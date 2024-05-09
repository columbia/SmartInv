1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-03
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Strings.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 // File: @openzeppelin/contracts/utils/Context.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @dev Provides information about the current execution context, including the
85  * sender of the transaction and its data. While these are generally available
86  * via msg.sender and msg.data, they should not be accessed in such a direct
87  * manner, since when dealing with meta-transactions the account sending and
88  * paying for execution may not be the actual sender (as far as an application
89  * is concerned).
90  *
91  * This contract is only required for intermediate, library-like contracts.
92  */
93 abstract contract Context {
94     function _msgSender() internal view virtual returns (address) {
95         return msg.sender;
96     }
97 
98     function _msgData() internal view virtual returns (bytes calldata) {
99         return msg.data;
100     }
101 }
102 
103 // File: @openzeppelin/contracts/access/Ownable.sol
104 
105 
106 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
107 
108 pragma solidity ^0.8.0;
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view virtual returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public virtual onlyOwner {
158         _transferOwnership(address(0));
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Can only be called by the current owner.
164      */
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         _transferOwnership(newOwner);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Internal function without access restriction.
173      */
174     function _transferOwnership(address newOwner) internal virtual {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180 
181 // File: @openzeppelin/contracts/utils/Address.sol
182 
183 
184 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
185 
186 pragma solidity ^0.8.1;
187 
188 /**
189  * @dev Collection of functions related to the address type
190  */
191 library Address {
192     /**
193      * @dev Returns true if `account` is a contract.
194      *
195      * [IMPORTANT]
196      * ====
197      * It is unsafe to assume that an address for which this function returns
198      * false is an externally-owned account (EOA) and not a contract.
199      *
200      * Among others, `isContract` will return false for the following
201      * types of addresses:
202      *
203      *  - an externally-owned account
204      *  - a contract in construction
205      *  - an address where a contract will be created
206      *  - an address where a contract lived, but was destroyed
207      * ====
208      *
209      * [IMPORTANT]
210      * ====
211      * You shouldn't rely on `isContract` to protect against flash loan attacks!
212      *
213      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
214      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
215      * constructor.
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize/address.code.length, which returns 0
220         // for contracts in construction, since the code is only stored at the end
221         // of the constructor execution.
222 
223         return account.code.length > 0;
224     }
225 
226     /**
227      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
228      * `recipient`, forwarding all available gas and reverting on errors.
229      *
230      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
231      * of certain opcodes, possibly making contracts go over the 2300 gas limit
232      * imposed by `transfer`, making them unable to receive funds via
233      * `transfer`. {sendValue} removes this limitation.
234      *
235      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
236      *
237      * IMPORTANT: because control is transferred to `recipient`, care must be
238      * taken to not create reentrancy vulnerabilities. Consider using
239      * {ReentrancyGuard} or the
240      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
241      */
242     function sendValue(address payable recipient, uint256 amount) internal {
243         require(address(this).balance >= amount, "Address: insufficient balance");
244 
245         (bool success, ) = recipient.call{value: amount}("");
246         require(success, "Address: unable to send value, recipient may have reverted");
247     }
248 
249     /**
250      * @dev Performs a Solidity function call using a low level `call`. A
251      * plain `call` is an unsafe replacement for a function call: use this
252      * function instead.
253      *
254      * If `target` reverts with a revert reason, it is bubbled up by this
255      * function (like regular Solidity function calls).
256      *
257      * Returns the raw returned data. To convert to the expected return value,
258      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
259      *
260      * Requirements:
261      *
262      * - `target` must be a contract.
263      * - calling `target` with `data` must not revert.
264      *
265      * _Available since v3.1._
266      */
267     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
268         return functionCall(target, data, "Address: low-level call failed");
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
273      * `errorMessage` as a fallback revert reason when `target` reverts.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(
278         address target,
279         bytes memory data,
280         string memory errorMessage
281     ) internal returns (bytes memory) {
282         return functionCallWithValue(target, data, 0, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but also transferring `value` wei to `target`.
288      *
289      * Requirements:
290      *
291      * - the calling contract must have an ETH balance of at least `value`.
292      * - the called Solidity function must be `payable`.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value
300     ) internal returns (bytes memory) {
301         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
306      * with `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCallWithValue(
311         address target,
312         bytes memory data,
313         uint256 value,
314         string memory errorMessage
315     ) internal returns (bytes memory) {
316         require(address(this).balance >= value, "Address: insufficient balance for call");
317         require(isContract(target), "Address: call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.call{value: value}(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but performing a static call.
326      *
327      * _Available since v3.3._
328      */
329     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
330         return functionStaticCall(target, data, "Address: low-level static call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal view returns (bytes memory) {
344         require(isContract(target), "Address: static call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(
367         address target,
368         bytes memory data,
369         string memory errorMessage
370     ) internal returns (bytes memory) {
371         require(isContract(target), "Address: delegate call to non-contract");
372 
373         (bool success, bytes memory returndata) = target.delegatecall(data);
374         return verifyCallResult(success, returndata, errorMessage);
375     }
376 
377     /**
378      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
379      * revert reason using the provided one.
380      *
381      * _Available since v4.3._
382      */
383     function verifyCallResult(
384         bool success,
385         bytes memory returndata,
386         string memory errorMessage
387     ) internal pure returns (bytes memory) {
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
407 
408 
409 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
410 
411 pragma solidity ^0.8.0;
412 
413 /**
414  * @title ERC721 token receiver interface
415  * @dev Interface for any contract that wants to support safeTransfers
416  * from ERC721 asset contracts.
417  */
418 interface IERC721Receiver {
419     /**
420      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
421      * by `operator` from `from`, this function is called.
422      *
423      * It must return its Solidity selector to confirm the token transfer.
424      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
425      *
426      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
427      */
428     function onERC721Received(
429         address operator,
430         address from,
431         uint256 tokenId,
432         bytes calldata data
433     ) external returns (bytes4);
434 }
435 
436 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
437 
438 
439 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 /**
444  * @dev Interface of the ERC165 standard, as defined in the
445  * https://eips.ethereum.org/EIPS/eip-165[EIP].
446  *
447  * Implementers can declare support of contract interfaces, which can then be
448  * queried by others ({ERC165Checker}).
449  *
450  * For an implementation, see {ERC165}.
451  */
452 interface IERC165 {
453     /**
454      * @dev Returns true if this contract implements the interface defined by
455      * `interfaceId`. See the corresponding
456      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
457      * to learn more about how these ids are created.
458      *
459      * This function call must use less than 30 000 gas.
460      */
461     function supportsInterface(bytes4 interfaceId) external view returns (bool);
462 }
463 
464 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
465 
466 
467 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
468 
469 pragma solidity ^0.8.0;
470 
471 
472 /**
473  * @dev Implementation of the {IERC165} interface.
474  *
475  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
476  * for the additional interface id that will be supported. For example:
477  *
478  * ```solidity
479  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
480  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
481  * }
482  * ```
483  *
484  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
485  */
486 abstract contract ERC165 is IERC165 {
487     /**
488      * @dev See {IERC165-supportsInterface}.
489      */
490     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
491         return interfaceId == type(IERC165).interfaceId;
492     }
493 }
494 
495 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
496 
497 
498 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 
503 /**
504  * @dev Required interface of an ERC721 compliant contract.
505  */
506 interface IERC721 is IERC165 {
507     /**
508      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
509      */
510     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
511 
512     /**
513      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
514      */
515     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
516 
517     /**
518      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
519      */
520     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
521 
522     /**
523      * @dev Returns the number of tokens in ``owner``'s account.
524      */
525     function balanceOf(address owner) external view returns (uint256 balance);
526 
527     /**
528      * @dev Returns the owner of the `tokenId` token.
529      *
530      * Requirements:
531      *
532      * - `tokenId` must exist.
533      */
534     function ownerOf(uint256 tokenId) external view returns (address owner);
535 
536     /**
537      * @dev Safely transfers `tokenId` token from `from` to `to`.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must exist and be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
546      *
547      * Emits a {Transfer} event.
548      */
549     function safeTransferFrom(
550         address from,
551         address to,
552         uint256 tokenId,
553         bytes calldata data
554     ) external;
555 
556     /**
557      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
558      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
559      *
560      * Requirements:
561      *
562      * - `from` cannot be the zero address.
563      * - `to` cannot be the zero address.
564      * - `tokenId` token must exist and be owned by `from`.
565      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
566      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
567      *
568      * Emits a {Transfer} event.
569      */
570     function safeTransferFrom(
571         address from,
572         address to,
573         uint256 tokenId
574     ) external;
575 
576     /**
577      * @dev Transfers `tokenId` token from `from` to `to`.
578      *
579      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must be owned by `from`.
586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
587      *
588      * Emits a {Transfer} event.
589      */
590     function transferFrom(
591         address from,
592         address to,
593         uint256 tokenId
594     ) external;
595 
596     /**
597      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
598      * The approval is cleared when the token is transferred.
599      *
600      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
601      *
602      * Requirements:
603      *
604      * - The caller must own the token or be an approved operator.
605      * - `tokenId` must exist.
606      *
607      * Emits an {Approval} event.
608      */
609     function approve(address to, uint256 tokenId) external;
610 
611     /**
612      * @dev Approve or remove `operator` as an operator for the caller.
613      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
614      *
615      * Requirements:
616      *
617      * - The `operator` cannot be the caller.
618      *
619      * Emits an {ApprovalForAll} event.
620      */
621     function setApprovalForAll(address operator, bool _approved) external;
622 
623     /**
624      * @dev Returns the account approved for `tokenId` token.
625      *
626      * Requirements:
627      *
628      * - `tokenId` must exist.
629      */
630     function getApproved(uint256 tokenId) external view returns (address operator);
631 
632     /**
633      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
634      *
635      * See {setApprovalForAll}
636      */
637     function isApprovedForAll(address owner, address operator) external view returns (bool);
638 }
639 
640 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
641 
642 
643 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 interface IERC721Enumerable is IERC721 {
653     /**
654      * @dev Returns the total amount of tokens stored by the contract.
655      */
656     function totalSupply() external view returns (uint256);
657 
658     /**
659      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
660      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
661      */
662     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
663 
664     /**
665      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
666      * Use along with {totalSupply} to enumerate all tokens.
667      */
668     function tokenByIndex(uint256 index) external view returns (uint256);
669 }
670 
671 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
672 
673 
674 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 
679 /**
680  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
681  * @dev See https://eips.ethereum.org/EIPS/eip-721
682  */
683 interface IERC721Metadata is IERC721 {
684     /**
685      * @dev Returns the token collection name.
686      */
687     function name() external view returns (string memory);
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() external view returns (string memory);
693 
694     /**
695      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
696      */
697     function tokenURI(uint256 tokenId) external view returns (string memory);
698 }
699 
700 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
701 
702 
703 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 
708 
709 
710 
711 
712 
713 
714 /**
715  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
716  * the Metadata extension, but not including the Enumerable extension, which is available separately as
717  * {ERC721Enumerable}.
718  */
719 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
720     using Address for address;
721     using Strings for uint256;
722 
723     // Token name
724     string private _name;
725 
726     // Token symbol
727     string private _symbol;
728 
729     // Mapping from token ID to owner address
730     mapping(uint256 => address) private _owners;
731 
732     // Mapping owner address to token count
733     mapping(address => uint256) private _balances;
734 
735     // Mapping from token ID to approved address
736     mapping(uint256 => address) private _tokenApprovals;
737 
738     // Mapping from owner to operator approvals
739     mapping(address => mapping(address => bool)) private _operatorApprovals;
740 
741     /**
742      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
743      */
744     constructor(string memory name_, string memory symbol_) {
745         _name = name_;
746         _symbol = symbol_;
747     }
748 
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
753         return
754             interfaceId == type(IERC721).interfaceId ||
755             interfaceId == type(IERC721Metadata).interfaceId ||
756             super.supportsInterface(interfaceId);
757     }
758 
759     /**
760      * @dev See {IERC721-balanceOf}.
761      */
762     function balanceOf(address owner) public view virtual override returns (uint256) {
763         require(owner != address(0), "ERC721: balance query for the zero address");
764         return _balances[owner];
765     }
766 
767     /**
768      * @dev See {IERC721-ownerOf}.
769      */
770     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
771         address owner = _owners[tokenId];
772         require(owner != address(0), "ERC721: owner query for nonexistent token");
773         return owner;
774     }
775 
776     /**
777      * @dev See {IERC721Metadata-name}.
778      */
779     function name() public view virtual override returns (string memory) {
780         return _name;
781     }
782 
783     /**
784      * @dev See {IERC721Metadata-symbol}.
785      */
786     function symbol() public view virtual override returns (string memory) {
787         return _symbol;
788     }
789 
790     /**
791      * @dev See {IERC721Metadata-tokenURI}.
792      */
793     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
794         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
795 
796         string memory baseURI = _baseURI();
797         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
798     }
799 
800     /**
801      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
802      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
803      * by default, can be overridden in child contracts.
804      */
805     function _baseURI() internal view virtual returns (string memory) {
806         return "";
807     }
808 
809     /**
810      * @dev See {IERC721-approve}.
811      */
812     function approve(address to, uint256 tokenId) public virtual override {
813         address owner = ERC721.ownerOf(tokenId);
814         require(to != owner, "ERC721: approval to current owner");
815 
816         require(
817             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
818             "ERC721: approve caller is not owner nor approved for all"
819         );
820 
821         _approve(to, tokenId);
822     }
823 
824     /**
825      * @dev See {IERC721-getApproved}.
826      */
827     function getApproved(uint256 tokenId) public view virtual override returns (address) {
828         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
829 
830         return _tokenApprovals[tokenId];
831     }
832 
833     /**
834      * @dev See {IERC721-setApprovalForAll}.
835      */
836     function setApprovalForAll(address operator, bool approved) public virtual override {
837         _setApprovalForAll(_msgSender(), operator, approved);
838     }
839 
840     /**
841      * @dev See {IERC721-isApprovedForAll}.
842      */
843     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
844         return _operatorApprovals[owner][operator];
845     }
846 
847     /**
848      * @dev See {IERC721-transferFrom}.
849      */
850     function transferFrom(
851         address from,
852         address to,
853         uint256 tokenId
854     ) public virtual override {
855         //solhint-disable-next-line max-line-length
856         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
857 
858         _transfer(from, to, tokenId);
859     }
860 
861     /**
862      * @dev See {IERC721-safeTransferFrom}.
863      */
864     function safeTransferFrom(
865         address from,
866         address to,
867         uint256 tokenId
868     ) public virtual override {
869         safeTransferFrom(from, to, tokenId, "");
870     }
871 
872     /**
873      * @dev See {IERC721-safeTransferFrom}.
874      */
875     function safeTransferFrom(
876         address from,
877         address to,
878         uint256 tokenId,
879         bytes memory _data
880     ) public virtual override {
881         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
882         _safeTransfer(from, to, tokenId, _data);
883     }
884 
885     /**
886      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
887      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
888      *
889      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
890      *
891      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
892      * implement alternative mechanisms to perform token transfer, such as signature-based.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must exist and be owned by `from`.
899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
900      *
901      * Emits a {Transfer} event.
902      */
903     function _safeTransfer(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) internal virtual {
909         _transfer(from, to, tokenId);
910         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
911     }
912 
913     /**
914      * @dev Returns whether `tokenId` exists.
915      *
916      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
917      *
918      * Tokens start existing when they are minted (`_mint`),
919      * and stop existing when they are burned (`_burn`).
920      */
921     function _exists(uint256 tokenId) internal view virtual returns (bool) {
922         return _owners[tokenId] != address(0);
923     }
924 
925     /**
926      * @dev Returns whether `spender` is allowed to manage `tokenId`.
927      *
928      * Requirements:
929      *
930      * - `tokenId` must exist.
931      */
932     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
933         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
934         address owner = ERC721.ownerOf(tokenId);
935         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
936     }
937 
938     /**
939      * @dev Safely mints `tokenId` and transfers it to `to`.
940      *
941      * Requirements:
942      *
943      * - `tokenId` must not exist.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeMint(address to, uint256 tokenId) internal virtual {
949         _safeMint(to, tokenId, "");
950     }
951 
952     /**
953      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
954      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
955      */
956     function _safeMint(
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) internal virtual {
961         _mint(to, tokenId);
962         require(
963             _checkOnERC721Received(address(0), to, tokenId, _data),
964             "ERC721: transfer to non ERC721Receiver implementer"
965         );
966     }
967 
968     /**
969      * @dev Mints `tokenId` and transfers it to `to`.
970      *
971      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
972      *
973      * Requirements:
974      *
975      * - `tokenId` must not exist.
976      * - `to` cannot be the zero address.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _mint(address to, uint256 tokenId) internal virtual {
981         require(to != address(0), "ERC721: mint to the zero address");
982         require(!_exists(tokenId), "ERC721: token already minted");
983 
984         _beforeTokenTransfer(address(0), to, tokenId);
985 
986         _balances[to] += 1;
987         _owners[tokenId] = to;
988 
989         emit Transfer(address(0), to, tokenId);
990 
991         _afterTokenTransfer(address(0), to, tokenId);
992     }
993 
994     /**
995      * @dev Destroys `tokenId`.
996      * The approval is cleared when the token is burned.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _burn(uint256 tokenId) internal virtual {
1005         address owner = ERC721.ownerOf(tokenId);
1006 
1007         _beforeTokenTransfer(owner, address(0), tokenId);
1008 
1009         // Clear approvals
1010         _approve(address(0), tokenId);
1011 
1012         _balances[owner] -= 1;
1013         delete _owners[tokenId];
1014 
1015         emit Transfer(owner, address(0), tokenId);
1016 
1017         _afterTokenTransfer(owner, address(0), tokenId);
1018     }
1019 
1020     /**
1021      * @dev Transfers `tokenId` from `from` to `to`.
1022      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1023      *
1024      * Requirements:
1025      *
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must be owned by `from`.
1028      *
1029      * Emits a {Transfer} event.
1030      */
1031     function _transfer(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) internal virtual {
1036         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1037         require(to != address(0), "ERC721: transfer to the zero address");
1038 
1039         _beforeTokenTransfer(from, to, tokenId);
1040 
1041         // Clear approvals from the previous owner
1042         _approve(address(0), tokenId);
1043 
1044         _balances[from] -= 1;
1045         _balances[to] += 1;
1046         _owners[tokenId] = to;
1047 
1048         emit Transfer(from, to, tokenId);
1049 
1050         _afterTokenTransfer(from, to, tokenId);
1051     }
1052 
1053     /**
1054      * @dev Approve `to` to operate on `tokenId`
1055      *
1056      * Emits a {Approval} event.
1057      */
1058     function _approve(address to, uint256 tokenId) internal virtual {
1059         _tokenApprovals[tokenId] = to;
1060         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev Approve `operator` to operate on all of `owner` tokens
1065      *
1066      * Emits a {ApprovalForAll} event.
1067      */
1068     function _setApprovalForAll(
1069         address owner,
1070         address operator,
1071         bool approved
1072     ) internal virtual {
1073         require(owner != operator, "ERC721: approve to caller");
1074         _operatorApprovals[owner][operator] = approved;
1075         emit ApprovalForAll(owner, operator, approved);
1076     }
1077 
1078     /**
1079      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1080      * The call is not executed if the target address is not a contract.
1081      *
1082      * @param from address representing the previous owner of the given token ID
1083      * @param to target address that will receive the tokens
1084      * @param tokenId uint256 ID of the token to be transferred
1085      * @param _data bytes optional data to send along with the call
1086      * @return bool whether the call correctly returned the expected magic value
1087      */
1088     function _checkOnERC721Received(
1089         address from,
1090         address to,
1091         uint256 tokenId,
1092         bytes memory _data
1093     ) private returns (bool) {
1094         if (to.isContract()) {
1095             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1096                 return retval == IERC721Receiver.onERC721Received.selector;
1097             } catch (bytes memory reason) {
1098                 if (reason.length == 0) {
1099                     revert("ERC721: transfer to non ERC721Receiver implementer");
1100                 } else {
1101                     assembly {
1102                         revert(add(32, reason), mload(reason))
1103                     }
1104                 }
1105             }
1106         } else {
1107             return true;
1108         }
1109     }
1110 
1111     /**
1112      * @dev Hook that is called before any token transfer. This includes minting
1113      * and burning.
1114      *
1115      * Calling conditions:
1116      *
1117      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1118      * transferred to `to`.
1119      * - When `from` is zero, `tokenId` will be minted for `to`.
1120      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1121      * - `from` and `to` are never both zero.
1122      *
1123      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1124      */
1125     function _beforeTokenTransfer(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) internal virtual {}
1130 
1131     /**
1132      * @dev Hook that is called after any transfer of tokens. This includes
1133      * minting and burning.
1134      *
1135      * Calling conditions:
1136      *
1137      * - when `from` and `to` are both non-zero.
1138      * - `from` and `to` are never both zero.
1139      *
1140      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1141      */
1142     function _afterTokenTransfer(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) internal virtual {}
1147 }
1148 
1149 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1150 
1151 
1152 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1153 
1154 pragma solidity ^0.8.0;
1155 
1156 
1157 
1158 /**
1159  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1160  * enumerability of all the token ids in the contract as well as all token ids owned by each
1161  * account.
1162  */
1163 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1164     // Mapping from owner to list of owned token IDs
1165     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1166 
1167     // Mapping from token ID to index of the owner tokens list
1168     mapping(uint256 => uint256) private _ownedTokensIndex;
1169 
1170     // Array with all token ids, used for enumeration
1171     uint256[] private _allTokens;
1172 
1173     // Mapping from token id to position in the allTokens array
1174     mapping(uint256 => uint256) private _allTokensIndex;
1175 
1176     /**
1177      * @dev See {IERC165-supportsInterface}.
1178      */
1179     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1180         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1181     }
1182 
1183     /**
1184      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1185      */
1186     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1187         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1188         return _ownedTokens[owner][index];
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Enumerable-totalSupply}.
1193      */
1194     function totalSupply() public view virtual override returns (uint256) {
1195         return _allTokens.length;
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Enumerable-tokenByIndex}.
1200      */
1201     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1202         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1203         return _allTokens[index];
1204     }
1205 
1206     /**
1207      * @dev Hook that is called before any token transfer. This includes minting
1208      * and burning.
1209      *
1210      * Calling conditions:
1211      *
1212      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1213      * transferred to `to`.
1214      * - When `from` is zero, `tokenId` will be minted for `to`.
1215      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1216      * - `from` cannot be the zero address.
1217      * - `to` cannot be the zero address.
1218      *
1219      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1220      */
1221     function _beforeTokenTransfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) internal virtual override {
1226         super._beforeTokenTransfer(from, to, tokenId);
1227 
1228         if (from == address(0)) {
1229             _addTokenToAllTokensEnumeration(tokenId);
1230         } else if (from != to) {
1231             _removeTokenFromOwnerEnumeration(from, tokenId);
1232         }
1233         if (to == address(0)) {
1234             _removeTokenFromAllTokensEnumeration(tokenId);
1235         } else if (to != from) {
1236             _addTokenToOwnerEnumeration(to, tokenId);
1237         }
1238     }
1239 
1240     /**
1241      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1242      * @param to address representing the new owner of the given token ID
1243      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1244      */
1245     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1246         uint256 length = ERC721.balanceOf(to);
1247         _ownedTokens[to][length] = tokenId;
1248         _ownedTokensIndex[tokenId] = length;
1249     }
1250 
1251     /**
1252      * @dev Private function to add a token to this extension's token tracking data structures.
1253      * @param tokenId uint256 ID of the token to be added to the tokens list
1254      */
1255     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1256         _allTokensIndex[tokenId] = _allTokens.length;
1257         _allTokens.push(tokenId);
1258     }
1259 
1260     /**
1261      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1262      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1263      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1264      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1265      * @param from address representing the previous owner of the given token ID
1266      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1267      */
1268     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1269         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1270         // then delete the last slot (swap and pop).
1271 
1272         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1273         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1274 
1275         // When the token to delete is the last token, the swap operation is unnecessary
1276         if (tokenIndex != lastTokenIndex) {
1277             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1278 
1279             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1280             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1281         }
1282 
1283         // This also deletes the contents at the last position of the array
1284         delete _ownedTokensIndex[tokenId];
1285         delete _ownedTokens[from][lastTokenIndex];
1286     }
1287 
1288     /**
1289      * @dev Private function to remove a token from this extension's token tracking data structures.
1290      * This has O(1) time complexity, but alters the order of the _allTokens array.
1291      * @param tokenId uint256 ID of the token to be removed from the tokens list
1292      */
1293     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1294         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1295         // then delete the last slot (swap and pop).
1296 
1297         uint256 lastTokenIndex = _allTokens.length - 1;
1298         uint256 tokenIndex = _allTokensIndex[tokenId];
1299 
1300         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1301         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1302         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1303         uint256 lastTokenId = _allTokens[lastTokenIndex];
1304 
1305         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1306         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1307 
1308         // This also deletes the contents at the last position of the array
1309         delete _allTokensIndex[tokenId];
1310         _allTokens.pop();
1311     }
1312 }
1313 
1314 // File: HideOut.sol
1315 
1316 pragma solidity >=0.7.0 <0.9.0;
1317 
1318 interface IMiniMoose {
1319     function balanceOf(address owner) external view returns (uint256);
1320 }
1321 
1322 interface IMetaMooseMansion {
1323     function balanceOf(address owner) external view returns (uint256);
1324 }
1325 
1326 contract SocietyHideouts is ERC721Enumerable, Ownable {
1327     using Strings for uint256;
1328 
1329     IMiniMoose public MiniMoose;
1330     IMetaMooseMansion public MetaMooseMansion;
1331 
1332     string public baseURI;
1333     uint256 public cost = 0.005 ether;
1334     uint256 public maxSupply = 2500;
1335     uint256 public maxMintAmount = 20;
1336     bool public paused = false;
1337     bool public claimingPaused = false;
1338     mapping(address => bool) public hasClaimed;
1339 
1340     constructor(
1341         string memory _name,
1342         string memory _symbol,
1343         string memory _initBaseURI, 
1344         address _metaMooseMansion,
1345         address _miniMoose
1346     )
1347     ERC721(_name, _symbol) {
1348     MetaMooseMansion = IMetaMooseMansion(_metaMooseMansion);
1349     MiniMoose = IMiniMoose(_miniMoose);
1350     setBaseURI(_initBaseURI);
1351   }
1352 
1353   // internal
1354 
1355     function _baseURI() internal view virtual override returns (string memory) {
1356     return baseURI;
1357     }
1358 
1359   // public
1360 
1361     function claimHideOut() public {
1362         address _to = msg.sender;
1363         uint256 supply = totalSupply();
1364         require(!claimingPaused, "Claiming is paused");
1365         require(supply + 1 <= maxSupply, "Max Supply reached");
1366         require(hasClaimed[_to] != true, "Already Claimed");
1367         require(
1368                 MetaMooseMansion.balanceOf(_to) > 0 || MiniMoose.balanceOf(_to) > 0,
1369                 "Not an existing holder"
1370                 );
1371         _safeMint(_to, supply + 1);
1372         hasClaimed[_to] = true;
1373     }
1374 
1375     function mintHideOut(uint256 _mintAmount) public payable {
1376     address _to = msg.sender;  
1377     uint256 supply = totalSupply();
1378     require(_mintAmount > 0, "Invalid minting amount");
1379     require(_mintAmount <= maxMintAmount, "Invalid minting amount");
1380     require(supply + _mintAmount <= maxSupply, "Max Supply reached");
1381 
1382         if (msg.sender != owner()) {
1383             require(msg.value >= cost * _mintAmount);
1384             require(!paused, "Minting is paused");
1385             require(
1386                 MetaMooseMansion.balanceOf(_to) > 0 || MiniMoose.balanceOf(_to) > 0,
1387                 "Not an existing holder"
1388             );
1389         }
1390 
1391         for (uint256 i = 1; i <= _mintAmount; i++) {
1392         _safeMint(_to, supply + i);
1393         }
1394     }
1395 
1396     function walletOfOwner(address _owner)
1397     public
1398     view
1399     returns (uint256[] memory)
1400     {
1401         uint256 ownerTokenCount = balanceOf(_owner);
1402         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1403             for (uint256 i; i < ownerTokenCount; i++) {
1404                 tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1405             }
1406         return tokenIds;
1407     }
1408 
1409     function tokenURI(uint256 tokenId)
1410     public
1411     view
1412     virtual
1413     override
1414     returns (string memory)
1415     {
1416     require(
1417       _exists(tokenId),
1418       "ERC721Metadata: URI query for nonexistent token"
1419     );
1420 
1421     string memory currentBaseURI = _baseURI();
1422     return bytes(currentBaseURI).length > 0
1423         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
1424         : "";
1425     }
1426 
1427   //only owner
1428 
1429     function setCost(uint256 _newCost) public onlyOwner {
1430         cost = _newCost;
1431     }
1432 
1433     function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1434         maxMintAmount = _newmaxMintAmount;
1435     }
1436 
1437     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1438         baseURI = _newBaseURI;
1439     }
1440 
1441     function pause(bool _state) public onlyOwner {
1442         paused = _state;
1443     }
1444 
1445     function pauseClaiming(bool _state) public onlyOwner {
1446         claimingPaused = _state;
1447     }
1448 
1449     function withdraw() public payable onlyOwner {
1450         (bool hs, ) = payable(0xa385D9db5d2fE2Bec3288f205f7f8C5677FeF904).call{value: address(this).balance}("");
1451         require(hs);
1452     }
1453 }