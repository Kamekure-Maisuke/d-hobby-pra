# D言語 std.file と std.functional 総合ガイド

## 第1部: std.file モジュール

`std.file` モジュールはファイルとディレクトリの操作に関する様々な機能を提供します。このモジュールを使用することで、ファイルの読み書き、ディレクトリの作成・削除、パーミッションの変更など、ファイルシステムに関連する多くの操作を簡単に行うことができます。

### 1. ファイルの読み書き

#### 1.1 ファイルの読み込み

##### `read` 関数

ファイルの内容を全て読み込みます。テキストファイルでもバイナリファイルでも読み込むことができます。

```d
import std.file : read;
import std.stdio : writeln;

void main() {
    // テキストファイルを文字列として読み込む
    string content = cast(string)read("example.txt");
    writeln(content);
    
    // バイナリファイルをバイト配列として読み込む
    ubyte[] binaryData = cast(ubyte[])read("example.bin");
    writeln("バイナリファイルサイズ: ", binaryData.length, " バイト");
}
```

##### `readText` 関数

ファイルをテキストとして読み込みます。エンコーディングを指定することも可能です。

```d
import std.file : readText;
import std.stdio : writeln;

void main() {
    // デフォルトのエンコーディングでテキストファイルを読み込む
    string content = readText("example.txt");
    writeln(content);
    
    // UTF-8エンコーディングを明示的に指定
    import std.encoding : EncodingScheme;
    string content2 = readText("example.txt", "utf-8");
    writeln(content2);
}
```

#### 1.2 ファイルへの書き込み

##### `write` 関数

データをファイルに書き込みます。テキストもバイナリも書き込めます。

```d
import std.file : write;
import std.stdio : writeln;

void main() {
    // テキストファイルに書き込む
    write("output.txt", "Hello, D Language!");
    writeln("テキストファイルへの書き込みが完了しました");
    
    // バイナリデータを書き込む
    ubyte[] data = [0x44, 0x4C, 0x61, 0x6E, 0x67]; // "DLang" in ASCII
    write("output.bin", data);
    writeln("バイナリファイルへの書き込みが完了しました");
}
```

##### `append` 関数

既存のファイルにデータを追加します。

```d
import std.file : append;
import std.stdio : writeln;

void main() {
    // ファイルに追加書き込み
    append("log.txt", "新しいログエントリ\n");
    writeln("ログに追加しました");
}
```

### 2. ファイルとディレクトリの操作

#### 2.1 ファイル操作

##### `exists` 関数

ファイルやディレクトリが存在するかどうかを確認します。

```d
import std.file : exists;
import std.stdio : writeln;

void main() {
    string filePath = "config.ini";
    if (exists(filePath)) {
        writeln(filePath, " は存在します");
    } else {
        writeln(filePath, " は存在しません");
    }
}
```

##### `rename` 関数

ファイルの名前を変更または移動します。

```d
import std.file : rename, exists;
import std.stdio : writeln;

void main() {
    string oldPath = "old_name.txt";
    string newPath = "new_name.txt";
    
    if (exists(oldPath)) {
        rename(oldPath, newPath);
        writeln("ファイル名を変更しました: ", oldPath, " → ", newPath);
    }
}
```

##### `remove` 関数

ファイルやディレクトリを削除します。

```d
import std.file : remove, exists;
import std.stdio : writeln;

void main() {
    string filePath = "temp.txt";
    
    if (exists(filePath)) {
        remove(filePath);
        writeln("ファイルを削除しました: ", filePath);
    }
}
```

##### `copy` 関数

ファイルをコピーします。

```d
import std.file : copy, exists;
import std.stdio : writeln;

void main() {
    string sourcePath = "source.txt";
    string destPath = "destination.txt";
    
    if (exists(sourcePath)) {
        copy(sourcePath, destPath);
        writeln("ファイルをコピーしました: ", sourcePath, " → ", destPath);
    }
}
```

#### 2.2 ディレクトリ操作

##### `mkdir` 関数

新しいディレクトリを作成します。

```d
import std.file : mkdir, exists;
import std.stdio : writeln;

void main() {
    string dirPath = "new_directory";
    
    if (!exists(dirPath)) {
        mkdir(dirPath);
        writeln("ディレクトリを作成しました: ", dirPath);
    }
}
```

##### `mkdirRecurse` 関数

パスに含まれる全てのディレクトリを再帰的に作成します。

```d
import std.file : mkdirRecurse, exists;
import std.stdio : writeln;

void main() {
    string nestedPath = "parent/child/grandchild";
    
    if (!exists(nestedPath)) {
        mkdirRecurse(nestedPath);
        writeln("ディレクトリ階層を作成しました: ", nestedPath);
    }
}
```

##### `rmdir` 関数

空のディレクトリを削除します。

```d
import std.file : rmdir, exists;
import std.stdio : writeln;

void main() {
    string dirPath = "empty_directory";
    
    if (exists(dirPath)) {
        rmdir(dirPath);
        writeln("ディレクトリを削除しました: ", dirPath);
    }
}
```

##### `rmdirRecurse` 関数

ディレクトリとその中身を再帰的に削除します。

