using System;
using System.Collections.Generic;
using System.Text;

namespace InitialSetup.Entities
{
    public class Towns
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public int CountryCode { get; set; }

        public virtual ICollection<Minions> Minions { get; set; }

        public virtual Countries Country { get; set; }
    }
}
