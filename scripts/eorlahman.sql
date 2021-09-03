-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

SELECT
	p.namefirst,
	p.namelast,
	t.name,
	a.awardid,
	a.lgid
FROM people AS p
INNER JOIN awardsmanagers AS a
ON p.playerid = a.playerid
INNER JOIN managershalf AS m
ON a.playerid = m.playerid
INNER JOIN teams AS t
ON m.teamid = t.teamid AND m.yearid = t.yearid
WHERE a.awardid = 'TSN Manager of the Year'
AND a.lgid = 'AL'
OR a.lgid = 'NL'
-- when adding AND and OR the first filtering clause becomes invalidated????

SELECT
	p.namefirst,
	p.namelast,
	t.name,
	am.awardid,
	am.lgid,
	COUNT (am.lgid) OVER (PARTITION BY am.lgid) AS count
FROM (
	SELECT
	playerid,
	awardid,
	lgid
	FROM awardsmanagers
	WHERE lgid = 'AL'
	OR lgid = 'NL') AS am
LEFT JOIN people AS p
ON p.playerid = am.playerid
LEFT JOIN managershalf AS mh
ON am.playerid = mh.playerid
LEFT JOIN teams AS t
ON mh.teamid = t.teamid
WHERE awardid = 'TSN Manager of the Year'
AND count = 2
ORDER BY p.namelast

SELECT *
FROM people AS p
WHERE EXISTS
(SELECT *
	FROM awardsmanagers AS a
 	WHERE lgid = 'AL'
 	OR lgid = 'NL')

SELECT * from awardsmanagers
WHERE awardid LIKE '%TSN%'

-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

SELECT
team,
park,
attendance/games AS avg_attendance
FROM homegames
WHERE games > '10'
AND year = 2016
ORDER BY avg_attendance DESC
LIMIT 5;

SELECT
team,
park,
attendance/games AS avg_attendance
FROM homegames
WHERE games > '10'
AND year = 2016
ORDER BY avg_attendance
LIMIT 5;

-- 7. From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

--think in terms of what is in the numerator and what is in the denominator when calculating a metric - it's talking about a team with the most wins(denominator) - only them, then the number that have world series wins - numerator
SELECT * FROM teams

SELECT 
name,
yearid,
SUM(w) AS wins
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND wswin <> 'Y'
GROUP BY name, yearid
ORDER BY wins

SELECT 
name,
yearid,
SUM(w) AS wins
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
AND wswin = 'Y'
GROUP BY name, yearid
ORDER BY wins

SELECT
name,
yearid,
w,
wswin
FROM teams
WHERE yearid BETWEEN 1970 AND 2016
ORDER BY w

SELECT 
name,
yearid,
SUM(w) AS wins
FROM teams
WHERE yearid > 1969
AND yearid <> 1994
AND wswin = 'Y'
GROUP BY name, yearid
ORDER BY wins DESC


-- 6. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.

SELECT p.namefirst,
p.namelast,
b.sb,
(SELECT b.sb + b.cs FROM batting) AS attempts
FROM people AS p
LEFT JOIN batting AS b
ON p.playerid = b.playerid
WHERE attempts > '20'
AND yearid = 2016

-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

SELECT date_trunc('decade', yearid) AS decade,
ROUND(AVG(so), 2) AS avg_so,
ROUND(AVG(hr),2) AS avg_hr
FROM (
SELECT to_date(yearid::text, 'YYYY') AS yearid,
	so,
	hr
	FROM teams) AS subquery
WHERE yearid > '1919-12-31'
GROUP BY decade
ORDER BY decade

-- average strikeouts have nearly tripled over time, with average home runs not far behind. They both dropped in the 70s and 80s though. Both climbed dramatically in the 1950s.

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.

SELECT
	position,
	SUM(po) AS put_outs
	FROM
	(SELECT
		yearid,
	 	po,
	 	CASE
			WHEN pos = 'OF' THEN 'Outfield'
			WHEN pos = 'SS' THEN 'Infield'
			WHEN pos = '1B' THEN 'Infield'
			WHEN pos = '2B' THEN 'Infield'
			WHEN pos = '3B' THEN 'Infield'
			WHEN pos = 'P' THEN 'Battery'
			WHEN pos = 'C' THEN 'Battery'
			END AS position
			FROM fielding) AS f
--LEFT JOIN people AS p
--ON f.playerid = p.playerid
WHERE yearid = 2016
GROUP BY position
ORDER BY put_outs DESC;

SELECT * FROM fielding

-- 3. Find all the players in the database who played at Vanderbilt University. Create a list showing each player's first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

SELECT
	p.namefirst,
	p.namelast,
	SUM(DISTINCT s.salary::text::money) AS total_salary
FROM people AS p
INNER JOIN collegeplaying AS cp
	ON p.playerid = cp.playerid
INNER JOIN salaries AS s
	ON p.playerid=s.playerid
WHERE schoolid = 'vandy'
GROUP BY p.namelast, p.namefirst
ORDER BY total_salary DESC;

-- The person who made the most and played in the Vanderbilt baseball team is David Price.

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played in?

SELECT
	p.namefirst,
	p.namelast,
	t.name,
	a.g_all,
	p.height
FROM people AS p
LEFT JOIN appearances AS a
ON p.playerid = a.playerid
LEFT JOIN teams AS t
ON a.teamid = t.teamid and a.yearid=t.yearid
ORDER BY p.height

SELECT *
FROM appearances

-- Eddie Gaedel is 43 inches in height, and played 154 games for the St. Louis Browns

-- 1. What range of years for baseball games played does the provided database cover?

select MIN(year),
MAX(year)
FROM homegames

-- The range of games is from 1871 to 2016

-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

--Open-ended questions

-- 10.    Analyze all the colleges in the state of Tennessee. Which college has had the most success in the major leagues. Use whatever metric for success you like - number of players, number of games, salaries, world series wins, etc.

-- 11.    Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.

-- 12.    In this question, you will explore the connection between number of wins and attendance.
 --       Does there appear to be any correlation between attendance at home games and number of wins?
 --       Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.

-- 13.   It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?
