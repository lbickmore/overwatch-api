# Unofficial Overwatch API  
Looking for the [Change Log](#change-log)?  
Or maybe the [Style Guide](#style-rules)?  
[Trello board](https://trello.com/b/t9jG9N3F/overwatch-api)?  
I can't think of anything else you could want from me, if you're still reading this hit me up on [twitter](https://twitter.com/blueshoesyes) I guess <3

## To Do
 * Convert into REST API or something akin to that.

## Completed Features
 * Command line tool to pull data for any user given their user information and system.  
   Ex: `main.rb pc BlueShoesYes 1548` will return with a csv of all my stats :D


## Description
&nbsp;&nbsp;&nbsp;&nbsp;Web Scraper that pulls stats from playoverwatch.com


---

# [Change Log]
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Command Line only file (cli.rb) for testing.

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
