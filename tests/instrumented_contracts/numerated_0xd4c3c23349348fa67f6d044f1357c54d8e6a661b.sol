1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 
29 /**
30  * @dev Required interface of an ERC721 compliant contract.
31  */
32 interface IERC721 is IERC165 {
33     /**
34      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
37     /**
38      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
39      */
40     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
41     /**
42      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
43      */
44     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
45     /**
46      * @dev Returns the number of tokens in ``owner``'s account.
47      */
48     function balanceOf(address owner) external view returns (uint256 balance);
49     /**
50      * @dev Returns the owner of the `tokenId` token.
51      *
52      * Requirements:
53      *
54      * - `tokenId` must exist.
55      */
56     function ownerOf(uint256 tokenId) external view returns (address owner);
57     /**
58      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
59      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
60      *
61      * Requirements:
62      *
63      * - `from` cannot be the zero address.
64      * - `to` cannot be the zero address.
65      * - `tokenId` token must exist and be owned by `from`.
66      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
67      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
68      *
69      * Emits a {Transfer} event.
70      */
71     function safeTransferFrom(
72         address from,
73         address to,
74         uint256 tokenId
75     ) external;
76     /**
77      * @dev Transfers `tokenId` token from `from` to `to`.
78      *
79      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must be owned by `from`.
86      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(
91         address from,
92         address to,
93         uint256 tokenId
94     ) external;
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
109     /**
110      * @dev Returns the account approved for `tokenId` token.
111      *
112      * Requirements:
113      *
114      * - `tokenId` must exist.
115      */
116     function getApproved(uint256 tokenId) external view returns (address operator);
117     /**
118      * @dev Approve or remove `operator` as an operator for the caller.
119      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
120      *
121      * Requirements:
122      *
123      * - The `operator` cannot be the caller.
124      *
125      * Emits an {ApprovalForAll} event.
126      */
127     function setApprovalForAll(address operator, bool _approved) external;
128     /**
129      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
130      *
131      * See {setApprovalForAll}
132      */
133     function isApprovedForAll(address owner, address operator) external view returns (bool);
134     /**
135      * @dev Safely transfers `tokenId` token from `from` to `to`.
136      *
137      * Requirements:
138      *
139      * - `from` cannot be the zero address.
140      * - `to` cannot be the zero address.
141      * - `tokenId` token must exist and be owned by `from`.
142      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
143      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
144      *
145      * Emits a {Transfer} event.
146      */
147     function safeTransferFrom(
148         address from,
149         address to,
150         uint256 tokenId,
151         bytes calldata data
152     ) external;
153 }
154 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
155 
156 /**
157  * @title ERC721 token receiver interface
158  * @dev Interface for any contract that wants to support safeTransfers
159  * from ERC721 asset contracts.
160  */
161 interface IERC721Receiver {
162     /**
163      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
164      * by `operator` from `from`, this function is called.
165      *
166      * It must return its Solidity selector to confirm the token transfer.
167      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
168      *
169      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
170      */
171     function onERC721Received(
172         address operator,
173         address from,
174         uint256 tokenId,
175         bytes calldata data
176     ) external returns (bytes4);
177 }
178 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
179 
180 /**
181  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
182  * @dev See https://eips.ethereum.org/EIPS/eip-721
183  */
184 interface IERC721Metadata is IERC721 {
185     /**
186      * @dev Returns the token collection name.
187      */
188     function name() external view returns (string memory);
189     /**
190      * @dev Returns the token collection symbol.
191      */
192     function symbol() external view returns (string memory);
193     /**
194      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
195      */
196     function tokenURI(uint256 tokenId) external view returns (string memory);
197 }
198 // File: @openzeppelin/contracts/utils/Address.sol
199 
200 /**
201  * @dev Collection of functions related to the address type
202  */
203 library Address {
204     /**
205      * @dev Returns true if `account` is a contract.
206      *
207      * [IMPORTANT]
208      * ====
209      * It is unsafe to assume that an address for which this function returns
210      * false is an externally-owned account (EOA) and not a contract.
211      *
212      * Among others, `isContract` will return false for the following
213      * types of addresses:
214      *
215      *  - an externally-owned account
216      *  - a contract in construction
217      *  - an address where a contract will be created
218      *  - an address where a contract lived, but was destroyed
219      * ====
220      */
221     function isContract(address account) internal view returns (bool) {
222         // This method relies on extcodesize, which returns 0 for contracts in
223         // construction, since the code is only stored at the end of the
224         // constructor execution.
225         uint256 size;
226         assembly {
227             size := extcodesize(account)
228         }
229         return size > 0;
230     }
231     /**
232      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
233      * `recipient`, forwarding all available gas and reverting on errors.
234      *
235      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
236      * of certain opcodes, possibly making contracts go over the 2300 gas limit
237      * imposed by `transfer`, making them unable to receive funds via
238      * `transfer`. {sendValue} removes this limitation.
239      *
240      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
241      *
242      * IMPORTANT: because control is transferred to `recipient`, care must be
243      * taken to not create reentrancy vulnerabilities. Consider using
244      * {ReentrancyGuard} or the
245      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(address(this).balance >= amount, "Address: insufficient balance");
249         (bool success, ) = recipient.call{value: amount}("");
250         require(success, "Address: unable to send value, recipient may have reverted");
251     }
252     /**
253      * @dev Performs a Solidity function call using a low level `call`. A
254      * plain `call` is an unsafe replacement for a function call: use this
255      * function instead.
256      *
257      * If `target` reverts with a revert reason, it is bubbled up by this
258      * function (like regular Solidity function calls).
259      *
260      * Returns the raw returned data. To convert to the expected return value,
261      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
262      *
263      * Requirements:
264      *
265      * - `target` must be a contract.
266      * - calling `target` with `data` must not revert.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionCall(target, data, "Address: low-level call failed");
272     }
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
275      * `errorMessage` as a fallback revert reason when `target` reverts.
276      *
277      * _Available since v3.1._
278      */
279     function functionCall(
280         address target,
281         bytes memory data,
282         string memory errorMessage
283     ) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, 0, errorMessage);
285     }
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
303     }
304     /**
305      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
306      * with `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(address(this).balance >= value, "Address: insufficient balance for call");
317         require(isContract(target), "Address: call to non-contract");
318         (bool success, bytes memory returndata) = target.call{value: value}(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but performing a static call.
324      *
325      * _Available since v3.3._
326      */
327     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
328         return functionStaticCall(target, data, "Address: low-level static call failed");
329     }
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a static call.
333      *
334      * _Available since v3.3._
335      */
336     function functionStaticCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal view returns (bytes memory) {
341         require(isContract(target), "Address: static call to non-contract");
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(isContract(target), "Address: delegate call to non-contract");
366         (bool success, bytes memory returndata) = target.delegatecall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369     /**
370      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
371      * revert reason using the provided one.
372      *
373      * _Available since v4.3._
374      */
375     function verifyCallResult(
376         bool success,
377         bytes memory returndata,
378         string memory errorMessage
379     ) internal pure returns (bytes memory) {
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 // File: @openzeppelin/contracts/utils/Context.sol
397 
398 /**
399  * @dev Provides information about the current execution context, including the
400  * sender of the transaction and its data. While these are generally available
401  * via msg.sender and msg.data, they should not be accessed in such a direct
402  * manner, since when dealing with meta-transactions the account sending and
403  * paying for execution may not be the actual sender (as far as an application
404  * is concerned).
405  *
406  * This contract is only required for intermediate, library-like contracts.
407  */
408 abstract contract Context {
409     function _msgSender() internal view virtual returns (address) {
410         return msg.sender;
411     }
412     function _msgData() internal view virtual returns (bytes calldata) {
413         return msg.data;
414     }
415 }
416 // File: @openzeppelin/contracts/utils/Strings.sol
417 
418 /**
419  * @dev String operations.
420  */
421 library Strings {
422     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
423     /**
424      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
425      */
426     function toString(uint256 value) internal pure returns (string memory) {
427         // Inspired by OraclizeAPI's implementation - MIT licence
428         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
429         if (value == 0) {
430             return "0";
431         }
432         uint256 temp = value;
433         uint256 digits;
434         while (temp != 0) {
435             digits++;
436             temp /= 10;
437         }
438         bytes memory buffer = new bytes(digits);
439         while (value != 0) {
440             digits -= 1;
441             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
442             value /= 10;
443         }
444         return string(buffer);
445     }
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
448      */
449     function toHexString(uint256 value) internal pure returns (string memory) {
450         if (value == 0) {
451             return "0x00";
452         }
453         uint256 temp = value;
454         uint256 length = 0;
455         while (temp != 0) {
456             length++;
457             temp >>= 8;
458         }
459         return toHexString(value, length);
460     }
461     /**
462      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
463      */
464     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
465         bytes memory buffer = new bytes(2 * length + 2);
466         buffer[0] = "0";
467         buffer[1] = "x";
468         for (uint256 i = 2 * length + 1; i > 1; --i) {
469             buffer[i] = _HEX_SYMBOLS[value & 0xf];
470             value >>= 4;
471         }
472         require(value == 0, "Strings: hex length insufficient");
473         return string(buffer);
474     }
475 }
476 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
477 
478 /**
479  * @dev Implementation of the {IERC165} interface.
480  *
481  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
482  * for the additional interface id that will be supported. For example:
483  *
484  * ```solidity
485  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
486  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
487  * }
488  * ```
489  *
490  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
491  */
492 abstract contract ERC165 is IERC165 {
493     /**
494      * @dev See {IERC165-supportsInterface}.
495      */
496     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497         return interfaceId == type(IERC165).interfaceId;
498     }
499 }
500 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
501 
502 /**
503  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
504  * the Metadata extension, but not including the Enumerable extension, which is available separately as
505  * {ERC721Enumerable}.
506  */
507 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
508     using Address for address;
509     using Strings for uint256;
510     // Token name
511     string private _name;
512     // Token symbol
513     string private _symbol;
514     // Mapping from token ID to owner address
515     mapping(uint256 => address) private _owners;
516     // Mapping owner address to token count
517     mapping(address => uint256) private _balances;
518     // Mapping from token ID to approved address
519     mapping(uint256 => address) private _tokenApprovals;
520     // Mapping from owner to operator approvals
521     mapping(address => mapping(address => bool)) private _operatorApprovals;
522     /**
523      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
524      */
525     constructor(string memory name_, string memory symbol_) {
526         _name = name_;
527         _symbol = symbol_;
528     }
529     /**
530      * @dev See {IERC165-supportsInterface}.
531      */
532     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
533         return
534             interfaceId == type(IERC721).interfaceId ||
535             interfaceId == type(IERC721Metadata).interfaceId ||
536             super.supportsInterface(interfaceId);
537     }
538     /**
539      * @dev See {IERC721-balanceOf}.
540      */
541     function balanceOf(address owner) public view virtual override returns (uint256) {
542         require(owner != address(0), "ERC721: balance query for the zero address");
543         return _balances[owner];
544     }
545     /**
546      * @dev See {IERC721-ownerOf}.
547      */
548     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
549         address owner = _owners[tokenId];
550         require(owner != address(0), "ERC721: owner query for nonexistent token");
551         return owner;
552     }
553     /**
554      * @dev See {IERC721Metadata-name}.
555      */
556     function name() public view virtual override returns (string memory) {
557         return _name;
558     }
559     /**
560      * @dev See {IERC721Metadata-symbol}.
561      */
562     function symbol() public view virtual override returns (string memory) {
563         return _symbol;
564     }
565     /**
566      * @dev See {IERC721Metadata-tokenURI}.
567      */
568     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
569         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
570         string memory baseURI = _baseURI();
571         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
572     }
573     /**
574      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
575      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
576      * by default, can be overriden in child contracts.
577      */
578     function _baseURI() internal view virtual returns (string memory) {
579         return "";
580     }
581     /**
582      * @dev See {IERC721-approve}.
583      */
584     function approve(address to, uint256 tokenId) public virtual override {
585         address owner = ERC721.ownerOf(tokenId);
586         require(to != owner, "ERC721: approval to current owner");
587         require(
588             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
589             "ERC721: approve caller is not owner nor approved for all"
590         );
591         _approve(to, tokenId);
592     }
593     /**
594      * @dev See {IERC721-getApproved}.
595      */
596     function getApproved(uint256 tokenId) public view virtual override returns (address) {
597         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
598         return _tokenApprovals[tokenId];
599     }
600     /**
601      * @dev See {IERC721-setApprovalForAll}.
602      */
603     function setApprovalForAll(address operator, bool approved) public virtual override {
604         require(operator != _msgSender(), "ERC721: approve to caller");
605         _operatorApprovals[_msgSender()][operator] = approved;
606         emit ApprovalForAll(_msgSender(), operator, approved);
607     }
608     /**
609      * @dev See {IERC721-isApprovedForAll}.
610      */
611     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
612         return _operatorApprovals[owner][operator];
613     }
614     /**
615      * @dev See {IERC721-transferFrom}.
616      */
617     function transferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) public virtual override {
622         //solhint-disable-next-line max-line-length
623         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
624         _transfer(from, to, tokenId);
625     }
626     /**
627      * @dev See {IERC721-safeTransferFrom}.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) public virtual override {
634         safeTransferFrom(from, to, tokenId, "");
635     }
636     /**
637      * @dev See {IERC721-safeTransferFrom}.
638      */
639     function safeTransferFrom(
640         address from,
641         address to,
642         uint256 tokenId,
643         bytes memory _data
644     ) public virtual override {
645         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
646         _safeTransfer(from, to, tokenId, _data);
647     }
648     /**
649      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
650      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
651      *
652      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
653      *
654      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
655      * implement alternative mechanisms to perform token transfer, such as signature-based.
656      *
657      * Requirements:
658      *
659      * - `from` cannot be the zero address.
660      * - `to` cannot be the zero address.
661      * - `tokenId` token must exist and be owned by `from`.
662      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
663      *
664      * Emits a {Transfer} event.
665      */
666     function _safeTransfer(
667         address from,
668         address to,
669         uint256 tokenId,
670         bytes memory _data
671     ) internal virtual {
672         _transfer(from, to, tokenId);
673         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
674     }
675     /**
676      * @dev Returns whether `tokenId` exists.
677      *
678      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
679      *
680      * Tokens start existing when they are minted (`_mint`),
681      * and stop existing when they are burned (`_burn`).
682      */
683     function _exists(uint256 tokenId) internal view virtual returns (bool) {
684         return _owners[tokenId] != address(0);
685     }
686     /**
687      * @dev Returns whether `spender` is allowed to manage `tokenId`.
688      *
689      * Requirements:
690      *
691      * - `tokenId` must exist.
692      */
693     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
694         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
695         address owner = ERC721.ownerOf(tokenId);
696         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
697     }
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
711     /**
712      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
713      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
714      */
715     function _safeMint(
716         address to,
717         uint256 tokenId,
718         bytes memory _data
719     ) internal virtual {
720         _mint(to, tokenId);
721         require(
722             _checkOnERC721Received(address(0), to, tokenId, _data),
723             "ERC721: transfer to non ERC721Receiver implementer"
724         );
725     }
726     /**
727      * @dev Mints `tokenId` and transfers it to `to`.
728      *
729      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
730      *
731      * Requirements:
732      *
733      * - `tokenId` must not exist.
734      * - `to` cannot be the zero address.
735      *
736      * Emits a {Transfer} event.
737      */
738     function _mint(address to, uint256 tokenId) internal virtual {
739         require(to != address(0), "ERC721: mint to the zero address");
740         require(!_exists(tokenId), "ERC721: token already minted");
741         _beforeTokenTransfer(address(0), to, tokenId);
742         _balances[to] += 1;
743         _owners[tokenId] = to;
744         emit Transfer(address(0), to, tokenId);
745     }
746     /**
747      * @dev Destroys `tokenId`.
748      * The approval is cleared when the token is burned.
749      *
750      * Requirements:
751      *
752      * - `tokenId` must exist.
753      *
754      * Emits a {Transfer} event.
755      */
756     function _burn(uint256 tokenId) internal virtual {
757         address owner = ERC721.ownerOf(tokenId);
758         _beforeTokenTransfer(owner, address(0), tokenId);
759         // Clear approvals
760         _approve(address(0), tokenId);
761         _balances[owner] -= 1;
762         delete _owners[tokenId];
763         emit Transfer(owner, address(0), tokenId);
764     }
765     /**
766      * @dev Transfers `tokenId` from `from` to `to`.
767      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
768      *
769      * Requirements:
770      *
771      * - `to` cannot be the zero address.
772      * - `tokenId` token must be owned by `from`.
773      *
774      * Emits a {Transfer} event.
775      */
776     function _transfer(
777         address from,
778         address to,
779         uint256 tokenId
780     ) internal virtual {
781         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
782         require(to != address(0), "ERC721: transfer to the zero address");
783         _beforeTokenTransfer(from, to, tokenId);
784         // Clear approvals from the previous owner
785         _approve(address(0), tokenId);
786         _balances[from] -= 1;
787         _balances[to] += 1;
788         _owners[tokenId] = to;
789         emit Transfer(from, to, tokenId);
790     }
791     /**
792      * @dev Approve `to` to operate on `tokenId`
793      *
794      * Emits a {Approval} event.
795      */
796     function _approve(address to, uint256 tokenId) internal virtual {
797         _tokenApprovals[tokenId] = to;
798         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
799     }
800     /**
801      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
802      * The call is not executed if the target address is not a contract.
803      *
804      * @param from address representing the previous owner of the given token ID
805      * @param to target address that will receive the tokens
806      * @param tokenId uint256 ID of the token to be transferred
807      * @param _data bytes optional data to send along with the call
808      * @return bool whether the call correctly returned the expected magic value
809      */
810     function _checkOnERC721Received(
811         address from,
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) private returns (bool) {
816         if (to.isContract()) {
817             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
818                 return retval == IERC721Receiver.onERC721Received.selector;
819             } catch (bytes memory reason) {
820                 if (reason.length == 0) {
821                     revert("ERC721: transfer to non ERC721Receiver implementer");
822                 } else {
823                     assembly {
824                         revert(add(32, reason), mload(reason))
825                     }
826                 }
827             }
828         } else {
829             return true;
830         }
831     }
832     /**
833      * @dev Hook that is called before any token transfer. This includes minting
834      * and burning.
835      *
836      * Calling conditions:
837      *
838      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
839      * transferred to `to`.
840      * - When `from` is zero, `tokenId` will be minted for `to`.
841      * - When `to` is zero, ``from``'s `tokenId` will be burned.
842      * - `from` and `to` are never both zero.
843      *
844      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
845      */
846     function _beforeTokenTransfer(
847         address from,
848         address to,
849         uint256 tokenId
850     ) internal virtual {}
851 }
852 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
853 
854 /**
855  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
856  * @dev See https://eips.ethereum.org/EIPS/eip-721
857  */
858 interface IERC721Enumerable is IERC721 {
859     /**
860      * @dev Returns the total amount of tokens stored by the contract.
861      */
862     function totalSupply() external view returns (uint256);
863     /**
864      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
865      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
866      */
867     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
868     /**
869      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
870      * Use along with {totalSupply} to enumerate all tokens.
871      */
872     function tokenByIndex(uint256 index) external view returns (uint256);
873 }
874 // File: @openzeppelin/contracts/access/Ownable.sol
875 
876 /**
877  * @dev Contract module which provides a basic access control mechanism, where
878  * there is an account (an owner) that can be granted exclusive access to
879  * specific functions.
880  *
881  * By default, the owner account will be the one that deploys the contract. This
882  * can later be changed with {transferOwnership}.
883  *
884  * This module is used through inheritance. It will make available the modifier
885  * `onlyOwner`, which can be applied to your functions to restrict their use to
886  * the owner.
887  */
888 abstract contract Ownable is Context {
889     address private _owner;
890     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
891     /**
892      * @dev Initializes the contract setting the deployer as the initial owner.
893      */
894     constructor() {
895         _setOwner(_msgSender());
896     }
897     /**
898      * @dev Returns the address of the current owner.
899      */
900     function owner() public view virtual returns (address) {
901         return _owner;
902     }
903     /**
904      * @dev Throws if called by any account other than the owner.
905      */
906     modifier onlyOwner() {
907         require(owner() == _msgSender(), "Ownable: caller is not the owner");
908         _;
909     }
910     /**
911      * @dev Leaves the contract without owner. It will not be possible to call
912      * `onlyOwner` functions anymore. Can only be called by the current owner.
913      *
914      * NOTE: Renouncing ownership will leave the contract without an owner,
915      * thereby removing any functionality that is only available to the owner.
916      */
917     function renounceOwnership() public virtual onlyOwner {
918         _setOwner(address(0));
919     }
920     /**
921      * @dev Transfers ownership of the contract to a new account (`newOwner`).
922      * Can only be called by the current owner.
923      */
924     function transferOwnership(address newOwner) public virtual onlyOwner {
925         require(newOwner != address(0), "Ownable: new owner is the zero address");
926         _setOwner(newOwner);
927     }
928     function _setOwner(address newOwner) private {
929         address oldOwner = _owner;
930         _owner = newOwner;
931         emit OwnershipTransferred(oldOwner, newOwner);
932     }
933 }
934 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
935 
936 /**
937  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
938  *
939  * These functions can be used to verify that a message was signed by the holder
940  * of the private keys of a given address.
941  */
942 library ECDSA {
943     enum RecoverError {
944         NoError,
945         InvalidSignature,
946         InvalidSignatureLength,
947         InvalidSignatureS,
948         InvalidSignatureV
949     }
950     function _throwError(RecoverError error) private pure {
951         if (error == RecoverError.NoError) {
952             return; // no error: do nothing
953         } else if (error == RecoverError.InvalidSignature) {
954             revert("ECDSA: invalid signature");
955         } else if (error == RecoverError.InvalidSignatureLength) {
956             revert("ECDSA: invalid signature length");
957         } else if (error == RecoverError.InvalidSignatureS) {
958             revert("ECDSA: invalid signature 's' value");
959         } else if (error == RecoverError.InvalidSignatureV) {
960             revert("ECDSA: invalid signature 'v' value");
961         }
962     }
963     /**
964      * @dev Returns the address that signed a hashed message (`hash`) with
965      * `signature` or error string. This address can then be used for verification purposes.
966      *
967      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
968      * this function rejects them by requiring the `s` value to be in the lower
969      * half order, and the `v` value to be either 27 or 28.
970      *
971      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
972      * verification to be secure: it is possible to craft signatures that
973      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
974      * this is by receiving a hash of the original message (which may otherwise
975      * be too long), and then calling {toEthSignedMessageHash} on it.
976      *
977      * Documentation for signature generation:
978      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
979      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
980      *
981      * _Available since v4.3._
982      */
983     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
984         // Check the signature length
985         // - case 65: r,s,v signature (standard)
986         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
987         if (signature.length == 65) {
988             bytes32 r;
989             bytes32 s;
990             uint8 v;
991             // ecrecover takes the signature parameters, and the only way to get them
992             // currently is to use assembly.
993             assembly {
994                 r := mload(add(signature, 0x20))
995                 s := mload(add(signature, 0x40))
996                 v := byte(0, mload(add(signature, 0x60)))
997             }
998             return tryRecover(hash, v, r, s);
999         } else if (signature.length == 64) {
1000             bytes32 r;
1001             bytes32 vs;
1002             // ecrecover takes the signature parameters, and the only way to get them
1003             // currently is to use assembly.
1004             assembly {
1005                 r := mload(add(signature, 0x20))
1006                 vs := mload(add(signature, 0x40))
1007             }
1008             return tryRecover(hash, r, vs);
1009         } else {
1010             return (address(0), RecoverError.InvalidSignatureLength);
1011         }
1012     }
1013     /**
1014      * @dev Returns the address that signed a hashed message (`hash`) with
1015      * `signature`. This address can then be used for verification purposes.
1016      *
1017      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1018      * this function rejects them by requiring the `s` value to be in the lower
1019      * half order, and the `v` value to be either 27 or 28.
1020      *
1021      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1022      * verification to be secure: it is possible to craft signatures that
1023      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1024      * this is by receiving a hash of the original message (which may otherwise
1025      * be too long), and then calling {toEthSignedMessageHash} on it.
1026      */
1027     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1028         (address recovered, RecoverError error) = tryRecover(hash, signature);
1029         _throwError(error);
1030         return recovered;
1031     }
1032     /**
1033      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1034      *
1035      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1036      *
1037      * _Available since v4.3._
1038      */
1039     function tryRecover(
1040         bytes32 hash,
1041         bytes32 r,
1042         bytes32 vs
1043     ) internal pure returns (address, RecoverError) {
1044         bytes32 s;
1045         uint8 v;
1046         assembly {
1047             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1048             v := add(shr(255, vs), 27)
1049         }
1050         return tryRecover(hash, v, r, s);
1051     }
1052     /**
1053      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1054      *
1055      * _Available since v4.2._
1056      */
1057     function recover(
1058         bytes32 hash,
1059         bytes32 r,
1060         bytes32 vs
1061     ) internal pure returns (address) {
1062         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1063         _throwError(error);
1064         return recovered;
1065     }
1066     /**
1067      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1068      * `r` and `s` signature fields separately.
1069      *
1070      * _Available since v4.3._
1071      */
1072     function tryRecover(
1073         bytes32 hash,
1074         uint8 v,
1075         bytes32 r,
1076         bytes32 s
1077     ) internal pure returns (address, RecoverError) {
1078         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1079         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1080         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1081         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1082         //
1083         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1084         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1085         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1086         // these malleable signatures as well.
1087         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1088             return (address(0), RecoverError.InvalidSignatureS);
1089         }
1090         if (v != 27 && v != 28) {
1091             return (address(0), RecoverError.InvalidSignatureV);
1092         }
1093         // If the signature is valid (and not malleable), return the signer address
1094         address signer = ecrecover(hash, v, r, s);
1095         if (signer == address(0)) {
1096             return (address(0), RecoverError.InvalidSignature);
1097         }
1098         return (signer, RecoverError.NoError);
1099     }
1100     /**
1101      * @dev Overload of {ECDSA-recover} that receives the `v`,
1102      * `r` and `s` signature fields separately.
1103      */
1104     function recover(
1105         bytes32 hash,
1106         uint8 v,
1107         bytes32 r,
1108         bytes32 s
1109     ) internal pure returns (address) {
1110         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1111         _throwError(error);
1112         return recovered;
1113     }
1114     /**
1115      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1116      * produces hash corresponding to the one signed with the
1117      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1118      * JSON-RPC method as part of EIP-191.
1119      *
1120      * See {recover}.
1121      */
1122     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1123         // 32 is the length in bytes of hash,
1124         // enforced by the type signature above
1125         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1126     }
1127     /**
1128      * @dev Returns an Ethereum Signed Typed Data, created from a
1129      * `domainSeparator` and a `structHash`. This produces hash corresponding
1130      * to the one signed with the
1131      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1132      * JSON-RPC method as part of EIP-712.
1133      *
1134      * See {recover}.
1135      */
1136     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1137         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1138     }
1139 }
1140 // File: contracts/ApeKidsPets.sol
1141 
1142 contract ApeKidsPets is ERC721, Ownable {
1143   using Strings for uint256;
1144   using ECDSA for bytes32;
1145   //AKC contract
1146   IERC721Enumerable akcContract;
1147   //NFT params
1148   string public baseURI;
1149   string public defaultURI;
1150   string public mycontractURI;
1151   bool public finalizeBaseUri = false;
1152   uint256 private currentSupply;
1153   uint256 public maxSupply;  //11999
1154   uint256 public mintMax = 1;
1155   address public signer;
1156   mapping(uint256 => uint8) public akcClaimed;
1157   mapping(address => uint8) public OGClaimed;
1158   mapping(address => uint8) public whitelistClaimed;
1159   //state
1160   bool public paused = true;
1161   //royalty
1162   address public royaltyAddr;
1163   uint256 public royaltyBasis;
1164   constructor(
1165     string memory _name,
1166     string memory _symbol,
1167     string memory _initBaseURI,
1168     string memory _defaultURI,
1169     address _akc,
1170     uint256 _maxSupply,
1171     address _signer,
1172     address _royaltyAddr, 
1173     uint256 _royaltyBasis
1174   ) ERC721(_name, _symbol) {
1175     setBaseURI(_initBaseURI);
1176     defaultURI = _defaultURI;
1177     akcContract = IERC721Enumerable(_akc);
1178     maxSupply = _maxSupply;
1179     signer = _signer;
1180     royaltyAddr = _royaltyAddr;
1181     royaltyBasis = _royaltyBasis;
1182   }
1183   // internal
1184   function _baseURI() internal view virtual override returns (string memory) {
1185     return baseURI;
1186   }
1187   // public
1188   function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
1189       return interfaceId == 0xe8a3d485 /* contractURI() */ ||
1190       interfaceId == 0x2a55205a /* ERC-2981 royaltyInfo() */ ||
1191       super.supportsInterface(interfaceId);
1192   }
1193   function claimablePets(address _addr) public view returns (uint256[] memory) {
1194     uint256 ownerTokenCount = akcContract.balanceOf(_addr);
1195     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1196     uint256 j;
1197     for (uint256 i; i < ownerTokenCount; i++) {
1198       uint256 tid = akcContract.tokenOfOwnerByIndex(_addr, i);
1199       if(akcClaimed[tid] < mintMax){
1200         tokenIds[j] = tid;
1201         j++;
1202       }
1203     }
1204     return tokenIds;
1205   }
1206   function mint(uint256[] memory _tokenIdsToClaim, uint8 WLnums, uint8 OGcnt, bytes memory OGsignature, bytes memory WLsignature) public {
1207     require(!paused);
1208     uint256 supply = totalSupply();
1209     uint256 mintCount;
1210     for(uint256 i=0;i<_tokenIdsToClaim.length;i++){
1211       uint256 tid = _tokenIdsToClaim[i];
1212       if((akcContract.ownerOf(tid) == msg.sender) && (akcClaimed[tid] < mintMax)){
1213         akcClaimed[tid]++;
1214         mintCount++;
1215       }else{
1216         revert("id doesnt belong to owner");
1217       }
1218     }
1219     if((OGsignature.length > 0) && isOGed(msg.sender, OGcnt, OGsignature) && (OGClaimed[msg.sender] < mintMax)){
1220       mintCount+=OGcnt;
1221       OGClaimed[msg.sender]++;
1222     }
1223     if((WLsignature.length > 0) && isWhitelisted(msg.sender, WLsignature) && (WLnums <= (mintMax - whitelistClaimed[msg.sender]))){
1224       whitelistClaimed[msg.sender] += WLnums;
1225       mintCount += WLnums;
1226     }
1227     require(mintCount > 0,"at least 1 mint");
1228     require(supply + mintCount <= maxSupply, "max supply reached");
1229     currentSupply += mintCount;
1230     for (uint256 i = 1; i <= mintCount; i++) {
1231       _safeMint(msg.sender, supply + i);
1232     }
1233   }
1234   function isOGed(address _addr, uint8 cnt, bytes memory signature) public view returns(bool){
1235     return signer == keccak256(abi.encodePacked('OG', _addr, cnt)).recover(signature);
1236   }
1237   function isWhitelisted(address _addr, bytes memory signature) public view returns(bool){
1238     return signer == keccak256(abi.encodePacked('WL', _addr)).recover(signature);
1239   }
1240   function tokensOfOwner(address _owner, uint startId, uint endId) external view returns(uint256[] memory ) {
1241     uint256 tokenCount = balanceOf(_owner);
1242     if (tokenCount == 0) {
1243         return new uint256[](0);
1244     } else {
1245         uint256[] memory result = new uint256[](tokenCount);
1246         uint256 index = 0;
1247         for (uint256 tokenId = startId; tokenId <= endId; tokenId++) {
1248             if (index == tokenCount) break;
1249             if (ownerOf(tokenId) == _owner) {
1250                 result[index] = tokenId;
1251                 index++;
1252             }
1253         }
1254         return result;
1255     }
1256 }
1257   function totalSupply() public view returns (uint256) {
1258     return currentSupply;
1259   }
1260   function tokenURI(uint256 tokenId)
1261     public
1262     view
1263     virtual
1264     override
1265     returns (string memory)
1266   {
1267     require(
1268       _exists(tokenId),
1269       "ERC721Metadata: URI query for nonexistent token"
1270     );
1271     string memory currentBaseURI = _baseURI();
1272     return bytes(currentBaseURI).length > 0
1273         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1274         : defaultURI;
1275   }
1276   function contractURI() public view returns (string memory) {
1277         return string(abi.encodePacked(mycontractURI));
1278   }
1279   //ERC-2981
1280   function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view 
1281   returns (address receiver, uint256 royaltyAmount){
1282     return (royaltyAddr, _salePrice * royaltyBasis / 10000);
1283   }
1284   //only owner functions ---
1285   function setMintMax(uint256 _mintMax) public onlyOwner {
1286     mintMax = _mintMax;
1287   }
1288   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1289     require(!finalizeBaseUri);
1290     baseURI = _newBaseURI;
1291   }
1292   function finalizeBaseURI() public onlyOwner {
1293     finalizeBaseUri = true;
1294   }
1295   function setContractURI(string memory _contractURI) public onlyOwner {
1296     mycontractURI = _contractURI;
1297     //return format based on https://docs.opensea.io/docs/contract-level-metadata
1298   }
1299   function setRoyalty(address _royaltyAddr, uint256 _royaltyBasis) public onlyOwner {
1300     royaltyAddr = _royaltyAddr;
1301     royaltyBasis = _royaltyBasis;
1302   }
1303   function pause(bool _state) public onlyOwner {
1304     paused = _state;
1305   }
1306   function reserveMint(uint256 _mintAmount, address _to) public onlyOwner {    
1307     uint256 supply = totalSupply();
1308     require(supply + _mintAmount <= maxSupply, "max supply reached");
1309     currentSupply += _mintAmount;
1310     for (uint256 i = 1; i <= _mintAmount; i++) {
1311       _safeMint(_to, supply + i);
1312     }
1313   }
1314 }