// Hàm làm tròn lên
double RoundUp(double value, int digits)
{
   double factor = MathPow(10, digits);
   return MathCeil(value * factor) / factor;
}
