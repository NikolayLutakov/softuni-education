using System;
using System.Linq;

namespace InversionCount
{
    class Program
    {
        static void Main(string[] args)
        {
            var input = Console.ReadLine().Split(' ').Select(int.Parse).ToArray();
            var aux = new int[input.Length]; 
            Console.WriteLine(FindInversions(input, aux, 0, input.Length-1));

        }
        private static int FindInversions(int[] arr, int[] aux, int lo, int hi)
        {
            if (lo >= hi)
            {
                return 0;
            }

            int mid = (lo + hi) / 2;
            int invertionsCount = FindInversions(arr, aux, lo, mid);
            invertionsCount += FindInversions(arr, aux, mid + 1, hi);

            // Merge - https://www.geeksforgeeks.org/counting-inversions/

            int left = lo;
            int right = ++mid;
            int index = lo;
            while ((left < mid) && (right <= hi))
            {
                if (arr[left] <= arr[right])
                {
                    aux[index++] = arr[left++];
                }
                else
                {
                    aux[index++] = arr[right++];
                    invertionsCount += mid - left;
                }
            }

            while (left < mid)
            {
                aux[index++] = arr[left++];
            }

            while (right <= hi)
            {
                aux[index++] = arr[right++];
            }

            for (left = lo; left <= hi; left++)
            {
                arr[left] = aux[left];
            }

            return invertionsCount;
        }
    }
}
