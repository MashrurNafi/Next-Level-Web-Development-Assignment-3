CREATE TABLE users (
    user_id serial PRIMARY KEY,
    full_name varchar(50),
    email varchar(50) UNIQUE,
    role varchar(25) CHECK (role IN ('Football Fan', 'Ticket Manager')),
    phone_number varchar(25)
);

CREATE TABLE matches (
    match_id int generated always as identity(
        start with 101
        increment by 1
    ) PRIMARY KEY,
    fixture varchar(50),
    tournament_category varchar(50),
    base_ticket_price int CHECK (base_ticket_price >= 0),
    match_status varchar(50) CHECK (
        match_status IN (
            'Available',
            'Selling Fast',
            'Sold Out',
            'Postponed'
        )
    )
);

CREATE TABLE bookings (
    booking_id int generated always as identity(
        start with 501 
        increment by 1 ) 
        PRIMARY KEY,
    user_id int REFERENCES users (user_id),
    match_id int references matches(match_id),
    seat_number varchar(20),
    payment_status varchar(25) check (payment_status in ('Confirmed', 'Pending', 'Canceled', 'Refunded')),
    total_cost int check(total_cost >= 0)
);


INSERT INTO
    Users (user_id, full_name, email, role, phone_number)
VALUES
    (
        1,
        'Tanvir Rahman',
        'tanvir@mail.com',
        'Football Fan',
        '+8801711111111'
    ),
    (
        2,
        'Asif Haque',
        'asif@mail.com',
        'Football Fan',
        '+8801722222222'
    ),
    (
        3,
        'Sajjad Rahman',
        'sajjad@mail.com',
        'Ticket Manager',
        '+8801733333333'
    ),
    (
        4,
        'Jannat Ara',
        'jannat@mail.com',
        'Football Fan',
        NULL
    );


INSERT INTO
    Matches (
        fixture,
        tournament_category,
        base_ticket_price,
        match_status
    )
VALUES
    (
        'Real Madrid vs Barcelona',
        'Champions League',
        150.00,
        'Available'
    ),
    ( 
        'Man City vs Liverpool',
        'Premier League',
        120.00,
        'Selling Fast'
    ),
    (        
        'Bayern Munich vs PSG',
        'Champions League',
        130.00,
        'Available'
    ),
    (       
        'AC Milan vs Inter Milan',
        'Serie A',
        90.00,
        'Sold Out'
    ),
    (      
        'Juventus vs Roma',
        'Serie A',
        80.00,
        'Available'
    );


INSERT INTO
    Bookings (
        user_id,
        match_id,
        seat_number,
        payment_status,
        total_cost
    )
VALUES
    (1, 101, 'A-12', 'Confirmed', 150.00),
    (1, 102, 'B-04', 'Confirmed', 120.00),
    (2, 101, 'A-13', 'Confirmed', 150.00),
    (2, 101, NULL, NULL, 150.00),
    (3, 102, 'C-20', 'Pending', 120.00);


--Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.

select match_id,fixture,base_ticket_price from matches where tournament_category = 'Champions League' and match_status = 'Available';

--Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).

select user_id,full_name,email from users where full_name like 'Tanvir%' or full_name ilike '%Haque%';

--Query 3 : Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.

select booking_id,user_id,match_id,coalesce(payment_status, 'Action Required') as systematic_status from bookings where payment_status is null;

--Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.

select booking_id,full_name,fixture,total_cost from bookings as b inner join users as u on b.user_id = u.user_id inner join matches as m on b.match_id = m.match_id;

--Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.

select u.user_id, full_name, booking_id from users as u full join bookings as b on u.user_id = b.user_id; 

--Query 6: Find all ticket bookings where the total cost is strictly higher than the average cost of all ticket bookings.

select booking_id,match_id, total_cost from bookings where total_cost > (select avg(total_cost) from bookings);

--Query 7: Retrieve the top 2 most expensive matches sorted by base ticket price, skipping the absolute highest premium match.

select match_id,fixture,base_ticket_price from matches order by base_ticket_price desc limit 2 offset 1;
