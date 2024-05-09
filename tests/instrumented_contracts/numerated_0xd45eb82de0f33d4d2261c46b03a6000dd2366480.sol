1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
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
25 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
26 /**
27  * @dev Required interface of an ERC721 compliant contract.
28  */
29 interface IERC721 is IERC165 {
30     /**
31      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
32      */
33     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
34     /**
35      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
36      */
37     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
38     /**
39      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
40      */
41     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
42     /**
43      * @dev Returns the number of tokens in ``owner``'s account.
44      */
45     function balanceOf(address owner) external view returns (uint256 balance);
46     /**
47      * @dev Returns the owner of the `tokenId` token.
48      *
49      * Requirements:
50      *
51      * - `tokenId` must exist.
52      */
53     function ownerOf(uint256 tokenId) external view returns (address owner);
54     /**
55      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
56      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
57      *
58      * Requirements:
59      *
60      * - `from` cannot be the zero address.
61      * - `to` cannot be the zero address.
62      * - `tokenId` token must exist and be owned by `from`.
63      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
64      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
65      *
66      * Emits a {Transfer} event.
67      */
68     function safeTransferFrom(
69         address from,
70         address to,
71         uint256 tokenId
72     ) external;
73     /**
74      * @dev Transfers `tokenId` token from `from` to `to`.
75      *
76      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
77      *
78      * Requirements:
79      *
80      * - `from` cannot be the zero address.
81      * - `to` cannot be the zero address.
82      * - `tokenId` token must be owned by `from`.
83      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(
88         address from,
89         address to,
90         uint256 tokenId
91     ) external;
92     /**
93      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
94      * The approval is cleared when the token is transferred.
95      *
96      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
97      *
98      * Requirements:
99      *
100      * - The caller must own the token or be an approved operator.
101      * - `tokenId` must exist.
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address to, uint256 tokenId) external;
106     /**
107      * @dev Returns the account approved for `tokenId` token.
108      *
109      * Requirements:
110      *
111      * - `tokenId` must exist.
112      */
113     function getApproved(uint256 tokenId) external view returns (address operator);
114     /**
115      * @dev Approve or remove `operator` as an operator for the caller.
116      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
117      *
118      * Requirements:
119      *
120      * - The `operator` cannot be the caller.
121      *
122      * Emits an {ApprovalForAll} event.
123      */
124     function setApprovalForAll(address operator, bool _approved) external;
125     /**
126      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
127      *
128      * See {setApprovalForAll}
129      */
130     function isApprovedForAll(address owner, address operator) external view returns (bool);
131     /**
132      * @dev Safely transfers `tokenId` token from `from` to `to`.
133      *
134      * Requirements:
135      *
136      * - `from` cannot be the zero address.
137      * - `to` cannot be the zero address.
138      * - `tokenId` token must exist and be owned by `from`.
139      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
141      *
142      * Emits a {Transfer} event.
143      */
144     function safeTransferFrom(
145         address from,
146         address to,
147         uint256 tokenId,
148         bytes calldata data
149     ) external;
150 }
151 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
152 /**
153  * @title ERC721 token receiver interface
154  * @dev Interface for any contract that wants to support safeTransfers
155  * from ERC721 asset contracts.
156  */
157 interface IERC721Receiver {
158     /**
159      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
160      * by `operator` from `from`, this function is called.
161      *
162      * It must return its Solidity selector to confirm the token transfer.
163      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
164      *
165      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
166      */
167     function onERC721Received(
168         address operator,
169         address from,
170         uint256 tokenId,
171         bytes calldata data
172     ) external returns (bytes4);
173 }
174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
175 /**
176  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
177  * @dev See https://eips.ethereum.org/EIPS/eip-721
178  */
179 interface IERC721Metadata is IERC721 {
180     /**
181      * @dev Returns the token collection name.
182      */
183     function name() external view returns (string memory);
184     /**
185      * @dev Returns the token collection symbol.
186      */
187     function symbol() external view returns (string memory);
188     /**
189      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
190      */
191     function tokenURI(uint256 tokenId) external view returns (string memory);
192 }
193 // File: @openzeppelin/contracts/utils/Address.sol
194 /**
195  * @dev Collection of functions related to the address type
196  */
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * [IMPORTANT]
202      * ====
203      * It is unsafe to assume that an address for which this function returns
204      * false is an externally-owned account (EOA) and not a contract.
205      *
206      * Among others, `isContract` will return false for the following
207      * types of addresses:
208      *
209      *  - an externally-owned account
210      *  - a contract in construction
211      *  - an address where a contract will be created
212      *  - an address where a contract lived, but was destroyed
213      * ====
214      */
215     function isContract(address account) internal view returns (bool) {
216         // This method relies on extcodesize, which returns 0 for contracts in
217         // construction, since the code is only stored at the end of the
218         // constructor execution.
219         uint256 size;
220         assembly {
221             size := extcodesize(account)
222         }
223         return size > 0;
224     }
225     /**
226      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
227      * `recipient`, forwarding all available gas and reverting on errors.
228      *
229      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
230      * of certain opcodes, possibly making contracts go over the 2300 gas limit
231      * imposed by `transfer`, making them unable to receive funds via
232      * `transfer`. {sendValue} removes this limitation.
233      *
234      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
235      *
236      * IMPORTANT: because control is transferred to `recipient`, care must be
237      * taken to not create reentrancy vulnerabilities. Consider using
238      * {ReentrancyGuard} or the
239      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
240      */
241     function sendValue(address payable recipient, uint256 amount) internal {
242         require(address(this).balance >= amount, "Address: insufficient balance");
243         (bool success, ) = recipient.call{value: amount}("");
244         require(success, "Address: unable to send value, recipient may have reverted");
245     }
246     /**
247      * @dev Performs a Solidity function call using a low level `call`. A
248      * plain `call` is an unsafe replacement for a function call: use this
249      * function instead.
250      *
251      * If `target` reverts with a revert reason, it is bubbled up by this
252      * function (like regular Solidity function calls).
253      *
254      * Returns the raw returned data. To convert to the expected return value,
255      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
256      *
257      * Requirements:
258      *
259      * - `target` must be a contract.
260      * - calling `target` with `data` must not revert.
261      *
262      * _Available since v3.1._
263      */
264     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
265         return functionCall(target, data, "Address: low-level call failed");
266     }
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
269      * `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, 0, errorMessage);
279     }
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298     /**
299      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
300      * with `errorMessage` as a fallback revert reason when `target` reverts.
301      *
302      * _Available since v3.1._
303      */
304     function functionCallWithValue(
305         address target,
306         bytes memory data,
307         uint256 value,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(address(this).balance >= value, "Address: insufficient balance for call");
311         require(isContract(target), "Address: call to non-contract");
312         (bool success, bytes memory returndata) = target.call{value: value}(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a static call.
318      *
319      * _Available since v3.3._
320      */
321     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
322         return functionStaticCall(target, data, "Address: low-level static call failed");
323     }
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal view returns (bytes memory) {
335         require(isContract(target), "Address: static call to non-contract");
336         (bool success, bytes memory returndata) = target.staticcall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a delegate call.
342      *
343      * _Available since v3.4._
344      */
345     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
347     }
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
350      * but performing a delegate call.
351      *
352      * _Available since v3.4._
353      */
354     function functionDelegateCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal returns (bytes memory) {
359         require(isContract(target), "Address: delegate call to non-contract");
360         (bool success, bytes memory returndata) = target.delegatecall(data);
361         return verifyCallResult(success, returndata, errorMessage);
362     }
363     /**
364      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
365      * revert reason using the provided one.
366      *
367      * _Available since v4.3._
368      */
369     function verifyCallResult(
370         bool success,
371         bytes memory returndata,
372         string memory errorMessage
373     ) internal pure returns (bytes memory) {
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 // File: @openzeppelin/contracts/utils/Context.sol
391 /**
392  * @dev Provides information about the current execution context, including the
393  * sender of the transaction and its data. While these are generally available
394  * via msg.sender and msg.data, they should not be accessed in such a direct
395  * manner, since when dealing with meta-transactions the account sending and
396  * paying for execution may not be the actual sender (as far as an application
397  * is concerned).
398  *
399  * This contract is only required for intermediate, library-like contracts.
400  */
401 abstract contract Context {
402     function _msgSender() internal view virtual returns (address) {
403         return msg.sender;
404     }
405     function _msgData() internal view virtual returns (bytes calldata) {
406         return msg.data;
407     }
408 }
409 // File: @openzeppelin/contracts/utils/Strings.sol
410 /**
411  * @dev String operations.
412  */
413 library Strings {
414     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
415     /**
416      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
417      */
418     function toString(uint256 value) internal pure returns (string memory) {
419         // Inspired by OraclizeAPI's implementation - MIT licence
420         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
421         if (value == 0) {
422             return "0";
423         }
424         uint256 temp = value;
425         uint256 digits;
426         while (temp != 0) {
427             digits++;
428             temp /= 10;
429         }
430         bytes memory buffer = new bytes(digits);
431         while (value != 0) {
432             digits -= 1;
433             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
434             value /= 10;
435         }
436         return string(buffer);
437     }
438     /**
439      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
440      */
441     function toHexString(uint256 value) internal pure returns (string memory) {
442         if (value == 0) {
443             return "0x00";
444         }
445         uint256 temp = value;
446         uint256 length = 0;
447         while (temp != 0) {
448             length++;
449             temp >>= 8;
450         }
451         return toHexString(value, length);
452     }
453     /**
454      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
455      */
456     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
457         bytes memory buffer = new bytes(2 * length + 2);
458         buffer[0] = "0";
459         buffer[1] = "x";
460         for (uint256 i = 2 * length + 1; i > 1; --i) {
461             buffer[i] = _HEX_SYMBOLS[value & 0xf];
462             value >>= 4;
463         }
464         require(value == 0, "Strings: hex length insufficient");
465         return string(buffer);
466     }
467 }
468 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
469 /**
470  * @dev Implementation of the {IERC165} interface.
471  *
472  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
473  * for the additional interface id that will be supported. For example:
474  *
475  * ```solidity
476  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
477  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
478  * }
479  * ```
480  *
481  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
482  */
483 abstract contract ERC165 is IERC165 {
484     /**
485      * @dev See {IERC165-supportsInterface}.
486      */
487     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
488         return interfaceId == type(IERC165).interfaceId;
489     }
490 }
491 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
492 /**
493  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
494  * the Metadata extension, but not including the Enumerable extension, which is available separately as
495  * {ERC721Enumerable}.
496  */
497 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
498     using Address for address;
499     using Strings for uint256;
500     // Token name
501     string private _name;
502     // Token symbol
503     string private _symbol;
504     // Mapping from token ID to owner address
505     mapping(uint256 => address) private _owners;
506     // Mapping owner address to token count
507     mapping(address => uint256) private _balances;
508     // Mapping from token ID to approved address
509     mapping(uint256 => address) private _tokenApprovals;
510     // Mapping from owner to operator approvals
511     mapping(address => mapping(address => bool)) private _operatorApprovals;
512     /**
513      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
514      */
515     constructor(string memory name_, string memory symbol_) {
516         _name = name_;
517         _symbol = symbol_;
518     }
519     /**
520      * @dev See {IERC165-supportsInterface}.
521      */
522     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
523         return
524             interfaceId == type(IERC721).interfaceId ||
525             interfaceId == type(IERC721Metadata).interfaceId ||
526             super.supportsInterface(interfaceId);
527     }
528     /**
529      * @dev See {IERC721-balanceOf}.
530      */
531     function balanceOf(address owner) public view virtual override returns (uint256) {
532         require(owner != address(0), "ERC721: balance query for the zero address");
533         return _balances[owner];
534     }
535     /**
536      * @dev See {IERC721-ownerOf}.
537      */
538     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
539         address owner = _owners[tokenId];
540         require(owner != address(0), "ERC721: owner query for nonexistent token");
541         return owner;
542     }
543     /**
544      * @dev See {IERC721Metadata-name}.
545      */
546     function name() public view virtual override returns (string memory) {
547         return _name;
548     }
549     /**
550      * @dev See {IERC721Metadata-symbol}.
551      */
552     function symbol() public view virtual override returns (string memory) {
553         return _symbol;
554     }
555     /**
556      * @dev See {IERC721Metadata-tokenURI}.
557      */
558     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
559         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
560         string memory baseURI = _baseURI();
561         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
562     }
563     /**
564      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
565      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
566      * by default, can be overriden in child contracts.
567      */
568     function _baseURI() internal view virtual returns (string memory) {
569         return "";
570     }
571     /**
572      * @dev See {IERC721-approve}.
573      */
574     function approve(address to, uint256 tokenId) public virtual override {
575         address owner = ERC721.ownerOf(tokenId);
576         require(to != owner, "ERC721: approval to current owner");
577         require(
578             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
579             "ERC721: approve caller is not owner nor approved for all"
580         );
581         _approve(to, tokenId);
582     }
583     /**
584      * @dev See {IERC721-getApproved}.
585      */
586     function getApproved(uint256 tokenId) public view virtual override returns (address) {
587         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
588         return _tokenApprovals[tokenId];
589     }
590     /**
591      * @dev See {IERC721-setApprovalForAll}.
592      */
593     function setApprovalForAll(address operator, bool approved) public virtual override {
594         require(operator != _msgSender(), "ERC721: approve to caller");
595         _operatorApprovals[_msgSender()][operator] = approved;
596         emit ApprovalForAll(_msgSender(), operator, approved);
597     }
598     /**
599      * @dev See {IERC721-isApprovedForAll}.
600      */
601     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
602         return _operatorApprovals[owner][operator];
603     }
604     /**
605      * @dev See {IERC721-transferFrom}.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) public virtual override {
612         //solhint-disable-next-line max-line-length
613         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
614         _transfer(from, to, tokenId);
615     }
616     /**
617      * @dev See {IERC721-safeTransferFrom}.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) public virtual override {
624         safeTransferFrom(from, to, tokenId, "");
625     }
626     /**
627      * @dev See {IERC721-safeTransferFrom}.
628      */
629     function safeTransferFrom(
630         address from,
631         address to,
632         uint256 tokenId,
633         bytes memory _data
634     ) public virtual override {
635         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
636         _safeTransfer(from, to, tokenId, _data);
637     }
638     /**
639      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
640      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
641      *
642      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
643      *
644      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
645      * implement alternative mechanisms to perform token transfer, such as signature-based.
646      *
647      * Requirements:
648      *
649      * - `from` cannot be the zero address.
650      * - `to` cannot be the zero address.
651      * - `tokenId` token must exist and be owned by `from`.
652      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
653      *
654      * Emits a {Transfer} event.
655      */
656     function _safeTransfer(
657         address from,
658         address to,
659         uint256 tokenId,
660         bytes memory _data
661     ) internal virtual {
662         _transfer(from, to, tokenId);
663         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
664     }
665     /**
666      * @dev Returns whether `tokenId` exists.
667      *
668      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
669      *
670      * Tokens start existing when they are minted (`_mint`),
671      * and stop existing when they are burned (`_burn`).
672      */
673     function _exists(uint256 tokenId) internal view virtual returns (bool) {
674         return _owners[tokenId] != address(0);
675     }
676     /**
677      * @dev Returns whether `spender` is allowed to manage `tokenId`.
678      *
679      * Requirements:
680      *
681      * - `tokenId` must exist.
682      */
683     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
684         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
685         address owner = ERC721.ownerOf(tokenId);
686         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
687     }
688     /**
689      * @dev Safely mints `tokenId` and transfers it to `to`.
690      *
691      * Requirements:
692      *
693      * - `tokenId` must not exist.
694      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
695      *
696      * Emits a {Transfer} event.
697      */
698     function _safeMint(address to, uint256 tokenId) internal virtual {
699         _safeMint(to, tokenId, "");
700     }
701     /**
702      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
703      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
704      */
705     function _safeMint(
706         address to,
707         uint256 tokenId,
708         bytes memory _data
709     ) internal virtual {
710         _mint(to, tokenId);
711         require(
712             _checkOnERC721Received(address(0), to, tokenId, _data),
713             "ERC721: transfer to non ERC721Receiver implementer"
714         );
715     }
716     /**
717      * @dev Mints `tokenId` and transfers it to `to`.
718      *
719      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
720      *
721      * Requirements:
722      *
723      * - `tokenId` must not exist.
724      * - `to` cannot be the zero address.
725      *
726      * Emits a {Transfer} event.
727      */
728     function _mint(address to, uint256 tokenId) internal virtual {
729         require(to != address(0), "ERC721: mint to the zero address");
730         require(!_exists(tokenId), "ERC721: token already minted");
731         _beforeTokenTransfer(address(0), to, tokenId);
732         _balances[to] += 1;
733         _owners[tokenId] = to;
734         emit Transfer(address(0), to, tokenId);
735     }
736     /**
737      * @dev Destroys `tokenId`.
738      * The approval is cleared when the token is burned.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _burn(uint256 tokenId) internal virtual {
747         address owner = ERC721.ownerOf(tokenId);
748         _beforeTokenTransfer(owner, address(0), tokenId);
749         // Clear approvals
750         _approve(address(0), tokenId);
751         _balances[owner] -= 1;
752         delete _owners[tokenId];
753         emit Transfer(owner, address(0), tokenId);
754     }
755     /**
756      * @dev Transfers `tokenId` from `from` to `to`.
757      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
758      *
759      * Requirements:
760      *
761      * - `to` cannot be the zero address.
762      * - `tokenId` token must be owned by `from`.
763      *
764      * Emits a {Transfer} event.
765      */
766     function _transfer(
767         address from,
768         address to,
769         uint256 tokenId
770     ) internal virtual {
771         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
772         require(to != address(0), "ERC721: transfer to the zero address");
773         _beforeTokenTransfer(from, to, tokenId);
774         // Clear approvals from the previous owner
775         _approve(address(0), tokenId);
776         _balances[from] -= 1;
777         _balances[to] += 1;
778         _owners[tokenId] = to;
779         emit Transfer(from, to, tokenId);
780     }
781     /**
782      * @dev Approve `to` to operate on `tokenId`
783      *
784      * Emits a {Approval} event.
785      */
786     function _approve(address to, uint256 tokenId) internal virtual {
787         _tokenApprovals[tokenId] = to;
788         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
789     }
790     /**
791      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
792      * The call is not executed if the target address is not a contract.
793      *
794      * @param from address representing the previous owner of the given token ID
795      * @param to target address that will receive the tokens
796      * @param tokenId uint256 ID of the token to be transferred
797      * @param _data bytes optional data to send along with the call
798      * @return bool whether the call correctly returned the expected magic value
799      */
800     function _checkOnERC721Received(
801         address from,
802         address to,
803         uint256 tokenId,
804         bytes memory _data
805     ) private returns (bool) {
806         if (to.isContract()) {
807             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
808                 return retval == IERC721Receiver.onERC721Received.selector;
809             } catch (bytes memory reason) {
810                 if (reason.length == 0) {
811                     revert("ERC721: transfer to non ERC721Receiver implementer");
812                 } else {
813                     assembly {
814                         revert(add(32, reason), mload(reason))
815                     }
816                 }
817             }
818         } else {
819             return true;
820         }
821     }
822     /**
823      * @dev Hook that is called before any token transfer. This includes minting
824      * and burning.
825      *
826      * Calling conditions:
827      *
828      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
829      * transferred to `to`.
830      * - When `from` is zero, `tokenId` will be minted for `to`.
831      * - When `to` is zero, ``from``'s `tokenId` will be burned.
832      * - `from` and `to` are never both zero.
833      *
834      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
835      */
836     function _beforeTokenTransfer(
837         address from,
838         address to,
839         uint256 tokenId
840     ) internal virtual {}
841 }
842 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
843 /**
844  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
845  * @dev See https://eips.ethereum.org/EIPS/eip-721
846  */
847 interface IERC721Enumerable is IERC721 {
848     /**
849      * @dev Returns the total amount of tokens stored by the contract.
850      */
851     function totalSupply() external view returns (uint256);
852     /**
853      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
854      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
855      */
856     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
857     /**
858      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
859      * Use along with {totalSupply} to enumerate all tokens.
860      */
861     function tokenByIndex(uint256 index) external view returns (uint256);
862 }
863 // File: @openzeppelin/contracts/access/Ownable.sol
864 /**
865  * @dev Contract module which provides a basic access control mechanism, where
866  * there is an account (an owner) that can be granted exclusive access to
867  * specific functions.
868  *
869  * By default, the owner account will be the one that deploys the contract. This
870  * can later be changed with {transferOwnership}.
871  *
872  * This module is used through inheritance. It will make available the modifier
873  * `onlyOwner`, which can be applied to your functions to restrict their use to
874  * the owner.
875  */
876 abstract contract Ownable is Context {
877     address private _owner;
878     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
879     /**
880      * @dev Initializes the contract setting the deployer as the initial owner.
881      */
882     constructor() {
883         _setOwner(_msgSender());
884     }
885     /**
886      * @dev Returns the address of the current owner.
887      */
888     function owner() public view virtual returns (address) {
889         return _owner;
890     }
891     /**
892      * @dev Throws if called by any account other than the owner.
893      */
894     modifier onlyOwner() {
895         require(owner() == _msgSender(), "Ownable: caller is not the owner");
896         _;
897     }
898     /**
899      * @dev Leaves the contract without owner. It will not be possible to call
900      * `onlyOwner` functions anymore. Can only be called by the current owner.
901      *
902      * NOTE: Renouncing ownership will leave the contract without an owner,
903      * thereby removing any functionality that is only available to the owner.
904      */
905     function renounceOwnership() public virtual onlyOwner {
906         _setOwner(address(0));
907     }
908     /**
909      * @dev Transfers ownership of the contract to a new account (`newOwner`).
910      * Can only be called by the current owner.
911      */
912     function transferOwnership(address newOwner) public virtual onlyOwner {
913         require(newOwner != address(0), "Ownable: new owner is the zero address");
914         _setOwner(newOwner);
915     }
916     function _setOwner(address newOwner) private {
917         address oldOwner = _owner;
918         _owner = newOwner;
919         emit OwnershipTransferred(oldOwner, newOwner);
920     }
921 }
922 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
923 /**
924  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
925  *
926  * These functions can be used to verify that a message was signed by the holder
927  * of the private keys of a given address.
928  */
929 library ECDSA {
930     enum RecoverError {
931         NoError,
932         InvalidSignature,
933         InvalidSignatureLength,
934         InvalidSignatureS,
935         InvalidSignatureV
936     }
937     function _throwError(RecoverError error) private pure {
938         if (error == RecoverError.NoError) {
939             return; // no error: do nothing
940         } else if (error == RecoverError.InvalidSignature) {
941             revert("ECDSA: invalid signature");
942         } else if (error == RecoverError.InvalidSignatureLength) {
943             revert("ECDSA: invalid signature length");
944         } else if (error == RecoverError.InvalidSignatureS) {
945             revert("ECDSA: invalid signature 's' value");
946         } else if (error == RecoverError.InvalidSignatureV) {
947             revert("ECDSA: invalid signature 'v' value");
948         }
949     }
950     /**
951      * @dev Returns the address that signed a hashed message (`hash`) with
952      * `signature` or error string. This address can then be used for verification purposes.
953      *
954      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
955      * this function rejects them by requiring the `s` value to be in the lower
956      * half order, and the `v` value to be either 27 or 28.
957      *
958      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
959      * verification to be secure: it is possible to craft signatures that
960      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
961      * this is by receiving a hash of the original message (which may otherwise
962      * be too long), and then calling {toEthSignedMessageHash} on it.
963      *
964      * Documentation for signature generation:
965      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
966      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
967      *
968      * _Available since v4.3._
969      */
970     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
971         // Check the signature length
972         // - case 65: r,s,v signature (standard)
973         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
974         if (signature.length == 65) {
975             bytes32 r;
976             bytes32 s;
977             uint8 v;
978             // ecrecover takes the signature parameters, and the only way to get them
979             // currently is to use assembly.
980             assembly {
981                 r := mload(add(signature, 0x20))
982                 s := mload(add(signature, 0x40))
983                 v := byte(0, mload(add(signature, 0x60)))
984             }
985             return tryRecover(hash, v, r, s);
986         } else if (signature.length == 64) {
987             bytes32 r;
988             bytes32 vs;
989             // ecrecover takes the signature parameters, and the only way to get them
990             // currently is to use assembly.
991             assembly {
992                 r := mload(add(signature, 0x20))
993                 vs := mload(add(signature, 0x40))
994             }
995             return tryRecover(hash, r, vs);
996         } else {
997             return (address(0), RecoverError.InvalidSignatureLength);
998         }
999     }
1000     /**
1001      * @dev Returns the address that signed a hashed message (`hash`) with
1002      * `signature`. This address can then be used for verification purposes.
1003      *
1004      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1005      * this function rejects them by requiring the `s` value to be in the lower
1006      * half order, and the `v` value to be either 27 or 28.
1007      *
1008      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1009      * verification to be secure: it is possible to craft signatures that
1010      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1011      * this is by receiving a hash of the original message (which may otherwise
1012      * be too long), and then calling {toEthSignedMessageHash} on it.
1013      */
1014     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1015         (address recovered, RecoverError error) = tryRecover(hash, signature);
1016         _throwError(error);
1017         return recovered;
1018     }
1019     /**
1020      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1021      *
1022      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1023      *
1024      * _Available since v4.3._
1025      */
1026     function tryRecover(
1027         bytes32 hash,
1028         bytes32 r,
1029         bytes32 vs
1030     ) internal pure returns (address, RecoverError) {
1031         bytes32 s;
1032         uint8 v;
1033         assembly {
1034             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1035             v := add(shr(255, vs), 27)
1036         }
1037         return tryRecover(hash, v, r, s);
1038     }
1039     /**
1040      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1041      *
1042      * _Available since v4.2._
1043      */
1044     function recover(
1045         bytes32 hash,
1046         bytes32 r,
1047         bytes32 vs
1048     ) internal pure returns (address) {
1049         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1050         _throwError(error);
1051         return recovered;
1052     }
1053     /**
1054      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1055      * `r` and `s` signature fields separately.
1056      *
1057      * _Available since v4.3._
1058      */
1059     function tryRecover(
1060         bytes32 hash,
1061         uint8 v,
1062         bytes32 r,
1063         bytes32 s
1064     ) internal pure returns (address, RecoverError) {
1065         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1066         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1067         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1068         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1069         //
1070         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1071         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1072         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1073         // these malleable signatures as well.
1074         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1075             return (address(0), RecoverError.InvalidSignatureS);
1076         }
1077         if (v != 27 && v != 28) {
1078             return (address(0), RecoverError.InvalidSignatureV);
1079         }
1080         // If the signature is valid (and not malleable), return the signer address
1081         address signer = ecrecover(hash, v, r, s);
1082         if (signer == address(0)) {
1083             return (address(0), RecoverError.InvalidSignature);
1084         }
1085         return (signer, RecoverError.NoError);
1086     }
1087     /**
1088      * @dev Overload of {ECDSA-recover} that receives the `v`,
1089      * `r` and `s` signature fields separately.
1090      */
1091     function recover(
1092         bytes32 hash,
1093         uint8 v,
1094         bytes32 r,
1095         bytes32 s
1096     ) internal pure returns (address) {
1097         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1098         _throwError(error);
1099         return recovered;
1100     }
1101     /**
1102      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1103      * produces hash corresponding to the one signed with the
1104      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1105      * JSON-RPC method as part of EIP-191.
1106      *
1107      * See {recover}.
1108      */
1109     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1110         // 32 is the length in bytes of hash,
1111         // enforced by the type signature above
1112         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1113     }
1114     /**
1115      * @dev Returns an Ethereum Signed Typed Data, created from a
1116      * `domainSeparator` and a `structHash`. This produces hash corresponding
1117      * to the one signed with the
1118      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1119      * JSON-RPC method as part of EIP-712.
1120      *
1121      * See {recover}.
1122      */
1123     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1124         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1125     }
1126 }
1127 // File: contracts/ApeKidsFC.sol
1128 contract ApeKidsFC is ERC721, Ownable {
1129   using Strings for uint256;
1130   using ECDSA for bytes32;
1131   //AKC contract
1132   IERC721Enumerable akcContract;
1133   //NFT params
1134   string public baseURI;
1135   string public defaultURI;
1136   string public mycontractURI;
1137   bool public finalizeBaseUri = false;
1138   uint256 private currentSupply;
1139   //mint parameters
1140   uint256 public maxSupply = 12626;
1141   uint256[] public stagePrice = [0, 0.1626 ether, 0.1626 ether, 0.0926 ether,0.0926 ether, 0.1626 ether];  //price for each stage
1142   uint256[] public stageLimit = [0, 2627, 2627, 12626, 12626, 12626];    //mint limit for each stage
1143   address public signer;        //WL signing key
1144   mapping(uint256 => bool) public akcClaimed;   //whether an AKC tokenId has been claimed
1145   mapping(uint8 => mapping(address => uint8)) public mint_count;  //mint_count[stage][addr]
1146   //withdraw
1147   address[] fundRecipients = [
1148     0x261D83Bb62b54B4eBEAe76195b13d190e292e22f, 
1149     0xe778d58088967D9F62874f493Dd374266Dba248D
1150     ];
1151   uint256[] receivePercentagePt = [4500, 5500];
1152   //state
1153   bool public paused = false;
1154   uint8 public stage = 0;
1155   //royalty
1156   address public royaltyAddr;
1157   uint256 public royaltyBasis;
1158   constructor(
1159     string memory _name,
1160     string memory _symbol,
1161     string memory _initBaseURI,
1162     string memory _defaultURI,
1163     address _akc,
1164     address _signer,
1165     address _royaltyAddr, 
1166     uint256 _royaltyBasis
1167   ) ERC721(_name, _symbol) {
1168     setBaseURI(_initBaseURI);
1169     defaultURI = _defaultURI;
1170     akcContract = IERC721Enumerable(_akc);
1171     signer = _signer;
1172     royaltyAddr = _royaltyAddr;
1173     royaltyBasis = _royaltyBasis;
1174   }
1175   // internal
1176   function _baseURI() internal view virtual override returns (string memory) {
1177     return baseURI;
1178   }
1179   // public
1180   function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
1181       return interfaceId == 0xe8a3d485 /* contractURI() */ ||
1182       interfaceId == 0x2a55205a /* ERC-2981 royaltyInfo() */ ||
1183       super.supportsInterface(interfaceId);
1184   }
1185   function ownedAKC(uint256[] memory _tokenIdsToClaim) public view returns (bool) {
1186     for (uint256 i; i < _tokenIdsToClaim.length; i++) {
1187       if(akcContract.ownerOf(_tokenIdsToClaim[i]) != msg.sender)
1188         return false;
1189     }    
1190     return true;
1191   }
1192   function mint(uint8 mint_num, uint256[] memory _tokenIdsToClaim, uint8 wl_max, bytes memory signature) public payable {
1193     require(!paused, "Contract paused");
1194     require((stage>0) && (stage<=5), "Invalid stage");
1195     uint256 supply = totalSupply();
1196     require(mint_num > 0,"at least 1 mint");
1197     require(supply + mint_num <= stageLimit[stage], "Hit stage limit");
1198     require(msg.value >= mint_num * stagePrice[stage], "Insufficient eth");
1199     require(supply + mint_num <= maxSupply, "max supply reached");
1200     if(stage==1){
1201       require(mint_num + mint_count[stage][msg.sender] <= wl_max, "Exceed WL limit");
1202       require(signature.length > 0, "Missing signature");
1203       require(checkSig(msg.sender, wl_max, signature), "Invalid signature");
1204       mint_count[stage][msg.sender] += mint_num;
1205     }else if(stage==2){
1206       require(signature.length > 0, "Missing signature");
1207       require(checkSig(msg.sender, wl_max, signature), "Invalid signture");
1208     }else if(stage==3){
1209       require(mint_num == _tokenIdsToClaim.length, "Mint more than claim");
1210       for(uint256 i;i<_tokenIdsToClaim.length;i++){
1211         require(akcContract.ownerOf(_tokenIdsToClaim[i]) == msg.sender, "Not owner of claim");
1212         require(akcClaimed[_tokenIdsToClaim[i]] == false, "Already claimed");
1213         akcClaimed[_tokenIdsToClaim[i]] = true;
1214       }
1215     }else if(stage==4){
1216       require(ownedAKC(_tokenIdsToClaim), "Not owned");
1217     }else if(stage==5){
1218     }
1219     currentSupply += mint_num;
1220     for (uint256 i = 1; i <= mint_num; i++) {
1221       _safeMint(msg.sender, supply + i);
1222     }
1223   }
1224   function checkSig(address _addr, uint8 cnt, bytes memory signature) public view returns(bool){
1225     return signer == keccak256(abi.encodePacked('AKFC', _addr, cnt, stage)).recover(signature);
1226   }
1227   function tokensOfOwner(address _owner, uint startId, uint endId) external view returns(uint256[] memory ) {
1228     uint256 tokenCount = balanceOf(_owner);
1229     if (tokenCount == 0) {
1230         return new uint256[](0);
1231     } else {
1232         uint256[] memory result = new uint256[](tokenCount);
1233         uint256 index = 0;
1234         for (uint256 tokenId = startId; tokenId <= endId; tokenId++) {
1235             if (index == tokenCount) break;
1236             if (ownerOf(tokenId) == _owner) {
1237                 result[index] = tokenId;
1238                 index++;
1239             }
1240         }
1241         return result;
1242     }
1243   }
1244   function totalSupply() public view returns (uint256) {
1245     return currentSupply;
1246   }
1247   function tokenURI(uint256 tokenId)
1248     public
1249     view
1250     virtual
1251     override
1252     returns (string memory)
1253   {
1254     require(
1255       _exists(tokenId),
1256       "ERC721Metadata: URI query for nonexistent token"
1257     );
1258     string memory currentBaseURI = _baseURI();
1259     return bytes(currentBaseURI).length > 0
1260         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1261         : defaultURI;
1262   }
1263   function contractURI() public view returns (string memory) {
1264         return string(abi.encodePacked(mycontractURI));
1265   }
1266   //ERC-2981
1267   function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view 
1268   returns (address receiver, uint256 royaltyAmount){
1269     return (royaltyAddr, _salePrice * royaltyBasis / 10000);
1270   }
1271   //only owner functions ---
1272   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1273     require(!finalizeBaseUri);
1274     baseURI = _newBaseURI;
1275   }
1276   function finalizeBaseURI() public onlyOwner {
1277     finalizeBaseUri = true;
1278   }
1279   function setContractURI(string memory _contractURI) public onlyOwner {
1280     mycontractURI = _contractURI;
1281     //return format based on https://docs.opensea.io/docs/contract-level-metadata
1282   }
1283   function setRoyalty(address _royaltyAddr, uint256 _royaltyBasis) public onlyOwner {
1284     royaltyAddr = _royaltyAddr;
1285     royaltyBasis = _royaltyBasis;
1286   }
1287   function nextStage() public onlyOwner {
1288     require(stage<5);
1289     stage++;
1290   }
1291   function pause(bool _state) public onlyOwner {
1292     paused = _state;
1293   }
1294   function reserveMint(uint256 _mintAmount, address _to) public onlyOwner {    
1295     uint256 supply = totalSupply();
1296     require(supply + _mintAmount <= maxSupply, "max supply reached");
1297     currentSupply += _mintAmount;
1298     for (uint256 i = 1; i <= _mintAmount; i++) {
1299       _safeMint(_to, supply + i);
1300     }
1301   }
1302   //fund withdraw functions ---
1303   function withdrawFund() public onlyOwner {
1304     uint256 currentBal = address(this).balance;
1305     require(currentBal > 0);
1306     for (uint256 i = 0; i < fundRecipients.length-1; i++) {
1307       _withdraw(fundRecipients[i], currentBal * receivePercentagePt[i] / 10000);
1308     }
1309     //final address receives remainder to prevent ether dust
1310     _withdraw(fundRecipients[fundRecipients.length-1], address(this).balance);
1311   }
1312   function _withdraw(address _addr, uint256 _amt) private {
1313     (bool success,) = _addr.call{value: _amt}("");
1314     require(success, "Transfer failed");
1315   }
1316 }