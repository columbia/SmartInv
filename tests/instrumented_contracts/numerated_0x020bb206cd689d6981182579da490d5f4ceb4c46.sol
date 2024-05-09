1 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
2 
3 pragma solidity ^0.8.0;
4 
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
26 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Required interface of an ERC721 compliant contract.
32  */
33 interface IERC721 is IERC165 {
34     /**
35      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
36      */
37     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
38 
39     /**
40      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
41      */
42     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
46      */
47     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
48 
49     /**
50      * @dev Returns the number of tokens in ``owner``'s account.
51      */
52     function balanceOf(address owner) external view returns (uint256 balance);
53 
54     /**
55      * @dev Returns the owner of the `tokenId` token.
56      *
57      * Requirements:
58      *
59      * - `tokenId` must exist.
60      */
61     function ownerOf(uint256 tokenId) external view returns (address owner);
62 
63     /**
64      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
65      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
66      *
67      * Requirements:
68      *
69      * - `from` cannot be the zero address.
70      * - `to` cannot be the zero address.
71      * - `tokenId` token must exist and be owned by `from`.
72      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
73      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
74      *
75      * Emits a {Transfer} event.
76      */
77     function safeTransferFrom(
78         address from,
79         address to,
80         uint256 tokenId
81     ) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address from,
99         address to,
100         uint256 tokenId
101     ) external;
102 
103     /**
104      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
105      * The approval is cleared when the token is transferred.
106      *
107      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
108      *
109      * Requirements:
110      *
111      * - The caller must own the token or be an approved operator.
112      * - `tokenId` must exist.
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address to, uint256 tokenId) external;
117 
118     /**
119      * @dev Returns the account approved for `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function getApproved(uint256 tokenId) external view returns (address operator);
126 
127     /**
128      * @dev Approve or remove `operator` as an operator for the caller.
129      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
130      *
131      * Requirements:
132      *
133      * - The `operator` cannot be the caller.
134      *
135      * Emits an {ApprovalForAll} event.
136      */
137     function setApprovalForAll(address operator, bool _approved) external;
138 
139     /**
140      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
141      *
142      * See {setApprovalForAll}
143      */
144     function isApprovedForAll(address owner, address operator) external view returns (bool);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`.
148      *
149      * Requirements:
150      *
151      * - `from` cannot be the zero address.
152      * - `to` cannot be the zero address.
153      * - `tokenId` token must exist and be owned by `from`.
154      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
156      *
157      * Emits a {Transfer} event.
158      */
159     function safeTransferFrom(
160         address from,
161         address to,
162         uint256 tokenId,
163         bytes calldata data
164     ) external;
165 }
166 
167 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @title ERC721 token receiver interface
173  * @dev Interface for any contract that wants to support safeTransfers
174  * from ERC721 asset contracts.
175  */
176 interface IERC721Receiver {
177     /**
178      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
179      * by `operator` from `from`, this function is called.
180      *
181      * It must return its Solidity selector to confirm the token transfer.
182      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
183      *
184      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
185      */
186     function onERC721Received(
187         address operator,
188         address from,
189         uint256 tokenId,
190         bytes calldata data
191     ) external returns (bytes4);
192 }
193 
194 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Metadata.sol
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 // File: openzeppelin-solidity/contracts/utils/Address.sol
220 
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev Collection of functions related to the address type
225  */
226 library Address {
227     /**
228      * @dev Returns true if `account` is a contract.
229      *
230      * [IMPORTANT]
231      * ====
232      * It is unsafe to assume that an address for which this function returns
233      * false is an externally-owned account (EOA) and not a contract.
234      *
235      * Among others, `isContract` will return false for the following
236      * types of addresses:
237      *
238      *  - an externally-owned account
239      *  - a contract in construction
240      *  - an address where a contract will be created
241      *  - an address where a contract lived, but was destroyed
242      * ====
243      */
244     function isContract(address account) internal view returns (bool) {
245         // This method relies on extcodesize, which returns 0 for contracts in
246         // construction, since the code is only stored at the end of the
247         // constructor execution.
248 
249         uint256 size;
250         assembly {
251             size := extcodesize(account)
252         }
253         return size > 0;
254     }
255 
256     /**
257      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
258      * `recipient`, forwarding all available gas and reverting on errors.
259      *
260      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
261      * of certain opcodes, possibly making contracts go over the 2300 gas limit
262      * imposed by `transfer`, making them unable to receive funds via
263      * `transfer`. {sendValue} removes this limitation.
264      *
265      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
266      *
267      * IMPORTANT: because control is transferred to `recipient`, care must be
268      * taken to not create reentrancy vulnerabilities. Consider using
269      * {ReentrancyGuard} or the
270      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
271      */
272     function sendValue(address payable recipient, uint256 amount) internal {
273         require(address(this).balance >= amount, "Address: insufficient balance");
274 
275         (bool success, ) = recipient.call{value: amount}("");
276         require(success, "Address: unable to send value, recipient may have reverted");
277     }
278 
279     /**
280      * @dev Performs a Solidity function call using a low level `call`. A
281      * plain `call` is an unsafe replacement for a function call: use this
282      * function instead.
283      *
284      * If `target` reverts with a revert reason, it is bubbled up by this
285      * function (like regular Solidity function calls).
286      *
287      * Returns the raw returned data. To convert to the expected return value,
288      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
289      *
290      * Requirements:
291      *
292      * - `target` must be a contract.
293      * - calling `target` with `data` must not revert.
294      *
295      * _Available since v3.1._
296      */
297     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionCall(target, data, "Address: low-level call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
303      * `errorMessage` as a fallback revert reason when `target` reverts.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(
327         address target,
328         bytes memory data,
329         uint256 value
330     ) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336      * with `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(
341         address target,
342         bytes memory data,
343         uint256 value,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         require(isContract(target), "Address: call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.call{value: value}(data);
350         return _verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a static call.
356      *
357      * _Available since v3.3._
358      */
359     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
360         return functionStaticCall(target, data, "Address: low-level static call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a static call.
366      *
367      * _Available since v3.3._
368      */
369     function functionStaticCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal view returns (bytes memory) {
374         require(isContract(target), "Address: static call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.staticcall(data);
377         return _verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a delegate call.
383      *
384      * _Available since v3.4._
385      */
386     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a delegate call.
393      *
394      * _Available since v3.4._
395      */
396     function functionDelegateCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         require(isContract(target), "Address: delegate call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.delegatecall(data);
404         return _verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     function _verifyCallResult(
408         bool success,
409         bytes memory returndata,
410         string memory errorMessage
411     ) private pure returns (bytes memory) {
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 // File: openzeppelin-solidity/contracts/utils/Context.sol
431 
432 pragma solidity ^0.8.0;
433 
434 /*
435  * @dev Provides information about the current execution context, including the
436  * sender of the transaction and its data. While these are generally available
437  * via msg.sender and msg.data, they should not be accessed in such a direct
438  * manner, since when dealing with meta-transactions the account sending and
439  * paying for execution may not be the actual sender (as far as an application
440  * is concerned).
441  *
442  * This contract is only required for intermediate, library-like contracts.
443  */
444 abstract contract Context {
445     function _msgSender() internal view virtual returns (address) {
446         return msg.sender;
447     }
448 
449     function _msgData() internal view virtual returns (bytes calldata) {
450         return msg.data;
451     }
452 }
453 
454 // File: openzeppelin-solidity/contracts/utils/Strings.sol
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev String operations.
460  */
461 library Strings {
462     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
466      */
467     function toString(uint256 value) internal pure returns (string memory) {
468         if (value == 0) {
469             return "0";
470         }
471         uint256 temp = value;
472         uint256 digits;
473         while (temp != 0) {
474             digits++;
475             temp /= 10;
476         }
477         bytes memory buffer = new bytes(digits);
478         while (value != 0) {
479             digits -= 1;
480             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
481             value /= 10;
482         }
483         return string(buffer);
484     }
485 
486     /**
487      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
488      */
489     function toHexString(uint256 value) internal pure returns (string memory) {
490         if (value == 0) {
491             return "0x00";
492         }
493         uint256 temp = value;
494         uint256 length = 0;
495         while (temp != 0) {
496             length++;
497             temp >>= 8;
498         }
499         return toHexString(value, length);
500     }
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
504      */
505     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
506         bytes memory buffer = new bytes(2 * length + 2);
507         buffer[0] = "0";
508         buffer[1] = "x";
509         for (uint256 i = 2 * length + 1; i > 1; --i) {
510             buffer[i] = _HEX_SYMBOLS[value & 0xf];
511             value >>= 4;
512         }
513         require(value == 0, "Strings: hex length insufficient");
514         return string(buffer);
515     }
516 }
517 
518 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Implementation of the {IERC165} interface.
524  *
525  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
526  * for the additional interface id that will be supported. For example:
527  *
528  * ```solidity
529  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
530  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
531  * }
532  * ```
533  *
534  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
535  */
536 abstract contract ERC165 is IERC165 {
537     /**
538      * @dev See {IERC165-supportsInterface}.
539      */
540     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
541         return interfaceId == type(IERC165).interfaceId;
542     }
543 }
544 
545 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
546 
547 pragma solidity ^0.8.0;
548 
549 /**
550  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
551  * the Metadata extension, but not including the Enumerable extension, which is available separately as
552  * {ERC721Enumerable}.
553  */
554 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
555     using Address for address;
556     using Strings for uint256;
557 
558     // Token name
559     string private _name;
560 
561     // Token symbol
562     string private _symbol;
563 
564     // Mapping from token ID to owner address
565     mapping(uint256 => address) private _owners;
566 
567     // Mapping owner address to token count
568     mapping(address => uint256) private _balances;
569 
570     // Mapping from token ID to approved address
571     mapping(uint256 => address) private _tokenApprovals;
572 
573     // Mapping from owner to operator approvals
574     mapping(address => mapping(address => bool)) private _operatorApprovals;
575 
576     /**
577      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
578      */
579     constructor(string memory name_, string memory symbol_) {
580         _name = name_;
581         _symbol = symbol_;
582     }
583 
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
588         return
589             interfaceId == type(IERC721).interfaceId ||
590             interfaceId == type(IERC721Metadata).interfaceId ||
591             super.supportsInterface(interfaceId);
592     }
593 
594     /**
595      * @dev See {IERC721-balanceOf}.
596      */
597     function balanceOf(address owner) public view virtual override returns (uint256) {
598         require(owner != address(0), "ERC721: balance query for the zero address");
599         return _balances[owner];
600     }
601 
602     /**
603      * @dev See {IERC721-ownerOf}.
604      */
605     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
606         address owner = _owners[tokenId];
607         require(owner != address(0), "ERC721: owner query for nonexistent token");
608         return owner;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-name}.
613      */
614     function name() public view virtual override returns (string memory) {
615         return _name;
616     }
617 
618     /**
619      * @dev See {IERC721Metadata-symbol}.
620      */
621     function symbol() public view virtual override returns (string memory) {
622         return _symbol;
623     }
624 
625     /**
626      * @dev See {IERC721Metadata-tokenURI}.
627      */
628     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
629         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
630 
631         string memory baseURI = _baseURI();
632         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
633     }
634 
635     /**
636      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
637      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
638      * by default, can be overriden in child contracts.
639      */
640     function _baseURI() internal view virtual returns (string memory) {
641         return "";
642     }
643 
644     /**
645      * @dev See {IERC721-approve}.
646      */
647     function approve(address to, uint256 tokenId) public virtual override {
648         address owner = ERC721.ownerOf(tokenId);
649         require(to != owner, "ERC721: approval to current owner");
650 
651         require(
652             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
653             "ERC721: approve caller is not owner nor approved for all"
654         );
655 
656         _approve(to, tokenId);
657     }
658 
659     /**
660      * @dev See {IERC721-getApproved}.
661      */
662     function getApproved(uint256 tokenId) public view virtual override returns (address) {
663         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
664 
665         return _tokenApprovals[tokenId];
666     }
667 
668     /**
669      * @dev See {IERC721-setApprovalForAll}.
670      */
671     function setApprovalForAll(address operator, bool approved) public virtual override {
672         require(operator != _msgSender(), "ERC721: approve to caller");
673 
674         _operatorApprovals[_msgSender()][operator] = approved;
675         emit ApprovalForAll(_msgSender(), operator, approved);
676     }
677 
678     /**
679      * @dev See {IERC721-isApprovedForAll}.
680      */
681     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
682         return _operatorApprovals[owner][operator];
683     }
684 
685     /**
686      * @dev See {IERC721-transferFrom}.
687      */
688     function transferFrom(
689         address from,
690         address to,
691         uint256 tokenId
692     ) public virtual override {
693         //solhint-disable-next-line max-line-length
694         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
695 
696         _transfer(from, to, tokenId);
697     }
698 
699     /**
700      * @dev See {IERC721-safeTransferFrom}.
701      */
702     function safeTransferFrom(
703         address from,
704         address to,
705         uint256 tokenId
706     ) public virtual override {
707         safeTransferFrom(from, to, tokenId, "");
708     }
709 
710     /**
711      * @dev See {IERC721-safeTransferFrom}.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 tokenId,
717         bytes memory _data
718     ) public virtual override {
719         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
720         _safeTransfer(from, to, tokenId, _data);
721     }
722 
723     /**
724      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
725      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
726      *
727      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
728      *
729      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
730      * implement alternative mechanisms to perform token transfer, such as signature-based.
731      *
732      * Requirements:
733      *
734      * - `from` cannot be the zero address.
735      * - `to` cannot be the zero address.
736      * - `tokenId` token must exist and be owned by `from`.
737      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
738      *
739      * Emits a {Transfer} event.
740      */
741     function _safeTransfer(
742         address from,
743         address to,
744         uint256 tokenId,
745         bytes memory _data
746     ) internal virtual {
747         _transfer(from, to, tokenId);
748         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
749     }
750 
751     /**
752      * @dev Returns whether `tokenId` exists.
753      *
754      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
755      *
756      * Tokens start existing when they are minted (`_mint`),
757      * and stop existing when they are burned (`_burn`).
758      */
759     function _exists(uint256 tokenId) internal view virtual returns (bool) {
760         return _owners[tokenId] != address(0);
761     }
762 
763     /**
764      * @dev Returns whether `spender` is allowed to manage `tokenId`.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must exist.
769      */
770     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
771         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
772         address owner = ERC721.ownerOf(tokenId);
773         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
774     }
775 
776     /**
777      * @dev Safely mints `tokenId` and transfers it to `to`.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must not exist.
782      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
783      *
784      * Emits a {Transfer} event.
785      */
786     function _safeMint(address to, uint256 tokenId) internal virtual {
787         _safeMint(to, tokenId, "");
788     }
789 
790     /**
791      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
792      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
793      */
794     function _safeMint(
795         address to,
796         uint256 tokenId,
797         bytes memory _data
798     ) internal virtual {
799         _mint(to, tokenId);
800         require(
801             _checkOnERC721Received(address(0), to, tokenId, _data),
802             "ERC721: transfer to non ERC721Receiver implementer"
803         );
804     }
805 
806     /**
807      * @dev Mints `tokenId` and transfers it to `to`.
808      *
809      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
810      *
811      * Requirements:
812      *
813      * - `tokenId` must not exist.
814      * - `to` cannot be the zero address.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _mint(address to, uint256 tokenId) internal virtual {
819         require(to != address(0), "ERC721: mint to the zero address");
820         require(!_exists(tokenId), "ERC721: token already minted");
821 
822         _beforeTokenTransfer(address(0), to, tokenId);
823 
824         _balances[to] += 1;
825         _owners[tokenId] = to;
826 
827         emit Transfer(address(0), to, tokenId);
828     }
829 
830     /**
831      * @dev Destroys `tokenId`.
832      * The approval is cleared when the token is burned.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must exist.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _burn(uint256 tokenId) internal virtual {
841         address owner = ERC721.ownerOf(tokenId);
842 
843         _beforeTokenTransfer(owner, address(0), tokenId);
844 
845         // Clear approvals
846         _approve(address(0), tokenId);
847 
848         _balances[owner] -= 1;
849         delete _owners[tokenId];
850 
851         emit Transfer(owner, address(0), tokenId);
852     }
853 
854     /**
855      * @dev Transfers `tokenId` from `from` to `to`.
856      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
857      *
858      * Requirements:
859      *
860      * - `to` cannot be the zero address.
861      * - `tokenId` token must be owned by `from`.
862      *
863      * Emits a {Transfer} event.
864      */
865     function _transfer(
866         address from,
867         address to,
868         uint256 tokenId
869     ) internal virtual {
870         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
871         require(to != address(0), "ERC721: transfer to the zero address");
872 
873         _beforeTokenTransfer(from, to, tokenId);
874 
875         // Clear approvals from the previous owner
876         _approve(address(0), tokenId);
877 
878         _balances[from] -= 1;
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev Approve `to` to operate on `tokenId`
887      *
888      * Emits a {Approval} event.
889      */
890     function _approve(address to, uint256 tokenId) internal virtual {
891         _tokenApprovals[tokenId] = to;
892         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
893     }
894 
895     /**
896      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
897      * The call is not executed if the target address is not a contract.
898      *
899      * @param from address representing the previous owner of the given token ID
900      * @param to target address that will receive the tokens
901      * @param tokenId uint256 ID of the token to be transferred
902      * @param _data bytes optional data to send along with the call
903      * @return bool whether the call correctly returned the expected magic value
904      */
905     function _checkOnERC721Received(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) private returns (bool) {
911         if (to.isContract()) {
912             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
913                 return retval == IERC721Receiver(to).onERC721Received.selector;
914             } catch (bytes memory reason) {
915                 if (reason.length == 0) {
916                     revert("ERC721: transfer to non ERC721Receiver implementer");
917                 } else {
918                     assembly {
919                         revert(add(32, reason), mload(reason))
920                     }
921                 }
922             }
923         } else {
924             return true;
925         }
926     }
927 
928     /**
929      * @dev Hook that is called before any token transfer. This includes minting
930      * and burning.
931      *
932      * Calling conditions:
933      *
934      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
935      * transferred to `to`.
936      * - When `from` is zero, `tokenId` will be minted for `to`.
937      * - When `to` is zero, ``from``'s `tokenId` will be burned.
938      * - `from` and `to` are never both zero.
939      *
940      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
941      */
942     function _beforeTokenTransfer(
943         address from,
944         address to,
945         uint256 tokenId
946     ) internal virtual {}
947 }
948 
949 // File: openzeppelin-solidity/contracts/access/Ownable.sol
950 
951 pragma solidity ^0.8.0;
952 
953 /**
954  * @dev Contract module which provides a basic access control mechanism, where
955  * there is an account (an owner) that can be granted exclusive access to
956  * specific functions.
957  *
958  * By default, the owner account will be the one that deploys the contract. This
959  * can later be changed with {transferOwnership}.
960  *
961  * This module is used through inheritance. It will make available the modifier
962  * `onlyOwner`, which can be applied to your functions to restrict their use to
963  * the owner.
964  */
965 abstract contract Ownable is Context {
966     address private _owner;
967 
968     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
969 
970     /**
971      * @dev Initializes the contract setting the deployer as the initial owner.
972      */
973     constructor() {
974         _setOwner(_msgSender());
975     }
976 
977     /**
978      * @dev Returns the address of the current owner.
979      */
980     function owner() public view virtual returns (address) {
981         return _owner;
982     }
983 
984     /**
985      * @dev Throws if called by any account other than the owner.
986      */
987     modifier onlyOwner() {
988         require(owner() == _msgSender(), "Ownable: caller is not the owner");
989         _;
990     }
991 
992     /**
993      * @dev Leaves the contract without owner. It will not be possible to call
994      * `onlyOwner` functions anymore. Can only be called by the current owner.
995      *
996      * NOTE: Renouncing ownership will leave the contract without an owner,
997      * thereby removing any functionality that is only available to the owner.
998      */
999     function renounceOwnership() public virtual onlyOwner {
1000         _setOwner(address(0));
1001     }
1002 
1003     /**
1004      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1005      * Can only be called by the current owner.
1006      */
1007     function transferOwnership(address newOwner) public virtual onlyOwner {
1008         require(newOwner != address(0), "Ownable: new owner is the zero address");
1009         _setOwner(newOwner);
1010     }
1011 
1012     function _setOwner(address newOwner) private {
1013         address oldOwner = _owner;
1014         _owner = newOwner;
1015         emit OwnershipTransferred(oldOwner, newOwner);
1016     }
1017 }
1018 
1019 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 /**
1024  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1025  * @dev See https://eips.ethereum.org/EIPS/eip-721
1026  */
1027 interface IERC721Enumerable is IERC721 {
1028     /**
1029      * @dev Returns the total amount of tokens stored by the contract.
1030      */
1031     function totalSupply() external view returns (uint256);
1032 
1033     /**
1034      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1035      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1036      */
1037     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1038 
1039     /**
1040      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1041      * Use along with {totalSupply} to enumerate all tokens.
1042      */
1043     function tokenByIndex(uint256 index) external view returns (uint256);
1044 }
1045 
1046 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1047 
1048 pragma solidity ^0.8.0;
1049 
1050 /**
1051  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1052  * enumerability of all the token ids in the contract as well as all token ids owned by each
1053  * account.
1054  */
1055 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1056     // Mapping from owner to list of owned token IDs
1057     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1058 
1059     // Mapping from token ID to index of the owner tokens list
1060     mapping(uint256 => uint256) private _ownedTokensIndex;
1061 
1062     // Array with all token ids, used for enumeration
1063     uint256[] private _allTokens;
1064 
1065     // Mapping from token id to position in the allTokens array
1066     mapping(uint256 => uint256) private _allTokensIndex;
1067 
1068     /**
1069      * @dev See {IERC165-supportsInterface}.
1070      */
1071     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1072         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1077      */
1078     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1079         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1080         return _ownedTokens[owner][index];
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Enumerable-totalSupply}.
1085      */
1086     function totalSupply() public view virtual override returns (uint256) {
1087         return _allTokens.length;
1088     }
1089 
1090     /**
1091      * @dev See {IERC721Enumerable-tokenByIndex}.
1092      */
1093     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1094         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1095         return _allTokens[index];
1096     }
1097 
1098     /**
1099      * @dev Hook that is called before any token transfer. This includes minting
1100      * and burning.
1101      *
1102      * Calling conditions:
1103      *
1104      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1105      * transferred to `to`.
1106      * - When `from` is zero, `tokenId` will be minted for `to`.
1107      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1108      * - `from` cannot be the zero address.
1109      * - `to` cannot be the zero address.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) internal virtual override {
1118         super._beforeTokenTransfer(from, to, tokenId);
1119 
1120         if (from == address(0)) {
1121             _addTokenToAllTokensEnumeration(tokenId);
1122         } else if (from != to) {
1123             _removeTokenFromOwnerEnumeration(from, tokenId);
1124         }
1125         if (to == address(0)) {
1126             _removeTokenFromAllTokensEnumeration(tokenId);
1127         } else if (to != from) {
1128             _addTokenToOwnerEnumeration(to, tokenId);
1129         }
1130     }
1131 
1132     /**
1133      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1134      * @param to address representing the new owner of the given token ID
1135      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1136      */
1137     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1138         uint256 length = ERC721.balanceOf(to);
1139         _ownedTokens[to][length] = tokenId;
1140         _ownedTokensIndex[tokenId] = length;
1141     }
1142 
1143     /**
1144      * @dev Private function to add a token to this extension's token tracking data structures.
1145      * @param tokenId uint256 ID of the token to be added to the tokens list
1146      */
1147     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1148         _allTokensIndex[tokenId] = _allTokens.length;
1149         _allTokens.push(tokenId);
1150     }
1151 
1152     /**
1153      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1154      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1155      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1156      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1157      * @param from address representing the previous owner of the given token ID
1158      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1159      */
1160     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1161         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1162         // then delete the last slot (swap and pop).
1163 
1164         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1165         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1166 
1167         // When the token to delete is the last token, the swap operation is unnecessary
1168         if (tokenIndex != lastTokenIndex) {
1169             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1170 
1171             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1172             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1173         }
1174 
1175         // This also deletes the contents at the last position of the array
1176         delete _ownedTokensIndex[tokenId];
1177         delete _ownedTokens[from][lastTokenIndex];
1178     }
1179 
1180     /**
1181      * @dev Private function to remove a token from this extension's token tracking data structures.
1182      * This has O(1) time complexity, but alters the order of the _allTokens array.
1183      * @param tokenId uint256 ID of the token to be removed from the tokens list
1184      */
1185     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1186         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1187         // then delete the last slot (swap and pop).
1188 
1189         uint256 lastTokenIndex = _allTokens.length - 1;
1190         uint256 tokenIndex = _allTokensIndex[tokenId];
1191 
1192         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1193         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1194         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1195         uint256 lastTokenId = _allTokens[lastTokenIndex];
1196 
1197         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1198         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1199 
1200         // This also deletes the contents at the last position of the array
1201         delete _allTokensIndex[tokenId];
1202         _allTokens.pop();
1203     }
1204 }
1205 
1206 // File: contracts/RSS.sol
1207 
1208 /**
1209 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0l.      'l0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1210 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0c.          .l0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1211 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk.   .:lool;.   'kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1212 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0'   :KWMMMMWO'   ,0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1213 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx.  .OMMMMMMMWd   .kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1214 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO.  .oNMMMMMMK;   .OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1215 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo.   ,okkkxl'   .oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1216 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx'            ,kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1217 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNNXkc,......,lkXWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1218 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0:;d0XNXKKKKXWWKx::0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1219 MMMMMMMMMMMMMMMMMMMMMMMMMMMMWk'    .,clox0WNd.   'kWMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1220 MMMMMMMMMMMMMMMMMMMMMMMMMMMNd.         ckKKc      .dNMMMMMMMMMMMMMMMMMMMMMMMMMMM
1221 MMMMMMMMMMMMMMMMMMMMMMMMMMXl.        .dNMXc        .lXMMMMMMMMMMMMMMMMMMMMMMMMMM
1222 MMMMMMMMMMMMMMMMMMMMMMMMMK:         ,OWMMWO,         :KMMMMMMMMMMMMMMMMMMMMMMMMM
1223 MMMMMMMMMMMMMMMMMMMMMMMW0,         cKMMMMMMK:         ,0WMMMMMMMMMMMMMMMMMMMMMMM
1224 MMMMMMMMMMMMMMMMMMMMMMWk'        .oNMMMMMMMMNo.        'kWMMMMMMMMMMMMMMMMMMMMMM
1225 MMMMMMMMMMMMMMMMMMMMMNd.      ..;kWMMMMMMMMMMWk;..      .dNMMMMMMMMMMMMMMMMMMMMM
1226 MMMMMMMMMMMMMMMMMMMMXl.    'lkKXNWMMMMMMMMMMMMWNXKkl'    .lXMMMMMMMMMMMMMMMMMMMM
1227 MMMMMMMMMMMMMMMMMMMK:    .oXMMMMMMMMMMMMMMMMMMMMMMMMXo.    :KMMMMMMMMMMMMMMMMMMM
1228 MMMMMMMMMMMMMMMMMW0,    .xWMMMMMMMMMMMMMMMMMMMMMMMMMMWx.    ,0WMMMMMMMMMMMMMMMMM
1229 MMMMMMMMMMMMMMMMWk'     .,:cdOXNNK0OOkkkkkkOO0XNNXOdc;,.     'kWMMMMMMMMMMMMMMMM
1230 MMMMMMMMMMMMMMMNd.    .       .'...          ..''.      ..    .dNMMMMMMMMMMMMMMM
1231 ONMMMMMMMMMMMMXl.    :x;                                :k:    .lXMMMMMMMMMMMWX0
1232 .'dKWMMMMMMMMK:     ,l:.                                .cl,     :KMMMMMMMMW0l.,
1233 .  .l0WMMMMW0,     ..    ..;cloddolc'      ,cloddolc;.     ..     ,OWMMMMNOc.  '
1234 .    .:ONMWk.     ..  .;d0NWMMMMMMMMNo.  .dNMMMMMMMMWX0d,   ..     .kWMXx;.    '
1235 .      .;dl.    .;'. 'xNMMMMMMMMMMMMM0'  ,KMMMMMMMMMMMMMNx. .';.    .dXx.      ,
1236 .    .         ,0WN0k0Odoodk0XWMMMMMMk.  'OMMMMMMWX0kdood00kKNWO,    .l0o..    ,
1237 x,...         ;KMMMMMWXkc.  ..;ok00Od'    ,xO00kl;..  .ckNMMMMMMO'     :Ox'...;k
1238 MNO:.        ;clONMMMMMMWXx;.     .          .     .:xXWMMMMMMXx;       ,Ok;l0WM
1239 MMMNk'     'c:. .;xXMMMMMMMW0o,.                .;dKWMMMMMMWKd'          .xNWMMM
1240 MMMNd.  .;l:.      'oKWMMMMMMMNOl,   'xOOd'  .,o0WMMMMMMMW0l.             .dNMMM
1241 MMXl. 'o0Kc..        .l0WMMMMMMMMNOl'.';;'.,oONMMMMMMMMNO:.       ...;xOo' .lXMM
1242 MK:.;xXMMMNOc.     .   .:kNMMMMMMMMMNklccoONMMMMMMMMMXx;.         .l0NMMWXx;.:KM
1243 0llOWMMMMMMMNO:. ...      ,xXMMMMMMMMMMMMMMMMMMMMMWKo'      ... .l0WMMMMMMMWOll0
1244 KXWMMMMMMMMMMMW0d;          'oKWMMMMMMMMMMMMMMMMW0l.         .:xKWMMMMMMMMMMMWXK
1245 MMMMMMMMMMMMMMMMWKd'.         .l0WMMMMMMMMMMMMNk:.         .,xXMMMMMMMMMMMMMMMMM
1246 MMMMMMMMMMMMMMMMMMMNk:.    ..   .:kNMMMMMMMMXx;    .     .lONMMMMMMMMMMMMMMMMMMM
1247 MMMMMMMMMMMMMMMMMMMMMNO:....       ,xXMMMWKo'       ....c0WMMMMMMMMMMMMMMMMMMMMM
1248 MMMMMMMMMMMMMMMMMMMMMMMWKd'          'oxxl.          ,xXWMMMMMMMMMMMMMMMMMMMMMMM
1249 MMMMMMMMMMMMMMMMMMMMMMMMMWKo,..                  ..;xXWMMMMMMMMMMMMMMMMMMMMMMMMM
1250 MMMMMMMMMMMMMMMMMMMMMMMMMMMMNk;    ..      ..   .cONMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1251 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk:'..        ..'c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1252 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKl.        'dXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1253 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKo'    ,dXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1254 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0:.'lXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1255 */
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 /**
1260  * @title RaccoonSecretSociety contract
1261  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1262  */
1263 contract RaccoonSecretSociety is ERC721, ERC721Enumerable, Ownable {
1264     using Strings for uint256;
1265     
1266     uint256 public constant tokenPrice = 20000000000000000; // 0.02 ETH
1267     uint public constant maxTokenPurchase = 10;
1268     uint256 public MAX_TOKENS = 10000;
1269     bool public allowNewMembers = false;
1270     uint256 public harbingerSeed;
1271     address public harbingerContract;
1272     uint256 public REVEAL_TIMESTAMP = 1630108800;
1273     mapping (uint256 => bool) private _renouncedHarbingers;
1274     string private _baseURIextended;
1275 
1276     constructor() ERC721("Raccoon Secret Society", "RSS") {
1277     }
1278 
1279     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
1280         super._beforeTokenTransfer(from, to, tokenId);
1281     }
1282 
1283     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
1284         return super.supportsInterface(interfaceId);
1285     }
1286 
1287     function setBaseURI(string memory baseURI_) external onlyOwner {
1288         _baseURIextended = baseURI_;
1289     }
1290     
1291     function setHarbingerContractAddress(address harbingerContract_) external onlyOwner {
1292         harbingerContract = harbingerContract_;
1293     }
1294 
1295     function _baseURI() internal view virtual override returns (string memory) {
1296         return _baseURIextended;
1297     }
1298 
1299     function reserveTokens(uint numberOfTokens) public onlyOwner {
1300         uint supply = totalSupply();
1301         require(supply + numberOfTokens <= MAX_TOKENS, "Reserve would exceed max supply of tokens");
1302         uint mintIndex;
1303         for (mintIndex = supply + 1; mintIndex <= supply + numberOfTokens; mintIndex++) {
1304             _safeMint(msg.sender, mintIndex);
1305         }
1306     }
1307     
1308     function flipSaleState() public onlyOwner {
1309         allowNewMembers = !allowNewMembers;
1310     }
1311     
1312     function setRevealTimestamp(uint256 timestamp) public onlyOwner {
1313         REVEAL_TIMESTAMP = timestamp;   
1314     }
1315     
1316     function initiate(uint numberOfTokens) public payable {
1317         require(allowNewMembers, "The society does not accept new members at the time");
1318         require(numberOfTokens <= maxTokenPurchase, "Exceeded max token purchase");
1319         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply of tokens");
1320         require(tokenPrice * numberOfTokens <= msg.value, "Ether value sent is not correct");
1321         
1322         for(uint i = 0; i < numberOfTokens; i++) {
1323             uint mintIndex = totalSupply() + 1;
1324             if (totalSupply() < MAX_TOKENS) {
1325                 _safeMint(msg.sender, mintIndex);
1326             }
1327         }
1328         
1329         if (harbingerSeed == 0 && (totalSupply() == MAX_TOKENS || block.timestamp >= REVEAL_TIMESTAMP)) {
1330             harbingerSeed = block.number % MAX_TOKENS;
1331             if (harbingerSeed == 0) {
1332                 harbingerSeed = harbingerSeed + 1;
1333             }
1334         }
1335     }
1336 
1337     function withdraw() public onlyOwner {
1338         uint balance = address(this).balance;
1339         payable(msg.sender).transfer(balance);
1340     }
1341     
1342     function isHarbinger(uint256 tokenId) public view returns (bool) {
1343         require(_exists(tokenId));
1344         uint256 harbingerId = (tokenId + harbingerSeed) % MAX_TOKENS + 1;
1345         return harbingerSeed != 0 && harbingerId % 10 == 0 && !_renouncedHarbingers[harbingerId];
1346     }
1347     
1348     function isHarbingerExternal(uint256 tokenId) external view returns (bool) {
1349         return isHarbinger(tokenId);
1350     }
1351     
1352     function ritualCheck(uint256 token1, uint256 token2, uint256 token3) external view returns (bool) {
1353         return isHarbinger(token1) && isHarbinger(token2) && isHarbinger(token3);   
1354     }
1355     
1356     function renounceHarbinger(uint256 tokenId) external {
1357         address owner = ownerOf(tokenId);
1358         require(isHarbinger(tokenId), "Token is not a Harbinger");
1359         require(msg.sender == owner || (harbingerContract != address(0) && msg.sender == harbingerContract), "You don't own this token");
1360         
1361         _renouncedHarbingers[(tokenId + harbingerSeed) % MAX_TOKENS + 1] = true;
1362     }
1363     
1364     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1365         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1366         if (harbingerSeed != 0) {
1367             tokenId = isHarbinger(tokenId) ? tokenId + MAX_TOKENS : tokenId;
1368         }
1369 
1370         string memory baseURI = _baseURI();
1371         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1372     }
1373 }