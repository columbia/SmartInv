1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity >=0.7.0 <0.9.0;
4 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35 
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45 
46     /**
47      * @dev Returns the number of tokens in ``owner``'s account.
48      */
49     function balanceOf(address owner) external view returns (uint256 balance);
50 
51     /**
52      * @dev Returns the owner of the `tokenId` token.
53      *
54      * Requirements:
55      *
56      * - `tokenId` must exist.
57      */
58     function ownerOf(uint256 tokenId) external view returns (address owner);
59 
60     /**
61      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
62      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
63      *
64      * Requirements:
65      *
66      * - `from` cannot be the zero address.
67      * - `to` cannot be the zero address.
68      * - `tokenId` token must exist and be owned by `from`.
69      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
70      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
71      *
72      * Emits a {Transfer} event.
73      */
74     function safeTransferFrom(
75         address from,
76         address to,
77         uint256 tokenId
78     ) external;
79 
80     /**
81      * @dev Transfers `tokenId` token from `from` to `to`.
82      *
83      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
84      *
85      * Requirements:
86      *
87      * - `from` cannot be the zero address.
88      * - `to` cannot be the zero address.
89      * - `tokenId` token must be owned by `from`.
90      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address from,
96         address to,
97         uint256 tokenId
98     ) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144      * @dev Safely transfers `tokenId` token from `from` to `to`.
145      *
146      * Requirements:
147      *
148      * - `from` cannot be the zero address.
149      * - `to` cannot be the zero address.
150      * - `tokenId` token must exist and be owned by `from`.
151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153      *
154      * Emits a {Transfer} event.
155      */
156     function safeTransferFrom(
157         address from,
158         address to,
159         uint256 tokenId,
160         bytes calldata data
161     ) external;
162 }
163 
164 
165 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
166 /**
167  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
168  * @dev See https://eips.ethereum.org/EIPS/eip-721
169  */
170 interface IERC721Enumerable is IERC721 {
171     /**
172      * @dev Returns the total amount of tokens stored by the contract.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
178      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
179      */
180     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
181 
182     /**
183      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
184      * Use along with {totalSupply} to enumerate all tokens.
185      */
186     function tokenByIndex(uint256 index) external view returns (uint256);
187 }
188 
189 
190 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
191 /**
192  * @dev Implementation of the {IERC165} interface.
193  *
194  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
195  * for the additional interface id that will be supported. For example:
196  *
197  * ```solidity
198  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
199  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
200  * }
201  * ```
202  *
203  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
204  */
205 abstract contract ERC165 is IERC165 {
206     /**
207      * @dev See {IERC165-supportsInterface}.
208      */
209     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
210         return interfaceId == type(IERC165).interfaceId;
211     }
212 }
213 
214 // File: @openzeppelin/contracts/utils/Strings.sol
215 
216 /**
217  * @dev String operations.
218  */
219 library Strings {
220     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
221 
222     /**
223      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
224      */
225     function toString(uint256 value) internal pure returns (string memory) {
226         // Inspired by OraclizeAPI's implementation - MIT licence
227         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
228 
229         if (value == 0) {
230             return "0";
231         }
232         uint256 temp = value;
233         uint256 digits;
234         while (temp != 0) {
235             digits++;
236             temp /= 10;
237         }
238         bytes memory buffer = new bytes(digits);
239         while (value != 0) {
240             digits -= 1;
241             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
242             value /= 10;
243         }
244         return string(buffer);
245     }
246 
247     /**
248      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
249      */
250     function toHexString(uint256 value) internal pure returns (string memory) {
251         if (value == 0) {
252             return "0x00";
253         }
254         uint256 temp = value;
255         uint256 length = 0;
256         while (temp != 0) {
257             length++;
258             temp >>= 8;
259         }
260         return toHexString(value, length);
261     }
262 
263     /**
264      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
265      */
266     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
267         bytes memory buffer = new bytes(2 * length + 2);
268         buffer[0] = "0";
269         buffer[1] = "x";
270         for (uint256 i = 2 * length + 1; i > 1; --i) {
271             buffer[i] = _HEX_SYMBOLS[value & 0xf];
272             value >>= 4;
273         }
274         require(value == 0, "Strings: hex length insufficient");
275         return string(buffer);
276     }
277 }
278 
279 // File: @openzeppelin/contracts/utils/Address.sol
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies on extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         uint256 size;
308         assembly {
309             size := extcodesize(account)
310         }
311         return size > 0;
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         (bool success, ) = recipient.call{value: amount}("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain `call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value
388     ) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         require(isContract(target), "Address: call to non-contract");
406 
407         (bool success, bytes memory returndata) = target.call{value: value}(data);
408         return verifyCallResult(success, returndata, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
418         return functionStaticCall(target, data, "Address: low-level static call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(
428         address target,
429         bytes memory data,
430         string memory errorMessage
431     ) internal view returns (bytes memory) {
432         require(isContract(target), "Address: static call to non-contract");
433 
434         (bool success, bytes memory returndata) = target.staticcall(data);
435         return verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a delegate call.
441      *
442      * _Available since v3.4._
443      */
444     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
445         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(
455         address target,
456         bytes memory data,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(isContract(target), "Address: delegate call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
467      * revert reason using the provided one.
468      *
469      * _Available since v4.3._
470      */
471     function verifyCallResult(
472         bool success,
473         bytes memory returndata,
474         string memory errorMessage
475     ) internal pure returns (bytes memory) {
476         if (success) {
477             return returndata;
478         } else {
479             // Look for revert reason and bubble it up if present
480             if (returndata.length > 0) {
481                 // The easiest way to bubble the revert reason is using memory via assembly
482 
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
495 
496 /**
497  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
498  * @dev See https://eips.ethereum.org/EIPS/eip-721
499  */
500 interface IERC721Metadata is IERC721 {
501     /**
502      * @dev Returns the token collection name.
503      */
504     function name() external view returns (string memory);
505 
506     /**
507      * @dev Returns the token collection symbol.
508      */
509     function symbol() external view returns (string memory);
510 
511     /**
512      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
513      */
514     function tokenURI(uint256 tokenId) external view returns (string memory);
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
518 
519 /**
520  * @title ERC721 token receiver interface
521  * @dev Interface for any contract that wants to support safeTransfers
522  * from ERC721 asset contracts.
523  */
524 interface IERC721Receiver {
525     /**
526      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
527      * by `operator` from `from`, this function is called.
528      *
529      * It must return its Solidity selector to confirm the token transfer.
530      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
531      *
532      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
533      */
534     function onERC721Received(
535         address operator,
536         address from,
537         uint256 tokenId,
538         bytes calldata data
539     ) external returns (bytes4);
540 }
541 
542 // File: @openzeppelin/contracts/utils/Context.sol
543 /**
544  * @dev Provides information about the current execution context, including the
545  * sender of the transaction and its data. While these are generally available
546  * via msg.sender and msg.data, they should not be accessed in such a direct
547  * manner, since when dealing with meta-transactions the account sending and
548  * paying for execution may not be the actual sender (as far as an application
549  * is concerned).
550  *
551  * This contract is only required for intermediate, library-like contracts.
552  */
553 abstract contract Context {
554     function _msgSender() internal view virtual returns (address) {
555         return msg.sender;
556     }
557 
558     function _msgData() internal view virtual returns (bytes calldata) {
559         return msg.data;
560     }
561 }
562 
563 
564 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
565 /**
566  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
567  * the Metadata extension, but not including the Enumerable extension, which is available separately as
568  * {ERC721Enumerable}.
569  */
570 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
571     using Address for address;
572     using Strings for uint256;
573 
574     // Token name
575     string private _name;
576 
577     // Token symbol
578     string private _symbol;
579 
580     // Mapping from token ID to owner address
581     mapping(uint256 => address) private _owners;
582 
583     // Mapping owner address to token count
584     mapping(address => uint256) private _balances;
585 
586     // Mapping from token ID to approved address
587     mapping(uint256 => address) private _tokenApprovals;
588 
589     // Mapping from owner to operator approvals
590     mapping(address => mapping(address => bool)) private _operatorApprovals;
591 
592     /**
593      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
594      */
595     constructor(string memory name_, string memory symbol_) {
596         _name = name_;
597         _symbol = symbol_;
598     }
599 
600     /**
601      * @dev See {IERC165-supportsInterface}.
602      */
603     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
604         return
605             interfaceId == type(IERC721).interfaceId ||
606             interfaceId == type(IERC721Metadata).interfaceId ||
607             super.supportsInterface(interfaceId);
608     }
609 
610     /**
611      * @dev See {IERC721-balanceOf}.
612      */
613     function balanceOf(address owner) public view virtual override returns (uint256) {
614         require(owner != address(0), "ERC721: balance query for the zero address");
615         return _balances[owner];
616     }
617 
618     /**
619      * @dev See {IERC721-ownerOf}.
620      */
621     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
622         address owner = _owners[tokenId];
623         require(owner != address(0), "ERC721: owner query for nonexistent token");
624         return owner;
625     }
626 
627     /**
628      * @dev See {IERC721Metadata-name}.
629      */
630     function name() public view virtual override returns (string memory) {
631         return _name;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-symbol}.
636      */
637     function symbol() public view virtual override returns (string memory) {
638         return _symbol;
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-tokenURI}.
643      */
644     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
645         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
646 
647         string memory baseURI = _baseURI();
648         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
649     }
650 
651     /**
652      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
653      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
654      * by default, can be overriden in child contracts.
655      */
656     function _baseURI() internal view virtual returns (string memory) {
657         return "";
658     }
659 
660     /**
661      * @dev See {IERC721-approve}.
662      */
663     function approve(address to, uint256 tokenId) public virtual override {
664         address owner = ERC721.ownerOf(tokenId);
665         require(to != owner, "ERC721: approval to current owner");
666 
667         require(
668             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
669             "ERC721: approve caller is not owner nor approved for all"
670         );
671 
672         _approve(to, tokenId);
673     }
674 
675     /**
676      * @dev See {IERC721-getApproved}.
677      */
678     function getApproved(uint256 tokenId) public view virtual override returns (address) {
679         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
680 
681         return _tokenApprovals[tokenId];
682     }
683 
684     /**
685      * @dev See {IERC721-setApprovalForAll}.
686      */
687     function setApprovalForAll(address operator, bool approved) public virtual override {
688         require(operator != _msgSender(), "ERC721: approve to caller");
689 
690         _operatorApprovals[_msgSender()][operator] = approved;
691         emit ApprovalForAll(_msgSender(), operator, approved);
692     }
693 
694     /**
695      * @dev See {IERC721-isApprovedForAll}.
696      */
697     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
698         return _operatorApprovals[owner][operator];
699     }
700 
701     /**
702      * @dev See {IERC721-transferFrom}.
703      */
704     function transferFrom(
705         address from,
706         address to,
707         uint256 tokenId
708     ) public virtual override {
709         //solhint-disable-next-line max-line-length
710         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
711 
712         _transfer(from, to, tokenId);
713     }
714 
715     /**
716      * @dev See {IERC721-safeTransferFrom}.
717      */
718     function safeTransferFrom(
719         address from,
720         address to,
721         uint256 tokenId
722     ) public virtual override {
723         safeTransferFrom(from, to, tokenId, "");
724     }
725 
726     /**
727      * @dev See {IERC721-safeTransferFrom}.
728      */
729     function safeTransferFrom(
730         address from,
731         address to,
732         uint256 tokenId,
733         bytes memory _data
734     ) public virtual override {
735         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
736         _safeTransfer(from, to, tokenId, _data);
737     }
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
741      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
742      *
743      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
744      *
745      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
746      * implement alternative mechanisms to perform token transfer, such as signature-based.
747      *
748      * Requirements:
749      *
750      * - `from` cannot be the zero address.
751      * - `to` cannot be the zero address.
752      * - `tokenId` token must exist and be owned by `from`.
753      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
754      *
755      * Emits a {Transfer} event.
756      */
757     function _safeTransfer(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) internal virtual {
763         _transfer(from, to, tokenId);
764         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
765     }
766 
767     /**
768      * @dev Returns whether `tokenId` exists.
769      *
770      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
771      *
772      * Tokens start existing when they are minted (`_mint`),
773      * and stop existing when they are burned (`_burn`).
774      */
775     function _exists(uint256 tokenId) internal view virtual returns (bool) {
776         return _owners[tokenId] != address(0);
777     }
778 
779     /**
780      * @dev Returns whether `spender` is allowed to manage `tokenId`.
781      *
782      * Requirements:
783      *
784      * - `tokenId` must exist.
785      */
786     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
787         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
788         address owner = ERC721.ownerOf(tokenId);
789         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
790     }
791 
792     /**
793      * @dev Safely mints `tokenId` and transfers it to `to`.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must not exist.
798      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
799      *
800      * Emits a {Transfer} event.
801      */
802     function _safeMint(address to, uint256 tokenId) internal virtual {
803         _safeMint(to, tokenId, "");
804     }
805 
806     /**
807      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
808      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
809      */
810     function _safeMint(
811         address to,
812         uint256 tokenId,
813         bytes memory _data
814     ) internal virtual {
815         _mint(to, tokenId);
816         require(
817             _checkOnERC721Received(address(0), to, tokenId, _data),
818             "ERC721: transfer to non ERC721Receiver implementer"
819         );
820     }
821 
822     /**
823      * @dev Mints `tokenId` and transfers it to `to`.
824      *
825      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
826      *
827      * Requirements:
828      *
829      * - `tokenId` must not exist.
830      * - `to` cannot be the zero address.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _mint(address to, uint256 tokenId) internal virtual {
835         require(to != address(0), "ERC721: mint to the zero address");
836         require(!_exists(tokenId), "ERC721: token already minted");
837 
838         _beforeTokenTransfer(address(0), to, tokenId);
839 
840         _balances[to] += 1;
841         _owners[tokenId] = to;
842 
843         emit Transfer(address(0), to, tokenId);
844     }
845 
846     /**
847      * @dev Destroys `tokenId`.
848      * The approval is cleared when the token is burned.
849      *
850      * Requirements:
851      *
852      * - `tokenId` must exist.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _burn(uint256 tokenId) internal virtual {
857         address owner = ERC721.ownerOf(tokenId);
858 
859         _beforeTokenTransfer(owner, address(0), tokenId);
860 
861         // Clear approvals
862         _approve(address(0), tokenId);
863 
864         _balances[owner] -= 1;
865         delete _owners[tokenId];
866 
867         emit Transfer(owner, address(0), tokenId);
868     }
869 
870     /**
871      * @dev Transfers `tokenId` from `from` to `to`.
872      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
873      *
874      * Requirements:
875      *
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must be owned by `from`.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _transfer(
882         address from,
883         address to,
884         uint256 tokenId
885     ) internal virtual {
886         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
887         require(to != address(0), "ERC721: transfer to the zero address");
888 
889         _beforeTokenTransfer(from, to, tokenId);
890 
891         // Clear approvals from the previous owner
892         _approve(address(0), tokenId);
893 
894         _balances[from] -= 1;
895         _balances[to] += 1;
896         _owners[tokenId] = to;
897 
898         emit Transfer(from, to, tokenId);
899     }
900 
901     /**
902      * @dev Approve `to` to operate on `tokenId`
903      *
904      * Emits a {Approval} event.
905      */
906     function _approve(address to, uint256 tokenId) internal virtual {
907         _tokenApprovals[tokenId] = to;
908         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
909     }
910 
911     /**
912      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
913      * The call is not executed if the target address is not a contract.
914      *
915      * @param from address representing the previous owner of the given token ID
916      * @param to target address that will receive the tokens
917      * @param tokenId uint256 ID of the token to be transferred
918      * @param _data bytes optional data to send along with the call
919      * @return bool whether the call correctly returned the expected magic value
920      */
921     function _checkOnERC721Received(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) private returns (bool) {
927         if (to.isContract()) {
928             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
929                 return retval == IERC721Receiver.onERC721Received.selector;
930             } catch (bytes memory reason) {
931                 if (reason.length == 0) {
932                     revert("ERC721: transfer to non ERC721Receiver implementer");
933                 } else {
934                     assembly {
935                         revert(add(32, reason), mload(reason))
936                     }
937                 }
938             }
939         } else {
940             return true;
941         }
942     }
943 
944     /**
945      * @dev Hook that is called before any token transfer. This includes minting
946      * and burning.
947      *
948      * Calling conditions:
949      *
950      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
951      * transferred to `to`.
952      * - When `from` is zero, `tokenId` will be minted for `to`.
953      * - When `to` is zero, ``from``'s `tokenId` will be burned.
954      * - `from` and `to` are never both zero.
955      *
956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
957      */
958     function _beforeTokenTransfer(
959         address from,
960         address to,
961         uint256 tokenId
962     ) internal virtual {}
963 }
964 
965 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
966 
967 /**
968  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
969  * enumerability of all the token ids in the contract as well as all token ids owned by each
970  * account.
971  */
972 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
973     // Mapping from owner to list of owned token IDs
974     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
975 
976     // Mapping from token ID to index of the owner tokens list
977     mapping(uint256 => uint256) private _ownedTokensIndex;
978 
979     // Array with all token ids, used for enumeration
980     uint256[] private _allTokens;
981 
982     // Mapping from token id to position in the allTokens array
983     mapping(uint256 => uint256) private _allTokensIndex;
984 
985     /**
986      * @dev See {IERC165-supportsInterface}.
987      */
988     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
989         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
990     }
991 
992     /**
993      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
994      */
995     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
996         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
997         return _ownedTokens[owner][index];
998     }
999 
1000     /**
1001      * @dev See {IERC721Enumerable-totalSupply}.
1002      */
1003     function totalSupply() public view virtual override returns (uint256) {
1004         return _allTokens.length;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Enumerable-tokenByIndex}.
1009      */
1010     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1011         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1012         return _allTokens[index];
1013     }
1014 
1015     /**
1016      * @dev Hook that is called before any token transfer. This includes minting
1017      * and burning.
1018      *
1019      * Calling conditions:
1020      *
1021      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1022      * transferred to `to`.
1023      * - When `from` is zero, `tokenId` will be minted for `to`.
1024      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      *
1028      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1029      */
1030     function _beforeTokenTransfer(
1031         address from,
1032         address to,
1033         uint256 tokenId
1034     ) internal virtual override {
1035         super._beforeTokenTransfer(from, to, tokenId);
1036 
1037         if (from == address(0)) {
1038             _addTokenToAllTokensEnumeration(tokenId);
1039         } else if (from != to) {
1040             _removeTokenFromOwnerEnumeration(from, tokenId);
1041         }
1042         if (to == address(0)) {
1043             _removeTokenFromAllTokensEnumeration(tokenId);
1044         } else if (to != from) {
1045             _addTokenToOwnerEnumeration(to, tokenId);
1046         }
1047     }
1048 
1049     /**
1050      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1051      * @param to address representing the new owner of the given token ID
1052      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1053      */
1054     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1055         uint256 length = ERC721.balanceOf(to);
1056         _ownedTokens[to][length] = tokenId;
1057         _ownedTokensIndex[tokenId] = length;
1058     }
1059 
1060     /**
1061      * @dev Private function to add a token to this extension's token tracking data structures.
1062      * @param tokenId uint256 ID of the token to be added to the tokens list
1063      */
1064     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1065         _allTokensIndex[tokenId] = _allTokens.length;
1066         _allTokens.push(tokenId);
1067     }
1068 
1069     /**
1070      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1071      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1072      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1073      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1074      * @param from address representing the previous owner of the given token ID
1075      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1076      */
1077     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1078         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1079         // then delete the last slot (swap and pop).
1080 
1081         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1082         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1083 
1084         // When the token to delete is the last token, the swap operation is unnecessary
1085         if (tokenIndex != lastTokenIndex) {
1086             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1087 
1088             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1089             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1090         }
1091 
1092         // This also deletes the contents at the last position of the array
1093         delete _ownedTokensIndex[tokenId];
1094         delete _ownedTokens[from][lastTokenIndex];
1095     }
1096 
1097     /**
1098      * @dev Private function to remove a token from this extension's token tracking data structures.
1099      * This has O(1) time complexity, but alters the order of the _allTokens array.
1100      * @param tokenId uint256 ID of the token to be removed from the tokens list
1101      */
1102     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1103         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1104         // then delete the last slot (swap and pop).
1105 
1106         uint256 lastTokenIndex = _allTokens.length - 1;
1107         uint256 tokenIndex = _allTokensIndex[tokenId];
1108 
1109         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1110         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1111         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1112         uint256 lastTokenId = _allTokens[lastTokenIndex];
1113 
1114         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1115         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1116 
1117         // This also deletes the contents at the last position of the array
1118         delete _allTokensIndex[tokenId];
1119         _allTokens.pop();
1120     }
1121 }
1122 
1123 
1124 // File: @openzeppelin/contracts/access/Ownable.sol
1125 /**
1126  * @dev Contract module which provides a basic access control mechanism, where
1127  * there is an account (an owner) that can be granted exclusive access to
1128  * specific functions.
1129  *
1130  * By default, the owner account will be the one that deploys the contract. This
1131  * can later be changed with {transferOwnership}.
1132  *
1133  * This module is used through inheritance. It will make available the modifier
1134  * `onlyOwner`, which can be applied to your functions to restrict their use to
1135  * the owner.
1136  */
1137 abstract contract Ownable is Context {
1138     address private _owner;
1139 
1140     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1141 
1142     /**
1143      * @dev Initializes the contract setting the deployer as the initial owner.
1144      */
1145     constructor() {
1146         _setOwner(_msgSender());
1147     }
1148 
1149     /**
1150      * @dev Returns the address of the current owner.
1151      */
1152     function owner() public view virtual returns (address) {
1153         return _owner;
1154     }
1155 
1156     /**
1157      * @dev Throws if called by any account other than the owner.
1158      */
1159     modifier onlyOwner() {
1160         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1161         _;
1162     }
1163 
1164     /**
1165      * @dev Leaves the contract without owner. It will not be possible to call
1166      * `onlyOwner` functions anymore. Can only be called by the current owner.
1167      *
1168      * NOTE: Renouncing ownership will leave the contract without an owner,
1169      * thereby removing any functionality that is only available to the owner.
1170      */
1171     function renounceOwnership() public virtual onlyOwner {
1172         _setOwner(address(0));
1173     }
1174 
1175     /**
1176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1177      * Can only be called by the current owner.
1178      */
1179     function transferOwnership(address newOwner) public virtual onlyOwner {
1180         require(newOwner != address(0), "Ownable: new owner is the zero address");
1181         _setOwner(newOwner);
1182     }
1183 
1184     function _setOwner(address newOwner) private {
1185         address oldOwner = _owner;
1186         _owner = newOwner;
1187         emit OwnershipTransferred(oldOwner, newOwner);
1188     }
1189 }
1190 
1191 contract Voyage is ERC721Enumerable, Ownable {
1192   using Strings for uint256;
1193 
1194   string public baseURI;
1195   string public baseExtension = ".json";
1196   string public notRevealedUri;
1197   uint256 public cost = 0.07 ether;
1198   uint256 public maxSupply = 3300;
1199   uint256 public maxMintAmount = 10;
1200   bool public paused = true;
1201   bool public revealed = false;
1202   mapping(address => uint256) public addressMintedBalance;
1203 
1204   constructor() ERC721("Atlantic Voyage Ape Club", "AVAC") {
1205     
1206     setNotRevealedURI("ipfs://QmQGoNj55uTDvjqsQezYzuBHQPwQXHPGEnMvE5DjQ5V2f6/hidden.json");
1207   }
1208 
1209   // internal
1210   function _baseURI() internal view virtual override returns (string memory) {
1211     return baseURI;
1212   }
1213 
1214   // public
1215   function mint(uint256 _mintAmount) public payable {
1216     require(!paused, "the contract is paused");
1217     uint256 supply = totalSupply();
1218     require(_mintAmount > 0, "need to mint at least 1 NFT");
1219     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1220     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1221     if (msg.sender != owner()) {
1222         require(msg.value >= cost * _mintAmount, "insufficient funds");
1223     }
1224 
1225     for (uint256 i = 1; i <= _mintAmount; i++) {
1226       addressMintedBalance[msg.sender]++;
1227       _safeMint(msg.sender, supply + i);
1228     }
1229   }
1230 
1231   function walletOfOwner(address _owner)
1232     public
1233     view
1234     returns (uint256[] memory)
1235   {
1236     uint256 ownerTokenCount = balanceOf(_owner);
1237     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1238     for (uint256 i; i < ownerTokenCount; i++) {
1239       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1240     }
1241     return tokenIds;
1242   }
1243 
1244   function tokenURI(uint256 tokenId)
1245     public
1246     view
1247     virtual
1248     override
1249     returns (string memory)
1250   {
1251     require(
1252       _exists(tokenId),
1253       "ERC721Metadata: URI query for nonexistent token"
1254     );
1255     
1256     if(revealed == false) {
1257         return notRevealedUri;
1258     }
1259 
1260     string memory currentBaseURI = _baseURI();
1261     return bytes(currentBaseURI).length > 0
1262         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1263         : "";
1264   }
1265 
1266   //only owner
1267   function reveal() public onlyOwner {
1268       revealed = true;
1269   }
1270   
1271   function setCost(uint256 _newCost) public onlyOwner {
1272     cost = _newCost;
1273   }
1274 
1275   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1276     maxMintAmount = _newmaxMintAmount;
1277   }
1278 
1279   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1280     baseURI = _newBaseURI;
1281   }
1282 
1283   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1284     baseExtension = _newBaseExtension;
1285   }
1286   
1287   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1288     notRevealedUri = _notRevealedURI;
1289   }
1290 
1291   function pause(bool _state) public onlyOwner {
1292     paused = _state;
1293   }
1294  
1295   function withdraw() public payable onlyOwner {
1296     // This will payout the owner the contract balance.
1297     // Do not remove this otherwise you will not be able to withdraw the funds.
1298     // =============================================================================
1299     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1300     require(os);
1301     // =============================================================================
1302   }
1303 }