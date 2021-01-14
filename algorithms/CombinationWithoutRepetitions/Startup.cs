using System;

namespace CombinationWithoutRepetitions
{
    class Startup
    {
        static int[] vector;
        static int[] set;
        static void Main(string[] args)
        {
            var n = int.Parse(Console.ReadLine());
            var k = int.Parse(Console.ReadLine());


            set = new int[n];
            vector = new int[k];

            for (int i = 0; i < n; i++)
            {
                set[i] = i + 1;
            }

            Generate(0, 0);

        }
        private static void Generate(int index, int border)
        {
            if (index == vector.Length)
            {
                Console.WriteLine(string.Join(" ", vector));
            }
            else
            {
                for (int i = border; i < set.Length; i++)
                {
                    vector[index] = set[i];
                    Generate(index + 1, i+1); // increment the border!!!
                }

            }
        }
    }
}
