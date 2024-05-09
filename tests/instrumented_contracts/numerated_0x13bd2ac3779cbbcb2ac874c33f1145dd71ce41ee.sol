1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
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
36         require(value > 0, "Counter: decrement overflow");
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
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/access/Ownable.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * By default, the owner account will be the one that deploys the contract. This
158  * can later be changed with {transferOwnership}.
159  *
160  * This module is used through inheritance. It will make available the modifier
161  * `onlyOwner`, which can be applied to your functions to restrict their use to
162  * the owner.
163  */
164 abstract contract Ownable is Context {
165     address private _owner;
166 
167     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
168 
169     /**
170      * @dev Initializes the contract setting the deployer as the initial owner.
171      */
172     constructor() {
173         _transferOwnership(_msgSender());
174     }
175 
176     /**
177      * @dev Returns the address of the current owner.
178      */
179     function owner() public view virtual returns (address) {
180         return _owner;
181     }
182 
183     /**
184      * @dev Throws if called by any account other than the owner.
185      */
186     modifier onlyOwner() {
187         require(owner() == _msgSender(), "Ownable: caller is not the owner");
188         _;
189     }
190 
191     /**
192      * @dev Leaves the contract without owner. It will not be possible to call
193      * `onlyOwner` functions anymore. Can only be called by the current owner.
194      *
195      * NOTE: Renouncing ownership will leave the contract without an owner,
196      * thereby removing any functionality that is only available to the owner.
197      */
198     function renounceOwnership() public virtual onlyOwner {
199         _transferOwnership(address(0));
200     }
201 
202     /**
203      * @dev Transfers ownership of the contract to a new account (`newOwner`).
204      * Can only be called by the current owner.
205      */
206     function transferOwnership(address newOwner) public virtual onlyOwner {
207         require(newOwner != address(0), "Ownable: new owner is the zero address");
208         _transferOwnership(newOwner);
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Internal function without access restriction.
214      */
215     function _transferOwnership(address newOwner) internal virtual {
216         address oldOwner = _owner;
217         _owner = newOwner;
218         emit OwnershipTransferred(oldOwner, newOwner);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Address.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Collection of functions related to the address type
231  */
232 library Address {
233     /**
234      * @dev Returns true if `account` is a contract.
235      *
236      * [IMPORTANT]
237      * ====
238      * It is unsafe to assume that an address for which this function returns
239      * false is an externally-owned account (EOA) and not a contract.
240      *
241      * Among others, `isContract` will return false for the following
242      * types of addresses:
243      *
244      *  - an externally-owned account
245      *  - a contract in construction
246      *  - an address where a contract will be created
247      *  - an address where a contract lived, but was destroyed
248      * ====
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies on extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         uint256 size;
256         assembly {
257             size := extcodesize(account)
258         }
259         return size > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCall(target, data, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         require(isContract(target), "Address: call to non-contract");
354 
355         (bool success, bytes memory returndata) = target.call{value: value}(data);
356         return verifyCallResult(success, returndata, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but performing a static call.
362      *
363      * _Available since v3.3._
364      */
365     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
366         return functionStaticCall(target, data, "Address: low-level static call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal view returns (bytes memory) {
380         require(isContract(target), "Address: static call to non-contract");
381 
382         (bool success, bytes memory returndata) = target.staticcall(data);
383         return verifyCallResult(success, returndata, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but performing a delegate call.
389      *
390      * _Available since v3.4._
391      */
392     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         require(isContract(target), "Address: delegate call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.delegatecall(data);
410         return verifyCallResult(success, returndata, errorMessage);
411     }
412 
413     /**
414      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
415      * revert reason using the provided one.
416      *
417      * _Available since v4.3._
418      */
419     function verifyCallResult(
420         bool success,
421         bytes memory returndata,
422         string memory errorMessage
423     ) internal pure returns (bytes memory) {
424         if (success) {
425             return returndata;
426         } else {
427             // Look for revert reason and bubble it up if present
428             if (returndata.length > 0) {
429                 // The easiest way to bubble the revert reason is using memory via assembly
430 
431                 assembly {
432                     let returndata_size := mload(returndata)
433                     revert(add(32, returndata), returndata_size)
434                 }
435             } else {
436                 revert(errorMessage);
437             }
438         }
439     }
440 }
441 
442 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @title ERC721 token receiver interface
451  * @dev Interface for any contract that wants to support safeTransfers
452  * from ERC721 asset contracts.
453  */
454 interface IERC721Receiver {
455     /**
456      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
457      * by `operator` from `from`, this function is called.
458      *
459      * It must return its Solidity selector to confirm the token transfer.
460      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
461      *
462      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
463      */
464     function onERC721Received(
465         address operator,
466         address from,
467         uint256 tokenId,
468         bytes calldata data
469     ) external returns (bytes4);
470 }
471 
472 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
473 
474 
475 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Interface of the ERC165 standard, as defined in the
481  * https://eips.ethereum.org/EIPS/eip-165[EIP].
482  *
483  * Implementers can declare support of contract interfaces, which can then be
484  * queried by others ({ERC165Checker}).
485  *
486  * For an implementation, see {ERC165}.
487  */
488 interface IERC165 {
489     /**
490      * @dev Returns true if this contract implements the interface defined by
491      * `interfaceId`. See the corresponding
492      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
493      * to learn more about how these ids are created.
494      *
495      * This function call must use less than 30 000 gas.
496      */
497     function supportsInterface(bytes4 interfaceId) external view returns (bool);
498 }
499 
500 // File: @openzeppelin/contracts/interfaces/IERC165.sol
501 
502 
503 // OpenZeppelin Contracts v4.4.0 (interfaces/IERC165.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 
508 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
509 
510 
511 // OpenZeppelin Contracts v4.4.0 (interfaces/IERC2981.sol)
512 
513 pragma solidity ^0.8.0;
514 
515 
516 /**
517  * @dev Interface for the NFT Royalty Standard
518  */
519 interface IERC2981 is IERC165 {
520     /**
521      * @dev Called with the sale price to determine how much royalty is owed and to whom.
522      * @param tokenId - the NFT asset queried for royalty information
523      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
524      * @return receiver - address of who should be sent the royalty payment
525      * @return royaltyAmount - the royalty payment amount for `salePrice`
526      */
527     function royaltyInfo(uint256 tokenId, uint256 salePrice)
528         external
529         view
530         returns (address receiver, uint256 royaltyAmount);
531 }
532 
533 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
534 
535 
536 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Implementation of the {IERC165} interface.
543  *
544  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
545  * for the additional interface id that will be supported. For example:
546  *
547  * ```solidity
548  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
549  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
550  * }
551  * ```
552  *
553  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
554  */
555 abstract contract ERC165 is IERC165 {
556     /**
557      * @dev See {IERC165-supportsInterface}.
558      */
559     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
560         return interfaceId == type(IERC165).interfaceId;
561     }
562 }
563 
564 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
565 
566 
567 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 /**
573  * @dev Required interface of an ERC721 compliant contract.
574  */
575 interface IERC721 is IERC165 {
576     /**
577      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
578      */
579     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
583      */
584     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
585 
586     /**
587      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
588      */
589     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
590 
591     /**
592      * @dev Returns the number of tokens in ``owner``'s account.
593      */
594     function balanceOf(address owner) external view returns (uint256 balance);
595 
596     /**
597      * @dev Returns the owner of the `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function ownerOf(uint256 tokenId) external view returns (address owner);
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
607      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
608      *
609      * Requirements:
610      *
611      * - `from` cannot be the zero address.
612      * - `to` cannot be the zero address.
613      * - `tokenId` token must exist and be owned by `from`.
614      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
615      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
616      *
617      * Emits a {Transfer} event.
618      */
619     function safeTransferFrom(
620         address from,
621         address to,
622         uint256 tokenId
623     ) external;
624 
625     /**
626      * @dev Transfers `tokenId` token from `from` to `to`.
627      *
628      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
629      *
630      * Requirements:
631      *
632      * - `from` cannot be the zero address.
633      * - `to` cannot be the zero address.
634      * - `tokenId` token must be owned by `from`.
635      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
636      *
637      * Emits a {Transfer} event.
638      */
639     function transferFrom(
640         address from,
641         address to,
642         uint256 tokenId
643     ) external;
644 
645     /**
646      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
647      * The approval is cleared when the token is transferred.
648      *
649      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
650      *
651      * Requirements:
652      *
653      * - The caller must own the token or be an approved operator.
654      * - `tokenId` must exist.
655      *
656      * Emits an {Approval} event.
657      */
658     function approve(address to, uint256 tokenId) external;
659 
660     /**
661      * @dev Returns the account approved for `tokenId` token.
662      *
663      * Requirements:
664      *
665      * - `tokenId` must exist.
666      */
667     function getApproved(uint256 tokenId) external view returns (address operator);
668 
669     /**
670      * @dev Approve or remove `operator` as an operator for the caller.
671      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
672      *
673      * Requirements:
674      *
675      * - The `operator` cannot be the caller.
676      *
677      * Emits an {ApprovalForAll} event.
678      */
679     function setApprovalForAll(address operator, bool _approved) external;
680 
681     /**
682      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
683      *
684      * See {setApprovalForAll}
685      */
686     function isApprovedForAll(address owner, address operator) external view returns (bool);
687 
688     /**
689      * @dev Safely transfers `tokenId` token from `from` to `to`.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must exist and be owned by `from`.
696      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
697      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
698      *
699      * Emits a {Transfer} event.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId,
705         bytes calldata data
706     ) external;
707 }
708 
709 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
719  * @dev See https://eips.ethereum.org/EIPS/eip-721
720  */
721 interface IERC721Enumerable is IERC721 {
722     /**
723      * @dev Returns the total amount of tokens stored by the contract.
724      */
725     function totalSupply() external view returns (uint256);
726 
727     /**
728      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
729      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
730      */
731     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
732 
733     /**
734      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
735      * Use along with {totalSupply} to enumerate all tokens.
736      */
737     function tokenByIndex(uint256 index) external view returns (uint256);
738 }
739 
740 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
741 
742 
743 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
750  * @dev See https://eips.ethereum.org/EIPS/eip-721
751  */
752 interface IERC721Metadata is IERC721 {
753     /**
754      * @dev Returns the token collection name.
755      */
756     function name() external view returns (string memory);
757 
758     /**
759      * @dev Returns the token collection symbol.
760      */
761     function symbol() external view returns (string memory);
762 
763     /**
764      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
765      */
766     function tokenURI(uint256 tokenId) external view returns (string memory);
767 }
768 
769 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
770 
771 
772 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
773 
774 pragma solidity ^0.8.0;
775 
776 
777 
778 
779 
780 
781 
782 
783 /**
784  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
785  * the Metadata extension, but not including the Enumerable extension, which is available separately as
786  * {ERC721Enumerable}.
787  */
788 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
789     using Address for address;
790     using Strings for uint256;
791 
792     // Token name
793     string private _name;
794 
795     // Token symbol
796     string private _symbol;
797 
798     // Mapping from token ID to owner address
799     mapping(uint256 => address) private _owners;
800 
801     // Mapping owner address to token count
802     mapping(address => uint256) private _balances;
803 
804     // Mapping from token ID to approved address
805     mapping(uint256 => address) private _tokenApprovals;
806 
807     // Mapping from owner to operator approvals
808     mapping(address => mapping(address => bool)) private _operatorApprovals;
809 
810     /**
811      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
812      */
813     constructor(string memory name_, string memory symbol_) {
814         _name = name_;
815         _symbol = symbol_;
816     }
817 
818     /**
819      * @dev See {IERC165-supportsInterface}.
820      */
821     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
822         return
823             interfaceId == type(IERC721).interfaceId ||
824             interfaceId == type(IERC721Metadata).interfaceId ||
825             super.supportsInterface(interfaceId);
826     }
827 
828     /**
829      * @dev See {IERC721-balanceOf}.
830      */
831     function balanceOf(address owner) public view virtual override returns (uint256) {
832         require(owner != address(0), "ERC721: balance query for the zero address");
833         return _balances[owner];
834     }
835 
836     /**
837      * @dev See {IERC721-ownerOf}.
838      */
839     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
840         address owner = _owners[tokenId];
841         require(owner != address(0), "ERC721: owner query for nonexistent token");
842         return owner;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-name}.
847      */
848     function name() public view virtual override returns (string memory) {
849         return _name;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-symbol}.
854      */
855     function symbol() public view virtual override returns (string memory) {
856         return _symbol;
857     }
858 
859     /**
860      * @dev See {IERC721Metadata-tokenURI}.
861      */
862     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
863         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
864 
865         string memory baseURI = _baseURI();
866         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
867     }
868 
869     /**
870      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
871      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
872      * by default, can be overriden in child contracts.
873      */
874     function _baseURI() internal view virtual returns (string memory) {
875         return "";
876     }
877 
878     /**
879      * @dev See {IERC721-approve}.
880      */
881     function approve(address to, uint256 tokenId) public virtual override {
882         address owner = ERC721.ownerOf(tokenId);
883         require(to != owner, "ERC721: approval to current owner");
884 
885         require(
886             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
887             "ERC721: approve caller is not owner nor approved for all"
888         );
889 
890         _approve(to, tokenId);
891     }
892 
893     /**
894      * @dev See {IERC721-getApproved}.
895      */
896     function getApproved(uint256 tokenId) public view virtual override returns (address) {
897         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
898 
899         return _tokenApprovals[tokenId];
900     }
901 
902     /**
903      * @dev See {IERC721-setApprovalForAll}.
904      */
905     function setApprovalForAll(address operator, bool approved) public virtual override {
906         _setApprovalForAll(_msgSender(), operator, approved);
907     }
908 
909     /**
910      * @dev See {IERC721-isApprovedForAll}.
911      */
912     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
913         return _operatorApprovals[owner][operator];
914     }
915 
916     /**
917      * @dev See {IERC721-transferFrom}.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public virtual override {
924         //solhint-disable-next-line max-line-length
925         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
926 
927         _transfer(from, to, tokenId);
928     }
929 
930     /**
931      * @dev See {IERC721-safeTransferFrom}.
932      */
933     function safeTransferFrom(
934         address from,
935         address to,
936         uint256 tokenId
937     ) public virtual override {
938         safeTransferFrom(from, to, tokenId, "");
939     }
940 
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId,
948         bytes memory _data
949     ) public virtual override {
950         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
951         _safeTransfer(from, to, tokenId, _data);
952     }
953 
954     /**
955      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
956      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
957      *
958      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
959      *
960      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
961      * implement alternative mechanisms to perform token transfer, such as signature-based.
962      *
963      * Requirements:
964      *
965      * - `from` cannot be the zero address.
966      * - `to` cannot be the zero address.
967      * - `tokenId` token must exist and be owned by `from`.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeTransfer(
973         address from,
974         address to,
975         uint256 tokenId,
976         bytes memory _data
977     ) internal virtual {
978         _transfer(from, to, tokenId);
979         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
980     }
981 
982     /**
983      * @dev Returns whether `tokenId` exists.
984      *
985      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
986      *
987      * Tokens start existing when they are minted (`_mint`),
988      * and stop existing when they are burned (`_burn`).
989      */
990     function _exists(uint256 tokenId) internal view virtual returns (bool) {
991         return _owners[tokenId] != address(0);
992     }
993 
994     /**
995      * @dev Returns whether `spender` is allowed to manage `tokenId`.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      */
1001     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1002         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1003         address owner = ERC721.ownerOf(tokenId);
1004         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1005     }
1006 
1007     /**
1008      * @dev Safely mints `tokenId` and transfers it to `to`.
1009      *
1010      * Requirements:
1011      *
1012      * - `tokenId` must not exist.
1013      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1014      *
1015      * Emits a {Transfer} event.
1016      */
1017     function _safeMint(address to, uint256 tokenId) internal virtual {
1018         _safeMint(to, tokenId, "");
1019     }
1020 
1021     /**
1022      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1023      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1024      */
1025     function _safeMint(
1026         address to,
1027         uint256 tokenId,
1028         bytes memory _data
1029     ) internal virtual {
1030         _mint(to, tokenId);
1031         require(
1032             _checkOnERC721Received(address(0), to, tokenId, _data),
1033             "ERC721: transfer to non ERC721Receiver implementer"
1034         );
1035     }
1036 
1037     /**
1038      * @dev Mints `tokenId` and transfers it to `to`.
1039      *
1040      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must not exist.
1045      * - `to` cannot be the zero address.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function _mint(address to, uint256 tokenId) internal virtual {
1050         require(to != address(0), "ERC721: mint to the zero address");
1051         require(!_exists(tokenId), "ERC721: token already minted");
1052 
1053         _beforeTokenTransfer(address(0), to, tokenId);
1054 
1055         _balances[to] += 1;
1056         _owners[tokenId] = to;
1057 
1058         emit Transfer(address(0), to, tokenId);
1059     }
1060 
1061     /**
1062      * @dev Destroys `tokenId`.
1063      * The approval is cleared when the token is burned.
1064      *
1065      * Requirements:
1066      *
1067      * - `tokenId` must exist.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _burn(uint256 tokenId) internal virtual {
1072         address owner = ERC721.ownerOf(tokenId);
1073 
1074         _beforeTokenTransfer(owner, address(0), tokenId);
1075 
1076         // Clear approvals
1077         _approve(address(0), tokenId);
1078 
1079         _balances[owner] -= 1;
1080         delete _owners[tokenId];
1081 
1082         emit Transfer(owner, address(0), tokenId);
1083     }
1084 
1085     /**
1086      * @dev Transfers `tokenId` from `from` to `to`.
1087      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1088      *
1089      * Requirements:
1090      *
1091      * - `to` cannot be the zero address.
1092      * - `tokenId` token must be owned by `from`.
1093      *
1094      * Emits a {Transfer} event.
1095      */
1096     function _transfer(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) internal virtual {
1101         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1102         require(to != address(0), "ERC721: transfer to the zero address");
1103 
1104         _beforeTokenTransfer(from, to, tokenId);
1105 
1106         // Clear approvals from the previous owner
1107         _approve(address(0), tokenId);
1108 
1109         _balances[from] -= 1;
1110         _balances[to] += 1;
1111         _owners[tokenId] = to;
1112 
1113         emit Transfer(from, to, tokenId);
1114     }
1115 
1116     /**
1117      * @dev Approve `to` to operate on `tokenId`
1118      *
1119      * Emits a {Approval} event.
1120      */
1121     function _approve(address to, uint256 tokenId) internal virtual {
1122         _tokenApprovals[tokenId] = to;
1123         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1124     }
1125 
1126     /**
1127      * @dev Approve `operator` to operate on all of `owner` tokens
1128      *
1129      * Emits a {ApprovalForAll} event.
1130      */
1131     function _setApprovalForAll(
1132         address owner,
1133         address operator,
1134         bool approved
1135     ) internal virtual {
1136         require(owner != operator, "ERC721: approve to caller");
1137         _operatorApprovals[owner][operator] = approved;
1138         emit ApprovalForAll(owner, operator, approved);
1139     }
1140 
1141     /**
1142      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1143      * The call is not executed if the target address is not a contract.
1144      *
1145      * @param from address representing the previous owner of the given token ID
1146      * @param to target address that will receive the tokens
1147      * @param tokenId uint256 ID of the token to be transferred
1148      * @param _data bytes optional data to send along with the call
1149      * @return bool whether the call correctly returned the expected magic value
1150      */
1151     function _checkOnERC721Received(
1152         address from,
1153         address to,
1154         uint256 tokenId,
1155         bytes memory _data
1156     ) private returns (bool) {
1157         if (to.isContract()) {
1158             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1159                 return retval == IERC721Receiver.onERC721Received.selector;
1160             } catch (bytes memory reason) {
1161                 if (reason.length == 0) {
1162                     revert("ERC721: transfer to non ERC721Receiver implementer");
1163                 } else {
1164                     assembly {
1165                         revert(add(32, reason), mload(reason))
1166                     }
1167                 }
1168             }
1169         } else {
1170             return true;
1171         }
1172     }
1173 
1174     /**
1175      * @dev Hook that is called before any token transfer. This includes minting
1176      * and burning.
1177      *
1178      * Calling conditions:
1179      *
1180      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1181      * transferred to `to`.
1182      * - When `from` is zero, `tokenId` will be minted for `to`.
1183      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1184      * - `from` and `to` are never both zero.
1185      *
1186      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1187      */
1188     function _beforeTokenTransfer(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) internal virtual {}
1193 }
1194 
1195 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1196 
1197 
1198 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1199 
1200 pragma solidity ^0.8.0;
1201 
1202 
1203 
1204 /**
1205  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1206  * enumerability of all the token ids in the contract as well as all token ids owned by each
1207  * account.
1208  */
1209 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1210     // Mapping from owner to list of owned token IDs
1211     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1212 
1213     // Mapping from token ID to index of the owner tokens list
1214     mapping(uint256 => uint256) private _ownedTokensIndex;
1215 
1216     // Array with all token ids, used for enumeration
1217     uint256[] private _allTokens;
1218 
1219     // Mapping from token id to position in the allTokens array
1220     mapping(uint256 => uint256) private _allTokensIndex;
1221 
1222     /**
1223      * @dev See {IERC165-supportsInterface}.
1224      */
1225     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1226         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1227     }
1228 
1229     /**
1230      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1231      */
1232     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1233         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1234         return _ownedTokens[owner][index];
1235     }
1236 
1237     /**
1238      * @dev See {IERC721Enumerable-totalSupply}.
1239      */
1240     function totalSupply() public view virtual override returns (uint256) {
1241         return _allTokens.length;
1242     }
1243 
1244     /**
1245      * @dev See {IERC721Enumerable-tokenByIndex}.
1246      */
1247     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1248         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1249         return _allTokens[index];
1250     }
1251 
1252     /**
1253      * @dev Hook that is called before any token transfer. This includes minting
1254      * and burning.
1255      *
1256      * Calling conditions:
1257      *
1258      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1259      * transferred to `to`.
1260      * - When `from` is zero, `tokenId` will be minted for `to`.
1261      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1262      * - `from` cannot be the zero address.
1263      * - `to` cannot be the zero address.
1264      *
1265      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1266      */
1267     function _beforeTokenTransfer(
1268         address from,
1269         address to,
1270         uint256 tokenId
1271     ) internal virtual override {
1272         super._beforeTokenTransfer(from, to, tokenId);
1273 
1274         if (from == address(0)) {
1275             _addTokenToAllTokensEnumeration(tokenId);
1276         } else if (from != to) {
1277             _removeTokenFromOwnerEnumeration(from, tokenId);
1278         }
1279         if (to == address(0)) {
1280             _removeTokenFromAllTokensEnumeration(tokenId);
1281         } else if (to != from) {
1282             _addTokenToOwnerEnumeration(to, tokenId);
1283         }
1284     }
1285 
1286     /**
1287      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1288      * @param to address representing the new owner of the given token ID
1289      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1290      */
1291     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1292         uint256 length = ERC721.balanceOf(to);
1293         _ownedTokens[to][length] = tokenId;
1294         _ownedTokensIndex[tokenId] = length;
1295     }
1296 
1297     /**
1298      * @dev Private function to add a token to this extension's token tracking data structures.
1299      * @param tokenId uint256 ID of the token to be added to the tokens list
1300      */
1301     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1302         _allTokensIndex[tokenId] = _allTokens.length;
1303         _allTokens.push(tokenId);
1304     }
1305 
1306     /**
1307      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1308      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1309      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1310      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1311      * @param from address representing the previous owner of the given token ID
1312      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1313      */
1314     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1315         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1316         // then delete the last slot (swap and pop).
1317 
1318         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1319         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1320 
1321         // When the token to delete is the last token, the swap operation is unnecessary
1322         if (tokenIndex != lastTokenIndex) {
1323             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1324 
1325             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1326             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1327         }
1328 
1329         // This also deletes the contents at the last position of the array
1330         delete _ownedTokensIndex[tokenId];
1331         delete _ownedTokens[from][lastTokenIndex];
1332     }
1333 
1334     /**
1335      * @dev Private function to remove a token from this extension's token tracking data structures.
1336      * This has O(1) time complexity, but alters the order of the _allTokens array.
1337      * @param tokenId uint256 ID of the token to be removed from the tokens list
1338      */
1339     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1340         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1341         // then delete the last slot (swap and pop).
1342 
1343         uint256 lastTokenIndex = _allTokens.length - 1;
1344         uint256 tokenIndex = _allTokensIndex[tokenId];
1345 
1346         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1347         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1348         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1349         uint256 lastTokenId = _allTokens[lastTokenIndex];
1350 
1351         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1352         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1353 
1354         // This also deletes the contents at the last position of the array
1355         delete _allTokensIndex[tokenId];
1356         _allTokens.pop();
1357     }
1358 }
1359 
1360 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1361 
1362 
1363 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
1364 
1365 pragma solidity ^0.8.0;
1366 
1367 /**
1368  * @dev Contract module that helps prevent reentrant calls to a function.
1369  *
1370  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1371  * available, which can be applied to functions to make sure there are no nested
1372  * (reentrant) calls to them.
1373  *
1374  * Note that because there is a single `nonReentrant` guard, functions marked as
1375  * `nonReentrant` may not call one another. This can be worked around by making
1376  * those functions `private`, and then adding `external` `nonReentrant` entry
1377  * points to them.
1378  *
1379  * TIP: If you would like to learn more about reentrancy and alternative ways
1380  * to protect against it, check out our blog post
1381  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1382  */
1383 abstract contract ReentrancyGuard {
1384     // Booleans are more expensive than uint256 or any type that takes up a full
1385     // word because each write operation emits an extra SLOAD to first read the
1386     // slot's contents, replace the bits taken up by the boolean, and then write
1387     // back. This is the compiler's defense against contract upgrades and
1388     // pointer aliasing, and it cannot be disabled.
1389 
1390     // The values being non-zero value makes deployment a bit more expensive,
1391     // but in exchange the refund on every call to nonReentrant will be lower in
1392     // amount. Since refunds are capped to a percentage of the total
1393     // transaction's gas, it is best to keep them low in cases like this one, to
1394     // increase the likelihood of the full refund coming into effect.
1395     uint256 private constant _NOT_ENTERED = 1;
1396     uint256 private constant _ENTERED = 2;
1397 
1398     uint256 private _status;
1399 
1400     constructor() {
1401         _status = _NOT_ENTERED;
1402     }
1403 
1404     /**
1405      * @dev Prevents a contract from calling itself, directly or indirectly.
1406      * Calling a `nonReentrant` function from another `nonReentrant`
1407      * function is not supported. It is possible to prevent this from happening
1408      * by making the `nonReentrant` function external, and making it call a
1409      * `private` function that does the actual work.
1410      */
1411     modifier nonReentrant() {
1412         // On the first call to nonReentrant, _notEntered will be true
1413         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1414 
1415         // Any calls to nonReentrant after this point will fail
1416         _status = _ENTERED;
1417 
1418         _;
1419 
1420         // By storing the original value once again, a refund is triggered (see
1421         // https://eips.ethereum.org/EIPS/eip-2200)
1422         _status = _NOT_ENTERED;
1423     }
1424 }
1425 
1426 // File: contracts/CompanionInABox.sol
1427 
1428 
1429 
1430 pragma solidity ^0.8.10;
1431 
1432 
1433 
1434 
1435 
1436 
1437 
1438 
1439 contract CompanionInABox is
1440     ERC721Enumerable,
1441     IERC2981,
1442     ReentrancyGuard,
1443     Ownable
1444 {
1445     using Counters for Counters.Counter;
1446 
1447     constructor(
1448         string memory customBaseURI_,
1449         address accessTokenAddress_,
1450         address presaleWallet_
1451     ) ERC721("CompanionInABox", "CBOX") {
1452         customBaseURI = customBaseURI_;
1453         accessTokenAddress = accessTokenAddress_;
1454 
1455         // Allocation for giveaways, promotions, and other activities
1456         for (uint256 i = 0; i < 25; i++) {
1457             _safeMint(_msgSender(), totalSupply());
1458         }
1459 
1460         // Pre-sold tokens
1461         for (uint256 i = 0; i < 120; i++) {
1462             _safeMint(presaleWallet_, totalSupply());
1463         }
1464     }
1465 
1466     /** MINTING **/
1467 
1468     address public immutable accessTokenAddress;
1469 
1470     uint256 public constant MAX_SUPPLY = 8888;
1471 
1472     uint256 public constant MAX_MULTIMINT = 8;
1473 
1474     uint256 public constant PRICE = 80000000000000000;
1475 
1476     function mint(uint256 count) public payable nonReentrant {
1477         require(saleIsActive, "Sale not active");
1478 
1479         require(totalSupply() + count - 1 < MAX_SUPPLY, "Exceeds max supply");
1480 
1481         require(count <= MAX_MULTIMINT, "Mint at most 8 at a time");
1482 
1483         require(
1484             msg.value >= PRICE * count,
1485             "Insufficient payment, 0.08 ETH per item"
1486         );
1487 
1488         ERC721 accessToken = ERC721(accessTokenAddress);
1489 
1490         for (uint256 i = 0; i < count; i++) {
1491             if (accessTokenIsActive) {
1492                 require(
1493                     accessToken.balanceOf(_msgSender()) > 0,
1494                     "Access token not owned"
1495                 );
1496             }
1497 
1498             _safeMint(_msgSender(), totalSupply());
1499         }
1500     }
1501 
1502     /** ACTIVATION **/
1503 
1504     bool public saleIsActive = false;
1505 
1506     function setSaleIsActive(bool saleIsActive_) external onlyOwner {
1507         saleIsActive = saleIsActive_;
1508     }
1509 
1510     bool public accessTokenIsActive = true;
1511 
1512     function setAccessTokenIsActive(bool accessTokenIsActive_)
1513         external
1514         onlyOwner
1515     {
1516         accessTokenIsActive = accessTokenIsActive_;
1517     }
1518 
1519     /** URI HANDLING **/
1520 
1521     string private customBaseURI;
1522 
1523     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1524         customBaseURI = customBaseURI_;
1525     }
1526 
1527     function _baseURI() internal view virtual override returns (string memory) {
1528         return customBaseURI;
1529     }
1530 
1531     /** PAYOUT **/
1532 
1533     function withdraw() public nonReentrant {
1534         uint256 balance = address(this).balance;
1535 
1536         Address.sendValue(payable(owner()), balance);
1537     }
1538 
1539     /** ROYALTIES **/
1540 
1541     function royaltyInfo(uint256, uint256 salePrice)
1542         external
1543         view
1544         override
1545         returns (address receiver, uint256 royaltyAmount)
1546     {
1547         return (address(this), (salePrice * 1000) / 10000);
1548     }
1549 
1550     function supportsInterface(bytes4 interfaceId)
1551         public
1552         view
1553         virtual
1554         override(ERC721Enumerable, IERC165)
1555         returns (bool)
1556     {
1557         return (interfaceId == type(IERC2981).interfaceId ||
1558             super.supportsInterface(interfaceId));
1559     }
1560 }