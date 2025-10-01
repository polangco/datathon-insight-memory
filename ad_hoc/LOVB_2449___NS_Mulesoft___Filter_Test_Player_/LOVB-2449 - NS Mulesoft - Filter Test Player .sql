-- check for instances of test in the invoices details report
-- exclude any cases where we see test or player in the player or user name
-- based on exploring the data there are exception cases
	-- Testa family - see registrations
	-- Testerman family - do not see registrations, but are in the players data with nothing to suggest it's a test account
	-- Nettestad family - do not see registrations, but are in the players data with nothing to suggest it's a test account
SELECT
	*
FROM
	public.sprocket_invoice_details
WHERE
	NOT (
		("player_name" || "user_name" ~* 'test|player') -- look for any instance of test or player in player or user name
		AND NOT "player_name" || "user_name" ~ '^Testa|^Testerman|^Nettestad' -- exclude these specific valid last names 
	)
;