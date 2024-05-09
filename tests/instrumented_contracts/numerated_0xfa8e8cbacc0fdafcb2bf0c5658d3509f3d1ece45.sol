1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
111 
112 
113 
114 /**
115  * @dev String operations.
116  */
117 library Strings {
118     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
119 
120     /**
121      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
122      */
123     function toString(uint256 value) internal pure returns (string memory) {
124         // Inspired by OraclizeAPI's implementation - MIT licence
125         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
126 
127         if (value == 0) {
128             return "0";
129         }
130         uint256 temp = value;
131         uint256 digits;
132         while (temp != 0) {
133             digits++;
134             temp /= 10;
135         }
136         bytes memory buffer = new bytes(digits);
137         while (value != 0) {
138             digits -= 1;
139             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
140             value /= 10;
141         }
142         return string(buffer);
143     }
144 
145     /**
146      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
147      */
148     function toHexString(uint256 value) internal pure returns (string memory) {
149         if (value == 0) {
150             return "0x00";
151         }
152         uint256 temp = value;
153         uint256 length = 0;
154         while (temp != 0) {
155             length++;
156             temp >>= 8;
157         }
158         return toHexString(value, length);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
163      */
164     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
165         bytes memory buffer = new bytes(2 * length + 2);
166         buffer[0] = "0";
167         buffer[1] = "x";
168         for (uint256 i = 2 * length + 1; i > 1; --i) {
169             buffer[i] = _HEX_SYMBOLS[value & 0xf];
170             value >>= 4;
171         }
172         require(value == 0, "Strings: hex length insufficient");
173         return string(buffer);
174     }
175 }
176 
177 
178 
179 
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
182 
183 
184 
185 /**
186  * @dev Interface of the ERC165 standard, as defined in the
187  * https://eips.ethereum.org/EIPS/eip-165[EIP].
188  *
189  * Implementers can declare support of contract interfaces, which can then be
190  * queried by others ({ERC165Checker}).
191  *
192  * For an implementation, see {ERC165}.
193  */
194 interface IERC165 {
195     /**
196      * @dev Returns true if this contract implements the interface defined by
197      * `interfaceId`. See the corresponding
198      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
199      * to learn more about how these ids are created.
200      *
201      * This function call must use less than 30 000 gas.
202      */
203     function supportsInterface(bytes4 interfaceId) external view returns (bool);
204 }
205 
206 
207 
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
211 
212 
213 
214 /**
215  * @dev Required interface of an ERC721 compliant contract.
216  */
217 interface IERC721 is IERC165 {
218     /**
219      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
220      */
221     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
222 
223     /**
224      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
225      */
226     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
227 
228     /**
229      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
230      */
231     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
232 
233     /**
234      * @dev Returns the number of tokens in ``owner``'s account.
235      */
236     function balanceOf(address owner) external view returns (uint256 balance);
237 
238     /**
239      * @dev Returns the owner of the `tokenId` token.
240      *
241      * Requirements:
242      *
243      * - `tokenId` must exist.
244      */
245     function ownerOf(uint256 tokenId) external view returns (address owner);
246 
247     /**
248      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
249      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
250      *
251      * Requirements:
252      *
253      * - `from` cannot be the zero address.
254      * - `to` cannot be the zero address.
255      * - `tokenId` token must exist and be owned by `from`.
256      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
257      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
258      *
259      * Emits a {Transfer} event.
260      */
261     function safeTransferFrom(
262         address from,
263         address to,
264         uint256 tokenId
265     ) external;
266 
267     /**
268      * @dev Transfers `tokenId` token from `from` to `to`.
269      *
270      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
271      *
272      * Requirements:
273      *
274      * - `from` cannot be the zero address.
275      * - `to` cannot be the zero address.
276      * - `tokenId` token must be owned by `from`.
277      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 tokenId
285     ) external;
286 
287     /**
288      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
289      * The approval is cleared when the token is transferred.
290      *
291      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
292      *
293      * Requirements:
294      *
295      * - The caller must own the token or be an approved operator.
296      * - `tokenId` must exist.
297      *
298      * Emits an {Approval} event.
299      */
300     function approve(address to, uint256 tokenId) external;
301 
302     /**
303      * @dev Returns the account approved for `tokenId` token.
304      *
305      * Requirements:
306      *
307      * - `tokenId` must exist.
308      */
309     function getApproved(uint256 tokenId) external view returns (address operator);
310 
311     /**
312      * @dev Approve or remove `operator` as an operator for the caller.
313      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
314      *
315      * Requirements:
316      *
317      * - The `operator` cannot be the caller.
318      *
319      * Emits an {ApprovalForAll} event.
320      */
321     function setApprovalForAll(address operator, bool _approved) external;
322 
323     /**
324      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
325      *
326      * See {setApprovalForAll}
327      */
328     function isApprovedForAll(address owner, address operator) external view returns (bool);
329 
330     /**
331      * @dev Safely transfers `tokenId` token from `from` to `to`.
332      *
333      * Requirements:
334      *
335      * - `from` cannot be the zero address.
336      * - `to` cannot be the zero address.
337      * - `tokenId` token must exist and be owned by `from`.
338      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
339      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
340      *
341      * Emits a {Transfer} event.
342      */
343     function safeTransferFrom(
344         address from,
345         address to,
346         uint256 tokenId,
347         bytes calldata data
348     ) external;
349 }
350 
351 
352 
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
356 
357 
358 
359 /**
360  * @title ERC721 token receiver interface
361  * @dev Interface for any contract that wants to support safeTransfers
362  * from ERC721 asset contracts.
363  */
364 interface IERC721Receiver {
365     /**
366      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
367      * by `operator` from `from`, this function is called.
368      *
369      * It must return its Solidity selector to confirm the token transfer.
370      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
371      *
372      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
373      */
374     function onERC721Received(
375         address operator,
376         address from,
377         uint256 tokenId,
378         bytes calldata data
379     ) external returns (bytes4);
380 }
381 
382 
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
386 
387 
388 
389 /**
390  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
391  * @dev See https://eips.ethereum.org/EIPS/eip-721
392  */
393 interface IERC721Metadata is IERC721 {
394     /**
395      * @dev Returns the token collection name.
396      */
397     function name() external view returns (string memory);
398 
399     /**
400      * @dev Returns the token collection symbol.
401      */
402     function symbol() external view returns (string memory);
403 
404     /**
405      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
406      */
407     function tokenURI(uint256 tokenId) external view returns (string memory);
408 }
409 
410 
411 
412 
413 
414 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
415 
416 
417 
418 /**
419  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
420  * @dev See https://eips.ethereum.org/EIPS/eip-721
421  */
422 interface IERC721Enumerable is IERC721 {
423     /**
424      * @dev Returns the total amount of tokens stored by the contract.
425      */
426     function totalSupply() external view returns (uint256);
427 
428     /**
429      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
430      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
431      */
432     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
433 
434     /**
435      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
436      * Use along with {totalSupply} to enumerate all tokens.
437      */
438     function tokenByIndex(uint256 index) external view returns (uint256);
439 }
440 
441 
442 
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
446 
447 
448 
449 /**
450  * @dev Collection of functions related to the address type
451  */
452 library Address {
453     /**
454      * @dev Returns true if `account` is a contract.
455      *
456      * [IMPORTANT]
457      * ====
458      * It is unsafe to assume that an address for which this function returns
459      * false is an externally-owned account (EOA) and not a contract.
460      *
461      * Among others, `isContract` will return false for the following
462      * types of addresses:
463      *
464      *  - an externally-owned account
465      *  - a contract in construction
466      *  - an address where a contract will be created
467      *  - an address where a contract lived, but was destroyed
468      * ====
469      */
470     function isContract(address account) internal view returns (bool) {
471         // This method relies on extcodesize, which returns 0 for contracts in
472         // construction, since the code is only stored at the end of the
473         // constructor execution.
474 
475         uint256 size;
476         assembly {
477             size := extcodesize(account)
478         }
479         return size > 0;
480     }
481 
482     /**
483      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
484      * `recipient`, forwarding all available gas and reverting on errors.
485      *
486      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
487      * of certain opcodes, possibly making contracts go over the 2300 gas limit
488      * imposed by `transfer`, making them unable to receive funds via
489      * `transfer`. {sendValue} removes this limitation.
490      *
491      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
492      *
493      * IMPORTANT: because control is transferred to `recipient`, care must be
494      * taken to not create reentrancy vulnerabilities. Consider using
495      * {ReentrancyGuard} or the
496      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
497      */
498     function sendValue(address payable recipient, uint256 amount) internal {
499         require(address(this).balance >= amount, "Address: insufficient balance");
500 
501         (bool success, ) = recipient.call{value: amount}("");
502         require(success, "Address: unable to send value, recipient may have reverted");
503     }
504 
505     /**
506      * @dev Performs a Solidity function call using a low level `call`. A
507      * plain `call` is an unsafe replacement for a function call: use this
508      * function instead.
509      *
510      * If `target` reverts with a revert reason, it is bubbled up by this
511      * function (like regular Solidity function calls).
512      *
513      * Returns the raw returned data. To convert to the expected return value,
514      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
515      *
516      * Requirements:
517      *
518      * - `target` must be a contract.
519      * - calling `target` with `data` must not revert.
520      *
521      * _Available since v3.1._
522      */
523     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
524         return functionCall(target, data, "Address: low-level call failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
529      * `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCall(
534         address target,
535         bytes memory data,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, 0, errorMessage);
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
543      * but also transferring `value` wei to `target`.
544      *
545      * Requirements:
546      *
547      * - the calling contract must have an ETH balance of at least `value`.
548      * - the called Solidity function must be `payable`.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(
553         address target,
554         bytes memory data,
555         uint256 value
556     ) internal returns (bytes memory) {
557         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
562      * with `errorMessage` as a fallback revert reason when `target` reverts.
563      *
564      * _Available since v3.1._
565      */
566     function functionCallWithValue(
567         address target,
568         bytes memory data,
569         uint256 value,
570         string memory errorMessage
571     ) internal returns (bytes memory) {
572         require(address(this).balance >= value, "Address: insufficient balance for call");
573         require(isContract(target), "Address: call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.call{value: value}(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a static call.
582      *
583      * _Available since v3.3._
584      */
585     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
586         return functionStaticCall(target, data, "Address: low-level static call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a static call.
592      *
593      * _Available since v3.3._
594      */
595     function functionStaticCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal view returns (bytes memory) {
600         require(isContract(target), "Address: static call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.staticcall(data);
603         return verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but performing a delegate call.
609      *
610      * _Available since v3.4._
611      */
612     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
613         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
618      * but performing a delegate call.
619      *
620      * _Available since v3.4._
621      */
622     function functionDelegateCall(
623         address target,
624         bytes memory data,
625         string memory errorMessage
626     ) internal returns (bytes memory) {
627         require(isContract(target), "Address: delegate call to non-contract");
628 
629         (bool success, bytes memory returndata) = target.delegatecall(data);
630         return verifyCallResult(success, returndata, errorMessage);
631     }
632 
633     /**
634      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
635      * revert reason using the provided one.
636      *
637      * _Available since v4.3._
638      */
639     function verifyCallResult(
640         bool success,
641         bytes memory returndata,
642         string memory errorMessage
643     ) internal pure returns (bytes memory) {
644         if (success) {
645             return returndata;
646         } else {
647             // Look for revert reason and bubble it up if present
648             if (returndata.length > 0) {
649                 // The easiest way to bubble the revert reason is using memory via assembly
650 
651                 assembly {
652                     let returndata_size := mload(returndata)
653                     revert(add(32, returndata), returndata_size)
654                 }
655             } else {
656                 revert(errorMessage);
657             }
658         }
659     }
660 }
661 
662 
663 
664 
665 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
666 
667 
668 
669 /**
670  * @dev Implementation of the {IERC165} interface.
671  *
672  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
673  * for the additional interface id that will be supported. For example:
674  *
675  * ```solidity
676  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
677  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
678  * }
679  * ```
680  *
681  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
682  */
683 abstract contract ERC165 is IERC165 {
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
688         return interfaceId == type(IERC165).interfaceId;
689     }
690 }
691 
692 
693 // File contracts/ERC721A.sol
694 
695 
696 // Creator: Chiru Labs
697 
698 
699 /**
700  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
701  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
702  *
703  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
704  *
705  * Does not support burning tokens to address(0).
706  *
707  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
708  */
709 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
710     using Address for address;
711     using Strings for uint256;
712 
713     struct TokenOwnership {
714         address addr;
715         uint64 startTimestamp;
716     }
717 
718     struct AddressData {
719         uint128 balance;
720         uint128 numberMinted;
721     }
722 
723     uint256 internal currentIndex = 0;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to ownership details
732     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
733     mapping(uint256 => TokenOwnership) internal _ownerships;
734 
735     // Mapping owner address to address data
736     mapping(address => AddressData) private _addressData;
737 
738     // Mapping from token ID to approved address
739     mapping(uint256 => address) private _tokenApprovals;
740 
741     // Mapping from owner to operator approvals
742     mapping(address => mapping(address => bool)) private _operatorApprovals;
743 
744     constructor(string memory name_, string memory symbol_) {
745         _name = name_;
746         _symbol = symbol_;
747     }
748 
749     /**
750      * @dev See {IERC721Enumerable-totalSupply}.
751      */
752     function totalSupply() public view override returns (uint256) {
753         return currentIndex;
754     }
755 
756     /**
757      * @dev See {IERC721Enumerable-tokenByIndex}.
758      */
759     function tokenByIndex(uint256 index) public view override returns (uint256) {
760         require(index < totalSupply(), 'ERC721A: global index out of bounds');
761         return index;
762     }
763 
764     /**
765      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
766      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
767      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
768      */
769     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
770         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
771         uint256 numMintedSoFar = totalSupply();
772         uint256 tokenIdsIdx = 0;
773         address currOwnershipAddr = address(0);
774         for (uint256 i = 0; i < numMintedSoFar; i++) {
775             TokenOwnership memory ownership = _ownerships[i];
776             if (ownership.addr != address(0)) {
777                 currOwnershipAddr = ownership.addr;
778             }
779             if (currOwnershipAddr == owner) {
780                 if (tokenIdsIdx == index) {
781                     return i;
782                 }
783                 tokenIdsIdx++;
784             }
785         }
786         revert('ERC721A: unable to get token of owner by index');
787     }
788 
789     /**
790      * @dev See {IERC165-supportsInterface}.
791      */
792     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
793         return
794             interfaceId == type(IERC721).interfaceId ||
795             interfaceId == type(IERC721Metadata).interfaceId ||
796             interfaceId == type(IERC721Enumerable).interfaceId ||
797             super.supportsInterface(interfaceId);
798     }
799 
800     /**
801      * @dev See {IERC721-balanceOf}.
802      */
803     function balanceOf(address owner) public view override returns (uint256) {
804         require(owner != address(0), 'ERC721A: balance query for the zero address');
805         return uint256(_addressData[owner].balance);
806     }
807 
808     function _numberMinted(address owner) internal view returns (uint256) {
809         require(owner != address(0), 'ERC721A: number minted query for the zero address');
810         return uint256(_addressData[owner].numberMinted);
811     }
812 
813     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
814         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
815 
816         for (uint256 curr = tokenId; ; curr--) {
817             TokenOwnership memory ownership = _ownerships[curr];
818             if (ownership.addr != address(0)) {
819                 return ownership;
820             }
821         }
822 
823         revert('ERC721A: unable to determine the owner of token');
824     }
825 
826     /**
827      * @dev See {IERC721-ownerOf}.
828      */
829     function ownerOf(uint256 tokenId) public view override returns (address) {
830         return ownershipOf(tokenId).addr;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-name}.
835      */
836     function name() public view virtual override returns (string memory) {
837         return _name;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-symbol}.
842      */
843     function symbol() public view virtual override returns (string memory) {
844         return _symbol;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-tokenURI}.
849      */
850     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
851         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
852 
853         string memory baseURI = _baseURI();
854         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
855     }
856 
857     /**
858      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
859      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
860      * by default, can be overriden in child contracts.
861      */
862     function _baseURI() internal view virtual returns (string memory) {
863         return '';
864     }
865 
866     /**
867      * @dev See {IERC721-approve}.
868      */
869     function approve(address to, uint256 tokenId) public override {
870         address owner = ERC721A.ownerOf(tokenId);
871         require(to != owner, 'ERC721A: approval to current owner');
872 
873         require(
874             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
875             'ERC721A: approve caller is not owner nor approved for all'
876         );
877 
878         _approve(to, tokenId, owner);
879     }
880 
881     /**
882      * @dev See {IERC721-getApproved}.
883      */
884     function getApproved(uint256 tokenId) public view override returns (address) {
885         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
886 
887         return _tokenApprovals[tokenId];
888     }
889 
890     /**
891      * @dev See {IERC721-setApprovalForAll}.
892      */
893     function setApprovalForAll(address operator, bool approved) public override {
894         require(operator != _msgSender(), 'ERC721A: approve to caller');
895 
896         _operatorApprovals[_msgSender()][operator] = approved;
897         emit ApprovalForAll(_msgSender(), operator, approved);
898     }
899 
900     /**
901      * @dev See {IERC721-isApprovedForAll}.
902      */
903     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
904         return _operatorApprovals[owner][operator];
905     }
906 
907     /**
908      * @dev See {IERC721-transferFrom}.
909      */
910     function transferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public override {
915         _transfer(from, to, tokenId);
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) public override {
926         safeTransferFrom(from, to, tokenId, '');
927     }
928 
929     /**
930      * @dev See {IERC721-safeTransferFrom}.
931      */
932     function safeTransferFrom(
933         address from,
934         address to,
935         uint256 tokenId,
936         bytes memory _data
937     ) public override {
938         _transfer(from, to, tokenId);
939         require(
940             _checkOnERC721Received(from, to, tokenId, _data),
941             'ERC721A: transfer to non ERC721Receiver implementer'
942         );
943     }
944 
945     /**
946      * @dev Returns whether `tokenId` exists.
947      *
948      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
949      *
950      * Tokens start existing when they are minted (`_mint`),
951      */
952     function _exists(uint256 tokenId) internal view returns (bool) {
953         return tokenId < currentIndex;
954     }
955 
956     function _safeMint(address to, uint256 quantity) internal {
957         _safeMint(to, quantity, '');
958     }
959 
960     /**
961      * @dev Mints `quantity` tokens and transfers them to `to`.
962      *
963      * Requirements:
964      *
965      * - `to` cannot be the zero address.
966      * - `quantity` cannot be larger than the max batch size.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _safeMint(
971         address to,
972         uint256 quantity,
973         bytes memory _data
974     ) internal {
975         uint256 startTokenId = currentIndex;
976         require(to != address(0), 'ERC721A: mint to the zero address');
977         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
978         require(!_exists(startTokenId), 'ERC721A: token already minted');
979         require(quantity > 0, 'ERC721A: quantity must be greater 0');
980 
981         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
982 
983         AddressData memory addressData = _addressData[to];
984         _addressData[to] = AddressData(
985             addressData.balance + uint128(quantity),
986             addressData.numberMinted + uint128(quantity)
987         );
988         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
989 
990         uint256 updatedIndex = startTokenId;
991 
992         for (uint256 i = 0; i < quantity; i++) {
993             emit Transfer(address(0), to, updatedIndex);
994             require(
995                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
996                 'ERC721A: transfer to non ERC721Receiver implementer'
997             );
998             updatedIndex++;
999         }
1000 
1001       currentIndex = updatedIndex;
1002         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1003     }
1004 
1005     /**
1006      * @dev Transfers `tokenId` from `from` to `to`.
1007      *
1008      * Requirements:
1009      *
1010      * - `to` cannot be the zero address.
1011      * - `tokenId` token must be owned by `from`.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function _transfer(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) private {
1020         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1021 
1022         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1023             getApproved(tokenId) == _msgSender() ||
1024             isApprovedForAll(prevOwnership.addr, _msgSender()));
1025 
1026         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1027 
1028         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1029         require(to != address(0), 'ERC721A: transfer to the zero address');
1030 
1031         _beforeTokenTransfers(from, to, tokenId, 1);
1032 
1033         // Clear approvals from the previous owner
1034         _approve(address(0), tokenId, prevOwnership.addr);
1035 
1036         // Underflow of the sender's balance is impossible because we check for
1037         // ownership above and the recipient's balance can't realistically overflow.
1038         unchecked {
1039             _addressData[from].balance -= 1;
1040             _addressData[to].balance += 1;
1041         }
1042 
1043         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1044 
1045         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1046         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1047         uint256 nextTokenId = tokenId + 1;
1048         if (_ownerships[nextTokenId].addr == address(0)) {
1049             if (_exists(nextTokenId)) {
1050                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1051             }
1052         }
1053 
1054         emit Transfer(from, to, tokenId);
1055         _afterTokenTransfers(from, to, tokenId, 1);
1056     }
1057 
1058     /**
1059      * @dev Approve `to` to operate on `tokenId`
1060      *
1061      * Emits a {Approval} event.
1062      */
1063     function _approve(
1064         address to,
1065         uint256 tokenId,
1066         address owner
1067     ) private {
1068         _tokenApprovals[tokenId] = to;
1069         emit Approval(owner, to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1074      * The call is not executed if the target address is not a contract.
1075      *
1076      * @param from address representing the previous owner of the given token ID
1077      * @param to target address that will receive the tokens
1078      * @param tokenId uint256 ID of the token to be transferred
1079      * @param _data bytes optional data to send along with the call
1080      * @return bool whether the call correctly returned the expected magic value
1081      */
1082     function _checkOnERC721Received(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes memory _data
1087     ) private returns (bool) {
1088         if (to.isContract()) {
1089             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1090                 return retval == IERC721Receiver(to).onERC721Received.selector;
1091             } catch (bytes memory reason) {
1092                 if (reason.length == 0) {
1093                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1094                 } else {
1095                     assembly {
1096                         revert(add(32, reason), mload(reason))
1097                     }
1098                 }
1099             }
1100         } else {
1101             return true;
1102         }
1103     }
1104 
1105     /**
1106      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1107      *
1108      * startTokenId - the first token id to be transferred
1109      * quantity - the amount to be transferred
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      */
1117     function _beforeTokenTransfers(
1118         address from,
1119         address to,
1120         uint256 startTokenId,
1121         uint256 quantity
1122     ) internal virtual {}
1123 
1124     /**
1125      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1126      * minting.
1127      *
1128      * startTokenId - the first token id to be transferred
1129      * quantity - the amount to be transferred
1130      *
1131      * Calling conditions:
1132      *
1133      * - when `from` and `to` are both non-zero.
1134      * - `from` and `to` are never both zero.
1135      */
1136     function _afterTokenTransfers(
1137         address from,
1138         address to,
1139         uint256 startTokenId,
1140         uint256 quantity
1141     ) internal virtual {}
1142 }
1143 
1144 contract MutantAssGoblins is ERC721A, Ownable {
1145 
1146     string public baseURI = "ipfs://";
1147     string public contractURI = "ipfs://";
1148     string public constant baseExtension = ".json";
1149     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1150 
1151     uint256 private constant Free_Tx = 20;
1152     uint256 public constant Max_Per_Tx = 20;
1153     uint256 private constant FREE_Max_Supply = 6000;
1154     uint256 public Max_Supply = 9999;
1155     uint256 public price = 0.0055 ether;
1156 
1157     bool public paused = false;
1158 
1159     constructor() ERC721A("MutantAssGoblins", "MAG") {}
1160 
1161     function mint(uint256 _amount) external payable {
1162         address _caller = _msgSender();
1163         require(!paused, "Paused");
1164         require(Max_Supply >= totalSupply() + _amount, "Exceeds max supply");
1165         require(_amount > 0, "No 0 mints");
1166         require(tx.origin == _caller, "No contracts");
1167 
1168         if(FREE_Max_Supply >= totalSupply()){
1169             require(Free_Tx >= _amount , "Excess max per free tx");
1170         }else{
1171             require(Max_Per_Tx >= _amount , "Excess max per paid tx");
1172             require(_amount * price == msg.value, "Invalid funds provided");
1173         }
1174 
1175         _safeMint(_caller, _amount);
1176     }
1177 
1178 
1179 
1180     function withdraw() external onlyOwner {
1181         uint256 balance = address(this).balance;
1182         (bool success, ) = _msgSender().call{value: balance}("");
1183         require(success, "Failed to send");
1184     }
1185 
1186     function pause(bool _state) external onlyOwner {
1187         paused = _state;
1188     }
1189 
1190     function setBaseURI(string memory baseURI_) external onlyOwner {
1191         baseURI = baseURI_;
1192     }
1193 
1194     function setContractURI(string memory _contractURI) external onlyOwner {
1195         contractURI = _contractURI;
1196     }
1197 
1198 function setPrice(uint256 newPrice) public onlyOwner {
1199         price = newPrice;
1200 }
1201 
1202 function setMax_Supply(uint256 newSupply) public onlyOwner {
1203         Max_Supply = newSupply;
1204 }
1205 
1206 
1207     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1208         require(_exists(_tokenId), "Token does not exist.");
1209         return bytes(baseURI).length > 0 ? string(
1210             abi.encodePacked(
1211               baseURI,
1212               Strings.toString(_tokenId),
1213               baseExtension
1214             )
1215         ) : "";
1216     }
1217 }