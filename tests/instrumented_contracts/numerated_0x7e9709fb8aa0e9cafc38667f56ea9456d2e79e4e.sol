1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
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
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 pragma solidity ^0.8.0;
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
156 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @title ERC721 token receiver interface
162  * @dev Interface for any contract that wants to support safeTransfers
163  * from ERC721 asset contracts.
164  */
165 interface IERC721Receiver {
166     /**
167      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
168      * by `operator` from `from`, this function is called.
169      *
170      * It must return its Solidity selector to confirm the token transfer.
171      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
172      *
173      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
174      */
175     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
176 }
177 
178 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Metadata is IERC721 {
187 
188     /**
189      * @dev Returns the token collection name.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the token collection symbol.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
200      */
201     function tokenURI(uint256 tokenId) external view returns (string memory);
202 }
203 
204 // File: @openzeppelin/contracts/utils/Address.sol
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
394 // File: @openzeppelin/contracts/utils/Context.sol
395 
396 pragma solidity ^0.8.0;
397 
398 /*
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
412 
413     function _msgData() internal view virtual returns (bytes calldata) {
414         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
415         return msg.data;
416     }
417 }
418 
419 // File: @openzeppelin/contracts/utils/Strings.sol
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev String operations.
425  */
426 library Strings {
427     bytes16 private constant alphabet = "0123456789abcdef";
428 
429     /**
430      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
431      */
432     function toString(uint256 value) internal pure returns (string memory) {
433         // Inspired by OraclizeAPI's implementation - MIT licence
434         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
435 
436         if (value == 0) {
437             return "0";
438         }
439         uint256 temp = value;
440         uint256 digits;
441         while (temp != 0) {
442             digits++;
443             temp /= 10;
444         }
445         bytes memory buffer = new bytes(digits);
446         while (value != 0) {
447             digits -= 1;
448             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
449             value /= 10;
450         }
451         return string(buffer);
452     }
453 
454     /**
455      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
456      */
457     function toHexString(uint256 value) internal pure returns (string memory) {
458         if (value == 0) {
459             return "0x00";
460         }
461         uint256 temp = value;
462         uint256 length = 0;
463         while (temp != 0) {
464             length++;
465             temp >>= 8;
466         }
467         return toHexString(value, length);
468     }
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
472      */
473     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
474         bytes memory buffer = new bytes(2 * length + 2);
475         buffer[0] = "0";
476         buffer[1] = "x";
477         for (uint256 i = 2 * length + 1; i > 1; --i) {
478             buffer[i] = alphabet[value & 0xf];
479             value >>= 4;
480         }
481         require(value == 0, "Strings: hex length insufficient");
482         return string(buffer);
483     }
484 
485 }
486 
487 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @dev Implementation of the {IERC165} interface.
493  *
494  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
495  * for the additional interface id that will be supported. For example:
496  *
497  * ```solidity
498  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
499  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
500  * }
501  * ```
502  *
503  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
504  */
505 abstract contract ERC165 is IERC165 {
506     /**
507      * @dev See {IERC165-supportsInterface}.
508      */
509     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
510         return interfaceId == type(IERC165).interfaceId;
511     }
512 }
513 
514 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
515 
516 pragma solidity ^0.8.0;
517 
518 /**
519  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
520  * the Metadata extension, but not including the Enumerable extension, which is available separately as
521  * {ERC721Enumerable}.
522  */
523 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
524     using Address for address;
525     using Strings for uint256;
526 
527     // Token name
528     string private _name;
529 
530     // Token symbol
531     string private _symbol;
532 
533     // Mapping from token ID to owner address
534     mapping (uint256 => address) private _owners;
535 
536     // Mapping owner address to token count
537     mapping (address => uint256) private _balances;
538 
539     // Mapping from token ID to approved address
540     mapping (uint256 => address) private _tokenApprovals;
541 
542     // Mapping from owner to operator approvals
543     mapping (address => mapping (address => bool)) private _operatorApprovals;
544 
545     /**
546      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
547      */
548     constructor (string memory name_, string memory symbol_) {
549         _name = name_;
550         _symbol = symbol_;
551     }
552 
553     /**
554      * @dev See {IERC165-supportsInterface}.
555      */
556     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
557         return interfaceId == type(IERC721).interfaceId
558             || interfaceId == type(IERC721Metadata).interfaceId
559             || super.supportsInterface(interfaceId);
560     }
561 
562     /**
563      * @dev See {IERC721-balanceOf}.
564      */
565     function balanceOf(address owner) public view virtual override returns (uint256) {
566         require(owner != address(0), "ERC721: balance query for the zero address");
567         return _balances[owner];
568     }
569 
570     /**
571      * @dev See {IERC721-ownerOf}.
572      */
573     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
574         address owner = _owners[tokenId];
575         require(owner != address(0), "ERC721: owner query for nonexistent token");
576         return owner;
577     }
578 
579     /**
580      * @dev See {IERC721Metadata-name}.
581      */
582     function name() public view virtual override returns (string memory) {
583         return _name;
584     }
585 
586     /**
587      * @dev See {IERC721Metadata-symbol}.
588      */
589     function symbol() public view virtual override returns (string memory) {
590         return _symbol;
591     }
592 
593     /**
594      * @dev See {IERC721Metadata-tokenURI}.
595      */
596     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
597         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
598 
599         string memory baseURI = _baseURI();
600         return bytes(baseURI).length > 0
601             ? string(abi.encodePacked(baseURI, tokenId.toString()))
602             : '';
603     }
604 
605     /**
606      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
607      * in child contracts.
608      */
609     function _baseURI() internal view virtual returns (string memory) {
610         return "";
611     }
612 
613     /**
614      * @dev See {IERC721-approve}.
615      */
616     function approve(address to, uint256 tokenId) public virtual override {
617         address owner = ERC721.ownerOf(tokenId);
618         require(to != owner, "ERC721: approval to current owner");
619 
620         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
621             "ERC721: approve caller is not owner nor approved for all"
622         );
623 
624         _approve(to, tokenId);
625     }
626 
627     /**
628      * @dev See {IERC721-getApproved}.
629      */
630     function getApproved(uint256 tokenId) public view virtual override returns (address) {
631         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
632 
633         return _tokenApprovals[tokenId];
634     }
635 
636     /**
637      * @dev See {IERC721-setApprovalForAll}.
638      */
639     function setApprovalForAll(address operator, bool approved) public virtual override {
640         require(operator != _msgSender(), "ERC721: approve to caller");
641 
642         _operatorApprovals[_msgSender()][operator] = approved;
643         emit ApprovalForAll(_msgSender(), operator, approved);
644     }
645 
646     /**
647      * @dev See {IERC721-isApprovedForAll}.
648      */
649     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
650         return _operatorApprovals[owner][operator];
651     }
652 
653     /**
654      * @dev See {IERC721-transferFrom}.
655      */
656     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
657         //solhint-disable-next-line max-line-length
658         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
659 
660         _transfer(from, to, tokenId);
661     }
662 
663     /**
664      * @dev See {IERC721-safeTransferFrom}.
665      */
666     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
667         safeTransferFrom(from, to, tokenId, "");
668     }
669 
670     /**
671      * @dev See {IERC721-safeTransferFrom}.
672      */
673     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
674         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
675         _safeTransfer(from, to, tokenId, _data);
676     }
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
680      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
681      *
682      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
683      *
684      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
685      * implement alternative mechanisms to perform token transfer, such as signature-based.
686      *
687      * Requirements:
688      *
689      * - `from` cannot be the zero address.
690      * - `to` cannot be the zero address.
691      * - `tokenId` token must exist and be owned by `from`.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
697         _transfer(from, to, tokenId);
698         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
699     }
700 
701     /**
702      * @dev Returns whether `tokenId` exists.
703      *
704      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
705      *
706      * Tokens start existing when they are minted (`_mint`),
707      * and stop existing when they are burned (`_burn`).
708      */
709     function _exists(uint256 tokenId) internal view virtual returns (bool) {
710         return _owners[tokenId] != address(0);
711     }
712 
713     /**
714      * @dev Returns whether `spender` is allowed to manage `tokenId`.
715      *
716      * Requirements:
717      *
718      * - `tokenId` must exist.
719      */
720     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
721         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
722         address owner = ERC721.ownerOf(tokenId);
723         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
724     }
725 
726     /**
727      * @dev Safely mints `tokenId` and transfers it to `to`.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must not exist.
732      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
733      *
734      * Emits a {Transfer} event.
735      */
736     function _safeMint(address to, uint256 tokenId) internal virtual {
737         _safeMint(to, tokenId, "");
738     }
739 
740     /**
741      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
742      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
743      */
744     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
745         _mint(to, tokenId);
746         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
747     }
748 
749     /**
750      * @dev Mints `tokenId` and transfers it to `to`.
751      *
752      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
753      *
754      * Requirements:
755      *
756      * - `tokenId` must not exist.
757      * - `to` cannot be the zero address.
758      *
759      * Emits a {Transfer} event.
760      */
761     function _mint(address to, uint256 tokenId) internal virtual {
762         require(to != address(0), "ERC721: mint to the zero address");
763         require(!_exists(tokenId), "ERC721: token already minted");
764 
765         _beforeTokenTransfer(address(0), to, tokenId);
766 
767         _balances[to] += 1;
768         _owners[tokenId] = to;
769 
770         emit Transfer(address(0), to, tokenId);
771     }
772 
773     /**
774      * @dev Destroys `tokenId`.
775      * The approval is cleared when the token is burned.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must exist.
780      *
781      * Emits a {Transfer} event.
782      */
783     function _burn(uint256 tokenId) internal virtual {
784         address owner = ERC721.ownerOf(tokenId);
785 
786         _beforeTokenTransfer(owner, address(0), tokenId);
787 
788         // Clear approvals
789         _approve(address(0), tokenId);
790 
791         _balances[owner] -= 1;
792         delete _owners[tokenId];
793 
794         emit Transfer(owner, address(0), tokenId);
795     }
796 
797     /**
798      * @dev Transfers `tokenId` from `from` to `to`.
799      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
800      *
801      * Requirements:
802      *
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must be owned by `from`.
805      *
806      * Emits a {Transfer} event.
807      */
808     function _transfer(address from, address to, uint256 tokenId) internal virtual {
809         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
810         require(to != address(0), "ERC721: transfer to the zero address");
811 
812         _beforeTokenTransfer(from, to, tokenId);
813 
814         // Clear approvals from the previous owner
815         _approve(address(0), tokenId);
816 
817         _balances[from] -= 1;
818         _balances[to] += 1;
819         _owners[tokenId] = to;
820 
821         emit Transfer(from, to, tokenId);
822     }
823 
824     /**
825      * @dev Approve `to` to operate on `tokenId`
826      *
827      * Emits a {Approval} event.
828      */
829     function _approve(address to, uint256 tokenId) internal virtual {
830         _tokenApprovals[tokenId] = to;
831         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
832     }
833 
834     /**
835      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
836      * The call is not executed if the target address is not a contract.
837      *
838      * @param from address representing the previous owner of the given token ID
839      * @param to target address that will receive the tokens
840      * @param tokenId uint256 ID of the token to be transferred
841      * @param _data bytes optional data to send along with the call
842      * @return bool whether the call correctly returned the expected magic value
843      */
844     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
845         private returns (bool)
846     {
847         if (to.isContract()) {
848             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
849                 return retval == IERC721Receiver(to).onERC721Received.selector;
850             } catch (bytes memory reason) {
851                 if (reason.length == 0) {
852                     revert("ERC721: transfer to non ERC721Receiver implementer");
853                 } else {
854                     // solhint-disable-next-line no-inline-assembly
855                     assembly {
856                         revert(add(32, reason), mload(reason))
857                     }
858                 }
859             }
860         } else {
861             return true;
862         }
863     }
864 
865     /**
866      * @dev Hook that is called before any token transfer. This includes minting
867      * and burning.
868      *
869      * Calling conditions:
870      *
871      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
872      * transferred to `to`.
873      * - When `from` is zero, `tokenId` will be minted for `to`.
874      * - When `to` is zero, ``from``'s `tokenId` will be burned.
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      *
878      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
879      */
880     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
881 }
882 
883 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
884 
885 pragma solidity ^0.8.0;
886 
887 /**
888  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
889  * @dev See https://eips.ethereum.org/EIPS/eip-721
890  */
891 interface IERC721Enumerable is IERC721 {
892 
893     /**
894      * @dev Returns the total amount of tokens stored by the contract.
895      */
896     function totalSupply() external view returns (uint256);
897 
898     /**
899      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
900      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
901      */
902     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
903 
904     /**
905      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
906      * Use along with {totalSupply} to enumerate all tokens.
907      */
908     function tokenByIndex(uint256 index) external view returns (uint256);
909 }
910 
911 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
912 
913 pragma solidity ^0.8.0;
914 
915 /**
916  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
917  * enumerability of all the token ids in the contract as well as all token ids owned by each
918  * account.
919  */
920 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
921     // Mapping from owner to list of owned token IDs
922     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
923 
924     // Mapping from token ID to index of the owner tokens list
925     mapping(uint256 => uint256) private _ownedTokensIndex;
926 
927     // Array with all token ids, used for enumeration
928     uint256[] private _allTokens;
929 
930     // Mapping from token id to position in the allTokens array
931     mapping(uint256 => uint256) private _allTokensIndex;
932 
933     /**
934      * @dev See {IERC165-supportsInterface}.
935      */
936     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
937         return interfaceId == type(IERC721Enumerable).interfaceId
938             || super.supportsInterface(interfaceId);
939     }
940 
941     /**
942      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
943      */
944     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
945         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
946         return _ownedTokens[owner][index];
947     }
948 
949     /**
950      * @dev See {IERC721Enumerable-totalSupply}.
951      */
952     function totalSupply() public view virtual override returns (uint256) {
953         return _allTokens.length;
954     }
955 
956     /**
957      * @dev See {IERC721Enumerable-tokenByIndex}.
958      */
959     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
960         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
961         return _allTokens[index];
962     }
963 
964     /**
965      * @dev Hook that is called before any token transfer. This includes minting
966      * and burning.
967      *
968      * Calling conditions:
969      *
970      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
971      * transferred to `to`.
972      * - When `from` is zero, `tokenId` will be minted for `to`.
973      * - When `to` is zero, ``from``'s `tokenId` will be burned.
974      * - `from` cannot be the zero address.
975      * - `to` cannot be the zero address.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
980         super._beforeTokenTransfer(from, to, tokenId);
981 
982         if (from == address(0)) {
983             _addTokenToAllTokensEnumeration(tokenId);
984         } else if (from != to) {
985             _removeTokenFromOwnerEnumeration(from, tokenId);
986         }
987         if (to == address(0)) {
988             _removeTokenFromAllTokensEnumeration(tokenId);
989         } else if (to != from) {
990             _addTokenToOwnerEnumeration(to, tokenId);
991         }
992     }
993 
994     /**
995      * @dev Private function to add a token to this extension's ownership-tracking data structures.
996      * @param to address representing the new owner of the given token ID
997      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
998      */
999     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1000         uint256 length = ERC721.balanceOf(to);
1001         _ownedTokens[to][length] = tokenId;
1002         _ownedTokensIndex[tokenId] = length;
1003     }
1004 
1005     /**
1006      * @dev Private function to add a token to this extension's token tracking data structures.
1007      * @param tokenId uint256 ID of the token to be added to the tokens list
1008      */
1009     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1010         _allTokensIndex[tokenId] = _allTokens.length;
1011         _allTokens.push(tokenId);
1012     }
1013 
1014     /**
1015      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1016      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1017      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1018      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1019      * @param from address representing the previous owner of the given token ID
1020      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1021      */
1022     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1023         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1024         // then delete the last slot (swap and pop).
1025 
1026         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1027         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1028 
1029         // When the token to delete is the last token, the swap operation is unnecessary
1030         if (tokenIndex != lastTokenIndex) {
1031             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1032 
1033             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1034             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1035         }
1036 
1037         // This also deletes the contents at the last position of the array
1038         delete _ownedTokensIndex[tokenId];
1039         delete _ownedTokens[from][lastTokenIndex];
1040     }
1041 
1042     /**
1043      * @dev Private function to remove a token from this extension's token tracking data structures.
1044      * This has O(1) time complexity, but alters the order of the _allTokens array.
1045      * @param tokenId uint256 ID of the token to be removed from the tokens list
1046      */
1047     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1048         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1049         // then delete the last slot (swap and pop).
1050 
1051         uint256 lastTokenIndex = _allTokens.length - 1;
1052         uint256 tokenIndex = _allTokensIndex[tokenId];
1053 
1054         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1055         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1056         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1057         uint256 lastTokenId = _allTokens[lastTokenIndex];
1058 
1059         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1060         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1061 
1062         // This also deletes the contents at the last position of the array
1063         delete _allTokensIndex[tokenId];
1064         _allTokens.pop();
1065     }
1066 }
1067 
1068 // File: @openzeppelin/contracts/access/Ownable.sol
1069 
1070 pragma solidity ^0.8.0;
1071 
1072 /**
1073  * @dev Contract module which provides a basic access control mechanism, where
1074  * there is an account (an owner) that can be granted exclusive access to
1075  * specific functions.
1076  *
1077  * By default, the owner account will be the one that deploys the contract. This
1078  * can later be changed with {transferOwnership}.
1079  *
1080  * This module is used through inheritance. It will make available the modifier
1081  * `onlyOwner`, which can be applied to your functions to restrict their use to
1082  * the owner.
1083  */
1084 abstract contract Ownable is Context {
1085     address private _owner;
1086 
1087     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1088 
1089     /**
1090      * @dev Initializes the contract setting the deployer as the initial owner.
1091      */
1092     constructor () {
1093         address msgSender = _msgSender();
1094         _owner = msgSender;
1095         emit OwnershipTransferred(address(0), msgSender);
1096     }
1097 
1098     /**
1099      * @dev Returns the address of the current owner.
1100      */
1101     function owner() public view virtual returns (address) {
1102         return _owner;
1103     }
1104 
1105     /**
1106      * @dev Throws if called by any account other than the owner.
1107      */
1108     modifier onlyOwner() {
1109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1110         _;
1111     }
1112 
1113     /**
1114      * @dev Leaves the contract without owner. It will not be possible to call
1115      * `onlyOwner` functions anymore. Can only be called by the current owner.
1116      *
1117      * NOTE: Renouncing ownership will leave the contract without an owner,
1118      * thereby removing any functionality that is only available to the owner.
1119      */
1120     function renounceOwnership() public virtual onlyOwner {
1121         emit OwnershipTransferred(_owner, address(0));
1122         _owner = address(0);
1123     }
1124 
1125     /**
1126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1127      * Can only be called by the current owner.
1128      */
1129     function transferOwnership(address newOwner) public virtual onlyOwner {
1130         require(newOwner != address(0), "Ownable: new owner is the zero address");
1131         emit OwnershipTransferred(_owner, newOwner);
1132         _owner = newOwner;
1133     }
1134 }
1135 
1136 // File: contracts/WickedLoot.sol
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 abstract contract TWC {
1141   function ownerOf(uint256 tokenId) public virtual view returns (address);
1142   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1143   function balanceOf(address owner) external virtual view returns (uint256 balance);
1144 }
1145 
1146 contract WickedLoot is ERC721Enumerable, Ownable {  
1147   
1148   TWC private twc = TWC(0x85f740958906b317de6ed79663012859067E745B); 
1149   string public WickedLootProvenance;
1150   bool public saleIsActive = false;
1151   uint256 public maxLoot = 10762;
1152   string private baseURI;
1153 
1154   constructor() ERC721("TheWickedLoot", "WICKEDLOOT") {
1155   }
1156 
1157   function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1158     WickedLootProvenance = provenanceHash;
1159   }
1160 
1161   function isMinted(uint256 tokenId) external view returns (bool) {
1162     require(tokenId < maxLoot, "tokenId outside collection bounds");
1163     return _exists(tokenId);
1164   }
1165 
1166   function _baseURI() internal view override returns (string memory) {
1167     return baseURI;
1168   }
1169   
1170   function setBaseURI(string memory uri) public onlyOwner {
1171     baseURI = uri;
1172   }
1173 
1174   function flipSaleState() public onlyOwner {
1175     saleIsActive = !saleIsActive;
1176   }
1177 
1178   function mintLoot(uint256 startingIndex, uint256 totalLootToMint) public {
1179     require(saleIsActive, "Sale must be active to mint a Loot");
1180     require(totalLootToMint > 0, "Must mint at least one Loot");
1181     uint balance = twc.balanceOf(msg.sender);
1182     require(balance > 0, "Must hold at least one Cranium to mint a Loot");
1183     require(balance >= totalLootToMint, "Must hold at least as many Craniums as the number of Loot you intend to mint");
1184     require(balance >= startingIndex + totalLootToMint, "Must hold at least as many Craniums as the number of Loot you intend to mint");
1185 
1186     for(uint i = 0; i < balance && i < totalLootToMint; i++) {
1187       require(totalSupply() < maxLoot, "Cannot exceed max supply of Loot");
1188       uint tokenId = twc.tokenOfOwnerByIndex(msg.sender, i + startingIndex);
1189       if (!_exists(tokenId)) {
1190         _safeMint(msg.sender, tokenId);
1191       }
1192     }
1193   }
1194 
1195 
1196   function ownerMint(address[] memory ads, uint[] memory ids) public onlyOwner {
1197     for(uint i = 0; i < ads.length; i++) {
1198         _safeMint(ads[i], ids[i]);
1199     }
1200   }
1201 }