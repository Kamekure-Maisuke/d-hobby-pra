import std.stdio : writeln;
import std.algorithm;
import std.datetime : SysTime;

// ファイル操作
import std.file;

void main()
{
  string dubConf = "dub.json";
  string filepath = "output.txt";

  // 終了時の処理
  scope (exit)
  {
    // ファイル存在チェック
    assert(exists(filepath));

    // ファイル削除
    remove(filepath);
  }

  // ファイル読み込み
  string content = cast(string) read(dubConf);
  assert(canFind(content, "license") == true);

  // テキストファイル読み込み
  string content2 = readText(dubConf);
  assert(canFind(content2, "license") == true);

  // ファイル書き込み
  write(filepath, "Hello");

  // ファイル追加
  append(filepath, " World");

  // ファイルサイズ
  ulong size = getSize(filepath);
  writeln("ファイルサイズ: ", size, "B");

  // ファイル時刻
  SysTime accessTime, changeTime;
  getTimes(filepath, accessTime, changeTime);
  writeln("アクセス時刻: ", accessTime);
  writeln("変更時刻: ", changeTime);

  // ファイル属性取得
  uint attrs = getAttributes(filepath);
  writeln("属性: ", attrs);

  // ディレクトリ情報
  string dirPath = ".";
  auto entries = dirEntries(dirPath, SpanMode.shallow);
  writeln(entries);
}
