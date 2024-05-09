1 // SPDX-License-Identifier: MIT
2 /*
3   ____       _                     _____               _     _           
4  |  _ \ _ __(_)_ __  _ __  _   _  |__  /___  _ __ ___ | |__ (_) ___  ___ 
5  | | | | '__| | '_ \| '_ \| | | |   / // _ \| '_ ` _ \| '_ \| |/ _ \/ __|
6  | |_| | |  | | |_) | |_) | |_| |  / /| (_) | | | | | | |_) | |  __/\__ \
7  |____/|_|  |_| .__/| .__/ \__, | /____\___/|_| |_| |_|_.__/|_|\___||___/
8               |_|   |_|    |___/                                         
9 
10                         
11 */
12 // File: @openzeppelin/contracts/utils/Address.sol
13 
14 
15 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
16 
17 pragma solidity ^0.8.1;
18 
19 /**
20  * @dev Collection of functions related to the address type
21  */
22 library Address {
23     /**
24      * @dev Returns true if `account` is a contract.
25      *
26      * [IMPORTANT]
27      * ====
28      * It is unsafe to assume that an address for which this function returns
29      * false is an externally-owned account (EOA) and not a contract.
30      *
31      * Among others, `isContract` will return false for the following
32      * types of addresses:
33      *
34      *  - an externally-owned account
35      *  - a contract in construction
36      *  - an address where a contract will be created
37      *  - an address where a contract lived, but was destroyed
38      * ====
39      *
40      * [IMPORTANT]
41      * ====
42      * You shouldn't rely on `isContract` to protect against flash loan attacks!
43      *
44      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
45      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
46      * constructor.
47      * ====
48      */
49     function isContract(address account) internal view returns (bool) {
50         // This method relies on extcodesize/address.code.length, which returns 0
51         // for contracts in construction, since the code is only stored at the end
52         // of the constructor execution.
53 
54         return account.code.length > 0;
55     }
56 
57     /**
58      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
59      * `recipient`, forwarding all available gas and reverting on errors.
60      *
61      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
62      * of certain opcodes, possibly making contracts go over the 2300 gas limit
63      * imposed by `transfer`, making them unable to receive funds via
64      * `transfer`. {sendValue} removes this limitation.
65      *
66      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
67      *
68      * IMPORTANT: because control is transferred to `recipient`, care must be
69      * taken to not create reentrancy vulnerabilities. Consider using
70      * {ReentrancyGuard} or the
71      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
72      */
73     function sendValue(address payable recipient, uint256 amount) internal {
74         require(address(this).balance >= amount, "Address: insufficient balance");
75 
76         (bool success, ) = recipient.call{value: amount}("");
77         require(success, "Address: unable to send value, recipient may have reverted");
78     }
79 
80     /**
81      * @dev Performs a Solidity function call using a low level `call`. A
82      * plain `call` is an unsafe replacement for a function call: use this
83      * function instead.
84      *
85      * If `target` reverts with a revert reason, it is bubbled up by this
86      * function (like regular Solidity function calls).
87      *
88      * Returns the raw returned data. To convert to the expected return value,
89      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
90      *
91      * Requirements:
92      *
93      * - `target` must be a contract.
94      * - calling `target` with `data` must not revert.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
99         return functionCall(target, data, "Address: low-level call failed");
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
104      * `errorMessage` as a fallback revert reason when `target` reverts.
105      *
106      * _Available since v3.1._
107      */
108     function functionCall(
109         address target,
110         bytes memory data,
111         string memory errorMessage
112     ) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, 0, errorMessage);
114     }
115 
116     /**
117      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
118      * but also transferring `value` wei to `target`.
119      *
120      * Requirements:
121      *
122      * - the calling contract must have an ETH balance of at least `value`.
123      * - the called Solidity function must be `payable`.
124      *
125      * _Available since v3.1._
126      */
127     function functionCallWithValue(
128         address target,
129         bytes memory data,
130         uint256 value
131     ) internal returns (bytes memory) {
132         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
137      * with `errorMessage` as a fallback revert reason when `target` reverts.
138      *
139      * _Available since v3.1._
140      */
141     function functionCallWithValue(
142         address target,
143         bytes memory data,
144         uint256 value,
145         string memory errorMessage
146     ) internal returns (bytes memory) {
147         require(address(this).balance >= value, "Address: insufficient balance for call");
148         require(isContract(target), "Address: call to non-contract");
149 
150         (bool success, bytes memory returndata) = target.call{value: value}(data);
151         return verifyCallResult(success, returndata, errorMessage);
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
161         return functionStaticCall(target, data, "Address: low-level static call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
166      * but performing a static call.
167      *
168      * _Available since v3.3._
169      */
170     function functionStaticCall(
171         address target,
172         bytes memory data,
173         string memory errorMessage
174     ) internal view returns (bytes memory) {
175         require(isContract(target), "Address: static call to non-contract");
176 
177         (bool success, bytes memory returndata) = target.staticcall(data);
178         return verifyCallResult(success, returndata, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but performing a delegate call.
184      *
185      * _Available since v3.4._
186      */
187     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
188         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
193      * but performing a delegate call.
194      *
195      * _Available since v3.4._
196      */
197     function functionDelegateCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         require(isContract(target), "Address: delegate call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.delegatecall(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
210      * revert reason using the provided one.
211      *
212      * _Available since v4.3._
213      */
214     function verifyCallResult(
215         bool success,
216         bytes memory returndata,
217         string memory errorMessage
218     ) internal pure returns (bytes memory) {
219         if (success) {
220             return returndata;
221         } else {
222             // Look for revert reason and bubble it up if present
223             if (returndata.length > 0) {
224                 // The easiest way to bubble the revert reason is using memory via assembly
225                 /// @solidity memory-safe-assembly
226                 assembly {
227                     let returndata_size := mload(returndata)
228                     revert(add(32, returndata), returndata_size)
229                 }
230             } else {
231                 revert(errorMessage);
232             }
233         }
234     }
235 }
236 
237 // File: @openzeppelin/contracts/utils/Strings.sol
238 
239 
240 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
241 
242 pragma solidity ^0.8.0;
243 
244 /**
245  * @dev String operations.
246  */
247 library Strings {
248     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
249     uint8 private constant _ADDRESS_LENGTH = 20;
250 
251     /**
252      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
253      */
254     function toString(uint256 value) internal pure returns (string memory) {
255         // Inspired by OraclizeAPI's implementation - MIT licence
256         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
257 
258         if (value == 0) {
259             return "0";
260         }
261         uint256 temp = value;
262         uint256 digits;
263         while (temp != 0) {
264             digits++;
265             temp /= 10;
266         }
267         bytes memory buffer = new bytes(digits);
268         while (value != 0) {
269             digits -= 1;
270             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
271             value /= 10;
272         }
273         return string(buffer);
274     }
275 
276     /**
277      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
278      */
279     function toHexString(uint256 value) internal pure returns (string memory) {
280         if (value == 0) {
281             return "0x00";
282         }
283         uint256 temp = value;
284         uint256 length = 0;
285         while (temp != 0) {
286             length++;
287             temp >>= 8;
288         }
289         return toHexString(value, length);
290     }
291 
292     /**
293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
294      */
295     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
296         bytes memory buffer = new bytes(2 * length + 2);
297         buffer[0] = "0";
298         buffer[1] = "x";
299         for (uint256 i = 2 * length + 1; i > 1; --i) {
300             buffer[i] = _HEX_SYMBOLS[value & 0xf];
301             value >>= 4;
302         }
303         require(value == 0, "Strings: hex length insufficient");
304         return string(buffer);
305     }
306 
307     /**
308      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
309      */
310     function toHexString(address addr) internal pure returns (string memory) {
311         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
312     }
313 }
314 
315 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
316 
317 
318 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
325  *
326  * These functions can be used to verify that a message was signed by the holder
327  * of the private keys of a given address.
328  */
329 library ECDSA {
330     enum RecoverError {
331         NoError,
332         InvalidSignature,
333         InvalidSignatureLength,
334         InvalidSignatureS,
335         InvalidSignatureV
336     }
337 
338     function _throwError(RecoverError error) private pure {
339         if (error == RecoverError.NoError) {
340             return; // no error: do nothing
341         } else if (error == RecoverError.InvalidSignature) {
342             revert("ECDSA: invalid signature");
343         } else if (error == RecoverError.InvalidSignatureLength) {
344             revert("ECDSA: invalid signature length");
345         } else if (error == RecoverError.InvalidSignatureS) {
346             revert("ECDSA: invalid signature 's' value");
347         } else if (error == RecoverError.InvalidSignatureV) {
348             revert("ECDSA: invalid signature 'v' value");
349         }
350     }
351 
352     /**
353      * @dev Returns the address that signed a hashed message (`hash`) with
354      * `signature` or error string. This address can then be used for verification purposes.
355      *
356      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
357      * this function rejects them by requiring the `s` value to be in the lower
358      * half order, and the `v` value to be either 27 or 28.
359      *
360      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
361      * verification to be secure: it is possible to craft signatures that
362      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
363      * this is by receiving a hash of the original message (which may otherwise
364      * be too long), and then calling {toEthSignedMessageHash} on it.
365      *
366      * Documentation for signature generation:
367      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
368      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
369      *
370      * _Available since v4.3._
371      */
372     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
373         if (signature.length == 65) {
374             bytes32 r;
375             bytes32 s;
376             uint8 v;
377             // ecrecover takes the signature parameters, and the only way to get them
378             // currently is to use assembly.
379             /// @solidity memory-safe-assembly
380             assembly {
381                 r := mload(add(signature, 0x20))
382                 s := mload(add(signature, 0x40))
383                 v := byte(0, mload(add(signature, 0x60)))
384             }
385             return tryRecover(hash, v, r, s);
386         } else {
387             return (address(0), RecoverError.InvalidSignatureLength);
388         }
389     }
390 
391     /**
392      * @dev Returns the address that signed a hashed message (`hash`) with
393      * `signature`. This address can then be used for verification purposes.
394      *
395      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
396      * this function rejects them by requiring the `s` value to be in the lower
397      * half order, and the `v` value to be either 27 or 28.
398      *
399      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
400      * verification to be secure: it is possible to craft signatures that
401      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
402      * this is by receiving a hash of the original message (which may otherwise
403      * be too long), and then calling {toEthSignedMessageHash} on it.
404      */
405     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
406         (address recovered, RecoverError error) = tryRecover(hash, signature);
407         _throwError(error);
408         return recovered;
409     }
410 
411     /**
412      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
413      *
414      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
415      *
416      * _Available since v4.3._
417      */
418     function tryRecover(
419         bytes32 hash,
420         bytes32 r,
421         bytes32 vs
422     ) internal pure returns (address, RecoverError) {
423         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
424         uint8 v = uint8((uint256(vs) >> 255) + 27);
425         return tryRecover(hash, v, r, s);
426     }
427 
428     /**
429      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
430      *
431      * _Available since v4.2._
432      */
433     function recover(
434         bytes32 hash,
435         bytes32 r,
436         bytes32 vs
437     ) internal pure returns (address) {
438         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
439         _throwError(error);
440         return recovered;
441     }
442 
443     /**
444      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
445      * `r` and `s` signature fields separately.
446      *
447      * _Available since v4.3._
448      */
449     function tryRecover(
450         bytes32 hash,
451         uint8 v,
452         bytes32 r,
453         bytes32 s
454     ) internal pure returns (address, RecoverError) {
455         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
456         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
457         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
458         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
459         //
460         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
461         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
462         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
463         // these malleable signatures as well.
464         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
465             return (address(0), RecoverError.InvalidSignatureS);
466         }
467         if (v != 27 && v != 28) {
468             return (address(0), RecoverError.InvalidSignatureV);
469         }
470 
471         // If the signature is valid (and not malleable), return the signer address
472         address signer = ecrecover(hash, v, r, s);
473         if (signer == address(0)) {
474             return (address(0), RecoverError.InvalidSignature);
475         }
476 
477         return (signer, RecoverError.NoError);
478     }
479 
480     /**
481      * @dev Overload of {ECDSA-recover} that receives the `v`,
482      * `r` and `s` signature fields separately.
483      */
484     function recover(
485         bytes32 hash,
486         uint8 v,
487         bytes32 r,
488         bytes32 s
489     ) internal pure returns (address) {
490         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
491         _throwError(error);
492         return recovered;
493     }
494 
495     /**
496      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
497      * produces hash corresponding to the one signed with the
498      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
499      * JSON-RPC method as part of EIP-191.
500      *
501      * See {recover}.
502      */
503     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
504         // 32 is the length in bytes of hash,
505         // enforced by the type signature above
506         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
507     }
508 
509     /**
510      * @dev Returns an Ethereum Signed Message, created from `s`. This
511      * produces hash corresponding to the one signed with the
512      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
513      * JSON-RPC method as part of EIP-191.
514      *
515      * See {recover}.
516      */
517     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
518         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
519     }
520 
521     /**
522      * @dev Returns an Ethereum Signed Typed Data, created from a
523      * `domainSeparator` and a `structHash`. This produces hash corresponding
524      * to the one signed with the
525      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
526      * JSON-RPC method as part of EIP-712.
527      *
528      * See {recover}.
529      */
530     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
531         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
532     }
533 }
534 
535 // File: @openzeppelin/contracts/utils/Context.sol
536 
537 
538 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
539 
540 pragma solidity ^0.8.0;
541 
542 /**
543  * @dev Provides information about the current execution context, including the
544  * sender of the transaction and its data. While these are generally available
545  * via msg.sender and msg.data, they should not be accessed in such a direct
546  * manner, since when dealing with meta-transactions the account sending and
547  * paying for execution may not be the actual sender (as far as an application
548  * is concerned).
549  *
550  * This contract is only required for intermediate, library-like contracts.
551  */
552 abstract contract Context {
553     function _msgSender() internal view virtual returns (address) {
554         return msg.sender;
555     }
556 
557     function _msgData() internal view virtual returns (bytes calldata) {
558         return msg.data;
559     }
560 }
561 
562 // File: @openzeppelin/contracts/access/Ownable.sol
563 
564 
565 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @dev Contract module which provides a basic access control mechanism, where
572  * there is an account (an owner) that can be granted exclusive access to
573  * specific functions.
574  *
575  * By default, the owner account will be the one that deploys the contract. This
576  * can later be changed with {transferOwnership}.
577  *
578  * This module is used through inheritance. It will make available the modifier
579  * `onlyOwner`, which can be applied to your functions to restrict their use to
580  * the owner.
581  */
582 abstract contract Ownable is Context {
583     address private _owner;
584 
585     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
586 
587     /**
588      * @dev Initializes the contract setting the deployer as the initial owner.
589      */
590     constructor() {
591         _transferOwnership(_msgSender());
592     }
593 
594     /**
595      * @dev Throws if called by any account other than the owner.
596      */
597     modifier onlyOwner() {
598         _checkOwner();
599         _;
600     }
601 
602     /**
603      * @dev Returns the address of the current owner.
604      */
605     function owner() public view virtual returns (address) {
606         return _owner;
607     }
608 
609     /**
610      * @dev Throws if the sender is not the owner.
611      */
612     function _checkOwner() internal view virtual {
613         require(owner() == _msgSender(), "Ownable: caller is not the owner");
614     }
615 
616     /**
617      * @dev Leaves the contract without owner. It will not be possible to call
618      * `onlyOwner` functions anymore. Can only be called by the current owner.
619      *
620      * NOTE: Renouncing ownership will leave the contract without an owner,
621      * thereby removing any functionality that is only available to the owner.
622      */
623     function renounceOwnership() public virtual onlyOwner {
624         _transferOwnership(address(0));
625     }
626 
627     /**
628      * @dev Transfers ownership of the contract to a new account (`newOwner`).
629      * Can only be called by the current owner.
630      */
631     function transferOwnership(address newOwner) public virtual onlyOwner {
632         require(newOwner != address(0), "Ownable: new owner is the zero address");
633         _transferOwnership(newOwner);
634     }
635 
636     /**
637      * @dev Transfers ownership of the contract to a new account (`newOwner`).
638      * Internal function without access restriction.
639      */
640     function _transferOwnership(address newOwner) internal virtual {
641         address oldOwner = _owner;
642         _owner = newOwner;
643         emit OwnershipTransferred(oldOwner, newOwner);
644     }
645 }
646 
647 // File: erc721a/contracts/IERC721A.sol
648 
649 
650 // ERC721A Contracts v4.2.2
651 // Creator: Chiru Labs
652 
653 pragma solidity ^0.8.4;
654 
655 /**
656  * @dev Interface of ERC721A.
657  */
658 interface IERC721A {
659     /**
660      * The caller must own the token or be an approved operator.
661      */
662     error ApprovalCallerNotOwnerNorApproved();
663 
664     /**
665      * The token does not exist.
666      */
667     error ApprovalQueryForNonexistentToken();
668 
669     /**
670      * The caller cannot approve to their own address.
671      */
672     error ApproveToCaller();
673 
674     /**
675      * Cannot query the balance for the zero address.
676      */
677     error BalanceQueryForZeroAddress();
678 
679     /**
680      * Cannot mint to the zero address.
681      */
682     error MintToZeroAddress();
683 
684     /**
685      * The quantity of tokens minted must be more than zero.
686      */
687     error MintZeroQuantity();
688 
689     /**
690      * The token does not exist.
691      */
692     error OwnerQueryForNonexistentToken();
693 
694     /**
695      * The caller must own the token or be an approved operator.
696      */
697     error TransferCallerNotOwnerNorApproved();
698 
699     /**
700      * The token must be owned by `from`.
701      */
702     error TransferFromIncorrectOwner();
703 
704     /**
705      * Cannot safely transfer to a contract that does not implement the
706      * ERC721Receiver interface.
707      */
708     error TransferToNonERC721ReceiverImplementer();
709 
710     /**
711      * Cannot transfer to the zero address.
712      */
713     error TransferToZeroAddress();
714 
715     /**
716      * The token does not exist.
717      */
718     error URIQueryForNonexistentToken();
719 
720     /**
721      * The `quantity` minted with ERC2309 exceeds the safety limit.
722      */
723     error MintERC2309QuantityExceedsLimit();
724 
725     /**
726      * The `extraData` cannot be set on an unintialized ownership slot.
727      */
728     error OwnershipNotInitializedForExtraData();
729 
730     // =============================================================
731     //                            STRUCTS
732     // =============================================================
733 
734     struct TokenOwnership {
735         // The address of the owner.
736         address addr;
737         // Stores the start time of ownership with minimal overhead for tokenomics.
738         uint64 startTimestamp;
739         // Whether the token has been burned.
740         bool burned;
741         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
742         uint24 extraData;
743     }
744 
745     // =============================================================
746     //                         TOKEN COUNTERS
747     // =============================================================
748 
749     /**
750      * @dev Returns the total number of tokens in existence.
751      * Burned tokens will reduce the count.
752      * To get the total number of tokens minted, please see {_totalMinted}.
753      */
754     function totalSupply() external view returns (uint256);
755 
756     // =============================================================
757     //                            IERC165
758     // =============================================================
759 
760     /**
761      * @dev Returns true if this contract implements the interface defined by
762      * `interfaceId`. See the corresponding
763      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
764      * to learn more about how these ids are created.
765      *
766      * This function call must use less than 30000 gas.
767      */
768     function supportsInterface(bytes4 interfaceId) external view returns (bool);
769 
770     // =============================================================
771     //                            IERC721
772     // =============================================================
773 
774     /**
775      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
776      */
777     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
778 
779     /**
780      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
781      */
782     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
783 
784     /**
785      * @dev Emitted when `owner` enables or disables
786      * (`approved`) `operator` to manage all of its assets.
787      */
788     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
789 
790     /**
791      * @dev Returns the number of tokens in `owner`'s account.
792      */
793     function balanceOf(address owner) external view returns (uint256 balance);
794 
795     /**
796      * @dev Returns the owner of the `tokenId` token.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must exist.
801      */
802     function ownerOf(uint256 tokenId) external view returns (address owner);
803 
804     /**
805      * @dev Safely transfers `tokenId` token from `from` to `to`,
806      * checking first that contract recipients are aware of the ERC721 protocol
807      * to prevent tokens from being forever locked.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must exist and be owned by `from`.
814      * - If the caller is not `from`, it must be have been allowed to move
815      * this token by either {approve} or {setApprovalForAll}.
816      * - If `to` refers to a smart contract, it must implement
817      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
818      *
819      * Emits a {Transfer} event.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 tokenId,
825         bytes calldata data
826     ) external;
827 
828     /**
829      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
830      */
831     function safeTransferFrom(
832         address from,
833         address to,
834         uint256 tokenId
835     ) external;
836 
837     /**
838      * @dev Transfers `tokenId` from `from` to `to`.
839      *
840      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
841      * whenever possible.
842      *
843      * Requirements:
844      *
845      * - `from` cannot be the zero address.
846      * - `to` cannot be the zero address.
847      * - `tokenId` token must be owned by `from`.
848      * - If the caller is not `from`, it must be approved to move this token
849      * by either {approve} or {setApprovalForAll}.
850      *
851      * Emits a {Transfer} event.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) external;
858 
859     /**
860      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
861      * The approval is cleared when the token is transferred.
862      *
863      * Only a single account can be approved at a time, so approving the
864      * zero address clears previous approvals.
865      *
866      * Requirements:
867      *
868      * - The caller must own the token or be an approved operator.
869      * - `tokenId` must exist.
870      *
871      * Emits an {Approval} event.
872      */
873     function approve(address to, uint256 tokenId) external;
874 
875     /**
876      * @dev Approve or remove `operator` as an operator for the caller.
877      * Operators can call {transferFrom} or {safeTransferFrom}
878      * for any token owned by the caller.
879      *
880      * Requirements:
881      *
882      * - The `operator` cannot be the caller.
883      *
884      * Emits an {ApprovalForAll} event.
885      */
886     function setApprovalForAll(address operator, bool _approved) external;
887 
888     /**
889      * @dev Returns the account approved for `tokenId` token.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must exist.
894      */
895     function getApproved(uint256 tokenId) external view returns (address operator);
896 
897     /**
898      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
899      *
900      * See {setApprovalForAll}.
901      */
902     function isApprovedForAll(address owner, address operator) external view returns (bool);
903 
904     // =============================================================
905     //                        IERC721Metadata
906     // =============================================================
907 
908     /**
909      * @dev Returns the token collection name.
910      */
911     function name() external view returns (string memory);
912 
913     /**
914      * @dev Returns the token collection symbol.
915      */
916     function symbol() external view returns (string memory);
917 
918     /**
919      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
920      */
921     function tokenURI(uint256 tokenId) external view returns (string memory);
922 
923     // =============================================================
924     //                           IERC2309
925     // =============================================================
926 
927     /**
928      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
929      * (inclusive) is transferred from `from` to `to`, as defined in the
930      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
931      *
932      * See {_mintERC2309} for more details.
933      */
934     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
935 }
936 
937 // File: erc721a/contracts/ERC721A.sol
938 
939 
940 // ERC721A Contracts v4.2.2
941 // Creator: Chiru Labs
942 
943 pragma solidity ^0.8.4;
944 
945 
946 /**
947  * @dev Interface of ERC721 token receiver.
948  */
949 interface ERC721A__IERC721Receiver {
950     function onERC721Received(
951         address operator,
952         address from,
953         uint256 tokenId,
954         bytes calldata data
955     ) external returns (bytes4);
956 }
957 
958 /**
959  * @title ERC721A
960  *
961  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
962  * Non-Fungible Token Standard, including the Metadata extension.
963  * Optimized for lower gas during batch mints.
964  *
965  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
966  * starting from `_startTokenId()`.
967  *
968  * Assumptions:
969  *
970  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
971  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
972  */
973 contract ERC721A is IERC721A {
974     // Reference type for token approval.
975     struct TokenApprovalRef {
976         address value;
977     }
978 
979     // =============================================================
980     //                           CONSTANTS
981     // =============================================================
982 
983     // Mask of an entry in packed address data.
984     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
985 
986     // The bit position of `numberMinted` in packed address data.
987     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
988 
989     // The bit position of `numberBurned` in packed address data.
990     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
991 
992     // The bit position of `aux` in packed address data.
993     uint256 private constant _BITPOS_AUX = 192;
994 
995     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
996     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
997 
998     // The bit position of `startTimestamp` in packed ownership.
999     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1000 
1001     // The bit mask of the `burned` bit in packed ownership.
1002     uint256 private constant _BITMASK_BURNED = 1 << 224;
1003 
1004     // The bit position of the `nextInitialized` bit in packed ownership.
1005     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1006 
1007     // The bit mask of the `nextInitialized` bit in packed ownership.
1008     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1009 
1010     // The bit position of `extraData` in packed ownership.
1011     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1012 
1013     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1014     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1015 
1016     // The mask of the lower 160 bits for addresses.
1017     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1018 
1019     // The maximum `quantity` that can be minted with {_mintERC2309}.
1020     // This limit is to prevent overflows on the address data entries.
1021     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1022     // is required to cause an overflow, which is unrealistic.
1023     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1024 
1025     // The `Transfer` event signature is given by:
1026     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1027     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1028         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1029 
1030     // =============================================================
1031     //                            STORAGE
1032     // =============================================================
1033 
1034     // The next token ID to be minted.
1035     uint256 private _currentIndex;
1036 
1037     // The number of tokens burned.
1038     uint256 private _burnCounter;
1039 
1040     // Token name
1041     string private _name;
1042 
1043     // Token symbol
1044     string private _symbol;
1045 
1046     // Mapping from token ID to ownership details
1047     // An empty struct value does not necessarily mean the token is unowned.
1048     // See {_packedOwnershipOf} implementation for details.
1049     //
1050     // Bits Layout:
1051     // - [0..159]   `addr`
1052     // - [160..223] `startTimestamp`
1053     // - [224]      `burned`
1054     // - [225]      `nextInitialized`
1055     // - [232..255] `extraData`
1056     mapping(uint256 => uint256) private _packedOwnerships;
1057 
1058     // Mapping owner address to address data.
1059     //
1060     // Bits Layout:
1061     // - [0..63]    `balance`
1062     // - [64..127]  `numberMinted`
1063     // - [128..191] `numberBurned`
1064     // - [192..255] `aux`
1065     mapping(address => uint256) private _packedAddressData;
1066 
1067     // Mapping from token ID to approved address.
1068     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1069 
1070     // Mapping from owner to operator approvals
1071     mapping(address => mapping(address => bool)) private _operatorApprovals;
1072 
1073     // =============================================================
1074     //                          CONSTRUCTOR
1075     // =============================================================
1076 
1077     constructor(string memory name_, string memory symbol_) {
1078         _name = name_;
1079         _symbol = symbol_;
1080         _currentIndex = _startTokenId();
1081     }
1082 
1083     // =============================================================
1084     //                   TOKEN COUNTING OPERATIONS
1085     // =============================================================
1086 
1087     /**
1088      * @dev Returns the starting token ID.
1089      * To change the starting token ID, please override this function.
1090      */
1091     function _startTokenId() internal view virtual returns (uint256) {
1092         return 0;
1093     }
1094 
1095     /**
1096      * @dev Returns the next token ID to be minted.
1097      */
1098     function _nextTokenId() internal view virtual returns (uint256) {
1099         return _currentIndex;
1100     }
1101 
1102     /**
1103      * @dev Returns the total number of tokens in existence.
1104      * Burned tokens will reduce the count.
1105      * To get the total number of tokens minted, please see {_totalMinted}.
1106      */
1107     function totalSupply() public view virtual override returns (uint256) {
1108         // Counter underflow is impossible as _burnCounter cannot be incremented
1109         // more than `_currentIndex - _startTokenId()` times.
1110         unchecked {
1111             return _currentIndex - _burnCounter - _startTokenId();
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns the total amount of tokens minted in the contract.
1117      */
1118     function _totalMinted() internal view virtual returns (uint256) {
1119         // Counter underflow is impossible as `_currentIndex` does not decrement,
1120         // and it is initialized to `_startTokenId()`.
1121         unchecked {
1122             return _currentIndex - _startTokenId();
1123         }
1124     }
1125 
1126     /**
1127      * @dev Returns the total number of tokens burned.
1128      */
1129     function _totalBurned() internal view virtual returns (uint256) {
1130         return _burnCounter;
1131     }
1132 
1133     // =============================================================
1134     //                    ADDRESS DATA OPERATIONS
1135     // =============================================================
1136 
1137     /**
1138      * @dev Returns the number of tokens in `owner`'s account.
1139      */
1140     function balanceOf(address owner) public view virtual override returns (uint256) {
1141         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1142         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1143     }
1144 
1145     /**
1146      * Returns the number of tokens minted by `owner`.
1147      */
1148     function _numberMinted(address owner) internal view returns (uint256) {
1149         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1150     }
1151 
1152     /**
1153      * Returns the number of tokens burned by or on behalf of `owner`.
1154      */
1155     function _numberBurned(address owner) internal view returns (uint256) {
1156         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1157     }
1158 
1159     /**
1160      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1161      */
1162     function _getAux(address owner) internal view returns (uint64) {
1163         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1164     }
1165 
1166     /**
1167      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1168      * If there are multiple variables, please pack them into a uint64.
1169      */
1170     function _setAux(address owner, uint64 aux) internal virtual {
1171         uint256 packed = _packedAddressData[owner];
1172         uint256 auxCasted;
1173         // Cast `aux` with assembly to avoid redundant masking.
1174         assembly {
1175             auxCasted := aux
1176         }
1177         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1178         _packedAddressData[owner] = packed;
1179     }
1180 
1181     // =============================================================
1182     //                            IERC165
1183     // =============================================================
1184 
1185     /**
1186      * @dev Returns true if this contract implements the interface defined by
1187      * `interfaceId`. See the corresponding
1188      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1189      * to learn more about how these ids are created.
1190      *
1191      * This function call must use less than 30000 gas.
1192      */
1193     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1194         // The interface IDs are constants representing the first 4 bytes
1195         // of the XOR of all function selectors in the interface.
1196         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1197         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1198         return
1199             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1200             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1201             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1202     }
1203 
1204     // =============================================================
1205     //                        IERC721Metadata
1206     // =============================================================
1207 
1208     /**
1209      * @dev Returns the token collection name.
1210      */
1211     function name() public view virtual override returns (string memory) {
1212         return _name;
1213     }
1214 
1215     /**
1216      * @dev Returns the token collection symbol.
1217      */
1218     function symbol() public view virtual override returns (string memory) {
1219         return _symbol;
1220     }
1221 
1222     /**
1223      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1224      */
1225     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1226         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1227 
1228         string memory baseURI = _baseURI();
1229         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1230     }
1231 
1232     /**
1233      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1234      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1235      * by default, it can be overridden in child contracts.
1236      */
1237     function _baseURI() internal view virtual returns (string memory) {
1238         return '';
1239     }
1240 
1241     // =============================================================
1242     //                     OWNERSHIPS OPERATIONS
1243     // =============================================================
1244 
1245     /**
1246      * @dev Returns the owner of the `tokenId` token.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      */
1252     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1253         return address(uint160(_packedOwnershipOf(tokenId)));
1254     }
1255 
1256     /**
1257      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1258      * It gradually moves to O(1) as tokens get transferred around over time.
1259      */
1260     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1261         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1262     }
1263 
1264     /**
1265      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1266      */
1267     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1268         return _unpackedOwnership(_packedOwnerships[index]);
1269     }
1270 
1271     /**
1272      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1273      */
1274     function _initializeOwnershipAt(uint256 index) internal virtual {
1275         if (_packedOwnerships[index] == 0) {
1276             _packedOwnerships[index] = _packedOwnershipOf(index);
1277         }
1278     }
1279 
1280     /**
1281      * Returns the packed ownership data of `tokenId`.
1282      */
1283     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1284         uint256 curr = tokenId;
1285 
1286         unchecked {
1287             if (_startTokenId() <= curr)
1288                 if (curr < _currentIndex) {
1289                     uint256 packed = _packedOwnerships[curr];
1290                     // If not burned.
1291                     if (packed & _BITMASK_BURNED == 0) {
1292                         // Invariant:
1293                         // There will always be an initialized ownership slot
1294                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1295                         // before an unintialized ownership slot
1296                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1297                         // Hence, `curr` will not underflow.
1298                         //
1299                         // We can directly compare the packed value.
1300                         // If the address is zero, packed will be zero.
1301                         while (packed == 0) {
1302                             packed = _packedOwnerships[--curr];
1303                         }
1304                         return packed;
1305                     }
1306                 }
1307         }
1308         revert OwnerQueryForNonexistentToken();
1309     }
1310 
1311     /**
1312      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1313      */
1314     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1315         ownership.addr = address(uint160(packed));
1316         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1317         ownership.burned = packed & _BITMASK_BURNED != 0;
1318         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1319     }
1320 
1321     /**
1322      * @dev Packs ownership data into a single uint256.
1323      */
1324     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1325         assembly {
1326             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1327             owner := and(owner, _BITMASK_ADDRESS)
1328             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1329             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1330         }
1331     }
1332 
1333     /**
1334      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1335      */
1336     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1337         // For branchless setting of the `nextInitialized` flag.
1338         assembly {
1339             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1340             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1341         }
1342     }
1343 
1344     // =============================================================
1345     //                      APPROVAL OPERATIONS
1346     // =============================================================
1347 
1348     /**
1349      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1350      * The approval is cleared when the token is transferred.
1351      *
1352      * Only a single account can be approved at a time, so approving the
1353      * zero address clears previous approvals.
1354      *
1355      * Requirements:
1356      *
1357      * - The caller must own the token or be an approved operator.
1358      * - `tokenId` must exist.
1359      *
1360      * Emits an {Approval} event.
1361      */
1362     function approve(address to, uint256 tokenId) public virtual override {
1363         address owner = ownerOf(tokenId);
1364 
1365         if (_msgSenderERC721A() != owner)
1366             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1367                 revert ApprovalCallerNotOwnerNorApproved();
1368             }
1369 
1370         _tokenApprovals[tokenId].value = to;
1371         emit Approval(owner, to, tokenId);
1372     }
1373 
1374     /**
1375      * @dev Returns the account approved for `tokenId` token.
1376      *
1377      * Requirements:
1378      *
1379      * - `tokenId` must exist.
1380      */
1381     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1382         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1383 
1384         return _tokenApprovals[tokenId].value;
1385     }
1386 
1387     /**
1388      * @dev Approve or remove `operator` as an operator for the caller.
1389      * Operators can call {transferFrom} or {safeTransferFrom}
1390      * for any token owned by the caller.
1391      *
1392      * Requirements:
1393      *
1394      * - The `operator` cannot be the caller.
1395      *
1396      * Emits an {ApprovalForAll} event.
1397      */
1398     function setApprovalForAll(address operator, bool approved) public virtual override {
1399         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1400 
1401         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1402         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1403     }
1404 
1405     /**
1406      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1407      *
1408      * See {setApprovalForAll}.
1409      */
1410     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1411         return _operatorApprovals[owner][operator];
1412     }
1413 
1414     /**
1415      * @dev Returns whether `tokenId` exists.
1416      *
1417      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1418      *
1419      * Tokens start existing when they are minted. See {_mint}.
1420      */
1421     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1422         return
1423             _startTokenId() <= tokenId &&
1424             tokenId < _currentIndex && // If within bounds,
1425             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1426     }
1427 
1428     /**
1429      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1430      */
1431     function _isSenderApprovedOrOwner(
1432         address approvedAddress,
1433         address owner,
1434         address msgSender
1435     ) private pure returns (bool result) {
1436         assembly {
1437             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1438             owner := and(owner, _BITMASK_ADDRESS)
1439             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1440             msgSender := and(msgSender, _BITMASK_ADDRESS)
1441             // `msgSender == owner || msgSender == approvedAddress`.
1442             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1443         }
1444     }
1445 
1446     /**
1447      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1448      */
1449     function _getApprovedSlotAndAddress(uint256 tokenId)
1450         private
1451         view
1452         returns (uint256 approvedAddressSlot, address approvedAddress)
1453     {
1454         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1455         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1456         assembly {
1457             approvedAddressSlot := tokenApproval.slot
1458             approvedAddress := sload(approvedAddressSlot)
1459         }
1460     }
1461 
1462     // =============================================================
1463     //                      TRANSFER OPERATIONS
1464     // =============================================================
1465 
1466     /**
1467      * @dev Transfers `tokenId` from `from` to `to`.
1468      *
1469      * Requirements:
1470      *
1471      * - `from` cannot be the zero address.
1472      * - `to` cannot be the zero address.
1473      * - `tokenId` token must be owned by `from`.
1474      * - If the caller is not `from`, it must be approved to move this token
1475      * by either {approve} or {setApprovalForAll}.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function transferFrom(
1480         address from,
1481         address to,
1482         uint256 tokenId
1483     ) public virtual override {
1484         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1485 
1486         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1487 
1488         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1489 
1490         // The nested ifs save around 20+ gas over a compound boolean condition.
1491         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1492             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1493 
1494         if (to == address(0)) revert TransferToZeroAddress();
1495 
1496         _beforeTokenTransfers(from, to, tokenId, 1);
1497 
1498         // Clear approvals from the previous owner.
1499         assembly {
1500             if approvedAddress {
1501                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1502                 sstore(approvedAddressSlot, 0)
1503             }
1504         }
1505 
1506         // Underflow of the sender's balance is impossible because we check for
1507         // ownership above and the recipient's balance can't realistically overflow.
1508         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1509         unchecked {
1510             // We can directly increment and decrement the balances.
1511             --_packedAddressData[from]; // Updates: `balance -= 1`.
1512             ++_packedAddressData[to]; // Updates: `balance += 1`.
1513 
1514             // Updates:
1515             // - `address` to the next owner.
1516             // - `startTimestamp` to the timestamp of transfering.
1517             // - `burned` to `false`.
1518             // - `nextInitialized` to `true`.
1519             _packedOwnerships[tokenId] = _packOwnershipData(
1520                 to,
1521                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1522             );
1523 
1524             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1525             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1526                 uint256 nextTokenId = tokenId + 1;
1527                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1528                 if (_packedOwnerships[nextTokenId] == 0) {
1529                     // If the next slot is within bounds.
1530                     if (nextTokenId != _currentIndex) {
1531                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1532                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1533                     }
1534                 }
1535             }
1536         }
1537 
1538         emit Transfer(from, to, tokenId);
1539         _afterTokenTransfers(from, to, tokenId, 1);
1540     }
1541 
1542     /**
1543      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1544      */
1545     function safeTransferFrom(
1546         address from,
1547         address to,
1548         uint256 tokenId
1549     ) public virtual override {
1550         safeTransferFrom(from, to, tokenId, '');
1551     }
1552 
1553     /**
1554      * @dev Safely transfers `tokenId` token from `from` to `to`.
1555      *
1556      * Requirements:
1557      *
1558      * - `from` cannot be the zero address.
1559      * - `to` cannot be the zero address.
1560      * - `tokenId` token must exist and be owned by `from`.
1561      * - If the caller is not `from`, it must be approved to move this token
1562      * by either {approve} or {setApprovalForAll}.
1563      * - If `to` refers to a smart contract, it must implement
1564      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1565      *
1566      * Emits a {Transfer} event.
1567      */
1568     function safeTransferFrom(
1569         address from,
1570         address to,
1571         uint256 tokenId,
1572         bytes memory _data
1573     ) public virtual override {
1574         transferFrom(from, to, tokenId);
1575         if (to.code.length != 0)
1576             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1577                 revert TransferToNonERC721ReceiverImplementer();
1578             }
1579     }
1580 
1581     /**
1582      * @dev Hook that is called before a set of serially-ordered token IDs
1583      * are about to be transferred. This includes minting.
1584      * And also called before burning one token.
1585      *
1586      * `startTokenId` - the first token ID to be transferred.
1587      * `quantity` - the amount to be transferred.
1588      *
1589      * Calling conditions:
1590      *
1591      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1592      * transferred to `to`.
1593      * - When `from` is zero, `tokenId` will be minted for `to`.
1594      * - When `to` is zero, `tokenId` will be burned by `from`.
1595      * - `from` and `to` are never both zero.
1596      */
1597     function _beforeTokenTransfers(
1598         address from,
1599         address to,
1600         uint256 startTokenId,
1601         uint256 quantity
1602     ) internal virtual {}
1603 
1604     /**
1605      * @dev Hook that is called after a set of serially-ordered token IDs
1606      * have been transferred. This includes minting.
1607      * And also called after one token has been burned.
1608      *
1609      * `startTokenId` - the first token ID to be transferred.
1610      * `quantity` - the amount to be transferred.
1611      *
1612      * Calling conditions:
1613      *
1614      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1615      * transferred to `to`.
1616      * - When `from` is zero, `tokenId` has been minted for `to`.
1617      * - When `to` is zero, `tokenId` has been burned by `from`.
1618      * - `from` and `to` are never both zero.
1619      */
1620     function _afterTokenTransfers(
1621         address from,
1622         address to,
1623         uint256 startTokenId,
1624         uint256 quantity
1625     ) internal virtual {}
1626 
1627     /**
1628      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1629      *
1630      * `from` - Previous owner of the given token ID.
1631      * `to` - Target address that will receive the token.
1632      * `tokenId` - Token ID to be transferred.
1633      * `_data` - Optional data to send along with the call.
1634      *
1635      * Returns whether the call correctly returned the expected magic value.
1636      */
1637     function _checkContractOnERC721Received(
1638         address from,
1639         address to,
1640         uint256 tokenId,
1641         bytes memory _data
1642     ) private returns (bool) {
1643         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1644             bytes4 retval
1645         ) {
1646             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1647         } catch (bytes memory reason) {
1648             if (reason.length == 0) {
1649                 revert TransferToNonERC721ReceiverImplementer();
1650             } else {
1651                 assembly {
1652                     revert(add(32, reason), mload(reason))
1653                 }
1654             }
1655         }
1656     }
1657 
1658     // =============================================================
1659     //                        MINT OPERATIONS
1660     // =============================================================
1661 
1662     /**
1663      * @dev Mints `quantity` tokens and transfers them to `to`.
1664      *
1665      * Requirements:
1666      *
1667      * - `to` cannot be the zero address.
1668      * - `quantity` must be greater than 0.
1669      *
1670      * Emits a {Transfer} event for each mint.
1671      */
1672     function _mint(address to, uint256 quantity) internal virtual {
1673         uint256 startTokenId = _currentIndex;
1674         if (quantity == 0) revert MintZeroQuantity();
1675 
1676         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1677 
1678         // Overflows are incredibly unrealistic.
1679         // `balance` and `numberMinted` have a maximum limit of 2**64.
1680         // `tokenId` has a maximum limit of 2**256.
1681         unchecked {
1682             // Updates:
1683             // - `balance += quantity`.
1684             // - `numberMinted += quantity`.
1685             //
1686             // We can directly add to the `balance` and `numberMinted`.
1687             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1688 
1689             // Updates:
1690             // - `address` to the owner.
1691             // - `startTimestamp` to the timestamp of minting.
1692             // - `burned` to `false`.
1693             // - `nextInitialized` to `quantity == 1`.
1694             _packedOwnerships[startTokenId] = _packOwnershipData(
1695                 to,
1696                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1697             );
1698 
1699             uint256 toMasked;
1700             uint256 end = startTokenId + quantity;
1701 
1702             // Use assembly to loop and emit the `Transfer` event for gas savings.
1703             assembly {
1704                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1705                 toMasked := and(to, _BITMASK_ADDRESS)
1706                 // Emit the `Transfer` event.
1707                 log4(
1708                     0, // Start of data (0, since no data).
1709                     0, // End of data (0, since no data).
1710                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1711                     0, // `address(0)`.
1712                     toMasked, // `to`.
1713                     startTokenId // `tokenId`.
1714                 )
1715 
1716                 for {
1717                     let tokenId := add(startTokenId, 1)
1718                 } iszero(eq(tokenId, end)) {
1719                     tokenId := add(tokenId, 1)
1720                 } {
1721                     // Emit the `Transfer` event. Similar to above.
1722                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1723                 }
1724             }
1725             if (toMasked == 0) revert MintToZeroAddress();
1726 
1727             _currentIndex = end;
1728         }
1729         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1730     }
1731 
1732     /**
1733      * @dev Mints `quantity` tokens and transfers them to `to`.
1734      *
1735      * This function is intended for efficient minting only during contract creation.
1736      *
1737      * It emits only one {ConsecutiveTransfer} as defined in
1738      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1739      * instead of a sequence of {Transfer} event(s).
1740      *
1741      * Calling this function outside of contract creation WILL make your contract
1742      * non-compliant with the ERC721 standard.
1743      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1744      * {ConsecutiveTransfer} event is only permissible during contract creation.
1745      *
1746      * Requirements:
1747      *
1748      * - `to` cannot be the zero address.
1749      * - `quantity` must be greater than 0.
1750      *
1751      * Emits a {ConsecutiveTransfer} event.
1752      */
1753     function _mintERC2309(address to, uint256 quantity) internal virtual {
1754         uint256 startTokenId = _currentIndex;
1755         if (to == address(0)) revert MintToZeroAddress();
1756         if (quantity == 0) revert MintZeroQuantity();
1757         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1758 
1759         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1760 
1761         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1762         unchecked {
1763             // Updates:
1764             // - `balance += quantity`.
1765             // - `numberMinted += quantity`.
1766             //
1767             // We can directly add to the `balance` and `numberMinted`.
1768             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1769 
1770             // Updates:
1771             // - `address` to the owner.
1772             // - `startTimestamp` to the timestamp of minting.
1773             // - `burned` to `false`.
1774             // - `nextInitialized` to `quantity == 1`.
1775             _packedOwnerships[startTokenId] = _packOwnershipData(
1776                 to,
1777                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1778             );
1779 
1780             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1781 
1782             _currentIndex = startTokenId + quantity;
1783         }
1784         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1785     }
1786 
1787     /**
1788      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1789      *
1790      * Requirements:
1791      *
1792      * - If `to` refers to a smart contract, it must implement
1793      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1794      * - `quantity` must be greater than 0.
1795      *
1796      * See {_mint}.
1797      *
1798      * Emits a {Transfer} event for each mint.
1799      */
1800     function _safeMint(
1801         address to,
1802         uint256 quantity,
1803         bytes memory _data
1804     ) internal virtual {
1805         _mint(to, quantity);
1806 
1807         unchecked {
1808             if (to.code.length != 0) {
1809                 uint256 end = _currentIndex;
1810                 uint256 index = end - quantity;
1811                 do {
1812                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1813                         revert TransferToNonERC721ReceiverImplementer();
1814                     }
1815                 } while (index < end);
1816                 // Reentrancy protection.
1817                 if (_currentIndex != end) revert();
1818             }
1819         }
1820     }
1821 
1822     /**
1823      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1824      */
1825     function _safeMint(address to, uint256 quantity) internal virtual {
1826         _safeMint(to, quantity, '');
1827     }
1828 
1829     // =============================================================
1830     //                        BURN OPERATIONS
1831     // =============================================================
1832 
1833     /**
1834      * @dev Equivalent to `_burn(tokenId, false)`.
1835      */
1836     function _burn(uint256 tokenId) internal virtual {
1837         _burn(tokenId, false);
1838     }
1839 
1840     /**
1841      * @dev Destroys `tokenId`.
1842      * The approval is cleared when the token is burned.
1843      *
1844      * Requirements:
1845      *
1846      * - `tokenId` must exist.
1847      *
1848      * Emits a {Transfer} event.
1849      */
1850     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1851         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1852 
1853         address from = address(uint160(prevOwnershipPacked));
1854 
1855         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1856 
1857         if (approvalCheck) {
1858             // The nested ifs save around 20+ gas over a compound boolean condition.
1859             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1860                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1861         }
1862 
1863         _beforeTokenTransfers(from, address(0), tokenId, 1);
1864 
1865         // Clear approvals from the previous owner.
1866         assembly {
1867             if approvedAddress {
1868                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1869                 sstore(approvedAddressSlot, 0)
1870             }
1871         }
1872 
1873         // Underflow of the sender's balance is impossible because we check for
1874         // ownership above and the recipient's balance can't realistically overflow.
1875         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1876         unchecked {
1877             // Updates:
1878             // - `balance -= 1`.
1879             // - `numberBurned += 1`.
1880             //
1881             // We can directly decrement the balance, and increment the number burned.
1882             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1883             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1884 
1885             // Updates:
1886             // - `address` to the last owner.
1887             // - `startTimestamp` to the timestamp of burning.
1888             // - `burned` to `true`.
1889             // - `nextInitialized` to `true`.
1890             _packedOwnerships[tokenId] = _packOwnershipData(
1891                 from,
1892                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1893             );
1894 
1895             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1896             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1897                 uint256 nextTokenId = tokenId + 1;
1898                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1899                 if (_packedOwnerships[nextTokenId] == 0) {
1900                     // If the next slot is within bounds.
1901                     if (nextTokenId != _currentIndex) {
1902                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1903                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1904                     }
1905                 }
1906             }
1907         }
1908 
1909         emit Transfer(from, address(0), tokenId);
1910         _afterTokenTransfers(from, address(0), tokenId, 1);
1911 
1912         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1913         unchecked {
1914             _burnCounter++;
1915         }
1916     }
1917 
1918     // =============================================================
1919     //                     EXTRA DATA OPERATIONS
1920     // =============================================================
1921 
1922     /**
1923      * @dev Directly sets the extra data for the ownership data `index`.
1924      */
1925     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1926         uint256 packed = _packedOwnerships[index];
1927         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1928         uint256 extraDataCasted;
1929         // Cast `extraData` with assembly to avoid redundant masking.
1930         assembly {
1931             extraDataCasted := extraData
1932         }
1933         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1934         _packedOwnerships[index] = packed;
1935     }
1936 
1937     /**
1938      * @dev Called during each token transfer to set the 24bit `extraData` field.
1939      * Intended to be overridden by the cosumer contract.
1940      *
1941      * `previousExtraData` - the value of `extraData` before transfer.
1942      *
1943      * Calling conditions:
1944      *
1945      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1946      * transferred to `to`.
1947      * - When `from` is zero, `tokenId` will be minted for `to`.
1948      * - When `to` is zero, `tokenId` will be burned by `from`.
1949      * - `from` and `to` are never both zero.
1950      */
1951     function _extraData(
1952         address from,
1953         address to,
1954         uint24 previousExtraData
1955     ) internal view virtual returns (uint24) {}
1956 
1957     /**
1958      * @dev Returns the next extra data for the packed ownership data.
1959      * The returned result is shifted into position.
1960      */
1961     function _nextExtraData(
1962         address from,
1963         address to,
1964         uint256 prevOwnershipPacked
1965     ) private view returns (uint256) {
1966         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1967         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1968     }
1969 
1970     // =============================================================
1971     //                       OTHER OPERATIONS
1972     // =============================================================
1973 
1974     /**
1975      * @dev Returns the message sender (defaults to `msg.sender`).
1976      *
1977      * If you are writing GSN compatible contracts, you need to override this function.
1978      */
1979     function _msgSenderERC721A() internal view virtual returns (address) {
1980         return msg.sender;
1981     }
1982 
1983     /**
1984      * @dev Converts a uint256 to its ASCII string decimal representation.
1985      */
1986     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1987         assembly {
1988             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1989             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
1990             // We will need 1 32-byte word to store the length,
1991             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
1992             str := add(mload(0x40), 0x80)
1993             // Update the free memory pointer to allocate.
1994             mstore(0x40, str)
1995 
1996             // Cache the end of the memory to calculate the length later.
1997             let end := str
1998 
1999             // We write the string from rightmost digit to leftmost digit.
2000             // The following is essentially a do-while loop that also handles the zero case.
2001             // prettier-ignore
2002             for { let temp := value } 1 {} {
2003                 str := sub(str, 1)
2004                 // Write the character to the pointer.
2005                 // The ASCII index of the '0' character is 48.
2006                 mstore8(str, add(48, mod(temp, 10)))
2007                 // Keep dividing `temp` until zero.
2008                 temp := div(temp, 10)
2009                 // prettier-ignore
2010                 if iszero(temp) { break }
2011             }
2012 
2013             let length := sub(end, str)
2014             // Move the pointer 32 bytes leftwards to make room for the length.
2015             str := sub(str, 0x20)
2016             // Store the length.
2017             mstore(str, length)
2018         }
2019     }
2020 }
2021 
2022 // File: contract.sol
2023 
2024 
2025 pragma solidity ^0.8.7;
2026 
2027 
2028 
2029 
2030 
2031 
2032 contract DrippyZombies is ERC721A, Ownable {
2033     using Strings for uint256;
2034     using ECDSA for bytes32;
2035 
2036     string private baseURI =
2037         "https://gateway.pinata.cloud/ipfs//";
2038     string public privateSigWord = "DRIPPY_PRIVATE";
2039     uint256 public maxSaleSupply = 3800;
2040     uint256 public maxTeamSupply = 200;
2041     uint256 public privatePrice = 0.029 ether;
2042     uint256 public publicPrice = 0.05 ether;
2043     uint256 public maxMintsPerTx = 4;
2044     uint256 public maxPerWallet = 3;
2045     uint256 public mintedCounter;
2046     uint256 public teamMintedCounter;
2047     address public privateSigner = 0x0A5f0929bD06d3034dF044b9C94E207E6E9e9bA1;
2048     bool public publicLive;
2049     bool public privateLive;
2050     uint256 private devAmountPaid;
2051     mapping(address => uint256) public privateMinters;
2052 
2053     constructor() ERC721A("Drippy Zombies", "DZs") {}
2054 
2055     function _startTokenId()
2056         internal
2057         view
2058         virtual
2059         override(ERC721A)
2060         returns (uint256)
2061     {
2062         return 1;
2063     }
2064 
2065     modifier notContract() {
2066         require(
2067             (!_isContract(msg.sender)) && (msg.sender == tx.origin),
2068             "contract not allowed"
2069         );
2070         _;
2071     }
2072 
2073     function _isContract(address addr) internal view returns (bool) {
2074         uint256 size;
2075         assembly {
2076             size := extcodesize(addr)
2077         }
2078         return size > 0;
2079     }
2080 
2081     function matchAddresSigner(bytes memory signature)
2082         private
2083         view
2084         returns (bool)
2085     {
2086         bytes32 hash = keccak256(
2087             abi.encodePacked(
2088                 "\x19Ethereum Signed Message:\n32",
2089                 keccak256(abi.encodePacked(msg.sender, privateSigWord))
2090             )
2091         );
2092         return privateSigner == hash.recover(signature);
2093     }
2094 
2095     function mint(uint256 tokenQuantity) external payable notContract {
2096         require(publicLive, "MINT_CLOSED");
2097         require(
2098             mintedCounter + tokenQuantity <= maxSaleSupply,
2099             "EXCEED_SALE_SUPPLY"
2100         );
2101         require(tokenQuantity <= maxMintsPerTx, "EXCEED_PER_TX");
2102         require(publicPrice * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2103 
2104         mintedCounter += tokenQuantity;
2105         _mint(msg.sender, tokenQuantity);
2106     }
2107 
2108     function privateMint(uint256 tokenQuantity, bytes memory signature)
2109         external
2110         payable
2111         notContract
2112     {
2113         require(privateLive, "MINT_CLOSED");
2114         require(
2115             mintedCounter + tokenQuantity <= maxSaleSupply,
2116             "EXCEED_SALE_SUPPLY"
2117         );
2118         require(matchAddresSigner(signature), "INVALID_SIGNATURE");
2119         require(
2120             privateMinters[msg.sender] + tokenQuantity <= maxPerWallet,
2121             "EXCEED_PER_WALLET"
2122         );
2123         require(privatePrice * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2124 
2125         mintedCounter += tokenQuantity;
2126         privateMinters[msg.sender] = privateMinters[msg.sender] + tokenQuantity;
2127         _mint(msg.sender, tokenQuantity);
2128     }
2129 
2130     function tokenURI(uint256 tokenId)
2131         public
2132         view
2133         override(ERC721A)
2134         returns (string memory)
2135     {
2136         require(_exists(tokenId), "Cannot query non-existent token");
2137         return string(abi.encodePacked(baseURI, tokenId.toString()));
2138     }
2139 
2140     function _baseURI() internal view virtual override returns (string memory) {
2141         return baseURI;
2142     }
2143 
2144     function gift(address[] calldata receivers) external onlyOwner {
2145         require(
2146             teamMintedCounter + receivers.length <= maxTeamSupply,
2147             "EXCEED_TEAM_SUPPLY"
2148         );
2149 
2150         teamMintedCounter += receivers.length;
2151         for (uint256 i = 0; i < receivers.length; i++) {
2152             _mint(receivers[i], 1);
2153         }
2154     }
2155 
2156     function founderMint(uint256 tokenQuantity) external onlyOwner {
2157         require(
2158             teamMintedCounter + tokenQuantity <= maxTeamSupply,
2159             "EXCEED_TEAM_SUPPLY"
2160         );
2161 
2162         teamMintedCounter += tokenQuantity;
2163         _mint(msg.sender, tokenQuantity);
2164     }
2165 
2166     function togglePublicStatus() external onlyOwner {
2167         publicLive = !publicLive;
2168     }
2169 
2170     function togglePrivateStatus() external onlyOwner {
2171         privateLive = !privateLive;
2172     }
2173 
2174     function setPublicPrice(uint256 newPrice) external onlyOwner {
2175         publicPrice = newPrice;
2176     }
2177 
2178     function setPrivatePrice(uint256 newPrice) external onlyOwner {
2179         privatePrice = newPrice;
2180     }
2181 
2182     function setMax(uint256 newCount) external onlyOwner {
2183         maxSaleSupply = newCount;
2184     }
2185 
2186     function setTeamMax(uint256 newCount) external onlyOwner {
2187         maxTeamSupply = newCount;
2188     }
2189 
2190     function setMaxPerTx(uint256 newCount) external onlyOwner {
2191         maxMintsPerTx = newCount;
2192     }
2193 
2194     function setMaxPerWallet(uint256 newCount) external onlyOwner {
2195         maxPerWallet = newCount;
2196     }
2197 
2198     function setSigner(address newAddress) external onlyOwner {
2199         privateSigner = newAddress;
2200     }
2201 
2202     function setBaseURI(string calldata newBaseURI) external onlyOwner {
2203         baseURI = newBaseURI;
2204     }
2205 
2206     function withdraw() external onlyOwner {
2207         uint256 currentBalance = address(this).balance;
2208 
2209         if (devAmountPaid + currentBalance <= 2.35 ether) {
2210             devAmountPaid += address(this).balance;
2211             Address.sendValue(
2212                 payable(0x0000F92fA20f4cE4E17f8f3a65D566EA2e2cEbcD),
2213                 address(this).balance
2214             );
2215         } else {
2216             uint256 amountToBePaid = 2.35 ether - devAmountPaid;
2217             devAmountPaid = 2.35 ether;
2218             Address.sendValue(
2219                 payable(0x0000F92fA20f4cE4E17f8f3a65D566EA2e2cEbcD),
2220                 amountToBePaid
2221             );
2222             Address.sendValue(payable(msg.sender), address(this).balance);
2223         }
2224     }
2225 
2226     receive() external payable {}
2227 }