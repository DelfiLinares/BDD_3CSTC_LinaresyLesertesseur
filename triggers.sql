-- --------------------------- TRIGGERS ------------------------------- --
#1 Crear una tabla llamada customers_audit.
create table customers_audit (
	IdAut int auto_increment not null primary key,
    operacion char(6),
    User int,
    Last_date_modified date
    );
    
 #a 
#Definir un trigger que se dispare después de insertar en la tabla de customers y que
#inserte la información necesaria en customers_audit.

delimiter //
create trigger after_insert_information after insert on customers 
for each row
begin
	insert into customers_audit values (1, "insert", current_date(), new.customerName, new.customerNumber);
end //
delimiter ;

insert into customers values (1003,'Atelier graphique','Schmitt','Carine ','40.32.2555','54, rue Royale',NULL,'Nantes',NULL,'44000','France',1370,'21000.00');

#b

#Definir un trigger que se dispare antes de una modificación en la tabla customers que
#deje los datos antes de ser modificados en la tabla customers_audit.

delimiter // 
create trigger before_update_customer before update on customers 
for each row
begin
	insert into customers_audit values ("update", old.customerNumber, old.customerName);
end //

delimiter ;

UPDATE `classicmodels`.`customers` SET `contactLastName` = 'Castillo' WHERE (`customerNumber` = '124');
 
 
 
#c

# Definir un trigger que, antes de borrar una fila en la tabla de customers, inserte los
# datos anteriores en la tabla customes_audit.

delimiter //
create trigger before_delete_customers before delete on customers
for each row
begin
	insert into customers_audit values(old.customerNumber, old.customerName, old.contactLastName,
    old.contactFirstName, old.phone, old.addressLine1, old.addressLine2, old.city, old.state, 
    old.postalCode, old.country, old.salesRepEmployeeNumber, old.creditLimit);
end //
delimiter ; 

DELETE FROM `classicmodels`.`customers` WHERE (`customerNumber` = '129'); 

-- --------------------------------------------------------------------------------------------
#2 Hacer lo mismo con la tabla de empleados. Crear una tabla de auditoría que contenga los
# campos de la tabla employees más un id, operación, usuario y fecha de última modificación.
# Definir un trigger para cada operación de insert, delete y update sobre la tabla.

#Creamos tabla
create table employees_audit (
	IdAut int auto_increment not null primary key,
    operacion char(6),
    User int,
    Last_date_modified date,
    employee_Number int,
    last_Name varchar(50),
    first_Name varchar(50),
    extension varchar(10),
    email varchar(100),
    officinaCode varchar(10),
    reportsTo int,
    jobTitle varchar(50)
);

#Operacion insert 
delimiter //
create trigger insert_before_empleado before insert on employees
for each row
begin
	insert into employees_audit values(new.employeeNumber, new.lastName, new.firstName, new.extension, 
    new.email, new.officeCode, new.reportsTo, new.jobTitle);
end //
delimiter ;

delimiter //
create trigger insert_after_empleado after insert on employees
for each row
begin
	insert into employees_audit values(new.employeeNumber, new.lastName, new.firstName, new.extension, 
    new.email, new.officeCode, new.reportsTo, new.jobTitle);
end //
delimiter ;

-- ----------------------------------------------------------------------------------------------------------------------------

#Operacion update

delimiter //
create trigger update_after_empleado after update on employees
for each row
begin
	insert into employees_audit values(new.employeeNumber, new.lastName, new.firstName, new.extension, 
    new.email, new.officeCode, new.reportsTo, new.jobTitle);
end //
delimiter ;

#Operacion update

delimiter //
create trigger update_after_empleado after update on employees
for each row
begin
	insert into employees_audit values(old.employeeNumber, old.lastName, old.firstName, old.extension, 
    old.email, old.officeCode, old.reportsTo, old.jobTitle);
end //
delimiter ;


delimiter //
create trigger update_before_empleado before update on employees
for each row
begin
	insert into employees_audit values(new.employeeNumber, new.lastName, new.firstName, new.extension, 
    new.email, new.officeCode, new.reportsTo, new.jobTitle);
end //
delimiter ;

delimiter //
create trigger update_before_empleado before update on employees
for each row
begin
	insert into employees_audit values(old.employeeNumber, old.lastName, old.firstName, old.extension, 
    old.email, old.officeCode, old.reportsTo, old.jobTitle);
end //
delimiter ;

-- ------------------------------------------------------------------------------------------------------------------------
#Operacion delete

delimiter // 
create trigger delete_before_empleado before delete on employees
for each row
begin 
	insert into employees_audit values(old.employeeNumber, old.lastName, old.firstName, old.extension, 
    old.email, old.officeCode, old.reportsTo, old.jobTitle);
end //
delimiter ;


delimiter // 
create trigger delete_after_empleado after delete on employees
for each row
begin 
	insert into employees_audit values(old.employeeNumber, old.lastName, old.firstName, old.extension, 
    old.email, old.officeCode, old.reportsTo, old.jobTitle);
end //
delimiter ;

-- ------------------------------------------------------------------------------------------------------------------------
#3 Hacer un trigger que ante el intento de borrar un producto verifique que dicho producto
# no exista en las órdenes cuya orderDate sea menor a dos meses. Si existe debe tirar un
# error que diga “Error, tiene órdenes asociadas”.

delimiter //
create trigger before_verificar_producto before delete on producto
for each row
begin
		declare existencia bool default false;
		declare intervalo date default (current_date() - interval 2 month);
        declare textError text default "Error, tiene órdenes asociadas.";
        declare Comprobacion text default "El producto no es menor a 2 meses";
        
        if orderDate between intervalo and current_date then
			return textError;
        else 
			return Comprobacion;
	end if;
end //
delimiter ;


select current_date() - interval 2 month;