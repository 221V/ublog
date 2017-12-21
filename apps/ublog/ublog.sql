--DROP TABLE IF EXISTS test;
--CREATE TABLE "test" (
--  "id" serial,
--  "name" varchar(255) NOT NULL,
--  "population" integer,
--  PRIMARY KEY ("id")
--);
--INSERT INTO "test" ("name", "population") VALUES ('Київ', 2804000);
--INSERT INTO "test" ("name", "population") VALUES ('Львів', 723605);
--INSERT INTO "test" ("name", "population") VALUES ('Одеса', 997189);


DROP TABLE IF EXISTS u_users;
CREATE TABLE "u_users" (
  "id" bigserial NOT NULL,
  "nickname" varchar(255) NOT NULL,
  "email" varchar(255) NOT NULL,
  "password" varchar(255) NOT NULL,
  "status" smallint NOT NULL DEFAULT 1,
  --active: 1, banned: 2, deleted: 3
  "rating_total" integer NOT NULL DEFAULT 0,
  "language" varchar(2) NOT NULL DEFAULT 'uk',
  "inserted_at" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
  "updated_at" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
  PRIMARY KEY ("id")
);
INSERT INTO "u_users" (nickname, email, password) VALUES ('221V', '92remox92@gmail.com', 'C95137A5FAA2579CFC1C401AC2557D763DE32C0D700EB38311945DABBBF935DA8AF24808F428E1E4C0F38336EAF6886405CA21D7AB6393410E6A11719E034640');


DROP TABLE IF EXISTS u_posts;
CREATE TABLE "u_posts" (
  "id" bigserial NOT NULL,
  "author_id" bigint NOT NULL,
  -- references u_users id
  "title" varchar(255) NOT NULL,
  "preview_post" text NOT NULL,
  "post" text NOT NULL,
  "tags" array NOT NULL,
  -- references u_tags id (array)
  "is_translation" smallint NOT NULL DEFAULT 0,
  -- is_translation = 0 - no, 1 - yes
  "orig_post_id" bigint DEFAULT NULL,
  -- references u_posts id
  "orig_author_id" bigint DEFAULT NULL,
  -- references u_users id
  "orig_lang" varchar(2) DEFAULT NULL,
  "lang" varchar(2) NOT NULL DEFAULT 'uk',
  "rating_points" integer NOT NULL DEFAULT 0,
  "votes_count" hstore NOT NULL DEFAULT '"p5" => "0", "p4" => "0", "p3" => "0", "p2" => "0", "p1" => "0", "m1" => "0", "m2" => "0", "m3" => "0", "m4" => "0", "m5" => "0"',
  -- p5 - addition 5, m5 - subtraction 5
  "status" smallint NOT NULL DEFAULT 1,
  --show: 1, hide: 2, deleted: 3
  "inserted_at" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
  "updated_at" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
  PRIMARY KEY ("id")
);


DROP TABLE IF EXISTS u_tags;
CREATE TABLE "u_tags" (
  "id" bigserial NOT NULL,
  "author_id" bigint NOT NULL,
  -- references u_users id
  "name" varchar(255) NOT NULL,
  "status" smallint NOT NULL DEFAULT 1,
  --show: 1, hide: 2, deleted: 3
  "inserted_at" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
  "updated_at" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
  PRIMARY KEY ("id")
);


DROP TABLE IF EXISTS u_votes;
CREATE TABLE "u_votes" (
  "id" bigserial NOT NULL,
  "post_id" bigint NOT NULL,
  -- references u_posts id
  "author_id" bigint NOT NULL,
  -- references u_users id
  "vote" smallint NOT NULL,
  "updated_at" TIMESTAMP NOT NULL DEFAULT LOCALTIMESTAMP(0),
  PRIMARY KEY ("id")
);





