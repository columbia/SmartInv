1 // SPDX-License-Identifier: Apache License, Version 2.0
2 
3 pragma solidity 0.7.6;
4 
5 
6 
7 // Part: Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies on extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: value }(data);
124         return _verifyCallResult(success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
129      * but performing a static call.
130      *
131      * _Available since v3.3._
132      */
133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
134         return functionStaticCall(target, data, "Address: low-level static call failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
139      * but performing a static call.
140      *
141      * _Available since v3.3._
142      */
143     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
144         require(isContract(target), "Address: static call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return _verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
168         require(isContract(target), "Address: delegate call to non-contract");
169 
170         // solhint-disable-next-line avoid-low-level-calls
171         (bool success, bytes memory returndata) = target.delegatecall(data);
172         return _verifyCallResult(success, returndata, errorMessage);
173     }
174 
175     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
176         if (success) {
177             return returndata;
178         } else {
179             // Look for revert reason and bubble it up if present
180             if (returndata.length > 0) {
181                 // The easiest way to bubble the revert reason is using memory via assembly
182 
183                 // solhint-disable-next-line no-inline-assembly
184                 assembly {
185                     let returndata_size := mload(returndata)
186                     revert(add(32, returndata), returndata_size)
187                 }
188             } else {
189                 revert(errorMessage);
190             }
191         }
192     }
193 }
194 
195 // Part: Context
196 
197 /*
198  * @dev Provides information about the current execution context, including the
199  * sender of the transaction and its data. While these are generally available
200  * via msg.sender and msg.data, they should not be accessed in such a direct
201  * manner, since when dealing with GSN meta-transactions the account sending and
202  * paying for execution may not be the actual sender (as far as an application
203  * is concerned).
204  *
205  * This contract is only required for intermediate, library-like contracts.
206  */
207 abstract contract Context {
208     function _msgSender() internal view virtual returns (address payable) {
209         return msg.sender;
210     }
211 
212     function _msgData() internal view virtual returns (bytes memory) {
213         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
214         return msg.data;
215     }
216 }
217 
218 // Part: IERC165
219 
220 /**
221  * @dev Interface of the ERC165 standard, as defined in the
222  * https://eips.ethereum.org/EIPS/eip-165[EIP].
223  *
224  * Implementers can declare support of contract interfaces, which can then be
225  * queried by others ({ERC165Checker}).
226  *
227  * For an implementation, see {ERC165}.
228  */
229 interface IERC165 {
230     /**
231      * @dev Returns true if this contract implements the interface defined by
232      * `interfaceId`. See the corresponding
233      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
234      * to learn more about how these ids are created.
235      *
236      * This function call must use less than 30 000 gas.
237      */
238     function supportsInterface(bytes4 interfaceId) external view returns (bool);
239 }
240 
241 // Part: SafeMath
242 
243 /**
244  * @dev Wrappers over Solidity's arithmetic operations with added overflow
245  * checks.
246  *
247  * Arithmetic operations in Solidity wrap on overflow. This can easily result
248  * in bugs, because programmers usually assume that an overflow raises an
249  * error, which is the standard behavior in high level programming languages.
250  * `SafeMath` restores this intuition by reverting the transaction when an
251  * operation overflows.
252  *
253  * Using this library instead of the unchecked operations eliminates an entire
254  * class of bugs, so it's recommended to use it always.
255  */
256 library SafeMath {
257     /**
258      * @dev Returns the addition of two unsigned integers, with an overflow flag.
259      *
260      * _Available since v3.4._
261      */
262     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
263         uint256 c = a + b;
264         if (c < a) return (false, 0);
265         return (true, c);
266     }
267 
268     /**
269      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
270      *
271      * _Available since v3.4._
272      */
273     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
274         if (b > a) return (false, 0);
275         return (true, a - b);
276     }
277 
278     /**
279      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
280      *
281      * _Available since v3.4._
282      */
283     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
285         // benefit is lost if 'b' is also tested.
286         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
287         if (a == 0) return (true, 0);
288         uint256 c = a * b;
289         if (c / a != b) return (false, 0);
290         return (true, c);
291     }
292 
293     /**
294      * @dev Returns the division of two unsigned integers, with a division by zero flag.
295      *
296      * _Available since v3.4._
297      */
298     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
299         if (b == 0) return (false, 0);
300         return (true, a / b);
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
305      *
306      * _Available since v3.4._
307      */
308     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
309         if (b == 0) return (false, 0);
310         return (true, a % b);
311     }
312 
313     /**
314      * @dev Returns the addition of two unsigned integers, reverting on
315      * overflow.
316      *
317      * Counterpart to Solidity's `+` operator.
318      *
319      * Requirements:
320      *
321      * - Addition cannot overflow.
322      */
323     function add(uint256 a, uint256 b) internal pure returns (uint256) {
324         uint256 c = a + b;
325         require(c >= a, "SafeMath: addition overflow");
326         return c;
327     }
328 
329     /**
330      * @dev Returns the subtraction of two unsigned integers, reverting on
331      * overflow (when the result is negative).
332      *
333      * Counterpart to Solidity's `-` operator.
334      *
335      * Requirements:
336      *
337      * - Subtraction cannot overflow.
338      */
339     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
340         require(b <= a, "SafeMath: subtraction overflow");
341         return a - b;
342     }
343 
344     /**
345      * @dev Returns the multiplication of two unsigned integers, reverting on
346      * overflow.
347      *
348      * Counterpart to Solidity's `*` operator.
349      *
350      * Requirements:
351      *
352      * - Multiplication cannot overflow.
353      */
354     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
355         if (a == 0) return 0;
356         uint256 c = a * b;
357         require(c / a == b, "SafeMath: multiplication overflow");
358         return c;
359     }
360 
361     /**
362      * @dev Returns the integer division of two unsigned integers, reverting on
363      * division by zero. The result is rounded towards zero.
364      *
365      * Counterpart to Solidity's `/` operator. Note: this function uses a
366      * `revert` opcode (which leaves remaining gas untouched) while Solidity
367      * uses an invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function div(uint256 a, uint256 b) internal pure returns (uint256) {
374         require(b > 0, "SafeMath: division by zero");
375         return a / b;
376     }
377 
378     /**
379      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
380      * reverting when dividing by zero.
381      *
382      * Counterpart to Solidity's `%` operator. This function uses a `revert`
383      * opcode (which leaves remaining gas untouched) while Solidity uses an
384      * invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
391         require(b > 0, "SafeMath: modulo by zero");
392         return a % b;
393     }
394 
395     /**
396      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
397      * overflow (when the result is negative).
398      *
399      * CAUTION: This function is deprecated because it requires allocating memory for the error
400      * message unnecessarily. For custom revert reasons use {trySub}.
401      *
402      * Counterpart to Solidity's `-` operator.
403      *
404      * Requirements:
405      *
406      * - Subtraction cannot overflow.
407      */
408     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
409         require(b <= a, errorMessage);
410         return a - b;
411     }
412 
413     /**
414      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
415      * division by zero. The result is rounded towards zero.
416      *
417      * CAUTION: This function is deprecated because it requires allocating memory for the error
418      * message unnecessarily. For custom revert reasons use {tryDiv}.
419      *
420      * Counterpart to Solidity's `/` operator. Note: this function uses a
421      * `revert` opcode (which leaves remaining gas untouched) while Solidity
422      * uses an invalid opcode to revert (consuming all remaining gas).
423      *
424      * Requirements:
425      *
426      * - The divisor cannot be zero.
427      */
428     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
429         require(b > 0, errorMessage);
430         return a / b;
431     }
432 
433     /**
434      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
435      * reverting with custom message when dividing by zero.
436      *
437      * CAUTION: This function is deprecated because it requires allocating memory for the error
438      * message unnecessarily. For custom revert reasons use {tryMod}.
439      *
440      * Counterpart to Solidity's `%` operator. This function uses a `revert`
441      * opcode (which leaves remaining gas untouched) while Solidity uses an
442      * invalid opcode to revert (consuming all remaining gas).
443      *
444      * Requirements:
445      *
446      * - The divisor cannot be zero.
447      */
448     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
449         require(b > 0, errorMessage);
450         return a % b;
451     }
452 }
453 
454 // Part: ERC165
455 
456 /**
457  * @dev Implementation of the {IERC165} interface.
458  *
459  * Contracts may inherit from this and call {_registerInterface} to declare
460  * their support of an interface.
461  */
462 abstract contract ERC165 is IERC165 {
463     /*
464      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
465      */
466     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
467 
468     /**
469      * @dev Mapping of interface ids to whether or not it's supported.
470      */
471     mapping(bytes4 => bool) private _supportedInterfaces;
472 
473     constructor () internal {
474         // Derived contracts need only register support for their own interfaces,
475         // we register support for ERC165 itself here
476         _registerInterface(_INTERFACE_ID_ERC165);
477     }
478 
479     /**
480      * @dev See {IERC165-supportsInterface}.
481      *
482      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
483      */
484     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485         return _supportedInterfaces[interfaceId];
486     }
487 
488     /**
489      * @dev Registers the contract as an implementer of the interface defined by
490      * `interfaceId`. Support of the actual ERC165 interface is automatic and
491      * registering its interface id is not required.
492      *
493      * See {IERC165-supportsInterface}.
494      *
495      * Requirements:
496      *
497      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
498      */
499     function _registerInterface(bytes4 interfaceId) internal virtual {
500         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
501         _supportedInterfaces[interfaceId] = true;
502     }
503 }
504 
505 // Part: IERC1155
506 
507 /**
508  * @dev Required interface of an ERC1155 compliant contract, as defined in the
509  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
510  *
511  * _Available since v3.1._
512  */
513 interface IERC1155 is IERC165 {
514     /**
515      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
516      */
517     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
518 
519     /**
520      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
521      * transfers.
522      */
523     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
524 
525     /**
526      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
527      * `approved`.
528      */
529     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
530 
531     /**
532      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
533      *
534      * If an {URI} event was emitted for `id`, the standard
535      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
536      * returned by {IERC1155MetadataURI-uri}.
537      */
538     event URI(string value, uint256 indexed id);
539 
540     /**
541      * @dev Returns the amount of tokens of token type `id` owned by `account`.
542      *
543      * Requirements:
544      *
545      * - `account` cannot be the zero address.
546      */
547     function balanceOf(address account, uint256 id) external view returns (uint256);
548 
549     /**
550      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
551      *
552      * Requirements:
553      *
554      * - `accounts` and `ids` must have the same length.
555      */
556     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
557 
558     /**
559      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
560      *
561      * Emits an {ApprovalForAll} event.
562      *
563      * Requirements:
564      *
565      * - `operator` cannot be the caller.
566      */
567     function setApprovalForAll(address operator, bool approved) external;
568 
569     /**
570      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
571      *
572      * See {setApprovalForAll}.
573      */
574     function isApprovedForAll(address account, address operator) external view returns (bool);
575 
576     /**
577      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
578      *
579      * Emits a {TransferSingle} event.
580      *
581      * Requirements:
582      *
583      * - `to` cannot be the zero address.
584      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
585      * - `from` must have a balance of tokens of type `id` of at least `amount`.
586      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
587      * acceptance magic value.
588      */
589     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
590 
591     /**
592      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
593      *
594      * Emits a {TransferBatch} event.
595      *
596      * Requirements:
597      *
598      * - `ids` and `amounts` must have the same length.
599      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
600      * acceptance magic value.
601      */
602     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
603 }
604 
605 // Part: IERC1155Receiver
606 
607 /**
608  * _Available since v3.1._
609  */
610 interface IERC1155Receiver is IERC165 {
611 
612     /**
613         @dev Handles the receipt of a single ERC1155 token type. This function is
614         called at the end of a `safeTransferFrom` after the balance has been updated.
615         To accept the transfer, this must return
616         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
617         (i.e. 0xf23a6e61, or its own function selector).
618         @param operator The address which initiated the transfer (i.e. msg.sender)
619         @param from The address which previously owned the token
620         @param id The ID of the token being transferred
621         @param value The amount of tokens being transferred
622         @param data Additional data with no specified format
623         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
624     */
625     function onERC1155Received(
626         address operator,
627         address from,
628         uint256 id,
629         uint256 value,
630         bytes calldata data
631     )
632         external
633         returns(bytes4);
634 
635     /**
636         @dev Handles the receipt of a multiple ERC1155 token types. This function
637         is called at the end of a `safeBatchTransferFrom` after the balances have
638         been updated. To accept the transfer(s), this must return
639         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
640         (i.e. 0xbc197c81, or its own function selector).
641         @param operator The address which initiated the batch transfer (i.e. msg.sender)
642         @param from The address which previously owned the token
643         @param ids An array containing ids of each token being transferred (order and length must match values array)
644         @param values An array containing amounts of each token being transferred (order and length must match ids array)
645         @param data Additional data with no specified format
646         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
647     */
648     function onERC1155BatchReceived(
649         address operator,
650         address from,
651         uint256[] calldata ids,
652         uint256[] calldata values,
653         bytes calldata data
654     )
655         external
656         returns(bytes4);
657 }
658 
659 // Part: Ownable
660 
661 /**
662  * @dev Contract module which provides a basic access control mechanism, where
663  * there is an account (an owner) that can be granted exclusive access to
664  * specific functions.
665  *
666  * By default, the owner account will be the one that deploys the contract. This
667  * can later be changed with {transferOwnership}.
668  *
669  * This module is used through inheritance. It will make available the modifier
670  * `onlyOwner`, which can be applied to your functions to restrict their use to
671  * the owner.
672  */
673 abstract contract Ownable is Context {
674     address private _owner;
675 
676     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
677 
678     /**
679      * @dev Initializes the contract setting the deployer as the initial owner.
680      */
681     constructor () internal {
682         address msgSender = _msgSender();
683         _owner = msgSender;
684         emit OwnershipTransferred(address(0), msgSender);
685     }
686 
687     /**
688      * @dev Returns the address of the current owner.
689      */
690     function owner() public view virtual returns (address) {
691         return _owner;
692     }
693 
694     /**
695      * @dev Throws if called by any account other than the owner.
696      */
697     modifier onlyOwner() {
698         require(owner() == _msgSender(), "Ownable: caller is not the owner");
699         _;
700     }
701 
702     /**
703      * @dev Leaves the contract without owner. It will not be possible to call
704      * `onlyOwner` functions anymore. Can only be called by the current owner.
705      *
706      * NOTE: Renouncing ownership will leave the contract without an owner,
707      * thereby removing any functionality that is only available to the owner.
708      */
709     function renounceOwnership() public virtual onlyOwner {
710         emit OwnershipTransferred(_owner, address(0));
711         _owner = address(0);
712     }
713 
714     /**
715      * @dev Transfers ownership of the contract to a new account (`newOwner`).
716      * Can only be called by the current owner.
717      */
718     function transferOwnership(address newOwner) public virtual onlyOwner {
719         require(newOwner != address(0), "Ownable: new owner is the zero address");
720         emit OwnershipTransferred(_owner, newOwner);
721         _owner = newOwner;
722     }
723 }
724 
725 // Part: IERC1155MetadataURI
726 
727 /**
728  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
729  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
730  *
731  * _Available since v3.1._
732  */
733 interface IERC1155MetadataURI is IERC1155 {
734     /**
735      * @dev Returns the URI for token type `id`.
736      *
737      * If the `\{id\}` substring is present in the URI, it must be replaced by
738      * clients with the actual token type ID.
739      */
740     function uri(uint256 id) external view returns (string memory);
741 }
742 
743 // Part: IStarNFT
744 
745 /**
746  * @title IStarNFT
747  * @author Galaxy Protocol
748  *
749  * Interface for operating with StarNFTs.
750  */
751 interface IStarNFT is IERC1155 {
752     /* ============ Events =============== */
753 //    event PowahUpdated(uint256 indexed id, uint256 indexed oldPoints, uint256 indexed newPoints);
754 
755     /* ============ Functions ============ */
756 
757     function isOwnerOf(address, uint256) external view returns (bool);
758 //    function starInfo(uint256) external view returns (uint128 powah, uint128 mintBlock, address originator);
759 //    function quasarInfo(uint256) external view returns (uint128 mintBlock, IERC20 stakeToken, uint256 amount, uint256 campaignID);
760 //    function superInfo(uint256) external view returns (uint128 mintBlock, IERC20[] memory stakeToken, uint256[] memory amount, uint256 campaignID);
761 
762     // mint
763     function mint(address account, uint256 powah) external returns (uint256);
764     function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external returns (uint256[] memory);
765     function burn(address account, uint256 id) external;
766     function burnBatch(address account, uint256[] calldata ids) external;
767 
768     // asset-backing mint
769 //    function mintQuasar(address account, uint256 powah, uint256 cid, IERC20 stakeToken, uint256 amount) external returns (uint256);
770 //    function burnQuasar(address account, uint256 id) external;
771 
772     // asset-backing forge
773 //    function mintSuper(address account, uint256 powah, uint256 campaignID, IERC20[] calldata stakeTokens, uint256[] calldata amounts) external returns (uint256);
774 //    function burnSuper(address account, uint256 id) external;
775     // update
776 //    function updatePowah(address owner, uint256 id, uint256 powah) external;
777 }
778 
779 // Part: ERC1155
780 
781 /**
782  *
783  * @dev Implementation of the basic standard multi-token.
784  * See https://eips.ethereum.org/EIPS/eip-1155
785  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
786  *
787  * _Available since v3.1._
788  */
789 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
790     using SafeMath for uint256;
791     using Address for address;
792 
793     // Mapping from token ID to account balances
794     mapping (uint256 => mapping(address => uint256)) private _balances;
795 
796     // Mapping from account to operator approvals
797     mapping (address => mapping(address => bool)) private _operatorApprovals;
798 
799     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
800     string private _uri;
801 
802     /*
803      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
804      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
805      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
806      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
807      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
808      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
809      *
810      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
811      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
812      */
813     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
814 
815     /*
816      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
817      */
818     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
819 
820     /**
821      * @dev See {_setURI}.
822      */
823     constructor (string memory uri_) public {
824         _setURI(uri_);
825 
826         // register the supported interfaces to conform to ERC1155 via ERC165
827         _registerInterface(_INTERFACE_ID_ERC1155);
828 
829         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
830         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
831     }
832 
833     /**
834      * @dev See {IERC1155MetadataURI-uri}.
835      *
836      * This implementation returns the same URI for *all* token types. It relies
837      * on the token type ID substitution mechanism
838      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
839      *
840      * Clients calling this function must replace the `\{id\}` substring with the
841      * actual token type ID.
842      */
843     function uri(uint256) external view virtual override returns (string memory) {
844         return _uri;
845     }
846 
847     /**
848      * @dev See {IERC1155-balanceOf}.
849      *
850      * Requirements:
851      *
852      * - `account` cannot be the zero address.
853      */
854     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
855         require(account != address(0), "ERC1155: balance query for the zero address");
856         return _balances[id][account];
857     }
858 
859     /**
860      * @dev See {IERC1155-balanceOfBatch}.
861      *
862      * Requirements:
863      *
864      * - `accounts` and `ids` must have the same length.
865      */
866     function balanceOfBatch(
867         address[] memory accounts,
868         uint256[] memory ids
869     )
870         public
871         view
872         virtual
873         override
874         returns (uint256[] memory)
875     {
876         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
877 
878         uint256[] memory batchBalances = new uint256[](accounts.length);
879 
880         for (uint256 i = 0; i < accounts.length; ++i) {
881             batchBalances[i] = balanceOf(accounts[i], ids[i]);
882         }
883 
884         return batchBalances;
885     }
886 
887     /**
888      * @dev See {IERC1155-setApprovalForAll}.
889      */
890     function setApprovalForAll(address operator, bool approved) public virtual override {
891         require(_msgSender() != operator, "ERC1155: setting approval status for self");
892 
893         _operatorApprovals[_msgSender()][operator] = approved;
894         emit ApprovalForAll(_msgSender(), operator, approved);
895     }
896 
897     /**
898      * @dev See {IERC1155-isApprovedForAll}.
899      */
900     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
901         return _operatorApprovals[account][operator];
902     }
903 
904     /**
905      * @dev See {IERC1155-safeTransferFrom}.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 id,
911         uint256 amount,
912         bytes memory data
913     )
914         public
915         virtual
916         override
917     {
918         require(to != address(0), "ERC1155: transfer to the zero address");
919         require(
920             from == _msgSender() || isApprovedForAll(from, _msgSender()),
921             "ERC1155: caller is not owner nor approved"
922         );
923 
924         address operator = _msgSender();
925 
926         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
927 
928         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
929         _balances[id][to] = _balances[id][to].add(amount);
930 
931         emit TransferSingle(operator, from, to, id, amount);
932 
933         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
934     }
935 
936     /**
937      * @dev See {IERC1155-safeBatchTransferFrom}.
938      */
939     function safeBatchTransferFrom(
940         address from,
941         address to,
942         uint256[] memory ids,
943         uint256[] memory amounts,
944         bytes memory data
945     )
946         public
947         virtual
948         override
949     {
950         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
951         require(to != address(0), "ERC1155: transfer to the zero address");
952         require(
953             from == _msgSender() || isApprovedForAll(from, _msgSender()),
954             "ERC1155: transfer caller is not owner nor approved"
955         );
956 
957         address operator = _msgSender();
958 
959         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
960 
961         for (uint256 i = 0; i < ids.length; ++i) {
962             uint256 id = ids[i];
963             uint256 amount = amounts[i];
964 
965             _balances[id][from] = _balances[id][from].sub(
966                 amount,
967                 "ERC1155: insufficient balance for transfer"
968             );
969             _balances[id][to] = _balances[id][to].add(amount);
970         }
971 
972         emit TransferBatch(operator, from, to, ids, amounts);
973 
974         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
975     }
976 
977     /**
978      * @dev Sets a new URI for all token types, by relying on the token type ID
979      * substitution mechanism
980      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
981      *
982      * By this mechanism, any occurrence of the `\{id\}` substring in either the
983      * URI or any of the amounts in the JSON file at said URI will be replaced by
984      * clients with the token type ID.
985      *
986      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
987      * interpreted by clients as
988      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
989      * for token type ID 0x4cce0.
990      *
991      * See {uri}.
992      *
993      * Because these URIs cannot be meaningfully represented by the {URI} event,
994      * this function emits no events.
995      */
996     function _setURI(string memory newuri) internal virtual {
997         _uri = newuri;
998     }
999 
1000     /**
1001      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1002      *
1003      * Emits a {TransferSingle} event.
1004      *
1005      * Requirements:
1006      *
1007      * - `account` cannot be the zero address.
1008      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1009      * acceptance magic value.
1010      */
1011     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
1012         require(account != address(0), "ERC1155: mint to the zero address");
1013 
1014         address operator = _msgSender();
1015 
1016         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1017 
1018         _balances[id][account] = _balances[id][account].add(amount);
1019         emit TransferSingle(operator, address(0), account, id, amount);
1020 
1021         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1022     }
1023 
1024     /**
1025      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1026      *
1027      * Requirements:
1028      *
1029      * - `ids` and `amounts` must have the same length.
1030      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1031      * acceptance magic value.
1032      */
1033     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
1034         require(to != address(0), "ERC1155: mint to the zero address");
1035         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1036 
1037         address operator = _msgSender();
1038 
1039         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1040 
1041         for (uint i = 0; i < ids.length; i++) {
1042             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
1043         }
1044 
1045         emit TransferBatch(operator, address(0), to, ids, amounts);
1046 
1047         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1048     }
1049 
1050     /**
1051      * @dev Destroys `amount` tokens of token type `id` from `account`
1052      *
1053      * Requirements:
1054      *
1055      * - `account` cannot be the zero address.
1056      * - `account` must have at least `amount` tokens of token type `id`.
1057      */
1058     function _burn(address account, uint256 id, uint256 amount) internal virtual {
1059         require(account != address(0), "ERC1155: burn from the zero address");
1060 
1061         address operator = _msgSender();
1062 
1063         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1064 
1065         _balances[id][account] = _balances[id][account].sub(
1066             amount,
1067             "ERC1155: burn amount exceeds balance"
1068         );
1069 
1070         emit TransferSingle(operator, account, address(0), id, amount);
1071     }
1072 
1073     /**
1074      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1075      *
1076      * Requirements:
1077      *
1078      * - `ids` and `amounts` must have the same length.
1079      */
1080     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
1081         require(account != address(0), "ERC1155: burn from the zero address");
1082         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1083 
1084         address operator = _msgSender();
1085 
1086         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1087 
1088         for (uint i = 0; i < ids.length; i++) {
1089             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
1090                 amounts[i],
1091                 "ERC1155: burn amount exceeds balance"
1092             );
1093         }
1094 
1095         emit TransferBatch(operator, account, address(0), ids, amounts);
1096     }
1097 
1098     /**
1099      * @dev Hook that is called before any token transfer. This includes minting
1100      * and burning, as well as batched variants.
1101      *
1102      * The same hook is called on both single and batched variants. For single
1103      * transfers, the length of the `id` and `amount` arrays will be 1.
1104      *
1105      * Calling conditions (for each `id` and `amount` pair):
1106      *
1107      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1108      * of token type `id` will be  transferred to `to`.
1109      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1110      * for `to`.
1111      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1112      * will be burned.
1113      * - `from` and `to` are never both zero.
1114      * - `ids` and `amounts` have the same, non-zero length.
1115      *
1116      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1117      */
1118     function _beforeTokenTransfer(
1119         address operator,
1120         address from,
1121         address to,
1122         uint256[] memory ids,
1123         uint256[] memory amounts,
1124         bytes memory data
1125     )
1126         internal
1127         virtual
1128     { }
1129 
1130     function _doSafeTransferAcceptanceCheck(
1131         address operator,
1132         address from,
1133         address to,
1134         uint256 id,
1135         uint256 amount,
1136         bytes memory data
1137     )
1138         private
1139     {
1140         if (to.isContract()) {
1141             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1142                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1143                     revert("ERC1155: ERC1155Receiver rejected tokens");
1144                 }
1145             } catch Error(string memory reason) {
1146                 revert(reason);
1147             } catch {
1148                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1149             }
1150         }
1151     }
1152 
1153     function _doSafeBatchTransferAcceptanceCheck(
1154         address operator,
1155         address from,
1156         address to,
1157         uint256[] memory ids,
1158         uint256[] memory amounts,
1159         bytes memory data
1160     )
1161         private
1162     {
1163         if (to.isContract()) {
1164             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1165                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1166                     revert("ERC1155: ERC1155Receiver rejected tokens");
1167                 }
1168             } catch Error(string memory reason) {
1169                 revert(reason);
1170             } catch {
1171                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1172             }
1173         }
1174     }
1175 
1176     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1177         uint256[] memory array = new uint256[](1);
1178         array[0] = element;
1179 
1180         return array;
1181     }
1182 }
1183 
1184 // File: StarNFTV2.sol
1185 
1186 /**
1187  * based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
1188  */
1189 contract StarNFTV1 is ERC1155, IStarNFT, Ownable {
1190     using SafeMath for uint256;
1191     //    using Address for address;
1192     //    using ERC165Checker for address;
1193 
1194     /* ============ Events ============ */
1195     event EventMinterAdded(address indexed newMinter);
1196     event EventMinterRemoved(address indexed oldMinter);
1197     /* ============ Modifiers ============ */
1198     /**
1199      * Only minter.
1200      */
1201     modifier onlyMinter() {
1202         require(minters[msg.sender], "must be minter");
1203         _;
1204     }
1205     /* ============ Enums ================ */
1206     /* ============ Structs ============ */
1207     /* ============ State Variables ============ */
1208 
1209     // Used as the URI for all token types by ID substitution, e.g. https://galaxy.eco/{address}/{id}.json
1210     string public baseURI;
1211 
1212     // Mint and burn star.
1213     mapping(address => bool) public minters;
1214 
1215     // Total star count, including burnt nft
1216     uint256 public starCount;
1217 
1218 
1219     /* ============ Constructor ============ */
1220     constructor () ERC1155("") {}
1221 
1222     /* ============ External Functions ============ */
1223 
1224     function mint(address account, uint256 powah) external onlyMinter override returns (uint256) {
1225         starCount++;
1226         uint256 sID = starCount;
1227 
1228         _mint(account, sID, 1, "");
1229         return sID;
1230     }
1231 
1232     function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external onlyMinter override returns (uint256[] memory) {
1233         uint256[] memory ids = new uint256[](amount);
1234         uint256[] memory amounts = new uint256[](amount);
1235         for (uint i = 0; i < ids.length; i++) {
1236             starCount++;
1237             ids[i] = starCount;
1238             amounts[i] = 1;
1239         }
1240         _mintBatch(account, ids, amounts, "");
1241         return ids;
1242     }
1243 
1244     function burn(address account, uint256 id) external onlyMinter override {
1245         require(isApprovedForAll(account, _msgSender()), "ERC1155: caller is not approved");
1246 
1247         _burn(account, id, 1);
1248     }
1249 
1250     function burnBatch(address account, uint256[] calldata ids) external onlyMinter override {
1251         require(isApprovedForAll(account, _msgSender()), "ERC1155: caller is not approved");
1252 
1253         uint256[] memory amounts = new uint256[](ids.length);
1254         for (uint i = 0; i < ids.length; i++) {
1255             amounts[i] = 1;
1256         }
1257 
1258         _burnBatch(account, ids, amounts);
1259     }
1260 
1261     /**
1262      * PRIVILEGED MODULE FUNCTION. Sets a new baseURI for all token types.
1263      */
1264     function setURI(string memory newURI) external onlyOwner {
1265         baseURI = newURI;
1266     }
1267 
1268     /**
1269      * PRIVILEGED MODULE FUNCTION. Add a new minter.
1270      */
1271     function addMinter(address minter) external onlyOwner {
1272         require(minter != address(0), "Minter must not be null address");
1273         require(!minters[minter], "Minter already added");
1274         minters[minter] = true;
1275         emit EventMinterAdded(minter);
1276     }
1277 
1278     /**
1279      * PRIVILEGED MODULE FUNCTION. Remove a old minter.
1280      */
1281     function removeMinter(address minter) external onlyOwner {
1282         require(minters[minter], "Minter does not exist");
1283         delete minters[minter];
1284         emit EventMinterRemoved(minter);
1285     }
1286 
1287     /* ============ External Getter Functions ============ */
1288     /**
1289      * See {IERC1155MetadataURI-uri}.
1290      *
1291      * This implementation returns the same URI for *all* token types. It relies
1292      * on the token type ID substitution mechanism
1293      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1294      *
1295      * Clients calling this function must replace the `\{id\}` substring with the
1296      * actual token type ID.
1297      */
1298     function uri(uint256 id) external view override returns (string memory) {
1299         require(id <= starCount, "NFT does not exist");
1300         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1301         if (bytes(baseURI).length == 0) {
1302             return "";
1303         } else {
1304             // bytes memory b = new bytes(32);
1305             // assembly { mstore(add(b, 32), id) }
1306             // abi.encodePacked is being used to concatenate strings
1307             return string(abi.encodePacked(baseURI, uint2str(id), ".json"));
1308         }
1309     }
1310 
1311     /**
1312      * Is the nft owner.
1313      * Requirements:
1314      * - `account` must not be zero address.
1315      */
1316     function isOwnerOf(address account, uint256 id) public view override returns (bool) {
1317         return balanceOf(account, id) == 1;
1318     }
1319 
1320     /* ============ Internal Functions ============ */
1321     /* ============ Private Functions ============ */
1322     /* ============ Util Functions ============ */
1323     function uint2str(uint _i) internal pure returns (string memory) {
1324         if (_i == 0) {
1325             return "0";
1326         }
1327         uint j = _i;
1328         uint len;
1329         while (j != 0) {
1330             len++;
1331             j /= 10;
1332         }
1333         bytes memory bStr = new bytes(len);
1334         uint k = len;
1335         while (_i != 0) {
1336             k = k - 1;
1337             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1338             bytes1 b1 = bytes1(temp);
1339             bStr[k] = b1;
1340             _i /= 10;
1341         }
1342         return string(bStr);
1343     }
1344 }
