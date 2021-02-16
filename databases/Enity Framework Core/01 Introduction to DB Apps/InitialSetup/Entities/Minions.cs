using System;
using System.Collections.Generic;
using System.Text;

namespace InitialSetup.Entities
{
    public class Minions
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public int Age { get; set; }

        public int TownId { get; set; }

        public virtual ICollection<Villains> Villains { get; set; }

        public virtual Towns Town { get; set;}
    }
}
