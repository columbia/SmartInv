1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 
79 /**
80  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
81  *
82  * These functions can be used to verify that a message was signed by the holder
83  * of the private keys of a given address.
84  */
85 library ECDSA {
86     enum RecoverError {
87         NoError,
88         InvalidSignature,
89         InvalidSignatureLength,
90         InvalidSignatureS,
91         InvalidSignatureV
92     }
93 
94     function _throwError(RecoverError error) private pure {
95         if (error == RecoverError.NoError) {
96             return; // no error: do nothing
97         } else if (error == RecoverError.InvalidSignature) {
98             revert("ECDSA: invalid signature");
99         } else if (error == RecoverError.InvalidSignatureLength) {
100             revert("ECDSA: invalid signature length");
101         } else if (error == RecoverError.InvalidSignatureS) {
102             revert("ECDSA: invalid signature 's' value");
103         } else if (error == RecoverError.InvalidSignatureV) {
104             revert("ECDSA: invalid signature 'v' value");
105         }
106     }
107 
108     /**
109      * @dev Returns the address that signed a hashed message (`hash`) with
110      * `signature` or error string. This address can then be used for verification purposes.
111      *
112      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
113      * this function rejects them by requiring the `s` value to be in the lower
114      * half order, and the `v` value to be either 27 or 28.
115      *
116      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
117      * verification to be secure: it is possible to craft signatures that
118      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
119      * this is by receiving a hash of the original message (which may otherwise
120      * be too long), and then calling {toEthSignedMessageHash} on it.
121      *
122      * Documentation for signature generation:
123      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
124      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
125      *
126      * _Available since v4.3._
127      */
128     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
129         // Check the signature length
130         // - case 65: r,s,v signature (standard)
131         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
132         if (signature.length == 65) {
133             bytes32 r;
134             bytes32 s;
135             uint8 v;
136             // ecrecover takes the signature parameters, and the only way to get them
137             // currently is to use assembly.
138             assembly {
139                 r := mload(add(signature, 0x20))
140                 s := mload(add(signature, 0x40))
141                 v := byte(0, mload(add(signature, 0x60)))
142             }
143             return tryRecover(hash, v, r, s);
144         } else if (signature.length == 64) {
145             bytes32 r;
146             bytes32 vs;
147             // ecrecover takes the signature parameters, and the only way to get them
148             // currently is to use assembly.
149             assembly {
150                 r := mload(add(signature, 0x20))
151                 vs := mload(add(signature, 0x40))
152             }
153             return tryRecover(hash, r, vs);
154         } else {
155             return (address(0), RecoverError.InvalidSignatureLength);
156         }
157     }
158 
159     /**
160      * @dev Returns the address that signed a hashed message (`hash`) with
161      * `signature`. This address can then be used for verification purposes.
162      *
163      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
164      * this function rejects them by requiring the `s` value to be in the lower
165      * half order, and the `v` value to be either 27 or 28.
166      *
167      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
168      * verification to be secure: it is possible to craft signatures that
169      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
170      * this is by receiving a hash of the original message (which may otherwise
171      * be too long), and then calling {toEthSignedMessageHash} on it.
172      */
173     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
174         (address recovered, RecoverError error) = tryRecover(hash, signature);
175         _throwError(error);
176         return recovered;
177     }
178 
179     /**
180      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
181      *
182      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
183      *
184      * _Available since v4.3._
185      */
186     function tryRecover(
187         bytes32 hash,
188         bytes32 r,
189         bytes32 vs
190     ) internal pure returns (address, RecoverError) {
191         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
192         uint8 v = uint8((uint256(vs) >> 255) + 27);
193         return tryRecover(hash, v, r, s);
194     }
195 
196     /**
197      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
198      *
199      * _Available since v4.2._
200      */
201     function recover(
202         bytes32 hash,
203         bytes32 r,
204         bytes32 vs
205     ) internal pure returns (address) {
206         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
207         _throwError(error);
208         return recovered;
209     }
210 
211     /**
212      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
213      * `r` and `s` signature fields separately.
214      *
215      * _Available since v4.3._
216      */
217     function tryRecover(
218         bytes32 hash,
219         uint8 v,
220         bytes32 r,
221         bytes32 s
222     ) internal pure returns (address, RecoverError) {
223         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
224         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
225         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
226         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
227         //
228         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
229         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
230         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
231         // these malleable signatures as well.
232         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
233             return (address(0), RecoverError.InvalidSignatureS);
234         }
235         if (v != 27 && v != 28) {
236             return (address(0), RecoverError.InvalidSignatureV);
237         }
238 
239         // If the signature is valid (and not malleable), return the signer address
240         address signer = ecrecover(hash, v, r, s);
241         if (signer == address(0)) {
242             return (address(0), RecoverError.InvalidSignature);
243         }
244 
245         return (signer, RecoverError.NoError);
246     }
247 
248     /**
249      * @dev Overload of {ECDSA-recover} that receives the `v`,
250      * `r` and `s` signature fields separately.
251      */
252     function recover(
253         bytes32 hash,
254         uint8 v,
255         bytes32 r,
256         bytes32 s
257     ) internal pure returns (address) {
258         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
259         _throwError(error);
260         return recovered;
261     }
262 
263     /**
264      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
265      * produces hash corresponding to the one signed with the
266      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
267      * JSON-RPC method as part of EIP-191.
268      *
269      * See {recover}.
270      */
271     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
272         // 32 is the length in bytes of hash,
273         // enforced by the type signature above
274         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
275     }
276 
277     /**
278      * @dev Returns an Ethereum Signed Message, created from `s`. This
279      * produces hash corresponding to the one signed with the
280      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
281      * JSON-RPC method as part of EIP-191.
282      *
283      * See {recover}.
284      */
285     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
286         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
287     }
288 
289     /**
290      * @dev Returns an Ethereum Signed Typed Data, created from a
291      * `domainSeparator` and a `structHash`. This produces hash corresponding
292      * to the one signed with the
293      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
294      * JSON-RPC method as part of EIP-712.
295      *
296      * See {recover}.
297      */
298     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
299         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/Context.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Provides information about the current execution context, including the
312  * sender of the transaction and its data. While these are generally available
313  * via msg.sender and msg.data, they should not be accessed in such a direct
314  * manner, since when dealing with meta-transactions the account sending and
315  * paying for execution may not be the actual sender (as far as an application
316  * is concerned).
317  *
318  * This contract is only required for intermediate, library-like contracts.
319  */
320 abstract contract Context {
321     function _msgSender() internal view virtual returns (address) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view virtual returns (bytes calldata) {
326         return msg.data;
327     }
328 }
329 
330 // File: @openzeppelin/contracts/access/Ownable.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Contract module which provides a basic access control mechanism, where
340  * there is an account (an owner) that can be granted exclusive access to
341  * specific functions.
342  *
343  * By default, the owner account will be the one that deploys the contract. This
344  * can later be changed with {transferOwnership}.
345  *
346  * This module is used through inheritance. It will make available the modifier
347  * `onlyOwner`, which can be applied to your functions to restrict their use to
348  * the owner.
349  */
350 abstract contract Ownable is Context {
351     address private _owner;
352 
353     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
354 
355     /**
356      * @dev Initializes the contract setting the deployer as the initial owner.
357      */
358     constructor() {
359         _transferOwnership(_msgSender());
360     }
361 
362     /**
363      * @dev Returns the address of the current owner.
364      */
365     function owner() public view virtual returns (address) {
366         return _owner;
367     }
368 
369     /**
370      * @dev Throws if called by any account other than the owner.
371      */
372     modifier onlyOwner() {
373         require(owner() == _msgSender(), "Ownable: caller is not the owner");
374         _;
375     }
376 
377     /**
378      * @dev Leaves the contract without owner. It will not be possible to call
379      * `onlyOwner` functions anymore. Can only be called by the current owner.
380      *
381      * NOTE: Renouncing ownership will leave the contract without an owner,
382      * thereby removing any functionality that is only available to the owner.
383      */
384     function renounceOwnership() public virtual onlyOwner {
385         _transferOwnership(address(0));
386     }
387 
388     /**
389      * @dev Transfers ownership of the contract to a new account (`newOwner`).
390      * Can only be called by the current owner.
391      */
392     function transferOwnership(address newOwner) public virtual onlyOwner {
393         require(newOwner != address(0), "Ownable: new owner is the zero address");
394         _transferOwnership(newOwner);
395     }
396 
397     /**
398      * @dev Transfers ownership of the contract to a new account (`newOwner`).
399      * Internal function without access restriction.
400      */
401     function _transferOwnership(address newOwner) internal virtual {
402         address oldOwner = _owner;
403         _owner = newOwner;
404         emit OwnershipTransferred(oldOwner, newOwner);
405     }
406 }
407 
408 // File: @openzeppelin/contracts/utils/Address.sol
409 
410 
411 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
412 
413 pragma solidity ^0.8.1;
414 
415 /**
416  * @dev Collection of functions related to the address type
417  */
418 library Address {
419     /**
420      * @dev Returns true if `account` is a contract.
421      *
422      * [IMPORTANT]
423      * ====
424      * It is unsafe to assume that an address for which this function returns
425      * false is an externally-owned account (EOA) and not a contract.
426      *
427      * Among others, `isContract` will return false for the following
428      * types of addresses:
429      *
430      *  - an externally-owned account
431      *  - a contract in construction
432      *  - an address where a contract will be created
433      *  - an address where a contract lived, but was destroyed
434      * ====
435      *
436      * [IMPORTANT]
437      * ====
438      * You shouldn't rely on `isContract` to protect against flash loan attacks!
439      *
440      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
441      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
442      * constructor.
443      * ====
444      */
445     function isContract(address account) internal view returns (bool) {
446         // This method relies on extcodesize/address.code.length, which returns 0
447         // for contracts in construction, since the code is only stored at the end
448         // of the constructor execution.
449 
450         return account.code.length > 0;
451     }
452 
453     /**
454      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
455      * `recipient`, forwarding all available gas and reverting on errors.
456      *
457      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
458      * of certain opcodes, possibly making contracts go over the 2300 gas limit
459      * imposed by `transfer`, making them unable to receive funds via
460      * `transfer`. {sendValue} removes this limitation.
461      *
462      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
463      *
464      * IMPORTANT: because control is transferred to `recipient`, care must be
465      * taken to not create reentrancy vulnerabilities. Consider using
466      * {ReentrancyGuard} or the
467      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
468      */
469     function sendValue(address payable recipient, uint256 amount) internal {
470         require(address(this).balance >= amount, "Address: insufficient balance");
471 
472         (bool success, ) = recipient.call{value: amount}("");
473         require(success, "Address: unable to send value, recipient may have reverted");
474     }
475 
476     /**
477      * @dev Performs a Solidity function call using a low level `call`. A
478      * plain `call` is an unsafe replacement for a function call: use this
479      * function instead.
480      *
481      * If `target` reverts with a revert reason, it is bubbled up by this
482      * function (like regular Solidity function calls).
483      *
484      * Returns the raw returned data. To convert to the expected return value,
485      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
486      *
487      * Requirements:
488      *
489      * - `target` must be a contract.
490      * - calling `target` with `data` must not revert.
491      *
492      * _Available since v3.1._
493      */
494     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
495         return functionCall(target, data, "Address: low-level call failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
500      * `errorMessage` as a fallback revert reason when `target` reverts.
501      *
502      * _Available since v3.1._
503      */
504     function functionCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, 0, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but also transferring `value` wei to `target`.
515      *
516      * Requirements:
517      *
518      * - the calling contract must have an ETH balance of at least `value`.
519      * - the called Solidity function must be `payable`.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(
524         address target,
525         bytes memory data,
526         uint256 value
527     ) internal returns (bytes memory) {
528         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
533      * with `errorMessage` as a fallback revert reason when `target` reverts.
534      *
535      * _Available since v3.1._
536      */
537     function functionCallWithValue(
538         address target,
539         bytes memory data,
540         uint256 value,
541         string memory errorMessage
542     ) internal returns (bytes memory) {
543         require(address(this).balance >= value, "Address: insufficient balance for call");
544         require(isContract(target), "Address: call to non-contract");
545 
546         (bool success, bytes memory returndata) = target.call{value: value}(data);
547         return verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
557         return functionStaticCall(target, data, "Address: low-level static call failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
562      * but performing a static call.
563      *
564      * _Available since v3.3._
565      */
566     function functionStaticCall(
567         address target,
568         bytes memory data,
569         string memory errorMessage
570     ) internal view returns (bytes memory) {
571         require(isContract(target), "Address: static call to non-contract");
572 
573         (bool success, bytes memory returndata) = target.staticcall(data);
574         return verifyCallResult(success, returndata, errorMessage);
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
579      * but performing a delegate call.
580      *
581      * _Available since v3.4._
582      */
583     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
584         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
589      * but performing a delegate call.
590      *
591      * _Available since v3.4._
592      */
593     function functionDelegateCall(
594         address target,
595         bytes memory data,
596         string memory errorMessage
597     ) internal returns (bytes memory) {
598         require(isContract(target), "Address: delegate call to non-contract");
599 
600         (bool success, bytes memory returndata) = target.delegatecall(data);
601         return verifyCallResult(success, returndata, errorMessage);
602     }
603 
604     /**
605      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
606      * revert reason using the provided one.
607      *
608      * _Available since v4.3._
609      */
610     function verifyCallResult(
611         bool success,
612         bytes memory returndata,
613         string memory errorMessage
614     ) internal pure returns (bytes memory) {
615         if (success) {
616             return returndata;
617         } else {
618             // Look for revert reason and bubble it up if present
619             if (returndata.length > 0) {
620                 // The easiest way to bubble the revert reason is using memory via assembly
621 
622                 assembly {
623                     let returndata_size := mload(returndata)
624                     revert(add(32, returndata), returndata_size)
625                 }
626             } else {
627                 revert(errorMessage);
628             }
629         }
630     }
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
634 
635 
636 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @title ERC721 token receiver interface
642  * @dev Interface for any contract that wants to support safeTransfers
643  * from ERC721 asset contracts.
644  */
645 interface IERC721Receiver {
646     /**
647      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
648      * by `operator` from `from`, this function is called.
649      *
650      * It must return its Solidity selector to confirm the token transfer.
651      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
652      *
653      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
654      */
655     function onERC721Received(
656         address operator,
657         address from,
658         uint256 tokenId,
659         bytes calldata data
660     ) external returns (bytes4);
661 }
662 
663 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev Interface of the ERC165 standard, as defined in the
672  * https://eips.ethereum.org/EIPS/eip-165[EIP].
673  *
674  * Implementers can declare support of contract interfaces, which can then be
675  * queried by others ({ERC165Checker}).
676  *
677  * For an implementation, see {ERC165}.
678  */
679 interface IERC165 {
680     /**
681      * @dev Returns true if this contract implements the interface defined by
682      * `interfaceId`. See the corresponding
683      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
684      * to learn more about how these ids are created.
685      *
686      * This function call must use less than 30 000 gas.
687      */
688     function supportsInterface(bytes4 interfaceId) external view returns (bool);
689 }
690 
691 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
692 
693 
694 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 /**
700  * @dev Implementation of the {IERC165} interface.
701  *
702  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
703  * for the additional interface id that will be supported. For example:
704  *
705  * ```solidity
706  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
708  * }
709  * ```
710  *
711  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
712  */
713 abstract contract ERC165 is IERC165 {
714     /**
715      * @dev See {IERC165-supportsInterface}.
716      */
717     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
718         return interfaceId == type(IERC165).interfaceId;
719     }
720 }
721 
722 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
723 
724 
725 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 
730 /**
731  * @dev Required interface of an ERC721 compliant contract.
732  */
733 interface IERC721 is IERC165 {
734     /**
735      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
736      */
737     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
738 
739     /**
740      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
741      */
742     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
743 
744     /**
745      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
746      */
747     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
748 
749     /**
750      * @dev Returns the number of tokens in ``owner``'s account.
751      */
752     function balanceOf(address owner) external view returns (uint256 balance);
753 
754     /**
755      * @dev Returns the owner of the `tokenId` token.
756      *
757      * Requirements:
758      *
759      * - `tokenId` must exist.
760      */
761     function ownerOf(uint256 tokenId) external view returns (address owner);
762 
763     /**
764      * @dev Safely transfers `tokenId` token from `from` to `to`.
765      *
766      * Requirements:
767      *
768      * - `from` cannot be the zero address.
769      * - `to` cannot be the zero address.
770      * - `tokenId` token must exist and be owned by `from`.
771      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
772      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
773      *
774      * Emits a {Transfer} event.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId,
780         bytes calldata data
781     ) external;
782 
783     /**
784      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
785      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
793      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
794      *
795      * Emits a {Transfer} event.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) external;
802 
803     /**
804      * @dev Transfers `tokenId` token from `from` to `to`.
805      *
806      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
807      *
808      * Requirements:
809      *
810      * - `from` cannot be the zero address.
811      * - `to` cannot be the zero address.
812      * - `tokenId` token must be owned by `from`.
813      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
814      *
815      * Emits a {Transfer} event.
816      */
817     function transferFrom(
818         address from,
819         address to,
820         uint256 tokenId
821     ) external;
822 
823     /**
824      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
825      * The approval is cleared when the token is transferred.
826      *
827      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
828      *
829      * Requirements:
830      *
831      * - The caller must own the token or be an approved operator.
832      * - `tokenId` must exist.
833      *
834      * Emits an {Approval} event.
835      */
836     function approve(address to, uint256 tokenId) external;
837 
838     /**
839      * @dev Approve or remove `operator` as an operator for the caller.
840      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
841      *
842      * Requirements:
843      *
844      * - The `operator` cannot be the caller.
845      *
846      * Emits an {ApprovalForAll} event.
847      */
848     function setApprovalForAll(address operator, bool _approved) external;
849 
850     /**
851      * @dev Returns the account approved for `tokenId` token.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      */
857     function getApproved(uint256 tokenId) external view returns (address operator);
858 
859     /**
860      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
861      *
862      * See {setApprovalForAll}
863      */
864     function isApprovedForAll(address owner, address operator) external view returns (bool);
865 }
866 
867 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
868 
869 
870 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 
875 /**
876  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
877  * @dev See https://eips.ethereum.org/EIPS/eip-721
878  */
879 interface IERC721Enumerable is IERC721 {
880     /**
881      * @dev Returns the total amount of tokens stored by the contract.
882      */
883     function totalSupply() external view returns (uint256);
884 
885     /**
886      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
887      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
888      */
889     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
890 
891     /**
892      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
893      * Use along with {totalSupply} to enumerate all tokens.
894      */
895     function tokenByIndex(uint256 index) external view returns (uint256);
896 }
897 
898 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
899 
900 
901 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 
906 /**
907  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
908  * @dev See https://eips.ethereum.org/EIPS/eip-721
909  */
910 interface IERC721Metadata is IERC721 {
911     /**
912      * @dev Returns the token collection name.
913      */
914     function name() external view returns (string memory);
915 
916     /**
917      * @dev Returns the token collection symbol.
918      */
919     function symbol() external view returns (string memory);
920 
921     /**
922      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
923      */
924     function tokenURI(uint256 tokenId) external view returns (string memory);
925 }
926 
927 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
928 
929 
930 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 
936 
937 
938 
939 
940 
941 /**
942  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
943  * the Metadata extension, but not including the Enumerable extension, which is available separately as
944  * {ERC721Enumerable}.
945  */
946 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
947     using Address for address;
948     using Strings for uint256;
949 
950     // Token name
951     string private _name;
952 
953     // Token symbol
954     string private _symbol;
955 
956     // Mapping from token ID to owner address
957     mapping(uint256 => address) private _owners;
958 
959     // Mapping owner address to token count
960     mapping(address => uint256) private _balances;
961 
962     // Mapping from token ID to approved address
963     mapping(uint256 => address) private _tokenApprovals;
964 
965     // Mapping from owner to operator approvals
966     mapping(address => mapping(address => bool)) private _operatorApprovals;
967 
968     /**
969      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
970      */
971     constructor(string memory name_, string memory symbol_) {
972         _name = name_;
973         _symbol = symbol_;
974     }
975 
976     /**
977      * @dev See {IERC165-supportsInterface}.
978      */
979     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
980         return
981             interfaceId == type(IERC721).interfaceId ||
982             interfaceId == type(IERC721Metadata).interfaceId ||
983             super.supportsInterface(interfaceId);
984     }
985 
986     /**
987      * @dev See {IERC721-balanceOf}.
988      */
989     function balanceOf(address owner) public view virtual override returns (uint256) {
990         require(owner != address(0), "ERC721: balance query for the zero address");
991         return _balances[owner];
992     }
993 
994     /**
995      * @dev See {IERC721-ownerOf}.
996      */
997     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
998         address owner = _owners[tokenId];
999         require(owner != address(0), "ERC721: owner query for nonexistent token");
1000         return owner;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-name}.
1005      */
1006     function name() public view virtual override returns (string memory) {
1007         return _name;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-symbol}.
1012      */
1013     function symbol() public view virtual override returns (string memory) {
1014         return _symbol;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-tokenURI}.
1019      */
1020     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1021         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1022 
1023         string memory baseURI = _baseURI();
1024         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1025     }
1026 
1027     /**
1028      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1029      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1030      * by default, can be overridden in child contracts.
1031      */
1032     function _baseURI() internal view virtual returns (string memory) {
1033         return "";
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-approve}.
1038      */
1039     function approve(address to, uint256 tokenId) public virtual override {
1040         address owner = ERC721.ownerOf(tokenId);
1041         require(to != owner, "ERC721: approval to current owner");
1042 
1043         require(
1044             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1045             "ERC721: approve caller is not owner nor approved for all"
1046         );
1047 
1048         _approve(to, tokenId);
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-getApproved}.
1053      */
1054     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1055         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1056 
1057         return _tokenApprovals[tokenId];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-setApprovalForAll}.
1062      */
1063     function setApprovalForAll(address operator, bool approved) public virtual override {
1064         _setApprovalForAll(_msgSender(), operator, approved);
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-isApprovedForAll}.
1069      */
1070     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1071         return _operatorApprovals[owner][operator];
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-transferFrom}.
1076      */
1077     function transferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) public virtual override {
1082         //solhint-disable-next-line max-line-length
1083         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1084 
1085         _transfer(from, to, tokenId);
1086     }
1087 
1088     /**
1089      * @dev See {IERC721-safeTransferFrom}.
1090      */
1091     function safeTransferFrom(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) public virtual override {
1096         safeTransferFrom(from, to, tokenId, "");
1097     }
1098 
1099     /**
1100      * @dev See {IERC721-safeTransferFrom}.
1101      */
1102     function safeTransferFrom(
1103         address from,
1104         address to,
1105         uint256 tokenId,
1106         bytes memory _data
1107     ) public virtual override {
1108         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1109         _safeTransfer(from, to, tokenId, _data);
1110     }
1111 
1112     /**
1113      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1114      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1115      *
1116      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1117      *
1118      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1119      * implement alternative mechanisms to perform token transfer, such as signature-based.
1120      *
1121      * Requirements:
1122      *
1123      * - `from` cannot be the zero address.
1124      * - `to` cannot be the zero address.
1125      * - `tokenId` token must exist and be owned by `from`.
1126      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _safeTransfer(
1131         address from,
1132         address to,
1133         uint256 tokenId,
1134         bytes memory _data
1135     ) internal virtual {
1136         _transfer(from, to, tokenId);
1137         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1138     }
1139 
1140     /**
1141      * @dev Returns whether `tokenId` exists.
1142      *
1143      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1144      *
1145      * Tokens start existing when they are minted (`_mint`),
1146      * and stop existing when they are burned (`_burn`).
1147      */
1148     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1149         return _owners[tokenId] != address(0);
1150     }
1151 
1152     /**
1153      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1154      *
1155      * Requirements:
1156      *
1157      * - `tokenId` must exist.
1158      */
1159     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1160         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1161         address owner = ERC721.ownerOf(tokenId);
1162         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1163     }
1164 
1165     /**
1166      * @dev Safely mints `tokenId` and transfers it to `to`.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must not exist.
1171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function _safeMint(address to, uint256 tokenId) internal virtual {
1176         _safeMint(to, tokenId, "");
1177     }
1178 
1179     /**
1180      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1181      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1182      */
1183     function _safeMint(
1184         address to,
1185         uint256 tokenId,
1186         bytes memory _data
1187     ) internal virtual {
1188         _mint(to, tokenId);
1189         require(
1190             _checkOnERC721Received(address(0), to, tokenId, _data),
1191             "ERC721: transfer to non ERC721Receiver implementer"
1192         );
1193     }
1194 
1195     /**
1196      * @dev Mints `tokenId` and transfers it to `to`.
1197      *
1198      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1199      *
1200      * Requirements:
1201      *
1202      * - `tokenId` must not exist.
1203      * - `to` cannot be the zero address.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _mint(address to, uint256 tokenId) internal virtual {
1208         require(to != address(0), "ERC721: mint to the zero address");
1209         require(!_exists(tokenId), "ERC721: token already minted");
1210 
1211         _beforeTokenTransfer(address(0), to, tokenId);
1212 
1213         _balances[to] += 1;
1214         _owners[tokenId] = to;
1215 
1216         emit Transfer(address(0), to, tokenId);
1217 
1218         _afterTokenTransfer(address(0), to, tokenId);
1219     }
1220 
1221     /**
1222      * @dev Destroys `tokenId`.
1223      * The approval is cleared when the token is burned.
1224      *
1225      * Requirements:
1226      *
1227      * - `tokenId` must exist.
1228      *
1229      * Emits a {Transfer} event.
1230      */
1231     function _burn(uint256 tokenId) internal virtual {
1232         address owner = ERC721.ownerOf(tokenId);
1233 
1234         _beforeTokenTransfer(owner, address(0), tokenId);
1235 
1236         // Clear approvals
1237         _approve(address(0), tokenId);
1238 
1239         _balances[owner] -= 1;
1240         delete _owners[tokenId];
1241 
1242         emit Transfer(owner, address(0), tokenId);
1243 
1244         _afterTokenTransfer(owner, address(0), tokenId);
1245     }
1246 
1247     /**
1248      * @dev Transfers `tokenId` from `from` to `to`.
1249      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1250      *
1251      * Requirements:
1252      *
1253      * - `to` cannot be the zero address.
1254      * - `tokenId` token must be owned by `from`.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _transfer(
1259         address from,
1260         address to,
1261         uint256 tokenId
1262     ) internal virtual {
1263         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1264         require(to != address(0), "ERC721: transfer to the zero address");
1265 
1266         _beforeTokenTransfer(from, to, tokenId);
1267 
1268         // Clear approvals from the previous owner
1269         _approve(address(0), tokenId);
1270 
1271         _balances[from] -= 1;
1272         _balances[to] += 1;
1273         _owners[tokenId] = to;
1274 
1275         emit Transfer(from, to, tokenId);
1276 
1277         _afterTokenTransfer(from, to, tokenId);
1278     }
1279 
1280     /**
1281      * @dev Approve `to` to operate on `tokenId`
1282      *
1283      * Emits a {Approval} event.
1284      */
1285     function _approve(address to, uint256 tokenId) internal virtual {
1286         _tokenApprovals[tokenId] = to;
1287         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1288     }
1289 
1290     /**
1291      * @dev Approve `operator` to operate on all of `owner` tokens
1292      *
1293      * Emits a {ApprovalForAll} event.
1294      */
1295     function _setApprovalForAll(
1296         address owner,
1297         address operator,
1298         bool approved
1299     ) internal virtual {
1300         require(owner != operator, "ERC721: approve to caller");
1301         _operatorApprovals[owner][operator] = approved;
1302         emit ApprovalForAll(owner, operator, approved);
1303     }
1304 
1305     /**
1306      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1307      * The call is not executed if the target address is not a contract.
1308      *
1309      * @param from address representing the previous owner of the given token ID
1310      * @param to target address that will receive the tokens
1311      * @param tokenId uint256 ID of the token to be transferred
1312      * @param _data bytes optional data to send along with the call
1313      * @return bool whether the call correctly returned the expected magic value
1314      */
1315     function _checkOnERC721Received(
1316         address from,
1317         address to,
1318         uint256 tokenId,
1319         bytes memory _data
1320     ) private returns (bool) {
1321         if (to.isContract()) {
1322             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1323                 return retval == IERC721Receiver.onERC721Received.selector;
1324             } catch (bytes memory reason) {
1325                 if (reason.length == 0) {
1326                     revert("ERC721: transfer to non ERC721Receiver implementer");
1327                 } else {
1328                     assembly {
1329                         revert(add(32, reason), mload(reason))
1330                     }
1331                 }
1332             }
1333         } else {
1334             return true;
1335         }
1336     }
1337 
1338     /**
1339      * @dev Hook that is called before any token transfer. This includes minting
1340      * and burning.
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1348      * - `from` and `to` are never both zero.
1349      *
1350      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1351      */
1352     function _beforeTokenTransfer(
1353         address from,
1354         address to,
1355         uint256 tokenId
1356     ) internal virtual {}
1357 
1358     /**
1359      * @dev Hook that is called after any transfer of tokens. This includes
1360      * minting and burning.
1361      *
1362      * Calling conditions:
1363      *
1364      * - when `from` and `to` are both non-zero.
1365      * - `from` and `to` are never both zero.
1366      *
1367      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1368      */
1369     function _afterTokenTransfer(
1370         address from,
1371         address to,
1372         uint256 tokenId
1373     ) internal virtual {}
1374 }
1375 
1376 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1377 
1378 
1379 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1380 
1381 pragma solidity ^0.8.0;
1382 
1383 
1384 /**
1385  * @dev ERC721 token with storage based token URI management.
1386  */
1387 abstract contract ERC721URIStorage is ERC721 {
1388     using Strings for uint256;
1389 
1390     // Optional mapping for token URIs
1391     mapping(uint256 => string) private _tokenURIs;
1392 
1393     /**
1394      * @dev See {IERC721Metadata-tokenURI}.
1395      */
1396     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1397         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1398 
1399         string memory _tokenURI = _tokenURIs[tokenId];
1400         string memory base = _baseURI();
1401 
1402         // If there is no base URI, return the token URI.
1403         if (bytes(base).length == 0) {
1404             return _tokenURI;
1405         }
1406         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1407         if (bytes(_tokenURI).length > 0) {
1408             return string(abi.encodePacked(base, _tokenURI));
1409         }
1410 
1411         return super.tokenURI(tokenId);
1412     }
1413 
1414     /**
1415      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1416      *
1417      * Requirements:
1418      *
1419      * - `tokenId` must exist.
1420      */
1421     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1422         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1423         _tokenURIs[tokenId] = _tokenURI;
1424     }
1425 
1426     /**
1427      * @dev Destroys `tokenId`.
1428      * The approval is cleared when the token is burned.
1429      *
1430      * Requirements:
1431      *
1432      * - `tokenId` must exist.
1433      *
1434      * Emits a {Transfer} event.
1435      */
1436     function _burn(uint256 tokenId) internal virtual override {
1437         super._burn(tokenId);
1438 
1439         if (bytes(_tokenURIs[tokenId]).length != 0) {
1440             delete _tokenURIs[tokenId];
1441         }
1442     }
1443 }
1444 
1445 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1446 
1447 
1448 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1449 
1450 pragma solidity ^0.8.0;
1451 
1452 
1453 
1454 /**
1455  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1456  * enumerability of all the token ids in the contract as well as all token ids owned by each
1457  * account.
1458  */
1459 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1460     // Mapping from owner to list of owned token IDs
1461     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1462 
1463     // Mapping from token ID to index of the owner tokens list
1464     mapping(uint256 => uint256) private _ownedTokensIndex;
1465 
1466     // Array with all token ids, used for enumeration
1467     uint256[] private _allTokens;
1468 
1469     // Mapping from token id to position in the allTokens array
1470     mapping(uint256 => uint256) private _allTokensIndex;
1471 
1472     /**
1473      * @dev See {IERC165-supportsInterface}.
1474      */
1475     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1476         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1477     }
1478 
1479     /**
1480      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1481      */
1482     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1483         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1484         return _ownedTokens[owner][index];
1485     }
1486 
1487     /**
1488      * @dev See {IERC721Enumerable-totalSupply}.
1489      */
1490     function totalSupply() public view virtual override returns (uint256) {
1491         return _allTokens.length;
1492     }
1493 
1494     /**
1495      * @dev See {IERC721Enumerable-tokenByIndex}.
1496      */
1497     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1498         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1499         return _allTokens[index];
1500     }
1501 
1502     /**
1503      * @dev Hook that is called before any token transfer. This includes minting
1504      * and burning.
1505      *
1506      * Calling conditions:
1507      *
1508      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1509      * transferred to `to`.
1510      * - When `from` is zero, `tokenId` will be minted for `to`.
1511      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1512      * - `from` cannot be the zero address.
1513      * - `to` cannot be the zero address.
1514      *
1515      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1516      */
1517     function _beforeTokenTransfer(
1518         address from,
1519         address to,
1520         uint256 tokenId
1521     ) internal virtual override {
1522         super._beforeTokenTransfer(from, to, tokenId);
1523 
1524         if (from == address(0)) {
1525             _addTokenToAllTokensEnumeration(tokenId);
1526         } else if (from != to) {
1527             _removeTokenFromOwnerEnumeration(from, tokenId);
1528         }
1529         if (to == address(0)) {
1530             _removeTokenFromAllTokensEnumeration(tokenId);
1531         } else if (to != from) {
1532             _addTokenToOwnerEnumeration(to, tokenId);
1533         }
1534     }
1535 
1536     /**
1537      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1538      * @param to address representing the new owner of the given token ID
1539      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1540      */
1541     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1542         uint256 length = ERC721.balanceOf(to);
1543         _ownedTokens[to][length] = tokenId;
1544         _ownedTokensIndex[tokenId] = length;
1545     }
1546 
1547     /**
1548      * @dev Private function to add a token to this extension's token tracking data structures.
1549      * @param tokenId uint256 ID of the token to be added to the tokens list
1550      */
1551     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1552         _allTokensIndex[tokenId] = _allTokens.length;
1553         _allTokens.push(tokenId);
1554     }
1555 
1556     /**
1557      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1558      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1559      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1560      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1561      * @param from address representing the previous owner of the given token ID
1562      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1563      */
1564     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1565         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1566         // then delete the last slot (swap and pop).
1567 
1568         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1569         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1570 
1571         // When the token to delete is the last token, the swap operation is unnecessary
1572         if (tokenIndex != lastTokenIndex) {
1573             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1574 
1575             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1576             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1577         }
1578 
1579         // This also deletes the contents at the last position of the array
1580         delete _ownedTokensIndex[tokenId];
1581         delete _ownedTokens[from][lastTokenIndex];
1582     }
1583 
1584     /**
1585      * @dev Private function to remove a token from this extension's token tracking data structures.
1586      * This has O(1) time complexity, but alters the order of the _allTokens array.
1587      * @param tokenId uint256 ID of the token to be removed from the tokens list
1588      */
1589     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1590         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1591         // then delete the last slot (swap and pop).
1592 
1593         uint256 lastTokenIndex = _allTokens.length - 1;
1594         uint256 tokenIndex = _allTokensIndex[tokenId];
1595 
1596         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1597         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1598         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1599         uint256 lastTokenId = _allTokens[lastTokenIndex];
1600 
1601         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1602         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1603 
1604         // This also deletes the contents at the last position of the array
1605         delete _allTokensIndex[tokenId];
1606         _allTokens.pop();
1607     }
1608 }
1609 
1610 // File: contracts/NFTv9.sol
1611 
1612 
1613 pragma solidity ^0.8.4;
1614 
1615 
1616 
1617 
1618 
1619 
1620 contract NFTversion9 is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
1621     using ECDSA for bytes32;
1622     address private _systemAddress;
1623     mapping(string => bool) public _usedNonces;
1624     
1625     constructor() ERC721("NFTversion9", "NFTv9") { }
1626 
1627     function safeMint(uint256 tokenId, string memory uri, string memory nonce, bytes32 hash, bytes memory signature) public payable {
1628         // signature related
1629         require(matchSigner(hash, signature), "Plz mint through website");
1630         require(!_usedNonces[nonce], "Hash reused");
1631         require(
1632             hashTransaction(msg.sender, tokenId, nonce) == hash,
1633             "Hash failed"
1634         );
1635         _usedNonces[nonce] = true;
1636         
1637         _safeMint(msg.sender, tokenId);
1638         _setTokenURI(tokenId, uri);
1639     }
1640 
1641     function matchSigner(bytes32 hash, bytes memory signature) public view returns (bool) {
1642         return _systemAddress == hash.toEthSignedMessageHash().recover(signature);
1643     }
1644 
1645     function matchSignerTemp1() public view returns (address) {
1646         return _systemAddress;
1647     }
1648 
1649     function matchSignerTemp2(bytes32 hash, bytes memory signature) public pure returns (address) {
1650         return hash.toEthSignedMessageHash().recover(signature);
1651     }
1652 
1653     function hashTransaction(
1654         address sender,
1655         uint256 tokenId,
1656         string memory nonce
1657     ) public view returns (bytes32) {
1658         bytes32 hash = keccak256(
1659             abi.encodePacked(sender, tokenId, nonce, address(this))
1660         );
1661         return hash;
1662     }
1663 
1664     function setSystemAddress() public onlyOwner {
1665         _systemAddress = msg.sender;
1666     }
1667 
1668     function updateTokenURI(uint256 tokenId, string memory uri) public onlyOwner {
1669         _setTokenURI(tokenId, uri);
1670     }
1671 
1672     // The following functions are overrides required by Solidity.
1673 
1674     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1675         super._beforeTokenTransfer(from, to, tokenId);
1676     }
1677 
1678     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1679         super._burn(tokenId);
1680     }
1681 
1682     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1683         return super.tokenURI(tokenId);
1684     }
1685 
1686     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1687         return super.supportsInterface(interfaceId);
1688     }
1689 }