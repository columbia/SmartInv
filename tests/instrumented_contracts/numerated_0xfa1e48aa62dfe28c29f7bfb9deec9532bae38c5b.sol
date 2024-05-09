1 // Sources flattened with hardhat v2.3.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.1.0
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
32 
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(address from, address to, uint256 tokenId) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address from, address to, uint256 tokenId) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146       * @dev Safely transfers `tokenId` token from `from` to `to`.
147       *
148       * Requirements:
149       *
150       * - `from` cannot be the zero address.
151       * - `to` cannot be the zero address.
152       * - `tokenId` token must exist and be owned by `from`.
153       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155       *
156       * Emits a {Transfer} event.
157       */
158     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
159 }
160 
161 
162 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
163 
164 
165 
166 pragma solidity ^0.8.0;
167 
168 /**
169  * @title ERC721 token receiver interface
170  * @dev Interface for any contract that wants to support safeTransfers
171  * from ERC721 asset contracts.
172  */
173 interface IERC721Receiver {
174     /**
175      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
176      * by `operator` from `from`, this function is called.
177      *
178      * It must return its Solidity selector to confirm the token transfer.
179      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
180      *
181      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
182      */
183     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
184 }
185 
186 
187 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
188 
189 
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
195  * @dev See https://eips.ethereum.org/EIPS/eip-721
196  */
197 interface IERC721Metadata is IERC721 {
198 
199     /**
200      * @dev Returns the token collection name.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the token collection symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
211      */
212     function tokenURI(uint256 tokenId) external view returns (string memory);
213 }
214 
215 
216 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
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
408 
409 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
410 
411 
412 
413 pragma solidity ^0.8.0;
414 
415 /*
416  * @dev Provides information about the current execution context, including the
417  * sender of the transaction and its data. While these are generally available
418  * via msg.sender and msg.data, they should not be accessed in such a direct
419  * manner, since when dealing with meta-transactions the account sending and
420  * paying for execution may not be the actual sender (as far as an application
421  * is concerned).
422  *
423  * This contract is only required for intermediate, library-like contracts.
424  */
425 abstract contract Context {
426     function _msgSender() internal view virtual returns (address) {
427         return msg.sender;
428     }
429 
430     function _msgData() internal view virtual returns (bytes calldata) {
431         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
432         return msg.data;
433     }
434 }
435 
436 
437 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
438 
439 
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @dev String operations.
445  */
446 library Strings {
447     bytes16 private constant alphabet = "0123456789abcdef";
448 
449     /**
450      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
451      */
452     function toString(uint256 value) internal pure returns (string memory) {
453         // Inspired by OraclizeAPI's implementation - MIT licence
454         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
455 
456         if (value == 0) {
457             return "0";
458         }
459         uint256 temp = value;
460         uint256 digits;
461         while (temp != 0) {
462             digits++;
463             temp /= 10;
464         }
465         bytes memory buffer = new bytes(digits);
466         while (value != 0) {
467             digits -= 1;
468             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
469             value /= 10;
470         }
471         return string(buffer);
472     }
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
476      */
477     function toHexString(uint256 value) internal pure returns (string memory) {
478         if (value == 0) {
479             return "0x00";
480         }
481         uint256 temp = value;
482         uint256 length = 0;
483         while (temp != 0) {
484             length++;
485             temp >>= 8;
486         }
487         return toHexString(value, length);
488     }
489 
490     /**
491      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
492      */
493     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
494         bytes memory buffer = new bytes(2 * length + 2);
495         buffer[0] = "0";
496         buffer[1] = "x";
497         for (uint256 i = 2 * length + 1; i > 1; --i) {
498             buffer[i] = alphabet[value & 0xf];
499             value >>= 4;
500         }
501         require(value == 0, "Strings: hex length insufficient");
502         return string(buffer);
503     }
504 
505 }
506 
507 
508 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Implementation of the {IERC165} interface.
516  *
517  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
518  * for the additional interface id that will be supported. For example:
519  *
520  * ```solidity
521  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
522  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
523  * }
524  * ```
525  *
526  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
527  */
528 abstract contract ERC165 is IERC165 {
529     /**
530      * @dev See {IERC165-supportsInterface}.
531      */
532     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
533         return interfaceId == type(IERC165).interfaceId;
534     }
535 }
536 
537 
538 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
539 
540 
541 
542 pragma solidity ^0.8.0;
543 
544 
545 
546 
547 
548 
549 
550 /**
551  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
552  * the Metadata extension, but not including the Enumerable extension, which is available separately as
553  * {ERC721Enumerable}.
554  */
555 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
556     using Address for address;
557     using Strings for uint256;
558 
559     // Token name
560     string private _name;
561 
562     // Token symbol
563     string private _symbol;
564 
565     // Mapping from token ID to owner address
566     mapping (uint256 => address) private _owners;
567 
568     // Mapping owner address to token count
569     mapping (address => uint256) private _balances;
570 
571     // Mapping from token ID to approved address
572     mapping (uint256 => address) private _tokenApprovals;
573 
574     // Mapping from owner to operator approvals
575     mapping (address => mapping (address => bool)) private _operatorApprovals;
576 
577     /**
578      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
579      */
580     constructor (string memory name_, string memory symbol_) {
581         _name = name_;
582         _symbol = symbol_;
583     }
584 
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
589         return interfaceId == type(IERC721).interfaceId
590             || interfaceId == type(IERC721Metadata).interfaceId
591             || super.supportsInterface(interfaceId);
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
632         return bytes(baseURI).length > 0
633             ? string(abi.encodePacked(baseURI, tokenId.toString()))
634             : '';
635     }
636 
637     /**
638      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
639      * in child contracts.
640      */
641     function _baseURI() internal view virtual returns (string memory) {
642         return "";
643     }
644 
645     /**
646      * @dev See {IERC721-approve}.
647      */
648     function approve(address to, uint256 tokenId) public virtual override {
649         address owner = ERC721.ownerOf(tokenId);
650         require(to != owner, "ERC721: approval to current owner");
651 
652         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
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
688     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
689         //solhint-disable-next-line max-line-length
690         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
691 
692         _transfer(from, to, tokenId);
693     }
694 
695     /**
696      * @dev See {IERC721-safeTransferFrom}.
697      */
698     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
699         safeTransferFrom(from, to, tokenId, "");
700     }
701 
702     /**
703      * @dev See {IERC721-safeTransferFrom}.
704      */
705     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707         _safeTransfer(from, to, tokenId, _data);
708     }
709 
710     /**
711      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
712      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
713      *
714      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
715      *
716      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
717      * implement alternative mechanisms to perform token transfer, such as signature-based.
718      *
719      * Requirements:
720      *
721      * - `from` cannot be the zero address.
722      * - `to` cannot be the zero address.
723      * - `tokenId` token must exist and be owned by `from`.
724      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
725      *
726      * Emits a {Transfer} event.
727      */
728     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
729         _transfer(from, to, tokenId);
730         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
731     }
732 
733     /**
734      * @dev Returns whether `tokenId` exists.
735      *
736      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
737      *
738      * Tokens start existing when they are minted (`_mint`),
739      * and stop existing when they are burned (`_burn`).
740      */
741     function _exists(uint256 tokenId) internal view virtual returns (bool) {
742         return _owners[tokenId] != address(0);
743     }
744 
745     /**
746      * @dev Returns whether `spender` is allowed to manage `tokenId`.
747      *
748      * Requirements:
749      *
750      * - `tokenId` must exist.
751      */
752     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
753         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
754         address owner = ERC721.ownerOf(tokenId);
755         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
756     }
757 
758     /**
759      * @dev Safely mints `tokenId` and transfers it to `to`.
760      *
761      * Requirements:
762      *
763      * - `tokenId` must not exist.
764      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
765      *
766      * Emits a {Transfer} event.
767      */
768     function _safeMint(address to, uint256 tokenId) internal virtual {
769         _safeMint(to, tokenId, "");
770     }
771 
772     /**
773      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
774      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
775      */
776     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
777         _mint(to, tokenId);
778         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
779     }
780 
781     /**
782      * @dev Mints `tokenId` and transfers it to `to`.
783      *
784      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
785      *
786      * Requirements:
787      *
788      * - `tokenId` must not exist.
789      * - `to` cannot be the zero address.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _mint(address to, uint256 tokenId) internal virtual {
794         require(to != address(0), "ERC721: mint to the zero address");
795         require(!_exists(tokenId), "ERC721: token already minted");
796 
797         _beforeTokenTransfer(address(0), to, tokenId);
798 
799         _balances[to] += 1;
800         _owners[tokenId] = to;
801 
802         emit Transfer(address(0), to, tokenId);
803     }
804 
805     /**
806      * @dev Destroys `tokenId`.
807      * The approval is cleared when the token is burned.
808      *
809      * Requirements:
810      *
811      * - `tokenId` must exist.
812      *
813      * Emits a {Transfer} event.
814      */
815     function _burn(uint256 tokenId) internal virtual {
816         address owner = ERC721.ownerOf(tokenId);
817 
818         _beforeTokenTransfer(owner, address(0), tokenId);
819 
820         // Clear approvals
821         _approve(address(0), tokenId);
822 
823         _balances[owner] -= 1;
824         delete _owners[tokenId];
825 
826         emit Transfer(owner, address(0), tokenId);
827     }
828 
829     /**
830      * @dev Transfers `tokenId` from `from` to `to`.
831      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
832      *
833      * Requirements:
834      *
835      * - `to` cannot be the zero address.
836      * - `tokenId` token must be owned by `from`.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _transfer(address from, address to, uint256 tokenId) internal virtual {
841         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
842         require(to != address(0), "ERC721: transfer to the zero address");
843 
844         _beforeTokenTransfer(from, to, tokenId);
845 
846         // Clear approvals from the previous owner
847         _approve(address(0), tokenId);
848 
849         _balances[from] -= 1;
850         _balances[to] += 1;
851         _owners[tokenId] = to;
852 
853         emit Transfer(from, to, tokenId);
854     }
855 
856     /**
857      * @dev Approve `to` to operate on `tokenId`
858      *
859      * Emits a {Approval} event.
860      */
861     function _approve(address to, uint256 tokenId) internal virtual {
862         _tokenApprovals[tokenId] = to;
863         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
864     }
865 
866     /**
867      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
868      * The call is not executed if the target address is not a contract.
869      *
870      * @param from address representing the previous owner of the given token ID
871      * @param to target address that will receive the tokens
872      * @param tokenId uint256 ID of the token to be transferred
873      * @param _data bytes optional data to send along with the call
874      * @return bool whether the call correctly returned the expected magic value
875      */
876     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
877         private returns (bool)
878     {
879         if (to.isContract()) {
880             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
881                 return retval == IERC721Receiver(to).onERC721Received.selector;
882             } catch (bytes memory reason) {
883                 if (reason.length == 0) {
884                     revert("ERC721: transfer to non ERC721Receiver implementer");
885                 } else {
886                     // solhint-disable-next-line no-inline-assembly
887                     assembly {
888                         revert(add(32, reason), mload(reason))
889                     }
890                 }
891             }
892         } else {
893             return true;
894         }
895     }
896 
897     /**
898      * @dev Hook that is called before any token transfer. This includes minting
899      * and burning.
900      *
901      * Calling conditions:
902      *
903      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
904      * transferred to `to`.
905      * - When `from` is zero, `tokenId` will be minted for `to`.
906      * - When `to` is zero, ``from``'s `tokenId` will be burned.
907      * - `from` cannot be the zero address.
908      * - `to` cannot be the zero address.
909      *
910      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
911      */
912     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
913 }
914 
915 
916 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.1.0
917 
918 
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev ERC721 token with storage based token URI management.
924  */
925 abstract contract ERC721URIStorage is ERC721 {
926     using Strings for uint256;
927 
928     // Optional mapping for token URIs
929     mapping (uint256 => string) private _tokenURIs;
930 
931     /**
932      * @dev See {IERC721Metadata-tokenURI}.
933      */
934     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
935         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
936 
937         string memory _tokenURI = _tokenURIs[tokenId];
938         string memory base = _baseURI();
939 
940         // If there is no base URI, return the token URI.
941         if (bytes(base).length == 0) {
942             return _tokenURI;
943         }
944         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
945         if (bytes(_tokenURI).length > 0) {
946             return string(abi.encodePacked(base, _tokenURI));
947         }
948 
949         return super.tokenURI(tokenId);
950     }
951 
952     /**
953      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      */
959     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
960         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
961         _tokenURIs[tokenId] = _tokenURI;
962     }
963 
964     /**
965      * @dev Destroys `tokenId`.
966      * The approval is cleared when the token is burned.
967      *
968      * Requirements:
969      *
970      * - `tokenId` must exist.
971      *
972      * Emits a {Transfer} event.
973      */
974     function _burn(uint256 tokenId) internal virtual override {
975         super._burn(tokenId);
976 
977         if (bytes(_tokenURIs[tokenId]).length != 0) {
978             delete _tokenURIs[tokenId];
979         }
980     }
981 }
982 
983 
984 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.1.0
985 
986 
987 
988 pragma solidity ^0.8.0;
989 
990 
991 /**
992  * @title ERC721 Burnable Token
993  * @dev ERC721 Token that can be irreversibly burned (destroyed).
994  */
995 abstract contract ERC721Burnable is Context, ERC721 {
996     /**
997      * @dev Burns `tokenId`. See {ERC721-_burn}.
998      *
999      * Requirements:
1000      *
1001      * - The caller must own `tokenId` or be an approved operator.
1002      */
1003     function burn(uint256 tokenId) public virtual {
1004         //solhint-disable-next-line max-line-length
1005         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1006         _burn(tokenId);
1007     }
1008 }
1009 
1010 
1011 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.1.0
1012 
1013 
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 /**
1018  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1019  * @dev See https://eips.ethereum.org/EIPS/eip-721
1020  */
1021 interface IERC721Enumerable is IERC721 {
1022 
1023     /**
1024      * @dev Returns the total amount of tokens stored by the contract.
1025      */
1026     function totalSupply() external view returns (uint256);
1027 
1028     /**
1029      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1030      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1031      */
1032     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1033 
1034     /**
1035      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1036      * Use along with {totalSupply} to enumerate all tokens.
1037      */
1038     function tokenByIndex(uint256 index) external view returns (uint256);
1039 }
1040 
1041 
1042 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.1.0
1043 
1044 
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 /**
1050  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1051  * enumerability of all the token ids in the contract as well as all token ids owned by each
1052  * account.
1053  */
1054 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1055     // Mapping from owner to list of owned token IDs
1056     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1057 
1058     // Mapping from token ID to index of the owner tokens list
1059     mapping(uint256 => uint256) private _ownedTokensIndex;
1060 
1061     // Array with all token ids, used for enumeration
1062     uint256[] private _allTokens;
1063 
1064     // Mapping from token id to position in the allTokens array
1065     mapping(uint256 => uint256) private _allTokensIndex;
1066 
1067     /**
1068      * @dev See {IERC165-supportsInterface}.
1069      */
1070     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1071         return interfaceId == type(IERC721Enumerable).interfaceId
1072             || super.supportsInterface(interfaceId);
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
1113     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1114         super._beforeTokenTransfer(from, to, tokenId);
1115 
1116         if (from == address(0)) {
1117             _addTokenToAllTokensEnumeration(tokenId);
1118         } else if (from != to) {
1119             _removeTokenFromOwnerEnumeration(from, tokenId);
1120         }
1121         if (to == address(0)) {
1122             _removeTokenFromAllTokensEnumeration(tokenId);
1123         } else if (to != from) {
1124             _addTokenToOwnerEnumeration(to, tokenId);
1125         }
1126     }
1127 
1128     /**
1129      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1130      * @param to address representing the new owner of the given token ID
1131      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1132      */
1133     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1134         uint256 length = ERC721.balanceOf(to);
1135         _ownedTokens[to][length] = tokenId;
1136         _ownedTokensIndex[tokenId] = length;
1137     }
1138 
1139     /**
1140      * @dev Private function to add a token to this extension's token tracking data structures.
1141      * @param tokenId uint256 ID of the token to be added to the tokens list
1142      */
1143     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1144         _allTokensIndex[tokenId] = _allTokens.length;
1145         _allTokens.push(tokenId);
1146     }
1147 
1148     /**
1149      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1150      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1151      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1152      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1153      * @param from address representing the previous owner of the given token ID
1154      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1155      */
1156     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1157         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1158         // then delete the last slot (swap and pop).
1159 
1160         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1161         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1162 
1163         // When the token to delete is the last token, the swap operation is unnecessary
1164         if (tokenIndex != lastTokenIndex) {
1165             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1166 
1167             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1168             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1169         }
1170 
1171         // This also deletes the contents at the last position of the array
1172         delete _ownedTokensIndex[tokenId];
1173         delete _ownedTokens[from][lastTokenIndex];
1174     }
1175 
1176     /**
1177      * @dev Private function to remove a token from this extension's token tracking data structures.
1178      * This has O(1) time complexity, but alters the order of the _allTokens array.
1179      * @param tokenId uint256 ID of the token to be removed from the tokens list
1180      */
1181     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1182         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1183         // then delete the last slot (swap and pop).
1184 
1185         uint256 lastTokenIndex = _allTokens.length - 1;
1186         uint256 tokenIndex = _allTokensIndex[tokenId];
1187 
1188         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1189         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1190         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1191         uint256 lastTokenId = _allTokens[lastTokenIndex];
1192 
1193         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1194         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1195 
1196         // This also deletes the contents at the last position of the array
1197         delete _allTokensIndex[tokenId];
1198         _allTokens.pop();
1199     }
1200 }
1201 
1202 
1203 // File @openzeppelin/contracts/security/Pausable.sol@v4.1.0
1204 
1205 
1206 
1207 pragma solidity ^0.8.0;
1208 
1209 /**
1210  * @dev Contract module which allows children to implement an emergency stop
1211  * mechanism that can be triggered by an authorized account.
1212  *
1213  * This module is used through inheritance. It will make available the
1214  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1215  * the functions of your contract. Note that they will not be pausable by
1216  * simply including this module, only once the modifiers are put in place.
1217  */
1218 abstract contract Pausable is Context {
1219     /**
1220      * @dev Emitted when the pause is triggered by `account`.
1221      */
1222     event Paused(address account);
1223 
1224     /**
1225      * @dev Emitted when the pause is lifted by `account`.
1226      */
1227     event Unpaused(address account);
1228 
1229     bool private _paused;
1230 
1231     /**
1232      * @dev Initializes the contract in unpaused state.
1233      */
1234     constructor () {
1235         _paused = false;
1236     }
1237 
1238     /**
1239      * @dev Returns true if the contract is paused, and false otherwise.
1240      */
1241     function paused() public view virtual returns (bool) {
1242         return _paused;
1243     }
1244 
1245     /**
1246      * @dev Modifier to make a function callable only when the contract is not paused.
1247      *
1248      * Requirements:
1249      *
1250      * - The contract must not be paused.
1251      */
1252     modifier whenNotPaused() {
1253         require(!paused(), "Pausable: paused");
1254         _;
1255     }
1256 
1257     /**
1258      * @dev Modifier to make a function callable only when the contract is paused.
1259      *
1260      * Requirements:
1261      *
1262      * - The contract must be paused.
1263      */
1264     modifier whenPaused() {
1265         require(paused(), "Pausable: not paused");
1266         _;
1267     }
1268 
1269     /**
1270      * @dev Triggers stopped state.
1271      *
1272      * Requirements:
1273      *
1274      * - The contract must not be paused.
1275      */
1276     function _pause() internal virtual whenNotPaused {
1277         _paused = true;
1278         emit Paused(_msgSender());
1279     }
1280 
1281     /**
1282      * @dev Returns to normal state.
1283      *
1284      * Requirements:
1285      *
1286      * - The contract must be paused.
1287      */
1288     function _unpause() internal virtual whenPaused {
1289         _paused = false;
1290         emit Unpaused(_msgSender());
1291     }
1292 }
1293 
1294 
1295 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol@v4.1.0
1296 
1297 
1298 
1299 pragma solidity ^0.8.0;
1300 
1301 
1302 /**
1303  * @dev ERC721 token with pausable token transfers, minting and burning.
1304  *
1305  * Useful for scenarios such as preventing trades until the end of an evaluation
1306  * period, or having an emergency switch for freezing all token transfers in the
1307  * event of a large bug.
1308  */
1309 abstract contract ERC721Pausable is ERC721, Pausable {
1310     /**
1311      * @dev See {ERC721-_beforeTokenTransfer}.
1312      *
1313      * Requirements:
1314      *
1315      * - the contract must not be paused.
1316      */
1317     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1318         super._beforeTokenTransfer(from, to, tokenId);
1319 
1320         require(!paused(), "ERC721Pausable: token transfer while paused");
1321     }
1322 }
1323 
1324 
1325 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
1326 
1327 
1328 
1329 pragma solidity ^0.8.0;
1330 
1331 /**
1332  * @title Counters
1333  * @author Matt Condon (@shrugs)
1334  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1335  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1336  *
1337  * Include with `using Counters for Counters.Counter;`
1338  */
1339 library Counters {
1340     struct Counter {
1341         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1342         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1343         // this feature: see https://github.com/ethereum/solidity/issues/4637
1344         uint256 _value; // default: 0
1345     }
1346 
1347     function current(Counter storage counter) internal view returns (uint256) {
1348         return counter._value;
1349     }
1350 
1351     function increment(Counter storage counter) internal {
1352         unchecked {
1353             counter._value += 1;
1354         }
1355     }
1356 
1357     function decrement(Counter storage counter) internal {
1358         uint256 value = counter._value;
1359         require(value > 0, "Counter: decrement overflow");
1360         unchecked {
1361             counter._value = value - 1;
1362         }
1363     }
1364 }
1365 
1366 
1367 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.1.0
1368 
1369 
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 /**
1374  * @dev Library for managing
1375  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1376  * types.
1377  *
1378  * Sets have the following properties:
1379  *
1380  * - Elements are added, removed, and checked for existence in constant time
1381  * (O(1)).
1382  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1383  *
1384  * ```
1385  * contract Example {
1386  *     // Add the library methods
1387  *     using EnumerableSet for EnumerableSet.AddressSet;
1388  *
1389  *     // Declare a set state variable
1390  *     EnumerableSet.AddressSet private mySet;
1391  * }
1392  * ```
1393  *
1394  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1395  * and `uint256` (`UintSet`) are supported.
1396  */
1397 library EnumerableSet {
1398     // To implement this library for multiple types with as little code
1399     // repetition as possible, we write it in terms of a generic Set type with
1400     // bytes32 values.
1401     // The Set implementation uses private functions, and user-facing
1402     // implementations (such as AddressSet) are just wrappers around the
1403     // underlying Set.
1404     // This means that we can only create new EnumerableSets for types that fit
1405     // in bytes32.
1406 
1407     struct Set {
1408         // Storage of set values
1409         bytes32[] _values;
1410 
1411         // Position of the value in the `values` array, plus 1 because index 0
1412         // means a value is not in the set.
1413         mapping (bytes32 => uint256) _indexes;
1414     }
1415 
1416     /**
1417      * @dev Add a value to a set. O(1).
1418      *
1419      * Returns true if the value was added to the set, that is if it was not
1420      * already present.
1421      */
1422     function _add(Set storage set, bytes32 value) private returns (bool) {
1423         if (!_contains(set, value)) {
1424             set._values.push(value);
1425             // The value is stored at length-1, but we add 1 to all indexes
1426             // and use 0 as a sentinel value
1427             set._indexes[value] = set._values.length;
1428             return true;
1429         } else {
1430             return false;
1431         }
1432     }
1433 
1434     /**
1435      * @dev Removes a value from a set. O(1).
1436      *
1437      * Returns true if the value was removed from the set, that is if it was
1438      * present.
1439      */
1440     function _remove(Set storage set, bytes32 value) private returns (bool) {
1441         // We read and store the value's index to prevent multiple reads from the same storage slot
1442         uint256 valueIndex = set._indexes[value];
1443 
1444         if (valueIndex != 0) { // Equivalent to contains(set, value)
1445             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1446             // the array, and then remove the last element (sometimes called as 'swap and pop').
1447             // This modifies the order of the array, as noted in {at}.
1448 
1449             uint256 toDeleteIndex = valueIndex - 1;
1450             uint256 lastIndex = set._values.length - 1;
1451 
1452             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1453             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1454 
1455             bytes32 lastvalue = set._values[lastIndex];
1456 
1457             // Move the last value to the index where the value to delete is
1458             set._values[toDeleteIndex] = lastvalue;
1459             // Update the index for the moved value
1460             set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1461 
1462             // Delete the slot where the moved value was stored
1463             set._values.pop();
1464 
1465             // Delete the index for the deleted slot
1466             delete set._indexes[value];
1467 
1468             return true;
1469         } else {
1470             return false;
1471         }
1472     }
1473 
1474     /**
1475      * @dev Returns true if the value is in the set. O(1).
1476      */
1477     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1478         return set._indexes[value] != 0;
1479     }
1480 
1481     /**
1482      * @dev Returns the number of values on the set. O(1).
1483      */
1484     function _length(Set storage set) private view returns (uint256) {
1485         return set._values.length;
1486     }
1487 
1488    /**
1489     * @dev Returns the value stored at position `index` in the set. O(1).
1490     *
1491     * Note that there are no guarantees on the ordering of values inside the
1492     * array, and it may change when more values are added or removed.
1493     *
1494     * Requirements:
1495     *
1496     * - `index` must be strictly less than {length}.
1497     */
1498     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1499         require(set._values.length > index, "EnumerableSet: index out of bounds");
1500         return set._values[index];
1501     }
1502 
1503     // Bytes32Set
1504 
1505     struct Bytes32Set {
1506         Set _inner;
1507     }
1508 
1509     /**
1510      * @dev Add a value to a set. O(1).
1511      *
1512      * Returns true if the value was added to the set, that is if it was not
1513      * already present.
1514      */
1515     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1516         return _add(set._inner, value);
1517     }
1518 
1519     /**
1520      * @dev Removes a value from a set. O(1).
1521      *
1522      * Returns true if the value was removed from the set, that is if it was
1523      * present.
1524      */
1525     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1526         return _remove(set._inner, value);
1527     }
1528 
1529     /**
1530      * @dev Returns true if the value is in the set. O(1).
1531      */
1532     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1533         return _contains(set._inner, value);
1534     }
1535 
1536     /**
1537      * @dev Returns the number of values in the set. O(1).
1538      */
1539     function length(Bytes32Set storage set) internal view returns (uint256) {
1540         return _length(set._inner);
1541     }
1542 
1543    /**
1544     * @dev Returns the value stored at position `index` in the set. O(1).
1545     *
1546     * Note that there are no guarantees on the ordering of values inside the
1547     * array, and it may change when more values are added or removed.
1548     *
1549     * Requirements:
1550     *
1551     * - `index` must be strictly less than {length}.
1552     */
1553     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1554         return _at(set._inner, index);
1555     }
1556 
1557     // AddressSet
1558 
1559     struct AddressSet {
1560         Set _inner;
1561     }
1562 
1563     /**
1564      * @dev Add a value to a set. O(1).
1565      *
1566      * Returns true if the value was added to the set, that is if it was not
1567      * already present.
1568      */
1569     function add(AddressSet storage set, address value) internal returns (bool) {
1570         return _add(set._inner, bytes32(uint256(uint160(value))));
1571     }
1572 
1573     /**
1574      * @dev Removes a value from a set. O(1).
1575      *
1576      * Returns true if the value was removed from the set, that is if it was
1577      * present.
1578      */
1579     function remove(AddressSet storage set, address value) internal returns (bool) {
1580         return _remove(set._inner, bytes32(uint256(uint160(value))));
1581     }
1582 
1583     /**
1584      * @dev Returns true if the value is in the set. O(1).
1585      */
1586     function contains(AddressSet storage set, address value) internal view returns (bool) {
1587         return _contains(set._inner, bytes32(uint256(uint160(value))));
1588     }
1589 
1590     /**
1591      * @dev Returns the number of values in the set. O(1).
1592      */
1593     function length(AddressSet storage set) internal view returns (uint256) {
1594         return _length(set._inner);
1595     }
1596 
1597    /**
1598     * @dev Returns the value stored at position `index` in the set. O(1).
1599     *
1600     * Note that there are no guarantees on the ordering of values inside the
1601     * array, and it may change when more values are added or removed.
1602     *
1603     * Requirements:
1604     *
1605     * - `index` must be strictly less than {length}.
1606     */
1607     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1608         return address(uint160(uint256(_at(set._inner, index))));
1609     }
1610 
1611 
1612     // UintSet
1613 
1614     struct UintSet {
1615         Set _inner;
1616     }
1617 
1618     /**
1619      * @dev Add a value to a set. O(1).
1620      *
1621      * Returns true if the value was added to the set, that is if it was not
1622      * already present.
1623      */
1624     function add(UintSet storage set, uint256 value) internal returns (bool) {
1625         return _add(set._inner, bytes32(value));
1626     }
1627 
1628     /**
1629      * @dev Removes a value from a set. O(1).
1630      *
1631      * Returns true if the value was removed from the set, that is if it was
1632      * present.
1633      */
1634     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1635         return _remove(set._inner, bytes32(value));
1636     }
1637 
1638     /**
1639      * @dev Returns true if the value is in the set. O(1).
1640      */
1641     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1642         return _contains(set._inner, bytes32(value));
1643     }
1644 
1645     /**
1646      * @dev Returns the number of values on the set. O(1).
1647      */
1648     function length(UintSet storage set) internal view returns (uint256) {
1649         return _length(set._inner);
1650     }
1651 
1652    /**
1653     * @dev Returns the value stored at position `index` in the set. O(1).
1654     *
1655     * Note that there are no guarantees on the ordering of values inside the
1656     * array, and it may change when more values are added or removed.
1657     *
1658     * Requirements:
1659     *
1660     * - `index` must be strictly less than {length}.
1661     */
1662     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1663         return uint256(_at(set._inner, index));
1664     }
1665 }
1666 
1667 
1668 // File @openzeppelin/contracts/utils/structs/EnumerableMap.sol@v4.1.0
1669 
1670 
1671 
1672 pragma solidity ^0.8.0;
1673 
1674 /**
1675  * @dev Library for managing an enumerable variant of Solidity's
1676  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1677  * type.
1678  *
1679  * Maps have the following properties:
1680  *
1681  * - Entries are added, removed, and checked for existence in constant time
1682  * (O(1)).
1683  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1684  *
1685  * ```
1686  * contract Example {
1687  *     // Add the library methods
1688  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1689  *
1690  *     // Declare a set state variable
1691  *     EnumerableMap.UintToAddressMap private myMap;
1692  * }
1693  * ```
1694  *
1695  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1696  * supported.
1697  */
1698 library EnumerableMap {
1699     using EnumerableSet for EnumerableSet.Bytes32Set;
1700 
1701     // To implement this library for multiple types with as little code
1702     // repetition as possible, we write it in terms of a generic Map type with
1703     // bytes32 keys and values.
1704     // The Map implementation uses private functions, and user-facing
1705     // implementations (such as Uint256ToAddressMap) are just wrappers around
1706     // the underlying Map.
1707     // This means that we can only create new EnumerableMaps for types that fit
1708     // in bytes32.
1709 
1710     struct Map {
1711         // Storage of keys
1712         EnumerableSet.Bytes32Set _keys;
1713 
1714         mapping (bytes32 => bytes32) _values;
1715     }
1716 
1717     /**
1718      * @dev Adds a key-value pair to a map, or updates the value for an existing
1719      * key. O(1).
1720      *
1721      * Returns true if the key was added to the map, that is if it was not
1722      * already present.
1723      */
1724     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1725         map._values[key] = value;
1726         return map._keys.add(key);
1727     }
1728 
1729     /**
1730      * @dev Removes a key-value pair from a map. O(1).
1731      *
1732      * Returns true if the key was removed from the map, that is if it was present.
1733      */
1734     function _remove(Map storage map, bytes32 key) private returns (bool) {
1735         delete map._values[key];
1736         return map._keys.remove(key);
1737     }
1738 
1739     /**
1740      * @dev Returns true if the key is in the map. O(1).
1741      */
1742     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1743         return map._keys.contains(key);
1744     }
1745 
1746     /**
1747      * @dev Returns the number of key-value pairs in the map. O(1).
1748      */
1749     function _length(Map storage map) private view returns (uint256) {
1750         return map._keys.length();
1751     }
1752 
1753    /**
1754     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1755     *
1756     * Note that there are no guarantees on the ordering of entries inside the
1757     * array, and it may change when more entries are added or removed.
1758     *
1759     * Requirements:
1760     *
1761     * - `index` must be strictly less than {length}.
1762     */
1763     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1764         bytes32 key = map._keys.at(index);
1765         return (key, map._values[key]);
1766     }
1767 
1768     /**
1769      * @dev Tries to returns the value associated with `key`.  O(1).
1770      * Does not revert if `key` is not in the map.
1771      */
1772     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1773         bytes32 value = map._values[key];
1774         if (value == bytes32(0)) {
1775             return (_contains(map, key), bytes32(0));
1776         } else {
1777             return (true, value);
1778         }
1779     }
1780 
1781     /**
1782      * @dev Returns the value associated with `key`.  O(1).
1783      *
1784      * Requirements:
1785      *
1786      * - `key` must be in the map.
1787      */
1788     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1789         bytes32 value = map._values[key];
1790         require(value != 0 || _contains(map, key), "EnumerableMap: nonexistent key");
1791         return value;
1792     }
1793 
1794     /**
1795      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1796      *
1797      * CAUTION: This function is deprecated because it requires allocating memory for the error
1798      * message unnecessarily. For custom revert reasons use {_tryGet}.
1799      */
1800     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1801         bytes32 value = map._values[key];
1802         require(value != 0 || _contains(map, key), errorMessage);
1803         return value;
1804     }
1805 
1806     // UintToAddressMap
1807 
1808     struct UintToAddressMap {
1809         Map _inner;
1810     }
1811 
1812     /**
1813      * @dev Adds a key-value pair to a map, or updates the value for an existing
1814      * key. O(1).
1815      *
1816      * Returns true if the key was added to the map, that is if it was not
1817      * already present.
1818      */
1819     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1820         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1821     }
1822 
1823     /**
1824      * @dev Removes a value from a set. O(1).
1825      *
1826      * Returns true if the key was removed from the map, that is if it was present.
1827      */
1828     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1829         return _remove(map._inner, bytes32(key));
1830     }
1831 
1832     /**
1833      * @dev Returns true if the key is in the map. O(1).
1834      */
1835     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1836         return _contains(map._inner, bytes32(key));
1837     }
1838 
1839     /**
1840      * @dev Returns the number of elements in the map. O(1).
1841      */
1842     function length(UintToAddressMap storage map) internal view returns (uint256) {
1843         return _length(map._inner);
1844     }
1845 
1846    /**
1847     * @dev Returns the element stored at position `index` in the set. O(1).
1848     * Note that there are no guarantees on the ordering of values inside the
1849     * array, and it may change when more values are added or removed.
1850     *
1851     * Requirements:
1852     *
1853     * - `index` must be strictly less than {length}.
1854     */
1855     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1856         (bytes32 key, bytes32 value) = _at(map._inner, index);
1857         return (uint256(key), address(uint160(uint256(value))));
1858     }
1859 
1860     /**
1861      * @dev Tries to returns the value associated with `key`.  O(1).
1862      * Does not revert if `key` is not in the map.
1863      *
1864      * _Available since v3.4._
1865      */
1866     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1867         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1868         return (success, address(uint160(uint256(value))));
1869     }
1870 
1871     /**
1872      * @dev Returns the value associated with `key`.  O(1).
1873      *
1874      * Requirements:
1875      *
1876      * - `key` must be in the map.
1877      */
1878     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1879         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1880     }
1881 
1882     /**
1883      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1884      *
1885      * CAUTION: This function is deprecated because it requires allocating memory for the error
1886      * message unnecessarily. For custom revert reasons use {tryGet}.
1887      */
1888     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1889         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1890     }
1891 }
1892 
1893 
1894 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
1895 
1896 
1897 
1898 pragma solidity ^0.8.0;
1899 
1900 /**
1901  * @dev Contract module which provides a basic access control mechanism, where
1902  * there is an account (an owner) that can be granted exclusive access to
1903  * specific functions.
1904  *
1905  * By default, the owner account will be the one that deploys the contract. This
1906  * can later be changed with {transferOwnership}.
1907  *
1908  * This module is used through inheritance. It will make available the modifier
1909  * `onlyOwner`, which can be applied to your functions to restrict their use to
1910  * the owner.
1911  */
1912 abstract contract Ownable is Context {
1913     address private _owner;
1914 
1915     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1916 
1917     /**
1918      * @dev Initializes the contract setting the deployer as the initial owner.
1919      */
1920     constructor () {
1921         address msgSender = _msgSender();
1922         _owner = msgSender;
1923         emit OwnershipTransferred(address(0), msgSender);
1924     }
1925 
1926     /**
1927      * @dev Returns the address of the current owner.
1928      */
1929     function owner() public view virtual returns (address) {
1930         return _owner;
1931     }
1932 
1933     /**
1934      * @dev Throws if called by any account other than the owner.
1935      */
1936     modifier onlyOwner() {
1937         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1938         _;
1939     }
1940 
1941     /**
1942      * @dev Leaves the contract without owner. It will not be possible to call
1943      * `onlyOwner` functions anymore. Can only be called by the current owner.
1944      *
1945      * NOTE: Renouncing ownership will leave the contract without an owner,
1946      * thereby removing any functionality that is only available to the owner.
1947      */
1948     function renounceOwnership() public virtual onlyOwner {
1949         emit OwnershipTransferred(_owner, address(0));
1950         _owner = address(0);
1951     }
1952 
1953     /**
1954      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1955      * Can only be called by the current owner.
1956      */
1957     function transferOwnership(address newOwner) public virtual onlyOwner {
1958         require(newOwner != address(0), "Ownable: new owner is the zero address");
1959         emit OwnershipTransferred(_owner, newOwner);
1960         _owner = newOwner;
1961     }
1962 }
1963 
1964 
1965 // File contracts/tokens/ERC721Token.sol
1966 
1967 
1968 pragma solidity ^0.8.0;
1969 contract ERC721Token is ERC721Enumerable, ERC721URIStorage, Ownable, ERC721Burnable, ERC721Pausable {
1970   using EnumerableMap for EnumerableMap.UintToAddressMap;
1971   using Counters for Counters.Counter;
1972 
1973   // Counter that tracks incremental token ids
1974   Counters.Counter private _tokenIds;
1975 
1976   // Authors mapping (tokenId -> author address)
1977   EnumerableMap.UintToAddressMap private _tokenIdAuthor;
1978 
1979   // Constructor will be called only 1 time, when the Smart Contract gets deployed
1980   constructor(
1981     string memory _name,
1982     string memory _symbol
1983   ) ERC721(_name, _symbol) {}
1984 
1985   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721Enumerable, ERC721) returns (bool) {
1986     return super.supportsInterface(interfaceId);
1987   }
1988 
1989   /**
1990    * Minting function. Anyone can call it.
1991    */
1992   function mint(address _to, string memory _tokenURI) 
1993     public
1994     whenNotPaused
1995     returns (uint256) 
1996   {
1997     return _mint(_to, _tokenURI, _msgSender()); 
1998   }
1999 
2000   /**
2001    * Only Owner minting function. To use if minting in the name of an author.
2002    */
2003   function mintWithAuthor(address _to, string memory _tokenURI, address _author)
2004     public
2005     onlyOwner
2006     whenNotPaused
2007     returns (uint256) 
2008   {
2009     return _mint(_to, _tokenURI, _author);
2010   }
2011 
2012   /**
2013    * Minting function.
2014    *
2015    * Will mint a new NFT with the tokenURI as property (ideally should point to a distributed storage URI),
2016    * setup the mapping of the newly created token ID and the provided author and send the NFT to _to after minting.
2017    */ 
2018   function _mint(address _to, string memory _tokenURI, address _author)
2019     internal
2020     whenNotPaused
2021     returns (uint256)
2022   {
2023     require(bytes(_tokenURI).length > 0, "ERR: Empty tokenURI");
2024     require(_author != address(0), "ERR: 0x0 author address");
2025 
2026     _tokenIds.increment();
2027      
2028     uint256 _newTokenId = _tokenIds.current();
2029     super._mint(_to, _newTokenId);
2030     _setTokenURI(_newTokenId, _tokenURI);
2031 
2032     _tokenIdAuthor.set(_newTokenId, _author);
2033 
2034     return _newTokenId;
2035   }
2036 
2037   /**
2038    * Getter to retrieve the author for a given token Id
2039    */
2040   function tokenIdAuthor(uint256 _tokenId)
2041     external
2042     view
2043     returns (address author)
2044   {
2045     require(_tokenIdAuthor.contains(_tokenId), "ERR: Unexisting token");
2046  
2047     return _tokenIdAuthor.get(_tokenId);
2048   }
2049 
2050   function pause() public onlyOwner {
2051     super._pause();
2052   }
2053 
2054   function unpause() public onlyOwner {
2055     super._unpause();
2056   }
2057 
2058   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Pausable, ERC721Enumerable) {
2059     super._beforeTokenTransfer(from, to, tokenId);
2060   }
2061 
2062   function _burn(uint256 tokenId) internal virtual whenNotPaused override(ERC721URIStorage, ERC721) {
2063     super._burn(tokenId);
2064   }
2065 
2066   function tokenURI(uint256 tokenId) public view virtual override (ERC721URIStorage, ERC721) returns (string memory) {
2067     return super.tokenURI(tokenId);
2068   }
2069 
2070   function transfer(address from, address to, uint256 tokenId) public virtual {
2071     return super.safeTransferFrom(from, to, tokenId);
2072   }
2073 
2074 }