1 pragma solidity 0.5.17;
2 
3 pragma experimental ABIEncoderV2;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 
162 // Storage for a NORI token
163 contract NORITokenStorage {
164 
165     using SafeMath for uint256;
166 
167     /**
168      * @dev Guard variable for re-entrancy checks. Not currently used
169      */
170     bool internal _notEntered;
171 
172     /**
173      * @notice EIP-20 token name for this token
174      */
175     string public name;
176 
177     /**
178      * @notice EIP-20 token symbol for this token
179      */
180     string public symbol;
181 
182     /**
183      * @notice EIP-20 token decimals for this token
184      */
185     uint8 public decimals;
186 
187     /**
188      * @notice Governor for this contract
189      */
190     address public gov;
191 
192     /**
193      * @notice Pending governance for this contract
194      */
195     address public pendingGov;
196 
197     /**
198      * @notice Approved rebaser for this contract
199      */
200     address public rebaser;
201 
202     /**
203      * @notice Reserve address of NORI protocol
204      */
205     address public incentivizer;
206 
207     /**
208      * @notice Total supply of NORIs
209      */
210     uint256 public totalSupply;
211 
212     /**
213      * @notice Internal decimals used to handle scaling factor
214      */
215     uint256 public constant internalDecimals = 10**24;
216 
217     /**
218      * @notice Used for percentage maths
219      */
220     uint256 public constant BASE = 10**18;
221 
222     /**
223      * @notice Scaling factor that adjusts everyone's balances
224      */
225     uint256 public norisScalingFactor;
226 
227     mapping (address => uint256) internal _noriBalances;
228 
229     mapping (address => mapping (address => uint256)) internal _allowedFragments;
230 
231     uint256 public initSupply;
232 
233 }
234 
235 contract NORIGovernanceStorage {
236     /// @notice A record of each accounts delegate
237     mapping (address => address) internal _delegates;
238 
239     /// @notice A checkpoint for marking number of votes from a given block
240     struct Checkpoint {
241         uint32 fromBlock;
242         uint256 votes;
243     }
244 
245     /// @notice A record of votes checkpoints for each account, by index
246     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
247 
248     /// @notice The number of checkpoints for each account
249     mapping (address => uint32) public numCheckpoints;
250 
251     /// @notice The EIP-712 typehash for the contract's domain
252     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
253 
254     /// @notice The EIP-712 typehash for the delegation struct used by the contract
255     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
256 
257     /// @notice A record of states for signing / validating signatures
258     mapping (address => uint) public nonces;
259 }
260 
261 contract NORITokenInterface is NORITokenStorage, NORIGovernanceStorage {
262 
263     /// @notice An event thats emitted when an account changes its delegate
264     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
265 
266     /// @notice An event thats emitted when a delegate account's vote balance changes
267     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
268 
269     /**
270      * @notice Event emitted when tokens are rebased
271      */
272     event Rebase(uint256 epoch, uint256 prevNorisScalingFactor, uint256 newNorisScalingFactor);
273 
274     /*** Gov Events ***/
275 
276     /**
277      * @notice Event emitted when pendingGov is changed
278      */
279     event NewPendingGov(address oldPendingGov, address newPendingGov);
280 
281     /**
282      * @notice Event emitted when gov is changed
283      */
284     event NewGov(address oldGov, address newGov);
285 
286     /**
287      * @notice Sets the rebaser contract
288      */
289     event NewRebaser(address oldRebaser, address newRebaser);
290 
291     /**
292      * @notice Sets the incentivizer contract
293      */
294     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
295 
296     /* - ERC20 Events - */
297 
298     /**
299      * @notice EIP20 Transfer event
300      */
301     event Transfer(address indexed from, address indexed to, uint amount);
302 
303     /**
304      * @notice EIP20 Approval event
305      */
306     event Approval(address indexed owner, address indexed spender, uint amount);
307 
308     /* - Extra Events - */
309     /**
310      * @notice Tokens minted event
311      */
312     event Mint(address to, uint256 amount);
313 
314     // Public functions
315     function transfer(address to, uint256 value) external returns(bool);
316     function transferFrom(address from, address to, uint256 value) external returns(bool);
317     function balanceOf(address who) external view returns(uint256);
318     function balanceOfUnderlying(address who) external view returns(uint256);
319     function allowance(address owner_, address spender) external view returns(uint256);
320     function approve(address spender, uint256 value) external returns (bool);
321     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
322     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
323     function maxScalingFactor() external view returns (uint256);
324 
325     /* - Governance Functions - */
326     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
327     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
328     function delegate(address delegatee) external;
329     function delegates(address delegator) external view returns (address);
330     function getCurrentVotes(address account) external view returns (uint256);
331 
332     /* - Permissioned/Governance functions - */
333     function mint(address to, uint256 amount) external returns (bool);
334     function rebase(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);
335     function _setRebaser(address rebaser_) external;
336     function _setIncentivizer(address incentivizer_) external;
337     function _setPendingGov(address pendingGov_) external;
338     function _acceptGov() external;
339 }
340 
341 
342 contract NORIGovernanceToken is NORITokenInterface {
343 
344       /// @notice An event thats emitted when an account changes its delegate
345     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
346 
347     /// @notice An event thats emitted when a delegate account's vote balance changes
348     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
349 
350     /**
351      * @notice Delegate votes from `msg.sender` to `delegatee`
352      * @param delegator The address to get delegatee for
353      */
354     function delegates(address delegator)
355         external
356         view
357         returns (address)
358     {
359         return _delegates[delegator];
360     }
361 
362    /**
363     * @notice Delegate votes from `msg.sender` to `delegatee`
364     * @param delegatee The address to delegate votes to
365     */
366     function delegate(address delegatee) external {
367         return _delegate(msg.sender, delegatee);
368     }
369 
370     /**
371      * @notice Delegates votes from signatory to `delegatee`
372      * @param delegatee The address to delegate votes to
373      * @param nonce The contract state required to match the signature
374      * @param expiry The time at which to expire the signature
375      * @param v The recovery byte of the signature
376      * @param r Half of the ECDSA signature pair
377      * @param s Half of the ECDSA signature pair
378      */
379     function delegateBySig(
380         address delegatee,
381         uint nonce,
382         uint expiry,
383         uint8 v,
384         bytes32 r,
385         bytes32 s
386     )
387         external
388     {
389         bytes32 domainSeparator = keccak256(
390             abi.encode(
391                 DOMAIN_TYPEHASH,
392                 keccak256(bytes(name)),
393                 getChainId(),
394                 address(this)
395             )
396         );
397 
398         bytes32 structHash = keccak256(
399             abi.encode(
400                 DELEGATION_TYPEHASH,
401                 delegatee,
402                 nonce,
403                 expiry
404             )
405         );
406 
407         bytes32 digest = keccak256(
408             abi.encodePacked(
409                 "\x19\x01",
410                 domainSeparator,
411                 structHash
412             )
413         );
414 
415         address signatory = ecrecover(digest, v, r, s);
416         require(signatory != address(0), "NORI::delegateBySig: invalid signature");
417         require(nonce == nonces[signatory]++, "NORI::delegateBySig: invalid nonce");
418         require(now <= expiry, "NORI::delegateBySig: signature expired");
419         return _delegate(signatory, delegatee);
420     }
421 
422     /**
423      * @notice Gets the current votes balance for `account`
424      * @param account The address to get votes balance
425      * @return The number of current votes for `account`
426      */
427     function getCurrentVotes(address account)
428         external
429         view
430         returns (uint256)
431     {
432         uint32 nCheckpoints = numCheckpoints[account];
433         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
434     }
435 
436     /**
437      * @notice Determine the prior number of votes for an account as of a block number
438      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
439      * @param account The address of the account to check
440      * @param blockNumber The block number to get the vote balance at
441      * @return The number of votes the account had as of the given block
442      */
443     function getPriorVotes(address account, uint blockNumber)
444         external
445         view
446         returns (uint256)
447     {
448         require(blockNumber < block.number, "NORI::getPriorVotes: not yet determined");
449 
450         uint32 nCheckpoints = numCheckpoints[account];
451         if (nCheckpoints == 0) {
452             return 0;
453         }
454 
455         // First check most recent balance
456         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
457             return checkpoints[account][nCheckpoints - 1].votes;
458         }
459 
460         // Next check implicit zero balance
461         if (checkpoints[account][0].fromBlock > blockNumber) {
462             return 0;
463         }
464 
465         uint32 lower = 0;
466         uint32 upper = nCheckpoints - 1;
467         while (upper > lower) {
468             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
469             Checkpoint memory cp = checkpoints[account][center];
470             if (cp.fromBlock == blockNumber) {
471                 return cp.votes;
472             } else if (cp.fromBlock < blockNumber) {
473                 lower = center;
474             } else {
475                 upper = center - 1;
476             }
477         }
478         return checkpoints[account][lower].votes;
479     }
480 
481     function _delegate(address delegator, address delegatee)
482         internal
483     {
484         address currentDelegate = _delegates[delegator];
485         uint256 delegatorBalance = _noriBalances[delegator]; // balance of underlying NORIs (not scaled);
486         _delegates[delegator] = delegatee;
487 
488         emit DelegateChanged(delegator, currentDelegate, delegatee);
489 
490         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
491     }
492 
493     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
494         if (srcRep != dstRep && amount > 0) {
495             if (srcRep != address(0)) {
496                 // decrease old representative
497                 uint32 srcRepNum = numCheckpoints[srcRep];
498                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
499                 uint256 srcRepNew = srcRepOld.sub(amount);
500                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
501             }
502 
503             if (dstRep != address(0)) {
504                 // increase new representative
505                 uint32 dstRepNum = numCheckpoints[dstRep];
506                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
507                 uint256 dstRepNew = dstRepOld.add(amount);
508                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
509             }
510         }
511     }
512 
513     function _writeCheckpoint(
514         address delegatee,
515         uint32 nCheckpoints,
516         uint256 oldVotes,
517         uint256 newVotes
518     )
519         internal
520     {
521         uint32 blockNumber = safe32(block.number, "NORI::_writeCheckpoint: block number exceeds 32 bits");
522 
523         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
524             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
525         } else {
526             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
527             numCheckpoints[delegatee] = nCheckpoints + 1;
528         }
529 
530         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
531     }
532 
533     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
534         require(n < 2**32, errorMessage);
535         return uint32(n);
536     }
537 
538     function getChainId() internal pure returns (uint) {
539         uint256 chainId;
540         assembly { chainId := chainid() }
541         return chainId;
542     }
543 }
544 
545 contract NORIToken is NORIGovernanceToken {
546     // Modifiers
547     modifier onlyGov() {
548         require(msg.sender == gov);
549         _;
550     }
551 
552     modifier onlyRebaser() {
553         require(msg.sender == rebaser);
554         _;
555     }
556 
557     modifier onlyMinter() {
558         require(msg.sender == rebaser || msg.sender == incentivizer || msg.sender == gov, "not minter");
559         _;
560     }
561 
562     modifier validRecipient(address to) {
563         require(to != address(0x0));
564         require(to != address(this));
565         _;
566     }
567 
568     function initialize(
569         string memory name_,
570         string memory symbol_,
571         uint8 decimals_
572     )
573         public
574     {
575         require(norisScalingFactor == 0, "already initialized");
576         name = name_;
577         symbol = symbol_;
578         decimals = decimals_;
579     }
580 
581 
582     /**
583     * @notice Computes the current max scaling factor
584     */
585     function maxScalingFactor()
586         external
587         view
588         returns (uint256)
589     {
590         return _maxScalingFactor();
591     }
592 
593     function _maxScalingFactor()
594         internal
595         view
596         returns (uint256)
597     {
598         // scaling factor can only go up to 2**256-1 = initSupply * norisScalingFactor
599         // this is used to check if norisScalingFactor will be too high to compute balances when rebasing.
600         return uint256(-1) / initSupply;
601     }
602 
603     /**
604     * @notice Mints new tokens, increasing totalSupply, initSupply, and a users balance.
605     * @dev Limited to onlyMinter modifier
606     */
607     function mint(address to, uint256 amount)
608         external
609         onlyMinter
610         returns (bool)
611     {
612         _mint(to, amount);
613         return true;
614     }
615 
616     function _mint(address to, uint256 amount)
617         internal
618     {
619       // increase totalSupply
620       totalSupply = totalSupply.add(amount);
621 
622       // get underlying value
623       uint256 noriValue = amount.mul(internalDecimals).div(norisScalingFactor);
624 
625       // increase initSupply
626       initSupply = initSupply.add(noriValue);
627 
628       // make sure the mint didnt push maxScalingFactor too low
629       require(norisScalingFactor <= _maxScalingFactor(), "max scaling factor too low");
630 
631       // add balance
632       _noriBalances[to] = _noriBalances[to].add(noriValue);
633 
634       // add delegates to the minter
635       _moveDelegates(address(0), _delegates[to], noriValue);
636       emit Mint(to, amount);
637     }
638 
639     /* - ERC20 functionality - */
640 
641     /**
642     * @dev Transfer tokens to a specified address.
643     * @param to The address to transfer to.
644     * @param value The amount to be transferred.
645     * @return True on success, false otherwise.
646     */
647     function transfer(address to, uint256 value)
648         external
649         validRecipient(to)
650         returns (bool)
651     {
652         // underlying balance is stored in noris, so divide by current scaling factor
653 
654         // note, this means as scaling factor grows, dust will be untransferrable.
655         // minimum transfer value == norisScalingFactor / 1e24;
656 
657         // get amount in underlying
658         uint256 noriValue = value.mul(internalDecimals).div(norisScalingFactor);
659 
660         // sub from balance of sender
661         _noriBalances[msg.sender] = _noriBalances[msg.sender].sub(noriValue);
662 
663         // add to balance of receiver
664         _noriBalances[to] = _noriBalances[to].add(noriValue);
665         emit Transfer(msg.sender, to, value);
666 
667         _moveDelegates(_delegates[msg.sender], _delegates[to], noriValue);
668         return true;
669     }
670 
671     /**
672     * @dev Transfer tokens from one address to another.
673     * @param from The address you want to send tokens from.
674     * @param to The address you want to transfer to.
675     * @param value The amount of tokens to be transferred.
676     */
677     function transferFrom(address from, address to, uint256 value)
678         external
679         validRecipient(to)
680         returns (bool)
681     {
682         // decrease allowance
683         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
684 
685         // get value in noris
686         uint256 noriValue = value.mul(internalDecimals).div(norisScalingFactor);
687 
688         // sub from from
689         _noriBalances[from] = _noriBalances[from].sub(noriValue);
690         _noriBalances[to] = _noriBalances[to].add(noriValue);
691         emit Transfer(from, to, value);
692 
693         _moveDelegates(_delegates[from], _delegates[to], noriValue);
694         return true;
695     }
696 
697     /**
698     * @param who The address to query.
699     * @return The balance of the specified address.
700     */
701     function balanceOf(address who)
702       external
703       view
704       returns (uint256)
705     {
706       return _noriBalances[who].mul(norisScalingFactor).div(internalDecimals);
707     }
708 
709     /** @notice Currently returns the internal storage amount
710     * @param who The address to query.
711     * @return The underlying balance of the specified address.
712     */
713     function balanceOfUnderlying(address who)
714       external
715       view
716       returns (uint256)
717     {
718       return _noriBalances[who];
719     }
720 
721     /**
722      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
723      * @param owner_ The address which owns the funds.
724      * @param spender The address which will spend the funds.
725      * @return The number of tokens still available for the spender.
726      */
727     function allowance(address owner_, address spender)
728         external
729         view
730         returns (uint256)
731     {
732         return _allowedFragments[owner_][spender];
733     }
734 
735     /**
736      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
737      * msg.sender. This method is included for ERC20 compatibility.
738      * increaseAllowance and decreaseAllowance should be used instead.
739      * Changing an allowance with this method brings the risk that someone may transfer both
740      * the old and the new allowance - if they are both greater than zero - if a transfer
741      * transaction is mined before the later approve() call is mined.
742      *
743      * @param spender The address which will spend the funds.
744      * @param value The amount of tokens to be spent.
745      */
746     function approve(address spender, uint256 value)
747         external
748         returns (bool)
749     {
750         _allowedFragments[msg.sender][spender] = value;
751         emit Approval(msg.sender, spender, value);
752         return true;
753     }
754 
755     /**
756      * @dev Increase the amount of tokens that an owner has allowed to a spender.
757      * This method should be used instead of approve() to avoid the double approval vulnerability
758      * described above.
759      * @param spender The address which will spend the funds.
760      * @param addedValue The amount of tokens to increase the allowance by.
761      */
762     function increaseAllowance(address spender, uint256 addedValue)
763         external
764         returns (bool)
765     {
766         _allowedFragments[msg.sender][spender] =
767             _allowedFragments[msg.sender][spender].add(addedValue);
768         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
769         return true;
770     }
771 
772     /**
773      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
774      *
775      * @param spender The address which will spend the funds.
776      * @param subtractedValue The amount of tokens to decrease the allowance by.
777      */
778     function decreaseAllowance(address spender, uint256 subtractedValue)
779         external
780         returns (bool)
781     {
782         uint256 oldValue = _allowedFragments[msg.sender][spender];
783         if (subtractedValue >= oldValue) {
784             _allowedFragments[msg.sender][spender] = 0;
785         } else {
786             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
787         }
788         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
789         return true;
790     }
791 
792     /* - Governance Functions - */
793 
794     /** @notice sets the rebaser
795      * @param rebaser_ The address of the rebaser contract to use for authentication.
796      */
797     function _setRebaser(address rebaser_)
798         external
799         onlyGov
800     {
801         address oldRebaser = rebaser;
802         rebaser = rebaser_;
803         emit NewRebaser(oldRebaser, rebaser_);
804     }
805 
806     /** @notice sets the incentivizer
807      * @param incentivizer_ The address of the rebaser contract to use for authentication.
808      */
809     function _setIncentivizer(address incentivizer_)
810         external
811         onlyGov
812     {
813         address oldIncentivizer = incentivizer;
814         incentivizer = incentivizer_;
815         emit NewIncentivizer(oldIncentivizer, incentivizer_);
816     }
817 
818     /** @notice sets the pendingGov
819      * @param pendingGov_ The address of the rebaser contract to use for authentication.
820      */
821     function _setPendingGov(address pendingGov_)
822         external
823         onlyGov
824     {
825         address oldPendingGov = pendingGov;
826         pendingGov = pendingGov_;
827         emit NewPendingGov(oldPendingGov, pendingGov_);
828     }
829 
830     /** @notice lets msg.sender accept governance
831      *
832      */
833     function _acceptGov()
834         external
835     {
836         require(msg.sender == pendingGov, "!pending");
837         address oldGov = gov;
838         gov = pendingGov;
839         pendingGov = address(0);
840         emit NewGov(oldGov, gov);
841     }
842 
843     /* - Extras - */
844 
845     /**
846     * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
847     *
848     * @dev The supply adjustment equals (totalSupply * DeviationFromTargetRate) / rebaseLag
849     *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
850     *      and targetRate is CpiOracleRate / baseCpi
851     */
852     function rebase(
853         uint256 epoch,
854         uint256 indexDelta,
855         bool positive
856     )
857         external
858         onlyRebaser
859         returns (uint256)
860     {
861         if (indexDelta == 0) {
862           emit Rebase(epoch, norisScalingFactor, norisScalingFactor);
863           return totalSupply;
864         }
865 
866         uint256 prevNorisScalingFactor = norisScalingFactor;
867 
868         if (!positive) {
869            norisScalingFactor = norisScalingFactor.mul(BASE.sub(indexDelta)).div(BASE);
870         } else {
871             uint256 newScalingFactor = norisScalingFactor.mul(BASE.add(indexDelta)).div(BASE);
872             if (newScalingFactor < _maxScalingFactor()) {
873                 norisScalingFactor = newScalingFactor;
874             } else {
875               norisScalingFactor = _maxScalingFactor();
876             }
877         }
878 
879         totalSupply = initSupply.mul(norisScalingFactor);
880         emit Rebase(epoch, prevNorisScalingFactor, norisScalingFactor);
881         return totalSupply;
882     }
883 }
884 
885 contract NORI is NORIToken {
886     /**
887      * @notice Initialize the new money market
888      * @param name_ ERC-20 name of this token
889      * @param symbol_ ERC-20 symbol of this token
890      * @param decimals_ ERC-20 decimal precision of this token
891      */
892     function initialize(
893         string memory name_,
894         string memory symbol_,
895         uint8 decimals_,
896         address initial_owner,
897         uint256 initSupply_
898     )
899         public
900     {
901         require(initSupply_ > 0, "0 init supply");
902 
903         super.initialize(name_, symbol_, decimals_);
904 
905         initSupply = initSupply_.mul(10**24/ (BASE));
906         totalSupply = initSupply_;
907         norisScalingFactor = BASE;
908         _noriBalances[initial_owner] = initSupply_.mul(10**24 / (BASE));
909 
910         // owner renounces ownership after deployment as they need to set
911         // rebaser and incentivizer
912         // gov = gov_;
913     }
914 }
915 
916 
917 contract NORIDelegationStorage {
918     /**
919      * @notice Implementation address for this contract
920      */
921     address public implementation;
922 }
923 
924 contract NORIDelegatorInterface is NORIDelegationStorage {
925     /**
926      * @notice Emitted when implementation is changed
927      */
928     event NewImplementation(address oldImplementation, address newImplementation);
929 
930     /**
931      * @notice Called by the gov to update the implementation of the delegator
932      * @param implementation_ The address of the new implementation for delegation
933      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
934      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
935      */
936     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
937 }
938 
939 contract NORIDelegateInterface is NORIDelegationStorage {
940     /**
941      * @notice Called by the delegator on a delegate to initialize it for duty
942      * @dev Should revert if any issues arise which make it unfit for delegation
943      * @param data The encoded bytes data for any initialization
944      */
945     function _becomeImplementation(bytes memory data) public;
946 
947     /**
948      * @notice Called by the delegator on a delegate to forfeit its responsibility
949      */
950     function _resignImplementation() public;
951 }
952 
953 
954 contract NORIDelegate is NORI, NORIDelegateInterface {
955     /**
956      * @notice Construct an empty delegate
957      */
958     constructor() public {}
959 
960     /**
961      * @notice Called by the delegator on a delegate to initialize it for duty
962      * @param data The encoded bytes data for any initialization
963      */
964     function _becomeImplementation(bytes memory data) public {
965         // Shh -- currently unused
966         data;
967 
968         // Shh -- we don't ever want this hook to be marked pure
969         if (false) {
970             implementation = address(0);
971         }
972 
973         require(msg.sender == gov, "only the gov may call _becomeImplementation");
974     }
975 
976     /**
977      * @notice Called by the delegator on a delegate to forfeit its responsibility
978      */
979     function _resignImplementation() public {
980         // Shh -- we don't ever want this hook to be marked pure
981         if (false) {
982             implementation = address(0);
983         }
984 
985         require(msg.sender == gov, "only the gov may call _resignImplementation");
986     }
987 }
988 
989 contract NORIDelegator is NORITokenInterface, NORIDelegatorInterface {
990     /**
991      * @notice Construct a new NORI
992      * @param name_ ERC-20 name of this token
993      * @param symbol_ ERC-20 symbol of this token
994      * @param decimals_ ERC-20 decimal precision of this token
995      * @param initSupply_ Initial token amount
996      * @param implementation_ The address of the implementation the contract delegates to
997      * @param becomeImplementationData The encoded args for becomeImplementation
998      */
999     constructor(
1000         string memory name_,
1001         string memory symbol_,
1002         uint8 decimals_,
1003         uint256 initSupply_,
1004         address implementation_,
1005         bytes memory becomeImplementationData
1006     )
1007         public
1008     {
1009 
1010 
1011         // Creator of the contract is gov during initialization
1012         gov = msg.sender;
1013 
1014         // First delegate gets to initialize the delegator (i.e. storage contract)
1015         delegateTo(
1016             implementation_,
1017             abi.encodeWithSignature(
1018                 "initialize(string,string,uint8,address,uint256)",
1019                 name_,
1020                 symbol_,
1021                 decimals_,
1022                 msg.sender,
1023                 initSupply_
1024             )
1025         );
1026 
1027         // New implementations always get set via the settor (post-initialize)
1028         _setImplementation(implementation_, false, becomeImplementationData);
1029 
1030     }
1031 
1032     /**
1033      * @notice Called by the gov to update the implementation of the delegator
1034      * @param implementation_ The address of the new implementation for delegation
1035      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
1036      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
1037      */
1038     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
1039         require(msg.sender == gov, "NORIDelegator::_setImplementation: Caller must be gov");
1040 
1041         if (allowResign) {
1042             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
1043         }
1044 
1045         address oldImplementation = implementation;
1046         implementation = implementation_;
1047 
1048         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
1049 
1050         emit NewImplementation(oldImplementation, implementation);
1051     }
1052 
1053     /**
1054      * @notice Sender supplies assets into the market and receives cTokens in exchange
1055      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1056      * @param mintAmount The amount of the underlying asset to supply
1057      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1058      */
1059     function mint(address to, uint256 mintAmount)
1060         external
1061         returns (bool)
1062     {
1063         to; mintAmount; // Shh
1064         delegateAndReturn();
1065     }
1066 
1067     /**
1068      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1069      * @param dst The address of the destination account
1070      * @param amount The number of tokens to transfer
1071      * @return Whether or not the transfer succeeded
1072      */
1073     function transfer(address dst, uint256 amount)
1074         external
1075         returns (bool)
1076     {
1077         dst; amount; // Shh
1078         delegateAndReturn();
1079     }
1080 
1081     /**
1082      * @notice Transfer `amount` tokens from `src` to `dst`
1083      * @param src The address of the source account
1084      * @param dst The address of the destination account
1085      * @param amount The number of tokens to transfer
1086      * @return Whether or not the transfer succeeded
1087      */
1088     function transferFrom(
1089         address src,
1090         address dst,
1091         uint256 amount
1092     )
1093         external
1094         returns (bool)
1095     {
1096         src; dst; amount; // Shh
1097         delegateAndReturn();
1098     }
1099 
1100     /**
1101      * @notice Approve `spender` to transfer up to `amount` from `src`
1102      * @dev This will overwrite the approval amount for `spender`
1103      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1104      * @param spender The address of the account which may transfer tokens
1105      * @param amount The number of tokens that are approved (-1 means infinite)
1106      * @return Whether or not the approval succeeded
1107      */
1108     function approve(
1109         address spender,
1110         uint256 amount
1111     )
1112         external
1113         returns (bool)
1114     {
1115         spender; amount; // Shh
1116         delegateAndReturn();
1117     }
1118 
1119     /**
1120      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1121      * This method should be used instead of approve() to avoid the double approval vulnerability
1122      * described above.
1123      * @param spender The address which will spend the funds.
1124      * @param addedValue The amount of tokens to increase the allowance by.
1125      */
1126     function increaseAllowance(
1127         address spender,
1128         uint256 addedValue
1129     )
1130         external
1131         returns (bool)
1132     {
1133         spender; addedValue; // Shh
1134         delegateAndReturn();
1135     }
1136 
1137     function maxScalingFactor()
1138         external
1139         view
1140         returns (uint256)
1141     {
1142         delegateToViewAndReturn();
1143     }
1144 
1145     function rebase(
1146         uint256 epoch,
1147         uint256 indexDelta,
1148         bool positive
1149     )
1150         external
1151         returns (uint256)
1152     {
1153         epoch; indexDelta; positive;
1154         delegateAndReturn();
1155     }
1156 
1157     /**
1158      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1159      *
1160      * @param spender The address which will spend the funds.
1161      * @param subtractedValue The amount of tokens to decrease the allowance by.
1162      */
1163     function decreaseAllowance(
1164         address spender,
1165         uint256 subtractedValue
1166     )
1167         external
1168         returns (bool)
1169     {
1170         spender; subtractedValue; // Shh
1171         delegateAndReturn();
1172     }
1173 
1174     /**
1175      * @notice Get the current allowance from `owner` for `spender`
1176      * @param owner The address of the account which owns the tokens to be spent
1177      * @param spender The address of the account which may transfer tokens
1178      * @return The number of tokens allowed to be spent (-1 means infinite)
1179      */
1180     function allowance(
1181         address owner,
1182         address spender
1183     )
1184         external
1185         view
1186         returns (uint256)
1187     {
1188         owner; spender; // Shh
1189         delegateToViewAndReturn();
1190     }
1191 
1192     /**
1193      * @notice Get the current allowance from `owner` for `spender`
1194      * @param delegator The address of the account which has designated a delegate
1195      * @return Address of delegatee
1196      */
1197     function delegates(
1198         address delegator
1199     )
1200         external
1201         view
1202         returns (address)
1203     {
1204         delegator; // Shh
1205         delegateToViewAndReturn();
1206     }
1207 
1208     /**
1209      * @notice Get the token balance of the `owner`
1210      * @param owner The address of the account to query
1211      * @return The number of tokens owned by `owner`
1212      */
1213     function balanceOf(address owner)
1214         external
1215         view
1216         returns (uint256)
1217     {
1218         owner; // Shh
1219         delegateToViewAndReturn();
1220     }
1221 
1222     /**
1223      * @notice Currently unused. For future compatability
1224      * @param owner The address of the account to query
1225      * @return The number of underlying tokens owned by `owner`
1226      */
1227     function balanceOfUnderlying(address owner)
1228         external
1229         view
1230         returns (uint256)
1231     {
1232         owner; // Shh
1233         delegateToViewAndReturn();
1234     }
1235 
1236     /*** Gov Functions ***/
1237 
1238     /**
1239       * @notice Begins transfer of gov rights. The newPendingGov must call `_acceptGov` to finalize the transfer.
1240       * @dev Gov function to begin change of gov. The newPendingGov must call `_acceptGov` to finalize the transfer.
1241       * @param newPendingGov New pending gov.
1242       */
1243     function _setPendingGov(address newPendingGov)
1244         external
1245     {
1246         newPendingGov; // Shh
1247         delegateAndReturn();
1248     }
1249 
1250     function _setRebaser(address rebaser_)
1251         external
1252     {
1253         rebaser_; // Shh
1254         delegateAndReturn();
1255     }
1256 
1257     function _setIncentivizer(address incentivizer_)
1258         external
1259     {
1260         incentivizer_; // Shh
1261         delegateAndReturn();
1262     }
1263 
1264     /**
1265       * @notice Accepts transfer of gov rights. msg.sender must be pendingGov
1266       * @dev Gov function for pending gov to accept role and update gov
1267       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1268       */
1269     function _acceptGov()
1270         external
1271     {
1272         delegateAndReturn();
1273     }
1274 
1275 
1276     function getPriorVotes(address account, uint blockNumber)
1277         external
1278         view
1279         returns (uint256)
1280     {
1281         account; blockNumber;
1282         delegateToViewAndReturn();
1283     }
1284 
1285     function delegateBySig(
1286         address delegatee,
1287         uint nonce,
1288         uint expiry,
1289         uint8 v,
1290         bytes32 r,
1291         bytes32 s
1292     )
1293         external
1294     {
1295         delegatee; nonce; expiry; v; r; s;
1296         delegateAndReturn();
1297     }
1298 
1299     function delegate(address delegatee)
1300         external
1301     {
1302         delegatee;
1303         delegateAndReturn();
1304     }
1305 
1306     function getCurrentVotes(address account)
1307         external
1308         view
1309         returns (uint256)
1310     {
1311         account;
1312         delegateToViewAndReturn();
1313     }
1314 
1315     /**
1316      * @notice Internal method to delegate execution to another contract
1317      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1318      * @param callee The contract to delegatecall
1319      * @param data The raw data to delegatecall
1320      * @return The returned bytes from the delegatecall
1321      */
1322     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
1323         (bool success, bytes memory returnData) = callee.delegatecall(data);
1324         assembly {
1325             if eq(success, 0) {
1326                 revert(add(returnData, 0x20), returndatasize)
1327             }
1328         }
1329         return returnData;
1330     }
1331 
1332     /**
1333      * @notice Delegates execution to the implementation contract
1334      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1335      * @param data The raw data to delegatecall
1336      * @return The returned bytes from the delegatecall
1337      */
1338     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
1339         return delegateTo(implementation, data);
1340     }
1341 
1342     /**
1343      * @notice Delegates execution to an implementation contract
1344      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1345      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
1346      * @param data The raw data to delegatecall
1347      * @return The returned bytes from the delegatecall
1348      */
1349     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
1350         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
1351         assembly {
1352             if eq(success, 0) {
1353                 revert(add(returnData, 0x20), returndatasize)
1354             }
1355         }
1356         return abi.decode(returnData, (bytes));
1357     }
1358 
1359     function delegateToViewAndReturn() private view returns (bytes memory) {
1360         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
1361 
1362         assembly {
1363             let free_mem_ptr := mload(0x40)
1364             returndatacopy(free_mem_ptr, 0, returndatasize)
1365 
1366             switch success
1367             case 0 { revert(free_mem_ptr, returndatasize) }
1368             default { return(add(free_mem_ptr, 0x40), returndatasize) }
1369         }
1370     }
1371 
1372     function delegateAndReturn() private returns (bytes memory) {
1373         (bool success, ) = implementation.delegatecall(msg.data);
1374 
1375         assembly {
1376             let free_mem_ptr := mload(0x40)
1377             returndatacopy(free_mem_ptr, 0, returndatasize)
1378 
1379             switch success
1380             case 0 { revert(free_mem_ptr, returndatasize) }
1381             default { return(free_mem_ptr, returndatasize) }
1382         }
1383     }
1384 
1385     /**
1386      * @notice Delegates execution to an implementation contract
1387      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1388      */
1389     function () external payable {
1390         require(msg.value == 0,"NORIDelegator:fallback: cannot send value to fallback");
1391 
1392         // delegate all other functions to current implementation
1393         delegateAndReturn();
1394     }
1395 }