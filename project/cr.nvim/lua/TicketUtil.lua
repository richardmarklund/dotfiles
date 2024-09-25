local function get_summary(body)
	local _, Summary_start = string.find(body, "summary", 1)
	if Summary_start == nil then
		return
	end
	local Summary_body = string.sub(body, Summary_start + 3, Summary_start + 100)
	local _, Summary_ends = string.find(Summary_body, '",', 1)
	local summary = string.sub(Summary_body, 2, Summary_ends - 2)
	return summary
end

local function get_status(body)
	local _, status_start = string.find(body, "status", 1)
	if status_start == nil then
		return
	end
	local status_body = string.sub(body, status_start + 3, status_start + 100)
	local _, status_ends = string.find(status_body, '",', 1)
	local status = string.sub(status_body, 2, status_ends - 2)
	if status == "Peer review / change manager approval" then
		status = "Review"
	end
	return status
end

function Get_ticket_table(ticket_data)
	local tickets = {}
	while true do
		local start, ends = string.find(ticket_data, "WCAR-", 1, true)

		if start == nil or ends == nil then
			break
		end

		local substring = string.sub(ticket_data, ends + 1, ends + 10)
		local number = string.find(substring, '"', 1)
		local id = "WCAR-" .. string.sub(substring, 0, number - 1)
		local status = get_status(string.sub(ticket_data, start, string.len(ticket_data)))
		local summary = get_summary(string.sub(ticket_data, start, string.len(ticket_data)))
		table.insert(tickets, 1, { id = id, summary = summary, status = status })
		ticket_data = string.sub(ticket_data, ends, string.len(ticket_data))
	end
	return tickets
end
