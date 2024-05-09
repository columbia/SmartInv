1 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
9  *
10  * These functions can be used to verify that a message was signed by the holder
11  * of the private keys of a given address.
12  */
13 library ECDSA {
14     enum RecoverError {
15         NoError,
16         InvalidSignature,
17         InvalidSignatureLength,
18         InvalidSignatureS,
19         InvalidSignatureV
20     }
21 
22     function _throwError(RecoverError error) private pure {
23         if (error == RecoverError.NoError) {
24             return; // no error: do nothing
25         } else if (error == RecoverError.InvalidSignature) {
26             revert("ECDSA: invalid signature");
27         } else if (error == RecoverError.InvalidSignatureLength) {
28             revert("ECDSA: invalid signature length");
29         } else if (error == RecoverError.InvalidSignatureS) {
30             revert("ECDSA: invalid signature 's' value");
31         } else if (error == RecoverError.InvalidSignatureV) {
32             revert("ECDSA: invalid signature 'v' value");
33         }
34     }
35 
36     /**
37      * @dev Returns the address that signed a hashed message (`hash`) with
38      * `signature` or error string. This address can then be used for verification purposes.
39      *
40      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
41      * this function rejects them by requiring the `s` value to be in the lower
42      * half order, and the `v` value to be either 27 or 28.
43      *
44      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
45      * verification to be secure: it is possible to craft signatures that
46      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
47      * this is by receiving a hash of the original message (which may otherwise
48      * be too long), and then calling {toEthSignedMessageHash} on it.
49      *
50      * Documentation for signature generation:
51      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
52      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
53      *
54      * _Available since v4.3._
55      */
56     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
57         // Check the signature length
58         // - case 65: r,s,v signature (standard)
59         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
60         if (signature.length == 65) {
61             bytes32 r;
62             bytes32 s;
63             uint8 v;
64             // ecrecover takes the signature parameters, and the only way to get them
65             // currently is to use assembly.
66             assembly {
67                 r := mload(add(signature, 0x20))
68                 s := mload(add(signature, 0x40))
69                 v := byte(0, mload(add(signature, 0x60)))
70             }
71             return tryRecover(hash, v, r, s);
72         } else if (signature.length == 64) {
73             bytes32 r;
74             bytes32 vs;
75             // ecrecover takes the signature parameters, and the only way to get them
76             // currently is to use assembly.
77             assembly {
78                 r := mload(add(signature, 0x20))
79                 vs := mload(add(signature, 0x40))
80             }
81             return tryRecover(hash, r, vs);
82         } else {
83             return (address(0), RecoverError.InvalidSignatureLength);
84         }
85     }
86 
87     /**
88      * @dev Returns the address that signed a hashed message (`hash`) with
89      * `signature`. This address can then be used for verification purposes.
90      *
91      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
92      * this function rejects them by requiring the `s` value to be in the lower
93      * half order, and the `v` value to be either 27 or 28.
94      *
95      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
96      * verification to be secure: it is possible to craft signatures that
97      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
98      * this is by receiving a hash of the original message (which may otherwise
99      * be too long), and then calling {toEthSignedMessageHash} on it.
100      */
101     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
102         (address recovered, RecoverError error) = tryRecover(hash, signature);
103         _throwError(error);
104         return recovered;
105     }
106 
107     /**
108      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
109      *
110      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
111      *
112      * _Available since v4.3._
113      */
114     function tryRecover(
115         bytes32 hash,
116         bytes32 r,
117         bytes32 vs
118     ) internal pure returns (address, RecoverError) {
119         bytes32 s;
120         uint8 v;
121         assembly {
122             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
123             v := add(shr(255, vs), 27)
124         }
125         return tryRecover(hash, v, r, s);
126     }
127 
128     /**
129      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
130      *
131      * _Available since v4.2._
132      */
133     function recover(
134         bytes32 hash,
135         bytes32 r,
136         bytes32 vs
137     ) internal pure returns (address) {
138         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
139         _throwError(error);
140         return recovered;
141     }
142 
143     /**
144      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
145      * `r` and `s` signature fields separately.
146      *
147      * _Available since v4.3._
148      */
149     function tryRecover(
150         bytes32 hash,
151         uint8 v,
152         bytes32 r,
153         bytes32 s
154     ) internal pure returns (address, RecoverError) {
155         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
156         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
157         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
158         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
159         //
160         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
161         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
162         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
163         // these malleable signatures as well.
164         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
165             return (address(0), RecoverError.InvalidSignatureS);
166         }
167         if (v != 27 && v != 28) {
168             return (address(0), RecoverError.InvalidSignatureV);
169         }
170 
171         // If the signature is valid (and not malleable), return the signer address
172         address signer = ecrecover(hash, v, r, s);
173         if (signer == address(0)) {
174             return (address(0), RecoverError.InvalidSignature);
175         }
176 
177         return (signer, RecoverError.NoError);
178     }
179 
180     /**
181      * @dev Overload of {ECDSA-recover} that receives the `v`,
182      * `r` and `s` signature fields separately.
183      */
184     function recover(
185         bytes32 hash,
186         uint8 v,
187         bytes32 r,
188         bytes32 s
189     ) internal pure returns (address) {
190         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
191         _throwError(error);
192         return recovered;
193     }
194 
195     /**
196      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
197      * produces hash corresponding to the one signed with the
198      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
199      * JSON-RPC method as part of EIP-191.
200      *
201      * See {recover}.
202      */
203     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
204         // 32 is the length in bytes of hash,
205         // enforced by the type signature above
206         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
207     }
208 
209     /**
210      * @dev Returns an Ethereum Signed Typed Data, created from a
211      * `domainSeparator` and a `structHash`. This produces hash corresponding
212      * to the one signed with the
213      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
214      * JSON-RPC method as part of EIP-712.
215      *
216      * See {recover}.
217      */
218     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
219         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
220     }
221 }
222 
223 // File: VaultCoreInterface.sol
224 
225 
226 
227 pragma solidity 0.8.9;
228 
229 abstract contract VaultCoreInterface {
230     function getVersion() public pure virtual returns (uint);
231     function typeOfContract() public pure virtual returns (bytes32);
232     function approveToken(
233         uint256 _tokenId,
234         address _tokenContractAddress) external virtual;
235 }
236 // File: RoyaltyRegistryInterface.sol
237 
238 
239 
240 pragma solidity 0.8.9;
241 
242 
243 /**
244  * Interface to the RoyaltyRegistry responsible for looking payout addresses
245  */
246 abstract contract RoyaltyRegistryInterface {
247     function getAddress(address custodial) external view virtual returns (address);
248     function getMediaCustomPercentage(uint256 mediaId, address tokenAddress) external view virtual returns(uint16);
249     function getExternalTokenPercentage(uint256 tokenId, address tokenAddress) external view virtual returns(uint16, uint16);
250     function typeOfContract() virtual public pure returns (string calldata);
251     function VERSION() virtual public pure returns (uint8);
252 }
253 // File: ApprovedCreatorRegistryInterface.sol
254 
255 
256 
257 pragma solidity 0.8.9;
258 
259 
260 /**
261  * Interface to the digital media store external contract that is
262  * responsible for storing the common digital media and collection data.
263  * This allows for new token contracts to be deployed and continue to reference
264  * the digital media and collection data.
265  */
266 abstract contract ApprovedCreatorRegistryInterface {
267 
268     function getVersion() virtual public pure returns (uint);
269     function typeOfContract() virtual public pure returns (string calldata);
270     function isOperatorApprovedForCustodialAccount(
271         address _operator,
272         address _custodialAddress) virtual public view returns (bool);
273 
274 }
275 // File: utils/Collaborator.sol
276 
277 
278 
279 pragma solidity 0.8.9;
280 
281 library Collaborator {
282     bytes32 public constant TYPE_HASH = keccak256("Share(address account,uint48 value,uint48 royalty)");
283 
284     struct Share {
285         address payable account;
286         uint48 value;
287         uint48 royalty;
288     }
289 
290     function hash(Share memory part) internal pure returns (bytes32) {
291         return keccak256(abi.encode(TYPE_HASH, part.account, part.value, part.royalty));
292     }
293 }
294 // File: @openzeppelin/contracts/utils/Strings.sol
295 
296 
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev String operations.
302  */
303 library Strings {
304     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
305 
306     /**
307      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
308      */
309     function toString(uint256 value) internal pure returns (string memory) {
310         // Inspired by OraclizeAPI's implementation - MIT licence
311         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
312 
313         if (value == 0) {
314             return "0";
315         }
316         uint256 temp = value;
317         uint256 digits;
318         while (temp != 0) {
319             digits++;
320             temp /= 10;
321         }
322         bytes memory buffer = new bytes(digits);
323         while (value != 0) {
324             digits -= 1;
325             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
326             value /= 10;
327         }
328         return string(buffer);
329     }
330 
331     /**
332      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
333      */
334     function toHexString(uint256 value) internal pure returns (string memory) {
335         if (value == 0) {
336             return "0x00";
337         }
338         uint256 temp = value;
339         uint256 length = 0;
340         while (temp != 0) {
341             length++;
342             temp >>= 8;
343         }
344         return toHexString(value, length);
345     }
346 
347     /**
348      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
349      */
350     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
351         bytes memory buffer = new bytes(2 * length + 2);
352         buffer[0] = "0";
353         buffer[1] = "x";
354         for (uint256 i = 2 * length + 1; i > 1; --i) {
355             buffer[i] = _HEX_SYMBOLS[value & 0xf];
356             value >>= 4;
357         }
358         require(value == 0, "Strings: hex length insufficient");
359         return string(buffer);
360     }
361 }
362 
363 // File: @openzeppelin/contracts/utils/Context.sol
364 
365 
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Provides information about the current execution context, including the
371  * sender of the transaction and its data. While these are generally available
372  * via msg.sender and msg.data, they should not be accessed in such a direct
373  * manner, since when dealing with meta-transactions the account sending and
374  * paying for execution may not be the actual sender (as far as an application
375  * is concerned).
376  *
377  * This contract is only required for intermediate, library-like contracts.
378  */
379 abstract contract Context {
380     function _msgSender() internal view virtual returns (address) {
381         return msg.sender;
382     }
383 
384     function _msgData() internal view virtual returns (bytes calldata) {
385         return msg.data;
386     }
387 }
388 
389 // File: @openzeppelin/contracts/access/Ownable.sol
390 
391 
392 
393 pragma solidity ^0.8.0;
394 
395 
396 /**
397  * @dev Contract module which provides a basic access control mechanism, where
398  * there is an account (an owner) that can be granted exclusive access to
399  * specific functions.
400  *
401  * By default, the owner account will be the one that deploys the contract. This
402  * can later be changed with {transferOwnership}.
403  *
404  * This module is used through inheritance. It will make available the modifier
405  * `onlyOwner`, which can be applied to your functions to restrict their use to
406  * the owner.
407  */
408 abstract contract Ownable is Context {
409     address private _owner;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     /**
414      * @dev Initializes the contract setting the deployer as the initial owner.
415      */
416     constructor() {
417         _setOwner(_msgSender());
418     }
419 
420     /**
421      * @dev Returns the address of the current owner.
422      */
423     function owner() public view virtual returns (address) {
424         return _owner;
425     }
426 
427     /**
428      * @dev Throws if called by any account other than the owner.
429      */
430     modifier onlyOwner() {
431         require(owner() == _msgSender(), "Ownable: caller is not the owner");
432         _;
433     }
434 
435     /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         _setOwner(address(0));
444     }
445 
446     /**
447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
448      * Can only be called by the current owner.
449      */
450     function transferOwnership(address newOwner) public virtual onlyOwner {
451         require(newOwner != address(0), "Ownable: new owner is the zero address");
452         _setOwner(newOwner);
453     }
454 
455     function _setOwner(address newOwner) private {
456         address oldOwner = _owner;
457         _owner = newOwner;
458         emit OwnershipTransferred(oldOwner, newOwner);
459     }
460 }
461 
462 // File: OBOControl.sol
463 
464 
465 
466 pragma solidity 0.8.9;
467 
468 
469 
470 contract OBOControl is Ownable {
471     address public oboAdmin;
472     uint256 constant public newAddressWaitPeriod = 1 days;
473     bool public canAddOBOImmediately = true;
474 
475     // List of approved on behalf of users.
476     mapping (address => uint256) public approvedOBOs;
477 
478     event NewOBOAddressEvent(
479         address OBOAddress,
480         bool action);
481 
482     event NewOBOAdminAddressEvent(
483         address oboAdminAddress);
484 
485     modifier onlyOBOAdmin() {
486         require(owner() == _msgSender() || oboAdmin == _msgSender(), "not oboAdmin");
487         _;
488     }
489 
490     function setOBOAdmin(address _oboAdmin) external onlyOwner {
491         oboAdmin = _oboAdmin;
492         emit NewOBOAdminAddressEvent(_oboAdmin);
493     }
494 
495     /**
496      * Add a new approvedOBO address. The address can be used after wait period.
497      */
498     function addApprovedOBO(address _oboAddress) external onlyOBOAdmin {
499         require(_oboAddress != address(0), "cant set to 0x");
500         require(approvedOBOs[_oboAddress] == 0, "already added");
501         approvedOBOs[_oboAddress] = block.timestamp;
502         emit NewOBOAddressEvent(_oboAddress, true);
503     }
504 
505     /**
506      * Removes an approvedOBO immediately.
507      */
508     function removeApprovedOBO(address _oboAddress) external onlyOBOAdmin {
509         delete approvedOBOs[_oboAddress];
510         emit NewOBOAddressEvent(_oboAddress, false);
511     }
512 
513     /*
514      * Add OBOAddress for immediate use. This is an internal only Fn that is called
515      * only when the contract is deployed.
516      */
517     function addApprovedOBOImmediately(address _oboAddress) internal onlyOwner {
518         require(_oboAddress != address(0), "addr(0)");
519         // set the date to one in past so that address is active immediately.
520         approvedOBOs[_oboAddress] = block.timestamp - newAddressWaitPeriod - 1;
521         emit NewOBOAddressEvent(_oboAddress, true);
522     }
523 
524     function addApprovedOBOAfterDeploy(address _oboAddress) external onlyOBOAdmin {
525         require(canAddOBOImmediately == true, "disabled");
526         addApprovedOBOImmediately(_oboAddress);
527     }
528 
529     function blockImmediateOBO() external onlyOBOAdmin {
530         canAddOBOImmediately = false;
531     }
532 
533     /*
534      * Helper function to verify is a given address is a valid approvedOBO address.
535      */
536     function isValidApprovedOBO(address _oboAddress) public view returns (bool) {
537         uint256 createdAt = approvedOBOs[_oboAddress];
538         if (createdAt == 0) {
539             return false;
540         }
541         return block.timestamp - createdAt > newAddressWaitPeriod;
542     }
543 
544     /**
545     * @dev Modifier to make the obo calls only callable by approved addressess
546     */
547     modifier isApprovedOBO() {
548         require(isValidApprovedOBO(msg.sender), "unauthorized OBO user");
549         _;
550     }
551 }
552 // File: @openzeppelin/contracts/security/Pausable.sol
553 
554 
555 
556 pragma solidity ^0.8.0;
557 
558 
559 /**
560  * @dev Contract module which allows children to implement an emergency stop
561  * mechanism that can be triggered by an authorized account.
562  *
563  * This module is used through inheritance. It will make available the
564  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
565  * the functions of your contract. Note that they will not be pausable by
566  * simply including this module, only once the modifiers are put in place.
567  */
568 abstract contract Pausable is Context {
569     /**
570      * @dev Emitted when the pause is triggered by `account`.
571      */
572     event Paused(address account);
573 
574     /**
575      * @dev Emitted when the pause is lifted by `account`.
576      */
577     event Unpaused(address account);
578 
579     bool private _paused;
580 
581     /**
582      * @dev Initializes the contract in unpaused state.
583      */
584     constructor() {
585         _paused = false;
586     }
587 
588     /**
589      * @dev Returns true if the contract is paused, and false otherwise.
590      */
591     function paused() public view virtual returns (bool) {
592         return _paused;
593     }
594 
595     /**
596      * @dev Modifier to make a function callable only when the contract is not paused.
597      *
598      * Requirements:
599      *
600      * - The contract must not be paused.
601      */
602     modifier whenNotPaused() {
603         require(!paused(), "Pausable: paused");
604         _;
605     }
606 
607     /**
608      * @dev Modifier to make a function callable only when the contract is paused.
609      *
610      * Requirements:
611      *
612      * - The contract must be paused.
613      */
614     modifier whenPaused() {
615         require(paused(), "Pausable: not paused");
616         _;
617     }
618 
619     /**
620      * @dev Triggers stopped state.
621      *
622      * Requirements:
623      *
624      * - The contract must not be paused.
625      */
626     function _pause() internal virtual whenNotPaused {
627         _paused = true;
628         emit Paused(_msgSender());
629     }
630 
631     /**
632      * @dev Returns to normal state.
633      *
634      * Requirements:
635      *
636      * - The contract must be paused.
637      */
638     function _unpause() internal virtual whenPaused {
639         _paused = false;
640         emit Unpaused(_msgSender());
641     }
642 }
643 
644 // File: @openzeppelin/contracts/utils/Address.sol
645 
646 
647 
648 pragma solidity ^0.8.0;
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
670      */
671     function isContract(address account) internal view returns (bool) {
672         // This method relies on extcodesize, which returns 0 for contracts in
673         // construction, since the code is only stored at the end of the
674         // constructor execution.
675 
676         uint256 size;
677         assembly {
678             size := extcodesize(account)
679         }
680         return size > 0;
681     }
682 
683     /**
684      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
685      * `recipient`, forwarding all available gas and reverting on errors.
686      *
687      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
688      * of certain opcodes, possibly making contracts go over the 2300 gas limit
689      * imposed by `transfer`, making them unable to receive funds via
690      * `transfer`. {sendValue} removes this limitation.
691      *
692      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
693      *
694      * IMPORTANT: because control is transferred to `recipient`, care must be
695      * taken to not create reentrancy vulnerabilities. Consider using
696      * {ReentrancyGuard} or the
697      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
698      */
699     function sendValue(address payable recipient, uint256 amount) internal {
700         require(address(this).balance >= amount, "Address: insufficient balance");
701 
702         (bool success, ) = recipient.call{value: amount}("");
703         require(success, "Address: unable to send value, recipient may have reverted");
704     }
705 
706     /**
707      * @dev Performs a Solidity function call using a low level `call`. A
708      * plain `call` is an unsafe replacement for a function call: use this
709      * function instead.
710      *
711      * If `target` reverts with a revert reason, it is bubbled up by this
712      * function (like regular Solidity function calls).
713      *
714      * Returns the raw returned data. To convert to the expected return value,
715      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
716      *
717      * Requirements:
718      *
719      * - `target` must be a contract.
720      * - calling `target` with `data` must not revert.
721      *
722      * _Available since v3.1._
723      */
724     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
725         return functionCall(target, data, "Address: low-level call failed");
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
730      * `errorMessage` as a fallback revert reason when `target` reverts.
731      *
732      * _Available since v3.1._
733      */
734     function functionCall(
735         address target,
736         bytes memory data,
737         string memory errorMessage
738     ) internal returns (bytes memory) {
739         return functionCallWithValue(target, data, 0, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but also transferring `value` wei to `target`.
745      *
746      * Requirements:
747      *
748      * - the calling contract must have an ETH balance of at least `value`.
749      * - the called Solidity function must be `payable`.
750      *
751      * _Available since v3.1._
752      */
753     function functionCallWithValue(
754         address target,
755         bytes memory data,
756         uint256 value
757     ) internal returns (bytes memory) {
758         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
759     }
760 
761     /**
762      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
763      * with `errorMessage` as a fallback revert reason when `target` reverts.
764      *
765      * _Available since v3.1._
766      */
767     function functionCallWithValue(
768         address target,
769         bytes memory data,
770         uint256 value,
771         string memory errorMessage
772     ) internal returns (bytes memory) {
773         require(address(this).balance >= value, "Address: insufficient balance for call");
774         require(isContract(target), "Address: call to non-contract");
775 
776         (bool success, bytes memory returndata) = target.call{value: value}(data);
777         return verifyCallResult(success, returndata, errorMessage);
778     }
779 
780     /**
781      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
782      * but performing a static call.
783      *
784      * _Available since v3.3._
785      */
786     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
787         return functionStaticCall(target, data, "Address: low-level static call failed");
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
792      * but performing a static call.
793      *
794      * _Available since v3.3._
795      */
796     function functionStaticCall(
797         address target,
798         bytes memory data,
799         string memory errorMessage
800     ) internal view returns (bytes memory) {
801         require(isContract(target), "Address: static call to non-contract");
802 
803         (bool success, bytes memory returndata) = target.staticcall(data);
804         return verifyCallResult(success, returndata, errorMessage);
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
809      * but performing a delegate call.
810      *
811      * _Available since v3.4._
812      */
813     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
814         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
815     }
816 
817     /**
818      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
819      * but performing a delegate call.
820      *
821      * _Available since v3.4._
822      */
823     function functionDelegateCall(
824         address target,
825         bytes memory data,
826         string memory errorMessage
827     ) internal returns (bytes memory) {
828         require(isContract(target), "Address: delegate call to non-contract");
829 
830         (bool success, bytes memory returndata) = target.delegatecall(data);
831         return verifyCallResult(success, returndata, errorMessage);
832     }
833 
834     /**
835      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
836      * revert reason using the provided one.
837      *
838      * _Available since v4.3._
839      */
840     function verifyCallResult(
841         bool success,
842         bytes memory returndata,
843         string memory errorMessage
844     ) internal pure returns (bytes memory) {
845         if (success) {
846             return returndata;
847         } else {
848             // Look for revert reason and bubble it up if present
849             if (returndata.length > 0) {
850                 // The easiest way to bubble the revert reason is using memory via assembly
851 
852                 assembly {
853                     let returndata_size := mload(returndata)
854                     revert(add(32, returndata), returndata_size)
855                 }
856             } else {
857                 revert(errorMessage);
858             }
859         }
860     }
861 }
862 
863 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
864 
865 
866 
867 pragma solidity ^0.8.0;
868 
869 /**
870  * @title ERC721 token receiver interface
871  * @dev Interface for any contract that wants to support safeTransfers
872  * from ERC721 asset contracts.
873  */
874 interface IERC721Receiver {
875     /**
876      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
877      * by `operator` from `from`, this function is called.
878      *
879      * It must return its Solidity selector to confirm the token transfer.
880      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
881      *
882      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
883      */
884     function onERC721Received(
885         address operator,
886         address from,
887         uint256 tokenId,
888         bytes calldata data
889     ) external returns (bytes4);
890 }
891 
892 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
893 
894 
895 
896 pragma solidity ^0.8.0;
897 
898 /**
899  * @dev Interface of the ERC165 standard, as defined in the
900  * https://eips.ethereum.org/EIPS/eip-165[EIP].
901  *
902  * Implementers can declare support of contract interfaces, which can then be
903  * queried by others ({ERC165Checker}).
904  *
905  * For an implementation, see {ERC165}.
906  */
907 interface IERC165 {
908     /**
909      * @dev Returns true if this contract implements the interface defined by
910      * `interfaceId`. See the corresponding
911      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
912      * to learn more about how these ids are created.
913      *
914      * This function call must use less than 30 000 gas.
915      */
916     function supportsInterface(bytes4 interfaceId) external view returns (bool);
917 }
918 
919 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
920 
921 
922 
923 pragma solidity ^0.8.0;
924 
925 
926 /**
927  * @dev Implementation of the {IERC165} interface.
928  *
929  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
930  * for the additional interface id that will be supported. For example:
931  *
932  * ```solidity
933  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
934  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
935  * }
936  * ```
937  *
938  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
939  */
940 abstract contract ERC165 is IERC165 {
941     /**
942      * @dev See {IERC165-supportsInterface}.
943      */
944     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
945         return interfaceId == type(IERC165).interfaceId;
946     }
947 }
948 
949 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
950 
951 
952 
953 pragma solidity ^0.8.0;
954 
955 
956 /**
957  * @dev Required interface of an ERC721 compliant contract.
958  */
959 interface IERC721 is IERC165 {
960     /**
961      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
962      */
963     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
964 
965     /**
966      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
967      */
968     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
969 
970     /**
971      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
972      */
973     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
974 
975     /**
976      * @dev Returns the number of tokens in ``owner``'s account.
977      */
978     function balanceOf(address owner) external view returns (uint256 balance);
979 
980     /**
981      * @dev Returns the owner of the `tokenId` token.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must exist.
986      */
987     function ownerOf(uint256 tokenId) external view returns (address owner);
988 
989     /**
990      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
991      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
992      *
993      * Requirements:
994      *
995      * - `from` cannot be the zero address.
996      * - `to` cannot be the zero address.
997      * - `tokenId` token must exist and be owned by `from`.
998      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
999      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function safeTransferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) external;
1008 
1009     /**
1010      * @dev Transfers `tokenId` token from `from` to `to`.
1011      *
1012      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1013      *
1014      * Requirements:
1015      *
1016      * - `from` cannot be the zero address.
1017      * - `to` cannot be the zero address.
1018      * - `tokenId` token must be owned by `from`.
1019      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1020      *
1021      * Emits a {Transfer} event.
1022      */
1023     function transferFrom(
1024         address from,
1025         address to,
1026         uint256 tokenId
1027     ) external;
1028 
1029     /**
1030      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1031      * The approval is cleared when the token is transferred.
1032      *
1033      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1034      *
1035      * Requirements:
1036      *
1037      * - The caller must own the token or be an approved operator.
1038      * - `tokenId` must exist.
1039      *
1040      * Emits an {Approval} event.
1041      */
1042     function approve(address to, uint256 tokenId) external;
1043 
1044     /**
1045      * @dev Returns the account approved for `tokenId` token.
1046      *
1047      * Requirements:
1048      *
1049      * - `tokenId` must exist.
1050      */
1051     function getApproved(uint256 tokenId) external view returns (address operator);
1052 
1053     /**
1054      * @dev Approve or remove `operator` as an operator for the caller.
1055      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1056      *
1057      * Requirements:
1058      *
1059      * - The `operator` cannot be the caller.
1060      *
1061      * Emits an {ApprovalForAll} event.
1062      */
1063     function setApprovalForAll(address operator, bool _approved) external;
1064 
1065     /**
1066      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1067      *
1068      * See {setApprovalForAll}
1069      */
1070     function isApprovedForAll(address owner, address operator) external view returns (bool);
1071 
1072     /**
1073      * @dev Safely transfers `tokenId` token from `from` to `to`.
1074      *
1075      * Requirements:
1076      *
1077      * - `from` cannot be the zero address.
1078      * - `to` cannot be the zero address.
1079      * - `tokenId` token must exist and be owned by `from`.
1080      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1081      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function safeTransferFrom(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes calldata data
1090     ) external;
1091 }
1092 
1093 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1094 
1095 
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 
1100 /**
1101  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1102  * @dev See https://eips.ethereum.org/EIPS/eip-721
1103  */
1104 interface IERC721Metadata is IERC721 {
1105     /**
1106      * @dev Returns the token collection name.
1107      */
1108     function name() external view returns (string memory);
1109 
1110     /**
1111      * @dev Returns the token collection symbol.
1112      */
1113     function symbol() external view returns (string memory);
1114 
1115     /**
1116      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1117      */
1118     function tokenURI(uint256 tokenId) external view returns (string memory);
1119 }
1120 
1121 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1122 
1123 
1124 
1125 pragma solidity ^0.8.0;
1126 
1127 
1128 
1129 
1130 
1131 
1132 
1133 
1134 /**
1135  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1136  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1137  * {ERC721Enumerable}.
1138  */
1139 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1140     using Address for address;
1141     using Strings for uint256;
1142 
1143     // Token name
1144     string private _name;
1145 
1146     // Token symbol
1147     string private _symbol;
1148 
1149     // Mapping from token ID to owner address
1150     mapping(uint256 => address) private _owners;
1151 
1152     // Mapping owner address to token count
1153     mapping(address => uint256) private _balances;
1154 
1155     // Mapping from token ID to approved address
1156     mapping(uint256 => address) private _tokenApprovals;
1157 
1158     // Mapping from owner to operator approvals
1159     mapping(address => mapping(address => bool)) private _operatorApprovals;
1160 
1161     /**
1162      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1163      */
1164     constructor(string memory name_, string memory symbol_) {
1165         _name = name_;
1166         _symbol = symbol_;
1167     }
1168 
1169     /**
1170      * @dev See {IERC165-supportsInterface}.
1171      */
1172     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1173         return
1174             interfaceId == type(IERC721).interfaceId ||
1175             interfaceId == type(IERC721Metadata).interfaceId ||
1176             super.supportsInterface(interfaceId);
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-balanceOf}.
1181      */
1182     function balanceOf(address owner) public view virtual override returns (uint256) {
1183         require(owner != address(0), "ERC721: balance query for the zero address");
1184         return _balances[owner];
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-ownerOf}.
1189      */
1190     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1191         address owner = _owners[tokenId];
1192         require(owner != address(0), "ERC721: owner query for nonexistent token");
1193         return owner;
1194     }
1195 
1196     /**
1197      * @dev See {IERC721Metadata-name}.
1198      */
1199     function name() public view virtual override returns (string memory) {
1200         return _name;
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Metadata-symbol}.
1205      */
1206     function symbol() public view virtual override returns (string memory) {
1207         return _symbol;
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Metadata-tokenURI}.
1212      */
1213     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1214         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1215 
1216         string memory baseURI = _baseURI();
1217         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1218     }
1219 
1220     /**
1221      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1222      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1223      * by default, can be overriden in child contracts.
1224      */
1225     function _baseURI() internal view virtual returns (string memory) {
1226         return "";
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-approve}.
1231      */
1232     function approve(address to, uint256 tokenId) public virtual override {
1233         address owner = ERC721.ownerOf(tokenId);
1234         require(to != owner, "ERC721: approval to current owner");
1235 
1236         require(
1237             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1238             "ERC721: approve caller is not owner nor approved for all"
1239         );
1240 
1241         _approve(to, tokenId);
1242     }
1243 
1244     /**
1245      * @dev See {IERC721-getApproved}.
1246      */
1247     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1248         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1249 
1250         return _tokenApprovals[tokenId];
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-setApprovalForAll}.
1255      */
1256     function setApprovalForAll(address operator, bool approved) public virtual override {
1257         require(operator != _msgSender(), "ERC721: approve to caller");
1258 
1259         _operatorApprovals[_msgSender()][operator] = approved;
1260         emit ApprovalForAll(_msgSender(), operator, approved);
1261     }
1262 
1263     /**
1264      * @dev See {IERC721-isApprovedForAll}.
1265      */
1266     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1267         return _operatorApprovals[owner][operator];
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-transferFrom}.
1272      */
1273     function transferFrom(
1274         address from,
1275         address to,
1276         uint256 tokenId
1277     ) public virtual override {
1278         //solhint-disable-next-line max-line-length
1279         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1280 
1281         _transfer(from, to, tokenId);
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-safeTransferFrom}.
1286      */
1287     function safeTransferFrom(
1288         address from,
1289         address to,
1290         uint256 tokenId
1291     ) public virtual override {
1292         safeTransferFrom(from, to, tokenId, "");
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-safeTransferFrom}.
1297      */
1298     function safeTransferFrom(
1299         address from,
1300         address to,
1301         uint256 tokenId,
1302         bytes memory _data
1303     ) public virtual override {
1304         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1305         _safeTransfer(from, to, tokenId, _data);
1306     }
1307 
1308     /**
1309      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1310      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1311      *
1312      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1313      *
1314      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1315      * implement alternative mechanisms to perform token transfer, such as signature-based.
1316      *
1317      * Requirements:
1318      *
1319      * - `from` cannot be the zero address.
1320      * - `to` cannot be the zero address.
1321      * - `tokenId` token must exist and be owned by `from`.
1322      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1323      *
1324      * Emits a {Transfer} event.
1325      */
1326     function _safeTransfer(
1327         address from,
1328         address to,
1329         uint256 tokenId,
1330         bytes memory _data
1331     ) internal virtual {
1332         _transfer(from, to, tokenId);
1333         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1334     }
1335 
1336     /**
1337      * @dev Returns whether `tokenId` exists.
1338      *
1339      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1340      *
1341      * Tokens start existing when they are minted (`_mint`),
1342      * and stop existing when they are burned (`_burn`).
1343      */
1344     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1345         return _owners[tokenId] != address(0);
1346     }
1347 
1348     /**
1349      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1350      *
1351      * Requirements:
1352      *
1353      * - `tokenId` must exist.
1354      */
1355     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1356         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1357         address owner = ERC721.ownerOf(tokenId);
1358         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1359     }
1360 
1361     /**
1362      * @dev Safely mints `tokenId` and transfers it to `to`.
1363      *
1364      * Requirements:
1365      *
1366      * - `tokenId` must not exist.
1367      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1368      *
1369      * Emits a {Transfer} event.
1370      */
1371     function _safeMint(address to, uint256 tokenId) internal virtual {
1372         _safeMint(to, tokenId, "");
1373     }
1374 
1375     /**
1376      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1377      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1378      */
1379     function _safeMint(
1380         address to,
1381         uint256 tokenId,
1382         bytes memory _data
1383     ) internal virtual {
1384         _mint(to, tokenId);
1385         require(
1386             _checkOnERC721Received(address(0), to, tokenId, _data),
1387             "ERC721: transfer to non ERC721Receiver implementer"
1388         );
1389     }
1390 
1391     /**
1392      * @dev Mints `tokenId` and transfers it to `to`.
1393      *
1394      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1395      *
1396      * Requirements:
1397      *
1398      * - `tokenId` must not exist.
1399      * - `to` cannot be the zero address.
1400      *
1401      * Emits a {Transfer} event.
1402      */
1403     function _mint(address to, uint256 tokenId) internal virtual {
1404         require(to != address(0), "ERC721: mint to the zero address");
1405         require(!_exists(tokenId), "ERC721: token already minted");
1406 
1407         _beforeTokenTransfer(address(0), to, tokenId);
1408 
1409         _balances[to] += 1;
1410         _owners[tokenId] = to;
1411 
1412         emit Transfer(address(0), to, tokenId);
1413     }
1414 
1415     /**
1416      * @dev Destroys `tokenId`.
1417      * The approval is cleared when the token is burned.
1418      *
1419      * Requirements:
1420      *
1421      * - `tokenId` must exist.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _burn(uint256 tokenId) internal virtual {
1426         address owner = ERC721.ownerOf(tokenId);
1427 
1428         _beforeTokenTransfer(owner, address(0), tokenId);
1429 
1430         // Clear approvals
1431         _approve(address(0), tokenId);
1432 
1433         _balances[owner] -= 1;
1434         delete _owners[tokenId];
1435 
1436         emit Transfer(owner, address(0), tokenId);
1437     }
1438 
1439     /**
1440      * @dev Transfers `tokenId` from `from` to `to`.
1441      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1442      *
1443      * Requirements:
1444      *
1445      * - `to` cannot be the zero address.
1446      * - `tokenId` token must be owned by `from`.
1447      *
1448      * Emits a {Transfer} event.
1449      */
1450     function _transfer(
1451         address from,
1452         address to,
1453         uint256 tokenId
1454     ) internal virtual {
1455         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1456         require(to != address(0), "ERC721: transfer to the zero address");
1457 
1458         _beforeTokenTransfer(from, to, tokenId);
1459 
1460         // Clear approvals from the previous owner
1461         _approve(address(0), tokenId);
1462 
1463         _balances[from] -= 1;
1464         _balances[to] += 1;
1465         _owners[tokenId] = to;
1466 
1467         emit Transfer(from, to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev Approve `to` to operate on `tokenId`
1472      *
1473      * Emits a {Approval} event.
1474      */
1475     function _approve(address to, uint256 tokenId) internal virtual {
1476         _tokenApprovals[tokenId] = to;
1477         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1478     }
1479 
1480     /**
1481      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1482      * The call is not executed if the target address is not a contract.
1483      *
1484      * @param from address representing the previous owner of the given token ID
1485      * @param to target address that will receive the tokens
1486      * @param tokenId uint256 ID of the token to be transferred
1487      * @param _data bytes optional data to send along with the call
1488      * @return bool whether the call correctly returned the expected magic value
1489      */
1490     function _checkOnERC721Received(
1491         address from,
1492         address to,
1493         uint256 tokenId,
1494         bytes memory _data
1495     ) private returns (bool) {
1496         if (to.isContract()) {
1497             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1498                 return retval == IERC721Receiver.onERC721Received.selector;
1499             } catch (bytes memory reason) {
1500                 if (reason.length == 0) {
1501                     revert("ERC721: transfer to non ERC721Receiver implementer");
1502                 } else {
1503                     assembly {
1504                         revert(add(32, reason), mload(reason))
1505                     }
1506                 }
1507             }
1508         } else {
1509             return true;
1510         }
1511     }
1512 
1513     /**
1514      * @dev Hook that is called before any token transfer. This includes minting
1515      * and burning.
1516      *
1517      * Calling conditions:
1518      *
1519      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1520      * transferred to `to`.
1521      * - When `from` is zero, `tokenId` will be minted for `to`.
1522      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1523      * - `from` and `to` are never both zero.
1524      *
1525      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1526      */
1527     function _beforeTokenTransfer(
1528         address from,
1529         address to,
1530         uint256 tokenId
1531     ) internal virtual {}
1532 }
1533 
1534 // File: DigitalMediaToken.sol
1535 
1536 
1537 
1538 pragma solidity 0.8.9;
1539 
1540 
1541 
1542 
1543 
1544 
1545 
1546 
1547 contract DigitalMediaToken is ERC721, OBOControl, Pausable {
1548     // creator address has to be set during deploy via constructor only.
1549     address public singleCreatorAddress;
1550     address public signerAddress;
1551     bool public enableExternalMinting;
1552     bool public canRoyaltyRegistryChange = true;
1553 
1554     struct DigitalMedia {
1555         uint32 totalSupply; // The total supply of collectibles available
1556         uint32 printIndex; // The current print index
1557         address creator; // The creator of the collectible
1558         uint16 royalty;
1559         bool immutableMedia;
1560         Collaborator.Share[] collaborators;
1561         string metadataPath; // Hash of the media content, with the actual data stored on a secondary
1562         // data store (ideally decentralized)
1563     }
1564 
1565     struct DigitalMediaRelease {
1566         uint32 printEdition; // The unique edition number of this digital media release
1567         uint256 digitalMediaId; // Reference ID to the digital media metadata
1568     }
1569 
1570     ApprovedCreatorRegistryInterface public creatorRegistryStore;
1571     RoyaltyRegistryInterface public royaltyStore;
1572     VaultCoreInterface public vaultStore;
1573 
1574     // Event fired when a new digital media is created. No point in returning printIndex
1575     // since its always zero when created.
1576     event DigitalMediaCreateEvent(
1577         uint256 id,
1578         address creator,
1579         uint32 totalSupply,
1580         uint32 royalty,
1581         bool immutableMedia,
1582         string metadataPath);
1583 
1584     event DigitalMediaReleaseCreateEvent(
1585         uint256 id,
1586         address owner,
1587         uint32 printEdition,
1588         string tokenURI,
1589         uint256 digitalMediaId);
1590 
1591     // Event fired when a creator assigns a new creator address.
1592     event ChangedCreator(
1593         address creator,
1594         address newCreator);
1595 
1596     // Event fired when a digital media is burned
1597     event DigitalMediaBurnEvent(
1598         uint256 id,
1599         address caller);
1600 
1601     // Event fired when burning a token
1602     event DigitalMediaReleaseBurnEvent(
1603         uint256 tokenId,
1604         address owner);
1605 
1606     event NewSignerEvent(
1607         address signer);
1608 
1609     event NewRoyaltyEvent(
1610         uint16 value);
1611 
1612     // ID to Digital Media object
1613     mapping (uint256 => DigitalMedia) public idToDigitalMedia;
1614     // Maps internal ERC721 token ID to digital media release object.
1615     mapping (uint256 => DigitalMediaRelease) public tokenIdToDigitalMediaRelease;
1616     // Maps a creator address to a new creator address.  Useful if a creator
1617     // changes their address or the previous address gets compromised.
1618     mapping (address => address) public changedCreators;
1619 
1620     constructor(string memory _tokenName, string memory _tokenSymbol) ERC721(_tokenName, _tokenSymbol) {}
1621 
1622     // Set the creator registry address upon construction. Immutable.
1623     function setCreatorRegistryStore(address _crsAddress) internal {
1624         ApprovedCreatorRegistryInterface candidateCreatorRegistryStore = ApprovedCreatorRegistryInterface(_crsAddress);
1625         // require(candidateCreatorRegistryStore.getVersion() == 1, "registry store is not version 1");
1626         // Simple check to make sure we are adding the registry contract indeed
1627         // https://fravoll.github.io/solidity-patterns/string_equality_comparison.html
1628         bytes32 contractType = keccak256(abi.encodePacked(candidateCreatorRegistryStore.typeOfContract()));
1629         // keccak256(abi.encodePacked("approvedCreatorRegistry")) = 0x74cb6de1099c3d993f336da7af5394f68038a23980424e1ae5723d4110522be4
1630         // keccak256(abi.encodePacked("approvedCreatorRegistryReadOnly")) = 0x9732b26dfb8751e6f1f71e8f21b28a237cfe383953dce7db3dfa1777abdb2791
1631         require(
1632             contractType == 0x74cb6de1099c3d993f336da7af5394f68038a23980424e1ae5723d4110522be4
1633             || contractType == 0x9732b26dfb8751e6f1f71e8f21b28a237cfe383953dce7db3dfa1777abdb2791,
1634             "not crtrRegistry");
1635         creatorRegistryStore = candidateCreatorRegistryStore;
1636     }
1637 
1638     function setRoyaltyRegistryStore(address _royaltyStore) external whenNotPaused onlyOBOAdmin {
1639         require(canRoyaltyRegistryChange == true, "no");
1640         RoyaltyRegistryInterface candidateRoyaltyStore = RoyaltyRegistryInterface(_royaltyStore);
1641         require(candidateRoyaltyStore.VERSION() == 1, "roylty v!= 1");
1642         bytes32 contractType = keccak256(abi.encodePacked(candidateRoyaltyStore.typeOfContract()));
1643         // keccak256(abi.encodePacked("royaltyRegistry")) = 0xb590ff355bf2d720a7e957392d3b76fd1adda1832940640bf5d5a7c387fed323
1644         require(contractType == 0xb590ff355bf2d720a7e957392d3b76fd1adda1832940640bf5d5a7c387fed323,
1645             "not royalty");
1646         royaltyStore = candidateRoyaltyStore;
1647     }
1648 
1649     function setRoyaltyRegistryForever() external whenNotPaused onlyOwner {
1650         canRoyaltyRegistryChange = false;
1651     }
1652 
1653     function setVaultStore(address _vaultStore) external whenNotPaused onlyOwner {
1654         VaultCoreInterface candidateVaultStore = VaultCoreInterface(_vaultStore);
1655         bytes32 contractType = candidateVaultStore.typeOfContract();
1656         require(contractType == 0x6d707661756c7400000000000000000000000000000000000000000000000000, "invalid mpvault");
1657         vaultStore = candidateVaultStore;
1658     }
1659 
1660     /*
1661      * Set signer address on the token contract. Setting signer means we are opening
1662      * the token contract for external accounts to create tokens. Call this to change
1663      * the signer immediately.
1664      */
1665     function setSignerAddress(address _signerAddress, bool _enableExternalMinting) external whenNotPaused
1666             isApprovedOBO {
1667         require(_signerAddress != address(0), "cant be zero");
1668         signerAddress = _signerAddress;
1669         enableExternalMinting = _enableExternalMinting;
1670         emit NewSignerEvent(signerAddress);
1671     }
1672 
1673      /**
1674      * Validates that the Registered store is initialized.
1675      */
1676     modifier registryInitialized() {
1677         require(address(creatorRegistryStore) != address(0), "registry = 0x0");
1678         _;
1679     }
1680 
1681     /**
1682      * Validates that the Vault store is initialized.
1683      */
1684     modifier vaultInitialized() {
1685         require(address(vaultStore) != address(0), "vault = 0x0");
1686         _;
1687     }
1688 
1689     function _setCollaboratorsOnDigitalMedia(DigitalMedia storage _digitalMedia,
1690             Collaborator.Share[] memory _collaborators) internal {
1691         uint total = 0;
1692         uint totalRoyalty = 0;
1693         for (uint i = 0; i < _collaborators.length; i++) {
1694             require(_collaborators[i].account != address(0x0) ||
1695                 _collaborators[i].account != _digitalMedia.creator, "collab 0x0/creator");
1696             require(_collaborators[i].value != 0 || _collaborators[i].royalty != 0,
1697                 "share/royalty = 0");
1698             _digitalMedia.collaborators.push(_collaborators[i]);
1699             total = total + _collaborators[i].value;
1700             totalRoyalty = totalRoyalty + _collaborators[i].royalty;
1701         }
1702         require(total <= 10000, "total <=10000");
1703         require(totalRoyalty <= 10000, "totalRoyalty <=10000");
1704     }
1705 
1706     /**
1707      * Creates a new digital media object.
1708      * @param  _creator address  the creator of this digital media
1709      * @param  _totalSupply uint32 the total supply a creation could have
1710      * @param  _metadataPath string the path to the ipfs metadata
1711      * @return uint the new digital media id
1712      */
1713     function _createDigitalMedia(
1714             address _creator, uint256 _onchainId, uint32 _totalSupply,
1715             string memory _metadataPath, Collaborator.Share[] memory _collaborators,
1716             uint16 _royalty, bool _immutableMedia)
1717             internal returns (uint) {
1718         // If this is a single creator contract make sure _owner matches single creator
1719         if (singleCreatorAddress != address(0)) {
1720             require(singleCreatorAddress == _creator, "Creator must match single creator address");
1721         }
1722         // Verify this media does not exist already
1723         DigitalMedia storage _digitalMedia = idToDigitalMedia[_onchainId];
1724         require(_digitalMedia.creator == address(0), "media already exists");
1725         // TODO: Dannie check this require throughly.
1726         require((_totalSupply > 0) && address(_creator) != address(0) && _royalty <= 10000, "invalid params");
1727         _digitalMedia.printIndex = 0;
1728         _digitalMedia.totalSupply = _totalSupply;
1729         _digitalMedia.creator = _creator;
1730         _digitalMedia.metadataPath = _metadataPath;
1731         _digitalMedia.immutableMedia = _immutableMedia;
1732         _digitalMedia.royalty = _royalty;
1733         _setCollaboratorsOnDigitalMedia(_digitalMedia, _collaborators);
1734         emit DigitalMediaCreateEvent(
1735             _onchainId, _creator, _totalSupply,
1736             _royalty, _immutableMedia, _metadataPath);
1737         return _onchainId;
1738     }
1739 
1740     /**
1741      * Creates _count number of new digital media releases (i.e a token).
1742      * Bumps up the print index by _count.
1743      * @param  _owner address the owner of the digital media object
1744      * @param  _digitalMediaId uint256 the digital media id
1745      */
1746     function _createDigitalMediaReleases(
1747         address _owner, uint256 _digitalMediaId, uint256[] memory _releaseIds)
1748         internal {
1749         require(_releaseIds.length > 0 && _releaseIds.length < 10000, "0 < count <= 10000");
1750         DigitalMedia storage _digitalMedia = idToDigitalMedia[_digitalMediaId];
1751         require(_digitalMedia.creator != address(0), "media does not exist");
1752         uint32 currentPrintIndex = _digitalMedia.printIndex;
1753         require(_checkApprovedCreator(_digitalMedia.creator, _owner), "Creator not approved");
1754         require(_releaseIds.length + currentPrintIndex <= _digitalMedia.totalSupply, "Total supply exceeded.");
1755 
1756         for (uint32 i=0; i < _releaseIds.length; i++) {
1757             uint256 newDigitalMediaReleaseId = _releaseIds[i];
1758             DigitalMediaRelease storage release = tokenIdToDigitalMediaRelease[newDigitalMediaReleaseId];
1759             require(release.printEdition == 0, "tokenId already used");
1760             uint32 newPrintEdition = currentPrintIndex + 1 + i;
1761             release.printEdition = newPrintEdition;
1762             release.digitalMediaId = _digitalMediaId;
1763             emit DigitalMediaReleaseCreateEvent(
1764                 newDigitalMediaReleaseId,
1765                 _owner,
1766                 newPrintEdition,
1767                 _digitalMedia.metadataPath,
1768                 _digitalMediaId
1769             );
1770 
1771             // This will assign ownership and also emit the Transfer event as per ERC721
1772             _mint(_owner, newDigitalMediaReleaseId);
1773         }
1774         _digitalMedia.printIndex = _digitalMedia.printIndex + uint32(_releaseIds.length);
1775     }
1776 
1777 
1778     /**
1779      * Checks that a given caller is an approved creator and is allowed to mint or burn
1780      * tokens.  If the creator was changed it will check against the updated creator.
1781      * @param  _caller the calling address
1782      * @return bool allowed or not
1783      */
1784     function _checkApprovedCreator(address _creator, address _caller)
1785             internal
1786             view
1787             returns (bool) {
1788         address approvedCreator = changedCreators[_creator];
1789         if (approvedCreator != address(0)) {
1790             return approvedCreator == _caller;
1791         } else {
1792             return _creator == _caller;
1793         }
1794     }
1795 
1796     /**
1797      * Burns a token for a given tokenId and caller.
1798      * @param  _tokenId the id of the token to burn.
1799      * @param  _caller the address of the caller.
1800      */
1801     function _burnToken(uint256 _tokenId, address _caller) internal {
1802         address owner = ownerOf(_tokenId);
1803         require(_isApprovedOrOwner(_caller, _tokenId), "ERC721: burn caller is not owner nor approved");
1804         _burn(_tokenId);
1805         // Dont delete the tokenIdToDMR as we dont want to reissue another release
1806         // with the same id. Leaving the data will prevent reissuing.
1807         // delete tokenIdToDigitalMediaRelease[_tokenId];
1808         emit DigitalMediaReleaseBurnEvent(_tokenId, owner);
1809     }
1810 
1811     /**
1812      * Burns a digital media.  Once this function succeeds, this digital media
1813      * will no longer be able to mint any more tokens.  Existing tokens need to be
1814      * burned individually though.
1815      * @param  _digitalMediaId the id of the digital media to burn
1816      * @param  _caller the address of the caller.
1817      */
1818     function _burnDigitalMedia(uint256 _digitalMediaId, address _caller) internal {
1819         DigitalMedia storage _digitalMedia = idToDigitalMedia[_digitalMediaId];
1820         require(_digitalMedia.creator != address(0), "media does not exist");
1821         require(_checkApprovedCreator(_digitalMedia.creator, _caller) ||
1822                 isApprovedForAll(_digitalMedia.creator, _caller),
1823                 "Failed digital media burn.  Caller not approved.");
1824 
1825         _digitalMedia.printIndex = _digitalMedia.totalSupply;
1826         emit DigitalMediaBurnEvent(_digitalMediaId, _caller);
1827     }
1828 
1829     /**
1830        * @dev Returns an URI for a given token ID
1831        * @dev Throws if the token ID does not exist. May return an empty string.
1832        * @param _tokenId uint256 ID of the token to query
1833        */
1834     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1835         require(_exists(_tokenId));
1836         DigitalMediaRelease storage digitalMediaRelease = tokenIdToDigitalMediaRelease[_tokenId];
1837         uint256 _digitalMediaId = digitalMediaRelease.digitalMediaId;
1838         DigitalMedia storage _digitalMedia = idToDigitalMedia[_digitalMediaId];
1839         string memory prefix = "ipfs://";
1840         return string(abi.encodePacked(prefix, string(_digitalMedia.metadataPath)));
1841     }
1842 
1843     /*
1844      * Look up a royalty payout address if royaltyStore is set otherwise we returns
1845      * the same argument.
1846      */
1847     function _getRoyaltyAddress(address custodial) internal view returns(address) {
1848         return address(royaltyStore) == address(0) ? custodial : royaltyStore.getAddress(custodial);
1849     }
1850 }
1851 // File: DigitalMediaCore.sol
1852 
1853 
1854 
1855 pragma solidity 0.8.9;
1856 
1857 
1858 
1859 
1860 contract DigitalMediaCore is DigitalMediaToken {
1861     using ECDSA for bytes32;
1862     uint8 constant public VERSION = 3;
1863     struct DigitalMediaCreateRequest {
1864         uint256 onchainId; // onchain id for this media
1865         uint32 totalSupply; // The total supply of collectibles available
1866         address creator; // The creator of the collectible
1867         uint16 royalty;
1868         bool immutableMedia;
1869         Collaborator.Share[] collaborators;
1870         string metadataPath; // Hash of the media content
1871         uint256[] releaseIds; // number of releases to mint
1872     }
1873 
1874     struct DigitalMediaUpdateRequest {
1875         uint256 onchainId; // onchain id for this media
1876         uint256 metadataId;
1877         uint32 totalSupply; // The total supply of collectibles available
1878         address creator; // The creator of the collectible
1879         uint16 royalty;
1880         Collaborator.Share[] collaborators;
1881         string metadataPath; // Hash of the media content
1882     }
1883 
1884     struct DigitalMediaReleaseCreateRequest {
1885         uint256 digitalMediaId;
1886         uint256[] releaseIds; // number of releases to mint
1887         address owner;
1888     }
1889 
1890     struct TokenDestinationRequest {
1891         uint256 tokenId;
1892         address destinationAddress;
1893     }
1894 
1895     struct ChainSignatureRequest {
1896         uint256 onchainId;
1897         address owner;
1898     }
1899 
1900     struct PayoutInfo {
1901         address user;
1902         uint256 amount;
1903     }
1904 
1905     event DigitalMediaUpdateEvent(
1906         uint256 id,
1907         uint32 totalSupply,
1908         uint16 royalty,
1909         string metadataPath,
1910         uint256 metadataId);
1911 
1912     event MediasImmutableEvent(
1913         uint256[] mediaIds);
1914     
1915     event MediaImmutableEvent(
1916         uint256 mediaId);
1917 
1918 
1919     constructor(string memory _tokenName, string memory _tokenSymbol,
1920             address _crsAddress) DigitalMediaToken(_tokenName, _tokenSymbol) {
1921         setCreatorRegistryStore(_crsAddress);
1922     }
1923 
1924     /**
1925      * Retrieves a Digital Media object.
1926      */
1927     function getDigitalMedia(uint256 _id)
1928             external
1929             view
1930             returns (DigitalMedia memory) {
1931         DigitalMedia memory _digitalMedia = idToDigitalMedia[_id];
1932         require(_digitalMedia.creator != address(0), "DigitalMedia not found.");
1933         return _digitalMedia;
1934     }
1935 
1936     /**
1937      * Ok I am not proud of this function but sale conract needs to getDigitalMedia
1938      * while I tried to write a interface file DigitalMediaBurnInterfaceV3.sol I could
1939      * not include the DigitalMedia struct in that abstract contract. So I am writing
1940      * another endpoint to return just the bare minimum data required for the sale contract.
1941      */
1942     function getDigitalMediaForSale(uint256 _id) external view returns(
1943             address, bool, uint16) {
1944         DigitalMedia storage _digitalMedia = idToDigitalMedia[_id];
1945         require(_digitalMedia.creator != address(0), "DigitalMedia not found.");
1946         return (_digitalMedia.creator, _digitalMedia.collaborators.length > 0,
1947                 _digitalMedia.royalty);
1948     }
1949 
1950     /**
1951      * Retrieves a Digital Media Release (i.e a token)
1952      */
1953     function getDigitalMediaRelease(uint256 _id)
1954             external
1955             view
1956             returns (DigitalMediaRelease memory) {
1957         require(_exists(_id), "release does not exist");
1958         DigitalMediaRelease storage digitalMediaRelease = tokenIdToDigitalMediaRelease[_id];
1959         return digitalMediaRelease;
1960     }
1961 
1962     /**
1963      * Creates a new digital media object and mints it's first digital media release token.
1964      * The onchainid and creator has to be signed by signerAddress in order to create.
1965      * No creations of any kind are allowed when the contract is paused.
1966      */
1967     function createDigitalMediaAndReleases(
1968             DigitalMediaCreateRequest memory request,
1969             bytes calldata signature)
1970             external
1971             whenNotPaused {
1972         require(request.creator == msg.sender, "msgSender != creator");
1973         ChainSignatureRequest memory signatureRequest = ChainSignatureRequest(request.onchainId, request.creator);
1974         _verifyReleaseRequestSignature(signatureRequest, signature);
1975         uint256 digitalMediaId = _createDigitalMedia(msg.sender, request.onchainId, request.totalSupply,
1976             request.metadataPath, request.collaborators, request.royalty, request.immutableMedia);
1977         _createDigitalMediaReleases(msg.sender, digitalMediaId, request.releaseIds);
1978     }
1979 
1980     /**
1981      * Creates a new digital media release (token) for a given digital media id.
1982      * This request needs to be signed by the authorized signerAccount to prevent
1983      * from user stealing media & release ids on chain and frontrunning.
1984      * No creations of any kind are allowed when the contract is paused.
1985      */
1986     function createDigitalMediaReleases(
1987             DigitalMediaReleaseCreateRequest memory request)
1988             external
1989             whenNotPaused {
1990         // require(request.owner == msg.sender, "owner != msg.sender");
1991         require(signerAddress != address(0), "signer not set");
1992         _createDigitalMediaReleases(msg.sender, request.digitalMediaId, request.releaseIds);
1993     }
1994 
1995     /**
1996      * Creates a new digital media object and mints it's digital media release tokens.
1997      * Called on behalf of the _owner. Pass count to mint `n` number of tokens.
1998      *
1999      * Only approved creators are allowed to create Obo.
2000      *
2001      * No creations of any kind are allowed when the contract is paused.
2002      */
2003     function oboCreateDigitalMediaAndReleases(
2004                 DigitalMediaCreateRequest memory request)
2005             external
2006             whenNotPaused
2007             isApprovedOBO {
2008         uint256 digitalMediaId = _createDigitalMedia(request.creator, request.onchainId, request.totalSupply, request.metadataPath,
2009             request.collaborators, request.royalty, request.immutableMedia);
2010         _createDigitalMediaReleases(request.creator, digitalMediaId, request.releaseIds);
2011     }
2012 
2013     /**
2014      * Create many digital medias in one call. 
2015      */
2016     function oboCreateManyDigitalMedias(
2017             DigitalMediaCreateRequest[] memory requests) external whenNotPaused isApprovedOBO {
2018         for (uint32 i=0; i < requests.length; i++) {
2019             DigitalMediaCreateRequest memory request = requests[i];
2020             _createDigitalMedia(request.creator, request.onchainId, request.totalSupply,
2021                 request.metadataPath, request.collaborators, request.royalty, request.immutableMedia);
2022         }
2023     }
2024 
2025     /**
2026      * Creates multiple digital media releases (tokens) for a given digital media id.
2027      * Called on behalf of the _owner.
2028      *
2029      * Only approved creators are allowed to create Obo.
2030      *
2031      * No creations of any kind are allowed when the contract is paused.
2032      */
2033     function oboCreateDigitalMediaReleases(
2034                 DigitalMediaReleaseCreateRequest memory request)
2035             external
2036             whenNotPaused
2037             isApprovedOBO {
2038         _createDigitalMediaReleases(request.owner, request.digitalMediaId, request.releaseIds);
2039     }
2040 
2041     /*
2042      * Create multiple digital medias and associated releases (tokens). Called on behalf
2043      * of the _owner. Each media should mint atleast 1 token.
2044      * No creations of any kind are allowed when the contract is paused.
2045      */
2046     function oboCreateManyDigitalMediasAndReleases(
2047         DigitalMediaCreateRequest[] memory requests) external whenNotPaused isApprovedOBO {
2048         for (uint32 i=0; i < requests.length; i++) {
2049             DigitalMediaCreateRequest memory request = requests[i];
2050             uint256 digitalMediaId = _createDigitalMedia(request.creator, request.onchainId, request.totalSupply,
2051                 request.metadataPath, request.collaborators, request.royalty, request.immutableMedia);
2052             _createDigitalMediaReleases(request.creator, digitalMediaId, request.releaseIds);
2053         }
2054     }
2055 
2056     /*
2057      * Create multiple releases (tokens) associated with existing medias. Called on behalf
2058      * of the _owner.
2059      * No creations of any kind are allowed when the contract is paused.
2060      */
2061     function oboCreateManyReleases(
2062         DigitalMediaReleaseCreateRequest[] memory requests) external whenNotPaused isApprovedOBO {
2063         for (uint32 i=0; i < requests.length; i++) {
2064             DigitalMediaReleaseCreateRequest memory request = requests[i];
2065             DigitalMedia storage _digitalMedia = idToDigitalMedia[request.digitalMediaId];
2066             require(_digitalMedia.creator != address(0), "DigitalMedia not found.");
2067             _createDigitalMediaReleases(request.owner, request.digitalMediaId, request.releaseIds);
2068         }
2069     }
2070 
2071     /**
2072      * Override the isApprovalForAll to check for a special oboApproval list.  Reason for this
2073      * is that we can can easily remove obo operators if they every become compromised.
2074      */
2075     function isApprovedForAll(address _owner, address _operator) public view override registryInitialized returns (bool) {
2076         if (creatorRegistryStore.isOperatorApprovedForCustodialAccount(_operator, _owner) == true) {
2077             return true;
2078         } else {
2079             return super.isApprovedForAll(_owner, _operator);
2080         }
2081     }
2082 
2083     /**
2084      * Changes the creator for the current sender, in the event we
2085      * need to be able to mint new tokens from an existing digital media
2086      * print production. When changing creator, the old creator will
2087      * no longer be able to mint tokens.
2088      *
2089      * A creator may need to be changed:
2090      * 1. If we want to allow a creator to take control over their token minting (i.e go decentralized)
2091      * 2. If we want to re-issue private keys due to a compromise.  For this reason, we can call this function
2092      * when the contract is paused.
2093      * @param _creator the creator address
2094      * @param _newCreator the new creator address
2095      */
2096     function changeCreator(address _creator, address _newCreator) external {
2097         address approvedCreator = changedCreators[_creator];
2098         require(msg.sender != address(0) && _creator != address(0), "Creator must be valid non 0x0 address.");
2099         require(msg.sender == _creator || msg.sender == approvedCreator, "Unauthorized caller.");
2100         if (approvedCreator == address(0)) {
2101             changedCreators[msg.sender] = _newCreator;
2102         } else {
2103             require(msg.sender == approvedCreator, "Unauthorized caller.");
2104             changedCreators[_creator] = _newCreator;
2105         }
2106         emit ChangedCreator(_creator, _newCreator);
2107     }
2108 
2109     // standard ERC721 burn interface
2110     function burn(uint256 _tokenId) external {
2111         _burnToken(_tokenId, msg.sender);
2112     }
2113 
2114     function burnToken(uint256 _tokenId) external {
2115         _burnToken(_tokenId, msg.sender);
2116     }
2117 
2118     /**
2119      * Ends the production run of a digital media.  Afterwards no more tokens
2120      * will be allowed to be printed for each digital media.  Used when a creator
2121      * makes a mistake and wishes to burn and recreate their digital media.
2122      *
2123      * When a contract is paused we do not allow new tokens to be created,
2124      * so stopping the production of a token doesn't have much purpose.
2125      */
2126     function burnDigitalMedia(uint256 _digitalMediaId) external whenNotPaused {
2127         _burnDigitalMedia(_digitalMediaId, msg.sender);
2128     }
2129 
2130     /*
2131      * Batch transfer multiple tokens from their sources to destination
2132      * Owner / ApproveAll user can call this endpoint.
2133      */
2134     function safeTransferMany(TokenDestinationRequest[] memory requests) external whenNotPaused {
2135         for (uint32 i=0; i < requests.length; i++) {
2136             TokenDestinationRequest memory request = requests[i];
2137             safeTransferFrom(ownerOf(request.tokenId), request.destinationAddress, request.tokenId);
2138         }
2139     }
2140 
2141     function _updateDigitalMedia(DigitalMediaUpdateRequest memory request,
2142             DigitalMedia storage _digitalMedia) internal {
2143         require(_digitalMedia.immutableMedia == false, "immutable");
2144         require(_digitalMedia.printIndex <= request.totalSupply, "< currentPrintIndex");
2145         _digitalMedia.totalSupply = request.totalSupply;
2146         _digitalMedia.metadataPath = request.metadataPath;
2147         _digitalMedia.royalty = request.royalty;
2148         delete _digitalMedia.collaborators;
2149         _setCollaboratorsOnDigitalMedia(_digitalMedia, request.collaborators);
2150         emit DigitalMediaUpdateEvent(request.onchainId,
2151             request.totalSupply, request.royalty, request.metadataPath,
2152             request.metadataId);
2153     }
2154 
2155     function updateMedia(DigitalMediaUpdateRequest memory request) external {
2156         require(request.creator == msg.sender, "msgSender != creator");
2157         DigitalMedia storage _digitalMedia = idToDigitalMedia[request.onchainId];
2158         require(_digitalMedia.creator != address(0) && _digitalMedia.creator == msg.sender,
2159             "DM creator issue");
2160         _updateDigitalMedia(request, _digitalMedia);
2161     }
2162 
2163     /*
2164      * Update existing digitalMedia's metadata, totalSupply, collaborated, royalty
2165      * and immutable attribute. Once a media is immutable you cannot call this function
2166      */
2167     function updateManyMedias(DigitalMediaUpdateRequest[] memory requests)
2168             external whenNotPaused isApprovedOBO vaultInitialized {
2169         for (uint32 i=0; i < requests.length; i++) {
2170             DigitalMediaUpdateRequest memory request = requests[i];
2171             DigitalMedia storage _digitalMedia = idToDigitalMedia[request.onchainId];
2172             // Call creator registry to check if the creator gave approveAll to vault
2173             require(_digitalMedia.creator != address(0) && _digitalMedia.creator == request.creator,
2174                 "DM creator");
2175             require(isApprovedForAll(_digitalMedia.creator, address(vaultStore)) == true, "approveall missing");
2176             _updateDigitalMedia(request, _digitalMedia);
2177         }
2178     }
2179 
2180     function makeMediaImmutable(uint256 mediaId) external {
2181         DigitalMedia storage _digitalMedia = idToDigitalMedia[mediaId];
2182         require(_digitalMedia.creator != address(0) && _digitalMedia.creator == msg.sender,
2183             "DM creator");
2184         require(_digitalMedia.immutableMedia == false, "DM immutable");
2185         _digitalMedia.immutableMedia = true;
2186         emit MediaImmutableEvent(mediaId);
2187     }
2188 
2189     /*
2190      * Once we update media and feel satisfied with the changes, we can render it immutable now.
2191      */
2192     function makeMediasImmutable(uint256[] memory mediaIds) external whenNotPaused isApprovedOBO vaultInitialized {
2193         for (uint32 i=0; i < mediaIds.length; i++) {
2194             uint256 mediaId = mediaIds[i];
2195             DigitalMedia storage _digitalMedia = idToDigitalMedia[mediaId];
2196             require(_digitalMedia.creator != address(0), "DM not found.");
2197             require(_digitalMedia.immutableMedia == false, "DM immutable");
2198             require(isApprovedForAll(_digitalMedia.creator, address(vaultStore)) == true, "approveall missing");
2199             _digitalMedia.immutableMedia = true;
2200         }
2201         emit MediasImmutableEvent(mediaIds);
2202     }
2203 
2204     function _lookUpTokenAndReturnEntries(uint256 _tokenId, uint256 _salePrice,
2205             bool _isRoyalty) internal view returns(PayoutInfo[] memory entries) {
2206         require(_exists(_tokenId), "no token");
2207         DigitalMediaRelease memory digitalMediaRelease = tokenIdToDigitalMediaRelease[_tokenId];
2208         DigitalMedia memory _digitalMedia = idToDigitalMedia[digitalMediaRelease.digitalMediaId];
2209         uint256 size = _digitalMedia.collaborators.length + 1;
2210         entries = new PayoutInfo[](size);
2211         uint totalRoyaltyPercentage = 0;
2212         for (uint256 index = 0; index < _digitalMedia.collaborators.length; index++) {
2213             address payoutAddress = _getRoyaltyAddress(_digitalMedia.collaborators[index].account);
2214             if (_isRoyalty == true) {
2215                 entries[index] = PayoutInfo(payoutAddress,
2216                     _digitalMedia.collaborators[index].royalty * _digitalMedia.royalty * _salePrice / (10000 * 10000));
2217                 totalRoyaltyPercentage = totalRoyaltyPercentage + _digitalMedia.collaborators[index].royalty;
2218             } else {
2219                 entries[index] = PayoutInfo(payoutAddress,
2220                 _digitalMedia.collaborators[index].value * _salePrice / 10000);
2221                 totalRoyaltyPercentage = totalRoyaltyPercentage + _digitalMedia.collaborators[index].value;
2222             }
2223         }
2224         address creatorPayoutAddress = _getRoyaltyAddress(_digitalMedia.creator);
2225         if (_isRoyalty == true) {
2226             entries[size-1]= PayoutInfo(creatorPayoutAddress, _salePrice * (10000 - totalRoyaltyPercentage) * _digitalMedia.royalty / (10000 * 10000));
2227         } else {
2228             entries[size-1]= PayoutInfo(creatorPayoutAddress, _salePrice * (10000 - totalRoyaltyPercentage) / 10000);
2229         }
2230         return entries;
2231     }
2232 
2233     /*
2234      * Return royalty for a given Token. Returns an array of PayoutInfo which consists
2235      * of address to pay to and amount.
2236      * Thank you for posting this gist. Helped me to figure out how to return an array of structs.
2237      * https://gist.github.com/minhth1905/4b6208372fc5e7343b5ce1fb6d42c942
2238      */
2239     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (
2240             PayoutInfo[] memory) {
2241         return _lookUpTokenAndReturnEntries(_tokenId, _salePrice, true);
2242     }
2243 
2244     /*
2245      * Given salePrice break down the amount between the creator and collabarators
2246       * according to their percentages.
2247      */
2248     function saleInfo(uint256 _tokenId, uint256 _totalPayout) external view returns (
2249             PayoutInfo[] memory) {
2250         return _lookUpTokenAndReturnEntries(_tokenId, _totalPayout, false);
2251     }
2252 
2253     function pause() external onlyOwner {
2254         _pause();
2255     }
2256 
2257     function unpause() external onlyOwner {
2258         _unpause();
2259     }
2260 
2261     /*
2262      * helper to verify signature signed by non-custodial creator.
2263      */
2264     function _verifyReleaseRequestSignature(
2265             ChainSignatureRequest memory request,
2266             bytes calldata signature) internal view {
2267         require(enableExternalMinting == true, "ext minting disabled");
2268         bytes32 encodedRequest = keccak256(abi.encode(request));
2269         address addressWhoSigned = encodedRequest.recover(signature);
2270         require(addressWhoSigned == signerAddress, "sig error");
2271     }
2272 }