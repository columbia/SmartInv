1 // File: VaultCoreInterface.sol
2 
3 
4 
5 pragma solidity 0.8.9;
6 
7 abstract contract VaultCoreInterface {
8     function getVersion() public pure virtual returns (uint);
9     function typeOfContract() public pure virtual returns (bytes32);
10     function approveToken(
11         uint256 _tokenId,
12         address _tokenContractAddress) external virtual;
13 }
14 // File: RoyaltyRegistryInterface.sol
15 
16 
17 
18 pragma solidity 0.8.9;
19 
20 
21 /**
22  * Interface to the RoyaltyRegistry responsible for looking payout addresses
23  */
24 abstract contract RoyaltyRegistryInterface {
25     function getAddress(address custodial) external view virtual returns (address);
26     function getMediaCustomPercentage(uint256 mediaId, address tokenAddress) external view virtual returns(uint16);
27     function getExternalTokenPercentage(uint256 tokenId, address tokenAddress) external view virtual returns(uint16, uint16);
28     function typeOfContract() virtual public pure returns (string calldata);
29     function VERSION() virtual public pure returns (uint8);
30 }
31 // File: ApprovedCreatorRegistryInterface.sol
32 
33 
34 
35 pragma solidity 0.8.9;
36 
37 
38 /**
39  * Interface to the digital media store external contract that is
40  * responsible for storing the common digital media and collection data.
41  * This allows for new token contracts to be deployed and continue to reference
42  * the digital media and collection data.
43  */
44 abstract contract ApprovedCreatorRegistryInterface {
45 
46     function getVersion() virtual public pure returns (uint);
47     function typeOfContract() virtual public pure returns (string calldata);
48     function isOperatorApprovedForCustodialAccount(
49         address _operator,
50         address _custodialAddress) virtual public view returns (bool);
51 
52 }
53 // File: @openzeppelin/contracts/utils/Strings.sol
54 
55 
56 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65     uint8 private constant _ADDRESS_LENGTH = 20;
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
69      */
70     function toString(uint256 value) internal pure returns (string memory) {
71         // Inspired by OraclizeAPI's implementation - MIT licence
72         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
73 
74         if (value == 0) {
75             return "0";
76         }
77         uint256 temp = value;
78         uint256 digits;
79         while (temp != 0) {
80             digits++;
81             temp /= 10;
82         }
83         bytes memory buffer = new bytes(digits);
84         while (value != 0) {
85             digits -= 1;
86             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
87             value /= 10;
88         }
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
94      */
95     function toHexString(uint256 value) internal pure returns (string memory) {
96         if (value == 0) {
97             return "0x00";
98         }
99         uint256 temp = value;
100         uint256 length = 0;
101         while (temp != 0) {
102             length++;
103             temp >>= 8;
104         }
105         return toHexString(value, length);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
110      */
111     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
112         bytes memory buffer = new bytes(2 * length + 2);
113         buffer[0] = "0";
114         buffer[1] = "x";
115         for (uint256 i = 2 * length + 1; i > 1; --i) {
116             buffer[i] = _HEX_SYMBOLS[value & 0xf];
117             value >>= 4;
118         }
119         require(value == 0, "Strings: hex length insufficient");
120         return string(buffer);
121     }
122 
123     /**
124      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
125      */
126     function toHexString(address addr) internal pure returns (string memory) {
127         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
132 
133 
134 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 
139 /**
140  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
141  *
142  * These functions can be used to verify that a message was signed by the holder
143  * of the private keys of a given address.
144  */
145 library ECDSA {
146     enum RecoverError {
147         NoError,
148         InvalidSignature,
149         InvalidSignatureLength,
150         InvalidSignatureS,
151         InvalidSignatureV
152     }
153 
154     function _throwError(RecoverError error) private pure {
155         if (error == RecoverError.NoError) {
156             return; // no error: do nothing
157         } else if (error == RecoverError.InvalidSignature) {
158             revert("ECDSA: invalid signature");
159         } else if (error == RecoverError.InvalidSignatureLength) {
160             revert("ECDSA: invalid signature length");
161         } else if (error == RecoverError.InvalidSignatureS) {
162             revert("ECDSA: invalid signature 's' value");
163         } else if (error == RecoverError.InvalidSignatureV) {
164             revert("ECDSA: invalid signature 'v' value");
165         }
166     }
167 
168     /**
169      * @dev Returns the address that signed a hashed message (`hash`) with
170      * `signature` or error string. This address can then be used for verification purposes.
171      *
172      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
173      * this function rejects them by requiring the `s` value to be in the lower
174      * half order, and the `v` value to be either 27 or 28.
175      *
176      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
177      * verification to be secure: it is possible to craft signatures that
178      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
179      * this is by receiving a hash of the original message (which may otherwise
180      * be too long), and then calling {toEthSignedMessageHash} on it.
181      *
182      * Documentation for signature generation:
183      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
184      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
185      *
186      * _Available since v4.3._
187      */
188     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
189         if (signature.length == 65) {
190             bytes32 r;
191             bytes32 s;
192             uint8 v;
193             // ecrecover takes the signature parameters, and the only way to get them
194             // currently is to use assembly.
195             /// @solidity memory-safe-assembly
196             assembly {
197                 r := mload(add(signature, 0x20))
198                 s := mload(add(signature, 0x40))
199                 v := byte(0, mload(add(signature, 0x60)))
200             }
201             return tryRecover(hash, v, r, s);
202         } else {
203             return (address(0), RecoverError.InvalidSignatureLength);
204         }
205     }
206 
207     /**
208      * @dev Returns the address that signed a hashed message (`hash`) with
209      * `signature`. This address can then be used for verification purposes.
210      *
211      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
212      * this function rejects them by requiring the `s` value to be in the lower
213      * half order, and the `v` value to be either 27 or 28.
214      *
215      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
216      * verification to be secure: it is possible to craft signatures that
217      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
218      * this is by receiving a hash of the original message (which may otherwise
219      * be too long), and then calling {toEthSignedMessageHash} on it.
220      */
221     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
222         (address recovered, RecoverError error) = tryRecover(hash, signature);
223         _throwError(error);
224         return recovered;
225     }
226 
227     /**
228      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
229      *
230      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
231      *
232      * _Available since v4.3._
233      */
234     function tryRecover(
235         bytes32 hash,
236         bytes32 r,
237         bytes32 vs
238     ) internal pure returns (address, RecoverError) {
239         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
240         uint8 v = uint8((uint256(vs) >> 255) + 27);
241         return tryRecover(hash, v, r, s);
242     }
243 
244     /**
245      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
246      *
247      * _Available since v4.2._
248      */
249     function recover(
250         bytes32 hash,
251         bytes32 r,
252         bytes32 vs
253     ) internal pure returns (address) {
254         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
255         _throwError(error);
256         return recovered;
257     }
258 
259     /**
260      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
261      * `r` and `s` signature fields separately.
262      *
263      * _Available since v4.3._
264      */
265     function tryRecover(
266         bytes32 hash,
267         uint8 v,
268         bytes32 r,
269         bytes32 s
270     ) internal pure returns (address, RecoverError) {
271         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
272         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
273         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
274         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
275         //
276         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
277         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
278         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
279         // these malleable signatures as well.
280         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
281             return (address(0), RecoverError.InvalidSignatureS);
282         }
283         if (v != 27 && v != 28) {
284             return (address(0), RecoverError.InvalidSignatureV);
285         }
286 
287         // If the signature is valid (and not malleable), return the signer address
288         address signer = ecrecover(hash, v, r, s);
289         if (signer == address(0)) {
290             return (address(0), RecoverError.InvalidSignature);
291         }
292 
293         return (signer, RecoverError.NoError);
294     }
295 
296     /**
297      * @dev Overload of {ECDSA-recover} that receives the `v`,
298      * `r` and `s` signature fields separately.
299      */
300     function recover(
301         bytes32 hash,
302         uint8 v,
303         bytes32 r,
304         bytes32 s
305     ) internal pure returns (address) {
306         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
307         _throwError(error);
308         return recovered;
309     }
310 
311     /**
312      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
313      * produces hash corresponding to the one signed with the
314      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
315      * JSON-RPC method as part of EIP-191.
316      *
317      * See {recover}.
318      */
319     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
320         // 32 is the length in bytes of hash,
321         // enforced by the type signature above
322         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
323     }
324 
325     /**
326      * @dev Returns an Ethereum Signed Message, created from `s`. This
327      * produces hash corresponding to the one signed with the
328      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
329      * JSON-RPC method as part of EIP-191.
330      *
331      * See {recover}.
332      */
333     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
334         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
335     }
336 
337     /**
338      * @dev Returns an Ethereum Signed Typed Data, created from a
339      * `domainSeparator` and a `structHash`. This produces hash corresponding
340      * to the one signed with the
341      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
342      * JSON-RPC method as part of EIP-712.
343      *
344      * See {recover}.
345      */
346     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
347         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Context.sol
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 /**
359  * @dev Provides information about the current execution context, including the
360  * sender of the transaction and its data. While these are generally available
361  * via msg.sender and msg.data, they should not be accessed in such a direct
362  * manner, since when dealing with meta-transactions the account sending and
363  * paying for execution may not be the actual sender (as far as an application
364  * is concerned).
365  *
366  * This contract is only required for intermediate, library-like contracts.
367  */
368 abstract contract Context {
369     function _msgSender() internal view virtual returns (address) {
370         return msg.sender;
371     }
372 
373     function _msgData() internal view virtual returns (bytes calldata) {
374         return msg.data;
375     }
376 }
377 
378 // File: @openzeppelin/contracts/access/Ownable.sol
379 
380 
381 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
382 
383 pragma solidity ^0.8.0;
384 
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 abstract contract Ownable is Context {
399     address private _owner;
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403     /**
404      * @dev Initializes the contract setting the deployer as the initial owner.
405      */
406     constructor() {
407         _transferOwnership(_msgSender());
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         _checkOwner();
415         _;
416     }
417 
418     /**
419      * @dev Returns the address of the current owner.
420      */
421     function owner() public view virtual returns (address) {
422         return _owner;
423     }
424 
425     /**
426      * @dev Throws if the sender is not the owner.
427      */
428     function _checkOwner() internal view virtual {
429         require(owner() == _msgSender(), "Ownable: caller is not the owner");
430     }
431 
432     /**
433      * @dev Leaves the contract without owner. It will not be possible to call
434      * `onlyOwner` functions anymore. Can only be called by the current owner.
435      *
436      * NOTE: Renouncing ownership will leave the contract without an owner,
437      * thereby removing any functionality that is only available to the owner.
438      */
439     function renounceOwnership() public virtual onlyOwner {
440         _transferOwnership(address(0));
441     }
442 
443     /**
444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
445      * Can only be called by the current owner.
446      */
447     function transferOwnership(address newOwner) public virtual onlyOwner {
448         require(newOwner != address(0), "Ownable: new owner is the zero address");
449         _transferOwnership(newOwner);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Internal function without access restriction.
455      */
456     function _transferOwnership(address newOwner) internal virtual {
457         address oldOwner = _owner;
458         _owner = newOwner;
459         emit OwnershipTransferred(oldOwner, newOwner);
460     }
461 }
462 
463 // File: OBOControl.sol
464 
465 
466 
467 pragma solidity 0.8.9;
468 
469 
470 
471 contract OBOControl is Ownable {
472     address public oboAdmin;
473     uint256 constant public newAddressWaitPeriod = 1 days;
474     bool public canAddOBOImmediately = true;
475 
476     // List of approved on behalf of users.
477     mapping (address => uint256) public approvedOBOs;
478 
479     event NewOBOAddressEvent(
480         address OBOAddress,
481         bool action);
482 
483     event NewOBOAdminAddressEvent(
484         address oboAdminAddress);
485 
486     modifier onlyOBOAdmin() {
487         require(owner() == _msgSender() || oboAdmin == _msgSender(), "not oboAdmin");
488         _;
489     }
490 
491     function setOBOAdmin(address _oboAdmin) external onlyOwner {
492         oboAdmin = _oboAdmin;
493         emit NewOBOAdminAddressEvent(_oboAdmin);
494     }
495 
496     /**
497      * Add a new approvedOBO address. The address can be used after wait period.
498      */
499     function addApprovedOBO(address _oboAddress) external onlyOBOAdmin {
500         require(_oboAddress != address(0), "cant set to 0x");
501         require(approvedOBOs[_oboAddress] == 0, "already added");
502         approvedOBOs[_oboAddress] = block.timestamp;
503         emit NewOBOAddressEvent(_oboAddress, true);
504     }
505 
506     /**
507      * Removes an approvedOBO immediately.
508      */
509     function removeApprovedOBO(address _oboAddress) external onlyOBOAdmin {
510         delete approvedOBOs[_oboAddress];
511         emit NewOBOAddressEvent(_oboAddress, false);
512     }
513 
514     /*
515      * Add OBOAddress for immediate use. This is an internal only Fn that is called
516      * only when the contract is deployed.
517      */
518     function addApprovedOBOImmediately(address _oboAddress) internal onlyOwner {
519         require(_oboAddress != address(0), "addr(0)");
520         // set the date to one in past so that address is active immediately.
521         approvedOBOs[_oboAddress] = block.timestamp - newAddressWaitPeriod - 1;
522         emit NewOBOAddressEvent(_oboAddress, true);
523     }
524 
525     function addApprovedOBOAfterDeploy(address _oboAddress) external onlyOBOAdmin {
526         require(canAddOBOImmediately == true, "disabled");
527         addApprovedOBOImmediately(_oboAddress);
528     }
529 
530     function blockImmediateOBO() external onlyOBOAdmin {
531         canAddOBOImmediately = false;
532     }
533 
534     /*
535      * Helper function to verify is a given address is a valid approvedOBO address.
536      */
537     function isValidApprovedOBO(address _oboAddress) public view returns (bool) {
538         uint256 createdAt = approvedOBOs[_oboAddress];
539         if (createdAt == 0) {
540             return false;
541         }
542         return block.timestamp - createdAt > newAddressWaitPeriod;
543     }
544 
545     /**
546     * @dev Modifier to make the obo calls only callable by approved addressess
547     */
548     modifier isApprovedOBO() {
549         require(isValidApprovedOBO(msg.sender), "unauthorized OBO user");
550         _;
551     }
552 }
553 // File: @openzeppelin/contracts/security/Pausable.sol
554 
555 
556 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 
561 /**
562  * @dev Contract module which allows children to implement an emergency stop
563  * mechanism that can be triggered by an authorized account.
564  *
565  * This module is used through inheritance. It will make available the
566  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
567  * the functions of your contract. Note that they will not be pausable by
568  * simply including this module, only once the modifiers are put in place.
569  */
570 abstract contract Pausable is Context {
571     /**
572      * @dev Emitted when the pause is triggered by `account`.
573      */
574     event Paused(address account);
575 
576     /**
577      * @dev Emitted when the pause is lifted by `account`.
578      */
579     event Unpaused(address account);
580 
581     bool private _paused;
582 
583     /**
584      * @dev Initializes the contract in unpaused state.
585      */
586     constructor() {
587         _paused = false;
588     }
589 
590     /**
591      * @dev Modifier to make a function callable only when the contract is not paused.
592      *
593      * Requirements:
594      *
595      * - The contract must not be paused.
596      */
597     modifier whenNotPaused() {
598         _requireNotPaused();
599         _;
600     }
601 
602     /**
603      * @dev Modifier to make a function callable only when the contract is paused.
604      *
605      * Requirements:
606      *
607      * - The contract must be paused.
608      */
609     modifier whenPaused() {
610         _requirePaused();
611         _;
612     }
613 
614     /**
615      * @dev Returns true if the contract is paused, and false otherwise.
616      */
617     function paused() public view virtual returns (bool) {
618         return _paused;
619     }
620 
621     /**
622      * @dev Throws if the contract is paused.
623      */
624     function _requireNotPaused() internal view virtual {
625         require(!paused(), "Pausable: paused");
626     }
627 
628     /**
629      * @dev Throws if the contract is not paused.
630      */
631     function _requirePaused() internal view virtual {
632         require(paused(), "Pausable: not paused");
633     }
634 
635     /**
636      * @dev Triggers stopped state.
637      *
638      * Requirements:
639      *
640      * - The contract must not be paused.
641      */
642     function _pause() internal virtual whenNotPaused {
643         _paused = true;
644         emit Paused(_msgSender());
645     }
646 
647     /**
648      * @dev Returns to normal state.
649      *
650      * Requirements:
651      *
652      * - The contract must be paused.
653      */
654     function _unpause() internal virtual whenPaused {
655         _paused = false;
656         emit Unpaused(_msgSender());
657     }
658 }
659 
660 // File: @openzeppelin/contracts/utils/Address.sol
661 
662 
663 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
664 
665 pragma solidity ^0.8.1;
666 
667 /**
668  * @dev Collection of functions related to the address type
669  */
670 library Address {
671     /**
672      * @dev Returns true if `account` is a contract.
673      *
674      * [IMPORTANT]
675      * ====
676      * It is unsafe to assume that an address for which this function returns
677      * false is an externally-owned account (EOA) and not a contract.
678      *
679      * Among others, `isContract` will return false for the following
680      * types of addresses:
681      *
682      *  - an externally-owned account
683      *  - a contract in construction
684      *  - an address where a contract will be created
685      *  - an address where a contract lived, but was destroyed
686      * ====
687      *
688      * [IMPORTANT]
689      * ====
690      * You shouldn't rely on `isContract` to protect against flash loan attacks!
691      *
692      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
693      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
694      * constructor.
695      * ====
696      */
697     function isContract(address account) internal view returns (bool) {
698         // This method relies on extcodesize/address.code.length, which returns 0
699         // for contracts in construction, since the code is only stored at the end
700         // of the constructor execution.
701 
702         return account.code.length > 0;
703     }
704 
705     /**
706      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
707      * `recipient`, forwarding all available gas and reverting on errors.
708      *
709      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
710      * of certain opcodes, possibly making contracts go over the 2300 gas limit
711      * imposed by `transfer`, making them unable to receive funds via
712      * `transfer`. {sendValue} removes this limitation.
713      *
714      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
715      *
716      * IMPORTANT: because control is transferred to `recipient`, care must be
717      * taken to not create reentrancy vulnerabilities. Consider using
718      * {ReentrancyGuard} or the
719      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
720      */
721     function sendValue(address payable recipient, uint256 amount) internal {
722         require(address(this).balance >= amount, "Address: insufficient balance");
723 
724         (bool success, ) = recipient.call{value: amount}("");
725         require(success, "Address: unable to send value, recipient may have reverted");
726     }
727 
728     /**
729      * @dev Performs a Solidity function call using a low level `call`. A
730      * plain `call` is an unsafe replacement for a function call: use this
731      * function instead.
732      *
733      * If `target` reverts with a revert reason, it is bubbled up by this
734      * function (like regular Solidity function calls).
735      *
736      * Returns the raw returned data. To convert to the expected return value,
737      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
738      *
739      * Requirements:
740      *
741      * - `target` must be a contract.
742      * - calling `target` with `data` must not revert.
743      *
744      * _Available since v3.1._
745      */
746     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
747         return functionCall(target, data, "Address: low-level call failed");
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
752      * `errorMessage` as a fallback revert reason when `target` reverts.
753      *
754      * _Available since v3.1._
755      */
756     function functionCall(
757         address target,
758         bytes memory data,
759         string memory errorMessage
760     ) internal returns (bytes memory) {
761         return functionCallWithValue(target, data, 0, errorMessage);
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
766      * but also transferring `value` wei to `target`.
767      *
768      * Requirements:
769      *
770      * - the calling contract must have an ETH balance of at least `value`.
771      * - the called Solidity function must be `payable`.
772      *
773      * _Available since v3.1._
774      */
775     function functionCallWithValue(
776         address target,
777         bytes memory data,
778         uint256 value
779     ) internal returns (bytes memory) {
780         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
785      * with `errorMessage` as a fallback revert reason when `target` reverts.
786      *
787      * _Available since v3.1._
788      */
789     function functionCallWithValue(
790         address target,
791         bytes memory data,
792         uint256 value,
793         string memory errorMessage
794     ) internal returns (bytes memory) {
795         require(address(this).balance >= value, "Address: insufficient balance for call");
796         require(isContract(target), "Address: call to non-contract");
797 
798         (bool success, bytes memory returndata) = target.call{value: value}(data);
799         return verifyCallResult(success, returndata, errorMessage);
800     }
801 
802     /**
803      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
804      * but performing a static call.
805      *
806      * _Available since v3.3._
807      */
808     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
809         return functionStaticCall(target, data, "Address: low-level static call failed");
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
814      * but performing a static call.
815      *
816      * _Available since v3.3._
817      */
818     function functionStaticCall(
819         address target,
820         bytes memory data,
821         string memory errorMessage
822     ) internal view returns (bytes memory) {
823         require(isContract(target), "Address: static call to non-contract");
824 
825         (bool success, bytes memory returndata) = target.staticcall(data);
826         return verifyCallResult(success, returndata, errorMessage);
827     }
828 
829     /**
830      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
831      * but performing a delegate call.
832      *
833      * _Available since v3.4._
834      */
835     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
836         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
837     }
838 
839     /**
840      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
841      * but performing a delegate call.
842      *
843      * _Available since v3.4._
844      */
845     function functionDelegateCall(
846         address target,
847         bytes memory data,
848         string memory errorMessage
849     ) internal returns (bytes memory) {
850         require(isContract(target), "Address: delegate call to non-contract");
851 
852         (bool success, bytes memory returndata) = target.delegatecall(data);
853         return verifyCallResult(success, returndata, errorMessage);
854     }
855 
856     /**
857      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
858      * revert reason using the provided one.
859      *
860      * _Available since v4.3._
861      */
862     function verifyCallResult(
863         bool success,
864         bytes memory returndata,
865         string memory errorMessage
866     ) internal pure returns (bytes memory) {
867         if (success) {
868             return returndata;
869         } else {
870             // Look for revert reason and bubble it up if present
871             if (returndata.length > 0) {
872                 // The easiest way to bubble the revert reason is using memory via assembly
873                 /// @solidity memory-safe-assembly
874                 assembly {
875                     let returndata_size := mload(returndata)
876                     revert(add(32, returndata), returndata_size)
877                 }
878             } else {
879                 revert(errorMessage);
880             }
881         }
882     }
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
886 
887 
888 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
889 
890 pragma solidity ^0.8.0;
891 
892 /**
893  * @title ERC721 token receiver interface
894  * @dev Interface for any contract that wants to support safeTransfers
895  * from ERC721 asset contracts.
896  */
897 interface IERC721Receiver {
898     /**
899      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
900      * by `operator` from `from`, this function is called.
901      *
902      * It must return its Solidity selector to confirm the token transfer.
903      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
904      *
905      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
906      */
907     function onERC721Received(
908         address operator,
909         address from,
910         uint256 tokenId,
911         bytes calldata data
912     ) external returns (bytes4);
913 }
914 
915 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev Interface of the ERC165 standard, as defined in the
924  * https://eips.ethereum.org/EIPS/eip-165[EIP].
925  *
926  * Implementers can declare support of contract interfaces, which can then be
927  * queried by others ({ERC165Checker}).
928  *
929  * For an implementation, see {ERC165}.
930  */
931 interface IERC165 {
932     /**
933      * @dev Returns true if this contract implements the interface defined by
934      * `interfaceId`. See the corresponding
935      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
936      * to learn more about how these ids are created.
937      *
938      * This function call must use less than 30 000 gas.
939      */
940     function supportsInterface(bytes4 interfaceId) external view returns (bool);
941 }
942 
943 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
944 
945 
946 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
947 
948 pragma solidity ^0.8.0;
949 
950 
951 /**
952  * @dev Implementation of the {IERC165} interface.
953  *
954  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
955  * for the additional interface id that will be supported. For example:
956  *
957  * ```solidity
958  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
959  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
960  * }
961  * ```
962  *
963  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
964  */
965 abstract contract ERC165 is IERC165 {
966     /**
967      * @dev See {IERC165-supportsInterface}.
968      */
969     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
970         return interfaceId == type(IERC165).interfaceId;
971     }
972 }
973 
974 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
975 
976 
977 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
978 
979 pragma solidity ^0.8.0;
980 
981 
982 /**
983  * @dev Required interface of an ERC721 compliant contract.
984  */
985 interface IERC721 is IERC165 {
986     /**
987      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
988      */
989     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
990 
991     /**
992      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
993      */
994     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
995 
996     /**
997      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
998      */
999     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1000 
1001     /**
1002      * @dev Returns the number of tokens in ``owner``'s account.
1003      */
1004     function balanceOf(address owner) external view returns (uint256 balance);
1005 
1006     /**
1007      * @dev Returns the owner of the `tokenId` token.
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must exist.
1012      */
1013     function ownerOf(uint256 tokenId) external view returns (address owner);
1014 
1015     /**
1016      * @dev Safely transfers `tokenId` token from `from` to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `from` cannot be the zero address.
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must exist and be owned by `from`.
1023      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1024      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId,
1032         bytes calldata data
1033     ) external;
1034 
1035     /**
1036      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1037      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1038      *
1039      * Requirements:
1040      *
1041      * - `from` cannot be the zero address.
1042      * - `to` cannot be the zero address.
1043      * - `tokenId` token must exist and be owned by `from`.
1044      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1045      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) external;
1054 
1055     /**
1056      * @dev Transfers `tokenId` token from `from` to `to`.
1057      *
1058      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1059      *
1060      * Requirements:
1061      *
1062      * - `from` cannot be the zero address.
1063      * - `to` cannot be the zero address.
1064      * - `tokenId` token must be owned by `from`.
1065      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function transferFrom(
1070         address from,
1071         address to,
1072         uint256 tokenId
1073     ) external;
1074 
1075     /**
1076      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1077      * The approval is cleared when the token is transferred.
1078      *
1079      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1080      *
1081      * Requirements:
1082      *
1083      * - The caller must own the token or be an approved operator.
1084      * - `tokenId` must exist.
1085      *
1086      * Emits an {Approval} event.
1087      */
1088     function approve(address to, uint256 tokenId) external;
1089 
1090     /**
1091      * @dev Approve or remove `operator` as an operator for the caller.
1092      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1093      *
1094      * Requirements:
1095      *
1096      * - The `operator` cannot be the caller.
1097      *
1098      * Emits an {ApprovalForAll} event.
1099      */
1100     function setApprovalForAll(address operator, bool _approved) external;
1101 
1102     /**
1103      * @dev Returns the account approved for `tokenId` token.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      */
1109     function getApproved(uint256 tokenId) external view returns (address operator);
1110 
1111     /**
1112      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1113      *
1114      * See {setApprovalForAll}
1115      */
1116     function isApprovedForAll(address owner, address operator) external view returns (bool);
1117 }
1118 
1119 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1120 
1121 
1122 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 
1127 /**
1128  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1129  * @dev See https://eips.ethereum.org/EIPS/eip-721
1130  */
1131 interface IERC721Enumerable is IERC721 {
1132     /**
1133      * @dev Returns the total amount of tokens stored by the contract.
1134      */
1135     function totalSupply() external view returns (uint256);
1136 
1137     /**
1138      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1139      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1140      */
1141     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1142 
1143     /**
1144      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1145      * Use along with {totalSupply} to enumerate all tokens.
1146      */
1147     function tokenByIndex(uint256 index) external view returns (uint256);
1148 }
1149 
1150 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1151 
1152 
1153 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1154 
1155 pragma solidity ^0.8.0;
1156 
1157 
1158 /**
1159  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1160  * @dev See https://eips.ethereum.org/EIPS/eip-721
1161  */
1162 interface IERC721Metadata is IERC721 {
1163     /**
1164      * @dev Returns the token collection name.
1165      */
1166     function name() external view returns (string memory);
1167 
1168     /**
1169      * @dev Returns the token collection symbol.
1170      */
1171     function symbol() external view returns (string memory);
1172 
1173     /**
1174      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1175      */
1176     function tokenURI(uint256 tokenId) external view returns (string memory);
1177 }
1178 
1179 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1180 
1181 
1182 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 
1188 
1189 
1190 
1191 
1192 
1193 /**
1194  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1195  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1196  * {ERC721Enumerable}.
1197  */
1198 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1199     using Address for address;
1200     using Strings for uint256;
1201 
1202     // Token name
1203     string private _name;
1204 
1205     // Token symbol
1206     string private _symbol;
1207 
1208     // Mapping from token ID to owner address
1209     mapping(uint256 => address) private _owners;
1210 
1211     // Mapping owner address to token count
1212     mapping(address => uint256) private _balances;
1213 
1214     // Mapping from token ID to approved address
1215     mapping(uint256 => address) private _tokenApprovals;
1216 
1217     // Mapping from owner to operator approvals
1218     mapping(address => mapping(address => bool)) private _operatorApprovals;
1219 
1220     /**
1221      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1222      */
1223     constructor(string memory name_, string memory symbol_) {
1224         _name = name_;
1225         _symbol = symbol_;
1226     }
1227 
1228     /**
1229      * @dev See {IERC165-supportsInterface}.
1230      */
1231     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1232         return
1233             interfaceId == type(IERC721).interfaceId ||
1234             interfaceId == type(IERC721Metadata).interfaceId ||
1235             super.supportsInterface(interfaceId);
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-balanceOf}.
1240      */
1241     function balanceOf(address owner) public view virtual override returns (uint256) {
1242         require(owner != address(0), "ERC721: address zero is not a valid owner");
1243         return _balances[owner];
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-ownerOf}.
1248      */
1249     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1250         address owner = _owners[tokenId];
1251         require(owner != address(0), "ERC721: invalid token ID");
1252         return owner;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Metadata-name}.
1257      */
1258     function name() public view virtual override returns (string memory) {
1259         return _name;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Metadata-symbol}.
1264      */
1265     function symbol() public view virtual override returns (string memory) {
1266         return _symbol;
1267     }
1268 
1269     /**
1270      * @dev See {IERC721Metadata-tokenURI}.
1271      */
1272     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1273         _requireMinted(tokenId);
1274 
1275         string memory baseURI = _baseURI();
1276         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1277     }
1278 
1279     /**
1280      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1281      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1282      * by default, can be overridden in child contracts.
1283      */
1284     function _baseURI() internal view virtual returns (string memory) {
1285         return "";
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-approve}.
1290      */
1291     function approve(address to, uint256 tokenId) public virtual override {
1292         address owner = ERC721.ownerOf(tokenId);
1293         require(to != owner, "ERC721: approval to current owner");
1294 
1295         require(
1296             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1297             "ERC721: approve caller is not token owner nor approved for all"
1298         );
1299 
1300         _approve(to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-getApproved}.
1305      */
1306     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1307         _requireMinted(tokenId);
1308 
1309         return _tokenApprovals[tokenId];
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-setApprovalForAll}.
1314      */
1315     function setApprovalForAll(address operator, bool approved) public virtual override {
1316         _setApprovalForAll(_msgSender(), operator, approved);
1317     }
1318 
1319     /**
1320      * @dev See {IERC721-isApprovedForAll}.
1321      */
1322     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1323         return _operatorApprovals[owner][operator];
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-transferFrom}.
1328      */
1329     function transferFrom(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) public virtual override {
1334         //solhint-disable-next-line max-line-length
1335         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1336 
1337         _transfer(from, to, tokenId);
1338     }
1339 
1340     /**
1341      * @dev See {IERC721-safeTransferFrom}.
1342      */
1343     function safeTransferFrom(
1344         address from,
1345         address to,
1346         uint256 tokenId
1347     ) public virtual override {
1348         safeTransferFrom(from, to, tokenId, "");
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-safeTransferFrom}.
1353      */
1354     function safeTransferFrom(
1355         address from,
1356         address to,
1357         uint256 tokenId,
1358         bytes memory data
1359     ) public virtual override {
1360         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1361         _safeTransfer(from, to, tokenId, data);
1362     }
1363 
1364     /**
1365      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1366      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1367      *
1368      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1369      *
1370      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1371      * implement alternative mechanisms to perform token transfer, such as signature-based.
1372      *
1373      * Requirements:
1374      *
1375      * - `from` cannot be the zero address.
1376      * - `to` cannot be the zero address.
1377      * - `tokenId` token must exist and be owned by `from`.
1378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _safeTransfer(
1383         address from,
1384         address to,
1385         uint256 tokenId,
1386         bytes memory data
1387     ) internal virtual {
1388         _transfer(from, to, tokenId);
1389         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1390     }
1391 
1392     /**
1393      * @dev Returns whether `tokenId` exists.
1394      *
1395      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1396      *
1397      * Tokens start existing when they are minted (`_mint`),
1398      * and stop existing when they are burned (`_burn`).
1399      */
1400     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1401         return _owners[tokenId] != address(0);
1402     }
1403 
1404     /**
1405      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1406      *
1407      * Requirements:
1408      *
1409      * - `tokenId` must exist.
1410      */
1411     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1412         address owner = ERC721.ownerOf(tokenId);
1413         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1414     }
1415 
1416     /**
1417      * @dev Safely mints `tokenId` and transfers it to `to`.
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must not exist.
1422      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1423      *
1424      * Emits a {Transfer} event.
1425      */
1426     function _safeMint(address to, uint256 tokenId) internal virtual {
1427         _safeMint(to, tokenId, "");
1428     }
1429 
1430     /**
1431      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1432      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1433      */
1434     function _safeMint(
1435         address to,
1436         uint256 tokenId,
1437         bytes memory data
1438     ) internal virtual {
1439         _mint(to, tokenId);
1440         require(
1441             _checkOnERC721Received(address(0), to, tokenId, data),
1442             "ERC721: transfer to non ERC721Receiver implementer"
1443         );
1444     }
1445 
1446     /**
1447      * @dev Mints `tokenId` and transfers it to `to`.
1448      *
1449      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1450      *
1451      * Requirements:
1452      *
1453      * - `tokenId` must not exist.
1454      * - `to` cannot be the zero address.
1455      *
1456      * Emits a {Transfer} event.
1457      */
1458     function _mint(address to, uint256 tokenId) internal virtual {
1459         require(to != address(0), "ERC721: mint to the zero address");
1460         require(!_exists(tokenId), "ERC721: token already minted");
1461 
1462         _beforeTokenTransfer(address(0), to, tokenId);
1463 
1464         _balances[to] += 1;
1465         _owners[tokenId] = to;
1466 
1467         emit Transfer(address(0), to, tokenId);
1468 
1469         _afterTokenTransfer(address(0), to, tokenId);
1470     }
1471 
1472     /**
1473      * @dev Destroys `tokenId`.
1474      * The approval is cleared when the token is burned.
1475      *
1476      * Requirements:
1477      *
1478      * - `tokenId` must exist.
1479      *
1480      * Emits a {Transfer} event.
1481      */
1482     function _burn(uint256 tokenId) internal virtual {
1483         address owner = ERC721.ownerOf(tokenId);
1484 
1485         _beforeTokenTransfer(owner, address(0), tokenId);
1486 
1487         // Clear approvals
1488         _approve(address(0), tokenId);
1489 
1490         _balances[owner] -= 1;
1491         delete _owners[tokenId];
1492 
1493         emit Transfer(owner, address(0), tokenId);
1494 
1495         _afterTokenTransfer(owner, address(0), tokenId);
1496     }
1497 
1498     /**
1499      * @dev Transfers `tokenId` from `from` to `to`.
1500      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1501      *
1502      * Requirements:
1503      *
1504      * - `to` cannot be the zero address.
1505      * - `tokenId` token must be owned by `from`.
1506      *
1507      * Emits a {Transfer} event.
1508      */
1509     function _transfer(
1510         address from,
1511         address to,
1512         uint256 tokenId
1513     ) internal virtual {
1514         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1515         require(to != address(0), "ERC721: transfer to the zero address");
1516 
1517         _beforeTokenTransfer(from, to, tokenId);
1518 
1519         // Clear approvals from the previous owner
1520         _approve(address(0), tokenId);
1521 
1522         _balances[from] -= 1;
1523         _balances[to] += 1;
1524         _owners[tokenId] = to;
1525 
1526         emit Transfer(from, to, tokenId);
1527 
1528         _afterTokenTransfer(from, to, tokenId);
1529     }
1530 
1531     /**
1532      * @dev Approve `to` to operate on `tokenId`
1533      *
1534      * Emits an {Approval} event.
1535      */
1536     function _approve(address to, uint256 tokenId) internal virtual {
1537         _tokenApprovals[tokenId] = to;
1538         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1539     }
1540 
1541     /**
1542      * @dev Approve `operator` to operate on all of `owner` tokens
1543      *
1544      * Emits an {ApprovalForAll} event.
1545      */
1546     function _setApprovalForAll(
1547         address owner,
1548         address operator,
1549         bool approved
1550     ) internal virtual {
1551         require(owner != operator, "ERC721: approve to caller");
1552         _operatorApprovals[owner][operator] = approved;
1553         emit ApprovalForAll(owner, operator, approved);
1554     }
1555 
1556     /**
1557      * @dev Reverts if the `tokenId` has not been minted yet.
1558      */
1559     function _requireMinted(uint256 tokenId) internal view virtual {
1560         require(_exists(tokenId), "ERC721: invalid token ID");
1561     }
1562 
1563     /**
1564      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1565      * The call is not executed if the target address is not a contract.
1566      *
1567      * @param from address representing the previous owner of the given token ID
1568      * @param to target address that will receive the tokens
1569      * @param tokenId uint256 ID of the token to be transferred
1570      * @param data bytes optional data to send along with the call
1571      * @return bool whether the call correctly returned the expected magic value
1572      */
1573     function _checkOnERC721Received(
1574         address from,
1575         address to,
1576         uint256 tokenId,
1577         bytes memory data
1578     ) private returns (bool) {
1579         if (to.isContract()) {
1580             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1581                 return retval == IERC721Receiver.onERC721Received.selector;
1582             } catch (bytes memory reason) {
1583                 if (reason.length == 0) {
1584                     revert("ERC721: transfer to non ERC721Receiver implementer");
1585                 } else {
1586                     /// @solidity memory-safe-assembly
1587                     assembly {
1588                         revert(add(32, reason), mload(reason))
1589                     }
1590                 }
1591             }
1592         } else {
1593             return true;
1594         }
1595     }
1596 
1597     /**
1598      * @dev Hook that is called before any token transfer. This includes minting
1599      * and burning.
1600      *
1601      * Calling conditions:
1602      *
1603      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1604      * transferred to `to`.
1605      * - When `from` is zero, `tokenId` will be minted for `to`.
1606      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1607      * - `from` and `to` are never both zero.
1608      *
1609      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1610      */
1611     function _beforeTokenTransfer(
1612         address from,
1613         address to,
1614         uint256 tokenId
1615     ) internal virtual {}
1616 
1617     /**
1618      * @dev Hook that is called after any transfer of tokens. This includes
1619      * minting and burning.
1620      *
1621      * Calling conditions:
1622      *
1623      * - when `from` and `to` are both non-zero.
1624      * - `from` and `to` are never both zero.
1625      *
1626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1627      */
1628     function _afterTokenTransfer(
1629         address from,
1630         address to,
1631         uint256 tokenId
1632     ) internal virtual {}
1633 }
1634 
1635 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1636 
1637 
1638 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1639 
1640 pragma solidity ^0.8.0;
1641 
1642 
1643 
1644 /**
1645  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1646  * enumerability of all the token ids in the contract as well as all token ids owned by each
1647  * account.
1648  */
1649 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1650     // Mapping from owner to list of owned token IDs
1651     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1652 
1653     // Mapping from token ID to index of the owner tokens list
1654     mapping(uint256 => uint256) private _ownedTokensIndex;
1655 
1656     // Array with all token ids, used for enumeration
1657     uint256[] private _allTokens;
1658 
1659     // Mapping from token id to position in the allTokens array
1660     mapping(uint256 => uint256) private _allTokensIndex;
1661 
1662     /**
1663      * @dev See {IERC165-supportsInterface}.
1664      */
1665     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1666         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1667     }
1668 
1669     /**
1670      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1671      */
1672     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1673         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1674         return _ownedTokens[owner][index];
1675     }
1676 
1677     /**
1678      * @dev See {IERC721Enumerable-totalSupply}.
1679      */
1680     function totalSupply() public view virtual override returns (uint256) {
1681         return _allTokens.length;
1682     }
1683 
1684     /**
1685      * @dev See {IERC721Enumerable-tokenByIndex}.
1686      */
1687     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1688         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1689         return _allTokens[index];
1690     }
1691 
1692     /**
1693      * @dev Hook that is called before any token transfer. This includes minting
1694      * and burning.
1695      *
1696      * Calling conditions:
1697      *
1698      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1699      * transferred to `to`.
1700      * - When `from` is zero, `tokenId` will be minted for `to`.
1701      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1702      * - `from` cannot be the zero address.
1703      * - `to` cannot be the zero address.
1704      *
1705      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1706      */
1707     function _beforeTokenTransfer(
1708         address from,
1709         address to,
1710         uint256 tokenId
1711     ) internal virtual override {
1712         super._beforeTokenTransfer(from, to, tokenId);
1713 
1714         if (from == address(0)) {
1715             _addTokenToAllTokensEnumeration(tokenId);
1716         } else if (from != to) {
1717             _removeTokenFromOwnerEnumeration(from, tokenId);
1718         }
1719         if (to == address(0)) {
1720             _removeTokenFromAllTokensEnumeration(tokenId);
1721         } else if (to != from) {
1722             _addTokenToOwnerEnumeration(to, tokenId);
1723         }
1724     }
1725 
1726     /**
1727      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1728      * @param to address representing the new owner of the given token ID
1729      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1730      */
1731     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1732         uint256 length = ERC721.balanceOf(to);
1733         _ownedTokens[to][length] = tokenId;
1734         _ownedTokensIndex[tokenId] = length;
1735     }
1736 
1737     /**
1738      * @dev Private function to add a token to this extension's token tracking data structures.
1739      * @param tokenId uint256 ID of the token to be added to the tokens list
1740      */
1741     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1742         _allTokensIndex[tokenId] = _allTokens.length;
1743         _allTokens.push(tokenId);
1744     }
1745 
1746     /**
1747      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1748      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1749      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1750      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1751      * @param from address representing the previous owner of the given token ID
1752      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1753      */
1754     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1755         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1756         // then delete the last slot (swap and pop).
1757 
1758         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1759         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1760 
1761         // When the token to delete is the last token, the swap operation is unnecessary
1762         if (tokenIndex != lastTokenIndex) {
1763             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1764 
1765             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1766             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1767         }
1768 
1769         // This also deletes the contents at the last position of the array
1770         delete _ownedTokensIndex[tokenId];
1771         delete _ownedTokens[from][lastTokenIndex];
1772     }
1773 
1774     /**
1775      * @dev Private function to remove a token from this extension's token tracking data structures.
1776      * This has O(1) time complexity, but alters the order of the _allTokens array.
1777      * @param tokenId uint256 ID of the token to be removed from the tokens list
1778      */
1779     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1780         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1781         // then delete the last slot (swap and pop).
1782 
1783         uint256 lastTokenIndex = _allTokens.length - 1;
1784         uint256 tokenIndex = _allTokensIndex[tokenId];
1785 
1786         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1787         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1788         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1789         uint256 lastTokenId = _allTokens[lastTokenIndex];
1790 
1791         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1792         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1793 
1794         // This also deletes the contents at the last position of the array
1795         delete _allTokensIndex[tokenId];
1796         _allTokens.pop();
1797     }
1798 }
1799 
1800 // File: CollectionCore.sol
1801 
1802 
1803 
1804 pragma solidity 0.8.9;
1805 
1806 
1807 
1808 
1809 
1810 
1811 
1812 
1813 contract CollectionCore is ERC721Enumerable, OBOControl, Pausable {
1814     using ECDSA for bytes32;
1815     uint8 constant public VERSION = 1;
1816     uint16 public immutable royaltyPercentage;
1817     address public immutable creator;
1818     address public signerAddress;
1819     bool public enableExternalMinting;
1820     // by default bool's are false, save gas by not initializing
1821     bool public isImmutable;
1822     uint256 public immutable totalMediaSupply;
1823     string public baseURI;
1824     ApprovedCreatorRegistryInterface public creatorRegistryStore;
1825 
1826     struct ExternalCreateRequest {
1827         address owner;
1828         bytes signature;
1829         uint256 tokenId;
1830     }
1831 
1832     struct OBOCreateRequest {
1833         address owner;
1834         uint256 tokenId;
1835     }
1836 
1837     struct ChainSignatureRequest {
1838         uint256 onchainId;
1839         address owner;
1840         address thisContract;
1841     }
1842 
1843     event NewSignerEvent(
1844         address signer);
1845 
1846     constructor(string memory _tokenName, string memory _tokenSymbol,
1847             address _crsAddress, uint256 _totalSupply,
1848             address _creator, uint16 _royaltyPercentage, string memory _initialBaseURI) ERC721(_tokenName, _tokenSymbol) {
1849         require(_royaltyPercentage > 0 && _royaltyPercentage <= 10000, "invalid royalty");
1850         require(_creator != address(0), "creator = 0x0");
1851         setCreatorRegistryStore(_crsAddress);
1852         require(_totalSupply > 0, "supply > 0");
1853         totalMediaSupply = _totalSupply;
1854         creator = _creator;
1855         royaltyPercentage = _royaltyPercentage;
1856         baseURI = _initialBaseURI;
1857     }
1858 
1859     /*
1860      * Set signer address on the token contract. Setting signer means we are opening
1861      * the token contract for external accounts to create tokens. Call this to change
1862      * the signer immediately.
1863      */
1864     function setSignerAddress(address _signerAddress, bool _enableExternalMinting) external
1865             whenNotPaused isApprovedOBO {
1866         require(_signerAddress != address(0), "cant be zero");
1867         signerAddress = _signerAddress;
1868         enableExternalMinting = _enableExternalMinting;
1869         emit NewSignerEvent(signerAddress);
1870     }
1871 
1872     // Set the creator registry address upon construction. Immutable.
1873     function setCreatorRegistryStore(address _crsAddress) internal {
1874         require(_crsAddress != address(0), "registry = 0x0");
1875         ApprovedCreatorRegistryInterface candidateCreatorRegistryStore = ApprovedCreatorRegistryInterface(_crsAddress);
1876         // require(candidateCreatorRegistryStore.getVersion() == 1, "registry store is not version 1");
1877         // Simple check to make sure we are adding the registry contract indeed
1878         // https://fravoll.github.io/solidity-patterns/string_equality_comparison.html
1879         bytes32 contractType = keccak256(abi.encodePacked(candidateCreatorRegistryStore.typeOfContract()));
1880         // keccak256(abi.encodePacked("approvedCreatorRegistryReadOnly")) = 0x9732b26dfb8751e6f1f71e8f21b28a237cfe383953dce7db3dfa1777abdb2791
1881         require(contractType == 0x9732b26dfb8751e6f1f71e8f21b28a237cfe383953dce7db3dfa1777abdb2791,
1882             "not crtrReadOnlyRegistry");
1883         creatorRegistryStore = candidateCreatorRegistryStore;
1884     }
1885 
1886     function _baseURI() internal view override returns (string memory) {
1887         return baseURI;
1888     }
1889 
1890     /*
1891      * Set BaseURI for the entire collectible project. Only owner can set it to hide / reveal
1892      * baseURI.
1893      */
1894     function setBaseURI(string memory _newBaseURI) external onlyOwner whenNotPaused {
1895         require(isImmutable == false, "cant change");
1896         baseURI = _newBaseURI;
1897     }
1898 
1899     function makeImmutable() external onlyOwner {
1900         isImmutable = true;
1901     }
1902 
1903     /* External users who have been given a signature can mint token using this function 
1904      * This Fn works only when unpaused.
1905      */
1906     function mintTokens(ExternalCreateRequest[] calldata requests) external whenNotPaused {
1907         require(enableExternalMinting == true, "minting disabled");
1908         for (uint32 i=0; i < requests.length; i++) {
1909             ExternalCreateRequest memory request = requests[i];
1910             // If a token is burnt _exists will return 0.
1911             require(_exists(request.tokenId) == false, "token exists");
1912             require(request.owner == msg.sender, "owner error");
1913             require(totalSupply() + 1 <= totalMediaSupply, "exceeded supply");
1914             ChainSignatureRequest memory signatureRequest = ChainSignatureRequest(request.tokenId, request.owner, address(this));
1915             bytes32 encodedRequest = keccak256(abi.encode(signatureRequest));
1916             address addressWhoSigned = encodedRequest.recover(request.signature);
1917             require(addressWhoSigned == signerAddress, "sig error");
1918             _safeMint(msg.sender, request.tokenId);
1919         }
1920     }
1921 
1922     function oboMintTokens(OBOCreateRequest[] calldata requests) external isApprovedOBO {
1923         for (uint32 i=0; i < requests.length; i++) {
1924             OBOCreateRequest memory request = requests[i];
1925             require(_exists(request.tokenId) == false, "token exists");
1926             require(totalSupply() + 1 <= totalMediaSupply, "exceeded supply");
1927             _safeMint(request.owner, request.tokenId);
1928         }
1929     }
1930 
1931     /**
1932      * Override the isApprovalForAll to check for a special oboApproval list.  Reason for this
1933      * is that we can can easily remove obo operators if they every become compromised.
1934      */
1935     function isApprovedForAll(address _owner, address _operator) public view override registryInitialized returns (bool) {
1936         if (creatorRegistryStore.isOperatorApprovedForCustodialAccount(_operator, _owner) == true) {
1937             return true;
1938         } else {
1939             return super.isApprovedForAll(_owner, _operator);
1940         }
1941     }
1942 
1943          /**
1944      * Validates that the Registered store is initialized.
1945      */
1946     modifier registryInitialized() {
1947         require(address(creatorRegistryStore) != address(0), "registry = 0x0");
1948         _;
1949     }
1950 
1951     function royaltyInfo(uint256, uint256 _salePrice) external view returns (
1952             address _creator, uint256 _payout) {
1953         return (creator, (_salePrice * royaltyPercentage / 10000));
1954     }
1955 
1956     function pause() external onlyOwner {
1957         _pause();
1958     }
1959 
1960     function unpause() external onlyOwner {
1961         _unpause();
1962     }
1963 }