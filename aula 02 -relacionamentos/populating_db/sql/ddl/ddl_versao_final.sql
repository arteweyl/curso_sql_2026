PRAGMA foreign_keys = ON;

-- dimensões / fatos
CREATE TABLE IF NOT EXISTS movies (
  id                INTEGER PRIMARY KEY,
  title             TEXT,
  original_language TEXT,
  overview          TEXT,
  release_date      TEXT,
  status            TEXT,
  tagline           TEXT,
  budget            INTEGER,
  revenue           INTEGER,
  runtime           INTEGER,
  popularity        REAL,
  vote_average      REAL,
  vote_count        INTEGER,
  poster_path       TEXT,
  backdrop_path     TEXT
);

CREATE TABLE IF NOT EXISTS genres (
  id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS people (
  id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_people_name ON people(name);

CREATE TABLE IF NOT EXISTS production_companies (
  id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS keywords (
  id      INTEGER PRIMARY KEY AUTOINCREMENT,
  keyword TEXT NOT NULL UNIQUE
);

-- pontes
CREATE TABLE IF NOT EXISTS movie_genres (
  movie_id INTEGER NOT NULL,
  genre_id INTEGER NOT NULL,
  PRIMARY KEY (movie_id, genre_id),
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
  FOREIGN KEY (genre_id) REFERENCES genres(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS movie_credits (
  movie_id     INTEGER NOT NULL,
  person_id    INTEGER NOT NULL,
  credit_order INTEGER,
  PRIMARY KEY (movie_id, person_id),
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
  FOREIGN KEY (person_id) REFERENCES people(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS movie_production_companies (
  movie_id   INTEGER NOT NULL,
  company_id INTEGER NOT NULL,
  PRIMARY KEY (movie_id, company_id),
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
  FOREIGN KEY (company_id) REFERENCES production_companies(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS movie_keywords (
  movie_id   INTEGER NOT NULL,
  keyword_id INTEGER NOT NULL,
  PRIMARY KEY (movie_id, keyword_id),
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
  FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS movie_recommendations (
  movie_id             INTEGER NOT NULL,
  recommended_movie_id INTEGER NOT NULL,
  PRIMARY KEY (movie_id, recommended_movie_id),
  FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE,
  FOREIGN KEY (recommended_movie_id) REFERENCES movies(id) ON DELETE CASCADE
);

-- índices úteis
CREATE INDEX IF NOT EXISTS idx_movies_release_date ON movies(release_date);
CREATE INDEX IF NOT EXISTS idx_movies_language     ON movies(original_language);
CREATE INDEX IF NOT EXISTS idx_movies_vote_average ON movies(vote_average);