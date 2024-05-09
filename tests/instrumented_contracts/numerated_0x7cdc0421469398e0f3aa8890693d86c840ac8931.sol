1 pragma solidity ^0.7.0;
2 
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // This method relies on extcodesize, which returns 0 for contracts in
27         // construction, since the code is only stored at the end of the
28         // constructor execution.
29 
30         uint256 size;
31         // solhint-disable-next-line no-inline-assembly
32         assembly { size := extcodesize(account) }
33         return size > 0;
34     }
35 
36     /**
37      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
38      * `recipient`, forwarding all available gas and reverting on errors.
39      *
40      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
41      * of certain opcodes, possibly making contracts go over the 2300 gas limit
42      * imposed by `transfer`, making them unable to receive funds via
43      * `transfer`. {sendValue} removes this limitation.
44      *
45      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
46      *
47      * IMPORTANT: because control is transferred to `recipient`, care must be
48      * taken to not create reentrancy vulnerabilities. Consider using
49      * {ReentrancyGuard} or the
50      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
51      */
52     function sendValue(address payable recipient, uint256 amount) internal {
53         require(address(this).balance >= amount, "Address: insufficient balance");
54 
55         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
56         (bool success, ) = recipient.call{ value: amount }("");
57         require(success, "Address: unable to send value, recipient may have reverted");
58     }
59 
60     /**
61      * @dev Performs a Solidity function call using a low level `call`. A
62      * plain`call` is an unsafe replacement for a function call: use this
63      * function instead.
64      *
65      * If `target` reverts with a revert reason, it is bubbled up by this
66      * function (like regular Solidity function calls).
67      *
68      * Returns the raw returned data. To convert to the expected return value,
69      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
70      *
71      * Requirements:
72      *
73      * - `target` must be a contract.
74      * - calling `target` with `data` must not revert.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79       return functionCall(target, data, "Address: low-level call failed");
80     }
81 
82     /**
83      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
84      * `errorMessage` as a fallback revert reason when `target` reverts.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, 0, errorMessage);
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
94      * but also transferring `value` wei to `target`.
95      *
96      * Requirements:
97      *
98      * - the calling contract must have an ETH balance of at least `value`.
99      * - the called Solidity function must be `payable`.
100      *
101      * _Available since v3.1._
102      */
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
109      * with `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         require(isContract(target), "Address: call to non-contract");
116 
117         // solhint-disable-next-line avoid-low-level-calls
118         (bool success, bytes memory returndata) = target.call{ value: value }(data);
119         return _verifyCallResult(success, returndata, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but performing a static call.
125      *
126      * _Available since v3.3._
127      */
128     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
129         return functionStaticCall(target, data, "Address: low-level static call failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
134      * but performing a static call.
135      *
136      * _Available since v3.3._
137      */
138     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
139         require(isContract(target), "Address: static call to non-contract");
140 
141         // solhint-disable-next-line avoid-low-level-calls
142         (bool success, bytes memory returndata) = target.staticcall(data);
143         return _verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a delegate call.
149      *
150      * _Available since v3.3._
151      */
152     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
153         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
154     }
155 
156     /**
157      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
158      * but performing a delegate call.
159      *
160      * _Available since v3.3._
161      */
162     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
163         require(isContract(target), "Address: delegate call to non-contract");
164 
165         // solhint-disable-next-line avoid-low-level-calls
166         (bool success, bytes memory returndata) = target.delegatecall(data);
167         return _verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
171         if (success) {
172             return returndata;
173         } else {
174             // Look for revert reason and bubble it up if present
175             if (returndata.length > 0) {
176                 // The easiest way to bubble the revert reason is using memory via assembly
177 
178                 // solhint-disable-next-line no-inline-assembly
179                 assembly {
180                     let returndata_size := mload(returndata)
181                     revert(add(32, returndata), returndata_size)
182                 }
183             } else {
184                 revert(errorMessage);
185             }
186         }
187     }
188 }
189 
190 /**
191  * @dev Wrappers over Solidity's arithmetic operations with added overflow
192  * checks.
193  *
194  * Arithmetic operations in Solidity wrap on overflow. This can easily result
195  * in bugs, because programmers usually assume that an overflow raises an
196  * error, which is the standard behavior in high level programming languages.
197  * `SafeMath` restores this intuition by reverting the transaction when an
198  * operation overflows.
199  *
200  * Using this library instead of the unchecked operations eliminates an entire
201  * class of bugs, so it's recommended to use it always.
202  */
203 library SafeMath {
204     /**
205      * @dev Returns the addition of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `+` operator.
209      *
210      * Requirements:
211      *
212      * - Addition cannot overflow.
213      */
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         uint256 c = a + b;
216         require(c >= a, "SafeMath: addition overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      *
229      * - Subtraction cannot overflow.
230      */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         return sub(a, b, "SafeMath: subtraction overflow");
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      *
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b <= a, errorMessage);
247         uint256 c = a - b;
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the multiplication of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `*` operator.
257      *
258      * Requirements:
259      *
260      * - Multiplication cannot overflow.
261      */
262     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
264         // benefit is lost if 'b' is also tested.
265         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
266         if (a == 0) {
267             return 0;
268         }
269 
270         uint256 c = a * b;
271         require(c / a == b, "SafeMath: multiplication overflow");
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers. Reverts on
278      * division by zero. The result is rounded towards zero.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         return div(a, b, "SafeMath: division by zero");
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * Counterpart to Solidity's `/` operator. Note: this function uses a
297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
298      * uses an invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b > 0, errorMessage);
306         uint256 c = a / b;
307         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * Reverts when dividing by zero.
315      *
316      * Counterpart to Solidity's `%` operator. This function uses a `revert`
317      * opcode (which leaves remaining gas untouched) while Solidity uses an
318      * invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         return mod(a, b, "SafeMath: modulo by zero");
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * Reverts with custom message when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
341         require(b != 0, errorMessage);
342         return a % b;
343     }
344 }
345 
346 /*
347  * @dev Provides information about the current execution context, including the
348  * sender of the transaction and its data. While these are generally available
349  * via msg.sender and msg.data, they should not be accessed in such a direct
350  * manner, since when dealing with GSN meta-transactions the account sending and
351  * paying for execution may not be the actual sender (as far as an application
352  * is concerned).
353  *
354  * This contract is only required for intermediate, library-like contracts.
355  */
356 abstract contract Context {
357     function _msgSender() internal view virtual returns (address payable) {
358         return msg.sender;
359     }
360 
361     function _msgData() internal view virtual returns (bytes memory) {
362         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
363         return msg.data;
364     }
365 }
366 
367 /**
368  * @dev Interface of the ERC165 standard, as defined in the
369  * https://eips.ethereum.org/EIPS/eip-165[EIP].
370  *
371  * Implementers can declare support of contract interfaces, which can then be
372  * queried by others ({ERC165Checker}).
373  *
374  * For an implementation, see {ERC165}.
375  */
376 interface IERC165 {
377     /**
378      * @dev Returns true if this contract implements the interface defined by
379      * `interfaceId`. See the corresponding
380      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
381      * to learn more about how these ids are created.
382      *
383      * This function call must use less than 30 000 gas.
384      */
385     function supportsInterface(bytes4 interfaceId) external view returns (bool);
386 }
387 
388 
389 /**
390  * @dev Implementation of the {IERC165} interface.
391  *
392  * Contracts may inherit from this and call {_registerInterface} to declare
393  * their support of an interface.
394  */
395 abstract contract ERC165 is IERC165 {
396     /*
397      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
398      */
399     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
400 
401     /**
402      * @dev Mapping of interface ids to whether or not it's supported.
403      */
404     mapping(bytes4 => bool) private _supportedInterfaces;
405 
406     constructor () internal {
407         // Derived contracts need only register support for their own interfaces,
408         // we register support for ERC165 itself here
409         _registerInterface(_INTERFACE_ID_ERC165);
410     }
411 
412     /**
413      * @dev See {IERC165-supportsInterface}.
414      *
415      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
416      */
417     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
418         return _supportedInterfaces[interfaceId];
419     }
420 
421     /**
422      * @dev Registers the contract as an implementer of the interface defined by
423      * `interfaceId`. Support of the actual ERC165 interface is automatic and
424      * registering its interface id is not required.
425      *
426      * See {IERC165-supportsInterface}.
427      *
428      * Requirements:
429      *
430      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
431      */
432     function _registerInterface(bytes4 interfaceId) internal virtual {
433         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
434         _supportedInterfaces[interfaceId] = true;
435     }
436 }
437 
438 
439 /**
440  * _Available since v3.1._
441  */
442 interface IERC1155Receiver is IERC165 {
443 
444     /**
445         @dev Handles the receipt of a single ERC1155 token type. This function is
446         called at the end of a `safeTransferFrom` after the balance has been updated.
447         To accept the transfer, this must return
448         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
449         (i.e. 0xf23a6e61, or its own function selector).
450         @param operator The address which initiated the transfer (i.e. msg.sender)
451         @param from The address which previously owned the token
452         @param id The ID of the token being transferred
453         @param value The amount of tokens being transferred
454         @param data Additional data with no specified format
455         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
456     */
457     function onERC1155Received(
458         address operator,
459         address from,
460         uint256 id,
461         uint256 value,
462         bytes calldata data
463     )
464         external
465         returns(bytes4);
466 
467     /**
468         @dev Handles the receipt of a multiple ERC1155 token types. This function
469         is called at the end of a `safeBatchTransferFrom` after the balances have
470         been updated. To accept the transfer(s), this must return
471         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
472         (i.e. 0xbc197c81, or its own function selector).
473         @param operator The address which initiated the batch transfer (i.e. msg.sender)
474         @param from The address which previously owned the token
475         @param ids An array containing ids of each token being transferred (order and length must match values array)
476         @param values An array containing amounts of each token being transferred (order and length must match ids array)
477         @param data Additional data with no specified format
478         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
479     */
480     function onERC1155BatchReceived(
481         address operator,
482         address from,
483         uint256[] calldata ids,
484         uint256[] calldata values,
485         bytes calldata data
486     )
487         external
488         returns(bytes4);
489 }
490 
491 
492 /**
493  * @dev Required interface of an ERC1155 compliant contract, as defined in the
494  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
495  *
496  * _Available since v3.1._
497  */
498 interface IERC1155 is IERC165 {
499     /**
500      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
501      */
502     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
503 
504     /**
505      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
506      * transfers.
507      */
508     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
509 
510     /**
511      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
512      * `approved`.
513      */
514     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
515 
516     /**
517      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
518      *
519      * If an {URI} event was emitted for `id`, the standard
520      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
521      * returned by {IERC1155MetadataURI-uri}.
522      */
523     event URI(string value, uint256 indexed id);
524 
525     /**
526      * @dev Returns the amount of tokens of token type `id` owned by `account`.
527      *
528      * Requirements:
529      *
530      * - `account` cannot be the zero address.
531      */
532     function balanceOf(address account, uint256 id) external view returns (uint256);
533 
534     /**
535      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
536      *
537      * Requirements:
538      *
539      * - `accounts` and `ids` must have the same length.
540      */
541     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
542 
543     /**
544      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
545      *
546      * Emits an {ApprovalForAll} event.
547      *
548      * Requirements:
549      *
550      * - `operator` cannot be the caller.
551      */
552     function setApprovalForAll(address operator, bool approved) external;
553 
554     /**
555      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
556      *
557      * See {setApprovalForAll}.
558      */
559     function isApprovedForAll(address account, address operator) external view returns (bool);
560 
561     /**
562      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
563      *
564      * Emits a {TransferSingle} event.
565      *
566      * Requirements:
567      *
568      * - `to` cannot be the zero address.
569      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
570      * - `from` must have a balance of tokens of type `id` of at least `amount`.
571      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
572      * acceptance magic value.
573      */
574     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
575 
576     /**
577      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
578      *
579      * Emits a {TransferBatch} event.
580      *
581      * Requirements:
582      *
583      * - `ids` and `amounts` must have the same length.
584      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
585      * acceptance magic value.
586      */
587     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
588 }
589 
590 
591 /**
592  *
593  * @dev Implementation of the basic standard multi-token.
594  * See https://eips.ethereum.org/EIPS/eip-1155
595  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
596  *
597  * _Available since v3.1._
598  */
599 contract ERC1155 is Context, ERC165, IERC1155 {
600     using SafeMath for uint256;
601     using Address for address;
602 
603     // Mapping from token ID to account balances
604     mapping (uint256 => mapping(address => uint256)) private _balances;
605 
606     // Mapping from account to operator approvals
607     mapping (address => mapping(address => bool)) private _operatorApprovals;
608 
609     /*
610      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
611      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
612      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
613      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
614      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
615      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
616      *
617      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
618      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
619      */
620     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
621 
622     /*
623      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
624      */
625     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
626 
627     constructor () public {
628         // register the supported interfaces to conform to ERC1155 via ERC165
629         _registerInterface(_INTERFACE_ID_ERC1155);
630 
631         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
632         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
633     }
634 
635     /**
636      * @dev See {IERC1155-balanceOf}.
637      *
638      * Requirements:
639      *
640      * - `account` cannot be the zero address.
641      */
642     function balanceOf(address account, uint256 id) public view override returns (uint256) {
643         require(account != address(0), "ERC1155: balance query for the zero address");
644         return _balances[id][account];
645     }
646 
647     /**
648      * @dev See {IERC1155-balanceOfBatch}.
649      *
650      * Requirements:
651      *
652      * - `accounts` and `ids` must have the same length.
653      */
654     function balanceOfBatch(
655         address[] memory accounts,
656         uint256[] memory ids
657     )
658         public
659         view
660         override
661         returns (uint256[] memory)
662     {
663         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
664 
665         uint256[] memory batchBalances = new uint256[](accounts.length);
666 
667         for (uint256 i = 0; i < accounts.length; ++i) {
668             require(accounts[i] != address(0), "ERC1155: batch balance query for the zero address");
669             batchBalances[i] = _balances[ids[i]][accounts[i]];
670         }
671 
672         return batchBalances;
673     }
674 
675     /**
676      * @dev See {IERC1155-setApprovalForAll}.
677      */
678     function setApprovalForAll(address operator, bool approved) public virtual override {
679         require(_msgSender() != operator, "ERC1155: setting approval status for self");
680 
681         _operatorApprovals[_msgSender()][operator] = approved;
682         emit ApprovalForAll(_msgSender(), operator, approved);
683     }
684 
685     /**
686      * @dev See {IERC1155-isApprovedForAll}.
687      */
688     function isApprovedForAll(address account, address operator) public view override returns (bool) {
689         return _operatorApprovals[account][operator];
690     }
691 
692     /**
693      * @dev See {IERC1155-safeTransferFrom}.
694      */
695     function safeTransferFrom(
696         address from,
697         address to,
698         uint256 id,
699         uint256 amount,
700         bytes memory data
701     )
702         public
703         virtual
704         override
705     {
706         require(to != address(0), "ERC1155: transfer to the zero address");
707         require(
708             from == _msgSender() || isApprovedForAll(from, _msgSender()),
709             "ERC1155: caller is not owner nor approved"
710         );
711 
712         address operator = _msgSender();
713 
714         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
715 
716         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
717         _balances[id][to] = _balances[id][to].add(amount);
718 
719         emit TransferSingle(operator, from, to, id, amount);
720 
721         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
722     }
723 
724     /**
725      * @dev See {IERC1155-safeBatchTransferFrom}.
726      */
727     function safeBatchTransferFrom(
728         address from,
729         address to,
730         uint256[] memory ids,
731         uint256[] memory amounts,
732         bytes memory data
733     )
734         public
735         virtual
736         override
737     {
738         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
739         require(to != address(0), "ERC1155: transfer to the zero address");
740         require(
741             from == _msgSender() || isApprovedForAll(from, _msgSender()),
742             "ERC1155: transfer caller is not owner nor approved"
743         );
744 
745         address operator = _msgSender();
746 
747         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
748 
749         for (uint256 i = 0; i < ids.length; ++i) {
750             uint256 id = ids[i];
751             uint256 amount = amounts[i];
752 
753             _balances[id][from] = _balances[id][from].sub(
754                 amount,
755                 "ERC1155: insufficient balance for transfer"
756             );
757             _balances[id][to] = _balances[id][to].add(amount);
758         }
759 
760         emit TransferBatch(operator, from, to, ids, amounts);
761 
762         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
763     }
764 
765     /**
766      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
767      *
768      * Emits a {TransferSingle} event.
769      *
770      * Requirements:
771      *
772      * - `account` cannot be the zero address.
773      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
774      * acceptance magic value.
775      */
776     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
777         require(account != address(0), "ERC1155: mint to the zero address");
778 
779         address operator = _msgSender();
780 
781         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
782 
783         _balances[id][account] = _balances[id][account].add(amount);
784         emit TransferSingle(operator, address(0), account, id, amount);
785 
786         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
787     }
788 
789     /**
790      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
791      *
792      * Requirements:
793      *
794      * - `ids` and `amounts` must have the same length.
795      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
796      * acceptance magic value.
797      */
798     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
799         require(to != address(0), "ERC1155: mint to the zero address");
800         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
801 
802         address operator = _msgSender();
803 
804         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
805 
806         for (uint i = 0; i < ids.length; i++) {
807             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
808         }
809 
810         emit TransferBatch(operator, address(0), to, ids, amounts);
811 
812         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
813     }
814 
815     /**
816      * @dev Destroys `amount` tokens of token type `id` from `account`
817      *
818      * Requirements:
819      *
820      * - `account` cannot be the zero address.
821      * - `account` must have at least `amount` tokens of token type `id`.
822      */
823     function _burn(address account, uint256 id, uint256 amount) internal virtual {
824         require(account != address(0), "ERC1155: burn from the zero address");
825 
826         address operator = _msgSender();
827 
828         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
829 
830         _balances[id][account] = _balances[id][account].sub(
831             amount,
832             "ERC1155: burn amount exceeds balance"
833         );
834 
835         emit TransferSingle(operator, account, address(0), id, amount);
836     }
837 
838     /**
839      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
840      *
841      * Requirements:
842      *
843      * - `ids` and `amounts` must have the same length.
844      */
845     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
846         require(account != address(0), "ERC1155: burn from the zero address");
847         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
848 
849         address operator = _msgSender();
850 
851         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
852 
853         for (uint i = 0; i < ids.length; i++) {
854             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
855                 amounts[i],
856                 "ERC1155: burn amount exceeds balance"
857             );
858         }
859 
860         emit TransferBatch(operator, account, address(0), ids, amounts);
861     }
862 
863     /**
864      * @dev Hook that is called before any token transfer. This includes minting
865      * and burning, as well as batched variants.
866      *
867      * The same hook is called on both single and batched variants. For single
868      * transfers, the length of the `id` and `amount` arrays will be 1.
869      *
870      * Calling conditions (for each `id` and `amount` pair):
871      *
872      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
873      * of token type `id` will be  transferred to `to`.
874      * - When `from` is zero, `amount` tokens of token type `id` will be minted
875      * for `to`.
876      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
877      * will be burned.
878      * - `from` and `to` are never both zero.
879      * - `ids` and `amounts` have the same, non-zero length.
880      *
881      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
882      */
883     function _beforeTokenTransfer(
884         address operator,
885         address from,
886         address to,
887         uint256[] memory ids,
888         uint256[] memory amounts,
889         bytes memory data
890     )
891         internal virtual
892     { }
893 
894     function _doSafeTransferAcceptanceCheck(
895         address operator,
896         address from,
897         address to,
898         uint256 id,
899         uint256 amount,
900         bytes memory data
901     )
902         private
903     {
904         if (to.isContract()) {
905             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
906                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
907                     revert("ERC1155: ERC1155Receiver rejected tokens");
908                 }
909             } catch Error(string memory reason) {
910                 revert(reason);
911             } catch {
912                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
913             }
914         }
915     }
916 
917     function _doSafeBatchTransferAcceptanceCheck(
918         address operator,
919         address from,
920         address to,
921         uint256[] memory ids,
922         uint256[] memory amounts,
923         bytes memory data
924     )
925         private
926     {
927         if (to.isContract()) {
928             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
929                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
930                     revert("ERC1155: ERC1155Receiver rejected tokens");
931                 }
932             } catch Error(string memory reason) {
933                 revert(reason);
934             } catch {
935                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
936             }
937         }
938     }
939 
940     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
941         uint256[] memory array = new uint256[](1);
942         array[0] = element;
943 
944         return array;
945     }
946 }
947 
948 library UintLibrary {
949     function toString(uint256 _i) internal pure returns (string memory) {
950         if (_i == 0) {
951             return "0";
952         }
953         uint j = _i;
954         uint len;
955         while (j != 0) {
956             len++;
957             j /= 10;
958         }
959         bytes memory bstr = new bytes(len);
960         uint k = len - 1;
961         while (_i != 0) {
962             bstr[k--] = byte(uint8(48 + _i % 10));
963             _i /= 10;
964         }
965         return string(bstr);
966     }
967 }
968 
969 library StringLibrary {
970     using UintLibrary for uint256;
971 
972     function append(string memory _a, string memory _b) internal pure returns (string memory) {
973         bytes memory _ba = bytes(_a);
974         bytes memory _bb = bytes(_b);
975         bytes memory bab = new bytes(_ba.length + _bb.length);
976         uint k = 0;
977         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
978         for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
979         return string(bab);
980     }
981 
982     function append(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
983         bytes memory _ba = bytes(_a);
984         bytes memory _bb = bytes(_b);
985         bytes memory _bc = bytes(_c);
986         bytes memory bbb = new bytes(_ba.length + _bb.length + _bc.length);
987         uint k = 0;
988         for (uint i = 0; i < _ba.length; i++) bbb[k++] = _ba[i];
989         for (uint i = 0; i < _bb.length; i++) bbb[k++] = _bb[i];
990         for (uint i = 0; i < _bc.length; i++) bbb[k++] = _bc[i];
991         return string(bbb);
992     }
993 
994     function recover(string memory message, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
995         bytes memory msgBytes = bytes(message);
996         bytes memory fullMessage = concat(
997             bytes("\x19Ethereum Signed Message:\n"),
998             bytes(msgBytes.length.toString()),
999             msgBytes,
1000             new bytes(0), new bytes(0), new bytes(0), new bytes(0)
1001         );
1002         return ecrecover(keccak256(fullMessage), v, r, s);
1003     }
1004 
1005     function concat(bytes memory _ba, bytes memory _bb, bytes memory _bc, bytes memory _bd, bytes memory _be, bytes memory _bf, bytes memory _bg) internal pure returns (bytes memory) {
1006         bytes memory resultBytes = new bytes(_ba.length + _bb.length + _bc.length + _bd.length + _be.length + _bf.length + _bg.length);
1007         uint k = 0;
1008         for (uint i = 0; i < _ba.length; i++) resultBytes[k++] = _ba[i];
1009         for (uint i = 0; i < _bb.length; i++) resultBytes[k++] = _bb[i];
1010         for (uint i = 0; i < _bc.length; i++) resultBytes[k++] = _bc[i];
1011         for (uint i = 0; i < _bd.length; i++) resultBytes[k++] = _bd[i];
1012         for (uint i = 0; i < _be.length; i++) resultBytes[k++] = _be[i];
1013         for (uint i = 0; i < _bf.length; i++) resultBytes[k++] = _bf[i];
1014         for (uint i = 0; i < _bg.length; i++) resultBytes[k++] = _bg[i];
1015         return resultBytes;
1016     }
1017 }
1018 
1019 contract TokenURI {
1020     using StringLibrary for string;
1021 
1022     string public tokenBaseURI;
1023     mapping (uint256 => string) private _tokenURIs;
1024 
1025     constructor(string memory uri) {
1026         tokenBaseURI = uri;
1027     }
1028 
1029     function _setBaseURI(string memory uri) internal {
1030         tokenBaseURI = uri;
1031     }
1032 
1033     function _tokenURI(uint256 tokenId) internal view returns (string memory) {
1034         return tokenBaseURI.append(_tokenURIs[tokenId]);
1035     }
1036 
1037     function _setTokenURI(uint256 tokenId, string memory uri) internal {
1038         bytes memory tokenUri = bytes(_tokenURIs[tokenId]);
1039         require(tokenUri.length == 0, "Uri has existed.");
1040         _tokenURIs[tokenId] = uri;
1041     }
1042 
1043     function _clearTokenURI(uint256 tokenId) internal {
1044         if (bytes(_tokenURIs[tokenId]).length != 0) {
1045             delete _tokenURIs[tokenId];
1046         }
1047     }
1048 }
1049 
1050 /**
1051  * @dev Contract module which provides a basic access control mechanism, where
1052  * there is an account (an owner) that can be granted exclusive access to
1053  * specific functions.
1054  *
1055  * By default, the owner account will be the one that deploys the contract. This
1056  * can later be changed with {transferOwnership}.
1057  *
1058  * This module is used through inheritance. It will make available the modifier
1059  * `onlyOwner`, which can be applied to your functions to restrict their use to
1060  * the owner.
1061  */
1062 abstract contract Ownable is Context {
1063     address private _owner;
1064 
1065     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1066 
1067     /**
1068      * @dev Initializes the contract setting the deployer as the initial owner.
1069      */
1070     constructor () internal {
1071         address msgSender = _msgSender();
1072         _owner = msgSender;
1073         emit OwnershipTransferred(address(0), msgSender);
1074     }
1075 
1076     /**
1077      * @dev Returns the address of the current owner.
1078      */
1079     function owner() public view returns (address) {
1080         return _owner;
1081     }
1082 
1083     /**
1084      * @dev Throws if called by any account other than the owner.
1085      */
1086     modifier onlyOwner() {
1087         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1088         _;
1089     }
1090 
1091     /**
1092      * @dev Leaves the contract without owner. It will not be possible to call
1093      * `onlyOwner` functions anymore. Can only be called by the current owner.
1094      *
1095      * NOTE: Renouncing ownership will leave the contract without an owner,
1096      * thereby removing any functionality that is only available to the owner.
1097      */
1098     function renounceOwnership() public virtual onlyOwner {
1099         emit OwnershipTransferred(_owner, address(0));
1100         _owner = address(0);
1101     }
1102 
1103     /**
1104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1105      * Can only be called by the current owner.
1106      */
1107     function transferOwnership(address newOwner) public virtual onlyOwner {
1108         require(newOwner != address(0), "Ownable: new owner is the zero address");
1109         emit OwnershipTransferred(_owner, newOwner);
1110         _owner = newOwner;
1111     }
1112 }
1113 
1114 /**
1115  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1116  * own tokens and those that they have been approved to use.
1117  *
1118  * _Available since v3.1._
1119  */
1120 abstract contract ERC1155Burnable is ERC1155 {
1121     function burn(address account, uint256 id, uint256 value) public virtual {
1122         require(
1123             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1124             "ERC1155: caller is not owner nor approved"
1125         );
1126 
1127         _burn(account, id, value);
1128     }
1129 
1130     function burnBatch(address account, uint256[] memory ids, uint256[] memory values) public virtual {
1131         require(
1132             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1133             "ERC1155: caller is not owner nor approved"
1134         );
1135 
1136         _burnBatch(account, ids, values);
1137     }
1138 }
1139 
1140 contract MomijiToken is ERC1155, TokenURI, ERC1155Burnable, Ownable {
1141     using SafeMath for uint256;
1142     using Address for address;
1143 
1144     string public name;
1145     string public symbol;
1146 
1147     // Count of duplication of every token.
1148     mapping(uint256 => uint256) public tokenQuantityWithId;
1149     mapping(uint256 => uint256) public tokenMaxQuantityWithId;
1150     mapping(uint256 => uint256) public mintManuallyQuantityWithId;
1151 
1152     mapping(uint256 => address) public creators;
1153     mapping(uint256 => mapping(address => bool)) public minters;
1154     uint256 [] public tokenIds;
1155     uint256 public tokenIdAmount;
1156 
1157     bool public onlyWhitelist = true;
1158     mapping(address => bool) public whitelist;
1159 
1160     event Create(uint256 maxSupply, uint256 tokenId, string indexed uri, bytes indexed data);
1161     event Mint(uint256 tokenId, address to, uint256 quantity, bytes indexed data, uint256 tokenMaxQuantity, uint256 tokenCurrentQuantity);
1162 
1163     constructor(string memory tokenName, string memory tokenSymbol, string memory baseUri) TokenURI(baseUri) {
1164         name = tokenName;
1165         symbol = tokenSymbol;
1166     }
1167 
1168     function setBaseURI(string memory baseUri) public onlyOwner {
1169         _setBaseURI(baseUri);
1170     }
1171 
1172     /**
1173       @dev create a new NFT token.
1174       @param maxSupply max supply allow
1175      */
1176     function create(uint256 tokenId, uint256 maxSupply, string memory uri, bytes calldata data) external {
1177         if (onlyWhitelist) {
1178             require(whitelist[msg.sender], "Open to only whitelist.");
1179         }
1180         tokenQuantityWithId[tokenId] = 0;
1181         tokenMaxQuantityWithId[tokenId] = maxSupply;
1182         tokenIds.push(tokenId);
1183         tokenIdAmount = tokenIdAmount.add(1);
1184         _setTokenURI(tokenId, uri);
1185         creators[tokenId] = msg.sender;
1186         mintManuallyQuantityWithId[tokenId] = maxSupply;
1187         emit Create(maxSupply, tokenId, uri, data);
1188     }
1189 
1190     function mint(uint256 tokenId, address to, uint256 quantity, bytes memory data) public {
1191         require(creators[tokenId] == msg.sender || minters[tokenId][msg.sender], "You are not the creator or minter of this NFT.");
1192         require(_isTokenIdExist(tokenId), "Token is is not exist.");
1193         require(tokenMaxQuantityWithId[tokenId] >= tokenQuantityWithId[tokenId] + quantity, "NFT quantity is greater than max supply.");
1194         if (!address(msg.sender).isContract()) {
1195             require(mintManuallyQuantityWithId[tokenId] >= quantity, "You mint too many cards manually" );
1196             mintManuallyQuantityWithId[tokenId] = mintManuallyQuantityWithId[tokenId].sub(quantity);
1197         }
1198         _mint(to, tokenId, quantity, data);
1199         tokenQuantityWithId[tokenId] = tokenQuantityWithId[tokenId].add(quantity);
1200         emit Mint(tokenId, to, quantity, data, tokenMaxQuantityWithId[tokenId], tokenQuantityWithId[tokenId]);
1201     }
1202 
1203     function uri(uint256 id) public view returns(string memory) {
1204         return _tokenURI(id);
1205     }
1206 
1207     function _isTokenIdExist(uint256 tokenId) private view returns(bool) {
1208         return creators[tokenId] != address(0);
1209     }
1210 
1211     function addMintManuallyQuantity(uint256 tokenId, uint256 amount) public {
1212         require(creators[tokenId] == msg.sender || minters[tokenId][msg.sender], "You are not the creator or minter of this NFT.");
1213         mintManuallyQuantityWithId[tokenId] = mintManuallyQuantityWithId[tokenId].add(amount);
1214     }
1215 
1216     function removeMintManuallyQuantity(uint256 tokenId, uint256 amount) public {
1217         require(creators[tokenId] == msg.sender || minters[tokenId][msg.sender], "You are not the creator or minter of this NFT.");
1218         mintManuallyQuantityWithId[tokenId] = mintManuallyQuantityWithId[tokenId].sub(amount);
1219     }
1220 
1221     function addToWhitelist(address account) public onlyOwner {
1222         whitelist[account] = true;
1223     }
1224 
1225     function removeFromWhitelist(address account) public onlyOwner {
1226         whitelist[account] = false;
1227     }
1228 
1229     function openToEveryone() public onlyOwner {
1230         onlyWhitelist = false;
1231     }
1232 
1233     function openOnlyToWhitelist() public onlyOwner {
1234         onlyWhitelist = true;
1235     }
1236 
1237     function addMinter(uint256 id, address account) public onlyCreator(id) {
1238         minters[id][account] = true;
1239     }
1240 
1241     function removeMinter(uint256 id, address account) public onlyCreator(id) {
1242         minters[id][account] = false;
1243     }
1244 
1245     function transferCreator(uint256 id, address account) public onlyCreator(id) {
1246         creators[id] = account;
1247     }
1248 
1249     modifier onlyCreator(uint256 id) {
1250         require(msg.sender == creators[id], "only for creator of this NFT.");
1251         _;
1252     }
1253 }