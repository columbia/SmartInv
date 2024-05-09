1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(
81         address from,
82         address to,
83         uint256 tokenId
84     ) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(
101         address from,
102         address to,
103         uint256 tokenId
104     ) external;
105 
106     /**
107      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
108      * The approval is cleared when the token is transferred.
109      *
110      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
111      *
112      * Requirements:
113      *
114      * - The caller must own the token or be an approved operator.
115      * - `tokenId` must exist.
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address to, uint256 tokenId) external;
120 
121     /**
122      * @dev Returns the account approved for `tokenId` token.
123      *
124      * Requirements:
125      *
126      * - `tokenId` must exist.
127      */
128     function getApproved(uint256 tokenId) external view returns (address operator);
129 
130     /**
131      * @dev Approve or remove `operator` as an operator for the caller.
132      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
133      *
134      * Requirements:
135      *
136      * - The `operator` cannot be the caller.
137      *
138      * Emits an {ApprovalForAll} event.
139      */
140     function setApprovalForAll(address operator, bool _approved) external;
141 
142     /**
143      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
144      *
145      * See {setApprovalForAll}
146      */
147     function isApprovedForAll(address owner, address operator) external view returns (bool);
148 
149     /**
150      * @dev Safely transfers `tokenId` token from `from` to `to`.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId,
166         bytes calldata data
167     ) external;
168 }
169 
170 
171 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @title ERC721 token receiver interface
177  * @dev Interface for any contract that wants to support safeTransfers
178  * from ERC721 asset contracts.
179  */
180 interface IERC721Receiver {
181     /**
182      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
183      * by `operator` from `from`, this function is called.
184      *
185      * It must return its Solidity selector to confirm the token transfer.
186      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
187      *
188      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
189      */
190     function onERC721Received(
191         address operator,
192         address from,
193         uint256 tokenId,
194         bytes calldata data
195     ) external returns (bytes4);
196 }
197 
198 
199 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Metadata is IERC721 {
209     /**
210      * @dev Returns the token collection name.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the token collection symbol.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
221      */
222     function tokenURI(uint256 tokenId) external view returns (string memory);
223 }
224 
225 
226 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Collection of functions related to the address type
232  */
233 library Address {
234     /**
235      * @dev Returns true if `account` is a contract.
236      *
237      * [IMPORTANT]
238      * ====
239      * It is unsafe to assume that an address for which this function returns
240      * false is an externally-owned account (EOA) and not a contract.
241      *
242      * Among others, `isContract` will return false for the following
243      * types of addresses:
244      *
245      *  - an externally-owned account
246      *  - a contract in construction
247      *  - an address where a contract will be created
248      *  - an address where a contract lived, but was destroyed
249      * ====
250      */
251     function isContract(address account) internal view returns (bool) {
252         // This method relies on extcodesize, which returns 0 for contracts in
253         // construction, since the code is only stored at the end of the
254         // constructor execution.
255 
256         uint256 size;
257         assembly {
258             size := extcodesize(account)
259         }
260         return size > 0;
261     }
262 
263     /**
264      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265      * `recipient`, forwarding all available gas and reverting on errors.
266      *
267      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268      * of certain opcodes, possibly making contracts go over the 2300 gas limit
269      * imposed by `transfer`, making them unable to receive funds via
270      * `transfer`. {sendValue} removes this limitation.
271      *
272      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273      *
274      * IMPORTANT: because control is transferred to `recipient`, care must be
275      * taken to not create reentrancy vulnerabilities. Consider using
276      * {ReentrancyGuard} or the
277      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278      */
279     function sendValue(address payable recipient, uint256 amount) internal {
280         require(address(this).balance >= amount, "Address: insufficient balance");
281 
282         (bool success, ) = recipient.call{value: amount}("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287      * @dev Performs a Solidity function call using a low level `call`. A
288      * plain `call` is an unsafe replacement for a function call: use this
289      * function instead.
290      *
291      * If `target` reverts with a revert reason, it is bubbled up by this
292      * function (like regular Solidity function calls).
293      *
294      * Returns the raw returned data. To convert to the expected return value,
295      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296      *
297      * Requirements:
298      *
299      * - `target` must be a contract.
300      * - calling `target` with `data` must not revert.
301      *
302      * _Available since v3.1._
303      */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310      * `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(
315         address target,
316         bytes memory data,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         return functionCallWithValue(target, data, 0, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but also transferring `value` wei to `target`.
325      *
326      * Requirements:
327      *
328      * - the calling contract must have an ETH balance of at least `value`.
329      * - the called Solidity function must be `payable`.
330      *
331      * _Available since v3.1._
332      */
333     function functionCallWithValue(
334         address target,
335         bytes memory data,
336         uint256 value
337     ) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(
348         address target,
349         bytes memory data,
350         uint256 value,
351         string memory errorMessage
352     ) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.staticcall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a delegate call.
390      *
391      * _Available since v3.4._
392      */
393     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
394         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a delegate call.
400      *
401      * _Available since v3.4._
402      */
403     function functionDelegateCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.delegatecall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
416      * revert reason using the provided one.
417      *
418      * _Available since v4.3._
419      */
420     function verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) internal pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 assembly {
433                     let returndata_size := mload(returndata)
434                     revert(add(32, returndata), returndata_size)
435                 }
436             } else {
437                 revert(errorMessage);
438             }
439         }
440     }
441 }
442 
443 
444 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 /**
449  * @dev Provides information about the current execution context, including the
450  * sender of the transaction and its data. While these are generally available
451  * via msg.sender and msg.data, they should not be accessed in such a direct
452  * manner, since when dealing with meta-transactions the account sending and
453  * paying for execution may not be the actual sender (as far as an application
454  * is concerned).
455  *
456  * This contract is only required for intermediate, library-like contracts.
457  */
458 abstract contract Context {
459     function _msgSender() internal view virtual returns (address) {
460         return msg.sender;
461     }
462 
463     function _msgData() internal view virtual returns (bytes calldata) {
464         return msg.data;
465     }
466 }
467 
468 
469 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev String operations.
475  */
476 library Strings {
477     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
478 
479     /**
480      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
481      */
482     function toString(uint256 value) internal pure returns (string memory) {
483         // Inspired by OraclizeAPI's implementation - MIT licence
484         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
485 
486         if (value == 0) {
487             return "0";
488         }
489         uint256 temp = value;
490         uint256 digits;
491         while (temp != 0) {
492             digits++;
493             temp /= 10;
494         }
495         bytes memory buffer = new bytes(digits);
496         while (value != 0) {
497             digits -= 1;
498             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
499             value /= 10;
500         }
501         return string(buffer);
502     }
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
506      */
507     function toHexString(uint256 value) internal pure returns (string memory) {
508         if (value == 0) {
509             return "0x00";
510         }
511         uint256 temp = value;
512         uint256 length = 0;
513         while (temp != 0) {
514             length++;
515             temp >>= 8;
516         }
517         return toHexString(value, length);
518     }
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
522      */
523     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
524         bytes memory buffer = new bytes(2 * length + 2);
525         buffer[0] = "0";
526         buffer[1] = "x";
527         for (uint256 i = 2 * length + 1; i > 1; --i) {
528             buffer[i] = _HEX_SYMBOLS[value & 0xf];
529             value >>= 4;
530         }
531         require(value == 0, "Strings: hex length insufficient");
532         return string(buffer);
533     }
534 }
535 
536 
537 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev Implementation of the {IERC165} interface.
544  *
545  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
546  * for the additional interface id that will be supported. For example:
547  *
548  * ```solidity
549  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
551  * }
552  * ```
553  *
554  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
555  */
556 abstract contract ERC165 is IERC165 {
557     /**
558      * @dev See {IERC165-supportsInterface}.
559      */
560     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561         return interfaceId == type(IERC165).interfaceId;
562     }
563 }
564 
565 
566 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
567 
568 pragma solidity ^0.8.0;
569 
570 
571 /**
572  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
573  * the Metadata extension, but not including the Enumerable extension, which is available separately as
574  * {ERC721Enumerable}.
575  */
576 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
577     using Address for address;
578     using Strings for uint256;
579 
580     // Token name
581     string private _name;
582 
583     // Token symbol
584     string private _symbol;
585 
586     // Mapping from token ID to owner address
587     mapping(uint256 => address) private _owners;
588 
589     // Mapping owner address to token count
590     mapping(address => uint256) private _balances;
591 
592     // Mapping from token ID to approved address
593     mapping(uint256 => address) private _tokenApprovals;
594 
595     // Mapping from owner to operator approvals
596     mapping(address => mapping(address => bool)) private _operatorApprovals;
597 
598     /**
599      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
600      */
601     constructor(string memory name_, string memory symbol_) {
602         _name = name_;
603         _symbol = symbol_;
604     }
605 
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
610         return
611             interfaceId == type(IERC721).interfaceId ||
612             interfaceId == type(IERC721Metadata).interfaceId ||
613             super.supportsInterface(interfaceId);
614     }
615 
616     /**
617      * @dev See {IERC721-balanceOf}.
618      */
619     function balanceOf(address owner) public view virtual override returns (uint256) {
620         require(owner != address(0), "ERC721: balance query for the zero address");
621         return _balances[owner];
622     }
623 
624     /**
625      * @dev See {IERC721-ownerOf}.
626      */
627     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
628         address owner = _owners[tokenId];
629         require(owner != address(0), "ERC721: owner query for nonexistent token");
630         return owner;
631     }
632 
633     /**
634      * @dev See {IERC721Metadata-name}.
635      */
636     function name() public view virtual override returns (string memory) {
637         return _name;
638     }
639 
640     /**
641      * @dev See {IERC721Metadata-symbol}.
642      */
643     function symbol() public view virtual override returns (string memory) {
644         return _symbol;
645     }
646 
647     /**
648      * @dev See {IERC721Metadata-tokenURI}.
649      */
650     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
651         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
652 
653         string memory baseURI = _baseURI();
654         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
655     }
656 
657     /**
658      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
659      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
660      * by default, can be overriden in child contracts.
661      */
662     function _baseURI() internal view virtual returns (string memory) {
663         return "";
664     }
665 
666     /**
667      * @dev See {IERC721-approve}.
668      */
669     function approve(address to, uint256 tokenId) public virtual override {
670         address owner = ERC721.ownerOf(tokenId);
671         require(to != owner, "ERC721: approval to current owner");
672 
673         require(
674             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
675             "ERC721: approve caller is not owner nor approved for all"
676         );
677 
678         _approve(to, tokenId);
679     }
680 
681     /**
682      * @dev See {IERC721-getApproved}.
683      */
684     function getApproved(uint256 tokenId) public view virtual override returns (address) {
685         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
686 
687         return _tokenApprovals[tokenId];
688     }
689 
690     /**
691      * @dev See {IERC721-setApprovalForAll}.
692      */
693     function setApprovalForAll(address operator, bool approved) public virtual override {
694         _setApprovalForAll(_msgSender(), operator, approved);
695     }
696 
697     /**
698      * @dev See {IERC721-isApprovedForAll}.
699      */
700     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
701         return _operatorApprovals[owner][operator];
702     }
703 
704     /**
705      * @dev See {IERC721-transferFrom}.
706      */
707     function transferFrom(
708         address from,
709         address to,
710         uint256 tokenId
711     ) public virtual override {
712         //solhint-disable-next-line max-line-length
713         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
714 
715         _transfer(from, to, tokenId);
716     }
717 
718     /**
719      * @dev See {IERC721-safeTransferFrom}.
720      */
721     function safeTransferFrom(
722         address from,
723         address to,
724         uint256 tokenId
725     ) public virtual override {
726         safeTransferFrom(from, to, tokenId, "");
727     }
728 
729     /**
730      * @dev See {IERC721-safeTransferFrom}.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId,
736         bytes memory _data
737     ) public virtual override {
738         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
739         _safeTransfer(from, to, tokenId, _data);
740     }
741 
742     /**
743      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
744      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
745      *
746      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
747      *
748      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
749      * implement alternative mechanisms to perform token transfer, such as signature-based.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must exist and be owned by `from`.
756      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
757      *
758      * Emits a {Transfer} event.
759      */
760     function _safeTransfer(
761         address from,
762         address to,
763         uint256 tokenId,
764         bytes memory _data
765     ) internal virtual {
766         _transfer(from, to, tokenId);
767         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
768     }
769 
770     /**
771      * @dev Returns whether `tokenId` exists.
772      *
773      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
774      *
775      * Tokens start existing when they are minted (`_mint`),
776      * and stop existing when they are burned (`_burn`).
777      */
778     function _exists(uint256 tokenId) internal view virtual returns (bool) {
779         return _owners[tokenId] != address(0);
780     }
781 
782     /**
783      * @dev Returns whether `spender` is allowed to manage `tokenId`.
784      *
785      * Requirements:
786      *
787      * - `tokenId` must exist.
788      */
789     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
790         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
791         address owner = ERC721.ownerOf(tokenId);
792         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
793     }
794 
795     /**
796      * @dev Safely mints `tokenId` and transfers it to `to`.
797      *
798      * Requirements:
799      *
800      * - `tokenId` must not exist.
801      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
802      *
803      * Emits a {Transfer} event.
804      */
805     function _safeMint(address to, uint256 tokenId) internal virtual {
806         _safeMint(to, tokenId, "");
807     }
808 
809     /**
810      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
811      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
812      */
813     function _safeMint(
814         address to,
815         uint256 tokenId,
816         bytes memory _data
817     ) internal virtual {
818         _mint(to, tokenId);
819         require(
820             _checkOnERC721Received(address(0), to, tokenId, _data),
821             "ERC721: transfer to non ERC721Receiver implementer"
822         );
823     }
824 
825     /**
826      * @dev Mints `tokenId` and transfers it to `to`.
827      *
828      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
829      *
830      * Requirements:
831      *
832      * - `tokenId` must not exist.
833      * - `to` cannot be the zero address.
834      *
835      * Emits a {Transfer} event.
836      */
837     function _mint(address to, uint256 tokenId) internal virtual {
838         require(to != address(0), "ERC721: mint to the zero address");
839         require(!_exists(tokenId), "ERC721: token already minted");
840 
841         _beforeTokenTransfer(address(0), to, tokenId);
842 
843         _balances[to] += 1;
844         _owners[tokenId] = to;
845 
846         emit Transfer(address(0), to, tokenId);
847     }
848 
849     /**
850      * @dev Destroys `tokenId`.
851      * The approval is cleared when the token is burned.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      *
857      * Emits a {Transfer} event.
858      */
859     function _burn(uint256 tokenId) internal virtual {
860         address owner = ERC721.ownerOf(tokenId);
861 
862         _beforeTokenTransfer(owner, address(0), tokenId);
863 
864         // Clear approvals
865         _approve(address(0), tokenId);
866 
867         _balances[owner] -= 1;
868         delete _owners[tokenId];
869 
870         emit Transfer(owner, address(0), tokenId);
871     }
872 
873     /**
874      * @dev Transfers `tokenId` from `from` to `to`.
875      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
876      *
877      * Requirements:
878      *
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must be owned by `from`.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _transfer(
885         address from,
886         address to,
887         uint256 tokenId
888     ) internal virtual {
889         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
890         require(to != address(0), "ERC721: transfer to the zero address");
891 
892         _beforeTokenTransfer(from, to, tokenId);
893 
894         // Clear approvals from the previous owner
895         _approve(address(0), tokenId);
896 
897         _balances[from] -= 1;
898         _balances[to] += 1;
899         _owners[tokenId] = to;
900 
901         emit Transfer(from, to, tokenId);
902     }
903 
904     /**
905      * @dev Approve `to` to operate on `tokenId`
906      *
907      * Emits a {Approval} event.
908      */
909     function _approve(address to, uint256 tokenId) internal virtual {
910         _tokenApprovals[tokenId] = to;
911         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
912     }
913 
914     /**
915      * @dev Approve `operator` to operate on all of `owner` tokens
916      *
917      * Emits a {ApprovalForAll} event.
918      */
919     function _setApprovalForAll(
920         address owner,
921         address operator,
922         bool approved
923     ) internal virtual {
924         require(owner != operator, "ERC721: approve to caller");
925         _operatorApprovals[owner][operator] = approved;
926         emit ApprovalForAll(owner, operator, approved);
927     }
928 
929     /**
930      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
931      * The call is not executed if the target address is not a contract.
932      *
933      * @param from address representing the previous owner of the given token ID
934      * @param to target address that will receive the tokens
935      * @param tokenId uint256 ID of the token to be transferred
936      * @param _data bytes optional data to send along with the call
937      * @return bool whether the call correctly returned the expected magic value
938      */
939     function _checkOnERC721Received(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) private returns (bool) {
945         if (to.isContract()) {
946             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
947                 return retval == IERC721Receiver.onERC721Received.selector;
948             } catch (bytes memory reason) {
949                 if (reason.length == 0) {
950                     revert("ERC721: transfer to non ERC721Receiver implementer");
951                 } else {
952                     assembly {
953                         revert(add(32, reason), mload(reason))
954                     }
955                 }
956             }
957         } else {
958             return true;
959         }
960     }
961 
962     /**
963      * @dev Hook that is called before any token transfer. This includes minting
964      * and burning.
965      *
966      * Calling conditions:
967      *
968      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
969      * transferred to `to`.
970      * - When `from` is zero, `tokenId` will be minted for `to`.
971      * - When `to` is zero, ``from``'s `tokenId` will be burned.
972      * - `from` and `to` are never both zero.
973      *
974      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
975      */
976     function _beforeTokenTransfer(
977         address from,
978         address to,
979         uint256 tokenId
980     ) internal virtual {}
981 }
982 
983 
984 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
985 
986 pragma solidity ^0.8.0;
987 
988 
989 /**
990  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
991  * @dev See https://eips.ethereum.org/EIPS/eip-721
992  */
993 interface IERC721Enumerable is IERC721 {
994     /**
995      * @dev Returns the total amount of tokens stored by the contract.
996      */
997     function totalSupply() external view returns (uint256);
998 
999     /**
1000      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1001      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1002      */
1003     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1004 
1005     /**
1006      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1007      * Use along with {totalSupply} to enumerate all tokens.
1008      */
1009     function tokenByIndex(uint256 index) external view returns (uint256);
1010 }
1011 
1012 
1013 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 
1018 
1019 /**
1020  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1021  * enumerability of all the token ids in the contract as well as all token ids owned by each
1022  * account.
1023  */
1024 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1025     // Mapping from owner to list of owned token IDs
1026     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1027 
1028     // Mapping from token ID to index of the owner tokens list
1029     mapping(uint256 => uint256) private _ownedTokensIndex;
1030 
1031     // Array with all token ids, used for enumeration
1032     uint256[] private _allTokens;
1033 
1034     // Mapping from token id to position in the allTokens array
1035     mapping(uint256 => uint256) private _allTokensIndex;
1036 
1037     /**
1038      * @dev See {IERC165-supportsInterface}.
1039      */
1040     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1041         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1046      */
1047     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1048         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1049         return _ownedTokens[owner][index];
1050     }
1051 
1052     /**
1053      * @dev See {IERC721Enumerable-totalSupply}.
1054      */
1055     function totalSupply() public view virtual override returns (uint256) {
1056         return _allTokens.length;
1057     }
1058 
1059     /**
1060      * @dev See {IERC721Enumerable-tokenByIndex}.
1061      */
1062     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1063         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1064         return _allTokens[index];
1065     }
1066 
1067     /**
1068      * @dev Hook that is called before any token transfer. This includes minting
1069      * and burning.
1070      *
1071      * Calling conditions:
1072      *
1073      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1074      * transferred to `to`.
1075      * - When `from` is zero, `tokenId` will be minted for `to`.
1076      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1077      * - `from` cannot be the zero address.
1078      * - `to` cannot be the zero address.
1079      *
1080      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1081      */
1082     function _beforeTokenTransfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual override {
1087         super._beforeTokenTransfer(from, to, tokenId);
1088 
1089         if (from == address(0)) {
1090             _addTokenToAllTokensEnumeration(tokenId);
1091         } else if (from != to) {
1092             _removeTokenFromOwnerEnumeration(from, tokenId);
1093         }
1094         if (to == address(0)) {
1095             _removeTokenFromAllTokensEnumeration(tokenId);
1096         } else if (to != from) {
1097             _addTokenToOwnerEnumeration(to, tokenId);
1098         }
1099     }
1100 
1101     /**
1102      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1103      * @param to address representing the new owner of the given token ID
1104      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1105      */
1106     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1107         uint256 length = ERC721.balanceOf(to);
1108         _ownedTokens[to][length] = tokenId;
1109         _ownedTokensIndex[tokenId] = length;
1110     }
1111 
1112     /**
1113      * @dev Private function to add a token to this extension's token tracking data structures.
1114      * @param tokenId uint256 ID of the token to be added to the tokens list
1115      */
1116     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1117         _allTokensIndex[tokenId] = _allTokens.length;
1118         _allTokens.push(tokenId);
1119     }
1120 
1121     /**
1122      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1123      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1124      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1125      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1126      * @param from address representing the previous owner of the given token ID
1127      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1128      */
1129     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1130         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1131         // then delete the last slot (swap and pop).
1132 
1133         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1134         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1135 
1136         // When the token to delete is the last token, the swap operation is unnecessary
1137         if (tokenIndex != lastTokenIndex) {
1138             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1139 
1140             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1141             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1142         }
1143 
1144         // This also deletes the contents at the last position of the array
1145         delete _ownedTokensIndex[tokenId];
1146         delete _ownedTokens[from][lastTokenIndex];
1147     }
1148 
1149     /**
1150      * @dev Private function to remove a token from this extension's token tracking data structures.
1151      * This has O(1) time complexity, but alters the order of the _allTokens array.
1152      * @param tokenId uint256 ID of the token to be removed from the tokens list
1153      */
1154     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1155         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1156         // then delete the last slot (swap and pop).
1157 
1158         uint256 lastTokenIndex = _allTokens.length - 1;
1159         uint256 tokenIndex = _allTokensIndex[tokenId];
1160 
1161         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1162         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1163         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1164         uint256 lastTokenId = _allTokens[lastTokenIndex];
1165 
1166         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1167         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1168 
1169         // This also deletes the contents at the last position of the array
1170         delete _allTokensIndex[tokenId];
1171         _allTokens.pop();
1172     }
1173 }
1174 
1175 
1176 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 /**
1182  * @dev Contract module which provides a basic access control mechanism, where
1183  * there is an account (an owner) that can be granted exclusive access to
1184  * specific functions.
1185  *
1186  * By default, the owner account will be the one that deploys the contract. This
1187  * can later be changed with {transferOwnership}.
1188  *
1189  * This module is used through inheritance. It will make available the modifier
1190  * `onlyOwner`, which can be applied to your functions to restrict their use to
1191  * the owner.
1192  */
1193 abstract contract Ownable is Context {
1194     address private _owner;
1195 
1196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1197 
1198     /**
1199      * @dev Initializes the contract setting the deployer as the initial owner.
1200      */
1201     constructor() {
1202         _transferOwnership(_msgSender());
1203     }
1204 
1205     /**
1206      * @dev Returns the address of the current owner.
1207      */
1208     function owner() public view virtual returns (address) {
1209         return _owner;
1210     }
1211 
1212     /**
1213      * @dev Throws if called by any account other than the owner.
1214      */
1215     modifier onlyOwner() {
1216         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1217         _;
1218     }
1219 
1220     /**
1221      * @dev Leaves the contract without owner. It will not be possible to call
1222      * `onlyOwner` functions anymore. Can only be called by the current owner.
1223      *
1224      * NOTE: Renouncing ownership will leave the contract without an owner,
1225      * thereby removing any functionality that is only available to the owner.
1226      */
1227     function renounceOwnership() public virtual onlyOwner {
1228         _transferOwnership(address(0));
1229     }
1230 
1231     /**
1232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1233      * Can only be called by the current owner.
1234      */
1235     function transferOwnership(address newOwner) public virtual onlyOwner {
1236         require(newOwner != address(0), "Ownable: new owner is the zero address");
1237         _transferOwnership(newOwner);
1238     }
1239 
1240     /**
1241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1242      * Internal function without access restriction.
1243      */
1244     function _transferOwnership(address newOwner) internal virtual {
1245         address oldOwner = _owner;
1246         _owner = newOwner;
1247         emit OwnershipTransferred(oldOwner, newOwner);
1248     }
1249 }
1250 
1251 
1252 // OpenZeppelin Contracts v4.4.0 (security/Pausable.sol)
1253 
1254 pragma solidity ^0.8.0;
1255 
1256 
1257 /**
1258  * @dev Contract module which allows children to implement an emergency stop
1259  * mechanism that can be triggered by an authorized account.
1260  *
1261  * This module is used through inheritance. It will make available the
1262  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1263  * the functions of your contract. Note that they will not be pausable by
1264  * simply including this module, only once the modifiers are put in place.
1265  */
1266 abstract contract Pausable is Context {
1267     /**
1268      * @dev Emitted when the pause is triggered by `account`.
1269      */
1270     event Paused(address account);
1271 
1272     /**
1273      * @dev Emitted when the pause is lifted by `account`.
1274      */
1275     event Unpaused(address account);
1276 
1277     bool private _paused;
1278 
1279     /**
1280      * @dev Initializes the contract in unpaused state.
1281      */
1282     constructor() {
1283         _paused = false;
1284     }
1285 
1286     /**
1287      * @dev Returns true if the contract is paused, and false otherwise.
1288      */
1289     function paused() public view virtual returns (bool) {
1290         return _paused;
1291     }
1292 
1293     /**
1294      * @dev Modifier to make a function callable only when the contract is not paused.
1295      *
1296      * Requirements:
1297      *
1298      * - The contract must not be paused.
1299      */
1300     modifier whenNotPaused() {
1301         require(!paused(), "Pausable: paused");
1302         _;
1303     }
1304 
1305     /**
1306      * @dev Modifier to make a function callable only when the contract is paused.
1307      *
1308      * Requirements:
1309      *
1310      * - The contract must be paused.
1311      */
1312     modifier whenPaused() {
1313         require(paused(), "Pausable: not paused");
1314         _;
1315     }
1316 
1317     /**
1318      * @dev Triggers stopped state.
1319      *
1320      * Requirements:
1321      *
1322      * - The contract must not be paused.
1323      */
1324     function _pause() internal virtual whenNotPaused {
1325         _paused = true;
1326         emit Paused(_msgSender());
1327     }
1328 
1329     /**
1330      * @dev Returns to normal state.
1331      *
1332      * Requirements:
1333      *
1334      * - The contract must be paused.
1335      */
1336     function _unpause() internal virtual whenPaused {
1337         _paused = false;
1338         emit Unpaused(_msgSender());
1339     }
1340 }
1341 
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 contract RowdyRoos is ERC721Enumerable, Ownable {
1346     using Strings for uint256;
1347 
1348     uint256 public constant MAX_ROOS = 9999;
1349     uint256 public constant PRESALE_PRICE = 0.06 ether;
1350     uint256 public constant PRICE = 0.07 ether;
1351     uint256 public constant MAX_PER_MINT = 10;
1352     uint256 public constant PRESALE_MAX_MINT = 3;
1353     uint256 public constant MAX_ROOS_MINT = 100;
1354     uint256 public constant RESERVED_ROOS = 123;
1355 
1356     uint256 public reservedClaimed;
1357 
1358     uint256 public numRoosMinted;
1359 
1360     string public baseTokenURI;
1361 
1362     bool public publicSaleStarted;
1363     bool public presaleStarted;
1364 
1365     mapping(address => bool) private _presaleEligible;
1366     mapping(address => uint256) private _totalClaimed;
1367 
1368     event BaseURIChanged(string baseURI);
1369     event PresaleMint(address minter, uint256 amountOfRoos);
1370     event PublicSaleMint(address minter, uint256 amountOfRoos);
1371 
1372     modifier whenPresaleStarted() {
1373         require(presaleStarted, "Presale has not started");
1374         _;
1375     }
1376 
1377     modifier whenPublicSaleStarted() {
1378         require(publicSaleStarted, "Public sale has not started");
1379         _;
1380     }
1381 
1382     constructor(string memory baseURI) ERC721("Rowdy Roos", "RROO") {
1383         baseTokenURI = baseURI;
1384     }
1385 
1386     function claimReserved(address recipient, uint256 amount) external onlyOwner {
1387         require(reservedClaimed != RESERVED_ROOS, "Already have claimed all reserved roos");
1388         require(reservedClaimed + amount <= RESERVED_ROOS, "Minting would exceed max reserved roos");
1389         require(recipient != address(0), "Cannot add null address");
1390         require(totalSupply() < MAX_ROOS, "All tokens have been minted");
1391         require(totalSupply() + amount <= MAX_ROOS, "Minting would exceed max supply");
1392 
1393         uint256 _nextTokenId = numRoosMinted + 1;
1394 
1395         for (uint256 i = 0; i < amount; i++) {
1396             _safeMint(recipient, _nextTokenId + i);
1397         }
1398         numRoosMinted += amount;
1399         reservedClaimed += amount;
1400     }
1401 
1402     function addToPresale(address[] calldata addresses) external onlyOwner {
1403         for (uint256 i = 0; i < addresses.length; i++) {
1404             require(addresses[i] != address(0), "Cannot add null address");
1405 
1406             _presaleEligible[addresses[i]] = true;
1407 
1408             _totalClaimed[addresses[i]] > 0 ? _totalClaimed[addresses[i]] : 0;
1409         }
1410     }
1411 
1412     function checkPresaleEligibility(address addr) external view returns (bool) {
1413         return _presaleEligible[addr];
1414     }
1415 
1416     function amountClaimedBy(address owner) external view returns (uint256) {
1417         require(owner != address(0), "Cannot add null address");
1418 
1419         return _totalClaimed[owner];
1420     }
1421 
1422     function mintPresale(uint256 amountOfRoos) external payable whenPresaleStarted {
1423         require(_presaleEligible[msg.sender], "You are not eligible for the presale");
1424         require(totalSupply() < MAX_ROOS, "All tokens have been minted");
1425         require(amountOfRoos <= PRESALE_MAX_MINT, "Cannot purchase this many tokens during presale");
1426         require(totalSupply() + amountOfRoos <= MAX_ROOS, "Minting would exceed max supply");
1427         require(_totalClaimed[msg.sender] + amountOfRoos <= PRESALE_MAX_MINT, "Purchase exceeds max allowed");
1428         require(amountOfRoos > 0, "Must mint at least one roo");
1429         require(PRESALE_PRICE * amountOfRoos == msg.value, "ETH amount is incorrect");
1430 
1431         for (uint256 i = 0; i < amountOfRoos; i++) {
1432             uint256 tokenId = numRoosMinted + 1;
1433 
1434             numRoosMinted += 1;
1435             _totalClaimed[msg.sender] += 1;
1436             _safeMint(msg.sender, tokenId);
1437         }
1438 
1439         emit PresaleMint(msg.sender, amountOfRoos);
1440     }
1441 
1442     function mint(uint256 amountOfRoos) external payable whenPublicSaleStarted {
1443         require(totalSupply() < MAX_ROOS, "All tokens have been minted");
1444         require(amountOfRoos <= MAX_PER_MINT, "Cannot purchase this many tokens in a transaction");
1445         require(totalSupply() + amountOfRoos <= MAX_ROOS, "Minting would exceed max supply");
1446         require(_totalClaimed[msg.sender] + amountOfRoos <= MAX_ROOS_MINT, "Purchase exceeds max allowed per address");
1447         require(amountOfRoos > 0, "Must mint at least one roo");
1448         require(PRICE * amountOfRoos == msg.value, "ETH amount is incorrect");
1449 
1450         for (uint256 i = 0; i < amountOfRoos; i++) {
1451             uint256 tokenId = numRoosMinted + 1;
1452 
1453             numRoosMinted += 1;
1454             _totalClaimed[msg.sender] += 1;
1455             _safeMint(msg.sender, tokenId);
1456         }
1457 
1458         emit PublicSaleMint(msg.sender, amountOfRoos);
1459     }
1460 
1461     function togglePresaleStarted() external onlyOwner {
1462         presaleStarted = !presaleStarted;
1463     }
1464 
1465     function togglePublicSaleStarted() external onlyOwner {
1466         publicSaleStarted = !publicSaleStarted;
1467     }
1468 
1469     function _baseURI() internal view virtual override returns (string memory) {
1470         return baseTokenURI;
1471     }
1472 
1473     function setBaseURI(string memory baseURI) public onlyOwner {
1474         baseTokenURI = baseURI;
1475         emit BaseURIChanged(baseURI);
1476     }
1477 
1478     function withdrawAll() public onlyOwner {
1479         uint256 balance = address(this).balance;
1480         require(balance > 0, "Insufficent balance");
1481         
1482         address[7] memory addresses = [
1483             0x563e1da5a345E30d82d3fa0364fBb8B2fF98909A,
1484             0xfF9329A4801151500E6143082D62814fE06f68B4,
1485             0xfb60A7A524964A8a194e7c50D3fa450259D6dcC4,
1486             0x9E2Ae5480ca4933149E6E1D834b3a880c4fC90Db,
1487             0x280164C04F712d05038F999C4ae89b008531AB8e,
1488             0xeAe304949e57d913254c38d5f593e49C3f042092,
1489             0x894cCe3C3E0318e1B3E9809a89610DF2F24a23A4
1490         ];
1491 
1492         uint32[7] memory shares = [
1493             uint32(2216),
1494             uint32(1584),
1495             uint32(1584),
1496             uint32(1584),
1497             uint32(1584),
1498             uint32(950),
1499             uint32(498)
1500         ];
1501 
1502         for (uint32 i = 0; i < addresses.length; i++) {
1503             uint256 amount = i == addresses.length - 1 ? address(this).balance : balance * shares[i] / 10000;
1504             _widthdraw(addresses[i], amount);
1505         }
1506     }
1507 
1508     function _widthdraw(address _address, uint256 _amount) private {
1509         (bool success, ) = _address.call{ value: _amount }("");
1510         require(success, "Failed to withdraw Ether");
1511     }
1512 }