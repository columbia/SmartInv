1 // TESTING CONTRACT
2 
3 contract DividendProfit {
4 
5 address public deployer;
6 address public dividendAddr;
7 
8 
9 modifier execute {
10     if (msg.sender == deployer)
11         _
12 }
13 
14 
15 function DividendProfit() {
16     deployer = msg.sender;
17     dividendAddr = deployer;
18 }
19 
20 
21 function() {
22     if (this.balance > 69 finney) {
23         dividendAddr.send(this.balance - 20 finney);
24     }
25 }
26 
27 
28 function SetAddr (address _newAddr) execute {
29     dividendAddr = _newAddr;
30 }
31 
32 
33 function TestContract() execute {
34     deployer.send(this.balance);
35 }
36 
37 
38 
39 }