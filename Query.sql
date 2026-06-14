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
