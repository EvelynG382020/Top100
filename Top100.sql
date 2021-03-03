--1. Crear base de datos llamada películas
CREATE DATABASE peliculas;
\c peliculas; -- Se conecta a la base de datos peliculas
--2. Revisar los archivos peliculas.csv y reparto.csv para crear las tablas correspondientes, determinando la relación entre ambas tablas. 
CREATE TABLE peliculas(
    id INT, --Otra opción, si no trae el valor del id, sería usar "SERIAL" es un método que crea id's de forma automática y progresiva
    pelicula VARCHAR(255),
    ano_de_estreno SMALLINT,
    director VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE reparto(
    id_peliculas INT,
    actor_o_actriz VARCHAR(255), 
    FOREIGN KEY (id_peliculas) REFERENCES peliculas(id)
);

--3. Cargar ambos archivos a su tabla correspondiente 
\copy peliculas FROM '/desktop/DesafioTop100/peliculas.csv' csv header;
\copy reparto FROM '/desktop/DesafioTop100/reparto.csv' csv;

--4. Listar todos los actores que aparecen en la película "Titanic".
SELECT peliculas.pelicula, peliculas.ano_de_estreno, peliculas.director, reparto.actor_o_actriz FROM peliculas 
INNER JOIN reparto 
ON peliculas.id = reparto.id_peliculas 
WHERE pelicula='Titanic';

--5. Listar los titulos de las películas donde actúe Harrison Ford.
SELECT peliculas.pelicula AS nombre_pelicula, reparto.actor_o_actriz FROM peliculas
INNER JOIN reparto
ON peliculas.id = reparto.id_peliculas
WHERE actor_o_actriz='Harrison Ford'; 

--6. Listar los 10 directores más populares (los que tienen más películas), indicando su nombre y cuántas películas aparecen en el top 100.
SELECT director, COUNT(*) AS cantidad FROM peliculas GROUP BY director ORDER BY cantidad DESC LIMIT 10;

--7. Indicar cuántos actores distintos hay
SELECT COUNT(DISTINCT actor_o_actriz) FROM reparto;

--8. Indicar las películas estrenadas entre los años 1990 y 1999 (ambos incluidos) ordenadas por título de manera ascendente.
SELECT ano_de_estreno, pelicula FROM peliculas WHERE ano_de_estreno>=1990 AND ano_de_estreno<=1999 ORDER BY pelicula ASC; 

--9. Listar el reparto de las películas lanzadas el año 2001.
SELECT peliculas.ano_de_estreno, peliculas.pelicula, reparto.actor_o_actriz FROM reparto 
INNER JOIN peliculas  
ON peliculas.id = reparto.id_peliculas
WHERE ano_de_estreno=2001;

--10. Listar los actores de la película más nueva.
SELECT peliculas.pelicula, peliculas.ano_de_estreno, reparto.actor_o_actriz FROM reparto
INNER JOIN peliculas -- En este caso, en primera instancia no mostraba ni el nombre de la película ni el año y lo resolvimos juntando las tablas con INNER JOIN
ON peliculas.id = reparto.id_peliculas
WHERE id_peliculas IN 
    (SELECT id FROM peliculas
    ORDER BY ano_de_estreno DESC LIMIT 1);

--COMANDOS IMPORTANTES:
-- \i Top100.sql; Con esta instrucción corro un archivo .sql en el terminal

-- \d = Lista las relaciones de las tablas

-- \du = Lista los roles

-- \h = Lista todos los comandos