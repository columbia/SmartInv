1 contract TranferInTwoPart {
2     function transfer(address _to) payable {
3         uint half = msg.value / 2;
4         uint halfRemain = msg.value - half;
5         
6         _to.send(half);
7         _to.send(halfRemain);
8     }
9     // Forward value transfers.
10     function() {       
11        throw;
12     }
13 }