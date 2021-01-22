using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Events.Data
{
    public class Event
    {
        public Event()
        {
            this.IsPublic = true;
            this.StartDateTime = DateTime.Now;
            this.Coments = new HashSet<Comment>();
        }

        public int Id { get; set; }
        
        [Required]
        [MaxLength(200)]
        public string Title { get; set; }

        public DateTime StartDateTime { get; set; }

        public TimeSpan? Duration { get; set; }

        public string AuthorId { get; set; }

        public ApplicationUser Author { get; set; }

        public string Description { get; set; }

        [MaxLength(200)]
        public string Location { get; set; }

        public bool IsPublic { get; set; }

        public ICollection<Comment> Coments { get; set; }
    }
}
