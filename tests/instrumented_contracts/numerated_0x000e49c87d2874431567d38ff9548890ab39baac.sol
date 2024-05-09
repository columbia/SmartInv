1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 
5 //			  _______     ______      ______    _______    _______   _______    ________  
6 //			 /" _   "|   /    " \    /    " \  |   _  "\  /"     "| /"      \  /"       ) 
7 //			(: ( \___)  // ____  \  // ____  \ (. |_)  :)(: ______)|:        |(:   \___/  
8 //			 \/ \      /  /    ) :)/  /    ) :)|:     \/  \/    |  |_____/   ) \___  \    
9 //			 //  \ ___(: (____/ //(: (____/ // (|  _  \\  // ___)_  //      /   __/  \\   
10 //			(:   _(  _|\        /  \        /  |: |_)  :)(:      "||:  __   \  /" \   :)  
11 //			 \_______)  \"_____/    \"_____/   (_______/  \_______)|__|  \___)(_______/   
12                                                                               
13                                                                               
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 
36 
37 /**
38  * @dev Contract module that helps prevent reentrant calls to a function.
39  *
40  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
41  * available, which can be applied to functions to make sure there are no nested
42  * (reentrant) calls to them.
43  *
44  * Note that because there is a single `nonReentrant` guard, functions marked as
45  * `nonReentrant` may not call one another. This can be worked around by making
46  * those functions `private`, and then adding `external` `nonReentrant` entry
47  * points to them.
48  *
49  * TIP: If you would like to learn more about reentrancy and alternative ways
50  * to protect against it, check out our blog post
51  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
52  */
53 abstract contract ReentrancyGuard {
54     // Booleans are more expensive than uint256 or any type that takes up a full
55     // word because each write operation emits an extra SLOAD to first read the
56     // slot's contents, replace the bits taken up by the boolean, and then write
57     // back. This is the compiler's defense against contract upgrades and
58     // pointer aliasing, and it cannot be disabled.
59 
60     // The values being non-zero value makes deployment a bit more expensive,
61     // but in exchange the refund on every call to nonReentrant will be lower in
62     // amount. Since refunds are capped to a percentage of the total
63     // transaction's gas, it is best to keep them low in cases like this one, to
64     // increase the likelihood of the full refund coming into effect.
65     uint256 private constant _NOT_ENTERED = 1;
66     uint256 private constant _ENTERED = 2;
67 
68     uint256 private _status;
69 
70     constructor() {
71         _status = _NOT_ENTERED;
72     }
73 
74     /**
75      * @dev Prevents a contract from calling itself, directly or indirectly.
76      * Calling a `nonReentrant` function from another `nonReentrant`
77      * function is not supported. It is possible to prevent this from happening
78      * by making the `nonReentrant` function external, and make it call a
79      * `private` function that does the actual work.
80      */
81     modifier nonReentrant() {
82         // On the first call to nonReentrant, _notEntered will be true
83         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
84 
85         // Any calls to nonReentrant after this point will fail
86         _status = _ENTERED;
87 
88         _;
89 
90         // By storing the original value once again, a refund is triggered (see
91         // https://eips.ethereum.org/EIPS/eip-2200)
92         _status = _NOT_ENTERED;
93     }
94 }
95 
96 
97 
98 /**
99  * @dev Contract module which provides a basic access control mechanism, where
100  * there is an account (an owner) that can be granted exclusive access to
101  * specific functions.
102  *
103  * By default, the owner account will be the one that deploys the contract. This
104  * can later be changed with {transferOwnership}.
105  *
106  * This module is used through inheritance. It will make available the modifier
107  * `onlyOwner`, which can be applied to your functions to restrict their use to
108  * the owner.
109  */
110 abstract contract Ownable is Context {
111     address private _owner;
112 
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115     /**
116      * @dev Initializes the contract setting the deployer as the initial owner.
117      */
118     constructor() {
119         _setOwner(_msgSender());
120     }
121 
122     /**
123      * @dev Returns the address of the current owner.
124      */
125     function owner() public view virtual returns (address) {
126         return _owner;
127     }
128 
129     /**
130      * @dev Throws if called by any account other than the owner.
131      */
132     modifier onlyOwner() {
133         require(owner() == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     /**
138      * @dev Leaves the contract without owner. It will not be possible to call
139      * `onlyOwner` functions anymore. Can only be called by the current owner.
140      *
141      * NOTE: Renouncing ownership will leave the contract without an owner,
142      * thereby removing any functionality that is only available to the owner.
143      */
144     function renounceOwnership() public virtual onlyOwner {
145         _setOwner(address(0));
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      * Can only be called by the current owner.
151      */
152     function transferOwnership(address newOwner) public virtual onlyOwner {
153         require(newOwner != address(0), "Ownable: new owner is the zero address");
154         _setOwner(newOwner);
155     }
156 
157     function _setOwner(address newOwner) private {
158         address oldOwner = _owner;
159         _owner = newOwner;
160         emit OwnershipTransferred(oldOwner, newOwner);
161     }
162 }
163 
164 
165 /**
166  * @title Counters
167  * @author Matt Condon (@shrugs)
168  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
169  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
170  *
171  * Include with `using Counters for Counters.Counter;`
172  */
173 library Counters {
174     struct Counter {
175         // This variable should never be directly accessed by users of the library: interactions must be restricted to
176         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
177         // this feature: see https://github.com/ethereum/solidity/issues/4637
178         uint256 _value; // default: 0
179     }
180 
181     function current(Counter storage counter) internal view returns (uint256) {
182         return counter._value;
183     }
184 
185     function increment(Counter storage counter) internal {
186         unchecked {
187             counter._value += 1;
188         }
189     }
190 
191     function decrement(Counter storage counter) internal {
192         uint256 value = counter._value;
193         require(value > 0, "Counter: decrement overflow");
194         unchecked {
195             counter._value = value - 1;
196         }
197     }
198 
199     function reset(Counter storage counter) internal {
200         counter._value = 0;
201     }
202 }
203 
204 
205 /**
206  * @dev Interface of the ERC165 standard, as defined in the
207  * https://eips.ethereum.org/EIPS/eip-165[EIP].
208  *
209  * Implementers can declare support of contract interfaces, which can then be
210  * queried by others ({ERC165Checker}).
211  *
212  * For an implementation, see {ERC165}.
213  */
214 interface IERC165 {
215     /**
216      * @dev Returns true if this contract implements the interface defined by
217      * `interfaceId`. See the corresponding
218      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
219      * to learn more about how these ids are created.
220      *
221      * This function call must use less than 30 000 gas.
222      */
223     function supportsInterface(bytes4 interfaceId) external view returns (bool);
224 }
225 
226 
227 
228 /**
229  * @dev Implementation of the {IERC165} interface.
230  *
231  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
232  * for the additional interface id that will be supported. For example:
233  *
234  * ```solidity
235  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
236  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
237  * }
238  * ```
239  *
240  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
241  */
242 abstract contract ERC165 is IERC165 {
243     /**
244      * @dev See {IERC165-supportsInterface}.
245      */
246     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
247         return interfaceId == type(IERC165).interfaceId;
248     }
249 }
250 
251 
252 /**
253  * @dev String operations.
254  */
255 library Strings {
256     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
257 
258     /**
259      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
260      */
261     function toString(uint256 value) internal pure returns (string memory) {
262         // Inspired by OraclizeAPI's implementation - MIT licence
263         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
264 
265         if (value == 0) {
266             return "0";
267         }
268         uint256 temp = value;
269         uint256 digits;
270         while (temp != 0) {
271             digits++;
272             temp /= 10;
273         }
274         bytes memory buffer = new bytes(digits);
275         while (value != 0) {
276             digits -= 1;
277             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
278             value /= 10;
279         }
280         return string(buffer);
281     }
282 
283     /**
284      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
285      */
286     function toHexString(uint256 value) internal pure returns (string memory) {
287         if (value == 0) {
288             return "0x00";
289         }
290         uint256 temp = value;
291         uint256 length = 0;
292         while (temp != 0) {
293             length++;
294             temp >>= 8;
295         }
296         return toHexString(value, length);
297     }
298 
299     /**
300      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
301      */
302     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
303         bytes memory buffer = new bytes(2 * length + 2);
304         buffer[0] = "0";
305         buffer[1] = "x";
306         for (uint256 i = 2 * length + 1; i > 1; --i) {
307             buffer[i] = _HEX_SYMBOLS[value & 0xf];
308             value >>= 4;
309         }
310         require(value == 0, "Strings: hex length insufficient");
311         return string(buffer);
312     }
313 }
314 
315 
316 /**
317  * @dev Collection of functions related to the address type
318  */
319 library Address {
320     /**
321      * @dev Returns true if `account` is a contract.
322      *
323      * [IMPORTANT]
324      * ====
325      * It is unsafe to assume that an address for which this function returns
326      * false is an externally-owned account (EOA) and not a contract.
327      *
328      * Among others, `isContract` will return false for the following
329      * types of addresses:
330      *
331      *  - an externally-owned account
332      *  - a contract in construction
333      *  - an address where a contract will be created
334      *  - an address where a contract lived, but was destroyed
335      * ====
336      */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies on extcodesize, which returns 0 for contracts in
339         // construction, since the code is only stored at the end of the
340         // constructor execution.
341 
342         uint256 size;
343         assembly {
344             size := extcodesize(account)
345         }
346         return size > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         (bool success, ) = recipient.call{value: amount}("");
369         require(success, "Address: unable to send value, recipient may have reverted");
370     }
371 
372     /**
373      * @dev Performs a Solidity function call using a low level `call`. A
374      * plain `call` is an unsafe replacement for a function call: use this
375      * function instead.
376      *
377      * If `target` reverts with a revert reason, it is bubbled up by this
378      * function (like regular Solidity function calls).
379      *
380      * Returns the raw returned data. To convert to the expected return value,
381      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382      *
383      * Requirements:
384      *
385      * - `target` must be a contract.
386      * - calling `target` with `data` must not revert.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionCall(target, data, "Address: low-level call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
396      * `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but also transferring `value` wei to `target`.
411      *
412      * Requirements:
413      *
414      * - the calling contract must have an ETH balance of at least `value`.
415      * - the called Solidity function must be `payable`.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.call{value: value}(data);
443         return _verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
453         return functionStaticCall(target, data, "Address: low-level static call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return _verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return _verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     function _verifyCallResult(
501         bool success,
502         bytes memory returndata,
503         string memory errorMessage
504     ) private pure returns (bytes memory) {
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
524 /**
525  * @dev Required interface of an ERC721 compliant contract.
526  */
527 interface IERC721 is IERC165 {
528     /**
529      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
530      */
531     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
535      */
536     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
537 
538     /**
539      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
540      */
541     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
542 
543     /**
544      * @dev Returns the number of tokens in ``owner``'s account.
545      */
546     function balanceOf(address owner) external view returns (uint256 balance);
547 
548     /**
549      * @dev Returns the owner of the `tokenId` token.
550      *
551      * Requirements:
552      *
553      * - `tokenId` must exist.
554      */
555     function ownerOf(uint256 tokenId) external view returns (address owner);
556 
557     /**
558      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
559      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
560      *
561      * Requirements:
562      *
563      * - `from` cannot be the zero address.
564      * - `to` cannot be the zero address.
565      * - `tokenId` token must exist and be owned by `from`.
566      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
567      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
568      *
569      * Emits a {Transfer} event.
570      */
571     function safeTransferFrom(
572         address from,
573         address to,
574         uint256 tokenId
575     ) external;
576 
577     /**
578      * @dev Transfers `tokenId` token from `from` to `to`.
579      *
580      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
581      *
582      * Requirements:
583      *
584      * - `from` cannot be the zero address.
585      * - `to` cannot be the zero address.
586      * - `tokenId` token must be owned by `from`.
587      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transferFrom(
592         address from,
593         address to,
594         uint256 tokenId
595     ) external;
596 
597     /**
598      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
599      * The approval is cleared when the token is transferred.
600      *
601      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
602      *
603      * Requirements:
604      *
605      * - The caller must own the token or be an approved operator.
606      * - `tokenId` must exist.
607      *
608      * Emits an {Approval} event.
609      */
610     function approve(address to, uint256 tokenId) external;
611 
612     /**
613      * @dev Returns the account approved for `tokenId` token.
614      *
615      * Requirements:
616      *
617      * - `tokenId` must exist.
618      */
619     function getApproved(uint256 tokenId) external view returns (address operator);
620 
621     /**
622      * @dev Approve or remove `operator` as an operator for the caller.
623      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
624      *
625      * Requirements:
626      *
627      * - The `operator` cannot be the caller.
628      *
629      * Emits an {ApprovalForAll} event.
630      */
631     function setApprovalForAll(address operator, bool _approved) external;
632 
633     /**
634      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
635      *
636      * See {setApprovalForAll}
637      */
638     function isApprovedForAll(address owner, address operator) external view returns (bool);
639 
640     /**
641      * @dev Safely transfers `tokenId` token from `from` to `to`.
642      *
643      * Requirements:
644      *
645      * - `from` cannot be the zero address.
646      * - `to` cannot be the zero address.
647      * - `tokenId` token must exist and be owned by `from`.
648      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
649      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
650      *
651      * Emits a {Transfer} event.
652      */
653     function safeTransferFrom(
654         address from,
655         address to,
656         uint256 tokenId,
657         bytes calldata data
658     ) external;
659 }
660 
661 
662 /**
663  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
664  * @dev See https://eips.ethereum.org/EIPS/eip-721
665  */
666 interface IERC721Metadata is IERC721 {
667     /**
668      * @dev Returns the token collection name.
669      */
670     function name() external view returns (string memory);
671 
672     /**
673      * @dev Returns the token collection symbol.
674      */
675     function symbol() external view returns (string memory);
676 
677     /**
678      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
679      */
680     function tokenURI(uint256 tokenId) external view returns (string memory);
681 }
682 
683 
684 /**
685  * @title ERC721 token receiver interface
686  * @dev Interface for any contract that wants to support safeTransfers
687  * from ERC721 asset contracts.
688  */
689 interface IERC721Receiver {
690     /**
691      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
692      * by `operator` from `from`, this function is called.
693      *
694      * It must return its Solidity selector to confirm the token transfer.
695      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
696      *
697      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
698      */
699     function onERC721Received(
700         address operator,
701         address from,
702         uint256 tokenId,
703         bytes calldata data
704     ) external returns (bytes4);
705 }
706 
707 
708 
709 /**
710  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
711  * the Metadata extension, but not including the Enumerable extension, which is available separately as
712  * {ERC721Enumerable}.
713  */
714 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
715     using Address for address;
716     using Strings for uint256;
717 
718     // Token name
719     string private _name;
720 
721     // Token symbol
722     string private _symbol;
723 
724     // Mapping from token ID to owner address
725     mapping(uint256 => address) private _owners;
726 
727     // Mapping owner address to token count
728     mapping(address => uint256) private _balances;
729 
730     // Mapping from token ID to approved address
731     mapping(uint256 => address) private _tokenApprovals;
732 
733     // Mapping from owner to operator approvals
734     mapping(address => mapping(address => bool)) private _operatorApprovals;
735 
736     /**
737      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
738      */
739     constructor(string memory name_, string memory symbol_) {
740         _name = name_;
741         _symbol = symbol_;
742     }
743 
744     /**
745      * @dev See {IERC165-supportsInterface}.
746      */
747     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
748         return
749             interfaceId == type(IERC721).interfaceId ||
750             interfaceId == type(IERC721Metadata).interfaceId ||
751             super.supportsInterface(interfaceId);
752     }
753 
754     /**
755      * @dev See {IERC721-balanceOf}.
756      */
757     function balanceOf(address owner) public view virtual override returns (uint256) {
758         require(owner != address(0), "ERC721: balance query for the zero address");
759         return _balances[owner];
760     }
761 
762     /**
763      * @dev See {IERC721-ownerOf}.
764      */
765     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
766         address owner = _owners[tokenId];
767         require(owner != address(0), "ERC721: owner query for nonexistent token");
768         return owner;
769     }
770 
771     /**
772      * @dev See {IERC721Metadata-name}.
773      */
774     function name() public view virtual override returns (string memory) {
775         return _name;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-symbol}.
780      */
781     function symbol() public view virtual override returns (string memory) {
782         return _symbol;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-tokenURI}.
787      */
788     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
789         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
790 
791         string memory baseURI = _baseURI();
792         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
793     }
794 
795     /**
796      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
797      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
798      * by default, can be overriden in child contracts.
799      */
800     function _baseURI() internal view virtual returns (string memory) {
801         return "";
802     }
803 
804     /**
805      * @dev See {IERC721-approve}.
806      */
807     function approve(address to, uint256 tokenId) public virtual override {
808         address owner = ERC721.ownerOf(tokenId);
809         require(to != owner, "ERC721: approval to current owner");
810 
811         require(
812             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
813             "ERC721: approve caller is not owner nor approved for all"
814         );
815 
816         _approve(to, tokenId);
817     }
818 
819     /**
820      * @dev See {IERC721-getApproved}.
821      */
822     function getApproved(uint256 tokenId) public view virtual override returns (address) {
823         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
824 
825         return _tokenApprovals[tokenId];
826     }
827 
828     /**
829      * @dev See {IERC721-setApprovalForAll}.
830      */
831     function setApprovalForAll(address operator, bool approved) public virtual override {
832         require(operator != _msgSender(), "ERC721: approve to caller");
833 
834         _operatorApprovals[_msgSender()][operator] = approved;
835         emit ApprovalForAll(_msgSender(), operator, approved);
836     }
837 
838     /**
839      * @dev See {IERC721-isApprovedForAll}.
840      */
841     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
842         return _operatorApprovals[owner][operator];
843     }
844 
845     /**
846      * @dev See {IERC721-transferFrom}.
847      */
848     function transferFrom(
849         address from,
850         address to,
851         uint256 tokenId
852     ) public virtual override {
853         //solhint-disable-next-line max-line-length
854         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
855 
856         _transfer(from, to, tokenId);
857     }
858 
859     /**
860      * @dev See {IERC721-safeTransferFrom}.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 tokenId
866     ) public virtual override {
867         safeTransferFrom(from, to, tokenId, "");
868     }
869 
870     /**
871      * @dev See {IERC721-safeTransferFrom}.
872      */
873     function safeTransferFrom(
874         address from,
875         address to,
876         uint256 tokenId,
877         bytes memory _data
878     ) public virtual override {
879         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
880         _safeTransfer(from, to, tokenId, _data);
881     }
882 
883     /**
884      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
885      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
886      *
887      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
888      *
889      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
890      * implement alternative mechanisms to perform token transfer, such as signature-based.
891      *
892      * Requirements:
893      *
894      * - `from` cannot be the zero address.
895      * - `to` cannot be the zero address.
896      * - `tokenId` token must exist and be owned by `from`.
897      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
898      *
899      * Emits a {Transfer} event.
900      */
901     function _safeTransfer(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes memory _data
906     ) internal virtual {
907         _transfer(from, to, tokenId);
908         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
909     }
910 
911     /**
912      * @dev Returns whether `tokenId` exists.
913      *
914      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
915      *
916      * Tokens start existing when they are minted (`_mint`),
917      * and stop existing when they are burned (`_burn`).
918      */
919     function _exists(uint256 tokenId) internal view virtual returns (bool) {
920         return _owners[tokenId] != address(0);
921     }
922 
923     /**
924      * @dev Returns whether `spender` is allowed to manage `tokenId`.
925      *
926      * Requirements:
927      *
928      * - `tokenId` must exist.
929      */
930     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
931         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
932         address owner = ERC721.ownerOf(tokenId);
933         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
934     }
935 
936     /**
937      * @dev Safely mints `tokenId` and transfers it to `to`.
938      *
939      * Requirements:
940      *
941      * - `tokenId` must not exist.
942      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
943      *
944      * Emits a {Transfer} event.
945      */
946     function _safeMint(address to, uint256 tokenId) internal virtual {
947         _safeMint(to, tokenId, "");
948     }
949 
950     /**
951      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
952      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
953      */
954     function _safeMint(
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) internal virtual {
959         _mint(to, tokenId);
960         require(
961             _checkOnERC721Received(address(0), to, tokenId, _data),
962             "ERC721: transfer to non ERC721Receiver implementer"
963         );
964     }
965 
966     /**
967      * @dev Mints `tokenId` and transfers it to `to`.
968      *
969      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
970      *
971      * Requirements:
972      *
973      * - `tokenId` must not exist.
974      * - `to` cannot be the zero address.
975      *
976      * Emits a {Transfer} event.
977      */
978     function _mint(address to, uint256 tokenId) internal virtual {
979         require(to != address(0), "ERC721: mint to the zero address");
980         require(!_exists(tokenId), "ERC721: token already minted");
981 
982         _beforeTokenTransfer(address(0), to, tokenId);
983 
984         _balances[to] += 1;
985         _owners[tokenId] = to;
986 
987         emit Transfer(address(0), to, tokenId);
988     }
989 
990     /**
991      * @dev Destroys `tokenId`.
992      * The approval is cleared when the token is burned.
993      *
994      * Requirements:
995      *
996      * - `tokenId` must exist.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _burn(uint256 tokenId) internal virtual {
1001         address owner = ERC721.ownerOf(tokenId);
1002 
1003         _beforeTokenTransfer(owner, address(0), tokenId);
1004 
1005         // Clear approvals
1006         _approve(address(0), tokenId);
1007 
1008         _balances[owner] -= 1;
1009         delete _owners[tokenId];
1010 
1011         emit Transfer(owner, address(0), tokenId);
1012     }
1013 
1014     /**
1015      * @dev Transfers `tokenId` from `from` to `to`.
1016      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1017      *
1018      * Requirements:
1019      *
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must be owned by `from`.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _transfer(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) internal virtual {
1030         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1031         require(to != address(0), "ERC721: transfer to the zero address");
1032 
1033         _beforeTokenTransfer(from, to, tokenId);
1034 
1035         // Clear approvals from the previous owner
1036         _approve(address(0), tokenId);
1037 
1038         _balances[from] -= 1;
1039         _balances[to] += 1;
1040         _owners[tokenId] = to;
1041 
1042         emit Transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev Approve `to` to operate on `tokenId`
1047      *
1048      * Emits a {Approval} event.
1049      */
1050     function _approve(address to, uint256 tokenId) internal virtual {
1051         _tokenApprovals[tokenId] = to;
1052         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1053     }
1054 
1055     /**
1056      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1057      * The call is not executed if the target address is not a contract.
1058      *
1059      * @param from address representing the previous owner of the given token ID
1060      * @param to target address that will receive the tokens
1061      * @param tokenId uint256 ID of the token to be transferred
1062      * @param _data bytes optional data to send along with the call
1063      * @return bool whether the call correctly returned the expected magic value
1064      */
1065     function _checkOnERC721Received(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes memory _data
1070     ) private returns (bool) {
1071         if (to.isContract()) {
1072             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1073                 return retval == IERC721Receiver(to).onERC721Received.selector;
1074             } catch (bytes memory reason) {
1075                 if (reason.length == 0) {
1076                     revert("ERC721: transfer to non ERC721Receiver implementer");
1077                 } else {
1078                     assembly {
1079                         revert(add(32, reason), mload(reason))
1080                     }
1081                 }
1082             }
1083         } else {
1084             return true;
1085         }
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before any token transfer. This includes minting
1090      * and burning.
1091      *
1092      * Calling conditions:
1093      *
1094      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1095      * transferred to `to`.
1096      * - When `from` is zero, `tokenId` will be minted for `to`.
1097      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1098      * - `from` and `to` are never both zero.
1099      *
1100      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1101      */
1102     function _beforeTokenTransfer(
1103         address from,
1104         address to,
1105         uint256 tokenId
1106     ) internal virtual {}
1107 }
1108 
1109 /**
1110  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1111  * @dev See https://eips.ethereum.org/EIPS/eip-721
1112  */
1113 interface IERC721Enumerable is IERC721 {
1114     /**
1115      * @dev Returns the total amount of tokens stored by the contract.
1116      */
1117     function totalSupply() external view returns (uint256);
1118 
1119     /**
1120      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1121      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1122      */
1123     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1124 
1125     /**
1126      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1127      * Use along with {totalSupply} to enumerate all tokens.
1128      */
1129     function tokenByIndex(uint256 index) external view returns (uint256);
1130 }
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
1289 contract GoobersNFT is ERC721Enumerable, Ownable, ReentrancyGuard {
1290     using Counters for Counters.Counter;
1291 
1292     Counters.Counter private _tokenIds;
1293     
1294     mapping(address => uint256) whitelisted;
1295     mapping(address => uint256) reservedClaims;
1296  
1297     string private _baseTokenURI;
1298 
1299     string public GOOBER_PROVENANCE = "";
1300     
1301     uint256 public startingIndexBlock;
1302 
1303     uint256 public startingIndex;
1304 
1305     uint256 public revealDate;
1306     
1307     uint256 public gooberPrice = 0.08 ether; 
1308     
1309     uint public constant maxPurchaseAmt = 20;
1310     
1311     uint256 public maxSupply = 15000;
1312     
1313     uint256 public reservedCount;
1314 
1315     bool public saleIsActive = true;
1316     
1317     uint256 public whiteSaleStart;
1318     uint256 public whiteSaleEnd;
1319     uint256 public redeemReservedStart;
1320 
1321     constructor(
1322         uint256 _whiteSaleStart,
1323         uint256 _whiteSaleEnd,
1324         uint256 _redeemReservedStart,
1325         uint256 _revealDate
1326     ) ERC721("Goobers", "GOOBERS") {
1327         whiteSaleStart = _whiteSaleStart;
1328         whiteSaleEnd = _whiteSaleEnd;
1329         redeemReservedStart = _redeemReservedStart;
1330         revealDate = _revealDate;
1331     }
1332     
1333     function withdraw() external onlyOwner payable {
1334         uint balance = address(this).balance;
1335         payable(msg.sender).transfer(balance);
1336     }
1337     
1338     function whitelist(address[] memory addresses) external onlyOwner payable {
1339         for (uint i=0; i < addresses.length; i++){
1340             whitelisted[addresses[i]] = 4;
1341         }
1342     }
1343     
1344     function reserveClaims(address[] memory addresses, uint256[] memory amounts) external onlyOwner payable {
1345         for (uint i=0; i < addresses.length; i++){
1346             reservedClaims[addresses[i]] = amounts[i];
1347             unchecked { reservedCount += amounts[i]; }
1348         }
1349     }
1350     
1351     function claim() external {
1352         require(block.timestamp > redeemReservedStart && saleIsActive, "You can't claim yet");
1353         require(reservedClaims[msg.sender] > 0, "Nothing to claim");
1354         
1355         uint256 _amount = reservedClaims[msg.sender];
1356         unchecked { reservedCount -= _amount; }
1357         reservedClaims[msg.sender] = 0;
1358         
1359         _mintGoobers(_amount);
1360         
1361     }
1362     
1363     function purchase(uint256 _amount) external payable {
1364         require(block.timestamp > whiteSaleStart && saleIsActive, "Sale is not active");
1365         require(_amount <= maxPurchaseAmt, "Can only mint 20 NFTs at a time");
1366         require( (gooberPrice * _amount) == msg.value, "ETH value sent is not correct");
1367         
1368         if (block.timestamp < whiteSaleEnd){
1369             require(whitelisted[msg.sender] > 0, "Not whitelisted or used allocation");
1370             require(_amount <= whitelisted[msg.sender], "Whitelist allocation is 4 NFTs");
1371             unchecked { whitelisted[msg.sender] -= _amount; }
1372         }
1373         
1374         _mintGoobers(_amount);
1375     }
1376     
1377     function _mintGoobers(uint _amount) internal nonReentrant {
1378         require((_tokenIds.current() + _amount) <=  maxSupply - reservedCount, "Mint would exceed max supply");
1379         
1380         for(uint i = 0; i < _amount; i++) {
1381             _tokenIds.increment();
1382             _safeMint(msg.sender, _tokenIds.current());
1383         }
1384 
1385         if (startingIndexBlock == 0 && (totalSupply() == maxSupply || block.timestamp >= revealDate)) {
1386             _setStartingIndex();
1387         } 
1388     }
1389     
1390     
1391     function _setStartingIndex() internal {
1392         require(startingIndex == 0, "Starting index is already set");
1393 
1394         startingIndexBlock = block.number - 1;
1395 
1396         startingIndex = uint(blockhash(startingIndexBlock)) % maxSupply;
1397     }
1398 
1399     function setRevealTimestamp(uint256 _revealTimeStamp) external onlyOwner payable {
1400         revealDate = _revealTimeStamp;
1401     } 
1402     
1403     function setWhiteSaleStart(uint256 _startingTimestamp) external onlyOwner payable {
1404         whiteSaleStart = _startingTimestamp;
1405     }
1406     
1407     function setWhiteSaleDuration(uint256 _whiteSaleEnd) external onlyOwner payable {
1408         whiteSaleEnd = _whiteSaleEnd;
1409     }
1410     
1411     function setRedeemReservedStart(uint256 _redeemReservedStartTimestamp) external onlyOwner payable{
1412         redeemReservedStart = _redeemReservedStartTimestamp;
1413     }
1414     
1415     function setProvenanceHash(string memory provenanceHash) external onlyOwner payable {
1416         GOOBER_PROVENANCE = provenanceHash;
1417     }
1418     
1419     function setBaseURI(string calldata newBaseTokenURI) external onlyOwner payable {
1420         _baseTokenURI = newBaseTokenURI;
1421     }
1422     
1423     function _baseURI() internal view override returns (string memory) {
1424         return _baseTokenURI;
1425     }
1426 
1427     function baseURI() public view returns (string memory) {
1428         return _baseURI();
1429     }
1430     
1431     function availableClaims(address addr) public view returns (uint256) {
1432         return reservedClaims[addr];
1433     }
1434 	
1435 	function whitelistBalance(address _address) public view returns (uint256) {
1436 		return whitelisted[_address];
1437 	}
1438 
1439     function changeSaleState() external onlyOwner payable {
1440         saleIsActive = !saleIsActive;
1441     }
1442     
1443     function setGooberPrice(uint256 Price) external onlyOwner payable {
1444         gooberPrice = Price;
1445     } 
1446     
1447     function addressAllocation(address addr) public view returns (uint256){
1448         return whitelisted[addr];
1449     }
1450     
1451     function currentReservedCount() public view returns (uint256){
1452         return reservedCount;
1453     }
1454 
1455 }