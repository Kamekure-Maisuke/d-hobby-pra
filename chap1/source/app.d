import std.stdio;
import std.algorithm;
import std.array;
import std.datetime;
import std.format;
import std.net.curl;
import std.conv;
import std.string;

/** 
 * 最頻出単語取得
 * Params:
 *   strings = 
 * Returns: 
 */
T mostFrequentWord(T)(T[] strings) if (is(T == string))
{
  size_t[string] wordCount;

  foreach (str; strings)
  {
    foreach (word; str.split)
    {
      wordCount[word] = word in wordCount ? wordCount[word] + 1 : 1;
    }
  }

  return wordCount.byKeyValue
    .array
    .sort!((a, b) => a.value > b.value)
    .front
    .key;
}

void main()
{
  SysTime time = Clock.currTime();
  string fmtTime = format("%04d%02d", time.year, time.month);

  // 今月のデータ取得
  string url = format(
    "https://raw.githubusercontent.com/Kamekure-Maisuke/todlikelog/refs/heads/main/data/%s.md", fmtTime);
  string content = get(url).to!string;
  string[] data = splitLines(content);

  // 出力
  writeln("今月の人気No1: ", mostFrequentWord(data));
}
