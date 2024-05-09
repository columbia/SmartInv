1 // SPDX-License-Identifier: MIT
2 // File: contracts/PixelDivision.sol
3 
4 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
34 
35 
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 
108 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
109 
110 
111 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
112 
113 /**
114  * @dev String operations.
115  */
116 library Strings {
117     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
121      */
122     function toString(uint256 value) internal pure returns (string memory) {
123         // Inspired by OraclizeAPI's implementation - MIT licence
124         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
125 
126         if (value == 0) {
127             return "0";
128         }
129         uint256 temp = value;
130         uint256 digits;
131         while (temp != 0) {
132             digits++;
133             temp /= 10;
134         }
135         bytes memory buffer = new bytes(digits);
136         while (value != 0) {
137             digits -= 1;
138             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
139             value /= 10;
140         }
141         return string(buffer);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
146      */
147     function toHexString(uint256 value) internal pure returns (string memory) {
148         if (value == 0) {
149             return "0x00";
150         }
151         uint256 temp = value;
152         uint256 length = 0;
153         while (temp != 0) {
154             length++;
155             temp >>= 8;
156         }
157         return toHexString(value, length);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
162      */
163     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
164         bytes memory buffer = new bytes(2 * length + 2);
165         buffer[0] = "0";
166         buffer[1] = "x";
167         for (uint256 i = 2 * length + 1; i > 1; --i) {
168             buffer[i] = _HEX_SYMBOLS[value & 0xf];
169             value >>= 4;
170         }
171         require(value == 0, "Strings: hex length insufficient");
172         return string(buffer);
173     }
174 }
175 
176 
177 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
178 
179 
180 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
181 
182 
183 
184 /**
185  * @dev Interface of the ERC165 standard, as defined in the
186  * https://eips.ethereum.org/EIPS/eip-165[EIP].
187  *
188  * Implementers can declare support of contract interfaces, which can then be
189  * queried by others ({ERC165Checker}).
190  *
191  * For an implementation, see {ERC165}.
192  */
193 interface IERC165 {
194     /**
195      * @dev Returns true if this contract implements the interface defined by
196      * `interfaceId`. See the corresponding
197      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
198      * to learn more about how these ids are created.
199      *
200      * This function call must use less than 30 000 gas.
201      */
202     function supportsInterface(bytes4 interfaceId) external view returns (bool);
203 }
204 
205 
206 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
207 
208 
209 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
210 
211 
212 
213 /**
214  * @dev Required interface of an ERC721 compliant contract.
215  */
216 interface IERC721 is IERC165 {
217     /**
218      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
219      */
220     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
221 
222     /**
223      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
224      */
225     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
226 
227     /**
228      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
229      */
230     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
231 
232     /**
233      * @dev Returns the number of tokens in ``owner``'s account.
234      */
235     function balanceOf(address owner) external view returns (uint256 balance);
236 
237     /**
238      * @dev Returns the owner of the `tokenId` token.
239      *
240      * Requirements:
241      *
242      * - `tokenId` must exist.
243      */
244     function ownerOf(uint256 tokenId) external view returns (address owner);
245 
246     /**
247      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
248      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
249      *
250      * Requirements:
251      *
252      * - `from` cannot be the zero address.
253      * - `to` cannot be the zero address.
254      * - `tokenId` token must exist and be owned by `from`.
255      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
256      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
257      *
258      * Emits a {Transfer} event.
259      */
260     function safeTransferFrom(
261         address from,
262         address to,
263         uint256 tokenId
264     ) external;
265 
266     /**
267      * @dev Transfers `tokenId` token from `from` to `to`.
268      *
269      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
270      *
271      * Requirements:
272      *
273      * - `from` cannot be the zero address.
274      * - `to` cannot be the zero address.
275      * - `tokenId` token must be owned by `from`.
276      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transferFrom(
281         address from,
282         address to,
283         uint256 tokenId
284     ) external;
285 
286     /**
287      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
288      * The approval is cleared when the token is transferred.
289      *
290      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
291      *
292      * Requirements:
293      *
294      * - The caller must own the token or be an approved operator.
295      * - `tokenId` must exist.
296      *
297      * Emits an {Approval} event.
298      */
299     function approve(address to, uint256 tokenId) external;
300 
301     /**
302      * @dev Returns the account approved for `tokenId` token.
303      *
304      * Requirements:
305      *
306      * - `tokenId` must exist.
307      */
308     function getApproved(uint256 tokenId) external view returns (address operator);
309 
310     /**
311      * @dev Approve or remove `operator` as an operator for the caller.
312      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
313      *
314      * Requirements:
315      *
316      * - The `operator` cannot be the caller.
317      *
318      * Emits an {ApprovalForAll} event.
319      */
320     function setApprovalForAll(address operator, bool _approved) external;
321 
322     /**
323      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
324      *
325      * See {setApprovalForAll}
326      */
327     function isApprovedForAll(address owner, address operator) external view returns (bool);
328 
329     /**
330      * @dev Safely transfers `tokenId` token from `from` to `to`.
331      *
332      * Requirements:
333      *
334      * - `from` cannot be the zero address.
335      * - `to` cannot be the zero address.
336      * - `tokenId` token must exist and be owned by `from`.
337      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
338      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
339      *
340      * Emits a {Transfer} event.
341      */
342     function safeTransferFrom(
343         address from,
344         address to,
345         uint256 tokenId,
346         bytes calldata data
347     ) external;
348 }
349 
350 
351 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
352 
353 
354 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
355 
356 
357 
358 /**
359  * @title ERC721 token receiver interface
360  * @dev Interface for any contract that wants to support safeTransfers
361  * from ERC721 asset contracts.
362  */
363 interface IERC721Receiver {
364     /**
365      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
366      * by `operator` from `from`, this function is called.
367      *
368      * It must return its Solidity selector to confirm the token transfer.
369      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
370      *
371      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
372      */
373     function onERC721Received(
374         address operator,
375         address from,
376         uint256 tokenId,
377         bytes calldata data
378     ) external returns (bytes4);
379 }
380 
381 
382 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
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
411 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
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
442 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
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
663 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
667 
668 
669 
670 /**
671  * @dev Implementation of the {IERC165} interface.
672  *
673  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
674  * for the additional interface id that will be supported. For example:
675  *
676  * ```solidity
677  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
678  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
679  * }
680  * ```
681  *
682  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
683  */
684 abstract contract ERC165 is IERC165 {
685     /**
686      * @dev See {IERC165-supportsInterface}.
687      */
688     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
689         return interfaceId == type(IERC165).interfaceId;
690     }
691 }
692 
693 
694 // File contracts/ERC721A.sol
695 
696 
697 // Creator: FROGGY
698 
699 
700 /**
701  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
702  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
703  *
704  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
705  *
706  * Does not support burning tokens to address(0).
707  *
708  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
709  */
710 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
711     using Address for address;
712     using Strings for uint256;
713 
714     struct TokenOwnership {
715         address addr;
716         uint64 startTimestamp;
717     }
718 
719     struct AddressData {
720         uint128 balance;
721         uint128 numberMinted;
722     }
723 
724     uint256 internal currentIndex = 1;
725 
726     // Token name
727     string private _name;
728 
729     // Token symbol
730     string private _symbol;
731 
732     // Mapping from token ID to ownership details
733     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
734     mapping(uint256 => TokenOwnership) internal _ownerships;
735 
736     // Mapping owner address to address data
737     mapping(address => AddressData) private _addressData;
738 
739     // Mapping from token ID to approved address
740     mapping(uint256 => address) private _tokenApprovals;
741 
742     // Mapping from owner to operator approvals
743     mapping(address => mapping(address => bool)) private _operatorApprovals;
744 
745     constructor(string memory name_, string memory symbol_) {
746         _name = name_;
747         _symbol = symbol_;
748     }
749 
750     /**
751      * @dev See {IERC721Enumerable-totalSupply}.
752      */
753     function totalSupply() public view override returns (uint256) {
754         return currentIndex;
755     }
756 
757     /**
758      * @dev See {IERC721Enumerable-tokenByIndex}.
759      */
760     function tokenByIndex(uint256 index) public view override returns (uint256) {
761         require(index < totalSupply(), 'ERC721A: global index out of bounds');
762         return index;
763     }
764 
765     /**
766      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
767      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
768      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
769      */
770     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
771         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
772         uint256 numMintedSoFar = totalSupply();
773         uint256 tokenIdsIdx = 0;
774         address currOwnershipAddr = address(0);
775         for (uint256 i = 0; i < numMintedSoFar; i++) {
776             TokenOwnership memory ownership = _ownerships[i];
777             if (ownership.addr != address(0)) {
778                 currOwnershipAddr = ownership.addr;
779             }
780             if (currOwnershipAddr == owner) {
781                 if (tokenIdsIdx == index) {
782                     return i;
783                 }
784                 tokenIdsIdx++;
785             }
786         }
787         revert('ERC721A: unable to get token of owner by index');
788     }
789 
790     /**
791      * @dev See {IERC165-supportsInterface}.
792      */
793     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
794         return
795             interfaceId == type(IERC721).interfaceId ||
796             interfaceId == type(IERC721Metadata).interfaceId ||
797             interfaceId == type(IERC721Enumerable).interfaceId ||
798             super.supportsInterface(interfaceId);
799     }
800 
801     /**
802      * @dev See {IERC721-balanceOf}.
803      */
804     function balanceOf(address owner) public view override returns (uint256) {
805         require(owner != address(0), 'ERC721A: balance query for the zero address');
806         return uint256(_addressData[owner].balance);
807     }
808 
809     function _numberMinted(address owner) internal view returns (uint256) {
810         require(owner != address(0), 'ERC721A: number minted query for the zero address');
811         return uint256(_addressData[owner].numberMinted);
812     }
813 
814     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
815         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
816 
817         for (uint256 curr = tokenId; ; curr--) {
818             TokenOwnership memory ownership = _ownerships[curr];
819             if (ownership.addr != address(0)) {
820                 return ownership;
821             }
822         }
823 
824         revert('ERC721A: unable to determine the owner of token');
825     }
826 
827     /**
828      * @dev See {IERC721-ownerOf}.
829      */
830     function ownerOf(uint256 tokenId) public view override returns (address) {
831         return ownershipOf(tokenId).addr;
832     }
833 
834     /**
835      * @dev See {IERC721Metadata-name}.
836      */
837     function name() public view virtual override returns (string memory) {
838         return _name;
839     }
840 
841     /**
842      * @dev See {IERC721Metadata-symbol}.
843      */
844     function symbol() public view virtual override returns (string memory) {
845         return _symbol;
846     }
847 
848     /**
849      * @dev See {IERC721Metadata-tokenURI}.
850      */
851     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
852         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
853 
854         string memory baseURI = _baseURI();
855         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
856     }
857 
858     /**
859      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
860      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
861      * by default, can be overriden in child contracts.
862      */
863     function _baseURI() internal view virtual returns (string memory) {
864         return '';
865     }
866 
867     /**
868      * @dev See {IERC721-approve}.
869      */
870     function approve(address to, uint256 tokenId) public override {
871         address owner = ERC721A.ownerOf(tokenId);
872         require(to != owner, 'ERC721A: approval to current owner');
873 
874         require(
875             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
876             'ERC721A: approve caller is not owner nor approved for all'
877         );
878 
879         _approve(to, tokenId, owner);
880     }
881 
882     /**
883      * @dev See {IERC721-getApproved}.
884      */
885     function getApproved(uint256 tokenId) public view override returns (address) {
886         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
887 
888         return _tokenApprovals[tokenId];
889     }
890 
891     /**
892      * @dev See {IERC721-setApprovalForAll}.
893      */
894     function setApprovalForAll(address operator, bool approved) public override {
895         require(operator != _msgSender(), 'ERC721A: approve to caller');
896 
897         _operatorApprovals[_msgSender()][operator] = approved;
898         emit ApprovalForAll(_msgSender(), operator, approved);
899     }
900 
901     /**
902      * @dev See {IERC721-isApprovedForAll}.
903      */
904     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
905         return _operatorApprovals[owner][operator];
906     }
907 
908     /**
909      * @dev See {IERC721-transferFrom}.
910      */
911     function transferFrom(
912         address from,
913         address to,
914         uint256 tokenId
915     ) public override {
916         _transfer(from, to, tokenId);
917     }
918 
919     /**
920      * @dev See {IERC721-safeTransferFrom}.
921      */
922     function safeTransferFrom(
923         address from,
924         address to,
925         uint256 tokenId
926     ) public override {
927         safeTransferFrom(from, to, tokenId, '');
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId,
937         bytes memory _data
938     ) public override {
939         _transfer(from, to, tokenId);
940         require(
941             _checkOnERC721Received(from, to, tokenId, _data),
942             'ERC721A: transfer to non ERC721Receiver implementer'
943         );
944     }
945 
946     /**
947      * @dev Returns whether `tokenId` exists.
948      *
949      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
950      *
951      * Tokens start existing when they are minted (`_mint`),
952      */
953     function _exists(uint256 tokenId) internal view returns (bool) {
954         return tokenId < currentIndex;
955     }
956 
957     function _safeMint(address to, uint256 quantity) internal {
958         _safeMint(to, quantity, '');
959     }
960 
961     /**
962      * @dev Mints `quantity` tokens and transfers them to `to`.
963      *
964      * Requirements:
965      *
966      * - `to` cannot be the zero address.
967      * - `quantity` cannot be larger than the max batch size.
968      *
969      * Emits a {Transfer} event.
970      */
971     function _safeMint(
972         address to,
973         uint256 quantity,
974         bytes memory _data
975     ) internal {
976         uint256 startTokenId = currentIndex;
977         require(to != address(0), 'ERC721A: mint to the zero address');
978         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
979         require(!_exists(startTokenId), 'ERC721A: token already minted');
980         require(quantity > 0, 'ERC721A: quantity must be greater 0');
981 
982         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
983 
984         AddressData memory addressData = _addressData[to];
985         _addressData[to] = AddressData(
986             addressData.balance + uint128(quantity),
987             addressData.numberMinted + uint128(quantity)
988         );
989         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
990 
991         uint256 updatedIndex = startTokenId;
992 
993         for (uint256 i = 0; i < quantity; i++) {
994             emit Transfer(address(0), to, updatedIndex);
995             require(
996                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
997                 'ERC721A: transfer to non ERC721Receiver implementer'
998             );
999             updatedIndex++;
1000         }
1001 
1002         currentIndex = updatedIndex;
1003         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1004     }
1005 
1006     /**
1007      * @dev Transfers `tokenId` from `from` to `to`.
1008      *
1009      * Requirements:
1010      *
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must be owned by `from`.
1013      *
1014      * Emits a {Transfer} event.
1015      */
1016     function _transfer(
1017         address from,
1018         address to,
1019         uint256 tokenId
1020     ) private {
1021         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1022 
1023         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1024             getApproved(tokenId) == _msgSender() ||
1025             isApprovedForAll(prevOwnership.addr, _msgSender()));
1026 
1027         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1028 
1029         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1030         require(to != address(0), 'ERC721A: transfer to the zero address');
1031 
1032         _beforeTokenTransfers(from, to, tokenId, 1);
1033 
1034         // Clear approvals from the previous owner
1035         _approve(address(0), tokenId, prevOwnership.addr);
1036 
1037         // Underflow of the sender's balance is impossible because we check for
1038         // ownership above and the recipient's balance can't realistically overflow.
1039         unchecked {
1040             _addressData[from].balance -= 1;
1041             _addressData[to].balance += 1;
1042         }
1043 
1044         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1045 
1046         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1047         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1048         uint256 nextTokenId = tokenId + 1;
1049         if (_ownerships[nextTokenId].addr == address(0)) {
1050             if (_exists(nextTokenId)) {
1051                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1052             }
1053         }
1054 
1055         emit Transfer(from, to, tokenId);
1056         _afterTokenTransfers(from, to, tokenId, 1);
1057     }
1058 
1059     /**
1060      * @dev Approve `to` to operate on `tokenId`
1061      *
1062      * Emits a {Approval} event.
1063      */
1064     function _approve(
1065         address to,
1066         uint256 tokenId,
1067         address owner
1068     ) private {
1069         _tokenApprovals[tokenId] = to;
1070         emit Approval(owner, to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1075      * The call is not executed if the target address is not a contract.
1076      *
1077      * @param from address representing the previous owner of the given token ID
1078      * @param to target address that will receive the tokens
1079      * @param tokenId uint256 ID of the token to be transferred
1080      * @param _data bytes optional data to send along with the call
1081      * @return bool whether the call correctly returned the expected magic value
1082      */
1083     function _checkOnERC721Received(
1084         address from,
1085         address to,
1086         uint256 tokenId,
1087         bytes memory _data
1088     ) private returns (bool) {
1089         if (to.isContract()) {
1090             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1091                 return retval == IERC721Receiver(to).onERC721Received.selector;
1092             } catch (bytes memory reason) {
1093                 if (reason.length == 0) {
1094                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1095                 } else {
1096                     assembly {
1097                         revert(add(32, reason), mload(reason))
1098                     }
1099                 }
1100             }
1101         } else {
1102             return true;
1103         }
1104     }
1105 
1106     /**
1107      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1108      *
1109      * startTokenId - the first token id to be transferred
1110      * quantity - the amount to be transferred
1111      *
1112      * Calling conditions:
1113      *
1114      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1115      * transferred to `to`.
1116      * - When `from` is zero, `tokenId` will be minted for `to`.
1117      */
1118     function _beforeTokenTransfers(
1119         address from,
1120         address to,
1121         uint256 startTokenId,
1122         uint256 quantity
1123     ) internal virtual {}
1124 
1125     /**
1126      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1127      * minting.
1128      *
1129      * startTokenId - the first token id to be transferred
1130      * quantity - the amount to be transferred
1131      *
1132      * Calling conditions:
1133      *
1134      * - when `from` and `to` are both non-zero.
1135      * - `from` and `to` are never both zero.
1136      */
1137     function _afterTokenTransfers(
1138         address from,
1139         address to,
1140         uint256 startTokenId,
1141         uint256 quantity
1142     ) internal virtual {}
1143 }
1144 
1145 contract PixelDivision is ERC721A, Ownable {
1146 
1147     string public baseURI = "ipfs://Qmb9dAoh1BF5pYjBCUiHmDySwj2iUnHw1qh5ZRE4nmLstS/";
1148     string public constant baseExtension = ".json";
1149     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1150 
1151     uint256 public constant MAX_PER_TX = 5;
1152     uint256 public constant MAX_PER_WALLET = 20;
1153     uint256 public constant MAX_SUPPLY = 2000;
1154     uint256 public constant price = 0 ether;
1155 
1156     bool public paused = false;
1157 
1158     mapping(address => uint256) public addressMinted;
1159 
1160     constructor() ERC721A("PixelDivision", "PXD") {}
1161 
1162     function mint(uint256 _amount) external payable {
1163         address _caller = _msgSender();
1164         require(!paused, "Paused");
1165         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1166         require(_amount > 0, "No 0 mints");
1167         require(tx.origin == _caller, "No contracts");
1168         require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
1169         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1170         require(_amount * price == msg.value, "Invalid funds provided");
1171          addressMinted[msg.sender] += _amount;
1172         _safeMint(_caller, _amount);
1173     }
1174 
1175     function isApprovedForAll(address owner, address operator)
1176         override
1177         public
1178         view
1179         returns (bool)
1180     {
1181         // Whitelist OpenSea proxy contract for easy trading.
1182         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1183         if (address(proxyRegistry.proxies(owner)) == operator) {
1184             return true;
1185         }
1186 
1187         return super.isApprovedForAll(owner, operator);
1188     }
1189 
1190     function withdraw() external onlyOwner {
1191         uint256 balance = address(this).balance;
1192         (bool success, ) = _msgSender().call{value: balance}("");
1193         require(success, "Failed to send");
1194     }
1195 
1196     function pause(bool _state) external onlyOwner {
1197         paused = _state;
1198     }
1199 
1200     function setBaseURI(string memory baseURI_) external onlyOwner {
1201         baseURI = baseURI_;
1202     }
1203 
1204     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1205         require(_exists(_tokenId), "Token does not exist.");
1206         return bytes(baseURI).length > 0 ? string(
1207             abi.encodePacked(
1208               baseURI,
1209               Strings.toString(_tokenId),
1210               baseExtension
1211             )
1212         ) : "";
1213     }
1214 }
1215 
1216 contract OwnableDelegateProxy { }
1217 contract ProxyRegistry {
1218     mapping(address => OwnableDelegateProxy) public proxies;
1219 }