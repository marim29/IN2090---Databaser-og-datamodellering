
BEGIN;

INSERT INTO ws.users(username, password, name, address) VALUES
('yunoboy12', 'secretpass', 'Carl Smith', 'Streetroad 34, 1234 Townplace'),
('hackzor', 'pass1234', 'Mary Sagan', 'Placestreet 12B, 4356 Nicetown'),
('comprin88', 'p4ssw0rd', 'Ann Pat', 'Firstroad 341, 8965 Hitown'),
('qwer12', 'terces', 'Mina Polar', 'Streetroad 2, 1234 Townplace'),
('mark4', 'mpass', 'Mark Green', 'Commonplace Road 34, 2234 Commonplace'),
('mirz', 'asdf9876', 'Amir Nazur', 'Higarden Road 98, 7762 Hitown'),
('manaman', 'abc123', 'Mirnaruth Pulary', 'Snooth rd 74, 5646 Hitown');

INSERT INTO ws.categories(name) VALUES
('food'), ('electronics'), ('clothing'), ('games');

INSERT INTO ws.products(name, price, cid, description)
(SELECT 'Nanana', 0.9, c.cid, 'A yellow fruit' FROM ws.categories c WHERE c.name = 'food') UNION
(SELECT 'Piffi', 3.9, c.cid, 'A spice mix' FROM ws.categories c WHERE c.name = 'food') UNION
(SELECT 'Bread', 5.0, c.cid, 'A freshly baked bread' FROM ws.categories c WHERE c.name = 'food') UNION
(SELECT 'Milk', 2.5, c.cid, 'Fresh cow milk' FROM ws.categories c WHERE c.name = 'food') UNION
(SELECT 'Thinkpad L420', 199.0, c.cid, 'A nice student laptop' FROM ws.categories c WHERE c.name = 'electronics') UNION
(SELECT 'IPad S6', 379.9, c.cid, 'A userfriendly pad' FROM ws.categories c WHERE c.name = 'electronics') UNION
(SELECT 'Gameboy Color', 45.0, c.cid, 'A vintage gameboy with color screen' FROM ws.categories c WHERE c.name = 'electronics') UNION
(SELECT 'Nintendo 64', 69.95, c.cid, 'The original Nintendo 64 with Mario 64 included' FROM ws.categories c WHERE c.name = 'electronics') UNION
(SELECT 'Socks', 8.99, c.cid, 'A pair of socks' FROM ws.categories c WHERE c.name = 'clothing') UNION
(SELECT 'Green sweather', 15.99, c.cid, 'A green woolen sweather' FROM ws.categories c WHERE c.name = 'clothing') UNION
(SELECT 'Denim pants', 29.99, c.cid, 'A pair of blue denim pants' FROM ws.categories c WHERE c.name = 'clothing') UNION
(SELECT 'Blue sweather', 15.99, c.cid, 'A blue woolen sweater' FROM ws.categories c WHERE c.name = 'clothing') UNION
(SELECT 'Star Fights 3', 15.39, c.cid, 'A space simulator' FROM ws.categories c WHERE c.name = 'games') UNION
(SELECT 'Nario Sledge', 14.45, c.cid, 'A sledge racing game' FROM ws.categories c WHERE c.name = 'games') UNION
(SELECT 'Realm of Battle Skill', 19.95, c.cid, 'An MMORPG' FROM ws.categories c WHERE c.name = 'games') UNION
(SELECT 'Squires of the New Monarchy', 9.95, c.cid, 'A Sci-Fi RPG' FROM ws.categories c WHERE c.name = 'games');

-- Generate random order data
INSERT INTO ws.orders(uid, pid, num, date, payed)
SELECT uid, pid, num, date, payed
FROM generate_series(1,30) AS g(n)
     CROSS JOIN LATERAL
     (SELECT 
         g.n, -- Necessary, otherwise query optimizer duplicates same row over and over
         floor((random() * (SELECT max(uid) FROM ws.users)) + 1)::int AS uid,
         floor((random() * (SELECT max(pid) FROM ws.products)) + 1)::int AS pid,
         greatest(1, floor((random() * 10) - 5))::int AS num,
         current_date - floor((random() * 100) + 1)::int AS date,
         floor(random() + 0.4)::int AS payed) AS r;

COMMIT;
