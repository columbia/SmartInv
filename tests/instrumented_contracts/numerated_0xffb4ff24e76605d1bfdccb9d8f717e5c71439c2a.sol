1 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.2 <0.8.0;
6 
7 /**
8  * @dev Library used to query support of an interface declared via {IERC165}.
9  *
10  * Note that these functions return the actual result of the query: they do not
11  * `revert` if an interface is not supported. It is up to the caller to decide
12  * what to do in these cases.
13  */
14 library ERC165Checker {
15     // As per the EIP-165 spec, no interface should ever match 0xffffffff
16     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
17 
18     /*
19      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
20      */
21     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
22 
23     /**
24      * @dev Returns true if `account` supports the {IERC165} interface,
25      */
26     function supportsERC165(address account) internal view returns (bool) {
27         // Any contract that implements ERC165 must explicitly indicate support of
28         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
29         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
30             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
31     }
32 
33     /**
34      * @dev Returns true if `account` supports the interface defined by
35      * `interfaceId`. Support for {IERC165} itself is queried automatically.
36      *
37      * See {IERC165-supportsInterface}.
38      */
39     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
40         // query support of both ERC165 as per the spec and support of _interfaceId
41         return supportsERC165(account) &&
42             _supportsERC165Interface(account, interfaceId);
43     }
44 
45     /**
46      * @dev Returns a boolean array where each value corresponds to the
47      * interfaces passed in and whether they're supported or not. This allows
48      * you to batch check interfaces for a contract where your expectation
49      * is that some interfaces may not be supported.
50      *
51      * See {IERC165-supportsInterface}.
52      *
53      * _Available since v3.4._
54      */
55     function getSupportedInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool[] memory) {
56         // an array of booleans corresponding to interfaceIds and whether they're supported or not
57         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
58 
59         // query support of ERC165 itself
60         if (supportsERC165(account)) {
61             // query support of each interface in interfaceIds
62             for (uint256 i = 0; i < interfaceIds.length; i++) {
63                 interfaceIdsSupported[i] = _supportsERC165Interface(account, interfaceIds[i]);
64             }
65         }
66 
67         return interfaceIdsSupported;
68     }
69 
70     /**
71      * @dev Returns true if `account` supports all the interfaces defined in
72      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
73      *
74      * Batch-querying can lead to gas savings by skipping repeated checks for
75      * {IERC165} support.
76      *
77      * See {IERC165-supportsInterface}.
78      */
79     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
80         // query support of ERC165 itself
81         if (!supportsERC165(account)) {
82             return false;
83         }
84 
85         // query support of each interface in _interfaceIds
86         for (uint256 i = 0; i < interfaceIds.length; i++) {
87             if (!_supportsERC165Interface(account, interfaceIds[i])) {
88                 return false;
89             }
90         }
91 
92         // all interfaces supported
93         return true;
94     }
95 
96     /**
97      * @notice Query if a contract implements an interface, does not check ERC165 support
98      * @param account The address of the contract to query for support of an interface
99      * @param interfaceId The interface identifier, as specified in ERC-165
100      * @return true if the contract at account indicates support of the interface with
101      * identifier interfaceId, false otherwise
102      * @dev Assumes that account contains a contract that supports ERC165, otherwise
103      * the behavior of this method is undefined. This precondition can be checked
104      * with {supportsERC165}.
105      * Interface identification is specified in ERC-165.
106      */
107     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
108         // success determines whether the staticcall succeeded and result determines
109         // whether the contract at account indicates support of _interfaceId
110         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
111 
112         return (success && result);
113     }
114 
115     /**
116      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
117      * @param account The address of the contract to query for support of an interface
118      * @param interfaceId The interface identifier, as specified in ERC-165
119      * @return success true if the STATICCALL succeeded, false otherwise
120      * @return result true if the STATICCALL succeeded and the contract at account
121      * indicates support of the interface with identifier interfaceId, false otherwise
122      */
123     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
124         private
125         view
126         returns (bool, bool)
127     {
128         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
129         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
130         if (result.length < 32) return (false, false);
131         return (success, abi.decode(result, (bool)));
132     }
133 }
134 
135 // File: @openzeppelin/contracts/introspection/IERC165.sol
136 
137 
138 
139 pragma solidity >=0.6.0 <0.8.0;
140 
141 /**
142  * @dev Interface of the ERC165 standard, as defined in the
143  * https://eips.ethereum.org/EIPS/eip-165[EIP].
144  *
145  * Implementers can declare support of contract interfaces, which can then be
146  * queried by others ({ERC165Checker}).
147  *
148  * For an implementation, see {ERC165}.
149  */
150 interface IERC165 {
151     /**
152      * @dev Returns true if this contract implements the interface defined by
153      * `interfaceId`. See the corresponding
154      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
155      * to learn more about how these ids are created.
156      *
157      * This function call must use less than 30 000 gas.
158      */
159     function supportsInterface(bytes4 interfaceId) external view returns (bool);
160 }
161 
162 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
163 
164 
165 
166 pragma solidity >=0.6.2 <0.8.0;
167 
168 
169 /**
170  * @dev Required interface of an ERC1155 compliant contract, as defined in the
171  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
172  *
173  * _Available since v3.1._
174  */
175 interface IERC1155 is IERC165 {
176     /**
177      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
178      */
179     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
180 
181     /**
182      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
183      * transfers.
184      */
185     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
186 
187     /**
188      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
189      * `approved`.
190      */
191     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
192 
193     /**
194      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
195      *
196      * If an {URI} event was emitted for `id`, the standard
197      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
198      * returned by {IERC1155MetadataURI-uri}.
199      */
200     event URI(string value, uint256 indexed id);
201 
202     /**
203      * @dev Returns the amount of tokens of token type `id` owned by `account`.
204      *
205      * Requirements:
206      *
207      * - `account` cannot be the zero address.
208      */
209     function balanceOf(address account, uint256 id) external view returns (uint256);
210 
211     /**
212      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
213      *
214      * Requirements:
215      *
216      * - `accounts` and `ids` must have the same length.
217      */
218     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
219 
220     /**
221      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
222      *
223      * Emits an {ApprovalForAll} event.
224      *
225      * Requirements:
226      *
227      * - `operator` cannot be the caller.
228      */
229     function setApprovalForAll(address operator, bool approved) external;
230 
231     /**
232      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
233      *
234      * See {setApprovalForAll}.
235      */
236     function isApprovedForAll(address account, address operator) external view returns (bool);
237 
238     /**
239      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
240      *
241      * Emits a {TransferSingle} event.
242      *
243      * Requirements:
244      *
245      * - `to` cannot be the zero address.
246      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
247      * - `from` must have a balance of tokens of type `id` of at least `amount`.
248      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
249      * acceptance magic value.
250      */
251     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
252 
253     /**
254      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
255      *
256      * Emits a {TransferBatch} event.
257      *
258      * Requirements:
259      *
260      * - `ids` and `amounts` must have the same length.
261      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
262      * acceptance magic value.
263      */
264     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
265 }
266 
267 // File: @openzeppelin/contracts/token/ERC1155/IERC1155MetadataURI.sol
268 
269 
270 
271 pragma solidity >=0.6.2 <0.8.0;
272 
273 
274 /**
275  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
276  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
277  *
278  * _Available since v3.1._
279  */
280 interface IERC1155MetadataURI is IERC1155 {
281     /**
282      * @dev Returns the URI for token type `id`.
283      *
284      * If the `\{id\}` substring is present in the URI, it must be replaced by
285      * clients with the actual token type ID.
286      */
287     function uri(uint256 id) external view returns (string memory);
288 }
289 
290 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
291 
292 
293 
294 pragma solidity >=0.6.0 <0.8.0;
295 
296 
297 /**
298  * _Available since v3.1._
299  */
300 interface IERC1155Receiver is IERC165 {
301 
302     /**
303         @dev Handles the receipt of a single ERC1155 token type. This function is
304         called at the end of a `safeTransferFrom` after the balance has been updated.
305         To accept the transfer, this must return
306         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
307         (i.e. 0xf23a6e61, or its own function selector).
308         @param operator The address which initiated the transfer (i.e. msg.sender)
309         @param from The address which previously owned the token
310         @param id The ID of the token being transferred
311         @param value The amount of tokens being transferred
312         @param data Additional data with no specified format
313         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
314     */
315     function onERC1155Received(
316         address operator,
317         address from,
318         uint256 id,
319         uint256 value,
320         bytes calldata data
321     )
322         external
323         returns(bytes4);
324 
325     /**
326         @dev Handles the receipt of a multiple ERC1155 token types. This function
327         is called at the end of a `safeBatchTransferFrom` after the balances have
328         been updated. To accept the transfer(s), this must return
329         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
330         (i.e. 0xbc197c81, or its own function selector).
331         @param operator The address which initiated the batch transfer (i.e. msg.sender)
332         @param from The address which previously owned the token
333         @param ids An array containing ids of each token being transferred (order and length must match values array)
334         @param values An array containing amounts of each token being transferred (order and length must match ids array)
335         @param data Additional data with no specified format
336         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
337     */
338     function onERC1155BatchReceived(
339         address operator,
340         address from,
341         uint256[] calldata ids,
342         uint256[] calldata values,
343         bytes calldata data
344     )
345         external
346         returns(bytes4);
347 }
348 
349 // File: @openzeppelin/contracts/utils/Context.sol
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
376 // File: @openzeppelin/contracts/introspection/ERC165.sol
377 
378 
379 
380 pragma solidity >=0.6.0 <0.8.0;
381 
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
432 // File: @openzeppelin/contracts/math/SafeMath.sol
433 
434 
435 
436 pragma solidity >=0.6.0 <0.8.0;
437 
438 /**
439  * @dev Wrappers over Solidity's arithmetic operations with added overflow
440  * checks.
441  *
442  * Arithmetic operations in Solidity wrap on overflow. This can easily result
443  * in bugs, because programmers usually assume that an overflow raises an
444  * error, which is the standard behavior in high level programming languages.
445  * `SafeMath` restores this intuition by reverting the transaction when an
446  * operation overflows.
447  *
448  * Using this library instead of the unchecked operations eliminates an entire
449  * class of bugs, so it's recommended to use it always.
450  */
451 library SafeMath {
452     /**
453      * @dev Returns the addition of two unsigned integers, with an overflow flag.
454      *
455      * _Available since v3.4._
456      */
457     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
458         uint256 c = a + b;
459         if (c < a) return (false, 0);
460         return (true, c);
461     }
462 
463     /**
464      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
465      *
466      * _Available since v3.4._
467      */
468     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
469         if (b > a) return (false, 0);
470         return (true, a - b);
471     }
472 
473     /**
474      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
475      *
476      * _Available since v3.4._
477      */
478     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
479         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
480         // benefit is lost if 'b' is also tested.
481         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
482         if (a == 0) return (true, 0);
483         uint256 c = a * b;
484         if (c / a != b) return (false, 0);
485         return (true, c);
486     }
487 
488     /**
489      * @dev Returns the division of two unsigned integers, with a division by zero flag.
490      *
491      * _Available since v3.4._
492      */
493     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
494         if (b == 0) return (false, 0);
495         return (true, a / b);
496     }
497 
498     /**
499      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
500      *
501      * _Available since v3.4._
502      */
503     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
504         if (b == 0) return (false, 0);
505         return (true, a % b);
506     }
507 
508     /**
509      * @dev Returns the addition of two unsigned integers, reverting on
510      * overflow.
511      *
512      * Counterpart to Solidity's `+` operator.
513      *
514      * Requirements:
515      *
516      * - Addition cannot overflow.
517      */
518     function add(uint256 a, uint256 b) internal pure returns (uint256) {
519         uint256 c = a + b;
520         require(c >= a, "SafeMath: addition overflow");
521         return c;
522     }
523 
524     /**
525      * @dev Returns the subtraction of two unsigned integers, reverting on
526      * overflow (when the result is negative).
527      *
528      * Counterpart to Solidity's `-` operator.
529      *
530      * Requirements:
531      *
532      * - Subtraction cannot overflow.
533      */
534     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
535         require(b <= a, "SafeMath: subtraction overflow");
536         return a - b;
537     }
538 
539     /**
540      * @dev Returns the multiplication of two unsigned integers, reverting on
541      * overflow.
542      *
543      * Counterpart to Solidity's `*` operator.
544      *
545      * Requirements:
546      *
547      * - Multiplication cannot overflow.
548      */
549     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
550         if (a == 0) return 0;
551         uint256 c = a * b;
552         require(c / a == b, "SafeMath: multiplication overflow");
553         return c;
554     }
555 
556     /**
557      * @dev Returns the integer division of two unsigned integers, reverting on
558      * division by zero. The result is rounded towards zero.
559      *
560      * Counterpart to Solidity's `/` operator. Note: this function uses a
561      * `revert` opcode (which leaves remaining gas untouched) while Solidity
562      * uses an invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function div(uint256 a, uint256 b) internal pure returns (uint256) {
569         require(b > 0, "SafeMath: division by zero");
570         return a / b;
571     }
572 
573     /**
574      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
575      * reverting when dividing by zero.
576      *
577      * Counterpart to Solidity's `%` operator. This function uses a `revert`
578      * opcode (which leaves remaining gas untouched) while Solidity uses an
579      * invalid opcode to revert (consuming all remaining gas).
580      *
581      * Requirements:
582      *
583      * - The divisor cannot be zero.
584      */
585     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
586         require(b > 0, "SafeMath: modulo by zero");
587         return a % b;
588     }
589 
590     /**
591      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
592      * overflow (when the result is negative).
593      *
594      * CAUTION: This function is deprecated because it requires allocating memory for the error
595      * message unnecessarily. For custom revert reasons use {trySub}.
596      *
597      * Counterpart to Solidity's `-` operator.
598      *
599      * Requirements:
600      *
601      * - Subtraction cannot overflow.
602      */
603     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
604         require(b <= a, errorMessage);
605         return a - b;
606     }
607 
608     /**
609      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
610      * division by zero. The result is rounded towards zero.
611      *
612      * CAUTION: This function is deprecated because it requires allocating memory for the error
613      * message unnecessarily. For custom revert reasons use {tryDiv}.
614      *
615      * Counterpart to Solidity's `/` operator. Note: this function uses a
616      * `revert` opcode (which leaves remaining gas untouched) while Solidity
617      * uses an invalid opcode to revert (consuming all remaining gas).
618      *
619      * Requirements:
620      *
621      * - The divisor cannot be zero.
622      */
623     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
624         require(b > 0, errorMessage);
625         return a / b;
626     }
627 
628     /**
629      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
630      * reverting with custom message when dividing by zero.
631      *
632      * CAUTION: This function is deprecated because it requires allocating memory for the error
633      * message unnecessarily. For custom revert reasons use {tryMod}.
634      *
635      * Counterpart to Solidity's `%` operator. This function uses a `revert`
636      * opcode (which leaves remaining gas untouched) while Solidity uses an
637      * invalid opcode to revert (consuming all remaining gas).
638      *
639      * Requirements:
640      *
641      * - The divisor cannot be zero.
642      */
643     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
644         require(b > 0, errorMessage);
645         return a % b;
646     }
647 }
648 
649 // File: @openzeppelin/contracts/utils/Address.sol
650 
651 
652 
653 pragma solidity >=0.6.2 <0.8.0;
654 
655 /**
656  * @dev Collection of functions related to the address type
657  */
658 library Address {
659     /**
660      * @dev Returns true if `account` is a contract.
661      *
662      * [IMPORTANT]
663      * ====
664      * It is unsafe to assume that an address for which this function returns
665      * false is an externally-owned account (EOA) and not a contract.
666      *
667      * Among others, `isContract` will return false for the following
668      * types of addresses:
669      *
670      *  - an externally-owned account
671      *  - a contract in construction
672      *  - an address where a contract will be created
673      *  - an address where a contract lived, but was destroyed
674      * ====
675      */
676     function isContract(address account) internal view returns (bool) {
677         // This method relies on extcodesize, which returns 0 for contracts in
678         // construction, since the code is only stored at the end of the
679         // constructor execution.
680 
681         uint256 size;
682         // solhint-disable-next-line no-inline-assembly
683         assembly { size := extcodesize(account) }
684         return size > 0;
685     }
686 
687     /**
688      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
689      * `recipient`, forwarding all available gas and reverting on errors.
690      *
691      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
692      * of certain opcodes, possibly making contracts go over the 2300 gas limit
693      * imposed by `transfer`, making them unable to receive funds via
694      * `transfer`. {sendValue} removes this limitation.
695      *
696      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
697      *
698      * IMPORTANT: because control is transferred to `recipient`, care must be
699      * taken to not create reentrancy vulnerabilities. Consider using
700      * {ReentrancyGuard} or the
701      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
702      */
703     function sendValue(address payable recipient, uint256 amount) internal {
704         require(address(this).balance >= amount, "Address: insufficient balance");
705 
706         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
707         (bool success, ) = recipient.call{ value: amount }("");
708         require(success, "Address: unable to send value, recipient may have reverted");
709     }
710 
711     /**
712      * @dev Performs a Solidity function call using a low level `call`. A
713      * plain`call` is an unsafe replacement for a function call: use this
714      * function instead.
715      *
716      * If `target` reverts with a revert reason, it is bubbled up by this
717      * function (like regular Solidity function calls).
718      *
719      * Returns the raw returned data. To convert to the expected return value,
720      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
721      *
722      * Requirements:
723      *
724      * - `target` must be a contract.
725      * - calling `target` with `data` must not revert.
726      *
727      * _Available since v3.1._
728      */
729     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
730       return functionCall(target, data, "Address: low-level call failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
735      * `errorMessage` as a fallback revert reason when `target` reverts.
736      *
737      * _Available since v3.1._
738      */
739     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
740         return functionCallWithValue(target, data, 0, errorMessage);
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
745      * but also transferring `value` wei to `target`.
746      *
747      * Requirements:
748      *
749      * - the calling contract must have an ETH balance of at least `value`.
750      * - the called Solidity function must be `payable`.
751      *
752      * _Available since v3.1._
753      */
754     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
755         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
756     }
757 
758     /**
759      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
760      * with `errorMessage` as a fallback revert reason when `target` reverts.
761      *
762      * _Available since v3.1._
763      */
764     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
765         require(address(this).balance >= value, "Address: insufficient balance for call");
766         require(isContract(target), "Address: call to non-contract");
767 
768         // solhint-disable-next-line avoid-low-level-calls
769         (bool success, bytes memory returndata) = target.call{ value: value }(data);
770         return _verifyCallResult(success, returndata, errorMessage);
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
775      * but performing a static call.
776      *
777      * _Available since v3.3._
778      */
779     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
780         return functionStaticCall(target, data, "Address: low-level static call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
785      * but performing a static call.
786      *
787      * _Available since v3.3._
788      */
789     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
790         require(isContract(target), "Address: static call to non-contract");
791 
792         // solhint-disable-next-line avoid-low-level-calls
793         (bool success, bytes memory returndata) = target.staticcall(data);
794         return _verifyCallResult(success, returndata, errorMessage);
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
799      * but performing a delegate call.
800      *
801      * _Available since v3.4._
802      */
803     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
804         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
809      * but performing a delegate call.
810      *
811      * _Available since v3.4._
812      */
813     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
814         require(isContract(target), "Address: delegate call to non-contract");
815 
816         // solhint-disable-next-line avoid-low-level-calls
817         (bool success, bytes memory returndata) = target.delegatecall(data);
818         return _verifyCallResult(success, returndata, errorMessage);
819     }
820 
821     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
822         if (success) {
823             return returndata;
824         } else {
825             // Look for revert reason and bubble it up if present
826             if (returndata.length > 0) {
827                 // The easiest way to bubble the revert reason is using memory via assembly
828 
829                 // solhint-disable-next-line no-inline-assembly
830                 assembly {
831                     let returndata_size := mload(returndata)
832                     revert(add(32, returndata), returndata_size)
833                 }
834             } else {
835                 revert(errorMessage);
836             }
837         }
838     }
839 }
840 
841 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
842 
843 
844 
845 pragma solidity >=0.6.0 <0.8.0;
846 
847 
848 
849 
850 
851 
852 
853 
854 /**
855  *
856  * @dev Implementation of the basic standard multi-token.
857  * See https://eips.ethereum.org/EIPS/eip-1155
858  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
859  *
860  * _Available since v3.1._
861  */
862 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
863     using SafeMath for uint256;
864     using Address for address;
865 
866     // Mapping from token ID to account balances
867     mapping (uint256 => mapping(address => uint256)) private _balances;
868 
869     // Mapping from account to operator approvals
870     mapping (address => mapping(address => bool)) private _operatorApprovals;
871 
872     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
873     string private _uri;
874 
875     /*
876      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
877      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
878      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
879      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
880      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
881      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
882      *
883      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
884      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
885      */
886     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
887 
888     /*
889      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
890      */
891     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
892 
893     /**
894      * @dev See {_setURI}.
895      */
896     constructor (string memory uri_) public {
897         _setURI(uri_);
898 
899         // register the supported interfaces to conform to ERC1155 via ERC165
900         _registerInterface(_INTERFACE_ID_ERC1155);
901 
902         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
903         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
904     }
905 
906     /**
907      * @dev See {IERC1155MetadataURI-uri}.
908      *
909      * This implementation returns the same URI for *all* token types. It relies
910      * on the token type ID substitution mechanism
911      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
912      *
913      * Clients calling this function must replace the `\{id\}` substring with the
914      * actual token type ID.
915      */
916     function uri(uint256) external view virtual override returns (string memory) {
917         return _uri;
918     }
919 
920     /**
921      * @dev See {IERC1155-balanceOf}.
922      *
923      * Requirements:
924      *
925      * - `account` cannot be the zero address.
926      */
927     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
928         require(account != address(0), "ERC1155: balance query for the zero address");
929         return _balances[id][account];
930     }
931 
932     /**
933      * @dev See {IERC1155-balanceOfBatch}.
934      *
935      * Requirements:
936      *
937      * - `accounts` and `ids` must have the same length.
938      */
939     function balanceOfBatch(
940         address[] memory accounts,
941         uint256[] memory ids
942     )
943         public
944         view
945         virtual
946         override
947         returns (uint256[] memory)
948     {
949         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
950 
951         uint256[] memory batchBalances = new uint256[](accounts.length);
952 
953         for (uint256 i = 0; i < accounts.length; ++i) {
954             batchBalances[i] = balanceOf(accounts[i], ids[i]);
955         }
956 
957         return batchBalances;
958     }
959 
960     /**
961      * @dev See {IERC1155-setApprovalForAll}.
962      */
963     function setApprovalForAll(address operator, bool approved) public virtual override {
964         require(_msgSender() != operator, "ERC1155: setting approval status for self");
965 
966         _operatorApprovals[_msgSender()][operator] = approved;
967         emit ApprovalForAll(_msgSender(), operator, approved);
968     }
969 
970     /**
971      * @dev See {IERC1155-isApprovedForAll}.
972      */
973     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
974         return _operatorApprovals[account][operator];
975     }
976 
977     /**
978      * @dev See {IERC1155-safeTransferFrom}.
979      */
980     function safeTransferFrom(
981         address from,
982         address to,
983         uint256 id,
984         uint256 amount,
985         bytes memory data
986     )
987         public
988         virtual
989         override
990     {
991         require(to != address(0), "ERC1155: transfer to the zero address");
992         require(
993             from == _msgSender() || isApprovedForAll(from, _msgSender()),
994             "ERC1155: caller is not owner nor approved"
995         );
996 
997         address operator = _msgSender();
998 
999         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1000 
1001         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
1002         _balances[id][to] = _balances[id][to].add(amount);
1003 
1004         emit TransferSingle(operator, from, to, id, amount);
1005 
1006         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1007     }
1008 
1009     /**
1010      * @dev See {IERC1155-safeBatchTransferFrom}.
1011      */
1012     function safeBatchTransferFrom(
1013         address from,
1014         address to,
1015         uint256[] memory ids,
1016         uint256[] memory amounts,
1017         bytes memory data
1018     )
1019         public
1020         virtual
1021         override
1022     {
1023         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1024         require(to != address(0), "ERC1155: transfer to the zero address");
1025         require(
1026             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1027             "ERC1155: transfer caller is not owner nor approved"
1028         );
1029 
1030         address operator = _msgSender();
1031 
1032         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1033 
1034         for (uint256 i = 0; i < ids.length; ++i) {
1035             uint256 id = ids[i];
1036             uint256 amount = amounts[i];
1037 
1038             _balances[id][from] = _balances[id][from].sub(
1039                 amount,
1040                 "ERC1155: insufficient balance for transfer"
1041             );
1042             _balances[id][to] = _balances[id][to].add(amount);
1043         }
1044 
1045         emit TransferBatch(operator, from, to, ids, amounts);
1046 
1047         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1048     }
1049 
1050     /**
1051      * @dev Sets a new URI for all token types, by relying on the token type ID
1052      * substitution mechanism
1053      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1054      *
1055      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1056      * URI or any of the amounts in the JSON file at said URI will be replaced by
1057      * clients with the token type ID.
1058      *
1059      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1060      * interpreted by clients as
1061      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1062      * for token type ID 0x4cce0.
1063      *
1064      * See {uri}.
1065      *
1066      * Because these URIs cannot be meaningfully represented by the {URI} event,
1067      * this function emits no events.
1068      */
1069     function _setURI(string memory newuri) internal virtual {
1070         _uri = newuri;
1071     }
1072 
1073     /**
1074      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1075      *
1076      * Emits a {TransferSingle} event.
1077      *
1078      * Requirements:
1079      *
1080      * - `account` cannot be the zero address.
1081      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1082      * acceptance magic value.
1083      */
1084     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
1085         require(account != address(0), "ERC1155: mint to the zero address");
1086 
1087         address operator = _msgSender();
1088 
1089         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1090 
1091         _balances[id][account] = _balances[id][account].add(amount);
1092         emit TransferSingle(operator, address(0), account, id, amount);
1093 
1094         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1095     }
1096 
1097     /**
1098      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1099      *
1100      * Requirements:
1101      *
1102      * - `ids` and `amounts` must have the same length.
1103      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1104      * acceptance magic value.
1105      */
1106     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
1107         require(to != address(0), "ERC1155: mint to the zero address");
1108         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1109 
1110         address operator = _msgSender();
1111 
1112         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1113 
1114         for (uint i = 0; i < ids.length; i++) {
1115             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
1116         }
1117 
1118         emit TransferBatch(operator, address(0), to, ids, amounts);
1119 
1120         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1121     }
1122 
1123     /**
1124      * @dev Destroys `amount` tokens of token type `id` from `account`
1125      *
1126      * Requirements:
1127      *
1128      * - `account` cannot be the zero address.
1129      * - `account` must have at least `amount` tokens of token type `id`.
1130      */
1131     function _burn(address account, uint256 id, uint256 amount) internal virtual {
1132         require(account != address(0), "ERC1155: burn from the zero address");
1133 
1134         address operator = _msgSender();
1135 
1136         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1137 
1138         _balances[id][account] = _balances[id][account].sub(
1139             amount,
1140             "ERC1155: burn amount exceeds balance"
1141         );
1142 
1143         emit TransferSingle(operator, account, address(0), id, amount);
1144     }
1145 
1146     /**
1147      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1148      *
1149      * Requirements:
1150      *
1151      * - `ids` and `amounts` must have the same length.
1152      */
1153     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
1154         require(account != address(0), "ERC1155: burn from the zero address");
1155         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1156 
1157         address operator = _msgSender();
1158 
1159         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1160 
1161         for (uint i = 0; i < ids.length; i++) {
1162             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
1163                 amounts[i],
1164                 "ERC1155: burn amount exceeds balance"
1165             );
1166         }
1167 
1168         emit TransferBatch(operator, account, address(0), ids, amounts);
1169     }
1170 
1171     /**
1172      * @dev Hook that is called before any token transfer. This includes minting
1173      * and burning, as well as batched variants.
1174      *
1175      * The same hook is called on both single and batched variants. For single
1176      * transfers, the length of the `id` and `amount` arrays will be 1.
1177      *
1178      * Calling conditions (for each `id` and `amount` pair):
1179      *
1180      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1181      * of token type `id` will be  transferred to `to`.
1182      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1183      * for `to`.
1184      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1185      * will be burned.
1186      * - `from` and `to` are never both zero.
1187      * - `ids` and `amounts` have the same, non-zero length.
1188      *
1189      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1190      */
1191     function _beforeTokenTransfer(
1192         address operator,
1193         address from,
1194         address to,
1195         uint256[] memory ids,
1196         uint256[] memory amounts,
1197         bytes memory data
1198     )
1199         internal
1200         virtual
1201     { }
1202 
1203     function _doSafeTransferAcceptanceCheck(
1204         address operator,
1205         address from,
1206         address to,
1207         uint256 id,
1208         uint256 amount,
1209         bytes memory data
1210     )
1211         private
1212     {
1213         if (to.isContract()) {
1214             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1215                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1216                     revert("ERC1155: ERC1155Receiver rejected tokens");
1217                 }
1218             } catch Error(string memory reason) {
1219                 revert(reason);
1220             } catch {
1221                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1222             }
1223         }
1224     }
1225 
1226     function _doSafeBatchTransferAcceptanceCheck(
1227         address operator,
1228         address from,
1229         address to,
1230         uint256[] memory ids,
1231         uint256[] memory amounts,
1232         bytes memory data
1233     )
1234         private
1235     {
1236         if (to.isContract()) {
1237             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1238                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1239                     revert("ERC1155: ERC1155Receiver rejected tokens");
1240                 }
1241             } catch Error(string memory reason) {
1242                 revert(reason);
1243             } catch {
1244                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1245             }
1246         }
1247     }
1248 
1249     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1250         uint256[] memory array = new uint256[](1);
1251         array[0] = element;
1252 
1253         return array;
1254     }
1255 }
1256 
1257 // File: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol
1258 
1259 
1260 
1261 pragma solidity >=0.6.0 <0.8.0;
1262 
1263 
1264 
1265 /**
1266  * @dev _Available since v3.1._
1267  */
1268 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
1269     constructor() internal {
1270         _registerInterface(
1271             ERC1155Receiver(address(0)).onERC1155Received.selector ^
1272             ERC1155Receiver(address(0)).onERC1155BatchReceived.selector
1273         );
1274     }
1275 }
1276 
1277 // File: contracts/interfaces/IGenFactory.sol
1278 
1279 pragma solidity >=0.5.0;
1280 
1281 interface IGenFactory {
1282     event TicketCreated(address indexed caller, address indexed genTicket);
1283 
1284     function feeTo() external view returns (address);
1285     function feeToSetter() external view returns (address);
1286 
1287     function getGenTicket(address) external view returns (uint);
1288     function genTickets(uint) external view returns (address);
1289     function genTicketsLength() external view returns (uint);
1290 
1291     function createGenTicket(
1292         address _underlyingToken, 
1293         uint256[] memory _numTickets,
1294         uint256[] memory _ticketSizes,
1295         uint[] memory _totalTranches,
1296         uint[] memory _cliffTranches,
1297         uint[] memory _trancheLength,
1298         string memory _uri
1299     ) external returns (address);
1300 
1301     function setFeeTo(address) external;
1302     function setFeeToSetter(address) external;
1303 }
1304 
1305 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1306 
1307 
1308 
1309 pragma solidity >=0.6.0 <0.8.0;
1310 
1311 /**
1312  * @dev Interface of the ERC20 standard as defined in the EIP.
1313  */
1314 interface IERC20 {
1315     /**
1316      * @dev Returns the amount of tokens in existence.
1317      */
1318     function totalSupply() external view returns (uint256);
1319 
1320     /**
1321      * @dev Returns the amount of tokens owned by `account`.
1322      */
1323     function balanceOf(address account) external view returns (uint256);
1324 
1325     /**
1326      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1327      *
1328      * Returns a boolean value indicating whether the operation succeeded.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function transfer(address recipient, uint256 amount) external returns (bool);
1333 
1334     /**
1335      * @dev Returns the remaining number of tokens that `spender` will be
1336      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1337      * zero by default.
1338      *
1339      * This value changes when {approve} or {transferFrom} are called.
1340      */
1341     function allowance(address owner, address spender) external view returns (uint256);
1342 
1343     /**
1344      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1345      *
1346      * Returns a boolean value indicating whether the operation succeeded.
1347      *
1348      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1349      * that someone may use both the old and the new allowance by unfortunate
1350      * transaction ordering. One possible solution to mitigate this race
1351      * condition is to first reduce the spender's allowance to 0 and set the
1352      * desired value afterwards:
1353      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1354      *
1355      * Emits an {Approval} event.
1356      */
1357     function approve(address spender, uint256 amount) external returns (bool);
1358 
1359     /**
1360      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1361      * allowance mechanism. `amount` is then deducted from the caller's
1362      * allowance.
1363      *
1364      * Returns a boolean value indicating whether the operation succeeded.
1365      *
1366      * Emits a {Transfer} event.
1367      */
1368     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1369 
1370     /**
1371      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1372      * another (`to`).
1373      *
1374      * Note that `value` may be zero.
1375      */
1376     event Transfer(address indexed from, address indexed to, uint256 value);
1377 
1378     /**
1379      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1380      * a call to {approve}. `value` is the new allowance.
1381      */
1382     event Approval(address indexed owner, address indexed spender, uint256 value);
1383 }
1384 
1385 // File: contracts/GenTickets.sol
1386 
1387 pragma solidity 0.6.12;
1388 
1389 
1390 
1391 
1392 
1393 
1394 //import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
1395 
1396 contract GenTickets is ERC1155, ERC1155Receiver {
1397     using SafeMath for uint;
1398     //using SafeERC20 for IERC20;
1399 
1400     struct GenTicket {
1401         uint256 numTickets;
1402         uint256 ticketSize;
1403         uint totalTranches;
1404         uint cliffTranches;
1405         // In days
1406         uint trancheLength;
1407         // Each non-cliff tranche gets ticketsize / (total tranches - cliff tranches)
1408     }
1409     // Ticket id mod numTicketTypes determines tier
1410     // Ticket id div numTicketTypes determines tranche of ticket
1411     // When ticket is swapped in for tokens, the next ticket is minted to the user
1412 
1413     address public underlyingToken;
1414     mapping(uint256 => GenTicket) public genTickets;
1415     uint8 public numTicketTypes;
1416     IGenFactory public factory;
1417     address public issuer;
1418     bool public active = false;
1419     uint256 public balanceNeeded = 0;
1420     // Expected TGE timestamp, start at max uint256
1421     uint public TGE = type(uint).max;
1422 
1423     bytes private constant VALIDATOR = bytes('JC');
1424     
1425     constructor (
1426         address _underlyingToken,
1427         uint256[] memory _numTickets,
1428         uint256[] memory _ticketSizes,
1429         uint[] memory _totalTranches,
1430         uint[] memory _cliffTranches,
1431         uint[] memory _trancheLength,
1432         string memory _uri,
1433         IGenFactory _factory,
1434         address _issuer
1435     ) 
1436         public 
1437         ERC1155(_uri)
1438     {
1439         underlyingToken = _underlyingToken;
1440         factory = _factory;
1441         issuer = _issuer;
1442 
1443          for (uint8 i = 0; i < 50; i++){
1444             if (_numTickets.length == i){
1445                 numTicketTypes = i;
1446                 break;
1447             }
1448             
1449             balanceNeeded += _numTickets[i].mul(_ticketSizes[i]);
1450             genTickets[i] = GenTicket(_numTickets[i], _ticketSizes[i], _totalTranches[i], _cliffTranches[i], _trancheLength[i]);
1451         }
1452     }
1453 
1454     function updateTGE(uint timestamp) external {
1455         require(msg.sender == issuer, "GenTickets: Only issuer can update TGE");
1456         require(getBlockTimestamp() < TGE, "GenTickets: TGE already occurred");
1457         require(getBlockTimestamp() < timestamp, "GenTickets: New TGE must be in the future");
1458         // Determine whether we want to restrict this or not
1459         //require(!active, "Tokens are already active");
1460 
1461         TGE = timestamp;
1462     }
1463 
1464     function issue(address _to) external {
1465         require(msg.sender == issuer, "GenTickets: Only issuer can issue the tokens");
1466         require(!active, "GenTickets: Token is already active");
1467         //require(IERC20(underlyingToken).balanceOf(address(this)) >= balanceNeeded, "GenTickets: Deposit more of the underlying tokens");
1468         IERC20(underlyingToken).transferFrom(msg.sender, address(this), balanceNeeded);
1469 
1470         address feeTo = factory.feeTo();
1471         bytes memory data;
1472 
1473         for (uint8 i = 0; i < 50; i++){
1474             if (numTicketTypes == i){
1475                 break;
1476             }
1477 
1478             GenTicket memory ticketType = genTickets[i];
1479             
1480             uint256 feeAmount = 0;
1481             if (feeTo != address(0)) {
1482                 // 1% of tickets generated is sent to feeTo address
1483                 feeAmount = ticketType.numTickets.div(100);
1484                 if (feeAmount == 0) {
1485                     feeAmount = 1;
1486                 }
1487                 _mint(feeTo, i, feeAmount, data);
1488             }
1489 
1490             _mint(_to, i, ticketType.numTickets - feeAmount, data);
1491         }
1492 
1493         active = true;
1494     }
1495 
1496     function redeemTicket(address _to, uint256 _id, uint256 _amount) public {
1497         uint tier = _id.mod(numTicketTypes);
1498         GenTicket memory ticketType = genTickets[tier];
1499 
1500         // Check that we are past the cliff period for this ticket type
1501         require(getBlockTimestamp() > ticketType.trancheLength.mul(ticketType.cliffTranches).add(TGE), "GenTickets: Ticket is still within cliff period");
1502         // Tranche past cliff
1503         uint tranche = _id.div(numTicketTypes);
1504         require(getBlockTimestamp() > ticketType.trancheLength.mul(ticketType.cliffTranches).add(ticketType.trancheLength.mul(tranche)).add(TGE), "GenTickets: Tokens for this ticket are being vested");
1505         require(tranche < ticketType.totalTranches.sub(ticketType.cliffTranches), "GenTickets: Ticket has redeemed all tokens");
1506 
1507         safeTransferFrom(address(msg.sender), address(this), _id, _amount, VALIDATOR);
1508 
1509         // Transfer underlying tokens with corresponding ticket size
1510         IERC20(underlyingToken).transfer(_to, _amount.mul(ticketType.ticketSize).div(ticketType.totalTranches.sub(ticketType.cliffTranches)));
1511 
1512         bytes memory data;
1513         _mint(_to, _id.add(numTicketTypes), _amount, data);
1514     }
1515 
1516     function getBlockTimestamp() internal view returns (uint) {
1517         // solium-disable-next-line security/no-block-members
1518         return block.timestamp;
1519     }
1520 
1521     /**
1522      * ERC1155 Token ERC1155Receiver
1523      */
1524     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) override external returns(bytes4) {
1525         if(keccak256(_data) == keccak256(VALIDATOR)){
1526             return 0xf23a6e61;
1527         }
1528     }
1529 
1530     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) override external returns(bytes4) {
1531         if(keccak256(_data) == keccak256(VALIDATOR)){
1532             return 0xbc197c81;
1533         }
1534     }
1535 }