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
927 // File: erc721a/contracts/ERC721A.sol
928 
929 
930 // Creator: Chiru Labs
931 
932 pragma solidity ^0.8.4;
933 
934 
935 
936 
937 
938 
939 
940 
941 
942 error ApprovalCallerNotOwnerNorApproved();
943 error ApprovalQueryForNonexistentToken();
944 error ApproveToCaller();
945 error ApprovalToCurrentOwner();
946 error BalanceQueryForZeroAddress();
947 error MintedQueryForZeroAddress();
948 error BurnedQueryForZeroAddress();
949 error AuxQueryForZeroAddress();
950 error MintToZeroAddress();
951 error MintZeroQuantity();
952 error OwnerIndexOutOfBounds();
953 error OwnerQueryForNonexistentToken();
954 error TokenIndexOutOfBounds();
955 error TransferCallerNotOwnerNorApproved();
956 error TransferFromIncorrectOwner();
957 error TransferToNonERC721ReceiverImplementer();
958 error TransferToZeroAddress();
959 error URIQueryForNonexistentToken();
960 
961 /**
962  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
963  * the Metadata extension. Built to optimize for lower gas during batch mints.
964  *
965  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
966  *
967  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
968  *
969  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
970  */
971 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
972     using Address for address;
973     using Strings for uint256;
974 
975     // Compiler will pack this into a single 256bit word.
976     struct TokenOwnership {
977         // The address of the owner.
978         address addr;
979         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
980         uint64 startTimestamp;
981         // Whether the token has been burned.
982         bool burned;
983     }
984 
985     // Compiler will pack this into a single 256bit word.
986     struct AddressData {
987         // Realistically, 2**64-1 is more than enough.
988         uint64 balance;
989         // Keeps track of mint count with minimal overhead for tokenomics.
990         uint64 numberMinted;
991         // Keeps track of burn count with minimal overhead for tokenomics.
992         uint64 numberBurned;
993         // For miscellaneous variable(s) pertaining to the address
994         // (e.g. number of whitelist mint slots used).
995         // If there are multiple variables, please pack them into a uint64.
996         uint64 aux;
997     }
998 
999     // The tokenId of the next token to be minted.
1000     uint256 internal _currentIndex;
1001 
1002     // The number of tokens burned.
1003     uint256 internal _burnCounter;
1004 
1005     // Token name
1006     string private _name;
1007 
1008     // Token symbol
1009     string private _symbol;
1010 
1011     // Mapping from token ID to ownership details
1012     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1013     mapping(uint256 => TokenOwnership) internal _ownerships;
1014 
1015     // Mapping owner address to address data
1016     mapping(address => AddressData) private _addressData;
1017 
1018     // Mapping from token ID to approved address
1019     mapping(uint256 => address) private _tokenApprovals;
1020 
1021     // Mapping from owner to operator approvals
1022     mapping(address => mapping(address => bool)) private _operatorApprovals;
1023 
1024     constructor(string memory name_, string memory symbol_) {
1025         _name = name_;
1026         _symbol = symbol_;
1027         _currentIndex = _startTokenId();
1028     }
1029 
1030     /**
1031      * To change the starting tokenId, please override this function.
1032      */
1033     function _startTokenId() internal view virtual returns (uint256) {
1034         return 0;
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Enumerable-totalSupply}.
1039      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1040      */
1041     function totalSupply() public view returns (uint256) {
1042         // Counter underflow is impossible as _burnCounter cannot be incremented
1043         // more than _currentIndex - _startTokenId() times
1044         unchecked {
1045             return _currentIndex - _burnCounter - _startTokenId();
1046         }
1047     }
1048 
1049     /**
1050      * Returns the total amount of tokens minted in the contract.
1051      */
1052     function _totalMinted() internal view returns (uint256) {
1053         // Counter underflow is impossible as _currentIndex does not decrement,
1054         // and it is initialized to _startTokenId()
1055         unchecked {
1056             return _currentIndex - _startTokenId();
1057         }
1058     }
1059 
1060     /**
1061      * @dev See {IERC165-supportsInterface}.
1062      */
1063     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1064         return
1065             interfaceId == type(IERC721).interfaceId ||
1066             interfaceId == type(IERC721Metadata).interfaceId ||
1067             super.supportsInterface(interfaceId);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-balanceOf}.
1072      */
1073     function balanceOf(address owner) public view override returns (uint256) {
1074         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1075         return uint256(_addressData[owner].balance);
1076     }
1077 
1078     /**
1079      * Returns the number of tokens minted by `owner`.
1080      */
1081     function _numberMinted(address owner) internal view returns (uint256) {
1082         if (owner == address(0)) revert MintedQueryForZeroAddress();
1083         return uint256(_addressData[owner].numberMinted);
1084     }
1085 
1086     /**
1087      * Returns the number of tokens burned by or on behalf of `owner`.
1088      */
1089     function _numberBurned(address owner) internal view returns (uint256) {
1090         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1091         return uint256(_addressData[owner].numberBurned);
1092     }
1093 
1094     /**
1095      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1096      */
1097     function _getAux(address owner) internal view returns (uint64) {
1098         if (owner == address(0)) revert AuxQueryForZeroAddress();
1099         return _addressData[owner].aux;
1100     }
1101 
1102     /**
1103      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1104      * If there are multiple variables, please pack them into a uint64.
1105      */
1106     function _setAux(address owner, uint64 aux) internal {
1107         if (owner == address(0)) revert AuxQueryForZeroAddress();
1108         _addressData[owner].aux = aux;
1109     }
1110 
1111     /**
1112      * Gas spent here starts off proportional to the maximum mint batch size.
1113      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1114      */
1115     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1116         uint256 curr = tokenId;
1117 
1118         unchecked {
1119             if (_startTokenId() <= curr && curr < _currentIndex) {
1120                 TokenOwnership memory ownership = _ownerships[curr];
1121                 if (!ownership.burned) {
1122                     if (ownership.addr != address(0)) {
1123                         return ownership;
1124                     }
1125                     // Invariant:
1126                     // There will always be an ownership that has an address and is not burned
1127                     // before an ownership that does not have an address and is not burned.
1128                     // Hence, curr will not underflow.
1129                     while (true) {
1130                         curr--;
1131                         ownership = _ownerships[curr];
1132                         if (ownership.addr != address(0)) {
1133                             return ownership;
1134                         }
1135                     }
1136                 }
1137             }
1138         }
1139         revert OwnerQueryForNonexistentToken();
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-ownerOf}.
1144      */
1145     function ownerOf(uint256 tokenId) public view override returns (address) {
1146         return ownershipOf(tokenId).addr;
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Metadata-name}.
1151      */
1152     function name() public view virtual override returns (string memory) {
1153         return _name;
1154     }
1155 
1156     /**
1157      * @dev See {IERC721Metadata-symbol}.
1158      */
1159     function symbol() public view virtual override returns (string memory) {
1160         return _symbol;
1161     }
1162 
1163     /**
1164      * @dev See {IERC721Metadata-tokenURI}.
1165      */
1166     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1167         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1168 
1169         string memory baseURI = _baseURI();
1170         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1171     }
1172 
1173     /**
1174      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1175      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1176      * by default, can be overriden in child contracts.
1177      */
1178     function _baseURI() internal view virtual returns (string memory) {
1179         return '';
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-approve}.
1184      */
1185     function approve(address to, uint256 tokenId) public override {
1186         address owner = ERC721A.ownerOf(tokenId);
1187         if (to == owner) revert ApprovalToCurrentOwner();
1188 
1189         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1190             revert ApprovalCallerNotOwnerNorApproved();
1191         }
1192 
1193         _approve(to, tokenId, owner);
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-getApproved}.
1198      */
1199     function getApproved(uint256 tokenId) public view override returns (address) {
1200         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1201 
1202         return _tokenApprovals[tokenId];
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-setApprovalForAll}.
1207      */
1208     function setApprovalForAll(address operator, bool approved) public override {
1209         if (operator == _msgSender()) revert ApproveToCaller();
1210 
1211         _operatorApprovals[_msgSender()][operator] = approved;
1212         emit ApprovalForAll(_msgSender(), operator, approved);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-isApprovedForAll}.
1217      */
1218     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1219         return _operatorApprovals[owner][operator];
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-transferFrom}.
1224      */
1225     function transferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) public virtual override {
1230         _transfer(from, to, tokenId);
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-safeTransferFrom}.
1235      */
1236     function safeTransferFrom(
1237         address from,
1238         address to,
1239         uint256 tokenId
1240     ) public virtual override {
1241         safeTransferFrom(from, to, tokenId, '');
1242     }
1243 
1244     /**
1245      * @dev See {IERC721-safeTransferFrom}.
1246      */
1247     function safeTransferFrom(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         bytes memory _data
1252     ) public virtual override {
1253         _transfer(from, to, tokenId);
1254         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1255             revert TransferToNonERC721ReceiverImplementer();
1256         }
1257     }
1258 
1259     /**
1260      * @dev Returns whether `tokenId` exists.
1261      *
1262      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1263      *
1264      * Tokens start existing when they are minted (`_mint`),
1265      */
1266     function _exists(uint256 tokenId) internal view returns (bool) {
1267         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1268             !_ownerships[tokenId].burned;
1269     }
1270 
1271     function _safeMint(address to, uint256 quantity) internal {
1272         _safeMint(to, quantity, '');
1273     }
1274 
1275     /**
1276      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1277      *
1278      * Requirements:
1279      *
1280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1281      * - `quantity` must be greater than 0.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function _safeMint(
1286         address to,
1287         uint256 quantity,
1288         bytes memory _data
1289     ) internal {
1290         _mint(to, quantity, _data, true);
1291     }
1292 
1293     /**
1294      * @dev Mints `quantity` tokens and transfers them to `to`.
1295      *
1296      * Requirements:
1297      *
1298      * - `to` cannot be the zero address.
1299      * - `quantity` must be greater than 0.
1300      *
1301      * Emits a {Transfer} event.
1302      */
1303     function _mint(
1304         address to,
1305         uint256 quantity,
1306         bytes memory _data,
1307         bool safe
1308     ) internal {
1309         uint256 startTokenId = _currentIndex;
1310         if (to == address(0)) revert MintToZeroAddress();
1311         if (quantity == 0) revert MintZeroQuantity();
1312 
1313         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1314 
1315         // Overflows are incredibly unrealistic.
1316         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1317         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1318         unchecked {
1319             _addressData[to].balance += uint64(quantity);
1320             _addressData[to].numberMinted += uint64(quantity);
1321 
1322             _ownerships[startTokenId].addr = to;
1323             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1324 
1325             uint256 updatedIndex = startTokenId;
1326             uint256 end = updatedIndex + quantity;
1327 
1328             if (safe && to.isContract()) {
1329                 do {
1330                     emit Transfer(address(0), to, updatedIndex);
1331                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1332                         revert TransferToNonERC721ReceiverImplementer();
1333                     }
1334                 } while (updatedIndex != end);
1335                 // Reentrancy protection
1336                 if (_currentIndex != startTokenId) revert();
1337             } else {
1338                 do {
1339                     emit Transfer(address(0), to, updatedIndex++);
1340                 } while (updatedIndex != end);
1341             }
1342             _currentIndex = updatedIndex;
1343         }
1344         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1345     }
1346 
1347     /**
1348      * @dev Transfers `tokenId` from `from` to `to`.
1349      *
1350      * Requirements:
1351      *
1352      * - `to` cannot be the zero address.
1353      * - `tokenId` token must be owned by `from`.
1354      *
1355      * Emits a {Transfer} event.
1356      */
1357     function _transfer(
1358         address from,
1359         address to,
1360         uint256 tokenId
1361     ) private {
1362         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1363 
1364         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1365             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1366             getApproved(tokenId) == _msgSender());
1367 
1368         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1369         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1370         if (to == address(0)) revert TransferToZeroAddress();
1371 
1372         _beforeTokenTransfers(from, to, tokenId, 1);
1373 
1374         // Clear approvals from the previous owner
1375         _approve(address(0), tokenId, prevOwnership.addr);
1376 
1377         // Underflow of the sender's balance is impossible because we check for
1378         // ownership above and the recipient's balance can't realistically overflow.
1379         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1380         unchecked {
1381             _addressData[from].balance -= 1;
1382             _addressData[to].balance += 1;
1383 
1384             _ownerships[tokenId].addr = to;
1385             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1386 
1387             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1388             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1389             uint256 nextTokenId = tokenId + 1;
1390             if (_ownerships[nextTokenId].addr == address(0)) {
1391                 // This will suffice for checking _exists(nextTokenId),
1392                 // as a burned slot cannot contain the zero address.
1393                 if (nextTokenId < _currentIndex) {
1394                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1395                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1396                 }
1397             }
1398         }
1399 
1400         emit Transfer(from, to, tokenId);
1401         _afterTokenTransfers(from, to, tokenId, 1);
1402     }
1403 
1404     /**
1405      * @dev Destroys `tokenId`.
1406      * The approval is cleared when the token is burned.
1407      *
1408      * Requirements:
1409      *
1410      * - `tokenId` must exist.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function _burn(uint256 tokenId) internal virtual {
1415         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1416 
1417         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1418 
1419         // Clear approvals from the previous owner
1420         _approve(address(0), tokenId, prevOwnership.addr);
1421 
1422         // Underflow of the sender's balance is impossible because we check for
1423         // ownership above and the recipient's balance can't realistically overflow.
1424         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1425         unchecked {
1426             _addressData[prevOwnership.addr].balance -= 1;
1427             _addressData[prevOwnership.addr].numberBurned += 1;
1428 
1429             // Keep track of who burned the token, and the timestamp of burning.
1430             _ownerships[tokenId].addr = prevOwnership.addr;
1431             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1432             _ownerships[tokenId].burned = true;
1433 
1434             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1435             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1436             uint256 nextTokenId = tokenId + 1;
1437             if (_ownerships[nextTokenId].addr == address(0)) {
1438                 // This will suffice for checking _exists(nextTokenId),
1439                 // as a burned slot cannot contain the zero address.
1440                 if (nextTokenId < _currentIndex) {
1441                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1442                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1443                 }
1444             }
1445         }
1446 
1447         emit Transfer(prevOwnership.addr, address(0), tokenId);
1448         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1449 
1450         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1451         unchecked {
1452             _burnCounter++;
1453         }
1454     }
1455 
1456     /**
1457      * @dev Approve `to` to operate on `tokenId`
1458      *
1459      * Emits a {Approval} event.
1460      */
1461     function _approve(
1462         address to,
1463         uint256 tokenId,
1464         address owner
1465     ) private {
1466         _tokenApprovals[tokenId] = to;
1467         emit Approval(owner, to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1472      *
1473      * @param from address representing the previous owner of the given token ID
1474      * @param to target address that will receive the tokens
1475      * @param tokenId uint256 ID of the token to be transferred
1476      * @param _data bytes optional data to send along with the call
1477      * @return bool whether the call correctly returned the expected magic value
1478      */
1479     function _checkContractOnERC721Received(
1480         address from,
1481         address to,
1482         uint256 tokenId,
1483         bytes memory _data
1484     ) private returns (bool) {
1485         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1486             return retval == IERC721Receiver(to).onERC721Received.selector;
1487         } catch (bytes memory reason) {
1488             if (reason.length == 0) {
1489                 revert TransferToNonERC721ReceiverImplementer();
1490             } else {
1491                 assembly {
1492                     revert(add(32, reason), mload(reason))
1493                 }
1494             }
1495         }
1496     }
1497 
1498     /**
1499      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1500      * And also called before burning one token.
1501      *
1502      * startTokenId - the first token id to be transferred
1503      * quantity - the amount to be transferred
1504      *
1505      * Calling conditions:
1506      *
1507      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1508      * transferred to `to`.
1509      * - When `from` is zero, `tokenId` will be minted for `to`.
1510      * - When `to` is zero, `tokenId` will be burned by `from`.
1511      * - `from` and `to` are never both zero.
1512      */
1513     function _beforeTokenTransfers(
1514         address from,
1515         address to,
1516         uint256 startTokenId,
1517         uint256 quantity
1518     ) internal virtual {}
1519 
1520     /**
1521      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1522      * minting.
1523      * And also called after one token has been burned.
1524      *
1525      * startTokenId - the first token id to be transferred
1526      * quantity - the amount to be transferred
1527      *
1528      * Calling conditions:
1529      *
1530      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1531      * transferred to `to`.
1532      * - When `from` is zero, `tokenId` has been minted for `to`.
1533      * - When `to` is zero, `tokenId` has been burned by `from`.
1534      * - `from` and `to` are never both zero.
1535      */
1536     function _afterTokenTransfers(
1537         address from,
1538         address to,
1539         uint256 startTokenId,
1540         uint256 quantity
1541     ) internal virtual {}
1542 }
1543 
1544 // File: contracts/Tejiverse.sol
1545 
1546 
1547 pragma solidity 0.8.11;
1548 
1549 
1550 
1551 
1552 
1553 /*   _____    _ _                           */
1554 /*  |_   _|  (_|_)                          */
1555 /*    | | ___ _ ___   _____ _ __ ___  ___   */
1556 /*    | |/ _ \ | \ \ / / _ \ '__/ __|/ _ \  */
1557 /*    | |  __/ | |\ V /  __/ |  \__ \  __/  */
1558 /*    \_/\___| |_| \_/ \___|_|  |___/\___|  */
1559 /*          _/ |                            */
1560 /*         |__/                             */
1561 
1562 /// @title Tejiverse
1563 /// @author naomsa <https://twitter.com/naomsa666>
1564 /// @author Teji <https://twitter.com/0xTeji>
1565 contract Tejiverse is Ownable, ERC721A {
1566   using Strings for uint256;
1567   using ECDSA for bytes32;
1568 
1569   /* -------------------------------------------------------------------------- */
1570   /*                              Metadata Details                              */
1571   /* -------------------------------------------------------------------------- */
1572 
1573   /// @notice Unrevealed metadata URI.
1574   string public unrevealedURI;
1575 
1576   /// @notice Metadata base URI.
1577   string public baseURI;
1578 
1579   /* -------------------------------------------------------------------------- */
1580   /*                             Marketplace Details                            */
1581   /* -------------------------------------------------------------------------- */
1582 
1583   /// @notice OpenSea proxy registry.
1584   address public opensea;
1585 
1586   /// @notice LooksRare marketplace transfer manager.
1587   address public looksrare;
1588 
1589   /// @notice Check if marketplaces pre-approve is enabled.
1590   bool public marketplacesApproved;
1591 
1592   /* -------------------------------------------------------------------------- */
1593   /*                                Sale Details                                */
1594   /* -------------------------------------------------------------------------- */
1595 
1596   /// @notice Whitelist verified signer address.
1597   address public signer;
1598 
1599   /// @notice 0 = CLOSED, 1 = WHITELIST, 2 = PUBLIC.
1600   uint256 public saleState;
1601 
1602   /// @notice address => has minted on presale.
1603   mapping(address => bool) internal _boughtPresale;
1604 
1605   constructor(string memory newUnrevealedURI, address newSigner) ERC721A("Tejiverse", "TEJI") {
1606     unrevealedURI = newUnrevealedURI;
1607     signer = newSigner;
1608 
1609     marketplacesApproved = true;
1610     opensea = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1611     looksrare = 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e;
1612   }
1613 
1614   /* -------------------------------------------------------------------------- */
1615   /*                                 Sale Logic                                 */
1616   /* -------------------------------------------------------------------------- */
1617 
1618   /// @notice Claim one teji.
1619   function claim() external {
1620     require(_currentIndex < 1000, "Tejiverse: max supply exceeded");
1621     if (msg.sender != owner()) {
1622       require(saleState == 2, "Tejiverse: public sale is not open");
1623     }
1624 
1625     _safeMint(msg.sender, 1);
1626   }
1627 
1628   /// @notice Claim one teji with whitelist proof.
1629   /// @param signature Whitelist proof signature.
1630   function claimWhitelist(bytes memory signature) external {
1631     require(_currentIndex < 1000, "Tejiverse: max supply exceeded");
1632     require(saleState == 1, "Tejiverse: whitelist sale is not open");
1633     require(!_boughtPresale[msg.sender], "Tejiverse: already claimed");
1634 
1635     bytes32 digest = keccak256(abi.encodePacked(address(this), msg.sender));
1636     require(digest.toEthSignedMessageHash().recover(signature) == signer, "Tejiverse: invalid signature");
1637 
1638     _boughtPresale[msg.sender] = true;
1639     _safeMint(msg.sender, 1);
1640   }
1641 
1642   /* -------------------------------------------------------------------------- */
1643   /*                                 Owner Logic                                */
1644   /* -------------------------------------------------------------------------- */
1645 
1646   /// @notice Set unrevealedURI to `newUnrevealedURI`.
1647   /// @param newUnrevealedURI New unrevealed uri.
1648   function setUnrevealedURI(string memory newUnrevealedURI) external onlyOwner {
1649     unrevealedURI = newUnrevealedURI;
1650   }
1651 
1652   /// @notice Set baseURI to `newBaseURI`.
1653   /// @param newBaseURI New base uri.
1654   function setBaseURI(string memory newBaseURI) external onlyOwner {
1655     baseURI = newBaseURI;
1656     delete unrevealedURI;
1657   }
1658 
1659   /// @notice Set `saleState` to `newSaleState`.
1660   /// @param newSaleState New sale state.
1661   function setSaleState(uint256 newSaleState) external onlyOwner {
1662     saleState = newSaleState;
1663   }
1664 
1665   /// @notice Set `signer` to `newSigner`.
1666   /// @param newSigner New whitelist signer address.
1667   function setSigner(address newSigner) external onlyOwner {
1668     signer = newSigner;
1669   }
1670 
1671   /// @notice Set `opensea` to `newOpensea` and `looksrare` to `newLooksrare`.
1672   /// @param newOpensea Opensea's proxy registry contract address.
1673   /// @param newLooksrare Looksrare's transfer manager contract address.
1674   function setMarketplaces(address newOpensea, address newLooksrare) external onlyOwner {
1675     opensea = newOpensea;
1676     looksrare = newLooksrare;
1677   }
1678 
1679   /// @notice Toggle pre-approve feature state for sender.
1680   function toggleMarketplacesApproved() external onlyOwner {
1681     marketplacesApproved = !marketplacesApproved;
1682   }
1683 
1684   /* -------------------------------------------------------------------------- */
1685   /*                                ERC-721 Logic                               */
1686   /* -------------------------------------------------------------------------- */
1687 
1688   /// @notice See {ERC721-tokenURI}.
1689   function tokenURI(uint256 id) public view override returns (string memory) {
1690     require(_exists(id), "ERC721Metadata: query for nonexisting token");
1691 
1692     if (bytes(unrevealedURI).length > 0) return unrevealedURI;
1693     return string(abi.encodePacked(baseURI, id.toString()));
1694   }
1695 
1696   /// @notice See {ERC721-isApprovedForAll}.
1697   /// @dev Modified for opensea and looksrare pre-approve so users can make truly gasless sales.
1698   function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1699     if (!marketplacesApproved) return super.isApprovedForAll(owner, operator);
1700 
1701     return
1702       operator == address(ProxyRegistry(opensea).proxies(owner)) ||
1703       operator == looksrare ||
1704       super.isApprovedForAll(owner, operator);
1705   }
1706 }
1707 
1708 contract OwnableDelegateProxy {}
1709 
1710 contract ProxyRegistry {
1711   mapping(address => OwnableDelegateProxy) public proxies;
1712 }