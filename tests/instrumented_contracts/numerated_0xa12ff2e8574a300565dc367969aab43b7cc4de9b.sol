1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 
67 
68 /**
69  * @dev Provides information about the current execution context, including the
70  * sender of the transaction and its data. While these are generally available
71  * via msg.sender and msg.data, they should not be accessed in such a direct
72  * manner, since when dealing with meta-transactions the account sending and
73  * paying for execution may not be the actual sender (as far as an application
74  * is concerned).
75  *
76  * This contract is only required for intermediate, library-like contracts.
77  */
78 abstract contract Context {
79     function _msgSender() internal view virtual returns (address) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view virtual returns (bytes calldata) {
84         return msg.data;
85     }
86 }
87 
88 
89 /**
90  * @dev Contract module which provides a basic access control mechanism, where
91  * there is an account (an owner) that can be granted exclusive access to
92  * specific functions.
93  *
94  * By default, the owner account will be the one that deploys the contract. This
95  * can later be changed with {transferOwnership}.
96  *
97  * This module is used through inheritance. It will make available the modifier
98  * `onlyOwner`, which can be applied to your functions to restrict their use to
99  * the owner.
100  */
101 abstract contract Ownable is Context {
102     address private _owner;
103 
104     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
105 
106     /**
107      * @dev Initializes the contract setting the deployer as the initial owner.
108      */
109     constructor() {
110         _transferOwnership(_msgSender());
111     }
112 
113     /**
114      * @dev Returns the address of the current owner.
115      */
116     function owner() public view virtual returns (address) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(owner() == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     /**
129      * @dev Leaves the contract without owner. It will not be possible to call
130      * `onlyOwner` functions anymore. Can only be called by the current owner.
131      *
132      * NOTE: Renouncing ownership will leave the contract without an owner,
133      * thereby removing any functionality that is only available to the owner.
134      */
135     function renounceOwnership() public virtual onlyOwner {
136         _transferOwnership(address(0));
137     }
138 
139     /**
140      * @dev Transfers ownership of the contract to a new account (`newOwner`).
141      * Can only be called by the current owner.
142      */
143     function transferOwnership(address newOwner) public virtual onlyOwner {
144         require(newOwner != address(0), "Ownable: new owner is the zero address");
145         _transferOwnership(newOwner);
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      * Internal function without access restriction.
151      */
152     function _transferOwnership(address newOwner) internal virtual {
153         address oldOwner = _owner;
154         _owner = newOwner;
155         emit OwnershipTransferred(oldOwner, newOwner);
156     }
157 }
158 
159 
160 /**
161  * @dev Contract module that helps prevent reentrant calls to a function.
162  *
163  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
164  * available, which can be applied to functions to make sure there are no nested
165  * (reentrant) calls to them.
166  *
167  * Note that because there is a single `nonReentrant` guard, functions marked as
168  * `nonReentrant` may not call one another. This can be worked around by making
169  * those functions `private`, and then adding `external` `nonReentrant` entry
170  * points to them.
171  *
172  * TIP: If you would like to learn more about reentrancy and alternative ways
173  * to protect against it, check out our blog post
174  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
175  */
176 abstract contract ReentrancyGuard {
177     // Booleans are more expensive than uint256 or any type that takes up a full
178     // word because each write operation emits an extra SLOAD to first read the
179     // slot's contents, replace the bits taken up by the boolean, and then write
180     // back. This is the compiler's defense against contract upgrades and
181     // pointer aliasing, and it cannot be disabled.
182 
183     // The values being non-zero value makes deployment a bit more expensive,
184     // but in exchange the refund on every call to nonReentrant will be lower in
185     // amount. Since refunds are capped to a percentage of the total
186     // transaction's gas, it is best to keep them low in cases like this one, to
187     // increase the likelihood of the full refund coming into effect.
188     uint256 private constant _NOT_ENTERED = 1;
189     uint256 private constant _ENTERED = 2;
190 
191     uint256 private _status;
192 
193     constructor() {
194         _status = _NOT_ENTERED;
195     }
196 
197     /**
198      * @dev Prevents a contract from calling itself, directly or indirectly.
199      * Calling a `nonReentrant` function from another `nonReentrant`
200      * function is not supported. It is possible to prevent this from happening
201      * by making the `nonReentrant` function external, and making it call a
202      * `private` function that does the actual work.
203      */
204     modifier nonReentrant() {
205         // On the first call to nonReentrant, _notEntered will be true
206         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
207 
208         // Any calls to nonReentrant after this point will fail
209         _status = _ENTERED;
210 
211         _;
212 
213         // By storing the original value once again, a refund is triggered (see
214         // https://eips.ethereum.org/EIPS/eip-2200)
215         _status = _NOT_ENTERED;
216     }
217 }
218 
219 
220 /**
221  * @dev Interface of the ERC165 standard, as defined in the
222  * https://eips.ethereum.org/EIPS/eip-165[EIP].
223  *
224  * Implementers can declare support of contract interfaces, which can then be
225  * queried by others ({ERC165Checker}).
226  *
227  * For an implementation, see {ERC165}.
228  */
229 interface IERC165 {
230     /**
231      * @dev Returns true if this contract implements the interface defined by
232      * `interfaceId`. See the corresponding
233      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
234      * to learn more about how these ids are created.
235      *
236      * This function call must use less than 30 000 gas.
237      */
238     function supportsInterface(bytes4 interfaceId) external view returns (bool);
239 }
240 
241 
242 /**
243  * @dev Required interface of an ERC721 compliant contract.
244  */
245 interface IERC721 is IERC165 {
246     /**
247      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
250 
251     /**
252      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
253      */
254     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
255 
256     /**
257      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
258      */
259     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
260 
261     /**
262      * @dev Returns the number of tokens in ``owner``'s account.
263      */
264     function balanceOf(address owner) external view returns (uint256 balance);
265 
266     /**
267      * @dev Returns the owner of the `tokenId` token.
268      *
269      * Requirements:
270      *
271      * - `tokenId` must exist.
272      */
273     function ownerOf(uint256 tokenId) external view returns (address owner);
274 
275     /**
276      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
277      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
278      *
279      * Requirements:
280      *
281      * - `from` cannot be the zero address.
282      * - `to` cannot be the zero address.
283      * - `tokenId` token must exist and be owned by `from`.
284      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
285      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
286      *
287      * Emits a {Transfer} event.
288      */
289     function safeTransferFrom(
290         address from,
291         address to,
292         uint256 tokenId
293     ) external;
294 
295     /**
296      * @dev Transfers `tokenId` token from `from` to `to`.
297      *
298      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
299      *
300      * Requirements:
301      *
302      * - `from` cannot be the zero address.
303      * - `to` cannot be the zero address.
304      * - `tokenId` token must be owned by `from`.
305      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transferFrom(
310         address from,
311         address to,
312         uint256 tokenId
313     ) external;
314 
315     /**
316      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
317      * The approval is cleared when the token is transferred.
318      *
319      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
320      *
321      * Requirements:
322      *
323      * - The caller must own the token or be an approved operator.
324      * - `tokenId` must exist.
325      *
326      * Emits an {Approval} event.
327      */
328     function approve(address to, uint256 tokenId) external;
329 
330     /**
331      * @dev Returns the account approved for `tokenId` token.
332      *
333      * Requirements:
334      *
335      * - `tokenId` must exist.
336      */
337     function getApproved(uint256 tokenId) external view returns (address operator);
338 
339     /**
340      * @dev Approve or remove `operator` as an operator for the caller.
341      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
342      *
343      * Requirements:
344      *
345      * - The `operator` cannot be the caller.
346      *
347      * Emits an {ApprovalForAll} event.
348      */
349     function setApprovalForAll(address operator, bool _approved) external;
350 
351     /**
352      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
353      *
354      * See {setApprovalForAll}
355      */
356     function isApprovedForAll(address owner, address operator) external view returns (bool);
357 
358     /**
359      * @dev Safely transfers `tokenId` token from `from` to `to`.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `tokenId` token must exist and be owned by `from`.
366      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
367      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
368      *
369      * Emits a {Transfer} event.
370      */
371     function safeTransferFrom(
372         address from,
373         address to,
374         uint256 tokenId,
375         bytes calldata data
376     ) external;
377 }
378 
379 
380 /**
381  * @title ERC721 token receiver interface
382  * @dev Interface for any contract that wants to support safeTransfers
383  * from ERC721 asset contracts.
384  */
385 interface IERC721Receiver {
386     /**
387      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
388      * by `operator` from `from`, this function is called.
389      *
390      * It must return its Solidity selector to confirm the token transfer.
391      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
392      *
393      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
394      */
395     function onERC721Received(
396         address operator,
397         address from,
398         uint256 tokenId,
399         bytes calldata data
400     ) external returns (bytes4);
401 }
402 
403 
404 /**
405  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
406  * @dev See https://eips.ethereum.org/EIPS/eip-721
407  */
408 interface IERC721Metadata is IERC721 {
409     /**
410      * @dev Returns the token collection name.
411      */
412     function name() external view returns (string memory);
413 
414     /**
415      * @dev Returns the token collection symbol.
416      */
417     function symbol() external view returns (string memory);
418 
419     /**
420      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
421      */
422     function tokenURI(uint256 tokenId) external view returns (string memory);
423 }
424 
425 
426 
427 /**
428  * @dev Collection of functions related to the address type
429  */
430 library Address {
431     /**
432      * @dev Returns true if `account` is a contract.
433      *
434      * [IMPORTANT]
435      * ====
436      * It is unsafe to assume that an address for which this function returns
437      * false is an externally-owned account (EOA) and not a contract.
438      *
439      * Among others, `isContract` will return false for the following
440      * types of addresses:
441      *
442      *  - an externally-owned account
443      *  - a contract in construction
444      *  - an address where a contract will be created
445      *  - an address where a contract lived, but was destroyed
446      * ====
447      *
448      * [IMPORTANT]
449      * ====
450      * You shouldn't rely on `isContract` to protect against flash loan attacks!
451      *
452      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
453      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
454      * constructor.
455      * ====
456      */
457     function isContract(address account) internal view returns (bool) {
458         // This method relies on extcodesize/address.code.length, which returns 0
459         // for contracts in construction, since the code is only stored at the end
460         // of the constructor execution.
461 
462         return account.code.length > 0;
463     }
464 
465     /**
466      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
467      * `recipient`, forwarding all available gas and reverting on errors.
468      *
469      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
470      * of certain opcodes, possibly making contracts go over the 2300 gas limit
471      * imposed by `transfer`, making them unable to receive funds via
472      * `transfer`. {sendValue} removes this limitation.
473      *
474      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
475      *
476      * IMPORTANT: because control is transferred to `recipient`, care must be
477      * taken to not create reentrancy vulnerabilities. Consider using
478      * {ReentrancyGuard} or the
479      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
480      */
481     function sendValue(address payable recipient, uint256 amount) internal {
482         require(address(this).balance >= amount, "Address: insufficient balance");
483 
484         (bool success, ) = recipient.call{value: amount}("");
485         require(success, "Address: unable to send value, recipient may have reverted");
486     }
487 
488     /**
489      * @dev Performs a Solidity function call using a low level `call`. A
490      * plain `call` is an unsafe replacement for a function call: use this
491      * function instead.
492      *
493      * If `target` reverts with a revert reason, it is bubbled up by this
494      * function (like regular Solidity function calls).
495      *
496      * Returns the raw returned data. To convert to the expected return value,
497      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
498      *
499      * Requirements:
500      *
501      * - `target` must be a contract.
502      * - calling `target` with `data` must not revert.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
507         return functionCall(target, data, "Address: low-level call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
512      * `errorMessage` as a fallback revert reason when `target` reverts.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(
517         address target,
518         bytes memory data,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         return functionCallWithValue(target, data, 0, errorMessage);
522     }
523 
524     /**
525      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
526      * but also transferring `value` wei to `target`.
527      *
528      * Requirements:
529      *
530      * - the calling contract must have an ETH balance of at least `value`.
531      * - the called Solidity function must be `payable`.
532      *
533      * _Available since v3.1._
534      */
535     function functionCallWithValue(
536         address target,
537         bytes memory data,
538         uint256 value
539     ) internal returns (bytes memory) {
540         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
545      * with `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCallWithValue(
550         address target,
551         bytes memory data,
552         uint256 value,
553         string memory errorMessage
554     ) internal returns (bytes memory) {
555         require(address(this).balance >= value, "Address: insufficient balance for call");
556         require(isContract(target), "Address: call to non-contract");
557 
558         (bool success, bytes memory returndata) = target.call{value: value}(data);
559         return verifyCallResult(success, returndata, errorMessage);
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
569         return functionStaticCall(target, data, "Address: low-level static call failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(
579         address target,
580         bytes memory data,
581         string memory errorMessage
582     ) internal view returns (bytes memory) {
583         require(isContract(target), "Address: static call to non-contract");
584 
585         (bool success, bytes memory returndata) = target.staticcall(data);
586         return verifyCallResult(success, returndata, errorMessage);
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
591      * but performing a delegate call.
592      *
593      * _Available since v3.4._
594      */
595     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
596         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(
606         address target,
607         bytes memory data,
608         string memory errorMessage
609     ) internal returns (bytes memory) {
610         require(isContract(target), "Address: delegate call to non-contract");
611 
612         (bool success, bytes memory returndata) = target.delegatecall(data);
613         return verifyCallResult(success, returndata, errorMessage);
614     }
615 
616     /**
617      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
618      * revert reason using the provided one.
619      *
620      * _Available since v4.3._
621      */
622     function verifyCallResult(
623         bool success,
624         bytes memory returndata,
625         string memory errorMessage
626     ) internal pure returns (bytes memory) {
627         if (success) {
628             return returndata;
629         } else {
630             // Look for revert reason and bubble it up if present
631             if (returndata.length > 0) {
632                 // The easiest way to bubble the revert reason is using memory via assembly
633 
634                 assembly {
635                     let returndata_size := mload(returndata)
636                     revert(add(32, returndata), returndata_size)
637                 }
638             } else {
639                 revert(errorMessage);
640             }
641         }
642     }
643 }
644 
645 
646 
647 /**
648  * @dev Implementation of the {IERC165} interface.
649  *
650  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
651  * for the additional interface id that will be supported. For example:
652  *
653  * ```solidity
654  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
655  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
656  * }
657  * ```
658  *
659  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
660  */
661 abstract contract ERC165 is IERC165 {
662     /**
663      * @dev See {IERC165-supportsInterface}.
664      */
665     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
666         return interfaceId == type(IERC165).interfaceId;
667     }
668 }
669 
670 
671 
672 
673 
674 
675 
676 
677 error ApprovalCallerNotOwnerNorApproved();
678 error ApprovalQueryForNonexistentToken();
679 error ApproveToCaller();
680 error ApprovalToCurrentOwner();
681 error BalanceQueryForZeroAddress();
682 error MintToZeroAddress();
683 error MintZeroQuantity();
684 error OwnerQueryForNonexistentToken();
685 error TransferCallerNotOwnerNorApproved();
686 error TransferFromIncorrectOwner();
687 error TransferToNonERC721ReceiverImplementer();
688 error TransferToZeroAddress();
689 error URIQueryForNonexistentToken();
690 
691 /**
692  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
693  * the Metadata extension. Built to optimize for lower gas during batch mints.
694  *
695  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
696  *
697  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
698  *
699  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
700  */
701 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
702     using Address for address;
703     using Strings for uint256;
704 
705     // Compiler will pack this into a single 256bit word.
706     struct TokenOwnership {
707         // The address of the owner.
708         address addr;
709         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
710         uint64 startTimestamp;
711         // Whether the token has been burned.
712         bool burned;
713     }
714 
715     // Compiler will pack this into a single 256bit word.
716     struct AddressData {
717         // Realistically, 2**64-1 is more than enough.
718         uint64 balance;
719         // Keeps track of mint count with minimal overhead for tokenomics.
720         uint64 numberMinted;
721         // Keeps track of burn count with minimal overhead for tokenomics.
722         uint64 numberBurned;
723         // For miscellaneous variable(s) pertaining to the address
724         // (e.g. number of whitelist mint slots used).
725         // If there are multiple variables, please pack them into a uint64.
726         uint64 aux;
727     }
728 
729     // The tokenId of the next token to be minted.
730     uint256 internal _currentIndex;
731 
732     // The number of tokens burned.
733     uint256 internal _burnCounter;
734 
735     // Token name
736     string private _name;
737 
738     // Token symbol
739     string private _symbol;
740 
741     // Mapping from token ID to ownership details
742     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
743     mapping(uint256 => TokenOwnership) internal _ownerships;
744 
745     // Mapping owner address to address data
746     mapping(address => AddressData) private _addressData;
747 
748     // Mapping from token ID to approved address
749     mapping(uint256 => address) private _tokenApprovals;
750 
751     // Mapping from owner to operator approvals
752     mapping(address => mapping(address => bool)) private _operatorApprovals;
753 
754     constructor(string memory name_, string memory symbol_) {
755         _name = name_;
756         _symbol = symbol_;
757         _currentIndex = _startTokenId();
758     }
759 
760     /**
761      * To change the starting tokenId, please override this function.
762      */
763     function _startTokenId() internal view virtual returns (uint256) {
764         return 0;
765     }
766 
767     /**
768      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
769      */
770     function totalSupply() public view returns (uint256) {
771         // Counter underflow is impossible as _burnCounter cannot be incremented
772         // more than _currentIndex - _startTokenId() times
773         unchecked {
774             return _currentIndex - _burnCounter - _startTokenId();
775         }
776     }
777 
778     /**
779      * Returns the total amount of tokens minted in the contract.
780      */
781     function _totalMinted() internal view returns (uint256) {
782         // Counter underflow is impossible as _currentIndex does not decrement,
783         // and it is initialized to _startTokenId()
784         unchecked {
785             return _currentIndex - _startTokenId();
786         }
787     }
788 
789     /**
790      * @dev See {IERC165-supportsInterface}.
791      */
792     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
793         return
794             interfaceId == type(IERC721).interfaceId ||
795             interfaceId == type(IERC721Metadata).interfaceId ||
796             super.supportsInterface(interfaceId);
797     }
798 
799     /**
800      * @dev See {IERC721-balanceOf}.
801      */
802     function balanceOf(address owner) public view override returns (uint256) {
803         if (owner == address(0)) revert BalanceQueryForZeroAddress();
804         return uint256(_addressData[owner].balance);
805     }
806 
807     /**
808      * Returns the number of tokens minted by `owner`.
809      */
810     function _numberMinted(address owner) internal view returns (uint256) {
811         return uint256(_addressData[owner].numberMinted);
812     }
813 
814     /**
815      * Returns the number of tokens burned by or on behalf of `owner`.
816      */
817     function _numberBurned(address owner) internal view returns (uint256) {
818         return uint256(_addressData[owner].numberBurned);
819     }
820 
821     /**
822      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
823      */
824     function _getAux(address owner) internal view returns (uint64) {
825         return _addressData[owner].aux;
826     }
827 
828     /**
829      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
830      * If there are multiple variables, please pack them into a uint64.
831      */
832     function _setAux(address owner, uint64 aux) internal {
833         _addressData[owner].aux = aux;
834     }
835 
836     /**
837      * Gas spent here starts off proportional to the maximum mint batch size.
838      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
839      */
840     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
841         uint256 curr = tokenId;
842 
843         unchecked {
844             if (_startTokenId() <= curr && curr < _currentIndex) {
845                 TokenOwnership memory ownership = _ownerships[curr];
846                 if (!ownership.burned) {
847                     if (ownership.addr != address(0)) {
848                         return ownership;
849                     }
850                     // Invariant:
851                     // There will always be an ownership that has an address and is not burned
852                     // before an ownership that does not have an address and is not burned.
853                     // Hence, curr will not underflow.
854                     while (true) {
855                         curr--;
856                         ownership = _ownerships[curr];
857                         if (ownership.addr != address(0)) {
858                             return ownership;
859                         }
860                     }
861                 }
862             }
863         }
864         revert OwnerQueryForNonexistentToken();
865     }
866 
867     /**
868      * @dev See {IERC721-ownerOf}.
869      */
870     function ownerOf(uint256 tokenId) public view override returns (address) {
871         return _ownershipOf(tokenId).addr;
872     }
873 
874     /**
875      * @dev See {IERC721Metadata-name}.
876      */
877     function name() public view virtual override returns (string memory) {
878         return _name;
879     }
880 
881     /**
882      * @dev See {IERC721Metadata-symbol}.
883      */
884     function symbol() public view virtual override returns (string memory) {
885         return _symbol;
886     }
887 
888     /**
889      * @dev See {IERC721Metadata-tokenURI}.
890      */
891     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
892         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
893 
894         string memory baseURI = _baseURI();
895         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
896     }
897 
898     /**
899      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
900      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
901      * by default, can be overriden in child contracts.
902      */
903     function _baseURI() internal view virtual returns (string memory) {
904         return '';
905     }
906 
907     /**
908      * @dev See {IERC721-approve}.
909      */
910     function approve(address to, uint256 tokenId) public override {
911         address owner = ERC721A.ownerOf(tokenId);
912         if (to == owner) revert ApprovalToCurrentOwner();
913 
914         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
915             revert ApprovalCallerNotOwnerNorApproved();
916         }
917 
918         _approve(to, tokenId, owner);
919     }
920 
921     /**
922      * @dev See {IERC721-getApproved}.
923      */
924     function getApproved(uint256 tokenId) public view override returns (address) {
925         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
926 
927         return _tokenApprovals[tokenId];
928     }
929 
930     /**
931      * @dev See {IERC721-setApprovalForAll}.
932      */
933     function setApprovalForAll(address operator, bool approved) public virtual override {
934         if (operator == _msgSender()) revert ApproveToCaller();
935 
936         _operatorApprovals[_msgSender()][operator] = approved;
937         emit ApprovalForAll(_msgSender(), operator, approved);
938     }
939 
940     /**
941      * @dev See {IERC721-isApprovedForAll}.
942      */
943     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
944         return _operatorApprovals[owner][operator];
945     }
946 
947     /**
948      * @dev See {IERC721-transferFrom}.
949      */
950     function transferFrom(
951         address from,
952         address to,
953         uint256 tokenId
954     ) public virtual override {
955         _transfer(from, to, tokenId);
956     }
957 
958     /**
959      * @dev See {IERC721-safeTransferFrom}.
960      */
961     function safeTransferFrom(
962         address from,
963         address to,
964         uint256 tokenId
965     ) public virtual override {
966         safeTransferFrom(from, to, tokenId, '');
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) public virtual override {
978         _transfer(from, to, tokenId);
979         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
980             revert TransferToNonERC721ReceiverImplementer();
981         }
982     }
983 
984     /**
985      * @dev Returns whether `tokenId` exists.
986      *
987      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
988      *
989      * Tokens start existing when they are minted (`_mint`),
990      */
991     function _exists(uint256 tokenId) internal view returns (bool) {
992         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
993     }
994 
995     function _safeMint(address to, uint256 quantity) internal {
996         _safeMint(to, quantity, '');
997     }
998 
999     /**
1000      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1005      * - `quantity` must be greater than 0.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _safeMint(
1010         address to,
1011         uint256 quantity,
1012         bytes memory _data
1013     ) internal {
1014         _mint(to, quantity, _data, true);
1015     }
1016 
1017     /**
1018      * @dev Mints `quantity` tokens and transfers them to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `to` cannot be the zero address.
1023      * - `quantity` must be greater than 0.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _mint(
1028         address to,
1029         uint256 quantity,
1030         bytes memory _data,
1031         bool safe
1032     ) internal {
1033         uint256 startTokenId = _currentIndex;
1034         if (to == address(0)) revert MintToZeroAddress();
1035         if (quantity == 0) revert MintZeroQuantity();
1036 
1037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1038 
1039         // Overflows are incredibly unrealistic.
1040         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1041         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1042         unchecked {
1043             _addressData[to].balance += uint64(quantity);
1044             _addressData[to].numberMinted += uint64(quantity);
1045 
1046             _ownerships[startTokenId].addr = to;
1047             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1048 
1049             uint256 updatedIndex = startTokenId;
1050             uint256 end = updatedIndex + quantity;
1051 
1052             if (safe && to.isContract()) {
1053                 do {
1054                     emit Transfer(address(0), to, updatedIndex);
1055                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1056                         revert TransferToNonERC721ReceiverImplementer();
1057                     }
1058                 } while (updatedIndex != end);
1059                 // Reentrancy protection
1060                 if (_currentIndex != startTokenId) revert();
1061             } else {
1062                 do {
1063                     emit Transfer(address(0), to, updatedIndex++);
1064                 } while (updatedIndex != end);
1065             }
1066             _currentIndex = updatedIndex;
1067         }
1068         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `tokenId` token must be owned by `from`.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _transfer(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) private {
1086         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1087 
1088         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1089 
1090         bool isApprovedOrOwner = (_msgSender() == from ||
1091             isApprovedForAll(from, _msgSender()) ||
1092             getApproved(tokenId) == _msgSender());
1093 
1094         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1095         if (to == address(0)) revert TransferToZeroAddress();
1096 
1097         _beforeTokenTransfers(from, to, tokenId, 1);
1098 
1099         // Clear approvals from the previous owner
1100         _approve(address(0), tokenId, from);
1101 
1102         // Underflow of the sender's balance is impossible because we check for
1103         // ownership above and the recipient's balance can't realistically overflow.
1104         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1105         unchecked {
1106             _addressData[from].balance -= 1;
1107             _addressData[to].balance += 1;
1108 
1109             TokenOwnership storage currSlot = _ownerships[tokenId];
1110             currSlot.addr = to;
1111             currSlot.startTimestamp = uint64(block.timestamp);
1112 
1113             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1114             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1115             uint256 nextTokenId = tokenId + 1;
1116             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1117             if (nextSlot.addr == address(0)) {
1118                 // This will suffice for checking _exists(nextTokenId),
1119                 // as a burned slot cannot contain the zero address.
1120                 if (nextTokenId != _currentIndex) {
1121                     nextSlot.addr = from;
1122                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1123                 }
1124             }
1125         }
1126 
1127         emit Transfer(from, to, tokenId);
1128         _afterTokenTransfers(from, to, tokenId, 1);
1129     }
1130 
1131     /**
1132      * @dev This is equivalent to _burn(tokenId, false)
1133      */
1134     function _burn(uint256 tokenId) internal virtual {
1135         _burn(tokenId, false);
1136     }
1137 
1138     /**
1139      * @dev Destroys `tokenId`.
1140      * The approval is cleared when the token is burned.
1141      *
1142      * Requirements:
1143      *
1144      * - `tokenId` must exist.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1149         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1150 
1151         address from = prevOwnership.addr;
1152 
1153         if (approvalCheck) {
1154             bool isApprovedOrOwner = (_msgSender() == from ||
1155                 isApprovedForAll(from, _msgSender()) ||
1156                 getApproved(tokenId) == _msgSender());
1157 
1158             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1159         }
1160 
1161         _beforeTokenTransfers(from, address(0), tokenId, 1);
1162 
1163         // Clear approvals from the previous owner
1164         _approve(address(0), tokenId, from);
1165 
1166         // Underflow of the sender's balance is impossible because we check for
1167         // ownership above and the recipient's balance can't realistically overflow.
1168         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1169         unchecked {
1170             AddressData storage addressData = _addressData[from];
1171             addressData.balance -= 1;
1172             addressData.numberBurned += 1;
1173 
1174             // Keep track of who burned the token, and the timestamp of burning.
1175             TokenOwnership storage currSlot = _ownerships[tokenId];
1176             currSlot.addr = from;
1177             currSlot.startTimestamp = uint64(block.timestamp);
1178             currSlot.burned = true;
1179 
1180             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1181             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1182             uint256 nextTokenId = tokenId + 1;
1183             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1184             if (nextSlot.addr == address(0)) {
1185                 // This will suffice for checking _exists(nextTokenId),
1186                 // as a burned slot cannot contain the zero address.
1187                 if (nextTokenId != _currentIndex) {
1188                     nextSlot.addr = from;
1189                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1190                 }
1191             }
1192         }
1193 
1194         emit Transfer(from, address(0), tokenId);
1195         _afterTokenTransfers(from, address(0), tokenId, 1);
1196 
1197         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1198         unchecked {
1199             _burnCounter++;
1200         }
1201     }
1202 
1203     /**
1204      * @dev Approve `to` to operate on `tokenId`
1205      *
1206      * Emits a {Approval} event.
1207      */
1208     function _approve(
1209         address to,
1210         uint256 tokenId,
1211         address owner
1212     ) private {
1213         _tokenApprovals[tokenId] = to;
1214         emit Approval(owner, to, tokenId);
1215     }
1216 
1217     /**
1218      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1219      *
1220      * @param from address representing the previous owner of the given token ID
1221      * @param to target address that will receive the tokens
1222      * @param tokenId uint256 ID of the token to be transferred
1223      * @param _data bytes optional data to send along with the call
1224      * @return bool whether the call correctly returned the expected magic value
1225      */
1226     function _checkContractOnERC721Received(
1227         address from,
1228         address to,
1229         uint256 tokenId,
1230         bytes memory _data
1231     ) private returns (bool) {
1232         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1233             return retval == IERC721Receiver(to).onERC721Received.selector;
1234         } catch (bytes memory reason) {
1235             if (reason.length == 0) {
1236                 revert TransferToNonERC721ReceiverImplementer();
1237             } else {
1238                 assembly {
1239                     revert(add(32, reason), mload(reason))
1240                 }
1241             }
1242         }
1243     }
1244 
1245     /**
1246      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1247      * And also called before burning one token.
1248      *
1249      * startTokenId - the first token id to be transferred
1250      * quantity - the amount to be transferred
1251      *
1252      * Calling conditions:
1253      *
1254      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1255      * transferred to `to`.
1256      * - When `from` is zero, `tokenId` will be minted for `to`.
1257      * - When `to` is zero, `tokenId` will be burned by `from`.
1258      * - `from` and `to` are never both zero.
1259      */
1260     function _beforeTokenTransfers(
1261         address from,
1262         address to,
1263         uint256 startTokenId,
1264         uint256 quantity
1265     ) internal virtual {}
1266 
1267     /**
1268      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1269      * minting.
1270      * And also called after one token has been burned.
1271      *
1272      * startTokenId - the first token id to be transferred
1273      * quantity - the amount to be transferred
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` has been minted for `to`.
1280      * - When `to` is zero, `tokenId` has been burned by `from`.
1281      * - `from` and `to` are never both zero.
1282      */
1283     function _afterTokenTransfers(
1284         address from,
1285         address to,
1286         uint256 startTokenId,
1287         uint256 quantity
1288     ) internal virtual {}
1289 }
1290 
1291 
1292 
1293 
1294 contract FC is ERC721A, Ownable {
1295     using Strings for uint256;
1296     uint256 public constant FREE_SUPPLY = 6666;
1297     Stage public stage = Stage.Start;
1298     string public baseURI;
1299     string internal baseExtension = ".json";
1300     uint256 freeSupply;
1301     enum Stage {
1302         Pause,
1303         Start
1304     }
1305 
1306     event StageChanged(Stage from, Stage to);
1307 
1308     constructor() ERC721A("Fortune Cat", "FC") {}
1309 
1310     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1311         require(_exists(tokenId), "FC: not exist");
1312         string memory currentBaseURI = _baseURI();
1313         return (
1314             bytes(currentBaseURI).length > 0
1315                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1316                 : ""
1317         );
1318     }
1319 
1320     function _baseURI() internal view virtual override returns (string memory) {
1321         return baseURI;
1322     }
1323 
1324     function setStage(Stage _stage) external onlyOwner {
1325         require(stage != _stage, "FC: invalid stage.");
1326         Stage prevStage = stage;
1327         stage = _stage;
1328         emit StageChanged(prevStage, stage);
1329     }
1330 
1331 
1332     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1333         baseURI = _newBaseURI;
1334     }
1335 
1336     function freeMint() external {
1337         require(stage == Stage.Start, "FC: mint is pause.");
1338         require(freeSupply < FREE_SUPPLY, "FC: free mint complete.");
1339         freeSupply += 1;
1340         _safeMint(msg.sender, 1);
1341     }
1342 
1343     function setBaseExtension(string memory _extension) external onlyOwner {
1344         baseExtension = _extension;
1345     }
1346 
1347     function withdrawAll() external onlyOwner {
1348         uint256 balance = address(this).balance;
1349         require(balance > 0, "No money");
1350         (bool success, ) = payable(msg.sender).call{value: balance}("");
1351         require(success, "Transfer failed");
1352     }
1353 }