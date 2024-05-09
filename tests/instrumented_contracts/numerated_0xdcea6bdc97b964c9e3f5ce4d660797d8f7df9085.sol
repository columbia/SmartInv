1 // Sources flattened with hardhat v2.6.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.2
32 
33 
34 
35 pragma solidity >=0.6.2 <0.8.0;
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(address from, address to, uint256 tokenId) external;
85 
86     /**
87      * @dev Transfers `tokenId` token from `from` to `to`.
88      *
89      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
90      *
91      * Requirements:
92      *
93      * - `from` cannot be the zero address.
94      * - `to` cannot be the zero address.
95      * - `tokenId` token must be owned by `from`.
96      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address from, address to, uint256 tokenId) external;
101 
102     /**
103      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
104      * The approval is cleared when the token is transferred.
105      *
106      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
107      *
108      * Requirements:
109      *
110      * - The caller must own the token or be an approved operator.
111      * - `tokenId` must exist.
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address to, uint256 tokenId) external;
116 
117     /**
118      * @dev Returns the account approved for `tokenId` token.
119      *
120      * Requirements:
121      *
122      * - `tokenId` must exist.
123      */
124     function getApproved(uint256 tokenId) external view returns (address operator);
125 
126     /**
127      * @dev Approve or remove `operator` as an operator for the caller.
128      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
129      *
130      * Requirements:
131      *
132      * - The `operator` cannot be the caller.
133      *
134      * Emits an {ApprovalForAll} event.
135      */
136     function setApprovalForAll(address operator, bool _approved) external;
137 
138     /**
139      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
140      *
141      * See {setApprovalForAll}
142      */
143     function isApprovedForAll(address owner, address operator) external view returns (bool);
144 
145     /**
146       * @dev Safely transfers `tokenId` token from `from` to `to`.
147       *
148       * Requirements:
149       *
150       * - `from` cannot be the zero address.
151       * - `to` cannot be the zero address.
152       * - `tokenId` token must exist and be owned by `from`.
153       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
154       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
155       *
156       * Emits a {Transfer} event.
157       */
158     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
159 }
160 
161 
162 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v3.4.2
163 
164 
165 
166 pragma solidity >=0.6.2 <0.8.0;
167 
168 /**
169  * @dev Required interface of an ERC1155 compliant contract, as defined in the
170  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
171  *
172  * _Available since v3.1._
173  */
174 interface IERC1155 is IERC165 {
175     /**
176      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
177      */
178     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
179 
180     /**
181      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
182      * transfers.
183      */
184     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
185 
186     /**
187      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
188      * `approved`.
189      */
190     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
191 
192     /**
193      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
194      *
195      * If an {URI} event was emitted for `id`, the standard
196      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
197      * returned by {IERC1155MetadataURI-uri}.
198      */
199     event URI(string value, uint256 indexed id);
200 
201     /**
202      * @dev Returns the amount of tokens of token type `id` owned by `account`.
203      *
204      * Requirements:
205      *
206      * - `account` cannot be the zero address.
207      */
208     function balanceOf(address account, uint256 id) external view returns (uint256);
209 
210     /**
211      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
212      *
213      * Requirements:
214      *
215      * - `accounts` and `ids` must have the same length.
216      */
217     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
218 
219     /**
220      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
221      *
222      * Emits an {ApprovalForAll} event.
223      *
224      * Requirements:
225      *
226      * - `operator` cannot be the caller.
227      */
228     function setApprovalForAll(address operator, bool approved) external;
229 
230     /**
231      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
232      *
233      * See {setApprovalForAll}.
234      */
235     function isApprovedForAll(address account, address operator) external view returns (bool);
236 
237     /**
238      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
239      *
240      * Emits a {TransferSingle} event.
241      *
242      * Requirements:
243      *
244      * - `to` cannot be the zero address.
245      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
246      * - `from` must have a balance of tokens of type `id` of at least `amount`.
247      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
248      * acceptance magic value.
249      */
250     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
251 
252     /**
253      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
254      *
255      * Emits a {TransferBatch} event.
256      *
257      * Requirements:
258      *
259      * - `ids` and `amounts` must have the same length.
260      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
261      * acceptance magic value.
262      */
263     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
264 }
265 
266 
267 // File @openzeppelin/contracts/token/ERC1155/IERC1155MetadataURI.sol@v3.4.2
268 
269 
270 
271 pragma solidity >=0.6.2 <0.8.0;
272 
273 /**
274  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
275  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
276  *
277  * _Available since v3.1._
278  */
279 interface IERC1155MetadataURI is IERC1155 {
280     /**
281      * @dev Returns the URI for token type `id`.
282      *
283      * If the `\{id\}` substring is present in the URI, it must be replaced by
284      * clients with the actual token type ID.
285      */
286     function uri(uint256 id) external view returns (string memory);
287 }
288 
289 
290 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v3.4.2
291 
292 
293 
294 pragma solidity >=0.6.0 <0.8.0;
295 
296 /**
297  * _Available since v3.1._
298  */
299 interface IERC1155Receiver is IERC165 {
300 
301     /**
302         @dev Handles the receipt of a single ERC1155 token type. This function is
303         called at the end of a `safeTransferFrom` after the balance has been updated.
304         To accept the transfer, this must return
305         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
306         (i.e. 0xf23a6e61, or its own function selector).
307         @param operator The address which initiated the transfer (i.e. msg.sender)
308         @param from The address which previously owned the token
309         @param id The ID of the token being transferred
310         @param value The amount of tokens being transferred
311         @param data Additional data with no specified format
312         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
313     */
314     function onERC1155Received(
315         address operator,
316         address from,
317         uint256 id,
318         uint256 value,
319         bytes calldata data
320     )
321         external
322         returns(bytes4);
323 
324     /**
325         @dev Handles the receipt of a multiple ERC1155 token types. This function
326         is called at the end of a `safeBatchTransferFrom` after the balances have
327         been updated. To accept the transfer(s), this must return
328         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
329         (i.e. 0xbc197c81, or its own function selector).
330         @param operator The address which initiated the batch transfer (i.e. msg.sender)
331         @param from The address which previously owned the token
332         @param ids An array containing ids of each token being transferred (order and length must match values array)
333         @param values An array containing amounts of each token being transferred (order and length must match ids array)
334         @param data Additional data with no specified format
335         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
336     */
337     function onERC1155BatchReceived(
338         address operator,
339         address from,
340         uint256[] calldata ids,
341         uint256[] calldata values,
342         bytes calldata data
343     )
344         external
345         returns(bytes4);
346 }
347 
348 
349 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2
350 
351 
352 
353 pragma solidity >=0.6.0 <0.8.0;
354 
355 /*
356  * @dev Provides information about the current execution context, including the
357  * sender of the transaction and its data. While these are generally available
358  * via msg.sender and msg.data, they should not be accessed in such a direct
359  * manner, since when dealing with GSN meta-transactions the account sending and
360  * paying for execution may not be the actual sender (as far as an application
361  * is concerned).
362  *
363  * This contract is only required for intermediate, library-like contracts.
364  */
365 abstract contract Context {
366     function _msgSender() internal view virtual returns (address payable) {
367         return msg.sender;
368     }
369 
370     function _msgData() internal view virtual returns (bytes memory) {
371         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
372         return msg.data;
373     }
374 }
375 
376 
377 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.2
378 
379 
380 
381 pragma solidity >=0.6.0 <0.8.0;
382 
383 /**
384  * @dev Implementation of the {IERC165} interface.
385  *
386  * Contracts may inherit from this and call {_registerInterface} to declare
387  * their support of an interface.
388  */
389 abstract contract ERC165 is IERC165 {
390     /*
391      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
392      */
393     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
394 
395     /**
396      * @dev Mapping of interface ids to whether or not it's supported.
397      */
398     mapping(bytes4 => bool) private _supportedInterfaces;
399 
400     constructor () internal {
401         // Derived contracts need only register support for their own interfaces,
402         // we register support for ERC165 itself here
403         _registerInterface(_INTERFACE_ID_ERC165);
404     }
405 
406     /**
407      * @dev See {IERC165-supportsInterface}.
408      *
409      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
410      */
411     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
412         return _supportedInterfaces[interfaceId];
413     }
414 
415     /**
416      * @dev Registers the contract as an implementer of the interface defined by
417      * `interfaceId`. Support of the actual ERC165 interface is automatic and
418      * registering its interface id is not required.
419      *
420      * See {IERC165-supportsInterface}.
421      *
422      * Requirements:
423      *
424      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
425      */
426     function _registerInterface(bytes4 interfaceId) internal virtual {
427         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
428         _supportedInterfaces[interfaceId] = true;
429     }
430 }
431 
432 
433 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
434 
435 
436 
437 pragma solidity >=0.6.0 <0.8.0;
438 
439 /**
440  * @dev Wrappers over Solidity's arithmetic operations with added overflow
441  * checks.
442  *
443  * Arithmetic operations in Solidity wrap on overflow. This can easily result
444  * in bugs, because programmers usually assume that an overflow raises an
445  * error, which is the standard behavior in high level programming languages.
446  * `SafeMath` restores this intuition by reverting the transaction when an
447  * operation overflows.
448  *
449  * Using this library instead of the unchecked operations eliminates an entire
450  * class of bugs, so it's recommended to use it always.
451  */
452 library SafeMath {
453     /**
454      * @dev Returns the addition of two unsigned integers, with an overflow flag.
455      *
456      * _Available since v3.4._
457      */
458     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
459         uint256 c = a + b;
460         if (c < a) return (false, 0);
461         return (true, c);
462     }
463 
464     /**
465      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
466      *
467      * _Available since v3.4._
468      */
469     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
470         if (b > a) return (false, 0);
471         return (true, a - b);
472     }
473 
474     /**
475      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
476      *
477      * _Available since v3.4._
478      */
479     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
480         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
481         // benefit is lost if 'b' is also tested.
482         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
483         if (a == 0) return (true, 0);
484         uint256 c = a * b;
485         if (c / a != b) return (false, 0);
486         return (true, c);
487     }
488 
489     /**
490      * @dev Returns the division of two unsigned integers, with a division by zero flag.
491      *
492      * _Available since v3.4._
493      */
494     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
495         if (b == 0) return (false, 0);
496         return (true, a / b);
497     }
498 
499     /**
500      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
501      *
502      * _Available since v3.4._
503      */
504     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
505         if (b == 0) return (false, 0);
506         return (true, a % b);
507     }
508 
509     /**
510      * @dev Returns the addition of two unsigned integers, reverting on
511      * overflow.
512      *
513      * Counterpart to Solidity's `+` operator.
514      *
515      * Requirements:
516      *
517      * - Addition cannot overflow.
518      */
519     function add(uint256 a, uint256 b) internal pure returns (uint256) {
520         uint256 c = a + b;
521         require(c >= a, "SafeMath: addition overflow");
522         return c;
523     }
524 
525     /**
526      * @dev Returns the subtraction of two unsigned integers, reverting on
527      * overflow (when the result is negative).
528      *
529      * Counterpart to Solidity's `-` operator.
530      *
531      * Requirements:
532      *
533      * - Subtraction cannot overflow.
534      */
535     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
536         require(b <= a, "SafeMath: subtraction overflow");
537         return a - b;
538     }
539 
540     /**
541      * @dev Returns the multiplication of two unsigned integers, reverting on
542      * overflow.
543      *
544      * Counterpart to Solidity's `*` operator.
545      *
546      * Requirements:
547      *
548      * - Multiplication cannot overflow.
549      */
550     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
551         if (a == 0) return 0;
552         uint256 c = a * b;
553         require(c / a == b, "SafeMath: multiplication overflow");
554         return c;
555     }
556 
557     /**
558      * @dev Returns the integer division of two unsigned integers, reverting on
559      * division by zero. The result is rounded towards zero.
560      *
561      * Counterpart to Solidity's `/` operator. Note: this function uses a
562      * `revert` opcode (which leaves remaining gas untouched) while Solidity
563      * uses an invalid opcode to revert (consuming all remaining gas).
564      *
565      * Requirements:
566      *
567      * - The divisor cannot be zero.
568      */
569     function div(uint256 a, uint256 b) internal pure returns (uint256) {
570         require(b > 0, "SafeMath: division by zero");
571         return a / b;
572     }
573 
574     /**
575      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
576      * reverting when dividing by zero.
577      *
578      * Counterpart to Solidity's `%` operator. This function uses a `revert`
579      * opcode (which leaves remaining gas untouched) while Solidity uses an
580      * invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      *
584      * - The divisor cannot be zero.
585      */
586     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
587         require(b > 0, "SafeMath: modulo by zero");
588         return a % b;
589     }
590 
591     /**
592      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
593      * overflow (when the result is negative).
594      *
595      * CAUTION: This function is deprecated because it requires allocating memory for the error
596      * message unnecessarily. For custom revert reasons use {trySub}.
597      *
598      * Counterpart to Solidity's `-` operator.
599      *
600      * Requirements:
601      *
602      * - Subtraction cannot overflow.
603      */
604     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
605         require(b <= a, errorMessage);
606         return a - b;
607     }
608 
609     /**
610      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
611      * division by zero. The result is rounded towards zero.
612      *
613      * CAUTION: This function is deprecated because it requires allocating memory for the error
614      * message unnecessarily. For custom revert reasons use {tryDiv}.
615      *
616      * Counterpart to Solidity's `/` operator. Note: this function uses a
617      * `revert` opcode (which leaves remaining gas untouched) while Solidity
618      * uses an invalid opcode to revert (consuming all remaining gas).
619      *
620      * Requirements:
621      *
622      * - The divisor cannot be zero.
623      */
624     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
625         require(b > 0, errorMessage);
626         return a / b;
627     }
628 
629     /**
630      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
631      * reverting with custom message when dividing by zero.
632      *
633      * CAUTION: This function is deprecated because it requires allocating memory for the error
634      * message unnecessarily. For custom revert reasons use {tryMod}.
635      *
636      * Counterpart to Solidity's `%` operator. This function uses a `revert`
637      * opcode (which leaves remaining gas untouched) while Solidity uses an
638      * invalid opcode to revert (consuming all remaining gas).
639      *
640      * Requirements:
641      *
642      * - The divisor cannot be zero.
643      */
644     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
645         require(b > 0, errorMessage);
646         return a % b;
647     }
648 }
649 
650 
651 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2
652 
653 
654 
655 pragma solidity >=0.6.2 <0.8.0;
656 
657 /**
658  * @dev Collection of functions related to the address type
659  */
660 library Address {
661     /**
662      * @dev Returns true if `account` is a contract.
663      *
664      * [IMPORTANT]
665      * ====
666      * It is unsafe to assume that an address for which this function returns
667      * false is an externally-owned account (EOA) and not a contract.
668      *
669      * Among others, `isContract` will return false for the following
670      * types of addresses:
671      *
672      *  - an externally-owned account
673      *  - a contract in construction
674      *  - an address where a contract will be created
675      *  - an address where a contract lived, but was destroyed
676      * ====
677      */
678     function isContract(address account) internal view returns (bool) {
679         // This method relies on extcodesize, which returns 0 for contracts in
680         // construction, since the code is only stored at the end of the
681         // constructor execution.
682 
683         uint256 size;
684         // solhint-disable-next-line no-inline-assembly
685         assembly { size := extcodesize(account) }
686         return size > 0;
687     }
688 
689     /**
690      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
691      * `recipient`, forwarding all available gas and reverting on errors.
692      *
693      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
694      * of certain opcodes, possibly making contracts go over the 2300 gas limit
695      * imposed by `transfer`, making them unable to receive funds via
696      * `transfer`. {sendValue} removes this limitation.
697      *
698      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
699      *
700      * IMPORTANT: because control is transferred to `recipient`, care must be
701      * taken to not create reentrancy vulnerabilities. Consider using
702      * {ReentrancyGuard} or the
703      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
704      */
705     function sendValue(address payable recipient, uint256 amount) internal {
706         require(address(this).balance >= amount, "Address: insufficient balance");
707 
708         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
709         (bool success, ) = recipient.call{ value: amount }("");
710         require(success, "Address: unable to send value, recipient may have reverted");
711     }
712 
713     /**
714      * @dev Performs a Solidity function call using a low level `call`. A
715      * plain`call` is an unsafe replacement for a function call: use this
716      * function instead.
717      *
718      * If `target` reverts with a revert reason, it is bubbled up by this
719      * function (like regular Solidity function calls).
720      *
721      * Returns the raw returned data. To convert to the expected return value,
722      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
723      *
724      * Requirements:
725      *
726      * - `target` must be a contract.
727      * - calling `target` with `data` must not revert.
728      *
729      * _Available since v3.1._
730      */
731     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
732       return functionCall(target, data, "Address: low-level call failed");
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
737      * `errorMessage` as a fallback revert reason when `target` reverts.
738      *
739      * _Available since v3.1._
740      */
741     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
742         return functionCallWithValue(target, data, 0, errorMessage);
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
747      * but also transferring `value` wei to `target`.
748      *
749      * Requirements:
750      *
751      * - the calling contract must have an ETH balance of at least `value`.
752      * - the called Solidity function must be `payable`.
753      *
754      * _Available since v3.1._
755      */
756     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
757         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
762      * with `errorMessage` as a fallback revert reason when `target` reverts.
763      *
764      * _Available since v3.1._
765      */
766     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
767         require(address(this).balance >= value, "Address: insufficient balance for call");
768         require(isContract(target), "Address: call to non-contract");
769 
770         // solhint-disable-next-line avoid-low-level-calls
771         (bool success, bytes memory returndata) = target.call{ value: value }(data);
772         return _verifyCallResult(success, returndata, errorMessage);
773     }
774 
775     /**
776      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
777      * but performing a static call.
778      *
779      * _Available since v3.3._
780      */
781     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
782         return functionStaticCall(target, data, "Address: low-level static call failed");
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
787      * but performing a static call.
788      *
789      * _Available since v3.3._
790      */
791     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
792         require(isContract(target), "Address: static call to non-contract");
793 
794         // solhint-disable-next-line avoid-low-level-calls
795         (bool success, bytes memory returndata) = target.staticcall(data);
796         return _verifyCallResult(success, returndata, errorMessage);
797     }
798 
799     /**
800      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
801      * but performing a delegate call.
802      *
803      * _Available since v3.4._
804      */
805     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
806         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
807     }
808 
809     /**
810      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
811      * but performing a delegate call.
812      *
813      * _Available since v3.4._
814      */
815     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
816         require(isContract(target), "Address: delegate call to non-contract");
817 
818         // solhint-disable-next-line avoid-low-level-calls
819         (bool success, bytes memory returndata) = target.delegatecall(data);
820         return _verifyCallResult(success, returndata, errorMessage);
821     }
822 
823     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
824         if (success) {
825             return returndata;
826         } else {
827             // Look for revert reason and bubble it up if present
828             if (returndata.length > 0) {
829                 // The easiest way to bubble the revert reason is using memory via assembly
830 
831                 // solhint-disable-next-line no-inline-assembly
832                 assembly {
833                     let returndata_size := mload(returndata)
834                     revert(add(32, returndata), returndata_size)
835                 }
836             } else {
837                 revert(errorMessage);
838             }
839         }
840     }
841 }
842 
843 
844 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v3.4.2
845 
846 
847 
848 pragma solidity >=0.6.0 <0.8.0;
849 
850 
851 
852 
853 
854 
855 
856 /**
857  *
858  * @dev Implementation of the basic standard multi-token.
859  * See https://eips.ethereum.org/EIPS/eip-1155
860  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
861  *
862  * _Available since v3.1._
863  */
864 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
865     using SafeMath for uint256;
866     using Address for address;
867 
868     // Mapping from token ID to account balances
869     mapping (uint256 => mapping(address => uint256)) private _balances;
870 
871     // Mapping from account to operator approvals
872     mapping (address => mapping(address => bool)) private _operatorApprovals;
873 
874     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
875     string private _uri;
876 
877     /*
878      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
879      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
880      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
881      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
882      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
883      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
884      *
885      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
886      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
887      */
888     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
889 
890     /*
891      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
892      */
893     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
894 
895     /**
896      * @dev See {_setURI}.
897      */
898     constructor (string memory uri_) public {
899         _setURI(uri_);
900 
901         // register the supported interfaces to conform to ERC1155 via ERC165
902         _registerInterface(_INTERFACE_ID_ERC1155);
903 
904         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
905         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
906     }
907 
908     /**
909      * @dev See {IERC1155MetadataURI-uri}.
910      *
911      * This implementation returns the same URI for *all* token types. It relies
912      * on the token type ID substitution mechanism
913      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
914      *
915      * Clients calling this function must replace the `\{id\}` substring with the
916      * actual token type ID.
917      */
918     function uri(uint256) external view virtual override returns (string memory) {
919         return _uri;
920     }
921 
922     /**
923      * @dev See {IERC1155-balanceOf}.
924      *
925      * Requirements:
926      *
927      * - `account` cannot be the zero address.
928      */
929     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
930         require(account != address(0), "ERC1155: balance query for the zero address");
931         return _balances[id][account];
932     }
933 
934     /**
935      * @dev See {IERC1155-balanceOfBatch}.
936      *
937      * Requirements:
938      *
939      * - `accounts` and `ids` must have the same length.
940      */
941     function balanceOfBatch(
942         address[] memory accounts,
943         uint256[] memory ids
944     )
945         public
946         view
947         virtual
948         override
949         returns (uint256[] memory)
950     {
951         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
952 
953         uint256[] memory batchBalances = new uint256[](accounts.length);
954 
955         for (uint256 i = 0; i < accounts.length; ++i) {
956             batchBalances[i] = balanceOf(accounts[i], ids[i]);
957         }
958 
959         return batchBalances;
960     }
961 
962     /**
963      * @dev See {IERC1155-setApprovalForAll}.
964      */
965     function setApprovalForAll(address operator, bool approved) public virtual override {
966         require(_msgSender() != operator, "ERC1155: setting approval status for self");
967 
968         _operatorApprovals[_msgSender()][operator] = approved;
969         emit ApprovalForAll(_msgSender(), operator, approved);
970     }
971 
972     /**
973      * @dev See {IERC1155-isApprovedForAll}.
974      */
975     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
976         return _operatorApprovals[account][operator];
977     }
978 
979     /**
980      * @dev See {IERC1155-safeTransferFrom}.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 id,
986         uint256 amount,
987         bytes memory data
988     )
989         public
990         virtual
991         override
992     {
993         require(to != address(0), "ERC1155: transfer to the zero address");
994         require(
995             from == _msgSender() || isApprovedForAll(from, _msgSender()),
996             "ERC1155: caller is not owner nor approved"
997         );
998 
999         address operator = _msgSender();
1000 
1001         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1002 
1003         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
1004         _balances[id][to] = _balances[id][to].add(amount);
1005 
1006         emit TransferSingle(operator, from, to, id, amount);
1007 
1008         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1009     }
1010 
1011     /**
1012      * @dev See {IERC1155-safeBatchTransferFrom}.
1013      */
1014     function safeBatchTransferFrom(
1015         address from,
1016         address to,
1017         uint256[] memory ids,
1018         uint256[] memory amounts,
1019         bytes memory data
1020     )
1021         public
1022         virtual
1023         override
1024     {
1025         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1026         require(to != address(0), "ERC1155: transfer to the zero address");
1027         require(
1028             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1029             "ERC1155: transfer caller is not owner nor approved"
1030         );
1031 
1032         address operator = _msgSender();
1033 
1034         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1035 
1036         for (uint256 i = 0; i < ids.length; ++i) {
1037             uint256 id = ids[i];
1038             uint256 amount = amounts[i];
1039 
1040             _balances[id][from] = _balances[id][from].sub(
1041                 amount,
1042                 "ERC1155: insufficient balance for transfer"
1043             );
1044             _balances[id][to] = _balances[id][to].add(amount);
1045         }
1046 
1047         emit TransferBatch(operator, from, to, ids, amounts);
1048 
1049         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1050     }
1051 
1052     /**
1053      * @dev Sets a new URI for all token types, by relying on the token type ID
1054      * substitution mechanism
1055      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1056      *
1057      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1058      * URI or any of the amounts in the JSON file at said URI will be replaced by
1059      * clients with the token type ID.
1060      *
1061      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1062      * interpreted by clients as
1063      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1064      * for token type ID 0x4cce0.
1065      *
1066      * See {uri}.
1067      *
1068      * Because these URIs cannot be meaningfully represented by the {URI} event,
1069      * this function emits no events.
1070      */
1071     function _setURI(string memory newuri) internal virtual {
1072         _uri = newuri;
1073     }
1074 
1075     /**
1076      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1077      *
1078      * Emits a {TransferSingle} event.
1079      *
1080      * Requirements:
1081      *
1082      * - `account` cannot be the zero address.
1083      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1084      * acceptance magic value.
1085      */
1086     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
1087         require(account != address(0), "ERC1155: mint to the zero address");
1088 
1089         address operator = _msgSender();
1090 
1091         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1092 
1093         _balances[id][account] = _balances[id][account].add(amount);
1094         emit TransferSingle(operator, address(0), account, id, amount);
1095 
1096         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1097     }
1098 
1099     /**
1100      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1101      *
1102      * Requirements:
1103      *
1104      * - `ids` and `amounts` must have the same length.
1105      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1106      * acceptance magic value.
1107      */
1108     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
1109         require(to != address(0), "ERC1155: mint to the zero address");
1110         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1111 
1112         address operator = _msgSender();
1113 
1114         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1115 
1116         for (uint i = 0; i < ids.length; i++) {
1117             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
1118         }
1119 
1120         emit TransferBatch(operator, address(0), to, ids, amounts);
1121 
1122         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1123     }
1124 
1125     /**
1126      * @dev Destroys `amount` tokens of token type `id` from `account`
1127      *
1128      * Requirements:
1129      *
1130      * - `account` cannot be the zero address.
1131      * - `account` must have at least `amount` tokens of token type `id`.
1132      */
1133     function _burn(address account, uint256 id, uint256 amount) internal virtual {
1134         require(account != address(0), "ERC1155: burn from the zero address");
1135 
1136         address operator = _msgSender();
1137 
1138         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1139 
1140         _balances[id][account] = _balances[id][account].sub(
1141             amount,
1142             "ERC1155: burn amount exceeds balance"
1143         );
1144 
1145         emit TransferSingle(operator, account, address(0), id, amount);
1146     }
1147 
1148     /**
1149      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1150      *
1151      * Requirements:
1152      *
1153      * - `ids` and `amounts` must have the same length.
1154      */
1155     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
1156         require(account != address(0), "ERC1155: burn from the zero address");
1157         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1158 
1159         address operator = _msgSender();
1160 
1161         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1162 
1163         for (uint i = 0; i < ids.length; i++) {
1164             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
1165                 amounts[i],
1166                 "ERC1155: burn amount exceeds balance"
1167             );
1168         }
1169 
1170         emit TransferBatch(operator, account, address(0), ids, amounts);
1171     }
1172 
1173     /**
1174      * @dev Hook that is called before any token transfer. This includes minting
1175      * and burning, as well as batched variants.
1176      *
1177      * The same hook is called on both single and batched variants. For single
1178      * transfers, the length of the `id` and `amount` arrays will be 1.
1179      *
1180      * Calling conditions (for each `id` and `amount` pair):
1181      *
1182      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1183      * of token type `id` will be  transferred to `to`.
1184      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1185      * for `to`.
1186      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1187      * will be burned.
1188      * - `from` and `to` are never both zero.
1189      * - `ids` and `amounts` have the same, non-zero length.
1190      *
1191      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1192      */
1193     function _beforeTokenTransfer(
1194         address operator,
1195         address from,
1196         address to,
1197         uint256[] memory ids,
1198         uint256[] memory amounts,
1199         bytes memory data
1200     )
1201         internal
1202         virtual
1203     { }
1204 
1205     function _doSafeTransferAcceptanceCheck(
1206         address operator,
1207         address from,
1208         address to,
1209         uint256 id,
1210         uint256 amount,
1211         bytes memory data
1212     )
1213         private
1214     {
1215         if (to.isContract()) {
1216             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1217                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1218                     revert("ERC1155: ERC1155Receiver rejected tokens");
1219                 }
1220             } catch Error(string memory reason) {
1221                 revert(reason);
1222             } catch {
1223                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1224             }
1225         }
1226     }
1227 
1228     function _doSafeBatchTransferAcceptanceCheck(
1229         address operator,
1230         address from,
1231         address to,
1232         uint256[] memory ids,
1233         uint256[] memory amounts,
1234         bytes memory data
1235     )
1236         private
1237     {
1238         if (to.isContract()) {
1239             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1240                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1241                     revert("ERC1155: ERC1155Receiver rejected tokens");
1242                 }
1243             } catch Error(string memory reason) {
1244                 revert(reason);
1245             } catch {
1246                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1247             }
1248         }
1249     }
1250 
1251     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1252         uint256[] memory array = new uint256[](1);
1253         array[0] = element;
1254 
1255         return array;
1256     }
1257 }
1258 
1259 
1260 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2
1261 
1262 
1263 
1264 pragma solidity >=0.6.0 <0.8.0;
1265 
1266 /**
1267  * @dev Contract module which provides a basic access control mechanism, where
1268  * there is an account (an owner) that can be granted exclusive access to
1269  * specific functions.
1270  *
1271  * By default, the owner account will be the one that deploys the contract. This
1272  * can later be changed with {transferOwnership}.
1273  *
1274  * This module is used through inheritance. It will make available the modifier
1275  * `onlyOwner`, which can be applied to your functions to restrict their use to
1276  * the owner.
1277  */
1278 abstract contract Ownable is Context {
1279     address private _owner;
1280 
1281     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1282 
1283     /**
1284      * @dev Initializes the contract setting the deployer as the initial owner.
1285      */
1286     constructor () internal {
1287         address msgSender = _msgSender();
1288         _owner = msgSender;
1289         emit OwnershipTransferred(address(0), msgSender);
1290     }
1291 
1292     /**
1293      * @dev Returns the address of the current owner.
1294      */
1295     function owner() public view virtual returns (address) {
1296         return _owner;
1297     }
1298 
1299     /**
1300      * @dev Throws if called by any account other than the owner.
1301      */
1302     modifier onlyOwner() {
1303         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1304         _;
1305     }
1306 
1307     /**
1308      * @dev Leaves the contract without owner. It will not be possible to call
1309      * `onlyOwner` functions anymore. Can only be called by the current owner.
1310      *
1311      * NOTE: Renouncing ownership will leave the contract without an owner,
1312      * thereby removing any functionality that is only available to the owner.
1313      */
1314     function renounceOwnership() public virtual onlyOwner {
1315         emit OwnershipTransferred(_owner, address(0));
1316         _owner = address(0);
1317     }
1318 
1319     /**
1320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1321      * Can only be called by the current owner.
1322      */
1323     function transferOwnership(address newOwner) public virtual onlyOwner {
1324         require(newOwner != address(0), "Ownable: new owner is the zero address");
1325         emit OwnershipTransferred(_owner, newOwner);
1326         _owner = newOwner;
1327     }
1328 }
1329 
1330 
1331 // File contracts/ManifestKlimaERC1155.sol
1332 
1333 pragma solidity ^0.7.5;
1334 // import "hardhat/console.sol";
1335 
1336 interface IERC721Contract {
1337     function balanceOf(address owner) external view returns (uint256 balance);
1338 }
1339 
1340 interface IERC20Contract {
1341     function balanceOf(address account) external view returns (uint256);
1342     function transfer(address recipient, uint256 amount) external returns (bool);
1343     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1344     function approve(address spender, uint256 amount) external returns (bool);
1345 }
1346 
1347 contract ManifestKlimaERC1155 is ERC1155, Ownable {
1348 
1349     event NftMinted(address sender, uint256 id);
1350 
1351     string public name = "Season 0: Save The World";
1352     string public symbol = "STW0";
1353 
1354     uint256 public constant TOKEN_1 = 1;
1355     uint256 public constant TOKEN_2 = 2;
1356     uint256 public constant TOKEN_3 = 3;
1357     uint256 public constant MAX_PER_WALLET = 4;
1358     uint256 public constant RESERVED_NUM = 151;
1359     uint256 public constant PUBLIC_NUM = 293;
1360 
1361     uint256 public price = 2 * 10**9;
1362     
1363     uint256 public totalRemaining1 = PUBLIC_NUM;
1364     uint256 public totalRemaining2 = PUBLIC_NUM;
1365     uint256 public totalRemaining3 = PUBLIC_NUM;
1366 
1367     address public treasury;
1368     address public sMNFST;
1369     address public MNFST;
1370 
1371     bool public treasuryHasMinted;
1372     bool public saleIsActive;
1373 
1374     mapping( address => uint256 ) private totalClaimed;
1375 
1376     constructor (address _treasury, address _MNFST, address _sMNFST, string memory _uri) ERC1155(_uri) {
1377         treasury = _treasury;
1378         sMNFST = _sMNFST;
1379         MNFST = _MNFST;
1380     }
1381 
1382     function setTreasury(address _treasury) external onlyOwner {
1383         treasury = _treasury;
1384     }
1385 
1386     function setMNFST(address _MNFST) external onlyOwner {
1387         MNFST = _MNFST;
1388     }
1389     
1390     function setSMNFST(address _sMNFST) external onlyOwner {
1391         sMNFST = _sMNFST;
1392     }
1393 
1394     function toggleSaleIsActive() external onlyOwner {
1395         saleIsActive = !saleIsActive;
1396     }
1397 
1398     function mintWithMNFST(uint256 tokenId) external {
1399         mint(tokenId, MNFST);
1400     }
1401 
1402     function mintWithSMNFST(uint256 tokenId) external {
1403         mint(tokenId, sMNFST);
1404     }
1405 
1406     function mint(uint256 tokenId, address token) internal {
1407         require(saleIsActive, "SALE_NOT_STARTED");
1408         require(IERC20Contract( token ).balanceOf(msg.sender) >= price, "INSUFFICIENT_BAL");
1409         require(totalClaimed[msg.sender] < MAX_PER_WALLET, "EXCEEDS_MAX_PER_WALLET");
1410         require(token == MNFST || token == sMNFST, "WRONG_PAYMENT_TOKEN");
1411 
1412         if (tokenId == TOKEN_1) {
1413             require(totalRemaining1 > 0, "AMOUNT_EXCEEDS_REMAINING");
1414             totalRemaining1--;
1415         }
1416         else if (tokenId == TOKEN_2) {
1417             require(totalRemaining2 > 0, "AMOUNT_EXCEEDS_REMAINING");
1418             totalRemaining2--;
1419         }
1420         else if (tokenId == TOKEN_3) {
1421             require(totalRemaining3 > 0, "AMOUNT_EXCEEDS_REMAINING");
1422             totalRemaining3--;
1423         }
1424         else {
1425             revert("WRONG_HOODIE_ID");
1426         }
1427 
1428         totalClaimed[msg.sender] += 1;
1429 
1430         // transfer payment from sender to this contract
1431         IERC20Contract( token ).transferFrom(msg.sender, address(this), price);
1432         // mint the hoodie
1433         _mint(msg.sender, tokenId, 1, '');
1434         
1435         emit NftMinted(msg.sender, tokenId);
1436     }
1437     
1438     function setURI(string memory _newUri) public onlyOwner {
1439         _setURI(_newUri);
1440     }
1441 
1442     function setPrice(uint256 inPrice) public onlyOwner returns (uint256) {
1443         price = inPrice;
1444         return price;
1445     }
1446 
1447     function totalClaimedBy(address owner) external view returns (uint256) {
1448         require(owner != address(0), "NULL_ADDR");
1449 
1450         return totalClaimed[owner];
1451     }
1452 
1453     function totalSupply(uint256 _id) public view returns (uint256) {
1454         uint256 treasuryNum = 0;
1455 
1456         if (treasuryHasMinted)
1457         {
1458             treasuryNum = RESERVED_NUM;
1459         }
1460 
1461         if (_id == TOKEN_1) {
1462             return (PUBLIC_NUM - totalRemaining1) + treasuryNum;
1463         }
1464 
1465         if (_id == TOKEN_2) {
1466             return (PUBLIC_NUM - totalRemaining2) + treasuryNum;
1467         }
1468 
1469         if (_id == TOKEN_3) {
1470             return (PUBLIC_NUM - totalRemaining3) + treasuryNum;
1471         }
1472 
1473         return 0;
1474     }
1475 
1476     function totalHoodiesMinted() public view returns (uint256) {
1477         uint256 treasuryNum = 0;
1478 
1479         if (treasuryHasMinted)
1480         {
1481             treasuryNum = RESERVED_NUM * 3;
1482         }
1483 
1484         return ((PUBLIC_NUM * 3) - totalRemaining1 - totalRemaining2 - totalRemaining3) + treasuryNum;
1485     }
1486 
1487     function mintToTreasury() public onlyOwner {
1488         require(treasuryHasMinted == false, "TREASURY_HAS_MINTED");
1489 
1490         uint256[] memory tokens = new uint256[](3);
1491         tokens[0] = TOKEN_1;
1492         tokens[1] = TOKEN_2;
1493         tokens[2] = TOKEN_3;
1494 
1495         uint256[] memory totals = new uint256[](3);
1496         totals[0] = RESERVED_NUM;
1497         totals[1] = RESERVED_NUM;
1498         totals[2] = RESERVED_NUM;
1499 
1500         _mintBatch(treasury, tokens, totals, '');
1501         treasuryHasMinted = true;
1502     }
1503 
1504     function withdrawAllEth() public onlyOwner {
1505         uint256 balance = address(this).balance;
1506         require(balance > 0, "NO_ETH");
1507         (bool success, ) = treasury.call{ value: balance }("");
1508         require(success, "FAILED");
1509     }
1510 
1511     function withdrawAllSMNFST() public onlyOwner {
1512         uint256 sMNFSTBalance = IERC20Contract( sMNFST ).balanceOf(address(this));
1513         require(sMNFSTBalance > 0, "NO_SMNFST");
1514         IERC20Contract( sMNFST ).transfer(treasury, sMNFSTBalance);
1515     }
1516 
1517     function withdrawAllMNFST() public onlyOwner {
1518         uint256 MNFSTBalance = IERC20Contract( MNFST ).balanceOf(address(this));
1519         require(MNFSTBalance > 0, "NO_MNFST");
1520         IERC20Contract( MNFST ).transfer(treasury, MNFSTBalance);
1521     }
1522 }