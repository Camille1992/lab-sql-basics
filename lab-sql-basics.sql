# Query 1
# Get the id values of the first 5 clients from district_id with a value equals to 1.
SELECT 
	CLIENT_ID, DISTRICT_ID 
FROM 
	CLIENT 
WHERE 
	DISTRICT_ID REGEXP "^1$" 
ORDER BY 
	CLIENT_ID ASC 
LIMIT 
	5;
    
# Query 2
# In the client table, get an id value of the last client where the district_id equals to 72.

SELECT * 
FROM 
	CLIENT 
WHERE 
	DISTRICT_ID = "72" 
ORDER BY 
	CLIENT_ID DESC 
LIMIT 
	1;

# Query 3
# Get the 3 lowest amounts in the loan table.
SELECT * 
FROM 
	LOAN 
ORDER BY 
	AMOUNT ASC 
LIMIT 
	3;

# Query 4
# What are the possible values for status, ordered alphabetically in ascending order in the loan table?
SELECT DISTINCT 
	STATUS 
FROM 
	LOAN 
ORDER BY 
	STATUS ASC;

# Query 5
# What is the loan_id of the highest payment received in the loan table?
SELECT 
	LOAN_ID, PAYMENTS 
FROM 
	LOAN 
ORDER BY 
	PAYMENTS DESC 
LIMIT 
	1;
# 6415 is the right answer

# Query 6
# What is the loan amount of the lowest 5 account_ids in the loan table? Show the account_id and the corresponding amount
SELECT 
	AMOUNT, ACCOUNT_ID 
FROM 
	LOAN 
ORDER BY 
	ACCOUNT_ID ASC 
LIMIT 
	5;

# Query 7
# What are the account_ids with the lowest loan amount that have a loan duration of 60 in the loan table?
SELECT 
	ACCOUNT_ID, AMOUNT, DURATION
FROM 
	LOAN 
WHERE 
	DURATION = 60
ORDER BY 
	AMOUNT ASC
LIMIT
	5;

# Query 8
# What are the unique values of k_symbol in the order table?
# Note: There shouldn't be a table name order, since order is reserved from the ORDER BY clause. 
# You have to use backticks to escape the order table name.
SELECT DISTINCT 
	K_SYMBOL 
FROM 
	`ORDER`
WHERE
	K_SYMBOL != ""
ORDER BY
	K_SYMBOL ASC;

# Query 9
# In the order table, what are the order_ids of the client with the account_id 34?
SELECT 
	ORDER_ID 
FROM 
	`ORDER` 
WHERE 
	ACCOUNT_ID = "34";

#Query 10
# In the order table, which account_ids were responsible for orders between order_id 29540 and order_id 29560 (inclusive)?
SELECT DISTINCT 
	ACCOUNT_ID 
FROM 
	BANK.ORDER 
WHERE 
	ORDER_ID BETWEEN 29540 AND 29560;

# Query 11
# In the order table, what are the individual amounts that were sent to (account_to) id 30067122?
SELECT 
	AMOUNT 
FROM 
	BANK.ORDER 
WHERE 
	ACCOUNT_TO = "30067122";

# Query 12
# In the trans table, show the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, 
# from newest to oldest.
SELECT 
	TRANS_ID, DATE, TYPE, AMOUNT 
FROM 
	TRANS 
WHERE 
	ACCOUNT_ID = "793" 
ORDER BY 
	DATE DESC 
LIMIT 
	10;

# Query 13
# In the client table, of all districts with a district_id lower than 10, 
# how many clients are from each district_id? Show the results sorted by the district_id in ascending order.
SELECT 
	DISTRICT_ID, COUNT(CLIENT_ID) AS number_of_clients
FROM 
	CLIENT 
WHERE 
	DISTRICT_ID < 10 
GROUP BY 
	DISTRICT_ID 
ORDER BY 
	DISTRICT_ID ASC;
    
# Query 14
# In the card table, how many cards exist for each type? Rank the result starting with the most frequent type.
SELECT 
	TYPE, COUNT(CARD_ID) AS number_of_cards
FROM
	CARD
GROUP BY
	TYPE
