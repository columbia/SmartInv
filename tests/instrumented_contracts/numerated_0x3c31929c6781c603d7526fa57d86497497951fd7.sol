1 /** : )
2     ____  __                   __ __                   _____           _ ___                ______                          __           
3    / __ \/ /__  ____ ______   / //_/__  ___  ____     / ___/____ ___  (_) (_)___  ____ _   / ____/   _____  _______  ______/ /___ ___  __
4   / /_/ / / _ \/ __ `/ ___/  / ,< / _ \/ _ \/ __ \    \__ \/ __ `__ \/ / / / __ \/ __ `/  / __/ | | / / _ \/ ___/ / / / __  / __ `/ / / /
5  / ____/ /  __/ /_/ (__  )  / /| /  __/  __/ /_/ /   ___/ / / / / / / / / / / / / /_/ /  / /___ | |/ /  __/ /  / /_/ / /_/ / /_/ / /_/ / 
6 /_/   /_/\___/\__,_/____/  /_/ |_\___/\___/ .___/   /____/_/ /_/ /_/_/_/_/_/ /_/\__, /  /_____/ |___/\___/_/   \__, /\__,_/\__,_/\__, /  
7                                          /_/                                   /____/                         /____/            /____/   
8 */
9 
10 
11 
12 
13 
14 
15 
16 /**
17  *Submitted for verification at Etherscan.io on 2022-06-02
18 */
19 
20 /**
21  *Submitted for verification at Etherscan.io on 2022-05-27
22 */
23 
24 /**
25  *Submitted for verification at Etherscan.io on 2022-05-27
26 */
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity ^0.8.12;
31 
32 /**
33  * @dev String operations.
34  */
35 library Strings {
36     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
37 
38     /**
39      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
40      */
41     function toString(uint256 value) internal pure returns (string memory) {
42         // Inspired by OraclizeAPI's implementation - MIT licence
43         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
44 
45         if (value == 0) {
46             return "0";
47         }
48         uint256 temp = value;
49         uint256 digits;
50         while (temp != 0) {
51             digits++;
52             temp /= 10;
53         }
54         bytes memory buffer = new bytes(digits);
55         while (value != 0) {
56             digits -= 1;
57             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
58             value /= 10;
59         }
60         return string(buffer);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
65      */
66     function toHexString(uint256 value) internal pure returns (string memory) {
67         if (value == 0) {
68             return "0x00";
69         }
70         uint256 temp = value;
71         uint256 length = 0;
72         while (temp != 0) {
73             length++;
74             temp >>= 8;
75         }
76         return toHexString(value, length);
77     }
78 
79     /**
80      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
81      */
82     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
83         bytes memory buffer = new bytes(2 * length + 2);
84         buffer[0] = "0";
85         buffer[1] = "x";
86         for (uint256 i = 2 * length + 1; i > 1; --i) {
87             buffer[i] = _HEX_SYMBOLS[value & 0xf];
88             value >>= 4;
89         }
90         require(value == 0, "Strings: hex length insufficient");
91         return string(buffer);
92     }
93 }
94 
95 
96 /**
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 abstract contract Context {
107     function _msgSender() internal view virtual returns (address) {
108         return msg.sender;
109     }
110 
111     function _msgData() internal view virtual returns (bytes calldata) {
112         return msg.data;
113     }
114 }
115 
116 /**
117  * @dev Contract module which provides a basic access control mechanism, where
118  * there is an account (an owner) that can be granted exclusive access to
119  * specific functions.
120  *
121  * By default, the owner account will be the one that deploys the contract. This
122  * can later be changed with {transferOwnership}.
123  *
124  * This module is used through inheritance. It will make available the modifier
125  * `onlyOwner`, which can be applied to your functions to restrict their use to
126  * the owner.
127  */
128 abstract contract Ownable is Context {
129     address private _owner;
130 
131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
132 
133     /**
134      * @dev Initializes the contract setting the deployer as the initial owner.
135      */
136     constructor() {
137         _setOwner(_msgSender());
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view virtual returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if called by any account other than the owner.
149      */
150     modifier onlyOwner() {
151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
152         _;
153     }
154 
155     /**
156      * @dev Leaves the contract without owner. It will not be possible to call
157      * `onlyOwner` functions anymore. Can only be called by the current owner.
158      *
159      * NOTE: Renouncing ownership will leave the contract without an owner,
160      * thereby removing any functionality that is only available to the owner.
161      */
162     function renounceOwnership() public virtual onlyOwner {
163         _setOwner(address(0));
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Can only be called by the current owner.
169      */
170     function transferOwnership(address newOwner) public virtual onlyOwner {
171         require(newOwner != address(0), "Ownable: new owner is the zero address");
172         _setOwner(newOwner);
173     }
174 
175     function _setOwner(address newOwner) private {
176         address oldOwner = _owner;
177         _owner = newOwner;
178         emit OwnershipTransferred(oldOwner, newOwner);
179     }
180 }
181 
182 /**
183  * @dev Collection of functions related to the address type
184  */
185 library Address {
186     /**
187      * @dev Returns true if `account` is a contract.
188      *
189      * [IMPORTANT]
190      * ====
191      * It is unsafe to assume that an address for which this function returns
192      * false is an externally-owned account (EOA) and not a contract.
193      *
194      * Among others, `isContract` will return false for the following
195      * types of addresses:
196      *
197      *  - an externally-owned account
198      *  - a contract in construction
199      *  - an address where a contract will be created
200      *  - an address where a contract lived, but was destroyed
201      * ====
202      */
203     function isContract(address account) internal view returns (bool) {
204         // This method relies on extcodesize, which returns 0 for contracts in
205         // construction, since the code is only stored at the end of the
206         // constructor execution.
207 
208         uint256 size;
209         assembly {
210             size := extcodesize(account)
211         }
212         return size > 0;
213     }
214 
215     /**
216      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
217      * `recipient`, forwarding all available gas and reverting on errors.
218      *
219      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
220      * of certain opcodes, possibly making contracts go over the 2300 gas limit
221      * imposed by `transfer`, making them unable to receive funds via
222      * `transfer`. {sendValue} removes this limitation.
223      *
224      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
225      *
226      * IMPORTANT: because control is transferred to `recipient`, care must be
227      * taken to not create reentrancy vulnerabilities. Consider using
228      * {ReentrancyGuard} or the
229      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
230      */
231     function sendValue(address payable recipient, uint256 amount) internal {
232         require(address(this).balance >= amount, "Address: insufficient balance");
233 
234         (bool success, ) = recipient.call{value: amount}("");
235         require(success, "Address: unable to send value, recipient may have reverted");
236     }
237 
238     /**
239      * @dev Performs a Solidity function call using a low level `call`. A
240      * plain `call` is an unsafe replacement for a function call: use this
241      * function instead.
242      *
243      * If `target` reverts with a revert reason, it is bubbled up by this
244      * function (like regular Solidity function calls).
245      *
246      * Returns the raw returned data. To convert to the expected return value,
247      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
248      *
249      * Requirements:
250      *
251      * - `target` must be a contract.
252      * - calling `target` with `data` must not revert.
253      *
254      * _Available since v3.1._
255      */
256     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionCall(target, data, "Address: low-level call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
262      * `errorMessage` as a fallback revert reason when `target` reverts.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, 0, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but also transferring `value` wei to `target`.
277      *
278      * Requirements:
279      *
280      * - the calling contract must have an ETH balance of at least `value`.
281      * - the called Solidity function must be `payable`.
282      *
283      * _Available since v3.1._
284      */
285     function functionCallWithValue(
286         address target,
287         bytes memory data,
288         uint256 value
289     ) internal returns (bytes memory) {
290         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
295      * with `errorMessage` as a fallback revert reason when `target` reverts.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value,
303         string memory errorMessage
304     ) internal returns (bytes memory) {
305         require(address(this).balance >= value, "Address: insufficient balance for call");
306         require(isContract(target), "Address: call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.call{value: value}(data);
309         return verifyCallResult(success, returndata, errorMessage);
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
314      * but performing a static call.
315      *
316      * _Available since v3.3._
317      */
318     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
319         return functionStaticCall(target, data, "Address: low-level static call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(
329         address target,
330         bytes memory data,
331         string memory errorMessage
332     ) internal view returns (bytes memory) {
333         require(isContract(target), "Address: static call to non-contract");
334 
335         (bool success, bytes memory returndata) = target.staticcall(data);
336         return verifyCallResult(success, returndata, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but performing a delegate call.
342      *
343      * _Available since v3.4._
344      */
345     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         require(isContract(target), "Address: delegate call to non-contract");
361 
362         (bool success, bytes memory returndata) = target.delegatecall(data);
363         return verifyCallResult(success, returndata, errorMessage);
364     }
365 
366     /**
367      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
368      * revert reason using the provided one.
369      *
370      * _Available since v4.3._
371      */
372     function verifyCallResult(
373         bool success,
374         bytes memory returndata,
375         string memory errorMessage
376     ) internal pure returns (bytes memory) {
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 /**
396  * @title ERC721 token receiver interface
397  * @dev Interface for any contract that wants to support safeTransfers
398  * from ERC721 asset contracts.
399  */
400 interface IERC721Receiver {
401     /**
402      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
403      * by `operator` from `from`, this function is called.
404      *
405      * It must return its Solidity selector to confirm the token transfer.
406      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
407      *
408      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
409      */
410     function onERC721Received(
411         address operator,
412         address from,
413         uint256 tokenId,
414         bytes calldata data
415     ) external returns (bytes4);
416 }
417 
418 /**
419  * @dev Interface of the ERC165 standard, as defined in the
420  * https://eips.ethereum.org/EIPS/eip-165[EIP].
421  *
422  * Implementers can declare support of contract interfaces, which can then be
423  * queried by others ({ERC165Checker}).
424  *
425  * For an implementation, see {ERC165}.
426  */
427 interface IERC165 {
428     /**
429      * @dev Returns true if this contract implements the interface defined by
430      * `interfaceId`. See the corresponding
431      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
432      * to learn more about how these ids are created.
433      *
434      * This function call must use less than 30 000 gas.
435      */
436     function supportsInterface(bytes4 interfaceId) external view returns (bool);
437 }
438 
439 /**
440  * @dev Implementation of the {IERC165} interface.
441  *
442  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
443  * for the additional interface id that will be supported. For example:
444  *
445  * ```solidity
446  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
447  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
448  * }
449  * ```
450  *
451  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
452  */
453 abstract contract ERC165 is IERC165 {
454     /**
455      * @dev See {IERC165-supportsInterface}.
456      */
457     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458         return interfaceId == type(IERC165).interfaceId;
459     }
460 }
461 
462 /**
463  * @dev Required interface of an ERC721 compliant contract.
464  */
465 interface IERC721 is IERC165 {
466     /**
467      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
468      */
469     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
470 
471     /**
472      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
473      */
474     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
475 
476     /**
477      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
478      */
479     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
480 
481     /**
482      * @dev Returns the number of tokens in ``owner``'s account.
483      */
484     function balanceOf(address owner) external view returns (uint256 balance);
485 
486     /**
487      * @dev Returns the owner of the `tokenId` token.
488      *
489      * Requirements:
490      *
491      * - `tokenId` must exist.
492      */
493     function ownerOf(uint256 tokenId) external view returns (address owner);
494 
495     /**
496      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
497      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must exist and be owned by `from`.
504      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
505      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId
513     ) external;
514 
515     /**
516      * @dev Transfers `tokenId` token from `from` to `to`.
517      *
518      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `tokenId` token must be owned by `from`.
525      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transferFrom(
530         address from,
531         address to,
532         uint256 tokenId
533     ) external;
534 
535     /**
536      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
537      * The approval is cleared when the token is transferred.
538      *
539      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
540      *
541      * Requirements:
542      *
543      * - The caller must own the token or be an approved operator.
544      * - `tokenId` must exist.
545      *
546      * Emits an {Approval} event.
547      */
548     function approve(address to, uint256 tokenId) external;
549 
550     /**
551      * @dev Returns the account approved for `tokenId` token.
552      *
553      * Requirements:
554      *
555      * - `tokenId` must exist.
556      */
557     function getApproved(uint256 tokenId) external view returns (address operator);
558 
559     /**
560      * @dev Approve or remove `operator` as an operator for the caller.
561      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
562      *
563      * Requirements:
564      *
565      * - The `operator` cannot be the caller.
566      *
567      * Emits an {ApprovalForAll} event.
568      */
569     function setApprovalForAll(address operator, bool _approved) external;
570 
571     /**
572      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
573      *
574      * See {setApprovalForAll}
575      */
576     function isApprovedForAll(address owner, address operator) external view returns (bool);
577 
578     /**
579      * @dev Safely transfers `tokenId` token from `from` to `to`.
580      *
581      * Requirements:
582      *
583      * - `from` cannot be the zero address.
584      * - `to` cannot be the zero address.
585      * - `tokenId` token must exist and be owned by `from`.
586      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
587      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
588      *
589      * Emits a {Transfer} event.
590      */
591     function safeTransferFrom(
592         address from,
593         address to,
594         uint256 tokenId,
595         bytes calldata data
596     ) external;
597 }
598 
599 /**
600  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
601  * @dev See https://eips.ethereum.org/EIPS/eip-721
602  */
603 interface IERC721Enumerable is IERC721 {
604     /**
605      * @dev Returns the total amount of tokens stored by the contract.
606      */
607     function totalSupply() external view returns (uint256);
608 
609     /**
610      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
611      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
612      */
613     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
614 
615     /**
616      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
617      * Use along with {totalSupply} to enumerate all tokens.
618      */
619     function tokenByIndex(uint256 index) external view returns (uint256);
620 }
621 
622 
623 /**
624  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
625  * @dev See https://eips.ethereum.org/EIPS/eip-721
626  */
627 interface IERC721Metadata is IERC721 {
628     /**
629      * @dev Returns the token collection name.
630      */
631     function name() external view returns (string memory);
632 
633     /**
634      * @dev Returns the token collection symbol.
635      */
636     function symbol() external view returns (string memory);
637 
638     /**
639      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
640      */
641     function tokenURI(uint256 tokenId) external view returns (string memory);
642 }
643 
644 /**
645  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
646  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
647  *
648  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
649  *
650  * Does not support burning tokens to address(0).
651  *
652  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
653  */
654 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
655     using Address for address;
656     using Strings for uint256;
657 
658     struct StakingInfo {
659         bool staked;
660         bool usedForMint;
661         uint duration;
662     }
663 
664     struct TokenOwnership {
665         address addr;
666         uint64 startTimestamp;
667     }
668 
669     struct AddressData {
670         uint128 balance;
671         uint128 numberMinted;
672     }
673 
674     uint256 public currentIndex = 1;
675 
676     // Token name
677     string private _name;
678 
679     // Token symbol
680     string private _symbol;
681 
682     string internal uri;
683 
684     // Mapping from token ID to ownership details
685     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
686     mapping(uint256 => TokenOwnership) internal _ownerships;
687 
688     // Mapping owner address to address data
689     mapping(address => AddressData) private _addressData;
690 
691     // Mapping from token ID to approved address
692     mapping(uint256 => address) private _tokenApprovals;
693 
694     // Mapping from owner to operator approvals
695     mapping(address => mapping(address => bool)) private _operatorApprovals;
696 
697     mapping(uint => StakingInfo) public _stakedTokens;
698 
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702     }
703 
704     /**
705      * @dev See {IERC721Enumerable-totalSupply}.
706      */
707     function totalSupply() public view override returns (uint256) {
708         return currentIndex - 1;
709     }
710 
711     /**
712      * @dev See {IERC721Enumerable-tokenByIndex}.
713      */
714     function tokenByIndex(uint256 index) public view override returns (uint256) {
715         require(index < totalSupply(), 'ERC721A: global index out of bounds');
716         return index;
717     }
718 
719     /**
720      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
721      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
722      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
723      */
724     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
725         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
726         uint256 numMintedSoFar = totalSupply();
727         uint256 tokenIdsIdx;
728         address currOwnershipAddr;
729 
730         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
731         unchecked {
732             for (uint256 i; i < numMintedSoFar; i++) {
733                 TokenOwnership memory ownership = _ownerships[i];
734                 if (ownership.addr != address(0)) {
735                     currOwnershipAddr = ownership.addr;
736                 }
737                 if (currOwnershipAddr == owner) {
738                     if (tokenIdsIdx == index) {
739                         return i;
740                     }
741                     tokenIdsIdx++;
742                 }
743             }
744         }
745 
746         revert('ERC721A: unable to get token of owner by index');
747     }
748 
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
753         return
754             interfaceId == type(IERC721).interfaceId ||
755             interfaceId == type(IERC721Metadata).interfaceId ||
756             interfaceId == type(IERC721Enumerable).interfaceId ||
757             super.supportsInterface(interfaceId);
758     }
759 
760     /**
761      * @dev See {IERC721-balanceOf}.
762      */
763     function balanceOf(address owner) public view override returns (uint256) {
764         require(owner != address(0), 'ERC721A: balance query for the zero address');
765         return uint256(_addressData[owner].balance);
766     }
767 
768     function _numberMinted(address owner) internal view returns (uint256) {
769         require(owner != address(0), 'ERC721A: number minted query for the zero address');
770         return uint256(_addressData[owner].numberMinted);
771     }
772 
773     /**
774      * Gas spent here starts off proportional to the maximum mint batch size.
775      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
776      */
777     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
778         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
779 
780         unchecked {
781             for (uint256 curr = tokenId; curr >= 0; curr--) {
782                 TokenOwnership memory ownership = _ownerships[curr];
783                 if (ownership.addr != address(0)) {
784                     return ownership;
785                 }
786             }
787         }
788 
789         revert('ERC721A: unable to determine the owner of token');
790     }
791 
792     /**
793      * @dev See {IERC721-ownerOf}.
794      */
795     function ownerOf(uint256 tokenId) public view override returns (address) {
796         return ownershipOf(tokenId).addr;
797     }
798 
799     /**
800      * @dev See {IERC721Metadata-name}.
801      */
802     function name() public view virtual override returns (string memory) {
803         return _name;
804     }
805 
806     /**
807      * @dev See {IERC721Metadata-symbol}.
808      */
809     function symbol() public view virtual override returns (string memory) {
810         return _symbol;
811     }
812 
813     /**
814      * @dev See {IERC721Metadata-tokenURI}.
815      */
816     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
817         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
818 
819         string memory baseURI = _baseURI();
820         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
821     }
822 
823     /**
824      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
825      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
826      * by default, can be overriden in child contracts.
827      */
828     function _baseURI() internal view virtual returns (string memory) {
829         return uri;
830     }
831 
832     /**
833      * @dev See {IERC721-approve}.
834      */
835     function approve(address to, uint256 tokenId) public override {
836         address owner = ERC721A.ownerOf(tokenId);
837         require(to != owner, 'ERC721A: approval to current owner');
838 
839         require(
840             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
841             'ERC721A: approve caller is not owner nor approved for all'
842         );
843 
844         _approve(to, tokenId, owner);
845     }
846 
847     /**
848      * @dev See {IERC721-getApproved}.
849      */
850     function getApproved(uint256 tokenId) public view override returns (address) {
851         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
852 
853         return _tokenApprovals[tokenId];
854     }
855 
856     /**
857      * @dev See {IERC721-setApprovalForAll}.
858      */
859     function setApprovalForAll(address operator, bool approved) public override {
860         require(operator != _msgSender(), 'ERC721A: approve to caller');
861 
862         _operatorApprovals[_msgSender()][operator] = approved;
863         emit ApprovalForAll(_msgSender(), operator, approved);
864     }
865 
866     /**
867      * @dev See {IERC721-isApprovedForAll}.
868      */
869     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
870         return _operatorApprovals[owner][operator];
871     }
872 
873     /**
874      * @dev See {IERC721-transferFrom}.
875      */
876     function transferFrom(
877         address from,
878         address to,
879         uint256 tokenId
880     ) public override {
881         require(!_stakedTokens[tokenId].staked, "TOKEN_STAKED!");
882         _transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public override {
893         require(!_stakedTokens[tokenId].staked, "TOKEN_STAKED!");
894         safeTransferFrom(from, to, tokenId, '');
895     }
896 
897     /**
898      * @dev See {IERC721-safeTransferFrom}.
899      */
900     function safeTransferFrom(
901         address from,
902         address to,
903         uint256 tokenId,
904         bytes memory _data
905     ) public override {
906         require(!_stakedTokens[tokenId].staked, "TOKEN_STAKED!");
907         _transfer(from, to, tokenId);
908         require(
909             _checkOnERC721Received(from, to, tokenId, _data),
910             'ERC721A: transfer to non ERC721Receiver implementer'
911         );
912     }
913 
914     /**
915      * @dev Returns whether `tokenId` exists.
916      *
917      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
918      *
919      * Tokens start existing when they are minted (`_mint`),
920      */
921     function _exists(uint256 tokenId) internal view returns (bool) {
922         return tokenId < currentIndex && tokenId > 0;
923     }
924 
925     function _safeMint(address to, uint256 quantity) internal {
926         _safeMint(to, quantity, '');
927     }
928 
929     /**
930      * @dev Safely mints `quantity` tokens and transfers them to `to`.
931      *
932      * Requirements:
933      *
934      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
935      * - `quantity` must be greater than 0.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _safeMint(
940         address to,
941         uint256 quantity,
942         bytes memory _data
943     ) internal {
944         _mint(to, quantity, _data, true);
945     }
946 
947     /**
948      * @dev Mints `quantity` tokens and transfers them to `to`.
949      *
950      * Requirements:
951      *
952      * - `to` cannot be the zero address.
953      * - `quantity` must be greater than 0.
954      *
955      * Emits a {Transfer} event.
956      */
957     function _mint(
958         address to,
959         uint256 quantity,
960         bytes memory _data,
961         bool safe
962     ) internal {
963         uint256 startTokenId = currentIndex;
964         require(to != address(0), 'ERC721A: mint to the zero address');
965         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
966 
967         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
968 
969         // Overflows are incredibly unrealistic.
970         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
971         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
972         unchecked {
973             _addressData[to].balance += uint128(quantity);
974             _addressData[to].numberMinted += uint128(quantity);
975 
976             _ownerships[startTokenId].addr = to;
977             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
978 
979             uint256 updatedIndex = startTokenId;
980 
981             for (uint256 i; i < quantity; i++) {
982                 emit Transfer(address(0), to, updatedIndex);
983                 if (safe) {
984                     require(
985                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
986                         'ERC721A: transfer to non ERC721Receiver implementer'
987                     );
988                 }
989 
990                 updatedIndex++;
991             }
992 
993             currentIndex = updatedIndex;
994         }
995 
996         _afterTokenTransfers(address(0), to, startTokenId, quantity);
997     }
998 
999     /**
1000      * @dev Transfers `tokenId` from `from` to `to`.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must be owned by `from`.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) private {
1014         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1015 
1016         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1017             getApproved(tokenId) == _msgSender() ||
1018             isApprovedForAll(prevOwnership.addr, _msgSender()));
1019 
1020         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1021 
1022         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1023         require(to != address(0), 'ERC721A: transfer to the zero address');
1024 
1025         _beforeTokenTransfers(from, to, tokenId, 1);
1026 
1027         // Clear approvals from the previous owner
1028         _approve(address(0), tokenId, prevOwnership.addr);
1029 
1030         // Underflow of the sender's balance is impossible because we check for
1031         // ownership above and the recipient's balance can't realistically overflow.
1032         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1033         unchecked {
1034             _addressData[from].balance -= 1;
1035             _addressData[to].balance += 1;
1036 
1037             _ownerships[tokenId].addr = to;
1038             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1039 
1040             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1041             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1042             uint256 nextTokenId = tokenId + 1;
1043             if (_ownerships[nextTokenId].addr == address(0)) {
1044                 if (_exists(nextTokenId)) {
1045                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1046                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1047                 }
1048             }
1049         }
1050 
1051         emit Transfer(from, to, tokenId);
1052         _afterTokenTransfers(from, to, tokenId, 1);
1053     }
1054 
1055     /**
1056      * @dev Approve `to` to operate on `tokenId`
1057      *
1058      * Emits a {Approval} event.
1059      */
1060     function _approve(
1061         address to,
1062         uint256 tokenId,
1063         address owner
1064     ) private {
1065         _tokenApprovals[tokenId] = to;
1066         emit Approval(owner, to, tokenId);
1067     }
1068 
1069     /**
1070      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1071      * The call is not executed if the target address is not a contract.
1072      *
1073      * @param from address representing the previous owner of the given token ID
1074      * @param to target address that will receive the tokens
1075      * @param tokenId uint256 ID of the token to be transferred
1076      * @param _data bytes optional data to send along with the call
1077      * @return bool whether the call correctly returned the expected magic value
1078      */
1079     function _checkOnERC721Received(
1080         address from,
1081         address to,
1082         uint256 tokenId,
1083         bytes memory _data
1084     ) private returns (bool) {
1085         if (to.isContract()) {
1086             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1087                 return retval == IERC721Receiver(to).onERC721Received.selector;
1088             } catch (bytes memory reason) {
1089                 if (reason.length == 0) {
1090                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1091                 } else {
1092                     assembly {
1093                         revert(add(32, reason), mload(reason))
1094                     }
1095                 }
1096             }
1097         } else {
1098             return true;
1099         }
1100     }
1101 
1102     /**
1103      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1104      *
1105      * startTokenId - the first token id to be transferred
1106      * quantity - the amount to be transferred
1107      *
1108      * Calling conditions:
1109      *
1110      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1111      * transferred to `to`.
1112      * - When `from` is zero, `tokenId` will be minted for `to`.
1113      */
1114     function _beforeTokenTransfers(
1115         address from,
1116         address to,
1117         uint256 startTokenId,
1118         uint256 quantity
1119     ) internal virtual {}
1120 
1121     /**
1122      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1123      * minting.
1124      *
1125      * startTokenId - the first token id to be transferred
1126      * quantity - the amount to be transferred
1127      *
1128      * Calling conditions:
1129      *
1130      * - when `from` and `to` are both non-zero.
1131      * - `from` and `to` are never both zero.
1132      */
1133     function _afterTokenTransfers(
1134         address from,
1135         address to,
1136         uint256 startTokenId,
1137         uint256 quantity
1138     ) internal virtual {}
1139 }
1140 
1141 contract PleaseKeepSmiling is ERC721A, Ownable {
1142 
1143     constructor() ERC721A("PleaseKeepSmiling", "PKS") {}
1144 
1145     uint public maxSupply = 5000;
1146     bool public saleStatus;
1147     uint public price;   
1148     uint public maxPerTx = 5;    
1149     uint public maxPerWallet = 20;
1150     uint public freeMintPrice = 0;
1151     uint public maxFreePerTx = 1;    
1152     uint public maxFreePerWallet = 1;  
1153 
1154  
1155     // ---------------------------------------------------------------------------------------------
1156     // MAPPINGS
1157     // ---------------------------------------------------------------------------------------------
1158 
1159     mapping(address => uint) public _minted; 
1160 
1161     mapping(address => uint) public _freeminted; 
1162 
1163     // ---------------------------------------------------------------------------------------------
1164     // OWNER SETTERS
1165     // ---------------------------------------------------------------------------------------------
1166 
1167     function withdraw() external onlyOwner {
1168         payable(msg.sender).transfer(address(this).balance);
1169     }
1170 
1171     function setSaleStatus() external onlyOwner {
1172         saleStatus = !saleStatus;
1173     }
1174 
1175     function setMaxSupply(uint supply) external onlyOwner {
1176         maxSupply = supply;
1177     }
1178 
1179     function setPrice(uint amount) external onlyOwner {
1180         price = amount;
1181     }
1182     
1183     function setMaxPerTx(uint amount) external onlyOwner {
1184         maxPerTx = amount;
1185     }
1186     
1187     function setMaxPerWallet(uint amount) external onlyOwner {
1188         maxPerWallet = amount;
1189     }
1190 
1191     function setMaxFreePerTx(uint amount) external onlyOwner {
1192         maxFreePerTx = amount;
1193     }
1194     
1195     function setMaxFreePerWallet(uint amount) external onlyOwner {
1196         maxFreePerWallet = amount;
1197     }
1198     
1199     function setBaseURI(string calldata _uri) external onlyOwner {
1200         uri = _uri;
1201     }
1202 
1203     function getTotalSupply() public view returns(uint) {
1204         return currentIndex - 1;
1205     }
1206 
1207     function getMaxSupply() public view returns(uint) {
1208         return maxSupply;
1209     }
1210 
1211     // ---------------------------------------------------------------------------------------------
1212     // PUBLIC SETTERS
1213     // ---------------------------------------------------------------------------------------------
1214 
1215     function devmint(uint256 amount) external onlyOwner {
1216         require(currentIndex <= maxSupply, "NOT_ALLOWED!");
1217         require(((currentIndex + amount)-1) <= maxSupply, "NOT_ENOUGH_TOKENS");
1218         _safeMint(msg.sender, amount);
1219     }
1220 
1221     function freemint(uint256 amount) external payable {
1222         require(saleStatus, "SALE_NOT_ACTIVE!");
1223         require(amount * freeMintPrice == msg.value, "NOT_ENOUGH_MONEY!");
1224         require(amount <= maxFreePerTx, "EXCEEDS_MAX_PER_TX!");
1225         require(currentIndex <= maxSupply, "NOT_ENOUGH_TOKENS!");
1226         require(((currentIndex + amount)-1) <= maxSupply, "NOT_ENOUGH_TOKENS");
1227         require(_freeminted[msg.sender] + amount <= maxFreePerWallet, "EXCEEDS_MAX_PER_WALLET!");
1228         _safeMint(msg.sender, amount);
1229         _freeminted[msg.sender] += amount;
1230     }
1231 
1232     function mint(uint256 amount) external payable {
1233         require(saleStatus, "SALE_NOT_ACTIVE!");
1234         require(amount * price == msg.value, "NOT_ENOUGH_MONEY!");
1235         require(amount <= maxPerTx, "EXCEEDS_MAX_PER_TX!");
1236         require(currentIndex <= maxSupply, "NOT_ENOUGH_TOKENS!");
1237         require(((currentIndex + amount)-1) <= maxSupply, "NOT_ENOUGH_TOKENS");
1238         require(_minted[msg.sender] + amount <= maxPerWallet, "EXCEEDS_MAX_PER_WALLET!");
1239         _safeMint(msg.sender, amount);
1240         _minted[msg.sender] += amount;
1241     }
1242 }