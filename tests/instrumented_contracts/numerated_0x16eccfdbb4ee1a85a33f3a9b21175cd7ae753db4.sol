1 // File: contracts/SafeMath.sol
2 
3 pragma solidity >=0.5.16;
4 
5 // From https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/Math.sol
6 // Subject to the MIT license.
7 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the addition of two unsigned integers, reverting with custom message on overflow.
39      *
40      * Counterpart to Solidity's `+` operator.
41      *
42      * Requirements:
43      * - Addition cannot overflow.
44      */
45     function add(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, errorMessage);
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting on underflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      * - Subtraction cannot underflow.
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction underflow");
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on underflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      * - Subtraction cannot underflow.
71      */
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the multiplication of two unsigned integers, reverting on overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      * - Multiplication cannot overflow.
108      */
109     function mul(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111         // benefit is lost if 'b' is also tested.
112         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
113         if (a == 0) {
114             return 0;
115         }
116 
117         uint256 c = a * b;
118         require(c / a == b, errorMessage);
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers.
125      * Reverts on division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers.
140      * Reverts with custom message on division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 // File: contracts/NativeMetaTransaction/Initializable.sol
191 
192 pragma solidity >= 0.6.6;
193 
194 contract Initializable {
195     bool inited = false;
196 
197     modifier initializer() {
198         require(!inited, "already inited");
199         _;
200         inited = true;
201     }
202 }
203 
204 // File: contracts/NativeMetaTransaction/EIP712Base.sol
205 
206 pragma solidity >= 0.6.6;
207 
208 
209 contract EIP712Base is Initializable {
210     struct EIP712Domain {
211         string name;
212         string version;
213         address verifyingContract;
214         uint256 chainId;
215     }
216 
217     string constant public ERC712_VERSION = "1";
218 
219     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
220         bytes(
221             "EIP712Domain(string name,string version,address verifyingContract,uint256 chainId)"
222         )
223     );
224     bytes32 internal domainSeperator;
225 
226     // supposed to be called once while initializing.
227     // one of the contractsa that inherits this contract follows proxy pattern
228     // so it is not possible to do this in a constructor
229     function _initializeEIP712(
230         string memory name
231     )
232         internal
233         initializer
234     {
235         _setDomainSeperator(name);
236     }
237 
238     function _setDomainSeperator(string memory name) internal {
239         domainSeperator = keccak256(
240             abi.encode(
241                 EIP712_DOMAIN_TYPEHASH,
242                 keccak256(bytes(name)),
243                 keccak256(bytes(ERC712_VERSION)),
244                 address(this),
245                 getChainId()
246             )
247         );
248     }
249 
250     function getDomainSeperator() public view returns (bytes32) {
251         return domainSeperator;
252     }
253 
254     function getChainId() public pure returns (uint256) {
255         uint256 id;
256         assembly {
257             id := chainid()
258         }
259         return id;
260     }
261 
262     /**
263      * Accept message hash and returns hash message in EIP712 compatible form
264      * So that it can be used to recover signer from signature signed using EIP712 formatted data
265      * https://eips.ethereum.org/EIPS/eip-712
266      * "\\x19" makes the encoding deterministic
267      * "\\x01" is the version byte to make it compatible to EIP-191
268      */
269     function toTypedMessageHash(bytes32 messageHash)
270         internal
271         view
272         returns (bytes32)
273     {
274         return
275             keccak256(
276                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
277             );
278     }
279 }
280 
281 // File: contracts/NativeMetaTransaction/NativeMetaTransaction.sol
282 
283 pragma solidity >= 0.6.6;
284 
285 
286 
287 contract NativeMetaTransaction is EIP712Base {
288     using SafeMath for uint;
289     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
290         bytes(
291             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
292         )
293     );
294     event MetaTransactionExecuted(
295         address userAddress,
296         address payable relayerAddress,
297         bytes functionSignature
298     );
299     mapping(address => uint256) public nonces;
300 
301     /*
302      * Meta transaction structure.
303      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
304      * He should call the desired function directly in that case.
305      */
306     struct MetaTransaction {
307         uint256 nonce;
308         address from;
309         bytes functionSignature;
310     }
311 
312     function executeMetaTransaction(
313         address userAddress,
314         bytes memory functionSignature,
315         bytes32 sigR,
316         bytes32 sigS,
317         uint8 sigV
318     ) public payable returns (bytes memory) {
319         MetaTransaction memory metaTx = MetaTransaction({
320             nonce: nonces[userAddress],
321             from: userAddress,
322             functionSignature: functionSignature
323         });
324 
325         require(
326             verify(userAddress, metaTx, sigR, sigS, sigV),
327             "Signer and signature do not match"
328         );
329 
330         // increase nonce for user (to avoid re-use)
331         nonces[userAddress] = nonces[userAddress].add(1);
332 
333         emit MetaTransactionExecuted(
334             userAddress,
335             msg.sender,
336             functionSignature
337         );
338 
339         // Append userAddress and relayer address at the end to extract it from calling context
340         (bool success, bytes memory returnData) = address(this).call(
341             abi.encodePacked(functionSignature, userAddress)
342         );
343         require(success, "Function call not successful");
344 
345         return returnData;
346     }
347 
348     function hashMetaTransaction(MetaTransaction memory metaTx)
349         internal
350         pure
351         returns (bytes32)
352     {
353         return
354             keccak256(
355                 abi.encode(
356                     META_TRANSACTION_TYPEHASH,
357                     metaTx.nonce,
358                     metaTx.from,
359                     keccak256(metaTx.functionSignature)
360                 )
361             );
362     }
363 
364     function getNonce(address user) public view returns (uint256 nonce) {
365         nonce = nonces[user];
366     }
367 
368     function verify(
369         address signer,
370         MetaTransaction memory metaTx,
371         bytes32 sigR,
372         bytes32 sigS,
373         uint8 sigV
374     ) internal view returns (bool) {
375         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
376         return
377             signer ==
378             ecrecover(
379                 toTypedMessageHash(hashMetaTransaction(metaTx)),
380                 sigV,
381                 sigR,
382                 sigS
383             );
384     }
385 
386     function _msgSender() internal view returns (address payable sender) {
387         if(msg.sender == address(this)) {
388             bytes memory array = msg.data;
389             uint256 index = msg.data.length;
390             assembly {
391                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
392                 sender := and(mload(add(array, index)), 0xffffffffffffffffffffffffffffffffffffffff)
393             }
394         } else {
395             sender = msg.sender;
396         }
397         return sender;
398     }
399 
400 }
401 
402 // File: contracts/Route.sol
403 
404 pragma solidity >=0.6.6;
405 pragma experimental ABIEncoderV2;
406 
407 
408 
409 contract Route is NativeMetaTransaction {
410     // @notice EIP-20 token name for this token
411     string public constant name = "Route";
412 
413     // @notice EIP-20 token symbol for this token
414     string public constant symbol = "ROUTE";
415 
416     // @notice EIP-20 token decimals for this token
417     uint8 public constant decimals = 18;
418 
419     // @notice Total number of tokens in circulation
420     uint public totalSupply = 20_000_000e18; // 20 Million Route Tokens
421 
422     // @notice Allowance amounts on behalf of others
423     mapping (address => mapping (address => uint256)) internal allowances;
424 
425     // @notice Official record of token balances for each account
426     mapping (address => uint256) internal balances;
427 
428     // @notice A record of each accounts delegate
429     mapping (address => address) public delegates;
430 
431     // @notice A checkpoint for marking number of votes from a given block
432     struct Checkpoint {
433         uint32 fromBlock;
434         uint256 votes;
435     }
436 
437     // @notice A record of votes checkpoints for each account, by index
438     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
439 
440     // @notice The number of checkpoints for each account
441     mapping (address => uint32) public numCheckpoints;
442 
443     // @notice The EIP-712 typehash for the contract's domain
444     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
445 
446     // @notice The EIP-712 typehash for the delegation struct used by the contract
447     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
448 
449     // @notice The EIP-712 typehash for the permit struct used by the contract
450     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
451 
452     // // @notice A record of states for signing / validating signatures
453     // mapping (address => uint) public nonces;
454 
455     // @notice An event thats emitted when an account changes its delegate
456     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
457 
458     // @notice An event thats emitted when a delegate account's vote balance changes
459     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
460 
461     // @notice The standard EIP-20 transfer event
462     event Transfer(address indexed from, address indexed to, uint256 amount);
463 
464     // @notice The standard EIP-20 approval event
465     event Approval(address indexed owner, address indexed spender, uint256 amount);
466 
467     /**
468      * @notice Construct a new Route token
469      */
470     constructor() public {
471         balances[_msgSender()] = uint256(totalSupply);
472         emit Transfer(address(0), _msgSender(), totalSupply);
473     }
474 
475     /**
476      * @notice Get the number of tokens `spender` is approved to spend on behalf of `account`
477      * @param account The address of the account holding the funds
478      * @param spender The address of the account spending the funds
479      * @return The number of tokens approved
480      */
481     function allowance(address account, address spender) external view returns (uint) {
482         return allowances[account][spender];
483     }
484 
485     /**
486      * @notice Approve `spender` to transfer up to `amount` from `src`
487      * @dev This will overwrite the approval amount for `spender`
488      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
489      * @param spender The address of the account which may transfer tokens
490      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
491      * @return Whether or not the approval succeeded
492      */
493     function approve(address spender, uint rawAmount) external returns (bool) {
494         uint256 amount;
495         if (rawAmount == uint(-1)) {
496             amount = uint256(-1);
497         } else {
498             amount = safe256(rawAmount, "Route::approve: amount exceeds 96 bits");
499         }
500 
501         allowances[_msgSender()][spender] = amount;
502 
503         emit Approval(_msgSender(), spender, amount);
504         return true;
505     }
506 
507     /**
508      * @notice Triggers an approval from owner to spends
509      * @param owner The address to approve from
510      * @param spender The address to be approved
511      * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
512      * @param deadline The time at which to expire the signature
513      * @param v The recovery byte of the signature
514      * @param r Half of the ECDSA signature pair
515      * @param s Half of the ECDSA signature pair
516      */
517     function permit(address owner, address spender, uint rawAmount, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
518         uint256 amount;
519         if (rawAmount == uint(-1)) {
520             amount = uint256(-1);
521         } else {
522             amount = safe256(rawAmount, "Route::permit: amount exceeds 96 bits");
523         }
524 
525         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
526         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, rawAmount, nonces[owner]++, deadline));
527         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
528         address signatory = ecrecover(digest, v, r, s);
529         require(signatory != address(0), "Route::permit: invalid signature");
530         require(signatory == owner, "Route::permit: unauthorized");
531         require(block.timestamp <= deadline, "Route::permit: signature expired");
532 
533         allowances[owner][spender] = amount;
534 
535         emit Approval(owner, spender, amount);
536     }
537 
538     /**
539      * @notice Get the number of tokens held by the `account`
540      * @param account The address of the account to get the balance of
541      * @return The number of tokens held
542      */
543     function balanceOf(address account) external view returns (uint) {
544         return balances[account];
545     }
546 
547     /**
548      * @notice Transfer `amount` tokens from `_msgSender()` to `dst`
549      * @param dst The address of the destination account
550      * @param rawAmount The number of tokens to transfer
551      * @return Whether or not the transfer succeeded
552      */
553     function transfer(address dst, uint rawAmount) external returns (bool) {
554         uint256 amount = safe256(rawAmount, "Route::transfer: amount exceeds 96 bits");
555         _transferTokens(_msgSender(), dst, amount);
556         return true;
557     }
558 
559     /**
560      * @notice Transfer `amount` tokens from `src` to `dst`
561      * @param src The address of the source account
562      * @param dst The address of the destination account
563      * @param rawAmount The number of tokens to transfer
564      * @return Whether or not the transfer succeeded
565      */
566     function transferFrom(address src, address dst, uint rawAmount) external returns (bool) {
567         address spender = _msgSender();
568         uint256 spenderAllowance = allowances[src][spender];
569         uint256 amount = safe256(rawAmount, "Route::approve: amount exceeds 96 bits");
570 
571         if (spender != src && spenderAllowance != uint256(-1)) {
572             uint256 newAllowance = sub256(spenderAllowance, amount, "Route::transferFrom: transfer amount exceeds spender allowance");
573             allowances[src][spender] = newAllowance;
574 
575             emit Approval(src, spender, newAllowance);
576         }
577 
578         _transferTokens(src, dst, amount);
579         return true;
580     }
581 
582     /**
583      * @notice Delegate votes from `_msgSender()` to `delegatee`
584      * @param delegatee The address to delegate votes to
585      */
586     function delegate(address delegatee) public {
587         return _delegate(_msgSender(), delegatee);
588     }
589 
590     /**
591      * @notice Delegates votes from signatory to `delegatee`
592      * @param delegatee The address to delegate votes to
593      * @param nonce The contract state required to match the signature
594      * @param expiry The time at which to expire the signature
595      * @param v The recovery byte of the signature
596      * @param r Half of the ECDSA signature pair
597      * @param s Half of the ECDSA signature pair
598      */
599     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
600         bytes32 domainSeparator = keccak256(abi.encode(DOMAIN_TYPEHASH, keccak256(bytes(name)), getChainId(), address(this)));
601         bytes32 structHash = keccak256(abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry));
602         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
603         address signatory = ecrecover(digest, v, r, s);
604         require(signatory != address(0), "Route::delegateBySig: invalid signature");
605         require(nonce == nonces[signatory]++, "Route::delegateBySig: invalid nonce");
606         require(block.timestamp <= expiry, "Route::delegateBySig: signature expired");
607         return _delegate(signatory, delegatee);
608     }
609 
610     /**
611      * @notice Gets the current votes balance for `account`
612      * @param account The address to get votes balance
613      * @return The number of current votes for `account`
614      */
615     function getCurrentVotes(address account) external view returns (uint256) {
616         uint32 nCheckpoints = numCheckpoints[account];
617         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
618     }
619 
620     /**
621      * @notice Determine the prior number of votes for an account as of a block number
622      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
623      * @param account The address of the account to check
624      * @param blockNumber The block number to get the vote balance at
625      * @return The number of votes the account had as of the given block
626      */
627     function getPriorVotes(address account, uint blockNumber) public view returns (uint256) {
628         require(blockNumber < block.number, "Route::getPriorVotes: not yet determined");
629 
630         uint32 nCheckpoints = numCheckpoints[account];
631         if (nCheckpoints == 0) {
632             return 0;
633         }
634 
635         // First check most recent balance
636         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
637             return checkpoints[account][nCheckpoints - 1].votes;
638         }
639 
640         // Next check implicit zero balance
641         if (checkpoints[account][0].fromBlock > blockNumber) {
642             return 0;
643         }
644 
645         uint32 lower = 0;
646         uint32 upper = nCheckpoints - 1;
647         while (upper > lower) {
648             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
649             Checkpoint memory cp = checkpoints[account][center];
650             if (cp.fromBlock == blockNumber) {
651                 return cp.votes;
652             } else if (cp.fromBlock < blockNumber) {
653                 lower = center;
654             } else {
655                 upper = center - 1;
656             }
657         }
658         return checkpoints[account][lower].votes;
659     }
660 
661     function _delegate(address delegator, address delegatee) internal {
662         address currentDelegate = delegates[delegator];
663         uint256 delegatorBalance = balances[delegator];
664         delegates[delegator] = delegatee;
665 
666         emit DelegateChanged(delegator, currentDelegate, delegatee);
667 
668         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
669     }
670 
671     function _transferTokens(address src, address dst, uint256 amount) internal {
672         require(src != address(0), "Route::_transferTokens: cannot transfer from the zero address");
673         require(dst != address(0), "Route::_transferTokens: cannot transfer to the zero address");
674 
675         balances[src] = sub256(balances[src], amount, "Route::_transferTokens: transfer amount exceeds balance");
676         balances[dst] = add256(balances[dst], amount, "Route::_transferTokens: transfer amount overflows");
677         emit Transfer(src, dst, amount);
678 
679         _moveDelegates(delegates[src], delegates[dst], amount);
680     }
681 
682     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
683         if (srcRep != dstRep && amount > 0) {
684             if (srcRep != address(0)) {
685                 uint32 srcRepNum = numCheckpoints[srcRep];
686                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
687                 uint256 srcRepNew = sub256(srcRepOld, amount, "Route::_moveVotes: vote amount underflows");
688                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
689             }
690 
691             if (dstRep != address(0)) {
692                 uint32 dstRepNum = numCheckpoints[dstRep];
693                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
694                 uint256 dstRepNew = add256(dstRepOld, amount, "Route::_moveVotes: vote amount overflows");
695                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
696             }
697         }
698     }
699 
700     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {
701       uint32 blockNumber = safe32(block.number, "Route::_writeCheckpoint: block number exceeds 32 bits");
702 
703       if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
704           checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
705       } else {
706           checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
707           numCheckpoints[delegatee] = nCheckpoints + 1;
708       }
709 
710       emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
711     }
712 
713     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
714         require(n < 2**32, errorMessage);
715         return uint32(n);
716     }
717 
718     function safe256(uint n, string memory errorMessage) internal pure returns (uint256) {
719         return uint256(n);
720     }
721 
722     function add256(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
723         uint256 c = a + b;
724         require(c >= a, errorMessage);
725         return c;
726     }
727 
728     function sub256(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
729         require(b <= a, errorMessage);
730         return a - b;
731     }
732 }