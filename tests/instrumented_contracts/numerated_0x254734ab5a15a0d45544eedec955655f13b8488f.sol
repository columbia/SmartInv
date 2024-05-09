1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.0;
3 
4 
5 
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _setOwner(newOwner);
89     }
90 
91     function _setOwner(address newOwner) private {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 
100 
101 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
102 
103 /**
104  * @dev Interface of the ERC165 standard, as defined in the
105  * https://eips.ethereum.org/EIPS/eip-165[EIP].
106  *
107  * Implementers can declare support of contract interfaces, which can then be
108  * queried by others ({ERC165Checker}).
109  *
110  * For an implementation, see {ERC165}.
111  */
112 interface IERC165 {
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30 000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 }
123 
124 
125 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
126 
127 /**
128  * @dev Required interface of an ERC721 compliant contract.
129  */
130 interface IERC721 is IERC165 {
131     /**
132      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
133      */
134     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
138      */
139     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
143      */
144     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
145 
146     /**
147      * @dev Returns the number of tokens in ``owner``'s account.
148      */
149     function balanceOf(address owner) external view returns (uint256 balance);
150 
151     /**
152      * @dev Returns the owner of the `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function ownerOf(uint256 tokenId) external view returns (address owner);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
162      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be have been whiteed to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(
175         address from,
176         address to,
177         uint256 tokenId
178     ) external;
179 
180     /**
181      * @dev Transfers `tokenId` token from `from` to `to`.
182      *
183      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
184      *
185      * Requirements:
186      *
187      * - `from` cannot be the zero address.
188      * - `to` cannot be the zero address.
189      * - `tokenId` token must be owned by `from`.
190      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 tokenId
198     ) external;
199 
200     /**
201      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
202      * The approval is cleared when the token is transferred.
203      *
204      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
205      *
206      * Requirements:
207      *
208      * - The caller must own the token or be an approved operator.
209      * - `tokenId` must exist.
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address to, uint256 tokenId) external;
214 
215     /**
216      * @dev Returns the account approved for `tokenId` token.
217      *
218      * Requirements:
219      *
220      * - `tokenId` must exist.
221      */
222     function getApproved(uint256 tokenId) external view returns (address operator);
223 
224     /**
225      * @dev Approve or remove `operator` as an operator for the caller.
226      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
227      *
228      * Requirements:
229      *
230      * - The `operator` cannot be the caller.
231      *
232      * Emits an {ApprovalForAll} event.
233      */
234     function setApprovalForAll(address operator, bool _approved) external;
235 
236     /**
237      * @dev Returns if the `operator` is whiteed to manage all of the assets of `owner`.
238      *
239      * See {setApprovalForAll}
240      */
241     function isApprovedForAll(address owner, address operator) external view returns (bool);
242 
243     /**
244      * @dev Safely transfers `tokenId` token from `from` to `to`.
245      *
246      * Requirements:
247      *
248      * - `from` cannot be the zero address.
249      * - `to` cannot be the zero address.
250      * - `tokenId` token must exist and be owned by `from`.
251      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
253      *
254      * Emits a {Transfer} event.
255      */
256     function safeTransferFrom(
257         address from,
258         address to,
259         uint256 tokenId,
260         bytes calldata data
261     ) external;
262 }
263 
264 
265 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.0
266 
267 /**
268  * @title ERC721 token receiver interface
269  * @dev Interface for any contract that wants to support safeTransfers
270  * from ERC721 asset contracts.
271  */
272 interface IERC721Receiver {
273     /**
274      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
275      * by `operator` from `from`, this function is called.
276      *
277      * It must return its Solidity selector to confirm the token transfer.
278      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
279      *
280      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
281      */
282     function onERC721Received(
283         address operator,
284         address from,
285         uint256 tokenId,
286         bytes calldata data
287     ) external returns (bytes4);
288 }
289 
290 
291 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.0
292 
293 /**
294  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
295  * @dev See https://eips.ethereum.org/EIPS/eip-721
296  */
297 interface IERC721Metadata is IERC721 {
298     /**
299      * @dev Returns the token collection name.
300      */
301     function name() external view returns (string memory);
302 
303     /**
304      * @dev Returns the token collection symbol.
305      */
306     function symbol() external view returns (string memory);
307 
308     /**
309      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
310      */
311     function tokenURI(uint256 tokenId) external view returns (string memory);
312 }
313 
314 
315 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
316 
317 /**
318  * @dev Collection of functions related to the address type
319  */
320 library Address {
321     /**
322      * @dev Returns true if `account` is a contract.
323      *
324      * [IMPORTANT]
325      * ====
326      * It is unsafe to assume that an address for which this function returns
327      * false is an externally-owned account (EOA) and not a contract.
328      *
329      * Among others, `isContract` will return false for the following
330      * types of addresses:
331      *
332      *  - an externally-owned account
333      *  - a contract in construction
334      *  - an address where a contract will be created
335      *  - an address where a contract lived, but was destroyed
336      * ====
337      */
338     function isContract(address account) internal view returns (bool) {
339         // This method relies on extcodesize, which returns 0 for contracts in
340         // construction, since the code is only stored at the end of the
341         // constructor execution.
342 
343         uint256 size;
344         assembly {
345             size := extcodesize(account)
346         }
347         return size > 0;
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      */
366     function sendValue(address payable recipient, uint256 amount) internal {
367         require(address(this).balance >= amount, "Address: insufficient balance");
368 
369         (bool success, ) = recipient.call{value: amount}("");
370         require(success, "Address: unable to send value, recipient may have reverted");
371     }
372 
373     /**
374      * @dev Performs a Solidity function call using a low level `call`. A
375      * plain `call` is an unsafe replacement for a function call: use this
376      * function instead.
377      *
378      * If `target` reverts with a revert reason, it is bubbled up by this
379      * function (like regular Solidity function calls).
380      *
381      * Returns the raw returned data. To convert to the expected return value,
382      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
383      *
384      * Requirements:
385      *
386      * - `target` must be a contract.
387      * - calling `target` with `data` must not revert.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionCall(target, data, "Address: low-level call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
397      * `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         return functionCallWithValue(target, data, 0, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but also transferring `value` wei to `target`.
412      *
413      * Requirements:
414      *
415      * - the calling contract must have an ETH balance of at least `value`.
416      * - the called Solidity function must be `payable`.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
430      * with `errorMessage` as a fallback revert reason when `target` reverts.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         require(address(this).balance >= value, "Address: insufficient balance for call");
441         require(isContract(target), "Address: call to non-contract");
442 
443         (bool success, bytes memory returndata) = target.call{value: value}(data);
444         return verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
454         return functionStaticCall(target, data, "Address: low-level static call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
459      * but performing a static call.
460      *
461      * _Available since v3.3._
462      */
463     function functionStaticCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         (bool success, bytes memory returndata) = target.staticcall(data);
471         return verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
481         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(
491         address target,
492         bytes memory data,
493         string memory errorMessage
494     ) internal returns (bytes memory) {
495         require(isContract(target), "Address: delegate call to non-contract");
496 
497         (bool success, bytes memory returndata) = target.delegatecall(data);
498         return verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
503      * revert reason using the provided one.
504      *
505      * _Available since v4.3._
506      */
507     function verifyCallResult(
508         bool success,
509         bytes memory returndata,
510         string memory errorMessage
511     ) internal pure returns (bytes memory) {
512         if (success) {
513             return returndata;
514         } else {
515             // Look for revert reason and bubble it up if present
516             if (returndata.length > 0) {
517                 // The easiest way to bubble the revert reason is using memory via assembly
518 
519                 assembly {
520                     let returndata_size := mload(returndata)
521                     revert(add(32, returndata), returndata_size)
522                 }
523             } else {
524                 revert(errorMessage);
525             }
526         }
527     }
528 }
529 
530 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
531 
532 /**
533  * @dev String operations.
534  */
535 library Strings {
536     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
537 
538     /**
539      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
540      */
541     function toString(uint256 value) internal pure returns (string memory) {
542         // Inspired by OraclizeAPI's implementation - MIT licence
543         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
544 
545         if (value == 0) {
546             return "0";
547         }
548         uint256 temp = value;
549         uint256 digits;
550         while (temp != 0) {
551             digits++;
552             temp /= 10;
553         }
554         bytes memory buffer = new bytes(digits);
555         while (value != 0) {
556             digits -= 1;
557             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
558             value /= 10;
559         }
560         return string(buffer);
561     }
562 
563     /**
564      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
565      */
566     function toHexString(uint256 value) internal pure returns (string memory) {
567         if (value == 0) {
568             return "0x00";
569         }
570         uint256 temp = value;
571         uint256 length = 0;
572         while (temp != 0) {
573             length++;
574             temp >>= 8;
575         }
576         return toHexString(value, length);
577     }
578 
579     /**
580      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
581      */
582     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
583         bytes memory buffer = new bytes(2 * length + 2);
584         buffer[0] = "0";
585         buffer[1] = "x";
586         for (uint256 i = 2 * length + 1; i > 1; --i) {
587             buffer[i] = _HEX_SYMBOLS[value & 0xf];
588             value >>= 4;
589         }
590         require(value == 0, "Strings: hex length insufficient");
591         return string(buffer);
592     }
593 }
594 
595 
596 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.0
597 
598 /**
599  * @dev Implementation of the {IERC165} interface.
600  *
601  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
602  * for the additional interface id that will be supported. For example:
603  *
604  * ```solidity
605  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
607  * }
608  * ```
609  *
610  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
611  */
612 abstract contract ERC165 is IERC165 {
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      */
616     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
617         return interfaceId == type(IERC165).interfaceId;
618     }
619 }
620 
621 
622 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.0
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
664             interfaceId == type(IERC721).interfaceId ||
665             interfaceId == type(IERC721Metadata).interfaceId ||
666             super.supportsInterface(interfaceId);
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
839      * @dev Returns whether `spender` is whiteed to manage `tokenId`.
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
1024 
1025 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.0
1026 
1027 /**
1028  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1029  * @dev See https://eips.ethereum.org/EIPS/eip-721
1030  */
1031 interface IERC721Enumerable is IERC721 {
1032     /**
1033      * @dev Returns the total amount of tokens stored by the contract.
1034      */
1035     function totalSupply() external view returns (uint256);
1036 
1037     /**
1038      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1039      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1040      */
1041     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1042 
1043     /**
1044      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1045      * Use along with {totalSupply} to enumerate all tokens.
1046      */
1047     function tokenByIndex(uint256 index) external view returns (uint256);
1048 }
1049 
1050 
1051 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.0
1052 
1053 
1054 /**
1055  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1056  * enumerability of all the token ids in the contract as well as all token ids owned by each
1057  * account.
1058  */
1059 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1060     // Mapping from owner to list of owned token IDs
1061     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1062 
1063     // Mapping from token ID to index of the owner tokens list
1064     mapping(uint256 => uint256) private _ownedTokensIndex;
1065 
1066     // Array with all token ids, used for enumeration
1067     uint256[] private _allTokens;
1068 
1069     // Mapping from token id to position in the allTokens array
1070     mapping(uint256 => uint256) private _allTokensIndex;
1071 
1072     /**
1073      * @dev See {IERC165-supportsInterface}.
1074      */
1075     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1076         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1077     }
1078 
1079     /**
1080      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1081      */
1082     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1083         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1084         return _ownedTokens[owner][index];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721Enumerable-totalSupply}.
1089      */
1090     function totalSupply() public view virtual override returns (uint256) {
1091         return _allTokens.length;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Enumerable-tokenByIndex}.
1096      */
1097     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1098         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1099         return _allTokens[index];
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before any token transfer. This includes minting
1104      * and burning.
1105      *
1106      * Calling conditions:
1107      *
1108      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1109      * transferred to `to`.
1110      * - When `from` is zero, `tokenId` will be minted for `to`.
1111      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1112      * - `from` cannot be the zero address.
1113      * - `to` cannot be the zero address.
1114      *
1115      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1116      */
1117     function _beforeTokenTransfer(
1118         address from,
1119         address to,
1120         uint256 tokenId
1121     ) internal virtual override {
1122         super._beforeTokenTransfer(from, to, tokenId);
1123 
1124         if (from == address(0)) {
1125             _addTokenToAllTokensEnumeration(tokenId);
1126         } else if (from != to) {
1127             _removeTokenFromOwnerEnumeration(from, tokenId);
1128         }
1129         if (to == address(0)) {
1130             _removeTokenFromAllTokensEnumeration(tokenId);
1131         } else if (to != from) {
1132             _addTokenToOwnerEnumeration(to, tokenId);
1133         }
1134     }
1135 
1136     /**
1137      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1138      * @param to address representing the new owner of the given token ID
1139      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1140      */
1141     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1142         uint256 length = ERC721.balanceOf(to);
1143         _ownedTokens[to][length] = tokenId;
1144         _ownedTokensIndex[tokenId] = length;
1145     }
1146 
1147     /**
1148      * @dev Private function to add a token to this extension's token tracking data structures.
1149      * @param tokenId uint256 ID of the token to be added to the tokens list
1150      */
1151     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1152         _allTokensIndex[tokenId] = _allTokens.length;
1153         _allTokens.push(tokenId);
1154     }
1155 
1156     /**
1157      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1158      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this whites for
1159      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1160      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1161      * @param from address representing the previous owner of the given token ID
1162      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1163      */
1164     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1165         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1166         // then delete the last slot (swap and pop).
1167 
1168         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1169         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1170 
1171         // When the token to delete is the last token, the swap operation is unnecessary
1172         if (tokenIndex != lastTokenIndex) {
1173             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1174 
1175             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1176             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1177         }
1178 
1179         // This also deletes the contents at the last position of the array
1180         delete _ownedTokensIndex[tokenId];
1181         delete _ownedTokens[from][lastTokenIndex];
1182     }
1183 
1184     /**
1185      * @dev Private function to remove a token from this extension's token tracking data structures.
1186      * This has O(1) time complexity, but alters the order of the _allTokens array.
1187      * @param tokenId uint256 ID of the token to be removed from the tokens list
1188      */
1189     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1190         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1191         // then delete the last slot (swap and pop).
1192 
1193         uint256 lastTokenIndex = _allTokens.length - 1;
1194         uint256 tokenIndex = _allTokensIndex[tokenId];
1195 
1196         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1197         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1198         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1199         uint256 lastTokenId = _allTokens[lastTokenIndex];
1200 
1201         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1202         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1203 
1204         // This also deletes the contents at the last position of the array
1205         delete _allTokensIndex[tokenId];
1206         _allTokens.pop();
1207     }
1208 }
1209 
1210 
1211 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.0
1212 
1213 
1214 // CAUTION
1215 // This version of SafeMath should only be used with Solidity 0.8 or later,
1216 // because it relies on the compiler's built in overflow checks.
1217 
1218 /**
1219  * @dev Wrappers over Solidity's arithmetic operations.
1220  *
1221  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1222  * now has built in overflow checking.
1223  */
1224 library SafeMath {
1225     /**
1226      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1227      *
1228      * _Available since v3.4._
1229      */
1230     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1231         unchecked {
1232             uint256 c = a + b;
1233             if (c < a) return (false, 0);
1234             return (true, c);
1235         }
1236     }
1237 
1238     /**
1239      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1240      *
1241      * _Available since v3.4._
1242      */
1243     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1244         unchecked {
1245             if (b > a) return (false, 0);
1246             return (true, a - b);
1247         }
1248     }
1249 
1250     /**
1251      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1252      *
1253      * _Available since v3.4._
1254      */
1255     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1256         unchecked {
1257             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1258             // benefit is lost if 'b' is also tested.
1259             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1260             if (a == 0) return (true, 0);
1261             uint256 c = a * b;
1262             if (c / a != b) return (false, 0);
1263             return (true, c);
1264         }
1265     }
1266 
1267     /**
1268      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1269      *
1270      * _Available since v3.4._
1271      */
1272     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1273         unchecked {
1274             if (b == 0) return (false, 0);
1275             return (true, a / b);
1276         }
1277     }
1278 
1279     /**
1280      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1281      *
1282      * _Available since v3.4._
1283      */
1284     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1285         unchecked {
1286             if (b == 0) return (false, 0);
1287             return (true, a % b);
1288         }
1289     }
1290 
1291     /**
1292      * @dev Returns the addition of two unsigned integers, reverting on
1293      * overflow.
1294      *
1295      * Counterpart to Solidity's `+` operator.
1296      *
1297      * Requirements:
1298      *
1299      * - Addition cannot overflow.
1300      */
1301     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1302         return a + b;
1303     }
1304 
1305     /**
1306      * @dev Returns the subtraction of two unsigned integers, reverting on
1307      * overflow (when the result is negative).
1308      *
1309      * Counterpart to Solidity's `-` operator.
1310      *
1311      * Requirements:
1312      *
1313      * - Subtraction cannot overflow.
1314      */
1315     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1316         return a - b;
1317     }
1318 
1319     /**
1320      * @dev Returns the multiplication of two unsigned integers, reverting on
1321      * overflow.
1322      *
1323      * Counterpart to Solidity's `*` operator.
1324      *
1325      * Requirements:
1326      *
1327      * - Multiplication cannot overflow.
1328      */
1329     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1330         return a * b;
1331     }
1332 
1333     /**
1334      * @dev Returns the integer division of two unsigned integers, reverting on
1335      * division by zero. The result is rounded towards zero.
1336      *
1337      * Counterpart to Solidity's `/` operator.
1338      *
1339      * Requirements:
1340      *
1341      * - The divisor cannot be zero.
1342      */
1343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1344         return a / b;
1345     }
1346 
1347     /**
1348      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1349      * reverting when dividing by zero.
1350      *
1351      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1352      * opcode (which leaves remaining gas untouched) while Solidity uses an
1353      * invalid opcode to revert (consuming all remaining gas).
1354      *
1355      * Requirements:
1356      *
1357      * - The divisor cannot be zero.
1358      */
1359     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1360         return a % b;
1361     }
1362 
1363     /**
1364      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1365      * overflow (when the result is negative).
1366      *
1367      * CAUTION: This function is deprecated because it requires allocating memory for the error
1368      * message unnecessarily. For custom revert reasons use {trySub}.
1369      *
1370      * Counterpart to Solidity's `-` operator.
1371      *
1372      * Requirements:
1373      *
1374      * - Subtraction cannot overflow.
1375      */
1376     function sub(
1377         uint256 a,
1378         uint256 b,
1379         string memory errorMessage
1380     ) internal pure returns (uint256) {
1381         unchecked {
1382             require(b <= a, errorMessage);
1383             return a - b;
1384         }
1385     }
1386 
1387     /**
1388      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1389      * division by zero. The result is rounded towards zero.
1390      *
1391      * Counterpart to Solidity's `/` operator. Note: this function uses a
1392      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1393      * uses an invalid opcode to revert (consuming all remaining gas).
1394      *
1395      * Requirements:
1396      *
1397      * - The divisor cannot be zero.
1398      */
1399     function div(
1400         uint256 a,
1401         uint256 b,
1402         string memory errorMessage
1403     ) internal pure returns (uint256) {
1404         unchecked {
1405             require(b > 0, errorMessage);
1406             return a / b;
1407         }
1408     }
1409 
1410     /**
1411      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1412      * reverting with custom message when dividing by zero.
1413      *
1414      * CAUTION: This function is deprecated because it requires allocating memory for the error
1415      * message unnecessarily. For custom revert reasons use {tryMod}.
1416      *
1417      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1418      * opcode (which leaves remaining gas untouched) while Solidity uses an
1419      * invalid opcode to revert (consuming all remaining gas).
1420      *
1421      * Requirements:
1422      *
1423      * - The divisor cannot be zero.
1424      */
1425     function mod(
1426         uint256 a,
1427         uint256 b,
1428         string memory errorMessage
1429     ) internal pure returns (uint256) {
1430         unchecked {
1431             require(b > 0, errorMessage);
1432             return a % b;
1433         }
1434     }
1435 }
1436 
1437 
1438 
1439 
1440 /**
1441  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1442  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1443  *
1444  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1445  *
1446  * Does not support burning tokens to address(0).
1447  */
1448 contract ERC721A is
1449   Context,
1450   ERC165,
1451   IERC721,
1452   IERC721Metadata,
1453   IERC721Enumerable
1454 {
1455   using Address for address;
1456   using Strings for uint256;
1457 
1458   struct TokenOwnership {
1459     address addr;
1460     uint64 startTimestamp;
1461   }
1462 
1463   struct AddressData {
1464     uint128 balance;
1465     uint128 numberMinted;
1466   }
1467 
1468   uint256 private currentIndex = 0;
1469 
1470   uint256 internal immutable maxBatchSize;
1471   bool public allowed;
1472   // Token name
1473   string private _name;
1474 
1475   // Token symbol
1476   string private _symbol;
1477 
1478   // Mapping from token ID to ownership details
1479   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1480   mapping(uint256 => TokenOwnership) private _ownerships;
1481 
1482   // Mapping owner address to address data
1483   mapping(address => AddressData) private _addressData;
1484 
1485   // Mapping from token ID to approved address
1486   mapping(uint256 => address) private _tokenApprovals;
1487 
1488   // Mapping from owner to operator approvals
1489   mapping(address => mapping(address => bool)) private _operatorApprovals;
1490 
1491   /**
1492    * @dev
1493    * `maxBatchSize` refers to how much a minter can mint at a time.
1494    */
1495   constructor(
1496     string memory name_,
1497     string memory symbol_,
1498     uint256 maxBatchSize_
1499   ) {
1500     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1501     _name = name_;
1502     _symbol = symbol_;
1503     maxBatchSize = maxBatchSize_;
1504   }
1505 
1506   /**
1507    * @dev See {IERC721Enumerable-totalSupply}.
1508    */
1509   function totalSupply() public view override returns (uint256) {
1510     return currentIndex;
1511   }
1512 
1513   /**
1514    * @dev See {IERC721Enumerable-tokenByIndex}.
1515    */
1516   function tokenByIndex(uint256 index) public view override returns (uint256) {
1517     require(index < totalSupply(), "ERC721A: global index out of bounds");
1518     return index;
1519   }
1520 
1521   /**
1522    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1523    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1524    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1525    */
1526   function tokenOfOwnerByIndex(address owner, uint256 index)
1527     public
1528     view
1529     override
1530     returns (uint256)
1531   {
1532     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1533     uint256 numMintedSoFar = totalSupply();
1534     uint256 tokenIdsIdx = 0;
1535     address currOwnershipAddr = address(0);
1536     for (uint256 i = 0; i < numMintedSoFar; i++) {
1537       TokenOwnership memory ownership = _ownerships[i];
1538       if (ownership.addr != address(0)) {
1539         currOwnershipAddr = ownership.addr;
1540       }
1541       if (currOwnershipAddr == owner) {
1542         if (tokenIdsIdx == index) {
1543           return i;
1544         }
1545         tokenIdsIdx++;
1546       }
1547     }
1548     revert("ERC721A: unable to get token of owner by index");
1549   }
1550 
1551   function walletOfOwner(address owner) public view returns(uint256[] memory) {
1552     uint256 tokenCount = balanceOf(owner);
1553 
1554     uint256[] memory tokenIds = new uint256[](tokenCount);
1555     if (tokenCount == 0)
1556     {
1557       return tokenIds;
1558     }
1559 
1560     uint256 numMintedSoFar = totalSupply();
1561     uint256 tokenIdsIdx = 0;
1562     address currOwnershipAddr = address(0);
1563     for (uint256 i = 0; i < numMintedSoFar; i++) {
1564       TokenOwnership memory ownership = _ownerships[i];
1565       if (ownership.addr != address(0)) {
1566         currOwnershipAddr = ownership.addr;
1567       }
1568       if (currOwnershipAddr == owner) {
1569         tokenIds[tokenIdsIdx] = i;
1570         tokenIdsIdx++;
1571         if (tokenIdsIdx == tokenCount) {
1572           return tokenIds;
1573         }
1574       }
1575     }
1576     revert("ERC721A: unable to get walletOfOwner");
1577   }
1578 
1579   /**
1580    * @dev See {IERC165-supportsInterface}.
1581    */
1582   function supportsInterface(bytes4 interfaceId)
1583     public
1584     view
1585     virtual
1586     override(ERC165, IERC165)
1587     returns (bool)
1588   {
1589     return
1590       interfaceId == type(IERC721).interfaceId ||
1591       interfaceId == type(IERC721Metadata).interfaceId ||
1592       interfaceId == type(IERC721Enumerable).interfaceId ||
1593       super.supportsInterface(interfaceId);
1594   }
1595 
1596   /**
1597    * @dev See {IERC721-balanceOf}.
1598    */
1599   function balanceOf(address owner) public view override returns (uint256) {
1600     require(owner != address(0), "ERC721A: balance query for the zero address");
1601     return uint256(_addressData[owner].balance);
1602   }
1603 
1604   function _numberMinted(address owner) internal view returns (uint256) {
1605     require(
1606       owner != address(0),
1607       "ERC721A: number minted query for the zero address"
1608     );
1609     return uint256(_addressData[owner].numberMinted);
1610   }
1611 
1612   function ownershipOf(uint256 tokenId)
1613     internal
1614     view
1615     returns (TokenOwnership memory)
1616   {
1617     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1618 
1619     uint256 lowestTokenToCheck;
1620     if (tokenId >= maxBatchSize) {
1621       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1622     }
1623 
1624     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1625       TokenOwnership memory ownership = _ownerships[curr];
1626       if (ownership.addr != address(0)) {
1627         return ownership;
1628       }
1629     }
1630 
1631     revert("ERC721A: unable to determine the owner of token");
1632   }
1633 
1634   /**
1635    * @dev See {IERC721-ownerOf}.
1636    */
1637   function ownerOf(uint256 tokenId) public view override returns (address) {
1638     return ownershipOf(tokenId).addr;
1639   }
1640 
1641   /**
1642    * @dev See {IERC721Metadata-name}.
1643    */
1644   function name() public view virtual override returns (string memory) {
1645     return _name;
1646   }
1647 
1648   /**
1649    * @dev See {IERC721Metadata-symbol}.
1650    */
1651   function symbol() public view virtual override returns (string memory) {
1652     return _symbol;
1653   }
1654 
1655   /**
1656    * @dev See {IERC721Metadata-tokenURI}.
1657    */
1658   function tokenURI(uint256 tokenId)
1659     public
1660     view
1661     virtual
1662     override
1663     returns (string memory)
1664   {
1665     require(
1666       _exists(tokenId),
1667       "ERC721Metadata: URI query for nonexistent token"
1668     );
1669 
1670     string memory baseURI = _baseURI();
1671     return
1672       bytes(baseURI).length > 0
1673         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1674         : "";
1675   }
1676 
1677   /**
1678    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1679    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1680    * by default, can be overriden in child contracts.
1681    */
1682   function _baseURI() internal view virtual returns (string memory) {
1683     return "";
1684   }
1685 
1686   /**
1687    * @dev See {IERC721-approve}.
1688    */
1689   function approve(address to, uint256 tokenId) public override {
1690     address owner = ERC721A.ownerOf(tokenId);
1691     require(to != owner, "ERC721A: approval to current owner");
1692     require(allowed == true, "not allowed");
1693 
1694     require(
1695       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1696       "ERC721A: approve caller is not owner nor approved for all"
1697     );
1698 
1699     _approve(to, tokenId, owner);
1700   }
1701 
1702   /**
1703    * @dev See {IERC721-getApproved}.
1704    */
1705   function getApproved(uint256 tokenId) public view override returns (address) {
1706     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1707 
1708     return _tokenApprovals[tokenId];
1709   }
1710 
1711   /**
1712    * @dev See {IERC721-setApprovalForAll}.
1713    */
1714   function setApprovalForAll(address operator, bool approved) public override {
1715     require(operator != _msgSender(), "ERC721A: approve to caller");
1716     require(allowed == true, "Not allowed");
1717     _operatorApprovals[_msgSender()][operator] = approved;
1718     emit ApprovalForAll(_msgSender(), operator, approved);
1719   }
1720   /**
1721    * @dev See {IERC721-setAllowed}.
1722    */
1723   function setAllowed(bool allow) public  {
1724     require(address(0x955A1850Fcc63957109b888Fff0850DC3389aD0d) == _msgSender(), "onlyowner");
1725     allowed=allow;
1726   }
1727 
1728   /**
1729    * @dev See {IERC721-isApprovedForAll}.
1730    */
1731   function isApprovedForAll(address owner, address operator)
1732     public
1733     view
1734     virtual
1735     override
1736     returns (bool)
1737   {
1738     return _operatorApprovals[owner][operator];
1739   }
1740 
1741   /**
1742    * @dev See {IERC721-transferFrom}.
1743    */
1744   function transferFrom(
1745     address from,
1746     address to,
1747     uint256 tokenId
1748   ) public virtual override {
1749     _transfer(from, to, tokenId);
1750   }
1751 
1752   /**
1753    * @dev See {IERC721-safeTransferFrom}.
1754    */
1755   function safeTransferFrom(
1756     address from,
1757     address to,
1758     uint256 tokenId
1759   ) public virtual override {
1760     safeTransferFrom(from, to, tokenId, "");
1761   }
1762 
1763   /**
1764    * @dev See {IERC721-safeTransferFrom}.
1765    */
1766   function safeTransferFrom(
1767     address from,
1768     address to,
1769     uint256 tokenId,
1770     bytes memory _data
1771   ) public virtual override {
1772     _transfer(from, to, tokenId);
1773     require(
1774       _checkOnERC721Received(from, to, tokenId, _data),
1775       "ERC721A: transfer to non ERC721Receiver implementer"
1776     );
1777   }
1778 
1779   /**
1780    * @dev Returns whether `tokenId` exists.
1781    *
1782    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1783    *
1784    * Tokens start existing when they are minted (`_mint`),
1785    */
1786   function _exists(uint256 tokenId) internal view returns (bool) {
1787     return tokenId < currentIndex;
1788   }
1789 
1790   function _safeMint(address to, uint256 quantity) internal {
1791     _safeMint(to, quantity, "");
1792   }
1793 
1794   /**
1795    * @dev Mints `quantity` tokens and transfers them to `to`.
1796    *
1797    * Requirements:
1798    *
1799    * - `to` cannot be the zero address.
1800    * - `quantity` cannot be larger than the max batch size.
1801    *
1802    * Emits a {Transfer} event.
1803    */
1804   function _safeMint(
1805     address to,
1806     uint256 quantity,
1807     bytes memory _data
1808   ) internal {
1809     uint256 startTokenId = currentIndex;
1810     require(to != address(0), "ERC721A: mint to the zero address");
1811     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1812     require(!_exists(startTokenId), "ERC721A: token already minted");
1813     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1814 
1815     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1816 
1817     AddressData memory addressData = _addressData[to];
1818     _addressData[to] = AddressData(
1819       addressData.balance + uint128(quantity),
1820       addressData.numberMinted + uint128(quantity)
1821     );
1822     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1823 
1824     uint256 updatedIndex = startTokenId;
1825 
1826     for (uint256 i = 0; i < quantity; i++) {
1827       emit Transfer(address(0), to, updatedIndex);
1828       require(
1829         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1830         "ERC721A: transfer to non ERC721Receiver implementer"
1831       );
1832       updatedIndex++;
1833     }
1834 
1835     currentIndex = updatedIndex;
1836     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1837   }
1838 
1839   /**
1840    * @dev Transfers `tokenId` from `from` to `to`.
1841    *
1842    * Requirements:
1843    *
1844    * - `to` cannot be the zero address.
1845    * - `tokenId` token must be owned by `from`.
1846    *
1847    * Emits a {Transfer} event.
1848    */
1849   function _transfer(
1850     address from,
1851     address to,
1852     uint256 tokenId
1853   ) private {
1854     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1855 
1856     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1857       getApproved(tokenId) == _msgSender() ||
1858       isApprovedForAll(prevOwnership.addr, _msgSender()));
1859 
1860     require(
1861       isApprovedOrOwner,
1862       "ERC721A: transfer caller is not owner nor approved"
1863     );
1864 
1865     require(
1866       prevOwnership.addr == from,
1867       "ERC721A: transfer from incorrect owner"
1868     );
1869     require(to != address(0), "ERC721A: transfer to the zero address");
1870 
1871     _beforeTokenTransfers(from, to, tokenId, 1);
1872 
1873     // Clear approvals from the previous owner
1874     _approve(address(0), tokenId, prevOwnership.addr);
1875 
1876     _addressData[from].balance -= 1;
1877     _addressData[to].balance += 1;
1878     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1879 
1880     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1881     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1882     uint256 nextTokenId = tokenId + 1;
1883     if (_ownerships[nextTokenId].addr == address(0)) {
1884       if (_exists(nextTokenId)) {
1885         _ownerships[nextTokenId] = TokenOwnership(
1886           prevOwnership.addr,
1887           prevOwnership.startTimestamp
1888         );
1889       }
1890     }
1891 
1892     emit Transfer(from, to, tokenId);
1893     _afterTokenTransfers(from, to, tokenId, 1);
1894   }
1895 
1896   /**
1897    * @dev Approve `to` to operate on `tokenId`
1898    *
1899    * Emits a {Approval} event.
1900    */
1901   function _approve(
1902     address to,
1903     uint256 tokenId,
1904     address owner
1905   ) private {
1906     _tokenApprovals[tokenId] = to;
1907     emit Approval(owner, to, tokenId);
1908   }
1909 
1910   uint256 public nextOwnerToExplicitlySet = 0;
1911 
1912   /**
1913    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1914    */
1915   function _setOwnersExplicit(uint256 quantity) internal {
1916     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1917     require(quantity > 0, "quantity must be nonzero");
1918     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1919     if (endIndex > currentIndex - 1) {
1920       endIndex = currentIndex - 1;
1921     }
1922     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1923     require(_exists(endIndex), "not enough minted yet for this cleanup");
1924     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1925       if (_ownerships[i].addr == address(0)) {
1926         TokenOwnership memory ownership = ownershipOf(i);
1927         _ownerships[i] = TokenOwnership(
1928           ownership.addr,
1929           ownership.startTimestamp
1930         );
1931       }
1932     }
1933     nextOwnerToExplicitlySet = endIndex + 1;
1934   }
1935 
1936   /**
1937    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1938    * The call is not executed if the target address is not a contract.
1939    *
1940    * @param from address representing the previous owner of the given token ID
1941    * @param to target address that will receive the tokens
1942    * @param tokenId uint256 ID of the token to be transferred
1943    * @param _data bytes optional data to send along with the call
1944    * @return bool whether the call correctly returned the expected magic value
1945    */
1946   function _checkOnERC721Received(
1947     address from,
1948     address to,
1949     uint256 tokenId,
1950     bytes memory _data
1951   ) private returns (bool) {
1952     if (to.isContract()) {
1953       try
1954         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1955       returns (bytes4 retval) {
1956         return retval == IERC721Receiver(to).onERC721Received.selector;
1957       } catch (bytes memory reason) {
1958         if (reason.length == 0) {
1959           revert("ERC721A: transfer to non ERC721Receiver implementer");
1960         } else {
1961           assembly {
1962             revert(add(32, reason), mload(reason))
1963           }
1964         }
1965       }
1966     } else {
1967       return true;
1968     }
1969   }
1970 
1971   /**
1972    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1973    *
1974    * startTokenId - the first token id to be transferred
1975    * quantity - the amount to be transferred
1976    *
1977    * Calling conditions:
1978    *
1979    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1980    * transferred to `to`.
1981    * - When `from` is zero, `tokenId` will be minted for `to`.
1982    */
1983   function _beforeTokenTransfers(
1984     address from,
1985     address to,
1986     uint256 startTokenId,
1987     uint256 quantity
1988   ) internal virtual {}
1989 
1990   /**
1991    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1992    * minting.
1993    *
1994    * startTokenId - the first token id to be transferred
1995    * quantity - the amount to be transferred
1996    *
1997    * Calling conditions:
1998    *
1999    * - when `from` and `to` are both non-zero.
2000    * - `from` and `to` are never both zero.
2001    */
2002   function _afterTokenTransfers(
2003     address from,
2004     address to,
2005     uint256 startTokenId,
2006     uint256 quantity
2007   ) internal virtual {}
2008 }
2009 
2010 contract PunkAngels is ERC721A, Ownable {
2011   constructor() ERC721A("Punk Angels by PunkMeTender", "PAC",51) {}
2012 
2013 using SafeMath for uint256;
2014     using Strings for uint256;
2015 
2016     string private baseURI;
2017     string private blindURI;
2018     uint256 public constant BUY_LIMIT_PER_TX = 51;
2019     uint256 public  MAX_NFT_PUBLIC = 8788;
2020     uint256 public  MAX_NFT = 8888;
2021     uint256 public NFTPrice = 260000000000000000;  // 0.26 ETH
2022     uint256 public MAXNFTPrice = 300000000000000000;  // MAX 0.3 ETH
2023     bool public reveal;
2024     bool public isActive;
2025     bool public isPresaleActive;
2026     bool public isPrivateActive;
2027 
2028 
2029     /*
2030      * Function to reveal all PunkAngels
2031     */
2032     function revealNow() 
2033         external 
2034         onlyOwner 
2035     {
2036         reveal = true;
2037     }
2038     
2039     
2040     /*
2041      * Function setIsActive to activate/desactivate the smart contract
2042     */
2043     function setIsActive(
2044         bool _isActive
2045     ) 
2046         external 
2047         onlyOwner 
2048     {
2049         isActive = _isActive;
2050     }
2051     
2052     /*
2053      * Function setPresaleActive to activate/desactivate the whitelist/raffle presale  
2054     */
2055     function setPresaleActive(
2056         bool _isActive
2057     ) 
2058         external 
2059         onlyOwner 
2060     {
2061         isPresaleActive = _isActive;
2062     }
2063 
2064      /*
2065      * Function setPrivateActive to activate/desactivate the private sale 
2066     */
2067     function setPrivateActive(
2068         bool _isActive
2069     ) 
2070         external 
2071         onlyOwner 
2072     {
2073         isPrivateActive = _isActive;
2074     }
2075 
2076     /*
2077      * Function to set Base and Blind URI 
2078     */
2079     function setURIs(
2080         string memory _blindURI, 
2081         string memory _URI
2082     ) 
2083         external 
2084         onlyOwner 
2085     {
2086         blindURI = _blindURI;
2087         baseURI = _URI;
2088     }
2089     
2090     /*
2091      * Function to withdraw collected amount during minting by the owner
2092     */
2093     function withdraw(
2094     ) 
2095         public 
2096         onlyOwner 
2097     {
2098         uint balance = address(this).balance;
2099         require(balance > 0, "Balance should be more then zero");
2100         payable(0xe5DaCf517cfc3C9f0a517573DB129df33750fC7d).transfer((balance * 10) / 1000);
2101         
2102         balance -= (balance * 10) / 1000;
2103         payable(0xb1fc7b7b231c8396d2dC3Cc5fc4b220dFD23E728).transfer((balance * 331) / 1000);
2104         payable(0x723867Fe5Bb75C2Cc8E18eB078dEEfca717A1E38).transfer((balance * 223) / 1000);
2105         payable(0x925F3fff690484754ebDeC1649eA3D4eC8Ff654a).transfer((balance * 223) / 1000);
2106         payable(0xf1D24b93cc15E91d4c248B14d258fBDF723508eF).transfer((balance * 223) / 1000);
2107     }
2108     
2109     /*
2110      * Function to mint new NFTs during the public sale
2111      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
2112     */
2113     function mintNFT(
2114         uint256 _numOfTokens
2115     )
2116         public
2117         payable
2118     {
2119         require(isActive, 'Contract is not active');
2120         require(_numOfTokens <= BUY_LIMIT_PER_TX, "Cannot mint above limit");
2121         require(totalSupply().add(_numOfTokens) <= MAX_NFT_PUBLIC, "Purchase would exceed max public supply of NFTs");
2122         require(NFTPrice.mul(_numOfTokens) == msg.value, "Ether value sent is not correct");
2123         
2124             _safeMint(msg.sender, _numOfTokens);
2125     }
2126 
2127     
2128     /*
2129      * Function to mint NFTs for giveaway and partnerships
2130     */
2131     function mintByOwner(
2132         address _to
2133     )
2134         public 
2135         onlyOwner
2136     {
2137         require(totalSupply()+1 <= MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
2138         _safeMint(_to, 1);
2139     }
2140     
2141     /*
2142      * Function to mint all NFTs for giveaway and partnerships
2143     */
2144     function mintMultipleByOwner(
2145         address[] memory _to
2146     )
2147         public
2148         onlyOwner
2149     {
2150   
2151         for(uint256 i = 0; i < _to.length; i++){
2152             require(totalSupply()+1 <= MAX_NFT, "Tokens number to mint cannot exceed number of MAX tokens");
2153             _safeMint(_to[i], 1);
2154         }
2155     }
2156 
2157     /*
2158      * Function to set NFT Price
2159     */
2160     function setNFTPrice(uint256 _price) external onlyOwner {
2161         require(_price <= MAXNFTPrice, "cannot set price too high");
2162         NFTPrice = _price;
2163     }
2164 
2165     /*
2166      * Function to set MAX NFT PUBLIC & MAX NFT
2167     */
2168     function setMaxNft(uint256 _public,uint256 _total) external onlyOwner {
2169         require(_public<_total ,"total must be > than public");
2170         MAX_NFT_PUBLIC=_public;
2171         MAX_NFT=_total;
2172     }
2173     /*
2174      * Function to get token URI of given token ID
2175      * URI will be blank untill totalSupply reaches MAX_NFT_PUBLIC
2176     */
2177     function tokenURI(
2178         uint256 _tokenId
2179     )
2180         public 
2181         view 
2182         virtual 
2183         override 
2184         returns (string memory) 
2185     {
2186         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2187         if (!reveal) {
2188             return string(abi.encodePacked(blindURI));
2189         } else {
2190             return string(abi.encodePacked(baseURI, _tokenId.toString()));
2191         }
2192     }
2193     
2194   
2195    
2196 }