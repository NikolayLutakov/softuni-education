using BookShop.Data;
using BookShop.Initializer;
using BookShop.Models.Enums;
using System;
using System.Linq;
using System.Text;

namespace BookShop
{
    public class StartUp
    {
        public static void Main(string[] args)
        {
            BookShopContext context = new BookShopContext();

            //DbInitializer.Seed(context);

            //Console.WriteLine(GetBooksByAgeRestriction(context, InputReader())); //02
            Console.WriteLine(GetGoldenBooks(context)); //03
        }


        //03
        public static string GetGoldenBooks(BookShopContext context) 
        {
            StringBuilder result = new StringBuilder();

            var books = context.Books.ToList().Where(b => b.EditionType.ToString() == "Gold" && b.Copies < 5000).Select(b => new {Title =  b.Title, Id = b.BookId }).OrderBy(b => b.Id).ToList();

            foreach (var book in books)
            {
                result.AppendLine(book.Title);
            }

            return result.ToString();

        }

       


        //02
        public static string GetBooksByAgeRestriction(BookShopContext context, string command) 
        {
            StringBuilder result = new StringBuilder();


            //AgeRestriction restriction = (AgeRestriction)Enum.Parse(typeof(AgeRestriction), command.Substring(0, 1).ToUpper() + command.Substring(1, command.Length - 1).ToLower());

            //var books = context.Books
            //    .Where(b => b.AgeRestriction == restriction)
            //    .Select(x => new
            //        {
            //            Title = x.Title,
            //        })
            //    .OrderBy(x => x.Title)
            //    .ToList() ;


            var books = context.Books
                .ToList()
                .Where(b => b.AgeRestriction
                     .ToString()
                     .ToLower() == command.ToLower())
                .Select(b => new 
                { 
                    Title =  b.Title 
                })
                .OrderBy(b => b.Title)
                .ToList();


            foreach (var book in books)
            {
                result.AppendLine(book.Title);
            }

            return result.ToString();
        }

        public static string InputReader()
        {
            return Console.ReadLine();
        }
    }
}
