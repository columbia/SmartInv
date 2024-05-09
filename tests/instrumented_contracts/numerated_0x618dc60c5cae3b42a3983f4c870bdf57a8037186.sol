1 // File: contracts/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.6.2;
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
25      /*
26      It is possible to cause an arithmetic underflow. 
27      Prevent the underflow by constraining inputs using the require() statement or use the OpenZeppelin SafeMath library for integer arithmetic operations. 
28      Refer to the transaction trace generated for this issue to reproduce the underflow.
29      https://swcregistry.io/docs/SWC-101
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 // File: contracts/IERC1155.sol
35 
36 // SPDX-License-Identifier: MIT
37 
38 pragma solidity 0.6.2;
39 
40 
41 /**
42  * @dev Required interface of an ERC1155 compliant contract, as defined in the
43  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
44  *
45  * _Available since v3.1._
46  */
47 interface IERC1155 is IERC165 {
48     /**
49      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
50      */
51     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
52 
53     /**
54      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
55      * transfers.
56      */
57     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
58 
59     /**
60      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
61      * `approved`.
62      */
63     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
64 
65     /**
66      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
67      *
68      * If an {URI} event was emitted for `id`, the standard
69      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
70      * returned by {IERC1155MetadataURI-uri}.
71      */
72     event URI(string value, uint256 indexed id);
73 
74     /**
75      * @dev Returns the amount of tokens of token type `id` owned by `account`.
76      *
77      * Requirements:
78      *
79      * - `account` cannot be the zero address.
80      */
81     function balanceOf(address account, uint256 id) external view returns (uint256);
82 
83     /**
84      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
85      *
86      * Requirements:
87      *
88      * - `accounts` and `ids` must have the same length.
89      */
90     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
91 
92     /**
93      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
94      *
95      * Emits an {ApprovalForAll} event.
96      *
97      * Requirements:
98      *
99      * - `operator` cannot be the caller.
100      */
101     function setApprovalForAll(address operator, bool approved) external;
102 
103     /**
104      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
105      *
106      * See {setApprovalForAll}.
107      */
108     function isApprovedForAll(address account, address operator) external view returns (bool);
109 
110     /**
111      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
112      *
113      * Emits a {TransferSingle} event.
114      *
115      * Requirements:
116      *
117      * - `to` cannot be the zero address.
118      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
119      * - `from` must have a balance of tokens of type `id` of at least `amount`.
120      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
121      * acceptance magic value.
122      */
123     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
124 
125     /**
126      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
127      *
128      * Emits a {TransferBatch} event.
129      *
130      * Requirements:
131      *
132      * - `ids` and `amounts` must have the same length.
133      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
134      * acceptance magic value.
135      */
136     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
137 }
138 
139 // File: contracts/IERC1155MetadataURI.sol
140 
141 // SPDX-License-Identifier: MIT
142 
143 pragma solidity 0.6.2;
144 
145 
146 /**
147  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
148  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
149  *
150  * _Available since v3.1._
151  */
152 interface IERC1155MetadataURI is IERC1155 {
153     /**
154      * @dev Returns the URI for token type `id`.
155      *
156      * If the `\{id\}` substring is present in the URI, it must be replaced by
157      * clients with the actual token type ID.
158      */
159     function uri(uint256 id) external view returns (string memory);
160 }
161 
162 // File: contracts/IERC1155Receiver.sol
163 
164 // SPDX-License-Identifier: MIT
165 
166 pragma solidity 0.6.2;
167 
168 
169 /**
170  * _Available since v3.1._
171  */
172 interface IERC1155Receiver is IERC165 {
173 
174     /**
175         @dev Handles the receipt of a single ERC1155 token type. This function is
176         called at the end of a `safeTransferFrom` after the balance has been updated.
177         To accept the transfer, this must return
178         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
179         (i.e. 0xf23a6e61, or its own function selector).
180         @param operator The address which initiated the transfer (i.e. msg.sender)
181         @param from The address which previously owned the token
182         @param id The ID of the token being transferred
183         @param value The amount of tokens being transferred
184         @param data Additional data with no specified format
185         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
186     */
187     function onERC1155Received(
188         address operator,
189         address from,
190         uint256 id,
191         uint256 value,
192         bytes calldata data
193     )
194         external
195         returns(bytes4);
196 
197     /**
198         @dev Handles the receipt of a multiple ERC1155 token types. This function
199         is called at the end of a `safeBatchTransferFrom` after the balances have
200         been updated. To accept the transfer(s), this must return
201         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
202         (i.e. 0xbc197c81, or its own function selector).
203         @param operator The address which initiated the batch transfer (i.e. msg.sender)
204         @param from The address which previously owned the token
205         @param ids An array containing ids of each token being transferred (order and length must match values array)
206         @param values An array containing amounts of each token being transferred (order and length must match ids array)
207         @param data Additional data with no specified format
208         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
209     */
210     function onERC1155BatchReceived(
211         address operator,
212         address from,
213         uint256[] calldata ids,
214         uint256[] calldata values,
215         bytes calldata data
216     )
217         external
218         returns(bytes4);
219 }
220 
221 // File: contracts/Context.sol
222 
223 // SPDX-License-Identifier: MIT
224 
225 pragma solidity 0.6.2;
226 
227 /*
228  * @dev Provides information about the current execution context, including the
229  * sender of the transaction and its data. While these are generally available
230  * via msg.sender and msg.data, they should not be accessed in such a direct
231  * manner, since when dealing with GSN meta-transactions the account sending and
232  * paying for execution may not be the actual sender (as far as an application
233  * is concerned).
234  *
235  * This contract is only required for intermediate, library-like contracts.
236  */
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address payable) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes memory) {
243         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
244         return msg.data;
245     }
246 }
247 
248 // File: contracts/ERC165.sol
249 
250 // SPDX-License-Identifier: MIT
251 
252 pragma solidity 0.6.2;
253 
254 
255 /**
256  * @dev Implementation of the {IERC165} interface.
257  *
258  * Contracts may inherit from this and call {_registerInterface} to declare
259  * their support of an interface.
260  */
261 contract ERC165 is IERC165 {
262     /*
263      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
264      */
265     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
266 
267     /**
268      * @dev Mapping of interface ids to whether or not it's supported.
269      */
270     mapping(bytes4 => bool) private _supportedInterfaces;
271 
272     constructor () internal {
273         // Derived contracts need only register support for their own interfaces,
274         // we register support for ERC165 itself here
275         _registerInterface(_INTERFACE_ID_ERC165);
276     }
277 
278     /**
279      * @dev See {IERC165-supportsInterface}.
280      *
281      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
282      */
283      /*
284      It is possible to cause an arithmetic underflow. 
285      Prevent the underflow by constraining inputs using the require() statement or use the OpenZeppelin SafeMath library for integer arithmetic operations. 
286      Refer to the transaction trace generated for this issue to reproduce the underflow.
287      https://swcregistry.io/docs/SWC-101
288      */
289     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
290         return _supportedInterfaces[interfaceId];
291     }
292 
293     /**
294      * @dev Registers the contract as an implementer of the interface defined by
295      * `interfaceId`. Support of the actual ERC165 interface is automatic and
296      * registering its interface id is not required.
297      *
298      * See {IERC165-supportsInterface}.
299      *
300      * Requirements:
301      *
302      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
303      */
304     function _registerInterface(bytes4 interfaceId) internal virtual {
305         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
306         _supportedInterfaces[interfaceId] = true;
307     }
308 }
309 
310 // File: contracts/SafeMath.sol
311 
312 // SPDX-License-Identifier: MIT
313 
314 pragma solidity 0.6.2;
315 
316 /**
317  * @dev Wrappers over Solidity's arithmetic operations with added overflow
318  * checks.
319  *
320  * Arithmetic operations in Solidity wrap on overflow. This can easily result
321  * in bugs, because programmers usually assume that an overflow raises an
322  * error, which is the standard behavior in high level programming languages.
323  * `SafeMath` restores this intuition by reverting the transaction when an
324  * operation overflows.
325  *
326  * Using this library instead of the unchecked operations eliminates an entire
327  * class of bugs, so it's recommended to use it always.
328  */
329 library SafeMath {
330     /**
331      * @dev Returns the addition of two unsigned integers, reverting on
332      * overflow.
333      *
334      * Counterpart to Solidity's `+` operator.
335      *
336      * Requirements:
337      *
338      * - Addition cannot overflow.
339      */
340     function add(uint256 a, uint256 b) internal pure returns (uint256) {
341         uint256 c = a + b;
342         require(c >= a, "SafeMath: addition overflow");
343 
344         return c;
345     }
346 
347     /**
348      * @dev Returns the subtraction of two unsigned integers, reverting on
349      * overflow (when the result is negative).
350      *
351      * Counterpart to Solidity's `-` operator.
352      *
353      * Requirements:
354      *
355      * - Subtraction cannot overflow.
356      */
357     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
358         return sub(a, b, "SafeMath: subtraction overflow");
359     }
360 
361     /**
362      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
363      * overflow (when the result is negative).
364      *
365      * Counterpart to Solidity's `-` operator.
366      *
367      * Requirements:
368      *
369      * - Subtraction cannot overflow.
370      */
371     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b <= a, errorMessage);
373         uint256 c = a - b;
374 
375         return c;
376     }
377 
378     /**
379      * @dev Returns the multiplication of two unsigned integers, reverting on
380      * overflow.
381      *
382      * Counterpart to Solidity's `*` operator.
383      *
384      * Requirements:
385      *
386      * - Multiplication cannot overflow.
387      */
388     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
389         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
390         // benefit is lost if 'b' is also tested.
391         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
392         if (a == 0) {
393             return 0;
394         }
395 
396         uint256 c = a * b;
397         require(c / a == b, "SafeMath: multiplication overflow");
398 
399         return c;
400     }
401 
402     /**
403      * @dev Returns the integer division of two unsigned integers. Reverts on
404      * division by zero. The result is rounded towards zero.
405      *
406      * Counterpart to Solidity's `/` operator. Note: this function uses a
407      * `revert` opcode (which leaves remaining gas untouched) while Solidity
408      * uses an invalid opcode to revert (consuming all remaining gas).
409      *
410      * Requirements:
411      *
412      * - The divisor cannot be zero.
413      */
414     function div(uint256 a, uint256 b) internal pure returns (uint256) {
415         return div(a, b, "SafeMath: division by zero");
416     }
417 
418     /**
419      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
420      * division by zero. The result is rounded towards zero.
421      *
422      * Counterpart to Solidity's `/` operator. Note: this function uses a
423      * `revert` opcode (which leaves remaining gas untouched) while Solidity
424      * uses an invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      *
428      * - The divisor cannot be zero.
429      */
430     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
431         require(b > 0, errorMessage);
432         uint256 c = a / b;
433         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
434 
435         return c;
436     }
437 
438     /**
439      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
440      * Reverts when dividing by zero.
441      *
442      * Counterpart to Solidity's `%` operator. This function uses a `revert`
443      * opcode (which leaves remaining gas untouched) while Solidity uses an
444      * invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
451         return mod(a, b, "SafeMath: modulo by zero");
452     }
453 
454     /**
455      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
456      * Reverts with custom message when dividing by zero.
457      *
458      * Counterpart to Solidity's `%` operator. This function uses a `revert`
459      * opcode (which leaves remaining gas untouched) while Solidity uses an
460      * invalid opcode to revert (consuming all remaining gas).
461      *
462      * Requirements:
463      *
464      * - The divisor cannot be zero.
465      */
466     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
467         require(b != 0, errorMessage);
468         return a % b;
469     }
470 }
471 
472 // File: contracts/Address.sol
473 
474 // SPDX-License-Identifier: MIT
475 
476 pragma solidity 0.6.2;
477 
478 /**
479  * @dev Collection of functions related to the address type
480  */
481 library Address {
482     /**
483      * @dev Returns true if `account` is a contract.
484      *
485      * [IMPORTANT]
486      * ====
487      * It is unsafe to assume that an address for which this function returns
488      * false is an externally-owned account (EOA) and not a contract.
489      *
490      * Among others, `isContract` will return false for the following
491      * types of addresses:
492      *
493      *  - an externally-owned account
494      *  - a contract in construction
495      *  - an address where a contract will be created
496      *  - an address where a contract lived, but was destroyed
497      * ====
498      */
499     function isContract(address account) internal view returns (bool) {
500         // This method relies in extcodesize, which returns 0 for contracts in
501         // construction, since the code is only stored at the end of the
502         // constructor execution.
503 
504         uint256 size;
505         // solhint-disable-next-line no-inline-assembly
506         assembly { size := extcodesize(account) }
507         return size > 0;
508     }
509 
510     /**
511      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
512      * `recipient`, forwarding all available gas and reverting on errors.
513      *
514      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
515      * of certain opcodes, possibly making contracts go over the 2300 gas limit
516      * imposed by `transfer`, making them unable to receive funds via
517      * `transfer`. {sendValue} removes this limitation.
518      *
519      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
520      *
521      * IMPORTANT: because control is transferred to `recipient`, care must be
522      * taken to not create reentrancy vulnerabilities. Consider using
523      * {ReentrancyGuard} or the
524      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
525      */
526     function sendValue(address payable recipient, uint256 amount) internal {
527         require(address(this).balance >= amount, "Address: insufficient balance");
528 
529         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
530         (bool success, ) = recipient.call{ value: amount }("");
531         require(success, "Address: unable to send value, recipient may have reverted");
532     }
533 
534     /**
535      * @dev Performs a Solidity function call using a low level `call`. A
536      * plain`call` is an unsafe replacement for a function call: use this
537      * function instead.
538      *
539      * If `target` reverts with a revert reason, it is bubbled up by this
540      * function (like regular Solidity function calls).
541      *
542      * Returns the raw returned data. To convert to the expected return value,
543      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
544      *
545      * Requirements:
546      *
547      * - `target` must be a contract.
548      * - calling `target` with `data` must not revert.
549      *
550      * _Available since v3.1._
551      */
552     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
553       return functionCall(target, data, "Address: low-level call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
558      * `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
563         return _functionCallWithValue(target, data, 0, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but also transferring `value` wei to `target`.
569      *
570      * Requirements:
571      *
572      * - the calling contract must have an ETH balance of at least `value`.
573      * - the called Solidity function must be `payable`.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
583      * with `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
588         require(address(this).balance >= value, "Address: insufficient balance for call");
589         return _functionCallWithValue(target, data, value, errorMessage);
590     }
591 
592     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
593         require(isContract(target), "Address: call to non-contract");
594 
595         // solhint-disable-next-line avoid-low-level-calls
596         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
597         if (success) {
598             return returndata;
599         } else {
600             // Look for revert reason and bubble it up if present
601             if (returndata.length > 0) {
602                 // The easiest way to bubble the revert reason is using memory via assembly
603 
604                 // solhint-disable-next-line no-inline-assembly
605                 assembly {
606                     let returndata_size := mload(returndata)
607                     revert(add(32, returndata), returndata_size)
608                 }
609             } else {
610                 revert(errorMessage);
611             }
612         }
613     }
614 }
615 
616 // File: contracts/Strings.sol
617 
618 pragma solidity 0.6.2;
619 
620 library Strings {
621   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
622   function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
623       bytes memory _ba = bytes(_a);
624       bytes memory _bb = bytes(_b);
625       bytes memory _bc = bytes(_c);
626       bytes memory _bd = bytes(_d);
627       bytes memory _be = bytes(_e);
628       string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
629       bytes memory babcde = bytes(abcde);
630       uint k = 0;
631       for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
632       for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
633       for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
634       for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
635       for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
636       return string(babcde);
637     }
638 
639     function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
640         return strConcat(_a, _b, _c, _d, "");
641     }
642 
643     function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
644         return strConcat(_a, _b, _c, "", "");
645     }
646 
647     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
648         return strConcat(_a, _b, "", "", "");
649     }
650 
651     function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
652         if (_i == 0) {
653             return "0";
654         }
655         uint j = _i;
656         uint len;
657         while (j != 0) {
658             len++;
659             j /= 10;
660         }
661         bytes memory bstr = new bytes(len);
662         uint k = len - 1;
663         while (_i != 0) {
664             bstr[k--] = byte(uint8(48 + _i % 10));
665             _i /= 10;
666         }
667         return string(bstr);
668     }
669 }
670 
671 // File: contracts/ERC1155.sol
672 
673 // SPDX-License-Identifier: MIT
674 
675 pragma solidity 0.6.2;
676 
677 
678 
679 
680 
681 
682 
683 
684 
685 /**
686  *
687  * @dev Implementation of the basic standard multi-token.
688  * See https://eips.ethereum.org/EIPS/eip-1155
689  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
690  *
691  * _Available since v3.1._
692  */
693 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
694     using SafeMath for uint256;
695     using Address for address;
696 
697     // Mapping from token ID to account balances
698     mapping (uint256 => mapping(address => uint256)) private _balances;
699 
700     // Mapping from account to operator approvals
701     mapping (address => mapping(address => bool)) private _operatorApprovals;
702 
703     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
704     string private _uri;
705 
706     /*
707      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
708      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
709      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
710      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
711      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
712      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
713      *
714      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
715      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
716      */
717     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
718 
719     /*
720      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
721      */
722     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
723 
724     /**
725      * @dev See {_setURI}.
726      */
727     constructor (string memory uri) public {
728         _setURI(uri);
729 
730         // register the supported interfaces to conform to ERC1155 via ERC165
731         _registerInterface(_INTERFACE_ID_ERC1155);
732 
733         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
734         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
735     }
736 
737     /**
738      * @dev See {IERC1155MetadataURI-uri}.
739      *
740      * This implementation returns the same URI for *all* token types. It relies
741      * on the token type ID substitution mechanism
742      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
743      *
744      * Clients calling this function must replace the `\{id\}` substring with the
745      * actual token type ID.
746      * --- MODIFIED TO CONCAT THE _ID TO THE END OF THE URL
747      */
748     function uri(uint256 _id) external view override returns (string memory) {
749         return Strings.strConcat(_uri, Strings.uint2str(_id));
750     }
751     function tokenURI(uint256 _tokenId) public view returns (string memory) {
752         return Strings.strConcat(_uri, Strings.uint2str(_tokenId));
753     }
754     string private constant _contractURI = "https://www.nobrainer.finance/api/nft.json";
755     function contractURI() public pure returns (string memory) {
756         return _contractURI;
757     }
758 
759 
760     /**
761      * @dev See {IERC1155-balanceOf}.
762      *
763      * Requirements:
764      *
765      * - `account` cannot be the zero address.
766      */
767     function balanceOf(address account, uint256 id) public view override returns (uint256) {
768         require(account != address(0), "ERC1155: balance query for the zero address");
769         return _balances[id][account];
770     }
771 
772     /**
773      * @dev See {IERC1155-balanceOfBatch}.
774      *
775      * Requirements:
776      *
777      * - `accounts` and `ids` must have the same length.
778      */
779     function balanceOfBatch(
780         address[] memory accounts,
781         uint256[] memory ids
782     )
783         public
784         view
785         override
786         returns (uint256[] memory)
787     {
788         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
789 
790         uint256[] memory batchBalances = new uint256[](accounts.length);
791 
792         for (uint256 i = 0; i < accounts.length; ++i) {
793             require(accounts[i] != address(0), "ERC1155: batch balance query for the zero address");
794             batchBalances[i] = _balances[ids[i]][accounts[i]];
795         }
796 
797         return batchBalances;
798     }
799 
800     /**
801      * @dev See {IERC1155-setApprovalForAll}.
802      */
803     function setApprovalForAll(address operator, bool approved) public virtual override {
804         require(_msgSender() != operator, "ERC1155: setting approval status for self");
805 
806         _operatorApprovals[_msgSender()][operator] = approved;
807         emit ApprovalForAll(_msgSender(), operator, approved);
808     }
809 
810     /**
811      * @dev See {IERC1155-isApprovedForAll}.
812      */
813     function isApprovedForAll(address account, address operator) public view override returns (bool) {
814         address _account = account;
815         return _operatorApprovals[_account][operator];
816     }
817 
818     /**
819      * @dev See {IERC1155-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 id,
825         uint256 amount,
826         bytes memory data
827     )
828         public
829         virtual
830         override
831     {
832         require(to != address(0), "ERC1155: transfer to the zero address");
833         require(
834             from == _msgSender() || isApprovedForAll(from, _msgSender()),
835             "ERC1155: caller is not owner nor approved"
836         );
837 
838         address operator = _msgSender();
839 
840         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
841 
842         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
843         _balances[id][to] = _balances[id][to].add(amount);
844 
845         emit TransferSingle(operator, from, to, id, amount);
846 
847         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
848     }
849 
850     /**
851      * @dev See {IERC1155-safeBatchTransferFrom}.
852      */
853     function safeBatchTransferFrom(
854         address from,
855         address to,
856         uint256[] memory ids,
857         uint256[] memory amounts,
858         bytes memory data
859     )
860         public
861         virtual
862         override
863     {
864         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
865         require(to != address(0), "ERC1155: transfer to the zero address");
866         require(
867             from == _msgSender() || isApprovedForAll(from, _msgSender()),
868             "ERC1155: transfer caller is not owner nor approved"
869         );
870 
871         address operator = _msgSender();
872 
873         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
874 
875         for (uint256 i = 0; i < ids.length; ++i) {
876             uint256 id = ids[i];
877             uint256 amount = amounts[i];
878 
879             _balances[id][from] = _balances[id][from].sub(
880                 amount,
881                 "ERC1155: insufficient balance for transfer"
882             );
883             _balances[id][to] = _balances[id][to].add(amount);
884         }
885 
886         emit TransferBatch(operator, from, to, ids, amounts);
887 
888         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
889     }
890 
891     /**
892      * @dev Sets a new URI for all token types, by relying on the token type ID
893      * substitution mechanism
894      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
895      *
896      * By this mechanism, any occurrence of the `\{id\}` substring in either the
897      * URI or any of the amounts in the JSON file at said URI will be replaced by
898      * clients with the token type ID.
899      *
900      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
901      * interpreted by clients as
902      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
903      * for token type ID 0x4cce0.
904      *
905      * See {uri}.
906      *
907      * Because these URIs cannot be meaningfully represented by the {URI} event,
908      * this function emits no events.
909      */
910     function _setURI(string memory newuri) internal virtual {
911         _uri = newuri;
912     }
913 
914     /**
915      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
916      *
917      * Emits a {TransferSingle} event.
918      *
919      * Requirements:
920      *
921      * - `account` cannot be the zero address.
922      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
923      * acceptance magic value.
924      */
925     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
926         require(account != address(0), "ERC1155: mint to the zero address");
927 
928         address operator = _msgSender();
929 
930         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
931 
932         _balances[id][account] = _balances[id][account].add(amount);
933         emit TransferSingle(operator, address(0), account, id, amount);
934 
935         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
936     }
937 
938     /**
939      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
940      *
941      * Requirements:
942      *
943      * - `ids` and `amounts` must have the same length.
944      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
945      * acceptance magic value.
946      */
947     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
948         require(to != address(0), "ERC1155: mint to the zero address");
949         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
950 
951         address operator = _msgSender();
952 
953         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
954 
955         for (uint i = 0; i < ids.length; i++) {
956             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
957         }
958 
959         emit TransferBatch(operator, address(0), to, ids, amounts);
960 
961         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
962     }
963 
964     /**
965      * @dev Destroys `amount` tokens of token type `id` from `account`
966      *
967      * Requirements:
968      *
969      * - `account` cannot be the zero address.
970      * - `account` must have at least `amount` tokens of token type `id`.
971      */
972     function _burn(address account, uint256 id, uint256 amount) internal virtual {
973         require(account != address(0), "ERC1155: burn from the zero address");
974 
975         address operator = _msgSender();
976 
977         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
978 
979         _balances[id][account] = _balances[id][account].sub(
980             amount,
981             "ERC1155: burn amount exceeds balance"
982         );
983 
984         emit TransferSingle(operator, account, address(0), id, amount);
985     }
986 
987     /**
988      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
989      *
990      * Requirements:
991      *
992      * - `ids` and `amounts` must have the same length.
993      */
994     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
995         require(account != address(0), "ERC1155: burn from the zero address");
996         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
997 
998         address operator = _msgSender();
999 
1000         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1001 
1002         for (uint i = 0; i < ids.length; i++) {
1003             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
1004                 amounts[i],
1005                 "ERC1155: burn amount exceeds balance"
1006             );
1007         }
1008 
1009         emit TransferBatch(operator, account, address(0), ids, amounts);
1010     }
1011 
1012     /**
1013      * @dev Hook that is called before any token transfer. This includes minting
1014      * and burning, as well as batched variants.
1015      *
1016      * The same hook is called on both single and batched variants. For single
1017      * transfers, the length of the `id` and `amount` arrays will be 1.
1018      *
1019      * Calling conditions (for each `id` and `amount` pair):
1020      *
1021      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1022      * of token type `id` will be  transferred to `to`.
1023      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1024      * for `to`.
1025      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1026      * will be burned.
1027      * - `from` and `to` are never both zero.
1028      * - `ids` and `amounts` have the same, non-zero length.
1029      *
1030      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1031      */
1032     function _beforeTokenTransfer(
1033         address operator,
1034         address from,
1035         address to,
1036         uint256[] memory ids,
1037         uint256[] memory amounts,
1038         bytes memory data
1039     )
1040         internal virtual
1041     { }
1042 
1043     function _doSafeTransferAcceptanceCheck(
1044         address operator,
1045         address from,
1046         address to,
1047         uint256 id,
1048         uint256 amount,
1049         bytes memory data
1050     )
1051         private
1052     {
1053         if (to.isContract()) {
1054             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1055                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1056                     revert("ERC1155: ERC1155Receiver rejected tokens");
1057                 }
1058             } catch Error(string memory reason) {
1059                 revert(reason);
1060             } catch {
1061                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1062             }
1063         }
1064     }
1065 
1066     function _doSafeBatchTransferAcceptanceCheck(
1067         address operator,
1068         address from,
1069         address to,
1070         uint256[] memory ids,
1071         uint256[] memory amounts,
1072         bytes memory data
1073     )
1074         private
1075     {
1076         if (to.isContract()) {
1077             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1078                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1079                     revert("ERC1155: ERC1155Receiver rejected tokens");
1080                 }
1081             } catch Error(string memory reason) {
1082                 revert(reason);
1083             } catch {
1084                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1085             }
1086         }
1087     }
1088 
1089     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1090         uint256[] memory array = new uint256[](1);
1091         array[0] = element;
1092 
1093         return array;
1094     }
1095 }
1096 
1097 // File: contracts/EnumerableSet.sol
1098 
1099 // SPDX-License-Identifier: MIT
1100 
1101 pragma solidity 0.6.2;
1102 
1103 /**
1104  * @dev Library for managing
1105  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1106  * types.
1107  *
1108  * Sets have the following properties:
1109  *
1110  * - Elements are added, removed, and checked for existence in constant time
1111  * (O(1)).
1112  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1113  *
1114  * ```
1115  * contract Example {
1116  *     // Add the library methods
1117  *     using EnumerableSet for EnumerableSet.AddressSet;
1118  *
1119  *     // Declare a set state variable
1120  *     EnumerableSet.AddressSet private mySet;
1121  * }
1122  * ```
1123  *
1124  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1125  * (`UintSet`) are supported.
1126  */
1127 library EnumerableSet {
1128     // To implement this library for multiple types with as little code
1129     // repetition as possible, we write it in terms of a generic Set type with
1130     // bytes32 values.
1131     // The Set implementation uses private functions, and user-facing
1132     // implementations (such as AddressSet) are just wrappers around the
1133     // underlying Set.
1134     // This means that we can only create new EnumerableSets for types that fit
1135     // in bytes32.
1136 
1137     struct Set {
1138         // Storage of set values
1139         bytes32[] _values;
1140 
1141         // Position of the value in the `values` array, plus 1 because index 0
1142         // means a value is not in the set.
1143         mapping (bytes32 => uint256) _indexes;
1144     }
1145 
1146     /**
1147      * @dev Add a value to a set. O(1).
1148      *
1149      * Returns true if the value was added to the set, that is if it was not
1150      * already present.
1151      */
1152     function _add(Set storage set, bytes32 value) private returns (bool) {
1153         if (!_contains(set, value)) {
1154             set._values.push(value);
1155             // The value is stored at length-1, but we add 1 to all indexes
1156             // and use 0 as a sentinel value
1157             set._indexes[value] = set._values.length;
1158             return true;
1159         } else {
1160             return false;
1161         }
1162     }
1163 
1164     /**
1165      * @dev Removes a value from a set. O(1).
1166      *
1167      * Returns true if the value was removed from the set, that is if it was
1168      * present.
1169      */
1170     function _remove(Set storage set, bytes32 value) private returns (bool) {
1171         // We read and store the value's index to prevent multiple reads from the same storage slot
1172         uint256 valueIndex = set._indexes[value];
1173 
1174         if (valueIndex != 0) { // Equivalent to contains(set, value)
1175             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1176             // the array, and then remove the last element (sometimes called as 'swap and pop').
1177             // This modifies the order of the array, as noted in {at}.
1178 
1179             uint256 toDeleteIndex = valueIndex - 1;
1180             uint256 lastIndex = set._values.length - 1;
1181 
1182             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1183             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1184 
1185             bytes32 lastvalue = set._values[lastIndex];
1186 
1187             // Move the last value to the index where the value to delete is
1188             set._values[toDeleteIndex] = lastvalue;
1189             // Update the index for the moved value
1190             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1191 
1192             // Delete the slot where the moved value was stored
1193             set._values.pop();
1194 
1195             // Delete the index for the deleted slot
1196             delete set._indexes[value];
1197 
1198             return true;
1199         } else {
1200             return false;
1201         }
1202     }
1203 
1204     /**
1205      * @dev Returns true if the value is in the set. O(1).
1206      */
1207     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1208         return set._indexes[value] != 0;
1209     }
1210 
1211     /**
1212      * @dev Returns the number of values on the set. O(1).
1213      */
1214     function _length(Set storage set) private view returns (uint256) {
1215         return set._values.length;
1216     }
1217 
1218    /**
1219     * @dev Returns the value stored at position `index` in the set. O(1).
1220     *
1221     * Note that there are no guarantees on the ordering of values inside the
1222     * array, and it may change when more values are added or removed.
1223     *
1224     * Requirements:
1225     *
1226     * - `index` must be strictly less than {length}.
1227     */
1228     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1229         require(set._values.length > index, "EnumerableSet: index out of bounds");
1230         return set._values[index];
1231     }
1232 
1233     // AddressSet
1234 
1235     struct AddressSet {
1236         Set _inner;
1237     }
1238 
1239     /**
1240      * @dev Add a value to a set. O(1).
1241      *
1242      * Returns true if the value was added to the set, that is if it was not
1243      * already present.
1244      */
1245     function add(AddressSet storage set, address value) internal returns (bool) {
1246         return _add(set._inner, bytes32(uint256(value)));
1247     }
1248 
1249     /**
1250      * @dev Removes a value from a set. O(1).
1251      *
1252      * Returns true if the value was removed from the set, that is if it was
1253      * present.
1254      */
1255     function remove(AddressSet storage set, address value) internal returns (bool) {
1256         return _remove(set._inner, bytes32(uint256(value)));
1257     }
1258 
1259     /**
1260      * @dev Returns true if the value is in the set. O(1).
1261      */
1262     function contains(AddressSet storage set, address value) internal view returns (bool) {
1263         return _contains(set._inner, bytes32(uint256(value)));
1264     }
1265 
1266     /**
1267      * @dev Returns the number of values in the set. O(1).
1268      */
1269     function length(AddressSet storage set) internal view returns (uint256) {
1270         return _length(set._inner);
1271     }
1272 
1273    /**
1274     * @dev Returns the value stored at position `index` in the set. O(1).
1275     *
1276     * Note that there are no guarantees on the ordering of values inside the
1277     * array, and it may change when more values are added or removed.
1278     *
1279     * Requirements:
1280     *
1281     * - `index` must be strictly less than {length}.
1282     */
1283     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1284         return address(uint256(_at(set._inner, index)));
1285     }
1286 
1287 
1288     // UintSet
1289 
1290     struct UintSet {
1291         Set _inner;
1292     }
1293 
1294     /**
1295      * @dev Add a value to a set. O(1).
1296      *
1297      * Returns true if the value was added to the set, that is if it was not
1298      * already present.
1299      */
1300     function add(UintSet storage set, uint256 value) internal returns (bool) {
1301         return _add(set._inner, bytes32(value));
1302     }
1303 
1304     /**
1305      * @dev Removes a value from a set. O(1).
1306      *
1307      * Returns true if the value was removed from the set, that is if it was
1308      * present.
1309      */
1310     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1311         return _remove(set._inner, bytes32(value));
1312     }
1313 
1314     /**
1315      * @dev Returns true if the value is in the set. O(1).
1316      */
1317     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1318         return _contains(set._inner, bytes32(value));
1319     }
1320 
1321     /**
1322      * @dev Returns the number of values on the set. O(1).
1323      */
1324     function length(UintSet storage set) internal view returns (uint256) {
1325         return _length(set._inner);
1326     }
1327 
1328    /**
1329     * @dev Returns the value stored at position `index` in the set. O(1).
1330     *
1331     * Note that there are no guarantees on the ordering of values inside the
1332     * array, and it may change when more values are added or removed.
1333     *
1334     * Requirements:
1335     *
1336     * - `index` must be strictly less than {length}.
1337     */
1338     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1339         return uint256(_at(set._inner, index));
1340     }
1341 }
1342 
1343 // File: contracts/AccessControl.sol
1344 
1345 // SPDX-License-Identifier: MIT
1346 
1347 pragma solidity 0.6.2;
1348 
1349 
1350 
1351 
1352 /**
1353  * @dev Contract module that allows children to implement role-based access
1354  * control mechanisms.
1355  *
1356  * Roles are referred to by their `bytes32` identifier. These should be exposed
1357  * in the external API and be unique. The best way to achieve this is by
1358  * using `public constant` hash digests:
1359  *
1360  * ```
1361  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1362  * ```
1363  *
1364  * Roles can be used to represent a set of permissions. To restrict access to a
1365  * function call, use {hasRole}:
1366  *
1367  * ```
1368  * function foo() public {
1369  *     require(hasRole(MY_ROLE, msg.sender));
1370  *     ...
1371  * }
1372  * ```
1373  *
1374  * Roles can be granted and revoked dynamically via the {grantRole} and
1375  * {revokeRole} functions. Each role has an associated admin role, and only
1376  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1377  *
1378  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1379  * that only accounts with this role will be able to grant or revoke other
1380  * roles. More complex role relationships can be created by using
1381  * {_setRoleAdmin}.
1382  *
1383  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1384  * grant and revoke this role. Extra precautions should be taken to secure
1385  * accounts that have been granted it.
1386  */
1387 abstract contract AccessControl is Context {
1388     using EnumerableSet for EnumerableSet.AddressSet;
1389     using Address for address;
1390 
1391     struct RoleData {
1392         EnumerableSet.AddressSet members;
1393         bytes32 adminRole;
1394     }
1395 
1396     mapping (bytes32 => RoleData) private _roles;
1397 
1398     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1399 
1400     /**
1401      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1402      *
1403      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1404      * {RoleAdminChanged} not being emitted signaling this.
1405      *
1406      * _Available since v3.1._
1407      */
1408     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1409 
1410     /**
1411      * @dev Emitted when `account` is granted `role`.
1412      *
1413      * `sender` is the account that originated the contract call, an admin role
1414      * bearer except when using {_setupRole}.
1415      */
1416     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1417 
1418     /**
1419      * @dev Emitted when `account` is revoked `role`.
1420      *
1421      * `sender` is the account that originated the contract call:
1422      *   - if using `revokeRole`, it is the admin role bearer
1423      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1424      */
1425     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1426 
1427     /**
1428      * @dev Returns `true` if `account` has been granted `role`.
1429      */
1430     function hasRole(bytes32 role, address account) public view returns (bool) {
1431         return _roles[role].members.contains(account);
1432     }
1433 
1434     /**
1435      * @dev Returns the number of accounts that have `role`. Can be used
1436      * together with {getRoleMember} to enumerate all bearers of a role.
1437      */
1438     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1439         return _roles[role].members.length();
1440     }
1441 
1442     /**
1443      * @dev Returns one of the accounts that have `role`. `index` must be a
1444      * value between 0 and {getRoleMemberCount}, non-inclusive.
1445      *
1446      * Role bearers are not sorted in any particular way, and their ordering may
1447      * change at any point.
1448      *
1449      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1450      * you perform all queries on the same block. See the following
1451      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1452      * for more information.
1453      */
1454     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1455         return _roles[role].members.at(index);
1456     }
1457 
1458     /**
1459      * @dev Returns the admin role that controls `role`. See {grantRole} and
1460      * {revokeRole}.
1461      *
1462      * To change a role's admin, use {_setRoleAdmin}.
1463      */
1464     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1465         return _roles[role].adminRole;
1466     }
1467 
1468     /**
1469      * @dev Grants `role` to `account`.
1470      *
1471      * If `account` had not been already granted `role`, emits a {RoleGranted}
1472      * event.
1473      *
1474      * Requirements:
1475      *
1476      * - the caller must have ``role``'s admin role.
1477      */
1478     function grantRole(bytes32 role, address account) public virtual {
1479         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1480 
1481         _grantRole(role, account);
1482     }
1483 
1484     /**
1485      * @dev Revokes `role` from `account`.
1486      *
1487      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1488      *
1489      * Requirements:
1490      *
1491      * - the caller must have ``role``'s admin role.
1492      */
1493     function revokeRole(bytes32 role, address account) public virtual {
1494         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1495 
1496         _revokeRole(role, account);
1497     }
1498 
1499     /**
1500      * @dev Revokes `role` from the calling account.
1501      *
1502      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1503      * purpose is to provide a mechanism for accounts to lose their privileges
1504      * if they are compromised (such as when a trusted device is misplaced).
1505      *
1506      * If the calling account had been granted `role`, emits a {RoleRevoked}
1507      * event.
1508      *
1509      * Requirements:
1510      *
1511      * - the caller must be `account`.
1512      */
1513     function renounceRole(bytes32 role, address account) public virtual {
1514         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1515 
1516         _revokeRole(role, account);
1517     }
1518 
1519     /**
1520      * @dev Grants `role` to `account`.
1521      *
1522      * If `account` had not been already granted `role`, emits a {RoleGranted}
1523      * event. Note that unlike {grantRole}, this function doesn't perform any
1524      * checks on the calling account.
1525      *
1526      * [WARNING]
1527      * ====
1528      * This function should only be called from the constructor when setting
1529      * up the initial roles for the system.
1530      *
1531      * Using this function in any other way is effectively circumventing the admin
1532      * system imposed by {AccessControl}.
1533      * ====
1534      */
1535     function _setupRole(bytes32 role, address account) internal virtual {
1536         _grantRole(role, account);
1537     }
1538 
1539     /**
1540      * @dev Sets `adminRole` as ``role``'s admin role.
1541      *
1542      * Emits a {RoleAdminChanged} event.
1543      */
1544     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1545         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1546         _roles[role].adminRole = adminRole;
1547     }
1548 
1549     function _grantRole(bytes32 role, address account) private {
1550         if (_roles[role].members.add(account)) {
1551             emit RoleGranted(role, account, _msgSender());
1552         }
1553     }
1554 
1555     function _revokeRole(bytes32 role, address account) private {
1556         if (_roles[role].members.remove(account)) {
1557             emit RoleRevoked(role, account, _msgSender());
1558         }
1559     }
1560 }
1561 
1562 // File: contracts/BrainNFT.sol
1563 
1564 // Brain ERC1155 NFT
1565 // https://nobrainer.finance/
1566 // SPDX-License-Identifier: MIT
1567 pragma solidity 0.6.2;
1568 
1569 
1570 
1571 contract BrainNFT is ERC1155, AccessControl {
1572   bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1573 
1574 
1575   constructor() public ERC1155("https://www.nobrainer.finance/api/NFT/") {
1576     _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1577   }
1578 
1579   uint256 public cards;
1580   mapping(uint256 => uint256) public totalSupply;
1581   mapping(uint256 => uint256) public circulatingSupply;
1582 
1583   event CardAdded(uint256 id, uint256 maxSupply);
1584 
1585   function addCard(uint256 maxSupply) public returns (uint256) {
1586     require(hasRole(MINTER_ROLE, _msgSender()), "Caller is not a minter");
1587     require(maxSupply > 0, "Maximum supply can not be 0");
1588     cards = cards.add(1);
1589     totalSupply[cards] = maxSupply;
1590     emit CardAdded(cards, maxSupply);
1591     return cards;
1592   }
1593 
1594   function mint(address to, uint256 id, uint256 amount) public {
1595     require(hasRole(MINTER_ROLE, _msgSender()), "Caller is not a minter");
1596     require(circulatingSupply[id].add(amount) <= totalSupply[id], "Total supply reached.");
1597     circulatingSupply[id] = circulatingSupply[id].add(amount);
1598     _mint(to, id, amount, "");
1599   }
1600     
1601   function burn(uint256 id, uint256 amount) public {
1602     _burn(_msgSender(), id, amount);
1603   }
1604 
1605 }