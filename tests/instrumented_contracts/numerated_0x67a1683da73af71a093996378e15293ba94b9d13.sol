1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Counters.sol
3 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
4 
5 //
6 // #     # ####### #######    #    #       ### ####### #     #  #####  
7 // ##   ## #          #      # #   #        #     #    #     # #     # 
8 // # # # # #          #     #   #  #        #     #    #     # #       
9 // #  #  # #####      #    #     # #        #     #    #######  #####  
10 // #     # #          #    ####### #        #     #    #     #       # 
11 // #     # #          #    #     # #        #     #    #     # #     # 
12 // #     # #######    #    #     # ####### ###    #    #     #  #####  
13 //
14 // Metaliths | Surreal Artworks By Chad Makerson Michael | Genesis Release | Only 1000 Minted On The Blockchain
15 // 
16 // metaliths.io
17 //
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @title Counters
23  * @author Matt Condon (@shrugs)
24  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
25  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
26  *
27  * Include with `using Counters for Counters.Counter;`
28  */
29 library Counters {
30     struct Counter {
31         // This variable should never be directly accessed by users of the library: interactions must be restricted to
32         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
33         // this feature: see https://github.com/ethereum/solidity/issues/4637
34         uint256 _value; // default: 0
35     }
36 
37     function current(Counter storage counter) internal view returns (uint256) {
38         return counter._value;
39     }
40 
41     function increment(Counter storage counter) internal {
42         unchecked {
43             counter._value += 1;
44         }
45     }
46 
47     function decrement(Counter storage counter) internal {
48         uint256 value = counter._value;
49         require(value > 0, "Counter: decrement overflow");
50         unchecked {
51             counter._value = value - 1;
52         }
53     }
54 
55     function reset(Counter storage counter) internal {
56         counter._value = 0;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/utils/Strings.sol
61 
62 
63 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev String operations.
69  */
70 library Strings {
71     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
75      */
76     function toString(uint256 value) internal pure returns (string memory) {
77         // Inspired by OraclizeAPI's implementation - MIT licence
78         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
79 
80         if (value == 0) {
81             return "0";
82         }
83         uint256 temp = value;
84         uint256 digits;
85         while (temp != 0) {
86             digits++;
87             temp /= 10;
88         }
89         bytes memory buffer = new bytes(digits);
90         while (value != 0) {
91             digits -= 1;
92             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
93             value /= 10;
94         }
95         return string(buffer);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
100      */
101     function toHexString(uint256 value) internal pure returns (string memory) {
102         if (value == 0) {
103             return "0x00";
104         }
105         uint256 temp = value;
106         uint256 length = 0;
107         while (temp != 0) {
108             length++;
109             temp >>= 8;
110         }
111         return toHexString(value, length);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
116      */
117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
118         bytes memory buffer = new bytes(2 * length + 2);
119         buffer[0] = "0";
120         buffer[1] = "x";
121         for (uint256 i = 2 * length + 1; i > 1; --i) {
122             buffer[i] = _HEX_SYMBOLS[value & 0xf];
123             value >>= 4;
124         }
125         require(value == 0, "Strings: hex length insufficient");
126         return string(buffer);
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Address.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Collection of functions related to the address type
139  */
140 library Address {
141     /**
142      * @dev Returns true if `account` is a contract.
143      *
144      * [IMPORTANT]
145      * ====
146      * It is unsafe to assume that an address for which this function returns
147      * false is an externally-owned account (EOA) and not a contract.
148      *
149      * Among others, `isContract` will return false for the following
150      * types of addresses:
151      *
152      *  - an externally-owned account
153      *  - a contract in construction
154      *  - an address where a contract will be created
155      *  - an address where a contract lived, but was destroyed
156      * ====
157      */
158     function isContract(address account) internal view returns (bool) {
159         // This method relies on extcodesize, which returns 0 for contracts in
160         // construction, since the code is only stored at the end of the
161         // constructor execution.
162 
163         uint256 size;
164         assembly {
165             size := extcodesize(account)
166         }
167         return size > 0;
168     }
169 
170     /**
171      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
172      * `recipient`, forwarding all available gas and reverting on errors.
173      *
174      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
175      * of certain opcodes, possibly making contracts go over the 2300 gas limit
176      * imposed by `transfer`, making them unable to receive funds via
177      * `transfer`. {sendValue} removes this limitation.
178      *
179      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
180      *
181      * IMPORTANT: because control is transferred to `recipient`, care must be
182      * taken to not create reentrancy vulnerabilities. Consider using
183      * {ReentrancyGuard} or the
184      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
185      */
186     function sendValue(address payable recipient, uint256 amount) internal {
187         require(address(this).balance >= amount, "Address: insufficient balance");
188 
189         (bool success, ) = recipient.call{value: amount}("");
190         require(success, "Address: unable to send value, recipient may have reverted");
191     }
192 
193     /**
194      * @dev Performs a Solidity function call using a low level `call`. A
195      * plain `call` is an unsafe replacement for a function call: use this
196      * function instead.
197      *
198      * If `target` reverts with a revert reason, it is bubbled up by this
199      * function (like regular Solidity function calls).
200      *
201      * Returns the raw returned data. To convert to the expected return value,
202      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
203      *
204      * Requirements:
205      *
206      * - `target` must be a contract.
207      * - calling `target` with `data` must not revert.
208      *
209      * _Available since v3.1._
210      */
211     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionCall(target, data, "Address: low-level call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
217      * `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, 0, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but also transferring `value` wei to `target`.
232      *
233      * Requirements:
234      *
235      * - the calling contract must have an ETH balance of at least `value`.
236      * - the called Solidity function must be `payable`.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value
244     ) internal returns (bytes memory) {
245         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
250      * with `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(address(this).balance >= value, "Address: insufficient balance for call");
261         require(isContract(target), "Address: call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.call{value: value}(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a static call.
270      *
271      * _Available since v3.3._
272      */
273     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
274         return functionStaticCall(target, data, "Address: low-level static call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a static call.
280      *
281      * _Available since v3.3._
282      */
283     function functionStaticCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal view returns (bytes memory) {
288         require(isContract(target), "Address: static call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.staticcall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.4._
309      */
310     function functionDelegateCall(
311         address target,
312         bytes memory data,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(isContract(target), "Address: delegate call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.delegatecall(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
323      * revert reason using the provided one.
324      *
325      * _Available since v4.3._
326      */
327     function verifyCallResult(
328         bool success,
329         bytes memory returndata,
330         string memory errorMessage
331     ) internal pure returns (bytes memory) {
332         if (success) {
333             return returndata;
334         } else {
335             // Look for revert reason and bubble it up if present
336             if (returndata.length > 0) {
337                 // The easiest way to bubble the revert reason is using memory via assembly
338 
339                 assembly {
340                     let returndata_size := mload(returndata)
341                     revert(add(32, returndata), returndata_size)
342                 }
343             } else {
344                 revert(errorMessage);
345             }
346         }
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @title ERC721 token receiver interface
359  * @dev Interface for any contract that wants to support safeTransfers
360  * from ERC721 asset contracts.
361  */
362 interface IERC721Receiver {
363     /**
364      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
365      * by `operator` from `from`, this function is called.
366      *
367      * It must return its Solidity selector to confirm the token transfer.
368      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
369      *
370      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
371      */
372     function onERC721Received(
373         address operator,
374         address from,
375         uint256 tokenId,
376         bytes calldata data
377     ) external returns (bytes4);
378 }
379 
380 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
381 
382 
383 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 /**
388  * @dev Interface of the ERC165 standard, as defined in the
389  * https://eips.ethereum.org/EIPS/eip-165[EIP].
390  *
391  * Implementers can declare support of contract interfaces, which can then be
392  * queried by others ({ERC165Checker}).
393  *
394  * For an implementation, see {ERC165}.
395  */
396 interface IERC165 {
397     /**
398      * @dev Returns true if this contract implements the interface defined by
399      * `interfaceId`. See the corresponding
400      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
401      * to learn more about how these ids are created.
402      *
403      * This function call must use less than 30 000 gas.
404      */
405     function supportsInterface(bytes4 interfaceId) external view returns (bool);
406 }
407 
408 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
409 
410 
411 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
412 
413 pragma solidity ^0.8.0;
414 
415 
416 /**
417  * @dev Implementation of the {IERC165} interface.
418  *
419  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
420  * for the additional interface id that will be supported. For example:
421  *
422  * ```solidity
423  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
424  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
425  * }
426  * ```
427  *
428  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
429  */
430 abstract contract ERC165 is IERC165 {
431     /**
432      * @dev See {IERC165-supportsInterface}.
433      */
434     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
435         return interfaceId == type(IERC165).interfaceId;
436     }
437 }
438 
439 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
440 
441 
442 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 
447 /**
448  * @dev Required interface of an ERC721 compliant contract.
449  */
450 interface IERC721 is IERC165 {
451     /**
452      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
453      */
454     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
455 
456     /**
457      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
458      */
459     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
460 
461     /**
462      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
463      */
464     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
465 
466     /**
467      * @dev Returns the number of tokens in ``owner``'s account.
468      */
469     function balanceOf(address owner) external view returns (uint256 balance);
470 
471     /**
472      * @dev Returns the owner of the `tokenId` token.
473      *
474      * Requirements:
475      *
476      * - `tokenId` must exist.
477      */
478     function ownerOf(uint256 tokenId) external view returns (address owner);
479 
480     /**
481      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
482      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
483      *
484      * Requirements:
485      *
486      * - `from` cannot be the zero address.
487      * - `to` cannot be the zero address.
488      * - `tokenId` token must exist and be owned by `from`.
489      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
490      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
491      *
492      * Emits a {Transfer} event.
493      */
494     function safeTransferFrom(
495         address from,
496         address to,
497         uint256 tokenId
498     ) external;
499 
500     /**
501      * @dev Transfers `tokenId` token from `from` to `to`.
502      *
503      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must be owned by `from`.
510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transferFrom(
515         address from,
516         address to,
517         uint256 tokenId
518     ) external;
519 
520     /**
521      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
522      * The approval is cleared when the token is transferred.
523      *
524      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
525      *
526      * Requirements:
527      *
528      * - The caller must own the token or be an approved operator.
529      * - `tokenId` must exist.
530      *
531      * Emits an {Approval} event.
532      */
533     function approve(address to, uint256 tokenId) external;
534 
535     /**
536      * @dev Returns the account approved for `tokenId` token.
537      *
538      * Requirements:
539      *
540      * - `tokenId` must exist.
541      */
542     function getApproved(uint256 tokenId) external view returns (address operator);
543 
544     /**
545      * @dev Approve or remove `operator` as an operator for the caller.
546      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
547      *
548      * Requirements:
549      *
550      * - The `operator` cannot be the caller.
551      *
552      * Emits an {ApprovalForAll} event.
553      */
554     function setApprovalForAll(address operator, bool _approved) external;
555 
556     /**
557      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
558      *
559      * See {setApprovalForAll}
560      */
561     function isApprovedForAll(address owner, address operator) external view returns (bool);
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must exist and be owned by `from`.
571      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
573      *
574      * Emits a {Transfer} event.
575      */
576     function safeTransferFrom(
577         address from,
578         address to,
579         uint256 tokenId,
580         bytes calldata data
581     ) external;
582 }
583 
584 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
594  * @dev See https://eips.ethereum.org/EIPS/eip-721
595  */
596 interface IERC721Metadata is IERC721 {
597     /**
598      * @dev Returns the token collection name.
599      */
600     function name() external view returns (string memory);
601 
602     /**
603      * @dev Returns the token collection symbol.
604      */
605     function symbol() external view returns (string memory);
606 
607     /**
608      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
609      */
610     function tokenURI(uint256 tokenId) external view returns (string memory);
611 }
612 
613 // File: @openzeppelin/contracts/utils/Context.sol
614 
615 
616 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev Provides information about the current execution context, including the
622  * sender of the transaction and its data. While these are generally available
623  * via msg.sender and msg.data, they should not be accessed in such a direct
624  * manner, since when dealing with meta-transactions the account sending and
625  * paying for execution may not be the actual sender (as far as an application
626  * is concerned).
627  *
628  * This contract is only required for intermediate, library-like contracts.
629  */
630 abstract contract Context {
631     function _msgSender() internal view virtual returns (address) {
632         return msg.sender;
633     }
634 
635     function _msgData() internal view virtual returns (bytes calldata) {
636         return msg.data;
637     }
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 
649 
650 
651 
652 
653 
654 /**
655  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
656  * the Metadata extension, but not including the Enumerable extension, which is available separately as
657  * {ERC721Enumerable}.
658  */
659 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
660     using Address for address;
661     using Strings for uint256;
662 
663     // Token name
664     string private _name;
665 
666     // Token symbol
667     string private _symbol;
668 
669     // Mapping from token ID to owner address
670     mapping(uint256 => address) private _owners;
671 
672     // Mapping owner address to token count
673     mapping(address => uint256) private _balances;
674 
675     // Mapping from token ID to approved address
676     mapping(uint256 => address) private _tokenApprovals;
677 
678     // Mapping from owner to operator approvals
679     mapping(address => mapping(address => bool)) private _operatorApprovals;
680 
681     /**
682      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
683      */
684     constructor(string memory name_, string memory symbol_) {
685         _name = name_;
686         _symbol = symbol_;
687     }
688 
689     /**
690      * @dev See {IERC165-supportsInterface}.
691      */
692     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
693         return
694             interfaceId == type(IERC721).interfaceId ||
695             interfaceId == type(IERC721Metadata).interfaceId ||
696             super.supportsInterface(interfaceId);
697     }
698 
699     /**
700      * @dev See {IERC721-balanceOf}.
701      */
702     function balanceOf(address owner) public view virtual override returns (uint256) {
703         require(owner != address(0), "ERC721: balance query for the zero address");
704         return _balances[owner];
705     }
706 
707     /**
708      * @dev See {IERC721-ownerOf}.
709      */
710     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
711         address owner = _owners[tokenId];
712         require(owner != address(0), "ERC721: owner query for nonexistent token");
713         return owner;
714     }
715 
716     /**
717      * @dev See {IERC721Metadata-name}.
718      */
719     function name() public view virtual override returns (string memory) {
720         return _name;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-symbol}.
725      */
726     function symbol() public view virtual override returns (string memory) {
727         return _symbol;
728     }
729 
730     /**
731      * @dev See {IERC721Metadata-tokenURI}.
732      */
733     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
734         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
735 
736         string memory baseURI = _baseURI();
737         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
738     }
739 
740     /**
741      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
742      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
743      * by default, can be overriden in child contracts.
744      */
745     function _baseURI() internal view virtual returns (string memory) {
746         return "";
747     }
748 
749     /**
750      * @dev See {IERC721-approve}.
751      */
752     function approve(address to, uint256 tokenId) public virtual override {
753         address owner = ERC721.ownerOf(tokenId);
754         require(to != owner, "ERC721: approval to current owner");
755 
756         require(
757             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
758             "ERC721: approve caller is not owner nor approved for all"
759         );
760 
761         _approve(to, tokenId);
762     }
763 
764     /**
765      * @dev See {IERC721-getApproved}.
766      */
767     function getApproved(uint256 tokenId) public view virtual override returns (address) {
768         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
769 
770         return _tokenApprovals[tokenId];
771     }
772 
773     /**
774      * @dev See {IERC721-setApprovalForAll}.
775      */
776     function setApprovalForAll(address operator, bool approved) public virtual override {
777         _setApprovalForAll(_msgSender(), operator, approved);
778     }
779 
780     /**
781      * @dev See {IERC721-isApprovedForAll}.
782      */
783     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
784         return _operatorApprovals[owner][operator];
785     }
786 
787     /**
788      * @dev See {IERC721-transferFrom}.
789      */
790     function transferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) public virtual override {
795         //solhint-disable-next-line max-line-length
796         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
797 
798         _transfer(from, to, tokenId);
799     }
800 
801     /**
802      * @dev See {IERC721-safeTransferFrom}.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) public virtual override {
809         safeTransferFrom(from, to, tokenId, "");
810     }
811 
812     /**
813      * @dev See {IERC721-safeTransferFrom}.
814      */
815     function safeTransferFrom(
816         address from,
817         address to,
818         uint256 tokenId,
819         bytes memory _data
820     ) public virtual override {
821         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
822         _safeTransfer(from, to, tokenId, _data);
823     }
824 
825     /**
826      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
827      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
828      *
829      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
830      *
831      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
832      * implement alternative mechanisms to perform token transfer, such as signature-based.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must exist and be owned by `from`.
839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
840      *
841      * Emits a {Transfer} event.
842      */
843     function _safeTransfer(
844         address from,
845         address to,
846         uint256 tokenId,
847         bytes memory _data
848     ) internal virtual {
849         _transfer(from, to, tokenId);
850         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
851     }
852 
853     /**
854      * @dev Returns whether `tokenId` exists.
855      *
856      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
857      *
858      * Tokens start existing when they are minted (`_mint`),
859      * and stop existing when they are burned (`_burn`).
860      */
861     function _exists(uint256 tokenId) internal view virtual returns (bool) {
862         return _owners[tokenId] != address(0);
863     }
864 
865     /**
866      * @dev Returns whether `spender` is allowed to manage `tokenId`.
867      *
868      * Requirements:
869      *
870      * - `tokenId` must exist.
871      */
872     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
873         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
874         address owner = ERC721.ownerOf(tokenId);
875         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
876     }
877 
878     /**
879      * @dev Safely mints `tokenId` and transfers it to `to`.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must not exist.
884      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _safeMint(address to, uint256 tokenId) internal virtual {
889         _safeMint(to, tokenId, "");
890     }
891 
892     /**
893      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
894      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
895      */
896     function _safeMint(
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) internal virtual {
901         _mint(to, tokenId);
902         require(
903             _checkOnERC721Received(address(0), to, tokenId, _data),
904             "ERC721: transfer to non ERC721Receiver implementer"
905         );
906     }
907 
908     /**
909      * @dev Mints `tokenId` and transfers it to `to`.
910      *
911      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
912      *
913      * Requirements:
914      *
915      * - `tokenId` must not exist.
916      * - `to` cannot be the zero address.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _mint(address to, uint256 tokenId) internal virtual {
921         require(to != address(0), "ERC721: mint to the zero address");
922         require(!_exists(tokenId), "ERC721: token already minted");
923 
924         _beforeTokenTransfer(address(0), to, tokenId);
925 
926         _balances[to] += 1;
927         _owners[tokenId] = to;
928 
929         emit Transfer(address(0), to, tokenId);
930     }
931 
932     /**
933      * @dev Destroys `tokenId`.
934      * The approval is cleared when the token is burned.
935      *
936      * Requirements:
937      *
938      * - `tokenId` must exist.
939      *
940      * Emits a {Transfer} event.
941      */
942     function _burn(uint256 tokenId) internal virtual {
943         address owner = ERC721.ownerOf(tokenId);
944 
945         _beforeTokenTransfer(owner, address(0), tokenId);
946 
947         // Clear approvals
948         _approve(address(0), tokenId);
949 
950         _balances[owner] -= 1;
951         delete _owners[tokenId];
952 
953         emit Transfer(owner, address(0), tokenId);
954     }
955 
956     /**
957      * @dev Transfers `tokenId` from `from` to `to`.
958      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
959      *
960      * Requirements:
961      *
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must be owned by `from`.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _transfer(
968         address from,
969         address to,
970         uint256 tokenId
971     ) internal virtual {
972         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
973         require(to != address(0), "ERC721: transfer to the zero address");
974 
975         _beforeTokenTransfer(from, to, tokenId);
976 
977         // Clear approvals from the previous owner
978         _approve(address(0), tokenId);
979 
980         _balances[from] -= 1;
981         _balances[to] += 1;
982         _owners[tokenId] = to;
983 
984         emit Transfer(from, to, tokenId);
985     }
986 
987     /**
988      * @dev Approve `to` to operate on `tokenId`
989      *
990      * Emits a {Approval} event.
991      */
992     function _approve(address to, uint256 tokenId) internal virtual {
993         _tokenApprovals[tokenId] = to;
994         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
995     }
996 
997     /**
998      * @dev Approve `operator` to operate on all of `owner` tokens
999      *
1000      * Emits a {ApprovalForAll} event.
1001      */
1002     function _setApprovalForAll(
1003         address owner,
1004         address operator,
1005         bool approved
1006     ) internal virtual {
1007         require(owner != operator, "ERC721: approve to caller");
1008         _operatorApprovals[owner][operator] = approved;
1009         emit ApprovalForAll(owner, operator, approved);
1010     }
1011 
1012     /**
1013      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1014      * The call is not executed if the target address is not a contract.
1015      *
1016      * @param from address representing the previous owner of the given token ID
1017      * @param to target address that will receive the tokens
1018      * @param tokenId uint256 ID of the token to be transferred
1019      * @param _data bytes optional data to send along with the call
1020      * @return bool whether the call correctly returned the expected magic value
1021      */
1022     function _checkOnERC721Received(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes memory _data
1027     ) private returns (bool) {
1028         if (to.isContract()) {
1029             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1030                 return retval == IERC721Receiver.onERC721Received.selector;
1031             } catch (bytes memory reason) {
1032                 if (reason.length == 0) {
1033                     revert("ERC721: transfer to non ERC721Receiver implementer");
1034                 } else {
1035                     assembly {
1036                         revert(add(32, reason), mload(reason))
1037                     }
1038                 }
1039             }
1040         } else {
1041             return true;
1042         }
1043     }
1044 
1045     /**
1046      * @dev Hook that is called before any token transfer. This includes minting
1047      * and burning.
1048      *
1049      * Calling conditions:
1050      *
1051      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1052      * transferred to `to`.
1053      * - When `from` is zero, `tokenId` will be minted for `to`.
1054      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1055      * - `from` and `to` are never both zero.
1056      *
1057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1058      */
1059     function _beforeTokenTransfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {}
1064 }
1065 
1066 // File: @openzeppelin/contracts/access/Ownable.sol
1067 
1068 
1069 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1070 
1071 pragma solidity ^0.8.0;
1072 
1073 
1074 /**
1075  * @dev Contract module which provides a basic access control mechanism, where
1076  * there is an account (an owner) that can be granted exclusive access to
1077  * specific functions.
1078  *
1079  * By default, the owner account will be the one that deploys the contract. This
1080  * can later be changed with {transferOwnership}.
1081  *
1082  * This module is used through inheritance. It will make available the modifier
1083  * `onlyOwner`, which can be applied to your functions to restrict their use to
1084  * the owner.
1085  */
1086 abstract contract Ownable is Context {
1087     address private _owner;
1088 
1089     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1090 
1091     /**
1092      * @dev Initializes the contract setting the deployer as the initial owner.
1093      */
1094     constructor() {
1095         _transferOwnership(_msgSender());
1096     }
1097 
1098     /**
1099      * @dev Returns the address of the current owner.
1100      */
1101     function owner() public view virtual returns (address) {
1102         return _owner;
1103     }
1104 
1105     /**
1106      * @dev Throws if called by any account other than the owner.
1107      */
1108     modifier onlyOwner() {
1109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1110         _;
1111     }
1112 
1113     /**
1114      * @dev Leaves the contract without owner. It will not be possible to call
1115      * `onlyOwner` functions anymore. Can only be called by the current owner.
1116      *
1117      * NOTE: Renouncing ownership will leave the contract without an owner,
1118      * thereby removing any functionality that is only available to the owner.
1119      */
1120     function renounceOwnership() public virtual onlyOwner {
1121         _transferOwnership(address(0));
1122     }
1123 
1124     /**
1125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1126      * Can only be called by the current owner.
1127      */
1128     function transferOwnership(address newOwner) public virtual onlyOwner {
1129         require(newOwner != address(0), "Ownable: new owner is the zero address");
1130         _transferOwnership(newOwner);
1131     }
1132 
1133     /**
1134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1135      * Internal function without access restriction.
1136      */
1137     function _transferOwnership(address newOwner) internal virtual {
1138         address oldOwner = _owner;
1139         _owner = newOwner;
1140         emit OwnershipTransferred(oldOwner, newOwner);
1141     }
1142 }
1143 
1144 // File: Contracts/Metalith.sol
1145 
1146 pragma solidity ^0.8.0;
1147 
1148 contract Metaliths is Ownable, ERC721 {
1149     using Counters for Counters.Counter;
1150     Counters.Counter private _tokenSupply;
1151 
1152     uint256 public constant MAX_TOKENS = 1001;
1153     uint256 public constant MINT_TRANSACTION_LIMIT = 6;
1154 
1155     uint256 public tokenPrice = 0.1 ether;
1156     bool public saleIsActive;
1157 
1158     string _baseTokenURI;
1159     address _proxyRegistryAddress;
1160 
1161     constructor(address proxyRegistryAddress) ERC721("Metaliths", "MLTHS") {
1162         _proxyRegistryAddress = proxyRegistryAddress;
1163         _tokenSupply.increment();
1164         _safeMint(msg.sender, 0);
1165     }
1166 
1167     function publicMint(uint256 amount) external payable {
1168         require(saleIsActive, "Sale is not active");
1169         require(amount < MINT_TRANSACTION_LIMIT, "Mint amount too large");
1170         uint256 supply = _tokenSupply.current();
1171         require(supply + amount < MAX_TOKENS, "Not enough tokens remaining");
1172         require(tokenPrice * amount <= msg.value, "Not enough ether sent");
1173 
1174         for (uint256 i = 0; i < amount; i++) {
1175             _tokenSupply.increment();
1176             _safeMint(msg.sender, supply + i);
1177         }
1178     }
1179 
1180     function reserveTokens(address to, uint256 amount) external onlyOwner {
1181         uint256 supply = _tokenSupply.current();
1182         require(supply + amount < MAX_TOKENS, "Not enough tokens remaining");
1183         for (uint256 i = 0; i < amount; i++) {
1184             _tokenSupply.increment();
1185             _safeMint(to, supply + i);
1186         }
1187     }
1188 
1189     function setTokenPrice(uint256 newPrice) external onlyOwner {
1190         tokenPrice = newPrice;
1191     }
1192 
1193     function flipSaleState() external onlyOwner {
1194         saleIsActive = !saleIsActive;
1195     }
1196 
1197     function totalSupply() public view returns (uint256) {
1198         return _tokenSupply.current();
1199     }
1200 
1201     function setBaseURI(string memory newBaseURI) external onlyOwner {
1202         _baseTokenURI = newBaseURI;
1203     }
1204 
1205     function _baseURI() internal view override returns (string memory) {
1206         return _baseTokenURI;
1207     }
1208 
1209     function setProxyRegistryAddress(address proxyRegistryAddress)
1210         external
1211         onlyOwner
1212     {
1213         _proxyRegistryAddress = proxyRegistryAddress;
1214     }
1215 
1216     function isApprovedForAll(address owner, address operator)
1217         public
1218         view
1219         override
1220         returns (bool)
1221     {
1222         // Whitelist OpenSea proxy contract for easy trading.
1223         ProxyRegistry proxyRegistry = ProxyRegistry(_proxyRegistryAddress);
1224         if (address(proxyRegistry.proxies(owner)) == operator) {
1225             return true;
1226         }
1227         return super.isApprovedForAll(owner, operator);
1228     }
1229 
1230     receive() external payable {}
1231 
1232     function withdraw() external onlyOwner {
1233         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1234         require(success, "Withdrawal failed");
1235     }
1236 }
1237 
1238 contract OwnableDelegateProxy {}
1239 
1240 contract ProxyRegistry {
1241     mapping(address => OwnableDelegateProxy) public proxies;
1242 }