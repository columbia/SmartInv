1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
5 
6 // 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
28 // 
29 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _transferOwnership(_msgSender());
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         _transferOwnership(address(0));
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         _transferOwnership(newOwner);
87     }
88 
89     /**
90      * @dev Transfers ownership of the contract to a new account (`newOwner`).
91      * Internal function without access restriction.
92      */
93     function _transferOwnership(address newOwner) internal virtual {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // 
101 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
102 /**
103  * @title Counters
104  * @author Matt Condon (@shrugs)
105  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
106  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
107  *
108  * Include with `using Counters for Counters.Counter;`
109  */
110 library Counters {
111     struct Counter {
112         // This variable should never be directly accessed by users of the library: interactions must be restricted to
113         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
114         // this feature: see https://github.com/ethereum/solidity/issues/4637
115         uint256 _value; // default: 0
116     }
117 
118     function current(Counter storage counter) internal view returns (uint256) {
119         return counter._value;
120     }
121 
122     function increment(Counter storage counter) internal {
123         unchecked {
124             counter._value += 1;
125         }
126     }
127 
128     function decrement(Counter storage counter) internal {
129         uint256 value = counter._value;
130         require(value > 0, "Counter: decrement overflow");
131         unchecked {
132             counter._value = value - 1;
133         }
134     }
135 
136     function reset(Counter storage counter) internal {
137         counter._value = 0;
138     }
139 }
140 
141 // 
142 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
143 /**
144  * @dev Interface of the ERC165 standard, as defined in the
145  * https://eips.ethereum.org/EIPS/eip-165[EIP].
146  *
147  * Implementers can declare support of contract interfaces, which can then be
148  * queried by others ({ERC165Checker}).
149  *
150  * For an implementation, see {ERC165}.
151  */
152 interface IERC165 {
153     /**
154      * @dev Returns true if this contract implements the interface defined by
155      * `interfaceId`. See the corresponding
156      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
157      * to learn more about how these ids are created.
158      *
159      * This function call must use less than 30 000 gas.
160      */
161     function supportsInterface(bytes4 interfaceId) external view returns (bool);
162 }
163 
164 // 
165 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
166 /**
167  * @dev Required interface of an ERC721 compliant contract.
168  */
169 interface IERC721 is IERC165 {
170     /**
171      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
172      */
173     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
174 
175     /**
176      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
177      */
178     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
179 
180     /**
181      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
182      */
183     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
184 
185     /**
186      * @dev Returns the number of tokens in ``owner``'s account.
187      */
188     function balanceOf(address owner) external view returns (uint256 balance);
189 
190     /**
191      * @dev Returns the owner of the `tokenId` token.
192      *
193      * Requirements:
194      *
195      * - `tokenId` must exist.
196      */
197     function ownerOf(uint256 tokenId) external view returns (address owner);
198 
199     /**
200      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
201      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
202      *
203      * Requirements:
204      *
205      * - `from` cannot be the zero address.
206      * - `to` cannot be the zero address.
207      * - `tokenId` token must exist and be owned by `from`.
208      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
209      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
210      *
211      * Emits a {Transfer} event.
212      */
213     function safeTransferFrom(
214         address from,
215         address to,
216         uint256 tokenId
217     ) external;
218 
219     /**
220      * @dev Transfers `tokenId` token from `from` to `to`.
221      *
222      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
223      *
224      * Requirements:
225      *
226      * - `from` cannot be the zero address.
227      * - `to` cannot be the zero address.
228      * - `tokenId` token must be owned by `from`.
229      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transferFrom(
234         address from,
235         address to,
236         uint256 tokenId
237     ) external;
238 
239     /**
240      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
241      * The approval is cleared when the token is transferred.
242      *
243      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
244      *
245      * Requirements:
246      *
247      * - The caller must own the token or be an approved operator.
248      * - `tokenId` must exist.
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address to, uint256 tokenId) external;
253 
254     /**
255      * @dev Returns the account approved for `tokenId` token.
256      *
257      * Requirements:
258      *
259      * - `tokenId` must exist.
260      */
261     function getApproved(uint256 tokenId) external view returns (address operator);
262 
263     /**
264      * @dev Approve or remove `operator` as an operator for the caller.
265      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
266      *
267      * Requirements:
268      *
269      * - The `operator` cannot be the caller.
270      *
271      * Emits an {ApprovalForAll} event.
272      */
273     function setApprovalForAll(address operator, bool _approved) external;
274 
275     /**
276      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
277      *
278      * See {setApprovalForAll}
279      */
280     function isApprovedForAll(address owner, address operator) external view returns (bool);
281 
282     /**
283      * @dev Safely transfers `tokenId` token from `from` to `to`.
284      *
285      * Requirements:
286      *
287      * - `from` cannot be the zero address.
288      * - `to` cannot be the zero address.
289      * - `tokenId` token must exist and be owned by `from`.
290      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
291      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
292      *
293      * Emits a {Transfer} event.
294      */
295     function safeTransferFrom(
296         address from,
297         address to,
298         uint256 tokenId,
299         bytes calldata data
300     ) external;
301 }
302 
303 // 
304 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
305 /**
306  * @title ERC721 token receiver interface
307  * @dev Interface for any contract that wants to support safeTransfers
308  * from ERC721 asset contracts.
309  */
310 interface IERC721Receiver {
311     /**
312      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
313      * by `operator` from `from`, this function is called.
314      *
315      * It must return its Solidity selector to confirm the token transfer.
316      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
317      *
318      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
319      */
320     function onERC721Received(
321         address operator,
322         address from,
323         uint256 tokenId,
324         bytes calldata data
325     ) external returns (bytes4);
326 }
327 
328 // 
329 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
330 /**
331  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
332  * @dev See https://eips.ethereum.org/EIPS/eip-721
333  */
334 interface IERC721Metadata is IERC721 {
335     /**
336      * @dev Returns the token collection name.
337      */
338     function name() external view returns (string memory);
339 
340     /**
341      * @dev Returns the token collection symbol.
342      */
343     function symbol() external view returns (string memory);
344 
345     /**
346      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
347      */
348     function tokenURI(uint256 tokenId) external view returns (string memory);
349 }
350 
351 // 
352 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
353 /**
354  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
355  * @dev See https://eips.ethereum.org/EIPS/eip-721
356  */
357 interface IERC721Enumerable is IERC721 {
358     /**
359      * @dev Returns the total amount of tokens stored by the contract.
360      */
361     function totalSupply() external view returns (uint256);
362 
363     /**
364      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
365      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
366      */
367     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
368 
369     /**
370      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
371      * Use along with {totalSupply} to enumerate all tokens.
372      */
373     function tokenByIndex(uint256 index) external view returns (uint256);
374 }
375 
376 // 
377 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
378 /**
379  * @dev Collection of functions related to the address type
380  */
381 library Address {
382     /**
383      * @dev Returns true if `account` is a contract.
384      *
385      * [IMPORTANT]
386      * ====
387      * It is unsafe to assume that an address for which this function returns
388      * false is an externally-owned account (EOA) and not a contract.
389      *
390      * Among others, `isContract` will return false for the following
391      * types of addresses:
392      *
393      *  - an externally-owned account
394      *  - a contract in construction
395      *  - an address where a contract will be created
396      *  - an address where a contract lived, but was destroyed
397      * ====
398      *
399      * [IMPORTANT]
400      * ====
401      * You shouldn't rely on `isContract` to protect against flash loan attacks!
402      *
403      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
404      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
405      * constructor.
406      * ====
407      */
408     function isContract(address account) internal view returns (bool) {
409         // This method relies on extcodesize/address.code.length, which returns 0
410         // for contracts in construction, since the code is only stored at the end
411         // of the constructor execution.
412 
413         return account.code.length > 0;
414     }
415 
416     /**
417      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
418      * `recipient`, forwarding all available gas and reverting on errors.
419      *
420      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
421      * of certain opcodes, possibly making contracts go over the 2300 gas limit
422      * imposed by `transfer`, making them unable to receive funds via
423      * `transfer`. {sendValue} removes this limitation.
424      *
425      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
426      *
427      * IMPORTANT: because control is transferred to `recipient`, care must be
428      * taken to not create reentrancy vulnerabilities. Consider using
429      * {ReentrancyGuard} or the
430      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
431      */
432     function sendValue(address payable recipient, uint256 amount) internal {
433         require(address(this).balance >= amount, "Address: insufficient balance");
434 
435         (bool success, ) = recipient.call{value: amount}("");
436         require(success, "Address: unable to send value, recipient may have reverted");
437     }
438 
439     /**
440      * @dev Performs a Solidity function call using a low level `call`. A
441      * plain `call` is an unsafe replacement for a function call: use this
442      * function instead.
443      *
444      * If `target` reverts with a revert reason, it is bubbled up by this
445      * function (like regular Solidity function calls).
446      *
447      * Returns the raw returned data. To convert to the expected return value,
448      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
449      *
450      * Requirements:
451      *
452      * - `target` must be a contract.
453      * - calling `target` with `data` must not revert.
454      *
455      * _Available since v3.1._
456      */
457     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
458         return functionCall(target, data, "Address: low-level call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
463      * `errorMessage` as a fallback revert reason when `target` reverts.
464      *
465      * _Available since v3.1._
466      */
467     function functionCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal returns (bytes memory) {
472         return functionCallWithValue(target, data, 0, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but also transferring `value` wei to `target`.
478      *
479      * Requirements:
480      *
481      * - the calling contract must have an ETH balance of at least `value`.
482      * - the called Solidity function must be `payable`.
483      *
484      * _Available since v3.1._
485      */
486     function functionCallWithValue(
487         address target,
488         bytes memory data,
489         uint256 value
490     ) internal returns (bytes memory) {
491         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
496      * with `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(
501         address target,
502         bytes memory data,
503         uint256 value,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         require(address(this).balance >= value, "Address: insufficient balance for call");
507         require(isContract(target), "Address: call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.call{value: value}(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but performing a static call.
516      *
517      * _Available since v3.3._
518      */
519     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
520         return functionStaticCall(target, data, "Address: low-level static call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
525      * but performing a static call.
526      *
527      * _Available since v3.3._
528      */
529     function functionStaticCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal view returns (bytes memory) {
534         require(isContract(target), "Address: static call to non-contract");
535 
536         (bool success, bytes memory returndata) = target.staticcall(data);
537         return verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a delegate call.
543      *
544      * _Available since v3.4._
545      */
546     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
547         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a delegate call.
553      *
554      * _Available since v3.4._
555      */
556     function functionDelegateCall(
557         address target,
558         bytes memory data,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(isContract(target), "Address: delegate call to non-contract");
562 
563         (bool success, bytes memory returndata) = target.delegatecall(data);
564         return verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
569      * revert reason using the provided one.
570      *
571      * _Available since v4.3._
572      */
573     function verifyCallResult(
574         bool success,
575         bytes memory returndata,
576         string memory errorMessage
577     ) internal pure returns (bytes memory) {
578         if (success) {
579             return returndata;
580         } else {
581             // Look for revert reason and bubble it up if present
582             if (returndata.length > 0) {
583                 // The easiest way to bubble the revert reason is using memory via assembly
584 
585                 assembly {
586                     let returndata_size := mload(returndata)
587                     revert(add(32, returndata), returndata_size)
588                 }
589             } else {
590                 revert(errorMessage);
591             }
592         }
593     }
594 }
595 
596 // 
597 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
598 /**
599  * @dev String operations.
600  */
601 library Strings {
602     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
603 
604     /**
605      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
606      */
607     function toString(uint256 value) internal pure returns (string memory) {
608         // Inspired by OraclizeAPI's implementation - MIT licence
609         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
610 
611         if (value == 0) {
612             return "0";
613         }
614         uint256 temp = value;
615         uint256 digits;
616         while (temp != 0) {
617             digits++;
618             temp /= 10;
619         }
620         bytes memory buffer = new bytes(digits);
621         while (value != 0) {
622             digits -= 1;
623             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
624             value /= 10;
625         }
626         return string(buffer);
627     }
628 
629     /**
630      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
631      */
632     function toHexString(uint256 value) internal pure returns (string memory) {
633         if (value == 0) {
634             return "0x00";
635         }
636         uint256 temp = value;
637         uint256 length = 0;
638         while (temp != 0) {
639             length++;
640             temp >>= 8;
641         }
642         return toHexString(value, length);
643     }
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
647      */
648     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
649         bytes memory buffer = new bytes(2 * length + 2);
650         buffer[0] = "0";
651         buffer[1] = "x";
652         for (uint256 i = 2 * length + 1; i > 1; --i) {
653             buffer[i] = _HEX_SYMBOLS[value & 0xf];
654             value >>= 4;
655         }
656         require(value == 0, "Strings: hex length insufficient");
657         return string(buffer);
658     }
659 }
660 
661 // 
662 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
663 /**
664  * @dev Implementation of the {IERC165} interface.
665  *
666  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
667  * for the additional interface id that will be supported. For example:
668  *
669  * ```solidity
670  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
671  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
672  * }
673  * ```
674  *
675  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
676  */
677 abstract contract ERC165 is IERC165 {
678     /**
679      * @dev See {IERC165-supportsInterface}.
680      */
681     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
682         return interfaceId == type(IERC165).interfaceId;
683     }
684 }
685 
686 // 
687 // Creator: Chiru Labs
688 /**
689  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
690  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
691  *
692  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
693  *
694  * Does not support burning tokens to address(0).
695  *
696  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
697  */
698 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
699     using Address for address;
700     using Strings for uint256;
701 
702     struct TokenOwnership {
703         address addr;
704         uint64 startTimestamp;
705     }
706 
707     struct AddressData {
708         uint128 balance;
709         uint128 numberMinted;
710     }
711 
712     uint256 internal currentIndex;
713 
714     // Token name
715     string private _name;
716 
717     // Token symbol
718     string private _symbol;
719 
720     // Mapping from token ID to ownership details
721     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
722     mapping(uint256 => TokenOwnership) internal _ownerships;
723 
724     // Mapping owner address to address data
725     mapping(address => AddressData) private _addressData;
726 
727     // Mapping from token ID to approved address
728     mapping(uint256 => address) private _tokenApprovals;
729 
730     // Mapping from owner to operator approvals
731     mapping(address => mapping(address => bool)) private _operatorApprovals;
732 
733     constructor(string memory name_, string memory symbol_) {
734         _name = name_;
735         _symbol = symbol_;
736     }
737 
738     /**
739      * @dev See {IERC721Enumerable-totalSupply}.
740      */
741     function totalSupply() public view override returns (uint256) {
742         return currentIndex;
743     }
744 
745     /**
746      * @dev See {IERC721Enumerable-tokenByIndex}.
747      */
748     function tokenByIndex(uint256 index) public view override returns (uint256) {
749         require(index < totalSupply(), 'ERC721A: global index out of bounds');
750         return index;
751     }
752 
753     /**
754      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
755      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
756      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
757      */
758     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
759         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
760         uint256 numMintedSoFar = totalSupply();
761         uint256 tokenIdsIdx;
762         address currOwnershipAddr;
763 
764         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
765         unchecked {
766             for (uint256 i; i < numMintedSoFar; i++) {
767                 TokenOwnership memory ownership = _ownerships[i];
768                 if (ownership.addr != address(0)) {
769                     currOwnershipAddr = ownership.addr;
770                 }
771                 if (currOwnershipAddr == owner) {
772                     if (tokenIdsIdx == index) {
773                         return i;
774                     }
775                     tokenIdsIdx++;
776                 }
777             }
778         }
779 
780         revert('ERC721A: unable to get token of owner by index');
781     }
782 
783     /**
784      * @dev See {IERC165-supportsInterface}.
785      */
786     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
787         return
788             interfaceId == type(IERC721).interfaceId ||
789             interfaceId == type(IERC721Metadata).interfaceId ||
790             interfaceId == type(IERC721Enumerable).interfaceId ||
791             super.supportsInterface(interfaceId);
792     }
793 
794     /**
795      * @dev See {IERC721-balanceOf}.
796      */
797     function balanceOf(address owner) public view override returns (uint256) {
798         require(owner != address(0), 'ERC721A: balance query for the zero address');
799         return uint256(_addressData[owner].balance);
800     }
801 
802     function _numberMinted(address owner) internal view returns (uint256) {
803         require(owner != address(0), 'ERC721A: number minted query for the zero address');
804         return uint256(_addressData[owner].numberMinted);
805     }
806 
807     /**
808      * Gas spent here starts off proportional to the maximum mint batch size.
809      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
810      */
811     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
812         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
813 
814         unchecked {
815             for (uint256 curr = tokenId; curr >= 0; curr--) {
816                 TokenOwnership memory ownership = _ownerships[curr];
817                 if (ownership.addr != address(0)) {
818                     return ownership;
819                 }
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
854         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
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
961      * @dev Safely mints `quantity` tokens and transfers them to `to`.
962      *
963      * Requirements:
964      *
965      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
966      * - `quantity` must be greater than 0.
967      *
968      * Emits a {Transfer} event.
969      */
970     function _safeMint(
971         address to,
972         uint256 quantity,
973         bytes memory _data
974     ) internal {
975         _mint(to, quantity, _data, true);
976     }
977 
978     /**
979      * @dev Mints `quantity` tokens and transfers them to `to`.
980      *
981      * Requirements:
982      *
983      * - `to` cannot be the zero address.
984      * - `quantity` must be greater than 0.
985      *
986      * Emits a {Transfer} event.
987      */
988     function _mint(
989         address to,
990         uint256 quantity,
991         bytes memory _data,
992         bool safe
993     ) internal {
994         uint256 startTokenId = currentIndex;
995         require(to != address(0), 'ERC721A: mint to the zero address');
996         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
997 
998         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
999 
1000         // Overflows are incredibly unrealistic.
1001         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1002         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1003         unchecked {
1004             _addressData[to].balance += uint128(quantity);
1005             _addressData[to].numberMinted += uint128(quantity);
1006 
1007             _ownerships[startTokenId].addr = to;
1008             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1009 
1010             uint256 updatedIndex = startTokenId;
1011 
1012             for (uint256 i; i < quantity; i++) {
1013                 emit Transfer(address(0), to, updatedIndex);
1014                 if (safe) {
1015                     require(
1016                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1017                         'ERC721A: transfer to non ERC721Receiver implementer'
1018                     );
1019                 }
1020 
1021                 updatedIndex++;
1022             }
1023 
1024             currentIndex = updatedIndex;
1025         }
1026 
1027         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1028     }
1029 
1030     /**
1031      * @dev Transfers `tokenId` from `from` to `to`.
1032      *
1033      * Requirements:
1034      *
1035      * - `to` cannot be the zero address.
1036      * - `tokenId` token must be owned by `from`.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function _transfer(
1041         address from,
1042         address to,
1043         uint256 tokenId
1044     ) private {
1045         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1046 
1047         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1048             getApproved(tokenId) == _msgSender() ||
1049             isApprovedForAll(prevOwnership.addr, _msgSender()));
1050 
1051         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1052 
1053         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1054         require(to != address(0), 'ERC721A: transfer to the zero address');
1055 
1056         _beforeTokenTransfers(from, to, tokenId, 1);
1057 
1058         // Clear approvals from the previous owner
1059         _approve(address(0), tokenId, prevOwnership.addr);
1060 
1061         // Underflow of the sender's balance is impossible because we check for
1062         // ownership above and the recipient's balance can't realistically overflow.
1063         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1064         unchecked {
1065             _addressData[from].balance -= 1;
1066             _addressData[to].balance += 1;
1067 
1068             _ownerships[tokenId].addr = to;
1069             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1070 
1071             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1072             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1073             uint256 nextTokenId = tokenId + 1;
1074             if (_ownerships[nextTokenId].addr == address(0)) {
1075                 if (_exists(nextTokenId)) {
1076                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1077                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1078                 }
1079             }
1080         }
1081 
1082         emit Transfer(from, to, tokenId);
1083         _afterTokenTransfers(from, to, tokenId, 1);
1084     }
1085 
1086     /**
1087      * @dev Approve `to` to operate on `tokenId`
1088      *
1089      * Emits a {Approval} event.
1090      */
1091     function _approve(
1092         address to,
1093         uint256 tokenId,
1094         address owner
1095     ) private {
1096         _tokenApprovals[tokenId] = to;
1097         emit Approval(owner, to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1102      * The call is not executed if the target address is not a contract.
1103      *
1104      * @param from address representing the previous owner of the given token ID
1105      * @param to target address that will receive the tokens
1106      * @param tokenId uint256 ID of the token to be transferred
1107      * @param _data bytes optional data to send along with the call
1108      * @return bool whether the call correctly returned the expected magic value
1109      */
1110     function _checkOnERC721Received(
1111         address from,
1112         address to,
1113         uint256 tokenId,
1114         bytes memory _data
1115     ) private returns (bool) {
1116         if (to.isContract()) {
1117             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1118                 return retval == IERC721Receiver(to).onERC721Received.selector;
1119             } catch (bytes memory reason) {
1120                 if (reason.length == 0) {
1121                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1122                 } else {
1123                     assembly {
1124                         revert(add(32, reason), mload(reason))
1125                     }
1126                 }
1127             }
1128         } else {
1129             return true;
1130         }
1131     }
1132 
1133     /**
1134      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1135      *
1136      * startTokenId - the first token id to be transferred
1137      * quantity - the amount to be transferred
1138      *
1139      * Calling conditions:
1140      *
1141      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1142      * transferred to `to`.
1143      * - When `from` is zero, `tokenId` will be minted for `to`.
1144      */
1145     function _beforeTokenTransfers(
1146         address from,
1147         address to,
1148         uint256 startTokenId,
1149         uint256 quantity
1150     ) internal virtual {}
1151 
1152     /**
1153      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1154      * minting.
1155      *
1156      * startTokenId - the first token id to be transferred
1157      * quantity - the amount to be transferred
1158      *
1159      * Calling conditions:
1160      *
1161      * - when `from` and `to` are both non-zero.
1162      * - `from` and `to` are never both zero.
1163      */
1164     function _afterTokenTransfers(
1165         address from,
1166         address to,
1167         uint256 startTokenId,
1168         uint256 quantity
1169     ) internal virtual {}
1170 }
1171 
1172 //
1173 contract Jericha is ERC721A, Ownable {
1174     using Counters for Counters.Counter;
1175     using Strings for uint256;
1176 
1177     Counters.Counter private tokenIdCounter;
1178 
1179     string baseURI;
1180     uint256 public maximumSupply = 999;
1181     uint256 public reservedForTeam = 99;
1182 
1183     uint256 public maxItems = 2; 
1184     mapping(address => uint256) public countPublic;
1185 
1186     bool public paused = true;
1187     
1188     constructor(string memory _initBaseURI) ERC721A("Jericha", "JRCH") {
1189         setBaseURI(_initBaseURI);
1190     }
1191 
1192     function _baseURI() internal view override returns (string memory) {
1193         return baseURI;
1194     }
1195 
1196     function teamMint() public onlyOwner {
1197         uint256 supply = tokenIdCounter.current();
1198 
1199         require(supply + reservedForTeam <= maximumSupply, "Exceeds maximum supply!");
1200 
1201         _safeMint(msg.sender, reservedForTeam);
1202 
1203         for (uint256 i = 0; i < reservedForTeam; i++) {
1204             tokenIdCounter.increment(); 
1205         }
1206     }
1207 
1208     function mint(uint256 quantity) external payable {
1209         uint256 supply = tokenIdCounter.current();
1210 
1211         require(!paused, "Sale is paused");
1212 
1213         require(supply + quantity <= maximumSupply, "Exceeds maximum supply");
1214 
1215         require(quantity <= maxItems, "You can mint maximum 2 per wallet.");
1216 
1217         require(countPublic[msg.sender] < maxItems);
1218 
1219         _safeMint(msg.sender, quantity);
1220 
1221         for (uint256 i = 0; i < quantity; i++) {
1222             tokenIdCounter.increment(); 
1223         }
1224 
1225         countPublic[msg.sender] += maxItems;
1226     }
1227 
1228     function getCurrentId() external view returns (uint256) {
1229         return tokenIdCounter.current();
1230     }
1231 
1232     function tokenURI(uint256 tokenId)
1233         public
1234         view
1235         virtual
1236         override
1237         returns (string memory)
1238     {
1239         return string(abi.encodePacked(baseURI, tokenId.toString(), ".json"));
1240     }
1241 
1242     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1243         baseURI = _newBaseURI;
1244     }
1245 
1246     function setPausedState(bool val) public onlyOwner {
1247         paused = val;
1248     }
1249 
1250     function withdrawAll() public onlyOwner {
1251         uint256 balance = address(this).balance;
1252         require(payable(msg.sender).send(balance));
1253     }
1254 }