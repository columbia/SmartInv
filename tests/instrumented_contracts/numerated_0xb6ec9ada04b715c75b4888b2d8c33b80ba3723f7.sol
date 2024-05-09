1 // Sources flattened with hardhat v2.5.0 https://hardhat.org
2  
3 // File contracts/utils/introspection/IERC165.sol
4  
5 // SPDX-License-Identifier: MIT
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
31 // File contracts/token/ERC721/IERC721.sol
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
162 // File contracts/token/ERC721/IERC721Receiver.sol
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
187 // File contracts/token/ERC721/extensions/IERC721Metadata.sol
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
216 // File contracts/utils/Address.sol
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
409 // File contracts/utils/Context.sol
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
437 // File contracts/utils/Strings.sol
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
508 // File contracts/utils/introspection/ERC165.sol
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
538 // File contracts/token/ERC721/ERC721.sol
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
916 // File contracts/token/ERC721/extensions/ERC721URIStorage.sol
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
984 // File contracts/access/Ownable.sol
985  
986  
987  
988 pragma solidity ^0.8.0;
989  
990 /**
991  * @dev Contract module which provides a basic access control mechanism, where
992  * there is an account (an owner) that can be granted exclusive access to
993  * specific functions.
994  *
995  * By default, the owner account will be the one that deploys the contract. This
996  * can later be changed with {transferOwnership}.
997  *
998  * This module is used through inheritance. It will make available the modifier
999  * `onlyOwner`, which can be applied to your functions to restrict their use to
1000  * the owner.
1001  */
1002 abstract contract Ownable is Context {
1003     address private _owner;
1004  
1005     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1006  
1007     /**
1008      * @dev Initializes the contract setting the deployer as the initial owner.
1009      */
1010     constructor () {
1011         address msgSender = _msgSender();
1012         _owner = msgSender;
1013         emit OwnershipTransferred(address(0), msgSender);
1014     }
1015  
1016     /**
1017      * @dev Returns the address of the current owner.
1018      */
1019     function owner() public view virtual returns (address) {
1020         return _owner;
1021     }
1022  
1023     /**
1024      * @dev Throws if called by any account other than the owner.
1025      */
1026     modifier onlyOwner() {
1027         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1028         _;
1029     }
1030  
1031     /**
1032      * @dev Leaves the contract without owner. It will not be possible to call
1033      * `onlyOwner` functions anymore. Can only be called by the current owner.
1034      *
1035      * NOTE: Renouncing ownership will leave the contract without an owner,
1036      * thereby removing any functionality that is only available to the owner.
1037      */
1038     function renounceOwnership() public virtual onlyOwner {
1039         emit OwnershipTransferred(_owner, address(0));
1040         _owner = address(0);
1041     }
1042  
1043     /**
1044      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1045      * Can only be called by the current owner.
1046      */
1047     function transferOwnership(address newOwner) public virtual onlyOwner {
1048         require(newOwner != address(0), "Ownable: new owner is the zero address");
1049         emit OwnershipTransferred(_owner, newOwner);
1050         _owner = newOwner;
1051     }
1052 }
1053  
1054  
1055  
1056 pragma solidity ^0.8.0;
1057  
1058  
1059  
1060 contract EthBananaChips is ERC721URIStorage, Ownable{
1061 
1062     event MintBananachip (address indexed minter, uint256 startWith, uint256 times);
1063    
1064     
1065     uint256 public totalBananachip;
1066     uint256 public totalCount = 5000; //bruhTotal
1067     uint256 public presaleMax = 100; 
1068     uint256 public maxBatch = 30; // bruhBatch
1069     uint256 public price = 50000000000000000; // 0.06 eth
1070     string public baseURI;
1071     bool public started;
1072     bool public whiteListStart;
1073     mapping(address => uint256) whiteListMintCount;
1074     uint addressRegistryCount;
1075     
1076     constructor(string memory name_, string memory symbol_, string memory baseURI_) ERC721(name_, symbol_) {
1077         baseURI = baseURI_;
1078     }
1079     
1080     modifier canWhitelistMint() {
1081         require(whiteListStart, "Hang on boys, youll get in soon");
1082         _; 
1083     }
1084 
1085     modifier mintEnabled() {
1086         require(started, "not started");
1087         _;
1088     }
1089  
1090     function totalSupply() public view virtual returns (uint256) {
1091         return totalBananachip;
1092        
1093     }
1094  
1095     function _baseURI() internal view virtual override returns (string memory){
1096         return baseURI;
1097     }
1098  
1099     function setBaseURI(string memory _newURI) public onlyOwner {
1100         baseURI = _newURI;
1101     }
1102  
1103     function changePrice(uint256 _newPrice) public onlyOwner {
1104         price = _newPrice;
1105     }
1106     
1107  
1108     function setTokenURI(uint256 _tokenId, string memory _tokenURI) public onlyOwner {
1109         _setTokenURI(_tokenId, _tokenURI);
1110     }
1111  
1112     function setNormalStart(bool _start) public onlyOwner {
1113         started = _start;
1114     }
1115     
1116     function setWhiteListStart(bool _start) public onlyOwner {
1117         whiteListStart = _start;
1118     }
1119     
1120     function getWhitelistMintAmount(address _addr) public view virtual returns (uint256) {
1121         return whiteListMintCount[_addr];
1122     }
1123  
1124     function MintBananachips(uint256 _times) payable public mintEnabled {
1125        
1126         require(_times >0 && _times <= maxBatch, "mint wrong number");
1127         require(totalBananachip + _times <= totalCount, "too much");
1128         require(msg.value == _times * price, "value error");
1129         payable(owner()).transfer(msg.value);
1130         emit MintBananachip(_msgSender(), totalBananachip+1, _times);
1131         for(uint256 i=0; i< _times; i++){
1132             _mint(_msgSender(), 1 + totalBananachip++);
1133         }
1134     } 
1135     
1136     function adminMint(uint256 _times) payable public onlyOwner {
1137         require(_times >0 && _times <= maxBatch, "mint wrong number");
1138         require(totalBananachip + _times <= totalCount, "too much");
1139         require(msg.value == _times * price, "value error");
1140         payable(owner()).transfer(msg.value);
1141         emit MintBananachip(_msgSender(), totalBananachip+1, _times);
1142         for(uint256 i=0; i< _times; i++){
1143             _mint(_msgSender(), 1 + totalBananachip++);
1144         }
1145     }
1146     
1147     
1148     function whitelistMint(uint _times) payable public canWhitelistMint {
1149         if (whiteListMintCount[msg.sender]==0)  {
1150             whiteListMintCount[msg.sender] = 4;
1151         }
1152         require(whiteListMintCount[msg.sender] - _times >= 1, "Over mint limit for address.");
1153         require(totalBananachip + _times <= presaleMax, "Mint amount will exceed total presale amount.");
1154         require(msg.value == _times * price, "Incorrect transaction value.");
1155         payable(owner()).transfer(msg.value);
1156         whiteListMintCount[_msgSender()] -= _times;
1157         emit MintBananachip(_msgSender(), totalBananachip+1, _times);
1158         for(uint256 i=0; i< _times; i++){
1159             _mint(_msgSender(), 1 + totalBananachip++);
1160         }
1161     }
1162     
1163     
1164     function adminMintGiveaways(address _addr) public onlyOwner {
1165         require(totalBananachip + 1 <= totalCount, "Mint amount will exceed total collection amount.");
1166         emit MintBananachip(_addr, totalBananachip+1, 1);
1167         _mint(_addr, 1 + totalBananachip++);
1168     } 
1169     
1170     
1171     
1172     
1173     
1174 }