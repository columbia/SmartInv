1 /**
2  ▄▄ •       ▄▄▄▄· ▄▄▌  ▪   ▐ ▄      ▄ .▄      ▄▄▄  .▄▄ · ▄▄▄ ..▄▄ · 
3 ▐█ ▀ ▪▪     ▐█ ▀█▪██•  ██ •█▌▐█    ██▪▐█▪     ▀▄ █·▐█ ▀. ▀▄.▀·▐█ ▀. 
4 ▄█ ▀█▄ ▄█▀▄ ▐█▀▀█▄██▪  ▐█·▐█▐▐▌    ██▀▐█ ▄█▀▄ ▐▀▀▄ ▄▀▀▀█▄▐▀▀▪▄▄▀▀▀█▄
5 ▐█▄▪▐█▐█▌.▐▌██▄▪▐█▐█▌▐▌▐█▌██▐█▌    ██▌▐▀▐█▌.▐▌▐█•█▌▐█▄▪▐█▐█▄▄▌▐█▄▪▐█
6 ·▀▀▀▀  ▀█▄▀▪·▀▀▀▀ .▀▀▀ ▀▀▀▀▀ █▪    ▀▀▀ · ▀█▄▀▪.▀  ▀ ▀▀▀▀  ▀▀▀  ▀▀▀▀                                                                                                                                                                                     
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.12;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 
76 
77 /**
78  * @dev Provides information about the current execution context, including the
79  * sender of the transaction and its data. While these are generally available
80  * via msg.sender and msg.data, they should not be accessed in such a direct
81  * manner, since when dealing with meta-transactions the account sending and
82  * paying for execution may not be the actual sender (as far as an application
83  * is concerned).
84  *
85  * This contract is only required for intermediate, library-like contracts.
86  */
87 abstract contract Context {
88     function _msgSender() internal view virtual returns (address) {
89         return msg.sender;
90     }
91 
92     function _msgData() internal view virtual returns (bytes calldata) {
93         return msg.data;
94     }
95 }
96 
97 /**
98  * @dev Contract module which provides a basic access control mechanism, where
99  * there is an account (an owner) that can be granted exclusive access to
100  * specific functions.
101  *
102  * By default, the owner account will be the one that deploys the contract. This
103  * can later be changed with {transferOwnership}.
104  *
105  * This module is used through inheritance. It will make available the modifier
106  * `onlyOwner`, which can be applied to your functions to restrict their use to
107  * the owner.
108  */
109 abstract contract Ownable is Context {
110     address private _owner;
111 
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     /**
115      * @dev Initializes the contract setting the deployer as the initial owner.
116      */
117     constructor() {
118         _setOwner(_msgSender());
119     }
120 
121     /**
122      * @dev Returns the address of the current owner.
123      */
124     function owner() public view virtual returns (address) {
125         return _owner;
126     }
127 
128     /**
129      * @dev Throws if called by any account other than the owner.
130      */
131     modifier onlyOwner() {
132         require(owner() == _msgSender(), "Ownable: caller is not the owner");
133         _;
134     }
135 
136     /**
137      * @dev Leaves the contract without owner. It will not be possible to call
138      * `onlyOwner` functions anymore. Can only be called by the current owner.
139      *
140      * NOTE: Renouncing ownership will leave the contract without an owner,
141      * thereby removing any functionality that is only available to the owner.
142      */
143     function renounceOwnership() public virtual onlyOwner {
144         _setOwner(address(0));
145     }
146 
147     /**
148      * @dev Transfers ownership of the contract to a new account (`newOwner`).
149      * Can only be called by the current owner.
150      */
151     function transferOwnership(address newOwner) public virtual onlyOwner {
152         require(newOwner != address(0), "Ownable: new owner is the zero address");
153         _setOwner(newOwner);
154     }
155 
156     function _setOwner(address newOwner) private {
157         address oldOwner = _owner;
158         _owner = newOwner;
159         emit OwnershipTransferred(oldOwner, newOwner);
160     }
161 }
162 
163 /**
164  * @dev Collection of functions related to the address type
165  */
166 library Address {
167     /**
168      * @dev Returns true if `account` is a contract.
169      *
170      * [IMPORTANT]
171      * ====
172      * It is unsafe to assume that an address for which this function returns
173      * false is an externally-owned account (EOA) and not a contract.
174      *
175      * Among others, `isContract` will return false for the following
176      * types of addresses:
177      *
178      *  - an externally-owned account
179      *  - a contract in construction
180      *  - an address where a contract will be created
181      *  - an address where a contract lived, but was destroyed
182      * ====
183      */
184     function isContract(address account) internal view returns (bool) {
185         // This method relies on extcodesize, which returns 0 for contracts in
186         // construction, since the code is only stored at the end of the
187         // constructor execution.
188 
189         uint256 size;
190         assembly {
191             size := extcodesize(account)
192         }
193         return size > 0;
194     }
195 
196     /**
197      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
198      * `recipient`, forwarding all available gas and reverting on errors.
199      *
200      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
201      * of certain opcodes, possibly making contracts go over the 2300 gas limit
202      * imposed by `transfer`, making them unable to receive funds via
203      * `transfer`. {sendValue} removes this limitation.
204      *
205      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
206      *
207      * IMPORTANT: because control is transferred to `recipient`, care must be
208      * taken to not create reentrancy vulnerabilities. Consider using
209      * {ReentrancyGuard} or the
210      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
211      */
212     function sendValue(address payable recipient, uint256 amount) internal {
213         require(address(this).balance >= amount, "Address: insufficient balance");
214 
215         (bool success, ) = recipient.call{value: amount}("");
216         require(success, "Address: unable to send value, recipient may have reverted");
217     }
218 
219     /**
220      * @dev Performs a Solidity function call using a low level `call`. A
221      * plain `call` is an unsafe replacement for a function call: use this
222      * function instead.
223      *
224      * If `target` reverts with a revert reason, it is bubbled up by this
225      * function (like regular Solidity function calls).
226      *
227      * Returns the raw returned data. To convert to the expected return value,
228      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
229      *
230      * Requirements:
231      *
232      * - `target` must be a contract.
233      * - calling `target` with `data` must not revert.
234      *
235      * _Available since v3.1._
236      */
237     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
238         return functionCall(target, data, "Address: low-level call failed");
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
243      * `errorMessage` as a fallback revert reason when `target` reverts.
244      *
245      * _Available since v3.1._
246      */
247     function functionCall(
248         address target,
249         bytes memory data,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, 0, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but also transferring `value` wei to `target`.
258      *
259      * Requirements:
260      *
261      * - the calling contract must have an ETH balance of at least `value`.
262      * - the called Solidity function must be `payable`.
263      *
264      * _Available since v3.1._
265      */
266     function functionCallWithValue(
267         address target,
268         bytes memory data,
269         uint256 value
270     ) internal returns (bytes memory) {
271         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
276      * with `errorMessage` as a fallback revert reason when `target` reverts.
277      *
278      * _Available since v3.1._
279      */
280     function functionCallWithValue(
281         address target,
282         bytes memory data,
283         uint256 value,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         require(address(this).balance >= value, "Address: insufficient balance for call");
287         require(isContract(target), "Address: call to non-contract");
288 
289         (bool success, bytes memory returndata) = target.call{value: value}(data);
290         return verifyCallResult(success, returndata, errorMessage);
291     }
292 
293     /**
294      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
295      * but performing a static call.
296      *
297      * _Available since v3.3._
298      */
299     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
300         return functionStaticCall(target, data, "Address: low-level static call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
305      * but performing a static call.
306      *
307      * _Available since v3.3._
308      */
309     function functionStaticCall(
310         address target,
311         bytes memory data,
312         string memory errorMessage
313     ) internal view returns (bytes memory) {
314         require(isContract(target), "Address: static call to non-contract");
315 
316         (bool success, bytes memory returndata) = target.staticcall(data);
317         return verifyCallResult(success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a delegate call.
323      *
324      * _Available since v3.4._
325      */
326     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a delegate call.
333      *
334      * _Available since v3.4._
335      */
336     function functionDelegateCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         require(isContract(target), "Address: delegate call to non-contract");
342 
343         (bool success, bytes memory returndata) = target.delegatecall(data);
344         return verifyCallResult(success, returndata, errorMessage);
345     }
346 
347     /**
348      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
349      * revert reason using the provided one.
350      *
351      * _Available since v4.3._
352      */
353     function verifyCallResult(
354         bool success,
355         bytes memory returndata,
356         string memory errorMessage
357     ) internal pure returns (bytes memory) {
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 assembly {
366                     let returndata_size := mload(returndata)
367                     revert(add(32, returndata), returndata_size)
368                 }
369             } else {
370                 revert(errorMessage);
371             }
372         }
373     }
374 }
375 
376 /**
377  * @title ERC721 token receiver interface
378  * @dev Interface for any contract that wants to support safeTransfers
379  * from ERC721 asset contracts.
380  */
381 interface IERC721Receiver {
382     /**
383      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
384      * by `operator` from `from`, this function is called.
385      *
386      * It must return its Solidity selector to confirm the token transfer.
387      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
388      *
389      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
390      */
391     function onERC721Received(
392         address operator,
393         address from,
394         uint256 tokenId,
395         bytes calldata data
396     ) external returns (bytes4);
397 }
398 
399 /**
400  * @dev Interface of the ERC165 standard, as defined in the
401  * https://eips.ethereum.org/EIPS/eip-165[EIP].
402  *
403  * Implementers can declare support of contract interfaces, which can then be
404  * queried by others ({ERC165Checker}).
405  *
406  * For an implementation, see {ERC165}.
407  */
408 interface IERC165 {
409     /**
410      * @dev Returns true if this contract implements the interface defined by
411      * `interfaceId`. See the corresponding
412      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
413      * to learn more about how these ids are created.
414      *
415      * This function call must use less than 30 000 gas.
416      */
417     function supportsInterface(bytes4 interfaceId) external view returns (bool);
418 }
419 
420 /**
421  * @dev Implementation of the {IERC165} interface.
422  *
423  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
424  * for the additional interface id that will be supported. For example:
425  *
426  * ```solidity
427  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
428  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
429  * }
430  * ```
431  *
432  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
433  */
434 abstract contract ERC165 is IERC165 {
435     /**
436      * @dev See {IERC165-supportsInterface}.
437      */
438     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
439         return interfaceId == type(IERC165).interfaceId;
440     }
441 }
442 
443 /**
444  * @dev Required interface of an ERC721 compliant contract.
445  */
446 interface IERC721 is IERC165 {
447     /**
448      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
449      */
450     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
451 
452     /**
453      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
454      */
455     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
456 
457     /**
458      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
459      */
460     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
461 
462     /**
463      * @dev Returns the number of tokens in ``owner``'s account.
464      */
465     function balanceOf(address owner) external view returns (uint256 balance);
466 
467     /**
468      * @dev Returns the owner of the `tokenId` token.
469      *
470      * Requirements:
471      *
472      * - `tokenId` must exist.
473      */
474     function ownerOf(uint256 tokenId) external view returns (address owner);
475 
476     /**
477      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
478      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must exist and be owned by `from`.
485      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
486      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
487      *
488      * Emits a {Transfer} event.
489      */
490     function safeTransferFrom(
491         address from,
492         address to,
493         uint256 tokenId
494     ) external;
495 
496     /**
497      * @dev Transfers `tokenId` token from `from` to `to`.
498      *
499      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must be owned by `from`.
506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
507      *
508      * Emits a {Transfer} event.
509      */
510     function transferFrom(
511         address from,
512         address to,
513         uint256 tokenId
514     ) external;
515 
516     /**
517      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
518      * The approval is cleared when the token is transferred.
519      *
520      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
521      *
522      * Requirements:
523      *
524      * - The caller must own the token or be an approved operator.
525      * - `tokenId` must exist.
526      *
527      * Emits an {Approval} event.
528      */
529     function approve(address to, uint256 tokenId) external;
530 
531     /**
532      * @dev Returns the account approved for `tokenId` token.
533      *
534      * Requirements:
535      *
536      * - `tokenId` must exist.
537      */
538     function getApproved(uint256 tokenId) external view returns (address operator);
539 
540     /**
541      * @dev Approve or remove `operator` as an operator for the caller.
542      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
543      *
544      * Requirements:
545      *
546      * - The `operator` cannot be the caller.
547      *
548      * Emits an {ApprovalForAll} event.
549      */
550     function setApprovalForAll(address operator, bool _approved) external;
551 
552     /**
553      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
554      *
555      * See {setApprovalForAll}
556      */
557     function isApprovedForAll(address owner, address operator) external view returns (bool);
558 
559     /**
560      * @dev Safely transfers `tokenId` token from `from` to `to`.
561      *
562      * Requirements:
563      *
564      * - `from` cannot be the zero address.
565      * - `to` cannot be the zero address.
566      * - `tokenId` token must exist and be owned by `from`.
567      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
569      *
570      * Emits a {Transfer} event.
571      */
572     function safeTransferFrom(
573         address from,
574         address to,
575         uint256 tokenId,
576         bytes calldata data
577     ) external;
578 }
579 
580 /**
581  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
582  * @dev See https://eips.ethereum.org/EIPS/eip-721
583  */
584 interface IERC721Enumerable is IERC721 {
585     /**
586      * @dev Returns the total amount of tokens stored by the contract.
587      */
588     function totalSupply() external view returns (uint256);
589 
590     /**
591      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
592      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
593      */
594     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
595 
596     /**
597      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
598      * Use along with {totalSupply} to enumerate all tokens.
599      */
600     function tokenByIndex(uint256 index) external view returns (uint256);
601 }
602 
603 
604 /**
605  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
606  * @dev See https://eips.ethereum.org/EIPS/eip-721
607  */
608 interface IERC721Metadata is IERC721 {
609     /**
610      * @dev Returns the token collection name.
611      */
612     function name() external view returns (string memory);
613 
614     /**
615      * @dev Returns the token collection symbol.
616      */
617     function symbol() external view returns (string memory);
618 
619     /**
620      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
621      */
622     function tokenURI(uint256 tokenId) external view returns (string memory);
623 }
624 
625 /**
626  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
627  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
628  *
629  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
630  *
631  * Does not support burning tokens to address(0).
632  *
633  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
634  */
635 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
636     using Address for address;
637     using Strings for uint256;
638 
639     struct StakingInfo {
640         bool staked;
641         bool usedForMint;
642         uint duration;
643     }
644 
645     struct TokenOwnership {
646         address addr;
647         uint64 startTimestamp;
648     }
649 
650     struct AddressData {
651         uint128 balance;
652         uint128 numberMinted;
653     }
654 
655     uint256 public currentIndex = 1;
656 
657     // Token name
658     string private _name;
659 
660     // Token symbol
661     string private _symbol;
662 
663     string internal uri;
664 
665     // Mapping from token ID to ownership details
666     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
667     mapping(uint256 => TokenOwnership) internal _ownerships;
668 
669     // Mapping owner address to address data
670     mapping(address => AddressData) private _addressData;
671 
672     // Mapping from token ID to approved address
673     mapping(uint256 => address) private _tokenApprovals;
674 
675     // Mapping from owner to operator approvals
676     mapping(address => mapping(address => bool)) private _operatorApprovals;
677 
678     mapping(uint => StakingInfo) public _stakedTokens;
679 
680     constructor(string memory name_, string memory symbol_) {
681         _name = name_;
682         _symbol = symbol_;
683     }
684 
685     /**
686      * @dev See {IERC721Enumerable-totalSupply}.
687      */
688     function totalSupply() public view override returns (uint256) {
689         return currentIndex - 1;
690     }
691 
692     /**
693      * @dev See {IERC721Enumerable-tokenByIndex}.
694      */
695     function tokenByIndex(uint256 index) public view override returns (uint256) {
696         require(index < totalSupply(), 'ERC721A: global index out of bounds');
697         return index;
698     }
699 
700     /**
701      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
702      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
703      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
704      */
705     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
706         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
707         uint256 numMintedSoFar = totalSupply();
708         uint256 tokenIdsIdx;
709         address currOwnershipAddr;
710 
711         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
712         unchecked {
713             for (uint256 i; i < numMintedSoFar; i++) {
714                 TokenOwnership memory ownership = _ownerships[i];
715                 if (ownership.addr != address(0)) {
716                     currOwnershipAddr = ownership.addr;
717                 }
718                 if (currOwnershipAddr == owner) {
719                     if (tokenIdsIdx == index) {
720                         return i;
721                     }
722                     tokenIdsIdx++;
723                 }
724             }
725         }
726 
727         revert('ERC721A: unable to get token of owner by index');
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
734         return
735             interfaceId == type(IERC721).interfaceId ||
736             interfaceId == type(IERC721Metadata).interfaceId ||
737             interfaceId == type(IERC721Enumerable).interfaceId ||
738             super.supportsInterface(interfaceId);
739     }
740 
741     /**
742      * @dev See {IERC721-balanceOf}.
743      */
744     function balanceOf(address owner) public view override returns (uint256) {
745         require(owner != address(0), 'ERC721A: balance query for the zero address');
746         return uint256(_addressData[owner].balance);
747     }
748 
749     function _numberMinted(address owner) internal view returns (uint256) {
750         require(owner != address(0), 'ERC721A: number minted query for the zero address');
751         return uint256(_addressData[owner].numberMinted);
752     }
753 
754     /**
755      * Gas spent here starts off proportional to the maximum mint batch size.
756      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
757      */
758     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
759         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
760 
761         unchecked {
762             for (uint256 curr = tokenId; curr >= 0; curr--) {
763                 TokenOwnership memory ownership = _ownerships[curr];
764                 if (ownership.addr != address(0)) {
765                     return ownership;
766                 }
767             }
768         }
769 
770         revert('ERC721A: unable to determine the owner of token');
771     }
772 
773     /**
774      * @dev See {IERC721-ownerOf}.
775      */
776     function ownerOf(uint256 tokenId) public view override returns (address) {
777         return ownershipOf(tokenId).addr;
778     }
779 
780     /**
781      * @dev See {IERC721Metadata-name}.
782      */
783     function name() public view virtual override returns (string memory) {
784         return _name;
785     }
786 
787     /**
788      * @dev See {IERC721Metadata-symbol}.
789      */
790     function symbol() public view virtual override returns (string memory) {
791         return _symbol;
792     }
793 
794     /**
795      * @dev See {IERC721Metadata-tokenURI}.
796      */
797     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
798         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
799 
800         string memory baseURI = _baseURI();
801         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
802     }
803 
804     /**
805      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
806      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
807      * by default, can be overriden in child contracts.
808      */
809     function _baseURI() internal view virtual returns (string memory) {
810         return uri;
811     }
812 
813     /**
814      * @dev See {IERC721-approve}.
815      */
816     function approve(address to, uint256 tokenId) public override {
817         address owner = ERC721A.ownerOf(tokenId);
818         require(to != owner, 'ERC721A: approval to current owner');
819 
820         require(
821             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
822             'ERC721A: approve caller is not owner nor approved for all'
823         );
824 
825         _approve(to, tokenId, owner);
826     }
827 
828     /**
829      * @dev See {IERC721-getApproved}.
830      */
831     function getApproved(uint256 tokenId) public view override returns (address) {
832         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
833 
834         return _tokenApprovals[tokenId];
835     }
836 
837     /**
838      * @dev See {IERC721-setApprovalForAll}.
839      */
840     function setApprovalForAll(address operator, bool approved) public override {
841         require(operator != _msgSender(), 'ERC721A: approve to caller');
842 
843         _operatorApprovals[_msgSender()][operator] = approved;
844         emit ApprovalForAll(_msgSender(), operator, approved);
845     }
846 
847     /**
848      * @dev See {IERC721-isApprovedForAll}.
849      */
850     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
851         return _operatorApprovals[owner][operator];
852     }
853 
854     /**
855      * @dev See {IERC721-transferFrom}.
856      */
857     function transferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) public override {
862         require(!_stakedTokens[tokenId].staked, "TOKEN_STAKED!");
863         _transfer(from, to, tokenId);
864     }
865 
866     /**
867      * @dev See {IERC721-safeTransferFrom}.
868      */
869     function safeTransferFrom(
870         address from,
871         address to,
872         uint256 tokenId
873     ) public override {
874         require(!_stakedTokens[tokenId].staked, "TOKEN_STAKED!");
875         safeTransferFrom(from, to, tokenId, '');
876     }
877 
878     /**
879      * @dev See {IERC721-safeTransferFrom}.
880      */
881     function safeTransferFrom(
882         address from,
883         address to,
884         uint256 tokenId,
885         bytes memory _data
886     ) public override {
887         require(!_stakedTokens[tokenId].staked, "TOKEN_STAKED!");
888         _transfer(from, to, tokenId);
889         require(
890             _checkOnERC721Received(from, to, tokenId, _data),
891             'ERC721A: transfer to non ERC721Receiver implementer'
892         );
893     }
894 
895     /**
896      * @dev Returns whether `tokenId` exists.
897      *
898      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
899      *
900      * Tokens start existing when they are minted (`_mint`),
901      */
902     function _exists(uint256 tokenId) internal view returns (bool) {
903         return tokenId < currentIndex && tokenId > 0;
904     }
905 
906     function _safeMint(address to, uint256 quantity) internal {
907         _safeMint(to, quantity, '');
908     }
909 
910     /**
911      * @dev Safely mints `quantity` tokens and transfers them to `to`.
912      *
913      * Requirements:
914      *
915      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
916      * - `quantity` must be greater than 0.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _safeMint(
921         address to,
922         uint256 quantity,
923         bytes memory _data
924     ) internal {
925         _mint(to, quantity, _data, true);
926     }
927 
928     /**
929      * @dev Mints `quantity` tokens and transfers them to `to`.
930      *
931      * Requirements:
932      *
933      * - `to` cannot be the zero address.
934      * - `quantity` must be greater than 0.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _mint(
939         address to,
940         uint256 quantity,
941         bytes memory _data,
942         bool safe
943     ) internal {
944         uint256 startTokenId = currentIndex;
945         require(to != address(0), 'ERC721A: mint to the zero address');
946         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
947 
948         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
949 
950         // Overflows are incredibly unrealistic.
951         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
952         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
953         unchecked {
954             _addressData[to].balance += uint128(quantity);
955             _addressData[to].numberMinted += uint128(quantity);
956 
957             _ownerships[startTokenId].addr = to;
958             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
959 
960             uint256 updatedIndex = startTokenId;
961 
962             for (uint256 i; i < quantity; i++) {
963                 emit Transfer(address(0), to, updatedIndex);
964                 if (safe) {
965                     require(
966                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
967                         'ERC721A: transfer to non ERC721Receiver implementer'
968                     );
969                 }
970 
971                 updatedIndex++;
972             }
973 
974             currentIndex = updatedIndex;
975         }
976 
977         _afterTokenTransfers(address(0), to, startTokenId, quantity);
978     }
979 
980     /**
981      * @dev Transfers `tokenId` from `from` to `to`.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must be owned by `from`.
987      *
988      * Emits a {Transfer} event.
989      */
990     function _transfer(
991         address from,
992         address to,
993         uint256 tokenId
994     ) private {
995         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
996 
997         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
998             getApproved(tokenId) == _msgSender() ||
999             isApprovedForAll(prevOwnership.addr, _msgSender()));
1000 
1001         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1002 
1003         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1004         require(to != address(0), 'ERC721A: transfer to the zero address');
1005 
1006         _beforeTokenTransfers(from, to, tokenId, 1);
1007 
1008         // Clear approvals from the previous owner
1009         _approve(address(0), tokenId, prevOwnership.addr);
1010 
1011         // Underflow of the sender's balance is impossible because we check for
1012         // ownership above and the recipient's balance can't realistically overflow.
1013         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1014         unchecked {
1015             _addressData[from].balance -= 1;
1016             _addressData[to].balance += 1;
1017 
1018             _ownerships[tokenId].addr = to;
1019             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1020 
1021             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1022             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1023             uint256 nextTokenId = tokenId + 1;
1024             if (_ownerships[nextTokenId].addr == address(0)) {
1025                 if (_exists(nextTokenId)) {
1026                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1027                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1028                 }
1029             }
1030         }
1031 
1032         emit Transfer(from, to, tokenId);
1033         _afterTokenTransfers(from, to, tokenId, 1);
1034     }
1035 
1036     /**
1037      * @dev Approve `to` to operate on `tokenId`
1038      *
1039      * Emits a {Approval} event.
1040      */
1041     function _approve(
1042         address to,
1043         uint256 tokenId,
1044         address owner
1045     ) private {
1046         _tokenApprovals[tokenId] = to;
1047         emit Approval(owner, to, tokenId);
1048     }
1049 
1050     /**
1051      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1052      * The call is not executed if the target address is not a contract.
1053      *
1054      * @param from address representing the previous owner of the given token ID
1055      * @param to target address that will receive the tokens
1056      * @param tokenId uint256 ID of the token to be transferred
1057      * @param _data bytes optional data to send along with the call
1058      * @return bool whether the call correctly returned the expected magic value
1059      */
1060     function _checkOnERC721Received(
1061         address from,
1062         address to,
1063         uint256 tokenId,
1064         bytes memory _data
1065     ) private returns (bool) {
1066         if (to.isContract()) {
1067             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1068                 return retval == IERC721Receiver(to).onERC721Received.selector;
1069             } catch (bytes memory reason) {
1070                 if (reason.length == 0) {
1071                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1072                 } else {
1073                     assembly {
1074                         revert(add(32, reason), mload(reason))
1075                     }
1076                 }
1077             }
1078         } else {
1079             return true;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1085      *
1086      * startTokenId - the first token id to be transferred
1087      * quantity - the amount to be transferred
1088      *
1089      * Calling conditions:
1090      *
1091      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1092      * transferred to `to`.
1093      * - When `from` is zero, `tokenId` will be minted for `to`.
1094      */
1095     function _beforeTokenTransfers(
1096         address from,
1097         address to,
1098         uint256 startTokenId,
1099         uint256 quantity
1100     ) internal virtual {}
1101 
1102     /**
1103      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1104      * minting.
1105      *
1106      * startTokenId - the first token id to be transferred
1107      * quantity - the amount to be transferred
1108      *
1109      * Calling conditions:
1110      *
1111      * - when `from` and `to` are both non-zero.
1112      * - `from` and `to` are never both zero.
1113      */
1114     function _afterTokenTransfers(
1115         address from,
1116         address to,
1117         uint256 startTokenId,
1118         uint256 quantity
1119     ) internal virtual {}
1120 }
1121 
1122 contract GoblinHorses is ERC721A, Ownable {
1123 
1124     constructor() ERC721A("GoblinHorses", "GHRS") {}
1125 
1126     uint public maxSupply = 2222;
1127     bool public saleStatus;
1128     uint public price;   
1129     uint public maxPerTx = 3;    
1130     uint public maxPerWallet = 6;
1131     uint public freeMintPrice = 0;
1132     uint public maxFreePerTx = 1;    
1133     uint public maxFreePerWallet = 1;  
1134 
1135  
1136     // ---------------------------------------------------------------------------------------------
1137     // MAPPINGS
1138     // ---------------------------------------------------------------------------------------------
1139 
1140     mapping(address => uint) public _minted; 
1141 
1142     mapping(address => uint) public _freeminted; 
1143 
1144     // ---------------------------------------------------------------------------------------------
1145     // OWNER SETTERS
1146     // ---------------------------------------------------------------------------------------------
1147 
1148     function withdraw() external onlyOwner {
1149         payable(msg.sender).transfer(address(this).balance);
1150     }
1151 
1152     function setSaleStatus() external onlyOwner {
1153         saleStatus = !saleStatus;
1154     }
1155 
1156     function setMaxSupply(uint supply) external onlyOwner {
1157         maxSupply = supply;
1158     }
1159 
1160     function setPrice(uint amount) external onlyOwner {
1161         price = amount;
1162     }
1163     
1164     function setMaxPerTx(uint amount) external onlyOwner {
1165         maxPerTx = amount;
1166     }
1167     
1168     function setMaxPerWallet(uint amount) external onlyOwner {
1169         maxPerWallet = amount;
1170     }
1171 
1172     function setMaxFreePerTx(uint amount) external onlyOwner {
1173         maxFreePerTx = amount;
1174     }
1175     
1176     function setMaxFreePerWallet(uint amount) external onlyOwner {
1177         maxFreePerWallet = amount;
1178     }
1179     
1180     function setBaseURI(string calldata _uri) external onlyOwner {
1181         uri = _uri;
1182     }
1183 
1184     function getTotalSupply() public view returns(uint) {
1185         return currentIndex - 1;
1186     }
1187 
1188     function getMaxSupply() public view returns(uint) {
1189         return maxSupply;
1190     }
1191 
1192     // ---------------------------------------------------------------------------------------------
1193     // PUBLIC SETTERS
1194     // ---------------------------------------------------------------------------------------------
1195 
1196     function devmint(uint256 amount) external onlyOwner {
1197         require(currentIndex <= maxSupply, "NOT_ALLOWED!");
1198         require(((currentIndex + amount)-1) <= maxSupply, "NOT_ENOUGH_TOKENS");
1199         _safeMint(msg.sender, amount);
1200     }
1201 
1202     function pooorishhmint(uint256 amount) external payable {
1203         require(saleStatus, "SALE_NOT_ACTIVE!");
1204         require(amount * freeMintPrice == msg.value, "NOT_ENOUGH_MONEY!");
1205         require(amount <= maxFreePerTx, "EXCEEDS_MAX_PER_TX!");
1206         require(currentIndex <= maxSupply, "NOT_ENOUGH_TOKENS!");
1207         require(((currentIndex + amount)-1) <= maxSupply, "NOT_ENOUGH_TOKENS");
1208         require(_freeminted[msg.sender] + amount <= maxFreePerWallet, "EXCEEDS_MAX_PER_WALLET!");
1209         _safeMint(msg.sender, amount);
1210         _freeminted[msg.sender] += amount;
1211     }
1212 
1213     function reiichmint(uint256 amount) external payable {
1214         require(saleStatus, "SALE_NOT_ACTIVE!");
1215         require(amount * price == msg.value, "NOT_ENOUGH_MONEY!");
1216         require(amount <= maxPerTx, "EXCEEDS_MAX_PER_TX!");
1217         require(currentIndex <= maxSupply, "NOT_ENOUGH_TOKENS!");
1218         require(((currentIndex + amount)-1) <= maxSupply, "NOT_ENOUGH_TOKENS");
1219         require(_minted[msg.sender] + amount <= maxPerWallet, "EXCEEDS_MAX_PER_WALLET!");
1220         _safeMint(msg.sender, amount);
1221         _minted[msg.sender] += amount;
1222     }
1223 }