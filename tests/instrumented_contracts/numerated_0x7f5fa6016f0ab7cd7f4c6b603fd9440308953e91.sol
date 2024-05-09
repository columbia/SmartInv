1 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
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
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
29 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(
48         address indexed previousOwner,
49         address indexed newOwner
50     );
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(
91             newOwner != address(0),
92             "Ownable: new owner is the zero address"
93         );
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
111 
112 /**
113  * @dev String operations.
114  */
115 library Strings {
116     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
120      */
121     function toString(uint256 value) internal pure returns (string memory) {
122         // Inspired by OraclizeAPI's implementation - MIT licence
123         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
124 
125         if (value == 0) {
126             return "0";
127         }
128         uint256 temp = value;
129         uint256 digits;
130         while (temp != 0) {
131             digits++;
132             temp /= 10;
133         }
134         bytes memory buffer = new bytes(digits);
135         while (value != 0) {
136             digits -= 1;
137             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
138             value /= 10;
139         }
140         return string(buffer);
141     }
142 
143     /**
144      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
145      */
146     function toHexString(uint256 value) internal pure returns (string memory) {
147         if (value == 0) {
148             return "0x00";
149         }
150         uint256 temp = value;
151         uint256 length = 0;
152         while (temp != 0) {
153             length++;
154             temp >>= 8;
155         }
156         return toHexString(value, length);
157     }
158 
159     /**
160      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
161      */
162     function toHexString(uint256 value, uint256 length)
163         internal
164         pure
165         returns (string memory)
166     {
167         bytes memory buffer = new bytes(2 * length + 2);
168         buffer[0] = "0";
169         buffer[1] = "x";
170         for (uint256 i = 2 * length + 1; i > 1; --i) {
171             buffer[i] = _HEX_SYMBOLS[value & 0xf];
172             value >>= 4;
173         }
174         require(value == 0, "Strings: hex length insufficient");
175         return string(buffer);
176     }
177 }
178 
179 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
180 
181 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
182 
183 /**
184  * @dev Interface of the ERC165 standard, as defined in the
185  * https://eips.ethereum.org/EIPS/eip-165[EIP].
186  *
187  * Implementers can declare support of contract interfaces, which can then be
188  * queried by others ({ERC165Checker}).
189  *
190  * For an implementation, see {ERC165}.
191  */
192 interface IERC165 {
193     /**
194      * @dev Returns true if this contract implements the interface defined by
195      * `interfaceId`. See the corresponding
196      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
197      * to learn more about how these ids are created.
198      *
199      * This function call must use less than 30 000 gas.
200      */
201     function supportsInterface(bytes4 interfaceId) external view returns (bool);
202 }
203 
204 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
205 
206 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
207 
208 /**
209  * @dev Required interface of an ERC721 compliant contract.
210  */
211 interface IERC721 is IERC165 {
212     /**
213      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
214      */
215     event Transfer(
216         address indexed from,
217         address indexed to,
218         uint256 indexed tokenId
219     );
220 
221     /**
222      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
223      */
224     event Approval(
225         address indexed owner,
226         address indexed approved,
227         uint256 indexed tokenId
228     );
229 
230     /**
231      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
232      */
233     event ApprovalForAll(
234         address indexed owner,
235         address indexed operator,
236         bool approved
237     );
238 
239     /**
240      * @dev Returns the number of tokens in ``owner``'s account.
241      */
242     function balanceOf(address owner) external view returns (uint256 balance);
243 
244     /**
245      * @dev Returns the owner of the `tokenId` token.
246      *
247      * Requirements:
248      *
249      * - `tokenId` must exist.
250      */
251     function ownerOf(uint256 tokenId) external view returns (address owner);
252 
253     /**
254      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
255      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
256      *
257      * Requirements:
258      *
259      * - `from` cannot be the zero address.
260      * - `to` cannot be the zero address.
261      * - `tokenId` token must exist and be owned by `from`.
262      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
263      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
264      *
265      * Emits a {Transfer} event.
266      */
267     function safeTransferFrom(
268         address from,
269         address to,
270         uint256 tokenId
271     ) external;
272 
273     /**
274      * @dev Transfers `tokenId` token from `from` to `to`.
275      *
276      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
277      *
278      * Requirements:
279      *
280      * - `from` cannot be the zero address.
281      * - `to` cannot be the zero address.
282      * - `tokenId` token must be owned by `from`.
283      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
284      *
285      * Emits a {Transfer} event.
286      */
287     function transferFrom(
288         address from,
289         address to,
290         uint256 tokenId
291     ) external;
292 
293     /**
294      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
295      * The approval is cleared when the token is transferred.
296      *
297      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
298      *
299      * Requirements:
300      *
301      * - The caller must own the token or be an approved operator.
302      * - `tokenId` must exist.
303      *
304      * Emits an {Approval} event.
305      */
306     function approve(address to, uint256 tokenId) external;
307 
308     /**
309      * @dev Returns the account approved for `tokenId` token.
310      *
311      * Requirements:
312      *
313      * - `tokenId` must exist.
314      */
315     function getApproved(uint256 tokenId)
316         external
317         view
318         returns (address operator);
319 
320     /**
321      * @dev Approve or remove `operator` as an operator for the caller.
322      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
323      *
324      * Requirements:
325      *
326      * - The `operator` cannot be the caller.
327      *
328      * Emits an {ApprovalForAll} event.
329      */
330     function setApprovalForAll(address operator, bool _approved) external;
331 
332     /**
333      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
334      *
335      * See {setApprovalForAll}
336      */
337     function isApprovedForAll(address owner, address operator)
338         external
339         view
340         returns (bool);
341 
342     /**
343      * @dev Safely transfers `tokenId` token from `from` to `to`.
344      *
345      * Requirements:
346      *
347      * - `from` cannot be the zero address.
348      * - `to` cannot be the zero address.
349      * - `tokenId` token must exist and be owned by `from`.
350      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
351      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
352      *
353      * Emits a {Transfer} event.
354      */
355     function safeTransferFrom(
356         address from,
357         address to,
358         uint256 tokenId,
359         bytes calldata data
360     ) external;
361 }
362 
363 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
364 
365 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
366 
367 /**
368  * @title ERC721 token receiver interface
369  * @dev Interface for any contract that wants to support safeTransfers
370  * from ERC721 asset contracts.
371  */
372 interface IERC721Receiver {
373     /**
374      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
375      * by `operator` from `from`, this function is called.
376      *
377      * It must return its Solidity selector to confirm the token transfer.
378      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
379      *
380      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
381      */
382     function onERC721Received(
383         address operator,
384         address from,
385         uint256 tokenId,
386         bytes calldata data
387     ) external returns (bytes4);
388 }
389 
390 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
391 
392 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
393 
394 /**
395  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
396  * @dev See https://eips.ethereum.org/EIPS/eip-721
397  */
398 interface IERC721Metadata is IERC721 {
399     /**
400      * @dev Returns the token collection name.
401      */
402     function name() external view returns (string memory);
403 
404     /**
405      * @dev Returns the token collection symbol.
406      */
407     function symbol() external view returns (string memory);
408 
409     /**
410      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
411      */
412     function tokenURI(uint256 tokenId) external view returns (string memory);
413 }
414 
415 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
416 
417 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
418 
419 /**
420  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
421  * @dev See https://eips.ethereum.org/EIPS/eip-721
422  */
423 interface IERC721Enumerable is IERC721 {
424     /**
425      * @dev Returns the total amount of tokens stored by the contract.
426      */
427     function totalSupply() external view returns (uint256);
428 
429     /**
430      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
431      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
432      */
433     function tokenOfOwnerByIndex(address owner, uint256 index)
434         external
435         view
436         returns (uint256 tokenId);
437 
438     /**
439      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
440      * Use along with {totalSupply} to enumerate all tokens.
441      */
442     function tokenByIndex(uint256 index) external view returns (uint256);
443 }
444 
445 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
446 
447 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
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
499         require(
500             address(this).balance >= amount,
501             "Address: insufficient balance"
502         );
503 
504         (bool success, ) = recipient.call{value: amount}("");
505         require(
506             success,
507             "Address: unable to send value, recipient may have reverted"
508         );
509     }
510 
511     /**
512      * @dev Performs a Solidity function call using a low level `call`. A
513      * plain `call` is an unsafe replacement for a function call: use this
514      * function instead.
515      *
516      * If `target` reverts with a revert reason, it is bubbled up by this
517      * function (like regular Solidity function calls).
518      *
519      * Returns the raw returned data. To convert to the expected return value,
520      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
521      *
522      * Requirements:
523      *
524      * - `target` must be a contract.
525      * - calling `target` with `data` must not revert.
526      *
527      * _Available since v3.1._
528      */
529     function functionCall(address target, bytes memory data)
530         internal
531         returns (bytes memory)
532     {
533         return functionCall(target, data, "Address: low-level call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
538      * `errorMessage` as a fallback revert reason when `target` reverts.
539      *
540      * _Available since v3.1._
541      */
542     function functionCall(
543         address target,
544         bytes memory data,
545         string memory errorMessage
546     ) internal returns (bytes memory) {
547         return functionCallWithValue(target, data, 0, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but also transferring `value` wei to `target`.
553      *
554      * Requirements:
555      *
556      * - the calling contract must have an ETH balance of at least `value`.
557      * - the called Solidity function must be `payable`.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(
562         address target,
563         bytes memory data,
564         uint256 value
565     ) internal returns (bytes memory) {
566         return
567             functionCallWithValue(
568                 target,
569                 data,
570                 value,
571                 "Address: low-level call with value failed"
572             );
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
577      * with `errorMessage` as a fallback revert reason when `target` reverts.
578      *
579      * _Available since v3.1._
580      */
581     function functionCallWithValue(
582         address target,
583         bytes memory data,
584         uint256 value,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(
588             address(this).balance >= value,
589             "Address: insufficient balance for call"
590         );
591         require(isContract(target), "Address: call to non-contract");
592 
593         (bool success, bytes memory returndata) = target.call{value: value}(
594             data
595         );
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a static call.
602      *
603      * _Available since v3.3._
604      */
605     function functionStaticCall(address target, bytes memory data)
606         internal
607         view
608         returns (bytes memory)
609     {
610         return
611             functionStaticCall(
612                 target,
613                 data,
614                 "Address: low-level static call failed"
615             );
616     }
617 
618     /**
619      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
620      * but performing a static call.
621      *
622      * _Available since v3.3._
623      */
624     function functionStaticCall(
625         address target,
626         bytes memory data,
627         string memory errorMessage
628     ) internal view returns (bytes memory) {
629         require(isContract(target), "Address: static call to non-contract");
630 
631         (bool success, bytes memory returndata) = target.staticcall(data);
632         return verifyCallResult(success, returndata, errorMessage);
633     }
634 
635     /**
636      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
637      * but performing a delegate call.
638      *
639      * _Available since v3.4._
640      */
641     function functionDelegateCall(address target, bytes memory data)
642         internal
643         returns (bytes memory)
644     {
645         return
646             functionDelegateCall(
647                 target,
648                 data,
649                 "Address: low-level delegate call failed"
650             );
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a delegate call.
656      *
657      * _Available since v3.4._
658      */
659     function functionDelegateCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         require(isContract(target), "Address: delegate call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.delegatecall(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
672      * revert reason using the provided one.
673      *
674      * _Available since v4.3._
675      */
676     function verifyCallResult(
677         bool success,
678         bytes memory returndata,
679         string memory errorMessage
680     ) internal pure returns (bytes memory) {
681         if (success) {
682             return returndata;
683         } else {
684             // Look for revert reason and bubble it up if present
685             if (returndata.length > 0) {
686                 // The easiest way to bubble the revert reason is using memory via assembly
687 
688                 assembly {
689                     let returndata_size := mload(returndata)
690                     revert(add(32, returndata), returndata_size)
691                 }
692             } else {
693                 revert(errorMessage);
694             }
695         }
696     }
697 }
698 
699 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
700 
701 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
702 
703 /**
704  * @dev Implementation of the {IERC165} interface.
705  *
706  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
707  * for the additional interface id that will be supported. For example:
708  *
709  * ```solidity
710  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
711  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
712  * }
713  * ```
714  *
715  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
716  */
717 abstract contract ERC165 is IERC165 {
718     /**
719      * @dev See {IERC165-supportsInterface}.
720      */
721     function supportsInterface(bytes4 interfaceId)
722         public
723         view
724         virtual
725         override
726         returns (bool)
727     {
728         return interfaceId == type(IERC165).interfaceId;
729     }
730 }
731 
732 // File contracts/ERC721A.sol
733 
734 // Creator: Chiru Labs
735 
736 /**
737  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
738  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
739  *
740  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
741  *
742  * Does not support burning tokens to address(0).
743  *
744  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
745  */
746 contract ERC721A is
747     Context,
748     ERC165,
749     IERC721,
750     IERC721Metadata,
751     IERC721Enumerable
752 {
753     using Address for address;
754     using Strings for uint256;
755 
756     struct TokenOwnership {
757         address addr;
758         uint64 startTimestamp;
759     }
760 
761     struct AddressData {
762         uint128 balance;
763         uint128 numberMinted;
764     }
765 
766     uint256 internal currentIndex = 0;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to ownership details
775     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
776     mapping(uint256 => TokenOwnership) internal _ownerships;
777 
778     // Mapping owner address to address data
779     mapping(address => AddressData) private _addressData;
780 
781     // Mapping from token ID to approved address
782     mapping(uint256 => address) private _tokenApprovals;
783 
784     // Mapping from owner to operator approvals
785     mapping(address => mapping(address => bool)) private _operatorApprovals;
786 
787     constructor(string memory name_, string memory symbol_) {
788         _name = name_;
789         _symbol = symbol_;
790     }
791 
792     /**
793      * @dev See {IERC721Enumerable-totalSupply}.
794      */
795     function totalSupply() public view override returns (uint256) {
796         return currentIndex;
797     }
798 
799     /**
800      * @dev See {IERC721Enumerable-tokenByIndex}.
801      */
802     function tokenByIndex(uint256 index)
803         public
804         view
805         override
806         returns (uint256)
807     {
808         require(index < totalSupply(), "ERC721A: global index out of bounds");
809         return index;
810     }
811 
812     /**
813      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
814      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
815      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
816      */
817     function tokenOfOwnerByIndex(address owner, uint256 index)
818         public
819         view
820         override
821         returns (uint256)
822     {
823         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
824         uint256 numMintedSoFar = totalSupply();
825         uint256 tokenIdsIdx = 0;
826         address currOwnershipAddr = address(0);
827         for (uint256 i = 0; i < numMintedSoFar; i++) {
828             TokenOwnership memory ownership = _ownerships[i];
829             if (ownership.addr != address(0)) {
830                 currOwnershipAddr = ownership.addr;
831             }
832             if (currOwnershipAddr == owner) {
833                 if (tokenIdsIdx == index) {
834                     return i;
835                 }
836                 tokenIdsIdx++;
837             }
838         }
839         revert("ERC721A: unable to get token of owner by index");
840     }
841 
842     /**
843      * @dev See {IERC165-supportsInterface}.
844      */
845     function supportsInterface(bytes4 interfaceId)
846         public
847         view
848         virtual
849         override(ERC165, IERC165)
850         returns (bool)
851     {
852         return
853             interfaceId == type(IERC721).interfaceId ||
854             interfaceId == type(IERC721Metadata).interfaceId ||
855             interfaceId == type(IERC721Enumerable).interfaceId ||
856             super.supportsInterface(interfaceId);
857     }
858 
859     /**
860      * @dev See {IERC721-balanceOf}.
861      */
862     function balanceOf(address owner) public view override returns (uint256) {
863         require(
864             owner != address(0),
865             "ERC721A: balance query for the zero address"
866         );
867         return uint256(_addressData[owner].balance);
868     }
869 
870     function _numberMinted(address owner) internal view returns (uint256) {
871         require(
872             owner != address(0),
873             "ERC721A: number minted query for the zero address"
874         );
875         return uint256(_addressData[owner].numberMinted);
876     }
877 
878     function ownershipOf(uint256 tokenId)
879         internal
880         view
881         returns (TokenOwnership memory)
882     {
883         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
884 
885         for (uint256 curr = tokenId; ; curr--) {
886             TokenOwnership memory ownership = _ownerships[curr];
887             if (ownership.addr != address(0)) {
888                 return ownership;
889             }
890         }
891 
892         revert("ERC721A: unable to determine the owner of token");
893     }
894 
895     /**
896      * @dev See {IERC721-ownerOf}.
897      */
898     function ownerOf(uint256 tokenId) public view override returns (address) {
899         return ownershipOf(tokenId).addr;
900     }
901 
902     /**
903      * @dev See {IERC721Metadata-name}.
904      */
905     function name() public view virtual override returns (string memory) {
906         return _name;
907     }
908 
909     /**
910      * @dev See {IERC721Metadata-symbol}.
911      */
912     function symbol() public view virtual override returns (string memory) {
913         return _symbol;
914     }
915 
916     /**
917      * @dev See {IERC721Metadata-tokenURI}.
918      */
919     function tokenURI(uint256 tokenId)
920         public
921         view
922         virtual
923         override
924         returns (string memory)
925     {
926         require(
927             _exists(tokenId),
928             "ERC721Metadata: URI query for nonexistent token"
929         );
930 
931         string memory baseURI = _baseURI();
932         return
933             bytes(baseURI).length > 0
934                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
935                 : "";
936     }
937 
938     /**
939      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
940      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
941      * by default, can be overriden in child contracts.
942      */
943     function _baseURI() internal view virtual returns (string memory) {
944         return "";
945     }
946 
947     /**
948      * @dev See {IERC721-approve}.
949      */
950     function approve(address to, uint256 tokenId) public override {
951         address owner = ERC721A.ownerOf(tokenId);
952         require(to != owner, "ERC721A: approval to current owner");
953 
954         require(
955             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
956             "ERC721A: approve caller is not owner nor approved for all"
957         );
958 
959         _approve(to, tokenId, owner);
960     }
961 
962     /**
963      * @dev See {IERC721-getApproved}.
964      */
965     function getApproved(uint256 tokenId)
966         public
967         view
968         override
969         returns (address)
970     {
971         require(
972             _exists(tokenId),
973             "ERC721A: approved query for nonexistent token"
974         );
975 
976         return _tokenApprovals[tokenId];
977     }
978 
979     /**
980      * @dev See {IERC721-setApprovalForAll}.
981      */
982     function setApprovalForAll(address operator, bool approved)
983         public
984         override
985     {
986         require(operator != _msgSender(), "ERC721A: approve to caller");
987 
988         _operatorApprovals[_msgSender()][operator] = approved;
989         emit ApprovalForAll(_msgSender(), operator, approved);
990     }
991 
992     /**
993      * @dev See {IERC721-isApprovedForAll}.
994      */
995     function isApprovedForAll(address owner, address operator)
996         public
997         view
998         virtual
999         override
1000         returns (bool)
1001     {
1002         return _operatorApprovals[owner][operator];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-transferFrom}.
1007      */
1008     function transferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public override {
1013         _transfer(from, to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public override {
1024         safeTransferFrom(from, to, tokenId, "");
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId,
1034         bytes memory _data
1035     ) public override {
1036         _transfer(from, to, tokenId);
1037         require(
1038             _checkOnERC721Received(from, to, tokenId, _data),
1039             "ERC721A: transfer to non ERC721Receiver implementer"
1040         );
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
1051         return tokenId < currentIndex;
1052     }
1053 
1054     function _safeMint(address to, uint256 quantity) internal {
1055         _safeMint(to, quantity, "");
1056     }
1057 
1058     /**
1059      * @dev Mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `quantity` cannot be larger than the max batch size.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _safeMint(
1069         address to,
1070         uint256 quantity,
1071         bytes memory _data
1072     ) internal {
1073         uint256 startTokenId = currentIndex;
1074         require(to != address(0), "ERC721A: mint to the zero address");
1075         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1076         require(!_exists(startTokenId), "ERC721A: token already minted");
1077         require(quantity > 0, "ERC721A: quantity must be greater 0");
1078 
1079         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1080 
1081         AddressData memory addressData = _addressData[to];
1082         _addressData[to] = AddressData(
1083             addressData.balance + uint128(quantity),
1084             addressData.numberMinted + uint128(quantity)
1085         );
1086         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1087 
1088         uint256 updatedIndex = startTokenId;
1089 
1090         for (uint256 i = 0; i < quantity; i++) {
1091             emit Transfer(address(0), to, updatedIndex);
1092             require(
1093                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1094                 "ERC721A: transfer to non ERC721Receiver implementer"
1095             );
1096             updatedIndex++;
1097         }
1098 
1099         currentIndex = updatedIndex;
1100         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1101     }
1102 
1103     /**
1104      * @dev Transfers `tokenId` from `from` to `to`.
1105      *
1106      * Requirements:
1107      *
1108      * - `to` cannot be the zero address.
1109      * - `tokenId` token must be owned by `from`.
1110      *
1111      * Emits a {Transfer} event.
1112      */
1113     function _transfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) private {
1118         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1119 
1120         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1121             getApproved(tokenId) == _msgSender() ||
1122             isApprovedForAll(prevOwnership.addr, _msgSender()));
1123 
1124         require(
1125             isApprovedOrOwner,
1126             "ERC721A: transfer caller is not owner nor approved"
1127         );
1128 
1129         require(
1130             prevOwnership.addr == from,
1131             "ERC721A: transfer from incorrect owner"
1132         );
1133         require(to != address(0), "ERC721A: transfer to the zero address");
1134 
1135         _beforeTokenTransfers(from, to, tokenId, 1);
1136 
1137         // Clear approvals from the previous owner
1138         _approve(address(0), tokenId, prevOwnership.addr);
1139 
1140         // Underflow of the sender's balance is impossible because we check for
1141         // ownership above and the recipient's balance can't realistically overflow.
1142         unchecked {
1143             _addressData[from].balance -= 1;
1144             _addressData[to].balance += 1;
1145         }
1146 
1147         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1148 
1149         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1150         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1151         uint256 nextTokenId = tokenId + 1;
1152         if (_ownerships[nextTokenId].addr == address(0)) {
1153             if (_exists(nextTokenId)) {
1154                 _ownerships[nextTokenId] = TokenOwnership(
1155                     prevOwnership.addr,
1156                     prevOwnership.startTimestamp
1157                 );
1158             }
1159         }
1160 
1161         emit Transfer(from, to, tokenId);
1162         _afterTokenTransfers(from, to, tokenId, 1);
1163     }
1164 
1165     /**
1166      * @dev Approve `to` to operate on `tokenId`
1167      *
1168      * Emits a {Approval} event.
1169      */
1170     function _approve(
1171         address to,
1172         uint256 tokenId,
1173         address owner
1174     ) private {
1175         _tokenApprovals[tokenId] = to;
1176         emit Approval(owner, to, tokenId);
1177     }
1178 
1179     /**
1180      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1181      * The call is not executed if the target address is not a contract.
1182      *
1183      * @param from address representing the previous owner of the given token ID
1184      * @param to target address that will receive the tokens
1185      * @param tokenId uint256 ID of the token to be transferred
1186      * @param _data bytes optional data to send along with the call
1187      * @return bool whether the call correctly returned the expected magic value
1188      */
1189     function _checkOnERC721Received(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) private returns (bool) {
1195         if (to.isContract()) {
1196             try
1197                 IERC721Receiver(to).onERC721Received(
1198                     _msgSender(),
1199                     from,
1200                     tokenId,
1201                     _data
1202                 )
1203             returns (bytes4 retval) {
1204                 return retval == IERC721Receiver(to).onERC721Received.selector;
1205             } catch (bytes memory reason) {
1206                 if (reason.length == 0) {
1207                     revert(
1208                         "ERC721A: transfer to non ERC721Receiver implementer"
1209                     );
1210                 } else {
1211                     assembly {
1212                         revert(add(32, reason), mload(reason))
1213                     }
1214                 }
1215             }
1216         } else {
1217             return true;
1218         }
1219     }
1220 
1221     /**
1222      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1223      *
1224      * startTokenId - the first token id to be transferred
1225      * quantity - the amount to be transferred
1226      *
1227      * Calling conditions:
1228      *
1229      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1230      * transferred to `to`.
1231      * - When `from` is zero, `tokenId` will be minted for `to`.
1232      */
1233     function _beforeTokenTransfers(
1234         address from,
1235         address to,
1236         uint256 startTokenId,
1237         uint256 quantity
1238     ) internal virtual {}
1239 
1240     /**
1241      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1242      * minting.
1243      *
1244      * startTokenId - the first token id to be transferred
1245      * quantity - the amount to be transferred
1246      *
1247      * Calling conditions:
1248      *
1249      * - when `from` and `to` are both non-zero.
1250      * - `from` and `to` are never both zero.
1251      */
1252     function _afterTokenTransfers(
1253         address from,
1254         address to,
1255         uint256 startTokenId,
1256         uint256 quantity
1257     ) internal virtual {}
1258 }
1259 
1260 contract Cocoverse is ERC721A, Ownable {
1261     string public constant baseExtension = ".json";
1262     address public constant proxyRegistryAddress =
1263         0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1264 
1265     string baseURI;
1266     string public notRevealedUri;
1267     uint256 public price = 0.005 ether;
1268     uint256 public MAX_SUPPLY = 2222;
1269     uint256 public FREE_MAX_SUPPLY = 0;
1270     uint256 public MAX_PER_TX = 3;
1271 
1272     bool public paused = true;
1273     bool public revealed = false;
1274 
1275     constructor(
1276         string memory _initBaseURI,
1277         string memory _initNotRevealedUri
1278     ) ERC721A("Cocoverse", "CV") {
1279         setBaseURI(_initBaseURI);
1280         setNotRevealedURI(_initNotRevealedUri);
1281     }
1282 
1283     function mint(uint256 _amount) public payable {
1284         require(!paused, "Paused");
1285         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1286         require(_amount > 0, "No 0 mints");
1287 
1288         if (FREE_MAX_SUPPLY >= totalSupply() + _amount) {
1289             require(MAX_PER_TX >= _amount, "Exceeds max per transaction");
1290         } else {
1291             require(MAX_PER_TX >= _amount, "Exceeds max per transaction");
1292             require(msg.value >= _amount * price, "Invalid funds provided");
1293         }
1294 
1295         _safeMint(msg.sender, _amount);
1296     }
1297 
1298     function isApprovedForAll(address owner, address operator)
1299         public
1300         view
1301         override
1302         returns (bool)
1303     {
1304         // Whitelist OpenSea proxy contract for easy trading.
1305         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1306         if (address(proxyRegistry.proxies(owner)) == operator) {
1307             return true;
1308         }
1309 
1310         return super.isApprovedForAll(owner, operator);
1311     }
1312 
1313     function withdraw() public onlyOwner {
1314         (bool success, ) = payable(msg.sender).call{
1315             value: address(this).balance
1316         }("");
1317         require(success);
1318     }
1319 
1320     function pause(bool _state) public onlyOwner {
1321         paused = _state;
1322     }
1323 
1324     function reveal(bool _state) public onlyOwner {
1325         revealed = _state;
1326     }
1327 
1328     function setPrice(uint256 _newPrice) public onlyOwner {
1329         price = _newPrice;
1330     }
1331 
1332     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1333         MAX_SUPPLY = _newMaxSupply;
1334     }
1335 
1336     function setFreeMaxSupply(uint256 _newFreeMaxSupply) public onlyOwner {
1337         FREE_MAX_SUPPLY = _newFreeMaxSupply;
1338     }
1339 
1340     function setMaxPerTx(uint256 _newMaxPerTx) public onlyOwner {
1341         MAX_PER_TX = _newMaxPerTx;
1342     }
1343 
1344     function setBaseURI(string memory baseURI_) public onlyOwner {
1345         baseURI = baseURI_;
1346     }
1347 
1348     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1349         notRevealedUri = _notRevealedURI;
1350     }
1351 
1352     function tokenURI(uint256 _tokenId)
1353         public
1354         view
1355         override
1356         returns (string memory)
1357     {
1358         require(_exists(_tokenId), "Token does not exist.");
1359 
1360         if (revealed == false) {
1361             return notRevealedUri;
1362         }
1363 
1364         return
1365             bytes(baseURI).length > 0
1366                 ? string(
1367                     abi.encodePacked(
1368                         baseURI,
1369                         Strings.toString(_tokenId),
1370                         baseExtension
1371                     )
1372                 )
1373                 : "";
1374     }
1375 }
1376 
1377 contract OwnableDelegateProxy {}
1378 
1379 contract ProxyRegistry {
1380     mapping(address => OwnableDelegateProxy) public proxies;
1381 }