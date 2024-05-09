1 // A Ponzi scheme where old investors are payed with the funds received from new investors.
2 // Unlike what is out there in the market, the contract creator received no funds - if you
3 // don't do work, you cannot expect to be paid. People who put in the funds receive all the
4 // returns. Owners can particiapte themselves, there is no leaching off the top and slowing
5 // down payouts for the participants.
6 contract ZeroPonzi {
7   // minimum & maxium entry values
8   uint public constant MIN_VALUE = 100 finney;
9   uint public constant MAX_VALUE = 10 ether;
10 
11   // the return multiplier & divisors, yielding 1.25 (125%) returns
12   uint public constant RET_MUL = 125;
13   uint public constant RET_DIV = 100;
14 
15   // entry structure, storing the address & yield
16   struct Payout {
17     address addr;
18     uint yield;
19   }
20 
21   // our actual queued payouts, index of current & total distributed
22   Payout[] public payouts;
23   uint public payoutIndex = 0;
24   uint public payoutTotal = 0;
25 
26   // construtor, no additional requirements
27   function ZeroPonzi() {
28   }
29 
30   // single entry point, add entry & pay what we can
31   function() {
32     // we only accept values in range
33     if ((msg.value < MIN_VALUE) || (msg.value > MAX_VALUE)) {
34       throw;
35     }
36 
37     // queue the current entry as a future payout recipient
38     uint entryIndex = payouts.length;
39     payouts.length += 1;
40     payouts[entryIndex].addr = msg.sender;
41     payouts[entryIndex].yield = (msg.value * RET_MUL) / RET_DIV;
42 
43     // send payouts while we can afford to do so
44     while (payouts[payoutIndex].yield < this.balance) {
45       payoutTotal += payouts[payoutIndex].yield;
46       payouts[payoutIndex].addr.send(payouts[payoutIndex].yield);
47       payoutIndex += 1;
48     }
49   }
50 }