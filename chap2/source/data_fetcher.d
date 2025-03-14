module data_fetcher;

import std.net.curl;
import std.datetime;
import std.conv;
import std.format;
import std.regex;
import std.string;
import std.array;

string generateCurrentMonthUrl()
{
  SysTime time = Clock.currTime();
  string fmtTime = format("%04d%02d", time.year, time.month);
  
  return format(
    "https://raw.githubusercontent.com/Kamekure-Maisuke/todlikelog/refs/heads/main/data/%s.md", 
    fmtTime);
}

string[] fetchAndProcessWords(string url)
{
  string content = get(url).to!string;
  return replaceAll(content, regex("[0-9]+ "), "").splitLines();
}