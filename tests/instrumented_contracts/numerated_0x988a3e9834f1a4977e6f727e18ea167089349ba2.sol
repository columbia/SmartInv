1 /**
2 ==========================================================
3           _   _ _____   __  __  ____   ____  _   _ 
4     /\   | \ | |_   _| |  \/  |/ __ \ / __ \| \ | |
5    /  \  |  \| | | |   | \  / | |  | | |  | |  \| |
6   / /\ \ | . ` | | |   | |\/| | |  | | |  | | . ` |
7  / ____ \| |\  |_| |_  | |  | | |__| | |__| | |\  |
8 /_/    \_\_| \_|_____| |_|  |_|\____/ \____/|_| \_|
9                                                    
10 ===========================================================
11 
12  *Submitted for verification at Etherscan.io on 2021-09-22
13 */
14 
15 /**
16  *Submitted for verification at Etherscan.io on 2021-09-21
17 */
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 pragma solidity ^0.8.0;
43 
44 /**
45  * @dev String operations.
46  */
47 library Strings {
48     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
52      */
53     function toString(uint256 value) internal pure returns (string memory) {
54         // Inspired by OraclizeAPI's implementation - MIT licence
55         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
56 
57         if (value == 0) {
58             return "0";
59         }
60         uint256 temp = value;
61         uint256 digits;
62         while (temp != 0) {
63             digits++;
64             temp /= 10;
65         }
66         bytes memory buffer = new bytes(digits);
67         while (value != 0) {
68             digits -= 1;
69             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
70             value /= 10;
71         }
72         return string(buffer);
73     }
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
77      */
78     function toHexString(uint256 value) internal pure returns (string memory) {
79         if (value == 0) {
80             return "0x00";
81         }
82         uint256 temp = value;
83         uint256 length = 0;
84         while (temp != 0) {
85             length++;
86             temp >>= 8;
87         }
88         return toHexString(value, length);
89     }
90 
91     /**
92      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
93      */
94     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
95         bytes memory buffer = new bytes(2 * length + 2);
96         buffer[0] = "0";
97         buffer[1] = "x";
98         for (uint256 i = 2 * length + 1; i > 1; --i) {
99             buffer[i] = _HEX_SYMBOLS[value & 0xf];
100             value >>= 4;
101         }
102         require(value == 0, "Strings: hex length insufficient");
103         return string(buffer);
104     }
105 }
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Collection of functions related to the address type
110  */
111 library Address {
112     /**
113      * @dev Returns true if `account` is a contract.
114      *
115      * [IMPORTANT]
116      * ====
117      * It is unsafe to assume that an address for which this function returns
118      * false is an externally-owned account (EOA) and not a contract.
119      *
120      * Among others, `isContract` will return false for the following
121      * types of addresses:
122      *
123      *  - an externally-owned account
124      *  - a contract in construction
125      *  - an address where a contract will be created
126      *  - an address where a contract lived, but was destroyed
127      * ====
128      */
129     function isContract(address account) internal view returns (bool) {
130         // This method relies on extcodesize, which returns 0 for contracts in
131         // construction, since the code is only stored at the end of the
132         // constructor execution.
133 
134         uint256 size;
135         assembly {
136             size := extcodesize(account)
137         }
138         return size > 0;
139     }
140 
141     /**
142      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
143      * `recipient`, forwarding all available gas and reverting on errors.
144      *
145      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
146      * of certain opcodes, possibly making contracts go over the 2300 gas limit
147      * imposed by `transfer`, making them unable to receive funds via
148      * `transfer`. {sendValue} removes this limitation.
149      *
150      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
151      *
152      * IMPORTANT: because control is transferred to `recipient`, care must be
153      * taken to not create reentrancy vulnerabilities. Consider using
154      * {ReentrancyGuard} or the
155      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
156      */
157     function sendValue(address payable recipient, uint256 amount) internal {
158         require(address(this).balance >= amount, "Address: insufficient balance");
159 
160         (bool success, ) = recipient.call{value: amount}("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 
164     /**
165      * @dev Performs a Solidity function call using a low level `call`. A
166      * plain `call` is an unsafe replacement for a function call: use this
167      * function instead.
168      *
169      * If `target` reverts with a revert reason, it is bubbled up by this
170      * function (like regular Solidity function calls).
171      *
172      * Returns the raw returned data. To convert to the expected return value,
173      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
174      *
175      * Requirements:
176      *
177      * - `target` must be a contract.
178      * - calling `target` with `data` must not revert.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
183         return functionCall(target, data, "Address: low-level call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
188      * `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, 0, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
202      * but also transferring `value` wei to `target`.
203      *
204      * Requirements:
205      *
206      * - the calling contract must have an ETH balance of at least `value`.
207      * - the called Solidity function must be `payable`.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value
215     ) internal returns (bytes memory) {
216         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
221      * with `errorMessage` as a fallback revert reason when `target` reverts.
222      *
223      * _Available since v3.1._
224      */
225     function functionCallWithValue(
226         address target,
227         bytes memory data,
228         uint256 value,
229         string memory errorMessage
230     ) internal returns (bytes memory) {
231         require(address(this).balance >= value, "Address: insufficient balance for call");
232         require(isContract(target), "Address: call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.call{value: value}(data);
235         return verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
245         return functionStaticCall(target, data, "Address: low-level static call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
250      * but performing a static call.
251      *
252      * _Available since v3.3._
253      */
254     function functionStaticCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal view returns (bytes memory) {
259         require(isContract(target), "Address: static call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.staticcall(data);
262         return verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
277      * but performing a delegate call.
278      *
279      * _Available since v3.4._
280      */
281     function functionDelegateCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         require(isContract(target), "Address: delegate call to non-contract");
287 
288         (bool success, bytes memory returndata) = target.delegatecall(data);
289         return verifyCallResult(success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
294      * revert reason using the provided one.
295      *
296      * _Available since v4.3._
297      */
298     function verifyCallResult(
299         bool success,
300         bytes memory returndata,
301         string memory errorMessage
302     ) internal pure returns (bytes memory) {
303         if (success) {
304             return returndata;
305         } else {
306             // Look for revert reason and bubble it up if present
307             if (returndata.length > 0) {
308                 // The easiest way to bubble the revert reason is using memory via assembly
309 
310                 assembly {
311                     let returndata_size := mload(returndata)
312                     revert(add(32, returndata), returndata_size)
313                 }
314             } else {
315                 revert(errorMessage);
316             }
317         }
318     }
319 }
320 pragma solidity ^0.8.0;
321 
322 /**
323  * @dev Interface of the ERC165 standard, as defined in the
324  * https://eips.ethereum.org/EIPS/eip-165[EIP].
325  *
326  * Implementers can declare support of contract interfaces, which can then be
327  * queried by others ({ERC165Checker}).
328  *
329  * For an implementation, see {ERC165}.
330  */
331 interface IERC165 {
332     /**
333      * @dev Returns true if this contract implements the interface defined by
334      * `interfaceId`. See the corresponding
335      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
336      * to learn more about how these ids are created.
337      *
338      * This function call must use less than 30 000 gas.
339      */
340     function supportsInterface(bytes4 interfaceId) external view returns (bool);
341 }
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @title ERC721 token receiver interface
346  * @dev Interface for any contract that wants to support safeTransfers
347  * from ERC721 asset contracts.
348  */
349 interface IERC721Receiver {
350     /**
351      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
352      * by `operator` from `from`, this function is called.
353      *
354      * It must return its Solidity selector to confirm the token transfer.
355      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
356      *
357      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
358      */
359     function onERC721Received(
360         address operator,
361         address from,
362         uint256 tokenId,
363         bytes calldata data
364     ) external returns (bytes4);
365 }
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Contract module which provides a basic access control mechanism, where
371  * there is an account (an owner) that can be granted exclusive access to
372  * specific functions.
373  *
374  * By default, the owner account will be the one that deploys the contract. This
375  * can later be changed with {transferOwnership}.
376  *
377  * This module is used through inheritance. It will make available the modifier
378  * `onlyOwner`, which can be applied to your functions to restrict their use to
379  * the owner.
380  */
381 abstract contract Ownable is Context {
382     address private _owner;
383 
384     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
385 
386     /**
387      * @dev Initializes the contract setting the deployer as the initial owner.
388      */
389     constructor() {
390         _setOwner(_msgSender());
391     }
392 
393     /**
394      * @dev Returns the address of the current owner.
395      */
396     function owner() public view virtual returns (address) {
397         return _owner;
398     }
399 
400     /**
401      * @dev Throws if called by any account other than the owner.
402      */
403     modifier onlyOwner() {
404         require(owner() == _msgSender(), "Ownable: caller is not the owner");
405         _;
406     }
407 
408     /**
409      * @dev Leaves the contract without owner. It will not be possible to call
410      * `onlyOwner` functions anymore. Can only be called by the current owner.
411      *
412      * NOTE: Renouncing ownership will leave the contract without an owner,
413      * thereby removing any functionality that is only available to the owner.
414      */
415     function renounceOwnership() public virtual onlyOwner {
416         _setOwner(address(0));
417     }
418 
419     /**
420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
421      * Can only be called by the current owner.
422      */
423     function transferOwnership(address newOwner) public virtual onlyOwner {
424         require(newOwner != address(0), "Ownable: new owner is the zero address");
425         _setOwner(newOwner);
426     }
427 
428     function _setOwner(address newOwner) private {
429         address oldOwner = _owner;
430         _owner = newOwner;
431         emit OwnershipTransferred(oldOwner, newOwner);
432     }
433 }
434 pragma solidity ^0.8.0;
435 
436 
437 /**
438  * @dev Implementation of the {IERC165} interface.
439  *
440  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
441  * for the additional interface id that will be supported. For example:
442  *
443  * ```solidity
444  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
445  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
446  * }
447  * ```
448  *
449  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
450  */
451 abstract contract ERC165 is IERC165 {
452     /**
453      * @dev See {IERC165-supportsInterface}.
454      */
455     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
456         return interfaceId == type(IERC165).interfaceId;
457     }
458 }
459 pragma solidity ^0.8.0;
460 
461 
462 /**
463  * @dev Required interface of an ERC721 compliant contract.
464  */
465 interface IERC721 is IERC165 {
466     /**
467      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
468      */
469     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
470 
471     /**
472      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
473      */
474     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
475 
476     /**
477      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
478      */
479     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
480 
481     /**
482      * @dev Returns the number of tokens in ``owner``'s account.
483      */
484     function balanceOf(address owner) external view returns (uint256 balance);
485 
486     /**
487      * @dev Returns the owner of the `tokenId` token.
488      *
489      * Requirements:
490      *
491      * - `tokenId` must exist.
492      */
493     function ownerOf(uint256 tokenId) external view returns (address owner);
494 
495     /**
496      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
497      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Transfers `tokenId` token from `from` to `to`.
517      *
518      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
537      * The approval is cleared when the token is transferred.
538      *
539      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
540      *
541      * Requirements:
542      *
543      * - The caller must own the token or be an approved operator.
544      * - `tokenId` must exist.
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address to, uint256 tokenId) external;
549 
550     /**
551      * @dev Returns the account approved for `tokenId` token.
552      *
553      * Requirements:
554      *
555      * - `tokenId` must exist.
556      */
557     function getApproved(uint256 tokenId) external view returns (address operator);
558 
559     /**
560      * @dev Approve or remove `operator` as an operator for the caller.
561      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
562      *
563      * Requirements:
564      *
565      * - The `operator` cannot be the caller.
566      *
567      * Emits an {ApprovalForAll} event.
568      */
569     function setApprovalForAll(address operator, bool _approved) external;
570 
571     /**
572      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
573      *
574      * See {setApprovalForAll}
575      */
576     function isApprovedForAll(address owner, address operator) external view returns (bool);
577 
578     /**
579      * @dev Safely transfers `tokenId` token from `from` to `to`.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId,
595         bytes calldata data
596     ) external;
597 }
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Metadata is IERC721 {
606     /**
607      * @dev Returns the token collection name.
608      */
609     function name() external view returns (string memory);
610 
611     /**
612      * @dev Returns the token collection symbol.
613      */
614     function symbol() external view returns (string memory);
615 
616     /**
617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
618      */
619     function tokenURI(uint256 tokenId) external view returns (string memory);
620 }
621 pragma solidity ^0.8.0;
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
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 
1028 contract Animoon is Ownable, ERC721 {
1029     
1030     uint public tokenPrice = 0.2 ether;
1031     uint constant maxSupply = 9999;
1032     uint public totalSupply = 0;
1033     uint public presaleSupply = 5000;
1034     bool public public_sale_status = false;
1035     bool public pre_sale_status = false;
1036     string public baseURI;
1037     
1038     uint public maxPerTransaction = 20;  //Max Limit for Sale     
1039     constructor() ERC721("Animoon", "ANI "){}
1040 
1041    function buy(uint _count) public payable{
1042        require(public_sale_status == true, "Sale is Paused.");
1043         require(_count > 0, "mint at least one token");
1044         require(_count <= maxPerTransaction, "max per transaction 5");
1045         require(totalSupply + _count <= maxSupply, "Not enough tokens left");
1046         require(msg.value >= tokenPrice * _count, "incorrect ether amount");
1047         
1048         for(uint i = 0; i < _count; i++)
1049             _safeMint(msg.sender, totalSupply + 1 + i);
1050         totalSupply += _count;
1051     }
1052       function presale(uint _count) public payable{
1053        require(pre_sale_status == true, "Sale is Paused.");
1054         require(_count > 0, "mint at least one token");
1055         require(_count <= maxPerTransaction, "max per transaction 5");
1056         require(totalSupply + _count <= presaleSupply, "Not enough tokens left");
1057         require(msg.value >= tokenPrice * _count, "incorrect ether amount");
1058         
1059         for(uint i = 0; i < _count; i++)
1060             _safeMint(msg.sender, totalSupply + 1 + i);
1061         totalSupply += _count;
1062     }
1063 
1064     function sendGifts(address[] memory _wallets) public onlyOwner{
1065         require(totalSupply + _wallets.length <= maxSupply, "not enough tokens left");
1066         for(uint i = 0; i < _wallets.length; i++)
1067             _safeMint(_wallets[i], totalSupply + 1 + i);
1068         totalSupply += _wallets.length;
1069         
1070     }
1071      function setprice(uint temp) external onlyOwner {
1072         tokenPrice = temp;
1073     }
1074     function setBaseUri(string memory _uri) external onlyOwner {
1075         baseURI = _uri;
1076     }
1077   
1078     function publicSale_status(bool temp) external onlyOwner {
1079         public_sale_status = temp;
1080     }
1081      function preSale_status(bool temp) external onlyOwner {
1082         pre_sale_status = temp;
1083     }
1084 
1085      function Update_preSale_supply(uint temp) external onlyOwner {
1086         presaleSupply = temp;
1087     }
1088     
1089     function _baseURI() internal view virtual override returns (string memory) {
1090         return baseURI;
1091     }
1092       function withdraw() external onlyOwner {
1093          uint _balance = address(this).balance;
1094         payable(owner()).transfer(_balance * 68 / 100);//owner wallet
1095         payable(0x7C60E48234ffc524993421885a1E8EFCb4FEB6EB).transfer(_balance * 30 / 100); //owner
1096         payable(0x2098145E7D5572828209f89FB972568B765605C7).transfer(_balance * 2 / 100); //dev
1097     }
1098 }