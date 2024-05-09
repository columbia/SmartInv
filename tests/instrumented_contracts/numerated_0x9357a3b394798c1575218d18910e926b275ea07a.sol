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
212 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
213 
214 
215 
216 pragma solidity ^0.8.0;
217 
218 
219 /**
220  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
221  * @dev See https://eips.ethereum.org/EIPS/eip-721
222  */
223 interface IERC721Enumerable is IERC721 {
224 
225     /**
226      * @dev Returns the total amount of tokens stored by the contract.
227      */
228     function totalSupply() external view returns (uint256);
229 
230     /**
231      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
232      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
233      */
234     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
235 
236     /**
237      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
238      * Use along with {totalSupply} to enumerate all tokens.
239      */
240     function tokenByIndex(uint256 index) external view returns (uint256);
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies on extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: value }(data);
364         return _verifyCallResult(success, returndata, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
374         return functionStaticCall(target, data, "Address: low-level static call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
379      * but performing a static call.
380      *
381      * _Available since v3.3._
382      */
383     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
384         require(isContract(target), "Address: static call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but performing a delegate call.
394      *
395      * _Available since v3.4._
396      */
397     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
403      * but performing a delegate call.
404      *
405      * _Available since v3.4._
406      */
407     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
408         require(isContract(target), "Address: delegate call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.delegatecall(data);
412         return _verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 // solhint-disable-next-line no-inline-assembly
424                 assembly {
425                     let returndata_size := mload(returndata)
426                     revert(add(32, returndata), returndata_size)
427                 }
428             } else {
429                 revert(errorMessage);
430             }
431         }
432     }
433 }
434 
435 // File: @openzeppelin/contracts/utils/Context.sol
436 
437 
438 
439 pragma solidity ^0.8.0;
440 
441 /*
442  * @dev Provides information about the current execution context, including the
443  * sender of the transaction and its data. While these are generally available
444  * via msg.sender and msg.data, they should not be accessed in such a direct
445  * manner, since when dealing with meta-transactions the account sending and
446  * paying for execution may not be the actual sender (as far as an application
447  * is concerned).
448  *
449  * This contract is only required for intermediate, library-like contracts.
450  */
451 abstract contract Context {
452     function _msgSender() internal view virtual returns (address) {
453         return msg.sender;
454     }
455 
456     function _msgData() internal view virtual returns (bytes calldata) {
457         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
458         return msg.data;
459     }
460 }
461 
462 // File: @openzeppelin/contracts/utils/Strings.sol
463 
464 
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev String operations.
470  */
471 library Strings {
472     bytes16 private constant alphabet = "0123456789abcdef";
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
476      */
477     function toString(uint256 value) internal pure returns (string memory) {
478         // Inspired by OraclizeAPI's implementation - MIT licence
479         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
480 
481         if (value == 0) {
482             return "0";
483         }
484         uint256 temp = value;
485         uint256 digits;
486         while (temp != 0) {
487             digits++;
488             temp /= 10;
489         }
490         bytes memory buffer = new bytes(digits);
491         while (value != 0) {
492             digits -= 1;
493             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
494             value /= 10;
495         }
496         return string(buffer);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
501      */
502     function toHexString(uint256 value) internal pure returns (string memory) {
503         if (value == 0) {
504             return "0x00";
505         }
506         uint256 temp = value;
507         uint256 length = 0;
508         while (temp != 0) {
509             length++;
510             temp >>= 8;
511         }
512         return toHexString(value, length);
513     }
514 
515     /**
516      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
517      */
518     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
519         bytes memory buffer = new bytes(2 * length + 2);
520         buffer[0] = "0";
521         buffer[1] = "x";
522         for (uint256 i = 2 * length + 1; i > 1; --i) {
523             buffer[i] = alphabet[value & 0xf];
524             value >>= 4;
525         }
526         require(value == 0, "Strings: hex length insufficient");
527         return string(buffer);
528     }
529 
530 }
531 
532 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
533 
534 
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Implementation of the {IERC165} interface.
541  *
542  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
543  * for the additional interface id that will be supported. For example:
544  *
545  * ```solidity
546  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
548  * }
549  * ```
550  *
551  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
552  */
553 abstract contract ERC165 is IERC165 {
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         return interfaceId == type(IERC165).interfaceId;
559     }
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
563 
564 
565 
566 pragma solidity ^0.8.0;
567 
568 
569 
570 
571 
572 
573 
574 
575 
576 /**
577  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
578  * the Metadata extension, but not including the Enumerable extension, which is available separately as
579  * {ERC721Enumerable}.
580  */
581 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
582     using Address for address;
583     using Strings for uint256;
584 
585     // Token name
586     string private _name;
587 
588     // Token symbol
589     string private _symbol;
590 
591     // Mapping from token ID to owner address
592     mapping (uint256 => address) private _owners;
593 
594     // Mapping owner address to token count
595     mapping (address => uint256) private _balances;
596 
597     // Mapping from token ID to approved address
598     mapping (uint256 => address) private _tokenApprovals;
599 
600     // Mapping from owner to operator approvals
601     mapping (address => mapping (address => bool)) private _operatorApprovals;
602 
603     /**
604      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
605      */
606     constructor (string memory name_, string memory symbol_) {
607         _name = name_;
608         _symbol = symbol_;
609     }
610 
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
615         return interfaceId == type(IERC721).interfaceId
616             || interfaceId == type(IERC721Metadata).interfaceId
617             || super.supportsInterface(interfaceId);
618     }
619 
620     /**
621      * @dev See {IERC721-balanceOf}.
622      */
623     function balanceOf(address owner) public view virtual override returns (uint256) {
624         require(owner != address(0), "ERC721: balance query for the zero address");
625         return _balances[owner];
626     }
627 
628     /**
629      * @dev See {IERC721-ownerOf}.
630      */
631     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
632         address owner = _owners[tokenId];
633         require(owner != address(0), "ERC721: owner query for nonexistent token");
634         return owner;
635     }
636 
637     /**
638      * @dev See {IERC721Metadata-name}.
639      */
640     function name() public view virtual override returns (string memory) {
641         return _name;
642     }
643 
644     /**
645      * @dev See {IERC721Metadata-symbol}.
646      */
647     function symbol() public view virtual override returns (string memory) {
648         return _symbol;
649     }
650 
651     /**
652      * @dev See {IERC721Metadata-tokenURI}.
653      */
654     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
655         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
656 
657         string memory baseURI = _baseURI();
658         return bytes(baseURI).length > 0
659             ? string(abi.encodePacked(baseURI, tokenId.toString()))
660             : '';
661     }
662 
663     /**
664      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
665      * in child contracts.
666      */
667     function _baseURI() internal view virtual returns (string memory) {
668         return "";
669     }
670 
671     /**
672      * @dev See {IERC721-approve}.
673      */
674     function approve(address to, uint256 tokenId) public virtual override {
675         address owner = ERC721.ownerOf(tokenId);
676         require(to != owner, "ERC721: approval to current owner");
677 
678         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
679             "ERC721: approve caller is not owner nor approved for all"
680         );
681 
682         _approve(to, tokenId);
683     }
684 
685     /**
686      * @dev See {IERC721-getApproved}.
687      */
688     function getApproved(uint256 tokenId) public view virtual override returns (address) {
689         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
690 
691         return _tokenApprovals[tokenId];
692     }
693 
694     /**
695      * @dev See {IERC721-setApprovalForAll}.
696      */
697     function setApprovalForAll(address operator, bool approved) public virtual override {
698         require(operator != _msgSender(), "ERC721: approve to caller");
699 
700         _operatorApprovals[_msgSender()][operator] = approved;
701         emit ApprovalForAll(_msgSender(), operator, approved);
702     }
703 
704     /**
705      * @dev See {IERC721-isApprovedForAll}.
706      */
707     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
708         return _operatorApprovals[owner][operator];
709     }
710 
711     /**
712      * @dev See {IERC721-transferFrom}.
713      */
714     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
715         //solhint-disable-next-line max-line-length
716         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
717 
718         _transfer(from, to, tokenId);
719     }
720 
721     /**
722      * @dev See {IERC721-safeTransferFrom}.
723      */
724     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
725         safeTransferFrom(from, to, tokenId, "");
726     }
727 
728     /**
729      * @dev See {IERC721-safeTransferFrom}.
730      */
731     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
732         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
733         _safeTransfer(from, to, tokenId, _data);
734     }
735 
736     /**
737      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
738      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
739      *
740      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
741      *
742      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
743      * implement alternative mechanisms to perform token transfer, such as signature-based.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must exist and be owned by `from`.
750      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
751      *
752      * Emits a {Transfer} event.
753      */
754     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
755         _transfer(from, to, tokenId);
756         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
757     }
758 
759     /**
760      * @dev Returns whether `tokenId` exists.
761      *
762      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
763      *
764      * Tokens start existing when they are minted (`_mint`),
765      * and stop existing when they are burned (`_burn`).
766      */
767     function _exists(uint256 tokenId) internal view virtual returns (bool) {
768         return _owners[tokenId] != address(0);
769     }
770 
771     /**
772      * @dev Returns whether `spender` is allowed to manage `tokenId`.
773      *
774      * Requirements:
775      *
776      * - `tokenId` must exist.
777      */
778     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
779         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
780         address owner = ERC721.ownerOf(tokenId);
781         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
782     }
783 
784     /**
785      * @dev Safely mints `tokenId` and transfers it to `to`.
786      *
787      * Requirements:
788      *
789      * - `tokenId` must not exist.
790      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
791      *
792      * Emits a {Transfer} event.
793      */
794     function _safeMint(address to, uint256 tokenId) internal virtual {
795         _safeMint(to, tokenId, "");
796     }
797 
798     /**
799      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
800      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
801      */
802     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
803         _mint(to, tokenId);
804         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
805     }
806 
807     /**
808      * @dev Mints `tokenId` and transfers it to `to`.
809      *
810      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
811      *
812      * Requirements:
813      *
814      * - `tokenId` must not exist.
815      * - `to` cannot be the zero address.
816      *
817      * Emits a {Transfer} event.
818      */
819     function _mint(address to, uint256 tokenId) internal virtual {
820         require(to != address(0), "ERC721: mint to the zero address");
821         require(!_exists(tokenId), "ERC721: token already minted");
822 
823         _beforeTokenTransfer(address(0), to, tokenId);
824 
825         _balances[to] += 1;
826         _owners[tokenId] = to;
827 
828         emit Transfer(address(0), to, tokenId);
829     }
830 
831     /**
832      * @dev Destroys `tokenId`.
833      * The approval is cleared when the token is burned.
834      *
835      * Requirements:
836      *
837      * - `tokenId` must exist.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _burn(uint256 tokenId) internal virtual {
842         address owner = ERC721.ownerOf(tokenId);
843 
844         _beforeTokenTransfer(owner, address(0), tokenId);
845 
846         // Clear approvals
847         _approve(address(0), tokenId);
848 
849         _balances[owner] -= 1;
850         delete _owners[tokenId];
851 
852         emit Transfer(owner, address(0), tokenId);
853     }
854 
855     /**
856      * @dev Transfers `tokenId` from `from` to `to`.
857      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
858      *
859      * Requirements:
860      *
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must be owned by `from`.
863      *
864      * Emits a {Transfer} event.
865      */
866     function _transfer(address from, address to, uint256 tokenId) internal virtual {
867         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
868         require(to != address(0), "ERC721: transfer to the zero address");
869 
870         _beforeTokenTransfer(from, to, tokenId);
871 
872         // Clear approvals from the previous owner
873         _approve(address(0), tokenId);
874 
875         _balances[from] -= 1;
876         _balances[to] += 1;
877         _owners[tokenId] = to;
878 
879         emit Transfer(from, to, tokenId);
880     }
881 
882     /**
883      * @dev Approve `to` to operate on `tokenId`
884      *
885      * Emits a {Approval} event.
886      */
887     function _approve(address to, uint256 tokenId) internal virtual {
888         _tokenApprovals[tokenId] = to;
889         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
890     }
891 
892     /**
893      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
894      * The call is not executed if the target address is not a contract.
895      *
896      * @param from address representing the previous owner of the given token ID
897      * @param to target address that will receive the tokens
898      * @param tokenId uint256 ID of the token to be transferred
899      * @param _data bytes optional data to send along with the call
900      * @return bool whether the call correctly returned the expected magic value
901      */
902     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
903         private returns (bool)
904     {
905         if (to.isContract()) {
906             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
907                 return retval == IERC721Receiver(to).onERC721Received.selector;
908             } catch (bytes memory reason) {
909                 if (reason.length == 0) {
910                     revert("ERC721: transfer to non ERC721Receiver implementer");
911                 } else {
912                     // solhint-disable-next-line no-inline-assembly
913                     assembly {
914                         revert(add(32, reason), mload(reason))
915                     }
916                 }
917             }
918         } else {
919             return true;
920         }
921     }
922 
923     /**
924      * @dev Hook that is called before any token transfer. This includes minting
925      * and burning.
926      *
927      * Calling conditions:
928      *
929      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
930      * transferred to `to`.
931      * - When `from` is zero, `tokenId` will be minted for `to`.
932      * - When `to` is zero, ``from``'s `tokenId` will be burned.
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      *
936      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
937      */
938     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
939 }
940 
941 // File: @openzeppelin/contracts/access/Ownable.sol
942 
943 
944 
945 pragma solidity ^0.8.0;
946 
947 /**
948  * @dev Contract module which provides a basic access control mechanism, where
949  * there is an account (an owner) that can be granted exclusive access to
950  * specific functions.
951  *
952  * By default, the owner account will be the one that deploys the contract. This
953  * can later be changed with {transferOwnership}.
954  *
955  * This module is used through inheritance. It will make available the modifier
956  * `onlyOwner`, which can be applied to your functions to restrict their use to
957  * the owner.
958  */
959 abstract contract Ownable is Context {
960     address private _owner;
961 
962     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
963 
964     /**
965      * @dev Initializes the contract setting the deployer as the initial owner.
966      */
967     constructor () {
968         address msgSender = _msgSender();
969         _owner = msgSender;
970         emit OwnershipTransferred(address(0), msgSender);
971     }
972 
973     /**
974      * @dev Returns the address of the current owner.
975      */
976     function owner() public view virtual returns (address) {
977         return _owner;
978     }
979 
980     /**
981      * @dev Throws if called by any account other than the owner.
982      */
983     modifier onlyOwner() {
984         require(owner() == _msgSender(), "Ownable: caller is not the owner");
985         _;
986     }
987 
988     /**
989      * @dev Leaves the contract without owner. It will not be possible to call
990      * `onlyOwner` functions anymore. Can only be called by the current owner.
991      *
992      * NOTE: Renouncing ownership will leave the contract without an owner,
993      * thereby removing any functionality that is only available to the owner.
994      */
995     function renounceOwnership() public virtual onlyOwner {
996         emit OwnershipTransferred(_owner, address(0));
997         _owner = address(0);
998     }
999 
1000     /**
1001      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1002      * Can only be called by the current owner.
1003      */
1004     function transferOwnership(address newOwner) public virtual onlyOwner {
1005         require(newOwner != address(0), "Ownable: new owner is the zero address");
1006         emit OwnershipTransferred(_owner, newOwner);
1007         _owner = newOwner;
1008     }
1009 }
1010 
1011 // File: contracts/WaifuWrapper.sol
1012 
1013 // SPDX-License-Identifier: GPL-3.0
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 
1018 
1019 
1020 interface WaifuContract {
1021 
1022     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
1023     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
1024 
1025     // Known functions
1026     function approve(address _to, uint256 _tokenId) external;
1027     function buy(uint256) external payable;
1028     function bid(uint256) external payable;
1029     function isTransferDisabled(uint256) external view returns (bool);
1030     function artworkIdToTransferApproved(uint256 _tokenId) external view returns (address);
1031     function ownerOf(uint256 _tokenId) external view returns (address);
1032     function transfer(address _to, uint256 _tokenId) external;
1033     // transferFrom needs send() from the artworkIdToTransferApproved() address, not owner
1034     function transferFrom(address _from, address _to, uint256 _tokenId) external;
1035 }
1036 
1037 contract WaifuWrapper is Ownable, ERC721 {
1038 
1039     event Wrapped(address indexed owner, uint indexed _tokenId);
1040     event Unwrapped(address indexed owner, uint indexed _tokenId);
1041 
1042     address public _waifuAddress = 0x36697e362Ee7E9CA977b7550B3e4f955fc5BF27d;
1043     string public _baseTokenURI;
1044 
1045     constructor() payable ERC721("Wrapped Waifus", "WWFU") {
1046     }
1047 
1048     /**
1049      * @dev Transfers a waifu from the contract and assigns a wrapped token to msg.sender
1050      */
1051     function wrap(uint _tokenId) public payable {
1052 
1053         WaifuContract(_waifuAddress).transferFrom(msg.sender, address(this), _tokenId);
1054         _mint(msg.sender, _tokenId);
1055         Wrapped(msg.sender, _tokenId);
1056     }
1057 
1058     /**
1059      * @dev Burns the wrapped token and transfers the underlying waifu to the owner
1060      **/
1061     function unwrap(uint256 _tokenId) public {
1062         require(_isApprovedOrOwner(msg.sender, _tokenId));
1063         _burn(_tokenId);
1064         WaifuContract(_waifuAddress).transfer(msg.sender, _tokenId);
1065         Unwrapped(msg.sender, _tokenId);
1066     }
1067 
1068     /**
1069      * @dev Returns a URI for a given token ID's metadata
1070      */
1071     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1072         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
1073     }
1074 
1075     function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
1076         _baseTokenURI = __baseTokenURI;
1077     }
1078 }