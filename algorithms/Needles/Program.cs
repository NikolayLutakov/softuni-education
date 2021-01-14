using System;
using System.Linq;
using System.Collections.Generic;

namespace Needles
{
    class Program
    {

        static int[] sequence;
        static int[] needles;
        static void Main(string[] args)
        {
            var firstLine = Console.ReadLine().Split(' ');
            sequence = Console.ReadLine().Split(' ').Select(int.Parse).ToArray();
            needles = Console.ReadLine().Split(' ').Select(int.Parse).ToArray();

            var c = int.Parse(firstLine[0]);
            var n = int.Parse(firstLine[1]);
            var result = new List<int>();

            for (int i = 0; i < needles.Length; i++)
            {
                result.Add(FindIndex(needles[i]));
            }

            Console.WriteLine(string.Join(" ", result));
        }

        private static int FindIndex(int needle)
        {
            var sum = 0;

            for (int i = 0; i < sequence.Length; i++)
            {


                sum += sequence[i];
                if (i == sequence.Length - 1 && sequence[i] < needle)
                {
                    if (sum == 0)
                    {
                        return 0;
                    }
                    return i+1;
                }
                if (sequence[i] >= needle)
                {
                    if (i == 0)
                    {
                        return 0;
                    }
                    var j = i-1;
                    while (sequence[j] == 0 || sequence[j] == needle)
                    {
                        j--;
                        if (j == 0)
                        {
                            return 0;
                        }
                    }
                    return j+1;
                }
            }
            return 0;
        }
    }
}
