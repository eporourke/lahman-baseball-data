-- 3. Find all the players in the database who played at Vanderbilt University. Create a list showing each player's first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

SELECT
	p.namefirst,
	p.namelast,
	s.salary
FROM people AS p
LEFT JOIN collegeplaying AS cp
	ON p.playerid = cp.playerid
LEFT JOIN salaries AS s
	ON p.playerid=s.playerid
WHERE schoolid = 'vandy'
ORDER BY s.salary DESC ;

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played in?

select p.namefirst,
p.namelast,
t.name,
t.g,
p.height
FROM people AS p
LEFT JOIN appearances AS a
ON p.playerid = a.playerid
LEFT JOIN teams AS t
ON a.teamid = t.teamid and a.yearid=t.yearid
ORDER BY p.height

SELECT *
FROM teams

-- Eddie Gaedel is 43 inches in height, and played 154 games for the St. Louis Browns

-- 1. What range of years for baseball games played does the provided database cover?

select MIN(year),
MAX(year)
FROM homegames

-- The range of games is from 1871 to 2016