1 /**
2  * SPDX-License-Identifier: UNLICENSED
3  */
4 pragma solidity 0.8.11;
5 
6 library SafeMath {
7     /**
8      * @dev Returns the addition of two unsigned integers, with an overflow flag.
9      *
10      * _Available since v3.4._
11      */
12     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
13         unchecked {
14             uint256 c = a + b;
15             if (c < a) return (false, 0);
16             return (true, c);
17         }
18     }
19 
20     /**
21      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             if (b > a) return (false, 0);
28             return (true, a - b);
29         }
30     }
31 
32     /**
33      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40             // benefit is lost if 'b' is also tested.
41             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
42             if (a == 0) return (true, 0);
43             uint256 c = a * b;
44             if (c / a != b) return (false, 0);
45             return (true, c);
46         }
47     }
48 
49     /**
50      * @dev Returns the division of two unsigned integers, with a division by zero flag.
51      *
52      * _Available since v3.4._
53      */
54     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55         unchecked {
56             if (b == 0) return (false, 0);
57             return (true, a / b);
58         }
59     }
60 
61     /**
62      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a % b);
70         }
71     }
72 
73     /**
74      * @dev Returns the addition of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `+` operator.
78      *
79      * Requirements:
80      *
81      * - Addition cannot overflow.
82      */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         return a + b;
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      *
95      * - Subtraction cannot overflow.
96      */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a - b;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `*` operator.
106      *
107      * Requirements:
108      *
109      * - Multiplication cannot overflow.
110      */
111     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a * b;
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers, reverting on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator.
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a / b;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * reverting when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return a % b;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * CAUTION: This function is deprecated because it requires allocating memory for the error
150      * message unnecessarily. For custom revert reasons use {trySub}.
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(
159         uint256 a,
160         uint256 b,
161         string memory errorMessage
162     ) internal pure returns (uint256) {
163         unchecked {
164             require(b <= a, errorMessage);
165             return a - b;
166         }
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(
182         uint256 a,
183         uint256 b,
184         string memory errorMessage
185     ) internal pure returns (uint256) {
186         unchecked {
187             require(b > 0, errorMessage);
188             return a / b;
189         }
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
194      * reverting with custom message when dividing by zero.
195      *
196      * CAUTION: This function is deprecated because it requires allocating memory for the error
197      * message unnecessarily. For custom revert reasons use {tryMod}.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a % b;
215         }
216     }
217 }
218 
219 contract HFT {
220     /// @notice EIP-20 token name for this token
221     string public constant name = 'Hashflow';
222 
223     /// @notice EIP-20 token symbol for this token
224     string public constant symbol = 'HFT';
225 
226     /// @notice EIP-20 token decimals for this token
227     uint8 public constant decimals = 18;
228 
229     /// @notice Total number of tokens in circulation
230     uint256 public totalSupply = 1_000_000_000e18; // 1 billion HFT
231 
232     /// @notice Address which may mint new tokens
233     address public minter;
234 
235     /// @notice The timestamp after which minting may occur (must be set to 4 years)
236     uint256 public mintingAllowedAfter;
237 
238     /// @notice Minimum time between mints
239     uint32 public constant minimumTimeBetweenMints = 1 days * 365;
240 
241     /// @notice Cap on the percentage of totalSupply that can be minted at each mint (set to 5% inflation currently)
242     uint8 public mintCap = 5;
243 
244     /// @notice Allowance amounts on behalf of others
245     mapping(address => mapping(address => uint96)) internal allowances;
246 
247     /// @notice Official record of token balances for each account
248     mapping(address => uint96) internal balances;
249 
250     /// @notice A record of each accounts delegate
251     mapping(address => address) public delegates;
252 
253     /// @notice A checkpoint for marking number of votes from a given block
254     struct Checkpoint {
255         uint32 fromBlock;
256         uint96 votes;
257     }
258 
259     /// @notice A record of votes checkpoints for each account, by index
260     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
261 
262     /// @notice The number of checkpoints for each account
263     mapping(address => uint32) public numCheckpoints;
264 
265     /// @notice The EIP-712 typehash for the contract's domain
266     bytes32 public constant DOMAIN_TYPEHASH =
267         keccak256(
268             'EIP712Domain(string name,uint256 chainId,address verifyingContract)'
269         );
270 
271     /// @notice The EIP-712 typehash for the delegation struct used by the contract
272     bytes32 public constant DELEGATION_TYPEHASH =
273         keccak256('Delegation(address delegatee,uint256 nonce,uint256 expiry)');
274 
275     /// @notice The EIP-712 typehash for the permit struct used by the contract
276     bytes32 public constant PERMIT_TYPEHASH =
277         keccak256(
278             'Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)'
279         );
280 
281     /// @notice A record of states for signing / validating signatures
282     mapping(address => uint256) public nonces;
283 
284     /// @notice An event that is emitted when the minter address is changed
285     event MinterChanged(address minter, address newMinter);
286 
287     /// @notice An event that is emitted when the mint percentage is changed
288     event MintCapChanged(uint256 newMintCap);
289 
290     /// @notice An event thats emitted when an account changes its delegate
291     event DelegateChanged(
292         address indexed delegator,
293         address indexed fromDelegate,
294         address indexed toDelegate
295     );
296 
297     /// @notice An event thats emitted when a delegate account's vote balance changes
298     event DelegateVotesChanged(
299         address indexed delegate,
300         uint256 previousBalance,
301         uint256 newBalance
302     );
303 
304     /// @notice The standard EIP-20 transfer event
305     event Transfer(address indexed from, address indexed to, uint256 amount);
306 
307     /// @notice The standard EIP-20 approval event
308     event Approval(
309         address indexed owner,
310         address indexed spender,
311         uint256 amount
312     );
313 
314     /**
315      * @notice Construct a new Hashflow token
316      * @param account The initial account to grant all the tokens
317      * @param minter_ The account with minting ability
318      * @param mintingAllowedAfter_ The timestamp after which minting may occur
319      */
320     constructor(
321         address account,
322         address minter_,
323         uint256 mintingAllowedAfter_
324     ) {
325         require(
326             mintingAllowedAfter_ >= block.timestamp + 1460 days,
327             'HFT::constructor: minting can only begin after 4 years'
328         );
329 
330         require(
331             minter_ != address(0),
332             'HFT::constructor: minter_ cannot be zero address'
333         );
334 
335         require(
336             account != address(0),
337             'HFT::constructor: account cannot be zero address'
338         );
339 
340         balances[account] = uint96(totalSupply);
341         emit Transfer(address(0), account, totalSupply);
342         minter = minter_;
343         emit MinterChanged(address(0), minter);
344         mintingAllowedAfter = mintingAllowedAfter_;
345     }
346 
347     /**
348      * @notice Change the minter address
349      * @param minter_ The address of the new minter
350      */
351     function setMinter(address minter_) external {
352         require(
353             minter_ != address(0),
354             'HFT::setMinter: minter_ cannot be zero address'
355         );
356         require(
357             msg.sender == minter,
358             'HFT::setMinter: only the minter can change the minter address'
359         );
360         minter = minter_;
361         emit MinterChanged(minter, minter_);
362     }
363 
364     function setMintCap(uint256 mintCap_) external {
365         require(
366             msg.sender == minter,
367             'HFT::setMintCap: only the minter can change the mint cap'
368         );
369         require(
370             mintCap_ <= 100,
371             'HFT::setMintCap: mint cap should be between 0 and 100'
372         );
373         mintCap = uint8(mintCap_);
374         emit MintCapChanged(uint256(mintCap));
375     }
376 
377     /**
378      * @notice Mint new tokens
379      * @param dst The address of the destination account
380 
381      */
382     function mint(address dst) external {
383         require(msg.sender == minter, 'HFT::mint: only the minter can mint');
384         require(
385             block.timestamp >= mintingAllowedAfter,
386             'HFT::mint: minting not allowed yet or exceeds mint cap'
387         );
388         require(
389             dst != address(0),
390             'HFT::mint: cannot transfer to the zero address'
391         );
392 
393         // record the mint
394         mintingAllowedAfter = SafeMath.add(
395             block.timestamp,
396             minimumTimeBetweenMints
397         );
398 
399         uint96 amount = safe96(
400             SafeMath.div(SafeMath.mul(totalSupply, uint256(mintCap)), 100),
401             'HFT::mint: amount exceeds 96 bits'
402         );
403 
404         totalSupply = safe96(
405             SafeMath.add(totalSupply, amount),
406             'HFT::mint: totalSupply exceeds 96 bits'
407         );
408 
409         // transfer the amount to the recipient
410         balances[dst] = add96(
411             balances[dst],
412             amount,
413             'HFT::mint: transfer amount overflows'
414         );
415         emit Transfer(address(0), dst, amount);
416 
417         // move delegates
418         _moveDelegates(address(0), delegates[dst], amount);
419     }
420 
421     /**
422      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
423      * @param account The address of the account holding the funds
424      * @param spender The address of the account spending the funds
425      * @return The number of tokens approved
426      */
427     function allowance(address account, address spender)
428         external
429         view
430         returns (uint256)
431     {
432         return allowances[account][spender];
433     }
434 
435     /**
436      * @notice Approve `spender` to transfer up to `amount` from `src`
437      * @dev This will overwrite the approval amount for `spender`
438      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
439      * @param spender The address of the account which may transfer tokens
440      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
441      * @return Whether or not the approval succeeded
442      */
443     function approve(address spender, uint256 rawAmount)
444         external
445         returns (bool)
446     {
447         _approve(msg.sender, spender, rawAmount);
448         return true;
449     }
450 
451     /**
452      * @notice Atomically increases the allowance granted to `spender` by the caller.
453      * @dev This is an alternative to {approve} that can be used as a mitigation for
454      * problems described in {IERC20-approve}.
455      * @param spender The address of the account which may transfer tokens
456      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
457      * @return Whether or not the approval succeeded
458      */
459     function increaseAllowance(address spender, uint256 rawAmount)
460         external
461         returns (bool)
462     {
463         _approve(
464             msg.sender,
465             spender,
466             allowances[msg.sender][spender] + rawAmount
467         );
468         return true;
469     }
470 
471     /**
472      * @notice Atomically increases the allowance granted to `spender` by the caller.
473      * @dev This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      * @param spender The address of the account which may transfer tokens
476      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
477      * @return Whether or not the approval succeeded
478      */
479     function decreaseAllowance(address spender, uint256 rawAmount)
480         external
481         returns (bool)
482     {
483         _approve(
484             msg.sender,
485             spender,
486             allowances[msg.sender][spender] - rawAmount
487         );
488         return true;
489     }
490 
491     /**
492      * @notice Triggers an approval from owner to spends
493      * @param owner The address to approve from
494      * @param spender The address to be approved
495      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
496      * @param deadline The time at which to expire the signature
497      * @param v The recovery byte of the signature
498      * @param r Half of the ECDSA signature pair
499      * @param s Half of the ECDSA signature pair
500      */
501     function permit(
502         address owner,
503         address spender,
504         uint256 rawAmount,
505         uint256 deadline,
506         uint8 v,
507         bytes32 r,
508         bytes32 s
509     ) external {
510         uint96 amount;
511         if (rawAmount == type(uint256).max) {
512             amount = type(uint96).max;
513         } else {
514             amount = safe96(rawAmount, 'HFT::permit: amount exceeds 96 bits');
515         }
516 
517         bytes32 domainSeparator = keccak256(
518             abi.encode(
519                 DOMAIN_TYPEHASH,
520                 keccak256(bytes(name)),
521                 getChainId(),
522                 address(this)
523             )
524         );
525         bytes32 structHash = keccak256(
526             abi.encode(
527                 PERMIT_TYPEHASH,
528                 owner,
529                 spender,
530                 rawAmount,
531                 nonces[owner]++,
532                 deadline
533             )
534         );
535         bytes32 digest = keccak256(
536             abi.encodePacked('\x19\x01', domainSeparator, structHash)
537         );
538         address signatory = ecrecover(digest, v, r, s);
539         require(signatory != address(0), 'HFT::permit: invalid signature');
540         require(signatory == owner, 'HFT::permit: unauthorized');
541         require(block.timestamp <= deadline, 'HFT::permit: signature expired');
542 
543         allowances[owner][spender] = amount;
544 
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @notice Get the number of tokens held by the `account`
550      * @param account The address of the account to get the balance of
551      * @return The number of tokens held
552      */
553     function balanceOf(address account) external view returns (uint256) {
554         return balances[account];
555     }
556 
557     /**
558      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
559      * @param dst The address of the destination account
560      * @param rawAmount The number of tokens to transfer
561      * @return Whether or not the transfer succeeded
562      */
563     function transfer(address dst, uint256 rawAmount) external returns (bool) {
564         uint96 amount = safe96(
565             rawAmount,
566             'HFT::transfer: amount exceeds 96 bits'
567         );
568         _transferTokens(msg.sender, dst, amount);
569         return true;
570     }
571 
572     /**
573      * @notice Transfer `amount` tokens from `src` to `dst`
574      * @param src The address of the source account
575      * @param dst The address of the destination account
576      * @param rawAmount The number of tokens to transfer
577      * @return Whether or not the transfer succeeded
578      */
579     function transferFrom(
580         address src,
581         address dst,
582         uint256 rawAmount
583     ) external returns (bool) {
584         address spender = msg.sender;
585         uint96 spenderAllowance = allowances[src][spender];
586         uint96 amount = safe96(
587             rawAmount,
588             'HFT::approve: amount exceeds 96 bits'
589         );
590 
591         if (spender != src && spenderAllowance != type(uint96).max) {
592             uint96 newAllowance = sub96(
593                 spenderAllowance,
594                 amount,
595                 'HFT::transferFrom: transfer amount exceeds spender allowance'
596             );
597             allowances[src][spender] = newAllowance;
598 
599             emit Approval(src, spender, newAllowance);
600         }
601 
602         _transferTokens(src, dst, amount);
603         return true;
604     }
605 
606     /**
607      * @notice Delegate votes from `msg.sender` to `delegatee`
608      * @param delegatee The address to delegate votes to
609      */
610     function delegate(address delegatee) public {
611         return _delegate(msg.sender, delegatee);
612     }
613 
614     /**
615      * @notice Delegates votes from signatory to `delegatee`
616      * @param delegatee The address to delegate votes to
617      * @param nonce The contract state required to match the signature
618      * @param expiry The time at which to expire the signature
619      * @param v The recovery byte of the signature
620      * @param r Half of the ECDSA signature pair
621      * @param s Half of the ECDSA signature pair
622      */
623     function delegateBySig(
624         address delegatee,
625         uint256 nonce,
626         uint256 expiry,
627         uint8 v,
628         bytes32 r,
629         bytes32 s
630     ) public {
631         bytes32 domainSeparator = keccak256(
632             abi.encode(
633                 DOMAIN_TYPEHASH,
634                 keccak256(bytes(name)),
635                 getChainId(),
636                 address(this)
637             )
638         );
639         bytes32 structHash = keccak256(
640             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
641         );
642         bytes32 digest = keccak256(
643             abi.encodePacked('\x19\x01', domainSeparator, structHash)
644         );
645         address signatory = ecrecover(digest, v, r, s);
646         require(
647             signatory != address(0),
648             'HFT::delegateBySig: invalid signature'
649         );
650         require(
651             nonce == nonces[signatory]++,
652             'HFT::delegateBySig: invalid nonce'
653         );
654         require(
655             block.timestamp <= expiry,
656             'HFT::delegateBySig: signature expired'
657         );
658         return _delegate(signatory, delegatee);
659     }
660 
661     /**
662      * @notice Gets the current votes balance for `account`
663      * @param account The address to get votes balance
664      * @return The number of current votes for `account`
665      */
666     function getCurrentVotes(address account) external view returns (uint96) {
667         uint32 nCheckpoints = numCheckpoints[account];
668         return
669             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
670     }
671 
672     /**
673      * @notice Determine the prior number of votes for an account as of a block number
674      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
675      * @param account The address of the account to check
676      * @param blockNumber The block number to get the vote balance at
677      * @return The number of votes the account had as of the given block
678      */
679     function getPriorVotes(address account, uint256 blockNumber)
680         public
681         view
682         returns (uint96)
683     {
684         require(
685             blockNumber < block.number,
686             'HFT::getPriorVotes: not yet determined'
687         );
688 
689         uint32 nCheckpoints = numCheckpoints[account];
690         if (nCheckpoints == 0) {
691             return 0;
692         }
693 
694         // First check most recent balance
695         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
696             return checkpoints[account][nCheckpoints - 1].votes;
697         }
698 
699         // Next check implicit zero balance
700         if (checkpoints[account][0].fromBlock > blockNumber) {
701             return 0;
702         }
703 
704         uint32 lower = 0;
705         uint32 upper = nCheckpoints - 1;
706         while (upper > lower) {
707             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
708             Checkpoint memory cp = checkpoints[account][center];
709             if (cp.fromBlock == blockNumber) {
710                 return cp.votes;
711             } else if (cp.fromBlock < blockNumber) {
712                 lower = center;
713             } else {
714                 upper = center - 1;
715             }
716         }
717         return checkpoints[account][lower].votes;
718     }
719 
720     function _delegate(address delegator, address delegatee) internal {
721         address currentDelegate = delegates[delegator];
722         uint96 delegatorBalance = balances[delegator];
723         delegates[delegator] = delegatee;
724 
725         emit DelegateChanged(delegator, currentDelegate, delegatee);
726 
727         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
728     }
729 
730     function _approve(
731         address caller,
732         address spender,
733         uint256 rawAmount
734     ) internal {
735         uint96 amount;
736         if (rawAmount == type(uint256).max) {
737             amount = type(uint96).max;
738         } else {
739             amount = safe96(rawAmount, 'HFT::approve: amount exceeds 96 bits');
740         }
741 
742         allowances[caller][spender] = amount;
743 
744         emit Approval(caller, spender, amount);
745     }
746 
747     function _transferTokens(
748         address src,
749         address dst,
750         uint96 amount
751     ) internal {
752         require(
753             src != address(0),
754             'HFT::_transferTokens: cannot transfer from the zero address'
755         );
756         require(
757             dst != address(0),
758             'HFT::_transferTokens: cannot transfer to the zero address'
759         );
760 
761         balances[src] = sub96(
762             balances[src],
763             amount,
764             'HFT::_transferTokens: transfer amount exceeds balance'
765         );
766         balances[dst] = add96(
767             balances[dst],
768             amount,
769             'HFT::_transferTokens: transfer amount overflows'
770         );
771         emit Transfer(src, dst, amount);
772 
773         _moveDelegates(delegates[src], delegates[dst], amount);
774     }
775 
776     function _moveDelegates(
777         address srcRep,
778         address dstRep,
779         uint96 amount
780     ) internal {
781         if (srcRep != dstRep && amount > 0) {
782             if (srcRep != address(0)) {
783                 uint32 srcRepNum = numCheckpoints[srcRep];
784                 uint96 srcRepOld = srcRepNum > 0
785                     ? checkpoints[srcRep][srcRepNum - 1].votes
786                     : 0;
787                 uint96 srcRepNew = sub96(
788                     srcRepOld,
789                     amount,
790                     'HFT::_moveDelegates: vote amount underflows'
791                 );
792                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
793             }
794 
795             if (dstRep != address(0)) {
796                 uint32 dstRepNum = numCheckpoints[dstRep];
797                 uint96 dstRepOld = dstRepNum > 0
798                     ? checkpoints[dstRep][dstRepNum - 1].votes
799                     : 0;
800                 uint96 dstRepNew = add96(
801                     dstRepOld,
802                     amount,
803                     'HFT::_moveDelegates: vote amount overflows'
804                 );
805                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
806             }
807         }
808     }
809 
810     function _writeCheckpoint(
811         address delegatee,
812         uint32 nCheckpoints,
813         uint96 oldVotes,
814         uint96 newVotes
815     ) internal {
816         uint32 blockNumber = safe32(
817             block.number,
818             'HFT::_writeCheckpoint: block number exceeds 32 bits'
819         );
820 
821         if (
822             nCheckpoints > 0 &&
823             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
824         ) {
825             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
826         } else {
827             checkpoints[delegatee][nCheckpoints] = Checkpoint(
828                 blockNumber,
829                 newVotes
830             );
831             numCheckpoints[delegatee] = nCheckpoints + 1;
832         }
833 
834         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
835     }
836 
837     function safe32(uint256 n, string memory errorMessage)
838         internal
839         pure
840         returns (uint32)
841     {
842         require(n < 2**32, errorMessage);
843         return uint32(n);
844     }
845 
846     function safe96(uint256 n, string memory errorMessage)
847         internal
848         pure
849         returns (uint96)
850     {
851         require(n < 2**96, errorMessage);
852         return uint96(n);
853     }
854 
855     function add96(
856         uint96 a,
857         uint96 b,
858         string memory errorMessage
859     ) internal pure returns (uint96) {
860         uint96 c = a + b;
861         require(c >= a, errorMessage);
862         return c;
863     }
864 
865     function sub96(
866         uint96 a,
867         uint96 b,
868         string memory errorMessage
869     ) internal pure returns (uint96) {
870         require(b <= a, errorMessage);
871         return a - b;
872     }
873 
874     function getChainId() internal view returns (uint256) {
875         uint256 chainId;
876         assembly {
877             chainId := chainid()
878         }
879         return chainId;
880     }
881 }