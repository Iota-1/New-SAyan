##################3##########ICC Test Cricket##############################

create database icc;
use icc;

alter table `icc test batting figures` rename to icc_test_batting_figures;


#2.	Remove the column 'Player Profile' from the table.

alter table icc_test_batting_figures drop column `Player Profile`;

#3.	Extract the country name and player names from the given data and store it in seperate columns for further usage.
alter table icc_test_batting_figures add column country varchar(15),add column player_name varchar(30);

update icc_test_batting_figures set country = substr(Player,position('(' in Player) + 1, length(Player) - position('(' in PLayer) - 2);
update icc_test_batting_figures set player_name = substr(Player, 1, position('(' in Player) - 1);

#4.	From the column 'Span' extract the start_year and end_year and store them in seperate columns for further usage.

alter table icc_test_batting_figures add column start_year int,add column end_year int;

update icc_test_batting_figures set start_year = substr(Span, 1,4);
update icc_test_batting_figures set end_year = substr(Span, 6, 4);


#5.	The column 'HS' has the highest score scored by the player so far in any given match. 
#The column also has details if the player had completed the match in a NOT OUT status.
# Extract the data and store the highest runs and the NOT OUT status in different columns.

alter table icc_test_batting_figures add column highest_runs int,add column Not_out varchar(10);

update icc_test_batting_figures set highest_runs = substring_index(HS, '*', 1);
update icc_test_batting_figures set Not_out = if(position('*' in HS) = 0, 'No', 'Yes');
 
 #6.Using the data given, considering the players who were active in the year of 2019,
 #create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for India.
 
select * from (select player_name,country,Span,Avg,
 rank() over(order by Avg desc) as rnk from icc_test_batting_figures  where 2019  between start_year and end_year
and country like'%india%') l
where rnk between 1 and 6 ;
 
 #7.Using the data given, considering the players who were active in the year of 2019, 
 #create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for India.
 
select * from (select player_name,country,Span,`100`,
 rank() over(order by `100` desc) as rnk1 from icc_test_batting_figures  where 2019  between start_year and end_year
and country like'%india%') w
where rnk1 between 1 and 6;

#8.	Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using 2 selection criterias of your own for India.

select * from (select player_name,country,Span,Avg,`100`,`50`,highest_runs,
 rank() over(order by`100`+`50`  desc) as rnk 
from icc_test_batting_figures  where 2019  between start_year and end_year
and country like'%india%') b 
where rnk between 1 and 6 ;

select * from (select player_name,country,Span,Avg,`100`,Mat,
 rank() over(order by Mat  desc) as rnk 
from icc_test_batting_figures  where 2019  between start_year and end_year
and country like'%india%') b 
where rnk between 1 and 6 ;

#9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, 
#considering the players who were active in the year of 2019, create a set of batting order of best 6 players
# using the selection criteria of those who have a good average score across all matches for South Africa.

create view Batting_Order_GoodAvgScorers_SA as (select * from (select player_name,country,Span,Avg,
 rank() over(order by Avg desc) as rnk from icc_test_batting_figures  where 2019  between start_year and end_year and country like'%sa%') l where rnk between 1 and 6);
 
select * from Batting_Order_GoodAvgScorers_SA;

#10.Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players who were active in the year of 2019, 
#create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.

create view Batting_Order_HighestCenturyScorers_SA as (select * from (select player_name,country,Span,`100`,
 rank() over(order by `100` desc) as rnk from icc_test_batting_figures  where 2019  between start_year and end_year and country like'%sa%') l where rnk between 1 and 6);
 
 select * from Batting_Order_HighestCenturyScorers_SA;
