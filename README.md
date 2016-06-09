# Unofficial Overwatch API  
Looking for the [Change Log](#change-log)?  
Or maybe the [Style Guide](#style-rules)?  
[Trello board](https://trello.com/b/t9jG9N3F/overwatch-api)?  
I can't think of anything else you could want from me, if you're still reading this hit me up on [twitter](https://twitter.com/blueshoesyes) I guess <3

## Usage
 * There is a server that is live for testing, the following `GET` requests will work
  * For PC accounts: `192.241.220.104:8080/stats/<battle_net_id>-<number>` 
  * For PSN and XBL: `192.241.220.104:8080/stats/<battle_net_id>`
  * To select specific heroes append `/<hero_name>` to the end
  * If a hero is specified you may also pass the option `stat=<stat>` if you happen to know the specific stat you wish to return.
  * Finally a functional example: `192.241.220.104:8080/stats/BlueShoesYes-1548/Widowmaker?stat=Shots%20Fired`

## To Do 
 * See [Trello](https://trello.com/b/t9jG9N3F/overwatch-api)?  

## Completed Features - Periodically Updated from Trello
 * Command line tool to pull data for any user given their user information and system.  
   Ex: `cli.rb pc BlueShoesYes 1548` will return with a csv of all my stats :D
 * system_type no longer required! Input is determined based on lack of battlenet ID #. At the moment this will return the first name that matches Playstation then Xbox. Potential further work required.


## Description
&nbsp;&nbsp;&nbsp;&nbsp;Web Scraper that pulls stats from playoverwatch.com


---

# [Change Log]
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [0.0.7] - 2016-06-08
### Added
- rspec tests for `battle_net_id` method out of main.rb, more to come.
- install.sh - includes basic systemd service.
- Small usage section in README.md


### Changed
- Directories have been created. Code has been moved to `/lib`
- `battle_net_id` method to check given strings against redis prior to scraping playoverwatch.com blindly.

## [0.0.6] - 2016-06-06
### Changed
- server.rb and main.rb account for a server hosting change. When running server.rb a password for the redis server is required.

## [0.0.5] - 2016-06-03
### Added
- server.rb - sinatra server for http api access.
- Proper `get_stats` function to grab stats from the database and return a JSON string.
- `data_dump` function to return entire database to JSON string.
- `in_database?` function to check for user id's in the server already.

### Changed
- `get_stats` function name to `crawl_stats`
- All redis calls in functions are recycled calls of a global variable vs declaring the same server each time.

### Fixed
- Unicode variable names to plain ASCII characters for the sake of easy API usage. 

## [0.0.4] - 2016-05-31
### Added
- `battle_net_id` function to main.rb

### Changed
- `get_stats` function in main.rb to account for `battle_net_id`

## [0.0.3] - 2016-05-28
### Added
- cli.rb - Command Line only tool for testing.

### Changed
- main.rb has a get_stats function.

## [0.0.2] - 2016-05-28
### Added
- (finished) script that can pull data for any user.

## [0.0.1] - 2016-05-27
### Added
- Changelog to README.md.

## [0.0.0] - 2016-05-26
### Added
- main.rb - pulls data from site and prints all info out ( not sorted )
- README.md as placeholder

<br>
<br>

---

# Style Rules
From [Keep A Changelog](http://keepachangelog.com/)  
Also useful [Markdown Cheatsheet](github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)  

--

<ul> <li>It’s made for humans, not machines, so legibility is crucial.</li>
<li>Easy to link to any section (hence Markdown over plain text).</li>
<li>One sub-section per version.</li> <li>List releases in reverse-chronological order (newest on top).</li>
<li>Write all dates in <code>YYYY-MM-DD</code> format. (Example: <code>2012-06-02</code> for <code>June 2nd, 2012</code>.) It’s international, <a href="http://xkcd.com/1179/">sensible</a>, and language-independent.</li>
<li>Explicitly mention whether the project follows <a href="http://semver.org/">Semantic Versioning</a>.</li>
<li>Each version should: <ul>
<li>List its release date in the above format.</li>
<li>Group changes to describe their impact on the project, as follows:</li>
<li><code>Added</code> for new features.</li>
<li><code>Changed</code> for changes in existing functionality.</li>
<li><code>Deprecated</code> for once-stable features removed in upcoming releases.</li>
<li><code>Removed</code> for deprecated features removed in this release.</li>
<li><code>Fixed</code> for any bug fixes.</li>
<li><code>Security</code> to invite users to upgrade in case of vulnerabilities.</li> </ul></li> </ul>
