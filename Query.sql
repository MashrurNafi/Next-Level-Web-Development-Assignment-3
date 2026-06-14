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
