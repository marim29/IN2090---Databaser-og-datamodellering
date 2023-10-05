-- Make schema and add example data

DROP SCHEMA IF EXISTS ws CASCADE;

BEGIN;

CREATE SCHEMA ws;

CREATE TABLE ws.users (
    uid SERIAL PRIMARY KEY,
    username varchar(20) UNIQUE CHECK (username ~ '[^\s]+'),
    password text NOT NULL, -- NEVER store passwords in plain text in real applications!!!
    name text NOT NULL,
    address text NOT NULL
);

CREATE TABLE ws.categories (
    cid SERIAL PRIMARY KEY,
    name text UNIQUE NOT NULL
);

CREATE TABLE ws.products (
    pid SERIAL PRIMARY KEY,
    name text NOT NULL,
    price float NOT NULL CHECK (price >= 0),
    cid int REFERENCES ws.categories(cid),
    description text
);

CREATE TABLE ws.orders (
    oid SERIAL PRIMARY KEY,
    uid int REFERENCES ws.users(uid),
    pid int REFERENCES ws.products(pid),
    num int NOT NULL,
    date date NOT NULL,
    payed int NOT NULL CHECK (payed = 0 OR payed = 1)
);

COMMIT;
