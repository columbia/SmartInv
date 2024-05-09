1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 
9 /**
10  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
11  *
12  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
13  */
14 
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() {
32     owner = msg.sender;
33   }
34 
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) onlyOwner {
50     require(newOwner != address(0));      
51     owner = newOwner;
52   }
53 
54 }
55 
56 
57 
58 /**
59  * @title ERC20Basic
60  * @dev Simpler version of ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/179
62  */
63 contract ERC20Basic {
64   uint256 public totalSupply;
65   function balanceOf(address who) constant returns (uint256);
66   function transfer(address to, uint256 value) returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 
71 contract Recoverable is Ownable {
72 
73   /// @dev Empty constructor (for now)
74   function Recoverable() {
75   }
76 
77   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
78   /// @param token Token which will we rescue to the owner from the contract
79   function recoverTokens(ERC20Basic token) onlyOwner public {
80     token.transfer(owner, tokensToBeReturned(token));
81   }
82 
83   /// @dev Interface function, can be overwritten by the superclass
84   /// @param token Token which balance we will check and return
85   /// @return The amount of tokens (in smallest denominator) the contract owns
86   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
87     return token.balanceOf(this);
88   }
89 }
90 
91 /**
92  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
93  *
94  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
95  */
96 
97 
98 /**
99  * Safe unsigned safe math.
100  *
101  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
102  *
103  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
104  *
105  * Maintained here until merged to mainline zeppelin-solidity.
106  *
107  */
108 library SafeMathLib {
109 
110   function times(uint a, uint b) returns (uint) {
111     uint c = a * b;
112     assert(a == 0 || c / a == b);
113     return c;
114   }
115 
116   function minus(uint a, uint b) returns (uint) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function plus(uint a, uint b) returns (uint) {
122     uint c = a + b;
123     assert(c>=a);
124     return c;
125   }
126 
127 }
128 
129 /**
130  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
131  *
132  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
133  */
134 
135 
136 
137 
138 
139 
140 
141 
142 
143 /**
144  * @title SafeMath
145  * @dev Math operations with safety checks that throw on error
146  */
147 library SafeMath {
148   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
149     uint256 c = a * b;
150     assert(a == 0 || c / a == b);
151     return c;
152   }
153 
154   function div(uint256 a, uint256 b) internal constant returns (uint256) {
155     // assert(b > 0); // Solidity automatically throws when dividing by 0
156     uint256 c = a / b;
157     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158     return c;
159   }
160 
161   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
162     assert(b <= a);
163     return a - b;
164   }
165 
166   function add(uint256 a, uint256 b) internal constant returns (uint256) {
167     uint256 c = a + b;
168     assert(c >= a);
169     return c;
170   }
171 }
172 
173 
174 
175 /**
176  * @title Basic token
177  * @dev Basic version of StandardToken, with no allowances. 
178  */
179 contract BasicToken is ERC20Basic {
180   using SafeMath for uint256;
181 
182   mapping(address => uint256) balances;
183 
184   /**
185   * @dev transfer token for a specified address
186   * @param _to The address to transfer to.
187   * @param _value The amount to be transferred.
188   */
189   function transfer(address _to, uint256 _value) returns (bool) {
190     balances[msg.sender] = balances[msg.sender].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     Transfer(msg.sender, _to, _value);
193     return true;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param _owner The address to query the the balance of. 
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   function balanceOf(address _owner) constant returns (uint256 balance) {
202     return balances[_owner];
203   }
204 
205 }
206 
207 
208 
209 
210 
211 
212 /**
213  * @title ERC20 interface
214  * @dev see https://github.com/ethereum/EIPs/issues/20
215  */
216 contract ERC20 is ERC20Basic {
217   function allowance(address owner, address spender) constant returns (uint256);
218   function transferFrom(address from, address to, uint256 value) returns (bool);
219   function approve(address spender, uint256 value) returns (bool);
220   event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 
224 
225 /**
226  * @title Standard ERC20 token
227  *
228  * @dev Implementation of the basic standard token.
229  * @dev https://github.com/ethereum/EIPs/issues/20
230  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
231  */
232 contract StandardToken is ERC20, BasicToken {
233 
234   mapping (address => mapping (address => uint256)) allowed;
235 
236 
237   /**
238    * @dev Transfer tokens from one address to another
239    * @param _from address The address which you want to send tokens from
240    * @param _to address The address which you want to transfer to
241    * @param _value uint256 the amout of tokens to be transfered
242    */
243   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
244     var _allowance = allowed[_from][msg.sender];
245 
246     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
247     // require (_value <= _allowance);
248 
249     balances[_to] = balances[_to].add(_value);
250     balances[_from] = balances[_from].sub(_value);
251     allowed[_from][msg.sender] = _allowance.sub(_value);
252     Transfer(_from, _to, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
258    * @param _spender The address which will spend the funds.
259    * @param _value The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint256 _value) returns (bool) {
262 
263     // To change the approve amount you first have to reduce the addresses`
264     //  allowance to zero by calling `approve(_spender, 0)` if it is not
265     //  already 0 to mitigate the race condition described here:
266     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
268 
269     allowed[msg.sender][_spender] = _value;
270     Approval(msg.sender, _spender, _value);
271     return true;
272   }
273 
274   /**
275    * @dev Function to check the amount of tokens that an owner allowed to a spender.
276    * @param _owner address The address which owns the funds.
277    * @param _spender address The address which will spend the funds.
278    * @return A uint256 specifing the amount of tokens still available for the spender.
279    */
280   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
281     return allowed[_owner][_spender];
282   }
283 
284 }
285 
286 
287 
288 /**
289  * Standard EIP-20 token with an interface marker.
290  *
291  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
292  *
293  */
294 contract StandardTokenExt is StandardToken {
295 
296   /* Interface declaration */
297   function isToken() public constant returns (bool weAre) {
298     return true;
299   }
300 }
301 
302 
303 
304 /**
305  * Hold tokens for a group investor of investors until the unlock date.
306  *
307  * After the unlock date the investor can claim their tokens.
308  *
309  * Steps
310  *
311  * - Prepare a spreadsheet for token allocation
312  * - Deploy this contract, with the sum to tokens to be distributed, from the owner account
313  * - Call setInvestor for all investors from the owner account using a local script and CSV input
314  * - Move tokensToBeAllocated in this contract using StandardToken.transfer()
315  * - Call lock from the owner account
316  * - Wait until the freeze period is over
317  * - After the freeze time is over investors can call claim() from their address to get their tokens
318  *
319  */
320 contract TokenVault is Ownable, Recoverable {
321   using SafeMathLib for uint;
322 
323   /** How many investors we have now */
324   uint public investorCount;
325 
326   /** Sum from the spreadsheet how much tokens we should get on the contract. If the sum does not match at the time of the lock the vault is faulty and must be recreated.*/
327   uint public tokensToBeAllocated;
328 
329   /** How many tokens investors have claimed so far */
330   uint public totalClaimed;
331 
332   /** How many tokens our internal book keeping tells us to have at the time of lock() when all investor data has been loaded */
333   uint public tokensAllocatedTotal;
334 
335   /** How much we have allocated to the investors invested */
336   mapping(address => uint) public balances;
337 
338   /** How many tokens investors have claimed */
339   mapping(address => uint) public claimed;
340 
341   /** When our claim freeze is over (UNIX timestamp) */
342   uint public freezeEndsAt;
343 
344   /** When this vault was locked (UNIX timestamp) */
345   uint public lockedAt;
346 
347   /** We can also define our own token, which will override the ICO one ***/
348   StandardTokenExt public token;
349 
350   /** What is our current state.
351    *
352    * Loading: Investor data is being loaded and contract not yet locked
353    * Holding: Holding tokens for investors
354    * Distributing: Freeze time is over, investors can claim their tokens
355    */
356   enum State{Unknown, Loading, Holding, Distributing}
357 
358   /** We allocated tokens for investor */
359   event Allocated(address investor, uint value);
360 
361   /** We distributed tokens to an investor */
362   event Distributed(address investors, uint count);
363 
364   event Locked();
365 
366   /**
367    * Create presale contract where lock up period is given days
368    *
369    * @param _owner Who can load investor data and lock
370    * @param _freezeEndsAt UNIX timestamp when the vault unlocks
371    * @param _token Token contract address we are distributing
372    * @param _tokensToBeAllocated Total number of tokens this vault will hold - including decimal multiplcation
373    *
374    */
375   function TokenVault(address _owner, uint _freezeEndsAt, StandardTokenExt _token, uint _tokensToBeAllocated) {
376 
377     owner = _owner;
378 
379     // Invalid owenr
380     if(owner == 0) {
381       throw;
382     }
383 
384     token = _token;
385 
386     // Check the address looks like a token contract
387     if(!token.isToken()) {
388       throw;
389     }
390 
391     // Give argument
392     if(_freezeEndsAt == 0) {
393       throw;
394     }
395 
396     // Sanity check on _tokensToBeAllocated
397     if(_tokensToBeAllocated == 0) {
398       throw;
399     }
400 
401     freezeEndsAt = _freezeEndsAt;
402     tokensToBeAllocated = _tokensToBeAllocated;
403   }
404 
405   /// @dev Add a presale participating allocation
406   function setInvestor(address investor, uint amount) public onlyOwner {
407 
408     if(lockedAt > 0) {
409       // Cannot add new investors after the vault is locked
410       throw;
411     }
412 
413     if(amount == 0) throw; // No empty buys
414 
415     // Don't allow reset
416     if(balances[investor] > 0) {
417       throw;
418     }
419 
420     balances[investor] = amount;
421 
422     investorCount++;
423 
424     tokensAllocatedTotal += amount;
425 
426     Allocated(investor, amount);
427   }
428 
429   /// @dev Lock the vault
430   ///      - All balances have been loaded in correctly
431   ///      - Tokens are transferred on this vault correctly
432   ///      - Checks are in place to prevent creating a vault that is locked with incorrect token balances.
433   function lock() onlyOwner {
434 
435     if(lockedAt > 0) {
436       throw; // Already locked
437     }
438 
439     // Spreadsheet sum does not match to what we have loaded to the investor data
440     if(tokensAllocatedTotal != tokensToBeAllocated) {
441       throw;
442     }
443 
444     // Do not lock the vault if the given tokens are not on this contract
445     if(token.balanceOf(address(this)) != tokensAllocatedTotal) {
446       throw;
447     }
448 
449     lockedAt = now;
450 
451     Locked();
452   }
453 
454   /// @dev In the case locking failed, then allow the owner to reclaim the tokens on the contract.
455   function recoverFailedLock() onlyOwner {
456     if(lockedAt > 0) {
457       throw;
458     }
459 
460     // Transfer all tokens on this contract back to the owner
461     token.transfer(owner, token.balanceOf(address(this)));
462   }
463 
464   /// @dev Get the current balance of tokens in the vault
465   /// @return uint How many tokens there are currently in vault
466   function getBalance() public constant returns (uint howManyTokensCurrentlyInVault) {
467     return token.balanceOf(address(this));
468   }
469 
470   /// @dev Claim N bought tokens to the investor as the msg sender
471   function claim() {
472 
473     address investor = msg.sender;
474 
475     if(lockedAt == 0) {
476       throw; // We were never locked
477     }
478 
479     if(now < freezeEndsAt) {
480       throw; // Trying to claim early
481     }
482 
483     if(balances[investor] == 0) {
484       // Not our investor
485       throw;
486     }
487 
488     if(claimed[investor] > 0) {
489       throw; // Already claimed
490     }
491 
492     uint amount = balances[investor];
493 
494     claimed[investor] = amount;
495 
496     totalClaimed += amount;
497 
498     token.transfer(investor, amount);
499 
500     Distributed(investor, amount);
501   }
502 
503   /// @dev This function is prototyped in Recoverable contract
504   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
505     return getBalance().minus(tokensAllocatedTotal);
506   }
507 
508   /// @dev Resolve the contract umambigious state
509   function getState() public constant returns(State) {
510     if(lockedAt == 0) {
511       return State.Loading;
512     } else if(now > freezeEndsAt) {
513       return State.Distributing;
514     } else {
515       return State.Holding;
516     }
517   }
518 
519 }