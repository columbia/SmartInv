1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
3 
4 /*
5 ░░░░░░░░▄██▄░░░░░░▄▄░░
6 ░░░░░░░▐███▀░░░░░▄███▌
7 ░░▄▀░░▄█▀▀░░░░░░░░▀██░
8 ░█░░░██░░░░░░░░░░░░░░░
9 █▌░░▐██░░▄██▌░░▄▄▄░░░▄
10 ██░░▐██▄░▀█▀░░░▀██░░▐▌
11 ██▄░▐███▄▄░░▄▄▄░▀▀░▄██
12 ▐███▄██████▄░▀░▄█████▌
13 ▐████████████▀▀██████░
14 ░▐████▀██████░░█████░░
15 ░░░▀▀▀░░█████▌░████▀░░
16 ░░░░░░░░░▀▀███░▀▀▀░░░░ 
17 
18 */
19 
20 
21 
22 pragma solidity ^0.8.0;
23 
24 
25 
26 
27 error ApprovalCallerNotOwnerNorApproved();
28 error ApprovalQueryForNonexistentToken();
29 error ApproveToCaller();
30 error ApprovalToCurrentOwner();
31 error BalanceQueryForZeroAddress();
32 error MintToZeroAddress();
33 error MintZeroQuantity();
34 error OwnerQueryForNonexistentToken();
35 error TransferCallerNotOwnerNorApproved();
36 error TransferFromIncorrectOwner();
37 error TransferToNonERC721ReceiverImplementer();
38 error TransferToZeroAddress();
39 error URIQueryForNonexistentToken();
40 error OwnerIndexOutOfBounds();
41 
42 
43 
44 /**
45  * @dev Interface of the ERC165 standard, as defined in the
46  * https://eips.ethereum.org/EIPS/eip-165[EIP].
47  *
48  * Implementers can declare support of contract interfaces, which can then be
49  * queried by others ({ERC165Checker}).
50  *
51  * For an implementation, see {ERC165}.
52  */
53 interface IERC165 {
54     /**
55      * @dev Returns true if this contract implements the interface defined by
56      * `interfaceId`. See the corresponding
57      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
58      * to learn more about how these ids are created.
59      *
60      * This function call must use less than 30 000 gas.
61      */
62     function supportsInterface(bytes4 interfaceId) external view returns (bool);
63 }
64 
65 
66 
67 /**
68  * @dev Required interface of an ERC721 compliant contract.
69  */
70 interface IERC721 is IERC165 {
71     /**
72      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
75 
76     /**
77      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
78      */
79     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
80 
81     /**
82      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
83      */
84     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
85 
86     /**
87      * @dev Returns the number of tokens in ``owner``'s account.
88      */
89     function balanceOf(address owner) external view returns (uint256 balance);
90 
91     /**
92      * @dev Returns the owner of the `tokenId` token.
93      *
94      * Requirements:
95      *
96      * - `tokenId` must exist.
97      */
98     function ownerOf(uint256 tokenId) external view returns (address owner);
99 
100     /**
101      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
102      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
103      *
104      * Requirements:
105      *
106      * - `from` cannot be the zero address.
107      * - `to` cannot be the zero address.
108      * - `tokenId` token must exist and be owned by `from`.
109      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
110      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
111      *
112      * Emits a {Transfer} event.
113      */
114     function safeTransferFrom(
115         address from,
116         address to,
117         uint256 tokenId
118     ) external;
119 
120     /**
121      * @dev Transfers `tokenId` token from `from` to `to`.
122      *
123      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
124      *
125      * Requirements:
126      *
127      * - `from` cannot be the zero address.
128      * - `to` cannot be the zero address.
129      * - `tokenId` token must be owned by `from`.
130      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transferFrom(
135         address from,
136         address to,
137         uint256 tokenId
138     ) external;
139 
140     /**
141      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
142      * The approval is cleared when the token is transferred.
143      *
144      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
145      *
146      * Requirements:
147      *
148      * - The caller must own the token or be an approved operator.
149      * - `tokenId` must exist.
150      *
151      * Emits an {Approval} event.
152      */
153     function approve(address to, uint256 tokenId) external;
154 
155     /**
156      * @dev Returns the account approved for `tokenId` token.
157      *
158      * Requirements:
159      *
160      * - `tokenId` must exist.
161      */
162     function getApproved(uint256 tokenId) external view returns (address operator);
163 
164     /**
165      * @dev Approve or remove `operator` as an operator for the caller.
166      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
167      *
168      * Requirements:
169      *
170      * - The `operator` cannot be the caller.
171      *
172      * Emits an {ApprovalForAll} event.
173      */
174     function setApprovalForAll(address operator, bool _approved) external;
175 
176     /**
177      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
178      *
179      * See {setApprovalForAll}
180      */
181     function isApprovedForAll(address owner, address operator) external view returns (bool);
182 
183     /**
184      * @dev Safely transfers `tokenId` token from `from` to `to`.
185      *
186      * Requirements:
187      *
188      * - `from` cannot be the zero address.
189      * - `to` cannot be the zero address.
190      * - `tokenId` token must exist and be owned by `from`.
191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
193      *
194      * Emits a {Transfer} event.
195      */
196     function safeTransferFrom(
197         address from,
198         address to,
199         uint256 tokenId,
200         bytes calldata data
201     ) external;
202 }
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Enumerable is IERC721 {
209     /**
210      * @dev Returns the total amount of tokens stored by the contract.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     /**
215      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
216      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
217      */
218     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
219 
220     /**
221      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
222      * Use along with {totalSupply} to enumerate all tokens.
223      */
224     function tokenByIndex(uint256 index) external view returns (uint256);
225 }
226 
227 /**
228  * @title ERC721 token receiver interface
229  * @dev Interface for any contract that wants to support safeTransfers
230  * from ERC721 asset contracts.
231  */
232 interface IERC721Receiver {
233     /**
234      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
235      * by `operator` from `from`, this function is called.
236      *
237      * It must return its Solidity selector to confirm the token transfer.
238      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
239      *
240      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
241      */
242     function onERC721Received(
243         address operator,
244         address from,
245         uint256 tokenId,
246         bytes calldata data
247     ) external returns (bytes4);
248 }
249 
250 
251 /**
252  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
253  * @dev See https://eips.ethereum.org/EIPS/eip-721
254  */
255 interface IERC721Metadata is IERC721 {
256     /**
257      * @dev Returns the token collection name.
258      */
259     function name() external view returns (string memory);
260 
261     /**
262      * @dev Returns the token collection symbol.
263      */
264     function symbol() external view returns (string memory);
265 
266     /**
267      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
268      */
269     function tokenURI(uint256 tokenId) external view returns (string memory);
270 }
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // This method relies on extcodesize, which returns 0 for contracts in
295         // construction, since the code is only stored at the end of the
296         // constructor execution.
297 
298         uint256 size;
299         assembly {
300             size := extcodesize(account)
301         }
302         return size > 0;
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         (bool success, ) = recipient.call{value: amount}("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain `call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(
357         address target,
358         bytes memory data,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(
390         address target,
391         bytes memory data,
392         uint256 value,
393         string memory errorMessage
394     ) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         require(isContract(target), "Address: call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.call{value: value}(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
404      * but performing a static call.
405      *
406      * _Available since v3.3._
407      */
408     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
409         return functionStaticCall(target, data, "Address: low-level static call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
414      * but performing a static call.
415      *
416      * _Available since v3.3._
417      */
418     function functionStaticCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal view returns (bytes memory) {
423         require(isContract(target), "Address: static call to non-contract");
424 
425         (bool success, bytes memory returndata) = target.staticcall(data);
426         return verifyCallResult(success, returndata, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but performing a delegate call.
432      *
433      * _Available since v3.4._
434      */
435     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
436         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
441      * but performing a delegate call.
442      *
443      * _Available since v3.4._
444      */
445     function functionDelegateCall(
446         address target,
447         bytes memory data,
448         string memory errorMessage
449     ) internal returns (bytes memory) {
450         require(isContract(target), "Address: delegate call to non-contract");
451 
452         (bool success, bytes memory returndata) = target.delegatecall(data);
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
458      * revert reason using the provided one.
459      *
460      * _Available since v4.3._
461      */
462     function verifyCallResult(
463         bool success,
464         bytes memory returndata,
465         string memory errorMessage
466     ) internal pure returns (bytes memory) {
467         if (success) {
468             return returndata;
469         } else {
470             // Look for revert reason and bubble it up if present
471             if (returndata.length > 0) {
472                 // The easiest way to bubble the revert reason is using memory via assembly
473 
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 
486 /**
487  * @dev Provides information about the current execution context, including the
488  * sender of the transaction and its data. While these are generally available
489  * via msg.sender and msg.data, they should not be accessed in such a direct
490  * manner, since when dealing with meta-transactions the account sending and
491  * paying for execution may not be the actual sender (as far as an application
492  * is concerned).
493  *
494  * This contract is only required for intermediate, library-like contracts.
495  */
496 abstract contract Context {
497     function _msgSender() internal view virtual returns (address) {
498         return msg.sender;
499     }
500 
501     function _msgData() internal view virtual returns (bytes calldata) {
502         return msg.data;
503     }
504 }
505 
506 
507 /**
508  * @dev String operations.
509  */
510 library Strings {
511     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
512 
513     /**
514      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
515      */
516     function toString(uint256 value) internal pure returns (string memory) {
517         // Inspired by OraclizeAPI's implementation - MIT licence
518         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
519 
520         if (value == 0) {
521             return "0";
522         }
523         uint256 temp = value;
524         uint256 digits;
525         while (temp != 0) {
526             digits++;
527             temp /= 10;
528         }
529         bytes memory buffer = new bytes(digits);
530         while (value != 0) {
531             digits -= 1;
532             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
533             value /= 10;
534         }
535         return string(buffer);
536     }
537 
538     /**
539      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
540      */
541     function toHexString(uint256 value) internal pure returns (string memory) {
542         if (value == 0) {
543             return "0x00";
544         }
545         uint256 temp = value;
546         uint256 length = 0;
547         while (temp != 0) {
548             length++;
549             temp >>= 8;
550         }
551         return toHexString(value, length);
552     }
553 
554     /**
555      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
556      */
557     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
558         bytes memory buffer = new bytes(2 * length + 2);
559         buffer[0] = "0";
560         buffer[1] = "x";
561         for (uint256 i = 2 * length + 1; i > 1; --i) {
562             buffer[i] = _HEX_SYMBOLS[value & 0xf];
563             value >>= 4;
564         }
565         require(value == 0, "Strings: hex length insufficient");
566         return string(buffer);
567     }
568 }
569 
570 /**
571  * @dev Implementation of the {IERC165} interface.
572  *
573  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
574  * for the additional interface id that will be supported. For example:
575  *
576  * ```solidity
577  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
578  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
579  * }
580  * ```
581  *
582  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
583  */
584 abstract contract ERC165 is IERC165 {
585     /**
586      * @dev See {IERC165-supportsInterface}.
587      */
588     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589         return interfaceId == type(IERC165).interfaceId;
590     }
591 }
592 
593 
594 
595 /**
596  * @dev Contract module which provides a basic access control mechanism, where
597  * there is an account (an owner) that can be granted exclusive access to
598  * specific functions.
599  *
600  * By default, the owner account will be the one that deploys the contract. This
601  * can later be changed with {transferOwnership}.
602  *
603  * This module is used through inheritance. It will make available the modifier
604  * `onlyOwner`, which can be applied to your functions to restrict their use to
605  * the owner.
606  */
607 abstract contract Ownable is Context {
608     address private _owner;
609 
610     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
611 
612     /**
613      * @dev Initializes the contract setting the deployer as the initial owner.
614      */
615     constructor() {
616         _transferOwnership(_msgSender());
617     }
618 
619     /**
620      * @dev Returns the address of the current owner.
621      */
622     function owner() public view virtual returns (address) {
623         return _owner;
624     }
625 
626     /**
627      * @dev Throws if called by any account other than the owner.
628      */
629     modifier onlyOwner() {
630         require(owner() == _msgSender(), "Ownable: caller is not the owner");
631         _;
632     }
633 
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * NOTE: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public virtual onlyOwner {
642         _transferOwnership(address(0));
643     }
644 
645     /**
646      * @dev Transfers ownership of the contract to a new account (`newOwner`).
647      * Can only be called by the current owner.
648      */
649     function transferOwnership(address newOwner) public virtual onlyOwner {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         _transferOwnership(newOwner);
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Internal function without access restriction.
657      */
658     function _transferOwnership(address newOwner) internal virtual {
659         address oldOwner = _owner;
660         _owner = newOwner;
661         emit OwnershipTransferred(oldOwner, newOwner);
662     }
663 }
664 
665 
666 /**
667  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
668  * the Metadata extension. Built to optimize for lower gas during batch mints.
669  *
670  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
671  *
672  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
673  *
674  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
675  */
676 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
677     using Address for address;
678     using Strings for uint256;
679 
680     // Compiler will pack this into a single 256bit word.
681     struct TokenOwnership {
682         // The address of the owner.
683         address addr;
684         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
685         uint64 startTimestamp;
686         // Whether the token has been burned.
687         bool burned;
688     }
689 
690     // Compiler will pack this into a single 256bit word.
691     struct AddressData {
692         // Realistically, 2**64-1 is more than enough.
693         uint64 balance;
694         // Keeps track of mint count with minimal overhead for tokenomics.
695         uint64 numberMinted;
696         // Keeps track of burn count with minimal overhead for tokenomics.
697         uint64 numberBurned;
698         // For miscellaneous variable(s) pertaining to the address
699         // (e.g. number of whitelist mint slots used).
700         // If there are multiple variables, please pack them into a uint64.
701         uint64 aux;
702     }
703 
704     // The tokenId of the next token to be minted.
705     uint256 internal _currentIndex;
706 
707     // The number of tokens burned.
708     uint256 internal _burnCounter;
709 
710     // Token name
711     string private _name;
712 
713     // Token symbol
714     string private _symbol;
715 
716     // Mapping from token ID to ownership details
717     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
718     mapping(uint256 => TokenOwnership) internal _ownerships;
719 
720     // Mapping owner address to address data
721     mapping(address => AddressData) private _addressData;
722 
723     // Mapping from token ID to approved address
724     mapping(uint256 => address) private _tokenApprovals;
725 
726     // Mapping from owner to operator approvals
727     mapping(address => mapping(address => bool)) private _operatorApprovals;
728 
729     constructor(string memory name_, string memory symbol_) {
730         _name = name_;
731         _symbol = symbol_;
732         _currentIndex = _startTokenId();
733     }
734 
735     /**
736      * To change the starting tokenId, please override this function.
737      */
738     function _startTokenId() internal view virtual returns (uint256) {
739         return 0;
740     }
741 
742     /**
743      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
744      */
745     function totalSupply() override public view returns (uint256) {
746         // Counter underflow is impossible as _burnCounter cannot be incremented
747         // more than _currentIndex - _startTokenId() times
748         unchecked {
749             return _currentIndex - _burnCounter - _startTokenId();
750         }
751     }
752 
753     /**
754      * Returns the total amount of tokens minted in the contract.
755      */
756     function _totalMinted() internal view returns (uint256) {
757         // Counter underflow is impossible as _currentIndex does not decrement,
758         // and it is initialized to _startTokenId()
759         unchecked {
760             return _currentIndex - _startTokenId();
761         }
762     }
763 
764     /**
765      * @dev See {IERC165-supportsInterface}.
766      */
767     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
768         return
769             interfaceId == type(IERC721).interfaceId ||
770             interfaceId == type(IERC721Metadata).interfaceId ||
771             interfaceId == type(IERC721Enumerable).interfaceId ||
772             super.supportsInterface(interfaceId);
773     }
774 
775     /**
776      * @dev See {IERC721-balanceOf}.
777      */
778     function balanceOf(address owner) public view override returns (uint256) {
779         if (owner == address(0)) revert BalanceQueryForZeroAddress();
780         return uint256(_addressData[owner].balance);
781     }
782 
783     /**
784      * Returns the number of tokens minted by `owner`.
785      */
786     function _numberMinted(address owner) internal view returns (uint256) {
787         return uint256(_addressData[owner].numberMinted);
788     }
789 
790     /**
791      * Returns the number of tokens burned by or on behalf of `owner`.
792      */
793     function _numberBurned(address owner) internal view returns (uint256) {
794         return uint256(_addressData[owner].numberBurned);
795     }
796 
797     /**
798      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
799      */
800     function _getAux(address owner) internal view returns (uint64) {
801         return _addressData[owner].aux;
802     }
803 
804     /**
805      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
806      * If there are multiple variables, please pack them into a uint64.
807      */
808     function _setAux(address owner, uint64 aux) internal {
809         _addressData[owner].aux = aux;
810     }
811 
812 
813 
814     /**
815      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
816      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
817      */
818     function tokenOfOwnerByIndex(address owner, uint256 index) override external view returns (uint256) {
819         uint256 currCount = 0;
820         uint256 currSupply = _currentIndex;
821         bool counting = false; 
822         TokenOwnership memory ownership; 
823         unchecked {
824             for (uint256 i = _startTokenId(); i < currSupply; ++i) {
825                 ownership = _ownerships[i];
826                 if (ownership.burned) {
827                     continue;
828                 }
829                 if(ownership.addr == owner) {
830                     counting = true; 
831                     currCount++;
832                 } else if(ownership.addr == address(0)) {
833                     if(counting) currCount++;
834                 } else {
835                     counting = false; 
836                 }
837                 if(counting && index == (currCount - 1)) {
838                     return i; 
839                 }
840             }
841         }
842         revert OwnerIndexOutOfBounds();
843     }
844 
845     /**
846      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
847      * Use along with {totalSupply} to enumerate all tokens.
848      */
849     function tokenByIndex(uint256 index) override external pure returns (uint256) {
850         return index; 
851     }
852 
853 
854     /**
855      * @dev Returns the tokenIds of the address. O(totalSupply) in complexity.
856      */
857     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
858         uint256 holdingAmount = balanceOf(owner);
859         uint256 currSupply = _currentIndex;
860         uint256 tokenIdsIdx;
861         address currOwnershipAddr;
862 
863         uint256[] memory list = new uint256[](holdingAmount);
864 
865         unchecked {
866             for (uint256 i = _startTokenId(); i < currSupply; ++i) {
867                 TokenOwnership memory ownership = _ownerships[i];
868 
869                 if (ownership.burned) {
870                     continue;
871                 }
872 
873                 // Find out who owns this sequence
874                 if (ownership.addr != address(0)) {
875                     currOwnershipAddr = ownership.addr;
876                 }
877 
878                 // Append tokens the last found owner owns in the sequence
879                 if (currOwnershipAddr == owner) {
880                     list[tokenIdsIdx++] = i;
881                 }
882 
883                 // All tokens have been found, we don't need to keep searching
884                 if (tokenIdsIdx == holdingAmount) {
885                     break;
886                 }
887             }
888         }
889 
890         return list;
891     }
892 
893 
894 
895     /**
896      * Gas spent here starts off proportional to the maximum mint batch size.
897      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
898      */
899     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
900         uint256 curr = tokenId;
901 
902         unchecked {
903             if (_startTokenId() <= curr && curr < _currentIndex) {
904                 TokenOwnership memory ownership = _ownerships[curr];
905                 if (!ownership.burned) {
906                     if (ownership.addr != address(0)) {
907                         return ownership;
908                     }
909                     // Invariant:
910                     // There will always be an ownership that has an address and is not burned
911                     // before an ownership that does not have an address and is not burned.
912                     // Hence, curr will not underflow.
913                     while (true) {
914                         curr--;
915                         ownership = _ownerships[curr];
916                         if (ownership.addr != address(0)) {
917                             return ownership;
918                         }
919                     }
920                 }
921             }
922         }
923         revert OwnerQueryForNonexistentToken();
924     }
925 
926     /**
927      * @dev See {IERC721-ownerOf}.
928      */
929     function ownerOf(uint256 tokenId) public view override returns (address) {
930         return _ownershipOf(tokenId).addr;
931     }
932 
933     /**
934      * @dev See {IERC721Metadata-name}.
935      */
936     function name() public view virtual override returns (string memory) {
937         return _name;
938     }
939 
940     /**
941      * @dev See {IERC721Metadata-symbol}.
942      */
943     function symbol() public view virtual override returns (string memory) {
944         return _symbol;
945     }
946 
947     /**
948      * @dev See {IERC721Metadata-tokenURI}.
949      */
950     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
951         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
952 
953         string memory baseURI = _baseURI();
954         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
955     }
956 
957     /**
958      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
959      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
960      * by default, can be overriden in child contracts.
961      */
962     function _baseURI() internal view virtual returns (string memory) {
963         return '';
964     }
965 
966     /**
967      * @dev See {IERC721-approve}.
968      */
969     function approve(address to, uint256 tokenId) public override {
970         address owner = ERC721A.ownerOf(tokenId);
971         if (to == owner) revert ApprovalToCurrentOwner();
972 
973         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
974             revert ApprovalCallerNotOwnerNorApproved();
975         }
976 
977         _approve(to, tokenId, owner);
978     }
979 
980     /**
981      * @dev See {IERC721-getApproved}.
982      */
983     function getApproved(uint256 tokenId) public view override returns (address) {
984         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
985 
986         return _tokenApprovals[tokenId];
987     }
988 
989     /**
990      * @dev See {IERC721-setApprovalForAll}.
991      */
992     function setApprovalForAll(address operator, bool approved) public virtual override {
993         if (operator == _msgSender()) revert ApproveToCaller();
994 
995         _operatorApprovals[_msgSender()][operator] = approved;
996         emit ApprovalForAll(_msgSender(), operator, approved);
997     }
998 
999     /**
1000      * @dev See {IERC721-isApprovedForAll}.
1001      */
1002     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1003         return _operatorApprovals[owner][operator];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-transferFrom}.
1008      */
1009     function transferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         _transfer(from, to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public virtual override {
1025         safeTransferFrom(from, to, tokenId, '');
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-safeTransferFrom}.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1039             revert TransferToNonERC721ReceiverImplementer();
1040         }
1041     }
1042 
1043     /**
1044      * @dev Returns whether `tokenId` exists.
1045      *
1046      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1047      *
1048      * Tokens start existing when they are minted (`_mint`),
1049      */
1050     function _exists(uint256 tokenId) internal view returns (bool) {
1051         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1052             !_ownerships[tokenId].burned;
1053     }
1054 
1055     function _safeMint(address to, uint256 quantity) internal {
1056         _safeMint(to, quantity, '');
1057     }
1058 
1059     /**
1060      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1065      * - `quantity` must be greater than 0.
1066      *
1067      * Emits a {Transfer} event.
1068      */
1069     function _safeMint(
1070         address to,
1071         uint256 quantity,
1072         bytes memory _data
1073     ) internal {
1074         _mint(to, quantity, _data, true);
1075     }
1076 
1077     /**
1078      * @dev Mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - `to` cannot be the zero address.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _mint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data,
1091         bool safe
1092     ) internal {
1093         uint256 startTokenId = _currentIndex;
1094         if (to == address(0)) revert MintToZeroAddress();
1095         if (quantity == 0) revert MintZeroQuantity();
1096 
1097         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1098 
1099         // Overflows are incredibly unrealistic.
1100         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1101         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1102         unchecked {
1103             _addressData[to].balance += uint64(quantity);
1104             _addressData[to].numberMinted += uint64(quantity);
1105 
1106             _ownerships[startTokenId].addr = to;
1107             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1108 
1109             uint256 updatedIndex = startTokenId;
1110             uint256 end = updatedIndex + quantity;
1111 
1112             if (safe && to.isContract()) {
1113                 do {
1114                     emit Transfer(address(0), to, updatedIndex);
1115                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1116                         revert TransferToNonERC721ReceiverImplementer();
1117                     }
1118                 } while (updatedIndex != end);
1119                 // Reentrancy protection
1120                 if (_currentIndex != startTokenId) revert();
1121             } else {
1122                 do {
1123                     emit Transfer(address(0), to, updatedIndex++);
1124                 } while (updatedIndex != end);
1125             }
1126             _currentIndex = updatedIndex;
1127         }
1128         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1129     }
1130 
1131     /**
1132      * @dev Transfers `tokenId` from `from` to `to`.
1133      *
1134      * Requirements:
1135      *
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must be owned by `from`.
1138      *
1139      * Emits a {Transfer} event.
1140      */
1141     function _transfer(
1142         address from,
1143         address to,
1144         uint256 tokenId
1145     ) private {
1146         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1147 
1148         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1149 
1150         bool isApprovedOrOwner = (_msgSender() == from ||
1151             isApprovedForAll(from, _msgSender()) ||
1152             getApproved(tokenId) == _msgSender());
1153 
1154         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1155         if (to == address(0)) revert TransferToZeroAddress();
1156 
1157         _beforeTokenTransfers(from, to, tokenId, 1);
1158 
1159         // Clear approvals from the previous owner
1160         _approve(address(0), tokenId, from);
1161 
1162         // Underflow of the sender's balance is impossible because we check for
1163         // ownership above and the recipient's balance can't realistically overflow.
1164         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1165         unchecked {
1166             _addressData[from].balance -= 1;
1167             _addressData[to].balance += 1;
1168 
1169             TokenOwnership storage currSlot = _ownerships[tokenId];
1170             currSlot.addr = to;
1171             currSlot.startTimestamp = uint64(block.timestamp);
1172 
1173             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1174             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1175             uint256 nextTokenId = tokenId + 1;
1176             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1177             if (nextSlot.addr == address(0)) {
1178                 // This will suffice for checking _exists(nextTokenId),
1179                 // as a burned slot cannot contain the zero address.
1180                 if (nextTokenId != _currentIndex) {
1181                     nextSlot.addr = from;
1182                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1183                 }
1184             }
1185         }
1186 
1187         emit Transfer(from, to, tokenId);
1188         _afterTokenTransfers(from, to, tokenId, 1);
1189     }
1190 
1191     /**
1192      * @dev This is equivalent to _burn(tokenId, false)
1193      */
1194     function _burn(uint256 tokenId) internal virtual {
1195         _burn(tokenId, false);
1196     }
1197 
1198     /**
1199      * @dev Destroys `tokenId`.
1200      * The approval is cleared when the token is burned.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must exist.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1209         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1210 
1211         address from = prevOwnership.addr;
1212 
1213         if (approvalCheck) {
1214             bool isApprovedOrOwner = (_msgSender() == from ||
1215                 isApprovedForAll(from, _msgSender()) ||
1216                 getApproved(tokenId) == _msgSender());
1217 
1218             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1219         }
1220 
1221         _beforeTokenTransfers(from, address(0), tokenId, 1);
1222 
1223         // Clear approvals from the previous owner
1224         _approve(address(0), tokenId, from);
1225 
1226         // Underflow of the sender's balance is impossible because we check for
1227         // ownership above and the recipient's balance can't realistically overflow.
1228         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1229         unchecked {
1230             AddressData storage addressData = _addressData[from];
1231             addressData.balance -= 1;
1232             addressData.numberBurned += 1;
1233 
1234             // Keep track of who burned the token, and the timestamp of burning.
1235             TokenOwnership storage currSlot = _ownerships[tokenId];
1236             currSlot.addr = from;
1237             currSlot.startTimestamp = uint64(block.timestamp);
1238             currSlot.burned = true;
1239 
1240             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1241             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1242             uint256 nextTokenId = tokenId + 1;
1243             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1244             if (nextSlot.addr == address(0)) {
1245                 // This will suffice for checking _exists(nextTokenId),
1246                 // as a burned slot cannot contain the zero address.
1247                 if (nextTokenId != _currentIndex) {
1248                     nextSlot.addr = from;
1249                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1250                 }
1251             }
1252         }
1253 
1254         emit Transfer(from, address(0), tokenId);
1255         _afterTokenTransfers(from, address(0), tokenId, 1);
1256 
1257         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1258         unchecked {
1259             _burnCounter++;
1260         }
1261     }
1262 
1263     /**
1264      * @dev Approve `to` to operate on `tokenId`
1265      *
1266      * Emits a {Approval} event.
1267      */
1268     function _approve(
1269         address to,
1270         uint256 tokenId,
1271         address owner
1272     ) private {
1273         _tokenApprovals[tokenId] = to;
1274         emit Approval(owner, to, tokenId);
1275     }
1276 
1277     /**
1278      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1279      *
1280      * @param from address representing the previous owner of the given token ID
1281      * @param to target address that will receive the tokens
1282      * @param tokenId uint256 ID of the token to be transferred
1283      * @param _data bytes optional data to send along with the call
1284      * @return bool whether the call correctly returned the expected magic value
1285      */
1286     function _checkContractOnERC721Received(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes memory _data
1291     ) private returns (bool) {
1292         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1293             return retval == IERC721Receiver(to).onERC721Received.selector;
1294         } catch (bytes memory reason) {
1295             if (reason.length == 0) {
1296                 revert TransferToNonERC721ReceiverImplementer();
1297             } else {
1298                 assembly {
1299                     revert(add(32, reason), mload(reason))
1300                 }
1301             }
1302         }
1303     }
1304 
1305     /**
1306      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1307      * And also called before burning one token.
1308      *
1309      * startTokenId - the first token id to be transferred
1310      * quantity - the amount to be transferred
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` will be minted for `to`.
1317      * - When `to` is zero, `tokenId` will be burned by `from`.
1318      * - `from` and `to` are never both zero.
1319      */
1320     function _beforeTokenTransfers(
1321         address from,
1322         address to,
1323         uint256 startTokenId,
1324         uint256 quantity
1325     ) internal virtual {}
1326 
1327     /**
1328      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1329      * minting.
1330      * And also called after one token has been burned.
1331      *
1332      * startTokenId - the first token id to be transferred
1333      * quantity - the amount to be transferred
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` has been minted for `to`.
1340      * - When `to` is zero, `tokenId` has been burned by `from`.
1341      * - `from` and `to` are never both zero.
1342      */
1343     function _afterTokenTransfers(
1344         address from,
1345         address to,
1346         uint256 startTokenId,
1347         uint256 quantity
1348     ) internal virtual {}
1349 }
1350 
1351 
1352 abstract contract PixieJars {
1353     function balanceOf(address owner) public view virtual returns (uint256);
1354 }
1355 
1356 contract Pandies is ERC721A, Ownable {
1357 
1358     // Minting Variables
1359     uint256 public maxPerWalletNonHolder = 1;
1360     uint256 public maxPerWalletHolder = 2;
1361     uint256 public holderReserve = 3500;
1362     uint256 constant public maxSupply = 10000;
1363     PixieJars pjContract = PixieJars(0xeA508034fCC8eefF24bF43effe42621008359A2E);
1364 
1365     mapping(address => uint256) public mintedPerWallet;
1366 
1367     // Sale Status
1368     bool public saleIsActive = false;
1369 
1370     // Metadata
1371     string _baseTokenURI = "";
1372     string _prerevealTokenURI = "";
1373     string _contractURI = "";
1374     bool public locked = false;
1375     bool public revealed = false;
1376 
1377     // Events
1378     event SaleActivation(bool isActive);
1379   
1380     constructor() ERC721A("Pandies", "P") {
1381     }
1382 
1383     function mint() external {
1384         require(saleIsActive, "SALE_INACTIVE");
1385         
1386         bool pjHolder = (pjContract.balanceOf(msg.sender) > 0);
1387         uint256 _count = (pjHolder ? maxPerWalletHolder : maxPerWalletNonHolder);
1388         uint256 _minted = mintedPerWallet[msg.sender];
1389 
1390         require(_minted < _count, "MAX PER WALLET REACHED");
1391         
1392         if(_minted > 0) { _count -= _minted; }
1393         if(totalSupply() < maxSupply && totalSupply() + _count > maxSupply) { _count = maxSupply - totalSupply(); }
1394 
1395         require(
1396             totalSupply() + _count + (pjHolder ? 0 : holderReserve) <= maxSupply,
1397             "SOLD_OUT"
1398         );
1399 
1400         _safeMint(msg.sender, _count);
1401         mintedPerWallet[msg.sender] = _minted + _count;
1402         if(pjHolder) { if(holderReserve > _count) { holderReserve -= _count; } else { holderReserve = 0; } }
1403     }
1404 
1405     function airdrop(address[] calldata recipients, uint256[] calldata count) external onlyOwner {
1406         require(recipients.length == count.length, "Array length mismatch");
1407         uint256 totalCount = 0;
1408         for(uint256 i = 0;i < count.length;i++) {
1409             totalCount += count[i];
1410         }
1411         require(
1412             totalSupply() + totalCount <= maxSupply,
1413             "SOLD_OUT"
1414         );
1415         
1416         for(uint256 i = 0;i < recipients.length;i++) {
1417             _safeMint(recipients[i], count[i]);
1418         }
1419     }
1420 
1421 
1422     function toggleSaleStatus() external onlyOwner {
1423         saleIsActive = !saleIsActive;
1424         emit SaleActivation(saleIsActive);
1425     }
1426 
1427     function setMaxPerWalletNonHolder(uint256 _max) external onlyOwner {
1428         maxPerWalletNonHolder = _max;
1429     }
1430 
1431     function setMaxPerWalletHolder(uint256 _max) external onlyOwner {
1432         maxPerWalletHolder = _max;
1433     }
1434 
1435     function setHolderReserve(uint256 _reserve) external onlyOwner {
1436         holderReserve = _reserve;
1437     }
1438     
1439     function lockMetadata() external onlyOwner {
1440         locked = true;
1441     }
1442     
1443     function toggleRevealed() external onlyOwner {
1444         revealed = !revealed;
1445     }
1446 
1447     function withdraw() external onlyOwner {
1448         payable(owner()).transfer(address(this).balance);
1449     }
1450 
1451 
1452     function getWalletOfOwner(address owner) external view returns (uint256[] memory) {
1453         unchecked {
1454             uint256[] memory a = new uint256[](balanceOf(owner));
1455             uint256 end = _currentIndex;
1456             uint256 tokenIdsIdx;
1457             address currOwnershipAddr;
1458             for (uint256 i; i < end; i++) {
1459                 TokenOwnership memory ownership = _ownerships[i];
1460                 if (ownership.burned) {
1461                     continue;
1462                 }
1463                 if (ownership.addr != address(0)) {
1464                     currOwnershipAddr = ownership.addr;
1465                 }
1466                 if (currOwnershipAddr == owner) {
1467                     a[tokenIdsIdx++] = i;
1468                 }
1469             }
1470             return a;
1471         }
1472     }
1473 
1474     function setBaseURI(string memory baseURI) external onlyOwner {
1475         require(!locked, "METADATA_LOCKED");
1476         _baseTokenURI = baseURI;
1477     }
1478 
1479     function setPrerevealURI(string memory prerevealURI) external onlyOwner {
1480         require(!locked, "METADATA_LOCKED");
1481         _prerevealTokenURI = prerevealURI;
1482     }
1483 
1484     function _baseURI() internal view virtual override returns (string memory) {
1485         return _baseTokenURI;
1486     }
1487 
1488     function setContractURI(string memory mContractURI) external onlyOwner {
1489         _contractURI = mContractURI;
1490     }
1491 
1492     function tokenURI(uint256 tokenId) public view override returns (string memory){
1493         if(!revealed) { return _prerevealTokenURI; }
1494         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
1495     }
1496 
1497     function contractURI() public view returns (string memory) {
1498         return _contractURI;
1499     }
1500 
1501     function _startTokenId() internal view virtual override returns (uint256){
1502         return 1;
1503     }
1504 }