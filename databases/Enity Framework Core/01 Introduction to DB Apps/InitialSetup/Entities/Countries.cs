﻿using System;
using System.Collections.Generic;
using System.Text;

namespace InitialSetup.Entities
{
    public class Countries
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public virtual ICollection<Towns> Towns { get; set; }
    }
}
