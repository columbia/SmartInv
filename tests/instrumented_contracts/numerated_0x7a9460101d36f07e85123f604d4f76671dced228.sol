1 /** 
2  *  
3 */
4             
5 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC165 standard, as defined in the
12  * https://eips.ethereum.org/EIPS/eip-165[EIP].
13  *
14  * Implementers can declare support of contract interfaces, which can then be
15  * queried by others ({ERC165Checker}).
16  *
17  * For an implementation, see {ERC165}.
18  */
19 interface IERC165 {
20     /**
21      * @dev Returns true if this contract implements the interface defined by
22      * `interfaceId`. See the corresponding
23      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
24      * to learn more about how these ids are created.
25      *
26      * This function call must use less than 30 000 gas.
27      */
28     function supportsInterface(bytes4 interfaceId) external view returns (bool);
29 }
30 
31 
32 
33 
34 /** 
35  *  
36 */
37             
38 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
39 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 ////import "../../utils/introspection/IERC165.sol";
44 
45 /**
46  * @dev Required interface of an ERC721 compliant contract.
47  */
48 interface IERC721 is IERC165 {
49     /**
50      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
51      */
52     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
53 
54     /**
55      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
56      */
57     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
58 
59     /**
60      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
61      */
62     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
63 
64     /**
65      * @dev Returns the number of tokens in ``owner``'s account.
66      */
67     function balanceOf(address owner) external view returns (uint256 balance);
68 
69     /**
70      * @dev Returns the owner of the `tokenId` token.
71      *
72      * Requirements:
73      *
74      * - `tokenId` must exist.
75      */
76     function ownerOf(uint256 tokenId) external view returns (address owner);
77 
78     /**
79      * @dev Safely transfers `tokenId` token from `from` to `to`.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must exist and be owned by `from`.
86      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
87      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
88      *
89      * Emits a {Transfer} event.
90      */
91     function safeTransferFrom(
92         address from,
93         address to,
94         uint256 tokenId,
95         bytes calldata data
96     ) external;
97 
98     /**
99      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
100      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must exist and be owned by `from`.
107      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
108      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
109      *
110      * Emits a {Transfer} event.
111      */
112     function safeTransferFrom(
113         address from,
114         address to,
115         uint256 tokenId
116     ) external;
117 
118     /**
119      * @dev Transfers `tokenId` token from `from` to `to`.
120      *
121      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
122      *
123      * Requirements:
124      *
125      * - `from` cannot be the zero address.
126      * - `to` cannot be the zero address.
127      * - `tokenId` token must be owned by `from`.
128      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transferFrom(
133         address from,
134         address to,
135         uint256 tokenId
136     ) external;
137 
138     /**
139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
140      * The approval is cleared when the token is transferred.
141      *
142      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
143      *
144      * Requirements:
145      *
146      * - The caller must own the token or be an approved operator.
147      * - `tokenId` must exist.
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Approve or remove `operator` as an operator for the caller.
155      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
156      *
157      * Requirements:
158      *
159      * - The `operator` cannot be the caller.
160      *
161      * Emits an {ApprovalForAll} event.
162      */
163     function setApprovalForAll(address operator, bool _approved) external;
164 
165     /**
166      * @dev Returns the account approved for `tokenId` token.
167      *
168      * Requirements:
169      *
170      * - `tokenId` must exist.
171      */
172     function getApproved(uint256 tokenId) external view returns (address operator);
173 
174     /**
175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
176      *
177      * See {setApprovalForAll}
178      */
179     function isApprovedForAll(address owner, address operator) external view returns (bool);
180 }
181 
182 
183 
184 
185 /** 
186  *  
187 */
188             
189 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
190 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 ////import "../IERC721.sol";
195 
196 /**
197  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
198  * @dev See https://eips.ethereum.org/EIPS/eip-721
199  */
200 interface IERC721Enumerable is IERC721 {
201     /**
202      * @dev Returns the total amount of tokens stored by the contract.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     /**
207      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
208      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
209      */
210     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
211 
212     /**
213      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
214      * Use along with {totalSupply} to enumerate all tokens.
215      */
216     function tokenByIndex(uint256 index) external view returns (uint256);
217 }
218 
219 
220 
221 
222 /** 
223  *  
224 */
225             
226 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
227 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @title ERC721 token receiver interface
233  * @dev Interface for any contract that wants to support safeTransfers
234  * from ERC721 asset contracts.
235  */
236 interface IERC721Receiver {
237     /**
238      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
239      * by `operator` from `from`, this function is called.
240      *
241      * It must return its Solidity selector to confirm the token transfer.
242      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
243      *
244      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
245      */
246     function onERC721Received(
247         address operator,
248         address from,
249         uint256 tokenId,
250         bytes calldata data
251     ) external returns (bytes4);
252 }
253 
254 
255 
256 
257 /** 
258  *  
259 */
260             
261 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
262 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 ////import "../IERC721.sol";
267 
268 /**
269  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
270  * @dev See https://eips.ethereum.org/EIPS/eip-721
271  */
272 interface IERC721Metadata is IERC721 {
273     /**
274      * @dev Returns the token collection name.
275      */
276     function name() external view returns (string memory);
277 
278     /**
279      * @dev Returns the token collection symbol.
280      */
281     function symbol() external view returns (string memory);
282 
283     /**
284      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
285      */
286     function tokenURI(uint256 tokenId) external view returns (string memory);
287 }
288 
289 
290 
291 
292 /** 
293  *  
294 */
295             
296 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
297 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721Receiver.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 ////import "../token/ERC721/IERC721Receiver.sol";
302 
303 
304 
305 
306 /** 
307  *  
308 */
309             
310 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
311 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
312 
313 pragma solidity ^0.8.1;
314 
315 /**
316  * @dev Collection of functions related to the address type
317  */
318 library Address {
319     /**
320      * @dev Returns true if `account` is a contract.
321      *
322      * [////IMPORTANT]
323      * ====
324      * It is unsafe to assume that an address for which this function returns
325      * false is an externally-owned account (EOA) and not a contract.
326      *
327      * Among others, `isContract` will return false for the following
328      * types of addresses:
329      *
330      *  - an externally-owned account
331      *  - a contract in construction
332      *  - an address where a contract will be created
333      *  - an address where a contract lived, but was destroyed
334      * ====
335      *
336      * [IMPORTANT]
337      * ====
338      * You shouldn't rely on `isContract` to protect against flash loan attacks!
339      *
340      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
341      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
342      * constructor.
343      * ====
344      */
345     function isContract(address account) internal view returns (bool) {
346         // This method relies on extcodesize/address.code.length, which returns 0
347         // for contracts in construction, since the code is only stored at the end
348         // of the constructor execution.
349 
350         return account.code.length > 0;
351     }
352 
353     /**
354      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
355      * `recipient`, forwarding all available gas and reverting on errors.
356      *
357      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
358      * of certain opcodes, possibly making contracts go over the 2300 gas limit
359      * imposed by `transfer`, making them unable to receive funds via
360      * `transfer`. {sendValue} removes this limitation.
361      *
362      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
363      *
364      * ////IMPORTANT: because control is transferred to `recipient`, care must be
365      * taken to not create reentrancy vulnerabilities. Consider using
366      * {ReentrancyGuard} or the
367      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
368      */
369     function sendValue(address payable recipient, uint256 amount) internal {
370         require(address(this).balance >= amount, "Address: insufficient balance");
371 
372         (bool success, ) = recipient.call{value: amount}("");
373         require(success, "Address: unable to send value, recipient may have reverted");
374     }
375 
376     /**
377      * @dev Performs a Solidity function call using a low level `call`. A
378      * plain `call` is an unsafe replacement for a function call: use this
379      * function instead.
380      *
381      * If `target` reverts with a revert reason, it is bubbled up by this
382      * function (like regular Solidity function calls).
383      *
384      * Returns the raw returned data. To convert to the expected return value,
385      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
386      *
387      * Requirements:
388      *
389      * - `target` must be a contract.
390      * - calling `target` with `data` must not revert.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
395         return functionCall(target, data, "Address: low-level call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
400      * `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, 0, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but also transferring `value` wei to `target`.
415      *
416      * Requirements:
417      *
418      * - the calling contract must have an ETH balance of at least `value`.
419      * - the called Solidity function must be `payable`.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(
424         address target,
425         bytes memory data,
426         uint256 value
427     ) internal returns (bytes memory) {
428         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
433      * with `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(
438         address target,
439         bytes memory data,
440         uint256 value,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         require(address(this).balance >= value, "Address: insufficient balance for call");
444         require(isContract(target), "Address: call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.call{value: value}(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a static call.
453      *
454      * _Available since v3.3._
455      */
456     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
457         return functionStaticCall(target, data, "Address: low-level static call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a static call.
463      *
464      * _Available since v3.3._
465      */
466     function functionStaticCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal view returns (bytes memory) {
471         require(isContract(target), "Address: static call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.staticcall(data);
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
484         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
489      * but performing a delegate call.
490      *
491      * _Available since v3.4._
492      */
493     function functionDelegateCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         require(isContract(target), "Address: delegate call to non-contract");
499 
500         (bool success, bytes memory returndata) = target.delegatecall(data);
501         return verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     /**
505      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
506      * revert reason using the provided one.
507      *
508      * _Available since v4.3._
509      */
510     function verifyCallResult(
511         bool success,
512         bytes memory returndata,
513         string memory errorMessage
514     ) internal pure returns (bytes memory) {
515         if (success) {
516             return returndata;
517         } else {
518             // Look for revert reason and bubble it up if present
519             if (returndata.length > 0) {
520                 // The easiest way to bubble the revert reason is using memory via assembly
521 
522                 assembly {
523                     let returndata_size := mload(returndata)
524                     revert(add(32, returndata), returndata_size)
525                 }
526             } else {
527                 revert(errorMessage);
528             }
529         }
530     }
531 }
532 
533 
534 
535 
536 /** 
537  *  
538 */
539             
540 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
541 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721Metadata.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 ////import "../token/ERC721/extensions/IERC721Metadata.sol";
546 
547 
548 
549 
550 /** 
551  *  
552 */
553             
554 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
555 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 ////import "../token/ERC721/IERC721.sol";
560 
561 
562 
563 
564 /** 
565  *  
566 */
567             
568 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
569 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 ////import "./IERC165.sol";
574 
575 /**
576  * @dev Implementation of the {IERC165} interface.
577  *
578  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
579  * for the additional interface id that will be supported. For example:
580  *
581  * ```solidity
582  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
583  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
584  * }
585  * ```
586  *
587  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
588  */
589 abstract contract ERC165 is IERC165 {
590     /**
591      * @dev See {IERC165-supportsInterface}.
592      */
593     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
594         return interfaceId == type(IERC165).interfaceId;
595     }
596 }
597 
598 
599 
600 
601 /** 
602  *  
603 */
604             
605 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
606 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev Provides information about the current execution context, including the
612  * sender of the transaction and its data. While these are generally available
613  * via msg.sender and msg.data, they should not be accessed in such a direct
614  * manner, since when dealing with meta-transactions the account sending and
615  * paying for execution may not be the actual sender (as far as an application
616  * is concerned).
617  *
618  * This contract is only required for intermediate, library-like contracts.
619  */
620 abstract contract Context {
621     function _msgSender() internal view virtual returns (address) {
622         return msg.sender;
623     }
624 
625     function _msgData() internal view virtual returns (bytes calldata) {
626         return msg.data;
627     }
628 }
629 
630 
631 
632 
633 /** 
634  *  
635 */
636             
637 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
638 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721Enumerable.sol)
639 
640 pragma solidity ^0.8.0;
641 
642 ////import "../token/ERC721/extensions/IERC721Enumerable.sol";
643 
644 
645 
646 
647 /** 
648  *  
649 */
650             
651 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
652 
653 pragma solidity ^0.8.0;
654 
655 ////import "@openzeppelin/contracts/utils/Context.sol";
656 ////import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
657 ////import "@openzeppelin/contracts/interfaces/IERC721.sol";
658 ////import "@openzeppelin/contracts/interfaces/IERC721Metadata.sol";
659 ////import "@openzeppelin/contracts/utils/Address.sol";
660 ////import "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
661 
662 /*************************
663 * @author: Squeebo       *
664 * @license: BSD-3-Clause *
665 **************************/
666 
667 abstract contract ERC721B is Context, ERC165, IERC721, IERC721Metadata {
668 	using Address for address;
669 
670 	// Token name
671 	string private _name;
672 
673 	// Token symbol
674 	string private _symbol;
675 
676 	// Mapping from token ID to owner address
677 	address[] internal _owners;
678 
679 	// Mapping from token ID to approved address
680 	mapping(uint256 => address) private _tokenApprovals;
681 
682 	// Mapping from owner to operator approvals
683 	mapping(address => mapping(address => bool)) private _operatorApprovals;
684 
685 	/**
686 	 * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
687 	 */
688 	constructor(string memory name_, string memory symbol_) {
689 		_name = name_;
690 		_symbol = symbol_;
691 	}
692 
693 	/**
694 	 * @dev See {IERC165-supportsInterface}.
695 	 */
696 	function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
697 		return
698 			interfaceId == type(IERC721).interfaceId ||
699 			interfaceId == type(IERC721Metadata).interfaceId ||
700 			super.supportsInterface(interfaceId);
701 	}
702 
703 	/**
704 	 * @dev See {IERC721-balanceOf}.
705 	 */
706 	function balanceOf(address owner) public view virtual override returns (uint256) {
707 		require(owner != address(0), "ERC721: balance query for the zero address");
708 
709 		uint count = 0;
710 		uint length = _owners.length;
711 		for( uint i = 0; i < length; ++i ){
712 		  if( owner == _owners[i] ){
713 			++count;
714 		  }
715 		}
716 
717 		delete length;
718 		return count;
719 	}
720 
721 	/**
722 	 * @dev See {IERC721-ownerOf}.
723 	 */
724 	function ownerOf(uint256 tokenId) public view virtual override returns (address) {
725 		address owner = _owners[tokenId];
726 		require(owner != address(0), "ERC721: owner query for nonexistent token");
727 		return owner;
728 	}
729 
730 	/**
731 	 * @dev See {IERC721Metadata-name}.
732 	 */
733 	function name() public view virtual override returns (string memory) {
734 		return _name;
735 	}
736 
737 	/**
738 	 * @dev See {IERC721Metadata-symbol}.
739 	 */
740 	function symbol() public view virtual override returns (string memory) {
741 		return _symbol;
742 	}
743 
744 	/**
745 	 * @dev See {IERC721-approve}.
746 	 */
747 	function approve(address to, uint256 tokenId) public virtual override {
748 		address owner = ERC721B.ownerOf(tokenId);
749 		require(to != owner, "ERC721: approval to current owner");
750 
751 		require(
752 			_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
753 			"ERC721: approve caller is not owner nor approved for all"
754 		);
755 
756 		_approve(to, tokenId);
757 	}
758 
759 	/**
760 	 * @dev See {IERC721-getApproved}.
761 	 */
762 	function getApproved(uint256 tokenId) public view virtual override returns (address) {
763 		require(_exists(tokenId), "ERC721: approved query for nonexistent token");
764 
765 		return _tokenApprovals[tokenId];
766 	}
767 
768 	/**
769 	 * @dev See {IERC721-setApprovalForAll}.
770 	 */
771 	function setApprovalForAll(address operator, bool approved) public virtual override {
772 		require(operator != _msgSender(), "ERC721: approve to caller");
773 
774 		_operatorApprovals[_msgSender()][operator] = approved;
775 		emit ApprovalForAll(_msgSender(), operator, approved);
776 	}
777 
778 	/**
779 	 * @dev See {IERC721-isApprovedForAll}.
780 	 */
781 	function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
782 		return _operatorApprovals[owner][operator];
783 	}
784 
785 
786 	/**
787 	 * @dev See {IERC721-transferFrom}.
788 	 */
789 	function transferFrom(
790 		address from,
791 		address to,
792 		uint256 tokenId
793 	) public virtual override {
794 		//solhint-disable-next-line max-line-length
795 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
796 
797 		_transfer(from, to, tokenId);
798 	}
799 
800 	/**
801 	 * @dev See {IERC721-safeTransferFrom}.
802 	 */
803 	function safeTransferFrom(
804 		address from,
805 		address to,
806 		uint256 tokenId
807 	) public virtual override {
808 		safeTransferFrom(from, to, tokenId, "");
809 	}
810 
811 	/**
812 	 * @dev See {IERC721-safeTransferFrom}.
813 	 */
814 	function safeTransferFrom(
815 		address from,
816 		address to,
817 		uint256 tokenId,
818 		bytes memory _data
819 	) public virtual override {
820 		require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
821 		_safeTransfer(from, to, tokenId, _data);
822 	}
823 
824 	/**
825 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
826 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
827 	 *
828 	 * `_data` is additional data, it has no specified format and it is sent in call to `to`.
829 	 *
830 	 * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
831 	 * implement alternative mechanisms to perform token transfer, such as signature-based.
832 	 *
833 	 * Requirements:
834 	 *
835 	 * - `from` cannot be the zero address.
836 	 * - `to` cannot be the zero address.
837 	 * - `tokenId` token must exist and be owned by `from`.
838 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
839 	 *
840 	 * Emits a {Transfer} event.
841 	 */
842 	function _safeTransfer(
843 		address from,
844 		address to,
845 		uint256 tokenId,
846 		bytes memory _data
847 	) internal virtual {
848 		_transfer(from, to, tokenId);
849 		require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
850 	}
851 
852 	/**
853 	 * @dev Returns whether `tokenId` exists.
854 	 *
855 	 * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
856 	 *
857 	 * Tokens start existing when they are minted (`_mint`),
858 	 * and stop existing when they are burned (`_burn`).
859 	 */
860 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
861 		return tokenId < _owners.length && _owners[tokenId] != address(0);
862 	}
863 
864 	/**
865 	 * @dev Returns whether `spender` is allowed to manage `tokenId`.
866 	 *
867 	 * Requirements:
868 	 *
869 	 * - `tokenId` must exist.
870 	 */
871 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
872 		require(_exists(tokenId), "ERC721: operator query for nonexistent token");
873 		address owner = ERC721B.ownerOf(tokenId);
874 		return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
875 	}
876 
877 	/**
878 	 * @dev Safely mints `tokenId` and transfers it to `to`.
879 	 *
880 	 * Requirements:
881 	 *
882 	 * - `tokenId` must not exist.
883 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
884 	 *
885 	 * Emits a {Transfer} event.
886 	 */
887 	function _safeMint(address to, uint256 tokenId) internal virtual {
888 		_safeMint(to, tokenId, "");
889 	}
890 
891 
892 	/**
893 	 * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
894 	 * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
895 	 */
896 	function _safeMint(
897 		address to,
898 		uint256 tokenId,
899 		bytes memory _data
900 	) internal virtual {
901 		_mint(to, tokenId);
902 		require(
903 			_checkOnERC721Received(address(0), to, tokenId, _data),
904 			"ERC721: transfer to non ERC721Receiver implementer"
905 		);
906 	}
907 
908 	/**
909 	 * @dev Mints `tokenId` and transfers it to `to`.
910 	 *
911 	 * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
912 	 *
913 	 * Requirements:
914 	 *
915 	 * - `tokenId` must not exist.
916 	 * - `to` cannot be the zero address.
917 	 *
918 	 * Emits a {Transfer} event.
919 	 */
920 	function _mint(address to, uint256 tokenId) internal virtual {
921 		require(to != address(0), "ERC721: mint to the zero address");
922 		require(!_exists(tokenId), "ERC721: token already minted");
923 
924 		_beforeTokenTransfer(address(0), to, tokenId);
925 		_owners.push(to);
926 
927 		emit Transfer(address(0), to, tokenId);
928 	}
929 
930 	/**
931 	 * @dev Destroys `tokenId`.
932 	 * The approval is cleared when the token is burned.
933 	 *
934 	 * Requirements:
935 	 *
936 	 * - `tokenId` must exist.
937 	 *
938 	 * Emits a {Transfer} event.
939 	 */
940 	function _burn(uint256 tokenId) internal virtual {
941 		address owner = ERC721B.ownerOf(tokenId);
942 
943 		_beforeTokenTransfer(owner, address(0), tokenId);
944 
945 		// Clear approvals
946 		_approve(address(0), tokenId);
947 		_owners[tokenId] = address(0);
948 
949 		emit Transfer(owner, address(0), tokenId);
950 	}
951 
952 	/**
953 	 * @dev Transfers `tokenId` from `from` to `to`.
954 	 *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
955 	 *
956 	 * Requirements:
957 	 *
958 	 * - `to` cannot be the zero address.
959 	 * - `tokenId` token must be owned by `from`.
960 	 *
961 	 * Emits a {Transfer} event.
962 	 */
963 	function _transfer(
964 		address from,
965 		address to,
966 		uint256 tokenId
967 	) internal virtual {
968 		require(ERC721B.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
969 		require(to != address(0), "ERC721: transfer to the zero address");
970 
971 		_beforeTokenTransfer(from, to, tokenId);
972 
973 		// Clear approvals from the previous owner
974 		_approve(address(0), tokenId);
975 		_owners[tokenId] = to;
976 
977 		emit Transfer(from, to, tokenId);
978 	}
979 
980 	/**
981 	 * @dev Approve `to` to operate on `tokenId`
982 	 *
983 	 * Emits a {Approval} event.
984 	 */
985 	function _approve(address to, uint256 tokenId) internal virtual {
986 		_tokenApprovals[tokenId] = to;
987 		emit Approval(ERC721B.ownerOf(tokenId), to, tokenId);
988 	}
989 
990 
991 	/**
992 	 * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
993 	 * The call is not executed if the target address is not a contract.
994 	 *
995 	 * @param from address representing the previous owner of the given token ID
996 	 * @param to target address that will receive the tokens
997 	 * @param tokenId uint256 ID of the token to be transferred
998 	 * @param _data bytes optional data to send along with the call
999 	 * @return bool whether the call correctly returned the expected magic value
1000 	 */
1001 	function _checkOnERC721Received(
1002 		address from,
1003 		address to,
1004 		uint256 tokenId,
1005 		bytes memory _data
1006 	) private returns (bool) {
1007 		if (to.isContract()) {
1008 			try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1009 				return retval == IERC721Receiver.onERC721Received.selector;
1010 			} catch (bytes memory reason) {
1011 				if (reason.length == 0) {
1012 					revert("ERC721: transfer to non ERC721Receiver implementer");
1013 				} else {
1014 					assembly {
1015 						revert(add(32, reason), mload(reason))
1016 					}
1017 				}
1018 			}
1019 		} else {
1020 			return true;
1021 		}
1022 	}
1023 
1024 	/**
1025 	 * @dev Hook that is called before any token transfer. This includes minting
1026 	 * and burning.
1027 	 *
1028 	 * Calling conditions:
1029 	 *
1030 	 * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1031 	 * transferred to `to`.
1032 	 * - When `from` is zero, `tokenId` will be minted for `to`.
1033 	 * - When `to` is zero, ``from``'s `tokenId` will be burned.
1034 	 * - `from` and `to` are never both zero.
1035 	 *
1036 	 * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1037 	 */
1038 	function _beforeTokenTransfer(
1039 		address from,
1040 		address to,
1041 		uint256 tokenId
1042 	) internal virtual {}
1043 }
1044 
1045 
1046 
1047 /** 
1048  *  
1049 */
1050             
1051 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1052 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 ////import "../utils/Context.sol";
1057 
1058 /**
1059  * @dev Contract module which provides a basic access control mechanism, where
1060  * there is an account (an owner) that can be granted exclusive access to
1061  * specific functions.
1062  *
1063  * By default, the owner account will be the one that deploys the contract. This
1064  * can later be changed with {transferOwnership}.
1065  *
1066  * This module is used through inheritance. It will make available the modifier
1067  * `onlyOwner`, which can be applied to your functions to restrict their use to
1068  * the owner.
1069  */
1070 abstract contract Ownable is Context {
1071     address private _owner;
1072 
1073     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1074 
1075     /**
1076      * @dev Initializes the contract setting the deployer as the initial owner.
1077      */
1078     constructor() {
1079         _transferOwnership(_msgSender());
1080     }
1081 
1082     /**
1083      * @dev Returns the address of the current owner.
1084      */
1085     function owner() public view virtual returns (address) {
1086         return _owner;
1087     }
1088 
1089     /**
1090      * @dev Throws if called by any account other than the owner.
1091      */
1092     modifier onlyOwner() {
1093         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1094         _;
1095     }
1096 
1097     /**
1098      * @dev Leaves the contract without owner. It will not be possible to call
1099      * `onlyOwner` functions anymore. Can only be called by the current owner.
1100      *
1101      * NOTE: Renouncing ownership will leave the contract without an owner,
1102      * thereby removing any functionality that is only available to the owner.
1103      */
1104     function renounceOwnership() public virtual onlyOwner {
1105         _transferOwnership(address(0));
1106     }
1107 
1108     /**
1109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1110      * Can only be called by the current owner.
1111      */
1112     function transferOwnership(address newOwner) public virtual onlyOwner {
1113         require(newOwner != address(0), "Ownable: new owner is the zero address");
1114         _transferOwnership(newOwner);
1115     }
1116 
1117     /**
1118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1119      * Internal function without access restriction.
1120      */
1121     function _transferOwnership(address newOwner) internal virtual {
1122         address oldOwner = _owner;
1123         _owner = newOwner;
1124         emit OwnershipTransferred(oldOwner, newOwner);
1125     }
1126 }
1127 
1128 
1129 
1130 
1131 /** 
1132  *  
1133 */
1134             
1135 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1136 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1137 
1138 pragma solidity ^0.8.0;
1139 
1140 /**
1141  * @dev Interface of the ERC20 standard as defined in the EIP.
1142  */
1143 interface IERC20 {
1144     /**
1145      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1146      * another (`to`).
1147      *
1148      * Note that `value` may be zero.
1149      */
1150     event Transfer(address indexed from, address indexed to, uint256 value);
1151 
1152     /**
1153      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1154      * a call to {approve}. `value` is the new allowance.
1155      */
1156     event Approval(address indexed owner, address indexed spender, uint256 value);
1157 
1158     /**
1159      * @dev Returns the amount of tokens in existence.
1160      */
1161     function totalSupply() external view returns (uint256);
1162 
1163     /**
1164      * @dev Returns the amount of tokens owned by `account`.
1165      */
1166     function balanceOf(address account) external view returns (uint256);
1167 
1168     /**
1169      * @dev Moves `amount` tokens from the caller's account to `to`.
1170      *
1171      * Returns a boolean value indicating whether the operation succeeded.
1172      *
1173      * Emits a {Transfer} event.
1174      */
1175     function transfer(address to, uint256 amount) external returns (bool);
1176 
1177     /**
1178      * @dev Returns the remaining number of tokens that `spender` will be
1179      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1180      * zero by default.
1181      *
1182      * This value changes when {approve} or {transferFrom} are called.
1183      */
1184     function allowance(address owner, address spender) external view returns (uint256);
1185 
1186     /**
1187      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1188      *
1189      * Returns a boolean value indicating whether the operation succeeded.
1190      *
1191      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
1192      * that someone may use both the old and the new allowance by unfortunate
1193      * transaction ordering. One possible solution to mitigate this race
1194      * condition is to first reduce the spender's allowance to 0 and set the
1195      * desired value afterwards:
1196      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1197      *
1198      * Emits an {Approval} event.
1199      */
1200     function approve(address spender, uint256 amount) external returns (bool);
1201 
1202     /**
1203      * @dev Moves `amount` tokens from `from` to `to` using the
1204      * allowance mechanism. `amount` is then deducted from the caller's
1205      * allowance.
1206      *
1207      * Returns a boolean value indicating whether the operation succeeded.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function transferFrom(
1212         address from,
1213         address to,
1214         uint256 amount
1215     ) external returns (bool);
1216 }
1217 
1218 
1219 
1220 
1221 /** 
1222  *  
1223 */
1224             
1225 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1226 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
1227 
1228 pragma solidity ^0.8.0;
1229 
1230 ////import "../IERC20.sol";
1231 ////import "../../../utils/Address.sol";
1232 
1233 /**
1234  * @title SafeERC20
1235  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1236  * contract returns false). Tokens that return no value (and instead revert or
1237  * throw on failure) are also supported, non-reverting calls are assumed to be
1238  * successful.
1239  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1240  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1241  */
1242 library SafeERC20 {
1243     using Address for address;
1244 
1245     function safeTransfer(
1246         IERC20 token,
1247         address to,
1248         uint256 value
1249     ) internal {
1250         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1251     }
1252 
1253     function safeTransferFrom(
1254         IERC20 token,
1255         address from,
1256         address to,
1257         uint256 value
1258     ) internal {
1259         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1260     }
1261 
1262     /**
1263      * @dev Deprecated. This function has issues similar to the ones found in
1264      * {IERC20-approve}, and its usage is discouraged.
1265      *
1266      * Whenever possible, use {safeIncreaseAllowance} and
1267      * {safeDecreaseAllowance} instead.
1268      */
1269     function safeApprove(
1270         IERC20 token,
1271         address spender,
1272         uint256 value
1273     ) internal {
1274         // safeApprove should only be called when setting an initial allowance,
1275         // or when resetting it to zero. To increase and decrease it, use
1276         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1277         require(
1278             (value == 0) || (token.allowance(address(this), spender) == 0),
1279             "SafeERC20: approve from non-zero to non-zero allowance"
1280         );
1281         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1282     }
1283 
1284     function safeIncreaseAllowance(
1285         IERC20 token,
1286         address spender,
1287         uint256 value
1288     ) internal {
1289         uint256 newAllowance = token.allowance(address(this), spender) + value;
1290         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1291     }
1292 
1293     function safeDecreaseAllowance(
1294         IERC20 token,
1295         address spender,
1296         uint256 value
1297     ) internal {
1298         unchecked {
1299             uint256 oldAllowance = token.allowance(address(this), spender);
1300             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1301             uint256 newAllowance = oldAllowance - value;
1302             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1303         }
1304     }
1305 
1306     /**
1307      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1308      * on the return value: the return value is optional (but if data is returned, it must not be false).
1309      * @param token The token targeted by the call.
1310      * @param data The call data (encoded using abi.encode or one of its variants).
1311      */
1312     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1313         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1314         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1315         // the target address contains contract code and also asserts for success in the low-level call.
1316 
1317         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1318         if (returndata.length > 0) {
1319             // Return data is optional
1320             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1321         }
1322     }
1323 }
1324 
1325 
1326 
1327 
1328 /** 
1329  *  
1330 */
1331             
1332 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1333 
1334 pragma solidity ^0.8.0;
1335 
1336 ////import "./ERC721B.sol";
1337 ////import "@openzeppelin/contracts/interfaces/IERC721Enumerable.sol";
1338 
1339 /*************************
1340 * @author: Squeebo       *
1341 * @license: BSD-3-Clause *
1342 **************************/
1343 
1344 /**
1345  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1346  * enumerability of all the token ids in the contract as well as all token ids owned by each
1347  * account.
1348  */
1349 abstract contract ERC721EnumerableB is ERC721B, IERC721Enumerable {
1350 	/**
1351 	 * @dev See {IERC165-supportsInterface}.
1352 	 */
1353 	function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721B) returns (bool) {
1354 		return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1355 	}
1356 
1357 	/**
1358 	 * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1359 	 */
1360 	function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1361 		require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1362 
1363 		uint count;
1364 		uint length = _owners.length;
1365 		for( uint i; i < length; ++i ){
1366 			if( owner == _owners[i] ){
1367 				if( count == index ){
1368 					delete count;
1369 					delete length;
1370 					return i;
1371 				}
1372 				else
1373 					++count;
1374 			}
1375 		}
1376 
1377 		delete count;
1378 		delete length;
1379 		require(false, "ERC721Enumerable: owner index out of bounds");
1380 	}
1381 
1382 	/**
1383 	 * @dev See {IERC721Enumerable-totalSupply}.
1384 	 */
1385 	function totalSupply() public view virtual override returns (uint256) {
1386 		return _owners.length;
1387 	}
1388 
1389 	/**
1390 	 * @dev See {IERC721Enumerable-tokenByIndex}.
1391 	 */
1392 	function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1393 		require(index < ERC721EnumerableB.totalSupply(), "ERC721Enumerable: global index out of bounds");
1394 		return index;
1395 	}
1396 }
1397 
1398 
1399 
1400 /** 
1401  *  
1402 */
1403             
1404 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1405 
1406 pragma solidity ^0.8.0;
1407 
1408 ////import "@openzeppelin/contracts/access/Ownable.sol";
1409 
1410 /*************************
1411 * @author: Squeebo       *
1412 * @license: BSD-3-Clause *
1413 **************************/
1414 
1415 contract Delegated is Ownable{
1416   mapping(address => bool) internal _delegates;
1417 
1418   constructor(){
1419 	_delegates[owner()] = true;
1420   }
1421 
1422   modifier onlyDelegates {
1423 	require(_delegates[msg.sender], "Invalid delegate" );
1424 	_;
1425   }
1426 
1427   //onlyOwner
1428   function isDelegate( address addr ) external view onlyOwner returns ( bool ){
1429 	return _delegates[addr];
1430   }
1431 
1432   function setDelegate( address addr, bool isDelegate_ ) external onlyOwner{
1433 	_delegates[addr] = isDelegate_;
1434   }
1435 }
1436 
1437 
1438 
1439 /** 
1440  *  
1441 */
1442             
1443 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1444 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
1445 
1446 pragma solidity ^0.8.0;
1447 
1448 /**
1449  * @dev These functions deal with verification of Merkle Trees proofs.
1450  *
1451  * The proofs can be generated using the JavaScript library
1452  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1453  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1454  *
1455  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1456  *
1457  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1458  * hashing, or use a hash function other than keccak256 for hashing leaves.
1459  * This is because the concatenation of a sorted pair of internal nodes in
1460  * the merkle tree could be reinterpreted as a leaf value.
1461  */
1462 library MerkleProof {
1463     /**
1464      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1465      * defined by `root`. For this, a `proof` must be provided, containing
1466      * sibling hashes on the branch from the leaf to the root of the tree. Each
1467      * pair of leaves and each pair of pre-images are assumed to be sorted.
1468      */
1469     function verify(
1470         bytes32[] memory proof,
1471         bytes32 root,
1472         bytes32 leaf
1473     ) internal pure returns (bool) {
1474         return processProof(proof, leaf) == root;
1475     }
1476 
1477     /**
1478      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1479      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1480      * hash matches the root of the tree. When processing the proof, the pairs
1481      * of leafs & pre-images are assumed to be sorted.
1482      *
1483      * _Available since v4.4._
1484      */
1485     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1486         bytes32 computedHash = leaf;
1487         for (uint256 i = 0; i < proof.length; i++) {
1488             bytes32 proofElement = proof[i];
1489             if (computedHash <= proofElement) {
1490                 // Hash(current computed hash + current element of the proof)
1491                 computedHash = _efficientHash(computedHash, proofElement);
1492             } else {
1493                 // Hash(current element of the proof + current computed hash)
1494                 computedHash = _efficientHash(proofElement, computedHash);
1495             }
1496         }
1497         return computedHash;
1498     }
1499 
1500     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1501         assembly {
1502             mstore(0x00, a)
1503             mstore(0x20, b)
1504             value := keccak256(0x00, 0x40)
1505         }
1506     }
1507 }
1508 
1509 
1510 
1511 
1512 /** 
1513  *  
1514 */
1515             
1516 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1517 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1518 
1519 pragma solidity ^0.8.0;
1520 
1521 /**
1522  * @dev String operations.
1523  */
1524 library Strings {
1525     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1526 
1527     /**
1528      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1529      */
1530     function toString(uint256 value) internal pure returns (string memory) {
1531         // Inspired by OraclizeAPI's implementation - MIT licence
1532         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1533 
1534         if (value == 0) {
1535             return "0";
1536         }
1537         uint256 temp = value;
1538         uint256 digits;
1539         while (temp != 0) {
1540             digits++;
1541             temp /= 10;
1542         }
1543         bytes memory buffer = new bytes(digits);
1544         while (value != 0) {
1545             digits -= 1;
1546             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1547             value /= 10;
1548         }
1549         return string(buffer);
1550     }
1551 
1552     /**
1553      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1554      */
1555     function toHexString(uint256 value) internal pure returns (string memory) {
1556         if (value == 0) {
1557             return "0x00";
1558         }
1559         uint256 temp = value;
1560         uint256 length = 0;
1561         while (temp != 0) {
1562             length++;
1563             temp >>= 8;
1564         }
1565         return toHexString(value, length);
1566     }
1567 
1568     /**
1569      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1570      */
1571     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1572         bytes memory buffer = new bytes(2 * length + 2);
1573         buffer[0] = "0";
1574         buffer[1] = "x";
1575         for (uint256 i = 2 * length + 1; i > 1; --i) {
1576             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1577             value >>= 4;
1578         }
1579         require(value == 0, "Strings: hex length insufficient");
1580         return string(buffer);
1581     }
1582 }
1583 
1584 
1585 
1586 
1587 /** 
1588  *  
1589 */
1590             
1591 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1592 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
1593 
1594 pragma solidity ^0.8.0;
1595 
1596 ////import "../token/ERC20/utils/SafeERC20.sol";
1597 ////import "../utils/Address.sol";
1598 ////import "../utils/Context.sol";
1599 
1600 /**
1601  * @title PaymentSplitter
1602  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1603  * that the Ether will be split in this way, since it is handled transparently by the contract.
1604  *
1605  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1606  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1607  * an amount proportional to the percentage of total shares they were assigned.
1608  *
1609  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1610  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1611  * function.
1612  *
1613  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1614  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1615  * to run tests before sending real value to this contract.
1616  */
1617 contract PaymentSplitter is Context {
1618     event PayeeAdded(address account, uint256 shares);
1619     event PaymentReleased(address to, uint256 amount);
1620     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1621     event PaymentReceived(address from, uint256 amount);
1622 
1623     uint256 private _totalShares;
1624     uint256 private _totalReleased;
1625 
1626     mapping(address => uint256) private _shares;
1627     mapping(address => uint256) private _released;
1628     address[] private _payees;
1629 
1630     mapping(IERC20 => uint256) private _erc20TotalReleased;
1631     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1632 
1633     /**
1634      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1635      * the matching position in the `shares` array.
1636      *
1637      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1638      * duplicates in `payees`.
1639      */
1640     constructor(address[] memory payees, uint256[] memory shares_) payable {
1641         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1642         require(payees.length > 0, "PaymentSplitter: no payees");
1643 
1644         for (uint256 i = 0; i < payees.length; i++) {
1645             _addPayee(payees[i], shares_[i]);
1646         }
1647     }
1648 
1649     /**
1650      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1651      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1652      * reliability of the events, and not the actual splitting of Ether.
1653      *
1654      * To learn more about this see the Solidity documentation for
1655      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1656      * functions].
1657      */
1658     receive() external payable virtual {
1659         emit PaymentReceived(_msgSender(), msg.value);
1660     }
1661 
1662     /**
1663      * @dev Getter for the total shares held by payees.
1664      */
1665     function totalShares() public view returns (uint256) {
1666         return _totalShares;
1667     }
1668 
1669     /**
1670      * @dev Getter for the total amount of Ether already released.
1671      */
1672     function totalReleased() public view returns (uint256) {
1673         return _totalReleased;
1674     }
1675 
1676     /**
1677      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1678      * contract.
1679      */
1680     function totalReleased(IERC20 token) public view returns (uint256) {
1681         return _erc20TotalReleased[token];
1682     }
1683 
1684     /**
1685      * @dev Getter for the amount of shares held by an account.
1686      */
1687     function shares(address account) public view returns (uint256) {
1688         return _shares[account];
1689     }
1690 
1691     /**
1692      * @dev Getter for the amount of Ether already released to a payee.
1693      */
1694     function released(address account) public view returns (uint256) {
1695         return _released[account];
1696     }
1697 
1698     /**
1699      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1700      * IERC20 contract.
1701      */
1702     function released(IERC20 token, address account) public view returns (uint256) {
1703         return _erc20Released[token][account];
1704     }
1705 
1706     /**
1707      * @dev Getter for the address of the payee number `index`.
1708      */
1709     function payee(uint256 index) public view returns (address) {
1710         return _payees[index];
1711     }
1712 
1713     /**
1714      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1715      * total shares and their previous withdrawals.
1716      */
1717     function release(address payable account) public virtual {
1718         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1719 
1720         uint256 totalReceived = address(this).balance + totalReleased();
1721         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1722 
1723         require(payment != 0, "PaymentSplitter: account is not due payment");
1724 
1725         _released[account] += payment;
1726         _totalReleased += payment;
1727 
1728         Address.sendValue(account, payment);
1729         emit PaymentReleased(account, payment);
1730     }
1731 
1732     /**
1733      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1734      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1735      * contract.
1736      */
1737     function release(IERC20 token, address account) public virtual {
1738         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1739 
1740         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1741         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1742 
1743         require(payment != 0, "PaymentSplitter: account is not due payment");
1744 
1745         _erc20Released[token][account] += payment;
1746         _erc20TotalReleased[token] += payment;
1747 
1748         SafeERC20.safeTransfer(token, account, payment);
1749         emit ERC20PaymentReleased(token, account, payment);
1750     }
1751 
1752     /**
1753      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1754      * already released amounts.
1755      */
1756     function _pendingPayment(
1757         address account,
1758         uint256 totalReceived,
1759         uint256 alreadyReleased
1760     ) private view returns (uint256) {
1761         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1762     }
1763 
1764     /**
1765      * @dev Add a new payee to the contract.
1766      * @param account The address of the payee to add.
1767      * @param shares_ The number of shares owned by the payee.
1768      */
1769     function _addPayee(address account, uint256 shares_) private {
1770         require(account != address(0), "PaymentSplitter: account is the zero address");
1771         require(shares_ > 0, "PaymentSplitter: shares are 0");
1772         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1773 
1774         _payees.push(account);
1775         _shares[account] = shares_;
1776         _totalShares = _totalShares + shares_;
1777         emit PayeeAdded(account, shares_);
1778     }
1779 }
1780 
1781 
1782 /** 
1783  *  
1784 */
1785 
1786 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
1787 
1788 pragma solidity ^0.8.7;
1789 
1790 ////import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
1791 ////import "@openzeppelin/contracts/utils/Strings.sol";
1792 ////import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
1793 ////import "./Delegated.sol";
1794 ////import "./ERC721EnumerableB.sol";
1795 
1796 /****************************************
1797  * @author: Squeebo                     *
1798  * @team:   X-11                        *
1799  ****************************************
1800  *   Blimpie-ERC721 provides low-gas    *
1801  *           mints + transfers          *
1802  ****************************************/
1803 
1804 contract grom is Delegated, ERC721EnumerableB, PaymentSplitter {
1805 	using Strings for uint;
1806 
1807 	bytes32 public merkleRoot;
1808 
1809 	uint public MAX_SUPPLY = 1000;
1810 	uint public WL_SUPPLY  = 500;
1811 
1812 	bool public isActive   = false;
1813 	bool public isActiveWL = false;
1814 	uint public maxOrder   = 5;
1815 	uint public price	   = 0.0169 ether;
1816 
1817 	string private _baseTokenURI = '';
1818 	string private _tokenURISuffix = '';
1819 
1820 	mapping(address => uint[]) private _balances;
1821 
1822 	address[] private addressList = [
1823 		0x7aa4720178a05654D48182aCF853b4eC1fe5f7E5,
1824 		0xD932B57C2A2A019C5b5924b86134FaF51280F956
1825 	];
1826 	uint[] private shareList = [
1827 		50,
1828 		50
1829 	];
1830 
1831 	constructor()
1832 		Delegated()
1833 		ERC721B("grom", "GROM")
1834 		PaymentSplitter(addressList, shareList)  {
1835 	}
1836 
1837 	//external
1838 	fallback() external payable {}
1839 
1840 	function mint( uint quantity ) external payable {
1841 		require( isActive,        				"Sale is not active"		);
1842 		require( quantity <= maxOrder,          "Order too big"             );
1843 		require( msg.value >= price * quantity, "Ether sent is not correct" );
1844 
1845 		uint256 supply = totalSupply();
1846 		require( supply + quantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1847 		for(uint i = 0; i < quantity; ++i){
1848 			_safeMint( msg.sender, supply++, "" );
1849 		}
1850 	}
1851 
1852 	function whitelistMint( bytes32[] calldata proof, uint quantity ) external payable {
1853 		require( isActiveWL,        			   "Whitelist sale is not active");
1854 		require( quantity <= maxOrder,            "Order too big"               );
1855 
1856 		bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1857 		require( MerkleProof.verify(proof, merkleRoot, leaf), "Not whitelisted");
1858 
1859 		uint256 supply = totalSupply();
1860 		require( supply + quantity <= WL_SUPPLY,  "Mint/order exceeds whitelist supply" );
1861 		require( supply + quantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1862 		
1863 		for(uint i = 0; i < quantity; ++i){
1864 			_safeMint( msg.sender, supply++, "" );
1865 		}  
1866 	}
1867 
1868 	//external delegated
1869 	function gift(uint[] calldata quantity, address[] calldata recipient) external onlyDelegates{
1870 		require(quantity.length == recipient.length, "Must provide equal quantities and recipients" );
1871 
1872 		uint totalQuantity = 0;
1873 		uint256 supply = totalSupply();
1874 		for(uint i = 0; i < quantity.length; ++i){
1875 			totalQuantity += quantity[i];
1876 		}
1877 		require( supply + totalQuantity <= MAX_SUPPLY, "Mint/order exceeds supply" );
1878 		delete totalQuantity;
1879 
1880 		for(uint i = 0; i < recipient.length; ++i){
1881 			for(uint j = 0; j < quantity[i]; ++j){
1882 				_safeMint( recipient[i], supply++, "Sent with love" );
1883 			}
1884 		}
1885 	}
1886 
1887 	function setWhitelistActive(bool isActiveWL_) external onlyDelegates {
1888 		if( isActiveWL != isActiveWL_ ) 
1889 			isActiveWL = isActiveWL_;
1890 	}
1891 
1892 	function setActive(bool isActive_) external onlyDelegates{
1893 		if( isActive != isActive_ )
1894 			isActive = isActive_;
1895 	}
1896 
1897 	function setMaxOrder(uint maxOrder_) external onlyDelegates{
1898 		if( maxOrder != maxOrder_ )
1899 			maxOrder = maxOrder_;
1900 	}
1901 
1902 	function setPrice(uint price_) external onlyDelegates{
1903 		if( price != price_ )
1904 			price = price_;
1905 	}
1906 
1907 	function setMerkleRoot(bytes32 root) external onlyDelegates {
1908 		merkleRoot = root;
1909 	}
1910 
1911 	function setBaseURI(string calldata _newBaseURI, string calldata _newSuffix) external onlyDelegates{
1912 		_baseTokenURI = _newBaseURI;
1913 		_tokenURISuffix = _newSuffix;
1914 	}
1915 
1916 	//external owner
1917 	function setMaxSupply(uint maxSupply) external onlyOwner{
1918 		if( MAX_SUPPLY != maxSupply ){
1919 			require(maxSupply >= totalSupply(), "Specified supply is lower than current balance" );
1920 			MAX_SUPPLY = maxSupply;
1921 		}
1922 	}
1923 
1924 	//public
1925 	function balanceOf(address owner) public view virtual override(ERC721B) returns (uint256) {
1926 		require(owner != address(0), "ERC721: balance query for the zero address");
1927 		return _balances[owner].length;
1928 	}
1929 
1930 	function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1931 		require(index < ERC721B.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1932 		return _balances[owner][index];
1933 	}
1934 
1935 	function tokenURI(uint tokenId) external view virtual override returns (string memory) {
1936 		require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1937 		return string(abi.encodePacked(_baseTokenURI, tokenId.toString(), _tokenURISuffix));
1938 	}
1939 
1940 	//internal
1941 	function _beforeTokenTransfer(
1942 		address from,
1943 		address to,
1944 		uint256 tokenId
1945 	) internal override virtual {
1946 		address zero = address(0);
1947 		if( from != zero || to == zero ){
1948 			//find this token and remove it
1949 			uint length = _balances[from].length;
1950 			for( uint i; i < length; ++i ){
1951 				if( _balances[from][i] == tokenId ){
1952 					_balances[from][i] = _balances[from][length - 1];
1953 					_balances[from].pop();
1954 					break;
1955 				}
1956 			}
1957 
1958 			delete length;
1959 		}
1960 
1961 		if( from == zero || to != zero ){
1962 			_balances[to].push( tokenId );
1963 		}
1964 	}
1965 }