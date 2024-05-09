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
162 // Storage for a DONDI token
163 contract DONDITokenStorage {
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
202     mapping(address => bool) public minter;
203 
204     /**
205      * @notice Reserve address of DONDI protocol
206      */
207     address public incentivizer;
208 
209     /**
210      * @notice Total supply of DONDIs
211      */
212     uint256 public totalSupply;
213 
214     /**
215      * @notice Internal decimals used to handle scaling factor
216      */
217     uint256 public constant internalDecimals = 10**24;
218 
219     /**
220      * @notice Used for percentage maths
221      */
222     uint256 public constant BASE = 10**18;
223 
224     /**
225      * @notice Scaling factor that adjusts everyone's balances
226      */
227     uint256 public dondisScalingFactor;
228 
229     mapping (address => uint256) internal _dondiBalances;
230 
231     mapping (address => mapping (address => uint256)) internal _allowedFragments;
232 
233     uint256 public initSupply;
234 
235 }
236 
237 contract DONDIGovernanceStorage {
238     /// @notice A record of each accounts delegate
239     mapping (address => address) internal _delegates;
240 
241     /// @notice A checkpoint for marking number of votes from a given block
242     struct Checkpoint {
243         uint32 fromBlock;
244         uint256 votes;
245     }
246 
247     /// @notice A record of votes checkpoints for each account, by index
248     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
249 
250     /// @notice The number of checkpoints for each account
251     mapping (address => uint32) public numCheckpoints;
252 
253     /// @notice The EIP-712 typehash for the contract's domain
254     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
255 
256     /// @notice The EIP-712 typehash for the delegation struct used by the contract
257     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
258 
259     /// @notice A record of states for signing / validating signatures
260     mapping (address => uint) public nonces;
261 }
262 
263 contract DONDITokenInterface is DONDITokenStorage, DONDIGovernanceStorage {
264 
265     /// @notice An event thats emitted when an account changes its delegate
266     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
267 
268     /// @notice An event thats emitted when a delegate account's vote balance changes
269     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
270 
271     /**
272      * @notice Event emitted when tokens are rebased
273      */
274     event Rebase(uint256 epoch, uint256 prevDondisScalingFactor, uint256 newDondisScalingFactor);
275 
276     /*** Gov Events ***/
277 
278     /**
279      * @notice Event emitted when pendingGov is changed
280      */
281     event NewPendingGov(address oldPendingGov, address newPendingGov);
282 
283     /**
284      * @notice Event emitted when gov is changed
285      */
286     event NewGov(address oldGov, address newGov);
287 
288     /**
289      * @notice Sets the rebaser contract
290      */
291     event NewRebaser(address oldRebaser, address newRebaser);
292 
293     /**
294      * @notice Sets the incentivizer contract
295      */
296     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
297 
298     event NewMinter(address newMinter);
299 
300     event RemoveMinter(address removeMinter);
301 
302     /* - ERC20 Events - */
303 
304     /**
305      * @notice EIP20 Transfer event
306      */
307     event Transfer(address indexed from, address indexed to, uint amount);
308 
309     /**
310      * @notice EIP20 Approval event
311      */
312     event Approval(address indexed owner, address indexed spender, uint amount);
313 
314     /* - Extra Events - */
315     /**
316      * @notice Tokens minted event
317      */
318     event Mint(address to, uint256 amount);
319 
320     // Public functions
321     function transfer(address to, uint256 value) external returns(bool);
322     function transferFrom(address from, address to, uint256 value) external returns(bool);
323     function balanceOf(address who) external view returns(uint256);
324     function balanceOfUnderlying(address who) external view returns(uint256);
325     function allowance(address owner_, address spender) external view returns(uint256);
326     function approve(address spender, uint256 value) external returns (bool);
327     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
328     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
329     function maxScalingFactor() external view returns (uint256);
330 
331     /* - Governance Functions - */
332     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
333     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
334     function delegate(address delegatee) external;
335     function delegates(address delegator) external view returns (address);
336     function getCurrentVotes(address account) external view returns (uint256);
337 
338     /* - Permissioned/Governance functions - */
339     function mint(address to, uint256 amount) external returns (bool);
340     function rebase(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);
341     function _setRebaser(address rebaser_) external;
342     function _setIncentivizer(address incentivizer_) external;
343     function _setMinter(address minter_) external;
344     function _setPendingGov(address pendingGov_) external;
345     function _acceptGov() external;
346 }
347 
348 
349 contract DONDIGovernanceToken is DONDITokenInterface {
350 
351       /// @notice An event thats emitted when an account changes its delegate
352     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
353 
354     /// @notice An event thats emitted when a delegate account's vote balance changes
355     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
356 
357     /**
358      * @notice Delegate votes from `msg.sender` to `delegatee`
359      * @param delegator The address to get delegatee for
360      */
361     function delegates(address delegator)
362         external
363         view
364         returns (address)
365     {
366         return _delegates[delegator];
367     }
368 
369    /**
370     * @notice Delegate votes from `msg.sender` to `delegatee`
371     * @param delegatee The address to delegate votes to
372     */
373     function delegate(address delegatee) external {
374         return _delegate(msg.sender, delegatee);
375     }
376 
377     /**
378      * @notice Delegates votes from signatory to `delegatee`
379      * @param delegatee The address to delegate votes to
380      * @param nonce The contract state required to match the signature
381      * @param expiry The time at which to expire the signature
382      * @param v The recovery byte of the signature
383      * @param r Half of the ECDSA signature pair
384      * @param s Half of the ECDSA signature pair
385      */
386     function delegateBySig(
387         address delegatee,
388         uint nonce,
389         uint expiry,
390         uint8 v,
391         bytes32 r,
392         bytes32 s
393     )
394         external
395     {
396         bytes32 domainSeparator = keccak256(
397             abi.encode(
398                 DOMAIN_TYPEHASH,
399                 keccak256(bytes(name)),
400                 getChainId(),
401                 address(this)
402             )
403         );
404 
405         bytes32 structHash = keccak256(
406             abi.encode(
407                 DELEGATION_TYPEHASH,
408                 delegatee,
409                 nonce,
410                 expiry
411             )
412         );
413 
414         bytes32 digest = keccak256(
415             abi.encodePacked(
416                 "\x19\x01",
417                 domainSeparator,
418                 structHash
419             )
420         );
421 
422         address signatory = ecrecover(digest, v, r, s);
423         require(signatory != address(0), "DONDI::delegateBySig: invalid signature");
424         require(nonce == nonces[signatory]++, "DONDI::delegateBySig: invalid nonce");
425         require(now <= expiry, "DONDI::delegateBySig: signature expired");
426         return _delegate(signatory, delegatee);
427     }
428 
429     /**
430      * @notice Gets the current votes balance for `account`
431      * @param account The address to get votes balance
432      * @return The number of current votes for `account`
433      */
434     function getCurrentVotes(address account)
435         external
436         view
437         returns (uint256)
438     {
439         uint32 nCheckpoints = numCheckpoints[account];
440         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
441     }
442 
443     /**
444      * @notice Determine the prior number of votes for an account as of a block number
445      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
446      * @param account The address of the account to check
447      * @param blockNumber The block number to get the vote balance at
448      * @return The number of votes the account had as of the given block
449      */
450     function getPriorVotes(address account, uint blockNumber)
451         external
452         view
453         returns (uint256)
454     {
455         require(blockNumber < block.number, "DONDI::getPriorVotes: not yet determined");
456 
457         uint32 nCheckpoints = numCheckpoints[account];
458         if (nCheckpoints == 0) {
459             return 0;
460         }
461 
462         // First check most recent balance
463         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
464             return checkpoints[account][nCheckpoints - 1].votes;
465         }
466 
467         // Next check implicit zero balance
468         if (checkpoints[account][0].fromBlock > blockNumber) {
469             return 0;
470         }
471 
472         uint32 lower = 0;
473         uint32 upper = nCheckpoints - 1;
474         while (upper > lower) {
475             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
476             Checkpoint memory cp = checkpoints[account][center];
477             if (cp.fromBlock == blockNumber) {
478                 return cp.votes;
479             } else if (cp.fromBlock < blockNumber) {
480                 lower = center;
481             } else {
482                 upper = center - 1;
483             }
484         }
485         return checkpoints[account][lower].votes;
486     }
487 
488     function _delegate(address delegator, address delegatee)
489         internal
490     {
491         address currentDelegate = _delegates[delegator];
492         uint256 delegatorBalance = _dondiBalances[delegator]; // balance of underlying DONDIs (not scaled);
493         _delegates[delegator] = delegatee;
494 
495         emit DelegateChanged(delegator, currentDelegate, delegatee);
496 
497         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
498     }
499 
500     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
501         if (srcRep != dstRep && amount > 0) {
502             if (srcRep != address(0)) {
503                 // decrease old representative
504                 uint32 srcRepNum = numCheckpoints[srcRep];
505                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
506                 uint256 srcRepNew = srcRepOld.sub(amount);
507                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
508             }
509 
510             if (dstRep != address(0)) {
511                 // increase new representative
512                 uint32 dstRepNum = numCheckpoints[dstRep];
513                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
514                 uint256 dstRepNew = dstRepOld.add(amount);
515                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
516             }
517         }
518     }
519 
520     function _writeCheckpoint(
521         address delegatee,
522         uint32 nCheckpoints,
523         uint256 oldVotes,
524         uint256 newVotes
525     )
526         internal
527     {
528         uint32 blockNumber = safe32(block.number, "DONDI::_writeCheckpoint: block number exceeds 32 bits");
529 
530         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
531             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
532         } else {
533             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
534             numCheckpoints[delegatee] = nCheckpoints + 1;
535         }
536 
537         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
538     }
539 
540     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
541         require(n < 2**32, errorMessage);
542         return uint32(n);
543     }
544 
545     function getChainId() internal pure returns (uint) {
546         uint256 chainId;
547         assembly { chainId := chainid() }
548         return chainId;
549     }
550 }
551 
552 contract DONDIToken is DONDIGovernanceToken {
553     // Modifiers
554     modifier onlyGov() {
555         require(msg.sender == gov);
556         _;
557     }
558 
559     modifier onlyRebaser() {
560         require(msg.sender == rebaser);
561         _;
562     }
563 
564     modifier onlyMinter() {
565         require(msg.sender == rebaser || msg.sender == incentivizer || msg.sender == gov || minter[msg.sender] == true, "not minter");
566         _;
567     }
568 
569     modifier validRecipient(address to) {
570         require(to != address(0x0));
571         require(to != address(this));
572         _;
573     }
574 
575     function initialize(
576         string memory name_,
577         string memory symbol_,
578         uint8 decimals_
579     )
580         public
581     {
582         require(dondisScalingFactor == 0, "already initialized");
583         name = name_;
584         symbol = symbol_;
585         decimals = decimals_;
586     }
587 
588 
589     /**
590     * @notice Computes the current max scaling factor
591     */
592     function maxScalingFactor()
593         external
594         view
595         returns (uint256)
596     {
597         return _maxScalingFactor();
598     }
599 
600     function _maxScalingFactor()
601         internal
602         view
603         returns (uint256)
604     {
605         // scaling factor can only go up to 2**256-1 = initSupply * dondisScalingFactor
606         // this is used to check if dondisScalingFactor will be too high to compute balances when rebasing.
607         return uint256(-1) / initSupply;
608     }
609 
610     /**
611     * @notice Mints new tokens, increasing totalSupply, initSupply, and a users balance.
612     * @dev Limited to onlyMinter modifier
613     */
614     function mint(address to, uint256 amount)
615         external
616         onlyMinter
617         returns (bool)
618     {
619         _mint(to, amount);
620         return true;
621     }
622 
623     function _mint(address to, uint256 amount)
624         internal
625     {
626       // increase totalSupply
627       totalSupply = totalSupply.add(amount);
628 
629       // get underlying value
630       uint256 dondiValue = amount.mul(internalDecimals).div(dondisScalingFactor);
631 
632       // increase initSupply
633       initSupply = initSupply.add(dondiValue);
634 
635       // make sure the mint didnt push maxScalingFactor too low
636       require(dondisScalingFactor <= _maxScalingFactor(), "max scaling factor too low");
637 
638       // add balance
639       _dondiBalances[to] = _dondiBalances[to].add(dondiValue);
640 
641       // add delegates to the minter
642       _moveDelegates(address(0), _delegates[to], dondiValue);
643       emit Mint(to, amount);
644     }
645 
646     /* - ERC20 functionality - */
647 
648     /**
649     * @dev Transfer tokens to a specified address.
650     * @param to The address to transfer to.
651     * @param value The amount to be transferred.
652     * @return True on success, false otherwise.
653     */
654     function transfer(address to, uint256 value)
655         external
656         validRecipient(to)
657         returns (bool)
658     {
659         // underlying balance is stored in dondis, so divide by current scaling factor
660 
661         // note, this means as scaling factor grows, dust will be untransferrable.
662         // minimum transfer value == dondisScalingFactor / 1e24;
663 
664         // get amount in underlying
665         uint256 dondiValue = value.mul(internalDecimals).div(dondisScalingFactor);
666 
667         // sub from balance of sender
668         _dondiBalances[msg.sender] = _dondiBalances[msg.sender].sub(dondiValue);
669 
670         // add to balance of receiver
671         _dondiBalances[to] = _dondiBalances[to].add(dondiValue);
672         emit Transfer(msg.sender, to, value);
673 
674         _moveDelegates(_delegates[msg.sender], _delegates[to], dondiValue);
675         return true;
676     }
677 
678     /**
679     * @dev Transfer tokens from one address to another.
680     * @param from The address you want to send tokens from.
681     * @param to The address you want to transfer to.
682     * @param value The amount of tokens to be transferred.
683     */
684     function transferFrom(address from, address to, uint256 value)
685         external
686         validRecipient(to)
687         returns (bool)
688     {
689         // decrease allowance
690         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
691 
692         // get value in dondis
693         uint256 dondiValue = value.mul(internalDecimals).div(dondisScalingFactor);
694 
695         // sub from from
696         _dondiBalances[from] = _dondiBalances[from].sub(dondiValue);
697         _dondiBalances[to] = _dondiBalances[to].add(dondiValue);
698         emit Transfer(from, to, value);
699 
700         _moveDelegates(_delegates[from], _delegates[to], dondiValue);
701         return true;
702     }
703 
704     /**
705     * @param who The address to query.
706     * @return The balance of the specified address.
707     */
708     function balanceOf(address who)
709       external
710       view
711       returns (uint256)
712     {
713       return _dondiBalances[who].mul(dondisScalingFactor).div(internalDecimals);
714     }
715 
716     /** @notice Currently returns the internal storage amount
717     * @param who The address to query.
718     * @return The underlying balance of the specified address.
719     */
720     function balanceOfUnderlying(address who)
721       external
722       view
723       returns (uint256)
724     {
725       return _dondiBalances[who];
726     }
727 
728     /**
729      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
730      * @param owner_ The address which owns the funds.
731      * @param spender The address which will spend the funds.
732      * @return The number of tokens still available for the spender.
733      */
734     function allowance(address owner_, address spender)
735         external
736         view
737         returns (uint256)
738     {
739         return _allowedFragments[owner_][spender];
740     }
741 
742     /**
743      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
744      * msg.sender. This method is included for ERC20 compatibility.
745      * increaseAllowance and decreaseAllowance should be used instead.
746      * Changing an allowance with this method brings the risk that someone may transfer both
747      * the old and the new allowance - if they are both greater than zero - if a transfer
748      * transaction is mined before the later approve() call is mined.
749      *
750      * @param spender The address which will spend the funds.
751      * @param value The amount of tokens to be spent.
752      */
753     function approve(address spender, uint256 value)
754         external
755         returns (bool)
756     {
757         _allowedFragments[msg.sender][spender] = value;
758         emit Approval(msg.sender, spender, value);
759         return true;
760     }
761 
762     /**
763      * @dev Increase the amount of tokens that an owner has allowed to a spender.
764      * This method should be used instead of approve() to avoid the double approval vulnerability
765      * described above.
766      * @param spender The address which will spend the funds.
767      * @param addedValue The amount of tokens to increase the allowance by.
768      */
769     function increaseAllowance(address spender, uint256 addedValue)
770         external
771         returns (bool)
772     {
773         _allowedFragments[msg.sender][spender] =
774             _allowedFragments[msg.sender][spender].add(addedValue);
775         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
776         return true;
777     }
778 
779     /**
780      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
781      *
782      * @param spender The address which will spend the funds.
783      * @param subtractedValue The amount of tokens to decrease the allowance by.
784      */
785     function decreaseAllowance(address spender, uint256 subtractedValue)
786         external
787         returns (bool)
788     {
789         uint256 oldValue = _allowedFragments[msg.sender][spender];
790         if (subtractedValue >= oldValue) {
791             _allowedFragments[msg.sender][spender] = 0;
792         } else {
793             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
794         }
795         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
796         return true;
797     }
798 
799     /* - Governance Functions - */
800 
801     /** @notice sets the rebaser
802      * @param rebaser_ The address of the rebaser contract to use for authentication.
803      */
804     function _setRebaser(address rebaser_)
805         external
806         onlyGov
807     {
808         address oldRebaser = rebaser;
809         rebaser = rebaser_;
810         emit NewRebaser(oldRebaser, rebaser_);
811     }
812 
813     /** @notice sets the incentivizer
814      * @param incentivizer_ The address of the rebaser contract to use for authentication.
815      */
816     function _setIncentivizer(address incentivizer_)
817         external
818         onlyGov
819     {
820         address oldIncentivizer = incentivizer;
821         incentivizer = incentivizer_;
822         emit NewIncentivizer(oldIncentivizer, incentivizer_);
823     }
824 
825     function _setMinter(address minter_)
826         external
827         onlyGov
828     {
829         minter[minter_] = true;
830         emit NewMinter(minter_);
831     }
832 
833     function _removeMinter(address minter_)
834         external
835         onlyGov
836     {
837         minter[minter_] = false;
838         emit RemoveMinter(minter_);
839     }
840 
841     /** @notice sets the pendingGov
842      * @param pendingGov_ The address of the rebaser contract to use for authentication.
843      */
844     function _setPendingGov(address pendingGov_)
845         external
846         onlyGov
847     {
848         address oldPendingGov = pendingGov;
849         pendingGov = pendingGov_;
850         emit NewPendingGov(oldPendingGov, pendingGov_);
851     }
852 
853     /** @notice lets msg.sender accept governance
854      *
855      */
856     function _acceptGov()
857         external
858     {
859         require(msg.sender == pendingGov, "!pending");
860         address oldGov = gov;
861         gov = pendingGov;
862         pendingGov = address(0);
863         emit NewGov(oldGov, gov);
864     }
865 
866     /* - Extras - */
867 
868     /**
869     * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
870     *
871     * @dev The supply adjustment equals (totalSupply * DeviationFromTargetRate) / rebaseLag
872     *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
873     *      and targetRate is CpiOracleRate / baseCpi
874     */
875     function rebase(
876         uint256 epoch,
877         uint256 indexDelta,
878         bool positive
879     )
880         external
881         onlyRebaser
882         returns (uint256)
883     {
884         if (indexDelta == 0) {
885           emit Rebase(epoch, dondisScalingFactor, dondisScalingFactor);
886           return totalSupply;
887         }
888 
889         uint256 prevDondisScalingFactor = dondisScalingFactor;
890 
891         if (!positive) {
892            dondisScalingFactor = dondisScalingFactor.mul(BASE.sub(indexDelta)).div(BASE);
893         } else {
894             uint256 newScalingFactor = dondisScalingFactor.mul(BASE.add(indexDelta)).div(BASE);
895             if (newScalingFactor < _maxScalingFactor()) {
896                 dondisScalingFactor = newScalingFactor;
897             } else {
898               dondisScalingFactor = _maxScalingFactor();
899             }
900         }
901 
902         totalSupply = initSupply.mul(dondisScalingFactor);
903         emit Rebase(epoch, prevDondisScalingFactor, dondisScalingFactor);
904         return totalSupply;
905     }
906 }
907 
908 contract DONDI is DONDIToken {
909     /**
910      * @notice Initialize the new money market
911      * @param name_ ERC-20 name of this token
912      * @param symbol_ ERC-20 symbol of this token
913      * @param decimals_ ERC-20 decimal precision of this token
914      */
915     function initialize(
916         string memory name_,
917         string memory symbol_,
918         uint8 decimals_,
919         address initial_owner,
920         uint256 initSupply_
921     )
922         public
923     {
924         require(initSupply_ > 0, "0 init supply");
925 
926         super.initialize(name_, symbol_, decimals_);
927 
928         initSupply = initSupply_.mul(10**24/ (BASE));
929         totalSupply = initSupply_;
930         dondisScalingFactor = BASE;
931         _dondiBalances[initial_owner] = initSupply_.mul(10**24 / (BASE));
932 
933         // owner renounces ownership after deployment as they need to set
934         // rebaser and incentivizer
935         // gov = gov_;
936     }
937 }
938 
939 
940 contract DONDIDelegationStorage {
941     /**
942      * @notice Implementation address for this contract
943      */
944     address public implementation;
945 }
946 
947 contract DONDIDelegatorInterface is DONDIDelegationStorage {
948     /**
949      * @notice Emitted when implementation is changed
950      */
951     event NewImplementation(address oldImplementation, address newImplementation);
952 
953     /**
954      * @notice Called by the gov to update the implementation of the delegator
955      * @param implementation_ The address of the new implementation for delegation
956      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
957      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
958      */
959     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
960 }
961 
962 contract DONDIDelegateInterface is DONDIDelegationStorage {
963     /**
964      * @notice Called by the delegator on a delegate to initialize it for duty
965      * @dev Should revert if any issues arise which make it unfit for delegation
966      * @param data The encoded bytes data for any initialization
967      */
968     function _becomeImplementation(bytes memory data) public;
969 
970     /**
971      * @notice Called by the delegator on a delegate to forfeit its responsibility
972      */
973     function _resignImplementation() public;
974 }
975 
976 
977 contract DONDIDelegate is DONDI, DONDIDelegateInterface {
978     /**
979      * @notice Construct an empty delegate
980      */
981     constructor() public {}
982 
983     /**
984      * @notice Called by the delegator on a delegate to initialize it for duty
985      * @param data The encoded bytes data for any initialization
986      */
987     function _becomeImplementation(bytes memory data) public {
988         // Shh -- currently unused
989         data;
990 
991         // Shh -- we don't ever want this hook to be marked pure
992         if (false) {
993             implementation = address(0);
994         }
995 
996         require(msg.sender == gov, "only the gov may call _becomeImplementation");
997     }
998 
999     /**
1000      * @notice Called by the delegator on a delegate to forfeit its responsibility
1001      */
1002     function _resignImplementation() public {
1003         // Shh -- we don't ever want this hook to be marked pure
1004         if (false) {
1005             implementation = address(0);
1006         }
1007 
1008         require(msg.sender == gov, "only the gov may call _resignImplementation");
1009     }
1010 }
1011 
1012 contract DONDIDelegator is DONDITokenInterface, DONDIDelegatorInterface {
1013     /**
1014      * @notice Construct a new DONDI
1015      * @param name_ ERC-20 name of this token
1016      * @param symbol_ ERC-20 symbol of this token
1017      * @param decimals_ ERC-20 decimal precision of this token
1018      * @param initSupply_ Initial token amount
1019      * @param implementation_ The address of the implementation the contract delegates to
1020      * @param becomeImplementationData The encoded args for becomeImplementation
1021      */
1022     constructor(
1023         string memory name_,
1024         string memory symbol_,
1025         uint8 decimals_,
1026         uint256 initSupply_,
1027         address implementation_,
1028         bytes memory becomeImplementationData
1029     )
1030         public
1031     {
1032 
1033 
1034         // Creator of the contract is gov during initialization
1035         gov = msg.sender;
1036 
1037         // First delegate gets to initialize the delegator (i.e. storage contract)
1038         delegateTo(
1039             implementation_,
1040             abi.encodeWithSignature(
1041                 "initialize(string,string,uint8,address,uint256)",
1042                 name_,
1043                 symbol_,
1044                 decimals_,
1045                 msg.sender,
1046                 initSupply_
1047             )
1048         );
1049 
1050         // New implementations always get set via the settor (post-initialize)
1051         _setImplementation(implementation_, false, becomeImplementationData);
1052 
1053     }
1054 
1055     /**
1056      * @notice Called by the gov to update the implementation of the delegator
1057      * @param implementation_ The address of the new implementation for delegation
1058      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
1059      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
1060      */
1061     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
1062         require(msg.sender == gov, "DONDIDelegator::_setImplementation: Caller must be gov");
1063 
1064         if (allowResign) {
1065             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
1066         }
1067 
1068         address oldImplementation = implementation;
1069         implementation = implementation_;
1070 
1071         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
1072 
1073         emit NewImplementation(oldImplementation, implementation);
1074     }
1075 
1076     /**
1077      * @notice Sender supplies assets into the market and receives cTokens in exchange
1078      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1079      * @param mintAmount The amount of the underlying asset to supply
1080      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1081      */
1082     function mint(address to, uint256 mintAmount)
1083         external
1084         returns (bool)
1085     {
1086         to; mintAmount; // Shh
1087         delegateAndReturn();
1088     }
1089 
1090     /**
1091      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1092      * @param dst The address of the destination account
1093      * @param amount The number of tokens to transfer
1094      * @return Whether or not the transfer succeeded
1095      */
1096     function transfer(address dst, uint256 amount)
1097         external
1098         returns (bool)
1099     {
1100         dst; amount; // Shh
1101         delegateAndReturn();
1102     }
1103 
1104     /**
1105      * @notice Transfer `amount` tokens from `src` to `dst`
1106      * @param src The address of the source account
1107      * @param dst The address of the destination account
1108      * @param amount The number of tokens to transfer
1109      * @return Whether or not the transfer succeeded
1110      */
1111     function transferFrom(
1112         address src,
1113         address dst,
1114         uint256 amount
1115     )
1116         external
1117         returns (bool)
1118     {
1119         src; dst; amount; // Shh
1120         delegateAndReturn();
1121     }
1122 
1123     /**
1124      * @notice Approve `spender` to transfer up to `amount` from `src`
1125      * @dev This will overwrite the approval amount for `spender`
1126      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1127      * @param spender The address of the account which may transfer tokens
1128      * @param amount The number of tokens that are approved (-1 means infinite)
1129      * @return Whether or not the approval succeeded
1130      */
1131     function approve(
1132         address spender,
1133         uint256 amount
1134     )
1135         external
1136         returns (bool)
1137     {
1138         spender; amount; // Shh
1139         delegateAndReturn();
1140     }
1141 
1142     /**
1143      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1144      * This method should be used instead of approve() to avoid the double approval vulnerability
1145      * described above.
1146      * @param spender The address which will spend the funds.
1147      * @param addedValue The amount of tokens to increase the allowance by.
1148      */
1149     function increaseAllowance(
1150         address spender,
1151         uint256 addedValue
1152     )
1153         external
1154         returns (bool)
1155     {
1156         spender; addedValue; // Shh
1157         delegateAndReturn();
1158     }
1159 
1160     function maxScalingFactor()
1161         external
1162         view
1163         returns (uint256)
1164     {
1165         delegateToViewAndReturn();
1166     }
1167 
1168     function rebase(
1169         uint256 epoch,
1170         uint256 indexDelta,
1171         bool positive
1172     )
1173         external
1174         returns (uint256)
1175     {
1176         epoch; indexDelta; positive;
1177         delegateAndReturn();
1178     }
1179 
1180     /**
1181      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1182      *
1183      * @param spender The address which will spend the funds.
1184      * @param subtractedValue The amount of tokens to decrease the allowance by.
1185      */
1186     function decreaseAllowance(
1187         address spender,
1188         uint256 subtractedValue
1189     )
1190         external
1191         returns (bool)
1192     {
1193         spender; subtractedValue; // Shh
1194         delegateAndReturn();
1195     }
1196 
1197     /**
1198      * @notice Get the current allowance from `owner` for `spender`
1199      * @param owner The address of the account which owns the tokens to be spent
1200      * @param spender The address of the account which may transfer tokens
1201      * @return The number of tokens allowed to be spent (-1 means infinite)
1202      */
1203     function allowance(
1204         address owner,
1205         address spender
1206     )
1207         external
1208         view
1209         returns (uint256)
1210     {
1211         owner; spender; // Shh
1212         delegateToViewAndReturn();
1213     }
1214 
1215     /**
1216      * @notice Get the current allowance from `owner` for `spender`
1217      * @param delegator The address of the account which has designated a delegate
1218      * @return Address of delegatee
1219      */
1220     function delegates(
1221         address delegator
1222     )
1223         external
1224         view
1225         returns (address)
1226     {
1227         delegator; // Shh
1228         delegateToViewAndReturn();
1229     }
1230 
1231     /**
1232      * @notice Get the token balance of the `owner`
1233      * @param owner The address of the account to query
1234      * @return The number of tokens owned by `owner`
1235      */
1236     function balanceOf(address owner)
1237         external
1238         view
1239         returns (uint256)
1240     {
1241         owner; // Shh
1242         delegateToViewAndReturn();
1243     }
1244 
1245     /**
1246      * @notice Currently unused. For future compatability
1247      * @param owner The address of the account to query
1248      * @return The number of underlying tokens owned by `owner`
1249      */
1250     function balanceOfUnderlying(address owner)
1251         external
1252         view
1253         returns (uint256)
1254     {
1255         owner; // Shh
1256         delegateToViewAndReturn();
1257     }
1258 
1259     /*** Gov Functions ***/
1260 
1261     /**
1262       * @notice Begins transfer of gov rights. The newPendingGov must call `_acceptGov` to finalize the transfer.
1263       * @dev Gov function to begin change of gov. The newPendingGov must call `_acceptGov` to finalize the transfer.
1264       * @param newPendingGov New pending gov.
1265       */
1266     function _setPendingGov(address newPendingGov)
1267         external
1268     {
1269         newPendingGov; // Shh
1270         delegateAndReturn();
1271     }
1272 
1273     function _setRebaser(address rebaser_)
1274         external
1275     {
1276         rebaser_; // Shh
1277         delegateAndReturn();
1278     }
1279 
1280     function _setIncentivizer(address incentivizer_)
1281         external
1282     {
1283         incentivizer_; // Shh
1284         delegateAndReturn();
1285     }
1286 
1287     function _setMinter(address minter_)
1288         external
1289     {
1290         minter_;
1291         delegateAndReturn();
1292     }
1293 
1294     /**
1295       * @notice Accepts transfer of gov rights. msg.sender must be pendingGov
1296       * @dev Gov function for pending gov to accept role and update gov
1297       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1298       */
1299     function _acceptGov()
1300         external
1301     {
1302         delegateAndReturn();
1303     }
1304 
1305 
1306     function getPriorVotes(address account, uint blockNumber)
1307         external
1308         view
1309         returns (uint256)
1310     {
1311         account; blockNumber;
1312         delegateToViewAndReturn();
1313     }
1314 
1315     function delegateBySig(
1316         address delegatee,
1317         uint nonce,
1318         uint expiry,
1319         uint8 v,
1320         bytes32 r,
1321         bytes32 s
1322     )
1323         external
1324     {
1325         delegatee; nonce; expiry; v; r; s;
1326         delegateAndReturn();
1327     }
1328 
1329     function delegate(address delegatee)
1330         external
1331     {
1332         delegatee;
1333         delegateAndReturn();
1334     }
1335 
1336     function getCurrentVotes(address account)
1337         external
1338         view
1339         returns (uint256)
1340     {
1341         account;
1342         delegateToViewAndReturn();
1343     }
1344 
1345     /**
1346      * @notice Internal method to delegate execution to another contract
1347      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1348      * @param callee The contract to delegatecall
1349      * @param data The raw data to delegatecall
1350      * @return The returned bytes from the delegatecall
1351      */
1352     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
1353         (bool success, bytes memory returnData) = callee.delegatecall(data);
1354         assembly {
1355             if eq(success, 0) {
1356                 revert(add(returnData, 0x20), returndatasize)
1357             }
1358         }
1359         return returnData;
1360     }
1361 
1362     /**
1363      * @notice Delegates execution to the implementation contract
1364      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1365      * @param data The raw data to delegatecall
1366      * @return The returned bytes from the delegatecall
1367      */
1368     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
1369         return delegateTo(implementation, data);
1370     }
1371 
1372     /**
1373      * @notice Delegates execution to an implementation contract
1374      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1375      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
1376      * @param data The raw data to delegatecall
1377      * @return The returned bytes from the delegatecall
1378      */
1379     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
1380         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
1381         assembly {
1382             if eq(success, 0) {
1383                 revert(add(returnData, 0x20), returndatasize)
1384             }
1385         }
1386         return abi.decode(returnData, (bytes));
1387     }
1388 
1389     function delegateToViewAndReturn() private view returns (bytes memory) {
1390         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
1391 
1392         assembly {
1393             let free_mem_ptr := mload(0x40)
1394             returndatacopy(free_mem_ptr, 0, returndatasize)
1395 
1396             switch success
1397             case 0 { revert(free_mem_ptr, returndatasize) }
1398             default { return(add(free_mem_ptr, 0x40), returndatasize) }
1399         }
1400     }
1401 
1402     function delegateAndReturn() private returns (bytes memory) {
1403         (bool success, ) = implementation.delegatecall(msg.data);
1404 
1405         assembly {
1406             let free_mem_ptr := mload(0x40)
1407             returndatacopy(free_mem_ptr, 0, returndatasize)
1408 
1409             switch success
1410             case 0 { revert(free_mem_ptr, returndatasize) }
1411             default { return(free_mem_ptr, returndatasize) }
1412         }
1413     }
1414 
1415     /**
1416      * @notice Delegates execution to an implementation contract
1417      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1418      */
1419     function () external payable {
1420         require(msg.value == 0,"DONDIDelegator:fallback: cannot send value to fallback");
1421 
1422         // delegate all other functions to current implementation
1423         delegateAndReturn();
1424     }
1425 }