```d
import std.file : rmdirRecurse, exists;
import std.stdio : writeln;

void main() {
    string dirPath = "project_backup";
    
    if (exists(dirPath)) {
        rmdirRecurse(dirPath);
        writeln("ディレクトリとその内容を削除しました: ", dirPath);
    }
}
```

### 3. ファイル情報の取得

#### 3.1 基本的なファイル情報

##### `getSize` 関数

ファイルのサイズをバイト単位で取得します。

```d
import std.file : getSize, exists;
import std.stdio : writeln;

void main() {
    string filePath = "document.pdf";
    
    if (exists(filePath)) {
        ulong fileSize = getSize(filePath);
        writeln("ファイルサイズ: ", fileSize, " バイト");
        writeln("キロバイト単位: ", fileSize / 1024.0, " KB");
        writeln("メガバイト単位: ", fileSize / (1024.0 * 1024.0), " MB");
    }
}
```

##### `getTimes` 関数

ファイルの作成時刻、最終アクセス時刻、最終更新時刻を取得します。

```d
import std.file : getTimes, exists;
import std.stdio : writeln;
import std.datetime : SysTime;

void main() {
    string filePath = "report.docx";
    
    if (exists(filePath)) {
        SysTime accessTime, modificationTime, changeTime;
        getTimes(filePath, accessTime, modificationTime, changeTime);
        
        writeln("最終アクセス時刻: ", accessTime);
        writeln("最終更新時刻: ", modificationTime);
        writeln("最終変更時刻: ", changeTime);
    }
}
```

##### `getAttributes` と `setAttributes` 関数

ファイルの属性を取得・設定します。

```d
import std.file : getAttributes, setAttributes, exists;
import std.stdio : writeln;

void main() {
    string filePath = "important.dat";
    
    if (exists(filePath)) {
        uint attrs = getAttributes(filePath);
        writeln("現在の属性: ", attrs);
        
        // 読み取り専用属性を設定
        import core.sys.windows.winnt : FILE_ATTRIBUTE_READONLY;
        setAttributes(filePath, attrs | FILE_ATTRIBUTE_READONLY);
        writeln("読み取り専用に設定しました");
    }
}
```

#### 3.2 詳細なファイル情報

##### `DirEntry` 構造体

ファイルやディレクトリに関する詳細情報を提供します。

```d
import std.file : DirEntry, dirEntries, SpanMode;
import std.stdio : writeln;

void main() {
    string dirPath = ".";
    
    foreach (DirEntry entry; dirEntries(dirPath, SpanMode.shallow)) {
        writeln("名前: ", entry.name);
        writeln("  サイズ: ", entry.size, " バイト");
        writeln("  ディレクトリか?: ", entry.isDir);
        writeln("  ファイルか?: ", entry.isFile);
        writeln("  シンボリックリンクか?: ", entry.isSymlink);
        writeln("  最終更新時刻: ", entry.timeLastModified);
        writeln();
    }
}
```

### 4. ディレクトリの探索

#### 4.1 `dirEntries` 関数

ディレクトリ内のファイルとサブディレクトリを列挙します。

```d
import std.file : dirEntries, SpanMode;
import std.stdio : writeln;
import std.path : baseName;

void main() {
    string dirPath = ".";
    
    // 現在のディレクトリ内のファイルとディレクトリを浅く探索
    writeln("現在のディレクトリの内容:");
    foreach (entry; dirEntries(dirPath, SpanMode.shallow)) {
        writeln("  ", baseName(entry.name));
    }
    
    // 再帰的に全てのファイルとディレクトリを深く探索
    writeln("\n再帰的なディレクトリ探索:");
    foreach (entry; dirEntries(dirPath, SpanMode.depth)) {
        writeln("  ", entry.name);
    }
    
    // 特定のパターンに一致するファイルのみを探索
    writeln("\n.txtファイルのみ:");
    foreach (entry; dirEntries(dirPath, "*.txt", SpanMode.depth)) {
        writeln("  ", entry.name);
    }
}
```

#### 4.2 特定の条件でのファイル検索

特定の条件に一致するファイルを検索するカスタム関数の例です。

```d
import std.file : dirEntries, SpanMode, DirEntry;
import std.stdio : writeln;
import std.algorithm : filter, map, sort;
import std.array : array;
import std.datetime : SysTime, Clock, days;

// 最近更新されたファイルを見つける
void findRecentFiles(string dirPath, int days) {
    // 指定日数以内に更新されたファイルを見つける
    auto cutoffTime = Clock.currTime() - days.days;
    
    auto recentFiles = dirEntries(dirPath, SpanMode.depth)
        .filter!(entry => entry.isFile)
        .filter!(entry => entry.timeLastModified > cutoffTime)
        .array;
    
    // 更新時刻で降順ソート
    import std.algorithm : sort;
    sort!((a, b) => a.timeLastModified > b.timeLastModified)(recentFiles);
    
    writeln("過去 ", days, " 日間に更新されたファイル:");
    foreach (file; recentFiles) {
        writeln("  ", file.name, " (", file.timeLastModified, ")");
    }
}

// 大きなファイルを見つける
void findLargeFiles(string dirPath, ulong minSizeKB) {
    auto largeFiles = dirEntries(dirPath, SpanMode.depth)
        .filter!(entry => entry.isFile)
        .filter!(entry => entry.size > minSizeKB * 1024)
        .array;
    
    // サイズで降順ソート
    import std.algorithm : sort;
    sort!((a, b) => a.size > b.size)(largeFiles);
    
    writeln(minSizeKB, "KB 以上のファイル:");
    foreach (file; largeFiles) {
        writefln("  %s (%.2f MB)", file.name, file.size / (1024.0 * 1024.0));
    }
}

void main() {
    string dirPath = ".";
    
    // 過去7日間に更新されたファイルを検索
    findRecentFiles(dirPath, 7);
    
    // 1MB以上のファイルを検索
    findLargeFiles(dirPath, 1024);
}
```

