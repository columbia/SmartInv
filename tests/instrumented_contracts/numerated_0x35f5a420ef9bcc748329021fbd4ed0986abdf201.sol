1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-23
3 */
4 
5 // SPDX-License-Identifier: Apache License, Version 2.0
6 
7 pragma solidity 0.7.6;
8 
9 
10 
11 // Part: Address
12 
13 /**
14  * @dev Collection of functions related to the address type
15  */
16 library Address {
17     /**
18      * @dev Returns true if `account` is a contract.
19      *
20      * [IMPORTANT]
21      * ====
22      * It is unsafe to assume that an address for which this function returns
23      * false is an externally-owned account (EOA) and not a contract.
24      *
25      * Among others, `isContract` will return false for the following
26      * types of addresses:
27      *
28      *  - an externally-owned account
29      *  - a contract in construction
30      *  - an address where a contract will be created
31      *  - an address where a contract lived, but was destroyed
32      * ====
33      */
34     function isContract(address account) internal view returns (bool) {
35         // This method relies on extcodesize, which returns 0 for contracts in
36         // construction, since the code is only stored at the end of the
37         // constructor execution.
38 
39         uint256 size;
40         // solhint-disable-next-line no-inline-assembly
41         assembly { size := extcodesize(account) }
42         return size > 0;
43     }
44 
45     /**
46      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
47      * `recipient`, forwarding all available gas and reverting on errors.
48      *
49      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
50      * of certain opcodes, possibly making contracts go over the 2300 gas limit
51      * imposed by `transfer`, making them unable to receive funds via
52      * `transfer`. {sendValue} removes this limitation.
53      *
54      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
55      *
56      * IMPORTANT: because control is transferred to `recipient`, care must be
57      * taken to not create reentrancy vulnerabilities. Consider using
58      * {ReentrancyGuard} or the
59      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
60      */
61     function sendValue(address payable recipient, uint256 amount) internal {
62         require(address(this).balance >= amount, "Address: insufficient balance");
63 
64         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
65         (bool success, ) = recipient.call{ value: amount }("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain`call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88       return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
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
112     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
113         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
114     }
115 
116     /**
117      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
118      * with `errorMessage` as a fallback revert reason when `target` reverts.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
123         require(address(this).balance >= value, "Address: insufficient balance for call");
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: value }(data);
128         return _verifyCallResult(success, returndata, errorMessage);
129     }
130 
131     /**
132      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
133      * but performing a static call.
134      *
135      * _Available since v3.3._
136      */
137     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
138         return functionStaticCall(target, data, "Address: low-level static call failed");
139     }
140 
141     /**
142      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
143      * but performing a static call.
144      *
145      * _Available since v3.3._
146      */
147     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
148         require(isContract(target), "Address: static call to non-contract");
149 
150         // solhint-disable-next-line avoid-low-level-calls
151         (bool success, bytes memory returndata) = target.staticcall(data);
152         return _verifyCallResult(success, returndata, errorMessage);
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
157      * but performing a delegate call.
158      *
159      * _Available since v3.4._
160      */
161     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
162         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
172         require(isContract(target), "Address: delegate call to non-contract");
173 
174         // solhint-disable-next-line avoid-low-level-calls
175         (bool success, bytes memory returndata) = target.delegatecall(data);
176         return _verifyCallResult(success, returndata, errorMessage);
177     }
178 
179     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
180         if (success) {
181             return returndata;
182         } else {
183             // Look for revert reason and bubble it up if present
184             if (returndata.length > 0) {
185                 // The easiest way to bubble the revert reason is using memory via assembly
186 
187                 // solhint-disable-next-line no-inline-assembly
188                 assembly {
189                     let returndata_size := mload(returndata)
190                     revert(add(32, returndata), returndata_size)
191                 }
192             } else {
193                 revert(errorMessage);
194             }
195         }
196     }
197 }
198 
199 // Part: Context
200 
201 /*
202  * @dev Provides information about the current execution context, including the
203  * sender of the transaction and its data. While these are generally available
204  * via msg.sender and msg.data, they should not be accessed in such a direct
205  * manner, since when dealing with GSN meta-transactions the account sending and
206  * paying for execution may not be the actual sender (as far as an application
207  * is concerned).
208  *
209  * This contract is only required for intermediate, library-like contracts.
210  */
211 abstract contract Context {
212     function _msgSender() internal view virtual returns (address payable) {
213         return msg.sender;
214     }
215 
216     function _msgData() internal view virtual returns (bytes memory) {
217         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
218         return msg.data;
219     }
220 }
221 
222 // Part: ERC165Checker
223 
224 /**
225  * @dev Library used to query support of an interface declared via {IERC165}.
226  *
227  * Note that these functions return the actual result of the query: they do not
228  * `revert` if an interface is not supported. It is up to the caller to decide
229  * what to do in these cases.
230  */
231 library ERC165Checker {
232     // As per the EIP-165 spec, no interface should ever match 0xffffffff
233     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
234 
235     /*
236      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
237      */
238     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
239 
240     /**
241      * @dev Returns true if `account` supports the {IERC165} interface,
242      */
243     function supportsERC165(address account) internal view returns (bool) {
244         // Any contract that implements ERC165 must explicitly indicate support of
245         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
246         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
247             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
248     }
249 
250     /**
251      * @dev Returns true if `account` supports the interface defined by
252      * `interfaceId`. Support for {IERC165} itself is queried automatically.
253      *
254      * See {IERC165-supportsInterface}.
255      */
256     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
257         // query support of both ERC165 as per the spec and support of _interfaceId
258         return supportsERC165(account) &&
259             _supportsERC165Interface(account, interfaceId);
260     }
261 
262     /**
263      * @dev Returns a boolean array where each value corresponds to the
264      * interfaces passed in and whether they're supported or not. This allows
265      * you to batch check interfaces for a contract where your expectation
266      * is that some interfaces may not be supported.
267      *
268      * See {IERC165-supportsInterface}.
269      *
270      * _Available since v3.4._
271      */
272     function getSupportedInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool[] memory) {
273         // an array of booleans corresponding to interfaceIds and whether they're supported or not
274         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
275 
276         // query support of ERC165 itself
277         if (supportsERC165(account)) {
278             // query support of each interface in interfaceIds
279             for (uint256 i = 0; i < interfaceIds.length; i++) {
280                 interfaceIdsSupported[i] = _supportsERC165Interface(account, interfaceIds[i]);
281             }
282         }
283 
284         return interfaceIdsSupported;
285     }
286 
287     /**
288      * @dev Returns true if `account` supports all the interfaces defined in
289      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
290      *
291      * Batch-querying can lead to gas savings by skipping repeated checks for
292      * {IERC165} support.
293      *
294      * See {IERC165-supportsInterface}.
295      */
296     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
297         // query support of ERC165 itself
298         if (!supportsERC165(account)) {
299             return false;
300         }
301 
302         // query support of each interface in _interfaceIds
303         for (uint256 i = 0; i < interfaceIds.length; i++) {
304             if (!_supportsERC165Interface(account, interfaceIds[i])) {
305                 return false;
306             }
307         }
308 
309         // all interfaces supported
310         return true;
311     }
312 
313     /**
314      * @notice Query if a contract implements an interface, does not check ERC165 support
315      * @param account The address of the contract to query for support of an interface
316      * @param interfaceId The interface identifier, as specified in ERC-165
317      * @return true if the contract at account indicates support of the interface with
318      * identifier interfaceId, false otherwise
319      * @dev Assumes that account contains a contract that supports ERC165, otherwise
320      * the behavior of this method is undefined. This precondition can be checked
321      * with {supportsERC165}.
322      * Interface identification is specified in ERC-165.
323      */
324     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
325         // success determines whether the staticcall succeeded and result determines
326         // whether the contract at account indicates support of _interfaceId
327         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
328 
329         return (success && result);
330     }
331 
332     /**
333      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
334      * @param account The address of the contract to query for support of an interface
335      * @param interfaceId The interface identifier, as specified in ERC-165
336      * @return success true if the STATICCALL succeeded, false otherwise
337      * @return result true if the STATICCALL succeeded and the contract at account
338      * indicates support of the interface with identifier interfaceId, false otherwise
339      */
340     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
341         private
342         view
343         returns (bool, bool)
344     {
345         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
346         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
347         if (result.length < 32) return (false, false);
348         return (success, abi.decode(result, (bool)));
349     }
350 }
351 
352 // Part: IERC165
353 
354 /**
355  * @dev Interface of the ERC165 standard, as defined in the
356  * https://eips.ethereum.org/EIPS/eip-165[EIP].
357  *
358  * Implementers can declare support of contract interfaces, which can then be
359  * queried by others ({ERC165Checker}).
360  *
361  * For an implementation, see {ERC165}.
362  */
363 interface IERC165 {
364     /**
365      * @dev Returns true if this contract implements the interface defined by
366      * `interfaceId`. See the corresponding
367      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
368      * to learn more about how these ids are created.
369      *
370      * This function call must use less than 30 000 gas.
371      */
372     function supportsInterface(bytes4 interfaceId) external view returns (bool);
373 }
374 
375 // Part: SafeMath
376 
377 /**
378  * @dev Wrappers over Solidity's arithmetic operations with added overflow
379  * checks.
380  *
381  * Arithmetic operations in Solidity wrap on overflow. This can easily result
382  * in bugs, because programmers usually assume that an overflow raises an
383  * error, which is the standard behavior in high level programming languages.
384  * `SafeMath` restores this intuition by reverting the transaction when an
385  * operation overflows.
386  *
387  * Using this library instead of the unchecked operations eliminates an entire
388  * class of bugs, so it's recommended to use it always.
389  */
390 library SafeMath {
391     /**
392      * @dev Returns the addition of two unsigned integers, with an overflow flag.
393      *
394      * _Available since v3.4._
395      */
396     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
397         uint256 c = a + b;
398         if (c < a) return (false, 0);
399         return (true, c);
400     }
401 
402     /**
403      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
404      *
405      * _Available since v3.4._
406      */
407     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
408         if (b > a) return (false, 0);
409         return (true, a - b);
410     }
411 
412     /**
413      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
414      *
415      * _Available since v3.4._
416      */
417     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
418         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
419         // benefit is lost if 'b' is also tested.
420         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
421         if (a == 0) return (true, 0);
422         uint256 c = a * b;
423         if (c / a != b) return (false, 0);
424         return (true, c);
425     }
426 
427     /**
428      * @dev Returns the division of two unsigned integers, with a division by zero flag.
429      *
430      * _Available since v3.4._
431      */
432     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
433         if (b == 0) return (false, 0);
434         return (true, a / b);
435     }
436 
437     /**
438      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
439      *
440      * _Available since v3.4._
441      */
442     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
443         if (b == 0) return (false, 0);
444         return (true, a % b);
445     }
446 
447     /**
448      * @dev Returns the addition of two unsigned integers, reverting on
449      * overflow.
450      *
451      * Counterpart to Solidity's `+` operator.
452      *
453      * Requirements:
454      *
455      * - Addition cannot overflow.
456      */
457     function add(uint256 a, uint256 b) internal pure returns (uint256) {
458         uint256 c = a + b;
459         require(c >= a, "SafeMath: addition overflow");
460         return c;
461     }
462 
463     /**
464      * @dev Returns the subtraction of two unsigned integers, reverting on
465      * overflow (when the result is negative).
466      *
467      * Counterpart to Solidity's `-` operator.
468      *
469      * Requirements:
470      *
471      * - Subtraction cannot overflow.
472      */
473     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
474         require(b <= a, "SafeMath: subtraction overflow");
475         return a - b;
476     }
477 
478     /**
479      * @dev Returns the multiplication of two unsigned integers, reverting on
480      * overflow.
481      *
482      * Counterpart to Solidity's `*` operator.
483      *
484      * Requirements:
485      *
486      * - Multiplication cannot overflow.
487      */
488     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
489         if (a == 0) return 0;
490         uint256 c = a * b;
491         require(c / a == b, "SafeMath: multiplication overflow");
492         return c;
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers, reverting on
497      * division by zero. The result is rounded towards zero.
498      *
499      * Counterpart to Solidity's `/` operator. Note: this function uses a
500      * `revert` opcode (which leaves remaining gas untouched) while Solidity
501      * uses an invalid opcode to revert (consuming all remaining gas).
502      *
503      * Requirements:
504      *
505      * - The divisor cannot be zero.
506      */
507     function div(uint256 a, uint256 b) internal pure returns (uint256) {
508         require(b > 0, "SafeMath: division by zero");
509         return a / b;
510     }
511 
512     /**
513      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
514      * reverting when dividing by zero.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
525         require(b > 0, "SafeMath: modulo by zero");
526         return a % b;
527     }
528 
529     /**
530      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
531      * overflow (when the result is negative).
532      *
533      * CAUTION: This function is deprecated because it requires allocating memory for the error
534      * message unnecessarily. For custom revert reasons use {trySub}.
535      *
536      * Counterpart to Solidity's `-` operator.
537      *
538      * Requirements:
539      *
540      * - Subtraction cannot overflow.
541      */
542     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b <= a, errorMessage);
544         return a - b;
545     }
546 
547     /**
548      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
549      * division by zero. The result is rounded towards zero.
550      *
551      * CAUTION: This function is deprecated because it requires allocating memory for the error
552      * message unnecessarily. For custom revert reasons use {tryDiv}.
553      *
554      * Counterpart to Solidity's `/` operator. Note: this function uses a
555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
556      * uses an invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b > 0, errorMessage);
564         return a / b;
565     }
566 
567     /**
568      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
569      * reverting with custom message when dividing by zero.
570      *
571      * CAUTION: This function is deprecated because it requires allocating memory for the error
572      * message unnecessarily. For custom revert reasons use {tryMod}.
573      *
574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
575      * opcode (which leaves remaining gas untouched) while Solidity uses an
576      * invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
583         require(b > 0, errorMessage);
584         return a % b;
585     }
586 }
587 
588 // Part: ERC165
589 
590 /**
591  * @dev Implementation of the {IERC165} interface.
592  *
593  * Contracts may inherit from this and call {_registerInterface} to declare
594  * their support of an interface.
595  */
596 abstract contract ERC165 is IERC165 {
597     /*
598      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
599      */
600     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
601 
602     /**
603      * @dev Mapping of interface ids to whether or not it's supported.
604      */
605     mapping(bytes4 => bool) private _supportedInterfaces;
606 
607     constructor () internal {
608         // Derived contracts need only register support for their own interfaces,
609         // we register support for ERC165 itself here
610         _registerInterface(_INTERFACE_ID_ERC165);
611     }
612 
613     /**
614      * @dev See {IERC165-supportsInterface}.
615      *
616      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
617      */
618     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
619         return _supportedInterfaces[interfaceId];
620     }
621 
622     /**
623      * @dev Registers the contract as an implementer of the interface defined by
624      * `interfaceId`. Support of the actual ERC165 interface is automatic and
625      * registering its interface id is not required.
626      *
627      * See {IERC165-supportsInterface}.
628      *
629      * Requirements:
630      *
631      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
632      */
633     function _registerInterface(bytes4 interfaceId) internal virtual {
634         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
635         _supportedInterfaces[interfaceId] = true;
636     }
637 }
638 
639 // Part: IERC1155
640 
641 /**
642  * @dev Required interface of an ERC1155 compliant contract, as defined in the
643  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
644  *
645  * _Available since v3.1._
646  */
647 interface IERC1155 is IERC165 {
648     /**
649      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
650      */
651     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
652 
653     /**
654      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
655      * transfers.
656      */
657     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
658 
659     /**
660      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
661      * `approved`.
662      */
663     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
664 
665     /**
666      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
667      *
668      * If an {URI} event was emitted for `id`, the standard
669      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
670      * returned by {IERC1155MetadataURI-uri}.
671      */
672     event URI(string value, uint256 indexed id);
673 
674     /**
675      * @dev Returns the amount of tokens of token type `id` owned by `account`.
676      *
677      * Requirements:
678      *
679      * - `account` cannot be the zero address.
680      */
681     function balanceOf(address account, uint256 id) external view returns (uint256);
682 
683     /**
684      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
685      *
686      * Requirements:
687      *
688      * - `accounts` and `ids` must have the same length.
689      */
690     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
691 
692     /**
693      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
694      *
695      * Emits an {ApprovalForAll} event.
696      *
697      * Requirements:
698      *
699      * - `operator` cannot be the caller.
700      */
701     function setApprovalForAll(address operator, bool approved) external;
702 
703     /**
704      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
705      *
706      * See {setApprovalForAll}.
707      */
708     function isApprovedForAll(address account, address operator) external view returns (bool);
709 
710     /**
711      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
712      *
713      * Emits a {TransferSingle} event.
714      *
715      * Requirements:
716      *
717      * - `to` cannot be the zero address.
718      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
719      * - `from` must have a balance of tokens of type `id` of at least `amount`.
720      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
721      * acceptance magic value.
722      */
723     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
724 
725     /**
726      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
727      *
728      * Emits a {TransferBatch} event.
729      *
730      * Requirements:
731      *
732      * - `ids` and `amounts` must have the same length.
733      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
734      * acceptance magic value.
735      */
736     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
737 }
738 
739 // Part: IERC1155Receiver
740 
741 /**
742  * _Available since v3.1._
743  */
744 interface IERC1155Receiver is IERC165 {
745 
746     /**
747         @dev Handles the receipt of a single ERC1155 token type. This function is
748         called at the end of a `safeTransferFrom` after the balance has been updated.
749         To accept the transfer, this must return
750         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
751         (i.e. 0xf23a6e61, or its own function selector).
752         @param operator The address which initiated the transfer (i.e. msg.sender)
753         @param from The address which previously owned the token
754         @param id The ID of the token being transferred
755         @param value The amount of tokens being transferred
756         @param data Additional data with no specified format
757         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
758     */
759     function onERC1155Received(
760         address operator,
761         address from,
762         uint256 id,
763         uint256 value,
764         bytes calldata data
765     )
766         external
767         returns(bytes4);
768 
769     /**
770         @dev Handles the receipt of a multiple ERC1155 token types. This function
771         is called at the end of a `safeBatchTransferFrom` after the balances have
772         been updated. To accept the transfer(s), this must return
773         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
774         (i.e. 0xbc197c81, or its own function selector).
775         @param operator The address which initiated the batch transfer (i.e. msg.sender)
776         @param from The address which previously owned the token
777         @param ids An array containing ids of each token being transferred (order and length must match values array)
778         @param values An array containing amounts of each token being transferred (order and length must match ids array)
779         @param data Additional data with no specified format
780         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
781     */
782     function onERC1155BatchReceived(
783         address operator,
784         address from,
785         uint256[] calldata ids,
786         uint256[] calldata values,
787         bytes calldata data
788     )
789         external
790         returns(bytes4);
791 }
792 
793 // Part: Ownable
794 
795 /**
796  * @dev Contract module which provides a basic access control mechanism, where
797  * there is an account (an owner) that can be granted exclusive access to
798  * specific functions.
799  *
800  * By default, the owner account will be the one that deploys the contract. This
801  * can later be changed with {transferOwnership}.
802  *
803  * This module is used through inheritance. It will make available the modifier
804  * `onlyOwner`, which can be applied to your functions to restrict their use to
805  * the owner.
806  */
807 abstract contract Ownable is Context {
808     address private _owner;
809 
810     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
811 
812     /**
813      * @dev Initializes the contract setting the deployer as the initial owner.
814      */
815     constructor () internal {
816         address msgSender = _msgSender();
817         _owner = msgSender;
818         emit OwnershipTransferred(address(0), msgSender);
819     }
820 
821     /**
822      * @dev Returns the address of the current owner.
823      */
824     function owner() public view virtual returns (address) {
825         return _owner;
826     }
827 
828     /**
829      * @dev Throws if called by any account other than the owner.
830      */
831     modifier onlyOwner() {
832         require(owner() == _msgSender(), "Ownable: caller is not the owner");
833         _;
834     }
835 
836     /**
837      * @dev Leaves the contract without owner. It will not be possible to call
838      * `onlyOwner` functions anymore. Can only be called by the current owner.
839      *
840      * NOTE: Renouncing ownership will leave the contract without an owner,
841      * thereby removing any functionality that is only available to the owner.
842      */
843     function renounceOwnership() public virtual onlyOwner {
844         emit OwnershipTransferred(_owner, address(0));
845         _owner = address(0);
846     }
847 
848     /**
849      * @dev Transfers ownership of the contract to a new account (`newOwner`).
850      * Can only be called by the current owner.
851      */
852     function transferOwnership(address newOwner) public virtual onlyOwner {
853         require(newOwner != address(0), "Ownable: new owner is the zero address");
854         emit OwnershipTransferred(_owner, newOwner);
855         _owner = newOwner;
856     }
857 }
858 
859 // Part: IERC1155MetadataURI
860 
861 /**
862  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
863  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
864  *
865  * _Available since v3.1._
866  */
867 interface IERC1155MetadataURI is IERC1155 {
868     /**
869      * @dev Returns the URI for token type `id`.
870      *
871      * If the `\{id\}` substring is present in the URI, it must be replaced by
872      * clients with the actual token type ID.
873      */
874     function uri(uint256 id) external view returns (string memory);
875 }
876 
877 // Part: IStarNFT
878 
879 /**
880  * @title IStarNFT
881  * @author Galaxy Protocol
882  *
883  * Interface for operating with StarNFTs.
884  */
885 interface IStarNFT is IERC1155 {
886     /* ============ Events =============== */
887 //    event PowahUpdated(uint256 indexed id, uint256 indexed oldPoints, uint256 indexed newPoints);
888 
889     /* ============ Functions ============ */
890 
891     function isOwnerOf(address, uint256) external view returns (bool);
892 //    function starInfo(uint256) external view returns (uint128 powah, uint128 mintBlock, address originator);
893 //    function quasarInfo(uint256) external view returns (uint128 mintBlock, IERC20 stakeToken, uint256 amount, uint256 campaignID);
894 //    function superInfo(uint256) external view returns (uint128 mintBlock, IERC20[] memory stakeToken, uint256[] memory amount, uint256 campaignID);
895 
896     // mint
897     function mint(address account, uint256 powah) external returns (uint256);
898     function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external returns (uint256[] memory);
899     function burn(address account, uint256 id) external;
900     function burnBatch(address account, uint256[] calldata ids) external;
901 
902     // asset-backing mint
903 //    function mintQuasar(address account, uint256 powah, uint256 cid, IERC20 stakeToken, uint256 amount) external returns (uint256);
904 //    function burnQuasar(address account, uint256 id) external;
905 
906     // asset-backing forge
907 //    function mintSuper(address account, uint256 powah, uint256 campaignID, IERC20[] calldata stakeTokens, uint256[] calldata amounts) external returns (uint256);
908 //    function burnSuper(address account, uint256 id) external;
909     // update
910 //    function updatePowah(address owner, uint256 id, uint256 powah) external;
911 }
912 
913 // File: StarNFTV1.sol
914 
915 //import "../../interfaces/listener/IStarUpdateListener.sol";
916 
917 
918 /**
919  * based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
920  */
921 contract StarNFTV1 is ERC165, IERC1155, IERC1155MetadataURI, IStarNFT, Ownable {
922     using SafeMath for uint256;
923     using Address for address;
924     using ERC165Checker for address;
925 
926     /* ============ Events ============ */
927     /* ============ Modifiers ============ */
928     /**
929      * Only minter.
930      */
931     modifier onlyMinter() {
932         require(minters[msg.sender], "must be minter");
933         _;
934     }
935     /* ============ Enums ================ */
936     /* ============ Structs ============ */
937     /* ============ State Variables ============ */
938 
939     // Used as the URI for all token types by ID substitution, e.g. https://galaxy.eco/{address}/{id}.json
940     string public baseURI;
941 
942     // Mint and burn star.
943     mapping(address => bool) public minters;
944 
945     // Total star count, including burnt nft
946     uint256 public starCount;
947     // Mapping from token ID to account
948     mapping(uint256 => address) public starBelongTo;
949 
950     // Mapping from account to operator approvals
951     mapping(address => mapping(address => bool)) private _operatorApprovals;
952 
953 
954     /* ============ Constructor ============ */
955     constructor () public {}
956 
957     /* ============ External Functions ============ */
958     /**
959      * See {IERC1155-setApprovalForAll}.
960      */
961     function setApprovalForAll(address operator, bool approved) external override {
962         require(msg.sender != operator, "Setting approval status for self");
963 
964         _operatorApprovals[msg.sender][operator] = approved;
965         emit ApprovalForAll(msg.sender, operator, approved);
966     }
967 
968     /**
969      * See {IERC1155-safeTransferFrom}.
970      */
971     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) external override {
972         require(to != address(0), "Transfer to must not be null address");
973         require(amount == 1, "Invalid amount");
974         require(
975             from == msg.sender || isApprovedForAll(from, msg.sender),
976             "Transfer caller is neither owner nor approved"
977         );
978         require(isOwnerOf(from, id), "Not the owner");
979 
980         starBelongTo[id] = to;
981 
982         emit TransferSingle(msg.sender, from, to, id, amount);
983 
984         _doSafeTransferAcceptanceCheck(msg.sender, from, to, id, amount, data);
985     }
986 
987     /**
988      * See {IERC1155-safeBatchTransferFrom}.
989      */
990     function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) external override {
991         require(to != address(0), "Batch transfer to must not be null address");
992         require(ids.length == amounts.length, "Array(ids, amounts) length mismatch");
993         require(from == msg.sender || isApprovedForAll(from, msg.sender), "Transfer caller is neither owner nor approved");
994 
995         for (uint256 i = 0; i < ids.length; ++i) {
996             uint256 id = ids[i];
997             require(isOwnerOf(from, id), "Not the owner");
998             starBelongTo[id] = to;
999         }
1000 
1001         emit TransferBatch(msg.sender, from, to, ids, amounts);
1002 
1003         _doSafeBatchTransferAcceptanceCheck(msg.sender, from, to, ids, amounts, data);
1004     }
1005 
1006     function mint(address account, uint256 powah) external onlyMinter override returns (uint256) {
1007         return _mint(account, powah);
1008     }
1009 
1010     function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external onlyMinter override returns (uint256[] memory) {
1011         require(account != address(0), "Must not mint to null address");
1012         require(powahArr.length == amount, "Array(powah) length mismatch param(amount)");
1013         return _mintBatch(account, amount, powahArr);
1014     }
1015 
1016     function burn(address account, uint256 id) external onlyMinter override {
1017         require(isOwnerOf(account, id), "Not the owner");
1018         _burn(account, id);
1019     }
1020 
1021     function burnBatch(address account, uint256[] calldata ids) external onlyMinter override {
1022         for (uint i = 0; i < ids.length; i++) {
1023             require(isOwnerOf(account, ids[i]), "Not the owner");
1024         }
1025         _burnBatch(account, ids);
1026     }
1027 
1028     /**
1029      * PRIVILEGED MODULE FUNCTION. Sets a new baseURI for all token types.
1030      */
1031     function setURI(string memory newURI) external onlyOwner {
1032         baseURI = newURI;
1033     }
1034 
1035     /**
1036      * PRIVILEGED MODULE FUNCTION. Add a new minter.
1037      */
1038     function addMinter(address minter) external onlyOwner {
1039         require(minter != address(0), "Minter must not be null address");
1040         require(!minters[minter], "Minter already added");
1041         minters[minter] = true;
1042     }
1043 
1044     /**
1045      * PRIVILEGED MODULE FUNCTION. Remove a old minter.
1046      */
1047     function removeMinter(address minter) external onlyOwner {
1048         require(minters[minter], "Minter does not exist");
1049         delete minters[minter];
1050     }
1051 
1052     /* ============ External Getter Functions ============ */
1053     /**
1054      * See {IERC1155-isApprovedForAll}.
1055      */
1056     function isApprovedForAll(address account, address operator) public view override returns (bool) {
1057         return _operatorApprovals[account][operator];
1058     }
1059 
1060     /**
1061      * See {IERC1155MetadataURI-uri}.
1062      *
1063      * This implementation returns the same URI for *all* token types. It relies
1064      * on the token type ID substitution mechanism
1065      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1066      *
1067      * Clients calling this function must replace the `\{id\}` substring with the
1068      * actual token type ID.
1069      */
1070     function uri(uint256 id) external view override returns (string memory) {
1071         require(id <= starCount, "NFT does not exist");
1072         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1073         if (bytes(baseURI).length == 0) {
1074             return "";
1075         } else {
1076             // bytes memory b = new bytes(32);
1077             // assembly { mstore(add(b, 32), id) }
1078             // abi.encodePacked is being used to concatenate strings
1079             return string(abi.encodePacked(baseURI, uint2str(id), ".json"));
1080         }
1081     }
1082 
1083     /**
1084      * Is the nft owner.
1085      * Requirements:
1086      * - `account` must not be zero address.
1087      */
1088     function isOwnerOf(address account, uint256 id) public view override returns (bool) {
1089         if (account == address(0)) {
1090             return false;
1091         } else {
1092             return starBelongTo[id] == account;
1093         }
1094     }
1095 
1096     /**
1097      * See {IERC1155-balanceOf}.
1098      * Requirements:
1099      * - `account` must not be zero address.
1100      */
1101     function balanceOf(address account, uint256 id) public view override returns (uint256) {
1102         if (isOwnerOf(account, id)) {
1103             return 1;
1104         }
1105         return 0;
1106     }
1107 
1108     /**
1109      * See {IERC1155-balanceOfBatch}.
1110      * Requirements:
1111      * - `accounts` and `ids` must have the same length.
1112      */
1113     function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view override returns (uint256[] memory){
1114         require(accounts.length == ids.length, "Array(accounts, ids) length mismatch");
1115 
1116         uint256[] memory batchBalances = new uint256[](accounts.length);
1117 
1118         for (uint256 i = 0; i < accounts.length; ++i) {
1119             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1120         }
1121 
1122         return batchBalances;
1123     }
1124 
1125     /* ============ Internal Functions ============ */
1126     /* ============ Private Functions ============ */
1127     /**
1128      * Create star with `powah`, and assign it to `account`.
1129      *
1130      * Emits a {TransferSingle} event.
1131      *
1132      * Requirements:
1133      * - `account` must not be zero address.
1134      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1135      * acceptance magic value.
1136      */
1137     function _mint(address account, uint256 powah) private returns (uint256) {
1138         require(account != address(0), "Must not mint to null address");
1139         starCount++;
1140         uint256 sID = starCount;
1141         starBelongTo[sID] = account;
1142         //        _stars[sID] = NFTInfo({
1143         //        powah : uint128(powah),
1144         //        mintBlock : uint128(block.number),
1145         //        originator : address(0)
1146         //        });
1147 
1148         emit TransferSingle(msg.sender, address(0), account, sID, 1);
1149 
1150         _doSafeTransferAcceptanceCheck(msg.sender, address(0), account, sID, 1, "");
1151 
1152         return sID;
1153     }
1154 
1155     /**
1156      * Mint `amount` star nft to `to`
1157      *
1158      * Requirements:
1159      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1160      * acceptance magic value.
1161      */
1162     function _mintBatch(address to, uint256 amount, uint256[] calldata powahArr) private returns (uint256[] memory) {
1163         uint256[] memory ids = new uint256[](amount);
1164         uint256[] memory amounts = new uint256[](amount);
1165         for (uint i = 0; i < ids.length; i++) {
1166             starCount++;
1167             starBelongTo[starCount] = to;
1168             //            _stars[_starCount] = NFTInfo({
1169             //            powah : uint128(powahArr[i]),
1170             //            mintBlock : uint128(block.number),
1171             //            originator : to
1172             //            });
1173             ids[i] = starCount;
1174             amounts[i] = 1;
1175         }
1176 
1177         emit TransferBatch(msg.sender, address(0), to, ids, amounts);
1178 
1179         _doSafeBatchTransferAcceptanceCheck(msg.sender, address(0), to, ids, amounts, "");
1180 
1181         return ids;
1182     }
1183 
1184     /**
1185      * Burn `id` nft from `account`.
1186      */
1187     function _burn(address account, uint256 id) private {
1188         delete starBelongTo[id];
1189 
1190         emit TransferSingle(msg.sender, account, address(0), id, 1);
1191     }
1192 
1193     /**
1194      * xref:ROOT:erc1155.doc#batch-operations[Batched] version of {_burn}.
1195      *
1196      * Requirements:
1197      * - `ids` and `amounts` must have the same length.
1198      */
1199     function _burnBatch(address account, uint256[] memory ids) private {
1200         uint256[] memory amounts = new uint256[](ids.length);
1201         for (uint i = 0; i < ids.length; i++) {
1202             delete starBelongTo[ids[i]];
1203             //            delete _quasars[ids[i]];
1204             //            delete _supers[ids[i]];
1205             //            delete _stars[ids[i]];
1206             amounts[i] = 1;
1207         }
1208 
1209         emit TransferBatch(msg.sender, account, address(0), ids, amounts);
1210     }
1211 
1212     function _doSafeTransferAcceptanceCheck(address operator, address from, address to, uint256 id, uint256 amount, bytes memory data) private {
1213         if (to.isContract()) {
1214             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1215                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1216                     revert("ERC1155Receiver rejected tokens");
1217                 }
1218             } catch Error(string memory reason) {
1219                 revert(reason);
1220             } catch {
1221                 revert("transfer to non ERC1155Receiver implementer");
1222             }
1223         }
1224     }
1225 
1226     function _doSafeBatchTransferAcceptanceCheck(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) private {
1227         if (to.isContract()) {
1228             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1229                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1230                     revert("ERC1155Receiver rejected tokens");
1231                 }
1232             } catch Error(string memory reason) {
1233                 revert(reason);
1234             } catch {
1235                 revert("transfer to non ERC1155Receiver implementer");
1236             }
1237         }
1238     }
1239 
1240     /* ============ Util Functions ============ */
1241     function uint2str(uint _i) internal pure returns (string memory) {
1242         if (_i == 0) {
1243             return "0";
1244         }
1245         uint j = _i;
1246         uint len;
1247         while (j != 0) {
1248             len++;
1249             j /= 10;
1250         }
1251         bytes memory bStr = new bytes(len);
1252         uint k = len;
1253         while (_i != 0) {
1254             k = k - 1;
1255             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1256             bytes1 b1 = bytes1(temp);
1257             bStr[k] = b1;
1258             _i /= 10;
1259         }
1260         return string(bStr);
1261     }
1262 }