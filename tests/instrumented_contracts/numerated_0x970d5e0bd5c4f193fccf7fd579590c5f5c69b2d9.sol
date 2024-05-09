1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Address.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(
60             address(this).balance >= amount,
61             "Address: insufficient balance"
62         );
63 
64         (bool success, ) = recipient.call{value: amount}("");
65         require(
66             success,
67             "Address: unable to send value, recipient may have reverted"
68         );
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data)
90         internal
91         returns (bytes memory)
92     {
93         return functionCall(target, data, "Address: low-level call failed");
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
98      * `errorMessage` as a fallback revert reason when `target` reverts.
99      *
100      * _Available since v3.1._
101      */
102     function functionCall(
103         address target,
104         bytes memory data,
105         string memory errorMessage
106     ) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, 0, errorMessage);
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
112      * but also transferring `value` wei to `target`.
113      *
114      * Requirements:
115      *
116      * - the calling contract must have an ETH balance of at least `value`.
117      * - the called Solidity function must be `payable`.
118      *
119      * _Available since v3.1._
120      */
121     function functionCallWithValue(
122         address target,
123         bytes memory data,
124         uint256 value
125     ) internal returns (bytes memory) {
126         return
127             functionCallWithValue(
128                 target,
129                 data,
130                 value,
131                 "Address: low-level call with value failed"
132             );
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
147         require(
148             address(this).balance >= value,
149             "Address: insufficient balance for call"
150         );
151         require(isContract(target), "Address: call to non-contract");
152 
153         (bool success, bytes memory returndata) = target.call{value: value}(
154             data
155         );
156         return verifyCallResult(success, returndata, errorMessage);
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(address target, bytes memory data)
166         internal
167         view
168         returns (bytes memory)
169     {
170         return
171             functionStaticCall(
172                 target,
173                 data,
174                 "Address: low-level static call failed"
175             );
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
180      * but performing a static call.
181      *
182      * _Available since v3.3._
183      */
184     function functionStaticCall(
185         address target,
186         bytes memory data,
187         string memory errorMessage
188     ) internal view returns (bytes memory) {
189         require(isContract(target), "Address: static call to non-contract");
190 
191         (bool success, bytes memory returndata) = target.staticcall(data);
192         return verifyCallResult(success, returndata, errorMessage);
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
197      * but performing a delegate call.
198      *
199      * _Available since v3.4._
200      */
201     function functionDelegateCall(address target, bytes memory data)
202         internal
203         returns (bytes memory)
204     {
205         return
206             functionDelegateCall(
207                 target,
208                 data,
209                 "Address: low-level delegate call failed"
210             );
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
215      * but performing a delegate call.
216      *
217      * _Available since v3.4._
218      */
219     function functionDelegateCall(
220         address target,
221         bytes memory data,
222         string memory errorMessage
223     ) internal returns (bytes memory) {
224         require(isContract(target), "Address: delegate call to non-contract");
225 
226         (bool success, bytes memory returndata) = target.delegatecall(data);
227         return verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
232      * revert reason using the provided one.
233      *
234      * _Available since v4.3._
235      */
236     function verifyCallResult(
237         bool success,
238         bytes memory returndata,
239         string memory errorMessage
240     ) internal pure returns (bytes memory) {
241         if (success) {
242             return returndata;
243         } else {
244             // Look for revert reason and bubble it up if present
245             if (returndata.length > 0) {
246                 // The easiest way to bubble the revert reason is using memory via assembly
247 
248                 assembly {
249                     let returndata_size := mload(returndata)
250                     revert(add(32, returndata), returndata_size)
251                 }
252             } else {
253                 revert(errorMessage);
254             }
255         }
256     }
257 }
258 
259 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
260 
261 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @title ERC721 token receiver interface
267  * @dev Interface for any contract that wants to support safeTransfers
268  * from ERC721 asset contracts.
269  */
270 interface IERC721Receiver {
271     /**
272      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
273      * by `operator` from `from`, this function is called.
274      *
275      * It must return its Solidity selector to confirm the token transfer.
276      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
277      *
278      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
279      */
280     function onERC721Received(
281         address operator,
282         address from,
283         uint256 tokenId,
284         bytes calldata data
285     ) external returns (bytes4);
286 }
287 
288 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
289 
290 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Interface of the ERC165 standard, as defined in the
296  * https://eips.ethereum.org/EIPS/eip-165[EIP].
297  *
298  * Implementers can declare support of contract interfaces, which can then be
299  * queried by others ({ERC165Checker}).
300  *
301  * For an implementation, see {ERC165}.
302  */
303 interface IERC165 {
304     /**
305      * @dev Returns true if this contract implements the interface defined by
306      * `interfaceId`. See the corresponding
307      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
308      * to learn more about how these ids are created.
309      *
310      * This function call must use less than 30 000 gas.
311      */
312     function supportsInterface(bytes4 interfaceId) external view returns (bool);
313 }
314 
315 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
316 
317 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 /**
322  * @dev Implementation of the {IERC165} interface.
323  *
324  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
325  * for the additional interface id that will be supported. For example:
326  *
327  * ```solidity
328  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
329  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
330  * }
331  * ```
332  *
333  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
334  */
335 abstract contract ERC165 is IERC165 {
336     /**
337      * @dev See {IERC165-supportsInterface}.
338      */
339     function supportsInterface(bytes4 interfaceId)
340         public
341         view
342         virtual
343         override
344         returns (bool)
345     {
346         return interfaceId == type(IERC165).interfaceId;
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
351 
352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Required interface of an ERC721 compliant contract.
358  */
359 interface IERC721 is IERC165 {
360     /**
361      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
362      */
363     event Transfer(
364         address indexed from,
365         address indexed to,
366         uint256 indexed tokenId
367     );
368 
369     /**
370      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
371      */
372     event Approval(
373         address indexed owner,
374         address indexed approved,
375         uint256 indexed tokenId
376     );
377 
378     /**
379      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
380      */
381     event ApprovalForAll(
382         address indexed owner,
383         address indexed operator,
384         bool approved
385     );
386 
387     /**
388      * @dev Returns the number of tokens in ``owner``'s account.
389      */
390     function balanceOf(address owner) external view returns (uint256 balance);
391 
392     /**
393      * @dev Returns the owner of the `tokenId` token.
394      *
395      * Requirements:
396      *
397      * - `tokenId` must exist.
398      */
399     function ownerOf(uint256 tokenId) external view returns (address owner);
400 
401     /**
402      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
403      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `tokenId` token must exist and be owned by `from`.
410      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
411      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
412      *
413      * Emits a {Transfer} event.
414      */
415     function safeTransferFrom(
416         address from,
417         address to,
418         uint256 tokenId
419     ) external;
420 
421     /**
422      * @dev Transfers `tokenId` token from `from` to `to`.
423      *
424      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
425      *
426      * Requirements:
427      *
428      * - `from` cannot be the zero address.
429      * - `to` cannot be the zero address.
430      * - `tokenId` token must be owned by `from`.
431      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
432      *
433      * Emits a {Transfer} event.
434      */
435     function transferFrom(
436         address from,
437         address to,
438         uint256 tokenId
439     ) external;
440 
441     /**
442      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
443      * The approval is cleared when the token is transferred.
444      *
445      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
446      *
447      * Requirements:
448      *
449      * - The caller must own the token or be an approved operator.
450      * - `tokenId` must exist.
451      *
452      * Emits an {Approval} event.
453      */
454     function approve(address to, uint256 tokenId) external;
455 
456     /**
457      * @dev Returns the account approved for `tokenId` token.
458      *
459      * Requirements:
460      *
461      * - `tokenId` must exist.
462      */
463     function getApproved(uint256 tokenId)
464         external
465         view
466         returns (address operator);
467 
468     /**
469      * @dev Approve or remove `operator` as an operator for the caller.
470      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
471      *
472      * Requirements:
473      *
474      * - The `operator` cannot be the caller.
475      *
476      * Emits an {ApprovalForAll} event.
477      */
478     function setApprovalForAll(address operator, bool _approved) external;
479 
480     /**
481      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
482      *
483      * See {setApprovalForAll}
484      */
485     function isApprovedForAll(address owner, address operator)
486         external
487         view
488         returns (bool);
489 
490     /**
491      * @dev Safely transfers `tokenId` token from `from` to `to`.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId,
507         bytes calldata data
508     ) external;
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
512 
513 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 /**
518  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
519  * @dev See https://eips.ethereum.org/EIPS/eip-721
520  */
521 interface IERC721Enumerable is IERC721 {
522     /**
523      * @dev Returns the total amount of tokens stored by the contract.
524      */
525     function totalSupply() external view returns (uint256);
526 
527     /**
528      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
529      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
530      */
531     function tokenOfOwnerByIndex(address owner, uint256 index)
532         external
533         view
534         returns (uint256 tokenId);
535 
536     /**
537      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
538      * Use along with {totalSupply} to enumerate all tokens.
539      */
540     function tokenByIndex(uint256 index) external view returns (uint256);
541 }
542 
543 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
544 
545 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
551  * @dev See https://eips.ethereum.org/EIPS/eip-721
552  */
553 interface IERC721Metadata is IERC721 {
554     /**
555      * @dev Returns the token collection name.
556      */
557     function name() external view returns (string memory);
558 
559     /**
560      * @dev Returns the token collection symbol.
561      */
562     function symbol() external view returns (string memory);
563 
564     /**
565      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
566      */
567     function tokenURI(uint256 tokenId) external view returns (string memory);
568 }
569 
570 // File: @openzeppelin/contracts/utils/Strings.sol
571 
572 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 /**
577  * @dev String operations.
578  */
579 library Strings {
580     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
581 
582     /**
583      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
584      */
585     function toString(uint256 value) internal pure returns (string memory) {
586         // Inspired by OraclizeAPI's implementation - MIT licence
587         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
588 
589         if (value == 0) {
590             return "0";
591         }
592         uint256 temp = value;
593         uint256 digits;
594         while (temp != 0) {
595             digits++;
596             temp /= 10;
597         }
598         bytes memory buffer = new bytes(digits);
599         while (value != 0) {
600             digits -= 1;
601             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
602             value /= 10;
603         }
604         return string(buffer);
605     }
606 
607     /**
608      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
609      */
610     function toHexString(uint256 value) internal pure returns (string memory) {
611         if (value == 0) {
612             return "0x00";
613         }
614         uint256 temp = value;
615         uint256 length = 0;
616         while (temp != 0) {
617             length++;
618             temp >>= 8;
619         }
620         return toHexString(value, length);
621     }
622 
623     /**
624      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
625      */
626     function toHexString(uint256 value, uint256 length)
627         internal
628         pure
629         returns (string memory)
630     {
631         bytes memory buffer = new bytes(2 * length + 2);
632         buffer[0] = "0";
633         buffer[1] = "x";
634         for (uint256 i = 2 * length + 1; i > 1; --i) {
635             buffer[i] = _HEX_SYMBOLS[value & 0xf];
636             value >>= 4;
637         }
638         require(value == 0, "Strings: hex length insufficient");
639         return string(buffer);
640     }
641 }
642 
643 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
644 
645 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 /**
650  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
651  *
652  * These functions can be used to verify that a message was signed by the holder
653  * of the private keys of a given address.
654  */
655 library ECDSA {
656     enum RecoverError {
657         NoError,
658         InvalidSignature,
659         InvalidSignatureLength,
660         InvalidSignatureS,
661         InvalidSignatureV
662     }
663 
664     function _throwError(RecoverError error) private pure {
665         if (error == RecoverError.NoError) {
666             return; // no error: do nothing
667         } else if (error == RecoverError.InvalidSignature) {
668             revert("ECDSA: invalid signature");
669         } else if (error == RecoverError.InvalidSignatureLength) {
670             revert("ECDSA: invalid signature length");
671         } else if (error == RecoverError.InvalidSignatureS) {
672             revert("ECDSA: invalid signature 's' value");
673         } else if (error == RecoverError.InvalidSignatureV) {
674             revert("ECDSA: invalid signature 'v' value");
675         }
676     }
677 
678     /**
679      * @dev Returns the address that signed a hashed message (`hash`) with
680      * `signature` or error string. This address can then be used for verification purposes.
681      *
682      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
683      * this function rejects them by requiring the `s` value to be in the lower
684      * half order, and the `v` value to be either 27 or 28.
685      *
686      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
687      * verification to be secure: it is possible to craft signatures that
688      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
689      * this is by receiving a hash of the original message (which may otherwise
690      * be too long), and then calling {toEthSignedMessageHash} on it.
691      *
692      * Documentation for signature generation:
693      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
694      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
695      *
696      * _Available since v4.3._
697      */
698     function tryRecover(bytes32 hash, bytes memory signature)
699         internal
700         pure
701         returns (address, RecoverError)
702     {
703         // Check the signature length
704         // - case 65: r,s,v signature (standard)
705         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
706         if (signature.length == 65) {
707             bytes32 r;
708             bytes32 s;
709             uint8 v;
710             // ecrecover takes the signature parameters, and the only way to get them
711             // currently is to use assembly.
712             assembly {
713                 r := mload(add(signature, 0x20))
714                 s := mload(add(signature, 0x40))
715                 v := byte(0, mload(add(signature, 0x60)))
716             }
717             return tryRecover(hash, v, r, s);
718         } else if (signature.length == 64) {
719             bytes32 r;
720             bytes32 vs;
721             // ecrecover takes the signature parameters, and the only way to get them
722             // currently is to use assembly.
723             assembly {
724                 r := mload(add(signature, 0x20))
725                 vs := mload(add(signature, 0x40))
726             }
727             return tryRecover(hash, r, vs);
728         } else {
729             return (address(0), RecoverError.InvalidSignatureLength);
730         }
731     }
732 
733     /**
734      * @dev Returns the address that signed a hashed message (`hash`) with
735      * `signature`. This address can then be used for verification purposes.
736      *
737      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
738      * this function rejects them by requiring the `s` value to be in the lower
739      * half order, and the `v` value to be either 27 or 28.
740      *
741      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
742      * verification to be secure: it is possible to craft signatures that
743      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
744      * this is by receiving a hash of the original message (which may otherwise
745      * be too long), and then calling {toEthSignedMessageHash} on it.
746      */
747     function recover(bytes32 hash, bytes memory signature)
748         internal
749         pure
750         returns (address)
751     {
752         (address recovered, RecoverError error) = tryRecover(hash, signature);
753         _throwError(error);
754         return recovered;
755     }
756 
757     /**
758      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
759      *
760      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
761      *
762      * _Available since v4.3._
763      */
764     function tryRecover(
765         bytes32 hash,
766         bytes32 r,
767         bytes32 vs
768     ) internal pure returns (address, RecoverError) {
769         bytes32 s;
770         uint8 v;
771         assembly {
772             s := and(
773                 vs,
774                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
775             )
776             v := add(shr(255, vs), 27)
777         }
778         return tryRecover(hash, v, r, s);
779     }
780 
781     /**
782      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
783      *
784      * _Available since v4.2._
785      */
786     function recover(
787         bytes32 hash,
788         bytes32 r,
789         bytes32 vs
790     ) internal pure returns (address) {
791         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
792         _throwError(error);
793         return recovered;
794     }
795 
796     /**
797      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
798      * `r` and `s` signature fields separately.
799      *
800      * _Available since v4.3._
801      */
802     function tryRecover(
803         bytes32 hash,
804         uint8 v,
805         bytes32 r,
806         bytes32 s
807     ) internal pure returns (address, RecoverError) {
808         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
809         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
810         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
811         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
812         //
813         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
814         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
815         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
816         // these malleable signatures as well.
817         if (
818             uint256(s) >
819             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
820         ) {
821             return (address(0), RecoverError.InvalidSignatureS);
822         }
823         if (v != 27 && v != 28) {
824             return (address(0), RecoverError.InvalidSignatureV);
825         }
826 
827         // If the signature is valid (and not malleable), return the signer address
828         address signer = ecrecover(hash, v, r, s);
829         if (signer == address(0)) {
830             return (address(0), RecoverError.InvalidSignature);
831         }
832 
833         return (signer, RecoverError.NoError);
834     }
835 
836     /**
837      * @dev Overload of {ECDSA-recover} that receives the `v`,
838      * `r` and `s` signature fields separately.
839      */
840     function recover(
841         bytes32 hash,
842         uint8 v,
843         bytes32 r,
844         bytes32 s
845     ) internal pure returns (address) {
846         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
847         _throwError(error);
848         return recovered;
849     }
850 
851     /**
852      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
853      * produces hash corresponding to the one signed with the
854      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
855      * JSON-RPC method as part of EIP-191.
856      *
857      * See {recover}.
858      */
859     function toEthSignedMessageHash(bytes32 hash)
860         internal
861         pure
862         returns (bytes32)
863     {
864         // 32 is the length in bytes of hash,
865         // enforced by the type signature above
866         return
867             keccak256(
868                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
869             );
870     }
871 
872     /**
873      * @dev Returns an Ethereum Signed Message, created from `s`. This
874      * produces hash corresponding to the one signed with the
875      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
876      * JSON-RPC method as part of EIP-191.
877      *
878      * See {recover}.
879      */
880     function toEthSignedMessageHash(bytes memory s)
881         internal
882         pure
883         returns (bytes32)
884     {
885         return
886             keccak256(
887                 abi.encodePacked(
888                     "\x19Ethereum Signed Message:\n",
889                     Strings.toString(s.length),
890                     s
891                 )
892             );
893     }
894 
895     /**
896      * @dev Returns an Ethereum Signed Typed Data, created from a
897      * `domainSeparator` and a `structHash`. This produces hash corresponding
898      * to the one signed with the
899      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
900      * JSON-RPC method as part of EIP-712.
901      *
902      * See {recover}.
903      */
904     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
905         internal
906         pure
907         returns (bytes32)
908     {
909         return
910             keccak256(
911                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
912             );
913     }
914 }
915 
916 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
917 
918 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev Contract module that helps prevent reentrant calls to a function.
924  *
925  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
926  * available, which can be applied to functions to make sure there are no nested
927  * (reentrant) calls to them.
928  *
929  * Note that because there is a single `nonReentrant` guard, functions marked as
930  * `nonReentrant` may not call one another. This can be worked around by making
931  * those functions `private`, and then adding `external` `nonReentrant` entry
932  * points to them.
933  *
934  * TIP: If you would like to learn more about reentrancy and alternative ways
935  * to protect against it, check out our blog post
936  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
937  */
938 abstract contract ReentrancyGuard {
939     // Booleans are more expensive than uint256 or any type that takes up a full
940     // word because each write operation emits an extra SLOAD to first read the
941     // slot's contents, replace the bits taken up by the boolean, and then write
942     // back. This is the compiler's defense against contract upgrades and
943     // pointer aliasing, and it cannot be disabled.
944 
945     // The values being non-zero value makes deployment a bit more expensive,
946     // but in exchange the refund on every call to nonReentrant will be lower in
947     // amount. Since refunds are capped to a percentage of the total
948     // transaction's gas, it is best to keep them low in cases like this one, to
949     // increase the likelihood of the full refund coming into effect.
950     uint256 private constant _NOT_ENTERED = 1;
951     uint256 private constant _ENTERED = 2;
952 
953     uint256 private _status;
954 
955     constructor() {
956         _status = _NOT_ENTERED;
957     }
958 
959     /**
960      * @dev Prevents a contract from calling itself, directly or indirectly.
961      * Calling a `nonReentrant` function from another `nonReentrant`
962      * function is not supported. It is possible to prevent this from happening
963      * by making the `nonReentrant` function external, and making it call a
964      * `private` function that does the actual work.
965      */
966     modifier nonReentrant() {
967         // On the first call to nonReentrant, _notEntered will be true
968         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
969 
970         // Any calls to nonReentrant after this point will fail
971         _status = _ENTERED;
972 
973         _;
974 
975         // By storing the original value once again, a refund is triggered (see
976         // https://eips.ethereum.org/EIPS/eip-2200)
977         _status = _NOT_ENTERED;
978     }
979 }
980 
981 // File: @openzeppelin/contracts/utils/Context.sol
982 
983 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
984 
985 pragma solidity ^0.8.0;
986 
987 /**
988  * @dev Provides information about the current execution context, including the
989  * sender of the transaction and its data. While these are generally available
990  * via msg.sender and msg.data, they should not be accessed in such a direct
991  * manner, since when dealing with meta-transactions the account sending and
992  * paying for execution may not be the actual sender (as far as an application
993  * is concerned).
994  *
995  * This contract is only required for intermediate, library-like contracts.
996  */
997 abstract contract Context {
998     function _msgSender() internal view virtual returns (address) {
999         return msg.sender;
1000     }
1001 
1002     function _msgData() internal view virtual returns (bytes calldata) {
1003         return msg.data;
1004     }
1005 }
1006 
1007 // File: contracts/ERC721A.sol
1008 
1009 pragma solidity ^0.8.0;
1010 
1011 /**
1012  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1013  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1014  *
1015  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1016  *
1017  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1018  *
1019  * Does not support burning tokens to address(0).
1020  */
1021 contract ERC721A is
1022     Context,
1023     ERC165,
1024     IERC721,
1025     IERC721Metadata,
1026     IERC721Enumerable
1027 {
1028     using Address for address;
1029     using Strings for uint256;
1030 
1031     struct TokenOwnership {
1032         address addr;
1033         uint64 startTimestamp;
1034     }
1035 
1036     struct AddressData {
1037         uint128 balance;
1038         uint128 numberMinted;
1039     }
1040 
1041     uint256 private currentIndex = 0;
1042 
1043     uint256 internal immutable collectionSize;
1044     uint256 internal immutable maxBatchSize;
1045 
1046     // Token name
1047     string private _name;
1048 
1049     // Token symbol
1050     string private _symbol;
1051 
1052     // Mapping from token ID to ownership details
1053     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1054     mapping(uint256 => TokenOwnership) private _ownerships;
1055 
1056     // Mapping owner address to address data
1057     mapping(address => AddressData) private _addressData;
1058 
1059     // Mapping from token ID to approved address
1060     mapping(uint256 => address) private _tokenApprovals;
1061 
1062     // Mapping from owner to operator approvals
1063     mapping(address => mapping(address => bool)) private _operatorApprovals;
1064 
1065     /**
1066      * @dev
1067      * `maxBatchSize` refers to how much a minter can mint at a time.
1068      * `collectionSize_` refers to how many tokens are in the collection.
1069      */
1070     constructor(
1071         string memory name_,
1072         string memory symbol_,
1073         uint256 maxBatchSize_,
1074         uint256 collectionSize_
1075     ) {
1076         require(
1077             collectionSize_ > 0,
1078             "ERC721A: collection must have a nonzero supply"
1079         );
1080         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1081         _name = name_;
1082         _symbol = symbol_;
1083         maxBatchSize = maxBatchSize_;
1084         collectionSize = collectionSize_;
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Enumerable-totalSupply}.
1089      */
1090     function totalSupply() public view override returns (uint256) {
1091         return currentIndex;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Enumerable-tokenByIndex}.
1096      */
1097     function tokenByIndex(uint256 index)
1098         public
1099         view
1100         override
1101         returns (uint256)
1102     {
1103         require(index < totalSupply(), "ERC721A: global index out of bounds");
1104         return index;
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1109      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1110      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1111      */
1112     function tokenOfOwnerByIndex(address owner, uint256 index)
1113         public
1114         view
1115         override
1116         returns (uint256)
1117     {
1118         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1119         uint256 numMintedSoFar = totalSupply();
1120         uint256 tokenIdsIdx = 0;
1121         address currOwnershipAddr = address(0);
1122         for (uint256 i = 0; i < numMintedSoFar; i++) {
1123             TokenOwnership memory ownership = _ownerships[i];
1124             if (ownership.addr != address(0)) {
1125                 currOwnershipAddr = ownership.addr;
1126             }
1127             if (currOwnershipAddr == owner) {
1128                 if (tokenIdsIdx == index) {
1129                     return i;
1130                 }
1131                 tokenIdsIdx++;
1132             }
1133         }
1134         revert("ERC721A: unable to get token of owner by index");
1135     }
1136 
1137     /**
1138      * @dev See {IERC165-supportsInterface}.
1139      */
1140     function supportsInterface(bytes4 interfaceId)
1141         public
1142         view
1143         virtual
1144         override(ERC165, IERC165)
1145         returns (bool)
1146     {
1147         return
1148             interfaceId == type(IERC721).interfaceId ||
1149             interfaceId == type(IERC721Metadata).interfaceId ||
1150             interfaceId == type(IERC721Enumerable).interfaceId ||
1151             super.supportsInterface(interfaceId);
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-balanceOf}.
1156      */
1157     function balanceOf(address owner) public view override returns (uint256) {
1158         require(
1159             owner != address(0),
1160             "ERC721A: balance query for the zero address"
1161         );
1162         return uint256(_addressData[owner].balance);
1163     }
1164 
1165     function _numberMinted(address owner) internal view returns (uint256) {
1166         require(
1167             owner != address(0),
1168             "ERC721A: number minted query for the zero address"
1169         );
1170         return uint256(_addressData[owner].numberMinted);
1171     }
1172 
1173     function ownershipOf(uint256 tokenId)
1174         internal
1175         view
1176         returns (TokenOwnership memory)
1177     {
1178         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1179 
1180         uint256 lowestTokenToCheck;
1181         if (tokenId >= maxBatchSize) {
1182             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1183         }
1184 
1185         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1186             TokenOwnership memory ownership = _ownerships[curr];
1187             if (ownership.addr != address(0)) {
1188                 return ownership;
1189             }
1190         }
1191 
1192         revert("ERC721A: unable to determine the owner of token");
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-ownerOf}.
1197      */
1198     function ownerOf(uint256 tokenId) public view override returns (address) {
1199         return ownershipOf(tokenId).addr;
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Metadata-name}.
1204      */
1205     function name() public view virtual override returns (string memory) {
1206         return _name;
1207     }
1208 
1209     /**
1210      * @dev See {IERC721Metadata-symbol}.
1211      */
1212     function symbol() public view virtual override returns (string memory) {
1213         return _symbol;
1214     }
1215 
1216     /**
1217      * @dev See {IERC721Metadata-tokenURI}.
1218      */
1219     function tokenURI(uint256 tokenId)
1220         public
1221         view
1222         virtual
1223         override
1224         returns (string memory)
1225     {
1226         require(
1227             _exists(tokenId),
1228             "ERC721Metadata: URI query for nonexistent token"
1229         );
1230 
1231         string memory baseURI = _baseURI();
1232         return
1233             bytes(baseURI).length > 0
1234                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1235                 : "";
1236     }
1237 
1238     /**
1239      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1240      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1241      * by default, can be overriden in child contracts.
1242      */
1243     function _baseURI() internal view virtual returns (string memory) {
1244         return "";
1245     }
1246 
1247     /**
1248      * @dev See {IERC721-approve}.
1249      */
1250     function approve(address to, uint256 tokenId) public override {
1251         address owner = ERC721A.ownerOf(tokenId);
1252         require(to != owner, "ERC721A: approval to current owner");
1253 
1254         require(
1255             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1256             "ERC721A: approve caller is not owner nor approved for all"
1257         );
1258 
1259         _approve(to, tokenId, owner);
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-getApproved}.
1264      */
1265     function getApproved(uint256 tokenId)
1266         public
1267         view
1268         override
1269         returns (address)
1270     {
1271         require(
1272             _exists(tokenId),
1273             "ERC721A: approved query for nonexistent token"
1274         );
1275 
1276         return _tokenApprovals[tokenId];
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-setApprovalForAll}.
1281      */
1282     function setApprovalForAll(address operator, bool approved)
1283         public
1284         override
1285     {
1286         require(operator != _msgSender(), "ERC721A: approve to caller");
1287 
1288         _operatorApprovals[_msgSender()][operator] = approved;
1289         emit ApprovalForAll(_msgSender(), operator, approved);
1290     }
1291 
1292     /**
1293      * @dev See {IERC721-isApprovedForAll}.
1294      */
1295     function isApprovedForAll(address owner, address operator)
1296         public
1297         view
1298         virtual
1299         override
1300         returns (bool)
1301     {
1302         return _operatorApprovals[owner][operator];
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-transferFrom}.
1307      */
1308     function transferFrom(
1309         address from,
1310         address to,
1311         uint256 tokenId
1312     ) public override {
1313         _transfer(from, to, tokenId);
1314     }
1315 
1316     /**
1317      * @dev See {IERC721-safeTransferFrom}.
1318      */
1319     function safeTransferFrom(
1320         address from,
1321         address to,
1322         uint256 tokenId
1323     ) public override {
1324         safeTransferFrom(from, to, tokenId, "");
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-safeTransferFrom}.
1329      */
1330     function safeTransferFrom(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) public override {
1336         _transfer(from, to, tokenId);
1337         require(
1338             _checkOnERC721Received(from, to, tokenId, _data),
1339             "ERC721A: transfer to non ERC721Receiver implementer"
1340         );
1341     }
1342 
1343     /**
1344      * @dev Returns whether `tokenId` exists.
1345      *
1346      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1347      *
1348      * Tokens start existing when they are minted (`_mint`),
1349      */
1350     function _exists(uint256 tokenId) internal view returns (bool) {
1351         return tokenId < currentIndex;
1352     }
1353 
1354     function _safeMint(address to, uint256 quantity) internal {
1355         _safeMint(to, quantity, "");
1356     }
1357 
1358     /**
1359      * @dev Mints `quantity` tokens and transfers them to `to`.
1360      *
1361      * Requirements:
1362      *
1363      * - there must be `quantity` tokens remaining unminted in the total collection.
1364      * - `to` cannot be the zero address.
1365      * - `quantity` cannot be larger than the max batch size.
1366      *
1367      * Emits a {Transfer} event.
1368      */
1369     function _safeMint(
1370         address to,
1371         uint256 quantity,
1372         bytes memory _data
1373     ) internal {
1374         uint256 startTokenId = currentIndex;
1375         require(to != address(0), "ERC721A: mint to the zero address");
1376         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1377         require(!_exists(startTokenId), "ERC721A: token already minted");
1378         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1379 
1380         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1381 
1382         AddressData memory addressData = _addressData[to];
1383         _addressData[to] = AddressData(
1384             addressData.balance + uint128(quantity),
1385             addressData.numberMinted + uint128(quantity)
1386         );
1387         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1388 
1389         uint256 updatedIndex = startTokenId;
1390 
1391         for (uint256 i = 0; i < quantity; i++) {
1392             emit Transfer(address(0), to, updatedIndex);
1393             require(
1394                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1395                 "ERC721A: transfer to non ERC721Receiver implementer"
1396             );
1397             updatedIndex++;
1398         }
1399 
1400         currentIndex = updatedIndex;
1401         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1402     }
1403 
1404     /**
1405      * @dev Transfers `tokenId` from `from` to `to`.
1406      *
1407      * Requirements:
1408      *
1409      * - `to` cannot be the zero address.
1410      * - `tokenId` token must be owned by `from`.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function _transfer(
1415         address from,
1416         address to,
1417         uint256 tokenId
1418     ) private {
1419         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1420 
1421         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1422             getApproved(tokenId) == _msgSender() ||
1423             isApprovedForAll(prevOwnership.addr, _msgSender()));
1424 
1425         require(
1426             isApprovedOrOwner,
1427             "ERC721A: transfer caller is not owner nor approved"
1428         );
1429 
1430         require(
1431             prevOwnership.addr == from,
1432             "ERC721A: transfer from incorrect owner"
1433         );
1434         require(to != address(0), "ERC721A: transfer to the zero address");
1435 
1436         _beforeTokenTransfers(from, to, tokenId, 1);
1437 
1438         // Clear approvals from the previous owner
1439         _approve(address(0), tokenId, prevOwnership.addr);
1440 
1441         _addressData[from].balance -= 1;
1442         _addressData[to].balance += 1;
1443         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1444 
1445         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1446         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1447         uint256 nextTokenId = tokenId + 1;
1448         if (_ownerships[nextTokenId].addr == address(0)) {
1449             if (_exists(nextTokenId)) {
1450                 _ownerships[nextTokenId] = TokenOwnership(
1451                     prevOwnership.addr,
1452                     prevOwnership.startTimestamp
1453                 );
1454             }
1455         }
1456 
1457         emit Transfer(from, to, tokenId);
1458         _afterTokenTransfers(from, to, tokenId, 1);
1459     }
1460 
1461     /**
1462      * @dev Approve `to` to operate on `tokenId`
1463      *
1464      * Emits a {Approval} event.
1465      */
1466     function _approve(
1467         address to,
1468         uint256 tokenId,
1469         address owner
1470     ) private {
1471         _tokenApprovals[tokenId] = to;
1472         emit Approval(owner, to, tokenId);
1473     }
1474 
1475     uint256 public nextOwnerToExplicitlySet = 0;
1476 
1477     /**
1478      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1479      */
1480     function _setOwnersExplicit(uint256 quantity) internal {
1481         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1482         require(quantity > 0, "quantity must be nonzero");
1483         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1484         if (endIndex > collectionSize - 1) {
1485             endIndex = collectionSize - 1;
1486         }
1487         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1488         require(_exists(endIndex), "not enough minted yet for this cleanup");
1489         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1490             if (_ownerships[i].addr == address(0)) {
1491                 TokenOwnership memory ownership = ownershipOf(i);
1492                 _ownerships[i] = TokenOwnership(
1493                     ownership.addr,
1494                     ownership.startTimestamp
1495                 );
1496             }
1497         }
1498         nextOwnerToExplicitlySet = endIndex + 1;
1499     }
1500 
1501     /**
1502      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1503      * The call is not executed if the target address is not a contract.
1504      *
1505      * @param from address representing the previous owner of the given token ID
1506      * @param to target address that will receive the tokens
1507      * @param tokenId uint256 ID of the token to be transferred
1508      * @param _data bytes optional data to send along with the call
1509      * @return bool whether the call correctly returned the expected magic value
1510      */
1511     function _checkOnERC721Received(
1512         address from,
1513         address to,
1514         uint256 tokenId,
1515         bytes memory _data
1516     ) private returns (bool) {
1517         if (to.isContract()) {
1518             try
1519                 IERC721Receiver(to).onERC721Received(
1520                     _msgSender(),
1521                     from,
1522                     tokenId,
1523                     _data
1524                 )
1525             returns (bytes4 retval) {
1526                 return retval == IERC721Receiver(to).onERC721Received.selector;
1527             } catch (bytes memory reason) {
1528                 if (reason.length == 0) {
1529                     revert(
1530                         "ERC721A: transfer to non ERC721Receiver implementer"
1531                     );
1532                 } else {
1533                     assembly {
1534                         revert(add(32, reason), mload(reason))
1535                     }
1536                 }
1537             }
1538         } else {
1539             return true;
1540         }
1541     }
1542 
1543     /**
1544      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1545      *
1546      * startTokenId - the first token id to be transferred
1547      * quantity - the amount to be transferred
1548      *
1549      * Calling conditions:
1550      *
1551      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1552      * transferred to `to`.
1553      * - When `from` is zero, `tokenId` will be minted for `to`.
1554      */
1555     function _beforeTokenTransfers(
1556         address from,
1557         address to,
1558         uint256 startTokenId,
1559         uint256 quantity
1560     ) internal virtual {}
1561 
1562     /**
1563      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1564      * minting.
1565      *
1566      * startTokenId - the first token id to be transferred
1567      * quantity - the amount to be transferred
1568      *
1569      * Calling conditions:
1570      *
1571      * - when `from` and `to` are both non-zero.
1572      * - `from` and `to` are never both zero.
1573      */
1574     function _afterTokenTransfers(
1575         address from,
1576         address to,
1577         uint256 startTokenId,
1578         uint256 quantity
1579     ) internal virtual {}
1580 }
1581 
1582 // File: @openzeppelin/contracts/access/Ownable.sol
1583 
1584 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1585 
1586 pragma solidity ^0.8.0;
1587 
1588 /**
1589  * @dev Contract module which provides a basic access control mechanism, where
1590  * there is an account (an owner) that can be granted exclusive access to
1591  * specific functions.
1592  *
1593  * By default, the owner account will be the one that deploys the contract. This
1594  * can later be changed with {transferOwnership}.
1595  *
1596  * This module is used through inheritance. It will make available the modifier
1597  * `onlyOwner`, which can be applied to your functions to restrict their use to
1598  * the owner.
1599  */
1600 abstract contract Ownable is Context {
1601     address private _owner;
1602 
1603     event OwnershipTransferred(
1604         address indexed previousOwner,
1605         address indexed newOwner
1606     );
1607 
1608     /**
1609      * @dev Initializes the contract setting the deployer as the initial owner.
1610      */
1611     constructor() {
1612         _transferOwnership(_msgSender());
1613     }
1614 
1615     /**
1616      * @dev Returns the address of the current owner.
1617      */
1618     function owner() public view virtual returns (address) {
1619         return _owner;
1620     }
1621 
1622     /**
1623      * @dev Throws if called by any account other than the owner.
1624      */
1625     modifier onlyOwner() {
1626         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1627         _;
1628     }
1629 
1630     /**
1631      * @dev Leaves the contract without owner. It will not be possible to call
1632      * `onlyOwner` functions anymore. Can only be called by the current owner.
1633      *
1634      * NOTE: Renouncing ownership will leave the contract without an owner,
1635      * thereby removing any functionality that is only available to the owner.
1636      */
1637     function renounceOwnership() public virtual onlyOwner {
1638         _transferOwnership(address(0));
1639     }
1640 
1641     /**
1642      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1643      * Can only be called by the current owner.
1644      */
1645     function transferOwnership(address newOwner) public virtual onlyOwner {
1646         require(
1647             newOwner != address(0),
1648             "Ownable: new owner is the zero address"
1649         );
1650         _transferOwnership(newOwner);
1651     }
1652 
1653     /**
1654      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1655      * Internal function without access restriction.
1656      */
1657     function _transferOwnership(address newOwner) internal virtual {
1658         address oldOwner = _owner;
1659         _owner = newOwner;
1660         emit OwnershipTransferred(oldOwner, newOwner);
1661     }
1662 }
1663 
1664 pragma solidity ^0.8.0;
1665 
1666 contract FortuneDao is ERC721A, Ownable, ReentrancyGuard {
1667     using ECDSA for bytes32;
1668 
1669     enum Status {
1670         Paused,
1671         WhitelistSale,
1672         PublicSale,
1673         Finished
1674     }
1675 
1676     Status public status;
1677     string public baseURI;
1678     string[] public baseURISet;
1679     address private _signer;
1680     address public marketingWallet;
1681     address public urlFlipper;
1682     uint256 public tokensReserved;
1683     uint256 public immutable maxMint;
1684     uint256 public immutable maxSupply;
1685     uint256 public immutable reserveAmount;
1686     uint256 public PRICE = 0.088 * 10**18; // 0.088 ETH
1687 
1688     mapping(address => bool) public publicMinted;
1689     mapping(address => bool) public whitelistMinted;
1690 
1691     event Minted(address minter, uint256 amount);
1692     event StatusChanged(Status status);
1693     event SignerChanged(address signer);
1694     event ReservedToken(address minter, address recipient, uint256 amount);
1695     event BaseURIChanged(string newBaseURI);
1696 
1697     constructor(
1698         string memory initBaseURI,
1699         address signer,
1700         address _marketingWallet,
1701         address _urlFlipper,
1702         uint256 _maxMint,
1703         uint256 _maxSupply,
1704         uint256 _reserveAmount
1705     ) ERC721A("FortuneDao", "Fortune", 66, _maxSupply) {
1706         baseURI = initBaseURI;
1707         _signer = signer;
1708         marketingWallet = _marketingWallet;
1709         urlFlipper = _urlFlipper;
1710         maxMint = _maxMint;
1711         maxSupply = _maxSupply;
1712         reserveAmount = _reserveAmount;
1713     }
1714 
1715     modifier onlyURLFlipper() {
1716         require(urlFlipper == _msgSender(), "Caller is not the url flipper");
1717         _;
1718     }
1719 
1720     function _hash(uint256 amount, address _address)
1721         public
1722         view
1723         returns (bytes32)
1724     {
1725         return keccak256(abi.encode(Strings.toString(amount), address(this), _address));
1726     }
1727 
1728     function _verify(bytes32 hash, bytes memory signature)
1729         internal
1730         view
1731         returns (bool)
1732     {
1733         return (_recover(hash, signature) == _signer);
1734     }
1735 
1736     function _recover(bytes32 hash, bytes memory signature)
1737         internal
1738         pure
1739         returns (address)
1740     {
1741         return hash.toEthSignedMessageHash().recover(signature);
1742     }
1743 
1744     function _baseURI() internal view override returns (string memory) {
1745         return baseURI;
1746     }
1747 
1748     function getBaseURISet() public view returns (string[] memory) {
1749         return baseURISet;
1750     }
1751 
1752     function reserve(address recipient, uint256 amount) external onlyOwner {
1753         require(amount > 0, "Amount too low");
1754         require(
1755             totalSupply() + amount <= collectionSize,
1756             "Max supply exceeded"
1757         );
1758         require(
1759             tokensReserved + amount <= reserveAmount,
1760             "Max reserve amount exceeded"
1761         );
1762 
1763         _safeMint(recipient, amount);
1764         tokensReserved += amount;
1765         emit ReservedToken(msg.sender, recipient, amount);
1766     }
1767 
1768     function whitelistMint(uint256 amount, bytes calldata signature)
1769         external
1770         payable
1771     {
1772         require(status == Status.WhitelistSale, "WhitelistSale is not active.");
1773         require(!whitelistMinted[msg.sender], "Already minted.");
1774         require(
1775             _verify(_hash(amount, msg.sender), signature),
1776             "Invalid signature."
1777         );
1778         require(PRICE * amount == msg.value, "Price incorrect.");
1779         require(
1780             numberMinted(msg.sender) + amount <= maxMint,
1781             "Max mint amount per wallet exceeded."
1782         );
1783         require(
1784             totalSupply() + amount + reserveAmount - tokensReserved <=
1785                 collectionSize,
1786             "Max supply exceeded."
1787         );
1788         require(tx.origin == msg.sender, "Contract is not allowed to mint.");
1789         
1790         whitelistMinted[msg.sender] = true;
1791         _safeMint(msg.sender, amount);
1792 
1793         emit Minted(msg.sender, amount);
1794     }
1795 
1796     function mint() external payable {
1797         require(status == Status.PublicSale, "Public sale is not active.");
1798         require(tx.origin == msg.sender, "Contract is not allowed to mint.");
1799         require(!publicMinted[msg.sender], "Already minted.");
1800         require(
1801             totalSupply() + 1 + reserveAmount - tokensReserved <=
1802                 collectionSize,
1803             "Max supply exceeded."
1804         );
1805         require(PRICE == msg.value, "Price incorrect.");
1806 
1807         publicMinted[msg.sender] = true;
1808         _safeMint(msg.sender, 1);
1809 
1810         emit Minted(msg.sender, 1);
1811     }
1812 
1813     function withdraw() external nonReentrant onlyOwner {
1814         uint256 balance = address(this).balance;
1815         (bool success1, ) = payable(marketingWallet).call{value: balance}("");
1816         require(success1, "Transfer failed.");
1817     }
1818 
1819     function setPRICE(uint256 newPRICE) external onlyOwner {
1820         PRICE = newPRICE;
1821     }
1822 
1823     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1824         baseURI = newBaseURI;
1825         emit BaseURIChanged(newBaseURI);
1826     }
1827 
1828     function flipBaseURI(uint256 index) external onlyURLFlipper {
1829         require(index < baseURISet.length, "Index out of bound.");
1830         baseURI = baseURISet[index];
1831         emit BaseURIChanged(baseURI);
1832     }
1833 
1834     function setBaseURISet(string[] memory newBaseURISet) external onlyOwner {
1835         baseURISet = newBaseURISet;
1836     }
1837 
1838     function setStatus(Status _status) external onlyOwner {
1839         status = _status;
1840         emit StatusChanged(_status);
1841     }
1842 
1843     function setSigner(address signer) external onlyOwner {
1844         _signer = signer;
1845         emit SignerChanged(signer);
1846     }
1847 
1848     function setURLFlipper(address newUrlFlipper) external onlyOwner {
1849         urlFlipper = newUrlFlipper;
1850     }
1851 
1852     function setMarketingWallet(address newMarketingWallet) external onlyOwner {
1853         marketingWallet = newMarketingWallet;
1854     }
1855 
1856     function setOwnersExplicit(uint256 quantity)
1857         external
1858         onlyOwner
1859         nonReentrant
1860     {
1861         _setOwnersExplicit(quantity);
1862     }
1863 
1864     function numberMinted(address owner) public view returns (uint256) {
1865         return _numberMinted(owner);
1866     }
1867 
1868     function getOwnershipData(uint256 tokenId)
1869         external
1870         view
1871         returns (TokenOwnership memory)
1872     {
1873         return ownershipOf(tokenId);
1874     }
1875 }