### 5. 実践的な使用例

#### 5.1 簡易ファイルバックアップツール

```d
import std.file;
import std.stdio : writeln;
import std.path : buildPath, baseName, dirName;
import std.datetime : Clock;
import std.conv : to;

void backupFile(string filePath, string backupDir) {
    if (!exists(filePath)) {
        writeln("エラー: ファイルが存在しません: ", filePath);
        return;
    }
    
    // バックアップディレクトリがなければ作成
    if (!exists(backupDir)) {
        mkdirRecurse(backupDir);
        writeln("バックアップディレクトリを作成しました: ", backupDir);
    }
    
    // タイムスタンプを含むバックアップファイル名を生成
    string timestamp = Clock.currTime().toISOExtString()
        .replace(":", "-").replace(".", "-");
    
    string fileName = baseName(filePath);
    string backupFileName = fileName ~ "." ~ timestamp ~ ".bak";
    string backupPath = buildPath(backupDir, backupFileName);
    
    // ファイルをバックアップ
    copy(filePath, backupPath);
    writeln("ファイルをバックアップしました: ", filePath, " → ", backupPath);
}

void main() {
    // 設定ファイルをバックアップ
    string configFile = "config.ini";
    string backupDir = "backups";
    
    backupFile(configFile, backupDir);
}
```

#### 5.2 ディレクトリサイズ計算ツール

```d
import std.file : dirEntries, SpanMode, DirEntry, exists;
import std.stdio : writeln, writefln;
import std.path : baseName;
import std.algorithm : sort;
import std.array : array;

// ディレクトリのサイズを計算
ulong calculateDirSize(string dirPath) {
    if (!exists(dirPath))
        return 0;
    
    ulong totalSize = 0;
    
    foreach (DirEntry entry; dirEntries(dirPath, SpanMode.depth)) {
        if (entry.isFile) {
            totalSize += entry.size;
        }
    }
    
    return totalSize;
}

// 人間が読みやすいサイズ表記に変換
string humanReadableSize(ulong size) {
    string[] units = ["B", "KB", "MB", "GB", "TB"];
    int unitIndex = 0;
    double sizeValue = cast(double)size;
    
    while (sizeValue >= 1024.0 && unitIndex < units.length - 1) {
        sizeValue /= 1024.0;
        unitIndex++;
    }
    
    import std.format : format;
    return format("%.2f %s", sizeValue, units[unitIndex]);
}

// ディレクトリのサイズ内訳を表示
void printDirSizes(string baseDir) {
    // 最上位のサブディレクトリを取得
    auto subDirs = dirEntries(baseDir, SpanMode.shallow)
        .filter!(entry => entry.isDir)
        .array;
    
    // サイズ情報を収集
    struct DirInfo {
        string path;
        ulong size;
    }
    
    DirInfo[] dirInfos;
    
    foreach (dir; subDirs) {
        ulong size = calculateDirSize(dir.name);
        dirInfos ~= DirInfo(dir.name, size);
    }
    
    // サイズで降順ソート
    sort!((a, b) => a.size > b.size)(dirInfos);
    
    // 結果を表示
    writeln("ディレクトリサイズ内訳:");
    writeln("----------------------");
    
    ulong totalSize = calculateDirSize(baseDir);
    
    foreach (info; dirInfos) {
        double percentage = totalSize > 0 ? (cast(double)info.size / totalSize) * 100.0 : 0.0;
        writefln("%s: %s (%.1f%%)", baseName(info.path), humanReadableSize(info.size), percentage);
    }
    
    writeln("----------------------");
    writefln("合計: %s", humanReadableSize(totalSize));
}

void main() {
    string dirToAnalyze = ".";
    printDirSizes(dirToAnalyze);
}
```

#### 5.3 ファイル変更監視ツール

```d
import std.file : DirEntry, dirEntries, SpanMode, timeLastModified, exists;
import std.stdio : writeln;
import std.datetime : SysTime, Clock, seconds;
import std.path : baseName;
import core.thread : Thread, dur;
import std.algorithm : filter, map;
import std.array : assocArray;

void watchDirectory(string dirPath, int intervalSeconds) {
    // 初期ファイル状態を記録
    SysTime[string] lastModified;
    
    foreach (DirEntry entry; dirEntries(dirPath, SpanMode.shallow).filter!(e => e.isFile)) {
        lastModified[entry.name] = entry.timeLastModified;
    }
    
    writeln("ディレクトリの監視を開始します: ", dirPath);
    writeln("Ctrl+Cで終了してください");
    
    while (true) {
        // 指定された間隔で待機
        Thread.sleep(dur!("seconds")(intervalSeconds));
        
        // 現在のファイル状態を取得
        SysTime[string] currentModified;
        
        foreach (DirEntry entry; dirEntries(dirPath, SpanMode.shallow).filter!(e => e.isFile)) {
            currentModified[entry.name] = entry.timeLastModified;
        }
        
        // 変更を検出
        // 新しいファイル
        foreach (fileName, modTime; currentModified) {
            if (fileName !in lastModified) {
                writeln("新しいファイル: ", baseName(fileName));
            } else if (modTime > lastModified[fileName]) {
                writeln("更新されたファイル: ", baseName(fileName));
            }
        }
        
        // 削除されたファイル
        foreach (fileName, modTime; lastModified) {
            if (fileName !in currentModified) {
                writeln("削除されたファイル: ", baseName(fileName));
            }
        }
        
        // 状態を更新
        lastModified = currentModified.dup;
    }
}

void main() {
    string dirToWatch = ".";
    int checkInterval = 5; // 秒単位
    
    watchDirectory(dirToWatch, checkInterval);
}
```

