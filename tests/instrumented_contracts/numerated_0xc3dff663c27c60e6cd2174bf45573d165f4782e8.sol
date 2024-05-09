1 // SPDX-License-Identifier: MIT
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
28 
29 pragma solidity ^0.8.0;
30 
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721 is IERC165 {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
67      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
68      *
69      * Requirements:
70      *
71      * - `from` cannot be the zero address.
72      * - `to` cannot be the zero address.
73      * - `tokenId` token must exist and be owned by `from`.
74      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
75      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
76      *
77      * Emits a {Transfer} event.
78      */
79     function safeTransferFrom(address from, address to, uint256 tokenId) external;
80 
81     /**
82      * @dev Transfers `tokenId` token from `from` to `to`.
83      *
84      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must be owned by `from`.
91      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address from, address to, uint256 tokenId) external;
96 
97     /**
98      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
99      * The approval is cleared when the token is transferred.
100      *
101      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
102      *
103      * Requirements:
104      *
105      * - The caller must own the token or be an approved operator.
106      * - `tokenId` must exist.
107      *
108      * Emits an {Approval} event.
109      */
110     function approve(address to, uint256 tokenId) external;
111 
112     /**
113      * @dev Returns the account approved for `tokenId` token.
114      *
115      * Requirements:
116      *
117      * - `tokenId` must exist.
118      */
119     function getApproved(uint256 tokenId) external view returns (address operator);
120 
121     /**
122      * @dev Approve or remove `operator` as an operator for the caller.
123      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
124      *
125      * Requirements:
126      *
127      * - The `operator` cannot be the caller.
128      *
129      * Emits an {ApprovalForAll} event.
130      */
131     function setApprovalForAll(address operator, bool _approved) external;
132 
133     /**
134      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
135      *
136      * See {setApprovalForAll}
137      */
138     function isApprovedForAll(address owner, address operator) external view returns (bool);
139 
140     /**
141       * @dev Safely transfers `tokenId` token from `from` to `to`.
142       *
143       * Requirements:
144       *
145       * - `from` cannot be the zero address.
146       * - `to` cannot be the zero address.
147       * - `tokenId` token must exist and be owned by `from`.
148       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
149       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
150       *
151       * Emits a {Transfer} event.
152       */
153     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
154 }
155 
156 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
157 
158 
159 pragma solidity ^0.8.0;
160 
161 /**
162  * @title ERC721 token receiver interface
163  * @dev Interface for any contract that wants to support safeTransfers
164  * from ERC721 asset contracts.
165  */
166 interface IERC721Receiver {
167     /**
168      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
169      * by `operator` from `from`, this function is called.
170      *
171      * It must return its Solidity selector to confirm the token transfer.
172      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
173      *
174      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
175      */
176     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
177 }
178 
179 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Metadata.sol
180 
181 
182 pragma solidity ^0.8.0;
183 
184 
185 /**
186  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
187  * @dev See https://eips.ethereum.org/EIPS/eip-721
188  */
189 interface IERC721Metadata is IERC721 {
190 
191     /**
192      * @dev Returns the token collection name.
193      */
194     function name() external view returns (string memory);
195 
196     /**
197      * @dev Returns the token collection symbol.
198      */
199     function symbol() external view returns (string memory);
200 
201     /**
202      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
203      */
204     function tokenURI(uint256 tokenId) external view returns (string memory);
205 }
206 
207 // File: openzeppelin-solidity/contracts/utils/Address.sol
208 
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Collection of functions related to the address type
214  */
215 library Address {
216     /**
217      * @dev Returns true if `account` is a contract.
218      *
219      * [IMPORTANT]
220      * ====
221      * It is unsafe to assume that an address for which this function returns
222      * false is an externally-owned account (EOA) and not a contract.
223      *
224      * Among others, `isContract` will return false for the following
225      * types of addresses:
226      *
227      *  - an externally-owned account
228      *  - a contract in construction
229      *  - an address where a contract will be created
230      *  - an address where a contract lived, but was destroyed
231      * ====
232      */
233     function isContract(address account) internal view returns (bool) {
234         // This method relies on extcodesize, which returns 0 for contracts in
235         // construction, since the code is only stored at the end of the
236         // constructor execution.
237 
238         uint256 size;
239         // solhint-disable-next-line no-inline-assembly
240         assembly { size := extcodesize(account) }
241         return size > 0;
242     }
243 
244     /**
245      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
246      * `recipient`, forwarding all available gas and reverting on errors.
247      *
248      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
249      * of certain opcodes, possibly making contracts go over the 2300 gas limit
250      * imposed by `transfer`, making them unable to receive funds via
251      * `transfer`. {sendValue} removes this limitation.
252      *
253      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
254      *
255      * IMPORTANT: because control is transferred to `recipient`, care must be
256      * taken to not create reentrancy vulnerabilities. Consider using
257      * {ReentrancyGuard} or the
258      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
259      */
260     function sendValue(address payable recipient, uint256 amount) internal {
261         require(address(this).balance >= amount, "Address: insufficient balance");
262 
263         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
264         (bool success, ) = recipient.call{ value: amount }("");
265         require(success, "Address: unable to send value, recipient may have reverted");
266     }
267 
268     /**
269      * @dev Performs a Solidity function call using a low level `call`. A
270      * plain`call` is an unsafe replacement for a function call: use this
271      * function instead.
272      *
273      * If `target` reverts with a revert reason, it is bubbled up by this
274      * function (like regular Solidity function calls).
275      *
276      * Returns the raw returned data. To convert to the expected return value,
277      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
278      *
279      * Requirements:
280      *
281      * - `target` must be a contract.
282      * - calling `target` with `data` must not revert.
283      *
284      * _Available since v3.1._
285      */
286     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
287       return functionCall(target, data, "Address: low-level call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
292      * `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, 0, errorMessage);
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
302      * but also transferring `value` wei to `target`.
303      *
304      * Requirements:
305      *
306      * - the calling contract must have an ETH balance of at least `value`.
307      * - the called Solidity function must be `payable`.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
312         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
317      * with `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
322         require(address(this).balance >= value, "Address: insufficient balance for call");
323         require(isContract(target), "Address: call to non-contract");
324 
325         // solhint-disable-next-line avoid-low-level-calls
326         (bool success, bytes memory returndata) = target.call{ value: value }(data);
327         return _verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
337         return functionStaticCall(target, data, "Address: low-level static call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
347         require(isContract(target), "Address: static call to non-contract");
348 
349         // solhint-disable-next-line avoid-low-level-calls
350         (bool success, bytes memory returndata) = target.staticcall(data);
351         return _verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
371         require(isContract(target), "Address: delegate call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return _verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 // File: openzeppelin-solidity/contracts/utils/Context.sol
399 
400 
401 pragma solidity ^0.8.0;
402 
403 /*
404  * @dev Provides information about the current execution context, including the
405  * sender of the transaction and its data. While these are generally available
406  * via msg.sender and msg.data, they should not be accessed in such a direct
407  * manner, since when dealing with meta-transactions the account sending and
408  * paying for execution may not be the actual sender (as far as an application
409  * is concerned).
410  *
411  * This contract is only required for intermediate, library-like contracts.
412  */
413 abstract contract Context {
414     function _msgSender() internal view virtual returns (address) {
415         return msg.sender;
416     }
417 
418     function _msgData() internal view virtual returns (bytes calldata) {
419         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
420         return msg.data;
421     }
422 }
423 
424 // File: openzeppelin-solidity/contracts/utils/Strings.sol
425 
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev String operations.
431  */
432 library Strings {
433     bytes16 private constant alphabet = "0123456789abcdef";
434 
435     /**
436      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
437      */
438     function toString(uint256 value) internal pure returns (string memory) {
439         // Inspired by OraclizeAPI's implementation - MIT licence
440         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
441 
442         if (value == 0) {
443             return "0";
444         }
445         uint256 temp = value;
446         uint256 digits;
447         while (temp != 0) {
448             digits++;
449             temp /= 10;
450         }
451         bytes memory buffer = new bytes(digits);
452         while (value != 0) {
453             digits -= 1;
454             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
455             value /= 10;
456         }
457         return string(buffer);
458     }
459 
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
462      */
463     function toHexString(uint256 value) internal pure returns (string memory) {
464         if (value == 0) {
465             return "0x00";
466         }
467         uint256 temp = value;
468         uint256 length = 0;
469         while (temp != 0) {
470             length++;
471             temp >>= 8;
472         }
473         return toHexString(value, length);
474     }
475 
476     /**
477      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
478      */
479     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
480         bytes memory buffer = new bytes(2 * length + 2);
481         buffer[0] = "0";
482         buffer[1] = "x";
483         for (uint256 i = 2 * length + 1; i > 1; --i) {
484             buffer[i] = alphabet[value & 0xf];
485             value >>= 4;
486         }
487         require(value == 0, "Strings: hex length insufficient");
488         return string(buffer);
489     }
490 
491 }
492 
493 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
494 
495 
496 pragma solidity ^0.8.0;
497 
498 
499 /**
500  * @dev Implementation of the {IERC165} interface.
501  *
502  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
503  * for the additional interface id that will be supported. For example:
504  *
505  * ```solidity
506  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
508  * }
509  * ```
510  *
511  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
512  */
513 abstract contract ERC165 is IERC165 {
514     /**
515      * @dev See {IERC165-supportsInterface}.
516      */
517     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
518         return interfaceId == type(IERC165).interfaceId;
519     }
520 }
521 
522 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
523 
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
530  * the Metadata extension, but not including the Enumerable extension, which is available separately as
531  * {ERC721Enumerable}.
532  */
533 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
534     using Address for address;
535     using Strings for uint256;
536 
537     // Token name
538     string private _name;
539 
540     // Token symbol
541     string private _symbol;
542 
543     // Mapping from token ID to owner address
544     mapping (uint256 => address) private _owners;
545 
546     // Mapping owner address to token count
547     mapping (address => uint256) private _balances;
548 
549     // Mapping from token ID to approved address
550     mapping (uint256 => address) private _tokenApprovals;
551 
552     // Mapping from owner to operator approvals
553     mapping (address => mapping (address => bool)) private _operatorApprovals;
554 
555     /**
556      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
557      */
558     constructor (string memory name_, string memory symbol_) {
559         _name = name_;
560         _symbol = symbol_;
561     }
562 
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
567         return interfaceId == type(IERC721).interfaceId
568             || interfaceId == type(IERC721Metadata).interfaceId
569             || super.supportsInterface(interfaceId);
570     }
571 
572     /**
573      * @dev See {IERC721-balanceOf}.
574      */
575     function balanceOf(address owner) public view virtual override returns (uint256) {
576         require(owner != address(0), "ERC721: balance query for the zero address");
577         return _balances[owner];
578     }
579 
580     /**
581      * @dev See {IERC721-ownerOf}.
582      */
583     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
584         address owner = _owners[tokenId];
585         require(owner != address(0), "ERC721: owner query for nonexistent token");
586         return owner;
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-name}.
591      */
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-symbol}.
598      */
599     function symbol() public view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-tokenURI}.
605      */
606     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
607         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
608 
609         string memory baseURI = _baseURI();
610         return bytes(baseURI).length > 0
611             ? string(abi.encodePacked(baseURI, tokenId.toString()))
612             : '';
613     }
614 
615     /**
616      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
617      * in child contracts.
618      */
619     function _baseURI() internal view virtual returns (string memory) {
620         return "";
621     }
622 
623     /**
624      * @dev See {IERC721-approve}.
625      */
626     function approve(address to, uint256 tokenId) public virtual override {
627         address owner = ERC721.ownerOf(tokenId);
628         require(to != owner, "ERC721: approval to current owner");
629 
630         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
631             "ERC721: approve caller is not owner nor approved for all"
632         );
633 
634         _approve(to, tokenId);
635     }
636 
637     /**
638      * @dev See {IERC721-getApproved}.
639      */
640     function getApproved(uint256 tokenId) public view virtual override returns (address) {
641         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
642 
643         return _tokenApprovals[tokenId];
644     }
645 
646     /**
647      * @dev See {IERC721-setApprovalForAll}.
648      */
649     function setApprovalForAll(address operator, bool approved) public virtual override {
650         require(operator != _msgSender(), "ERC721: approve to caller");
651 
652         _operatorApprovals[_msgSender()][operator] = approved;
653         emit ApprovalForAll(_msgSender(), operator, approved);
654     }
655 
656     /**
657      * @dev See {IERC721-isApprovedForAll}.
658      */
659     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
660         return _operatorApprovals[owner][operator];
661     }
662 
663     /**
664      * @dev See {IERC721-transferFrom}.
665      */
666     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
667         //solhint-disable-next-line max-line-length
668         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
669 
670         _transfer(from, to, tokenId);
671     }
672 
673     /**
674      * @dev See {IERC721-safeTransferFrom}.
675      */
676     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
677         safeTransferFrom(from, to, tokenId, "");
678     }
679 
680     /**
681      * @dev See {IERC721-safeTransferFrom}.
682      */
683     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
684         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
685         _safeTransfer(from, to, tokenId, _data);
686     }
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
690      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
691      *
692      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
693      *
694      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
695      * implement alternative mechanisms to perform token transfer, such as signature-based.
696      *
697      * Requirements:
698      *
699      * - `from` cannot be the zero address.
700      * - `to` cannot be the zero address.
701      * - `tokenId` token must exist and be owned by `from`.
702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
703      *
704      * Emits a {Transfer} event.
705      */
706     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
707         _transfer(from, to, tokenId);
708         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
709     }
710 
711     /**
712      * @dev Returns whether `tokenId` exists.
713      *
714      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
715      *
716      * Tokens start existing when they are minted (`_mint`),
717      * and stop existing when they are burned (`_burn`).
718      */
719     function _exists(uint256 tokenId) internal view virtual returns (bool) {
720         return _owners[tokenId] != address(0);
721     }
722 
723     /**
724      * @dev Returns whether `spender` is allowed to manage `tokenId`.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must exist.
729      */
730     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
731         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
732         address owner = ERC721.ownerOf(tokenId);
733         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
734     }
735 
736     /**
737      * @dev Safely mints `tokenId` and transfers it to `to`.
738      *
739      * Requirements:
740      *
741      * - `tokenId` must not exist.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _safeMint(address to, uint256 tokenId) internal virtual {
747         _safeMint(to, tokenId, "");
748     }
749 
750     /**
751      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
752      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
753      */
754     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
755         _mint(to, tokenId);
756         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
757     }
758 
759     /**
760      * @dev Mints `tokenId` and transfers it to `to`.
761      *
762      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
763      *
764      * Requirements:
765      *
766      * - `tokenId` must not exist.
767      * - `to` cannot be the zero address.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _mint(address to, uint256 tokenId) internal virtual {
772         require(to != address(0), "ERC721: mint to the zero address");
773         require(!_exists(tokenId), "ERC721: token already minted");
774 
775         _beforeTokenTransfer(address(0), to, tokenId);
776 
777         _balances[to] += 1;
778         _owners[tokenId] = to;
779 
780         emit Transfer(address(0), to, tokenId);
781     }
782 
783     /**
784      * @dev Destroys `tokenId`.
785      * The approval is cleared when the token is burned.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must exist.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _burn(uint256 tokenId) internal virtual {
794         address owner = ERC721.ownerOf(tokenId);
795 
796         _beforeTokenTransfer(owner, address(0), tokenId);
797 
798         // Clear approvals
799         _approve(address(0), tokenId);
800 
801         _balances[owner] -= 1;
802         delete _owners[tokenId];
803 
804         emit Transfer(owner, address(0), tokenId);
805     }
806 
807     /**
808      * @dev Transfers `tokenId` from `from` to `to`.
809      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
810      *
811      * Requirements:
812      *
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _transfer(address from, address to, uint256 tokenId) internal virtual {
819         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
820         require(to != address(0), "ERC721: transfer to the zero address");
821 
822         _beforeTokenTransfer(from, to, tokenId);
823 
824         // Clear approvals from the previous owner
825         _approve(address(0), tokenId);
826 
827         _balances[from] -= 1;
828         _balances[to] += 1;
829         _owners[tokenId] = to;
830 
831         emit Transfer(from, to, tokenId);
832     }
833 
834     /**
835      * @dev Approve `to` to operate on `tokenId`
836      *
837      * Emits a {Approval} event.
838      */
839     function _approve(address to, uint256 tokenId) internal virtual {
840         _tokenApprovals[tokenId] = to;
841         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
842     }
843 
844     /**
845      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
846      * The call is not executed if the target address is not a contract.
847      *
848      * @param from address representing the previous owner of the given token ID
849      * @param to target address that will receive the tokens
850      * @param tokenId uint256 ID of the token to be transferred
851      * @param _data bytes optional data to send along with the call
852      * @return bool whether the call correctly returned the expected magic value
853      */
854     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
855         private returns (bool)
856     {
857         if (to.isContract()) {
858             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
859                 return retval == IERC721Receiver(to).onERC721Received.selector;
860             } catch (bytes memory reason) {
861                 if (reason.length == 0) {
862                     revert("ERC721: transfer to non ERC721Receiver implementer");
863                 } else {
864                     // solhint-disable-next-line no-inline-assembly
865                     assembly {
866                         revert(add(32, reason), mload(reason))
867                     }
868                 }
869             }
870         } else {
871             return true;
872         }
873     }
874 
875     /**
876      * @dev Hook that is called before any token transfer. This includes minting
877      * and burning.
878      *
879      * Calling conditions:
880      *
881      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
882      * transferred to `to`.
883      * - When `from` is zero, `tokenId` will be minted for `to`.
884      * - When `to` is zero, ``from``'s `tokenId` will be burned.
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      *
888      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
889      */
890     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
891 }
892 
893 // File: openzeppelin-solidity/contracts/access/Ownable.sol
894 
895 
896 pragma solidity ^0.8.0;
897 
898 /**
899  * @dev Contract module which provides a basic access control mechanism, where
900  * there is an account (an owner) that can be granted exclusive access to
901  * specific functions.
902  *
903  * By default, the owner account will be the one that deploys the contract. This
904  * can later be changed with {transferOwnership}.
905  *
906  * This module is used through inheritance. It will make available the modifier
907  * `onlyOwner`, which can be applied to your functions to restrict their use to
908  * the owner.
909  */
910 abstract contract Ownable is Context {
911     address private _owner;
912 
913     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
914 
915     /**
916      * @dev Initializes the contract setting the deployer as the initial owner.
917      */
918     constructor () {
919         address msgSender = _msgSender();
920         _owner = msgSender;
921         emit OwnershipTransferred(address(0), msgSender);
922     }
923 
924     /**
925      * @dev Returns the address of the current owner.
926      */
927     function owner() public view virtual returns (address) {
928         return _owner;
929     }
930 
931     /**
932      * @dev Throws if called by any account other than the owner.
933      */
934     modifier onlyOwner() {
935         require(owner() == _msgSender(), "Ownable: caller is not the owner");
936         _;
937     }
938 
939     /**
940      * @dev Leaves the contract without owner. It will not be possible to call
941      * `onlyOwner` functions anymore. Can only be called by the current owner.
942      *
943      * NOTE: Renouncing ownership will leave the contract without an owner,
944      * thereby removing any functionality that is only available to the owner.
945      */
946     function renounceOwnership() public virtual onlyOwner {
947         emit OwnershipTransferred(_owner, address(0));
948         _owner = address(0);
949     }
950 
951     /**
952      * @dev Transfers ownership of the contract to a new account (`newOwner`).
953      * Can only be called by the current owner.
954      */
955     function transferOwnership(address newOwner) public virtual onlyOwner {
956         require(newOwner != address(0), "Ownable: new owner is the zero address");
957         emit OwnershipTransferred(_owner, newOwner);
958         _owner = newOwner;
959     }
960 }
961 
962 // File: contracts/Metagenesis.sol
963 
964 pragma solidity ^0.8.7;
965 
966 
967 
968 contract MetaGenesis is ERC721, Ownable {
969 
970     uint public preMintPrice = 0.08 ether;
971     uint public mintPrice = 0.08 ether;
972     uint public airdropItems = 70;
973     uint public maxItems = 9999;
974     uint public airdropMintCount = 0;
975     uint public totalSupply = 0;
976     uint public maxItemsPerPreMint = 3; 
977     uint public maxItemsPerTx = 5; 
978     string public _baseTokenURI = "https://ipfs.io/ipns/conf.metagenesis.world/";
979     bool public preMintPaused = true;
980     bool public publicMintPaused = true;
981     bool public airdropPaused = true;
982 
983     mapping(address => uint) public preMintLists; // Maps address to how many they can premint
984 
985     mapping(address => uint) public airdropLists; // Maps address to how many they can premint
986 
987 
988     event Mint(address indexed owner, uint indexed tokenId);
989 
990     constructor() ERC721("MetaGenesis", "MG") {}
991 
992     receive() external payable {}
993 
994     function preMint() external payable {
995         require(!preMintPaused, "preMint: Paused");
996         uint remainder = msg.value % preMintPrice;
997         uint amount = msg.value / preMintPrice;
998         require(remainder == 0, "preMint: Send a divisible amount of eth");
999         require(amount <= 3, "preMint: max 3 per tx");
1000         require(amount <= preMintLists[msg.sender], "preMint: Amount greater than allocation");
1001         _mintWithoutValidation(msg.sender, amount);
1002     }
1003 
1004     function airdropMint() external payable {
1005         require(!airdropPaused, "airdropMint: Paused");
1006         uint amount = 1;
1007         require(amount <= airdropLists[msg.sender], "airdropMint: Amount greater than allocation");
1008         airdropMintCount += amount;
1009         airdropLists[msg.sender] -= amount;
1010         _mintWithoutValidation(msg.sender, amount);
1011     }
1012     
1013     function publicMint() external payable {
1014         require(!publicMintPaused, "publicMint: Paused");
1015         uint remainder = msg.value % mintPrice;
1016         uint amount = msg.value / mintPrice;
1017         require(remainder == 0, "publicMint: Send a divisible amount of eth");
1018         require(amount <= maxItemsPerTx, "publicMint: Max 5 per tx");
1019         require(totalSupply - airdropMintCount + amount <= maxItems - airdropItems, "publicMint: Surpasses cap");
1020         _mintWithoutValidation(msg.sender, amount);
1021     }
1022 
1023     function _mintWithoutValidation(address to, uint amount) internal {
1024         require(totalSupply + amount <= maxItems, "mintWithoutValidation: Sold out");
1025         for (uint i = 0; i < amount; i++) {
1026             totalSupply += 1;
1027             _mint(to, totalSupply);
1028             emit Mint(to, totalSupply);
1029         }
1030     }
1031 
1032     // ADMIN FUNCTIONALITY
1033 
1034     function addToWhitelist(address[] memory toAdd) external onlyOwner {
1035         for(uint i = 0; i < toAdd.length; i++) {
1036             preMintLists[toAdd[i]] = maxItemsPerPreMint;
1037         }
1038     }
1039 
1040     function addToAirdroplist(address[] memory toAdd) external onlyOwner {
1041         for(uint i = 0; i < toAdd.length; i++) {
1042             airdropLists[toAdd[i]] = 1;
1043         }
1044     }
1045 
1046     function setPreMintPaused(bool _preMintPaused) external onlyOwner {
1047         preMintPaused = _preMintPaused;
1048     }
1049 
1050     function setPublicMintPaused(bool _publicMintPaused) external onlyOwner {
1051         publicMintPaused = _publicMintPaused;
1052     }
1053 
1054     function setAirdropPaused(bool _airdropPaused) external onlyOwner {
1055         airdropPaused = _airdropPaused;
1056     }
1057 
1058     function setBaseTokenURI(string memory __baseTokenURI) external onlyOwner {
1059         _baseTokenURI = __baseTokenURI;
1060     }
1061 
1062     /**
1063      * @dev Withdraw the contract balance to the dev address or splitter address
1064      */
1065 
1066     function withdrawAll() external onlyOwner {
1067         uint amount = address(this).balance;
1068         sendEth(0x7Fb563E33C220BfD102a611A95AE55d50806BC58, amount);
1069     }
1070     function sendEth(address to, uint amount) internal {
1071         (bool success,) = to.call{value: amount}("");
1072         require(success, "Failed to send ether");
1073     }
1074 
1075     // METADATA FUNCTIONALITY
1076 
1077     /**
1078      * @dev Returns a URI for a given token ID's metadata
1079      */
1080     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1081         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
1082     }
1083 
1084 }