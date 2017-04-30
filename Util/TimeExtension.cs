using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

    public class TimeStamp
    {
public double unix_timestamp() {
    TimeSpan unix_time = (System.DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0));
    return unix_time.TotalSeconds;

        }

}