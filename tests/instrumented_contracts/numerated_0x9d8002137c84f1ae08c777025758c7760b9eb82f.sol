1 // Sources flattened with hardhat v2.4.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.1.0
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
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(address from, address to, uint256 tokenId) external;
83 
84     /**
85      * @dev Transfers `tokenId` token from `from` to `to`.
86      *
87      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must be owned by `from`.
94      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address from, address to, uint256 tokenId) external;
99 
100     /**
101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
102      * The approval is cleared when the token is transferred.
103      *
104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
105      *
106      * Requirements:
107      *
108      * - The caller must own the token or be an approved operator.
109      * - `tokenId` must exist.
110      *
111      * Emits an {Approval} event.
112      */
113     function approve(address to, uint256 tokenId) external;
114 
115     /**
116      * @dev Returns the account approved for `tokenId` token.
117      *
118      * Requirements:
119      *
120      * - `tokenId` must exist.
121      */
122     function getApproved(uint256 tokenId) external view returns (address operator);
123 
124     /**
125      * @dev Approve or remove `operator` as an operator for the caller.
126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
127      *
128      * Requirements:
129      *
130      * - The `operator` cannot be the caller.
131      *
132      * Emits an {ApprovalForAll} event.
133      */
134     function setApprovalForAll(address operator, bool _approved) external;
135 
136     /**
137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
138      *
139      * See {setApprovalForAll}
140      */
141     function isApprovedForAll(address owner, address operator) external view returns (bool);
142 
143     /**
144       * @dev Safely transfers `tokenId` token from `from` to `to`.
145       *
146       * Requirements:
147       *
148       * - `from` cannot be the zero address.
149       * - `to` cannot be the zero address.
150       * - `tokenId` token must exist and be owned by `from`.
151       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
152       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
153       *
154       * Emits a {Transfer} event.
155       */
156     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
157 }
158 
159 
160 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
161 
162 pragma solidity ^0.8.0;
163 
164 /**
165  * @title ERC721 token receiver interface
166  * @dev Interface for any contract that wants to support safeTransfers
167  * from ERC721 asset contracts.
168  */
169 interface IERC721Receiver {
170     /**
171      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
172      * by `operator` from `from`, this function is called.
173      *
174      * It must return its Solidity selector to confirm the token transfer.
175      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
176      *
177      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
178      */
179     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
180 }
181 
182 
183 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
184 
185 pragma solidity ^0.8.0;
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
209 
210 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
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
400 
401 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
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
426 
427 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
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
495 
496 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Implementation of the {IERC165} interface.
502  *
503  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
504  * for the additional interface id that will be supported. For example:
505  *
506  * ```solidity
507  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
508  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
509  * }
510  * ```
511  *
512  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
513  */
514 abstract contract ERC165 is IERC165 {
515     /**
516      * @dev See {IERC165-supportsInterface}.
517      */
518     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
519         return interfaceId == type(IERC165).interfaceId;
520     }
521 }
522 
523 
524 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
530  * the Metadata extension, but not including the Enumerable extension, which is available separately as
531  * {ERC721Enumerable}.
532  */
533 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
534     using Address for address;
535     using Strings for uint256;
536 
537     // Token name
538     string private _name;
539 
540     // Token symbol
541     string private _symbol;
542 
543     // Mapping from token ID to owner address
544     mapping (uint256 => address) private _owners;
545 
546     // Mapping owner address to token count
547     mapping (address => uint256) private _balances;
548 
549     // Mapping from token ID to approved address
550     mapping (uint256 => address) private _tokenApprovals;
551 
552     // Mapping from owner to operator approvals
553     mapping (address => mapping (address => bool)) private _operatorApprovals;
554 
555     /**
556      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
557      */
558     constructor (string memory name_, string memory symbol_) {
559         _name = name_;
560         _symbol = symbol_;
561     }
562 
563     /**
564      * @dev See {IERC165-supportsInterface}.
565      */
566     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
567         return interfaceId == type(IERC721).interfaceId
568             || interfaceId == type(IERC721Metadata).interfaceId
569             || super.supportsInterface(interfaceId);
570     }
571 
572     /**
573      * @dev See {IERC721-balanceOf}.
574      */
575     function balanceOf(address owner) public view virtual override returns (uint256) {
576         require(owner != address(0), "ERC721: balance query for the zero address");
577         return _balances[owner];
578     }
579 
580     /**
581      * @dev See {IERC721-ownerOf}.
582      */
583     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
584         address owner = _owners[tokenId];
585         require(owner != address(0), "ERC721: owner query for nonexistent token");
586         return owner;
587     }
588 
589     /**
590      * @dev See {IERC721Metadata-name}.
591      */
592     function name() public view virtual override returns (string memory) {
593         return _name;
594     }
595 
596     /**
597      * @dev See {IERC721Metadata-symbol}.
598      */
599     function symbol() public view virtual override returns (string memory) {
600         return _symbol;
601     }
602 
603     /**
604      * @dev See {IERC721Metadata-tokenURI}.
605      */
606     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
607         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
608 
609         string memory baseURI = _baseURI();
610         return bytes(baseURI).length > 0
611             ? string(abi.encodePacked(baseURI, tokenId.toString()))
612             : '';
613     }
614 
615     /**
616      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
617      * in child contracts.
618      */
619     function _baseURI() internal view virtual returns (string memory) {
620         return "";
621     }
622 
623     /**
624      * @dev See {IERC721-approve}.
625      */
626     function approve(address to, uint256 tokenId) public virtual override {
627         address owner = ERC721.ownerOf(tokenId);
628         require(to != owner, "ERC721: approval to current owner");
629 
630         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
631             "ERC721: approve caller is not owner nor approved for all"
632         );
633 
634         _approve(to, tokenId);
635     }
636 
637     /**
638      * @dev See {IERC721-getApproved}.
639      */
640     function getApproved(uint256 tokenId) public view virtual override returns (address) {
641         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
642 
643         return _tokenApprovals[tokenId];
644     }
645 
646     /**
647      * @dev See {IERC721-setApprovalForAll}.
648      */
649     function setApprovalForAll(address operator, bool approved) public virtual override {
650         require(operator != _msgSender(), "ERC721: approve to caller");
651 
652         _operatorApprovals[_msgSender()][operator] = approved;
653         emit ApprovalForAll(_msgSender(), operator, approved);
654     }
655 
656     /**
657      * @dev See {IERC721-isApprovedForAll}.
658      */
659     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
660         return _operatorApprovals[owner][operator];
661     }
662 
663     /**
664      * @dev See {IERC721-transferFrom}.
665      */
666     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
667         //solhint-disable-next-line max-line-length
668         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
669 
670         _transfer(from, to, tokenId);
671     }
672 
673     /**
674      * @dev See {IERC721-safeTransferFrom}.
675      */
676     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
677         safeTransferFrom(from, to, tokenId, "");
678     }
679 
680     /**
681      * @dev See {IERC721-safeTransferFrom}.
682      */
683     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
684         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
685         _safeTransfer(from, to, tokenId, _data);
686     }
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
690      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
691      *
692      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
693      *
694      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
695      * implement alternative mechanisms to perform token transfer, such as signature-based.
696      *
697      * Requirements:
698      *
699      * - `from` cannot be the zero address.
700      * - `to` cannot be the zero address.
701      * - `tokenId` token must exist and be owned by `from`.
702      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
703      *
704      * Emits a {Transfer} event.
705      */
706     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
707         _transfer(from, to, tokenId);
708         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
709     }
710 
711     /**
712      * @dev Returns whether `tokenId` exists.
713      *
714      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
715      *
716      * Tokens start existing when they are minted (`_mint`),
717      * and stop existing when they are burned (`_burn`).
718      */
719     function _exists(uint256 tokenId) internal view virtual returns (bool) {
720         return _owners[tokenId] != address(0);
721     }
722 
723     /**
724      * @dev Returns whether `spender` is allowed to manage `tokenId`.
725      *
726      * Requirements:
727      *
728      * - `tokenId` must exist.
729      */
730     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
731         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
732         address owner = ERC721.ownerOf(tokenId);
733         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
734     }
735 
736     /**
737      * @dev Safely mints `tokenId` and transfers it to `to`.
738      *
739      * Requirements:
740      *
741      * - `tokenId` must not exist.
742      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
743      *
744      * Emits a {Transfer} event.
745      */
746     function _safeMint(address to, uint256 tokenId) internal virtual {
747         _safeMint(to, tokenId, "");
748     }
749 
750     /**
751      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
752      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
753      */
754     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
755         _mint(to, tokenId);
756         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
757     }
758 
759     /**
760      * @dev Mints `tokenId` and transfers it to `to`.
761      *
762      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
763      *
764      * Requirements:
765      *
766      * - `tokenId` must not exist.
767      * - `to` cannot be the zero address.
768      *
769      * Emits a {Transfer} event.
770      */
771     function _mint(address to, uint256 tokenId) internal virtual {
772         require(to != address(0), "ERC721: mint to the zero address");
773         require(!_exists(tokenId), "ERC721: token already minted");
774 
775         _beforeTokenTransfer(address(0), to, tokenId);
776 
777         _balances[to] += 1;
778         _owners[tokenId] = to;
779 
780         emit Transfer(address(0), to, tokenId);
781     }
782 
783     /**
784      * @dev Destroys `tokenId`.
785      * The approval is cleared when the token is burned.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must exist.
790      *
791      * Emits a {Transfer} event.
792      */
793     function _burn(uint256 tokenId) internal virtual {
794         address owner = ERC721.ownerOf(tokenId);
795 
796         _beforeTokenTransfer(owner, address(0), tokenId);
797 
798         // Clear approvals
799         _approve(address(0), tokenId);
800 
801         _balances[owner] -= 1;
802         delete _owners[tokenId];
803 
804         emit Transfer(owner, address(0), tokenId);
805     }
806 
807     /**
808      * @dev Transfers `tokenId` from `from` to `to`.
809      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
810      *
811      * Requirements:
812      *
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must be owned by `from`.
815      *
816      * Emits a {Transfer} event.
817      */
818     function _transfer(address from, address to, uint256 tokenId) internal virtual {
819         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
820         require(to != address(0), "ERC721: transfer to the zero address");
821 
822         _beforeTokenTransfer(from, to, tokenId);
823 
824         // Clear approvals from the previous owner
825         _approve(address(0), tokenId);
826 
827         _balances[from] -= 1;
828         _balances[to] += 1;
829         _owners[tokenId] = to;
830 
831         emit Transfer(from, to, tokenId);
832     }
833 
834     /**
835      * @dev Approve `to` to operate on `tokenId`
836      *
837      * Emits a {Approval} event.
838      */
839     function _approve(address to, uint256 tokenId) internal virtual {
840         _tokenApprovals[tokenId] = to;
841         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
842     }
843 
844     /**
845      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
846      * The call is not executed if the target address is not a contract.
847      *
848      * @param from address representing the previous owner of the given token ID
849      * @param to target address that will receive the tokens
850      * @param tokenId uint256 ID of the token to be transferred
851      * @param _data bytes optional data to send along with the call
852      * @return bool whether the call correctly returned the expected magic value
853      */
854     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
855         private returns (bool)
856     {
857         if (to.isContract()) {
858             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
859                 return retval == IERC721Receiver(to).onERC721Received.selector;
860             } catch (bytes memory reason) {
861                 if (reason.length == 0) {
862                     revert("ERC721: transfer to non ERC721Receiver implementer");
863                 } else {
864                     // solhint-disable-next-line no-inline-assembly
865                     assembly {
866                         revert(add(32, reason), mload(reason))
867                     }
868                 }
869             }
870         } else {
871             return true;
872         }
873     }
874 
875     /**
876      * @dev Hook that is called before any token transfer. This includes minting
877      * and burning.
878      *
879      * Calling conditions:
880      *
881      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
882      * transferred to `to`.
883      * - When `from` is zero, `tokenId` will be minted for `to`.
884      * - When `to` is zero, ``from``'s `tokenId` will be burned.
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      *
888      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
889      */
890     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
891 }
892 
893 
894 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.1.0
895 
896 pragma solidity ^0.8.0;
897 
898 /**
899  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
900  * @dev See https://eips.ethereum.org/EIPS/eip-721
901  */
902 interface IERC721Enumerable is IERC721 {
903 
904     /**
905      * @dev Returns the total amount of tokens stored by the contract.
906      */
907     function totalSupply() external view returns (uint256);
908 
909     /**
910      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
911      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
912      */
913     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
914 
915     /**
916      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
917      * Use along with {totalSupply} to enumerate all tokens.
918      */
919     function tokenByIndex(uint256 index) external view returns (uint256);
920 }
921 
922 
923 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.1.0
924 
925 pragma solidity ^0.8.0;
926 
927 /**
928  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
929  * enumerability of all the token ids in the contract as well as all token ids owned by each
930  * account.
931  */
932 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
933     // Mapping from owner to list of owned token IDs
934     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
935 
936     // Mapping from token ID to index of the owner tokens list
937     mapping(uint256 => uint256) private _ownedTokensIndex;
938 
939     // Array with all token ids, used for enumeration
940     uint256[] private _allTokens;
941 
942     // Mapping from token id to position in the allTokens array
943     mapping(uint256 => uint256) private _allTokensIndex;
944 
945     /**
946      * @dev See {IERC165-supportsInterface}.
947      */
948     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
949         return interfaceId == type(IERC721Enumerable).interfaceId
950             || super.supportsInterface(interfaceId);
951     }
952 
953     /**
954      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
955      */
956     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
957         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
958         return _ownedTokens[owner][index];
959     }
960 
961     /**
962      * @dev See {IERC721Enumerable-totalSupply}.
963      */
964     function totalSupply() public view virtual override returns (uint256) {
965         return _allTokens.length;
966     }
967 
968     /**
969      * @dev See {IERC721Enumerable-tokenByIndex}.
970      */
971     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
972         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
973         return _allTokens[index];
974     }
975 
976     /**
977      * @dev Hook that is called before any token transfer. This includes minting
978      * and burning.
979      *
980      * Calling conditions:
981      *
982      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
983      * transferred to `to`.
984      * - When `from` is zero, `tokenId` will be minted for `to`.
985      * - When `to` is zero, ``from``'s `tokenId` will be burned.
986      * - `from` cannot be the zero address.
987      * - `to` cannot be the zero address.
988      *
989      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
990      */
991     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
992         super._beforeTokenTransfer(from, to, tokenId);
993 
994         if (from == address(0)) {
995             _addTokenToAllTokensEnumeration(tokenId);
996         } else if (from != to) {
997             _removeTokenFromOwnerEnumeration(from, tokenId);
998         }
999         if (to == address(0)) {
1000             _removeTokenFromAllTokensEnumeration(tokenId);
1001         } else if (to != from) {
1002             _addTokenToOwnerEnumeration(to, tokenId);
1003         }
1004     }
1005 
1006     /**
1007      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1008      * @param to address representing the new owner of the given token ID
1009      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1010      */
1011     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1012         uint256 length = ERC721.balanceOf(to);
1013         _ownedTokens[to][length] = tokenId;
1014         _ownedTokensIndex[tokenId] = length;
1015     }
1016 
1017     /**
1018      * @dev Private function to add a token to this extension's token tracking data structures.
1019      * @param tokenId uint256 ID of the token to be added to the tokens list
1020      */
1021     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1022         _allTokensIndex[tokenId] = _allTokens.length;
1023         _allTokens.push(tokenId);
1024     }
1025 
1026     /**
1027      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1028      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1029      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1030      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1031      * @param from address representing the previous owner of the given token ID
1032      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1033      */
1034     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1035         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1036         // then delete the last slot (swap and pop).
1037 
1038         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1039         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1040 
1041         // When the token to delete is the last token, the swap operation is unnecessary
1042         if (tokenIndex != lastTokenIndex) {
1043             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1044 
1045             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1046             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1047         }
1048 
1049         // This also deletes the contents at the last position of the array
1050         delete _ownedTokensIndex[tokenId];
1051         delete _ownedTokens[from][lastTokenIndex];
1052     }
1053 
1054     /**
1055      * @dev Private function to remove a token from this extension's token tracking data structures.
1056      * This has O(1) time complexity, but alters the order of the _allTokens array.
1057      * @param tokenId uint256 ID of the token to be removed from the tokens list
1058      */
1059     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1060         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1061         // then delete the last slot (swap and pop).
1062 
1063         uint256 lastTokenIndex = _allTokens.length - 1;
1064         uint256 tokenIndex = _allTokensIndex[tokenId];
1065 
1066         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1067         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1068         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1069         uint256 lastTokenId = _allTokens[lastTokenIndex];
1070 
1071         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1072         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1073 
1074         // This also deletes the contents at the last position of the array
1075         delete _allTokensIndex[tokenId];
1076         _allTokens.pop();
1077     }
1078 }
1079 
1080 
1081 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 /**
1086  * @dev Contract module which provides a basic access control mechanism, where
1087  * there is an account (an owner) that can be granted exclusive access to
1088  * specific functions.
1089  *
1090  * By default, the owner account will be the one that deploys the contract. This
1091  * can later be changed with {transferOwnership}.
1092  *
1093  * This module is used through inheritance. It will make available the modifier
1094  * `onlyOwner`, which can be applied to your functions to restrict their use to
1095  * the owner.
1096  */
1097 abstract contract Ownable is Context {
1098     address private _owner;
1099 
1100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1101 
1102     /**
1103      * @dev Initializes the contract setting the deployer as the initial owner.
1104      */
1105     constructor () {
1106         address msgSender = _msgSender();
1107         _owner = msgSender;
1108         emit OwnershipTransferred(address(0), msgSender);
1109     }
1110 
1111     /**
1112      * @dev Returns the address of the current owner.
1113      */
1114     function owner() public view virtual returns (address) {
1115         return _owner;
1116     }
1117 
1118     /**
1119      * @dev Throws if called by any account other than the owner.
1120      */
1121     modifier onlyOwner() {
1122         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1123         _;
1124     }
1125 
1126     /**
1127      * @dev Leaves the contract without owner. It will not be possible to call
1128      * `onlyOwner` functions anymore. Can only be called by the current owner.
1129      *
1130      * NOTE: Renouncing ownership will leave the contract without an owner,
1131      * thereby removing any functionality that is only available to the owner.
1132      */
1133     function renounceOwnership() public virtual onlyOwner {
1134         emit OwnershipTransferred(_owner, address(0));
1135         _owner = address(0);
1136     }
1137 
1138     /**
1139      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1140      * Can only be called by the current owner.
1141      */
1142     function transferOwnership(address newOwner) public virtual onlyOwner {
1143         require(newOwner != address(0), "Ownable: new owner is the zero address");
1144         emit OwnershipTransferred(_owner, newOwner);
1145         _owner = newOwner;
1146     }
1147 }
1148 
1149 
1150 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.1.0
1151 
1152 pragma solidity ^0.8.0;
1153 
1154 // CAUTION
1155 // This version of SafeMath should only be used with Solidity 0.8 or later,
1156 // because it relies on the compiler's built in overflow checks.
1157 
1158 /**
1159  * @dev Wrappers over Solidity's arithmetic operations.
1160  *
1161  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1162  * now has built in overflow checking.
1163  */
1164 library SafeMath {
1165     /**
1166      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1167      *
1168      * _Available since v3.4._
1169      */
1170     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1171         unchecked {
1172             uint256 c = a + b;
1173             if (c < a) return (false, 0);
1174             return (true, c);
1175         }
1176     }
1177 
1178     /**
1179      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1180      *
1181      * _Available since v3.4._
1182      */
1183     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1184         unchecked {
1185             if (b > a) return (false, 0);
1186             return (true, a - b);
1187         }
1188     }
1189 
1190     /**
1191      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1192      *
1193      * _Available since v3.4._
1194      */
1195     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1196         unchecked {
1197             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1198             // benefit is lost if 'b' is also tested.
1199             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1200             if (a == 0) return (true, 0);
1201             uint256 c = a * b;
1202             if (c / a != b) return (false, 0);
1203             return (true, c);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1209      *
1210      * _Available since v3.4._
1211      */
1212     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1213         unchecked {
1214             if (b == 0) return (false, 0);
1215             return (true, a / b);
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1221      *
1222      * _Available since v3.4._
1223      */
1224     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1225         unchecked {
1226             if (b == 0) return (false, 0);
1227             return (true, a % b);
1228         }
1229     }
1230 
1231     /**
1232      * @dev Returns the addition of two unsigned integers, reverting on
1233      * overflow.
1234      *
1235      * Counterpart to Solidity's `+` operator.
1236      *
1237      * Requirements:
1238      *
1239      * - Addition cannot overflow.
1240      */
1241     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1242         return a + b;
1243     }
1244 
1245     /**
1246      * @dev Returns the subtraction of two unsigned integers, reverting on
1247      * overflow (when the result is negative).
1248      *
1249      * Counterpart to Solidity's `-` operator.
1250      *
1251      * Requirements:
1252      *
1253      * - Subtraction cannot overflow.
1254      */
1255     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1256         return a - b;
1257     }
1258 
1259     /**
1260      * @dev Returns the multiplication of two unsigned integers, reverting on
1261      * overflow.
1262      *
1263      * Counterpart to Solidity's `*` operator.
1264      *
1265      * Requirements:
1266      *
1267      * - Multiplication cannot overflow.
1268      */
1269     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1270         return a * b;
1271     }
1272 
1273     /**
1274      * @dev Returns the integer division of two unsigned integers, reverting on
1275      * division by zero. The result is rounded towards zero.
1276      *
1277      * Counterpart to Solidity's `/` operator.
1278      *
1279      * Requirements:
1280      *
1281      * - The divisor cannot be zero.
1282      */
1283     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1284         return a / b;
1285     }
1286 
1287     /**
1288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1289      * reverting when dividing by zero.
1290      *
1291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1292      * opcode (which leaves remaining gas untouched) while Solidity uses an
1293      * invalid opcode to revert (consuming all remaining gas).
1294      *
1295      * Requirements:
1296      *
1297      * - The divisor cannot be zero.
1298      */
1299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1300         return a % b;
1301     }
1302 
1303     /**
1304      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1305      * overflow (when the result is negative).
1306      *
1307      * CAUTION: This function is deprecated because it requires allocating memory for the error
1308      * message unnecessarily. For custom revert reasons use {trySub}.
1309      *
1310      * Counterpart to Solidity's `-` operator.
1311      *
1312      * Requirements:
1313      *
1314      * - Subtraction cannot overflow.
1315      */
1316     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1317         unchecked {
1318             require(b <= a, errorMessage);
1319             return a - b;
1320         }
1321     }
1322 
1323     /**
1324      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1325      * division by zero. The result is rounded towards zero.
1326      *
1327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1328      * opcode (which leaves remaining gas untouched) while Solidity uses an
1329      * invalid opcode to revert (consuming all remaining gas).
1330      *
1331      * Counterpart to Solidity's `/` operator. Note: this function uses a
1332      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1333      * uses an invalid opcode to revert (consuming all remaining gas).
1334      *
1335      * Requirements:
1336      *
1337      * - The divisor cannot be zero.
1338      */
1339     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1340         unchecked {
1341             require(b > 0, errorMessage);
1342             return a / b;
1343         }
1344     }
1345 
1346     /**
1347      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1348      * reverting with custom message when dividing by zero.
1349      *
1350      * CAUTION: This function is deprecated because it requires allocating memory for the error
1351      * message unnecessarily. For custom revert reasons use {tryMod}.
1352      *
1353      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1354      * opcode (which leaves remaining gas untouched) while Solidity uses an
1355      * invalid opcode to revert (consuming all remaining gas).
1356      *
1357      * Requirements:
1358      *
1359      * - The divisor cannot be zero.
1360      */
1361     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1362         unchecked {
1363             require(b > 0, errorMessage);
1364             return a % b;
1365         }
1366     }
1367 }
1368 
1369 
1370 // File contracts/JoblessGiraffes.sol
1371 
1372 pragma solidity ^0.8.0;
1373  contract JoblessGiraffes is ERC721Enumerable, Ownable {
1374     using SafeMath for uint256;
1375     using Address for address;
1376     
1377     string public PROVENANCE;
1378     string private baseURI;
1379 
1380     uint256 public maxSupply;
1381     uint256 public price = 0.06 ether;
1382 
1383     bool public presaleActive = false;
1384     bool public saleActive = false;
1385 
1386     mapping (address => uint256) public presaleWhitelist;
1387 
1388     constructor(uint256 supply) ERC721("Jobless Giraffes", "GIRAFFES") {
1389         maxSupply = supply;
1390     }
1391     
1392     function reserve() public onlyOwner {
1393         uint256 supply = totalSupply();
1394         for (uint256 i = 0; i < 50; i++) {
1395             _safeMint(msg.sender, supply + i);
1396         }
1397     }
1398 
1399     function mintPresale(uint256 numberOfMints) public payable {
1400         uint256 supply = totalSupply();
1401         uint256 reserved = presaleWhitelist[msg.sender];
1402         require(presaleActive,                              "Presale must be active to mint");
1403         require(reserved > 0,                               "No tokens reserved for this address");
1404         require(numberOfMints <= reserved,                  "Can't mint more than reserved");
1405         require(supply.add(numberOfMints) <= maxSupply,     "Purchase would exceed max supply of tokens");
1406         require(price.mul(numberOfMints) == msg.value,      "Ether value sent is not correct");
1407         presaleWhitelist[msg.sender] = reserved - numberOfMints;
1408 
1409         for(uint256 i; i < numberOfMints; i++){
1410             _safeMint( msg.sender, supply + i );
1411         }
1412     }
1413     
1414     function mint(uint256 numberOfMints) public payable {
1415         uint256 supply = totalSupply();
1416         require(saleActive,                                 "Sale must be active to mint");
1417         require(numberOfMints > 0 && numberOfMints < 11,    "Invalid purchase amount");
1418         require(supply.add(numberOfMints) <= maxSupply,     "Purchase would exceed max supply of tokens");
1419         require(price.mul(numberOfMints) == msg.value,      "Ether value sent is not correct");
1420         
1421         for(uint256 i; i < numberOfMints; i++) {
1422             _safeMint(msg.sender, supply + i);
1423         }
1424     }
1425 
1426     function editPresale(address[] memory presaleAddresses) public onlyOwner {
1427         for(uint256 i; i < presaleAddresses.length; i++){
1428             presaleWhitelist[presaleAddresses[i]] = 2;
1429         }
1430     }
1431     
1432     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1433         uint256 tokenCount = balanceOf(_owner);
1434 
1435         uint256[] memory tokensId = new uint256[](tokenCount);
1436         for(uint256 i; i < tokenCount; i++){
1437             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1438         }
1439         return tokensId;
1440     }
1441 
1442     function withdraw() public onlyOwner {
1443         uint256 balance = address(this).balance;
1444         payable(msg.sender).transfer(balance);
1445     }
1446 
1447     function togglePresale() public onlyOwner {
1448         presaleActive = !presaleActive;
1449     }
1450 
1451     function toggleSale() public onlyOwner {
1452         saleActive = !saleActive;
1453     }
1454 
1455     function setPrice(uint256 newPrice) public onlyOwner {
1456         price = newPrice;
1457     }
1458 
1459     function setProvenance(string memory provenance) public onlyOwner {
1460         PROVENANCE = provenance;
1461     }
1462     
1463     function setBaseURI(string memory uri) public onlyOwner {
1464         baseURI = uri;
1465     }
1466     
1467     function _baseURI() internal view override returns (string memory) {
1468         return baseURI;
1469     }
1470  }