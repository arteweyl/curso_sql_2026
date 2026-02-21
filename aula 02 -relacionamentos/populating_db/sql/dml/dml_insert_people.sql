-- DIM people
WITH RECURSIVE split(movie_id, idx, rest, token) AS (
  SELECT id, 0, COALESCE(credits,'') || '-', '' FROM raw_movies
  UNION ALL
  SELECT movie_id,
         idx + 1,
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

-- BRIDGE movie_credits
WITH RECURSIVE split(movie_id, idx, rest, token) AS (
  SELECT id, 0, COALESCE(credits,'') || '-', '' FROM raw_movies
  UNION ALL
  SELECT movie_id,
         idx + 1,
         substr(rest, instr(rest,'-')+1),
         trim(substr(rest,1,instr(rest,'-')-1))
  FROM split
  WHERE rest <> ''
)
INSERT OR IGNORE INTO movie_credits(movie_id, person_id, credit_order)
SELECT s.movie_id, p.id, s.idx
FROM split s
JOIN people p ON p.name = s.token
WHERE s.token <> ''
  AND EXISTS (SELECT 1 FROM movies m WHERE m.id = s.movie_id);