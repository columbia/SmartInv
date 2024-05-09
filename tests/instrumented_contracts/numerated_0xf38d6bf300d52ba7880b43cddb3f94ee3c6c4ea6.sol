1 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
7  *
8  * These functions can be used to verify that a message was signed by the holder
9  * of the private keys of a given address.
10  */
11 library ECDSA {
12     /**
13      * @dev Returns the address that signed a hashed message (`hash`) with
14      * `signature`. This address can then be used for verification purposes.
15      *
16      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
17      * this function rejects them by requiring the `s` value to be in the lower
18      * half order, and the `v` value to be either 27 or 28.
19      *
20      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
21      * verification to be secure: it is possible to craft signatures that
22      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
23      * this is by receiving a hash of the original message (which may otherwise
24      * be too long), and then calling {toEthSignedMessageHash} on it.
25      *
26      * Documentation for signature generation:
27      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
28      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
29      */
30     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
31         // Check the signature length
32         // - case 65: r,s,v signature (standard)
33         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
34         if (signature.length == 65) {
35             bytes32 r;
36             bytes32 s;
37             uint8 v;
38             // ecrecover takes the signature parameters, and the only way to get them
39             // currently is to use assembly.
40             assembly {
41                 r := mload(add(signature, 0x20))
42                 s := mload(add(signature, 0x40))
43                 v := byte(0, mload(add(signature, 0x60)))
44             }
45             return recover(hash, v, r, s);
46         } else if (signature.length == 64) {
47             bytes32 r;
48             bytes32 vs;
49             // ecrecover takes the signature parameters, and the only way to get them
50             // currently is to use assembly.
51             assembly {
52                 r := mload(add(signature, 0x20))
53                 vs := mload(add(signature, 0x40))
54             }
55             return recover(hash, r, vs);
56         } else {
57             revert("ECDSA: invalid signature length");
58         }
59     }
60 
61     /**
62      * @dev Overload of {ECDSA-recover} that receives the `r` and `vs` short-signature fields separately.
63      *
64      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
65      *
66      * _Available since v4.2._
67      */
68     function recover(
69         bytes32 hash,
70         bytes32 r,
71         bytes32 vs
72     ) internal pure returns (address) {
73         bytes32 s;
74         uint8 v;
75         assembly {
76             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
77             v := add(shr(255, vs), 27)
78         }
79         return recover(hash, v, r, s);
80     }
81 
82     /**
83      * @dev Overload of {ECDSA-recover} that receives the `v`, `r` and `s` signature fields separately.
84      */
85     function recover(
86         bytes32 hash,
87         uint8 v,
88         bytes32 r,
89         bytes32 s
90     ) internal pure returns (address) {
91         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
92         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
93         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
94         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
95         //
96         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
97         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
98         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
99         // these malleable signatures as well.
100         require(
101             uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0,
102             "ECDSA: invalid signature 's' value"
103         );
104         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
105 
106         // If the signature is valid (and not malleable), return the signer address
107         address signer = ecrecover(hash, v, r, s);
108         require(signer != address(0), "ECDSA: invalid signature");
109 
110         return signer;
111     }
112 
113     /**
114      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
115      * produces hash corresponding to the one signed with the
116      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
117      * JSON-RPC method as part of EIP-191.
118      *
119      * See {recover}.
120      */
121     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
122         // 32 is the length in bytes of hash,
123         // enforced by the type signature above
124         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
125     }
126 
127     /**
128      * @dev Returns an Ethereum Signed Typed Data, created from a
129      * `domainSeparator` and a `structHash`. This produces hash corresponding
130      * to the one signed with the
131      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
132      * JSON-RPC method as part of EIP-712.
133      *
134      * See {recover}.
135      */
136     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
137         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
142 
143 
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Interface of the ERC165 standard, as defined in the
149  * https://eips.ethereum.org/EIPS/eip-165[EIP].
150  *
151  * Implementers can declare support of contract interfaces, which can then be
152  * queried by others ({ERC165Checker}).
153  *
154  * For an implementation, see {ERC165}.
155  */
156 interface IERC165 {
157     /**
158      * @dev Returns true if this contract implements the interface defined by
159      * `interfaceId`. See the corresponding
160      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
161      * to learn more about how these ids are created.
162      *
163      * This function call must use less than 30 000 gas.
164      */
165     function supportsInterface(bytes4 interfaceId) external view returns (bool);
166 }
167 
168 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
169 
170 
171 
172 pragma solidity ^0.8.0;
173 
174 
175 /**
176  * @dev Required interface of an ERC721 compliant contract.
177  */
178 interface IERC721 is IERC165 {
179     /**
180      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
183 
184     /**
185      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
186      */
187     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
188 
189     /**
190      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
191      */
192     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
193 
194     /**
195      * @dev Returns the number of tokens in ``owner``'s account.
196      */
197     function balanceOf(address owner) external view returns (uint256 balance);
198 
199     /**
200      * @dev Returns the owner of the `tokenId` token.
201      *
202      * Requirements:
203      *
204      * - `tokenId` must exist.
205      */
206     function ownerOf(uint256 tokenId) external view returns (address owner);
207 
208     /**
209      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
210      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must exist and be owned by `from`.
217      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
218      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
219      *
220      * Emits a {Transfer} event.
221      */
222     function safeTransferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external;
227 
228     /**
229      * @dev Transfers `tokenId` token from `from` to `to`.
230      *
231      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(
243         address from,
244         address to,
245         uint256 tokenId
246     ) external;
247 
248     /**
249      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
250      * The approval is cleared when the token is transferred.
251      *
252      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
253      *
254      * Requirements:
255      *
256      * - The caller must own the token or be an approved operator.
257      * - `tokenId` must exist.
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address to, uint256 tokenId) external;
262 
263     /**
264      * @dev Returns the account approved for `tokenId` token.
265      *
266      * Requirements:
267      *
268      * - `tokenId` must exist.
269      */
270     function getApproved(uint256 tokenId) external view returns (address operator);
271 
272     /**
273      * @dev Approve or remove `operator` as an operator for the caller.
274      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
275      *
276      * Requirements:
277      *
278      * - The `operator` cannot be the caller.
279      *
280      * Emits an {ApprovalForAll} event.
281      */
282     function setApprovalForAll(address operator, bool _approved) external;
283 
284     /**
285      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
286      *
287      * See {setApprovalForAll}
288      */
289     function isApprovedForAll(address owner, address operator) external view returns (bool);
290 
291     /**
292      * @dev Safely transfers `tokenId` token from `from` to `to`.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `tokenId` token must exist and be owned by `from`.
299      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
300      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
301      *
302      * Emits a {Transfer} event.
303      */
304     function safeTransferFrom(
305         address from,
306         address to,
307         uint256 tokenId,
308         bytes calldata data
309     ) external;
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
313 
314 
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @title ERC721 token receiver interface
320  * @dev Interface for any contract that wants to support safeTransfers
321  * from ERC721 asset contracts.
322  */
323 interface IERC721Receiver {
324     /**
325      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
326      * by `operator` from `from`, this function is called.
327      *
328      * It must return its Solidity selector to confirm the token transfer.
329      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
330      *
331      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
332      */
333     function onERC721Received(
334         address operator,
335         address from,
336         uint256 tokenId,
337         bytes calldata data
338     ) external returns (bytes4);
339 }
340 
341 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
342 
343 
344 
345 pragma solidity ^0.8.0;
346 
347 
348 /**
349  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
350  * @dev See https://eips.ethereum.org/EIPS/eip-721
351  */
352 interface IERC721Metadata is IERC721 {
353     /**
354      * @dev Returns the token collection name.
355      */
356     function name() external view returns (string memory);
357 
358     /**
359      * @dev Returns the token collection symbol.
360      */
361     function symbol() external view returns (string memory);
362 
363     /**
364      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
365      */
366     function tokenURI(uint256 tokenId) external view returns (string memory);
367 }
368 
369 // File: @openzeppelin/contracts/utils/Address.sol
370 
371 
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Collection of functions related to the address type
377  */
378 library Address {
379     /**
380      * @dev Returns true if `account` is a contract.
381      *
382      * [IMPORTANT]
383      * ====
384      * It is unsafe to assume that an address for which this function returns
385      * false is an externally-owned account (EOA) and not a contract.
386      *
387      * Among others, `isContract` will return false for the following
388      * types of addresses:
389      *
390      *  - an externally-owned account
391      *  - a contract in construction
392      *  - an address where a contract will be created
393      *  - an address where a contract lived, but was destroyed
394      * ====
395      */
396     function isContract(address account) internal view returns (bool) {
397         // This method relies on extcodesize, which returns 0 for contracts in
398         // construction, since the code is only stored at the end of the
399         // constructor execution.
400 
401         uint256 size;
402         assembly {
403             size := extcodesize(account)
404         }
405         return size > 0;
406     }
407 
408     /**
409      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
410      * `recipient`, forwarding all available gas and reverting on errors.
411      *
412      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
413      * of certain opcodes, possibly making contracts go over the 2300 gas limit
414      * imposed by `transfer`, making them unable to receive funds via
415      * `transfer`. {sendValue} removes this limitation.
416      *
417      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
418      *
419      * IMPORTANT: because control is transferred to `recipient`, care must be
420      * taken to not create reentrancy vulnerabilities. Consider using
421      * {ReentrancyGuard} or the
422      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
423      */
424     function sendValue(address payable recipient, uint256 amount) internal {
425         require(address(this).balance >= amount, "Address: insufficient balance");
426 
427         (bool success, ) = recipient.call{value: amount}("");
428         require(success, "Address: unable to send value, recipient may have reverted");
429     }
430 
431     /**
432      * @dev Performs a Solidity function call using a low level `call`. A
433      * plain `call` is an unsafe replacement for a function call: use this
434      * function instead.
435      *
436      * If `target` reverts with a revert reason, it is bubbled up by this
437      * function (like regular Solidity function calls).
438      *
439      * Returns the raw returned data. To convert to the expected return value,
440      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
441      *
442      * Requirements:
443      *
444      * - `target` must be a contract.
445      * - calling `target` with `data` must not revert.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
450         return functionCall(target, data, "Address: low-level call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
455      * `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         return functionCallWithValue(target, data, 0, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but also transferring `value` wei to `target`.
470      *
471      * Requirements:
472      *
473      * - the calling contract must have an ETH balance of at least `value`.
474      * - the called Solidity function must be `payable`.
475      *
476      * _Available since v3.1._
477      */
478     function functionCallWithValue(
479         address target,
480         bytes memory data,
481         uint256 value
482     ) internal returns (bytes memory) {
483         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
488      * with `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCallWithValue(
493         address target,
494         bytes memory data,
495         uint256 value,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         require(address(this).balance >= value, "Address: insufficient balance for call");
499         require(isContract(target), "Address: call to non-contract");
500 
501         (bool success, bytes memory returndata) = target.call{value: value}(data);
502         return _verifyCallResult(success, returndata, errorMessage);
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
507      * but performing a static call.
508      *
509      * _Available since v3.3._
510      */
511     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
512         return functionStaticCall(target, data, "Address: low-level static call failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(
522         address target,
523         bytes memory data,
524         string memory errorMessage
525     ) internal view returns (bytes memory) {
526         require(isContract(target), "Address: static call to non-contract");
527 
528         (bool success, bytes memory returndata) = target.staticcall(data);
529         return _verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a delegate call.
535      *
536      * _Available since v3.4._
537      */
538     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
539         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
544      * but performing a delegate call.
545      *
546      * _Available since v3.4._
547      */
548     function functionDelegateCall(
549         address target,
550         bytes memory data,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         require(isContract(target), "Address: delegate call to non-contract");
554 
555         (bool success, bytes memory returndata) = target.delegatecall(data);
556         return _verifyCallResult(success, returndata, errorMessage);
557     }
558 
559     function _verifyCallResult(
560         bool success,
561         bytes memory returndata,
562         string memory errorMessage
563     ) private pure returns (bytes memory) {
564         if (success) {
565             return returndata;
566         } else {
567             // Look for revert reason and bubble it up if present
568             if (returndata.length > 0) {
569                 // The easiest way to bubble the revert reason is using memory via assembly
570 
571                 assembly {
572                     let returndata_size := mload(returndata)
573                     revert(add(32, returndata), returndata_size)
574                 }
575             } else {
576                 revert(errorMessage);
577             }
578         }
579     }
580 }
581 
582 // File: @openzeppelin/contracts/utils/Context.sol
583 
584 
585 
586 pragma solidity ^0.8.0;
587 
588 /*
589  * @dev Provides information about the current execution context, including the
590  * sender of the transaction and its data. While these are generally available
591  * via msg.sender and msg.data, they should not be accessed in such a direct
592  * manner, since when dealing with meta-transactions the account sending and
593  * paying for execution may not be the actual sender (as far as an application
594  * is concerned).
595  *
596  * This contract is only required for intermediate, library-like contracts.
597  */
598 abstract contract Context {
599     function _msgSender() internal view virtual returns (address) {
600         return msg.sender;
601     }
602 
603     function _msgData() internal view virtual returns (bytes calldata) {
604         return msg.data;
605     }
606 }
607 
608 // File: @openzeppelin/contracts/utils/Strings.sol
609 
610 
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev String operations.
616  */
617 library Strings {
618     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
619 
620     /**
621      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
622      */
623     function toString(uint256 value) internal pure returns (string memory) {
624         // Inspired by OraclizeAPI's implementation - MIT licence
625         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
626 
627         if (value == 0) {
628             return "0";
629         }
630         uint256 temp = value;
631         uint256 digits;
632         while (temp != 0) {
633             digits++;
634             temp /= 10;
635         }
636         bytes memory buffer = new bytes(digits);
637         while (value != 0) {
638             digits -= 1;
639             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
640             value /= 10;
641         }
642         return string(buffer);
643     }
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
647      */
648     function toHexString(uint256 value) internal pure returns (string memory) {
649         if (value == 0) {
650             return "0x00";
651         }
652         uint256 temp = value;
653         uint256 length = 0;
654         while (temp != 0) {
655             length++;
656             temp >>= 8;
657         }
658         return toHexString(value, length);
659     }
660 
661     /**
662      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
663      */
664     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
665         bytes memory buffer = new bytes(2 * length + 2);
666         buffer[0] = "0";
667         buffer[1] = "x";
668         for (uint256 i = 2 * length + 1; i > 1; --i) {
669             buffer[i] = _HEX_SYMBOLS[value & 0xf];
670             value >>= 4;
671         }
672         require(value == 0, "Strings: hex length insufficient");
673         return string(buffer);
674     }
675 }
676 
677 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
678 
679 
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @dev Implementation of the {IERC165} interface.
686  *
687  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
688  * for the additional interface id that will be supported. For example:
689  *
690  * ```solidity
691  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
693  * }
694  * ```
695  *
696  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
697  */
698 abstract contract ERC165 is IERC165 {
699     /**
700      * @dev See {IERC165-supportsInterface}.
701      */
702     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
703         return interfaceId == type(IERC165).interfaceId;
704     }
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
708 
709 
710 
711 pragma solidity ^0.8.0;
712 
713 
714 
715 
716 
717 
718 
719 
720 /**
721  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
722  * the Metadata extension, but not including the Enumerable extension, which is available separately as
723  * {ERC721Enumerable}.
724  */
725 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
726     using Address for address;
727     using Strings for uint256;
728 
729     // Token name
730     string private _name;
731 
732     // Token symbol
733     string private _symbol;
734 
735     // Mapping from token ID to owner address
736     mapping(uint256 => address) private _owners;
737 
738     // Mapping owner address to token count
739     mapping(address => uint256) private _balances;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     /**
748      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
749      */
750     constructor(string memory name_, string memory symbol_) {
751         _name = name_;
752         _symbol = symbol_;
753     }
754 
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
759         return
760             interfaceId == type(IERC721).interfaceId ||
761             interfaceId == type(IERC721Metadata).interfaceId ||
762             super.supportsInterface(interfaceId);
763     }
764 
765     /**
766      * @dev See {IERC721-balanceOf}.
767      */
768     function balanceOf(address owner) public view virtual override returns (uint256) {
769         require(owner != address(0), "ERC721: balance query for the zero address");
770         return _balances[owner];
771     }
772 
773     /**
774      * @dev See {IERC721-ownerOf}.
775      */
776     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
777         address owner = _owners[tokenId];
778         require(owner != address(0), "ERC721: owner query for nonexistent token");
779         return owner;
780     }
781 
782     /**
783      * @dev See {IERC721Metadata-name}.
784      */
785     function name() public view virtual override returns (string memory) {
786         return _name;
787     }
788 
789     /**
790      * @dev See {IERC721Metadata-symbol}.
791      */
792     function symbol() public view virtual override returns (string memory) {
793         return _symbol;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-tokenURI}.
798      */
799     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
800         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
801 
802         string memory baseURI = _baseURI();
803         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
804     }
805 
806     /**
807      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
808      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
809      * by default, can be overriden in child contracts.
810      */
811     function _baseURI() internal view virtual returns (string memory) {
812         return "";
813     }
814 
815     /**
816      * @dev See {IERC721-approve}.
817      */
818     function approve(address to, uint256 tokenId) public virtual override {
819         address owner = ERC721.ownerOf(tokenId);
820         require(to != owner, "ERC721: approval to current owner");
821 
822         require(
823             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
824             "ERC721: approve caller is not owner nor approved for all"
825         );
826 
827         _approve(to, tokenId);
828     }
829 
830     /**
831      * @dev See {IERC721-getApproved}.
832      */
833     function getApproved(uint256 tokenId) public view virtual override returns (address) {
834         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
835 
836         return _tokenApprovals[tokenId];
837     }
838 
839     /**
840      * @dev See {IERC721-setApprovalForAll}.
841      */
842     function setApprovalForAll(address operator, bool approved) public virtual override {
843         require(operator != _msgSender(), "ERC721: approve to caller");
844 
845         _operatorApprovals[_msgSender()][operator] = approved;
846         emit ApprovalForAll(_msgSender(), operator, approved);
847     }
848 
849     /**
850      * @dev See {IERC721-isApprovedForAll}.
851      */
852     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
853         return _operatorApprovals[owner][operator];
854     }
855 
856     /**
857      * @dev See {IERC721-transferFrom}.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) public virtual override {
864         //solhint-disable-next-line max-line-length
865         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
866 
867         _transfer(from, to, tokenId);
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId
877     ) public virtual override {
878         safeTransferFrom(from, to, tokenId, "");
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId,
888         bytes memory _data
889     ) public virtual override {
890         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
891         _safeTransfer(from, to, tokenId, _data);
892     }
893 
894     /**
895      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
896      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
897      *
898      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
899      *
900      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
901      * implement alternative mechanisms to perform token transfer, such as signature-based.
902      *
903      * Requirements:
904      *
905      * - `from` cannot be the zero address.
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must exist and be owned by `from`.
908      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _safeTransfer(
913         address from,
914         address to,
915         uint256 tokenId,
916         bytes memory _data
917     ) internal virtual {
918         _transfer(from, to, tokenId);
919         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
920     }
921 
922     /**
923      * @dev Returns whether `tokenId` exists.
924      *
925      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
926      *
927      * Tokens start existing when they are minted (`_mint`),
928      * and stop existing when they are burned (`_burn`).
929      */
930     function _exists(uint256 tokenId) internal view virtual returns (bool) {
931         return _owners[tokenId] != address(0);
932     }
933 
934     /**
935      * @dev Returns whether `spender` is allowed to manage `tokenId`.
936      *
937      * Requirements:
938      *
939      * - `tokenId` must exist.
940      */
941     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
942         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
943         address owner = ERC721.ownerOf(tokenId);
944         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
945     }
946 
947     /**
948      * @dev Safely mints `tokenId` and transfers it to `to`.
949      *
950      * Requirements:
951      *
952      * - `tokenId` must not exist.
953      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _safeMint(address to, uint256 tokenId) internal virtual {
958         _safeMint(to, tokenId, "");
959     }
960 
961     /**
962      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
963      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
964      */
965     function _safeMint(
966         address to,
967         uint256 tokenId,
968         bytes memory _data
969     ) internal virtual {
970         _mint(to, tokenId);
971         require(
972             _checkOnERC721Received(address(0), to, tokenId, _data),
973             "ERC721: transfer to non ERC721Receiver implementer"
974         );
975     }
976 
977     /**
978      * @dev Mints `tokenId` and transfers it to `to`.
979      *
980      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
981      *
982      * Requirements:
983      *
984      * - `tokenId` must not exist.
985      * - `to` cannot be the zero address.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _mint(address to, uint256 tokenId) internal virtual {
990         require(to != address(0), "ERC721: mint to the zero address");
991         require(!_exists(tokenId), "ERC721: token already minted");
992 
993         _beforeTokenTransfer(address(0), to, tokenId);
994 
995         _balances[to] += 1;
996         _owners[tokenId] = to;
997 
998         emit Transfer(address(0), to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Destroys `tokenId`.
1003      * The approval is cleared when the token is burned.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must exist.
1008      *
1009      * Emits a {Transfer} event.
1010      */
1011     function _burn(uint256 tokenId) internal virtual {
1012         address owner = ERC721.ownerOf(tokenId);
1013 
1014         _beforeTokenTransfer(owner, address(0), tokenId);
1015 
1016         // Clear approvals
1017         _approve(address(0), tokenId);
1018 
1019         _balances[owner] -= 1;
1020         delete _owners[tokenId];
1021 
1022         emit Transfer(owner, address(0), tokenId);
1023     }
1024 
1025     /**
1026      * @dev Transfers `tokenId` from `from` to `to`.
1027      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1028      *
1029      * Requirements:
1030      *
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must be owned by `from`.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 tokenId
1040     ) internal virtual {
1041         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1042         require(to != address(0), "ERC721: transfer to the zero address");
1043 
1044         _beforeTokenTransfer(from, to, tokenId);
1045 
1046         // Clear approvals from the previous owner
1047         _approve(address(0), tokenId);
1048 
1049         _balances[from] -= 1;
1050         _balances[to] += 1;
1051         _owners[tokenId] = to;
1052 
1053         emit Transfer(from, to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Approve `to` to operate on `tokenId`
1058      *
1059      * Emits a {Approval} event.
1060      */
1061     function _approve(address to, uint256 tokenId) internal virtual {
1062         _tokenApprovals[tokenId] = to;
1063         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1068      * The call is not executed if the target address is not a contract.
1069      *
1070      * @param from address representing the previous owner of the given token ID
1071      * @param to target address that will receive the tokens
1072      * @param tokenId uint256 ID of the token to be transferred
1073      * @param _data bytes optional data to send along with the call
1074      * @return bool whether the call correctly returned the expected magic value
1075      */
1076     function _checkOnERC721Received(
1077         address from,
1078         address to,
1079         uint256 tokenId,
1080         bytes memory _data
1081     ) private returns (bool) {
1082         if (to.isContract()) {
1083             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1084                 return retval == IERC721Receiver(to).onERC721Received.selector;
1085             } catch (bytes memory reason) {
1086                 if (reason.length == 0) {
1087                     revert("ERC721: transfer to non ERC721Receiver implementer");
1088                 } else {
1089                     assembly {
1090                         revert(add(32, reason), mload(reason))
1091                     }
1092                 }
1093             }
1094         } else {
1095             return true;
1096         }
1097     }
1098 
1099     /**
1100      * @dev Hook that is called before any token transfer. This includes minting
1101      * and burning.
1102      *
1103      * Calling conditions:
1104      *
1105      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1106      * transferred to `to`.
1107      * - When `from` is zero, `tokenId` will be minted for `to`.
1108      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1109      * - `from` and `to` are never both zero.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) internal virtual {}
1118 }
1119 
1120 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1121 
1122 
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
1141     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1142 
1143     /**
1144      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1145      * Use along with {totalSupply} to enumerate all tokens.
1146      */
1147     function tokenByIndex(uint256 index) external view returns (uint256);
1148 }
1149 
1150 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1151 
1152 
1153 
1154 pragma solidity ^0.8.0;
1155 
1156 
1157 
1158 /**
1159  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1160  * enumerability of all the token ids in the contract as well as all token ids owned by each
1161  * account.
1162  */
1163 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1164     // Mapping from owner to list of owned token IDs
1165     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1166 
1167     // Mapping from token ID to index of the owner tokens list
1168     mapping(uint256 => uint256) private _ownedTokensIndex;
1169 
1170     // Array with all token ids, used for enumeration
1171     uint256[] private _allTokens;
1172 
1173     // Mapping from token id to position in the allTokens array
1174     mapping(uint256 => uint256) private _allTokensIndex;
1175 
1176     /**
1177      * @dev See {IERC165-supportsInterface}.
1178      */
1179     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1180         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1181     }
1182 
1183     /**
1184      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1185      */
1186     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1187         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1188         return _ownedTokens[owner][index];
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Enumerable-totalSupply}.
1193      */
1194     function totalSupply() public view virtual override returns (uint256) {
1195         return _allTokens.length;
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Enumerable-tokenByIndex}.
1200      */
1201     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1202         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1203         return _allTokens[index];
1204     }
1205 
1206     /**
1207      * @dev Hook that is called before any token transfer. This includes minting
1208      * and burning.
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` will be minted for `to`.
1215      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1216      * - `from` cannot be the zero address.
1217      * - `to` cannot be the zero address.
1218      *
1219      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1220      */
1221     function _beforeTokenTransfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) internal virtual override {
1226         super._beforeTokenTransfer(from, to, tokenId);
1227 
1228         if (from == address(0)) {
1229             _addTokenToAllTokensEnumeration(tokenId);
1230         } else if (from != to) {
1231             _removeTokenFromOwnerEnumeration(from, tokenId);
1232         }
1233         if (to == address(0)) {
1234             _removeTokenFromAllTokensEnumeration(tokenId);
1235         } else if (to != from) {
1236             _addTokenToOwnerEnumeration(to, tokenId);
1237         }
1238     }
1239 
1240     /**
1241      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1242      * @param to address representing the new owner of the given token ID
1243      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1244      */
1245     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1246         uint256 length = ERC721.balanceOf(to);
1247         _ownedTokens[to][length] = tokenId;
1248         _ownedTokensIndex[tokenId] = length;
1249     }
1250 
1251     /**
1252      * @dev Private function to add a token to this extension's token tracking data structures.
1253      * @param tokenId uint256 ID of the token to be added to the tokens list
1254      */
1255     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1256         _allTokensIndex[tokenId] = _allTokens.length;
1257         _allTokens.push(tokenId);
1258     }
1259 
1260     /**
1261      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1262      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1263      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1264      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1265      * @param from address representing the previous owner of the given token ID
1266      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1267      */
1268     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1269         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1270         // then delete the last slot (swap and pop).
1271 
1272         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1273         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1274 
1275         // When the token to delete is the last token, the swap operation is unnecessary
1276         if (tokenIndex != lastTokenIndex) {
1277             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1278 
1279             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1280             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1281         }
1282 
1283         // This also deletes the contents at the last position of the array
1284         delete _ownedTokensIndex[tokenId];
1285         delete _ownedTokens[from][lastTokenIndex];
1286     }
1287 
1288     /**
1289      * @dev Private function to remove a token from this extension's token tracking data structures.
1290      * This has O(1) time complexity, but alters the order of the _allTokens array.
1291      * @param tokenId uint256 ID of the token to be removed from the tokens list
1292      */
1293     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1294         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1295         // then delete the last slot (swap and pop).
1296 
1297         uint256 lastTokenIndex = _allTokens.length - 1;
1298         uint256 tokenIndex = _allTokensIndex[tokenId];
1299 
1300         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1301         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1302         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1303         uint256 lastTokenId = _allTokens[lastTokenIndex];
1304 
1305         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1306         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1307 
1308         // This also deletes the contents at the last position of the array
1309         delete _allTokensIndex[tokenId];
1310         _allTokens.pop();
1311     }
1312 }
1313 
1314 // File: @openzeppelin/contracts/access/Ownable.sol
1315 
1316 
1317 
1318 pragma solidity ^0.8.0;
1319 
1320 
1321 /**
1322  * @dev Contract module which provides a basic access control mechanism, where
1323  * there is an account (an owner) that can be granted exclusive access to
1324  * specific functions.
1325  *
1326  * By default, the owner account will be the one that deploys the contract. This
1327  * can later be changed with {transferOwnership}.
1328  *
1329  * This module is used through inheritance. It will make available the modifier
1330  * `onlyOwner`, which can be applied to your functions to restrict their use to
1331  * the owner.
1332  */
1333 abstract contract Ownable is Context {
1334     address private _owner;
1335 
1336     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1337 
1338     /**
1339      * @dev Initializes the contract setting the deployer as the initial owner.
1340      */
1341     constructor() {
1342         _setOwner(_msgSender());
1343     }
1344 
1345     /**
1346      * @dev Returns the address of the current owner.
1347      */
1348     function owner() public view virtual returns (address) {
1349         return _owner;
1350     }
1351 
1352     /**
1353      * @dev Throws if called by any account other than the owner.
1354      */
1355     modifier onlyOwner() {
1356         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1357         _;
1358     }
1359 
1360     /**
1361      * @dev Leaves the contract without owner. It will not be possible to call
1362      * `onlyOwner` functions anymore. Can only be called by the current owner.
1363      *
1364      * NOTE: Renouncing ownership will leave the contract without an owner,
1365      * thereby removing any functionality that is only available to the owner.
1366      */
1367     function renounceOwnership() public virtual onlyOwner {
1368         _setOwner(address(0));
1369     }
1370 
1371     /**
1372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1373      * Can only be called by the current owner.
1374      */
1375     function transferOwnership(address newOwner) public virtual onlyOwner {
1376         require(newOwner != address(0), "Ownable: new owner is the zero address");
1377         _setOwner(newOwner);
1378     }
1379 
1380     function _setOwner(address newOwner) private {
1381         address oldOwner = _owner;
1382         _owner = newOwner;
1383         emit OwnershipTransferred(oldOwner, newOwner);
1384     }
1385 }
1386 
1387 // File: contracts/PixelGlyphs.sol
1388 
1389 
1390 pragma solidity >=0.4.22 <0.9.0;
1391 
1392 
1393 
1394 
1395 /**
1396 
1397                                                                                                                                                                                    
1398                                                                                                                                                                                    
1399 PPPPPPPPPPPPPPPPP     iiii                                      lllllll                    lllllll                                            hhhhhhh                              
1400 P::::::::::::::::P   i::::i                                     l:::::l                    l:::::l                                            h:::::h                              
1401 P::::::PPPPPP:::::P   iiii                                      l:::::l                    l:::::l                                            h:::::h                              
1402 PP:::::P     P:::::P                                            l:::::l                    l:::::l                                            h:::::h                              
1403   P::::P     P:::::Piiiiiii xxxxxxx      xxxxxxx eeeeeeeeeeee    l::::l    ggggggggg   gggggl::::lyyyyyyy           yyyyyyyppppp   ppppppppp   h::::h hhhhh           ssssssssss   
1404   P::::P     P:::::Pi:::::i  x:::::x    x:::::xee::::::::::::ee  l::::l   g:::::::::ggg::::gl::::l y:::::y         y:::::y p::::ppp:::::::::p  h::::hh:::::hhh      ss::::::::::s  
1405   P::::PPPPPP:::::P  i::::i   x:::::x  x:::::xe::::::eeeee:::::eel::::l  g:::::::::::::::::gl::::l  y:::::y       y:::::y  p:::::::::::::::::p h::::::::::::::hh  ss:::::::::::::s 
1406   P:::::::::::::PP   i::::i    x:::::xx:::::xe::::::e     e:::::el::::l g::::::ggggg::::::ggl::::l   y:::::y     y:::::y   pp::::::ppppp::::::ph:::::::hhh::::::h s::::::ssss:::::s
1407   P::::PPPPPPPPP     i::::i     x::::::::::x e:::::::eeeee::::::el::::l g:::::g     g:::::g l::::l    y:::::y   y:::::y     p:::::p     p:::::ph::::::h   h::::::h s:::::s  ssssss 
1408   P::::P             i::::i      x::::::::x  e:::::::::::::::::e l::::l g:::::g     g:::::g l::::l     y:::::y y:::::y      p:::::p     p:::::ph:::::h     h:::::h   s::::::s      
1409   P::::P             i::::i      x::::::::x  e::::::eeeeeeeeeee  l::::l g:::::g     g:::::g l::::l      y:::::y:::::y       p:::::p     p:::::ph:::::h     h:::::h      s::::::s   
1410   P::::P             i::::i     x::::::::::x e:::::::e           l::::l g::::::g    g:::::g l::::l       y:::::::::y        p:::::p    p::::::ph:::::h     h:::::hssssss   s:::::s 
1411 PP::::::PP          i::::::i   x:::::xx:::::xe::::::::e         l::::::lg:::::::ggggg:::::gl::::::l       y:::::::y         p:::::ppppp:::::::ph:::::h     h:::::hs:::::ssss::::::s
1412 P::::::::P          i::::::i  x:::::x  x:::::xe::::::::eeeeeeee l::::::l g::::::::::::::::gl::::::l        y:::::y          p::::::::::::::::p h:::::h     h:::::hs::::::::::::::s 
1413 P::::::::P          i::::::i x:::::x    x:::::xee:::::::::::::e l::::::l  gg::::::::::::::gl::::::l       y:::::y           p::::::::::::::pp  h:::::h     h:::::h s:::::::::::ss  
1414 PPPPPPPPPP          iiiiiiiixxxxxxx      xxxxxxx eeeeeeeeeeeeee llllllll    gggggggg::::::gllllllll      y:::::y            p::::::pppppppp    hhhhhhh     hhhhhhh  sssssssssss    
1415                                                                                     g:::::g             y:::::y             p:::::p                                                
1416                                                                         gggggg      g:::::g            y:::::y              p:::::p                                                
1417                                                                         g:::::gg   gg:::::g           y:::::y              p:::::::p                                               
1418                                                                          g::::::ggg:::::::g          y:::::y               p:::::::p                                               
1419                                                                           gg:::::::::::::g          yyyyyyy                p:::::::p                                               
1420                                                                             ggg::::::ggg                                   ppppppppp                                               
1421                                                                                gggggg                                                                                              
1422 
1423 ################################################################################
1424 ################################################################################
1425 ################################################################################
1426 ################################################################################
1427 ################################################################################
1428 ################################################################################
1429 ##############################((((((((((((((((((((##############################
1430 ##############################((((((((((((((((((((##############################
1431 ####################((((((((((####################((((((((((####################
1432 ####################((((((((((####################((((((((((####################
1433 ###############(((((#####(((((####################(((((#####(((((###############
1434 ###############(((((#####(((((####################(((((#####(((((###############
1435 ###############(((((##########(((((##########(((((##########(((((###############
1436 ###############(((((##########(((((##########(((((##########(((((###############
1437 ###############(((((##########(((((##########(((((##########(((((###############
1438 ###############(((((##########(((((##########(((((##########(((((###############
1439 ####################((((((((((####################((((((((((####################
1440 ####################((((((((((####################((((((((((####################
1441 ###############(((((##########((((((((((((((((((((##########(((((###############
1442 ###############(((((##########((((((((((((((((((((##########(((((###############
1443 ###############(((((###############((((((((((###############(((((###############
1444 ###############(((((###############((((((((((###############(((((###############
1445 ####################(((((((((((((((##########(((((((((((((((####################
1446 ####################(((((((((((((((##########(((((((((((((((####################
1447 ###################################((((((((((###################################
1448 ###################################((((((((((###################################
1449 ################################################################################
1450 ################################################################################
1451 ################################################################################
1452 ################################################################################
1453 ################################################################################
1454 ################################################################################
1455 
1456 10,000 on-chain avatar NFTs created using a cellular automaton. 
1457 
1458 A cellular automaton consists of a regular grid of cells, each in one of a finite number of states, 
1459 such as on and off. The grid can be in any finite number of dimensions. For each cell, a set of cells 
1460 called its neighborhood is defined relative to the specified cell. An initial state (time t = 0) is 
1461 selected by assigning a state for each cell. A new generation is created (advancing t by 1), according 
1462 to some fixed rule (generally, a mathematical function) that determines the new state of each cell in terms 
1463 of the current state of the cell and the states of the cells in its neighborhood. Typically, the rule 
1464 for updating the state of cells is the same for each cell and does not change over time, and is 
1465 applied to the whole grid simultaneously.
1466 
1467 
1468 https://pixelglyphs.io
1469 
1470 
1471 */
1472 
1473 contract PixelGlyphs is ERC721Enumerable, Ownable {
1474   using ECDSA for bytes32;
1475 
1476   uint256 spriteSize = 10;
1477   uint256 globalId = 0;
1478   address SIGNER;
1479   uint256 public PRICE_PER_MINT = 0.009 ether;
1480   uint256 public PRICE_PER_NAME = 0.0025 ether;
1481   string BASE_URI;
1482   uint256 public namingBlockStart;
1483   uint256 public namingBlockEnd;
1484   mapping(uint256 => string) public names;
1485 
1486   constructor(address signer, string memory baseUri)
1487     ERC721("PixelGlyphs", "PxG")
1488   {
1489     SIGNER = signer;
1490     BASE_URI = baseUri;
1491   }
1492 
1493   event Created(
1494     uint256 indexed tokenId,
1495     uint256[5][10] glyph,
1496     uint256[3][3] colors
1497   );
1498 
1499   event Named(uint256 indexed tokenId, string name);
1500 
1501   function nameGlyph(uint256 tokenId, string memory name) public payable {
1502     require(msg.value == PRICE_PER_NAME);
1503     require(ownerOf(tokenId) == msg.sender);
1504     require(block.number >= namingBlockStart && block.number <= namingBlockEnd);
1505     names[tokenId] = name;
1506     emit Named(tokenId, name);
1507   }
1508 
1509   // This will begin The Great Naming Ceremony
1510   function setNamingBlock(uint256 blockNumber) public onlyOwner {
1511     require(namingBlockStart == 0, "PxG: Naming ceremony has already begun");
1512     namingBlockStart = blockNumber;
1513     // The Great Naming Ceremony will last approximately 5 days
1514     namingBlockEnd = blockNumber + (6357 * 3);
1515   }
1516 
1517   function _mintInternal(
1518     uint256[] memory seed,
1519     uint256[] memory cSeed,
1520     bytes32 uuid,
1521     uint256 timestamp,
1522     bytes memory sig,
1523     address to
1524   ) internal {
1525     bytes32 hash = keccak256(abi.encodePacked(seed, cSeed, timestamp, uuid));
1526     require(
1527       hash.toEthSignedMessageHash().recover(sig) == SIGNER,
1528       "PxG: Invalid signature"
1529     );
1530     require(globalId < 10000, "PxG: All glyphs minted");
1531     uint256[5][10] memory matrix;
1532     for (uint256 i = 0; i < spriteSize; i++) {
1533       uint256[5] memory row;
1534       matrix[i] = row;
1535       if (i == 0 || i == spriteSize - 1) continue;
1536       row[0] = 0;
1537 
1538       for (uint256 j = 1; j < row.length; j++) {
1539         row[j] = seed[i * row.length + j] % 2;
1540       }
1541     }
1542 
1543     for (uint256 index = 0; index < 2; index++) {
1544       matrix = step(matrix);
1545     }
1546 
1547     uint256[3][3] memory colors;
1548 
1549     for (uint256 i = 0; i < colors.length; i++) {
1550       for (uint256 j = 0; j < colors[i].length; j++) {
1551         colors[i][j] = cSeed[i * 3 + j] % 255;
1552       }
1553     }
1554 
1555     _safeMint(to, ++globalId);
1556 
1557     emit Created(globalId, matrix, colors);
1558   }
1559 
1560   function mintTo(
1561     uint256[] memory seed,
1562     uint256[] memory cSeed,
1563     bytes32 uuid,
1564     uint256 timestamp,
1565     bytes memory sig,
1566     address to
1567   ) public onlyOwner {
1568     _mintInternal(seed, cSeed, uuid, timestamp, sig, to);
1569   }
1570 
1571   function setBaseUri(string memory baseUri) public onlyOwner {
1572     BASE_URI = baseUri;
1573   }
1574 
1575   function _baseURI() internal view virtual override returns (string memory) {
1576     return BASE_URI;
1577   }
1578 
1579   function mint(
1580     uint256[][] memory seeds,
1581     uint256[][] memory cSeeds,
1582     bytes32[] memory uuids,
1583     uint256 timestamp,
1584     bytes[] memory sigs
1585   ) public payable {
1586     require(seeds.length == cSeeds.length, "PxG: Arrays do not match");
1587     require(uuids.length == seeds.length, "PxG: Arrays do not match");
1588     require(sigs.length == seeds.length, "PxG: Arrays do not match");
1589     require(msg.value == PRICE_PER_MINT * seeds.length, "PxG: Incorrect value");
1590     require(block.timestamp <= timestamp + 6 hours);
1591     for (uint256 i = 0; i < seeds.length; i++) {
1592       _mintInternal(
1593         seeds[i],
1594         cSeeds[i],
1595         uuids[i],
1596         timestamp,
1597         sigs[i],
1598         msg.sender
1599       );
1600     }
1601   }
1602 
1603   mapping(address => uint256) public equipped;
1604 
1605   event Equip(address indexed owner, uint256 tokenId);
1606 
1607   function equip(uint256 tokenId) public {
1608     require(ownerOf(tokenId) == msg.sender, "PxG: Must be owner to equip");
1609     equipped[msg.sender] = tokenId;
1610     emit Equip(msg.sender, tokenId);
1611   }
1612 
1613   function _beforeTokenTransfer(
1614     address from,
1615     address to,
1616     uint256 tokenId
1617   ) internal override {
1618     super._beforeTokenTransfer(from, to, tokenId);
1619     if (equipped[from] == tokenId) {
1620       delete equipped[from];
1621       emit Equip(msg.sender, 0);
1622     }
1623   }
1624 
1625   function countNeighbors(
1626     uint256[5][10] memory matrix,
1627     uint256 x,
1628     uint256 y
1629   ) internal pure returns (uint256) {
1630     uint256 count = 0;
1631     // check left
1632     if (matrix[y][x - 1] > 0) {
1633       count++;
1634     }
1635     // check right
1636     if (x < matrix[y].length - 1 && matrix[y][x + 1] > 0) {
1637       count++;
1638     }
1639     // check top
1640     if (y > 0 && matrix[y - 1][x] > 0) {
1641       count++;
1642     }
1643     // check bottom
1644     if (y < matrix.length - 1 && matrix[y + 1][x] > 0) {
1645       count++;
1646     }
1647     return count;
1648   }
1649 
1650   function step(uint256[5][10] memory prev)
1651     internal
1652     pure
1653     returns (uint256[5][10] memory)
1654   {
1655     uint256[5][10] memory next;
1656     uint256 size = prev.length;
1657 
1658     for (uint256 y = 0; y < size; y++) {
1659       uint256[5] memory row;
1660       next[y] = row;
1661       if (y == 0 || y == size - 1) continue;
1662       row[0] = 0;
1663 
1664       for (uint256 x = 1; x < row.length; x++) {
1665         uint256 n = countNeighbors(prev, x, y);
1666         row[x] = prev[y][x] == 0 ? (n <= 1 ? 1 : 0) : n == 2 || n == 3 ? 1 : 0;
1667       }
1668     }
1669     return next;
1670   }
1671 
1672   function withdraw(address sendTo) public onlyOwner {
1673     uint256 balance = address(this).balance;
1674     payable(sendTo).transfer(balance);
1675   }
1676 
1677   function updateSigner(address signer) public onlyOwner {
1678     SIGNER = signer;
1679   }
1680 
1681   function updatePricePerMint(uint256 price) public onlyOwner {
1682     PRICE_PER_MINT = price;
1683   }
1684 
1685   function setGenerationString(bytes calldata str) public onlyOwner {}
1686 }