1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.6;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 
25 
26 /**
27  * @dev Implementation of the {IERC165} interface.
28  *
29  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
30  * for the additional interface id that will be supported. For example:
31  *
32  * ```solidity
33  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
34  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
35  * ```
36  *
37  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
38  */
39 abstract contract ERC165 is IERC165 {
40     /**
41      * @dev See {IERC165-supportsInterface}.
42      */
43     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
44         return interfaceId == type(IERC165).interfaceId;
45     }
46 }
47 
48 
49 /**
50  * @dev Required interface of an ERC721 compliant contract.
51  */
52 interface IERC721 is IERC165 {
53     /**
54      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
55      */
56     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
57 
58     /**
59      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
60      */
61     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
62 
63     /**
64      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
65      */
66     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
67 
68     /**
69      * @dev Returns the number of tokens in ``owner``'s account.
70      */
71     function balanceOf(address owner) external view returns (uint256 balance);
72 
73     /**
74      * @dev Returns the owner of the `tokenId` token.
75      *
76      * Requirements:
77      *
78      * - `tokenId` must exist.
79      */
80     function ownerOf(uint256 tokenId) external view returns (address owner);
81 
82     /**
83      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
84      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
85      *
86      * Requirements:
87      *
88      * - `from` cannot be the zero address.
89      * - `to` cannot be the zero address.
90      * - `tokenId` token must exist and be owned by `from`.
91      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
92      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
93      *
94      * Emits a {Transfer} event.
95      */
96     function safeTransferFrom(address from, address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Transfers `tokenId` token from `from` to `to`.
100      *
101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
102      *
103      * Requirements:
104      *
105      * - `from` cannot be the zero address.
106      * - `to` cannot be the zero address.
107      * - `tokenId` token must be owned by `from`.
108      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transferFrom(address from, address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
116      * The approval is cleared when the token is transferred.
117      *
118      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
119      *
120      * Requirements:
121      *
122      * - The caller must own the token or be an approved operator.
123      * - `tokenId` must exist.
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address to, uint256 tokenId) external;
128 
129     /**
130      * @dev Returns the account approved for `tokenId` token.
131      *
132      * Requirements:
133      *
134      * - `tokenId` must exist.
135      */
136     function getApproved(uint256 tokenId) external view returns (address operator);
137 
138     /**
139      * @dev Approve or remove `operator` as an operator for the caller.
140      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
141      *
142      * Requirements:
143      *
144      * - The `operator` cannot be the caller.
145      *
146      * Emits an {ApprovalForAll} event.
147      */
148     function setApprovalForAll(address operator, bool _approved) external;
149 
150     /**
151      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
152      *
153      * See {setApprovalForAll}
154      */
155     function isApprovedForAll(address owner, address operator) external view returns (bool);
156 
157     /**
158       * @dev Safely transfers `tokenId` token from `from` to `to`.
159       *
160       * Requirements:
161       *
162       * - `from` cannot be the zero address.
163       * - `to` cannot be the zero address.
164       * - `tokenId` token must exist and be owned by `from`.
165       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
166       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167       *
168       * Emits a {Transfer} event.
169       */
170     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
171 }
172 
173 /**
174  * @title ERC721 token receiver interface
175  * @dev Interface for any contract that wants to support safeTransfers
176  * from ERC721 asset contracts.
177  */
178 interface IERC721Receiver {
179     /**
180      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
181      * by `operator` from `from`, this function is called.
182      *
183      * It must return its Solidity selector to confirm the token transfer.
184      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
185      *
186      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
187      */
188     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
189 }
190 
191 
192 /**
193  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
194  * @dev See https://eips.ethereum.org/EIPS/eip-721
195  */
196 interface IERC721Metadata is IERC721 {
197 
198     /**
199      * @dev Returns the token collection name.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the token collection symbol.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
210      */
211     function tokenURI(uint256 tokenId) external view returns (string memory);
212 }
213 
214 
215 /**
216  * @dev Collection of functions related to the address type
217  */
218 library Address {
219     /**
220      * @dev Returns true if `account` is a contract.
221      *
222      * [IMPORTANT]
223      * ====
224      * It is unsafe to assume that an address for which this function returns
225      * false is an externally-owned account (EOA) and not a contract.
226      *
227      * Among others, `isContract` will return false for the following
228      * types of addresses:
229      *
230      *  - an externally-owned account
231      *  - a contract in construction
232      *  - an address where a contract will be created
233      *  - an address where a contract lived, but was destroyed
234      * ====
235      */
236     function isContract(address account) internal view returns (bool) {
237         // This method relies on extcodesize, which returns 0 for contracts in
238         // construction, since the code is only stored at the end of the
239         // constructor execution.
240 
241         uint256 size;
242         // solhint-disable-next-line no-inline-assembly
243         assembly { size := extcodesize(account) }
244         return size > 0;
245     }
246 
247     /**
248      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
249      * `recipient`, forwarding all available gas and reverting on errors.
250      *
251      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
252      * of certain opcodes, possibly making contracts go over the 2300 gas limit
253      * imposed by `transfer`, making them unable to receive funds via
254      * `transfer`. {sendValue} removes this limitation.
255      *
256      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
257      *
258      * IMPORTANT: because control is transferred to `recipient`, care must be
259      * taken to not create reentrancy vulnerabilities. Consider using
260      * {ReentrancyGuard} or the
261      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
262      */
263     function sendValue(address payable recipient, uint256 amount) internal {
264         require(address(this).balance >= amount, "Address: insufficient balance");
265 
266         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
267         (bool success, ) = recipient.call{ value: amount }("");
268         require(success, "Address: unable to send value, recipient may have reverted");
269     }
270 
271     /**
272      * @dev Performs a Solidity function call using a low level `call`. A
273      * plain`call` is an unsafe replacement for a function call: use this
274      * function instead.
275      *
276      * If `target` reverts with a revert reason, it is bubbled up by this
277      * function (like regular Solidity function calls).
278      *
279      * Returns the raw returned data. To convert to the expected return value,
280      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
281      *
282      * Requirements:
283      *
284      * - `target` must be a contract.
285      * - calling `target` with `data` must not revert.
286      *
287      * _Available since v3.1._
288      */
289     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
290       return functionCall(target, data, "Address: low-level call failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
295      * `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, 0, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but also transferring `value` wei to `target`.
306      *
307      * Requirements:
308      *
309      * - the calling contract must have an ETH balance of at least `value`.
310      * - the called Solidity function must be `payable`.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
315         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
320      * with `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
325         require(address(this).balance >= value, "Address: insufficient balance for call");
326         require(isContract(target), "Address: call to non-contract");
327 
328         // solhint-disable-next-line avoid-low-level-calls
329         (bool success, bytes memory returndata) = target.call{ value: value }(data);
330         return _verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
350         require(isContract(target), "Address: static call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.staticcall(data);
354         return _verifyCallResult(success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a delegate call.
360      *
361      * _Available since v3.4._
362      */
363     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a delegate call.
370      *
371      * _Available since v3.4._
372      */
373     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
374         require(isContract(target), "Address: delegate call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.delegatecall(data);
378         return _verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 
402 /*
403  * @dev Provides information about the current execution context, including the
404  * sender of the transaction and its data. While these are generally available
405  * via msg.sender and msg.data, they should not be accessed in such a direct
406  * manner, since when dealing with meta-transactions the account sending and
407  * paying for execution may not be the actual sender (as far as an application
408  * is concerned).
409  *
410  * This contract is only required for intermediate, library-like contracts.
411  */
412 abstract contract Context {
413     function _msgSender() internal view virtual returns (address) {
414         return msg.sender;
415     }
416 
417     function _msgData() internal view virtual returns (bytes calldata) {
418         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
419         return msg.data;
420     }
421 }
422 
423 
424 /**
425  * @dev String operations.
426  */
427 library Strings {
428     bytes16 private constant alphabet = "0123456789abcdef";
429 
430     /**
431      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
432      */
433     function toString(uint256 value) internal pure returns (string memory) {
434         // Inspired by OraclizeAPI's implementation - MIT licence
435         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
436 
437         if (value == 0) {
438             return "0";
439         }
440         uint256 temp = value;
441         uint256 digits;
442         while (temp != 0) {
443             digits++;
444             temp /= 10;
445         }
446         bytes memory buffer = new bytes(digits);
447         while (value != 0) {
448             digits -= 1;
449             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
450             value /= 10;
451         }
452         return string(buffer);
453     }
454 
455     /**
456      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
457      */
458     function toHexString(uint256 value) internal pure returns (string memory) {
459         if (value == 0) {
460             return "0x00";
461         }
462         uint256 temp = value;
463         uint256 length = 0;
464         while (temp != 0) {
465             length++;
466             temp >>= 8;
467         }
468         return toHexString(value, length);
469     }
470 
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
473      */
474     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
475         bytes memory buffer = new bytes(2 * length + 2);
476         buffer[0] = "0";
477         buffer[1] = "x";
478         for (uint256 i = 2 * length + 1; i > 1; --i) {
479             buffer[i] = alphabet[value & 0xf];
480             value >>= 4;
481         }
482         require(value == 0, "Strings: hex length insufficient");
483         return string(buffer);
484     }
485 
486 }
487 
488 
489 /**
490  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
491  * the Metadata extension, but not including the Enumerable extension, which is available separately as
492  * {ERC721Enumerable}.
493  */
494 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
495     using Address for address;
496     using Strings for uint256;
497 
498     // Token name
499     string private _name;
500 
501     // Token symbol
502     string private _symbol;
503 
504     string internal _tokenURI;
505 
506 
507     // Mapping from token ID to owner address
508     mapping (uint256 => address) private _owners;
509 
510     // Mapping owner address to token count
511     mapping (address => uint256) private _balances;
512 
513     // Mapping from token ID to approved address
514     mapping (uint256 => address) private _tokenApprovals;
515 
516     // Mapping from owner to operator approvals
517     mapping (address => mapping (address => bool)) private _operatorApprovals;
518     
519 
520     /**
521      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
522      */
523     constructor (string memory name_, string memory symbol_) {
524         _name = name_;
525         _symbol = symbol_;
526     }
527 
528     /**
529      * @dev See {IERC165-supportsInterface}.
530      */
531     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
532         return interfaceId == type(IERC721).interfaceId
533             || interfaceId == type(IERC721Metadata).interfaceId
534             || super.supportsInterface(interfaceId);
535     }
536 
537     /**
538      * @dev See {IERC721-balanceOf}.
539      */
540     function balanceOf(address owner) public view virtual override returns (uint256) {
541         require(owner != address(0), "ERC721: balance query for the zero address");
542         return _balances[owner];
543     }
544 
545     /**
546      * @dev See {IERC721-ownerOf}.
547      */
548     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
549         address owner = _owners[tokenId];
550         require(owner != address(0), "ERC721: owner query for nonexistent token");
551         return owner;
552     }
553 
554     /**
555      * @dev See {IERC721Metadata-name}.
556      */
557     function name() public view virtual override returns (string memory) {
558         return _name;
559     }
560 
561     /**
562      * @dev See {IERC721Metadata-symbol}.
563      */
564     function symbol() public view virtual override returns (string memory) {
565         return _symbol;
566     }
567     
568     /// @notice It all points to base reality being a higher order of consciousness, take a deep dive into the work of Jacobo Grinberg.
569 
570     function _baseURI() internal view  returns (string memory) {
571         return _tokenURI;
572     }
573 
574     /**
575      * @dev See {IERC721Metadata-tokenURI}.
576      */
577     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
578         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
579 
580         string memory uri = _baseURI();
581         return uri;
582     }
583 
584    
585     /**
586      * @dev See {IERC721-approve}.
587      */
588     function approve(address to, uint256 tokenId) public virtual override {
589         address owner = ERC721.ownerOf(tokenId);
590         require(to != owner, "ERC721: approval to current owner");
591 
592         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
593             "ERC721: approve caller is not owner nor approved for all"
594         );
595 
596         _approve(to, tokenId);
597     }
598 
599     /**
600      * @dev See {IERC721-getApproved}.
601      */
602     function getApproved(uint256 tokenId) public view virtual override returns (address) {
603         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
604 
605         return _tokenApprovals[tokenId];
606     }
607 
608     /**
609      * @dev See {IERC721-setApprovalForAll}.
610      */
611     function setApprovalForAll(address operator, bool approved) public virtual override {
612         require(operator != _msgSender(), "ERC721: approve to caller");
613 
614         _operatorApprovals[_msgSender()][operator] = approved;
615         emit ApprovalForAll(_msgSender(), operator, approved);
616     }
617 
618     /**
619      * @dev See {IERC721-isApprovedForAll}.
620      */
621     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
622         return _operatorApprovals[owner][operator];
623     }
624 
625     /**
626      * @dev See {IERC721-transferFrom}.
627      */
628     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
629         //solhint-disable-next-line max-line-length
630         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
631 
632         _transfer(from, to, tokenId);
633     }
634 
635     /**
636      * @dev See {IERC721-safeTransferFrom}.
637      */
638     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
639         safeTransferFrom(from, to, tokenId, "");
640     }
641 
642     /**
643      * @dev See {IERC721-safeTransferFrom}.
644      */
645     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
646         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
647         _safeTransfer(from, to, tokenId, _data);
648     }
649 
650     /**
651      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
652      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
653      *
654      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
655      *
656      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
657      * implement alternative mechanisms to perform token transfer, such as signature-based.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665      *
666      * Emits a {Transfer} event.
667      */
668     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
669         _transfer(from, to, tokenId);
670         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
671     }
672 
673     /**
674      * @dev Returns whether `tokenId` exists.
675      *
676      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
677      *
678      * Tokens start existing when they are minted (`_mint`),
679      * and stop existing when they are burned (`_burn`).
680      */
681     function _exists(uint256 tokenId) internal view virtual returns (bool) {
682         return _owners[tokenId] != address(0);
683     }
684 
685     /**
686      * @dev Returns whether `spender` is allowed to manage `tokenId`.
687      *
688      * Requirements:
689      *
690      * - `tokenId` must exist.
691      */
692     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
693         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
694         address owner = ERC721.ownerOf(tokenId);
695         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
696     }
697 
698     /**
699      * @dev Safely mints `tokenId` and transfers it to `to`.
700      *
701      * Requirements:
702      *
703      * - `tokenId` must not exist.
704      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
705      *
706      * Emits a {Transfer} event.
707      */
708     function _safeMint(address to, uint256 tokenId) internal virtual {
709         _safeMint(to, tokenId, "");
710     }
711 
712     /**
713      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
714      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
715      */
716     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
717         _mint(to, tokenId);
718         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
719     }
720 
721     /**
722      * @dev Mints `tokenId` and transfers it to `to`.
723      *
724      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
725      *
726      * Requirements:
727      *
728      * - `tokenId` must not exist.
729      * - `to` cannot be the zero address.
730      *
731      * Emits a {Transfer} event.
732      */
733     function _mint(address to, uint256 tokenId) internal virtual {
734         require(to != address(0), "ERC721: mint to the zero address");
735         require(!_exists(tokenId), "ERC721: token already minted");
736 
737         _beforeTokenTransfer(address(0), to, tokenId);
738 
739         _balances[to] += 1;
740         _owners[tokenId] = to;
741 
742         emit Transfer(address(0), to, tokenId);
743     }
744 
745     /**
746      * @dev Destroys `tokenId`.
747      * The approval is cleared when the token is burned.
748      *
749      * Requirements:
750      *
751      * - `tokenId` must exist.
752      *
753      * Emits a {Transfer} event.
754      */
755     function _burn(uint256 tokenId) internal virtual {
756         address owner = ERC721.ownerOf(tokenId);
757 
758         _beforeTokenTransfer(owner, address(0), tokenId);
759 
760         // Clear approvals
761         _approve(address(0), tokenId);
762 
763         _balances[owner] -= 1;
764         delete _owners[tokenId];
765 
766         emit Transfer(owner, address(0), tokenId);
767     }
768 
769     /**
770      * @dev Transfers `tokenId` from `from` to `to`.
771      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
772      *
773      * Requirements:
774      *
775      * - `to` cannot be the zero address.
776      * - `tokenId` token must be owned by `from`.
777      *
778      * Emits a {Transfer} event.
779      */
780     function _transfer(address from, address to, uint256 tokenId) internal virtual {
781         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
782         require(to != address(0), "ERC721: transfer to the zero address");
783 
784         _beforeTokenTransfer(from, to, tokenId);
785 
786         // Clear approvals from the previous owner
787         _approve(address(0), tokenId);
788 
789         _balances[from] -= 1;
790         _balances[to] += 1;
791         _owners[tokenId] = to;
792 
793         emit Transfer(from, to, tokenId);
794     }
795 
796     /**
797      * @dev Approve `to` to operate on `tokenId`
798      *
799      * Emits a {Approval} event.
800      */
801     function _approve(address to, uint256 tokenId) internal virtual {
802         _tokenApprovals[tokenId] = to;
803         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
804     }
805 
806     /**
807      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
808      * The call is not executed if the target address is not a contract.
809      *
810      * @param from address representing the previous owner of the given token ID
811      * @param to target address that will receive the tokens
812      * @param tokenId uint256 ID of the token to be transferred
813      * @param _data bytes optional data to send along with the call
814      * @return bool whether the call correctly returned the expected magic value
815      */
816     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
817         private returns (bool)
818     {
819         if (to.isContract()) {
820             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
821                 return retval == IERC721Receiver(to).onERC721Received.selector;
822             } catch (bytes memory reason) {
823                 if (reason.length == 0) {
824                     revert("ERC721: transfer to non ERC721Receiver implementer");
825                 } else {
826                     // solhint-disable-next-line no-inline-assembly
827                     assembly {
828                         revert(add(32, reason), mload(reason))
829                     }
830                 }
831             }
832         } else {
833             return true;
834         }
835     }
836 
837     /**
838      * @dev Hook that is called before any token transfer. This includes minting
839      * and burning.
840      *
841      * Calling conditions:
842      *
843      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
844      * transferred to `to`.
845      * - When `from` is zero, `tokenId` will be minted for `to`.
846      * - When `to` is zero, ``from``'s `tokenId` will be burned.
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      *
850      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
851      */
852     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
853 }
854 
855 
856 contract Ownable is Context {
857     address private _owner;
858 
859     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
860 
861     /**
862      * @dev Initializes the contract setting the deployer as the initial owner.
863      */
864     constructor ()  {
865         address msgSender = _msgSender();
866         _owner = msgSender;
867         emit OwnershipTransferred(address(0), msgSender);
868     }
869 
870     /**
871      * @dev Returns the address of the current owner.
872      */
873     function owner() public view returns (address) {
874         return _owner;
875     }
876 
877     /**
878      * @dev Throws if called by any account other than the owner.
879      */
880     modifier onlyOwner() {
881         require(_owner == _msgSender(), "Ownable: caller is not the owner");
882         _;
883     }
884 
885     /**
886      * @dev Leaves the contract without owner. It will not be possible to call
887      * `onlyOwner` functions anymore. Can only be called by the current owner.
888      *
889      * NOTE: Renouncing ownership will leave the contract without an owner,
890      * thereby removing any functionality that is only available to the owner.
891      */
892     function renounceOwnership() public virtual onlyOwner {
893         emit OwnershipTransferred(_owner, address(0));
894         _owner = address(0);
895     }
896 
897     /**
898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
899      * Can only be called by the current owner.
900      */
901     function transferOwnership(address newOwner) public virtual onlyOwner {
902         require(newOwner != address(0), "Ownable: new owner is the zero address");
903         emit OwnershipTransferred(_owner, newOwner);
904         _owner = newOwner;
905     }
906 }
907 
908 
909 
910 /**
911  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
912  * @dev See https://eips.ethereum.org/EIPS/eip-721
913  */
914 interface IERC721Enumerable is IERC721 {
915     /**
916      * @dev Returns the total amount of tokens stored by the contract.
917      */
918     function totalSupply() external view returns (uint256);
919 
920     /**
921      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
922      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
923      */
924     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
925 
926     /**
927      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
928      * Use along with {totalSupply} to enumerate all tokens.
929      */
930     function tokenByIndex(uint256 index) external view returns (uint256);
931 }
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
955         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
956     }
957 
958     /**
959      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
960      */
961     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
962         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
963         return _ownedTokens[owner][index];
964     }
965 
966     /**
967      * @dev See {IERC721Enumerable-totalSupply}.
968      */
969     function totalSupply() public view virtual override returns (uint256) {
970         return _allTokens.length;
971     }
972 
973     /**
974      * @dev See {IERC721Enumerable-tokenByIndex}.
975      */
976     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
977         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
978         return _allTokens[index];
979     }
980 
981     /**
982      * @dev Hook that is called before any token transfer. This includes minting
983      * and burning.
984      *
985      * Calling conditions:
986      *
987      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
988      * transferred to `to`.
989      * - When `from` is zero, `tokenId` will be minted for `to`.
990      * - When `to` is zero, ``from``'s `tokenId` will be burned.
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      *
994      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
995      */
996     function _beforeTokenTransfer(
997         address from,
998         address to,
999         uint256 tokenId
1000     ) internal virtual override {
1001         super._beforeTokenTransfer(from, to, tokenId);
1002 
1003         if (from == address(0)) {
1004             _addTokenToAllTokensEnumeration(tokenId);
1005         } else if (from != to) {
1006             _removeTokenFromOwnerEnumeration(from, tokenId);
1007         }
1008         if (to == address(0)) {
1009             _removeTokenFromAllTokensEnumeration(tokenId);
1010         } else if (to != from) {
1011             _addTokenToOwnerEnumeration(to, tokenId);
1012         }
1013     }
1014 
1015     /**
1016      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1017      * @param to address representing the new owner of the given token ID
1018      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1019      */
1020     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1021         uint256 length = ERC721.balanceOf(to);
1022         _ownedTokens[to][length] = tokenId;
1023         _ownedTokensIndex[tokenId] = length;
1024     }
1025 
1026     /**
1027      * @dev Private function to add a token to this extension's token tracking data structures.
1028      * @param tokenId uint256 ID of the token to be added to the tokens list
1029      */
1030     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1031         _allTokensIndex[tokenId] = _allTokens.length;
1032         _allTokens.push(tokenId);
1033     }
1034 
1035     /**
1036      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1037      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1038      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1039      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1040      * @param from address representing the previous owner of the given token ID
1041      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1042      */
1043     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1044         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1045         // then delete the last slot (swap and pop).
1046 
1047         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1048         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1049 
1050         // When the token to delete is the last token, the swap operation is unnecessary
1051         if (tokenIndex != lastTokenIndex) {
1052             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1053 
1054             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1055             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1056         }
1057 
1058         // This also deletes the contents at the last position of the array
1059         delete _ownedTokensIndex[tokenId];
1060         delete _ownedTokens[from][lastTokenIndex];
1061     }
1062 
1063     /**
1064      * @dev Private function to remove a token from this extension's token tracking data structures.
1065      * This has O(1) time complexity, but alters the order of the _allTokens array.
1066      * @param tokenId uint256 ID of the token to be removed from the tokens list
1067      */
1068     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1069         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1070         // then delete the last slot (swap and pop).
1071 
1072         uint256 lastTokenIndex = _allTokens.length - 1;
1073         uint256 tokenIndex = _allTokensIndex[tokenId];
1074 
1075         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1076         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1077         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1078         uint256 lastTokenId = _allTokens[lastTokenIndex];
1079 
1080         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1081         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1082 
1083         // This also deletes the contents at the last position of the array
1084         delete _allTokensIndex[tokenId];
1085         _allTokens.pop();
1086     }
1087 }
1088 
1089 
1090 
1091 
1092 contract MembershipToken is ERC721Enumerable, Ownable() {
1093     
1094    
1095     address public dev1;
1096     address public dev2; 
1097     address public dev3;
1098     
1099     uint256 price;
1100     uint256 maxSupply;
1101     
1102     
1103     constructor(string memory _uri,address _dev1Add, address _dev2Add, address _dev3Add, uint256 _price,uint256 _max, address to, uint256 _count) ERC721("MembershipToken","NMS") {
1104         dev1 = _dev1Add; 
1105         dev2 = _dev2Add; 
1106         dev3 = _dev3Add;
1107         price = _price;
1108         _tokenURI = _uri;
1109         maxSupply = _max;
1110         for(uint256 i=0; i<_count; i++){
1111             _safeMint(to, totalSupply());
1112         }
1113         
1114     }
1115 
1116     function buyToken(address _address, uint256 _count) public payable {
1117         require(totalSupply() + _count <= maxSupply,"ERROR: Max Limit");
1118         require(msg.value >= calculatePrice(_count),"ERROR: price too low");
1119         require(_count <= 5, "ERROR: Exceeds 5");
1120         require(totalSupply() <= maxSupply,"ERROR: sale ended");
1121         
1122         for(uint256 i=0; i<_count; i++){
1123             _safeMint(_address,totalSupply());
1124         }
1125         payable(dev1).transfer(msg.value*80/100);
1126         payable(dev2).transfer(msg.value*15/100);
1127         payable(dev3).transfer(msg.value*5/100);
1128     }
1129     
1130     function calculatePrice(uint256 _count) public view returns(uint256){
1131         return _count*price;
1132     }
1133 }