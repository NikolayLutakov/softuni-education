﻿using System;
using System.Linq;
using System.Collections.Generic;

namespace Words
{
    class Program
    {
        private static char[] letters;
        private static int count;
        static void Main(string[] args)
        {
            letters = Console.ReadLine().ToCharArray();

            var hasUniqueLetters = letters.Distinct().Count() == letters.Length;

            if (hasUniqueLetters)
            {
                count = Factorial(letters.Length);
            }
            else
            {
                Permutations(0);
            }

            Console.WriteLine(count);
        }

        private static void Permutations(int index)
        {
            if (index >= letters.Length
                && !HasRepeatingLetters())
            {
                count++;
            }
            else
            {
                var swappedElements = new HashSet<char>();

                for (int current = index; current < letters.Length; current++)
                {
                    var currentElement = letters[current];

                    if (!swappedElements.Contains(currentElement))
                    {
                        swappedElements.Add(currentElement);

                        Swap(index, current);

                        Permutations(index + 1);

                        Swap(index, current);
                    }
                }
            }
        }

        private static void Swap(int first, int second)
        {
            var temp = letters[first];
            letters[first] = letters[second];
            letters[second] = temp;
        }

        private static bool HasRepeatingLetters()
        {
            for (int i = 1; i < letters.Length; i++)
            {
                if (letters[i] == letters[i-1])
                {
                    return true;
                }                
            }
            return false;
        }

        private static int Factorial(int n)
        {
            var fact = 1;

            for (int i = 2; i <= n; i++)
            {
                fact *= i;
            }

            return fact;
        }
    }
}
