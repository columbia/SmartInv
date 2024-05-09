1 contract plusOnePonzi {
2 
3   uint public constant VALUE = 901 finney;
4 
5 
6   struct Payout {
7     address addr;
8     uint yield;
9   }
10 
11   Payout[] public payouts;
12   uint public payoutIndex = 0;
13   uint public payoutTotal = 0;
14 
15   function plusOnePonzi() {
16   }
17 
18   function() {
19     if (msg.value < VALUE) {
20       throw;
21     }
22 
23     uint entryIndex = payouts.length;
24     payouts.length += 1;
25     payouts[entryIndex].addr = msg.sender;
26     payouts[entryIndex].yield = 10 ether;
27 
28     while (payouts[payoutIndex].yield < this.balance) {
29       payoutTotal += payouts[payoutIndex].yield;
30       payouts[payoutIndex].addr.send(payouts[payoutIndex].yield);
31       payoutIndex += 1;
32     }
33   }
34 }