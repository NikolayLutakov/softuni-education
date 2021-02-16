using Microsoft.Data.SqlClient;
using System;
using System.Linq;

namespace _04_Add_Minion
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] firstLineParams = Console.ReadLine().Split(" ", StringSplitOptions.RemoveEmptyEntries);
            string[] secondLineParams = Console.ReadLine().Split(" ", StringSplitOptions.RemoveEmptyEntries);

            string minionName = firstLineParams[1];
            int minionAge = int.Parse(firstLineParams[2]);
            string minionTown = firstLineParams[3];

            string villainName = secondLineParams[1];

            using (SqlConnection connection = new SqlConnection("Server=192.168.0.116,1433;Database=MinionsDB;User ID=nlyutakov;Password=A123456a;"))
            {
                connection.Open();

                string takeTownsQueryString = "SELECT Id, Name FROM Towns WHERE Name = @townName";
                SqlCommand takeTownCmd = new SqlCommand(takeTownsQueryString, connection);
                takeTownCmd.Parameters.AddWithValue("@townName", minionTown);
                using (SqlDataReader townsResult = takeTownCmd.ExecuteReader())
                {
                    if (!townsResult.HasRows)
                    {
                        townsResult.Close();
                        string insertTownQueryString = "INSERT INTO Towns (Name) VALUES (@townName)";
                        SqlCommand insertTownCmd = new SqlCommand(insertTownQueryString, connection);
                        insertTownCmd.Parameters.AddWithValue("@townName", minionTown);

                        insertTownCmd.ExecuteNonQuery();

                        Console.WriteLine($"Town {minionTown} was added to the database.");
                    }
                    else
                    {

                    }
                }


            }
        }
    }
}
