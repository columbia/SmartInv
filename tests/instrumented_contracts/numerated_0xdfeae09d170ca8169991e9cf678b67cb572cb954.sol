1 pragma solidity ^0.4.25;
2 
3 contract opterium {
4     /*
5  *   See: http://opterium.ru/
6  * 
7  *   No one can change this smart contract, including the community creators.  
8  *   The profit is : (interest is accrued continuously).
9  * Up to 100  ETH = 1.0 % in 36 hours of your invested amount
10  * From 100   ETH = 1.5 % in 36 hours *
11  * From 200   ETH = 1.8 % in 36 hours *
12  * From 500   ETH = 2.0 % in 36 hours *
13  * From 1000  ETH = 1.6 % in 36 hours *
14  * From 3000  ETH = 1.4 % in 36 hours *
15  * From 5000  ETH = 1.2 % in 36 hours *
16  * From 7000  ETH = 1.0 % in 36 hours *
17  * From 10000 ETH = 2.5 % in 36 hours *
18  *   Minimum deposit is 0.011 ETH.
19  *
20  *  How to make a deposit:
21  *   Send cryptocurrency from ETH wallet (at least 0.011 ETH) to the address
22  *   of the smart contract - opterium
23  *   It is not allowed to make transfers from cryptocurrency exchanges.
24  *   Only personal ETH wallet with private keys is allowed.
25  * 
26  *   Recommended limits are 200000 ETH, check the current ETH rate at
27  *   the following link: https://ethgasstation.info/
28  * 
29  * How to get paid:
30  *   Request your profit by sending 0 ETH to the address of the smart contract.
31  *
32   */  
33     
34     mapping (address => uint256) public invested;
35     mapping (address => uint256) public atBlock;
36     address techSupport = 0x720497fce7D8f7D7B89FB27E5Ae48b7DA884f582;
37     uint techSupportPercent = 2;
38     address defaultReferrer = 0x720497fce7D8f7D7B89FB27E5Ae48b7DA884f582;
39     uint refPercent = 2;
40     uint refBack = 2;
41 
42     function calculateProfitPercent(uint bal) private pure returns (uint) {
43         if (bal >= 1e22) {
44             return 25;
45         }
46         if (bal >= 7e21) {
47             return 10;
48         }
49         if (bal >= 5e21) {
50             return 12;
51         }
52         if (bal >= 3e21) {
53             return 14;
54         }
55         if (bal >= 1e21) {
56             return 16;
57         }
58         if (bal >= 5e20) {
59             return 20;
60         }
61         if (bal >= 2e20) {
62             return 18;
63         }
64         if (bal >= 1e20) {
65             return 15;
66         } else {
67             return 10;
68         }
69     }
70 
71     function transferDefaultPercentsOfInvested(uint value) private {
72         techSupport.transfer(value * techSupportPercent / 100);
73     }
74 
75     function bytesToAddress(bytes bys) private pure returns (address addr) {
76         assembly {
77             addr := mload(add(bys, 20))
78         }
79     }
80 
81     function transferRefPercents(uint value, address sender) private {
82         if (msg.data.length != 0) {
83             address referrer = bytesToAddress(msg.data);
84             if(referrer != sender) {
85                 sender.transfer(value * refBack / 100);
86                 referrer.transfer(value * refPercent / 100);
87             } else {
88                 defaultReferrer.transfer(value * refPercent / 100);
89             }
90         } else {
91             defaultReferrer.transfer(value * refPercent / 100);
92         }
93     }
94 
95   
96     function () external payable {
97         if (invested[msg.sender] != 0) {
98             
99             uint thisBalance = address(this).balance;
100             uint amount = invested[msg.sender] * calculateProfitPercent(thisBalance) / 1000 * (block.number - atBlock[msg.sender]) / 9150;
101 
102             address sender = msg.sender;
103             sender.transfer(amount);
104         }
105         if (msg.value > 0) {
106             transferDefaultPercentsOfInvested(msg.value);
107             transferRefPercents(msg.value, msg.sender);
108         }
109         atBlock[msg.sender] = block.number;
110         invested[msg.sender] += (msg.value);
111     }
112 }