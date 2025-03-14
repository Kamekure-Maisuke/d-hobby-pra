import std.stdio;
import std.algorithm;

import data_fetcher;
import word_analyzer;
import word_types;

void main()
{
  // データURL生成
  string url = generateCurrentMonthUrl();
  
  // データ取得
  string[] words = fetchAndProcessWords(url);
  
  // 単語カウント
  WordInfo[string] wordCount = countWords(words);
  
  // ソート
  WordInfo[] sortedWords = sortWordsByCount(wordCount);
  
  // 表示
  displayResults(sortedWords);
}

/**
 * 表示
 */
void displayResults(WordInfo[] sortedWords)
{
  writeln("\n===== 登場回数 =====");
  
  foreach (info; sortedWords[0 .. min(20, $)])
  {
    writefln("%s (%d回)", info.display, info.count);
  }
}