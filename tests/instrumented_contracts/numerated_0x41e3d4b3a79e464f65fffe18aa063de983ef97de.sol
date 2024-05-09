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
36         assembly {
37             size := extcodesize(account)
38         }
39         return size > 0;
40     }
41 
42     /**
43      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
44      * `recipient`, forwarding all available gas and reverting on errors.
45      *
46      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
47      * of certain opcodes, possibly making contracts go over the 2300 gas limit
48      * imposed by `transfer`, making them unable to receive funds via
49      * `transfer`. {sendValue} removes this limitation.
50      *
51      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
52      *
53      * IMPORTANT: because control is transferred to `recipient`, care must be
54      * taken to not create reentrancy vulnerabilities. Consider using
55      * {ReentrancyGuard} or the
56      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
57      */
58     function sendValue(address payable recipient, uint256 amount) internal {
59         require(address(this).balance >= amount, "Address: insufficient balance");
60 
61         (bool success, ) = recipient.call{value: amount}("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain `call` is an unsafe replacement for a function call: use this
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
84         return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, errorMessage);
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
103      * but also transferring `value` wei to `target`.
104      *
105      * Requirements:
106      *
107      * - the calling contract must have an ETH balance of at least `value`.
108      * - the called Solidity function must be `payable`.
109      *
110      * _Available since v3.1._
111      */
112     function functionCallWithValue(
113         address target,
114         bytes memory data,
115         uint256 value
116     ) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     /**
121      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
122      * with `errorMessage` as a fallback revert reason when `target` reverts.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         require(address(this).balance >= value, "Address: insufficient balance for call");
133         require(isContract(target), "Address: call to non-contract");
134 
135         (bool success, bytes memory returndata) = target.call{value: value}(data);
136         return _verifyCallResult(success, returndata, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
141      * but performing a static call.
142      *
143      * _Available since v3.3._
144      */
145     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
146         return functionStaticCall(target, data, "Address: low-level static call failed");
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(
156         address target,
157         bytes memory data,
158         string memory errorMessage
159     ) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         (bool success, bytes memory returndata) = target.staticcall(data);
163         return _verifyCallResult(success, returndata, errorMessage);
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
168      * but performing a delegate call.
169      *
170      * _Available since v3.4._
171      */
172     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         require(isContract(target), "Address: delegate call to non-contract");
188 
189         (bool success, bytes memory returndata) = target.delegatecall(data);
190         return _verifyCallResult(success, returndata, errorMessage);
191     }
192 
193     function _verifyCallResult(
194         bool success,
195         bytes memory returndata,
196         string memory errorMessage
197     ) private pure returns (bytes memory) {
198         if (success) {
199             return returndata;
200         } else {
201             // Look for revert reason and bubble it up if present
202             if (returndata.length > 0) {
203                 // The easiest way to bubble the revert reason is using memory via assembly
204 
205                 assembly {
206                     let returndata_size := mload(returndata)
207                     revert(add(32, returndata), returndata_size)
208                 }
209             } else {
210                 revert(errorMessage);
211             }
212         }
213     }
214 }
215 
216 // Part: Context
217 
218 /*
219  * @dev Provides information about the current execution context, including the
220  * sender of the transaction and its data. While these are generally available
221  * via msg.sender and msg.data, they should not be accessed in such a direct
222  * manner, since when dealing with GSN meta-transactions the account sending and
223  * paying for execution may not be the actual sender (as far as an application
224  * is concerned).
225  *
226  * This contract is only required for intermediate, library-like contracts.
227  */
228 abstract contract Context {
229     function _msgSender() internal view virtual returns (address payable) {
230         return msg.sender;
231     }
232 
233     function _msgData() internal view virtual returns (bytes memory) {
234         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
235         return msg.data;
236     }
237 }
238 
239 // Part: IERC165
240 
241 /**
242  * @dev Interface of the ERC165 standard, as defined in the
243  * https://eips.ethereum.org/EIPS/eip-165[EIP].
244  *
245  * Implementers can declare support of contract interfaces, which can then be
246  * queried by others ({ERC165Checker}).
247  *
248  * For an implementation, see {ERC165}.
249  */
250 interface IERC165 {
251     /**
252      * @dev Returns true if this contract implements the interface defined by
253      * `interfaceId`. See the corresponding
254      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
255      * to learn more about how these ids are created.
256      *
257      * This function call must use less than 30 000 gas.
258      */
259     function supportsInterface(bytes4 interfaceId) external view returns (bool);
260 }
261 
262 // Part: SafeMath
263 
264 /**
265  * @dev Wrappers over Solidity's arithmetic operations with added overflow
266  * checks.
267  *
268  * Arithmetic operations in Solidity wrap on overflow. This can easily result
269  * in bugs, because programmers usually assume that an overflow raises an
270  * error, which is the standard behavior in high level programming languages.
271  * `SafeMath` restores this intuition by reverting the transaction when an
272  * operation overflows.
273  *
274  * Using this library instead of the unchecked operations eliminates an entire
275  * class of bugs, so it's recommended to use it always.
276  */
277 library SafeMath {
278     /**
279      * @dev Returns the addition of two unsigned integers, with an overflow flag.
280      *
281      * _Available since v3.4._
282      */
283     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
284         uint256 c = a + b;
285         if (c < a) return (false, 0);
286         return (true, c);
287     }
288 
289     /**
290      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
291      *
292      * _Available since v3.4._
293      */
294     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
295         if (b > a) return (false, 0);
296         return (true, a - b);
297     }
298 
299     /**
300      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
301      *
302      * _Available since v3.4._
303      */
304     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
305         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
306         // benefit is lost if 'b' is also tested.
307         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
308         if (a == 0) return (true, 0);
309         uint256 c = a * b;
310         if (c / a != b) return (false, 0);
311         return (true, c);
312     }
313 
314     /**
315      * @dev Returns the division of two unsigned integers, with a division by zero flag.
316      *
317      * _Available since v3.4._
318      */
319     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
320         if (b == 0) return (false, 0);
321         return (true, a / b);
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
326      *
327      * _Available since v3.4._
328      */
329     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
330         if (b == 0) return (false, 0);
331         return (true, a % b);
332     }
333 
334     /**
335      * @dev Returns the addition of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `+` operator.
339      *
340      * Requirements:
341      *
342      * - Addition cannot overflow.
343      */
344     function add(uint256 a, uint256 b) internal pure returns (uint256) {
345         uint256 c = a + b;
346         require(c >= a, "SafeMath: addition overflow");
347         return c;
348     }
349 
350     /**
351      * @dev Returns the subtraction of two unsigned integers, reverting on
352      * overflow (when the result is negative).
353      *
354      * Counterpart to Solidity's `-` operator.
355      *
356      * Requirements:
357      *
358      * - Subtraction cannot overflow.
359      */
360     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
361         require(b <= a, "SafeMath: subtraction overflow");
362         return a - b;
363     }
364 
365     /**
366      * @dev Returns the multiplication of two unsigned integers, reverting on
367      * overflow.
368      *
369      * Counterpart to Solidity's `*` operator.
370      *
371      * Requirements:
372      *
373      * - Multiplication cannot overflow.
374      */
375     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
376         if (a == 0) return 0;
377         uint256 c = a * b;
378         require(c / a == b, "SafeMath: multiplication overflow");
379         return c;
380     }
381 
382     /**
383      * @dev Returns the integer division of two unsigned integers, reverting on
384      * division by zero. The result is rounded towards zero.
385      *
386      * Counterpart to Solidity's `/` operator. Note: this function uses a
387      * `revert` opcode (which leaves remaining gas untouched) while Solidity
388      * uses an invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function div(uint256 a, uint256 b) internal pure returns (uint256) {
395         require(b > 0, "SafeMath: division by zero");
396         return a / b;
397     }
398 
399     /**
400      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
401      * reverting when dividing by zero.
402      *
403      * Counterpart to Solidity's `%` operator. This function uses a `revert`
404      * opcode (which leaves remaining gas untouched) while Solidity uses an
405      * invalid opcode to revert (consuming all remaining gas).
406      *
407      * Requirements:
408      *
409      * - The divisor cannot be zero.
410      */
411     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
412         require(b > 0, "SafeMath: modulo by zero");
413         return a % b;
414     }
415 
416     /**
417      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
418      * overflow (when the result is negative).
419      *
420      * CAUTION: This function is deprecated because it requires allocating memory for the error
421      * message unnecessarily. For custom revert reasons use {trySub}.
422      *
423      * Counterpart to Solidity's `-` operator.
424      *
425      * Requirements:
426      *
427      * - Subtraction cannot overflow.
428      */
429     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
430         require(b <= a, errorMessage);
431         return a - b;
432     }
433 
434     /**
435      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
436      * division by zero. The result is rounded towards zero.
437      *
438      * CAUTION: This function is deprecated because it requires allocating memory for the error
439      * message unnecessarily. For custom revert reasons use {tryDiv}.
440      *
441      * Counterpart to Solidity's `/` operator. Note: this function uses a
442      * `revert` opcode (which leaves remaining gas untouched) while Solidity
443      * uses an invalid opcode to revert (consuming all remaining gas).
444      *
445      * Requirements:
446      *
447      * - The divisor cannot be zero.
448      */
449     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
450         require(b > 0, errorMessage);
451         return a / b;
452     }
453 
454     /**
455      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
456      * reverting with custom message when dividing by zero.
457      *
458      * CAUTION: This function is deprecated because it requires allocating memory for the error
459      * message unnecessarily. For custom revert reasons use {tryMod}.
460      *
461      * Counterpart to Solidity's `%` operator. This function uses a `revert`
462      * opcode (which leaves remaining gas untouched) while Solidity uses an
463      * invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
470         require(b > 0, errorMessage);
471         return a % b;
472     }
473 }
474 
475 // Part: ERC165
476 
477 /**
478  * @dev Implementation of the {IERC165} interface.
479  *
480  * Contracts may inherit from this and call {_registerInterface} to declare
481  * their support of an interface.
482  */
483 abstract contract ERC165 is IERC165 {
484     /*
485      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
486      */
487     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
488 
489     /**
490      * @dev Mapping of interface ids to whether or not it's supported.
491      */
492     mapping(bytes4 => bool) private _supportedInterfaces;
493 
494     constructor () internal {
495         // Derived contracts need only register support for their own interfaces,
496         // we register support for ERC165 itself here
497         _registerInterface(_INTERFACE_ID_ERC165);
498     }
499 
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      *
503      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
504      */
505     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
506         return _supportedInterfaces[interfaceId];
507     }
508 
509     /**
510      * @dev Registers the contract as an implementer of the interface defined by
511      * `interfaceId`. Support of the actual ERC165 interface is automatic and
512      * registering its interface id is not required.
513      *
514      * See {IERC165-supportsInterface}.
515      *
516      * Requirements:
517      *
518      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
519      */
520     function _registerInterface(bytes4 interfaceId) internal virtual {
521         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
522         _supportedInterfaces[interfaceId] = true;
523     }
524 }
525 
526 // Part: IERC1155
527 
528 /**
529  * @dev Required interface of an ERC1155 compliant contract, as defined in the
530  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
531  *
532  * _Available since v3.1._
533  */
534 interface IERC1155 is IERC165 {
535     /**
536      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
537      */
538     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
539 
540     /**
541      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
542      * transfers.
543      */
544     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
545 
546     /**
547      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
548      * `approved`.
549      */
550     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
551 
552     /**
553      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
554      *
555      * If an {URI} event was emitted for `id`, the standard
556      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
557      * returned by {IERC1155MetadataURI-uri}.
558      */
559     event URI(string value, uint256 indexed id);
560 
561     /**
562      * @dev Returns the amount of tokens of token type `id` owned by `account`.
563      *
564      * Requirements:
565      *
566      * - `account` cannot be the zero address.
567      */
568     function balanceOf(address account, uint256 id) external view returns (uint256);
569 
570     /**
571      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
572      *
573      * Requirements:
574      *
575      * - `accounts` and `ids` must have the same length.
576      */
577     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
578 
579     /**
580      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
581      *
582      * Emits an {ApprovalForAll} event.
583      *
584      * Requirements:
585      *
586      * - `operator` cannot be the caller.
587      */
588     function setApprovalForAll(address operator, bool approved) external;
589 
590     /**
591      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
592      *
593      * See {setApprovalForAll}.
594      */
595     function isApprovedForAll(address account, address operator) external view returns (bool);
596 
597     /**
598      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
599      *
600      * Emits a {TransferSingle} event.
601      *
602      * Requirements:
603      *
604      * - `to` cannot be the zero address.
605      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
606      * - `from` must have a balance of tokens of type `id` of at least `amount`.
607      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
608      * acceptance magic value.
609      */
610     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
611 
612     /**
613      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
614      *
615      * Emits a {TransferBatch} event.
616      *
617      * Requirements:
618      *
619      * - `ids` and `amounts` must have the same length.
620      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
621      * acceptance magic value.
622      */
623     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
624 }
625 
626 // Part: IERC1155Receiver
627 
628 /**
629  * _Available since v3.1._
630  */
631 interface IERC1155Receiver is IERC165 {
632 
633     /**
634         @dev Handles the receipt of a single ERC1155 token type. This function is
635         called at the end of a `safeTransferFrom` after the balance has been updated.
636         To accept the transfer, this must return
637         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
638         (i.e. 0xf23a6e61, or its own function selector).
639         @param operator The address which initiated the transfer (i.e. msg.sender)
640         @param from The address which previously owned the token
641         @param id The ID of the token being transferred
642         @param value The amount of tokens being transferred
643         @param data Additional data with no specified format
644         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
645     */
646     function onERC1155Received(
647         address operator,
648         address from,
649         uint256 id,
650         uint256 value,
651         bytes calldata data
652     )
653         external
654         returns(bytes4);
655 
656     /**
657         @dev Handles the receipt of a multiple ERC1155 token types. This function
658         is called at the end of a `safeBatchTransferFrom` after the balances have
659         been updated. To accept the transfer(s), this must return
660         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
661         (i.e. 0xbc197c81, or its own function selector).
662         @param operator The address which initiated the batch transfer (i.e. msg.sender)
663         @param from The address which previously owned the token
664         @param ids An array containing ids of each token being transferred (order and length must match values array)
665         @param values An array containing amounts of each token being transferred (order and length must match ids array)
666         @param data Additional data with no specified format
667         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
668     */
669     function onERC1155BatchReceived(
670         address operator,
671         address from,
672         uint256[] calldata ids,
673         uint256[] calldata values,
674         bytes calldata data
675     )
676         external
677         returns(bytes4);
678 }
679 
680 // Part: Ownable
681 
682 /**
683  * @dev Contract module which provides a basic access control mechanism, where
684  * there is an account (an owner) that can be granted exclusive access to
685  * specific functions.
686  *
687  * By default, the owner account will be the one that deploys the contract. This
688  * can later be changed with {transferOwnership}.
689  *
690  * This module is used through inheritance. It will make available the modifier
691  * `onlyOwner`, which can be applied to your functions to restrict their use to
692  * the owner.
693  */
694 abstract contract Ownable is Context {
695     address private _owner;
696 
697     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
698 
699     /**
700      * @dev Initializes the contract setting the deployer as the initial owner.
701      */
702     constructor () internal {
703         address msgSender = _msgSender();
704         _owner = msgSender;
705         emit OwnershipTransferred(address(0), msgSender);
706     }
707 
708     /**
709      * @dev Returns the address of the current owner.
710      */
711     function owner() public view virtual returns (address) {
712         return _owner;
713     }
714 
715     /**
716      * @dev Throws if called by any account other than the owner.
717      */
718     modifier onlyOwner() {
719         require(owner() == _msgSender(), "Ownable: caller is not the owner");
720         _;
721     }
722 
723     /**
724      * @dev Leaves the contract without owner. It will not be possible to call
725      * `onlyOwner` functions anymore. Can only be called by the current owner.
726      *
727      * NOTE: Renouncing ownership will leave the contract without an owner,
728      * thereby removing any functionality that is only available to the owner.
729      */
730     function renounceOwnership() public virtual onlyOwner {
731         emit OwnershipTransferred(_owner, address(0));
732         _owner = address(0);
733     }
734 
735     /**
736      * @dev Transfers ownership of the contract to a new account (`newOwner`).
737      * Can only be called by the current owner.
738      */
739     function transferOwnership(address newOwner) public virtual onlyOwner {
740         require(newOwner != address(0), "Ownable: new owner is the zero address");
741         emit OwnershipTransferred(_owner, newOwner);
742         _owner = newOwner;
743     }
744 }
745 
746 // Part: IERC1155MetadataURI
747 
748 /**
749  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
750  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
751  *
752  * _Available since v3.1._
753  */
754 interface IERC1155MetadataURI is IERC1155 {
755     /**
756      * @dev Returns the URI for token type `id`.
757      *
758      * If the `\{id\}` substring is present in the URI, it must be replaced by
759      * clients with the actual token type ID.
760      */
761     function uri(uint256 id) external view returns (string memory);
762 }
763 
764 // Part: IStarNFT
765 
766 /**
767  * @title IStarNFT
768  * @author Galaxy Protocol
769  *
770  * Interface for operating with StarNFTs.
771  */
772 interface IStarNFT is IERC1155 {
773     /* ============ Events =============== */
774 //    event PowahUpdated(uint256 indexed id, uint256 indexed oldPoints, uint256 indexed newPoints);
775 
776     /* ============ Functions ============ */
777 
778     function isOwnerOf(address, uint256) external view returns (bool);
779 //    function starInfo(uint256) external view returns (uint128 powah, uint128 mintBlock, address originator);
780 //    function quasarInfo(uint256) external view returns (uint128 mintBlock, IERC20 stakeToken, uint256 amount, uint256 campaignID);
781 //    function superInfo(uint256) external view returns (uint128 mintBlock, IERC20[] memory stakeToken, uint256[] memory amount, uint256 campaignID);
782 
783     // mint
784     function mint(address account, uint256 powah) external returns (uint256);
785     function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external returns (uint256[] memory);
786     function burn(address account, uint256 id) external;
787     function burnBatch(address account, uint256[] calldata ids) external;
788 
789     // asset-backing mint
790 //    function mintQuasar(address account, uint256 powah, uint256 cid, IERC20 stakeToken, uint256 amount) external returns (uint256);
791 //    function burnQuasar(address account, uint256 id) external;
792 
793     // asset-backing forge
794 //    function mintSuper(address account, uint256 powah, uint256 campaignID, IERC20[] calldata stakeTokens, uint256[] calldata amounts) external returns (uint256);
795 //    function burnSuper(address account, uint256 id) external;
796     // update
797 //    function updatePowah(address owner, uint256 id, uint256 powah) external;
798 }
799 
800 // Part: ERC1155
801 
802 /**
803  *
804  * @dev Implementation of the basic standard multi-token.
805  * See https://eips.ethereum.org/EIPS/eip-1155
806  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
807  *
808  * _Available since v3.1._
809  */
810 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
811     using SafeMath for uint256;
812     using Address for address;
813 
814     // Mapping from token ID to account balances
815     mapping (uint256 => mapping(address => uint256)) private _balances;
816 
817     // Mapping from account to operator approvals
818     mapping (address => mapping(address => bool)) private _operatorApprovals;
819 
820     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
821     string private _uri;
822 
823     /*
824      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
825      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
826      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
827      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
828      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
829      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
830      *
831      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
832      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
833      */
834     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
835 
836     /*
837      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
838      */
839     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
840 
841     /**
842      * @dev See {_setURI}.
843      */
844     constructor (string memory uri_) public {
845         _setURI(uri_);
846 
847         // register the supported interfaces to conform to ERC1155 via ERC165
848         _registerInterface(_INTERFACE_ID_ERC1155);
849 
850         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
851         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
852     }
853 
854     /**
855      * @dev See {IERC1155MetadataURI-uri}.
856      *
857      * This implementation returns the same URI for *all* token types. It relies
858      * on the token type ID substitution mechanism
859      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
860      *
861      * Clients calling this function must replace the `\{id\}` substring with the
862      * actual token type ID.
863      */
864     function uri(uint256) external view virtual override returns (string memory) {
865         return _uri;
866     }
867 
868     /**
869      * @dev See {IERC1155-balanceOf}.
870      *
871      * Requirements:
872      *
873      * - `account` cannot be the zero address.
874      */
875     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
876         require(account != address(0), "ERC1155: balance query for the zero address");
877         return _balances[id][account];
878     }
879 
880     /**
881      * @dev See {IERC1155-balanceOfBatch}.
882      *
883      * Requirements:
884      *
885      * - `accounts` and `ids` must have the same length.
886      */
887     function balanceOfBatch(
888         address[] memory accounts,
889         uint256[] memory ids
890     )
891         public
892         view
893         virtual
894         override
895         returns (uint256[] memory)
896     {
897         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
898 
899         uint256[] memory batchBalances = new uint256[](accounts.length);
900 
901         for (uint256 i = 0; i < accounts.length; ++i) {
902             batchBalances[i] = balanceOf(accounts[i], ids[i]);
903         }
904 
905         return batchBalances;
906     }
907 
908     /**
909      * @dev See {IERC1155-setApprovalForAll}.
910      */
911     function setApprovalForAll(address operator, bool approved) public virtual override {
912         require(_msgSender() != operator, "ERC1155: setting approval status for self");
913 
914         _operatorApprovals[_msgSender()][operator] = approved;
915         emit ApprovalForAll(_msgSender(), operator, approved);
916     }
917 
918     /**
919      * @dev See {IERC1155-isApprovedForAll}.
920      */
921     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
922         return _operatorApprovals[account][operator];
923     }
924 
925     /**
926      * @dev See {IERC1155-safeTransferFrom}.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 id,
932         uint256 amount,
933         bytes memory data
934     )
935         public
936         virtual
937         override
938     {
939         require(to != address(0), "ERC1155: transfer to the zero address");
940         require(
941             from == _msgSender() || isApprovedForAll(from, _msgSender()),
942             "ERC1155: caller is not owner nor approved"
943         );
944 
945         address operator = _msgSender();
946 
947         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
948 
949         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
950         _balances[id][to] = _balances[id][to].add(amount);
951 
952         emit TransferSingle(operator, from, to, id, amount);
953 
954         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
955     }
956 
957     /**
958      * @dev See {IERC1155-safeBatchTransferFrom}.
959      */
960     function safeBatchTransferFrom(
961         address from,
962         address to,
963         uint256[] memory ids,
964         uint256[] memory amounts,
965         bytes memory data
966     )
967         public
968         virtual
969         override
970     {
971         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
972         require(to != address(0), "ERC1155: transfer to the zero address");
973         require(
974             from == _msgSender() || isApprovedForAll(from, _msgSender()),
975             "ERC1155: transfer caller is not owner nor approved"
976         );
977 
978         address operator = _msgSender();
979 
980         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
981 
982         for (uint256 i = 0; i < ids.length; ++i) {
983             uint256 id = ids[i];
984             uint256 amount = amounts[i];
985 
986             _balances[id][from] = _balances[id][from].sub(
987                 amount,
988                 "ERC1155: insufficient balance for transfer"
989             );
990             _balances[id][to] = _balances[id][to].add(amount);
991         }
992 
993         emit TransferBatch(operator, from, to, ids, amounts);
994 
995         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
996     }
997 
998     /**
999      * @dev Sets a new URI for all token types, by relying on the token type ID
1000      * substitution mechanism
1001      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1002      *
1003      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1004      * URI or any of the amounts in the JSON file at said URI will be replaced by
1005      * clients with the token type ID.
1006      *
1007      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1008      * interpreted by clients as
1009      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1010      * for token type ID 0x4cce0.
1011      *
1012      * See {uri}.
1013      *
1014      * Because these URIs cannot be meaningfully represented by the {URI} event,
1015      * this function emits no events.
1016      */
1017     function _setURI(string memory newuri) internal virtual {
1018         _uri = newuri;
1019     }
1020 
1021     /**
1022      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1023      *
1024      * Emits a {TransferSingle} event.
1025      *
1026      * Requirements:
1027      *
1028      * - `account` cannot be the zero address.
1029      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1030      * acceptance magic value.
1031      */
1032     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
1033         require(account != address(0), "ERC1155: mint to the zero address");
1034 
1035         address operator = _msgSender();
1036 
1037         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
1038 
1039         _balances[id][account] = _balances[id][account].add(amount);
1040         emit TransferSingle(operator, address(0), account, id, amount);
1041 
1042         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
1043     }
1044 
1045     /**
1046      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1047      *
1048      * Requirements:
1049      *
1050      * - `ids` and `amounts` must have the same length.
1051      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1052      * acceptance magic value.
1053      */
1054     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
1055         require(to != address(0), "ERC1155: mint to the zero address");
1056         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1057 
1058         address operator = _msgSender();
1059 
1060         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1061 
1062         for (uint i = 0; i < ids.length; i++) {
1063             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
1064         }
1065 
1066         emit TransferBatch(operator, address(0), to, ids, amounts);
1067 
1068         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1069     }
1070 
1071     /**
1072      * @dev Destroys `amount` tokens of token type `id` from `account`
1073      *
1074      * Requirements:
1075      *
1076      * - `account` cannot be the zero address.
1077      * - `account` must have at least `amount` tokens of token type `id`.
1078      */
1079     function _burn(address account, uint256 id, uint256 amount) internal virtual {
1080         require(account != address(0), "ERC1155: burn from the zero address");
1081 
1082         address operator = _msgSender();
1083 
1084         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1085 
1086         _balances[id][account] = _balances[id][account].sub(
1087             amount,
1088             "ERC1155: burn amount exceeds balance"
1089         );
1090 
1091         emit TransferSingle(operator, account, address(0), id, amount);
1092     }
1093 
1094     /**
1095      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1096      *
1097      * Requirements:
1098      *
1099      * - `ids` and `amounts` must have the same length.
1100      */
1101     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
1102         require(account != address(0), "ERC1155: burn from the zero address");
1103         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1104 
1105         address operator = _msgSender();
1106 
1107         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1108 
1109         for (uint i = 0; i < ids.length; i++) {
1110             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
1111                 amounts[i],
1112                 "ERC1155: burn amount exceeds balance"
1113             );
1114         }
1115 
1116         emit TransferBatch(operator, account, address(0), ids, amounts);
1117     }
1118 
1119     /**
1120      * @dev Hook that is called before any token transfer. This includes minting
1121      * and burning, as well as batched variants.
1122      *
1123      * The same hook is called on both single and batched variants. For single
1124      * transfers, the length of the `id` and `amount` arrays will be 1.
1125      *
1126      * Calling conditions (for each `id` and `amount` pair):
1127      *
1128      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1129      * of token type `id` will be  transferred to `to`.
1130      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1131      * for `to`.
1132      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1133      * will be burned.
1134      * - `from` and `to` are never both zero.
1135      * - `ids` and `amounts` have the same, non-zero length.
1136      *
1137      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1138      */
1139     function _beforeTokenTransfer(
1140         address operator,
1141         address from,
1142         address to,
1143         uint256[] memory ids,
1144         uint256[] memory amounts,
1145         bytes memory data
1146     )
1147         internal
1148         virtual
1149     { }
1150 
1151     function _doSafeTransferAcceptanceCheck(
1152         address operator,
1153         address from,
1154         address to,
1155         uint256 id,
1156         uint256 amount,
1157         bytes memory data
1158     )
1159         private
1160     {
1161         if (to.isContract()) {
1162             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1163                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1164                     revert("ERC1155: ERC1155Receiver rejected tokens");
1165                 }
1166             } catch Error(string memory reason) {
1167                 revert(reason);
1168             } catch {
1169                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1170             }
1171         }
1172     }
1173 
1174     function _doSafeBatchTransferAcceptanceCheck(
1175         address operator,
1176         address from,
1177         address to,
1178         uint256[] memory ids,
1179         uint256[] memory amounts,
1180         bytes memory data
1181     )
1182         private
1183     {
1184         if (to.isContract()) {
1185             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1186                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1187                     revert("ERC1155: ERC1155Receiver rejected tokens");
1188                 }
1189             } catch Error(string memory reason) {
1190                 revert(reason);
1191             } catch {
1192                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1193             }
1194         }
1195     }
1196 
1197     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1198         uint256[] memory array = new uint256[](1);
1199         array[0] = element;
1200 
1201         return array;
1202     }
1203 }
1204 
1205 // File: StarNFTV2.sol
1206 
1207 /**
1208  * based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
1209  */
1210 contract StarNFTV1 is ERC1155, IStarNFT, Ownable {
1211     using SafeMath for uint256;
1212     //    using Address for address;
1213     //    using ERC165Checker for address;
1214 
1215     /* ============ Events ============ */
1216     /* ============ Modifiers ============ */
1217     /**
1218      * Only minter.
1219      */
1220     modifier onlyMinter() {
1221         require(minters[msg.sender], "must be minter");
1222         _;
1223     }
1224     /* ============ Enums ================ */
1225     /* ============ Structs ============ */
1226     /* ============ State Variables ============ */
1227 
1228     // Used as the URI for all token types by ID substitution, e.g. https://galaxy.eco/{address}/{id}.json
1229     string public baseURI;
1230 
1231     // Mint and burn star.
1232     mapping(address => bool) public minters;
1233 
1234     // Total star count, including burnt nft
1235     uint256 public starCount;
1236 
1237 
1238     /* ============ Constructor ============ */
1239     constructor () ERC1155("") {}
1240 
1241     /* ============ External Functions ============ */
1242 
1243     function mint(address account, uint256 powah) external onlyMinter override returns (uint256) {
1244         starCount++;
1245         uint256 sID = starCount;
1246 
1247         _mint(account, sID, 1, "");
1248         return sID;
1249     }
1250 
1251     function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external onlyMinter override returns (uint256[] memory) {
1252         uint256[] memory ids = new uint256[](amount);
1253         uint256[] memory amounts = new uint256[](amount);
1254         for (uint i = 0; i < ids.length; i++) {
1255             starCount++;
1256             ids[i] = starCount;
1257             amounts[i] = 1;
1258         }
1259         _mintBatch(account, ids, amounts, "");
1260         return ids;
1261     }
1262 
1263     function burn(address account, uint256 id) external onlyMinter override {
1264         require(isApprovedForAll(account, _msgSender()), "ERC1155: caller is not approved");
1265 
1266         _burn(account, id, 1);
1267     }
1268 
1269     function burnBatch(address account, uint256[] calldata ids) external onlyMinter override {
1270         require(isApprovedForAll(account, _msgSender()), "ERC1155: caller is not approved");
1271 
1272         uint256[] memory amounts = new uint256[](ids.length);
1273         for (uint i = 0; i < ids.length; i++) {
1274             amounts[i] = 1;
1275         }
1276 
1277         _burnBatch(account, ids, amounts);
1278     }
1279 
1280     /**
1281      * PRIVILEGED MODULE FUNCTION. Sets a new baseURI for all token types.
1282      */
1283     function setURI(string memory newURI) external onlyOwner {
1284         baseURI = newURI;
1285     }
1286 
1287     /**
1288      * PRIVILEGED MODULE FUNCTION. Add a new minter.
1289      */
1290     function addMinter(address minter) external onlyOwner {
1291         require(minter != address(0), "Minter must not be null address");
1292         require(!minters[minter], "Minter already added");
1293         minters[minter] = true;
1294     }
1295 
1296     /**
1297      * PRIVILEGED MODULE FUNCTION. Remove a old minter.
1298      */
1299     function removeMinter(address minter) external onlyOwner {
1300         require(minters[minter], "Minter does not exist");
1301         delete minters[minter];
1302     }
1303 
1304     /* ============ External Getter Functions ============ */
1305     /**
1306      * See {IERC1155MetadataURI-uri}.
1307      *
1308      * This implementation returns the same URI for *all* token types. It relies
1309      * on the token type ID substitution mechanism
1310      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1311      *
1312      * Clients calling this function must replace the `\{id\}` substring with the
1313      * actual token type ID.
1314      */
1315     function uri(uint256 id) external view override returns (string memory) {
1316         require(id <= starCount, "NFT does not exist");
1317         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1318         if (bytes(baseURI).length == 0) {
1319             return "";
1320         } else {
1321             // bytes memory b = new bytes(32);
1322             // assembly { mstore(add(b, 32), id) }
1323             // abi.encodePacked is being used to concatenate strings
1324             return string(abi.encodePacked(baseURI, uint2str(id), ".json"));
1325         }
1326     }
1327 
1328     /**
1329      * Is the nft owner.
1330      * Requirements:
1331      * - `account` must not be zero address.
1332      */
1333     function isOwnerOf(address account, uint256 id) public view override returns (bool) {
1334         return balanceOf(account, id) == 1;
1335     }
1336 
1337     /* ============ Internal Functions ============ */
1338     /* ============ Private Functions ============ */
1339     /* ============ Util Functions ============ */
1340     function uint2str(uint _i) internal pure returns (string memory) {
1341         if (_i == 0) {
1342             return "0";
1343         }
1344         uint j = _i;
1345         uint len;
1346         while (j != 0) {
1347             len++;
1348             j /= 10;
1349         }
1350         bytes memory bStr = new bytes(len);
1351         uint k = len;
1352         while (_i != 0) {
1353             k = k - 1;
1354             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1355             bytes1 b1 = bytes1(temp);
1356             bStr[k] = b1;
1357             _i /= 10;
1358         }
1359         return string(bStr);
1360     }
1361 }
