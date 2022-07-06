/* SAMPLE 8 CUSTOMERS AND ANALYZE THEIR ONBOARDING JOURNEY*/

SELECT s.customer_id, s.plan_id, s.start_date, p.plan_name, p.price
FROM foodie_fi.subscriptions s
JOIN foodie_fi.plan p
ON s.plan_id = p.plan_id
WHERE s.customer_id IN (1,2,3,4,5,7,9,11)

/* 
customer_id 1: Started 7-days free trial plan on Aug-2020 and continued using the basic monthly pro service after trial
customer_id 2: Onboared using the free trial and subscribed to basic monthly package thereafter until 21-april-21
customer_id 7: similar to cid2, cid 7 onboarded via the free trial on 5th Feb, then continued with the basic monthly plan and then upgraded to pro plan on 22nd May.

 */