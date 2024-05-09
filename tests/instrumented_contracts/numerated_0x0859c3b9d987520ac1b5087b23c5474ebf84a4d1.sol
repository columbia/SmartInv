1 // SPDX-License-Identifier: MIT
2 // File: contracts/notboryoku.sol
3 
4 
5 
6 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
33 
34 
35 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
36 
37 
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev Initializes the contract setting the deployer as the initial owner.
58      */
59     constructor() {
60         _transferOwnership(_msgSender());
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         _transferOwnership(address(0));
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Can only be called by the current owner.
92      */
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "Ownable: new owner is the zero address");
95         _transferOwnership(newOwner);
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Internal function without access restriction.
101      */
102     function _transferOwnership(address newOwner) internal virtual {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 
110 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
111 
112 
113 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
114 
115 /**
116  * @dev String operations.
117  */
118 library Strings {
119     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
123      */
124     function toString(uint256 value) internal pure returns (string memory) {
125         // Inspired by OraclizeAPI's implementation - MIT licence
126         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
127 
128         if (value == 0) {
129             return "0";
130         }
131         uint256 temp = value;
132         uint256 digits;
133         while (temp != 0) {
134             digits++;
135             temp /= 10;
136         }
137         bytes memory buffer = new bytes(digits);
138         while (value != 0) {
139             digits -= 1;
140             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
141             value /= 10;
142         }
143         return string(buffer);
144     }
145 
146     /**
147      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
148      */
149     function toHexString(uint256 value) internal pure returns (string memory) {
150         if (value == 0) {
151             return "0x00";
152         }
153         uint256 temp = value;
154         uint256 length = 0;
155         while (temp != 0) {
156             length++;
157             temp >>= 8;
158         }
159         return toHexString(value, length);
160     }
161 
162     /**
163      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
164      */
165     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
166         bytes memory buffer = new bytes(2 * length + 2);
167         buffer[0] = "0";
168         buffer[1] = "x";
169         for (uint256 i = 2 * length + 1; i > 1; --i) {
170             buffer[i] = _HEX_SYMBOLS[value & 0xf];
171             value >>= 4;
172         }
173         require(value == 0, "Strings: hex length insufficient");
174         return string(buffer);
175     }
176 }
177 
178 
179 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
180 
181 
182 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
183 
184 
185 
186 /**
187  * @dev Interface of the ERC165 standard, as defined in the
188  * https://eips.ethereum.org/EIPS/eip-165[EIP].
189  *
190  * Implementers can declare support of contract interfaces, which can then be
191  * queried by others ({ERC165Checker}).
192  *
193  * For an implementation, see {ERC165}.
194  */
195 interface IERC165 {
196     /**
197      * @dev Returns true if this contract implements the interface defined by
198      * `interfaceId`. See the corresponding
199      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
200      * to learn more about how these ids are created.
201      *
202      * This function call must use less than 30 000 gas.
203      */
204     function supportsInterface(bytes4 interfaceId) external view returns (bool);
205 }
206 
207 
208 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
212 
213 
214 
215 /**
216  * @dev Required interface of an ERC721 compliant contract.
217  */
218 interface IERC721 is IERC165 {
219     /**
220      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
221      */
222     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
223 
224     /**
225      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
226      */
227     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
228 
229     /**
230      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
231      */
232     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
233 
234     /**
235      * @dev Returns the number of tokens in ``owner``'s account.
236      */
237     function balanceOf(address owner) external view returns (uint256 balance);
238 
239     /**
240      * @dev Returns the owner of the `tokenId` token.
241      *
242      * Requirements:
243      *
244      * - `tokenId` must exist.
245      */
246     function ownerOf(uint256 tokenId) external view returns (address owner);
247 
248     /**
249      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
250      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
251      *
252      * Requirements:
253      *
254      * - `from` cannot be the zero address.
255      * - `to` cannot be the zero address.
256      * - `tokenId` token must exist and be owned by `from`.
257      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
258      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
259      *
260      * Emits a {Transfer} event.
261      */
262     function safeTransferFrom(
263         address from,
264         address to,
265         uint256 tokenId
266     ) external;
267 
268     /**
269      * @dev Transfers `tokenId` token from `from` to `to`.
270      *
271      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
272      *
273      * Requirements:
274      *
275      * - `from` cannot be the zero address.
276      * - `to` cannot be the zero address.
277      * - `tokenId` token must be owned by `from`.
278      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transferFrom(
283         address from,
284         address to,
285         uint256 tokenId
286     ) external;
287 
288     /**
289      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
290      * The approval is cleared when the token is transferred.
291      *
292      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
293      *
294      * Requirements:
295      *
296      * - The caller must own the token or be an approved operator.
297      * - `tokenId` must exist.
298      *
299      * Emits an {Approval} event.
300      */
301     function approve(address to, uint256 tokenId) external;
302 
303     /**
304      * @dev Returns the account approved for `tokenId` token.
305      *
306      * Requirements:
307      *
308      * - `tokenId` must exist.
309      */
310     function getApproved(uint256 tokenId) external view returns (address operator);
311 
312     /**
313      * @dev Approve or remove `operator` as an operator for the caller.
314      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
315      *
316      * Requirements:
317      *
318      * - The `operator` cannot be the caller.
319      *
320      * Emits an {ApprovalForAll} event.
321      */
322     function setApprovalForAll(address operator, bool _approved) external;
323 
324     /**
325      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
326      *
327      * See {setApprovalForAll}
328      */
329     function isApprovedForAll(address owner, address operator) external view returns (bool);
330 
331     /**
332      * @dev Safely transfers `tokenId` token from `from` to `to`.
333      *
334      * Requirements:
335      *
336      * - `from` cannot be the zero address.
337      * - `to` cannot be the zero address.
338      * - `tokenId` token must exist and be owned by `from`.
339      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
340      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
341      *
342      * Emits a {Transfer} event.
343      */
344     function safeTransferFrom(
345         address from,
346         address to,
347         uint256 tokenId,
348         bytes calldata data
349     ) external;
350 }
351 
352 
353 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
357 
358 
359 
360 /**
361  * @title ERC721 token receiver interface
362  * @dev Interface for any contract that wants to support safeTransfers
363  * from ERC721 asset contracts.
364  */
365 interface IERC721Receiver {
366     /**
367      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
368      * by `operator` from `from`, this function is called.
369      *
370      * It must return its Solidity selector to confirm the token transfer.
371      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
372      *
373      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
374      */
375     function onERC721Received(
376         address operator,
377         address from,
378         uint256 tokenId,
379         bytes calldata data
380     ) external returns (bytes4);
381 }
382 
383 
384 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
385 
386 
387 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
388 
389 
390 
391 /**
392  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
393  * @dev See https://eips.ethereum.org/EIPS/eip-721
394  */
395 interface IERC721Metadata is IERC721 {
396     /**
397      * @dev Returns the token collection name.
398      */
399     function name() external view returns (string memory);
400 
401     /**
402      * @dev Returns the token collection symbol.
403      */
404     function symbol() external view returns (string memory);
405 
406     /**
407      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
408      */
409     function tokenURI(uint256 tokenId) external view returns (string memory);
410 }
411 
412 
413 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
417 
418 
419 
420 /**
421  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
422  * @dev See https://eips.ethereum.org/EIPS/eip-721
423  */
424 interface IERC721Enumerable is IERC721 {
425     /**
426      * @dev Returns the total amount of tokens stored by the contract.
427      */
428     function totalSupply() external view returns (uint256);
429 
430     /**
431      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
432      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
433      */
434     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
435 
436     /**
437      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
438      * Use along with {totalSupply} to enumerate all tokens.
439      */
440     function tokenByIndex(uint256 index) external view returns (uint256);
441 }
442 
443 
444 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
445 
446 
447 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
448 
449 
450 
451 /**
452  * @dev Collection of functions related to the address type
453  */
454 library Address {
455     /**
456      * @dev Returns true if `account` is a contract.
457      *
458      * [IMPORTANT]
459      * ====
460      * It is unsafe to assume that an address for which this function returns
461      * false is an externally-owned account (EOA) and not a contract.
462      *
463      * Among others, `isContract` will return false for the following
464      * types of addresses:
465      *
466      *  - an externally-owned account
467      *  - a contract in construction
468      *  - an address where a contract will be created
469      *  - an address where a contract lived, but was destroyed
470      * ====
471      */
472     function isContract(address account) internal view returns (bool) {
473         // This method relies on extcodesize, which returns 0 for contracts in
474         // construction, since the code is only stored at the end of the
475         // constructor execution.
476 
477         uint256 size;
478         assembly {
479             size := extcodesize(account)
480         }
481         return size > 0;
482     }
483 
484     /**
485      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
486      * `recipient`, forwarding all available gas and reverting on errors.
487      *
488      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
489      * of certain opcodes, possibly making contracts go over the 2300 gas limit
490      * imposed by `transfer`, making them unable to receive funds via
491      * `transfer`. {sendValue} removes this limitation.
492      *
493      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
494      *
495      * IMPORTANT: because control is transferred to `recipient`, care must be
496      * taken to not create reentrancy vulnerabilities. Consider using
497      * {ReentrancyGuard} or the
498      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
499      */
500     function sendValue(address payable recipient, uint256 amount) internal {
501         require(address(this).balance >= amount, "Address: insufficient balance");
502 
503         (bool success, ) = recipient.call{value: amount}("");
504         require(success, "Address: unable to send value, recipient may have reverted");
505     }
506 
507     /**
508      * @dev Performs a Solidity function call using a low level `call`. A
509      * plain `call` is an unsafe replacement for a function call: use this
510      * function instead.
511      *
512      * If `target` reverts with a revert reason, it is bubbled up by this
513      * function (like regular Solidity function calls).
514      *
515      * Returns the raw returned data. To convert to the expected return value,
516      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
517      *
518      * Requirements:
519      *
520      * - `target` must be a contract.
521      * - calling `target` with `data` must not revert.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
526         return functionCall(target, data, "Address: low-level call failed");
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
531      * `errorMessage` as a fallback revert reason when `target` reverts.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         return functionCallWithValue(target, data, 0, errorMessage);
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
545      * but also transferring `value` wei to `target`.
546      *
547      * Requirements:
548      *
549      * - the calling contract must have an ETH balance of at least `value`.
550      * - the called Solidity function must be `payable`.
551      *
552      * _Available since v3.1._
553      */
554     function functionCallWithValue(
555         address target,
556         bytes memory data,
557         uint256 value
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
564      * with `errorMessage` as a fallback revert reason when `target` reverts.
565      *
566      * _Available since v3.1._
567      */
568     function functionCallWithValue(
569         address target,
570         bytes memory data,
571         uint256 value,
572         string memory errorMessage
573     ) internal returns (bytes memory) {
574         require(address(this).balance >= value, "Address: insufficient balance for call");
575         require(isContract(target), "Address: call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.call{value: value}(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal view returns (bytes memory) {
602         require(isContract(target), "Address: static call to non-contract");
603 
604         (bool success, bytes memory returndata) = target.staticcall(data);
605         return verifyCallResult(success, returndata, errorMessage);
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
615         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a delegate call.
621      *
622      * _Available since v3.4._
623      */
624     function functionDelegateCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal returns (bytes memory) {
629         require(isContract(target), "Address: delegate call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.delegatecall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
637      * revert reason using the provided one.
638      *
639      * _Available since v4.3._
640      */
641     function verifyCallResult(
642         bool success,
643         bytes memory returndata,
644         string memory errorMessage
645     ) internal pure returns (bytes memory) {
646         if (success) {
647             return returndata;
648         } else {
649             // Look for revert reason and bubble it up if present
650             if (returndata.length > 0) {
651                 // The easiest way to bubble the revert reason is using memory via assembly
652 
653                 assembly {
654                     let returndata_size := mload(returndata)
655                     revert(add(32, returndata), returndata_size)
656                 }
657             } else {
658                 revert(errorMessage);
659             }
660         }
661     }
662 }
663 
664 
665 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
669 
670 
671 
672 /**
673  * @dev Implementation of the {IERC165} interface.
674  *
675  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
676  * for the additional interface id that will be supported. For example:
677  *
678  * ```solidity
679  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
680  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
681  * }
682  * ```
683  *
684  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
685  */
686 abstract contract ERC165 is IERC165 {
687     /**
688      * @dev See {IERC165-supportsInterface}.
689      */
690     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
691         return interfaceId == type(IERC165).interfaceId;
692     }
693 }
694 
695 
696 // File contracts/ERC721A.sol
697 
698 
699 // Creator: FROGGY
700 
701 
702 /**
703  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
704  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
705  *
706  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
707  *
708  * Does not support burning tokens to address(0).
709  *
710  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
711  */
712 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
713     using Address for address;
714     using Strings for uint256;
715 
716     struct TokenOwnership {
717         address addr;
718         uint64 startTimestamp;
719     }
720 
721     struct AddressData {
722         uint128 balance;
723         uint128 numberMinted;
724     }
725 
726     uint256 internal currentIndex = 1;
727 
728     // Token name
729     string private _name;
730 
731     // Token symbol
732     string private _symbol;
733 
734     // Mapping from token ID to ownership details
735     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
736     mapping(uint256 => TokenOwnership) internal _ownerships;
737 
738     // Mapping owner address to address data
739     mapping(address => AddressData) private _addressData;
740 
741     // Mapping from token ID to approved address
742     mapping(uint256 => address) private _tokenApprovals;
743 
744     // Mapping from owner to operator approvals
745     mapping(address => mapping(address => bool)) private _operatorApprovals;
746 
747     constructor(string memory name_, string memory symbol_) {
748         _name = name_;
749         _symbol = symbol_;
750     }
751 
752     /**
753      * @dev See {IERC721Enumerable-totalSupply}.
754      */
755     function totalSupply() public view override returns (uint256) {
756         return currentIndex;
757     }
758 
759     /**
760      * @dev See {IERC721Enumerable-tokenByIndex}.
761      */
762     function tokenByIndex(uint256 index) public view override returns (uint256) {
763         require(index < totalSupply(), 'ERC721A: global index out of bounds');
764         return index;
765     }
766 
767     /**
768      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
769      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
770      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
771      */
772     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
773         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
774         uint256 numMintedSoFar = totalSupply();
775         uint256 tokenIdsIdx = 0;
776         address currOwnershipAddr = address(0);
777         for (uint256 i = 0; i < numMintedSoFar; i++) {
778             TokenOwnership memory ownership = _ownerships[i];
779             if (ownership.addr != address(0)) {
780                 currOwnershipAddr = ownership.addr;
781             }
782             if (currOwnershipAddr == owner) {
783                 if (tokenIdsIdx == index) {
784                     return i;
785                 }
786                 tokenIdsIdx++;
787             }
788         }
789         revert('ERC721A: unable to get token of owner by index');
790     }
791 
792     /**
793      * @dev See {IERC165-supportsInterface}.
794      */
795     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
796         return
797             interfaceId == type(IERC721).interfaceId ||
798             interfaceId == type(IERC721Metadata).interfaceId ||
799             interfaceId == type(IERC721Enumerable).interfaceId ||
800             super.supportsInterface(interfaceId);
801     }
802 
803     /**
804      * @dev See {IERC721-balanceOf}.
805      */
806     function balanceOf(address owner) public view override returns (uint256) {
807         require(owner != address(0), 'ERC721A: balance query for the zero address');
808         return uint256(_addressData[owner].balance);
809     }
810 
811     function _numberMinted(address owner) internal view returns (uint256) {
812         require(owner != address(0), 'ERC721A: number minted query for the zero address');
813         return uint256(_addressData[owner].numberMinted);
814     }
815 
816     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
817         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
818 
819         for (uint256 curr = tokenId; ; curr--) {
820             TokenOwnership memory ownership = _ownerships[curr];
821             if (ownership.addr != address(0)) {
822                 return ownership;
823             }
824         }
825 
826         revert('ERC721A: unable to determine the owner of token');
827     }
828 
829     /**
830      * @dev See {IERC721-ownerOf}.
831      */
832     function ownerOf(uint256 tokenId) public view override returns (address) {
833         return ownershipOf(tokenId).addr;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-name}.
838      */
839     function name() public view virtual override returns (string memory) {
840         return _name;
841     }
842 
843     /**
844      * @dev See {IERC721Metadata-symbol}.
845      */
846     function symbol() public view virtual override returns (string memory) {
847         return _symbol;
848     }
849 
850     /**
851      * @dev See {IERC721Metadata-tokenURI}.
852      */
853     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
854         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
855 
856         string memory baseURI = _baseURI();
857         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
858     }
859 
860     /**
861      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
862      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
863      * by default, can be overriden in child contracts.
864      */
865     function _baseURI() internal view virtual returns (string memory) {
866         return '';
867     }
868 
869     /**
870      * @dev See {IERC721-approve}.
871      */
872     function approve(address to, uint256 tokenId) public override {
873         address owner = ERC721A.ownerOf(tokenId);
874         require(to != owner, 'ERC721A: approval to current owner');
875 
876         require(
877             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
878             'ERC721A: approve caller is not owner nor approved for all'
879         );
880 
881         _approve(to, tokenId, owner);
882     }
883 
884     /**
885      * @dev See {IERC721-getApproved}.
886      */
887     function getApproved(uint256 tokenId) public view override returns (address) {
888         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
889 
890         return _tokenApprovals[tokenId];
891     }
892 
893     /**
894      * @dev See {IERC721-setApprovalForAll}.
895      */
896     function setApprovalForAll(address operator, bool approved) public override {
897         require(operator != _msgSender(), 'ERC721A: approve to caller');
898 
899         _operatorApprovals[_msgSender()][operator] = approved;
900         emit ApprovalForAll(_msgSender(), operator, approved);
901     }
902 
903     /**
904      * @dev See {IERC721-isApprovedForAll}.
905      */
906     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
907         return _operatorApprovals[owner][operator];
908     }
909 
910     /**
911      * @dev See {IERC721-transferFrom}.
912      */
913     function transferFrom(
914         address from,
915         address to,
916         uint256 tokenId
917     ) public override {
918         _transfer(from, to, tokenId);
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) public override {
929         safeTransferFrom(from, to, tokenId, '');
930     }
931 
932     /**
933      * @dev See {IERC721-safeTransferFrom}.
934      */
935     function safeTransferFrom(
936         address from,
937         address to,
938         uint256 tokenId,
939         bytes memory _data
940     ) public override {
941         _transfer(from, to, tokenId);
942         require(
943             _checkOnERC721Received(from, to, tokenId, _data),
944             'ERC721A: transfer to non ERC721Receiver implementer'
945         );
946     }
947 
948     /**
949      * @dev Returns whether `tokenId` exists.
950      *
951      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
952      *
953      * Tokens start existing when they are minted (`_mint`),
954      */
955     function _exists(uint256 tokenId) internal view returns (bool) {
956         return tokenId < currentIndex;
957     }
958 
959     function _safeMint(address to, uint256 quantity) internal {
960         _safeMint(to, quantity, '');
961     }
962 
963     /**
964      * @dev Mints `quantity` tokens and transfers them to `to`.
965      *
966      * Requirements:
967      *
968      * - `to` cannot be the zero address.
969      * - `quantity` cannot be larger than the max batch size.
970      *
971      * Emits a {Transfer} event.
972      */
973     function _safeMint(
974         address to,
975         uint256 quantity,
976         bytes memory _data
977     ) internal {
978         uint256 startTokenId = currentIndex;
979         require(to != address(0), 'ERC721A: mint to the zero address');
980         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
981         require(!_exists(startTokenId), 'ERC721A: token already minted');
982         require(quantity > 0, 'ERC721A: quantity must be greater 0');
983 
984         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
985 
986         AddressData memory addressData = _addressData[to];
987         _addressData[to] = AddressData(
988             addressData.balance + uint128(quantity),
989             addressData.numberMinted + uint128(quantity)
990         );
991         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
992 
993         uint256 updatedIndex = startTokenId;
994 
995         for (uint256 i = 0; i < quantity; i++) {
996             emit Transfer(address(0), to, updatedIndex);
997             require(
998                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
999                 'ERC721A: transfer to non ERC721Receiver implementer'
1000             );
1001             updatedIndex++;
1002         }
1003 
1004         currentIndex = updatedIndex;
1005         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1006     }
1007 
1008     /**
1009      * @dev Transfers `tokenId` from `from` to `to`.
1010      *
1011      * Requirements:
1012      *
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must be owned by `from`.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function _transfer(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) private {
1023         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1024 
1025         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1026             getApproved(tokenId) == _msgSender() ||
1027             isApprovedForAll(prevOwnership.addr, _msgSender()));
1028 
1029         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1030 
1031         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1032         require(to != address(0), 'ERC721A: transfer to the zero address');
1033 
1034         _beforeTokenTransfers(from, to, tokenId, 1);
1035 
1036         // Clear approvals from the previous owner
1037         _approve(address(0), tokenId, prevOwnership.addr);
1038 
1039         // Underflow of the sender's balance is impossible because we check for
1040         // ownership above and the recipient's balance can't realistically overflow.
1041         unchecked {
1042             _addressData[from].balance -= 1;
1043             _addressData[to].balance += 1;
1044         }
1045 
1046         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1047 
1048         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1049         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1050         uint256 nextTokenId = tokenId + 1;
1051         if (_ownerships[nextTokenId].addr == address(0)) {
1052             if (_exists(nextTokenId)) {
1053                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1054             }
1055         }
1056 
1057         emit Transfer(from, to, tokenId);
1058         _afterTokenTransfers(from, to, tokenId, 1);
1059     }
1060 
1061     /**
1062      * @dev Approve `to` to operate on `tokenId`
1063      *
1064      * Emits a {Approval} event.
1065      */
1066     function _approve(
1067         address to,
1068         uint256 tokenId,
1069         address owner
1070     ) private {
1071         _tokenApprovals[tokenId] = to;
1072         emit Approval(owner, to, tokenId);
1073     }
1074 
1075     /**
1076      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1077      * The call is not executed if the target address is not a contract.
1078      *
1079      * @param from address representing the previous owner of the given token ID
1080      * @param to target address that will receive the tokens
1081      * @param tokenId uint256 ID of the token to be transferred
1082      * @param _data bytes optional data to send along with the call
1083      * @return bool whether the call correctly returned the expected magic value
1084      */
1085     function _checkOnERC721Received(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) private returns (bool) {
1091         if (to.isContract()) {
1092             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1093                 return retval == IERC721Receiver(to).onERC721Received.selector;
1094             } catch (bytes memory reason) {
1095                 if (reason.length == 0) {
1096                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1097                 } else {
1098                     assembly {
1099                         revert(add(32, reason), mload(reason))
1100                     }
1101                 }
1102             }
1103         } else {
1104             return true;
1105         }
1106     }
1107 
1108     /**
1109      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1110      *
1111      * startTokenId - the first token id to be transferred
1112      * quantity - the amount to be transferred
1113      *
1114      * Calling conditions:
1115      *
1116      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1117      * transferred to `to`.
1118      * - When `from` is zero, `tokenId` will be minted for `to`.
1119      */
1120     function _beforeTokenTransfers(
1121         address from,
1122         address to,
1123         uint256 startTokenId,
1124         uint256 quantity
1125     ) internal virtual {}
1126 
1127     /**
1128      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1129      * minting.
1130      *
1131      * startTokenId - the first token id to be transferred
1132      * quantity - the amount to be transferred
1133      *
1134      * Calling conditions:
1135      *
1136      * - when `from` and `to` are both non-zero.
1137      * - `from` and `to` are never both zero.
1138      */
1139     function _afterTokenTransfers(
1140         address from,
1141         address to,
1142         uint256 startTokenId,
1143         uint256 quantity
1144     ) internal virtual {}
1145 }
1146 
1147 contract NotBoryokuDragons is ERC721A, Ownable {
1148 
1149     string public baseURI = "ipfs://QmWeVBBUUb6gCFNndmYqMNF4xx8MSaB9aV1dVr7c2kfZzJ/";
1150     string public constant baseExtension = ".json";
1151     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1152 
1153     uint256 public constant MAX_PER_TX = 1;
1154     uint256 public constant MAX_PER_WALLET = 1;
1155     uint256 public constant MAX_SUPPLY = 555;
1156     uint256 public constant price = 0 ether;
1157 
1158     bool public paused = false;
1159 
1160     mapping(address => uint256) public addressMinted;
1161 
1162     constructor() ERC721A("NotBoryokuDragons", "NBD") {}
1163 
1164     function mint(uint256 _amount) external payable {
1165         address _caller = _msgSender();
1166         require(!paused, "Paused");
1167         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1168         require(_amount > 0, "No 0 mints");
1169         require(tx.origin == _caller, "No contracts");
1170         require(addressMinted[msg.sender] + _amount <= MAX_PER_WALLET, "Exceeds max per wallet");
1171         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1172         require(_amount * price == msg.value, "Invalid funds provided");
1173          addressMinted[msg.sender] += _amount;
1174         _safeMint(_caller, _amount);
1175     }
1176 
1177     function isApprovedForAll(address owner, address operator)
1178         override
1179         public
1180         view
1181         returns (bool)
1182     {
1183         // Whitelist OpenSea proxy contract for easy trading.
1184         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1185         if (address(proxyRegistry.proxies(owner)) == operator) {
1186             return true;
1187         }
1188 
1189         return super.isApprovedForAll(owner, operator);
1190     }
1191 
1192     function withdraw() external onlyOwner {
1193         uint256 balance = address(this).balance;
1194         (bool success, ) = _msgSender().call{value: balance}("");
1195         require(success, "Failed to send");
1196     }
1197 
1198     function pause(bool _state) external onlyOwner {
1199         paused = _state;
1200     }
1201 
1202     function setBaseURI(string memory baseURI_) external onlyOwner {
1203         baseURI = baseURI_;
1204     }
1205 
1206     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1207         require(_exists(_tokenId), "Token does not exist.");
1208         return bytes(baseURI).length > 0 ? string(
1209             abi.encodePacked(
1210               baseURI,
1211               Strings.toString(_tokenId),
1212               baseExtension
1213             )
1214         ) : "";
1215     }
1216 }
1217 
1218 contract OwnableDelegateProxy { }
1219 contract ProxyRegistry {
1220     mapping(address => OwnableDelegateProxy) public proxies;
1221 }