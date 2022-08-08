-- Eliminar la base de datos si es que ya existía
drop database if exists telovendo_nueva;

-- Crear la base de datos
create database telovendo_nueva;

-- Usar la base de datos nueva
use telovendo_nueva;

-- Eliminar el usuario "sprint" si ya existía
drop user if exists sprint;

-- Crear usuario con privilegios 
CREATE USER 'sprint' IDENTIFIED BY '1234';
GRANT INSERT, UPDATE, DELETE, SELECT, CREATE ON telovendo_nueva.* TO 'sprint' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Crear tabla Proveedores
create table proveedores (
	id int primary key auto_increment,
    nombre_corporativo varchar(50),
	nombre_representante_legal varchar(50),
    telefono_1 varchar(12),
    telefono_2 varchar(12),
    nombre_contacto varchar(50),
    categoria_productos varchar(50),
    email varchar(50)
);

-- Agregar data a Proveedores
insert into proveedores values(null, 'Stabilo', 'Sady Maureira', '+56900000001', '+72200000001', 'Pedro Pablo Pérez Pereira', 'Librería', 'contacto@stabilo.com');
insert into proveedores values(null, 'Somela', 'Fernando Torrejón', '+56900000002', '+72200000002', 'Arturo Ruiz-Tagle', 'Electrohogar', 'contacto@somela.com');
insert into proveedores values(null, 'DIB', 'Gabriela Santander', '+56900000003', '+72200000003', 'Carolina Arregui', 'Decohogar', 'contacto@dib.com');
insert into proveedores values(null, 'Tolix', 'Andrea Sepúlveda', '+56900000004', '+72200000004', 'Joaquín De La Maza', 'Iluminación', 'contacto@tolix.com');
insert into proveedores values(null, 'Torre', 'Juan Torres', '+56900000005', '+72200000005', 'Alexis Gómez', 'Librería', 'contacto@torre.com');

-- Crear tabla Clientes
create table clientes (
  id INT NOT NULL AUTO_INCREMENT,
  nombre varchar(45) NULL,
  apellido varchar(45) NULL,
  direccion varchar(45) NULL,
  PRIMARY KEY (id)
);

-- Insertar data en Clientes
insert into clientes values (null, 'Ana', 'Pérez', 'Calle del Agua 43');
insert into clientes values (null, 'Isabel', 'Allendes', 'Calle del Agua 44');
insert into clientes values (null, 'Lorena', 'Polanco', 'Arlegui 53');
insert into clientes values (null, 'Paola', 'Pizarro', 'Calle del sol 44');
insert into clientes values (null, 'Daniela', 'Contreras', 'Prat 43');

-- Crear tabla de Productos
CREATE TABLE productos (
  sku int not null auto_increment,
  nombre varchar(50) DEFAULT NULL,
  precio int DEFAULT NULL,
  categoria varchar(50) DEFAULT NULL,
  color varchar(50) DEFAULT NULL,
  stock int DEFAULT NULL,
  proveedor_id int DEFAULT NULL,
  PRIMARY KEY (sku),
  FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

-- Insertar data en Productos
insert into productos values (null, 'Lápiz Kiss', 300, 'Librería', 'Azul', 300, 1);
insert into productos values (null, 'Lampara Tolix', 75000, 'Iluminación', 'Verde', 20, 4);
insert into productos values (null, 'Aspiradora', 76000, 'Electrohogar', 'Rojo', 23, 2);
insert into productos values (null, 'Alfombra Tribal', 45000, 'Decohogar', 'Multicolor', 8, 3);
insert into productos values (null, 'Cuadernos Mandala', 2500, 'Librería', 'Multicolor', 300, 5);
insert into productos values (null, 'Libreta Kawaii', 4500, 'Librería', 'Multicolor', 200, 5);
insert into productos values (null, 'Lápiz Pez', 1350, 'Librería', 'Negro', 700, 5);
insert into productos values (null, 'Batidora', 30000, 'Electrohogar', 'Blanco', 7, 2);
insert into productos values (null, 'Velador DJN', 78000, 'Decohogar', 'Madera', 16, 3);
insert into productos values (null, 'Lámpara Solar', 9500, 'Decohogar', 'Amarillo', 6, 4);

-- Categoría que más se repite en productos
select categoria, count(categoria) as total from productos
group by categoria order by total desc limit 1;

-- Productos con mayor stock
select * from productos order by stock desc limit 3;

-- Color más común
select color, count(color) as total from productos
group by color order by total desc limit 1;

-- Proveedor con menor stock
select prov.nombre_corporativo, prod.proveedor_id, prod.categoria, prod.stock
from productos as prod
inner join proveedores as prov
on prov.id=prod.proveedor_id
where stock = (select min(stock) from productos);

-- Asignar la categoría más repetida
set @categoriaMasRepetida = (
	select nombre from (
		select categoria as nombre, count(categoria) as total_productos from productos
		group by categoria order by total_productos desc limit 1
	) as categoriaMasRepetida
);

-- Probar si es la categoría más repetida
select @categoriaMasRepetida;

-- Desactivar modo seguro para poder actualizar
set SQL_SAFE_UPDATES = false;

-- Actualizar la categoría más popular por Electrónica y Computación
update productos set categoria = 'Electrónica y Computación'
where categoria = @categoriaMasRepetida;

-- Volver a activar modo seguro
set SQL_SAFE_UPDATES = true;

-- Verificar si se ejecutó exitosamente
select * from productos;