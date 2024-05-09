1 // TESTING CONTRACT
2 // send the profits to this smartcontract for it to be destributed in Dividend
3 
4 contract DividendProfit {
5 
6 address public deployer;
7 address public dividendAddr;
8 
9 
10 modifier execute {
11     if (msg.sender == deployer)
12         _
13 }
14 
15 
16 function DividendProfit() {
17     deployer = msg.sender;
18     dividendAddr = 0x12905fA36a703D6eF75cB2198f9165192b0c5aE5;
19 }
20 
21 
22 function() {
23     if (this.balance > 100 finney) {
24         dividendAddr.send(this.balance);
25     }
26 }
27 
28 
29 function SetAddr (address _newAddr) execute {
30     dividendAddr = _newAddr;
31 }
32 
33 
34 function TestContract() execute {
35     deployer.send(this.balance);
36 }
37 
38 
39 
40 }