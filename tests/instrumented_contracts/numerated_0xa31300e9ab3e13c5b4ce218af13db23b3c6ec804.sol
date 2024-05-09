1 pragma solidity ^0.4.18;
2 
3 // File: contracts/flavours/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 }
41 
42 // File: contracts/commons/SafeMath.sol
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51       return 0;
52     }
53     uint256 c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57 
58   function div(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a / b;
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 // File: contracts/flavours/Lockable.sol
76 
77 /**
78  * @title Lockable
79  * @dev Base contract which allows children to
80  *      implement main operations locking mechanism.
81  */
82 contract Lockable is Ownable {
83   event Lock();
84   event Unlock();
85 
86   bool public locked = false;
87 
88   /**
89    * @dev Modifier to make a function callable
90   *       only when the contract is not locked.
91    */
92   modifier whenNotLocked() {
93     require(!locked);
94     _;
95   }
96 
97   /**
98    * @dev Modifier to make a function callable
99    *      only when the contract is locked.
100    */
101   modifier whenLocked() {
102     require(locked);
103     _;
104   }
105 
106   /**
107    * @dev called by the owner to locke, triggers locked state
108    */
109   function lock() onlyOwner whenNotLocked public {
110     locked = true;
111     Lock();
112   }
113 
114   /**
115    * @dev called by the owner
116    *      to unlock, returns to unlocked state
117    */
118   function unlock() onlyOwner whenLocked public {
119     locked = false;
120     Unlock();
121   }
122 }
123 
124 // File: contracts/base/BaseFixedERC20Token.sol
125 
126 contract BaseFixedERC20Token is Lockable {
127   using SafeMath for uint;
128 
129   /// @dev ERC20 Total supply
130   uint public totalSupply;
131 
132   mapping(address => uint) balances;
133 
134   mapping(address => mapping (address => uint)) private allowed;
135 
136   /// @dev Fired if Token transfered accourding to ERC20
137   event Transfer(address indexed from, address indexed to, uint value);
138 
139   /// @dev Fired if Token withdraw is approved accourding to ERC20
140   event Approval(address indexed owner, address indexed spender, uint value);
141 
142   /**
143    * @dev Gets the balance of the specified address.
144    * @param owner_ The address to query the the balance of.
145    * @return An uint representing the amount owned by the passed address.
146    */
147   function balanceOf(address owner_) public view returns (uint balance) {
148     return balances[owner_];
149   }
150 
151   /**
152    * @dev Transfer token for a specified address
153    * @param to_ The address to transfer to.
154    * @param value_ The amount to be transferred.
155    */
156   function transfer(address to_, uint value_) whenNotLocked public returns (bool) {
157     require(to_ != address(0) && value_ <= balances[msg.sender]);
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(value_);
160     balances[to_] = balances[to_].add(value_);
161     Transfer(msg.sender, to_, value_);
162     return true;
163   }
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param from_ address The address which you want to send tokens from
168    * @param to_ address The address which you want to transfer to
169    * @param value_ uint the amount of tokens to be transferred
170    */
171   function transferFrom(address from_, address to_, uint value_) whenNotLocked public returns (bool) {
172     require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
173     balances[from_] = balances[from_].sub(value_);
174     balances[to_] = balances[to_].add(value_);
175     allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
176     Transfer(from_, to_, value_);
177     return true;
178   }
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    *
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering.
185    *
186    * To change the approve amount you first have to reduce the addresses
187    * allowance to zero by calling `approve(spender_, 0)` if it is not
188    * already 0 to mitigate the race condition described in:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    *
191    * @param spender_ The address which will spend the funds.
192    * @param value_ The amount of tokens to be spent.
193    */
194   function approve(address spender_, uint value_) whenNotLocked public returns (bool) {
195     if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
196       revert();
197     }
198     allowed[msg.sender][spender_] = value_;
199     Approval(msg.sender, spender_, value_);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param owner_ address The address which owns the funds.
206    * @param spender_ address The address which will spend the funds.
207    * @return A uint specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address owner_, address spender_) view public returns (uint) {
210     return allowed[owner_][spender_];
211   }
212 }
213 
214 // File: contracts/base/BaseICOToken.sol
215 
216 /**
217  * @dev Not mintable, ERC20 compilant token, distributed by ICO/Pre-ICO.
218  */
219 contract BaseICOToken is BaseFixedERC20Token {
220 
221   /// @dev Available supply of tokens
222   uint public availableSupply;
223 
224   /// @dev ICO/Pre-ICO smart contract allowed to distribute public funds for this
225   address public ico;
226 
227   /// @dev Fired if investment for `amount` of tokens performed by `to` address
228   event ICOTokensInvested(address indexed to, uint amount);
229 
230   /// @dev ICO contract changed for this token
231   event ICOChanged(address indexed icoContract);
232 
233   /**
234    * @dev Not mintable, ERC20 compilant token, distributed by ICO/Pre-ICO.
235    * @param totalSupply_ Total tokens supply.
236    */
237   function BaseICOToken(uint totalSupply_) public {
238     locked = true;
239     totalSupply = totalSupply_;
240     availableSupply = totalSupply_;
241   }
242 
243   /**
244    * @dev Set address of ICO smart-contract which controls token
245    * initial token distribution.
246    * @param ico_ ICO contract address.
247    */
248   function changeICO(address ico_) onlyOwner public {
249     ico = ico_;
250     ICOChanged(ico);
251   }
252 
253   function isValidICOInvestment(address to_, uint amount_) internal view returns(bool) {
254     return msg.sender == ico && to_ != address(0) && amount_ <= availableSupply;
255   }
256 
257   /**
258    * @dev Assign `amount_` of tokens to investor identified by `to_` address.
259    * @param to_ Investor address.
260    * @param amount_ Number of tokens distributed.
261    */
262   function icoInvestment(address to_, uint amount_) public returns (uint) {
263     require(isValidICOInvestment(to_, amount_));
264     availableSupply -= amount_;
265     balances[to_] = balances[to_].add(amount_);
266     ICOTokensInvested(to_, amount_);
267     return amount_;
268   }
269 }
270 
271 // File: contracts/base/BaseICO.sol
272 
273 /**
274  * @dev Base abstract smart contract for any ICO
275  */
276 contract BaseICO is Ownable {
277 
278   /// @dev ICO state
279   enum State {
280     // ICO is not active and not started
281     Inactive,
282     // ICO is active, tokens can be distributed among investors.
283     // ICO parameters (end date, hard/low caps) cannot be changed.
284     Active,
285     // ICO is suspended, tokens cannot be distributed among investors.
286     // ICO can be resumed to `Active state`.
287     // ICO parameters (end date, hard/low caps) may changed.
288     Suspended,
289     // ICO is termnated by owner, ICO cannot be resumed.
290     Terminated,
291     // ICO goals are not reached,
292     // ICO terminated and cannot be resumed.
293     NotCompleted,
294     // ICO completed, ICO goals reached successfully,
295     // ICO terminated and cannot be resumed.
296     Completed
297   }
298 
299   /// @dev Token which controlled by this ICO
300   BaseICOToken public token;
301 
302   /// @dev Current ICO state.
303   State public state;
304 
305   /// @dev ICO start date seconds since epoch.
306   uint public startAt;
307 
308   /// @dev ICO end date seconds since epoch.
309   uint public endAt;
310 
311   /// @dev Minimal amount of investments in wei needed for successfull ICO
312   uint public lowCapWei;
313 
314   /// @dev Maximal amount of investments in wei for this ICO.
315   /// If reached ICO will be in `Completed` state.
316   uint public hardCapWei;
317 
318   /// @dev Minimal amount of investments in wei per investor.
319   uint public lowCapTxWei;
320 
321   /// @dev Maximal amount of investments in wei per investor.
322   uint public hardCapTxWei;
323 
324   /// @dev Number of investments collected by this ICO
325   uint public collectedWei;
326 
327   /// @dev Team wallet used to collect funds
328   address public teamWallet;
329 
330   /// @dev True if whitelist enabled
331   bool public whitelistEnabled = true;
332 
333   /// @dev ICO whitelist
334   mapping (address => bool) public whitelist;
335 
336   // ICO state transition events
337   event ICOStarted(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
338   event ICOResumed(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
339   event ICOSuspended();
340   event ICOTerminated();
341   event ICONotCompleted();
342   event ICOCompleted(uint collectedWei);
343   event ICOInvestment(address indexed from, uint investedWei, uint tokens, uint8 bonusPct);
344   event ICOWhitelisted(address indexed addr);
345   event ICOBlacklisted(address indexed addr);
346 
347   modifier isSuspended() {
348     require(state == State.Suspended);
349     _;
350   }
351 
352   modifier isActive() {
353     require(state == State.Active);
354     _;
355   }
356 
357   /**
358    * Add address to ICO whitelist
359    * @param address_ Investor address
360    */
361   function whitelist(address address_) external onlyOwner {
362     whitelist[address_] = true;
363     ICOWhitelisted(address_);
364   }
365 
366   /**
367    * Remove address from ICO whitelist
368    * @param address_ Investor address
369    */
370   function blacklist(address address_) external onlyOwner {
371     delete whitelist[address_];
372     ICOBlacklisted(address_);
373   }
374 
375   /**
376    * @dev Returns true if given address in ICO whitelist
377    */
378   function whitelisted(address address_) public view returns (bool) {
379     if (whitelistEnabled) {
380       return whitelist[address_];
381     } else {
382       return true;
383     }
384   }
385 
386   /**
387    * @dev Enable whitelisting
388    */
389   function enableWhitelist() public onlyOwner {
390     whitelistEnabled = true;
391   }
392 
393   /**
394    * @dev Disable whitelisting
395    */
396   function disableWhitelist() public onlyOwner {
397     whitelistEnabled = false;
398   }
399 
400   /**
401    * @dev Trigger start of ICO.
402    * @param endAt_ ICO end date, seconds since epoch.
403    */
404   function start(uint endAt_) onlyOwner public {
405     require(endAt_ > block.timestamp && state == State.Inactive);
406     endAt = endAt_;
407     startAt = block.timestamp;
408     state = State.Active;
409     ICOStarted(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
410   }
411 
412   /**
413    * @dev Suspend this ICO.
414    * ICO can be activated later by calling `resume()` function.
415    * In suspend state, ICO owner can change basic ICO paraneter using `tune()` function,
416    * tokens cannot be distributed among investors.
417    */
418   function suspend() onlyOwner isActive public {
419     state = State.Suspended;
420     ICOSuspended();
421   }
422 
423   /**
424    * @dev Terminate the ICO.
425    * ICO goals are not reached, ICO terminated and cannot be resumed.
426    */
427   function terminate() onlyOwner public {
428     require(state != State.Terminated &&
429             state != State.NotCompleted &&
430             state != State.Completed);
431     state = State.Terminated;
432     ICOTerminated();
433   }
434 
435   /**
436    * @dev Change basic ICO paraneters. Can be done only during `Suspended` state.
437    * Any provided parameter is used only if it is not zero.
438    * @param endAt_ ICO end date seconds since epoch. Used if it is not zero.
439    * @param lowCapWei_ ICO low capacity. Used if it is not zero.
440    * @param hardCapWei_ ICO hard capacity. Used if it is not zero.
441    * @param lowCapTxWei_ Min limit for ICO per transaction
442    * @param hardCapTxWei_ Hard limit for ICO per transaction
443    */
444   function tune(uint endAt_,
445                 uint lowCapWei_,
446                 uint hardCapWei_,
447                 uint lowCapTxWei_,
448                 uint hardCapTxWei_) onlyOwner isSuspended public {
449     if (endAt_ > block.timestamp) {
450       endAt = endAt_;
451     }
452     if (lowCapWei_ > 0) {
453       lowCapWei = lowCapWei_;
454     }
455     if (hardCapWei_ > 0) {
456       hardCapWei = hardCapWei_;
457     }
458     if (lowCapTxWei_ > 0) {
459       lowCapTxWei = lowCapTxWei_;
460     }
461     if (hardCapTxWei_ > 0) {
462       hardCapTxWei = hardCapTxWei_;
463     }
464     require(lowCapWei <= hardCapWei && lowCapTxWei <= hardCapTxWei);
465     touch();
466   }
467 
468   /**
469    * @dev Resume a previously suspended ICO.
470    */
471   function resume() onlyOwner isSuspended public {
472     state = State.Active;
473     ICOResumed(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
474     touch();
475   }
476 
477   /**
478    * @dev Send ether to the fund collection wallet
479    */
480   function forwardFunds() internal {
481     teamWallet.transfer(msg.value);
482   }
483 
484   /**
485    * @dev Recalculate ICO state based on current block time.
486    * Should be called periodically by ICO owner.
487    */
488   function touch() public;
489 
490   /**
491    * @dev Buy tokens
492    */
493   function buyTokens() public payable;
494 }
495 
496 // File: contracts/MDICOStage2.sol
497 
498 /**
499  * @title MD tokens ICO Stage 2 contract.
500  */
501 contract MDICOStage2 is BaseICO {
502   using SafeMath for uint;
503 
504   /// @dev 18 decimals for token
505   uint internal constant ONE_TOKEN = 1e18;
506 
507   /// @dev 1e18 WEI == 1ETH == 1000 tokens
508   uint public constant ETH_TOKEN_EXCHANGE_RATIO = 1000;
509 
510   /// @dev 0% bonus for ICO Stage 2
511   uint8 internal constant BONUS = 0; // 0%
512 
513   function MDICOStage2(address icoToken_,
514                     address teamWallet_,
515                     uint lowCapWei_,
516                     uint hardCapWei_,
517                     uint lowCapTxWei_,
518                     uint hardCapTxWei_) public {
519     require(icoToken_ != address(0) && teamWallet_ != address(0));
520     token = BaseICOToken(icoToken_);
521     teamWallet = teamWallet_;
522     state = State.Inactive;
523     lowCapWei = lowCapWei_;
524     hardCapWei = hardCapWei_;
525     lowCapTxWei = lowCapTxWei_;
526     hardCapTxWei = hardCapTxWei_;
527   }
528 
529   /**
530    * @dev Recalculate ICO state based on current block time.
531    * Should be called periodically by ICO owner.
532    */
533   function touch() public {
534     if (state != State.Active && state != State.Suspended) {
535       return;
536     }
537     if (collectedWei >= hardCapWei) {
538       state = State.Completed;
539       endAt = block.timestamp;
540       ICOCompleted(collectedWei);
541     } else if (block.timestamp >= endAt) {
542       if (collectedWei < lowCapWei) {
543         state = State.NotCompleted;
544         ICONotCompleted();
545       } else {
546         state = State.Completed;
547         ICOCompleted(collectedWei);
548       }
549     }
550   }
551 
552   function buyTokens() public payable {
553     require(state == State.Active &&
554             block.timestamp <= endAt &&
555             msg.value >= lowCapTxWei &&
556             msg.value <= hardCapTxWei &&
557             collectedWei + msg.value <= hardCapWei &&
558             whitelisted(msg.sender));
559     uint amountWei = msg.value;
560     uint iwei = amountWei.mul(100 + BONUS).div(100);
561     uint itokens = iwei * ETH_TOKEN_EXCHANGE_RATIO;
562     token.icoInvestment(msg.sender, itokens); // Transfer tokens to investor
563     collectedWei = collectedWei.add(amountWei);
564     ICOInvestment(msg.sender, amountWei, itokens, BONUS);
565     forwardFunds();
566     touch();
567   }
568 
569   /**
570    * Accept direct payments
571    */
572   function() external payable {
573     buyTokens();
574   }
575 }