1 // SPDX-License-Identifier: MIT
2 /*
3 
4    ▄████████    ▄████████ ███▄▄▄▄      ▄████████    ▄█    █▄     ▄█          ▄████████  ▄██████▄  ███    █▄   ▄█          ▄████████ 
5   ███    ███   ███    ███ ███▀▀▀██▄   ███    ███   ███    ███   ███         ███    ███ ███    ███ ███    ███ ███         ███    ███ 
6   ███    █▀    ███    █▀  ███   ███   ███    █▀    ███    ███   ███▌        ███    █▀  ███    ███ ███    ███ ███         ███    █▀  
7   ███         ▄███▄▄▄     ███   ███   ███         ▄███▄▄▄▄███▄▄ ███▌        ███        ███    ███ ███    ███ ███         ███        
8 ▀███████████ ▀▀███▀▀▀     ███   ███ ▀███████████ ▀▀███▀▀▀▀███▀  ███▌      ▀███████████ ███    ███ ███    ███ ███       ▀███████████ 
9          ███   ███    █▄  ███   ███          ███   ███    ███   ███                ███ ███    ███ ███    ███ ███                ███ 
10    ▄█    ███   ███    ███ ███   ███    ▄█    ███   ███    ███   ███          ▄█    ███ ███    ███ ███    ███ ███▌    ▄    ▄█    ███ 
11  ▄████████▀    ██████████  ▀█   █▀   ▄████████▀    ███    █▀    █▀         ▄████████▀   ▀██████▀  ████████▀  █████▄▄██  ▄████████▀  
12                                                                                                              ▀                      
13                                                          By Devko.dev#7286
14  */
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @title Counters
19  * @author Matt Condon (@shrugs)
20  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
21  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
22  *
23  * Include with `using Counters for Counters.Counter;`
24  */
25 library Counters {
26     struct Counter {
27         // This variable should never be directly accessed by users of the library: interactions must be restricted to
28         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
29         // this feature: see https://github.com/ethereum/solidity/issues/4637
30         uint256 _value; // default: 0
31     }
32 
33     function current(Counter storage counter) internal view returns (uint256) {
34         return counter._value;
35     }
36 
37     function increment(Counter storage counter) internal {
38         unchecked {
39             counter._value += 1;
40         }
41     }
42 
43     function decrement(Counter storage counter) internal {
44         uint256 value = counter._value;
45         require(value > 0, "Counter: decrement overflow");
46         unchecked {
47             counter._value = value - 1;
48         }
49     }
50 
51     function reset(Counter storage counter) internal {
52         counter._value = 0;
53     }
54 }
55 
56 pragma solidity ^0.8.0;
57 
58 /**
59  * @dev String operations.
60  */
61 library Strings {
62     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
66      */
67     function toString(uint256 value) internal pure returns (string memory) {
68         // Inspired by OraclizeAPI's implementation - MIT licence
69         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
70 
71         if (value == 0) {
72             return "0";
73         }
74         uint256 temp = value;
75         uint256 digits;
76         while (temp != 0) {
77             digits++;
78             temp /= 10;
79         }
80         bytes memory buffer = new bytes(digits);
81         while (value != 0) {
82             digits -= 1;
83             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
84             value /= 10;
85         }
86         return string(buffer);
87     }
88 
89     /**
90      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
91      */
92     function toHexString(uint256 value) internal pure returns (string memory) {
93         if (value == 0) {
94             return "0x00";
95         }
96         uint256 temp = value;
97         uint256 length = 0;
98         while (temp != 0) {
99             length++;
100             temp >>= 8;
101         }
102         return toHexString(value, length);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
107      */
108     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
109         bytes memory buffer = new bytes(2 * length + 2);
110         buffer[0] = "0";
111         buffer[1] = "x";
112         for (uint256 i = 2 * length + 1; i > 1; --i) {
113             buffer[i] = _HEX_SYMBOLS[value & 0xf];
114             value >>= 4;
115         }
116         require(value == 0, "Strings: hex length insufficient");
117         return string(buffer);
118     }
119 }
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Provides information about the current execution context, including the
125  * sender of the transaction and its data. While these are generally available
126  * via msg.sender and msg.data, they should not be accessed in such a direct
127  * manner, since when dealing with meta-transactions the account sending and
128  * paying for execution may not be the actual sender (as far as an application
129  * is concerned).
130  *
131  * This contract is only required for intermediate, library-like contracts.
132  */
133 abstract contract Context {
134     function _msgSender() internal view virtual returns (address) {
135         return msg.sender;
136     }
137 
138     function _msgData() internal view virtual returns (bytes calldata) {
139         return msg.data;
140     }
141 }
142 
143 pragma solidity ^0.8.0;
144 
145 
146 /**
147  * @dev Contract module which provides a basic access control mechanism, where
148  * there is an account (an owner) that can be granted exclusive access to
149  * specific functions.
150  *
151  * By default, the owner account will be the one that deploys the contract. This
152  * can later be changed with {transferOwnership}.
153  *
154  * This module is used through inheritance. It will make available the modifier
155  * `onlyOwner`, which can be applied to your functions to restrict their use to
156  * the owner.
157  */
158 abstract contract Ownable is Context {
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     /**
164      * @dev Initializes the contract setting the deployer as the initial owner.
165      */
166     constructor() {
167         _transferOwnership(_msgSender());
168     }
169 
170     /**
171      * @dev Returns the address of the current owner.
172      */
173     function owner() public view virtual returns (address) {
174         return _owner;
175     }
176 
177     /**
178      * @dev Throws if called by any account other than the owner.
179      */
180     modifier onlyOwner() {
181         require(owner() == _msgSender(), "Ownable: caller is not the owner");
182         _;
183     }
184 
185     /**
186      * @dev Leaves the contract without owner. It will not be possible to call
187      * `onlyOwner` functions anymore. Can only be called by the current owner.
188      *
189      * NOTE: Renouncing ownership will leave the contract without an owner,
190      * thereby removing any functionality that is only available to the owner.
191      */
192     function renounceOwnership() public virtual onlyOwner {
193         _transferOwnership(address(0));
194     }
195 
196     /**
197      * @dev Transfers ownership of the contract to a new account (`newOwner`).
198      * Can only be called by the current owner.
199      */
200     function transferOwnership(address newOwner) public virtual onlyOwner {
201         require(newOwner != address(0), "Ownable: new owner is the zero address");
202         _transferOwnership(newOwner);
203     }
204 
205     /**
206      * @dev Transfers ownership of the contract to a new account (`newOwner`).
207      * Internal function without access restriction.
208      */
209     function _transferOwnership(address newOwner) internal virtual {
210         address oldOwner = _owner;
211         _owner = newOwner;
212         emit OwnershipTransferred(oldOwner, newOwner);
213     }
214 }
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @dev Collection of functions related to the address type
220  */
221 library Address {
222     /**
223      * @dev Returns true if `account` is a contract.
224      *
225      * [IMPORTANT]
226      * ====
227      * It is unsafe to assume that an address for which this function returns
228      * false is an externally-owned account (EOA) and not a contract.
229      *
230      * Among others, `isContract` will return false for the following
231      * types of addresses:
232      *
233      *  - an externally-owned account
234      *  - a contract in construction
235      *  - an address where a contract will be created
236      *  - an address where a contract lived, but was destroyed
237      * ====
238      */
239     function isContract(address account) internal view returns (bool) {
240         // This method relies on extcodesize, which returns 0 for contracts in
241         // construction, since the code is only stored at the end of the
242         // constructor execution.
243 
244         uint256 size;
245         assembly {
246             size := extcodesize(account)
247         }
248         return size > 0;
249     }
250 
251     /**
252      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
253      * `recipient`, forwarding all available gas and reverting on errors.
254      *
255      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
256      * of certain opcodes, possibly making contracts go over the 2300 gas limit
257      * imposed by `transfer`, making them unable to receive funds via
258      * `transfer`. {sendValue} removes this limitation.
259      *
260      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
261      *
262      * IMPORTANT: because control is transferred to `recipient`, care must be
263      * taken to not create reentrancy vulnerabilities. Consider using
264      * {ReentrancyGuard} or the
265      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
266      */
267     function sendValue(address payable recipient, uint256 amount) internal {
268         require(address(this).balance >= amount, "Address: insufficient balance");
269 
270         (bool success, ) = recipient.call{value: amount}("");
271         require(success, "Address: unable to send value, recipient may have reverted");
272     }
273 
274     /**
275      * @dev Performs a Solidity function call using a low level `call`. A
276      * plain `call` is an unsafe replacement for a function call: use this
277      * function instead.
278      *
279      * If `target` reverts with a revert reason, it is bubbled up by this
280      * function (like regular Solidity function calls).
281      *
282      * Returns the raw returned data. To convert to the expected return value,
283      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
284      *
285      * Requirements:
286      *
287      * - `target` must be a contract.
288      * - calling `target` with `data` must not revert.
289      *
290      * _Available since v3.1._
291      */
292     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionCall(target, data, "Address: low-level call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
298      * `errorMessage` as a fallback revert reason when `target` reverts.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, 0, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but also transferring `value` wei to `target`.
313      *
314      * Requirements:
315      *
316      * - the calling contract must have an ETH balance of at least `value`.
317      * - the called Solidity function must be `payable`.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(
322         address target,
323         bytes memory data,
324         uint256 value
325     ) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         require(address(this).balance >= value, "Address: insufficient balance for call");
342         require(isContract(target), "Address: call to non-contract");
343 
344         (bool success, bytes memory returndata) = target.call{value: value}(data);
345         return verifyCallResult(success, returndata, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
355         return functionStaticCall(target, data, "Address: low-level static call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
360      * but performing a static call.
361      *
362      * _Available since v3.3._
363      */
364     function functionStaticCall(
365         address target,
366         bytes memory data,
367         string memory errorMessage
368     ) internal view returns (bytes memory) {
369         require(isContract(target), "Address: static call to non-contract");
370 
371         (bool success, bytes memory returndata) = target.staticcall(data);
372         return verifyCallResult(success, returndata, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but performing a delegate call.
378      *
379      * _Available since v3.4._
380      */
381     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         require(isContract(target), "Address: delegate call to non-contract");
397 
398         (bool success, bytes memory returndata) = target.delegatecall(data);
399         return verifyCallResult(success, returndata, errorMessage);
400     }
401 
402     /**
403      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
404      * revert reason using the provided one.
405      *
406      * _Available since v4.3._
407      */
408     function verifyCallResult(
409         bool success,
410         bytes memory returndata,
411         string memory errorMessage
412     ) internal pure returns (bytes memory) {
413         if (success) {
414             return returndata;
415         } else {
416             // Look for revert reason and bubble it up if present
417             if (returndata.length > 0) {
418                 // The easiest way to bubble the revert reason is using memory via assembly
419 
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 }
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @title ERC721 token receiver interface
435  * @dev Interface for any contract that wants to support safeTransfers
436  * from ERC721 asset contracts.
437  */
438 interface IERC721Receiver {
439     /**
440      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
441      * by `operator` from `from`, this function is called.
442      *
443      * It must return its Solidity selector to confirm the token transfer.
444      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
445      *
446      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
447      */
448     function onERC721Received(
449         address operator,
450         address from,
451         uint256 tokenId,
452         bytes calldata data
453     ) external returns (bytes4);
454 }
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Interface of the ERC165 standard, as defined in the
460  * https://eips.ethereum.org/EIPS/eip-165[EIP].
461  *
462  * Implementers can declare support of contract interfaces, which can then be
463  * queried by others ({ERC165Checker}).
464  *
465  * For an implementation, see {ERC165}.
466  */
467 interface IERC165 {
468     /**
469      * @dev Returns true if this contract implements the interface defined by
470      * `interfaceId`. See the corresponding
471      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
472      * to learn more about how these ids are created.
473      *
474      * This function call must use less than 30 000 gas.
475      */
476     function supportsInterface(bytes4 interfaceId) external view returns (bool);
477 }
478 
479 pragma solidity ^0.8.0;
480 
481 
482 /**
483  * @dev Implementation of the {IERC165} interface.
484  *
485  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
486  * for the additional interface id that will be supported. For example:
487  *
488  * ```solidity
489  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
490  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
491  * }
492  * ```
493  *
494  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
495  */
496 abstract contract ERC165 is IERC165 {
497     /**
498      * @dev See {IERC165-supportsInterface}.
499      */
500     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
501         return interfaceId == type(IERC165).interfaceId;
502     }
503 }
504 
505 pragma solidity ^0.8.0;
506 
507 
508 /**
509  * @dev Required interface of an ERC721 compliant contract.
510  */
511 interface IERC721 is IERC165 {
512     /**
513      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
514      */
515     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
516 
517     /**
518      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
519      */
520     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
521 
522     /**
523      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
524      */
525     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
526 
527     /**
528      * @dev Returns the number of tokens in ``owner``'s account.
529      */
530     function balanceOf(address owner) external view returns (uint256 balance);
531 
532     /**
533      * @dev Returns the owner of the `tokenId` token.
534      *
535      * Requirements:
536      *
537      * - `tokenId` must exist.
538      */
539     function ownerOf(uint256 tokenId) external view returns (address owner);
540 
541     /**
542      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
543      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
544      *
545      * Requirements:
546      *
547      * - `from` cannot be the zero address.
548      * - `to` cannot be the zero address.
549      * - `tokenId` token must exist and be owned by `from`.
550      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
551      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
552      *
553      * Emits a {Transfer} event.
554      */
555     function safeTransferFrom(
556         address from,
557         address to,
558         uint256 tokenId
559     ) external;
560 
561     /**
562      * @dev Transfers `tokenId` token from `from` to `to`.
563      *
564      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
565      *
566      * Requirements:
567      *
568      * - `from` cannot be the zero address.
569      * - `to` cannot be the zero address.
570      * - `tokenId` token must be owned by `from`.
571      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
572      *
573      * Emits a {Transfer} event.
574      */
575     function transferFrom(
576         address from,
577         address to,
578         uint256 tokenId
579     ) external;
580 
581     /**
582      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
583      * The approval is cleared when the token is transferred.
584      *
585      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
586      *
587      * Requirements:
588      *
589      * - The caller must own the token or be an approved operator.
590      * - `tokenId` must exist.
591      *
592      * Emits an {Approval} event.
593      */
594     function approve(address to, uint256 tokenId) external;
595 
596     /**
597      * @dev Returns the account approved for `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function getApproved(uint256 tokenId) external view returns (address operator);
604 
605     /**
606      * @dev Approve or remove `operator` as an operator for the caller.
607      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
608      *
609      * Requirements:
610      *
611      * - The `operator` cannot be the caller.
612      *
613      * Emits an {ApprovalForAll} event.
614      */
615     function setApprovalForAll(address operator, bool _approved) external;
616 
617     /**
618      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
619      *
620      * See {setApprovalForAll}
621      */
622     function isApprovedForAll(address owner, address operator) external view returns (bool);
623 
624     /**
625      * @dev Safely transfers `tokenId` token from `from` to `to`.
626      *
627      * Requirements:
628      *
629      * - `from` cannot be the zero address.
630      * - `to` cannot be the zero address.
631      * - `tokenId` token must exist and be owned by `from`.
632      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
634      *
635      * Emits a {Transfer} event.
636      */
637     function safeTransferFrom(
638         address from,
639         address to,
640         uint256 tokenId,
641         bytes calldata data
642     ) external;
643 }
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
650  * @dev See https://eips.ethereum.org/EIPS/eip-721
651  */
652 interface IERC721Metadata is IERC721 {
653     /**
654      * @dev Returns the token collection name.
655      */
656     function name() external view returns (string memory);
657 
658     /**
659      * @dev Returns the token collection symbol.
660      */
661     function symbol() external view returns (string memory);
662 
663     /**
664      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
665      */
666     function tokenURI(uint256 tokenId) external view returns (string memory);
667 }
668 
669 pragma solidity ^0.8.0;
670 
671 
672 /**
673  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
674  * the Metadata extension, but not including the Enumerable extension, which is available separately as
675  * {ERC721Enumerable}.
676  */
677 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
678     using Address for address;
679     using Strings for uint256;
680 
681     // Token name
682     string private _name;
683 
684     // Token symbol
685     string private _symbol;
686 
687     // Mapping from token ID to owner address
688     mapping(uint256 => address) private _owners;
689 
690     // Mapping owner address to token count
691     mapping(address => uint256) private _balances;
692 
693     // Mapping from token ID to approved address
694     mapping(uint256 => address) private _tokenApprovals;
695 
696     // Mapping from owner to operator approvals
697     mapping(address => mapping(address => bool)) private _operatorApprovals;
698 
699     /**
700      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
701      */
702     constructor(string memory name_, string memory symbol_) {
703         _name = name_;
704         _symbol = symbol_;
705     }
706 
707     /**
708      * @dev See {IERC165-supportsInterface}.
709      */
710     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
711         return
712             interfaceId == type(IERC721).interfaceId ||
713             interfaceId == type(IERC721Metadata).interfaceId ||
714             super.supportsInterface(interfaceId);
715     }
716 
717     /**
718      * @dev See {IERC721-balanceOf}.
719      */
720     function balanceOf(address owner) public view virtual override returns (uint256) {
721         require(owner != address(0), "ERC721: balance query for the zero address");
722         return _balances[owner];
723     }
724 
725     /**
726      * @dev See {IERC721-ownerOf}.
727      */
728     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
729         address owner = _owners[tokenId];
730         require(owner != address(0), "ERC721: owner query for nonexistent token");
731         return owner;
732     }
733 
734     /**
735      * @dev See {IERC721Metadata-name}.
736      */
737     function name() public view virtual override returns (string memory) {
738         return _name;
739     }
740 
741     /**
742      * @dev See {IERC721Metadata-symbol}.
743      */
744     function symbol() public view virtual override returns (string memory) {
745         return _symbol;
746     }
747 
748     /**
749      * @dev See {IERC721Metadata-tokenURI}.
750      */
751     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
752         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
753 
754         string memory baseURI = _baseURI();
755         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
756     }
757 
758     /**
759      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
760      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
761      * by default, can be overriden in child contracts.
762      */
763     function _baseURI() internal view virtual returns (string memory) {
764         return "";
765     }
766 
767     /**
768      * @dev See {IERC721-approve}.
769      */
770     function approve(address to, uint256 tokenId) public virtual override {
771         address owner = ERC721.ownerOf(tokenId);
772         require(to != owner, "ERC721: approval to current owner");
773 
774         require(
775             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
776             "ERC721: approve caller is not owner nor approved for all"
777         );
778 
779         _approve(to, tokenId);
780     }
781 
782     /**
783      * @dev See {IERC721-getApproved}.
784      */
785     function getApproved(uint256 tokenId) public view virtual override returns (address) {
786         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
787 
788         return _tokenApprovals[tokenId];
789     }
790 
791     /**
792      * @dev See {IERC721-setApprovalForAll}.
793      */
794     function setApprovalForAll(address operator, bool approved) public virtual override {
795         _setApprovalForAll(_msgSender(), operator, approved);
796     }
797 
798     /**
799      * @dev See {IERC721-isApprovedForAll}.
800      */
801     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
802         return _operatorApprovals[owner][operator];
803     }
804 
805     /**
806      * @dev See {IERC721-transferFrom}.
807      */
808     function transferFrom(
809         address from,
810         address to,
811         uint256 tokenId
812     ) public virtual override {
813         //solhint-disable-next-line max-line-length
814         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
815 
816         _transfer(from, to, tokenId);
817     }
818 
819     /**
820      * @dev See {IERC721-safeTransferFrom}.
821      */
822     function safeTransferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) public virtual override {
827         safeTransferFrom(from, to, tokenId, "");
828     }
829 
830     /**
831      * @dev See {IERC721-safeTransferFrom}.
832      */
833     function safeTransferFrom(
834         address from,
835         address to,
836         uint256 tokenId,
837         bytes memory _data
838     ) public virtual override {
839         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
840         _safeTransfer(from, to, tokenId, _data);
841     }
842 
843     /**
844      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
845      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
846      *
847      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
848      *
849      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
850      * implement alternative mechanisms to perform token transfer, such as signature-based.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must exist and be owned by `from`.
857      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
858      *
859      * Emits a {Transfer} event.
860      */
861     function _safeTransfer(
862         address from,
863         address to,
864         uint256 tokenId,
865         bytes memory _data
866     ) internal virtual {
867         _transfer(from, to, tokenId);
868         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
869     }
870 
871     /**
872      * @dev Returns whether `tokenId` exists.
873      *
874      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
875      *
876      * Tokens start existing when they are minted (`_mint`),
877      * and stop existing when they are burned (`_burn`).
878      */
879     function _exists(uint256 tokenId) internal view virtual returns (bool) {
880         return _owners[tokenId] != address(0);
881     }
882 
883     /**
884      * @dev Returns whether `spender` is allowed to manage `tokenId`.
885      *
886      * Requirements:
887      *
888      * - `tokenId` must exist.
889      */
890     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
891         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
892         address owner = ERC721.ownerOf(tokenId);
893         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
894     }
895 
896     /**
897      * @dev Safely mints `tokenId` and transfers it to `to`.
898      *
899      * Requirements:
900      *
901      * - `tokenId` must not exist.
902      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
903      *
904      * Emits a {Transfer} event.
905      */
906     function _safeMint(address to, uint256 tokenId) internal virtual {
907         _safeMint(to, tokenId, "");
908     }
909 
910     /**
911      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
912      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
913      */
914     function _safeMint(
915         address to,
916         uint256 tokenId,
917         bytes memory _data
918     ) internal virtual {
919         _mint(to, tokenId);
920         require(
921             _checkOnERC721Received(address(0), to, tokenId, _data),
922             "ERC721: transfer to non ERC721Receiver implementer"
923         );
924     }
925 
926     /**
927      * @dev Mints `tokenId` and transfers it to `to`.
928      *
929      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
930      *
931      * Requirements:
932      *
933      * - `tokenId` must not exist.
934      * - `to` cannot be the zero address.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _mint(address to, uint256 tokenId) internal virtual {
939         require(to != address(0), "ERC721: mint to the zero address");
940         require(!_exists(tokenId), "ERC721: token already minted");
941 
942         _beforeTokenTransfer(address(0), to, tokenId);
943 
944         _balances[to] += 1;
945         _owners[tokenId] = to;
946 
947         emit Transfer(address(0), to, tokenId);
948     }
949 
950     /**
951      * @dev Destroys `tokenId`.
952      * The approval is cleared when the token is burned.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _burn(uint256 tokenId) internal virtual {
961         address owner = ERC721.ownerOf(tokenId);
962 
963         _beforeTokenTransfer(owner, address(0), tokenId);
964 
965         // Clear approvals
966         _approve(address(0), tokenId);
967 
968         _balances[owner] -= 1;
969         delete _owners[tokenId];
970 
971         emit Transfer(owner, address(0), tokenId);
972     }
973 
974     /**
975      * @dev Transfers `tokenId` from `from` to `to`.
976      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
977      *
978      * Requirements:
979      *
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must be owned by `from`.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _transfer(
986         address from,
987         address to,
988         uint256 tokenId
989     ) internal virtual {
990         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
991         require(to != address(0), "ERC721: transfer to the zero address");
992 
993         _beforeTokenTransfer(from, to, tokenId);
994 
995         // Clear approvals from the previous owner
996         _approve(address(0), tokenId);
997 
998         _balances[from] -= 1;
999         _balances[to] += 1;
1000         _owners[tokenId] = to;
1001 
1002         emit Transfer(from, to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev Approve `to` to operate on `tokenId`
1007      *
1008      * Emits a {Approval} event.
1009      */
1010     function _approve(address to, uint256 tokenId) internal virtual {
1011         _tokenApprovals[tokenId] = to;
1012         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev Approve `operator` to operate on all of `owner` tokens
1017      *
1018      * Emits a {ApprovalForAll} event.
1019      */
1020     function _setApprovalForAll(
1021         address owner,
1022         address operator,
1023         bool approved
1024     ) internal virtual {
1025         require(owner != operator, "ERC721: approve to caller");
1026         _operatorApprovals[owner][operator] = approved;
1027         emit ApprovalForAll(owner, operator, approved);
1028     }
1029 
1030     /**
1031      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1032      * The call is not executed if the target address is not a contract.
1033      *
1034      * @param from address representing the previous owner of the given token ID
1035      * @param to target address that will receive the tokens
1036      * @param tokenId uint256 ID of the token to be transferred
1037      * @param _data bytes optional data to send along with the call
1038      * @return bool whether the call correctly returned the expected magic value
1039      */
1040     function _checkOnERC721Received(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes memory _data
1045     ) private returns (bool) {
1046         if (to.isContract()) {
1047             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1048                 return retval == IERC721Receiver.onERC721Received.selector;
1049             } catch (bytes memory reason) {
1050                 if (reason.length == 0) {
1051                     revert("ERC721: transfer to non ERC721Receiver implementer");
1052                 } else {
1053                     assembly {
1054                         revert(add(32, reason), mload(reason))
1055                     }
1056                 }
1057             }
1058         } else {
1059             return true;
1060         }
1061     }
1062 
1063     /**
1064      * @dev Hook that is called before any token transfer. This includes minting
1065      * and burning.
1066      *
1067      * Calling conditions:
1068      *
1069      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1070      * transferred to `to`.
1071      * - When `from` is zero, `tokenId` will be minted for `to`.
1072      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1073      * - `from` and `to` are never both zero.
1074      *
1075      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1076      */
1077     function _beforeTokenTransfer(
1078         address from,
1079         address to,
1080         uint256 tokenId
1081     ) internal virtual {}
1082 }
1083 
1084 pragma solidity ^0.8.7;
1085 
1086 contract SenshiSouls is ERC721, Ownable {
1087 
1088     using Strings for uint256;
1089     using Counters for Counters.Counter;
1090 
1091     string private _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/QmNQaGg5QFmvW15iwaX8S44CF3pvZ3QtbEd9LHb7A3rPnd/";
1092     uint256 public SS_TEAM_RESERVE = 111;
1093     uint256 public SS_FREE_RESERVE = 666;
1094     uint256 public SS_PUBLIC = 6000;
1095     uint256 public SS_MAX = SS_FREE_RESERVE + SS_TEAM_RESERVE + SS_PUBLIC;
1096     uint256 public SS_PRICE = 0.066 ether;
1097     uint256 public SS_PER_MINT = 10;
1098     mapping(address => uint256) public FREE_LIST;
1099 
1100     uint256 public freeTokensMinted;
1101     uint256 public publicTokensMinted;
1102     uint256 public teamTokensMinted;
1103 
1104     bool public freeLive;
1105     bool public publicLive;
1106 
1107     Counters.Counter private _tokensMinted;
1108 
1109     constructor() ERC721("Senshi Souls", "SOUL") {}
1110 
1111     function gift(address[] calldata receivers) external onlyOwner {
1112         require(teamTokensMinted + receivers.length <= SS_TEAM_RESERVE, "EXCEED_TEAM_RESERVE");
1113         require(_tokensMinted.current() + receivers.length <= SS_MAX, "EXCEED_MAX");
1114         for (uint256 i = 0; i < receivers.length; i++) {
1115             teamTokensMinted++;
1116             _tokensMinted.increment();
1117             _safeMint(receivers[i], _tokensMinted.current());
1118         }
1119     }
1120 
1121     function founderMint(uint256 tokenQuantity) external onlyOwner {
1122         require(teamTokensMinted + tokenQuantity <= SS_TEAM_RESERVE, "EXCEED_TEAM_RESERVE");
1123         require(_tokensMinted.current() + tokenQuantity <= SS_MAX, "EXCEED_MAX");
1124         for(uint256 i = 0; i < tokenQuantity; i++) {
1125             teamTokensMinted++;
1126             _tokensMinted.increment();
1127             _safeMint(msg.sender, _tokensMinted.current());
1128         }
1129     }
1130 
1131     function freeMint(uint256 tokenQuantity) external {
1132         require(freeLive, "MINT_CLOSED");
1133         require(freeTokensMinted + tokenQuantity <= SS_FREE_RESERVE, "EXCEED_FREE_RESERVE");
1134         require(_tokensMinted.current() + tokenQuantity <= SS_MAX, "EXCEED_MAX");
1135         require(FREE_LIST[msg.sender] + tokenQuantity <= 5, "EXCEED_PER_WALLET");
1136         for (uint256 i = 0; i < tokenQuantity; i++) {
1137             freeTokensMinted++;
1138             FREE_LIST[msg.sender]++;
1139             _tokensMinted.increment();
1140             _safeMint(msg.sender, _tokensMinted.current());
1141         }
1142     }
1143 
1144     function mint(uint256 tokenQuantity) external payable {
1145         require(publicLive, "MINT_CLOSED");
1146         require(publicTokensMinted + tokenQuantity <= SS_PUBLIC, "EXCEED_PUBLIC");
1147         require(_tokensMinted.current() + tokenQuantity <= SS_MAX, "EXCEED_MAX");
1148         require(tokenQuantity <= SS_PER_MINT, "EXCEED_PER_MINT");
1149         require(SS_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1150         for (uint256 i = 0; i < tokenQuantity; i++) {
1151             publicTokensMinted++;
1152             _tokensMinted.increment();
1153             _safeMint(msg.sender, _tokensMinted.current());
1154         }
1155     }
1156 
1157     function withdraw() external onlyOwner {
1158         uint256 currentBalance = address(this).balance;
1159         Address.sendValue(payable(0x738F58d7B2445960F5ffED63587b29876e8dFc78), currentBalance * 1 / 10);
1160         Address.sendValue(payable(0x69c10b60fBba7b662131b9263940aC13Fe6766E9), currentBalance * 1 / 10);
1161         Address.sendValue(payable(0x93CB07c1bA5826dbeF2519A77B3886ce809828fe), currentBalance * 1 / 10);
1162         Address.sendValue(payable(0x11111F01570EeAA3e5a2Fd51f4A2f127661B9834), currentBalance * 1 / 10);
1163         Address.sendValue(payable(0x96Eb3dD8c2f72b4BFd772Af77808EC2684563E2A), currentBalance * 2 / 10);        
1164         Address.sendValue(payable(0xd548fE1a0952e26B458df470F0859cdaf8a56917), currentBalance * 2 / 10);
1165         Address.sendValue(payable(0xF2868A47a30299E088a9C9353b988686FD9E6193), address(this).balance);
1166     }
1167 
1168     function togglePublicMintStatus() external onlyOwner {
1169         publicLive = !publicLive;
1170     }
1171 
1172     function toggleFreeMintStatus() external onlyOwner {
1173         freeLive = !freeLive;
1174     }
1175 
1176     function setPrice(uint256 newPrice) external onlyOwner {
1177         SS_PRICE = newPrice;
1178     }
1179 
1180     function setTeamReserve(uint256 newCount) external onlyOwner {
1181         SS_TEAM_RESERVE = newCount;
1182     }
1183 
1184     function setFreeReserve(uint256 newCount) external onlyOwner {
1185         SS_FREE_RESERVE = newCount;
1186     }
1187 
1188     function setPublic(uint256 newCount) external onlyOwner {
1189         SS_PUBLIC = newCount;
1190     }
1191     
1192     function setMax(uint256 newCount) external onlyOwner {
1193         SS_MAX = newCount;
1194     }
1195     
1196     function setBaseURI(string calldata URI) external onlyOwner {
1197         _tokenBaseURI = URI;
1198     }
1199     
1200     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1201         require(_exists(tokenId), "Cannot query non-existent token");
1202         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1203     }
1204 
1205     function totalSupply() public view returns (uint256) {
1206         return _tokensMinted.current();
1207     }
1208 
1209     receive() external payable {}
1210 }