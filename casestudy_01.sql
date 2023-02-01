# Create new database
create database if not exists casestudy_01;
use casestudy_01;

# Fixing error code 1290. The MySQL server is running with the --secure-file-priv option so it cannot execute this statement
show variables like "secure_file_priv";
-- Go to "C:\ProgramData\MySQL\MySQL Server 8.0\"
-- Give permission to edit file "my.in"
-- Edit file "my.in" by notepad
-- In line "# Secure File Priv.
-- secure-file-priv="C:/ProgramData/MySQL/MySQL Server 8.0/Uploads" 
-- Change to
-- "# Secure File Priv.
-- #secure-file-priv="C:/ProgramData/MySQL/MySQL Server 8.0/Uploads"
-- secure-file-priv=""
-- Save and go to Service
-- Restart MYSQL80

# Import data from csv. Trip data from "Divvy_Trips_2013.csv"
set sql_mode="";
DROP table if exists 2013_trip;
CREATE TABLE IF NOT EXISTS 2013_trip 
(
	trip_id varchar(50),
	starttime datetime,
	stoptime datetime,
	bikeid int,
	tripduration int,
	from_station_id int,
	from_station_name text,
	to_station_id int,
	to_station_name text,
	usertype varchar(50),
	gender varchar(50),
	birthyear int
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Trips_2013.csv'
INTO TABLE 2013_trip
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# Import data from csv. Trip data from "Divvy_Trips_2014_Q1Q2.csv" to "Divvy_Trips_2017_Q4.csv"
# Date in these files are not right formatted for MySQL, so we need to transform date data and preprocessing before import
# Right format for MySQL is YYYY-MM-DD
# Using user-defined variable with @
set sql_mode="";
DROP table if exists 2016_q1_trip;
CREATE TABLE IF NOT EXISTS 2016_q1_trip
(
	trip_id varchar(50),
	starttime datetime,
	stoptime datetime,
	bikeid int,
	tripduration int,
	from_station_id int,
	from_station_name text,
	to_station_id int,
	to_station_name text,
	usertype varchar(50),
	gender varchar(50),
	birthyear int
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Trips_2016_Q1.csv'
INTO TABLE 2016_q1_trip
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(trip_id, @starttime, @stoptime, bikeid, tripduration, from_station_id,from_station_name,to_station_id,to_station_name,usertype,gender,birthyear)
SET starttime=str_to_date(@starttime,'%m/%d/%Y %H:%i'),
	stoptime=str_to_date(@stoptime,'%m/%d/%Y %H:%i');

# Import data from csv. Trip data from "Divvy_Trips_2018_Q1.csv" to "Divvy_Trips_2019_Q4.csv" 
# Original data have strange format in column "01 - Rental Details Duration In Seconds Uncapped"
# Example: "2,904.0". 
# We must transform it to int (example: 2904) by using format cell its column in Excel, change to number without decimal. (Using Macros)
# Change format of 2 columns "starttime", "stoptime" into 'yyyy-mm-dd hh:mm:ss'. (Using Macros)
# Save Excel formated csv and import into MySQL
set sql_mode="";
DROP table if exists 2018_q1_trip;
CREATE TABLE IF NOT EXISTS 2018_q1_trip 
(
	trip_id varchar(50),
	starttime datetime,
	stoptime datetime,
	bikeid int,
	tripduration int,
	from_station_id int,
	from_station_name text,
	to_station_id int,
	to_station_name text,
	usertype varchar(50),
	gender varchar(50),
	birthyear int
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Trips_2018_Q1.csv'
INTO TABLE 2018_q1_trip
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# The other way to import trip data from "Divvy_Trips_2018_Q1.csv" to "Divvy_Trips_2019_Q4.csv"
# No need edit anything in csv files
set sql_mode="";
DROP table if exists 2018_q1_trip;
CREATE TABLE IF NOT EXISTS 2018_q1_trip 
(
	trip_id varchar(50),
	starttime datetime,
	stoptime datetime,
	bikeid int,
	tripduration int,
	from_station_id int,
	from_station_name text,
	to_station_id varchar(50),
	to_station_name text,
	usertype varchar(50),
	gender varchar(50),
	birthyear int
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Trips_2018_Q1.csv'
INTO TABLE 2018_q1_trip
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(trip_id, starttime, stoptime, bikeid, @tripduration, from_station_id,from_station_name,to_station_id,to_station_name,usertype,gender,birthyear)
SET tripduration = replace(@tripduration,',','');
ALTER TABLE 2018_q1_trip MODIFY tripduration int;

# Import data from csv. Trip data from "Divvy_Trips_2020_Q1", "202004-divvy-tripdata.csv" to "202208-divvy-tripdata.csv"
set sql_mode="";
DROP table if exists 202208_trip;
CREATE TABLE IF NOT EXISTS 202208_trip 
(
	ride_id varchar(50),
	rideable_type varchar(50),
	started_at datetime,
	ended_at datetime,
	start_station_name text,
	start_station_id varchar(50),
	end_station_name text,
	end_station_id varchar(50),
	start_lat double,
	start_lng double,
	end_lat double,
	end_lng double,
	member_casual varchar(50)
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/202208-divvy-tripdata.csv'
INTO TABLE 202208_trip 
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# Import data from csv. Trip data from "202209-divvy-publictripdata.csv" to "202212-divvy-tripdata.csv"
# Problem in dataset is character '"' of original dataset column 'member_casual' can not transform right way so we must open csv and replace all '"' to ''
# After that we can import data into MySQL
set sql_mode="";
DROP table if exists 202210_trip;
CREATE TABLE IF NOT EXISTS 202212_trip 
(
	ride_id varchar(50),
	rideable_type varchar(50),
	started_at datetime,
	ended_at datetime,
	start_station_name text,
	start_station_id varchar(50),
	end_station_name text,
	end_station_id varchar(50),
	start_lat double,
	start_lng double,
	end_lat double,
	end_lng double,
	member_casual varchar(50)
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/202212-divvy-tripdata.csv'
INTO TABLE 202212_trip 
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# Import data from csv. Station data from "Divvy_Stations_2013" 
# Date in these files are not right formatted for MySQL, so we need to transform datetime data and preprocessing before import
# Right format for MySQL is YYYY-MM-DD
# Using user-defined variable with @
set sql_mode="";
DROP table if exists 2013_station;
CREATE TABLE IF NOT EXISTS  2013_station 
(
	id int primary key,
	name text,
	latitude double,
    longitude double,
    dpcapacity int,
    landmark int,
    online_date date
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Stations_2013.csv'
INTO TABLE 2013_station
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, latitude, longitude, dpcapacity, landmark, @online_date)
SET online_date =str_to_date(@online_date, '%m/%d/%Y');

# Import data from csv. Station data from "Divvy_Stations_2014-Q1Q2.csv" and "Divvy_Stations_2016_Q1Q2" to "Divvy_Stations_2016_Q4". 
# Date in these files are not right formatted for MySQL, so we need to transform date data and preprocessing before import
# Right format for MySQL is YYYY-MM-DD
# Using user-defined variable with @
set sql_mode="";
DROP table if exists 2016_q4_station;
CREATE TABLE IF NOT EXISTS  2016_q4_station
(
	id int primary key,
	name text,
	latitude double,
    longitude double,
    dpcapacity int,
    online_date date
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Stations_2016_Q4.csv'
INTO TABLE 2016_q4_station
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, latitude, longitude, dpcapacity, @online_date)
SET online_date =str_to_date(@online_date, '%m/%d/%Y');

# Import data from csv. Station data from "Divvy_Stations_2014-Q3Q4" 
# Date in these files are not right formatted for MySQL, so we need to transform datetime data and preprocessing before import
# Right format for MySQL is YYYY-MM-DD
# Using user-defined variable with @
set sql_mode="";
DROP table if exists 2014_q3q4_station;
CREATE TABLE IF NOT EXISTS  2014_q3q4_station 
(
	id int primary key,
	name text,
	latitude double,
    longitude double,
    dpcapacity int,
    online_date datetime
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Stations_2014-Q3Q4.csv'
INTO TABLE 2014_q3q4_station
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, latitude, longitude, dpcapacity, @online_date)
SET online_date =str_to_date(@online_date, '%m/%d/%Y %H:%i');

# Import data from csv. Station data from "Divvy_Stations_2015" 
# Date in these files are not right formatted for MySQL, so we need to transform datetime data and preprocessing before import
# Right format for MySQL is YYYY-MM-DD
# Using user-defined variable with @
set sql_mode="";
DROP table if exists 2015_station;
CREATE TABLE IF NOT EXISTS  2015_station 
(
	id int primary key,
	name text,
	latitude double,
    longitude double,
    dpcapacity int,
    landmark int
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Stations_2015.csv'
INTO TABLE 2015_station
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# Import data from csv. Station data from "Divvy_Stations_2017_Q1Q2.csv" to "Divvy_Stations_2017_Q3Q4.csv"
# Date in these files are not right formatted for MySQL, so we need to transform datetime data and preprocessing before import
# Right format for MySQL is YYYY-MM-DD
# Using user-defined variable with @
set sql_mode="";
DROP table if exists 2017_q3q4_station;
CREATE TABLE IF NOT EXISTS  2017_q3q4_station 
(
	id int primary key,
	name text,
    city varchar(50),
	latitude double,
    longitude double,
    dpcapacity int,
    online_date datetime
);
LOAD DATA INFILE 'D:/Data Analytics/Portfolio/Case study 1/Data/Divvy_Stations_2017_Q3Q4.csv'
INTO TABLE 2017_q3q4_station
FIELDS	TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, name, city, latitude, longitude, dpcapacity, @online_date)
SET online_date =str_to_date(@online_date, '%m/%d/%Y %H:%i:%s');


# Combine trip dataet into one table for each year (cannot combine one time for 2 years because it is too slow, error 2013)
# Only combine trip dataset have same structure data
# Fixing Error Code: 2013. Lost connection to MySQL server during query
# Edit → Preferences → SQL Editor → DBMS connection read time out (in seconds) and changed the value to 6000.
# Go to "C:\ProgramData\MySQL\MySQL Server 8.0\" and change "max_allowed_packet=64M". Save and restart MySQL 8.0 in services.msc
SET @@global.net_read_timeout=360;
DROP table if exists 2014_2015_trip;
Create table if not exists 2014_2015_trip as
(
	select * 
    from casestudy_01.2014_q1q2_trip
    
    union
    select * 
    from casestudy_01.2014_q3_07_trip
    
	union
	select * 
    from casestudy_01.2014_q3_0809_trip
    
    union
	select * 
    from casestudy_01.2014_q4_trip
    
    union
	select * 
    from casestudy_01.2015_q1_trip
    
    union
	select * 
    from casestudy_01.2015_q2_trip
    
    union
	select * 
    from casestudy_01.201507_trip
    
    union
	select * 
    from casestudy_01.201508_trip
    
	union
	select * 
    from casestudy_01.201509_trip
    
	union
	select * 
    from casestudy_01.2015_q4_trip
);

DROP table if exists 2016_2017_trip;
Create table if not exists 2016_2017_trip as
(
	select * 
    from casestudy_01.2016_q1_trip
    
    union
    select * 
    from casestudy_01.201604_trip
    
	union
	select * 
    from casestudy_01.201605_trip
    
    union
	select * 
    from casestudy_01.201606_trip
    
    union
	select * 
    from casestudy_01.2016_q3_trip
    
    union
	select * 
    from casestudy_01.2016_q4_trip
    
    union
	select * 
    from casestudy_01.2017_q1_trip
    
    union
	select * 
    from casestudy_01.2017_q2_trip
    
	union
	select * 
    from casestudy_01.2017_q3_trip
    
	union
	select * 
    from casestudy_01.2017_q4_trip
);

DROP table if exists 2018_2019_trip;
Create table if not exists 2018_2019_trip as
(
	select * 
    from casestudy_01.2018_q1_trip
    
    union
    select * 
    from casestudy_01.2018_q2_trip
    
	union
	select * 
    from casestudy_01.2018_q3_trip
    
    union
	select * 
    from casestudy_01.2018_q4_trip
    
    union
	select * 
    from casestudy_01.2019_q1_trip
    
    union
	select * 
    from casestudy_01.2019_q2_trip
    
    union
	select * 
    from casestudy_01.2019_q3_trip
    
    union
	select * 
    from casestudy_01.2019_q4_trip
);

DROP table if exists 2020_trip;
Create table if not exists 2020_trip as
(
	select * 
    from casestudy_01.2020_q1_trip
    
    union
    select * 
    from casestudy_01.202004_trip
    
	union
	select * 
    from casestudy_01.202005_trip
    
    union
	select * 
    from casestudy_01.202006_trip
    
    union
	select * 
    from casestudy_01.202007_trip
    
    union
	select * 
    from casestudy_01.202008_trip
    
    union
	select * 
    from casestudy_01.202009_trip
    
    union
	select * 
    from casestudy_01.202010_trip
    
    union
	select * 
    from casestudy_01.202011_trip
    
    union
	select * 
    from casestudy_01.202012_trip
);

DROP table if exists 2021_trip;
Create table if not exists 2021_trip as
(
	select * 
    from casestudy_01.202101_trip
    
    union
	select * 
    from casestudy_01.202102_trip
    
    union
	select * 
    from casestudy_01.202102_trip
    
    union
	select * 
    from casestudy_01.202103_trip
    
    union
	select * 
    from casestudy_01.202104_trip
    
    union
	select * 
    from casestudy_01.202105_trip
    
    union
	select * 
    from casestudy_01.202106_trip
    
    union
	select * 
    from casestudy_01.202107_trip
    
    union
	select * 
    from casestudy_01.202108_trip

    union
	select * 
    from casestudy_01.202109_trip
    
    union
	select * 
    from casestudy_01.202110_trip
    
    union
	select * 
    from casestudy_01.202111_trip
    
    union
	select * 
    from casestudy_01.202112_trip
);

DROP table if exists 2022_trip;    
Create table if not exists 2022_trip as
(
	select * 
    from casestudy_01.202201_trip
    
    union
	select * 
    from casestudy_01.202202_trip

    union
	select * 
    from casestudy_01.202203_trip
    
    union
	select * 
    from casestudy_01.202204_trip
    
    union
	select * 
    from casestudy_01.202205_trip
    
    union
	select * 
    from casestudy_01.202206_trip

    union
	select * 
    from casestudy_01.202207_trip
    
    union
	select * 
    from casestudy_01.202208_trip
    
    union
	select * 
    from casestudy_01.202209_trip
    
    union
	select * 
    from casestudy_01.202210_trip

    union
	select * 
    from casestudy_01.202211_trip
    
    union
	select * 
    from casestudy_01.202212_trip
);

DROP table if exists 2020_2022_trip;
Create table if not exists 2020_2022_trip as
(
	select *
    from casestudy_01.2020_trip
    
    union
    select *
    from casestudy_01.2021_trip
    
    union
    select *
    from casestudy_01.2022_trip
);

# Combine station data
SET @@global.net_read_timeout=360;
DROP table if exists 2014_station;
Create table if not exists 2014_station as
(
	select *
    from casestudy_01.2014_q1q2_station
    
    
    union
    select * 
    from casestudy_01.2014_q3q4_station
);

DROP table if exists 2016_station;
Create table if not exists 2016_station as
(
    select * 
    from casestudy_01.2016_q1q2_station
        
    union
    select * 
    from casestudy_01.2016_q3_station
    
    union
    select * 
    from casestudy_01.2016_q4_station
);

DROP table if exists 2017_station;
Create table if not exists 2017_station as
(
    select * 
    from casestudy_01.2017_q1q2_station
        
    union
    select * 
    from casestudy_01.2017_q3q4_station
);

# Data Prepare
# We focus on table '2022_trip' for this case study
# Table '2020_2022_trip' is hard to be analyzed because of  the big of dataset, take more time to process dataset
# Look at the data table
SELECT * 
FROM casestudy_01.2022_trip;

# Calculate time length of each ride and format as hh:mm:ss
select *,timediff(ended_at, started_at) as tripduration
from casestudy_01.2022_trip;

alter table casestudy_01.2022_trip
add column tripduration time generated always as (timediff(ended_at, started_at)) stored;


# The number of rides by casual customers and members.
select distinct casestudy_01.2022_trip.member_casual
from casestudy_01.2022_trip;
-- There are 2 distinct values: casual and member

select casestudy_01.2022_trip.member_casual, count(*) as num_rides
from casestudy_01.2022_trip
group by casestudy_01.2022_trip.member_casual
order by count(*) desc;
-- Member: 3345685
-- Casual: 2322032

# The types of bikes being offered.
select distinct casestudy_01.2022_trip.rideable_type
from casestudy_01.2022_trip;
-- electric_bike, classic_bike,docked_bike

select casestudy_01.2022_trip.rideable_type, count(*) as num_rides
from casestudy_01.2022_trip
group by casestudy_01.2022_trip.rideable_type
order by count(*) desc;
-- electric_bike: 2889029
-- classic_bike: 2601214
-- docked_bike: 177474

# Number of rides starting at each station
select casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name, count(*) as num_rides
from casestudy_01.2022_trip
group by casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name
order by count(*) desc;

# Number of rides ending at each station
select casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name, count(*) as num_rides
from casestudy_01.2022_trip
group by casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name
order by count(*) desc;

# Number of round trips
select 	casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name,
		casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name,
		casestudy_01.2022_trip.rideable_type, casestudy_01.2022_trip.member_casual,
        count(*) as num_round_rides
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_station_id = casestudy_01.2022_trip.end_station_id
group by casestudy_01.2022_trip.start_station_id,  casestudy_01.2022_trip.rideable_type,  casestudy_01.2022_trip.member_casual
order by count(*) desc;

select 	casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name,
		casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name,
        count(*) as num_round_rides
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_station_id = casestudy_01.2022_trip.end_station_id
group by casestudy_01.2022_trip.start_station_id
order by count(*) desc;

# Data Process
# Member_casual field have only 2 distinct values
select distinct casestudy_01.2022_trip.member_casual
from casestudy_01.2022_trip;
-- There are 2 distinct values: casual and member

# Latitudes should be between -90 to 90 and longitudes should be between -180 to 180.
select 	casestudy_01.2022_trip.ride_id, casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name,
        casestudy_01.2022_trip.start_lat
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_lat = (select min(casestudy_01.2022_trip.start_lat) from casestudy_01.2022_trip);

select 	casestudy_01.2022_trip.ride_id, casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name,
        casestudy_01.2022_trip.start_lat
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_lat = (select max(casestudy_01.2022_trip.start_lat) from casestudy_01.2022_trip);

select 	casestudy_01.2022_trip.ride_id, casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name,
        casestudy_01.2022_trip.start_lng
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_lng = (select min(casestudy_01.2022_trip.start_lng) from casestudy_01.2022_trip);

select 	casestudy_01.2022_trip.ride_id, casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name,
        casestudy_01.2022_trip.start_lng
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_lng = (select max(casestudy_01.2022_trip.start_lng) from casestudy_01.2022_trip);

select 	casestudy_01.2022_trip.ride_id, casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name,
        casestudy_01.2022_trip.end_lat
from casestudy_01.2022_trip
where casestudy_01.2022_trip.end_lat = (select min(casestudy_01.2022_trip.end_lat) from casestudy_01.2022_trip);

select 	casestudy_01.2022_trip.ride_id, casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name,
        casestudy_01.2022_trip.end_lat
from casestudy_01.2022_trip
where casestudy_01.2022_trip.end_lat = (select max(casestudy_01.2022_trip.end_lat) from casestudy_01.2022_trip);

select 	casestudy_01.2022_trip.ride_id, casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name,
        casestudy_01.2022_trip.end_lng
from casestudy_01.2022_trip
where casestudy_01.2022_trip.end_lng = (select min(casestudy_01.2022_trip.end_lng) from casestudy_01.2022_trip);

select 	casestudy_01.2022_trip.ride_id, casestudy_01.022_trip.end_station_id, casestudy_01.2022_trip.end_station_name,
        casestudy_01.2022_trip.end_lng
from casestudy_01.2022_trip
where casestudy_01.2022_trip.end_lng = (select max(casestudy_01.2022_trip.end_lng) from casestudy_01.2022_trip);

select 	min(casestudy_01.2022_trip.start_lat) as min_start_lat, max(casestudy_01.2022_trip.start_lat) as max_start_lat,
		min(casestudy_01.2022_trip.start_lng) as min_start_lng, max(casestudy_01.2022_trip.start_lng) as max_start_lng,
        min(casestudy_01.2022_trip.end_lat) as min_end_lat, max(casestudy_01.2022_trip.end_lat) as max_end_lat,
		min(casestudy_01.2022_trip.end_lng) as min_end_lng, max(casestudy_01.2022_trip.end_lng) as max_end_lng
from casestudy_01.2022_trip;

-- Min start latitude:	41.64
-- Max start latitude: 45.635034323
-- Min start longitude: -87.84
-- Max start longitude: -79.79647696
-- Min end latitude: 0
-- Max end latitude: 42.37
-- Min end longitude: -88.14
-- Max end longitude: 0

# Check ride_id dupplicated or not
select casestudy_01.2022_trip.ride_id, count(casestudy_01.2022_trip.ride_id) as num_dups
from casestudy_01.2022_trip
group by casestudy_01.2022_trip.ride_id
having count(casestudy_01.2022_trip.ride_id)>1;
-- There is no duplicate ride_id

# Check nulls in rows
select *
from casestudy_01.2022_trip
where casestudy_01.2022_trip.started_at is null or casestudy_01.2022_trip.ended_at is null;
-- There is no null in rows

# Checking wrong time if the start time was after the end time
select *
from casestudy_01.2022_trip
where casestudy_01.2022_trip.started_at > casestudy_01.2022_trip.ended_at;

select *
from casestudy_01.2022_trip
where timediff(casestudy_01.2022_trip.started_at,casestudy_01.2022_trip.ended_at)>0;

# Checking nulls in time at started_at, ended_at
select *
from casestudy_01.2022_trip
where casestudy_01.2022_trip.started_at is null or casestudy_01.2022_trip.ended_at is null;
-- There is no null in rows

# Checking start stations and end stations which have only whitespaces
select *, count(*) as "Number of start stations which have only whitespaces"
from casestudy_01.2022_trip
where trim(casestudy_01.2022_trip.start_station_id) is null or trim(casestudy_01.2022_trip.start_station_name) is null
group by casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name;
-- There is no start stations which have only whitespaces

select *, count(*) as "Number of end stations which have only whitespaces"
from casestudy_01.2022_trip
where trim(casestudy_01.2022_trip.end_station_id) is null or trim(casestudy_01.2022_trip.end_station_name) is null
group by casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name;
-- There is no end stations which have only whitespaces

# Checking nulls of start stations and end stations
select *, count(*) as num_null_start
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_station_id is null or casestudy_01.2022_trip.start_station_name is null
group by casestudy_01.2022_trip.start_station_id, casestudy_01.2022_trip.start_station_name;
-- There is no null of start stations

select *, count(*) as num_null_end
from casestudy_01.2022_trip
where casestudy_01.2022_trip.end_station_id is null or casestudy_01.2022_trip.end_station_name is null
group by casestudy_01.2022_trip.end_station_id, casestudy_01.2022_trip.end_station_name;
-- There is no null of end stations

# Checking nulls of latitude and longtitude
select *, count(*) as num_null_lat
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_lat is null or casestudy_01.2022_trip.end_lat is null
group by casestudy_01.2022_trip.start_lat, casestudy_01.2022_trip.end_lat;
-- There is no null of latitude

select *, count(*) as num_null_lng
from casestudy_01.2022_trip
where casestudy_01.2022_trip.start_lng is null or casestudy_01.2022_trip.end_lng is null
group by casestudy_01.2022_trip.start_lng, casestudy_01.2022_trip.end_lng;
--  There is no null of longitude

# Checking nulls of member_casual
select *, count(*) as num_null_users
from casestudy_01.2022_trip
where casestudy_01.2022_trip.member_casual is null
group by casestudy_01.2022_trip.member_casual;
-- There is no null of member_casual

# Data analyze
# Delete duplicated ride_id without primary key. 
# While insert data from old table to new temp table, we may encounter error code 1205: lock wait timeout excceded. 
# To fix it we kill process id in process list.
create table casestudy_01.temp like casestudy_01.2022_trip;
insert into casestudy_01.temp
			(select * from  casestudy_01.2022_trip 
            group by casestudy_01.2022_trip.ride_id);
drop table casestudy_01.2022_trip;
rename table casestudy_01.temp to casestudy_01.2022_trip;
show full processlist;
kill 96;
kill 98;
kill 99;
kill 100;
kill 5;

delete from casestudy_01.2022_trip
where 	casestudy_01.2022_trip.ride_id in 
		(select casestudy_01.2022_trip.ride_id 
				from 
						(select casestudy_01.2022_trip.ride_id,
						row_number() over
							(partition by casestudy_01.2022_trip.ride_id 
							order by casestudy_01.2022_trip.ride_id) as row_num
						from casestudy_01.2022_trip) t
				where row_num >1);

alter table casestudy_01.2022_trip add column temp serial primary key;
delete t1.* 
from casestudy_01.2022_trip t1
left join (select min(temp) mintemp from casestudy_01.2022_trip group by casestudy_01.2022_trip.ride_id) t2
on t1.temp=t2.mintemp
where t2.mintemp is null;
alter table casestudy_01.2022_trip drop column temp;

# Delete duplicated ride_id with primary key
delete from casestudy_01.2022_trip t1
inner join casestudy_01.2022_trip t2
where t1.id > t2.id and t1.ride_id = t2.ride_id;

# Delete wrong time which ended_at sooner than started_at
delete from casestudy_01.2022_trip
where casestudy_01.2022_trip.started_at>=casestudy_01.2022_trip.ended_at;
-- 531 rows affected



# Delete wrong data
delete from casestudy_01.2022_trip
where	casestudy_01.2022_trip.start_lat not between -90 and 90 or
		casestudy_01.2022_trip.start_lng not between -180 and 180 or
        casestudy_01.2022_trip.end_lat not between -90 and 90 or
		casestudy_01.2022_trip.end_lng not between -180 and 180;
-- 0 rows affected

# Delete null data
delete from casestudy_01.2022_trip
where 	casestudy_01.2022_trip.ride_id is null or
		casestudy_01.2022_trip.started_at is null or
        casestudy_01.2022_trip.ended_at is null or
        casestudy_01.2022_trip.member_casual is null ;
-- 0 rows affected

# Calculation trip duration for each ride
alter table casestudy_01.2022_trip
add column tripduration int generated always as (timediff(casestudy_01.2022_trip.ended_at,casestudy_01.2022_trip.started_at)) stored;

alter table casestudy_01.2022_trip
add column tripduration int;
update casestudy_01.2022_trip
set tripduration = timestampdiff(second,casestudy_01.2022_trip.started_at,casestudy_01.2022_trip.ended_at);

# Day of week for each ride at start station
alter table casestudy_01.2022_trip
add column day_of_week int generated always as (dayofweek(casestudy_01.2022_trip.started_at)) stored;

alter table casestudy_01.2022_trip
add column day_of_week int;
update casestudy_01.2022_trip
set day_of_week = dayofweek(casestudy_01.2022_trip.started_at);

# Data share
# Create new summarized table for sharing to stakeholder
# Number of rides for casual and member
create table if not exists member_casual_rides as
(
	select casestudy_01.2022_trip.member_casual, count(*) as num_rides
    from casestudy_01.2022_trip
    group by casestudy_01.2022_trip.member_casual
    order by count(*) desc
);

# Number of rides for each rideable type
create table if not exists rideable_type_rides as
(
	select casestudy_01.2022_trip.rideable_type, count(*) as num_rides
    from casestudy_01.2022_trip
    group by casestudy_01.2022_trip.rideable_type
    order by count(*) desc
);

# Distribution of members and casuals for each bike type
create table if not exists mem_rideable_rides as
(
	select casestudy_01.2022_trip.member_casual,casestudy_01.2022_trip.rideable_type, count(*) as num_rides
    from casestudy_01.2022_trip
    group by casestudy_01.2022_trip.member_casual,casestudy_01.2022_trip.rideable_type
    order by casestudy_01.2022_trip.member_casual asc,casestudy_01.2022_trip.rideable_type asc, count(*) desc
);

# Round trips for each bike tupe and membership type
create table if not exists round_rides as
(
	select 	casestudy_01.2022_trip.start_station_name,casestudy_01.2022_trip.start_station_id,
			casestudy_01.2022_trip.end_station_name, casestudy_01.2022_trip.end_station_id,
			casestudy_01.2022_trip.member_casual,casestudy_01.2022_trip.rideable_type, 
            count(*) as num_round_rides
    from casestudy_01.2022_trip
    where casestudy_01.2022_trip.start_station_id=casestudy_01.2022_trip.end_station_id
    group by 	casestudy_01.2022_trip.start_station_name,casestudy_01.2022_trip.start_station_id,
				casestudy_01.2022_trip.member_casual ,casestudy_01.2022_trip.rideable_type
    order by 	casestudy_01.2022_trip.start_station_name,casestudy_01.2022_trip.start_station_id,
				casestudy_01.2022_trip.member_casual ,casestudy_01.2022_trip.rideable_type, 
                count(*) desc
);

#  Distribution of casual and member rides across the year
create table if not exists year_rides as
(
	select 	date_format(casestudy_01.2022_trip.started_at,'%m-%Y') as mon_year,
			casestudy_01.2022_trip.member_casual, count(*) as num_rides
	from casestudy_01.2022_trip
    group by date_format(casestudy_01.2022_trip.started_at,'%m-%Y'),casestudy_01.2022_trip.member_casual
    order by date_format(casestudy_01.2022_trip.started_at,'%m-%Y'), count(*) desc
);

create table if not exists year_rides_casual as
(
	select 	date_format(casestudy_01.2022_trip.started_at,'%m-%Y') as mon_year,
			casestudy_01.2022_trip.member_casual, count(*) as num_rides
	from casestudy_01.2022_trip
    where casestudy_01.2022_trip.member_casual like "%casual%"
    group by date_format(casestudy_01.2022_trip.started_at,'%m-%Y')
	order by date_format(casestudy_01.2022_trip.started_at,'%m-%Y')
);

create table if not exists year_rides_member as
(
	select 	date_format(casestudy_01.2022_trip.started_at,'%m-%Y') as mon_year,
			casestudy_01.2022_trip.member_casual, count(*) as num_rides
	from casestudy_01.2022_trip
    where casestudy_01.2022_trip.member_casual like "%member%"
    group by date_format(casestudy_01.2022_trip.started_at,'%m-%Y')
	order by date_format(casestudy_01.2022_trip.started_at,'%m-%Y'), count(*) desc
);

# Create table that calculate average trip duration for member and casual
create table if not exists member_casual_duration as
(
	select 	casestudy_01.2022_trip.member_casual, count(*) as num_rides, 
			avg(casestudy_01.2022_trip.tripduration) as avg_duration
	from casestudy_01.2022_trip
    group by casestudy_01.2022_trip.member_casual
	order by avg(casestudy_01.2022_trip.tripduration) desc
);

# Average trip duration for users by day of week
create table if not exists dayofweek_duration as
(
	select 	casestudy_01.2022_trip.member_casual, dayofweek(casestudy_01.2022_trip.started_at) as day_of_week, count(*) as num_rides, 
			avg(casestudy_01.2022_trip.tripduration) as avg_tripduration
	from casestudy_01.2022_trip
    group by casestudy_01.2022_trip.member_casual, dayofweek(casestudy_01.2022_trip.started_at)
	order by casestudy_01.2022_trip.member_casual,dayofweek(casestudy_01.2022_trip.started_at)
);

# Export query to csv then import to Tableau
SELECT 'ride_id','rideable_type','started_at','ended_at','start_station_name','start_station_id','end_station_name','end_station_id','start_lat','start_lng','end_lat','end_lng','member_casual','tripduration','day_of_week'
UNION ALL
SELECT *
FROM casestudy_01.2022_trip
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/2022_trip.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT 'member_casual','day_of_week', 'num_rides','avg_duration'
UNION ALL
SELECT *
FROM casestudy_01.dayofweek_duration
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/dayofweek_duration.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT 'member_casual','rideable_type' ,'num_rides'
UNION ALL
SELECT *
FROM casestudy_01.mem_rideable_rides
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/mem_rideable_rides.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT 'member_casual','num_rides'
UNION ALL
SELECT *
FROM casestudy_01.member_casual_rides
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/member_casual_rides.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT 'member_casual', 'num_rides','avg_duration'
UNION ALL
SELECT *
FROM casestudy_01.member_casual_duration
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/member_casual_duration.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT 'rideable_type','num_rides'
UNION ALL
SELECT *
FROM casestudy_01.rideable_type_rides
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/rideable_type_rides.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT 'mon_year','member_casual', 'num_rides'
UNION ALL
SELECT *
FROM casestudy_01.year_rides
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/year_rides.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT 'mon_year','member_casual', 'num_rides'
UNION ALL
SELECT *
FROM casestudy_01.year_rides_casual
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/year_rides_casual.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT 'mon_year','member_casual', 'num_rides'
UNION ALL
SELECT *
FROM casestudy_01.year_rides_member
INTO OUTFILE 'D:/Data Analytics/Portfolio/Case study 1/Output/year_rides_member.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

# Fixing error code 1175 when delete wrong data because of safe update
SET SQL_SAFE_UPDATES = 0;
-- Go to Edit --> Preferences
-- Click "SQL Editor" tab and uncheck "Safe Updates" check box
-- Query --> Reconnect to Server // logout and then login
-- Now execute your SQL query





