1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 }
71 
72 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 
80 /**
81  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
82  *
83  * These functions can be used to verify that a message was signed by the holder
84  * of the private keys of a given address.
85  */
86 library ECDSA {
87     enum RecoverError {
88         NoError,
89         InvalidSignature,
90         InvalidSignatureLength,
91         InvalidSignatureS,
92         InvalidSignatureV
93     }
94 
95     function _throwError(RecoverError error) private pure {
96         if (error == RecoverError.NoError) {
97             return; // no error: do nothing
98         } else if (error == RecoverError.InvalidSignature) {
99             revert("ECDSA: invalid signature");
100         } else if (error == RecoverError.InvalidSignatureLength) {
101             revert("ECDSA: invalid signature length");
102         } else if (error == RecoverError.InvalidSignatureS) {
103             revert("ECDSA: invalid signature 's' value");
104         } else if (error == RecoverError.InvalidSignatureV) {
105             revert("ECDSA: invalid signature 'v' value");
106         }
107     }
108 
109     /**
110      * @dev Returns the address that signed a hashed message (`hash`) with
111      * `signature` or error string. This address can then be used for verification purposes.
112      *
113      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
114      * this function rejects them by requiring the `s` value to be in the lower
115      * half order, and the `v` value to be either 27 or 28.
116      *
117      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
118      * verification to be secure: it is possible to craft signatures that
119      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
120      * this is by receiving a hash of the original message (which may otherwise
121      * be too long), and then calling {toEthSignedMessageHash} on it.
122      *
123      * Documentation for signature generation:
124      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
125      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
126      *
127      * _Available since v4.3._
128      */
129     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
130         // Check the signature length
131         // - case 65: r,s,v signature (standard)
132         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
133         if (signature.length == 65) {
134             bytes32 r;
135             bytes32 s;
136             uint8 v;
137             // ecrecover takes the signature parameters, and the only way to get them
138             // currently is to use assembly.
139             assembly {
140                 r := mload(add(signature, 0x20))
141                 s := mload(add(signature, 0x40))
142                 v := byte(0, mload(add(signature, 0x60)))
143             }
144             return tryRecover(hash, v, r, s);
145         } else if (signature.length == 64) {
146             bytes32 r;
147             bytes32 vs;
148             // ecrecover takes the signature parameters, and the only way to get them
149             // currently is to use assembly.
150             assembly {
151                 r := mload(add(signature, 0x20))
152                 vs := mload(add(signature, 0x40))
153             }
154             return tryRecover(hash, r, vs);
155         } else {
156             return (address(0), RecoverError.InvalidSignatureLength);
157         }
158     }
159 
160     /**
161      * @dev Returns the address that signed a hashed message (`hash`) with
162      * `signature`. This address can then be used for verification purposes.
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
173      */
174     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
175         (address recovered, RecoverError error) = tryRecover(hash, signature);
176         _throwError(error);
177         return recovered;
178     }
179 
180     /**
181      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
182      *
183      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
184      *
185      * _Available since v4.3._
186      */
187     function tryRecover(
188         bytes32 hash,
189         bytes32 r,
190         bytes32 vs
191     ) internal pure returns (address, RecoverError) {
192         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
193         uint8 v = uint8((uint256(vs) >> 255) + 27);
194         return tryRecover(hash, v, r, s);
195     }
196 
197     /**
198      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
199      *
200      * _Available since v4.2._
201      */
202     function recover(
203         bytes32 hash,
204         bytes32 r,
205         bytes32 vs
206     ) internal pure returns (address) {
207         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
208         _throwError(error);
209         return recovered;
210     }
211 
212     /**
213      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
214      * `r` and `s` signature fields separately.
215      *
216      * _Available since v4.3._
217      */
218     function tryRecover(
219         bytes32 hash,
220         uint8 v,
221         bytes32 r,
222         bytes32 s
223     ) internal pure returns (address, RecoverError) {
224         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
225         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
226         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
227         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
228         //
229         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
230         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
231         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
232         // these malleable signatures as well.
233         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
234             return (address(0), RecoverError.InvalidSignatureS);
235         }
236         if (v != 27 && v != 28) {
237             return (address(0), RecoverError.InvalidSignatureV);
238         }
239 
240         // If the signature is valid (and not malleable), return the signer address
241         address signer = ecrecover(hash, v, r, s);
242         if (signer == address(0)) {
243             return (address(0), RecoverError.InvalidSignature);
244         }
245 
246         return (signer, RecoverError.NoError);
247     }
248 
249     /**
250      * @dev Overload of {ECDSA-recover} that receives the `v`,
251      * `r` and `s` signature fields separately.
252      */
253     function recover(
254         bytes32 hash,
255         uint8 v,
256         bytes32 r,
257         bytes32 s
258     ) internal pure returns (address) {
259         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
260         _throwError(error);
261         return recovered;
262     }
263 
264     /**
265      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
266      * produces hash corresponding to the one signed with the
267      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
268      * JSON-RPC method as part of EIP-191.
269      *
270      * See {recover}.
271      */
272     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
273         // 32 is the length in bytes of hash,
274         // enforced by the type signature above
275         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
276     }
277 
278     /**
279      * @dev Returns an Ethereum Signed Message, created from `s`. This
280      * produces hash corresponding to the one signed with the
281      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
282      * JSON-RPC method as part of EIP-191.
283      *
284      * See {recover}.
285      */
286     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
287         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
288     }
289 
290     /**
291      * @dev Returns an Ethereum Signed Typed Data, created from a
292      * `domainSeparator` and a `structHash`. This produces hash corresponding
293      * to the one signed with the
294      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
295      * JSON-RPC method as part of EIP-712.
296      *
297      * See {recover}.
298      */
299     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
300         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
301     }
302 }
303 
304 // File: @openzeppelin/contracts/utils/Context.sol
305 
306 
307 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Provides information about the current execution context, including the
313  * sender of the transaction and its data. While these are generally available
314  * via msg.sender and msg.data, they should not be accessed in such a direct
315  * manner, since when dealing with meta-transactions the account sending and
316  * paying for execution may not be the actual sender (as far as an application
317  * is concerned).
318  *
319  * This contract is only required for intermediate, library-like contracts.
320  */
321 abstract contract Context {
322     function _msgSender() internal view virtual returns (address) {
323         return msg.sender;
324     }
325 
326     function _msgData() internal view virtual returns (bytes calldata) {
327         return msg.data;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/access/Ownable.sol
332 
333 
334 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
335 
336 pragma solidity ^0.8.0;
337 
338 
339 /**
340  * @dev Contract module which provides a basic access control mechanism, where
341  * there is an account (an owner) that can be granted exclusive access to
342  * specific functions.
343  *
344  * By default, the owner account will be the one that deploys the contract. This
345  * can later be changed with {transferOwnership}.
346  *
347  * This module is used through inheritance. It will make available the modifier
348  * `onlyOwner`, which can be applied to your functions to restrict their use to
349  * the owner.
350  */
351 abstract contract Ownable is Context {
352     address private _owner;
353 
354     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
355 
356     /**
357      * @dev Initializes the contract setting the deployer as the initial owner.
358      */
359     constructor() {
360         _transferOwnership(_msgSender());
361     }
362 
363     /**
364      * @dev Returns the address of the current owner.
365      */
366     function owner() public view virtual returns (address) {
367         return _owner;
368     }
369 
370     /**
371      * @dev Throws if called by any account other than the owner.
372      */
373     modifier onlyOwner() {
374         require(owner() == _msgSender(), "Ownable: caller is not the owner");
375         _;
376     }
377 
378     /**
379      * @dev Leaves the contract without owner. It will not be possible to call
380      * `onlyOwner` functions anymore. Can only be called by the current owner.
381      *
382      * NOTE: Renouncing ownership will leave the contract without an owner,
383      * thereby removing any functionality that is only available to the owner.
384      */
385     function renounceOwnership() public virtual onlyOwner {
386         _transferOwnership(address(0));
387     }
388 
389     /**
390      * @dev Transfers ownership of the contract to a new account (`newOwner`).
391      * Can only be called by the current owner.
392      */
393     function transferOwnership(address newOwner) public virtual onlyOwner {
394         require(newOwner != address(0), "Ownable: new owner is the zero address");
395         _transferOwnership(newOwner);
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Internal function without access restriction.
401      */
402     function _transferOwnership(address newOwner) internal virtual {
403         address oldOwner = _owner;
404         _owner = newOwner;
405         emit OwnershipTransferred(oldOwner, newOwner);
406     }
407 }
408 
409 // File: @openzeppelin/contracts/utils/Address.sol
410 
411 
412 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
413 
414 pragma solidity ^0.8.1;
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      *
437      * [IMPORTANT]
438      * ====
439      * You shouldn't rely on `isContract` to protect against flash loan attacks!
440      *
441      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
442      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
443      * constructor.
444      * ====
445      */
446     function isContract(address account) internal view returns (bool) {
447         // This method relies on extcodesize/address.code.length, which returns 0
448         // for contracts in construction, since the code is only stored at the end
449         // of the constructor execution.
450 
451         return account.code.length > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         (bool success, ) = recipient.call{value: amount}("");
474         require(success, "Address: unable to send value, recipient may have reverted");
475     }
476 
477     /**
478      * @dev Performs a Solidity function call using a low level `call`. A
479      * plain `call` is an unsafe replacement for a function call: use this
480      * function instead.
481      *
482      * If `target` reverts with a revert reason, it is bubbled up by this
483      * function (like regular Solidity function calls).
484      *
485      * Returns the raw returned data. To convert to the expected return value,
486      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
487      *
488      * Requirements:
489      *
490      * - `target` must be a contract.
491      * - calling `target` with `data` must not revert.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionCall(target, data, "Address: low-level call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
501      * `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, 0, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but also transferring `value` wei to `target`.
516      *
517      * Requirements:
518      *
519      * - the calling contract must have an ETH balance of at least `value`.
520      * - the called Solidity function must be `payable`.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(
525         address target,
526         bytes memory data,
527         uint256 value
528     ) internal returns (bytes memory) {
529         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
534      * with `errorMessage` as a fallback revert reason when `target` reverts.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(address(this).balance >= value, "Address: insufficient balance for call");
545         require(isContract(target), "Address: call to non-contract");
546 
547         (bool success, bytes memory returndata) = target.call{value: value}(data);
548         return verifyCallResult(success, returndata, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
558         return functionStaticCall(target, data, "Address: low-level static call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
563      * but performing a static call.
564      *
565      * _Available since v3.3._
566      */
567     function functionStaticCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal view returns (bytes memory) {
572         require(isContract(target), "Address: static call to non-contract");
573 
574         (bool success, bytes memory returndata) = target.staticcall(data);
575         return verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
585         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a delegate call.
591      *
592      * _Available since v3.4._
593      */
594     function functionDelegateCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal returns (bytes memory) {
599         require(isContract(target), "Address: delegate call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.delegatecall(data);
602         return verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
607      * revert reason using the provided one.
608      *
609      * _Available since v4.3._
610      */
611     function verifyCallResult(
612         bool success,
613         bytes memory returndata,
614         string memory errorMessage
615     ) internal pure returns (bytes memory) {
616         if (success) {
617             return returndata;
618         } else {
619             // Look for revert reason and bubble it up if present
620             if (returndata.length > 0) {
621                 // The easiest way to bubble the revert reason is using memory via assembly
622 
623                 assembly {
624                     let returndata_size := mload(returndata)
625                     revert(add(32, returndata), returndata_size)
626                 }
627             } else {
628                 revert(errorMessage);
629             }
630         }
631     }
632 }
633 
634 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 /**
642  * @title ERC721 token receiver interface
643  * @dev Interface for any contract that wants to support safeTransfers
644  * from ERC721 asset contracts.
645  */
646 interface IERC721Receiver {
647     /**
648      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
649      * by `operator` from `from`, this function is called.
650      *
651      * It must return its Solidity selector to confirm the token transfer.
652      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
653      *
654      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
655      */
656     function onERC721Received(
657         address operator,
658         address from,
659         uint256 tokenId,
660         bytes calldata data
661     ) external returns (bytes4);
662 }
663 
664 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Interface of the ERC165 standard, as defined in the
673  * https://eips.ethereum.org/EIPS/eip-165[EIP].
674  *
675  * Implementers can declare support of contract interfaces, which can then be
676  * queried by others ({ERC165Checker}).
677  *
678  * For an implementation, see {ERC165}.
679  */
680 interface IERC165 {
681     /**
682      * @dev Returns true if this contract implements the interface defined by
683      * `interfaceId`. See the corresponding
684      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
685      * to learn more about how these ids are created.
686      *
687      * This function call must use less than 30 000 gas.
688      */
689     function supportsInterface(bytes4 interfaceId) external view returns (bool);
690 }
691 
692 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
693 
694 
695 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 /**
701  * @dev Implementation of the {IERC165} interface.
702  *
703  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
704  * for the additional interface id that will be supported. For example:
705  *
706  * ```solidity
707  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
708  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
709  * }
710  * ```
711  *
712  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
713  */
714 abstract contract ERC165 is IERC165 {
715     /**
716      * @dev See {IERC165-supportsInterface}.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719         return interfaceId == type(IERC165).interfaceId;
720     }
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 
731 /**
732  * @dev Required interface of an ERC721 compliant contract.
733  */
734 interface IERC721 is IERC165 {
735     /**
736      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
737      */
738     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
739 
740     /**
741      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
742      */
743     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
744 
745     /**
746      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
747      */
748     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
749 
750     /**
751      * @dev Returns the number of tokens in ``owner``'s account.
752      */
753     function balanceOf(address owner) external view returns (uint256 balance);
754 
755     /**
756      * @dev Returns the owner of the `tokenId` token.
757      *
758      * Requirements:
759      *
760      * - `tokenId` must exist.
761      */
762     function ownerOf(uint256 tokenId) external view returns (address owner);
763 
764     /**
765      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
766      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
767      *
768      * Requirements:
769      *
770      * - `from` cannot be the zero address.
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must exist and be owned by `from`.
773      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
775      *
776      * Emits a {Transfer} event.
777      */
778     function safeTransferFrom(
779         address from,
780         address to,
781         uint256 tokenId
782     ) external;
783 
784     /**
785      * @dev Transfers `tokenId` token from `from` to `to`.
786      *
787      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
788      *
789      * Requirements:
790      *
791      * - `from` cannot be the zero address.
792      * - `to` cannot be the zero address.
793      * - `tokenId` token must be owned by `from`.
794      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
795      *
796      * Emits a {Transfer} event.
797      */
798     function transferFrom(
799         address from,
800         address to,
801         uint256 tokenId
802     ) external;
803 
804     /**
805      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
806      * The approval is cleared when the token is transferred.
807      *
808      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
809      *
810      * Requirements:
811      *
812      * - The caller must own the token or be an approved operator.
813      * - `tokenId` must exist.
814      *
815      * Emits an {Approval} event.
816      */
817     function approve(address to, uint256 tokenId) external;
818 
819     /**
820      * @dev Returns the account approved for `tokenId` token.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must exist.
825      */
826     function getApproved(uint256 tokenId) external view returns (address operator);
827 
828     /**
829      * @dev Approve or remove `operator` as an operator for the caller.
830      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
831      *
832      * Requirements:
833      *
834      * - The `operator` cannot be the caller.
835      *
836      * Emits an {ApprovalForAll} event.
837      */
838     function setApprovalForAll(address operator, bool _approved) external;
839 
840     /**
841      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
842      *
843      * See {setApprovalForAll}
844      */
845     function isApprovedForAll(address owner, address operator) external view returns (bool);
846 
847     /**
848      * @dev Safely transfers `tokenId` token from `from` to `to`.
849      *
850      * Requirements:
851      *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854      * - `tokenId` token must exist and be owned by `from`.
855      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
856      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
857      *
858      * Emits a {Transfer} event.
859      */
860     function safeTransferFrom(
861         address from,
862         address to,
863         uint256 tokenId,
864         bytes calldata data
865     ) external;
866 }
867 
868 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
869 
870 
871 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 
876 /**
877  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
878  * @dev See https://eips.ethereum.org/EIPS/eip-721
879  */
880 interface IERC721Metadata is IERC721 {
881     /**
882      * @dev Returns the token collection name.
883      */
884     function name() external view returns (string memory);
885 
886     /**
887      * @dev Returns the token collection symbol.
888      */
889     function symbol() external view returns (string memory);
890 
891     /**
892      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
893      */
894     function tokenURI(uint256 tokenId) external view returns (string memory);
895 }
896 
897 // File: contracts/ERC721B.sol
898 
899 
900 
901 pragma solidity ^0.8.4;
902 
903 /********************
904 * @author: Squeebo *
905 ********************/
906 
907 
908 
909 
910 
911 
912 
913 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
914     using Address for address;
915 
916     // Token name
917     string private _name;
918 
919     // Token symbol
920     string private _symbol;
921 
922     // Mapping from token ID to owner address
923     address[] internal _owners;
924 
925     // Mapping from token ID to approved address
926     mapping(uint256 => address) private _tokenApprovals;
927 
928     // Mapping from owner to operator approvals
929     mapping(address => mapping(address => bool)) private _operatorApprovals;
930 
931     /**
932      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
933      */
934     constructor(string memory name_, string memory symbol_) {
935         _name = name_;
936         _symbol = symbol_;
937     }
938 
939     /**
940      * @dev See {IERC165-supportsInterface}.
941      */
942     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
943         return
944             interfaceId == type(IERC721).interfaceId ||
945             interfaceId == type(IERC721Metadata).interfaceId ||
946             super.supportsInterface(interfaceId);
947     }
948 
949     /**
950      * @dev See {IERC721-balanceOf}.
951      */
952     function balanceOf(address owner) public view virtual override returns (uint256) {
953         require(owner != address(0), "ERC721: balance query for the zero address");
954 
955         uint count = 0;
956         uint length = _owners.length;
957         for( uint i = 0; i < length; ++i ){
958           if( owner == _owners[i] ){
959             ++count;
960           }
961         }
962 
963         delete length;
964         return count;
965     }
966 
967     /**
968      * @dev See {IERC721-ownerOf}.
969      */
970     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
971         address owner = _owners[tokenId];
972         require(owner != address(0), "ERC721: owner query for nonexistent token");
973         return owner;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-name}.
978      */
979     function name() public view virtual override returns (string memory) {
980         return _name;
981     }
982 
983     /**
984      * @dev See {IERC721Metadata-symbol}.
985      */
986     function symbol() public view virtual override returns (string memory) {
987         return _symbol;
988     }
989 
990     /**
991      * @dev See {IERC721-approve}.
992      */
993     function approve(address to, uint256 tokenId) public virtual override {
994         address owner = ERC721B.ownerOf(tokenId);
995         require(to != owner, "ERC721: approval to current owner");
996 
997         require(
998             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
999             "ERC721: approve caller is not owner nor approved for all"
1000         );
1001 
1002         _approve(to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-getApproved}.
1007      */
1008     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1009         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1010 
1011         return _tokenApprovals[tokenId];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-setApprovalForAll}.
1016      */
1017     function setApprovalForAll(address operator, bool approved) public virtual override {
1018         require(operator != _msgSender(), "ERC721: approve to caller");
1019 
1020         _operatorApprovals[_msgSender()][operator] = approved;
1021         emit ApprovalForAll(_msgSender(), operator, approved);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-isApprovedForAll}.
1026      */
1027     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1028         return _operatorApprovals[owner][operator];
1029     }
1030 
1031 
1032     /**
1033      * @dev See {IERC721-transferFrom}.
1034      */
1035     function transferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         //solhint-disable-next-line max-line-length
1041         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1042 
1043         _transfer(from, to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-safeTransferFrom}.
1048      */
1049     function safeTransferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) public virtual override {
1054         safeTransferFrom(from, to, tokenId, "");
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-safeTransferFrom}.
1059      */
1060     function safeTransferFrom(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) public virtual override {
1066         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1067         _safeTransfer(from, to, tokenId, _data);
1068     }
1069 
1070     /**
1071      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1072      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1073      *
1074      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1075      *
1076      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1077      * implement alternative mechanisms to perform token transfer, such as signature-based.
1078      *
1079      * Requirements:
1080      *
1081      * - `from` cannot be the zero address.
1082      * - `to` cannot be the zero address.
1083      * - `tokenId` token must exist and be owned by `from`.
1084      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1085      *
1086      * Emits a {Transfer} event.
1087      */
1088     function _safeTransfer(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) internal virtual {
1094         _transfer(from, to, tokenId);
1095         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1096     }
1097 
1098     /**
1099      * @dev Returns whether `tokenId` exists.
1100      *
1101      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1102      *
1103      * Tokens start existing when they are minted (`_mint`),
1104      * and stop existing when they are burned (`_burn`).
1105      */
1106     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1107         return tokenId < _owners.length && _owners[tokenId] != address(0);
1108     }
1109 
1110     /**
1111      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1112      *
1113      * Requirements:
1114      *
1115      * - `tokenId` must exist.
1116      */
1117     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1118         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1119         address owner = ERC721B.ownerOf(tokenId);
1120         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1121     }
1122 
1123     /**
1124      * @dev Safely mints `tokenId` and transfers it to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `tokenId` must not exist.
1129      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _safeMint(address to, uint256 tokenId) internal virtual {
1134         _safeMint(to, tokenId, "");
1135     }
1136 
1137 
1138     /**
1139      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1140      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1141      */
1142     function _safeMint(
1143         address to,
1144         uint256 tokenId,
1145         bytes memory _data
1146     ) internal virtual {
1147         _mint(to, tokenId);
1148         require(
1149             _checkOnERC721Received(address(0), to, tokenId, _data),
1150             "ERC721: transfer to non ERC721Receiver implementer"
1151         );
1152     }
1153 
1154     /**
1155      * @dev Mints `tokenId` and transfers it to `to`.
1156      *
1157      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1158      *
1159      * Requirements:
1160      *
1161      * - `tokenId` must not exist.
1162      * - `to` cannot be the zero address.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _mint(address to, uint256 tokenId) internal virtual {
1167         require(to != address(0), "ERC721: mint to the zero address");
1168         require(!_exists(tokenId), "ERC721: token already minted");
1169 
1170         _beforeTokenTransfer(address(0), to, tokenId);
1171         _owners.push(to);
1172 
1173         emit Transfer(address(0), to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Destroys `tokenId`.
1178      * The approval is cleared when the token is burned.
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must exist.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _burn(uint256 tokenId) internal virtual {
1187         address owner = ERC721B.ownerOf(tokenId);
1188 
1189         _beforeTokenTransfer(owner, address(0), tokenId);
1190 
1191         // Clear approvals
1192         _approve(address(0), tokenId);
1193         _owners[tokenId] = address(0);
1194 
1195         emit Transfer(owner, address(0), tokenId);
1196     }
1197 
1198     /**
1199      * @dev Transfers `tokenId` from `from` to `to`.
1200      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1201      *
1202      * Requirements:
1203      *
1204      * - `to` cannot be the zero address.
1205      * - `tokenId` token must be owned by `from`.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _transfer(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) internal virtual {
1214         require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1215         require(to != address(0), "ERC721: transfer to the zero address");
1216 
1217         _beforeTokenTransfer(from, to, tokenId);
1218 
1219         // Clear approvals from the previous owner
1220         _approve(address(0), tokenId);
1221         _owners[tokenId] = to;
1222 
1223         emit Transfer(from, to, tokenId);
1224     }
1225 
1226     /**
1227      * @dev Approve `to` to operate on `tokenId`
1228      *
1229      * Emits a {Approval} event.
1230      */
1231     function _approve(address to, uint256 tokenId) internal virtual {
1232         _tokenApprovals[tokenId] = to;
1233         emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
1234     }
1235 
1236 
1237     /**
1238      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1239      * The call is not executed if the target address is not a contract.
1240      *
1241      * @param from address representing the previous owner of the given token ID
1242      * @param to target address that will receive the tokens
1243      * @param tokenId uint256 ID of the token to be transferred
1244      * @param _data bytes optional data to send along with the call
1245      * @return bool whether the call correctly returned the expected magic value
1246      */
1247     function _checkOnERC721Received(
1248         address from,
1249         address to,
1250         uint256 tokenId,
1251         bytes memory _data
1252     ) private returns (bool) {
1253         if (to.isContract()) {
1254             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1255                 return retval == IERC721Receiver.onERC721Received.selector;
1256             } catch (bytes memory reason) {
1257                 if (reason.length == 0) {
1258                     revert("ERC721: transfer to non ERC721Receiver implementer");
1259                 } else {
1260                     assembly {
1261                         revert(add(32, reason), mload(reason))
1262                     }
1263                 }
1264             }
1265         } else {
1266             return true;
1267         }
1268     }
1269 
1270     /**
1271      * @dev Hook that is called before any token transfer. This includes minting
1272      * and burning.
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` will be minted for `to`.
1279      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1280      * - `from` and `to` are never both zero.
1281      *
1282      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1283      */
1284     function _beforeTokenTransfer(
1285         address from,
1286         address to,
1287         uint256 tokenId
1288     ) internal virtual {}
1289 }
1290 // File: contracts/3dmutantmfers.sol
1291 
1292 
1293 
1294 pragma solidity ^0.8.4;
1295 
1296 /****************************************
1297  * @author: CryptoMoonHawk              *
1298  ****************************************/
1299 
1300 
1301 
1302 
1303 
1304 contract MutantMfers is Ownable, ERC721B {
1305   using Strings for uint;
1306 
1307   uint public MAX_SUPPLY     = 4444;
1308   uint public MAX_PER_WALLET = 1000;
1309 
1310   uint public price          = 0.029 ether;
1311   bool public isActive       = false;
1312   uint public maxOrder       = 20;
1313 
1314   // Mapping from token ID to owner address
1315   string[] public contract1ClaimedTokens;
1316   uint public contract1ClaimedTokensCount = 0;
1317 
1318   string[] public contract2ClaimedTokens;
1319   uint public contract2ClaimedTokensCount = 0;
1320 
1321   // Count of NFTs minted per wallet
1322   mapping(address => uint) public addressMintedBalance;
1323 
1324   // signer address for verification
1325   address public signerAddress;
1326 
1327   string private _baseTokenURI = 'ipfs://QmVTHEc3TC1wbAmWs2G2aeUerdehAQnBVRLMgxFFeLg8bn/';
1328   string private _tokenURISuffix = '';
1329 
1330   constructor()
1331     ERC721B("3DMutantMfers", "3DMM"){
1332       signerAddress = msg.sender;
1333   }
1334 
1335   function totalSupply() external view returns (uint) {
1336     uint supply = _owners.length;
1337     return supply;
1338   }
1339 
1340   function getContract1ClaimedTokensAsString() external view returns (string memory) {
1341     string memory claimedTokens = "";
1342     for (uint i = 0;i < contract1ClaimedTokensCount; i++) {
1343       claimedTokens = string(abi.encodePacked(claimedTokens, contract1ClaimedTokens[i], i < contract1ClaimedTokensCount - 1 ? "," : ""));
1344     }
1345     
1346     return claimedTokens;
1347   }
1348 
1349   function getContract2ClaimedTokensAsString() external view returns (string memory) {
1350     string memory claimedTokens = "";
1351     for (uint i = 0;i < contract2ClaimedTokensCount; i++) {
1352       claimedTokens = string(abi.encodePacked(claimedTokens, contract2ClaimedTokens[i], i < contract2ClaimedTokensCount - 1 ? "," : ""));
1353     }
1354     
1355     return claimedTokens;
1356   }
1357 
1358   //external
1359 
1360   fallback() external payable {}
1361 
1362   receive() external payable {}
1363 
1364   modifier mintCompliance( uint numberOfTokens ) {
1365     require( isActive,                            "Sale must be active to mint 3DMutantMfers" );
1366     require( numberOfTokens <= maxOrder,          "Can only mint 20 tokens at a time" );
1367     require( numberOfTokens > 0,                  "Token Mint Count must be > 0" );
1368 
1369     uint256 supply = _owners.length;
1370     require( supply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max supply of 3DMutantMfers" );
1371     
1372     uint256 mintedCount = addressMintedBalance[msg.sender];
1373     require(mintedCount + numberOfTokens <= MAX_PER_WALLET, "Max NFT per address exceeded");
1374 
1375     _;
1376   }
1377 
1378   function mint( uint numberOfTokens ) external payable mintCompliance( numberOfTokens ) {
1379     require( msg.value >= price * numberOfTokens, "Ether value sent is not correct" );
1380 
1381     _mintLoop( msg.sender, numberOfTokens );    
1382   }
1383 
1384   function verifySender(bytes memory signature, string[] memory contract1TokenIds, string[] memory contract2TokenIds) internal view returns (bool) {
1385 
1386     string memory contract1TokensString = "";
1387     string memory contract2TokensString = "";
1388 
1389     for (uint i = 0; i < contract1TokenIds.length; i++) {
1390       contract1TokensString = string(abi.encodePacked(contract1TokensString, contract1TokenIds[i], i < contract1TokenIds.length - 1 ? "," : ""));
1391     }
1392     
1393     for (uint i = 0; i < contract2TokenIds.length; i++) {
1394       contract2TokensString = string(abi.encodePacked(contract2TokensString, contract2TokenIds[i], i < contract2TokenIds.length - 1 ? "," : ""));
1395     }
1396 
1397     bytes32 hash = ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(msg.sender, contract1TokensString, contract2TokensString)));
1398     return ECDSA.recover(hash, signature) == signerAddress;
1399   }
1400 
1401   function freeClaimMint( uint numberOfTokens, bytes memory signature, string[] memory contract1TokenIds, string[] memory contract2TokenIds ) external mintCompliance( numberOfTokens ) {
1402     
1403     require(verifySender(signature, contract1TokenIds, contract2TokenIds), "Invalid Access");
1404 
1405     // Check to make sure there are token ids
1406     require(contract1TokenIds.length > 0 || contract2TokenIds.length > 0, "Empty Token IDs");
1407 
1408     uint totalTokenIds = contract1TokenIds.length + contract2TokenIds.length;
1409     require(totalTokenIds == numberOfTokens, "Token IDs and Mint Count mismatch");
1410 
1411     // Lets make sure we are not claiming for already claimed tokens of contract 1
1412     bool isValidTokenIds = true;
1413     for (uint i = 0; isValidTokenIds && i < contract1TokenIds.length; i++) {
1414       for (uint j = 0; isValidTokenIds && j < contract1ClaimedTokensCount; j++) {
1415         string memory contractClaimedToken = contract1ClaimedTokens[j];
1416         string memory tokenToClaim = contract1TokenIds[i];
1417 
1418         if (keccak256(bytes(tokenToClaim)) == keccak256(bytes(contractClaimedToken))) {
1419           isValidTokenIds = false;
1420         }
1421       } 
1422     } 
1423     require(isValidTokenIds, "Cosmo Creatures Token ID passed is already claimed");
1424 
1425     // Lets make sure we are not claiming for already claimed tokens of contract 2
1426     for (uint i = 0; isValidTokenIds && i < contract2TokenIds.length; i++) {
1427       for (uint j = 0; isValidTokenIds && j < contract2ClaimedTokensCount; j++) {
1428         string memory contractClaimedToken = contract2ClaimedTokens[j];
1429         string memory tokenToClaim = contract2TokenIds[i];
1430 
1431         if (keccak256(bytes(tokenToClaim)) == keccak256(bytes(contractClaimedToken))) {
1432           isValidTokenIds = false;
1433         }
1434       } 
1435     } 
1436     require(isValidTokenIds, "3D Mfrs Token ID passed is already claimed");
1437 
1438 
1439     for (uint i = 0; i < contract1TokenIds.length; i++) {
1440       contract1ClaimedTokensCount++;
1441       contract1ClaimedTokens.push(contract1TokenIds[i]);
1442     }
1443     
1444     for (uint i = 0; i < contract2TokenIds.length; i++) {
1445       contract2ClaimedTokensCount++;
1446       contract2ClaimedTokens.push(contract2TokenIds[i]);
1447     }
1448 
1449     _mintLoop( msg.sender, numberOfTokens );
1450   }
1451 
1452   function _mintLoop(address _receiver, uint256 numberOfTokens) internal {
1453     uint256 supply = _owners.length;
1454 
1455     for (uint256 i = 0; i < numberOfTokens; i++) {
1456       addressMintedBalance[_receiver]++;
1457       _safeMint( _receiver, supply++, "" );
1458     }
1459   }
1460 
1461   //delegated
1462   function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner {
1463     require(quantity.length == recipient.length, "Must provide equal quantity and recipient" );
1464 
1465     uint totalQuantity = 0;
1466     uint256 supply = _owners.length;
1467     for(uint i = 0; i < quantity.length; ++i){
1468       totalQuantity += quantity[i];
1469     }
1470     require( supply + totalQuantity <= MAX_SUPPLY, "Mint/order would exceed max supply of 3DMutantMfers" );
1471     delete totalQuantity;
1472 
1473     for(uint i = 0; i < recipient.length; ++i){
1474       _mintLoop(recipient[i], quantity[i]);
1475     }
1476   }
1477 
1478   function walletOfOwner(address _owner) external view returns (uint256[] memory) {
1479     uint256 ownerTokenCount = balanceOf(_owner);
1480     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1481     uint256 currentTokenId = 0;
1482     uint256 ownedTokenIndex = 0;
1483 
1484     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1485       address currentTokenOwner = ownerOf(currentTokenId);
1486 
1487       if (currentTokenOwner == _owner) {
1488         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1489         ownedTokenIndex++;
1490       }
1491 
1492       currentTokenId++;
1493     }
1494 
1495     return ownedTokenIds;
1496   }
1497 
1498   function setActive(bool isActive_) external onlyOwner {
1499     if( isActive != isActive_ )
1500       isActive = isActive_;
1501   }
1502 
1503   function setMaxOrder(uint maxOrder_) external onlyOwner {
1504     if( maxOrder != maxOrder_ )
1505       maxOrder = maxOrder_;
1506   }
1507 
1508   function setPrice(uint price_ ) external onlyOwner {
1509     if( price != price_ )
1510       price = price_;
1511   }
1512 
1513   function setBaseURI(string calldata _newBaseURI) external onlyOwner {
1514     _baseTokenURI = _newBaseURI;
1515   }
1516 
1517   //onlyOwner
1518   function setMaxSupply(uint maxSupply_ ) external onlyOwner {
1519     if( MAX_SUPPLY != maxSupply_ ){
1520       require(maxSupply_ >= _owners.length, "Specified supply is lower than current balance" );
1521       MAX_SUPPLY = maxSupply_;
1522     }
1523   }
1524 
1525   // Update Max Tokens A Wallet can mint
1526   function setMaxPerWallet(uint maxPerWallet_ ) external onlyOwner {
1527     if( MAX_PER_WALLET != maxPerWallet_ ){
1528       MAX_PER_WALLET = maxPerWallet_;
1529     }
1530   }
1531 
1532   function setSignerAddress(address _newSignerAddress) external onlyOwner {
1533     signerAddress = _newSignerAddress;
1534   }
1535 
1536   function withdraw(uint256 _percentWithdrawl) external onlyOwner {
1537       require(address(this).balance >= 0, "No funds available");
1538       require(_percentWithdrawl > 0 && _percentWithdrawl <= 100, "Withdrawl percent should be > 0 and <= 100");
1539 
1540       Address.sendValue(payable(owner()), (address(this).balance * _percentWithdrawl) / 100);
1541   }
1542 
1543   //public
1544   function tokenURI(uint tokenId) external view virtual override returns (string memory) {
1545     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1546     return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), _tokenURISuffix));
1547   }
1548 }