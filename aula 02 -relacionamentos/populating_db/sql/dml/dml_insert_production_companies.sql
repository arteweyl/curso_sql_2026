-- DIM production_companies
WITH RECURSIVE split(movie_id, rest, token) AS (
  SELECT id, COALESCE(production_companies,'') || '-', '' FROM raw_movies
  UNION ALL
  SELECT movie_id,
         substr(rest, instr(rest,'-')+1),
         trim(substr(rest,1,instr(rest,'-')-1))
  FROM split
  WHERE rest <> ''
)
INSERT OR IGNORE INTO production_companies(name)
SELECT DISTINCT token
FROM split
WHERE token <> '';

-- BRIDGE movie_production_companies
WITH RECURSIVE split(movie_id, rest, token) AS (
  SELECT id, COALESCE(production_companies,'') || '-', '' FROM raw_movies
  UNION ALL
  SELECT movie_id,
         substr(rest, instr(rest,'-')+1),
         trim(substr(rest,1,instr(rest,'-')-1))
  FROM split
  WHERE rest <> ''
)
INSERT OR IGNORE INTO movie_production_companies(movie_id, company_id)
SELECT s.movie_id, c.id
FROM split s
JOIN production_companies c ON c.name = s.token
WHERE s.token <> ''
  AND EXISTS (SELECT 1 FROM movies m WHERE m.id = s.movie_id);