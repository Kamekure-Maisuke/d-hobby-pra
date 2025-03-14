import std.stdio;

// 比較系
import std.algorithm.comparison;

void main()
{
  writeln("test");
}

// 比較系のテスト
unittest
{
  // 等価
  int[] a = [3,4,5];
  int[] b = [3,4];
  int[] c = [3,4,5];
  assert(equal(a,b) == false);
  assert(equal(a,c) == true);

  // 比較結果
  assert(cmp("Hello", "hello") != 0);
  assert(cmp("hello", "hello") == 0);

  // 指定範囲内
  assert(clamp(3, 1, 4) == 3);
  assert(clamp(3, 1, 2) == 2);

  // 最大値または最小値
  assert(max(a[0], a[1], a[2]) == 5);
  assert(min(a[0], a[1], a[2]) == 3);

  // 選択肢の中にあるか確認。switch同様の処理も可能。
  string msg = "こんにちは";
  assert(msg.among("おはよう", "こんにちは", "こんばんは"));
}