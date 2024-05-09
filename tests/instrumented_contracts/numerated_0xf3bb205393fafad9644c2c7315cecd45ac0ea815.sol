1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
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
31 
32 pragma solidity ^0.8.0;
33 
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
159 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
160 
161 
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @title ERC721 token receiver interface
167  * @dev Interface for any contract that wants to support safeTransfers
168  * from ERC721 asset contracts.
169  */
170 interface IERC721Receiver {
171     /**
172      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
173      * by `operator` from `from`, this function is called.
174      *
175      * It must return its Solidity selector to confirm the token transfer.
176      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
177      *
178      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
179      */
180     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
181 }
182 
183 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
184 
185 
186 
187 pragma solidity ^0.8.0;
188 
189 
190 /**
191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
192  * @dev See https://eips.ethereum.org/EIPS/eip-721
193  */
194 interface IERC721Metadata is IERC721 {
195 
196     /**
197      * @dev Returns the token collection name.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the token collection symbol.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
208      */
209     function tokenURI(uint256 tokenId) external view returns (string memory);
210 }
211 
212 // File: @openzeppelin/contracts/utils/Address.sol
213 
214 
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @dev Collection of functions related to the address type
220  */
221 library Address {
222     /**
223      * @dev Returns true if `account` is a contract.
224      *
225      * [IMPORTANT]
226      * ====
227      * It is unsafe to assume that an address for which this function returns
228      * false is an externally-owned account (EOA) and not a contract.
229      *
230      * Among others, `isContract` will return false for the following
231      * types of addresses:
232      *
233      *  - an externally-owned account
234      *  - a contract in construction
235      *  - an address where a contract will be created
236      *  - an address where a contract lived, but was destroyed
237      * ====
238      */
239     function isContract(address account) internal view returns (bool) {
240         // This method relies on extcodesize, which returns 0 for contracts in
241         // construction, since the code is only stored at the end of the
242         // constructor execution.
243 
244         uint256 size;
245         // solhint-disable-next-line no-inline-assembly
246         assembly { size := extcodesize(account) }
247         return size > 0;
248     }
249 
250     /**
251      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
252      * `recipient`, forwarding all available gas and reverting on errors.
253      *
254      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
255      * of certain opcodes, possibly making contracts go over the 2300 gas limit
256      * imposed by `transfer`, making them unable to receive funds via
257      * `transfer`. {sendValue} removes this limitation.
258      *
259      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
260      *
261      * IMPORTANT: because control is transferred to `recipient`, care must be
262      * taken to not create reentrancy vulnerabilities. Consider using
263      * {ReentrancyGuard} or the
264      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
265      */
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268 
269         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
270         (bool success, ) = recipient.call{ value: amount }("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain`call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
293       return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
303         return functionCallWithValue(target, data, 0, errorMessage);
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
308      * but also transferring `value` wei to `target`.
309      *
310      * Requirements:
311      *
312      * - the calling contract must have an ETH balance of at least `value`.
313      * - the called Solidity function must be `payable`.
314      *
315      * _Available since v3.1._
316      */
317     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
323      * with `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
328         require(address(this).balance >= value, "Address: insufficient balance for call");
329         require(isContract(target), "Address: call to non-contract");
330 
331         // solhint-disable-next-line avoid-low-level-calls
332         (bool success, bytes memory returndata) = target.call{ value: value }(data);
333         return _verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
343         return functionStaticCall(target, data, "Address: low-level static call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a static call.
349      *
350      * _Available since v3.3._
351      */
352     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
353         require(isContract(target), "Address: static call to non-contract");
354 
355         // solhint-disable-next-line avoid-low-level-calls
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return _verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
377         require(isContract(target), "Address: delegate call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.delegatecall(data);
381         return _verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 // File: @openzeppelin/contracts/utils/Context.sol
405 
406 
407 
408 pragma solidity ^0.8.0;
409 
410 /*
411  * @dev Provides information about the current execution context, including the
412  * sender of the transaction and its data. While these are generally available
413  * via msg.sender and msg.data, they should not be accessed in such a direct
414  * manner, since when dealing with meta-transactions the account sending and
415  * paying for execution may not be the actual sender (as far as an application
416  * is concerned).
417  *
418  * This contract is only required for intermediate, library-like contracts.
419  */
420 abstract contract Context {
421     function _msgSender() internal view virtual returns (address) {
422         return msg.sender;
423     }
424 
425     function _msgData() internal view virtual returns (bytes calldata) {
426         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
427         return msg.data;
428     }
429 }
430 
431 // File: @openzeppelin/contracts/utils/Strings.sol
432 
433 
434 
435 pragma solidity ^0.8.0;
436 
437 /**
438  * @dev String operations.
439  */
440 library Strings {
441     bytes16 private constant alphabet = "0123456789abcdef";
442 
443     /**
444      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
445      */
446     function toString(uint256 value) internal pure returns (string memory) {
447         // Inspired by OraclizeAPI's implementation - MIT licence
448         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
449 
450         if (value == 0) {
451             return "0";
452         }
453         uint256 temp = value;
454         uint256 digits;
455         while (temp != 0) {
456             digits++;
457             temp /= 10;
458         }
459         bytes memory buffer = new bytes(digits);
460         while (value != 0) {
461             digits -= 1;
462             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
463             value /= 10;
464         }
465         return string(buffer);
466     }
467 
468     /**
469      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
470      */
471     function toHexString(uint256 value) internal pure returns (string memory) {
472         if (value == 0) {
473             return "0x00";
474         }
475         uint256 temp = value;
476         uint256 length = 0;
477         while (temp != 0) {
478             length++;
479             temp >>= 8;
480         }
481         return toHexString(value, length);
482     }
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
486      */
487     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
488         bytes memory buffer = new bytes(2 * length + 2);
489         buffer[0] = "0";
490         buffer[1] = "x";
491         for (uint256 i = 2 * length + 1; i > 1; --i) {
492             buffer[i] = alphabet[value & 0xf];
493             value >>= 4;
494         }
495         require(value == 0, "Strings: hex length insufficient");
496         return string(buffer);
497     }
498 
499 }
500 
501 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
502 
503 
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Implementation of the {IERC165} interface.
510  *
511  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
512  * for the additional interface id that will be supported. For example:
513  *
514  * ```solidity
515  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
517  * }
518  * ```
519  *
520  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
521  */
522 abstract contract ERC165 is IERC165 {
523     /**
524      * @dev See {IERC165-supportsInterface}.
525      */
526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527         return interfaceId == type(IERC165).interfaceId;
528     }
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
532 
533 
534 
535 pragma solidity ^0.8.0;
536 
537 
538 
539 
540 
541 
542 
543 
544 /**
545  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
546  * the Metadata extension, but not including the Enumerable extension, which is available separately as
547  * {ERC721Enumerable}.
548  */
549 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
550     using Address for address;
551     using Strings for uint256;
552 
553     // Token name
554     string private _name;
555 
556     // Token symbol
557     string private _symbol;
558 
559     // Mapping from token ID to owner address
560     mapping (uint256 => address) private _owners;
561 
562     // Mapping owner address to token count
563     mapping (address => uint256) private _balances;
564 
565     // Mapping from token ID to approved address
566     mapping (uint256 => address) private _tokenApprovals;
567 
568     // Mapping from owner to operator approvals
569     mapping (address => mapping (address => bool)) private _operatorApprovals;
570 
571     /**
572      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
573      */
574     constructor (string memory name_, string memory symbol_) {
575         _name = name_;
576         _symbol = symbol_;
577     }
578 
579     /**
580      * @dev See {IERC165-supportsInterface}.
581      */
582     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
583         return interfaceId == type(IERC721).interfaceId
584             || interfaceId == type(IERC721Metadata).interfaceId
585             || super.supportsInterface(interfaceId);
586     }
587 
588     /**
589      * @dev See {IERC721-balanceOf}.
590      */
591     function balanceOf(address owner) public view virtual override returns (uint256) {
592         require(owner != address(0), "ERC721: balance query for the zero address");
593         return _balances[owner];
594     }
595 
596     /**
597      * @dev See {IERC721-ownerOf}.
598      */
599     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
600         address owner = _owners[tokenId];
601         require(owner != address(0), "ERC721: owner query for nonexistent token");
602         return owner;
603     }
604 
605     /**
606      * @dev See {IERC721Metadata-name}.
607      */
608     function name() public view virtual override returns (string memory) {
609         return _name;
610     }
611 
612     /**
613      * @dev See {IERC721Metadata-symbol}.
614      */
615     function symbol() public view virtual override returns (string memory) {
616         return _symbol;
617     }
618 
619     /**
620      * @dev See {IERC721Metadata-tokenURI}.
621      */
622     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
623         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
624 
625         string memory baseURI = _baseURI();
626         return bytes(baseURI).length > 0
627             ? string(abi.encodePacked(baseURI, tokenId.toString()))
628             : '';
629     }
630 
631     /**
632      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
633      * in child contracts.
634      */
635     function _baseURI() internal view virtual returns (string memory) {
636         return "";
637     }
638 
639     /**
640      * @dev See {IERC721-approve}.
641      */
642     function approve(address to, uint256 tokenId) public virtual override {
643         address owner = ERC721.ownerOf(tokenId);
644         require(to != owner, "ERC721: approval to current owner");
645 
646         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
647             "ERC721: approve caller is not owner nor approved for all"
648         );
649 
650         _approve(to, tokenId);
651     }
652 
653     /**
654      * @dev See {IERC721-getApproved}.
655      */
656     function getApproved(uint256 tokenId) public view virtual override returns (address) {
657         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
658 
659         return _tokenApprovals[tokenId];
660     }
661 
662     /**
663      * @dev See {IERC721-setApprovalForAll}.
664      */
665     function setApprovalForAll(address operator, bool approved) public virtual override {
666         require(operator != _msgSender(), "ERC721: approve to caller");
667 
668         _operatorApprovals[_msgSender()][operator] = approved;
669         emit ApprovalForAll(_msgSender(), operator, approved);
670     }
671 
672     /**
673      * @dev See {IERC721-isApprovedForAll}.
674      */
675     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
676         return _operatorApprovals[owner][operator];
677     }
678 
679     /**
680      * @dev See {IERC721-transferFrom}.
681      */
682     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
683         //solhint-disable-next-line max-line-length
684         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
685 
686         _transfer(from, to, tokenId);
687     }
688 
689     /**
690      * @dev See {IERC721-safeTransferFrom}.
691      */
692     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
693         safeTransferFrom(from, to, tokenId, "");
694     }
695 
696     /**
697      * @dev See {IERC721-safeTransferFrom}.
698      */
699     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
700         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
701         _safeTransfer(from, to, tokenId, _data);
702     }
703 
704     /**
705      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
706      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
707      *
708      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
709      *
710      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
711      * implement alternative mechanisms to perform token transfer, such as signature-based.
712      *
713      * Requirements:
714      *
715      * - `from` cannot be the zero address.
716      * - `to` cannot be the zero address.
717      * - `tokenId` token must exist and be owned by `from`.
718      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
719      *
720      * Emits a {Transfer} event.
721      */
722     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
723         _transfer(from, to, tokenId);
724         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
725     }
726 
727     /**
728      * @dev Returns whether `tokenId` exists.
729      *
730      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
731      *
732      * Tokens start existing when they are minted (`_mint`),
733      * and stop existing when they are burned (`_burn`).
734      */
735     function _exists(uint256 tokenId) internal view virtual returns (bool) {
736         return _owners[tokenId] != address(0);
737     }
738 
739     /**
740      * @dev Returns whether `spender` is allowed to manage `tokenId`.
741      *
742      * Requirements:
743      *
744      * - `tokenId` must exist.
745      */
746     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
747         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
748         address owner = ERC721.ownerOf(tokenId);
749         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
750     }
751 
752     /**
753      * @dev Safely mints `tokenId` and transfers it to `to`.
754      *
755      * Requirements:
756      *
757      * - `tokenId` must not exist.
758      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
759      *
760      * Emits a {Transfer} event.
761      */
762     function _safeMint(address to, uint256 tokenId) internal virtual {
763         _safeMint(to, tokenId, "");
764     }
765 
766     /**
767      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
768      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
769      */
770     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
771         _mint(to, tokenId);
772         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
773     }
774 
775     /**
776      * @dev Mints `tokenId` and transfers it to `to`.
777      *
778      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
779      *
780      * Requirements:
781      *
782      * - `tokenId` must not exist.
783      * - `to` cannot be the zero address.
784      *
785      * Emits a {Transfer} event.
786      */
787     function _mint(address to, uint256 tokenId) internal virtual {
788         require(to != address(0), "ERC721: mint to the zero address");
789         require(!_exists(tokenId), "ERC721: token already minted");
790 
791         _beforeTokenTransfer(address(0), to, tokenId);
792 
793         _balances[to] += 1;
794         _owners[tokenId] = to;
795 
796         emit Transfer(address(0), to, tokenId);
797     }
798 
799     /**
800      * @dev Destroys `tokenId`.
801      * The approval is cleared when the token is burned.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _burn(uint256 tokenId) internal virtual {
810         address owner = ERC721.ownerOf(tokenId);
811 
812         _beforeTokenTransfer(owner, address(0), tokenId);
813 
814         // Clear approvals
815         _approve(address(0), tokenId);
816 
817         _balances[owner] -= 1;
818         delete _owners[tokenId];
819 
820         emit Transfer(owner, address(0), tokenId);
821     }
822 
823     /**
824      * @dev Transfers `tokenId` from `from` to `to`.
825      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
826      *
827      * Requirements:
828      *
829      * - `to` cannot be the zero address.
830      * - `tokenId` token must be owned by `from`.
831      *
832      * Emits a {Transfer} event.
833      */
834     function _transfer(address from, address to, uint256 tokenId) internal virtual {
835         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
836         require(to != address(0), "ERC721: transfer to the zero address");
837 
838         _beforeTokenTransfer(from, to, tokenId);
839 
840         // Clear approvals from the previous owner
841         _approve(address(0), tokenId);
842 
843         _balances[from] -= 1;
844         _balances[to] += 1;
845         _owners[tokenId] = to;
846 
847         emit Transfer(from, to, tokenId);
848     }
849 
850     /**
851      * @dev Approve `to` to operate on `tokenId`
852      *
853      * Emits a {Approval} event.
854      */
855     function _approve(address to, uint256 tokenId) internal virtual {
856         _tokenApprovals[tokenId] = to;
857         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
858     }
859 
860     /**
861      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
862      * The call is not executed if the target address is not a contract.
863      *
864      * @param from address representing the previous owner of the given token ID
865      * @param to target address that will receive the tokens
866      * @param tokenId uint256 ID of the token to be transferred
867      * @param _data bytes optional data to send along with the call
868      * @return bool whether the call correctly returned the expected magic value
869      */
870     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
871         private returns (bool)
872     {
873         if (to.isContract()) {
874             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
875                 return retval == IERC721Receiver(to).onERC721Received.selector;
876             } catch (bytes memory reason) {
877                 if (reason.length == 0) {
878                     revert("ERC721: transfer to non ERC721Receiver implementer");
879                 } else {
880                     // solhint-disable-next-line no-inline-assembly
881                     assembly {
882                         revert(add(32, reason), mload(reason))
883                     }
884                 }
885             }
886         } else {
887             return true;
888         }
889     }
890 
891     /**
892      * @dev Hook that is called before any token transfer. This includes minting
893      * and burning.
894      *
895      * Calling conditions:
896      *
897      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
898      * transferred to `to`.
899      * - When `from` is zero, `tokenId` will be minted for `to`.
900      * - When `to` is zero, ``from``'s `tokenId` will be burned.
901      * - `from` cannot be the zero address.
902      * - `to` cannot be the zero address.
903      *
904      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
905      */
906     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
907 }
908 
909 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
910 
911 
912 
913 pragma solidity ^0.8.0;
914 
915 
916 /**
917  * @dev ERC721 token with storage based token URI management.
918  */
919 abstract contract ERC721URIStorage is ERC721 {
920     using Strings for uint256;
921 
922     // Optional mapping for token URIs
923     mapping (uint256 => string) private _tokenURIs;
924 
925     /**
926      * @dev See {IERC721Metadata-tokenURI}.
927      */
928     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
929         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
930 
931         string memory _tokenURI = _tokenURIs[tokenId];
932         string memory base = _baseURI();
933 
934         // If there is no base URI, return the token URI.
935         if (bytes(base).length == 0) {
936             return _tokenURI;
937         }
938         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
939         if (bytes(_tokenURI).length > 0) {
940             return string(abi.encodePacked(base, _tokenURI));
941         }
942 
943         return super.tokenURI(tokenId);
944     }
945 
946     /**
947      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
948      *
949      * Requirements:
950      *
951      * - `tokenId` must exist.
952      */
953     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
954         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
955         _tokenURIs[tokenId] = _tokenURI;
956     }
957 
958     /**
959      * @dev Destroys `tokenId`.
960      * The approval is cleared when the token is burned.
961      *
962      * Requirements:
963      *
964      * - `tokenId` must exist.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _burn(uint256 tokenId) internal virtual override {
969         super._burn(tokenId);
970 
971         if (bytes(_tokenURIs[tokenId]).length != 0) {
972             delete _tokenURIs[tokenId];
973         }
974     }
975 }
976 
977 // File: @openzeppelin/contracts/utils/Counters.sol
978 
979 
980 
981 pragma solidity ^0.8.0;
982 
983 /**
984  * @title Counters
985  * @author Matt Condon (@shrugs)
986  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
987  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
988  *
989  * Include with `using Counters for Counters.Counter;`
990  */
991 library Counters {
992     struct Counter {
993         // This variable should never be directly accessed by users of the library: interactions must be restricted to
994         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
995         // this feature: see https://github.com/ethereum/solidity/issues/4637
996         uint256 _value; // default: 0
997     }
998 
999     function current(Counter storage counter) internal view returns (uint256) {
1000         return counter._value;
1001     }
1002 
1003     function increment(Counter storage counter) internal {
1004         unchecked {
1005             counter._value += 1;
1006         }
1007     }
1008 
1009     function decrement(Counter storage counter) internal {
1010         uint256 value = counter._value;
1011         require(value > 0, "Counter: decrement overflow");
1012         unchecked {
1013             counter._value = value - 1;
1014         }
1015     }
1016 }
1017 
1018 // File: @openzeppelin/contracts/access/Ownable.sol
1019 
1020 
1021 
1022 pragma solidity ^0.8.0;
1023 
1024 /**
1025  * @dev Contract module which provides a basic access control mechanism, where
1026  * there is an account (an owner) that can be granted exclusive access to
1027  * specific functions.
1028  *
1029  * By default, the owner account will be the one that deploys the contract. This
1030  * can later be changed with {transferOwnership}.
1031  *
1032  * This module is used through inheritance. It will make available the modifier
1033  * `onlyOwner`, which can be applied to your functions to restrict their use to
1034  * the owner.
1035  */
1036 abstract contract Ownable is Context {
1037     address private _owner;
1038 
1039     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1040 
1041     /**
1042      * @dev Initializes the contract setting the deployer as the initial owner.
1043      */
1044     constructor () {
1045         address msgSender = _msgSender();
1046         _owner = msgSender;
1047         emit OwnershipTransferred(address(0), msgSender);
1048     }
1049 
1050     /**
1051      * @dev Returns the address of the current owner.
1052      */
1053     function owner() public view virtual returns (address) {
1054         return _owner;
1055     }
1056 
1057     /**
1058      * @dev Throws if called by any account other than the owner.
1059      */
1060     modifier onlyOwner() {
1061         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1062         _;
1063     }
1064 
1065     /**
1066      * @dev Leaves the contract without owner. It will not be possible to call
1067      * `onlyOwner` functions anymore. Can only be called by the current owner.
1068      *
1069      * NOTE: Renouncing ownership will leave the contract without an owner,
1070      * thereby removing any functionality that is only available to the owner.
1071      */
1072     function renounceOwnership() public virtual onlyOwner {
1073         emit OwnershipTransferred(_owner, address(0));
1074         _owner = address(0);
1075     }
1076 
1077     /**
1078      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1079      * Can only be called by the current owner.
1080      */
1081     function transferOwnership(address newOwner) public virtual onlyOwner {
1082         require(newOwner != address(0), "Ownable: new owner is the zero address");
1083         emit OwnershipTransferred(_owner, newOwner);
1084         _owner = newOwner;
1085     }
1086 }
1087 
1088 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1089 
1090 
1091 
1092 pragma solidity ^0.8.0;
1093 
1094 /**
1095  * @dev Interface of the ERC20 standard as defined in the EIP.
1096  */
1097 interface IERC20 {
1098     /**
1099      * @dev Returns the amount of tokens in existence.
1100      */
1101     function totalSupply() external view returns (uint256);
1102 
1103     /**
1104      * @dev Returns the amount of tokens owned by `account`.
1105      */
1106     function balanceOf(address account) external view returns (uint256);
1107 
1108     /**
1109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1110      *
1111      * Returns a boolean value indicating whether the operation succeeded.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function transfer(address recipient, uint256 amount) external returns (bool);
1116 
1117     /**
1118      * @dev Returns the remaining number of tokens that `spender` will be
1119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1120      * zero by default.
1121      *
1122      * This value changes when {approve} or {transferFrom} are called.
1123      */
1124     function allowance(address owner, address spender) external view returns (uint256);
1125 
1126     /**
1127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1128      *
1129      * Returns a boolean value indicating whether the operation succeeded.
1130      *
1131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1132      * that someone may use both the old and the new allowance by unfortunate
1133      * transaction ordering. One possible solution to mitigate this race
1134      * condition is to first reduce the spender's allowance to 0 and set the
1135      * desired value afterwards:
1136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1137      *
1138      * Emits an {Approval} event.
1139      */
1140     function approve(address spender, uint256 amount) external returns (bool);
1141 
1142     /**
1143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1144      * allowance mechanism. `amount` is then deducted from the caller's
1145      * allowance.
1146      *
1147      * Returns a boolean value indicating whether the operation succeeded.
1148      *
1149      * Emits a {Transfer} event.
1150      */
1151     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1152 
1153     /**
1154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1155      * another (`to`).
1156      *
1157      * Note that `value` may be zero.
1158      */
1159     event Transfer(address indexed from, address indexed to, uint256 value);
1160 
1161     /**
1162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1163      * a call to {approve}. `value` is the new allowance.
1164      */
1165     event Approval(address indexed owner, address indexed spender, uint256 value);
1166 }
1167 
1168 // File: contracts/SumItem.sol
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 
1173 
1174 
1175 
1176 
1177 contract OwnableDelegateProxy { }
1178 
1179 contract ProxyRegistry {
1180   mapping(address => OwnableDelegateProxy) public proxies;
1181 }
1182 /**
1183 *On Rinkeby: "0xf57b2c51ded3a29e6891aba85459d600256cf317"
1184 *On mainnet: "0xa5409ec958c83c3f309868babaca7c86dcb077c1"
1185 **/
1186 contract SumItem is ERC721URIStorage, Ownable {
1187     using Counters for Counters.Counter;
1188     Counters.Counter private _tokenIds;
1189     address proxyRegistryAddress;
1190     constructor(address _proxyRegistryAddress) ERC721("SumSwap Collection", "SSC") {
1191         proxyRegistryAddress = _proxyRegistryAddress;
1192     }
1193 
1194     function isApprovedForAll(address owner,address operator) override public view returns (bool) {
1195         // Whitelist OpenSea proxy contract for easy trading.
1196         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1197         if (address(proxyRegistry.proxies(owner)) == operator) {
1198             return true;
1199         }
1200 
1201         return super.isApprovedForAll(owner, operator);
1202    }
1203 
1204     function awardItem(address player, string memory tokenURI)
1205         public onlyOwner
1206         returns (uint256)
1207     {
1208         _tokenIds.increment();
1209 
1210         uint256 newItemId = _tokenIds.current();
1211         _mint(player, newItemId);
1212         _setTokenURI(newItemId, tokenURI);
1213 
1214         return newItemId;
1215     }
1216 
1217     function withdrawETH() public onlyOwner{
1218         payable(msg.sender).transfer(address(this).balance);
1219     }
1220 
1221     function withdrawToken(address addr) public onlyOwner{
1222         IERC20(addr).transfer(_msgSender(), IERC20(addr).balanceOf(address(this)));
1223     }
1224 }