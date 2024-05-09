1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
4 pragma solidity ^0.8.0;
5 
6 library Address {
7 
8     function isContract(address account) internal view returns (bool) {
9 
10         uint256 size;
11         assembly {
12             size := extcodesize(account)
13         }
14         return size > 0;
15     }
16 
17     function sendValue(address payable recipient, uint256 amount) internal {
18         require(address(this).balance >= amount, "Address: insufficient balance");
19 
20         (bool success, ) = recipient.call{value: amount}("");
21         require(success, "Address: unable to send value, recipient may have reverted");
22     }
23 
24     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
25         return functionCall(target, data, "Address: low-level call failed");
26     }
27 
28     /**
29      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
30      * `errorMessage` as a fallback revert reason when `target` reverts.
31      *
32      * _Available since v3.1._
33      */
34     function functionCall(
35         address target,
36         bytes memory data,
37         string memory errorMessage
38     ) internal returns (bytes memory) {
39         return functionCallWithValue(target, data, 0, errorMessage);
40     }
41 
42     /**
43      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
44      * but also transferring `value` wei to `target`.
45      *
46      * Requirements:
47      *
48      * - the calling contract must have an ETH balance of at least `value`.
49      * - the called Solidity function must be `payable`.
50      *
51      * _Available since v3.1._
52      */
53     function functionCallWithValue(
54         address target,
55         bytes memory data,
56         uint256 value
57     ) internal returns (bytes memory) {
58         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
59     }
60 
61     /**
62      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
63      * with `errorMessage` as a fallback revert reason when `target` reverts.
64      *
65      * _Available since v3.1._
66      */
67     function functionCallWithValue(
68         address target,
69         bytes memory data,
70         uint256 value,
71         string memory errorMessage
72     ) internal returns (bytes memory) {
73         require(address(this).balance >= value, "Address: insufficient balance for call");
74         require(isContract(target), "Address: call to non-contract");
75 
76         (bool success, bytes memory returndata) = target.call{value: value}(data);
77         return verifyCallResult(success, returndata, errorMessage);
78     }
79 
80     /**
81      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
82      * but performing a static call.
83      *
84      * _Available since v3.3._
85      */
86     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
87         return functionStaticCall(target, data, "Address: low-level static call failed");
88     }
89 
90     /**
91      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
92      * but performing a static call.
93      *
94      * _Available since v3.3._
95      */
96     function functionStaticCall(
97         address target,
98         bytes memory data,
99         string memory errorMessage
100     ) internal view returns (bytes memory) {
101         require(isContract(target), "Address: static call to non-contract");
102 
103         (bool success, bytes memory returndata) = target.staticcall(data);
104         return verifyCallResult(success, returndata, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but performing a delegate call.
110      *
111      * _Available since v3.4._
112      */
113     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
114         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
119      * but performing a delegate call.
120      *
121      * _Available since v3.4._
122      */
123     function functionDelegateCall(
124         address target,
125         bytes memory data,
126         string memory errorMessage
127     ) internal returns (bytes memory) {
128         require(isContract(target), "Address: delegate call to non-contract");
129 
130         (bool success, bytes memory returndata) = target.delegatecall(data);
131         return verifyCallResult(success, returndata, errorMessage);
132     }
133 
134     /**
135      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
136      * revert reason using the provided one.
137      *
138      * _Available since v4.3._
139      */
140     function verifyCallResult(
141         bool success,
142         bytes memory returndata,
143         string memory errorMessage
144     ) internal pure returns (bytes memory) {
145         if (success) {
146             return returndata;
147         } else {
148             // Look for revert reason and bubble it up if present
149             if (returndata.length > 0) {
150                 // The easiest way to bubble the revert reason is using memory via assembly
151 
152                 assembly {
153                     let returndata_size := mload(returndata)
154                     revert(add(32, returndata), returndata_size)
155                 }
156             } else {
157                 revert(errorMessage);
158             }
159         }
160     }
161 }
162 
163 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
164 pragma solidity ^0.8.0;
165 
166 /**
167  * @dev String operations.
168  */
169 library Strings {
170     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
171 
172     /**
173      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
174      */
175     function toString(uint256 value) internal pure returns (string memory) {
176         // Inspired by OraclizeAPI's implementation - MIT licence
177         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
178 
179         if (value == 0) {
180             return "0";
181         }
182         uint256 temp = value;
183         uint256 digits;
184         while (temp != 0) {
185             digits++;
186             temp /= 10;
187         }
188         bytes memory buffer = new bytes(digits);
189         while (value != 0) {
190             digits -= 1;
191             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
192             value /= 10;
193         }
194         return string(buffer);
195     }
196 
197     /**
198      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
199      */
200     function toHexString(uint256 value) internal pure returns (string memory) {
201         if (value == 0) {
202             return "0x00";
203         }
204         uint256 temp = value;
205         uint256 length = 0;
206         while (temp != 0) {
207             length++;
208             temp >>= 8;
209         }
210         return toHexString(value, length);
211     }
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
215      */
216     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
217         bytes memory buffer = new bytes(2 * length + 2);
218         buffer[0] = "0";
219         buffer[1] = "x";
220         for (uint256 i = 2 * length + 1; i > 1; --i) {
221             buffer[i] = _HEX_SYMBOLS[value & 0xf];
222             value >>= 4;
223         }
224         require(value == 0, "Strings: hex length insufficient");
225         return string(buffer);
226     }
227 }
228 
229 
230 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @title Counters
235  * @author Matt Condon (@shrugs)
236  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
237  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
238  *
239  * Include with `using Counters for Counters.Counter;`
240  */
241 library Counters {
242     struct Counter {
243         // This variable should never be directly accessed by users of the library: interactions must be restricted to
244         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
245         // this feature: see https://github.com/ethereum/solidity/issues/4637
246         uint256 _value; // default: 0
247     }
248 
249     function current(Counter storage counter) internal view returns (uint256) {
250         return counter._value;
251     }
252 
253     function increment(Counter storage counter) internal {
254         unchecked {
255             counter._value += 1;
256         }
257     }
258 
259     function decrement(Counter storage counter) internal {
260         uint256 value = counter._value;
261         require(value > 0, "Counter: decrement overflow");
262         unchecked {
263             counter._value = value - 1;
264         }
265     }
266 
267     function reset(Counter storage counter) internal {
268         counter._value = 0;
269     }
270 }
271 
272 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Interface of the ERC165 standard, as defined in the
277  * https://eips.ethereum.org/EIPS/eip-165[EIP].
278  *
279  * Implementers can declare support of contract interfaces, which can then be
280  * queried by others ({ERC165Checker}).
281  *
282  * For an implementation, see {ERC165}.
283  */
284 interface IERC165 {
285     /**
286      * @dev Returns true if this contract implements the interface defined by
287      * `interfaceId`. See the corresponding
288      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
289      * to learn more about how these ids are created.
290      *
291      * This function call must use less than 30 000 gas.
292      */
293     function supportsInterface(bytes4 interfaceId) external view returns (bool);
294 }
295 
296 
297 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Required interface of an ERC721 compliant contract.
302  */
303 interface IERC721 is IERC165 {
304     /**
305      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
306      */
307     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
308 
309     /**
310      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
311      */
312     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
313 
314     /**
315      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
316      */
317     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
318 
319     /**
320      * @dev Returns the number of tokens in ``owner``'s account.
321      */
322     function balanceOf(address owner) external view returns (uint256 balance);
323 
324     /**
325      * @dev Returns the owner of the `tokenId` token.
326      *
327      * Requirements:
328      *
329      * - `tokenId` must exist.
330      */
331     function ownerOf(uint256 tokenId) external view returns (address owner);
332 
333     /**
334      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
335      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `tokenId` token must exist and be owned by `from`.
342      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
343      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
344      *
345      * Emits a {Transfer} event.
346      */
347     function safeTransferFrom(
348         address from,
349         address to,
350         uint256 tokenId
351     ) external;
352 
353     /**
354      * @dev Transfers `tokenId` token from `from` to `to`.
355      *
356      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `tokenId` token must be owned by `from`.
363      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(
368         address from,
369         address to,
370         uint256 tokenId
371     ) external;
372 
373     /**
374      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
375      * The approval is cleared when the token is transferred.
376      *
377      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
378      *
379      * Requirements:
380      *
381      * - The caller must own the token or be an approved operator.
382      * - `tokenId` must exist.
383      *
384      * Emits an {Approval} event.
385      */
386     function approve(address to, uint256 tokenId) external;
387 
388     /**
389      * @dev Returns the account approved for `tokenId` token.
390      *
391      * Requirements:
392      *
393      * - `tokenId` must exist.
394      */
395     function getApproved(uint256 tokenId) external view returns (address operator);
396 
397     /**
398      * @dev Approve or remove `operator` as an operator for the caller.
399      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
400      *
401      * Requirements:
402      *
403      * - The `operator` cannot be the caller.
404      *
405      * Emits an {ApprovalForAll} event.
406      */
407     function setApprovalForAll(address operator, bool _approved) external;
408 
409     /**
410      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
411      *
412      * See {setApprovalForAll}
413      */
414     function isApprovedForAll(address owner, address operator) external view returns (bool);
415 
416     /**
417      * @dev Safely transfers `tokenId` token from `from` to `to`.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `tokenId` token must exist and be owned by `from`.
424      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
426      *
427      * Emits a {Transfer} event.
428      */
429     function safeTransferFrom(
430         address from,
431         address to,
432         uint256 tokenId,
433         bytes calldata data
434     ) external;
435 }
436 
437 
438 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @title ERC721 token receiver interface
443  * @dev Interface for any contract that wants to support safeTransfers
444  * from ERC721 asset contracts.
445  */
446 interface IERC721Receiver {
447     /**
448      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
449      * by `operator` from `from`, this function is called.
450      *
451      * It must return its Solidity selector to confirm the token transfer.
452      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
453      *
454      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
455      */
456     function onERC721Received(
457         address operator,
458         address from,
459         uint256 tokenId,
460         bytes calldata data
461     ) external returns (bytes4);
462 }
463 
464 
465 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
470  * @dev See https://eips.ethereum.org/EIPS/eip-721
471  */
472 interface IERC721Metadata is IERC721 {
473     /**
474      * @dev Returns the token collection name.
475      */
476     function name() external view returns (string memory);
477 
478     /**
479      * @dev Returns the token collection symbol.
480      */
481     function symbol() external view returns (string memory);
482 
483     /**
484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
485      */
486     function tokenURI(uint256 tokenId) external view returns (string memory);
487 }
488 
489 
490 
491 
492 
493 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Provides information about the current execution context, including the
498  * sender of the transaction and its data. While these are generally available
499  * via msg.sender and msg.data, they should not be accessed in such a direct
500  * manner, since when dealing with meta-transactions the account sending and
501  * paying for execution may not be the actual sender (as far as an application
502  * is concerned).
503  *
504  * This contract is only required for intermediate, library-like contracts.
505  */
506 abstract contract Context {
507     function _msgSender() internal view virtual returns (address) {
508         return msg.sender;
509     }
510 
511     function _msgData() internal view virtual returns (bytes calldata) {
512         return msg.data;
513     }
514 }
515 
516 
517 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev Implementation of the {IERC165} interface.
522  *
523  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
524  * for the additional interface id that will be supported. For example:
525  *
526  * ```solidity
527  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
528  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
529  * }
530  * ```
531  *
532  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
533  */
534 abstract contract ERC165 is IERC165 {
535     /**
536      * @dev See {IERC165-supportsInterface}.
537      */
538     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539         return interfaceId == type(IERC165).interfaceId;
540     }
541 }
542 
543 
544 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
545 pragma solidity ^0.8.0;
546 
547 /**
548  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
549  * the Metadata extension, but not including the Enumerable extension, which is available separately as
550  * {ERC721Enumerable}.
551  */
552 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
553     using Address for address;
554     using Strings for uint256;
555 
556     // Token name
557     string private _name;
558 
559     // Token symbol
560     string private _symbol;
561 
562     // Mapping from token ID to owner address
563     mapping(uint256 => address) private _owners;
564 
565     // Mapping owner address to token count
566     mapping(address => uint256) private _balances;
567 
568     // Mapping from token ID to approved address
569     mapping(uint256 => address) private _tokenApprovals;
570 
571     // Mapping from owner to operator approvals
572     mapping(address => mapping(address => bool)) private _operatorApprovals;
573 
574     /**
575      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
576      */
577     constructor(string memory name_, string memory symbol_) {
578         _name = name_;
579         _symbol = symbol_;
580     }
581 
582     /**
583      * @dev See {IERC165-supportsInterface}.
584      */
585     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
586         return
587             interfaceId == type(IERC721).interfaceId ||
588             interfaceId == type(IERC721Metadata).interfaceId ||
589             super.supportsInterface(interfaceId);
590     }
591 
592     /**
593      * @dev See {IERC721-balanceOf}.
594      */
595     function balanceOf(address owner) public view virtual override returns (uint256) {
596         require(owner != address(0), "ERC721: balance query for the zero address");
597         return _balances[owner];
598     }
599 
600     /**
601      * @dev See {IERC721-ownerOf}.
602      */
603     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
604         address owner = _owners[tokenId];
605         require(owner != address(0), "ERC721: owner query for nonexistent token");
606         return owner;
607     }
608 
609     /**
610      * @dev See {IERC721Metadata-name}.
611      */
612     function name() public view virtual override returns (string memory) {
613         return _name;
614     }
615 
616     /**
617      * @dev See {IERC721Metadata-symbol}.
618      */
619     function symbol() public view virtual override returns (string memory) {
620         return _symbol;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-tokenURI}.
625      */
626     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
627         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
628 
629         string memory baseURI = _baseURI();
630         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
631     }
632 
633     /**
634      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
635      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
636      * by default, can be overriden in child contracts.
637      */
638     function _baseURI() internal view virtual returns (string memory) {
639         return "";
640     }
641 
642     /**
643      * @dev See {IERC721-approve}.
644      */
645     function approve(address to, uint256 tokenId) public virtual override {
646         address owner = ERC721.ownerOf(tokenId);
647         require(to != owner, "ERC721: approval to current owner");
648 
649         require(
650             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
651             "ERC721: approve caller is not owner nor approved for all"
652         );
653 
654         _approve(to, tokenId);
655     }
656 
657     /**
658      * @dev See {IERC721-getApproved}.
659      */
660     function getApproved(uint256 tokenId) public view virtual override returns (address) {
661         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
662 
663         return _tokenApprovals[tokenId];
664     }
665 
666     /**
667      * @dev See {IERC721-setApprovalForAll}.
668      */
669     function setApprovalForAll(address operator, bool approved) public virtual override {
670         require(operator != _msgSender(), "ERC721: approve to caller");
671 
672         _operatorApprovals[_msgSender()][operator] = approved;
673         emit ApprovalForAll(_msgSender(), operator, approved);
674     }
675 
676     /**
677      * @dev See {IERC721-isApprovedForAll}.
678      */
679     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
680         return _operatorApprovals[owner][operator];
681     }
682 
683     /**
684      * @dev See {IERC721-transferFrom}.
685      */
686     function transferFrom(
687         address from,
688         address to,
689         uint256 tokenId
690     ) public virtual override {
691         //solhint-disable-next-line max-line-length
692         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
693 
694         _transfer(from, to, tokenId);
695     }
696 
697     /**
698      * @dev See {IERC721-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) public virtual override {
705         safeTransferFrom(from, to, tokenId, "");
706     }
707 
708     /**
709      * @dev See {IERC721-safeTransferFrom}.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId,
715         bytes memory _data
716     ) public virtual override {
717         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
718         _safeTransfer(from, to, tokenId, _data);
719     }
720 
721     /**
722      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
723      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
724      *
725      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
726      *
727      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
728      * implement alternative mechanisms to perform token transfer, such as signature-based.
729      *
730      * Requirements:
731      *
732      * - `from` cannot be the zero address.
733      * - `to` cannot be the zero address.
734      * - `tokenId` token must exist and be owned by `from`.
735      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
736      *
737      * Emits a {Transfer} event.
738      */
739     function _safeTransfer(
740         address from,
741         address to,
742         uint256 tokenId,
743         bytes memory _data
744     ) internal virtual {
745         _transfer(from, to, tokenId);
746         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
747     }
748 
749     /**
750      * @dev Returns whether `tokenId` exists.
751      *
752      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
753      *
754      * Tokens start existing when they are minted (`_mint`),
755      * and stop existing when they are burned (`_burn`).
756      */
757     function _exists(uint256 tokenId) internal view virtual returns (bool) {
758         return _owners[tokenId] != address(0);
759     }
760 
761     /**
762      * @dev Returns whether `spender` is allowed to manage `tokenId`.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must exist.
767      */
768     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
769         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
770         address owner = ERC721.ownerOf(tokenId);
771         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
772     }
773 
774     /**
775      * @dev Safely mints `tokenId` and transfers it to `to`.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must not exist.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _safeMint(address to, uint256 tokenId) internal virtual {
785         _safeMint(to, tokenId, "");
786     }
787 
788     /**
789      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
790      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
791      */
792     function _safeMint(
793         address to,
794         uint256 tokenId,
795         bytes memory _data
796     ) internal virtual {
797         _mint(to, tokenId);
798         require(
799             _checkOnERC721Received(address(0), to, tokenId, _data),
800             "ERC721: transfer to non ERC721Receiver implementer"
801         );
802     }
803 
804     /**
805      * @dev Mints `tokenId` and transfers it to `to`.
806      *
807      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
808      *
809      * Requirements:
810      *
811      * - `tokenId` must not exist.
812      * - `to` cannot be the zero address.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _mint(address to, uint256 tokenId) internal virtual {
817         require(to != address(0), "ERC721: mint to the zero address");
818         require(!_exists(tokenId), "ERC721: token already minted");
819 
820         _beforeTokenTransfer(address(0), to, tokenId);
821 
822         _balances[to] += 1;
823         _owners[tokenId] = to;
824 
825         emit Transfer(address(0), to, tokenId);
826     }
827 
828     /**
829      * @dev Destroys `tokenId`.
830      * The approval is cleared when the token is burned.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _burn(uint256 tokenId) internal virtual {
839         address owner = ERC721.ownerOf(tokenId);
840 
841         _beforeTokenTransfer(owner, address(0), tokenId);
842 
843         // Clear approvals
844         _approve(address(0), tokenId);
845 
846         _balances[owner] -= 1;
847         delete _owners[tokenId];
848 
849         emit Transfer(owner, address(0), tokenId);
850     }
851 
852     /**
853      * @dev Transfers `tokenId` from `from` to `to`.
854      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
855      *
856      * Requirements:
857      *
858      * - `to` cannot be the zero address.
859      * - `tokenId` token must be owned by `from`.
860      *
861      * Emits a {Transfer} event.
862      */
863     function _transfer(
864         address from,
865         address to,
866         uint256 tokenId
867     ) internal virtual {
868         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
869         require(to != address(0), "ERC721: transfer to the zero address");
870 
871         _beforeTokenTransfer(from, to, tokenId);
872 
873         // Clear approvals from the previous owner
874         _approve(address(0), tokenId);
875 
876         _balances[from] -= 1;
877         _balances[to] += 1;
878         _owners[tokenId] = to;
879 
880         emit Transfer(from, to, tokenId);
881     }
882 
883     /**
884      * @dev Approve `to` to operate on `tokenId`
885      *
886      * Emits a {Approval} event.
887      */
888     function _approve(address to, uint256 tokenId) internal virtual {
889         _tokenApprovals[tokenId] = to;
890         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
891     }
892 
893     /**
894      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
895      * The call is not executed if the target address is not a contract.
896      *
897      * @param from address representing the previous owner of the given token ID
898      * @param to target address that will receive the tokens
899      * @param tokenId uint256 ID of the token to be transferred
900      * @param _data bytes optional data to send along with the call
901      * @return bool whether the call correctly returned the expected magic value
902      */
903     function _checkOnERC721Received(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) private returns (bool) {
909         if (to.isContract()) {
910             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
911                 return retval == IERC721Receiver.onERC721Received.selector;
912             } catch (bytes memory reason) {
913                 if (reason.length == 0) {
914                     revert("ERC721: transfer to non ERC721Receiver implementer");
915                 } else {
916                     assembly {
917                         revert(add(32, reason), mload(reason))
918                     }
919                 }
920             }
921         } else {
922             return true;
923         }
924     }
925 
926     /**
927      * @dev Hook that is called before any token transfer. This includes minting
928      * and burning.
929      *
930      * Calling conditions:
931      *
932      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
933      * transferred to `to`.
934      * - When `from` is zero, `tokenId` will be minted for `to`.
935      * - When `to` is zero, ``from``'s `tokenId` will be burned.
936      * - `from` and `to` are never both zero.
937      *
938      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
939      */
940     function _beforeTokenTransfer(
941         address from,
942         address to,
943         uint256 tokenId
944     ) internal virtual {}
945 }
946 
947 
948 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
949 
950 
951 pragma solidity ^0.8.0;
952 
953 /**
954  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
955  * @dev See https://eips.ethereum.org/EIPS/eip-721
956  */
957 interface IERC721Enumerable is IERC721 {
958     /**
959      * @dev Returns the total amount of tokens stored by the contract.
960      */
961     function totalSupply() external view returns (uint256);
962 
963     /**
964      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
965      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
966      */
967     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
968 
969     /**
970      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
971      * Use along with {totalSupply} to enumerate all tokens.
972      */
973     function tokenByIndex(uint256 index) external view returns (uint256);
974 }
975 
976 
977 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
978 
979 
980 pragma solidity ^0.8.0;
981 
982 
983 /**
984  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
985  * enumerability of all the token ids in the contract as well as all token ids owned by each
986  * account.
987  */
988 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
989     // Mapping from owner to list of owned token IDs
990     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
991 
992     // Mapping from token ID to index of the owner tokens list
993     mapping(uint256 => uint256) private _ownedTokensIndex;
994 
995     // Array with all token ids, used for enumeration
996     uint256[] private _allTokens;
997 
998     // Mapping from token id to position in the allTokens array
999     mapping(uint256 => uint256) private _allTokensIndex;
1000 
1001     /**
1002      * @dev See {IERC165-supportsInterface}.
1003      */
1004     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1005         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1006     }
1007 
1008     /**
1009      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1010      */
1011     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1012         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1013         return _ownedTokens[owner][index];
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Enumerable-totalSupply}.
1018      */
1019     function totalSupply() public view virtual override returns (uint256) {
1020         return _allTokens.length;
1021     }
1022 
1023     /**
1024      * @dev See {IERC721Enumerable-tokenByIndex}.
1025      */
1026     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1027         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1028         return _allTokens[index];
1029     }
1030 
1031     /**
1032      * @dev Hook that is called before any token transfer. This includes minting
1033      * and burning.
1034      *
1035      * Calling conditions:
1036      *
1037      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1038      * transferred to `to`.
1039      * - When `from` is zero, `tokenId` will be minted for `to`.
1040      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1041      * - `from` cannot be the zero address.
1042      * - `to` cannot be the zero address.
1043      *
1044      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1045      */
1046     function _beforeTokenTransfer(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) internal virtual override {
1051         super._beforeTokenTransfer(from, to, tokenId);
1052 
1053         if (from == address(0)) {
1054             _addTokenToAllTokensEnumeration(tokenId);
1055         } else if (from != to) {
1056             _removeTokenFromOwnerEnumeration(from, tokenId);
1057         }
1058         if (to == address(0)) {
1059             _removeTokenFromAllTokensEnumeration(tokenId);
1060         } else if (to != from) {
1061             _addTokenToOwnerEnumeration(to, tokenId);
1062         }
1063     }
1064 
1065     /**
1066      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1067      * @param to address representing the new owner of the given token ID
1068      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1069      */
1070     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1071         uint256 length = ERC721.balanceOf(to);
1072         _ownedTokens[to][length] = tokenId;
1073         _ownedTokensIndex[tokenId] = length;
1074     }
1075 
1076     /**
1077      * @dev Private function to add a token to this extension's token tracking data structures.
1078      * @param tokenId uint256 ID of the token to be added to the tokens list
1079      */
1080     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1081         _allTokensIndex[tokenId] = _allTokens.length;
1082         _allTokens.push(tokenId);
1083     }
1084 
1085     /**
1086      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1087      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1088      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1089      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1090      * @param from address representing the previous owner of the given token ID
1091      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1092      */
1093     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1094         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1095         // then delete the last slot (swap and pop).
1096 
1097         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1098         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1099 
1100         // When the token to delete is the last token, the swap operation is unnecessary
1101         if (tokenIndex != lastTokenIndex) {
1102             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1103 
1104             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1105             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1106         }
1107 
1108         // This also deletes the contents at the last position of the array
1109         delete _ownedTokensIndex[tokenId];
1110         delete _ownedTokens[from][lastTokenIndex];
1111     }
1112 
1113     /**
1114      * @dev Private function to remove a token from this extension's token tracking data structures.
1115      * This has O(1) time complexity, but alters the order of the _allTokens array.
1116      * @param tokenId uint256 ID of the token to be removed from the tokens list
1117      */
1118     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1119         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1120         // then delete the last slot (swap and pop).
1121 
1122         uint256 lastTokenIndex = _allTokens.length - 1;
1123         uint256 tokenIndex = _allTokensIndex[tokenId];
1124 
1125         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1126         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1127         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1128         uint256 lastTokenId = _allTokens[lastTokenIndex];
1129 
1130         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1131         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1132 
1133         // This also deletes the contents at the last position of the array
1134         delete _allTokensIndex[tokenId];
1135         _allTokens.pop();
1136     }
1137 }
1138 
1139 /**
1140  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1141  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1142  *
1143  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1144  *
1145  * Does not support burning tokens to address(0).
1146  */
1147 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1148     using Address for address;
1149     using Strings for uint256;
1150 
1151     struct TokenOwnership {
1152         address addr;
1153         uint64 startTimestamp;
1154     }
1155 
1156     struct AddressData {
1157         uint128 balance;
1158         uint128 numberMinted;
1159     }
1160 
1161     uint256 private currentIndex = 1;
1162 
1163      uint256 internal immutable maxBatchSize;
1164 
1165     // Token name
1166     string private _name;
1167 
1168     // Token symbol
1169     string private _symbol;
1170 
1171     // Mapping from token ID to ownership details
1172     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1173     mapping(uint256 => TokenOwnership) private _ownerships;
1174 
1175     // Mapping owner address to address data
1176     mapping(address => AddressData) private _addressData;
1177 
1178     // Mapping from token ID to approved address
1179     mapping(uint256 => address) private _tokenApprovals;
1180 
1181     // Mapping from owner to operator approvals
1182     mapping(address => mapping(address => bool)) private _operatorApprovals;
1183 
1184     /**
1185      * @dev
1186      * `maxBatchSize` refers to how much a minter can mint at a time.
1187      */
1188     constructor(
1189         string memory name_,
1190         string memory symbol_,
1191         uint256 maxBatchSize_
1192     ) {
1193         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1194         _name = name_;
1195         _symbol = symbol_;
1196         maxBatchSize = maxBatchSize_;
1197     }
1198 
1199     /**
1200      * @dev See {IERC721Enumerable-totalSupply}.
1201      */
1202     function totalSupply() public view override returns (uint256) {
1203         return currentIndex;
1204     }
1205 
1206     /**
1207      * @dev See {IERC721Enumerable-tokenByIndex}.
1208      */
1209     function tokenByIndex(uint256 index) public view override returns (uint256) {
1210         require(index < totalSupply(), "ERC721A: global index out of bounds");
1211         return index;
1212     }
1213 
1214     /**
1215      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1216      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1217      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1218      */
1219     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1220         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1221         uint256 numMintedSoFar = totalSupply();
1222         uint256 tokenIdsIdx = 0;
1223         address currOwnershipAddr = address(0);
1224         for (uint256 i = 0; i < numMintedSoFar; i++) {
1225             TokenOwnership memory ownership = _ownerships[i];
1226             if (ownership.addr != address(0)) {
1227                 currOwnershipAddr = ownership.addr;
1228             }
1229             if (currOwnershipAddr == owner) {
1230                 if (tokenIdsIdx == index) {
1231                     return i;
1232                 }
1233                 tokenIdsIdx++;
1234             }
1235         }
1236         revert("ERC721A: unable to get token of owner by index");
1237     }
1238 
1239     /**
1240      * @dev See {IERC165-supportsInterface}.
1241      */
1242     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1243         return
1244             interfaceId == type(IERC721).interfaceId ||
1245             interfaceId == type(IERC721Metadata).interfaceId ||
1246             interfaceId == type(IERC721Enumerable).interfaceId ||
1247             super.supportsInterface(interfaceId);
1248     }
1249 
1250     /**
1251      * @dev See {IERC721-balanceOf}.
1252      */
1253     function balanceOf(address owner) public view override returns (uint256) {
1254         require(owner != address(0), "ERC721A: balance query for the zero address");
1255         return uint256(_addressData[owner].balance);
1256     }
1257 
1258     function _numberMinted(address owner) internal view returns (uint256) {
1259         require(owner != address(0), "ERC721A: number minted query for the zero address");
1260         return uint256(_addressData[owner].numberMinted);
1261     }
1262 
1263     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1264         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1265 
1266         uint256 lowestTokenToCheck;
1267         if (tokenId >= maxBatchSize) {
1268             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1269         }
1270 
1271         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1272             TokenOwnership memory ownership = _ownerships[curr];
1273             if (ownership.addr != address(0)) {
1274                 return ownership;
1275             }
1276         }
1277 
1278         revert("ERC721A: unable to determine the owner of token");
1279     }
1280 
1281     /**
1282      * @dev See {IERC721-ownerOf}.
1283      */
1284     function ownerOf(uint256 tokenId) public view override returns (address) {
1285         return ownershipOf(tokenId).addr;
1286     }
1287 
1288     /**
1289      * @dev See {IERC721Metadata-name}.
1290      */
1291     function name() public view virtual override returns (string memory) {
1292         return _name;
1293     }
1294 
1295     /**
1296      * @dev See {IERC721Metadata-symbol}.
1297      */
1298     function symbol() public view virtual override returns (string memory) {
1299         return _symbol;
1300     }
1301 
1302     /**
1303      * @dev See {IERC721Metadata-tokenURI}.
1304      */
1305     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1306         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1307 
1308         string memory baseURI = _baseURI();
1309         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1310     }
1311 
1312     /**
1313      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1314      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1315      * by default, can be overriden in child contracts.
1316      */
1317     function _baseURI() internal view virtual returns (string memory) {
1318         return "";
1319     }
1320 
1321     /**
1322      * @dev See {IERC721-approve}.
1323      */
1324     function approve(address to, uint256 tokenId) public override {
1325         address owner = ERC721A.ownerOf(tokenId);
1326         require(to != owner, "ERC721A: approval to current owner");
1327 
1328         require(
1329             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1330             "ERC721A: approve caller is not owner nor approved for all"
1331         );
1332 
1333         _approve(to, tokenId, owner);
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-getApproved}.
1338      */
1339     function getApproved(uint256 tokenId) public view override returns (address) {
1340         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1341 
1342         return _tokenApprovals[tokenId];
1343     }
1344 
1345     /**
1346      * @dev See {IERC721-setApprovalForAll}.
1347      */
1348     function setApprovalForAll(address operator, bool approved) public override {
1349         require(operator != _msgSender(), "ERC721A: approve to caller");
1350 
1351         _operatorApprovals[_msgSender()][operator] = approved;
1352         emit ApprovalForAll(_msgSender(), operator, approved);
1353     }
1354 
1355     /**
1356      * @dev See {IERC721-isApprovedForAll}.
1357      */
1358     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1359         return _operatorApprovals[owner][operator];
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-transferFrom}.
1364      */
1365     function transferFrom(
1366         address from,
1367         address to,
1368         uint256 tokenId
1369     ) public override {
1370         _transfer(from, to, tokenId);
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-safeTransferFrom}.
1375      */
1376     function safeTransferFrom(
1377         address from,
1378         address to,
1379         uint256 tokenId
1380     ) public override {
1381         safeTransferFrom(from, to, tokenId, "");
1382     }
1383 
1384     /**
1385      * @dev See {IERC721-safeTransferFrom}.
1386      */
1387     function safeTransferFrom(
1388         address from,
1389         address to,
1390         uint256 tokenId,
1391         bytes memory _data
1392     ) public override {
1393         _transfer(from, to, tokenId);
1394         require(
1395             _checkOnERC721Received(from, to, tokenId, _data),
1396             "ERC721A: transfer to non ERC721Receiver implementer"
1397         );
1398     }
1399 
1400     /**
1401      * @dev Returns whether `tokenId` exists.
1402      *
1403      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1404      *
1405      * Tokens start existing when they are minted (`_mint`),
1406      */
1407     function _exists(uint256 tokenId) internal view returns (bool) {
1408         return tokenId < currentIndex;
1409     }
1410 
1411     function _safeMint(address to, uint256 quantity) internal {
1412         _safeMint(to, quantity, "");
1413     }
1414 
1415     /**
1416      * @dev Mints `quantity` tokens and transfers them to `to`.
1417      *
1418      * Requirements:
1419      *
1420      * - `to` cannot be the zero address.
1421      * - `quantity` cannot be larger than the max batch size.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _safeMint(
1426         address to,
1427         uint256 quantity,
1428         bytes memory _data
1429     ) internal {
1430         uint256 startTokenId = currentIndex;
1431         require(to != address(0), "ERC721A: mint to the zero address");
1432         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1433         require(!_exists(startTokenId), "ERC721A: token already minted");
1434         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1435 
1436         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1437 
1438         AddressData memory addressData = _addressData[to];
1439         _addressData[to] = AddressData(
1440             addressData.balance + uint128(quantity),
1441             addressData.numberMinted + uint128(quantity)
1442         );
1443         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1444 
1445         uint256 updatedIndex = startTokenId;
1446 
1447         for (uint256 i = 0; i < quantity; i++) {
1448             emit Transfer(address(0), to, updatedIndex);
1449             require(
1450                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1451                 "ERC721A: transfer to non ERC721Receiver implementer"
1452             );
1453             updatedIndex++;
1454         }
1455 
1456         currentIndex = updatedIndex;
1457         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1458     }
1459 
1460     /**
1461      * @dev Transfers `tokenId` from `from` to `to`.
1462      *
1463      * Requirements:
1464      *
1465      * - `to` cannot be the zero address.
1466      * - `tokenId` token must be owned by `from`.
1467      *
1468      * Emits a {Transfer} event.
1469      */
1470     function _transfer(
1471         address from,
1472         address to,
1473         uint256 tokenId
1474     ) private {
1475         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1476 
1477         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1478             getApproved(tokenId) == _msgSender() ||
1479             isApprovedForAll(prevOwnership.addr, _msgSender()));
1480 
1481         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1482 
1483         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1484         require(to != address(0), "ERC721A: transfer to the zero address");
1485 
1486         _beforeTokenTransfers(from, to, tokenId, 1);
1487 
1488         // Clear approvals from the previous owner
1489         _approve(address(0), tokenId, prevOwnership.addr);
1490 
1491         _addressData[from].balance -= 1;
1492         _addressData[to].balance += 1;
1493         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1494 
1495         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1496         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1497         uint256 nextTokenId = tokenId + 1;
1498         if (_ownerships[nextTokenId].addr == address(0)) {
1499             if (_exists(nextTokenId)) {
1500                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1501             }
1502         }
1503 
1504         emit Transfer(from, to, tokenId);
1505         _afterTokenTransfers(from, to, tokenId, 1);
1506     }
1507 
1508     /**
1509      * @dev Approve `to` to operate on `tokenId`
1510      *
1511      * Emits a {Approval} event.
1512      */
1513     function _approve(
1514         address to,
1515         uint256 tokenId,
1516         address owner
1517     ) private {
1518         _tokenApprovals[tokenId] = to;
1519         emit Approval(owner, to, tokenId);
1520     }
1521 
1522     uint256 public nextOwnerToExplicitlySet = 0;
1523 
1524     /**
1525      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1526      */
1527     function _setOwnersExplicit(uint256 quantity) internal {
1528         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1529         require(quantity > 0, "quantity must be nonzero");
1530         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1531         if (endIndex > currentIndex - 1) {
1532             endIndex = currentIndex - 1;
1533         }
1534         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1535         require(_exists(endIndex), "not enough minted yet for this cleanup");
1536         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1537             if (_ownerships[i].addr == address(0)) {
1538                 TokenOwnership memory ownership = ownershipOf(i);
1539                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1540             }
1541         }
1542         nextOwnerToExplicitlySet = endIndex + 1;
1543     }
1544 
1545     /**
1546      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1547      * The call is not executed if the target address is not a contract.
1548      *
1549      * @param from address representing the previous owner of the given token ID
1550      * @param to target address that will receive the tokens
1551      * @param tokenId uint256 ID of the token to be transferred
1552      * @param _data bytes optional data to send along with the call
1553      * @return bool whether the call correctly returned the expected magic value
1554      */
1555     function _checkOnERC721Received(
1556         address from,
1557         address to,
1558         uint256 tokenId,
1559         bytes memory _data
1560     ) private returns (bool) {
1561         if (to.isContract()) {
1562             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1563                 return retval == IERC721Receiver(to).onERC721Received.selector;
1564             } catch (bytes memory reason) {
1565                 if (reason.length == 0) {
1566                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1567                 } else {
1568                     assembly {
1569                         revert(add(32, reason), mload(reason))
1570                     }
1571                 }
1572             }
1573         } else {
1574             return true;
1575         }
1576     }
1577 
1578     /**
1579      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1580      *
1581      * startTokenId - the first token id to be transferred
1582      * quantity - the amount to be transferred
1583      *
1584      * Calling conditions:
1585      *
1586      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1587      * transferred to `to`.
1588      * - When `from` is zero, `tokenId` will be minted for `to`.
1589      */
1590     function _beforeTokenTransfers(
1591         address from,
1592         address to,
1593         uint256 startTokenId,
1594         uint256 quantity
1595     ) internal virtual {}
1596 
1597     /**
1598      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1599      * minting.
1600      *
1601      * startTokenId - the first token id to be transferred
1602      * quantity - the amount to be transferred
1603      *
1604      * Calling conditions:
1605      *
1606      * - when `from` and `to` are both non-zero.
1607      * - `from` and `to` are never both zero.
1608      */
1609     function _afterTokenTransfers(
1610         address from,
1611         address to,
1612         uint256 startTokenId,
1613         uint256 quantity
1614     ) internal virtual {}
1615 }
1616 
1617 pragma solidity ^0.8.0;
1618 
1619 contract FunkyFlies is ERC721A
1620 {
1621     using Strings for uint256;
1622 
1623     string public baseURI;
1624     uint256 public cost;
1625     uint256 public maxSupply;
1626     uint256 public maxMintAmount = 50;
1627     uint256 public maxMintPerTransaction = 50;
1628     address public owner;
1629     bool public preSaleLive;
1630     bool public mintLive;
1631 
1632     mapping(address => bool) private whiteList;
1633     mapping(address => uint256) private mintCount;
1634 
1635     modifier onlyOwner() {
1636         require(owner == msg.sender, "not owner");
1637         _;
1638     }
1639 
1640     modifier preSaleIsLive() {
1641         require(preSaleLive, "preSale not live");
1642         _;
1643     }
1644 
1645     modifier mintIsLive() {
1646         require(mintLive, "mint not live");
1647         _;
1648     }
1649 
1650     constructor(string memory defaultBaseURI) ERC721A("Funky Flies", "FUNKY", maxMintAmount) {
1651         owner = msg.sender;
1652         baseURI = defaultBaseURI;
1653         maxSupply = 7777;
1654         maxMintPerTransaction;
1655         cost = 50000000000000000;
1656     }
1657 
1658     function isWhiteListed(address _address) public view returns (bool){
1659         return whiteList[_address];
1660     }
1661 
1662     function mintedByAddressCount(address _address) public view returns (uint256){
1663         return mintCount[_address];
1664     }
1665 
1666     function setCost(uint256 _newCost) public onlyOwner {
1667         cost = _newCost;
1668     }
1669 
1670     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1671         maxMintAmount = _newmaxMintAmount;
1672     }
1673 
1674     function setmaxMintPerTransaction(uint256 _newmaxMintPerTransaction) public onlyOwner {
1675         maxMintPerTransaction = _newmaxMintPerTransaction;
1676     }
1677 
1678     // Minting functions
1679     function mint(uint256 _mintAmount) external payable mintIsLive {
1680         address _to = msg.sender;
1681         uint256 minted = mintCount[_to];
1682         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1683         require(_mintAmount <= maxMintPerTransaction, "amount must < max");
1684         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1685         require(msg.value >= cost * _mintAmount, "insufficient funds");
1686 
1687         mintCount[_to] = minted + _mintAmount;
1688         _safeMint(msg.sender, _mintAmount);
1689     }
1690 
1691     function preSaleMint(uint256 _mintAmount) external payable preSaleIsLive {
1692         address _to = msg.sender;
1693         uint256 minted = mintCount[_to];
1694         require(whiteList[_to], "not whitelisted");
1695         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1696         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1697         require(msg.value >= cost * _mintAmount, "insufficient funds");
1698 
1699         mintCount[_to] = minted + _mintAmount;
1700         _safeMint(msg.sender, _mintAmount);
1701     }
1702 
1703     // Only Owner executable functions
1704     function mintByOwner(address _to, uint256 _mintAmount) external onlyOwner {
1705         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1706         if (_mintAmount <= maxBatchSize) {
1707             _safeMint(_to, _mintAmount);
1708             return;
1709         }
1710         
1711         uint256 leftToMint = _mintAmount;
1712         while (leftToMint > 0) {
1713             if (leftToMint <= maxBatchSize) {
1714                 _safeMint(_to, leftToMint);
1715                 return;
1716             }
1717             _safeMint(_to, maxBatchSize);
1718             leftToMint = leftToMint - maxBatchSize;
1719         }
1720     }
1721 
1722     function addToWhiteList(address[] calldata _addresses) external onlyOwner {
1723         for (uint256 i; i < _addresses.length; i++) {
1724             whiteList[_addresses[i]] = true;
1725         }
1726     }
1727 
1728     function togglePreSaleLive() external onlyOwner {
1729         if (preSaleLive) {
1730             preSaleLive = false;
1731             return;
1732         }
1733         preSaleLive = true;
1734     }
1735 
1736     function toggleMintLive() external onlyOwner {
1737         if (mintLive) {
1738             mintLive = false;
1739             return;
1740         }
1741         preSaleLive = false;
1742         mintLive = true;
1743     }
1744 
1745     function setBaseURI(string memory _newURI) external onlyOwner {
1746         baseURI = _newURI;
1747     }
1748 
1749     function withdraw() external payable onlyOwner {
1750         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1751         require(success, "Transfer failed");
1752     }
1753 
1754     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1755         _setOwnersExplicit(quantity);
1756     }
1757 
1758     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1759         require(_exists(_tokenId), "URI query for nonexistent token");
1760 
1761         string memory baseTokenURI = _baseURI();
1762         string memory json = ".json";
1763         return bytes(baseTokenURI).length > 0
1764             ? string(abi.encodePacked(baseTokenURI, _tokenId.toString(), json))
1765             : '';
1766     }
1767 
1768     function _baseURI() internal view virtual override returns (string memory) {
1769         return baseURI;
1770     }
1771 
1772     fallback() external payable { }
1773 
1774     receive() external payable { }
1775 }