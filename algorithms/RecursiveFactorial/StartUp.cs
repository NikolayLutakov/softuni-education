using System;

namespace RecursiveFactorial
{
    class StartUp
    {

        static int Fact(int n)
        {
            if (n == 0)
            {
                return 1;
            }
            return n * Fact(n - 1);
        }
        static void Main(string[] args)
        {
            var n = int.Parse(Console.ReadLine());

            Console.WriteLine(Fact(n));
        }
    }
}
