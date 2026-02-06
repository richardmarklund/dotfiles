local Snacks = require 'snacks'

local M = {}

-- Resolve a sensible root for directory scanning
local function resolve_root(opts)
  -- 1) Neo-tree root if available (so reveal stays within tree)
  local ok_mgr, mgr = pcall(require, 'neo-tree.sources.manager')
  if ok_mgr then
    local state = mgr.get_state 'filesystem'
    if state and state.path and state.path ~= '' then
      return state.path
    end
  end

  -- 2) Current buffer's directory
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname and bufname ~= '' then
    local buf_dir = vim.fn.fnamemodify(bufname, ':p:h')
    if buf_dir and buf_dir ~= '' then
      return buf_dir
    end
  end

  -- 3) Editor working directory
  local cwd = (opts and opts.cwd) or vim.fn.getcwd()
  return cwd
end

-- Collect directories using fast uv scanning with a depth limit
local function collect_dirs_uv(root, max_depth)
  local results = {}
  local uv = vim.loop

  local function scan_dir(path, depth)
    if depth > max_depth then
      return
    end
    local fd = uv.fs_scandir(path)
    if not fd then
      return
    end
    while true do
      local name, t = uv.fs_scandir_next(fd)
      if not name then
        break
      end
      if t == 'directory' then
        local full = path .. '/' .. name
        table.insert(results, full)
        scan_dir(full, depth + 1)
      end
    end
  end

  scan_dir(root, 1)
  return results
end

-- Snacks picker to search directories and reveal selection in Neo-tree
function M.search_folders(opts)
  opts = opts or {}

  local root = resolve_root(opts)
  local depth = opts.depth or 15

  -- First try plenary.scandir (respects .gitignore), then fallback to uv walk
  local results = {}
  local ok_scan, scan = pcall(require, 'plenary.scandir')
  if ok_scan then
    local ok_list, list = pcall(scan.scan_dir, root, {
      hidden = true,
      depth = depth,
      only_dirs = true,
      respect_gitignore = true,
    })
    if ok_list and type(list) == 'table' and #list > 0 then
      results = list
    end
  end
  if #results == 0 then
    results = collect_dirs_uv(root, depth)
  end

  if #results == 0 then
    vim.notify('No directories found under: ' .. root, vim.log.levels.WARN)
  end

  local items = {}
  for _, path in ipairs(results) do
    local rel = vim.fs.normalize(vim.fs.relpath(path, root) or path)
    items[#items + 1] = { file = path, text = rel }
  end

  local function reveal(path)
    local ok_cmd, nt_cmd = pcall(require, 'neo-tree.command')
    if ok_cmd then
      nt_cmd.execute {
        source = 'filesystem',
        position = 'left',
        reveal = true,
        reveal_file = path,
        reveal_force_cwd = false,
        toggle = false,
      }
      return
    end

    local escaped = vim.fn.fnameescape(path)
    vim.cmd('Neotree reveal=true reveal_file=' .. escaped .. ' reveal_force_cwd=false position=left')
  end

  Snacks.picker {
    source = 'folders',
    prompt = 'Search Folders (' .. root .. ')',
    items = items,
    format = 'file',
    win = { preview = { hidden = true } },
    sort = { fields = { 'text' } },
    confirm = function(picker, item)
      picker:close()
      if not item or not item.file then
        return
      end
      reveal(item.file)
    end,
  }
end

return M
