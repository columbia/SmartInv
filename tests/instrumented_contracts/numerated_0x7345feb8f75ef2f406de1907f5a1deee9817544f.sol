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
11 
12     address public owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     /**
17      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18      * account.
19      */
20     function Ownable() public {
21         owner = msg.sender;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32     /**
33      * @dev Allows the current owner to transfer control of the contract to a newOwner.
34      * @param newOwner The address to transfer ownership to.
35      */
36     function transferOwnership(address newOwner) public onlyOwner {
37         require(newOwner != address(0));
38         OwnershipTransferred(owner, newOwner);
39         owner = newOwner;
40     }
41 }
42 
43 // File: contracts/commons/SafeMath.sol
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         assert(c / a == b);
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a / b;
61         return c;
62     }
63 
64     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
65         assert(b <= a);
66         return a - b;
67     }
68 
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         assert(c >= a);
72         return c;
73     }
74 }
75 
76 // File: contracts/flavours/Lockable.sol
77 
78 /**
79  * @title Lockable
80  * @dev Base contract which allows children to
81  *      implement main operations locking mechanism.
82  */
83 contract Lockable is Ownable {
84     event Lock();
85     event Unlock();
86 
87     bool public locked = false;
88 
89     /**
90      * @dev Modifier to make a function callable
91     *       only when the contract is not locked.
92      */
93     modifier whenNotLocked() {
94         require(!locked);
95         _;
96     }
97 
98     /**
99      * @dev Modifier to make a function callable
100      *      only when the contract is locked.
101      */
102     modifier whenLocked() {
103         require(locked);
104         _;
105     }
106 
107     /**
108      * @dev called by the owner to locke, triggers locked state
109      */
110     function lock() public onlyOwner whenNotLocked {
111         locked = true;
112         Lock();
113     }
114 
115     /**
116      * @dev called by the owner
117      *      to unlock, returns to unlocked state
118      */
119     function unlock() public onlyOwner whenLocked {
120         locked = false;
121         Unlock();
122     }
123 }
124 
125 // File: contracts/base/BaseFixedERC20Token.sol
126 
127 contract BaseFixedERC20Token is Lockable {
128     using SafeMath for uint;
129 
130     /// @dev ERC20 Total supply
131     uint public totalSupply;
132 
133     mapping(address => uint) balances;
134 
135     mapping(address => mapping(address => uint)) private allowed;
136 
137     /// @dev Fired if Token transfered accourding to ERC20
138     event Transfer(address indexed from, address indexed to, uint value);
139 
140     /// @dev Fired if Token withdraw is approved accourding to ERC20
141     event Approval(address indexed owner, address indexed spender, uint value);
142 
143     /**
144      * @dev Gets the balance of the specified address.
145      * @param owner_ The address to query the the balance of.
146      * @return An uint representing the amount owned by the passed address.
147      */
148     function balanceOf(address owner_) public view returns (uint balance) {
149         return balances[owner_];
150     }
151 
152     /**
153      * @dev Transfer token for a specified address
154      * @param to_ The address to transfer to.
155      * @param value_ The amount to be transferred.
156      */
157     function transfer(address to_, uint value_) public whenNotLocked returns (bool) {
158         require(to_ != address(0) && value_ <= balances[msg.sender]);
159         // SafeMath.sub will throw if there is not enough balance.
160         balances[msg.sender] = balances[msg.sender].sub(value_);
161         balances[to_] = balances[to_].add(value_);
162         Transfer(msg.sender, to_, value_);
163         return true;
164     }
165 
166     /**
167      * @dev Transfer tokens from one address to another
168      * @param from_ address The address which you want to send tokens from
169      * @param to_ address The address which you want to transfer to
170      * @param value_ uint the amount of tokens to be transferred
171      */
172     function transferFrom(address from_, address to_, uint value_) public whenNotLocked returns (bool) {
173         require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
174         balances[from_] = balances[from_].sub(value_);
175         balances[to_] = balances[to_].add(value_);
176         allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
177         Transfer(from_, to_, value_);
178         return true;
179     }
180 
181     /**
182      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
183      *
184      * Beware that changing an allowance with this method brings the risk that someone may use both the old
185      * and the new allowance by unfortunate transaction ordering.
186      *
187      * To change the approve amount you first have to reduce the addresses
188      * allowance to zero by calling `approve(spender_, 0)` if it is not
189      * already 0 to mitigate the race condition described in:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * @param spender_ The address which will spend the funds.
193      * @param value_ The amount of tokens to be spent.
194      */
195     function approve(address spender_, uint value_) public whenNotLocked returns (bool) {
196         if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
197             revert();
198         }
199         allowed[msg.sender][spender_] = value_;
200         Approval(msg.sender, spender_, value_);
201         return true;
202     }
203 
204     /**
205      * @dev Function to check the amount of tokens that an owner allowed to a spender.
206      * @param owner_ address The address which owns the funds.
207      * @param spender_ address The address which will spend the funds.
208      * @return A uint specifying the amount of tokens still available for the spender.
209      */
210     function allowance(address owner_, address spender_) public view returns (uint) {
211         return allowed[owner_][spender_];
212     }
213 }
214 
215 // File: contracts/base/BaseICOToken.sol
216 
217 /**
218  * @dev Not mintable, ERC20 compilant token, distributed by ICO/Pre-ICO.
219  */
220 contract BaseICOToken is BaseFixedERC20Token {
221 
222     /// @dev Available supply of tokens
223     uint public availableSupply;
224 
225     /// @dev ICO/Pre-ICO smart contract allowed to distribute public funds for this
226     address public ico;
227 
228     /// @dev Fired if investment for `amount` of tokens performed by `to` address
229     event ICOTokensInvested(address indexed to, uint amount);
230 
231     /// @dev ICO contract changed for this token
232     event ICOChanged(address indexed icoContract);
233 
234     modifier onlyICO() {
235         require(msg.sender == ico);
236         _;
237     }
238 
239     /**
240      * @dev Not mintable, ERC20 compilant token, distributed by ICO/Pre-ICO.
241      * @param totalSupply_ Total tokens supply.
242      */
243     function BaseICOToken(uint totalSupply_) public {
244         locked = true;
245         totalSupply = totalSupply_;
246         availableSupply = totalSupply_;
247     }
248 
249     /**
250      * @dev Set address of ICO smart-contract which controls token
251      * initial token distribution.
252      * @param ico_ ICO contract address.
253      */
254     function changeICO(address ico_) public onlyOwner {
255         ico = ico_;
256         ICOChanged(ico);
257     }
258 
259     /**
260      * @dev Assign `amount_` of tokens to investor identified by `to_` address.
261      * @param to_ Investor address.
262      * @param amount_ Number of tokens distributed.
263      */
264     function icoInvestment(address to_, uint amount_) public onlyICO returns (uint) {
265         require(isValidICOInvestment(to_, amount_));
266         availableSupply = availableSupply.sub(amount_);
267         balances[to_] = balances[to_].add(amount_);
268         ICOTokensInvested(to_, amount_);
269         return amount_;
270     }
271 
272     function isValidICOInvestment(address to_, uint amount_) internal view returns (bool) {
273         return to_ != address(0) && amount_ <= availableSupply;
274     }
275 
276 }
277 
278 // File: contracts/base/BaseICO.sol
279 
280 /**
281  * @dev Base abstract smart contract for any ICO
282  */
283 contract BaseICO is Ownable {
284 
285     /// @dev ICO state
286     enum State {
287         // ICO is not active and not started
288         Inactive,
289         // ICO is active, tokens can be distributed among investors.
290         // ICO parameters (end date, hard/low caps) cannot be changed.
291         Active,
292         // ICO is suspended, tokens cannot be distributed among investors.
293         // ICO can be resumed to `Active state`.
294         // ICO parameters (end date, hard/low caps) may changed.
295         Suspended,
296         // ICO is termnated by owner, ICO cannot be resumed.
297         Terminated,
298         // ICO goals are not reached,
299         // ICO terminated and cannot be resumed.
300         NotCompleted,
301         // ICO completed, ICO goals reached successfully,
302         // ICO terminated and cannot be resumed.
303         Completed
304     }
305 
306     /// @dev Token which controlled by this ICO
307     BaseICOToken public token;
308 
309     /// @dev Current ICO state.
310     State public state;
311 
312     /// @dev ICO start date seconds since epoch.
313     uint public startAt;
314 
315     /// @dev ICO end date seconds since epoch.
316     uint public endAt;
317 
318     /// @dev Minimal amount of investments in wei needed for successful ICO
319     uint public lowCapWei;
320 
321     /// @dev Maximal amount of investments in wei for this ICO.
322     /// If reached ICO will be in `Completed` state.
323     uint public hardCapWei;
324 
325     /// @dev Minimal amount of investments in wei per investor.
326     uint public lowCapTxWei;
327 
328     /// @dev Maximal amount of investments in wei per investor.
329     uint public hardCapTxWei;
330 
331     /// @dev Number of investments collected by this ICO
332     uint public collectedWei;
333 
334     /// @dev Number of sold tokens by this ICO
335     uint public tokensSold;
336 
337     /// @dev Team wallet used to collect funds
338     address public teamWallet;
339 
340     // ICO state transition events
341     event ICOStarted(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
342     event ICOResumed(uint indexed endAt, uint lowCapWei, uint hardCapWei, uint lowCapTxWei, uint hardCapTxWei);
343     event ICOSuspended();
344     event ICOTerminated();
345     event ICONotCompleted();
346     event ICOCompleted(uint collectedWei);
347     event ICOInvestment(address indexed from, uint investedWei, uint tokens, uint8 bonusPct);
348 
349     function BaseICO(address icoToken_,
350                      address teamWallet_,
351                      uint lowCapWei_,
352                      uint hardCapWei_,
353                      uint lowCapTxWei_,
354                      uint hardCapTxWei_) public {
355         require(icoToken_ != address(0) && teamWallet_ != address(0));
356         token = BaseICOToken(icoToken_);
357         teamWallet = teamWallet_;
358         state = State.Inactive;
359         lowCapWei = lowCapWei_;
360         hardCapWei = hardCapWei_;
361         lowCapTxWei = lowCapTxWei_;
362         hardCapTxWei = hardCapTxWei_;
363     }
364 
365     modifier isSuspended() {
366         require(state == State.Suspended);
367         _;
368     }
369 
370     modifier isActive() {
371         require(state == State.Active);
372         _;
373     }
374 
375     /**
376      * @dev Trigger start of ICO.
377      * @param endAt_ ICO end date, seconds since epoch.
378      */
379     function start(uint endAt_) public onlyOwner {
380         require(endAt_ > block.timestamp && state == State.Inactive);
381         endAt = endAt_;
382         startAt = block.timestamp;
383         state = State.Active;
384         ICOStarted(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
385     }
386 
387     /**
388      * @dev Suspend this ICO.
389      * ICO can be activated later by calling `resume()` function.
390      * In suspend state, ICO owner can change basic ICO paraneter using `tune()` function,
391      * tokens cannot be distributed among investors.
392      */
393     function suspend() public onlyOwner isActive {
394         state = State.Suspended;
395         ICOSuspended();
396     }
397 
398     /**
399      * @dev Terminate the ICO.
400      * ICO goals are not reached, ICO terminated and cannot be resumed.
401      */
402     function terminate() public onlyOwner {
403         require(state != State.Terminated &&
404         state != State.NotCompleted &&
405         state != State.Completed);
406         state = State.Terminated;
407         ICOTerminated();
408     }
409 
410     /**
411      * @dev Change basic ICO parameters. Can be done only during `Suspended` state.
412      * Any provided parameter is used only if it is not zero.
413      * @param endAt_ ICO end date seconds since epoch. Used if it is not zero.
414      * @param lowCapWei_ ICO low capacity. Used if it is not zero.
415      * @param hardCapWei_ ICO hard capacity. Used if it is not zero.
416      * @param lowCapTxWei_ Min limit for ICO per transaction
417      * @param hardCapTxWei_ Hard limit for ICO per transaction
418      */
419     function tune(uint endAt_, uint lowCapWei_, uint hardCapWei_, uint lowCapTxWei_, uint hardCapTxWei_) public onlyOwner isSuspended {
420         if (endAt_ > block.timestamp) {
421             endAt = endAt_;
422         }
423         if (lowCapWei_ > 0) {
424             lowCapWei = lowCapWei_;
425         }
426         if (hardCapWei_ > 0) {
427             hardCapWei = hardCapWei_;
428         }
429         if (lowCapTxWei_ > 0) {
430             lowCapTxWei = lowCapTxWei_;
431         }
432         if (hardCapTxWei_ > 0) {
433             hardCapTxWei = hardCapTxWei_;
434         }
435         require(lowCapWei <= hardCapWei && lowCapTxWei <= hardCapTxWei);
436         touch();
437     }
438 
439     /**
440      * @dev Resume a previously suspended ICO.
441      */
442     function resume() public onlyOwner isSuspended {
443         state = State.Active;
444         ICOResumed(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
445         touch();
446     }
447 
448     /**
449      * @dev Recalculate ICO state based on current block time.
450      * Should be called periodically by ICO owner.
451      */
452     function touch() public;
453 
454     /**
455      * @dev Buy tokens
456      */
457     function buyTokens() public payable;
458 
459     /**
460      * @dev Send ether to the fund collection wallet
461      */
462     function forwardFunds() internal {
463         teamWallet.transfer(msg.value);
464     }
465 }
466 
467 // File: contracts/flavours/Whitelisted.sol
468 
469 contract Whitelisted is Ownable {
470 
471     /// @dev True if whitelist enabled
472     bool public whitelistEnabled = true;
473 
474     /// @dev ICO whitelist
475     mapping(address => bool) public whitelist;
476 
477     event ICOWhitelisted(address indexed addr);
478     event ICOBlacklisted(address indexed addr);
479 
480     modifier onlyWhitelisted {
481         require(!whitelistEnabled || whitelist[msg.sender]);
482         _;
483     }
484 
485     /**
486     * Add address to ICO whitelist
487     * @param address_ Investor address
488     */
489     function whitelist(address address_) external onlyOwner {
490         whitelist[address_] = true;
491         ICOWhitelisted(address_);
492     }
493 
494     /**
495      * Remove address from ICO whitelist
496      * @param address_ Investor address
497      */
498     function blacklist(address address_) external onlyOwner {
499         delete whitelist[address_];
500         ICOBlacklisted(address_);
501     }
502 
503     /**
504      * @dev Returns true if given address in ICO whitelist
505      */
506     function whitelisted(address address_) public view returns (bool) {
507         if (whitelistEnabled) {
508             return whitelist[address_];
509         } else {
510             return true;
511         }
512     }
513 
514     /**
515      * @dev Enable whitelisting
516      */
517     function enableWhitelist() public onlyOwner {
518         whitelistEnabled = true;
519     }
520 
521     /**
522      * @dev Disable whitelisting
523      */
524     function disableWhitelist() public onlyOwner {
525         whitelistEnabled = false;
526     }
527 
528 }
529 
530 // File: contracts/DWBTICO.sol
531 
532 /**
533  * @title DWBT tokens ICO contract.
534  */
535 contract DWBTICO is BaseICO, Whitelisted {
536     using SafeMath for uint;
537 
538     /// @dev 18 decimals for token
539     uint internal constant ONE_TOKEN = 1e18;
540 
541     /// @dev 1e18 WEI == 1ETH == 10000 tokens
542     uint public constant ETH_TOKEN_EXCHANGE_RATIO = 10000;
543 
544     /// @dev bonuses by week number
545     uint8[4] public weekBonuses;
546 
547     /// @dev investors count
548     uint public investorCount;
549 
550     // @dev investments distribution
551     mapping (address => uint) public investments;
552 
553     function DWBTICO(address icoToken_,
554                     address teamWallet_,
555                     uint lowCapWei_,
556                     uint hardCapWei_,
557                     uint lowCapTxWei_,
558                     uint hardCapTxWei_) public BaseICO(icoToken_, teamWallet_, lowCapWei_, hardCapWei_, lowCapTxWei_, hardCapTxWei_) {
559         weekBonuses = [0, 30, 20, 10];
560     }
561 
562     /**
563      * @dev Trigger start of ICO.
564      * @param endAt_ ICO end date, seconds since epoch.
565      */
566     function start(uint endAt_) public onlyOwner {
567         require(endAt_ > block.timestamp && state == State.Inactive);
568         endAt = endAt_;
569         startAt = block.timestamp;
570         state = State.Active;
571 
572         ICOStarted(endAt, lowCapWei, hardCapWei, lowCapTxWei, hardCapTxWei);
573     }
574 
575     /**
576      * @dev Recalculate ICO state based on current block time.
577      * Should be called periodically by ICO owner.
578      */
579     function touch() public {
580         if (state != State.Active && state != State.Suspended) {
581             return;
582         }
583         if (collectedWei >= hardCapWei) {
584             state = State.Completed;
585             endAt = block.timestamp;
586             ICOCompleted(collectedWei);
587         } else if (block.timestamp >= endAt) {
588             if (collectedWei < lowCapWei) {
589                 state = State.NotCompleted;
590                 ICONotCompleted();
591             } else {
592                 state = State.Completed;
593                 ICOCompleted(collectedWei);
594             }
595         }
596     }
597 
598     function buyTokens() public onlyWhitelisted payable {
599         require(state == State.Active &&
600                 block.timestamp <= endAt &&
601                 msg.value >= lowCapTxWei &&
602                 msg.value <= hardCapTxWei &&
603                 collectedWei + msg.value <= hardCapWei);
604         uint amountWei = msg.value;
605 
606         uint8 bonus = getCurrentBonus();
607         uint iwei = amountWei.mul(100 + bonus).div(100);
608         uint itokens = iwei * ETH_TOKEN_EXCHANGE_RATIO;
609         // Transfer tokens to investor
610         token.icoInvestment(msg.sender, itokens);
611         collectedWei = collectedWei.add(amountWei);
612         tokensSold = tokensSold.add(itokens);
613 
614         if (investments[msg.sender] == 0) {
615             // new investor
616             investorCount++;
617 
618         }
619         investments[msg.sender] = investments[msg.sender].add(amountWei);
620 
621         ICOInvestment(msg.sender, amountWei, itokens, bonus);
622 
623         forwardFunds();
624         touch();
625     }
626 
627     function getInvestments(address investor) public view returns (uint) {
628         return investments[investor];
629     }
630 
631     function getCurrentBonus() public view returns (uint8) {
632         return weekBonuses[getWeekNumber()];
633     }
634 
635     function getWeekNumber() internal view returns (uint8 weekNumber) {
636         weekNumber = 0;
637         uint time = startAt;
638         for (uint8 i = 1; i < weekBonuses.length; i++) {
639             time = time + 1 weeks;
640             if (block.timestamp <= time) {
641                 weekNumber = i;
642                 break;
643             }
644         }
645     }
646 
647     /**
648      * Accept direct payments
649      */
650     function() external payable {
651         buyTokens();
652     }
653 }