using System;

namespace ReverseArray
{
    class Program
    {
       
        static void Main(string[] args)
        {

            var input = Console.ReadLine().Split(' ');
            ReverseArray(input, 0);
            Console.WriteLine();
        }

        private static void ReverseArray(string[] arr, int index)
        {


            if (index == arr.Length)
            {
                return;
            }

            ReverseArray(arr, index + 1);
            Console.Write(arr[index] + " ");
            
        }
    }
}
