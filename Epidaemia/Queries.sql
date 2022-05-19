
-- Individuals in urbe
create VIEW if not EXISTS individuals_in_urbe as select i.*,u.* from individual i inner join urbe u on (u.ROWID=i.idurbe);

-- Select all healthy individuals
create view if not EXISTS healthy_individuals_in_urbe as
select * from individuals_in_urbe
where infecround = -1
and vaccinated=-1;

-- Select all susceptible individuals
CREATE VIEW if NOT EXISTS susceptible_in_urbe as select * from individuals_in_urbe where infecround = -1 and immune=false;

-- Individuals incubating
CREATE VIEW if NOT EXISTS incubation_in_urbe as
select * from individuals_in_urbe
where immune=true
and infected=true
and infecround>-1
and round>=infecround
and round<infecround+incubation;

-- Individuals just being infected
create view if not EXISTS contacted_in_urbe as
select * from individuals_in_urbe
where immune=true
and infected=true
and infecround>-1
and round=infecround;

-- Counting of infected individuals per round
create view if not exists infected_row as
select idurbe,round,count(*) as cnt_infect from contacted_in_urbe
group by idurbe,round;

-- Cumulative counting of infected individuals
create view if not exists sum_infected_row as
select idurbe,round,sum(cnt_infect) OVER (rows UNBOUNDED PRECEDING) as infect_sum
from infected_row;

-- Sick individuals
create view if not EXISTS sick_in_urbe as
select * from individuals_in_urbe
where immune=true
and infected=true
and infecround>-1
and round>=infecround+incubation
and round<=infecround+incubation+illnssprd;

-- Individuals getting sick (notifications per round)
create view if not exists gettingsick_in_urbe as
select * from individuals_in_urbe
where immune=true
and infected=true
and infecround>-1
and round=infecround+incubation;

-- Sick and asymptomatic
create view if not exists asymptomatic_sick_in_urbe as
select * from individuals_in_urbe
where immune=true
and infected=true
and infecround>-1
and round>=infecround+incubation
and round<=infecround+incubation+illnssprd
and asymptomatic=true;

-- Sick risky individuals 
create view if not exists risky_in_urbe as
select * from individuals_in_urbe
where immune=true
and infected=true
and infecround>-1
and round>=infecround+incubation
and round<=infecround+incubation+illnssprd
and maydie=true;

-- Risky and asymptomatic individuals
create view if not exists riskyasymptomaticsick_in_urbe as
select * from individuals_in_urbe
where immune=true
and infected=true
and infecround>-1
and round>=infecround+incubation
and round<=infecround+incubation+illnssprd
and asymptomatic=true
and maydie=true;

-- Deaths per round
SELECT * from individual
where maydie=true
and round=dead;

-- Individuals recovered
create view if not exists recovered_in_urbe as
select * from individuals_in_urbe
where infecround>-1
and round>infecround+incubation+illnssprd;

-- Individuals getting recovered per round
create view if not exists gettingrecovered_in_urbe as
select * from individuals_in_urbe
where infecround>-1
and round=infecround+incubation+illnssprd+1;

-- Individuals becoming susceptible again
create view if not exists recurrence_in_urbe as
select * from individuals_in_urbe
where infecround>-1
and recurrence=true
and immune=false
and round>infecround+incubation+illnssprd;

-- Individuals getting susceptible again
create view if not exists getting_susceptible_in_urbe as
select * from individuals_in_urbe
where infecround>-1
and recurrence=true
and immune=false
and round-infecround-incubation-illnssprd-recurrencedelay=1;

-- Number of vaccinated individuals
create view if not exists vaccinated_in_urbe as
select * from individuals_in_urbe
where vaccinated>-1;

-- Number of vaccinated individuals per round
create view if not exists vaccinated_in_urbe as
select * from individuals_in_urbe
where round=vaccinated;

-- vaccinated individuals effectively immunized
create view if not exists immunized_vaccinated_in_urbe as
select * from individuals_in_urbe
where round=vaccinated
and immune=true;

-- Vaccinated but not immunized
create view if not exists notimmunized_vaccinated_in_urbe as
select * from individuals_in_urbe
where round=vaccinated
and immune=false;