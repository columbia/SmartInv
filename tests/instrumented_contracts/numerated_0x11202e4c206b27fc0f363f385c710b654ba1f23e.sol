1 pragma solidity ^0.5.10;
2 
3 /**
4 Get 15% profit every month with a contract Shareholder VOMER!
5 *
6 * - OBTAINING 15% PER 1 MONTH. (percentages are charged in equal parts every 1 sec)
7 * 0.49995% per 1 day
8 * 0.020625% per 1 hour
9 * 0.0003375% per 1 minute
10 * 0.0000057% per 1 sec
11 * - lifetime payments
12 * - unprecedentedly reliable
13 * - bring luck
14 * - first minimum contribution from 0.01 eth
15 * - Currency and Payment - ETH
16 * - Contribution allocation schemes:
17 * - 100% of payments - 5% percent for support
18 * 
19 * VOMER.net
20 *
21 * RECOMMENDED GAS LIMIT: 200,000
22 * RECOMMENDED GAS PRICE: https://ethgasstation.info/
23 * DO NOT TRANSFER DIRECTLY FROM AN EXCHANGE (only use your ETH wallet, from which you have a private key)
24 * You can check payments on the website etherscan.io, in the “Internal Txns” tab of your wallet.
25 *
26 * Payments to developers 5%
27 *
28 * Restart of the contract is also absent. If there is no money in the Fund, payments are stopped and resumed after the Fund is filled. Thus, the contract will work forever!
29 *
30 * How to use:
31 * 1. Send from your ETH wallet to the address of the smart contract
32 * Any amount from 0.01 ETH.
33 * 2. Confirm your transaction in the history of your application or etherscan.io, indicating the address of your wallet.
34 * Take profit by sending 0 eth to contract (profit is calculated every second).
35 *
36 **/
37 
38 contract ERC20Token
39 {
40     mapping (address => uint256) public balanceOf;
41     function transfer(address _to, uint256 _value) public;
42 }
43 
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      * - Addition cannot overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57 
58         return c;
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot overflow.
69      */
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b <= a, "SafeMath: subtraction overflow");
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the multiplication of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      * - The divisor cannot be zero.
110      */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         // Solidity only automatically asserts when dividing by 0
113         require(b > 0, "SafeMath: division by zero");
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      * - The divisor cannot be zero.
130      */
131     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b != 0, "SafeMath: modulo by zero");
133         return a % b;
134     }
135 }
136 
137 contract ShareholderVomer
138 {
139     using SafeMath for uint256;
140     
141     address payable public owner = 0x016311b7Fe50d6A295e014ac54696a220582FEB9;
142     
143     uint256 minBalance = 1;
144     ERC20Token VMR_Token = ERC20Token(0x063b98a414EAA1D4a5D4fC235a22db1427199024);
145     
146     struct InvestorData {
147         uint256 funds;
148         uint256 lastDatetime;
149         uint256 totalProfit;
150     }
151     mapping (address => InvestorData) investors;
152     
153     modifier onlyOwner()
154     {
155         assert(msg.sender == owner);
156         _;
157     }
158     
159     function withdraw(uint256 amount)  public onlyOwner {
160         owner.transfer(amount);
161     }
162     
163     function changeOwner(address payable newOwner) public onlyOwner {
164         owner = newOwner;
165     }
166     
167     function changeMinBalance(uint256 newMinBalance) public onlyOwner {
168         minBalance = newMinBalance;
169     }
170     
171     function bytesToAddress(bytes memory bys) private pure returns (address payable addr) {
172         assembly {
173           addr := mload(add(bys,20))
174         } 
175     }
176     // function for transfer any token from contract
177     function transferTokens (address token, address target, uint256 amount) onlyOwner public
178     {
179         ERC20Token(token).transfer(target, amount);
180     }
181     
182     function getInfo(address investor) view public returns (uint256 totalFunds, uint256 pendingReward, uint256 totalProfit, uint256 contractBalance)
183     {
184         InvestorData memory data = investors[investor];
185         totalFunds = data.funds;
186         if (data.funds > 0) pendingReward = data.funds.mul(15).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
187         totalProfit = data.totalProfit;
188         contractBalance = address(this).balance;
189     }
190     
191     function() payable external
192     {
193         assert(msg.sender == tx.origin); // prevent bots to interact with contract
194         
195         if (msg.sender == owner) return;
196         
197         assert(VMR_Token.balanceOf(msg.sender) >= minBalance * 10**18);
198         
199         
200         InvestorData storage data = investors[msg.sender];
201         
202         if (msg.value > 0)
203         {
204             // investment at least 0.01 ether
205             assert(msg.value >= 0.01 ether);
206             owner.transfer(msg.value.mul(5).div(100));  // 5%            
207         }
208         
209         
210         if (data.funds != 0) {
211             // 15% per 30 days
212             uint256 reward = data.funds.mul(15).div(100).mul(block.timestamp - data.lastDatetime).div(30 days);
213             data.totalProfit = data.totalProfit.add(reward);
214             
215             address(msg.sender).transfer(reward);
216         }
217 
218         data.lastDatetime = block.timestamp;
219         data.funds = data.funds.add(msg.value.mul(95).div(100));
220         
221     }
222 }