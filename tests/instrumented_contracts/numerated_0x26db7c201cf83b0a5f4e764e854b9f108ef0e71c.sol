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
636 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
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
653      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
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
725 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
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
764      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
765      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
766      *
767      * Requirements:
768      *
769      * - `from` cannot be the zero address.
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must exist and be owned by `from`.
772      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
773      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
774      *
775      * Emits a {Transfer} event.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) external;
782 
783     /**
784      * @dev Transfers `tokenId` token from `from` to `to`.
785      *
786      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must be owned by `from`.
793      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
794      *
795      * Emits a {Transfer} event.
796      */
797     function transferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) external;
802 
803     /**
804      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
805      * The approval is cleared when the token is transferred.
806      *
807      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
808      *
809      * Requirements:
810      *
811      * - The caller must own the token or be an approved operator.
812      * - `tokenId` must exist.
813      *
814      * Emits an {Approval} event.
815      */
816     function approve(address to, uint256 tokenId) external;
817 
818     /**
819      * @dev Returns the account approved for `tokenId` token.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function getApproved(uint256 tokenId) external view returns (address operator);
826 
827     /**
828      * @dev Approve or remove `operator` as an operator for the caller.
829      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
830      *
831      * Requirements:
832      *
833      * - The `operator` cannot be the caller.
834      *
835      * Emits an {ApprovalForAll} event.
836      */
837     function setApprovalForAll(address operator, bool _approved) external;
838 
839     /**
840      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
841      *
842      * See {setApprovalForAll}
843      */
844     function isApprovedForAll(address owner, address operator) external view returns (bool);
845 
846     /**
847      * @dev Safely transfers `tokenId` token from `from` to `to`.
848      *
849      * Requirements:
850      *
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must exist and be owned by `from`.
854      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
856      *
857      * Emits a {Transfer} event.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId,
863         bytes calldata data
864     ) external;
865 }
866 
867 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
868 
869 
870 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 
875 /**
876  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
877  * @dev See https://eips.ethereum.org/EIPS/eip-721
878  */
879 interface IERC721Metadata is IERC721 {
880     /**
881      * @dev Returns the token collection name.
882      */
883     function name() external view returns (string memory);
884 
885     /**
886      * @dev Returns the token collection symbol.
887      */
888     function symbol() external view returns (string memory);
889 
890     /**
891      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
892      */
893     function tokenURI(uint256 tokenId) external view returns (string memory);
894 }
895 
896 // File: erc721a/contracts/ERC721A.sol
897 
898 
899 // Creator: Chiru Labs
900 
901 pragma solidity ^0.8.4;
902 
903 
904 
905 
906 
907 
908 
909 
910 error ApprovalCallerNotOwnerNorApproved();
911 error ApprovalQueryForNonexistentToken();
912 error ApproveToCaller();
913 error ApprovalToCurrentOwner();
914 error BalanceQueryForZeroAddress();
915 error MintToZeroAddress();
916 error MintZeroQuantity();
917 error OwnerQueryForNonexistentToken();
918 error TransferCallerNotOwnerNorApproved();
919 error TransferFromIncorrectOwner();
920 error TransferToNonERC721ReceiverImplementer();
921 error TransferToZeroAddress();
922 error URIQueryForNonexistentToken();
923 
924 /**
925  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
926  * the Metadata extension. Built to optimize for lower gas during batch mints.
927  *
928  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
929  *
930  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
931  *
932  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
933  */
934 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
935     using Address for address;
936     using Strings for uint256;
937 
938     // Compiler will pack this into a single 256bit word.
939     struct TokenOwnership {
940         // The address of the owner.
941         address addr;
942         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
943         uint64 startTimestamp;
944         // Whether the token has been burned.
945         bool burned;
946     }
947 
948     // Compiler will pack this into a single 256bit word.
949     struct AddressData {
950         // Realistically, 2**64-1 is more than enough.
951         uint64 balance;
952         // Keeps track of mint count with minimal overhead for tokenomics.
953         uint64 numberMinted;
954         // Keeps track of burn count with minimal overhead for tokenomics.
955         uint64 numberBurned;
956         // For miscellaneous variable(s) pertaining to the address
957         // (e.g. number of whitelist mint slots used).
958         // If there are multiple variables, please pack them into a uint64.
959         uint64 aux;
960     }
961 
962     // The tokenId of the next token to be minted.
963     uint256 internal _currentIndex;
964 
965     // The number of tokens burned.
966     uint256 internal _burnCounter;
967 
968     // Token name
969     string private _name;
970 
971     // Token symbol
972     string private _symbol;
973 
974     // Mapping from token ID to ownership details
975     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
976     mapping(uint256 => TokenOwnership) internal _ownerships;
977 
978     // Mapping owner address to address data
979     mapping(address => AddressData) private _addressData;
980 
981     // Mapping from token ID to approved address
982     mapping(uint256 => address) private _tokenApprovals;
983 
984     // Mapping from owner to operator approvals
985     mapping(address => mapping(address => bool)) private _operatorApprovals;
986 
987     constructor(string memory name_, string memory symbol_) {
988         _name = name_;
989         _symbol = symbol_;
990         _currentIndex = _startTokenId();
991     }
992 
993     /**
994      * To change the starting tokenId, please override this function.
995      */
996     function _startTokenId() internal view virtual returns (uint256) {
997         return 0;
998     }
999 
1000     /**
1001      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1002      */
1003     function totalSupply() public view returns (uint256) {
1004         // Counter underflow is impossible as _burnCounter cannot be incremented
1005         // more than _currentIndex - _startTokenId() times
1006         unchecked {
1007             return _currentIndex - _burnCounter - _startTokenId();
1008         }
1009     }
1010 
1011     /**
1012      * Returns the total amount of tokens minted in the contract.
1013      */
1014     function _totalMinted() internal view returns (uint256) {
1015         // Counter underflow is impossible as _currentIndex does not decrement,
1016         // and it is initialized to _startTokenId()
1017         unchecked {
1018             return _currentIndex - _startTokenId();
1019         }
1020     }
1021 
1022     /**
1023      * @dev See {IERC165-supportsInterface}.
1024      */
1025     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1026         return
1027             interfaceId == type(IERC721).interfaceId ||
1028             interfaceId == type(IERC721Metadata).interfaceId ||
1029             super.supportsInterface(interfaceId);
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-balanceOf}.
1034      */
1035     function balanceOf(address owner) public view override returns (uint256) {
1036         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1037         return uint256(_addressData[owner].balance);
1038     }
1039 
1040     /**
1041      * Returns the number of tokens minted by `owner`.
1042      */
1043     function _numberMinted(address owner) internal view returns (uint256) {
1044         return uint256(_addressData[owner].numberMinted);
1045     }
1046 
1047     /**
1048      * Returns the number of tokens burned by or on behalf of `owner`.
1049      */
1050     function _numberBurned(address owner) internal view returns (uint256) {
1051         return uint256(_addressData[owner].numberBurned);
1052     }
1053 
1054     /**
1055      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1056      */
1057     function _getAux(address owner) internal view returns (uint64) {
1058         return _addressData[owner].aux;
1059     }
1060 
1061     /**
1062      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1063      * If there are multiple variables, please pack them into a uint64.
1064      */
1065     function _setAux(address owner, uint64 aux) internal {
1066         _addressData[owner].aux = aux;
1067     }
1068 
1069     /**
1070      * Gas spent here starts off proportional to the maximum mint batch size.
1071      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1072      */
1073     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1074         uint256 curr = tokenId;
1075 
1076         unchecked {
1077             if (_startTokenId() <= curr && curr < _currentIndex) {
1078                 TokenOwnership memory ownership = _ownerships[curr];
1079                 if (!ownership.burned) {
1080                     if (ownership.addr != address(0)) {
1081                         return ownership;
1082                     }
1083                     // Invariant:
1084                     // There will always be an ownership that has an address and is not burned
1085                     // before an ownership that does not have an address and is not burned.
1086                     // Hence, curr will not underflow.
1087                     while (true) {
1088                         curr--;
1089                         ownership = _ownerships[curr];
1090                         if (ownership.addr != address(0)) {
1091                             return ownership;
1092                         }
1093                     }
1094                 }
1095             }
1096         }
1097         revert OwnerQueryForNonexistentToken();
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-ownerOf}.
1102      */
1103     function ownerOf(uint256 tokenId) public view override returns (address) {
1104         return _ownershipOf(tokenId).addr;
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Metadata-name}.
1109      */
1110     function name() public view virtual override returns (string memory) {
1111         return _name;
1112     }
1113 
1114     /**
1115      * @dev See {IERC721Metadata-symbol}.
1116      */
1117     function symbol() public view virtual override returns (string memory) {
1118         return _symbol;
1119     }
1120 
1121     /**
1122      * @dev See {IERC721Metadata-tokenURI}.
1123      */
1124     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1125         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1126 
1127         string memory baseURI = _baseURI();
1128         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1129     }
1130 
1131     /**
1132      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1133      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1134      * by default, can be overriden in child contracts.
1135      */
1136     function _baseURI() internal view virtual returns (string memory) {
1137         return '';
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-approve}.
1142      */
1143     function approve(address to, uint256 tokenId) public override {
1144         address owner = ERC721A.ownerOf(tokenId);
1145         if (to == owner) revert ApprovalToCurrentOwner();
1146 
1147         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1148             revert ApprovalCallerNotOwnerNorApproved();
1149         }
1150 
1151         _approve(to, tokenId, owner);
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-getApproved}.
1156      */
1157     function getApproved(uint256 tokenId) public view override returns (address) {
1158         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1159 
1160         return _tokenApprovals[tokenId];
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-setApprovalForAll}.
1165      */
1166     function setApprovalForAll(address operator, bool approved) public virtual override {
1167         if (operator == _msgSender()) revert ApproveToCaller();
1168 
1169         _operatorApprovals[_msgSender()][operator] = approved;
1170         emit ApprovalForAll(_msgSender(), operator, approved);
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-isApprovedForAll}.
1175      */
1176     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1177         return _operatorApprovals[owner][operator];
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-transferFrom}.
1182      */
1183     function transferFrom(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) public virtual override {
1188         _transfer(from, to, tokenId);
1189     }
1190 
1191     /**
1192      * @dev See {IERC721-safeTransferFrom}.
1193      */
1194     function safeTransferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) public virtual override {
1199         safeTransferFrom(from, to, tokenId, '');
1200     }
1201 
1202     /**
1203      * @dev See {IERC721-safeTransferFrom}.
1204      */
1205     function safeTransferFrom(
1206         address from,
1207         address to,
1208         uint256 tokenId,
1209         bytes memory _data
1210     ) public virtual override {
1211         _transfer(from, to, tokenId);
1212         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1213             revert TransferToNonERC721ReceiverImplementer();
1214         }
1215     }
1216 
1217     /**
1218      * @dev Returns whether `tokenId` exists.
1219      *
1220      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1221      *
1222      * Tokens start existing when they are minted (`_mint`),
1223      */
1224     function _exists(uint256 tokenId) internal view returns (bool) {
1225         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1226     }
1227 
1228     function _safeMint(address to, uint256 quantity) internal {
1229         _safeMint(to, quantity, '');
1230     }
1231 
1232     /**
1233      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1234      *
1235      * Requirements:
1236      *
1237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1238      * - `quantity` must be greater than 0.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function _safeMint(
1243         address to,
1244         uint256 quantity,
1245         bytes memory _data
1246     ) internal {
1247         _mint(to, quantity, _data, true);
1248     }
1249 
1250     /**
1251      * @dev Mints `quantity` tokens and transfers them to `to`.
1252      *
1253      * Requirements:
1254      *
1255      * - `to` cannot be the zero address.
1256      * - `quantity` must be greater than 0.
1257      *
1258      * Emits a {Transfer} event.
1259      */
1260     function _mint(
1261         address to,
1262         uint256 quantity,
1263         bytes memory _data,
1264         bool safe
1265     ) internal {
1266         uint256 startTokenId = _currentIndex;
1267         if (to == address(0)) revert MintToZeroAddress();
1268         if (quantity == 0) revert MintZeroQuantity();
1269 
1270         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1271 
1272         // Overflows are incredibly unrealistic.
1273         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1274         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1275         unchecked {
1276             _addressData[to].balance += uint64(quantity);
1277             _addressData[to].numberMinted += uint64(quantity);
1278 
1279             _ownerships[startTokenId].addr = to;
1280             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1281 
1282             uint256 updatedIndex = startTokenId;
1283             uint256 end = updatedIndex + quantity;
1284 
1285             if (safe && to.isContract()) {
1286                 do {
1287                     emit Transfer(address(0), to, updatedIndex);
1288                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1289                         revert TransferToNonERC721ReceiverImplementer();
1290                     }
1291                 } while (updatedIndex != end);
1292                 // Reentrancy protection
1293                 if (_currentIndex != startTokenId) revert();
1294             } else {
1295                 do {
1296                     emit Transfer(address(0), to, updatedIndex++);
1297                 } while (updatedIndex != end);
1298             }
1299             _currentIndex = updatedIndex;
1300         }
1301         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1302     }
1303 
1304     /**
1305      * @dev Transfers `tokenId` from `from` to `to`.
1306      *
1307      * Requirements:
1308      *
1309      * - `to` cannot be the zero address.
1310      * - `tokenId` token must be owned by `from`.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function _transfer(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) private {
1319         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1320 
1321         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1322 
1323         bool isApprovedOrOwner = (_msgSender() == from ||
1324             isApprovedForAll(from, _msgSender()) ||
1325             getApproved(tokenId) == _msgSender());
1326 
1327         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1328         if (to == address(0)) revert TransferToZeroAddress();
1329 
1330         _beforeTokenTransfers(from, to, tokenId, 1);
1331 
1332         // Clear approvals from the previous owner
1333         _approve(address(0), tokenId, from);
1334 
1335         // Underflow of the sender's balance is impossible because we check for
1336         // ownership above and the recipient's balance can't realistically overflow.
1337         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1338         unchecked {
1339             _addressData[from].balance -= 1;
1340             _addressData[to].balance += 1;
1341 
1342             TokenOwnership storage currSlot = _ownerships[tokenId];
1343             currSlot.addr = to;
1344             currSlot.startTimestamp = uint64(block.timestamp);
1345 
1346             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1347             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1348             uint256 nextTokenId = tokenId + 1;
1349             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1350             if (nextSlot.addr == address(0)) {
1351                 // This will suffice for checking _exists(nextTokenId),
1352                 // as a burned slot cannot contain the zero address.
1353                 if (nextTokenId != _currentIndex) {
1354                     nextSlot.addr = from;
1355                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1356                 }
1357             }
1358         }
1359 
1360         emit Transfer(from, to, tokenId);
1361         _afterTokenTransfers(from, to, tokenId, 1);
1362     }
1363 
1364     /**
1365      * @dev This is equivalent to _burn(tokenId, false)
1366      */
1367     function _burn(uint256 tokenId) internal virtual {
1368         _burn(tokenId, false);
1369     }
1370 
1371     /**
1372      * @dev Destroys `tokenId`.
1373      * The approval is cleared when the token is burned.
1374      *
1375      * Requirements:
1376      *
1377      * - `tokenId` must exist.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1382         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1383 
1384         address from = prevOwnership.addr;
1385 
1386         if (approvalCheck) {
1387             bool isApprovedOrOwner = (_msgSender() == from ||
1388                 isApprovedForAll(from, _msgSender()) ||
1389                 getApproved(tokenId) == _msgSender());
1390 
1391             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1392         }
1393 
1394         _beforeTokenTransfers(from, address(0), tokenId, 1);
1395 
1396         // Clear approvals from the previous owner
1397         _approve(address(0), tokenId, from);
1398 
1399         // Underflow of the sender's balance is impossible because we check for
1400         // ownership above and the recipient's balance can't realistically overflow.
1401         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1402         unchecked {
1403             AddressData storage addressData = _addressData[from];
1404             addressData.balance -= 1;
1405             addressData.numberBurned += 1;
1406 
1407             // Keep track of who burned the token, and the timestamp of burning.
1408             TokenOwnership storage currSlot = _ownerships[tokenId];
1409             currSlot.addr = from;
1410             currSlot.startTimestamp = uint64(block.timestamp);
1411             currSlot.burned = true;
1412 
1413             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1414             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1415             uint256 nextTokenId = tokenId + 1;
1416             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1417             if (nextSlot.addr == address(0)) {
1418                 // This will suffice for checking _exists(nextTokenId),
1419                 // as a burned slot cannot contain the zero address.
1420                 if (nextTokenId != _currentIndex) {
1421                     nextSlot.addr = from;
1422                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1423                 }
1424             }
1425         }
1426 
1427         emit Transfer(from, address(0), tokenId);
1428         _afterTokenTransfers(from, address(0), tokenId, 1);
1429 
1430         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1431         unchecked {
1432             _burnCounter++;
1433         }
1434     }
1435 
1436     /**
1437      * @dev Approve `to` to operate on `tokenId`
1438      *
1439      * Emits a {Approval} event.
1440      */
1441     function _approve(
1442         address to,
1443         uint256 tokenId,
1444         address owner
1445     ) private {
1446         _tokenApprovals[tokenId] = to;
1447         emit Approval(owner, to, tokenId);
1448     }
1449 
1450     /**
1451      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1452      *
1453      * @param from address representing the previous owner of the given token ID
1454      * @param to target address that will receive the tokens
1455      * @param tokenId uint256 ID of the token to be transferred
1456      * @param _data bytes optional data to send along with the call
1457      * @return bool whether the call correctly returned the expected magic value
1458      */
1459     function _checkContractOnERC721Received(
1460         address from,
1461         address to,
1462         uint256 tokenId,
1463         bytes memory _data
1464     ) private returns (bool) {
1465         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1466             return retval == IERC721Receiver(to).onERC721Received.selector;
1467         } catch (bytes memory reason) {
1468             if (reason.length == 0) {
1469                 revert TransferToNonERC721ReceiverImplementer();
1470             } else {
1471                 assembly {
1472                     revert(add(32, reason), mload(reason))
1473                 }
1474             }
1475         }
1476     }
1477 
1478     /**
1479      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1480      * And also called before burning one token.
1481      *
1482      * startTokenId - the first token id to be transferred
1483      * quantity - the amount to be transferred
1484      *
1485      * Calling conditions:
1486      *
1487      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1488      * transferred to `to`.
1489      * - When `from` is zero, `tokenId` will be minted for `to`.
1490      * - When `to` is zero, `tokenId` will be burned by `from`.
1491      * - `from` and `to` are never both zero.
1492      */
1493     function _beforeTokenTransfers(
1494         address from,
1495         address to,
1496         uint256 startTokenId,
1497         uint256 quantity
1498     ) internal virtual {}
1499 
1500     /**
1501      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1502      * minting.
1503      * And also called after one token has been burned.
1504      *
1505      * startTokenId - the first token id to be transferred
1506      * quantity - the amount to be transferred
1507      *
1508      * Calling conditions:
1509      *
1510      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1511      * transferred to `to`.
1512      * - When `from` is zero, `tokenId` has been minted for `to`.
1513      * - When `to` is zero, `tokenId` has been burned by `from`.
1514      * - `from` and `to` are never both zero.
1515      */
1516     function _afterTokenTransfers(
1517         address from,
1518         address to,
1519         uint256 startTokenId,
1520         uint256 quantity
1521     ) internal virtual {}
1522 }
1523 
1524 // File: contracts/Companions.sol
1525 
1526 
1527 
1528 pragma solidity 0.8.10;
1529 
1530 
1531 
1532 
1533 interface Shines {
1534     function ownerOf(uint256 tokenId) external view returns (address);
1535 }
1536 
1537 contract Companion is ERC721A, Ownable {
1538     using Strings for uint256;
1539     using ECDSA for bytes32;
1540 
1541     bytes32 constant private salt = bytes32(0x63e211fde095b028ad3db5ac6b2b2cece35c844465446d43b3873c8777606a2f);
1542 
1543     uint256 constant public MAX_TX_LIMIT = 20;
1544     
1545     uint256 public cost = 0.025 ether;
1546     uint256 public wlCost = 0.015 ether;
1547 
1548     uint256 public maxSupply = 6666;
1549     uint256 public maxWhitelistSupply = 20;
1550     uint256 public maxClaimSupply = 3333;
1551     uint256 public whitelistLimit = 1;
1552     uint256 public mintedByWhitelist;
1553     uint256 public mintedByClaim;
1554 
1555     bool public isPublicSale;
1556     bool public isWhitelistSale;
1557     bool public claimMintEnabled;
1558     bool public isURIFrozen;
1559     bool public tokensStillReserved = true;
1560 
1561     address private _signatureVerifier = 0x4704A6507ED359F78f1C0280359F9A72afE6B02F;
1562 
1563     string private baseURI = "ipfs://bafybeie3y7kf4cz4c2bjrjjmla244xxn57rkxn7azuynn23wrzv7j4kh7e/metadata/";
1564     string public baseExtension = ".json";
1565     mapping(uint256 => bool) public claimedTokenIds;
1566 
1567     Shines public nft = Shines(0xa00108f4CFB6400d43C911af0d7a3422f7c011E5);
1568     
1569     constructor() ERC721A("Companion", "CMP") {}
1570 
1571     function mint(uint256 _quantity) external payable {
1572         require(isPublicSale, "Public sale: Inactive");
1573         require(_quantity > 0, "Number should be more than 0");
1574         require(_quantity <= MAX_TX_LIMIT, "Exceeds the limit");
1575         if(tokensStillReserved) {
1576             require(totalSupply() + _quantity <= maxSupply - maxWhitelistSupply + mintedByWhitelist - maxClaimSupply + mintedByClaim, "Not enough tokens left");
1577         } else {
1578             require(totalSupply() + _quantity <= maxSupply, "Not enough tokens left");
1579         }
1580         require(msg.value >= cost * _quantity, "Not enough ether sent");
1581         _safeMint(msg.sender, _quantity);
1582     }
1583 
1584     function whiteListMint(uint256 _quantity, bytes calldata signature) external payable {
1585         require(isWhitelistSale, "Whitelist sale: Inactive");
1586         require(_quantity > 0, "Number should be more than 0");
1587         require(_quantity + _numberMinted(msg.sender) <= whitelistLimit, "Exceeds the limit");
1588         require(totalSupply() + _quantity <= maxSupply, "Not enough tokens left");
1589         require(msg.value >= wlCost * _quantity, "Not enough ether sent");
1590 
1591         require(isUserWhitelisted(msg.sender, signature), "User not whitelisted");
1592         mintedByWhitelist += 1;
1593         _safeMint(msg.sender, _quantity);
1594     }
1595 
1596     function claim(uint256[] memory _ownedTokenIds) external {
1597         require(claimMintEnabled, "Claim Mint is paused.");
1598         require(_ownedTokenIds.length > 0, "owned tokens size is 0");
1599 
1600         for(uint256 i = 0; i < _ownedTokenIds.length; i++){
1601             require(msg.sender == nft.ownerOf(_ownedTokenIds[i]), "You dont have this token");
1602             require(!claimedTokenIds[_ownedTokenIds[i]], "This token alerday claimed");
1603             claimedTokenIds[_ownedTokenIds[i]] = true;
1604         }
1605         mintedByClaim += 1;
1606         _safeMint(msg.sender, _ownedTokenIds.length);
1607     }
1608 
1609     function isUserWhitelisted(address _user, bytes calldata _signature) public view returns(bool) {
1610         bytes32 messageHash = hashMessage(_user);
1611         return messageHash.recover(_signature) == _signatureVerifier;
1612     }
1613 
1614     function withdraw() external onlyOwner {
1615         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1616         require(os);
1617     }
1618 
1619     // Owner functions
1620     
1621     function setSignatureVerifier(address newVerifier) external onlyOwner {
1622         _signatureVerifier = newVerifier;
1623     }
1624 
1625     function togglePreSale() external onlyOwner {
1626         isWhitelistSale = !isWhitelistSale;
1627     }
1628 
1629     function togglePublicSale() external onlyOwner {
1630         isPublicSale = !isPublicSale;
1631     }
1632 
1633     function toggleClaimStatus(bool _claimMintStatus) external onlyOwner {
1634         claimMintEnabled = _claimMintStatus;
1635     }
1636 
1637     // Just a helper method to allow absolute guarantee that whitelist people
1638     // will be able to get their portions even if public mint is very congested.
1639     function toggleSwitch() external onlyOwner {
1640         tokensStillReserved = !tokensStillReserved;
1641     }
1642     
1643     function beginSales() external onlyOwner {
1644         isWhitelistSale = !isWhitelistSale;
1645         isPublicSale = !isPublicSale;
1646         claimMintEnabled = !claimMintEnabled;
1647     }
1648 
1649     function setBaseExtension(string calldata _newBaseExtension) external onlyOwner {
1650         require(!isURIFrozen, "URI is Frozen");
1651         baseExtension = _newBaseExtension;
1652     }
1653 
1654     function setBaseURI(string calldata newURI) external onlyOwner {
1655         require(!isURIFrozen, "URI is Frozen");
1656         baseURI = newURI;
1657     }
1658 
1659 
1660     function freezeURI() external onlyOwner {
1661         isURIFrozen = true;
1662     }
1663     
1664     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1665         require(_maxSupply <= 22222, "Cannot set higher than 22222");
1666         maxSupply = _maxSupply;
1667     }
1668     
1669     function setWhitelistLimit(uint256 _whitelistLimit) external onlyOwner {
1670         whitelistLimit = _whitelistLimit;
1671     }
1672 
1673     function setCost(uint256 _cost) external onlyOwner {
1674         cost = _cost;
1675     }
1676 
1677     function setWhitelistCost(uint256 _cost) external onlyOwner {
1678         wlCost = _cost;
1679     }
1680 
1681     // view functions
1682     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1683         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1684 
1685         string memory currentBaseURI = _baseURI();
1686         return bytes(currentBaseURI).length > 0 
1687             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1688             : "";
1689     }
1690 
1691     function _baseURI() internal view override returns (string memory) {
1692         return baseURI;
1693     }
1694 
1695     function _startTokenId() internal view virtual override returns (uint256) {
1696         return 0;
1697     }
1698 
1699     function hashMessage(address sender) internal pure returns(bytes32) {
1700         bytes32 payloadHash = keccak256(abi.encode(sender, salt));
1701         bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", payloadHash));
1702 
1703         return messageHash;
1704     }
1705 }