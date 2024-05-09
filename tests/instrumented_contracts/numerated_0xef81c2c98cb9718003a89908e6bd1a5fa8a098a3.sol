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
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Required interface of an ERC721 compliant contract.
36  */
37 interface IERC721 is IERC165 {
38     /**
39      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
40      */
41     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
42 
43     /**
44      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
45      */
46     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
47 
48     /**
49      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
50      */
51     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
52 
53     /**
54      * @dev Returns the number of tokens in ``owner``'s account.
55      */
56     function balanceOf(address owner) external view returns (uint256 balance);
57 
58     /**
59      * @dev Returns the owner of the `tokenId` token.
60      *
61      * Requirements:
62      *
63      * - `tokenId` must exist.
64      */
65     function ownerOf(uint256 tokenId) external view returns (address owner);
66 
67     /**
68      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
69      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
70      *
71      * Requirements:
72      *
73      * - `from` cannot be the zero address.
74      * - `to` cannot be the zero address.
75      * - `tokenId` token must exist and be owned by `from`.
76      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
77      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
78      *
79      * Emits a {Transfer} event.
80      */
81     function safeTransferFrom(address from, address to, uint256 tokenId) external;
82 
83     /**
84      * @dev Transfers `tokenId` token from `from` to `to`.
85      *
86      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must be owned by `from`.
93      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address from, address to, uint256 tokenId) external;
98 
99     /**
100      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
101      * The approval is cleared when the token is transferred.
102      *
103      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
104      *
105      * Requirements:
106      *
107      * - The caller must own the token or be an approved operator.
108      * - `tokenId` must exist.
109      *
110      * Emits an {Approval} event.
111      */
112     function approve(address to, uint256 tokenId) external;
113 
114     /**
115      * @dev Returns the account approved for `tokenId` token.
116      *
117      * Requirements:
118      *
119      * - `tokenId` must exist.
120      */
121     function getApproved(uint256 tokenId) external view returns (address operator);
122 
123     /**
124      * @dev Approve or remove `operator` as an operator for the caller.
125      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
126      *
127      * Requirements:
128      *
129      * - The `operator` cannot be the caller.
130      *
131      * Emits an {ApprovalForAll} event.
132      */
133     function setApprovalForAll(address operator, bool _approved) external;
134 
135     /**
136      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
137      *
138      * See {setApprovalForAll}
139      */
140     function isApprovedForAll(address owner, address operator) external view returns (bool);
141 
142     /**
143       * @dev Safely transfers `tokenId` token from `from` to `to`.
144       *
145       * Requirements:
146       *
147       * - `from` cannot be the zero address.
148       * - `to` cannot be the zero address.
149       * - `tokenId` token must exist and be owned by `from`.
150       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
152       *
153       * Emits a {Transfer} event.
154       */
155     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
156 }
157 
158 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
159 
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @title ERC721 token receiver interface
165  * @dev Interface for any contract that wants to support safeTransfers
166  * from ERC721 asset contracts.
167  */
168 interface IERC721Receiver {
169     /**
170      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
171      * by `operator` from `from`, this function is called.
172      *
173      * It must return its Solidity selector to confirm the token transfer.
174      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
175      *
176      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
177      */
178     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
179 }
180 
181 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
182 
183 
184 pragma solidity ^0.8.0;
185 
186 
187 /**
188  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
189  * @dev See https://eips.ethereum.org/EIPS/eip-721
190  */
191 interface IERC721Metadata is IERC721 {
192 
193     /**
194      * @dev Returns the token collection name.
195      */
196     function name() external view returns (string memory);
197 
198     /**
199      * @dev Returns the token collection symbol.
200      */
201     function symbol() external view returns (string memory);
202 
203     /**
204      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
205      */
206     function tokenURI(uint256 tokenId) external view returns (string memory);
207 }
208 
209 // File: @openzeppelin/contracts/utils/Address.sol
210 
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @dev Collection of functions related to the address type
216  */
217 library Address {
218     /**
219      * @dev Returns true if `account` is a contract.
220      *
221      * [IMPORTANT]
222      * ====
223      * It is unsafe to assume that an address for which this function returns
224      * false is an externally-owned account (EOA) and not a contract.
225      *
226      * Among others, `isContract` will return false for the following
227      * types of addresses:
228      *
229      *  - an externally-owned account
230      *  - a contract in construction
231      *  - an address where a contract will be created
232      *  - an address where a contract lived, but was destroyed
233      * ====
234      */
235     function isContract(address account) internal view returns (bool) {
236         // This method relies on extcodesize, which returns 0 for contracts in
237         // construction, since the code is only stored at the end of the
238         // constructor execution.
239 
240         uint256 size;
241         // solhint-disable-next-line no-inline-assembly
242         assembly { size := extcodesize(account) }
243         return size > 0;
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      */
262     function sendValue(address payable recipient, uint256 amount) internal {
263         require(address(this).balance >= amount, "Address: insufficient balance");
264 
265         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
266         (bool success, ) = recipient.call{ value: amount }("");
267         require(success, "Address: unable to send value, recipient may have reverted");
268     }
269 
270     /**
271      * @dev Performs a Solidity function call using a low level `call`. A
272      * plain`call` is an unsafe replacement for a function call: use this
273      * function instead.
274      *
275      * If `target` reverts with a revert reason, it is bubbled up by this
276      * function (like regular Solidity function calls).
277      *
278      * Returns the raw returned data. To convert to the expected return value,
279      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
280      *
281      * Requirements:
282      *
283      * - `target` must be a contract.
284      * - calling `target` with `data` must not revert.
285      *
286      * _Available since v3.1._
287      */
288     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
289       return functionCall(target, data, "Address: low-level call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
294      * `errorMessage` as a fallback revert reason when `target` reverts.
295      *
296      * _Available since v3.1._
297      */
298     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
299         return functionCallWithValue(target, data, 0, errorMessage);
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
304      * but also transferring `value` wei to `target`.
305      *
306      * Requirements:
307      *
308      * - the calling contract must have an ETH balance of at least `value`.
309      * - the called Solidity function must be `payable`.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
314         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
319      * with `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
324         require(address(this).balance >= value, "Address: insufficient balance for call");
325         require(isContract(target), "Address: call to non-contract");
326 
327         // solhint-disable-next-line avoid-low-level-calls
328         (bool success, bytes memory returndata) = target.call{ value: value }(data);
329         return _verifyCallResult(success, returndata, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
339         return functionStaticCall(target, data, "Address: low-level static call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
344      * but performing a static call.
345      *
346      * _Available since v3.3._
347      */
348     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = target.staticcall(data);
353         return _verifyCallResult(success, returndata, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
368      * but performing a delegate call.
369      *
370      * _Available since v3.4._
371      */
372     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
373         require(isContract(target), "Address: delegate call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return _verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/utils/Context.sol
401 
402 
403 pragma solidity ^0.8.0;
404 
405 /*
406  * @dev Provides information about the current execution context, including the
407  * sender of the transaction and its data. While these are generally available
408  * via msg.sender and msg.data, they should not be accessed in such a direct
409  * manner, since when dealing with meta-transactions the account sending and
410  * paying for execution may not be the actual sender (as far as an application
411  * is concerned).
412  *
413  * This contract is only required for intermediate, library-like contracts.
414  */
415 abstract contract Context {
416     function _msgSender() internal view virtual returns (address) {
417         return msg.sender;
418     }
419 
420     function _msgData() internal view virtual returns (bytes calldata) {
421         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
422         return msg.data;
423     }
424 }
425 
426 // File: @openzeppelin/contracts/utils/Strings.sol
427 
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @dev String operations.
433  */
434 library Strings {
435     bytes16 private constant alphabet = "0123456789abcdef";
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
439      */
440     function toString(uint256 value) internal pure returns (string memory) {
441         // Inspired by OraclizeAPI's implementation - MIT licence
442         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
443 
444         if (value == 0) {
445             return "0";
446         }
447         uint256 temp = value;
448         uint256 digits;
449         while (temp != 0) {
450             digits++;
451             temp /= 10;
452         }
453         bytes memory buffer = new bytes(digits);
454         while (value != 0) {
455             digits -= 1;
456             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
457             value /= 10;
458         }
459         return string(buffer);
460     }
461 
462     /**
463      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
464      */
465     function toHexString(uint256 value) internal pure returns (string memory) {
466         if (value == 0) {
467             return "0x00";
468         }
469         uint256 temp = value;
470         uint256 length = 0;
471         while (temp != 0) {
472             length++;
473             temp >>= 8;
474         }
475         return toHexString(value, length);
476     }
477 
478     /**
479      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
480      */
481     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
482         bytes memory buffer = new bytes(2 * length + 2);
483         buffer[0] = "0";
484         buffer[1] = "x";
485         for (uint256 i = 2 * length + 1; i > 1; --i) {
486             buffer[i] = alphabet[value & 0xf];
487             value >>= 4;
488         }
489         require(value == 0, "Strings: hex length insufficient");
490         return string(buffer);
491     }
492 
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
496 
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev Implementation of the {IERC165} interface.
503  *
504  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
505  * for the additional interface id that will be supported. For example:
506  *
507  * ```solidity
508  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
509  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
510  * }
511  * ```
512  *
513  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
514  */
515 abstract contract ERC165 is IERC165 {
516     /**
517      * @dev See {IERC165-supportsInterface}.
518      */
519     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
520         return interfaceId == type(IERC165).interfaceId;
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
525 
526 
527 pragma solidity ^0.8.0;
528 
529 
530 
531 
532 
533 
534 
535 
536 /**
537  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
538  * the Metadata extension, but not including the Enumerable extension, which is available separately as
539  * {ERC721Enumerable}.
540  */
541 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
542     using Address for address;
543     using Strings for uint256;
544 
545     // Token name
546     string private _name;
547 
548     // Token symbol
549     string private _symbol;
550 
551     // Mapping from token ID to owner address
552     mapping (uint256 => address) private _owners;
553 
554     // Mapping owner address to token count
555     mapping (address => uint256) private _balances;
556 
557     // Mapping from token ID to approved address
558     mapping (uint256 => address) private _tokenApprovals;
559 
560     // Mapping from owner to operator approvals
561     mapping (address => mapping (address => bool)) private _operatorApprovals;
562 
563     /**
564      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
565      */
566     constructor (string memory name_, string memory symbol_) {
567         _name = name_;
568         _symbol = symbol_;
569     }
570 
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
575         return interfaceId == type(IERC721).interfaceId
576             || interfaceId == type(IERC721Metadata).interfaceId
577             || super.supportsInterface(interfaceId);
578     }
579 
580     /**
581      * @dev See {IERC721-balanceOf}.
582      */
583     function balanceOf(address owner) public view virtual override returns (uint256) {
584         require(owner != address(0), "ERC721: balance query for the zero address");
585         return _balances[owner];
586     }
587 
588     /**
589      * @dev See {IERC721-ownerOf}.
590      */
591     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
592         address owner = _owners[tokenId];
593         require(owner != address(0), "ERC721: owner query for nonexistent token");
594         return owner;
595     }
596 
597     /**
598      * @dev See {IERC721Metadata-name}.
599      */
600     function name() public view virtual override returns (string memory) {
601         return _name;
602     }
603 
604     /**
605      * @dev See {IERC721Metadata-symbol}.
606      */
607     function symbol() public view virtual override returns (string memory) {
608         return _symbol;
609     }
610 
611     /**
612      * @dev See {IERC721Metadata-tokenURI}.
613      */
614     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
615         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
616 
617         string memory baseURI = _baseURI();
618         return bytes(baseURI).length > 0
619             ? string(abi.encodePacked(baseURI, tokenId.toString()))
620             : '';
621     }
622 
623     /**
624      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
625      * in child contracts.
626      */
627     function _baseURI() internal view virtual returns (string memory) {
628         return "";
629     }
630 
631     /**
632      * @dev See {IERC721-approve}.
633      */
634     function approve(address to, uint256 tokenId) public virtual override {
635         address owner = ERC721.ownerOf(tokenId);
636         require(to != owner, "ERC721: approval to current owner");
637 
638         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
639             "ERC721: approve caller is not owner nor approved for all"
640         );
641 
642         _approve(to, tokenId);
643     }
644 
645     /**
646      * @dev See {IERC721-getApproved}.
647      */
648     function getApproved(uint256 tokenId) public view virtual override returns (address) {
649         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
650 
651         return _tokenApprovals[tokenId];
652     }
653 
654     /**
655      * @dev See {IERC721-setApprovalForAll}.
656      */
657     function setApprovalForAll(address operator, bool approved) public virtual override {
658         require(operator != _msgSender(), "ERC721: approve to caller");
659 
660         _operatorApprovals[_msgSender()][operator] = approved;
661         emit ApprovalForAll(_msgSender(), operator, approved);
662     }
663 
664     /**
665      * @dev See {IERC721-isApprovedForAll}.
666      */
667     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
668         return _operatorApprovals[owner][operator];
669     }
670 
671     /**
672      * @dev See {IERC721-transferFrom}.
673      */
674     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
675         //solhint-disable-next-line max-line-length
676         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
677 
678         _transfer(from, to, tokenId);
679     }
680 
681     /**
682      * @dev See {IERC721-safeTransferFrom}.
683      */
684     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
685         safeTransferFrom(from, to, tokenId, "");
686     }
687 
688     /**
689      * @dev See {IERC721-safeTransferFrom}.
690      */
691     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
692         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
693         _safeTransfer(from, to, tokenId, _data);
694     }
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
698      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
699      *
700      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
701      *
702      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
703      * implement alternative mechanisms to perform token transfer, such as signature-based.
704      *
705      * Requirements:
706      *
707      * - `from` cannot be the zero address.
708      * - `to` cannot be the zero address.
709      * - `tokenId` token must exist and be owned by `from`.
710      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
711      *
712      * Emits a {Transfer} event.
713      */
714     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
715         _transfer(from, to, tokenId);
716         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
717     }
718 
719     /**
720      * @dev Returns whether `tokenId` exists.
721      *
722      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
723      *
724      * Tokens start existing when they are minted (`_mint`),
725      * and stop existing when they are burned (`_burn`).
726      */
727     function _exists(uint256 tokenId) internal view virtual returns (bool) {
728         return _owners[tokenId] != address(0);
729     }
730 
731     /**
732      * @dev Returns whether `spender` is allowed to manage `tokenId`.
733      *
734      * Requirements:
735      *
736      * - `tokenId` must exist.
737      */
738     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
739         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
740         address owner = ERC721.ownerOf(tokenId);
741         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
742     }
743 
744     /**
745      * @dev Safely mints `tokenId` and transfers it to `to`.
746      *
747      * Requirements:
748      *
749      * - `tokenId` must not exist.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function _safeMint(address to, uint256 tokenId) internal virtual {
755         _safeMint(to, tokenId, "");
756     }
757 
758     /**
759      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
760      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
761      */
762     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
763         _mint(to, tokenId);
764         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
765     }
766 
767     /**
768      * @dev Mints `tokenId` and transfers it to `to`.
769      *
770      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
771      *
772      * Requirements:
773      *
774      * - `tokenId` must not exist.
775      * - `to` cannot be the zero address.
776      *
777      * Emits a {Transfer} event.
778      */
779     function _mint(address to, uint256 tokenId) internal virtual {
780         require(to != address(0), "ERC721: mint to the zero address");
781         require(!_exists(tokenId), "ERC721: token already minted");
782 
783         _beforeTokenTransfer(address(0), to, tokenId);
784 
785         _balances[to] += 1;
786         _owners[tokenId] = to;
787 
788         emit Transfer(address(0), to, tokenId);
789     }
790 
791     /**
792      * @dev Destroys `tokenId`.
793      * The approval is cleared when the token is burned.
794      *
795      * Requirements:
796      *
797      * - `tokenId` must exist.
798      *
799      * Emits a {Transfer} event.
800      */
801     function _burn(uint256 tokenId) internal virtual {
802         address owner = ERC721.ownerOf(tokenId);
803 
804         _beforeTokenTransfer(owner, address(0), tokenId);
805 
806         // Clear approvals
807         _approve(address(0), tokenId);
808 
809         _balances[owner] -= 1;
810         delete _owners[tokenId];
811 
812         emit Transfer(owner, address(0), tokenId);
813     }
814 
815     /**
816      * @dev Transfers `tokenId` from `from` to `to`.
817      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
818      *
819      * Requirements:
820      *
821      * - `to` cannot be the zero address.
822      * - `tokenId` token must be owned by `from`.
823      *
824      * Emits a {Transfer} event.
825      */
826     function _transfer(address from, address to, uint256 tokenId) internal virtual {
827         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
828         require(to != address(0), "ERC721: transfer to the zero address");
829 
830         _beforeTokenTransfer(from, to, tokenId);
831 
832         // Clear approvals from the previous owner
833         _approve(address(0), tokenId);
834 
835         _balances[from] -= 1;
836         _balances[to] += 1;
837         _owners[tokenId] = to;
838 
839         emit Transfer(from, to, tokenId);
840     }
841 
842     /**
843      * @dev Approve `to` to operate on `tokenId`
844      *
845      * Emits a {Approval} event.
846      */
847     function _approve(address to, uint256 tokenId) internal virtual {
848         _tokenApprovals[tokenId] = to;
849         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
850     }
851 
852     /**
853      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
854      * The call is not executed if the target address is not a contract.
855      *
856      * @param from address representing the previous owner of the given token ID
857      * @param to target address that will receive the tokens
858      * @param tokenId uint256 ID of the token to be transferred
859      * @param _data bytes optional data to send along with the call
860      * @return bool whether the call correctly returned the expected magic value
861      */
862     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
863         private returns (bool)
864     {
865         if (to.isContract()) {
866             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
867                 return retval == IERC721Receiver(to).onERC721Received.selector;
868             } catch (bytes memory reason) {
869                 if (reason.length == 0) {
870                     revert("ERC721: transfer to non ERC721Receiver implementer");
871                 } else {
872                     // solhint-disable-next-line no-inline-assembly
873                     assembly {
874                         revert(add(32, reason), mload(reason))
875                     }
876                 }
877             }
878         } else {
879             return true;
880         }
881     }
882 
883     /**
884      * @dev Hook that is called before any token transfer. This includes minting
885      * and burning.
886      *
887      * Calling conditions:
888      *
889      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
890      * transferred to `to`.
891      * - When `from` is zero, `tokenId` will be minted for `to`.
892      * - When `to` is zero, ``from``'s `tokenId` will be burned.
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      *
896      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
897      */
898     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
899 }
900 
901 
902 pragma solidity ^0.8.0;
903 
904 /**
905  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
906  * @dev See https://eips.ethereum.org/EIPS/eip-721
907  */
908 interface IERC721Enumerable is IERC721 {
909     /**
910      * @dev Returns the total amount of tokens stored by the contract.
911      */
912     function totalSupply() external view returns (uint256);
913 
914     /**
915      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
916      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
917      */
918     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
919 
920     /**
921      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
922      * Use along with {totalSupply} to enumerate all tokens.
923      */
924     function tokenByIndex(uint256 index) external view returns (uint256);
925 }
926 
927 
928 pragma solidity ^0.8.0;
929 
930 /**
931  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
932  * enumerability of all the token ids in the contract as well as all token ids owned by each
933  * account.
934  */
935 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
936     // Mapping from owner to list of owned token IDs
937     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
938 
939     // Mapping from token ID to index of the owner tokens list
940     mapping(uint256 => uint256) private _ownedTokensIndex;
941 
942     // Array with all token ids, used for enumeration
943     uint256[] private _allTokens;
944 
945     // Mapping from token id to position in the allTokens array
946     mapping(uint256 => uint256) private _allTokensIndex;
947 
948     /**
949      * @dev See {IERC165-supportsInterface}.
950      */
951     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
952         return interfaceId == type(IERC721Enumerable).interfaceId
953             || super.supportsInterface(interfaceId);
954     }
955 
956     /**
957      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
958      */
959     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
960         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
961         return _ownedTokens[owner][index];
962     }
963 
964     /**
965      * @dev See {IERC721Enumerable-totalSupply}.
966      */
967     function totalSupply() public view virtual override returns (uint256) {
968         return _allTokens.length;
969     }
970 
971     /**
972      * @dev See {IERC721Enumerable-tokenByIndex}.
973      */
974     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
975         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
976         return _allTokens[index];
977     }
978 
979     /**
980      * @dev Hook that is called before any token transfer. This includes minting
981      * and burning.
982      *
983      * Calling conditions:
984      *
985      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
986      * transferred to `to`.
987      * - When `from` is zero, `tokenId` will be minted for `to`.
988      * - When `to` is zero, ``from``'s `tokenId` will be burned.
989      * - `from` cannot be the zero address.
990      * - `to` cannot be the zero address.
991      *
992      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
993      */
994     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
995         super._beforeTokenTransfer(from, to, tokenId);
996 
997         if (from == address(0)) {
998             _addTokenToAllTokensEnumeration(tokenId);
999         } else if (from != to) {
1000             _removeTokenFromOwnerEnumeration(from, tokenId);
1001         }
1002         if (to == address(0)) {
1003             _removeTokenFromAllTokensEnumeration(tokenId);
1004         } else if (to != from) {
1005             _addTokenToOwnerEnumeration(to, tokenId);
1006         }
1007     }
1008 
1009     /**
1010      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1011      * @param to address representing the new owner of the given token ID
1012      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1013      */
1014     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1015         uint256 length = ERC721.balanceOf(to);
1016         _ownedTokens[to][length] = tokenId;
1017         _ownedTokensIndex[tokenId] = length;
1018     }
1019 
1020     /**
1021      * @dev Private function to add a token to this extension's token tracking data structures.
1022      * @param tokenId uint256 ID of the token to be added to the tokens list
1023      */
1024     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1025         _allTokensIndex[tokenId] = _allTokens.length;
1026         _allTokens.push(tokenId);
1027     }
1028 
1029     /**
1030      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1031      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1032      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1033      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1034      * @param from address representing the previous owner of the given token ID
1035      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1036      */
1037     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1038         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1039         // then delete the last slot (swap and pop).
1040 
1041         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1042         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1043 
1044         // When the token to delete is the last token, the swap operation is unnecessary
1045         if (tokenIndex != lastTokenIndex) {
1046             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1047 
1048             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1049             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1050         }
1051 
1052         // This also deletes the contents at the last position of the array
1053         delete _ownedTokensIndex[tokenId];
1054         delete _ownedTokens[from][lastTokenIndex];
1055     }
1056 
1057     /**
1058      * @dev Private function to remove a token from this extension's token tracking data structures.
1059      * This has O(1) time complexity, but alters the order of the _allTokens array.
1060      * @param tokenId uint256 ID of the token to be removed from the tokens list
1061      */
1062     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1063         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1064         // then delete the last slot (swap and pop).
1065 
1066         uint256 lastTokenIndex = _allTokens.length - 1;
1067         uint256 tokenIndex = _allTokensIndex[tokenId];
1068 
1069         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1070         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1071         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1072         uint256 lastTokenId = _allTokens[lastTokenIndex];
1073 
1074         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1075         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1076         // This also deletes the contents at the last position of the array
1077         delete _allTokensIndex[tokenId];
1078         _allTokens.pop();
1079     }
1080 }
1081 
1082 // File: contracts/SpaceShibas.sol
1083 
1084 pragma solidity ^0.8.0;
1085 
1086 
1087 contract SpaceShibas is ERC721Enumerable {
1088 
1089   address public immutable owner;
1090   uint256 public constant MAX_SUPPLY = 10000;
1091   uint256 public price = 1 ether / 20;
1092   bool public saleEnabled;
1093   uint256 public counter = 1;
1094   uint256 public shibasMinted;
1095   string private shibasURI; 
1096   event ShibasBought(address buyer, uint256 shibasBought, uint256[10] shibaIndexes);
1097 
1098   constructor(string memory name, string memory symbol, string memory uri) ERC721(name, symbol) {
1099     owner = msg.sender;  
1100     shibasURI = uri;
1101   }
1102 
1103   function baseURI() public view returns (string memory) {
1104     return _baseURI();
1105   }
1106   
1107   function _baseURI() internal view override returns (string memory) {
1108     return shibasURI;
1109   }
1110 
1111   function mintBunch(uint256[] memory toMint) public {
1112     require(msg.sender == owner, "Only owner can mint before sale");
1113     shibasMinted += toMint.length;
1114     for (uint256 i = 0; i < toMint.length; i++) {
1115       require(toMint[i] != 0 && toMint[i] <= MAX_SUPPLY, "Invalid tokenId");
1116       _mint(msg.sender, toMint[i]); 
1117     }
1118   }
1119 
1120   function buy(uint256 amountToBuy) public payable {
1121     require(saleEnabled, "Sale ended");
1122     require(amountToBuy > 0 && amountToBuy <= 10, "Invalid amount");
1123     require(msg.value == price * amountToBuy, "Invalid amount of ether for amount to buy");
1124 
1125     uint256[10] memory tokenIdsToMint;
1126     uint256 tokensToMint;
1127     uint256 i = counter;
1128 
1129     while (tokensToMint < amountToBuy) {
1130         if (!_exists(i)) {
1131             tokenIdsToMint[tokensToMint] = i;
1132             tokensToMint++;
1133         }
1134         counter = ++i;
1135         if (i > MAX_SUPPLY) {
1136             saleEnabled = false;
1137             payable(msg.sender).transfer((amountToBuy - tokensToMint) * price);
1138             break;
1139         }
1140     }
1141     
1142     emit ShibasBought(msg.sender, tokensToMint, tokenIdsToMint);
1143     shibasMinted += tokensToMint;
1144     
1145     for (uint256 j = 0; j < tokensToMint; j++) {
1146       _mint(msg.sender, tokenIdsToMint[j]); 
1147     }
1148   }
1149 
1150   function withdraw() public {
1151     require(msg.sender == owner, "Only owner can withdraw");
1152     payable(msg.sender).transfer(address(this).balance); 
1153   }
1154 
1155   function setSaleEnabled(bool to) public {
1156     require(msg.sender == owner, "Only owner can toggle sale state");
1157     saleEnabled = to;
1158   }
1159 
1160   function setCounter(uint256 to) public {
1161     require(msg.sender == owner, "Only owner can set counter");
1162     counter = to;
1163   }
1164 
1165   function setPrice(uint256 to) public {
1166     require(msg.sender == owner, "Only owner can set prices");
1167     price = to;
1168   }
1169 
1170 
1171 }