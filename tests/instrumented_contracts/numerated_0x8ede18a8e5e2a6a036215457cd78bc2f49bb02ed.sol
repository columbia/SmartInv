1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-26
3 */
4 
5 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
33 
34 
35 
36 pragma solidity ^0.8.0;
37 
38 
39 /**
40  * @dev Required interface of an ERC721 compliant contract.
41  */
42 interface IERC721 is IERC165 {
43     /**
44      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
50      */
51     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
52 
53     /**
54      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
55      */
56     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
57 
58     /**
59      * @dev Returns the number of tokens in ``owner``'s account.
60      */
61     function balanceOf(address owner) external view returns (uint256 balance);
62 
63     /**
64      * @dev Returns the owner of the `tokenId` token.
65      *
66      * Requirements:
67      *
68      * - `tokenId` must exist.
69      */
70     function ownerOf(uint256 tokenId) external view returns (address owner);
71 
72     /**
73      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
74      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
75      *
76      * Requirements:
77      *
78      * - `from` cannot be the zero address.
79      * - `to` cannot be the zero address.
80      * - `tokenId` token must exist and be owned by `from`.
81      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
82      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
83      *
84      * Emits a {Transfer} event.
85      */
86     function safeTransferFrom(address from, address to, uint256 tokenId) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(address from, address to, uint256 tokenId) external;
103 
104     /**
105      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
106      * The approval is cleared when the token is transferred.
107      *
108      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
109      *
110      * Requirements:
111      *
112      * - The caller must own the token or be an approved operator.
113      * - `tokenId` must exist.
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address to, uint256 tokenId) external;
118 
119     /**
120      * @dev Returns the account approved for `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function getApproved(uint256 tokenId) external view returns (address operator);
127 
128     /**
129      * @dev Approve or remove `operator` as an operator for the caller.
130      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
131      *
132      * Requirements:
133      *
134      * - The `operator` cannot be the caller.
135      *
136      * Emits an {ApprovalForAll} event.
137      */
138     function setApprovalForAll(address operator, bool _approved) external;
139 
140     /**
141      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
142      *
143      * See {setApprovalForAll}
144      */
145     function isApprovedForAll(address owner, address operator) external view returns (bool);
146 
147     /**
148       * @dev Safely transfers `tokenId` token from `from` to `to`.
149       *
150       * Requirements:
151       *
152       * - `from` cannot be the zero address.
153       * - `to` cannot be the zero address.
154       * - `tokenId` token must exist and be owned by `from`.
155       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157       *
158       * Emits a {Transfer} event.
159       */
160     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
164 
165 
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @title ERC721 token receiver interface
171  * @dev Interface for any contract that wants to support safeTransfers
172  * from ERC721 asset contracts.
173  */
174 interface IERC721Receiver {
175     /**
176      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
177      * by `operator` from `from`, this function is called.
178      *
179      * It must return its Solidity selector to confirm the token transfer.
180      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
181      *
182      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
183      */
184     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
185 }
186 
187 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
188 
189 
190 
191 pragma solidity ^0.8.0;
192 
193 
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Metadata is IERC721 {
199 
200     /**
201      * @dev Returns the token collection name.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the token collection symbol.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
212      */
213     function tokenURI(uint256 tokenId) external view returns (string memory);
214 }
215 
216 // File: @openzeppelin/contracts/utils/Address.sol
217 
218 
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev Collection of functions related to the address type
224  */
225 library Address {
226     /**
227      * @dev Returns true if `account` is a contract.
228      *
229      * [IMPORTANT]
230      * ====
231      * It is unsafe to assume that an address for which this function returns
232      * false is an externally-owned account (EOA) and not a contract.
233      *
234      * Among others, `isContract` will return false for the following
235      * types of addresses:
236      *
237      *  - an externally-owned account
238      *  - a contract in construction
239      *  - an address where a contract will be created
240      *  - an address where a contract lived, but was destroyed
241      * ====
242      */
243     function isContract(address account) internal view returns (bool) {
244         // This method relies on extcodesize, which returns 0 for contracts in
245         // construction, since the code is only stored at the end of the
246         // constructor execution.
247 
248         uint256 size;
249         // solhint-disable-next-line no-inline-assembly
250         assembly { size := extcodesize(account) }
251         return size > 0;
252     }
253 
254     /**
255      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
256      * `recipient`, forwarding all available gas and reverting on errors.
257      *
258      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
259      * of certain opcodes, possibly making contracts go over the 2300 gas limit
260      * imposed by `transfer`, making them unable to receive funds via
261      * `transfer`. {sendValue} removes this limitation.
262      *
263      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
264      *
265      * IMPORTANT: because control is transferred to `recipient`, care must be
266      * taken to not create reentrancy vulnerabilities. Consider using
267      * {ReentrancyGuard} or the
268      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
269      */
270     function sendValue(address payable recipient, uint256 amount) internal {
271         require(address(this).balance >= amount, "Address: insufficient balance");
272 
273         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
274         (bool success, ) = recipient.call{ value: amount }("");
275         require(success, "Address: unable to send value, recipient may have reverted");
276     }
277 
278     /**
279      * @dev Performs a Solidity function call using a low level `call`. A
280      * plain`call` is an unsafe replacement for a function call: use this
281      * function instead.
282      *
283      * If `target` reverts with a revert reason, it is bubbled up by this
284      * function (like regular Solidity function calls).
285      *
286      * Returns the raw returned data. To convert to the expected return value,
287      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
288      *
289      * Requirements:
290      *
291      * - `target` must be a contract.
292      * - calling `target` with `data` must not revert.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
297       return functionCall(target, data, "Address: low-level call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
302      * `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, 0, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but also transferring `value` wei to `target`.
313      *
314      * Requirements:
315      *
316      * - the calling contract must have an ETH balance of at least `value`.
317      * - the called Solidity function must be `payable`.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
327      * with `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         require(isContract(target), "Address: call to non-contract");
334 
335         // solhint-disable-next-line avoid-low-level-calls
336         (bool success, bytes memory returndata) = target.call{ value: value }(data);
337         return _verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but performing a static call.
343      *
344      * _Available since v3.3._
345      */
346     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
347         return functionStaticCall(target, data, "Address: low-level static call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
352      * but performing a static call.
353      *
354      * _Available since v3.3._
355      */
356     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
357         require(isContract(target), "Address: static call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.staticcall(data);
361         return _verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a delegate call.
377      *
378      * _Available since v3.4._
379      */
380     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
381         require(isContract(target), "Address: delegate call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.delegatecall(data);
385         return _verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 // File: @openzeppelin/contracts/utils/Context.sol
409 
410 
411 
412 pragma solidity ^0.8.0;
413 
414 /*
415  * @dev Provides information about the current execution context, including the
416  * sender of the transaction and its data. While these are generally available
417  * via msg.sender and msg.data, they should not be accessed in such a direct
418  * manner, since when dealing with meta-transactions the account sending and
419  * paying for execution may not be the actual sender (as far as an application
420  * is concerned).
421  *
422  * This contract is only required for intermediate, library-like contracts.
423  */
424 abstract contract Context {
425     function _msgSender() internal view virtual returns (address) {
426         return msg.sender;
427     }
428 
429     function _msgData() internal view virtual returns (bytes calldata) {
430         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
431         return msg.data;
432     }
433 }
434 
435 // File: @openzeppelin/contracts/utils/Strings.sol
436 
437 
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev String operations.
443  */
444 library Strings {
445     bytes16 private constant alphabet = "0123456789abcdef";
446 
447     /**
448      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
449      */
450     function toString(uint256 value) internal pure returns (string memory) {
451         // Inspired by OraclizeAPI's implementation - MIT licence
452         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
453 
454         if (value == 0) {
455             return "0";
456         }
457         uint256 temp = value;
458         uint256 digits;
459         while (temp != 0) {
460             digits++;
461             temp /= 10;
462         }
463         bytes memory buffer = new bytes(digits);
464         while (value != 0) {
465             digits -= 1;
466             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
467             value /= 10;
468         }
469         return string(buffer);
470     }
471 
472     /**
473      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
474      */
475     function toHexString(uint256 value) internal pure returns (string memory) {
476         if (value == 0) {
477             return "0x00";
478         }
479         uint256 temp = value;
480         uint256 length = 0;
481         while (temp != 0) {
482             length++;
483             temp >>= 8;
484         }
485         return toHexString(value, length);
486     }
487 
488     /**
489      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
490      */
491     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
492         bytes memory buffer = new bytes(2 * length + 2);
493         buffer[0] = "0";
494         buffer[1] = "x";
495         for (uint256 i = 2 * length + 1; i > 1; --i) {
496             buffer[i] = alphabet[value & 0xf];
497             value >>= 4;
498         }
499         require(value == 0, "Strings: hex length insufficient");
500         return string(buffer);
501     }
502 
503 }
504 
505 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
506 
507 
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Implementation of the {IERC165} interface.
514  *
515  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
516  * for the additional interface id that will be supported. For example:
517  *
518  * ```solidity
519  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
521  * }
522  * ```
523  *
524  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
525  */
526 abstract contract ERC165 is IERC165 {
527     /**
528      * @dev See {IERC165-supportsInterface}.
529      */
530     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
531         return interfaceId == type(IERC165).interfaceId;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
536 
537 
538 
539 pragma solidity ^0.8.0;
540 
541 
542 
543 
544 
545 
546 
547 
548 /**
549  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
550  * the Metadata extension, but not including the Enumerable extension, which is available separately as
551  * {ERC721Enumerable}.
552  */
553 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
554     using Address for address;
555     using Strings for uint256;
556 
557     // Token name
558     string private _name;
559 
560     // Token symbol
561     string private _symbol;
562 
563     // Mapping from token ID to owner address
564     mapping (uint256 => address) private _owners;
565 
566     // Mapping owner address to token count
567     mapping (address => uint256) private _balances;
568 
569     // Mapping from token ID to approved address
570     mapping (uint256 => address) private _tokenApprovals;
571 
572     // Mapping from owner to operator approvals
573     mapping (address => mapping (address => bool)) private _operatorApprovals;
574 
575     /**
576      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
577      */
578     constructor (string memory name_, string memory symbol_) {
579         _name = name_;
580         _symbol = symbol_;
581     }
582 
583     /**
584      * @dev See {IERC165-supportsInterface}.
585      */
586     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
587         return interfaceId == type(IERC721).interfaceId
588             || interfaceId == type(IERC721Metadata).interfaceId
589             || super.supportsInterface(interfaceId);
590     }
591 
592     /**
593      * @dev See {IERC721-balanceOf}.
594      */
595     function balanceOf(address owner) public view virtual override returns (uint256) {
596         require(owner != address(0), "ERC721: balance query for the zero address");
597         return _balances[owner];
598     }
599 
600     /**
601      * @dev See {IERC721-ownerOf}.
602      */
603     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
604         address owner = _owners[tokenId];
605         require(owner != address(0), "ERC721: owner query for nonexistent token");
606         return owner;
607     }
608 
609     /**
610      * @dev See {IERC721Metadata-name}.
611      */
612     function name() public view virtual override returns (string memory) {
613         return _name;
614     }
615 
616     /**
617      * @dev See {IERC721Metadata-symbol}.
618      */
619     function symbol() public view virtual override returns (string memory) {
620         return _symbol;
621     }
622 
623     /**
624      * @dev See {IERC721Metadata-tokenURI}.
625      */
626     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
627         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
628 
629         string memory baseURI = _baseURI();
630         return bytes(baseURI).length > 0
631             ? string(abi.encodePacked(baseURI, tokenId.toString()))
632             : '';
633     }
634 
635     /**
636      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
637      * in child contracts.
638      */
639     function _baseURI() internal view virtual returns (string memory) {
640         return "";
641     }
642 
643     /**
644      * @dev See {IERC721-approve}.
645      */
646     function approve(address to, uint256 tokenId) public virtual override {
647         address owner = ERC721.ownerOf(tokenId);
648         require(to != owner, "ERC721: approval to current owner");
649 
650         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
651             "ERC721: approve caller is not owner nor approved for all"
652         );
653 
654         _approve(to, tokenId);
655     }
656 
657     /**
658      * @dev See {IERC721-getApproved}.
659      */
660     function getApproved(uint256 tokenId) public view virtual override returns (address) {
661         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
662 
663         return _tokenApprovals[tokenId];
664     }
665 
666     /**
667      * @dev See {IERC721-setApprovalForAll}.
668      */
669     function setApprovalForAll(address operator, bool approved) public virtual override {
670         require(operator != _msgSender(), "ERC721: approve to caller");
671 
672         _operatorApprovals[_msgSender()][operator] = approved;
673         emit ApprovalForAll(_msgSender(), operator, approved);
674     }
675 
676     /**
677      * @dev See {IERC721-isApprovedForAll}.
678      */
679     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
680         return _operatorApprovals[owner][operator];
681     }
682 
683     /**
684      * @dev See {IERC721-transferFrom}.
685      */
686     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
687         //solhint-disable-next-line max-line-length
688         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
689 
690         _transfer(from, to, tokenId);
691     }
692 
693     /**
694      * @dev See {IERC721-safeTransferFrom}.
695      */
696     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
697         safeTransferFrom(from, to, tokenId, "");
698     }
699 
700     /**
701      * @dev See {IERC721-safeTransferFrom}.
702      */
703     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
704         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
705         _safeTransfer(from, to, tokenId, _data);
706     }
707 
708     /**
709      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
710      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
711      *
712      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
713      *
714      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
715      * implement alternative mechanisms to perform token transfer, such as signature-based.
716      *
717      * Requirements:
718      *
719      * - `from` cannot be the zero address.
720      * - `to` cannot be the zero address.
721      * - `tokenId` token must exist and be owned by `from`.
722      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
723      *
724      * Emits a {Transfer} event.
725      */
726     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
727         _transfer(from, to, tokenId);
728         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
729     }
730 
731     /**
732      * @dev Returns whether `tokenId` exists.
733      *
734      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
735      *
736      * Tokens start existing when they are minted (`_mint`),
737      * and stop existing when they are burned (`_burn`).
738      */
739     function _exists(uint256 tokenId) internal view virtual returns (bool) {
740         return _owners[tokenId] != address(0);
741     }
742 
743     /**
744      * @dev Returns whether `spender` is allowed to manage `tokenId`.
745      *
746      * Requirements:
747      *
748      * - `tokenId` must exist.
749      */
750     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
751         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
752         address owner = ERC721.ownerOf(tokenId);
753         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
754     }
755 
756     /**
757      * @dev Safely mints `tokenId` and transfers it to `to`.
758      *
759      * Requirements:
760      *
761      * - `tokenId` must not exist.
762      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
763      *
764      * Emits a {Transfer} event.
765      */
766     function _safeMint(address to, uint256 tokenId) internal virtual {
767         _safeMint(to, tokenId, "");
768     }
769 
770     /**
771      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
772      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
773      */
774     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
775         _mint(to, tokenId);
776         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
777     }
778 
779     /**
780      * @dev Mints `tokenId` and transfers it to `to`.
781      *
782      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
783      *
784      * Requirements:
785      *
786      * - `tokenId` must not exist.
787      * - `to` cannot be the zero address.
788      *
789      * Emits a {Transfer} event.
790      */
791     function _mint(address to, uint256 tokenId) internal virtual {
792         require(to != address(0), "ERC721: mint to the zero address");
793         require(!_exists(tokenId), "ERC721: token already minted");
794 
795         _beforeTokenTransfer(address(0), to, tokenId);
796 
797         _balances[to] += 1;
798         _owners[tokenId] = to;
799 
800         emit Transfer(address(0), to, tokenId);
801     }
802 
803     /**
804      * @dev Destroys `tokenId`.
805      * The approval is cleared when the token is burned.
806      *
807      * Requirements:
808      *
809      * - `tokenId` must exist.
810      *
811      * Emits a {Transfer} event.
812      */
813     function _burn(uint256 tokenId) internal virtual {
814         address owner = ERC721.ownerOf(tokenId);
815 
816         _beforeTokenTransfer(owner, address(0), tokenId);
817 
818         // Clear approvals
819         _approve(address(0), tokenId);
820 
821         _balances[owner] -= 1;
822         delete _owners[tokenId];
823 
824         emit Transfer(owner, address(0), tokenId);
825     }
826 
827     /**
828      * @dev Transfers `tokenId` from `from` to `to`.
829      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
830      *
831      * Requirements:
832      *
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must be owned by `from`.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _transfer(address from, address to, uint256 tokenId) internal virtual {
839         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
840         require(to != address(0), "ERC721: transfer to the zero address");
841 
842         _beforeTokenTransfer(from, to, tokenId);
843 
844         // Clear approvals from the previous owner
845         _approve(address(0), tokenId);
846 
847         _balances[from] -= 1;
848         _balances[to] += 1;
849         _owners[tokenId] = to;
850 
851         emit Transfer(from, to, tokenId);
852     }
853 
854     /**
855      * @dev Approve `to` to operate on `tokenId`
856      *
857      * Emits a {Approval} event.
858      */
859     function _approve(address to, uint256 tokenId) internal virtual {
860         _tokenApprovals[tokenId] = to;
861         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
862     }
863 
864     /**
865      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
866      * The call is not executed if the target address is not a contract.
867      *
868      * @param from address representing the previous owner of the given token ID
869      * @param to target address that will receive the tokens
870      * @param tokenId uint256 ID of the token to be transferred
871      * @param _data bytes optional data to send along with the call
872      * @return bool whether the call correctly returned the expected magic value
873      */
874     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
875         private returns (bool)
876     {
877         if (to.isContract()) {
878             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
879                 return retval == IERC721Receiver(to).onERC721Received.selector;
880             } catch (bytes memory reason) {
881                 if (reason.length == 0) {
882                     revert("ERC721: transfer to non ERC721Receiver implementer");
883                 } else {
884                     // solhint-disable-next-line no-inline-assembly
885                     assembly {
886                         revert(add(32, reason), mload(reason))
887                     }
888                 }
889             }
890         } else {
891             return true;
892         }
893     }
894 
895     /**
896      * @dev Hook that is called before any token transfer. This includes minting
897      * and burning.
898      *
899      * Calling conditions:
900      *
901      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
902      * transferred to `to`.
903      * - When `from` is zero, `tokenId` will be minted for `to`.
904      * - When `to` is zero, ``from``'s `tokenId` will be burned.
905      * - `from` cannot be the zero address.
906      * - `to` cannot be the zero address.
907      *
908      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
909      */
910     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
911 }
912 
913 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
914 
915 
916 
917 pragma solidity ^0.8.0;
918 
919 
920 /**
921  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
922  * @dev See https://eips.ethereum.org/EIPS/eip-721
923  */
924 interface IERC721Enumerable is IERC721 {
925 
926     /**
927      * @dev Returns the total amount of tokens stored by the contract.
928      */
929     function totalSupply() external view returns (uint256);
930 
931     /**
932      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
933      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
934      */
935     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
936 
937     /**
938      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
939      * Use along with {totalSupply} to enumerate all tokens.
940      */
941     function tokenByIndex(uint256 index) external view returns (uint256);
942 }
943 
944 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
945 
946 
947 
948 pragma solidity ^0.8.0;
949 
950 
951 
952 /**
953  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
954  * enumerability of all the token ids in the contract as well as all token ids owned by each
955  * account.
956  */
957 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
958     // Mapping from owner to list of owned token IDs
959     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
960 
961     // Mapping from token ID to index of the owner tokens list
962     mapping(uint256 => uint256) private _ownedTokensIndex;
963 
964     // Array with all token ids, used for enumeration
965     uint256[] private _allTokens;
966 
967     // Mapping from token id to position in the allTokens array
968     mapping(uint256 => uint256) private _allTokensIndex;
969 
970     /**
971      * @dev See {IERC165-supportsInterface}.
972      */
973     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
974         return interfaceId == type(IERC721Enumerable).interfaceId
975             || super.supportsInterface(interfaceId);
976     }
977 
978     /**
979      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
980      */
981     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
982         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
983         return _ownedTokens[owner][index];
984     }
985 
986     /**
987      * @dev See {IERC721Enumerable-totalSupply}.
988      */
989     function totalSupply() public view virtual override returns (uint256) {
990         return _allTokens.length;
991     }
992 
993     /**
994      * @dev See {IERC721Enumerable-tokenByIndex}.
995      */
996     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
997         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
998         return _allTokens[index];
999     }
1000 
1001     /**
1002      * @dev Hook that is called before any token transfer. This includes minting
1003      * and burning.
1004      *
1005      * Calling conditions:
1006      *
1007      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1008      * transferred to `to`.
1009      * - When `from` is zero, `tokenId` will be minted for `to`.
1010      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1011      * - `from` cannot be the zero address.
1012      * - `to` cannot be the zero address.
1013      *
1014      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1015      */
1016     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1017         super._beforeTokenTransfer(from, to, tokenId);
1018 
1019         if (from == address(0)) {
1020             _addTokenToAllTokensEnumeration(tokenId);
1021         } else if (from != to) {
1022             _removeTokenFromOwnerEnumeration(from, tokenId);
1023         }
1024         if (to == address(0)) {
1025             _removeTokenFromAllTokensEnumeration(tokenId);
1026         } else if (to != from) {
1027             _addTokenToOwnerEnumeration(to, tokenId);
1028         }
1029     }
1030 
1031     /**
1032      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1033      * @param to address representing the new owner of the given token ID
1034      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1035      */
1036     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1037         uint256 length = ERC721.balanceOf(to);
1038         _ownedTokens[to][length] = tokenId;
1039         _ownedTokensIndex[tokenId] = length;
1040     }
1041 
1042     /**
1043      * @dev Private function to add a token to this extension's token tracking data structures.
1044      * @param tokenId uint256 ID of the token to be added to the tokens list
1045      */
1046     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1047         _allTokensIndex[tokenId] = _allTokens.length;
1048         _allTokens.push(tokenId);
1049     }
1050 
1051     /**
1052      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1053      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1054      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1055      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1056      * @param from address representing the previous owner of the given token ID
1057      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1058      */
1059     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1060         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1061         // then delete the last slot (swap and pop).
1062 
1063         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1064         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1065 
1066         // When the token to delete is the last token, the swap operation is unnecessary
1067         if (tokenIndex != lastTokenIndex) {
1068             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1069 
1070             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1071             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1072         }
1073 
1074         // This also deletes the contents at the last position of the array
1075         delete _ownedTokensIndex[tokenId];
1076         delete _ownedTokens[from][lastTokenIndex];
1077     }
1078 
1079     /**
1080      * @dev Private function to remove a token from this extension's token tracking data structures.
1081      * This has O(1) time complexity, but alters the order of the _allTokens array.
1082      * @param tokenId uint256 ID of the token to be removed from the tokens list
1083      */
1084     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1085         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1086         // then delete the last slot (swap and pop).
1087 
1088         uint256 lastTokenIndex = _allTokens.length - 1;
1089         uint256 tokenIndex = _allTokensIndex[tokenId];
1090 
1091         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1092         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1093         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1094         uint256 lastTokenId = _allTokens[lastTokenIndex];
1095 
1096         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1097         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1098 
1099         // This also deletes the contents at the last position of the array
1100         delete _allTokensIndex[tokenId];
1101         _allTokens.pop();
1102     }
1103 }
1104 
1105 // File: @openzeppelin/contracts/access/Ownable.sol
1106 
1107 
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 /**
1112  * @dev Contract module which provides a basic access control mechanism, where
1113  * there is an account (an owner) that can be granted exclusive access to
1114  * specific functions.
1115  *
1116  * By default, the owner account will be the one that deploys the contract. This
1117  * can later be changed with {transferOwnership}.
1118  *
1119  * This module is used through inheritance. It will make available the modifier
1120  * `onlyOwner`, which can be applied to your functions to restrict their use to
1121  * the owner.
1122  */
1123 abstract contract Ownable is Context {
1124     address private _owner;
1125 
1126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1127 
1128     /**
1129      * @dev Initializes the contract setting the deployer as the initial owner.
1130      */
1131     constructor () {
1132         address msgSender = _msgSender();
1133         _owner = msgSender;
1134         emit OwnershipTransferred(address(0), msgSender);
1135     }
1136 
1137     /**
1138      * @dev Returns the address of the current owner.
1139      */
1140     function owner() public view virtual returns (address) {
1141         return _owner;
1142     }
1143 
1144     /**
1145      * @dev Throws if called by any account other than the owner.
1146      */
1147     modifier onlyOwner() {
1148         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1149         _;
1150     }
1151 
1152     /**
1153      * @dev Leaves the contract without owner. It will not be possible to call
1154      * `onlyOwner` functions anymore. Can only be called by the current owner.
1155      *
1156      * NOTE: Renouncing ownership will leave the contract without an owner,
1157      * thereby removing any functionality that is only available to the owner.
1158      */
1159     function renounceOwnership() public virtual onlyOwner {
1160         emit OwnershipTransferred(_owner, address(0));
1161         _owner = address(0);
1162     }
1163 
1164     /**
1165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1166      * Can only be called by the current owner.
1167      */
1168     function transferOwnership(address newOwner) public virtual onlyOwner {
1169         require(newOwner != address(0), "Ownable: new owner is the zero address");
1170         emit OwnershipTransferred(_owner, newOwner);
1171         _owner = newOwner;
1172     }
1173 }
1174 
1175 // File: contracts/BunkerBeasts.sol
1176 
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 abstract contract GONS {
1182   function ownerOf(uint256 tokenId) public virtual view returns (address);
1183   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1184   function balanceOf(address owner) external virtual view returns (uint256 balance);
1185 }
1186 
1187 contract BunkerBeasts is ERC721Enumerable, Ownable {  
1188   GONS private gons;
1189 
1190   uint constant public MAX_BEAST_MINT = 50;
1191   uint constant public MAX_BEASTS = 5000;
1192 
1193   address private gonsContract = 0x984EEA281Bf65638ac6ed30C4FF7977EA7fe0433;
1194   bool public saleIsActive = false;
1195   uint256 public maxBeasts;
1196   string private baseURI;   
1197 
1198   constructor() ERC721("BunkerBeasts", "BBEASTS") {
1199     maxBeasts = MAX_BEASTS;
1200     gons = GONS(gonsContract);
1201   }
1202 
1203 
1204   function isMinted(uint256 tokenId) external view returns (bool) {
1205     require(tokenId < maxBeasts, "tokenId outside collection bounds");
1206 
1207     return _exists(tokenId);
1208   }
1209 
1210   function _baseURI() internal view override returns (string memory) {
1211     return baseURI;
1212   }
1213   
1214   function setBaseURI(string memory uri) public onlyOwner {
1215     baseURI = uri;
1216   }
1217 
1218   function flipSaleState() public onlyOwner {
1219     saleIsActive = !saleIsActive;
1220   }
1221 
1222 
1223   // Shows if a gons can claim a beast
1224   function canClaim(uint256 tokenId) view public returns (bool) {
1225       return !_exists(tokenId);
1226   }
1227 
1228   // Returns amount of BunkerBeasts available for claim
1229   function getMintableTokenNumber(address user) view public returns (uint256 mintableTokenNumber) {
1230       mintableTokenNumber = 0;
1231       for (uint256 i = 0; i < gons.balanceOf(user); i++) {
1232           uint256 tokenId = gons.tokenOfOwnerByIndex(user, i);
1233           if (canClaim(tokenId))
1234               mintableTokenNumber++;
1235       }
1236       return mintableTokenNumber;
1237   }
1238 
1239 
1240   /**
1241     * Claim a single Bunker Beast
1242     */
1243   function claimBeast(uint256 gonsTokenId) public {
1244     require(saleIsActive, "Sale must be active to mint a Beast");
1245     require(totalSupply() < maxBeasts, "Purchase would exceed max supply of Beasts");
1246     require(gonsTokenId < maxBeasts, "Requested tokenId exceeds upper bound");
1247     require(gons.ownerOf(gonsTokenId) == msg.sender, "Must own the Gorilla Nemesis for requested tokenId to mint a Beast");
1248     
1249     _safeMint(msg.sender, gonsTokenId);
1250   }
1251 
1252   /**
1253     * Claim N Bunker Beasts
1254   */
1255   function claimNBeasts(uint256 numBeasts) public {
1256       require(saleIsActive, "Sale must be active to mint a Beast");
1257       require(numBeasts > 0, "Must mint at least one Beast");
1258       require(numBeasts <= MAX_BEAST_MINT, "Cannot claim more than 50 Beasts at once");
1259       uint balanceGons = gons.balanceOf(msg.sender);
1260       require(balanceGons > 0, "Must hold at least one Gorilla Nemesis to mint a Beast");
1261 
1262       uint256 claimed = 0;
1263       for (uint256 i = 0; i < balanceGons; i++) {
1264           uint256 tokenId = gons.tokenOfOwnerByIndex(msg.sender, i);
1265           if (canClaim(tokenId)) {
1266               _safeMint(msg.sender, tokenId);
1267               claimed++;
1268           }
1269           if (claimed == numBeasts) {
1270               break;
1271           }
1272       }
1273   }
1274 
1275 }