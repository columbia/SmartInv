1 pragma solidity ^0.8.2;
2 
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _transferOwnership(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         _transferOwnership(newOwner);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Internal function without access restriction.
90      */
91     function _transferOwnership(address newOwner) internal virtual {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 
99 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
100 /**
101  * @dev Interface of the ERC165 standard, as defined in the
102  * https://eips.ethereum.org/EIPS/eip-165[EIP].
103  *
104  * Implementers can declare support of contract interfaces, which can then be
105  * queried by others ({ERC165Checker}).
106  *
107  * For an implementation, see {ERC165}.
108  */
109 interface IERC165 {
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30 000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 }
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
123 /**
124  * @dev Required interface of an ERC721 compliant contract.
125  */
126 interface IERC721 is IERC165 {
127     /**
128      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
134      */
135     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
139      */
140     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
141 
142     /**
143      * @dev Returns the number of tokens in ``owner``'s account.
144      */
145     function balanceOf(address owner) external view returns (uint256 balance);
146 
147     /**
148      * @dev Returns the owner of the `tokenId` token.
149      *
150      * Requirements:
151      *
152      * - `tokenId` must exist.
153      */
154     function ownerOf(uint256 tokenId) external view returns (address owner);
155 
156     /**
157      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
158      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
159      *
160      * Requirements:
161      *
162      * - `from` cannot be the zero address.
163      * - `to` cannot be the zero address.
164      * - `tokenId` token must exist and be owned by `from`.
165      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
167      *
168      * Emits a {Transfer} event.
169      */
170     function safeTransferFrom(
171         address from,
172         address to,
173         uint256 tokenId
174     ) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 tokenId
194     ) external;
195 
196     /**
197      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
198      * The approval is cleared when the token is transferred.
199      *
200      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
201      *
202      * Requirements:
203      *
204      * - The caller must own the token or be an approved operator.
205      * - `tokenId` must exist.
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address to, uint256 tokenId) external;
210 
211     /**
212      * @dev Returns the account approved for `tokenId` token.
213      *
214      * Requirements:
215      *
216      * - `tokenId` must exist.
217      */
218     function getApproved(uint256 tokenId) external view returns (address operator);
219 
220     /**
221      * @dev Approve or remove `operator` as an operator for the caller.
222      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
223      *
224      * Requirements:
225      *
226      * - The `operator` cannot be the caller.
227      *
228      * Emits an {ApprovalForAll} event.
229      */
230     function setApprovalForAll(address operator, bool _approved) external;
231 
232     /**
233      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
234      *
235      * See {setApprovalForAll}
236      */
237     function isApprovedForAll(address owner, address operator) external view returns (bool);
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes calldata data
257     ) external;
258 }
259 
260 
261 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
262 /**
263  * @title ERC721 token receiver interface
264  * @dev Interface for any contract that wants to support safeTransfers
265  * from ERC721 asset contracts.
266  */
267 interface IERC721Receiver {
268     /**
269      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
270      * by `operator` from `from`, this function is called.
271      *
272      * It must return its Solidity selector to confirm the token transfer.
273      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
274      *
275      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
276      */
277     function onERC721Received(
278         address operator,
279         address from,
280         uint256 tokenId,
281         bytes calldata data
282     ) external returns (bytes4);
283 }
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
287 /**
288  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
289  * @dev See https://eips.ethereum.org/EIPS/eip-721
290  */
291 interface IERC721Metadata is IERC721 {
292     /**
293      * @dev Returns the token collection name.
294      */
295     function name() external view returns (string memory);
296 
297     /**
298      * @dev Returns the token collection symbol.
299      */
300     function symbol() external view returns (string memory);
301 
302     /**
303      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
304      */
305     function tokenURI(uint256 tokenId) external view returns (string memory);
306 }
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * [IMPORTANT]
318      * ====
319      * It is unsafe to assume that an address for which this function returns
320      * false is an externally-owned account (EOA) and not a contract.
321      *
322      * Among others, `isContract` will return false for the following
323      * types of addresses:
324      *
325      *  - an externally-owned account
326      *  - a contract in construction
327      *  - an address where a contract will be created
328      *  - an address where a contract lived, but was destroyed
329      * ====
330      */
331     function isContract(address account) internal view returns (bool) {
332         // This method relies on extcodesize, which returns 0 for contracts in
333         // construction, since the code is only stored at the end of the
334         // constructor execution.
335 
336         uint256 size;
337         assembly {
338             size := extcodesize(account)
339         }
340         return size > 0;
341     }
342 
343     /**
344      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
345      * `recipient`, forwarding all available gas and reverting on errors.
346      *
347      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
348      * of certain opcodes, possibly making contracts go over the 2300 gas limit
349      * imposed by `transfer`, making them unable to receive funds via
350      * `transfer`. {sendValue} removes this limitation.
351      *
352      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
353      *
354      * IMPORTANT: because control is transferred to `recipient`, care must be
355      * taken to not create reentrancy vulnerabilities. Consider using
356      * {ReentrancyGuard} or the
357      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
358      */
359     function sendValue(address payable recipient, uint256 amount) internal {
360         require(address(this).balance >= amount, "Address: insufficient balance");
361 
362         (bool success, ) = recipient.call{value: amount}("");
363         require(success, "Address: unable to send value, recipient may have reverted");
364     }
365 
366     /**
367      * @dev Performs a Solidity function call using a low level `call`. A
368      * plain `call` is an unsafe replacement for a function call: use this
369      * function instead.
370      *
371      * If `target` reverts with a revert reason, it is bubbled up by this
372      * function (like regular Solidity function calls).
373      *
374      * Returns the raw returned data. To convert to the expected return value,
375      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
376      *
377      * Requirements:
378      *
379      * - `target` must be a contract.
380      * - calling `target` with `data` must not revert.
381      *
382      * _Available since v3.1._
383      */
384     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionCall(target, data, "Address: low-level call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
390      * `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, 0, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but also transferring `value` wei to `target`.
405      *
406      * Requirements:
407      *
408      * - the calling contract must have an ETH balance of at least `value`.
409      * - the called Solidity function must be `payable`.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value
417     ) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
423      * with `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 value,
431         string memory errorMessage
432     ) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         require(isContract(target), "Address: call to non-contract");
435 
436         (bool success, bytes memory returndata) = target.call{value: value}(data);
437         return verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but performing a static call.
443      *
444      * _Available since v3.3._
445      */
446     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
447         return functionStaticCall(target, data, "Address: low-level static call failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal view returns (bytes memory) {
461         require(isContract(target), "Address: static call to non-contract");
462 
463         (bool success, bytes memory returndata) = target.staticcall(data);
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a delegate call.
470      *
471      * _Available since v3.4._
472      */
473     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
474         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(
484         address target,
485         bytes memory data,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(isContract(target), "Address: delegate call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.delegatecall(data);
491         return verifyCallResult(success, returndata, errorMessage);
492     }
493 
494     /**
495      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
496      * revert reason using the provided one.
497      *
498      * _Available since v4.3._
499      */
500     function verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) internal pure returns (bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511 
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
525 /**
526  * @dev String operations.
527  */
528 library Strings {
529     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
530 
531     /**
532      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
533      */
534     function toString(uint256 value) internal pure returns (string memory) {
535         // Inspired by OraclizeAPI's implementation - MIT licence
536         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
537 
538         if (value == 0) {
539             return "0";
540         }
541         uint256 temp = value;
542         uint256 digits;
543         while (temp != 0) {
544             digits++;
545             temp /= 10;
546         }
547         bytes memory buffer = new bytes(digits);
548         while (value != 0) {
549             digits -= 1;
550             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
551             value /= 10;
552         }
553         return string(buffer);
554     }
555 
556     /**
557      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
558      */
559     function toHexString(uint256 value) internal pure returns (string memory) {
560         if (value == 0) {
561             return "0x00";
562         }
563         uint256 temp = value;
564         uint256 length = 0;
565         while (temp != 0) {
566             length++;
567             temp >>= 8;
568         }
569         return toHexString(value, length);
570     }
571 
572     /**
573      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
574      */
575     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
576         bytes memory buffer = new bytes(2 * length + 2);
577         buffer[0] = "0";
578         buffer[1] = "x";
579         for (uint256 i = 2 * length + 1; i > 1; --i) {
580             buffer[i] = _HEX_SYMBOLS[value & 0xf];
581             value >>= 4;
582         }
583         require(value == 0, "Strings: hex length insufficient");
584         return string(buffer);
585     }
586 }
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
590 /**
591  * @dev Implementation of the {IERC165} interface.
592  *
593  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
594  * for the additional interface id that will be supported. For example:
595  *
596  * ```solidity
597  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
598  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
599  * }
600  * ```
601  *
602  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
603  */
604 abstract contract ERC165 is IERC165 {
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
609         return interfaceId == type(IERC165).interfaceId;
610     }
611 }
612 
613 
614 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
615 /**
616  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
617  * the Metadata extension, but not including the Enumerable extension, which is available separately as
618  * {ERC721Enumerable}.
619  */
620 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
621     using Address for address;
622     using Strings for uint256;
623 
624     // Token name
625     string private _name;
626 
627     // Token symbol
628     string private _symbol;
629 
630     // Mapping from token ID to owner address
631     mapping(uint256 => address) private _owners;
632 
633     // Mapping owner address to token count
634     mapping(address => uint256) private _balances;
635 
636     // Mapping from token ID to approved address
637     mapping(uint256 => address) private _tokenApprovals;
638 
639     // Mapping from owner to operator approvals
640     mapping(address => mapping(address => bool)) private _operatorApprovals;
641 
642     /**
643      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
644      */
645     constructor(string memory name_, string memory symbol_) {
646         _name = name_;
647         _symbol = symbol_;
648     }
649 
650     /**
651      * @dev See {IERC165-supportsInterface}.
652      */
653     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
654         return
655             interfaceId == type(IERC721).interfaceId ||
656             interfaceId == type(IERC721Metadata).interfaceId ||
657             super.supportsInterface(interfaceId);
658     }
659 
660     /**
661      * @dev See {IERC721-balanceOf}.
662      */
663     function balanceOf(address owner) public view virtual override returns (uint256) {
664         require(owner != address(0), "ERC721: balance query for the zero address");
665         return _balances[owner];
666     }
667 
668     /**
669      * @dev See {IERC721-ownerOf}.
670      */
671     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
672         address owner = _owners[tokenId];
673         require(owner != address(0), "ERC721: owner query for nonexistent token");
674         return owner;
675     }
676 
677     /**
678      * @dev See {IERC721Metadata-name}.
679      */
680     function name() public view virtual override returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-symbol}.
686      */
687     function symbol() public view virtual override returns (string memory) {
688         return _symbol;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-tokenURI}.
693      */
694     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
695         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
696 
697         string memory baseURI = _baseURI();
698         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
699     }
700 
701     /**
702      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
703      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
704      * by default, can be overriden in child contracts.
705      */
706     function _baseURI() internal view virtual returns (string memory) {
707         return "";
708     }
709 
710     /**
711      * @dev See {IERC721-approve}.
712      */
713     function approve(address to, uint256 tokenId) public virtual override {
714         address owner = ERC721.ownerOf(tokenId);
715         require(to != owner, "ERC721: approval to current owner");
716 
717         require(
718             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
719             "ERC721: approve caller is not owner nor approved for all"
720         );
721 
722         _approve(to, tokenId);
723     }
724 
725     /**
726      * @dev See {IERC721-getApproved}.
727      */
728     function getApproved(uint256 tokenId) public view virtual override returns (address) {
729         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
730 
731         return _tokenApprovals[tokenId];
732     }
733 
734     /**
735      * @dev See {IERC721-setApprovalForAll}.
736      */
737     function setApprovalForAll(address operator, bool approved) public virtual override {
738         _setApprovalForAll(_msgSender(), operator, approved);
739     }
740 
741     /**
742      * @dev See {IERC721-isApprovedForAll}.
743      */
744     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
745         return _operatorApprovals[owner][operator];
746     }
747 
748     /**
749      * @dev See {IERC721-transferFrom}.
750      */
751     function transferFrom(
752         address from,
753         address to,
754         uint256 tokenId
755     ) public virtual override {
756         //solhint-disable-next-line max-line-length
757         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
758 
759         _transfer(from, to, tokenId);
760     }
761 
762     /**
763      * @dev See {IERC721-safeTransferFrom}.
764      */
765     function safeTransferFrom(
766         address from,
767         address to,
768         uint256 tokenId
769     ) public virtual override {
770         safeTransferFrom(from, to, tokenId, "");
771     }
772 
773     /**
774      * @dev See {IERC721-safeTransferFrom}.
775      */
776     function safeTransferFrom(
777         address from,
778         address to,
779         uint256 tokenId,
780         bytes memory _data
781     ) public virtual override {
782         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
783         _safeTransfer(from, to, tokenId, _data);
784     }
785 
786     /**
787      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
788      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
789      *
790      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
791      *
792      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
793      * implement alternative mechanisms to perform token transfer, such as signature-based.
794      *
795      * Requirements:
796      *
797      * - `from` cannot be the zero address.
798      * - `to` cannot be the zero address.
799      * - `tokenId` token must exist and be owned by `from`.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function _safeTransfer(
805         address from,
806         address to,
807         uint256 tokenId,
808         bytes memory _data
809     ) internal virtual {
810         _transfer(from, to, tokenId);
811         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
812     }
813 
814     /**
815      * @dev Returns whether `tokenId` exists.
816      *
817      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
818      *
819      * Tokens start existing when they are minted (`_mint`),
820      * and stop existing when they are burned (`_burn`).
821      */
822     function _exists(uint256 tokenId) internal view virtual returns (bool) {
823         return _owners[tokenId] != address(0);
824     }
825 
826     /**
827      * @dev Returns whether `spender` is allowed to manage `tokenId`.
828      *
829      * Requirements:
830      *
831      * - `tokenId` must exist.
832      */
833     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
834         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
835         address owner = ERC721.ownerOf(tokenId);
836         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
837     }
838 
839     /**
840      * @dev Safely mints `tokenId` and transfers it to `to`.
841      *
842      * Requirements:
843      *
844      * - `tokenId` must not exist.
845      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
846      *
847      * Emits a {Transfer} event.
848      */
849     function _safeMint(address to, uint256 tokenId) internal virtual {
850         _safeMint(to, tokenId, "");
851     }
852 
853     /**
854      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
855      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
856      */
857     function _safeMint(
858         address to,
859         uint256 tokenId,
860         bytes memory _data
861     ) internal virtual {
862         _mint(to, tokenId);
863         require(
864             _checkOnERC721Received(address(0), to, tokenId, _data),
865             "ERC721: transfer to non ERC721Receiver implementer"
866         );
867     }
868 
869     /**
870      * @dev Mints `tokenId` and transfers it to `to`.
871      *
872      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
873      *
874      * Requirements:
875      *
876      * - `tokenId` must not exist.
877      * - `to` cannot be the zero address.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _mint(address to, uint256 tokenId) internal virtual {
882         require(to != address(0), "ERC721: mint to the zero address");
883         require(!_exists(tokenId), "ERC721: token already minted");
884 
885         _beforeTokenTransfer(address(0), to, tokenId);
886 
887         _balances[to] += 1;
888         _owners[tokenId] = to;
889 
890         emit Transfer(address(0), to, tokenId);
891     }
892 
893     /**
894      * @dev Destroys `tokenId`.
895      * The approval is cleared when the token is burned.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _burn(uint256 tokenId) internal virtual {
904         address owner = ERC721.ownerOf(tokenId);
905 
906         _beforeTokenTransfer(owner, address(0), tokenId);
907 
908         // Clear approvals
909         _approve(address(0), tokenId);
910 
911         _balances[owner] -= 1;
912         delete _owners[tokenId];
913 
914         emit Transfer(owner, address(0), tokenId);
915     }
916 
917     /**
918      * @dev Transfers `tokenId` from `from` to `to`.
919      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
920      *
921      * Requirements:
922      *
923      * - `to` cannot be the zero address.
924      * - `tokenId` token must be owned by `from`.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _transfer(
929         address from,
930         address to,
931         uint256 tokenId
932     ) internal virtual {
933         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
934         require(to != address(0), "ERC721: transfer to the zero address");
935 
936         _beforeTokenTransfer(from, to, tokenId);
937 
938         // Clear approvals from the previous owner
939         _approve(address(0), tokenId);
940 
941         _balances[from] -= 1;
942         _balances[to] += 1;
943         _owners[tokenId] = to;
944 
945         emit Transfer(from, to, tokenId);
946     }
947 
948     /**
949      * @dev Approve `to` to operate on `tokenId`
950      *
951      * Emits a {Approval} event.
952      */
953     function _approve(address to, uint256 tokenId) internal virtual {
954         _tokenApprovals[tokenId] = to;
955         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
956     }
957 
958     /**
959      * @dev Approve `operator` to operate on all of `owner` tokens
960      *
961      * Emits a {ApprovalForAll} event.
962      */
963     function _setApprovalForAll(
964         address owner,
965         address operator,
966         bool approved
967     ) internal virtual {
968         require(owner != operator, "ERC721: approve to caller");
969         _operatorApprovals[owner][operator] = approved;
970         emit ApprovalForAll(owner, operator, approved);
971     }
972 
973     /**
974      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
975      * The call is not executed if the target address is not a contract.
976      *
977      * @param from address representing the previous owner of the given token ID
978      * @param to target address that will receive the tokens
979      * @param tokenId uint256 ID of the token to be transferred
980      * @param _data bytes optional data to send along with the call
981      * @return bool whether the call correctly returned the expected magic value
982      */
983     function _checkOnERC721Received(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) private returns (bool) {
989         if (to.isContract()) {
990             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
991                 return retval == IERC721Receiver.onERC721Received.selector;
992             } catch (bytes memory reason) {
993                 if (reason.length == 0) {
994                     revert("ERC721: transfer to non ERC721Receiver implementer");
995                 } else {
996                     assembly {
997                         revert(add(32, reason), mload(reason))
998                     }
999                 }
1000             }
1001         } else {
1002             return true;
1003         }
1004     }
1005 
1006     /**
1007      * @dev Hook that is called before any token transfer. This includes minting
1008      * and burning.
1009      *
1010      * Calling conditions:
1011      *
1012      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1013      * transferred to `to`.
1014      * - When `from` is zero, `tokenId` will be minted for `to`.
1015      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1016      * - `from` and `to` are never both zero.
1017      *
1018      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1019      */
1020     function _beforeTokenTransfer(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) internal virtual {}
1025 }
1026 
1027 
1028 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1029 /**
1030  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1031  * @dev See https://eips.ethereum.org/EIPS/eip-721
1032  */
1033 interface IERC721Enumerable is IERC721 {
1034     /**
1035      * @dev Returns the total amount of tokens stored by the contract.
1036      */
1037     function totalSupply() external view returns (uint256);
1038 
1039     /**
1040      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1041      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1042      */
1043     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1044 
1045     /**
1046      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1047      * Use along with {totalSupply} to enumerate all tokens.
1048      */
1049     function tokenByIndex(uint256 index) external view returns (uint256);
1050 }
1051 
1052 
1053 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
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
1158      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
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
1211 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1212 /**
1213  * @dev Contract module which allows children to implement an emergency stop
1214  * mechanism that can be triggered by an authorized account.
1215  *
1216  * This module is used through inheritance. It will make available the
1217  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1218  * the functions of your contract. Note that they will not be pausable by
1219  * simply including this module, only once the modifiers are put in place.
1220  */
1221 abstract contract Pausable is Context {
1222     /**
1223      * @dev Emitted when the pause is triggered by `account`.
1224      */
1225     event Paused(address account);
1226 
1227     /**
1228      * @dev Emitted when the pause is lifted by `account`.
1229      */
1230     event Unpaused(address account);
1231 
1232     bool private _paused;
1233 
1234     /**
1235      * @dev Initializes the contract in unpaused state.
1236      */
1237     constructor() {
1238         _paused = false;
1239     }
1240 
1241     /**
1242      * @dev Returns true if the contract is paused, and false otherwise.
1243      */
1244     function paused() public view virtual returns (bool) {
1245         return _paused;
1246     }
1247 
1248     /**
1249      * @dev Modifier to make a function callable only when the contract is not paused.
1250      *
1251      * Requirements:
1252      *
1253      * - The contract must not be paused.
1254      */
1255     modifier whenNotPaused() {
1256         require(!paused(), "Pausable: paused");
1257         _;
1258     }
1259 
1260     /**
1261      * @dev Modifier to make a function callable only when the contract is paused.
1262      *
1263      * Requirements:
1264      *
1265      * - The contract must be paused.
1266      */
1267     modifier whenPaused() {
1268         require(paused(), "Pausable: not paused");
1269         _;
1270     }
1271 
1272     /**
1273      * @dev Triggers stopped state.
1274      *
1275      * Requirements:
1276      *
1277      * - The contract must not be paused.
1278      */
1279     function _pause() internal virtual whenNotPaused {
1280         _paused = true;
1281         emit Paused(_msgSender());
1282     }
1283 
1284     /**
1285      * @dev Returns to normal state.
1286      *
1287      * Requirements:
1288      *
1289      * - The contract must be paused.
1290      */
1291     function _unpause() internal virtual whenPaused {
1292         _paused = false;
1293         emit Unpaused(_msgSender());
1294     }
1295 }
1296 
1297 
1298 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1299 /**
1300  * @dev External interface of AccessControl declared to support ERC165 detection.
1301  */
1302 interface IAccessControl {
1303     /**
1304      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1305      *
1306      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1307      * {RoleAdminChanged} not being emitted signaling this.
1308      *
1309      * _Available since v3.1._
1310      */
1311     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1312 
1313     /**
1314      * @dev Emitted when `account` is granted `role`.
1315      *
1316      * `sender` is the account that originated the contract call, an admin role
1317      * bearer except when using {AccessControl-_setupRole}.
1318      */
1319     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1320 
1321     /**
1322      * @dev Emitted when `account` is revoked `role`.
1323      *
1324      * `sender` is the account that originated the contract call:
1325      *   - if using `revokeRole`, it is the admin role bearer
1326      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1327      */
1328     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1329 
1330     /**
1331      * @dev Returns `true` if `account` has been granted `role`.
1332      */
1333     function hasRole(bytes32 role, address account) external view returns (bool);
1334 
1335     /**
1336      * @dev Returns the admin role that controls `role`. See {grantRole} and
1337      * {revokeRole}.
1338      *
1339      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1340      */
1341     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1342 
1343     /**
1344      * @dev Grants `role` to `account`.
1345      *
1346      * If `account` had not been already granted `role`, emits a {RoleGranted}
1347      * event.
1348      *
1349      * Requirements:
1350      *
1351      * - the caller must have ``role``'s admin role.
1352      */
1353     function grantRole(bytes32 role, address account) external;
1354 
1355     /**
1356      * @dev Revokes `role` from `account`.
1357      *
1358      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1359      *
1360      * Requirements:
1361      *
1362      * - the caller must have ``role``'s admin role.
1363      */
1364     function revokeRole(bytes32 role, address account) external;
1365 
1366     /**
1367      * @dev Revokes `role` from the calling account.
1368      *
1369      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1370      * purpose is to provide a mechanism for accounts to lose their privileges
1371      * if they are compromised (such as when a trusted device is misplaced).
1372      *
1373      * If the calling account had been granted `role`, emits a {RoleRevoked}
1374      * event.
1375      *
1376      * Requirements:
1377      *
1378      * - the caller must be `account`.
1379      */
1380     function renounceRole(bytes32 role, address account) external;
1381 }
1382 
1383 
1384 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
1385 /**
1386  * @dev Contract module that allows children to implement role-based access
1387  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1388  * members except through off-chain means by accessing the contract event logs. Some
1389  * applications may benefit from on-chain enumerability, for those cases see
1390  * {AccessControlEnumerable}.
1391  *
1392  * Roles are referred to by their `bytes32` identifier. These should be exposed
1393  * in the external API and be unique. The best way to achieve this is by
1394  * using `public constant` hash digests:
1395  *
1396  * ```
1397  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1398  * ```
1399  *
1400  * Roles can be used to represent a set of permissions. To restrict access to a
1401  * function call, use {hasRole}:
1402  *
1403  * ```
1404  * function foo() public {
1405  *     require(hasRole(MY_ROLE, msg.sender));
1406  *     ...
1407  * }
1408  * ```
1409  *
1410  * Roles can be granted and revoked dynamically via the {grantRole} and
1411  * {revokeRole} functions. Each role has an associated admin role, and only
1412  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1413  *
1414  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1415  * that only accounts with this role will be able to grant or revoke other
1416  * roles. More complex role relationships can be created by using
1417  * {_setRoleAdmin}.
1418  *
1419  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1420  * grant and revoke this role. Extra precautions should be taken to secure
1421  * accounts that have been granted it.
1422  */
1423 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1424     struct RoleData {
1425         mapping(address => bool) members;
1426         bytes32 adminRole;
1427     }
1428 
1429     mapping(bytes32 => RoleData) private _roles;
1430 
1431     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1432 
1433     /**
1434      * @dev Modifier that checks that an account has a specific role. Reverts
1435      * with a standardized message including the required role.
1436      *
1437      * The format of the revert reason is given by the following regular expression:
1438      *
1439      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1440      *
1441      * _Available since v4.1._
1442      */
1443     modifier onlyRole(bytes32 role) {
1444         _checkRole(role, _msgSender());
1445         _;
1446     }
1447 
1448     /**
1449      * @dev See {IERC165-supportsInterface}.
1450      */
1451     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1452         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1453     }
1454 
1455     /**
1456      * @dev Returns `true` if `account` has been granted `role`.
1457      */
1458     function hasRole(bytes32 role, address account) public view override returns (bool) {
1459         return _roles[role].members[account];
1460     }
1461 
1462     /**
1463      * @dev Revert with a standard message if `account` is missing `role`.
1464      *
1465      * The format of the revert reason is given by the following regular expression:
1466      *
1467      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1468      */
1469     function _checkRole(bytes32 role, address account) internal view {
1470         if (!hasRole(role, account)) {
1471             revert(
1472                 string(
1473                     abi.encodePacked(
1474                         "AccessControl: account ",
1475                         Strings.toHexString(uint160(account), 20),
1476                         " is missing role ",
1477                         Strings.toHexString(uint256(role), 32)
1478                     )
1479                 )
1480             );
1481         }
1482     }
1483 
1484     /**
1485      * @dev Returns the admin role that controls `role`. See {grantRole} and
1486      * {revokeRole}.
1487      *
1488      * To change a role's admin, use {_setRoleAdmin}.
1489      */
1490     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
1491         return _roles[role].adminRole;
1492     }
1493 
1494     /**
1495      * @dev Grants `role` to `account`.
1496      *
1497      * If `account` had not been already granted `role`, emits a {RoleGranted}
1498      * event.
1499      *
1500      * Requirements:
1501      *
1502      * - the caller must have ``role``'s admin role.
1503      */
1504     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1505         _grantRole(role, account);
1506     }
1507 
1508     /**
1509      * @dev Revokes `role` from `account`.
1510      *
1511      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1512      *
1513      * Requirements:
1514      *
1515      * - the caller must have ``role``'s admin role.
1516      */
1517     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1518         _revokeRole(role, account);
1519     }
1520 
1521     /**
1522      * @dev Revokes `role` from the calling account.
1523      *
1524      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1525      * purpose is to provide a mechanism for accounts to lose their privileges
1526      * if they are compromised (such as when a trusted device is misplaced).
1527      *
1528      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1529      * event.
1530      *
1531      * Requirements:
1532      *
1533      * - the caller must be `account`.
1534      */
1535     function renounceRole(bytes32 role, address account) public virtual override {
1536         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1537 
1538         _revokeRole(role, account);
1539     }
1540 
1541     /**
1542      * @dev Grants `role` to `account`.
1543      *
1544      * If `account` had not been already granted `role`, emits a {RoleGranted}
1545      * event. Note that unlike {grantRole}, this function doesn't perform any
1546      * checks on the calling account.
1547      *
1548      * [WARNING]
1549      * ====
1550      * This function should only be called from the constructor when setting
1551      * up the initial roles for the system.
1552      *
1553      * Using this function in any other way is effectively circumventing the admin
1554      * system imposed by {AccessControl}.
1555      * ====
1556      *
1557      * NOTE: This function is deprecated in favor of {_grantRole}.
1558      */
1559     function _setupRole(bytes32 role, address account) internal virtual {
1560         _grantRole(role, account);
1561     }
1562 
1563     /**
1564      * @dev Sets `adminRole` as ``role``'s admin role.
1565      *
1566      * Emits a {RoleAdminChanged} event.
1567      */
1568     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1569         bytes32 previousAdminRole = getRoleAdmin(role);
1570         _roles[role].adminRole = adminRole;
1571         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1572     }
1573 
1574     /**
1575      * @dev Grants `role` to `account`.
1576      *
1577      * Internal function without access restriction.
1578      */
1579     function _grantRole(bytes32 role, address account) internal virtual {
1580         if (!hasRole(role, account)) {
1581             _roles[role].members[account] = true;
1582             emit RoleGranted(role, account, _msgSender());
1583         }
1584     }
1585 
1586     /**
1587      * @dev Revokes `role` from `account`.
1588      *
1589      * Internal function without access restriction.
1590      */
1591     function _revokeRole(bytes32 role, address account) internal virtual {
1592         if (hasRole(role, account)) {
1593             _roles[role].members[account] = false;
1594             emit RoleRevoked(role, account, _msgSender());
1595         }
1596     }
1597 }
1598 
1599 
1600 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1601 /**
1602  * @title Counters
1603  * @author Matt Condon (@shrugs)
1604  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1605  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1606  *
1607  * Include with `using Counters for Counters.Counter;`
1608  */
1609 library Counters {
1610     struct Counter {
1611         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1612         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1613         // this feature: see https://github.com/ethereum/solidity/issues/4637
1614         uint256 _value; // default: 0
1615     }
1616 
1617     function current(Counter storage counter) internal view returns (uint256) {
1618         return counter._value;
1619     }
1620 
1621     function increment(Counter storage counter) internal {
1622         unchecked {
1623             counter._value += 1;
1624         }
1625     }
1626 
1627     function decrement(Counter storage counter) internal {
1628         uint256 value = counter._value;
1629         require(value > 0, "Counter: decrement overflow");
1630         unchecked {
1631             counter._value = value - 1;
1632         }
1633     }
1634 
1635     function reset(Counter storage counter) internal {
1636         counter._value = 0;
1637     }
1638 }
1639 
1640 
1641 contract LuckyChonks is ERC721, ERC721Enumerable, Pausable, AccessControl {
1642   using Counters for Counters.Counter;
1643 
1644   bytes32 public constant PAUSER_ROLE = keccak256('PAUSER_ROLE');
1645   bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
1646   Counters.Counter private _tokenIdCounter;
1647 
1648   constructor() ERC721('Lucky Chonks', 'LuckyChonks') {
1649     _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1650     _grantRole(PAUSER_ROLE, msg.sender);
1651     _grantRole(MINTER_ROLE, msg.sender);
1652   }
1653 
1654   function _baseURI() internal pure override returns (string memory) {
1655     return 'https://luckychonks.com/metadata/';
1656   }
1657 
1658   function pause() public onlyRole(PAUSER_ROLE) {
1659     _pause();
1660   }
1661 
1662   function unpause() public onlyRole(PAUSER_ROLE) {
1663     _unpause();
1664   }
1665 
1666   function safeMint(address to) public onlyRole(MINTER_ROLE) {
1667     uint256 tokenId = _tokenIdCounter.current();
1668     _tokenIdCounter.increment();
1669     _safeMint(to, tokenId);
1670   }
1671 
1672   function _beforeTokenTransfer(
1673     address from,
1674     address to,
1675     uint256 tokenId
1676   ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1677     super._beforeTokenTransfer(from, to, tokenId);
1678   }
1679 
1680   // The following functions are overrides required by Solidity.
1681 
1682   function supportsInterface(bytes4 interfaceId)
1683     public
1684     view
1685     override(ERC721, ERC721Enumerable, AccessControl)
1686     returns (bool)
1687   {
1688     return super.supportsInterface(interfaceId);
1689   }
1690 }
1691 
1692 
1693 contract Minter is Ownable {
1694   uint256 public BASE_PRICE = 0.05 ether;
1695   uint256 public constant MAX_PER_WALLET = 5;
1696   uint256 public constant MAX_CHONKS = 888;
1697   uint256 public constant FREE_MINT = 444;
1698 
1699   LuckyChonks private luckyChonks;
1700   address private luckyChonksAddress;
1701 
1702   event Log(uint256 amount, uint256 gas);
1703   event ResultsFromCall(bool success, bytes data);
1704 
1705   constructor(address payable _luckyChonksAddress) {
1706     luckyChonksAddress = _luckyChonksAddress;
1707     luckyChonks = LuckyChonks(_luckyChonksAddress);
1708   }
1709 
1710   receive() external payable {}
1711 
1712   fallback() external payable {}
1713 
1714   function getBalance() public view returns (uint256) {
1715     return address(this).balance;
1716   }
1717 
1718   function mint(address to) public payable {
1719     require(luckyChonks.totalSupply() < MAX_CHONKS, 'No more left to mint');
1720     require(luckyChonks.balanceOf(to) < MAX_PER_WALLET, 'You have minted your wallet limit');
1721 
1722     if (luckyChonks.totalSupply() < FREE_MINT) {
1723       // free minting
1724       luckyChonks.safeMint(to);
1725     } else {
1726       require(msg.value >= BASE_PRICE, 'Need to send more ether');
1727       luckyChonks.safeMint(to);
1728     }
1729 
1730     emit Log(msg.value, gasleft());
1731   }
1732 
1733   function batchMint(address to, uint256 batchMintAmt) public payable {
1734     // no free minting for batch
1735 
1736     require((luckyChonks.totalSupply() + batchMintAmt) <= MAX_CHONKS, 'No more left to mint');
1737     require((luckyChonks.balanceOf(to) + batchMintAmt) <= MAX_PER_WALLET, 'You have minted your wallet limit');
1738     require(msg.value >= (BASE_PRICE * batchMintAmt), 'Need to send more ether');
1739 
1740     for (uint256 index = 0; index < batchMintAmt; index++) {
1741       luckyChonks.safeMint(to);
1742     }
1743 
1744     emit Log(msg.value, gasleft());
1745   }
1746 
1747   function withdraw() external onlyOwner {
1748     uint256 balance = address(this).balance;
1749     require(balance > 0, 'No ether left to withdraw');
1750 
1751     (bool success, bytes memory data) = (msg.sender).call{value: balance}('');
1752     require(success, 'Withdrawal failed');
1753     emit ResultsFromCall(success, data);
1754   }
1755 
1756   function setContractAddress(address payable _address) external onlyOwner {
1757     luckyChonksAddress = _address;
1758     luckyChonks = LuckyChonks(_address);
1759   }
1760 
1761   function setBasePrice(uint256 _basePrice) public onlyOwner {
1762     BASE_PRICE = _basePrice;
1763   }
1764 }