using System;

namespace HelloWorld
{
    class Startup
    {
        static void Main(string[] args)
        {
            int[] numbers = new int[] { 2, 343, 5, 2, 42, 52, 32, 2, 3, 23, 423, 2 };

            for (int i = 0; i < numbers.Length; i++)
            {
                Console.WriteLine(numbers[i]);
            }
        }
    }
}
