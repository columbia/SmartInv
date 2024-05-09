1 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
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
25     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
26 }
27 
28 // File: node_modules\@openzeppelin\contracts\token\ERC1155\IERC1155.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.2;
33 
34 
35 /**
36  * @dev Required interface of an ERC1155 compliant contract, as defined in the
37  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
38  *
39  * _Available since v3.1._
40  */
41 interface IERC1155 is IERC165 {
42     /**
43      * @dev Emitted when `value` tokens of token type `id` are transfered from `from` to `to` by `operator`.
44      */
45     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
46 
47     /**
48      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
49      * transfers.
50      */
51     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
52 
53     /**
54      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
55      * `approved`.
56      */
57     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
58 
59     /**
60      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
61      *
62      * If an {URI} event was emitted for `id`, the standard
63      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
64      * returned by {IERC1155MetadataURI-uri}.
65      */
66     event URI(string value, uint256 indexed id);
67 
68     /**
69      * @dev Returns the amount of tokens of token type `id` owned by `account`.
70      *
71      * Requirements:
72      *
73      * - `account` cannot be the zero address.
74      */
75     function balanceOf(address account, uint256 id) external view returns (uint256);
76 
77     /**
78      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
79      *
80      * Requirements:
81      *
82      * - `accounts` and `ids` must have the same length.
83      */
84     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
85 
86     /**
87      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
88      *
89      * Emits an {ApprovalForAll} event.
90      *
91      * Requirements:
92      *
93      * - `operator` cannot be the caller.
94      */
95     function setApprovalForAll(address operator, bool approved) external;
96 
97     /**
98      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
99      *
100      * See {setApprovalForAll}.
101      */
102     function isApprovedForAll(address account, address operator) external view returns (bool);
103 
104     /**
105      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
106      *
107      * Emits a {TransferSingle} event.
108      *
109      * Requirements:
110      *
111      * - `to` cannot be the zero address.
112      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
113      * - `from` must have a balance of tokens of type `id` of at least `amount`.
114      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
115      * acceptance magic value.
116      */
117     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
118 
119     /**
120      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
121      *
122      * Emits a {TransferBatch} event.
123      *
124      * Requirements:
125      *
126      * - `ids` and `amounts` must have the same length.
127      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
128      * acceptance magic value.
129      */
130     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
131 }
132 
133 // File: node_modules\@openzeppelin\contracts\token\ERC1155\IERC1155MetadataURI.sol
134 
135 // SPDX-License-Identifier: MIT
136 
137 pragma solidity ^0.6.2;
138 
139 
140 /**
141  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
142  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
143  *
144  * _Available since v3.1._
145  */
146 interface IERC1155MetadataURI is IERC1155 {
147     /**
148      * @dev Returns the URI for token type `id`.
149      *
150      * If the `\{id\}` substring is present in the URI, it must be replaced by
151      * clients with the actual token type ID.
152      */
153     function uri(uint256 id) external view returns (string memory);
154 }
155 
156 // File: node_modules\@openzeppelin\contracts\token\ERC1155\IERC1155Receiver.sol
157 
158 // SPDX-License-Identifier: MIT
159 
160 pragma solidity ^0.6.0;
161 
162 
163 /**
164  * _Available since v3.1._
165  */
166 interface IERC1155Receiver is IERC165 {
167 
168     /**
169         @dev Handles the receipt of a single ERC1155 token type. This function is
170         called at the end of a `safeTransferFrom` after the balance has been updated.
171         To accept the transfer, this must return
172         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
173         (i.e. 0xf23a6e61, or its own function selector).
174         @param operator The address which initiated the transfer (i.e. msg.sender)
175         @param from The address which previously owned the token
176         @param id The ID of the token being transferred
177         @param value The amount of tokens being transferred
178         @param data Additional data with no specified format
179         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
180     */
181     function onERC1155Received(
182         address operator,
183         address from,
184         uint256 id,
185         uint256 value,
186         bytes calldata data
187     )
188         external
189         returns(bytes4);
190 
191     /**
192         @dev Handles the receipt of a multiple ERC1155 token types. This function
193         is called at the end of a `safeBatchTransferFrom` after the balances have
194         been updated. To accept the transfer(s), this must return
195         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
196         (i.e. 0xbc197c81, or its own function selector).
197         @param operator The address which initiated the batch transfer (i.e. msg.sender)
198         @param from The address which previously owned the token
199         @param ids An array containing ids of each token being transferred (order and length must match values array)
200         @param values An array containing amounts of each token being transferred (order and length must match ids array)
201         @param data Additional data with no specified format
202         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
203     */
204     function onERC1155BatchReceived(
205         address operator,
206         address from,
207         uint256[] calldata ids,
208         uint256[] calldata values,
209         bytes calldata data
210     )
211         external
212         returns(bytes4);
213 }
214 
215 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
216 
217 // SPDX-License-Identifier: MIT
218 
219 pragma solidity ^0.6.0;
220 
221 /*
222  * @dev Provides information about the current execution context, including the
223  * sender of the transaction and its data. While these are generally available
224  * via msg.sender and msg.data, they should not be accessed in such a direct
225  * manner, since when dealing with GSN meta-transactions the account sending and
226  * paying for execution may not be the actual sender (as far as an application
227  * is concerned).
228  *
229  * This contract is only required for intermediate, library-like contracts.
230  */
231 abstract contract Context {
232     function _msgSender() internal view virtual returns (address payable) {
233         return msg.sender;
234     }
235 
236     function _msgData() internal view virtual returns (bytes memory) {
237         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
238         return msg.data;
239     }
240 }
241 
242 // File: node_modules\@openzeppelin\contracts\introspection\ERC165.sol
243 
244 // SPDX-License-Identifier: MIT
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
298 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
299 
300 // SPDX-License-Identifier: MIT
301 
302 pragma solidity ^0.6.0;
303 
304 /**
305  * @dev Wrappers over Solidity's arithmetic operations with added overflow
306  * checks.
307  *
308  * Arithmetic operations in Solidity wrap on overflow. This can easily result
309  * in bugs, because programmers usually assume that an overflow raises an
310  * error, which is the standard behavior in high level programming languages.
311  * `SafeMath` restores this intuition by reverting the transaction when an
312  * operation overflows.
313  *
314  * Using this library instead of the unchecked operations eliminates an entire
315  * class of bugs, so it's recommended to use it always.
316  */
317 library SafeMath {
318     /**
319      * @dev Returns the addition of two unsigned integers, reverting on
320      * overflow.
321      *
322      * Counterpart to Solidity's `+` operator.
323      *
324      * Requirements:
325      *
326      * - Addition cannot overflow.
327      */
328     function add(uint256 a, uint256 b) internal pure returns (uint256) {
329         uint256 c = a + b;
330         require(c >= a, "SafeMath: addition overflow");
331 
332         return c;
333     }
334 
335     /**
336      * @dev Returns the subtraction of two unsigned integers, reverting on
337      * overflow (when the result is negative).
338      *
339      * Counterpart to Solidity's `-` operator.
340      *
341      * Requirements:
342      *
343      * - Subtraction cannot overflow.
344      */
345     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
346         return sub(a, b, "SafeMath: subtraction overflow");
347     }
348 
349     /**
350      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
351      * overflow (when the result is negative).
352      *
353      * Counterpart to Solidity's `-` operator.
354      *
355      * Requirements:
356      *
357      * - Subtraction cannot overflow.
358      */
359     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
360         require(b <= a, errorMessage);
361         uint256 c = a - b;
362 
363         return c;
364     }
365 
366     /**
367      * @dev Returns the multiplication of two unsigned integers, reverting on
368      * overflow.
369      *
370      * Counterpart to Solidity's `*` operator.
371      *
372      * Requirements:
373      *
374      * - Multiplication cannot overflow.
375      */
376     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
377         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
378         // benefit is lost if 'b' is also tested.
379         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
380         if (a == 0) {
381             return 0;
382         }
383 
384         uint256 c = a * b;
385         require(c / a == b, "SafeMath: multiplication overflow");
386 
387         return c;
388     }
389 
390     /**
391      * @dev Returns the integer division of two unsigned integers. Reverts on
392      * division by zero. The result is rounded towards zero.
393      *
394      * Counterpart to Solidity's `/` operator. Note: this function uses a
395      * `revert` opcode (which leaves remaining gas untouched) while Solidity
396      * uses an invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      *
400      * - The divisor cannot be zero.
401      */
402     function div(uint256 a, uint256 b) internal pure returns (uint256) {
403         return div(a, b, "SafeMath: division by zero");
404     }
405 
406     /**
407      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
408      * division by zero. The result is rounded towards zero.
409      *
410      * Counterpart to Solidity's `/` operator. Note: this function uses a
411      * `revert` opcode (which leaves remaining gas untouched) while Solidity
412      * uses an invalid opcode to revert (consuming all remaining gas).
413      *
414      * Requirements:
415      *
416      * - The divisor cannot be zero.
417      */
418     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
419         require(b > 0, errorMessage);
420         uint256 c = a / b;
421         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
422 
423         return c;
424     }
425 
426     /**
427      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
428      * Reverts when dividing by zero.
429      *
430      * Counterpart to Solidity's `%` operator. This function uses a `revert`
431      * opcode (which leaves remaining gas untouched) while Solidity uses an
432      * invalid opcode to revert (consuming all remaining gas).
433      *
434      * Requirements:
435      *
436      * - The divisor cannot be zero.
437      */
438     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
439         return mod(a, b, "SafeMath: modulo by zero");
440     }
441 
442     /**
443      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
444      * Reverts with custom message when dividing by zero.
445      *
446      * Counterpart to Solidity's `%` operator. This function uses a `revert`
447      * opcode (which leaves remaining gas untouched) while Solidity uses an
448      * invalid opcode to revert (consuming all remaining gas).
449      *
450      * Requirements:
451      *
452      * - The divisor cannot be zero.
453      */
454     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
455         require(b != 0, errorMessage);
456         return a % b;
457     }
458 }
459 
460 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
461 
462 // SPDX-License-Identifier: MIT
463 
464 pragma solidity ^0.6.2;
465 
466 /**
467  * @dev Collection of functions related to the address type
468  */
469 library Address {
470     /**
471      * @dev Returns true if `account` is a contract.
472      *
473      * [IMPORTANT]
474      * ====
475      * It is unsafe to assume that an address for which this function returns
476      * false is an externally-owned account (EOA) and not a contract.
477      *
478      * Among others, `isContract` will return false for the following
479      * types of addresses:
480      *
481      *  - an externally-owned account
482      *  - a contract in construction
483      *  - an address where a contract will be created
484      *  - an address where a contract lived, but was destroyed
485      * ====
486      */
487     function isContract(address account) internal view returns (bool) {
488         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
489         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
490         // for accounts without code, i.e. `keccak256('')`
491         bytes32 codehash;
492         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
493         // solhint-disable-next-line no-inline-assembly
494         assembly { codehash := extcodehash(account) }
495         return (codehash != accountHash && codehash != 0x0);
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(address(this).balance >= amount, "Address: insufficient balance");
516 
517         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
518         (bool success, ) = recipient.call{ value: amount }("");
519         require(success, "Address: unable to send value, recipient may have reverted");
520     }
521 
522     /**
523      * @dev Performs a Solidity function call using a low level `call`. A
524      * plain`call` is an unsafe replacement for a function call: use this
525      * function instead.
526      *
527      * If `target` reverts with a revert reason, it is bubbled up by this
528      * function (like regular Solidity function calls).
529      *
530      * Returns the raw returned data. To convert to the expected return value,
531      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
532      *
533      * Requirements:
534      *
535      * - `target` must be a contract.
536      * - calling `target` with `data` must not revert.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
541       return functionCall(target, data, "Address: low-level call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
546      * `errorMessage` as a fallback revert reason when `target` reverts.
547      *
548      * _Available since v3.1._
549      */
550     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
551         return _functionCallWithValue(target, data, 0, errorMessage);
552     }
553 
554     /**
555      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
556      * but also transferring `value` wei to `target`.
557      *
558      * Requirements:
559      *
560      * - the calling contract must have an ETH balance of at least `value`.
561      * - the called Solidity function must be `payable`.
562      *
563      * _Available since v3.1._
564      */
565     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
566         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
571      * with `errorMessage` as a fallback revert reason when `target` reverts.
572      *
573      * _Available since v3.1._
574      */
575     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
576         require(address(this).balance >= value, "Address: insufficient balance for call");
577         return _functionCallWithValue(target, data, value, errorMessage);
578     }
579 
580     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
581         require(isContract(target), "Address: call to non-contract");
582 
583         // solhint-disable-next-line avoid-low-level-calls
584         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
585         if (success) {
586             return returndata;
587         } else {
588             // Look for revert reason and bubble it up if present
589             if (returndata.length > 0) {
590                 // The easiest way to bubble the revert reason is using memory via assembly
591 
592                 // solhint-disable-next-line no-inline-assembly
593                 assembly {
594                     let returndata_size := mload(returndata)
595                     revert(add(32, returndata), returndata_size)
596                 }
597             } else {
598                 revert(errorMessage);
599             }
600         }
601     }
602 }
603 
604 // File: @openzeppelin\contracts\token\ERC1155\ERC1155.sol
605 
606 // SPDX-License-Identifier: MIT
607 
608 pragma solidity ^0.6.0;
609 
610 
611 
612 
613 
614 
615 
616 
617 /**
618  *
619  * @dev Implementation of the basic standard multi-token.
620  * See https://eips.ethereum.org/EIPS/eip-1155
621  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
622  *
623  * _Available since v3.1._
624  */
625 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
626     using SafeMath for uint256;
627     using Address for address;
628 
629     // Mapping from token ID to account balances
630     mapping (uint256 => mapping(address => uint256)) internal _balances;
631 
632     // Mapping from account to operator approvals
633     mapping (address => mapping(address => bool)) private _operatorApprovals;
634 
635     // Used as the URI for all token types by relying on ID substition, e.g. https://token-cdn-domain/{id}.json
636     string private _uri;
637 
638     /*
639      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
640      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
641      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
642      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
643      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
644      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
645      *
646      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
647      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
648      */
649     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
650 
651     /*
652      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
653      */
654     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
655 
656     /**
657      * @dev See {_setURI}.
658      */
659     constructor (string memory uri) public {
660         _setURI(uri);
661 
662         // register the supported interfaces to conform to ERC1155 via ERC165
663         _registerInterface(_INTERFACE_ID_ERC1155);
664 
665         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
666         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
667     }
668 
669     /**
670      * @dev See {IERC1155MetadataURI-uri}.
671      *
672      * This implementation returns the same URI for *all* token types. It relies
673      * on the token type ID substituion mechanism
674      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
675      *
676      * Clients calling this function must replace the `\{id\}` substring with the
677      * actual token type ID.
678      */
679     function uri(uint256) public view virtual override returns (string memory) {
680         return _uri;
681     }
682 
683     /**
684      * @dev See {IERC1155-balanceOf}.
685      *
686      * Requirements:
687      *
688      * - `account` cannot be the zero address.
689      */
690     function balanceOf(address account, uint256 id) public view override returns (uint256) {
691         require(account != address(0), "ERC1155: balance query for the zero address");
692         return _balances[id][account];
693     }
694 
695     /**
696      * @dev See {IERC1155-balanceOfBatch}.
697      *
698      * Requirements:
699      *
700      * - `accounts` and `ids` must have the same length.
701      */
702     function balanceOfBatch(
703         address[] memory accounts,
704         uint256[] memory ids
705     )
706         public
707         view
708         override
709         returns (uint256[] memory)
710     {
711         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
712 
713         uint256[] memory batchBalances = new uint256[](accounts.length);
714 
715         for (uint256 i = 0; i < accounts.length; ++i) {
716             require(accounts[i] != address(0), "ERC1155: batch balance query for the zero address");
717             batchBalances[i] = _balances[ids[i]][accounts[i]];
718         }
719 
720         return batchBalances;
721     }
722 
723     /**
724      * @dev See {IERC1155-setApprovalForAll}.
725      */
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         require(_msgSender() != operator, "ERC1155: setting approval status for self");
728 
729         _operatorApprovals[_msgSender()][operator] = approved;
730         emit ApprovalForAll(_msgSender(), operator, approved);
731     }
732 
733     /**
734      * @dev See {IERC1155-isApprovedForAll}.
735      */
736     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
737         return _operatorApprovals[account][operator];
738     }
739 
740     /**
741      * @dev See {IERC1155-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 id,
747         uint256 amount,
748         bytes memory data
749     )
750         public
751         virtual
752         override
753     {
754         require(to != address(0), "ERC1155: transfer to the zero address");
755         require(
756             from == _msgSender() || isApprovedForAll(from, _msgSender()),
757             "ERC1155: caller is not owner nor approved"
758         );
759 
760         address operator = _msgSender();
761 
762         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
763 
764         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
765         _balances[id][to] = _balances[id][to].add(amount);
766 
767         emit TransferSingle(operator, from, to, id, amount);
768 
769         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
770     }
771 
772     /**
773      * @dev See {IERC1155-safeBatchTransferFrom}.
774      */
775     function safeBatchTransferFrom(
776         address from,
777         address to,
778         uint256[] memory ids,
779         uint256[] memory amounts,
780         bytes memory data
781     )
782         public
783         virtual
784         override
785     {
786         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
787         require(to != address(0), "ERC1155: transfer to the zero address");
788         require(
789             from == _msgSender() || isApprovedForAll(from, _msgSender()),
790             "ERC1155: transfer caller is not owner nor approved"
791         );
792 
793         address operator = _msgSender();
794 
795         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
796 
797         for (uint256 i = 0; i < ids.length; ++i) {
798             uint256 id = ids[i];
799             uint256 amount = amounts[i];
800 
801             _balances[id][from] = _balances[id][from].sub(
802                 amount,
803                 "ERC1155: insufficient balance for transfer"
804             );
805             _balances[id][to] = _balances[id][to].add(amount);
806         }
807 
808         emit TransferBatch(operator, from, to, ids, amounts);
809 
810         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
811     }
812 
813     /**
814      * @dev Sets a new URI for all token types, by relying on the token type ID
815      * substituion mechanism
816      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
817      *
818      * By this mechanism, any occurence of the `\{id\}` substring in either the
819      * URI or any of the amounts in the JSON file at said URI will be replaced by
820      * clients with the token type ID.
821      *
822      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
823      * interpreted by clients as
824      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
825      * for token type ID 0x4cce0.
826      *
827      * See {uri}.
828      *
829      * Because these URIs cannot be meaningfully represented by the {URI} event,
830      * this function emits no events.
831      */
832     function _setURI(string memory newuri) internal virtual {
833         _uri = newuri;
834     }
835 
836     /**
837      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
838      *
839      * Emits a {TransferSingle} event.
840      *
841      * Requirements:
842      *
843      * - `account` cannot be the zero address.
844      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
845      * acceptance magic value.
846      */
847     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
848         require(account != address(0), "ERC1155: mint to the zero address");
849 
850         address operator = _msgSender();
851 
852         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
853 
854         _balances[id][account] = _balances[id][account].add(amount);
855         emit TransferSingle(operator, address(0), account, id, amount);
856 
857         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
858     }
859 
860     /**
861      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
862      *
863      * Requirements:
864      *
865      * - `ids` and `amounts` must have the same length.
866      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
867      * acceptance magic value.
868      */
869     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
870         require(to != address(0), "ERC1155: mint to the zero address");
871         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
872 
873         address operator = _msgSender();
874 
875         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
876 
877         for (uint i = 0; i < ids.length; i++) {
878             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
879         }
880 
881         emit TransferBatch(operator, address(0), to, ids, amounts);
882 
883         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
884     }
885 
886     /**
887      * @dev Destroys `amount` tokens of token type `id` from `account`
888      *
889      * Requirements:
890      *
891      * - `account` cannot be the zero address.
892      * - `account` must have at least `amount` tokens of token type `id`.
893      */
894     function _burn(address account, uint256 id, uint256 amount) internal virtual {
895         require(account != address(0), "ERC1155: burn from the zero address");
896 
897         address operator = _msgSender();
898 
899         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
900 
901         _balances[id][account] = _balances[id][account].sub(
902             amount,
903             "ERC1155: burn amount exceeds balance"
904         );
905 
906         emit TransferSingle(operator, account, address(0), id, amount);
907     }
908 
909     /**
910      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
911      *
912      * Requirements:
913      *
914      * - `ids` and `amounts` must have the same length.
915      */
916     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
917         require(account != address(0), "ERC1155: burn from the zero address");
918         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
919 
920         address operator = _msgSender();
921 
922         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
923 
924         for (uint i = 0; i < ids.length; i++) {
925             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
926                 amounts[i],
927                 "ERC1155: burn amount exceeds balance"
928             );
929         }
930 
931         emit TransferBatch(operator, account, address(0), ids, amounts);
932     }
933 
934     /**
935      * @dev Hook that is called before any token transfer. This includes minting
936      * and burning, as well as batched variants.
937      *
938      * The same hook is called on both single and batched variants. For single
939      * transfers, the length of the `id` and `amount` arrays will be 1.
940      *
941      * Calling conditions (for each `id` and `amount` pair):
942      *
943      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
944      * of token type `id` will be  transferred to `to`.
945      * - When `from` is zero, `amount` tokens of token type `id` will be minted
946      * for `to`.
947      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
948      * will be burned.
949      * - `from` and `to` are never both zero.
950      * - `ids` and `amounts` have the same, non-zero length.
951      *
952      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
953      */
954     function _beforeTokenTransfer(
955         address operator,
956         address from,
957         address to,
958         uint256[] memory ids,
959         uint256[] memory amounts,
960         bytes memory data
961     )
962         internal virtual
963     { }
964 
965     function _doSafeTransferAcceptanceCheck(
966         address operator,
967         address from,
968         address to,
969         uint256 id,
970         uint256 amount,
971         bytes memory data
972     )
973         internal
974     {
975         if (to.isContract()) {
976             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
977                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
978                     revert("ERC1155: ERC1155Receiver rejected tokens");
979                 }
980             } catch Error(string memory reason) {
981                 revert(reason);
982             } catch {
983                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
984             }
985         }
986     }
987 
988     function _doSafeBatchTransferAcceptanceCheck(
989         address operator,
990         address from,
991         address to,
992         uint256[] memory ids,
993         uint256[] memory amounts,
994         bytes memory data
995     )
996         internal
997     {
998         if (to.isContract()) {
999             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1000                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1001                     revert("ERC1155: ERC1155Receiver rejected tokens");
1002                 }
1003             } catch Error(string memory reason) {
1004                 revert(reason);
1005             } catch {
1006                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1007             }
1008         }
1009     }
1010 
1011     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1012         uint256[] memory array = new uint256[](1);
1013         array[0] = element;
1014 
1015         return array;
1016     }
1017 }
1018 
1019 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
1020 
1021 // SPDX-License-Identifier: MIT
1022 
1023 pragma solidity ^0.6.0;
1024 
1025 /**
1026  * @dev Library for managing
1027  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1028  * types.
1029  *
1030  * Sets have the following properties:
1031  *
1032  * - Elements are added, removed, and checked for existence in constant time
1033  * (O(1)).
1034  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1035  *
1036  * ```
1037  * contract Example {
1038  *     // Add the library methods
1039  *     using EnumerableSet for EnumerableSet.AddressSet;
1040  *
1041  *     // Declare a set state variable
1042  *     EnumerableSet.AddressSet private mySet;
1043  * }
1044  * ```
1045  *
1046  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1047  * (`UintSet`) are supported.
1048  */
1049 library EnumerableSet {
1050     // To implement this library for multiple types with as little code
1051     // repetition as possible, we write it in terms of a generic Set type with
1052     // bytes32 values.
1053     // The Set implementation uses private functions, and user-facing
1054     // implementations (such as AddressSet) are just wrappers around the
1055     // underlying Set.
1056     // This means that we can only create new EnumerableSets for types that fit
1057     // in bytes32.
1058 
1059     struct Set {
1060         // Storage of set values
1061         bytes32[] _values;
1062 
1063         // Position of the value in the `values` array, plus 1 because index 0
1064         // means a value is not in the set.
1065         mapping (bytes32 => uint256) _indexes;
1066     }
1067 
1068     /**
1069      * @dev Add a value to a set. O(1).
1070      *
1071      * Returns true if the value was added to the set, that is if it was not
1072      * already present.
1073      */
1074     function _add(Set storage set, bytes32 value) private returns (bool) {
1075         if (!_contains(set, value)) {
1076             set._values.push(value);
1077             // The value is stored at length-1, but we add 1 to all indexes
1078             // and use 0 as a sentinel value
1079             set._indexes[value] = set._values.length;
1080             return true;
1081         } else {
1082             return false;
1083         }
1084     }
1085 
1086     /**
1087      * @dev Removes a value from a set. O(1).
1088      *
1089      * Returns true if the value was removed from the set, that is if it was
1090      * present.
1091      */
1092     function _remove(Set storage set, bytes32 value) private returns (bool) {
1093         // We read and store the value's index to prevent multiple reads from the same storage slot
1094         uint256 valueIndex = set._indexes[value];
1095 
1096         if (valueIndex != 0) { // Equivalent to contains(set, value)
1097             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1098             // the array, and then remove the last element (sometimes called as 'swap and pop').
1099             // This modifies the order of the array, as noted in {at}.
1100 
1101             uint256 toDeleteIndex = valueIndex - 1;
1102             uint256 lastIndex = set._values.length - 1;
1103 
1104             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1105             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1106 
1107             bytes32 lastvalue = set._values[lastIndex];
1108 
1109             // Move the last value to the index where the value to delete is
1110             set._values[toDeleteIndex] = lastvalue;
1111             // Update the index for the moved value
1112             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1113 
1114             // Delete the slot where the moved value was stored
1115             set._values.pop();
1116 
1117             // Delete the index for the deleted slot
1118             delete set._indexes[value];
1119 
1120             return true;
1121         } else {
1122             return false;
1123         }
1124     }
1125 
1126     /**
1127      * @dev Returns true if the value is in the set. O(1).
1128      */
1129     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1130         return set._indexes[value] != 0;
1131     }
1132 
1133     /**
1134      * @dev Returns the number of values on the set. O(1).
1135      */
1136     function _length(Set storage set) private view returns (uint256) {
1137         return set._values.length;
1138     }
1139 
1140    /**
1141     * @dev Returns the value stored at position `index` in the set. O(1).
1142     *
1143     * Note that there are no guarantees on the ordering of values inside the
1144     * array, and it may change when more values are added or removed.
1145     *
1146     * Requirements:
1147     *
1148     * - `index` must be strictly less than {length}.
1149     */
1150     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1151         require(set._values.length > index, "EnumerableSet: index out of bounds");
1152         return set._values[index];
1153     }
1154 
1155     // AddressSet
1156 
1157     struct AddressSet {
1158         Set _inner;
1159     }
1160 
1161     /**
1162      * @dev Add a value to a set. O(1).
1163      *
1164      * Returns true if the value was added to the set, that is if it was not
1165      * already present.
1166      */
1167     function add(AddressSet storage set, address value) internal returns (bool) {
1168         return _add(set._inner, bytes32(uint256(value)));
1169     }
1170 
1171     /**
1172      * @dev Removes a value from a set. O(1).
1173      *
1174      * Returns true if the value was removed from the set, that is if it was
1175      * present.
1176      */
1177     function remove(AddressSet storage set, address value) internal returns (bool) {
1178         return _remove(set._inner, bytes32(uint256(value)));
1179     }
1180 
1181     /**
1182      * @dev Returns true if the value is in the set. O(1).
1183      */
1184     function contains(AddressSet storage set, address value) internal view returns (bool) {
1185         return _contains(set._inner, bytes32(uint256(value)));
1186     }
1187 
1188     /**
1189      * @dev Returns the number of values in the set. O(1).
1190      */
1191     function length(AddressSet storage set) internal view returns (uint256) {
1192         return _length(set._inner);
1193     }
1194 
1195    /**
1196     * @dev Returns the value stored at position `index` in the set. O(1).
1197     *
1198     * Note that there are no guarantees on the ordering of values inside the
1199     * array, and it may change when more values are added or removed.
1200     *
1201     * Requirements:
1202     *
1203     * - `index` must be strictly less than {length}.
1204     */
1205     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1206         return address(uint256(_at(set._inner, index)));
1207     }
1208 
1209 
1210     // UintSet
1211 
1212     struct UintSet {
1213         Set _inner;
1214     }
1215 
1216     /**
1217      * @dev Add a value to a set. O(1).
1218      *
1219      * Returns true if the value was added to the set, that is if it was not
1220      * already present.
1221      */
1222     function add(UintSet storage set, uint256 value) internal returns (bool) {
1223         return _add(set._inner, bytes32(value));
1224     }
1225 
1226     /**
1227      * @dev Removes a value from a set. O(1).
1228      *
1229      * Returns true if the value was removed from the set, that is if it was
1230      * present.
1231      */
1232     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1233         return _remove(set._inner, bytes32(value));
1234     }
1235 
1236     /**
1237      * @dev Returns true if the value is in the set. O(1).
1238      */
1239     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1240         return _contains(set._inner, bytes32(value));
1241     }
1242 
1243     /**
1244      * @dev Returns the number of values on the set. O(1).
1245      */
1246     function length(UintSet storage set) internal view returns (uint256) {
1247         return _length(set._inner);
1248     }
1249 
1250    /**
1251     * @dev Returns the value stored at position `index` in the set. O(1).
1252     *
1253     * Note that there are no guarantees on the ordering of values inside the
1254     * array, and it may change when more values are added or removed.
1255     *
1256     * Requirements:
1257     *
1258     * - `index` must be strictly less than {length}.
1259     */
1260     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1261         return uint256(_at(set._inner, index));
1262     }
1263 }
1264 
1265 // File: @openzeppelin\contracts\access\AccessControl.sol
1266 
1267 // SPDX-License-Identifier: MIT
1268 
1269 pragma solidity ^0.6.0;
1270 
1271 
1272 
1273 
1274 /**
1275  * @dev Contract module that allows children to implement role-based access
1276  * control mechanisms.
1277  *
1278  * Roles are referred to by their `bytes32` identifier. These should be exposed
1279  * in the external API and be unique. The best way to achieve this is by
1280  * using `public constant` hash digests:
1281  *
1282  * ```
1283  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1284  * ```
1285  *
1286  * Roles can be used to represent a set of permissions. To restrict access to a
1287  * function call, use {hasRole}:
1288  *
1289  * ```
1290  * function foo() public {
1291  *     require(hasRole(MY_ROLE, msg.sender));
1292  *     ...
1293  * }
1294  * ```
1295  *
1296  * Roles can be granted and revoked dynamically via the {grantRole} and
1297  * {revokeRole} functions. Each role has an associated admin role, and only
1298  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1299  *
1300  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1301  * that only accounts with this role will be able to grant or revoke other
1302  * roles. More complex role relationships can be created by using
1303  * {_setRoleAdmin}.
1304  *
1305  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1306  * grant and revoke this role. Extra precautions should be taken to secure
1307  * accounts that have been granted it.
1308  */
1309 abstract contract AccessControl is Context {
1310     using EnumerableSet for EnumerableSet.AddressSet;
1311     using Address for address;
1312 
1313     struct RoleData {
1314         EnumerableSet.AddressSet members;
1315         bytes32 adminRole;
1316     }
1317 
1318     mapping (bytes32 => RoleData) private _roles;
1319 
1320     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1321 
1322     /**
1323      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1324      *
1325      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1326      * {RoleAdminChanged} not being emitted signaling this.
1327      *
1328      * _Available since v3.1._
1329      */
1330     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1331 
1332     /**
1333      * @dev Emitted when `account` is granted `role`.
1334      *
1335      * `sender` is the account that originated the contract call, an admin role
1336      * bearer except when using {_setupRole}.
1337      */
1338     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1339 
1340     /**
1341      * @dev Emitted when `account` is revoked `role`.
1342      *
1343      * `sender` is the account that originated the contract call:
1344      *   - if using `revokeRole`, it is the admin role bearer
1345      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1346      */
1347     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1348 
1349     /**
1350      * @dev Returns `true` if `account` has been granted `role`.
1351      */
1352     function hasRole(bytes32 role, address account) public view returns (bool) {
1353         return _roles[role].members.contains(account);
1354     }
1355 
1356     /**
1357      * @dev Returns the number of accounts that have `role`. Can be used
1358      * together with {getRoleMember} to enumerate all bearers of a role.
1359      */
1360     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1361         return _roles[role].members.length();
1362     }
1363 
1364     /**
1365      * @dev Returns one of the accounts that have `role`. `index` must be a
1366      * value between 0 and {getRoleMemberCount}, non-inclusive.
1367      *
1368      * Role bearers are not sorted in any particular way, and their ordering may
1369      * change at any point.
1370      *
1371      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1372      * you perform all queries on the same block. See the following
1373      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1374      * for more information.
1375      */
1376     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1377         return _roles[role].members.at(index);
1378     }
1379 
1380     /**
1381      * @dev Returns the admin role that controls `role`. See {grantRole} and
1382      * {revokeRole}.
1383      *
1384      * To change a role's admin, use {_setRoleAdmin}.
1385      */
1386     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1387         return _roles[role].adminRole;
1388     }
1389 
1390     /**
1391      * @dev Grants `role` to `account`.
1392      *
1393      * If `account` had not been already granted `role`, emits a {RoleGranted}
1394      * event.
1395      *
1396      * Requirements:
1397      *
1398      * - the caller must have ``role``'s admin role.
1399      */
1400     function grantRole(bytes32 role, address account) internal virtual {
1401         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1402 
1403         _grantRole(role, account);
1404     }
1405 
1406     /**
1407      * @dev Revokes `role` from `account`.
1408      *
1409      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1410      *
1411      * Requirements:
1412      *
1413      * - the caller must have ``role``'s admin role.
1414      */
1415     function revokeRole(bytes32 role, address account) public virtual {
1416         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1417 
1418         _revokeRole(role, account);
1419     }
1420 
1421     /**
1422      * @dev Revokes `role` from the calling account.
1423      *
1424      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1425      * purpose is to provide a mechanism for accounts to lose their privileges
1426      * if they are compromised (such as when a trusted device is misplaced).
1427      *
1428      * If the calling account had been granted `role`, emits a {RoleRevoked}
1429      * event.
1430      *
1431      * Requirements:
1432      *
1433      * - the caller must be `account`.
1434      */
1435     function renounceRole(bytes32 role, address account) public virtual {
1436         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1437 
1438         _revokeRole(role, account);
1439     }
1440 
1441     /**
1442      * @dev Grants `role` to `account`.
1443      *
1444      * If `account` had not been already granted `role`, emits a {RoleGranted}
1445      * event. Note that unlike {grantRole}, this function doesn't perform any
1446      * checks on the calling account.
1447      *
1448      * [WARNING]
1449      * ====
1450      * This function should only be called from the constructor when setting
1451      * up the initial roles for the system.
1452      *
1453      * Using this function in any other way is effectively circumventing the admin
1454      * system imposed by {AccessControl}.
1455      * ====
1456      */
1457     function _setupRole(bytes32 role, address account) internal virtual {
1458         _grantRole(role, account);
1459     }
1460 
1461     /**
1462      * @dev Sets `adminRole` as ``role``'s admin role.
1463      *
1464      * Emits a {RoleAdminChanged} event.
1465      */
1466     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1467         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1468         _roles[role].adminRole = adminRole;
1469     }
1470 
1471     function _grantRole(bytes32 role, address account) private {
1472         if (_roles[role].members.add(account)) {
1473             emit RoleGranted(role, account, _msgSender());
1474         }
1475     }
1476 
1477     function _revokeRole(bytes32 role, address account) private {
1478         if (_roles[role].members.remove(account)) {
1479             emit RoleRevoked(role, account, _msgSender());
1480         }
1481     }
1482 }
1483 
1484 // File: contracts\common\AccessControlMixin.sol
1485 
1486 pragma solidity 0.6.6;
1487 
1488 
1489 contract AccessControlMixin is AccessControl {
1490     string private _revertMsg;
1491     function _setupContractId(string memory contractId) internal {
1492         _revertMsg = string(abi.encodePacked(contractId, ": INSUFFICIENT_PERMISSIONS"));
1493     }
1494 
1495     modifier only(bytes32 role) {
1496         require(
1497             hasRole(role, _msgSender()),
1498             _revertMsg
1499         );
1500         _;
1501     }
1502 }
1503 
1504 
1505 
1506 
1507 library Strings {
1508   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1509   function strConcat(
1510     string memory _a,
1511     string memory _b,
1512     string memory _c,
1513     string memory _d,
1514     string memory _e
1515   ) internal pure returns (string memory) {
1516     bytes memory _ba = bytes(_a);
1517     bytes memory _bb = bytes(_b);
1518     bytes memory _bc = bytes(_c);
1519     bytes memory _bd = bytes(_d);
1520     bytes memory _be = bytes(_e);
1521     string memory abcde = new string(
1522       _ba.length + _bb.length + _bc.length + _bd.length + _be.length
1523     );
1524     bytes memory babcde = bytes(abcde);
1525     uint256 k = 0;
1526     for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1527     for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1528     for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1529     for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1530     for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1531     return string(babcde);
1532   }
1533 
1534   function strConcat(
1535     string memory _a,
1536     string memory _b,
1537     string memory _c,
1538     string memory _d
1539   ) internal pure returns (string memory) {
1540     return strConcat(_a, _b, _c, _d, '');
1541   }
1542 
1543   function strConcat(
1544     string memory _a,
1545     string memory _b,
1546     string memory _c
1547   ) internal pure returns (string memory) {
1548     return strConcat(_a, _b, _c, '', '');
1549   }
1550 
1551   function strConcat(string memory _a, string memory _b)
1552     internal
1553     pure
1554     returns (string memory)
1555   {
1556     return strConcat(_a, _b, '', '', '');
1557   }
1558 
1559   function uint2str(uint256 _i)
1560     internal
1561     pure
1562     returns (string memory _uintAsString)
1563   {
1564     if (_i == 0) {
1565       return '0';
1566     }
1567     uint256 j = _i;
1568     uint256 len;
1569     while (j != 0) {
1570       len++;
1571       j /= 10;
1572     }
1573     bytes memory bstr = new bytes(len);
1574     uint256 k = len - 1;
1575     while (_i != 0) {
1576       bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1577       _i /= 10;
1578     }
1579     return string(bstr);
1580   }
1581 }
1582 
1583 contract OwnableDelegateProxy {}
1584 
1585 contract ProxyRegistry {
1586   mapping(address => OwnableDelegateProxy) public proxies;
1587 }
1588 
1589 abstract contract ERC1155Tradable is
1590   ERC1155,
1591   AccessControlMixin
1592 {
1593   using Strings for string;
1594   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1595   bytes32 public constant WHITELIST_ADMIN_ROLE = keccak256("WHITELIST_ADMIN_ROLE");
1596 
1597   address proxyRegistryAddress;
1598   uint256 internal _currentTokenID = 0;
1599   mapping(uint256 => address) public creators;
1600   mapping(uint256 => uint256) public tokenSupply;
1601   mapping(uint256 => uint256) public tokenMaxSupply;
1602   // Contract name
1603   string public name;
1604   // Contract symbol
1605   string public symbol;
1606 
1607   constructor(
1608     string memory _name,
1609     string memory _symbol,
1610     address _proxyRegistryAddress
1611   ) public ERC1155('https://api.toshimon.io/cards/') {
1612     name = _name;
1613     symbol = _symbol;
1614     proxyRegistryAddress = _proxyRegistryAddress;
1615   }
1616 
1617   function addWhitelistAdmin(address account) public virtual only(DEFAULT_ADMIN_ROLE) {
1618     grantRole(WHITELIST_ADMIN_ROLE,account);
1619   }
1620 
1621   function addMinter(address account) public virtual only(DEFAULT_ADMIN_ROLE) {
1622     grantRole(MINTER_ROLE,account);
1623   }
1624 
1625   function removeWhitelistAdmin(address account) public virtual only(DEFAULT_ADMIN_ROLE) {
1626     revokeRole(WHITELIST_ADMIN_ROLE,account);
1627   }
1628 
1629   function removeMinter(address account) public virtual only(DEFAULT_ADMIN_ROLE) {
1630     revokeRole(MINTER_ROLE,account);
1631   }
1632 
1633   function uri(uint256 _id) public  view virtual override returns (string memory) {
1634     require(_exists(_id), 'ERC721Tradable#uri: NONEXISTENT_TOKEN');
1635     return Strings.strConcat(uri(_id), Strings.uint2str(_id));
1636   }
1637 
1638   /**
1639    * @dev Returns the total quantity for a token ID
1640    * @param _id uint256 ID of the token to query
1641    * @return amount of token in existence
1642    */
1643   function totalSupply(uint256 _id) public view virtual returns (uint256) {
1644     return tokenSupply[_id];
1645   }
1646 
1647 
1648   /**
1649    * @dev Will update the base URL of token's URI
1650    * @param _newBaseMetadataURI New base URL of token's URI
1651    */
1652   function _setBaseMetadataURI(string memory _newBaseMetadataURI)
1653     public
1654     virtual
1655      only(WHITELIST_ADMIN_ROLE)
1656   {
1657     _setURI(_newBaseMetadataURI);
1658   }
1659 
1660   function setMaxSupply(uint256 _id, uint256 _maxSupply)
1661     public
1662     only(WHITELIST_ADMIN_ROLE)
1663   {
1664     tokenMaxSupply[_id] = _maxSupply;
1665   }
1666 
1667   function create(
1668     uint256 _maxSupply,
1669     uint256 _initialSupply,
1670     string calldata _uri,
1671     bytes calldata _data
1672   ) external virtual only(WHITELIST_ADMIN_ROLE) returns (uint256 tokenId) {
1673     require(
1674       _initialSupply <= _maxSupply,
1675       'Initial supply cannot be more than max supply'
1676     );
1677     uint256 _id = _getNextTokenID();
1678     _incrementTokenTypeId();
1679     creators[_id] = msg.sender;
1680 
1681     if (bytes(_uri).length > 0) {
1682       emit URI(_uri, _id);
1683     }
1684 
1685     if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1686     tokenSupply[_id] = _initialSupply;
1687     tokenMaxSupply[_id] = _maxSupply;
1688     return _id;
1689   }
1690   
1691   function createBatch(
1692     uint256  _timesCreated,   
1693     uint256  _maxSupply
1694   
1695   ) external virtual only(WHITELIST_ADMIN_ROLE){
1696     uint256 _id;
1697     for (uint i = 0; i < _timesCreated; i++) {
1698 
1699         _id = _getNextTokenID();
1700         _incrementTokenTypeId();
1701         creators[_id] = msg.sender;
1702         tokenMaxSupply[_id] = _maxSupply;
1703     }
1704   }
1705 
1706   /**
1707    * @dev Mints some amount of tokens to an address
1708    * @param _to          Address of the future owner of the token
1709    * @param _id          Token ID to mint
1710    * @param _quantity    Amount of tokens to mint
1711    * @param _data        Data to pass if receiver is contract
1712    */
1713   function mint(
1714     address _to,
1715     uint256 _id,
1716     uint256 _quantity,
1717     bytes memory _data
1718   ) public virtual only(MINTER_ROLE) {
1719     uint256 tokenId = _id;
1720     uint256 newSupply = tokenSupply[tokenId].add(_quantity);
1721     require(newSupply <= tokenMaxSupply[tokenId], 'Max supply reached');
1722     _mint(_to, _id, _quantity, _data);
1723     tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1724   }
1725 
1726   /**
1727    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings - The Beano of NFTs
1728    */
1729   function isApprovedForAll(address _owner, address _operator)
1730     public
1731     view
1732     virtual
1733     override
1734     returns (bool isOperator)
1735   {
1736     // Whitelist OpenSea proxy contract for easy trading.
1737     ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1738     if (address(proxyRegistry.proxies(_owner)) == _operator) {
1739       return true;
1740     }
1741 
1742     return ERC1155.isApprovedForAll(_owner, _operator);
1743   }
1744 
1745   /**
1746    * @dev Returns whether the specified token exists by checking to see if it has a creator
1747    * @param _id uint256 ID of the token to query the existence of
1748    * @return bool whether the token exists
1749    */
1750   function _exists(uint256 _id) internal view virtual returns (bool) {
1751     return creators[_id] != address(0);
1752   }
1753 
1754   /**
1755    * @dev calculates the next token ID based on value of _currentTokenID
1756    * @return uint256 for the next token ID
1757    */
1758   function _getNextTokenID() internal virtual view returns (uint256) {
1759     return _currentTokenID.add(1);
1760   }
1761 
1762   /**
1763    * @dev increments the value of _currentTokenID
1764    */
1765   function _incrementTokenTypeId() internal virtual {
1766     _currentTokenID++;
1767   }
1768     /**
1769    * @dev Returns the max quantity for a token ID
1770    * @param _id uint256 ID of the token to query
1771    * @return amount of token in existence
1772    */
1773   function maxSupply(uint256 _id) public view returns (uint256) {
1774     return tokenMaxSupply[_id];
1775   }
1776 }
1777 
1778 // File: contracts\child\ChildToken\ChildERC1155.sol
1779 
1780 pragma solidity 0.6.6;
1781 
1782 
1783 
1784 
1785 
1786 
1787 contract ToshimonMinter is ERC1155Tradable
1788 {
1789     using Strings for string;
1790     string private _contractURI;
1791     
1792 
1793     constructor(address _proxyRegistryAddress)
1794         public
1795         ERC1155Tradable('Toshimon Minter', 'ToshimonMinter', _proxyRegistryAddress)
1796     {
1797 
1798         proxyRegistryAddress = _proxyRegistryAddress;
1799         _setupContractId("ChildERC1155");
1800         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1801         _setupRole(MINTER_ROLE, _msgSender());
1802         _setupRole(WHITELIST_ADMIN_ROLE, _msgSender());
1803         
1804         _contractURI = 'https://api.toshimon.io/toshimon-erc1155';
1805 
1806     }
1807 
1808     // This is to support Native meta transactions
1809     // never use msg.sender directly, use _msgSender() instead
1810 
1811 
1812     function setBaseMetadataURI(string memory newURI) public only(WHITELIST_ADMIN_ROLE) {
1813         _setBaseMetadataURI(newURI);
1814     }
1815 
1816     function mintBatch(address user, uint256[] calldata ids, uint256[] calldata amounts)
1817         external
1818         only(MINTER_ROLE)
1819     {
1820         _mintBatch(user, ids, amounts, '');
1821     }
1822  function setContractURI(string memory newURI) public only(WHITELIST_ADMIN_ROLE) {
1823     _contractURI = newURI;
1824   }
1825 
1826   function contractURI() public view returns (string memory) {
1827     return _contractURI;
1828   }
1829   /**
1830    * @dev Ends minting of token
1831    * @param _id Token ID for which minting will end
1832    */
1833   function endMinting(uint256 _id) external only(WHITELIST_ADMIN_ROLE) {
1834     tokenMaxSupply[_id] = tokenSupply[_id];
1835   }
1836 
1837   function burn(
1838     address _account,
1839     uint256 _id,
1840     uint256 _amount
1841   ) 
1842     external
1843     only(MINTER_ROLE) {
1844     require(
1845       balanceOf(_account, _id) >= _amount,
1846       'Cannot burn more than addres has'
1847     );
1848     _burn(_account, _id, _amount);
1849   }
1850 
1851   /**
1852    * Mint NFT and send those to the list of given addresses
1853    */
1854   function airdrop(uint256 _id, address[] calldata _addresses)  
1855         external
1856         only(MINTER_ROLE)  {
1857     for (uint256 i = 0; i < _addresses.length; i++) {
1858       _mint(_addresses[i], _id, 1, '');
1859     }
1860   }
1861     /**
1862    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1863    * Can only be called by the current owner.
1864    */
1865   function transferOwnership(address newOwner) public only(DEFAULT_ADMIN_ROLE) {
1866     _transferOwnership(newOwner);
1867   }
1868 
1869   /**
1870    * @dev Transfers ownership of the contract to a new account (`newOwner`).
1871    */
1872   function _transferOwnership(address newOwner) internal {
1873     require(newOwner != address(0), 'Ownable: new owner is the zero address');
1874     grantRole(DEFAULT_ADMIN_ROLE,newOwner);
1875     revokeRole(DEFAULT_ADMIN_ROLE,getRoleMember(DEFAULT_ADMIN_ROLE,0));
1876   }
1877   function isMinter(address account) public view returns (bool) {
1878     return hasRole(MINTER_ROLE,account);
1879   }
1880   function isOwner(address account) public view returns (bool) {
1881     return hasRole(DEFAULT_ADMIN_ROLE,account);
1882   }
1883   function isWhitelistAdmin(address account) public view returns (bool) {
1884     return hasRole(WHITELIST_ADMIN_ROLE,account);
1885   }
1886   function owner() public view returns (address) {
1887     return getRoleMember(DEFAULT_ADMIN_ROLE,0);
1888   }
1889  
1890 }