1 /**
2 ▀▄▒▄▀ 　 ▒█▀▀▀ ▒█▄░▒█ ▒█▀▀▀█ ▒█░░░ ▒█▀▀█ 
3 ░▒█░░ 　 ▒█▀▀▀ ▒█▒█▒█ ▒█░░▒█ ▒█░░░ ▒█░░░ 
4 ▄▀▒▀▄ 　 ▒█▄▄▄ ▒█░░▀█ ▒█▄▄▄█ ▒█▄▄█ ▒█▄▄█
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.11;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16 
17     /**
18      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
19      */
20     function toString(uint256 value) internal pure returns (string memory) {
21         // Inspired by OraclizeAPI's implementation - MIT licence
22         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
23 
24         if (value == 0) {
25             return "0";
26         }
27         uint256 temp = value;
28         uint256 digits;
29         while (temp != 0) {
30             digits++;
31             temp /= 10;
32         }
33         bytes memory buffer = new bytes(digits);
34         while (value != 0) {
35             digits -= 1;
36             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
37             value /= 10;
38         }
39         return string(buffer);
40     }
41 
42     /**
43      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
44      */
45     function toHexString(uint256 value) internal pure returns (string memory) {
46         if (value == 0) {
47             return "0x00";
48         }
49         uint256 temp = value;
50         uint256 length = 0;
51         while (temp != 0) {
52             length++;
53             temp >>= 8;
54         }
55         return toHexString(value, length);
56     }
57 
58     /**
59      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
60      */
61     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
62         bytes memory buffer = new bytes(2 * length + 2);
63         buffer[0] = "0";
64         buffer[1] = "x";
65         for (uint256 i = 2 * length + 1; i > 1; --i) {
66             buffer[i] = _HEX_SYMBOLS[value & 0xf];
67             value >>= 4;
68         }
69         require(value == 0, "Strings: hex length insufficient");
70         return string(buffer);
71     }
72 }
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 /**
95  * @dev Collection of functions related to the address type
96  */
97 library Address {
98     /**
99      * @dev Returns true if `account` is a contract.
100      *
101      * [IMPORTANT]
102      * ====
103      * It is unsafe to assume that an address for which this function returns
104      * false is an externally-owned account (EOA) and not a contract.
105      *
106      * Among others, `isContract` will return false for the following
107      * types of addresses:
108      *
109      *  - an externally-owned account
110      *  - a contract in construction
111      *  - an address where a contract will be created
112      *  - an address where a contract lived, but was destroyed
113      * ====
114      */
115     function isContract(address account) internal view returns (bool) {
116         // This method relies on extcodesize, which returns 0 for contracts in
117         // construction, since the code is only stored at the end of the
118         // constructor execution.
119 
120         uint256 size;
121         assembly {
122             size := extcodesize(account)
123         }
124         return size > 0;
125     }
126 
127     /**
128      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
129      * `recipient`, forwarding all available gas and reverting on errors.
130      *
131      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
132      * of certain opcodes, possibly making contracts go over the 2300 gas limit
133      * imposed by `transfer`, making them unable to receive funds via
134      * `transfer`. {sendValue} removes this limitation.
135      *
136      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
137      *
138      * IMPORTANT: because control is transferred to `recipient`, care must be
139      * taken to not create reentrancy vulnerabilities. Consider using
140      * {ReentrancyGuard} or the
141      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
142      */
143     function sendValue(address payable recipient, uint256 amount) internal {
144         require(address(this).balance >= amount, "Address: insufficient balance");
145 
146         (bool success, ) = recipient.call{value: amount}("");
147         require(success, "Address: unable to send value, recipient may have reverted");
148     }
149 
150     /**
151      * @dev Performs a Solidity function call using a low level `call`. A
152      * plain `call` is an unsafe replacement for a function call: use this
153      * function instead.
154      *
155      * If `target` reverts with a revert reason, it is bubbled up by this
156      * function (like regular Solidity function calls).
157      *
158      * Returns the raw returned data. To convert to the expected return value,
159      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
160      *
161      * Requirements:
162      *
163      * - `target` must be a contract.
164      * - calling `target` with `data` must not revert.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169         return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
174      * `errorMessage` as a fallback revert reason when `target` reverts.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal returns (bytes memory) {
183         return functionCallWithValue(target, data, 0, errorMessage);
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
188      * but also transferring `value` wei to `target`.
189      *
190      * Requirements:
191      *
192      * - the calling contract must have an ETH balance of at least `value`.
193      * - the called Solidity function must be `payable`.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
207      * with `errorMessage` as a fallback revert reason when `target` reverts.
208      *
209      * _Available since v3.1._
210      */
211     function functionCallWithValue(
212         address target,
213         bytes memory data,
214         uint256 value,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         require(address(this).balance >= value, "Address: insufficient balance for call");
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value: value}(data);
221         return verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(
241         address target,
242         bytes memory data,
243         string memory errorMessage
244     ) internal view returns (bytes memory) {
245         require(isContract(target), "Address: static call to non-contract");
246 
247         (bool success, bytes memory returndata) = target.staticcall(data);
248         return verifyCallResult(success, returndata, errorMessage);
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
258         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
259     }
260 
261     /**
262      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
263      * but performing a delegate call.
264      *
265      * _Available since v3.4._
266      */
267     function functionDelegateCall(
268         address target,
269         bytes memory data,
270         string memory errorMessage
271     ) internal returns (bytes memory) {
272         require(isContract(target), "Address: delegate call to non-contract");
273 
274         (bool success, bytes memory returndata) = target.delegatecall(data);
275         return verifyCallResult(success, returndata, errorMessage);
276     }
277 
278     /**
279      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
280      * revert reason using the provided one.
281      *
282      * _Available since v4.3._
283      */
284     function verifyCallResult(
285         bool success,
286         bytes memory returndata,
287         string memory errorMessage
288     ) internal pure returns (bytes memory) {
289         if (success) {
290             return returndata;
291         } else {
292             // Look for revert reason and bubble it up if present
293             if (returndata.length > 0) {
294                 // The easiest way to bubble the revert reason is using memory via assembly
295 
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 /**
308  * @title ERC721 token receiver interface
309  * @dev Interface for any contract that wants to support safeTransfers
310  * from ERC721 asset contracts.
311  */
312 interface IERC721Receiver {
313     /**
314      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
315      * by `operator` from `from`, this function is called.
316      *
317      * It must return its Solidity selector to confirm the token transfer.
318      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
319      *
320      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
321      */
322     function onERC721Received(
323         address operator,
324         address from,
325         uint256 tokenId,
326         bytes calldata data
327     ) external returns (bytes4);
328 }
329 
330 /**
331  * @dev Interface of the ERC165 standard, as defined in the
332  * https://eips.ethereum.org/EIPS/eip-165[EIP].
333  *
334  * Implementers can declare support of contract interfaces, which can then be
335  * queried by others ({ERC165Checker}).
336  *
337  * For an implementation, see {ERC165}.
338  */
339 interface IERC165 {
340     /**
341      * @dev Returns true if this contract implements the interface defined by
342      * `interfaceId`. See the corresponding
343      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
344      * to learn more about how these ids are created.
345      *
346      * This function call must use less than 30 000 gas.
347      */
348     function supportsInterface(bytes4 interfaceId) external view returns (bool);
349 }
350 
351 /**
352  * @dev Implementation of the {IERC165} interface.
353  *
354  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
355  * for the additional interface id that will be supported. For example:
356  *
357  * ```solidity
358  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
359  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
360  * }
361  * ```
362  *
363  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
364  */
365 abstract contract ERC165 is IERC165 {
366     /**
367      * @dev See {IERC165-supportsInterface}.
368      */
369     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370         return interfaceId == type(IERC165).interfaceId;
371     }
372 }
373 
374 /**
375  * @dev Required interface of an ERC721 compliant contract.
376  */
377 interface IERC721 is IERC165 {
378     /**
379      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
380      */
381     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
382 
383     /**
384      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
385      */
386     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
387 
388     /**
389      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
390      */
391     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
392 
393     /**
394      * @dev Returns the number of tokens in ``owner``'s account.
395      */
396     function balanceOf(address owner) external view returns (uint256 balance);
397 
398     /**
399      * @dev Returns the owner of the `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function ownerOf(uint256 tokenId) external view returns (address owner);
406 
407     /**
408      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
409      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
410      *
411      * Requirements:
412      *
413      * - `from` cannot be the zero address.
414      * - `to` cannot be the zero address.
415      * - `tokenId` token must exist and be owned by `from`.
416      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
417      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
418      *
419      * Emits a {Transfer} event.
420      */
421     function safeTransferFrom(
422         address from,
423         address to,
424         uint256 tokenId
425     ) external;
426 
427     /**
428      * @dev Transfers `tokenId` token from `from` to `to`.
429      *
430      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
431      *
432      * Requirements:
433      *
434      * - `from` cannot be the zero address.
435      * - `to` cannot be the zero address.
436      * - `tokenId` token must be owned by `from`.
437      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
438      *
439      * Emits a {Transfer} event.
440      */
441     function transferFrom(
442         address from,
443         address to,
444         uint256 tokenId
445     ) external;
446 
447     /**
448      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
449      * The approval is cleared when the token is transferred.
450      *
451      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
452      *
453      * Requirements:
454      *
455      * - The caller must own the token or be an approved operator.
456      * - `tokenId` must exist.
457      *
458      * Emits an {Approval} event.
459      */
460     function approve(address to, uint256 tokenId) external;
461 
462     /**
463      * @dev Returns the account approved for `tokenId` token.
464      *
465      * Requirements:
466      *
467      * - `tokenId` must exist.
468      */
469     function getApproved(uint256 tokenId) external view returns (address operator);
470 
471     /**
472      * @dev Approve or remove `operator` as an operator for the caller.
473      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
474      *
475      * Requirements:
476      *
477      * - The `operator` cannot be the caller.
478      *
479      * Emits an {ApprovalForAll} event.
480      */
481     function setApprovalForAll(address operator, bool _approved) external;
482 
483     /**
484      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
485      *
486      * See {setApprovalForAll}
487      */
488     function isApprovedForAll(address owner, address operator) external view returns (bool);
489 
490     /**
491      * @dev Safely transfers `tokenId` token from `from` to `to`.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId,
507         bytes calldata data
508     ) external;
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
521  * @dev See https://eips.ethereum.org/EIPS/eip-721
522  */
523 interface IERC721Enumerable is IERC721 {
524     /**
525      * @dev Returns the total amount of tokens stored by the contract.
526      */
527     function totalSupply() external view returns (uint256);
528 
529     /**
530      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
531      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
532      */
533     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
534 
535     /**
536      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
537      * Use along with {totalSupply} to enumerate all tokens.
538      */
539     function tokenByIndex(uint256 index) external view returns (uint256);
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
543 
544 
545 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
552  * @dev See https://eips.ethereum.org/EIPS/eip-721
553  */
554 interface IERC721Metadata is IERC721 {
555     /**
556      * @dev Returns the token collection name.
557      */
558     function name() external view returns (string memory);
559 
560     /**
561      * @dev Returns the token collection symbol.
562      */
563     function symbol() external view returns (string memory);
564 
565     /**
566      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
567      */
568     function tokenURI(uint256 tokenId) external view returns (string memory);
569 }
570 
571 /**
572  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
573  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
574  *
575  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
576  *
577  * Does not support burning tokens to address(0).
578  *
579  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
580  */
581 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
582     using Address for address;
583     using Strings for uint256;
584 
585     struct TokenOwnership {
586         address addr;
587         uint64 startTimestamp;
588     }
589 
590     struct AddressData {
591         uint128 balance;
592         uint128 numberMinted;
593     }
594 
595     uint256 internal currentIndex = 1;
596 
597     // Token name
598     string private _name;
599 
600     // Token symbol
601     string private _symbol;
602 
603     // Mapping from token ID to ownership details
604     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
605     mapping(uint256 => TokenOwnership) internal _ownerships;
606 
607     // Mapping owner address to address data
608     mapping(address => AddressData) private _addressData;
609 
610     // Mapping from token ID to approved address
611     mapping(uint256 => address) private _tokenApprovals;
612 
613     // Mapping from owner to operator approvals
614     mapping(address => mapping(address => bool)) private _operatorApprovals;
615 
616     constructor(string memory name_, string memory symbol_) {
617         _name = name_;
618         _symbol = symbol_;
619     }
620 
621     /**
622      * @dev See {IERC721Enumerable-totalSupply}.
623      */
624     function totalSupply() public view override returns (uint256) {
625         return currentIndex;
626     }
627 
628     /**
629      * @dev See {IERC721Enumerable-tokenByIndex}.
630      */
631     function tokenByIndex(uint256 index) public view override returns (uint256) {
632         require(index < totalSupply(), 'ERC721A: global index out of bounds');
633         return index;
634     }
635 
636     /**
637      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
638      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
639      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
640      */
641     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
642         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
643         uint256 numMintedSoFar = totalSupply();
644         uint256 tokenIdsIdx = 0;
645         address currOwnershipAddr = address(0);
646         for (uint256 i = 0; i < numMintedSoFar; i++) {
647             TokenOwnership memory ownership = _ownerships[i];
648             if (ownership.addr != address(0)) {
649                 currOwnershipAddr = ownership.addr;
650             }
651             if (currOwnershipAddr == owner) {
652                 if (tokenIdsIdx == index) {
653                     return i;
654                 }
655                 tokenIdsIdx++;
656             }
657         }
658         revert('ERC721A: unable to get token of owner by index');
659     }
660 
661     /**
662      * @dev See {IERC165-supportsInterface}.
663      */
664     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
665         return
666             interfaceId == type(IERC721).interfaceId ||
667             interfaceId == type(IERC721Metadata).interfaceId ||
668             interfaceId == type(IERC721Enumerable).interfaceId ||
669             super.supportsInterface(interfaceId);
670     }
671 
672     /**
673      * @dev See {IERC721-balanceOf}.
674      */
675     function balanceOf(address owner) public view override returns (uint256) {
676         require(owner != address(0), 'ERC721A: balance query for the zero address');
677         return uint256(_addressData[owner].balance);
678     }
679 
680     function _numberMinted(address owner) internal view returns (uint256) {
681         require(owner != address(0), 'ERC721A: number minted query for the zero address');
682         return uint256(_addressData[owner].numberMinted);
683     }
684 
685     /**
686      * Gas spent here starts off proportional to the maximum mint batch size.
687      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
688      */
689     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
690         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
691 
692         for (uint256 curr = tokenId; ; curr--) {
693             TokenOwnership memory ownership = _ownerships[curr];
694             if (ownership.addr != address(0)) {
695                 return ownership;
696             }
697         }
698 
699         revert('ERC721A: unable to determine the owner of token');
700     }
701 
702     /**
703      * @dev See {IERC721-ownerOf}.
704      */
705     function ownerOf(uint256 tokenId) public view override returns (address) {
706         return ownershipOf(tokenId).addr;
707     }
708 
709     /**
710      * @dev See {IERC721Metadata-name}.
711      */
712     function name() public view virtual override returns (string memory) {
713         return _name;
714     }
715 
716     /**
717      * @dev See {IERC721Metadata-symbol}.
718      */
719     function symbol() public view virtual override returns (string memory) {
720         return _symbol;
721     }
722 
723     /**
724      * @dev See {IERC721Metadata-tokenURI}.
725      */
726     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
727         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
728 
729         string memory baseURI = _baseURI();
730         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
731     }
732 
733     /**
734      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
735      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
736      * by default, can be overriden in child contracts.
737      */
738     function _baseURI() internal view virtual returns (string memory) {
739         return '';
740     }
741 
742     /**
743      * @dev See {IERC721-approve}.
744      */
745     function approve(address to, uint256 tokenId) public override {
746         address owner = ERC721A.ownerOf(tokenId);
747         require(to != owner, 'ERC721A: approval to current owner');
748 
749         require(
750             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
751             'ERC721A: approve caller is not owner nor approved for all'
752         );
753 
754         _approve(to, tokenId, owner);
755     }
756 
757     /**
758      * @dev See {IERC721-getApproved}.
759      */
760     function getApproved(uint256 tokenId) public view override returns (address) {
761         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
762 
763         return _tokenApprovals[tokenId];
764     }
765 
766     /**
767      * @dev See {IERC721-setApprovalForAll}.
768      */
769     function setApprovalForAll(address operator, bool approved) public override {
770         require(operator != _msgSender(), 'ERC721A: approve to caller');
771 
772         _operatorApprovals[_msgSender()][operator] = approved;
773         emit ApprovalForAll(_msgSender(), operator, approved);
774     }
775 
776     /**
777      * @dev See {IERC721-isApprovedForAll}.
778      */
779     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
780         return _operatorApprovals[owner][operator];
781     }
782 
783     /**
784      * @dev See {IERC721-transferFrom}.
785      */
786     function transferFrom(
787         address from,
788         address to,
789         uint256 tokenId
790     ) public override {
791         _transfer(from, to, tokenId);
792     }
793 
794     /**
795      * @dev See {IERC721-safeTransferFrom}.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) public override {
802         safeTransferFrom(from, to, tokenId, '');
803     }
804 
805     /**
806      * @dev See {IERC721-safeTransferFrom}.
807      */
808     function safeTransferFrom(
809         address from,
810         address to,
811         uint256 tokenId,
812         bytes memory _data
813     ) public override {
814         _transfer(from, to, tokenId);
815         require(
816             _checkOnERC721Received(from, to, tokenId, _data),
817             'ERC721A: transfer to non ERC721Receiver implementer'
818         );
819     }
820 
821     /**
822      * @dev Returns whether `tokenId` exists.
823      *
824      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
825      *
826      * Tokens start existing when they are minted (`_mint`),
827      */
828     function _exists(uint256 tokenId) internal view returns (bool) {
829         return tokenId < currentIndex;
830     }
831 
832     function _safeMint(address to, uint256 quantity) internal {
833         _safeMint(to, quantity, '');
834     }
835 
836     /**
837      * @dev Safely mints `quantity` tokens and transfers them to `to`.
838      *
839      * Requirements:
840      *
841      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
842      * - `quantity` must be greater than 0.
843      *
844      * Emits a {Transfer} event.
845      */
846     function _safeMint(
847         address to,
848         uint256 quantity,
849         bytes memory _data
850     ) internal {
851         _mint(to, quantity, _data, true);
852     }
853 
854     /**
855      * @dev Mints `quantity` tokens and transfers them to `to`.
856      *
857      * Requirements:
858      *
859      * - `to` cannot be the zero address.
860      * - `quantity` must be greater than 0.
861      *
862      * Emits a {Transfer} event.
863      */
864     function _mint(
865         address to,
866         uint256 quantity,
867         bytes memory _data,
868         bool safe
869     ) internal {
870         uint256 startTokenId = currentIndex;
871         require(to != address(0), 'ERC721A: mint to the zero address');
872         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
873         require(!_exists(startTokenId), 'ERC721A: token already minted');
874         require(quantity > 0, 'ERC721A: quantity must be greater than 0');
875 
876         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
877 
878         _addressData[to].balance += uint128(quantity);
879         _addressData[to].numberMinted += uint128(quantity);
880 
881         _ownerships[startTokenId].addr = to;
882         _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
883 
884         uint256 updatedIndex = startTokenId;
885 
886         for (uint256 i = 0; i < quantity; i++) {
887             emit Transfer(address(0), to, updatedIndex);
888             if (safe) {
889                 require(
890                     _checkOnERC721Received(address(0), to, updatedIndex, _data),
891                     'ERC721A: transfer to non ERC721Receiver implementer'
892                 );
893             }
894             updatedIndex++;
895         }
896 
897         currentIndex = updatedIndex;
898         _afterTokenTransfers(address(0), to, startTokenId, quantity);
899     }
900 
901     /**
902      * @dev Transfers `tokenId` from `from` to `to`.
903      *
904      * Requirements:
905      *
906      * - `to` cannot be the zero address.
907      * - `tokenId` token must be owned by `from`.
908      *
909      * Emits a {Transfer} event.
910      */
911     function _transfer(
912         address from,
913         address to,
914         uint256 tokenId
915     ) private {
916         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
917 
918         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
919             getApproved(tokenId) == _msgSender() ||
920             isApprovedForAll(prevOwnership.addr, _msgSender()));
921 
922         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
923 
924         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
925         require(to != address(0), 'ERC721A: transfer to the zero address');
926 
927         _beforeTokenTransfers(from, to, tokenId, 1);
928 
929         // Clear approvals from the previous owner
930         _approve(address(0), tokenId, prevOwnership.addr);
931 
932         // Underflow of the sender's balance is impossible because we check for
933         // ownership above and the recipient's balance can't realistically overflow.
934         unchecked {
935             _addressData[from].balance -= 1;
936             _addressData[to].balance += 1;
937         }
938 
939         _ownerships[tokenId].addr = to;
940         _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
941 
942         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
943         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
944         uint256 nextTokenId = tokenId + 1;
945         if (_ownerships[nextTokenId].addr == address(0)) {
946             if (_exists(nextTokenId)) {
947                 _ownerships[nextTokenId].addr = prevOwnership.addr;
948                 _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
949             }
950         }
951 
952         emit Transfer(from, to, tokenId);
953         _afterTokenTransfers(from, to, tokenId, 1);
954     }
955 
956     /**
957      * @dev Approve `to` to operate on `tokenId`
958      *
959      * Emits a {Approval} event.
960      */
961     function _approve(
962         address to,
963         uint256 tokenId,
964         address owner
965     ) private {
966         _tokenApprovals[tokenId] = to;
967         emit Approval(owner, to, tokenId);
968     }
969 
970     /**
971      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
972      * The call is not executed if the target address is not a contract.
973      *
974      * @param from address representing the previous owner of the given token ID
975      * @param to target address that will receive the tokens
976      * @param tokenId uint256 ID of the token to be transferred
977      * @param _data bytes optional data to send along with the call
978      * @return bool whether the call correctly returned the expected magic value
979      */
980     function _checkOnERC721Received(
981         address from,
982         address to,
983         uint256 tokenId,
984         bytes memory _data
985     ) private returns (bool) {
986         if (to.isContract()) {
987             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
988                 return retval == IERC721Receiver(to).onERC721Received.selector;
989             } catch (bytes memory reason) {
990                 if (reason.length == 0) {
991                     revert('ERC721A: transfer to non ERC721Receiver implementer');
992                 } else {
993                     assembly {
994                         revert(add(32, reason), mload(reason))
995                     }
996                 }
997             }
998         } else {
999             return true;
1000         }
1001     }
1002 
1003     /**
1004      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1005      *
1006      * startTokenId - the first token id to be transferred
1007      * quantity - the amount to be transferred
1008      *
1009      * Calling conditions:
1010      *
1011      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1012      * transferred to `to`.
1013      * - When `from` is zero, `tokenId` will be minted for `to`.
1014      */
1015     function _beforeTokenTransfers(
1016         address from,
1017         address to,
1018         uint256 startTokenId,
1019         uint256 quantity
1020     ) internal virtual {}
1021 
1022     /**
1023      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1024      * minting.
1025      *
1026      * startTokenId - the first token id to be transferred
1027      * quantity - the amount to be transferred
1028      *
1029      * Calling conditions:
1030      *
1031      * - when `from` and `to` are both non-zero.
1032      * - `from` and `to` are never both zero.
1033      */
1034     function _afterTokenTransfers(
1035         address from,
1036         address to,
1037         uint256 startTokenId,
1038         uint256 quantity
1039     ) internal virtual {}
1040 }
1041 
1042 contract XenolC_TKFTR is ERC721A {
1043 
1044     mapping (address => uint8) public _minted;
1045 
1046     uint public salePrice;
1047     uint public reachedCapPrice;
1048     uint16 public maxSupply;
1049     uint8 public maxPerTx;
1050     uint8 public maxPerWallet;
1051 
1052     bool public publicMintStatus;
1053 
1054     string public baseURI;
1055 
1056     address private owner;
1057 
1058     function _baseURI() internal view override returns (string memory) {
1059         return baseURI;
1060     }
1061     
1062     function setBaseURI(string memory _newBaseURI) external onlyOwner {
1063         baseURI = _newBaseURI;
1064     }
1065 
1066     function setSalePrice(uint price) external onlyOwner {
1067         salePrice = price;
1068     }
1069 
1070     function setReachedCapPrice(uint price) external onlyOwner {
1071         reachedCapPrice = price;
1072     }
1073 
1074     function setMaxSupply(uint16 supply) external onlyOwner {
1075         maxSupply = supply;
1076     }
1077 
1078 
1079     function setMaxPerTx(uint8 max) external onlyOwner {
1080         maxPerTx = max;
1081     }
1082 
1083     function setMaxPerWallet(uint8 max) external onlyOwner {
1084         maxPerWallet = max;
1085     }
1086 
1087     function setPublicMintStatus() external onlyOwner {
1088         publicMintStatus = !publicMintStatus;
1089     }
1090 
1091     function withdraw() external onlyOwner {
1092         payable(msg.sender).transfer(address(this).balance);
1093     }
1094 
1095     modifier onlyOwner {
1096         require(owner == msg.sender, "Not the owner!");
1097         _;
1098     }
1099 
1100     function transferOwnership(address newOwner) external onlyOwner {
1101         owner = newOwner;
1102     }
1103 
1104     constructor() ERC721A("XenolC TKFTR", "XENOLC") {
1105         owner = msg.sender;
1106     }
1107 
1108     function publicMint(uint8 amount) external payable {
1109         require(publicMintStatus, "Sale not active!");
1110         require(currentIndex + amount <= maxSupply + 1, "Not enough tokens to sell!");
1111         require(amount <= maxPerTx, "Incorrect amount!");
1112         require(_minted[msg.sender] + amount <= maxPerWallet, "Incorrect amount!");
1113         if(currentIndex + amount > 5000){
1114             require(msg.value == reachedCapPrice * amount, "Incorrect amount!");
1115             _safeMint(msg.sender, amount);
1116             _minted[msg.sender] += amount;
1117         }else{
1118             require(msg.value == salePrice * amount, "Incorrect amount!");
1119             _safeMint(msg.sender, amount);
1120             _minted[msg.sender] += amount;
1121         }
1122     }
1123 }