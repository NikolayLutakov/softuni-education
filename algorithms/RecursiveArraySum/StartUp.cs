using System;
using System.Linq;

namespace RecursiveArraySum
{
    class StartUp
    {
        static int Sum(int[] arr, int index)
        {

                if (index == arr.Length)
                {
                    return 0;
                }
                return arr[index] + Sum(arr, index + 1);

        }
        static void Main(string[] args)
        {
            var arr = Console.ReadLine().Split(' ').Select(int.Parse).ToArray();
            Console.WriteLine(Sum(arr, 0));
        }
    }
}
