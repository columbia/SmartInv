1 pragma solidity ^0.4.23;
2 
3 contract EtherSmart {
4 
5     mapping (address => uint256) public invested;
6     mapping (address => uint256) public atBlock;
7     address techSupport = 0x0C7223e71ee75c6801a6C8DB772A30beb403683b;
8     uint techSupportPercent = 2;
9     address advertising = 0x1308C144980c92E1825fae9Ab078B1CB5AAe8B23;
10     uint advertisingPercent = 7;
11     address defaultReferrer = 0x35580368B30742C9b6fcf859803ee7EEcED5485c;
12     uint refPercent = 2;
13     uint refBack = 2;
14 
15     // calculation of the percentage of profit depending on the balance sheet
16     // returns the percentage times 10
17     function calculateProfitPercent(uint bal) private pure returns (uint) {
18         if (bal >= 1e22) { // balance >= 10000 ETH
19             return 50;
20         }
21         if (bal >= 7e21) { // balance >= 7000 ETH
22             return 47;
23         }
24         if (bal >= 5e21) { // balance >= 5000 ETH
25             return 45;
26         }
27         if (bal >= 3e21) { // balance >= 3000 ETH
28             return 42;
29         }
30         if (bal >= 1e21) { // balance >= 1000 ETH
31             return 40;
32         }
33         if (bal >= 5e20) { // balance >= 500 ETH
34             return 35;
35         }
36         if (bal >= 2e20) { // balance >= 200 ETH
37             return 30;
38         }
39         if (bal >= 1e20) { // balance >= 100 ETH
40             return 27;
41         } else {
42             return 25;
43         }
44     }
45 
46     // transfer default percents of invested
47     function transferDefaultPercentsOfInvested(uint value) private {
48         techSupport.transfer(value * techSupportPercent / 100);
49         advertising.transfer(value * advertisingPercent / 100);
50     }
51 
52     // convert bytes to eth address 
53     function bytesToAddress(bytes bys) private pure returns (address addr) {
54         assembly {
55             addr := mload(add(bys, 20))
56         }
57     }
58 
59     // transfer default refback and referrer percents of invested
60     function transferRefPercents(uint value, address sender) private {
61         if (msg.data.length != 0) {
62             address referrer = bytesToAddress(msg.data);
63             if(referrer != sender) {
64                 sender.transfer(value * refBack / 100);
65                 referrer.transfer(value * refPercent / 100);
66             } else {
67                 defaultReferrer.transfer(value * refPercent / 100);
68             }
69         } else {
70             defaultReferrer.transfer(value * refPercent / 100);
71         }
72     }
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
90         }
91         atBlock[msg.sender] = block.number;
92         invested[msg.sender] += (msg.value);
93     }
94 }