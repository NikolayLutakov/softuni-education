using System;
using System.Linq;

namespace BinarySearch
{
    class Program
    {
        static void Main(string[] args)
        {
            var input = Console.ReadLine().Split(' ').Select(int.Parse).ToArray();
            var key = int.Parse(Console.ReadLine());

            Console.WriteLine(BinarySearch.IndexOf(input, key));
        }

        public class BinarySearch
        {
            public static int IndexOf(int[] arr, int key)
            {
                int lo = 0;
                int hi = arr.Length - 1;
                
                while (lo <= hi)
                {
                    var mid = lo + (hi - lo) / 2;

                    if (key < arr[mid])
                    {
                        hi = mid - 1;
                    }
                    else if(key > arr[mid])
                    {
                        lo = mid + 1;                  
                    }
                    else
                    {
                        return mid;
                    }
                }
                
                return -1;
            }
        }
    }
}
