-- DIM keywords
WITH RECURSIVE split(movie_id, rest, token) AS (
  SELECT id, COALESCE(keywords,'') || '-', '' FROM raw_movies
  UNION ALL
  SELECT movie_id,
         substr(rest, instr(rest,'-')+1),
         trim(substr(rest,1,instr(rest,'-')-1))
  FROM split
  WHERE rest <> ''
)
INSERT OR IGNORE INTO keywords(keyword)
SELECT DISTINCT token
FROM split
WHERE token <> '';

-- BRIDGE movie_keywords
WITH RECURSIVE split(movie_id, rest, token) AS (
  SELECT id, COALESCE(keywords,'') || '-', '' FROM raw_movies
  UNION ALL
  SELECT movie_id,
         substr(rest, instr(rest,'-')+1),
         trim(substr(rest,1,instr(rest,'-')-1))
  FROM split
  WHERE rest <> ''
)
INSERT OR IGNORE INTO movie_keywords(movie_id, keyword_id)
SELECT s.movie_id, k.id
FROM split s
JOIN keywords k ON k.keyword = s.token
WHERE s.token <> ''
  AND EXISTS (SELECT 1 FROM movies m WHERE m.id = s.movie_id);