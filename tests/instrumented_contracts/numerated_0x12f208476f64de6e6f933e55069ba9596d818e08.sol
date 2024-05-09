1 pragma solidity >=0.5.3<0.6.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 // Just inlining part of the standard ERC20 contract
110 interface ERC20Token {
111     function transfer(address recipient, uint256 amount) external returns (bool);
112     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113 }
114 
115 /**
116  * @title Staking is a contract to support locking and releasing ERC-20 tokens
117  * for the purposes of staking.
118  */
119 contract Staking {
120     struct PendingDeposit {
121         address depositor;
122         uint256 amount;
123     }
124 
125     address public _owner;
126     address public _authorizedNewOwner;
127     address public _tokenAddress;
128 
129     address public _withdrawalPublisher;
130     address public _fallbackPublisher;
131     uint256 public _fallbackWithdrawalDelaySeconds = 1 weeks;
132 
133     // 1% of total supply
134     uint256 public _immediatelyWithdrawableLimit = 100_000 * (10**18);
135     address public _immediatelyWithdrawableLimitPublisher;
136 
137     uint256 public _depositNonce = 0;
138     mapping(uint256 => PendingDeposit) public _nonceToPendingDeposit;
139 
140     uint256 public _maxWithdrawalRootNonce = 0;
141     mapping(bytes32 => uint256) public _withdrawalRootToNonce;
142     mapping(address => uint256) public _addressToWithdrawalNonce;
143     mapping(address => uint256) public _addressToCumulativeAmountWithdrawn;
144 
145     bytes32 public _fallbackRoot;
146     uint256 public _fallbackMaxDepositIncluded = 0;
147     uint256 public _fallbackSetDate = 2**200;
148 
149     event WithdrawalRootHashAddition(
150         bytes32 indexed rootHash,
151         uint256 indexed nonce
152     );
153 
154     event WithdrawalRootHashRemoval(
155         bytes32 indexed rootHash,
156         uint256 indexed nonce
157     );
158 
159     event FallbackRootHashSet(
160         bytes32 indexed rootHash,
161         uint256 indexed maxDepositNonceIncluded,
162         uint256 setDate
163     );
164 
165     event Deposit(
166         address indexed depositor,
167         uint256 indexed amount,
168         uint256 indexed nonce
169     );
170 
171     event Withdrawal(
172         address indexed toAddress,
173         uint256 indexed amount,
174         uint256 indexed rootNonce,
175         uint256 authorizedAccountNonce
176     );
177 
178     event FallbackWithdrawal(
179         address indexed toAddress,
180         uint256 indexed amount
181     );
182 
183     event PendingDepositRefund(
184         address indexed depositorAddress,
185         uint256 indexed amount,
186         uint256 indexed nonce
187     );
188 
189     event RenounceWithdrawalAuthorization(
190         address indexed forAddress
191     );
192 
193     event FallbackWithdrawalDelayUpdate(
194         uint256 indexed oldValue,
195         uint256 indexed newValue
196     );
197 
198     event FallbackMechanismDateReset(
199         uint256 indexed newDate
200     );
201 
202     event ImmediatelyWithdrawableLimitUpdate(
203         uint256 indexed oldValue,
204         uint256 indexed newValue
205     );
206 
207     event OwnershipTransferAuthorization(
208         address indexed authorizedAddress
209     );
210 
211     event OwnerUpdate(
212         address indexed oldValue,
213         address indexed newValue
214     );
215 
216     event FallbackPublisherUpdate(
217         address indexed oldValue,
218         address indexed newValue
219     );
220 
221     event WithdrawalPublisherUpdate(
222         address indexed oldValue,
223         address indexed newValue
224     );
225 
226     event ImmediatelyWithdrawableLimitPublisherUpdate(
227         address indexed oldValue,
228         address indexed newValue
229     );
230 
231     constructor(
232         address tokenAddress,
233         address fallbackPublisher,
234         address withdrawalPublisher,
235         address immediatelyWithdrawableLimitPublisher
236     ) public {
237         _owner = msg.sender;
238         _fallbackPublisher = fallbackPublisher;
239         _withdrawalPublisher = withdrawalPublisher;
240         _immediatelyWithdrawableLimitPublisher = immediatelyWithdrawableLimitPublisher;
241         _tokenAddress = tokenAddress;
242     }
243 
244     /********************
245      * STANDARD ACTIONS *
246      ********************/
247 
248     /**
249      * @notice Deposits the provided amount of FXC from the message sender into this wallet.
250      * Note: The sending address must own the provided amount of FXC to deposit, and
251      * the sender must have indicated to the FXC ERC-20 contract that this contract is
252      * allowed to transfer at least the provided amount from its address.
253      *
254      * @param amount The amount to deposit.
255      * @return The deposit nonce for this deposit. This can be useful in calling
256      * refundPendingDeposit(...).
257      */
258     function deposit(uint256 amount) external returns(uint256) {
259         require(
260             amount > 0,
261             "Cannot deposit 0"
262         );
263 
264         _depositNonce = SafeMath.add(_depositNonce, 1);
265         _nonceToPendingDeposit[_depositNonce].depositor = msg.sender;
266         _nonceToPendingDeposit[_depositNonce].amount = amount;
267 
268         emit Deposit(
269             msg.sender,
270             amount,
271             _depositNonce
272         );
273 
274         bool transferred = ERC20Token(_tokenAddress).transferFrom(
275             msg.sender,
276             address(this),
277             amount
278         );
279         require(transferred, "Transfer failed");
280         
281         return _depositNonce;
282     }
283 
284     /**
285      * @notice Indicates that this address would not like its withdrawable
286      * funds to be available for withdrawal. This will prevent withdrawal
287      * for this address until the next withdrawal root is published.
288      *
289      * Note: The caller does not need to know or prove the details of the current
290      * withdrawal authorization in order to renounce it.
291      * @param forAddress The address for which the withdrawal is being renounced.
292      */
293     function renounceWithdrawalAuthorization(address forAddress) external {
294         require(
295             msg.sender == _owner ||
296             msg.sender == _withdrawalPublisher ||
297             msg.sender == forAddress,
298             "Only the owner, withdrawal publisher, and address in question can renounce a withdrawal authorization"
299         );
300         require(
301             _addressToWithdrawalNonce[forAddress] < _maxWithdrawalRootNonce,
302             "Address nonce indicates there are no funds withdrawable"
303         );
304         _addressToWithdrawalNonce[forAddress] = _maxWithdrawalRootNonce;
305         emit RenounceWithdrawalAuthorization(forAddress);
306     }
307 
308     /**
309      * @notice Executes a previously authorized token withdrawal.
310      * @param toAddress The address to which the tokens are to be transferred.
311      * @param amount The amount of tokens to be withdrawn.
312      * @param maxAuthorizedAccountNonce The maximum authorized account nonce for the withdrawing
313      * address encoded within the withdrawal authorization. Prevents double-withdrawals.
314      * @param merkleProof The Merkle tree proof associated with the withdrawal
315      * authorization.
316      */
317     function withdraw(
318         address toAddress,
319         uint256 amount,
320         uint256 maxAuthorizedAccountNonce,
321         bytes32[] calldata merkleProof
322     ) external {
323         require(
324             msg.sender == _owner || msg.sender == toAddress,
325             "Only the owner or recipient can execute a withdrawal"
326         );
327 
328         require(
329             _addressToWithdrawalNonce[toAddress] <= maxAuthorizedAccountNonce,
330             "Account nonce in contract exceeds provided max authorized withdrawal nonce for this account"
331         );
332 
333         require(
334             amount <= _immediatelyWithdrawableLimit,
335             "Withdrawal would push contract over its immediately withdrawable limit"
336         );
337 
338         bytes32 leafDataHash = keccak256(abi.encodePacked(
339             toAddress,
340             amount,
341             maxAuthorizedAccountNonce
342         ));
343 
344         bytes32 calculatedRoot = calculateMerkleRoot(merkleProof, leafDataHash);
345         uint256 withdrawalPermissionRootNonce = _withdrawalRootToNonce[calculatedRoot];
346 
347         require(
348             withdrawalPermissionRootNonce > 0,
349             "Root hash unauthorized");
350         require(
351             withdrawalPermissionRootNonce > maxAuthorizedAccountNonce,
352             "Encoded nonce not greater than max last authorized nonce for this account"
353         );
354 
355         _immediatelyWithdrawableLimit -= amount; // amount guaranteed <= _immediatelyWithdrawableLimit
356         _addressToWithdrawalNonce[toAddress] = withdrawalPermissionRootNonce;
357         _addressToCumulativeAmountWithdrawn[toAddress] = SafeMath.add(amount, _addressToCumulativeAmountWithdrawn[toAddress]);
358 
359         emit Withdrawal(
360             toAddress,
361             amount,
362             withdrawalPermissionRootNonce,
363             maxAuthorizedAccountNonce
364         );
365 
366         bool transferred = ERC20Token(_tokenAddress).transfer(
367             toAddress,
368             amount
369         );
370 
371         require(transferred, "Transfer failed");
372     }
373 
374     /**
375      * @notice Executes a fallback withdrawal transfer.
376      * @param toAddress The address to which the tokens are to be transferred.
377      * @param maxCumulativeAmountWithdrawn The lifetime withdrawal limit that this address is
378      * subject to. This is encoded within the fallback authorization to prevent regular 
379      * withdrawal / fallback withdrawal double-spends
380      * @param merkleProof The Merkle tree proof associated with the withdrawal authorization.
381      */
382     function withdrawFallback(
383         address toAddress,
384         uint256 maxCumulativeAmountWithdrawn,
385         bytes32[] calldata merkleProof
386     ) external {
387         require(
388             msg.sender == _owner || msg.sender == toAddress,
389             "Only the owner or recipient can execute a fallback withdrawal"
390         );
391         require(
392             SafeMath.add(_fallbackSetDate, _fallbackWithdrawalDelaySeconds) <= block.timestamp,
393             "Fallback withdrawal period is not active"
394         );
395         require(
396             _addressToCumulativeAmountWithdrawn[toAddress] < maxCumulativeAmountWithdrawn,
397             "Withdrawal not permitted when amount withdrawn is at lifetime withdrawal limit"
398         );
399 
400         bytes32 msgHash = keccak256(abi.encodePacked(
401             toAddress,
402             maxCumulativeAmountWithdrawn
403         ));
404 
405         bytes32 calculatedRoot = calculateMerkleRoot(merkleProof, msgHash);
406         require(
407             _fallbackRoot == calculatedRoot,
408             "Root hash unauthorized"
409         );
410 
411         // If user is triggering fallback withdrawal, invalidate all existing regular withdrawals
412         _addressToWithdrawalNonce[toAddress] = _maxWithdrawalRootNonce;
413 
414         // _addressToCumulativeAmountWithdrawn[toAddress] guaranteed < maxCumulativeAmountWithdrawn
415         uint256 withdrawalAmount = maxCumulativeAmountWithdrawn - _addressToCumulativeAmountWithdrawn[toAddress];
416         _addressToCumulativeAmountWithdrawn[toAddress] = maxCumulativeAmountWithdrawn;
417         
418         emit FallbackWithdrawal(
419             toAddress,
420             withdrawalAmount
421         );
422 
423         bool transferred = ERC20Token(_tokenAddress).transfer(
424             toAddress,
425             withdrawalAmount
426         );
427 
428         require(transferred, "Transfer failed");
429     }
430 
431     /**
432      * @notice Refunds a pending deposit for the provided address, refunding the pending funds.
433      * This may only take place if the fallback withdrawal period has lapsed.
434      * @param depositNonce The deposit nonce uniquely identifying the deposit to cancel
435      */
436     function refundPendingDeposit(uint256 depositNonce) external {
437         address depositor = _nonceToPendingDeposit[depositNonce].depositor;
438         require(
439             msg.sender == _owner || msg.sender == depositor,
440             "Only the owner or depositor can initiate the refund of a pending deposit"
441         );
442         require(
443             SafeMath.add(_fallbackSetDate, _fallbackWithdrawalDelaySeconds) <= block.timestamp,
444             "Fallback withdrawal period is not active, so refunds are not permitted"
445         );
446         uint256 amount = _nonceToPendingDeposit[depositNonce].amount;
447         require(
448             depositNonce > _fallbackMaxDepositIncluded &&
449             amount > 0,
450             "There is no pending deposit for the specified nonce"
451         );
452         delete _nonceToPendingDeposit[depositNonce];
453 
454         emit PendingDepositRefund(depositor, amount, depositNonce);
455 
456         bool transferred = ERC20Token(_tokenAddress).transfer(
457             depositor,
458             amount
459         );
460         require(transferred, "Transfer failed");
461     }
462 
463     /*****************
464      * ADMIN ACTIONS *
465      *****************/
466 
467     /**
468      * @notice Authorizes the transfer of ownership from _owner to the provided address.
469      * NOTE: No transfer will occur unless authorizedAddress calls assumeOwnership( ).
470      * This authorization may be removed by another call to this function authorizing
471      * the null address.
472      * @param authorizedAddress The address authorized to become the new owner.
473      */
474     function authorizeOwnershipTransfer(address authorizedAddress) external {
475         require(
476             msg.sender == _owner,
477             "Only the owner can authorize a new address to become owner"
478         );
479 
480         _authorizedNewOwner = authorizedAddress;
481 
482         emit OwnershipTransferAuthorization(_authorizedNewOwner);
483     }
484 
485     /**
486      * @notice Transfers ownership of this contract to the _authorizedNewOwner.
487      */
488     function assumeOwnership() external {
489         require(
490             msg.sender == _authorizedNewOwner,
491             "Only the authorized new owner can accept ownership"
492         );
493         address oldValue = _owner;
494         _owner = _authorizedNewOwner;
495         _authorizedNewOwner = address(0);
496 
497         emit OwnerUpdate(oldValue, _owner);
498     }
499 
500     /**
501      * @notice Updates the Withdrawal Publisher address, the only address other than the
502      * owner that can publish / remove withdrawal Merkle tree roots.
503      * @param newWithdrawalPublisher The address of the new Withdrawal Publisher
504      */
505     function setWithdrawalPublisher(address newWithdrawalPublisher) external {
506         require(
507             msg.sender == _owner,
508             "Only the owner can set the withdrawal publisher address"
509         );
510         address oldValue = _withdrawalPublisher;
511         _withdrawalPublisher = newWithdrawalPublisher;
512 
513         emit WithdrawalPublisherUpdate(oldValue, _withdrawalPublisher);
514     }
515 
516     /**
517      * @notice Updates the Fallback Publisher address, the only address other than
518      * the owner that can publish / remove fallback withdrawal Merkle tree roots.
519      * @param newFallbackPublisher The address of the new Fallback Publisher
520      */
521     function setFallbackPublisher(address newFallbackPublisher) external {
522         require(
523             msg.sender == _owner,
524             "Only the owner can set the fallback publisher address"
525         );
526         address oldValue = _fallbackPublisher;
527         _fallbackPublisher = newFallbackPublisher;
528 
529         emit FallbackPublisherUpdate(oldValue, _fallbackPublisher);
530     }
531 
532     /**
533      * @notice Updates the Immediately Withdrawable Limit Publisher address, the only address
534      * other than the owner that can set the immediately withdrawable limit.
535      * @param newImmediatelyWithdrawableLimitPublisher The address of the new Immediately
536      * Withdrawable Limit Publisher
537      */
538     function setImmediatelyWithdrawableLimitPublisher(
539       address newImmediatelyWithdrawableLimitPublisher
540     ) external {
541         require(
542             msg.sender == _owner,
543             "Only the owner can set the immediately withdrawable limit publisher address"
544         );
545         address oldValue = _immediatelyWithdrawableLimitPublisher;
546         _immediatelyWithdrawableLimitPublisher = newImmediatelyWithdrawableLimitPublisher;
547 
548         emit ImmediatelyWithdrawableLimitPublisherUpdate(
549           oldValue,
550           _immediatelyWithdrawableLimitPublisher
551         );
552     }
553 
554     /**
555      * @notice Modifies the immediately withdrawable limit (the maximum amount that
556      * can be withdrawn from withdrawal authorization roots before the limit needs
557      * to be updated by Flexa) by the provided amount.
558      * If negative, it will be decreased, if positive, increased.
559      * This is to prevent contract funds from being drained by error or publisher malice.
560      * This does not affect the fallback withdrawal mechanism.
561      * @param amount amount to modify the limit by.
562      */
563     function modifyImmediatelyWithdrawableLimit(int256 amount) external {
564         require(
565             msg.sender == _owner || msg.sender == _immediatelyWithdrawableLimitPublisher,
566             "Only the immediately withdrawable limit publisher and owner can modify the immediately withdrawable limit"
567         );
568         uint256 oldLimit = _immediatelyWithdrawableLimit;
569 
570         if (amount < 0) {
571             uint256 unsignedAmount = uint256(-amount);
572             _immediatelyWithdrawableLimit = SafeMath.sub(_immediatelyWithdrawableLimit, unsignedAmount);
573         } else {
574             uint256 unsignedAmount = uint256(amount);
575             _immediatelyWithdrawableLimit = SafeMath.add(_immediatelyWithdrawableLimit, unsignedAmount);
576         }
577 
578         emit ImmediatelyWithdrawableLimitUpdate(oldLimit, _immediatelyWithdrawableLimit);
579     }
580 
581     /**
582      * @notice Updates the time-lock period for a fallback withdrawal to be permitted if no
583      * action is taken by Flexa.
584      * @param newFallbackDelaySeconds The new delay period in seconds.
585      */
586     function setFallbackWithdrawalDelay(uint256 newFallbackDelaySeconds) external {
587         require(
588             msg.sender == _owner,
589             "Only the owner can set the fallback withdrawal delay"
590         );
591         require(
592             newFallbackDelaySeconds != 0,
593             "New fallback delay may not be 0"
594         );
595 
596         uint256 oldDelay = _fallbackWithdrawalDelaySeconds;
597         _fallbackWithdrawalDelaySeconds = newFallbackDelaySeconds;
598 
599         emit FallbackWithdrawalDelayUpdate(oldDelay, newFallbackDelaySeconds);
600     }
601 
602     /**
603      * @notice Adds the root hash of a merkle tree containing authorized token withdrawals.
604      * @param root The root hash to be added to the repository.
605      * @param nonce The nonce of the new root hash. Must be exactly one higher
606      * than the existing max nonce.
607      * @param replacedRoots The root hashes to be removed from the repository.
608      */
609     function addWithdrawalRoot(
610         bytes32 root,
611         uint256 nonce,
612         bytes32[] calldata replacedRoots
613     ) external {
614         require(
615             msg.sender == _owner || msg.sender == _withdrawalPublisher,
616             "Only the owner and withdrawal publisher can add and replace withdrawal root hashes"
617         );
618         require(
619             root != 0,
620             "Added root may not be 0"
621         );
622         require(
623             // Overflowing uint256 by incrementing by 1 not plausible and guarded by nonce variable.
624             _maxWithdrawalRootNonce + 1 == nonce,
625             "Nonce must be exactly max nonce + 1"
626         );
627         require(
628             _withdrawalRootToNonce[root] == 0,
629             "Root already exists and is associated with a different nonce"
630         );
631 
632         _withdrawalRootToNonce[root] = nonce;
633         _maxWithdrawalRootNonce = nonce;
634 
635         emit WithdrawalRootHashAddition(root, nonce);
636 
637         for (uint256 i = 0; i < replacedRoots.length; i++) {
638             deleteWithdrawalRoot(replacedRoots[i]);
639         }
640     }
641 
642     /**
643      * @notice Removes root hashes of a merkle trees containing authorized
644      * token withdrawals.
645      * @param roots The root hashes to be removed from the repository.
646      */
647     function removeWithdrawalRoots(bytes32[] calldata roots) external {
648         require(
649             msg.sender == _owner || msg.sender == _withdrawalPublisher,
650             "Only the owner and withdrawal publisher can remove withdrawal root hashes"
651         );
652 
653         for (uint256 i = 0; i < roots.length; i++) {
654             deleteWithdrawalRoot(roots[i]);
655         }
656     }
657 
658     /**
659      * @notice Resets the _fallbackSetDate to the current block's timestamp.
660      * This is mainly used to deactivate the fallback mechanism so new
661      * fallback roots may be published.
662      */
663     function resetFallbackMechanismDate() external {
664         require(
665             msg.sender == _owner || msg.sender == _fallbackPublisher,
666             "Only the owner and fallback publisher can reset fallback mechanism date"
667         );
668 
669         _fallbackSetDate = block.timestamp;
670 
671         emit FallbackMechanismDateReset(_fallbackSetDate);
672     }
673 
674     /**
675      * @notice Sets the root hash of the Merkle tree containing fallback
676      * withdrawal authorizations. This is used in scenarios where the contract
677      * owner has stopped interacting with the contract, and therefore is no
678      * longer honoring requests to unlock funds. After the configured fallback
679      * delay elapses, the withdrawal authorizations included in the supplied
680      * Merkle tree can be executed to recover otherwise locked funds.
681      * @param root The root hash to be saved as the fallback withdrawal
682      * authorizations.
683      * @param maxDepositIncluded The max deposit nonce represented in this root.
684      */
685     function setFallbackRoot(bytes32 root, uint256 maxDepositIncluded) external {
686         require(
687             msg.sender == _owner || msg.sender == _fallbackPublisher,
688             "Only the owner and fallback publisher can set the fallback root hash"
689         );
690         require(
691             root != 0,
692             "New root may not be 0"
693         );
694         require(
695             SafeMath.add(_fallbackSetDate, _fallbackWithdrawalDelaySeconds) > block.timestamp,
696             "Cannot set fallback root while fallback mechanism is active"
697         );
698         require(
699             maxDepositIncluded >= _fallbackMaxDepositIncluded,
700             "Max deposit included must remain the same or increase"
701         );
702         require(
703             maxDepositIncluded <= _depositNonce,
704             "Cannot invalidate future deposits"
705         );
706 
707         _fallbackRoot = root;
708         _fallbackMaxDepositIncluded = maxDepositIncluded;
709         _fallbackSetDate = block.timestamp;
710 
711         emit FallbackRootHashSet(
712             root,
713             _fallbackMaxDepositIncluded,
714             block.timestamp
715         );
716     }
717 
718     /**
719      * @notice Deletes the provided root from the collection of
720      * withdrawal authorization merkle tree roots, invalidating the
721      * withdrawals contained in the tree assocated with this root.
722      * @param root The root hash to delete.
723      */
724     function deleteWithdrawalRoot(bytes32 root) private {
725         uint256 nonce = _withdrawalRootToNonce[root];
726 
727         require(
728             nonce > 0,
729             "Root hash not set"
730         );
731 
732         delete _withdrawalRootToNonce[root];
733 
734         emit WithdrawalRootHashRemoval(root, nonce);
735     }
736 
737     /**
738      * @notice Calculates the Merkle root for the unique Merkle tree described by the provided
739        Merkle proof and leaf hash.
740      * @param merkleProof The sibling node hashes at each level of the tree.
741      * @param leafHash The hash of the leaf data for which merkleProof is an inclusion proof.
742      * @return The calculated Merkle root.
743      */
744     function calculateMerkleRoot(
745         bytes32[] memory merkleProof,
746         bytes32 leafHash
747     ) private pure returns (bytes32) {
748         bytes32 computedHash = leafHash;
749 
750         for (uint256 i = 0; i < merkleProof.length; i++) {
751             bytes32 proofElement = merkleProof[i];
752 
753             if (computedHash < proofElement) {
754                 computedHash = keccak256(abi.encodePacked(
755                     computedHash,
756                     proofElement
757                 ));
758             } else {
759                 computedHash = keccak256(abi.encodePacked(
760                     proofElement,
761                     computedHash
762                 ));
763             }
764         }
765 
766         return computedHash;
767     }
768 }