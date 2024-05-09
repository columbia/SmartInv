1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module that helps prevent reentrant calls to a function.
31  *
32  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
33  * available, which can be applied to functions to make sure there are no nested
34  * (reentrant) calls to them.
35  *
36  * Note that because there is a single `nonReentrant` guard, functions marked as
37  * `nonReentrant` may not call one another. This can be worked around by making
38  * those functions `private`, and then adding `external` `nonReentrant` entry
39  * points to them.
40  *
41  * TIP: If you would like to learn more about reentrancy and alternative ways
42  * to protect against it, check out our blog post
43  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
44  */
45 abstract contract ReentrancyGuard {
46     // Booleans are more expensive than uint256 or any type that takes up a full
47     // word because each write operation emits an extra SLOAD to first read the
48     // slot's contents, replace the bits taken up by the boolean, and then write
49     // back. This is the compiler's defense against contract upgrades and
50     // pointer aliasing, and it cannot be disabled.
51 
52     // The values being non-zero value makes deployment a bit more expensive,
53     // but in exchange the refund on every call to nonReentrant will be lower in
54     // amount. Since refunds are capped to a percentage of the total
55     // transaction's gas, it is best to keep them low in cases like this one, to
56     // increase the likelihood of the full refund coming into effect.
57     uint256 private constant _NOT_ENTERED = 1;
58     uint256 private constant _ENTERED = 2;
59 
60     uint256 private _status;
61 
62     constructor () {
63         _status = _NOT_ENTERED;
64     }
65 
66     /**
67      * @dev Prevents a contract from calling itself, directly or indirectly.
68      * Calling a `nonReentrant` function from another `nonReentrant`
69      * function is not supported. It is possible to prevent this from happening
70      * by making the `nonReentrant` function external, and make it call a
71      * `private` function that does the actual work.
72      */
73     modifier nonReentrant() {
74         // On the first call to nonReentrant, _notEntered will be true
75         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
76 
77         // Any calls to nonReentrant after this point will fail
78         _status = _ENTERED;
79 
80         _;
81 
82         // By storing the original value once again, a refund is triggered (see
83         // https://eips.ethereum.org/EIPS/eip-2200)
84         _status = _NOT_ENTERED;
85     }
86 }
87 
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Contract module which provides a basic access control mechanism, where
93  * there is an account (an owner) that can be granted exclusive access to
94  * specific functions.
95  *
96  * By default, the owner account will be the one that deploys the contract. This
97  * can later be changed with {transferOwnership}.
98  *
99  * This module is used through inheritance. It will make available the modifier
100  * `onlyOwner`, which can be applied to your functions to restrict their use to
101  * the owner.
102  */
103 abstract contract Ownable is Context {
104     address private _owner;
105 
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     /**
109      * @dev Initializes the contract setting the deployer as the initial owner.
110      */
111     constructor () {
112         address msgSender = _msgSender();
113         _owner = msgSender;
114         emit OwnershipTransferred(address(0), msgSender);
115     }
116 
117     /**
118      * @dev Returns the address of the current owner.
119      */
120     function owner() public view virtual returns (address) {
121         return _owner;
122     }
123 
124     /**
125      * @dev Throws if called by any account other than the owner.
126      */
127     modifier onlyOwner() {
128         require(owner() == _msgSender(), "Ownable: caller is not the owner");
129         _;
130     }
131 
132     /**
133      * @dev Leaves the contract without owner. It will not be possible to call
134      * `onlyOwner` functions anymore. Can only be called by the current owner.
135      *
136      * NOTE: Renouncing ownership will leave the contract without an owner,
137      * thereby removing any functionality that is only available to the owner.
138      */
139     function renounceOwnership() public virtual onlyOwner {
140         emit OwnershipTransferred(_owner, address(0));
141         _owner = address(0);
142     }
143 
144     /**
145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
146      * Can only be called by the current owner.
147      */
148     function transferOwnership(address newOwner) public virtual onlyOwner {
149         require(newOwner != address(0), "Ownable: new owner is the zero address");
150         emit OwnershipTransferred(_owner, newOwner);
151         _owner = newOwner;
152     }
153 }
154 
155 
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev Interface of the ERC165 standard, as defined in the
161  * https://eips.ethereum.org/EIPS/eip-165[EIP].
162  *
163  * Implementers can declare support of contract interfaces, which can then be
164  * queried by others ({ERC165Checker}).
165  *
166  * For an implementation, see {ERC165}.
167  */
168 interface IERC165 {
169     /**
170      * @dev Returns true if this contract implements the interface defined by
171      * `interfaceId`. See the corresponding
172      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
173      * to learn more about how these ids are created.
174      *
175      * This function call must use less than 30 000 gas.
176      */
177     function supportsInterface(bytes4 interfaceId) external view returns (bool);
178 }
179 
180 
181 pragma solidity ^0.8.0;
182 
183 /**
184  * @title ERC721 token receiver interface
185  * @dev Interface for any contract that wants to support safeTransfers
186  * from ERC721 asset contracts.
187  */
188 interface IERC721Receiver {
189     /**
190      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
191      * by `operator` from `from`, this function is called.
192      *
193      * It must return its Solidity selector to confirm the token transfer.
194      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
195      *
196      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
197      */
198     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
199 }
200 
201 
202 pragma solidity ^0.8.0;
203 
204 
205 /**
206  * @dev Required interface of an ERC721 compliant contract.
207  */
208 interface IERC721 is IERC165 {
209     /**
210      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
211      */
212     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
213 
214     /**
215      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
216      */
217     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
218 
219     /**
220      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
221      */
222     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
223 
224     /**
225      * @dev Returns the number of tokens in ``owner``'s account.
226      */
227     function balanceOf(address owner) external view returns (uint256 balance);
228 
229     /**
230      * @dev Returns the owner of the `tokenId` token.
231      *
232      * Requirements:
233      *
234      * - `tokenId` must exist.
235      */
236     function ownerOf(uint256 tokenId) external view returns (address owner);
237 
238     /**
239      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
240      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(address from, address to, uint256 tokenId) external;
253 
254     /**
255      * @dev Transfers `tokenId` token from `from` to `to`.
256      *
257      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
258      *
259      * Requirements:
260      *
261      * - `from` cannot be the zero address.
262      * - `to` cannot be the zero address.
263      * - `tokenId` token must be owned by `from`.
264      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transferFrom(address from, address to, uint256 tokenId) external;
269 
270     /**
271      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
272      * The approval is cleared when the token is transferred.
273      *
274      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
275      *
276      * Requirements:
277      *
278      * - The caller must own the token or be an approved operator.
279      * - `tokenId` must exist.
280      *
281      * Emits an {Approval} event.
282      */
283     function approve(address to, uint256 tokenId) external;
284 
285     /**
286      * @dev Returns the account approved for `tokenId` token.
287      *
288      * Requirements:
289      *
290      * - `tokenId` must exist.
291      */
292     function getApproved(uint256 tokenId) external view returns (address operator);
293 
294     /**
295      * @dev Approve or remove `operator` as an operator for the caller.
296      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
297      *
298      * Requirements:
299      *
300      * - The `operator` cannot be the caller.
301      *
302      * Emits an {ApprovalForAll} event.
303      */
304     function setApprovalForAll(address operator, bool _approved) external;
305 
306     /**
307      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
308      *
309      * See {setApprovalForAll}
310      */
311     function isApprovedForAll(address owner, address operator) external view returns (bool);
312 
313     /**
314       * @dev Safely transfers `tokenId` token from `from` to `to`.
315       *
316       * Requirements:
317       *
318       * - `from` cannot be the zero address.
319       * - `to` cannot be the zero address.
320       * - `tokenId` token must exist and be owned by `from`.
321       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
322       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
323       *
324       * Emits a {Transfer} event.
325       */
326     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
327 }
328 
329 
330 pragma solidity ^0.8.0;
331 
332 
333 /**
334  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
335  * @dev See https://eips.ethereum.org/EIPS/eip-721
336  */
337 interface IERC721Metadata is IERC721 {
338 
339     /**
340      * @dev Returns the token collection name.
341      */
342     function name() external view returns (string memory);
343 
344     /**
345      * @dev Returns the token collection symbol.
346      */
347     function symbol() external view returns (string memory);
348 
349     /**
350      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
351      */
352     function tokenURI(uint256 tokenId) external view returns (string memory);
353 }
354 
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
361  * @dev See https://eips.ethereum.org/EIPS/eip-721
362  */
363 interface IERC721Enumerable is IERC721 {
364 
365     /**
366      * @dev Returns the total amount of tokens stored by the contract.
367      */
368     function totalSupply() external view returns (uint256);
369 
370     /**
371      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
372      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
373      */
374     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
375 
376     /**
377      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
378      * Use along with {totalSupply} to enumerate all tokens.
379      */
380     function tokenByIndex(uint256 index) external view returns (uint256);
381 }
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Collection of functions related to the address type
387  */
388 library Address {
389     /**
390      * @dev Returns true if `account` is a contract.
391      *
392      * [IMPORTANT]
393      * ====
394      * It is unsafe to assume that an address for which this function returns
395      * false is an externally-owned account (EOA) and not a contract.
396      *
397      * Among others, `isContract` will return false for the following
398      * types of addresses:
399      *
400      *  - an externally-owned account
401      *  - a contract in construction
402      *  - an address where a contract will be created
403      *  - an address where a contract lived, but was destroyed
404      * ====
405      */
406     function isContract(address account) internal view returns (bool) {
407         // This method relies on extcodesize, which returns 0 for contracts in
408         // construction, since the code is only stored at the end of the
409         // constructor execution.
410 
411         uint256 size;
412         // solhint-disable-next-line no-inline-assembly
413         assembly { size := extcodesize(account) }
414         return size > 0;
415     }
416 
417     /**
418      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
419      * `recipient`, forwarding all available gas and reverting on errors.
420      *
421      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
422      * of certain opcodes, possibly making contracts go over the 2300 gas limit
423      * imposed by `transfer`, making them unable to receive funds via
424      * `transfer`. {sendValue} removes this limitation.
425      *
426      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
427      *
428      * IMPORTANT: because control is transferred to `recipient`, care must be
429      * taken to not create reentrancy vulnerabilities. Consider using
430      * {ReentrancyGuard} or the
431      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
432      */
433     function sendValue(address payable recipient, uint256 amount) internal {
434         require(address(this).balance >= amount, "Address: insufficient balance");
435 
436         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
437         (bool success, ) = recipient.call{ value: amount }("");
438         require(success, "Address: unable to send value, recipient may have reverted");
439     }
440 
441     /**
442      * @dev Performs a Solidity function call using a low level `call`. A
443      * plain`call` is an unsafe replacement for a function call: use this
444      * function instead.
445      *
446      * If `target` reverts with a revert reason, it is bubbled up by this
447      * function (like regular Solidity function calls).
448      *
449      * Returns the raw returned data. To convert to the expected return value,
450      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
451      *
452      * Requirements:
453      *
454      * - `target` must be a contract.
455      * - calling `target` with `data` must not revert.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
460       return functionCall(target, data, "Address: low-level call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
465      * `errorMessage` as a fallback revert reason when `target` reverts.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
470         return functionCallWithValue(target, data, 0, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but also transferring `value` wei to `target`.
476      *
477      * Requirements:
478      *
479      * - the calling contract must have an ETH balance of at least `value`.
480      * - the called Solidity function must be `payable`.
481      *
482      * _Available since v3.1._
483      */
484     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
485         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
490      * with `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
495         require(address(this).balance >= value, "Address: insufficient balance for call");
496         require(isContract(target), "Address: call to non-contract");
497 
498         // solhint-disable-next-line avoid-low-level-calls
499         (bool success, bytes memory returndata) = target.call{ value: value }(data);
500         return _verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
510         return functionStaticCall(target, data, "Address: low-level static call failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
515      * but performing a static call.
516      *
517      * _Available since v3.3._
518      */
519     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
520         require(isContract(target), "Address: static call to non-contract");
521 
522         // solhint-disable-next-line avoid-low-level-calls
523         (bool success, bytes memory returndata) = target.staticcall(data);
524         return _verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but performing a delegate call.
530      *
531      * _Available since v3.4._
532      */
533     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
534         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
539      * but performing a delegate call.
540      *
541      * _Available since v3.4._
542      */
543     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
544         require(isContract(target), "Address: delegate call to non-contract");
545 
546         // solhint-disable-next-line avoid-low-level-calls
547         (bool success, bytes memory returndata) = target.delegatecall(data);
548         return _verifyCallResult(success, returndata, errorMessage);
549     }
550 
551     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
552         if (success) {
553             return returndata;
554         } else {
555             // Look for revert reason and bubble it up if present
556             if (returndata.length > 0) {
557                 // The easiest way to bubble the revert reason is using memory via assembly
558 
559                 // solhint-disable-next-line no-inline-assembly
560                 assembly {
561                     let returndata_size := mload(returndata)
562                     revert(add(32, returndata), returndata_size)
563                 }
564             } else {
565                 revert(errorMessage);
566             }
567         }
568     }
569 }
570 
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev String operations.
576  */
577 library Strings {
578     bytes16 private constant alphabet = "0123456789abcdef";
579 
580     /**
581      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
582      */
583     function toString(uint256 value) internal pure returns (string memory) {
584         // Inspired by OraclizeAPI's implementation - MIT licence
585         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
586 
587         if (value == 0) {
588             return "0";
589         }
590         uint256 temp = value;
591         uint256 digits;
592         while (temp != 0) {
593             digits++;
594             temp /= 10;
595         }
596         bytes memory buffer = new bytes(digits);
597         while (value != 0) {
598             digits -= 1;
599             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
600             value /= 10;
601         }
602         return string(buffer);
603     }
604 
605     /**
606      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
607      */
608     function toHexString(uint256 value) internal pure returns (string memory) {
609         if (value == 0) {
610             return "0x00";
611         }
612         uint256 temp = value;
613         uint256 length = 0;
614         while (temp != 0) {
615             length++;
616             temp >>= 8;
617         }
618         return toHexString(value, length);
619     }
620 
621     /**
622      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
623      */
624     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
625         bytes memory buffer = new bytes(2 * length + 2);
626         buffer[0] = "0";
627         buffer[1] = "x";
628         for (uint256 i = 2 * length + 1; i > 1; --i) {
629             buffer[i] = alphabet[value & 0xf];
630             value >>= 4;
631         }
632         require(value == 0, "Strings: hex length insufficient");
633         return string(buffer);
634     }
635 
636 }
637 
638 
639 
640 pragma solidity ^0.8.0;
641 
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
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
673  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
674  *
675  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
676  *
677  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
678  *
679  * Does not support burning tokens to address(0).
680  */
681 contract ERC721A is
682     Context,
683     ERC165,
684     IERC721,
685     IERC721Metadata,
686     IERC721Enumerable
687 {
688     using Address for address;
689     using Strings for uint256;
690 
691     struct TokenOwnership {
692         address addr;
693         uint64 startTimestamp;
694     }
695 
696     struct AddressData {
697         uint128 balance;
698         uint128 numberMinted;
699     }
700 
701     uint256 private currentIndex = 0;
702 
703     uint256 internal immutable collectionSize;
704     uint256 internal immutable maxBatchSize;
705 
706     // Token name
707     string private _name;
708 
709     // Token symbol
710     string private _symbol;
711 
712     // Mapping from token ID to ownership details
713     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
714     mapping(uint256 => TokenOwnership) private _ownerships;
715 
716     // Mapping owner address to address data
717     mapping(address => AddressData) private _addressData;
718 
719     // Mapping from token ID to approved address
720     mapping(uint256 => address) private _tokenApprovals;
721 
722     // Mapping from owner to operator approvals
723     mapping(address => mapping(address => bool)) private _operatorApprovals;
724 
725     /**
726      * @dev
727      * `maxBatchSize` refers to how much a minter can mint at a time.
728      * `collectionSize_` refers to how many tokens are in the collection.
729      */
730     constructor(
731         string memory name_,
732         string memory symbol_,
733         uint256 maxBatchSize_,
734         uint256 collectionSize_
735     ) {
736         require(
737             collectionSize_ > 0,
738             "ERC721A: collection must have a nonzero supply"
739         );
740         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
741         _name = name_;
742         _symbol = symbol_;
743         maxBatchSize = maxBatchSize_;
744         collectionSize = collectionSize_;
745     }
746 
747     /**
748      * @dev See {IERC721Enumerable-totalSupply}.
749      */
750     function totalSupply() public view override returns (uint256) {
751         return currentIndex;
752     }
753 
754     /**
755      * @dev See {IERC721Enumerable-tokenByIndex}.
756      */
757     function tokenByIndex(uint256 index)
758         public
759         view
760         override
761         returns (uint256)
762     {
763         require(index < totalSupply(), "ERC721A: global index out of bounds");
764         return index;
765     }
766 
767     /**
768      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
769      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
770      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
771      */
772     function tokenOfOwnerByIndex(address owner, uint256 index)
773         public
774         view
775         override
776         returns (uint256)
777     {
778         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
779         uint256 numMintedSoFar = totalSupply();
780         uint256 tokenIdsIdx = 0;
781         address currOwnershipAddr = address(0);
782         for (uint256 i = 0; i < numMintedSoFar; i++) {
783             TokenOwnership memory ownership = _ownerships[i];
784             if (ownership.addr != address(0)) {
785                 currOwnershipAddr = ownership.addr;
786             }
787             if (currOwnershipAddr == owner) {
788                 if (tokenIdsIdx == index) {
789                     return i;
790                 }
791                 tokenIdsIdx++;
792             }
793         }
794         revert("ERC721A: unable to get token of owner by index");
795     }
796 
797     /**
798      * @dev See {IERC165-supportsInterface}.
799      */
800     function supportsInterface(bytes4 interfaceId)
801         public
802         view
803         virtual
804         override(ERC165, IERC165)
805         returns (bool)
806     {
807         return
808             interfaceId == type(IERC721).interfaceId ||
809             interfaceId == type(IERC721Metadata).interfaceId ||
810             interfaceId == type(IERC721Enumerable).interfaceId ||
811             super.supportsInterface(interfaceId);
812     }
813 
814     /**
815      * @dev See {IERC721-balanceOf}.
816      */
817     function balanceOf(address owner) public view override returns (uint256) {
818         require(
819             owner != address(0),
820             "ERC721A: balance query for the zero address"
821         );
822         return uint256(_addressData[owner].balance);
823     }
824 
825     function _numberMinted(address owner) internal view returns (uint256) {
826         require(
827             owner != address(0),
828             "ERC721A: number minted query for the zero address"
829         );
830         return uint256(_addressData[owner].numberMinted);
831     }
832 
833     function ownershipOf(uint256 tokenId)
834         internal
835         view
836         returns (TokenOwnership memory)
837     {
838         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
839 
840         uint256 lowestTokenToCheck;
841         if (tokenId >= maxBatchSize) {
842             lowestTokenToCheck = tokenId - maxBatchSize + 1;
843         }
844 
845         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
846             TokenOwnership memory ownership = _ownerships[curr];
847             if (ownership.addr != address(0)) {
848                 return ownership;
849             }
850         }
851 
852         revert("ERC721A: unable to determine the owner of token");
853     }
854 
855     /**
856      * @dev See {IERC721-ownerOf}.
857      */
858     function ownerOf(uint256 tokenId) public view override returns (address) {
859         return ownershipOf(tokenId).addr;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-name}.
864      */
865     function name() public view virtual override returns (string memory) {
866         return _name;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-symbol}.
871      */
872     function symbol() public view virtual override returns (string memory) {
873         return _symbol;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-tokenURI}.
878      */
879     function tokenURI(uint256 tokenId)
880         public
881         view
882         virtual
883         override
884         returns (string memory)
885     {
886         require(
887             _exists(tokenId),
888             "ERC721Metadata: URI query for nonexistent token"
889         );
890 
891         string memory baseURI = _baseURI();
892         return
893             bytes(baseURI).length > 0
894                 ? string(abi.encodePacked(baseURI))
895                 : "";
896     }
897 
898     /**
899      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
900      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
901      * by default, can be overriden in child contracts.
902      */
903     function _baseURI() internal view virtual returns (string memory) {
904         return "";
905     }
906 
907     /**
908      * @dev See {IERC721-approve}.
909      */
910     function approve(address to, uint256 tokenId) public override {
911         address owner = ERC721A.ownerOf(tokenId);
912         require(to != owner, "ERC721A: approval to current owner");
913 
914         require(
915             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
916             "ERC721A: approve caller is not owner nor approved for all"
917         );
918 
919         _approve(to, tokenId, owner);
920     }
921 
922     /**
923      * @dev See {IERC721-getApproved}.
924      */
925     function getApproved(uint256 tokenId)
926         public
927         view
928         override
929         returns (address)
930     {
931         require(
932             _exists(tokenId),
933             "ERC721A: approved query for nonexistent token"
934         );
935 
936         return _tokenApprovals[tokenId];
937     }
938 
939     /**
940      * @dev See {IERC721-setApprovalForAll}.
941      */
942     function setApprovalForAll(address operator, bool approved)
943         public
944         override
945     {
946         require(operator != _msgSender(), "ERC721A: approve to caller");
947 
948         _operatorApprovals[_msgSender()][operator] = approved;
949         emit ApprovalForAll(_msgSender(), operator, approved);
950     }
951 
952     /**
953      * @dev See {IERC721-isApprovedForAll}.
954      */
955     function isApprovedForAll(address owner, address operator)
956         public
957         view
958         virtual
959         override
960         returns (bool)
961     {
962         return _operatorApprovals[owner][operator];
963     }
964 
965     /**
966      * @dev See {IERC721-transferFrom}.
967      */
968     function transferFrom(
969         address from,
970         address to,
971         uint256 tokenId
972     ) public override {
973         _transfer(from, to, tokenId);
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) public override {
984         safeTransferFrom(from, to, tokenId, "");
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) public override {
996         _transfer(from, to, tokenId);
997         require(
998             _checkOnERC721Received(from, to, tokenId, _data),
999             "ERC721A: transfer to non ERC721Receiver implementer"
1000         );
1001     }
1002 
1003     /**
1004      * @dev Returns whether `tokenId` exists.
1005      *
1006      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1007      *
1008      * Tokens start existing when they are minted (`_mint`),
1009      */
1010     function _exists(uint256 tokenId) internal view returns (bool) {
1011         return tokenId < currentIndex;
1012     }
1013 
1014     function _safeMint(address to, uint256 quantity) internal {
1015         _safeMint(to, quantity, "");
1016     }
1017 
1018     /**
1019      * @dev Mints `quantity` tokens and transfers them to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - there must be `quantity` tokens remaining unminted in the total collection.
1024      * - `to` cannot be the zero address.
1025      * - `quantity` cannot be larger than the max batch size.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _safeMint(
1030         address to,
1031         uint256 quantity,
1032         bytes memory _data
1033     ) internal {
1034         uint256 startTokenId = currentIndex;
1035         require(to != address(0), "ERC721A: mint to the zero address");
1036         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1037         require(!_exists(startTokenId), "ERC721A: token already minted");
1038         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1039 
1040         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1041 
1042         AddressData memory addressData = _addressData[to];
1043         _addressData[to] = AddressData(
1044             addressData.balance + uint128(quantity),
1045             addressData.numberMinted + uint128(quantity)
1046         );
1047         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1048 
1049         uint256 updatedIndex = startTokenId;
1050 
1051         for (uint256 i = 0; i < quantity; i++) {
1052             emit Transfer(address(0), to, updatedIndex);
1053             require(
1054                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1055                 "ERC721A: transfer to non ERC721Receiver implementer"
1056             );
1057             updatedIndex++;
1058         }
1059 
1060         currentIndex = updatedIndex;
1061         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1062     }
1063 
1064     /**
1065      * @dev Transfers `tokenId` from `from` to `to`.
1066      *
1067      * Requirements:
1068      *
1069      * - `to` cannot be the zero address.
1070      * - `tokenId` token must be owned by `from`.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) private {
1079         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1080 
1081         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1082             getApproved(tokenId) == _msgSender() ||
1083             isApprovedForAll(prevOwnership.addr, _msgSender()));
1084 
1085         require(
1086             isApprovedOrOwner,
1087             "ERC721A: transfer caller is not owner nor approved"
1088         );
1089 
1090         require(
1091             prevOwnership.addr == from,
1092             "ERC721A: transfer from incorrect owner"
1093         );
1094         require(to != address(0), "ERC721A: transfer to the zero address");
1095 
1096         _beforeTokenTransfers(from, to, tokenId, 1);
1097 
1098         // Clear approvals from the previous owner
1099         _approve(address(0), tokenId, prevOwnership.addr);
1100 
1101         _addressData[from].balance -= 1;
1102         _addressData[to].balance += 1;
1103         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1104 
1105         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1106         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1107         uint256 nextTokenId = tokenId + 1;
1108         if (_ownerships[nextTokenId].addr == address(0)) {
1109             if (_exists(nextTokenId)) {
1110                 _ownerships[nextTokenId] = TokenOwnership(
1111                     prevOwnership.addr,
1112                     prevOwnership.startTimestamp
1113                 );
1114             }
1115         }
1116 
1117         emit Transfer(from, to, tokenId);
1118         _afterTokenTransfers(from, to, tokenId, 1);
1119     }
1120 
1121     /**
1122      * @dev Approve `to` to operate on `tokenId`
1123      *
1124      * Emits a {Approval} event.
1125      */
1126     function _approve(
1127         address to,
1128         uint256 tokenId,
1129         address owner
1130     ) private {
1131         _tokenApprovals[tokenId] = to;
1132         emit Approval(owner, to, tokenId);
1133     }
1134 
1135     uint256 public nextOwnerToExplicitlySet = 0;
1136 
1137     /**
1138      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1139      */
1140     function _setOwnersExplicit(uint256 quantity) internal {
1141         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1142         require(quantity > 0, "quantity must be nonzero");
1143         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1144         if (endIndex > collectionSize - 1) {
1145             endIndex = collectionSize - 1;
1146         }
1147         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1148         require(_exists(endIndex), "not enough minted yet for this cleanup");
1149         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1150             if (_ownerships[i].addr == address(0)) {
1151                 TokenOwnership memory ownership = ownershipOf(i);
1152                 _ownerships[i] = TokenOwnership(
1153                     ownership.addr,
1154                     ownership.startTimestamp
1155                 );
1156             }
1157         }
1158         nextOwnerToExplicitlySet = endIndex + 1;
1159     }
1160 
1161     /**
1162      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1163      * The call is not executed if the target address is not a contract.
1164      *
1165      * @param from address representing the previous owner of the given token ID
1166      * @param to target address that will receive the tokens
1167      * @param tokenId uint256 ID of the token to be transferred
1168      * @param _data bytes optional data to send along with the call
1169      * @return bool whether the call correctly returned the expected magic value
1170      */
1171     function _checkOnERC721Received(
1172         address from,
1173         address to,
1174         uint256 tokenId,
1175         bytes memory _data
1176     ) private returns (bool) {
1177         if (to.isContract()) {
1178             try
1179                 IERC721Receiver(to).onERC721Received(
1180                     _msgSender(),
1181                     from,
1182                     tokenId,
1183                     _data
1184                 )
1185             returns (bytes4 retval) {
1186                 return retval == IERC721Receiver(to).onERC721Received.selector;
1187             } catch (bytes memory reason) {
1188                 if (reason.length == 0) {
1189                     revert(
1190                         "ERC721A: transfer to non ERC721Receiver implementer"
1191                     );
1192                 } else {
1193                     assembly {
1194                         revert(add(32, reason), mload(reason))
1195                     }
1196                 }
1197             }
1198         } else {
1199             return true;
1200         }
1201     }
1202 
1203     /**
1204      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1205      *
1206      * startTokenId - the first token id to be transferred
1207      * quantity - the amount to be transferred
1208      *
1209      * Calling conditions:
1210      *
1211      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1212      * transferred to `to`.
1213      * - When `from` is zero, `tokenId` will be minted for `to`.
1214      */
1215     function _beforeTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 
1222     /**
1223      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1224      * minting.
1225      *
1226      * startTokenId - the first token id to be transferred
1227      * quantity - the amount to be transferred
1228      *
1229      * Calling conditions:
1230      *
1231      * - when `from` and `to` are both non-zero.
1232      * - `from` and `to` are never both zero.
1233      */
1234     function _afterTokenTransfers(
1235         address from,
1236         address to,
1237         uint256 startTokenId,
1238         uint256 quantity
1239     ) internal virtual {}
1240 }
1241 
1242 
1243 
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 
1248 contract ApeRaffle is ERC721A, Ownable {
1249 
1250     uint256 public apePrice = 42000000000000000;
1251     uint256 public apeWlPrice = 0;
1252     uint public maxApePurchase = 25;
1253     uint public maxWlApePurchase = 1;
1254     uint public ApeSup = 4200;
1255     bool public drop_is_active = false;
1256     bool public presale_is_active = true;
1257     string public baseURI = "https://ipfs.io/ipfs/QmNoKJrk5fLbaG1taXv1sYnuv3APrMsMs9JXYaQqFjTtXU";
1258     uint256 public tokensMinted = 0;
1259 
1260     mapping(address => uint) addressesThatMinted;
1261 
1262     struct Whitelistaddr {
1263         uint256 presalemints;
1264         bool exists;
1265     }
1266     mapping(address => Whitelistaddr) private whitelist;
1267 
1268     constructor() ERC721A("ApeRaffle", "APED",24, 10000){
1269    
1270    whitelist[0xdcf90FDd7EF37178A1dfB414D2Ef028d8681a83B].exists = true;
1271 whitelist[0xE187F9D2abAd356D3Cd84fBb446766CB1dFDe5A4].exists = true;
1272 whitelist[0x56ae97EDfdab3b367E8e0DDcdB63A0C4072B96D2].exists = true;
1273 whitelist[0x6099381e17d4Ffb7a2717bb7Ee8067867442aA55].exists = true;
1274 whitelist[0xD9e6E096649e183eB3F51f3A424EA940d4126a07].exists = true;
1275 whitelist[0xea06264f9324c417d633a867B62D5f03e1346418].exists = true;
1276 whitelist[0x77a38728E69098ACB6F6Dc343a69ad28a4B913a0].exists = true;
1277 whitelist[0x5ED2698484c888C5701Bc0Af690ccA67F67Bc000].exists = true;
1278 whitelist[0x035f4B090F4fE6a2d95a3e3617ba0FAF8C8322e5].exists = true;
1279 whitelist[0x5382718773076C66198ee1a4fb82c2Ed47B362ED].exists = true;
1280 whitelist[0xd5d1c5daF1Ef2807b4033c169eCc0F7e1CbCdFf9].exists = true;
1281 whitelist[0x2318C512B95404d05b09936DB4836c78054253f7].exists = true;
1282 whitelist[0x6eD487770e3065Ab5Ff038f757AAde4a35601C43].exists = true;
1283 whitelist[0x1B065C320a3f889E57D2dA4C218b1d97e90C609a].exists = true;
1284 whitelist[0xe819D78c8AE7Eb2c3BEBBED6CaCB6f91D6221735].exists = true;
1285 whitelist[0x995484306Fa2833dc37A0cfCCDc237ECD54019e2].exists = true;
1286 whitelist[0x93e4a8D7aA34CAed7669bfbd24037680277D277C].exists = true;
1287 whitelist[0x1329eE6b4DeA88F48ecB25858F911b409847a74e].exists = true;
1288 whitelist[0x6B18fb2248eD2fddD1c639EEC40fEd4A5d596747].exists = true;
1289 whitelist[0x72466e0A114aC95661e2011633759F73Ef77943F].exists = true;
1290 whitelist[0xe4FaDECA360813E6d0AFF959E0f7F256EEA5A26b].exists = true;
1291 whitelist[0xd7cc1a676F987001b9F622adfC50788ad908e505].exists = true;
1292 whitelist[0x64BC4Ed143D0c2043D6A93C1C3214022622b7D6C].exists = true;
1293 whitelist[0x70627c9376F78F4e69b12094c2eEC4d187433340].exists = true;
1294 whitelist[0xf1D6212ee15486a0E1541FD68318a2de4abF872d].exists = true;
1295 whitelist[0xD9393a4EC941E0456Dd51Ce8EA65765C76295366].exists = true;
1296 whitelist[0x6D1DEDAceB920980Ae80e2C901971755296Ca41e].exists = true;
1297 whitelist[0x6F9a0Ab8B1e7098B31031d1b2ca6daD090E2122E].exists = true;
1298 whitelist[0x9BeB2df4Bf7Ddd5f06f7Ac71ecaB0440246278CE].exists = true;
1299 whitelist[0xaF88a198559D08B5932a5dF63b6Be42bE8f96eE1].exists = true;
1300 whitelist[0x0C07747AB98EE84971C90Fbd353eda207B737c43].exists = true;
1301 whitelist[0xB72eDF2669F2b05571aE4eE0E045D5927982b1a9].exists = true;
1302 whitelist[0xA2B48C299A90303E758680E4FdEcE6C0AdC1D588].exists = true;
1303 whitelist[0x974BFb4a344da64Ae216E8c21b70c3235cac7CF8].exists = true;
1304 whitelist[0x36Fa3E52D58A7401Be46353F50667FBf931e4F42].exists = true;
1305 whitelist[0x65960E16ff98732704d8FFc86ff736f5A4a032F2].exists = true;
1306 whitelist[0x0D54d4500FACb7f836868A94daAb41ABdcFAB0A8].exists = true;
1307 whitelist[0x18651bC48BC18110C99332f63BB921Cf0592cA53].exists = true;
1308 whitelist[0xD75301B8Aad060377D616098d91Bbc42054C2074].exists = true;
1309 whitelist[0x21EbFbbb8dF82E20d7130e0A35B1C6A22068380a].exists = true;
1310 whitelist[0x6C8A0db8610F08159d3be7a2bFeCb8624E76aC79].exists = true;
1311 whitelist[0x7AD79B83575BECB692bddF23909b74f1F52503De].exists = true;
1312 whitelist[0x9Baf7C87825e382408a5C17D36af48d3c8A4756B].exists = true;
1313 whitelist[0xE77c2317E7d9170f374A6ce32877E95E91E6AE92].exists = true;
1314 whitelist[0xA3C35f9eb6EB55db0Ab0311749b7D95Ce2B9bC52].exists = true;
1315 whitelist[0x75256484A5f5e56D2c0189ed64Aa7CF4C677E2E6].exists = true;
1316 whitelist[0x63ff0cBf0A777e9c2F84F0386947F0c86B99a939].exists = true;
1317 whitelist[0xAB8782298BB8c647562c8D80c794E6E013852f99].exists = true;
1318 whitelist[0x1cFacf54fcA7A1574666325cDf0F5387db97752a].exists = true;
1319 whitelist[0x66Ce82ab8dc9ce4C93f244E56e7647d81a8a97D5].exists = true;
1320 whitelist[0xE31515776f6CC88F57B6f697f4F5c11D2269e862].exists = true;
1321 whitelist[0x3ef083f9f48B5f3b7734aA582f7BF04cf2D4b173].exists = true;
1322 whitelist[0x5BE48Eb33ecC783CE0dBf17Ce0d392bDC3D1C5de].exists = true;
1323 whitelist[0x97F7c8A4F4734CB893024Ea0fD563CebEEc5B0e2].exists = true;
1324 whitelist[0x973477e108f9e5B4aA61CC5B972015daf3c20f5a].exists = true;
1325 whitelist[0xfebbB48C8f7A67Dc3DcEE19524A410E078e6A6a1].exists = true;
1326 whitelist[0xA15Cee6667054F7cE834c7E5d2a06dBa4454a227].exists = true;
1327 whitelist[0x219C9F6799a890f2093Fa0a87277C976DDc46f2D].exists = true;
1328 whitelist[0xd0aA5209e5B1594215e1450C4e7596bB3066E330].exists = true;
1329 whitelist[0x54A987BB76eB866dc2359D6a7f7B8E160BD48f39].exists = true;
1330 whitelist[0xEB0AADED83e56137a526ed20D66645D6955cA0fb].exists = true;
1331 whitelist[0x2eCC650E73D984DB98c2d239108D2931BdAB7028].exists = true;
1332 whitelist[0x97E054d5C8BAdE27F527b8d76287F78978f1242F].exists = true;
1333 whitelist[0xF96CB1BB32542129b2F2f3248e90252D7291f27F].exists = true;
1334 whitelist[0x441839Ca1653706192D4cc1B1d1698f50108e01b].exists = true;
1335 whitelist[0x8a8117c238f01F7F9AA835BE5735c7B2B33d7315].exists = true;
1336 whitelist[0xd3F332cF93Cb42dBF4f39dF4001f157165eaC1E6].exists = true;
1337 whitelist[0x5100650a6F0d69795Ed52ccCfdD5f6651A18EDed].exists = true;
1338 whitelist[0x027C73dF1f9F1b846bb79c0D23C6c5a5798a747F].exists = true;
1339 whitelist[0x63a5b7C95447E2c1CfbC904932027E19534e63e2].exists = true;
1340 whitelist[0xABA5509bDcAF5D7B97d65a3Bc9aA5261a14119b1].exists = true;
1341 whitelist[0xfB63762F4D921437B09dd1E69cfcc357D3299175].exists = true;
1342 whitelist[0x5F6777cfD0652d7E8C249152fF1B36c721E250eA].exists = true;
1343 whitelist[0x1F1D2A3fa9b32429B709694BEa92192A685eaF72].exists = true;
1344 whitelist[0x18eb9EFBAb54297cb2c75b3eE01F8471a3953571].exists = true;
1345 whitelist[0xDE051A2A43A18F76626296F09207934270EF5D71].exists = true;
1346 whitelist[0x99FD27b7A783a69e71D56C8B1309ee1e158Ba48a].exists = true;
1347 whitelist[0x79E19185F624a861051be468cc137Ab1e90539a9].exists = true;
1348 whitelist[0x95e122628A0f323598460A071555c38cdc46fe00].exists = true;
1349 whitelist[0xb342eFb33f6AeA4184bF0917b3883d4333Fb3950].exists = true;
1350 whitelist[0x454f40135BFfB862559223fb2A8614ddb5977aDD].exists = true;
1351 whitelist[0xfBfc29e19B1E235b3a1B86DD3BE037e9617b1991].exists = true;
1352 whitelist[0xEA771c3aA97fC8DbA614ECf6de91D7B2b595EF1a].exists = true;
1353 whitelist[0xe6723F96A3485783cb89F84C0C53Ea88B0410a17].exists = true;
1354 whitelist[0x5F1F88a17BEB89E9B51C8167382569F8F5FB89Af].exists = true;
1355 whitelist[0x097bf2c7CDF1543238e88abd675A26cde1aa3259].exists = true;
1356 whitelist[0xc74b35a30e6CEf0a0c7dAE582b87200285C2af6b].exists = true;
1357 whitelist[0x9d509C23f0170760920FDf24D0315e7E70903fC6].exists = true;
1358 whitelist[0x29146D7c15d94f19fb92863b80898ca93a659C54].exists = true;
1359 whitelist[0x626f1Ceb00a2112f1dEfBb1ebF9EFdb98d88830f].exists = true;
1360 whitelist[0x0B0237aD59e1BbCb611fdf0c9Fa07350C3f41e87].exists = true;
1361 whitelist[0xD8dBC8Db662B2712c5C9E1e66A961c427a81bE3d].exists = true;
1362 whitelist[0x4e4CC29ab82cf8aa4EcD3578A26409E57793de4b].exists = true;
1363 whitelist[0xd7DFF7399E8F45490c708f5eC1A4a39993B7b4A6].exists = true;
1364 whitelist[0xe973B9fDC98586D0BE196fC5dA93e6D26CE9A899].exists = true;
1365 whitelist[0xcd245Eb87Cce56756BBF4661A5a88999A48d8752].exists = true;
1366 whitelist[0x212Ed9cf16aA66e0DB9b8483E82908659D3f5370].exists = true;
1367 whitelist[0xB5905960c0224d9333fC58eb60E2B57423b18d99].exists = true;
1368 whitelist[0x036D0560582c444ff13d5822e2759A9f1E3D1e1e].exists = true;
1369 whitelist[0xd7125Fec3a9a58EcC15449e124813887b1ea2ecF].exists = true;
1370 whitelist[0xdC18E236e31aB28115E35ebE446ddCf333fE9a58].exists = true;
1371 
1372     }
1373 
1374     function OnWhiteList(address walletaddr)
1375     public
1376     view
1377     returns (bool)
1378     {
1379         if (whitelist[walletaddr].exists){
1380             return true;
1381         }
1382         else{
1383             return false;
1384         }
1385     }
1386 
1387     function addToWhiteList (address[] memory newWalletaddr) public onlyOwner{
1388         for (uint256 i = 0; i<newWalletaddr.length;i++){
1389             whitelist[newWalletaddr[i]].exists = true;
1390         }        
1391     }
1392 
1393     function withdraw() public onlyOwner {
1394     require(payable(msg.sender).send(address(this).balance));
1395     }
1396 
1397     function flipDropState() public onlyOwner {
1398         drop_is_active = !drop_is_active;
1399     }
1400 
1401     function flipPresaleSate() public onlyOwner {
1402         presale_is_active = !presale_is_active;
1403     }
1404 
1405     function PresaleMint(uint256 numberOfTokens) public payable{
1406         require(presale_is_active, "Please wait until the PreMint has begun!");
1407         require(whitelist[msg.sender].exists == true, "This Wallet is not able mint for presale"); 
1408         require(numberOfTokens > 0 && tokensMinted + numberOfTokens <= ApeSup, "Purchase would exceed current max supply of tickets");
1409         require(whitelist[msg.sender].presalemints + numberOfTokens <= maxWlApePurchase,"This Wallet has already minted its reserved tickets");
1410         require(msg.value >= apeWlPrice * numberOfTokens, "ETH value sent is too little for this many tickets");
1411         addressesThatMinted[msg.sender] += numberOfTokens;
1412         whitelist[msg.sender].presalemints += numberOfTokens;
1413 
1414         _safeMint(msg.sender, numberOfTokens);
1415     }
1416 
1417     function mintApeRaffle(uint numberOfTokens) public payable {
1418         require(drop_is_active, "Please wait until the Public sale is active to mint");
1419         require(numberOfTokens > 0 && numberOfTokens <= maxApePurchase);
1420         require(tokensMinted + numberOfTokens <= ApeSup, "Purchase would exceed max supply of tickets");
1421         require(msg.value >= apePrice * numberOfTokens, "ETH value sent is too little for this many tickets");
1422         require(((addressesThatMinted[msg.sender] + numberOfTokens) ) <= maxApePurchase , "this would exceed mint max allowance");
1423 
1424         addressesThatMinted[msg.sender] += numberOfTokens;
1425 
1426         _safeMint(msg.sender, numberOfTokens);
1427     }
1428 
1429     function _baseURI() internal view virtual override returns (string memory) {
1430         return baseURI;
1431     }
1432 
1433     function setBaseURI(string memory newBaseURI)public onlyOwner{
1434         baseURI = newBaseURI;
1435     }
1436     function changeMintPrice(uint256 newPrice) public onlyOwner {
1437         // require(newPrice < apePrice); removing mandate to go lower
1438         apePrice = newPrice;
1439     }
1440     function changeWlMintPrice(uint256 newWlPrice) public onlyOwner {
1441         // require(newPrice < apePrice); removing mandate to go lower
1442         apeWlPrice = newWlPrice;
1443     }
1444     function changeMintSupply(uint256 newSupply) public onlyOwner {
1445         // require(newSupply < ApeSup); removing mandate to go lower
1446         require(newSupply > totalSupply());
1447         ApeSup = newSupply;
1448     }
1449     function changeMaxApePurchase(uint256 newMaxApePurchase) public onlyOwner {
1450 
1451         maxApePurchase = newMaxApePurchase;
1452     }
1453     function changeMaxWlApePurchase(uint256 newMaxWlApePurchase) public onlyOwner {
1454 
1455         maxWlApePurchase = newMaxWlApePurchase;
1456     }
1457     
1458 }