## 第2部: std.functional モジュール

`std.functional` モジュールは関数型プログラミングのための様々なツールを提供します。このモジュールを使用することで、関数の合成、部分適用、メモ化、高階関数の操作などが可能になります。

### 1. 基本概念

#### 1.1 関数オブジェクトと関数合成

##### `pipe` 関数

複数の関数を合成して新しい関数を作成します。

```d
import std.functional : pipe;
import std.stdio : writeln;
import std.conv : to;
import std.algorithm : map;
import std.array : array;

// 二乗する関数
int square(int x) {
    return x * x;
}

// 数値を文字列に変換する関数
string toString(int x) {
    return "値: " ~ x.to!string;
}

void main() {
    // square関数とtoString関数を合成
    auto squareAndToString = pipe!(square, toString);
    
    writeln(squareAndToString(5)); // "値: 25"
    
    // 複数の値に適用
    int[] numbers = [1, 2, 3, 4, 5];
    auto results = numbers.map!squareAndToString.array;
    
    foreach (result; results) {
        writeln(result);
    }
}
```

##### `compose` 関数

`pipe` と似ていますが、関数の適用順序が逆になります。

```d
import std.functional : compose;
import std.stdio : writeln;

// 値を二倍にする
int twice(int x) {
    return x * 2;
}

// 値に1を加える
int plusOne(int x) {
    return x + 1;
}

void main() {
    // compose: g(f(x)) の順で適用される
    auto twiceThenPlusOne = compose!(plusOne, twice);
    writeln("compose(plusOne, twice)(3) = ", twiceThenPlusOne(3)); // (3*2)+1 = 7
    
    // 逆の順序で合成
    auto plusOneThenTwice = compose!(twice, plusOne);
    writeln("compose(twice, plusOne)(3) = ", plusOneThenTwice(3)); // (3+1)*2 = 8
}
```

#### 1.2 関数のラッピングと変換

##### `toDelegate` 関数

関数ポインタを委譲（デリゲート）に変換します。

```d
import std.functional : toDelegate;
import std.stdio : writeln;

// グローバル関数
void globalFunc(int x) {
    writeln("グローバル関数: ", x);
}

void main() {
    // 関数ポインタを委譲に変換
    auto delegateFunc = toDelegate(&globalFunc);
    
    // 委譲として呼び出し
    delegateFunc(42);
}
```

##### `memoize` 関数

関数呼び出しの結果をキャッシュして計算を効率化します。

```d
import std.functional : memoize;
import std.stdio : writeln;
import core.time : MonoTime;

// 再帰的なフィボナッチ数列の計算（非効率な実装）
ulong fibonacci(ulong n) {
    if (n < 2) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}

// memoizeを使用して最適化
alias memoFib = memoize!(fibonacci);

void main() {
    writeln("通常のフィボナッチ関数:");
    
    auto start1 = MonoTime.currTime;
    auto result1 = fibonacci(35);
    auto end1 = MonoTime.currTime;
    
    writeln("fibonacci(35) = ", result1);
    writeln("計算時間: ", (end1 - start1).total!"msecs", " ミリ秒");
    
    writeln("\nmemoize最適化されたフィボナッチ関数:");
    
    auto start2 = MonoTime.currTime;
    auto result2 = memoFib(35);
    auto end2 = MonoTime.currTime;
    
    writeln("memoFib(35) = ", result2);
    writeln("計算時間: ", (end2 - start2).total!"msecs", " ミリ秒");
}
```

### 2. 関数の部分適用と束縛

#### 2.1 `partial` 関数

関数の一部の引数を固定して新しい関数を作成します。

```d
import std.functional : partial;
import std.stdio : writeln;

// 3つの引数を取る関数
int add3(int a, int b, int c) {
    return a + b + c;
}

void main() {
    // 最初の引数を10に固定
    auto add3_10 = partial!(add3, 10);
    writeln("add3_10(20, 30) = ", add3_10(20, 30)); // 10 + 20 + 30 = 60
    
    // 最初の2つの引数を10と20に固定
    auto add3_10_20 = partial!(add3, 10, 20);
    writeln("add3_10_20(30) = ", add3_10_20(30)); // 10 + 20 + 30 = 60
}
```

#### 2.2 `curry` 関数

複数の引数を取る関数を、一度に1つの引数を取る連続した関数に変換します。

