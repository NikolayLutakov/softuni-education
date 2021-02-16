using System;
using System.Collections.Generic;
using System.Text;

namespace InitialSetup.Entities
{
    public class EvilnessFactors
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public virtual ICollection<Villains> Villains { get; set; }
    }
}
