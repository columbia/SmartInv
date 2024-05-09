1 contract Vote {
2     event LogVote(address indexed addr);
3 
4     function() {
5         LogVote(msg.sender);
6 
7         if (msg.value > 0) {
8             msg.sender.send(msg.value);
9         }
10     }
11 }