1 pragma solidity 0.4.25;
2 
3 contract X2Contract {
4     using SafeMath for uint256;
5 
6     address public constant promotionAddress = 0x22e483dBeb45EDBC74d4fE25d79B5C28eA6Aa8Dd;
7     address public constant adminAddress = 0x3C1FD40A99066266A60F60d17d5a7c51434d74bB;
8 
9     mapping (address => uint256) public deposit;
10     mapping (address => uint256) public withdrawals;
11     mapping (address => uint256) public time;
12 
13     uint256 public minimum = 0.01 ether;
14     uint public promotionPercent = 10;
15     uint public adminPercent = 2;
16     uint256 public countOfInvestors;
17 
18     /**
19     * @dev Get percent depends on balance of contract
20     * @return Percent
21     */
22     function getPhasePercent() view public returns (uint){
23         uint contractBalance = address(this).balance;
24         if (contractBalance < 300 ether) {
25             return 2;
26         }
27         if (contractBalance >= 300 ether && contractBalance < 1200 ether) {
28             return 3;
29         }
30         if (contractBalance >= 1200 ether) {
31             return 4;
32         }
33     }
34 
35     /**
36     * @dev Evaluate current balance
37     * @param _address Address of investor
38     * @return Payout amount
39     */
40     function getUserBalance(address _address) view public returns (uint256) {
41         uint percent = getPhasePercent();
42         uint256 differentTime = now.sub(time[_address]).div(1 hours);
43         uint256 differentPercent = deposit[_address].mul(percent).div(100);
44         uint256 payout = differentPercent.mul(differentTime).div(24);
45 
46         return payout;
47     }
48 
49     /**
50     * @dev Withdraw profit from contract. Investor will be deleted if he will try withdraw after received x2
51     * @param _address Address of investor
52     */
53     function withdraw(address _address) private {
54         //Get user balance
55         uint256 balance = getUserBalance(_address);
56         //Conditions for withdraw, deposit should be more than 0, balance of contract should be more than balance of
57         //investor and balance of investor should be more than 0
58         if (deposit[_address] > 0 && address(this).balance >= balance && balance > 0) {
59             //Add withdrawal to storage
60             withdrawals[_address] = withdrawals[_address].add(balance);
61             //Reset time
62             time[_address] = now;
63             //If withdrawals more greater or equal deposit * 2 - delete investor
64             if (withdrawals[_address] >= deposit[_address].mul(2)){
65                 deposit[_address] = 0;
66                 time[_address] = 0;
67                 withdrawals[_address] = 0;
68                 countOfInvestors--;
69             }
70             //Transfer percents to investor
71             _address.transfer(balance);
72         }
73 
74     }
75 
76     /**
77     * @dev  Payable function
78     */
79     function () external payable {
80         if (msg.value >= minimum){
81             //Payout for promotion
82             promotionAddress.transfer(msg.value.mul(promotionPercent).div(100));
83             //Payout for admin
84             adminAddress.transfer(msg.value.mul(adminPercent).div(100));
85 
86             //Withdraw a profit
87             withdraw(msg.sender);
88 
89             //Increase counter of investors
90             if (deposit[msg.sender] == 0){
91                 countOfInvestors++;
92             }
93 
94             //Add deposit to storage
95             deposit[msg.sender] = deposit[msg.sender].add(msg.value);
96             //Reset last time of deposit
97             time[msg.sender] = now;
98         } else {
99             //Withdraw a profit
100             withdraw(msg.sender);
101         }
102     }
103 }
104 
105 /**
106  * @title SafeMath
107  * @dev Math operations with safety checks that revert on error
108  */
109 library SafeMath {
110 
111     /**
112     * @dev Multiplies two numbers, reverts on overflow.
113     */
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         // Gas optimization: this is cheaper then requiring 'a' not being zero, but the
116         // benefit is lost if 'b' is also tested.
117         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
118         if (a == 0) {
119             return 0;
120         }
121 
122         uint256 c = a * b;
123         require(c / a == b);
124 
125         return c;
126     }
127 
128     /**
129     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
130     */
131     function div(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b > 0); // Solidity only automatically asserts when dividing by 0
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139     /**
140     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
141     */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b <= a);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150     * @dev Adds two numbers, reverts on overflow.
151     */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a);
155 
156         return c;
157     }
158 
159     /**
160     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
161     * reverts when dividing by zero.
162     */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b != 0);
165         return a % b;
166     }
167 }