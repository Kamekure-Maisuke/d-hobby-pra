import std.stdio;

// 比較系
import std.algorithm.comparison;

// イテレーション系
import std.algorithm.iteration;
import std.array;

// 検索系
import std.algorithm.searching;

void main()
{
  writeln("test");
}

// 比較系のテスト
unittest
{
  // 等価
  int[] a = [3, 4, 5];
  int[] b = [3, 4];
  int[] c = [3, 4, 5];
  assert(equal(a, b) == false);
  assert(equal(a, c) == true);

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

// イテレーション系のテスト
unittest
{
  int[] scores = [3, 4, 5];

  // 「関数適用」
  // Dのmapはarray型ではなくrangeを返す。遅延評価。
  // 中間配列を作らないため。計算効率の観点から。
  // 最後のarray呼び出しで初めて実際の計算が実行。std.arrayのimportが必要。
  // パイプラインで繋げられたりできる。takeで数を指定できたりする。
  auto doubleScores = scores.map!(s => s * 2);
  assert(doubleScores.array == [6, 8, 10]);

  // 抽出
  auto evens = scores.filter!(s => s % 2 == 0);
  assert(evens.array == [4]);

  // 累積処理
  // 別途foldもある。
  auto sum = reduce!"a + b"(scores);
  assert(sum == 12);

  // 連結
  // 例: 2次元配列を1次元化
  int[][] sheets = [[1, 1], [1, 2], [1, 3]];
  auto joined = sheets.joiner;
  assert(joined.array == [1, 1, 1, 2, 1, 3]);

  // 文字列連結
  string[] members = ["白石麻衣", "橋本奈々美", "松村沙友理"];
  auto joinedMember = members.joiner(" ");
  assert(joinedMember.array == "白石麻衣 橋本奈々美 松村沙友理");

  // 別途chunkByも。
}

// 検索系のテスト
unittest
{
  int[] scores = [1,2,3,4,5];
  string text = "白石麻衣";

  // 要素が含まれているか
  // 関数とテンプレートがあり、テンプレートは条件で検索。
  assert(canFind(scores, 4) == true);
  assert(canFind(scores, 6) == false);
  assert(canFind(text, "白") == true);
  assert(canFind!(a => a > 3)(scores) == true);
  assert(canFind!(a => a > 5)(scores) == false);

  // 要素で分割
  auto split = findSplit(scores, [3]);
  assert(split[0] == [1,2]);
  assert(split[1] == [3]);
}