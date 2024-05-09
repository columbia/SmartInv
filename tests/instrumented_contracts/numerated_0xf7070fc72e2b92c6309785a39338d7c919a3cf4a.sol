1 contract NoFeePonzi {
2 
3   uint public constant MIN_VALUE = 1 ether;
4   uint public constant MAX_VALUE = 10 ether;
5 
6   uint public constant RET_MUL = 110;
7   uint public constant RET_DIV = 100;
8 
9   struct Payout {
10     address addr;
11     uint yield;
12   }
13 
14   Payout[] public payouts;
15   uint public payoutIndex = 0;
16   uint public payoutTotal = 0;
17 
18   function NoFeePonzi() {
19   }
20 
21   function() {
22     if ((msg.value < MIN_VALUE) || (msg.value > MAX_VALUE)) {
23       throw;
24     }
25 
26     uint entryIndex = payouts.length;
27     payouts.length += 1;
28     payouts[entryIndex].addr = msg.sender;
29     payouts[entryIndex].yield = (msg.value * RET_MUL) / RET_DIV;
30 
31     while (payouts[payoutIndex].yield < this.balance) {
32       payoutTotal += payouts[payoutIndex].yield;
33       payouts[payoutIndex].addr.send(payouts[payoutIndex].yield);
34       payoutIndex += 1;
35     }
36   }
37 }