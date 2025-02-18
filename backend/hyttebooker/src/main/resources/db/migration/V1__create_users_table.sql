create table if not exists users (
    userId int auto_increment primary key,
    name varchar(255) not null ,
    email varchar(255) unique not null,
    password varchar(255) not null
);