ORDER BY
	COUNT(TYPE) DESC;

# Query 15
# Using the loan table, print the top 10 account_ids based on the sum of all of their loan amounts.
SELECT 
	ACCOUNT_ID, SUM(AMOUNT) AS total_amount
FROM
	LOAN
GROUP BY
	ACCOUNT_ID
ORDER BY
	SUM(AMOUNT) DESC
LIMIT
	10;
	
# Query 16
# In the loan table, retrieve the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
SELECT
	DATE, COUNT(LOAN_ID)
FROM
	LOAN
WHERE
	DATE < 930907
GROUP BY
	DATE
ORDER BY
	DATE DESC;

# Query 17
# In the loan table, for each day in December 1997, count the number of loans issued for each unique loan duration, ordered by date and duration, both in ascending order. 
# You can ignore days without any loans in your output.
SELECT * 
FROM 
	LOAN;
SELECT
	DURATION, DATE, COUNT(LOAN_ID)
FROM
	LOAN
WHERE
	DATE REGEXP "^9712"
GROUP BY
	DURATION
ORDER BY
	DATE, DURATION ASC;
# not the same as the expected result but they didn't group by duration??? so they're not showing the number per unique loan duration. So I think mine is the correct one.
    
#Query 18
# In the trans table, for account_id 396, sum the amount of transactions for each type (VYDAJ = Outgoing, PRIJEM = Incoming). NUMBER OF TRANSACTIONS OR SUM OF THE AMOUNT FOR EACH TYPE ???
# Your output should have the account_id, the type and the sum of amount, named as total_amount. Sort alphabetically by type.
# SUM OF THE AMOUNT FOR EACH TYPE:
SELECT
	ACCOUNT_ID, TYPE, ROUND(SUM(AMOUNT), 0) AS total_amount
FROM
	TRANS
WHERE
	ACCOUNT_ID = 396
GROUP BY
	TYPE
ORDER BY
	TYPE ASC;

# Query 19
# From the previous output, translate the values for type to English, rename the column to transaction_type, round total_amount down to an integer   
SELECT
	ACCOUNT_ID, 
		CASE
			WHEN TYPE = "PRIJEM" THEN "INCOMING"
            WHEN TYPE = "VYDAJ" THEN "OUTGOING"
		END AS TYPE,
    ROUND(SUM(AMOUNT), 0) AS total_amount
FROM
	TRANS
WHERE
	ACCOUNT_ID = 396
GROUP BY
	TYPE
ORDER BY
	TYPE ASC;
    
# Query 20
# From the previous result, modify your query so that it returns only one row, with a column for incoming amount, outgoing amount and the difference.
SELECT
	ACCOUNT_ID,
    ROUND(SUM(CASE
				WHEN TYPE = "PRIJEM" THEN AMOUNT
                ELSE 0
			END)) AS Incoming,
	 ROUND(SUM(CASE
				WHEN TYPE = "VYDAJ" THEN AMOUNT
                ELSE 0
			END)) AS Outgoing,
	ROUND(SUM(CASE
				WHEN TYPE = "PRIJEM" THEN AMOUNT
				WHEN TYPE = "VYDAJ" THEN -AMOUNT
                ELSE 0
			END)) AS Difference
FROM
	TRANS
WHERE
	ACCOUNT_ID = 396
ORDER BY
	TYPE ASC; 

# Query 21
# Continuing with the previous example, rank the top 10 account_ids based on their difference.
SELECT
	ACCOUNT_ID,
    ROUND(SUM(CASE
				WHEN TYPE = "PRIJEM" THEN AMOUNT
                ELSE 0
			END)) AS Incoming,
	 ROUND(SUM(CASE
				WHEN TYPE = "VYDAJ" THEN AMOUNT
                ELSE 0
			END)) AS Outgoing,
	ROUND(SUM(CASE
				WHEN TYPE = "PRIJEM" THEN AMOUNT
				WHEN TYPE = "VYDAJ" THEN -AMOUNT
                ELSE 0
			END)) AS Difference
FROM
	TRANS
GROUP BY
	ACCOUNT_ID
ORDER BY
	difference DESC
LIMIT
	10; 