```d
import std.functional : curry;
import std.stdio : writeln;

// 3つの引数を取る関数
int multiply3(int a, int b, int c) {
    return a * b * c;
}

void main() {
    // カリー化された関数を作成
    auto curriedMultiply = curry!multiply3;
    
    // 一度に1つの引数を適用
    auto step1 = curriedMultiply(2);
    auto step2 = step1(3);
    auto result = step2(4);
    
    writeln("2 * 3 * 4 = ", result); // 24
    
    // 連鎖的に呼び出すこともできる
    writeln("5 * 6 * 7 = ", curriedMultiply(5)(6)(7)); // 210
}
```

#### 2.3 `bind` 関数

特定の位置の引数を値に束縛します。`_`（プレースホルダー）を使用して束縛しない引数を指定できます。

```d
import std.functional : bind, _;
import std.stdio : writeln;

// 除算関数
double divide(double a, double b) {
    return a / b;
}

// 3つの値から最大値を求める関数
int maxOfThree(int a, int b, int c) {
    return max(max(a, b), c);
}

void main() {
    // 除算の第2引数を2に束縛（半分にする）
    auto halve = bind!(divide, _, 2);
    writeln("halve(10) = ", halve(10)); // 10 / 2 = 5
    
    // 第1引数を10に束縛（10を何かで割る）
    auto divideFrom10 = bind!(divide, 10, _);
    writeln("divideFrom10(2) = ", divideFrom10(2)); // 10 / 2 = 5
    
    // 複数の引数を持つ関数の例
    import std.algorithm : max;
    
    // 最初と最後の引数を100に束縛
    auto maxWith100 = bind!(maxOfThree, 100, _, 100);
    writeln("maxWith100(50) = ", maxWith100(50)); // max(100, 50, 100) = 100
    writeln("maxWith100(150) = ", maxWith100(150)); // max(100, 150, 100) = 150
}
```

### 3. 関数のユーティリティ

#### 3.1 `binaryFun` と `unaryFun`

文字列から一項または二項演算子関数を作成します。

```d
import std.functional : binaryFun, unaryFun;
import std.stdio : writeln;
import std.algorithm : map, filter, sort;
import std.array : array;

void main() {
    int[] numbers = [5, 2, 8, 1, 7, 3];
    
    // binaryFunの使用例: 降順ソート
    auto sortedDesc = numbers.dup.sort!(binaryFun!("a > b")).array;
    writeln("降順ソート: ", sortedDesc);
    
    // unaryFunの使用例: 偶数のフィルタリング
    auto evenNumbers = numbers.filter!(unaryFun!("a % 2 == 0")).array;
    writeln("偶数: ", evenNumbers);
    
    // 二乗する関数の作成と適用
    auto squares = numbers.map!(unaryFun!("a * a")).array;
    writeln("二乗値: ", squares);
    
    // 複数の演算子を組み合わせる
    auto complexOperation = numbers
        .filter!(unaryFun!("a > 3"))      // 3より大きい値をフィルタリング
        .map!(unaryFun!("a * 2 - 1"))     // 2倍して1を引く
        .array;
    
    writeln("複合操作結果: ", complexOperation);
}
```

#### 3.2 `adjoin` 関数

複数の関数の結果をタプルとして返す新しい関数を作成します。

```d
import std.functional : adjoin;
import std.stdio : writeln;
import std.typecons : tuple;

// 合計を計算する関数
int sum(int[] arr) {
    int result = 0;
    foreach (x; arr) result += x;
    return result;
}

// 平均を計算する関数
double average(int[] arr) {
    if (arr.length == 0) return 0.0;
    return cast(double)sum(arr) / arr.length;
}

// 最小値を返す関数
int minimum(int[] arr) {
    if (arr.length == 0) return int.max;
    int minVal = arr[0];
    foreach (x; arr) {
        if (x < minVal) minVal = x;
    }
    return minVal;
}

// 最大値を返す関数
int maximum(int[] arr) {
    if (arr.length == 0) return int.min;
    int maxVal = arr[0];
    foreach (x; arr) {
        if (x > maxVal) maxVal = x;
    }
    return maxVal;
}

void main() {
    int[] data = [4, 7, 2, 9, 5, 1, 8, 3, 6];
    
    // 合計、平均、最小値、最大値を一度に計算
    auto statsFunc = adjoin!(sum, average, minimum, maximum);
    auto stats = statsFunc(data);
    
    writeln("統計情報:");
    writeln("  合計: ", stats[0]);
    writeln("  平均: ", stats[1]);
    writeln("  最小値: ", stats[2]);
    writeln("  最大値: ", stats[3]);
}
```

#### 3.3 `forward` テンプレート

引数を関数に転送（フォワーディング）します。これは元の型情報を維持するのに役立ちます。

```d
import std.functional : forward;
import std.stdio : writeln;

// 引数の型情報を表示する関数
void showTypeInfo(T)(T param) {
    import std.traits : fullyQualifiedName;
    writeln("型: ", fullyQualifiedName!T);
    static if (is(T == int)) {
        writeln("整数型です");
    } else static if (is(T == string)) {
        writeln("文字列型です");
    } else {
        writeln("その他の型です");
    }
}

// 引数を転送する関数
void forwardingWrapper(T)(T arg) {
    writeln("ラッパー関数内:");
    showTypeInfo(forward!arg);  // 型情報を保持して転送
}

void main() {
    int x = 42;
    string s = "Hello";
    
    writeln("直接呼び出し:");
    showTypeInfo(x);
    showTypeInfo(s);
    
    writeln("\nフォワーディング経由:");
    forwardingWrapper(x);
    forwardingWrapper(s);
}
```

