using System;
using System.Collections.Generic;
using System.Text;

namespace InitialSetup.Entities
{
    public class Villains
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public int EvilnessFactorId { get; set; }

        public virtual ICollection<Minions> Minions { get; set; }
        public virtual EvilnessFactors EvilnessFactor { get; set; }
    }
}
