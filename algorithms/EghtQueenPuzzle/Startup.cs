using System;

namespace EghtQueenPuzzle
{
    class Startup
    {
        static void Main(string[] args)
        {
            ChessBoard.PutQueens(0);
            
            Console.WriteLine(ChessBoard.solutionsFound);
        }
    }
}
