using System;
using System.Collections.Generic;
using System.Linq;

namespace Quicksort
{
    class Program
    {
        static void Main(string[] args)
        {
            var input = Console.ReadLine().Split(' ').Select(int.Parse).ToArray();
            Quick.Sort(input);
            Console.WriteLine(string.Join(" ", input));
        }


        public class Quick
        {
            public static void Sort<T>(T[] a) where T : IComparable
            {
                Shuffle(a);
                Sort(a, 0, a.Length - 1);
            }

            private static void Shuffle<T>(T[] a) where T : IComparable
            {
                Random rand = new Random();
                for (int i = 0; i < a.Length; i++)
                {
                    int index = rand.Next(0, a.Length - 1);
                    var temp = a[i];
                    a[i] = a[index];
                    a[index] = temp;

                }
            }

            private static void Sort<T>(T[] a, int lo, int hi) where T : IComparable
            {
                if (lo >= hi)
                {
                    return;
                }

                int p = Partition(a, lo, hi);
                Sort(a, lo, p - 1);
                Sort(a, p + 1, hi);
            }

            private static int Partition<T>(T[] a, int lo, int hi) where T : IComparable
            {
                if (lo >= hi)
                {
                    return lo;
                }

                int i = lo;
                int j = hi + 1;
                while (true)
                {
                    while (Less(a[++i], a[lo]))
                    {
                        if (i == hi)
                        {
                            break;
                        }
                    }

                    while (Less(a[lo], a[--j]))
                    {
                        if (j == lo)
                        {
                            break;
                        }
                    }

                    if (i >= j) 
                    {
                        break;
                    }
                    Swap(a, i, j);
                }
                Swap(a, lo, j);
                return j;
            }

            private static void Swap<T>(T[] a, int i, int j) where T : IComparable
            {
                var temp = a[i];
                a[i] = a[j];
                a[j] = temp;
            }

            private static bool Less<T>(T t1, T t2) where T : IComparable
            {
                if (t1.CompareTo(t2) == -1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
    }
}
