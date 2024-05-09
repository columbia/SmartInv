1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21 
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: @openzeppelin/contracts/access/Ownable.sol
33 
34 
35 
36 pragma solidity ^0.6.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor () internal {
59         address msgSender = _msgSender();
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         emit OwnershipTransferred(_owner, newOwner);
98         _owner = newOwner;
99     }
100 }
101 
102 // File: contracts/Poll.sol
103 
104 
105 pragma solidity >=0.6.0 <0.7.0;
106 
107 
108 contract Poll is Ownable {
109     WalletRegistry walletRegistry;
110     Token token;
111 
112     // Designates when the poll is over
113     uint256 public end;
114 
115     string question;
116 
117     struct Option {
118         uint256 id;
119         string text;
120         uint256 votes; // Represented in weis
121     }
122 
123     Option[] options;
124 
125     mapping(address => bool) private voted;
126 
127     constructor(
128         WalletRegistry _walletRegistry,
129         Token _token,
130         string memory _question,
131         uint256 _end
132     ) public {
133         walletRegistry = _walletRegistry;
134         token = _token;
135         question = _question;
136         end = _end;
137     }
138 
139     function addOption(uint256 optionId, string memory text) public onlyOwner {
140         options.push(Option(optionId, text, 0));
141     }
142 
143     function vote(address account, uint256 optionId) public returns (bool) {
144         Controller controller = Controller(msg.sender);
145         require(
146             controller.votingPermissions(account),
147             "This account cannot vote"
148         );
149         require(controller.balances(account) > 0, "No balance to vote");
150         require(
151             walletRegistry.exists(account),
152             "Sender is not a registered account"
153         );
154         require(!voted[account], "Account already voted");
155         require(end > block.timestamp, "Voting period is already over");
156 
157         for (uint256 index = 0; index < options.length; index++) {
158             if (options[index].id == optionId) {
159                 options[index].votes += controller.balances(account);
160                 voted[account] = true;
161                 return true;
162             }
163         }
164 
165         revert("Not a valid option");
166     }
167 
168     function optionText(uint256 index) public view returns (string memory) {
169         return options[index].text;
170     }
171 
172     function optionVotes(uint256 index) public view returns (uint256) {
173         return options[index].votes;
174     }
175 }
176 
177 // File: @openzeppelin/contracts/math/SafeMath.sol
178 
179 
180 
181 pragma solidity ^0.6.0;
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations with added overflow
185  * checks.
186  *
187  * Arithmetic operations in Solidity wrap on overflow. This can easily result
188  * in bugs, because programmers usually assume that an overflow raises an
189  * error, which is the standard behavior in high level programming languages.
190  * `SafeMath` restores this intuition by reverting the transaction when an
191  * operation overflows.
192  *
193  * Using this library instead of the unchecked operations eliminates an entire
194  * class of bugs, so it's recommended to use it always.
195  */
196 library SafeMath {
197     /**
198      * @dev Returns the addition of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `+` operator.
202      *
203      * Requirements:
204      * - Addition cannot overflow.
205      */
206     function add(uint256 a, uint256 b) internal pure returns (uint256) {
207         uint256 c = a + b;
208         require(c >= a, "SafeMath: addition overflow");
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return sub(a, b, "SafeMath: subtraction overflow");
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b <= a, errorMessage);
237         uint256 c = a - b;
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the multiplication of two unsigned integers, reverting on
244      * overflow.
245      *
246      * Counterpart to Solidity's `*` operator.
247      *
248      * Requirements:
249      * - Multiplication cannot overflow.
250      */
251     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
253         // benefit is lost if 'b' is also tested.
254         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
255         if (a == 0) {
256             return 0;
257         }
258 
259         uint256 c = a * b;
260         require(c / a == b, "SafeMath: multiplication overflow");
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers. Reverts on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      * - The divisor cannot be zero.
275      */
276     function div(uint256 a, uint256 b) internal pure returns (uint256) {
277         return div(a, b, "SafeMath: division by zero");
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
282      * division by zero. The result is rounded towards zero.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         // Solidity only automatically asserts when dividing by 0
293         require(b > 0, errorMessage);
294         uint256 c = a / b;
295         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * Reverts when dividing by zero.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return mod(a, b, "SafeMath: modulo by zero");
313     }
314 
315     /**
316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317      * Reverts with custom message when dividing by zero.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      * - The divisor cannot be zero.
325      */
326     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b != 0, errorMessage);
328         return a % b;
329     }
330 }
331 
332 // File: contracts/Controller.sol
333 
334 
335 pragma solidity >=0.6.0 <0.7.0;
336 
337 
338 
339 
340 contract Controller is Ownable {
341     using SafeMath for uint256;
342 
343     WalletRegistry walletRegistry;
344     Token token;
345 
346     // Token balances
347     mapping(address => uint256) public balances;
348 
349     // Designates whether a user is able to vote
350     mapping(address => bool) public votingPermissions;
351 
352     // Initial vested amounts
353     mapping(address => uint256) public initialVestedAmounts;
354 
355     // New amounts transferred
356     mapping(address => mapping(uint256 => uint256)) public newVestedAmounts;
357 
358     // Vesting transferred
359     mapping(address => uint256) public vestingsTransferred;
360 
361     // Vesting period starts for each wallet
362     mapping(address => uint256) public startVestings;
363 
364     // Vesting periods
365     uint256 public firstVestingPeriodStart = 90;
366     uint256 public secondVestingPeriodStart = 180;
367     uint256 public thirdVestingPeriodStart = 270;
368     uint256 public fourthVestingPeriodStart = 365;
369 
370     uint256 public firstVestingPeriodStartDays = 90 days;
371     uint256 public secondVestingPeriodStartDays = 180 days;
372     uint256 public thirdVestingPeriodStartDays = 270 days;
373     uint256 public fourthVestingPeriodStartDays = 365 days;
374 
375     event EnableVoting();
376     event ConfigureVesting(
377         address account,
378         uint256 startVesting,
379         uint256 initialVestedAmount
380     );
381     event AddNewVestedAmount(uint256 amount);
382     event Transfer(address to, uint256 amount);
383     event Vote(address indexed account, address indexed poll, uint256 option);
384 
385     modifier onlyRegistered() {
386         require(
387             walletRegistry.exists(msg.sender),
388             "Sender is not a registered account"
389         );
390         _;
391     }
392 
393     modifier onlyToken() {
394         require(msg.sender == address(token), "Sender is not ERC20 token BHF");
395         _;
396     }
397 
398     constructor(WalletRegistry _walletRegistry, Token _token) public {
399         walletRegistry = _walletRegistry;
400         token = _token;
401     }
402 
403     function enableVoting(address account) public onlyOwner {
404         require(votingPermissions[account] == false, "Voting already enabled");
405 
406         votingPermissions[account] = true;
407 
408         emit EnableVoting();
409     }
410 
411     function configureVesting(
412         address account,
413         uint256 _initialVestedAmount,
414         uint256 _startVesting
415     ) public onlyOwner {
416         require(
417             initialVestedAmounts[account] == 0,
418             "Vesting already configured"
419         );
420 
421         startVestings[account] = _startVesting;
422         initialVestedAmounts[account] = _initialVestedAmount;
423 
424         emit ConfigureVesting(account, _startVesting, _initialVestedAmount);
425     }
426 
427     function addNewVestedAmount(address account, uint256 amount)
428         public
429         onlyOwner
430     {
431         require(initialVestedAmounts[account] != 0, "Vesting not configured");
432         require(amount > 0, "Increase is 0");
433 
434         newVestedAmounts[account][nextVestingPeriod(
435             account
436         )] = newVestedAmounts[account][nextVestingPeriod(account)].add(amount);
437 
438         emit AddNewVestedAmount(amount);
439     }
440 
441     function transfer(address account, uint256 amount) public onlyRegistered {
442         require(
443             availableToTransfer(msg.sender) >= amount,
444             "Wallet: Amount is subject to vesting or no balance"
445         );
446         require(
447             token.transfer(account, amount),
448             "Wallet: Could not complete the transfer"
449         );
450 
451         balances[msg.sender] = balances[msg.sender].sub(amount);
452         manageTransferredAmount(amount);
453 
454         emit Transfer(account, amount);
455     }
456 
457     function manageTransferredAmount(uint256 amount) internal {
458         if (freeFromVesting(msg.sender) > vestingsTransferred[msg.sender]) {
459             if (amount <= freeFromVesting(msg.sender)) {
460                 vestingsTransferred[msg.sender] = vestingsTransferred[msg
461                     .sender]
462                     .add(amount);
463             } else {
464                 vestingsTransferred[msg.sender] = freeFromVesting(msg.sender);
465             }
466         }
467     }
468 
469     function vote(Poll poll, uint256 option) public onlyRegistered {
470         require(poll.vote(msg.sender, option), "Could not vote");
471 
472         emit Vote(msg.sender, address(poll), option);
473     }
474 
475     function availableToTransfer(address account)
476         public
477         view
478         returns (uint256)
479     {
480         return nonVestedAmount(account).add(transferrableVesting(account));
481     }
482 
483     function transferrableVesting(address account)
484         public
485         view
486         returns (uint256)
487     {
488         return freeFromVesting(account) - vestingsTransferred[account];
489     }
490 
491     function freeFromVesting(address account) internal view returns (uint256) {
492         /*
493         Amount free from vesting calculed from the total vesting amount, it doen't take
494         tranferred vesting into account.
495         */
496         uint256 _freeFromVesting = 0;
497         uint256 _currentVestingPeriod = currentVestingPeriod(account);
498         uint256 _totalVestedAmountAvailable = totalVestedAmountAvailable(
499             account
500         );
501 
502         if (_currentVestingPeriod == fourthVestingPeriodStart) {
503             _freeFromVesting = _totalVestedAmountAvailable; // 100%
504         } else if (_currentVestingPeriod == thirdVestingPeriodStart) {
505             _freeFromVesting = (_totalVestedAmountAvailable.mul(300)).div(1000); // 30%
506         } else if (_currentVestingPeriod == secondVestingPeriodStart) {
507             _freeFromVesting = (_totalVestedAmountAvailable.mul(225)).div(1000); // 22.5%
508         } else if (_currentVestingPeriod == firstVestingPeriodStart) {
509             _freeFromVesting = (_totalVestedAmountAvailable.mul(150)).div(1000); // 15.0%
510         } else {
511             _freeFromVesting = (_totalVestedAmountAvailable.mul(75)).div(1000); // 7.5%
512         }
513 
514         return _freeFromVesting;
515     }
516 
517     function increaseBalance(address account, uint256 amount) public onlyToken {
518         balances[account] = balances[account].add(amount);
519     }
520 
521     function totalNewVestedAmounts(address account)
522         internal
523         view
524         returns (uint256)
525     {
526         uint256 nextVestingPeriod = nextVestingPeriod(account);
527 
528         if (nextVestingPeriod == firstVestingPeriodStart) {
529             return newVestedAmounts[account][firstVestingPeriodStart];
530         } else if (nextVestingPeriod == secondVestingPeriodStart) {
531             return
532                 newVestedAmounts[account][firstVestingPeriodStart].add(
533                     newVestedAmounts[account][secondVestingPeriodStart]
534                 );
535         } else if (nextVestingPeriod == thirdVestingPeriodStart) {
536             return
537                 newVestedAmounts[account][firstVestingPeriodStart]
538                     .add(newVestedAmounts[account][secondVestingPeriodStart])
539                     .add(newVestedAmounts[account][thirdVestingPeriodStart]);
540         } else {
541             return
542                 newVestedAmounts[account][firstVestingPeriodStart]
543                     .add(newVestedAmounts[account][secondVestingPeriodStart])
544                     .add(newVestedAmounts[account][thirdVestingPeriodStart])
545                     .add(newVestedAmounts[account][fourthVestingPeriodStart]);
546         }
547     }
548 
549     function totalVestedAmountAvailable(address account)
550         internal
551         view
552         returns (uint256)
553     {
554         return totalNewVestedAmounts(account) + initialVestedAmounts[account];
555     }
556 
557     function totalVestedAmount(address account)
558         internal
559         view
560         returns (uint256)
561     {
562         return
563             newVestedAmounts[account][firstVestingPeriodStart]
564                 .add(newVestedAmounts[account][secondVestingPeriodStart])
565                 .add(newVestedAmounts[account][thirdVestingPeriodStart])
566                 .add(newVestedAmounts[account][fourthVestingPeriodStart])
567                 .add(initialVestedAmounts[account]);
568     }
569 
570     function currentVestingPeriod(address account)
571         internal
572         view
573         returns (uint256)
574     {
575         uint256 currentTime = time();
576         if (
577             startVestings[account] <= currentTime &&
578             currentTime <
579             startVestings[account].add(firstVestingPeriodStartDays)
580         ) {
581             // Not stored since this is a dummy period in relation to new amounts in vesting
582             return 0;
583         } else if (
584             startVestings[account].add(firstVestingPeriodStartDays) <=
585             currentTime &&
586             currentTime <
587             startVestings[account].add(secondVestingPeriodStartDays)
588         ) {
589             return firstVestingPeriodStart;
590         } else if (
591             startVestings[account].add(secondVestingPeriodStartDays) <=
592             currentTime &&
593             currentTime <
594             startVestings[account].add(thirdVestingPeriodStartDays)
595         ) {
596             return secondVestingPeriodStart;
597         } else if (
598             startVestings[account].add(thirdVestingPeriodStartDays) <=
599             currentTime &&
600             currentTime <
601             startVestings[account].add(fourthVestingPeriodStartDays)
602         ) {
603             return thirdVestingPeriodStart;
604         } else {
605             return fourthVestingPeriodStart;
606         }
607     }
608 
609     function nextVestingPeriod(address account)
610         internal
611         view
612         returns (uint256)
613     {
614         /*
615         Returns the next vesting period, if last period is active keeps returning
616         the last one
617         */
618         if (time() <= startVestings[account].add(firstVestingPeriodStartDays)) {
619             return firstVestingPeriodStart;
620         } else if (
621             time() <= startVestings[account].add(secondVestingPeriodStartDays)
622         ) {
623             return secondVestingPeriodStart;
624         } else if (
625             time() <= startVestings[account].add(thirdVestingPeriodStartDays)
626         ) {
627             return thirdVestingPeriodStart;
628         } else {
629             return fourthVestingPeriodStart;
630         }
631     }
632 
633     function nonVestedAmount(address account) internal view returns (uint256) {
634         /* 
635             Returns the amount managed by the contract but not related to vesting
636             in any meanings
637         */
638         uint256 remainingVesting = totalVestedAmount(account).sub(
639             vestingsTransferred[account]
640         );
641 
642         return balances[account].sub(remainingVesting);
643     }
644 
645     function time() public virtual view returns (uint256) {
646         return block.timestamp;
647     }
648 }
649 
650 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
651 
652 
653 
654 pragma solidity ^0.6.0;
655 
656 /**
657  * @dev Interface of the ERC20 standard as defined in the EIP.
658  */
659 interface IERC20 {
660     /**
661      * @dev Returns the amount of tokens in existence.
662      */
663     function totalSupply() external view returns (uint256);
664 
665     /**
666      * @dev Returns the amount of tokens owned by `account`.
667      */
668     function balanceOf(address account) external view returns (uint256);
669 
670     /**
671      * @dev Moves `amount` tokens from the caller's account to `recipient`.
672      *
673      * Returns a boolean value indicating whether the operation succeeded.
674      *
675      * Emits a {Transfer} event.
676      */
677     function transfer(address recipient, uint256 amount) external returns (bool);
678 
679     /**
680      * @dev Returns the remaining number of tokens that `spender` will be
681      * allowed to spend on behalf of `owner` through {transferFrom}. This is
682      * zero by default.
683      *
684      * This value changes when {approve} or {transferFrom} are called.
685      */
686     function allowance(address owner, address spender) external view returns (uint256);
687 
688     /**
689      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
690      *
691      * Returns a boolean value indicating whether the operation succeeded.
692      *
693      * IMPORTANT: Beware that changing an allowance with this method brings the risk
694      * that someone may use both the old and the new allowance by unfortunate
695      * transaction ordering. One possible solution to mitigate this race
696      * condition is to first reduce the spender's allowance to 0 and set the
697      * desired value afterwards:
698      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
699      *
700      * Emits an {Approval} event.
701      */
702     function approve(address spender, uint256 amount) external returns (bool);
703 
704     /**
705      * @dev Moves `amount` tokens from `sender` to `recipient` using the
706      * allowance mechanism. `amount` is then deducted from the caller's
707      * allowance.
708      *
709      * Returns a boolean value indicating whether the operation succeeded.
710      *
711      * Emits a {Transfer} event.
712      */
713     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
714 
715     /**
716      * @dev Emitted when `value` tokens are moved from one account (`from`) to
717      * another (`to`).
718      *
719      * Note that `value` may be zero.
720      */
721     event Transfer(address indexed from, address indexed to, uint256 value);
722 
723     /**
724      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
725      * a call to {approve}. `value` is the new allowance.
726      */
727     event Approval(address indexed owner, address indexed spender, uint256 value);
728 }
729 
730 // File: @openzeppelin/contracts/utils/Address.sol
731 
732 
733 
734 pragma solidity ^0.6.2;
735 
736 /**
737  * @dev Collection of functions related to the address type
738  */
739 library Address {
740     /**
741      * @dev Returns true if `account` is a contract.
742      *
743      * [IMPORTANT]
744      * ====
745      * It is unsafe to assume that an address for which this function returns
746      * false is an externally-owned account (EOA) and not a contract.
747      *
748      * Among others, `isContract` will return false for the following
749      * types of addresses:
750      *
751      *  - an externally-owned account
752      *  - a contract in construction
753      *  - an address where a contract will be created
754      *  - an address where a contract lived, but was destroyed
755      * ====
756      */
757     function isContract(address account) internal view returns (bool) {
758         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
759         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
760         // for accounts without code, i.e. `keccak256('')`
761         bytes32 codehash;
762         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
763         // solhint-disable-next-line no-inline-assembly
764         assembly { codehash := extcodehash(account) }
765         return (codehash != accountHash && codehash != 0x0);
766     }
767 
768     /**
769      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
770      * `recipient`, forwarding all available gas and reverting on errors.
771      *
772      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
773      * of certain opcodes, possibly making contracts go over the 2300 gas limit
774      * imposed by `transfer`, making them unable to receive funds via
775      * `transfer`. {sendValue} removes this limitation.
776      *
777      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
778      *
779      * IMPORTANT: because control is transferred to `recipient`, care must be
780      * taken to not create reentrancy vulnerabilities. Consider using
781      * {ReentrancyGuard} or the
782      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
783      */
784     function sendValue(address payable recipient, uint256 amount) internal {
785         require(address(this).balance >= amount, "Address: insufficient balance");
786 
787         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
788         (bool success, ) = recipient.call{ value: amount }("");
789         require(success, "Address: unable to send value, recipient may have reverted");
790     }
791 }
792 
793 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
794 
795 
796 
797 pragma solidity ^0.6.0;
798 
799 
800 
801 
802 
803 /**
804  * @dev Implementation of the {IERC20} interface.
805  *
806  * This implementation is agnostic to the way tokens are created. This means
807  * that a supply mechanism has to be added in a derived contract using {_mint}.
808  * For a generic mechanism see {ERC20MinterPauser}.
809  *
810  * TIP: For a detailed writeup see our guide
811  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
812  * to implement supply mechanisms].
813  *
814  * We have followed general OpenZeppelin guidelines: functions revert instead
815  * of returning `false` on failure. This behavior is nonetheless conventional
816  * and does not conflict with the expectations of ERC20 applications.
817  *
818  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
819  * This allows applications to reconstruct the allowance for all accounts just
820  * by listening to said events. Other implementations of the EIP may not emit
821  * these events, as it isn't required by the specification.
822  *
823  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
824  * functions have been added to mitigate the well-known issues around setting
825  * allowances. See {IERC20-approve}.
826  */
827 contract ERC20 is Context, IERC20 {
828     using SafeMath for uint256;
829     using Address for address;
830 
831     mapping (address => uint256) private _balances;
832 
833     mapping (address => mapping (address => uint256)) private _allowances;
834 
835     uint256 private _totalSupply;
836 
837     string private _name;
838     string private _symbol;
839     uint8 private _decimals;
840 
841     /**
842      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
843      * a default value of 18.
844      *
845      * To select a different value for {decimals}, use {_setupDecimals}.
846      *
847      * All three of these values are immutable: they can only be set once during
848      * construction.
849      */
850     constructor (string memory name, string memory symbol) public {
851         _name = name;
852         _symbol = symbol;
853         _decimals = 18;
854     }
855 
856     /**
857      * @dev Returns the name of the token.
858      */
859     function name() public view returns (string memory) {
860         return _name;
861     }
862 
863     /**
864      * @dev Returns the symbol of the token, usually a shorter version of the
865      * name.
866      */
867     function symbol() public view returns (string memory) {
868         return _symbol;
869     }
870 
871     /**
872      * @dev Returns the number of decimals used to get its user representation.
873      * For example, if `decimals` equals `2`, a balance of `505` tokens should
874      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
875      *
876      * Tokens usually opt for a value of 18, imitating the relationship between
877      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
878      * called.
879      *
880      * NOTE: This information is only used for _display_ purposes: it in
881      * no way affects any of the arithmetic of the contract, including
882      * {IERC20-balanceOf} and {IERC20-transfer}.
883      */
884     function decimals() public view returns (uint8) {
885         return _decimals;
886     }
887 
888     /**
889      * @dev See {IERC20-totalSupply}.
890      */
891     function totalSupply() public view override returns (uint256) {
892         return _totalSupply;
893     }
894 
895     /**
896      * @dev See {IERC20-balanceOf}.
897      */
898     function balanceOf(address account) public view override returns (uint256) {
899         return _balances[account];
900     }
901 
902     /**
903      * @dev See {IERC20-transfer}.
904      *
905      * Requirements:
906      *
907      * - `recipient` cannot be the zero address.
908      * - the caller must have a balance of at least `amount`.
909      */
910     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
911         _transfer(_msgSender(), recipient, amount);
912         return true;
913     }
914 
915     /**
916      * @dev See {IERC20-allowance}.
917      */
918     function allowance(address owner, address spender) public view virtual override returns (uint256) {
919         return _allowances[owner][spender];
920     }
921 
922     /**
923      * @dev See {IERC20-approve}.
924      *
925      * Requirements:
926      *
927      * - `spender` cannot be the zero address.
928      */
929     function approve(address spender, uint256 amount) public virtual override returns (bool) {
930         _approve(_msgSender(), spender, amount);
931         return true;
932     }
933 
934     /**
935      * @dev See {IERC20-transferFrom}.
936      *
937      * Emits an {Approval} event indicating the updated allowance. This is not
938      * required by the EIP. See the note at the beginning of {ERC20};
939      *
940      * Requirements:
941      * - `sender` and `recipient` cannot be the zero address.
942      * - `sender` must have a balance of at least `amount`.
943      * - the caller must have allowance for ``sender``'s tokens of at least
944      * `amount`.
945      */
946     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
947         _transfer(sender, recipient, amount);
948         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
949         return true;
950     }
951 
952     /**
953      * @dev Atomically increases the allowance granted to `spender` by the caller.
954      *
955      * This is an alternative to {approve} that can be used as a mitigation for
956      * problems described in {IERC20-approve}.
957      *
958      * Emits an {Approval} event indicating the updated allowance.
959      *
960      * Requirements:
961      *
962      * - `spender` cannot be the zero address.
963      */
964     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
965         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
966         return true;
967     }
968 
969     /**
970      * @dev Atomically decreases the allowance granted to `spender` by the caller.
971      *
972      * This is an alternative to {approve} that can be used as a mitigation for
973      * problems described in {IERC20-approve}.
974      *
975      * Emits an {Approval} event indicating the updated allowance.
976      *
977      * Requirements:
978      *
979      * - `spender` cannot be the zero address.
980      * - `spender` must have allowance for the caller of at least
981      * `subtractedValue`.
982      */
983     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
984         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
985         return true;
986     }
987 
988     /**
989      * @dev Moves tokens `amount` from `sender` to `recipient`.
990      *
991      * This is internal function is equivalent to {transfer}, and can be used to
992      * e.g. implement automatic token fees, slashing mechanisms, etc.
993      *
994      * Emits a {Transfer} event.
995      *
996      * Requirements:
997      *
998      * - `sender` cannot be the zero address.
999      * - `recipient` cannot be the zero address.
1000      * - `sender` must have a balance of at least `amount`.
1001      */
1002     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1003         require(sender != address(0), "ERC20: transfer from the zero address");
1004         require(recipient != address(0), "ERC20: transfer to the zero address");
1005 
1006         _beforeTokenTransfer(sender, recipient, amount);
1007 
1008         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1009         _balances[recipient] = _balances[recipient].add(amount);
1010         emit Transfer(sender, recipient, amount);
1011     }
1012 
1013     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1014      * the total supply.
1015      *
1016      * Emits a {Transfer} event with `from` set to the zero address.
1017      *
1018      * Requirements
1019      *
1020      * - `to` cannot be the zero address.
1021      */
1022     function _mint(address account, uint256 amount) internal virtual {
1023         require(account != address(0), "ERC20: mint to the zero address");
1024 
1025         _beforeTokenTransfer(address(0), account, amount);
1026 
1027         _totalSupply = _totalSupply.add(amount);
1028         _balances[account] = _balances[account].add(amount);
1029         emit Transfer(address(0), account, amount);
1030     }
1031 
1032     /**
1033      * @dev Destroys `amount` tokens from `account`, reducing the
1034      * total supply.
1035      *
1036      * Emits a {Transfer} event with `to` set to the zero address.
1037      *
1038      * Requirements
1039      *
1040      * - `account` cannot be the zero address.
1041      * - `account` must have at least `amount` tokens.
1042      */
1043     function _burn(address account, uint256 amount) internal virtual {
1044         require(account != address(0), "ERC20: burn from the zero address");
1045 
1046         _beforeTokenTransfer(account, address(0), amount);
1047 
1048         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1049         _totalSupply = _totalSupply.sub(amount);
1050         emit Transfer(account, address(0), amount);
1051     }
1052 
1053     /**
1054      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1055      *
1056      * This is internal function is equivalent to `approve`, and can be used to
1057      * e.g. set automatic allowances for certain subsystems, etc.
1058      *
1059      * Emits an {Approval} event.
1060      *
1061      * Requirements:
1062      *
1063      * - `owner` cannot be the zero address.
1064      * - `spender` cannot be the zero address.
1065      */
1066     function _approve(address owner, address spender, uint256 amount) internal virtual {
1067         require(owner != address(0), "ERC20: approve from the zero address");
1068         require(spender != address(0), "ERC20: approve to the zero address");
1069 
1070         _allowances[owner][spender] = amount;
1071         emit Approval(owner, spender, amount);
1072     }
1073 
1074     /**
1075      * @dev Sets {decimals} to a value other than the default one of 18.
1076      *
1077      * WARNING: This function should only be called from the constructor. Most
1078      * applications that interact with token contracts will not expect
1079      * {decimals} to ever change, and may work incorrectly if it does.
1080      */
1081     function _setupDecimals(uint8 decimals_) internal {
1082         _decimals = decimals_;
1083     }
1084 
1085     /**
1086      * @dev Hook that is called before any transfer of tokens. This includes
1087      * minting and burning.
1088      *
1089      * Calling conditions:
1090      *
1091      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1092      * will be to transferred to `to`.
1093      * - when `from` is zero, `amount` tokens will be minted for `to`.
1094      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1095      * - `from` and `to` are never both zero.
1096      *
1097      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1098      */
1099     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1100 }
1101 
1102 // File: contracts/Token.sol
1103 
1104 
1105 pragma solidity >=0.6.0 <0.7.0;
1106 
1107 
1108 
1109 
1110 contract Token is ERC20 {
1111     Controller controller;
1112 
1113     address burnerAddress;
1114 
1115     constructor(uint256 _totalSupply, address _burnerAddress)
1116         public
1117         ERC20("Blue Hill", "BHF")
1118     {
1119         _mint(msg.sender, _totalSupply);
1120         burnerAddress = _burnerAddress;
1121         controller = Controller(address(0));
1122     }
1123 
1124     function transfer(address recipient, uint256 amount)
1125         public
1126         virtual
1127         override
1128         returns (bool)
1129     {
1130         require(
1131             msg.sender != burnerAddress,
1132             "Cannot transfer from burner address"
1133         );
1134         _transfer(msg.sender, recipient, amount);
1135 
1136         return true;
1137     }
1138 
1139     // Method to deposit tokens in the controller
1140     function depositController(address account, uint256 amount) public {
1141         controller.increaseBalance(account, amount);
1142         transfer(address(controller), amount);
1143     }
1144 
1145     // Total supply removing burned tokens
1146     function totalAvailable() public view returns (uint256) {
1147         return super.totalSupply() - balanceOf(burnerAddress);
1148     }
1149 
1150     function setController(Controller _controller) public {
1151         require(
1152             address(controller) == address(0),
1153             "Controller address already set."
1154         );
1155         controller = _controller;
1156     }
1157 }
1158 
1159 // File: contracts/WalletRegistry.sol
1160 
1161 
1162 pragma solidity >=0.6.0 <0.7.0;
1163 
1164 
1165 
1166 contract WalletRegistry is Ownable {
1167     mapping(address => bool) private wallets;
1168 
1169     function addWallet(address _wallet) public onlyOwner {
1170         wallets[_wallet] = true;
1171     }
1172 
1173     function exists(address _wallet) public view returns (bool) {
1174         return wallets[_wallet];
1175     }
1176 }