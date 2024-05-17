-- 1. Количество заказов за все время
SELECT COUNT(*) AS "Количество заказов"
	FROM public.orders;

-- 2. Сумма по всем заказам за все время (учитывая скидки)
SELECT CAST(SUM(unit_price * quantity * (1 - discount)) as numeric(15,2)) as "Сумма по заказам"
	FROM public.order_details;

-- 3. Количество сотрудников по городам.
SELECT city, COUNT(*) as "Количество сотрудников"
	FROM public.employees
	GROUP BY city;

-- 4. Выявить самый продаваемый товар в штуках. Вывести имя продукта и его количество.
SELECT pr.product_name, qty.total_quantity
FROM public.products pr
JOIN (
	SELECT product_id, SUM(quantity) AS total_quantity
	FROM public.order_details
	GROUP BY product_id
	ORDER BY total_quantity DESC
	LIMIT 1
) qty on pr.product_id = qty.product_id;

-- 5. Выявить ФИО сотрудника, у которого сумма всех заказов самая маленькая.
SELECT last_name, first_name, title_of_courtesy, 
	CAST(tot_sum.sum AS numeric(15,2)) AS "Сумма заказов"
FROM public.employees emp
JOIN (
    SELECT ord.employee_id, SUM(ord_sum.total_sum)
    FROM public.orders ord
    JOIN (
        SELECT order_id, SUM(unit_price * quantity * (1 - discount)) AS "total_sum"
        FROM public.order_details
        GROUP BY order_id
    ) ord_sum ON ord.order_id = ord_sum.order_id
    GROUP BY ord.employee_id
) tot_sum ON emp.employee_id = tot_sum.employee_id
ORDER BY tot_sum.sum ASC
LIMIT 1;