1 // SPDX-License-Identifier: GPL-3.0
2 /*
3       #                                           ##             #                      
4       # ###### #    # #    # # #    #  ####      #  #            #   ##   #    # ###### 
5       # #      ##   # #   #  # ##   # #           ##             #  #  #  #   #  #      
6       # #####  # #  # ####   # # #  #  ####      ###             # #    # ####   #####  
7 #     # #      #  # # #  #   # #  # #      #    #   # #    #     # ###### #  #   #      
8 #     # #      #   ## #   #  # #   ## #    #    #    #     #     # #    # #   #  #      
9  #####  ###### #    # #    # # #    #  ####      ###  #     #####  #    # #    # ###### 
10 */
11 
12 pragma solidity ^0.8.12;
13 
14 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
15 
16 
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
19 
20 
21 
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
112 
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
116 
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
120 
121 
122 
123 /**
124  * @dev Interface of the ERC165 standard, as defined in the
125  * https://eips.ethereum.org/EIPS/eip-165[EIP].
126  *
127  * Implementers can declare support of contract interfaces, which can then be
128  * queried by others ({ERC165Checker}).
129  *
130  * For an implementation, see {ERC165}.
131  */
132 interface IERC165 {
133     /**
134      * @dev Returns true if this contract implements the interface defined by
135      * `interfaceId`. See the corresponding
136      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
137      * to learn more about how these ids are created.
138      *
139      * This function call must use less than 30 000 gas.
140      */
141     function supportsInterface(bytes4 interfaceId) external view returns (bool);
142 }
143 
144 /**
145  * @dev Required interface of an ERC721 compliant contract.
146  */
147 interface IERC721 is IERC165 {
148     /**
149      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
152 
153     /**
154      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
155      */
156     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
157 
158     /**
159      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
160      */
161     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
162 
163     /**
164      * @dev Returns the number of tokens in ``owner``'s account.
165      */
166     function balanceOf(address owner) external view returns (uint256 balance);
167 
168     /**
169      * @dev Returns the owner of the `tokenId` token.
170      *
171      * Requirements:
172      *
173      * - `tokenId` must exist.
174      */
175     function ownerOf(uint256 tokenId) external view returns (address owner);
176 
177     /**
178      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
179      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must exist and be owned by `from`.
186      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
187      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
188      *
189      * Emits a {Transfer} event.
190      */
191     function safeTransferFrom(
192         address from,
193         address to,
194         uint256 tokenId
195     ) external;
196 
197     /**
198      * @dev Transfers `tokenId` token from `from` to `to`.
199      *
200      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
201      *
202      * Requirements:
203      *
204      * - `from` cannot be the zero address.
205      * - `to` cannot be the zero address.
206      * - `tokenId` token must be owned by `from`.
207      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
208      *
209      * Emits a {Transfer} event.
210      */
211     function transferFrom(
212         address from,
213         address to,
214         uint256 tokenId
215     ) external;
216 
217     /**
218      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
219      * The approval is cleared when the token is transferred.
220      *
221      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
222      *
223      * Requirements:
224      *
225      * - The caller must own the token or be an approved operator.
226      * - `tokenId` must exist.
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address to, uint256 tokenId) external;
231 
232     /**
233      * @dev Returns the account approved for `tokenId` token.
234      *
235      * Requirements:
236      *
237      * - `tokenId` must exist.
238      */
239     function getApproved(uint256 tokenId) external view returns (address operator);
240 
241     /**
242      * @dev Approve or remove `operator` as an operator for the caller.
243      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
244      *
245      * Requirements:
246      *
247      * - The `operator` cannot be the caller.
248      *
249      * Emits an {ApprovalForAll} event.
250      */
251     function setApprovalForAll(address operator, bool _approved) external;
252 
253     /**
254      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
255      *
256      * See {setApprovalForAll}
257      */
258     function isApprovedForAll(address owner, address operator) external view returns (bool);
259 
260     /**
261      * @dev Safely transfers `tokenId` token from `from` to `to`.
262      *
263      * Requirements:
264      *
265      * - `from` cannot be the zero address.
266      * - `to` cannot be the zero address.
267      * - `tokenId` token must exist and be owned by `from`.
268      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
269      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
270      *
271      * Emits a {Transfer} event.
272      */
273     function safeTransferFrom(
274         address from,
275         address to,
276         uint256 tokenId,
277         bytes calldata data
278     ) external;
279 }
280 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
281 
282 
283 
284 /**
285  * @title ERC721 token receiver interface
286  * @dev Interface for any contract that wants to support safeTransfers
287  * from ERC721 asset contracts.
288  */
289 interface IERC721Receiver {
290     /**
291      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
292      * by `operator` from `from`, this function is called.
293      *
294      * It must return its Solidity selector to confirm the token transfer.
295      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
296      *
297      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
298      */
299     function onERC721Received(
300         address operator,
301         address from,
302         uint256 tokenId,
303         bytes calldata data
304     ) external returns (bytes4);
305 }
306 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
307 
308 
309 
310 
311 
312 /**
313  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
314  * @dev See https://eips.ethereum.org/EIPS/eip-721
315  */
316 interface IERC721Metadata is IERC721 {
317     /**
318      * @dev Returns the token collection name.
319      */
320     function name() external view returns (string memory);
321 
322     /**
323      * @dev Returns the token collection symbol.
324      */
325     function symbol() external view returns (string memory);
326 
327     /**
328      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
329      */
330     function tokenURI(uint256 tokenId) external view returns (string memory);
331 }
332 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
333 
334 
335 
336 /**
337  * @dev Collection of functions related to the address type
338  */
339 library Address {
340     /**
341      * @dev Returns true if `account` is a contract.
342      *
343      * [IMPORTANT]
344      * ====
345      * It is unsafe to assume that an address for which this function returns
346      * false is an externally-owned account (EOA) and not a contract.
347      *
348      * Among others, `isContract` will return false for the following
349      * types of addresses:
350      *
351      *  - an externally-owned account
352      *  - a contract in construction
353      *  - an address where a contract will be created
354      *  - an address where a contract lived, but was destroyed
355      * ====
356      *
357      * [IMPORTANT]
358      * ====
359      * You shouldn't rely on `isContract` to protect against flash loan attacks!
360      *
361      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
362      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
363      * constructor.
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // This method relies on extcodesize/address.code.length, which returns 0
368         // for contracts in construction, since the code is only stored at the end
369         // of the constructor execution.
370 
371         return account.code.length > 0;
372     }
373 
374     /**
375      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
376      * `recipient`, forwarding all available gas and reverting on errors.
377      *
378      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
379      * of certain opcodes, possibly making contracts go over the 2300 gas limit
380      * imposed by `transfer`, making them unable to receive funds via
381      * `transfer`. {sendValue} removes this limitation.
382      *
383      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
384      *
385      * IMPORTANT: because control is transferred to `recipient`, care must be
386      * taken to not create reentrancy vulnerabilities. Consider using
387      * {ReentrancyGuard} or the
388      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
389      */
390     function sendValue(address payable recipient, uint256 amount) internal {
391         require(address(this).balance >= amount, "Address: insufficient balance");
392 
393         (bool success, ) = recipient.call{value: amount}("");
394         require(success, "Address: unable to send value, recipient may have reverted");
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain `call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionCall(target, data, "Address: low-level call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421      * `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, 0, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but also transferring `value` wei to `target`.
436      *
437      * Requirements:
438      *
439      * - the calling contract must have an ETH balance of at least `value`.
440      * - the called Solidity function must be `payable`.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(
445         address target,
446         bytes memory data,
447         uint256 value
448     ) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
454      * with `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(
459         address target,
460         bytes memory data,
461         uint256 value,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         require(address(this).balance >= value, "Address: insufficient balance for call");
465         require(isContract(target), "Address: call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.call{value: value}(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
478         return functionStaticCall(target, data, "Address: low-level static call failed");
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
483      * but performing a static call.
484      *
485      * _Available since v3.3._
486      */
487     function functionStaticCall(
488         address target,
489         bytes memory data,
490         string memory errorMessage
491     ) internal view returns (bytes memory) {
492         require(isContract(target), "Address: static call to non-contract");
493 
494         (bool success, bytes memory returndata) = target.staticcall(data);
495         return verifyCallResult(success, returndata, errorMessage);
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
500      * but performing a delegate call.
501      *
502      * _Available since v3.4._
503      */
504     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
505         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
510      * but performing a delegate call.
511      *
512      * _Available since v3.4._
513      */
514     function functionDelegateCall(
515         address target,
516         bytes memory data,
517         string memory errorMessage
518     ) internal returns (bytes memory) {
519         require(isContract(target), "Address: delegate call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.delegatecall(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
527      * revert reason using the provided one.
528      *
529      * _Available since v4.3._
530      */
531     function verifyCallResult(
532         bool success,
533         bytes memory returndata,
534         string memory errorMessage
535     ) internal pure returns (bytes memory) {
536         if (success) {
537             return returndata;
538         } else {
539             // Look for revert reason and bubble it up if present
540             if (returndata.length > 0) {
541                 // The easiest way to bubble the revert reason is using memory via assembly
542 
543                 assembly {
544                     let returndata_size := mload(returndata)
545                     revert(add(32, returndata), returndata_size)
546                 }
547             } else {
548                 revert(errorMessage);
549             }
550         }
551     }
552 }
553 
554 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
555 
556 
557 
558 /**
559  * @dev String operations.
560  */
561 library Strings {
562     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
563 
564     /**
565      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
566      */
567     function toString(uint256 value) internal pure returns (string memory) {
568         // Inspired by OraclizeAPI's implementation - MIT licence
569         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
570 
571         if (value == 0) {
572             return "0";
573         }
574         uint256 temp = value;
575         uint256 digits;
576         while (temp != 0) {
577             digits++;
578             temp /= 10;
579         }
580         bytes memory buffer = new bytes(digits);
581         while (value != 0) {
582             digits -= 1;
583             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
584             value /= 10;
585         }
586         return string(buffer);
587     }
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
591      */
592     function toHexString(uint256 value) internal pure returns (string memory) {
593         if (value == 0) {
594             return "0x00";
595         }
596         uint256 temp = value;
597         uint256 length = 0;
598         while (temp != 0) {
599             length++;
600             temp >>= 8;
601         }
602         return toHexString(value, length);
603     }
604 
605     /**
606      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
607      */
608     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
609         bytes memory buffer = new bytes(2 * length + 2);
610         buffer[0] = "0";
611         buffer[1] = "x";
612         for (uint256 i = 2 * length + 1; i > 1; --i) {
613             buffer[i] = _HEX_SYMBOLS[value & 0xf];
614             value >>= 4;
615         }
616         require(value == 0, "Strings: hex length insufficient");
617         return string(buffer);
618     }
619 }
620 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
621 
622 
623 
624 
625 
626 /**
627  * @dev Implementation of the {IERC165} interface.
628  *
629  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
630  * for the additional interface id that will be supported. For example:
631  *
632  * ```solidity
633  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
634  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
635  * }
636  * ```
637  *
638  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
639  */
640 abstract contract ERC165 is IERC165 {
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
645         return interfaceId == type(IERC165).interfaceId;
646     }
647 }
648 
649 /**
650  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
651  * the Metadata extension, but not including the Enumerable extension, which is available separately as
652  * {ERC721Enumerable}.
653  */
654 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
655     using Address for address;
656     using Strings for uint256;
657 
658     // Token name
659     string private _name;
660 
661     // Token symbol
662     string private _symbol;
663 
664     // Mapping from token ID to owner address
665     mapping(uint256 => address) private _owners;
666 
667     // Mapping owner address to token count
668     mapping(address => uint256) private _balances;
669 
670     // Mapping from token ID to approved address
671     mapping(uint256 => address) private _tokenApprovals;
672 
673     // Mapping from owner to operator approvals
674     mapping(address => mapping(address => bool)) private _operatorApprovals;
675 
676     /**
677      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
678      */
679     constructor(string memory name_, string memory symbol_) {
680         _name = name_;
681         _symbol = symbol_;
682     }
683 
684     /**
685      * @dev See {IERC165-supportsInterface}.
686      */
687     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
688         return
689             interfaceId == type(IERC721).interfaceId ||
690             interfaceId == type(IERC721Metadata).interfaceId ||
691             super.supportsInterface(interfaceId);
692     }
693 
694     /**
695      * @dev See {IERC721-balanceOf}.
696      */
697     function balanceOf(address owner) public view virtual override returns (uint256) {
698         require(owner != address(0), "ERC721: balance query for the zero address");
699         return _balances[owner];
700     }
701 
702     /**
703      * @dev See {IERC721-ownerOf}.
704      */
705     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
706         address owner = _owners[tokenId];
707         require(owner != address(0), "ERC721: owner query for nonexistent token");
708         return owner;
709     }
710 
711     /**
712      * @dev See {IERC721Metadata-name}.
713      */
714     function name() public view virtual override returns (string memory) {
715         return _name;
716     }
717 
718     /**
719      * @dev See {IERC721Metadata-symbol}.
720      */
721     function symbol() public view virtual override returns (string memory) {
722         return _symbol;
723     }
724 
725     /**
726      * @dev See {IERC721Metadata-tokenURI}.
727      */
728     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
729         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
730 
731         string memory baseURI = _baseURI();
732         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
733     }
734 
735     /**
736      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
737      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
738      * by default, can be overridden in child contracts.
739      */
740     function _baseURI() internal view virtual returns (string memory) {
741         return "";
742     }
743 
744     /**
745      * @dev See {IERC721-approve}.
746      */
747     function approve(address to, uint256 tokenId) public virtual override {
748         address owner = ERC721.ownerOf(tokenId);
749         require(to != owner, "ERC721: approval to current owner");
750 
751         require(
752             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
753             "ERC721: approve caller is not owner nor approved for all"
754         );
755 
756         _approve(to, tokenId);
757     }
758 
759     /**
760      * @dev See {IERC721-getApproved}.
761      */
762     function getApproved(uint256 tokenId) public view virtual override returns (address) {
763         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
764 
765         return _tokenApprovals[tokenId];
766     }
767 
768     /**
769      * @dev See {IERC721-setApprovalForAll}.
770      */
771     function setApprovalForAll(address operator, bool approved) public virtual override {
772         _setApprovalForAll(_msgSender(), operator, approved);
773     }
774 
775     /**
776      * @dev See {IERC721-isApprovedForAll}.
777      */
778     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
779         return _operatorApprovals[owner][operator];
780     }
781 
782     /**
783      * @dev See {IERC721-transferFrom}.
784      */
785     function transferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) public virtual override {
790         //solhint-disable-next-line max-line-length
791         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
792 
793         _transfer(from, to, tokenId);
794     }
795 
796     /**
797      * @dev See {IERC721-safeTransferFrom}.
798      */
799     function safeTransferFrom(
800         address from,
801         address to,
802         uint256 tokenId
803     ) public virtual override {
804         safeTransferFrom(from, to, tokenId, "");
805     }
806 
807     /**
808      * @dev See {IERC721-safeTransferFrom}.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId,
814         bytes memory _data
815     ) public virtual override {
816         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
817         _safeTransfer(from, to, tokenId, _data);
818     }
819 
820     /**
821      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
822      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
823      *
824      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
825      *
826      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
827      * implement alternative mechanisms to perform token transfer, such as signature-based.
828      *
829      * Requirements:
830      *
831      * - `from` cannot be the zero address.
832      * - `to` cannot be the zero address.
833      * - `tokenId` token must exist and be owned by `from`.
834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function _safeTransfer(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) internal virtual {
844         _transfer(from, to, tokenId);
845         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
846     }
847 
848     /**
849      * @dev Returns whether `tokenId` exists.
850      *
851      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
852      *
853      * Tokens start existing when they are minted (`_mint`),
854      * and stop existing when they are burned (`_burn`).
855      */
856     function _exists(uint256 tokenId) internal view virtual returns (bool) {
857         return _owners[tokenId] != address(0);
858     }
859 
860     /**
861      * @dev Returns whether `spender` is allowed to manage `tokenId`.
862      *
863      * Requirements:
864      *
865      * - `tokenId` must exist.
866      */
867     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
868         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
869         address owner = ERC721.ownerOf(tokenId);
870         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
871     }
872 
873     /**
874      * @dev Safely mints `tokenId` and transfers it to `to`.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must not exist.
879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880      *
881      * Emits a {Transfer} event.
882      */
883     function _safeMint(address to, uint256 tokenId) internal virtual {
884         _safeMint(to, tokenId, "");
885     }
886 
887     /**
888      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
889      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
890      */
891     function _safeMint(
892         address to,
893         uint256 tokenId,
894         bytes memory _data
895     ) internal virtual {
896         _mint(to, tokenId);
897         require(
898             _checkOnERC721Received(address(0), to, tokenId, _data),
899             "ERC721: transfer to non ERC721Receiver implementer"
900         );
901     }
902 
903     /**
904      * @dev Mints `tokenId` and transfers it to `to`.
905      *
906      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
907      *
908      * Requirements:
909      *
910      * - `tokenId` must not exist.
911      * - `to` cannot be the zero address.
912      *
913      * Emits a {Transfer} event.
914      */
915     function _mint(address to, uint256 tokenId) internal virtual {
916         require(to != address(0), "ERC721: mint to the zero address");
917         require(!_exists(tokenId), "ERC721: token already minted");
918 
919         _beforeTokenTransfer(address(0), to, tokenId);
920 
921         _balances[to] += 1;
922         _owners[tokenId] = to;
923 
924         emit Transfer(address(0), to, tokenId);
925 
926         _afterTokenTransfer(address(0), to, tokenId);
927     }
928 
929     /**
930      * @dev Destroys `tokenId`.
931      * The approval is cleared when the token is burned.
932      *
933      * Requirements:
934      *
935      * - `tokenId` must exist.
936      *
937      * Emits a {Transfer} event.
938      */
939     function _burn(uint256 tokenId) internal virtual {
940         address owner = ERC721.ownerOf(tokenId);
941 
942         _beforeTokenTransfer(owner, address(0), tokenId);
943 
944         // Clear approvals
945         _approve(address(0), tokenId);
946 
947         _balances[owner] -= 1;
948         delete _owners[tokenId];
949 
950         emit Transfer(owner, address(0), tokenId);
951 
952         _afterTokenTransfer(owner, address(0), tokenId);
953     }
954 
955     /**
956      * @dev Transfers `tokenId` from `from` to `to`.
957      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
958      *
959      * Requirements:
960      *
961      * - `to` cannot be the zero address.
962      * - `tokenId` token must be owned by `from`.
963      *
964      * Emits a {Transfer} event.
965      */
966     function _transfer(
967         address from,
968         address to,
969         uint256 tokenId
970     ) internal virtual {
971         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
972         require(to != address(0), "ERC721: transfer to the zero address");
973 
974         _beforeTokenTransfer(from, to, tokenId);
975 
976         // Clear approvals from the previous owner
977         _approve(address(0), tokenId);
978 
979         _balances[from] -= 1;
980         _balances[to] += 1;
981         _owners[tokenId] = to;
982 
983         emit Transfer(from, to, tokenId);
984 
985         _afterTokenTransfer(from, to, tokenId);
986     }
987 
988     /**
989      * @dev Approve `to` to operate on `tokenId`
990      *
991      * Emits a {Approval} event.
992      */
993     function _approve(address to, uint256 tokenId) internal virtual {
994         _tokenApprovals[tokenId] = to;
995         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
996     }
997 
998     /**
999      * @dev Approve `operator` to operate on all of `owner` tokens
1000      *
1001      * Emits a {ApprovalForAll} event.
1002      */
1003     function _setApprovalForAll(
1004         address owner,
1005         address operator,
1006         bool approved
1007     ) internal virtual {
1008         require(owner != operator, "ERC721: approve to caller");
1009         _operatorApprovals[owner][operator] = approved;
1010         emit ApprovalForAll(owner, operator, approved);
1011     }
1012 
1013     /**
1014      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1015      * The call is not executed if the target address is not a contract.
1016      *
1017      * @param from address representing the previous owner of the given token ID
1018      * @param to target address that will receive the tokens
1019      * @param tokenId uint256 ID of the token to be transferred
1020      * @param _data bytes optional data to send along with the call
1021      * @return bool whether the call correctly returned the expected magic value
1022      */
1023     function _checkOnERC721Received(
1024         address from,
1025         address to,
1026         uint256 tokenId,
1027         bytes memory _data
1028     ) private returns (bool) {
1029         if (to.isContract()) {
1030             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1031                 return retval == IERC721Receiver.onERC721Received.selector;
1032             } catch (bytes memory reason) {
1033                 if (reason.length == 0) {
1034                     revert("ERC721: transfer to non ERC721Receiver implementer");
1035                 } else {
1036                     assembly {
1037                         revert(add(32, reason), mload(reason))
1038                     }
1039                 }
1040             }
1041         } else {
1042             return true;
1043         }
1044     }
1045 
1046     /**
1047      * @dev Hook that is called before any token transfer. This includes minting
1048      * and burning.
1049      *
1050      * Calling conditions:
1051      *
1052      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1053      * transferred to `to`.
1054      * - When `from` is zero, `tokenId` will be minted for `to`.
1055      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1056      * - `from` and `to` are never both zero.
1057      *
1058      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1059      */
1060     function _beforeTokenTransfer(
1061         address from,
1062         address to,
1063         uint256 tokenId
1064     ) internal virtual {}
1065 
1066     /**
1067      * @dev Hook that is called after any transfer of tokens. This includes
1068      * minting and burning.
1069      *
1070      * Calling conditions:
1071      *
1072      * - when `from` and `to` are both non-zero.
1073      * - `from` and `to` are never both zero.
1074      *
1075      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1076      */
1077     function _afterTokenTransfer(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) internal virtual {}
1082 }
1083 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
1084 
1085 
1086 
1087 /**
1088  * @dev These functions deal with verification of Merkle Trees proofs.
1089  *
1090  * The proofs can be generated using the JavaScript library
1091  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1092  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1093  *
1094  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1095  *
1096  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1097  * hashing, or use a hash function other than keccak256 for hashing leaves.
1098  * This is because the concatenation of a sorted pair of internal nodes in
1099  * the merkle tree could be reinterpreted as a leaf value.
1100  */
1101 library MerkleProof {
1102     /**
1103      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1104      * defined by `root`. For this, a `proof` must be provided, containing
1105      * sibling hashes on the branch from the leaf to the root of the tree. Each
1106      * pair of leaves and each pair of pre-images are assumed to be sorted.
1107      */
1108     function verify(
1109         bytes32[] memory proof,
1110         bytes32 root,
1111         bytes32 leaf
1112     ) internal pure returns (bool) {
1113         return processProof(proof, leaf) == root;
1114     }
1115 
1116     /**
1117      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1118      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1119      * hash matches the root of the tree. When processing the proof, the pairs
1120      * of leafs & pre-images are assumed to be sorted.
1121      *
1122      * _Available since v4.4._
1123      */
1124     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1125         bytes32 computedHash = leaf;
1126         for (uint256 i = 0; i < proof.length; i++) {
1127             bytes32 proofElement = proof[i];
1128             if (computedHash <= proofElement) {
1129                 // Hash(current computed hash + current element of the proof)
1130                 computedHash = _efficientHash(computedHash, proofElement);
1131             } else {
1132                 // Hash(current element of the proof + current computed hash)
1133                 computedHash = _efficientHash(proofElement, computedHash);
1134             }
1135         }
1136         return computedHash;
1137     }
1138 
1139     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1140         assembly {
1141             mstore(0x00, a)
1142             mstore(0x20, b)
1143             value := keccak256(0x00, 0x40)
1144         }
1145     }
1146 }
1147 
1148 
1149 contract JakeXJenkins is ERC721, Ownable {
1150     bytes32 public merkleRoot = ""; // Construct this from (address, amount) tuple elements
1151     mapping(address => uint) public whitelistRemaining; // Maps user address to their remaining mints if they have minted some but not all of their allocation
1152     mapping(address => bool) public whitelistUsed; // Maps user address to bool, true if user has minted
1153 
1154     uint public totalSupply = 0;
1155     string public _baseTokenURI;
1156 
1157     event Mint(address indexed owner, uint indexed tokenId);
1158 
1159     constructor() ERC721("Jake x Jenkins", "JXJ") {}
1160 
1161     /// @notice Mint to the owner
1162     function ownerMint(uint amount) external onlyOwner {
1163         _mintWithoutValidation(msg.sender, amount);
1164     }
1165 
1166     /// @notice Mint from whitelist allocation
1167     function whitelistMint(uint amount, uint totalAllocation, bytes32 leaf, bytes32[] memory proof) external {
1168         // Create storage element tracking user mints if this is the first mint for them
1169         if (!whitelistUsed[msg.sender]) {        
1170             // Verify that (msg.sender, amount) correspond to Merkle leaf
1171             require(keccak256(abi.encodePacked(msg.sender, totalAllocation)) == leaf, "Sender and amount don't match Merkle leaf");
1172 
1173             // Verify that (leaf, proof) matches the Merkle root
1174             require(verify(merkleRoot, leaf, proof), "Not a valid leaf in the Merkle tree");
1175 
1176             whitelistUsed[msg.sender] = true;
1177             whitelistRemaining[msg.sender] = totalAllocation;
1178         }
1179 
1180         // Require nonzero amount
1181         require(amount > 0, "Can't mint zero");
1182 
1183         require(whitelistRemaining[msg.sender] >= amount, "Can't mint more than remaining allocation");
1184 
1185         whitelistRemaining[msg.sender] -= amount;
1186         _mintWithoutValidation(msg.sender, amount);
1187     }
1188 
1189     /// @notice Perform raw minting
1190     function _mintWithoutValidation(address to, uint amount) internal {
1191         for (uint i = 0; i < amount; i++) {
1192             _mint(to, totalSupply);
1193             emit Mint(to, totalSupply);
1194             totalSupply += 1;
1195         }
1196     }
1197 
1198     /// @notice Ensure the proof and leaf match the merkle root
1199     function verify(bytes32 root, bytes32 leaf, bytes32[] memory proof) public pure returns (bool) {
1200         return MerkleProof.verify(proof, root, leaf);
1201     }
1202 
1203     // ADMIN FUNCTIONALITY
1204 
1205     /// @notice Set metadata
1206     function setBaseTokenURI(string memory __baseTokenURI) public onlyOwner {
1207         _baseTokenURI = __baseTokenURI;
1208     }
1209 
1210     /// @notice Set merkle root
1211     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1212         merkleRoot = _merkleRoot;
1213     }
1214 
1215     // METADATA FUNCTIONALITY
1216 
1217     /// @notice Returns the metadata URI for a given token
1218     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1219         return string(abi.encodePacked(_baseTokenURI, Strings.toString(_tokenId)));
1220     }
1221 }
1222 
