DROP TABLE IF EXISTS test;
CREATE TABLE "test" (
  "id" serial,
  "name" varchar(255) NOT NULL,
  "population" integer,
  PRIMARY KEY ("id")
);
INSERT INTO "test" ("name", "population") VALUES ('Київ', 2804000);
INSERT INTO "test" ("name", "population") VALUES ('Львів', 723605);
INSERT INTO "test" ("name", "population") VALUES ('Одеса', 997189);

