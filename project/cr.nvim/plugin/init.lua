require("CrClient")
require("TicketUtil")
JSON = require("JSON")

--[[        self.insight_input_data = {
            APPROVER: "AA100581",
            SUMMARY: "Update the service to handle incoming cars in batches.",
            RISK_DESCRIPTION: "If not properly handled the batches can become too big.",
            DESCRIPTION: "This change is long overdue and will improve perfomance!",
            RISK_IMPACT: 2,
            RISK_PROBABILITY: 3,
            CONTINGENCY_PLAN: "Roll back to previous version as fast as possible.",
            START_DATE: datetime.fromisoformat("2021-07-05T11:05:31.123456"),
            AFFECTED_PROGRAMS: ["All"],
            SERVICE_INSIGHT: "ITSM-24920",
            ENVIRONMENTS_INSIGHT: ["ITSM-38012", "ITSM-38013"],
        }]]
--

function ShowMenu(title, opts, cb)
	vim.ui.select(opts, {
		prompt = title,
		format_item = function(item)
			return item.id .. " | " .. item.summary .. " | " .. item.status
		end,
	}, function(choice) end)
end

function OpenMyActiveTickets()
	local opts = Get_ticket_table(Get_my_active_cr_tickets())
	local cb = function(_, sel) end
	ShowMenu("My active tickets", opts, cb)
end

function OpenTicketsToReview()
	local opts = Get_ticket_table(Get_tickets_to_review())
	local cb = function(_, sel) end
	ShowMenu("Tickets to review", opts, cb)
end

function InsightChangeRequestData(input_data)
	return JSON:encode({
		serviceDesktopId = 2,
		requestTypeId = 329,
		requestFieldValues = {
			summary = input_data.summary,
			description = input_data.description,
			customfield_13313 = os.date("%Y-%m-%dT%H:%M:%S.000+0000"),
			customfield_13312 = os.date("%Y-%m-%dT%H:%M:%S.000+0000", (os.time() + input_data.hours * 60 * 60)),
			customfield_13704 = "rollback",
			customfield_13307 = input_data.approver,
			customfield_13707 = "No", -- Other programs affected
			customfield_13810 = "Green Risk Change Checker (Risk Level 1-5)",
			customfield_13700 = "Low",
			customfield_13701 = input_data.risk_impact,
			customfield_13702 = input_data.risk_probability,
			customfield_13718 = input_data.vw_mod4_service,
			customfield_13904 = input_data.vw_mod4_environments, -- not used?
			customfield_14606 = input_data.service_insight,
			customfield_16201 = { key = "ALL" },
		},
	})
end

function CreateChangeRequestWindow()
	vim.cmd("tabnew")
	vim.api.nvim_buf_set_lines(
		0,
		0,
		4,
		false,
		{ "Summary: ", "Description: ", "Risk impact: ", "Risk probability: ", "Service: " }
	)
	vim.api.nvim_buf_set_name(0, "change request")
end

CreateChangeRequestWindow()
