1 // File: @openzeppelin/contracts/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
29 
30 pragma solidity ^0.6.2;
31 
32 
33 /**
34  * @dev Required interface of an ERC1155 compliant contract, as defined in the
35  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
36  *
37  * _Available since v3.1._
38  */
39 interface IERC1155 is IERC165 {
40     /**
41      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
42      */
43     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
44 
45     /**
46      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
47      * transfers.
48      */
49     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
50 
51     /**
52      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
53      * `approved`.
54      */
55     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
56 
57     /**
58      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
59      *
60      * If an {URI} event was emitted for `id`, the standard
61      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
62      * returned by {IERC1155MetadataURI-uri}.
63      */
64     event URI(string value, uint256 indexed id);
65 
66     /**
67      * @dev Returns the amount of tokens of token type `id` owned by `account`.
68      *
69      * Requirements:
70      *
71      * - `account` cannot be the zero address.
72      */
73     function balanceOf(address account, uint256 id) external view returns (uint256);
74 
75     /**
76      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
77      *
78      * Requirements:
79      *
80      * - `accounts` and `ids` must have the same length.
81      */
82     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
83 
84     /**
85      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
86      *
87      * Emits an {ApprovalForAll} event.
88      *
89      * Requirements:
90      *
91      * - `operator` cannot be the caller.
92      */
93     function setApprovalForAll(address operator, bool approved) external;
94 
95     /**
96      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
97      *
98      * See {setApprovalForAll}.
99      */
100     function isApprovedForAll(address account, address operator) external view returns (bool);
101 
102     /**
103      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
104      *
105      * Emits a {TransferSingle} event.
106      *
107      * Requirements:
108      *
109      * - `to` cannot be the zero address.
110      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
111      * - `from` must have a balance of tokens of type `id` of at least `amount`.
112      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
113      * acceptance magic value.
114      */
115     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
116 
117     /**
118      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
119      *
120      * Emits a {TransferBatch} event.
121      *
122      * Requirements:
123      *
124      * - `ids` and `amounts` must have the same length.
125      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
126      * acceptance magic value.
127      */
128     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
129 }
130 
131 // File: @openzeppelin/contracts/token/ERC1155/IERC1155MetadataURI.sol
132 
133 pragma solidity ^0.6.2;
134 
135 
136 /**
137  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
138  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
139  *
140  * _Available since v3.1._
141  */
142 interface IERC1155MetadataURI is IERC1155 {
143     /**
144      * @dev Returns the URI for token type `id`.
145      *
146      * If the `\{id\}` substring is present in the URI, it must be replaced by
147      * clients with the actual token type ID.
148      */
149     function uri(uint256 id) external view returns (string memory);
150 }
151 
152 // File: contracts/Mintable.sol
153 
154 pragma solidity =0.6.11;
155 
156 interface Mintable {
157     function setTokenId(uint256 id, bytes32 sig) external;
158     function mint(address account, uint256 id, uint256 amount) external;
159 }
160 
161 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
162 
163 
164 pragma solidity ^0.6.0;
165 
166 
167 /**
168  * _Available since v3.1._
169  */
170 interface IERC1155Receiver is IERC165 {
171 
172     /**
173         @dev Handles the receipt of a single ERC1155 token type. This function is
174         called at the end of a `safeTransferFrom` after the balance has been updated.
175         To accept the transfer, this must return
176         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
177         (i.e. 0xf23a6e61, or its own function selector).
178         @param operator The address which initiated the transfer (i.e. msg.sender)
179         @param from The address which previously owned the token
180         @param id The ID of the token being transferred
181         @param value The amount of tokens being transferred
182         @param data Additional data with no specified format
183         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
184     */
185     function onERC1155Received(
186         address operator,
187         address from,
188         uint256 id,
189         uint256 value,
190         bytes calldata data
191     )
192         external
193         returns(bytes4);
194 
195     /**
196         @dev Handles the receipt of a multiple ERC1155 token types. This function
197         is called at the end of a `safeBatchTransferFrom` after the balances have
198         been updated. To accept the transfer(s), this must return
199         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
200         (i.e. 0xbc197c81, or its own function selector).
201         @param operator The address which initiated the batch transfer (i.e. msg.sender)
202         @param from The address which previously owned the token
203         @param ids An array containing ids of each token being transferred (order and length must match values array)
204         @param values An array containing amounts of each token being transferred (order and length must match ids array)
205         @param data Additional data with no specified format
206         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
207     */
208     function onERC1155BatchReceived(
209         address operator,
210         address from,
211         uint256[] calldata ids,
212         uint256[] calldata values,
213         bytes calldata data
214     )
215         external
216         returns(bytes4);
217 }
218 
219 // File: @openzeppelin/contracts/GSN/Context.sol
220 
221 pragma solidity ^0.6.0;
222 
223 /*
224  * @dev Provides information about the current execution context, including the
225  * sender of the transaction and its data. While these are generally available
226  * via msg.sender and msg.data, they should not be accessed in such a direct
227  * manner, since when dealing with GSN meta-transactions the account sending and
228  * paying for execution may not be the actual sender (as far as an application
229  * is concerned).
230  *
231  * This contract is only required for intermediate, library-like contracts.
232  */
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address payable) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes memory) {
239         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
240         return msg.data;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/introspection/ERC165.sol
245 
246 pragma solidity ^0.6.0;
247 
248 
249 /**
250  * @dev Implementation of the {IERC165} interface.
251  *
252  * Contracts may inherit from this and call {_registerInterface} to declare
253  * their support of an interface.
254  */
255 contract ERC165 is IERC165 {
256     /*
257      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
258      */
259     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
260 
261     /**
262      * @dev Mapping of interface ids to whether or not it's supported.
263      */
264     mapping(bytes4 => bool) private _supportedInterfaces;
265 
266     constructor () internal {
267         // Derived contracts need only register support for their own interfaces,
268         // we register support for ERC165 itself here
269         _registerInterface(_INTERFACE_ID_ERC165);
270     }
271 
272     /**
273      * @dev See {IERC165-supportsInterface}.
274      *
275      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
276      */
277     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
278         return _supportedInterfaces[interfaceId];
279     }
280 
281     /**
282      * @dev Registers the contract as an implementer of the interface defined by
283      * `interfaceId`. Support of the actual ERC165 interface is automatic and
284      * registering its interface id is not required.
285      *
286      * See {IERC165-supportsInterface}.
287      *
288      * Requirements:
289      *
290      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
291      */
292     function _registerInterface(bytes4 interfaceId) internal virtual {
293         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
294         _supportedInterfaces[interfaceId] = true;
295     }
296 }
297 
298 // File: @openzeppelin/contracts/math/SafeMath.sol
299 
300 pragma solidity ^0.6.0;
301 
302 /**
303  * @dev Wrappers over Solidity's arithmetic operations with added overflow
304  * checks.
305  *
306  * Arithmetic operations in Solidity wrap on overflow. This can easily result
307  * in bugs, because programmers usually assume that an overflow raises an
308  * error, which is the standard behavior in high level programming languages.
309  * `SafeMath` restores this intuition by reverting the transaction when an
310  * operation overflows.
311  *
312  * Using this library instead of the unchecked operations eliminates an entire
313  * class of bugs, so it's recommended to use it always.
314  */
315 library SafeMath {
316     /**
317      * @dev Returns the addition of two unsigned integers, reverting on
318      * overflow.
319      *
320      * Counterpart to Solidity's `+` operator.
321      *
322      * Requirements:
323      *
324      * - Addition cannot overflow.
325      */
326     function add(uint256 a, uint256 b) internal pure returns (uint256) {
327         uint256 c = a + b;
328         require(c >= a, "SafeMath: addition overflow");
329 
330         return c;
331     }
332 
333     /**
334      * @dev Returns the subtraction of two unsigned integers, reverting on
335      * overflow (when the result is negative).
336      *
337      * Counterpart to Solidity's `-` operator.
338      *
339      * Requirements:
340      *
341      * - Subtraction cannot overflow.
342      */
343     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
344         return sub(a, b, "SafeMath: subtraction overflow");
345     }
346 
347     /**
348      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
349      * overflow (when the result is negative).
350      *
351      * Counterpart to Solidity's `-` operator.
352      *
353      * Requirements:
354      *
355      * - Subtraction cannot overflow.
356      */
357     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
358         require(b <= a, errorMessage);
359         uint256 c = a - b;
360 
361         return c;
362     }
363 
364     /**
365      * @dev Returns the multiplication of two unsigned integers, reverting on
366      * overflow.
367      *
368      * Counterpart to Solidity's `*` operator.
369      *
370      * Requirements:
371      *
372      * - Multiplication cannot overflow.
373      */
374     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
375         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
376         // benefit is lost if 'b' is also tested.
377         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
378         if (a == 0) {
379             return 0;
380         }
381 
382         uint256 c = a * b;
383         require(c / a == b, "SafeMath: multiplication overflow");
384 
385         return c;
386     }
387 
388     /**
389      * @dev Returns the integer division of two unsigned integers. Reverts on
390      * division by zero. The result is rounded towards zero.
391      *
392      * Counterpart to Solidity's `/` operator. Note: this function uses a
393      * `revert` opcode (which leaves remaining gas untouched) while Solidity
394      * uses an invalid opcode to revert (consuming all remaining gas).
395      *
396      * Requirements:
397      *
398      * - The divisor cannot be zero.
399      */
400     function div(uint256 a, uint256 b) internal pure returns (uint256) {
401         return div(a, b, "SafeMath: division by zero");
402     }
403 
404     /**
405      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
406      * division by zero. The result is rounded towards zero.
407      *
408      * Counterpart to Solidity's `/` operator. Note: this function uses a
409      * `revert` opcode (which leaves remaining gas untouched) while Solidity
410      * uses an invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
417         require(b > 0, errorMessage);
418         uint256 c = a / b;
419         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
420 
421         return c;
422     }
423 
424     /**
425      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
426      * Reverts when dividing by zero.
427      *
428      * Counterpart to Solidity's `%` operator. This function uses a `revert`
429      * opcode (which leaves remaining gas untouched) while Solidity uses an
430      * invalid opcode to revert (consuming all remaining gas).
431      *
432      * Requirements:
433      *
434      * - The divisor cannot be zero.
435      */
436     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
437         return mod(a, b, "SafeMath: modulo by zero");
438     }
439 
440     /**
441      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
442      * Reverts with custom message when dividing by zero.
443      *
444      * Counterpart to Solidity's `%` operator. This function uses a `revert`
445      * opcode (which leaves remaining gas untouched) while Solidity uses an
446      * invalid opcode to revert (consuming all remaining gas).
447      *
448      * Requirements:
449      *
450      * - The divisor cannot be zero.
451      */
452     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
453         require(b != 0, errorMessage);
454         return a % b;
455     }
456 }
457 
458 // File: @openzeppelin/contracts/utils/Address.sol
459 
460 pragma solidity ^0.6.2;
461 
462 /**
463  * @dev Collection of functions related to the address type
464  */
465 library Address {
466     /**
467      * @dev Returns true if `account` is a contract.
468      *
469      * [IMPORTANT]
470      * ====
471      * It is unsafe to assume that an address for which this function returns
472      * false is an externally-owned account (EOA) and not a contract.
473      *
474      * Among others, `isContract` will return false for the following
475      * types of addresses:
476      *
477      *  - an externally-owned account
478      *  - a contract in construction
479      *  - an address where a contract will be created
480      *  - an address where a contract lived, but was destroyed
481      * ====
482      */
483     function isContract(address account) internal view returns (bool) {
484         // This method relies in extcodesize, which returns 0 for contracts in
485         // construction, since the code is only stored at the end of the
486         // constructor execution.
487 
488         uint256 size;
489         // solhint-disable-next-line no-inline-assembly
490         assembly { size := extcodesize(account) }
491         return size > 0;
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      */
510     function sendValue(address payable recipient, uint256 amount) internal {
511         require(address(this).balance >= amount, "Address: insufficient balance");
512 
513         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
514         (bool success, ) = recipient.call{ value: amount }("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain`call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537       return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
547         return _functionCallWithValue(target, data, 0, errorMessage);
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
561     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
562         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
567      * with `errorMessage` as a fallback revert reason when `target` reverts.
568      *
569      * _Available since v3.1._
570      */
571     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
572         require(address(this).balance >= value, "Address: insufficient balance for call");
573         return _functionCallWithValue(target, data, value, errorMessage);
574     }
575 
576     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
577         require(isContract(target), "Address: call to non-contract");
578 
579         // solhint-disable-next-line avoid-low-level-calls
580         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
581         if (success) {
582             return returndata;
583         } else {
584             // Look for revert reason and bubble it up if present
585             if (returndata.length > 0) {
586                 // The easiest way to bubble the revert reason is using memory via assembly
587 
588                 // solhint-disable-next-line no-inline-assembly
589                 assembly {
590                     let returndata_size := mload(returndata)
591                     revert(add(32, returndata), returndata_size)
592                 }
593             } else {
594                 revert(errorMessage);
595             }
596         }
597     }
598 }
599 
600 // File: contracts/ERC1155.sol
601 
602 pragma solidity ^0.6.0;
603 
604 
605 
606 
607 
608 
609 
610 /**
611  *
612  * Modified version of OpenZeppelin's ERC1155 implementation for Pepe purposes. Basically, remove metadata
613  * from this contract
614  * see https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
615  *
616  * _Available since v3.1._
617  */
618 contract ERC1155 is Context, ERC165, IERC1155 {
619     using SafeMath for uint256;
620     using Address for address;
621 
622     // Mapping from token ID to account balances
623     mapping (uint256 => mapping(address => uint256)) private _balances;
624 
625     // Mapping from account to operator approvals
626     mapping (address => mapping(address => bool)) private _operatorApprovals;
627 
628     /*
629      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
630      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
631      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
632      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
633      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
634      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
635      *
636      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
637      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
638      */
639     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
640 
641     constructor () public {
642         // register the supported interfaces to conform to ERC1155 via ERC165
643         _registerInterface(_INTERFACE_ID_ERC1155);
644     }
645 
646     /**
647      * @dev See {IERC1155-balanceOf}.
648      *
649      * Requirements:
650      *
651      * - `account` cannot be the zero address.
652      */
653     function balanceOf(address account, uint256 id) public view override returns (uint256) {
654         require(account != address(0), "ERC1155: balance query for the zero address");
655         return _balances[id][account];
656     }
657 
658     /**
659     * @dev See {IERC1155-balanceOfBatch}.
660     *
661         * Requirements:
662         *
663         * - `accounts` and `ids` must have the same length.
664         */
665     function balanceOfBatch(
666         address[] memory accounts,
667         uint256[] memory ids
668     )
669     public
670     view
671     override
672     returns (uint256[] memory)
673     {
674         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
675 
676         uint256[] memory batchBalances = new uint256[](accounts.length);
677 
678         for (uint256 i = 0; i < accounts.length; ++i) {
679             require(accounts[i] != address(0), "ERC1155: batch balance query for the zero address");
680             batchBalances[i] = _balances[ids[i]][accounts[i]];
681         }
682 
683         return batchBalances;
684     }
685 
686     /**
687     * @dev See {IERC1155-setApprovalForAll}.
688     */
689     function setApprovalForAll(address operator, bool approved) public virtual override {
690         require(_msgSender() != operator, "ERC1155: setting approval status for self");
691 
692         _operatorApprovals[_msgSender()][operator] = approved;
693         emit ApprovalForAll(_msgSender(), operator, approved);
694     }
695 
696     /**
697     * @dev See {IERC1155-isApprovedForAll}.
698     */
699     function isApprovedForAll(address account, address operator) public view override returns (bool) {
700         return _operatorApprovals[account][operator];
701     }
702 
703     /**
704     * @dev See {IERC1155-safeTransferFrom}.
705     */
706     function safeTransferFrom(
707         address from,
708         address to,
709         uint256 id,
710         uint256 amount,
711         bytes memory data
712     )
713     public
714     virtual
715     override
716     {
717         require(to != address(0), "ERC1155: transfer to the zero address");
718         require(
719             from == _msgSender() || isApprovedForAll(from, _msgSender()),
720             "ERC1155: caller is not owner nor approved"
721         );
722 
723         address operator = _msgSender();
724 
725         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
726 
727         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
728         _balances[id][to] = _balances[id][to].add(amount);
729 
730         emit TransferSingle(operator, from, to, id, amount);
731 
732         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
733     }
734 
735     /**
736     * @dev See {IERC1155-safeBatchTransferFrom}.
737     */
738     function safeBatchTransferFrom(
739         address from,
740         address to,
741         uint256[] memory ids,
742         uint256[] memory amounts,
743         bytes memory data
744     )
745     public
746     virtual
747     override
748     {
749         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
750         require(to != address(0), "ERC1155: transfer to the zero address");
751         require(
752             from == _msgSender() || isApprovedForAll(from, _msgSender()),
753             "ERC1155: transfer caller is not owner nor approved"
754         );
755 
756         address operator = _msgSender();
757 
758         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
759 
760         for (uint256 i = 0; i < ids.length; ++i) {
761             uint256 id = ids[i];
762             uint256 amount = amounts[i];
763 
764             _balances[id][from] = _balances[id][from].sub(
765                 amount,
766                 "ERC1155: insufficient balance for transfer"
767             );
768             _balances[id][to] = _balances[id][to].add(amount);
769         }
770 
771         emit TransferBatch(operator, from, to, ids, amounts);
772 
773         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
774     }
775 
776     /**
777     * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
778     *
779         * Emits a {TransferSingle} event.
780         *
781         * Requirements:
782         *
783         * - `account` cannot be the zero address.
784         * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
785     * acceptance magic value.
786         */
787     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
788         require(account != address(0), "ERC1155: mint to the zero address");
789 
790         address operator = _msgSender();
791 
792         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
793 
794         _balances[id][account] = _balances[id][account].add(amount);
795         emit TransferSingle(operator, address(0), account, id, amount);
796 
797         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
798     }
799 
800     /**
801     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
802     *
803         * Requirements:
804         *
805         * - `ids` and `amounts` must have the same length.
806         * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
807     * acceptance magic value.
808         */
809     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
810         require(to != address(0), "ERC1155: mint to the zero address");
811         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
812 
813         address operator = _msgSender();
814 
815         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
816 
817         for (uint i = 0; i < ids.length; i++) {
818             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
819         }
820 
821         emit TransferBatch(operator, address(0), to, ids, amounts);
822 
823         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
824     }
825 
826     /**
827     * @dev Destroys `amount` tokens of token type `id` from `account`
828     *
829         * Requirements:
830         *
831         * - `account` cannot be the zero address.
832         * - `account` must have at least `amount` tokens of token type `id`.
833         */
834     function _burn(address account, uint256 id, uint256 amount) internal virtual {
835         require(account != address(0), "ERC1155: burn from the zero address");
836 
837         address operator = _msgSender();
838 
839         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
840 
841         _balances[id][account] = _balances[id][account].sub(
842             amount,
843             "ERC1155: burn amount exceeds balance"
844         );
845 
846         emit TransferSingle(operator, account, address(0), id, amount);
847     }
848 
849     /**
850     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
851     *
852         * Requirements:
853         *
854         * - `ids` and `amounts` must have the same length.
855         */
856     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
857         require(account != address(0), "ERC1155: burn from the zero address");
858         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
859 
860         address operator = _msgSender();
861 
862         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
863 
864         for (uint i = 0; i < ids.length; i++) {
865             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
866                 amounts[i],
867                 "ERC1155: burn amount exceeds balance"
868             );
869         }
870 
871         emit TransferBatch(operator, account, address(0), ids, amounts);
872     }
873 
874     /**
875     * @dev Hook that is called before any token transfer. This includes minting
876     * and burning, as well as batched variants.
877         *
878         * The same hook is called on both single and batched variants. For single
879     * transfers, the length of the `id` and `amount` arrays will be 1.
880         *
881         * Calling conditions (for each `id` and `amount` pair):
882         *
883         * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
884     * of token type `id` will be  transferred to `to`.
885     * - When `from` is zero, `amount` tokens of token type `id` will be minted
886     * for `to`.
887             * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
888         * will be burned.
889     * - `from` and `to` are never both zero.
890         * - `ids` and `amounts` have the same, non-zero length.
891         *
892         * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
893         */
894     function _beforeTokenTransfer(
895         address operator,
896         address from,
897         address to,
898         uint256[] memory ids,
899         uint256[] memory amounts,
900         bytes memory data
901     )
902     internal virtual
903     { }
904 
905     function _doSafeTransferAcceptanceCheck(
906         address operator,
907         address from,
908         address to,
909         uint256 id,
910         uint256 amount,
911         bytes memory data
912     )
913     private
914     {
915         if (to.isContract()) {
916             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
917                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
918                     revert("ERC1155: ERC1155Receiver rejected tokens");
919                 }
920             } catch Error(string memory reason) {
921                 revert(reason);
922             } catch {
923                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
924             }
925         }
926     }
927 
928     function _doSafeBatchTransferAcceptanceCheck(
929         address operator,
930         address from,
931         address to,
932         uint256[] memory ids,
933         uint256[] memory amounts,
934         bytes memory data
935     )
936     private
937     {
938         if (to.isContract()) {
939             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
940                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
941                     revert("ERC1155: ERC1155Receiver rejected tokens");
942                 }
943             } catch Error(string memory reason) {
944                 revert(reason);
945             } catch {
946                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
947             }
948         }
949     }
950 
951     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
952         uint256[] memory array = new uint256[](1);
953         array[0] = element;
954 
955         return array;
956     }
957 }
958 
959 // File: contracts/PepeV2.sol
960 
961 pragma solidity =0.6.11;
962 pragma experimental ABIEncoderV2;
963 
964 
965 
966 
967 contract PepeV2 is ERC1155(), IERC1155MetadataURI, Mintable {
968     /*
969      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
970      */
971     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
972 
973     address public immutable minterAddress;
974 
975     // Metadata mappings. 'sig' is the intermediate that was used in the initial PepeCore contract
976     mapping(bytes32 => string) public sigToIpfsHash;
977     mapping(uint256 => bytes32) public tokenIdToSig;
978 
979     constructor(address _minterAddress, bytes32[58] memory _orderedSigs, string[58] memory _orderedIpfsHashes) public {
980         minterAddress = _minterAddress;
981 
982         for (uint256 i = 0; i < 58; i++) {
983             sigToIpfsHash[_orderedSigs[i]] = _orderedIpfsHashes[i];
984         }
985 
986         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
987         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
988     }
989 
990     function setTokenId(uint256 id, bytes32 sig) external override {
991         require(msg.sender == minterAddress, "PepeV2: Can only set token ID from minter address");
992 
993         require(tokenIdToSig[id] == 0, "PepeV2: can only set token ID sig once");
994 
995         tokenIdToSig[id] = sig;
996     }
997 
998     function mint(address account, uint256 id, uint256 amount) external override {
999         require(msg.sender == minterAddress, "PepeV2: Can only mint from minter address");
1000 
1001         _mint(account, id, amount, "0x0");
1002     }
1003 
1004     function uri(uint256 id) external view override returns (string memory) {
1005         string storage ipfsHash = sigToIpfsHash[tokenIdToSig[id]];
1006 
1007         // NOTE: bytes conversion just for empty test
1008         bytes memory tmpIpfsBytes = bytes(ipfsHash);
1009         require(tmpIpfsBytes.length > 0, "PepeV2: Can only return URI for known token IDs");
1010 
1011         return string(abi.encodePacked("ipfs://ipfs/", ipfsHash));
1012     }
1013 }