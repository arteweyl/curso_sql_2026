WITH RECURSIVE split(movie_id, idx, rest, token) AS (
  SELECT id, 0, COALESCE(credits,'') || '-', '' FROM raw_movies
  UNION ALL
  SELECT movie_id,
         idx+1,
         substr(rest, instr(rest,'-')+1),
         trim(substr(rest,1,instr(rest,'-')-1))
  FROM split
  WHERE rest <> ''
)
INSERT INTO people(name)
SELECT DISTINCT token
FROM split
WHERE token <> ''
  AND NOT EXISTS (SELECT 1 FROM people p WHERE p.name = split.token);