1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 // SPDX-License-Identifier: MIT
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
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 pragma solidity ^0.8.0;
28 
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
77     function safeTransferFrom(address from, address to, uint256 tokenId) external;
78 
79     /**
80      * @dev Transfers `tokenId` token from `from` to `to`.
81      *
82      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
83      *
84      * Requirements:
85      *
86      * - `from` cannot be the zero address.
87      * - `to` cannot be the zero address.
88      * - `tokenId` token must be owned by `from`.
89      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address from, address to, uint256 tokenId) external;
94 
95     /**
96      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
97      * The approval is cleared when the token is transferred.
98      *
99      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
100      *
101      * Requirements:
102      *
103      * - The caller must own the token or be an approved operator.
104      * - `tokenId` must exist.
105      *
106      * Emits an {Approval} event.
107      */
108     function approve(address to, uint256 tokenId) external;
109 
110     /**
111      * @dev Returns the account approved for `tokenId` token.
112      *
113      * Requirements:
114      *
115      * - `tokenId` must exist.
116      */
117     function getApproved(uint256 tokenId) external view returns (address operator);
118 
119     /**
120      * @dev Approve or remove `operator` as an operator for the caller.
121      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
122      *
123      * Requirements:
124      *
125      * - The `operator` cannot be the caller.
126      *
127      * Emits an {ApprovalForAll} event.
128      */
129     function setApprovalForAll(address operator, bool _approved) external;
130 
131     /**
132      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
133      *
134      * See {setApprovalForAll}
135      */
136     function isApprovedForAll(address owner, address operator) external view returns (bool);
137 
138     /**
139       * @dev Safely transfers `tokenId` token from `from` to `to`.
140       *
141       * Requirements:
142       *
143       * - `from` cannot be the zero address.
144       * - `to` cannot be the zero address.
145       * - `tokenId` token must exist and be owned by `from`.
146       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
147       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
148       *
149       * Emits a {Transfer} event.
150       */
151     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
152 }
153 
154 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
155 pragma solidity ^0.8.0;
156 
157 /**
158  * @title ERC721 token receiver interface
159  * @dev Interface for any contract that wants to support safeTransfers
160  * from ERC721 asset contracts.
161  */
162 interface IERC721Receiver {
163     /**
164      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
165      * by `operator` from `from`, this function is called.
166      *
167      * It must return its Solidity selector to confirm the token transfer.
168      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
169      *
170      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
171      */
172     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
176 pragma solidity ^0.8.0;
177 
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
181  * @dev See https://eips.ethereum.org/EIPS/eip-721
182  */
183 interface IERC721Metadata is IERC721 {
184 
185     /**
186      * @dev Returns the token collection name.
187      */
188     function name() external view returns (string memory);
189 
190     /**
191      * @dev Returns the token collection symbol.
192      */
193     function symbol() external view returns (string memory);
194 
195     /**
196      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
197      */
198     function tokenURI(uint256 tokenId) external view returns (string memory);
199 }
200 
201 // File: @openzeppelin/contracts/utils/Address.sol
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Collection of functions related to the address type
206  */
207 library Address {
208     /**
209      * @dev Returns true if `account` is a contract.
210      *
211      * [IMPORTANT]
212      * ====
213      * It is unsafe to assume that an address for which this function returns
214      * false is an externally-owned account (EOA) and not a contract.
215      *
216      * Among others, `isContract` will return false for the following
217      * types of addresses:
218      *
219      *  - an externally-owned account
220      *  - a contract in construction
221      *  - an address where a contract will be created
222      *  - an address where a contract lived, but was destroyed
223      * ====
224      */
225     function isContract(address account) internal view returns (bool) {
226         // This method relies on extcodesize, which returns 0 for contracts in
227         // construction, since the code is only stored at the end of the
228         // constructor execution.
229 
230         uint256 size;
231         // solhint-disable-next-line no-inline-assembly
232         assembly { size := extcodesize(account) }
233         return size > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
256         (bool success, ) = recipient.call{ value: amount }("");
257         require(success, "Address: unable to send value, recipient may have reverted");
258     }
259 
260     /**
261      * @dev Performs a Solidity function call using a low level `call`. A
262      * plain`call` is an unsafe replacement for a function call: use this
263      * function instead.
264      *
265      * If `target` reverts with a revert reason, it is bubbled up by this
266      * function (like regular Solidity function calls).
267      *
268      * Returns the raw returned data. To convert to the expected return value,
269      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
270      *
271      * Requirements:
272      *
273      * - `target` must be a contract.
274      * - calling `target` with `data` must not revert.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
279       return functionCall(target, data, "Address: low-level call failed");
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
284      * `errorMessage` as a fallback revert reason when `target` reverts.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
289         return functionCallWithValue(target, data, 0, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but also transferring `value` wei to `target`.
295      *
296      * Requirements:
297      *
298      * - the calling contract must have an ETH balance of at least `value`.
299      * - the called Solidity function must be `payable`.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
309      * with `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
314         require(address(this).balance >= value, "Address: insufficient balance for call");
315         require(isContract(target), "Address: call to non-contract");
316 
317         // solhint-disable-next-line avoid-low-level-calls
318         (bool success, bytes memory returndata) = target.call{ value: value }(data);
319         return _verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
329         return functionStaticCall(target, data, "Address: low-level static call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         // solhint-disable-next-line avoid-low-level-calls
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return _verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         require(isContract(target), "Address: delegate call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.delegatecall(data);
367         return _verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 // File: @openzeppelin/contracts/utils/Context.sol
391 pragma solidity ^0.8.0;
392 
393 /*
394  * @dev Provides information about the current execution context, including the
395  * sender of the transaction and its data. While these are generally available
396  * via msg.sender and msg.data, they should not be accessed in such a direct
397  * manner, since when dealing with meta-transactions the account sending and
398  * paying for execution may not be the actual sender (as far as an application
399  * is concerned).
400  *
401  * This contract is only required for intermediate, library-like contracts.
402  */
403 abstract contract Context {
404     function _msgSender() internal view virtual returns (address) {
405         return msg.sender;
406     }
407 
408     function _msgData() internal view virtual returns (bytes calldata) {
409         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
410         return msg.data;
411     }
412 }
413 
414 // File: @openzeppelin/contracts/utils/Strings.sol
415 
416 
417 
418 pragma solidity ^0.8.0;
419 
420 /**
421  * @dev String operations.
422  */
423 library Strings {
424     bytes16 private constant alphabet = "0123456789abcdef";
425 
426     /**
427      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
428      */
429     function toString(uint256 value) internal pure returns (string memory) {
430         // Inspired by OraclizeAPI's implementation - MIT licence
431         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
432 
433         if (value == 0) {
434             return "0";
435         }
436         uint256 temp = value;
437         uint256 digits;
438         while (temp != 0) {
439             digits++;
440             temp /= 10;
441         }
442         bytes memory buffer = new bytes(digits);
443         while (value != 0) {
444             digits -= 1;
445             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
446             value /= 10;
447         }
448         return string(buffer);
449     }
450 
451     /**
452      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
453      */
454     function toHexString(uint256 value) internal pure returns (string memory) {
455         if (value == 0) {
456             return "0x00";
457         }
458         uint256 temp = value;
459         uint256 length = 0;
460         while (temp != 0) {
461             length++;
462             temp >>= 8;
463         }
464         return toHexString(value, length);
465     }
466 
467     /**
468      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
469      */
470     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
471         bytes memory buffer = new bytes(2 * length + 2);
472         buffer[0] = "0";
473         buffer[1] = "x";
474         for (uint256 i = 2 * length + 1; i > 1; --i) {
475             buffer[i] = alphabet[value & 0xf];
476             value >>= 4;
477         }
478         require(value == 0, "Strings: hex length insufficient");
479         return string(buffer);
480     }
481 
482 }
483 
484 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev Implementation of the {IERC165} interface.
490  *
491  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
492  * for the additional interface id that will be supported. For example:
493  *
494  * ```solidity
495  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
497  * }
498  * ```
499  *
500  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
501  */
502 abstract contract ERC165 is IERC165 {
503     /**
504      * @dev See {IERC165-supportsInterface}.
505      */
506     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507         return interfaceId == type(IERC165).interfaceId;
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
516  * the Metadata extension, but not including the Enumerable extension, which is available separately as
517  * {ERC721Enumerable}.
518  */
519 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
520     using Address for address;
521     using Strings for uint256;
522 
523     // Token name
524     string private _name;
525 
526     // Token symbol
527     string private _symbol;
528 
529     // Mapping from token ID to owner address
530     mapping (uint256 => address) private _owners;
531 
532     // Mapping owner address to token count
533     mapping (address => uint256) private _balances;
534 
535     // Mapping from token ID to approved address
536     mapping (uint256 => address) private _tokenApprovals;
537 
538     // Mapping from owner to operator approvals
539     mapping (address => mapping (address => bool)) private _operatorApprovals;
540 
541     /**
542      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
543      */
544     constructor (string memory name_, string memory symbol_) {
545         _name = name_;
546         _symbol = symbol_;
547     }
548 
549     /**
550      * @dev See {IERC165-supportsInterface}.
551      */
552     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
553         return interfaceId == type(IERC721).interfaceId
554             || interfaceId == type(IERC721Metadata).interfaceId
555             || super.supportsInterface(interfaceId);
556     }
557 
558     /**
559      * @dev See {IERC721-balanceOf}.
560      */
561     function balanceOf(address owner) public view virtual override returns (uint256) {
562         require(owner != address(0), "ERC721: balance query for the zero address");
563         return _balances[owner];
564     }
565 
566     /**
567      * @dev See {IERC721-ownerOf}.
568      */
569     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
570         address owner = _owners[tokenId];
571         require(owner != address(0), "ERC721: owner query for nonexistent token");
572         return owner;
573     }
574 
575     /**
576      * @dev See {IERC721Metadata-name}.
577      */
578     function name() public view virtual override returns (string memory) {
579         return _name;
580     }
581 
582     /**
583      * @dev See {IERC721Metadata-symbol}.
584      */
585     function symbol() public view virtual override returns (string memory) {
586         return _symbol;
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-tokenURI}.
591      */
592     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
593         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
594 
595         string memory baseURI = _baseURI();
596         return bytes(baseURI).length > 0
597             ? string(abi.encodePacked(baseURI, tokenId.toString()))
598             : '';
599     }
600 
601     /**
602      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
603      * in child contracts.
604      */
605     function _baseURI() internal view virtual returns (string memory) {
606         return "";
607     }
608 
609     /**
610      * @dev See {IERC721-approve}.
611      */
612     function approve(address to, uint256 tokenId) public virtual override {
613         address owner = ERC721.ownerOf(tokenId);
614         require(to != owner, "ERC721: approval to current owner");
615 
616         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
617             "ERC721: approve caller is not owner nor approved for all"
618         );
619 
620         _approve(to, tokenId);
621     }
622 
623     /**
624      * @dev See {IERC721-getApproved}.
625      */
626     function getApproved(uint256 tokenId) public view virtual override returns (address) {
627         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
628 
629         return _tokenApprovals[tokenId];
630     }
631 
632     /**
633      * @dev See {IERC721-setApprovalForAll}.
634      */
635     function setApprovalForAll(address operator, bool approved) public virtual override {
636         require(operator != _msgSender(), "ERC721: approve to caller");
637 
638         _operatorApprovals[_msgSender()][operator] = approved;
639         emit ApprovalForAll(_msgSender(), operator, approved);
640     }
641 
642     /**
643      * @dev See {IERC721-isApprovedForAll}.
644      */
645     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
646         return _operatorApprovals[owner][operator];
647     }
648 
649     /**
650      * @dev See {IERC721-transferFrom}.
651      */
652     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
653         //solhint-disable-next-line max-line-length
654         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
655 
656         _transfer(from, to, tokenId);
657     }
658 
659     /**
660      * @dev See {IERC721-safeTransferFrom}.
661      */
662     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
663         safeTransferFrom(from, to, tokenId, "");
664     }
665 
666     /**
667      * @dev See {IERC721-safeTransferFrom}.
668      */
669     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
670         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
671         _safeTransfer(from, to, tokenId, _data);
672     }
673 
674     /**
675      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
676      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
677      *
678      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
679      *
680      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
681      * implement alternative mechanisms to perform token transfer, such as signature-based.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must exist and be owned by `from`.
688      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
689      *
690      * Emits a {Transfer} event.
691      */
692     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
693         _transfer(from, to, tokenId);
694         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
695     }
696 
697     /**
698      * @dev Returns whether `tokenId` exists.
699      *
700      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
701      *
702      * Tokens start existing when they are minted (`_mint`),
703      * and stop existing when they are burned (`_burn`).
704      */
705     function _exists(uint256 tokenId) internal view virtual returns (bool) {
706         return _owners[tokenId] != address(0);
707     }
708 
709     /**
710      * @dev Returns whether `spender` is allowed to manage `tokenId`.
711      *
712      * Requirements:
713      *
714      * - `tokenId` must exist.
715      */
716     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
717         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
718         address owner = ERC721.ownerOf(tokenId);
719         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
720     }
721 
722     /**
723      * @dev Safely mints `tokenId` and transfers it to `to`.
724      *
725      * Requirements:
726      *
727      * - `tokenId` must not exist.
728      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
729      *
730      * Emits a {Transfer} event.
731      */
732     function _safeMint(address to, uint256 tokenId) internal virtual {
733         _safeMint(to, tokenId, "");
734     }
735 
736     /**
737      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
738      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
739      */
740     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
741         _mint(to, tokenId);
742         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
743     }
744 
745     /**
746      * @dev Mints `tokenId` and transfers it to `to`.
747      *
748      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
749      *
750      * Requirements:
751      *
752      * - `tokenId` must not exist.
753      * - `to` cannot be the zero address.
754      *
755      * Emits a {Transfer} event.
756      */
757     function _mint(address to, uint256 tokenId) internal virtual {
758         require(to != address(0), "ERC721: mint to the zero address");
759         require(!_exists(tokenId), "ERC721: token already minted");
760 
761         _beforeTokenTransfer(address(0), to, tokenId);
762 
763         _balances[to] += 1;
764         _owners[tokenId] = to;
765 
766         emit Transfer(address(0), to, tokenId);
767     }
768 
769     /**
770      * @dev Destroys `tokenId`.
771      * The approval is cleared when the token is burned.
772      *
773      * Requirements:
774      *
775      * - `tokenId` must exist.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _burn(uint256 tokenId) internal virtual {
780         address owner = ERC721.ownerOf(tokenId);
781 
782         _beforeTokenTransfer(owner, address(0), tokenId);
783 
784         // Clear approvals
785         _approve(address(0), tokenId);
786 
787         _balances[owner] -= 1;
788         delete _owners[tokenId];
789 
790         emit Transfer(owner, address(0), tokenId);
791     }
792 
793     /**
794      * @dev Transfers `tokenId` from `from` to `to`.
795      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
796      *
797      * Requirements:
798      *
799      * - `to` cannot be the zero address.
800      * - `tokenId` token must be owned by `from`.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _transfer(address from, address to, uint256 tokenId) internal virtual {
805         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
806         require(to != address(0), "ERC721: transfer to the zero address");
807 
808         _beforeTokenTransfer(from, to, tokenId);
809 
810         // Clear approvals from the previous owner
811         _approve(address(0), tokenId);
812 
813         _balances[from] -= 1;
814         _balances[to] += 1;
815         _owners[tokenId] = to;
816 
817         emit Transfer(from, to, tokenId);
818     }
819 
820     /**
821      * @dev Approve `to` to operate on `tokenId`
822      *
823      * Emits a {Approval} event.
824      */
825     function _approve(address to, uint256 tokenId) internal virtual {
826         _tokenApprovals[tokenId] = to;
827         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
828     }
829 
830     /**
831      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
832      * The call is not executed if the target address is not a contract.
833      *
834      * @param from address representing the previous owner of the given token ID
835      * @param to target address that will receive the tokens
836      * @param tokenId uint256 ID of the token to be transferred
837      * @param _data bytes optional data to send along with the call
838      * @return bool whether the call correctly returned the expected magic value
839      */
840     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
841         private returns (bool)
842     {
843         if (to.isContract()) {
844             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
845                 return retval == IERC721Receiver(to).onERC721Received.selector;
846             } catch (bytes memory reason) {
847                 if (reason.length == 0) {
848                     revert("ERC721: transfer to non ERC721Receiver implementer");
849                 } else {
850                     // solhint-disable-next-line no-inline-assembly
851                     assembly {
852                         revert(add(32, reason), mload(reason))
853                     }
854                 }
855             }
856         } else {
857             return true;
858         }
859     }
860 
861     /**
862      * @dev Hook that is called before any token transfer. This includes minting
863      * and burning.
864      *
865      * Calling conditions:
866      *
867      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
868      * transferred to `to`.
869      * - When `from` is zero, `tokenId` will be minted for `to`.
870      * - When `to` is zero, ``from``'s `tokenId` will be burned.
871      * - `from` cannot be the zero address.
872      * - `to` cannot be the zero address.
873      *
874      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
875      */
876     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
877 }
878 
879 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
880 pragma solidity ^0.8.0;
881 
882 /**
883  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
884  * @dev See https://eips.ethereum.org/EIPS/eip-721
885  */
886 interface IERC721Enumerable is IERC721 {
887 
888     /**
889      * @dev Returns the total amount of tokens stored by the contract.
890      */
891     function totalSupply() external view returns (uint256);
892 
893     /**
894      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
895      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
896      */
897     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
898 
899     /**
900      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
901      * Use along with {totalSupply} to enumerate all tokens.
902      */
903     function tokenByIndex(uint256 index) external view returns (uint256);
904 }
905 
906 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
907 pragma solidity ^0.8.0;
908 
909 /**
910  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
911  * enumerability of all the token ids in the contract as well as all token ids owned by each
912  * account.
913  */
914 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
915     // Mapping from owner to list of owned token IDs
916     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
917 
918     // Mapping from token ID to index of the owner tokens list
919     mapping(uint256 => uint256) private _ownedTokensIndex;
920 
921     // Array with all token ids, used for enumeration
922     uint256[] private _allTokens;
923 
924     // Mapping from token id to position in the allTokens array
925     mapping(uint256 => uint256) private _allTokensIndex;
926 
927     /**
928      * @dev See {IERC165-supportsInterface}.
929      */
930     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
931         return interfaceId == type(IERC721Enumerable).interfaceId
932             || super.supportsInterface(interfaceId);
933     }
934 
935     /**
936      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
937      */
938     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
939         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
940         return _ownedTokens[owner][index];
941     }
942 
943     /**
944      * @dev See {IERC721Enumerable-totalSupply}.
945      */
946     function totalSupply() public view virtual override returns (uint256) {
947         return _allTokens.length;
948     }
949 
950     /**
951      * @dev See {IERC721Enumerable-tokenByIndex}.
952      */
953     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
954         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
955         return _allTokens[index];
956     }
957 
958     /**
959      * @dev Hook that is called before any token transfer. This includes minting
960      * and burning.
961      *
962      * Calling conditions:
963      *
964      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
965      * transferred to `to`.
966      * - When `from` is zero, `tokenId` will be minted for `to`.
967      * - When `to` is zero, ``from``'s `tokenId` will be burned.
968      * - `from` cannot be the zero address.
969      * - `to` cannot be the zero address.
970      *
971      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
972      */
973     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
974         super._beforeTokenTransfer(from, to, tokenId);
975 
976         if (from == address(0)) {
977             _addTokenToAllTokensEnumeration(tokenId);
978         } else if (from != to) {
979             _removeTokenFromOwnerEnumeration(from, tokenId);
980         }
981         if (to == address(0)) {
982             _removeTokenFromAllTokensEnumeration(tokenId);
983         } else if (to != from) {
984             _addTokenToOwnerEnumeration(to, tokenId);
985         }
986     }
987 
988     /**
989      * @dev Private function to add a token to this extension's ownership-tracking data structures.
990      * @param to address representing the new owner of the given token ID
991      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
992      */
993     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
994         uint256 length = ERC721.balanceOf(to);
995         _ownedTokens[to][length] = tokenId;
996         _ownedTokensIndex[tokenId] = length;
997     }
998 
999     /**
1000      * @dev Private function to add a token to this extension's token tracking data structures.
1001      * @param tokenId uint256 ID of the token to be added to the tokens list
1002      */
1003     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1004         _allTokensIndex[tokenId] = _allTokens.length;
1005         _allTokens.push(tokenId);
1006     }
1007 
1008     /**
1009      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1010      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1011      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1012      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1013      * @param from address representing the previous owner of the given token ID
1014      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1015      */
1016     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1017         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1018         // then delete the last slot (swap and pop).
1019 
1020         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1021         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1022 
1023         // When the token to delete is the last token, the swap operation is unnecessary
1024         if (tokenIndex != lastTokenIndex) {
1025             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1026 
1027             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1028             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1029         }
1030 
1031         // This also deletes the contents at the last position of the array
1032         delete _ownedTokensIndex[tokenId];
1033         delete _ownedTokens[from][lastTokenIndex];
1034     }
1035 
1036     /**
1037      * @dev Private function to remove a token from this extension's token tracking data structures.
1038      * This has O(1) time complexity, but alters the order of the _allTokens array.
1039      * @param tokenId uint256 ID of the token to be removed from the tokens list
1040      */
1041     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1042         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1043         // then delete the last slot (swap and pop).
1044 
1045         uint256 lastTokenIndex = _allTokens.length - 1;
1046         uint256 tokenIndex = _allTokensIndex[tokenId];
1047 
1048         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1049         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1050         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1051         uint256 lastTokenId = _allTokens[lastTokenIndex];
1052 
1053         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1054         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1055 
1056         // This also deletes the contents at the last position of the array
1057         delete _allTokensIndex[tokenId];
1058         _allTokens.pop();
1059     }
1060 }
1061 
1062 // File: @openzeppelin/contracts/access/Ownable.sol
1063 pragma solidity ^0.8.0;
1064 
1065 /**
1066  * @dev Contract module which provides a basic access control mechanism, where
1067  * there is an account (an owner) that can be granted exclusive access to
1068  * specific functions.
1069  *
1070  * By default, the owner account will be the one that deploys the contract. This
1071  * can later be changed with {transferOwnership}.
1072  *
1073  * This module is used through inheritance. It will make available the modifier
1074  * `onlyOwner`, which can be applied to your functions to restrict their use to
1075  * the owner.
1076  */
1077 abstract contract Ownable is Context {
1078     address private _owner;
1079 
1080     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1081 
1082     /**
1083      * @dev Initializes the contract setting the deployer as the initial owner.
1084      */
1085     constructor () {
1086         address msgSender = _msgSender();
1087         _owner = msgSender;
1088         emit OwnershipTransferred(address(0), msgSender);
1089     }
1090 
1091     /**
1092      * @dev Returns the address of the current owner.
1093      */
1094     function owner() public view virtual returns (address) {
1095         return _owner;
1096     }
1097 
1098     /**
1099      * @dev Throws if called by any account other than the owner.
1100      */
1101     modifier onlyOwner() {
1102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1103         _;
1104     }
1105 
1106     /**
1107      * @dev Leaves the contract without owner. It will not be possible to call
1108      * `onlyOwner` functions anymore. Can only be called by the current owner.
1109      *
1110      * NOTE: Renouncing ownership will leave the contract without an owner,
1111      * thereby removing any functionality that is only available to the owner.
1112      */
1113     function renounceOwnership() public virtual onlyOwner {
1114         emit OwnershipTransferred(_owner, address(0));
1115         _owner = address(0);
1116     }
1117 
1118     /**
1119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1120      * Can only be called by the current owner.
1121      */
1122     function transferOwnership(address newOwner) public virtual onlyOwner {
1123         require(newOwner != address(0), "Ownable: new owner is the zero address");
1124         emit OwnershipTransferred(_owner, newOwner);
1125         _owner = newOwner;
1126     }
1127 }
1128 
1129 // File: contracts/Circleorzo.sol
1130 pragma solidity ^0.8.0;
1131 
1132 contract Circleorzo is ERC721Enumerable, Ownable {
1133     uint256 public constant MAX_NFT_SUPPLY = 4444;
1134     uint public constant MAX_PURCHASABLE = 20;
1135     uint256 public NFT_PRICE = 44000000000000000; // 0.044 ETH
1136     bool public saleStarted = false;
1137 
1138     constructor() ERC721("Circleorzo", "CIRCLE") {
1139     }
1140 
1141     function _baseURI() internal view virtual override returns (string memory) {
1142         return "https://api.circleorzo.com/";
1143     }
1144 
1145     function getTokenURI(uint256 tokenId) public view returns (string memory) {
1146         return tokenURI(tokenId);
1147     }
1148 
1149    function mint(uint256 amountToMint) public payable {
1150         require(saleStarted == true, "This sale has not started.");
1151         require(totalSupply() < MAX_NFT_SUPPLY, "All NFTs have been minted.");
1152         require(amountToMint > 0, "You must mint at least one circleorzo.");
1153         require(amountToMint <= MAX_PURCHASABLE, "You cannot mint more than 20 circleorzos.");
1154         require(totalSupply() + amountToMint <= MAX_NFT_SUPPLY, "The amount of circleorzos you are trying to mint exceeds the MAX_NFT_SUPPLY.");
1155         
1156         require(NFT_PRICE * amountToMint == msg.value, "Incorrect Ether value.");
1157 
1158         for (uint256 i = 0; i < amountToMint; i++) {
1159             uint256 mintIndex = totalSupply();
1160             _safeMint(msg.sender, mintIndex);
1161         }
1162    }
1163 
1164     function startSale() public onlyOwner {
1165         saleStarted = true;
1166     }
1167 
1168     function pauseSale() public onlyOwner {
1169         saleStarted = false;
1170     }
1171 
1172     function withdraw() public payable onlyOwner {
1173         require(payable(msg.sender).send(address(this).balance));
1174     }
1175 }