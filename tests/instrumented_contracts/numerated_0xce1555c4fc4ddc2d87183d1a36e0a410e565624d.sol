1 contract storadge {
2     event log(string description);
3 	function save(
4         string mdhash
5     )
6     {
7         log(mdhash);
8     }
9 }