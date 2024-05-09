1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, with an overflow flag.
7      *
8      * _Available since v3.4._
9      */
10     function tryAdd(uint256 a, uint256 b)
11         internal
12         pure
13         returns (bool, uint256)
14     {
15         unchecked {
16             uint256 c = a + b;
17             if (c < a) return (false, 0);
18             return (true, c);
19         }
20     }
21 
22     /**
23      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function trySub(uint256 a, uint256 b)
28         internal
29         pure
30         returns (bool, uint256)
31     {
32         unchecked {
33             if (b > a) return (false, 0);
34             return (true, a - b);
35         }
36     }
37 
38     /**
39      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function tryMul(uint256 a, uint256 b)
44         internal
45         pure
46         returns (bool, uint256)
47     {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b)
65         internal
66         pure
67         returns (bool, uint256)
68     {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b)
81         internal
82         pure
83         returns (bool, uint256)
84     {
85         unchecked {
86             if (b == 0) return (false, 0);
87             return (true, a % b);
88         }
89     }
90 
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a + b;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a - b;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a * b;
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers, reverting on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator.
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a / b;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * reverting when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a % b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * CAUTION: This function is deprecated because it requires allocating memory for the error
168      * message unnecessarily. For custom revert reasons use {trySub}.
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(
177         uint256 a,
178         uint256 b,
179         string memory errorMessage
180     ) internal pure returns (uint256) {
181         unchecked {
182             require(b <= a, errorMessage);
183             return a - b;
184         }
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(
200         uint256 a,
201         uint256 b,
202         string memory errorMessage
203     ) internal pure returns (uint256) {
204         unchecked {
205             require(b > 0, errorMessage);
206             return a / b;
207         }
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * reverting with custom message when dividing by zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryMod}.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a % b;
233         }
234     }
235 }
236 
237 library SafeCast {
238     /**
239      * @dev Returns the downcasted uint224 from uint256, reverting on
240      * overflow (when the input is greater than largest uint224).
241      *
242      * Counterpart to Solidity's `uint224` operator.
243      *
244      * Requirements:
245      *
246      * - input must fit into 224 bits
247      */
248     function toUint224(uint256 value) internal pure returns (uint224) {
249         require(
250             value <= type(uint224).max,
251             "SafeCast: value doesn't fit in 224 bits"
252         );
253         return uint224(value);
254     }
255 
256     /**
257      * @dev Returns the downcasted uint128 from uint256, reverting on
258      * overflow (when the input is greater than largest uint128).
259      *
260      * Counterpart to Solidity's `uint128` operator.
261      *
262      * Requirements:
263      *
264      * - input must fit into 128 bits
265      */
266     function toUint128(uint256 value) internal pure returns (uint128) {
267         require(
268             value <= type(uint128).max,
269             "SafeCast: value doesn't fit in 128 bits"
270         );
271         return uint128(value);
272     }
273 
274     /**
275      * @dev Returns the downcasted uint96 from uint256, reverting on
276      * overflow (when the input is greater than largest uint96).
277      *
278      * Counterpart to Solidity's `uint96` operator.
279      *
280      * Requirements:
281      *
282      * - input must fit into 96 bits
283      */
284     function toUint96(uint256 value) internal pure returns (uint96) {
285         require(
286             value <= type(uint96).max,
287             "SafeCast: value doesn't fit in 96 bits"
288         );
289         return uint96(value);
290     }
291 
292     /**
293      * @dev Returns the downcasted uint64 from uint256, reverting on
294      * overflow (when the input is greater than largest uint64).
295      *
296      * Counterpart to Solidity's `uint64` operator.
297      *
298      * Requirements:
299      *
300      * - input must fit into 64 bits
301      */
302     function toUint64(uint256 value) internal pure returns (uint64) {
303         require(
304             value <= type(uint64).max,
305             "SafeCast: value doesn't fit in 64 bits"
306         );
307         return uint64(value);
308     }
309 
310     /**
311      * @dev Returns the downcasted uint32 from uint256, reverting on
312      * overflow (when the input is greater than largest uint32).
313      *
314      * Counterpart to Solidity's `uint32` operator.
315      *
316      * Requirements:
317      *
318      * - input must fit into 32 bits
319      */
320     function toUint32(uint256 value) internal pure returns (uint32) {
321         require(
322             value <= type(uint32).max,
323             "SafeCast: value doesn't fit in 32 bits"
324         );
325         return uint32(value);
326     }
327 
328     /**
329      * @dev Returns the downcasted uint16 from uint256, reverting on
330      * overflow (when the input is greater than largest uint16).
331      *
332      * Counterpart to Solidity's `uint16` operator.
333      *
334      * Requirements:
335      *
336      * - input must fit into 16 bits
337      */
338     function toUint16(uint256 value) internal pure returns (uint16) {
339         require(
340             value <= type(uint16).max,
341             "SafeCast: value doesn't fit in 16 bits"
342         );
343         return uint16(value);
344     }
345 
346     /**
347      * @dev Returns the downcasted uint8 from uint256, reverting on
348      * overflow (when the input is greater than largest uint8).
349      *
350      * Counterpart to Solidity's `uint8` operator.
351      *
352      * Requirements:
353      *
354      * - input must fit into 8 bits.
355      */
356     function toUint8(uint256 value) internal pure returns (uint8) {
357         require(
358             value <= type(uint8).max,
359             "SafeCast: value doesn't fit in 8 bits"
360         );
361         return uint8(value);
362     }
363 
364     /**
365      * @dev Converts a signed int256 into an unsigned uint256.
366      *
367      * Requirements:
368      *
369      * - input must be greater than or equal to 0.
370      */
371     function toUint256(int256 value) internal pure returns (uint256) {
372         require(value >= 0, "SafeCast: value must be positive");
373         return uint256(value);
374     }
375 
376     /**
377      * @dev Returns the downcasted int128 from int256, reverting on
378      * overflow (when the input is less than smallest int128 or
379      * greater than largest int128).
380      *
381      * Counterpart to Solidity's `int128` operator.
382      *
383      * Requirements:
384      *
385      * - input must fit into 128 bits
386      *
387      * _Available since v3.1._
388      */
389     function toInt128(int256 value) internal pure returns (int128) {
390         require(
391             value >= type(int128).min && value <= type(int128).max,
392             "SafeCast: value doesn't fit in 128 bits"
393         );
394         return int128(value);
395     }
396 
397     /**
398      * @dev Returns the downcasted int64 from int256, reverting on
399      * overflow (when the input is less than smallest int64 or
400      * greater than largest int64).
401      *
402      * Counterpart to Solidity's `int64` operator.
403      *
404      * Requirements:
405      *
406      * - input must fit into 64 bits
407      *
408      * _Available since v3.1._
409      */
410     function toInt64(int256 value) internal pure returns (int64) {
411         require(
412             value >= type(int64).min && value <= type(int64).max,
413             "SafeCast: value doesn't fit in 64 bits"
414         );
415         return int64(value);
416     }
417 
418     /**
419      * @dev Returns the downcasted int32 from int256, reverting on
420      * overflow (when the input is less than smallest int32 or
421      * greater than largest int32).
422      *
423      * Counterpart to Solidity's `int32` operator.
424      *
425      * Requirements:
426      *
427      * - input must fit into 32 bits
428      *
429      * _Available since v3.1._
430      */
431     function toInt32(int256 value) internal pure returns (int32) {
432         require(
433             value >= type(int32).min && value <= type(int32).max,
434             "SafeCast: value doesn't fit in 32 bits"
435         );
436         return int32(value);
437     }
438 
439     /**
440      * @dev Returns the downcasted int16 from int256, reverting on
441      * overflow (when the input is less than smallest int16 or
442      * greater than largest int16).
443      *
444      * Counterpart to Solidity's `int16` operator.
445      *
446      * Requirements:
447      *
448      * - input must fit into 16 bits
449      *
450      * _Available since v3.1._
451      */
452     function toInt16(int256 value) internal pure returns (int16) {
453         require(
454             value >= type(int16).min && value <= type(int16).max,
455             "SafeCast: value doesn't fit in 16 bits"
456         );
457         return int16(value);
458     }
459 
460     /**
461      * @dev Returns the downcasted int8 from int256, reverting on
462      * overflow (when the input is less than smallest int8 or
463      * greater than largest int8).
464      *
465      * Counterpart to Solidity's `int8` operator.
466      *
467      * Requirements:
468      *
469      * - input must fit into 8 bits.
470      *
471      * _Available since v3.1._
472      */
473     function toInt8(int256 value) internal pure returns (int8) {
474         require(
475             value >= type(int8).min && value <= type(int8).max,
476             "SafeCast: value doesn't fit in 8 bits"
477         );
478         return int8(value);
479     }
480 
481     /**
482      * @dev Converts an unsigned uint256 into a signed int256.
483      *
484      * Requirements:
485      *
486      * - input must be less than or equal to maxInt256.
487      */
488     function toInt256(uint256 value) internal pure returns (int256) {
489         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
490         require(
491             value <= uint256(type(int256).max),
492             "SafeCast: value doesn't fit in an int256"
493         );
494         return int256(value);
495     }
496 }
497 
498 abstract contract Context {
499     function _msgSender() internal view virtual returns (address) {
500         return msg.sender;
501     }
502 
503     function _msgData() internal view virtual returns (bytes calldata) {
504         return msg.data;
505     }
506 }
507 
508 abstract contract Ownable is Context {
509     address private _owner;
510 
511     event OwnershipTransferred(
512         address indexed previousOwner,
513         address indexed newOwner
514     );
515 
516     /**
517      * @dev Initializes the contract setting the deployer as the initial owner.
518      */
519     constructor() {
520         _setOwner(_msgSender());
521     }
522 
523     /**
524      * @dev Returns the address of the current owner.
525      */
526     function owner() public view virtual returns (address) {
527         return _owner;
528     }
529 
530     /**
531      * @dev Throws if called by any account other than the owner.
532      */
533     modifier onlyOwner() {
534         require(owner() == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537 
538     /**
539      * @dev Transfers ownership of the contract to a new account (`newOwner`).
540      * Can only be called by the current owner.
541      */
542     function transferOwnership(address newOwner) public virtual onlyOwner {
543         require(
544             newOwner != address(0),
545             "Ownable: new owner is the zero address"
546         );
547         _setOwner(newOwner);
548     }
549 
550     function _setOwner(address newOwner) private {
551         address oldOwner = _owner;
552         _owner = newOwner;
553         emit OwnershipTransferred(oldOwner, newOwner);
554     }
555 }
556 
557 contract GenArtGovToken is Ownable {
558     using SafeMath for uint256;
559     using SafeCast for uint256;
560 
561     /// @notice EIP-20 token name for this token
562     string public constant name = "GEN.ART";
563 
564     /// @notice EIP-20 token symbol for this token
565     string public constant symbol = "GENART";
566 
567     /// @notice EIP-20 token decimals for this token
568     uint8 public constant decimals = 18;
569 
570     /// @notice Total number of tokens in circulation
571     uint256 public totalSupply = 100_000_000e18; // 100 million
572 
573     mapping(address => mapping(address => uint256)) internal allowances;
574 
575     mapping(address => uint256) internal balances;
576 
577     /// @notice A record of each accounts delegate
578     mapping(address => address) public delegates;
579 
580     /// @notice A checkpoint for marking number of votes from a given block
581     struct Checkpoint {
582         uint32 fromBlock;
583         uint224 votes;
584     }
585 
586     /// @notice A record of votes checkpoints for each account, by index
587     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
588 
589     /// @notice The number of checkpoints for each account
590     mapping(address => uint32) public numCheckpoints;
591 
592     /// @notice The EIP-712 typehash for the contract's domain
593     bytes32 public constant DOMAIN_TYPEHASH =
594         keccak256(
595             "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
596         );
597 
598     /// @notice The EIP-712 typehash for the delegation struct used by the contract
599     bytes32 public constant DELEGATION_TYPEHASH =
600         keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
601 
602     /// @notice The EIP-712 typehash for the permit struct used by the contract
603     bytes32 public constant PERMIT_TYPEHASH =
604         keccak256(
605             "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
606         );
607 
608     /// @notice A record of states for signing / validating signatures
609     mapping(address => uint256) public nonces;
610 
611     /// @notice An event thats emitted when an account changes its delegate
612     event DelegateChanged(
613         address indexed delegator,
614         address indexed fromDelegate,
615         address indexed toDelegate
616     );
617 
618     /// @notice An event thats emitted when a delegate account's vote balance changes
619     event DelegateVotesChanged(
620         address indexed delegate,
621         uint256 previousBalance,
622         uint256 newBalance
623     );
624 
625     /// @notice The standard EIP-20 transfer event
626     event Transfer(address indexed from, address indexed to, uint256 amount);
627 
628     /// @notice The standard EIP-20 approval event
629     event Approval(
630         address indexed owner,
631         address indexed spender,
632         uint256 amount
633     );
634 
635     constructor(address treasury_) {
636         _mint(treasury_, 100 * 10**24);
637     }
638 
639     /**
640      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
641      * @param account The address of the account holding the funds
642      * @param spender The address of the account spending the funds
643      * @return The number of tokens approved
644      */
645     function allowance(address account, address spender)
646         external
647         view
648         returns (uint256)
649     {
650         return allowances[account][spender];
651     }
652 
653     /**
654      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
655      *
656      * This internal function is equivalent to `approve`, and can be used to
657      * e.g. set automatic allowances for certain subsystems, etc.
658      *
659      * Emits an {Approval} event.
660      *
661      * Requirements:
662      *
663      * - `owner` cannot be the zero address.
664      * - `spender` cannot be the zero address.
665      */
666     function _approve(
667         address owner,
668         address spender,
669         uint256 amount
670     ) internal virtual {
671         require(
672             owner != address(0),
673             "GenArtGovToken: approve from the zero address"
674         );
675         require(
676             spender != address(0),
677             "GenArtGovToken: approve to the zero address"
678         );
679 
680         allowances[owner][spender] = amount;
681         emit Approval(owner, spender, amount);
682     }
683 
684     /**
685      * @notice Triggers an approval from owner to spender
686      * @param owner The address to approve from
687      * @param spender The address to be approved
688      * @param amount The number of tokens that are approved (2^256-1 means infinite)
689      * @param deadline The time at which to expire the signature
690      * @param v The recovery byte of the signature
691      * @param r Half of the ECDSA signature pair
692      * @param s Half of the ECDSA signature pair
693      */
694     function permit(
695         address owner,
696         address spender,
697         uint256 amount,
698         uint256 deadline,
699         uint8 v,
700         bytes32 r,
701         bytes32 s
702     ) external {
703         bytes32 domainSeparator = keccak256(
704             abi.encode(
705                 DOMAIN_TYPEHASH,
706                 keccak256(bytes(name)),
707                 getChainId(),
708                 address(this)
709             )
710         );
711         bytes32 structHash = keccak256(
712             abi.encode(
713                 PERMIT_TYPEHASH,
714                 owner,
715                 spender,
716                 amount,
717                 nonces[owner]++,
718                 deadline
719             )
720         );
721         bytes32 digest = keccak256(
722             abi.encodePacked("\x19\x01", domainSeparator, structHash)
723         );
724         address signatory = ecrecover(digest, v, r, s);
725         require(signatory != address(0), "GenArtGovToken: invalid signature");
726         require(signatory == owner, "GenArtGovToken: unauthorized");
727         require(
728             block.timestamp <= deadline,
729             "GenArtGovToken: signature expired"
730         );
731 
732         allowances[owner][spender] = amount;
733 
734         emit Approval(owner, spender, amount);
735     }
736 
737     /**
738      * @notice Get the number of tokens held by the `account`
739      * @param account The address of the account to get the balance of
740      * @return The number of tokens held
741      */
742     function balanceOf(address account) external view returns (uint256) {
743         return balances[account];
744     }
745 
746     /**
747      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
748      * @param to The address of the destination account
749      * @param amount The number of tokens to transfer
750      * @return Whether or not the transfer succeeded
751      */
752     function transfer(address to, uint256 amount) external returns (bool) {
753         _transferTokens(msg.sender, to, amount);
754         return true;
755     }
756 
757     function transferFrom(
758         address sender,
759         address recipient,
760         uint256 amount
761     ) public returns (bool) {
762         address spender = _msgSender();
763 
764         uint256 currentAllowance = allowances[sender][spender];
765         require(
766             currentAllowance >= amount,
767             "GenArtGovToken: transfer amount exceeds allowance"
768         );
769         _transferTokens(sender, recipient, amount);
770 
771         unchecked {
772             approve(spender, currentAllowance - amount);
773         }
774 
775         return true;
776     }
777 
778     /**
779      * @notice Delegate votes from `msg.sender` to `delegatee`
780      * @param delegatee The address to delegate votes to
781      */
782     function delegate(address delegatee) public {
783         return _delegate(msg.sender, delegatee);
784     }
785 
786     /**
787      * @notice Delegates votes from signatory to `delegatee`
788      * @param delegatee The address to delegate votes to
789      * @param nonce The contract state required to match the signature
790      * @param expiry The time at which to expire the signature
791      * @param v The recovery byte of the signature
792      * @param r Half of the ECDSA signature pair
793      * @param s Half of the ECDSA signature pair
794      */
795     function delegateBySig(
796         address delegatee,
797         uint256 nonce,
798         uint256 expiry,
799         uint8 v,
800         bytes32 r,
801         bytes32 s
802     ) public {
803         bytes32 domainSeparator = keccak256(
804             abi.encode(
805                 DOMAIN_TYPEHASH,
806                 keccak256(bytes(name)),
807                 getChainId(),
808                 address(this)
809             )
810         );
811         bytes32 structHash = keccak256(
812             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
813         );
814         bytes32 digest = keccak256(
815             abi.encodePacked("\x19\x01", domainSeparator, structHash)
816         );
817         address signatory = ecrecover(digest, v, r, s);
818         require(signatory != address(0), "GenArtGovToken: invalid signature");
819         require(nonce == nonces[signatory]++, "GenArtGovToken: invalid nonce");
820         require(block.timestamp <= expiry, "GenArtGovToken: signature expired");
821         return _delegate(signatory, delegatee);
822     }
823 
824     /**
825      * @notice Gets the current votes balance for `account`
826      * @param account The address to get votes balance
827      * @return The number of current votes for `account`
828      */
829     function getCurrentVotes(address account) external view returns (uint256) {
830         uint32 nCheckpoints = numCheckpoints[account];
831         return
832             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
833     }
834 
835     /**
836      * @notice Determine the prior number of votes for an account as of a block number
837      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
838      * @param account The address of the account to check
839      * @param blockNumber The block number to get the vote balance at
840      * @return The number of votes the account had as of the given block
841      */
842     function getPriorVotes(address account, uint32 blockNumber)
843         public
844         view
845         returns (uint256)
846     {
847         require(
848             blockNumber < block.number,
849             "GenArtGovToken: not yet determined"
850         );
851 
852         uint32 nCheckpoints = numCheckpoints[account];
853         if (nCheckpoints == 0) {
854             return 0;
855         }
856 
857         // First check most recent balance
858         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
859             return checkpoints[account][nCheckpoints - 1].votes;
860         }
861 
862         // Next check implicit zero balance
863         if (checkpoints[account][0].fromBlock > blockNumber) {
864             return 0;
865         }
866 
867         uint32 lower = 0;
868         uint32 upper = nCheckpoints - 1;
869         while (upper > lower) {
870             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
871             Checkpoint memory cp = checkpoints[account][center];
872             if (cp.fromBlock == blockNumber) {
873                 return cp.votes;
874             } else if (cp.fromBlock < blockNumber) {
875                 lower = center;
876             } else {
877                 upper = center - 1;
878             }
879         }
880         return checkpoints[account][lower].votes;
881     }
882 
883     function _delegate(address delegator, address delegatee) internal {
884         address currentDelegate = delegates[delegator];
885         uint256 delegatorBalance = balances[delegator];
886         delegates[delegator] = delegatee;
887 
888         emit DelegateChanged(delegator, currentDelegate, delegatee);
889 
890         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
891     }
892 
893     function _transferTokens(
894         address from,
895         address to,
896         uint256 amount
897     ) internal {
898         require(
899             from != address(0),
900             "GenArtGovToken: cannot transfer from the zero address"
901         );
902         require(
903             to != address(0),
904             "GenArtGovToken: cannot transfer to the zero address"
905         );
906 
907         balances[from] = balances[from].sub(
908             amount,
909             "GenArtGovToken: transfer amount exceeds balance"
910         );
911 
912         balances[to] = balances[to].add(amount);
913 
914         emit Transfer(from, to, amount);
915 
916         _moveDelegates(delegates[from], delegates[to], amount);
917     }
918 
919     function _moveDelegates(
920         address srcRep,
921         address dstRep,
922         uint256 amount
923     ) internal {
924         if (srcRep != dstRep && amount > 0) {
925             if (srcRep != address(0)) {
926                 uint32 srcRepNum = numCheckpoints[srcRep];
927                 uint256 srcRepOld = srcRepNum > 0
928                     ? checkpoints[srcRep][srcRepNum - 1].votes
929                     : 0;
930                 uint256 srcRepNew = srcRepOld.sub(
931                     amount,
932                     "GenArtGovToken: vote amount underflows"
933                 );
934 
935                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
936             }
937 
938             if (dstRep != address(0)) {
939                 uint32 dstRepNum = numCheckpoints[dstRep];
940                 uint256 dstRepOld = dstRepNum > 0
941                     ? checkpoints[dstRep][dstRepNum - 1].votes
942                     : 0;
943                 uint256 dstRepNew = dstRepOld.add(amount);
944 
945                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
946             }
947         }
948     }
949 
950     function _writeCheckpoint(
951         address delegatee,
952         uint32 nCheckpoints,
953         uint256 oldVotes,
954         uint256 newVotes
955     ) internal {
956         uint224 _votes = newVotes.toUint224();
957         if (
958             nCheckpoints > 0 &&
959             checkpoints[delegatee][nCheckpoints - 1].fromBlock == block.number
960         ) {
961             checkpoints[delegatee][nCheckpoints - 1].votes = _votes;
962         } else {
963             checkpoints[delegatee][nCheckpoints] = Checkpoint(
964                 block.number.toUint32(),
965                 _votes
966             );
967             numCheckpoints[delegatee] = nCheckpoints + 1;
968         }
969 
970         emit DelegateVotesChanged(delegatee, oldVotes, _votes);
971     }
972 
973     function getChainId() public view returns (uint256) {
974         uint256 chainId;
975         assembly {
976             chainId := chainid()
977         }
978         return chainId;
979     }
980 
981     function _mint(address account, uint96 amount) internal virtual {
982         require(
983             account != address(0),
984             "GenArtGovToken: mint to the zero address"
985         );
986 
987         totalSupply += amount;
988         balances[account] += amount;
989         emit Transfer(address(0), account, amount);
990     }
991 
992     /**
993      * @dev See {IERC20-approve}.
994      *
995      * Requirements:
996      *
997      * - `spender` cannot be the zero address.
998      */
999     function approve(address spender, uint256 amount)
1000         public
1001         virtual
1002         returns (bool)
1003     {
1004         _approve(_msgSender(), spender, amount);
1005         return true;
1006     }
1007 }