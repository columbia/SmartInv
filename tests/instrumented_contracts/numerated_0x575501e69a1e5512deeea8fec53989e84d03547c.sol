1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
28 
29 
30 pragma solidity ^0.8.0;
31 
32 
33 /**
34  * @dev Required interface of an ERC721 compliant contract.
35  */
36 interface IERC721 is IERC165 {
37     /**
38      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
41 
42     /**
43      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
44      */
45     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
49      */
50     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
51 
52     /**
53      * @dev Returns the number of tokens in ``owner``'s account.
54      */
55     function balanceOf(address owner) external view returns (uint256 balance);
56 
57     /**
58      * @dev Returns the owner of the `tokenId` token.
59      *
60      * Requirements:
61      *
62      * - `tokenId` must exist.
63      */
64     function ownerOf(uint256 tokenId) external view returns (address owner);
65 
66     /**
67      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
68      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
69      *
70      * Requirements:
71      *
72      * - `from` cannot be the zero address.
73      * - `to` cannot be the zero address.
74      * - `tokenId` token must exist and be owned by `from`.
75      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
76      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
77      *
78      * Emits a {Transfer} event.
79      */
80     function safeTransferFrom(address from, address to, uint256 tokenId) external;
81 
82     /**
83      * @dev Transfers `tokenId` token from `from` to `to`.
84      *
85      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
86      *
87      * Requirements:
88      *
89      * - `from` cannot be the zero address.
90      * - `to` cannot be the zero address.
91      * - `tokenId` token must be owned by `from`.
92      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address from, address to, uint256 tokenId) external;
97 
98     /**
99      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
100      * The approval is cleared when the token is transferred.
101      *
102      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
103      *
104      * Requirements:
105      *
106      * - The caller must own the token or be an approved operator.
107      * - `tokenId` must exist.
108      *
109      * Emits an {Approval} event.
110      */
111     function approve(address to, uint256 tokenId) external;
112 
113     /**
114      * @dev Returns the account approved for `tokenId` token.
115      *
116      * Requirements:
117      *
118      * - `tokenId` must exist.
119      */
120     function getApproved(uint256 tokenId) external view returns (address operator);
121 
122     /**
123      * @dev Approve or remove `operator` as an operator for the caller.
124      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
125      *
126      * Requirements:
127      *
128      * - The `operator` cannot be the caller.
129      *
130      * Emits an {ApprovalForAll} event.
131      */
132     function setApprovalForAll(address operator, bool _approved) external;
133 
134     /**
135      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
136      *
137      * See {setApprovalForAll}
138      */
139     function isApprovedForAll(address owner, address operator) external view returns (bool);
140 
141     /**
142       * @dev Safely transfers `tokenId` token from `from` to `to`.
143       *
144       * Requirements:
145       *
146       * - `from` cannot be the zero address.
147       * - `to` cannot be the zero address.
148       * - `tokenId` token must exist and be owned by `from`.
149       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
150       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
151       *
152       * Emits a {Transfer} event.
153       */
154     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
155 }
156 
157 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
158 
159 
160 pragma solidity ^0.8.0;
161 
162 /**
163  * @title ERC721 token receiver interface
164  * @dev Interface for any contract that wants to support safeTransfers
165  * from ERC721 asset contracts.
166  */
167 interface IERC721Receiver {
168     /**
169      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
170      * by `operator` from `from`, this function is called.
171      *
172      * It must return its Solidity selector to confirm the token transfer.
173      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
174      *
175      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
176      */
177     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
178 }
179 
180 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
181 
182 
183 pragma solidity ^0.8.0;
184 
185 
186 /**
187  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
188  * @dev See https://eips.ethereum.org/EIPS/eip-721
189  */
190 interface IERC721Metadata is IERC721 {
191 
192     /**
193      * @dev Returns the token collection name.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the token collection symbol.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
204      */
205     function tokenURI(uint256 tokenId) external view returns (string memory);
206 }
207 
208 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
209 
210 
211 pragma solidity ^0.8.0;
212 
213 
214 /**
215  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
216  * @dev See https://eips.ethereum.org/EIPS/eip-721
217  */
218 interface IERC721Enumerable is IERC721 {
219 
220     /**
221      * @dev Returns the total amount of tokens stored by the contract.
222      */
223     function totalSupply() external view returns (uint256);
224 
225     /**
226      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
227      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
228      */
229     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
230 
231     /**
232      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
233      * Use along with {totalSupply} to enumerate all tokens.
234      */
235     function tokenByIndex(uint256 index) external view returns (uint256);
236 }
237 
238 // File: @openzeppelin/contracts/utils/Address.sol
239 
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize, which returns 0 for contracts in
266         // construction, since the code is only stored at the end of the
267         // constructor execution.
268 
269         uint256 size;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { size := extcodesize(account) }
272         return size > 0;
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318       return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: value }(data);
358         return _verifyCallResult(success, returndata, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
368         return functionStaticCall(target, data, "Address: low-level static call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
373      * but performing a static call.
374      *
375      * _Available since v3.3._
376      */
377     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
378         require(isContract(target), "Address: static call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return _verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
402         require(isContract(target), "Address: delegate call to non-contract");
403 
404         // solhint-disable-next-line avoid-low-level-calls
405         (bool success, bytes memory returndata) = target.delegatecall(data);
406         return _verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
410         if (success) {
411             return returndata;
412         } else {
413             // Look for revert reason and bubble it up if present
414             if (returndata.length > 0) {
415                 // The easiest way to bubble the revert reason is using memory via assembly
416 
417                 // solhint-disable-next-line no-inline-assembly
418                 assembly {
419                     let returndata_size := mload(returndata)
420                     revert(add(32, returndata), returndata_size)
421                 }
422             } else {
423                 revert(errorMessage);
424             }
425         }
426     }
427 }
428 
429 // File: @openzeppelin/contracts/utils/Context.sol
430 
431 
432 pragma solidity ^0.8.0;
433 
434 /*
435  * @dev Provides information about the current execution context, including the
436  * sender of the transaction and its data. While these are generally available
437  * via msg.sender and msg.data, they should not be accessed in such a direct
438  * manner, since when dealing with meta-transactions the account sending and
439  * paying for execution may not be the actual sender (as far as an application
440  * is concerned).
441  *
442  * This contract is only required for intermediate, library-like contracts.
443  */
444 abstract contract Context {
445     function _msgSender() internal view virtual returns (address) {
446         return msg.sender;
447     }
448 
449     function _msgData() internal view virtual returns (bytes calldata) {
450         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
451         return msg.data;
452     }
453 }
454 
455 // File: @openzeppelin/contracts/utils/Strings.sol
456 
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev String operations.
462  */
463 library Strings {
464     bytes16 private constant alphabet = "0123456789abcdef";
465 
466     /**
467      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
468      */
469     function toString(uint256 value) internal pure returns (string memory) {
470         // Inspired by OraclizeAPI's implementation - MIT licence
471         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
472 
473         if (value == 0) {
474             return "0";
475         }
476         uint256 temp = value;
477         uint256 digits;
478         while (temp != 0) {
479             digits++;
480             temp /= 10;
481         }
482         bytes memory buffer = new bytes(digits);
483         while (value != 0) {
484             digits -= 1;
485             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
486             value /= 10;
487         }
488         return string(buffer);
489     }
490 
491     /**
492      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
493      */
494     function toHexString(uint256 value) internal pure returns (string memory) {
495         if (value == 0) {
496             return "0x00";
497         }
498         uint256 temp = value;
499         uint256 length = 0;
500         while (temp != 0) {
501             length++;
502             temp >>= 8;
503         }
504         return toHexString(value, length);
505     }
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
509      */
510     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
511         bytes memory buffer = new bytes(2 * length + 2);
512         buffer[0] = "0";
513         buffer[1] = "x";
514         for (uint256 i = 2 * length + 1; i > 1; --i) {
515             buffer[i] = alphabet[value & 0xf];
516             value >>= 4;
517         }
518         require(value == 0, "Strings: hex length insufficient");
519         return string(buffer);
520     }
521 
522 }
523 
524 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
525 
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Implementation of the {IERC165} interface.
532  *
533  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
534  * for the additional interface id that will be supported. For example:
535  *
536  * ```solidity
537  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
539  * }
540  * ```
541  *
542  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
543  */
544 abstract contract ERC165 is IERC165 {
545     /**
546      * @dev See {IERC165-supportsInterface}.
547      */
548     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549         return interfaceId == type(IERC165).interfaceId;
550     }
551 }
552 
553 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
554 
555 
556 pragma solidity ^0.8.0;
557 
558 
559 
560 
561 
562 
563 
564 
565 
566 /**
567  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
568  * the Metadata extension, but not including the Enumerable extension, which is available separately as
569  * {ERC721Enumerable}.
570  */
571 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
572     using Address for address;
573     using Strings for uint256;
574 
575     // Token name
576     string private _name;
577 
578     // Token symbol
579     string private _symbol;
580 
581     // Mapping from token ID to owner address
582     mapping (uint256 => address) private _owners;
583 
584     // Mapping owner address to token count
585     mapping (address => uint256) private _balances;
586 
587     // Mapping from token ID to approved address
588     mapping (uint256 => address) private _tokenApprovals;
589 
590     // Mapping from owner to operator approvals
591     mapping (address => mapping (address => bool)) private _operatorApprovals;
592 
593     /**
594      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
595      */
596     constructor (string memory name_, string memory symbol_) {
597         _name = name_;
598         _symbol = symbol_;
599     }
600 
601     /**
602      * @dev See {IERC165-supportsInterface}.
603      */
604     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
605         return interfaceId == type(IERC721).interfaceId
606             || interfaceId == type(IERC721Metadata).interfaceId
607             || super.supportsInterface(interfaceId);
608     }
609 
610     /**
611      * @dev See {IERC721-balanceOf}.
612      */
613     function balanceOf(address owner) public view virtual override returns (uint256) {
614         require(owner != address(0), "ERC721: balance query for the zero address");
615         return _balances[owner];
616     }
617 
618     /**
619      * @dev See {IERC721-ownerOf}.
620      */
621     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
622         address owner = _owners[tokenId];
623         require(owner != address(0), "ERC721: owner query for nonexistent token");
624         return owner;
625     }
626 
627     /**
628      * @dev See {IERC721Metadata-name}.
629      */
630     function name() public view virtual override returns (string memory) {
631         return _name;
632     }
633 
634     /**
635      * @dev See {IERC721Metadata-symbol}.
636      */
637     function symbol() public view virtual override returns (string memory) {
638         return _symbol;
639     }
640 
641     /**
642      * @dev See {IERC721Metadata-tokenURI}.
643      */
644     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
645         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
646 
647         string memory baseURI = _baseURI();
648         return bytes(baseURI).length > 0
649             ? string(abi.encodePacked(baseURI, tokenId.toString()))
650             : '';
651     }
652 
653     /**
654      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
655      * in child contracts.
656      */
657     function _baseURI() internal view virtual returns (string memory) {
658         return "";
659     }
660 
661     /**
662      * @dev See {IERC721-approve}.
663      */
664     function approve(address to, uint256 tokenId) public virtual override {
665         address owner = ERC721.ownerOf(tokenId);
666         require(to != owner, "ERC721: approval to current owner");
667 
668         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
669             "ERC721: approve caller is not owner nor approved for all"
670         );
671 
672         _approve(to, tokenId);
673     }
674 
675     /**
676      * @dev See {IERC721-getApproved}.
677      */
678     function getApproved(uint256 tokenId) public view virtual override returns (address) {
679         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
680 
681         return _tokenApprovals[tokenId];
682     }
683 
684     /**
685      * @dev See {IERC721-setApprovalForAll}.
686      */
687     function setApprovalForAll(address operator, bool approved) public virtual override {
688         require(operator != _msgSender(), "ERC721: approve to caller");
689 
690         _operatorApprovals[_msgSender()][operator] = approved;
691         emit ApprovalForAll(_msgSender(), operator, approved);
692     }
693 
694     /**
695      * @dev See {IERC721-isApprovedForAll}.
696      */
697     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
698         return _operatorApprovals[owner][operator];
699     }
700 
701     /**
702      * @dev See {IERC721-transferFrom}.
703      */
704     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
705         //solhint-disable-next-line max-line-length
706         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
707 
708         _transfer(from, to, tokenId);
709     }
710 
711     /**
712      * @dev See {IERC721-safeTransferFrom}.
713      */
714     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
715         safeTransferFrom(from, to, tokenId, "");
716     }
717 
718     /**
719      * @dev See {IERC721-safeTransferFrom}.
720      */
721     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
722         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
723         _safeTransfer(from, to, tokenId, _data);
724     }
725 
726     /**
727      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
728      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
729      *
730      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
731      *
732      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
733      * implement alternative mechanisms to perform token transfer, such as signature-based.
734      *
735      * Requirements:
736      *
737      * - `from` cannot be the zero address.
738      * - `to` cannot be the zero address.
739      * - `tokenId` token must exist and be owned by `from`.
740      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
741      *
742      * Emits a {Transfer} event.
743      */
744     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
745         _transfer(from, to, tokenId);
746         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
747     }
748 
749     /**
750      * @dev Returns whether `tokenId` exists.
751      *
752      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
753      *
754      * Tokens start existing when they are minted (`_mint`),
755      * and stop existing when they are burned (`_burn`).
756      */
757     function _exists(uint256 tokenId) internal view virtual returns (bool) {
758         return _owners[tokenId] != address(0);
759     }
760 
761     /**
762      * @dev Returns whether `spender` is allowed to manage `tokenId`.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must exist.
767      */
768     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
769         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
770         address owner = ERC721.ownerOf(tokenId);
771         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
772     }
773 
774     /**
775      * @dev Safely mints `tokenId` and transfers it to `to`.
776      *
777      * Requirements:
778      *
779      * - `tokenId` must not exist.
780      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
781      *
782      * Emits a {Transfer} event.
783      */
784     function _safeMint(address to, uint256 tokenId) internal virtual {
785         _safeMint(to, tokenId, "");
786     }
787 
788     /**
789      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
790      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
791      */
792     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
793         _mint(to, tokenId);
794         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
795     }
796 
797     /**
798      * @dev Mints `tokenId` and transfers it to `to`.
799      *
800      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
801      *
802      * Requirements:
803      *
804      * - `tokenId` must not exist.
805      * - `to` cannot be the zero address.
806      *
807      * Emits a {Transfer} event.
808      */
809     function _mint(address to, uint256 tokenId) internal virtual {
810         require(to != address(0), "ERC721: mint to the zero address");
811         require(!_exists(tokenId), "ERC721: token already minted");
812 
813         _beforeTokenTransfer(address(0), to, tokenId);
814 
815         _balances[to] += 1;
816         _owners[tokenId] = to;
817 
818         emit Transfer(address(0), to, tokenId);
819     }
820 
821     /**
822      * @dev Destroys `tokenId`.
823      * The approval is cleared when the token is burned.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _burn(uint256 tokenId) internal virtual {
832         address owner = ERC721.ownerOf(tokenId);
833 
834         _beforeTokenTransfer(owner, address(0), tokenId);
835 
836         // Clear approvals
837         _approve(address(0), tokenId);
838 
839         _balances[owner] -= 1;
840         delete _owners[tokenId];
841 
842         emit Transfer(owner, address(0), tokenId);
843     }
844 
845     /**
846      * @dev Transfers `tokenId` from `from` to `to`.
847      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
848      *
849      * Requirements:
850      *
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must be owned by `from`.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _transfer(address from, address to, uint256 tokenId) internal virtual {
857         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
858         require(to != address(0), "ERC721: transfer to the zero address");
859 
860         _beforeTokenTransfer(from, to, tokenId);
861 
862         // Clear approvals from the previous owner
863         _approve(address(0), tokenId);
864 
865         _balances[from] -= 1;
866         _balances[to] += 1;
867         _owners[tokenId] = to;
868 
869         emit Transfer(from, to, tokenId);
870     }
871 
872     /**
873      * @dev Approve `to` to operate on `tokenId`
874      *
875      * Emits a {Approval} event.
876      */
877     function _approve(address to, uint256 tokenId) internal virtual {
878         _tokenApprovals[tokenId] = to;
879         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
880     }
881 
882     /**
883      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
884      * The call is not executed if the target address is not a contract.
885      *
886      * @param from address representing the previous owner of the given token ID
887      * @param to target address that will receive the tokens
888      * @param tokenId uint256 ID of the token to be transferred
889      * @param _data bytes optional data to send along with the call
890      * @return bool whether the call correctly returned the expected magic value
891      */
892     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
893         private returns (bool)
894     {
895         if (to.isContract()) {
896             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
897                 return retval == IERC721Receiver(to).onERC721Received.selector;
898             } catch (bytes memory reason) {
899                 if (reason.length == 0) {
900                     revert("ERC721: transfer to non ERC721Receiver implementer");
901                 } else {
902                     // solhint-disable-next-line no-inline-assembly
903                     assembly {
904                         revert(add(32, reason), mload(reason))
905                     }
906                 }
907             }
908         } else {
909             return true;
910         }
911     }
912 
913     /**
914      * @dev Hook that is called before any token transfer. This includes minting
915      * and burning.
916      *
917      * Calling conditions:
918      *
919      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
920      * transferred to `to`.
921      * - When `from` is zero, `tokenId` will be minted for `to`.
922      * - When `to` is zero, ``from``'s `tokenId` will be burned.
923      * - `from` cannot be the zero address.
924      * - `to` cannot be the zero address.
925      *
926      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
927      */
928     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
932 
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 /**
939  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
940  * enumerability of all the token ids in the contract as well as all token ids owned by each
941  * account.
942  */
943 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
944     // Mapping from owner to list of owned token IDs
945     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
946 
947     // Mapping from token ID to index of the owner tokens list
948     mapping(uint256 => uint256) private _ownedTokensIndex;
949 
950     // Array with all token ids, used for enumeration
951     uint256[] private _allTokens;
952 
953     // Mapping from token id to position in the allTokens array
954     mapping(uint256 => uint256) private _allTokensIndex;
955 
956     /**
957      * @dev See {IERC165-supportsInterface}.
958      */
959     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
960         return interfaceId == type(IERC721Enumerable).interfaceId
961             || super.supportsInterface(interfaceId);
962     }
963 
964     /**
965      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
966      */
967     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
968         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
969         return _ownedTokens[owner][index];
970     }
971 
972     /**
973      * @dev See {IERC721Enumerable-totalSupply}.
974      */
975     function totalSupply() public view virtual override returns (uint256) {
976         return _allTokens.length;
977     }
978 
979     /**
980      * @dev See {IERC721Enumerable-tokenByIndex}.
981      */
982     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
983         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
984         return _allTokens[index];
985     }
986 
987     /**
988      * @dev Hook that is called before any token transfer. This includes minting
989      * and burning.
990      *
991      * Calling conditions:
992      *
993      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
994      * transferred to `to`.
995      * - When `from` is zero, `tokenId` will be minted for `to`.
996      * - When `to` is zero, ``from``'s `tokenId` will be burned.
997      * - `from` cannot be the zero address.
998      * - `to` cannot be the zero address.
999      *
1000      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1001      */
1002     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1003         super._beforeTokenTransfer(from, to, tokenId);
1004 
1005         if (from == address(0)) {
1006             _addTokenToAllTokensEnumeration(tokenId);
1007         } else if (from != to) {
1008             _removeTokenFromOwnerEnumeration(from, tokenId);
1009         }
1010         if (to == address(0)) {
1011             _removeTokenFromAllTokensEnumeration(tokenId);
1012         } else if (to != from) {
1013             _addTokenToOwnerEnumeration(to, tokenId);
1014         }
1015     }
1016 
1017     /**
1018      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1019      * @param to address representing the new owner of the given token ID
1020      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1021      */
1022     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1023         uint256 length = ERC721.balanceOf(to);
1024         _ownedTokens[to][length] = tokenId;
1025         _ownedTokensIndex[tokenId] = length;
1026     }
1027 
1028     /**
1029      * @dev Private function to add a token to this extension's token tracking data structures.
1030      * @param tokenId uint256 ID of the token to be added to the tokens list
1031      */
1032     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1033         _allTokensIndex[tokenId] = _allTokens.length;
1034         _allTokens.push(tokenId);
1035     }
1036 
1037     /**
1038      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1039      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1040      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1041      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1042      * @param from address representing the previous owner of the given token ID
1043      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1044      */
1045     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1046         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1047         // then delete the last slot (swap and pop).
1048 
1049         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1050         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1051 
1052         // When the token to delete is the last token, the swap operation is unnecessary
1053         if (tokenIndex != lastTokenIndex) {
1054             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1055 
1056             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1057             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1058         }
1059 
1060         // This also deletes the contents at the last position of the array
1061         delete _ownedTokensIndex[tokenId];
1062         delete _ownedTokens[from][lastTokenIndex];
1063     }
1064 
1065     /**
1066      * @dev Private function to remove a token from this extension's token tracking data structures.
1067      * This has O(1) time complexity, but alters the order of the _allTokens array.
1068      * @param tokenId uint256 ID of the token to be removed from the tokens list
1069      */
1070     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1071         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1072         // then delete the last slot (swap and pop).
1073 
1074         uint256 lastTokenIndex = _allTokens.length - 1;
1075         uint256 tokenIndex = _allTokensIndex[tokenId];
1076 
1077         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1078         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1079         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1080         uint256 lastTokenId = _allTokens[lastTokenIndex];
1081 
1082         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1083         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1084 
1085         // This also deletes the contents at the last position of the array
1086         delete _allTokensIndex[tokenId];
1087         _allTokens.pop();
1088     }
1089 }
1090 
1091 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1092 
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 
1098 /**
1099  * @title ERC721 Burnable Token
1100  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1101  */
1102 abstract contract ERC721Burnable is Context, ERC721 {
1103     /**
1104      * @dev Burns `tokenId`. See {ERC721-_burn}.
1105      *
1106      * Requirements:
1107      *
1108      * - The caller must own `tokenId` or be an approved operator.
1109      */
1110     function burn(uint256 tokenId) public virtual {
1111         //solhint-disable-next-line max-line-length
1112         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1113         _burn(tokenId);
1114     }
1115 }
1116 
1117 // File: @openzeppelin/contracts/security/Pausable.sol
1118 
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 
1123 /**
1124  * @dev Contract module which allows children to implement an emergency stop
1125  * mechanism that can be triggered by an authorized account.
1126  *
1127  * This module is used through inheritance. It will make available the
1128  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1129  * the functions of your contract. Note that they will not be pausable by
1130  * simply including this module, only once the modifiers are put in place.
1131  */
1132 abstract contract Pausable is Context {
1133     /**
1134      * @dev Emitted when the pause is triggered by `account`.
1135      */
1136     event Paused(address account);
1137 
1138     /**
1139      * @dev Emitted when the pause is lifted by `account`.
1140      */
1141     event Unpaused(address account);
1142 
1143     bool private _paused;
1144 
1145     /**
1146      * @dev Initializes the contract in unpaused state.
1147      */
1148     constructor () {
1149         _paused = false;
1150     }
1151 
1152     /**
1153      * @dev Returns true if the contract is paused, and false otherwise.
1154      */
1155     function paused() public view virtual returns (bool) {
1156         return _paused;
1157     }
1158 
1159     /**
1160      * @dev Modifier to make a function callable only when the contract is not paused.
1161      *
1162      * Requirements:
1163      *
1164      * - The contract must not be paused.
1165      */
1166     modifier whenNotPaused() {
1167         require(!paused(), "Pausable: paused");
1168         _;
1169     }
1170 
1171     /**
1172      * @dev Modifier to make a function callable only when the contract is paused.
1173      *
1174      * Requirements:
1175      *
1176      * - The contract must be paused.
1177      */
1178     modifier whenPaused() {
1179         require(paused(), "Pausable: not paused");
1180         _;
1181     }
1182 
1183     /**
1184      * @dev Triggers stopped state.
1185      *
1186      * Requirements:
1187      *
1188      * - The contract must not be paused.
1189      */
1190     function _pause() internal virtual whenNotPaused {
1191         _paused = true;
1192         emit Paused(_msgSender());
1193     }
1194 
1195     /**
1196      * @dev Returns to normal state.
1197      *
1198      * Requirements:
1199      *
1200      * - The contract must be paused.
1201      */
1202     function _unpause() internal virtual whenPaused {
1203         _paused = false;
1204         emit Unpaused(_msgSender());
1205     }
1206 }
1207 
1208 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1209 
1210 // SPDX-License-Identifier: MIT
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 
1216 /**
1217  * @dev ERC721 token with pausable token transfers, minting and burning.
1218  *
1219  * Useful for scenarios such as preventing trades until the end of an evaluation
1220  * period, or having an emergency switch for freezing all token transfers in the
1221  * event of a large bug.
1222  */
1223 abstract contract ERC721Pausable is ERC721, Pausable {
1224     /**
1225      * @dev See {ERC721-_beforeTokenTransfer}.
1226      *
1227      * Requirements:
1228      *
1229      * - the contract must not be paused.
1230      */
1231     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1232         super._beforeTokenTransfer(from, to, tokenId);
1233 
1234         require(!paused(), "ERC721Pausable: token transfer while paused");
1235     }
1236 }
1237 
1238 // File: @openzeppelin/contracts/access/AccessControl.sol
1239 
1240 
1241 pragma solidity ^0.8.0;
1242 
1243 
1244 
1245 /**
1246  * @dev External interface of AccessControl declared to support ERC165 detection.
1247  */
1248 interface IAccessControl {
1249     function hasRole(bytes32 role, address account) external view returns (bool);
1250     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1251     function grantRole(bytes32 role, address account) external;
1252     function revokeRole(bytes32 role, address account) external;
1253     function renounceRole(bytes32 role, address account) external;
1254 }
1255 
1256 /**
1257  * @dev Contract module that allows children to implement role-based access
1258  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1259  * members except through off-chain means by accessing the contract event logs. Some
1260  * applications may benefit from on-chain enumerability, for those cases see
1261  * {AccessControlEnumerable}.
1262  *
1263  * Roles are referred to by their `bytes32` identifier. These should be exposed
1264  * in the external API and be unique. The best way to achieve this is by
1265  * using `public constant` hash digests:
1266  *
1267  * ```
1268  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1269  * ```
1270  *
1271  * Roles can be used to represent a set of permissions. To restrict access to a
1272  * function call, use {hasRole}:
1273  *
1274  * ```
1275  * function foo() public {
1276  *     require(hasRole(MY_ROLE, msg.sender));
1277  *     ...
1278  * }
1279  * ```
1280  *
1281  * Roles can be granted and revoked dynamically via the {grantRole} and
1282  * {revokeRole} functions. Each role has an associated admin role, and only
1283  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1284  *
1285  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1286  * that only accounts with this role will be able to grant or revoke other
1287  * roles. More complex role relationships can be created by using
1288  * {_setRoleAdmin}.
1289  *
1290  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1291  * grant and revoke this role. Extra precautions should be taken to secure
1292  * accounts that have been granted it.
1293  */
1294 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1295     struct RoleData {
1296         mapping (address => bool) members;
1297         bytes32 adminRole;
1298     }
1299 
1300     mapping (bytes32 => RoleData) private _roles;
1301 
1302     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1303 
1304     /**
1305      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1306      *
1307      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1308      * {RoleAdminChanged} not being emitted signaling this.
1309      *
1310      * _Available since v3.1._
1311      */
1312     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1313 
1314     /**
1315      * @dev Emitted when `account` is granted `role`.
1316      *
1317      * `sender` is the account that originated the contract call, an admin role
1318      * bearer except when using {_setupRole}.
1319      */
1320     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1321 
1322     /**
1323      * @dev Emitted when `account` is revoked `role`.
1324      *
1325      * `sender` is the account that originated the contract call:
1326      *   - if using `revokeRole`, it is the admin role bearer
1327      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1328      */
1329     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1330 
1331     /**
1332      * @dev See {IERC165-supportsInterface}.
1333      */
1334     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1335         return interfaceId == type(IAccessControl).interfaceId
1336             || super.supportsInterface(interfaceId);
1337     }
1338 
1339     /**
1340      * @dev Returns `true` if `account` has been granted `role`.
1341      */
1342     function hasRole(bytes32 role, address account) public view override returns (bool) {
1343         return _roles[role].members[account];
1344     }
1345 
1346     /**
1347      * @dev Returns the admin role that controls `role`. See {grantRole} and
1348      * {revokeRole}.
1349      *
1350      * To change a role's admin, use {_setRoleAdmin}.
1351      */
1352     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1353         return _roles[role].adminRole;
1354     }
1355 
1356     /**
1357      * @dev Grants `role` to `account`.
1358      *
1359      * If `account` had not been already granted `role`, emits a {RoleGranted}
1360      * event.
1361      *
1362      * Requirements:
1363      *
1364      * - the caller must have ``role``'s admin role.
1365      */
1366     function grantRole(bytes32 role, address account) public virtual override {
1367         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
1368 
1369         _grantRole(role, account);
1370     }
1371 
1372     /**
1373      * @dev Revokes `role` from `account`.
1374      *
1375      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1376      *
1377      * Requirements:
1378      *
1379      * - the caller must have ``role``'s admin role.
1380      */
1381     function revokeRole(bytes32 role, address account) public virtual override {
1382         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
1383 
1384         _revokeRole(role, account);
1385     }
1386 
1387     /**
1388      * @dev Revokes `role` from the calling account.
1389      *
1390      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1391      * purpose is to provide a mechanism for accounts to lose their privileges
1392      * if they are compromised (such as when a trusted device is misplaced).
1393      *
1394      * If the calling account had been granted `role`, emits a {RoleRevoked}
1395      * event.
1396      *
1397      * Requirements:
1398      *
1399      * - the caller must be `account`.
1400      */
1401     function renounceRole(bytes32 role, address account) public virtual override {
1402         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1403 
1404         _revokeRole(role, account);
1405     }
1406 
1407     /**
1408      * @dev Grants `role` to `account`.
1409      *
1410      * If `account` had not been already granted `role`, emits a {RoleGranted}
1411      * event. Note that unlike {grantRole}, this function doesn't perform any
1412      * checks on the calling account.
1413      *
1414      * [WARNING]
1415      * ====
1416      * This function should only be called from the constructor when setting
1417      * up the initial roles for the system.
1418      *
1419      * Using this function in any other way is effectively circumventing the admin
1420      * system imposed by {AccessControl}.
1421      * ====
1422      */
1423     function _setupRole(bytes32 role, address account) internal virtual {
1424         _grantRole(role, account);
1425     }
1426 
1427     /**
1428      * @dev Sets `adminRole` as ``role``'s admin role.
1429      *
1430      * Emits a {RoleAdminChanged} event.
1431      */
1432     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1433         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
1434         _roles[role].adminRole = adminRole;
1435     }
1436 
1437     function _grantRole(bytes32 role, address account) private {
1438         if (!hasRole(role, account)) {
1439             _roles[role].members[account] = true;
1440             emit RoleGranted(role, account, _msgSender());
1441         }
1442     }
1443 
1444     function _revokeRole(bytes32 role, address account) private {
1445         if (hasRole(role, account)) {
1446             _roles[role].members[account] = false;
1447             emit RoleRevoked(role, account, _msgSender());
1448         }
1449     }
1450 }
1451 
1452 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
1453 
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 /**
1458  * @dev Library for managing
1459  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1460  * types.
1461  *
1462  * Sets have the following properties:
1463  *
1464  * - Elements are added, removed, and checked for existence in constant time
1465  * (O(1)).
1466  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1467  *
1468  * ```
1469  * contract Example {
1470  *     // Add the library methods
1471  *     using EnumerableSet for EnumerableSet.AddressSet;
1472  *
1473  *     // Declare a set state variable
1474  *     EnumerableSet.AddressSet private mySet;
1475  * }
1476  * ```
1477  *
1478  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1479  * and `uint256` (`UintSet`) are supported.
1480  */
1481 library EnumerableSet {
1482     // To implement this library for multiple types with as little code
1483     // repetition as possible, we write it in terms of a generic Set type with
1484     // bytes32 values.
1485     // The Set implementation uses private functions, and user-facing
1486     // implementations (such as AddressSet) are just wrappers around the
1487     // underlying Set.
1488     // This means that we can only create new EnumerableSets for types that fit
1489     // in bytes32.
1490 
1491     struct Set {
1492         // Storage of set values
1493         bytes32[] _values;
1494 
1495         // Position of the value in the `values` array, plus 1 because index 0
1496         // means a value is not in the set.
1497         mapping (bytes32 => uint256) _indexes;
1498     }
1499 
1500     /**
1501      * @dev Add a value to a set. O(1).
1502      *
1503      * Returns true if the value was added to the set, that is if it was not
1504      * already present.
1505      */
1506     function _add(Set storage set, bytes32 value) private returns (bool) {
1507         if (!_contains(set, value)) {
1508             set._values.push(value);
1509             // The value is stored at length-1, but we add 1 to all indexes
1510             // and use 0 as a sentinel value
1511             set._indexes[value] = set._values.length;
1512             return true;
1513         } else {
1514             return false;
1515         }
1516     }
1517 
1518     /**
1519      * @dev Removes a value from a set. O(1).
1520      *
1521      * Returns true if the value was removed from the set, that is if it was
1522      * present.
1523      */
1524     function _remove(Set storage set, bytes32 value) private returns (bool) {
1525         // We read and store the value's index to prevent multiple reads from the same storage slot
1526         uint256 valueIndex = set._indexes[value];
1527 
1528         if (valueIndex != 0) { // Equivalent to contains(set, value)
1529             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1530             // the array, and then remove the last element (sometimes called as 'swap and pop').
1531             // This modifies the order of the array, as noted in {at}.
1532 
1533             uint256 toDeleteIndex = valueIndex - 1;
1534             uint256 lastIndex = set._values.length - 1;
1535 
1536             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1537             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1538 
1539             bytes32 lastvalue = set._values[lastIndex];
1540 
1541             // Move the last value to the index where the value to delete is
1542             set._values[toDeleteIndex] = lastvalue;
1543             // Update the index for the moved value
1544             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1545 
1546             // Delete the slot where the moved value was stored
1547             set._values.pop();
1548 
1549             // Delete the index for the deleted slot
1550             delete set._indexes[value];
1551 
1552             return true;
1553         } else {
1554             return false;
1555         }
1556     }
1557 
1558     /**
1559      * @dev Returns true if the value is in the set. O(1).
1560      */
1561     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1562         return set._indexes[value] != 0;
1563     }
1564 
1565     /**
1566      * @dev Returns the number of values on the set. O(1).
1567      */
1568     function _length(Set storage set) private view returns (uint256) {
1569         return set._values.length;
1570     }
1571 
1572    /**
1573     * @dev Returns the value stored at position `index` in the set. O(1).
1574     *
1575     * Note that there are no guarantees on the ordering of values inside the
1576     * array, and it may change when more values are added or removed.
1577     *
1578     * Requirements:
1579     *
1580     * - `index` must be strictly less than {length}.
1581     */
1582     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1583         require(set._values.length > index, "EnumerableSet: index out of bounds");
1584         return set._values[index];
1585     }
1586 
1587     // Bytes32Set
1588 
1589     struct Bytes32Set {
1590         Set _inner;
1591     }
1592 
1593     /**
1594      * @dev Add a value to a set. O(1).
1595      *
1596      * Returns true if the value was added to the set, that is if it was not
1597      * already present.
1598      */
1599     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1600         return _add(set._inner, value);
1601     }
1602 
1603     /**
1604      * @dev Removes a value from a set. O(1).
1605      *
1606      * Returns true if the value was removed from the set, that is if it was
1607      * present.
1608      */
1609     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1610         return _remove(set._inner, value);
1611     }
1612 
1613     /**
1614      * @dev Returns true if the value is in the set. O(1).
1615      */
1616     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1617         return _contains(set._inner, value);
1618     }
1619 
1620     /**
1621      * @dev Returns the number of values in the set. O(1).
1622      */
1623     function length(Bytes32Set storage set) internal view returns (uint256) {
1624         return _length(set._inner);
1625     }
1626 
1627    /**
1628     * @dev Returns the value stored at position `index` in the set. O(1).
1629     *
1630     * Note that there are no guarantees on the ordering of values inside the
1631     * array, and it may change when more values are added or removed.
1632     *
1633     * Requirements:
1634     *
1635     * - `index` must be strictly less than {length}.
1636     */
1637     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1638         return _at(set._inner, index);
1639     }
1640 
1641     // AddressSet
1642 
1643     struct AddressSet {
1644         Set _inner;
1645     }
1646 
1647     /**
1648      * @dev Add a value to a set. O(1).
1649      *
1650      * Returns true if the value was added to the set, that is if it was not
1651      * already present.
1652      */
1653     function add(AddressSet storage set, address value) internal returns (bool) {
1654         return _add(set._inner, bytes32(uint256(uint160(value))));
1655     }
1656 
1657     /**
1658      * @dev Removes a value from a set. O(1).
1659      *
1660      * Returns true if the value was removed from the set, that is if it was
1661      * present.
1662      */
1663     function remove(AddressSet storage set, address value) internal returns (bool) {
1664         return _remove(set._inner, bytes32(uint256(uint160(value))));
1665     }
1666 
1667     /**
1668      * @dev Returns true if the value is in the set. O(1).
1669      */
1670     function contains(AddressSet storage set, address value) internal view returns (bool) {
1671         return _contains(set._inner, bytes32(uint256(uint160(value))));
1672     }
1673 
1674     /**
1675      * @dev Returns the number of values in the set. O(1).
1676      */
1677     function length(AddressSet storage set) internal view returns (uint256) {
1678         return _length(set._inner);
1679     }
1680 
1681    /**
1682     * @dev Returns the value stored at position `index` in the set. O(1).
1683     *
1684     * Note that there are no guarantees on the ordering of values inside the
1685     * array, and it may change when more values are added or removed.
1686     *
1687     * Requirements:
1688     *
1689     * - `index` must be strictly less than {length}.
1690     */
1691     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1692         return address(uint160(uint256(_at(set._inner, index))));
1693     }
1694 
1695 
1696     // UintSet
1697 
1698     struct UintSet {
1699         Set _inner;
1700     }
1701 
1702     /**
1703      * @dev Add a value to a set. O(1).
1704      *
1705      * Returns true if the value was added to the set, that is if it was not
1706      * already present.
1707      */
1708     function add(UintSet storage set, uint256 value) internal returns (bool) {
1709         return _add(set._inner, bytes32(value));
1710     }
1711 
1712     /**
1713      * @dev Removes a value from a set. O(1).
1714      *
1715      * Returns true if the value was removed from the set, that is if it was
1716      * present.
1717      */
1718     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1719         return _remove(set._inner, bytes32(value));
1720     }
1721 
1722     /**
1723      * @dev Returns true if the value is in the set. O(1).
1724      */
1725     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1726         return _contains(set._inner, bytes32(value));
1727     }
1728 
1729     /**
1730      * @dev Returns the number of values on the set. O(1).
1731      */
1732     function length(UintSet storage set) internal view returns (uint256) {
1733         return _length(set._inner);
1734     }
1735 
1736    /**
1737     * @dev Returns the value stored at position `index` in the set. O(1).
1738     *
1739     * Note that there are no guarantees on the ordering of values inside the
1740     * array, and it may change when more values are added or removed.
1741     *
1742     * Requirements:
1743     *
1744     * - `index` must be strictly less than {length}.
1745     */
1746     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1747         return uint256(_at(set._inner, index));
1748     }
1749 }
1750 
1751 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1752 
1753 
1754 pragma solidity ^0.8.0;
1755 
1756 
1757 
1758 /**
1759  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1760  */
1761 interface IAccessControlEnumerable {
1762     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1763     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1764 }
1765 
1766 /**
1767  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1768  */
1769 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1770     using EnumerableSet for EnumerableSet.AddressSet;
1771 
1772     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1773 
1774     /**
1775      * @dev See {IERC165-supportsInterface}.
1776      */
1777     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1778         return interfaceId == type(IAccessControlEnumerable).interfaceId
1779             || super.supportsInterface(interfaceId);
1780     }
1781 
1782     /**
1783      * @dev Returns one of the accounts that have `role`. `index` must be a
1784      * value between 0 and {getRoleMemberCount}, non-inclusive.
1785      *
1786      * Role bearers are not sorted in any particular way, and their ordering may
1787      * change at any point.
1788      *
1789      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1790      * you perform all queries on the same block. See the following
1791      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1792      * for more information.
1793      */
1794     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1795         return _roleMembers[role].at(index);
1796     }
1797 
1798     /**
1799      * @dev Returns the number of accounts that have `role`. Can be used
1800      * together with {getRoleMember} to enumerate all bearers of a role.
1801      */
1802     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1803         return _roleMembers[role].length();
1804     }
1805 
1806     /**
1807      * @dev Overload {grantRole} to track enumerable memberships
1808      */
1809     function grantRole(bytes32 role, address account) public virtual override {
1810         super.grantRole(role, account);
1811         _roleMembers[role].add(account);
1812     }
1813 
1814     /**
1815      * @dev Overload {revokeRole} to track enumerable memberships
1816      */
1817     function revokeRole(bytes32 role, address account) public virtual override {
1818         super.revokeRole(role, account);
1819         _roleMembers[role].remove(account);
1820     }
1821 
1822     /**
1823      * @dev Overload {renounceRole} to track enumerable memberships
1824      */
1825     function renounceRole(bytes32 role, address account) public virtual override {
1826         super.renounceRole(role, account);
1827         _roleMembers[role].remove(account);
1828     }
1829 
1830     /**
1831      * @dev Overload {_setupRole} to track enumerable memberships
1832      */
1833     function _setupRole(bytes32 role, address account) internal virtual override {
1834         super._setupRole(role, account);
1835         _roleMembers[role].add(account);
1836     }
1837 }
1838 
1839 // File: @openzeppelin/contracts/utils/Counters.sol
1840 
1841 
1842 pragma solidity ^0.8.0;
1843 
1844 /**
1845  * @title Counters
1846  * @author Matt Condon (@shrugs)
1847  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1848  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1849  *
1850  * Include with `using Counters for Counters.Counter;`
1851  */
1852 library Counters {
1853     struct Counter {
1854         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1855         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1856         // this feature: see https://github.com/ethereum/solidity/issues/4637
1857         uint256 _value; // default: 0
1858     }
1859 
1860     function current(Counter storage counter) internal view returns (uint256) {
1861         return counter._value;
1862     }
1863 
1864     function increment(Counter storage counter) internal {
1865         unchecked {
1866             counter._value += 1;
1867         }
1868     }
1869 
1870     function decrement(Counter storage counter) internal {
1871         uint256 value = counter._value;
1872         require(value > 0, "Counter: decrement overflow");
1873         unchecked {
1874             counter._value = value - 1;
1875         }
1876     }
1877 }
1878 
1879 // File: @openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol
1880 
1881 
1882 pragma solidity ^0.8.0;
1883 
1884 
1885 
1886 
1887 
1888 
1889 
1890 
1891 /**
1892  * @dev {ERC721} token, including:
1893  *
1894  *  - ability for holders to burn (destroy) their tokens
1895  *  - a minter role that allows for token minting (creation)
1896  *  - a pauser role that allows to stop all token transfers
1897  *  - token ID and URI autogeneration
1898  *
1899  * This contract uses {AccessControl} to lock permissioned functions using the
1900  * different roles - head to its documentation for details.
1901  *
1902  * The account that deploys the contract will be granted the minter and pauser
1903  * roles, as well as the default admin role, which will let it grant both minter
1904  * and pauser roles to other accounts.
1905  */
1906 contract ERC721PresetMinterPauserAutoId is Context, AccessControlEnumerable, ERC721Enumerable, ERC721Burnable, ERC721Pausable {
1907     using Counters for Counters.Counter;
1908 
1909     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1910     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1911 
1912     Counters.Counter private _tokenIdTracker;
1913 
1914     string private _baseTokenURI;
1915 
1916     /**
1917      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1918      * account that deploys the contract.
1919      *
1920      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
1921      * See {ERC721-tokenURI}.
1922      */
1923     constructor(string memory name, string memory symbol, string memory baseTokenURI) ERC721(name, symbol) {
1924         _baseTokenURI = baseTokenURI;
1925 
1926         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1927 
1928         _setupRole(MINTER_ROLE, _msgSender());
1929         _setupRole(PAUSER_ROLE, _msgSender());
1930     }
1931 
1932     function _baseURI() internal view virtual override returns (string memory) {
1933         return _baseTokenURI;
1934     }
1935 
1936     /**
1937      * @dev Creates a new token for `to`. Its token ID will be automatically
1938      * assigned (and available on the emitted {IERC721-Transfer} event), and the token
1939      * URI autogenerated based on the base URI passed at construction.
1940      *
1941      * See {ERC721-_mint}.
1942      *
1943      * Requirements:
1944      *
1945      * - the caller must have the `MINTER_ROLE`.
1946      */
1947     function mint(address to) public virtual {
1948         require(hasRole(MINTER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have minter role to mint");
1949 
1950         // We cannot just use balanceOf to create the new tokenId because tokens
1951         // can be burned (destroyed), so we need a separate counter.
1952         _mint(to, _tokenIdTracker.current());
1953         _tokenIdTracker.increment();
1954     }
1955 
1956     /**
1957      * @dev Pauses all token transfers.
1958      *
1959      * See {ERC721Pausable} and {Pausable-_pause}.
1960      *
1961      * Requirements:
1962      *
1963      * - the caller must have the `PAUSER_ROLE`.
1964      */
1965     function pause() public virtual {
1966         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to pause");
1967         _pause();
1968     }
1969 
1970     /**
1971      * @dev Unpauses all token transfers.
1972      *
1973      * See {ERC721Pausable} and {Pausable-_unpause}.
1974      *
1975      * Requirements:
1976      *
1977      * - the caller must have the `PAUSER_ROLE`.
1978      */
1979     function unpause() public virtual {
1980         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721PresetMinterPauserAutoId: must have pauser role to unpause");
1981         _unpause();
1982     }
1983 
1984     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
1985         super._beforeTokenTransfer(from, to, tokenId);
1986     }
1987 
1988     /**
1989      * @dev See {IERC165-supportsInterface}.
1990      */
1991     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, ERC721, ERC721Enumerable) returns (bool) {
1992         return super.supportsInterface(interfaceId);
1993     }
1994 }
1995 
1996 // File: contracts/NFT.sol
1997 
1998 pragma solidity ^0.8.0;
1999 
2000 contract AudiusCollectiblesLaunchToken is ERC721PresetMinterPauserAutoId {
2001     /**
2002      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
2003      * account that deploys the contract.
2004      *
2005      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
2006      * See {ERC721-tokenURI}.
2007      */
2008     constructor() ERC721PresetMinterPauserAutoId("AudiusCollectiblesLaunchToken", "ACLT", "https://launchcollectible.audius.co/") { }
2009 }