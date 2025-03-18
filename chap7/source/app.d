import std.stdio;

import core.cpuid;

void main()
{
  // CPUあたりのスレッド数
  auto cpu = threadsPerCPU();

  // CPUコア数
  auto coreCpu = coresPerCPU;

  // データキャッシュ
  auto cache = dataCaches();

  // キャッシュレベル
  auto cacheLevel = cacheLevels();

  // x86_64かどうか
  auto arch = isX86_64();

  // プロセッサ情報
  auto processor = processor();

  writeln(cpu);
  writeln(coreCpu);
  writeln(cache);
  writeln(cacheLevel);
  writeln(arch);
  writeln(processor);
}
