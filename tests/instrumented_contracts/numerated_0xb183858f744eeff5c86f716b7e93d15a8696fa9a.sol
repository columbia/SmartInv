1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-18
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 //import "../utils/Context.sol";
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 /**
111  * @dev Collection of functions related to the address type
112  */
113 library Address {
114     /**
115      * @dev Returns true if `account` is a contract.
116      *
117      * [IMPORTANT]
118      * ====
119      * It is unsafe to assume that an address for which this function returns
120      * false is an externally-owned account (EOA) and not a contract.
121      *
122      * Among others, `isContract` will return false for the following
123      * types of addresses:
124      *
125      *  - an externally-owned account
126      *  - a contract in construction
127      *  - an address where a contract will be created
128      *  - an address where a contract lived, but was destroyed
129      * ====
130      */
131     function isContract(address account) internal view returns (bool) {
132         // This method relies on extcodesize, which returns 0 for contracts in
133         // construction, since the code is only stored at the end of the
134         // constructor execution.
135 
136         uint256 size;
137         assembly {
138             size := extcodesize(account)
139         }
140         return size > 0;
141     }
142 
143     /**
144      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
145      * `recipient`, forwarding all available gas and reverting on errors.
146      *
147      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
148      * of certain opcodes, possibly making contracts go over the 2300 gas limit
149      * imposed by `transfer`, making them unable to receive funds via
150      * `transfer`. {sendValue} removes this limitation.
151      *
152      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
153      *
154      * IMPORTANT: because control is transferred to `recipient`, care must be
155      * taken to not create reentrancy vulnerabilities. Consider using
156      * {ReentrancyGuard} or the
157      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
158      */
159     function sendValue(address payable recipient, uint256 amount) internal {
160         require(address(this).balance >= amount, "Address: insufficient balance");
161 
162         (bool success, ) = recipient.call{value: amount}("");
163         require(success, "Address: unable to send value, recipient may have reverted");
164     }
165 
166     /**
167      * @dev Performs a Solidity function call using a low level `call`. A
168      * plain `call` is an unsafe replacement for a function call: use this
169      * function instead.
170      *
171      * If `target` reverts with a revert reason, it is bubbled up by this
172      * function (like regular Solidity function calls).
173      *
174      * Returns the raw returned data. To convert to the expected return value,
175      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
176      *
177      * Requirements:
178      *
179      * - `target` must be a contract.
180      * - calling `target` with `data` must not revert.
181      *
182      * _Available since v3.1._
183      */
184     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionCall(target, data, "Address: low-level call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
190      * `errorMessage` as a fallback revert reason when `target` reverts.
191      *
192      * _Available since v3.1._
193      */
194     function functionCall(
195         address target,
196         bytes memory data,
197         string memory errorMessage
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, 0, errorMessage);
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
204      * but also transferring `value` wei to `target`.
205      *
206      * Requirements:
207      *
208      * - the calling contract must have an ETH balance of at least `value`.
209      * - the called Solidity function must be `payable`.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
223      * with `errorMessage` as a fallback revert reason when `target` reverts.
224      *
225      * _Available since v3.1._
226      */
227     function functionCallWithValue(
228         address target,
229         bytes memory data,
230         uint256 value,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         require(address(this).balance >= value, "Address: insufficient balance for call");
234         require(isContract(target), "Address: call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.call{value: value}(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a static call.
243      *
244      * _Available since v3.3._
245      */
246     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
247         return functionStaticCall(target, data, "Address: low-level static call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal view returns (bytes memory) {
261         require(isContract(target), "Address: static call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.staticcall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
274         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a delegate call.
280      *
281      * _Available since v3.4._
282      */
283     function functionDelegateCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(isContract(target), "Address: delegate call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.delegatecall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
296      * revert reason using the provided one.
297      *
298      * _Available since v4.3._
299      */
300     function verifyCallResult(
301         bool success,
302         bytes memory returndata,
303         string memory errorMessage
304     ) internal pure returns (bytes memory) {
305         if (success) {
306             return returndata;
307         } else {
308             // Look for revert reason and bubble it up if present
309             if (returndata.length > 0) {
310                 // The easiest way to bubble the revert reason is using memory via assembly
311 
312                 assembly {
313                     let returndata_size := mload(returndata)
314                     revert(add(32, returndata), returndata_size)
315                 }
316             } else {
317                 revert(errorMessage);
318             }
319         }
320     }
321 }
322 
323 
324 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @title ERC721 token receiver interface
330  * @dev Interface for any contract that wants to support safeTransfers
331  * from ERC721 asset contracts.
332  */
333 interface IERC721Receiver {
334     /**
335      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
336      * by `operator` from `from`, this function is called.
337      *
338      * It must return its Solidity selector to confirm the token transfer.
339      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
340      *
341      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
342      */
343     function onERC721Received(
344         address operator,
345         address from,
346         uint256 tokenId,
347         bytes calldata data
348     ) external returns (bytes4);
349 }
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Interface of the ERC165 standard, as defined in the
358  * https://eips.ethereum.org/EIPS/eip-165[EIP].
359  *
360  * Implementers can declare support of contract interfaces, which can then be
361  * queried by others ({ERC165Checker}).
362  *
363  * For an implementation, see {ERC165}.
364  */
365 interface IERC165 {
366     /**
367      * @dev Returns true if this contract implements the interface defined by
368      * `interfaceId`. See the corresponding
369      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
370      * to learn more about how these ids are created.
371      *
372      * This function call must use less than 30 000 gas.
373      */
374     function supportsInterface(bytes4 interfaceId) external view returns (bool);
375 }
376 
377 
378 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 //import "./IERC165.sol";
383 
384 /**
385  * @dev Implementation of the {IERC165} interface.
386  *
387  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
388  * for the additional interface id that will be supported. For example:
389  *
390  * ```solidity
391  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
392  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
393  * }
394  * ```
395  *
396  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
397  */
398 abstract contract ERC165 is IERC165 {
399     /**
400      * @dev See {IERC165-supportsInterface}.
401      */
402     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
403         return interfaceId == type(IERC165).interfaceId;
404     }
405 }
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @dev String operations.
414  */
415 library Strings {
416     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
417 
418     /**
419      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
420      */
421     function toString(uint256 value) internal pure returns (string memory) {
422         // Inspired by OraclizeAPI's implementation - MIT licence
423         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
424 
425         if (value == 0) {
426             return "0";
427         }
428         uint256 temp = value;
429         uint256 digits;
430         while (temp != 0) {
431             digits++;
432             temp /= 10;
433         }
434         bytes memory buffer = new bytes(digits);
435         while (value != 0) {
436             digits -= 1;
437             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
438             value /= 10;
439         }
440         return string(buffer);
441     }
442 
443     /**
444      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
445      */
446     function toHexString(uint256 value) internal pure returns (string memory) {
447         if (value == 0) {
448             return "0x00";
449         }
450         uint256 temp = value;
451         uint256 length = 0;
452         while (temp != 0) {
453             length++;
454             temp >>= 8;
455         }
456         return toHexString(value, length);
457     }
458 
459     /**
460      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
461      */
462     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
463         bytes memory buffer = new bytes(2 * length + 2);
464         buffer[0] = "0";
465         buffer[1] = "x";
466         for (uint256 i = 2 * length + 1; i > 1; --i) {
467             buffer[i] = _HEX_SYMBOLS[value & 0xf];
468             value >>= 4;
469         }
470         require(value == 0, "Strings: hex length insufficient");
471         return string(buffer);
472     }
473 }
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 //import "../../utils/introspection/IERC165.sol";
481 
482 /**
483  * @dev Required interface of an ERC721 compliant contract.
484  */
485 interface IERC721 is IERC165 {
486     /**
487      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
488      */
489     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
490 
491     /**
492      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
493      */
494     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
495 
496     /**
497      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
498      */
499     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
500 
501     /**
502      * @dev Returns the number of tokens in ``owner``'s account.
503      */
504     function balanceOf(address owner) external view returns (uint256 balance);
505 
506     /**
507      * @dev Returns the owner of the `tokenId` token.
508      *
509      * Requirements:
510      *
511      * - `tokenId` must exist.
512      */
513     function ownerOf(uint256 tokenId) external view returns (address owner);
514 
515     /**
516      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
517      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
518      *
519      * Requirements:
520      *
521      * - `from` cannot be the zero address.
522      * - `to` cannot be the zero address.
523      * - `tokenId` token must exist and be owned by `from`.
524      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
526      *
527      * Emits a {Transfer} event.
528      */
529     function safeTransferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Transfers `tokenId` token from `from` to `to`.
537      *
538      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
539      *
540      * Requirements:
541      *
542      * - `from` cannot be the zero address.
543      * - `to` cannot be the zero address.
544      * - `tokenId` token must be owned by `from`.
545      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
546      *
547      * Emits a {Transfer} event.
548      */
549     function transferFrom(
550         address from,
551         address to,
552         uint256 tokenId
553     ) external;
554 
555     /**
556      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
557      * The approval is cleared when the token is transferred.
558      *
559      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
560      *
561      * Requirements:
562      *
563      * - The caller must own the token or be an approved operator.
564      * - `tokenId` must exist.
565      *
566      * Emits an {Approval} event.
567      */
568     function approve(address to, uint256 tokenId) external;
569 
570     /**
571      * @dev Returns the account approved for `tokenId` token.
572      *
573      * Requirements:
574      *
575      * - `tokenId` must exist.
576      */
577     function getApproved(uint256 tokenId) external view returns (address operator);
578 
579     /**
580      * @dev Approve or remove `operator` as an operator for the caller.
581      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
582      *
583      * Requirements:
584      *
585      * - The `operator` cannot be the caller.
586      *
587      * Emits an {ApprovalForAll} event.
588      */
589     function setApprovalForAll(address operator, bool _approved) external;
590 
591     /**
592      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
593      *
594      * See {setApprovalForAll}
595      */
596     function isApprovedForAll(address owner, address operator) external view returns (bool);
597 
598     /**
599      * @dev Safely transfers `tokenId` token from `from` to `to`.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId,
615         bytes calldata data
616     ) external;
617 }
618 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
619 
620 
621 
622 pragma solidity ^0.8.0;
623 
624 //import "../IERC721.sol";
625 
626 /**
627  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
628  * @dev See https://eips.ethereum.org/EIPS/eip-721
629  */
630 interface IERC721Metadata is IERC721 {
631     /**
632      * @dev Returns the token collection name.
633      */
634     function name() external view returns (string memory);
635 
636     /**
637      * @dev Returns the token collection symbol.
638      */
639     function symbol() external view returns (string memory);
640 
641     /**
642      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
643      */
644     function tokenURI(uint256 tokenId) external view returns (string memory);
645 }
646 
647 
648 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 //import "../IERC721.sol";
653 
654 /**
655  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
656  * @dev See https://eips.ethereum.org/EIPS/eip-721
657  */
658 interface IERC721Enumerable is IERC721 {
659     /**
660      * @dev Returns the total amount of tokens stored by the contract.
661      */
662     function totalSupply() external view returns (uint256);
663 
664     /**
665      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
666      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
667      */
668     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
669 
670     /**
671      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
672      * Use along with {totalSupply} to enumerate all tokens.
673      */
674     function tokenByIndex(uint256 index) external view returns (uint256);
675 }
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
679 
680 
681 
682 pragma solidity ^0.8.0;
683 
684 //import "./IERC721.sol";
685 //import "./IERC721Receiver.sol";
686 //import "./extensions/IERC721Metadata.sol";
687 //import "../../utils/Address.sol";
688 //import "../../utils/Context.sol";
689 //import "../../utils/Strings.sol";
690 //import "../../utils/introspection/ERC165.sol";
691 
692 /**
693  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
694  * the Metadata extension, but not including the Enumerable extension, which is available separately as
695  * {ERC721Enumerable}.
696  */
697 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
698     using Address for address;
699     using Strings for uint256;
700 
701     // Token name
702     string private _name;
703 
704     // Token symbol
705     string private _symbol;
706 
707     // Mapping from token ID to owner address
708     mapping(uint256 => address) private _owners;
709 
710     // Mapping owner address to token count
711     mapping(address => uint256) private _balances;
712 
713     // Mapping from token ID to approved address
714     mapping(uint256 => address) private _tokenApprovals;
715 
716     // Mapping from owner to operator approvals
717     mapping(address => mapping(address => bool)) private _operatorApprovals;
718 
719     /**
720      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
721      */
722     constructor(string memory name_, string memory symbol_) {
723         _name = name_;
724         _symbol = symbol_;
725     }
726 
727     /**
728      * @dev See {IERC165-supportsInterface}.
729      */
730     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
731         return
732             interfaceId == type(IERC721).interfaceId ||
733             interfaceId == type(IERC721Metadata).interfaceId ||
734             super.supportsInterface(interfaceId);
735     }
736 
737     /**
738      * @dev See {IERC721-balanceOf}.
739      */
740     function balanceOf(address owner) public view virtual override returns (uint256) {
741         require(owner != address(0), "ERC721: balance query for the zero address");
742         return _balances[owner];
743     }
744 
745     /**
746      * @dev See {IERC721-ownerOf}.
747      */
748     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
749         address owner = _owners[tokenId];
750         require(owner != address(0), "ERC721: owner query for nonexistent token");
751         return owner;
752     }
753 
754     /**
755      * @dev See {IERC721Metadata-name}.
756      */
757     function name() public view virtual override returns (string memory) {
758         return _name;
759     }
760 
761     /**
762      * @dev See {IERC721Metadata-symbol}.
763      */
764     function symbol() public view virtual override returns (string memory) {
765         return _symbol;
766     }
767 
768     /**
769      * @dev See {IERC721Metadata-tokenURI}.
770      */
771     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
772         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
773 
774         string memory baseURI = _baseURI();
775         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
776     }
777 
778     /**
779      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
780      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
781      * by default, can be overriden in child contracts.
782      */
783     function _baseURI() internal view virtual returns (string memory) {
784         return "";
785     }
786 
787     /**
788      * @dev See {IERC721-approve}.
789      */
790     function approve(address to, uint256 tokenId) public virtual override {
791         address owner = ERC721.ownerOf(tokenId);
792         require(to != owner, "ERC721: approval to current owner");
793 
794         require(
795             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
796             "ERC721: approve caller is not owner nor approved for all"
797         );
798 
799         _approve(to, tokenId);
800     }
801 
802     /**
803      * @dev See {IERC721-getApproved}.
804      */
805     function getApproved(uint256 tokenId) public view virtual override returns (address) {
806         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
807 
808         return _tokenApprovals[tokenId];
809     }
810 
811     /**
812      * @dev See {IERC721-setApprovalForAll}.
813      */
814     function setApprovalForAll(address operator, bool approved) public virtual override {
815         _setApprovalForAll(_msgSender(), operator, approved);
816     }
817 
818     /**
819      * @dev See {IERC721-isApprovedForAll}.
820      */
821     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
822         return _operatorApprovals[owner][operator];
823     }
824 
825     /**
826      * @dev See {IERC721-transferFrom}.
827      */
828     function transferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) public virtual override {
833         //solhint-disable-next-line max-line-length
834         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
835 
836         _transfer(from, to, tokenId);
837     }
838 
839     /**
840      * @dev See {IERC721-safeTransferFrom}.
841      */
842     function safeTransferFrom(
843         address from,
844         address to,
845         uint256 tokenId
846     ) public virtual override {
847         safeTransferFrom(from, to, tokenId, "");
848     }
849 
850     /**
851      * @dev See {IERC721-safeTransferFrom}.
852      */
853     function safeTransferFrom(
854         address from,
855         address to,
856         uint256 tokenId,
857         bytes memory _data
858     ) public virtual override {
859         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
860         _safeTransfer(from, to, tokenId, _data);
861     }
862 
863     /**
864      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
865      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
866      *
867      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
868      *
869      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
870      * implement alternative mechanisms to perform token transfer, such as signature-based.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must exist and be owned by `from`.
877      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
878      *
879      * Emits a {Transfer} event.
880      */
881     function _safeTransfer(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) internal virtual {
887         _transfer(from, to, tokenId);
888         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
889     }
890 
891     /**
892      * @dev Returns whether `tokenId` exists.
893      *
894      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
895      *
896      * Tokens start existing when they are minted (`_mint`),
897      * and stop existing when they are burned (`_burn`).
898      */
899     function _exists(uint256 tokenId) internal view virtual returns (bool) {
900         return _owners[tokenId] != address(0);
901     }
902 
903     /**
904      * @dev Returns whether `spender` is allowed to manage `tokenId`.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must exist.
909      */
910     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
911         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
912         address owner = ERC721.ownerOf(tokenId);
913         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
914     }
915 
916     /**
917      * @dev Safely mints `tokenId` and transfers it to `to`.
918      *
919      * Requirements:
920      *
921      * - `tokenId` must not exist.
922      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
923      *
924      * Emits a {Transfer} event.
925      */
926     function _safeMint(address to, uint256 tokenId) internal virtual {
927         _safeMint(to, tokenId, "");
928     }
929 
930     /**
931      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
932      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
933      */
934     function _safeMint(
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) internal virtual {
939         _mint(to, tokenId);
940         require(
941             _checkOnERC721Received(address(0), to, tokenId, _data),
942             "ERC721: transfer to non ERC721Receiver implementer"
943         );
944     }
945 
946     /**
947      * @dev Mints `tokenId` and transfers it to `to`.
948      *
949      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
950      *
951      * Requirements:
952      *
953      * - `tokenId` must not exist.
954      * - `to` cannot be the zero address.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _mint(address to, uint256 tokenId) internal virtual {
959         require(to != address(0), "ERC721: mint to the zero address");
960         require(!_exists(tokenId), "ERC721: token already minted");
961 
962         _beforeTokenTransfer(address(0), to, tokenId);
963 
964         _balances[to] += 1;
965         _owners[tokenId] = to;
966 
967         emit Transfer(address(0), to, tokenId);
968     }
969 
970     /**
971      * @dev Destroys `tokenId`.
972      * The approval is cleared when the token is burned.
973      *
974      * Requirements:
975      *
976      * - `tokenId` must exist.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _burn(uint256 tokenId) internal virtual {
981         address owner = ERC721.ownerOf(tokenId);
982 
983         _beforeTokenTransfer(owner, address(0), tokenId);
984 
985         // Clear approvals
986         _approve(address(0), tokenId);
987 
988         _balances[owner] -= 1;
989         delete _owners[tokenId];
990 
991         emit Transfer(owner, address(0), tokenId);
992     }
993 
994     /**
995      * @dev Transfers `tokenId` from `from` to `to`.
996      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
997      *
998      * Requirements:
999      *
1000      * - `to` cannot be the zero address.
1001      * - `tokenId` token must be owned by `from`.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function _transfer(
1006         address from,
1007         address to,
1008         uint256 tokenId
1009     ) internal virtual {
1010         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1011         require(to != address(0), "ERC721: transfer to the zero address");
1012 
1013         _beforeTokenTransfer(from, to, tokenId);
1014 
1015         // Clear approvals from the previous owner
1016         _approve(address(0), tokenId);
1017 
1018         _balances[from] -= 1;
1019         _balances[to] += 1;
1020         _owners[tokenId] = to;
1021 
1022         emit Transfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev Approve `to` to operate on `tokenId`
1027      *
1028      * Emits a {Approval} event.
1029      */
1030     function _approve(address to, uint256 tokenId) internal virtual {
1031         _tokenApprovals[tokenId] = to;
1032         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1033     }
1034 
1035     /**
1036      * @dev Approve `operator` to operate on all of `owner` tokens
1037      *
1038      * Emits a {ApprovalForAll} event.
1039      */
1040     function _setApprovalForAll(
1041         address owner,
1042         address operator,
1043         bool approved
1044     ) internal virtual {
1045         require(owner != operator, "ERC721: approve to caller");
1046         _operatorApprovals[owner][operator] = approved;
1047         emit ApprovalForAll(owner, operator, approved);
1048     }
1049 
1050     /**
1051      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1052      * The call is not executed if the target address is not a contract.
1053      *
1054      * @param from address representing the previous owner of the given token ID
1055      * @param to target address that will receive the tokens
1056      * @param tokenId uint256 ID of the token to be transferred
1057      * @param _data bytes optional data to send along with the call
1058      * @return bool whether the call correctly returned the expected magic value
1059      */
1060     function _checkOnERC721Received(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) private returns (bool) {
1066         if (to.isContract()) {
1067             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1068                 return retval == IERC721Receiver.onERC721Received.selector;
1069             } catch (bytes memory reason) {
1070                 if (reason.length == 0) {
1071                     revert("ERC721: transfer to non ERC721Receiver implementer");
1072                 } else {
1073                     assembly {
1074                         revert(add(32, reason), mload(reason))
1075                     }
1076                 }
1077             }
1078         } else {
1079             return true;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before any token transfer. This includes minting
1085      * and burning.
1086      *
1087      * Calling conditions:
1088      *
1089      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1090      * transferred to `to`.
1091      * - When `from` is zero, `tokenId` will be minted for `to`.
1092      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1093      * - `from` and `to` are never both zero.
1094      *
1095      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1096      */
1097     function _beforeTokenTransfer(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) internal virtual {}
1102 }
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 //import "../ERC721.sol";
1107 //import "./IERC721Enumerable.sol";
1108 
1109 /**
1110  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1111  * enumerability of all the token ids in the contract as well as all token ids owned by each
1112  * account.
1113  */
1114 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1115     // Mapping from owner to list of owned token IDs
1116     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1117 
1118     // Mapping from token ID to index of the owner tokens list
1119     mapping(uint256 => uint256) private _ownedTokensIndex;
1120 
1121     // Array with all token ids, used for enumeration
1122     uint256[] private _allTokens;
1123 
1124     // Mapping from token id to position in the allTokens array
1125     mapping(uint256 => uint256) private _allTokensIndex;
1126 
1127     /**
1128      * @dev See {IERC165-supportsInterface}.
1129      */
1130     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1131         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1136      */
1137     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1138         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1139         return _ownedTokens[owner][index];
1140     }
1141 
1142     /**
1143      * @dev See {IERC721Enumerable-totalSupply}.
1144      */
1145     function totalSupply() public view virtual override returns (uint256) {
1146         return _allTokens.length;
1147     }
1148 
1149     /**
1150      * @dev See {IERC721Enumerable-tokenByIndex}.
1151      */
1152     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1153         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1154         return _allTokens[index];
1155     }
1156 
1157     /**
1158      * @dev Hook that is called before any token transfer. This includes minting
1159      * and burning.
1160      *
1161      * Calling conditions:
1162      *
1163      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1164      * transferred to `to`.
1165      * - When `from` is zero, `tokenId` will be minted for `to`.
1166      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1167      * - `from` cannot be the zero address.
1168      * - `to` cannot be the zero address.
1169      *
1170      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1171      */
1172     function _beforeTokenTransfer(
1173         address from,
1174         address to,
1175         uint256 tokenId
1176     ) internal virtual override {
1177         super._beforeTokenTransfer(from, to, tokenId);
1178 
1179         if (from == address(0)) {
1180             _addTokenToAllTokensEnumeration(tokenId);
1181         } else if (from != to) {
1182             _removeTokenFromOwnerEnumeration(from, tokenId);
1183         }
1184         if (to == address(0)) {
1185             _removeTokenFromAllTokensEnumeration(tokenId);
1186         } else if (to != from) {
1187             _addTokenToOwnerEnumeration(to, tokenId);
1188         }
1189     }
1190 
1191     /**
1192      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1193      * @param to address representing the new owner of the given token ID
1194      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1195      */
1196     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1197         uint256 length = ERC721.balanceOf(to);
1198         _ownedTokens[to][length] = tokenId;
1199         _ownedTokensIndex[tokenId] = length;
1200     }
1201 
1202     /**
1203      * @dev Private function to add a token to this extension's token tracking data structures.
1204      * @param tokenId uint256 ID of the token to be added to the tokens list
1205      */
1206     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1207         _allTokensIndex[tokenId] = _allTokens.length;
1208         _allTokens.push(tokenId);
1209     }
1210 
1211     /**
1212      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1213      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1214      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1215      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1216      * @param from address representing the previous owner of the given token ID
1217      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1218      */
1219     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1220         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1221         // then delete the last slot (swap and pop).
1222 
1223         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1224         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1225 
1226         // When the token to delete is the last token, the swap operation is unnecessary
1227         if (tokenIndex != lastTokenIndex) {
1228             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1229 
1230             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1231             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1232         }
1233 
1234         // This also deletes the contents at the last position of the array
1235         delete _ownedTokensIndex[tokenId];
1236         delete _ownedTokens[from][lastTokenIndex];
1237     }
1238 
1239     /**
1240      * @dev Private function to remove a token from this extension's token tracking data structures.
1241      * This has O(1) time complexity, but alters the order of the _allTokens array.
1242      * @param tokenId uint256 ID of the token to be removed from the tokens list
1243      */
1244     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1245         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1246         // then delete the last slot (swap and pop).
1247 
1248         uint256 lastTokenIndex = _allTokens.length - 1;
1249         uint256 tokenIndex = _allTokensIndex[tokenId];
1250 
1251         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1252         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1253         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1254         uint256 lastTokenId = _allTokens[lastTokenIndex];
1255 
1256         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1257         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1258 
1259         // This also deletes the contents at the last position of the array
1260         delete _allTokensIndex[tokenId];
1261         _allTokens.pop();
1262     }
1263 }
1264 
1265 
1266 
1267 
1268 pragma solidity ^0.8.0;
1269 
1270 //import '@openzeppelin/contracts/access/Ownable.sol';
1271 //import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
1272 //import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
1273 
1274 contract Sloth is ERC721, ERC721Enumerable, Ownable {
1275   using Strings for uint256;
1276   bool public _isWhiteListSaleActive = false;
1277   bool public _isSaleActive = false;
1278 
1279   // Constants
1280   uint256 constant public MAX_SUPPLY = 2022;
1281   uint256 public mintPrice = 0.08 ether;
1282   uint256 public whiteListPrice = 0.06 ether;
1283   uint256 public maxwhitelistBalance = 2;
1284   uint256 public revealTimeStamp = block.timestamp+86400*14 ; 
1285 
1286 
1287   string private _baseURIExtended;
1288   string private _preRevealURI;
1289 
1290   mapping(address => uint256) public whiteList;
1291   
1292 
1293   event TokenMinted(uint256 supply);
1294 
1295   constructor() ERC721('Swag Sloth', 'SLOTH') {}
1296 //ok
1297   function flipWhiteListSaleActive() public onlyOwner {
1298     _isWhiteListSaleActive = !_isWhiteListSaleActive;
1299   }
1300 //ok
1301   function filpSaleActive() public onlyOwner {
1302     _isSaleActive = !_isSaleActive;
1303   }
1304 
1305 //ok
1306   function setMintPrice(uint256 _mintPrice) public onlyOwner {
1307     mintPrice = _mintPrice;
1308   }
1309 
1310   function setWhiteListPrice(uint256 _whiteListPrice) public onlyOwner {
1311     whiteListPrice = _whiteListPrice;
1312   }
1313 
1314 
1315 //ok
1316   function setWhiteList(address[] calldata _whiteList) external onlyOwner {
1317     for(uint i = 0; i < _whiteList.length; i++) {
1318       whiteList[_whiteList[i]] = maxwhitelistBalance;
1319     }
1320   }
1321 
1322 //ok
1323   function withdraw(address to) public onlyOwner {
1324     uint256 balance = address(this).balance;
1325     payable(to).transfer(balance);
1326   }
1327 //ok
1328   function preserveMint(uint numSloths, address to) public onlyOwner {
1329     require(totalSupply() + numSloths <= MAX_SUPPLY, 'Preserve mint would exceed max supply');
1330     _mintSloth(numSloths, to);
1331     emit TokenMinted(totalSupply());
1332   }
1333 //ok
1334   function getTotalSupply() public view returns (uint256) {
1335     return totalSupply();
1336   }
1337 //ok
1338   function getSlothByOwner(address _owner) public view returns (uint256[] memory) {
1339     uint256 tokenCount = balanceOf(_owner);
1340     uint256[] memory tokenIds = new uint256[](tokenCount);
1341     for (uint256 i; i < tokenCount; i++) {
1342       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1343     }
1344     return tokenIds;
1345   }
1346 
1347 //ok
1348   function mintSloths(uint numSloths) public payable {
1349     require(_isSaleActive, 'Sale must be active to mint Sloths');
1350     require(totalSupply() + numSloths <= MAX_SUPPLY, 'Sale would exceed max supply');
1351     require(numSloths * mintPrice <= msg.value, 'Not enough ether sent');
1352     _mintSloth(numSloths, msg.sender);
1353     emit TokenMinted(totalSupply());
1354   }
1355   //ok
1356   function setRevealTimestamp(uint256 newRevealTimeStamp) external onlyOwner {
1357     revealTimeStamp = newRevealTimeStamp;
1358   }
1359 
1360   function whiteListMintSloths(uint numSloths) public payable {
1361     require(_isWhiteListSaleActive, 'Sale must be active to mint Sloths');
1362     require(totalSupply() + numSloths <= MAX_SUPPLY, 'Sale would exceed max supply');
1363     require(balanceOf(msg.sender) + numSloths <= maxwhitelistBalance, 'Sale would exceed max Whitelist balance');
1364     uint256 price = whiteListPrice;
1365     require(numSloths * price <= msg.value, 'Not enough ether sent');
1366     if (whiteList[msg.sender] == 2) {
1367     price = whiteListPrice;
1368     whiteList[msg.sender] = maxwhitelistBalance-numSloths;
1369     } 
1370     else if(whiteList[msg.sender] == 1){
1371       require(numSloths == 1,'Something Wrong');
1372       price = whiteListPrice;
1373     whiteList[msg.sender] = 0;
1374     }
1375     else if(whiteList[msg.sender] == 0){
1376       revert('You have no more whitelist');
1377     }
1378     else  {
1379     revert('Not in white list');
1380     }
1381     
1382     
1383     _mintSloth(numSloths, msg.sender);
1384     emit TokenMinted(totalSupply());
1385   }
1386 
1387 //ok
1388   function _mintSloth(uint256 numSloths, address recipient) internal {
1389     uint256 supply = totalSupply();
1390     for (uint256 i = 0; i < numSloths; i++) {
1391       _safeMint(recipient, supply + i);
1392     }
1393   }
1394 //ok
1395   function setBaseURI(string memory baseURI_) external onlyOwner {
1396     _baseURIExtended = baseURI_;
1397   }
1398 //ok
1399   function _baseURI() internal view virtual override returns (string memory) {
1400     return _baseURIExtended;
1401   }
1402 //ok
1403   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1404     require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1405     if (totalSupply() >= MAX_SUPPLY || block.timestamp >= revealTimeStamp) {
1406       if (tokenId < MAX_SUPPLY) {
1407         return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
1408       } 
1409     }
1410     else if(totalSupply() >= 1500){
1411       if (tokenId < 1500) {
1412         return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
1413       } 
1414     }
1415     else if(totalSupply() >= 1020){
1416       if (tokenId < 1020) {
1417         return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
1418       } 
1419     }
1420     else if(totalSupply() >= 666){
1421       if (tokenId < 666) {
1422         return string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"));
1423       } 
1424     }
1425     {
1426       return _preRevealURI;
1427     }
1428   }
1429 //ok
1430   function setPreRevealURI(string memory preRevealURI) external onlyOwner {
1431     _preRevealURI = preRevealURI;
1432   }
1433 
1434 //ok
1435   function _beforeTokenTransfer(
1436     address from,
1437     address to,
1438     uint256 tokenId
1439   ) internal override(ERC721, ERC721Enumerable) {
1440     super._beforeTokenTransfer(from, to, tokenId);
1441   }
1442 //ok
1443   function supportsInterface(bytes4 interfaceId)
1444     public
1445     view
1446     override(ERC721, ERC721Enumerable)
1447     returns (bool)
1448   {
1449     return super.supportsInterface(interfaceId);
1450   }
1451 }