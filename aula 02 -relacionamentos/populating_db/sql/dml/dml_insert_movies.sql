INSERT INTO movies (
  id, title, original_language, overview, release_date, status, tagline,
  budget, revenue, runtime, popularity, vote_average, vote_count,
  poster_path, backdrop_path
)
SELECT
  r.id,
  r.title,
  r.original_language,
  r.overview,
  r.release_date,
  r.status,
  r.tagline,
  r.budget,
  r.revenue,
  r.runtime,
  r.popularity,
  r.vote_average,
  r.vote_count,
  r.poster_path,
  r.backdrop_path
FROM raw_movies r
WHERE NOT EXISTS (
  SELECT 1
  FROM movies m
  WHERE m.id = r.id
);