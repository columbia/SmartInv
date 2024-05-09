1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-26
3 */
4 
5 // File: @openzeppelin/contracts/utils/Strings.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev String operations.
14  */
15 library Strings {
16     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Context.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/access/Ownable.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 
110 /**
111  * @dev Contract module which provides a basic access control mechanism, where
112  * there is an account (an owner) that can be granted exclusive access to
113  * specific functions.
114  *
115  * By default, the owner account will be the one that deploys the contract. This
116  * can later be changed with {transferOwnership}.
117  *
118  * This module is used through inheritance. It will make available the modifier
119  * `onlyOwner`, which can be applied to your functions to restrict their use to
120  * the owner.
121  */
122 abstract contract Ownable is Context {
123     address private _owner;
124 
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Returns the address of the current owner.
136      */
137     function owner() public view virtual returns (address) {
138         return _owner;
139     }
140 
141     /**
142      * @dev Throws if called by any account other than the owner.
143      */
144     modifier onlyOwner() {
145         require(owner() == _msgSender(), "Ownable: caller is not the owner");
146         _;
147     }
148 
149     /**
150      * @dev Leaves the contract without owner. It will not be possible to call
151      * `onlyOwner` functions anymore. Can only be called by the current owner.
152      *
153      * NOTE: Renouncing ownership will leave the contract without an owner,
154      * thereby removing any functionality that is only available to the owner.
155      */
156     function renounceOwnership() public virtual onlyOwner {
157         _transferOwnership(address(0));
158     }
159 
160     /**
161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
162      * Can only be called by the current owner.
163      */
164     function transferOwnership(address newOwner) public virtual onlyOwner {
165         require(newOwner != address(0), "Ownable: new owner is the zero address");
166         _transferOwnership(newOwner);
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Internal function without access restriction.
172      */
173     function _transferOwnership(address newOwner) internal virtual {
174         address oldOwner = _owner;
175         _owner = newOwner;
176         emit OwnershipTransferred(oldOwner, newOwner);
177     }
178 }
179 
180 // File: @openzeppelin/contracts/utils/Address.sol
181 
182 
183 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
184 
185 pragma solidity ^0.8.1;
186 
187 /**
188  * @dev Collection of functions related to the address type
189  */
190 library Address {
191     /**
192      * @dev Returns true if `account` is a contract.
193      *
194      * [IMPORTANT]
195      * ====
196      * It is unsafe to assume that an address for which this function returns
197      * false is an externally-owned account (EOA) and not a contract.
198      *
199      * Among others, `isContract` will return false for the following
200      * types of addresses:
201      *
202      *  - an externally-owned account
203      *  - a contract in construction
204      *  - an address where a contract will be created
205      *  - an address where a contract lived, but was destroyed
206      * ====
207      *
208      * [IMPORTANT]
209      * ====
210      * You shouldn't rely on `isContract` to protect against flash loan attacks!
211      *
212      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
213      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
214      * constructor.
215      * ====
216      */
217     function isContract(address account) internal view returns (bool) {
218         // This method relies on extcodesize/address.code.length, which returns 0
219         // for contracts in construction, since the code is only stored at the end
220         // of the constructor execution.
221 
222         return account.code.length > 0;
223     }
224 
225     /**
226      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
227      * `recipient`, forwarding all available gas and reverting on errors.
228      *
229      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
230      * of certain opcodes, possibly making contracts go over the 2300 gas limit
231      * imposed by `transfer`, making them unable to receive funds via
232      * `transfer`. {sendValue} removes this limitation.
233      *
234      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
235      *
236      * IMPORTANT: because control is transferred to `recipient`, care must be
237      * taken to not create reentrancy vulnerabilities. Consider using
238      * {ReentrancyGuard} or the
239      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
240      */
241     function sendValue(address payable recipient, uint256 amount) internal {
242         require(address(this).balance >= amount, "Address: insufficient balance");
243 
244         (bool success, ) = recipient.call{value: amount}("");
245         require(success, "Address: unable to send value, recipient may have reverted");
246     }
247 
248     /**
249      * @dev Performs a Solidity function call using a low level `call`. A
250      * plain `call` is an unsafe replacement for a function call: use this
251      * function instead.
252      *
253      * If `target` reverts with a revert reason, it is bubbled up by this
254      * function (like regular Solidity function calls).
255      *
256      * Returns the raw returned data. To convert to the expected return value,
257      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
258      *
259      * Requirements:
260      *
261      * - `target` must be a contract.
262      * - calling `target` with `data` must not revert.
263      *
264      * _Available since v3.1._
265      */
266     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
267         return functionCall(target, data, "Address: low-level call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
272      * `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCall(
277         address target,
278         bytes memory data,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         return functionCallWithValue(target, data, 0, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but also transferring `value` wei to `target`.
287      *
288      * Requirements:
289      *
290      * - the calling contract must have an ETH balance of at least `value`.
291      * - the called Solidity function must be `payable`.
292      *
293      * _Available since v3.1._
294      */
295     function functionCallWithValue(
296         address target,
297         bytes memory data,
298         uint256 value
299     ) internal returns (bytes memory) {
300         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
305      * with `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCallWithValue(
310         address target,
311         bytes memory data,
312         uint256 value,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(address(this).balance >= value, "Address: insufficient balance for call");
316         require(isContract(target), "Address: call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.call{value: value}(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a static call.
325      *
326      * _Available since v3.3._
327      */
328     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
329         return functionStaticCall(target, data, "Address: low-level static call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a static call.
335      *
336      * _Available since v3.3._
337      */
338     function functionStaticCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal view returns (bytes memory) {
343         require(isContract(target), "Address: static call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.staticcall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but performing a delegate call.
352      *
353      * _Available since v3.4._
354      */
355     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
356         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
361      * but performing a delegate call.
362      *
363      * _Available since v3.4._
364      */
365     function functionDelegateCall(
366         address target,
367         bytes memory data,
368         string memory errorMessage
369     ) internal returns (bytes memory) {
370         require(isContract(target), "Address: delegate call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.delegatecall(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
378      * revert reason using the provided one.
379      *
380      * _Available since v4.3._
381      */
382     function verifyCallResult(
383         bool success,
384         bytes memory returndata,
385         string memory errorMessage
386     ) internal pure returns (bytes memory) {
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
406 
407 
408 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @title ERC721 token receiver interface
414  * @dev Interface for any contract that wants to support safeTransfers
415  * from ERC721 asset contracts.
416  */
417 interface IERC721Receiver {
418     /**
419      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
420      * by `operator` from `from`, this function is called.
421      *
422      * It must return its Solidity selector to confirm the token transfer.
423      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
424      *
425      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
426      */
427     function onERC721Received(
428         address operator,
429         address from,
430         uint256 tokenId,
431         bytes calldata data
432     ) external returns (bytes4);
433 }
434 
435 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Interface of the ERC165 standard, as defined in the
444  * https://eips.ethereum.org/EIPS/eip-165[EIP].
445  *
446  * Implementers can declare support of contract interfaces, which can then be
447  * queried by others ({ERC165Checker}).
448  *
449  * For an implementation, see {ERC165}.
450  */
451 interface IERC165 {
452     /**
453      * @dev Returns true if this contract implements the interface defined by
454      * `interfaceId`. See the corresponding
455      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
456      * to learn more about how these ids are created.
457      *
458      * This function call must use less than 30 000 gas.
459      */
460     function supportsInterface(bytes4 interfaceId) external view returns (bool);
461 }
462 
463 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 
471 /**
472  * @dev Implementation of the {IERC165} interface.
473  *
474  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
475  * for the additional interface id that will be supported. For example:
476  *
477  * ```solidity
478  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
479  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
480  * }
481  * ```
482  *
483  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
484  */
485 abstract contract ERC165 is IERC165 {
486     /**
487      * @dev See {IERC165-supportsInterface}.
488      */
489     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490         return interfaceId == type(IERC165).interfaceId;
491     }
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
495 
496 
497 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 
502 /**
503  * @dev Required interface of an ERC721 compliant contract.
504  */
505 interface IERC721 is IERC165 {
506     /**
507      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
508      */
509     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
510 
511     /**
512      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
513      */
514     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
515 
516     /**
517      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
518      */
519     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
520 
521     /**
522      * @dev Returns the number of tokens in ``owner``'s account.
523      */
524     function balanceOf(address owner) external view returns (uint256 balance);
525 
526     /**
527      * @dev Returns the owner of the `tokenId` token.
528      *
529      * Requirements:
530      *
531      * - `tokenId` must exist.
532      */
533     function ownerOf(uint256 tokenId) external view returns (address owner);
534 
535     /**
536      * @dev Safely transfers `tokenId` token from `from` to `to`.
537      *
538      * Requirements:
539      *
540      * - `from` cannot be the zero address.
541      * - `to` cannot be the zero address.
542      * - `tokenId` token must exist and be owned by `from`.
543      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
544      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
545      *
546      * Emits a {Transfer} event.
547      */
548     function safeTransferFrom(
549         address from,
550         address to,
551         uint256 tokenId,
552         bytes calldata data
553     ) external;
554 
555     /**
556      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
557      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
558      *
559      * Requirements:
560      *
561      * - `from` cannot be the zero address.
562      * - `to` cannot be the zero address.
563      * - `tokenId` token must exist and be owned by `from`.
564      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
565      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
566      *
567      * Emits a {Transfer} event.
568      */
569     function safeTransferFrom(
570         address from,
571         address to,
572         uint256 tokenId
573     ) external;
574 
575     /**
576      * @dev Transfers `tokenId` token from `from` to `to`.
577      *
578      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must be owned by `from`.
585      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
586      *
587      * Emits a {Transfer} event.
588      */
589     function transferFrom(
590         address from,
591         address to,
592         uint256 tokenId
593     ) external;
594 
595     /**
596      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
597      * The approval is cleared when the token is transferred.
598      *
599      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
600      *
601      * Requirements:
602      *
603      * - The caller must own the token or be an approved operator.
604      * - `tokenId` must exist.
605      *
606      * Emits an {Approval} event.
607      */
608     function approve(address to, uint256 tokenId) external;
609 
610     /**
611      * @dev Approve or remove `operator` as an operator for the caller.
612      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
613      *
614      * Requirements:
615      *
616      * - The `operator` cannot be the caller.
617      *
618      * Emits an {ApprovalForAll} event.
619      */
620     function setApprovalForAll(address operator, bool _approved) external;
621 
622     /**
623      * @dev Returns the account approved for `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function getApproved(uint256 tokenId) external view returns (address operator);
630 
631     /**
632      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
633      *
634      * See {setApprovalForAll}
635      */
636     function isApprovedForAll(address owner, address operator) external view returns (bool);
637 }
638 
639 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
640 
641 
642 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
643 
644 pragma solidity ^0.8.0;
645 
646 
647 /**
648  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
649  * @dev See https://eips.ethereum.org/EIPS/eip-721
650  */
651 interface IERC721Metadata is IERC721 {
652     /**
653      * @dev Returns the token collection name.
654      */
655     function name() external view returns (string memory);
656 
657     /**
658      * @dev Returns the token collection symbol.
659      */
660     function symbol() external view returns (string memory);
661 
662     /**
663      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
664      */
665     function tokenURI(uint256 tokenId) external view returns (string memory);
666 }
667 
668 // File: erc721a/contracts/IERC721A.sol
669 
670 
671 // ERC721A Contracts v3.3.0
672 // Creator: Chiru Labs
673 
674 pragma solidity ^0.8.4;
675 
676 
677 
678 /**
679  * @dev Interface of an ERC721A compliant contract.
680  */
681 interface IERC721A is IERC721, IERC721Metadata {
682     /**
683      * The caller must own the token or be an approved operator.
684      */
685     error ApprovalCallerNotOwnerNorApproved();
686 
687     /**
688      * The token does not exist.
689      */
690     error ApprovalQueryForNonexistentToken();
691 
692     /**
693      * The caller cannot approve to their own address.
694      */
695     error ApproveToCaller();
696 
697     /**
698      * The caller cannot approve to the current owner.
699      */
700     error ApprovalToCurrentOwner();
701 
702     /**
703      * Cannot query the balance for the zero address.
704      */
705     error BalanceQueryForZeroAddress();
706 
707     /**
708      * Cannot mint to the zero address.
709      */
710     error MintToZeroAddress();
711 
712     /**
713      * The quantity of tokens minted must be more than zero.
714      */
715     error MintZeroQuantity();
716 
717     /**
718      * The token does not exist.
719      */
720     error OwnerQueryForNonexistentToken();
721 
722     /**
723      * The caller must own the token or be an approved operator.
724      */
725     error TransferCallerNotOwnerNorApproved();
726 
727     /**
728      * The token must be owned by `from`.
729      */
730     error TransferFromIncorrectOwner();
731 
732     /**
733      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
734      */
735     error TransferToNonERC721ReceiverImplementer();
736 
737     /**
738      * Cannot transfer to the zero address.
739      */
740     error TransferToZeroAddress();
741 
742     /**
743      * The token does not exist.
744      */
745     error URIQueryForNonexistentToken();
746 
747     // Compiler will pack this into a single 256bit word.
748     struct TokenOwnership {
749         // The address of the owner.
750         address addr;
751         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
752         uint64 startTimestamp;
753         // Whether the token has been burned.
754         bool burned;
755     }
756 
757     // Compiler will pack this into a single 256bit word.
758     struct AddressData {
759         // Realistically, 2**64-1 is more than enough.
760         uint64 balance;
761         // Keeps track of mint count with minimal overhead for tokenomics.
762         uint64 numberMinted;
763         // Keeps track of burn count with minimal overhead for tokenomics.
764         uint64 numberBurned;
765         // For miscellaneous variable(s) pertaining to the address
766         // (e.g. number of whitelist mint slots used).
767         // If there are multiple variables, please pack them into a uint64.
768         uint64 aux;
769     }
770 
771     /**
772      * @dev Returns the total amount of tokens stored by the contract.
773      * 
774      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
775      */
776     function totalSupply() external view returns (uint256);
777 }
778 
779 // File: erc721a/contracts/ERC721A.sol
780 
781 
782 // ERC721A Contracts v3.3.0
783 // Creator: Chiru Labs
784 
785 pragma solidity ^0.8.4;
786 
787 
788 
789 
790 
791 
792 
793 /**
794  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
795  * the Metadata extension. Built to optimize for lower gas during batch mints.
796  *
797  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
798  *
799  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
800  *
801  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
802  */
803 contract ERC721A is Context, ERC165, IERC721A {
804     using Address for address;
805     using Strings for uint256;
806 
807     // The tokenId of the next token to be minted.
808     uint256 internal _currentIndex;
809 
810     // The number of tokens burned.
811     uint256 internal _burnCounter;
812 
813     // Token name
814     string private _name;
815 
816     // Token symbol
817     string private _symbol;
818 
819     // Mapping from token ID to ownership details
820     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
821     mapping(uint256 => TokenOwnership) internal _ownerships;
822 
823     // Mapping owner address to address data
824     mapping(address => AddressData) private _addressData;
825 
826     // Mapping from token ID to approved address
827     mapping(uint256 => address) private _tokenApprovals;
828 
829     // Mapping from owner to operator approvals
830     mapping(address => mapping(address => bool)) private _operatorApprovals;
831 
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835         _currentIndex = _startTokenId();
836     }
837 
838     /**
839      * To change the starting tokenId, please override this function.
840      */
841     function _startTokenId() internal view virtual returns (uint256) {
842         return 0;
843     }
844 
845     /**
846      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
847      */
848     function totalSupply() public view override returns (uint256) {
849         // Counter underflow is impossible as _burnCounter cannot be incremented
850         // more than _currentIndex - _startTokenId() times
851         unchecked {
852             return _currentIndex - _burnCounter - _startTokenId();
853         }
854     }
855 
856     /**
857      * Returns the total amount of tokens minted in the contract.
858      */
859     function _totalMinted() internal view returns (uint256) {
860         // Counter underflow is impossible as _currentIndex does not decrement,
861         // and it is initialized to _startTokenId()
862         unchecked {
863             return _currentIndex - _startTokenId();
864         }
865     }
866 
867     /**
868      * @dev See {IERC165-supportsInterface}.
869      */
870     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
871         return
872             interfaceId == type(IERC721).interfaceId ||
873             interfaceId == type(IERC721Metadata).interfaceId ||
874             super.supportsInterface(interfaceId);
875     }
876 
877     /**
878      * @dev See {IERC721-balanceOf}.
879      */
880     function balanceOf(address owner) public view override returns (uint256) {
881         if (owner == address(0)) revert BalanceQueryForZeroAddress();
882         return uint256(_addressData[owner].balance);
883     }
884 
885     /**
886      * Returns the number of tokens minted by `owner`.
887      */
888     function _numberMinted(address owner) internal view returns (uint256) {
889         return uint256(_addressData[owner].numberMinted);
890     }
891 
892     /**
893      * Returns the number of tokens burned by or on behalf of `owner`.
894      */
895     function _numberBurned(address owner) internal view returns (uint256) {
896         return uint256(_addressData[owner].numberBurned);
897     }
898 
899     /**
900      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
901      */
902     function _getAux(address owner) internal view returns (uint64) {
903         return _addressData[owner].aux;
904     }
905 
906     /**
907      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
908      * If there are multiple variables, please pack them into a uint64.
909      */
910     function _setAux(address owner, uint64 aux) internal {
911         _addressData[owner].aux = aux;
912     }
913 
914     /**
915      * Gas spent here starts off proportional to the maximum mint batch size.
916      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
917      */
918     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
919         uint256 curr = tokenId;
920 
921         unchecked {
922             if (_startTokenId() <= curr) if (curr < _currentIndex) {
923                 TokenOwnership memory ownership = _ownerships[curr];
924                 if (!ownership.burned) {
925                     if (ownership.addr != address(0)) {
926                         return ownership;
927                     }
928                     // Invariant:
929                     // There will always be an ownership that has an address and is not burned
930                     // before an ownership that does not have an address and is not burned.
931                     // Hence, curr will not underflow.
932                     while (true) {
933                         curr--;
934                         ownership = _ownerships[curr];
935                         if (ownership.addr != address(0)) {
936                             return ownership;
937                         }
938                     }
939                 }
940             }
941         }
942         revert OwnerQueryForNonexistentToken();
943     }
944 
945     /**
946      * @dev See {IERC721-ownerOf}.
947      */
948     function ownerOf(uint256 tokenId) public view override returns (address) {
949         return _ownershipOf(tokenId).addr;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-name}.
954      */
955     function name() public view virtual override returns (string memory) {
956         return _name;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-symbol}.
961      */
962     function symbol() public view virtual override returns (string memory) {
963         return _symbol;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-tokenURI}.
968      */
969     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
970         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
971 
972         string memory baseURI = _baseURI();
973         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
974     }
975 
976     /**
977      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
978      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
979      * by default, can be overriden in child contracts.
980      */
981     function _baseURI() internal view virtual returns (string memory) {
982         return '';
983     }
984 
985     /**
986      * @dev See {IERC721-approve}.
987      */
988     function approve(address to, uint256 tokenId) public override {
989         address owner = ERC721A.ownerOf(tokenId);
990         if (to == owner) revert ApprovalToCurrentOwner();
991 
992         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
993             revert ApprovalCallerNotOwnerNorApproved();
994         }
995 
996         _approve(to, tokenId, owner);
997     }
998 
999     /**
1000      * @dev See {IERC721-getApproved}.
1001      */
1002     function getApproved(uint256 tokenId) public view override returns (address) {
1003         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1004 
1005         return _tokenApprovals[tokenId];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-setApprovalForAll}.
1010      */
1011     function setApprovalForAll(address operator, bool approved) public virtual override {
1012         if (operator == _msgSender()) revert ApproveToCaller();
1013 
1014         _operatorApprovals[_msgSender()][operator] = approved;
1015         emit ApprovalForAll(_msgSender(), operator, approved);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-isApprovedForAll}.
1020      */
1021     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1022         return _operatorApprovals[owner][operator];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-transferFrom}.
1027      */
1028     function transferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         _transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         safeTransferFrom(from, to, tokenId, '');
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId,
1054         bytes memory _data
1055     ) public virtual override {
1056         _transfer(from, to, tokenId);
1057         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1058             revert TransferToNonERC721ReceiverImplementer();
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns whether `tokenId` exists.
1064      *
1065      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1066      *
1067      * Tokens start existing when they are minted (`_mint`),
1068      */
1069     function _exists(uint256 tokenId) internal view returns (bool) {
1070         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1071     }
1072 
1073     /**
1074      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1075      */
1076     function _safeMint(address to, uint256 quantity) internal {
1077         _safeMint(to, quantity, '');
1078     }
1079 
1080     /**
1081      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1082      *
1083      * Requirements:
1084      *
1085      * - If `to` refers to a smart contract, it must implement
1086      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _safeMint(
1092         address to,
1093         uint256 quantity,
1094         bytes memory _data
1095     ) internal {
1096         uint256 startTokenId = _currentIndex;
1097         if (to == address(0)) revert MintToZeroAddress();
1098         if (quantity == 0) revert MintZeroQuantity();
1099 
1100         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1101 
1102         // Overflows are incredibly unrealistic.
1103         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1104         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1105         unchecked {
1106             _addressData[to].balance += uint64(quantity);
1107             _addressData[to].numberMinted += uint64(quantity);
1108 
1109             _ownerships[startTokenId].addr = to;
1110             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1111 
1112             uint256 updatedIndex = startTokenId;
1113             uint256 end = updatedIndex + quantity;
1114 
1115             if (to.isContract()) {
1116                 do {
1117                     emit Transfer(address(0), to, updatedIndex);
1118                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1119                         revert TransferToNonERC721ReceiverImplementer();
1120                     }
1121                 } while (updatedIndex < end);
1122                 // Reentrancy protection
1123                 if (_currentIndex != startTokenId) revert();
1124             } else {
1125                 do {
1126                     emit Transfer(address(0), to, updatedIndex++);
1127                 } while (updatedIndex < end);
1128             }
1129             _currentIndex = updatedIndex;
1130         }
1131         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1132     }
1133 
1134     /**
1135      * @dev Mints `quantity` tokens and transfers them to `to`.
1136      *
1137      * Requirements:
1138      *
1139      * - `to` cannot be the zero address.
1140      * - `quantity` must be greater than 0.
1141      *
1142      * Emits a {Transfer} event.
1143      */
1144     function _mint(address to, uint256 quantity) internal {
1145         uint256 startTokenId = _currentIndex;
1146         if (to == address(0)) revert MintToZeroAddress();
1147         if (quantity == 0) revert MintZeroQuantity();
1148 
1149         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1150 
1151         // Overflows are incredibly unrealistic.
1152         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1153         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1154         unchecked {
1155             _addressData[to].balance += uint64(quantity);
1156             _addressData[to].numberMinted += uint64(quantity);
1157 
1158             _ownerships[startTokenId].addr = to;
1159             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1160 
1161             uint256 updatedIndex = startTokenId;
1162             uint256 end = updatedIndex + quantity;
1163 
1164             do {
1165                 emit Transfer(address(0), to, updatedIndex++);
1166             } while (updatedIndex < end);
1167 
1168             _currentIndex = updatedIndex;
1169         }
1170         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _transfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) private {
1188         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1189 
1190         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1191 
1192         bool isApprovedOrOwner = (_msgSender() == from ||
1193             isApprovedForAll(from, _msgSender()) ||
1194             getApproved(tokenId) == _msgSender());
1195 
1196         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1197         if (to == address(0)) revert TransferToZeroAddress();
1198 
1199         _beforeTokenTransfers(from, to, tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, from);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             _addressData[from].balance -= 1;
1209             _addressData[to].balance += 1;
1210 
1211             TokenOwnership storage currSlot = _ownerships[tokenId];
1212             currSlot.addr = to;
1213             currSlot.startTimestamp = uint64(block.timestamp);
1214 
1215             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1216             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1217             uint256 nextTokenId = tokenId + 1;
1218             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1219             if (nextSlot.addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId != _currentIndex) {
1223                     nextSlot.addr = from;
1224                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(from, to, tokenId);
1230         _afterTokenTransfers(from, to, tokenId, 1);
1231     }
1232 
1233     /**
1234      * @dev Equivalent to `_burn(tokenId, false)`.
1235      */
1236     function _burn(uint256 tokenId) internal virtual {
1237         _burn(tokenId, false);
1238     }
1239 
1240     /**
1241      * @dev Destroys `tokenId`.
1242      * The approval is cleared when the token is burned.
1243      *
1244      * Requirements:
1245      *
1246      * - `tokenId` must exist.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1251         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1252 
1253         address from = prevOwnership.addr;
1254 
1255         if (approvalCheck) {
1256             bool isApprovedOrOwner = (_msgSender() == from ||
1257                 isApprovedForAll(from, _msgSender()) ||
1258                 getApproved(tokenId) == _msgSender());
1259 
1260             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1261         }
1262 
1263         _beforeTokenTransfers(from, address(0), tokenId, 1);
1264 
1265         // Clear approvals from the previous owner
1266         _approve(address(0), tokenId, from);
1267 
1268         // Underflow of the sender's balance is impossible because we check for
1269         // ownership above and the recipient's balance can't realistically overflow.
1270         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1271         unchecked {
1272             AddressData storage addressData = _addressData[from];
1273             addressData.balance -= 1;
1274             addressData.numberBurned += 1;
1275 
1276             // Keep track of who burned the token, and the timestamp of burning.
1277             TokenOwnership storage currSlot = _ownerships[tokenId];
1278             currSlot.addr = from;
1279             currSlot.startTimestamp = uint64(block.timestamp);
1280             currSlot.burned = true;
1281 
1282             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1283             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1284             uint256 nextTokenId = tokenId + 1;
1285             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1286             if (nextSlot.addr == address(0)) {
1287                 // This will suffice for checking _exists(nextTokenId),
1288                 // as a burned slot cannot contain the zero address.
1289                 if (nextTokenId != _currentIndex) {
1290                     nextSlot.addr = from;
1291                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1292                 }
1293             }
1294         }
1295 
1296         emit Transfer(from, address(0), tokenId);
1297         _afterTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1300         unchecked {
1301             _burnCounter++;
1302         }
1303     }
1304 
1305     /**
1306      * @dev Approve `to` to operate on `tokenId`
1307      *
1308      * Emits a {Approval} event.
1309      */
1310     function _approve(
1311         address to,
1312         uint256 tokenId,
1313         address owner
1314     ) private {
1315         _tokenApprovals[tokenId] = to;
1316         emit Approval(owner, to, tokenId);
1317     }
1318 
1319     /**
1320      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1321      *
1322      * @param from address representing the previous owner of the given token ID
1323      * @param to target address that will receive the tokens
1324      * @param tokenId uint256 ID of the token to be transferred
1325      * @param _data bytes optional data to send along with the call
1326      * @return bool whether the call correctly returned the expected magic value
1327      */
1328     function _checkContractOnERC721Received(
1329         address from,
1330         address to,
1331         uint256 tokenId,
1332         bytes memory _data
1333     ) private returns (bool) {
1334         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1335             return retval == IERC721Receiver(to).onERC721Received.selector;
1336         } catch (bytes memory reason) {
1337             if (reason.length == 0) {
1338                 revert TransferToNonERC721ReceiverImplementer();
1339             } else {
1340                 assembly {
1341                     revert(add(32, reason), mload(reason))
1342                 }
1343             }
1344         }
1345     }
1346 
1347     /**
1348      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1349      * And also called before burning one token.
1350      *
1351      * startTokenId - the first token id to be transferred
1352      * quantity - the amount to be transferred
1353      *
1354      * Calling conditions:
1355      *
1356      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1357      * transferred to `to`.
1358      * - When `from` is zero, `tokenId` will be minted for `to`.
1359      * - When `to` is zero, `tokenId` will be burned by `from`.
1360      * - `from` and `to` are never both zero.
1361      */
1362     function _beforeTokenTransfers(
1363         address from,
1364         address to,
1365         uint256 startTokenId,
1366         uint256 quantity
1367     ) internal virtual {}
1368 
1369     /**
1370      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1371      * minting.
1372      * And also called after one token has been burned.
1373      *
1374      * startTokenId - the first token id to be transferred
1375      * quantity - the amount to be transferred
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` has been minted for `to`.
1382      * - When `to` is zero, `tokenId` has been burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _afterTokenTransfers(
1386         address from,
1387         address to,
1388         uint256 startTokenId,
1389         uint256 quantity
1390     ) internal virtual {}
1391 }
1392 
1393 // File: contracts/slothopia/staking/TokenContract.sol
1394 
1395 
1396 pragma solidity >=0.8.0 <0.9.0;
1397 
1398 abstract contract TokenContract {
1399     function mint(address to, uint256 amount) external virtual;
1400 }
1401 // File: contracts/slothopia/staking/Staker.sol
1402 
1403 
1404 
1405 pragma solidity >=0.8.0 <0.9.0;
1406 
1407 
1408 
1409 
1410 
1411 contract SlothStaker is Ownable, IERC721Receiver {
1412 
1413   uint256 public totalStaked;
1414   uint256 perdayreward;
1415   
1416   struct Stake {
1417     uint24 tokenId;
1418     uint48 timestamp;
1419     address owner;
1420   }
1421 
1422   event NFTStaked(address owner, uint256 tokenId, uint256 value);
1423   event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
1424   event Claimed(address owner, uint256 amount);
1425 
1426   ERC721A nft;
1427   TokenContract token;
1428 
1429   mapping(uint256 => Stake) public vault; 
1430 
1431    constructor(address _nft, address _token) { 
1432     nft = ERC721A(_nft);
1433     token = TokenContract(_token);
1434     perdayreward = 500 ether; // 5 $SLEEP A DAY
1435   }
1436 
1437   function stake(uint256[] calldata tokenIds) external {
1438     uint256 tokenId;
1439     totalStaked += tokenIds.length;
1440     for (uint i = 0; i < tokenIds.length; i++) {
1441       tokenId = tokenIds[i];
1442       require(nft.ownerOf(tokenId) == msg.sender, "not your token");
1443       require(vault[tokenId].tokenId == 0, 'already staked');
1444 
1445       nft.transferFrom(msg.sender, address(this), tokenId);
1446       emit NFTStaked(msg.sender, tokenId, block.timestamp);
1447 
1448       vault[tokenId] = Stake({
1449         owner: msg.sender,
1450         tokenId: uint24(tokenId),
1451         timestamp: uint48(block.timestamp)
1452       });
1453     }
1454   }
1455 
1456   function _unstakeMany(address account, uint256[] calldata tokenIds) internal {
1457     uint256 tokenId;
1458     totalStaked -= tokenIds.length;
1459     for (uint i = 0; i < tokenIds.length; i++) {
1460       tokenId = tokenIds[i];
1461       Stake memory staked = vault[tokenId];
1462       require(staked.owner == msg.sender, "not an owner");
1463 
1464       delete vault[tokenId];
1465       emit NFTUnstaked(account, tokenId, block.timestamp);
1466       nft.transferFrom(address(this), account, tokenId);
1467     }
1468   }
1469 
1470   function claim(uint256[] calldata tokenIds) external {
1471       _claim(msg.sender, tokenIds, false);
1472   }
1473 
1474   function claimForAddress(address account, uint256[] calldata tokenIds) external {
1475       _claim(account, tokenIds, false);
1476   }
1477 
1478   function unstake(uint256[] calldata tokenIds) external {
1479       _claim(msg.sender, tokenIds, true);
1480   }
1481 
1482   function _claim(address account, uint256[] calldata tokenIds, bool _unstake) internal {
1483     uint256 tokenId;
1484     uint256 earned = 0;
1485     uint256 rewardmath = 0;
1486 
1487     for (uint i = 0; i < tokenIds.length; i++) {
1488       tokenId = tokenIds[i];
1489       Stake memory staked = vault[tokenId];
1490       require(staked.owner == account, "not an owner");
1491       uint256 stakedAt = staked.timestamp;
1492       rewardmath = perdayreward * (block.timestamp - stakedAt) / 86400 ;
1493       earned = rewardmath / 100;
1494       vault[tokenId] = Stake({
1495         owner: account,
1496         tokenId: uint24(tokenId),
1497         timestamp: uint48(block.timestamp)
1498       });
1499     }
1500     if (earned > 0) {
1501       token.mint(account, earned);
1502     }
1503     if (_unstake) {
1504       _unstakeMany(account, tokenIds);
1505     }
1506     emit Claimed(account, earned);
1507   }
1508 
1509   function earningInfo(address account, uint256[] calldata tokenIds) external view returns (uint256[1] memory info) {
1510      uint256 tokenId;
1511      uint256 earned = 0;
1512      uint256 rewardmath = 0;
1513 
1514     for (uint i = 0; i < tokenIds.length; i++) {
1515       tokenId = tokenIds[i];
1516       Stake memory staked = vault[tokenId];
1517       require(staked.owner == account, "not an owner");
1518       uint256 stakedAt = staked.timestamp;
1519       rewardmath = perdayreward * (block.timestamp - stakedAt) / 86400;
1520       earned = rewardmath / 100;
1521 
1522     }
1523     if (earned > 0) {
1524       return [earned];
1525     }
1526 }
1527 
1528   function balanceOf(address account) public view returns (uint256) {
1529     uint256 balance = 0;
1530     uint256 supply = nft.totalSupply();
1531     for(uint i = 1; i <= supply; i++) {
1532       if (vault[i].owner == account) {
1533         balance += 1;
1534       }
1535     }
1536     return balance;
1537   }
1538 
1539   function tokensOfOwner(address account) public view returns (uint256[] memory ownerTokens) {
1540 
1541     uint256 supply = nft.totalSupply();
1542     uint256[] memory tmp = new uint256[](supply);
1543 
1544     uint256 index = 0;
1545     for(uint tokenId = 1; tokenId <= supply; tokenId++) {
1546       if (vault[tokenId].owner == account) {
1547         tmp[index] = vault[tokenId].tokenId;
1548         index +=1;
1549       }
1550     }
1551 
1552     uint256[] memory tokens = new uint256[](index);
1553     for(uint i = 0; i < index; i++) {
1554       tokens[i] = tmp[i];
1555     }
1556 
1557     return tokens;
1558   }
1559 
1560   function setPerDayReward(uint256 newReward) external onlyOwner {
1561     perdayreward = newReward;
1562   }
1563 
1564   function onERC721Received(
1565         address,
1566         address from,
1567         uint256,
1568         bytes calldata
1569     ) external pure override returns (bytes4) {
1570       require(from == address(0x0), "Cannot send nfts to Vault directly");
1571       return IERC721Receiver.onERC721Received.selector;
1572     }
1573   
1574 }