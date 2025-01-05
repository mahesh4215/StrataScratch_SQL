write a query that will Identify returning active users by finding users who made a second purchase within 7 days of any previous purchase. Output a list of these user_ids.

Solution 1: 
SELECT DISTINCT t1.user_id
FROM amazon_transactions t1
JOIN amazon_transactions t2
ON t1.user_id = t2.user_id
   AND t1.created_at <= t2.created_at
   AND t1.id <> t2.id
   AND t2.created_at <= DATEADD(day, 6, t1.created_at)
ORDER BY t1.user_id;

Soltuion 2: 
SELECT user_id
FROM (
    SELECT 
        user_id, 
        created_at,
        DATEDIFF(day, LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at), created_at) AS prev_date
    FROM amazon_transactions
) AS a
WHERE prev_date <= 7
GROUP BY user_id;

Explanation: 
This SQL query identifies users who have made a second purchase within 7 days of their previous purchase. The goal is to find returning active users.
  
1.Subquery with LAG() Window Function:
The LAG() function is used to get the previous transaction date (prev_date) for each user based on the order of their transactions (created_at).
PARTITION BY user_id: This ensures that we calculate the previous purchase for each user separately.
ORDER BY created_at: This orders the transactions by date to ensure we're comparing each purchase with the previous one. 

2.The main query retrieves user_id from the subquery where the prev_date is less than or equal to 7 days (prev_date <= 7), which indicates that the user has made another purchase within the 7-day window.
The group by user_id ensures we get distinct user_id values of the users who meet the condition.
