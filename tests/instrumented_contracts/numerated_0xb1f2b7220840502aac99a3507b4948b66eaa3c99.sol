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
136   /// @dev Fired if Token transferred accourding to ERC20
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
217  * @dev Not mintable, ERC20 compilant token, distributed by ICO.
218  */
219 contract BaseICOToken is BaseFixedERC20Token {
220 
221   /// @dev Available supply of tokens
222   uint public availableSupply;
223 
224   /// @dev ICO smart contract allowed to distribute public funds for this
225   address public ico;
226 
227   /// @dev Fired if investment for `amount` of tokens performed by `to` address
228   event ICOTokensInvested(address indexed to, uint amount);
229 
230   /// @dev ICO contract changed for this token
231   event ICOChanged(address indexed icoContract);
232 
233   /**
234    * @dev Not mintable, ERC20 compilant token, distributed by ICO.
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
289     // ICO is terminated by owner, ICO cannot be resumed.
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
311   /// @dev Maximal amount of investments in wei for this ICO.
312   /// If reached ICO will be in `Completed` state.
313   uint public hardCapWei;
314 
315   /// @dev Minimal amount of investments in wei per investor.
316   uint public lowCapTxWei;
317 
318   /// @dev Maximal amount of investments in wei per investor.
319   uint public hardCapTxWei;
320 
321   /// @dev Number of investments collected by this ICO
322   uint public collectedWei;
323 
324   /// @dev Team wallet used to collect funds
325   address public teamWallet;
326 
327   /// @dev True if whitelist enabled
328   bool public whitelistEnabled = true;
329 
330   /// @dev ICO whitelist
331   mapping (address => bool) public whitelist;
332 
333   // ICO state transition events
334   event ICOStarted(uint indexed endAt, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
335   event ICOResumed(uint indexed endAt, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
336   event ICOSuspended();
337   event ICOTerminated();
338   event ICONotCompleted();
339   event ICOCompleted(uint collectedWei);
340   event ICOInvestment(address indexed from, uint investedWei, uint tokens, uint8 bonusPct);
341   event ICOWhitelisted(address indexed addr);
342   event ICOBlacklisted(address indexed addr);
343 
344   modifier isSuspended() {
345     require(state == State.Suspended);
346     _;
347   }
348 
349   modifier isActive() {
350     require(state == State.Active);
351     _;
352   }
353 
354   /**
355    * Add address to ICO whitelist
356    * @param address_ Investor address
357    */
358   function whitelist(address address_) external onlyOwner {
359     whitelist[address_] = true;
360     ICOWhitelisted(address_);
361   }
362 
363   /**
364    * Remove address from ICO whitelist
365    * @param address_ Investor address
366    */
367   function blacklist(address address_) external onlyOwner {
368     delete whitelist[address_];
369     ICOBlacklisted(address_);
370   }
371 
372   /**
373    * @dev Returns true if given address in ICO whitelist
374    */
375   function whitelisted(address address_) public view returns (bool) {
376     if (whitelistEnabled) {
377       return whitelist[address_];
378     } else {
379       return true;
380     }
381   }
382 
383   /**
384    * @dev Enable whitelisting
385    */
386   function enableWhitelist() onlyOwner public {
387     whitelistEnabled = true;
388   }
389 
390   /**
391    * @dev Disable whitelisting
392    */
393   function disableWhitelist() onlyOwner public {
394     whitelistEnabled = false;
395   }
396 
397   /**
398    * @dev Trigger start of ICO.
399    * @param endAt_ ICO end date, seconds since epoch.
400    */
401   function start(uint endAt_) onlyOwner public {
402     require(endAt_ > block.timestamp && state == State.Inactive);
403     endAt = endAt_;
404     startAt = block.timestamp;
405     state = State.Active;
406     ICOStarted(endAt, hardCapWei, lowCapTxWei, hardCapTxWei);
407   }
408 
409   /**
410    * @dev Suspend this ICO.
411    * ICO can be activated later by calling `resume()` function.
412    * In suspend state, ICO owner can change basic ICO paraneter using `tune()` function,
413    * tokens cannot be distributed among investors.
414    */
415   function suspend() onlyOwner isActive public {
416     state = State.Suspended;
417     ICOSuspended();
418   }
419 
420   /**
421    * @dev Terminate the ICO.
422    * ICO goals are not reached, ICO terminated and cannot be resumed.
423    */
424   function terminate() onlyOwner public {
425     require(state != State.Terminated &&
426             state != State.NotCompleted &&
427             state != State.Completed);
428     state = State.Terminated;
429     ICOTerminated();
430   }
431 
432   /**
433    * @dev Change basic ICO paraneters. Can be done only during `Suspended` state.
434    * Any provided parameter is used only if it is not zero.
435    * @param endAt_ ICO end date seconds since epoch. Used if it is not zero.
436    * @param hardCapWei_ ICO hard capacity. Used if it is not zero.
437    * @param lowCapTxWei_ Min limit for ICO per transaction
438    * @param hardCapTxWei_ Hard limit for ICO per transaction
439    */
440   function tune(uint endAt_,
441                 uint hardCapWei_,
442                 uint lowCapTxWei_,
443                 uint hardCapTxWei_) onlyOwner isSuspended public {
444     if (endAt_ > block.timestamp) {
445       endAt = endAt_;
446     }
447     if (hardCapWei_ > 0) {
448       hardCapWei = hardCapWei_;
449     }
450     if (lowCapTxWei_ > 0) {
451       lowCapTxWei = lowCapTxWei_;
452     }
453     if (hardCapTxWei_ > 0) {
454       hardCapTxWei = hardCapTxWei_;
455     }
456     require(lowCapTxWei <= hardCapTxWei);
457     touch();
458   }
459 
460   /**
461    * @dev Resume a previously suspended ICO.
462    */
463   function resume() onlyOwner isSuspended public {
464     state = State.Active;
465     ICOResumed(endAt, hardCapWei, lowCapTxWei, hardCapTxWei);
466     touch();
467   }
468 
469   /**
470    * @dev Send ether to the fund collection wallet
471    */
472   function forwardFunds() internal {
473     teamWallet.transfer(msg.value);
474   }
475 
476   /**
477    * @dev Recalculate ICO state based on current block time.
478    * Should be called periodically by ICO owner.
479    */
480   function touch() public;
481 
482   /**
483    * @dev Buy tokens
484    */
485   function buyTokens() public payable;
486 }
487 
488 // File: contracts/DATOICO.sol
489 
490 contract DATOICO is BaseICO {
491     using SafeMath for uint;
492 
493     /// @dev 18 decimals for token
494     uint internal constant ONE_TOKEN = 1e18;
495 
496     /// @dev 1e18 WEI == 1ETH == 500 tokens
497     uint public constant ETH_TOKEN_EXCHANGE_RATIO = 500;
498 
499     function DATOICO(address icoToken_,
500                      address teamWallet_,
501                      uint hardCapWei_,
502                      uint lowCapTxWei_,
503                      uint hardCapTxWei_) public {
504         require(icoToken_ != address(0) && teamWallet_ != address(0));
505         token = BaseICOToken(icoToken_);
506         state = State.Inactive;
507         teamWallet = teamWallet_;
508         hardCapWei = hardCapWei_;
509         lowCapTxWei = lowCapTxWei_;
510         hardCapTxWei = hardCapTxWei_;
511     }
512 
513     /**
514      * @dev Recalculate ICO state based on current block time.
515      * Should be called periodically by ICO owner.
516      */
517     function touch() public {
518         if (state != State.Active && state != State.Suspended) {
519             return;
520         }
521         if (collectedWei >= hardCapWei) {
522             state = State.Completed;
523             endAt = block.timestamp;
524             ICOCompleted(collectedWei);
525         } else if (block.timestamp >= endAt) {
526             state = State.NotCompleted;
527             ICONotCompleted();
528         }
529     }
530 
531     function buyTokens() public payable {
532         require(state == State.Active &&
533                 block.timestamp <= endAt &&
534                 msg.value >= lowCapTxWei &&
535                 msg.value <= hardCapTxWei &&
536                 collectedWei + msg.value <= hardCapWei &&
537                 whitelisted(msg.sender));
538         uint iwei = msg.value;
539         uint itokens = iwei * ETH_TOKEN_EXCHANGE_RATIO;
540         token.icoInvestment(msg.sender, itokens); // Transfer tokens to investor
541         collectedWei = collectedWei.add(iwei);
542         ICOInvestment(msg.sender, iwei, itokens, 0);
543         forwardFunds();
544         touch();
545     }
546 
547     /**
548      * Accept direct payments
549      */
550     function() external payable {
551         buyTokens();
552     }
553 }