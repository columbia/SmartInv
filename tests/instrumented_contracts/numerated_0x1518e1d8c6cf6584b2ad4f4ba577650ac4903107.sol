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
238     locked = true; // Audit: I'd call lock() for better readability
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
253   // Audit: Keep the sender logic separated from the input validation
254   // Audit Create modifier onlyICOAddress -  and use it in the icoInvestment method
255   function isValidICOInvestment(address to_, uint amount_) internal view returns(bool) {
256     return msg.sender == ico && to_ != address(0) && amount_ <= availableSupply;
257   }
258 
259   /**
260    * @dev Assign `amount_` of tokens to investor identified by `to_` address.
261    * @param to_ Investor address.
262    * @param amount_ Number of tokens distributed.
263    */
264   function icoInvestment(address to_, uint amount_) public returns (uint) {
265     require(isValidICOInvestment(to_, amount_));
266     availableSupply -= amount_; // Audit: Please keep using safe math here too 
267     balances[to_] = balances[to_].add(amount_);
268     ICOTokensInvested(to_, amount_);
269     return amount_;
270   }
271 }
272 
273 // File: contracts/base/BaseICO.sol
274 
275 /**
276  * @dev Base abstract smart contract for any ICO
277  */
278 contract BaseICO is Ownable {
279 
280   /// @dev ICO state
281   enum State {
282     // ICO is not active and not started
283     Inactive,
284     // ICO is active, tokens can be distributed among investors.
285     // ICO parameters (end date, hard/low caps) cannot be changed.
286     Active,
287     // ICO is suspended, tokens cannot be distributed among investors.
288     // ICO can be resumed to `Active state`.
289     // ICO parameters (end date, hard/low caps) may changed.
290     Suspended,
291     // ICO is termnated by owner, ICO cannot be resumed.
292     Terminated,
293     // ICO goals are not reached,
294     // ICO terminated and cannot be resumed.
295     NotCompleted,
296     // ICO completed, ICO goals reached successfully,
297     // ICO terminated and cannot be resumed.
298     Completed
299   }
300 
301   /// @dev Token which controlled by this ICO
302   BaseICOToken public token;
303 
304   /// @dev Current ICO state.
305   State public state;
306 
307   /// @dev ICO start date seconds since epoch.
308   uint public startAt;
309 
310   /// @dev ICO end date seconds since epoch.
311   uint public endAt;
312 
313   /// @dev Minimal amount of investments in wei needed for successfull ICO
314   uint public lowCapWei; // Audit: I'd name this softCapWei
315 
316   /// @dev Maximal amount of investments in wei for this ICO.
317   /// If reached ICO will be in `Completed` state.
318   uint public hardCapWei;
319 
320   /// @dev Minimal amount of investments in wei per investor.
321   uint public lowCapTxWei; // Audit: I'd name this minimalContributionWei
322 
323   /// @dev Maximal amount of investments in wei per investor.
324   uint public hardCapTxWei; // Audit: I'd name this maximumContributionWei
325 
326   /// @dev Number of investments collected by this ICO
327   uint public collectedWei;
328 
329   /// @dev Team wallet used to collect funds
330   address public teamWallet;
331 
332   /// @dev True if whitelist enabled
333   bool public whitelistEnabled = true;
334 
335   /// @dev ICO whitelist
336   mapping (address => bool) public whitelist;
337 
338   // ICO state transition events
339   event ICOStarted(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
340   event ICOResumed(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
341   event ICOSuspended();
342   event ICOTerminated();
343   event ICONotCompleted();
344   event ICOCompleted(uint collectedWei);
345   event ICOInvestment(address indexed from, uint investedWei, uint tokens, uint8 bonusPct);
346   event ICOWhitelisted(address indexed addr);
347   event ICOBlacklisted(address indexed addr);
348 
349   modifier isSuspended() {
350     require(state == State.Suspended);
351     _;
352   }
353 
354   modifier isActive() {
355     require(state == State.Active);
356     _;
357   }
358 
359   /**
360    * Add address to ICO whitelist
361    * @param address_ Investor address
362    */
363   function whitelist(address address_) external onlyOwner {
364     whitelist[address_] = true;
365     ICOWhitelisted(address_);
366   }
367 
368   /**
369    * Remove address from ICO whitelist
370    * @param address_ Investor address
371    */
372   function blacklist(address address_) external onlyOwner {
373     delete whitelist[address_];
374     ICOBlacklisted(address_);
375   }
376 
377   /**
378    * @dev Returns true if given address in ICO whitelist
379    */
380   function whitelisted(address address_) public view returns (bool) {
381     if (whitelistEnabled) {
382       return whitelist[address_];
383     } else {
384       return true;
385     }
386   }
387 
388   /**
389    * @dev Enable whitelisting
390    */
391   function enableWhitelist() public onlyOwner {
392     whitelistEnabled = true;
393   }
394 
395   /**
396    * @dev Disable whitelisting
397    */
398   function disableWhitelist() public onlyOwner {
399     whitelistEnabled = false;
400   }
401 
402   /**
403    * @dev Trigger start of ICO.
404    * @param endAt_ ICO end date, seconds since epoch.
405    */
406   function start(uint endAt_) onlyOwner public {
407     require(endAt_ > block.timestamp && state == State.Inactive);
408     endAt = endAt_;
409     startAt = block.timestamp;
410     state = State.Active;
411     ICOStarted(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
412   }
413 
414   /**
415    * @dev Suspend this ICO.
416    * ICO can be activated later by calling `resume()` function.
417    * In suspend state, ICO owner can change basic ICO paraneter using `tune()` function,
418    * tokens cannot be distributed among investors.
419    */
420   function suspend() onlyOwner isActive public {
421     state = State.Suspended;
422     ICOSuspended();
423   }
424 
425   /**
426    * @dev Terminate the ICO.
427    * ICO goals are not reached, ICO terminated and cannot be resumed.
428    */
429   function terminate() onlyOwner public {
430     require(state != State.Terminated &&
431             state != State.NotCompleted &&
432             state != State.Completed);
433     state = State.Terminated;
434     ICOTerminated();
435   }
436 
437   /**
438    * @dev Change basic ICO parameters. Can be done only during `Suspended` state.
439    * Any provided parameter is used only if it is not zero.
440    * @param endAt_ ICO end date seconds since epoch. Used if it is not zero.
441    * @param lowCapWei_ ICO low capacity. Used if it is not zero.
442    * @param hardCapWei_ ICO hard capacity. Used if it is not zero.
443    * @param lowCapTxWei_ Min limit for ICO per transaction
444    * @param hardCapTxWei_ Hard limit for ICO per transaction
445    */
446   function tune(uint endAt_,
447                 uint lowCapWei_,
448                 uint hardCapWei_,
449                 uint lowCapTxWei_,
450                 uint hardCapTxWei_) onlyOwner isSuspended public {
451     if (endAt_ > block.timestamp) {
452       endAt = endAt_;
453     }
454     if (lowCapWei_ > 0) {
455       lowCapWei = lowCapWei_;
456     }
457     if (hardCapWei_ > 0) {
458       hardCapWei = hardCapWei_;
459     }
460     if (lowCapTxWei_ > 0) {
461       lowCapTxWei = lowCapTxWei_;
462     }
463     if (hardCapTxWei_ > 0) {
464       hardCapTxWei = hardCapTxWei_;
465     }
466     require(lowCapWei <= hardCapWei && lowCapTxWei <= hardCapTxWei);
467     touch();
468   }
469 
470   /**
471    * @dev Resume a previously suspended ICO.
472    */
473   function resume() onlyOwner isSuspended public {
474     state = State.Active;
475     ICOResumed(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
476     touch();
477   }
478 
479   /**
480    * @dev Send ether to the fund collection wallet
481    */
482    // Audit: I could not find logic for refund on softCap not reached
483    // Audit: Something like this might make sense for this case:
484    // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundVault.sol
485    // Here is how it can be used:
486    // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundableCrowdsale.sol
487   function forwardFunds() internal {
488     teamWallet.transfer(msg.value);
489   }
490 
491   /**
492    * @dev Recalculate ICO state based on current block time.
493    * Should be called periodically by ICO owner.
494    */
495   function touch() public;
496 
497   /**
498    * @dev Buy tokens
499    */
500   function buyTokens() public payable;
501 }
502 
503 // File: contracts/OTCPreICO.sol
504 
505 // Audit: If this contract is used for the full ICO not only the pre-sale it might make sense to rename it to OTCCrowdsale or something similar
506 
507  
508 /**
509  * @title OTCrit Pre-ICO smart contract.
510  */
511 contract OTCPreICO is BaseICO {
512   using SafeMath for uint;
513 
514   /// @dev 18 decimals for token
515   uint internal constant ONE_TOKEN = 1e18;
516 
517   /// @dev 1e18 WEI == 1ETH == 5000 tokens
518   uint public constant ETH_TOKEN_EXCHANGE_RATIO = 5000;
519 
520   // Audit: It might be better for these setters to be in a constructur in the BaseICO
521   function OTCPreICO(address icoToken_,
522                      address teamWallet_,
523                      uint lowCapWei_,
524                      uint hardCapWei_,
525                      uint lowCapTxWei_,
526                      uint hardCapTxWei_) public {
527     require(icoToken_ != address(0) && teamWallet_ != address(0));
528     token = BaseICOToken(icoToken_); 
529     teamWallet = teamWallet_;
530     state = State.Inactive;
531     lowCapWei = lowCapWei_;
532     hardCapWei = hardCapWei_;
533     lowCapTxWei = lowCapTxWei_;
534     hardCapTxWei = hardCapTxWei_;
535   }
536 
537   /**
538    * @dev Recalculate ICO state based on current block time.
539    * Should be called periodically by ICO owner.
540    */
541   function touch() public {
542     if (state != State.Active && state != State.Suspended) {
543       return;
544     }
545     if (collectedWei >= hardCapWei) {
546       state = State.Completed;
547       endAt = block.timestamp;
548       ICOCompleted(collectedWei);
549     } else if (block.timestamp >= endAt) {
550       if (collectedWei < lowCapWei) {
551         state = State.NotCompleted;
552         ICONotCompleted();
553       } else {
554         state = State.Completed;
555         ICOCompleted(collectedWei);
556       }
557     }
558   }
559 
560   function buyTokens() public payable {
561     require(state == State.Active &&
562             block.timestamp <= endAt &&
563             msg.value >= lowCapTxWei &&
564             msg.value <= hardCapTxWei &&
565             collectedWei + msg.value <= hardCapWei &&
566             whitelisted(msg.sender) );
567     uint amountWei = msg.value;
568     uint8 bonus = (block.timestamp - startAt >= 1 weeks) ? 10 : 20;
569     uint iwei = bonus > 0 ? amountWei.mul(100 + bonus).div(100) : amountWei;
570     uint itokens = iwei * ETH_TOKEN_EXCHANGE_RATIO;
571     token.icoInvestment(msg.sender, itokens); // Transfer tokens to investor
572     collectedWei = collectedWei.add(amountWei);
573     ICOInvestment(msg.sender, amountWei, itokens, bonus);
574     forwardFunds();
575     touch();
576   }
577 
578   /**
579    * Accept direct payments
580    */
581   function() external payable {
582     buyTokens();
583   }
584 }