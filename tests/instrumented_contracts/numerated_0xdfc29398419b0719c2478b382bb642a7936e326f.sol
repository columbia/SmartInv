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
56 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
57 
58 pragma solidity ^0.8.0;
59 
60 /**
61  * @dev String operations.
62  */
63 library Strings {
64     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
68      */
69     function toString(uint256 value) internal pure returns (string memory) {
70         // Inspired by OraclizeAPI's implementation - MIT licence
71         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
72 
73         if (value == 0) {
74             return "0";
75         }
76         uint256 temp = value;
77         uint256 digits;
78         while (temp != 0) {
79             digits++;
80             temp /= 10;
81         }
82         bytes memory buffer = new bytes(digits);
83         while (value != 0) {
84             digits -= 1;
85             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
86             value /= 10;
87         }
88         return string(buffer);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
93      */
94     function toHexString(uint256 value) internal pure returns (string memory) {
95         if (value == 0) {
96             return "0x00";
97         }
98         uint256 temp = value;
99         uint256 length = 0;
100         while (temp != 0) {
101             length++;
102             temp >>= 8;
103         }
104         return toHexString(value, length);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
109      */
110     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
111         bytes memory buffer = new bytes(2 * length + 2);
112         buffer[0] = "0";
113         buffer[1] = "x";
114         for (uint256 i = 2 * length + 1; i > 1; --i) {
115             buffer[i] = _HEX_SYMBOLS[value & 0xf];
116             value >>= 4;
117         }
118         require(value == 0, "Strings: hex length insufficient");
119         return string(buffer);
120     }
121 }
122 
123 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
124 
125 
126 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 
131 /**
132  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
133  *
134  * These functions can be used to verify that a message was signed by the holder
135  * of the private keys of a given address.
136  */
137 library ECDSA {
138     enum RecoverError {
139         NoError,
140         InvalidSignature,
141         InvalidSignatureLength,
142         InvalidSignatureS,
143         InvalidSignatureV
144     }
145 
146     function _throwError(RecoverError error) private pure {
147         if (error == RecoverError.NoError) {
148             return; // no error: do nothing
149         } else if (error == RecoverError.InvalidSignature) {
150             revert("ECDSA: invalid signature");
151         } else if (error == RecoverError.InvalidSignatureLength) {
152             revert("ECDSA: invalid signature length");
153         } else if (error == RecoverError.InvalidSignatureS) {
154             revert("ECDSA: invalid signature 's' value");
155         } else if (error == RecoverError.InvalidSignatureV) {
156             revert("ECDSA: invalid signature 'v' value");
157         }
158     }
159 
160     /**
161      * @dev Returns the address that signed a hashed message (`hash`) with
162      * `signature` or error string. This address can then be used for verification purposes.
163      *
164      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
165      * this function rejects them by requiring the `s` value to be in the lower
166      * half order, and the `v` value to be either 27 or 28.
167      *
168      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
169      * verification to be secure: it is possible to craft signatures that
170      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
171      * this is by receiving a hash of the original message (which may otherwise
172      * be too long), and then calling {toEthSignedMessageHash} on it.
173      *
174      * Documentation for signature generation:
175      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
176      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
177      *
178      * _Available since v4.3._
179      */
180     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
181         // Check the signature length
182         // - case 65: r,s,v signature (standard)
183         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
184         if (signature.length == 65) {
185             bytes32 r;
186             bytes32 s;
187             uint8 v;
188             // ecrecover takes the signature parameters, and the only way to get them
189             // currently is to use assembly.
190             assembly {
191                 r := mload(add(signature, 0x20))
192                 s := mload(add(signature, 0x40))
193                 v := byte(0, mload(add(signature, 0x60)))
194             }
195             return tryRecover(hash, v, r, s);
196         } else if (signature.length == 64) {
197             bytes32 r;
198             bytes32 vs;
199             // ecrecover takes the signature parameters, and the only way to get them
200             // currently is to use assembly.
201             assembly {
202                 r := mload(add(signature, 0x20))
203                 vs := mload(add(signature, 0x40))
204             }
205             return tryRecover(hash, r, vs);
206         } else {
207             return (address(0), RecoverError.InvalidSignatureLength);
208         }
209     }
210 
211     /**
212      * @dev Returns the address that signed a hashed message (`hash`) with
213      * `signature`. This address can then be used for verification purposes.
214      *
215      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
216      * this function rejects them by requiring the `s` value to be in the lower
217      * half order, and the `v` value to be either 27 or 28.
218      *
219      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
220      * verification to be secure: it is possible to craft signatures that
221      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
222      * this is by receiving a hash of the original message (which may otherwise
223      * be too long), and then calling {toEthSignedMessageHash} on it.
224      */
225     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
226         (address recovered, RecoverError error) = tryRecover(hash, signature);
227         _throwError(error);
228         return recovered;
229     }
230 
231     /**
232      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
233      *
234      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
235      *
236      * _Available since v4.3._
237      */
238     function tryRecover(
239         bytes32 hash,
240         bytes32 r,
241         bytes32 vs
242     ) internal pure returns (address, RecoverError) {
243         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
244         uint8 v = uint8((uint256(vs) >> 255) + 27);
245         return tryRecover(hash, v, r, s);
246     }
247 
248     /**
249      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
250      *
251      * _Available since v4.2._
252      */
253     function recover(
254         bytes32 hash,
255         bytes32 r,
256         bytes32 vs
257     ) internal pure returns (address) {
258         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
259         _throwError(error);
260         return recovered;
261     }
262 
263     /**
264      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
265      * `r` and `s` signature fields separately.
266      *
267      * _Available since v4.3._
268      */
269     function tryRecover(
270         bytes32 hash,
271         uint8 v,
272         bytes32 r,
273         bytes32 s
274     ) internal pure returns (address, RecoverError) {
275         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
276         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
277         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
278         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
279         //
280         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
281         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
282         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
283         // these malleable signatures as well.
284         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
285             return (address(0), RecoverError.InvalidSignatureS);
286         }
287         if (v != 27 && v != 28) {
288             return (address(0), RecoverError.InvalidSignatureV);
289         }
290 
291         // If the signature is valid (and not malleable), return the signer address
292         address signer = ecrecover(hash, v, r, s);
293         if (signer == address(0)) {
294             return (address(0), RecoverError.InvalidSignature);
295         }
296 
297         return (signer, RecoverError.NoError);
298     }
299 
300     /**
301      * @dev Overload of {ECDSA-recover} that receives the `v`,
302      * `r` and `s` signature fields separately.
303      */
304     function recover(
305         bytes32 hash,
306         uint8 v,
307         bytes32 r,
308         bytes32 s
309     ) internal pure returns (address) {
310         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
311         _throwError(error);
312         return recovered;
313     }
314 
315     /**
316      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
317      * produces hash corresponding to the one signed with the
318      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
319      * JSON-RPC method as part of EIP-191.
320      *
321      * See {recover}.
322      */
323     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
324         // 32 is the length in bytes of hash,
325         // enforced by the type signature above
326         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
327     }
328 
329     /**
330      * @dev Returns an Ethereum Signed Message, created from `s`. This
331      * produces hash corresponding to the one signed with the
332      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
333      * JSON-RPC method as part of EIP-191.
334      *
335      * See {recover}.
336      */
337     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
338         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
339     }
340 
341     /**
342      * @dev Returns an Ethereum Signed Typed Data, created from a
343      * `domainSeparator` and a `structHash`. This produces hash corresponding
344      * to the one signed with the
345      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
346      * JSON-RPC method as part of EIP-712.
347      *
348      * See {recover}.
349      */
350     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
351         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
352     }
353 }
354 
355 // File: @openzeppelin/contracts/utils/Context.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/access/Ownable.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 /**
391  * @dev Contract module which provides a basic access control mechanism, where
392  * there is an account (an owner) that can be granted exclusive access to
393  * specific functions.
394  *
395  * By default, the owner account will be the one that deploys the contract. This
396  * can later be changed with {transferOwnership}.
397  *
398  * This module is used through inheritance. It will make available the modifier
399  * `onlyOwner`, which can be applied to your functions to restrict their use to
400  * the owner.
401  */
402 abstract contract Ownable is Context {
403     address private _owner;
404 
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
406 
407     /**
408      * @dev Initializes the contract setting the deployer as the initial owner.
409      */
410     constructor() {
411         _transferOwnership(_msgSender());
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view virtual returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(owner() == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429     /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         _transferOwnership(address(0));
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Can only be called by the current owner.
443      */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         _transferOwnership(newOwner);
447     }
448 
449     /**
450      * @dev Transfers ownership of the contract to a new account (`newOwner`).
451      * Internal function without access restriction.
452      */
453     function _transferOwnership(address newOwner) internal virtual {
454         address oldOwner = _owner;
455         _owner = newOwner;
456         emit OwnershipTransferred(oldOwner, newOwner);
457     }
458 }
459 
460 // File: OBOControl.sol
461 
462 
463 
464 pragma solidity 0.8.9;
465 
466 
467 
468 contract OBOControl is Ownable {
469     address public oboAdmin;
470     uint256 constant public newAddressWaitPeriod = 1 days;
471     bool public canAddOBOImmediately = true;
472 
473     // List of approved on behalf of users.
474     mapping (address => uint256) public approvedOBOs;
475 
476     event NewOBOAddressEvent(
477         address OBOAddress,
478         bool action);
479 
480     event NewOBOAdminAddressEvent(
481         address oboAdminAddress);
482 
483     modifier onlyOBOAdmin() {
484         require(owner() == _msgSender() || oboAdmin == _msgSender(), "not oboAdmin");
485         _;
486     }
487 
488     function setOBOAdmin(address _oboAdmin) external onlyOwner {
489         oboAdmin = _oboAdmin;
490         emit NewOBOAdminAddressEvent(_oboAdmin);
491     }
492 
493     /**
494      * Add a new approvedOBO address. The address can be used after wait period.
495      */
496     function addApprovedOBO(address _oboAddress) external onlyOBOAdmin {
497         require(_oboAddress != address(0), "cant set to 0x");
498         require(approvedOBOs[_oboAddress] == 0, "already added");
499         approvedOBOs[_oboAddress] = block.timestamp;
500         emit NewOBOAddressEvent(_oboAddress, true);
501     }
502 
503     /**
504      * Removes an approvedOBO immediately.
505      */
506     function removeApprovedOBO(address _oboAddress) external onlyOBOAdmin {
507         delete approvedOBOs[_oboAddress];
508         emit NewOBOAddressEvent(_oboAddress, false);
509     }
510 
511     /*
512      * Add OBOAddress for immediate use. This is an internal only Fn that is called
513      * only when the contract is deployed.
514      */
515     function addApprovedOBOImmediately(address _oboAddress) internal onlyOwner {
516         require(_oboAddress != address(0), "addr(0)");
517         // set the date to one in past so that address is active immediately.
518         approvedOBOs[_oboAddress] = block.timestamp - newAddressWaitPeriod - 1;
519         emit NewOBOAddressEvent(_oboAddress, true);
520     }
521 
522     function addApprovedOBOAfterDeploy(address _oboAddress) external onlyOBOAdmin {
523         require(canAddOBOImmediately == true, "disabled");
524         addApprovedOBOImmediately(_oboAddress);
525     }
526 
527     function blockImmediateOBO() external onlyOBOAdmin {
528         canAddOBOImmediately = false;
529     }
530 
531     /*
532      * Helper function to verify is a given address is a valid approvedOBO address.
533      */
534     function isValidApprovedOBO(address _oboAddress) public view returns (bool) {
535         uint256 createdAt = approvedOBOs[_oboAddress];
536         if (createdAt == 0) {
537             return false;
538         }
539         return block.timestamp - createdAt > newAddressWaitPeriod;
540     }
541 
542     /**
543     * @dev Modifier to make the obo calls only callable by approved addressess
544     */
545     modifier isApprovedOBO() {
546         require(isValidApprovedOBO(msg.sender), "unauthorized OBO user");
547         _;
548     }
549 }
550 // File: @openzeppelin/contracts/security/Pausable.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Contract module which allows children to implement an emergency stop
560  * mechanism that can be triggered by an authorized account.
561  *
562  * This module is used through inheritance. It will make available the
563  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
564  * the functions of your contract. Note that they will not be pausable by
565  * simply including this module, only once the modifiers are put in place.
566  */
567 abstract contract Pausable is Context {
568     /**
569      * @dev Emitted when the pause is triggered by `account`.
570      */
571     event Paused(address account);
572 
573     /**
574      * @dev Emitted when the pause is lifted by `account`.
575      */
576     event Unpaused(address account);
577 
578     bool private _paused;
579 
580     /**
581      * @dev Initializes the contract in unpaused state.
582      */
583     constructor() {
584         _paused = false;
585     }
586 
587     /**
588      * @dev Returns true if the contract is paused, and false otherwise.
589      */
590     function paused() public view virtual returns (bool) {
591         return _paused;
592     }
593 
594     /**
595      * @dev Modifier to make a function callable only when the contract is not paused.
596      *
597      * Requirements:
598      *
599      * - The contract must not be paused.
600      */
601     modifier whenNotPaused() {
602         require(!paused(), "Pausable: paused");
603         _;
604     }
605 
606     /**
607      * @dev Modifier to make a function callable only when the contract is paused.
608      *
609      * Requirements:
610      *
611      * - The contract must be paused.
612      */
613     modifier whenPaused() {
614         require(paused(), "Pausable: not paused");
615         _;
616     }
617 
618     /**
619      * @dev Triggers stopped state.
620      *
621      * Requirements:
622      *
623      * - The contract must not be paused.
624      */
625     function _pause() internal virtual whenNotPaused {
626         _paused = true;
627         emit Paused(_msgSender());
628     }
629 
630     /**
631      * @dev Returns to normal state.
632      *
633      * Requirements:
634      *
635      * - The contract must be paused.
636      */
637     function _unpause() internal virtual whenPaused {
638         _paused = false;
639         emit Unpaused(_msgSender());
640     }
641 }
642 
643 // File: @openzeppelin/contracts/utils/Address.sol
644 
645 
646 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
647 
648 pragma solidity ^0.8.1;
649 
650 /**
651  * @dev Collection of functions related to the address type
652  */
653 library Address {
654     /**
655      * @dev Returns true if `account` is a contract.
656      *
657      * [IMPORTANT]
658      * ====
659      * It is unsafe to assume that an address for which this function returns
660      * false is an externally-owned account (EOA) and not a contract.
661      *
662      * Among others, `isContract` will return false for the following
663      * types of addresses:
664      *
665      *  - an externally-owned account
666      *  - a contract in construction
667      *  - an address where a contract will be created
668      *  - an address where a contract lived, but was destroyed
669      * ====
670      *
671      * [IMPORTANT]
672      * ====
673      * You shouldn't rely on `isContract` to protect against flash loan attacks!
674      *
675      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
676      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
677      * constructor.
678      * ====
679      */
680     function isContract(address account) internal view returns (bool) {
681         // This method relies on extcodesize/address.code.length, which returns 0
682         // for contracts in construction, since the code is only stored at the end
683         // of the constructor execution.
684 
685         return account.code.length > 0;
686     }
687 
688     /**
689      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
690      * `recipient`, forwarding all available gas and reverting on errors.
691      *
692      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
693      * of certain opcodes, possibly making contracts go over the 2300 gas limit
694      * imposed by `transfer`, making them unable to receive funds via
695      * `transfer`. {sendValue} removes this limitation.
696      *
697      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
698      *
699      * IMPORTANT: because control is transferred to `recipient`, care must be
700      * taken to not create reentrancy vulnerabilities. Consider using
701      * {ReentrancyGuard} or the
702      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
703      */
704     function sendValue(address payable recipient, uint256 amount) internal {
705         require(address(this).balance >= amount, "Address: insufficient balance");
706 
707         (bool success, ) = recipient.call{value: amount}("");
708         require(success, "Address: unable to send value, recipient may have reverted");
709     }
710 
711     /**
712      * @dev Performs a Solidity function call using a low level `call`. A
713      * plain `call` is an unsafe replacement for a function call: use this
714      * function instead.
715      *
716      * If `target` reverts with a revert reason, it is bubbled up by this
717      * function (like regular Solidity function calls).
718      *
719      * Returns the raw returned data. To convert to the expected return value,
720      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
721      *
722      * Requirements:
723      *
724      * - `target` must be a contract.
725      * - calling `target` with `data` must not revert.
726      *
727      * _Available since v3.1._
728      */
729     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
730         return functionCall(target, data, "Address: low-level call failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
735      * `errorMessage` as a fallback revert reason when `target` reverts.
736      *
737      * _Available since v3.1._
738      */
739     function functionCall(
740         address target,
741         bytes memory data,
742         string memory errorMessage
743     ) internal returns (bytes memory) {
744         return functionCallWithValue(target, data, 0, errorMessage);
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
749      * but also transferring `value` wei to `target`.
750      *
751      * Requirements:
752      *
753      * - the calling contract must have an ETH balance of at least `value`.
754      * - the called Solidity function must be `payable`.
755      *
756      * _Available since v3.1._
757      */
758     function functionCallWithValue(
759         address target,
760         bytes memory data,
761         uint256 value
762     ) internal returns (bytes memory) {
763         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
764     }
765 
766     /**
767      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
768      * with `errorMessage` as a fallback revert reason when `target` reverts.
769      *
770      * _Available since v3.1._
771      */
772     function functionCallWithValue(
773         address target,
774         bytes memory data,
775         uint256 value,
776         string memory errorMessage
777     ) internal returns (bytes memory) {
778         require(address(this).balance >= value, "Address: insufficient balance for call");
779         require(isContract(target), "Address: call to non-contract");
780 
781         (bool success, bytes memory returndata) = target.call{value: value}(data);
782         return verifyCallResult(success, returndata, errorMessage);
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
787      * but performing a static call.
788      *
789      * _Available since v3.3._
790      */
791     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
792         return functionStaticCall(target, data, "Address: low-level static call failed");
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
797      * but performing a static call.
798      *
799      * _Available since v3.3._
800      */
801     function functionStaticCall(
802         address target,
803         bytes memory data,
804         string memory errorMessage
805     ) internal view returns (bytes memory) {
806         require(isContract(target), "Address: static call to non-contract");
807 
808         (bool success, bytes memory returndata) = target.staticcall(data);
809         return verifyCallResult(success, returndata, errorMessage);
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
814      * but performing a delegate call.
815      *
816      * _Available since v3.4._
817      */
818     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
819         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
820     }
821 
822     /**
823      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
824      * but performing a delegate call.
825      *
826      * _Available since v3.4._
827      */
828     function functionDelegateCall(
829         address target,
830         bytes memory data,
831         string memory errorMessage
832     ) internal returns (bytes memory) {
833         require(isContract(target), "Address: delegate call to non-contract");
834 
835         (bool success, bytes memory returndata) = target.delegatecall(data);
836         return verifyCallResult(success, returndata, errorMessage);
837     }
838 
839     /**
840      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
841      * revert reason using the provided one.
842      *
843      * _Available since v4.3._
844      */
845     function verifyCallResult(
846         bool success,
847         bytes memory returndata,
848         string memory errorMessage
849     ) internal pure returns (bytes memory) {
850         if (success) {
851             return returndata;
852         } else {
853             // Look for revert reason and bubble it up if present
854             if (returndata.length > 0) {
855                 // The easiest way to bubble the revert reason is using memory via assembly
856 
857                 assembly {
858                     let returndata_size := mload(returndata)
859                     revert(add(32, returndata), returndata_size)
860                 }
861             } else {
862                 revert(errorMessage);
863             }
864         }
865     }
866 }
867 
868 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
869 
870 
871 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 /**
876  * @title ERC721 token receiver interface
877  * @dev Interface for any contract that wants to support safeTransfers
878  * from ERC721 asset contracts.
879  */
880 interface IERC721Receiver {
881     /**
882      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
883      * by `operator` from `from`, this function is called.
884      *
885      * It must return its Solidity selector to confirm the token transfer.
886      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
887      *
888      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
889      */
890     function onERC721Received(
891         address operator,
892         address from,
893         uint256 tokenId,
894         bytes calldata data
895     ) external returns (bytes4);
896 }
897 
898 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
899 
900 
901 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 /**
906  * @dev Interface of the ERC165 standard, as defined in the
907  * https://eips.ethereum.org/EIPS/eip-165[EIP].
908  *
909  * Implementers can declare support of contract interfaces, which can then be
910  * queried by others ({ERC165Checker}).
911  *
912  * For an implementation, see {ERC165}.
913  */
914 interface IERC165 {
915     /**
916      * @dev Returns true if this contract implements the interface defined by
917      * `interfaceId`. See the corresponding
918      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
919      * to learn more about how these ids are created.
920      *
921      * This function call must use less than 30 000 gas.
922      */
923     function supportsInterface(bytes4 interfaceId) external view returns (bool);
924 }
925 
926 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
927 
928 
929 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
930 
931 pragma solidity ^0.8.0;
932 
933 
934 /**
935  * @dev Implementation of the {IERC165} interface.
936  *
937  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
938  * for the additional interface id that will be supported. For example:
939  *
940  * ```solidity
941  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
942  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
943  * }
944  * ```
945  *
946  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
947  */
948 abstract contract ERC165 is IERC165 {
949     /**
950      * @dev See {IERC165-supportsInterface}.
951      */
952     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
953         return interfaceId == type(IERC165).interfaceId;
954     }
955 }
956 
957 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
958 
959 
960 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @dev Required interface of an ERC721 compliant contract.
967  */
968 interface IERC721 is IERC165 {
969     /**
970      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
971      */
972     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
973 
974     /**
975      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
976      */
977     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
978 
979     /**
980      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
981      */
982     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
983 
984     /**
985      * @dev Returns the number of tokens in ``owner``'s account.
986      */
987     function balanceOf(address owner) external view returns (uint256 balance);
988 
989     /**
990      * @dev Returns the owner of the `tokenId` token.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must exist.
995      */
996     function ownerOf(uint256 tokenId) external view returns (address owner);
997 
998     /**
999      * @dev Safely transfers `tokenId` token from `from` to `to`.
1000      *
1001      * Requirements:
1002      *
1003      * - `from` cannot be the zero address.
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must exist and be owned by `from`.
1006      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1007      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function safeTransferFrom(
1012         address from,
1013         address to,
1014         uint256 tokenId,
1015         bytes calldata data
1016     ) external;
1017 
1018     /**
1019      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1020      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1021      *
1022      * Requirements:
1023      *
1024      * - `from` cannot be the zero address.
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must exist and be owned by `from`.
1027      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1028      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) external;
1037 
1038     /**
1039      * @dev Transfers `tokenId` token from `from` to `to`.
1040      *
1041      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1042      *
1043      * Requirements:
1044      *
1045      * - `from` cannot be the zero address.
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function transferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) external;
1057 
1058     /**
1059      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1060      * The approval is cleared when the token is transferred.
1061      *
1062      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1063      *
1064      * Requirements:
1065      *
1066      * - The caller must own the token or be an approved operator.
1067      * - `tokenId` must exist.
1068      *
1069      * Emits an {Approval} event.
1070      */
1071     function approve(address to, uint256 tokenId) external;
1072 
1073     /**
1074      * @dev Approve or remove `operator` as an operator for the caller.
1075      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1076      *
1077      * Requirements:
1078      *
1079      * - The `operator` cannot be the caller.
1080      *
1081      * Emits an {ApprovalForAll} event.
1082      */
1083     function setApprovalForAll(address operator, bool _approved) external;
1084 
1085     /**
1086      * @dev Returns the account approved for `tokenId` token.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      */
1092     function getApproved(uint256 tokenId) external view returns (address operator);
1093 
1094     /**
1095      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1096      *
1097      * See {setApprovalForAll}
1098      */
1099     function isApprovedForAll(address owner, address operator) external view returns (bool);
1100 }
1101 
1102 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1103 
1104 
1105 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Enumerable is IERC721 {
1115     /**
1116      * @dev Returns the total amount of tokens stored by the contract.
1117      */
1118     function totalSupply() external view returns (uint256);
1119 
1120     /**
1121      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1122      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1123      */
1124     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1125 
1126     /**
1127      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1128      * Use along with {totalSupply} to enumerate all tokens.
1129      */
1130     function tokenByIndex(uint256 index) external view returns (uint256);
1131 }
1132 
1133 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1134 
1135 
1136 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 
1141 /**
1142  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1143  * @dev See https://eips.ethereum.org/EIPS/eip-721
1144  */
1145 interface IERC721Metadata is IERC721 {
1146     /**
1147      * @dev Returns the token collection name.
1148      */
1149     function name() external view returns (string memory);
1150 
1151     /**
1152      * @dev Returns the token collection symbol.
1153      */
1154     function symbol() external view returns (string memory);
1155 
1156     /**
1157      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1158      */
1159     function tokenURI(uint256 tokenId) external view returns (string memory);
1160 }
1161 
1162 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1163 
1164 
1165 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1166 
1167 pragma solidity ^0.8.0;
1168 
1169 
1170 
1171 
1172 
1173 
1174 
1175 
1176 /**
1177  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1178  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1179  * {ERC721Enumerable}.
1180  */
1181 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1182     using Address for address;
1183     using Strings for uint256;
1184 
1185     // Token name
1186     string private _name;
1187 
1188     // Token symbol
1189     string private _symbol;
1190 
1191     // Mapping from token ID to owner address
1192     mapping(uint256 => address) private _owners;
1193 
1194     // Mapping owner address to token count
1195     mapping(address => uint256) private _balances;
1196 
1197     // Mapping from token ID to approved address
1198     mapping(uint256 => address) private _tokenApprovals;
1199 
1200     // Mapping from owner to operator approvals
1201     mapping(address => mapping(address => bool)) private _operatorApprovals;
1202 
1203     /**
1204      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1205      */
1206     constructor(string memory name_, string memory symbol_) {
1207         _name = name_;
1208         _symbol = symbol_;
1209     }
1210 
1211     /**
1212      * @dev See {IERC165-supportsInterface}.
1213      */
1214     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1215         return
1216             interfaceId == type(IERC721).interfaceId ||
1217             interfaceId == type(IERC721Metadata).interfaceId ||
1218             super.supportsInterface(interfaceId);
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-balanceOf}.
1223      */
1224     function balanceOf(address owner) public view virtual override returns (uint256) {
1225         require(owner != address(0), "ERC721: balance query for the zero address");
1226         return _balances[owner];
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-ownerOf}.
1231      */
1232     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1233         address owner = _owners[tokenId];
1234         require(owner != address(0), "ERC721: owner query for nonexistent token");
1235         return owner;
1236     }
1237 
1238     /**
1239      * @dev See {IERC721Metadata-name}.
1240      */
1241     function name() public view virtual override returns (string memory) {
1242         return _name;
1243     }
1244 
1245     /**
1246      * @dev See {IERC721Metadata-symbol}.
1247      */
1248     function symbol() public view virtual override returns (string memory) {
1249         return _symbol;
1250     }
1251 
1252     /**
1253      * @dev See {IERC721Metadata-tokenURI}.
1254      */
1255     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1256         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1257 
1258         string memory baseURI = _baseURI();
1259         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1260     }
1261 
1262     /**
1263      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1264      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1265      * by default, can be overridden in child contracts.
1266      */
1267     function _baseURI() internal view virtual returns (string memory) {
1268         return "";
1269     }
1270 
1271     /**
1272      * @dev See {IERC721-approve}.
1273      */
1274     function approve(address to, uint256 tokenId) public virtual override {
1275         address owner = ERC721.ownerOf(tokenId);
1276         require(to != owner, "ERC721: approval to current owner");
1277 
1278         require(
1279             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1280             "ERC721: approve caller is not owner nor approved for all"
1281         );
1282 
1283         _approve(to, tokenId);
1284     }
1285 
1286     /**
1287      * @dev See {IERC721-getApproved}.
1288      */
1289     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1290         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1291 
1292         return _tokenApprovals[tokenId];
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-setApprovalForAll}.
1297      */
1298     function setApprovalForAll(address operator, bool approved) public virtual override {
1299         _setApprovalForAll(_msgSender(), operator, approved);
1300     }
1301 
1302     /**
1303      * @dev See {IERC721-isApprovedForAll}.
1304      */
1305     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1306         return _operatorApprovals[owner][operator];
1307     }
1308 
1309     /**
1310      * @dev See {IERC721-transferFrom}.
1311      */
1312     function transferFrom(
1313         address from,
1314         address to,
1315         uint256 tokenId
1316     ) public virtual override {
1317         //solhint-disable-next-line max-line-length
1318         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1319 
1320         _transfer(from, to, tokenId);
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-safeTransferFrom}.
1325      */
1326     function safeTransferFrom(
1327         address from,
1328         address to,
1329         uint256 tokenId
1330     ) public virtual override {
1331         safeTransferFrom(from, to, tokenId, "");
1332     }
1333 
1334     /**
1335      * @dev See {IERC721-safeTransferFrom}.
1336      */
1337     function safeTransferFrom(
1338         address from,
1339         address to,
1340         uint256 tokenId,
1341         bytes memory _data
1342     ) public virtual override {
1343         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1344         _safeTransfer(from, to, tokenId, _data);
1345     }
1346 
1347     /**
1348      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1349      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1350      *
1351      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1352      *
1353      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1354      * implement alternative mechanisms to perform token transfer, such as signature-based.
1355      *
1356      * Requirements:
1357      *
1358      * - `from` cannot be the zero address.
1359      * - `to` cannot be the zero address.
1360      * - `tokenId` token must exist and be owned by `from`.
1361      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function _safeTransfer(
1366         address from,
1367         address to,
1368         uint256 tokenId,
1369         bytes memory _data
1370     ) internal virtual {
1371         _transfer(from, to, tokenId);
1372         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1373     }
1374 
1375     /**
1376      * @dev Returns whether `tokenId` exists.
1377      *
1378      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1379      *
1380      * Tokens start existing when they are minted (`_mint`),
1381      * and stop existing when they are burned (`_burn`).
1382      */
1383     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1384         return _owners[tokenId] != address(0);
1385     }
1386 
1387     /**
1388      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1389      *
1390      * Requirements:
1391      *
1392      * - `tokenId` must exist.
1393      */
1394     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1395         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1396         address owner = ERC721.ownerOf(tokenId);
1397         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1398     }
1399 
1400     /**
1401      * @dev Safely mints `tokenId` and transfers it to `to`.
1402      *
1403      * Requirements:
1404      *
1405      * - `tokenId` must not exist.
1406      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1407      *
1408      * Emits a {Transfer} event.
1409      */
1410     function _safeMint(address to, uint256 tokenId) internal virtual {
1411         _safeMint(to, tokenId, "");
1412     }
1413 
1414     /**
1415      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1416      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1417      */
1418     function _safeMint(
1419         address to,
1420         uint256 tokenId,
1421         bytes memory _data
1422     ) internal virtual {
1423         _mint(to, tokenId);
1424         require(
1425             _checkOnERC721Received(address(0), to, tokenId, _data),
1426             "ERC721: transfer to non ERC721Receiver implementer"
1427         );
1428     }
1429 
1430     /**
1431      * @dev Mints `tokenId` and transfers it to `to`.
1432      *
1433      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1434      *
1435      * Requirements:
1436      *
1437      * - `tokenId` must not exist.
1438      * - `to` cannot be the zero address.
1439      *
1440      * Emits a {Transfer} event.
1441      */
1442     function _mint(address to, uint256 tokenId) internal virtual {
1443         require(to != address(0), "ERC721: mint to the zero address");
1444         require(!_exists(tokenId), "ERC721: token already minted");
1445 
1446         _beforeTokenTransfer(address(0), to, tokenId);
1447 
1448         _balances[to] += 1;
1449         _owners[tokenId] = to;
1450 
1451         emit Transfer(address(0), to, tokenId);
1452 
1453         _afterTokenTransfer(address(0), to, tokenId);
1454     }
1455 
1456     /**
1457      * @dev Destroys `tokenId`.
1458      * The approval is cleared when the token is burned.
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must exist.
1463      *
1464      * Emits a {Transfer} event.
1465      */
1466     function _burn(uint256 tokenId) internal virtual {
1467         address owner = ERC721.ownerOf(tokenId);
1468 
1469         _beforeTokenTransfer(owner, address(0), tokenId);
1470 
1471         // Clear approvals
1472         _approve(address(0), tokenId);
1473 
1474         _balances[owner] -= 1;
1475         delete _owners[tokenId];
1476 
1477         emit Transfer(owner, address(0), tokenId);
1478 
1479         _afterTokenTransfer(owner, address(0), tokenId);
1480     }
1481 
1482     /**
1483      * @dev Transfers `tokenId` from `from` to `to`.
1484      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1485      *
1486      * Requirements:
1487      *
1488      * - `to` cannot be the zero address.
1489      * - `tokenId` token must be owned by `from`.
1490      *
1491      * Emits a {Transfer} event.
1492      */
1493     function _transfer(
1494         address from,
1495         address to,
1496         uint256 tokenId
1497     ) internal virtual {
1498         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1499         require(to != address(0), "ERC721: transfer to the zero address");
1500 
1501         _beforeTokenTransfer(from, to, tokenId);
1502 
1503         // Clear approvals from the previous owner
1504         _approve(address(0), tokenId);
1505 
1506         _balances[from] -= 1;
1507         _balances[to] += 1;
1508         _owners[tokenId] = to;
1509 
1510         emit Transfer(from, to, tokenId);
1511 
1512         _afterTokenTransfer(from, to, tokenId);
1513     }
1514 
1515     /**
1516      * @dev Approve `to` to operate on `tokenId`
1517      *
1518      * Emits a {Approval} event.
1519      */
1520     function _approve(address to, uint256 tokenId) internal virtual {
1521         _tokenApprovals[tokenId] = to;
1522         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1523     }
1524 
1525     /**
1526      * @dev Approve `operator` to operate on all of `owner` tokens
1527      *
1528      * Emits a {ApprovalForAll} event.
1529      */
1530     function _setApprovalForAll(
1531         address owner,
1532         address operator,
1533         bool approved
1534     ) internal virtual {
1535         require(owner != operator, "ERC721: approve to caller");
1536         _operatorApprovals[owner][operator] = approved;
1537         emit ApprovalForAll(owner, operator, approved);
1538     }
1539 
1540     /**
1541      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1542      * The call is not executed if the target address is not a contract.
1543      *
1544      * @param from address representing the previous owner of the given token ID
1545      * @param to target address that will receive the tokens
1546      * @param tokenId uint256 ID of the token to be transferred
1547      * @param _data bytes optional data to send along with the call
1548      * @return bool whether the call correctly returned the expected magic value
1549      */
1550     function _checkOnERC721Received(
1551         address from,
1552         address to,
1553         uint256 tokenId,
1554         bytes memory _data
1555     ) private returns (bool) {
1556         if (to.isContract()) {
1557             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1558                 return retval == IERC721Receiver.onERC721Received.selector;
1559             } catch (bytes memory reason) {
1560                 if (reason.length == 0) {
1561                     revert("ERC721: transfer to non ERC721Receiver implementer");
1562                 } else {
1563                     assembly {
1564                         revert(add(32, reason), mload(reason))
1565                     }
1566                 }
1567             }
1568         } else {
1569             return true;
1570         }
1571     }
1572 
1573     /**
1574      * @dev Hook that is called before any token transfer. This includes minting
1575      * and burning.
1576      *
1577      * Calling conditions:
1578      *
1579      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1580      * transferred to `to`.
1581      * - When `from` is zero, `tokenId` will be minted for `to`.
1582      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1583      * - `from` and `to` are never both zero.
1584      *
1585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1586      */
1587     function _beforeTokenTransfer(
1588         address from,
1589         address to,
1590         uint256 tokenId
1591     ) internal virtual {}
1592 
1593     /**
1594      * @dev Hook that is called after any transfer of tokens. This includes
1595      * minting and burning.
1596      *
1597      * Calling conditions:
1598      *
1599      * - when `from` and `to` are both non-zero.
1600      * - `from` and `to` are never both zero.
1601      *
1602      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1603      */
1604     function _afterTokenTransfer(
1605         address from,
1606         address to,
1607         uint256 tokenId
1608     ) internal virtual {}
1609 }
1610 
1611 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1612 
1613 
1614 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1615 
1616 pragma solidity ^0.8.0;
1617 
1618 
1619 
1620 /**
1621  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1622  * enumerability of all the token ids in the contract as well as all token ids owned by each
1623  * account.
1624  */
1625 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1626     // Mapping from owner to list of owned token IDs
1627     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1628 
1629     // Mapping from token ID to index of the owner tokens list
1630     mapping(uint256 => uint256) private _ownedTokensIndex;
1631 
1632     // Array with all token ids, used for enumeration
1633     uint256[] private _allTokens;
1634 
1635     // Mapping from token id to position in the allTokens array
1636     mapping(uint256 => uint256) private _allTokensIndex;
1637 
1638     /**
1639      * @dev See {IERC165-supportsInterface}.
1640      */
1641     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1642         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1643     }
1644 
1645     /**
1646      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1647      */
1648     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1649         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1650         return _ownedTokens[owner][index];
1651     }
1652 
1653     /**
1654      * @dev See {IERC721Enumerable-totalSupply}.
1655      */
1656     function totalSupply() public view virtual override returns (uint256) {
1657         return _allTokens.length;
1658     }
1659 
1660     /**
1661      * @dev See {IERC721Enumerable-tokenByIndex}.
1662      */
1663     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1664         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1665         return _allTokens[index];
1666     }
1667 
1668     /**
1669      * @dev Hook that is called before any token transfer. This includes minting
1670      * and burning.
1671      *
1672      * Calling conditions:
1673      *
1674      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1675      * transferred to `to`.
1676      * - When `from` is zero, `tokenId` will be minted for `to`.
1677      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1678      * - `from` cannot be the zero address.
1679      * - `to` cannot be the zero address.
1680      *
1681      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1682      */
1683     function _beforeTokenTransfer(
1684         address from,
1685         address to,
1686         uint256 tokenId
1687     ) internal virtual override {
1688         super._beforeTokenTransfer(from, to, tokenId);
1689 
1690         if (from == address(0)) {
1691             _addTokenToAllTokensEnumeration(tokenId);
1692         } else if (from != to) {
1693             _removeTokenFromOwnerEnumeration(from, tokenId);
1694         }
1695         if (to == address(0)) {
1696             _removeTokenFromAllTokensEnumeration(tokenId);
1697         } else if (to != from) {
1698             _addTokenToOwnerEnumeration(to, tokenId);
1699         }
1700     }
1701 
1702     /**
1703      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1704      * @param to address representing the new owner of the given token ID
1705      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1706      */
1707     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1708         uint256 length = ERC721.balanceOf(to);
1709         _ownedTokens[to][length] = tokenId;
1710         _ownedTokensIndex[tokenId] = length;
1711     }
1712 
1713     /**
1714      * @dev Private function to add a token to this extension's token tracking data structures.
1715      * @param tokenId uint256 ID of the token to be added to the tokens list
1716      */
1717     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1718         _allTokensIndex[tokenId] = _allTokens.length;
1719         _allTokens.push(tokenId);
1720     }
1721 
1722     /**
1723      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1724      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1725      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1726      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1727      * @param from address representing the previous owner of the given token ID
1728      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1729      */
1730     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1731         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1732         // then delete the last slot (swap and pop).
1733 
1734         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1735         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1736 
1737         // When the token to delete is the last token, the swap operation is unnecessary
1738         if (tokenIndex != lastTokenIndex) {
1739             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1740 
1741             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1742             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1743         }
1744 
1745         // This also deletes the contents at the last position of the array
1746         delete _ownedTokensIndex[tokenId];
1747         delete _ownedTokens[from][lastTokenIndex];
1748     }
1749 
1750     /**
1751      * @dev Private function to remove a token from this extension's token tracking data structures.
1752      * This has O(1) time complexity, but alters the order of the _allTokens array.
1753      * @param tokenId uint256 ID of the token to be removed from the tokens list
1754      */
1755     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1756         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1757         // then delete the last slot (swap and pop).
1758 
1759         uint256 lastTokenIndex = _allTokens.length - 1;
1760         uint256 tokenIndex = _allTokensIndex[tokenId];
1761 
1762         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1763         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1764         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1765         uint256 lastTokenId = _allTokens[lastTokenIndex];
1766 
1767         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1768         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1769 
1770         // This also deletes the contents at the last position of the array
1771         delete _allTokensIndex[tokenId];
1772         _allTokens.pop();
1773     }
1774 }
1775 
1776 // File: CollectionCore.sol
1777 
1778 
1779 
1780 pragma solidity 0.8.9;
1781 
1782 
1783 
1784 
1785 
1786 
1787 
1788 
1789 contract CollectionCore is ERC721Enumerable, OBOControl, Pausable {
1790     using ECDSA for bytes32;
1791     uint8 constant public VERSION = 1;
1792     uint16 public immutable royaltyPercentage;
1793     address public immutable creator;
1794     address public signerAddress;
1795     bool public enableExternalMinting;
1796     // by default bool's are false, save gas by not initializing
1797     bool public isImmutable;
1798     uint256 public immutable totalMediaSupply;
1799     string public baseURI;
1800     ApprovedCreatorRegistryInterface public creatorRegistryStore;
1801 
1802     struct ExternalCreateRequest {
1803         address owner;
1804         bytes signature;
1805         uint256 tokenId;
1806     }
1807 
1808     struct OBOCreateRequest {
1809         address owner;
1810         uint256 tokenId;
1811     }
1812 
1813     struct ChainSignatureRequest {
1814         uint256 onchainId;
1815         address owner;
1816         address thisContract;
1817     }
1818 
1819     event NewSignerEvent(
1820         address signer);
1821 
1822     constructor(string memory _tokenName, string memory _tokenSymbol,
1823             address _crsAddress, uint256 _totalSupply,
1824             address _creator, uint16 _royaltyPercentage, string memory _initialBaseURI) ERC721(_tokenName, _tokenSymbol) {
1825         require(_royaltyPercentage > 0 && _royaltyPercentage <= 10000, "invalid royalty");
1826         require(_creator != address(0), "creator = 0x0");
1827         setCreatorRegistryStore(_crsAddress);
1828         require(_totalSupply > 0, "supply > 0");
1829         totalMediaSupply = _totalSupply;
1830         creator = _creator;
1831         royaltyPercentage = _royaltyPercentage;
1832         baseURI = _initialBaseURI;
1833     }
1834 
1835     /*
1836      * Set signer address on the token contract. Setting signer means we are opening
1837      * the token contract for external accounts to create tokens. Call this to change
1838      * the signer immediately.
1839      */
1840     function setSignerAddress(address _signerAddress, bool _enableExternalMinting) external
1841             whenNotPaused isApprovedOBO {
1842         require(_signerAddress != address(0), "cant be zero");
1843         signerAddress = _signerAddress;
1844         enableExternalMinting = _enableExternalMinting;
1845         emit NewSignerEvent(signerAddress);
1846     }
1847 
1848     // Set the creator registry address upon construction. Immutable.
1849     function setCreatorRegistryStore(address _crsAddress) internal {
1850         require(_crsAddress != address(0), "registry = 0x0");
1851         ApprovedCreatorRegistryInterface candidateCreatorRegistryStore = ApprovedCreatorRegistryInterface(_crsAddress);
1852         // require(candidateCreatorRegistryStore.getVersion() == 1, "registry store is not version 1");
1853         // Simple check to make sure we are adding the registry contract indeed
1854         // https://fravoll.github.io/solidity-patterns/string_equality_comparison.html
1855         bytes32 contractType = keccak256(abi.encodePacked(candidateCreatorRegistryStore.typeOfContract()));
1856         // keccak256(abi.encodePacked("approvedCreatorRegistryReadOnly")) = 0x9732b26dfb8751e6f1f71e8f21b28a237cfe383953dce7db3dfa1777abdb2791
1857         require(contractType == 0x9732b26dfb8751e6f1f71e8f21b28a237cfe383953dce7db3dfa1777abdb2791,
1858             "not crtrReadOnlyRegistry");
1859         creatorRegistryStore = candidateCreatorRegistryStore;
1860     }
1861 
1862     function _baseURI() internal view override returns (string memory) {
1863         return baseURI;
1864     }
1865 
1866     /*
1867      * Set BaseURI for the entire collectible project. Only owner can set it to hide / reveal
1868      * baseURI.
1869      */
1870     function setBaseURI(string memory _newBaseURI) external onlyOwner whenNotPaused {
1871         require(isImmutable == false, "cant change");
1872         baseURI = _newBaseURI;
1873     }
1874 
1875     function makeImmutable() external onlyOwner {
1876         isImmutable = true;
1877     }
1878 
1879     /* External users who have been given a signature can mint token using this function 
1880      * This Fn works only when unpaused.
1881      */
1882     function mintTokens(ExternalCreateRequest[] calldata requests) external whenNotPaused {
1883         require(enableExternalMinting == true, "minting disabled");
1884         for (uint32 i=0; i < requests.length; i++) {
1885             ExternalCreateRequest memory request = requests[i];
1886             // If a token is burnt _exists will return 0.
1887             require(_exists(request.tokenId) == false, "token exists");
1888             require(request.owner == msg.sender, "owner error");
1889             require(totalSupply() + 1 <= totalMediaSupply, "exceeded supply");
1890             ChainSignatureRequest memory signatureRequest = ChainSignatureRequest(request.tokenId, request.owner, address(this));
1891             bytes32 encodedRequest = keccak256(abi.encode(signatureRequest));
1892             address addressWhoSigned = encodedRequest.recover(request.signature);
1893             require(addressWhoSigned == signerAddress, "sig error");
1894             _safeMint(msg.sender, request.tokenId);
1895         }
1896     }
1897 
1898     function oboMintTokens(OBOCreateRequest[] calldata requests) external isApprovedOBO {
1899         for (uint32 i=0; i < requests.length; i++) {
1900             OBOCreateRequest memory request = requests[i];
1901             require(_exists(request.tokenId) == false, "token exists");
1902             require(totalSupply() + 1 <= totalMediaSupply, "exceeded supply");
1903             _safeMint(request.owner, request.tokenId);
1904         }
1905     }
1906 
1907     /**
1908      * Override the isApprovalForAll to check for a special oboApproval list.  Reason for this
1909      * is that we can can easily remove obo operators if they every become compromised.
1910      */
1911     function isApprovedForAll(address _owner, address _operator) public view override registryInitialized returns (bool) {
1912         if (creatorRegistryStore.isOperatorApprovedForCustodialAccount(_operator, _owner) == true) {
1913             return true;
1914         } else {
1915             return super.isApprovedForAll(_owner, _operator);
1916         }
1917     }
1918 
1919          /**
1920      * Validates that the Registered store is initialized.
1921      */
1922     modifier registryInitialized() {
1923         require(address(creatorRegistryStore) != address(0), "registry = 0x0");
1924         _;
1925     }
1926 
1927     function royaltyInfo(uint256, uint256 _salePrice) external view returns (
1928             address _creator, uint256 _payout) {
1929         return (creator, (_salePrice * royaltyPercentage / 10000));
1930     }
1931 
1932     function pause() external onlyOwner {
1933         _pause();
1934     }
1935 
1936     function unpause() external onlyOwner {
1937         _unpause();
1938     }
1939 
1940     // TODO: Other collectible project dont expose burn.
1941     // function burn(uint256 _tokenId) external {
1942     //     require(_isApprovedOrOwner(msg.sender, _tokenId), "ERC721: burn caller is not owner nor approved");
1943     //     _burn(_tokenId);
1944     // }
1945 }