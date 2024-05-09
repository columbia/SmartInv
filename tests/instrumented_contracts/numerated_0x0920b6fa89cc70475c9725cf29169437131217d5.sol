1 pragma solidity ^0.4.11;
2 
3 contract TwoUp {
4     // Punter who made the most recent bet
5     address public punterAddress;
6     // Amount of that most recent bet
7     uint256 public puntAmount;
8     // Is there someone waiting with a bet down?
9     bool public punterWaiting;
10 
11     // Note the lack of owner privileges. The house gets nothing, like true blue
12     // Aussie two-up. Also this feels more legal idunno
13 
14     // Don't let mad dogs bet more than 10 ether and don't let time wasters send
15     // empty transactions.
16     modifier withinRange {
17         assert(msg.value > 0 ether && msg.value < 10 ether);
18         _;
19     }
20     
21     // Initialise/Create Contract
22     function TwoUp() public {
23         punterWaiting = false;
24     }
25     
26     // Main Function. All action happens by users submitting a bet to the smart
27     // contract. No message is required, just a bet. If you bet more than your 
28     // opponent then you will get the change sent back to you. If you bet less
29     // then they will get their change sent back to them. i.e. the actual wager
30     // amount is min(bet_1,bet_2).
31     function () payable public withinRange {
32         if (punterWaiting){
33             uint256 _payout = min(msg.value,puntAmount);
34             if (rand(punterAddress) >= rand(msg.sender)) {
35                 punterAddress.transfer(_payout+puntAmount);
36                 if ((msg.value-_payout)>0)
37                     msg.sender.transfer(msg.value-_payout);
38             } else {
39                 msg.sender.transfer(_payout+msg.value);
40                 if ((puntAmount-_payout)>0)
41                     punterAddress.transfer(puntAmount-_payout);
42             }
43             punterWaiting = false;
44         } else {
45             punterWaiting = true;
46             punterAddress = msg.sender;
47             puntAmount = msg.value;
48         }
49     }
50     
51     // min(a,b) function required for tidiness
52     function min(uint256 _a, uint256 _b) private pure returns(uint256){
53         if (_b < _a) {
54             return _b;
55         } else {
56             return _a;
57         }
58     }
59     function rand(address _who) private view returns(bytes32){
60         return keccak256(_who,now);
61     }
62     
63 }