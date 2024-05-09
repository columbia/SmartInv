1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
27 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
28 
29 
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
95 
96 
97 
98 /**
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         return msg.data;
115     }
116 }
117 
118 /**
119  * @dev Required interface of an ERC721 compliant contract.
120  */
121 interface IERC721 is IERC165 {
122     /**
123      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
124      */
125     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
129      */
130     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
131 
132     /**
133      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
134      */
135     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
136 
137     /**
138      * @dev Returns the number of tokens in ``owner``'s account.
139      */
140     function balanceOf(address owner) external view returns (uint256 balance);
141 
142     /**
143      * @dev Returns the owner of the `tokenId` token.
144      *
145      * Requirements:
146      *
147      * - `tokenId` must exist.
148      */
149     function ownerOf(uint256 tokenId) external view returns (address owner);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
153      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
154      *
155      * Requirements:
156      *
157      * - `from` cannot be the zero address.
158      * - `to` cannot be the zero address.
159      * - `tokenId` token must exist and be owned by `from`.
160      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
162      *
163      * Emits a {Transfer} event.
164      */
165     function safeTransferFrom(
166         address from,
167         address to,
168         uint256 tokenId
169     ) external;
170 
171     /**
172      * @dev Transfers `tokenId` token from `from` to `to`.
173      *
174      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
175      *
176      * Requirements:
177      *
178      * - `from` cannot be the zero address.
179      * - `to` cannot be the zero address.
180      * - `tokenId` token must be owned by `from`.
181      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address from,
187         address to,
188         uint256 tokenId
189     ) external;
190 
191     /**
192      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
193      * The approval is cleared when the token is transferred.
194      *
195      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
196      *
197      * Requirements:
198      *
199      * - The caller must own the token or be an approved operator.
200      * - `tokenId` must exist.
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address to, uint256 tokenId) external;
205 
206     /**
207      * @dev Returns the account approved for `tokenId` token.
208      *
209      * Requirements:
210      *
211      * - `tokenId` must exist.
212      */
213     function getApproved(uint256 tokenId) external view returns (address operator);
214 
215     /**
216      * @dev Approve or remove `operator` as an operator for the caller.
217      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
218      *
219      * Requirements:
220      *
221      * - The `operator` cannot be the caller.
222      *
223      * Emits an {ApprovalForAll} event.
224      */
225     function setApprovalForAll(address operator, bool _approved) external;
226 
227     /**
228      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
229      *
230      * See {setApprovalForAll}
231      */
232     function isApprovedForAll(address owner, address operator) external view returns (bool);
233 
234     /**
235      * @dev Safely transfers `tokenId` token from `from` to `to`.
236      *
237      * Requirements:
238      *
239      * - `from` cannot be the zero address.
240      * - `to` cannot be the zero address.
241      * - `tokenId` token must exist and be owned by `from`.
242      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
243      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
244      *
245      * Emits a {Transfer} event.
246      */
247     function safeTransferFrom(
248         address from,
249         address to,
250         uint256 tokenId,
251         bytes calldata data
252     ) external;
253 }
254 /**
255  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
256  * @dev See https://eips.ethereum.org/EIPS/eip-721
257  */
258 interface IERC721Enumerable is IERC721 {
259     /**
260      * @dev Returns the total amount of tokens stored by the contract.
261      */
262     function totalSupply() external view returns (uint256);
263 
264     /**
265      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
266      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
267      */
268     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
269 
270     /**
271      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
272      * Use along with {totalSupply} to enumerate all tokens.
273      */
274     function tokenByIndex(uint256 index) external view returns (uint256);
275 }
276 
277 
278 
279 
280 //Copyleft (ɔ) All Rights Reversed
281 
282 
283 
284 
285 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
286 
287 
288 
289 
290 
291 /**
292  * @dev Contract module which provides a basic access control mechanism, where
293  * there is an account (an owner) that can be granted exclusive access to
294  * specific functions.
295  *
296  * By default, the owner account will be the one that deploys the contract. This
297  * can later be changed with {transferOwnership}.
298  *
299  * This module is used through inheritance. It will make available the modifier
300  * `onlyOwner`, which can be applied to your functions to restrict their use to
301  * the owner.
302  */
303 abstract contract Ownable is Context {
304     address private _owner;
305 
306     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
307 
308     /**
309      * @dev Initializes the contract setting the deployer as the initial owner.
310      */
311     constructor() {
312         _transferOwnership(_msgSender());
313     }
314 
315     /**
316      * @dev Returns the address of the current owner.
317      */
318     function owner() public view virtual returns (address) {
319         return _owner;
320     }
321 
322     /**
323      * @dev Throws if called by any account other than the owner.
324      */
325     modifier onlyOwner() {
326         require(owner() == _msgSender(), "Ownable: caller is not the owner");
327         _;
328     }
329 
330     /**
331      * @dev Leaves the contract without owner. It will not be possible to call
332      * `onlyOwner` functions anymore. Can only be called by the current owner.
333      *
334      * NOTE: Renouncing ownership will leave the contract without an owner,
335      * thereby removing any functionality that is only available to the owner.
336      */
337     function renounceOwnership() public virtual onlyOwner {
338         _transferOwnership(address(0));
339     }
340 
341     /**
342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
343      * Can only be called by the current owner.
344      */
345     function transferOwnership(address newOwner) public virtual onlyOwner {
346         require(newOwner != address(0), "Ownable: new owner is the zero address");
347         _transferOwnership(newOwner);
348     }
349 
350     /**
351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
352      * Internal function without access restriction.
353      */
354     function _transferOwnership(address newOwner) internal virtual {
355         address oldOwner = _owner;
356         _owner = newOwner;
357         emit OwnershipTransferred(oldOwner, newOwner);
358     }
359 }
360 
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
364 
365 
366 
367 
368 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
369 
370 
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
374 
375 
376 
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
380 
381 
382 
383 /**
384  * @title ERC721 token receiver interface
385  * @dev Interface for any contract that wants to support safeTransfers
386  * from ERC721 asset contracts.
387  */
388 interface IERC721Receiver {
389     /**
390      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
391      * by `operator` from `from`, this function is called.
392      *
393      * It must return its Solidity selector to confirm the token transfer.
394      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
395      *
396      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
397      */
398     function onERC721Received(
399         address operator,
400         address from,
401         uint256 tokenId,
402         bytes calldata data
403     ) external returns (bytes4);
404 }
405 
406 
407 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
408 
409 
410 
411 
412 
413 /**
414  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
415  * @dev See https://eips.ethereum.org/EIPS/eip-721
416  */
417 interface IERC721Metadata is IERC721 {
418     /**
419      * @dev Returns the token collection name.
420      */
421     function name() external view returns (string memory);
422 
423     /**
424      * @dev Returns the token collection symbol.
425      */
426     function symbol() external view returns (string memory);
427 
428     /**
429      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
430      */
431     function tokenURI(uint256 tokenId) external view returns (string memory);
432 }
433 
434 
435 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
436 
437 
438 
439 /**
440  * @dev Collection of functions related to the address type
441  */
442 library Address {
443     /**
444      * @dev Returns true if `account` is a contract.
445      *
446      * [IMPORTANT]
447      * ====
448      * It is unsafe to assume that an address for which this function returns
449      * false is an externally-owned account (EOA) and not a contract.
450      *
451      * Among others, `isContract` will return false for the following
452      * types of addresses:
453      *
454      *  - an externally-owned account
455      *  - a contract in construction
456      *  - an address where a contract will be created
457      *  - an address where a contract lived, but was destroyed
458      * ====
459      *
460      * [IMPORTANT]
461      * ====
462      * You shouldn't rely on `isContract` to protect against flash loan attacks!
463      *
464      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
465      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
466      * constructor.
467      * ====
468      */
469     function isContract(address account) internal view returns (bool) {
470         // This method relies on extcodesize/address.code.length, which returns 0
471         // for contracts in construction, since the code is only stored at the end
472         // of the constructor execution.
473 
474         return account.code.length > 0;
475     }
476 
477     /**
478      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
479      * `recipient`, forwarding all available gas and reverting on errors.
480      *
481      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
482      * of certain opcodes, possibly making contracts go over the 2300 gas limit
483      * imposed by `transfer`, making them unable to receive funds via
484      * `transfer`. {sendValue} removes this limitation.
485      *
486      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
487      *
488      * IMPORTANT: because control is transferred to `recipient`, care must be
489      * taken to not create reentrancy vulnerabilities. Consider using
490      * {ReentrancyGuard} or the
491      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
492      */
493     function sendValue(address payable recipient, uint256 amount) internal {
494         require(address(this).balance >= amount, "Address: insufficient balance");
495 
496         (bool success, ) = recipient.call{value: amount}("");
497         require(success, "Address: unable to send value, recipient may have reverted");
498     }
499 
500     /**
501      * @dev Performs a Solidity function call using a low level `call`. A
502      * plain `call` is an unsafe replacement for a function call: use this
503      * function instead.
504      *
505      * If `target` reverts with a revert reason, it is bubbled up by this
506      * function (like regular Solidity function calls).
507      *
508      * Returns the raw returned data. To convert to the expected return value,
509      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
510      *
511      * Requirements:
512      *
513      * - `target` must be a contract.
514      * - calling `target` with `data` must not revert.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
519         return functionCall(target, data, "Address: low-level call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
524      * `errorMessage` as a fallback revert reason when `target` reverts.
525      *
526      * _Available since v3.1._
527      */
528     function functionCall(
529         address target,
530         bytes memory data,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         return functionCallWithValue(target, data, 0, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but also transferring `value` wei to `target`.
539      *
540      * Requirements:
541      *
542      * - the calling contract must have an ETH balance of at least `value`.
543      * - the called Solidity function must be `payable`.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(
548         address target,
549         bytes memory data,
550         uint256 value
551     ) internal returns (bytes memory) {
552         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
557      * with `errorMessage` as a fallback revert reason when `target` reverts.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         require(address(this).balance >= value, "Address: insufficient balance for call");
568         require(isContract(target), "Address: call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.call{value: value}(data);
571         return verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a static call.
577      *
578      * _Available since v3.3._
579      */
580     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
581         return functionStaticCall(target, data, "Address: low-level static call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a static call.
587      *
588      * _Available since v3.3._
589      */
590     function functionStaticCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal view returns (bytes memory) {
595         require(isContract(target), "Address: static call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.staticcall(data);
598         return verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     /**
602      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
603      * but performing a delegate call.
604      *
605      * _Available since v3.4._
606      */
607     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
608         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
609     }
610 
611     /**
612      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
613      * but performing a delegate call.
614      *
615      * _Available since v3.4._
616      */
617     function functionDelegateCall(
618         address target,
619         bytes memory data,
620         string memory errorMessage
621     ) internal returns (bytes memory) {
622         require(isContract(target), "Address: delegate call to non-contract");
623 
624         (bool success, bytes memory returndata) = target.delegatecall(data);
625         return verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     /**
629      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
630      * revert reason using the provided one.
631      *
632      * _Available since v4.3._
633      */
634     function verifyCallResult(
635         bool success,
636         bytes memory returndata,
637         string memory errorMessage
638     ) internal pure returns (bytes memory) {
639         if (success) {
640             return returndata;
641         } else {
642             // Look for revert reason and bubble it up if present
643             if (returndata.length > 0) {
644                 // The easiest way to bubble the revert reason is using memory via assembly
645 
646                 assembly {
647                     let returndata_size := mload(returndata)
648                     revert(add(32, returndata), returndata_size)
649                 }
650             } else {
651                 revert(errorMessage);
652             }
653         }
654     }
655 }
656 
657 
658 
659 
660 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
661 
662 
663 
664 
665 
666 /**
667  * @dev Implementation of the {IERC165} interface.
668  *
669  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
670  * for the additional interface id that will be supported. For example:
671  *
672  * ```solidity
673  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
674  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
675  * }
676  * ```
677  *
678  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
679  */
680 abstract contract ERC165 is IERC165 {
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
685         return interfaceId == type(IERC165).interfaceId;
686     }
687 }
688 
689 
690 /**
691  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
692  * the Metadata extension, but not including the Enumerable extension, which is available separately as
693  * {ERC721Enumerable}.
694  */
695 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
696     using Address for address;
697     using Strings for uint256;
698 
699     // Token name
700     string private _name;
701 
702     // Token symbol
703     string private _symbol;
704 
705     // Mapping from token ID to owner address
706     mapping(uint256 => address) private _owners;
707 
708     // Mapping owner address to token count
709     mapping(address => uint256) private _balances;
710 
711     // Mapping from token ID to approved address
712     mapping(uint256 => address) private _tokenApprovals;
713 
714     // Mapping from owner to operator approvals
715     mapping(address => mapping(address => bool)) private _operatorApprovals;
716 
717     /**
718      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
719      */
720     constructor(string memory name_, string memory symbol_) {
721         _name = name_;
722         _symbol = symbol_;
723     }
724 
725     /**
726      * @dev See {IERC165-supportsInterface}.
727      */
728     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
729         return
730             interfaceId == type(IERC721).interfaceId ||
731             interfaceId == type(IERC721Metadata).interfaceId ||
732             super.supportsInterface(interfaceId);
733     }
734 
735     /**
736      * @dev See {IERC721-balanceOf}.
737      */
738     function balanceOf(address owner) public view virtual override returns (uint256) {
739         require(owner != address(0), "ERC721: balance query for the zero address");
740         return _balances[owner];
741     }
742 
743     /**
744      * @dev See {IERC721-ownerOf}.
745      */
746     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
747         address owner = _owners[tokenId];
748         require(owner != address(0), "ERC721: owner query for nonexistent token");
749         return owner;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-name}.
754      */
755     function name() public view virtual override returns (string memory) {
756         return _name;
757     }
758 
759     /**
760      * @dev See {IERC721Metadata-symbol}.
761      */
762     function symbol() public view virtual override returns (string memory) {
763         return _symbol;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-tokenURI}.
768      */
769     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
770         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
771 
772         string memory baseURI = _baseURI();
773         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
774     }
775 
776     /**
777      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
778      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
779      * by default, can be overriden in child contracts.
780      */
781     function _baseURI() internal view virtual returns (string memory) {
782         return "";
783     }
784 
785     /**
786      * @dev See {IERC721-approve}.
787      */
788     function approve(address to, uint256 tokenId) public virtual override {
789         address owner = ERC721.ownerOf(tokenId);
790         require(to != owner, "ERC721: approval to current owner");
791 
792         require(
793             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
794             "ERC721: approve caller is not owner nor approved for all"
795         );
796 
797         _approve(to, tokenId);
798     }
799 
800     /**
801      * @dev See {IERC721-getApproved}.
802      */
803     function getApproved(uint256 tokenId) public view virtual override returns (address) {
804         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
805 
806         return _tokenApprovals[tokenId];
807     }
808 
809     /**
810      * @dev See {IERC721-setApprovalForAll}.
811      */
812     function setApprovalForAll(address operator, bool approved) public virtual override {
813         _setApprovalForAll(_msgSender(), operator, approved);
814     }
815 
816     /**
817      * @dev See {IERC721-isApprovedForAll}.
818      */
819     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
820         return _operatorApprovals[owner][operator];
821     }
822 
823     /**
824      * @dev See {IERC721-transferFrom}.
825      */
826     function transferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) public virtual override {
831         //solhint-disable-next-line max-line-length
832         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
833 
834         _transfer(from, to, tokenId);
835     }
836 
837     /**
838      * @dev See {IERC721-safeTransferFrom}.
839      */
840     function safeTransferFrom(
841         address from,
842         address to,
843         uint256 tokenId
844     ) public virtual override {
845         safeTransferFrom(from, to, tokenId, "");
846     }
847 
848     /**
849      * @dev See {IERC721-safeTransferFrom}.
850      */
851     function safeTransferFrom(
852         address from,
853         address to,
854         uint256 tokenId,
855         bytes memory _data
856     ) public virtual override {
857         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
858         _safeTransfer(from, to, tokenId, _data);
859     }
860 
861     /**
862      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
863      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
864      *
865      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
866      *
867      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
868      * implement alternative mechanisms to perform token transfer, such as signature-based.
869      *
870      * Requirements:
871      *
872      * - `from` cannot be the zero address.
873      * - `to` cannot be the zero address.
874      * - `tokenId` token must exist and be owned by `from`.
875      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
876      *
877      * Emits a {Transfer} event.
878      */
879     function _safeTransfer(
880         address from,
881         address to,
882         uint256 tokenId,
883         bytes memory _data
884     ) internal virtual {
885         _transfer(from, to, tokenId);
886         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
887     }
888 
889     /**
890      * @dev Returns whether `tokenId` exists.
891      *
892      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
893      *
894      * Tokens start existing when they are minted (`_mint`),
895      * and stop existing when they are burned (`_burn`).
896      */
897     function _exists(uint256 tokenId) internal view virtual returns (bool) {
898         return _owners[tokenId] != address(0);
899     }
900 
901     /**
902      * @dev Returns whether `spender` is allowed to manage `tokenId`.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      */
908     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
909         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
910         address owner = ERC721.ownerOf(tokenId);
911         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
912     }
913 
914     /**
915      * @dev Safely mints `tokenId` and transfers it to `to`.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must not exist.
920      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
921      *
922      * Emits a {Transfer} event.
923      */
924     function _safeMint(address to, uint256 tokenId) internal virtual {
925         _safeMint(to, tokenId, "");
926     }
927 
928     /**
929      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
930      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
931      */
932     function _safeMint(
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) internal virtual {
937         _mint(to, tokenId);
938         require(
939             _checkOnERC721Received(address(0), to, tokenId, _data),
940             "ERC721: transfer to non ERC721Receiver implementer"
941         );
942     }
943 
944     /**
945      * @dev Mints `tokenId` and transfers it to `to`.
946      *
947      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
948      *
949      * Requirements:
950      *
951      * - `tokenId` must not exist.
952      * - `to` cannot be the zero address.
953      *
954      * Emits a {Transfer} event.
955      */
956     function _mint(address to, uint256 tokenId) internal virtual {
957         require(to != address(0), "ERC721: mint to the zero address");
958         require(!_exists(tokenId), "ERC721: token already minted");
959 
960         _beforeTokenTransfer(address(0), to, tokenId);
961 
962         _balances[to] += 1;
963         _owners[tokenId] = to;
964 
965         emit Transfer(address(0), to, tokenId);
966 
967         _afterTokenTransfer(address(0), to, tokenId);
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
992 
993         _afterTokenTransfer(owner, address(0), tokenId);
994     }
995 
996     /**
997      * @dev Transfers `tokenId` from `from` to `to`.
998      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
999      *
1000      * Requirements:
1001      *
1002      * - `to` cannot be the zero address.
1003      * - `tokenId` token must be owned by `from`.
1004      *
1005      * Emits a {Transfer} event.
1006      */
1007     function _transfer(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) internal virtual {
1012         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1013         require(to != address(0), "ERC721: transfer to the zero address");
1014 
1015         _beforeTokenTransfer(from, to, tokenId);
1016 
1017         // Clear approvals from the previous owner
1018         _approve(address(0), tokenId);
1019 
1020         _balances[from] -= 1;
1021         _balances[to] += 1;
1022         _owners[tokenId] = to;
1023 
1024         emit Transfer(from, to, tokenId);
1025 
1026         _afterTokenTransfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev Approve `to` to operate on `tokenId`
1031      *
1032      * Emits a {Approval} event.
1033      */
1034     function _approve(address to, uint256 tokenId) internal virtual {
1035         _tokenApprovals[tokenId] = to;
1036         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Approve `operator` to operate on all of `owner` tokens
1041      *
1042      * Emits a {ApprovalForAll} event.
1043      */
1044     function _setApprovalForAll(
1045         address owner,
1046         address operator,
1047         bool approved
1048     ) internal virtual {
1049         require(owner != operator, "ERC721: approve to caller");
1050         _operatorApprovals[owner][operator] = approved;
1051         emit ApprovalForAll(owner, operator, approved);
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1056      * The call is not executed if the target address is not a contract.
1057      *
1058      * @param from address representing the previous owner of the given token ID
1059      * @param to target address that will receive the tokens
1060      * @param tokenId uint256 ID of the token to be transferred
1061      * @param _data bytes optional data to send along with the call
1062      * @return bool whether the call correctly returned the expected magic value
1063      */
1064     function _checkOnERC721Received(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) private returns (bool) {
1070         if (to.isContract()) {
1071             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1072                 return retval == IERC721Receiver.onERC721Received.selector;
1073             } catch (bytes memory reason) {
1074                 if (reason.length == 0) {
1075                     revert("ERC721: transfer to non ERC721Receiver implementer");
1076                 } else {
1077                     assembly {
1078                         revert(add(32, reason), mload(reason))
1079                     }
1080                 }
1081             }
1082         } else {
1083             return true;
1084         }
1085     }
1086 
1087     /**
1088      * @dev Hook that is called before any token transfer. This includes minting
1089      * and burning.
1090      *
1091      * Calling conditions:
1092      *
1093      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1094      * transferred to `to`.
1095      * - When `from` is zero, `tokenId` will be minted for `to`.
1096      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1097      * - `from` and `to` are never both zero.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _beforeTokenTransfer(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) internal virtual {}
1106 
1107     /**
1108      * @dev Hook that is called after any transfer of tokens. This includes
1109      * minting and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - when `from` and `to` are both non-zero.
1114      * - `from` and `to` are never both zero.
1115      *
1116      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1117      */
1118     function _afterTokenTransfer(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) internal virtual {}
1123 }
1124 
1125 
1126 
1127 /**
1128  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1129  * enumerability of all the token ids in the contract as well as all token ids owned by each
1130  * account.
1131  */
1132 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1133     // Mapping from owner to list of owned token IDs
1134     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1135 
1136     // Mapping from token ID to index of the owner tokens list
1137     mapping(uint256 => uint256) private _ownedTokensIndex;
1138 
1139     // Array with all token ids, used for enumeration
1140     uint256[] private _allTokens;
1141 
1142     // Mapping from token id to position in the allTokens array
1143     mapping(uint256 => uint256) private _allTokensIndex;
1144 
1145     /**
1146      * @dev See {IERC165-supportsInterface}.
1147      */
1148     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1149         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1150     }
1151 
1152     /**
1153      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1154      */
1155     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1156         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1157         return _ownedTokens[owner][index];
1158     }
1159 
1160     /**
1161      * @dev See {IERC721Enumerable-totalSupply}.
1162      */
1163     function totalSupply() public view virtual override returns (uint256) {
1164         return _allTokens.length;
1165     }
1166 
1167     /**
1168      * @dev See {IERC721Enumerable-tokenByIndex}.
1169      */
1170     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1171         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1172         return _allTokens[index];
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before any token transfer. This includes minting
1177      * and burning.
1178      *
1179      * Calling conditions:
1180      *
1181      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1182      * transferred to `to`.
1183      * - When `from` is zero, `tokenId` will be minted for `to`.
1184      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1185      * - `from` cannot be the zero address.
1186      * - `to` cannot be the zero address.
1187      *
1188      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1189      */
1190     function _beforeTokenTransfer(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) internal virtual override {
1195         super._beforeTokenTransfer(from, to, tokenId);
1196 
1197         if (from == address(0)) {
1198             _addTokenToAllTokensEnumeration(tokenId);
1199         } else if (from != to) {
1200             _removeTokenFromOwnerEnumeration(from, tokenId);
1201         }
1202         if (to == address(0)) {
1203             _removeTokenFromAllTokensEnumeration(tokenId);
1204         } else if (to != from) {
1205             _addTokenToOwnerEnumeration(to, tokenId);
1206         }
1207     }
1208 
1209     /**
1210      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1211      * @param to address representing the new owner of the given token ID
1212      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1213      */
1214     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1215         uint256 length = ERC721.balanceOf(to);
1216         _ownedTokens[to][length] = tokenId;
1217         _ownedTokensIndex[tokenId] = length;
1218     }
1219 
1220     /**
1221      * @dev Private function to add a token to this extension's token tracking data structures.
1222      * @param tokenId uint256 ID of the token to be added to the tokens list
1223      */
1224     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1225         _allTokensIndex[tokenId] = _allTokens.length;
1226         _allTokens.push(tokenId);
1227     }
1228 
1229     /**
1230      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1231      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1232      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1233      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1234      * @param from address representing the previous owner of the given token ID
1235      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1236      */
1237     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1238         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1239         // then delete the last slot (swap and pop).
1240 
1241         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1242         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1243 
1244         // When the token to delete is the last token, the swap operation is unnecessary
1245         if (tokenIndex != lastTokenIndex) {
1246             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1247 
1248             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1249             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1250         }
1251 
1252         // This also deletes the contents at the last position of the array
1253         delete _ownedTokensIndex[tokenId];
1254         delete _ownedTokens[from][lastTokenIndex];
1255     }
1256 
1257     /**
1258      * @dev Private function to remove a token from this extension's token tracking data structures.
1259      * This has O(1) time complexity, but alters the order of the _allTokens array.
1260      * @param tokenId uint256 ID of the token to be removed from the tokens list
1261      */
1262     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1263         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1264         // then delete the last slot (swap and pop).
1265 
1266         uint256 lastTokenIndex = _allTokens.length - 1;
1267         uint256 tokenIndex = _allTokensIndex[tokenId];
1268 
1269         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1270         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1271         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1272         uint256 lastTokenId = _allTokens[lastTokenIndex];
1273 
1274         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1275         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1276 
1277         // This also deletes the contents at the last position of the array
1278         delete _allTokensIndex[tokenId];
1279         _allTokens.pop();
1280     }
1281 }
1282 
1283 
1284 
1285 struct Shareholder {
1286 	address addr;
1287 	uint256 percent;
1288 }
1289 contract Dropicall is ERC721Enumerable, Ownable {
1290 
1291 	mapping(address => uint256) private share_pool;
1292 	address[] private share_addr; // [i]
1293 
1294 	// [addr][id] (usually i,j)
1295 	// Contains "unrolled" share amounts to distribute.
1296 	uint256[][] private share_price_matrix;
1297 	// [j]
1298 	// Pairs of [price,count]
1299 	uint256[2][] private prices_n;
1300 
1301 	uint256 public immutable item_count;
1302 
1303 	bool private sale_data_ok = false;
1304 
1305 	uint256 private immutable max_supply;
1306 	function get_mint_price(uint j) public view returns(uint256) {
1307 		require(j < prices_n.length);
1308 		return prices_n[j][0] * prices_n[j][1];
1309 	}
1310 	function get_mint_count(uint j) public view returns(uint256) {
1311 		require(j < prices_n.length);
1312 		return prices_n[j][1];
1313 	}
1314 	function pay_and_mint(uint j) private {
1315 		require( j < prices_n.length, "Invalid mint option." );
1316 		require(msg.value == get_mint_price(j), "Incorrect value paid.");
1317 		require(totalSupply() + prices_n[j][1] <= max_supply, "Not enough left.");
1318 		distribute_share(j);
1319 		uint ts = totalSupply() + 1;
1320 		for (uint i = 0; i < prices_n[j][1]; i++) {
1321 			_safeMint(msg.sender, ts + i);
1322 		}
1323 	}
1324 	function distribute_share(uint256 j) private {
1325 		for ( uint i = 0; i < share_addr.length; i++ ) {
1326 			share_pool[share_addr[i]] += share_price_matrix[i][j];
1327 		}
1328 	}
1329 	function init_sale_data(Shareholder[] memory shareholders, uint256[2][] memory amounts_prices ) private {
1330 		require(!sale_data_ok, "Already initialized");
1331 		require(shareholders.length > 0, "Must provide at least one shareholder.");
1332 		require(amounts_prices.length > 0, "Must provide prices.");
1333 		prices_n = amounts_prices;
1334 		uint256 p = 0;
1335 		for ( uint256 i = 0; i < shareholders.length; i++ ) {
1336 			require( shareholders[i].percent > 0 && shareholders[i].percent <= 100, "Percentage out of range." );
1337 			p += shareholders[i].percent;
1338 			share_addr.push(shareholders[i].addr);
1339 			share_price_matrix.push();
1340 			for ( uint256 j = 0; j < amounts_prices.length; j++ ) {
1341 				require( amounts_prices[j][0] % 100 == 0, "Prices must each be a multiple of 100 Wei." );
1342 				uint256 v = (amounts_prices[j][0] / 100) * shareholders[i].percent;
1343 				share_price_matrix[i].push(v * amounts_prices[j][1]);
1344 			}
1345 		}
1346 		require( p == 100, "Combined shares do not add up to 100 percent." );
1347 		sale_data_ok = true;
1348 		/* Deactivate for less constructor gas * /
1349 		for ( uint256 j = 0; j < amounts_prices.length; j++ ) {
1350 			uint256 c = 0;
1351 			for ( uint256 i = 0; i < shareholders.length; i++ ) {
1352 				c += share_price_matrix[i][j];
1353 			}
1354 			assert( c == amounts_prices[j][0] * amounts_prices[j][1] ); // Unrolled prices do not add up to the original.
1355 		}
1356 		/ * */
1357 	}
1358 	function withdraw_share() public {
1359 		require(share_pool[msg.sender] > 0, "No shares for this address to withdraw." );
1360 		address payable dest = payable(msg.sender);
1361 		uint256 bounty = share_pool[msg.sender];
1362 		share_pool[msg.sender] = 0;
1363 		dest.transfer(bounty);
1364 	}
1365 
1366 	///////////////
1367 
1368 	string private __baseURI;
1369 	function _baseURI() internal view virtual override returns (string memory) {
1370 		return __baseURI;
1371 	}
1372 	function _setBaseURI(string memory baseURI_) internal virtual {
1373 		__baseURI = baseURI_;
1374 	}
1375 	function setBaseURI(string memory baseURI) public onlyOwner {
1376 		_setBaseURI(baseURI);
1377 	}
1378 
1379 	string private __contractURI;
1380 	function _contractURI() internal view virtual returns (string memory) {
1381 		return __contractURI;
1382 	}
1383 	function _setContractURI(string memory contractURI_) internal virtual {
1384 		__contractURI = contractURI_;
1385 	}
1386 	function setContractURI(string memory contractURI) public onlyOwner {
1387 		_setContractURI(contractURI);
1388 	}
1389 	///////////////
1390 
1391 	bool premint_started;
1392 	bool mint_started;
1393 
1394 	mapping(address => bool) public whitelist;
1395 
1396 	function mint_main(uint256 option_id) public payable {
1397 		require( mint_started || ( premint_started && whitelist[msg.sender] ), "You may not mint at this time." );
1398 		pay_and_mint( option_id );
1399 	}
1400 
1401 	function start_premint() public onlyOwner {
1402 		premint_started = true;
1403 	}
1404 	function start_mint() public onlyOwner {
1405 		require( premint_started, "Starting mint without premint first, did you press the wrong button?" );
1406 		mint_started = true;
1407 	}
1408 
1409 	constructor() ERC721(
1410 		"Dropicall",
1411 		"DRCA"
1412 	) {
1413 		Shareholder[] memory sh = new Shareholder[](2);
1414 		sh[0] = Shareholder( { addr: 0xB520F068a908A1782a543aAcC3847ADB77A04778, percent: 10 } ); // remco
1415 		sh[1] = Shareholder( { addr: 0x4dDAc376f28BE60e1F7642A4D302C6Cf6CAe1D92, percent: 90 } ); // mezza
1416 
1417 		// Why? So that you can query this (it's public)
1418 		item_count = 3;
1419 		uint256[2][] memory price_table = new uint256[2][](item_count);		
1420 		price_table[0] = [ uint256(8e7 gwei), 1 ];
1421 		price_table[1] = [ uint256(7e7 gwei), 5 ];
1422 		price_table[2] = [ uint256(6e7 gwei), 10 ];
1423 
1424 		max_supply = 3333;
1425 
1426 		init_sale_data( sh, price_table );
1427 
1428 		// _setContractURI( "this is a very long string about mice. squeak are mice making a home in your code??" );
1429 		// _setBaseURI( "this is a very long string about mice. actually this is for more conservative gas estimates.." );
1430 
1431 		whitelist[0x2cc2149D905fe27841055CC31700641e0E6C944D] = true;
1432 		whitelist[0x9508d995ca98DAc918D0a4F18Acd67BC545C8b92] = true;
1433 		whitelist[0x1077011F38c120973238eF266Dd45edad4a78E99] = true;
1434 		whitelist[0x32E094eeD5995331a45F2eb8727Da81156845Ff0] = true;
1435 		whitelist[0x88923378021BeA85f9b09Ce571a309E12C7D2262] = true;
1436 		whitelist[0x87CBd58ba04C8a0D26A0242d5Ac06f30269a96c5] = true;
1437 		whitelist[0xf5D4E11f6392a138cDaD459367C45Fe8B90dB704] = true;
1438 		whitelist[0xF9f5a72142bd0bdb9A6053191104c010d912c1BD] = true;
1439 		whitelist[0x2ec970270130EdbA7D9B1f0f7cE7DFb3d1f6Cf6a] = true;
1440 		whitelist[0x32918DBB0Dad6C0E92eBc72F024A61FB8507277E] = true;
1441 		whitelist[0x8694EC6954a576D42e5a95488ae2C175A959f04c] = true;
1442 		whitelist[0x98c1d8A5cd2e6FA559ba6ae0680B388b799AC231] = true;
1443 		whitelist[0xFB52e265F03e1783e222f30106418a4a1487D0e7] = true;
1444 		whitelist[0x1F38EbCFfb0Be993b981225a917aAA8a6d6A4E52] = true;
1445 		whitelist[0xA7b2A23fF93f04D9D04a645Fc90450845106f19c] = true;
1446 		whitelist[0x104B2edadfe9F12E99C422E6823D1eEa40343564] = true;
1447 		whitelist[0xF7C53Fd0599632cAa643C8bC7b195ffE041F9134] = true;
1448 		whitelist[0x32Cc2EC897F21a77A704e9a7313af6a640c47BB5] = true;
1449 		whitelist[0xdDe74f034163192dd2170BB56B9CAc2d45Ce0a36] = true;
1450 		whitelist[0xDC89B615F0e36261c02b0B7d92bBcBD31C3C6269] = true;
1451 		whitelist[0x984b18B1823Fef04A4Ca7cF1e8A0eF5359fA522F] = true;
1452 		whitelist[0xd42d08ca1A876ac9BD2bFe631eE7D997cAE39229] = true;
1453 		whitelist[0x56C82d09b490F63531656E25838536C97e10610f] = true;
1454 		whitelist[0x0503bF05c49F96faaC2B0f5fD394672eD4603C52] = true;
1455 		whitelist[0x768058a4b0054dc1cb025889B2eFD9C2051d2Bf6] = true;
1456 		whitelist[0x76fC54b4eC08917fc4a7FC6a72d0BaAff9861ad7] = true;
1457 		whitelist[0xF43E468e6E39F490E7198cDe92c6995e843ef4c5] = true;
1458 		whitelist[0xD31D14f6B5AeFDaB5fE16DeA29fA46F6B8c15bF2] = true;
1459 		whitelist[0xB1Bb9A663765255542221B8C2106660c84E0B7ce] = true;
1460 		whitelist[0xF7C53Fd0599632cAa643C8bC7b195ffE041F9134] = true;
1461 		whitelist[0x8694EC6954a576D42e5a95488ae2C175A959f04c] = true;
1462 		whitelist[0x8d586f380846dCA988cB3B345231AF02F989C411] = true;
1463 		whitelist[0xe4A24b53C97A25A21fe0Ee6a1a1F652A5dAFe88f] = true;
1464 		whitelist[0x0EDb2533655876b1656243fd6ee9B16401281df8] = true;
1465 		whitelist[0xe958a38D6819bBa0501020e37e1F7C0e54584FAA] = true;
1466 		whitelist[0x008BA4907924f86C62fBb31Fe4A0dFE91c0e6acc] = true;
1467 		whitelist[0xe81FC42336c9314A9Be1EDB3F50eA9e275C93df3] = true;
1468 		whitelist[0xB7E64cb5B81cc275024B056DBDb8eB4afd84b4EA] = true;
1469 		whitelist[0x2A1Ca52f11A7F0aA923A6739d49c69004C7246e1] = true;
1470 		whitelist[0x1AC76Ec4c02c5488E8DcB892272e9E284d5Fe295] = true;
1471 		whitelist[0xE0E7745713Cca16eE73e231428921B424f419b10] = true;
1472 		whitelist[0x001Bf5f51453E74aa44dE9eE47F9deB6E896Ca29] = true;
1473 		whitelist[0x2227de445Dbfd90712C48bCD74D492CccA1Cb242] = true;
1474 		whitelist[0x767A60F295AEDd958932088F9Cd6a4951D8739b6] = true;
1475 		whitelist[0x10455d2469b5235F95C2512026307bD77b1511d2] = true;
1476 		whitelist[0x00000000000Cd56832cE5dfBcBFf02e7eC639BC9] = true;
1477 		whitelist[0xcb9F176f3C90837a727E4678e29515cB2D557F18] = true;
1478 		whitelist[0x5ea7e5e100aE141d1f0Fa98852e335CBa9A9f374] = true;
1479 		whitelist[0xb6E34A8A93031a24C264Be59D0BaC00bcaeF9051] = true;
1480 		whitelist[0x8149DC18D39FDBa137E43C871e7801E7CF566D41] = true;
1481 		whitelist[0xda1D4Bd894709DbD9a140c05bdaedd19afE7fb00] = true;
1482 		whitelist[0x4EfeceA2A42E1E73737e4dda7234e999A84Ca60B] = true;
1483 		whitelist[0x49AAD19d4f36EB41dDF3d54151D5ba0c0531A888] = true;
1484 		whitelist[0xdAE4012B41657B7118324Fe13aF91eEc0EC95acD] = true;
1485 		whitelist[0xAf981AFA2f5fd50ffEDBB5728FA0fFd2a99b93CE] = true;
1486 		whitelist[0x25a61B9CB2D749b062fA87b792ca60faEdDdF851] = true;
1487 		whitelist[0x10172b1A8fD270C2F4F45561617747ad2a35B31E] = true;
1488 		whitelist[0x885dA0E56F2B1aEd633f9A3847D3b057832a5463] = true;
1489 		whitelist[0x9294bb652f4B1392Ff8c266Cc75BA45ba312c124] = true;
1490 		whitelist[0xCbE7396ea129242438C565Ec5dCB8A37f187E639] = true;
1491 		whitelist[0x5C45b39E13c4129dF392072045747DDbcedA1eB9] = true;
1492 		whitelist[0x84a6C06CCEfE63C5C8df52dFff3101a480aD3760] = true;
1493 		whitelist[0x2bFaC2D8D79D13D45862EA64ce0f25C5D34e9cA8] = true;
1494 		whitelist[0xC41CfcEc2b5f65A2c6bF70869cbC116Aa0ec0Ada] = true;
1495 		whitelist[0x2378598aEf5768d12df9ab72dee9AF37a2741F5A] = true;
1496 		whitelist[0x8205F2AB276C78d06a8F9bE9b1C97A776C7dD805] = true;
1497 		whitelist[0xe5A7a206E9a8769f90ca792EbB68E9268231F717] = true;
1498 		whitelist[0x1258436bc2Ce96f60e0032b07DA166Ac588f1a00] = true;
1499 		whitelist[0x4218bA2E10E56aAC410205A7576d8FBc3DD54420] = true;
1500 		whitelist[0xc2086C494819b15EF371585e45682C50CbC20aF5] = true;
1501 		whitelist[0xce0E1766269e63a87FB1C1e5C745B1db32b5713d] = true;
1502 		whitelist[0xDc610C4766450E3184AfC312ef2224702299219b] = true;
1503 		whitelist[0x3bfd26bCF88E595F65e1583AfbdFcd6CF87EA169] = true;
1504 		whitelist[0xdc52C2E7FC45B30bd5636f8D45BBEBAE4CE87f46] = true;
1505 		whitelist[0x264B6B1D31F95c01876C17a8b30D3Ce68dF1371C] = true;
1506 		whitelist[0x2705045Ef16d185a84AEF570cdddE535A0A95d1f] = true;
1507 		whitelist[0x9Be8cbE548110b4F09D932cdfbaC082c9dD98899] = true;
1508 		whitelist[0xbb5D3Fc1E82dCAD48d07ADac292a08d765FD1eFf] = true;
1509 		whitelist[0x419fD53f8c5c957Ae2c52A7df6904e986E59db62] = true;
1510 		whitelist[0x284643Cea4d1Aa85596C69195557967408Fc18F7] = true;
1511 		whitelist[0x91cE2EaAa0ae31B8b109E4a2038Fa7aC3e83034f] = true;
1512 		whitelist[0x38b3bb561700fc263240c4bCfA6F9a5A10167556] = true;
1513 		whitelist[0x4FB54f1F8c545cf31619978E97A3F8396894C88f] = true;
1514 		whitelist[0xc6F236891c3099ce4b210793BB1b3030fFfBaA67] = true;
1515 		whitelist[0x6232d7a6085D0Ab8F885292078eEb723064a376B] = true;
1516 		whitelist[0x0f0924A3a5111e7987A23a49Af826D2Ba431342e] = true;
1517 		whitelist[0xC273ee810842f9fFc9Ce781e4AeD4533A4bdd6De] = true;
1518 		whitelist[0xa58112df57A29a5DFd7a22164a38216b56f39960] = true;
1519 		whitelist[0x33d704D1347bBf81C05104bC41beE19e83C02205] = true;
1520 		whitelist[0x389fb1a81410D20cB6119c134A727E21ebBFEA59] = true;
1521 		whitelist[0xA381D21bc2bc9e349dc4332854788d1036BBD107] = true;
1522 		whitelist[0x89032c0cFF4abb9bc490dF104Ec89eff27314909] = true;
1523 		whitelist[0xdb29C08D0A11D376A54EAABbaa89EB7853e32da5] = true;
1524 		whitelist[0x32E094eeD5995331a45F2eb8727Da81156845Ff0] = true;
1525 		whitelist[0xF896E426615E44a2610F4C3D5343B63b557E11e2] = true;
1526 		whitelist[0xa4939a893C7AEfE9629d7525BE3Db799a9E1045B] = true;
1527 		whitelist[0x36ABc45216Ee411581DA092B9caa98Ac460afc45] = true;
1528 		whitelist[0x657A38e6994CB578351376dCDb077330D00665d6] = true;
1529 		whitelist[0x459B3154699F7e49F7FBcf9591dEfa0a1f1177fc] = true;
1530 		whitelist[0x9b7657D46ea863bfDD0c48b4C41794D47e95E6De] = true;
1531 		whitelist[0xcE20b5aF05868d1d39a65FA47ec285067145686a] = true;
1532 		whitelist[0x40b1ED5efC7aE8a8B50F34963bA89984DcB0529d] = true;
1533 		whitelist[0xB35248FeEB246b850Fac690a1BEaF5130dC71894] = true;
1534 		whitelist[0xad9df182acaDfAd985E854FB93F52F62C0Af6db4] = true;
1535 		whitelist[0x84572C31ACdd30c03982e27b809D30b1eFbCD8f2] = true;
1536 		whitelist[0x018881270dD7738aE1D74dCBc48Ed70A0B47E5A5] = true;
1537 		whitelist[0x8Bfd22d7fa34839447af3B4ED35B847DE5882dC5] = true;
1538 		whitelist[0x9f3BcE237ea107ffad3aa7852F8Dd847e6b82A5D] = true;
1539 		whitelist[0x354d4D759c49094f60D537bfD7177c05b70c20cC] = true;
1540 		whitelist[0xf89C94f43B36719046b55E2AE60BacBfc0dB1C6a] = true;
1541 		whitelist[0xA1830E8d9F019FEB448478a171Bb37Cc6C4c0482] = true;
1542 		whitelist[0x40f465F1ba4c2Aba91c0C896cb92bbe4c7e545DF] = true;
1543 		whitelist[0x57a879266C02bD29d11C956156E9a524de4483D7] = true;
1544 		whitelist[0xFaED43c98a40711e9521859f9ad80a90B6a84968] = true;
1545 		whitelist[0xAB723364C7Acb9b26029f002f942d2C8ed789a3B] = true;
1546 		whitelist[0x3E09005C7B9FC14B4f035260aA4a38B44566dd62] = true;
1547 		whitelist[0x1F4FD7F98275D44A48E1DDFB184aa125dC8Aa9AE] = true;
1548 		whitelist[0x5ad3b640c760CA369321682A0FfBf866C07b2b5a] = true;
1549 		whitelist[0x0B0b8696f89Ba073FC8515FF649618A4fb361885] = true;
1550 		whitelist[0x8CFBD1994cF924d80ec7891CafcEc51CcE4f999b] = true;
1551 		whitelist[0xab88C3E77D9CEB047Face254612653Ee35C9ff0e] = true;
1552 		whitelist[0xF8eF2dD0Bd0D7cD6f60DDa52ab01da6cD2AbE7B1] = true;
1553 		whitelist[0x7417E3bCdE8726908895152A8F3925a756b1894D] = true;
1554 		whitelist[0x0FdbfDc79ad0e2e3F76cC8b7Be6e8bE901E57552] = true;
1555 		whitelist[0xA23FcB4645cc618549Da1b61b8564429C2C32Ff9] = true;
1556 		whitelist[0xCAc5EE14B2155bDf3c7CACAF091c9b481fB47bD2] = true;
1557 		whitelist[0xF405f10feDE59e1D7350c3A3fF8488C33a1f07fa] = true;
1558 		whitelist[0x6ae615835aa020fF1239DEC4DD7A3A5e8b975649] = true;
1559 		whitelist[0x730Ca048cab18D4F09F2A295936325adDfeE7BcF] = true;
1560 		whitelist[0xC9582D09acDec05aa8Fee7fdebb5F10B7E9d039f] = true;
1561 		whitelist[0xE16491e0c975E0394D30e356dE7495Ad8550eAfa] = true;
1562 		whitelist[0x5bd3bf853B9970D93Da64d7628919997C1a06a6c] = true;
1563 		whitelist[0x98CaC89Bba31cE2B18f8CfdF34dAEdF29F383B2E] = true;
1564 		whitelist[0x04ceFD6166D0Ee8f8112Cae7237Bb9207a0ef253] = true;
1565 		whitelist[0x3F38FD15b1Ac453410d8D55e0Ec6696E70BE93a1] = true;
1566 		whitelist[0xE9fAD6906bF563732012Ebf6c30BD47E5E96EbC8] = true;
1567 		whitelist[0x4F64C6b8333F74890b0ba0AF4d480d8ecce01e17] = true;
1568 		whitelist[0xa8A2Aa7200B360e9B76fAFe60950a587449a0ed4] = true;
1569 		whitelist[0x08295076180ee8A6De5a4221Ab5bcD3f7A61200B] = true;
1570 		whitelist[0xEf6c1456A2467c9016a443812D0c182706FDF722] = true;
1571 		whitelist[0x11A6cdf624b0e32B377c6097606edFAB3f0f326E] = true;
1572 		whitelist[0x003dfd836b5AecC95F0E42F1E1F21879C31E8F46] = true;
1573 		whitelist[0xCcb147f3ef9Cb2e8E616D5bF55C1147d0Be6b371] = true;
1574 		whitelist[0x7Ed716a3c0a634fa033CAD0e53BC5fDBc838e23B] = true;
1575 		whitelist[0xeAc5f9b3cd48123a69FE69CE93A7F58100A56552] = true;
1576 		whitelist[0xF9567F184dE6B1fcF617850dE093F78f6c78b0f6] = true;
1577 		whitelist[0x788F93C6165B1Ae7A1297527d0037160A32C1252] = true;
1578 		whitelist[0xd35fC346e15BA5b446917C9fD23A9471d6144701] = true;
1579 		whitelist[0xF3D9281fa183B74F32B96E1c5244596045f4edE8] = true;
1580 		whitelist[0x7302bC5b47F5588174A148C90747a88CB528A8c1] = true;
1581 		whitelist[0xAca3b4110403F3c4dacb35A7B3Aa0a84eFb6A3e9] = true;
1582 		whitelist[0x8F8B4759dC93CA55bD6997DF719F20F581F10F5C] = true;
1583 		whitelist[0x69469f819AbdF47f0164b7fe905993EBDF09bbE8] = true;
1584 		whitelist[0xb9ab9578a34a05c86124c399735fdE44dEc80E7F] = true;
1585 		whitelist[0x327F66c77330AD01CBe89DE9523811CBA0c33fE6] = true;
1586 		whitelist[0x0EC666C5901ba8829138716176Fb44CF214939ed] = true;
1587 		whitelist[0xD68faC38f2AA31c499DF26e3C432Efe3bB019164] = true;
1588 		whitelist[0x3BA3D09f70CED571FE3F629Adc234e200ef5EA46] = true;
1589 		whitelist[0x08cF1208e638a5A3623be58d600e35c6199baa9C] = true;
1590 		whitelist[0x59e147Ec5BB417745356A1e2d9433F3A07D74419] = true;
1591 		whitelist[0x87933405d041141e3564cDD7a2D4b62411E76e89] = true;
1592 		whitelist[0x40CbFEd4ce554C018306207A597586603428152d] = true;
1593 		whitelist[0xb761b98E4A80A3b2d899Bd5cD7E04288952F614a] = true;
1594 		whitelist[0x06687d0C06053124BF67B83a71dB1Dfb50A88527] = true;
1595 		whitelist[0xe425FbdDA869433Db7a123F55d1Aa476947e8040] = true;
1596 		whitelist[0x439EEc211024b3389D38972003cB9D845cF420ce] = true;
1597 		whitelist[0xb540b333FD631F8c4bb389c6E81A99dd50C811C4] = true;
1598 		whitelist[0xfE505FDC65030dD93F44c5bAE1B0F36a55b50291] = true;
1599 		whitelist[0x1ad0b2a3760E4148479bC882c4f148558F17Fcd1] = true;
1600 		whitelist[0xdB39DD32A6203840dB4D7406D780aB3125b66588] = true;
1601 		whitelist[0xcC833833C2B9B0fd7e3122d92AaCb72B53633768] = true;
1602 		whitelist[0xEa506b68aA88120a939372aB746A1b35551AF6F9] = true;
1603 		whitelist[0x9d528bfDef21538303A59D5284801299DdF64e37] = true;
1604 		whitelist[0x80b1960Ce559fDF3f7543B0d87fbB5381f8C3903] = true;
1605 		whitelist[0x82674C58211C0134348B016810Db718b832d4233] = true;
1606 		whitelist[0x8029D8D22610E457360e7Bdfb388e138A7730DA5] = true;
1607 		whitelist[0x97e167a835C54FdeB1F55433ff8bFb94E3359514] = true;
1608 		whitelist[0xD26593E8A99999d418bC58d7C77Ca10611731162] = true;
1609 		whitelist[0x159Ae2b05b03460954fe7b6C0984157DA1A64ea6] = true;
1610 		whitelist[0x1dFbCA42cC60Fbbf3b5FADc3BDF55353B1EA807f] = true;
1611 		whitelist[0x23B2b77c050c4f4fB2EFEb8A6755719A179e7430] = true;
1612 		whitelist[0x681Cbae1C41e5eeC8411dD8e009fA71F81D03F7F] = true;
1613 		whitelist[0xc8664B56Df7ea10C57a8499B10AfC70C78b0650e] = true;
1614 		whitelist[0xbE863eADD096Fe478D3589d6879d15794d729764] = true;
1615 		whitelist[0x5b44a8aBf5b5280cD93fc7E481FbF1Fd46bEdB1A] = true;
1616 		whitelist[0xe6B31e9FC87A81a9bdBFfadBD0c9809f53723efA] = true;
1617 		whitelist[0xa6D3465aE5Da55e36aE33d508154c91F1fF0Bb17] = true;
1618 		whitelist[0x517eCA408D25F7058812943f0682271A4271BF08] = true;
1619 		whitelist[0x2DcCbFFB389576d2Da4e9B71A9016E213bbD5ec7] = true;
1620 		whitelist[0x1f8A12Ad2F144193B12543ba7fd0410351142858] = true;
1621 		whitelist[0x2A121375edF522F3bf8e0704661626Eb5C86aC8A] = true;
1622 		whitelist[0xD30F2888E7928b52EA5bF4cb1D323e0531aFe272] = true;
1623 		whitelist[0x3B570118B74fa0A39AD7C7FCfd75EF7A7A3e3301] = true;
1624 		whitelist[0x25A6BBD4D8f041B4B14CD703560995a09A74B464] = true;
1625 		whitelist[0x42a32D733BDf680c8741C9d2C286D4adF73C0867] = true;
1626 		whitelist[0x5b2094bc95238Cd5A861eA3Bc8f2e3c0C4678ad6] = true;
1627 		whitelist[0x70B0013c64E3439dE45bAcAa1978146b14cC9F2C] = true;
1628 		whitelist[0x528d4e4E0dbF071eC23013f06D8487BaD5A8a68B] = true;
1629 		whitelist[0x35B64947F786c8B756b35Fd25ef2B9917aCC25d3] = true;
1630 		whitelist[0x3F138407A8893f20FC47b4ef0A9c972c19084a57] = true;
1631 		whitelist[0x8e50b222b2C027259392f9F4d6E39e59c24edfC8] = true;
1632 		whitelist[0xE1fc8b4c3566F5459923CBfadDc1B7741a997c58] = true;
1633 		whitelist[0xA4f76fd64aD5cd460c6FB918Fc075EBCef8b5F9E] = true;
1634 		whitelist[0xDAE7ed1ce27D9fF542Ab03c4aD845ACeb2B23E0C] = true;
1635 		whitelist[0xF1140e2fBE438188dFD2FE1a01C6D24D90eF0CA3] = true;
1636 		whitelist[0xB7a0cF8cc33025A654A73dbae1256828c004b7dc] = true;
1637 		whitelist[0x9349F2246D266445f0D40055c9529F084a3ea74F] = true;
1638 		whitelist[0xa8C14D9Fe2cbDF56E610f8F4647c2776c3505526] = true;
1639 		whitelist[0xbFCf0663Ec8eAbd2090Fdcb36534fc8352BDc042] = true;
1640 		whitelist[0xAF77E6ce8FEf4b096E909Ebe6c475Cb991c27675] = true;
1641 		whitelist[0xBac3346e78f18485575B94AD0b1132017Eccb62f] = true;
1642 		whitelist[0x4F7f9811De292Aa6E7FbBada8a1EB0eAB5d60254] = true;
1643 		whitelist[0x849117D3722dC581e588C1F3B02cB7828BdEf2EF] = true;
1644 		whitelist[0x6c0ea11E09f138d56E61b9dbb86cB7422d4e7183] = true;
1645 		whitelist[0x6661280D2363f69A615AE69f57aDF936a89644ca] = true;
1646 		whitelist[0xbAc9E1Da19FF794Cf1037eC332558C7987C6c506] = true;
1647 		whitelist[0x0B01F1310e7224DAfEd24C3B62d53CeC37d9fAf8] = true;
1648 		whitelist[0x82A0F25b6FE7E406c2c6E7884342164D7A9438c0] = true;
1649 		whitelist[0x297cF79ad1CA102DE119fd5C4593E7c4CD99b13C] = true;
1650 		whitelist[0x52734AA7B37A023BD650355A7Ed91025B1A2147E] = true;
1651 		whitelist[0x418e2e450B7dE452Bc479A4efCd7f4262c6cf79c] = true;
1652 		whitelist[0x97A554cb95EDEc7037292dEAa883864Cb35BC668] = true;
1653 		whitelist[0x16D9fd80d8e3f055ba7793794E811712dcbdD9c2] = true;
1654 		whitelist[0x7EB91dAD1fb797EF65887105f0DF3d0ceafb871C] = true;
1655 		whitelist[0xDf4abd11D93cba45F8bE55E3A41c1c18c6f8e9C1] = true;
1656 		whitelist[0xC17f20335080cD0b7283e042C89F16605f3A085f] = true;
1657 		whitelist[0x542a5651F84145EfAaf8dC470e2adC2922877807] = true;
1658 		whitelist[0xC1Ba5d206EE1F07E54185dA06bfAfbF83367BFDd] = true;
1659 		whitelist[0x4dce3bB119FD5785f5f40B1394fb9b3F4d78096b] = true;
1660 		whitelist[0xE55c69cfD20Cfa25651c72b84383dE6104104Eb4] = true;
1661 		whitelist[0x1077011F38c120973238eF266Dd45edad4a78E99] = true;
1662 		whitelist[0x536122207cdE9c0b261ce01E9Af0EE2743c790bA] = true;
1663 		whitelist[0x92d0060BF437A8f6BD9AC72233Ab8cB866BC63a0] = true;
1664 		whitelist[0x6BD662F8b7258D0e371E18A23d509D045e486635] = true;
1665 		whitelist[0xBA2f3CfC765cCE262579aB6Db69Ac7022bfDf0f2] = true;
1666 		whitelist[0x21426471eBF0b7db0F07216d81a897B5F5554394] = true;
1667 		whitelist[0x6EFc434b7858fc7307d0215142b3c019eeee7F72] = true;
1668 		whitelist[0x13afD331C4D411c0dd81Ea257d6C42b6B8a4BBDd] = true;
1669 		whitelist[0x269e5f8AddFAF05dDfaef856f6A36fa27fbaCc38] = true;
1670 		whitelist[0xE37523f553606C6BbB0d5bD78da6C760B368CA2f] = true;
1671 		whitelist[0x2eFf70000afa05066aF0134A1dF455bd2Cb41763] = true;
1672 		whitelist[0xFA8479b6933EBD2A5921eBe82EE2734f494E3f26] = true;
1673 		whitelist[0x5138C21b2A1a4898ee232F00d57B8f68678A7D99] = true;
1674 		whitelist[0xd0C73ceB728bbD0eE113A7a7e312A0173c833E2c] = true;
1675 		whitelist[0x92eC90D6e692d39B189308621c9B12f33372dDB9] = true;
1676 		whitelist[0x189ecEbfa5D3c5EA82d5172b1069c3305a0a149A] = true;
1677 		whitelist[0x92Cee34282f5ef5F387abE41b2976af83296b316] = true;
1678 		whitelist[0x49E3cF47606a5Da7B11b270A790E2112a467485f] = true;
1679 		whitelist[0x552922eEdfF18324098A18b7CC143E96855db7Cf] = true;
1680 		whitelist[0x4E87AAb2ffC3ddDA8142981273c82Df2b5Cc76D7] = true;
1681 		whitelist[0x38865683F5DD59048CCA3A2e91064a731bdB45A2] = true;
1682 		whitelist[0x82509f1803d292FD4bb9A93abA54aA533D6609Db] = true;
1683 		whitelist[0x6Ac0b41B017347309119e13159878B1F3e3eb410] = true;
1684 		whitelist[0xe74a12e1bEFb0d65a399db1A6e231abD8Cf4E746] = true;
1685 		whitelist[0x0EE15685674C6A0B1fF634d23d02D1Cb650d883A] = true;
1686 		whitelist[0x0700D8a9c0B225946b60F8d24661878CAA6683A2] = true;
1687 		whitelist[0x853D18353Ac666E87dB98c59550F2C7068f55cD7] = true;
1688 		whitelist[0xE77d66e7F0903bCE55794E5f5828d521C27e1584] = true;
1689 		whitelist[0x0c6306c1ff8F0cA8432B761085d5Ce74160A499a] = true;
1690 		whitelist[0x6Ec06f8835F41Cc79BB4ADf25ba3DE13c7A5996a] = true;
1691 		whitelist[0x2bDFC32ed7B113D79d04254848C8550D6Be2057D] = true;
1692 		whitelist[0x6F3bA8A845D18D32bE6985650E449d7c29926F7F] = true;
1693 		whitelist[0xc3Ab4F4451d65299540242bb8Ab3C2c65154B3F6] = true;
1694 		whitelist[0x9Ef6aF5379c6C52a1e545Af2085D85015a6aa6Cd] = true;
1695 		whitelist[0xE2d43dA6A3b36B0E97430e42420BFDE4052D0262] = true;
1696 		whitelist[0xcc073E4c1930a974bbF9f07cfC845E639c3026af] = true;
1697 		whitelist[0xD114B66903A4Fe92a75Bb95e6b3059c0766ed0d9] = true;
1698 		whitelist[0xd2587e936569F12e4e553033C6be96d01440ecB7] = true;
1699 		whitelist[0xd61daEBC28274d1feaAf51F11179cd264e4105fB] = true;
1700 		whitelist[0x68e19ADa86678133FEfDc54A98558746bD56B067] = true;
1701 		whitelist[0x542a5651F84145EfAaf8dC470e2adC2922877807] = true;
1702 		whitelist[0x985B03CDC4Def39ED62785458F339DE0121be4D3] = true;
1703 		whitelist[0x681Cbae1C41e5eeC8411dD8e009fA71F81D03F7F] = true;
1704 		whitelist[0x71EAb2760e640775De36Eed89983741Ae83806C8] = true;
1705 		whitelist[0xd21f21Ed6B663028D6B9fC31f240e6D42A2E401b] = true;
1706 		whitelist[0x5877Af7FC64E26c695806E2Fd7e083c8511e61f1] = true;
1707 		whitelist[0x8149DC18D39FDBa137E43C871e7801E7CF566D41] = true;
1708 		whitelist[0x053E6294400a9268E35Df445624F58087C7F388f] = true;
1709 		whitelist[0x1434A664bbAF93AB2655fEf271E5eC4A2431c2D7] = true;
1710 		whitelist[0xff4160A2355B1fa42722cB63fA482E7061ee40e7] = true;
1711 		whitelist[0x10455d2469b5235F95C2512026307bD77b1511d2] = true;
1712 		whitelist[0x376275c4F9e4fffd8A89a90852F253F8e3373F67] = true;
1713 		whitelist[0x05603561a53de107Ce513fE12ED0B13Cc0Da4ed2] = true;
1714 		whitelist[0xD09bB703CBB6EB64034296Fc94488b6C6AC4d05F] = true;
1715 		whitelist[0x34b5f399cc5A1dD491666c9866941FB8E8D09746] = true;
1716 		whitelist[0x1CBD934Eaf49FE310Ba4E27606029c9dEF0168E3] = true;
1717 		whitelist[0x96Afed3Ea9A4238F860423B701AB94CAE084F369] = true;
1718 		whitelist[0x6232d7a6085D0Ab8F885292078eEb723064a376B] = true;
1719 		whitelist[0xb6E34A8A93031a24C264Be59D0BaC00bcaeF9051] = true;
1720 		whitelist[0x13280bA47862A393494F5a46c1910385aA292bd2] = true;
1721 		whitelist[0x1Ca049Ccd785d1400944070c665B3c3132684373] = true;
1722 		whitelist[0x0f0924A3a5111e7987A23a49Af826D2Ba431342e] = true;
1723 		whitelist[0xc7A0D765C3aF6E2710bA05A56c5E2cA190C2E11e] = true;
1724 		whitelist[0x8Da15F7e6bf20Eae393D0210d0F69eA98fC8Ea5e] = true;
1725 		whitelist[0x9975969F2083694d35448c2a4cC40AfF24566700] = true;
1726 		whitelist[0x564B5E5BEcDF359357C15810Ef172dD9d6Be6279] = true;
1727 		whitelist[0x64174450c49242535B4184e3988CC4145B80526C] = true;
1728 		whitelist[0xF7CB4396Dabe5f86128d03A6781bAFE7844bF6Ff] = true;
1729 		whitelist[0xA732BB434e43E007C74B5f26250EE92380c3d2B6] = true;
1730 		whitelist[0x717ba2d9AE88A92C98EB796D3D7dD2D09755a0d6] = true;
1731 		whitelist[0xb1821263a27069c37AD6c042950c7BA59A7c8eC2] = true;
1732 		whitelist[0xa1fC498f0D5ad41d3d1317Fc1dBcBA54e951a2fb] = true;
1733 		whitelist[0x88A92a8a56e21C51d8C0d402d9a84FC81CcfF60C] = true;
1734 		whitelist[0x4fEf654560d6ad788F4b35A5CD02ed185C12Fbbf] = true;
1735 		whitelist[0x8293Fdc6648dcd00b9194dfa0ab731b51E294F66] = true;
1736 		whitelist[0x3704E8d3a85e253b49cda9e5C6470979D6202336] = true;
1737 		whitelist[0x1793a9D2752A0E65EA66e1D5F536d59717D622a4] = true;
1738 		whitelist[0xe8d0587D82Ae54b0dd1F8E234bA3f0Ce1E2f047A] = true;
1739 		whitelist[0xe81FC42336c9314A9Be1EDB3F50eA9e275C93df3] = true;
1740 		whitelist[0x6a167aBE38959433aaaA984B3d50761aC60ee875] = true;
1741 		whitelist[0xD80Dae31104d2361402128937bcF92A59F13E6E3] = true;
1742 		whitelist[0xbb5D3Fc1E82dCAD48d07ADac292a08d765FD1eFf] = true;
1743 		whitelist[0x2bC99F6C868b14Ea6BdE976CE5310F6115DD1382] = true;
1744 		whitelist[0xAea6D987D521B0e61FD4af5164Ab743E00eeC94f] = true;
1745 		whitelist[0x8Fac841807E21807F511dAf3C04a34cd78661F4c] = true;
1746 		whitelist[0xaEE7E9BB015E1543c8ab3226a9d9615971C4C060] = true;
1747 		whitelist[0x5F652f6443d742078A9AbB1C9e453Ed009BB64F2] = true;
1748 		whitelist[0x8ba60b93055713b86A952102239d894dE4b85AB9] = true;
1749 		whitelist[0xdDF06174511F1467811Aa55cD6Eb4efe0DfFc2E8] = true;
1750 		whitelist[0x4dDAc376f28BE60e1F7642A4D302C6Cf6CAe1D92] = true;
1751 		whitelist[0x41A00092909Aa49bB3144eA576d54C4E3e388BD3] = true;
1752 		whitelist[0x5E78d0c7E548bbD070C84Ef6E199e521f4a135a5] = true;
1753 		whitelist[0x08cF1208e638a5A3623be58d600e35c6199baa9C] = true;
1754 		whitelist[0x4EBee6bA2771C19aDf9AF348985bCf06d3270d42] = true;
1755 		whitelist[0xBc486420659a2009987207649d5d0b401349f679] = true;
1756 		whitelist[0xC9582D09acDec05aa8Fee7fdebb5F10B7E9d039f] = true;
1757 		whitelist[0x24f2112A3fe2bc186ffc7ABbAba34bb49d7b199e] = true;
1758 		whitelist[0x528d4e4E0dbF071eC23013f06D8487BaD5A8a68B] = true;
1759 		whitelist[0x0338CE5020c447f7e668DC2ef778025CE398266B] = true;
1760 		whitelist[0xF7FDB7652171d5C2722B4cDd62c92E90f73c437E] = true;
1761 		whitelist[0x269e5f8AddFAF05dDfaef856f6A36fa27fbaCc38] = true;
1762 		whitelist[0x327F66c77330AD01CBe89DE9523811CBA0c33fE6] = true;
1763 		whitelist[0xb9ab9578a34a05c86124c399735fdE44dEc80E7F] = true;
1764 		whitelist[0xe557fBF5009ed3D3b2a7B2f75c5bc673C0e4D0d0] = true;
1765 		whitelist[0xfFC88fC868A01003Fe5D3FCC389051a365d4f932] = true;
1766 		whitelist[0xF9F40ceaca61Ec55CFb09AF821553c3b068341aa] = true;
1767 		whitelist[0x69469f819AbdF47f0164b7fe905993EBDF09bbE8] = true;
1768 		whitelist[0xa8A2Aa7200B360e9B76fAFe60950a587449a0ed4] = true;
1769 		whitelist[0x38865683F5DD59048CCA3A2e91064a731bdB45A2] = true;
1770 		whitelist[0x4E87AAb2ffC3ddDA8142981273c82Df2b5Cc76D7] = true;
1771 		whitelist[0x6c71b204b394c9B8ADd99Ea37B6d1c2fc2b130FF] = true;
1772 		whitelist[0x58f5CE1BDCB2D87EccC0cA2FD8D5073e4EC316a5] = true;
1773 		whitelist[0x62BA33Ccc4a404456e388456C332D871DaE7ae9e] = true;
1774 		whitelist[0x16D9fd80d8e3f055ba7793794E811712dcbdD9c2] = true;
1775 		whitelist[0x0B455480f26444a76638EAC5b6a5B13B60469758] = true;
1776 		whitelist[0xEf2e060E1569816B37bB923A911eC952b8694f42] = true;
1777 		whitelist[0x0700D8a9c0B225946b60F8d24661878CAA6683A2] = true;
1778 		whitelist[0xCa570FB7Ba1Da03a74C929580Dc17d543bF78b90] = true;
1779 		whitelist[0xD724aDa4d48a795e99e547eb2DC2597B06Ac8392] = true;
1780 		whitelist[0x08295076180ee8A6De5a4221Ab5bcD3f7A61200B] = true;
1781 		whitelist[0x8aDc376F33Fd467FdF3293Df4eAe7De6Fd5CcAf1] = true;
1782 		whitelist[0x7bF925893F7713e00493A67Ef0f0127855AD36be] = true;
1783 		whitelist[0xCcb147f3ef9Cb2e8E616D5bF55C1147d0Be6b371] = true;
1784 		whitelist[0xeAc5f9b3cd48123a69FE69CE93A7F58100A56552] = true;
1785 		whitelist[0x763A7bfDe263168dA6DF5f450b4860ccf76749Fa] = true;
1786 		whitelist[0xB3787093e364AE7419Bf9d0c4709900C0cF3469c] = true;
1787 		whitelist[0x84572C31ACdd30c03982e27b809D30b1eFbCD8f2] = true;
1788 		whitelist[0xeB42B12a965CFc16878A966c635e04f15146c665] = true;
1789 		whitelist[0x69f32dbe156D3c5c116CA8feC75ECeB5148841e5] = true;
1790 		whitelist[0xEF1509c5dCb93AFbE3195D4BB28CCc8660eB4945] = true;
1791 		whitelist[0xac1Eb7459AF366444CC502d9b002E2eEf577C02E] = true;
1792 		whitelist[0xda1D4Bd894709DbD9a140c05bdaedd19afE7fb00] = true;
1793 		whitelist[0x11b03346Faabd4A0c9778D2ABa744aE7C7D62B45] = true;
1794 		whitelist[0xA7D7Ac8Fe7e8693B5599C69cC7d4F6226677845B] = true;
1795 		whitelist[0x06074Ff83C4240c554dE83160E611007D66125d5] = true;
1796 		whitelist[0x0Dcf3968f5dD3A68b9a09E67c1E3eC08a82e6C22] = true;
1797 		whitelist[0xD6b954F59F0Ebb252Edc7796c64BA167A1E2efAB] = true;
1798 		whitelist[0x144b9A09B3d4e88212F69cf21bFdE6e3Eb64420e] = true;
1799 		whitelist[0x82674C58211C0134348B016810Db718b832d4233] = true;
1800 		whitelist[0x4650D0c9E3148A8f66AF374820AA2eCa0A47DAD4] = true;
1801 		whitelist[0xe45aB678768CC7E5BAb6DE02Fad7235d6c615037] = true;
1802 		whitelist[0x21af0A9117ee420CB26c32a49c59220F38F5991b] = true;
1803 		whitelist[0xdDe74f034163192dd2170BB56B9CAc2d45Ce0a36] = true;
1804 		whitelist[0xfc27C589B33b7a52EB0a304d76c0544CA4B496E6] = true;
1805 		whitelist[0x92eC90D6e692d39B189308621c9B12f33372dDB9] = true;
1806 		whitelist[0x003dfd836b5AecC95F0E42F1E1F21879C31E8F46] = true;
1807 		whitelist[0xC17f20335080cD0b7283e042C89F16605f3A085f] = true;
1808 		whitelist[0x5204677EeFA881A16D5F8EC4C5978EC3c1dd3059] = true;
1809 		whitelist[0xc6435031926A631D0f241c9285c98Ea840Ee64DD] = true;
1810 		whitelist[0xFfDe865353Cb473544b8f98965A9D1f284ddA3b5] = true;
1811 		whitelist[0x49E3cF47606a5Da7B11b270A790E2112a467485f] = true;
1812 		whitelist[0xDf4abd11D93cba45F8bE55E3A41c1c18c6f8e9C1] = true;
1813 		whitelist[0xce0E1766269e63a87FB1C1e5C745B1db32b5713d] = true;
1814 		whitelist[0x593bee91EBe3A42e809d07189FCEbf9ca0414447] = true;
1815 		whitelist[0x00bF11233fB3A0C0593129e815D0511870299Bc0] = true;
1816 		whitelist[0xD39F25Fe6Fc80421585A07FCb854D2b11ceBE335] = true;
1817 		whitelist[0x182e0C610c4A855b81169385821C4c8690Af5f3b] = true;
1818 		whitelist[0x7f102a3fa4b786fBDEa615daA797E0f0e41b16e1] = true;
1819 		whitelist[0xf6910D47FbB1F5518d60C721D4189936eCd5a1b6] = true;
1820 		whitelist[0xD9917D5c30160240bDE95f8BA2A26034ABbc0541] = true;
1821 		whitelist[0x8e3eDE4CC366dF012231671863720DCc9C929b16] = true;
1822 		whitelist[0xA8652526111e3f5a78b112c3A59f0e7593033d70] = true;
1823 		whitelist[0x333BE3261D637c822DB11085AF4aD9E59aAA2FfA] = true;
1824 		whitelist[0xfba978799D7a6D67Eac09E2E8c052060804A175f] = true;
1825 		whitelist[0x5C45b39E13c4129dF392072045747DDbcedA1eB9] = true;
1826 		whitelist[0xDC4471ee9DFcA619Ac5465FdE7CF2634253a9dc6] = true;
1827 		whitelist[0x70879832e89e0F307801613aa1DAF2FAe5775A31] = true;
1828 		whitelist[0xE638cb3fA853622B2824CbDab3C27b06E8049651] = true;
1829 		whitelist[0xf1ca4Bf4C325C3078Ec25299601A519eBc6BEA6D] = true;
1830 		whitelist[0xAfAB37e854e2EDb2aa9E2830c6BFcd3eEf5C4C32] = true;
1831 		whitelist[0x33d704D1347bBf81C05104bC41beE19e83C02205] = true;
1832 		whitelist[0x3c6d7CE577E3703b8a93d2b77C20B23BfE23eD98] = true;
1833 		whitelist[0xd26E23aAA39F29e07b299DA734C77765F6866A0E] = true;
1834 		whitelist[0x435592c9DC7Fe4536c958D8f9975630dF18DF0cb] = true;
1835 		whitelist[0xe9e9B22B65F17808880f726334BAAfAA8A124Fa8] = true;
1836 		whitelist[0xBA2f3CfC765cCE262579aB6Db69Ac7022bfDf0f2] = true;
1837 		whitelist[0xd319f112bf73eAe5e3cf06bF8D4076cC5f8B1cD5] = true;
1838 		whitelist[0x55b451320A34CE88Fc8F1A1D9156e2AeB8aaD6Cb] = true;
1839 		whitelist[0xA3C277b8f35881CBdb017E52bcC376B3ce8F21dA] = true;
1840 		whitelist[0x5036e7857fdB7D8CcEAB64fDcC445C3B370f819b] = true;
1841 		whitelist[0xa51449B96801233C23639cc7B3D9d95860E1E7a2] = true;
1842 		whitelist[0x50025A3A50dA7Ae49630c5806b4411B0B7B55821] = true;
1843 		whitelist[0x035E8A0A57f24FD10D447c6cE44524513dd6e09C] = true;
1844 		whitelist[0x5EfDd9027575E7c3d1Fa5d7713462CF79Af5892d] = true;
1845 		whitelist[0xc6334A606bDd3699a553fC47a81796234E217B3e] = true;
1846 		whitelist[0xBe67DE0C3f7650B958aAbDFfF3BBD8D55d5c2Ccd] = true;
1847 		whitelist[0x7e8dA72bA1656F62a5a07B18b23E5d23BcD5ed3d] = true;
1848 		whitelist[0x6F3bA8A845D18D32bE6985650E449d7c29926F7F] = true;
1849 		whitelist[0x78D6F9b69c99d2D972bfdAC24fbD70B973e3b763] = true;
1850 		whitelist[0x45698cdCC733cBA4f8B1150C2f580587adF1Df92] = true;
1851 		whitelist[0x492346B79818f9F4A31C2779b52D1DE2C64DBff7] = true;
1852 		whitelist[0xd7E5A6F7b8B838F1be0856e5D3DD907608E40E50] = true;
1853 		whitelist[0x03753428Ea0A136cE3ABA808419B7230e413CE85] = true;
1854 		whitelist[0x2e274C7Ea1667D37373D6a7eC34201b4F4bB95dC] = true;
1855 		whitelist[0x6a7ea8945D0Cdb9b53030F63b4b26263e4478C8f] = true;
1856 		whitelist[0xc8a38F838b7951AB533be6d378ebE298fb41B25f] = true;
1857 		whitelist[0xBB343898E3cAfd815Ce8184973753fcE6E4341be] = true;
1858 		whitelist[0xD30F2888E7928b52EA5bF4cb1D323e0531aFe272] = true;
1859 		whitelist[0x76fC54b4eC08917fc4a7FC6a72d0BaAff9861ad7] = true;
1860 		whitelist[0x4defA30195094963cFAc7285d8d6E6E523c7f90D] = true;
1861 		whitelist[0x0EDb2533655876b1656243fd6ee9B16401281df8] = true;
1862 		whitelist[0x03F52a039d9665C19a771204493B53B81C9405aF] = true;
1863 		whitelist[0xb78196b3e667841047d1Bb1365AB8fB3d46aB1A8] = true;
1864 		whitelist[0x9006eeF759C79745509E8D99Ebd84eFD75975f3F] = true;
1865 		whitelist[0xE2F130B5c02fFBE322DB7904a8a42198ffDC8EC0] = true;
1866 		whitelist[0x66D30263D3E33dF6fECAFB89Cc6ef6582B248Bcc] = true;
1867 		whitelist[0x06056Dcdc6471439e31e878492f594B6F0D8F9D0] = true;
1868 		whitelist[0x79a074122bE96E1Fc9bDd32Dba04759421D12f90] = true;
1869 		whitelist[0xB8eD097E86b7688F29b5b6Ff649AF573682F6F53] = true;
1870 		whitelist[0x06CF8399E3f1ef9Cd94031a6FaE9F47877F512e7] = true;
1871 		whitelist[0x9B32bf5D8D88Dd5CEF0D32cDFFf2eAB50d2e04b3] = true;
1872 		whitelist[0xcBA7f4f44473e32Dd01cD863622b2B8797681955] = true;
1873 		whitelist[0x43961f20194C1a27888386F8547B91aC23f9d8Ae] = true;
1874 		whitelist[0x8Be7b518155184aa03fbDa531a165c567DA9AFfa] = true;
1875 		whitelist[0x9128a39Fdb22De4cE3594e2e2e8EdD7BD9aBa987] = true;
1876 		whitelist[0xDD8dB9f64512cB13fDfe24565670C603381FcA27] = true;
1877 		whitelist[0xe5A7a206E9a8769f90ca792EbB68E9268231F717] = true;
1878 		whitelist[0x9D16ceDC91b859F2e03d94F479994f795F422e27] = true;
1879 		whitelist[0xb9d1Fb123C779B47269280D0e152Ac32E40b1177] = true;
1880 		whitelist[0xf6Ae21A0586691f7F4Ea86fc4c08731Fa455aCB0] = true;
1881 		whitelist[0x06904f07a74e1d47313cB530AF0487BF705aB099] = true;
1882 		whitelist[0x64B7fcC8C17540139BDd84d00c7261035602Cb66] = true;
1883 		whitelist[0x050920eDA4014e25DED17c346b425239a468d63d] = true;
1884 		whitelist[0xf823825DC97a8c81Ec09D53b6E3F734E76E60cB6] = true;
1885 		whitelist[0x7cB0393740204B1034E58Fddd1580563B6f3c0a3] = true;
1886 		whitelist[0x2fF1bdC41B5c602e90951908ffeD997f3b5D97a6] = true;
1887 		whitelist[0x0d9506F3498c73fA1b26Ec9f8B913834645a8b37] = true;
1888 		whitelist[0x600a782c4D56961f8f72220d4c28b413b9Cf3c87] = true;
1889 		whitelist[0xeB5264d5E08452c4966788c1C63D073B56cbff93] = true;
1890 		whitelist[0xe684AEDcb17D70923dD50aC757ECeDc43d86cc49] = true;
1891 		whitelist[0x38b3bb561700fc263240c4bCfA6F9a5A10167556] = true;
1892 		whitelist[0xD5174e20aa8DCaB93bd7551CcB990b4B9E9f7789] = true;
1893 		whitelist[0x5520082cAfe40F2De90DBDAf29a2ECC606B8f9AF] = true;
1894 		whitelist[0x13454530E32A74faf73FB8210361aa66C3bba5A6] = true;
1895 		whitelist[0xab40ef5d3D86f90a5069df913edcDc4E4B99f9a6] = true;
1896 		whitelist[0x6bd8441EE1e4a1B326a29439A1d225627DfAd071] = true;
1897 		whitelist[0x67ce74c19cdc9FC596B96778b9C17B10d34AF36d] = true;
1898 		whitelist[0xc82a75D564521306e7Ee9eBD530a459292c45Ae7] = true;
1899 		whitelist[0x0E1ca0c78C85457e04DD6F256b290f6c31B7629A] = true;
1900 		whitelist[0x94B60bCCc939Aeb28FeC230659E4603eF17324f7] = true;
1901 		whitelist[0xc252e410E213A9bc3DB942B4C7c6C69AA3cE8718] = true;
1902 		whitelist[0x79FBa65F42731E4a4dB8472f0B2A5b48d0b4E7F9] = true;
1903 		whitelist[0x1F4FD7F98275D44A48E1DDFB184aa125dC8Aa9AE] = true;
1904 		whitelist[0x419Cd8897906fA7A60105b2f0c3369e0e36D8D26] = true;
1905 		whitelist[0xAa73bdecb77AE96c2C73530cA1A276E256cb65e8] = true;
1906 		whitelist[0x075483AD26925E558955Ca1D2679c12D8453a8CA] = true;
1907 		whitelist[0x33cB0C602d9D2965c5538731bAB28F122988f74E] = true;
1908 		whitelist[0xDc610C4766450E3184AfC312ef2224702299219b] = true;
1909 		whitelist[0xfD3414fd643023D73457a7BFD628959E0f55CC97] = true;
1910 		whitelist[0x0778e79130594FA32B0b3eC87E1d9f92AF43BcE7] = true;
1911 		whitelist[0x9D2daC55816Aa70cF0357492E5A111461F912B19] = true;
1912 		whitelist[0x284A9e0f4F7869b3294d1931B9845740A8607586] = true;
1913 		whitelist[0xA5471Bd195552d35f299AFb4196750005e7298F5] = true;
1914 		whitelist[0x04B9Cad474D427576344152FbEa36b996C586076] = true;
1915 		whitelist[0xD1370243a9e83b9641f90C1Afd012BDa729331c4] = true;
1916 		whitelist[0xBEEf32ccA6966bD3Bd0aA02659f829FcC8631a84] = true;
1917 		whitelist[0x6519E6117480D140CD7d33163aC30fD01812f34a] = true;
1918 		whitelist[0x18aEc641D8e2b1108FF5fE048539824b5B62c8E1] = true;
1919 		whitelist[0xd48D8cef2F1A7b29BAFb5E17e8B88bfEBaeC602a] = true;
1920 		whitelist[0x10665581d1ce1ef67593b7770F9fA555C9009C06] = true;
1921 		whitelist[0x7545E91679A6cc1d744690F136fF5c705c2dDB67] = true;
1922 		whitelist[0xF3D9281fa183B74F32B96E1c5244596045f4edE8] = true;
1923 		whitelist[0x9431D1615FA755Faa25A74da7f34C8Bd6963bd0A] = true;
1924 		whitelist[0x51050ec063d393217B436747617aD1C2285Aeeee] = true;
1925 		whitelist[0xf2D499fD020d1b711238461F96DA9A07A137660d] = true;
1926 		whitelist[0x186d562907bB057377d5c87e4f543C434fDB58F4] = true;
1927 		whitelist[0x91cE2EaAa0ae31B8b109E4a2038Fa7aC3e83034f] = true;
1928 		whitelist[0x5e40E0ad7b8b37C63aC1B9039b91E223DD27D688] = true;
1929 		whitelist[0x6A09156e3741955f5fA556f61F5c9546e52c45f7] = true;
1930 		whitelist[0x414be4F8572176Ac908926Cf2A9c328b873F75Bf] = true;
1931 		whitelist[0xBE994cF43F52Fd73FE45ceD29F06D1B08bd1709A] = true;
1932 		whitelist[0x2206e33975EF5CBf8d0DE16e4c6574a3a3aC65B6] = true;
1933 		whitelist[0xB618aaCb9DcDc21Ca69D310A6fC04674D293A193] = true;
1934 		whitelist[0xC77848cDD3D3C91A7c3b25d6443d2871bcbaFFc1] = true;
1935 		whitelist[0x270e3A305495e675d582847D8F3Ac4d10825A690] = true;
1936 		whitelist[0x7807829E002aD30F68c3072B3260bF912B3394Da] = true;
1937 		whitelist[0x4a60A51B200cfC0224645C515530dcB3efFCb370] = true;
1938 		whitelist[0x1f6D31774AD51A60C7b53EeC2C37052F6635235A] = true;
1939 		whitelist[0xaF7031b4f2a1A52338fE6Bd75409e38564838154] = true;
1940 		whitelist[0xb418Bd3d37e947C4B954C3750bF74C99804Fd776] = true;
1941 		whitelist[0x64ab118484c38baEb5B924143ca459706c03953F] = true;
1942 		whitelist[0xCf1DF6C3A26064A05b6437BBdF377fE46ac2d753] = true;
1943 		whitelist[0x822F86864da9fE5ca3cAb3B7438CF6227f459346] = true;
1944 		whitelist[0x8D19a5C86cf176d49419DD7E4EEC7b81B96431c4] = true;
1945 		whitelist[0x8683A90E9fe51AF9e452437f14Fed9241Be9413e] = true;
1946 		whitelist[0x0A4095a90bBe52625599EFd4B698d8d01B32676C] = true;
1947 		whitelist[0x1E6BB25d0068C11331c100e3c7eDb3bb8b98d042] = true;
1948 		whitelist[0x8B6D3eEe9048304aac53Ba571B1889A4f0609474] = true;
1949 		whitelist[0xba6332d3f01D220f1Cc2Fda423Ed89249D495C43] = true;
1950 		whitelist[0x9eaC7914e6dC6889E368dD48E3089706D7536a1b] = true;
1951 		whitelist[0xf6607ad5992f32448D307ddC20f71D88B4fe35A5] = true;
1952 		whitelist[0x93f0C941Da115cff5680F83172248e7644f5369e] = true;
1953 		whitelist[0x768058a4b0054dc1cb025889B2eFD9C2051d2Bf6] = true;
1954 		whitelist[0x2D8f11b3e4010C067Ad964D5d8558e2b61E21f07] = true;
1955 		whitelist[0x277d1523f3993bb40eC647a2236316eAf5A39cF9] = true;
1956 		whitelist[0x14B072f1954DD88131271D597A30e9899B57eb0F] = true;
1957 		whitelist[0x5d96D8F927a7bf5F342017CAF70039B9e9CFC216] = true;
1958 		whitelist[0x51Bd2CCceB74999380c26E401aC87D4afEf092Fe] = true;
1959 		whitelist[0xe31AAf1A3C67D6909Eb7D104A620d3CD85c8411A] = true;
1960 		whitelist[0x95B97AaA76fC57DCd65df419C6ccd73efaE611ad] = true;
1961 		whitelist[0x8C1D0aC50ad00C220936E2f1647405B12B0B91C2] = true;
1962 		whitelist[0x85CdF932E2cf53f8011D09A0088bF06D9dD96179] = true;
1963 		whitelist[0xA289b1a2594bEa59e34DF6A17544Cc308C8e18F8] = true;
1964 		whitelist[0xd23199F1222C418ffC74c385171330B21B16e452] = true;
1965 		whitelist[0x8d17Ff92B8C92Ed3C3f0A99e9A1aB817Fb895BF7] = true;
1966 		whitelist[0x6b7C318467F409A5Af2F0A9d0976Ef7b72d22a62] = true;
1967 		whitelist[0xEf6c1456A2467c9016a443812D0c182706FDF722] = true;
1968 		whitelist[0x265D5CEDbCecf2a70E78D31D0AcC7BE8617de7B9] = true;
1969 		whitelist[0xd0D004B4ce867785D9aB4C684f0497680AA7B6Ae] = true;
1970 		whitelist[0x325296d941a6e2d77f084488676704F8CFEc7b51] = true;
1971 		whitelist[0x55EEeE5F33036885C336a78564522e89B69c26dC] = true;
1972 		whitelist[0xc07A18c4ccE7F95A413515d3D137De47BcFfb495] = true;
1973 		whitelist[0xc3Ab4F4451d65299540242bb8Ab3C2c65154B3F6] = true;
1974 		whitelist[0x418A9a9f182B04EE9BDC5AE0dd0B4f0976dF5Eda] = true;
1975 		whitelist[0xDb2eDCC7880F0071959e2f6713CC335a6690FC84] = true;
1976 		whitelist[0xf19F3d5F1CB45a6953d6B8946917b06431314C00] = true;
1977 		whitelist[0x89831EF83444823b033CBfEbf877a197D39aA231] = true;
1978 		whitelist[0xB82eB1dA53C5e394f8525c7D627dd03640D6bc97] = true;
1979 		whitelist[0xB09D70324fb2c73bC8Ba5c7fc1270Ec0c0546407] = true;
1980 		whitelist[0xB15f55B848B56F80a08759C4064cb2e1957be6c0] = true;
1981 		whitelist[0x46EcB3F576c31290E1A4b359fd993e36E86Ef9e1] = true;
1982 		whitelist[0x3BA3D09f70CED571FE3F629Adc234e200ef5EA46] = true;
1983 		whitelist[0x812DbB12a51a5173cBAE829dD451CD4A79f6a756] = true;
1984 		whitelist[0x07819CD403605c35C94BcFdF386fdD5312D7D706] = true;
1985 		whitelist[0x657A38e6994CB578351376dCDb077330D00665d6] = true;
1986 		whitelist[0x120fb4D4b80DC98BF27341f0D98F0CCedFEeFDd4] = true;
1987 		whitelist[0x767CD29fA0BeFC46690F2547a826152d67dFB189] = true;
1988 		whitelist[0xcE64da4caf4c7D5A65c74Fbacb16E170d300285d] = true;
1989 		whitelist[0x4441fBd5E5E1A5AE0BAD986C015c0DE9a320cE2C] = true;
1990 		whitelist[0x329E630CA8507829B90660c26C555A906f6782e1] = true;
1991 		whitelist[0x008BA4907924f86C62fBb31Fe4A0dFE91c0e6acc] = true;
1992 		whitelist[0x21258055dfd7a287DCC224E3586210F1864c1996] = true;
1993 		whitelist[0xdAE4012B41657B7118324Fe13aF91eEc0EC95acD] = true;
1994 		whitelist[0x9294bb652f4B1392Ff8c266Cc75BA45ba312c124] = true;
1995 		whitelist[0xdcbe2EDb494a5816Fb234b2407877149291d8bA4] = true;
1996 		whitelist[0x10172b1A8fD270C2F4F45561617747ad2a35B31E] = true;
1997 		whitelist[0x25a61B9CB2D749b062fA87b792ca60faEdDdF851] = true;
1998 		whitelist[0xAf981AFA2f5fd50ffEDBB5728FA0fFd2a99b93CE] = true;
1999 		whitelist[0xE3f3EbacD9Af846fd2385F390E400fe520923173] = true;
2000 		whitelist[0xCAaD0665CD8007D692e57188A1C8e38Ea0A38F50] = true;
2001 		whitelist[0x0F4Dc70b4229e859fC25DC8cA4Ea58956359eD83] = true;
2002 		whitelist[0x3d7cdE7EA3da7fDd724482f11174CbC0b389BD8b] = true;
2003 		whitelist[0x97A554cb95EDEc7037292dEAa883864Cb35BC668] = true;
2004 		whitelist[0xD31D14f6B5AeFDaB5fE16DeA29fA46F6B8c15bF2] = true;
2005 		whitelist[0x419fD53f8c5c957Ae2c52A7df6904e986E59db62] = true;
2006 		whitelist[0x9402B3759C8f8f338639566826Fe7A684BA143B0] = true;
2007 		whitelist[0x23FA84013Ba906121D80d839321823F75cE018b6] = true;
2008 		whitelist[0x98011a7b0795F456FfcE7c988369f1149e8AEba2] = true;
2009 		whitelist[0xEa302cF778a1186843Ae10689695349f5388E0D9] = true;
2010 		whitelist[0xaECf6412Cf1A51986185F5718FadD640bae5C7cB] = true;
2011 		whitelist[0xb65aFAa2c59fd94f00D667F651B5D0c800ab99B6] = true;
2012 		whitelist[0x4d0bF3C6B181E719cdC50299303D65774dFB0aF7] = true;
2013 		whitelist[0x22C3378F9842792f9e240B11201E7C2F4901a408] = true;
2014 		whitelist[0xC208C84FC1B7A11ac3C798B396f9c0e5a23CFA38] = true;
2015 		whitelist[0x753e13f134810DFBE55296A910c7961Aa1B839C4] = true;
2016 		whitelist[0x34D7bCeaA2B3cfb1dE368BAA703683EDC666d3f1] = true;
2017 		whitelist[0x2D2c027E0d1A899a1965910Dd272bcaE1cD03c22] = true;
2018 		whitelist[0x6dE12C6478cba122eCec306e765385DF4C95E883] = true;
2019 		whitelist[0xdc52C2E7FC45B30bd5636f8D45BBEBAE4CE87f46] = true;
2020 		whitelist[0xfF5723A2967557D5a6E7277230B35b460f96E56c] = true;
2021 		whitelist[0x79CE43f7F12d7762c0350b28dcC0810695Fb24dD] = true;
2022 		whitelist[0x7E6FF370343468f5Bf8307D05427D1B02fE74E68] = true;
2023 		whitelist[0xB0623C91c65621df716aB8aFE5f66656B21A9108] = true;
2024 		whitelist[0x12F4b06a8cED0c0f35a5094c875a2b8a86562498] = true;
2025 		whitelist[0xe43A5Bda37e98A9fb6F40Bdee4147C7D0C5a7dDE] = true;
2026 		whitelist[0xab35EE8Df2f8dd950cc1cFd38fEf86857374e971] = true;
2027 		whitelist[0x128Db0689C294f934df3f52e73877a78f2d783B5] = true;
2028 		whitelist[0xc48d912C6596a0138e058323fD9929209A66Cfd8] = true;
2029 		whitelist[0x02e04F52Dc954F25831e4edFd1A1086B9feEf801] = true;
2030 		whitelist[0x75291cB8b75d6D0097a95F9F5B5389E20B1Fe40a] = true;
2031 		whitelist[0x7f92C0b4970b8459462DaC9e3256a016B45ee15E] = true;
2032 		whitelist[0xEA5338F40A649b58f15eBA78eF67262558343F03] = true;
2033 		whitelist[0x552922eEdfF18324098A18b7CC143E96855db7Cf] = true;
2034 		whitelist[0xfbA792D508d0f61e6BFD7c5A5bd00802a97AA0b2] = true;
2035 		whitelist[0xb9dBf2caE6Fd864B1F7C2fb3dF5c0ce68D0E6B59] = true;
2036 		whitelist[0x853D18353Ac666E87dB98c59550F2C7068f55cD7] = true;
2037 		whitelist[0xAef9a463CB85e771bD8F3536e04956d30ee31ce2] = true;
2038 		whitelist[0xc0b75b61c6ECFfd77743a8b77BD8a3E7fCbc5a93] = true;
2039 		whitelist[0xa837b0f94974f37e17347A0BB8C448d8F25D0B0B] = true;
2040 		whitelist[0xA95F4f51cc7FfB04e97eF0dDC9B6060c9200eE80] = true;
2041 		whitelist[0x5e58538cc693b1099C68d7fEF963C1f148DaE8CB] = true;
2042 		whitelist[0x4771B65e9A825d2917378F43810F6bAF4ce3F732] = true;
2043 		whitelist[0x35bD3902A2Ed264f1803f78423e71Ee0BD7b189B] = true;
2044 		whitelist[0x068baEE003C32D507a64eD7AF700a0aC7074Fa58] = true;
2045 		whitelist[0xBd87C000fd1222d5dE79D91ef9ff23Aa6d1b0F52] = true;
2046 		whitelist[0x8eBc92675F0182182994B44B204be932565E736D] = true;
2047 		whitelist[0x6Ac40b84f5732cCc2d21ebe71f2ACC4140314843] = true;
2048 		whitelist[0x6963D1743A452FE1A082B76b1432037a12c2C742] = true;
2049 		whitelist[0x41BF39033C732F884A52ddf38F647aD63457CEEC] = true;
2050 		whitelist[0xa5cc3c03994DB5b0d9A5eEdD10CabaB0813678AC] = true;
2051 		whitelist[0xd3A1ab87C8aB81CB093Ef5430A387D127ac523a0] = true;
2052 		whitelist[0x39B557A249706CAC1DFfe157cE5D25fF1791b56F] = true;
2053 		whitelist[0xE0Dd8C40ACC74005C71CE5d02Cd5116A2eEDB1b0] = true;
2054 		whitelist[0xF6f4B3d80884DCf2E602820622cafC1Bcc1F9AFE] = true;
2055 		whitelist[0x95eE9e136f0d5EB6fb5b7b83Bd09b35e21ba55F0] = true;
2056 		whitelist[0x127fa43E17eA1a819cD07692Ee17D4F65E927564] = true;
2057 		whitelist[0x328Ca06CA310EFd4cbf9Cc2DD4B62C7dbC1BB791] = true;
2058 		whitelist[0xC9b5db189631ED9bB35eb795826d90717b43B56A] = true;
2059 		whitelist[0x13FD513c2104941Bc399589b5391957B27392E8b] = true;
2060 		whitelist[0x7F7d6649af37189C3C1CBA4407265218086D5716] = true;
2061 		whitelist[0xA1c256282e215e3040F3Fe5f17bb105C72Ec4E25] = true;
2062 		whitelist[0xCeba00f5c2e0cA4E8dAE4D88EF79190a648B9966] = true;
2063 		whitelist[0x2A3Ce3854762e057BA8296f4Ec18697D69140e1E] = true;
2064 		whitelist[0x6DC16Cb8532967534Ef2BFE8C4eDEE9fD552603e] = true;
2065 		whitelist[0xC2488CcF46573821a02E0dE829f1970dbC14A3E9] = true;
2066 		whitelist[0x6564f96bE476A430Dede03EcD7352Be33B12FC0F] = true;
2067 		whitelist[0x6457A438e924EEeb2aA14C254db044bf774b62Eb] = true;
2068 		whitelist[0xeD66cE7eEe03790056cA5Ba5ee61Bc4F77bA2DED] = true;
2069 		whitelist[0x4c3A392af5FC22253743b0600a4365DF3A7F9893] = true;
2070 		whitelist[0xbA993c1FeE51a4A937bB6a8b7b74cD8DfFDCA1A4] = true;
2071 		whitelist[0xDf9c5Cf591e1338bBA20A26D4177B733713108FD] = true;
2072 		whitelist[0x4Fc83f87639C917A9703F135f4C48a50e54eF8c3] = true;
2073 		whitelist[0x5Ed9e63Ea642DB16B3B6A58E3F867668178ac222] = true;
2074 		whitelist[0x42FB05E09f8A477620dEFe49AF76e577Cbd791D8] = true;
2075 		whitelist[0x775C4B0f9f13fc32548B060ab4bf5eff44B08348] = true;
2076 		whitelist[0x7b5296dB485B599DD8604346163c0DFaC096D553] = true;
2077 		whitelist[0xD6Fd8413B1FaCafcB46b3F7C08d07DaA0fe5E770] = true;
2078 		whitelist[0x01be72263B12fE4D51919786f65bF13FF3E58ebE] = true;
2079 		whitelist[0xa47Fd53CcEc8fe0ec67794AeA9e3Cd392A49b88E] = true;
2080 		whitelist[0x013bbCfF38F4E875B0218E4eB460e0E7c8FFaFc2] = true;
2081 		whitelist[0x8DD6629B2272b4fb384c13E982f8e08Bc8EE001E] = true;
2082 		whitelist[0x1AfC8C45493DFb8176D12a5C5A0469dC4c14f02a] = true;
2083 		whitelist[0xBb179f078BAC0FF4f181F6e01606cCAe883Ef74D] = true;
2084 		whitelist[0x9Be8cbE548110b4F09D932cdfbaC082c9dD98899] = true;
2085 		whitelist[0x41a195cD1b26cA3774f761c5652c9E0841932126] = true;
2086 		whitelist[0x6885863E1aAa726346e9Ea88b7273fe779075E8a] = true;
2087 		whitelist[0x97bac212815DfF849820e34b6F9a58e4C40909De] = true;
2088 		whitelist[0x8Dc9c53B85FC13779C5874be6fD7A20Ce3Cf7e20] = true;
2089 		whitelist[0x83E84CC194E595B43dCEDfBFfC3e0358366307f1] = true;
2090 		whitelist[0x107Fb8867608508eb4B9F69333603fCD632BF330] = true;
2091 		whitelist[0x26983a34F4E6cA1695C7b897904AD9212d042d27] = true;
2092 		whitelist[0xf6FF6beCFe9D0b78424C598352cC8f64D0d1d675] = true;
2093 		whitelist[0x553ea73C8d7932c94830Bfe16d91Dd3931d87305] = true;
2094 		whitelist[0x7fC9435A996E6F07e75c244bd9F345FAAF81AF8C] = true;
2095 		whitelist[0x3D5c457920Ff88a7a42D2aF63d450E5F2da61d14] = true;
2096 		whitelist[0x99F0764BECCAEF7959795c16277a10CA7a80369C] = true;
2097 		whitelist[0x2378598aEf5768d12df9ab72dee9AF37a2741F5A] = true;
2098 		whitelist[0xA58715f1069d82233ba2bFa88058774678b33F05] = true;
2099 		whitelist[0x660157aeDBF8f046b50D6EBd3a4502007aB6cBE7] = true;
2100 		whitelist[0xb0cFeA22b93a4C85C46c55f6e665a77fefC5D197] = true;
2101 		whitelist[0x55e2880c6984f671A78044B4027C899b12d7BA86] = true;
2102 		whitelist[0x64Ad18fd2cdE41578d231955C98A714f8CBaC239] = true;
2103 		whitelist[0x1C12c3FB74aA4658B13bDB744Fc314648311A082] = true;
2104 		whitelist[0x993f5b993e733d7840F25981138DA602430e13Dc] = true;
2105 		whitelist[0x977D3dbf93174f517a52736E1e556B79300CE3cC] = true;
2106 		whitelist[0x22a001Eb8434Dfe92C22Af924A9A0a6ddA82B5e8] = true;
2107 		whitelist[0xAdC3BD4529cbE18291E3f2dB73Cb7630Aba73Cb7] = true;
2108 		whitelist[0xeCC1C3d38460FFc4fd58BECAEF72A90EdF0613a4] = true;
2109 		whitelist[0xb6D089F0b4865F922FE92815A1c90b53598e5AAe] = true;
2110 		whitelist[0x91aD771F1e4978479f7451F76d423093D26ba616] = true;
2111 		whitelist[0xbFd3F0350120Ed7e7c45b722E69D6f5e1a063c6C] = true;
2112 		whitelist[0x2E601885896103318269CA45431B943a6C8Ae39a] = true;
2113 		whitelist[0xE4E565C4a2A5050BA1020314c76420dd52D88Cd6] = true;
2114 		whitelist[0x6375594B4175100055813039CA22476CDDE06328] = true;
2115 		whitelist[0x8C8024bf5f90a06CCeD7D32BAbcCB934942c82f6] = true;
2116 		whitelist[0x0Db99Bf3b52EDa95FD6647C16442EF55815a40A9] = true;
2117 		whitelist[0x9b973568b0664BFcA35e8F0Aa39daEEA737b3fcC] = true;
2118 		whitelist[0x3822881D61803AF91a95847ad20B1bF20A5671B2] = true;
2119 		whitelist[0x02a5c980029cB470Ac89Df2E2de1CF453aEE6558] = true;
2120 		whitelist[0x7b923AaB6126b5F09b141e9cB4fd41bFaA6A4bB2] = true;
2121 		whitelist[0x89032c0cFF4abb9bc490dF104Ec89eff27314909] = true;
2122 		whitelist[0xF848E384e41d09DCe3DcAeD37e1714418e68ea7F] = true;
2123 		whitelist[0x4FFe858b37c9398237246A81885c5d4dCB38245e] = true;
2124 		whitelist[0x7373087E3901DA42A29AA5d585F9343385Fc2908] = true;
2125 		whitelist[0x9f477D97a21389542e0a20879a3899730843dcCD] = true;
2126 		whitelist[0x823dC685e777a7523954388FA7933DA770f49d42] = true;
2127 		whitelist[0xDA86955802A0e8f69F1C8e04090E4dC109fd9653] = true;
2128 		whitelist[0x8683BbBe511B269F1b9dC0108fb6B267Ea764F8e] = true;
2129 		whitelist[0x1AC08405E96E3561893eef86F194acDB9A24D38D] = true;
2130 		whitelist[0xe7779a8C5005098328A1ece6185B82c6A9DBE56D] = true;
2131 		whitelist[0xd8758354945360a603BCbe1bb31C56383f6FefF3] = true;
2132 		whitelist[0x7a2269e15d34FC2a69e4C598A7DC51733ae93638] = true;
2133 		whitelist[0x9643805d1756d8990B5C492a2c3374a4dd29FA80] = true;
2134 		whitelist[0x473888e67636661062daD4CFfC92a39437810313] = true;
2135 		whitelist[0x22720cCDe7Db8141576f844beAfCC9c7B7D602aA] = true;
2136 		whitelist[0x68c3494bAd6011033d10745144B51890861422E9] = true;
2137 		whitelist[0x2eFf70000afa05066aF0134A1dF455bd2Cb41763] = true;
2138 		whitelist[0x0D0b3B531cDBB38F854613969d83334cD73dC7CB] = true;
2139 		whitelist[0x44ddBB35CfeBbafE98e402970517b33d8e925eB3] = true;
2140 		whitelist[0xE076f2722c830d4441ec0BCe158fA1956e8B162E] = true;
2141 		whitelist[0x2D0d77065aB397CcC8D7cCFD847eF46074a93c38] = true;
2142 		whitelist[0x829004098cFd973A574a7c18dce5CD10EAa96Cb0] = true;
2143 		whitelist[0xd7d35C3FbfeAaAA6ad1C9C020ED39764E0A604bb] = true;
2144 		whitelist[0xF6746F1472EA920eee7b793a4d48BE0fEA647Bfe] = true;
2145 		whitelist[0x03eE1E0e4eaa0eF034aC81831FAe674135a4995a] = true;
2146 		whitelist[0xaF2E6340bcF42C39467dD6D86632a2db42C11dc5] = true;
2147 		whitelist[0xBA12D8B01A6Bfe6FFf2250912caB159455Ee87ad] = true;
2148 		whitelist[0x51e13ff041D86dcc4B8126eD58050b7C2BA2c5B0] = true;
2149 		whitelist[0x78c4B4A8BB8C7366b80F470D7dBeb3932e5261aF] = true;
2150 		whitelist[0xBd8e9e39ad49D2607805b77951C9b284E4E8CF31] = true;
2151 		whitelist[0x71211a75C7995aA0a3f3FbF666ccb9446cE051B3] = true;
2152 		whitelist[0x254B8073B057942235756B7E7249fB5Ca60753Ef] = true;
2153 		whitelist[0x86Fd708A7762B5cb8625f794263516b95B22e129] = true;
2154 		whitelist[0xEaf7D511a1956c9D297EFBB2D81b528B37D1d8D7] = true;
2155 		whitelist[0x2a7B50f2FbdEfd9CAFF33cb386d87269EF5aBfCd] = true;
2156 		whitelist[0xBa1fA72bE53A1693dE4867DeA60fA9f041073BEF] = true;
2157 		whitelist[0x7FF50D24C87F3A4E0c3C527bBB563715cE6E71c5] = true;
2158 		whitelist[0xF43479102a0d24d068a7912B092689000d9Cc5F0] = true;
2159 		whitelist[0x7a18960043093E89d804A30D5664Ce769cd153A1] = true;
2160 		whitelist[0x989057259D3a0D75c4C0E21584E296bBF044E722] = true;
2161 		whitelist[0x50491bf5d8EA8d23AADeB482be496590DAb34fb7] = true;
2162 		whitelist[0x915782DB070B286375C4B757f63fC9a81c3E93F7] = true;
2163 		whitelist[0x4dd5D12a6b16224b4d234F0A06De1587db190679] = true;
2164 		whitelist[0xc3B39978C872B3DD3A52Ebe34A6A3B08De7762E8] = true;
2165 		whitelist[0x7a9DC8eEaf5022cECd60C54A042343484ce6C065] = true;
2166 		whitelist[0x469B786bd2416eb6EB832741f2FD536F60a355D3] = true;
2167 		whitelist[0x523A16DCF25698a9992327BD0c1d9832c82b8A4D] = true;
2168 		whitelist[0x559d92d2bF798c4310e5b71001B6351c3c96005C] = true;
2169 		whitelist[0xcfadBa5101911D04189331ff9F6e42fE44567439] = true;
2170 		whitelist[0xD5D4aAFb3B2217607e5B5B5526Eb6932f8DF130F] = true;
2171 		whitelist[0x6e3f8E093Fe749398aac60515686fC4FC4baC514] = true;
2172 		whitelist[0xfD2307923C117e384b3aa9E34Bfec419Cb66a14d] = true;
2173 		whitelist[0x2847E472A7F56c1693A815F2CA50F30d3d263F4E] = true;
2174 		whitelist[0xaB4bE3171994fEa9F6717DbE1D2f7839295e7688] = true;
2175 		whitelist[0xF6b11609c3A5bCDEbA0EAB46799A3ed7C1323db8] = true;
2176 		whitelist[0xcC4f052FCDf3C94cc5acDec24E415248dAC9eEc2] = true;
2177 		whitelist[0x094F8EECDf916aA47E5382c1c1E83888bCC03dfF] = true;
2178 		whitelist[0x7E9631b460DE70F5b089594C4aC83Ce7026cd0B2] = true;
2179 		whitelist[0x00C994c17976B06b6A7b22460E9001ECdb25c511] = true;
2180 		whitelist[0xf2439241881964006369c0e2377D45F3740f48a0] = true;
2181 		whitelist[0x4EfeceA2A42E1E73737e4dda7234e999A84Ca60B] = true;
2182 		whitelist[0x179891636BAeAf21c5DEA72Ff9144fc4e4f48680] = true;
2183 		whitelist[0x87Aa1150cAF247a35f303AA051568a81FeCa11a2] = true;
2184 		whitelist[0xaDba5Ea1525C5aE27A0f98408C8E5D67e28c754c] = true;
2185 		whitelist[0x1E94b256C7B0B07c7c0AEd932d12F03034c601Ab] = true;
2186 		whitelist[0x1aD42FB475192C8C0a2Fc7D0DF6faC4F71142c58] = true;
2187 		whitelist[0xAb30f11201d6D53215729D45DC05a0966C237922] = true;
2188 		whitelist[0xf4f5AC536B4E39dAe47855744C311A87361337d8] = true;
2189 		whitelist[0x4065a1D266B93001E7DF796735C68070E2154fa4] = true;
2190 		whitelist[0x612aFa0059F72905f78f45fD147Cda08311b24eB] = true;
2191 		whitelist[0xb48d6C33A96F5519C82569b478fcD723b3A94a2A] = true;
2192 		whitelist[0x501D63B672E92274Ec7dCd4474751D8F62933386] = true;
2193 		whitelist[0x370F75f54907AA06584892A86F891536DB5C4F49] = true;
2194 		whitelist[0xf21E7aF6777b9a8F1eB57A94B5F1501e68eBFb91] = true;
2195 	}
2196 }