### 4. 高度な関数型プログラミング

#### 4.1 関数合成のチェーン

複数の関数合成を連鎖させる例です。

```d
import std.functional : compose, pipe, binaryFun, unaryFun;
import std.algorithm : map, filter;
import std.array : array;
import std.stdio : writeln;
import std.conv : to;

// 整数のリストから偶数だけを抽出して二乗し、文字列に変換する
string[] processNumbers(int[] numbers) {
    // 関数を個別に定義
    auto filterEvens = (int[] nums) => nums.filter!(n => n % 2 == 0).array;
    auto square = (int[] nums) => nums.map!(n => n * n).array;
    auto toString = (int[] nums) => nums.map!(n => n.to!string).array;
    
    // pipeを使用して関数を合成
    auto process = pipe!(filterEvens, square, toString);
    return process(numbers);
}

void main() {
    int[] data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    
    auto result = processNumbers(data);
    writeln("処理結果: ", result); // ["4", "16", "36", "64", "100"]
    
    // 同じ処理をSTLスタイルで
    auto result2 = data
        .filter!(n => n % 2 == 0)
        .map!(n => n * n)
        .map!(n => n.to!string)
        .array;
    
    writeln("STLスタイル処理結果: ", result2);
}
```

#### 4.2 `memoize` の詳細な使用例

複雑な計算をメモ化（結果をキャッシュ）する例です。

```d
import std.functional : memoize;
import std.stdio : writeln;
import core.time : MonoTime;

// 非常に重い計算を行う関数
double heavyComputation(int x, double y) {
    import std.math : sin, cos, sqrt, pow;
    import core.thread : Thread;
    import core.time : dur;
    
    // 計算が重いことをシミュレート
    Thread.sleep(dur!("msecs")(100));
    
    double result = 0;
    for (int i = 0; i < 1000; i++) {
        result += sin(x * i) * cos(y * i) / sqrt(pow(i, 2) + 1);
    }
    
    return result;
}

// メモ化バージョンの関数
alias memoizedComputation = memoize!(heavyComputation);

void main() {
    // メモ化なしでの呼び出し
    writeln("メモ化なし:");
    
    auto start1 = MonoTime.currTime;
    auto result1 = heavyComputation(5, 2.5);
    auto result2 = heavyComputation(5, 2.5); // 同じ引数で再計算
    auto end1 = MonoTime.currTime;
    
    writeln("結果: ", result1);
    writeln("経過時間: ", (end1 - start1).total!"msecs", " ミリ秒");
    
    // メモ化ありでの呼び出し
    writeln("\nメモ化あり:");
    
    auto start2 = MonoTime.currTime;
    auto result3 = memoizedComputation(5, 2.5);
    auto result4 = memoizedComputation(5, 2.5); // キャッシュから取得
    auto end2 = MonoTime.currTime;
    
    writeln("結果: ", result3);
    writeln("経過時間: ", (end2 - start2).total!"msecs", " ミリ秒");
    
    // 異なる引数での呼び出し
    writeln("\n異なる引数での呼び出し:");
    
    auto start3 = MonoTime.currTime;
    auto result5 = memoizedComputation(10, 3.5); // 計算が必要
    auto result6 = memoizedComputation(10, 3.5); // キャッシュから取得
    auto end3 = MonoTime.currTime;
    
    writeln("結果: ", result5);
    writeln("経過時間: ", (end3 - start3).total!"msecs", " ミリ秒");
}
```

### 5. 実践的な使用例

#### 5.1 コマンドパターンの実装

関数型プログラミングを使用したコマンドパターンの実装例です。

