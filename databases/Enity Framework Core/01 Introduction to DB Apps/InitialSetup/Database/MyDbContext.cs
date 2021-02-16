using Microsoft.EntityFrameworkCore;
using InitialSetup.Entities;
using System.Collections.Generic;
using System.Text;

namespace InitialSetup.Database
{
    public class MyDbContext : DbContext
    {
        public MyDbContext()
        {

        }
        public DbSet<Countries> Countries { get; set; }

        public DbSet<EvilnessFactors> EvilnessFactors { get; set; }


        public DbSet<Minions> Minions { get; set; }

        public DbSet<Towns> Towns { get; set; }

        public DbSet<Villains> Villains { get; set; }
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer("Data Source=NIKOLAYPC\\NICKSSQLSERVER; Initial Catalog=MinionsDB; User ID=nlyutakov; Password=A123456a; ");

        }
    }
}
