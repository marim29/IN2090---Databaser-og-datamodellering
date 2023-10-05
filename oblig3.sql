-- Oblig 3: Avansert SQL
-- Oppgave 1:
SELECT filmcharacter AS character, count(filmcharacter) AS count
FROM filmcharacter
GROUP BY character HAVING count(*)>2000 ORDER BY count desc;

-- Oppgave 2:
-- Filmtittel og produksjonsår for filmer som Stanley Kubrick har regissert:
-- 2a) v/bruk av INNER JOIN:
SELECT f.title, f.prodyear
FROM film AS f INNER JOIN filmparticipation AS fp USING
    (filmid) INNER JOIN person AS p USING (personid)
WHERE p.firstname = 'Stanley' AND
      p.lastname = 'Kubrick' AND fp.parttype = 'director';

-- 2b) v/bruk av NATURAL JOIN:
SELECT f.title, f.prodyear
FROM film AS f NATURAL JOIN filmparticipation AS fp
      NATURAL JOIN person AS p
WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick'
      AND fp.parttype = 'director';

-- 2c) v/bruk av implisitt join:
SELECT f.title, f.prodyear
FROM film AS f, filmparticipation AS fp, person AS p
WHERE f.filmid = fp.filmid AND fp.personid = p.personid AND p.firstname = 'Stanley'
      AND p.lastname = 'Kubrick' AND fp.parttype = 'director';

-- Oppgave 3:
-- Vurderte det som at jeg skulle ha med navnet på karakteren.
SELECT p.personid, p.firstname || ' ' || p.lastname AS name, fc.filmcharacter,
      f.title, c.country
FROM person AS p, filmcharacter AS fc, film AS f, filmcountry AS c,
      filmparticipation AS fp
WHERE p.personid = fp.personid AND fp.partid = fc.partid AND fp.filmid = f.filmid
      AND fp.filmid = c.filmid AND p.firstname = 'Ingrid'
      AND fc.filmcharacter = 'Ingrid';

-- Oppgave 4:
SELECT f.filmid, f.title, count(distinct genre)
FROM film AS f LEFT OUTER JOIN filmgenre AS g ON f.filmid = g.filmid
WHERE title like '%Antoine %' GROUP BY f.filmid, f.title;

-- Oppgave 5:
SELECT f.title, fp.parttype, count(parttype)
FROM film AS f, filmparticipation AS fp, filmitem AS fi
WHERE f.filmid = fp.filmid AND f.filmid = fi.filmid AND f.title LIKE
      '%Lord of the Rings%' AND fi.filmtype = 'C' GROUP BY f.title, fb.parttype;

-- Oppgave 6:
SELECT title, prodyear
FROM film
WHERE prodyear = (SELECT min(prodyear)
                  FROM film)
ORDER BY prodyear;

-- Oppgave 7:
WITH film1 as (
  SELECT f.title, f.prodyear
  FROM film AS f
  NATURAL JOIN filmgenre AS g
  WHERE g.genre = 'Film-Noir'),
  film2 as (
    SELECT f.title, f.prodyear
    FROM film AS f
    NATURAL JOIN filmgenre AS g
    WHERE g.genre = 'Comedy')
SELECT f1.title, f1.prodyear
FROM film1 as f1
INTERSECT (
  SELECT f2.title, f2.prodyear
  FROM film2 as f2);


-- Oppgave 8:
WITH film1 as (
  SELECT f.title, f.prodyear
  FROM film AS f
  NATURAL JOIN filmgenre AS g
  WHERE g.genre = 'Film-Noir'),
  film2 AS (
    SELECT f.title, f.prodyear
    FROM film AS f
    NATURAL JOIN filmgenre AS g
    WHERE g.genre = 'Comedy'),
    film3 AS (
      SELECT title, prodyear
      FROM film
      WHERE prodyear = (SELECT min(prodyear) FROM film)
      ORDER BY prodyear)
SELECT f1.title, f1.prodyear
FROM film1 as f1
INTERSECT (
  SELECT f2.title, f2.prodyear
  FROM film2 as f2)
  UNION (
    SELECT title, prodyear from film3);


-- Oppgave 9:
WITH director as (
  SELECT f.title, f.prodyear
  FROM film AS f
  INNER JOIN filmparticipation AS fp USING (filmid)
  INNER JOIN person AS p USING (personid)
  WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick'
      AND fp.parttype = 'director'),
      casting AS (
        SELECT f.title, f.prodyear
        FROM film AS f
        INNER JOIN filmparticipation AS fp USING (filmid)
        INNER JOIN person AS p USING (personid)
        WHERE p.firstname = 'Stanley' AND p.lastname = 'Kubrick'
            AND fp.parttype = 'cast')
  SELECT d.title, d.prodyear
  FROM director AS d
  INTERSECT (
    SELECT c.title, c.prodyear
    FROM casting AS c);


-- Oppgave 10:
WITH table1 AS (
  SELECT maintitle, rank
  FROM series
  INNER JOIN filmrating ON (seriesid = filmid)
  WHERE votes > 1000)
SELECT maintitle
FROM table1
WHERE rank = (SELECT max(rank) FROM table1);


-- Oppgave 11:
WITH country_info AS (
  SELECT country, count(country) AS c
  FROM filmcountry
  GROUP BY country)
SELECT country
FROM country_info WHERE c = 1;


-- Oppgave 12:
WITH film_character AS (
  SELECT filmcharacter, count(filmcharacter)
  FROM filmcharacter
  GROUP BY filmcharacter
  HAVING count(filmcharacter) = 1)
SELECT p.firstname || ' ' || p.lastname AS name, count(fp.filmid)
FROM person AS p
NATURAL JOIN filmparticipation AS fp
NATURAL JOIN filmcharacter as fc
INNER JOIN film_character ON (fc.filmcharacter = f.filmcharacter)
GROUP BY p.firstname, p.lastname
HAVING count(fp.filmid) > 199;


-- Oppgave 13:
WITH table1 AS (
  SELECT filmid, personid, rank
  FROM filmrating
  INNER JOIN filmparticipation using (filmid)
  WHERE votes > 60000 and parttype = 'director'),
  table2 AS (
    SELECT distinct personid
    FROM table1
    WHERE rank < 8),
    table3 AS (
      SELECT personid
      FROM table1
      EXCEPT (SELECT personid FROM table2))
SELECT firstname || ' ' || lastname AS name
FROM person
WHERE personid IN (SELECT personid FROM table3);
