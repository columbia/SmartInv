1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity >=0.7.0 <0.9.0;
7 
8 //
9 // TheMetaMoais contract created by 10xDevelopment
10 // https://10xDevelopment.com
11 // Idea by Leonardo Lammas
12 //
13 
14 /**
15  * @dev String operations.
16  */
17 library Strings {
18     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
19 
20     /**
21      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
22      */
23     function toString(uint256 value) internal pure returns (string memory) {
24         // Inspired by OraclizeAPI's implementation - MIT licence
25         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
26 
27         if (value == 0) {
28             return "0";
29         }
30         uint256 temp = value;
31         uint256 digits;
32         while (temp != 0) {
33             digits++;
34             temp /= 10;
35         }
36         bytes memory buffer = new bytes(digits);
37         while (value != 0) {
38             digits -= 1;
39             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
40             value /= 10;
41         }
42         return string(buffer);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
47      */
48     function toHexString(uint256 value) internal pure returns (string memory) {
49         if (value == 0) {
50             return "0x00";
51         }
52         uint256 temp = value;
53         uint256 length = 0;
54         while (temp != 0) {
55             length++;
56             temp >>= 8;
57         }
58         return toHexString(value, length);
59     }
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
63      */
64     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
65         bytes memory buffer = new bytes(2 * length + 2);
66         buffer[0] = "0";
67         buffer[1] = "x";
68         for (uint256 i = 2 * length + 1; i > 1; --i) {
69             buffer[i] = _HEX_SYMBOLS[value & 0xf];
70             value >>= 4;
71         }
72         require(value == 0, "Strings: hex length insufficient");
73         return string(buffer);
74     }
75 }
76 
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      */
99     function isContract(address account) internal view returns (bool) {
100         // This method relies on extcodesize, which returns 0 for contracts in
101         // construction, since the code is only stored at the end of the
102         // constructor execution.
103 
104         uint256 size;
105         assembly {
106             size := extcodesize(account)
107         }
108         return size > 0;
109     }
110 
111     /**
112      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
113      * `recipient`, forwarding all available gas and reverting on errors.
114      *
115      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
116      * of certain opcodes, possibly making contracts go over the 2300 gas limit
117      * imposed by `transfer`, making them unable to receive funds via
118      * `transfer`. {sendValue} removes this limitation.
119      *
120      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
121      *
122      * IMPORTANT: because control is transferred to `recipient`, care must be
123      * taken to not create reentrancy vulnerabilities. Consider using
124      * {ReentrancyGuard} or the
125      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
126      */
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");
129 
130         (bool success, ) = recipient.call{value: amount}("");
131         require(success, "Address: unable to send value, recipient may have reverted");
132     }
133 
134     /**
135      * @dev Performs a Solidity function call using a low level `call`. A
136      * plain `call` is an unsafe replacement for a function call: use this
137      * function instead.
138      *
139      * If `target` reverts with a revert reason, it is bubbled up by this
140      * function (like regular Solidity function calls).
141      *
142      * Returns the raw returned data. To convert to the expected return value,
143      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
144      *
145      * Requirements:
146      *
147      * - `target` must be a contract.
148      * - calling `target` with `data` must not revert.
149      *
150      * _Available since v3.1._
151      */
152     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionCall(target, data, "Address: low-level call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
158      * `errorMessage` as a fallback revert reason when `target` reverts.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(
163         address target,
164         bytes memory data,
165         string memory errorMessage
166     ) internal returns (bytes memory) {
167         return functionCallWithValue(target, data, 0, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but also transferring `value` wei to `target`.
173      *
174      * Requirements:
175      *
176      * - the calling contract must have an ETH balance of at least `value`.
177      * - the called Solidity function must be `payable`.
178      *
179      * _Available since v3.1._
180      */
181     function functionCallWithValue(
182         address target,
183         bytes memory data,
184         uint256 value
185     ) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(
196         address target,
197         bytes memory data,
198         uint256 value,
199         string memory errorMessage
200     ) internal returns (bytes memory) {
201         require(address(this).balance >= value, "Address: insufficient balance for call");
202         require(isContract(target), "Address: call to non-contract");
203 
204         (bool success, bytes memory returndata) = target.call{value: value}(data);
205         return verifyCallResult(success, returndata, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but performing a static call.
211      *
212      * _Available since v3.3._
213      */
214     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
215         return functionStaticCall(target, data, "Address: low-level static call failed");
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
220      * but performing a static call.
221      *
222      * _Available since v3.3._
223      */
224     function functionStaticCall(
225         address target,
226         bytes memory data,
227         string memory errorMessage
228     ) internal view returns (bytes memory) {
229         require(isContract(target), "Address: static call to non-contract");
230 
231         (bool success, bytes memory returndata) = target.staticcall(data);
232         return verifyCallResult(success, returndata, errorMessage);
233     }
234 
235     /**
236      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
237      * but performing a delegate call.
238      *
239      * _Available since v3.4._
240      */
241     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a delegate call.
248      *
249      * _Available since v3.4._
250      */
251     function functionDelegateCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         require(isContract(target), "Address: delegate call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.delegatecall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
264      * revert reason using the provided one.
265      *
266      * _Available since v4.3._
267      */
268     function verifyCallResult(
269         bool success,
270         bytes memory returndata,
271         string memory errorMessage
272     ) internal pure returns (bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 assembly {
281                     let returndata_size := mload(returndata)
282                     revert(add(32, returndata), returndata_size)
283                 }
284             } else {
285                 revert(errorMessage);
286             }
287         }
288     }
289 }
290 
291 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC721 token receiver interface
297  * @dev Interface for any contract that wants to support safeTransfers
298  * from ERC721 asset contracts.
299  */
300 interface IERC721Receiver {
301     /**
302      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
303      * by `operator` from `from`, this function is called.
304      *
305      * It must return its Solidity selector to confirm the token transfer.
306      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
307      *
308      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
309      */
310     function onERC721Received(
311         address operator,
312         address from,
313         uint256 tokenId,
314         bytes calldata data
315     ) external returns (bytes4);
316 }
317 
318 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
319 
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
342 
343 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
344 
345 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
346 
347 pragma solidity ^0.8.0;
348 
349 /**
350  * @dev Implementation of the {IERC165} interface.
351  *
352  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
353  * for the additional interface id that will be supported. For example:
354  *
355  * ```solidity
356  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
358  * }
359  * ```
360  *
361  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
362  */
363 abstract contract ERC165 is IERC165 {
364     /**
365      * @dev See {IERC165-supportsInterface}.
366      */
367     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368         return interfaceId == type(IERC165).interfaceId;
369     }
370 }
371 
372 
373 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.2
374 
375 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 
380 
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @dev Provides information about the current execution context, including the
386  * sender of the transaction and its data. While these are generally available
387  * via msg.sender and msg.data, they should not be accessed in such a direct
388  * manner, since when dealing with meta-transactions the account sending and
389  * paying for execution may not be the actual sender (as far as an application
390  * is concerned).
391  *
392  * This contract is only required for intermediate, library-like contracts.
393  */
394 abstract contract Context {
395     function _msgSender() internal view virtual returns (address) {
396         return msg.sender;
397     }
398 
399     function _msgData() internal view virtual returns (bytes calldata) {
400         return msg.data;
401     }
402 }
403 
404 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 
409 /**
410  * @dev Contract module which provides a basic access control mechanism, where
411  * there is an account (an owner) that can be granted exclusive access to
412  * specific functions.
413  *
414  * By default, the owner account will be the one that deploys the contract. This
415  * can later be changed with {transferOwnership}.
416  *
417  * This module is used through inheritance. It will make available the modifier
418  * `onlyOwner`, which can be applied to your functions to restrict their use to
419  * the owner.
420  */
421 abstract contract Ownable is Context {
422     address private _owner;
423 
424     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
425 
426     /**
427      * @dev Initializes the contract setting the deployer as the initial owner.
428      */
429     constructor() {
430         _transferOwnership(_msgSender());
431     }
432 
433     /**
434      * @dev Returns the address of the current owner.
435      */
436     function owner() public view virtual returns (address) {
437         return _owner;
438     }
439 
440     /**
441      * @dev Throws if called by any account other than the owner.
442      */
443     modifier onlyOwner() {
444         require(owner() == _msgSender(), "Ownable: caller is not the owner");
445         _;
446     }
447 
448     /**
449      * @dev Leaves the contract without owner. It will not be possible to call
450      * `onlyOwner` functions anymore. Can only be called by the current owner.
451      *
452      * NOTE: Renouncing ownership will leave the contract without an owner,
453      * thereby removing any functionality that is only available to the owner.
454      */
455     function renounceOwnership() public virtual onlyOwner {
456         _transferOwnership(address(0));
457     }
458 
459     /**
460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
461      * Can only be called by the current owner.
462      */
463     function transferOwnership(address newOwner) public virtual onlyOwner {
464         require(newOwner != address(0), "Ownable: new owner is the zero address");
465         _transferOwnership(newOwner);
466     }
467 
468     /**
469      * @dev Transfers ownership of the contract to a new account (`newOwner`).
470      * Internal function without access restriction.
471      */
472     function _transferOwnership(address newOwner) internal virtual {
473         address oldOwner = _owner;
474         _owner = newOwner;
475         emit OwnershipTransferred(oldOwner, newOwner);
476     }
477 }
478 
479 
480 /**
481  * @dev Required interface of an ERC721 compliant contract.
482  */
483 interface IERC721 is IERC165 {
484     /**
485      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
486      */
487     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
488 
489     /**
490      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
491      */
492     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
493 
494     /**
495      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
496      */
497     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
498 
499     /**
500      * @dev Returns the number of tokens in ``owner``'s account.
501      */
502     function balanceOf(address owner) external view returns (uint256 balance);
503 
504     /**
505      * @dev Returns the owner of the `tokenId` token.
506      *
507      * Requirements:
508      *
509      * - `tokenId` must exist.
510      */
511     function ownerOf(uint256 tokenId) external view returns (address owner);
512 
513     /**
514      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
515      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
516      *
517      * Requirements:
518      *
519      * - `from` cannot be the zero address.
520      * - `to` cannot be the zero address.
521      * - `tokenId` token must exist and be owned by `from`.
522      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
523      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
524      *
525      * Emits a {Transfer} event.
526      */
527     function safeTransferFrom(
528         address from,
529         address to,
530         uint256 tokenId
531     ) external;
532 
533     /**
534      * @dev Transfers `tokenId` token from `from` to `to`.
535      *
536      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must be owned by `from`.
543      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
544      *
545      * Emits a {Transfer} event.
546      */
547     function transferFrom(
548         address from,
549         address to,
550         uint256 tokenId
551     ) external;
552 
553     /**
554      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
555      * The approval is cleared when the token is transferred.
556      *
557      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
558      *
559      * Requirements:
560      *
561      * - The caller must own the token or be an approved operator.
562      * - `tokenId` must exist.
563      *
564      * Emits an {Approval} event.
565      */
566     function approve(address to, uint256 tokenId) external;
567 
568     /**
569      * @dev Returns the account approved for `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function getApproved(uint256 tokenId) external view returns (address operator);
576 
577     /**
578      * @dev Approve or remove `operator` as an operator for the caller.
579      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
580      *
581      * Requirements:
582      *
583      * - The `operator` cannot be the caller.
584      *
585      * Emits an {ApprovalForAll} event.
586      */
587     function setApprovalForAll(address operator, bool _approved) external;
588 
589     /**
590      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
591      *
592      * See {setApprovalForAll}
593      */
594     function isApprovedForAll(address owner, address operator) external view returns (bool);
595 
596     /**
597      * @dev Safely transfers `tokenId` token from `from` to `to`.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId,
613         bytes calldata data
614     ) external;
615 }
616 
617 /**
618  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
619  * @dev See https://eips.ethereum.org/EIPS/eip-721
620  */
621 interface IERC721Metadata is IERC721 {
622     /**
623      * @dev Returns the token collection name.
624      */
625     function name() external view returns (string memory);
626 
627     /**
628      * @dev Returns the token collection symbol.
629      */
630     function symbol() external view returns (string memory);
631 
632     /**
633      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
634      */
635     function tokenURI(uint256 tokenId) external view returns (string memory);
636 }
637 
638 
639 
640 /**
641  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
642  * the Metadata extension, but not including the Enumerable extension, which is available separately as
643  * {ERC721Enumerable}.
644  */
645 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
646     using Address for address;
647     using Strings for uint256;
648 
649     // Token name
650     string private _name;
651 
652     // Token symbol
653     string private _symbol;
654 
655     // Mapping from token ID to owner address
656     mapping(uint256 => address) private _owners;
657 
658     // Mapping owner address to token count
659     mapping(address => uint256) private _balances;
660 
661     // Mapping from token ID to approved address
662     mapping(uint256 => address) private _tokenApprovals;
663 
664     // Mapping from owner to operator approvals
665     mapping(address => mapping(address => bool)) private _operatorApprovals;
666 
667     /**
668      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
669      */
670     constructor(string memory name_, string memory symbol_) {
671         _name = name_;
672         _symbol = symbol_;
673     }
674 
675     /**
676      * @dev See {IERC165-supportsInterface}.
677      */
678     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
679         return
680             interfaceId == type(IERC721).interfaceId ||
681             interfaceId == type(IERC721Metadata).interfaceId ||
682             super.supportsInterface(interfaceId);
683     }
684 
685     /**
686      * @dev See {IERC721-balanceOf}.
687      */
688     function balanceOf(address owner) public view virtual override returns (uint256) {
689         require(owner != address(0), "ERC721: balance query for the zero address");
690         return _balances[owner];
691     }
692 
693     /**
694      * @dev See {IERC721-ownerOf}.
695      */
696     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
697         address owner = _owners[tokenId];
698         require(owner != address(0), "ERC721: owner query for nonexistent token");
699         return owner;
700     }
701 
702     /**
703      * @dev See {IERC721Metadata-name}.
704      */
705     function name() public view virtual override returns (string memory) {
706         return _name;
707     }
708 
709     /**
710      * @dev See {IERC721Metadata-symbol}.
711      */
712     function symbol() public view virtual override returns (string memory) {
713         return _symbol;
714     }
715 
716     /**
717      * @dev See {IERC721Metadata-tokenURI}.
718      */
719     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
720         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
721 
722         string memory baseURI = _baseURI();
723         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
724     }
725 
726     /**
727      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
728      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
729      * by default, can be overriden in child contracts.
730      */
731     function _baseURI() internal view virtual returns (string memory) {
732         return "";
733     }
734 
735     /**
736      * @dev See {IERC721-approve}.
737      */
738     function approve(address to, uint256 tokenId) public virtual override {
739         address owner = ERC721.ownerOf(tokenId);
740         require(to != owner, "ERC721: approval to current owner");
741 
742         require(
743             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
744             "ERC721: approve caller is not owner nor approved for all"
745         );
746 
747         _approve(to, tokenId);
748     }
749 
750     /**
751      * @dev See {IERC721-getApproved}.
752      */
753     function getApproved(uint256 tokenId) public view virtual override returns (address) {
754         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
755 
756         return _tokenApprovals[tokenId];
757     }
758 
759     /**
760      * @dev See {IERC721-setApprovalForAll}.
761      */
762     function setApprovalForAll(address operator, bool approved) public virtual override {
763         _setApprovalForAll(_msgSender(), operator, approved);
764     }
765 
766     /**
767      * @dev See {IERC721-isApprovedForAll}.
768      */
769     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
770         return _operatorApprovals[owner][operator];
771     }
772 
773     /**
774      * @dev See {IERC721-transferFrom}.
775      */
776     function transferFrom(
777         address from,
778         address to,
779         uint256 tokenId
780     ) public virtual override {
781         //solhint-disable-next-line max-line-length
782         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
783 
784         _transfer(from, to, tokenId);
785     }
786 
787     /**
788      * @dev See {IERC721-safeTransferFrom}.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId
794     ) public virtual override {
795         safeTransferFrom(from, to, tokenId, "");
796     }
797 
798     /**
799      * @dev See {IERC721-safeTransferFrom}.
800      */
801     function safeTransferFrom(
802         address from,
803         address to,
804         uint256 tokenId,
805         bytes memory _data
806     ) public virtual override {
807         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
808         _safeTransfer(from, to, tokenId, _data);
809     }
810 
811     /**
812      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
813      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
814      *
815      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
816      *
817      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
818      * implement alternative mechanisms to perform token transfer, such as signature-based.
819      *
820      * Requirements:
821      *
822      * - `from` cannot be the zero address.
823      * - `to` cannot be the zero address.
824      * - `tokenId` token must exist and be owned by `from`.
825      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
826      *
827      * Emits a {Transfer} event.
828      */
829     function _safeTransfer(
830         address from,
831         address to,
832         uint256 tokenId,
833         bytes memory _data
834     ) internal virtual {
835         _transfer(from, to, tokenId);
836         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
837     }
838 
839     /**
840      * @dev Returns whether `tokenId` exists.
841      *
842      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
843      *
844      * Tokens start existing when they are minted (`_mint`),
845      * and stop existing when they are burned (`_burn`).
846      */
847     function _exists(uint256 tokenId) internal view virtual returns (bool) {
848         return _owners[tokenId] != address(0);
849     }
850 
851     /**
852      * @dev Returns whether `spender` is allowed to manage `tokenId`.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must exist.
857      */
858     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
859         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
860         address owner = ERC721.ownerOf(tokenId);
861         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
862     }
863 
864     /**
865      * @dev Safely mints `tokenId` and transfers it to `to`.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must not exist.
870      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
871      *
872      * Emits a {Transfer} event.
873      */
874     function _safeMint(address to, uint256 tokenId) internal virtual {
875         _safeMint(to, tokenId, "");
876     }
877 
878     /**
879      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
880      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
881      */
882     function _safeMint(
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) internal virtual {
887         _mint(to, tokenId);
888         require(
889             _checkOnERC721Received(address(0), to, tokenId, _data),
890             "ERC721: transfer to non ERC721Receiver implementer"
891         );
892     }
893 
894     /**
895      * @dev Mints `tokenId` and transfers it to `to`.
896      *
897      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
898      *
899      * Requirements:
900      *
901      * - `tokenId` must not exist.
902      * - `to` cannot be the zero address.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _mint(address to, uint256 tokenId) internal virtual {
907         require(to != address(0), "ERC721: mint to the zero address");
908         require(!_exists(tokenId), "ERC721: token already minted");
909 
910         _beforeTokenTransfer(address(0), to, tokenId);
911 
912         _balances[to] += 1;
913         _owners[tokenId] = to;
914 
915         emit Transfer(address(0), to, tokenId);
916     }
917 
918     /**
919      * @dev Destroys `tokenId`.
920      * The approval is cleared when the token is burned.
921      *
922      * Requirements:
923      *
924      * - `tokenId` must exist.
925      *
926      * Emits a {Transfer} event.
927      */
928     function _burn(uint256 tokenId) internal virtual {
929         address owner = ERC721.ownerOf(tokenId);
930 
931         _beforeTokenTransfer(owner, address(0), tokenId);
932 
933         // Clear approvals
934         _approve(address(0), tokenId);
935 
936         _balances[owner] -= 1;
937         delete _owners[tokenId];
938 
939         emit Transfer(owner, address(0), tokenId);
940     }
941 
942     /**
943      * @dev Transfers `tokenId` from `from` to `to`.
944      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
945      *
946      * Requirements:
947      *
948      * - `to` cannot be the zero address.
949      * - `tokenId` token must be owned by `from`.
950      *
951      * Emits a {Transfer} event.
952      */
953     function _transfer(
954         address from,
955         address to,
956         uint256 tokenId
957     ) internal virtual {
958         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
959         require(to != address(0), "ERC721: transfer to the zero address");
960 
961         _beforeTokenTransfer(from, to, tokenId);
962 
963         // Clear approvals from the previous owner
964         _approve(address(0), tokenId);
965 
966         _balances[from] -= 1;
967         _balances[to] += 1;
968         _owners[tokenId] = to;
969 
970         emit Transfer(from, to, tokenId);
971     }
972 
973     /**
974      * @dev Approve `to` to operate on `tokenId`
975      *
976      * Emits a {Approval} event.
977      */
978     function _approve(address to, uint256 tokenId) internal virtual {
979         _tokenApprovals[tokenId] = to;
980         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
981     }
982 
983     /**
984      * @dev Approve `operator` to operate on all of `owner` tokens
985      *
986      * Emits a {ApprovalForAll} event.
987      */
988     function _setApprovalForAll(
989         address owner,
990         address operator,
991         bool approved
992     ) internal virtual {
993         require(owner != operator, "ERC721: approve to caller");
994         _operatorApprovals[owner][operator] = approved;
995         emit ApprovalForAll(owner, operator, approved);
996     }
997 
998     /**
999      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1000      * The call is not executed if the target address is not a contract.
1001      *
1002      * @param from address representing the previous owner of the given token ID
1003      * @param to target address that will receive the tokens
1004      * @param tokenId uint256 ID of the token to be transferred
1005      * @param _data bytes optional data to send along with the call
1006      * @return bool whether the call correctly returned the expected magic value
1007      */
1008     function _checkOnERC721Received(
1009         address from,
1010         address to,
1011         uint256 tokenId,
1012         bytes memory _data
1013     ) private returns (bool) {
1014         if (to.isContract()) {
1015             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1016                 return retval == IERC721Receiver.onERC721Received.selector;
1017             } catch (bytes memory reason) {
1018                 if (reason.length == 0) {
1019                     revert("ERC721: transfer to non ERC721Receiver implementer");
1020                 } else {
1021                     assembly {
1022                         revert(add(32, reason), mload(reason))
1023                     }
1024                 }
1025             }
1026         } else {
1027             return true;
1028         }
1029     }
1030 
1031     /**
1032      * @dev Hook that is called before any token transfer. This includes minting
1033      * and burning.
1034      *
1035      * Calling conditions:
1036      *
1037      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1038      * transferred to `to`.
1039      * - When `from` is zero, `tokenId` will be minted for `to`.
1040      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1041      * - `from` and `to` are never both zero.
1042      *
1043      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1044      */
1045     function _beforeTokenTransfer(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) internal virtual {}
1050 }
1051 
1052 
1053 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
1054 
1055 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1056 
1057 pragma solidity ^0.8.0;
1058 
1059 /**
1060  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1061  * @dev See https://eips.ethereum.org/EIPS/eip-721
1062  */
1063 interface IERC721Enumerable is IERC721 {
1064     /**
1065      * @dev Returns the total amount of tokens stored by the contract.
1066      */
1067     function totalSupply() external view returns (uint256);
1068 
1069     /**
1070      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1071      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1072      */
1073     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1074 
1075     /**
1076      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1077      * Use along with {totalSupply} to enumerate all tokens.
1078      */
1079     function tokenByIndex(uint256 index) external view returns (uint256);
1080 }
1081 
1082 
1083 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.4.2
1084 
1085 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1086 
1087 pragma solidity ^0.8.0;
1088 
1089 
1090 /**
1091  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1092  * enumerability of all the token ids in the contract as well as all token ids owned by each
1093  * account.
1094  */
1095 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1096     // Mapping from owner to list of owned token IDs
1097     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1098 
1099     // Mapping from token ID to index of the owner tokens list
1100     mapping(uint256 => uint256) private _ownedTokensIndex;
1101 
1102     // Array with all token ids, used for enumeration
1103     uint256[] private _allTokens;
1104 
1105     // Mapping from token id to position in the allTokens array
1106     mapping(uint256 => uint256) private _allTokensIndex;
1107 
1108     /**
1109      * @dev See {IERC165-supportsInterface}.
1110      */
1111     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1112         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1117      */
1118     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1119         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1120         return _ownedTokens[owner][index];
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Enumerable-totalSupply}.
1125      */
1126     function totalSupply() public view virtual override returns (uint256) {
1127         return _allTokens.length;
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Enumerable-tokenByIndex}.
1132      */
1133     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1134         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1135         return _allTokens[index];
1136     }
1137 
1138     /**
1139      * @dev Hook that is called before any token transfer. This includes minting
1140      * and burning.
1141      *
1142      * Calling conditions:
1143      *
1144      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1145      * transferred to `to`.
1146      * - When `from` is zero, `tokenId` will be minted for `to`.
1147      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      *
1151      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1152      */
1153     function _beforeTokenTransfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual override {
1158         super._beforeTokenTransfer(from, to, tokenId);
1159 
1160         if (from == address(0)) {
1161             _addTokenToAllTokensEnumeration(tokenId);
1162         } else if (from != to) {
1163             _removeTokenFromOwnerEnumeration(from, tokenId);
1164         }
1165         if (to == address(0)) {
1166             _removeTokenFromAllTokensEnumeration(tokenId);
1167         } else if (to != from) {
1168             _addTokenToOwnerEnumeration(to, tokenId);
1169         }
1170     }
1171 
1172     /**
1173      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1174      * @param to address representing the new owner of the given token ID
1175      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1176      */
1177     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1178         uint256 length = ERC721.balanceOf(to);
1179         _ownedTokens[to][length] = tokenId;
1180         _ownedTokensIndex[tokenId] = length;
1181     }
1182 
1183     /**
1184      * @dev Private function to add a token to this extension's token tracking data structures.
1185      * @param tokenId uint256 ID of the token to be added to the tokens list
1186      */
1187     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1188         _allTokensIndex[tokenId] = _allTokens.length;
1189         _allTokens.push(tokenId);
1190     }
1191 
1192     /**
1193      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1194      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1195      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1196      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1197      * @param from address representing the previous owner of the given token ID
1198      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1199      */
1200     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1201         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1202         // then delete the last slot (swap and pop).
1203 
1204         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1205         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1206 
1207         // When the token to delete is the last token, the swap operation is unnecessary
1208         if (tokenIndex != lastTokenIndex) {
1209             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1210 
1211             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1212             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1213         }
1214 
1215         // This also deletes the contents at the last position of the array
1216         delete _ownedTokensIndex[tokenId];
1217         delete _ownedTokens[from][lastTokenIndex];
1218     }
1219 
1220     /**
1221      * @dev Private function to remove a token from this extension's token tracking data structures.
1222      * This has O(1) time complexity, but alters the order of the _allTokens array.
1223      * @param tokenId uint256 ID of the token to be removed from the tokens list
1224      */
1225     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1226         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1227         // then delete the last slot (swap and pop).
1228 
1229         uint256 lastTokenIndex = _allTokens.length - 1;
1230         uint256 tokenIndex = _allTokensIndex[tokenId];
1231 
1232         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1233         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1234         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1235         uint256 lastTokenId = _allTokens[lastTokenIndex];
1236 
1237         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1238         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1239 
1240         // This also deletes the contents at the last position of the array
1241         delete _allTokensIndex[tokenId];
1242         _allTokens.pop();
1243     }
1244 }
1245 
1246 
1247 // File contracts/TheMetaMoais.sol
1248 
1249 contract TheMetaMoais is ERC721Enumerable, Ownable {
1250   using Strings for uint256;
1251 
1252   string baseURI;
1253   string public notRevealedUri;
1254   string public baseExtension = ".json";
1255   uint256 public cost = 0.025 ether;
1256   bool public paused = false;
1257   bool public revealed = true;
1258   uint256 public maxMintAmount = 500;
1259 
1260   // Max supply of 10,000...
1261   uint256 public constant MAX_SUPPLY = 10000;
1262 
1263   // Minting is free until the number minted exceeds this threshold... 
1264   uint256 public constant FREE_MINT_THRESHOLD = 1000;
1265 
1266   // Each wallet can only mint 2 free ones...
1267   uint256 public constant FREE_MINTS_PER_WALLET = 2;
1268 
1269   constructor(
1270     string memory _name,
1271     string memory _symbol,
1272     string memory _initBaseURI,
1273     string memory _initNotRevealedUri
1274   ) ERC721(_name, _symbol) {
1275     baseURI = _initBaseURI;
1276     notRevealedUri = _initNotRevealedUri;
1277   }
1278 
1279   // internal
1280   function _baseURI() internal view virtual override returns (string memory) {
1281     return baseURI;
1282   }
1283 
1284   /** Returns true if we're in the free minting period */
1285   function isInFreePeriod() private view returns(bool) {
1286       return (totalSupply() <= FREE_MINT_THRESHOLD);
1287   }
1288 
1289   /**
1290    * Calculates cost of minting a single unit.
1291    * If we've minted less than 1000, it's free
1292    */
1293   function calculateCost() private view returns(uint256) {
1294       return (isInFreePeriod()) ? 0 : cost;
1295   }
1296 
1297   // public
1298   function mint(uint256 _mintAmount) public payable {
1299     uint256 supply = totalSupply();
1300     require(!paused);
1301     require(_mintAmount > 0);
1302     require(_mintAmount <= maxMintAmount);
1303     require(supply + _mintAmount <= MAX_SUPPLY);
1304 
1305     // If we are in the free period, make sure user does not mint more than FREE_MINTS_PER_WALLET...
1306     if (isInFreePeriod()) {
1307       if (msg.sender != owner()) {
1308           require (balanceOf(msg.sender) + _mintAmount <= FREE_MINTS_PER_WALLET, "Free mint limit exceeded.");
1309       }
1310     }
1311 
1312     // Verify user sent enough ether (owner does not have to pay)...
1313     if (msg.sender != owner()) {
1314       uint256 mintCost = calculateCost();
1315       require(msg.value >= mintCost * _mintAmount, "Did not send enough ether.");
1316     }
1317 
1318     // Mint...
1319     for (uint256 i = 1; i <= _mintAmount; i++) {
1320       _safeMint(msg.sender, supply + i);
1321     }
1322   }
1323 
1324   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1325     uint256 ownerTokenCount = balanceOf(_owner);
1326     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1327     for (uint256 i; i < ownerTokenCount; i++) {
1328       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1329     }
1330     return tokenIds;
1331   }
1332 
1333   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1334     require(_exists(tokenId), "Nonexistent token");
1335 
1336     if(revealed == false) { return notRevealedUri; }
1337 
1338     string memory currentBaseURI = _baseURI();
1339     return bytes(currentBaseURI).length > 0
1340         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1341         : "";
1342   }
1343 
1344   //only owner
1345   function reveal() public onlyOwner() {
1346       revealed = true;
1347   }
1348 
1349   function setCost(uint256 _newCost) public onlyOwner() {
1350     cost = _newCost;
1351   }
1352 
1353   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
1354     maxMintAmount = _newmaxMintAmount;
1355   }
1356 
1357   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1358     notRevealedUri = _notRevealedURI;
1359   }
1360 
1361   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1362     baseURI = _newBaseURI;
1363   }
1364 
1365   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1366     baseExtension = _newBaseExtension;
1367   }
1368 
1369   function pause(bool _state) public onlyOwner {
1370     paused = _state;
1371   }
1372 
1373   function withdraw() public payable onlyOwner {
1374     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1375     require(success);
1376   }
1377 }