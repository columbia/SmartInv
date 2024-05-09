1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-19
3 */
4 
5 pragma solidity 0.5.17;
6 
7 
8 // SPDX-License-Identifier: MIT
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations with added overflow
11  * checks.
12  *
13  * Arithmetic operations in Solidity wrap on overflow. This can easily result
14  * in bugs, because programmers usually assume that an overflow raises an
15  * error, which is the standard behavior in high level programming languages.
16  * `SafeMath` restores this intuition by reverting the transaction when an
17  * operation overflows.
18  *
19  * Using this library instead of the unchecked operations eliminates an entire
20  * class of bugs, so it's recommended to use it always.
21  */
22 library SafeMath {
23     /**
24      * @dev Returns the addition of two unsigned integers, reverting on
25      * overflow.
26      *
27      * Counterpart to Solidity's `+` operator.
28      *
29      * Requirements:
30      *
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      *
48      * - Subtraction cannot overflow.
49      */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     /**
55      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
56      * overflow (when the result is negative).
57      *
58      * Counterpart to Solidity's `-` operator.
59      *
60      * Requirements:
61      *
62      * - Subtraction cannot overflow.
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      *
79      * - Multiplication cannot overflow.
80      */
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the integer division of two unsigned integers. Reverts on
97      * division by zero. The result is rounded towards zero.
98      *
99      * Counterpart to Solidity's `/` operator. Note: this function uses a
100      * `revert` opcode (which leaves remaining gas untouched) while Solidity
101      * uses an invalid opcode to revert (consuming all remaining gas).
102      *
103      * Requirements:
104      *
105      * - The divisor cannot be zero.
106      */
107     function div(uint256 a, uint256 b) internal pure returns (uint256) {
108         return div(a, b, "SafeMath: division by zero");
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts with custom message when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 // Storage for a StableDark token
166 contract StableDarkTokenStorage {
167 
168     using SafeMath for uint256;
169 
170     /**
171      * @dev Guard variable for re-entrancy checks. Not currently used
172      */
173     bool internal _notEntered;
174 
175     /**
176      * @notice EIP-20 token name for this token
177      */
178     string public name;
179 
180     /**
181      * @notice EIP-20 token symbol for this token
182      */
183     string public symbol;
184 
185     /**
186      * @notice EIP-20 token decimals for this token
187      */
188     uint8 public decimals;
189 
190     /**
191      * @notice Governor for this contract
192      */
193     address public gov;
194 
195     /**
196      * @notice Pending governance for this contract
197      */
198     address public pendingGov;
199 
200     /**
201      * @notice Approved rebaser for this contract
202      */
203     address public rebaser;
204 
205     /**
206      * @notice Reserve address of StableDark protocol
207      */
208     address public incentivizer;
209 
210     /**
211      * @notice Total supply of StableDarks
212      */
213     uint256 internal _totalSupply;
214 
215     /**
216      * @notice Internal decimals used to handle scaling factor
217      */
218     uint256 public constant internalDecimals = 10**24;
219 
220     /**
221      * @notice Used for percentage maths
222      */
223     uint256 public constant BASE = 10**18;
224 
225     /**
226      * @notice Scaling factor that adjusts everyone's balances
227      */
228     uint256 public stabledarksScalingFactor;
229 
230     mapping (address => uint256) internal _stabledarkBalances;
231 
232     mapping (address => mapping (address => uint256)) internal _allowedFragments;
233 
234     uint256 public initSupply;
235 
236 }
237 
238 contract StableDarkGovernanceStorage {
239     /// @notice A record of each accounts delegate
240     mapping (address => address) internal _delegates;
241 
242     /// @notice A checkpoint for marking number of votes from a given block
243     struct Checkpoint {
244         uint32 fromBlock;
245         uint256 votes;
246     }
247 
248     /// @notice A record of votes checkpoints for each account, by index
249     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
250 
251     /// @notice The number of checkpoints for each account
252     mapping (address => uint32) public numCheckpoints;
253 
254     /// @notice The EIP-712 typehash for the contract's domain
255     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
256 
257     /// @notice The EIP-712 typehash for the delegation struct used by the contract
258     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
259 
260     /// @notice A record of states for signing / validating signatures
261     mapping (address => uint) public nonces;
262 }
263 
264 contract StableDarkTokenInterface is StableDarkTokenStorage, StableDarkGovernanceStorage {
265 
266     /// @notice An event thats emitted when an account changes its delegate
267     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
268 
269     /// @notice An event thats emitted when a delegate account's vote balance changes
270     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
271 
272     /**
273      * @notice Event emitted when tokens are rebased
274      */
275     event Rebase(uint256 epoch, uint256 prevSdarksScalingFactor, uint256 newSdarksScalingFactor);
276 
277     /*** Gov Events ***/
278 
279     /**
280      * @notice Event emitted when pendingGov is changed
281      */
282     event NewPendingGov(address oldPendingGov, address newPendingGov);
283 
284     /**
285      * @notice Event emitted when gov is changed
286      */
287     event NewGov(address oldGov, address newGov);
288 
289     /**
290      * @notice Sets the rebaser contract
291      */
292     event NewRebaser(address oldRebaser, address newRebaser);
293 
294     /**
295      * @notice Sets the incentivizer contract
296      */
297     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
298 
299     /* - ERC20 Events - */
300 
301     /**
302      * @notice EIP20 Transfer event
303      */
304     event Transfer(address indexed from, address indexed to, uint amount);
305 
306     /**
307      * @notice EIP20 Approval event
308      */
309     event Approval(address indexed owner, address indexed spender, uint amount);
310 
311     /* - Extra Events - */
312     /**
313      * @notice Tokens minted event
314      */
315     event Mint(address to, uint256 amount);
316 
317     // Public functions
318     function totalSupply() external view returns (uint256);
319     function transfer(address to, uint256 value) external returns(bool);
320     function transferFrom(address from, address to, uint256 value) external returns(bool);
321     function balanceOf(address who) external view returns(uint256);
322     function balanceOfUnderlying(address who) external view returns(uint256);
323     function allowance(address owner_, address spender) external view returns(uint256);
324     function approve(address spender, uint256 value) external returns (bool);
325     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
326     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
327     function maxScalingFactor() external view returns (uint256);
328 
329     /* - Governance Functions - */
330     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
331     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
332     function delegate(address delegatee) external;
333     function delegates(address delegator) external view returns (address);
334     function getCurrentVotes(address account) external view returns (uint256);
335 
336     /* - Permissioned/Governance functions - */
337     function mint(address to, uint256 amount) external returns (bool);
338     function rebase(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);
339     function _setRebaser(address rebaser_) external;
340     function _setIncentivizer(address incentivizer_) external;
341     function _setPendingGov(address pendingGov_) external;
342     function _acceptGov() external;
343 }
344 
345 contract StableDarkGovernanceToken is StableDarkTokenInterface {
346 
347       /// @notice An event thats emitted when an account changes its delegate
348     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
349 
350     /// @notice An event thats emitted when a delegate account's vote balance changes
351     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
352 
353     /**
354      * @notice Delegate votes from `msg.sender` to `delegatee`
355      * @param delegator The address to get delegatee for
356      */
357     function delegates(address delegator)
358         external
359         view
360         returns (address)
361     {
362         return _delegates[delegator];
363     }
364 
365    /**
366     * @notice Delegate votes from `msg.sender` to `delegatee`
367     * @param delegatee The address to delegate votes to
368     */
369     function delegate(address delegatee) external {
370         return _delegate(msg.sender, delegatee);
371     }
372 
373     /**
374      * @notice Delegates votes from signatory to `delegatee`
375      * @param delegatee The address to delegate votes to
376      * @param nonce The contract state required to match the signature
377      * @param expiry The time at which to expire the signature
378      * @param v The recovery byte of the signature
379      * @param r Half of the ECDSA signature pair
380      * @param s Half of the ECDSA signature pair
381      */
382     function delegateBySig(
383         address delegatee,
384         uint nonce,
385         uint expiry,
386         uint8 v,
387         bytes32 r,
388         bytes32 s
389     )
390         external
391     {
392         bytes32 domainSeparator = keccak256(
393             abi.encode(
394                 DOMAIN_TYPEHASH,
395                 keccak256(bytes(name)),
396                 getChainId(),
397                 address(this)
398             )
399         );
400 
401         bytes32 structHash = keccak256(
402             abi.encode(
403                 DELEGATION_TYPEHASH,
404                 delegatee,
405                 nonce,
406                 expiry
407             )
408         );
409 
410         bytes32 digest = keccak256(
411             abi.encodePacked(
412                 "\x19\x01",
413                 domainSeparator,
414                 structHash
415             )
416         );
417 
418         address signatory = ecrecover(digest, v, r, s);
419         require(signatory != address(0), "StableDark::delegateBySig: invalid signature");
420         require(nonce == nonces[signatory]++, "StableDark::delegateBySig: invalid nonce");
421         require(now <= expiry, "StableDark::delegateBySig: signature expired");
422         return _delegate(signatory, delegatee);
423     }
424 
425     /**
426      * @notice Gets the current votes balance for `account`
427      * @param account The address to get votes balance
428      * @return The number of current votes for `account`
429      */
430     function getCurrentVotes(address account)
431         external
432         view
433         returns (uint256)
434     {
435         uint32 nCheckpoints = numCheckpoints[account];
436         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
437     }
438 
439     /**
440      * @notice Determine the prior number of votes for an account as of a block number
441      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
442      * @param account The address of the account to check
443      * @param blockNumber The block number to get the vote balance at
444      * @return The number of votes the account had as of the given block
445      */
446     function getPriorVotes(address account, uint blockNumber)
447         external
448         view
449         returns (uint256)
450     {
451         require(blockNumber < block.number, "StableDark::getPriorVotes: not yet determined");
452 
453         uint32 nCheckpoints = numCheckpoints[account];
454         if (nCheckpoints == 0) {
455             return 0;
456         }
457 
458         // First check most recent balance
459         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
460             return checkpoints[account][nCheckpoints - 1].votes;
461         }
462 
463         // Next check implicit zero balance
464         if (checkpoints[account][0].fromBlock > blockNumber) {
465             return 0;
466         }
467 
468         uint32 lower = 0;
469         uint32 upper = nCheckpoints - 1;
470         while (upper > lower) {
471             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
472             Checkpoint memory cp = checkpoints[account][center];
473             if (cp.fromBlock == blockNumber) {
474                 return cp.votes;
475             } else if (cp.fromBlock < blockNumber) {
476                 lower = center;
477             } else {
478                 upper = center - 1;
479             }
480         }
481         return checkpoints[account][lower].votes;
482     }
483 
484     function _delegate(address delegator, address delegatee)
485         internal
486     {
487         address currentDelegate = _delegates[delegator];
488         uint256 delegatorBalance = _stabledarkBalances[delegator]; // balance of underlying StableDarks (not scaled);
489         _delegates[delegator] = delegatee;
490 
491         emit DelegateChanged(delegator, currentDelegate, delegatee);
492 
493         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
494     }
495 
496     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
497         if (srcRep != dstRep && amount > 0) {
498             if (srcRep != address(0)) {
499                 // decrease old representative
500                 uint32 srcRepNum = numCheckpoints[srcRep];
501                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
502                 uint256 srcRepNew = srcRepOld.sub(amount);
503                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
504             }
505 
506             if (dstRep != address(0)) {
507                 // increase new representative
508                 uint32 dstRepNum = numCheckpoints[dstRep];
509                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
510                 uint256 dstRepNew = dstRepOld.add(amount);
511                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
512             }
513         }
514     }
515 
516     function _writeCheckpoint(
517         address delegatee,
518         uint32 nCheckpoints,
519         uint256 oldVotes,
520         uint256 newVotes
521     )
522         internal
523     {
524         uint32 blockNumber = safe32(block.number, "StableDark::_writeCheckpoint: block number exceeds 32 bits");
525 
526         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
527             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
528         } else {
529             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
530             numCheckpoints[delegatee] = nCheckpoints + 1;
531         }
532 
533         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
534     }
535 
536     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
537         require(n < 2**32, errorMessage);
538         return uint32(n);
539     }
540 
541     function getChainId() internal pure returns (uint) {
542         uint256 chainId;
543         assembly { chainId := chainid() }
544         return chainId;
545     }
546 }
547 
548 /* import "./StableDarkTokenInterface.sol"; */
549 contract StableDarkToken is StableDarkGovernanceToken {
550     // Modifiers
551     modifier onlyGov() {
552         require(msg.sender == gov);
553         _;
554     }
555 
556     modifier onlyRebaser() {
557         require(msg.sender == rebaser);
558         _;
559     }
560 
561     modifier onlyMinter() {
562         require(msg.sender == rebaser || msg.sender == incentivizer || msg.sender == gov, "not minter");
563         _;
564     }
565 
566     modifier validRecipient(address to) {
567         require(to != address(0x0));
568         require(to != address(this));
569         _;
570     }
571 
572     function initialize(
573         string memory name_,
574         string memory symbol_,
575         uint8 decimals_
576     )
577         public
578     {
579         require(stabledarksScalingFactor == 0, "already initialized");
580         name = name_;
581         symbol = symbol_;
582         decimals = decimals_;
583     }
584 
585     /**
586     * @notice Computes the current totalSupply
587     */
588     function totalSupply()
589         external
590         view
591         returns (uint256)
592     {
593         return _totalSupply.div(10**24/ (BASE));
594     }
595     
596     /**
597     * @notice Computes the current max scaling factor
598     */
599     function maxScalingFactor()
600         external
601         view
602         returns (uint256)
603     {
604         return _maxScalingFactor();
605     }
606 
607     function _maxScalingFactor()
608         internal
609         view
610         returns (uint256)
611     {
612         // scaling factor can only go up to 2**256-1 = initSupply * stabledarksScalingFactor
613         // this is used to check if stabledarksScalingFactor will be too high to compute balances when rebasing.
614         return uint256(-1) / initSupply;
615     }
616 
617     /**
618     * @notice Mints new tokens, increasing totalSupply, initSupply, and a users balance.
619     * @dev Limited to onlyMinter modifier
620     */
621     function mint(address to, uint256 amount)
622         external
623         onlyMinter
624         returns (bool)
625     {
626         _mint(to, amount);
627         return true;
628     }
629 
630     function _mint(address to, uint256 amount)
631         internal
632     {
633       // increase totalSupply
634       _totalSupply = _totalSupply.add(amount.mul(10**24/ (BASE)));
635 
636       // get underlying value
637       uint256 stabledarkValue = amount.mul(internalDecimals).div(stabledarksScalingFactor);
638 
639       // increase initSupply
640       initSupply = initSupply.add(stabledarkValue);
641 
642       // make sure the mint didnt push maxScalingFactor too low
643       require(stabledarksScalingFactor <= _maxScalingFactor(), "max scaling factor too low");
644 
645       // add balance
646       _stabledarkBalances[to] = _stabledarkBalances[to].add(stabledarkValue);
647       emit Transfer(address(0), to, amount);
648     
649       // add delegates to the minter
650       _moveDelegates(address(0), _delegates[to], stabledarkValue);
651       emit Mint(to, amount);
652     }
653 
654     /* - ERC20 functionality - */
655 
656     /**
657     * @dev Transfer tokens to a specified address.
658     * @param to The address to transfer to.
659     * @param value The amount to be transferred.
660     * @return True on success, false otherwise.
661     */
662     function transfer(address to, uint256 value)
663         external
664         validRecipient(to)
665         returns (bool)
666     {
667         // underlying balance is stored in stabledarks, so divide by current scaling factor
668 
669         // note, this means as scaling factor grows, dust will be untransferrable.
670         // minimum transfer value == stabledarksScalingFactor / 1e24;
671 
672         // get amount in underlying
673         uint256 stabledarkValue = value.mul(internalDecimals).div(stabledarksScalingFactor);
674 
675         // sub from balance of sender
676         _stabledarkBalances[msg.sender] = _stabledarkBalances[msg.sender].sub(stabledarkValue);
677 
678         // add to balance of receiver
679         _stabledarkBalances[to] = _stabledarkBalances[to].add(stabledarkValue);
680         emit Transfer(msg.sender, to, value);
681 
682         _moveDelegates(_delegates[msg.sender], _delegates[to], stabledarkValue);
683         return true;
684     }
685 
686     /**
687     * @dev Transfer tokens from one address to another.
688     * @param from The address you want to send tokens from.
689     * @param to The address you want to transfer to.
690     * @param value The amount of tokens to be transferred.
691     */
692     function transferFrom(address from, address to, uint256 value)
693         external
694         validRecipient(to)
695         returns (bool)
696     {
697         // decrease allowance
698         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
699 
700         // get value in stabledarks
701         uint256 stabledarkValue = value.mul(internalDecimals).div(stabledarksScalingFactor);
702 
703         // sub from from
704         _stabledarkBalances[from] = _stabledarkBalances[from].sub(stabledarkValue);
705         _stabledarkBalances[to] = _stabledarkBalances[to].add(stabledarkValue);
706         emit Transfer(from, to, value);
707 
708         _moveDelegates(_delegates[from], _delegates[to], stabledarkValue);
709         return true;
710     }
711 
712     /**
713     * @param who The address to query.
714     * @return The balance of the specified address.
715     */
716     function balanceOf(address who)
717       external
718       view
719       returns (uint256)
720     {
721       return _stabledarkBalances[who].mul(stabledarksScalingFactor).div(internalDecimals);
722     }
723 
724     /** @notice Currently returns the internal storage amount
725     * @param who The address to query.
726     * @return The underlying balance of the specified address.
727     */
728     function balanceOfUnderlying(address who)
729       external
730       view
731       returns (uint256)
732     {
733       return _stabledarkBalances[who];
734     }
735 
736     /**
737      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
738      * @param owner_ The address which owns the funds.
739      * @param spender The address which will spend the funds.
740      * @return The number of tokens still available for the spender.
741      */
742     function allowance(address owner_, address spender)
743         external
744         view
745         returns (uint256)
746     {
747         return _allowedFragments[owner_][spender];
748     }
749 
750     /**
751      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
752      * msg.sender. This method is included for ERC20 compatibility.
753      * increaseAllowance and decreaseAllowance should be used instead.
754      * Changing an allowance with this method brings the risk that someone may transfer both
755      * the old and the new allowance - if they are both greater than zero - if a transfer
756      * transaction is mined before the later approve() call is mined.
757      *
758      * @param spender The address which will spend the funds.
759      * @param value The amount of tokens to be spent.
760      */
761     function approve(address spender, uint256 value)
762         external
763         returns (bool)
764     {
765         _allowedFragments[msg.sender][spender] = value;
766         emit Approval(msg.sender, spender, value);
767         return true;
768     }
769 
770     /**
771      * @dev Increase the amount of tokens that an owner has allowed to a spender.
772      * This method should be used instead of approve() to avoid the double approval vulnerability
773      * described above.
774      * @param spender The address which will spend the funds.
775      * @param addedValue The amount of tokens to increase the allowance by.
776      */
777     function increaseAllowance(address spender, uint256 addedValue)
778         external
779         returns (bool)
780     {
781         _allowedFragments[msg.sender][spender] =
782             _allowedFragments[msg.sender][spender].add(addedValue);
783         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
784         return true;
785     }
786 
787     /**
788      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
789      *
790      * @param spender The address which will spend the funds.
791      * @param subtractedValue The amount of tokens to decrease the allowance by.
792      */
793     function decreaseAllowance(address spender, uint256 subtractedValue)
794         external
795         returns (bool)
796     {
797         uint256 oldValue = _allowedFragments[msg.sender][spender];
798         if (subtractedValue >= oldValue) {
799             _allowedFragments[msg.sender][spender] = 0;
800         } else {
801             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
802         }
803         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
804         return true;
805     }
806 
807     /* - Governance Functions - */
808 
809     /** @notice sets the rebaser
810      * @param rebaser_ The address of the rebaser contract to use for authentication.
811      */
812     function _setRebaser(address rebaser_)
813         external
814         onlyGov
815     {
816         address oldRebaser = rebaser;
817         rebaser = rebaser_;
818         emit NewRebaser(oldRebaser, rebaser_);
819     }
820 
821     /** @notice sets the incentivizer
822      * @param incentivizer_ The address of the rebaser contract to use for authentication.
823      */
824     function _setIncentivizer(address incentivizer_)
825         external
826         onlyGov
827     {
828         address oldIncentivizer = incentivizer;
829         incentivizer = incentivizer_;
830         emit NewIncentivizer(oldIncentivizer, incentivizer_);
831     }
832 
833     /** @notice sets the pendingGov
834      * @param pendingGov_ The address of the rebaser contract to use for authentication.
835      */
836     function _setPendingGov(address pendingGov_)
837         external
838         onlyGov
839     {
840         address oldPendingGov = pendingGov;
841         pendingGov = pendingGov_;
842         emit NewPendingGov(oldPendingGov, pendingGov_);
843     }
844 
845     /** @notice lets msg.sender accept governance
846      *
847      */
848     function _acceptGov()
849         external
850     {
851         require(msg.sender == pendingGov, "!pending");
852         address oldGov = gov;
853         gov = pendingGov;
854         pendingGov = address(0);
855         emit NewGov(oldGov, gov);
856     }
857 
858     /* - Extras - */
859 
860     /**
861     * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
862     *
863     * @dev The supply adjustment equals (totalSupply * DeviationFromTargetRate) / rebaseLag
864     *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
865     *      and targetRate is CpiOracleRate / baseCpi
866     */
867     function rebase(
868         uint256 epoch,
869         uint256 indexDelta,
870         bool positive
871     )
872         external
873         onlyRebaser
874         returns (uint256)
875     {
876         if (indexDelta == 0) {
877           emit Rebase(epoch, stabledarksScalingFactor, stabledarksScalingFactor);
878           return _totalSupply;
879         }
880 
881         uint256 prevSdarksScalingFactor = stabledarksScalingFactor;
882 
883         if (!positive) {
884            stabledarksScalingFactor = stabledarksScalingFactor.mul(BASE.sub(indexDelta)).div(BASE);
885         } else {
886             uint256 newScalingFactor = stabledarksScalingFactor.mul(BASE.add(indexDelta)).div(BASE);
887             if (newScalingFactor < _maxScalingFactor()) {
888                 stabledarksScalingFactor = newScalingFactor;
889             } else {
890               stabledarksScalingFactor = _maxScalingFactor();
891             }
892         }
893 
894         _totalSupply = initSupply.mul(stabledarksScalingFactor).div(BASE);
895         emit Rebase(epoch, prevSdarksScalingFactor, stabledarksScalingFactor);
896         return _totalSupply;
897     }
898 }
899 
900 contract StableDark is StableDarkToken {
901     /**
902      * @notice Initialize the new money market
903      * @param name_ ERC-20 name of this token
904      * @param symbol_ ERC-20 symbol of this token
905      * @param decimals_ ERC-20 decimal precision of this token
906      */
907     function initialize(
908         string memory name_,
909         string memory symbol_,
910         uint8 decimals_,
911         address initial_owner,
912         uint256 initSupply_
913     )
914         public
915     {
916         require(initSupply_ > 0, "0 init supply");
917 
918         super.initialize(name_, symbol_, decimals_);
919 
920         initSupply = initSupply_.mul(10**24/ (BASE));
921         _totalSupply = initSupply;
922         stabledarksScalingFactor = BASE;
923         _stabledarkBalances[initial_owner] = initSupply_.mul(10**24 / (BASE));
924 
925         // owner renounces ownership after deployment as they need to set
926         // rebaser and incentivizer
927         // gov = gov_;
928     }
929 }
930 
931 contract StableDarkDelegationStorage {
932     /**
933      * @notice Implementation address for this contract
934      */
935     address public implementation;
936 }
937 
938 contract StableDarkDelegatorInterface is StableDarkDelegationStorage {
939     /**
940      * @notice Emitted when implementation is changed
941      */
942     event NewImplementation(address oldImplementation, address newImplementation);
943 
944     /**
945      * @notice Called by the gov to update the implementation of the delegator
946      * @param implementation_ The address of the new implementation for delegation
947      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
948      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
949      */
950     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
951 }
952 
953 contract StableDarkDelegateInterface is StableDarkDelegationStorage {
954     /**
955      * @notice Called by the delegator on a delegate to initialize it for duty
956      * @dev Should revert if any issues arise which make it unfit for delegation
957      * @param data The encoded bytes data for any initialization
958      */
959     function _becomeImplementation(bytes memory data) public;
960 
961     /**
962      * @notice Called by the delegator on a delegate to forfeit its responsibility
963      */
964     function _resignImplementation() public;
965 }
966 
967 contract StableDarkDelegate is StableDark, StableDarkDelegateInterface {
968     /**
969      * @notice Construct an empty delegate
970      */
971     constructor() public {}
972 
973     /**
974      * @notice Called by the delegator on a delegate to initialize it for duty
975      * @param data The encoded bytes data for any initialization
976      */
977     function _becomeImplementation(bytes memory data) public {
978         // Shh -- currently unused
979         data;
980 
981         // Shh -- we don't ever want this hook to be marked pure
982         if (false) {
983             implementation = address(0);
984         }
985 
986         require(msg.sender == gov, "only the gov may call _becomeImplementation");
987     }
988 
989     /**
990      * @notice Called by the delegator on a delegate to forfeit its responsibility
991      */
992     function _resignImplementation() public {
993         // Shh -- we don't ever want this hook to be marked pure
994         if (false) {
995             implementation = address(0);
996         }
997 
998         require(msg.sender == gov, "only the gov may call _resignImplementation");
999     }
1000 }
1001 
1002 contract StableDarkDelegator is StableDarkTokenInterface, StableDarkDelegatorInterface {
1003     /**
1004      * @notice Construct a new StableDark
1005      * @param name_ ERC-20 name of this token
1006      * @param symbol_ ERC-20 symbol of this token
1007      * @param decimals_ ERC-20 decimal precision of this token
1008      * @param initSupply_ Initial token amount
1009      * @param implementation_ The address of the implementation the contract delegates to
1010      * @param becomeImplementationData The encoded args for becomeImplementation
1011      */
1012     constructor(
1013         string memory name_,
1014         string memory symbol_,
1015         uint8 decimals_,
1016         uint256 initSupply_,
1017         address implementation_,
1018         bytes memory becomeImplementationData
1019     )
1020         public
1021     {
1022 
1023 
1024         // Creator of the contract is gov during initialization
1025         gov = msg.sender;
1026 
1027         // First delegate gets to initialize the delegator (i.e. storage contract)
1028         delegateTo(
1029             implementation_,
1030             abi.encodeWithSignature(
1031                 "initialize(string,string,uint8,address,uint256)",
1032                 name_,
1033                 symbol_,
1034                 decimals_,
1035                 msg.sender,
1036                 initSupply_
1037             )
1038         );
1039 
1040         // New implementations always get set via the settor (post-initialize)
1041         _setImplementation(implementation_, false, becomeImplementationData);
1042 
1043     }
1044 
1045     /**
1046      * @notice Called by the gov to update the implementation of the delegator
1047      * @param implementation_ The address of the new implementation for delegation
1048      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
1049      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
1050      */
1051     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
1052         require(msg.sender == gov, "StableDarkDelegator::_setImplementation: Caller must be gov");
1053 
1054         if (allowResign) {
1055             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
1056         }
1057 
1058         address oldImplementation = implementation;
1059         implementation = implementation_;
1060 
1061         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
1062 
1063         emit NewImplementation(oldImplementation, implementation);
1064     }
1065 
1066     /**
1067      * @notice Sender supplies assets into the market and receives cTokens in exchange
1068      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1069      * @param mintAmount The amount of the underlying asset to supply
1070      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1071      */
1072     function mint(address to, uint256 mintAmount)
1073         external
1074         returns (bool)
1075     {
1076         to; mintAmount; // Shh
1077         delegateAndReturn();
1078     }
1079 
1080     /**
1081      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1082      * @param dst The address of the destination account
1083      * @param amount The number of tokens to transfer
1084      * @return Whether or not the transfer succeeded
1085      */
1086     function transfer(address dst, uint256 amount)
1087         external
1088         returns (bool)
1089     {
1090         dst; amount; // Shh
1091         delegateAndReturn();
1092     }
1093 
1094     /**
1095      * @notice Transfer `amount` tokens from `src` to `dst`
1096      * @param src The address of the source account
1097      * @param dst The address of the destination account
1098      * @param amount The number of tokens to transfer
1099      * @return Whether or not the transfer succeeded
1100      */
1101     function transferFrom(
1102         address src,
1103         address dst,
1104         uint256 amount
1105     )
1106         external
1107         returns (bool)
1108     {
1109         src; dst; amount; // Shh
1110         delegateAndReturn();
1111     }
1112 
1113     /**
1114      * @notice Approve `spender` to transfer up to `amount` from `src`
1115      * @dev This will overwrite the approval amount for `spender`
1116      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1117      * @param spender The address of the account which may transfer tokens
1118      * @param amount The number of tokens that are approved (-1 means infinite)
1119      * @return Whether or not the approval succeeded
1120      */
1121     function approve(
1122         address spender,
1123         uint256 amount
1124     )
1125         external
1126         returns (bool)
1127     {
1128         spender; amount; // Shh
1129         delegateAndReturn();
1130     }
1131 
1132     /**
1133      * @dev Increase the amount of tokens that an owner has allowed to a spender.
1134      * This method should be used instead of approve() to avoid the double approval vulnerability
1135      * described above.
1136      * @param spender The address which will spend the funds.
1137      * @param addedValue The amount of tokens to increase the allowance by.
1138      */
1139     function increaseAllowance(
1140         address spender,
1141         uint256 addedValue
1142     )
1143         external
1144         returns (bool)
1145     {
1146         spender; addedValue; // Shh
1147         delegateAndReturn();
1148     }
1149 
1150     function totalSupply()
1151         external
1152         view
1153         returns (uint256)
1154     {
1155         delegateToViewAndReturn();
1156     }
1157 
1158     function maxScalingFactor()
1159         external
1160         view
1161         returns (uint256)
1162     {
1163         delegateToViewAndReturn();
1164     }
1165 
1166     function rebase(
1167         uint256 epoch,
1168         uint256 indexDelta,
1169         bool positive
1170     )
1171         external
1172         returns (uint256)
1173     {
1174         epoch; indexDelta; positive;
1175         delegateAndReturn();
1176     }
1177 
1178     /**
1179      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
1180      *
1181      * @param spender The address which will spend the funds.
1182      * @param subtractedValue The amount of tokens to decrease the allowance by.
1183      */
1184     function decreaseAllowance(
1185         address spender,
1186         uint256 subtractedValue
1187     )
1188         external
1189         returns (bool)
1190     {
1191         spender; subtractedValue; // Shh
1192         delegateAndReturn();
1193     }
1194 
1195     /**
1196      * @notice Get the current allowance from `owner` for `spender`
1197      * @param owner The address of the account which owns the tokens to be spent
1198      * @param spender The address of the account which may transfer tokens
1199      * @return The number of tokens allowed to be spent (-1 means infinite)
1200      */
1201     function allowance(
1202         address owner,
1203         address spender
1204     )
1205         external
1206         view
1207         returns (uint256)
1208     {
1209         owner; spender; // Shh
1210         delegateToViewAndReturn();
1211     }
1212 
1213     /**
1214      * @notice Get the current allowance from `owner` for `spender`
1215      * @param delegator The address of the account which has designated a delegate
1216      * @return Address of delegatee
1217      */
1218     function delegates(
1219         address delegator
1220     )
1221         external
1222         view
1223         returns (address)
1224     {
1225         delegator; // Shh
1226         delegateToViewAndReturn();
1227     }
1228 
1229     /**
1230      * @notice Get the token balance of the `owner`
1231      * @param owner The address of the account to query
1232      * @return The number of tokens owned by `owner`
1233      */
1234     function balanceOf(address owner)
1235         external
1236         view
1237         returns (uint256)
1238     {
1239         owner; // Shh
1240         delegateToViewAndReturn();
1241     }
1242 
1243     /**
1244      * @notice Currently unused. For future compatability
1245      * @param owner The address of the account to query
1246      * @return The number of underlying tokens owned by `owner`
1247      */
1248     function balanceOfUnderlying(address owner)
1249         external
1250         view
1251         returns (uint256)
1252     {
1253         owner; // Shh
1254         delegateToViewAndReturn();
1255     }
1256 
1257     /*** Gov Functions ***/
1258 
1259     /**
1260       * @notice Begins transfer of gov rights. The newPendingGov must call `_acceptGov` to finalize the transfer.
1261       * @dev Gov function to begin change of gov. The newPendingGov must call `_acceptGov` to finalize the transfer.
1262       * @param newPendingGov New pending gov.
1263       */
1264     function _setPendingGov(address newPendingGov)
1265         external
1266     {
1267         newPendingGov; // Shh
1268         delegateAndReturn();
1269     }
1270 
1271     function _setRebaser(address rebaser_)
1272         external
1273     {
1274         rebaser_; // Shh
1275         delegateAndReturn();
1276     }
1277 
1278     function _setIncentivizer(address incentivizer_)
1279         external
1280     {
1281         incentivizer_; // Shh
1282         delegateAndReturn();
1283     }
1284 
1285     /**
1286       * @notice Accepts transfer of gov rights. msg.sender must be pendingGov
1287       * @dev Gov function for pending gov to accept role and update gov
1288       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1289       */
1290     function _acceptGov()
1291         external
1292     {
1293         delegateAndReturn();
1294     }
1295 
1296 
1297     function getPriorVotes(address account, uint blockNumber)
1298         external
1299         view
1300         returns (uint256)
1301     {
1302         account; blockNumber;
1303         delegateToViewAndReturn();
1304     }
1305 
1306     function delegateBySig(
1307         address delegatee,
1308         uint nonce,
1309         uint expiry,
1310         uint8 v,
1311         bytes32 r,
1312         bytes32 s
1313     )
1314         external
1315     {
1316         delegatee; nonce; expiry; v; r; s;
1317         delegateAndReturn();
1318     }
1319 
1320     function delegate(address delegatee)
1321         external
1322     {
1323         delegatee;
1324         delegateAndReturn();
1325     }
1326 
1327     function getCurrentVotes(address account)
1328         external
1329         view
1330         returns (uint256)
1331     {
1332         account;
1333         delegateToViewAndReturn();
1334     }
1335 
1336     /**
1337      * @notice Internal method to delegate execution to another contract
1338      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1339      * @param callee The contract to delegatecall
1340      * @param data The raw data to delegatecall
1341      * @return The returned bytes from the delegatecall
1342      */
1343     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
1344         (bool success, bytes memory returnData) = callee.delegatecall(data);
1345         assembly {
1346             if eq(success, 0) {
1347                 revert(add(returnData, 0x20), returndatasize)
1348             }
1349         }
1350         return returnData;
1351     }
1352 
1353     /**
1354      * @notice Delegates execution to the implementation contract
1355      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1356      * @param data The raw data to delegatecall
1357      * @return The returned bytes from the delegatecall
1358      */
1359     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
1360         return delegateTo(implementation, data);
1361     }
1362 
1363     /**
1364      * @notice Delegates execution to an implementation contract
1365      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1366      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
1367      * @param data The raw data to delegatecall
1368      * @return The returned bytes from the delegatecall
1369      */
1370     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
1371         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
1372         assembly {
1373             if eq(success, 0) {
1374                 revert(add(returnData, 0x20), returndatasize)
1375             }
1376         }
1377         return abi.decode(returnData, (bytes));
1378     }
1379 
1380     function delegateToViewAndReturn() private view returns (bytes memory) {
1381         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
1382 
1383         assembly {
1384             let free_mem_ptr := mload(0x40)
1385             returndatacopy(free_mem_ptr, 0, returndatasize)
1386 
1387             switch success
1388             case 0 { revert(free_mem_ptr, returndatasize) }
1389             default { return(add(free_mem_ptr, 0x40), returndatasize) }
1390         }
1391     }
1392 
1393     function delegateAndReturn() private returns (bytes memory) {
1394         (bool success, ) = implementation.delegatecall(msg.data);
1395 
1396         assembly {
1397             let free_mem_ptr := mload(0x40)
1398             returndatacopy(free_mem_ptr, 0, returndatasize)
1399 
1400             switch success
1401             case 0 { revert(free_mem_ptr, returndatasize) }
1402             default { return(free_mem_ptr, returndatasize) }
1403         }
1404     }
1405 
1406     /**
1407      * @notice Delegates execution to an implementation contract
1408      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
1409      */
1410     function () external payable {
1411         require(msg.value == 0,"StableDarkDelegator:fallback: cannot send value to fallback");
1412 
1413         // delegate all other functions to current implementation
1414         delegateAndReturn();
1415     }
1416 }