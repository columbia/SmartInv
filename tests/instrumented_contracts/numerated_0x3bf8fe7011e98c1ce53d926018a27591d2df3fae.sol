1 pragma solidity ^0.4.25;
2 
3 
4 contract Olympus {
5     
6     using SafeMath for uint;
7     
8     mapping (address=>uint) public invest;
9     mapping (address=>uint) public percentage;
10     mapping (address=>uint) public time_stamp;
11     
12     address techSupport = 0x0bD47808d4A09aD155b00C39dBb101Fb71e1C0f0;
13     uint techSupportPercent = 2;
14     
15     uint refPercent = 3;
16     uint refBack = 3;
17     
18     uint public payment_delay = 1 hours;
19     uint public count_investors = 0;
20     
21     function bytesToAddress(bytes _data) internal pure returns(address referrer) {
22         assembly {
23             referrer := mload(add(_data, 20))
24         }
25         return referrer;
26     }
27     
28     function elapsedTime()public view returns(uint) {
29         return now.sub(time_stamp[msg.sender]).div(payment_delay);
30     }
31     
32     function calculateProfitPercent(uint bal) private pure returns (uint) {
33         if (bal >= 4e21) { // balance >= 4000 ETH
34             return 2500;   // 6% per day
35         }
36         if (bal >= 2e21) { // balance >= 2000 ETH
37             return 2083;   // 5% per day
38         }
39         if (bal >= 1e21) { // balance >= 1000 ETH
40             return 1875;   // 4.5% per day
41         }
42         if (bal >= 5e20) { // balance >= 500 ETH
43             return 1666;   // 4% per day
44         }
45         if (bal >= 4e20) { // balance >= 400 ETH
46             return 1583;   // 3.8% per day
47         }
48         if (bal >= 3e20) { // balance >= 300 ETH
49             return 1500;   // 3.6% per day
50         }
51         if (bal >= 2e20) { // balance >= 200 ETH
52             return 1416;   // 3.4% per day
53         }
54         if (bal >= 1e20) { // balance >= 100 ETH
55             return 1333;   // 3.2% per day
56         } else {
57             return 1250;   // 3% per day
58         }
59     }
60     
61     function deposit() internal {
62         if(invest[msg.sender] > 0 && elapsedTime() > 0) {
63             pickUpCharges();
64         }
65         if (msg.data.length > 0 ) {
66             address referrer = bytesToAddress(bytes(msg.data));
67             address sender = msg.sender;
68             if(referrer != sender) {
69                 sender.transfer(msg.value * refBack / 100);
70                 referrer.transfer(msg.value * refPercent / 100);
71             } else {
72                 techSupport.transfer(msg.value * refPercent / 100);
73             }
74         } else {
75             techSupport.transfer(msg.value * refPercent / 100);
76         }
77         if(invest[msg.sender] == 0) {
78             count_investors+=1;
79         }
80         techSupport.transfer(msg.value.mul(techSupportPercent).div(100));
81         invest[msg.sender]+= msg.value;
82         time_stamp[msg.sender] = now;
83     }
84     
85     function pickUpCharges() internal {
86         uint hours_passed = elapsedTime();
87         require(hours_passed > 0, 'You can receive payment 1 time per hour');
88         uint thisBalance = address(this).balance;
89         uint value = (invest[msg.sender].mul(calculateProfitPercent(thisBalance)).div(1000000)).mul(hours_passed);
90         percentage[msg.sender] += value;
91         time_stamp[msg.sender] = now;
92         msg.sender.transfer(value);
93     }
94     
95     function() external payable {
96         if(msg.value > 0) {
97                 deposit();
98         } else if(msg.value == 0) {
99             pickUpCharges();
100         }
101     }
102 }
103 
104 library SafeMath {
105 
106   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107     if (a == 0) {
108       return 0;
109     }
110     uint256 c = a * b;
111     require(c / a == b);
112     return c;
113   }
114 
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116     require(b > 0); // Solidity only automatically asserts when dividing by 0
117     uint256 c = a / b;
118     return c;
119   }
120 
121   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122     require(b <= a);
123     uint256 c = a - b;
124     return c;
125   }
126 
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128     uint256 c = a + b;
129     require(c >= a);
130     return c;
131   }
132 }