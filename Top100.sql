--1. Crear base de datos llamada películas
CREATE DATABASE movies;
\c movies; -- Se conecta a la base de datos movies
--2. Revisar los archivos peliculas.csv y reparto.csv para crear las tablas correspondientes, determinando la relación entre ambas tablas. 
CREATE TABLE movies_table(
    id INT, --Otra opción, si no trae el valor del id, sería usar "SERIAL" es un método que crea id's de forma automática y progresiva
    movies_column VARCHAR(255),
    year_premiere SMALLINT,
    director VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE reparto(
    id_movies INT,
    actor_o_actriz VARCHAR(255), 
    FOREIGN KEY (id_movies) REFERENCES movies_table(id)
);

--3. Cargar ambos archivos a su tabla correspondiente 
\copy movies_table FROM '/desktop/DesafioTop100/peliculas.csv' csv header;
\copy reparto FROM '/desktop/DesafioTop100/reparto.csv' csv;

--4. Listar todos los actores que aparecen en la película "Titanic".
SELECT movies_table.movies_column, movies_table.year_premiere, movies_table.director, reparto.year_premiere FROM movies_table 
INNER JOIN reparto 
ON movies_table.id = reparto.id_movies 
WHERE movies_column='Titanic';

--5. Listar los titulos de las películas donde actúe Harrison Ford.
SELECT movies_table.movies_column AS name_movie, reparto.actor_o_actriz FROM movies_table
INNER JOIN reparto
ON movies_table.id = reparto.id_movies
WHERE actor_o_actriz='Harrison Ford'; 

--6. Listar los 10 directores más populares (los que tienen más películas), indicando su nombre y cuántas películas aparecen en el top 100.
SELECT director, COUNT(*) AS quantity FROM movies_table GROUP BY director ORDER BY quantity DESC LIMIT 10;

--7. Indicar cuántos actores distintos hay
SELECT COUNT(DISTINCT actor_o_actriz) FROM reparto;

--8. Indicar las películas estrenadas entre los años 1990 y 1999 (ambos incluidos) ordenadas por título de manera ascendente.
SELECT year_premiere, movies_column FROM movies_table WHERE year_premiere>=1990 AND year_premiere<=1999 ORDER BY movies_column ASC; 
--BETWEEN 1990 AND 1999

--9. Listar el reparto de las películas lanzadas el año 2001.
SELECT movies_table.year_premiere, movies_table.movies_column, reparto.actor_o_actriz FROM reparto 
INNER JOIN movies_table  
ON movies_table.id = reparto.id_movies
WHERE year_premiere=2001;

--10. Listar los actores de la película más nueva.
SELECT movies_table.movies_column, movies_table.year_premiere, reparto.actor_o_actriz FROM reparto
INNER JOIN movies_table -- En este caso, en primera instancia no mostraba ni el nombre de la película ni el año y lo resolvimos juntando las tablas con INNER JOIN
ON movies_table.id = reparto.id_movies
WHERE id_movies IN 
    (SELECT id FROM movies_table
    ORDER BY year_premiere DESC LIMIT 1);

--COMANDOS IMPORTANTES:
-- \i Top100.sql; Con esta instrucción corro un archivo .sql en el terminal

-- \d = Lista las relaciones de las tablas

-- \du = Lista los roles

-- \h = Lista todos los comandos