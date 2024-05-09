1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 contract Context {
17     // Empty internal constructor, to prevent people from mistakenly deploying
18     // an instance of this contract, which should be used via inheritance.
19     constructor () internal { }
20 
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/access/Ownable.sol
32 
33 
34 pragma solidity ^0.6.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor () internal {
57         address msgSender = _msgSender();
58         _owner = msgSender;
59         emit OwnershipTransferred(address(0), msgSender);
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 // File: contracts/Poll.sol
101 
102 
103 pragma solidity >=0.6.0 <0.7.0;
104 
105 
106 contract Poll is Ownable {
107     WalletRegistry walletRegistry;
108     Token token;
109 
110     // Designates when the poll is over
111     uint256 public end;
112 
113     string question;
114 
115     struct Option {
116         uint256 id;
117         string text;
118         uint256 votes; // Represented in weis
119     }
120 
121     Option[] options;
122 
123     mapping(address => bool) private voted;
124 
125     constructor(
126         WalletRegistry _walletRegistry,
127         Token _token,
128         string memory _question,
129         uint256 _end
130     ) public {
131         walletRegistry = _walletRegistry;
132         token = _token;
133         question = _question;
134         end = _end;
135     }
136 
137     function addOption(uint256 optionId, string memory text) public onlyOwner {
138         options.push(Option(optionId, text, 0));
139     }
140 
141     function vote(address account, uint256 optionId) public returns (bool) {
142         Controller controller = Controller(msg.sender);
143         require(
144             controller.votingPermissions(account),
145             "This account cannot vote"
146         );
147         require(controller.balances(account) > 0, "No balance to vote");
148         require(
149             walletRegistry.exists(account),
150             "Sender is not a registered account"
151         );
152         require(!voted[account], "Account already voted");
153         require(end > block.timestamp, "Voting period is already over");
154 
155         for (uint256 index = 0; index < options.length; index++) {
156             if (options[index].id == optionId) {
157                 options[index].votes += controller.balances(account);
158                 voted[account] = true;
159                 return true;
160             }
161         }
162 
163         revert("Not a valid option");
164     }
165 
166     function optionText(uint256 index) public view returns (string memory) {
167         return options[index].text;
168     }
169 
170     function optionVotes(uint256 index) public view returns (uint256) {
171         return options[index].votes;
172     }
173 }
174 
175 // File: contracts/WalletRegistry.sol
176 
177 
178 pragma solidity >=0.6.0 <0.7.0;
179 
180 
181 contract WalletRegistry is Ownable {
182     mapping(address => bool) private wallets;
183 
184     function addWallet(address _wallet) public onlyOwner {
185         wallets[_wallet] = true;
186     }
187 
188     function exists(address _wallet) public view returns (bool) {
189         return wallets[_wallet];
190     }
191 }
192 
193 // File: @openzeppelin/contracts/math/SafeMath.sol
194 
195 
196 
197 pragma solidity ^0.6.0;
198 
199 /**
200  * @dev Wrappers over Solidity's arithmetic operations with added overflow
201  * checks.
202  *
203  * Arithmetic operations in Solidity wrap on overflow. This can easily result
204  * in bugs, because programmers usually assume that an overflow raises an
205  * error, which is the standard behavior in high level programming languages.
206  * `SafeMath` restores this intuition by reverting the transaction when an
207  * operation overflows.
208  *
209  * Using this library instead of the unchecked operations eliminates an entire
210  * class of bugs, so it's recommended to use it always.
211  */
212 library SafeMath {
213     /**
214      * @dev Returns the addition of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `+` operator.
218      *
219      * Requirements:
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
239         return sub(a, b, "SafeMath: subtraction overflow");
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * Counterpart to Solidity's `-` operator.
247      *
248      * Requirements:
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b <= a, errorMessage);
253         uint256 c = a - b;
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the multiplication of two unsigned integers, reverting on
260      * overflow.
261      *
262      * Counterpart to Solidity's `*` operator.
263      *
264      * Requirements:
265      * - Multiplication cannot overflow.
266      */
267     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
268         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
269         // benefit is lost if 'b' is also tested.
270         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
271         if (a == 0) {
272             return 0;
273         }
274 
275         uint256 c = a * b;
276         require(c / a == b, "SafeMath: multiplication overflow");
277 
278         return c;
279     }
280 
281     /**
282      * @dev Returns the integer division of two unsigned integers. Reverts on
283      * division by zero. The result is rounded towards zero.
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      * - The divisor cannot be zero.
291      */
292     function div(uint256 a, uint256 b) internal pure returns (uint256) {
293         return div(a, b, "SafeMath: division by zero");
294     }
295 
296     /**
297      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
298      * division by zero. The result is rounded towards zero.
299      *
300      * Counterpart to Solidity's `/` operator. Note: this function uses a
301      * `revert` opcode (which leaves remaining gas untouched) while Solidity
302      * uses an invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      * - The divisor cannot be zero.
306      */
307     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
308         // Solidity only automatically asserts when dividing by 0
309         require(b > 0, errorMessage);
310         uint256 c = a / b;
311         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * Reverts when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328         return mod(a, b, "SafeMath: modulo by zero");
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333      * Reverts with custom message when dividing by zero.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      * - The divisor cannot be zero.
341      */
342     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
343         require(b != 0, errorMessage);
344         return a % b;
345     }
346 }
347 
348 // File: contracts/Controller.sol
349 
350 
351 pragma solidity >=0.6.0 <0.7.0;
352 
353 
354 
355 
356 
357 contract Controller is Ownable {
358     using SafeMath for uint256;
359 
360     WalletRegistry walletRegistry;
361     Token token;
362 
363     // Token balances
364     mapping(address => uint256) public balances;
365 
366     // Designates whether a user is able to vote
367     mapping(address => bool) public votingPermissions;
368 
369     // Initial vested amounts
370     mapping(address => uint256) public initialVestedAmounts;
371 
372     // New amounts transferred
373     mapping(address => mapping(uint256 => uint256)) public newVestedAmounts;
374 
375     // Vesting transferred
376     mapping(address => uint256) public vestingsTransferred;
377 
378     // Vesting period starts for each wallet
379     mapping(address => uint256) public startVestings;
380 
381     // Vesting periods
382     uint256 public firstVestingPeriodStart = 90;
383     uint256 public secondVestingPeriodStart = 180;
384     uint256 public thirdVestingPeriodStart = 270;
385     uint256 public fourthVestingPeriodStart = 365;
386 
387     uint256 public firstVestingPeriodStartDays = 90 days;
388     uint256 public secondVestingPeriodStartDays = 180 days;
389     uint256 public thirdVestingPeriodStartDays = 270 days;
390     uint256 public fourthVestingPeriodStartDays = 365 days;
391 
392     event EnableVoting();
393     event ConfigureVesting(
394         address account,
395         uint256 startVesting,
396         uint256 initialVestedAmount
397     );
398     event AddNewVestedAmount(uint256 amount);
399     event Transfer(address to, uint256 amount);
400     event Vote(address indexed account, address indexed poll, uint256 option);
401 
402     modifier onlyRegistered() {
403         require(
404             walletRegistry.exists(msg.sender),
405             "Sender is not a registered account"
406         );
407         _;
408     }
409 
410     modifier onlyToken() {
411         require(msg.sender == address(token), "Sender is not ERC20 token BHF");
412         _;
413     }
414 
415     constructor(WalletRegistry _walletRegistry, Token _token) public {
416         walletRegistry = _walletRegistry;
417         token = _token;
418     }
419 
420     function enableVoting(address account) public onlyOwner {
421         require(votingPermissions[account] == false, "Voting already enabled");
422 
423         votingPermissions[account] = true;
424 
425         emit EnableVoting();
426     }
427 
428     function configureVesting(
429         address account,
430         uint256 _initialVestedAmount,
431         uint256 _startVesting
432     ) public onlyOwner {
433         require(
434             initialVestedAmounts[account] == 0,
435             "Vesting already configured"
436         );
437 
438         startVestings[account] = _startVesting;
439         initialVestedAmounts[account] = _initialVestedAmount;
440 
441         emit ConfigureVesting(account, _startVesting, _initialVestedAmount);
442     }
443 
444     function addNewVestedAmount(address account, uint256 amount)
445         public
446         onlyOwner
447     {
448         require(initialVestedAmounts[account] != 0, "Vesting not configured");
449         require(amount > 0, "Increase is 0");
450 
451         newVestedAmounts[account][nextVestingPeriod(
452             account
453         )] = newVestedAmounts[account][nextVestingPeriod(account)].add(amount);
454 
455         emit AddNewVestedAmount(amount);
456     }
457 
458     function transfer(address account, uint256 amount) public onlyRegistered {
459         require(
460             availableToTransfer(msg.sender) >= amount,
461             "Wallet: Amount is subject to vesting or no balance"
462         );
463         require(
464             token.transfer(account, amount),
465             "Wallet: Could not complete the transfer"
466         );
467 
468         balances[msg.sender] = balances[msg.sender].sub(amount);
469         manageTransferredAmount(amount);
470 
471         emit Transfer(account, amount);
472     }
473 
474     function manageTransferredAmount(uint256 amount) internal {
475         if (freeFromVesting(msg.sender) > vestingsTransferred[msg.sender]) {
476             if (amount <= freeFromVesting(msg.sender)) {
477                 vestingsTransferred[msg.sender] = vestingsTransferred[msg
478                     .sender]
479                     .add(amount);
480             } else {
481                 vestingsTransferred[msg.sender] = freeFromVesting(msg.sender);
482             }
483         }
484     }
485 
486     function vote(Poll poll, uint256 option) public onlyRegistered {
487         require(poll.vote(msg.sender, option), "Could not vote");
488 
489         emit Vote(msg.sender, address(poll), option);
490     }
491 
492     function availableToTransfer(address account)
493         public
494         view
495         returns (uint256)
496     {
497         return nonVestedAmount(account).add(transferrableVesting(account));
498     }
499 
500     function transferrableVesting(address account)
501         public
502         view
503         returns (uint256)
504     {
505         return freeFromVesting(account) - vestingsTransferred[account];
506     }
507 
508     function freeFromVesting(address account) internal view returns (uint256) {
509         /*
510         Amount free from vesting calculed from the total vesting amount, it doen't take
511         tranferred vesting into account.
512         */
513         uint256 _freeFromVesting = 0;
514         uint256 _currentVestingPeriod = currentVestingPeriod(account);
515         uint256 _totalVestedAmountAvailable = totalVestedAmountAvailable(
516             account
517         );
518 
519         if (_currentVestingPeriod == fourthVestingPeriodStart) {
520             _freeFromVesting = _totalVestedAmountAvailable; // 100%
521         } else if (_currentVestingPeriod == thirdVestingPeriodStart) {
522             _freeFromVesting = (_totalVestedAmountAvailable.mul(300)).div(1000); // 30%
523         } else if (_currentVestingPeriod == secondVestingPeriodStart) {
524             _freeFromVesting = (_totalVestedAmountAvailable.mul(225)).div(1000); // 22.5%
525         } else if (_currentVestingPeriod == firstVestingPeriodStart) {
526             _freeFromVesting = (_totalVestedAmountAvailable.mul(150)).div(1000); // 15.0%
527         } else {
528             _freeFromVesting = (_totalVestedAmountAvailable.mul(75)).div(1000); // 7.5%
529         }
530 
531         return _freeFromVesting;
532     }
533 
534     function increaseBalance(address account, uint256 amount) public onlyToken {
535         balances[account] = balances[account].add(amount);
536     }
537 
538     function totalNewVestedAmounts(address account)
539         internal
540         view
541         returns (uint256)
542     {
543         uint256 nextVestingPeriod = nextVestingPeriod(account);
544 
545         if (nextVestingPeriod == firstVestingPeriodStart) {
546             return newVestedAmounts[account][firstVestingPeriodStart];
547         } else if (nextVestingPeriod == secondVestingPeriodStart) {
548             return
549                 newVestedAmounts[account][firstVestingPeriodStart].add(
550                     newVestedAmounts[account][secondVestingPeriodStart]
551                 );
552         } else if (nextVestingPeriod == thirdVestingPeriodStart) {
553             return
554                 newVestedAmounts[account][firstVestingPeriodStart]
555                     .add(newVestedAmounts[account][secondVestingPeriodStart])
556                     .add(newVestedAmounts[account][thirdVestingPeriodStart]);
557         } else {
558             return
559                 newVestedAmounts[account][firstVestingPeriodStart]
560                     .add(newVestedAmounts[account][secondVestingPeriodStart])
561                     .add(newVestedAmounts[account][thirdVestingPeriodStart])
562                     .add(newVestedAmounts[account][fourthVestingPeriodStart]);
563         }
564     }
565 
566     function totalVestedAmountAvailable(address account)
567         internal
568         view
569         returns (uint256)
570     {
571         return totalNewVestedAmounts(account) + initialVestedAmounts[account];
572     }
573 
574     function totalVestedAmount(address account)
575         internal
576         view
577         returns (uint256)
578     {
579         return
580             newVestedAmounts[account][firstVestingPeriodStart]
581                 .add(newVestedAmounts[account][secondVestingPeriodStart])
582                 .add(newVestedAmounts[account][thirdVestingPeriodStart])
583                 .add(newVestedAmounts[account][fourthVestingPeriodStart])
584                 .add(initialVestedAmounts[account]);
585     }
586 
587     function currentVestingPeriod(address account)
588         internal
589         view
590         returns (uint256)
591     {
592         uint256 currentTime = time();
593         if (
594             startVestings[account] <= currentTime &&
595             currentTime <
596             startVestings[account].add(firstVestingPeriodStartDays)
597         ) {
598             // Not stored since this is a dummy period in relation to new amounts in vesting
599             return 0;
600         } else if (
601             startVestings[account].add(firstVestingPeriodStartDays) <=
602             currentTime &&
603             currentTime <
604             startVestings[account].add(secondVestingPeriodStartDays)
605         ) {
606             return firstVestingPeriodStart;
607         } else if (
608             startVestings[account].add(secondVestingPeriodStartDays) <=
609             currentTime &&
610             currentTime <
611             startVestings[account].add(thirdVestingPeriodStartDays)
612         ) {
613             return secondVestingPeriodStart;
614         } else if (
615             startVestings[account].add(thirdVestingPeriodStartDays) <=
616             currentTime &&
617             currentTime <
618             startVestings[account].add(fourthVestingPeriodStartDays)
619         ) {
620             return thirdVestingPeriodStart;
621         } else {
622             return fourthVestingPeriodStart;
623         }
624     }
625 
626     function nextVestingPeriod(address account)
627         internal
628         view
629         returns (uint256)
630     {
631         /*
632         Returns the next vesting period, if last period is active keeps returning
633         the last one
634         */
635         if (time() <= startVestings[account].add(firstVestingPeriodStartDays)) {
636             return firstVestingPeriodStart;
637         } else if (
638             time() <= startVestings[account].add(secondVestingPeriodStartDays)
639         ) {
640             return secondVestingPeriodStart;
641         } else if (
642             time() <= startVestings[account].add(thirdVestingPeriodStartDays)
643         ) {
644             return thirdVestingPeriodStart;
645         } else {
646             return fourthVestingPeriodStart;
647         }
648     }
649 
650     function nonVestedAmount(address account) internal view returns (uint256) {
651         /* 
652             Returns the amount managed by the contract but not related to vesting
653             in any meanings
654         */
655         uint256 remainingVesting = totalVestedAmount(account).sub(
656             vestingsTransferred[account]
657         );
658 
659         return balances[account].sub(remainingVesting);
660     }
661 
662     function time() public virtual view returns (uint256) {
663         return block.timestamp;
664     }
665 }
666 
667 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
668 
669 
670 
671 pragma solidity ^0.6.0;
672 
673 /**
674  * @dev Interface of the ERC20 standard as defined in the EIP.
675  */
676 interface IERC20 {
677     /**
678      * @dev Returns the amount of tokens in existence.
679      */
680     function totalSupply() external view returns (uint256);
681 
682     /**
683      * @dev Returns the amount of tokens owned by `account`.
684      */
685     function balanceOf(address account) external view returns (uint256);
686 
687     /**
688      * @dev Moves `amount` tokens from the caller's account to `recipient`.
689      *
690      * Returns a boolean value indicating whether the operation succeeded.
691      *
692      * Emits a {Transfer} event.
693      */
694     function transfer(address recipient, uint256 amount) external returns (bool);
695 
696     /**
697      * @dev Returns the remaining number of tokens that `spender` will be
698      * allowed to spend on behalf of `owner` through {transferFrom}. This is
699      * zero by default.
700      *
701      * This value changes when {approve} or {transferFrom} are called.
702      */
703     function allowance(address owner, address spender) external view returns (uint256);
704 
705     /**
706      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
707      *
708      * Returns a boolean value indicating whether the operation succeeded.
709      *
710      * IMPORTANT: Beware that changing an allowance with this method brings the risk
711      * that someone may use both the old and the new allowance by unfortunate
712      * transaction ordering. One possible solution to mitigate this race
713      * condition is to first reduce the spender's allowance to 0 and set the
714      * desired value afterwards:
715      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
716      *
717      * Emits an {Approval} event.
718      */
719     function approve(address spender, uint256 amount) external returns (bool);
720 
721     /**
722      * @dev Moves `amount` tokens from `sender` to `recipient` using the
723      * allowance mechanism. `amount` is then deducted from the caller's
724      * allowance.
725      *
726      * Returns a boolean value indicating whether the operation succeeded.
727      *
728      * Emits a {Transfer} event.
729      */
730     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
731 
732     /**
733      * @dev Emitted when `value` tokens are moved from one account (`from`) to
734      * another (`to`).
735      *
736      * Note that `value` may be zero.
737      */
738     event Transfer(address indexed from, address indexed to, uint256 value);
739 
740     /**
741      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
742      * a call to {approve}. `value` is the new allowance.
743      */
744     event Approval(address indexed owner, address indexed spender, uint256 value);
745 }
746 
747 // File: @openzeppelin/contracts/utils/Address.sol
748 
749 
750 
751 pragma solidity ^0.6.2;
752 
753 /**
754  * @dev Collection of functions related to the address type
755  */
756 library Address {
757     /**
758      * @dev Returns true if `account` is a contract.
759      *
760      * [IMPORTANT]
761      * ====
762      * It is unsafe to assume that an address for which this function returns
763      * false is an externally-owned account (EOA) and not a contract.
764      *
765      * Among others, `isContract` will return false for the following
766      * types of addresses:
767      *
768      *  - an externally-owned account
769      *  - a contract in construction
770      *  - an address where a contract will be created
771      *  - an address where a contract lived, but was destroyed
772      * ====
773      */
774     function isContract(address account) internal view returns (bool) {
775         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
776         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
777         // for accounts without code, i.e. `keccak256('')`
778         bytes32 codehash;
779         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
780         // solhint-disable-next-line no-inline-assembly
781         assembly { codehash := extcodehash(account) }
782         return (codehash != accountHash && codehash != 0x0);
783     }
784 
785     /**
786      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
787      * `recipient`, forwarding all available gas and reverting on errors.
788      *
789      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
790      * of certain opcodes, possibly making contracts go over the 2300 gas limit
791      * imposed by `transfer`, making them unable to receive funds via
792      * `transfer`. {sendValue} removes this limitation.
793      *
794      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
795      *
796      * IMPORTANT: because control is transferred to `recipient`, care must be
797      * taken to not create reentrancy vulnerabilities. Consider using
798      * {ReentrancyGuard} or the
799      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
800      */
801     function sendValue(address payable recipient, uint256 amount) internal {
802         require(address(this).balance >= amount, "Address: insufficient balance");
803 
804         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
805         (bool success, ) = recipient.call{ value: amount }("");
806         require(success, "Address: unable to send value, recipient may have reverted");
807     }
808 }
809 
810 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
811 
812 
813 
814 pragma solidity ^0.6.0;
815 
816 
817 
818 
819 
820 /**
821  * @dev Implementation of the {IERC20} interface.
822  *
823  * This implementation is agnostic to the way tokens are created. This means
824  * that a supply mechanism has to be added in a derived contract using {_mint}.
825  * For a generic mechanism see {ERC20MinterPauser}.
826  *
827  * TIP: For a detailed writeup see our guide
828  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
829  * to implement supply mechanisms].
830  *
831  * We have followed general OpenZeppelin guidelines: functions revert instead
832  * of returning `false` on failure. This behavior is nonetheless conventional
833  * and does not conflict with the expectations of ERC20 applications.
834  *
835  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
836  * This allows applications to reconstruct the allowance for all accounts just
837  * by listening to said events. Other implementations of the EIP may not emit
838  * these events, as it isn't required by the specification.
839  *
840  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
841  * functions have been added to mitigate the well-known issues around setting
842  * allowances. See {IERC20-approve}.
843  */
844 contract ERC20 is Context, IERC20 {
845     using SafeMath for uint256;
846     using Address for address;
847 
848     mapping (address => uint256) private _balances;
849 
850     mapping (address => mapping (address => uint256)) private _allowances;
851 
852     uint256 private _totalSupply;
853 
854     string private _name;
855     string private _symbol;
856     uint8 private _decimals;
857 
858     /**
859      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
860      * a default value of 18.
861      *
862      * To select a different value for {decimals}, use {_setupDecimals}.
863      *
864      * All three of these values are immutable: they can only be set once during
865      * construction.
866      */
867     constructor (string memory name, string memory symbol) public {
868         _name = name;
869         _symbol = symbol;
870         _decimals = 18;
871     }
872 
873     /**
874      * @dev Returns the name of the token.
875      */
876     function name() public view returns (string memory) {
877         return _name;
878     }
879 
880     /**
881      * @dev Returns the symbol of the token, usually a shorter version of the
882      * name.
883      */
884     function symbol() public view returns (string memory) {
885         return _symbol;
886     }
887 
888     /**
889      * @dev Returns the number of decimals used to get its user representation.
890      * For example, if `decimals` equals `2`, a balance of `505` tokens should
891      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
892      *
893      * Tokens usually opt for a value of 18, imitating the relationship between
894      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
895      * called.
896      *
897      * NOTE: This information is only used for _display_ purposes: it in
898      * no way affects any of the arithmetic of the contract, including
899      * {IERC20-balanceOf} and {IERC20-transfer}.
900      */
901     function decimals() public view returns (uint8) {
902         return _decimals;
903     }
904 
905     /**
906      * @dev See {IERC20-totalSupply}.
907      */
908     function totalSupply() public view override returns (uint256) {
909         return _totalSupply;
910     }
911 
912     /**
913      * @dev See {IERC20-balanceOf}.
914      */
915     function balanceOf(address account) public view override returns (uint256) {
916         return _balances[account];
917     }
918 
919     /**
920      * @dev See {IERC20-transfer}.
921      *
922      * Requirements:
923      *
924      * - `recipient` cannot be the zero address.
925      * - the caller must have a balance of at least `amount`.
926      */
927     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
928         _transfer(_msgSender(), recipient, amount);
929         return true;
930     }
931 
932     /**
933      * @dev See {IERC20-allowance}.
934      */
935     function allowance(address owner, address spender) public view virtual override returns (uint256) {
936         return _allowances[owner][spender];
937     }
938 
939     /**
940      * @dev See {IERC20-approve}.
941      *
942      * Requirements:
943      *
944      * - `spender` cannot be the zero address.
945      */
946     function approve(address spender, uint256 amount) public virtual override returns (bool) {
947         _approve(_msgSender(), spender, amount);
948         return true;
949     }
950 
951     /**
952      * @dev See {IERC20-transferFrom}.
953      *
954      * Emits an {Approval} event indicating the updated allowance. This is not
955      * required by the EIP. See the note at the beginning of {ERC20};
956      *
957      * Requirements:
958      * - `sender` and `recipient` cannot be the zero address.
959      * - `sender` must have a balance of at least `amount`.
960      * - the caller must have allowance for ``sender``'s tokens of at least
961      * `amount`.
962      */
963     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
964         _transfer(sender, recipient, amount);
965         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
966         return true;
967     }
968 
969     /**
970      * @dev Atomically increases the allowance granted to `spender` by the caller.
971      *
972      * This is an alternative to {approve} that can be used as a mitigation for
973      * problems described in {IERC20-approve}.
974      *
975      * Emits an {Approval} event indicating the updated allowance.
976      *
977      * Requirements:
978      *
979      * - `spender` cannot be the zero address.
980      */
981     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
982         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
983         return true;
984     }
985 
986     /**
987      * @dev Atomically decreases the allowance granted to `spender` by the caller.
988      *
989      * This is an alternative to {approve} that can be used as a mitigation for
990      * problems described in {IERC20-approve}.
991      *
992      * Emits an {Approval} event indicating the updated allowance.
993      *
994      * Requirements:
995      *
996      * - `spender` cannot be the zero address.
997      * - `spender` must have allowance for the caller of at least
998      * `subtractedValue`.
999      */
1000     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1001         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1002         return true;
1003     }
1004 
1005     /**
1006      * @dev Moves tokens `amount` from `sender` to `recipient`.
1007      *
1008      * This is internal function is equivalent to {transfer}, and can be used to
1009      * e.g. implement automatic token fees, slashing mechanisms, etc.
1010      *
1011      * Emits a {Transfer} event.
1012      *
1013      * Requirements:
1014      *
1015      * - `sender` cannot be the zero address.
1016      * - `recipient` cannot be the zero address.
1017      * - `sender` must have a balance of at least `amount`.
1018      */
1019     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1020         require(sender != address(0), "ERC20: transfer from the zero address");
1021         require(recipient != address(0), "ERC20: transfer to the zero address");
1022 
1023         _beforeTokenTransfer(sender, recipient, amount);
1024 
1025         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1026         _balances[recipient] = _balances[recipient].add(amount);
1027         emit Transfer(sender, recipient, amount);
1028     }
1029 
1030     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1031      * the total supply.
1032      *
1033      * Emits a {Transfer} event with `from` set to the zero address.
1034      *
1035      * Requirements
1036      *
1037      * - `to` cannot be the zero address.
1038      */
1039     function _mint(address account, uint256 amount) internal virtual {
1040         require(account != address(0), "ERC20: mint to the zero address");
1041 
1042         _beforeTokenTransfer(address(0), account, amount);
1043 
1044         _totalSupply = _totalSupply.add(amount);
1045         _balances[account] = _balances[account].add(amount);
1046         emit Transfer(address(0), account, amount);
1047     }
1048 
1049     /**
1050      * @dev Destroys `amount` tokens from `account`, reducing the
1051      * total supply.
1052      *
1053      * Emits a {Transfer} event with `to` set to the zero address.
1054      *
1055      * Requirements
1056      *
1057      * - `account` cannot be the zero address.
1058      * - `account` must have at least `amount` tokens.
1059      */
1060     function _burn(address account, uint256 amount) internal virtual {
1061         require(account != address(0), "ERC20: burn from the zero address");
1062 
1063         _beforeTokenTransfer(account, address(0), amount);
1064 
1065         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1066         _totalSupply = _totalSupply.sub(amount);
1067         emit Transfer(account, address(0), amount);
1068     }
1069 
1070     /**
1071      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1072      *
1073      * This is internal function is equivalent to `approve`, and can be used to
1074      * e.g. set automatic allowances for certain subsystems, etc.
1075      *
1076      * Emits an {Approval} event.
1077      *
1078      * Requirements:
1079      *
1080      * - `owner` cannot be the zero address.
1081      * - `spender` cannot be the zero address.
1082      */
1083     function _approve(address owner, address spender, uint256 amount) internal virtual {
1084         require(owner != address(0), "ERC20: approve from the zero address");
1085         require(spender != address(0), "ERC20: approve to the zero address");
1086 
1087         _allowances[owner][spender] = amount;
1088         emit Approval(owner, spender, amount);
1089     }
1090 
1091     /**
1092      * @dev Sets {decimals} to a value other than the default one of 18.
1093      *
1094      * WARNING: This function should only be called from the constructor. Most
1095      * applications that interact with token contracts will not expect
1096      * {decimals} to ever change, and may work incorrectly if it does.
1097      */
1098     function _setupDecimals(uint8 decimals_) internal {
1099         _decimals = decimals_;
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before any transfer of tokens. This includes
1104      * minting and burning.
1105      *
1106      * Calling conditions:
1107      *
1108      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1109      * will be to transferred to `to`.
1110      * - when `from` is zero, `amount` tokens will be minted for `to`.
1111      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1112      * - `from` and `to` are never both zero.
1113      *
1114      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1115      */
1116     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1117 }
1118 
1119 // File: contracts/Token.sol
1120 
1121 
1122 pragma solidity >=0.6.0 <0.7.0;
1123 
1124 
1125 
1126 
1127 contract Token is ERC20 {
1128     Controller controller;
1129 
1130     address burnerAddress;
1131 
1132     constructor(uint256 _totalSupply, address _burnerAddress)
1133         public
1134         ERC20("Blue Hill", "BHF")
1135     {
1136         _mint(msg.sender, _totalSupply);
1137         burnerAddress = _burnerAddress;
1138         controller = Controller(address(0));
1139     }
1140 
1141     function transfer(address recipient, uint256 amount)
1142         public
1143         virtual
1144         override
1145         returns (bool)
1146     {
1147         require(
1148             msg.sender != burnerAddress,
1149             "Cannot transfer from burner address"
1150         );
1151         _transfer(msg.sender, recipient, amount);
1152 
1153         return true;
1154     }
1155 
1156     // Method to deposit tokens in the controller
1157     function depositController(address account, uint256 amount) public {
1158         controller.increaseBalance(account, amount);
1159         transfer(address(controller), amount);
1160     }
1161 
1162     // Total supply removing burned tokens
1163     function totalAvailable() public view returns (uint256) {
1164         return super.totalSupply() - balanceOf(burnerAddress);
1165     }
1166 
1167     function setController(Controller _controller) public {
1168         require(
1169             address(controller) == address(0),
1170             "Controller address already set."
1171         );
1172         controller = _controller;
1173     }
1174 }