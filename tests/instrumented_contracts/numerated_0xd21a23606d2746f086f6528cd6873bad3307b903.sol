1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 
25 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37 
38     /**
39      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
40      */
41     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
45      */
46     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
47 
48     /**
49      * @dev Returns the number of tokens in ``owner``'s account.
50      */
51     function balanceOf(address owner) external view returns (uint256 balance);
52 
53     /**
54      * @dev Returns the owner of the `tokenId` token.
55      *
56      * Requirements:
57      *
58      * - `tokenId` must exist.
59      */
60     function ownerOf(uint256 tokenId) external view returns (address owner);
61 
62     /**
63      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
64      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
65      *
66      * Requirements:
67      *
68      * - `from` cannot be the zero address.
69      * - `to` cannot be the zero address.
70      * - `tokenId` token must exist and be owned by `from`.
71      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
72      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
73      *
74      * Emits a {Transfer} event.
75      */
76     function safeTransferFrom(address from, address to, uint256 tokenId) external;
77 
78     /**
79      * @dev Transfers `tokenId` token from `from` to `to`.
80      *
81      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
82      *
83      * Requirements:
84      *
85      * - `from` cannot be the zero address.
86      * - `to` cannot be the zero address.
87      * - `tokenId` token must be owned by `from`.
88      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address from, address to, uint256 tokenId) external;
93 
94     /**
95      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
96      * The approval is cleared when the token is transferred.
97      *
98      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
99      *
100      * Requirements:
101      *
102      * - The caller must own the token or be an approved operator.
103      * - `tokenId` must exist.
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address to, uint256 tokenId) external;
108 
109     /**
110      * @dev Returns the account approved for `tokenId` token.
111      *
112      * Requirements:
113      *
114      * - `tokenId` must exist.
115      */
116     function getApproved(uint256 tokenId) external view returns (address operator);
117 
118     /**
119      * @dev Approve or remove `operator` as an operator for the caller.
120      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
121      *
122      * Requirements:
123      *
124      * - The `operator` cannot be the caller.
125      *
126      * Emits an {ApprovalForAll} event.
127      */
128     function setApprovalForAll(address operator, bool _approved) external;
129 
130     /**
131      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
132      *
133      * See {setApprovalForAll}
134      */
135     function isApprovedForAll(address owner, address operator) external view returns (bool);
136 
137     /**
138       * @dev Safely transfers `tokenId` token from `from` to `to`.
139       *
140       * Requirements:
141       *
142       * - `from` cannot be the zero address.
143       * - `to` cannot be the zero address.
144       * - `tokenId` token must exist and be owned by `from`.
145       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
147       *
148       * Emits a {Transfer} event.
149       */
150     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
151 }
152 
153 
154 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
155 
156 pragma solidity ^0.8.0;
157 
158 /**
159  * @title ERC721 token receiver interface
160  * @dev Interface for any contract that wants to support safeTransfers
161  * from ERC721 asset contracts.
162  */
163 interface IERC721Receiver {
164     /**
165      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
166      * by `operator` from `from`, this function is called.
167      *
168      * It must return its Solidity selector to confirm the token transfer.
169      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
170      *
171      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
172      */
173     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
183  * @dev See https://eips.ethereum.org/EIPS/eip-721
184  */
185 interface IERC721Metadata is IERC721 {
186 
187     /**
188      * @dev Returns the token collection name.
189      */
190     function name() external view returns (string memory);
191 
192     /**
193      * @dev Returns the token collection symbol.
194      */
195     function symbol() external view returns (string memory);
196 
197     /**
198      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
199      */
200     function tokenURI(uint256 tokenId) external view returns (string memory);
201 }
202 
203 
204 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Collection of functions related to the address type
210  */
211 library Address {
212     /**
213      * @dev Returns true if `account` is a contract.
214      *
215      * [IMPORTANT]
216      * ====
217      * It is unsafe to assume that an address for which this function returns
218      * false is an externally-owned account (EOA) and not a contract.
219      *
220      * Among others, `isContract` will return false for the following
221      * types of addresses:
222      *
223      *  - an externally-owned account
224      *  - a contract in construction
225      *  - an address where a contract will be created
226      *  - an address where a contract lived, but was destroyed
227      * ====
228      */
229     function isContract(address account) internal view returns (bool) {
230         // This method relies on extcodesize, which returns 0 for contracts in
231         // construction, since the code is only stored at the end of the
232         // constructor execution.
233 
234         uint256 size;
235         // solhint-disable-next-line no-inline-assembly
236         assembly { size := extcodesize(account) }
237         return size > 0;
238     }
239 
240     /**
241      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
242      * `recipient`, forwarding all available gas and reverting on errors.
243      *
244      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
245      * of certain opcodes, possibly making contracts go over the 2300 gas limit
246      * imposed by `transfer`, making them unable to receive funds via
247      * `transfer`. {sendValue} removes this limitation.
248      *
249      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
250      *
251      * IMPORTANT: because control is transferred to `recipient`, care must be
252      * taken to not create reentrancy vulnerabilities. Consider using
253      * {ReentrancyGuard} or the
254      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
260         (bool success, ) = recipient.call{ value: amount }("");
261         require(success, "Address: unable to send value, recipient may have reverted");
262     }
263 
264     /**
265      * @dev Performs a Solidity function call using a low level `call`. A
266      * plain`call` is an unsafe replacement for a function call: use this
267      * function instead.
268      *
269      * If `target` reverts with a revert reason, it is bubbled up by this
270      * function (like regular Solidity function calls).
271      *
272      * Returns the raw returned data. To convert to the expected return value,
273      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
274      *
275      * Requirements:
276      *
277      * - `target` must be a contract.
278      * - calling `target` with `data` must not revert.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
283       return functionCall(target, data, "Address: low-level call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
288      * `errorMessage` as a fallback revert reason when `target` reverts.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
293         return functionCallWithValue(target, data, 0, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but also transferring `value` wei to `target`.
299      *
300      * Requirements:
301      *
302      * - the calling contract must have an ETH balance of at least `value`.
303      * - the called Solidity function must be `payable`.
304      *
305      * _Available since v3.1._
306      */
307     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
308         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
313      * with `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
318         require(address(this).balance >= value, "Address: insufficient balance for call");
319         require(isContract(target), "Address: call to non-contract");
320 
321         // solhint-disable-next-line avoid-low-level-calls
322         (bool success, bytes memory returndata) = target.call{ value: value }(data);
323         return _verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
333         return functionStaticCall(target, data, "Address: low-level static call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
343         require(isContract(target), "Address: static call to non-contract");
344 
345         // solhint-disable-next-line avoid-low-level-calls
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return _verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         require(isContract(target), "Address: delegate call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.delegatecall(data);
371         return _verifyCallResult(success, returndata, errorMessage);
372     }
373 
374     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 
395 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
396 
397 pragma solidity ^0.8.0;
398 
399 /*
400  * @dev Provides information about the current execution context, including the
401  * sender of the transaction and its data. While these are generally available
402  * via msg.sender and msg.data, they should not be accessed in such a direct
403  * manner, since when dealing with meta-transactions the account sending and
404  * paying for execution may not be the actual sender (as far as an application
405  * is concerned).
406  *
407  * This contract is only required for intermediate, library-like contracts.
408  */
409 abstract contract Context {
410     function _msgSender() internal view virtual returns (address) {
411         return msg.sender;
412     }
413 
414     function _msgData() internal view virtual returns (bytes calldata) {
415         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
416         return msg.data;
417     }
418 }
419 
420 
421 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
422 
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev String operations.
428  */
429 library Strings {
430     bytes16 private constant alphabet = "0123456789abcdef";
431 
432     /**
433      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
434      */
435     function toString(uint256 value) internal pure returns (string memory) {
436         // Inspired by OraclizeAPI's implementation - MIT licence
437         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
438 
439         if (value == 0) {
440             return "0";
441         }
442         uint256 temp = value;
443         uint256 digits;
444         while (temp != 0) {
445             digits++;
446             temp /= 10;
447         }
448         bytes memory buffer = new bytes(digits);
449         while (value != 0) {
450             digits -= 1;
451             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
452             value /= 10;
453         }
454         return string(buffer);
455     }
456 
457     /**
458      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
459      */
460     function toHexString(uint256 value) internal pure returns (string memory) {
461         if (value == 0) {
462             return "0x00";
463         }
464         uint256 temp = value;
465         uint256 length = 0;
466         while (temp != 0) {
467             length++;
468             temp >>= 8;
469         }
470         return toHexString(value, length);
471     }
472 
473     /**
474      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
475      */
476     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
477         bytes memory buffer = new bytes(2 * length + 2);
478         buffer[0] = "0";
479         buffer[1] = "x";
480         for (uint256 i = 2 * length + 1; i > 1; --i) {
481             buffer[i] = alphabet[value & 0xf];
482             value >>= 4;
483         }
484         require(value == 0, "Strings: hex length insufficient");
485         return string(buffer);
486     }
487 
488 }
489 
490 
491 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
492 
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev Implementation of the {IERC165} interface.
498  *
499  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
500  * for the additional interface id that will be supported. For example:
501  *
502  * ```solidity
503  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
505  * }
506  * ```
507  *
508  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
509  */
510 abstract contract ERC165 is IERC165 {
511     /**
512      * @dev See {IERC165-supportsInterface}.
513      */
514     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
515         return interfaceId == type(IERC165).interfaceId;
516     }
517 }
518 
519 
520 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
521 
522 
523 pragma solidity ^0.8.0;
524 
525 
526 
527 
528 
529 
530 
531 /**
532  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
533  * the Metadata extension, but not including the Enumerable extension, which is available separately as
534  * {ERC721Enumerable}.
535  */
536 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
537     using Address for address;
538     using Strings for uint256;
539 
540     // Token name
541     string private _name;
542 
543     // Token symbol
544     string private _symbol;
545 
546     // Mapping from token ID to owner address
547     mapping (uint256 => address) private _owners;
548 
549     // Mapping owner address to token count
550     mapping (address => uint256) private _balances;
551 
552     // Mapping from token ID to approved address
553     mapping (uint256 => address) private _tokenApprovals;
554 
555     // Mapping from owner to operator approvals
556     mapping (address => mapping (address => bool)) private _operatorApprovals;
557 
558     /**
559      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
560      */
561     constructor (string memory name_, string memory symbol_) {
562         _name = name_;
563         _symbol = symbol_;
564     }
565 
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
570         return interfaceId == type(IERC721).interfaceId
571             || interfaceId == type(IERC721Metadata).interfaceId
572             || super.supportsInterface(interfaceId);
573     }
574 
575     /**
576      * @dev See {IERC721-balanceOf}.
577      */
578     function balanceOf(address owner) public view virtual override returns (uint256) {
579         require(owner != address(0), "ERC721: balance query for the zero address");
580         return _balances[owner];
581     }
582 
583     /**
584      * @dev See {IERC721-ownerOf}.
585      */
586     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
587         address owner = _owners[tokenId];
588         require(owner != address(0), "ERC721: owner query for nonexistent token");
589         return owner;
590     }
591 
592     /**
593      * @dev See {IERC721Metadata-name}.
594      */
595     function name() public view virtual override returns (string memory) {
596         return _name;
597     }
598 
599     /**
600      * @dev See {IERC721Metadata-symbol}.
601      */
602     function symbol() public view virtual override returns (string memory) {
603         return _symbol;
604     }
605 
606     /**
607      * @dev See {IERC721Metadata-tokenURI}.
608      */
609     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
610         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
611 
612         string memory baseURI = _baseURI();
613         return bytes(baseURI).length > 0
614             ? string(abi.encodePacked(baseURI, tokenId.toString()))
615             : '';
616     }
617 
618     /**
619      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
620      * in child contracts.
621      */
622     function _baseURI() internal view virtual returns (string memory) {
623         return "";
624     }
625 
626     /**
627      * @dev See {IERC721-approve}.
628      */
629     function approve(address to, uint256 tokenId) public virtual override {
630         address owner = ERC721.ownerOf(tokenId);
631         require(to != owner, "ERC721: approval to current owner");
632 
633         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
634             "ERC721: approve caller is not owner nor approved for all"
635         );
636 
637         _approve(to, tokenId);
638     }
639 
640     /**
641      * @dev See {IERC721-getApproved}.
642      */
643     function getApproved(uint256 tokenId) public view virtual override returns (address) {
644         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
645 
646         return _tokenApprovals[tokenId];
647     }
648 
649     /**
650      * @dev See {IERC721-setApprovalForAll}.
651      */
652     function setApprovalForAll(address operator, bool approved) public virtual override {
653         require(operator != _msgSender(), "ERC721: approve to caller");
654 
655         _operatorApprovals[_msgSender()][operator] = approved;
656         emit ApprovalForAll(_msgSender(), operator, approved);
657     }
658 
659     /**
660      * @dev See {IERC721-isApprovedForAll}.
661      */
662     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
663         return _operatorApprovals[owner][operator];
664     }
665 
666     /**
667      * @dev See {IERC721-transferFrom}.
668      */
669     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
670         //solhint-disable-next-line max-line-length
671         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
672 
673         _transfer(from, to, tokenId);
674     }
675 
676     /**
677      * @dev See {IERC721-safeTransferFrom}.
678      */
679     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
680         safeTransferFrom(from, to, tokenId, "");
681     }
682 
683     /**
684      * @dev See {IERC721-safeTransferFrom}.
685      */
686     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
687         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
688         _safeTransfer(from, to, tokenId, _data);
689     }
690 
691     /**
692      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
693      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
694      *
695      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
696      *
697      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
698      * implement alternative mechanisms to perform token transfer, such as signature-based.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must exist and be owned by `from`.
705      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
706      *
707      * Emits a {Transfer} event.
708      */
709     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
710         _transfer(from, to, tokenId);
711         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
712     }
713 
714     /**
715      * @dev Returns whether `tokenId` exists.
716      *
717      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
718      *
719      * Tokens start existing when they are minted (`_mint`),
720      * and stop existing when they are burned (`_burn`).
721      */
722     function _exists(uint256 tokenId) internal view virtual returns (bool) {
723         return _owners[tokenId] != address(0);
724     }
725 
726     /**
727      * @dev Returns whether `spender` is allowed to manage `tokenId`.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
734         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
735         address owner = ERC721.ownerOf(tokenId);
736         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
737     }
738 
739     /**
740      * @dev Safely mints `tokenId` and transfers it to `to`.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must not exist.
745      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
746      *
747      * Emits a {Transfer} event.
748      */
749     function _safeMint(address to, uint256 tokenId) internal virtual {
750         _safeMint(to, tokenId, "");
751     }
752 
753     /**
754      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
755      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
756      */
757     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
758         _mint(to, tokenId);
759         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
760     }
761 
762     /**
763      * @dev Mints `tokenId` and transfers it to `to`.
764      *
765      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
766      *
767      * Requirements:
768      *
769      * - `tokenId` must not exist.
770      * - `to` cannot be the zero address.
771      *
772      * Emits a {Transfer} event.
773      */
774     function _mint(address to, uint256 tokenId) internal virtual {
775         require(to != address(0), "ERC721: mint to the zero address");
776         require(!_exists(tokenId), "ERC721: token already minted");
777 
778         _beforeTokenTransfer(address(0), to, tokenId);
779 
780         _balances[to] += 1;
781         _owners[tokenId] = to;
782 
783         emit Transfer(address(0), to, tokenId);
784     }
785 
786     /**
787      * @dev Destroys `tokenId`.
788      * The approval is cleared when the token is burned.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must exist.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _burn(uint256 tokenId) internal virtual {
797         address owner = ERC721.ownerOf(tokenId);
798 
799         _beforeTokenTransfer(owner, address(0), tokenId);
800 
801         // Clear approvals
802         _approve(address(0), tokenId);
803 
804         _balances[owner] -= 1;
805         delete _owners[tokenId];
806 
807         emit Transfer(owner, address(0), tokenId);
808     }
809 
810     /**
811      * @dev Transfers `tokenId` from `from` to `to`.
812      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
813      *
814      * Requirements:
815      *
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must be owned by `from`.
818      *
819      * Emits a {Transfer} event.
820      */
821     function _transfer(address from, address to, uint256 tokenId) internal virtual {
822         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
823         require(to != address(0), "ERC721: transfer to the zero address");
824 
825         _beforeTokenTransfer(from, to, tokenId);
826 
827         // Clear approvals from the previous owner
828         _approve(address(0), tokenId);
829 
830         _balances[from] -= 1;
831         _balances[to] += 1;
832         _owners[tokenId] = to;
833 
834         emit Transfer(from, to, tokenId);
835     }
836 
837     /**
838      * @dev Approve `to` to operate on `tokenId`
839      *
840      * Emits a {Approval} event.
841      */
842     function _approve(address to, uint256 tokenId) internal virtual {
843         _tokenApprovals[tokenId] = to;
844         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
845     }
846 
847     /**
848      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
849      * The call is not executed if the target address is not a contract.
850      *
851      * @param from address representing the previous owner of the given token ID
852      * @param to target address that will receive the tokens
853      * @param tokenId uint256 ID of the token to be transferred
854      * @param _data bytes optional data to send along with the call
855      * @return bool whether the call correctly returned the expected magic value
856      */
857     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
858         private returns (bool)
859     {
860         if (to.isContract()) {
861             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
862                 return retval == IERC721Receiver(to).onERC721Received.selector;
863             } catch (bytes memory reason) {
864                 if (reason.length == 0) {
865                     revert("ERC721: transfer to non ERC721Receiver implementer");
866                 } else {
867                     // solhint-disable-next-line no-inline-assembly
868                     assembly {
869                         revert(add(32, reason), mload(reason))
870                     }
871                 }
872             }
873         } else {
874             return true;
875         }
876     }
877 
878     /**
879      * @dev Hook that is called before any token transfer. This includes minting
880      * and burning.
881      *
882      * Calling conditions:
883      *
884      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
885      * transferred to `to`.
886      * - When `from` is zero, `tokenId` will be minted for `to`.
887      * - When `to` is zero, ``from``'s `tokenId` will be burned.
888      * - `from` cannot be the zero address.
889      * - `to` cannot be the zero address.
890      *
891      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
892      */
893     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
894 }
895 
896 
897 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.1.0
898 
899 
900 pragma solidity ^0.8.0;
901 
902 /**
903  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
904  * @dev See https://eips.ethereum.org/EIPS/eip-721
905  */
906 interface IERC721Enumerable is IERC721 {
907 
908     /**
909      * @dev Returns the total amount of tokens stored by the contract.
910      */
911     function totalSupply() external view returns (uint256);
912 
913     /**
914      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
915      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
916      */
917     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
918 
919     /**
920      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
921      * Use along with {totalSupply} to enumerate all tokens.
922      */
923     function tokenByIndex(uint256 index) external view returns (uint256);
924 }
925 
926 
927 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.1.0
928 
929 
930 pragma solidity ^0.8.0;
931 
932 
933 /**
934  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
935  * enumerability of all the token ids in the contract as well as all token ids owned by each
936  * account.
937  */
938 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
939     // Mapping from owner to list of owned token IDs
940     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
941 
942     // Mapping from token ID to index of the owner tokens list
943     mapping(uint256 => uint256) private _ownedTokensIndex;
944 
945     // Array with all token ids, used for enumeration
946     uint256[] private _allTokens;
947 
948     // Mapping from token id to position in the allTokens array
949     mapping(uint256 => uint256) private _allTokensIndex;
950 
951     /**
952      * @dev See {IERC165-supportsInterface}.
953      */
954     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
955         return interfaceId == type(IERC721Enumerable).interfaceId
956             || super.supportsInterface(interfaceId);
957     }
958 
959     /**
960      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
961      */
962     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
963         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
964         return _ownedTokens[owner][index];
965     }
966 
967     /**
968      * @dev See {IERC721Enumerable-totalSupply}.
969      */
970     function totalSupply() public view virtual override returns (uint256) {
971         return _allTokens.length;
972     }
973 
974     /**
975      * @dev See {IERC721Enumerable-tokenByIndex}.
976      */
977     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
978         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
979         return _allTokens[index];
980     }
981 
982     /**
983      * @dev Hook that is called before any token transfer. This includes minting
984      * and burning.
985      *
986      * Calling conditions:
987      *
988      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
989      * transferred to `to`.
990      * - When `from` is zero, `tokenId` will be minted for `to`.
991      * - When `to` is zero, ``from``'s `tokenId` will be burned.
992      * - `from` cannot be the zero address.
993      * - `to` cannot be the zero address.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
998         super._beforeTokenTransfer(from, to, tokenId);
999 
1000         if (from == address(0)) {
1001             _addTokenToAllTokensEnumeration(tokenId);
1002         } else if (from != to) {
1003             _removeTokenFromOwnerEnumeration(from, tokenId);
1004         }
1005         if (to == address(0)) {
1006             _removeTokenFromAllTokensEnumeration(tokenId);
1007         } else if (to != from) {
1008             _addTokenToOwnerEnumeration(to, tokenId);
1009         }
1010     }
1011 
1012     /**
1013      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1014      * @param to address representing the new owner of the given token ID
1015      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1016      */
1017     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1018         uint256 length = ERC721.balanceOf(to);
1019         _ownedTokens[to][length] = tokenId;
1020         _ownedTokensIndex[tokenId] = length;
1021     }
1022 
1023     /**
1024      * @dev Private function to add a token to this extension's token tracking data structures.
1025      * @param tokenId uint256 ID of the token to be added to the tokens list
1026      */
1027     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1028         _allTokensIndex[tokenId] = _allTokens.length;
1029         _allTokens.push(tokenId);
1030     }
1031 
1032     /**
1033      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1034      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1035      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1036      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1037      * @param from address representing the previous owner of the given token ID
1038      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1039      */
1040     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1041         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1042         // then delete the last slot (swap and pop).
1043 
1044         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1045         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1046 
1047         // When the token to delete is the last token, the swap operation is unnecessary
1048         if (tokenIndex != lastTokenIndex) {
1049             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1050 
1051             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1052             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1053         }
1054 
1055         // This also deletes the contents at the last position of the array
1056         delete _ownedTokensIndex[tokenId];
1057         delete _ownedTokens[from][lastTokenIndex];
1058     }
1059 
1060     /**
1061      * @dev Private function to remove a token from this extension's token tracking data structures.
1062      * This has O(1) time complexity, but alters the order of the _allTokens array.
1063      * @param tokenId uint256 ID of the token to be removed from the tokens list
1064      */
1065     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1066         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1067         // then delete the last slot (swap and pop).
1068 
1069         uint256 lastTokenIndex = _allTokens.length - 1;
1070         uint256 tokenIndex = _allTokensIndex[tokenId];
1071 
1072         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1073         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1074         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1075         uint256 lastTokenId = _allTokens[lastTokenIndex];
1076 
1077         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1078         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1079 
1080         // This also deletes the contents at the last position of the array
1081         delete _allTokensIndex[tokenId];
1082         _allTokens.pop();
1083     }
1084 }
1085 
1086 
1087 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
1088 
1089 
1090 pragma solidity ^0.8.0;
1091 
1092 /**
1093  * @dev Contract module which provides a basic access control mechanism, where
1094  * there is an account (an owner) that can be granted exclusive access to
1095  * specific functions.
1096  *
1097  * By default, the owner account will be the one that deploys the contract. This
1098  * can later be changed with {transferOwnership}.
1099  *
1100  * This module is used through inheritance. It will make available the modifier
1101  * `onlyOwner`, which can be applied to your functions to restrict their use to
1102  * the owner.
1103  */
1104 abstract contract Ownable is Context {
1105     address private _owner;
1106 
1107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1108 
1109     /**
1110      * @dev Initializes the contract setting the deployer as the initial owner.
1111      */
1112     constructor () {
1113         address msgSender = _msgSender();
1114         _owner = msgSender;
1115         emit OwnershipTransferred(address(0), msgSender);
1116     }
1117 
1118     /**
1119      * @dev Returns the address of the current owner.
1120      */
1121     function owner() public view virtual returns (address) {
1122         return _owner;
1123     }
1124 
1125     /**
1126      * @dev Throws if called by any account other than the owner.
1127      */
1128     modifier onlyOwner() {
1129         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1130         _;
1131     }
1132 
1133     /**
1134      * @dev Leaves the contract without owner. It will not be possible to call
1135      * `onlyOwner` functions anymore. Can only be called by the current owner.
1136      *
1137      * NOTE: Renouncing ownership will leave the contract without an owner,
1138      * thereby removing any functionality that is only available to the owner.
1139      */
1140     function renounceOwnership() public virtual onlyOwner {
1141         emit OwnershipTransferred(_owner, address(0));
1142         _owner = address(0);
1143     }
1144 
1145     /**
1146      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1147      * Can only be called by the current owner.
1148      */
1149     function transferOwnership(address newOwner) public virtual onlyOwner {
1150         require(newOwner != address(0), "Ownable: new owner is the zero address");
1151         emit OwnershipTransferred(_owner, newOwner);
1152         _owner = newOwner;
1153     }
1154 }
1155 
1156 
1157 // File contracts/SRSC.sol
1158 
1159 pragma solidity ^0.8.0;
1160 contract SRSC is ERC721Enumerable, Ownable {
1161     uint public constant MAX_RATS = 8888;
1162     string _baseTokenURI;
1163     bool public paused = true;
1164 
1165     constructor(string memory baseURI) ERC721("Sewer Rat Social Club", "SRSC")  {
1166         setBaseURI(baseURI);
1167     }
1168 
1169     modifier saleIsOpen{
1170         require(totalSupply() < MAX_RATS, "Sale end");
1171         _;
1172     }
1173 
1174     /**
1175      * Sewer Rats reserved for promotions and Dev Team
1176     */
1177     function reserveRats() public onlyOwner {
1178         uint supply = totalSupply();
1179         uint i;
1180         for (i = 0; i < 30; i++) {
1181             _safeMint(msg.sender, supply + i);
1182         }
1183     }
1184 
1185 
1186     function mintSewerRat(address _to, uint _count) public payable saleIsOpen {
1187         if(msg.sender != owner()){
1188             require(!paused, "Paused");
1189         }
1190         require(totalSupply() + _count <= MAX_RATS, "Max limit");
1191         require(totalSupply() < MAX_RATS, "Sale end");
1192         require(_count <= 15, "Exceeds 15");
1193         require(msg.value >= price(_count), "Value below price");
1194 
1195         for(uint i = 0; i < _count; i++){
1196             _safeMint(_to, totalSupply());
1197         }
1198     }
1199 
1200     function price(uint _count) public view returns (uint256) {
1201         uint _id = totalSupply();
1202         // free 200
1203         if(_id <= 229 ){
1204             require(_count <= 1, "Max 1 Free Per TX");
1205             return 0;
1206         }
1207 
1208         return 50000000000000000 * _count; // 0.05 ETH
1209     }
1210 
1211     function contractURI() public view returns (string memory) {
1212         return "https://gateway.pinata.cloud/ipfs/Qmce2MpyvCSYcrRDseRWjAqQJLevaXGBAfsYnyV8eLqWDg";
1213     }
1214 
1215     function _baseURI() internal view virtual override returns (string memory) {
1216         return _baseTokenURI;
1217     }
1218     function setBaseURI(string memory baseURI) public onlyOwner {
1219         _baseTokenURI = baseURI;
1220     }
1221 
1222     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1223         uint tokenCount = balanceOf(_owner);
1224 
1225         uint256[] memory tokensId = new uint256[](tokenCount);
1226         for(uint i = 0; i < tokenCount; i++){
1227             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1228         }
1229 
1230         return tokensId;
1231     }
1232 
1233     function pause(bool val) public onlyOwner {
1234         paused = val;
1235     }
1236 
1237     function withdrawAll() public payable onlyOwner {
1238         require(payable(_msgSender()).send(address(this).balance));
1239     }
1240 }