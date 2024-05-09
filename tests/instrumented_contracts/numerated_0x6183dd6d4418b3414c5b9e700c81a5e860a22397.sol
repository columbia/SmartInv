1 pragma solidity ^0.4.18;
2 
3 contract FullERC20 {
4   event Transfer(address indexed from, address indexed to, uint256 value);
5   event Approval(address indexed owner, address indexed spender, uint256 value);
6   
7   uint256 public totalSupply;
8   uint8 public decimals;
9 
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15 }
16 
17 contract BalanceHistoryToken is FullERC20 {
18   function balanceOfAtBlock(address who, uint256 blockNumber) public view returns (uint256);
19 }
20 
21 library Math {
22   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
23     return a >= b ? a : b;
24   }
25 
26   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
27     return a < b ? a : b;
28   }
29 
30   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
31     return a >= b ? a : b;
32   }
33 
34   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
35     return a < b ? a : b;
36   }
37 }
38 
39 library SafeMath {
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     if (a == 0) {
42       return 0;
43     }
44     uint256 c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return c;
54   }
55 
56   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57     assert(b <= a);
58     return a - b;
59   }
60 
61   function add(uint256 a, uint256 b) internal pure returns (uint256) {
62     uint256 c = a + b;
63     assert(c >= a);
64     return c;
65   }
66 }
67 
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() public {
80     owner = msg.sender;
81   }
82 
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner) public onlyOwner {
98     require(newOwner != address(0));
99     OwnershipTransferred(owner, newOwner);
100     owner = newOwner;
101   }
102 
103 }
104 
105 contract Destructible is Ownable {
106 
107   function Destructible() public payable { }
108 
109   /**
110    * @dev Transfers the current balance to the owner and terminates the contract.
111    */
112   function destroy() onlyOwner public {
113     selfdestruct(owner);
114   }
115 
116   function destroyAndSend(address _recipient) onlyOwner public {
117     selfdestruct(_recipient);
118   }
119 }
120 
121 contract Pausable is Ownable {
122   event Pause();
123   event Unpause();
124 
125   bool public paused = false;
126 
127 
128   /**
129    * @dev Modifier to make a function callable only when the contract is not paused.
130    */
131   modifier whenNotPaused() {
132     require(!paused);
133     _;
134   }
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is paused.
138    */
139   modifier whenPaused() {
140     require(paused);
141     _;
142   }
143 
144   /**
145    * @dev called by the owner to pause, triggers stopped state
146    */
147   function pause() onlyOwner whenNotPaused public {
148     paused = true;
149     Pause();
150   }
151 
152   /**
153    * @dev called by the owner to unpause, returns to normal state
154    */
155   function unpause() onlyOwner whenPaused public {
156     paused = false;
157     Unpause();
158   }
159 }
160 
161 contract ProfitSharingV2 is Ownable, Destructible, Pausable {
162     using SafeMath for uint256;
163 
164     struct Period {
165         uint128 endTime;
166         uint128 block;
167         uint128 balance;
168     }
169 
170     // public
171     BalanceHistoryToken public token;
172     uint256 public periodDuration;
173     Period public currentPeriod;
174     mapping(address => mapping(uint => bool)) public payments;
175 
176     // internal
177 
178     // events
179     event PaymentCompleted(address indexed requester, uint indexed paymentPeriodBlock, uint amount);
180     event PeriodReset(uint block, uint endTime, uint balance, uint totalSupply);
181 
182     /// @dev Constructor of the contract
183     function ProfitSharingV2(address _tokenAddress) public {
184         periodDuration = 4 weeks;
185         resetPeriod();
186         token = BalanceHistoryToken(_tokenAddress);
187     }
188 
189     /// @dev Default payable fallback. 
190     function () public payable {
191     }
192 
193     /// @dev Withdraws the full amount shared with the sender.
194     function withdraw() public whenNotPaused {
195         withdrawFor(msg.sender);
196     }
197 
198     /// @dev Allows someone to call withdraw on behalf of someone else. 
199     /// Useful if we expose via web3 but metamask account is different than owner of tokens.
200     function withdrawFor(address tokenOwner) public whenNotPaused {
201         // Ensure that this address hasn't been previously paid out for this period.
202         require(!payments[tokenOwner][currentPeriod.block]);
203         
204         // Check if it is time to calculate the next payout period.
205         resetPeriod();
206 
207         // Calculate the amount of the current payout period
208         uint payment = getPaymentTotal(tokenOwner);
209         require(payment > 0);
210         assert(this.balance >= payment);
211 
212         payments[tokenOwner][currentPeriod.block] = true;
213         PaymentCompleted(tokenOwner, currentPeriod.block, payment);
214         tokenOwner.transfer(payment);
215     }
216 
217     /// @dev Resets the period given the duration of the current period
218     function resetPeriod() public {
219         uint nowTime = getNow();
220         if (currentPeriod.endTime < nowTime) {
221             currentPeriod.endTime = uint128(nowTime.add(periodDuration)); 
222             currentPeriod.block = uint128(block.number);
223             currentPeriod.balance = uint128(this.balance);
224             if (token != address(0x0)) {
225                 PeriodReset(block.number, nowTime.add(periodDuration), this.balance, token.totalSupply());
226             }
227         }
228     }
229 
230     /// @dev Gets the total payment amount for the sender given the current period.
231     function getPaymentTotal(address tokenOwner) public constant returns (uint256) {
232         if (payments[tokenOwner][currentPeriod.block]) {
233             return 0;
234         }
235 
236         uint nowTime = getNow();
237         uint tokenOwnerBalance = currentPeriod.endTime < nowTime ?  
238             // This will never hit while withdrawing, but will be used in the case where the period
239             // has ended, but is awaiting the first withrawl. It will avoid the case where the current period
240             // reports an amount greater than the next period withdrawl amount.
241             token.balanceOfAtBlock(tokenOwner, block.number) :
242             // Get the amount of balance at the beginning of the payment period
243             token.balanceOfAtBlock(tokenOwner, currentPeriod.block);
244             
245         // Calculate the amount of the current payout period
246         return calculatePayment(tokenOwnerBalance);
247     }
248 
249     function isPaymentCompleted(address tokenOwner) public constant returns (bool) {
250         return payments[tokenOwner][currentPeriod.block];
251     }
252 
253     /// @dev Updates the token address of the payment type.
254     function updateToken(address tokenAddress) public onlyOwner {
255         token = BalanceHistoryToken(tokenAddress);
256     }
257 
258     /// @dev Calculates the payment given the sender balance for the current period.
259     function calculatePayment(uint tokenOwnerBalance) public constant returns(uint) {
260         return tokenOwnerBalance.mul(currentPeriod.balance).div(token.totalSupply());
261     }
262 
263     /// @dev Internal function for mocking purposes
264     function getNow() internal view returns (uint256) {
265         return now;
266     }
267 
268     /// @dev Updates the period duration
269     function updatePeriodDuration(uint newPeriodDuration) public onlyOwner {
270         require(newPeriodDuration > 0);
271         periodDuration = newPeriodDuration;
272     }
273 
274     /// @dev Forces a period reset
275     function forceResetPeriod() public onlyOwner {
276         uint nowTime = getNow();
277         currentPeriod.endTime = uint128(nowTime.add(periodDuration)); 
278         currentPeriod.block = uint128(block.number);
279         currentPeriod.balance = uint128(this.balance);
280         if (token != address(0x0)) {
281             PeriodReset(block.number, nowTime.add(periodDuration), this.balance, token.totalSupply());
282         }
283     }
284 }