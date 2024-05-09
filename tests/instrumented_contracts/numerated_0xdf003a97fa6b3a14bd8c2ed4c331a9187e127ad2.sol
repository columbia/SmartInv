1 // Dependency file: @openzeppelin/contracts/introspection/IERC165.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
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
28 
29 // Dependency file: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
30 
31 
32 // pragma solidity ^0.6.2;
33 
34 // import "@openzeppelin/contracts/introspection/IERC165.sol";
35 
36 /**
37  * @dev Required interface of an ERC1155 compliant contract, as defined in the
38  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
39  *
40  * _Available since v3.1._
41  */
42 interface IERC1155 is IERC165 {
43     /**
44      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
45      */
46     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
47 
48     /**
49      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
50      * transfers.
51      */
52     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
53 
54     /**
55      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
56      * `approved`.
57      */
58     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
59 
60     /**
61      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
62      *
63      * If an {URI} event was emitted for `id`, the standard
64      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
65      * returned by {IERC1155MetadataURI-uri}.
66      */
67     event URI(string value, uint256 indexed id);
68 
69     /**
70      * @dev Returns the amount of tokens of token type `id` owned by `account`.
71      *
72      * Requirements:
73      *
74      * - `account` cannot be the zero address.
75      */
76     function balanceOf(address account, uint256 id) external view returns (uint256);
77 
78     /**
79      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
80      *
81      * Requirements:
82      *
83      * - `accounts` and `ids` must have the same length.
84      */
85     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
86 
87     /**
88      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
89      *
90      * Emits an {ApprovalForAll} event.
91      *
92      * Requirements:
93      *
94      * - `operator` cannot be the caller.
95      */
96     function setApprovalForAll(address operator, bool approved) external;
97 
98     /**
99      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
100      *
101      * See {setApprovalForAll}.
102      */
103     function isApprovedForAll(address account, address operator) external view returns (bool);
104 
105     /**
106      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
107      *
108      * Emits a {TransferSingle} event.
109      *
110      * Requirements:
111      *
112      * - `to` cannot be the zero address.
113      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
114      * - `from` must have a balance of tokens of type `id` of at least `amount`.
115      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
116      * acceptance magic value.
117      */
118     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
119 
120     /**
121      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
122      *
123      * Emits a {TransferBatch} event.
124      *
125      * Requirements:
126      *
127      * - `ids` and `amounts` must have the same length.
128      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
129      * acceptance magic value.
130      */
131     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
132 }
133 
134 
135 // Dependency file: @openzeppelin/contracts/token/ERC1155/IERC1155MetadataURI.sol
136 
137 
138 // pragma solidity ^0.6.2;
139 
140 // import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
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
158 
159 // Dependency file: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
160 
161 
162 // pragma solidity ^0.6.0;
163 
164 // import "@openzeppelin/contracts/introspection/IERC165.sol";
165 
166 /**
167  * _Available since v3.1._
168  */
169 interface IERC1155Receiver is IERC165 {
170 
171     /**
172         @dev Handles the receipt of a single ERC1155 token type. This function is
173         called at the end of a `safeTransferFrom` after the balance has been updated.
174         To accept the transfer, this must return
175         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
176         (i.e. 0xf23a6e61, or its own function selector).
177         @param operator The address which initiated the transfer (i.e. msg.sender)
178         @param from The address which previously owned the token
179         @param id The ID of the token being transferred
180         @param value The amount of tokens being transferred
181         @param data Additional data with no specified format
182         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
183     */
184     function onERC1155Received(
185         address operator,
186         address from,
187         uint256 id,
188         uint256 value,
189         bytes calldata data
190     )
191         external
192         returns(bytes4);
193 
194     /**
195         @dev Handles the receipt of a multiple ERC1155 token types. This function
196         is called at the end of a `safeBatchTransferFrom` after the balances have
197         been updated. To accept the transfer(s), this must return
198         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
199         (i.e. 0xbc197c81, or its own function selector).
200         @param operator The address which initiated the batch transfer (i.e. msg.sender)
201         @param from The address which previously owned the token
202         @param ids An array containing ids of each token being transferred (order and length must match values array)
203         @param values An array containing amounts of each token being transferred (order and length must match ids array)
204         @param data Additional data with no specified format
205         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
206     */
207     function onERC1155BatchReceived(
208         address operator,
209         address from,
210         uint256[] calldata ids,
211         uint256[] calldata values,
212         bytes calldata data
213     )
214         external
215         returns(bytes4);
216 }
217 
218 
219 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
220 
221 
222 // pragma solidity ^0.6.0;
223 
224 /*
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with GSN meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address payable) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes memory) {
240         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
241         return msg.data;
242     }
243 }
244 
245 
246 // Dependency file: @openzeppelin/contracts/introspection/ERC165.sol
247 
248 
249 // pragma solidity ^0.6.0;
250 
251 // import "@openzeppelin/contracts/introspection/IERC165.sol";
252 
253 /**
254  * @dev Implementation of the {IERC165} interface.
255  *
256  * Contracts may inherit from this and call {_registerInterface} to declare
257  * their support of an interface.
258  */
259 contract ERC165 is IERC165 {
260     /*
261      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
262      */
263     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
264 
265     /**
266      * @dev Mapping of interface ids to whether or not it's supported.
267      */
268     mapping(bytes4 => bool) private _supportedInterfaces;
269 
270     constructor () internal {
271         // Derived contracts need only register support for their own interfaces,
272         // we register support for ERC165 itself here
273         _registerInterface(_INTERFACE_ID_ERC165);
274     }
275 
276     /**
277      * @dev See {IERC165-supportsInterface}.
278      *
279      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
280      */
281     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
282         return _supportedInterfaces[interfaceId];
283     }
284 
285     /**
286      * @dev Registers the contract as an implementer of the interface defined by
287      * `interfaceId`. Support of the actual ERC165 interface is automatic and
288      * registering its interface id is not required.
289      *
290      * See {IERC165-supportsInterface}.
291      *
292      * Requirements:
293      *
294      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
295      */
296     function _registerInterface(bytes4 interfaceId) internal virtual {
297         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
298         _supportedInterfaces[interfaceId] = true;
299     }
300 }
301 
302 
303 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
304 
305 
306 // pragma solidity ^0.6.0;
307 
308 /**
309  * @dev Wrappers over Solidity's arithmetic operations with added overflow
310  * checks.
311  *
312  * Arithmetic operations in Solidity wrap on overflow. This can easily result
313  * in bugs, because programmers usually assume that an overflow raises an
314  * error, which is the standard behavior in high level programming languages.
315  * `SafeMath` restores this intuition by reverting the transaction when an
316  * operation overflows.
317  *
318  * Using this library instead of the unchecked operations eliminates an entire
319  * class of bugs, so it's recommended to use it always.
320  */
321 library SafeMath {
322     /**
323      * @dev Returns the addition of two unsigned integers, reverting on
324      * overflow.
325      *
326      * Counterpart to Solidity's `+` operator.
327      *
328      * Requirements:
329      *
330      * - Addition cannot overflow.
331      */
332     function add(uint256 a, uint256 b) internal pure returns (uint256) {
333         uint256 c = a + b;
334         require(c >= a, "SafeMath: addition overflow");
335 
336         return c;
337     }
338 
339     /**
340      * @dev Returns the subtraction of two unsigned integers, reverting on
341      * overflow (when the result is negative).
342      *
343      * Counterpart to Solidity's `-` operator.
344      *
345      * Requirements:
346      *
347      * - Subtraction cannot overflow.
348      */
349     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
350         return sub(a, b, "SafeMath: subtraction overflow");
351     }
352 
353     /**
354      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
355      * overflow (when the result is negative).
356      *
357      * Counterpart to Solidity's `-` operator.
358      *
359      * Requirements:
360      *
361      * - Subtraction cannot overflow.
362      */
363     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
364         require(b <= a, errorMessage);
365         uint256 c = a - b;
366 
367         return c;
368     }
369 
370     /**
371      * @dev Returns the multiplication of two unsigned integers, reverting on
372      * overflow.
373      *
374      * Counterpart to Solidity's `*` operator.
375      *
376      * Requirements:
377      *
378      * - Multiplication cannot overflow.
379      */
380     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
382         // benefit is lost if 'b' is also tested.
383         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
384         if (a == 0) {
385             return 0;
386         }
387 
388         uint256 c = a * b;
389         require(c / a == b, "SafeMath: multiplication overflow");
390 
391         return c;
392     }
393 
394     /**
395      * @dev Returns the integer division of two unsigned integers. Reverts on
396      * division by zero. The result is rounded towards zero.
397      *
398      * Counterpart to Solidity's `/` operator. Note: this function uses a
399      * `revert` opcode (which leaves remaining gas untouched) while Solidity
400      * uses an invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function div(uint256 a, uint256 b) internal pure returns (uint256) {
407         return div(a, b, "SafeMath: division by zero");
408     }
409 
410     /**
411      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
412      * division by zero. The result is rounded towards zero.
413      *
414      * Counterpart to Solidity's `/` operator. Note: this function uses a
415      * `revert` opcode (which leaves remaining gas untouched) while Solidity
416      * uses an invalid opcode to revert (consuming all remaining gas).
417      *
418      * Requirements:
419      *
420      * - The divisor cannot be zero.
421      */
422     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
423         require(b > 0, errorMessage);
424         uint256 c = a / b;
425         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
426 
427         return c;
428     }
429 
430     /**
431      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
432      * Reverts when dividing by zero.
433      *
434      * Counterpart to Solidity's `%` operator. This function uses a `revert`
435      * opcode (which leaves remaining gas untouched) while Solidity uses an
436      * invalid opcode to revert (consuming all remaining gas).
437      *
438      * Requirements:
439      *
440      * - The divisor cannot be zero.
441      */
442     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
443         return mod(a, b, "SafeMath: modulo by zero");
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
448      * Reverts with custom message when dividing by zero.
449      *
450      * Counterpart to Solidity's `%` operator. This function uses a `revert`
451      * opcode (which leaves remaining gas untouched) while Solidity uses an
452      * invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
459         require(b != 0, errorMessage);
460         return a % b;
461     }
462 }
463 
464 
465 // Dependency file: @openzeppelin/contracts/utils/Address.sol
466 
467 
468 // pragma solidity ^0.6.2;
469 
470 /**
471  * @dev Collection of functions related to the address type
472  */
473 library Address {
474     /**
475      * @dev Returns true if `account` is a contract.
476      *
477      * [// importANT]
478      * ====
479      * It is unsafe to assume that an address for which this function returns
480      * false is an externally-owned account (EOA) and not a contract.
481      *
482      * Among others, `isContract` will return false for the following
483      * types of addresses:
484      *
485      *  - an externally-owned account
486      *  - a contract in construction
487      *  - an address where a contract will be created
488      *  - an address where a contract lived, but was destroyed
489      * ====
490      */
491     function isContract(address account) internal view returns (bool) {
492         // This method relies in extcodesize, which returns 0 for contracts in
493         // construction, since the code is only stored at the end of the
494         // constructor execution.
495 
496         uint256 size;
497         // solhint-disable-next-line no-inline-assembly
498         assembly { size := extcodesize(account) }
499         return size > 0;
500     }
501 
502     /**
503      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
504      * `recipient`, forwarding all available gas and reverting on errors.
505      *
506      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
507      * of certain opcodes, possibly making contracts go over the 2300 gas limit
508      * imposed by `transfer`, making them unable to receive funds via
509      * `transfer`. {sendValue} removes this limitation.
510      *
511      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
512      *
513      * // importANT: because control is transferred to `recipient`, care must be
514      * taken to not create reentrancy vulnerabilities. Consider using
515      * {ReentrancyGuard} or the
516      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
517      */
518     function sendValue(address payable recipient, uint256 amount) internal {
519         require(address(this).balance >= amount, "Address: insufficient balance");
520 
521         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
522         (bool success, ) = recipient.call{ value: amount }("");
523         require(success, "Address: unable to send value, recipient may have reverted");
524     }
525 
526     /**
527      * @dev Performs a Solidity function call using a low level `call`. A
528      * plain`call` is an unsafe replacement for a function call: use this
529      * function instead.
530      *
531      * If `target` reverts with a revert reason, it is bubbled up by this
532      * function (like regular Solidity function calls).
533      *
534      * Returns the raw returned data. To convert to the expected return value,
535      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
536      *
537      * Requirements:
538      *
539      * - `target` must be a contract.
540      * - calling `target` with `data` must not revert.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
545       return functionCall(target, data, "Address: low-level call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
550      * `errorMessage` as a fallback revert reason when `target` reverts.
551      *
552      * _Available since v3.1._
553      */
554     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
555         return _functionCallWithValue(target, data, 0, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but also transferring `value` wei to `target`.
561      *
562      * Requirements:
563      *
564      * - the calling contract must have an ETH balance of at least `value`.
565      * - the called Solidity function must be `payable`.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
570         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
575      * with `errorMessage` as a fallback revert reason when `target` reverts.
576      *
577      * _Available since v3.1._
578      */
579     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
580         require(address(this).balance >= value, "Address: insufficient balance for call");
581         return _functionCallWithValue(target, data, value, errorMessage);
582     }
583 
584     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
585         require(isContract(target), "Address: call to non-contract");
586 
587         // solhint-disable-next-line avoid-low-level-calls
588         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
589         if (success) {
590             return returndata;
591         } else {
592             // Look for revert reason and bubble it up if present
593             if (returndata.length > 0) {
594                 // The easiest way to bubble the revert reason is using memory via assembly
595 
596                 // solhint-disable-next-line no-inline-assembly
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 
609 // Dependency file: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
610 
611 
612 // pragma solidity ^0.6.0;
613 
614 // import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
615 // import "@openzeppelin/contracts/token/ERC1155/IERC1155MetadataURI.sol";
616 // import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
617 // import "@openzeppelin/contracts/GSN/Context.sol";
618 // import "@openzeppelin/contracts/introspection/ERC165.sol";
619 // import "@openzeppelin/contracts/math/SafeMath.sol";
620 // import "@openzeppelin/contracts/utils/Address.sol";
621 
622 /**
623  *
624  * @dev Implementation of the basic standard multi-token.
625  * See https://eips.ethereum.org/EIPS/eip-1155
626  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
627  *
628  * _Available since v3.1._
629  */
630 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
631     using SafeMath for uint256;
632     using Address for address;
633 
634     // Mapping from token ID to account balances
635     mapping (uint256 => mapping(address => uint256)) private _balances;
636 
637     // Mapping from account to operator approvals
638     mapping (address => mapping(address => bool)) private _operatorApprovals;
639 
640     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
641     string private _uri;
642 
643     /*
644      *     bytes4(keccak256('balanceOf(address,uint256)')) == 0x00fdd58e
645      *     bytes4(keccak256('balanceOfBatch(address[],uint256[])')) == 0x4e1273f4
646      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
647      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
648      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,uint256,bytes)')) == 0xf242432a
649      *     bytes4(keccak256('safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)')) == 0x2eb2c2d6
650      *
651      *     => 0x00fdd58e ^ 0x4e1273f4 ^ 0xa22cb465 ^
652      *        0xe985e9c5 ^ 0xf242432a ^ 0x2eb2c2d6 == 0xd9b67a26
653      */
654     bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
655 
656     /*
657      *     bytes4(keccak256('uri(uint256)')) == 0x0e89341c
658      */
659     bytes4 private constant _INTERFACE_ID_ERC1155_METADATA_URI = 0x0e89341c;
660 
661     /**
662      * @dev See {_setURI}.
663      */
664     constructor (string memory uri) public {
665         _setURI(uri);
666 
667         // register the supported interfaces to conform to ERC1155 via ERC165
668         _registerInterface(_INTERFACE_ID_ERC1155);
669 
670         // register the supported interfaces to conform to ERC1155MetadataURI via ERC165
671         _registerInterface(_INTERFACE_ID_ERC1155_METADATA_URI);
672     }
673 
674     /**
675      * @dev See {IERC1155MetadataURI-uri}.
676      *
677      * This implementation returns the same URI for *all* token types. It relies
678      * on the token type ID substitution mechanism
679      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
680      *
681      * Clients calling this function must replace the `\{id\}` substring with the
682      * actual token type ID.
683      */
684     function uri(uint256) external view override returns (string memory) {
685         return _uri;
686     }
687 
688     /**
689      * @dev See {IERC1155-balanceOf}.
690      *
691      * Requirements:
692      *
693      * - `account` cannot be the zero address.
694      */
695     function balanceOf(address account, uint256 id) public view override returns (uint256) {
696         require(account != address(0), "ERC1155: balance query for the zero address");
697         return _balances[id][account];
698     }
699 
700     /**
701      * @dev See {IERC1155-balanceOfBatch}.
702      *
703      * Requirements:
704      *
705      * - `accounts` and `ids` must have the same length.
706      */
707     function balanceOfBatch(
708         address[] memory accounts,
709         uint256[] memory ids
710     )
711         public
712         view
713         override
714         returns (uint256[] memory)
715     {
716         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
717 
718         uint256[] memory batchBalances = new uint256[](accounts.length);
719 
720         for (uint256 i = 0; i < accounts.length; ++i) {
721             require(accounts[i] != address(0), "ERC1155: batch balance query for the zero address");
722             batchBalances[i] = _balances[ids[i]][accounts[i]];
723         }
724 
725         return batchBalances;
726     }
727 
728     /**
729      * @dev See {IERC1155-setApprovalForAll}.
730      */
731     function setApprovalForAll(address operator, bool approved) public virtual override {
732         require(_msgSender() != operator, "ERC1155: setting approval status for self");
733 
734         _operatorApprovals[_msgSender()][operator] = approved;
735         emit ApprovalForAll(_msgSender(), operator, approved);
736     }
737 
738     /**
739      * @dev See {IERC1155-isApprovedForAll}.
740      */
741     function isApprovedForAll(address account, address operator) public view override returns (bool) {
742         return _operatorApprovals[account][operator];
743     }
744 
745     /**
746      * @dev See {IERC1155-safeTransferFrom}.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 id,
752         uint256 amount,
753         bytes memory data
754     )
755         public
756         virtual
757         override
758     {
759         require(to != address(0), "ERC1155: transfer to the zero address");
760         require(
761             from == _msgSender() || isApprovedForAll(from, _msgSender()),
762             "ERC1155: caller is not owner nor approved"
763         );
764 
765         address operator = _msgSender();
766 
767         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
768 
769         _balances[id][from] = _balances[id][from].sub(amount, "ERC1155: insufficient balance for transfer");
770         _balances[id][to] = _balances[id][to].add(amount);
771 
772         emit TransferSingle(operator, from, to, id, amount);
773 
774         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
775     }
776 
777     /**
778      * @dev See {IERC1155-safeBatchTransferFrom}.
779      */
780     function safeBatchTransferFrom(
781         address from,
782         address to,
783         uint256[] memory ids,
784         uint256[] memory amounts,
785         bytes memory data
786     )
787         public
788         virtual
789         override
790     {
791         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
792         require(to != address(0), "ERC1155: transfer to the zero address");
793         require(
794             from == _msgSender() || isApprovedForAll(from, _msgSender()),
795             "ERC1155: transfer caller is not owner nor approved"
796         );
797 
798         address operator = _msgSender();
799 
800         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
801 
802         for (uint256 i = 0; i < ids.length; ++i) {
803             uint256 id = ids[i];
804             uint256 amount = amounts[i];
805 
806             _balances[id][from] = _balances[id][from].sub(
807                 amount,
808                 "ERC1155: insufficient balance for transfer"
809             );
810             _balances[id][to] = _balances[id][to].add(amount);
811         }
812 
813         emit TransferBatch(operator, from, to, ids, amounts);
814 
815         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
816     }
817 
818     /**
819      * @dev Sets a new URI for all token types, by relying on the token type ID
820      * substitution mechanism
821      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
822      *
823      * By this mechanism, any occurrence of the `\{id\}` substring in either the
824      * URI or any of the amounts in the JSON file at said URI will be replaced by
825      * clients with the token type ID.
826      *
827      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
828      * interpreted by clients as
829      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
830      * for token type ID 0x4cce0.
831      *
832      * See {uri}.
833      *
834      * Because these URIs cannot be meaningfully represented by the {URI} event,
835      * this function emits no events.
836      */
837     function _setURI(string memory newuri) internal virtual {
838         _uri = newuri;
839     }
840 
841     /**
842      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
843      *
844      * Emits a {TransferSingle} event.
845      *
846      * Requirements:
847      *
848      * - `account` cannot be the zero address.
849      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
850      * acceptance magic value.
851      */
852     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
853         require(account != address(0), "ERC1155: mint to the zero address");
854 
855         address operator = _msgSender();
856 
857         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
858 
859         _balances[id][account] = _balances[id][account].add(amount);
860         emit TransferSingle(operator, address(0), account, id, amount);
861 
862         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
863     }
864 
865     /**
866      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
867      *
868      * Requirements:
869      *
870      * - `ids` and `amounts` must have the same length.
871      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
872      * acceptance magic value.
873      */
874     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
875         require(to != address(0), "ERC1155: mint to the zero address");
876         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
877 
878         address operator = _msgSender();
879 
880         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
881 
882         for (uint i = 0; i < ids.length; i++) {
883             _balances[ids[i]][to] = amounts[i].add(_balances[ids[i]][to]);
884         }
885 
886         emit TransferBatch(operator, address(0), to, ids, amounts);
887 
888         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
889     }
890 
891     /**
892      * @dev Destroys `amount` tokens of token type `id` from `account`
893      *
894      * Requirements:
895      *
896      * - `account` cannot be the zero address.
897      * - `account` must have at least `amount` tokens of token type `id`.
898      */
899     function _burn(address account, uint256 id, uint256 amount) internal virtual {
900         require(account != address(0), "ERC1155: burn from the zero address");
901 
902         address operator = _msgSender();
903 
904         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
905 
906         _balances[id][account] = _balances[id][account].sub(
907             amount,
908             "ERC1155: burn amount exceeds balance"
909         );
910 
911         emit TransferSingle(operator, account, address(0), id, amount);
912     }
913 
914     /**
915      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
916      *
917      * Requirements:
918      *
919      * - `ids` and `amounts` must have the same length.
920      */
921     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
922         require(account != address(0), "ERC1155: burn from the zero address");
923         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
924 
925         address operator = _msgSender();
926 
927         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
928 
929         for (uint i = 0; i < ids.length; i++) {
930             _balances[ids[i]][account] = _balances[ids[i]][account].sub(
931                 amounts[i],
932                 "ERC1155: burn amount exceeds balance"
933             );
934         }
935 
936         emit TransferBatch(operator, account, address(0), ids, amounts);
937     }
938 
939     /**
940      * @dev Hook that is called before any token transfer. This includes minting
941      * and burning, as well as batched variants.
942      *
943      * The same hook is called on both single and batched variants. For single
944      * transfers, the length of the `id` and `amount` arrays will be 1.
945      *
946      * Calling conditions (for each `id` and `amount` pair):
947      *
948      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
949      * of token type `id` will be  transferred to `to`.
950      * - When `from` is zero, `amount` tokens of token type `id` will be minted
951      * for `to`.
952      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
953      * will be burned.
954      * - `from` and `to` are never both zero.
955      * - `ids` and `amounts` have the same, non-zero length.
956      *
957      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
958      */
959     function _beforeTokenTransfer(
960         address operator,
961         address from,
962         address to,
963         uint256[] memory ids,
964         uint256[] memory amounts,
965         bytes memory data
966     )
967         internal virtual
968     { }
969 
970     function _doSafeTransferAcceptanceCheck(
971         address operator,
972         address from,
973         address to,
974         uint256 id,
975         uint256 amount,
976         bytes memory data
977     )
978         private
979     {
980         if (to.isContract()) {
981             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
982                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
983                     revert("ERC1155: ERC1155Receiver rejected tokens");
984                 }
985             } catch Error(string memory reason) {
986                 revert(reason);
987             } catch {
988                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
989             }
990         }
991     }
992 
993     function _doSafeBatchTransferAcceptanceCheck(
994         address operator,
995         address from,
996         address to,
997         uint256[] memory ids,
998         uint256[] memory amounts,
999         bytes memory data
1000     )
1001         private
1002     {
1003         if (to.isContract()) {
1004             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1005                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1006                     revert("ERC1155: ERC1155Receiver rejected tokens");
1007                 }
1008             } catch Error(string memory reason) {
1009                 revert(reason);
1010             } catch {
1011                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1012             }
1013         }
1014     }
1015 
1016     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1017         uint256[] memory array = new uint256[](1);
1018         array[0] = element;
1019 
1020         return array;
1021     }
1022 }
1023 
1024 
1025 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
1026 
1027 
1028 // pragma solidity ^0.6.0;
1029 
1030 // import "@openzeppelin/contracts/GSN/Context.sol";
1031 /**
1032  * @dev Contract module which provides a basic access control mechanism, where
1033  * there is an account (an owner) that can be granted exclusive access to
1034  * specific functions.
1035  *
1036  * By default, the owner account will be the one that deploys the contract. This
1037  * can later be changed with {transferOwnership}.
1038  *
1039  * This module is used through inheritance. It will make available the modifier
1040  * `onlyOwner`, which can be applied to your functions to restrict their use to
1041  * the owner.
1042  */
1043 contract Ownable is Context {
1044     address private _owner;
1045 
1046     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1047 
1048     /**
1049      * @dev Initializes the contract setting the deployer as the initial owner.
1050      */
1051     constructor () internal {
1052         address msgSender = _msgSender();
1053         _owner = msgSender;
1054         emit OwnershipTransferred(address(0), msgSender);
1055     }
1056 
1057     /**
1058      * @dev Returns the address of the current owner.
1059      */
1060     function owner() public view returns (address) {
1061         return _owner;
1062     }
1063 
1064     /**
1065      * @dev Throws if called by any account other than the owner.
1066      */
1067     modifier onlyOwner() {
1068         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1069         _;
1070     }
1071 
1072     /**
1073      * @dev Leaves the contract without owner. It will not be possible to call
1074      * `onlyOwner` functions anymore. Can only be called by the current owner.
1075      *
1076      * NOTE: Renouncing ownership will leave the contract without an owner,
1077      * thereby removing any functionality that is only available to the owner.
1078      */
1079     function renounceOwnership() public virtual onlyOwner {
1080         emit OwnershipTransferred(_owner, address(0));
1081         _owner = address(0);
1082     }
1083 
1084     /**
1085      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1086      * Can only be called by the current owner.
1087      */
1088     function transferOwnership(address newOwner) public virtual onlyOwner {
1089         require(newOwner != address(0), "Ownable: new owner is the zero address");
1090         emit OwnershipTransferred(_owner, newOwner);
1091         _owner = newOwner;
1092     }
1093 }
1094 
1095 
1096 // Dependency file: @openzeppelin/contracts/utils/EnumerableSet.sol
1097 
1098 
1099 // pragma solidity ^0.6.0;
1100 
1101 /**
1102  * @dev Library for managing
1103  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1104  * types.
1105  *
1106  * Sets have the following properties:
1107  *
1108  * - Elements are added, removed, and checked for existence in constant time
1109  * (O(1)).
1110  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1111  *
1112  * ```
1113  * contract Example {
1114  *     // Add the library methods
1115  *     using EnumerableSet for EnumerableSet.AddressSet;
1116  *
1117  *     // Declare a set state variable
1118  *     EnumerableSet.AddressSet private mySet;
1119  * }
1120  * ```
1121  *
1122  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1123  * (`UintSet`) are supported.
1124  */
1125 library EnumerableSet {
1126     // To implement this library for multiple types with as little code
1127     // repetition as possible, we write it in terms of a generic Set type with
1128     // bytes32 values.
1129     // The Set implementation uses private functions, and user-facing
1130     // implementations (such as AddressSet) are just wrappers around the
1131     // underlying Set.
1132     // This means that we can only create new EnumerableSets for types that fit
1133     // in bytes32.
1134 
1135     struct Set {
1136         // Storage of set values
1137         bytes32[] _values;
1138 
1139         // Position of the value in the `values` array, plus 1 because index 0
1140         // means a value is not in the set.
1141         mapping (bytes32 => uint256) _indexes;
1142     }
1143 
1144     /**
1145      * @dev Add a value to a set. O(1).
1146      *
1147      * Returns true if the value was added to the set, that is if it was not
1148      * already present.
1149      */
1150     function _add(Set storage set, bytes32 value) private returns (bool) {
1151         if (!_contains(set, value)) {
1152             set._values.push(value);
1153             // The value is stored at length-1, but we add 1 to all indexes
1154             // and use 0 as a sentinel value
1155             set._indexes[value] = set._values.length;
1156             return true;
1157         } else {
1158             return false;
1159         }
1160     }
1161 
1162     /**
1163      * @dev Removes a value from a set. O(1).
1164      *
1165      * Returns true if the value was removed from the set, that is if it was
1166      * present.
1167      */
1168     function _remove(Set storage set, bytes32 value) private returns (bool) {
1169         // We read and store the value's index to prevent multiple reads from the same storage slot
1170         uint256 valueIndex = set._indexes[value];
1171 
1172         if (valueIndex != 0) { // Equivalent to contains(set, value)
1173             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1174             // the array, and then remove the last element (sometimes called as 'swap and pop').
1175             // This modifies the order of the array, as noted in {at}.
1176 
1177             uint256 toDeleteIndex = valueIndex - 1;
1178             uint256 lastIndex = set._values.length - 1;
1179 
1180             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1181             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1182 
1183             bytes32 lastvalue = set._values[lastIndex];
1184 
1185             // Move the last value to the index where the value to delete is
1186             set._values[toDeleteIndex] = lastvalue;
1187             // Update the index for the moved value
1188             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1189 
1190             // Delete the slot where the moved value was stored
1191             set._values.pop();
1192 
1193             // Delete the index for the deleted slot
1194             delete set._indexes[value];
1195 
1196             return true;
1197         } else {
1198             return false;
1199         }
1200     }
1201 
1202     /**
1203      * @dev Returns true if the value is in the set. O(1).
1204      */
1205     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1206         return set._indexes[value] != 0;
1207     }
1208 
1209     /**
1210      * @dev Returns the number of values on the set. O(1).
1211      */
1212     function _length(Set storage set) private view returns (uint256) {
1213         return set._values.length;
1214     }
1215 
1216    /**
1217     * @dev Returns the value stored at position `index` in the set. O(1).
1218     *
1219     * Note that there are no guarantees on the ordering of values inside the
1220     * array, and it may change when more values are added or removed.
1221     *
1222     * Requirements:
1223     *
1224     * - `index` must be strictly less than {length}.
1225     */
1226     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1227         require(set._values.length > index, "EnumerableSet: index out of bounds");
1228         return set._values[index];
1229     }
1230 
1231     // AddressSet
1232 
1233     struct AddressSet {
1234         Set _inner;
1235     }
1236 
1237     /**
1238      * @dev Add a value to a set. O(1).
1239      *
1240      * Returns true if the value was added to the set, that is if it was not
1241      * already present.
1242      */
1243     function add(AddressSet storage set, address value) internal returns (bool) {
1244         return _add(set._inner, bytes32(uint256(value)));
1245     }
1246 
1247     /**
1248      * @dev Removes a value from a set. O(1).
1249      *
1250      * Returns true if the value was removed from the set, that is if it was
1251      * present.
1252      */
1253     function remove(AddressSet storage set, address value) internal returns (bool) {
1254         return _remove(set._inner, bytes32(uint256(value)));
1255     }
1256 
1257     /**
1258      * @dev Returns true if the value is in the set. O(1).
1259      */
1260     function contains(AddressSet storage set, address value) internal view returns (bool) {
1261         return _contains(set._inner, bytes32(uint256(value)));
1262     }
1263 
1264     /**
1265      * @dev Returns the number of values in the set. O(1).
1266      */
1267     function length(AddressSet storage set) internal view returns (uint256) {
1268         return _length(set._inner);
1269     }
1270 
1271    /**
1272     * @dev Returns the value stored at position `index` in the set. O(1).
1273     *
1274     * Note that there are no guarantees on the ordering of values inside the
1275     * array, and it may change when more values are added or removed.
1276     *
1277     * Requirements:
1278     *
1279     * - `index` must be strictly less than {length}.
1280     */
1281     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1282         return address(uint256(_at(set._inner, index)));
1283     }
1284 
1285 
1286     // UintSet
1287 
1288     struct UintSet {
1289         Set _inner;
1290     }
1291 
1292     /**
1293      * @dev Add a value to a set. O(1).
1294      *
1295      * Returns true if the value was added to the set, that is if it was not
1296      * already present.
1297      */
1298     function add(UintSet storage set, uint256 value) internal returns (bool) {
1299         return _add(set._inner, bytes32(value));
1300     }
1301 
1302     /**
1303      * @dev Removes a value from a set. O(1).
1304      *
1305      * Returns true if the value was removed from the set, that is if it was
1306      * present.
1307      */
1308     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1309         return _remove(set._inner, bytes32(value));
1310     }
1311 
1312     /**
1313      * @dev Returns true if the value is in the set. O(1).
1314      */
1315     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1316         return _contains(set._inner, bytes32(value));
1317     }
1318 
1319     /**
1320      * @dev Returns the number of values on the set. O(1).
1321      */
1322     function length(UintSet storage set) internal view returns (uint256) {
1323         return _length(set._inner);
1324     }
1325 
1326    /**
1327     * @dev Returns the value stored at position `index` in the set. O(1).
1328     *
1329     * Note that there are no guarantees on the ordering of values inside the
1330     * array, and it may change when more values are added or removed.
1331     *
1332     * Requirements:
1333     *
1334     * - `index` must be strictly less than {length}.
1335     */
1336     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1337         return uint256(_at(set._inner, index));
1338     }
1339 }
1340 
1341 
1342 // Dependency file: contracts/interfaces/IAlpacaWearable.sol
1343 
1344 
1345 // pragma solidity 0.6.12;
1346 
1347 // import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
1348 
1349 interface IAlpacaWearable is IERC1155 {
1350     function getWearable(uint256 _id)
1351         external
1352         view
1353         returns (
1354             uint256 id,
1355             uint256 energy,
1356             uint256 wearableType
1357         );
1358 
1359     function mint(
1360         address account,
1361         uint256 id,
1362         uint256 amount,
1363         bytes memory data
1364     ) external;
1365 
1366     function mintBatch(
1367         address to,
1368         uint256[] memory ids,
1369         uint256[] memory amounts,
1370         bytes memory data
1371     ) external;
1372 
1373     function burn(
1374         address account,
1375         uint256 id,
1376         uint256 amount
1377     ) external;
1378 
1379     function burnBatch(
1380         address account,
1381         uint256[] memory ids,
1382         uint256[] memory amounts
1383     ) external;
1384 }
1385 
1386 
1387 // Root file: contracts/AlpacaWearable/AlpacaWearable.sol
1388 
1389 
1390 pragma solidity 0.6.12;
1391 
1392 // import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
1393 // import "@openzeppelin/contracts/access/Ownable.sol";
1394 // import "@openzeppelin/contracts/utils/EnumerableSet.sol";
1395 
1396 // import "contracts/interfaces/IAlpacaWearable.sol";
1397 
1398 contract AlpacaWearable is ERC1155(""), Ownable, IAlpacaWearable {
1399     using EnumerableSet for EnumerableSet.AddressSet;
1400 
1401     /* ========== EVENT ========== */
1402 
1403     event AddWearable(uint256 indexed wearableId, uint256 energy);
1404 
1405     event UpdateWearableEnergy(
1406         uint256 indexed wearableId,
1407         uint256 prevEnergy,
1408         uint256 newEnergy
1409     );
1410 
1411     /* ========== STORAGE ========== */
1412 
1413     struct Wearable {
1414         uint32 energy;
1415         uint32 wearableType;
1416     }
1417 
1418     Wearable[] public wearables;
1419 
1420     // Set of alpaca IDs this contract owns
1421     EnumerableSet.AddressSet private minters;
1422 
1423     constructor() public {
1424         minters.add(msg.sender);
1425         wearables.push(Wearable({energy: 0, wearableType: 0}));
1426     }
1427 
1428     /* ========== VIEW ========== */
1429 
1430     function wearableCount() public view returns (uint256) {
1431         return wearables.length;
1432     }
1433 
1434     function getWearable(uint256 _id)
1435         external
1436         override
1437         view
1438         returns (
1439             uint256 id,
1440             uint256 energy,
1441             uint256 wearableType
1442         )
1443     {
1444         require(id < wearables.length);
1445 
1446         Wearable storage wearable = wearables[_id];
1447         id = _id;
1448         energy = wearable.energy;
1449         wearableType = wearable.wearableType;
1450     }
1451 
1452     /* ========== MUTATION ========== */
1453 
1454     function addWearable(uint32 energy, uint32 wearableType)
1455         public
1456         onlyOwner
1457         returns (uint256)
1458     {
1459         require(wearableType != 0, "invalid type");
1460 
1461         uint256 id = wearables.length;
1462         wearables.push(Wearable({energy: energy, wearableType: wearableType}));
1463         emit AddWearable(id, energy);
1464         return id;
1465     }
1466 
1467     function updateWearableEnergy(uint256 index, uint32 energy)
1468         public
1469         onlyOwner
1470     {
1471         require(index < wearables.length);
1472 
1473         Wearable storage wearable = wearables[index];
1474         uint256 prevEnergy = wearable.energy;
1475         wearable.energy = energy;
1476 
1477         emit UpdateWearableEnergy(index, prevEnergy, energy);
1478     }
1479 
1480     function mint(
1481         address account,
1482         uint256 id,
1483         uint256 amount,
1484         bytes memory data
1485     ) public override onlyMinter {
1486         require(id < wearables.length);
1487         _mint(account, id, amount, data);
1488     }
1489 
1490     function mintBatch(
1491         address to,
1492         uint256[] memory ids,
1493         uint256[] memory amounts,
1494         bytes memory data
1495     ) public override onlyMinter {
1496         for (uint256 i = 0; i < ids.length; i++) {
1497             require(ids[i] < wearables.length);
1498         }
1499         _mintBatch(to, ids, amounts, data);
1500     }
1501 
1502     function burn(
1503         address account,
1504         uint256 id,
1505         uint256 amount
1506     ) public override onlyMinter {
1507         _burn(account, id, amount);
1508     }
1509 
1510     function burnBatch(
1511         address account,
1512         uint256[] memory ids,
1513         uint256[] memory amounts
1514     ) public override onlyMinter {
1515         _burnBatch(account, ids, amounts);
1516     }
1517 
1518     function setURI(string memory _uri) public onlyOwner {
1519         _setURI(_uri);
1520     }
1521 
1522     function addMinter(address _minter) public onlyOwner {
1523         minters.add(_minter);
1524     }
1525 
1526     function removeMinter(address _minter) public onlyOwner {
1527         minters.remove(_minter);
1528     }
1529 
1530     function isMinter(address _minter) public view returns (bool) {
1531         minters.contains(_minter);
1532     }
1533 
1534     modifier onlyMinter() {
1535         require(
1536             minters.contains(_msgSender()),
1537             "AlpacaWearable: caller is not the minter"
1538         );
1539         _;
1540     }
1541 }