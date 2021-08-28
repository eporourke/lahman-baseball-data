-- 5.Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

-- 4.Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

SELECT
	position,
	SUM(f.po)
	(SELECT
		CASE
			WHEN f.pos = 'OF' THEN 'Outfield'
			WHEN f.pos = 'SS' THEN 'Infield'
			WHEN f.pos = '1B' THEN 'Infield'
			WHEN f.pos = '2B' THEN 'Infield'
			WHEN f.pos = '3B' THEN 'Infield'
			WHEN f.pos = 'P' THEN 'Battery'
			WHEN f.pos = 'C' THEN 'Battery'
			END AS position,
		f.po)
		FROM people AS p
LEFT JOIN fielding AS f
ON p.playerid = f.playerid
GROUP BY position

SELECT * FROM fielding

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