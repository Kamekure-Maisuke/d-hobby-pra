import std.stdio;
import std.file;
import std.path;
import std.datetime;
import core.thread;
import core.time;

void main() {
    string dirPath = "./sample";
    
    if (!exists(dirPath)) {
        mkdir(dirPath);
    }
    
    writeln("ディレクトリを監視中: ", dirPath);
    
    // 初期状態を取得
    auto fileInfos = getFileInfos(dirPath);
    
    // メイン監視ループ
    while (true) {
        // CPUの過剰な使用を避けるために短時間スリープ
        Thread.sleep(dur!"msecs"(100));
        
        // 現在の状態を取得
        auto currentInfos = getFileInfos(dirPath);
        
        // 変更を検出して報告
        foreach (path, currentInfo; currentInfos) {
            if (path !in fileInfos) {
                // 新しいファイル
                writefln(">>>> event { kind: \"create\", paths: [\"%s\"] }", path);
            } else if (fileInfos[path] != currentInfo) {
                // 変更されたファイル
                writefln(">>>> event { kind: \"modify\", paths: [\"%s\"] }", path);
            }
        }
        
        // 削除されたファイルを確認
        foreach (path, info; fileInfos) {
            if (path !in currentInfos) {
                writefln(">>>> event { kind: \"remove\", paths: [\"%s\"] }", path);
            }
        }
        
        // 状態を更新
        fileInfos = currentInfos;
    }
}

// ファイル情報を格納する構造体
struct FileInfo {
    SysTime modTime;  // 最終変更時刻
    ulong size;       // ファイルサイズ
    
    // 2つのFileInfoオブジェクトを比較する
    bool opEquals(const FileInfo other) const {
        return modTime == other.modTime && size == other.size;
    }
}

// 指定されたディレクトリ内のすべてのファイルの情報を取得する関数
FileInfo[string] getFileInfos(string dirPath) {
    FileInfo[string] infos;
    
    if (exists(dirPath) && isDir(dirPath)) {
        foreach (DirEntry entry; dirEntries(dirPath, SpanMode.shallow)) {
            infos[entry.name] = FileInfo(entry.timeLastModified, entry.size);
        }
    }
    
    return infos;
}