```d
import std.functional : toDelegate;
import std.stdio : writeln;
import std.array : appender;

// コマンドインターフェース
interface Command {
    void execute();
    void undo();
}

// 関数から作成するコマンド
class FunctionalCommand : Command {
    private void delegate() executeFunc;
    private void delegate() undoFunc;
    
    this(void delegate() exec, void delegate() undo) {
        executeFunc = exec;
        undoFunc = undo;
    }
    
    void execute() {
        executeFunc();
    }
    
    void undo() {
        undoFunc();
    }
}

// コマンドを管理するクラス
class CommandManager {
    private Command[] history;
    private size_t currentIndex = 0;
    
    void executeCommand(Command cmd) {
        // 新しいコマンドが追加された場合、それ以降の履歴を破棄
        if (currentIndex < history.length) {
            history = history[0..currentIndex];
        }
        
        cmd.execute();
        history ~= cmd;
        currentIndex++;
    }
    
    void undo() {
        if (currentIndex > 0) {
            currentIndex--;
            history[currentIndex].undo();
        } else {
            writeln("これ以上元に戻せません");
        }
    }
    
    void redo() {
        if (currentIndex < history.length) {
            history[currentIndex].execute();
            currentIndex++;
        } else {
            writeln("これ以上やり直せません");
        }
    }
}

// テキストエディタの簡易版
class TextEditor {
    private string text = "";
    
    string getText() {
        return text;
    }
    
    void appendText(string newText) {
        text ~= newText;
    }
    
    void deleteLastChars(size_t count) {
        if (count <= text.length) {
            text = text[0..text.length - count];
        } else {
            text = "";
        }
    }
}

// コマンドファクトリ関数
Command createAppendCommand(TextEditor editor, string textToAppend) {
    return new FunctionalCommand(
        // 実行関数
        () {
            editor.appendText(textToAppend);
            writeln("追加: \"", textToAppend, "\"");
        },
        // 元に戻す関数
        () {
            editor.deleteLastChars(textToAppend.length);
            writeln("元に戻す: \"", textToAppend, "\" の追加");
        }
    );
}

void main() {
    auto editor = new TextEditor();
    auto cmdManager = new CommandManager();
    
    // コマンドを実行
    cmdManager.executeCommand(createAppendCommand(editor, "Hello, "));
    cmdManager.executeCommand(createAppendCommand(editor, "D Language! "));
    cmdManager.executeCommand(createAppendCommand(editor, "This is functional programming."));
    
    writeln("現在のテキスト: \"", editor.getText(), "\"");
    
    // 元に戻す
    cmdManager.undo();
    writeln("現在のテキスト: \"", editor.getText(), "\"");
    
    cmdManager.undo();
    writeln("現在のテキスト: \"", editor.getText(), "\"");
    
    // やり直し
    cmdManager.redo();
    writeln("現在のテキスト: \"", editor.getText(), "\"");
    
    // 新しいコマンドを追加
    cmdManager.executeCommand(createAppendCommand(editor, "Functional is great!"));
    writeln("現在のテキスト: \"", editor.getText(), "\"");
}
```

#### 5.2 データ変換パイプライン

関数型プログラミングを使用したデータ処理パイプラインの例です。

```d
import std.functional : pipe, unaryFun, binaryFun;
import std.stdio : writeln;
import std.algorithm : map, filter, sort, fold;
import std.array : array;
import std.conv : to;
import std.typecons : tuple;

// データ構造
struct Product {
    string name;
    string category;
    double price;
    int stock;
    
    string toString() const {
        import std.format : format;
        return format("%s (%s): $%.2f [在庫: %d]", name, category, price, stock);
    }
}

// カテゴリでフィルタリングする関数
Product[] filterByCategory(Product[] products, string category) {
    return products.filter!(p => p.category == category).array;
}

// 在庫数で並べ替える関数
Product[] sortByStock(Product[] products) {
    return products.sort!((a, b) => a.stock < b.stock).array;
}

// 価格を変更する関数
Product[] applyDiscount(Product[] products, double discountPercent) {
    return products.map!(p => Product(
        p.name, p.category, p.price * (1 - discountPercent / 100), p.stock
    )).array;
}

// 在庫が少ない商品にフラグを付ける関数
string[] flagLowStock(Product[] products, int threshold) {
    return products
        .filter!(p => p.stock < threshold)
        .map!(p => p.name ~ " [残りわずか!]")
        .array;
}

void main() {
    // 商品データ
    Product[] inventory = [
        Product("ノートパソコン", "電子機器", 1200.0, 15),
        Product("スマートフォン", "電子機器", 800.0, 25),
        Product("ヘッドフォン", "アクセサリー", 150.0, 50),
        Product("マウス", "アクセサリー", 25.0, 8),
        Product("キーボード", "アクセサリー", 45.0, 12),
        Product("モニター", "電子機器", 300.0, 5),
        Product("USBケーブル", "アクセサリー", 10.0, 100)
    ];
    
    // 電子機器カテゴリに20%割引を適用し、在庫が少ない順に並べ、残り10個未満にフラグを付ける
    auto processElectronics = pipe!(
        (Product[] p) => filterByCategory(p, "電子機器"),
        (Product[] p) => applyDiscount(p, 20.0),
        (Product[] p) => sortByStock(p)
    );
    
    writeln("セール対象の電子機器（在庫少ない順）:");
    auto processedElectronics = processElectronics(inventory);
    foreach (product; processedElectronics) {
        writeln("  ", product);
    }
    
    // 残りわずかの商品を表示
    auto lowStockItems = flagLowStock(processedElectronics, 10);
    
    writeln("\n在庫わずかの商品:");
    foreach (item; lowStockItems) {
        writeln("  ", item);
    }
    
    // カテゴリ別の総額と平均価格を計算
    import std.algorithm.iteration : group, chunkBy;
    
    writeln("\nカテゴリ別分析:");
    auto categorySummary = inventory
        .sort!((a, b) => a.category < b.category)
        .chunkBy!((a, b) => a.category == b.category)
        .map!(chunk => tuple(
            chunk[0].category, 
            chunk[1].map!(p => p.price * p.stock).sum,
            chunk[1].map!(p => p.price).sum / chunk[1].length
        ))
        .array;
    
    foreach (summary; categorySummary) {
        writefln("  %s - 総額: $%.2f, 平均価格: $%.2f", 
            summary[0], summary[1], summary[2]);
    }
}
```

#### 5.3 イベント駆動システム

関数型プログラミングを使用したイベント駆動システムの実装例です。

