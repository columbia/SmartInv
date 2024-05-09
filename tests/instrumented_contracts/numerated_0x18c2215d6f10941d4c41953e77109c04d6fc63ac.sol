1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Strings.sol
4 
5 pragma solidity ^0.8.4;
6 
7 /**
8  * @dev String operations.
9  */
10 library Strings {
11     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
12 
13     /**
14      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
15      */
16     function toString(uint256 value) internal pure returns (string memory) {
17         // Inspired by OraclizeAPI's implementation - MIT licence
18         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
19 
20         if (value == 0) {
21             return "0";
22         }
23         uint256 temp = value;
24         uint256 digits;
25         while (temp != 0) {
26             digits++;
27             temp /= 10;
28         }
29         bytes memory buffer = new bytes(digits);
30         while (value != 0) {
31             digits -= 1;
32             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
33             value /= 10;
34         }
35         return string(buffer);
36     }
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
40      */
41     function toHexString(uint256 value) internal pure returns (string memory) {
42         if (value == 0) {
43             return "0x00";
44         }
45         uint256 temp = value;
46         uint256 length = 0;
47         while (temp != 0) {
48             length++;
49             temp >>= 8;
50         }
51         return toHexString(value, length);
52     }
53 
54     /**
55      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
56      */
57     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
58         bytes memory buffer = new bytes(2 * length + 2);
59         buffer[0] = "0";
60         buffer[1] = "x";
61         for (uint256 i = 2 * length + 1; i > 1; --i) {
62             buffer[i] = _HEX_SYMBOLS[value & 0xf];
63             value >>= 4;
64         }
65         require(value == 0, "Strings: hex length insufficient");
66         return string(buffer);
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Context.sol
71 
72 /**
73  * @dev Provides information about the current execution context, including the
74  * sender of the transaction and its data. While these are generally available
75  * via msg.sender and msg.data, they should not be accessed in such a direct
76  * manner, since when dealing with meta-transactions the account sending and
77  * paying for execution may not be the actual sender (as far as an application
78  * is concerned).
79  *
80  * This contract is only required for intermediate, library-like contracts.
81  */
82 abstract contract Context {
83     function _msgSender() internal view virtual returns (address) {
84         return msg.sender;
85     }
86 
87     function _msgData() internal view virtual returns (bytes calldata) {
88         return msg.data;
89     }
90 }
91 
92 // File: @openzeppelin/contracts/access/Ownable.sol
93 
94 
95 
96 /**
97  * @dev Contract module which provides a basic access control mechanism, where
98  * there is an account (an owner) that can be granted exclusive access to
99  * specific functions.
100  *
101  * By default, the owner account will be the one that deploys the contract. This
102  * can later be changed with {transferOwnership}.
103  *
104  * This module is used through inheritance. It will make available the modifier
105  * `onlyOwner`, which can be applied to your functions to restrict their use to
106  * the owner.
107  */
108 abstract contract Ownable is Context {
109     address private _owner;
110 
111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113     /**
114      * @dev Initializes the contract setting the deployer as the initial owner.
115      */
116     constructor() {
117         _setOwner(_msgSender());
118     }
119 
120     /**
121      * @dev Returns the address of the current owner.
122      */
123     function owner() public view virtual returns (address) {
124         return _owner;
125     }
126 
127     /**
128      * @dev Throws if called by any account other than the owner.
129      */
130     modifier onlyOwner() {
131         require(owner() == _msgSender(), "Ownable: caller is not the owner");
132         _;
133     }
134 
135     /**
136      * @dev Leaves the contract without owner. It will not be possible to call
137      * `onlyOwner` functions anymore. Can only be called by the current owner.
138      *
139      * NOTE: Renouncing ownership will leave the contract without an owner,
140      * thereby removing any functionality that is only available to the owner.
141      */
142     function renounceOwnership() public virtual onlyOwner {
143         _setOwner(address(0));
144     }
145 
146     /**
147      * @dev Transfers ownership of the contract to a new account (`newOwner`).
148      * Can only be called by the current owner.
149      */
150     function transferOwnership(address newOwner) public virtual onlyOwner {
151         require(newOwner != address(0), "Ownable: new owner is the zero address");
152         _setOwner(newOwner);
153     }
154 
155     function _setOwner(address newOwner) private {
156         address oldOwner = _owner;
157         _owner = newOwner;
158         emit OwnershipTransferred(oldOwner, newOwner);
159     }
160 }
161 
162 // File: @openzeppelin/contracts/utils/Address.sol
163 
164 
165 /**
166  * @dev Collection of functions related to the address type
167  */
168 library Address {
169     /**
170      * @dev Returns true if `account` is a contract.
171      *
172      * [IMPORTANT]
173      * ====
174      * It is unsafe to assume that an address for which this function returns
175      * false is an externally-owned account (EOA) and not a contract.
176      *
177      * Among others, `isContract` will return false for the following
178      * types of addresses:
179      *
180      *  - an externally-owned account
181      *  - a contract in construction
182      *  - an address where a contract will be created
183      *  - an address where a contract lived, but was destroyed
184      * ====
185      */
186     function isContract(address account) internal view returns (bool) {
187         // This method relies on extcodesize, which returns 0 for contracts in
188         // construction, since the code is only stored at the end of the
189         // constructor execution.
190 
191         uint256 size;
192         assembly {
193             size := extcodesize(account)
194         }
195         return size > 0;
196     }
197 
198     /**
199      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
200      * `recipient`, forwarding all available gas and reverting on errors.
201      *
202      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
203      * of certain opcodes, possibly making contracts go over the 2300 gas limit
204      * imposed by `transfer`, making them unable to receive funds via
205      * `transfer`. {sendValue} removes this limitation.
206      *
207      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
208      *
209      * IMPORTANT: because control is transferred to `recipient`, care must be
210      * taken to not create reentrancy vulnerabilities. Consider using
211      * {ReentrancyGuard} or the
212      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
213      */
214     function sendValue(address payable recipient, uint256 amount) internal {
215         require(address(this).balance >= amount, "Address: insufficient balance");
216 
217         (bool success, ) = recipient.call{value: amount}("");
218         require(success, "Address: unable to send value, recipient may have reverted");
219     }
220 
221     /**
222      * @dev Performs a Solidity function call using a low level `call`. A
223      * plain `call` is an unsafe replacement for a function call: use this
224      * function instead.
225      *
226      * If `target` reverts with a revert reason, it is bubbled up by this
227      * function (like regular Solidity function calls).
228      *
229      * Returns the raw returned data. To convert to the expected return value,
230      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
231      *
232      * Requirements:
233      *
234      * - `target` must be a contract.
235      * - calling `target` with `data` must not revert.
236      *
237      * _Available since v3.1._
238      */
239     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionCall(target, data, "Address: low-level call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
245      * `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, 0, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but also transferring `value` wei to `target`.
260      *
261      * Requirements:
262      *
263      * - the calling contract must have an ETH balance of at least `value`.
264      * - the called Solidity function must be `payable`.
265      *
266      * _Available since v3.1._
267      */
268     function functionCallWithValue(
269         address target,
270         bytes memory data,
271         uint256 value
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
278      * with `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(
283         address target,
284         bytes memory data,
285         uint256 value,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(address(this).balance >= value, "Address: insufficient balance for call");
289         require(isContract(target), "Address: call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.call{value: value}(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but performing a static call.
298      *
299      * _Available since v3.3._
300      */
301     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
302         return functionStaticCall(target, data, "Address: low-level static call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal view returns (bytes memory) {
316         require(isContract(target), "Address: static call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.staticcall(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a delegate call.
325      *
326      * _Available since v3.4._
327      */
328     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.4._
337      */
338     function functionDelegateCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         require(isContract(target), "Address: delegate call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.delegatecall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
351      * revert reason using the provided one.
352      *
353      * _Available since v4.3._
354      */
355     function verifyCallResult(
356         bool success,
357         bytes memory returndata,
358         string memory errorMessage
359     ) internal pure returns (bytes memory) {
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366 
367                 assembly {
368                     let returndata_size := mload(returndata)
369                     revert(add(32, returndata), returndata_size)
370                 }
371             } else {
372                 revert(errorMessage);
373             }
374         }
375     }
376 }
377 
378 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
379 
380 
381 /**
382  * @title ERC721 token receiver interface
383  * @dev Interface for any contract that wants to support safeTransfers
384  * from ERC721 asset contracts.
385  */
386 interface IERC721Receiver {
387     /**
388      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
389      * by `operator` from `from`, this function is called.
390      *
391      * It must return its Solidity selector to confirm the token transfer.
392      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
393      *
394      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
395      */
396     function onERC721Received(
397         address operator,
398         address from,
399         uint256 tokenId,
400         bytes calldata data
401     ) external returns (bytes4);
402 }
403 
404 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
405 
406 
407 /**
408  * @dev Interface of the ERC165 standard, as defined in the
409  * https://eips.ethereum.org/EIPS/eip-165[EIP].
410  *
411  * Implementers can declare support of contract interfaces, which can then be
412  * queried by others ({ERC165Checker}).
413  *
414  * For an implementation, see {ERC165}.
415  */
416 interface IERC165 {
417     /**
418      * @dev Returns true if this contract implements the interface defined by
419      * `interfaceId`. See the corresponding
420      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
421      * to learn more about how these ids are created.
422      *
423      * This function call must use less than 30 000 gas.
424      */
425     function supportsInterface(bytes4 interfaceId) external view returns (bool);
426 }
427 
428 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
429 
430 
431 
432 /**
433  * @dev Implementation of the {IERC165} interface.
434  *
435  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
436  * for the additional interface id that will be supported. For example:
437  *
438  * ```solidity
439  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
440  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
441  * }
442  * ```
443  *
444  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
445  */
446 abstract contract ERC165 is IERC165 {
447     /**
448      * @dev See {IERC165-supportsInterface}.
449      */
450     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
451         return interfaceId == type(IERC165).interfaceId;
452     }
453 }
454 
455 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
456 
457 
458 
459 /**
460  * @dev Required interface of an ERC721 compliant contract.
461  */
462 interface IERC721 is IERC165 {
463     /**
464      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
465      */
466     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
470      */
471     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
472 
473     /**
474      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
475      */
476     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
477 
478     /**
479      * @dev Returns the number of tokens in ``owner``'s account.
480      */
481     function balanceOf(address owner) external view returns (uint256 balance);
482 
483     /**
484      * @dev Returns the owner of the `tokenId` token.
485      *
486      * Requirements:
487      *
488      * - `tokenId` must exist.
489      */
490     function ownerOf(uint256 tokenId) external view returns (address owner);
491 
492     /**
493      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
494      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
495      *
496      * Requirements:
497      *
498      * - `from` cannot be the zero address.
499      * - `to` cannot be the zero address.
500      * - `tokenId` token must exist and be owned by `from`.
501      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
502      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
503      *
504      * Emits a {Transfer} event.
505      */
506     function safeTransferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Transfers `tokenId` token from `from` to `to`.
514      *
515      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must be owned by `from`.
522      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
523      *
524      * Emits a {Transfer} event.
525      */
526     function transferFrom(
527         address from,
528         address to,
529         uint256 tokenId
530     ) external;
531 
532     /**
533      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
534      * The approval is cleared when the token is transferred.
535      *
536      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
537      *
538      * Requirements:
539      *
540      * - The caller must own the token or be an approved operator.
541      * - `tokenId` must exist.
542      *
543      * Emits an {Approval} event.
544      */
545     function approve(address to, uint256 tokenId) external;
546 
547     /**
548      * @dev Returns the account approved for `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function getApproved(uint256 tokenId) external view returns (address operator);
555 
556     /**
557      * @dev Approve or remove `operator` as an operator for the caller.
558      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
559      *
560      * Requirements:
561      *
562      * - The `operator` cannot be the caller.
563      *
564      * Emits an {ApprovalForAll} event.
565      */
566     function setApprovalForAll(address operator, bool _approved) external;
567 
568     /**
569      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
570      *
571      * See {setApprovalForAll}
572      */
573     function isApprovedForAll(address owner, address operator) external view returns (bool);
574 
575     /**
576      * @dev Safely transfers `tokenId` token from `from` to `to`.
577      *
578      * Requirements:
579      *
580      * - `from` cannot be the zero address.
581      * - `to` cannot be the zero address.
582      * - `tokenId` token must exist and be owned by `from`.
583      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585      *
586      * Emits a {Transfer} event.
587      */
588     function safeTransferFrom(
589         address from,
590         address to,
591         uint256 tokenId,
592         bytes calldata data
593     ) external;
594 }
595 
596 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
597 
598 
599 
600 /**
601  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
602  * @dev See https://eips.ethereum.org/EIPS/eip-721
603  */
604 interface IERC721Metadata is IERC721 {
605     /**
606      * @dev Returns the token collection name.
607      */
608     function name() external view returns (string memory);
609 
610     /**
611      * @dev Returns the token collection symbol.
612      */
613     function symbol() external view returns (string memory);
614 
615     /**
616      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
617      */
618     function tokenURI(uint256 tokenId) external view returns (string memory);
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
622 
623 
624 /**
625  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
626  * the Metadata extension, but not including the Enumerable extension, which is available separately as
627  * {ERC721Enumerable}.
628  */
629 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
630     using Address for address;
631     using Strings for uint256;
632 
633     // Token name
634     string private _name;
635 
636     // Token symbol
637     string private _symbol;
638 
639     // Mapping from token ID to owner address
640     mapping(uint256 => address) private _owners;
641 
642     // Mapping owner address to token count
643     mapping(address => uint256) private _balances;
644 
645     // Mapping from token ID to approved address
646     mapping(uint256 => address) private _tokenApprovals;
647 
648     // Mapping from owner to operator approvals
649     mapping(address => mapping(address => bool)) private _operatorApprovals;
650 
651     /**
652      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
653      */
654     constructor(string memory name_, string memory symbol_) {
655         _name = name_;
656         _symbol = symbol_;
657     }
658 
659     /**
660      * @dev See {IERC165-supportsInterface}.
661      */
662     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
663         return
664         interfaceId == type(IERC721).interfaceId ||
665         interfaceId == type(IERC721Metadata).interfaceId ||
666         super.supportsInterface(interfaceId);
667     }
668 
669     /**
670      * @dev See {IERC721-balanceOf}.
671      */
672     function balanceOf(address owner) public view virtual override returns (uint256) {
673         require(owner != address(0), "ERC721: balance query for the zero address");
674         return _balances[owner];
675     }
676 
677     /**
678      * @dev See {IERC721-ownerOf}.
679      */
680     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
681         address owner = _owners[tokenId];
682         require(owner != address(0), "ERC721: owner query for nonexistent token");
683         return owner;
684     }
685 
686     /**
687      * @dev See {IERC721Metadata-name}.
688      */
689     function name() public view virtual override returns (string memory) {
690         return _name;
691     }
692 
693     /**
694      * @dev See {IERC721Metadata-symbol}.
695      */
696     function symbol() public view virtual override returns (string memory) {
697         return _symbol;
698     }
699 
700     /**
701      * @dev See {IERC721Metadata-tokenURI}.
702      */
703     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
704         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
705 
706         string memory baseURI = _baseURI();
707         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
708     }
709 
710     /**
711      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
712      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
713      * by default, can be overriden in child contracts.
714      */
715     function _baseURI() internal view virtual returns (string memory) {
716         return "";
717     }
718 
719     /**
720      * @dev See {IERC721-approve}.
721      */
722     function approve(address to, uint256 tokenId) public virtual override {
723         address owner = ERC721.ownerOf(tokenId);
724         require(to != owner, "ERC721: approval to current owner");
725 
726         require(
727             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
728             "ERC721: approve caller is not owner nor approved for all"
729         );
730 
731         _approve(to, tokenId);
732     }
733 
734     /**
735      * @dev See {IERC721-getApproved}.
736      */
737     function getApproved(uint256 tokenId) public view virtual override returns (address) {
738         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
739 
740         return _tokenApprovals[tokenId];
741     }
742 
743     /**
744      * @dev See {IERC721-setApprovalForAll}.
745      */
746     function setApprovalForAll(address operator, bool approved) public virtual override {
747         require(operator != _msgSender(), "ERC721: approve to caller");
748 
749         _operatorApprovals[_msgSender()][operator] = approved;
750         emit ApprovalForAll(_msgSender(), operator, approved);
751     }
752 
753     /**
754      * @dev See {IERC721-isApprovedForAll}.
755      */
756     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
757         return _operatorApprovals[owner][operator];
758     }
759 
760     /**
761      * @dev See {IERC721-transferFrom}.
762      */
763     function transferFrom(
764         address from,
765         address to,
766         uint256 tokenId
767     ) public virtual override {
768         //solhint-disable-next-line max-line-length
769         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
770 
771         _transfer(from, to, tokenId);
772     }
773 
774     /**
775      * @dev See {IERC721-safeTransferFrom}.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId
781     ) public virtual override {
782         safeTransferFrom(from, to, tokenId, "");
783     }
784 
785     /**
786      * @dev See {IERC721-safeTransferFrom}.
787      */
788     function safeTransferFrom(
789         address from,
790         address to,
791         uint256 tokenId,
792         bytes memory _data
793     ) public virtual override {
794         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
795         _safeTransfer(from, to, tokenId, _data);
796     }
797 
798     /**
799      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
800      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
801      *
802      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
803      *
804      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
805      * implement alternative mechanisms to perform token transfer, such as signature-based.
806      *
807      * Requirements:
808      *
809      * - `from` cannot be the zero address.
810      * - `to` cannot be the zero address.
811      * - `tokenId` token must exist and be owned by `from`.
812      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
813      *
814      * Emits a {Transfer} event.
815      */
816     function _safeTransfer(
817         address from,
818         address to,
819         uint256 tokenId,
820         bytes memory _data
821     ) internal virtual {
822         _transfer(from, to, tokenId);
823         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
824     }
825 
826     /**
827      * @dev Returns whether `tokenId` exists.
828      *
829      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
830      *
831      * Tokens start existing when they are minted (`_mint`),
832      * and stop existing when they are burned (`_burn`).
833      */
834     function _exists(uint256 tokenId) internal view virtual returns (bool) {
835         return _owners[tokenId] != address(0);
836     }
837 
838     /**
839      * @dev Returns whether `spender` is allowed to manage `tokenId`.
840      *
841      * Requirements:
842      *
843      * - `tokenId` must exist.
844      */
845     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
846         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
847         address owner = ERC721.ownerOf(tokenId);
848         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
849     }
850 
851     /**
852      * @dev Safely mints `tokenId` and transfers it to `to`.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must not exist.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _safeMint(address to, uint256 tokenId) internal virtual {
862         _safeMint(to, tokenId, "");
863     }
864 
865     /**
866      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
867      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
868      */
869     function _safeMint(
870         address to,
871         uint256 tokenId,
872         bytes memory _data
873     ) internal virtual {
874         _mint(to, tokenId);
875         require(
876             _checkOnERC721Received(address(0), to, tokenId, _data),
877             "ERC721: transfer to non ERC721Receiver implementer"
878         );
879     }
880 
881     /**
882      * @dev Mints `tokenId` and transfers it to `to`.
883      *
884      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
885      *
886      * Requirements:
887      *
888      * - `tokenId` must not exist.
889      * - `to` cannot be the zero address.
890      *
891      * Emits a {Transfer} event.
892      */
893     function _mint(address to, uint256 tokenId) internal virtual {
894         require(to != address(0), "ERC721: mint to the zero address");
895         require(!_exists(tokenId), "ERC721: token already minted");
896 
897         _beforeTokenTransfer(address(0), to, tokenId);
898 
899         _balances[to] += 1;
900         _owners[tokenId] = to;
901 
902         emit Transfer(address(0), to, tokenId);
903     }
904 
905     /**
906      * @dev Destroys `tokenId`.
907      * The approval is cleared when the token is burned.
908      *
909      * Requirements:
910      *
911      * - `tokenId` must exist.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _burn(uint256 tokenId) internal virtual {
916         address owner = ERC721.ownerOf(tokenId);
917 
918         _beforeTokenTransfer(owner, address(0), tokenId);
919 
920         // Clear approvals
921         _approve(address(0), tokenId);
922 
923         _balances[owner] -= 1;
924         delete _owners[tokenId];
925 
926         emit Transfer(owner, address(0), tokenId);
927     }
928 
929     /**
930      * @dev Transfers `tokenId` from `from` to `to`.
931      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
932      *
933      * Requirements:
934      *
935      * - `to` cannot be the zero address.
936      * - `tokenId` token must be owned by `from`.
937      *
938      * Emits a {Transfer} event.
939      */
940     function _transfer(
941         address from,
942         address to,
943         uint256 tokenId
944     ) internal virtual {
945         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
946         require(to != address(0), "ERC721: transfer to the zero address");
947 
948         _beforeTokenTransfer(from, to, tokenId);
949 
950         // Clear approvals from the previous owner
951         _approve(address(0), tokenId);
952 
953         _balances[from] -= 1;
954         _balances[to] += 1;
955         _owners[tokenId] = to;
956 
957         emit Transfer(from, to, tokenId);
958     }
959 
960     /**
961      * @dev Approve `to` to operate on `tokenId`
962      *
963      * Emits a {Approval} event.
964      */
965     function _approve(address to, uint256 tokenId) internal virtual {
966         _tokenApprovals[tokenId] = to;
967         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
968     }
969 
970     /**
971      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
972      * The call is not executed if the target address is not a contract.
973      *
974      * @param from address representing the previous owner of the given token ID
975      * @param to target address that will receive the tokens
976      * @param tokenId uint256 ID of the token to be transferred
977      * @param _data bytes optional data to send along with the call
978      * @return bool whether the call correctly returned the expected magic value
979      */
980     function _checkOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         if (to.isContract()) {
987             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
988                 return retval == IERC721Receiver.onERC721Received.selector;
989             } catch (bytes memory reason) {
990                 if (reason.length == 0) {
991                     revert("ERC721: transfer to non ERC721Receiver implementer");
992                 } else {
993                     assembly {
994                         revert(add(32, reason), mload(reason))
995                     }
996                 }
997             }
998         } else {
999             return true;
1000         }
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before any token transfer. This includes minting
1005      * and burning.
1006      *
1007      * Calling conditions:
1008      *
1009      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1010      * transferred to `to`.
1011      * - When `from` is zero, `tokenId` will be minted for `to`.
1012      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1013      * - `from` and `to` are never both zero.
1014      *
1015      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1016      */
1017     function _beforeTokenTransfer(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) internal virtual {}
1022 }
1023 
1024 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1025 
1026 /**
1027  * @dev ERC721 token with storage based token URI management.
1028  */
1029 abstract contract ERC721URIStorage is ERC721 {
1030     using Strings for uint256;
1031 
1032     // Optional mapping for token URIs
1033     mapping(uint256 => string) private _tokenURIs;
1034 
1035     /**
1036      * @dev See {IERC721Metadata-tokenURI}.
1037      */
1038     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1039         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1040 
1041         string memory _tokenURI = _tokenURIs[tokenId];
1042         string memory base = _baseURI();
1043 
1044         // If there is no base URI, return the token URI.
1045         if (bytes(base).length == 0) {
1046             return _tokenURI;
1047         }
1048         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1049         if (bytes(_tokenURI).length > 0) {
1050             return string(abi.encodePacked(base, _tokenURI));
1051         }
1052 
1053         return super.tokenURI(tokenId);
1054     }
1055 
1056     /**
1057      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      */
1063     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1064         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1065         _tokenURIs[tokenId] = _tokenURI;
1066     }
1067 
1068     /**
1069      * @dev Destroys `tokenId`.
1070      * The approval is cleared when the token is burned.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      *
1076      * Emits a {Transfer} event.
1077      */
1078     function _burn(uint256 tokenId) internal virtual override {
1079         super._burn(tokenId);
1080 
1081         if (bytes(_tokenURIs[tokenId]).length != 0) {
1082             delete _tokenURIs[tokenId];
1083         }
1084     }
1085 }
1086 
1087 // File: @openzeppelin/contracts/utils/Counters.sol
1088 
1089 /**
1090  * @title Counters
1091  * @author Matt Condon (@shrugs)
1092  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1093  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1094  *
1095  * Include with `using Counters for Counters.Counter;`
1096  */
1097 library Counters {
1098     struct Counter {
1099         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1100         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1101         // this feature: see https://github.com/ethereum/solidity/issues/4637
1102         uint256 _value; // default: 0
1103     }
1104 
1105     function current(Counter storage counter) internal view returns (uint256) {
1106         return counter._value;
1107     }
1108 
1109     function increment(Counter storage counter) internal {
1110         unchecked {
1111         counter._value += 1;
1112        }
1113    }
1114 
1115     function incrementByValue(Counter storage counter, uint256 primaryValue) internal{
1116             unchecked {
1117             counter._value += primaryValue;
1118         }
1119     }
1120 
1121 
1122 function decrement(Counter storage counter) internal {
1123 uint256 value = counter._value;
1124 require(value > 0, "Counter: decrement overflow");
1125 unchecked {
1126 counter._value = value - 1;
1127 }
1128 }
1129 
1130 function reset(Counter storage counter) internal {
1131 counter._value = 0;
1132 }
1133 }
1134 
1135 // File: contracts/CaniSpacien.sol
1136 
1137 
1138 
1139 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1140 
1141 // CAUTION
1142 // This version of SafeMath should only be used with Solidity 0.8 or later,
1143 // because it relies on the compiler's built in overflow checks.
1144 
1145 /**
1146  * @dev Wrappers over Solidity's arithmetic operations.
1147  *
1148  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1149  * now has built in overflow checking.
1150  */
1151 library SafeMath {
1152 /**
1153  * @dev Returns the addition of two unsigned integers, with an overflow flag.
1154  *
1155  * _Available since v3.4._
1156  */
1157 function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1158 unchecked {
1159 uint256 c = a + b;
1160 if (c < a) return (false, 0);
1161 return (true, c);
1162 }
1163 }
1164 
1165 /**
1166  * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1167  *
1168  * _Available since v3.4._
1169  */
1170 function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1171 unchecked {
1172 if (b > a) return (false, 0);
1173 return (true, a - b);
1174 }
1175 }
1176 
1177 /**
1178  * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1179  *
1180  * _Available since v3.4._
1181  */
1182 function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1183 unchecked {
1184 // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1185 // benefit is lost if 'b' is also tested.
1186 // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1187 if (a == 0) return (true, 0);
1188 uint256 c = a * b;
1189 if (c / a != b) return (false, 0);
1190 return (true, c);
1191 }
1192 }
1193 
1194 /**
1195  * @dev Returns the division of two unsigned integers, with a division by zero flag.
1196  *
1197  * _Available since v3.4._
1198  */
1199 function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1200 unchecked {
1201 if (b == 0) return (false, 0);
1202 return (true, a / b);
1203 }
1204 }
1205 
1206 /**
1207  * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1208  *
1209  * _Available since v3.4._
1210  */
1211 function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1212 unchecked {
1213 if (b == 0) return (false, 0);
1214 return (true, a % b);
1215 }
1216 }
1217 
1218 /**
1219  * @dev Returns the addition of two unsigned integers, reverting on
1220  * overflow.
1221  *
1222  * Counterpart to Solidity's `+` operator.
1223  *
1224  * Requirements:
1225  *
1226  * - Addition cannot overflow.
1227  */
1228 function add(uint256 a, uint256 b) internal pure returns (uint256) {
1229 return a + b;
1230 }
1231 
1232 /**
1233  * @dev Returns the subtraction of two unsigned integers, reverting on
1234  * overflow (when the result is negative).
1235  *
1236  * Counterpart to Solidity's `-` operator.
1237  *
1238  * Requirements:
1239  *
1240  * - Subtraction cannot overflow.
1241  */
1242 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1243 return a - b;
1244 }
1245 
1246 /**
1247  * @dev Returns the multiplication of two unsigned integers, reverting on
1248  * overflow.
1249  *
1250  * Counterpart to Solidity's `*` operator.
1251  *
1252  * Requirements:
1253  *
1254  * - Multiplication cannot overflow.
1255  */
1256 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1257 return a * b;
1258 }
1259 
1260 /**
1261  * @dev Returns the integer division of two unsigned integers, reverting on
1262  * division by zero. The result is rounded towards zero.
1263  *
1264  * Counterpart to Solidity's `/` operator.
1265  *
1266  * Requirements:
1267  *
1268  * - The divisor cannot be zero.
1269  */
1270 function div(uint256 a, uint256 b) internal pure returns (uint256) {
1271 return a / b;
1272 }
1273 
1274 /**
1275  * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1276  * reverting when dividing by zero.
1277  *
1278  * Counterpart to Solidity's `%` operator. This function uses a `revert`
1279  * opcode (which leaves remaining gas untouched) while Solidity uses an
1280  * invalid opcode to revert (consuming all remaining gas).
1281  *
1282  * Requirements:
1283  *
1284  * - The divisor cannot be zero.
1285  */
1286 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1287 return a % b;
1288 }
1289 
1290 /**
1291  * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1292  * overflow (when the result is negative).
1293  *
1294  * CAUTION: This function is deprecated because it requires allocating memory for the error
1295  * message unnecessarily. For custom revert reasons use {trySub}.
1296  *
1297  * Counterpart to Solidity's `-` operator.
1298  *
1299  * Requirements:
1300  *
1301  * - Subtraction cannot overflow.
1302  */
1303 function sub(
1304 uint256 a,
1305 uint256 b,
1306 string memory errorMessage
1307 ) internal pure returns (uint256) {
1308 unchecked {
1309 require(b <= a, errorMessage);
1310 return a - b;
1311 }
1312 }
1313 
1314 /**
1315  * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1316  * division by zero. The result is rounded towards zero.
1317  *
1318  * Counterpart to Solidity's `/` operator. Note: this function uses a
1319  * `revert` opcode (which leaves remaining gas untouched) while Solidity
1320  * uses an invalid opcode to revert (consuming all remaining gas).
1321  *
1322  * Requirements:
1323  *
1324  * - The divisor cannot be zero.
1325  */
1326 function div(
1327 uint256 a,
1328 uint256 b,
1329 string memory errorMessage
1330 ) internal pure returns (uint256) {
1331 unchecked {
1332 require(b > 0, errorMessage);
1333 return a / b;
1334 }
1335 }
1336 
1337 
1338 function mod(
1339 uint256 a,
1340 uint256 b,
1341 string memory errorMessage
1342 ) internal pure returns (uint256) {
1343 unchecked {
1344 require(b > 0, errorMessage);
1345 return a % b;
1346 }
1347 }
1348 
1349 function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
1350 uint256 c = add(a,m);
1351 uint256 d = sub(c,1);
1352 return mul(div(d,m),m);
1353 }
1354 }
1355 
1356 
1357 
1358 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721Burnable.sol)
1359 
1360 
1361 
1362 /**
1363  * @title ERC721 Burnable Token
1364  * @dev ERC721 Token that can be burned (destroyed).
1365  */
1366 abstract contract ERC721Burnable is Context, ERC721 {
1367     /**
1368      * @dev Burns `tokenId`. See {ERC721-_burn}.
1369      *
1370      * Requirements:
1371      *
1372      * - The caller must own `tokenId` or be an approved operator.
1373      */
1374     function burn(uint256 tokenId) public virtual {
1375         //solhint-disable-next-line max-line-length
1376         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1377         _burn(tokenId);
1378     }
1379 }
1380 
1381 
1382 
1383 // Contract CaniSpacien***********************
1384 
1385 
1386 
1387 contract CaniSpacienNFT is ERC721, Ownable, ERC721Burnable  {
1388     using Counters for Counters.Counter;
1389     uint32 public _maximum_tokens_per_transaction;
1390     uint32 public _MaxTotalSupply;
1391     string public _baseCaniSpacienURL;
1392     bool public isSaleOpen;
1393 
1394 
1395 
1396     Counters.Counter private _tokenIdCounter;
1397     
1398 
1399     constructor() ERC721("CaniSpacien NFT", "CaniSpacien") {
1400     _tokenIdCounter.increment();
1401     _maximum_tokens_per_transaction=2;
1402     _MaxTotalSupply=4444;
1403     _baseCaniSpacienURL= "https://ipfs.io/ipfs/QmcPCk6Vgci12EcPaADbvKdc8qjeS7rS4YC65Wmxy8qXoV/";
1404     isSaleOpen =false;
1405 
1406     }
1407 
1408     function totalSupply()external view returns (uint256){
1409         uint256 total_supply = _tokenIdCounter.current();
1410         total_supply = total_supply-1;
1411         return total_supply;
1412     }
1413 
1414     function _baseURI() internal view override returns (string memory) {
1415         return _baseCaniSpacienURL;
1416     }
1417 
1418     function change_baseURL( string memory _url) public
1419     onlyOwner
1420     returns (string memory) {
1421         _baseCaniSpacienURL = _url;
1422         return _baseCaniSpacienURL;
1423     }
1424 
1425    
1426 
1427     function setupMainSale( bool isOpen) public
1428     onlyOwner
1429     returns (bool) {
1430         isSaleOpen = isOpen;
1431 
1432     return isSaleOpen;
1433     }
1434 
1435     function change_MaxTokensTransaction(uint32 tpt) public
1436     onlyOwner
1437     returns (uint32) {
1438         _maximum_tokens_per_transaction = tpt;
1439         return _maximum_tokens_per_transaction;
1440     }
1441 
1442     function mintToken(uint256 num) 
1443     public
1444     
1445      {
1446         require(isSaleOpen, "Currently Sale session is not enabled.");
1447         require(num<=_maximum_tokens_per_transaction && num > 0, "Exceeds maximum number of tokens that can be minted per transaction.");
1448         uint256 supply = _tokenIdCounter.current();
1449         require( supply + num <= _MaxTotalSupply+1, "Exceeds maximum supply for CaniSpacien tokens." ); 
1450         for(uint256 i; i < num; i++){
1451 		    uint256 tokenId = _tokenIdCounter.current();
1452             _tokenIdCounter.increment();
1453 		    require(!_exists(tokenId), "Token already exist.");
1454 		   _safeMint(msg.sender, tokenId);
1455         }
1456 	}
1457 
1458     function safeMint(uint256 num) public onlyOwner {
1459        //require(num<=_maximum_tokens_per_transaction && num > 0, "Exceeds maximum number of tokens that can be minted per transaction.");
1460         uint256 supply = _tokenIdCounter.current();
1461         require( supply + num <= _MaxTotalSupply+1, "Exceeds maximum supply for CaniSpacien tokens." ); 
1462         for(uint256 i; i < num; i++){
1463 		    uint256 tokenId = _tokenIdCounter.current();
1464             _tokenIdCounter.increment();
1465 		    require(!_exists(tokenId), "Token already exist.");
1466 		   _safeMint(msg.sender, tokenId);
1467 
1468         }
1469     }
1470 
1471     function safeMintTo(address to, uint256 num) public onlyOwner {
1472         //require(num<=_maximum_tokens_per_transaction && num > 0, "Exceeds maximum number of tokens that can be minted per transaction.");
1473         uint256 supply = _tokenIdCounter.current();
1474         require( supply + num <= _MaxTotalSupply+1, "Exceeds maximum supply for CaniSpacien tokens." ); 
1475         for(uint256 i; i < num; i++){
1476 		    uint256 tokenId = _tokenIdCounter.current();
1477             _tokenIdCounter.increment();
1478 		    require(!_exists(tokenId), "Token already exist.");
1479         _safeMint(to, tokenId);
1480 
1481         }
1482     }
1483 
1484 
1485 }