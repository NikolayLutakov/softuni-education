using System;
using System.Collections.Generic;
using System.Linq;

namespace TowersOfHanoi
{
    class Startup
    {
        static Stack<int> source;
        static Stack<int> destination = new Stack<int>();
        static Stack<int> spare = new Stack<int>();
        static int stepsTaken = 0;
        static void Main(string[] args)
        {
            int numberOfDisks = int.Parse(Console.ReadLine());
            source = new Stack<int>(Enumerable.Range(1, numberOfDisks).Reverse());
            PrintRods();
            MoveDisk(numberOfDisks, source, destination, spare);
          
        }
        private static void PrintMove(int currentDisk)
        {
            stepsTaken++;
            Console.WriteLine($"Step #{stepsTaken}: Moved disk: {currentDisk}");
            PrintRods();
        }
        private static void PrintRods()
        {
            Console.WriteLine($"Source: {string.Join(", ", source.Reverse())}");
            Console.WriteLine($"Destination: {string.Join(", ", destination.Reverse())}");
            Console.WriteLine($"Spare: {string.Join(", ", spare.Reverse())}");
            Console.WriteLine();
        }

        private static void MoveDisk(int bottomDisk, Stack<int> source, Stack<int> destination, Stack<int> spare)
        {
            if (bottomDisk == 1)
            {
                
                destination.Push(source.Pop());
                PrintMove(bottomDisk);
            }
            else
            {
                MoveDisk(bottomDisk - 1, source, spare, destination);
                destination.Push(source.Pop());
                PrintMove(bottomDisk);
                MoveDisk(bottomDisk - 1, spare, destination, source);
            }
        }
    }
}
