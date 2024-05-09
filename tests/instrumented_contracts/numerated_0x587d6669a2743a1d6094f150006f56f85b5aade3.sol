1 contract Vote {
2     address creator;
3 
4     function Vote() {
5         creator = msg.sender;
6     }
7 
8     function() {
9         if (msg.value > 0) {
10             tx.origin.send(msg.value);
11         }
12     }
13 
14     function kill() {
15         if (msg.sender == creator) {
16             suicide(creator);
17         }
18     }
19 }