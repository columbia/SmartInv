1 // =================================================================================================================
2 //  _|_|_|    _|_|_|_|  _|    _|    _|_|_|      _|_|_|_|  _|                                                       |
3 //  _|    _|  _|        _|    _|  _|            _|            _|_|_|      _|_|_|  _|_|_|      _|_|_|    _|_|       |
4 //  _|    _|  _|_|_|    _|    _|    _|_|        _|_|_|    _|  _|    _|  _|    _|  _|    _|  _|        _|_|_|_|     |
5 //  _|    _|  _|        _|    _|        _|      _|        _|  _|    _|  _|    _|  _|    _|  _|        _|           |
6 //  _|_|_|    _|_|_|_|    _|_|    _|_|_|        _|        _|  _|    _|    _|_|_|  _|    _|    _|_|_|    _|_|_|     |
7 // =================================================================================================================
8 //                         %@(                                                @@@                       
9 //                       @@@@@@@                                      @@@@@@@@@@@@@@@@@@@               
10 //                       @@@@@@@                                   @@@@@@@@         *@@@@@@@(           
11 //                    #@@@ @@@,@@@,                             @@@@@@                   @@@@@@         
12 //                  @@@@   @@@   @@@@                  @@@@@@@@@@@@@                       @@@@@@@@@@@@@
13 //               #@@@.     @@@     *@@@,               @@@@@@@@@@@                           @@@@@@@@@@@
14 //             @@@@        @@@        @@@@                   @@@@            @@@@@            @@@@      
15 //          (@@@.          @@@          ,@@@,               @@@@@          @@@@@@@@@          (@@@@     
16 //        @@@@            .@@@             @@@@             @@@@.          @@@@@@@@@           @@@@     
17 //  @@@@@@@              @@@@@@&             ,@@@@@@&       *@@@@           @@@@@@@           @@@@&     
18 // @@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@.@@@@@@@@@@@@        @@@@@                            @@@@      
19 //  (@@@@@@,  *@@@@@@@            ,@@@@@@@,  /@@@@@@.  @@@@@@@@@@@@                         @@@@@@@@@@@@
20 //        @@@@    @@@@             @@@&    @@@@        @@@@@@@@@@@@@@                     @@@@@@@@@@@@@@
21 //          .@@@,   @@@          .@@&   (@@@                     @@@@@@@               @@@@@@@          
22 //             @@@@  (@@*       @@@.  @@@@                          @@@@@@@@@@@@@@@@@@@@@@@             
23 //               ,@@@. @@@     @@@ /@@@                                  @@@@@@@@@@@@@                  
24 //                  @@@@@@@   @@@@@@@                
25 //                    .@@@@@ @@@@@                   
26 //                       @@@@@@@                     
27 //                       @@@@@@@
28 // ======================= DEUS Bridge ======================
29 // ==========================================================
30 // DEUS Finance: https://github.com/DeusFinance
31 
32 // Primary Author(s)
33 // Sadegh: https://github.com/sadeghte
34 // Reza: https://github.com/bakhshandeh
35 // Vahid: https://github.com/vahid-dev
36 // Mahdi: https://github.com/Mahdi-HF
37 // File: @openzeppelin/contracts/utils/Context.sol
38 
39 // SPDX-License-Identifier: MIT
40 
41 pragma solidity ^0.8.0;
42 
43 /*
44  * @dev Provides information about the current execution context, including the
45  * sender of the transaction and its data. While these are generally available
46  * via msg.sender and msg.data, they should not be accessed in such a direct
47  * manner, since when dealing with meta-transactions the account sending and
48  * paying for execution may not be the actual sender (as far as an application
49  * is concerned).
50  *
51  * This contract is only required for intermediate, library-like contracts.
52  */
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 
58     function _msgData() internal view virtual returns (bytes calldata) {
59         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
60         return msg.data;
61     }
62 }
63 
64 // File: @openzeppelin/contracts/access/Ownable.sol
65 
66 
67 
68 pragma solidity ^0.8.0;
69 
70 /**
71  * @dev Contract module which provides a basic access control mechanism, where
72  * there is an account (an owner) that can be granted exclusive access to
73  * specific functions.
74  *
75  * By default, the owner account will be the one that deploys the contract. This
76  * can later be changed with {transferOwnership}.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 abstract contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     /**
97      * @dev Returns the address of the current owner.
98      */
99     function owner() public view virtual returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if called by any account other than the owner.
105      */
106     modifier onlyOwner() {
107         require(owner() == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     /**
112      * @dev Leaves the contract without owner. It will not be possible to call
113      * `onlyOwner` functions anymore. Can only be called by the current owner.
114      *
115      * NOTE: Renouncing ownership will leave the contract without an owner,
116      * thereby removing any functionality that is only available to the owner.
117      */
118     function renounceOwnership() public virtual onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         emit OwnershipTransferred(_owner, newOwner);
130         _owner = newOwner;
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
135 
136 
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
142  *
143  * These functions can be used to verify that a message was signed by the holder
144  * of the private keys of a given address.
145  */
146 library ECDSA {
147     /**
148      * @dev Returns the address that signed a hashed message (`hash`) with
149      * `signature`. This address can then be used for verification purposes.
150      *
151      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
152      * this function rejects them by requiring the `s` value to be in the lower
153      * half order, and the `v` value to be either 27 or 28.
154      *
155      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
156      * verification to be secure: it is possible to craft signatures that
157      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
158      * this is by receiving a hash of the original message (which may otherwise
159      * be too long), and then calling {toEthSignedMessageHash} on it.
160      */
161     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
162         // Divide the signature in r, s and v variables
163         bytes32 r;
164         bytes32 s;
165         uint8 v;
166 
167         // Check the signature length
168         // - case 65: r,s,v signature (standard)
169         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
170         if (signature.length == 65) {
171             // ecrecover takes the signature parameters, and the only way to get them
172             // currently is to use assembly.
173             // solhint-disable-next-line no-inline-assembly
174             assembly {
175                 r := mload(add(signature, 0x20))
176                 s := mload(add(signature, 0x40))
177                 v := byte(0, mload(add(signature, 0x60)))
178             }
179         } else if (signature.length == 64) {
180             // ecrecover takes the signature parameters, and the only way to get them
181             // currently is to use assembly.
182             // solhint-disable-next-line no-inline-assembly
183             assembly {
184                 let vs := mload(add(signature, 0x40))
185                 r := mload(add(signature, 0x20))
186                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
187                 v := add(shr(255, vs), 27)
188             }
189         } else {
190             revert("ECDSA: invalid signature length");
191         }
192 
193         return recover(hash, v, r, s);
194     }
195 
196     /**
197      * @dev Overload of {ECDSA-recover} that receives the `v`,
198      * `r` and `s` signature fields separately.
199      */
200     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
201         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
202         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
203         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
204         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
205         //
206         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
207         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
208         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
209         // these malleable signatures as well.
210         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
211         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
212 
213         // If the signature is valid (and not malleable), return the signer address
214         address signer = ecrecover(hash, v, r, s);
215         require(signer != address(0), "ECDSA: invalid signature");
216 
217         return signer;
218     }
219 
220     /**
221      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
222      * produces hash corresponding to the one signed with the
223      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
224      * JSON-RPC method as part of EIP-191.
225      *
226      * See {recover}.
227      */
228     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
229         // 32 is the length in bytes of hash,
230         // enforced by the type signature above
231         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
232     }
233 
234     /**
235      * @dev Returns an Ethereum Signed Typed Data, created from a
236      * `domainSeparator` and a `structHash`. This produces hash corresponding
237      * to the one signed with the
238      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
239      * JSON-RPC method as part of EIP-712.
240      *
241      * See {recover}.
242      */
243     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
244         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
245     }
246 }
247 
248 // File: @openzeppelin/contracts/security/Pausable.sol
249 
250 
251 
252 pragma solidity ^0.8.0;
253 
254 
255 /**
256  * @dev Contract module which allows children to implement an emergency stop
257  * mechanism that can be triggered by an authorized account.
258  *
259  * This module is used through inheritance. It will make available the
260  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
261  * the functions of your contract. Note that they will not be pausable by
262  * simply including this module, only once the modifiers are put in place.
263  */
264 abstract contract Pausable is Context {
265     /**
266      * @dev Emitted when the pause is triggered by `account`.
267      */
268     event Paused(address account);
269 
270     /**
271      * @dev Emitted when the pause is lifted by `account`.
272      */
273     event Unpaused(address account);
274 
275     bool private _paused;
276 
277     /**
278      * @dev Initializes the contract in unpaused state.
279      */
280     constructor () {
281         _paused = false;
282     }
283 
284     /**
285      * @dev Returns true if the contract is paused, and false otherwise.
286      */
287     function paused() public view virtual returns (bool) {
288         return _paused;
289     }
290 
291     /**
292      * @dev Modifier to make a function callable only when the contract is not paused.
293      *
294      * Requirements:
295      *
296      * - The contract must not be paused.
297      */
298     modifier whenNotPaused() {
299         require(!paused(), "Pausable: paused");
300         _;
301     }
302 
303     /**
304      * @dev Modifier to make a function callable only when the contract is paused.
305      *
306      * Requirements:
307      *
308      * - The contract must be paused.
309      */
310     modifier whenPaused() {
311         require(paused(), "Pausable: not paused");
312         _;
313     }
314 
315     /**
316      * @dev Triggers stopped state.
317      *
318      * Requirements:
319      *
320      * - The contract must not be paused.
321      */
322     function _pause() internal virtual whenNotPaused {
323         _paused = true;
324         emit Paused(_msgSender());
325     }
326 
327     /**
328      * @dev Returns to normal state.
329      *
330      * Requirements:
331      *
332      * - The contract must be paused.
333      */
334     function _unpause() internal virtual whenPaused {
335         _paused = false;
336         emit Unpaused(_msgSender());
337     }
338 }
339 
340 // File: contracts/interfaces/IMuonV02.sol
341 
342 pragma solidity >=0.7.0 <0.9.0;
343 
344 struct SchnorrSign {
345     uint256 signature;
346     address owner;
347     address nonce;
348 }
349 
350 interface IMuonV02{
351     function verify(bytes calldata reqId, uint256 hash, SchnorrSign[] calldata _sigs) external returns (bool);
352 }
353 
354 // File: contracts/interfaces/IDeusBridge.sol
355 
356 pragma solidity >=0.8.0 <=0.9.0;
357 
358 
359 struct Transaction {
360     uint txId;
361     uint tokenId;
362     uint amount;
363     uint fromChain;
364     uint toChain;
365     address user;
366     uint txBlockNo;
367 }
368 
369 interface IDeusBridge {
370 	/* ========== STATE VARIABLES ========== */
371 	
372     function lastTxId() external view returns (uint);
373     function network() external view returns (uint);
374     function minReqSigs() external view returns (uint);
375     function scale() external view returns (uint);
376     function bridgeReserve() external view returns (uint);
377     function muonContract() external view returns (address);
378     function deiAddress() external view returns (address);
379     function mintable() external view returns (bool);
380     function ETH_APP_ID() external view returns (uint8);
381     function sideContracts(uint) external view returns (address);
382     function tokens(uint) external view returns (address);
383     function claimedTxs(uint, uint) external view returns (bool);
384     function fee(uint) external view returns (uint);
385     function collectedFee(uint) external view returns (uint);
386 
387 	/* ========== PUBLIC FUNCTIONS ========== */
388 	function deposit(
389 		uint amount, 
390 		uint toChain,
391 		uint tokenId
392 	) external returns (uint txId);
393 	function depositFor(
394 		address user,
395 		uint amount, 
396 		uint toChain,
397 		uint tokenId
398 	) external returns (uint txId);
399 	function deposit(
400 		uint amount, 
401 		uint toChain,
402 		uint tokenId,
403 		uint referralCode
404 	) external returns (uint txId);
405 	function depositFor(
406 		address user,
407 		uint amount, 
408 		uint toChain,
409 		uint tokenId,
410 		uint referralCode
411 	) external returns (uint txId);
412 	function claim(
413         address user,
414         uint amount,
415         uint fromChain,
416         uint toChain,
417         uint tokenId,
418         uint txId,
419         bytes calldata _reqId,
420         SchnorrSign[] calldata sigs
421     ) external;
422 
423 	/* ========== VIEWS ========== */
424 	function collatDollarBalance(uint collat_usd_price) external view returns (uint);
425 	function pendingTxs(
426 		uint fromChain, 
427 		uint[] calldata ids
428 	) external view returns (bool[] memory unclaimedIds);
429 	function getUserTxs(
430 		address user, 
431 		uint toChain
432 	) external view returns (uint[] memory);
433 	function getTransaction(uint txId_) external view returns (
434 		uint txId,
435 		uint tokenId,
436 		uint amount,
437 		uint fromChain,
438 		uint toChain,
439 		address user,
440 		uint txBlockNo,
441 		uint currentBlockNo
442 	);
443 	function getExecutingChainID() external view returns (uint);
444 
445 	/* ========== RESTRICTED FUNCTIONS ========== */
446 	function setBridgeReserve(uint bridgeReserve_) external;
447 	function setToken(uint tokenId, address tokenAddress) external;
448 	function setNetworkID(uint network_) external;
449 	function setFee(uint tokenId, uint fee_) external;
450 	function setDeiAddress(address deiAddress_) external;
451 	function setMinReqSigs(uint minReqSigs_) external;
452 	function setSideContract(uint network_, address address_) external;
453 	function setMintable(bool mintable_) external;
454 	function setEthAppId(uint8 ethAppId_) external;
455 	function setMuonContract(address muonContract_) external;
456 	function pause() external;
457 	function unpase() external;
458 	function withdrawFee(uint tokenId, address to) external;
459 	function emergencyWithdrawETH(address to, uint amount) external;
460 	function emergencyWithdrawERC20Tokens(address tokenAddr, address to, uint amount) external;
461 }
462 
463 // File: contracts/interfaces/IERC20.sol
464 
465 pragma solidity >=0.8.0 <=0.9.0;
466 
467 interface IERC20 {
468 	function transfer(address recipient, uint256 amount) external;
469 	function transferFrom(address sender, address recipient, uint256 amount) external;
470 	function pool_burn_from(address b_address, uint256 b_amount) external;
471 	function pool_mint(address m_address, uint256 m_amount) external;
472 }
473 
474 // File: contracts/interfaces/IDEIStablecoin.sol
475 
476 pragma solidity >=0.8.0 <=0.9.0;
477 
478 interface IDEIStablecoin {
479 	function global_collateral_ratio() external view returns (uint256);
480 }
481 
482 // File: contracts/DeusBridge.sol
483 
484 
485 pragma solidity ^0.8.10;
486 
487 contract DeusBridge is IDeusBridge, Ownable, Pausable {
488     using ECDSA for bytes32;
489 
490     /* ========== STATE VARIABLES ========== */
491 
492     uint public lastTxId = 0;  // unique id for deposit tx
493     uint public network;  // current chain id
494     uint public minReqSigs;  // minimum required tss
495     uint public scale = 1e6;
496     uint public bridgeReserve;  // it handles buyback & recollaterlize on dei pools
497     address public muonContract;  // muon signature verifier contract
498     address public deiAddress;
499     uint8   public ETH_APP_ID;  // muon's eth app id
500     bool    public mintable;  // use mint functions instead of transfer
501     // we assign a unique ID to each chain (default is CHAIN-ID)
502     mapping (uint => address) public sideContracts;
503     // tokenId => tokenContractAddress
504     mapping(uint => address)  public tokens;
505     mapping(uint => Transaction) private txs;
506     // user => (destination chain => user's txs id)
507     mapping(address => mapping(uint => uint[])) private userTxs;
508     // source chain => (tx id => false/true)
509     mapping(uint => mapping(uint => bool)) public claimedTxs;
510     // tokenId => tokenFee
511     mapping(uint => uint) public fee;
512     // tokenId => collectedFee
513     mapping(uint => uint) public collectedFee;
514 
515     /* ========== EVENTS ========== */
516     event Deposit(
517         address indexed user,
518         uint tokenId,
519         uint amount,
520         uint indexed toChain,
521         uint txId
522     );
523     event DepositWithReferralCode(
524         address indexed user,
525         uint tokenId,
526         uint amount,
527         uint indexed toChain,
528         uint txId,
529         uint referralCode
530     );
531     event Claim(
532         address indexed user,
533         uint tokenId, 
534         uint amount, 
535         uint indexed fromChain, 
536         uint txId
537     );
538     event BridgeReserveSet(uint bridgeReserve, uint _bridgeReserve);
539 
540     /* ========== CONSTRUCTOR ========== */
541 
542     constructor(
543         uint minReqSigs_, 
544         uint bridgeReserve_,
545         uint8 ETH_APP_ID_,
546         address muon_, 
547         address deiAddress_,
548         bool mintable_
549     ) {
550         network = getExecutingChainID();
551         minReqSigs = minReqSigs_;
552         bridgeReserve = bridgeReserve_;
553         ETH_APP_ID = ETH_APP_ID_;
554         muonContract = muon_;
555         deiAddress = deiAddress_;
556         mintable = mintable_;
557     }
558 
559     /* ========== PUBLIC FUNCTIONS ========== */
560 
561     function deposit(
562         uint amount, 
563         uint toChain,
564         uint tokenId
565     ) external returns (uint txId) {
566         txId = _deposit(msg.sender, amount, toChain, tokenId);
567         emit Deposit(msg.sender, tokenId, amount, toChain, txId);
568     }
569 
570     function depositFor(
571         address user,
572         uint amount, 
573         uint toChain,
574         uint tokenId
575     ) external returns (uint txId) {
576         txId = _deposit(user, amount, toChain, tokenId);
577         emit Deposit(user, tokenId, amount, toChain, txId);
578     }
579 
580     function deposit(
581         uint amount, 
582         uint toChain,
583         uint tokenId,
584         uint referralCode
585     ) external returns (uint txId) {
586         txId = _deposit(msg.sender, amount, toChain, tokenId);
587         emit DepositWithReferralCode(msg.sender, tokenId, amount, toChain, txId, referralCode);
588     }
589 
590     function depositFor(
591         address user,
592         uint amount, 
593         uint toChain,
594         uint tokenId,
595         uint referralCode
596     ) external returns (uint txId) {
597         txId = _deposit(user, amount, toChain, tokenId);
598         emit DepositWithReferralCode(user, tokenId, amount, toChain, txId, referralCode);
599     }
600 
601     function _deposit(
602         address user,
603         uint amount,
604         uint toChain,
605         uint tokenId
606     ) 
607         internal 
608         whenNotPaused() 
609         returns (uint txId) 
610     {
611         require(sideContracts[toChain] != address(0), "Bridge: unknown toChain");
612         require(toChain != network, "Bridge: selfDeposit");
613         require(tokens[tokenId] != address(0), "Bridge: unknown tokenId");
614 
615         IERC20 token = IERC20(tokens[tokenId]);
616         if (mintable) {
617             token.pool_burn_from(msg.sender, amount);
618             if (tokens[tokenId] == deiAddress) {
619                 bridgeReserve -= amount;
620             }
621         } else {
622             token.transferFrom(msg.sender, address(this), amount);
623         }
624 
625         if (fee[tokenId] > 0) {
626             uint feeAmount = amount * fee[tokenId] / scale;
627             amount -= feeAmount;
628             collectedFee[tokenId] += feeAmount;
629         }
630 
631         txId = ++lastTxId;
632         txs[txId] = Transaction({
633             txId: txId,
634             tokenId: tokenId,
635             fromChain: network,
636             toChain: toChain,
637             amount: amount,
638             user: user,
639             txBlockNo: block.number
640         });
641         userTxs[user][toChain].push(txId);
642     }
643 
644     function claim(
645         address user,
646         uint amount,
647         uint fromChain,
648         uint toChain,
649         uint tokenId,
650         uint txId,
651         bytes calldata _reqId,
652         SchnorrSign[] calldata sigs
653     ) external {
654         require(sideContracts[fromChain] != address(0), 'Bridge: source contract not exist');
655         require(toChain == network, "Bridge: toChain should equal network");
656         require(sigs.length >= minReqSigs, "Bridge: insufficient number of signatures");
657 
658         {
659             bytes32 hash = keccak256(
660             abi.encodePacked(
661                 abi.encodePacked(sideContracts[fromChain], txId, tokenId, amount),
662                 abi.encodePacked(fromChain, toChain, user, ETH_APP_ID)
663                 )
664             );
665 
666             IMuonV02 muon = IMuonV02(muonContract);
667             require(muon.verify(_reqId, uint(hash), sigs), "Bridge: not verified");
668         }
669 
670         require(!claimedTxs[fromChain][txId], "Bridge: already claimed");
671         require(tokens[tokenId] != address(0), "Bridge: unknown tokenId");
672 
673         IERC20 token = IERC20(tokens[tokenId]);
674         if (mintable) {
675             token.pool_mint(user, amount);
676             if (tokens[tokenId] == deiAddress) {
677                 bridgeReserve += amount;
678             }
679         } else { 
680             token.transfer(user, amount);
681         }
682 
683         claimedTxs[fromChain][txId] = true;
684         emit Claim(user, tokenId, amount, fromChain, txId);
685     }
686 
687 
688     /* ========== VIEWS ========== */
689 
690     // This function use pool feature to handle buyback and recollateralize on DEI minter pool
691     function collatDollarBalance(uint collat_usd_price) public view returns (uint) {
692         uint collateralRatio = IDEIStablecoin(deiAddress).global_collateral_ratio();
693         return bridgeReserve * collateralRatio / 1e6;
694     }
695 
696     function pendingTxs(
697         uint fromChain, 
698         uint[] calldata ids
699     ) public view returns (bool[] memory unclaimedIds) {
700         unclaimedIds = new bool[](ids.length);
701         for(uint i=0; i < ids.length; i++){
702             unclaimedIds[i] = claimedTxs[fromChain][ids[i]];
703         }
704     }
705 
706     function getUserTxs(
707         address user, 
708         uint toChain
709     ) public view returns (uint[] memory) {
710         return userTxs[user][toChain];
711     }
712 
713     function getTransaction(uint txId_) public view returns(
714         uint txId,
715         uint tokenId,
716         uint amount,
717         uint fromChain,
718         uint toChain,
719         address user,
720         uint txBlockNo,
721         uint currentBlockNo
722     ){
723         txId = txs[txId_].txId;
724         tokenId = txs[txId_].tokenId;
725         amount = txs[txId_].amount;
726         fromChain = txs[txId_].fromChain;
727         toChain = txs[txId_].toChain;
728         user = txs[txId_].user;
729         txBlockNo = txs[txId_].txBlockNo;
730         currentBlockNo = block.number;
731     }
732 
733     function getExecutingChainID() public view returns (uint) {
734         uint id;
735         assembly {
736             id := chainid()
737         }
738         return id;
739     }
740 
741 
742     /* ========== RESTRICTED FUNCTIONS ========== */
743 
744     function setBridgeReserve(uint bridgeReserve_) external onlyOwner {
745         emit BridgeReserveSet(bridgeReserve, bridgeReserve_);
746 
747         bridgeReserve = bridgeReserve_;
748     }
749 
750     function setToken(uint tokenId, address tokenAddress) external onlyOwner {
751         tokens[tokenId] = tokenAddress;
752     }
753 
754     function setNetworkID(uint network_) external onlyOwner {
755         network = network_;
756         delete sideContracts[network];
757     }
758 
759     function setFee(uint tokenId, uint fee_) external onlyOwner {
760         fee[tokenId] = fee_;
761     }
762     
763     function setDeiAddress(address deiAddress_) external onlyOwner {
764         deiAddress = deiAddress_;
765     }
766 
767     function setMinReqSigs(uint minReqSigs_) external onlyOwner {
768         minReqSigs = minReqSigs_;
769     }
770 
771     function setSideContract(uint network_, address address_) external onlyOwner {
772         require (network != network_, "Bridge: current network");
773         sideContracts[network_] = address_;
774     }
775 
776     function setMintable(bool mintable_) external onlyOwner {
777         mintable = mintable_;
778     }
779 
780     function setEthAppId(uint8 ETH_APP_ID_) external onlyOwner {
781         ETH_APP_ID = ETH_APP_ID_;
782     }
783 
784     function setMuonContract(address muonContract_) external onlyOwner {
785         muonContract = muonContract_;
786     }
787 
788     function pause() external onlyOwner { super._pause(); }
789 
790     function unpase() external onlyOwner { super._unpause(); }
791 
792     function withdrawFee(uint tokenId, address to) external onlyOwner {
793         require(collectedFee[tokenId] > 0, "Bridge: No fee to collect");
794 
795         IERC20(tokens[tokenId]).pool_mint(to, collectedFee[tokenId]);
796         collectedFee[tokenId] = 0;
797     }
798 
799     function emergencyWithdrawETH(address to, uint amount) external onlyOwner {
800         require(to != address(0));
801         payable(to).transfer(amount);
802     }
803 
804     function emergencyWithdrawERC20Tokens(address tokenAddr, address to, uint amount) external onlyOwner {
805         require(to != address(0));
806         IERC20(tokenAddr).transfer(to, amount);
807     }
808 }