1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
7 
8 pragma solidity 0.8.10;
9 
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Interface of the ERC165 standard, as defined in the
34  * https://eips.ethereum.org/EIPS/eip-165[EIP].
35  *
36  * Implementers can declare support of contract interfaces, which can then be
37  * queried by others ({ERC165Checker}).
38  *
39  * For an implementation, see {ERC165}.
40  */
41 interface IERC165 {
42     /**
43      * @dev Returns true if this contract implements the interface defined by
44      * `interfaceId`. See the corresponding
45      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
46      * to learn more about how these ids are created.
47      *
48      * This function call must use less than 30 000 gas.
49      */
50     function supportsInterface(bytes4 interfaceId) external view returns (bool);
51 }
52 
53 
54 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
55 
56 /**
57  * @dev Required interface of an ERC721 compliant contract.
58  */
59 interface IERC721 is IERC165 {
60     /**
61      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
62      */
63     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
64 
65     /**
66      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
67      */
68     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
69 
70     /**
71      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
72      */
73     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
74 
75     /**
76      * @dev Returns the number of tokens in ``owner``'s account.
77      */
78     function balanceOf(address owner) external view returns (uint256 balance);
79 
80     /**
81      * @dev Returns the owner of the `tokenId` token.
82      *
83      * Requirements:
84      *
85      * - `tokenId` must exist.
86      */
87     function ownerOf(uint256 tokenId) external view returns (address owner);
88 
89     /**
90      * @dev Safely transfers `tokenId` token from `from` to `to`.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId,
106         bytes calldata data
107     ) external;
108 
109     /**
110      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
111      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must exist and be owned by `from`.
118      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
119      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
120      *
121      * Emits a {Transfer} event.
122      */
123     function safeTransferFrom(
124         address from,
125         address to,
126         uint256 tokenId
127     ) external;
128 
129     /**
130      * @dev Transfers `tokenId` token from `from` to `to`.
131      *
132      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
133      *
134      * Requirements:
135      *
136      * - `from` cannot be the zero address.
137      * - `to` cannot be the zero address.
138      * - `tokenId` token must be owned by `from`.
139      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address from,
145         address to,
146         uint256 tokenId
147     ) external;
148 
149     /**
150      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
151      * The approval is cleared when the token is transferred.
152      *
153      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
154      *
155      * Requirements:
156      *
157      * - The caller must own the token or be an approved operator.
158      * - `tokenId` must exist.
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address to, uint256 tokenId) external;
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
177      * @dev Returns the account approved for `tokenId` token.
178      *
179      * Requirements:
180      *
181      * - `tokenId` must exist.
182      */
183     function getApproved(uint256 tokenId) external view returns (address operator);
184 
185     /**
186      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
187      *
188      * See {setApprovalForAll}
189      */
190     function isApprovedForAll(address owner, address operator) external view returns (bool);
191 }
192 
193 
194 /**
195  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
196  * @dev See https://eips.ethereum.org/EIPS/eip-721
197  */
198 interface IERC721Metadata is IERC721 {
199     /**
200      * @dev Returns the token collection name.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the token collection symbol.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
211      */
212     function tokenURI(uint256 tokenId) external view returns (string memory);
213 }
214 
215 
216 // ERC721A Contracts v3.3.0
217 // Creator: Chiru Labs
218 
219 /**
220  * @dev Interface of an ERC721A compliant contract.
221  */
222 interface IERC721A is IERC721, IERC721Metadata {
223     /**
224      * The caller must own the token or be an approved operator.
225      */
226     error ApprovalCallerNotOwnerNorApproved();
227 
228     /**
229      * The token does not exist.
230      */
231     error ApprovalQueryForNonexistentToken();
232 
233     /**
234      * The caller cannot approve to their own address.
235      */
236     error ApproveToCaller();
237 
238     /**
239      * The caller cannot approve to the current owner.
240      */
241     error ApprovalToCurrentOwner();
242 
243     /**
244      * Cannot query the balance for the zero address.
245      */
246     error BalanceQueryForZeroAddress();
247 
248     /**
249      * Cannot mint to the zero address.
250      */
251     error MintToZeroAddress();
252 
253     /**
254      * The quantity of tokens minted must be more than zero.
255      */
256     error MintZeroQuantity();
257 
258     /**
259      * The token does not exist.
260      */
261     error OwnerQueryForNonexistentToken();
262 
263     /**
264      * The caller must own the token or be an approved operator.
265      */
266     error TransferCallerNotOwnerNorApproved();
267 
268     /**
269      * The token must be owned by `from`.
270      */
271     error TransferFromIncorrectOwner();
272 
273     /**
274      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
275      */
276     error TransferToNonERC721ReceiverImplementer();
277 
278     /**
279      * Cannot transfer to the zero address.
280      */
281     error TransferToZeroAddress();
282 
283     /**
284      * The token does not exist.
285      */
286     error URIQueryForNonexistentToken();
287 
288     // Compiler will pack this into a single 256bit word.
289     struct TokenOwnership {
290         // The address of the owner.
291         address addr;
292         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
293         uint64 startTimestamp;
294         // Whether the token has been burned.
295         bool burned;
296     }
297 
298     // Compiler will pack this into a single 256bit word.
299     struct AddressData {
300         // Realistically, 2**64-1 is more than enough.
301         uint64 balance;
302         // Keeps track of mint count with minimal overhead for tokenomics.
303         uint64 numberMinted;
304         // Keeps track of burn count with minimal overhead for tokenomics.
305         uint64 numberBurned;
306         // For miscellaneous variable(s) pertaining to the address
307         // (e.g. number of whitelist mint slots used).
308         // If there are multiple variables, please pack them into a uint64.
309         uint64 aux;
310     }
311 
312     /**
313      * @dev Returns the total amount of tokens stored by the contract.
314      * 
315      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
316      */
317     function totalSupply() external view returns (uint256);
318 }
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
322 
323 /**
324  * @dev Implementation of the {IERC165} interface.
325  *
326  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
327  * for the additional interface id that will be supported. For example:
328  *
329  * ```solidity
330  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
331  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
332  * }
333  * ```
334  *
335  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
336  */
337 abstract contract ERC165 is IERC165 {
338     /**
339      * @dev See {IERC165-supportsInterface}.
340      */
341     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
342         return interfaceId == type(IERC165).interfaceId;
343     }
344 }
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
348 
349 /**
350  * @dev Contract module which provides a basic access control mechanism, where
351  * there is an account (an owner) that can be granted exclusive access to
352  * specific functions.
353  *
354  * By default, the owner account will be the one that deploys the contract. This
355  * can later be changed with {transferOwnership}.
356  *
357  * This module is used through inheritance. It will make available the modifier
358  * `onlyOwner`, which can be applied to your functions to restrict their use to
359  * the owner.
360  */
361 abstract contract Ownable is Context {
362     address private _owner;
363 
364     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
365 
366     /**
367      * @dev Initializes the contract setting the deployer as the initial owner.
368      */
369     constructor() {
370         _transferOwnership(_msgSender());
371     }
372 
373     /**
374      * @dev Returns the address of the current owner.
375      */
376     function owner() public view virtual returns (address) {
377         return _owner;
378     }
379 
380     /**
381      * @dev Throws if called by any account other than the owner.
382      */
383     modifier onlyOwner() {
384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
385         _;
386     }
387 
388     /**
389      * @dev Leaves the contract without owner. It will not be possible to call
390      * `onlyOwner` functions anymore. Can only be called by the current owner.
391      *
392      * NOTE: Renouncing ownership will leave the contract without an owner,
393      * thereby removing any functionality that is only available to the owner.
394      */
395     function renounceOwnership() public virtual onlyOwner {
396         _transferOwnership(address(0));
397     }
398 
399     /**
400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
401      * Can only be called by the current owner.
402      */
403     function transferOwnership(address newOwner) public virtual onlyOwner {
404         require(newOwner != address(0), "Ownable: new owner is the zero address");
405         _transferOwnership(newOwner);
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Internal function without access restriction.
411      */
412     function _transferOwnership(address newOwner) internal virtual {
413         address oldOwner = _owner;
414         _owner = newOwner;
415         emit OwnershipTransferred(oldOwner, newOwner);
416     }
417 }
418 
419 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
420 
421 /**
422  * @dev Collection of functions related to the address type
423  */
424 library Address {
425     /**
426      * @dev Returns true if `account` is a contract.
427      *
428      * [IMPORTANT]
429      * ====
430      * It is unsafe to assume that an address for which this function returns
431      * false is an externally-owned account (EOA) and not a contract.
432      *
433      * Among others, `isContract` will return false for the following
434      * types of addresses:
435      *
436      *  - an externally-owned account
437      *  - a contract in construction
438      *  - an address where a contract will be created
439      *  - an address where a contract lived, but was destroyed
440      * ====
441      *
442      * [IMPORTANT]
443      * ====
444      * You shouldn't rely on `isContract` to protect against flash loan attacks!
445      *
446      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
447      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
448      * constructor.
449      * ====
450      */
451     function isContract(address account) internal view returns (bool) {
452         // This method relies on extcodesize/address.code.length, which returns 0
453         // for contracts in construction, since the code is only stored at the end
454         // of the constructor execution.
455 
456         return account.code.length > 0;
457     }
458 
459     /**
460      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
461      * `recipient`, forwarding all available gas and reverting on errors.
462      *
463      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
464      * of certain opcodes, possibly making contracts go over the 2300 gas limit
465      * imposed by `transfer`, making them unable to receive funds via
466      * `transfer`. {sendValue} removes this limitation.
467      *
468      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
469      *
470      * IMPORTANT: because control is transferred to `recipient`, care must be
471      * taken to not create reentrancy vulnerabilities. Consider using
472      * {ReentrancyGuard} or the
473      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
474      */
475     function sendValue(address payable recipient, uint256 amount) internal {
476         require(address(this).balance >= amount, "Address: insufficient balance");
477 
478         (bool success, ) = recipient.call{value: amount}("");
479         require(success, "Address: unable to send value, recipient may have reverted");
480     }
481 
482     /**
483      * @dev Performs a Solidity function call using a low level `call`. A
484      * plain `call` is an unsafe replacement for a function call: use this
485      * function instead.
486      *
487      * If `target` reverts with a revert reason, it is bubbled up by this
488      * function (like regular Solidity function calls).
489      *
490      * Returns the raw returned data. To convert to the expected return value,
491      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
492      *
493      * Requirements:
494      *
495      * - `target` must be a contract.
496      * - calling `target` with `data` must not revert.
497      *
498      * _Available since v3.1._
499      */
500     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
501         return functionCall(target, data, "Address: low-level call failed");
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
506      * `errorMessage` as a fallback revert reason when `target` reverts.
507      *
508      * _Available since v3.1._
509      */
510     function functionCall(
511         address target,
512         bytes memory data,
513         string memory errorMessage
514     ) internal returns (bytes memory) {
515         return functionCallWithValue(target, data, 0, errorMessage);
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
520      * but also transferring `value` wei to `target`.
521      *
522      * Requirements:
523      *
524      * - the calling contract must have an ETH balance of at least `value`.
525      * - the called Solidity function must be `payable`.
526      *
527      * _Available since v3.1._
528      */
529     function functionCallWithValue(
530         address target,
531         bytes memory data,
532         uint256 value
533     ) internal returns (bytes memory) {
534         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
539      * with `errorMessage` as a fallback revert reason when `target` reverts.
540      *
541      * _Available since v3.1._
542      */
543     function functionCallWithValue(
544         address target,
545         bytes memory data,
546         uint256 value,
547         string memory errorMessage
548     ) internal returns (bytes memory) {
549         require(address(this).balance >= value, "Address: insufficient balance for call");
550         require(isContract(target), "Address: call to non-contract");
551 
552         (bool success, bytes memory returndata) = target.call{value: value}(data);
553         return verifyCallResult(success, returndata, errorMessage);
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
558      * but performing a static call.
559      *
560      * _Available since v3.3._
561      */
562     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
563         return functionStaticCall(target, data, "Address: low-level static call failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
568      * but performing a static call.
569      *
570      * _Available since v3.3._
571      */
572     function functionStaticCall(
573         address target,
574         bytes memory data,
575         string memory errorMessage
576     ) internal view returns (bytes memory) {
577         require(isContract(target), "Address: static call to non-contract");
578 
579         (bool success, bytes memory returndata) = target.staticcall(data);
580         return verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but performing a delegate call.
586      *
587      * _Available since v3.4._
588      */
589     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
590         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
595      * but performing a delegate call.
596      *
597      * _Available since v3.4._
598      */
599     function functionDelegateCall(
600         address target,
601         bytes memory data,
602         string memory errorMessage
603     ) internal returns (bytes memory) {
604         require(isContract(target), "Address: delegate call to non-contract");
605 
606         (bool success, bytes memory returndata) = target.delegatecall(data);
607         return verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
612      * revert reason using the provided one.
613      *
614      * _Available since v4.3._
615      */
616     function verifyCallResult(
617         bool success,
618         bytes memory returndata,
619         string memory errorMessage
620     ) internal pure returns (bytes memory) {
621         if (success) {
622             return returndata;
623         } else {
624             // Look for revert reason and bubble it up if present
625             if (returndata.length > 0) {
626                 // The easiest way to bubble the revert reason is using memory via assembly
627 
628                 assembly {
629                     let returndata_size := mload(returndata)
630                     revert(add(32, returndata), returndata_size)
631                 }
632             } else {
633                 revert(errorMessage);
634             }
635         }
636     }
637 }
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
641 
642 /**
643  * @dev String operations.
644  */
645 library Strings {
646     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
650      */
651     function toString(uint256 value) internal pure returns (string memory) {
652         // Inspired by OraclizeAPI's implementation - MIT licence
653         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
654 
655         if (value == 0) {
656             return "0";
657         }
658         uint256 temp = value;
659         uint256 digits;
660         while (temp != 0) {
661             digits++;
662             temp /= 10;
663         }
664         bytes memory buffer = new bytes(digits);
665         while (value != 0) {
666             digits -= 1;
667             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
668             value /= 10;
669         }
670         return string(buffer);
671     }
672 
673     /**
674      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
675      */
676     function toHexString(uint256 value) internal pure returns (string memory) {
677         if (value == 0) {
678             return "0x00";
679         }
680         uint256 temp = value;
681         uint256 length = 0;
682         while (temp != 0) {
683             length++;
684             temp >>= 8;
685         }
686         return toHexString(value, length);
687     }
688 
689     /**
690      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
691      */
692     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
693         bytes memory buffer = new bytes(2 * length + 2);
694         buffer[0] = "0";
695         buffer[1] = "x";
696         for (uint256 i = 2 * length + 1; i > 1; --i) {
697             buffer[i] = _HEX_SYMBOLS[value & 0xf];
698             value >>= 4;
699         }
700         require(value == 0, "Strings: hex length insufficient");
701         return string(buffer);
702     }
703 }
704 
705 
706 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
707 
708 /**
709  * @title ERC721 token receiver interface
710  * @dev Interface for any contract that wants to support safeTransfers
711  * from ERC721 asset contracts.
712  */
713 interface IERC721Receiver {
714     /**
715      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
716      * by `operator` from `from`, this function is called.
717      *
718      * It must return its Solidity selector to confirm the token transfer.
719      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
720      *
721      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
722      */
723     function onERC721Received(
724         address operator,
725         address from,
726         uint256 tokenId,
727         bytes calldata data
728     ) external returns (bytes4);
729 }
730 
731 
732 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
733 
734 /**
735  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
736  * the Metadata extension, but not including the Enumerable extension, which is available separately as
737  * {ERC721Enumerable}.
738  */
739 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
740     using Address for address;
741     using Strings for uint256;
742 
743     // Token name
744     string private _name;
745 
746     // Token symbol
747     string private _symbol;
748 
749     // Mapping from token ID to owner address
750     mapping(uint256 => address) private _owners;
751 
752     // Mapping owner address to token count
753     mapping(address => uint256) private _balances;
754 
755     // Mapping from token ID to approved address
756     mapping(uint256 => address) private _tokenApprovals;
757 
758     // Mapping from owner to operator approvals
759     mapping(address => mapping(address => bool)) private _operatorApprovals;
760 
761     /**
762      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
763      */
764     constructor(string memory name_, string memory symbol_) {
765         _name = name_;
766         _symbol = symbol_;
767     }
768 
769     /**
770      * @dev See {IERC165-supportsInterface}.
771      */
772     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
773         return
774             interfaceId == type(IERC721).interfaceId ||
775             interfaceId == type(IERC721Metadata).interfaceId ||
776             super.supportsInterface(interfaceId);
777     }
778 
779     /**
780      * @dev See {IERC721-balanceOf}.
781      */
782     function balanceOf(address owner) public view virtual override returns (uint256) {
783         require(owner != address(0), "ERC721: balance query for the zero address");
784         return _balances[owner];
785     }
786 
787     /**
788      * @dev See {IERC721-ownerOf}.
789      */
790     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
791         address owner = _owners[tokenId];
792         require(owner != address(0), "ERC721: owner query for nonexistent token");
793         return owner;
794     }
795 
796     /**
797      * @dev See {IERC721Metadata-name}.
798      */
799     function name() public view virtual override returns (string memory) {
800         return _name;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-symbol}.
805      */
806     function symbol() public view virtual override returns (string memory) {
807         return _symbol;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-tokenURI}.
812      */
813     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
814         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
815 
816         string memory baseURI = _baseURI();
817         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
818     }
819 
820     /**
821      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
822      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
823      * by default, can be overridden in child contracts.
824      */
825     function _baseURI() internal view virtual returns (string memory) {
826         return "";
827     }
828 
829     /**
830      * @dev See {IERC721-approve}.
831      */
832     function approve(address to, uint256 tokenId) public virtual override {
833         address owner = ERC721.ownerOf(tokenId);
834         require(to != owner, "ERC721: approval to current owner");
835 
836         require(
837             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
838             "ERC721: approve caller is not owner nor approved for all"
839         );
840 
841         _approve(to, tokenId);
842     }
843 
844     /**
845      * @dev See {IERC721-getApproved}.
846      */
847     function getApproved(uint256 tokenId) public view virtual override returns (address) {
848         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
849 
850         return _tokenApprovals[tokenId];
851     }
852 
853     /**
854      * @dev See {IERC721-setApprovalForAll}.
855      */
856     function setApprovalForAll(address operator, bool approved) public virtual override {
857         _setApprovalForAll(_msgSender(), operator, approved);
858     }
859 
860     /**
861      * @dev See {IERC721-isApprovedForAll}.
862      */
863     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
864         return _operatorApprovals[owner][operator];
865     }
866 
867     /**
868      * @dev See {IERC721-transferFrom}.
869      */
870     function transferFrom(
871         address from,
872         address to,
873         uint256 tokenId
874     ) public virtual override {
875         //solhint-disable-next-line max-line-length
876         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
877 
878         _transfer(from, to, tokenId);
879     }
880 
881     /**
882      * @dev See {IERC721-safeTransferFrom}.
883      */
884     function safeTransferFrom(
885         address from,
886         address to,
887         uint256 tokenId
888     ) public virtual override {
889         safeTransferFrom(from, to, tokenId, "");
890     }
891 
892     /**
893      * @dev See {IERC721-safeTransferFrom}.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId,
899         bytes memory _data
900     ) public virtual override {
901         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
902         _safeTransfer(from, to, tokenId, _data);
903     }
904 
905     /**
906      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
907      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
908      *
909      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
910      *
911      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
912      * implement alternative mechanisms to perform token transfer, such as signature-based.
913      *
914      * Requirements:
915      *
916      * - `from` cannot be the zero address.
917      * - `to` cannot be the zero address.
918      * - `tokenId` token must exist and be owned by `from`.
919      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
920      *
921      * Emits a {Transfer} event.
922      */
923     function _safeTransfer(
924         address from,
925         address to,
926         uint256 tokenId,
927         bytes memory _data
928     ) internal virtual {
929         _transfer(from, to, tokenId);
930         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
931     }
932 
933     /**
934      * @dev Returns whether `tokenId` exists.
935      *
936      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
937      *
938      * Tokens start existing when they are minted (`_mint`),
939      * and stop existing when they are burned (`_burn`).
940      */
941     function _exists(uint256 tokenId) internal view virtual returns (bool) {
942         return _owners[tokenId] != address(0);
943     }
944 
945     /**
946      * @dev Returns whether `spender` is allowed to manage `tokenId`.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      */
952     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
953         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
954         address owner = ERC721.ownerOf(tokenId);
955         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
956     }
957 
958     /**
959      * @dev Safely mints `tokenId` and transfers it to `to`.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must not exist.
964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _safeMint(address to, uint256 tokenId) internal virtual {
969         _safeMint(to, tokenId, "");
970     }
971 
972     /**
973      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
974      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
975      */
976     function _safeMint(
977         address to,
978         uint256 tokenId,
979         bytes memory _data
980     ) internal virtual {
981         _mint(to, tokenId);
982         require(
983             _checkOnERC721Received(address(0), to, tokenId, _data),
984             "ERC721: transfer to non ERC721Receiver implementer"
985         );
986     }
987 
988     /**
989      * @dev Mints `tokenId` and transfers it to `to`.
990      *
991      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
992      *
993      * Requirements:
994      *
995      * - `tokenId` must not exist.
996      * - `to` cannot be the zero address.
997      *
998      * Emits a {Transfer} event.
999      */
1000     function _mint(address to, uint256 tokenId) internal virtual {
1001         require(to != address(0), "ERC721: mint to the zero address");
1002         require(!_exists(tokenId), "ERC721: token already minted");
1003 
1004         _beforeTokenTransfer(address(0), to, tokenId);
1005 
1006         _balances[to] += 1;
1007         _owners[tokenId] = to;
1008 
1009         emit Transfer(address(0), to, tokenId);
1010 
1011         _afterTokenTransfer(address(0), to, tokenId);
1012     }
1013 
1014     /**
1015      * @dev Destroys `tokenId`.
1016      * The approval is cleared when the token is burned.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _burn(uint256 tokenId) internal virtual {
1025         address owner = ERC721.ownerOf(tokenId);
1026 
1027         _beforeTokenTransfer(owner, address(0), tokenId);
1028 
1029         // Clear approvals
1030         _approve(address(0), tokenId);
1031 
1032         _balances[owner] -= 1;
1033         delete _owners[tokenId];
1034 
1035         emit Transfer(owner, address(0), tokenId);
1036 
1037         _afterTokenTransfer(owner, address(0), tokenId);
1038     }
1039 
1040     /**
1041      * @dev Transfers `tokenId` from `from` to `to`.
1042      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _transfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual {
1056         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1057         require(to != address(0), "ERC721: transfer to the zero address");
1058 
1059         _beforeTokenTransfer(from, to, tokenId);
1060 
1061         // Clear approvals from the previous owner
1062         _approve(address(0), tokenId);
1063 
1064         _balances[from] -= 1;
1065         _balances[to] += 1;
1066         _owners[tokenId] = to;
1067 
1068         emit Transfer(from, to, tokenId);
1069 
1070         _afterTokenTransfer(from, to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Approve `to` to operate on `tokenId`
1075      *
1076      * Emits a {Approval} event.
1077      */
1078     function _approve(address to, uint256 tokenId) internal virtual {
1079         _tokenApprovals[tokenId] = to;
1080         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev Approve `operator` to operate on all of `owner` tokens
1085      *
1086      * Emits a {ApprovalForAll} event.
1087      */
1088     function _setApprovalForAll(
1089         address owner,
1090         address operator,
1091         bool approved
1092     ) internal virtual {
1093         require(owner != operator, "ERC721: approve to caller");
1094         _operatorApprovals[owner][operator] = approved;
1095         emit ApprovalForAll(owner, operator, approved);
1096     }
1097 
1098     /**
1099      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1100      * The call is not executed if the target address is not a contract.
1101      *
1102      * @param from address representing the previous owner of the given token ID
1103      * @param to target address that will receive the tokens
1104      * @param tokenId uint256 ID of the token to be transferred
1105      * @param _data bytes optional data to send along with the call
1106      * @return bool whether the call correctly returned the expected magic value
1107      */
1108     function _checkOnERC721Received(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory _data
1113     ) private returns (bool) {
1114         if (to.isContract()) {
1115             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1116                 return retval == IERC721Receiver.onERC721Received.selector;
1117             } catch (bytes memory reason) {
1118                 if (reason.length == 0) {
1119                     revert("ERC721: transfer to non ERC721Receiver implementer");
1120                 } else {
1121                     assembly {
1122                         revert(add(32, reason), mload(reason))
1123                     }
1124                 }
1125             }
1126         } else {
1127             return true;
1128         }
1129     }
1130 
1131     /**
1132      * @dev Hook that is called before any token transfer. This includes minting
1133      * and burning.
1134      *
1135      * Calling conditions:
1136      *
1137      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1138      * transferred to `to`.
1139      * - When `from` is zero, `tokenId` will be minted for `to`.
1140      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1141      * - `from` and `to` are never both zero.
1142      *
1143      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1144      */
1145     function _beforeTokenTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId
1149     ) internal virtual {}
1150 
1151     /**
1152      * @dev Hook that is called after any transfer of tokens. This includes
1153      * minting and burning.
1154      *
1155      * Calling conditions:
1156      *
1157      * - when `from` and `to` are both non-zero.
1158      * - `from` and `to` are never both zero.
1159      *
1160      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1161      */
1162     function _afterTokenTransfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) internal virtual {}
1167 }
1168 
1169 
1170 // ERC721A Contracts v3.3.0
1171 // Creator: Chiru Labs
1172 
1173 /**
1174  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1175  * the Metadata extension. Built to optimize for lower gas during batch mints.
1176  *
1177  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1178  *
1179  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1180  *
1181  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1182  */
1183 contract ERC721A is Context, ERC165, IERC721A {
1184     using Address for address;
1185     using Strings for uint256;
1186 
1187     // The tokenId of the next token to be minted.
1188     uint256 internal _currentIndex;
1189 
1190     // The number of tokens burned.
1191     uint256 internal _burnCounter;
1192 
1193     // Token name
1194     string private _name;
1195 
1196     // Token symbol
1197     string private _symbol;
1198 
1199     // Mapping from token ID to ownership details
1200     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1201     mapping(uint256 => TokenOwnership) internal _ownerships;
1202 
1203     // Mapping owner address to address data
1204     mapping(address => AddressData) private _addressData;
1205 
1206     // Mapping from token ID to approved address
1207     mapping(uint256 => address) private _tokenApprovals;
1208 
1209     // Mapping from owner to operator approvals
1210     mapping(address => mapping(address => bool)) private _operatorApprovals;
1211 
1212     constructor(string memory name_, string memory symbol_) {
1213         _name = name_;
1214         _symbol = symbol_;
1215         _currentIndex = _startTokenId();
1216     }
1217 
1218     /**
1219      * To change the starting tokenId, please override this function.
1220      */
1221     function _startTokenId() internal view virtual returns (uint256) {
1222         return 0;
1223     }
1224 
1225     /**
1226      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1227      */
1228     function totalSupply() public view override returns (uint256) {
1229         // Counter underflow is impossible as _burnCounter cannot be incremented
1230         // more than _currentIndex - _startTokenId() times
1231         unchecked {
1232             return _currentIndex - _burnCounter - _startTokenId();
1233         }
1234     }
1235 
1236     /**
1237      * Returns the total amount of tokens minted in the contract.
1238      */
1239     function _totalMinted() internal view returns (uint256) {
1240         // Counter underflow is impossible as _currentIndex does not decrement,
1241         // and it is initialized to _startTokenId()
1242         unchecked {
1243             return _currentIndex - _startTokenId();
1244         }
1245     }
1246 
1247     /**
1248      * @dev See {IERC165-supportsInterface}.
1249      */
1250     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1251         return
1252             interfaceId == type(IERC721).interfaceId ||
1253             interfaceId == type(IERC721Metadata).interfaceId ||
1254             super.supportsInterface(interfaceId);
1255     }
1256 
1257     /**
1258      * @dev See {IERC721-balanceOf}.
1259      */
1260     function balanceOf(address owner) public view override returns (uint256) {
1261         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1262         return uint256(_addressData[owner].balance);
1263     }
1264 
1265     /**
1266      * Returns the number of tokens minted by `owner`.
1267      */
1268     function _numberMinted(address owner) internal view returns (uint256) {
1269         return uint256(_addressData[owner].numberMinted);
1270     }
1271 
1272     /**
1273      * Returns the number of tokens burned by or on behalf of `owner`.
1274      */
1275     function _numberBurned(address owner) internal view returns (uint256) {
1276         return uint256(_addressData[owner].numberBurned);
1277     }
1278 
1279     /**
1280      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1281      */
1282     function _getAux(address owner) internal view returns (uint64) {
1283         return _addressData[owner].aux;
1284     }
1285 
1286     /**
1287      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1288      * If there are multiple variables, please pack them into a uint64.
1289      */
1290     function _setAux(address owner, uint64 aux) internal {
1291         _addressData[owner].aux = aux;
1292     }
1293 
1294     /**
1295      * Gas spent here starts off proportional to the maximum mint batch size.
1296      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1297      */
1298     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1299         uint256 curr = tokenId;
1300 
1301         unchecked {
1302             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1303                 TokenOwnership memory ownership = _ownerships[curr];
1304                 if (!ownership.burned) {
1305                     if (ownership.addr != address(0)) {
1306                         return ownership;
1307                     }
1308                     // Invariant:
1309                     // There will always be an ownership that has an address and is not burned
1310                     // before an ownership that does not have an address and is not burned.
1311                     // Hence, curr will not underflow.
1312                     while (true) {
1313                         curr--;
1314                         ownership = _ownerships[curr];
1315                         if (ownership.addr != address(0)) {
1316                             return ownership;
1317                         }
1318                     }
1319                 }
1320             }
1321         }
1322         revert OwnerQueryForNonexistentToken();
1323     }
1324 
1325     /**
1326      * @dev See {IERC721-ownerOf}.
1327      */
1328     function ownerOf(uint256 tokenId) public view override returns (address) {
1329         return _ownershipOf(tokenId).addr;
1330     }
1331 
1332     /**
1333      * @dev See {IERC721Metadata-name}.
1334      */
1335     function name() public view virtual override returns (string memory) {
1336         return _name;
1337     }
1338 
1339     /**
1340      * @dev See {IERC721Metadata-symbol}.
1341      */
1342     function symbol() public view virtual override returns (string memory) {
1343         return _symbol;
1344     }
1345 
1346     /**
1347      * @dev See {IERC721Metadata-tokenURI}.
1348      */
1349     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1350         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1351 
1352         string memory baseURI = _baseURI();
1353         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1354     }
1355 
1356     /**
1357      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1358      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1359      * by default, can be overriden in child contracts.
1360      */
1361     function _baseURI() internal view virtual returns (string memory) {
1362         return '';
1363     }
1364 
1365     /**
1366      * @dev See {IERC721-approve}.
1367      */
1368     function approve(address to, uint256 tokenId) public override {
1369         address owner = ERC721A.ownerOf(tokenId);
1370         if (to == owner) revert ApprovalToCurrentOwner();
1371 
1372         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1373             revert ApprovalCallerNotOwnerNorApproved();
1374         }
1375 
1376         _approve(to, tokenId, owner);
1377     }
1378 
1379     /**
1380      * @dev See {IERC721-getApproved}.
1381      */
1382     function getApproved(uint256 tokenId) public view override returns (address) {
1383         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1384 
1385         return _tokenApprovals[tokenId];
1386     }
1387 
1388     /**
1389      * @dev See {IERC721-setApprovalForAll}.
1390      */
1391     function setApprovalForAll(address operator, bool approved) public virtual override {
1392         if (operator == _msgSender()) revert ApproveToCaller();
1393 
1394         _operatorApprovals[_msgSender()][operator] = approved;
1395         emit ApprovalForAll(_msgSender(), operator, approved);
1396     }
1397 
1398     /**
1399      * @dev See {IERC721-isApprovedForAll}.
1400      */
1401     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1402         return _operatorApprovals[owner][operator];
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-transferFrom}.
1407      */
1408     function transferFrom(
1409         address from,
1410         address to,
1411         uint256 tokenId
1412     ) public virtual override {
1413         _transfer(from, to, tokenId);
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-safeTransferFrom}.
1418      */
1419     function safeTransferFrom(
1420         address from,
1421         address to,
1422         uint256 tokenId
1423     ) public virtual override {
1424         safeTransferFrom(from, to, tokenId, '');
1425     }
1426 
1427     /**
1428      * @dev See {IERC721-safeTransferFrom}.
1429      */
1430     function safeTransferFrom(
1431         address from,
1432         address to,
1433         uint256 tokenId,
1434         bytes memory _data
1435     ) public virtual override {
1436         _transfer(from, to, tokenId);
1437         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1438             revert TransferToNonERC721ReceiverImplementer();
1439         }
1440     }
1441 
1442     /**
1443      * @dev Returns whether `tokenId` exists.
1444      *
1445      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1446      *
1447      * Tokens start existing when they are minted (`_mint`),
1448      */
1449     function _exists(uint256 tokenId) internal view returns (bool) {
1450         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1451     }
1452 
1453     /**
1454      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1455      */
1456     function _safeMint(address to, uint256 quantity) internal {
1457         _safeMint(to, quantity, '');
1458     }
1459 
1460     /**
1461      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1462      *
1463      * Requirements:
1464      *
1465      * - If `to` refers to a smart contract, it must implement
1466      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1467      * - `quantity` must be greater than 0.
1468      *
1469      * Emits a {Transfer} event.
1470      */
1471     function _safeMint(
1472         address to,
1473         uint256 quantity,
1474         bytes memory _data
1475     ) internal {
1476         uint256 startTokenId = _currentIndex;
1477         if (to == address(0)) revert MintToZeroAddress();
1478         if (quantity == 0) revert MintZeroQuantity();
1479 
1480         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1481 
1482         // Overflows are incredibly unrealistic.
1483         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1484         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1485         unchecked {
1486             _addressData[to].balance += uint64(quantity);
1487             _addressData[to].numberMinted += uint64(quantity);
1488 
1489             _ownerships[startTokenId].addr = to;
1490             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1491 
1492             uint256 updatedIndex = startTokenId;
1493             uint256 end = updatedIndex + quantity;
1494 
1495             if (to.isContract()) {
1496                 do {
1497                     emit Transfer(address(0), to, updatedIndex);
1498                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1499                         revert TransferToNonERC721ReceiverImplementer();
1500                     }
1501                 } while (updatedIndex < end);
1502                 // Reentrancy protection
1503                 if (_currentIndex != startTokenId) revert();
1504             } else {
1505                 do {
1506                     emit Transfer(address(0), to, updatedIndex++);
1507                 } while (updatedIndex < end);
1508             }
1509             _currentIndex = updatedIndex;
1510         }
1511         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1512     }
1513 
1514     /**
1515      * @dev Mints `quantity` tokens and transfers them to `to`.
1516      *
1517      * Requirements:
1518      *
1519      * - `to` cannot be the zero address.
1520      * - `quantity` must be greater than 0.
1521      *
1522      * Emits a {Transfer} event.
1523      */
1524     function _mint(address to, uint256 quantity) internal {
1525         uint256 startTokenId = _currentIndex;
1526         if (to == address(0)) revert MintToZeroAddress();
1527         if (quantity == 0) revert MintZeroQuantity();
1528 
1529         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1530 
1531         // Overflows are incredibly unrealistic.
1532         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1533         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1534         unchecked {
1535             _addressData[to].balance += uint64(quantity);
1536             _addressData[to].numberMinted += uint64(quantity);
1537 
1538             _ownerships[startTokenId].addr = to;
1539             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1540 
1541             uint256 updatedIndex = startTokenId;
1542             uint256 end = updatedIndex + quantity;
1543 
1544             do {
1545                 emit Transfer(address(0), to, updatedIndex++);
1546             } while (updatedIndex < end);
1547 
1548             _currentIndex = updatedIndex;
1549         }
1550         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1551     }
1552 
1553     /**
1554      * @dev Transfers `tokenId` from `from` to `to`.
1555      *
1556      * Requirements:
1557      *
1558      * - `to` cannot be the zero address.
1559      * - `tokenId` token must be owned by `from`.
1560      *
1561      * Emits a {Transfer} event.
1562      */
1563     function _transfer(
1564         address from,
1565         address to,
1566         uint256 tokenId
1567     ) private {
1568         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1569 
1570         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1571 
1572         bool isApprovedOrOwner = (_msgSender() == from ||
1573             isApprovedForAll(from, _msgSender()) ||
1574             getApproved(tokenId) == _msgSender());
1575 
1576         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1577         if (to == address(0)) revert TransferToZeroAddress();
1578 
1579         _beforeTokenTransfers(from, to, tokenId, 1);
1580 
1581         // Clear approvals from the previous owner
1582         _approve(address(0), tokenId, from);
1583 
1584         // Underflow of the sender's balance is impossible because we check for
1585         // ownership above and the recipient's balance can't realistically overflow.
1586         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1587         unchecked {
1588             _addressData[from].balance -= 1;
1589             _addressData[to].balance += 1;
1590 
1591             TokenOwnership storage currSlot = _ownerships[tokenId];
1592             currSlot.addr = to;
1593             currSlot.startTimestamp = uint64(block.timestamp);
1594 
1595             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1596             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1597             uint256 nextTokenId = tokenId + 1;
1598             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1599             if (nextSlot.addr == address(0)) {
1600                 // This will suffice for checking _exists(nextTokenId),
1601                 // as a burned slot cannot contain the zero address.
1602                 if (nextTokenId != _currentIndex) {
1603                     nextSlot.addr = from;
1604                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1605                 }
1606             }
1607         }
1608 
1609         emit Transfer(from, to, tokenId);
1610         _afterTokenTransfers(from, to, tokenId, 1);
1611     }
1612 
1613     /**
1614      * @dev Equivalent to `_burn(tokenId, false)`.
1615      */
1616     function _burn(uint256 tokenId) internal virtual {
1617         _burn(tokenId, false);
1618     }
1619 
1620     /**
1621      * @dev Destroys `tokenId`.
1622      * The approval is cleared when the token is burned.
1623      *
1624      * Requirements:
1625      *
1626      * - `tokenId` must exist.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1631         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1632 
1633         address from = prevOwnership.addr;
1634 
1635         if (approvalCheck) {
1636             bool isApprovedOrOwner = (_msgSender() == from ||
1637                 isApprovedForAll(from, _msgSender()) ||
1638                 getApproved(tokenId) == _msgSender());
1639 
1640             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1641         }
1642 
1643         _beforeTokenTransfers(from, address(0), tokenId, 1);
1644 
1645         // Clear approvals from the previous owner
1646         _approve(address(0), tokenId, from);
1647 
1648         // Underflow of the sender's balance is impossible because we check for
1649         // ownership above and the recipient's balance can't realistically overflow.
1650         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1651         unchecked {
1652             AddressData storage addressData = _addressData[from];
1653             addressData.balance -= 1;
1654             addressData.numberBurned += 1;
1655 
1656             // Keep track of who burned the token, and the timestamp of burning.
1657             TokenOwnership storage currSlot = _ownerships[tokenId];
1658             currSlot.addr = from;
1659             currSlot.startTimestamp = uint64(block.timestamp);
1660             currSlot.burned = true;
1661 
1662             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1663             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1664             uint256 nextTokenId = tokenId + 1;
1665             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1666             if (nextSlot.addr == address(0)) {
1667                 // This will suffice for checking _exists(nextTokenId),
1668                 // as a burned slot cannot contain the zero address.
1669                 if (nextTokenId != _currentIndex) {
1670                     nextSlot.addr = from;
1671                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1672                 }
1673             }
1674         }
1675 
1676         emit Transfer(from, address(0), tokenId);
1677         _afterTokenTransfers(from, address(0), tokenId, 1);
1678 
1679         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1680         unchecked {
1681             _burnCounter++;
1682         }
1683     }
1684 
1685     /**
1686      * @dev Approve `to` to operate on `tokenId`
1687      *
1688      * Emits a {Approval} event.
1689      */
1690     function _approve(
1691         address to,
1692         uint256 tokenId,
1693         address owner
1694     ) private {
1695         _tokenApprovals[tokenId] = to;
1696         emit Approval(owner, to, tokenId);
1697     }
1698 
1699     /**
1700      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1701      *
1702      * @param from address representing the previous owner of the given token ID
1703      * @param to target address that will receive the tokens
1704      * @param tokenId uint256 ID of the token to be transferred
1705      * @param _data bytes optional data to send along with the call
1706      * @return bool whether the call correctly returned the expected magic value
1707      */
1708     function _checkContractOnERC721Received(
1709         address from,
1710         address to,
1711         uint256 tokenId,
1712         bytes memory _data
1713     ) private returns (bool) {
1714         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1715             return retval == IERC721Receiver(to).onERC721Received.selector;
1716         } catch (bytes memory reason) {
1717             if (reason.length == 0) {
1718                 revert TransferToNonERC721ReceiverImplementer();
1719             } else {
1720                 assembly {
1721                     revert(add(32, reason), mload(reason))
1722                 }
1723             }
1724         }
1725     }
1726 
1727     /**
1728      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1729      * And also called before burning one token.
1730      *
1731      * startTokenId - the first token id to be transferred
1732      * quantity - the amount to be transferred
1733      *
1734      * Calling conditions:
1735      *
1736      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1737      * transferred to `to`.
1738      * - When `from` is zero, `tokenId` will be minted for `to`.
1739      * - When `to` is zero, `tokenId` will be burned by `from`.
1740      * - `from` and `to` are never both zero.
1741      */
1742     function _beforeTokenTransfers(
1743         address from,
1744         address to,
1745         uint256 startTokenId,
1746         uint256 quantity
1747     ) internal virtual {}
1748 
1749     /**
1750      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1751      * minting.
1752      * And also called after one token has been burned.
1753      *
1754      * startTokenId - the first token id to be transferred
1755      * quantity - the amount to be transferred
1756      *
1757      * Calling conditions:
1758      *
1759      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1760      * transferred to `to`.
1761      * - When `from` is zero, `tokenId` has been minted for `to`.
1762      * - When `to` is zero, `tokenId` has been burned by `from`.
1763      * - `from` and `to` are never both zero.
1764      */
1765     function _afterTokenTransfers(
1766         address from,
1767         address to,
1768         uint256 startTokenId,
1769         uint256 quantity
1770     ) internal virtual {}
1771 }
1772 
1773 // OpenZeppelin Contracts (last updated v4.5.0) (interfaces/IERC2981.sol)
1774 
1775 /**
1776  * @dev Interface for the NFT Royalty Standard.
1777  *
1778  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1779  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1780  *
1781  * _Available since v4.5._
1782  */
1783 interface IERC2981 is IERC165 {
1784     /**
1785      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1786      * exchange. The royalty amount is denominated and should be payed in that same unit of exchange.
1787      */
1788     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1789         external
1790         view
1791         returns (address receiver, uint256 royaltyAmount);
1792 }
1793 
1794 // OpenZeppelin Contracts (last updated v4.5.0) (token/common/ERC2981.sol)
1795 
1796 /**
1797  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1798  *
1799  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1800  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1801  *
1802  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1803  * fee is specified in basis points by default.
1804  *
1805  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1806  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1807  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1808  *
1809  * _Available since v4.5._
1810  */
1811 abstract contract ERC2981 is IERC2981, ERC165 {
1812     struct RoyaltyInfo {
1813         address receiver;
1814         uint96 royaltyFraction;
1815     }
1816 
1817     RoyaltyInfo private _defaultRoyaltyInfo;
1818     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1819 
1820     /**
1821      * @dev See {IERC165-supportsInterface}.
1822      */
1823     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1824         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1825     }
1826 
1827     /**
1828      * @inheritdoc IERC2981
1829      */
1830     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1831         external
1832         view
1833         virtual
1834         override
1835         returns (address, uint256)
1836     {
1837         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1838 
1839         if (royalty.receiver == address(0)) {
1840             royalty = _defaultRoyaltyInfo;
1841         }
1842 
1843         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1844 
1845         return (royalty.receiver, royaltyAmount);
1846     }
1847 
1848     /**
1849      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1850      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1851      * override.
1852      */
1853     function _feeDenominator() internal pure virtual returns (uint96) {
1854         return 10000;
1855     }
1856 
1857     /**
1858      * @dev Sets the royalty information that all ids in this contract will default to.
1859      *
1860      * Requirements:
1861      *
1862      * - `receiver` cannot be the zero address.
1863      * - `feeNumerator` cannot be greater than the fee denominator.
1864      */
1865     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1866         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1867         require(receiver != address(0), "ERC2981: invalid receiver");
1868 
1869         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1870     }
1871 
1872     /**
1873      * @dev Removes default royalty information.
1874      */
1875     function _deleteDefaultRoyalty() internal virtual {
1876         delete _defaultRoyaltyInfo;
1877     }
1878 
1879     /**
1880      * @dev Sets the royalty information for a specific token id, overriding the global default.
1881      *
1882      * Requirements:
1883      *
1884      * - `tokenId` must be already minted.
1885      * - `receiver` cannot be the zero address.
1886      * - `feeNumerator` cannot be greater than the fee denominator.
1887      */
1888     function _setTokenRoyalty(
1889         uint256 tokenId,
1890         address receiver,
1891         uint96 feeNumerator
1892     ) internal virtual {
1893         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1894         require(receiver != address(0), "ERC2981: Invalid parameters");
1895 
1896         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1897     }
1898 
1899     /**
1900      * @dev Resets royalty information for the token id back to the global default.
1901      */
1902     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1903         delete _tokenRoyaltyInfo[tokenId];
1904     }
1905 }
1906 
1907 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1908 
1909 /**
1910  * @dev Contract module that helps prevent reentrant calls to a function.
1911  *
1912  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1913  * available, which can be applied to functions to make sure there are no nested
1914  * (reentrant) calls to them.
1915  *
1916  * Note that because there is a single `nonReentrant` guard, functions marked as
1917  * `nonReentrant` may not call one another. This can be worked around by making
1918  * those functions `private`, and then adding `external` `nonReentrant` entry
1919  * points to them.
1920  *
1921  * TIP: If you would like to learn more about reentrancy and alternative ways
1922  * to protect against it, check out our blog post
1923  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1924  */
1925 abstract contract ReentrancyGuard {
1926     // Booleans are more expensive than uint256 or any type that takes up a full
1927     // word because each write operation emits an extra SLOAD to first read the
1928     // slot's contents, replace the bits taken up by the boolean, and then write
1929     // back. This is the compiler's defense against contract upgrades and
1930     // pointer aliasing, and it cannot be disabled.
1931 
1932     // The values being non-zero value makes deployment a bit more expensive,
1933     // but in exchange the refund on every call to nonReentrant will be lower in
1934     // amount. Since refunds are capped to a percentage of the total
1935     // transaction's gas, it is best to keep them low in cases like this one, to
1936     // increase the likelihood of the full refund coming into effect.
1937     uint256 private constant _NOT_ENTERED = 1;
1938     uint256 private constant _ENTERED = 2;
1939 
1940     uint256 private _status;
1941 
1942     constructor() {
1943         _status = _NOT_ENTERED;
1944     }
1945 
1946     /**
1947      * @dev Prevents a contract from calling itself, directly or indirectly.
1948      * Calling a `nonReentrant` function from another `nonReentrant`
1949      * function is not supported. It is possible to prevent this from happening
1950      * by making the `nonReentrant` function external, and making it call a
1951      * `private` function that does the actual work.
1952      */
1953     modifier nonReentrant() {
1954         // On the first call to nonReentrant, _notEntered will be true
1955         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1956 
1957         // Any calls to nonReentrant after this point will fail
1958         _status = _ENTERED;
1959 
1960         _;
1961 
1962         // By storing the original value once again, a refund is triggered (see
1963         // https://eips.ethereum.org/EIPS/eip-2200)
1964         _status = _NOT_ENTERED;
1965     }
1966 }
1967 
1968 
1969 contract Bulies is ERC721A, ERC2981, Ownable, ReentrancyGuard {
1970 
1971     string public baseURI = "https://nftservices.s3.amazonaws.com/bulies/";
1972 
1973     uint256 public tokenPrice = 5000000000000000; //0.005 ETH
1974 
1975     uint public maxTokensPerTx = 20;
1976 
1977     uint public defaultTokensPerTx = 3;
1978 
1979     uint256 public MAX_TOKENS = 8888;
1980 
1981     bool public saleIsActive = true;
1982 
1983     bool public whitelistMintIsActive = false;
1984 
1985     uint256 public whitelistMintRemains = 0;
1986 
1987     uint public maxFreePerUser = 1;
1988 
1989     uint public maxWhitelistPerUser = 20;
1990 
1991     uint public maxTokensWithFeePerTx = 1;
1992 
1993     uint public maxTokensFreePerTx = 1;
1994 
1995     uint public percentRequiredFee = 50;
1996 
1997     mapping (address => uint256) addressToUserFreeMinted;
1998     mapping (address => uint256) addressToUserWhitelistMinted;
1999 
2000     enum TokenURIMode {
2001         MODE_ONE,
2002         MODE_TWO
2003     }
2004 
2005     enum SaleMode{
2006         X_FREE,//1
2007         X_FEE,//2
2008         X_LOTTERY//3
2009     }
2010 
2011     TokenURIMode private tokenUriMode = TokenURIMode.MODE_ONE;
2012 
2013     SaleMode public saleMode = SaleMode.X_LOTTERY;
2014 
2015     constructor(        
2016     ) ERC721A("Bulies", "BUL") {
2017         _setDefaultRoyalty(msg.sender, 200);
2018         _safeMint(msg.sender, 100);
2019     }
2020 
2021 
2022     struct HelperState {
2023         uint256 tokenPrice;
2024         uint256 maxTokensPerTx;
2025         uint256 MAX_TOKENS;
2026         bool saleIsActive;
2027         uint256 totalSupply;
2028         uint  maxFreePerUser;
2029         uint  maxTokensWithFeePerTx;
2030         uint  maxTokensFreePerTx;
2031         uint  percentRequiredFee ;
2032         uint256 userMinted;
2033         uint256 userFreeMinted;
2034         uint lottery;
2035         uint saleMode;
2036         uint defaultTokensPerTx;
2037     }
2038 
2039     function _state(address minter) external view returns (HelperState memory) {
2040         return HelperState({
2041             tokenPrice: tokenPrice,
2042             maxTokensPerTx: maxTokensPerTx,
2043             MAX_TOKENS: MAX_TOKENS,
2044             saleIsActive: saleIsActive,
2045             totalSupply: uint256(totalSupply()),
2046             maxFreePerUser : maxFreePerUser,
2047             maxTokensWithFeePerTx : maxTokensWithFeePerTx,
2048             maxTokensFreePerTx : maxTokensFreePerTx,
2049             percentRequiredFee :percentRequiredFee,
2050             userMinted: uint256(_numberMinted(minter)),
2051             userFreeMinted : addressToUserFreeMinted[minter],
2052             lottery : randomLottery(minter),
2053             saleMode : saleMode == SaleMode.X_FREE ? 1 : (saleMode == SaleMode.X_FEE  ? 2 : saleMode == SaleMode.X_LOTTERY ? 3 : 0),
2054             defaultTokensPerTx : defaultTokensPerTx
2055         });
2056     }
2057 
2058     function withdraw() public onlyOwner {
2059         uint balance = address(this).balance;
2060         payable(msg.sender).transfer(balance);
2061     } 
2062 
2063     function withdrawTo(address to, uint256 amount) public onlyOwner {
2064         require(amount <= address(this).balance, "Request would exceed balance of this contract");
2065         payable(to).transfer(amount);
2066     } 
2067 
2068     function reserveTokens(address to, uint numberOfTokens) public onlyOwner {        
2069         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Request would exceed max supply of tokens");
2070         _safeMint(to, numberOfTokens);
2071     }         
2072     
2073     function setBaseURI(string memory newURI) public onlyOwner {
2074         baseURI = newURI;
2075     }    
2076 
2077     function flipSaleState() public onlyOwner {
2078         saleIsActive = !saleIsActive;
2079     }
2080 
2081     function openWhitelistMint(uint256 _whitelistMintRemains, uint _maxWhitelistPerUser) public onlyOwner{
2082         whitelistMintIsActive = true;
2083         whitelistMintRemains = _whitelistMintRemains;
2084         maxWhitelistPerUser = _maxWhitelistPerUser;
2085         saleIsActive = true;
2086     }
2087 
2088     function closeWhitelistMint()public onlyOwner{
2089         whitelistMintIsActive = false;
2090         whitelistMintRemains = 0;
2091     }
2092 
2093     function whitelistMint(uint numberOfTokens) public payable nonReentrant {
2094         require(saleIsActive, "Sale must be active");
2095         require(numberOfTokens <= maxTokensPerTx, "Purchase would exceed max tokens per tx");
2096         require(numberOfTokens > 0, "You must mint at least one");
2097         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply");
2098         require(whitelistMintIsActive, "Whitelist mint must be active");
2099         require(whitelistMintRemains > 0, "No more whitelist tokens");
2100         require(addressToUserWhitelistMinted[msg.sender] + numberOfTokens <= maxWhitelistPerUser, "Purchase would exceed max free tokens per wallet");
2101         if(whitelistMintRemains - numberOfTokens <= 0){
2102             numberOfTokens = whitelistMintRemains;
2103         }
2104         _safeMint(msg.sender, numberOfTokens);
2105         addressToUserWhitelistMinted[msg.sender] = addressToUserWhitelistMinted[msg.sender] + numberOfTokens;
2106         whitelistMintRemains = whitelistMintRemains - numberOfTokens;
2107         if(whitelistMintRemains <= 0){
2108             whitelistMintIsActive = false;
2109         }
2110     }
2111 
2112     function mintToken(uint numberOfTokens) public payable nonReentrant {
2113         require(saleIsActive, "Sale must be active");
2114         require(numberOfTokens <= maxTokensPerTx, "Purchase would exceed max tokens per tx");
2115         require(numberOfTokens > 0, "You must mint at least one");
2116         require(totalSupply() + numberOfTokens <= MAX_TOKENS, "Purchase would exceed max supply");
2117 
2118         uint256 price = 0;
2119         uint numberFreeTokens = 0;
2120         if ( maxFreePerUser <= addressToUserFreeMinted[msg.sender]  ) {
2121             price = numberOfTokens * tokenPrice;
2122         }
2123         else{
2124             if(saleMode == SaleMode.X_FREE){
2125                 if(numberOfTokens > maxTokensFreePerTx){
2126                     price = (numberOfTokens - maxTokensFreePerTx) * tokenPrice;
2127                     numberFreeTokens = maxTokensFreePerTx;
2128                 } else{
2129                     numberFreeTokens = numberOfTokens;
2130                 }
2131             } else if(saleMode == SaleMode.X_FEE){
2132                 if(numberOfTokens >= maxTokensWithFeePerTx){
2133                     price = maxTokensWithFeePerTx * tokenPrice;
2134                     numberFreeTokens = numberOfTokens - maxTokensWithFeePerTx;
2135                 } else{
2136                     price = numberOfTokens * tokenPrice;
2137                     numberFreeTokens = 0;
2138                 }
2139             } else if(saleMode == SaleMode.X_LOTTERY){
2140                 uint lottery = randomLottery(msg.sender);
2141                 if(lottery <= percentRequiredFee){
2142                     if(numberOfTokens >= maxTokensWithFeePerTx){
2143                         price = maxTokensWithFeePerTx * tokenPrice;
2144                         numberFreeTokens = numberOfTokens - maxTokensWithFeePerTx;
2145                     } else{
2146                         price = numberOfTokens * tokenPrice;
2147                         numberFreeTokens = 0;
2148                     }
2149                 } else{
2150                     numberFreeTokens = numberOfTokens;
2151                 }
2152             }
2153         }
2154 
2155         require(msg.value >= price, "Ether value sent is not correct");
2156         _safeMint(msg.sender, numberOfTokens);
2157 
2158         if(numberFreeTokens > 0){
2159             addressToUserFreeMinted[msg.sender] = addressToUserFreeMinted[msg.sender] + numberFreeTokens;
2160         }
2161         
2162     }
2163 
2164     function setTokenPrice(uint256 newTokenPrice) public onlyOwner{
2165         tokenPrice = newTokenPrice;
2166     }
2167 
2168     function tokenURI(uint256 _tokenId) public view override returns (string memory) 
2169     {
2170         require(_exists(_tokenId), "Token does not exist.");
2171         if (tokenUriMode == TokenURIMode.MODE_TWO) {
2172           return bytes(baseURI).length > 0 ? string(
2173             abi.encodePacked(
2174               baseURI,
2175               Strings.toString(_tokenId)
2176             )
2177           ) : "";
2178         } else {
2179           return bytes(baseURI).length > 0 ? string(
2180             abi.encodePacked(
2181               baseURI,
2182               Strings.toString(_tokenId),
2183               ".json"
2184             )
2185           ) : "";
2186         }
2187     }
2188 
2189     function setTokenURIMode(uint256 mode) external onlyOwner {
2190         if (mode == 2) {
2191             tokenUriMode = TokenURIMode.MODE_TWO;
2192         } else {
2193             tokenUriMode = TokenURIMode.MODE_ONE;
2194         }
2195     }
2196 
2197     function _baseURI() internal view virtual override returns (string memory) {
2198         return baseURI;
2199     }   
2200 
2201     function numberMinted(address owner) public view returns (uint256) {
2202         return _numberMinted(owner);
2203     } 
2204 
2205     function numberFreeMinted(address owner) public view returns (uint256) {
2206         return addressToUserFreeMinted[owner];
2207     } 
2208 
2209     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2210       MAX_TOKENS = _maxSupply;
2211     }
2212 
2213     function setMaxTokensPerTx(uint _maxTokensPerTx) public onlyOwner{
2214         maxTokensPerTx = _maxTokensPerTx;
2215     }
2216 
2217     function setMaxFreePerUser(uint _maxFreePerUser) public onlyOwner{
2218         maxFreePerUser = _maxFreePerUser;
2219     }
2220 
2221     function setMaxTokensWithFeePerTx(uint _maxTokensWithFeePerTx) public onlyOwner{
2222         maxTokensWithFeePerTx = _maxTokensWithFeePerTx;
2223     }
2224 
2225     function setMaxTokensFreePerTx(uint _maxTokensFreePerTx) public onlyOwner{
2226         maxTokensFreePerTx = _maxTokensFreePerTx;
2227     }
2228 
2229     function setSaleMode(uint _saleMode, uint _maxFreePerUser, uint  _maxTokensWithFeePerTx, uint _maxTokensFreePerTx) public onlyOwner{
2230         if(_saleMode == 1){
2231             saleMode = SaleMode.X_FREE;
2232         } else if(_saleMode == 2){
2233             saleMode = SaleMode.X_FEE;
2234         }else if(_saleMode == 3){
2235             saleMode = SaleMode.X_LOTTERY;
2236         }
2237         maxTokensWithFeePerTx = _maxTokensWithFeePerTx;
2238         maxTokensFreePerTx = _maxTokensFreePerTx;
2239         maxFreePerUser = _maxFreePerUser;
2240         saleIsActive = true;
2241     }
2242 
2243     function setPercentRequiredFee (uint _percentRequiredFee) public onlyOwner{
2244         percentRequiredFee = _percentRequiredFee;
2245     }
2246 
2247     function setDefaultTokensPerTx(uint _defaultTokensPerTx) public onlyOwner{
2248         defaultTokensPerTx = _defaultTokensPerTx;
2249     }
2250 
2251     function userWhitelistMinted(address minter) public view returns (uint256){
2252         return addressToUserWhitelistMinted[minter];
2253     }
2254 
2255     /**
2256     @notice Sets the contract-wide royalty info.
2257      */
2258     function setRoyaltyInfo(address receiver, uint96 feeBasisPoints)
2259         external
2260         onlyOwner
2261     {
2262         _setDefaultRoyalty(receiver, feeBasisPoints);
2263     }
2264 
2265     function supportsInterface(bytes4 interfaceId)
2266         public
2267         view
2268         override(ERC721A, ERC2981)
2269         returns (bool)
2270     {
2271         return super.supportsInterface(interfaceId);
2272     }
2273     
2274     function randomLottery(address adr) public view returns (uint){
2275         return uint( keccak256(abi.encodePacked(adr, name())) ) % 100;
2276     }
2277 }