```d
import std.functional : toDelegate, forward;
import std.stdio : writeln;
import std.algorithm : remove;
import std.datetime : SysTime, Clock;

// イベント種別
enum EventType {
    UserLogin,
    UserLogout,
    DataChanged,
    SystemError
}

// イベントデータ構造
struct Event {
    EventType type;
    string message;
    SysTime timestamp;
    
    this(EventType t, string msg) {
        type = t;
        message = msg;
        timestamp = Clock.currTime();
    }
    
    string toString() const {
        import std.format : format;
        return format("[%s] %s: %s", 
            timestamp.toSimpleString(), 
            getEventTypeName(type), 
            message);
    }
    
    private string getEventTypeName(EventType t) const {
        final switch(t) {
            case EventType.UserLogin: return "ユーザーログイン";
            case EventType.UserLogout: return "ユーザーログアウト";
            case EventType.DataChanged: return "データ変更";
            case EventType.SystemError: return "システムエラー";
        }
    }
}

// イベントハンドラの型
alias EventHandler = void delegate(Event);

// イベントディスパッチャ
class EventDispatcher {
    private EventHandler[EventType][] handlers;
    
    // イベントハンドラを登録
    size_t addEventListener(EventType type, EventHandler handler) {
        handlers[type] ~= handler;
        return handlers[type].length - 1;
    }
    
    // イベントハンドラを削除
    void removeEventListener(EventType type, size_t handlerId) {
        if (type in handlers && handlerId < handlers[type].length) {
            handlers[type] = handlers[type].remove(handlerId);
        }
    }
    
    // イベントを発火
    void dispatchEvent(Event event) {
        if (event.type in handlers) {
            foreach (handler; handlers[event.type]) {
                handler(event);
            }
        }
    }
}

// ログ記録ハンドラ
void logEventHandler(Event event) {
    writeln("ログ: ", event);
}

// 通知ハンドラ
void notificationHandler(Event event) {
    writeln("通知: ", event.message);
}

// エラーアラートハンドラ
void errorAlertHandler(Event event) {
    if (event.type == EventType.SystemError) {
        writeln("!!! 緊急アラート !!! ", event.message);
    }
}

// イベントフィルタファクトリ関数
EventHandler createFilteredHandler(EventHandler baseHandler, bool function(Event) filter) {
    return (Event event) {
        if (filter(event)) {
            baseHandler(event);
        }
    };
}

void main() {
    auto dispatcher = new EventDispatcher();
    
    // 標準的なハンドラを登録
    dispatcher.addEventListener(EventType.UserLogin, &logEventHandler);
    dispatcher.addEventListener(EventType.UserLogout, &logEventHandler);
    dispatcher.addEventListener(EventType.DataChanged, &logEventHandler);
    dispatcher.addEventListener(EventType.SystemError, &logEventHandler);
    
    // フィルタ付きハンドラを作成と登録
    auto userEventHandler = createFilteredHandler(
        &notificationHandler,
        (Event e) => e.type == EventType.UserLogin || e.type == EventType.UserLogout
    );
    dispatcher.addEventListener(EventType.UserLogin, userEventHandler);
    dispatcher.addEventListener(EventType.UserLogout, userEventHandler);
    
    // エラーハンドラを登録
    dispatcher.addEventListener(EventType.SystemError, &errorAlertHandler);
    
    // イベントを発火
    dispatcher.dispatchEvent(Event(EventType.UserLogin, "user123がログインしました"));
    dispatcher.dispatchEvent(Event(EventType.DataChanged, "ユーザープロファイルが更新されました"));
    dispatcher.dispatchEvent(Event(EventType.SystemError, "データベース接続エラー"));
    dispatcher.dispatchEvent(Event(EventType.UserLogout, "user123がログアウトしました"));
}
```

## まとめ

### std.file モジュール

D言語の`std.file`モジュールは、ファイルシステム操作のための豊富な機能を提供します：

1. **ファイルの読み書き**：`read`、`readText`、`write`、`append`などの関数を使用して、ファイルの内容を簡単に操作できます。

2. **ファイルとディレクトリの操作**：`exists`、`rename`、`remove`、`copy`、`mkdir`、`rmdir`などの関数を使用して、ファイルとディレクトリを管理できます。

3. **ファイル情報の取得**：`getSize`、`getTimes`、`getAttributes`などの関数を使用して、ファイルの詳細情報を取得できます。

4. **ディレクトリの探索**：`dirEntries`関数を使用して、ディレクトリ内のファイルを列挙したり、再帰的に探索したりできます。

### std.functional モジュール

D言語の`std.functional`モジュールは、関数型プログラミングのための様々なツールを提供します：

1. **関数の合成と変換**：`pipe`、`compose`、`toDelegate`、`memoize`などの関数を使用して、関数を合成したり変換したりできます。

2. **部分適用と束縛**：`partial`、`curry`、`bind`などの関数を使用して、関数の引数を固定したり、部分的に適用したりできます。

3. **関数ユーティリティ**：`binaryFun`、`unaryFun`、`adjoin`、`forward`などのユーティリティを使用して、関数の操作を簡略化できます。

これらのモジュールを活用することで、D言語でのファイル操作や関数型プログラミングを効率的に行うことができます。関数型アプローチを用いることで、コードの再利用性、可読性、テスト容易性を向上させることができます。