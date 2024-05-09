1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract Pausable is Ownable {
41   event Pause();
42   event Unpause();
43 
44   bool public paused = false;
45 
46 
47   /**
48    * @dev Modifier to make a function callable only when the contract is not paused.
49    */
50   modifier whenNotPaused() {
51     require(!paused);
52     _;
53   }
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is paused.
57    */
58   modifier whenPaused() {
59     require(paused);
60     _;
61   }
62 
63   /**
64    * @dev called by the owner to pause, triggers stopped state
65    */
66   function pause() onlyOwner whenNotPaused public {
67     paused = true;
68     Pause();
69   }
70 
71   /**
72    * @dev called by the owner to unpause, returns to normal state
73    */
74   function unpause() onlyOwner whenPaused public {
75     paused = false;
76     Unpause();
77   }
78 }
79 
80 library Math {
81   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
82     return a >= b ? a : b;
83   }
84 
85   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
86     return a < b ? a : b;
87   }
88 
89   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
90     return a >= b ? a : b;
91   }
92 
93   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
94     return a < b ? a : b;
95   }
96 }
97 
98 contract Destructible is Ownable {
99 
100   function Destructible() public payable { }
101 
102   /**
103    * @dev Transfers the current balance to the owner and terminates the contract.
104    */
105   function destroy() onlyOwner public {
106     selfdestruct(owner);
107   }
108 
109   function destroyAndSend(address _recipient) onlyOwner public {
110     selfdestruct(_recipient);
111   }
112 }
113 
114 contract ProfitSharing is Ownable, Destructible, Pausable {
115     using SafeMath for uint256;
116 
117     struct Period {
118         uint128 endTime;
119         uint128 block;
120         uint128 balance;
121     }
122 
123     // public
124     BalanceHistoryToken public token;
125     uint256 public periodDuration;
126     Period public currentPeriod;
127     mapping(address => mapping(uint => bool)) public payments;
128 
129     // internal
130 
131     // events
132     event PaymentCompleted(address indexed requester, uint indexed paymentPeriodBlock, uint amount);
133     event PeriodReset(uint block, uint endTime, uint balance, uint totalSupply);
134 
135     /// @dev Constructor of the contract
136     function ProfitSharing(address _tokenAddress) public {
137         periodDuration = 4 weeks;
138         resetPeriod();
139         token = BalanceHistoryToken(_tokenAddress);
140     }
141 
142     /// @dev Default payable fallback. 
143     function () public payable {
144     }
145 
146     /// @dev Withdraws the full amount shared with the sender.
147     function withdraw() public whenNotPaused {
148         withdrawFor(msg.sender);
149     }
150 
151     /// @dev Allows someone to call withdraw on behalf of someone else. 
152     /// Useful if we expose via web3 but metamask account is different than owner of tokens.
153     function withdrawFor(address tokenOwner) public whenNotPaused {
154         // Ensure that this address hasn't been previously paid out for this period.
155         require(!payments[tokenOwner][currentPeriod.block]);
156         
157         // Check if it is time to calculate the next payout period.
158         resetPeriod();
159 
160         // Calculate the amount of the current payout period
161         uint payment = getPaymentTotal(tokenOwner);
162         require(payment > 0);
163         assert(this.balance >= payment);
164 
165         payments[tokenOwner][currentPeriod.block] = true;
166         PaymentCompleted(tokenOwner, currentPeriod.block, payment);
167         tokenOwner.transfer(payment);
168     }
169 
170     /// @dev Resets the period given the duration of the current period
171     function resetPeriod() internal {
172         uint nowTime = getNow();
173         if (currentPeriod.endTime < nowTime) {
174             currentPeriod.endTime = uint128(nowTime.add(periodDuration)); 
175             currentPeriod.block = uint128(block.number);
176             currentPeriod.balance = uint128(this.balance);
177             if (token != address(0x0)) {
178                 PeriodReset(block.number, nowTime.add(periodDuration), this.balance, token.totalSupply());
179             }
180         }
181     }
182 
183     /// @dev Gets the total payment amount for the sender given the current period.
184     function getPaymentTotal(address tokenOwner) public constant returns (uint256) {
185         if (payments[tokenOwner][currentPeriod.block]) {
186             return 0;
187         }
188 
189         // Get the amount of balance at the beginning of the payment period
190         uint tokenOwnerBalance = token.balanceOfAtBlock(tokenOwner, currentPeriod.block);
191 
192         // Calculate the amount of the current payout period
193         return calculatePayment(tokenOwnerBalance);
194     }
195 
196     /// @dev Updates the token address of the payment type.
197     function updateToken(address tokenAddress) public onlyOwner {
198         token = BalanceHistoryToken(tokenAddress);
199     }
200 
201     /// @dev Calculates the payment given the sender balance for the current period.
202     function calculatePayment(uint tokenOwnerBalance) public constant returns(uint) {
203         return tokenOwnerBalance.mul(currentPeriod.balance).div(token.totalSupply());
204     }
205 
206     /// @dev Internal function for mocking purposes
207     function getNow() internal view returns (uint256) {
208         return now;
209     }
210 
211     /// @dev Updates the period duration
212     function updatePeriodDuration(uint newPeriodDuration) public onlyOwner {
213         require(newPeriodDuration > 0);
214         periodDuration = newPeriodDuration;
215     }
216 
217     /// @dev Forces a period reset
218     function forceResetPeriod() public onlyOwner {
219         uint nowTime = getNow();
220         currentPeriod.endTime = uint128(nowTime.add(periodDuration)); 
221         currentPeriod.block = uint128(block.number);
222         currentPeriod.balance = uint128(this.balance);
223         if (token != address(0x0)) {
224             PeriodReset(block.number, nowTime.add(periodDuration), this.balance, token.totalSupply());
225         }
226     }
227 }
228 
229 library SafeMath {
230   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
231     if (a == 0) {
232       return 0;
233     }
234     uint256 c = a * b;
235     assert(c / a == b);
236     return c;
237   }
238 
239   function div(uint256 a, uint256 b) internal pure returns (uint256) {
240     // assert(b > 0); // Solidity automatically throws when dividing by 0
241     uint256 c = a / b;
242     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243     return c;
244   }
245 
246   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247     assert(b <= a);
248     return a - b;
249   }
250 
251   function add(uint256 a, uint256 b) internal pure returns (uint256) {
252     uint256 c = a + b;
253     assert(c >= a);
254     return c;
255   }
256 }
257 
258 contract FullERC20 {
259   event Transfer(address indexed from, address indexed to, uint256 value);
260   event Approval(address indexed owner, address indexed spender, uint256 value);
261   
262   uint256 public totalSupply;
263   uint8 public decimals;
264 
265   function balanceOf(address who) public view returns (uint256);
266   function transfer(address to, uint256 value) public returns (bool);
267   function allowance(address owner, address spender) public view returns (uint256);
268   function transferFrom(address from, address to, uint256 value) public returns (bool);
269   function approve(address spender, uint256 value) public returns (bool);
270 }
271 
272 contract BalanceHistoryToken is FullERC20 {
273   function balanceOfAtBlock(address who, uint256 blockNumber) public view returns (uint256);
274 }