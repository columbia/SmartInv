1 // SPDX-License-Identifier: MIT
2 // Sources flattened with hardhat v2.6.4 https://hardhat.org
3 
4 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.1
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 
75 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 
103 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 
181 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.1
182 
183 
184 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Interface of the ERC165 standard, as defined in the
190  * https://eips.ethereum.org/EIPS/eip-165[EIP].
191  *
192  * Implementers can declare support of contract interfaces, which can then be
193  * queried by others ({ERC165Checker}).
194  *
195  * For an implementation, see {ERC165}.
196  */
197 interface IERC165 {
198     /**
199      * @dev Returns true if this contract implements the interface defined by
200      * `interfaceId`. See the corresponding
201      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
202      * to learn more about how these ids are created.
203      *
204      * This function call must use less than 30 000 gas.
205      */
206     function supportsInterface(bytes4 interfaceId) external view returns (bool);
207 }
208 
209 
210 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.1
211 
212 
213 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Required interface of an ERC721 compliant contract.
219  */
220 interface IERC721 is IERC165 {
221     /**
222      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
225 
226     /**
227      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
228      */
229     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
230 
231     /**
232      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
233      */
234     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
235 
236     /**
237      * @dev Returns the number of tokens in ``owner``'s account.
238      */
239     function balanceOf(address owner) external view returns (uint256 balance);
240 
241     /**
242      * @dev Returns the owner of the `tokenId` token.
243      *
244      * Requirements:
245      *
246      * - `tokenId` must exist.
247      */
248     function ownerOf(uint256 tokenId) external view returns (address owner);
249 
250     /**
251      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
252      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
253      *
254      * Requirements:
255      *
256      * - `from` cannot be the zero address.
257      * - `to` cannot be the zero address.
258      * - `tokenId` token must exist and be owned by `from`.
259      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
260      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
261      *
262      * Emits a {Transfer} event.
263      */
264     function safeTransferFrom(
265         address from,
266         address to,
267         uint256 tokenId
268     ) external;
269 
270     /**
271      * @dev Transfers `tokenId` token from `from` to `to`.
272      *
273      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
274      *
275      * Requirements:
276      *
277      * - `from` cannot be the zero address.
278      * - `to` cannot be the zero address.
279      * - `tokenId` token must be owned by `from`.
280      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(
285         address from,
286         address to,
287         uint256 tokenId
288     ) external;
289 
290     /**
291      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
292      * The approval is cleared when the token is transferred.
293      *
294      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
295      *
296      * Requirements:
297      *
298      * - The caller must own the token or be an approved operator.
299      * - `tokenId` must exist.
300      *
301      * Emits an {Approval} event.
302      */
303     function approve(address to, uint256 tokenId) external;
304 
305     /**
306      * @dev Returns the account approved for `tokenId` token.
307      *
308      * Requirements:
309      *
310      * - `tokenId` must exist.
311      */
312     function getApproved(uint256 tokenId) external view returns (address operator);
313 
314     /**
315      * @dev Approve or remove `operator` as an operator for the caller.
316      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
317      *
318      * Requirements:
319      *
320      * - The `operator` cannot be the caller.
321      *
322      * Emits an {ApprovalForAll} event.
323      */
324     function setApprovalForAll(address operator, bool _approved) external;
325 
326     /**
327      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
328      *
329      * See {setApprovalForAll}
330      */
331     function isApprovedForAll(address owner, address operator) external view returns (bool);
332 
333     /**
334      * @dev Safely transfers `tokenId` token from `from` to `to`.
335      *
336      * Requirements:
337      *
338      * - `from` cannot be the zero address.
339      * - `to` cannot be the zero address.
340      * - `tokenId` token must exist and be owned by `from`.
341      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
342      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
343      *
344      * Emits a {Transfer} event.
345      */
346     function safeTransferFrom(
347         address from,
348         address to,
349         uint256 tokenId,
350         bytes calldata data
351     ) external;
352 }
353 
354 
355 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.1
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @title ERC721 token receiver interface
364  * @dev Interface for any contract that wants to support safeTransfers
365  * from ERC721 asset contracts.
366  */
367 interface IERC721Receiver {
368     /**
369      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
370      * by `operator` from `from`, this function is called.
371      *
372      * It must return its Solidity selector to confirm the token transfer.
373      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
374      *
375      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
376      */
377     function onERC721Received(
378         address operator,
379         address from,
380         uint256 tokenId,
381         bytes calldata data
382     ) external returns (bytes4);
383 }
384 
385 
386 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.1
387 
388 
389 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 /**
394  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
395  * @dev See https://eips.ethereum.org/EIPS/eip-721
396  */
397 interface IERC721Metadata is IERC721 {
398     /**
399      * @dev Returns the token collection name.
400      */
401     function name() external view returns (string memory);
402 
403     /**
404      * @dev Returns the token collection symbol.
405      */
406     function symbol() external view returns (string memory);
407 
408     /**
409      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
410      */
411     function tokenURI(uint256 tokenId) external view returns (string memory);
412 }
413 
414 
415 // File @openzeppelin/contracts/utils/Address.sol@v4.4.1
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * [IMPORTANT]
430      * ====
431      * It is unsafe to assume that an address for which this function returns
432      * false is an externally-owned account (EOA) and not a contract.
433      *
434      * Among others, `isContract` will return false for the following
435      * types of addresses:
436      *
437      *  - an externally-owned account
438      *  - a contract in construction
439      *  - an address where a contract will be created
440      *  - an address where a contract lived, but was destroyed
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize, which returns 0 for contracts in
445         // construction, since the code is only stored at the end of the
446         // constructor execution.
447 
448         uint256 size;
449         assembly {
450             size := extcodesize(account)
451         }
452         return size > 0;
453     }
454 
455     /**
456      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
457      * `recipient`, forwarding all available gas and reverting on errors.
458      *
459      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
460      * of certain opcodes, possibly making contracts go over the 2300 gas limit
461      * imposed by `transfer`, making them unable to receive funds via
462      * `transfer`. {sendValue} removes this limitation.
463      *
464      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
465      *
466      * IMPORTANT: because control is transferred to `recipient`, care must be
467      * taken to not create reentrancy vulnerabilities. Consider using
468      * {ReentrancyGuard} or the
469      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         (bool success, ) = recipient.call{value: amount}("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain `call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, 0, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but also transferring `value` wei to `target`.
517      *
518      * Requirements:
519      *
520      * - the calling contract must have an ETH balance of at least `value`.
521      * - the called Solidity function must be `payable`.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
535      * with `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(
540         address target,
541         bytes memory data,
542         uint256 value,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(address(this).balance >= value, "Address: insufficient balance for call");
546         require(isContract(target), "Address: call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.call{value: value}(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
559         return functionStaticCall(target, data, "Address: low-level static call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal view returns (bytes memory) {
573         require(isContract(target), "Address: static call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.staticcall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a delegate call.
592      *
593      * _Available since v3.4._
594      */
595     function functionDelegateCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(isContract(target), "Address: delegate call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.delegatecall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
608      * revert reason using the provided one.
609      *
610      * _Available since v4.3._
611      */
612     function verifyCallResult(
613         bool success,
614         bytes memory returndata,
615         string memory errorMessage
616     ) internal pure returns (bytes memory) {
617         if (success) {
618             return returndata;
619         } else {
620             // Look for revert reason and bubble it up if present
621             if (returndata.length > 0) {
622                 // The easiest way to bubble the revert reason is using memory via assembly
623 
624                 assembly {
625                     let returndata_size := mload(returndata)
626                     revert(add(32, returndata), returndata_size)
627                 }
628             } else {
629                 revert(errorMessage);
630             }
631         }
632     }
633 }
634 
635 
636 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.1
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Implementation of the {IERC165} interface.
645  *
646  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
647  * for the additional interface id that will be supported. For example:
648  *
649  * ```solidity
650  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
651  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
652  * }
653  * ```
654  *
655  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
656  */
657 abstract contract ERC165 is IERC165 {
658     /**
659      * @dev See {IERC165-supportsInterface}.
660      */
661     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
662         return interfaceId == type(IERC165).interfaceId;
663     }
664 }
665 
666 
667 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.1
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 
675 
676 
677 
678 
679 
680 /**
681  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
682  * the Metadata extension, but not including the Enumerable extension, which is available separately as
683  * {ERC721Enumerable}.
684  */
685 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
686     using Address for address;
687     using Strings for uint256;
688 
689     // Token name
690     string private _name;
691 
692     // Token symbol
693     string private _symbol;
694 
695     // Mapping from token ID to owner address
696     mapping(uint256 => address) private _owners;
697 
698     // Mapping owner address to token count
699     mapping(address => uint256) private _balances;
700 
701     // Mapping from token ID to approved address
702     mapping(uint256 => address) private _tokenApprovals;
703 
704     // Mapping from owner to operator approvals
705     mapping(address => mapping(address => bool)) private _operatorApprovals;
706 
707     /**
708      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
709      */
710     constructor(string memory name_, string memory symbol_) {
711         _name = name_;
712         _symbol = symbol_;
713     }
714 
715     /**
716      * @dev See {IERC165-supportsInterface}.
717      */
718     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
719         return
720             interfaceId == type(IERC721).interfaceId ||
721             interfaceId == type(IERC721Metadata).interfaceId ||
722             super.supportsInterface(interfaceId);
723     }
724 
725     /**
726      * @dev See {IERC721-balanceOf}.
727      */
728     function balanceOf(address owner) public view virtual override returns (uint256) {
729         require(owner != address(0), "ERC721: balance query for the zero address");
730         return _balances[owner];
731     }
732 
733     /**
734      * @dev See {IERC721-ownerOf}.
735      */
736     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
737         address owner = _owners[tokenId];
738         require(owner != address(0), "ERC721: owner query for nonexistent token");
739         return owner;
740     }
741 
742     /**
743      * @dev See {IERC721Metadata-name}.
744      */
745     function name() public view virtual override returns (string memory) {
746         return _name;
747     }
748 
749     /**
750      * @dev See {IERC721Metadata-symbol}.
751      */
752     function symbol() public view virtual override returns (string memory) {
753         return _symbol;
754     }
755 
756     /**
757      * @dev See {IERC721Metadata-tokenURI}.
758      */
759     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
760         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
761 
762         string memory baseURI = _baseURI();
763         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
764     }
765 
766     /**
767      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
768      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
769      * by default, can be overriden in child contracts.
770      */
771     function _baseURI() internal view virtual returns (string memory) {
772         return "";
773     }
774 
775     /**
776      * @dev See {IERC721-approve}.
777      */
778     function approve(address to, uint256 tokenId) public virtual override {
779         address owner = ERC721.ownerOf(tokenId);
780         require(to != owner, "ERC721: approval to current owner");
781 
782         require(
783             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
784             "ERC721: approve caller is not owner nor approved for all"
785         );
786 
787         _approve(to, tokenId);
788     }
789 
790     /**
791      * @dev See {IERC721-getApproved}.
792      */
793     function getApproved(uint256 tokenId) public view virtual override returns (address) {
794         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
795 
796         return _tokenApprovals[tokenId];
797     }
798 
799     /**
800      * @dev See {IERC721-setApprovalForAll}.
801      */
802     function setApprovalForAll(address operator, bool approved) public virtual override {
803         _setApprovalForAll(_msgSender(), operator, approved);
804     }
805 
806     /**
807      * @dev See {IERC721-isApprovedForAll}.
808      */
809     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
810         return _operatorApprovals[owner][operator];
811     }
812 
813     /**
814      * @dev See {IERC721-transferFrom}.
815      */
816     function transferFrom(
817         address from,
818         address to,
819         uint256 tokenId
820     ) public virtual override {
821         //solhint-disable-next-line max-line-length
822         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
823 
824         _transfer(from, to, tokenId);
825     }
826 
827     /**
828      * @dev See {IERC721-safeTransferFrom}.
829      */
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) public virtual override {
835         safeTransferFrom(from, to, tokenId, "");
836     }
837 
838     /**
839      * @dev See {IERC721-safeTransferFrom}.
840      */
841     function safeTransferFrom(
842         address from,
843         address to,
844         uint256 tokenId,
845         bytes memory _data
846     ) public virtual override {
847         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
848         _safeTransfer(from, to, tokenId, _data);
849     }
850 
851     /**
852      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
853      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
854      *
855      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
856      *
857      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
858      * implement alternative mechanisms to perform token transfer, such as signature-based.
859      *
860      * Requirements:
861      *
862      * - `from` cannot be the zero address.
863      * - `to` cannot be the zero address.
864      * - `tokenId` token must exist and be owned by `from`.
865      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
866      *
867      * Emits a {Transfer} event.
868      */
869     function _safeTransfer(
870         address from,
871         address to,
872         uint256 tokenId,
873         bytes memory _data
874     ) internal virtual {
875         _transfer(from, to, tokenId);
876         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
877     }
878 
879     /**
880      * @dev Returns whether `tokenId` exists.
881      *
882      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
883      *
884      * Tokens start existing when they are minted (`_mint`),
885      * and stop existing when they are burned (`_burn`).
886      */
887     function _exists(uint256 tokenId) internal view virtual returns (bool) {
888         return _owners[tokenId] != address(0);
889     }
890 
891     /**
892      * @dev Returns whether `spender` is allowed to manage `tokenId`.
893      *
894      * Requirements:
895      *
896      * - `tokenId` must exist.
897      */
898     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
899         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
900         address owner = ERC721.ownerOf(tokenId);
901         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
902     }
903 
904     /**
905      * @dev Safely mints `tokenId` and transfers it to `to`.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must not exist.
910      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
911      *
912      * Emits a {Transfer} event.
913      */
914     function _safeMint(address to, uint256 tokenId) internal virtual {
915         _safeMint(to, tokenId, "");
916     }
917 
918     /**
919      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
920      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
921      */
922     function _safeMint(
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) internal virtual {
927         _mint(to, tokenId);
928         require(
929             _checkOnERC721Received(address(0), to, tokenId, _data),
930             "ERC721: transfer to non ERC721Receiver implementer"
931         );
932     }
933 
934     /**
935      * @dev Mints `tokenId` and transfers it to `to`.
936      *
937      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
938      *
939      * Requirements:
940      *
941      * - `tokenId` must not exist.
942      * - `to` cannot be the zero address.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _mint(address to, uint256 tokenId) internal virtual {
947         require(to != address(0), "ERC721: mint to the zero address");
948         require(!_exists(tokenId), "ERC721: token already minted");
949 
950         _beforeTokenTransfer(address(0), to, tokenId);
951 
952         _balances[to] += 1;
953         _owners[tokenId] = to;
954 
955         emit Transfer(address(0), to, tokenId);
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
968     function _burn(uint256 tokenId) internal virtual {
969         address owner = ERC721.ownerOf(tokenId);
970 
971         _beforeTokenTransfer(owner, address(0), tokenId);
972 
973         // Clear approvals
974         _approve(address(0), tokenId);
975 
976         _balances[owner] -= 1;
977         delete _owners[tokenId];
978 
979         emit Transfer(owner, address(0), tokenId);
980     }
981 
982     /**
983      * @dev Transfers `tokenId` from `from` to `to`.
984      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
985      *
986      * Requirements:
987      *
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _transfer(
994         address from,
995         address to,
996         uint256 tokenId
997     ) internal virtual {
998         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
999         require(to != address(0), "ERC721: transfer to the zero address");
1000 
1001         _beforeTokenTransfer(from, to, tokenId);
1002 
1003         // Clear approvals from the previous owner
1004         _approve(address(0), tokenId);
1005 
1006         _balances[from] -= 1;
1007         _balances[to] += 1;
1008         _owners[tokenId] = to;
1009 
1010         emit Transfer(from, to, tokenId);
1011     }
1012 
1013     /**
1014      * @dev Approve `to` to operate on `tokenId`
1015      *
1016      * Emits a {Approval} event.
1017      */
1018     function _approve(address to, uint256 tokenId) internal virtual {
1019         _tokenApprovals[tokenId] = to;
1020         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev Approve `operator` to operate on all of `owner` tokens
1025      *
1026      * Emits a {ApprovalForAll} event.
1027      */
1028     function _setApprovalForAll(
1029         address owner,
1030         address operator,
1031         bool approved
1032     ) internal virtual {
1033         require(owner != operator, "ERC721: approve to caller");
1034         _operatorApprovals[owner][operator] = approved;
1035         emit ApprovalForAll(owner, operator, approved);
1036     }
1037 
1038     /**
1039      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1040      * The call is not executed if the target address is not a contract.
1041      *
1042      * @param from address representing the previous owner of the given token ID
1043      * @param to target address that will receive the tokens
1044      * @param tokenId uint256 ID of the token to be transferred
1045      * @param _data bytes optional data to send along with the call
1046      * @return bool whether the call correctly returned the expected magic value
1047      */
1048     function _checkOnERC721Received(
1049         address from,
1050         address to,
1051         uint256 tokenId,
1052         bytes memory _data
1053     ) private returns (bool) {
1054         if (to.isContract()) {
1055             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1056                 return retval == IERC721Receiver.onERC721Received.selector;
1057             } catch (bytes memory reason) {
1058                 if (reason.length == 0) {
1059                     revert("ERC721: transfer to non ERC721Receiver implementer");
1060                 } else {
1061                     assembly {
1062                         revert(add(32, reason), mload(reason))
1063                     }
1064                 }
1065             }
1066         } else {
1067             return true;
1068         }
1069     }
1070 
1071     /**
1072      * @dev Hook that is called before any token transfer. This includes minting
1073      * and burning.
1074      *
1075      * Calling conditions:
1076      *
1077      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1078      * transferred to `to`.
1079      * - When `from` is zero, `tokenId` will be minted for `to`.
1080      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1081      * - `from` and `to` are never both zero.
1082      *
1083      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1084      */
1085     function _beforeTokenTransfer(
1086         address from,
1087         address to,
1088         uint256 tokenId
1089     ) internal virtual {}
1090 }
1091 
1092 
1093 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.1
1094 
1095 
1096 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1097 
1098 pragma solidity ^0.8.0;
1099 
1100 /**
1101  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1102  * @dev See https://eips.ethereum.org/EIPS/eip-721
1103  */
1104 interface IERC721Enumerable is IERC721 {
1105     /**
1106      * @dev Returns the total amount of tokens stored by the contract.
1107      */
1108     function totalSupply() external view returns (uint256);
1109 
1110     /**
1111      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1112      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1113      */
1114     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1115 
1116     /**
1117      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1118      * Use along with {totalSupply} to enumerate all tokens.
1119      */
1120     function tokenByIndex(uint256 index) external view returns (uint256);
1121 }
1122 
1123 
1124 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.4.1
1125 
1126 
1127 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1128 
1129 pragma solidity ^0.8.0;
1130 
1131 
1132 /**
1133  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1134  * enumerability of all the token ids in the contract as well as all token ids owned by each
1135  * account.
1136  */
1137 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1138     // Mapping from owner to list of owned token IDs
1139     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1140 
1141     // Mapping from token ID to index of the owner tokens list
1142     mapping(uint256 => uint256) private _ownedTokensIndex;
1143 
1144     // Array with all token ids, used for enumeration
1145     uint256[] private _allTokens;
1146 
1147     // Mapping from token id to position in the allTokens array
1148     mapping(uint256 => uint256) private _allTokensIndex;
1149 
1150     /**
1151      * @dev See {IERC165-supportsInterface}.
1152      */
1153     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1154         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1155     }
1156 
1157     /**
1158      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1159      */
1160     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1161         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1162         return _ownedTokens[owner][index];
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Enumerable-totalSupply}.
1167      */
1168     function totalSupply() public view virtual override returns (uint256) {
1169         return _allTokens.length;
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Enumerable-tokenByIndex}.
1174      */
1175     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1176         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1177         return _allTokens[index];
1178     }
1179 
1180     /**
1181      * @dev Hook that is called before any token transfer. This includes minting
1182      * and burning.
1183      *
1184      * Calling conditions:
1185      *
1186      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1187      * transferred to `to`.
1188      * - When `from` is zero, `tokenId` will be minted for `to`.
1189      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1190      * - `from` cannot be the zero address.
1191      * - `to` cannot be the zero address.
1192      *
1193      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1194      */
1195     function _beforeTokenTransfer(
1196         address from,
1197         address to,
1198         uint256 tokenId
1199     ) internal virtual override {
1200         super._beforeTokenTransfer(from, to, tokenId);
1201 
1202         if (from == address(0)) {
1203             _addTokenToAllTokensEnumeration(tokenId);
1204         } else if (from != to) {
1205             _removeTokenFromOwnerEnumeration(from, tokenId);
1206         }
1207         if (to == address(0)) {
1208             _removeTokenFromAllTokensEnumeration(tokenId);
1209         } else if (to != from) {
1210             _addTokenToOwnerEnumeration(to, tokenId);
1211         }
1212     }
1213 
1214     /**
1215      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1216      * @param to address representing the new owner of the given token ID
1217      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1218      */
1219     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1220         uint256 length = ERC721.balanceOf(to);
1221         _ownedTokens[to][length] = tokenId;
1222         _ownedTokensIndex[tokenId] = length;
1223     }
1224 
1225     /**
1226      * @dev Private function to add a token to this extension's token tracking data structures.
1227      * @param tokenId uint256 ID of the token to be added to the tokens list
1228      */
1229     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1230         _allTokensIndex[tokenId] = _allTokens.length;
1231         _allTokens.push(tokenId);
1232     }
1233 
1234     /**
1235      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1236      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1237      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1238      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1239      * @param from address representing the previous owner of the given token ID
1240      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1241      */
1242     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1243         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1244         // then delete the last slot (swap and pop).
1245 
1246         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1247         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1248 
1249         // When the token to delete is the last token, the swap operation is unnecessary
1250         if (tokenIndex != lastTokenIndex) {
1251             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1252 
1253             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1254             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1255         }
1256 
1257         // This also deletes the contents at the last position of the array
1258         delete _ownedTokensIndex[tokenId];
1259         delete _ownedTokens[from][lastTokenIndex];
1260     }
1261 
1262     /**
1263      * @dev Private function to remove a token from this extension's token tracking data structures.
1264      * This has O(1) time complexity, but alters the order of the _allTokens array.
1265      * @param tokenId uint256 ID of the token to be removed from the tokens list
1266      */
1267     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1268         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1269         // then delete the last slot (swap and pop).
1270 
1271         uint256 lastTokenIndex = _allTokens.length - 1;
1272         uint256 tokenIndex = _allTokensIndex[tokenId];
1273 
1274         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1275         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1276         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1277         uint256 lastTokenId = _allTokens[lastTokenIndex];
1278 
1279         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1280         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1281 
1282         // This also deletes the contents at the last position of the array
1283         delete _allTokensIndex[tokenId];
1284         _allTokens.pop();
1285     }
1286 }
1287 
1288 
1289 // File @openzeppelin/contracts/security/Pausable.sol@v4.4.1
1290 
1291 
1292 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
1293 
1294 pragma solidity ^0.8.0;
1295 
1296 /**
1297  * @dev Contract module which allows children to implement an emergency stop
1298  * mechanism that can be triggered by an authorized account.
1299  *
1300  * This module is used through inheritance. It will make available the
1301  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1302  * the functions of your contract. Note that they will not be pausable by
1303  * simply including this module, only once the modifiers are put in place.
1304  */
1305 abstract contract Pausable is Context {
1306     /**
1307      * @dev Emitted when the pause is triggered by `account`.
1308      */
1309     event Paused(address account);
1310 
1311     /**
1312      * @dev Emitted when the pause is lifted by `account`.
1313      */
1314     event Unpaused(address account);
1315 
1316     bool private _paused;
1317 
1318     /**
1319      * @dev Initializes the contract in unpaused state.
1320      */
1321     constructor() {
1322         _paused = false;
1323     }
1324 
1325     /**
1326      * @dev Returns true if the contract is paused, and false otherwise.
1327      */
1328     function paused() public view virtual returns (bool) {
1329         return _paused;
1330     }
1331 
1332     /**
1333      * @dev Modifier to make a function callable only when the contract is not paused.
1334      *
1335      * Requirements:
1336      *
1337      * - The contract must not be paused.
1338      */
1339     modifier whenNotPaused() {
1340         require(!paused(), "Pausable: paused");
1341         _;
1342     }
1343 
1344     /**
1345      * @dev Modifier to make a function callable only when the contract is paused.
1346      *
1347      * Requirements:
1348      *
1349      * - The contract must be paused.
1350      */
1351     modifier whenPaused() {
1352         require(paused(), "Pausable: not paused");
1353         _;
1354     }
1355 
1356     /**
1357      * @dev Triggers stopped state.
1358      *
1359      * Requirements:
1360      *
1361      * - The contract must not be paused.
1362      */
1363     function _pause() internal virtual whenNotPaused {
1364         _paused = true;
1365         emit Paused(_msgSender());
1366     }
1367 
1368     /**
1369      * @dev Returns to normal state.
1370      *
1371      * Requirements:
1372      *
1373      * - The contract must be paused.
1374      */
1375     function _unpause() internal virtual whenPaused {
1376         _paused = false;
1377         emit Unpaused(_msgSender());
1378     }
1379 }
1380 
1381 
1382 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol@v4.4.1
1383 
1384 
1385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
1386 
1387 pragma solidity ^0.8.0;
1388 
1389 
1390 /**
1391  * @dev ERC721 token with pausable token transfers, minting and burning.
1392  *
1393  * Useful for scenarios such as preventing trades until the end of an evaluation
1394  * period, or having an emergency switch for freezing all token transfers in the
1395  * event of a large bug.
1396  */
1397 abstract contract ERC721Pausable is ERC721, Pausable {
1398     /**
1399      * @dev See {ERC721-_beforeTokenTransfer}.
1400      *
1401      * Requirements:
1402      *
1403      * - the contract must not be paused.
1404      */
1405     function _beforeTokenTransfer(
1406         address from,
1407         address to,
1408         uint256 tokenId
1409     ) internal virtual override {
1410         super._beforeTokenTransfer(from, to, tokenId);
1411 
1412         require(!paused(), "ERC721Pausable: token transfer while paused");
1413     }
1414 }
1415 
1416 
1417 // File contracts/Reveal.sol
1418 
1419 
1420 pragma solidity >=0.4.22 <0.9.0;
1421 
1422 
1423 contract Reveal is Ownable {
1424     using Strings for uint256;
1425 
1426     bool public revealed = false;
1427 
1428     string public baseURI;
1429     string public notRevealedUri;
1430     string public baseExtension = ".json";
1431 
1432     constructor() {
1433 
1434     }
1435 
1436     // Action
1437     function reveal() public onlyOwner {
1438         revealed = true;
1439     }
1440     // Set
1441     function setBaseURI(string calldata _tokenBaseURI) external onlyOwner {
1442         baseURI = _tokenBaseURI;
1443     }
1444 
1445     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1446         baseExtension = _newBaseExtension;
1447     }
1448 
1449     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1450         notRevealedUri = _notRevealedURI;
1451     }
1452     // View
1453     function getTokenURI(uint256 _tokenId, string memory _baseURI) internal view returns (string memory) {
1454         if (!revealed) {
1455             return notRevealedUri;
1456         }
1457 
1458         return
1459             bytes(_baseURI).length > 0
1460                 ? string(
1461                     abi.encodePacked(
1462                         _baseURI,
1463                         _tokenId.toString(),
1464                         baseExtension
1465                     )
1466                 )
1467                 : "";
1468     }
1469 }
1470 
1471 
1472 // File contracts/WhiteListSale.sol
1473 
1474 
1475 pragma solidity >=0.4.22 <0.9.0;
1476 
1477 contract WhiteListSale is Ownable {
1478     uint256 public constant PRE_MAX_QTY_PER_MINTER = 3; // 3
1479 
1480     bool public isWhiteListActive = false;
1481     
1482     mapping(address => uint256) public whiteList;
1483     mapping(address => bool) public whiteListBool;
1484 
1485     event WhiteListSetup(address[] addresses);
1486     event WhiteListDeleted(address[] addresses);
1487 
1488     constructor() {
1489 
1490     }
1491 
1492     modifier isWhiteListSaleActivity() {
1493         require(isWhiteListActive, "White list sale is not active.");
1494         _;
1495     }
1496 
1497     modifier nonWhiteListSaleActivity() {
1498         require(!isWhiteListActive, "White list sale is active,can't do it.");
1499         _;
1500     }
1501     // View
1502     function isWhiteListMinter(address _address) public view returns (bool) {
1503         return whiteListBool[_address];
1504     }
1505     // Action
1506     function setWhitListActive(bool _isAllowListActive) external onlyOwner {
1507         isWhiteListActive = _isAllowListActive;
1508     }
1509 
1510     function setWhiteList(address[] calldata addresses) external onlyOwner nonWhiteListSaleActivity {
1511         for (uint256 i = 0; i < addresses.length; i++) {
1512             whiteList[addresses[i]] = PRE_MAX_QTY_PER_MINTER;
1513             whiteListBool[addresses[i]] = true;
1514         }
1515         emit WhiteListSetup(addresses);
1516     }
1517 
1518     function deleteWhiteList(address[] calldata addresses) external onlyOwner {
1519         for (uint256 i = 0; i < addresses.length; i++) {
1520             delete whiteList[addresses[i]];
1521             whiteListBool[addresses[i]] = false;
1522         }
1523         emit WhiteListDeleted(addresses);
1524     }
1525 }
1526 
1527 
1528 // File contracts/Withdrawable.sol
1529 
1530 
1531 pragma solidity >=0.4.22 <0.9.0;
1532 
1533 contract Withdrawable is Ownable {
1534     constructor() {}
1535 
1536     function withdrawAll() external onlyOwner {
1537         require(address(this).balance > 0, "Withdrawble: No amount to withdraw");
1538         payable(msg.sender).transfer(address(this).balance);
1539     }
1540 }
1541 
1542 
1543 // File contracts/LionHeart.sol
1544 
1545 
1546 pragma solidity ^0.8.12;
1547 
1548 
1549 
1550 
1551 
1552 
1553 
1554 contract LionHeart is
1555     ERC721,
1556     ERC721Pausable,
1557     ERC721Enumerable,
1558     Ownable,
1559     WhiteListSale,
1560     Reveal,
1561     Withdrawable
1562 {
1563     using Strings for uint256;
1564     
1565     // QTY
1566     uint256 public constant TOTAL_MAX_QTY = 7300; // 7300
1567     uint256 public constant RESERVED_MAX_QTY = 15; // 15
1568     uint256 public constant PRESALE_MAX_QTY = 2190; // 2190
1569     uint256 public constant SALE_MAX_SUPPLY = TOTAL_MAX_QTY - PRESALE_MAX_QTY;
1570     // PerQTY
1571     uint256 public constant PUB_MAX_QTY_PER_MINTER = 7; // 7
1572     // Price
1573     uint256 public constant PRE_SALES_PRICE = PUBLIC_SALES_PRICE;
1574     uint256 public constant PUBLIC_SALES_PRICE = 0.3 ether;
1575 
1576     bool public isSaleActive = false;
1577     bool public isBurnEnabled = false;
1578 
1579     event SaleStarted();
1580     event SalePaused();
1581     event PubSaleMinted(address indexed minter, uint256 amount, uint256 supply);
1582     event PreSaleMinted(address indexed minter, uint256 amount, uint256 supply);
1583 
1584     constructor() ERC721("LionHeart", "LH") {
1585         
1586     }
1587 
1588     // Contract Status
1589     function startSale() external onlyOwner whenNotPaused {
1590         require(!isSaleActive, "Sale is already began");
1591         isSaleActive = true;
1592         isWhiteListActive = false;
1593         emit SaleStarted();
1594     }
1595 
1596     function pauseSale() external onlyOwner {
1597         require(isSaleActive, "Sale is already paused");
1598         isSaleActive = false;
1599         emit SalePaused();
1600     }
1601     
1602     // Action
1603     function reservedMint() external onlyOwner {
1604         uint256 supply = totalSupply();
1605         for (uint256 i = 0; i < RESERVED_MAX_QTY; i++) {
1606             _safeMint(msg.sender, supply + i);
1607         }
1608     }
1609 
1610     function preMint(uint256 _mintQty) external payable
1611         isWhiteListSaleActivity
1612     {
1613         uint256 supply = totalSupply();
1614         require(supply + _mintQty <= PRESALE_MAX_QTY, "Sale would exceed max supply");
1615         require(_mintQty <= PRE_MAX_QTY_PER_MINTER, "Sale would exceed max mint");
1616         require(_mintQty > 0, "Sale would exceed min mint");
1617         require(isWhiteListMinter(msg.sender), "Minter is not on the whitelist");
1618         require(whiteList[msg.sender] >= _mintQty, "Sale would exceed max presale quantity or remaining purchasable quantity");
1619         require(PRE_SALES_PRICE * _mintQty <= msg.value, "Not enough ether sent");
1620         
1621         for (uint256 i = 0; i < _mintQty; i++) {
1622             _safeMint(msg.sender, supply + i);
1623         }
1624         whiteList[msg.sender] -= _mintQty;
1625 
1626         emit PreSaleMinted(msg.sender, _mintQty, supply);
1627     }
1628 
1629     function mint(uint256 _mintQty) external payable {
1630         uint256 supply = totalSupply();
1631         require(isSaleActive, "Sale must be active to mint");
1632         require(supply + _mintQty <= TOTAL_MAX_QTY, "Sale would exceed max supply");
1633         require(_mintQty <= PUB_MAX_QTY_PER_MINTER, "Sale would exceed max mint");
1634         require(0 < _mintQty, "Sale would exceed min mint");
1635         uint256 QTY = PUB_MAX_QTY_PER_MINTER;
1636         if (whiteListBool[msg.sender]) {
1637             QTY = 10;
1638         }
1639         require(balanceOf(msg.sender) + _mintQty <= QTY, "Sale would exceed max balance");
1640         require(PUBLIC_SALES_PRICE * _mintQty <= msg.value, "Not enough ether sent");
1641         
1642         for (uint256 i = 0; i < _mintQty; i++) {
1643             _safeMint(msg.sender, supply + i);
1644         }
1645 
1646         emit PubSaleMinted(msg.sender, _mintQty, supply);
1647     }
1648 
1649     function setBurnEnabled(bool _isBurnEnabled) external onlyOwner {
1650         require(!isSaleActive, "Sale is in progress and cannot be burned NFT");
1651         isBurnEnabled = _isBurnEnabled;
1652     }
1653 
1654     function burn(uint256 tokenId) external {
1655         require(isBurnEnabled, "Burning disabled");
1656         require(_isApprovedOrOwner(msg.sender, tokenId), "Burn caller is not owner nor approved");
1657         _burn(tokenId);
1658     }
1659 
1660     /* Override */
1661     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1662         internal
1663         override(ERC721, ERC721Enumerable, ERC721Pausable)
1664     {
1665         super._beforeTokenTransfer(from, to, tokenId);
1666     }
1667 
1668     // EIP 165
1669     function supportsInterface(bytes4 interfaceId)
1670         public
1671         view
1672         override(ERC721, ERC721Enumerable)
1673         returns (bool)
1674     {
1675         return super.supportsInterface(interfaceId);
1676     }
1677 
1678     // TokenURI
1679     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1680         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1681         return getTokenURI(tokenId, _baseURI());
1682     }
1683 
1684     function _baseURI() internal view override returns (string memory) {
1685         return baseURI;
1686     }
1687 }