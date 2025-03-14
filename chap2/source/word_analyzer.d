module word_analyzer;

import std.algorithm;
import std.array;

import word_types;


/**
 * 登場回数をカウント
 */
WordInfo[string] countWords(string[] words)
{
  WordInfo[string] wordCount;
  
  foreach (word; words)
  {
    if (word in wordCount)
      wordCount[word].count++;
    else
      wordCount[word] = WordInfo(word, 1);
  }
  
  // 登場回数によって表示形式を計算
  foreach (ref info; wordCount)
  {
    info.calculateDisplay();
  }
  
  return wordCount;
}

/**
 * 登場回数でソート
 */
WordInfo[] sortWordsByCount(WordInfo[string] wordCount)
{
  return wordCount.values.array.sort!((a, b) => a.count > b.count).array;
}