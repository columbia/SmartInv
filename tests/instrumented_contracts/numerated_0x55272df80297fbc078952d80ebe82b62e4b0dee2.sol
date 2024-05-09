1 pragma solidity ^0.4.13;
2 
3 contract StandardContract {
4     // allows usage of "require" as a modifier
5     modifier requires(bool b) {
6         require(b);
7         _;
8     }
9 
10     // require at least one of the two conditions to be true
11     modifier requiresOne(bool b1, bool b2) {
12         require(b1 || b2);
13         _;
14     }
15 
16     modifier notNull(address a) {
17         require(a != 0);
18         _;
19     }
20 
21     modifier notZero(uint256 a) {
22         require(a != 0);
23         _;
24     }
25 }
26 
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function div(uint256 a, uint256 b) internal constant returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 contract ReentrancyGuard {
54 
55   /**
56    * @dev We use a single lock for the whole contract.
57    */
58   bool private rentrancy_lock = false;
59 
60   /**
61    * @dev Prevents a contract from calling itself, directly or indirectly.
62    * @notice If you mark a function `nonReentrant`, you should also
63    * mark it `external`. Calling one nonReentrant function from
64    * another is not supported. Instead, you can implement a
65    * `private` function doing the actual work, and a `external`
66    * wrapper marked as `nonReentrant`.
67    */
68   modifier nonReentrant() {
69     require(!rentrancy_lock);
70     rentrancy_lock = true;
71     _;
72     rentrancy_lock = false;
73   }
74 
75 }
76 
77 contract ERC20Basic {
78   uint256 public totalSupply;
79   function balanceOf(address who) public constant returns (uint256);
80   function transfer(address to, uint256 value) public returns (bool);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82 }
83 
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 contract Ownable {
92   address public owner;
93 
94 
95   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
96 
97 
98   /**
99    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
100    * account.
101    */
102   function Ownable() {
103     owner = msg.sender;
104   }
105 
106 
107   /**
108    * @dev Throws if called by any account other than the owner.
109    */
110   modifier onlyOwner() {
111     require(msg.sender == owner);
112     _;
113   }
114 
115 
116   /**
117    * @dev Allows the current owner to transfer control of the contract to a newOwner.
118    * @param newOwner The address to transfer ownership to.
119    */
120   function transferOwnership(address newOwner) onlyOwner public {
121     require(newOwner != address(0));
122     OwnershipTransferred(owner, newOwner);
123     owner = newOwner;
124   }
125 
126 }
127 
128 contract Claimable is Ownable {
129   address public pendingOwner;
130 
131   /**
132    * @dev Modifier throws if called by any account other than the pendingOwner.
133    */
134   modifier onlyPendingOwner() {
135     require(msg.sender == pendingOwner);
136     _;
137   }
138 
139   /**
140    * @dev Allows the current owner to set the pendingOwner address.
141    * @param newOwner The address to transfer ownership to.
142    */
143   function transferOwnership(address newOwner) onlyOwner public {
144     pendingOwner = newOwner;
145   }
146 
147   /**
148    * @dev Allows the pendingOwner address to finalize the transfer.
149    */
150   function claimOwnership() onlyPendingOwner public {
151     OwnershipTransferred(owner, pendingOwner);
152     owner = pendingOwner;
153     pendingOwner = 0x0;
154   }
155 }
156 
157 contract HasNoEther is Ownable {
158 
159   /**
160   * @dev Constructor that rejects incoming Ether
161   * @dev The `payable` flag is added so we can access `msg.value` without compiler warning. If we
162   * leave out payable, then Solidity will allow inheriting contracts to implement a payable
163   * constructor. By doing it this way we prevent a payable constructor from working. Alternatively
164   * we could use assembly to access msg.value.
165   */
166   function HasNoEther() payable {
167     require(msg.value == 0);
168   }
169 
170   /**
171    * @dev Disallows direct send by settings a default function without the `payable` flag.
172    */
173   function() external {
174   }
175 
176   /**
177    * @dev Transfer all Ether held by the contract to the owner.
178    */
179   function reclaimEther() external onlyOwner {
180     assert(owner.send(this.balance));
181   }
182 }
183 
184 /*
185  * A SingleTokenLocker allows a user to create a locker that can lock a single type of ERC20 token.
186  * The token locker should:
187  *    - Allow the owner to prove a certain number of their own tokens are locked for until a particular time
188  *    - Allow the owner to transfer tokens to a recipient and prove the tokens are locked until a particular time
189  *    - Allow the owner to cancel a transfer before a recipient confirms (in case of transfer to an incorrect address)
190  *    - Allow the recipient to be certain that they will have access to transferred tokens once the lock expires
191  *    - Be re-usable by the owner, so an owner can easily schedule/monitor multiple transfers/locks
192  *
193  * This class should be reusable for any ERC20 token.  Ideally, this sort of fine grained locking would be available in
194  * the token contract itself.  Short of that, the token locker receives tokens (presumably from the locker owner) and
195  * can be configured to release them only under certain conditions.
196  *
197  * Usage:
198  *  - The owner creates a token locker for a particular ERC20 token type
199  *  - The owner approves the locker up to some number of tokens: token.approve(tokenLockerAddress, tokenAmount)
200  *    - Alternately, the owner can send tokens to the locker.  When locking tokens, the locker checks its balance first
201  *  - The owner calls "lockup" with a particular recipient, amount, and unlock time.  The recipient will be allowed
202  *    to collect the tokens once the lockup period is ended.
203  *  - The recipient calls "confirm" which confirms that the recipient's address is correct and is controlled by the
204  *    intended recipient (e.g. not an exchange address).  The assumption is that if the recipient can call "confirm"
205  *    they have demonstrated that they will also be able to call "collect" when the tokens are ready.
206  *  - Once the lock expires, the recipient calls "collect" and the tokens are transferred from the locker to the
207  *    recipient.
208  *
209  * An owner can lockup his/her own tokens in order to demonstrate the they will not be moved until a particular time.
210  * In this case, no separate "confirm" step is needed (confirm happens automatically)
211  *
212  * The following diagram shows the actual balance of the token locker and how it is tracked internally
213  *
214  *         +-------------------------------------------------------------+
215  *         |                      Actual Locker Balance                  |
216  *         |-------------------------------------------------------------|
217  *         |                     |                Promised               |
218  *  State  |     Uncommitted     +---------------------------------------|
219  *         |                     |        Pending            |  Locked   |
220  *         |---------------------+---------------------------------------|
221  *  Actions| withdraw            |  confirm, cancel, collect | collect   |
222  *         |---------------------+---------------------------+-----------|
223  *  Field  | balance - promised  | promised - locked         | locked    |
224  *         +---------------------+---------------------------+-----------+
225  */
226 contract SingleTokenLocker is Claimable, ReentrancyGuard, StandardContract, HasNoEther {
227 
228   using SafeMath for uint256;
229 
230   // the type of token this locker is used for
231   ERC20 public token;
232 
233   // A counter to generate unique Ids for promises
234   uint256 public nextPromiseId;
235 
236   // promise storage
237   mapping(uint256 => TokenPromise) public promises;
238 
239   // The total amount of tokens locked or pending lock (in the non-fractional units, like wei)
240   uint256 public promisedTokenBalance;
241 
242   // The total amount of tokens actually locked (recipients have confirmed)
243   uint256 public lockedTokenBalance;
244 
245   // promise states
246   //  none: The default state.  Never explicitly assigned.
247   //  pending: The owner has initiated a promise, but it has not been claimed
248   //  confirmed: The recipient has confirmed the promise
249   //  executed: The promise has completed (after the required lockup)
250   //  canceled: The promise was canceled (only from pending state)
251   //  failed: The promise could not be fulfilled due to an error
252   enum PromiseState { none, pending, confirmed, executed, canceled, failed }
253 
254   // a matrix designating the legal state transitions for a promise (see constructor)
255   mapping (uint => mapping(uint => bool)) stateTransitionMatrix;
256 
257   // true if the contract has been initialized
258   bool initialized;
259 
260   struct TokenPromise {
261     uint256 promiseId;
262     address recipient;
263     uint256 amount;
264     uint256 lockedUntil;
265     PromiseState state;
266   }
267 
268   event logPromiseCreated(uint256 promiseId, address recipient, uint256 amount, uint256 lockedUntil);
269   event logPromiseConfirmed(uint256 promiseId);
270   event logPromiseCanceled(uint256 promiseId);
271   event logPromiseFulfilled(uint256 promiseId);
272   event logPromiseUnfulfillable(uint256 promiseId, address recipient, uint256 amount);
273 
274   /**
275    * Guards actions that only the intended recipient should be able to perform
276    */
277   modifier onlyRecipient(uint256 promiseId) {
278     require(msg.sender == promises[promiseId].recipient);
279     _;
280   }
281 
282   /**
283    * Ensures the promiseId as actually in use.
284    */
285   modifier promiseExists(uint promiseId) {
286     require(promiseId < nextPromiseId);
287     _;
288   }
289 
290   /**
291    * Ensure state consistency after modifying lockedTokenBalance or promisedTokenBalance
292    */
293   modifier thenAssertState() {
294     _;
295     uint256 balance = tokenBalance();
296     assert(lockedTokenBalance <= promisedTokenBalance);
297     assert(promisedTokenBalance <= balance);
298   }
299 
300   // Constructor
301   function SingleTokenLocker(address tokenAddress) {
302     token = ERC20(tokenAddress);
303 
304     allowTransition(PromiseState.pending, PromiseState.canceled);
305     allowTransition(PromiseState.pending, PromiseState.executed);
306     allowTransition(PromiseState.pending, PromiseState.confirmed);
307     allowTransition(PromiseState.confirmed, PromiseState.executed);
308     allowTransition(PromiseState.executed, PromiseState.failed);
309     initialized = true;
310   }
311 
312   /**
313    * Initiates the request to lockup the given number of tokens until the given block.timestamp occurs.
314    * This contract will attempt to acquire tokens from the Token contract from the owner if its balance
315    * is not sufficient.  Therefore, the locker owner may call token.approve(locker.address, amount) one time
316    * and then initiate many smaller transfers to individuals.
317    *
318    * Note 1: lockup is not guaranteed until the recipient confirms.
319    * Note 2: Assumes the owner has already given approval for the TokenLocker to take out the tokens
320    *         or that the locker's balance is sufficient
321    */
322   function lockup(address recipient, uint256 amount, uint256 lockedUntil)
323     onlyOwner
324     notNull(recipient)
325     notZero(amount)
326     nonReentrant
327     external
328   {
329     // if the locker does not have sufficient unlocked tokens, assume it has enough
330     // approved by the owner to make up the difference
331     ensureTokensAvailable(amount);
332 
333     // setup a promise that allow transfer to the recipient after the lock expires
334     TokenPromise storage promise = createPromise(recipient, amount, lockedUntil);
335 
336     // auto-confirm if the recipient is the owner
337     if (recipient == owner) {
338       doConfirm(promise);
339     }
340   }
341 
342   /***
343    * @dev Cancels the pending transaction as long as the caller has permissions and the transaction has not already
344    * been confirmed.  Allowing *any* transaction to be canceled would mean no lockup could ever be guaranteed.
345    */
346   function cancel(uint256 promiseId)
347     promiseExists(promiseId)
348     requires(promises[promiseId].state == PromiseState.pending)
349     requiresOne(
350       msg.sender == owner,
351       msg.sender == promises[promiseId].recipient
352     )
353     nonReentrant
354     external
355   {
356     TokenPromise storage promise = promises[promiseId];
357     unlockTokens(promise, PromiseState.canceled);
358     logPromiseCanceled(promise.promiseId);
359   }
360 
361   // @dev Allows the recipient to confirm their address.  If this fails (or they cannot send from the specified address)
362   // the owner of the TokenLocker can cancel the promise and initiate a new one
363   function confirm(uint256 promiseId)
364     promiseExists(promiseId)
365     onlyRecipient(promiseId)
366     requires(promises[promiseId].state == PromiseState.pending)
367     nonReentrant
368     external
369   {
370     doConfirm(promises[promiseId]);
371   }
372 
373   /***
374    * Called by the recipient after the lock has expired.
375    */
376   function collect(uint256 promiseId)
377     promiseExists(promiseId)
378     onlyRecipient(promiseId)
379     requires(block.timestamp >= promises[promiseId].lockedUntil)
380     requiresOne(
381       promises[promiseId].state == PromiseState.pending,
382       promises[promiseId].state == PromiseState.confirmed
383     )
384     nonReentrant
385     external
386   {
387     TokenPromise storage promise = promises[promiseId];
388 
389     unlockTokens(promise, PromiseState.executed);
390     if (token.transfer(promise.recipient, promise.amount)) {
391       logPromiseFulfilled(promise.promiseId);
392     }
393     else {
394       // everything looked good, but the transfer failed.  :(  Now what?
395       // There is no reason to think it will work the next time, so
396       // reverting probably won't help here; the tokens would remain locked
397       // forever.  Our only hope is that the token owner will resolve the
398       // issue in the real world.  Since the amount has been deducted from the
399       // locked and pending totals, it has effectively been returned to the owner.
400       transition(promise, PromiseState.failed);
401       logPromiseUnfulfillable(promiseId, promise.recipient, promise.amount);
402     }
403   }
404 
405   /***
406    * Withdraws the given number of tokens from the locker as long as they are not already locked or promised
407    */
408   function withdrawUncommittedTokens(uint amount)
409     onlyOwner
410     requires(amount <= uncommittedTokenBalance())
411     nonReentrant
412     external
413   {
414     token.transfer(owner, amount);
415   }
416 
417   /***
418    * Withdraw all tokens from the wallet that are not locked or promised
419    */
420   function withdrawAllUncommittedTokens()
421     onlyOwner
422     nonReentrant
423     external
424   {
425     // not using withdrawUncommittedTokens(uncommittedTokenBalance())
426     // to have stronger guarantee on nonReentrant+external
427     token.transfer(owner, uncommittedTokenBalance());
428   }
429 
430   // tokens can be transferred out by the owner if either
431   //  1: The tokens are not the type that are governed by this contract (accidentally sent here, most likely)
432   //  2: The tokens are not already promised to a recipient (either pending or confirmed)
433   //
434   // If neither of these conditions are true, then allowing the owner to transfer the tokens
435   // out would violate the purpose of the token locker, which is to prove that the tokens
436   // cannot be moved.
437   function salvageTokensFromContract(address tokenAddress, address to, uint amount)
438     onlyOwner
439     requiresOne(
440       tokenAddress != address(token),
441       amount <= uncommittedTokenBalance()
442     )
443     nonReentrant
444     external
445   {
446     ERC20(tokenAddress).transfer(to, amount);
447   }
448 
449   /***
450    * Returns true if the given promise has been confirmed by the recipient
451    */
452   function isConfirmed(uint256 promiseId)
453     constant
454     returns(bool)
455   {
456     return promises[promiseId].state == PromiseState.confirmed;
457   }
458 
459   /***
460    * Returns true if the give promise can been collected by the recipient
461    */
462   function canCollect(uint256 promiseId)
463     constant
464     returns(bool)
465   {
466     return (promises[promiseId].state == PromiseState.confirmed || promises[promiseId].state == PromiseState.pending)
467       && block.timestamp >= promises[promiseId].lockedUntil;
468   }
469 
470   // @dev returns the total amount of tokens that are eligible to be collected
471   function collectableTokenBalance()
472     constant
473     returns(uint256 collectable)
474   {
475     collectable = 0;
476     for (uint i=0; i<nextPromiseId; i++) {
477       if (canCollect(i)) {
478         collectable = collectable.add(promises[i].amount);
479       }
480     }
481     return collectable;
482   }
483 
484   /***
485    * Return the number of transactions that meet the given criteria.  To be used in conjunction with
486    * getPromiseIds()
487    *
488    * recipient: the recipients address to use for filtering, or 0x0 to return all
489    * includeCompleted: true if the list should include transactions that are already executed or canceled
490    */
491   function getPromiseCount(address recipient, bool includeCompleted)
492     public
493     constant
494     returns (uint count)
495   {
496     for (uint i=0; i<nextPromiseId; i++) {
497       if (recipient != 0x0 && recipient != promises[i].recipient)
498         continue;
499 
500         if (includeCompleted
501             || promises[i].state == PromiseState.pending
502             || promises[i].state == PromiseState.confirmed)
503       count += 1;
504     }
505   }
506 
507   /***
508    * Return a list of promiseIds that match the given criteria
509    *
510    * recipient: the recipients address to use for filtering, or 0x0 to return all
511    * includeCompleted: true if the list should include transactions that are already executed or canceled
512    */
513   function getPromiseIds(uint from, uint to, address recipient, bool includeCompleted)
514     public
515     constant
516     returns (uint[] promiseIds)
517   {
518     uint[] memory promiseIdsTemp = new uint[](nextPromiseId);
519     uint count = 0;
520     uint i;
521     for (i=0; i<nextPromiseId && count < to; i++) {
522       if (recipient != 0x0 && recipient != promises[i].recipient)
523         continue;
524 
525       if (includeCompleted
526         || promises[i].state == PromiseState.pending
527         || promises[i].state == PromiseState.confirmed)
528       {
529         promiseIdsTemp[count] = i;
530         count += 1;
531       }
532     }
533     promiseIds = new uint[](to - from);
534     for (i=from; i<to; i++)
535       promiseIds[i - from] = promiseIdsTemp[i];
536   }
537 
538   /***
539    * returns the number of tokens held by the token locker (some might be promised or locked)
540    */
541   function tokenBalance()
542     constant
543     returns(uint256)
544   {
545     return token.balanceOf(address(this));
546   }
547 
548   /***
549    * returns the number of tokens that are not promised or locked
550    */
551   function uncommittedTokenBalance()
552     constant
553     returns(uint256)
554   {
555     return tokenBalance() - promisedTokenBalance;
556   }
557 
558   /***
559    * returns the number of tokens that a promised by have not been locked (pending confirmation from recipient)
560    */
561   function pendingTokenBalance()
562     constant
563     returns(uint256)
564   {
565     return promisedTokenBalance - lockedTokenBalance;
566   }
567 
568   // ------------------ internal methods ------------------ //
569 
570   // @dev moves the promise to the new state and updates the locked/pending totals accordingly
571   function unlockTokens(TokenPromise storage promise, PromiseState newState)
572     internal
573   {
574     promisedTokenBalance = promisedTokenBalance.sub(promise.amount);
575     if (promise.state == PromiseState.confirmed) {
576       lockedTokenBalance = lockedTokenBalance.sub(promise.amount);
577     }
578     transition(promise, newState);
579   }
580 
581   // @dev add a new state transition to the state transition matrix
582   function allowTransition(PromiseState from, PromiseState to)
583     requires(!initialized)
584     internal
585   {
586     stateTransitionMatrix[uint(from)][uint(to)] = true;
587   }
588 
589   // @dev moves the promise to the new state as long as it's permitted by the state transition matrix
590   function transition(TokenPromise storage promise, PromiseState newState)
591     internal
592   {
593     assert(stateTransitionMatrix[uint(promise.state)][uint(newState)]);
594     promise.state = newState;
595   }
596 
597   // @dev moves the promise to the confirmed state and updates the locked token total
598   function doConfirm(TokenPromise storage promise)
599     thenAssertState
600     internal
601   {
602     transition(promise, PromiseState.confirmed);
603     lockedTokenBalance = lockedTokenBalance.add(promise.amount);
604     logPromiseConfirmed(promise.promiseId);
605   }
606 
607   /***
608    * @dev creates and stores a new promise object, updates the promisedTokenBalance
609    */
610   function createPromise(address recipient, uint256 amount, uint256 lockedUntil)
611     requires(amount <= uncommittedTokenBalance())
612     thenAssertState
613     internal
614     returns(TokenPromise storage promise)
615   {
616     uint256 promiseId = nextPromiseId++;
617     promise = promises[promiseId];
618     promise.promiseId = promiseId;
619     promise.recipient = recipient;
620     promise.amount = amount;
621     promise.lockedUntil = lockedUntil;
622     promise.state = PromiseState.pending;
623 
624     promisedTokenBalance = promisedTokenBalance.add(promise.amount);
625 
626     logPromiseCreated(promiseId, recipient, amount, lockedUntil);
627 
628     return promise;
629   }
630 
631   /**
632    * @dev Checks the uncommitted balance to ensure there the locker has enough tokens to guarantee the
633    * amount given can be promised.  If the locker's balance is not enough, the locker will attempt to transfer
634    * tokens from the owner.
635    */
636   function ensureTokensAvailable(uint256 amount)
637     onlyOwner
638     internal
639   {
640     uint256 uncommittedBalance = uncommittedTokenBalance();
641     if (uncommittedBalance < amount) {
642       token.transferFrom(owner, this, amount.sub(uncommittedBalance));
643 
644       // Just assert that the condition we really care about holds, rather
645       // than relying on the return value.  see GavCoin and all the tokens copy/pasted therefrom.
646       assert(uncommittedTokenBalance() >= amount);
647     }
648   }
649 }