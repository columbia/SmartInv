1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-27
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
11 
12 pragma solidity 0.8.10;
13 
14 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 /**
37  * @dev Interface of the ERC165 standard, as defined in the
38  * https://eips.ethereum.org/EIPS/eip-165[EIP].
39  *
40  * Implementers can declare support of contract interfaces, which can then be
41  * queried by others ({ERC165Checker}).
42  *
43  * For an implementation, see {ERC165}.
44  */
45 interface IERC165 {
46     /**
47      * @dev Returns true if this contract implements the interface defined by
48      * `interfaceId`. See the corresponding
49      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
50      * to learn more about how these ids are created.
51      *
52      * This function call must use less than 30 000 gas.
53      */
54     function supportsInterface(bytes4 interfaceId) external view returns (bool);
55 }
56 
57 
58 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
59 
60 /**
61  * @dev Required interface of an ERC721 compliant contract.
62  */
63 interface IERC721 is IERC165 {
64     /**
65      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
71      */
72     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
73 
74     /**
75      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
76      */
77     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
78 
79     /**
80      * @dev Returns the number of tokens in ``owner``'s account.
81      */
82     function balanceOf(address owner) external view returns (uint256 balance);
83 
84     /**
85      * @dev Returns the owner of the `tokenId` token.
86      *
87      * Requirements:
88      *
89      * - `tokenId` must exist.
90      */
91     function ownerOf(uint256 tokenId) external view returns (address owner);
92 
93     /**
94      * @dev Safely transfers `tokenId` token from `from` to `to`.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must exist and be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
103      *
104      * Emits a {Transfer} event.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 tokenId,
110         bytes calldata data
111     ) external;
112 
113     /**
114      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
115      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
116      *
117      * Requirements:
118      *
119      * - `from` cannot be the zero address.
120      * - `to` cannot be the zero address.
121      * - `tokenId` token must exist and be owned by `from`.
122      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
123      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
124      *
125      * Emits a {Transfer} event.
126      */
127     function safeTransferFrom(
128         address from,
129         address to,
130         uint256 tokenId
131     ) external;
132 
133     /**
134      * @dev Transfers `tokenId` token from `from` to `to`.
135      *
136      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
137      *
138      * Requirements:
139      *
140      * - `from` cannot be the zero address.
141      * - `to` cannot be the zero address.
142      * - `tokenId` token must be owned by `from`.
143      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transferFrom(
148         address from,
149         address to,
150         uint256 tokenId
151     ) external;
152 
153     /**
154      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
155      * The approval is cleared when the token is transferred.
156      *
157      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
158      *
159      * Requirements:
160      *
161      * - The caller must own the token or be an approved operator.
162      * - `tokenId` must exist.
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address to, uint256 tokenId) external;
167 
168     /**
169      * @dev Approve or remove `operator` as an operator for the caller.
170      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
171      *
172      * Requirements:
173      *
174      * - The `operator` cannot be the caller.
175      *
176      * Emits an {ApprovalForAll} event.
177      */
178     function setApprovalForAll(address operator, bool _approved) external;
179 
180     /**
181      * @dev Returns the account approved for `tokenId` token.
182      *
183      * Requirements:
184      *
185      * - `tokenId` must exist.
186      */
187     function getApproved(uint256 tokenId) external view returns (address operator);
188 
189     /**
190      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
191      *
192      * See {setApprovalForAll}
193      */
194     function isApprovedForAll(address owner, address operator) external view returns (bool);
195 }
196 
197 
198 /**
199  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
200  * @dev See https://eips.ethereum.org/EIPS/eip-721
201  */
202 interface IERC721Metadata is IERC721 {
203     /**
204      * @dev Returns the token collection name.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the token collection symbol.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
215      */
216     function tokenURI(uint256 tokenId) external view returns (string memory);
217 }
218 
219 
220 // ERC721A Contracts v3.3.0
221 // Creator: Chiru Labs
222 
223 /**
224  * @dev Interface of an ERC721A compliant contract.
225  */
226 interface IERC721A is IERC721, IERC721Metadata {
227     /**
228      * The caller must own the token or be an approved operator.
229      */
230     error ApprovalCallerNotOwnerNorApproved();
231 
232     /**
233      * The token does not exist.
234      */
235     error ApprovalQueryForNonexistentToken();
236 
237     /**
238      * The caller cannot approve to their own address.
239      */
240     error ApproveToCaller();
241 
242     /**
243      * The caller cannot approve to the current owner.
244      */
245     error ApprovalToCurrentOwner();
246 
247     /**
248      * Cannot query the balance for the zero address.
249      */
250     error BalanceQueryForZeroAddress();
251 
252     /**
253      * Cannot mint to the zero address.
254      */
255     error MintToZeroAddress();
256 
257     /**
258      * The quantity of tokens minted must be more than zero.
259      */
260     error MintZeroQuantity();
261 
262     /**
263      * The token does not exist.
264      */
265     error OwnerQueryForNonexistentToken();
266 
267     /**
268      * The caller must own the token or be an approved operator.
269      */
270     error TransferCallerNotOwnerNorApproved();
271 
272     /**
273      * The token must be owned by `from`.
274      */
275     error TransferFromIncorrectOwner();
276 
277     /**
278      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
279      */
280     error TransferToNonERC721ReceiverImplementer();
281 
282     /**
283      * Cannot transfer to the zero address.
284      */
285     error TransferToZeroAddress();
286 
287     /**
288      * The token does not exist.
289      */
290     error URIQueryForNonexistentToken();
291 
292     // Compiler will pack this into a single 256bit word.
293     struct TokenOwnership {
294         // The address of the owner.
295         address addr;
296         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
297         uint64 startTimestamp;
298         // Whether the token has been burned.
299         bool burned;
300     }
301 
302     // Compiler will pack this into a single 256bit word.
303     struct AddressData {
304         // Realistically, 2**64-1 is more than enough.
305         uint64 balance;
306         // Keeps track of mint count with minimal overhead for tokenomics.
307         uint64 numberMinted;
308         // Keeps track of burn count with minimal overhead for tokenomics.
309         uint64 numberBurned;
310         // For miscellaneous variable(s) pertaining to the address
311         // (e.g. number of whitelist mint slots used).
312         // If there are multiple variables, please pack them into a uint64.
313         uint64 aux;
314     }
315 
316     /**
317      * @dev Returns the total amount of tokens stored by the contract.
318      * 
319      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
320      */
321     function totalSupply() external view returns (uint256);
322 }
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
326 
327 /**
328  * @dev Implementation of the {IERC165} interface.
329  *
330  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
331  * for the additional interface id that will be supported. For example:
332  *
333  * ```solidity
334  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
336  * }
337  * ```
338  *
339  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
340  */
341 abstract contract ERC165 is IERC165 {
342     /**
343      * @dev See {IERC165-supportsInterface}.
344      */
345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346         return interfaceId == type(IERC165).interfaceId;
347     }
348 }
349 
350 
351 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
352 
353 /**
354  * @dev Contract module which provides a basic access control mechanism, where
355  * there is an account (an owner) that can be granted exclusive access to
356  * specific functions.
357  *
358  * By default, the owner account will be the one that deploys the contract. This
359  * can later be changed with {transferOwnership}.
360  *
361  * This module is used through inheritance. It will make available the modifier
362  * `onlyOwner`, which can be applied to your functions to restrict their use to
363  * the owner.
364  */
365 abstract contract Ownable is Context {
366     address private _owner;
367 
368     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
369 
370     /**
371      * @dev Initializes the contract setting the deployer as the initial owner.
372      */
373     constructor() {
374         _transferOwnership(_msgSender());
375     }
376 
377     /**
378      * @dev Returns the address of the current owner.
379      */
380     function owner() public view virtual returns (address) {
381         return _owner;
382     }
383 
384     /**
385      * @dev Throws if called by any account other than the owner.
386      */
387     modifier onlyOwner() {
388         require(owner() == _msgSender(), "Ownable: caller is not the owner");
389         _;
390     }
391 
392     /**
393      * @dev Leaves the contract without owner. It will not be possible to call
394      * `onlyOwner` functions anymore. Can only be called by the current owner.
395      *
396      * NOTE: Renouncing ownership will leave the contract without an owner,
397      * thereby removing any functionality that is only available to the owner.
398      */
399     function renounceOwnership() public virtual onlyOwner {
400         _transferOwnership(address(0));
401     }
402 
403     /**
404      * @dev Transfers ownership of the contract to a new account (`newOwner`).
405      * Can only be called by the current owner.
406      */
407     function transferOwnership(address newOwner) public virtual onlyOwner {
408         require(newOwner != address(0), "Ownable: new owner is the zero address");
409         _transferOwnership(newOwner);
410     }
411 
412     /**
413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
414      * Internal function without access restriction.
415      */
416     function _transferOwnership(address newOwner) internal virtual {
417         address oldOwner = _owner;
418         _owner = newOwner;
419         emit OwnershipTransferred(oldOwner, newOwner);
420     }
421 }
422 
423 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
424 
425 /**
426  * @dev Collection of functions related to the address type
427  */
428 library Address {
429     /**
430      * @dev Returns true if `account` is a contract.
431      *
432      * [IMPORTANT]
433      * ====
434      * It is unsafe to assume that an address for which this function returns
435      * false is an externally-owned account (EOA) and not a contract.
436      *
437      * Among others, `isContract` will return false for the following
438      * types of addresses:
439      *
440      *  - an externally-owned account
441      *  - a contract in construction
442      *  - an address where a contract will be created
443      *  - an address where a contract lived, but was destroyed
444      * ====
445      *
446      * [IMPORTANT]
447      * ====
448      * You shouldn't rely on `isContract` to protect against flash loan attacks!
449      *
450      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
451      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
452      * constructor.
453      * ====
454      */
455     function isContract(address account) internal view returns (bool) {
456         // This method relies on extcodesize/address.code.length, which returns 0
457         // for contracts in construction, since the code is only stored at the end
458         // of the constructor execution.
459 
460         return account.code.length > 0;
461     }
462 
463     /**
464      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
465      * `recipient`, forwarding all available gas and reverting on errors.
466      *
467      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
468      * of certain opcodes, possibly making contracts go over the 2300 gas limit
469      * imposed by `transfer`, making them unable to receive funds via
470      * `transfer`. {sendValue} removes this limitation.
471      *
472      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
473      *
474      * IMPORTANT: because control is transferred to `recipient`, care must be
475      * taken to not create reentrancy vulnerabilities. Consider using
476      * {ReentrancyGuard} or the
477      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
478      */
479     function sendValue(address payable recipient, uint256 amount) internal {
480         require(address(this).balance >= amount, "Address: insufficient balance");
481 
482         (bool success, ) = recipient.call{value: amount}("");
483         require(success, "Address: unable to send value, recipient may have reverted");
484     }
485 
486     /**
487      * @dev Performs a Solidity function call using a low level `call`. A
488      * plain `call` is an unsafe replacement for a function call: use this
489      * function instead.
490      *
491      * If `target` reverts with a revert reason, it is bubbled up by this
492      * function (like regular Solidity function calls).
493      *
494      * Returns the raw returned data. To convert to the expected return value,
495      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
496      *
497      * Requirements:
498      *
499      * - `target` must be a contract.
500      * - calling `target` with `data` must not revert.
501      *
502      * _Available since v3.1._
503      */
504     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
505         return functionCall(target, data, "Address: low-level call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
510      * `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         return functionCallWithValue(target, data, 0, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but also transferring `value` wei to `target`.
525      *
526      * Requirements:
527      *
528      * - the calling contract must have an ETH balance of at least `value`.
529      * - the called Solidity function must be `payable`.
530      *
531      * _Available since v3.1._
532      */
533     function functionCallWithValue(
534         address target,
535         bytes memory data,
536         uint256 value
537     ) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
543      * with `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(
548         address target,
549         bytes memory data,
550         uint256 value,
551         string memory errorMessage
552     ) internal returns (bytes memory) {
553         require(address(this).balance >= value, "Address: insufficient balance for call");
554         require(isContract(target), "Address: call to non-contract");
555 
556         (bool success, bytes memory returndata) = target.call{value: value}(data);
557         return verifyCallResult(success, returndata, errorMessage);
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
562      * but performing a static call.
563      *
564      * _Available since v3.3._
565      */
566     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
567         return functionStaticCall(target, data, "Address: low-level static call failed");
568     }
569 
570     /**
571      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
572      * but performing a static call.
573      *
574      * _Available since v3.3._
575      */
576     function functionStaticCall(
577         address target,
578         bytes memory data,
579         string memory errorMessage
580     ) internal view returns (bytes memory) {
581         require(isContract(target), "Address: static call to non-contract");
582 
583         (bool success, bytes memory returndata) = target.staticcall(data);
584         return verifyCallResult(success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a delegate call.
590      *
591      * _Available since v3.4._
592      */
593     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
594         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a delegate call.
600      *
601      * _Available since v3.4._
602      */
603     function functionDelegateCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         require(isContract(target), "Address: delegate call to non-contract");
609 
610         (bool success, bytes memory returndata) = target.delegatecall(data);
611         return verifyCallResult(success, returndata, errorMessage);
612     }
613 
614     /**
615      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
616      * revert reason using the provided one.
617      *
618      * _Available since v4.3._
619      */
620     function verifyCallResult(
621         bool success,
622         bytes memory returndata,
623         string memory errorMessage
624     ) internal pure returns (bytes memory) {
625         if (success) {
626             return returndata;
627         } else {
628             // Look for revert reason and bubble it up if present
629             if (returndata.length > 0) {
630                 // The easiest way to bubble the revert reason is using memory via assembly
631 
632                 assembly {
633                     let returndata_size := mload(returndata)
634                     revert(add(32, returndata), returndata_size)
635                 }
636             } else {
637                 revert(errorMessage);
638             }
639         }
640     }
641 }
642 
643 
644 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
645 
646 /**
647  * @dev String operations.
648  */
649 library Strings {
650     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
651 
652     /**
653      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
654      */
655     function toString(uint256 value) internal pure returns (string memory) {
656         // Inspired by OraclizeAPI's implementation - MIT licence
657         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
658 
659         if (value == 0) {
660             return "0";
661         }
662         uint256 temp = value;
663         uint256 digits;
664         while (temp != 0) {
665             digits++;
666             temp /= 10;
667         }
668         bytes memory buffer = new bytes(digits);
669         while (value != 0) {
670             digits -= 1;
671             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
672             value /= 10;
673         }
674         return string(buffer);
675     }
676 
677     /**
678      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
679      */
680     function toHexString(uint256 value) internal pure returns (string memory) {
681         if (value == 0) {
682             return "0x00";
683         }
684         uint256 temp = value;
685         uint256 length = 0;
686         while (temp != 0) {
687             length++;
688             temp >>= 8;
689         }
690         return toHexString(value, length);
691     }
692 
693     /**
694      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
695      */
696     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
697         bytes memory buffer = new bytes(2 * length + 2);
698         buffer[0] = "0";
699         buffer[1] = "x";
700         for (uint256 i = 2 * length + 1; i > 1; --i) {
701             buffer[i] = _HEX_SYMBOLS[value & 0xf];
702             value >>= 4;
703         }
704         require(value == 0, "Strings: hex length insufficient");
705         return string(buffer);
706     }
707 }
708 
709 
710 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
711 
712 /**
713  * @title ERC721 token receiver interface
714  * @dev Interface for any contract that wants to support safeTransfers
715  * from ERC721 asset contracts.
716  */
717 interface IERC721Receiver {
718     /**
719      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
720      * by `operator` from `from`, this function is called.
721      *
722      * It must return its Solidity selector to confirm the token transfer.
723      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
724      *
725      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
726      */
727     function onERC721Received(
728         address operator,
729         address from,
730         uint256 tokenId,
731         bytes calldata data
732     ) external returns (bytes4);
733 }
734 
735 
736 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
737 
738 /**
739  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
740  * the Metadata extension, but not including the Enumerable extension, which is available separately as
741  * {ERC721Enumerable}.
742  */
743 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
744     using Address for address;
745     using Strings for uint256;
746 
747     // Token name
748     string private _name;
749 
750     // Token symbol
751     string private _symbol;
752 
753     // Mapping from token ID to owner address
754     mapping(uint256 => address) private _owners;
755 
756     // Mapping owner address to token count
757     mapping(address => uint256) private _balances;
758 
759     // Mapping from token ID to approved address
760     mapping(uint256 => address) private _tokenApprovals;
761 
762     // Mapping from owner to operator approvals
763     mapping(address => mapping(address => bool)) private _operatorApprovals;
764 
765     /**
766      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
767      */
768     constructor(string memory name_, string memory symbol_) {
769         _name = name_;
770         _symbol = symbol_;
771     }
772 
773     /**
774      * @dev See {IERC165-supportsInterface}.
775      */
776     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
777         return
778             interfaceId == type(IERC721).interfaceId ||
779             interfaceId == type(IERC721Metadata).interfaceId ||
780             super.supportsInterface(interfaceId);
781     }
782 
783     /**
784      * @dev See {IERC721-balanceOf}.
785      */
786     function balanceOf(address owner) public view virtual override returns (uint256) {
787         require(owner != address(0), "ERC721: balance query for the zero address");
788         return _balances[owner];
789     }
790 
791     /**
792      * @dev See {IERC721-ownerOf}.
793      */
794     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
795         address owner = _owners[tokenId];
796         require(owner != address(0), "ERC721: owner query for nonexistent token");
797         return owner;
798     }
799 
800     /**
801      * @dev See {IERC721Metadata-name}.
802      */
803     function name() public view virtual override returns (string memory) {
804         return _name;
805     }
806 
807     /**
808      * @dev See {IERC721Metadata-symbol}.
809      */
810     function symbol() public view virtual override returns (string memory) {
811         return _symbol;
812     }
813 
814     /**
815      * @dev See {IERC721Metadata-tokenURI}.
816      */
817     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
818         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
819 
820         string memory baseURI = _baseURI();
821         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
822     }
823 
824     /**
825      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
826      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
827      * by default, can be overridden in child contracts.
828      */
829     function _baseURI() internal view virtual returns (string memory) {
830         return "";
831     }
832 
833     /**
834      * @dev See {IERC721-approve}.
835      */
836     function approve(address to, uint256 tokenId) public virtual override {
837         address owner = ERC721.ownerOf(tokenId);
838         require(to != owner, "ERC721: approval to current owner");
839 
840         require(
841             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
842             "ERC721: approve caller is not owner nor approved for all"
843         );
844 
845         _approve(to, tokenId);
846     }
847 
848     /**
849      * @dev See {IERC721-getApproved}.
850      */
851     function getApproved(uint256 tokenId) public view virtual override returns (address) {
852         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
853 
854         return _tokenApprovals[tokenId];
855     }
856 
857     /**
858      * @dev See {IERC721-setApprovalForAll}.
859      */
860     function setApprovalForAll(address operator, bool approved) public virtual override {
861         _setApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     /**
865      * @dev See {IERC721-isApprovedForAll}.
866      */
867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
868         return _operatorApprovals[owner][operator];
869     }
870 
871     /**
872      * @dev See {IERC721-transferFrom}.
873      */
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         //solhint-disable-next-line max-line-length
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
881 
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
892     ) public virtual override {
893         safeTransferFrom(from, to, tokenId, "");
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) public virtual override {
905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
906         _safeTransfer(from, to, tokenId, _data);
907     }
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
911      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
912      *
913      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
914      *
915      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
916      * implement alternative mechanisms to perform token transfer, such as signature-based.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeTransfer(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _transfer(from, to, tokenId);
934         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      * and stop existing when they are burned (`_burn`).
944      */
945     function _exists(uint256 tokenId) internal view virtual returns (bool) {
946         return _owners[tokenId] != address(0);
947     }
948 
949     /**
950      * @dev Returns whether `spender` is allowed to manage `tokenId`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      */
956     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
957         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
958         address owner = ERC721.ownerOf(tokenId);
959         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
960     }
961 
962     /**
963      * @dev Safely mints `tokenId` and transfers it to `to`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must not exist.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeMint(address to, uint256 tokenId) internal virtual {
973         _safeMint(to, tokenId, "");
974     }
975 
976     /**
977      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
978      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
979      */
980     function _safeMint(
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) internal virtual {
985         _mint(to, tokenId);
986         require(
987             _checkOnERC721Received(address(0), to, tokenId, _data),
988             "ERC721: transfer to non ERC721Receiver implementer"
989         );
990     }
991 
992     /**
993      * @dev Mints `tokenId` and transfers it to `to`.
994      *
995      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
996      *
997      * Requirements:
998      *
999      * - `tokenId` must not exist.
1000      * - `to` cannot be the zero address.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _mint(address to, uint256 tokenId) internal virtual {
1005         require(to != address(0), "ERC721: mint to the zero address");
1006         require(!_exists(tokenId), "ERC721: token already minted");
1007 
1008         _beforeTokenTransfer(address(0), to, tokenId);
1009 
1010         _balances[to] += 1;
1011         _owners[tokenId] = to;
1012 
1013         emit Transfer(address(0), to, tokenId);
1014 
1015         _afterTokenTransfer(address(0), to, tokenId);
1016     }
1017 
1018     /**
1019      * @dev Destroys `tokenId`.
1020      * The approval is cleared when the token is burned.
1021      *
1022      * Requirements:
1023      *
1024      * - `tokenId` must exist.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _burn(uint256 tokenId) internal virtual {
1029         address owner = ERC721.ownerOf(tokenId);
1030 
1031         _beforeTokenTransfer(owner, address(0), tokenId);
1032 
1033         // Clear approvals
1034         _approve(address(0), tokenId);
1035 
1036         _balances[owner] -= 1;
1037         delete _owners[tokenId];
1038 
1039         emit Transfer(owner, address(0), tokenId);
1040 
1041         _afterTokenTransfer(owner, address(0), tokenId);
1042     }
1043 
1044     /**
1045      * @dev Transfers `tokenId` from `from` to `to`.
1046      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1047      *
1048      * Requirements:
1049      *
1050      * - `to` cannot be the zero address.
1051      * - `tokenId` token must be owned by `from`.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) internal virtual {
1060         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1061         require(to != address(0), "ERC721: transfer to the zero address");
1062 
1063         _beforeTokenTransfer(from, to, tokenId);
1064 
1065         // Clear approvals from the previous owner
1066         _approve(address(0), tokenId);
1067 
1068         _balances[from] -= 1;
1069         _balances[to] += 1;
1070         _owners[tokenId] = to;
1071 
1072         emit Transfer(from, to, tokenId);
1073 
1074         _afterTokenTransfer(from, to, tokenId);
1075     }
1076 
1077     /**
1078      * @dev Approve `to` to operate on `tokenId`
1079      *
1080      * Emits a {Approval} event.
1081      */
1082     function _approve(address to, uint256 tokenId) internal virtual {
1083         _tokenApprovals[tokenId] = to;
1084         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev Approve `operator` to operate on all of `owner` tokens
1089      *
1090      * Emits a {ApprovalForAll} event.
1091      */
1092     function _setApprovalForAll(
1093         address owner,
1094         address operator,
1095         bool approved
1096     ) internal virtual {
1097         require(owner != operator, "ERC721: approve to caller");
1098         _operatorApprovals[owner][operator] = approved;
1099         emit ApprovalForAll(owner, operator, approved);
1100     }
1101 
1102     /**
1103      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1104      * The call is not executed if the target address is not a contract.
1105      *
1106      * @param from address representing the previous owner of the given token ID
1107      * @param to target address that will receive the tokens
1108      * @param tokenId uint256 ID of the token to be transferred
1109      * @param _data bytes optional data to send along with the call
1110      * @return bool whether the call correctly returned the expected magic value
1111      */
1112     function _checkOnERC721Received(
1113         address from,
1114         address to,
1115         uint256 tokenId,
1116         bytes memory _data
1117     ) private returns (bool) {
1118         if (to.isContract()) {
1119             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1120                 return retval == IERC721Receiver.onERC721Received.selector;
1121             } catch (bytes memory reason) {
1122                 if (reason.length == 0) {
1123                     revert("ERC721: transfer to non ERC721Receiver implementer");
1124                 } else {
1125                     assembly {
1126                         revert(add(32, reason), mload(reason))
1127                     }
1128                 }
1129             }
1130         } else {
1131             return true;
1132         }
1133     }
1134 
1135     /**
1136      * @dev Hook that is called before any token transfer. This includes minting
1137      * and burning.
1138      *
1139      * Calling conditions:
1140      *
1141      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1142      * transferred to `to`.
1143      * - When `from` is zero, `tokenId` will be minted for `to`.
1144      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1145      * - `from` and `to` are never both zero.
1146      *
1147      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1148      */
1149     function _beforeTokenTransfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) internal virtual {}
1154 
1155     /**
1156      * @dev Hook that is called after any transfer of tokens. This includes
1157      * minting and burning.
1158      *
1159      * Calling conditions:
1160      *
1161      * - when `from` and `to` are both non-zero.
1162      * - `from` and `to` are never both zero.
1163      *
1164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1165      */
1166     function _afterTokenTransfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) internal virtual {}
1171 }
1172 
1173 
1174 // ERC721A Contracts v3.3.0
1175 // Creator: Chiru Labs
1176 
1177 /**
1178  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1179  * the Metadata extension. Built to optimize for lower gas during batch mints.
1180  *
1181  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1182  *
1183  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1184  *
1185  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1186  */
1187 contract ERC721A is Context, ERC165, IERC721A {
1188     using Address for address;
1189     using Strings for uint256;
1190 
1191     // The tokenId of the next token to be minted.
1192     uint256 internal _currentIndex;
1193 
1194     // The number of tokens burned.
1195     uint256 internal _burnCounter;
1196 
1197     // Token name
1198     string private _name;
1199 
1200     // Token symbol
1201     string private _symbol;
1202 
1203     // Mapping from token ID to ownership details
1204     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1205     mapping(uint256 => TokenOwnership) internal _ownerships;
1206 
1207     // Mapping owner address to address data
1208     mapping(address => AddressData) private _addressData;
1209 
1210     // Mapping from token ID to approved address
1211     mapping(uint256 => address) private _tokenApprovals;
1212 
1213     // Mapping from owner to operator approvals
1214     mapping(address => mapping(address => bool)) private _operatorApprovals;
1215 
1216     constructor(string memory name_, string memory symbol_) {
1217         _name = name_;
1218         _symbol = symbol_;
1219         _currentIndex = _startTokenId();
1220     }
1221 
1222     /**
1223      * To change the starting tokenId, please override this function.
1224      */
1225     function _startTokenId() internal view virtual returns (uint256) {
1226         return 0;
1227     }
1228 
1229     /**
1230      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1231      */
1232     function totalSupply() public view override returns (uint256) {
1233         // Counter underflow is impossible as _burnCounter cannot be incremented
1234         // more than _currentIndex - _startTokenId() times
1235         unchecked {
1236             return _currentIndex - _burnCounter - _startTokenId();
1237         }
1238     }
1239 
1240     /**
1241      * Returns the total amount of tokens minted in the contract.
1242      */
1243     function _totalMinted() internal view returns (uint256) {
1244         // Counter underflow is impossible as _currentIndex does not decrement,
1245         // and it is initialized to _startTokenId()
1246         unchecked {
1247             return _currentIndex - _startTokenId();
1248         }
1249     }
1250 
1251     /**
1252      * @dev See {IERC165-supportsInterface}.
1253      */
1254     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1255         return
1256             interfaceId == type(IERC721).interfaceId ||
1257             interfaceId == type(IERC721Metadata).interfaceId ||
1258             super.supportsInterface(interfaceId);
1259     }
1260 
1261     /**
1262      * @dev See {IERC721-balanceOf}.
1263      */
1264     function balanceOf(address owner) public view override returns (uint256) {
1265         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1266         return uint256(_addressData[owner].balance);
1267     }
1268 
1269     /**
1270      * Returns the number of tokens minted by `owner`.
1271      */
1272     function _numberMinted(address owner) internal view returns (uint256) {
1273         return uint256(_addressData[owner].numberMinted);
1274     }
1275 
1276     /**
1277      * Returns the number of tokens burned by or on behalf of `owner`.
1278      */
1279     function _numberBurned(address owner) internal view returns (uint256) {
1280         return uint256(_addressData[owner].numberBurned);
1281     }
1282 
1283     /**
1284      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1285      */
1286     function _getAux(address owner) internal view returns (uint64) {
1287         return _addressData[owner].aux;
1288     }
1289 
1290     /**
1291      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1292      * If there are multiple variables, please pack them into a uint64.
1293      */
1294     function _setAux(address owner, uint64 aux) internal {
1295         _addressData[owner].aux = aux;
1296     }
1297 
1298     /**
1299      * Gas spent here starts off proportional to the maximum mint batch size.
1300      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1301      */
1302     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1303         uint256 curr = tokenId;
1304 
1305         unchecked {
1306             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1307                 TokenOwnership memory ownership = _ownerships[curr];
1308                 if (!ownership.burned) {
1309                     if (ownership.addr != address(0)) {
1310                         return ownership;
1311                     }
1312                     // Invariant:
1313                     // There will always be an ownership that has an address and is not burned
1314                     // before an ownership that does not have an address and is not burned.
1315                     // Hence, curr will not underflow.
1316                     while (true) {
1317                         curr--;
1318                         ownership = _ownerships[curr];
1319                         if (ownership.addr != address(0)) {
1320                             return ownership;
1321                         }
1322                     }
1323                 }
1324             }
1325         }
1326         revert OwnerQueryForNonexistentToken();
1327     }
1328 
1329     /**
1330      * @dev See {IERC721-ownerOf}.
1331      */
1332     function ownerOf(uint256 tokenId) public view override returns (address) {
1333         return _ownershipOf(tokenId).addr;
1334     }
1335 
1336     /**
1337      * @dev See {IERC721Metadata-name}.
1338      */
1339     function name() public view virtual override returns (string memory) {
1340         return _name;
1341     }
1342 
1343     /**
1344      * @dev See {IERC721Metadata-symbol}.
1345      */
1346     function symbol() public view virtual override returns (string memory) {
1347         return _symbol;
1348     }
1349 
1350     /**
1351      * @dev See {IERC721Metadata-tokenURI}.
1352      */
1353     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1354         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1355 
1356         string memory baseURI = _baseURI();
1357         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1358     }
1359 
1360     /**
1361      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1362      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1363      * by default, can be overriden in child contracts.
1364      */
1365     function _baseURI() internal view virtual returns (string memory) {
1366         return '';
1367     }
1368 
1369     /**
1370      * @dev See {IERC721-approve}.
1371      */
1372     function approve(address to, uint256 tokenId) public override {
1373         address owner = ERC721A.ownerOf(tokenId);
1374         if (to == owner) revert ApprovalToCurrentOwner();
1375 
1376         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1377             revert ApprovalCallerNotOwnerNorApproved();
1378         }
1379 
1380         _approve(to, tokenId, owner);
1381     }
1382 
1383     /**
1384      * @dev See {IERC721-getApproved}.
1385      */
1386     function getApproved(uint256 tokenId) public view override returns (address) {
1387         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1388 
1389         return _tokenApprovals[tokenId];
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-setApprovalForAll}.
1394      */
1395     function setApprovalForAll(address operator, bool approved) public virtual override {
1396         if (operator == _msgSender()) revert ApproveToCaller();
1397 
1398         _operatorApprovals[_msgSender()][operator] = approved;
1399         emit ApprovalForAll(_msgSender(), operator, approved);
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-isApprovedForAll}.
1404      */
1405     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1406         return _operatorApprovals[owner][operator];
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-transferFrom}.
1411      */
1412     function transferFrom(
1413         address from,
1414         address to,
1415         uint256 tokenId
1416     ) public virtual override {
1417         _transfer(from, to, tokenId);
1418     }
1419 
1420     /**
1421      * @dev See {IERC721-safeTransferFrom}.
1422      */
1423     function safeTransferFrom(
1424         address from,
1425         address to,
1426         uint256 tokenId
1427     ) public virtual override {
1428         safeTransferFrom(from, to, tokenId, '');
1429     }
1430 
1431     /**
1432      * @dev See {IERC721-safeTransferFrom}.
1433      */
1434     function safeTransferFrom(
1435         address from,
1436         address to,
1437         uint256 tokenId,
1438         bytes memory _data
1439     ) public virtual override {
1440         _transfer(from, to, tokenId);
1441         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1442             revert TransferToNonERC721ReceiverImplementer();
1443         }
1444     }
1445 
1446     /**
1447      * @dev Returns whether `tokenId` exists.
1448      *
1449      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1450      *
1451      * Tokens start existing when they are minted (`_mint`),
1452      */
1453     function _exists(uint256 tokenId) internal view returns (bool) {
1454         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1455     }
1456 
1457     /**
1458      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1459      */
1460     function _safeMint(address to, uint256 quantity) internal {
1461         _safeMint(to, quantity, '');
1462     }
1463 
1464     /**
1465      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1466      *
1467      * Requirements:
1468      *
1469      * - If `to` refers to a smart contract, it must implement
1470      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1471      * - `quantity` must be greater than 0.
1472      *
1473      * Emits a {Transfer} event.
1474      */
1475     function _safeMint(
1476         address to,
1477         uint256 quantity,
1478         bytes memory _data
1479     ) internal {
1480         uint256 startTokenId = _currentIndex;
1481         if (to == address(0)) revert MintToZeroAddress();
1482         if (quantity == 0) revert MintZeroQuantity();
1483 
1484         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1485 
1486         // Overflows are incredibly unrealistic.
1487         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1488         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1489         unchecked {
1490             _addressData[to].balance += uint64(quantity);
1491             _addressData[to].numberMinted += uint64(quantity);
1492 
1493             _ownerships[startTokenId].addr = to;
1494             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1495 
1496             uint256 updatedIndex = startTokenId;
1497             uint256 end = updatedIndex + quantity;
1498 
1499             if (to.isContract()) {
1500                 do {
1501                     emit Transfer(address(0), to, updatedIndex);
1502                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1503                         revert TransferToNonERC721ReceiverImplementer();
1504                     }
1505                 } while (updatedIndex < end);
1506                 // Reentrancy protection
1507                 if (_currentIndex != startTokenId) revert();
1508             } else {
1509                 do {
1510                     emit Transfer(address(0), to, updatedIndex++);
1511                 } while (updatedIndex < end);
1512             }
1513             _currentIndex = updatedIndex;
1514         }
1515         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1516     }
1517 
1518     /**
1519      * @dev Mints `quantity` tokens and transfers them to `to`.
1520      *
1521      * Requirements:
1522      *
1523      * - `to` cannot be the zero address.
1524      * - `quantity` must be greater than 0.
1525      *
1526      * Emits a {Transfer} event.
1527      */
1528     function _mint(address to, uint256 quantity) internal {
1529         uint256 startTokenId = _currentIndex;
1530         if (to == address(0)) revert MintToZeroAddress();
1531         if (quantity == 0) revert MintZeroQuantity();
1532 
1533         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1534 
1535         // Overflows are incredibly unrealistic.
1536         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1537         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1538         unchecked {
1539             _addressData[to].balance += uint64(quantity);
1540             _addressData[to].numberMinted += uint64(quantity);
1541 
1542             _ownerships[startTokenId].addr = to;
1543             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1544 
1545             uint256 updatedIndex = startTokenId;
1546             uint256 end = updatedIndex + quantity;
1547 
1548             do {
1549                 emit Transfer(address(0), to, updatedIndex++);
1550             } while (updatedIndex < end);
1551 
1552             _currentIndex = updatedIndex;
1553         }
1554         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1555     }
1556 
1557     /**
1558      * @dev Transfers `tokenId` from `from` to `to`.
1559      *
1560      * Requirements:
1561      *
1562      * - `to` cannot be the zero address.
1563      * - `tokenId` token must be owned by `from`.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _transfer(
1568         address from,
1569         address to,
1570         uint256 tokenId
1571     ) private {
1572         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1573 
1574         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1575 
1576         bool isApprovedOrOwner = (_msgSender() == from ||
1577             isApprovedForAll(from, _msgSender()) ||
1578             getApproved(tokenId) == _msgSender());
1579 
1580         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1581         if (to == address(0)) revert TransferToZeroAddress();
1582 
1583         _beforeTokenTransfers(from, to, tokenId, 1);
1584 
1585         // Clear approvals from the previous owner
1586         _approve(address(0), tokenId, from);
1587 
1588         // Underflow of the sender's balance is impossible because we check for
1589         // ownership above and the recipient's balance can't realistically overflow.
1590         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1591         unchecked {
1592             _addressData[from].balance -= 1;
1593             _addressData[to].balance += 1;
1594 
1595             TokenOwnership storage currSlot = _ownerships[tokenId];
1596             currSlot.addr = to;
1597             currSlot.startTimestamp = uint64(block.timestamp);
1598 
1599             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1600             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1601             uint256 nextTokenId = tokenId + 1;
1602             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1603             if (nextSlot.addr == address(0)) {
1604                 // This will suffice for checking _exists(nextTokenId),
1605                 // as a burned slot cannot contain the zero address.
1606                 if (nextTokenId != _currentIndex) {
1607                     nextSlot.addr = from;
1608                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1609                 }
1610             }
1611         }
1612 
1613         emit Transfer(from, to, tokenId);
1614         _afterTokenTransfers(from, to, tokenId, 1);
1615     }
1616 
1617     /**
1618      * @dev Equivalent to `_burn(tokenId, false)`.
1619      */
1620     function _burn(uint256 tokenId) internal virtual {
1621         _burn(tokenId, false);
1622     }
1623 
1624     /**
1625      * @dev Destroys `tokenId`.
1626      * The approval is cleared when the token is burned.
1627      *
1628      * Requirements:
1629      *
1630      * - `tokenId` must exist.
1631      *
1632      * Emits a {Transfer} event.
1633      */
1634     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1635         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1636 
1637         address from = prevOwnership.addr;
1638 
1639         if (approvalCheck) {
1640             bool isApprovedOrOwner = (_msgSender() == from ||
1641                 isApprovedForAll(from, _msgSender()) ||
1642                 getApproved(tokenId) == _msgSender());
1643 
1644             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1645         }
1646 
1647         _beforeTokenTransfers(from, address(0), tokenId, 1);
1648 
1649         // Clear approvals from the previous owner
1650         _approve(address(0), tokenId, from);
1651 
1652         // Underflow of the sender's balance is impossible because we check for
1653         // ownership above and the recipient's balance can't realistically overflow.
1654         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1655         unchecked {
1656             AddressData storage addressData = _addressData[from];
1657             addressData.balance -= 1;
1658             addressData.numberBurned += 1;
1659 
1660             // Keep track of who burned the token, and the timestamp of burning.
1661             TokenOwnership storage currSlot = _ownerships[tokenId];
1662             currSlot.addr = from;
1663             currSlot.startTimestamp = uint64(block.timestamp);
1664             currSlot.burned = true;
1665 
1666             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1667             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1668             uint256 nextTokenId = tokenId + 1;
1669             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1670             if (nextSlot.addr == address(0)) {
1671                 // This will suffice for checking _exists(nextTokenId),
1672                 // as a burned slot cannot contain the zero address.
1673                 if (nextTokenId != _currentIndex) {
1674                     nextSlot.addr = from;
1675                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1676                 }
1677             }
1678         }
1679 
1680         emit Transfer(from, address(0), tokenId);
1681         _afterTokenTransfers(from, address(0), tokenId, 1);
1682 
1683         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1684         unchecked {
1685             _burnCounter++;
1686         }
1687     }
1688 
1689     /**
1690      * @dev Approve `to` to operate on `tokenId`
1691      *
1692      * Emits a {Approval} event.
1693      */
1694     function _approve(
1695         address to,
1696         uint256 tokenId,
1697         address owner
1698     ) private {
1699         _tokenApprovals[tokenId] = to;
1700         emit Approval(owner, to, tokenId);
1701     }
1702 
1703     /**
1704      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1705      *
1706      * @param from address representing the previous owner of the given token ID
1707      * @param to target address that will receive the tokens
1708      * @param tokenId uint256 ID of the token to be transferred
1709      * @param _data bytes optional data to send along with the call
1710      * @return bool whether the call correctly returned the expected magic value
1711      */
1712     function _checkContractOnERC721Received(
1713         address from,
1714         address to,
1715         uint256 tokenId,
1716         bytes memory _data
1717     ) private returns (bool) {
1718         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1719             return retval == IERC721Receiver(to).onERC721Received.selector;
1720         } catch (bytes memory reason) {
1721             if (reason.length == 0) {
1722                 revert TransferToNonERC721ReceiverImplementer();
1723             } else {
1724                 assembly {
1725                     revert(add(32, reason), mload(reason))
1726                 }
1727             }
1728         }
1729     }
1730 
1731     /**
1732      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1733      * And also called before burning one token.
1734      *
1735      * startTokenId - the first token id to be transferred
1736      * quantity - the amount to be transferred
1737      *
1738      * Calling conditions:
1739      *
1740      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1741      * transferred to `to`.
1742      * - When `from` is zero, `tokenId` will be minted for `to`.
1743      * - When `to` is zero, `tokenId` will be burned by `from`.
1744      * - `from` and `to` are never both zero.
1745      */
1746     function _beforeTokenTransfers(
1747         address from,
1748         address to,
1749         uint256 startTokenId,
1750         uint256 quantity
1751     ) internal virtual {}
1752 
1753     /**
1754      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1755      * minting.
1756      * And also called after one token has been burned.
1757      *
1758      * startTokenId - the first token id to be transferred
1759      * quantity - the amount to be transferred
1760      *
1761      * Calling conditions:
1762      *
1763      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1764      * transferred to `to`.
1765      * - When `from` is zero, `tokenId` has been minted for `to`.
1766      * - When `to` is zero, `tokenId` has been burned by `from`.
1767      * - `from` and `to` are never both zero.
1768      */
1769     function _afterTokenTransfers(
1770         address from,
1771         address to,
1772         uint256 startTokenId,
1773         uint256 quantity
1774     ) internal virtual {}
1775 }
1776 
1777 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1778 
1779 /**
1780  * @dev Interface for the NFT Royalty Standard.
1781  *
1782  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1783  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1784  *
1785  * _Available since v4.5._
1786  */
1787 interface IERC2981 is IERC165 {
1788     /**
1789      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1790      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1791      */
1792     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1793         external
1794         view
1795         returns (address receiver, uint256 royaltyAmount);
1796 }
1797 
1798 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
1799 
1800 /**
1801  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1802  *
1803  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1804  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1805  *
1806  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1807  * fee is specified in basis points by default.
1808  *
1809  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1810  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1811  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1812  *
1813  * _Available since v4.5._
1814  */
1815 abstract contract ERC2981 is IERC2981, ERC165 {
1816     struct RoyaltyInfo {
1817         address receiver;
1818         uint96 royaltyFraction;
1819     }
1820 
1821     RoyaltyInfo private _defaultRoyaltyInfo;
1822     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1823 
1824     /**
1825      * @dev See {IERC165-supportsInterface}.
1826      */
1827     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1828         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1829     }
1830 
1831     /**
1832      * @inheritdoc IERC2981
1833      */
1834     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1835         external
1836         view
1837         virtual
1838         override
1839         returns (address, uint256)
1840     {
1841         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1842 
1843         if (royalty.receiver == address(0)) {
1844             royalty = _defaultRoyaltyInfo;
1845         }
1846 
1847         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1848 
1849         return (royalty.receiver, royaltyAmount);
1850     }
1851 
1852     /**
1853      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1854      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1855      * override.
1856      */
1857     function _feeDenominator() internal pure virtual returns (uint96) {
1858         return 10000;
1859     }
1860 
1861     /**
1862      * @dev Sets the royalty information that all ids in this contract will default to.
1863      *
1864      * Requirements:
1865      *
1866      * - `receiver` cannot be the zero address.
1867      * - `feeNumerator` cannot be greater than the fee denominator.
1868      */
1869     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1870         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1871         require(receiver != address(0), "ERC2981: invalid receiver");
1872 
1873         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1874     }
1875 
1876     /**
1877      * @dev Removes default royalty information.
1878      */
1879     function _deleteDefaultRoyalty() internal virtual {
1880         delete _defaultRoyaltyInfo;
1881     }
1882 
1883     /**
1884      * @dev Sets the royalty information for a specific token id, overriding the global default.
1885      *
1886      * Requirements:
1887      *
1888      * - `tokenId` must be already minted.
1889      * - `receiver` cannot be the zero address.
1890      * - `feeNumerator` cannot be greater than the fee denominator.
1891      */
1892     function _setTokenRoyalty(
1893         uint256 tokenId,
1894         address receiver,
1895         uint96 feeNumerator
1896     ) internal virtual {
1897         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1898         require(receiver != address(0), "ERC2981: Invalid parameters");
1899 
1900         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1901     }
1902 
1903     /**
1904      * @dev Resets royalty information for the token id back to the global default.
1905      */
1906     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1907         delete _tokenRoyaltyInfo[tokenId];
1908     }
1909 }
1910 
1911 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1912 
1913 /**
1914  * @dev Contract module that helps prevent reentrant calls to a function.
1915  *
1916  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1917  * available, which can be applied to functions to make sure there are no nested
1918  * (reentrant) calls to them.
1919  *
1920  * Note that because there is a single `nonReentrant` guard, functions marked as
1921  * `nonReentrant` may not call one another. This can be worked around by making
1922  * those functions `private`, and then adding `external` `nonReentrant` entry
1923  * points to them.
1924  *
1925  * TIP: If you would like to learn more about reentrancy and alternative ways
1926  * to protect against it, check out our blog post
1927  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1928  */
1929 abstract contract ReentrancyGuard {
1930     // Booleans are more expensive than uint256 or any type that takes up a full
1931     // word because each write operation emits an extra SLOAD to first read the
1932     // slot's contents, replace the bits taken up by the boolean, and then write
1933     // back. This is the compiler's defense against contract upgrades and
1934     // pointer aliasing, and it cannot be disabled.
1935 
1936     // The values being non-zero value makes deployment a bit more expensive,
1937     // but in exchange the refund on every call to nonReentrant will be lower in
1938     // amount. Since refunds are capped to a percentage of the total
1939     // transaction's gas, it is best to keep them low in cases like this one, to
1940     // increase the likelihood of the full refund coming into effect.
1941     uint256 private constant _NOT_ENTERED = 1;
1942     uint256 private constant _ENTERED = 2;
1943 
1944     uint256 private _status;
1945 
1946     constructor() {
1947         _status = _NOT_ENTERED;
1948     }
1949 
1950     /**
1951      * @dev Prevents a contract from calling itself, directly or indirectly.
1952      * Calling a `nonReentrant` function from another `nonReentrant`
1953      * function is not supported. It is possible to prevent this from happening
1954      * by making the `nonReentrant` function external, and making it call a
1955      * `private` function that does the actual work.
1956      */
1957     modifier nonReentrant() {
1958         // On the first call to nonReentrant, _notEntered will be true
1959         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1960 
1961         // Any calls to nonReentrant after this point will fail
1962         _status = _ENTERED;
1963 
1964         _;
1965 
1966         // By storing the original value once again, a refund is triggered (see
1967         // https://eips.ethereum.org/EIPS/eip-2200)
1968         _status = _NOT_ENTERED;
1969     }
1970 }
1971 
1972 contract JustMeow is ERC721A, ERC2981, Ownable, ReentrancyGuard {
1973 
1974     string public baseURI = "https://nftservices.s3.amazonaws.com/justmeow/";
1975 
1976     uint256 public tokenPrice = 5000000000000000; //0.005 ETH
1977 
1978     uint public maxTokensPerTx = 20;
1979 
1980     uint public defaultTokensPerTx = 3;
1981 
1982     uint256 public MAX_TOKENS = 8888;
1983 
1984     bool public saleIsActive = true;
1985 
1986     uint256 public whitelistMintRemains = 0;
1987 
1988     // = 0 if there are all free
1989     // = maxTokensPerTx if there are all with fee
1990     uint public maxTokensWithFeePerTx = 1;
1991 
1992     enum TokenURIMode {
1993         MODE_ONE,
1994         MODE_TWO
1995     }
1996 
1997     TokenURIMode private tokenUriMode = TokenURIMode.MODE_ONE;
1998 
1999     constructor(        
2000     ) ERC721A("JustMeow", "JW") {
2001         _setDefaultRoyalty(msg.sender, 200);
2002         _safeMint(msg.sender, 100);
2003     }
2004 
2005 
2006     struct HelperState {
2007         uint256 tokenPrice;
2008         uint256 maxTokensPerTx;
2009         uint256 MAX_TOKENS;
2010         bool saleIsActive;
2011         uint256 totalSupply;
2012         uint  maxTokensWithFeePerTx;
2013         uint256 userMinted;
2014         uint defaultTokensPerTx;
2015     }
2016 
2017     function _state(address minter) external view returns (HelperState memory) {
2018         return HelperState({
2019             tokenPrice: tokenPrice,
2020             maxTokensPerTx: maxTokensPerTx,
2021             MAX_TOKENS: MAX_TOKENS,
2022             saleIsActive: saleIsActive,
2023             totalSupply: uint256(totalSupply()),
2024             maxTokensWithFeePerTx : maxTokensWithFeePerTx,
2025             userMinted: uint256(_numberMinted(minter)),
2026             defaultTokensPerTx : defaultTokensPerTx
2027         });
2028     }
2029 
2030     function withdraw() public onlyOwner {
2031         uint balance = address(this).balance;
2032         payable(msg.sender).transfer(balance);
2033     } 
2034 
2035     function withdrawTo(address to, uint256 amount) public onlyOwner {
2036         require(amount <= address(this).balance, "Exceed balance of this contract");
2037         payable(to).transfer(amount);
2038     } 
2039 
2040     function reserveTokens(address to, uint numberOfTokens) public onlyOwner {        
2041         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Exceed max supply of tokens");
2042         _safeMint(to, numberOfTokens);
2043     }         
2044     
2045     function setBaseURI(string memory newURI) public onlyOwner {
2046         baseURI = newURI;
2047     }    
2048 
2049     function flipSaleState() public onlyOwner {
2050         saleIsActive = !saleIsActive;
2051     }
2052 
2053     function openWhitelistMint(uint256 _whitelistMintRemains) public onlyOwner{
2054         whitelistMintRemains = _whitelistMintRemains;
2055         saleIsActive = true;
2056     }
2057 
2058     function closeWhitelistMint()public onlyOwner{
2059         whitelistMintRemains = 0;
2060     }
2061 
2062     function getPrice(uint numberOfTokens, address minter) public view returns (uint256) {
2063         if(numberMinted(minter) > 0){
2064             return numberOfTokens * tokenPrice;
2065         } else if(numberOfTokens > maxTokensWithFeePerTx){
2066             return maxTokensWithFeePerTx * tokenPrice;
2067         } else if(numberOfTokens <= maxTokensWithFeePerTx){
2068             return numberOfTokens * tokenPrice;
2069         }
2070         return 0;
2071     }
2072 
2073     // if numberMinted(msg.sender) > 0 -> no whitelist, no free.
2074     function mintToken(uint numberOfTokens) public payable nonReentrant {
2075         require(saleIsActive, "Sale must be active");
2076         require(numberOfTokens <= maxTokensPerTx, "Exceed max tokens per tx");
2077         require(numberOfTokens > 0, "Must mint at least one");
2078         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Exceed max supply");
2079         
2080         if(whitelistMintRemains > 0 && numberMinted(msg.sender) <= 0){
2081             if(numberOfTokens >= whitelistMintRemains){
2082                 numberOfTokens = whitelistMintRemains;
2083             }
2084             _safeMint(msg.sender, numberOfTokens);
2085             whitelistMintRemains = whitelistMintRemains - numberOfTokens;
2086         } else{
2087             if(_numberMinted(msg.sender) > 0){
2088                 require(msg.value >= numberOfTokens * tokenPrice, "Not enough ether");
2089             } else  if(numberOfTokens > maxTokensWithFeePerTx){
2090                 require(msg.value >= maxTokensWithFeePerTx * tokenPrice, "Not enough ether");
2091             } else if(numberOfTokens <= maxTokensWithFeePerTx){
2092                 require(msg.value >= numberOfTokens * tokenPrice, "Not enough ether");
2093             }
2094             _safeMint(msg.sender, numberOfTokens);
2095         }
2096     }
2097 
2098     function setTokenPrice(uint256 newTokenPrice) public onlyOwner{
2099         tokenPrice = newTokenPrice;
2100     }
2101 
2102     function tokenURI(uint256 _tokenId) public view override returns (string memory) 
2103     {
2104         require(_exists(_tokenId), "Token does not exist.");
2105         if (tokenUriMode == TokenURIMode.MODE_TWO) {
2106           return bytes(baseURI).length > 0 ? string(
2107             abi.encodePacked(
2108               baseURI,
2109               Strings.toString(_tokenId)
2110             )
2111           ) : "";
2112         } else {
2113           return bytes(baseURI).length > 0 ? string(
2114             abi.encodePacked(
2115               baseURI,
2116               Strings.toString(_tokenId),
2117               ".json"
2118             )
2119           ) : "";
2120         }
2121     }
2122 
2123     function setTokenURIMode(uint256 mode) external onlyOwner {
2124         if (mode == 2) {
2125             tokenUriMode = TokenURIMode.MODE_TWO;
2126         } else {
2127             tokenUriMode = TokenURIMode.MODE_ONE;
2128         }
2129     }
2130 
2131     function _baseURI() internal view virtual override returns (string memory) {
2132         return baseURI;
2133     }   
2134 
2135     function numberMinted(address owner) public view returns (uint256) {
2136         return _numberMinted(owner);
2137     } 
2138 
2139     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2140       MAX_TOKENS = _maxSupply;
2141     }
2142 
2143     function setMaxTokensPerTx(uint _maxTokensPerTx) public onlyOwner{
2144         maxTokensPerTx = _maxTokensPerTx;
2145     }
2146 
2147     function setMaxTokensWithFeePerTx(uint _maxTokensWithFeePerTx) public onlyOwner{
2148         maxTokensWithFeePerTx = _maxTokensWithFeePerTx;
2149     }
2150 
2151     function setDefaultTokensPerTx(uint _defaultTokensPerTx) public onlyOwner{
2152         defaultTokensPerTx = _defaultTokensPerTx;
2153     }
2154 
2155     /**
2156     @notice Sets the contract-wide royalty info.
2157      */
2158     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
2159         external
2160         onlyOwner
2161     {
2162         _setDefaultRoyalty(receiver, feeBasisPoints);
2163     }
2164 
2165     function supportsInterface(bytes4 interfaceId)
2166         public
2167         view
2168         override(ERC721A, ERC2981)
2169         returns (bool)
2170     {
2171         return super.supportsInterface(interfaceId);
2172     }
2173     
2174     function randomLottery(address adr) public view returns (uint){
2175         return uint( keccak256(abi.encodePacked(adr, name())) ) % 100;
2176     }
2177 }