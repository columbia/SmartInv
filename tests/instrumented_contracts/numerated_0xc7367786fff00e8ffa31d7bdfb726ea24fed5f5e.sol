1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Implementation of the {IERC165} interface.
28  *
29  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
30  * for the additional interface id that will be supported. For example:
31  *
32  * ```solidity
33  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
34  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
35  * }
36  * ```
37  *
38  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
39  */
40 abstract contract ERC165 is IERC165 {
41     /**
42      * @dev See {IERC165-supportsInterface}.
43      */
44     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45         return interfaceId == type(IERC165).interfaceId;
46     }
47 }
48 
49 /**
50  * @dev String operations.
51  */
52 library Strings {
53     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
57      */
58     function toString(uint256 value) internal pure returns (string memory) {
59         // Inspired by OraclizeAPI's implementation - MIT licence
60         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
61 
62         if (value == 0) {
63             return "0";
64         }
65         uint256 temp = value;
66         uint256 digits;
67         while (temp != 0) {
68             digits++;
69             temp /= 10;
70         }
71         bytes memory buffer = new bytes(digits);
72         while (value != 0) {
73             digits -= 1;
74             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
75             value /= 10;
76         }
77         return string(buffer);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
82      */
83     function toHexString(uint256 value) internal pure returns (string memory) {
84         if (value == 0) {
85             return "0x00";
86         }
87         uint256 temp = value;
88         uint256 length = 0;
89         while (temp != 0) {
90             length++;
91             temp >>= 8;
92         }
93         return toHexString(value, length);
94     }
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
98      */
99     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
100         bytes memory buffer = new bytes(2 * length + 2);
101         buffer[0] = "0";
102         buffer[1] = "x";
103         for (uint256 i = 2 * length + 1; i > 1; --i) {
104             buffer[i] = _HEX_SYMBOLS[value & 0xf];
105             value >>= 4;
106         }
107         require(value == 0, "Strings: hex length insufficient");
108         return string(buffer);
109     }
110 }
111 
112 /**
113  * @dev Provides information about the current execution context, including the
114  * sender of the transaction and its data. While these are generally available
115  * via msg.sender and msg.data, they should not be accessed in such a direct
116  * manner, since when dealing with meta-transactions the account sending and
117  * paying for execution may not be the actual sender (as far as an application
118  * is concerned).
119  *
120  * This contract is only required for intermediate, library-like contracts.
121  */
122 abstract contract Context {
123     function _msgSender() internal view virtual returns (address) {
124         return msg.sender;
125     }
126 
127     function _msgData() internal view virtual returns (bytes calldata) {
128         return msg.data;
129     }
130 }
131 
132 /**
133  * @dev Collection of functions related to the address type
134  */
135 library Address {
136     /**
137      * @dev Returns true if `account` is a contract.
138      *
139      * [IMPORTANT]
140      * ====
141      * It is unsafe to assume that an address for which this function returns
142      * false is an externally-owned account (EOA) and not a contract.
143      *
144      * Among others, `isContract` will return false for the following
145      * types of addresses:
146      *
147      *  - an externally-owned account
148      *  - a contract in construction
149      *  - an address where a contract will be created
150      *  - an address where a contract lived, but was destroyed
151      * ====
152      */
153     function isContract(address account) internal view returns (bool) {
154         // This method relies on extcodesize, which returns 0 for contracts in
155         // construction, since the code is only stored at the end of the
156         // constructor execution.
157 
158         uint256 size;
159         assembly {
160             size := extcodesize(account)
161         }
162         return size > 0;
163     }
164 
165     /**
166      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
167      * `recipient`, forwarding all available gas and reverting on errors.
168      *
169      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
170      * of certain opcodes, possibly making contracts go over the 2300 gas limit
171      * imposed by `transfer`, making them unable to receive funds via
172      * `transfer`. {sendValue} removes this limitation.
173      *
174      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
175      *
176      * IMPORTANT: because control is transferred to `recipient`, care must be
177      * taken to not create reentrancy vulnerabilities. Consider using
178      * {ReentrancyGuard} or the
179      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
180      */
181     function sendValue(address payable recipient, uint256 amount) internal {
182         require(address(this).balance >= amount, "Address: insufficient balance");
183 
184         (bool success, ) = recipient.call{value: amount}("");
185         require(success, "Address: unable to send value, recipient may have reverted");
186     }
187 
188     /**
189      * @dev Performs a Solidity function call using a low level `call`. A
190      * plain `call` is an unsafe replacement for a function call: use this
191      * function instead.
192      *
193      * If `target` reverts with a revert reason, it is bubbled up by this
194      * function (like regular Solidity function calls).
195      *
196      * Returns the raw returned data. To convert to the expected return value,
197      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
198      *
199      * Requirements:
200      *
201      * - `target` must be a contract.
202      * - calling `target` with `data` must not revert.
203      *
204      * _Available since v3.1._
205      */
206     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
207         return functionCall(target, data, "Address: low-level call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
212      * `errorMessage` as a fallback revert reason when `target` reverts.
213      *
214      * _Available since v3.1._
215      */
216     function functionCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, 0, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but also transferring `value` wei to `target`.
227      *
228      * Requirements:
229      *
230      * - the calling contract must have an ETH balance of at least `value`.
231      * - the called Solidity function must be `payable`.
232      *
233      * _Available since v3.1._
234      */
235     function functionCallWithValue(
236         address target,
237         bytes memory data,
238         uint256 value
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
245      * with `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(address(this).balance >= value, "Address: insufficient balance for call");
256         require(isContract(target), "Address: call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.call{value: value}(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a static call.
265      *
266      * _Available since v3.3._
267      */
268     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
269         return functionStaticCall(target, data, "Address: low-level static call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
274      * but performing a static call.
275      *
276      * _Available since v3.3._
277      */
278     function functionStaticCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal view returns (bytes memory) {
283         require(isContract(target), "Address: static call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.staticcall(data);
286         return verifyCallResult(success, returndata, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but performing a delegate call.
292      *
293      * _Available since v3.4._
294      */
295     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
301      * but performing a delegate call.
302      *
303      * _Available since v3.4._
304      */
305     function functionDelegateCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         require(isContract(target), "Address: delegate call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.delegatecall(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
318      * revert reason using the provided one.
319      *
320      * _Available since v4.3._
321      */
322     function verifyCallResult(
323         bool success,
324         bytes memory returndata,
325         string memory errorMessage
326     ) internal pure returns (bytes memory) {
327         if (success) {
328             return returndata;
329         } else {
330             // Look for revert reason and bubble it up if present
331             if (returndata.length > 0) {
332                 // The easiest way to bubble the revert reason is using memory via assembly
333 
334                 assembly {
335                     let returndata_size := mload(returndata)
336                     revert(add(32, returndata), returndata_size)
337                 }
338             } else {
339                 revert(errorMessage);
340             }
341         }
342     }
343 }
344 
345 /**
346  * @dev Required interface of an ERC721 compliant contract.
347  */
348 interface IERC721 is IERC165 {
349     /**
350      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
351      */
352     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
353 
354     /**
355      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
356      */
357     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
358 
359     /**
360      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
361      */
362     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
363 
364     /**
365      * @dev Returns the number of tokens in ``owner``'s account.
366      */
367     function balanceOf(address owner) external view returns (uint256 balance);
368 
369     /**
370      * @dev Returns the owner of the `tokenId` token.
371      *
372      * Requirements:
373      *
374      * - `tokenId` must exist.
375      */
376     function ownerOf(uint256 tokenId) external view returns (address owner);
377 
378     /**
379      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
380      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
381      *
382      * Requirements:
383      *
384      * - `from` cannot be the zero address.
385      * - `to` cannot be the zero address.
386      * - `tokenId` token must exist and be owned by `from`.
387      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
388      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
389      *
390      * Emits a {Transfer} event.
391      */
392     function safeTransferFrom(
393         address from,
394         address to,
395         uint256 tokenId
396     ) external;
397 
398     /**
399      * @dev Transfers `tokenId` token from `from` to `to`.
400      *
401      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
402      *
403      * Requirements:
404      *
405      * - `from` cannot be the zero address.
406      * - `to` cannot be the zero address.
407      * - `tokenId` token must be owned by `from`.
408      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(
413         address from,
414         address to,
415         uint256 tokenId
416     ) external;
417 
418     /**
419      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
420      * The approval is cleared when the token is transferred.
421      *
422      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
423      *
424      * Requirements:
425      *
426      * - The caller must own the token or be an approved operator.
427      * - `tokenId` must exist.
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address to, uint256 tokenId) external;
432 
433     /**
434      * @dev Returns the account approved for `tokenId` token.
435      *
436      * Requirements:
437      *
438      * - `tokenId` must exist.
439      */
440     function getApproved(uint256 tokenId) external view returns (address operator);
441 
442     /**
443      * @dev Approve or remove `operator` as an operator for the caller.
444      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
445      *
446      * Requirements:
447      *
448      * - The `operator` cannot be the caller.
449      *
450      * Emits an {ApprovalForAll} event.
451      */
452     function setApprovalForAll(address operator, bool _approved) external;
453 
454     /**
455      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
456      *
457      * See {setApprovalForAll}
458      */
459     function isApprovedForAll(address owner, address operator) external view returns (bool);
460 
461     /**
462      * @dev Safely transfers `tokenId` token from `from` to `to`.
463      *
464      * Requirements:
465      *
466      * - `from` cannot be the zero address.
467      * - `to` cannot be the zero address.
468      * - `tokenId` token must exist and be owned by `from`.
469      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
470      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
471      *
472      * Emits a {Transfer} event.
473      */
474     function safeTransferFrom(
475         address from,
476         address to,
477         uint256 tokenId,
478         bytes calldata data
479     ) external;
480 }
481 
482 /**
483  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
484  * @dev See https://eips.ethereum.org/EIPS/eip-721
485  */
486 interface IERC721Metadata is IERC721 {
487     /**
488      * @dev Returns the token collection name.
489      */
490     function name() external view returns (string memory);
491 
492     /**
493      * @dev Returns the token collection symbol.
494      */
495     function symbol() external view returns (string memory);
496 
497     /**
498      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
499      */
500     function tokenURI(uint256 tokenId) external view returns (string memory);
501 }
502 
503 /**
504  * @title ERC721 token receiver interface
505  * @dev Interface for any contract that wants to support safeTransfers
506  * from ERC721 asset contracts.
507  */
508 interface IERC721Receiver {
509     /**
510      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
511      * by `operator` from `from`, this function is called.
512      *
513      * It must return its Solidity selector to confirm the token transfer.
514      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
515      *
516      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
517      */
518     function onERC721Received(
519         address operator,
520         address from,
521         uint256 tokenId,
522         bytes calldata data
523     ) external returns (bytes4);
524 }
525 
526 
527 /**
528  * @dev Contract module which provides a basic access control mechanism, where
529  * there is an account (an owner) that can be granted exclusive access to
530  * specific functions.
531  *
532  * By default, the owner account will be the one that deploys the contract. This
533  * can later be changed with {transferOwnership}.
534  *
535  * This module is used through inheritance. It will make available the modifier
536  * `onlyOwner`, which can be applied to your functions to restrict their use to
537  * the owner.
538  */
539 abstract contract Ownable is Context {
540     address private _owner;
541 
542     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
543 
544     /**
545      * @dev Initializes the contract setting the deployer as the initial owner.
546      */
547     constructor() {
548         _setOwner(_msgSender());
549     }
550 
551     /**
552      * @dev Returns the address of the current owner.
553      */
554     function owner() public view virtual returns (address) {
555         return _owner;
556     }
557 
558     /**
559      * @dev Throws if called by any account other than the owner.
560      */
561     modifier onlyOwner() {
562         require(owner() == _msgSender(), "Ownable: caller is not the owner");
563         _;
564     }
565 
566     /**
567      * @dev Leaves the contract without owner. It will not be possible to call
568      * `onlyOwner` functions anymore. Can only be called by the current owner.
569      *
570      * NOTE: Renouncing ownership will leave the contract without an owner,
571      * thereby removing any functionality that is only available to the owner.
572      */
573     function renounceOwnership() public virtual onlyOwner {
574         _setOwner(address(0));
575     }
576 
577     /**
578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
579      * Can only be called by the current owner.
580      */
581     function transferOwnership(address newOwner) public virtual onlyOwner {
582         require(newOwner != address(0), "Ownable: new owner is the zero address");
583         _setOwner(newOwner);
584     }
585 
586     function _setOwner(address newOwner) private {
587         address oldOwner = _owner;
588         _owner = newOwner;
589         emit OwnershipTransferred(oldOwner, newOwner);
590     }
591 }
592 
593 /**
594  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
595  * the Metadata extension, but not including the Enumerable extension, which is available separately as
596  * {ERC721Enumerable}.
597  */
598 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
599     using Address for address;
600     using Strings for uint256;
601 
602     // Token name
603     string private _name;
604 
605     // Token symbol
606     string private _symbol;
607 
608     // Mapping from token ID to owner address
609     mapping(uint256 => address) private _owners;
610 
611     // Mapping owner address to token count
612     mapping(address => uint256) private _balances;
613 
614     // Mapping from token ID to approved address
615     mapping(uint256 => address) private _tokenApprovals;
616 
617     // Mapping from owner to operator approvals
618     mapping(address => mapping(address => bool)) private _operatorApprovals;
619 
620     /**
621      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
622      */
623     constructor(string memory name_, string memory symbol_) {
624         _name = name_;
625         _symbol = symbol_;
626     }
627 
628     /**
629      * @dev See {IERC165-supportsInterface}.
630      */
631     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
632         return
633             interfaceId == type(IERC721).interfaceId ||
634             interfaceId == type(IERC721Metadata).interfaceId ||
635             super.supportsInterface(interfaceId);
636     }
637 
638     /**
639      * @dev See {IERC721-balanceOf}.
640      */
641     function balanceOf(address owner) public view virtual override returns (uint256) {
642         require(owner != address(0), "ERC721: balance query for the zero address");
643         return _balances[owner];
644     }
645 
646     /**
647      * @dev See {IERC721-ownerOf}.
648      */
649     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
650         address owner = _owners[tokenId];
651         require(owner != address(0), "ERC721: owner query for nonexistent token");
652         return owner;
653     }
654 
655     /**
656      * @dev See {IERC721Metadata-name}.
657      */
658     function name() public view virtual override returns (string memory) {
659         return _name;
660     }
661 
662     /**
663      * @dev See {IERC721Metadata-symbol}.
664      */
665     function symbol() public view virtual override returns (string memory) {
666         return _symbol;
667     }
668 
669     /**
670      * @dev See {IERC721Metadata-tokenURI}.
671      */
672     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
673         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
674 
675         string memory baseURI = _baseURI();
676         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
677     }
678 
679     /**
680      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
681      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
682      * by default, can be overriden in child contracts.
683      */
684     function _baseURI() internal view virtual returns (string memory) {
685         return "";
686     }
687 
688     /**
689      * @dev See {IERC721-approve}.
690      */
691     function approve(address to, uint256 tokenId) public virtual override {
692         address owner = ERC721.ownerOf(tokenId);
693         require(to != owner, "ERC721: approval to current owner");
694 
695         require(
696             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
697             "ERC721: approve caller is not owner nor approved for all"
698         );
699 
700         _approve(to, tokenId);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view virtual override returns (address) {
707         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public virtual override {
716         require(operator != _msgSender(), "ERC721: approve to caller");
717 
718         _operatorApprovals[_msgSender()][operator] = approved;
719         emit ApprovalForAll(_msgSender(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         //solhint-disable-next-line max-line-length
738         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
739 
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, "");
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
764         _safeTransfer(from, to, tokenId, _data);
765     }
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
772      *
773      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
774      * implement alternative mechanisms to perform token transfer, such as signature-based.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeTransfer(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) internal virtual {
791         _transfer(from, to, tokenId);
792         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
793     }
794 
795     /**
796      * @dev Returns whether `tokenId` exists.
797      *
798      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
799      *
800      * Tokens start existing when they are minted (`_mint`),
801      * and stop existing when they are burned (`_burn`).
802      */
803     function _exists(uint256 tokenId) internal view virtual returns (bool) {
804         return _owners[tokenId] != address(0);
805     }
806 
807     /**
808      * @dev Returns whether `spender` is allowed to manage `tokenId`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
815         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
816         address owner = ERC721.ownerOf(tokenId);
817         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
818     }
819 
820     /**
821      * @dev Safely mints `tokenId` and transfers it to `to`.
822      *
823      * Requirements:
824      *
825      * - `tokenId` must not exist.
826      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
827      *
828      * Emits a {Transfer} event.
829      */
830     function _safeMint(address to, uint256 tokenId) internal virtual {
831         _safeMint(to, tokenId, "");
832     }
833 
834     /**
835      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
836      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
837      */
838     function _safeMint(
839         address to,
840         uint256 tokenId,
841         bytes memory _data
842     ) internal virtual {
843         _mint(to, tokenId);
844         require(
845             _checkOnERC721Received(address(0), to, tokenId, _data),
846             "ERC721: transfer to non ERC721Receiver implementer"
847         );
848     }
849 
850     /**
851      * @dev Mints `tokenId` and transfers it to `to`.
852      *
853      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
854      *
855      * Requirements:
856      *
857      * - `tokenId` must not exist.
858      * - `to` cannot be the zero address.
859      *
860      * Emits a {Transfer} event.
861      */
862     function _mint(address to, uint256 tokenId) internal virtual {
863         require(to != address(0), "ERC721: mint to the zero address");
864         require(!_exists(tokenId), "ERC721: token already minted");
865 
866         _beforeTokenTransfer(address(0), to, tokenId);
867 
868         _balances[to] += 1;
869         _owners[tokenId] = to;
870 
871         emit Transfer(address(0), to, tokenId);
872     }
873 
874     /**
875      * @dev Destroys `tokenId`.
876      * The approval is cleared when the token is burned.
877      *
878      * Requirements:
879      *
880      * - `tokenId` must exist.
881      *
882      * Emits a {Transfer} event.
883      */
884     function _burn(uint256 tokenId) internal virtual {
885         address owner = ERC721.ownerOf(tokenId);
886 
887         _beforeTokenTransfer(owner, address(0), tokenId);
888 
889         // Clear approvals
890         _approve(address(0), tokenId);
891 
892         _balances[owner] -= 1;
893         delete _owners[tokenId];
894 
895         emit Transfer(owner, address(0), tokenId);
896     }
897 
898     /**
899      * @dev Transfers `tokenId` from `from` to `to`.
900      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
901      *
902      * Requirements:
903      *
904      * - `to` cannot be the zero address.
905      * - `tokenId` token must be owned by `from`.
906      *
907      * Emits a {Transfer} event.
908      */
909     function _transfer(
910         address from,
911         address to,
912         uint256 tokenId
913     ) internal virtual {
914         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
915         require(to != address(0), "ERC721: transfer to the zero address");
916 
917         _beforeTokenTransfer(from, to, tokenId);
918 
919         // Clear approvals from the previous owner
920         _approve(address(0), tokenId);
921 
922         _balances[from] -= 1;
923         _balances[to] += 1;
924         _owners[tokenId] = to;
925 
926         emit Transfer(from, to, tokenId);
927     }
928 
929     /**
930      * @dev Approve `to` to operate on `tokenId`
931      *
932      * Emits a {Approval} event.
933      */
934     function _approve(address to, uint256 tokenId) internal virtual {
935         _tokenApprovals[tokenId] = to;
936         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
937     }
938 
939     /**
940      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
941      * The call is not executed if the target address is not a contract.
942      *
943      * @param from address representing the previous owner of the given token ID
944      * @param to target address that will receive the tokens
945      * @param tokenId uint256 ID of the token to be transferred
946      * @param _data bytes optional data to send along with the call
947      * @return bool whether the call correctly returned the expected magic value
948      */
949     function _checkOnERC721Received(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) private returns (bool) {
955         if (to.isContract()) {
956             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
957                 return retval == IERC721Receiver.onERC721Received.selector;
958             } catch (bytes memory reason) {
959                 if (reason.length == 0) {
960                     revert("ERC721: transfer to non ERC721Receiver implementer");
961                 } else {
962                     assembly {
963                         revert(add(32, reason), mload(reason))
964                     }
965                 }
966             }
967         } else {
968             return true;
969         }
970     }
971 
972     /**
973      * @dev Hook that is called before any token transfer. This includes minting
974      * and burning.
975      *
976      * Calling conditions:
977      *
978      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
979      * transferred to `to`.
980      * - When `from` is zero, `tokenId` will be minted for `to`.
981      * - When `to` is zero, ``from``'s `tokenId` will be burned.
982      * - `from` and `to` are never both zero.
983      *
984      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
985      */
986     function _beforeTokenTransfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) internal virtual {}
991 }
992 
993 interface IGGold {
994     function balanceOf(address owner) external view returns (uint);
995     function burn(address account, uint amount) external;
996 }
997 
998 interface ITreasureIsland {
999     function randomPirateOwner() external returns (address);
1000     function addTokensToStake(address account, uint16[] calldata tokenIds) external;
1001 }
1002 
1003 contract OfficialJokersClub is ERC721, Ownable {
1004     uint public MAX_TOKENS = 6000;
1005     uint constant public MINT_PER_TX_LIMIT = 10;
1006 
1007     uint public tokensMinted = 0;
1008     uint16 public phase = 1;
1009     uint16 public pirateStolen = 0;
1010     uint16 public goldMinerStolen = 0;
1011     uint16 public pirateMinted = 0;
1012 
1013     bool private _paused = true;
1014 
1015     mapping(uint16 => uint) public phasePrice;
1016 
1017     ITreasureIsland public treasureIsland;
1018     IGGold public gold;
1019 
1020     string private _apiURI = "https://api.official-jokers-club.com/token/";
1021     mapping(uint16 => bool) private _isPirate;
1022     
1023     uint16[] private _availableTokens;
1024     uint16 private _randomIndex = 0;
1025     uint private _randomCalls = 0;
1026 
1027     mapping(uint16 => address) private _randomSource;
1028 
1029     event TokenStolen(address owner, uint16 tokenId, address thief);
1030 
1031     constructor() ERC721("Official Jokers club", "Official Jokers club") {
1032         _safeMint(msg.sender, 0);
1033         tokensMinted += 1;
1034 
1035         // Phase 1 is available in the beginning
1036         switchToSalePhase(1, true);
1037 
1038         // Set default price for each phase
1039         phasePrice[1] = 0.06 ether;
1040         phasePrice[2] = 20000 ether;
1041         phasePrice[3] = 40000 ether;
1042         phasePrice[4] = 80000 ether;
1043         
1044         // Fill random source addresses
1045         _randomSource[0] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1046         _randomSource[1] = 0x3cD751E6b0078Be393132286c442345e5DC49699;
1047         _randomSource[2] = 0xb5d85CBf7cB3EE0D56b3bB207D5Fc4B82f43F511;
1048         _randomSource[3] = 0xC098B2a3Aa256D2140208C3de6543aAEf5cd3A94;
1049         _randomSource[4] = 0x28C6c06298d514Db089934071355E5743bf21d60;
1050         _randomSource[5] = 0x2FAF487A4414Fe77e2327F0bf4AE2a264a776AD2;
1051         _randomSource[6] = 0x267be1C1D684F78cb4F6a176C4911b741E4Ffdc0;
1052     }
1053 
1054     function paused() public view virtual returns (bool) {
1055         return _paused;
1056     }
1057 
1058     modifier whenNotPaused() {
1059         require(!paused(), "Pausable: paused");
1060         _;
1061     }
1062     modifier whenPaused() {
1063         require(paused(), "Pausable: not paused");
1064         _;
1065     }
1066 
1067     function setPaused(bool _state) external onlyOwner {
1068         _paused = _state;
1069     }
1070 
1071     function addAvailableTokens(uint16 _from, uint16 _to) public onlyOwner {
1072         internalAddTokens(_from, _to);
1073     }
1074 
1075     function internalAddTokens(uint16 _from, uint16 _to) internal {
1076         for (uint16 i = _from; i <= _to; i++) {
1077             _availableTokens.push(i);
1078         }
1079     }
1080 
1081     function switchToSalePhase(uint16 _phase, bool _setTokens) public onlyOwner {
1082         phase = _phase;
1083 
1084         if (!_setTokens) {
1085             return;
1086         }
1087 
1088         if (phase == 1) {
1089             internalAddTokens(1, 6000);
1090         } else if (phase == 2) {
1091             //internalAddTokens(10000, 20000);
1092         } else if (phase == 3) {
1093             //internalAddTokens(20001, 40000);
1094         } else if (phase == 4) {
1095             //internalAddTokens(40001, 6000);
1096         }
1097     }
1098 
1099     function giveAway(uint _amount, address _address) public onlyOwner {
1100         require(tokensMinted + _amount <= MAX_TOKENS, "All tokens minted");
1101         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1102 
1103         for (uint i = 0; i < _amount; i++) {
1104             uint16 tokenId = getTokenToBeMinted();
1105             _safeMint(_address, tokenId);
1106         }
1107     }
1108 
1109     function mint(uint _amount, bool _stake) public payable whenNotPaused {
1110         require(tx.origin == msg.sender, "Only EOA");
1111         require(tokensMinted + _amount <= MAX_TOKENS, "All tokens minted");
1112         require(_amount > 0 && _amount <= MINT_PER_TX_LIMIT, "Invalid mint amount");
1113         require(_availableTokens.length > 0, "All tokens for this Phase are already sold");
1114 
1115         uint totalPennyCost = 0;
1116         if (phase == 1) {
1117             // Paid mint
1118             require(mintPrice(_amount) == msg.value, "Invalid payment amount");
1119         } else {
1120             // Mint via Penny token burn
1121             require(msg.value == 0, "Now minting is done via Penny");
1122             totalPennyCost = mintPrice(_amount);
1123             require(gold.balanceOf(msg.sender) >= totalPennyCost, "Not enough Penny");
1124         }
1125 
1126         if (totalPennyCost > 0) {
1127             gold.burn(msg.sender, totalPennyCost);
1128         }
1129 
1130         tokensMinted += _amount;
1131         uint16[] memory tokenIds = _stake ? new uint16[](_amount) : new uint16[](0);
1132         for (uint i = 0; i < _amount; i++) {
1133             address recipient = msg.sender;
1134             if (phase != 1) {
1135                 updateRandomIndex();
1136             }
1137 
1138             uint16 tokenId = getTokenToBeMinted();
1139 
1140             if (isPirate(tokenId)) {
1141                 pirateMinted += 1;
1142             }
1143 
1144 //            if (recipient != msg.sender) {
1145 //                isPirate(tokenId) ? pirateStolen += 1 : goldMinerStolen += 1;
1146 //                emit TokenStolen(msg.sender, tokenId, recipient);
1147 //            }
1148             
1149             if (!_stake) {
1150                 _safeMint(recipient, tokenId);
1151             } else {
1152                 _safeMint(address(treasureIsland), tokenId);
1153                 tokenIds[i] = tokenId;
1154             }
1155         }
1156         if (_stake) {
1157             treasureIsland.addTokensToStake(msg.sender, tokenIds);
1158         }
1159     }
1160 
1161     function mintPrice(uint _amount) public view returns (uint) {
1162         return _amount * phasePrice[phase];
1163     }
1164 
1165     function isPirate(uint16 id) public view returns (bool) {
1166         return _isPirate[id];
1167     }
1168 
1169     function getTokenToBeMinted() private returns (uint16) {
1170         uint random = getSomeRandomNumber(_availableTokens.length, _availableTokens.length);
1171         uint16 tokenId = _availableTokens[random];
1172 
1173         _availableTokens[random] = _availableTokens[_availableTokens.length - 1];
1174         _availableTokens.pop();
1175 
1176         return tokenId;
1177     }
1178     
1179     function updateRandomIndex() internal {
1180         _randomIndex += 1;
1181         _randomCalls += 1;
1182         if (_randomIndex > 6) _randomIndex = 0;
1183     }
1184 
1185     function getSomeRandomNumber(uint _seed, uint _limit) internal view returns (uint16) {
1186         uint extra = 0;
1187         for (uint16 i = 0; i < 7; i++) {
1188             extra += _randomSource[_randomIndex].balance;
1189         }
1190 
1191         uint random = uint(
1192             keccak256(
1193                 abi.encodePacked(
1194                     _seed,
1195                     blockhash(block.number - 1),
1196                     block.coinbase,
1197                     block.difficulty,
1198                     msg.sender,
1199                     tokensMinted,
1200                     extra,
1201                     _randomCalls,
1202                     _randomIndex
1203                 )
1204             )
1205         );
1206 
1207         return uint16(random % _limit);
1208     }
1209 
1210     function shuffleSeeds(uint _seed, uint _max) external onlyOwner {
1211         uint shuffleCount = getSomeRandomNumber(_seed, _max);
1212         _randomIndex = uint16(shuffleCount);
1213         for (uint i = 0; i < shuffleCount; i++) {
1214             updateRandomIndex();
1215         }
1216     }
1217 
1218     function setPirateId(uint16 id, bool special) external onlyOwner {
1219         _isPirate[id] = special;
1220     }
1221 
1222     function setPirateIds(uint16[] calldata ids) external onlyOwner {
1223         for (uint i = 0; i < ids.length; i++) {
1224             _isPirate[ids[i]] = true;
1225         }
1226     }
1227 
1228     function setTreasureIsland(address _island) external onlyOwner {
1229         treasureIsland = ITreasureIsland(_island);
1230     }
1231 
1232     function setGold(address _gold) external onlyOwner {
1233         gold = IGGold(_gold);
1234     }
1235 
1236     function changePhasePrice(uint16 _phase, uint _weiPrice) external onlyOwner {
1237         phasePrice[_phase] = _weiPrice;
1238     }
1239 
1240     function transferFrom(address from, address to, uint tokenId) public virtual override {
1241         // Hardcode the Manager's approval so that users don't have to waste gas approving
1242         if (_msgSender() != address(treasureIsland))
1243             require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1244         _transfer(from, to, tokenId);
1245     }
1246 
1247     function totalSupply() external view returns (uint) {
1248         return tokensMinted;
1249     }
1250 
1251     function _baseURI() internal view override returns (string memory) {
1252         return _apiURI;
1253     }
1254 
1255     function setBaseURI(string memory uri) external onlyOwner {
1256         _apiURI = uri;
1257     }
1258 
1259     function changeRandomSource(uint16 _id, address _address) external onlyOwner {
1260         _randomSource[_id] = _address;
1261     }
1262 
1263     function withdraw(address to) external onlyOwner {
1264         uint balance = address(this).balance;
1265         payable(to).transfer(balance);
1266     }
1267 }