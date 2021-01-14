using System;

namespace GenaratingBitVectors
{
    class Startup
    {
        private static void Generate(int[] arr, int index)
        {
            if (index > arr.Length - 1)
            {
                Console.WriteLine(string.Join("" , arr));
                return;
            }

            for (int i = 0; i <= 1; i++)
            {
                arr[index] = i;
                Generate(arr, index + 1);
            }

        }
        static void Main(string[] args)
        {
            int input = int.Parse(Console.ReadLine());

            int[] arr = new int[input];

            Generate(arr, 0);
        }


    }
}
