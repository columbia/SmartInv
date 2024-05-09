1 pragma solidity 0.4.24;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11     /**
12     * @dev Multiplies two numbers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0); // Solidity only automatically asserts when dividing by 0
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two numbers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: contracts/flavours/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions". It has two-stage ownership transfer.
75  */
76 contract Ownable {
77 
78     address public owner;
79     address public pendingOwner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
85      * account.
86      */
87     constructor() public {
88         owner = msg.sender;
89     }
90 
91     /**
92      * @dev Throws if called by any account other than the owner.
93      */
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyPendingOwner() {
103         require(msg.sender == pendingOwner);
104         _;
105     }
106 
107     /**
108      * @dev Allows the current owner to prepare transfer control of the contract to a newOwner.
109      * @param newOwner The address to transfer ownership to.
110      */
111     function transferOwnership(address newOwner) public onlyOwner {
112         require(newOwner != address(0));
113         pendingOwner = newOwner;
114     }
115 
116     /**
117      * @dev Allows the pendingOwner address to finalize the transfer.
118      */
119     function claimOwnership() public onlyPendingOwner {
120         emit OwnershipTransferred(owner, pendingOwner);
121         owner = pendingOwner;
122         pendingOwner = address(0);
123     }
124 }
125 
126 // File: contracts/flavours/Whitelisted.sol
127 
128 contract Whitelisted is Ownable {
129 
130     /// @dev True if whitelist enabled
131     bool public whitelistEnabled = true;
132 
133     /// @dev ICO whitelist
134     mapping(address => bool) public whitelist;
135 
136     event ICOWhitelisted(address indexed addr);
137     event ICOBlacklisted(address indexed addr);
138 
139     modifier onlyWhitelisted {
140         require(!whitelistEnabled || whitelist[msg.sender]);
141         _;
142     }
143 
144     /**
145      * Add address to ICO whitelist
146      * @param address_ Investor address
147      */
148     function whitelist(address address_) external onlyOwner {
149         whitelist[address_] = true;
150         emit ICOWhitelisted(address_);
151     }
152 
153     /**
154      * Remove address from ICO whitelist
155      * @param address_ Investor address
156      */
157     function blacklist(address address_) external onlyOwner {
158         delete whitelist[address_];
159         emit ICOBlacklisted(address_);
160     }
161 
162     /**
163      * @dev Returns true if given address in ICO whitelist
164      */
165     function whitelisted(address address_) public view returns (bool) {
166         if (whitelistEnabled) {
167             return whitelist[address_];
168         } else {
169             return true;
170         }
171     }
172 
173     /**
174      * @dev Enable whitelisting
175      */
176     function enableWhitelist() public onlyOwner {
177         whitelistEnabled = true;
178     }
179 
180     /**
181      * @dev Disable whitelisting
182      */
183     function disableWhitelist() public onlyOwner {
184         whitelistEnabled = false;
185     }
186 }
187 
188 // File: contracts/flavours/Lockable.sol
189 
190 /**
191  * @title Lockable
192  * @dev Base contract which allows children to
193  *      implement main operations locking mechanism.
194  */
195 contract Lockable is Ownable {
196     event Lock();
197     event Unlock();
198 
199     bool public locked = false;
200 
201     /**
202      * @dev Modifier to make a function callable
203     *       only when the contract is not locked.
204      */
205     modifier whenNotLocked() {
206         require(!locked);
207         _;
208     }
209 
210     /**
211      * @dev Modifier to make a function callable
212      *      only when the contract is locked.
213      */
214     modifier whenLocked() {
215         require(locked);
216         _;
217     }
218 
219     /**
220      * @dev called by the owner to locke, triggers locked state
221      */
222     function lock() public onlyOwner whenNotLocked {
223         locked = true;
224         emit Lock();
225     }
226 
227     /**
228      * @dev called by the owner
229      *      to unlock, returns to unlocked state
230      */
231     function unlock() public onlyOwner whenLocked {
232         locked = false;
233         emit Unlock();
234     }
235 }
236 
237 // File: contracts/base/BaseFixedERC20Token.sol
238 
239 contract BaseFixedERC20Token is Lockable {
240     using SafeMath for uint;
241 
242     /// @dev ERC20 Total supply
243     uint public totalSupply;
244 
245     mapping(address => uint) public balances;
246 
247     mapping(address => mapping(address => uint)) private allowed;
248 
249     /// @dev Fired if token is transferred according to ERC20 spec
250     event Transfer(address indexed from, address indexed to, uint value);
251 
252     /// @dev Fired if token withdrawal is approved according to ERC20 spec
253     event Approval(address indexed owner, address indexed spender, uint value);
254 
255     /**
256      * @dev Gets the balance of the specified address
257      * @param owner_ The address to query the the balance of
258      * @return An uint representing the amount owned by the passed address
259      */
260     function balanceOf(address owner_) public view returns (uint balance) {
261         return balances[owner_];
262     }
263 
264     /**
265      * @dev Transfer token for a specified address
266      * @param to_ The address to transfer to.
267      * @param value_ The amount to be transferred.
268      */
269     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
270         require(to_ != address(0) && value_ <= balances[msg.sender]);
271         // SafeMath.sub will throw an exception if there is not enough balance
272         balances[msg.sender] = balances[msg.sender].sub(value_);
273         balances[to_] = balances[to_].add(value_);
274         emit Transfer(msg.sender, to_, value_);
275         return true;
276     }
277 
278     /**
279      * @dev Transfer tokens from one address to another
280      * @param from_ address The address which you want to send tokens from
281      * @param to_ address The address which you want to transfer to
282      * @param value_ uint the amount of tokens to be transferred
283      */
284     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
285         require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
286         balances[from_] = balances[from_].sub(value_);
287         balances[to_] = balances[to_].add(value_);
288         allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
289         emit Transfer(from_, to_, value_);
290         return true;
291     }
292 
293     /**
294      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
295      *
296      * Beware that changing an allowance with this method brings the risk that someone may use both the old
297      * and the new allowance by unfortunate transaction ordering
298      *
299      * To change the approve amount you first have to reduce the addresses
300      * allowance to zero by calling `approve(spender_, 0)` if it is not
301      * already 0 to mitigate the race condition described in:
302      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
303      *
304      * @param spender_ The address which will spend the funds.
305      * @param value_ The amount of tokens to be spent.
306      */
307     function approve(address spender_, uint value_) public whenNotLocked returns (bool) {
308         if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
309             revert();
310         }
311         allowed[msg.sender][spender_] = value_;
312         emit Approval(msg.sender, spender_, value_);
313         return true;
314     }
315 
316     /**
317      * @dev Function to check the amount of tokens that an owner allowed to a spender
318      * @param owner_ address The address which owns the funds
319      * @param spender_ address The address which will spend the funds
320      * @return A uint specifying the amount of tokens still available for the spender
321      */
322     function allowance(address owner_, address spender_) public view returns (uint) {
323         return allowed[owner_][spender_];
324     }
325 }
326 
327 // File: contracts/base/BaseICOToken.sol
328 
329 /**
330  * @dev Not mintable, ERC20 compliant token, distributed by ICO.
331  */
332 contract BaseICOToken is BaseFixedERC20Token {
333 
334     /// @dev Available supply of tokens
335     uint public availableSupply;
336 
337     /// @dev ICO smart contract allowed to distribute public funds for this
338     address public ico;
339 
340     /// @dev Fired if investment for `amount` of tokens performed by `to` address
341     event ICOTokensInvested(address indexed to, uint amount);
342 
343     /// @dev ICO contract changed for this token
344     event ICOChanged(address indexed icoContract);
345 
346     modifier onlyICO() {
347         require(msg.sender == ico);
348         _;
349     }
350 
351     /**
352      * @dev Not mintable, ERC20 compliant token, distributed by ICO.
353      * @param totalSupply_ Total tokens supply.
354      */
355     constructor(uint totalSupply_) public {
356         locked = true;
357         totalSupply = totalSupply_;
358         availableSupply = totalSupply_;
359     }
360 
361     /**
362      * @dev Set address of ICO smart-contract which controls token
363      * initial token distribution.
364      * @param ico_ ICO contract address.
365      */
366     function changeICO(address ico_) public onlyOwner {
367         ico = ico_;
368         emit ICOChanged(ico);
369     }
370 
371     /**
372      * @dev Assign `amountWei_` of wei converted into tokens to investor identified by `to_` address.
373      * @param to_ Investor address.
374      * @param amountWei_ Number of wei invested
375      * @param ethTokenExchangeRatio_ Number of tokens in 1Eth
376      * @return Amount of invested tokens
377      */
378     function icoInvestmentWei(address to_, uint amountWei_, uint ethTokenExchangeRatio_) public returns (uint);
379 
380     function isValidICOInvestment(address to_, uint amount_) internal view returns (bool) {
381         return to_ != address(0) && amount_ <= availableSupply;
382     }
383 }
384 
385 // File: contracts/base/BaseICO.sol
386 
387 /**
388  * @dev Base abstract smart contract for any ICO
389  */
390 contract BaseICO is Ownable, Whitelisted {
391 
392     /// @dev ICO state
393     enum State {
394 
395         // ICO is not active and not started
396         Inactive,
397 
398         // ICO is active, tokens can be distributed among investors.
399         // ICO parameters (end date, hard/low caps) cannot be changed.
400         Active,
401 
402         // ICO is suspended, tokens cannot be distributed among investors.
403         // ICO can be resumed to `Active state`.
404         // ICO parameters (end date, hard/low caps) may changed.
405         Suspended,
406 
407         // ICO is terminated by owner, ICO cannot be resumed.
408         Terminated,
409 
410         // ICO goals are not reached,
411         // ICO terminated and cannot be resumed.
412         NotCompleted,
413 
414         // ICO completed, ICO goals reached successfully,
415         // ICO terminated and cannot be resumed.
416         Completed
417     }
418 
419     /// @dev Token which controlled by this ICO
420     BaseICOToken public token;
421 
422     /// @dev Current ICO state.
423     State public state;
424 
425     /// @dev ICO start date seconds since epoch.
426     uint public startAt;
427 
428     /// @dev ICO end date seconds since epoch.
429     uint public endAt;
430 
431     /// @dev Minimal amount of investments in wei needed for successful ICO
432     uint public lowCapWei;
433 
434     /// @dev Maximal amount of investments in wei for this ICO.
435     /// If reached ICO will be in `Completed` state.
436     uint public hardCapWei;
437 
438     /// @dev Minimal amount of investments in wei per investor.
439     uint public lowCapTxWei;
440 
441     /// @dev Maximal amount of investments in wei per investor.
442     uint public hardCapTxWei;
443 
444     /// @dev Number of investments collected by this ICO
445     uint public collectedWei;
446 
447     /// @dev Number of sold tokens by this ICO
448     uint public tokensSold;
449 
450     /// @dev Team wallet used to collect funds
451     address public teamWallet;
452 
453     // ICO state transition events
454     event ICOStarted(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
455     event ICOResumed(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
456     event ICOSuspended();
457     event ICOTerminated();
458     event ICONotCompleted();
459     event ICOCompleted(uint collectedWei);
460     event ICOInvestment(address indexed from, uint investedWei, uint tokens, uint8 bonusPct);
461 
462     modifier isSuspended() {
463         require(state == State.Suspended);
464         _;
465     }
466 
467     modifier isActive() {
468         require(state == State.Active);
469         _;
470     }
471 
472     constructor(address icoToken_,
473         address teamWallet_,
474         uint lowCapWei_,
475         uint hardCapWei_,
476         uint lowCapTxWei_,
477         uint hardCapTxWei_) public {
478         require(icoToken_ != address(0) && teamWallet_ != address(0));
479         token = BaseICOToken(icoToken_);
480         teamWallet = teamWallet_;
481         lowCapWei = lowCapWei_;
482         hardCapWei = hardCapWei_;
483         lowCapTxWei = lowCapTxWei_;
484         hardCapTxWei = hardCapTxWei_;
485     }
486 
487     /**
488      * @dev Trigger start of ICO.
489      * @param endAt_ ICO end date, seconds since epoch.
490      */
491     function start(uint endAt_) public onlyOwner {
492         require(endAt_ > block.timestamp && state == State.Inactive);
493         endAt = endAt_;
494         startAt = block.timestamp;
495         state = State.Active;
496         emit ICOStarted(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
497     }
498 
499     /**
500      * @dev Suspend this ICO.
501      * ICO can be activated later by calling `resume()` function.
502      * In suspend state, ICO owner can change basic ICO parameter using `tune()` function,
503      * tokens cannot be distributed among investors.
504      */
505     function suspend() public onlyOwner isActive {
506         state = State.Suspended;
507         emit ICOSuspended();
508     }
509 
510     /**
511      * @dev Terminate the ICO.
512      * ICO goals are not reached, ICO terminated and cannot be resumed.
513      */
514     function terminate() public onlyOwner {
515         require(state != State.Terminated &&
516         state != State.NotCompleted &&
517         state != State.Completed);
518         state = State.Terminated;
519         emit ICOTerminated();
520     }
521 
522     /**
523      * @dev Change basic ICO parameters. Can be done only during `Suspended` state.
524      * Any provided parameter is used only if it is not zero.
525      * @param endAt_ ICO end date seconds since epoch. Used if it is not zero.
526      * @param lowCapWei_ ICO low capacity. Used if it is not zero.
527      * @param hardCapWei_ ICO hard capacity. Used if it is not zero.
528      * @param lowCapTxWei_ Min limit for ICO per transaction
529      * @param hardCapTxWei_ Hard limit for ICO per transaction
530      */
531     function tune(uint endAt_,
532         uint lowCapWei_,
533         uint hardCapWei_,
534         uint lowCapTxWei_,
535         uint hardCapTxWei_) public onlyOwner isSuspended {
536         if (endAt_ > block.timestamp) {
537             endAt = endAt_;
538         }
539         if (lowCapWei_ > 0) {
540             lowCapWei = lowCapWei_;
541         }
542         if (hardCapWei_ > 0) {
543             hardCapWei = hardCapWei_;
544         }
545         if (lowCapTxWei_ > 0) {
546             lowCapTxWei = lowCapTxWei_;
547         }
548         if (hardCapTxWei_ > 0) {
549             hardCapTxWei = hardCapTxWei_;
550         }
551         require(lowCapWei <= hardCapWei && lowCapTxWei <= hardCapTxWei);
552         touch();
553     }
554 
555     /**
556      * @dev Resume a previously suspended ICO.
557      */
558     function resume() public onlyOwner isSuspended {
559         state = State.Active;
560         emit ICOResumed(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
561         touch();
562     }
563 
564     /**
565      * @dev Recalculate ICO state based on current block time.
566      * Should be called periodically by ICO owner.
567      */
568     function touch() public;
569 
570     /**
571      * @dev Buy tokens
572      */
573     function buyTokens() public payable;
574 
575     /**
576      * @dev Send ether to the fund collection wallet
577      */
578     function forwardFunds() internal {
579         teamWallet.transfer(msg.value);
580     }
581 }
582 
583 // File: contracts/flavours/SelfDestructible.sol
584 
585 /**
586  * @title SelfDestructible
587  * @dev The SelfDestructible contract has an owner address, and provides selfDestruct method
588  * in case of deployment error.
589  */
590 contract SelfDestructible is Ownable {
591 
592     function selfDestruct(uint8 v, bytes32 r, bytes32 s) public onlyOwner {
593         if (ecrecover(prefixedHash(), v, r, s) != owner) {
594             revert();
595         }
596         selfdestruct(owner);
597     }
598 
599     function originalHash() internal view returns (bytes32) {
600         return keccak256(abi.encodePacked(
601                 "Signed for Selfdestruct",
602                 address(this),
603                 msg.sender
604             ));
605     }
606 
607     function prefixedHash() internal view returns (bytes32) {
608         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
609         return keccak256(abi.encodePacked(prefix, originalHash()));
610     }
611 }
612 
613 // File: contracts/interface/ERC20Token.sol
614 
615 interface ERC20Token {
616     function transferFrom(address from_, address to_, uint value_) external returns (bool);
617     function transfer(address to_, uint value_) external returns (bool);
618     function balanceOf(address owner_) external returns (uint);
619 }
620 
621 // File: contracts/flavours/Withdrawal.sol
622 
623 /**
624  * @title Withdrawal
625  * @dev The Withdrawal contract has an owner address, and provides method for withdraw funds and tokens, if any
626  */
627 contract Withdrawal is Ownable {
628 
629     // withdraw funds, if any, only for owner
630     function withdraw() public onlyOwner {
631         owner.transfer(address(this).balance);
632     }
633 
634     // withdraw stuck tokens, if any, only for owner
635     function withdrawTokens(address _someToken) public onlyOwner {
636         ERC20Token someToken = ERC20Token(_someToken);
637         uint balance = someToken.balanceOf(address(this));
638         someToken.transfer(owner, balance);
639     }
640 }
641 
642 // File: contracts/ICHXICO.sol
643 
644 /**
645  * @title ICHX tokens ICO contract.
646  */
647 contract ICHXICO is BaseICO, SelfDestructible, Withdrawal {
648     using SafeMath for uint;
649 
650     /// @dev Total number of invested wei
651     uint public collectedWei;
652 
653     // @dev investments distribution
654     mapping (address => uint) public investments;
655 
656     /// @dev 1e18 WEI == 1ETH == 16700 tokens
657     uint public constant ETH_TOKEN_EXCHANGE_RATIO = 16700;
658 
659     constructor(address icoToken_,
660                 address teamWallet_,
661                 uint lowCapWei_,
662                 uint hardCapWei_,
663                 uint lowCapTxWei_,
664                 uint hardCapTxWei_) public
665         BaseICO(icoToken_, teamWallet_, lowCapWei_, hardCapWei_, lowCapTxWei_, hardCapTxWei_) {
666     }
667 
668     /**
669      * Accept direct payments
670      */
671     function() external payable {
672         buyTokens();
673     }
674 
675     /**
676      * @dev Recalculate ICO state based on current block time.
677      * Should be called periodically by ICO owner.
678      */
679     function touch() public {
680         if (state != State.Active && state != State.Suspended) {
681             return;
682         }
683         if (collectedWei >= hardCapWei) {
684             state = State.Completed;
685             endAt = block.timestamp;
686             emit ICOCompleted(collectedWei);
687         } else if (block.timestamp >= endAt) {
688             if (collectedWei < lowCapWei) {
689                 state = State.NotCompleted;
690                 emit ICONotCompleted();
691             } else {
692                 state = State.Completed;
693                 emit ICOCompleted(collectedWei);
694             }
695         }
696     }
697 
698     function buyTokens() public payable {
699         require(state == State.Active &&
700                 block.timestamp < endAt &&
701                 msg.value >= lowCapTxWei &&
702                 msg.value <= hardCapTxWei &&
703                 collectedWei + msg.value <= hardCapWei &&
704                 whitelisted(msg.sender));
705         uint amountWei = msg.value;
706 
707         uint iTokens = token.icoInvestmentWei(msg.sender, amountWei, ETH_TOKEN_EXCHANGE_RATIO);
708         collectedWei = collectedWei.add(amountWei);
709         tokensSold = tokensSold.add(iTokens);
710         investments[msg.sender] = investments[msg.sender].add(amountWei);
711 
712         emit ICOInvestment(msg.sender, amountWei, iTokens, 0);
713         forwardFunds();
714         touch();
715     }
716 
717     function getInvestments(address investor) public view returns (uint) {
718         return investments[investor];
719     }
720 }