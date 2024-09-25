function Get_my_active_cr_tickets()
	return vim.fn.system(
		"curl --location 'https://wcar-jira-test.riada.se/servicedesk/customer/user/requests?status=open' --header 'Authorization: Bearer MzAzMjU5ODYzMzY0Os8q/lT1DIMl18SB+xA5/+kyGTlV'"
	)
end

function Get_tickets_to_review()
	return vim.fn.system(
		"curl --location 'https://wcar-jira-test.riada.se/servicedesk/customer/user/approvals?approvalQueryType=myPending' --header 'Authorization: Bearer MzAzMjU5ODYzMzY0Os8q/lT1DIMl18SB+xA5/+kyGTlV'"
	)
end

function Get_ticket_specification(ticket_id)
	return vim.fn.system(
		"curl --location 'https://wcar-jira-test.riada.se/rest/servicedeskapi/request/"
			.. ticket_id
			.. "' --header 'Authorization: Bearer MzAzMjU5ODYzMzY0Os8q/lT1DIMl18SB+xA5/+kyGTlV'"
	)
end
