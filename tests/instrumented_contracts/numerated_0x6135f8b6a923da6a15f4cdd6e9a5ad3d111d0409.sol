1 pragma solidity ^0.4.23;
2 
3 contract Olympus {
4 
5     mapping (address => uint256) public invested;
6     mapping (address => uint256) public atBlock;
7     address techSupport = 0x9BeE4317c50f66332DA95238AF079Be40a40eaa2;
8     uint techSupportPercent = 2;
9     uint refPercent = 3;
10     uint refBack = 3;
11 
12     // calculation of the percentage of profit depending on the balance sheet
13     // returns the percentage times 10
14     function calculateProfitPercent(uint bal) private pure returns (uint) {
15         if (bal >= 4e21) { // balance >= 4000 ETH
16             return 60;
17         }
18         if (bal >= 2e21) { // balance >= 2000 ETH
19             return 50;
20         }
21         if (bal >= 1e21) { // balance >= 1000 ETH
22             return 45;
23         }
24         if (bal >= 5e20) { // balance >= 500 ETH
25             return 40;
26         }
27         if (bal >= 4e20) { // balance >= 400 ETH
28             return 38;
29         }
30         if (bal >= 3e20) { // balance >= 300 ETH
31             return 36;
32         }
33         if (bal >= 2e20) { // balance >= 200 ETH
34             return 34;
35         }
36         if (bal >= 1e20) { // balance >= 100 ETH
37             return 32;
38         } else {
39             return 30;
40         }
41     }
42 
43     // transfer default percents of invested
44     function transferDefaultPercentsOfInvested(uint value) private {
45         techSupport.transfer(value * techSupportPercent / 100);
46     }
47 
48     // convert bytes to eth address 
49     function bytesToAddress(bytes bys) private pure returns (address addr) {
50         assembly {
51             addr := mload(add(bys, 20))
52         }
53     }
54 
55     // transfer default refback and referrer percents of invested
56     function transferRefPercents(uint value, address sender) private {
57         if (msg.data.length != 0) {
58             address referrer = bytesToAddress(msg.data);
59             if(referrer != sender) {
60                 sender.transfer(value * refBack / 100);
61                 referrer.transfer(value * refPercent / 100);
62             } else {
63                 techSupport.transfer(value * refPercent / 100);
64             }
65         } else {
66             techSupport.transfer(value * refPercent / 100);
67         }
68     }
69 
70     // calculate profit amount as such:
71     // amount = (amount invested) * ((percent * 10)/ 1000) * (blocks since last transaction) / 6100
72     // percent is multiplied by 10 to calculate fractional percentages and then divided by 1000 instead of 100
73     // 6100 is an average block count per day produced by Ethereum blockchain
74     function () external payable {
75         if (invested[msg.sender] != 0) {
76             
77             uint thisBalance = address(this).balance;
78             uint amount = invested[msg.sender] * calculateProfitPercent(thisBalance) / 1000 * (block.number - atBlock[msg.sender]) / 6100;
79 
80             address sender = msg.sender;
81             sender.transfer(amount);
82         }
83         if (msg.value > 0) {
84             transferDefaultPercentsOfInvested(msg.value);
85             transferRefPercents(msg.value, msg.sender);
86         }
87         atBlock[msg.sender] = block.number;
88         invested[msg.sender] += (msg.value);
89     }
90     
91     function balanceOf() public view returns(uint256) {
92         if (invested[msg.sender] != 0) {
93         uint thisBalance = address(this).balance;
94         uint ofBalance = invested[msg.sender]* calculateProfitPercent(thisBalance) / 1000 * (block.number - atBlock[msg.sender]) / 6100;
95         return ofBalance;
96         }
97         else return 0;
98         
99     }
100 }