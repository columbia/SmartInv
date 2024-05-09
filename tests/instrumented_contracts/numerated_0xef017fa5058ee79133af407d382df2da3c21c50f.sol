1 pragma solidity 0.4.25;
2 
3 /**
4 * Smart-contract 155percents
5 * You can invest ETH to the 155percents and take 4% per day, also you can send 0.001 ETH to contract and
6 * your percent will be increase on 0.04% per day while you hold your profit, after you withdraw percent will returns to 4%
7 *
8 * - To invest you can send at least 0.01 ETH to contract
9 * - To withdraw your profit you can send 0 ETH to contract
10 * - To turn on increasing percent you can send 0.001 ETH to contract
11 */
12 contract OneHundredFiftyFive {
13 
14     using SafeMath for uint256;
15 
16     struct Investor {
17         uint256 deposit;
18         uint256 paymentTime;
19         uint256 withdrawals;
20         bool hold;
21     }
22 
23     mapping (address => Investor) public investors;
24 
25     uint256 public countOfInvestors;
26     uint256 public startTime;
27 
28     address public ownerAddress = 0xC24ddFFaaCEB94f48D2771FE47B85b49818204Be;
29 
30     /**
31     * @dev Constructor function which set starting time
32     */
33     constructor() public {
34         startTime = now;
35     }
36 
37     /**
38     * @dev  Evaluate user current percent.
39     * @param _address Investor's address
40     * @return Amount of profit depends on HOLD mode
41     */
42     function getUserProfit(address _address) view public returns (uint256) {
43         Investor storage investor = investors[_address];
44 
45         uint256 passedMinutes = now.sub(investor.paymentTime).div(1 minutes);
46 
47         if (investor.hold) {
48             uint firstDay = 0;
49 
50             if (passedMinutes >= 1440) {
51                 firstDay = 1440;
52             }
53 
54             //Evaluate profit to according increasing profit percent on 0.04% daily
55             //deposit * ( 400 +  4 * (passedMinutes-1440)/1440) * (passedMinutes)/14400
56             return investor.deposit.mul(400 + 4 * (passedMinutes.sub(firstDay)).div(1440)).mul(passedMinutes).div(14400000);
57         } else {
58             //Evaluate profit on 4% per day
59             //deposit*4/100*(passedMinutes)/1440
60             uint256 differentPercent = investor.deposit.mul(4).div(100);
61             return differentPercent.mul(passedMinutes).div(1440);
62         }
63     }
64 
65     /**
66     * @dev Return current Ethereum time
67     */
68     function getCurrentTime() view public returns (uint256) {
69         return now;
70     }
71 
72     /**
73     * @dev Withdraw profit from contract. Investor will be deleted if he will try withdraw after received 155%
74     * @param _address Investor's address
75     */
76     function withdraw(address _address) private {
77         Investor storage investor = investors[_address];
78         uint256 balance = getUserProfit(_address);
79 
80         if (investor.deposit > 0 && balance > 0) {
81             if (address(this).balance < balance) {
82                 balance = address(this).balance;
83             }
84 
85             investor.withdrawals = investor.withdrawals.add(balance);
86             investor.paymentTime = now;
87 
88             if (investor.withdrawals >= investor.deposit.mul(155).div(100)) {
89                 investor.deposit = 0;
90                 investor.paymentTime = 0;
91                 investor.withdrawals = 0;
92                 investor.hold = false;
93                 countOfInvestors--;
94             }
95 
96             msg.sender.transfer(balance);
97         }
98     }
99 
100     /**
101     * @dev  You able:
102     * - To invest you can send at least 0.01 ETH to contract
103     * - To withdraw your profit you can send 0 ETH to contract
104     * - To turn on increasing percent you can send 0.001 ETH to contract
105     */
106     function () external payable {
107         Investor storage investor = investors[msg.sender];
108 
109         if (msg.value >= 0.01 ether) {
110 
111             ownerAddress.transfer(msg.value.mul(10).div(100));
112 
113             if (investor.deposit == 0) {
114                 countOfInvestors++;
115             }
116 
117             withdraw(msg.sender);
118 
119             investor.deposit = investor.deposit.add(msg.value);
120             investor.paymentTime = now;
121         } else if (msg.value == 0.001 ether) {
122             withdraw(msg.sender);
123             investor.hold = true;
124         } else {
125             withdraw(msg.sender);
126         }
127     }
128 }
129 
130 /**
131  * @title SafeMath
132  * @dev Math operations with safety checks that revert on error
133  */
134 library SafeMath {
135 
136     /**
137     * @dev Multiplies two numbers, reverts on overflow.
138     */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b);
149 
150         return c;
151     }
152 
153     /**
154     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
155     */
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         require(b > 0); // Solidity only automatically asserts when dividing by 0
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161         return c;
162     }
163 
164     /**
165     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
166     */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         require(b <= a);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175     * @dev Adds two numbers, reverts on overflow.
176     */
177     function add(uint256 a, uint256 b) internal pure returns (uint256) {
178         uint256 c = a + b;
179         require(c >= a);
180 
181         return c;
182     }
183 
184     /**
185     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
186     * reverts when dividing by zero.
187     */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b != 0);
190         return a % b;
191     }
192 }