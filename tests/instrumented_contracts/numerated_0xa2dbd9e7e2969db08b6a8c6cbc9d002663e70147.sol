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
545     uint256 public NFT_PRICE = 30000000000000000; // 0.03 ETH
546     string public PROVENANCE_HASH = "";
547     uint256 public ROUND = 1; // price doubles each round
548     
549     bool public saleStarted = true;
550 
551     // Token name
552     string private _name;
553 
554     // Token symbol
555     string private _symbol;
556 
557     // Mapping from token ID to owner address
558     mapping (uint256 => address) private _owners;
559 
560     // Mapping owner address to token count
561     mapping (address => uint256) private _balances;
562 
563     // Mapping from token ID to approved address
564     mapping (uint256 => address) private _tokenApprovals;
565 
566     // Mapping from owner to operator approvals
567     mapping (address => mapping (address => bool)) private _operatorApprovals;
568 
569     /**
570      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
571      */
572     constructor (string memory name_, string memory symbol_) {
573         _name = name_;
574         _symbol = symbol_;
575     }
576 
577     /**
578      * @dev See {IERC165-supportsInterface}.
579      */
580     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
581         return interfaceId == type(IERC721).interfaceId
582             || interfaceId == type(IERC721Metadata).interfaceId
583             || super.supportsInterface(interfaceId);
584     }
585 
586     /**
587      * @dev See {IERC721-balanceOf}.
588      */
589     function balanceOf(address owner) public view virtual override returns (uint256) {
590         require(owner != address(0), "ERC721: balance query for the zero address");
591         return _balances[owner];
592     }
593 
594     /**
595      * @dev See {IERC721-ownerOf}.
596      */
597     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
598         address owner = _owners[tokenId];
599         require(owner != address(0), "ERC721: owner query for nonexistent token");
600         return owner;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-name}.
605      */
606     function name() public view virtual override returns (string memory) {
607         return _name;
608     }
609 
610     /**
611      * @dev See {IERC721Metadata-symbol}.
612      */
613     function symbol() public view virtual override returns (string memory) {
614         return _symbol;
615     }
616 
617     /**
618      * @dev See {IERC721Metadata-tokenURI}.
619      */
620     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
621         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
622 
623         string memory baseURI = _baseURI();
624         return bytes(baseURI).length > 0
625             ? string(abi.encodePacked(baseURI, tokenId.toString(), '.json'))
626             : '';
627     }
628 
629     /**
630      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
631      * in child contracts.
632      */
633     function _baseURI() internal view virtual returns (string memory) {
634         return "";
635     }
636 
637     /**
638      * @dev See {IERC721-approve}.
639      */
640     function approve(address to, uint256 tokenId) public virtual override {
641         address owner = ERC721.ownerOf(tokenId);
642         require(to != owner, "ERC721: approval to current owner");
643 
644         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
645             "ERC721: approve caller is not owner nor approved for all"
646         );
647 
648         _approve(to, tokenId);
649     }
650 
651     /**
652      * @dev See {IERC721-getApproved}.
653      */
654     function getApproved(uint256 tokenId) public view virtual override returns (address) {
655         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
656 
657         return _tokenApprovals[tokenId];
658     }
659 
660     /**
661      * @dev See {IERC721-setApprovalForAll}.
662      */
663     function setApprovalForAll(address operator, bool approved) public virtual override {
664         require(operator != _msgSender(), "ERC721: approve to caller");
665 
666         _operatorApprovals[_msgSender()][operator] = approved;
667         emit ApprovalForAll(_msgSender(), operator, approved);
668     }
669 
670     /**
671      * @dev See {IERC721-isApprovedForAll}.
672      */
673     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
674         return _operatorApprovals[owner][operator];
675     }
676 
677     /**
678      * @dev See {IERC721-transferFrom}.
679      */
680     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
681         //solhint-disable-next-line max-line-length
682         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
683 
684         _transfer(from, to, tokenId);
685     }
686 
687     /**
688      * @dev See {IERC721-safeTransferFrom}.
689      */
690     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
691         safeTransferFrom(from, to, tokenId, "");
692     }
693 
694     /**
695      * @dev See {IERC721-safeTransferFrom}.
696      */
697     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
698         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
699         _safeTransfer(from, to, tokenId, _data);
700     }
701 
702     /**
703      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
704      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
705      *
706      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
707      *
708      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
709      * implement alternative mechanisms to perform token transfer, such as signature-based.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must exist and be owned by `from`.
716      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
717      *
718      * Emits a {Transfer} event.
719      */
720     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
721         _transfer(from, to, tokenId);
722         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
723     }
724 
725     /**
726      * @dev Returns whether `tokenId` exists.
727      *
728      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
729      *
730      * Tokens start existing when they are minted (`_mint`),
731      * and stop existing when they are burned (`_burn`).
732      */
733     function _exists(uint256 tokenId) internal view virtual returns (bool) {
734         return _owners[tokenId] != address(0);
735     }
736 
737     /**
738      * @dev Returns whether `spender` is allowed to manage `tokenId`.
739      *
740      * Requirements:
741      *
742      * - `tokenId` must exist.
743      */
744     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
745         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
746         address owner = ERC721.ownerOf(tokenId);
747         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
748     }
749 
750     /**
751      * @dev Safely mints `tokenId` and transfers it to `to`.
752      *
753      * Requirements:
754      *
755      * - `tokenId` must not exist.
756      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
757      *
758      * Emits a {Transfer} event.
759      */
760     function _safeMint(address to, uint256 tokenId) internal virtual {
761         _safeMint(to, tokenId, "");
762     }
763 
764     /**
765      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
766      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
767      */
768     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
769         _mint(to, tokenId);
770         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
771     }
772 
773     /**
774      * @dev Mints `tokenId` and transfers it to `to`.
775      *
776      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
777      *
778      * Requirements:
779      *
780      * - `tokenId` must not exist.
781      * - `to` cannot be the zero address.
782      *
783      * Emits a {Transfer} event.
784      */
785     
786     function sendValue(address payable recipient, uint256 amount) internal {
787         require(address(this).balance >= amount, "Address: insufficient balance");
788 
789         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
790         (bool success, ) = recipient.call{ value: amount }("");
791         require(success, "Address: unable to send value, recipient may have reverted");
792     }
793     
794     function _mint(address to, uint256 tokenId) internal virtual {
795        require(to != address(0), "ERC721: mint to the zero address");
796        // require(!_exists(tokenId), "ERC721: token already minted");   change this to accommodate autosell
797        if (_exists(tokenId)) {  //autosell
798                 uint256 payment = 95 * ROUND * NFT_PRICE / 100;
799                 address previousOwner = _owners[tokenId];
800                 address payable wallet = payable(previousOwner);
801                 sendValue(wallet, payment);    // pay old owner
802                 _transfer2(_owners[tokenId], to, tokenId);           // transfer to new owner 
803         } else
804         {       //original minting          
805         _beforeTokenTransfer(address(0), to, tokenId);
806 
807         _balances[to] += 1;
808         _owners[tokenId] = to;
809 
810         emit Transfer(address(0), to, tokenId);
811         }
812     }
813 
814     /**
815      * @dev Destroys `tokenId`.
816      * The approval is cleared when the token is burned.
817      *
818      * Requirements:
819      *
820      * - `tokenId` must exist.
821      *
822      * Emits a {Transfer} event.
823      */
824     function _burn(uint256 tokenId) internal virtual {
825         address owner = ERC721.ownerOf(tokenId);
826 
827         _beforeTokenTransfer(owner, address(0), tokenId);
828 
829         // Clear approvals
830         _approve(address(0), tokenId);
831 
832         _balances[owner] -= 1;
833         delete _owners[tokenId];
834 
835         emit Transfer(owner, address(0), tokenId);
836     }
837 
838     /**
839      * @dev Transfers `tokenId` from `from` to `to`.
840      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
841      *
842      * Requirements:
843      *
844      * - `to` cannot be the zero address.
845      * - `tokenId` token must be owned by `from`.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _transfer(address from, address to, uint256 tokenId) internal virtual {
850         require(saleStarted==false, "Main website sale not finished yet");
851         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
852         require(to != address(0), "ERC721: transfer to the zero address");
853 
854         _beforeTokenTransfer(from, to, tokenId);
855 
856         // Clear approvals from the previous owner
857         _approve(address(0), tokenId);
858 
859         _balances[from] -= 1;
860         _balances[to] += 1;
861         _owners[tokenId] = to;
862 
863         emit Transfer(from, to, tokenId);
864     }
865     
866    function _transfer2(address from, address to, uint256 tokenId) internal virtual {   // for main website buy from previous buyer who autosells at same position
867         _beforeTokenTransfer(from, to, tokenId);
868 
869         // Clear approvals from the previous owner
870         _approve(address(0), tokenId);
871 
872         _balances[from] -= 1;
873         _balances[to] += 1;
874         _owners[tokenId] = to;
875 
876         emit Transfer(from, to, tokenId);
877     }
878 
879     /**
880      * @dev Approve `to` to operate on `tokenId`
881      *
882      * Emits a {Approval} event.
883      */
884     function _approve(address to, uint256 tokenId) internal virtual {
885         _tokenApprovals[tokenId] = to;
886         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
887     }
888 
889     /**
890      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
891      * The call is not executed if the target address is not a contract.
892      *
893      * @param from address representing the previous owner of the given token ID
894      * @param to target address that will receive the tokens
895      * @param tokenId uint256 ID of the token to be transferred
896      * @param _data bytes optional data to send along with the call
897      * @return bool whether the call correctly returned the expected magic value
898      */
899     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
900         private returns (bool)
901     {
902         if (to.isContract()) {
903             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
904                 return retval == IERC721Receiver(to).onERC721Received.selector;
905             } catch (bytes memory reason) {
906                 if (reason.length == 0) {
907                     revert("ERC721: transfer to non ERC721Receiver implementer");
908                 } else {
909                     // solhint-disable-next-line no-inline-assembly
910                     assembly {
911                         revert(add(32, reason), mload(reason))
912                     }
913                 }
914             }
915         } else {
916             return true;
917         }
918     }
919 
920     /**
921      * @dev Hook that is called before any token transfer. This includes minting
922      * and burning.
923      *
924      * Calling conditions:
925      *
926      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
927      * transferred to `to`.
928      * - When `from` is zero, `tokenId` will be minted for `to`.
929      * - When `to` is zero, ``from``'s `tokenId` will be burned.
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      *
933      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
934      */
935     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
936 }
937 
938 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
939 
940 
941 pragma solidity ^0.8.0;
942 
943 
944 /**
945  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
946  * @dev See https://eips.ethereum.org/EIPS/eip-721
947  */
948 interface IERC721Enumerable is IERC721 {
949 
950     /**
951      * @dev Returns the total amount of tokens stored by the contract.
952      */
953     function totalSupply() external view returns (uint256);
954 
955     /**
956      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
957      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
958      */
959     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
960 
961     /**
962      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
963      * Use along with {totalSupply} to enumerate all tokens.
964      */
965     function tokenByIndex(uint256 index) external view returns (uint256);
966 }
967 
968 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
969 
970 
971 pragma solidity ^0.8.0;
972 
973 
974 
975 /**
976  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
977  * enumerability of all the token ids in the contract as well as all token ids owned by each
978  * account.
979  */
980 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
981     // Mapping from owner to list of owned token IDs
982     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
983 
984     // Mapping from token ID to index of the owner tokens list
985     mapping(uint256 => uint256) private _ownedTokensIndex;
986 
987     // Array with all token ids, used for enumeration
988     uint256[] private _allTokens;
989 
990     // Mapping from token id to position in the allTokens array
991     mapping(uint256 => uint256) private _allTokensIndex;
992 
993     /**
994      * @dev See {IERC165-supportsInterface}.
995      */
996     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
997         return interfaceId == type(IERC721Enumerable).interfaceId
998             || super.supportsInterface(interfaceId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1003      */
1004     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1005         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1006         return _ownedTokens[owner][index];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Enumerable-totalSupply}.
1011      */
1012     function totalSupply() public view virtual override returns (uint256) {
1013         return _allTokens.length;
1014     }
1015 
1016     /**
1017      * @dev See {IERC721Enumerable-tokenByIndex}.
1018      */
1019     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1020         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1021         return _allTokens[index];
1022     }
1023 
1024     /**
1025      * @dev Hook that is called before any token transfer. This includes minting
1026      * and burning.
1027      *
1028      * Calling conditions:
1029      *
1030      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1031      * transferred to `to`.
1032      * - When `from` is zero, `tokenId` will be minted for `to`.
1033      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1034      * - `from` cannot be the zero address.
1035      * - `to` cannot be the zero address.
1036      *
1037      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1038      */
1039     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1040         super._beforeTokenTransfer(from, to, tokenId);
1041 
1042         if (from == address(0)) {
1043             _addTokenToAllTokensEnumeration(tokenId);
1044         } else if (from != to) {
1045             _removeTokenFromOwnerEnumeration(from, tokenId);
1046         }
1047         if (to == address(0)) {
1048             _removeTokenFromAllTokensEnumeration(tokenId);
1049         } else if (to != from) {
1050             _addTokenToOwnerEnumeration(to, tokenId);
1051         }
1052     }
1053 
1054     /**
1055      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1056      * @param to address representing the new owner of the given token ID
1057      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1058      */
1059     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1060         uint256 length = ERC721.balanceOf(to);
1061         _ownedTokens[to][length] = tokenId;
1062         _ownedTokensIndex[tokenId] = length;
1063     }
1064 
1065     /**
1066      * @dev Private function to add a token to this extension's token tracking data structures.
1067      * @param tokenId uint256 ID of the token to be added to the tokens list
1068      */
1069     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1070         _allTokensIndex[tokenId] = _allTokens.length;
1071         _allTokens.push(tokenId);
1072     }
1073 
1074     /**
1075      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1076      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1077      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1078      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1079      * @param from address representing the previous owner of the given token ID
1080      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1081      */
1082     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1083         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1084         // then delete the last slot (swap and pop).
1085 
1086         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1087         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1088 
1089         // When the token to delete is the last token, the swap operation is unnecessary
1090         if (tokenIndex != lastTokenIndex) {
1091             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1092 
1093             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1094             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1095         }
1096 
1097         // This also deletes the contents at the last position of the array
1098         delete _ownedTokensIndex[tokenId];
1099         delete _ownedTokens[from][lastTokenIndex];
1100     }
1101 
1102     /**
1103      * @dev Private function to remove a token from this extension's token tracking data structures.
1104      * This has O(1) time complexity, but alters the order of the _allTokens array.
1105      * @param tokenId uint256 ID of the token to be removed from the tokens list
1106      */
1107     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1108         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1109         // then delete the last slot (swap and pop).
1110 
1111         uint256 lastTokenIndex = _allTokens.length - 1;
1112         uint256 tokenIndex = _allTokensIndex[tokenId];
1113 
1114         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1115         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1116         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1117         uint256 lastTokenId = _allTokens[lastTokenIndex];
1118 
1119         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1120         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1121 
1122         // This also deletes the contents at the last position of the array
1123         delete _allTokensIndex[tokenId];
1124         _allTokens.pop();
1125     }
1126 }
1127 
1128 // File: @openzeppelin/contracts/access/Ownable.sol
1129 
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 /**
1134  * @dev Contract module which provides a basic access control mechanism, where
1135  * there is an account (an owner) that can be granted exclusive access to
1136  * specific functions.
1137  *
1138  * By default, the owner account will be the one that deploys the contract. This
1139  * can later be changed with {transferOwnership}.
1140  *
1141  * This module is used through inheritance. It will make available the modifier
1142  * `onlyOwner`, which can be applied to your functions to restrict their use to
1143  * the owner.
1144  */
1145 abstract contract Ownable is Context {
1146     address private _owner;
1147 
1148     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1149 
1150     /**
1151      * @dev Initializes the contract setting the deployer as the initial owner.
1152      */
1153     constructor () {
1154         address msgSender = _msgSender();
1155         _owner = msgSender;
1156         emit OwnershipTransferred(address(0), msgSender);
1157     }
1158 
1159     /**
1160      * @dev Returns the address of the current owner.
1161      */
1162     function owner() public view virtual returns (address) {
1163         return _owner;
1164     }
1165 
1166     /**
1167      * @dev Throws if called by any account other than the owner.
1168      */
1169     modifier onlyOwner() {
1170         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1171         _;
1172     }
1173 
1174     /**
1175      * @dev Leaves the contract without owner. It will not be possible to call
1176      * `onlyOwner` functions anymore. Can only be called by the current owner.
1177      *
1178      * NOTE: Renouncing ownership will leave the contract without an owner,
1179      * thereby removing any functionality that is only available to the owner.
1180      */
1181     function renounceOwnership() public virtual onlyOwner {
1182         emit OwnershipTransferred(_owner, address(0));
1183         _owner = address(0);
1184     }
1185 
1186     /**
1187      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1188      * Can only be called by the current owner.
1189      */
1190     function transferOwnership(address newOwner) public virtual onlyOwner {
1191         require(newOwner != address(0), "Ownable: new owner is the zero address");
1192         emit OwnershipTransferred(_owner, newOwner);
1193         _owner = newOwner;
1194     }
1195 }
1196 
1197 // File: contracts/MandelNFT.sol
1198 
1199 pragma solidity ^0.8.0;
1200 
1201 
1202 contract MandelNFT is ERC721Enumerable, Ownable {
1203     uint256 public constant MAX_NFT_SUPPLY = 1000;
1204     uint public constant MAX_PURCHASABLE = 30;
1205     
1206     uint256 public mintIndex = 0;
1207 
1208 
1209   
1210     constructor() ERC721("MandelNFT", "MANDELNFT") {
1211     }
1212 
1213     function contractURI() public view returns (string memory) {
1214         return "https://mandelnft.onrender.com/collection.json";
1215     }
1216 
1217     function _baseURI() internal view virtual override returns (string memory) {
1218         return "https://mandelnft.onrender.com/";
1219     }
1220 
1221     function getTokenURI(uint256 tokenId) public view returns (string memory) {
1222         return tokenURI(tokenId);
1223     }
1224 
1225    function mint(uint256 amountToMint) public payable {
1226         require(saleStarted == true, "This sale has not started.");
1227         require(amountToMint > 0, "You must mint at least one.");
1228         require(amountToMint <= MAX_PURCHASABLE, "You cannot mint more than 30 at a time.");
1229         require(mintIndex + amountToMint <= MAX_NFT_SUPPLY, "The amount you are trying to mint exceeds the MAX_NFT_SUPPLY.");
1230         
1231         require(NFT_PRICE * amountToMint * ROUND == msg.value, "Incorrect Ether value.");
1232 
1233         for (uint256 i = 0; i < amountToMint; i++) {
1234             mintIndex++;
1235             _safeMint(msg.sender, mintIndex);
1236         }
1237         if (mintIndex == MAX_NFT_SUPPLY) {ROUND++; mintIndex=0;}
1238    }
1239 
1240     function startSale() public onlyOwner {
1241         saleStarted = true;
1242     }
1243 
1244     function pauseSale() public onlyOwner {
1245         saleStarted = false;
1246     }
1247 
1248     function setProvenanceHash(string memory _hash) public onlyOwner {
1249         PROVENANCE_HASH = _hash;
1250     }
1251 
1252     function withdraw() public payable onlyOwner {
1253         require(payable(msg.sender).send(address(this).balance));
1254     }
1255 }