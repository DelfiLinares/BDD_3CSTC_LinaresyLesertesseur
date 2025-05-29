-- EJERCICIOS EVENTOS
-- 1:  Crear un evento que se ejecute diariamente y cambie el estado de los pedidos cuya
-- fecha de entrega ya pasó pero aún están marcados como "In Process" a "Delayed"

delimiter //
create event estadoPedido on schedule every 1 day starts now() do
begin
		update orders set status = "Cancelled" where status = "In process"
		and shippedDate < current_date();
end//
delimiter ;

select * from orders where year(shippedDate) = 2025;
select * from orders where shippedDate > "2003-01-10" ;
select * from orders where status = "In process";

select orderNumber from orders where status = "In process"
and shippedDate < current_date();

update orders set status = "Cancelled" where status = "In process"
and shippedDate < current_date();

-- 2: Crear un evento que cada mes elimine los pagos realizados hace más de 5 años.

delimiter //
create event eliminarPagos on schedule every 1 month starts now() do
begin 
	delete from payments where paymentDate > subdate(current_date(),interval 5 year);
end//
delimiter ;

select * from payments;
select * from payments where paymentDate > subdate(current_date(),interval 30 year)
order by paymentDate desc;

-- 3: 
-- Crea un evento que cada mes identifique a los clientes que han realizado más de 10
-- pedidos en el último año y les agregue un 10% de crédito extra en creditLimit. Esto se
-- debe realizar hasta el año que viene.

delimiter //
create event clientesFrecuentes on schedule every 1 month starts now() do
begin
	
end//
delimiter ;

select * from customers ;