using System;
using System.Collections.Generic;

namespace FindAllPathsinaLabyrinth
{
    class Program
    {
        static char[,] lab;
        static bool[,] visited;
        static List<char> path = new List<char>();
        static void Main(string[] args)
        {
            lab = ReadLab();
            visited = new bool[lab.GetLength(0), lab.GetLength(1)];
            FindPaths(0, 0, 'S');

            //PrintLab();
        }

        private static void PrintLab()
        {
            for (int i = 0; i < lab.GetLength(0); i++)
            {
                for (int j = 0; j < lab.GetLength(1); j++)
                {
                    Console.Write(lab[i, j]);
                }
                Console.WriteLine();
            }
        }

        private static void FindPaths(int row, int col, char direction)
        {
            if (!IsInBounds(row, col))
            {
                return;
            }

            path.Add(direction);

            if (IsExit(row, col))
            {
                PrintPath();
            }
            else if (!IsVisited(row, col) && IsFree(row, col))
            {
                MarkVisited(row, col);
                FindPaths(row, col + 1, 'R');
                FindPaths(row + 1, col, 'D');
                FindPaths(row, col - 1, 'L');
                FindPaths(row - 1, col, 'U');
                UnmarkVisited(row, col);
            }
            path.RemoveAt(path.Count - 1);
            
        }

        private static void UnmarkVisited(int row, int col)
        {
            visited[row, col] = false;
        }

        private static void MarkVisited(int row, int col)
        {
            visited[row, col] = true;
        }

        private static bool IsVisited(int row, int col)
        {
            return visited[row, col];
        }

        private static bool IsFree(int row, int col)
        {
            if (lab[row, col] != '*')
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private static void PrintPath()
        {
            for (int i = 0; i < path.Count; i++)
            {
                if (path[i] != 'S')
                {
                    Console.Write(path[i]);
                }
                
            }
            Console.WriteLine();
            //Console.WriteLine(string.Join("", path));
        }

        private static bool IsExit(int row, int col)
        {
            if (lab[row, col] == 'e')
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private static bool IsInBounds(int row, int col)
        {
            if (row < 0 || col < 0 || row >= lab.GetLongLength(0) || col >= lab.GetLength(1))
            {
                return false;
            }
            else
            {
                return true;
            }
        }


        private static char[,] ReadLab()
        {
            
            int rowsCount = int.Parse(Console.ReadLine());
            int colsCount = int.Parse(Console.ReadLine());
            var lab = new char[rowsCount, colsCount];

            for (int row = 0; row < rowsCount; row++)
            {
                var line = Console.ReadLine();

                for (int col = 0; col < line.Length; col++)
                {
                    lab[row, col] = line[col];
                }
            }

            return lab;
        }
    }
}
