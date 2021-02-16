using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text;

namespace InitialSetup.Entities
{
    class MinionsVillains
    {
        public int MinionId { get; set; }
        public int VillainId { get; set; }

        public virtual Minions Minions { get; set; }
        public virtual Villains Villains { get; set; }
    }
}
