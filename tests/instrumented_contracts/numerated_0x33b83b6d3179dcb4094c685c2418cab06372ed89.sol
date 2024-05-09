1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-01
3 */
4 
5 // File: @openzeppelin/contracts/introspection/IERC165.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity >=0.6.0 <0.8.0;
10 
11 /**
12  * @dev Interface of the ERC165 standard, as defined in the
13  * https://eips.ethereum.org/EIPS/eip-165[EIP].
14  *
15  * Implementers can declare support of contract interfaces, which can then be
16  * queried by others ({ERC165Checker}).
17  *
18  * For an implementation, see {ERC165}.
19  */
20 interface IERC165 {
21     /**
22      * @dev Returns true if this contract implements the interface defined by
23      * `interfaceId`. See the corresponding
24      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
25      * to learn more about how these ids are created.
26      *
27      * This function call must use less than 30 000 gas.
28      */
29     function supportsInterface(bytes4 interfaceId) external view returns (bool);
30 }
31 
32 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
33 
34 
35 pragma solidity >=0.6.2 <0.8.0;
36 
37 
38 /**
39  * @dev Required interface of an ERC1155 compliant contract, as defined in the
40  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
41  *
42  * _Available since v3.1._
43  */
44 interface IERC1155 is IERC165 {
45     /**
46      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
47      */
48     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
49 
50     /**
51      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
52      * transfers.
53      */
54     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
55 
56     /**
57      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
58      * `approved`.
59      */
60     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
61 
62     /**
63      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
64      *
65      * If an {URI} event was emitted for `id`, the standard
66      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
67      * returned by {IERC1155MetadataURI-uri}.
68      */
69     event URI(string value, uint256 indexed id);
70 
71     /**
72      * @dev Returns the amount of tokens of token type `id` owned by `account`.
73      *
74      * Requirements:
75      *
76      * - `account` cannot be the zero address.
77      */
78     function balanceOf(address account, uint256 id) external view returns (uint256);
79 
80     /**
81      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
82      *
83      * Requirements:
84      *
85      * - `accounts` and `ids` must have the same length.
86      */
87     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
88 
89     /**
90      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
91      *
92      * Emits an {ApprovalForAll} event.
93      *
94      * Requirements:
95      *
96      * - `operator` cannot be the caller.
97      */
98     function setApprovalForAll(address operator, bool approved) external;
99 
100     /**
101      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
102      *
103      * See {setApprovalForAll}.
104      */
105     function isApprovedForAll(address account, address operator) external view returns (bool);
106 
107     /**
108      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
109      *
110      * Emits a {TransferSingle} event.
111      *
112      * Requirements:
113      *
114      * - `to` cannot be the zero address.
115      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
116      * - `from` must have a balance of tokens of type `id` of at least `amount`.
117      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
118      * acceptance magic value.
119      */
120     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
121 
122     /**
123      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
124      *
125      * Emits a {TransferBatch} event.
126      *
127      * Requirements:
128      *
129      * - `ids` and `amounts` must have the same length.
130      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
131      * acceptance magic value.
132      */
133     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
134 }
135 
136 // File: @openzeppelin/contracts/token/ERC1155/IERC1155MetadataURI.sol
137 
138 
139 pragma solidity >=0.6.2 <0.8.0;
140 
141 
142 /**
143  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
144  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
145  *
146  * _Available since v3.1._
147  */
148 interface IERC1155MetadataURI is IERC1155 {
149     /**
150      * @dev Returns the URI for token type `id`.
151      *
152      * If the `\{id\}` substring is present in the URI, it must be replaced by
153      * clients with the actual token type ID.
154      */
155     function uri(uint256 id) external view returns (string memory);
156 }
157 
158 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
159 
160 
161 pragma solidity >=0.6.0 <0.8.0;
162 
163 
164 /**
165  * _Available since v3.1._
166  */
167 interface IERC1155Receiver is IERC165 {
168 
169     /**
170         @dev Handles the receipt of a single ERC1155 token type. This function is
171         called at the end of a `safeTransferFrom` after the balance has been updated.
172         To accept the transfer, this must return
173         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
174         (i.e. 0xf23a6e61, or its own function selector).
175         @param operator The address which initiated the transfer (i.e. msg.sender)
176         @param from The address which previously owned the token
177         @param id The ID of the token being transferred
178         @param value The amount of tokens being transferred
179         @param data Additional data with no specified format
180         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
181     */
182     function onERC1155Received(
183         address operator,
184         address from,
185         uint256 id,
186         uint256 value,
187         bytes calldata data
188     )
189         external
190         returns(bytes4);
191 
192     /**
193         @dev Handles the receipt of a multiple ERC1155 token types. This function
194         is called at the end of a `safeBatchTransferFrom` after the balances have
195         been updated. To accept the transfer(s), this must return
196         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
197         (i.e. 0xbc197c81, or its own function selector).
198         @param operator The address which initiated the batch transfer (i.e. msg.sender)
199         @param from The address which previously owned the token
200         @param ids An array containing ids of each token being transferred (order and length must match values array)
201         @param values An array containing amounts of each token being transferred (order and length must match ids array)
202         @param data Additional data with no specified format
203         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
204     */
205     function onERC1155BatchReceived(
206         address operator,
207         address from,
208         uint256[] calldata ids,
209         uint256[] calldata values,
210         bytes calldata data
211     )
212         external
213         returns(bytes4);
214 }
215 
216 // File: @openzeppelin/contracts/GSN/Context.sol
217 
218 
219 pragma solidity >=0.6.0 <0.8.0;
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
242 // File: @openzeppelin/contracts/introspection/ERC165.sol
243 
244 
245 pragma solidity >=0.6.0 <0.8.0;
246 
247 
248 /**
249  * @dev Implementation of the {IERC165} interface.
250  *
251  * Contracts may inherit from this and call {_registerInterface} to declare
252  * their support of an interface.
253  */
254 abstract contract ERC165 is IERC165 {
255     /*
256      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
257      */
258     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
259 
260     /**
261      * @dev Mapping of interface ids to whether or not it's supported.
262      */
263     mapping(bytes4 => bool) private _supportedInterfaces;
264 
265     constructor () internal {
266         // Derived contracts need only register support for their own interfaces,
267         // we register support for ERC165 itself here
268         _registerInterface(_INTERFACE_ID_ERC165);
269     }
270 
271     /**
272      * @dev See {IERC165-supportsInterface}.
273      *
274      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
275      */
276     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
277         return _supportedInterfaces[interfaceId];
278     }
279 
280     /**
281      * @dev Registers the contract as an implementer of the interface defined by
282      * `interfaceId`. Support of the actual ERC165 interface is automatic and
283      * registering its interface id is not required.
284      *
285      * See {IERC165-supportsInterface}.
286      *
287      * Requirements:
288      *
289      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
290      */
291     function _registerInterface(bytes4 interfaceId) internal virtual {
292         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
293         _supportedInterfaces[interfaceId] = true;
294     }
295 }
296 
297 // File: @openzeppelin/contracts/math/SafeMath.sol
298 
299 
300 pragma solidity >=0.6.0 <0.8.0;
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
460 
461 pragma solidity >=0.6.2 <0.8.0;
462 
463 /**
464  * @dev Collection of functions related to the address type
465  */
466 library Address {
467     /**
468      * @dev Returns true if `account` is a contract.
469      *
470      * [IMPORTANT]
471      * ====
472      * It is unsafe to assume that an address for which this function returns
473      * false is an externally-owned account (EOA) and not a contract.
474      *
475      * Among others, `isContract` will return false for the following
476      * types of addresses:
477      *
478      *  - an externally-owned account
479      *  - a contract in construction
480      *  - an address where a contract will be created
481      *  - an address where a contract lived, but was destroyed
482      * ====
483      */
484     function isContract(address account) internal view returns (bool) {
485         // This method relies on extcodesize, which returns 0 for contracts in
486         // construction, since the code is only stored at the end of the
487         // constructor execution.
488 
489         uint256 size;
490         // solhint-disable-next-line no-inline-assembly
491         assembly { size := extcodesize(account) }
492         return size > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
515         (bool success, ) = recipient.call{ value: amount }("");
516         require(success, "Address: unable to send value, recipient may have reverted");
517     }
518 
519     /**
520      * @dev Performs a Solidity function call using a low level `call`. A
521      * plain`call` is an unsafe replacement for a function call: use this
522      * function instead.
523      *
524      * If `target` reverts with a revert reason, it is bubbled up by this
525      * function (like regular Solidity function calls).
526      *
527      * Returns the raw returned data. To convert to the expected return value,
528      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
529      *
530      * Requirements:
531      *
532      * - `target` must be a contract.
533      * - calling `target` with `data` must not revert.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
538       return functionCall(target, data, "Address: low-level call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
543      * `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
548         return functionCallWithValue(target, data, 0, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but also transferring `value` wei to `target`.
554      *
555      * Requirements:
556      *
557      * - the calling contract must have an ETH balance of at least `value`.
558      * - the called Solidity function must be `payable`.
559      *
560      * _Available since v3.1._
561      */
562     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
563         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
568      * with `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
573         require(address(this).balance >= value, "Address: insufficient balance for call");
574         require(isContract(target), "Address: call to non-contract");
575 
576         // solhint-disable-next-line avoid-low-level-calls
577         (bool success, bytes memory returndata) = target.call{ value: value }(data);
578         return _verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
598         require(isContract(target), "Address: static call to non-contract");
599 
600         // solhint-disable-next-line avoid-low-level-calls
601         (bool success, bytes memory returndata) = target.staticcall(data);
602         return _verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 // solhint-disable-next-line no-inline-assembly
614                 assembly {
615                     let returndata_size := mload(returndata)
616                     revert(add(32, returndata), returndata_size)
617                 }
618             } else {
619                 revert(errorMessage);
620             }
621         }
622     }
623 }
624 
625 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
626 
627 
628 pragma solidity >=0.6.0 <0.8.0;
629 
630 
631 
632 
633 
634 
635 
636 
637 /**
638  *
639  * @dev Implementation of the basic standard multi-token.
640  * See https://eips.ethereum.org/EIPS/eip-1155
641  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
642  *
643  * _Available since v3.1._
644  */
645 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
646     using SafeMath for uint256;
647     using Address for address;
648 
649     // Mapping from token ID to account balances
650     mapping (uint256 => mapping(address => uint256)) private _balances;
651 
652     // Mapping from account to operator approvals
653     mapping (address => mapping(address => bool)) private _operatorApprovals;
654 
655     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
656     string private _uri;
657 
658     /*
659      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
660      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
661      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
662      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
663      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
664      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
665      *
666      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
667      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
668      */
669     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
670 
671     /*
672      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
673      */
674     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
675 
676     /**
677      * @dev See {_setURI}.
678      */
679     constructor (string memory uri_) public {
680         _setURI(uri_);
681 
682         // register the supported interfaces to conform to ERC1155 via ERC165
683         _registerInterface(_INTERFACE_ID_ERC1155);
684 
685         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
686         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
687     }
688 
689     /**
690      * @dev See {IERC1155MetadataURI-uri}.
691      *
692      * This implementation returns the same URI for *all* token types. It relies
693      * on the token type ID substitution mechanism
694      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
695      *
696      * Clients calling this function must replace the `\{id\}` substring with the
697      * actual token type ID.
698      */
699     function uri(uint256) external view virtual override returns (string memory) {
700         return _uri;
701     }
702 
703     /**
704      * @dev See {IERC1155-balanceOf}.
705      *
706      * Requirements:
707      *
708      * - `account` cannot be the zero address.
709      */
710     function balanceOf(address account, uint256 id) public view override returns (uint256) {
711         require(account != address(0), "ERC1155: balance query for the zero address");
712         return _balances[id][account];
713     }
714 
715     /**
716      * @dev See {IERC1155-balanceOfBatch}.
717      *
718      * Requirements:
719      *
720      * - `accounts` and `ids` must have the same length.
721      */
722     function balanceOfBatch(
723         address[] memory accounts,
724         uint256[] memory ids
725     )
726         public
727         view
728         override
729         returns (uint256[] memory)
730     {
731         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
732 
733         uint256[] memory batchBalances = new uint256[](accounts.length);
734 
735         for (uint256 i = 0; i < accounts.length; ++i) {
736             require(accounts[i] != address(0), "ERC1155: batch balance query for the zero address");
737             batchBalances[i] = _balances[ids[i]][accounts[i]];
738         }
739 
740         return batchBalances;
741     }
742 
743     /**
744      * @dev See {IERC1155-setApprovalForAll}.
745      */
746     function setApprovalForAll(address operator, bool approved) public virtual override {
747         require(_msgSender() != operator, "ERC1155: setting approval status for self");
748 
749         _operatorApprovals[_msgSender()][operator] = approved;
750         emit ApprovalForAll(_msgSender(), operator, approved);
751     }
752 
753     /**
754      * @dev See {IERC1155-isApprovedForAll}.
755      */
756     function isApprovedForAll(address account, address operator) public view override returns (bool) {
757         return _operatorApprovals[account][operator];
758     }
759 
760     /**
761      * @dev See {IERC1155-safeTransferFrom}.
762      */
763     function safeTransferFrom(
764         address from,
765         address to,
766         uint256 id,
767         uint256 amount,
768         bytes memory data
769     )
770         public
771         virtual
772         override
773     {
774         require(to != address(0), "ERC1155: transfer to the zero address");
775         require(
776             from == _msgSender() || isApprovedForAll(from, _msgSender()),
777             "ERC1155: caller is not owner nor approved"
778         );
779 
780         address operator = _msgSender();
781 
782         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
783 
784         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
785         _balances[id][to] = _balances[id][to].add(amount);
786 
787         emit TransferSingle(operator, from, to, id, amount);
788 
789         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
790     }
791 
792     /**
793      * @dev See {IERC1155-safeBatchTransferFrom}.
794      */
795     function safeBatchTransferFrom(
796         address from,
797         address to,
798         uint256[] memory ids,
799         uint256[] memory amounts,
800         bytes memory data
801     )
802         public
803         virtual
804         override
805     {
806         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
807         require(to != address(0), "ERC1155: transfer to the zero address");
808         require(
809             from == _msgSender() || isApprovedForAll(from, _msgSender()),
810             "ERC1155: transfer caller is not owner nor approved"
811         );
812 
813         address operator = _msgSender();
814 
815         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
816 
817         for (uint256 i = 0; i < ids.length; ++i) {
818             uint256 id = ids[i];
819             uint256 amount = amounts[i];
820 
821             _balances[id][from] = _balances[id][from].sub(
822                 amount,
823                 "ERC1155: insufficient balance for transfer"
824             );
825             _balances[id][to] = _balances[id][to].add(amount);
826         }
827 
828         emit TransferBatch(operator, from, to, ids, amounts);
829 
830         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
831     }
832 
833     /**
834      * @dev Sets a new URI for all token types, by relying on the token type ID
835      * substitution mechanism
836      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
837      *
838      * By this mechanism, any occurrence of the `\{id\}` substring in either the
839      * URI or any of the amounts in the JSON file at said URI will be replaced by
840      * clients with the token type ID.
841      *
842      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
843      * interpreted by clients as
844      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
845      * for token type ID 0x4cce0.
846      *
847      * See {uri}.
848      *
849      * Because these URIs cannot be meaningfully represented by the {URI} event,
850      * this function emits no events.
851      */
852     function _setURI(string memory newuri) internal virtual {
853         _uri = newuri;
854     }
855 
856     /**
857      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
858      *
859      * Emits a {TransferSingle} event.
860      *
861      * Requirements:
862      *
863      * - `account` cannot be the zero address.
864      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
865      * acceptance magic value.
866      */
867     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
868         require(account != address(0), "ERC1155: mint to the zero address");
869 
870         address operator = _msgSender();
871 
872         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
873 
874         _balances[id][account] = _balances[id][account].add(amount);
875         emit TransferSingle(operator, address(0), account, id, amount);
876 
877         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
878     }
879 
880     /**
881      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
882      *
883      * Requirements:
884      *
885      * - `ids` and `amounts` must have the same length.
886      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
887      * acceptance magic value.
888      */
889     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
890         require(to != address(0), "ERC1155: mint to the zero address");
891         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
892 
893         address operator = _msgSender();
894 
895         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
896 
897         for (uint i = 0; i < ids.length; i++) {
898             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
899         }
900 
901         emit TransferBatch(operator, address(0), to, ids, amounts);
902 
903         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
904     }
905 
906     /**
907      * @dev Destroys `amount` tokens of token type `id` from `account`
908      *
909      * Requirements:
910      *
911      * - `account` cannot be the zero address.
912      * - `account` must have at least `amount` tokens of token type `id`.
913      */
914     function _burn(address account, uint256 id, uint256 amount) internal virtual {
915         require(account != address(0), "ERC1155: burn from the zero address");
916 
917         address operator = _msgSender();
918 
919         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
920 
921         _balances[id][account] = _balances[id][account].sub(
922             amount,
923             "ERC1155: burn amount exceeds balance"
924         );
925 
926         emit TransferSingle(operator, account, address(0), id, amount);
927     }
928 
929     /**
930      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
931      *
932      * Requirements:
933      *
934      * - `ids` and `amounts` must have the same length.
935      */
936     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
937         require(account != address(0), "ERC1155: burn from the zero address");
938         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
939 
940         address operator = _msgSender();
941 
942         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
943 
944         for (uint i = 0; i < ids.length; i++) {
945             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
946                 amounts[i],
947                 "ERC1155: burn amount exceeds balance"
948             );
949         }
950 
951         emit TransferBatch(operator, account, address(0), ids, amounts);
952     }
953 
954     /**
955      * @dev Hook that is called before any token transfer. This includes minting
956      * and burning, as well as batched variants.
957      *
958      * The same hook is called on both single and batched variants. For single
959      * transfers, the length of the `id` and `amount` arrays will be 1.
960      *
961      * Calling conditions (for each `id` and `amount` pair):
962      *
963      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
964      * of token type `id` will be  transferred to `to`.
965      * - When `from` is zero, `amount` tokens of token type `id` will be minted
966      * for `to`.
967      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
968      * will be burned.
969      * - `from` and `to` are never both zero.
970      * - `ids` and `amounts` have the same, non-zero length.
971      *
972      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
973      */
974     function _beforeTokenTransfer(
975         address operator,
976         address from,
977         address to,
978         uint256[] memory ids,
979         uint256[] memory amounts,
980         bytes memory data
981     )
982         internal virtual
983     { }
984 
985     function _doSafeTransferAcceptanceCheck(
986         address operator,
987         address from,
988         address to,
989         uint256 id,
990         uint256 amount,
991         bytes memory data
992     )
993         private
994     {
995         if (to.isContract()) {
996             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
997                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
998                     revert("ERC1155: ERC1155Receiver rejected tokens");
999                 }
1000             } catch Error(string memory reason) {
1001                 revert(reason);
1002             } catch {
1003                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1004             }
1005         }
1006     }
1007 
1008     function _doSafeBatchTransferAcceptanceCheck(
1009         address operator,
1010         address from,
1011         address to,
1012         uint256[] memory ids,
1013         uint256[] memory amounts,
1014         bytes memory data
1015     )
1016         private
1017     {
1018         if (to.isContract()) {
1019             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1020                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1021                     revert("ERC1155: ERC1155Receiver rejected tokens");
1022                 }
1023             } catch Error(string memory reason) {
1024                 revert(reason);
1025             } catch {
1026                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1027             }
1028         }
1029     }
1030 
1031     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1032         uint256[] memory array = new uint256[](1);
1033         array[0] = element;
1034 
1035         return array;
1036     }
1037 }
1038 
1039 // File: @openzeppelin/contracts/access/Ownable.sol
1040 
1041 
1042 pragma solidity >=0.6.0 <0.8.0;
1043 
1044 /**
1045  * @dev Contract module which provides a basic access control mechanism, where
1046  * there is an account (an owner) that can be granted exclusive access to
1047  * specific functions.
1048  *
1049  * By default, the owner account will be the one that deploys the contract. This
1050  * can later be changed with {transferOwnership}.
1051  *
1052  * This module is used through inheritance. It will make available the modifier
1053  * `onlyOwner`, which can be applied to your functions to restrict their use to
1054  * the owner.
1055  */
1056 abstract contract Ownable is Context {
1057     address private _owner;
1058 
1059     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1060 
1061     /**
1062      * @dev Initializes the contract setting the deployer as the initial owner.
1063      */
1064     constructor () internal {
1065         address msgSender = _msgSender();
1066         _owner = msgSender;
1067         emit OwnershipTransferred(address(0), msgSender);
1068     }
1069 
1070     /**
1071      * @dev Returns the address of the current owner.
1072      */
1073     function owner() public view returns (address) {
1074         return _owner;
1075     }
1076 
1077     /**
1078      * @dev Throws if called by any account other than the owner.
1079      */
1080     modifier onlyOwner() {
1081         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1082         _;
1083     }
1084 
1085     /**
1086      * @dev Leaves the contract without owner. It will not be possible to call
1087      * `onlyOwner` functions anymore. Can only be called by the current owner.
1088      *
1089      * NOTE: Renouncing ownership will leave the contract without an owner,
1090      * thereby removing any functionality that is only available to the owner.
1091      */
1092     function renounceOwnership() public virtual onlyOwner {
1093         emit OwnershipTransferred(_owner, address(0));
1094         _owner = address(0);
1095     }
1096 
1097     /**
1098      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1099      * Can only be called by the current owner.
1100      */
1101     function transferOwnership(address newOwner) public virtual onlyOwner {
1102         require(newOwner != address(0), "Ownable: new owner is the zero address");
1103         emit OwnershipTransferred(_owner, newOwner);
1104         _owner = newOwner;
1105     }
1106 }
1107 
1108 // File: contracts/contract.sol
1109 
1110 pragma solidity ^0.6.0;
1111 
1112 
1113 interface EthMenLegacy {
1114     function burn(address _owner, uint256 _id, uint256 _value) external;
1115     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
1116 }
1117 
1118 
1119 contract EthMen is ERC1155, Ownable {
1120     
1121     string public name;
1122     string public symbol;
1123     uint256 private highestId;
1124     
1125     
1126     //mappings
1127     mapping(uint256 => string) private metadata;
1128     mapping(uint256 => uint256) private idSupply;
1129     
1130     constructor(string memory _symbol, string memory _name) public ERC1155("") {
1131         name = _name;
1132         symbol = _symbol;
1133         highestId = 0;
1134 
1135     }
1136     
1137     function mint(address account, uint256 id, uint256 amount, string memory _metadata) public onlyOwner {
1138         _customMint(account, id, amount);
1139         bytes memory bytesData = bytes(_metadata);
1140         if (bytesData.length != 0) metadata[id] = _metadata;
1141     }
1142     
1143     
1144     function _customMint(address account, uint256 id, uint256 amount) private {
1145         require(account == _msgSender() || isApprovedForAll(account, _msgSender()), "Need operator approval for 3rd party burns.");
1146         _mint(account, id, amount, "");
1147         if (id > highestId) { highestId = id;}
1148         idSupply[id]+=amount;
1149     }
1150     
1151     function burn(address account, uint256 id, uint256 amount) public {
1152         require(account == _msgSender() || isApprovedForAll(account, _msgSender()), "Need operator approval for 3rd party burns.");
1153         _burn(account, id, amount);
1154         idSupply[id]-=amount;
1155     }
1156     
1157     function migrate(address account, uint256 id, uint256 amount) public {
1158         require(account == _msgSender() || isApprovedForAll(account, _msgSender()), "Need operator approval for 3rd party burns.");
1159         EthMenLegacy ethMenLegacy = EthMenLegacy(0x1DD2c47496fBD9D38Ac9A884d15D816B062E1F6E);
1160         require(id % 2 == 0 && id != 0, "Not a Front Card provided");
1161         require(ethMenLegacy.balanceOf(account,id) >= amount, "Not enough Front Cards");
1162         require(ethMenLegacy.balanceOf(account,id+1) >= amount, "Not enough Back Cards");
1163         
1164         ethMenLegacy.burn(account, id, amount);
1165         ethMenLegacy.burn(account, id+1, amount);
1166         
1167         if (id == 2) _customMint(account,1,amount);
1168         else if (id == 4) _customMint(account,2,amount);
1169         else if (id == 6) _customMint(account,3,amount);
1170         else if (id == 8) _customMint(account,4,amount);
1171         else if (id == 10) _customMint(account,5,amount);
1172         else if (id == 12) _customMint(account,6,amount);
1173         else if (id == 24) _customMint(account,7,amount);
1174 
1175     }
1176     
1177     function setTokenUri(uint256 id, string memory _metadata) public onlyOwner {
1178         require(id >= 0, "Id needs be 0 or greater");
1179         metadata[id] = _metadata;
1180     }
1181     
1182     function totalSupply(uint256 id) public view returns(uint256 total_supply) {
1183         return idSupply[id];
1184     }
1185     
1186     
1187     function totalBalance(address _owner) public view returns(uint256) {
1188         uint256 count = 0;
1189         for (uint256 id = 0; id <= highestId; id++) {
1190             if (balanceOf(_owner, id) > 0) count++;
1191         }
1192         return count; 
1193     }
1194     
1195     function tokenTypesOf(address _owner) public view returns(uint256[] memory ids) {
1196         uint256[] memory result = new uint256[](totalBalance(_owner));
1197         uint256 c = 0;
1198         for (uint256 id = 0; id <= highestId; id++) {
1199             if (balanceOf(_owner, id) > 0) {result[c] = id;c++;}
1200         }
1201         return result;
1202     }
1203     
1204     function totalTokenTypes() public view returns(uint256) {
1205         uint256 count = 0;
1206         for (uint256 id = 0; id <= highestId; id++) {
1207             if (totalSupply(id) > 0) count++;
1208         }
1209         return count; 
1210     }
1211     
1212     function uri(uint256 id) public view override returns(string memory) {
1213         return metadata[id];
1214       }
1215     
1216 
1217 }