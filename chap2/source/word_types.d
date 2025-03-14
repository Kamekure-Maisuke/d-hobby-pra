module word_types;

import std.string;

struct WordInfo
{
  string word;
  int count;
  string display;

  void calculateDisplay()
  {
    if (count > 10)
      display = word.toUpper();
    else if (count > 5)
      display = "**" ~ word ~ "**";
    else if (count > 2)
      display = "+" ~ word ~ "+";
    else
      display = word;
  }
}