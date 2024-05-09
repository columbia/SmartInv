1 pragma solidity ^0.4.13;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control 
7  * functions, this simplifies the implementation of "user permissions". 
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /** 
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner. 
24    */
25   modifier onlyOwner() {
26     if (msg.sender != owner) {
27       throw;
28     }
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to. 
36    */
37   function transferOwnership(address newOwner) onlyOwner {
38     if (newOwner != address(0)) {
39       owner = newOwner;
40     }
41   }
42 
43 }
44 
45 
46 contract ERC20Basic {
47   uint256 public totalSupply;
48   function balanceOf(address who) constant returns (uint256);
49   function transfer(address to, uint256 value) returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) returns (bool);
57   function approve(address spender, uint256 value) returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66   function mul(uint256 a, uint256 b) internal returns (uint256) {
67     uint256 c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71 
72   function div(uint256 a, uint256 b) internal returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   function sub(uint256 a, uint256 b) internal returns (uint256) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   function add(uint256 a, uint256 b) internal returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances. 
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) returns (bool) {
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of. 
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) constant returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // if (_value > _allowance) throw;
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) returns (bool) {
162 
163     // To change the approve amount you first have to reduce the addresses`
164     //  allowance to zero by calling `approve(_spender, 0)` if it is not
165     //  already 0 to mitigate the race condition described here:
166     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
168 
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifing the amount of tokens still avaible for the spender.
179    */
180   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184 }
185 
186 
187 contract GenesisToken is StandardToken, Ownable {
188   using SafeMath for uint256;
189 
190   // metadata
191   string public constant name = 'Genesis';
192   string public constant symbol = 'GNS';
193   uint256 public constant decimals = 18;
194   string public version = '0.0.1';
195 
196   // events
197   event EarnedGNS(address indexed contributor, uint256 amount);
198   event TransferredGNS(address indexed from, address indexed to, uint256 value);
199 
200   // constructor
201   function GenesisToken(
202     address _owner,
203     uint256 initialBalance)
204   {
205     owner = _owner;
206     totalSupply = initialBalance;
207     balances[_owner] = initialBalance;
208     EarnedGNS(_owner, initialBalance);
209   }
210 
211   /**
212    * @dev Function to mint tokens
213    * @param _to The address that will recieve the minted tokens.
214    * @param _amount The amount of tokens to mint.
215    * @return A boolean that indicates if the operation was successful.
216    */
217   function giveTokens(address _to, uint256 _amount) onlyOwner returns (bool) {
218     totalSupply = totalSupply.add(_amount);
219     balances[_to] = balances[_to].add(_amount);
220     EarnedGNS(_to, _amount);
221     return true;
222   }
223 }
224 
225 /**
226  * This contract holds all the revenues generated by the DAO, and pays out to
227  * token holders on a periodic basis.
228  */
229 contract CrowdWallet is Ownable {
230   using SafeMath for uint;
231 
232   struct Deposit {
233     uint amount;
234     uint block;
235   }
236 
237   struct Payout {
238     uint amount;
239     uint block;
240   }
241 
242   // Genesis Tokens determine the payout for each contributor.
243   GenesisToken public token;
244 
245   // Track deposits/payouts by address
246   mapping (address => Deposit[]) public deposits;
247   mapping (address => Payout[]) public payouts;
248 
249   // Track the sum of all payouts & deposits ever made to this contract.
250   uint public lifetimeDeposits;
251   uint public lifetimePayouts;
252 
253   // Time between pay periods are defined as a number of blocks.
254   uint public blocksPerPayPeriod = 172800; // ~30 days
255   uint public previousPayoutBlock;
256   uint public nextPayoutBlock;
257 
258   // The balance at the end of each period is saved here and allocated to token
259   // holders from the previous period.
260   uint public payoutPool;
261 
262   // For doing division. Numerator should be multiplied by this.
263   uint multiplier = 10**18;
264 
265   // Set a minimum that a user must have earned in order to withdraw it.
266   uint public minWithdrawalThreshold = 100000000000000000; // 0.1 ETH in wei
267 
268   // Events
269   event onDeposit(address indexed _from, uint _amount);
270   event onPayout(address indexed _to, uint _amount);
271   event onPayoutFailure(address indexed _to, uint amount);
272 
273   /**
274    * Constructor - set the GNS token address and the initial number of blocks
275    * in-between each pay period.
276    */
277   function CrowdWallet(address _gns, address _owner, uint _blocksPerPayPeriod) {
278     token = GenesisToken(_gns);
279     owner = _owner;
280     blocksPerPayPeriod = _blocksPerPayPeriod;
281     nextPayoutBlock = now.add(blocksPerPayPeriod);
282   }
283 
284   function setMinimumWithdrawal(uint _weiAmount) onlyOwner {
285     minWithdrawalThreshold = _weiAmount;
286   }
287 
288   function setBlocksPerPayPeriod(uint _blocksPerPayPeriod) onlyOwner {
289     blocksPerPayPeriod = _blocksPerPayPeriod;
290   }
291 
292   /**
293    * To prevent cheating, when a withdrawal is made, the tokens for that address
294    * become immediately locked until the next period. Otherwise, they could send
295    * their tokens to another wallet and withdraw again.
296    */
297   function withdraw() {
298     require(previousPayoutBlock > 0);
299 
300     // Ensure the user has not already made a withdrawal this period.
301     require(!isAddressLocked(msg.sender));
302 
303     uint payoutAmount = calculatePayoutForAddress(msg.sender);
304 
305     // Ensure user's payout is above the minimum threshold for withdrawals.
306     require(payoutAmount > minWithdrawalThreshold);
307 
308     // User qualifies. Save the transaction with the current block number,
309     // effectively locking their tokens until the next payout date.
310     payouts[msg.sender].push(Payout({ amount: payoutAmount, block: now }));
311 
312     require(this.balance >= payoutAmount);
313 
314     onPayout(msg.sender, payoutAmount);
315 
316     lifetimePayouts += payoutAmount;
317 
318     msg.sender.transfer(payoutAmount);
319   }
320 
321   /**
322    * Once a user gets paid out for a period, we lock up the tokens they own
323    * until the next period. Otherwise, they can send their tokens to a fresh
324    * address and then double dip.
325    */
326   function isAddressLocked(address contributor) constant returns(bool) {
327     var paymentHistory = payouts[contributor];
328 
329     if (paymentHistory.length == 0) {
330       return false;
331     }
332 
333     var lastPayment = paymentHistory[paymentHistory.length - 1];
334 
335     return (lastPayment.block >= previousPayoutBlock) && (lastPayment.block < nextPayoutBlock);
336   }
337 
338   /**
339    * Check if we are in a new payout cycle.
340    */
341   function isNewPayoutPeriod() constant returns(bool) {
342     return now >= nextPayoutBlock;
343   }
344 
345   /**
346    * Start a new payout cycle
347    */
348   function startNewPayoutPeriod() {
349     require(isNewPayoutPeriod());
350 
351     previousPayoutBlock = nextPayoutBlock;
352     nextPayoutBlock = nextPayoutBlock.add(blocksPerPayPeriod);
353     payoutPool = this.balance;
354   }
355 
356   /**
357    * Determine the amount that should be paid out.
358    */
359   function calculatePayoutForAddress(address payee) constant returns(uint) {
360     uint ownedAmount = token.balanceOf(payee);
361     uint totalSupply = token.totalSupply();
362     uint percentage = (ownedAmount * multiplier) / totalSupply;
363     uint payout = (payoutPool * percentage) / multiplier;
364 
365     return payout;
366   }
367 
368   /**
369    * Check the contract's ETH balance.
370    */
371   function ethBalance() constant returns(uint) {
372     return this.balance;
373   }
374 
375   /**
376    * Income should go here.
377    */
378   function deposit() payable {
379     onDeposit(msg.sender, msg.value);
380     lifetimeDeposits += msg.value;
381     deposits[msg.sender].push(Deposit({ amount: msg.value, block: now }));
382   }
383 
384   function () payable {
385     deposit();
386   }
387 }