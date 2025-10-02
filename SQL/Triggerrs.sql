-- EJS SOBRE STOCK. 
-- 1 Crear un trigger que ante cada fila insertada en la tabla Pedido_Producto modifique la tabla
-- IngresoStock_Producto restando de la columna cantidad de esta tabla la cantidad informada en
-- Pedido_Producto.

delimiter //
create trigger modificarStock after insert on pedido_producto for each row
begin
	update ingresostock_producto 
    join producto on ingresostock_producto.Producto_codProducto = producto.codProducto 
    join pedido_producto on producto.codProducto = pedido_producto.Producto_codProducto
    set ingresostock_producto.cantidad = ingresostock_producto.cantidad - pedido_producto.cantidad;
end //

select * from pedido_producto;
select * from ingresostock_producto;

insert into pedido_producto values(4, 2, 15.00, 1, 3);




