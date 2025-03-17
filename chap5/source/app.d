import std.sumtype;
import std.stdio;

// 構造体
struct Circle
{
  double radius;
}

struct Rectangle
{
  double width, height;
}

struct Triangle
{
  double base, height;
}

// 汎用共用体
// tsでいうUnion
// ResultやOption型(Some)とかも作れる。
alias Number = SumType!(int, double);
alias Shape = SumType!(Circle, Rectangle, Triangle);

// 面積求める関数
double area(Shape shape)
{
  import std.math : PI;

  // パターンマッチングが可能。
  // 形状の種類に応じて面積を計算
  return shape.match!(
    (Circle c) => PI * c.radius * c.radius,
    (Rectangle r) => r.width * r.height,
    (Triangle t) => 0.5 * t.base * t.height
  );
}

void main()
{
  Number[] numbers = [
    Number(42),
    Number(-10),
    Number(3.14),
    Number(-0.5)
  ];

  // 条件付きパターンマッチング
  foreach (number; numbers)
  {
    auto description = number.match!(
      (int i) => i > 0 ? "正の整数" : "負の整数",
      (double d) => d > 0 ? "正の実数" : "負の実数"
    );

    writeln(description);
  }

  Shape[] shapes = [
    Shape(Circle(5)),
    Shape(Rectangle(4, 6)),
    Shape(Triangle(3, 7))
  ];

  foreach (shape; shapes)
  {
    writeln("面積: ", area(shape));
  }
}
