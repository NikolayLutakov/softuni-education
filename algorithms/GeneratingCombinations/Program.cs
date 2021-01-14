using System;
using System.Linq;

namespace GeneratingCombinations
{
    class Program
    {
        private static void Combine(int[] set, int[] vector, int index, int border)
        {
            if (index >= vector.Length)
            {
                Console.WriteLine(string.Join(" ", vector));
            }
            else
            {
                for (int i = border; i < set.Length; i++)
                {
                    vector[index] = set[i];
                    Combine(set, vector, index + 1, i + 1);
                }
            }
        }
        static void Main(string[] args)
        {
            var set = Console.ReadLine().Split(' ').Select(int.Parse).ToArray();
            var k = int.Parse(Console.ReadLine());
            var vector = new int[k];
            

            Combine(set, vector, 0, 0);
        }


    }
}
