1 // File: contracts/interfaces/IMintableERC721.sol
2 
3 
4 pragma solidity ^0.8.10;
5 
6 interface IMintableERC721 {
7 	/**
8 	 * @notice Checks if specified token exists
9 	 *
10 	 * @dev Returns whether the specified token ID has an ownership
11 	 *      information associated with it
12 	 *
13 	 * @param _tokenId ID of the token to query existence for
14 	 * @return whether the token exists (true - exists, false - doesn't exist)
15 	 */
16 	function exists(uint256 _tokenId) external view returns(bool);
17 
18 	/**
19 	 * @dev Creates new token with token ID specified
20 	 *      and assigns an ownership `_to` for this token
21 	 *
22 	 * @dev Unsafe: doesn't execute `onERC721Received` on the receiver.
23 	 *      Prefer the use of `saveMint` instead of `mint`.
24 	 *
25 	 * @dev Should have a restricted access handled by the implementation
26 	 *
27 	 * @param _to an address to mint token to
28 	 * @param _tokenId ID of the token to mint
29 	 */
30 	function mint(address _to, uint256 _tokenId) external;
31 
32 	/**
33 	 * @dev Creates new tokens starting with token ID specified
34 	 *      and assigns an ownership `_to` for these tokens
35 	 *
36 	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
37 	 *
38 	 * @dev n must be greater or equal 2: `n > 1`
39 	 *
40 	 * @dev Unsafe: doesn't execute `onERC721Received` on the receiver.
41 	 *      Prefer the use of `saveMintBatch` instead of `mintBatch`.
42 	 *
43 	 * @dev Should have a restricted access handled by the implementation
44 	 *
45 	 * @param _to an address to mint tokens to
46 	 * @param _tokenId ID of the first token to mint
47 	 * @param n how many tokens to mint, sequentially increasing the _tokenId
48 	 */
49 	function mintBatch(address _to, uint256 _tokenId, uint256 n) external;
50 
51 	/**
52 	 * @dev Creates new token with token ID specified
53 	 *      and assigns an ownership `_to` for this token
54 	 *
55 	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
56 	 *      `onERC721Received` on `_to` and throws if the return value is not
57 	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
58 	 *
59 	 * @dev Should have a restricted access handled by the implementation
60 	 *
61 	 * @param _to an address to mint token to
62 	 * @param _tokenId ID of the token to mint
63 	 */
64 	function safeMint(address _to, uint256 _tokenId) external;
65 
66 	/**
67 	 * @dev Creates new token with token ID specified
68 	 *      and assigns an ownership `_to` for this token
69 	 *
70 	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
71 	 *      `onERC721Received` on `_to` and throws if the return value is not
72 	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
73 	 *
74 	 * @dev Should have a restricted access handled by the implementation
75 	 *
76 	 * @param _to an address to mint token to
77 	 * @param _tokenId ID of the token to mint
78 	 * @param _data additional data with no specified format, sent in call to `_to`
79 	 */
80 	function safeMint(address _to, uint256 _tokenId, bytes memory _data) external;
81 
82 	/**
83 	 * @dev Creates new tokens starting with token ID specified
84 	 *      and assigns an ownership `_to` for these tokens
85 	 *
86 	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
87 	 *
88 	 * @dev n must be greater or equal 2: `n > 1`
89 	 *
90 	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
91 	 *      `onERC721Received` on `_to` and throws if the return value is not
92 	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
93 	 *
94 	 * @dev Should have a restricted access handled by the implementation
95 	 *
96 	 * @param _to an address to mint token to
97 	 * @param _tokenId ID of the token to mint
98 	 * @param n how many tokens to mint, sequentially increasing the _tokenId
99 	 */
100 	function safeMintBatch(address _to, uint256 _tokenId, uint256 n) external;
101 
102 	/**
103 	 * @dev Creates new tokens starting with token ID specified
104 	 *      and assigns an ownership `_to` for these tokens
105 	 *
106 	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
107 	 *
108 	 * @dev n must be greater or equal 2: `n > 1`
109 	 *
110 	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
111 	 *      `onERC721Received` on `_to` and throws if the return value is not
112 	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
113 	 *
114 	 * @dev Should have a restricted access handled by the implementation
115 	 *
116 	 * @param _to an address to mint token to
117 	 * @param _tokenId ID of the token to mint
118 	 * @param n how many tokens to mint, sequentially increasing the _tokenId
119 	 * @param _data additional data with no specified format, sent in call to `_to`
120 	 */
121 	function safeMintBatch(address _to, uint256 _tokenId, uint256 n, bytes memory _data) external;
122 }
123 // File: @openzeppelin/contracts/utils/Address.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Collection of functions related to the address type
132  */
133 library Address {
134     /**
135      * @dev Returns true if `account` is a contract.
136      *
137      * [IMPORTANT]
138      * ====
139      * It is unsafe to assume that an address for which this function returns
140      * false is an externally-owned account (EOA) and not a contract.
141      *
142      * Among others, `isContract` will return false for the following
143      * types of addresses:
144      *
145      *  - an externally-owned account
146      *  - a contract in construction
147      *  - an address where a contract will be created
148      *  - an address where a contract lived, but was destroyed
149      * ====
150      */
151     function isContract(address account) internal view returns (bool) {
152         // This method relies on extcodesize, which returns 0 for contracts in
153         // construction, since the code is only stored at the end of the
154         // constructor execution.
155 
156         uint256 size;
157         assembly {
158             size := extcodesize(account)
159         }
160         return size > 0;
161     }
162 
163     /**
164      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
165      * `recipient`, forwarding all available gas and reverting on errors.
166      *
167      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
168      * of certain opcodes, possibly making contracts go over the 2300 gas limit
169      * imposed by `transfer`, making them unable to receive funds via
170      * `transfer`. {sendValue} removes this limitation.
171      *
172      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
173      *
174      * IMPORTANT: because control is transferred to `recipient`, care must be
175      * taken to not create reentrancy vulnerabilities. Consider using
176      * {ReentrancyGuard} or the
177      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
178      */
179     function sendValue(address payable recipient, uint256 amount) internal {
180         require(address(this).balance >= amount, "Address: insufficient balance");
181 
182         (bool success, ) = recipient.call{value: amount}("");
183         require(success, "Address: unable to send value, recipient may have reverted");
184     }
185 
186     /**
187      * @dev Performs a Solidity function call using a low level `call`. A
188      * plain `call` is an unsafe replacement for a function call: use this
189      * function instead.
190      *
191      * If `target` reverts with a revert reason, it is bubbled up by this
192      * function (like regular Solidity function calls).
193      *
194      * Returns the raw returned data. To convert to the expected return value,
195      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
196      *
197      * Requirements:
198      *
199      * - `target` must be a contract.
200      * - calling `target` with `data` must not revert.
201      *
202      * _Available since v3.1._
203      */
204     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
205         return functionCall(target, data, "Address: low-level call failed");
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
210      * `errorMessage` as a fallback revert reason when `target` reverts.
211      *
212      * _Available since v3.1._
213      */
214     function functionCall(
215         address target,
216         bytes memory data,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         return functionCallWithValue(target, data, 0, errorMessage);
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
224      * but also transferring `value` wei to `target`.
225      *
226      * Requirements:
227      *
228      * - the calling contract must have an ETH balance of at least `value`.
229      * - the called Solidity function must be `payable`.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(
234         address target,
235         bytes memory data,
236         uint256 value
237     ) internal returns (bytes memory) {
238         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
243      * with `errorMessage` as a fallback revert reason when `target` reverts.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         require(address(this).balance >= value, "Address: insufficient balance for call");
254         require(isContract(target), "Address: call to non-contract");
255 
256         (bool success, bytes memory returndata) = target.call{value: value}(data);
257         return verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a static call.
263      *
264      * _Available since v3.3._
265      */
266     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
267         return functionStaticCall(target, data, "Address: low-level static call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal view returns (bytes memory) {
281         require(isContract(target), "Address: static call to non-contract");
282 
283         (bool success, bytes memory returndata) = target.staticcall(data);
284         return verifyCallResult(success, returndata, errorMessage);
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
289      * but performing a delegate call.
290      *
291      * _Available since v3.4._
292      */
293     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
294         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
299      * but performing a delegate call.
300      *
301      * _Available since v3.4._
302      */
303     function functionDelegateCall(
304         address target,
305         bytes memory data,
306         string memory errorMessage
307     ) internal returns (bytes memory) {
308         require(isContract(target), "Address: delegate call to non-contract");
309 
310         (bool success, bytes memory returndata) = target.delegatecall(data);
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
316      * revert reason using the provided one.
317      *
318      * _Available since v4.3._
319      */
320     function verifyCallResult(
321         bool success,
322         bytes memory returndata,
323         string memory errorMessage
324     ) internal pure returns (bytes memory) {
325         if (success) {
326             return returndata;
327         } else {
328             // Look for revert reason and bubble it up if present
329             if (returndata.length > 0) {
330                 // The easiest way to bubble the revert reason is using memory via assembly
331 
332                 assembly {
333                     let returndata_size := mload(returndata)
334                     revert(add(32, returndata), returndata_size)
335                 }
336             } else {
337                 revert(errorMessage);
338             }
339         }
340     }
341 }
342 
343 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @title ERC721 token receiver interface
352  * @dev Interface for any contract that wants to support safeTransfers
353  * from ERC721 asset contracts.
354  */
355 interface IERC721Receiver {
356     /**
357      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
358      * by `operator` from `from`, this function is called.
359      *
360      * It must return its Solidity selector to confirm the token transfer.
361      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
362      *
363      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
364      */
365     function onERC721Received(
366         address operator,
367         address from,
368         uint256 tokenId,
369         bytes calldata data
370     ) external returns (bytes4);
371 }
372 
373 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Interface of the ERC165 standard, as defined in the
382  * https://eips.ethereum.org/EIPS/eip-165[EIP].
383  *
384  * Implementers can declare support of contract interfaces, which can then be
385  * queried by others ({ERC165Checker}).
386  *
387  * For an implementation, see {ERC165}.
388  */
389 interface IERC165 {
390     /**
391      * @dev Returns true if this contract implements the interface defined by
392      * `interfaceId`. See the corresponding
393      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
394      * to learn more about how these ids are created.
395      *
396      * This function call must use less than 30 000 gas.
397      */
398     function supportsInterface(bytes4 interfaceId) external view returns (bool);
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
402 
403 
404 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 
409 /**
410  * @dev Required interface of an ERC721 compliant contract.
411  */
412 interface IERC721 is IERC165 {
413     /**
414      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
415      */
416     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
417 
418     /**
419      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
420      */
421     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
422 
423     /**
424      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
425      */
426     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
427 
428     /**
429      * @dev Returns the number of tokens in ``owner``'s account.
430      */
431     function balanceOf(address owner) external view returns (uint256 balance);
432 
433     /**
434      * @dev Returns the owner of the `tokenId` token.
435      *
436      * Requirements:
437      *
438      * - `tokenId` must exist.
439      */
440     function ownerOf(uint256 tokenId) external view returns (address owner);
441 
442     /**
443      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
444      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
445      *
446      * Requirements:
447      *
448      * - `from` cannot be the zero address.
449      * - `to` cannot be the zero address.
450      * - `tokenId` token must exist and be owned by `from`.
451      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
452      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
453      *
454      * Emits a {Transfer} event.
455      */
456     function safeTransferFrom(
457         address from,
458         address to,
459         uint256 tokenId
460     ) external;
461 
462     /**
463      * @dev Transfers `tokenId` token from `from` to `to`.
464      *
465      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
466      *
467      * Requirements:
468      *
469      * - `from` cannot be the zero address.
470      * - `to` cannot be the zero address.
471      * - `tokenId` token must be owned by `from`.
472      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
473      *
474      * Emits a {Transfer} event.
475      */
476     function transferFrom(
477         address from,
478         address to,
479         uint256 tokenId
480     ) external;
481 
482     /**
483      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
484      * The approval is cleared when the token is transferred.
485      *
486      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
487      *
488      * Requirements:
489      *
490      * - The caller must own the token or be an approved operator.
491      * - `tokenId` must exist.
492      *
493      * Emits an {Approval} event.
494      */
495     function approve(address to, uint256 tokenId) external;
496 
497     /**
498      * @dev Returns the account approved for `tokenId` token.
499      *
500      * Requirements:
501      *
502      * - `tokenId` must exist.
503      */
504     function getApproved(uint256 tokenId) external view returns (address operator);
505 
506     /**
507      * @dev Approve or remove `operator` as an operator for the caller.
508      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
509      *
510      * Requirements:
511      *
512      * - The `operator` cannot be the caller.
513      *
514      * Emits an {ApprovalForAll} event.
515      */
516     function setApprovalForAll(address operator, bool _approved) external;
517 
518     /**
519      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
520      *
521      * See {setApprovalForAll}
522      */
523     function isApprovedForAll(address owner, address operator) external view returns (bool);
524 
525     /**
526      * @dev Safely transfers `tokenId` token from `from` to `to`.
527      *
528      * Requirements:
529      *
530      * - `from` cannot be the zero address.
531      * - `to` cannot be the zero address.
532      * - `tokenId` token must exist and be owned by `from`.
533      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
534      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
535      *
536      * Emits a {Transfer} event.
537      */
538     function safeTransferFrom(
539         address from,
540         address to,
541         uint256 tokenId,
542         bytes calldata data
543     ) external;
544 }
545 
546 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
556  * @dev See https://eips.ethereum.org/EIPS/eip-721
557  */
558 interface IERC721Metadata is IERC721 {
559     /**
560      * @dev Returns the token collection name.
561      */
562     function name() external view returns (string memory);
563 
564     /**
565      * @dev Returns the token collection symbol.
566      */
567     function symbol() external view returns (string memory);
568 
569     /**
570      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
571      */
572     function tokenURI(uint256 tokenId) external view returns (string memory);
573 }
574 
575 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
576 
577 
578 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @dev Implementation of the {IERC165} interface.
585  *
586  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
587  * for the additional interface id that will be supported. For example:
588  *
589  * ```solidity
590  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
591  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
592  * }
593  * ```
594  *
595  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
596  */
597 abstract contract ERC165 is IERC165 {
598     /**
599      * @dev See {IERC165-supportsInterface}.
600      */
601     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602         return interfaceId == type(IERC165).interfaceId;
603     }
604 }
605 
606 // File: @openzeppelin/contracts/utils/Strings.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev String operations.
615  */
616 library Strings {
617     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
618 
619     /**
620      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
621      */
622     function toString(uint256 value) internal pure returns (string memory) {
623         // Inspired by OraclizeAPI's implementation - MIT licence
624         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
625 
626         if (value == 0) {
627             return "0";
628         }
629         uint256 temp = value;
630         uint256 digits;
631         while (temp != 0) {
632             digits++;
633             temp /= 10;
634         }
635         bytes memory buffer = new bytes(digits);
636         while (value != 0) {
637             digits -= 1;
638             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
639             value /= 10;
640         }
641         return string(buffer);
642     }
643 
644     /**
645      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
646      */
647     function toHexString(uint256 value) internal pure returns (string memory) {
648         if (value == 0) {
649             return "0x00";
650         }
651         uint256 temp = value;
652         uint256 length = 0;
653         while (temp != 0) {
654             length++;
655             temp >>= 8;
656         }
657         return toHexString(value, length);
658     }
659 
660     /**
661      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
662      */
663     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
664         bytes memory buffer = new bytes(2 * length + 2);
665         buffer[0] = "0";
666         buffer[1] = "x";
667         for (uint256 i = 2 * length + 1; i > 1; --i) {
668             buffer[i] = _HEX_SYMBOLS[value & 0xf];
669             value >>= 4;
670         }
671         require(value == 0, "Strings: hex length insufficient");
672         return string(buffer);
673     }
674 }
675 
676 // File: @openzeppelin/contracts/utils/Context.sol
677 
678 
679 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
680 
681 pragma solidity ^0.8.0;
682 
683 /**
684  * @dev Provides information about the current execution context, including the
685  * sender of the transaction and its data. While these are generally available
686  * via msg.sender and msg.data, they should not be accessed in such a direct
687  * manner, since when dealing with meta-transactions the account sending and
688  * paying for execution may not be the actual sender (as far as an application
689  * is concerned).
690  *
691  * This contract is only required for intermediate, library-like contracts.
692  */
693 abstract contract Context {
694     function _msgSender() internal view virtual returns (address) {
695         return msg.sender;
696     }
697 
698     function _msgData() internal view virtual returns (bytes calldata) {
699         return msg.data;
700     }
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
704 
705 
706 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
707 
708 pragma solidity ^0.8.0;
709 
710 
711 
712 
713 
714 
715 
716 
717 /**
718  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
719  * the Metadata extension, but not including the Enumerable extension, which is available separately as
720  * {ERC721Enumerable}.
721  */
722 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
723     using Address for address;
724     using Strings for uint256;
725 
726     // Token name
727     string private _name;
728 
729     // Token symbol
730     string private _symbol;
731 
732     // Mapping from token ID to owner address
733     mapping(uint256 => address) private _owners;
734 
735     // Mapping owner address to token count
736     mapping(address => uint256) private _balances;
737 
738     // Mapping from token ID to approved address
739     mapping(uint256 => address) private _tokenApprovals;
740 
741     // Mapping from owner to operator approvals
742     mapping(address => mapping(address => bool)) private _operatorApprovals;
743 
744     /**
745      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
746      */
747     constructor(string memory name_, string memory symbol_) {
748         _name = name_;
749         _symbol = symbol_;
750     }
751 
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
756         return
757             interfaceId == type(IERC721).interfaceId ||
758             interfaceId == type(IERC721Metadata).interfaceId ||
759             super.supportsInterface(interfaceId);
760     }
761 
762     /**
763      * @dev See {IERC721-balanceOf}.
764      */
765     function balanceOf(address owner) public view virtual override returns (uint256) {
766         require(owner != address(0), "ERC721: balance query for the zero address");
767         return _balances[owner];
768     }
769 
770     /**
771      * @dev See {IERC721-ownerOf}.
772      */
773     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
774         address owner = _owners[tokenId];
775         require(owner != address(0), "ERC721: owner query for nonexistent token");
776         return owner;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-name}.
781      */
782     function name() public view virtual override returns (string memory) {
783         return _name;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-symbol}.
788      */
789     function symbol() public view virtual override returns (string memory) {
790         return _symbol;
791     }
792 
793     /**
794      * @dev See {IERC721Metadata-tokenURI}.
795      */
796     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
797         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
798 
799         string memory baseURI = _baseURI();
800         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
801     }
802 
803     /**
804      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
805      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
806      * by default, can be overriden in child contracts.
807      */
808     function _baseURI() internal view virtual returns (string memory) {
809         return "";
810     }
811 
812     /**
813      * @dev See {IERC721-approve}.
814      */
815     function approve(address to, uint256 tokenId) public virtual override {
816         address owner = ERC721.ownerOf(tokenId);
817         require(to != owner, "ERC721: approval to current owner");
818 
819         require(
820             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
821             "ERC721: approve caller is not owner nor approved for all"
822         );
823 
824         _approve(to, tokenId);
825     }
826 
827     /**
828      * @dev See {IERC721-getApproved}.
829      */
830     function getApproved(uint256 tokenId) public view virtual override returns (address) {
831         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
832 
833         return _tokenApprovals[tokenId];
834     }
835 
836     /**
837      * @dev See {IERC721-setApprovalForAll}.
838      */
839     function setApprovalForAll(address operator, bool approved) public virtual override {
840         _setApprovalForAll(_msgSender(), operator, approved);
841     }
842 
843     /**
844      * @dev See {IERC721-isApprovedForAll}.
845      */
846     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
847         return _operatorApprovals[owner][operator];
848     }
849 
850     /**
851      * @dev See {IERC721-transferFrom}.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 tokenId
857     ) public virtual override {
858         //solhint-disable-next-line max-line-length
859         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
860 
861         _transfer(from, to, tokenId);
862     }
863 
864     /**
865      * @dev See {IERC721-safeTransferFrom}.
866      */
867     function safeTransferFrom(
868         address from,
869         address to,
870         uint256 tokenId
871     ) public virtual override {
872         safeTransferFrom(from, to, tokenId, "");
873     }
874 
875     /**
876      * @dev See {IERC721-safeTransferFrom}.
877      */
878     function safeTransferFrom(
879         address from,
880         address to,
881         uint256 tokenId,
882         bytes memory _data
883     ) public virtual override {
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885         _safeTransfer(from, to, tokenId, _data);
886     }
887 
888     /**
889      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
890      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
891      *
892      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
893      *
894      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
895      * implement alternative mechanisms to perform token transfer, such as signature-based.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeTransfer(
907         address from,
908         address to,
909         uint256 tokenId,
910         bytes memory _data
911     ) internal virtual {
912         _transfer(from, to, tokenId);
913         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
914     }
915 
916     /**
917      * @dev Returns whether `tokenId` exists.
918      *
919      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
920      *
921      * Tokens start existing when they are minted (`_mint`),
922      * and stop existing when they are burned (`_burn`).
923      */
924     function _exists(uint256 tokenId) internal view virtual returns (bool) {
925         return _owners[tokenId] != address(0);
926     }
927 
928     /**
929      * @dev Returns whether `spender` is allowed to manage `tokenId`.
930      *
931      * Requirements:
932      *
933      * - `tokenId` must exist.
934      */
935     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
936         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
937         address owner = ERC721.ownerOf(tokenId);
938         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
939     }
940 
941     /**
942      * @dev Safely mints `tokenId` and transfers it to `to`.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must not exist.
947      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
948      *
949      * Emits a {Transfer} event.
950      */
951     function _safeMint(address to, uint256 tokenId) internal virtual {
952         _safeMint(to, tokenId, "");
953     }
954 
955     /**
956      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
957      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
958      */
959     function _safeMint(
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) internal virtual {
964         _mint(to, tokenId);
965         require(
966             _checkOnERC721Received(address(0), to, tokenId, _data),
967             "ERC721: transfer to non ERC721Receiver implementer"
968         );
969     }
970 
971     /**
972      * @dev Mints `tokenId` and transfers it to `to`.
973      *
974      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
975      *
976      * Requirements:
977      *
978      * - `tokenId` must not exist.
979      * - `to` cannot be the zero address.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _mint(address to, uint256 tokenId) internal virtual {
984         require(to != address(0), "ERC721: mint to the zero address");
985         require(!_exists(tokenId), "ERC721: token already minted");
986 
987         _beforeTokenTransfer(address(0), to, tokenId);
988 
989         _balances[to] += 1;
990         _owners[tokenId] = to;
991 
992         emit Transfer(address(0), to, tokenId);
993     }
994 
995     /**
996      * @dev Destroys `tokenId`.
997      * The approval is cleared when the token is burned.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must exist.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _burn(uint256 tokenId) internal virtual {
1006         address owner = ERC721.ownerOf(tokenId);
1007 
1008         _beforeTokenTransfer(owner, address(0), tokenId);
1009 
1010         // Clear approvals
1011         _approve(address(0), tokenId);
1012 
1013         _balances[owner] -= 1;
1014         delete _owners[tokenId];
1015 
1016         emit Transfer(owner, address(0), tokenId);
1017     }
1018 
1019     /**
1020      * @dev Transfers `tokenId` from `from` to `to`.
1021      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1022      *
1023      * Requirements:
1024      *
1025      * - `to` cannot be the zero address.
1026      * - `tokenId` token must be owned by `from`.
1027      *
1028      * Emits a {Transfer} event.
1029      */
1030     function _transfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual {
1035         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1036         require(to != address(0), "ERC721: transfer to the zero address");
1037 
1038         _beforeTokenTransfer(from, to, tokenId);
1039 
1040         // Clear approvals from the previous owner
1041         _approve(address(0), tokenId);
1042 
1043         _balances[from] -= 1;
1044         _balances[to] += 1;
1045         _owners[tokenId] = to;
1046 
1047         emit Transfer(from, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Approve `to` to operate on `tokenId`
1052      *
1053      * Emits a {Approval} event.
1054      */
1055     function _approve(address to, uint256 tokenId) internal virtual {
1056         _tokenApprovals[tokenId] = to;
1057         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev Approve `operator` to operate on all of `owner` tokens
1062      *
1063      * Emits a {ApprovalForAll} event.
1064      */
1065     function _setApprovalForAll(
1066         address owner,
1067         address operator,
1068         bool approved
1069     ) internal virtual {
1070         require(owner != operator, "ERC721: approve to caller");
1071         _operatorApprovals[owner][operator] = approved;
1072         emit ApprovalForAll(owner, operator, approved);
1073     }
1074 
1075     /**
1076      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1077      * The call is not executed if the target address is not a contract.
1078      *
1079      * @param from address representing the previous owner of the given token ID
1080      * @param to target address that will receive the tokens
1081      * @param tokenId uint256 ID of the token to be transferred
1082      * @param _data bytes optional data to send along with the call
1083      * @return bool whether the call correctly returned the expected magic value
1084      */
1085     function _checkOnERC721Received(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) private returns (bool) {
1091         if (to.isContract()) {
1092             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1093                 return retval == IERC721Receiver.onERC721Received.selector;
1094             } catch (bytes memory reason) {
1095                 if (reason.length == 0) {
1096                     revert("ERC721: transfer to non ERC721Receiver implementer");
1097                 } else {
1098                     assembly {
1099                         revert(add(32, reason), mload(reason))
1100                     }
1101                 }
1102             }
1103         } else {
1104             return true;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Hook that is called before any token transfer. This includes minting
1110      * and burning.
1111      *
1112      * Calling conditions:
1113      *
1114      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1115      * transferred to `to`.
1116      * - When `from` is zero, `tokenId` will be minted for `to`.
1117      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1118      * - `from` and `to` are never both zero.
1119      *
1120      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1121      */
1122     function _beforeTokenTransfer(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) internal virtual {}
1127 }
1128 
1129 // File: @openzeppelin/contracts/access/Ownable.sol
1130 
1131 
1132 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1133 
1134 pragma solidity ^0.8.0;
1135 
1136 
1137 /**
1138  * @dev Contract module which provides a basic access control mechanism, where
1139  * there is an account (an owner) that can be granted exclusive access to
1140  * specific functions.
1141  *
1142  * By default, the owner account will be the one that deploys the contract. This
1143  * can later be changed with {transferOwnership}.
1144  *
1145  * This module is used through inheritance. It will make available the modifier
1146  * `onlyOwner`, which can be applied to your functions to restrict their use to
1147  * the owner.
1148  */
1149 abstract contract Ownable is Context {
1150     address private _owner;
1151 
1152     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1153 
1154     /**
1155      * @dev Initializes the contract setting the deployer as the initial owner.
1156      */
1157     constructor() {
1158         _transferOwnership(_msgSender());
1159     }
1160 
1161     /**
1162      * @dev Returns the address of the current owner.
1163      */
1164     function owner() public view virtual returns (address) {
1165         return _owner;
1166     }
1167 
1168     /**
1169      * @dev Throws if called by any account other than the owner.
1170      */
1171     modifier onlyOwner() {
1172         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1173         _;
1174     }
1175 
1176     /**
1177      * @dev Leaves the contract without owner. It will not be possible to call
1178      * `onlyOwner` functions anymore. Can only be called by the current owner.
1179      *
1180      * NOTE: Renouncing ownership will leave the contract without an owner,
1181      * thereby removing any functionality that is only available to the owner.
1182      */
1183     function renounceOwnership() public virtual onlyOwner {
1184         _transferOwnership(address(0));
1185     }
1186 
1187     /**
1188      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1189      * Can only be called by the current owner.
1190      */
1191     function transferOwnership(address newOwner) public virtual onlyOwner {
1192         require(newOwner != address(0), "Ownable: new owner is the zero address");
1193         _transferOwnership(newOwner);
1194     }
1195 
1196     /**
1197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1198      * Internal function without access restriction.
1199      */
1200     function _transferOwnership(address newOwner) internal virtual {
1201         address oldOwner = _owner;
1202         _owner = newOwner;
1203         emit OwnershipTransferred(oldOwner, newOwner);
1204     }
1205 }
1206 
1207 // File: @openzeppelin/contracts/access/IAccessControl.sol
1208 
1209 
1210 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 /**
1215  * @dev External interface of AccessControl declared to support ERC165 detection.
1216  */
1217 interface IAccessControl {
1218     /**
1219      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1220      *
1221      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1222      * {RoleAdminChanged} not being emitted signaling this.
1223      *
1224      * _Available since v3.1._
1225      */
1226     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1227 
1228     /**
1229      * @dev Emitted when `account` is granted `role`.
1230      *
1231      * `sender` is the account that originated the contract call, an admin role
1232      * bearer except when using {AccessControl-_setupRole}.
1233      */
1234     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1235 
1236     /**
1237      * @dev Emitted when `account` is revoked `role`.
1238      *
1239      * `sender` is the account that originated the contract call:
1240      *   - if using `revokeRole`, it is the admin role bearer
1241      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1242      */
1243     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1244 
1245     /**
1246      * @dev Returns `true` if `account` has been granted `role`.
1247      */
1248     function hasRole(bytes32 role, address account) external view returns (bool);
1249 
1250     /**
1251      * @dev Returns the admin role that controls `role`. See {grantRole} and
1252      * {revokeRole}.
1253      *
1254      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1255      */
1256     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1257 
1258     /**
1259      * @dev Grants `role` to `account`.
1260      *
1261      * If `account` had not been already granted `role`, emits a {RoleGranted}
1262      * event.
1263      *
1264      * Requirements:
1265      *
1266      * - the caller must have ``role``'s admin role.
1267      */
1268     function grantRole(bytes32 role, address account) external;
1269 
1270     /**
1271      * @dev Revokes `role` from `account`.
1272      *
1273      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1274      *
1275      * Requirements:
1276      *
1277      * - the caller must have ``role``'s admin role.
1278      */
1279     function revokeRole(bytes32 role, address account) external;
1280 
1281     /**
1282      * @dev Revokes `role` from the calling account.
1283      *
1284      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1285      * purpose is to provide a mechanism for accounts to lose their privileges
1286      * if they are compromised (such as when a trusted device is misplaced).
1287      *
1288      * If the calling account had been granted `role`, emits a {RoleRevoked}
1289      * event.
1290      *
1291      * Requirements:
1292      *
1293      * - the caller must be `account`.
1294      */
1295     function renounceRole(bytes32 role, address account) external;
1296 }
1297 
1298 // File: @openzeppelin/contracts/access/AccessControl.sol
1299 
1300 
1301 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
1302 
1303 pragma solidity ^0.8.0;
1304 
1305 
1306 
1307 
1308 
1309 /**
1310  * @dev Contract module that allows children to implement role-based access
1311  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1312  * members except through off-chain means by accessing the contract event logs. Some
1313  * applications may benefit from on-chain enumerability, for those cases see
1314  * {AccessControlEnumerable}.
1315  *
1316  * Roles are referred to by their `bytes32` identifier. These should be exposed
1317  * in the external API and be unique. The best way to achieve this is by
1318  * using `public constant` hash digests:
1319  *
1320  * ```
1321  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1322  * ```
1323  *
1324  * Roles can be used to represent a set of permissions. To restrict access to a
1325  * function call, use {hasRole}:
1326  *
1327  * ```
1328  * function foo() public {
1329  *     require(hasRole(MY_ROLE, msg.sender));
1330  *     ...
1331  * }
1332  * ```
1333  *
1334  * Roles can be granted and revoked dynamically via the {grantRole} and
1335  * {revokeRole} functions. Each role has an associated admin role, and only
1336  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1337  *
1338  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1339  * that only accounts with this role will be able to grant or revoke other
1340  * roles. More complex role relationships can be created by using
1341  * {_setRoleAdmin}.
1342  *
1343  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1344  * grant and revoke this role. Extra precautions should be taken to secure
1345  * accounts that have been granted it.
1346  */
1347 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1348     struct RoleData {
1349         mapping(address => bool) members;
1350         bytes32 adminRole;
1351     }
1352 
1353     mapping(bytes32 => RoleData) private _roles;
1354 
1355     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1356 
1357     /**
1358      * @dev Modifier that checks that an account has a specific role. Reverts
1359      * with a standardized message including the required role.
1360      *
1361      * The format of the revert reason is given by the following regular expression:
1362      *
1363      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1364      *
1365      * _Available since v4.1._
1366      */
1367     modifier onlyRole(bytes32 role) {
1368         _checkRole(role, _msgSender());
1369         _;
1370     }
1371 
1372     /**
1373      * @dev See {IERC165-supportsInterface}.
1374      */
1375     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1376         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1377     }
1378 
1379     /**
1380      * @dev Returns `true` if `account` has been granted `role`.
1381      */
1382     function hasRole(bytes32 role, address account) public view override returns (bool) {
1383         return _roles[role].members[account];
1384     }
1385 
1386     /**
1387      * @dev Revert with a standard message if `account` is missing `role`.
1388      *
1389      * The format of the revert reason is given by the following regular expression:
1390      *
1391      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1392      */
1393     function _checkRole(bytes32 role, address account) internal view {
1394         if (!hasRole(role, account)) {
1395             revert(
1396                 string(
1397                     abi.encodePacked(
1398                         "AccessControl: account ",
1399                         Strings.toHexString(uint160(account), 20),
1400                         " is missing role ",
1401                         Strings.toHexString(uint256(role), 32)
1402                     )
1403                 )
1404             );
1405         }
1406     }
1407 
1408     /**
1409      * @dev Returns the admin role that controls `role`. See {grantRole} and
1410      * {revokeRole}.
1411      *
1412      * To change a role's admin, use {_setRoleAdmin}.
1413      */
1414     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1415         return _roles[role].adminRole;
1416     }
1417 
1418     /**
1419      * @dev Grants `role` to `account`.
1420      *
1421      * If `account` had not been already granted `role`, emits a {RoleGranted}
1422      * event.
1423      *
1424      * Requirements:
1425      *
1426      * - the caller must have ``role``'s admin role.
1427      */
1428     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1429         _grantRole(role, account);
1430     }
1431 
1432     /**
1433      * @dev Revokes `role` from `account`.
1434      *
1435      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1436      *
1437      * Requirements:
1438      *
1439      * - the caller must have ``role``'s admin role.
1440      */
1441     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1442         _revokeRole(role, account);
1443     }
1444 
1445     /**
1446      * @dev Revokes `role` from the calling account.
1447      *
1448      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1449      * purpose is to provide a mechanism for accounts to lose their privileges
1450      * if they are compromised (such as when a trusted device is misplaced).
1451      *
1452      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1453      * event.
1454      *
1455      * Requirements:
1456      *
1457      * - the caller must be `account`.
1458      */
1459     function renounceRole(bytes32 role, address account) public virtual override {
1460         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1461 
1462         _revokeRole(role, account);
1463     }
1464 
1465     /**
1466      * @dev Grants `role` to `account`.
1467      *
1468      * If `account` had not been already granted `role`, emits a {RoleGranted}
1469      * event. Note that unlike {grantRole}, this function doesn't perform any
1470      * checks on the calling account.
1471      *
1472      * [WARNING]
1473      * ====
1474      * This function should only be called from the constructor when setting
1475      * up the initial roles for the system.
1476      *
1477      * Using this function in any other way is effectively circumventing the admin
1478      * system imposed by {AccessControl}.
1479      * ====
1480      *
1481      * NOTE: This function is deprecated in favor of {_grantRole}.
1482      */
1483     function _setupRole(bytes32 role, address account) internal virtual {
1484         _grantRole(role, account);
1485     }
1486 
1487     /**
1488      * @dev Sets `adminRole` as ``role``'s admin role.
1489      *
1490      * Emits a {RoleAdminChanged} event.
1491      */
1492     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1493         bytes32 previousAdminRole = getRoleAdmin(role);
1494         _roles[role].adminRole = adminRole;
1495         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1496     }
1497 
1498     /**
1499      * @dev Grants `role` to `account`.
1500      *
1501      * Internal function without access restriction.
1502      */
1503     function _grantRole(bytes32 role, address account) internal virtual {
1504         if (!hasRole(role, account)) {
1505             _roles[role].members[account] = true;
1506             emit RoleGranted(role, account, _msgSender());
1507         }
1508     }
1509 
1510     /**
1511      * @dev Revokes `role` from `account`.
1512      *
1513      * Internal function without access restriction.
1514      */
1515     function _revokeRole(bytes32 role, address account) internal virtual {
1516         if (hasRole(role, account)) {
1517             _roles[role].members[account] = false;
1518             emit RoleRevoked(role, account, _msgSender());
1519         }
1520     }
1521 }
1522 
1523 // File: contracts/MintableERC721.sol
1524 
1525 
1526 pragma solidity ^0.8.10;
1527 
1528 
1529 
1530 
1531 
1532 
1533 
1534 
1535 contract MintableERC721 is ERC721, IMintableERC721, AccessControl, Ownable {
1536   using Address for address;
1537   using Strings for uint256;
1538 
1539   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1540   bytes32 public constant URI_MANAGER_ROLE = keccak256("URI_MANAGER_ROLE");
1541 
1542   uint256 public totalSupply = 0;
1543 
1544   // Mapping from owner to list of owned token IDs
1545   mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1546 
1547   // Mapping from token ID to index of the owner tokens list
1548   mapping(uint256 => uint256) private _ownedTokensIndex;
1549 
1550   constructor(string memory _name, string memory _symbol)
1551     ERC721(_name, _symbol)
1552   {
1553     _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1554     _setupRole(MINTER_ROLE, msg.sender);
1555     _setupRole(URI_MANAGER_ROLE, msg.sender);
1556   }
1557 
1558   string internal theBaseURI = "";
1559 
1560   function _baseURI() internal view virtual override returns (string memory) {
1561     return theBaseURI;
1562   }
1563 
1564   function tokenURI(uint256 tokenId)
1565     public
1566     view
1567     virtual
1568     override
1569     returns (string memory)
1570   {
1571     require(
1572       _exists(tokenId),
1573       "ERC721Metadata: URI query for nonexistent token"
1574     );
1575 
1576     string memory baseURI = _baseURI();
1577     return
1578       bytes(baseURI).length > 0
1579         ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json"))
1580         : "";
1581   }
1582 
1583   /**
1584    * @dev Fired in setBaseURI()
1585    *
1586    * @param _by an address which executed update
1587    * @param _oldVal old _baseURI value
1588    * @param _newVal new _baseURI value
1589    */
1590   event BaseURIChanged(address _by, string _oldVal, string _newVal);
1591 
1592   /**
1593    * @dev Restricted access function which updates base URI used to construct
1594    *      ERC721Metadata.tokenURI
1595    *
1596    * @param _newBaseURI new base URI to set
1597    */
1598   function setBaseURI(string memory _newBaseURI)
1599     external
1600     onlyRole(URI_MANAGER_ROLE)
1601   {
1602     // Fire event
1603     emit BaseURIChanged(msg.sender, theBaseURI, _newBaseURI);
1604 
1605     // Update base uri
1606     theBaseURI = _newBaseURI;
1607   }
1608 
1609   /**
1610    * @inheritdoc IMintableERC721
1611    */
1612   function exists(uint256 _tokenId) external view returns (bool) {
1613     // Delegate to internal OpenZeppelin function
1614     return _exists(_tokenId);
1615   }
1616 
1617   /**
1618    * @inheritdoc IMintableERC721
1619    */
1620   function mint(address _to, uint256 _tokenId)
1621     public
1622     virtual
1623     onlyRole(MINTER_ROLE)
1624   {
1625     totalSupply++;
1626 
1627     // Delegate to internal OpenZeppelin function
1628     _mint(_to, _tokenId);
1629   }
1630 
1631   /**
1632    * @inheritdoc IMintableERC721
1633    */
1634   function mintBatch(
1635     address _to,
1636     uint256 _tokenId,
1637     uint256 _n
1638   ) public virtual onlyRole(MINTER_ROLE) {
1639     totalSupply += _n;
1640 
1641     for (uint256 i = 0; i < _n; i++) {
1642       // Delegate to internal OpenZeppelin mint function
1643       _mint(_to, _tokenId + i);
1644     }
1645   }
1646 
1647   /**
1648    * @inheritdoc IMintableERC721
1649    */
1650   function safeMint(
1651     address _to,
1652     uint256 _tokenId,
1653     bytes memory _data
1654   ) public onlyRole(MINTER_ROLE) {
1655     // Delegate to internal OpenZeppelin unsafe mint function
1656     _mint(_to, _tokenId);
1657 
1658     // If a contract, check if it can receive ERC721 tokens (safe to send)
1659     if (_to.isContract()) {
1660       bytes4 response = IERC721Receiver(_to).onERC721Received(
1661         msg.sender,
1662         address(0),
1663         _tokenId,
1664         _data
1665       );
1666 
1667       require(
1668         response == IERC721Receiver(_to).onERC721Received.selector,
1669         "Invalid onERC721Received response"
1670       );
1671     }
1672   }
1673 
1674   /**
1675    * @inheritdoc IMintableERC721
1676    */
1677   function safeMint(address _to, uint256 _tokenId) public {
1678     // Delegate to internal safe mint function (includes permission check)
1679     safeMint(_to, _tokenId, "");
1680   }
1681 
1682   /**
1683    * @inheritdoc IMintableERC721
1684    */
1685   function safeMintBatch(
1686     address _to,
1687     uint256 _tokenId,
1688     uint256 _n,
1689     bytes memory _data
1690   ) public {
1691     // Delegate to internal unsafe batch mint function (includes permission check)
1692     mintBatch(_to, _tokenId, _n);
1693 
1694     // If a contract, check if it can receive ERC721 tokens (safe to send)
1695     if (_to.isContract()) {
1696       bytes4 response = IERC721Receiver(_to).onERC721Received(
1697         msg.sender,
1698         address(0),
1699         _tokenId,
1700         _data
1701       );
1702 
1703       require(
1704         response == IERC721Receiver(_to).onERC721Received.selector,
1705         "Invalid onERC721Received response"
1706       );
1707     }
1708   }
1709 
1710   /**
1711    * @inheritdoc IMintableERC721
1712    */
1713   function safeMintBatch(
1714     address _to,
1715     uint256 _tokenId,
1716     uint256 _n
1717   ) external {
1718     // Delegate to internal safe batch mint function (includes permission check)
1719     safeMintBatch(_to, _tokenId, _n, "");
1720   }
1721 
1722   /**
1723    * @inheritdoc ERC721
1724    */
1725   function supportsInterface(bytes4 interfaceId)
1726     public
1727     view
1728     override(ERC721, AccessControl)
1729     returns (bool)
1730   {
1731     return
1732       interfaceId == type(IMintableERC721).interfaceId ||
1733       super.supportsInterface(interfaceId);
1734   }
1735 
1736   // ************************************************************************************************************************
1737   // The following methods are borrowed from OpenZeppelin's ERC721Enumerable contract, to make it easier to query a wallet's
1738   // contents without incurring the extra storage gas costs of the full ERC721Enumerable extension
1739   // ************************************************************************************************************************
1740 
1741   function walletOfOwner(address _owner)
1742     public
1743     view
1744     returns (uint256[] memory)
1745   {
1746     uint256 tokenCount = balanceOf(_owner);
1747 
1748     uint256[] memory tokensId = new uint256[](tokenCount);
1749     for (uint256 i; i < tokenCount; i++) {
1750       tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1751     }
1752     return tokensId;
1753   }
1754 
1755   /**
1756    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1757    */
1758   function tokenOfOwnerByIndex(address owner, uint256 index)
1759     public
1760     view
1761     virtual
1762     returns (uint256)
1763   {
1764     require(
1765       index < ERC721.balanceOf(owner),
1766       "ERC721Enumerable: owner index out of bounds"
1767     );
1768     return _ownedTokens[owner][index];
1769   }
1770 
1771   /**
1772    * @dev Private function to add a token to ownership-tracking data structures.
1773    * @param to address representing the new owner of the given token ID
1774    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1775    */
1776   function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1777     uint256 length = ERC721.balanceOf(to);
1778     _ownedTokens[to][length] = tokenId;
1779     _ownedTokensIndex[tokenId] = length;
1780   }
1781 
1782   /**
1783    * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1784    * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1785    * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1786    * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1787    * @param from address representing the previous owner of the given token ID
1788    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1789    */
1790   function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1791     private
1792   {
1793     // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1794     // then delete the last slot (swap and pop).
1795     uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1796     uint256 tokenIndex = _ownedTokensIndex[tokenId];
1797 
1798     // When the token to delete is the last token, the swap operation is unnecessary
1799     if (tokenIndex != lastTokenIndex) {
1800       uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1801 
1802       _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1803       _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1804     }
1805 
1806     // This also deletes the contents at the last position of the array
1807     delete _ownedTokensIndex[tokenId];
1808     delete _ownedTokens[from][lastTokenIndex];
1809   }
1810 
1811   /**
1812    * @dev Hook that is called before any token transfer. This includes minting
1813    * and burning.
1814    *
1815    * Calling conditions:
1816    *
1817    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1818    * transferred to `to`.
1819    * - When `from` is zero, `tokenId` will be minted for `to`.
1820    * - When `to` is zero, ``from``'s `tokenId` will be burned.
1821    * - `from` cannot be the zero address.
1822    * - `to` cannot be the zero address.
1823    *
1824    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1825    */
1826   function _beforeTokenTransfer(
1827     address from,
1828     address to,
1829     uint256 tokenId
1830   ) internal virtual override {
1831     super._beforeTokenTransfer(from, to, tokenId);
1832 
1833     if (from != address(0)) {
1834       _removeTokenFromOwnerEnumeration(from, tokenId);
1835     }
1836     if (to != address(0)) {
1837       _addTokenToOwnerEnumeration(to, tokenId);
1838     }
1839   }
1840 }
1841 
1842 // File: contracts/Eagles.sol
1843 
1844 
1845 pragma solidity ^0.8.10;
1846 
1847 
1848 contract Eagles is MintableERC721 {
1849   uint256 public constant TOTAL_NUMBER_OF_EAGLES = 12000;
1850 
1851   constructor(string memory _name, string memory _symbol)
1852     MintableERC721(_name, _symbol)
1853   {}
1854 
1855   function mint(address _to, uint256 _tokenId) public override {
1856     require(
1857       totalSupply + 1 <= TOTAL_NUMBER_OF_EAGLES,
1858       "MEC: Cannot mint more than total number of EAGLES"
1859     );
1860     super.mint(_to, _tokenId);
1861   }
1862 
1863   function mintBatch(
1864     address _to,
1865     uint256 _tokenId,
1866     uint256 _n
1867   ) public override {
1868     require(
1869       totalSupply + _n <= TOTAL_NUMBER_OF_EAGLES,
1870       "MEC: Cannot mint more than total number of EAGLES"
1871     );
1872     super.mintBatch(_to, _tokenId, _n);
1873   }
1874 }