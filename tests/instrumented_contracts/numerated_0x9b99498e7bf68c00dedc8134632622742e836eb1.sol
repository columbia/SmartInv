1 /**
2  *Submitted for verification at Etherscan.io on 2022-09-21
3 */
4 
5 /**
6 ╭━━━┳╮╱╭┳━━━┳━━━┳━━━━┳━━┳━━━╮
7 ┃╭━╮┃┃╱┃┃╭━╮┃╭━╮┃╭╮╭╮┣┫┣┫╭━━╯
8 ┃┃╱╰┫╰━╯┃┃╱┃┃╰━━╋╯┃┃╰╯┃┃┃╰━━╮
9 ┃┃╭━┫╭━╮┃┃╱┃┣━━╮┃╱┃┃╱╱┃┃┃╭━━╯
10 ┃╰┻━┃┃╱┃┃╰━╯┃╰━╯┃╱┃┃╱╭┫┣┫╰━━╮
11 ╰━━━┻╯╱╰┻━━━┻━━━╯╱╰╯╱╰━━┻━━━╯
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity ^0.8.0;
17 
18 library Counters {
19     struct Counter {
20 
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter:decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 
48 pragma solidity ^0.8.0;
49 
50 /**
51  * @dev String operations.
52  */
53 library Strings {
54     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
58      */
59     function toString(uint256 value) internal pure returns (string memory) {
60         // Inspired by OraclizeAPI's implementation - MIT licence
61         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
62 
63         if (value == 0) {
64             return "0";
65         }
66         uint256 temp = value;
67         uint256 digits;
68         while (temp != 0) {
69             digits++;
70             temp /= 10;
71         }
72         bytes memory buffer = new bytes(digits);
73         while (value != 0) {
74             digits -= 1;
75             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
76             value /= 10;
77         }
78         return string(buffer);
79     }
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
83      */
84     function toHexString(uint256 value) internal pure returns (string memory) {
85         if (value == 0) {
86             return "0x00";
87         }
88         uint256 temp = value;
89         uint256 length = 0;
90         while (temp != 0) {
91             length++;
92             temp >>= 8;
93         }
94         return toHexString(value, length);
95     }
96 
97     /**
98      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
99      */
100     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
101         bytes memory buffer = new bytes(2 * length + 2);
102         buffer[0] = "0";
103         buffer[1] = "x";
104         for (uint256 i = 2 * length + 1; i > 1; --i) {
105             buffer[i] = _HEX_SYMBOLS[value & 0xf];
106             value >>= 4;
107         }
108         require(value == 0, "Strings: hex length insufficient");
109         return string(buffer);
110     }
111 }
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Provides information about the current execution context, including the
117  * sender of the transaction and its data. While these are generally available
118  * via msg.sender and msg.data, they should not be accessed in such a direct
119  * manner, since when dealing with meta-transactions the account sending and
120  * paying for execution may not be the actual sender (as far as an application
121  * is concerned).
122  *
123  * This contract is only required for intermediate, library-like contracts.
124  */
125 abstract contract Context {
126     function _msgSender() internal view virtual returns (address) {
127         return msg.sender;
128     }
129 
130     function _msgData() internal view virtual returns (bytes calldata) {
131         return msg.data;
132     }
133 }
134 
135 
136 pragma solidity ^0.8.0;
137 
138 abstract contract Ownable is Context {
139     address private _owner;
140 
141     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
142 
143     /**
144      * @dev Initializes the contract setting the deployer as the initial owner.
145      */
146     constructor() {
147         _transferOwnership(_msgSender());
148     }
149 
150     /**
151      * @dev Returns the address of the current owner.
152      */
153     function owner() public view virtual returns (address) {
154         return _owner;
155     }
156 
157     /**
158      * @dev Throws if called by any account other than the owner.
159      */
160     modifier onlyOwner() {
161         require(owner() == _msgSender(), "Ownable: caller is not the owner");
162         _;
163     }
164 
165     /**
166      * @dev Leaves the contract without owner. It will not be possible to call
167      * `onlyOwner` functions anymore. Can only be called by the current owner.
168      *
169      * NOTE: Renouncing ownership will leave the contract without an owner,
170      * thereby removing any functionality that is only available to the owner.
171      */
172     function renounceOwnership() public virtual onlyOwner {
173         _transferOwnership(address(0));
174     }
175 
176     /**
177      * @dev Transfers ownership of the contract to a new account (`newOwner`).
178      * Can only be called by the current owner.
179      */
180     function transferOwnership(address newOwner) public virtual onlyOwner {
181         require(newOwner != address(0), "Ownable: new owner is the zero address");
182         _transferOwnership(newOwner);
183     }
184 
185     /**
186      * @dev Transfers ownership of the contract to a new account (`newOwner`).
187      * Internal function without access restriction.
188      */
189     function _transferOwnership(address newOwner) internal virtual {
190         address oldOwner = _owner;
191         _owner = newOwner;
192         emit OwnershipTransferred(oldOwner, newOwner);
193     }
194 }
195 
196 pragma solidity ^0.8.1;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * [IMPORTANT]
206      * ====
207      * It is unsafe to assume that an address for which this function returns
208      * false is an externally-owned account (EOA) and not a contract.
209      *
210      * Among others, `isContract` will return false for the following
211      * types of addresses:
212      *
213      *  - an externally-owned account
214      *  - a contract in construction
215      *  - an address where a contract will be created
216      *  - an address where a contract lived, but was destroyed
217      * ====
218      *
219      * [IMPORTANT]
220      * ====
221      * You shouldn't rely on `isContract` to protect against flash loan attacks!
222      *
223      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
224      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
225      * constructor.
226      * ====
227      */
228     function isContract(address account) internal view returns (bool) {
229         // This method relies on extcodesize/address.code.length, which returns 0
230         // for contracts in construction, since the code is only stored at the end
231         // of the constructor execution.
232 
233         return account.code.length > 0;
234     }
235 
236     /**
237      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
238      * `recipient`, forwarding all available gas and reverting on errors.
239      *
240      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
241      * of certain opcodes, possibly making contracts go over the 2300 gas limit
242      * imposed by `transfer`, making them unable to receive funds via
243      * `transfer`. {sendValue} removes this limitation.
244      *
245      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
246      *
247      * IMPORTANT: because control is transferred to `recipient`, care must be
248      * taken to not create reentrancy vulnerabilities. Consider using
249      * {ReentrancyGuard} or the
250      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
251      */
252     function sendValue(address payable recipient, uint256 amount) internal {
253         require(address(this).balance >= amount, "Address: insufficient balance");
254 
255         (bool success, ) = recipient.call{value: amount}("");
256         require(success, "Address: unable to send value, recipient may have reverted");
257     }
258 
259     /**
260      * @dev Performs a Solidity function call using a low level `call`. A
261      * plain `call` is an unsafe replacement for a function call: use this
262      * function instead.
263      *
264      * If `target` reverts with a revert reason, it is bubbled up by this
265      * function (like regular Solidity function calls).
266      *
267      * Returns the raw returned data. To convert to the expected return value,
268      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
269      *
270      * Requirements:
271      *
272      * - `target` must be a contract.
273      * - calling `target` with `data` must not revert.
274      *
275      * _Available since v3.1._
276      */
277     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
278         return functionCall(target, data, "Address: low-level call failed");
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
283      * `errorMessage` as a fallback revert reason when `target` reverts.
284      *
285      * _Available since v3.1._
286      */
287     function functionCall(
288         address target,
289         bytes memory data,
290         string memory errorMessage
291     ) internal returns (bytes memory) {
292         return functionCallWithValue(target, data, 0, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but also transferring `value` wei to `target`.
298      *
299      * Requirements:
300      *
301      * - the calling contract must have an ETH balance of at least `value`.
302      * - the called Solidity function must be `payable`.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value
310     ) internal returns (bytes memory) {
311         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
316      * with `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(
321         address target,
322         bytes memory data,
323         uint256 value,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         require(isContract(target), "Address: call to non-contract");
328 
329         (bool success, bytes memory returndata) = target.call{value: value}(data);
330         return verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
340         return functionStaticCall(target, data, "Address: low-level static call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
345      * but performing a static call.
346      *
347      * _Available since v3.3._
348      */
349     function functionStaticCall(
350         address target,
351         bytes memory data,
352         string memory errorMessage
353     ) internal view returns (bytes memory) {
354         require(isContract(target), "Address: static call to non-contract");
355 
356         (bool success, bytes memory returndata) = target.staticcall(data);
357         return verifyCallResult(success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a delegate call.
363      *
364      * _Available since v3.4._
365      */
366     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
367         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a delegate call.
373      *
374      * _Available since v3.4._
375      */
376     function functionDelegateCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(isContract(target), "Address: delegate call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.delegatecall(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
389      * revert reason using the provided one.
390      *
391      * _Available since v4.3._
392      */
393     function verifyCallResult(
394         bool success,
395         bytes memory returndata,
396         string memory errorMessage
397     ) internal pure returns (bytes memory) {
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 pragma solidity ^0.8.0;
417 
418 /**
419  * @title ERC721 token receiver interface
420  * @dev Interface for any contract that wants to support safeTransfers
421  * from ERC721 asset contracts.
422  */
423 interface IERC721Receiver {
424     /**
425      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
426      * by `operator` from `from`, this function is called.
427      *
428      * It must return its Solidity selector to confirm the token transfer.
429      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
430      *
431      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
432      */
433     function onERC721Received(
434         address operator,
435         address from,
436         uint256 tokenId,
437         bytes calldata data
438     ) external returns (bytes4);
439 }
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
464 pragma solidity ^0.8.0;
465 
466 abstract contract ERC165 is IERC165 {
467     /**
468      * @dev See {IERC165-supportsInterface}.
469      */
470     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
471         return interfaceId == type(IERC165).interfaceId;
472     }
473 }
474 
475 pragma solidity ^0.8.0;
476 
477 interface IERC721 is IERC165 {
478     /**
479      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
480      */
481     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
485      */
486     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
487 
488     /**
489      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
490      */
491     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
492 
493     /**
494      * @dev Returns the number of tokens in ``owner``'s account.
495      */
496     function balanceOf(address owner) external view returns (uint256 balance);
497 
498     /**
499      * @dev Returns the owner of the `tokenId` token.
500      *
501      * Requirements:
502      *
503      * - `tokenId` must exist.
504      */
505     function ownerOf(uint256 tokenId) external view returns (address owner);
506 
507     function safeTransferFrom(
508         address from,
509         address to,
510         uint256 tokenId
511     ) external;
512 
513     function transferFrom(
514         address from,
515         address to,
516         uint256 tokenId
517     ) external;
518 
519     function approve(address to, uint256 tokenId) external;
520 
521     /**
522      * @dev Returns the account approved for `tokenId` token.
523      *
524      * Requirements:
525      *
526      * - `tokenId` must exist.
527      */
528     function getApproved(uint256 tokenId) external view returns (address operator);
529 
530     /**
531      * @dev Approve or remove `operator` as an operator for the caller.
532      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
533      *
534      * Requirements:
535      *
536      * - The `operator` cannot be the caller.
537      *
538      * Emits an {ApprovalForAll} event.
539      */
540     function setApprovalForAll(address operator, bool _approved) external;
541 
542     /**
543      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
544      *
545      * See {setApprovalForAll}
546      */
547     function isApprovedForAll(address owner, address operator) external view returns (bool);
548 
549     /**
550      * @dev Safely transfers `tokenId` token from `from` to `to`.
551      *
552      * Requirements:
553      *
554      * - `from` cannot be the zero address.
555      * - `to` cannot be the zero address.
556      * - `tokenId` token must exist and be owned by `from`.
557      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
558      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
559      *
560      * Emits a {Transfer} event.
561      */
562     function safeTransferFrom(
563         address from,
564         address to,
565         uint256 tokenId,
566         bytes calldata data
567     ) external;
568 }
569 
570 
571 pragma solidity ^0.8.0;
572 
573 
574 /**
575  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
576  * @dev See https://eips.ethereum.org/EIPS/eip-721
577  */
578 interface IERC721Enumerable is IERC721 {
579     /**
580      * @dev Returns the total amount of tokens stored by the contract.
581      */
582     function totalSupply() external view returns (uint256);
583 
584     /**
585      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
586      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
587      */
588     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
589 
590     /**
591      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
592      * Use along with {totalSupply} to enumerate all tokens.
593      */
594     function tokenByIndex(uint256 index) external view returns (uint256);
595 }
596 
597 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
598 
599 
600 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 /**
606  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
607  * @dev See https://eips.ethereum.org/EIPS/eip-721
608  */
609 interface IERC721Metadata is IERC721 {
610     /**
611      * @dev Returns the token collection name.
612      */
613     function name() external view returns (string memory);
614 
615     /**
616      * @dev Returns the token collection symbol.
617      */
618     function symbol() external view returns (string memory);
619 
620     /**
621      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
622      */
623     function tokenURI(uint256 tokenId) external view returns (string memory);
624 }
625 
626 pragma solidity ^0.8.4;
627 
628 error ApprovalCallerNotOwnerNorApproved();
629 error ApprovalQueryForNonexistentToken();
630 error ApproveToCaller();
631 error ApprovalToCurrentOwner();
632 error BalanceQueryForZeroAddress();
633 error MintToZeroAddress();
634 error MintZeroQuantity();
635 error OwnerQueryForNonexistentToken();
636 error TransferCallerNotOwnerNorApproved();
637 error TransferFromIncorrectOwner();
638 error TransferToNonERC721ReceiverImplementer();
639 error TransferToZeroAddress();
640 error URIQueryForNonexistentToken();
641 
642 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
643     using Address for address;
644     using Strings for uint256;
645 
646     // Compiler will pack this into a single 256bit word.
647     struct TokenOwnership {
648         // The address of the owner.
649         address addr;
650         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
651         uint64 startTimestamp;
652         // Whether the token has been burned.
653         bool burned;
654     }
655 
656     // Compiler will pack this into a single 256bit word.
657     struct AddressData {
658         // Realistically, 2**64-1 is more than enough.
659         uint64 balance;
660         // Keeps track of mint count with minimal overhead for tokenomics.
661         uint64 numberMinted;
662         // Keeps track of burn count with minimal overhead for tokenomics.
663         uint64 numberBurned;
664         // For miscellaneous variable(s) pertaining to the address
665         // (e.g. number of whitelist mint slots used).
666         // If there are multiple variables, please pack them into a uint64.
667         uint64 aux;
668     }
669 
670     // The tokenId of the next token to be minted.
671     uint256 internal _currentIndex;
672 
673     // The number of tokens burned.
674     uint256 internal _burnCounter;
675 
676     // Token name
677     string private _name;
678 
679     // Token symbol
680     string private _symbol;
681 
682     // Mapping from token ID to ownership details
683     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
684     mapping(uint256 => TokenOwnership) internal _ownerships;
685 
686     // Mapping owner address to address data
687     mapping(address => AddressData) private _addressData;
688 
689     // Mapping from token ID to approved address
690     mapping(uint256 => address) private _tokenApprovals;
691 
692     // Mapping from owner to operator approvals
693     mapping(address => mapping(address => bool)) private _operatorApprovals;
694 
695     constructor(string memory name_, string memory symbol_) {
696         _name = name_;
697         _symbol = symbol_;
698         _currentIndex = _startTokenId();
699     }
700 
701     /**
702      * To change the starting tokenId, please override this function.
703      */
704     function _startTokenId() internal view virtual returns (uint256) {
705         return 0;
706     }
707 
708     /**
709      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
710      */
711     function totalSupply() public view returns (uint256) {
712         // Counter underflow is impossible as _burnCounter cannot be incremented
713         // more than _currentIndex - _startTokenId() times
714         unchecked {
715             return _currentIndex - _burnCounter - _startTokenId();
716         }
717     }
718 
719     /**
720      * Returns the total amount of tokens minted in the contract.
721      */
722     function _totalMinted() internal view returns (uint256) {
723         // Counter underflow is impossible as _currentIndex does not decrement,
724         // and it is initialized to _startTokenId()
725         unchecked {
726             return _currentIndex - _startTokenId();
727         }
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
734         return
735             interfaceId == type(IERC721).interfaceId ||
736             interfaceId == type(IERC721Metadata).interfaceId ||
737             super.supportsInterface(interfaceId);
738     }
739 
740     /**
741      * @dev See {IERC721-balanceOf}.
742      */
743     function balanceOf(address owner) public view override returns (uint256) {
744         if (owner == address(0)) revert BalanceQueryForZeroAddress();
745         return uint256(_addressData[owner].balance);
746     }
747 
748     /**
749      * Returns the number of tokens minted by `owner`.
750      */
751     function _numberMinted(address owner) internal view returns (uint256) {
752         return uint256(_addressData[owner].numberMinted);
753     }
754 
755     /**
756      * Returns the number of tokens burned by or on behalf of `owner`.
757      */
758     function _numberBurned(address owner) internal view returns (uint256) {
759         return uint256(_addressData[owner].numberBurned);
760     }
761 
762     /**
763      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
764      */
765     function _getAux(address owner) internal view returns (uint64) {
766         return _addressData[owner].aux;
767     }
768 
769     /**
770      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
771      * If there are multiple variables, please pack them into a uint64.
772      */
773     function _setAux(address owner, uint64 aux) internal {
774         _addressData[owner].aux = aux;
775     }
776 
777     /**
778      * Gas spent here starts off proportional to the maximum mint batch size.
779      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
780      */
781     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
782         uint256 curr = tokenId;
783 
784         unchecked {
785             if (_startTokenId() <= curr && curr < _currentIndex) {
786                 TokenOwnership memory ownership = _ownerships[curr];
787                 if (!ownership.burned) {
788                     if (ownership.addr != address(0)) {
789                         return ownership;
790                     }
791                     // Invariant:
792                     // There will always be an ownership that has an address and is not burned
793                     // before an ownership that does not have an address and is not burned.
794                     // Hence, curr will not underflow.
795                     while (true) {
796                         curr--;
797                         ownership = _ownerships[curr];
798                         if (ownership.addr != address(0)) {
799                             return ownership;
800                         }
801                     }
802                 }
803             }
804         }
805         revert OwnerQueryForNonexistentToken();
806     }
807 
808     /**
809      * @dev See {IERC721-ownerOf}.
810      */
811     function ownerOf(uint256 tokenId) public view override returns (address) {
812         return _ownershipOf(tokenId).addr;
813     }
814 
815     /**
816      * @dev See {IERC721Metadata-name}.
817      */
818     function name() public view virtual override returns (string memory) {
819         return _name;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-symbol}.
824      */
825     function symbol() public view virtual override returns (string memory) {
826         return _symbol;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-tokenURI}.
831      */
832     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
833         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
834 
835         string memory baseURI = _baseURI();
836         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
837     }
838 
839     /**
840      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
841      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
842      * by default, can be overriden in child contracts.
843      */
844     function _baseURI() internal view virtual returns (string memory) {
845         return '';
846     }
847 
848     /**
849      * @dev See {IERC721-approve}.
850      */
851     function approve(address to, uint256 tokenId) public override {
852         address owner = ERC721A.ownerOf(tokenId);
853         if (to == owner) revert ApprovalToCurrentOwner();
854 
855         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
856             revert ApprovalCallerNotOwnerNorApproved();
857         }
858 
859         _approve(to, tokenId, owner);
860     }
861 
862     /**
863      * @dev See {IERC721-getApproved}.
864      */
865     function getApproved(uint256 tokenId) public view override returns (address) {
866         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
867 
868         return _tokenApprovals[tokenId];
869     }
870 
871     /**
872      * @dev See {IERC721-setApprovalForAll}.
873      */
874     function setApprovalForAll(address operator, bool approved) public virtual override {
875         if (operator == _msgSender()) revert ApproveToCaller();
876 
877         _operatorApprovals[_msgSender()][operator] = approved;
878         emit ApprovalForAll(_msgSender(), operator, approved);
879     }
880 
881     /**
882      * @dev See {IERC721-isApprovedForAll}.
883      */
884     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
885         return _operatorApprovals[owner][operator];
886     }
887 
888     /**
889      * @dev See {IERC721-transferFrom}.
890      */
891     function transferFrom(
892         address from,
893         address to,
894         uint256 tokenId
895     ) public virtual override {
896         _transfer(from, to, tokenId);
897     }
898 
899     /**
900      * @dev See {IERC721-safeTransferFrom}.
901      */
902     function safeTransferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         safeTransferFrom(from, to, tokenId, '');
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) public virtual override {
919         _transfer(from, to, tokenId);
920         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
921             revert TransferToNonERC721ReceiverImplementer();
922         }
923     }
924 
925     /**
926      * @dev Returns whether `tokenId` exists.
927      *
928      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
929      *
930      * Tokens start existing when they are minted (`_mint`),
931      */
932     function _exists(uint256 tokenId) internal view returns (bool) {
933         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
934     }
935 
936     function _safeMint(address to, uint256 quantity) internal {
937         _safeMint(to, quantity, '');
938     }
939 
940     /**
941      * @dev Safely mints `quantity` tokens and transfers them to `to`.
942      *
943      * Requirements:
944      *
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
946      * - `quantity` must be greater than 0.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _safeMint(
951         address to,
952         uint256 quantity,
953         bytes memory _data
954     ) internal {
955         _mint(to, quantity, _data, true);
956     }
957 
958     /**
959      * @dev Mints `quantity` tokens and transfers them to `to`.
960      *
961      * Requirements:
962      *
963      * - `to` cannot be the zero address.
964      * - `quantity` must be greater than 0.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _mint(
969         address to,
970         uint256 quantity,
971         bytes memory _data,
972         bool safe
973     ) internal {
974         uint256 startTokenId = _currentIndex;
975         if (to == address(0)) revert MintToZeroAddress();
976         if (quantity == 0) revert MintZeroQuantity();
977 
978         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
979 
980         // Overflows are incredibly unrealistic.
981         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
982         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
983         unchecked {
984             _addressData[to].balance += uint64(quantity);
985             _addressData[to].numberMinted += uint64(quantity);
986 
987             _ownerships[startTokenId].addr = to;
988             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
989 
990             uint256 updatedIndex = startTokenId;
991             uint256 end = updatedIndex + quantity;
992 
993             if (safe && to.isContract()) {
994                 do {
995                     emit Transfer(address(0), to, updatedIndex);
996                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
997                         revert TransferToNonERC721ReceiverImplementer();
998                     }
999                 } while (updatedIndex != end);
1000                 // Reentrancy protection
1001                 if (_currentIndex != startTokenId) revert();
1002             } else {
1003                 do {
1004                     emit Transfer(address(0), to, updatedIndex++);
1005                 } while (updatedIndex != end);
1006             }
1007             _currentIndex = updatedIndex;
1008         }
1009         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1010     }
1011 
1012     function _transfer(
1013         address from,
1014         address to,
1015         uint256 tokenId
1016     ) private {
1017         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1018 
1019         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1020 
1021         bool isApprovedOrOwner = (_msgSender() == from ||
1022             isApprovedForAll(from, _msgSender()) ||
1023             getApproved(tokenId) == _msgSender());
1024 
1025         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1026         if (to == address(0)) revert TransferToZeroAddress();
1027 
1028         _beforeTokenTransfers(from, to, tokenId, 1);
1029 
1030         // Clear approvals from the previous owner
1031         _approve(address(0), tokenId, from);
1032 
1033         // Underflow of the sender's balance is impossible because we check for
1034         // ownership above and the recipient's balance can't realistically overflow.
1035         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1036         unchecked {
1037             _addressData[from].balance -= 1;
1038             _addressData[to].balance += 1;
1039 
1040             TokenOwnership storage currSlot = _ownerships[tokenId];
1041             currSlot.addr = to;
1042             currSlot.startTimestamp = uint64(block.timestamp);
1043 
1044             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1045             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1046             uint256 nextTokenId = tokenId + 1;
1047             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1048             if (nextSlot.addr == address(0)) {
1049                 // This will suffice for checking _exists(nextTokenId),
1050                 // as a burned slot cannot contain the zero address.
1051                 if (nextTokenId != _currentIndex) {
1052                     nextSlot.addr = from;
1053                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1054                 }
1055             }
1056         }
1057 
1058         emit Transfer(from, to, tokenId);
1059         _afterTokenTransfers(from, to, tokenId, 1);
1060     }
1061 
1062     /**
1063      * @dev This is equivalent to _burn(tokenId, false)
1064      */
1065     function _burn(uint256 tokenId) internal virtual {
1066         _burn(tokenId, false);
1067     }
1068 
1069     /**
1070      * @dev Destroys `tokenId`.
1071      * The approval is cleared when the token is burned.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      *
1077      * Emits a {Transfer} event.
1078      */
1079     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1080         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1081 
1082         address from = prevOwnership.addr;
1083 
1084         if (approvalCheck) {
1085             bool isApprovedOrOwner = (_msgSender() == from ||
1086                 isApprovedForAll(from, _msgSender()) ||
1087                 getApproved(tokenId) == _msgSender());
1088 
1089             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1090         }
1091 
1092         _beforeTokenTransfers(from, address(0), tokenId, 1);
1093 
1094         // Clear approvals from the previous owner
1095         _approve(address(0), tokenId, from);
1096 
1097         // Underflow of the sender's balance is impossible because we check for
1098         // ownership above and the recipient's balance can't realistically overflow.
1099         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1100         unchecked {
1101             AddressData storage addressData = _addressData[from];
1102             addressData.balance -= 1;
1103             addressData.numberBurned += 1;
1104 
1105             // Keep track of who burned the token, and the timestamp of burning.
1106             TokenOwnership storage currSlot = _ownerships[tokenId];
1107             currSlot.addr = from;
1108             currSlot.startTimestamp = uint64(block.timestamp);
1109             currSlot.burned = true;
1110 
1111             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1112             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1113             uint256 nextTokenId = tokenId + 1;
1114             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1115             if (nextSlot.addr == address(0)) {
1116                 // This will suffice for checking _exists(nextTokenId),
1117                 // as a burned slot cannot contain the zero address.
1118                 if (nextTokenId != _currentIndex) {
1119                     nextSlot.addr = from;
1120                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1121                 }
1122             }
1123         }
1124 
1125         emit Transfer(from, address(0), tokenId);
1126         _afterTokenTransfers(from, address(0), tokenId, 1);
1127 
1128         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1129         unchecked {
1130             _burnCounter++;
1131         }
1132     }
1133 
1134     /**
1135      * @dev Approve `to` to operate on `tokenId`
1136      *
1137      * Emits a {Approval} event.
1138      */
1139     function _approve(
1140         address to,
1141         uint256 tokenId,
1142         address owner
1143     ) private {
1144         _tokenApprovals[tokenId] = to;
1145         emit Approval(owner, to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1150      *
1151      * @param from address representing the previous owner of the given token ID
1152      * @param to target address that will receive the tokens
1153      * @param tokenId uint256 ID of the token to be transferred
1154      * @param _data bytes optional data to send along with the call
1155      * @return bool whether the call correctly returned the expected magic value
1156      */
1157     function _checkContractOnERC721Received(
1158         address from,
1159         address to,
1160         uint256 tokenId,
1161         bytes memory _data
1162     ) private returns (bool) {
1163         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1164             return retval == IERC721Receiver(to).onERC721Received.selector;
1165         } catch (bytes memory reason) {
1166             if (reason.length == 0) {
1167                 revert TransferToNonERC721ReceiverImplementer();
1168             } else {
1169                 assembly {
1170                     revert(add(32, reason), mload(reason))
1171                 }
1172             }
1173         }
1174     }
1175 
1176     function _beforeTokenTransfers(
1177         address from,
1178         address to,
1179         uint256 startTokenId,
1180         uint256 quantity
1181     ) internal virtual {}
1182 
1183     function _afterTokenTransfers(
1184         address from,
1185         address to,
1186         uint256 startTokenId,
1187         uint256 quantity
1188     ) internal virtual {}
1189 }
1190 
1191 
1192 pragma solidity ^0.8.4;
1193 
1194 
1195 contract GhostIE is ERC721A, Ownable {
1196     using Strings for uint256;
1197 
1198     string private baseURI;
1199 
1200     string public hiddenMetadataUri;
1201 
1202     // uint256 public price = 0 ether;
1203     uint256 public price;
1204 
1205     uint256 public maxMintPerWallet = 1;
1206 
1207     uint256 public totalPublicSale = 400;
1208 
1209     uint256 public currentPublicSale = 0;
1210 
1211     uint256 public maxSupply = 500;
1212 
1213     uint public nextId = 0;
1214 
1215     bool public mintEnabled;
1216 
1217     bool public revealed;
1218 
1219     mapping(address => uint256) private _mintedFreeAmount;
1220 
1221     constructor() ERC721A("Ghostie", "GHE") {
1222         setHiddenMetadataUri("");
1223     }
1224 
1225     function mint(uint256 count) external payable {
1226         require(mintEnabled, "Minting is not live yet");
1227         require(msg.value >= count * price, "Please send the exact amount.");
1228         require(totalSupply() + count <= maxSupply, "No more GhostIE");
1229         require(currentPublicSale + count <= totalPublicSale, "Insufficient free credits");
1230         require(count <= maxMintPerWallet, "Max per TX reached.");
1231         require(_mintedFreeAmount[msg.sender] + count <= maxMintPerWallet, "More than the number of wallets per");
1232 
1233         _safeMint(msg.sender, count);
1234         _mintedFreeAmount[msg.sender] += count;
1235         currentPublicSale += count;
1236         nextId += count;
1237     }
1238 
1239     function canMint(address _addr) external view returns(bool){
1240         return  _mintedFreeAmount[_addr] < maxMintPerWallet;
1241     }
1242 
1243     function _baseURI() internal view virtual override returns (string memory) {
1244         return baseURI;
1245     }
1246 
1247     function tokenURI(uint256 tokenId)
1248         public
1249         view
1250         virtual
1251         override
1252         returns (string memory)
1253     {
1254         require(
1255             _exists(tokenId),
1256             "ERC721Metadata: URI query for nonexistent token"
1257         );
1258 
1259         if (revealed == false) {
1260          return string(abi.encodePacked(hiddenMetadataUri));
1261         }
1262     
1263         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1264     }
1265 
1266     function setBaseURI(string memory uri) public onlyOwner {
1267         baseURI = uri;
1268     }
1269 
1270     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1271      hiddenMetadataUri = _hiddenMetadataUri;
1272     }
1273 
1274     function setFreeAmount(uint256 amount) external onlyOwner {
1275         totalPublicSale = amount;
1276     }
1277 
1278     function setPrice(uint256 _newPrice) external onlyOwner {
1279         price = _newPrice;
1280     }
1281 
1282     function setMaxMintPerWallet(uint256 _num) external onlyOwner {
1283         maxMintPerWallet = _num;
1284     }
1285 
1286     function setRevealed() external onlyOwner {
1287      revealed = !revealed;
1288     }
1289 
1290     function flipSale() external onlyOwner {
1291         mintEnabled = !mintEnabled;
1292     }
1293 
1294     function getNextId() public view returns(uint){
1295      return nextId;
1296     }
1297 
1298     function _startTokenId() internal pure override returns (uint256) {
1299         return 1;
1300     }
1301 
1302     function withdraw() external onlyOwner {
1303         (bool success, ) = payable(msg.sender).call{
1304             value: address(this).balance
1305         }("");
1306         require(success, "Transfer failed.");
1307     }
1308 
1309     function airdrop(address to, uint256 quantity)public onlyOwner{
1310         require(totalSupply() + quantity <= maxSupply, "reached max supply");
1311         _safeMint(to, quantity);
1312     }
1313 }