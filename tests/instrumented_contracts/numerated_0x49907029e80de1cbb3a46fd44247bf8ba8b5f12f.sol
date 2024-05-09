1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
26 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
27 
28 /**
29  * @dev Required interface of an ERC721 compliant contract.
30  */
31 interface IERC721 is IERC165 {
32     /**
33      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
36     /**
37      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
38      */
39     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
40     /**
41      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
42      */
43     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
44     /**
45      * @dev Returns the number of tokens in ``owner``'s account.
46      */
47     function balanceOf(address owner) external view returns (uint256 balance);
48     /**
49      * @dev Returns the owner of the `tokenId` token.
50      *
51      * Requirements:
52      *
53      * - `tokenId` must exist.
54      */
55     function ownerOf(uint256 tokenId) external view returns (address owner);
56     /**
57      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
58      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
59      *
60      * Requirements:
61      *
62      * - `from` cannot be the zero address.
63      * - `to` cannot be the zero address.
64      * - `tokenId` token must exist and be owned by `from`.
65      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
66      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
67      *
68      * Emits a {Transfer} event.
69      */
70     function safeTransferFrom(
71         address from,
72         address to,
73         uint256 tokenId
74     ) external;
75     /**
76      * @dev Transfers `tokenId` token from `from` to `to`.
77      *
78      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
79      *
80      * Requirements:
81      *
82      * - `from` cannot be the zero address.
83      * - `to` cannot be the zero address.
84      * - `tokenId` token must be owned by `from`.
85      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address from,
91         address to,
92         uint256 tokenId
93     ) external;
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
108     /**
109      * @dev Returns the account approved for `tokenId` token.
110      *
111      * Requirements:
112      *
113      * - `tokenId` must exist.
114      */
115     function getApproved(uint256 tokenId) external view returns (address operator);
116     /**
117      * @dev Approve or remove `operator` as an operator for the caller.
118      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
119      *
120      * Requirements:
121      *
122      * - The `operator` cannot be the caller.
123      *
124      * Emits an {ApprovalForAll} event.
125      */
126     function setApprovalForAll(address operator, bool _approved) external;
127     /**
128      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
129      *
130      * See {setApprovalForAll}
131      */
132     function isApprovedForAll(address owner, address operator) external view returns (bool);
133     /**
134      * @dev Safely transfers `tokenId` token from `from` to `to`.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must exist and be owned by `from`.
141      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143      *
144      * Emits a {Transfer} event.
145      */
146     function safeTransferFrom(
147         address from,
148         address to,
149         uint256 tokenId,
150         bytes calldata data
151     ) external;
152 }
153 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
154 
155 /**
156  * @title ERC721 token receiver interface
157  * @dev Interface for any contract that wants to support safeTransfers
158  * from ERC721 asset contracts.
159  */
160 interface IERC721Receiver {
161     /**
162      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
163      * by `operator` from `from`, this function is called.
164      *
165      * It must return its Solidity selector to confirm the token transfer.
166      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
167      *
168      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
169      */
170     function onERC721Received(
171         address operator,
172         address from,
173         uint256 tokenId,
174         bytes calldata data
175     ) external returns (bytes4);
176 }
177 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
178 
179 /**
180  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
181  * @dev See https://eips.ethereum.org/EIPS/eip-721
182  */
183 interface IERC721Metadata is IERC721 {
184     /**
185      * @dev Returns the token collection name.
186      */
187     function name() external view returns (string memory);
188     /**
189      * @dev Returns the token collection symbol.
190      */
191     function symbol() external view returns (string memory);
192     /**
193      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
194      */
195     function tokenURI(uint256 tokenId) external view returns (string memory);
196 }
197 // File: @openzeppelin/contracts/utils/Address.sol
198 
199 /**
200  * @dev Collection of functions related to the address type
201  */
202 library Address {
203     /**
204      * @dev Returns true if `account` is a contract.
205      *
206      * [IMPORTANT]
207      * ====
208      * It is unsafe to assume that an address for which this function returns
209      * false is an externally-owned account (EOA) and not a contract.
210      *
211      * Among others, `isContract` will return false for the following
212      * types of addresses:
213      *
214      *  - an externally-owned account
215      *  - a contract in construction
216      *  - an address where a contract will be created
217      *  - an address where a contract lived, but was destroyed
218      * ====
219      */
220     function isContract(address account) internal view returns (bool) {
221         // This method relies on extcodesize, which returns 0 for contracts in
222         // construction, since the code is only stored at the end of the
223         // constructor execution.
224         uint256 size;
225         assembly {
226             size := extcodesize(account)
227         }
228         return size > 0;
229     }
230     /**
231      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
232      * `recipient`, forwarding all available gas and reverting on errors.
233      *
234      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
235      * of certain opcodes, possibly making contracts go over the 2300 gas limit
236      * imposed by `transfer`, making them unable to receive funds via
237      * `transfer`. {sendValue} removes this limitation.
238      *
239      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
240      *
241      * IMPORTANT: because control is transferred to `recipient`, care must be
242      * taken to not create reentrancy vulnerabilities. Consider using
243      * {ReentrancyGuard} or the
244      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
245      */
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248         (bool success, ) = recipient.call{value: amount}("");
249         require(success, "Address: unable to send value, recipient may have reverted");
250     }
251     /**
252      * @dev Performs a Solidity function call using a low level `call`. A
253      * plain `call` is an unsafe replacement for a function call: use this
254      * function instead.
255      *
256      * If `target` reverts with a revert reason, it is bubbled up by this
257      * function (like regular Solidity function calls).
258      *
259      * Returns the raw returned data. To convert to the expected return value,
260      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
261      *
262      * Requirements:
263      *
264      * - `target` must be a contract.
265      * - calling `target` with `data` must not revert.
266      *
267      * _Available since v3.1._
268      */
269     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
270         return functionCall(target, data, "Address: low-level call failed");
271     }
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but also transferring `value` wei to `target`.
288      *
289      * Requirements:
290      *
291      * - the calling contract must have an ETH balance of at least `value`.
292      * - the called Solidity function must be `payable`.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
302     }
303     /**
304      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
305      * with `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(address(this).balance >= value, "Address: insufficient balance for call");
316         require(isContract(target), "Address: call to non-contract");
317         (bool success, bytes memory returndata) = target.call{value: value}(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a static call.
323      *
324      * _Available since v3.3._
325      */
326     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
327         return functionStaticCall(target, data, "Address: low-level static call failed");
328     }
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal view returns (bytes memory) {
340         require(isContract(target), "Address: static call to non-contract");
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but performing a delegate call.
347      *
348      * _Available since v3.4._
349      */
350     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
352     }
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(isContract(target), "Address: delegate call to non-contract");
365         (bool success, bytes memory returndata) = target.delegatecall(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368     /**
369      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
370      * revert reason using the provided one.
371      *
372      * _Available since v4.3._
373      */
374     function verifyCallResult(
375         bool success,
376         bytes memory returndata,
377         string memory errorMessage
378     ) internal pure returns (bytes memory) {
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 // File: @openzeppelin/contracts/utils/Context.sol
396 
397 /**
398  * @dev Provides information about the current execution context, including the
399  * sender of the transaction and its data. While these are generally available
400  * via msg.sender and msg.data, they should not be accessed in such a direct
401  * manner, since when dealing with meta-transactions the account sending and
402  * paying for execution may not be the actual sender (as far as an application
403  * is concerned).
404  *
405  * This contract is only required for intermediate, library-like contracts.
406  */
407 abstract contract Context {
408     function _msgSender() internal view virtual returns (address) {
409         return msg.sender;
410     }
411     function _msgData() internal view virtual returns (bytes calldata) {
412         return msg.data;
413     }
414 }
415 // File: @openzeppelin/contracts/utils/Strings.sol
416 
417 /**
418  * @dev String operations.
419  */
420 library Strings {
421     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
422     /**
423      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
424      */
425     function toString(uint256 value) internal pure returns (string memory) {
426         // Inspired by OraclizeAPI's implementation - MIT licence
427         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
428         if (value == 0) {
429             return "0";
430         }
431         uint256 temp = value;
432         uint256 digits;
433         while (temp != 0) {
434             digits++;
435             temp /= 10;
436         }
437         bytes memory buffer = new bytes(digits);
438         while (value != 0) {
439             digits -= 1;
440             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
441             value /= 10;
442         }
443         return string(buffer);
444     }
445     /**
446      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
447      */
448     function toHexString(uint256 value) internal pure returns (string memory) {
449         if (value == 0) {
450             return "0x00";
451         }
452         uint256 temp = value;
453         uint256 length = 0;
454         while (temp != 0) {
455             length++;
456             temp >>= 8;
457         }
458         return toHexString(value, length);
459     }
460     /**
461      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
462      */
463     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
464         bytes memory buffer = new bytes(2 * length + 2);
465         buffer[0] = "0";
466         buffer[1] = "x";
467         for (uint256 i = 2 * length + 1; i > 1; --i) {
468             buffer[i] = _HEX_SYMBOLS[value & 0xf];
469             value >>= 4;
470         }
471         require(value == 0, "Strings: hex length insufficient");
472         return string(buffer);
473     }
474 }
475 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
476 
477 /**
478  * @dev Implementation of the {IERC165} interface.
479  *
480  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
481  * for the additional interface id that will be supported. For example:
482  *
483  * ```solidity
484  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
486  * }
487  * ```
488  *
489  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
490  */
491 abstract contract ERC165 is IERC165 {
492     /**
493      * @dev See {IERC165-supportsInterface}.
494      */
495     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496         return interfaceId == type(IERC165).interfaceId;
497     }
498 }
499 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
500 
501 /**
502  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
503  * the Metadata extension, but not including the Enumerable extension, which is available separately as
504  * {ERC721Enumerable}.
505  */
506 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
507     using Address for address;
508     using Strings for uint256;
509     // Token name
510     string private _name;
511     // Token symbol
512     string private _symbol;
513     // Mapping from token ID to owner address
514     mapping(uint256 => address) private _owners;
515     // Mapping owner address to token count
516     mapping(address => uint256) private _balances;
517     // Mapping from token ID to approved address
518     mapping(uint256 => address) private _tokenApprovals;
519     // Mapping from owner to operator approvals
520     mapping(address => mapping(address => bool)) private _operatorApprovals;
521     /**
522      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
523      */
524     constructor(string memory name_, string memory symbol_) {
525         _name = name_;
526         _symbol = symbol_;
527     }
528     /**
529      * @dev See {IERC165-supportsInterface}.
530      */
531     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
532         return
533             interfaceId == type(IERC721).interfaceId ||
534             interfaceId == type(IERC721Metadata).interfaceId ||
535             super.supportsInterface(interfaceId);
536     }
537     /**
538      * @dev See {IERC721-balanceOf}.
539      */
540     function balanceOf(address owner) public view virtual override returns (uint256) {
541         require(owner != address(0), "ERC721: balance query for the zero address");
542         return _balances[owner];
543     }
544     /**
545      * @dev See {IERC721-ownerOf}.
546      */
547     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
548         address owner = _owners[tokenId];
549         require(owner != address(0), "ERC721: owner query for nonexistent token");
550         return owner;
551     }
552     /**
553      * @dev See {IERC721Metadata-name}.
554      */
555     function name() public view virtual override returns (string memory) {
556         return _name;
557     }
558     /**
559      * @dev See {IERC721Metadata-symbol}.
560      */
561     function symbol() public view virtual override returns (string memory) {
562         return _symbol;
563     }
564     /**
565      * @dev See {IERC721Metadata-tokenURI}.
566      */
567     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
568         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
569         string memory baseURI = _baseURI();
570         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
571     }
572     /**
573      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
574      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
575      * by default, can be overriden in child contracts.
576      */
577     function _baseURI() internal view virtual returns (string memory) {
578         return "";
579     }
580     /**
581      * @dev See {IERC721-approve}.
582      */
583     function approve(address to, uint256 tokenId) public virtual override {
584         address owner = ERC721.ownerOf(tokenId);
585         require(to != owner, "ERC721: approval to current owner");
586         require(
587             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
588             "ERC721: approve caller is not owner nor approved for all"
589         );
590         _approve(to, tokenId);
591     }
592     /**
593      * @dev See {IERC721-getApproved}.
594      */
595     function getApproved(uint256 tokenId) public view virtual override returns (address) {
596         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
597         return _tokenApprovals[tokenId];
598     }
599     /**
600      * @dev See {IERC721-setApprovalForAll}.
601      */
602     function setApprovalForAll(address operator, bool approved) public virtual override {
603         require(operator != _msgSender(), "ERC721: approve to caller");
604         _operatorApprovals[_msgSender()][operator] = approved;
605         emit ApprovalForAll(_msgSender(), operator, approved);
606     }
607     /**
608      * @dev See {IERC721-isApprovedForAll}.
609      */
610     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
611         return _operatorApprovals[owner][operator];
612     }
613     /**
614      * @dev See {IERC721-transferFrom}.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) public virtual override {
621         //solhint-disable-next-line max-line-length
622         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
623         _transfer(from, to, tokenId);
624     }
625     /**
626      * @dev See {IERC721-safeTransferFrom}.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId
632     ) public virtual override {
633         safeTransferFrom(from, to, tokenId, "");
634     }
635     /**
636      * @dev See {IERC721-safeTransferFrom}.
637      */
638     function safeTransferFrom(
639         address from,
640         address to,
641         uint256 tokenId,
642         bytes memory _data
643     ) public virtual override {
644         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
645         _safeTransfer(from, to, tokenId, _data);
646     }
647     /**
648      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
649      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
650      *
651      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
652      *
653      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
654      * implement alternative mechanisms to perform token transfer, such as signature-based.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must exist and be owned by `from`.
661      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662      *
663      * Emits a {Transfer} event.
664      */
665     function _safeTransfer(
666         address from,
667         address to,
668         uint256 tokenId,
669         bytes memory _data
670     ) internal virtual {
671         _transfer(from, to, tokenId);
672         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
673     }
674     /**
675      * @dev Returns whether `tokenId` exists.
676      *
677      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
678      *
679      * Tokens start existing when they are minted (`_mint`),
680      * and stop existing when they are burned (`_burn`).
681      */
682     function _exists(uint256 tokenId) internal view virtual returns (bool) {
683         return _owners[tokenId] != address(0);
684     }
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
697     /**
698      * @dev Safely mints `tokenId` and transfers it to `to`.
699      *
700      * Requirements:
701      *
702      * - `tokenId` must not exist.
703      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
704      *
705      * Emits a {Transfer} event.
706      */
707     function _safeMint(address to, uint256 tokenId) internal virtual {
708         _safeMint(to, tokenId, "");
709     }
710     /**
711      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
712      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
713      */
714     function _safeMint(
715         address to,
716         uint256 tokenId,
717         bytes memory _data
718     ) internal virtual {
719         _mint(to, tokenId);
720         require(
721             _checkOnERC721Received(address(0), to, tokenId, _data),
722             "ERC721: transfer to non ERC721Receiver implementer"
723         );
724     }
725     /**
726      * @dev Mints `tokenId` and transfers it to `to`.
727      *
728      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
729      *
730      * Requirements:
731      *
732      * - `tokenId` must not exist.
733      * - `to` cannot be the zero address.
734      *
735      * Emits a {Transfer} event.
736      */
737     function _mint(address to, uint256 tokenId) internal virtual {
738         require(to != address(0), "ERC721: mint to the zero address");
739         require(!_exists(tokenId), "ERC721: token already minted");
740         _beforeTokenTransfer(address(0), to, tokenId);
741         _balances[to] += 1;
742         _owners[tokenId] = to;
743         emit Transfer(address(0), to, tokenId);
744     }
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
757         _beforeTokenTransfer(owner, address(0), tokenId);
758         // Clear approvals
759         _approve(address(0), tokenId);
760         _balances[owner] -= 1;
761         delete _owners[tokenId];
762         emit Transfer(owner, address(0), tokenId);
763     }
764     /**
765      * @dev Transfers `tokenId` from `from` to `to`.
766      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
767      *
768      * Requirements:
769      *
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must be owned by `from`.
772      *
773      * Emits a {Transfer} event.
774      */
775     function _transfer(
776         address from,
777         address to,
778         uint256 tokenId
779     ) internal virtual {
780         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
781         require(to != address(0), "ERC721: transfer to the zero address");
782         _beforeTokenTransfer(from, to, tokenId);
783         // Clear approvals from the previous owner
784         _approve(address(0), tokenId);
785         _balances[from] -= 1;
786         _balances[to] += 1;
787         _owners[tokenId] = to;
788         emit Transfer(from, to, tokenId);
789     }
790     /**
791      * @dev Approve `to` to operate on `tokenId`
792      *
793      * Emits a {Approval} event.
794      */
795     function _approve(address to, uint256 tokenId) internal virtual {
796         _tokenApprovals[tokenId] = to;
797         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
798     }
799     /**
800      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
801      * The call is not executed if the target address is not a contract.
802      *
803      * @param from address representing the previous owner of the given token ID
804      * @param to target address that will receive the tokens
805      * @param tokenId uint256 ID of the token to be transferred
806      * @param _data bytes optional data to send along with the call
807      * @return bool whether the call correctly returned the expected magic value
808      */
809     function _checkOnERC721Received(
810         address from,
811         address to,
812         uint256 tokenId,
813         bytes memory _data
814     ) private returns (bool) {
815         if (to.isContract()) {
816             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
817                 return retval == IERC721Receiver.onERC721Received.selector;
818             } catch (bytes memory reason) {
819                 if (reason.length == 0) {
820                     revert("ERC721: transfer to non ERC721Receiver implementer");
821                 } else {
822                     assembly {
823                         revert(add(32, reason), mload(reason))
824                     }
825                 }
826             }
827         } else {
828             return true;
829         }
830     }
831     /**
832      * @dev Hook that is called before any token transfer. This includes minting
833      * and burning.
834      *
835      * Calling conditions:
836      *
837      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
838      * transferred to `to`.
839      * - When `from` is zero, `tokenId` will be minted for `to`.
840      * - When `to` is zero, ``from``'s `tokenId` will be burned.
841      * - `from` and `to` are never both zero.
842      *
843      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
844      */
845     function _beforeTokenTransfer(
846         address from,
847         address to,
848         uint256 tokenId
849     ) internal virtual {}
850 }
851 // File: @openzeppelin/contracts/access/Ownable.sol
852 
853 /**
854  * @dev Contract module which provides a basic access control mechanism, where
855  * there is an account (an owner) that can be granted exclusive access to
856  * specific functions.
857  *
858  * By default, the owner account will be the one that deploys the contract. This
859  * can later be changed with {transferOwnership}.
860  *
861  * This module is used through inheritance. It will make available the modifier
862  * `onlyOwner`, which can be applied to your functions to restrict their use to
863  * the owner.
864  */
865 abstract contract Ownable is Context {
866     address private _owner;
867     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
868     /**
869      * @dev Initializes the contract setting the deployer as the initial owner.
870      */
871     constructor() {
872         _setOwner(_msgSender());
873     }
874     /**
875      * @dev Returns the address of the current owner.
876      */
877     function owner() public view virtual returns (address) {
878         return _owner;
879     }
880     /**
881      * @dev Throws if called by any account other than the owner.
882      */
883     modifier onlyOwner() {
884         require(owner() == _msgSender(), "Ownable: caller is not the owner");
885         _;
886     }
887     /**
888      * @dev Leaves the contract without owner. It will not be possible to call
889      * `onlyOwner` functions anymore. Can only be called by the current owner.
890      *
891      * NOTE: Renouncing ownership will leave the contract without an owner,
892      * thereby removing any functionality that is only available to the owner.
893      */
894     function renounceOwnership() public virtual onlyOwner {
895         _setOwner(address(0));
896     }
897     /**
898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
899      * Can only be called by the current owner.
900      */
901     function transferOwnership(address newOwner) public virtual onlyOwner {
902         require(newOwner != address(0), "Ownable: new owner is the zero address");
903         _setOwner(newOwner);
904     }
905     function _setOwner(address newOwner) private {
906         address oldOwner = _owner;
907         _owner = newOwner;
908         emit OwnershipTransferred(oldOwner, newOwner);
909     }
910 }
911 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
912 
913 /**
914  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
915  *
916  * These functions can be used to verify that a message was signed by the holder
917  * of the private keys of a given address.
918  */
919 library ECDSA {
920     enum RecoverError {
921         NoError,
922         InvalidSignature,
923         InvalidSignatureLength,
924         InvalidSignatureS,
925         InvalidSignatureV
926     }
927     function _throwError(RecoverError error) private pure {
928         if (error == RecoverError.NoError) {
929             return; // no error: do nothing
930         } else if (error == RecoverError.InvalidSignature) {
931             revert("ECDSA: invalid signature");
932         } else if (error == RecoverError.InvalidSignatureLength) {
933             revert("ECDSA: invalid signature length");
934         } else if (error == RecoverError.InvalidSignatureS) {
935             revert("ECDSA: invalid signature 's' value");
936         } else if (error == RecoverError.InvalidSignatureV) {
937             revert("ECDSA: invalid signature 'v' value");
938         }
939     }
940     /**
941      * @dev Returns the address that signed a hashed message (`hash`) with
942      * `signature` or error string. This address can then be used for verification purposes.
943      *
944      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
945      * this function rejects them by requiring the `s` value to be in the lower
946      * half order, and the `v` value to be either 27 or 28.
947      *
948      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
949      * verification to be secure: it is possible to craft signatures that
950      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
951      * this is by receiving a hash of the original message (which may otherwise
952      * be too long), and then calling {toEthSignedMessageHash} on it.
953      *
954      * Documentation for signature generation:
955      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
956      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
957      *
958      * _Available since v4.3._
959      */
960     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
961         // Check the signature length
962         // - case 65: r,s,v signature (standard)
963         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
964         if (signature.length == 65) {
965             bytes32 r;
966             bytes32 s;
967             uint8 v;
968             // ecrecover takes the signature parameters, and the only way to get them
969             // currently is to use assembly.
970             assembly {
971                 r := mload(add(signature, 0x20))
972                 s := mload(add(signature, 0x40))
973                 v := byte(0, mload(add(signature, 0x60)))
974             }
975             return tryRecover(hash, v, r, s);
976         } else if (signature.length == 64) {
977             bytes32 r;
978             bytes32 vs;
979             // ecrecover takes the signature parameters, and the only way to get them
980             // currently is to use assembly.
981             assembly {
982                 r := mload(add(signature, 0x20))
983                 vs := mload(add(signature, 0x40))
984             }
985             return tryRecover(hash, r, vs);
986         } else {
987             return (address(0), RecoverError.InvalidSignatureLength);
988         }
989     }
990     /**
991      * @dev Returns the address that signed a hashed message (`hash`) with
992      * `signature`. This address can then be used for verification purposes.
993      *
994      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
995      * this function rejects them by requiring the `s` value to be in the lower
996      * half order, and the `v` value to be either 27 or 28.
997      *
998      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
999      * verification to be secure: it is possible to craft signatures that
1000      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1001      * this is by receiving a hash of the original message (which may otherwise
1002      * be too long), and then calling {toEthSignedMessageHash} on it.
1003      */
1004     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1005         (address recovered, RecoverError error) = tryRecover(hash, signature);
1006         _throwError(error);
1007         return recovered;
1008     }
1009     /**
1010      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1011      *
1012      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1013      *
1014      * _Available since v4.3._
1015      */
1016     function tryRecover(
1017         bytes32 hash,
1018         bytes32 r,
1019         bytes32 vs
1020     ) internal pure returns (address, RecoverError) {
1021         bytes32 s;
1022         uint8 v;
1023         assembly {
1024             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1025             v := add(shr(255, vs), 27)
1026         }
1027         return tryRecover(hash, v, r, s);
1028     }
1029     /**
1030      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1031      *
1032      * _Available since v4.2._
1033      */
1034     function recover(
1035         bytes32 hash,
1036         bytes32 r,
1037         bytes32 vs
1038     ) internal pure returns (address) {
1039         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1040         _throwError(error);
1041         return recovered;
1042     }
1043     /**
1044      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1045      * `r` and `s` signature fields separately.
1046      *
1047      * _Available since v4.3._
1048      */
1049     function tryRecover(
1050         bytes32 hash,
1051         uint8 v,
1052         bytes32 r,
1053         bytes32 s
1054     ) internal pure returns (address, RecoverError) {
1055         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1056         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1057         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1058         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1059         //
1060         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1061         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1062         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1063         // these malleable signatures as well.
1064         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1065             return (address(0), RecoverError.InvalidSignatureS);
1066         }
1067         if (v != 27 && v != 28) {
1068             return (address(0), RecoverError.InvalidSignatureV);
1069         }
1070         // If the signature is valid (and not malleable), return the signer address
1071         address signer = ecrecover(hash, v, r, s);
1072         if (signer == address(0)) {
1073             return (address(0), RecoverError.InvalidSignature);
1074         }
1075         return (signer, RecoverError.NoError);
1076     }
1077     /**
1078      * @dev Overload of {ECDSA-recover} that receives the `v`,
1079      * `r` and `s` signature fields separately.
1080      */
1081     function recover(
1082         bytes32 hash,
1083         uint8 v,
1084         bytes32 r,
1085         bytes32 s
1086     ) internal pure returns (address) {
1087         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1088         _throwError(error);
1089         return recovered;
1090     }
1091     /**
1092      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1093      * produces hash corresponding to the one signed with the
1094      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1095      * JSON-RPC method as part of EIP-191.
1096      *
1097      * See {recover}.
1098      */
1099     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1100         // 32 is the length in bytes of hash,
1101         // enforced by the type signature above
1102         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1103     }
1104     /**
1105      * @dev Returns an Ethereum Signed Typed Data, created from a
1106      * `domainSeparator` and a `structHash`. This produces hash corresponding
1107      * to the one signed with the
1108      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1109      * JSON-RPC method as part of EIP-712.
1110      *
1111      * See {recover}.
1112      */
1113     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1114         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1115     }
1116 }
1117 // File: contracts/NFTMTG.sol
1118 
1119 contract NFTMTG is ERC721, Ownable {
1120   using Strings for uint256;
1121   using ECDSA for bytes32;
1122   //NFT params
1123   string public baseURI;
1124   string public defaultURI;
1125   string public mycontractURI;
1126   bool public finalizeBaseUri = false;
1127   //sale stages:
1128   //stage 0: init(no minting)
1129   //stage 1: pre-sale
1130   //stage 2: pre-sale clearance
1131   //stage 3: public sale
1132   uint8 public stage = 0;
1133   event stageChanged(uint8 stage);
1134   //pre-sale (stage=1)
1135   address private _signer;
1136   uint256 public presalePrice = 0.2 ether;
1137   uint256 public presaleSupply;
1138   uint256 public presaleMintMax = 1;
1139   mapping(address => uint8) public presaleMintCount;
1140   //pre-sale-clearance (stage=2)
1141   uint256 public clearanceMintMax = 2; //one more than presaleMintMax
1142   //public sale (stage=3)
1143   uint256 public salePrice = 0.2 ether;
1144   uint256 public saleMintMax = 3;
1145   uint256 public totalSaleSupply;
1146   mapping(address => uint8) public saleMintCount;
1147   //others
1148   bool public paused = false;
1149   uint256 public currentSupply;
1150   //sale holders
1151   address[6] public fundRecipients = [
1152     0xA1ae8f9ed498c7EF353DD275b6F581fC76E72b8B,
1153     0x491252D2D7FbF62fE8360F80eAFccdF6edfa9090,
1154     0x20c606439a3ee9988453C192f825893FF5CB40A1,
1155     0xafBD28f83c21674796Cb6eDE9aBed53de4aFbcC4,
1156     0xEf0ec25bF8931EcA46D2fF785d1A7f3d7Db6F7ab,
1157     0x98Eb7D8e1bfFd0B9368726fdf4555C45fDBB2Bd6
1158   ];
1159   uint256[] public receivePercentagePt = [2375, 750, 3250, 750, 2375, 500];   //distribution in basis points
1160   //royalty
1161   address public royaltyAddr;
1162   uint256 public royaltyBasis;
1163   constructor(
1164     string memory _name,
1165     string memory _symbol,
1166     string memory _initBaseURI,
1167     string memory _defaultURI,
1168     uint256 _presaleSupply,
1169     uint256 _totalSaleSupply,
1170     address _whitelistSigner
1171   ) ERC721(_name, _symbol) {
1172     setBaseURI(_initBaseURI);
1173     defaultURI = _defaultURI;
1174     presaleSupply = _presaleSupply;
1175     totalSaleSupply = _totalSaleSupply;
1176     _signer = _whitelistSigner;
1177   }
1178   // internal
1179   function _baseURI() internal view virtual override returns (string memory) {
1180     return baseURI;
1181   }
1182   function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
1183       return interfaceId == type(IERC721).interfaceId || 
1184       interfaceId == 0xe8a3d485 /* contractURI() */ ||
1185       interfaceId == 0x2a55205a /* ERC-2981 royaltyInfo() */ ||
1186       super.supportsInterface(interfaceId);
1187   }
1188   // public
1189   function mint_whitelist(uint8 _mintAmount, bytes memory signature) public payable {
1190     uint256 supply = totalSupply();
1191     require(!paused);
1192     require(stage > 0, "Sale not started");
1193     require(isWhitelisted(msg.sender, signature), "Must be whitelisted");
1194     require(stage == 1 || stage == 2, "invalid stage");
1195     require(_mintAmount > 0, "Must mint at least 1");
1196     require(supply + _mintAmount <= presaleSupply, "Mint exceed presale supply");
1197     require(msg.value >= presalePrice * _mintAmount, "Insufficient amount sent");
1198     require(_mintAmount + presaleMintCount[msg.sender] <= (stage == 1 ? presaleMintMax : clearanceMintMax), "Cannot mint more than 2");
1199     presaleMintCount[msg.sender] += _mintAmount;
1200     currentSupply += _mintAmount;
1201     for (uint256 i = 1; i <= _mintAmount; i++) {
1202       _safeMint(msg.sender, supply + i);
1203     }
1204   }
1205   function mint_public(uint8 _mintAmount) public payable {
1206     uint256 supply = totalSupply();
1207     require(!paused);
1208     require(stage == 3, "Not public sale");
1209     require(_mintAmount > 0, "Must mint at least 1");
1210     require(supply + _mintAmount <= totalSaleSupply, "Mint exceed total supply");
1211     require(_mintAmount + saleMintCount[tx.origin] <= saleMintMax, "Cannot mint more than 3");
1212     require(msg.value >= salePrice * _mintAmount, "Insufficient amount sent");
1213     saleMintCount[tx.origin] += _mintAmount;
1214     currentSupply += _mintAmount;
1215     for (uint256 i = 1; i <= _mintAmount; i++) {
1216       _safeMint(msg.sender, supply + i);
1217     }
1218   }
1219   function isWhitelisted(address _addr, bytes memory signature) public view returns(bool){
1220       return _signer == ECDSA.recover(keccak256(abi.encodePacked("WL", _addr)), signature);
1221   }
1222   function totalSupply() public view returns (uint) {
1223         return currentSupply;
1224     }
1225     function tokensOfOwner(address _owner, uint startId, uint endId) external view returns(uint256[] memory ) {
1226         uint256 tokenCount = balanceOf(_owner);
1227         if (tokenCount == 0) {
1228             return new uint256[](0);
1229         } else {
1230             uint256[] memory result = new uint256[](tokenCount);
1231             uint256 index = 0;
1232             for (uint256 tokenId = startId; tokenId < endId; tokenId++) {
1233                 if (index == tokenCount) break;
1234                 if (ownerOf(tokenId) == _owner) {
1235                     result[index] = tokenId;
1236                     index++;
1237                 }
1238             }
1239             return result;
1240         }
1241     }
1242   function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1243   {
1244     require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1245     string memory currentBaseURI = _baseURI();
1246     return bytes(currentBaseURI).length > 0
1247         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1248         : defaultURI;
1249   }
1250   function contractURI() public view returns (string memory) {
1251       return string(abi.encodePacked(mycontractURI));
1252   }
1253   //ERC-2981
1254   function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount){
1255     return (royaltyAddr, _salePrice * royaltyBasis / 10000);
1256   }
1257   //only owner functions ---
1258   function nextStage() public onlyOwner() {
1259     require(stage < 3, "Stage cannot be more than 3");
1260     stage++;
1261     emit stageChanged(stage);
1262   }
1263   function setwhitelistSigner(address _whitelistSigner) public onlyOwner {
1264     _signer = _whitelistSigner;
1265   }
1266   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1267     require(!finalizeBaseUri);
1268     baseURI = _newBaseURI;
1269   }
1270   function finalizeBaseURI() public onlyOwner {
1271     finalizeBaseUri = true;
1272   }
1273   function setContractURI(string memory _contractURI) public onlyOwner {
1274     mycontractURI = _contractURI;
1275   }
1276   function setRoyalty(address _royaltyAddr, uint256 _royaltyBasis) public onlyOwner {
1277     royaltyAddr = _royaltyAddr;
1278     royaltyBasis = _royaltyBasis;
1279   }
1280   function pause(bool _state) public onlyOwner {
1281     paused = _state;
1282   }
1283   function reserveMint(uint256 _mintAmount, address _to) public onlyOwner {
1284     uint256 supply = totalSupply();
1285     require(supply + _mintAmount <= totalSaleSupply, "Mint exceed total supply");
1286     currentSupply += _mintAmount;
1287     for (uint256 i = 1; i <= _mintAmount; i++) {
1288       _safeMint(_to, supply + i);
1289     }
1290   }
1291   //fund withdraw functions ---
1292   function withdrawFund() public onlyOwner {
1293     uint256 currentBal = address(this).balance;
1294     require(currentBal > 0);
1295     for (uint256 i = 0; i < fundRecipients.length-1; i++) {
1296       _withdraw(fundRecipients[i], currentBal * receivePercentagePt[i] / 10000);
1297     }
1298     //final address receives remainder to prevent ether dust
1299     _withdraw(fundRecipients[fundRecipients.length-1], address(this).balance);
1300   }
1301   function _withdraw(address _addr, uint256 _amt) private {
1302     (bool success,) = _addr.call{value: _amt}("");
1303     require(success, "Transfer failed");
1304   }
1305 }