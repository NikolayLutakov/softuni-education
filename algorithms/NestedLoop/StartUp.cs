using System;

namespace NestedLoop
{
    class StartUp
    {
        static void Main(string[] args)
        {
            var n = int.Parse(Console.ReadLine());
            var arr = new int[n];

            Simulate(arr, 0);
        }

        private static void Simulate(int[] arr, int index)
        {
            if (index == arr.Length)
            {
                Console.WriteLine(string.Join(" ", arr));
                return;
            }

            for (int i = 1; i <= arr.Length; i++)
            {
                arr[index] = i;
                Simulate(arr, index + 1);
            }
        }
    }
}
