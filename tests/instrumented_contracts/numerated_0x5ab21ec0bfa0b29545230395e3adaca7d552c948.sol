1 // File: node_modules\@openzeppelin\contracts\utils\introspection\IERC165.sol
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
28 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
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
159 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721Receiver.sol
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
183 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Metadata.sol
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
212 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
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
404 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
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
431 // File: node_modules\@openzeppelin\contracts\utils\Strings.sol
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
501 // File: node_modules\@openzeppelin\contracts\utils\introspection\ERC165.sol
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
531 // File: @openzeppelin\contracts\token\ERC721\ERC721.sol
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
909 // File: node_modules\@openzeppelin\contracts\token\ERC721\ERC721.sol
910 
911 
912 
913 pragma solidity ^0.8.0;
914 
915 
916 // File: node_modules\@openzeppelin\contracts\token\ERC721\extensions\IERC721Enumerable.sol
917 
918 
919 
920 pragma solidity ^0.8.0;
921 
922 
923 /**
924  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
925  * @dev See https://eips.ethereum.org/EIPS/eip-721
926  */
927 interface IERC721Enumerable is IERC721 {
928 
929     /**
930      * @dev Returns the total amount of tokens stored by the contract.
931      */
932     function totalSupply() external view returns (uint256);
933 
934     /**
935      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
936      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
937      */
938     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
939 
940     /**
941      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
942      * Use along with {totalSupply} to enumerate all tokens.
943      */
944     function tokenByIndex(uint256 index) external view returns (uint256);
945 }
946 
947 // File: @openzeppelin\contracts\token\ERC721\extensions\ERC721Enumerable.sol
948 
949 
950 
951 pragma solidity ^0.8.0;
952 
953 
954 
955 /**
956  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
957  * enumerability of all the token ids in the contract as well as all token ids owned by each
958  * account.
959  */
960 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
961     // Mapping from owner to list of owned token IDs
962     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
963 
964     // Mapping from token ID to index of the owner tokens list
965     mapping(uint256 => uint256) private _ownedTokensIndex;
966 
967     // Array with all token ids, used for enumeration
968     uint256[] private _allTokens;
969 
970     // Mapping from token id to position in the allTokens array
971     mapping(uint256 => uint256) private _allTokensIndex;
972 
973     /**
974      * @dev See {IERC165-supportsInterface}.
975      */
976     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
977         return interfaceId == type(IERC721Enumerable).interfaceId
978             || super.supportsInterface(interfaceId);
979     }
980 
981     /**
982      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
983      */
984     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
985         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
986         return _ownedTokens[owner][index];
987     }
988 
989     /**
990      * @dev See {IERC721Enumerable-totalSupply}.
991      */
992     function totalSupply() public view virtual override returns (uint256) {
993         return _allTokens.length;
994     }
995 
996     /**
997      * @dev See {IERC721Enumerable-tokenByIndex}.
998      */
999     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1000         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1001         return _allTokens[index];
1002     }
1003 
1004     /**
1005      * @dev Hook that is called before any token transfer. This includes minting
1006      * and burning.
1007      *
1008      * Calling conditions:
1009      *
1010      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1011      * transferred to `to`.
1012      * - When `from` is zero, `tokenId` will be minted for `to`.
1013      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      *
1017      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1018      */
1019     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1020         super._beforeTokenTransfer(from, to, tokenId);
1021 
1022         if (from == address(0)) {
1023             _addTokenToAllTokensEnumeration(tokenId);
1024         } else if (from != to) {
1025             _removeTokenFromOwnerEnumeration(from, tokenId);
1026         }
1027         if (to == address(0)) {
1028             _removeTokenFromAllTokensEnumeration(tokenId);
1029         } else if (to != from) {
1030             _addTokenToOwnerEnumeration(to, tokenId);
1031         }
1032     }
1033 
1034     /**
1035      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1036      * @param to address representing the new owner of the given token ID
1037      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1038      */
1039     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1040         uint256 length = ERC721.balanceOf(to);
1041         _ownedTokens[to][length] = tokenId;
1042         _ownedTokensIndex[tokenId] = length;
1043     }
1044 
1045     /**
1046      * @dev Private function to add a token to this extension's token tracking data structures.
1047      * @param tokenId uint256 ID of the token to be added to the tokens list
1048      */
1049     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1050         _allTokensIndex[tokenId] = _allTokens.length;
1051         _allTokens.push(tokenId);
1052     }
1053 
1054     /**
1055      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1056      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1057      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1058      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1059      * @param from address representing the previous owner of the given token ID
1060      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1061      */
1062     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1063         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1064         // then delete the last slot (swap and pop).
1065 
1066         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1067         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1068 
1069         // When the token to delete is the last token, the swap operation is unnecessary
1070         if (tokenIndex != lastTokenIndex) {
1071             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1072 
1073             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1074             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1075         }
1076 
1077         // This also deletes the contents at the last position of the array
1078         delete _ownedTokensIndex[tokenId];
1079         delete _ownedTokens[from][lastTokenIndex];
1080     }
1081 
1082     /**
1083      * @dev Private function to remove a token from this extension's token tracking data structures.
1084      * This has O(1) time complexity, but alters the order of the _allTokens array.
1085      * @param tokenId uint256 ID of the token to be removed from the tokens list
1086      */
1087     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1088         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1089         // then delete the last slot (swap and pop).
1090 
1091         uint256 lastTokenIndex = _allTokens.length - 1;
1092         uint256 tokenIndex = _allTokensIndex[tokenId];
1093 
1094         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1095         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1096         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1097         uint256 lastTokenId = _allTokens[lastTokenIndex];
1098 
1099         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1100         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1101 
1102         // This also deletes the contents at the last position of the array
1103         delete _allTokensIndex[tokenId];
1104         _allTokens.pop();
1105     }
1106 }
1107 
1108 // File: @openzeppelin\contracts\token\ERC721\extensions\ERC721URIStorage.sol
1109 
1110 
1111 
1112 pragma solidity ^0.8.0;
1113 
1114 
1115 /**
1116  * @dev ERC721 token with storage based token URI management.
1117  */
1118 abstract contract ERC721URIStorage is ERC721 {
1119     using Strings for uint256;
1120 
1121     // Optional mapping for token URIs
1122     mapping (uint256 => string) private _tokenURIs;
1123 
1124     /**
1125      * @dev See {IERC721Metadata-tokenURI}.
1126      */
1127     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1128         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1129 
1130         string memory _tokenURI = _tokenURIs[tokenId];
1131         string memory base = _baseURI();
1132 
1133         // If there is no base URI, return the token URI.
1134         if (bytes(base).length == 0) {
1135             return _tokenURI;
1136         }
1137         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1138         if (bytes(_tokenURI).length > 0) {
1139             return string(abi.encodePacked(base, _tokenURI));
1140         }
1141 
1142         return super.tokenURI(tokenId);
1143     }
1144 
1145     /**
1146      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must exist.
1151      */
1152     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1153         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1154         _tokenURIs[tokenId] = _tokenURI;
1155     }
1156 
1157     /**
1158      * @dev Destroys `tokenId`.
1159      * The approval is cleared when the token is burned.
1160      *
1161      * Requirements:
1162      *
1163      * - `tokenId` must exist.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function _burn(uint256 tokenId) internal virtual override {
1168         super._burn(tokenId);
1169 
1170         if (bytes(_tokenURIs[tokenId]).length != 0) {
1171             delete _tokenURIs[tokenId];
1172         }
1173     }
1174 }
1175 
1176 // File: @openzeppelin\contracts\access\Ownable.sol
1177 
1178 
1179 
1180 pragma solidity ^0.8.0;
1181 
1182 /**
1183  * @dev Contract module which provides a basic access control mechanism, where
1184  * there is an account (an owner) that can be granted exclusive access to
1185  * specific functions.
1186  *
1187  * By default, the owner account will be the one that deploys the contract. This
1188  * can later be changed with {transferOwnership}.
1189  *
1190  * This module is used through inheritance. It will make available the modifier
1191  * `onlyOwner`, which can be applied to your functions to restrict their use to
1192  * the owner.
1193  */
1194 abstract contract Ownable is Context {
1195     address private _owner;
1196 
1197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1198 
1199     /**
1200      * @dev Initializes the contract setting the deployer as the initial owner.
1201      */
1202     constructor () {
1203         address msgSender = _msgSender();
1204         _owner = msgSender;
1205         emit OwnershipTransferred(address(0), msgSender);
1206     }
1207 
1208     /**
1209      * @dev Returns the address of the current owner.
1210      */
1211     function owner() public view virtual returns (address) {
1212         return _owner;
1213     }
1214 
1215     /**
1216      * @dev Throws if called by any account other than the owner.
1217      */
1218     modifier onlyOwner() {
1219         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1220         _;
1221     }
1222 
1223     /**
1224      * @dev Leaves the contract without owner. It will not be possible to call
1225      * `onlyOwner` functions anymore. Can only be called by the current owner.
1226      *
1227      * NOTE: Renouncing ownership will leave the contract without an owner,
1228      * thereby removing any functionality that is only available to the owner.
1229      */
1230     function renounceOwnership() public virtual onlyOwner {
1231         emit OwnershipTransferred(_owner, address(0));
1232         _owner = address(0);
1233     }
1234 
1235     /**
1236      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1237      * Can only be called by the current owner.
1238      */
1239     function transferOwnership(address newOwner) public virtual onlyOwner {
1240         require(newOwner != address(0), "Ownable: new owner is the zero address");
1241         emit OwnershipTransferred(_owner, newOwner);
1242         _owner = newOwner;
1243     }
1244 }
1245 
1246 // File: contracts\ComicMinter.sol
1247 
1248 // SPDX-License-Identifier: UNLICENSED
1249 pragma solidity ^0.8.0;
1250 
1251 
1252 
1253 
1254 
1255 contract ComicMinter is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
1256 
1257     uint256 private _tokenIds;
1258     
1259     string  constant public IPFS_HASH = "QmWS694ViHvkTms9UkKqocv1kWDm2MTQqYEJeYi6LsJbxK";
1260     uint256 constant public ETH_PRICE = 0.2 ether;
1261     uint256 constant public MAX_PER_TX = 20;
1262     uint256 constant public MAX_SUPPLY = 10000;
1263     bool public burningEnabled = false;
1264     bool public mintingEnabled = false;
1265     address payable public pixel_vault;
1266 
1267     event Minted(address to, uint256 quantity);
1268 
1269     constructor() ERC721("PUNKS Comic", "COMIC") {
1270         pixel_vault = payable(address(0xaBF107de3E01c7c257e64E0a18d60A733Aad395d));
1271     }
1272 
1273     function mint(uint256 quantity) public payable {
1274         require(msg.sender == pixel_vault || mintingEnabled, "minting is not enabled yet");
1275         require(quantity <= MAX_PER_TX, "minting too many");
1276         require(msg.value == getPrice(quantity), "wrong amount");
1277         require(totalSupply() < MAX_SUPPLY, "sold out");
1278         require(totalSupply() + quantity <= MAX_SUPPLY, "exceeds max supply");
1279         
1280         for (uint i = 0; i < quantity; i++) {
1281             _tokenIds++;
1282 
1283             uint256 newTokenId = _tokenIds;
1284             _safeMint(msg.sender, newTokenId);
1285             _setTokenURI(newTokenId, IPFS_HASH);
1286         }
1287 
1288         emit Minted(msg.sender, quantity);
1289     }
1290 
1291     function getPrice(uint256 quantity) public pure returns(uint256) {
1292         return ETH_PRICE * quantity;
1293     }
1294 
1295     function withdraw() public {
1296         pixel_vault.transfer(address(this).balance);
1297     }
1298     
1299     function toggleBurningEnabled() public onlyOwner {
1300         burningEnabled = !burningEnabled;
1301     }
1302 
1303     function toggleMintingEnabled() public onlyOwner {
1304         mintingEnabled = !mintingEnabled;
1305     }
1306 
1307     function burn(uint256 tokenId) public virtual {
1308         require(burningEnabled, "burning is not yet enabled");
1309         require(_isApprovedOrOwner(_msgSender(), tokenId), "caller is not owner nor approved");
1310         _burn(tokenId);
1311     }
1312     
1313     function remainingSupply() public view returns(uint256) {
1314         return MAX_SUPPLY - totalSupply();
1315     }
1316 
1317     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1318         internal
1319         override(ERC721, ERC721Enumerable)
1320     {
1321         super._beforeTokenTransfer(from, to, tokenId);
1322     }
1323 
1324     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1325         super._burn(tokenId);
1326     }
1327 
1328     function tokenURI(uint256 tokenId)
1329         public
1330         view
1331         override(ERC721, ERC721URIStorage)
1332         returns (string memory)
1333     {
1334         return super.tokenURI(tokenId);
1335     }
1336 
1337     function supportsInterface(bytes4 interfaceId)
1338         public
1339         view
1340         override(ERC721, ERC721Enumerable)
1341         returns (bool)
1342     {
1343         return super.supportsInterface(interfaceId);
1344     }
1345 
1346     function _baseURI() internal pure override returns (string memory) {
1347         return "ipfs://ipfs/";
1348     }
1349 }