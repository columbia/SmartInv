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
239 // Part: ERC165Checker
240 
241 /**
242  * @dev Library used to query support of an interface declared via {IERC165}.
243  *
244  * Note that these functions return the actual result of the query: they do not
245  * `revert` if an interface is not supported. It is up to the caller to decide
246  * what to do in these cases.
247  */
248 library ERC165Checker {
249     // As per the EIP-165 spec, no interface should ever match 0xffffffff
250     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
251 
252     /*
253      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
254      */
255     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
256 
257     /**
258      * @dev Returns true if `account` supports the {IERC165} interface,
259      */
260     function supportsERC165(address account) internal view returns (bool) {
261         // Any contract that implements ERC165 must explicitly indicate support of
262         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
263         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
264             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
265     }
266 
267     /**
268      * @dev Returns true if `account` supports the interface defined by
269      * `interfaceId`. Support for {IERC165} itself is queried automatically.
270      *
271      * See {IERC165-supportsInterface}.
272      */
273     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
274         // query support of both ERC165 as per the spec and support of _interfaceId
275         return supportsERC165(account) &&
276             _supportsERC165Interface(account, interfaceId);
277     }
278 
279     /**
280      * @dev Returns a boolean array where each value corresponds to the
281      * interfaces passed in and whether they're supported or not. This allows
282      * you to batch check interfaces for a contract where your expectation
283      * is that some interfaces may not be supported.
284      *
285      * See {IERC165-supportsInterface}.
286      *
287      * _Available since v3.4._
288      */
289     function getSupportedInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool[] memory) {
290         // an array of booleans corresponding to interfaceIds and whether they're supported or not
291         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
292 
293         // query support of ERC165 itself
294         if (supportsERC165(account)) {
295             // query support of each interface in interfaceIds
296             for (uint256 i = 0; i < interfaceIds.length; i++) {
297                 interfaceIdsSupported[i] = _supportsERC165Interface(account, interfaceIds[i]);
298             }
299         }
300 
301         return interfaceIdsSupported;
302     }
303 
304     /**
305      * @dev Returns true if `account` supports all the interfaces defined in
306      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
307      *
308      * Batch-querying can lead to gas savings by skipping repeated checks for
309      * {IERC165} support.
310      *
311      * See {IERC165-supportsInterface}.
312      */
313     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
314         // query support of ERC165 itself
315         if (!supportsERC165(account)) {
316             return false;
317         }
318 
319         // query support of each interface in _interfaceIds
320         for (uint256 i = 0; i < interfaceIds.length; i++) {
321             if (!_supportsERC165Interface(account, interfaceIds[i])) {
322                 return false;
323             }
324         }
325 
326         // all interfaces supported
327         return true;
328     }
329 
330     /**
331      * @notice Query if a contract implements an interface, does not check ERC165 support
332      * @param account The address of the contract to query for support of an interface
333      * @param interfaceId The interface identifier, as specified in ERC-165
334      * @return true if the contract at account indicates support of the interface with
335      * identifier interfaceId, false otherwise
336      * @dev Assumes that account contains a contract that supports ERC165, otherwise
337      * the behavior of this method is undefined. This precondition can be checked
338      * with {supportsERC165}.
339      * Interface identification is specified in ERC-165.
340      */
341     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
342         // success determines whether the staticcall succeeded and result determines
343         // whether the contract at account indicates support of _interfaceId
344         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
345 
346         return (success && result);
347     }
348 
349     /**
350      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
351      * @param account The address of the contract to query for support of an interface
352      * @param interfaceId The interface identifier, as specified in ERC-165
353      * @return success true if the STATICCALL succeeded, false otherwise
354      * @return result true if the STATICCALL succeeded and the contract at account
355      * indicates support of the interface with identifier interfaceId, false otherwise
356      */
357     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
358         private
359         view
360         returns (bool, bool)
361     {
362         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
363         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
364         if (result.length < 32) return (false, false);
365         return (success, abi.decode(result, (bool)));
366     }
367 }
368 
369 // Part: IERC165
370 
371 /**
372  * @dev Interface of the ERC165 standard, as defined in the
373  * https://eips.ethereum.org/EIPS/eip-165[EIP].
374  *
375  * Implementers can declare support of contract interfaces, which can then be
376  * queried by others ({ERC165Checker}).
377  *
378  * For an implementation, see {ERC165}.
379  */
380 interface IERC165 {
381     /**
382      * @dev Returns true if this contract implements the interface defined by
383      * `interfaceId`. See the corresponding
384      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
385      * to learn more about how these ids are created.
386      *
387      * This function call must use less than 30 000 gas.
388      */
389     function supportsInterface(bytes4 interfaceId) external view returns (bool);
390 }
391 
392 // Part: SafeMath
393 
394 /**
395  * @dev Wrappers over Solidity's arithmetic operations with added overflow
396  * checks.
397  *
398  * Arithmetic operations in Solidity wrap on overflow. This can easily result
399  * in bugs, because programmers usually assume that an overflow raises an
400  * error, which is the standard behavior in high level programming languages.
401  * `SafeMath` restores this intuition by reverting the transaction when an
402  * operation overflows.
403  *
404  * Using this library instead of the unchecked operations eliminates an entire
405  * class of bugs, so it's recommended to use it always.
406  */
407 library SafeMath {
408     /**
409      * @dev Returns the addition of two unsigned integers, with an overflow flag.
410      *
411      * _Available since v3.4._
412      */
413     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
414         uint256 c = a + b;
415         if (c < a) return (false, 0);
416         return (true, c);
417     }
418 
419     /**
420      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
421      *
422      * _Available since v3.4._
423      */
424     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
425         if (b > a) return (false, 0);
426         return (true, a - b);
427     }
428 
429     /**
430      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
431      *
432      * _Available since v3.4._
433      */
434     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
435         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
436         // benefit is lost if 'b' is also tested.
437         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
438         if (a == 0) return (true, 0);
439         uint256 c = a * b;
440         if (c / a != b) return (false, 0);
441         return (true, c);
442     }
443 
444     /**
445      * @dev Returns the division of two unsigned integers, with a division by zero flag.
446      *
447      * _Available since v3.4._
448      */
449     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
450         if (b == 0) return (false, 0);
451         return (true, a / b);
452     }
453 
454     /**
455      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
456      *
457      * _Available since v3.4._
458      */
459     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
460         if (b == 0) return (false, 0);
461         return (true, a % b);
462     }
463 
464     /**
465      * @dev Returns the addition of two unsigned integers, reverting on
466      * overflow.
467      *
468      * Counterpart to Solidity's `+` operator.
469      *
470      * Requirements:
471      *
472      * - Addition cannot overflow.
473      */
474     function add(uint256 a, uint256 b) internal pure returns (uint256) {
475         uint256 c = a + b;
476         require(c >= a, "SafeMath: addition overflow");
477         return c;
478     }
479 
480     /**
481      * @dev Returns the subtraction of two unsigned integers, reverting on
482      * overflow (when the result is negative).
483      *
484      * Counterpart to Solidity's `-` operator.
485      *
486      * Requirements:
487      *
488      * - Subtraction cannot overflow.
489      */
490     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
491         require(b <= a, "SafeMath: subtraction overflow");
492         return a - b;
493     }
494 
495     /**
496      * @dev Returns the multiplication of two unsigned integers, reverting on
497      * overflow.
498      *
499      * Counterpart to Solidity's `*` operator.
500      *
501      * Requirements:
502      *
503      * - Multiplication cannot overflow.
504      */
505     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
506         if (a == 0) return 0;
507         uint256 c = a * b;
508         require(c / a == b, "SafeMath: multiplication overflow");
509         return c;
510     }
511 
512     /**
513      * @dev Returns the integer division of two unsigned integers, reverting on
514      * division by zero. The result is rounded towards zero.
515      *
516      * Counterpart to Solidity's `/` operator. Note: this function uses a
517      * `revert` opcode (which leaves remaining gas untouched) while Solidity
518      * uses an invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function div(uint256 a, uint256 b) internal pure returns (uint256) {
525         require(b > 0, "SafeMath: division by zero");
526         return a / b;
527     }
528 
529     /**
530      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
531      * reverting when dividing by zero.
532      *
533      * Counterpart to Solidity's `%` operator. This function uses a `revert`
534      * opcode (which leaves remaining gas untouched) while Solidity uses an
535      * invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
542         require(b > 0, "SafeMath: modulo by zero");
543         return a % b;
544     }
545 
546     /**
547      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
548      * overflow (when the result is negative).
549      *
550      * CAUTION: This function is deprecated because it requires allocating memory for the error
551      * message unnecessarily. For custom revert reasons use {trySub}.
552      *
553      * Counterpart to Solidity's `-` operator.
554      *
555      * Requirements:
556      *
557      * - Subtraction cannot overflow.
558      */
559     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b <= a, errorMessage);
561         return a - b;
562     }
563 
564     /**
565      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
566      * division by zero. The result is rounded towards zero.
567      *
568      * CAUTION: This function is deprecated because it requires allocating memory for the error
569      * message unnecessarily. For custom revert reasons use {tryDiv}.
570      *
571      * Counterpart to Solidity's `/` operator. Note: this function uses a
572      * `revert` opcode (which leaves remaining gas untouched) while Solidity
573      * uses an invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
580         require(b > 0, errorMessage);
581         return a / b;
582     }
583 
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * reverting with custom message when dividing by zero.
587      *
588      * CAUTION: This function is deprecated because it requires allocating memory for the error
589      * message unnecessarily. For custom revert reasons use {tryMod}.
590      *
591      * Counterpart to Solidity's `%` operator. This function uses a `revert`
592      * opcode (which leaves remaining gas untouched) while Solidity uses an
593      * invalid opcode to revert (consuming all remaining gas).
594      *
595      * Requirements:
596      *
597      * - The divisor cannot be zero.
598      */
599     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
600         require(b > 0, errorMessage);
601         return a % b;
602     }
603 }
604 
605 // Part: ERC165
606 
607 /**
608  * @dev Implementation of the {IERC165} interface.
609  *
610  * Contracts may inherit from this and call {_registerInterface} to declare
611  * their support of an interface.
612  */
613 abstract contract ERC165 is IERC165 {
614     /*
615      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
616      */
617     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
618 
619     /**
620      * @dev Mapping of interface ids to whether or not it's supported.
621      */
622     mapping(bytes4 => bool) private _supportedInterfaces;
623 
624     constructor () internal {
625         // Derived contracts need only register support for their own interfaces,
626         // we register support for ERC165 itself here
627         _registerInterface(_INTERFACE_ID_ERC165);
628     }
629 
630     /**
631      * @dev See {IERC165-supportsInterface}.
632      *
633      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
634      */
635     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
636         return _supportedInterfaces[interfaceId];
637     }
638 
639     /**
640      * @dev Registers the contract as an implementer of the interface defined by
641      * `interfaceId`. Support of the actual ERC165 interface is automatic and
642      * registering its interface id is not required.
643      *
644      * See {IERC165-supportsInterface}.
645      *
646      * Requirements:
647      *
648      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
649      */
650     function _registerInterface(bytes4 interfaceId) internal virtual {
651         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
652         _supportedInterfaces[interfaceId] = true;
653     }
654 }
655 
656 // Part: IERC1155
657 
658 /**
659  * @dev Required interface of an ERC1155 compliant contract, as defined in the
660  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
661  *
662  * _Available since v3.1._
663  */
664 interface IERC1155 is IERC165 {
665     /**
666      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
667      */
668     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
669 
670     /**
671      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
672      * transfers.
673      */
674     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
675 
676     /**
677      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
678      * `approved`.
679      */
680     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
681 
682     /**
683      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
684      *
685      * If an {URI} event was emitted for `id`, the standard
686      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
687      * returned by {IERC1155MetadataURI-uri}.
688      */
689     event URI(string value, uint256 indexed id);
690 
691     /**
692      * @dev Returns the amount of tokens of token type `id` owned by `account`.
693      *
694      * Requirements:
695      *
696      * - `account` cannot be the zero address.
697      */
698     function balanceOf(address account, uint256 id) external view returns (uint256);
699 
700     /**
701      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
702      *
703      * Requirements:
704      *
705      * - `accounts` and `ids` must have the same length.
706      */
707     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
708 
709     /**
710      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
711      *
712      * Emits an {ApprovalForAll} event.
713      *
714      * Requirements:
715      *
716      * - `operator` cannot be the caller.
717      */
718     function setApprovalForAll(address operator, bool approved) external;
719 
720     /**
721      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
722      *
723      * See {setApprovalForAll}.
724      */
725     function isApprovedForAll(address account, address operator) external view returns (bool);
726 
727     /**
728      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
729      *
730      * Emits a {TransferSingle} event.
731      *
732      * Requirements:
733      *
734      * - `to` cannot be the zero address.
735      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
736      * - `from` must have a balance of tokens of type `id` of at least `amount`.
737      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
738      * acceptance magic value.
739      */
740     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
741 
742     /**
743      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
744      *
745      * Emits a {TransferBatch} event.
746      *
747      * Requirements:
748      *
749      * - `ids` and `amounts` must have the same length.
750      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
751      * acceptance magic value.
752      */
753     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
754 }
755 
756 // Part: IERC1155Receiver
757 
758 /**
759  * _Available since v3.1._
760  */
761 interface IERC1155Receiver is IERC165 {
762 
763     /**
764         @dev Handles the receipt of a single ERC1155 token type. This function is
765         called at the end of a `safeTransferFrom` after the balance has been updated.
766         To accept the transfer, this must return
767         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
768         (i.e. 0xf23a6e61, or its own function selector).
769         @param operator The address which initiated the transfer (i.e. msg.sender)
770         @param from The address which previously owned the token
771         @param id The ID of the token being transferred
772         @param value The amount of tokens being transferred
773         @param data Additional data with no specified format
774         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
775     */
776     function onERC1155Received(
777         address operator,
778         address from,
779         uint256 id,
780         uint256 value,
781         bytes calldata data
782     )
783         external
784         returns(bytes4);
785 
786     /**
787         @dev Handles the receipt of a multiple ERC1155 token types. This function
788         is called at the end of a `safeBatchTransferFrom` after the balances have
789         been updated. To accept the transfer(s), this must return
790         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
791         (i.e. 0xbc197c81, or its own function selector).
792         @param operator The address which initiated the batch transfer (i.e. msg.sender)
793         @param from The address which previously owned the token
794         @param ids An array containing ids of each token being transferred (order and length must match values array)
795         @param values An array containing amounts of each token being transferred (order and length must match ids array)
796         @param data Additional data with no specified format
797         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
798     */
799     function onERC1155BatchReceived(
800         address operator,
801         address from,
802         uint256[] calldata ids,
803         uint256[] calldata values,
804         bytes calldata data
805     )
806         external
807         returns(bytes4);
808 }
809 
810 // Part: Ownable
811 
812 /**
813  * @dev Contract module which provides a basic access control mechanism, where
814  * there is an account (an owner) that can be granted exclusive access to
815  * specific functions.
816  *
817  * By default, the owner account will be the one that deploys the contract. This
818  * can later be changed with {transferOwnership}.
819  *
820  * This module is used through inheritance. It will make available the modifier
821  * `onlyOwner`, which can be applied to your functions to restrict their use to
822  * the owner.
823  */
824 abstract contract Ownable is Context {
825     address private _owner;
826 
827     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
828 
829     /**
830      * @dev Initializes the contract setting the deployer as the initial owner.
831      */
832     constructor () internal {
833         address msgSender = _msgSender();
834         _owner = msgSender;
835         emit OwnershipTransferred(address(0), msgSender);
836     }
837 
838     /**
839      * @dev Returns the address of the current owner.
840      */
841     function owner() public view virtual returns (address) {
842         return _owner;
843     }
844 
845     /**
846      * @dev Throws if called by any account other than the owner.
847      */
848     modifier onlyOwner() {
849         require(owner() == _msgSender(), "Ownable: caller is not the owner");
850         _;
851     }
852 
853     /**
854      * @dev Leaves the contract without owner. It will not be possible to call
855      * `onlyOwner` functions anymore. Can only be called by the current owner.
856      *
857      * NOTE: Renouncing ownership will leave the contract without an owner,
858      * thereby removing any functionality that is only available to the owner.
859      */
860     function renounceOwnership() public virtual onlyOwner {
861         emit OwnershipTransferred(_owner, address(0));
862         _owner = address(0);
863     }
864 
865     /**
866      * @dev Transfers ownership of the contract to a new account (`newOwner`).
867      * Can only be called by the current owner.
868      */
869     function transferOwnership(address newOwner) public virtual onlyOwner {
870         require(newOwner != address(0), "Ownable: new owner is the zero address");
871         emit OwnershipTransferred(_owner, newOwner);
872         _owner = newOwner;
873     }
874 }
875 
876 // Part: IERC1155MetadataURI
877 
878 /**
879  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
880  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
881  *
882  * _Available since v3.1._
883  */
884 interface IERC1155MetadataURI is IERC1155 {
885     /**
886      * @dev Returns the URI for token type `id`.
887      *
888      * If the `\{id\}` substring is present in the URI, it must be replaced by
889      * clients with the actual token type ID.
890      */
891     function uri(uint256 id) external view returns (string memory);
892 }
893 
894 // Part: IStarNFT
895 
896 /**
897  * @title IStarNFT
898  * @author Galaxy Protocol
899  *
900  * Interface for operating with StarNFTs.
901  */
902 interface IStarNFT is IERC1155 {
903     /* ============ Events =============== */
904 //    event PowahUpdated(uint256 indexed id, uint256 indexed oldPoints, uint256 indexed newPoints);
905 
906     /* ============ Functions ============ */
907 
908     function isOwnerOf(address, uint256) external view returns (bool);
909 //    function starInfo(uint256) external view returns (uint128 powah, uint128 mintBlock, address originator);
910 //    function quasarInfo(uint256) external view returns (uint128 mintBlock, IERC20 stakeToken, uint256 amount, uint256 campaignID);
911 //    function superInfo(uint256) external view returns (uint128 mintBlock, IERC20[] memory stakeToken, uint256[] memory amount, uint256 campaignID);
912 
913     // mint
914     function mint(address account, uint256 powah) external returns (uint256);
915     function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external returns (uint256[] memory);
916     function burn(address account, uint256 id) external;
917     function burnBatch(address account, uint256[] calldata ids) external;
918 
919     // asset-backing mint
920 //    function mintQuasar(address account, uint256 powah, uint256 cid, IERC20 stakeToken, uint256 amount) external returns (uint256);
921 //    function burnQuasar(address account, uint256 id) external;
922 
923     // asset-backing forge
924 //    function mintSuper(address account, uint256 powah, uint256 campaignID, IERC20[] calldata stakeTokens, uint256[] calldata amounts) external returns (uint256);
925 //    function burnSuper(address account, uint256 id) external;
926     // update
927 //    function updatePowah(address owner, uint256 id, uint256 powah) external;
928 }
929 
930 // File: StarNFTV1.sol
931 
932 //import "../../interfaces/listener/IStarUpdateListener.sol";
933 
934 
935 /**
936  * based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol
937  */
938 contract StarNFTV1 is ERC165, IERC1155, IERC1155MetadataURI, IStarNFT, Ownable {
939     using SafeMath for uint256;
940     using Address for address;
941     using ERC165Checker for address;
942 
943     /* ============ Events ============ */
944     /* ============ Modifiers ============ */
945     /**
946      * Only minter.
947      */
948     modifier onlyMinter() {
949         require(minters[msg.sender], "must be minter");
950         _;
951     }
952     /* ============ Enums ================ */
953     /* ============ Structs ============ */
954     /* ============ State Variables ============ */
955 
956     // Used as the URI for all token types by ID substitution, e.g. https://galaxy.eco/{address}/{id}.json
957     string public baseURI;
958 
959     // Mint and burn star.
960     mapping(address => bool) public minters;
961 
962     // Total star count, including burnt nft
963     uint256 public starCount;
964     // Mapping from token ID to account
965     mapping(uint256 => address) public starBelongTo;
966 
967     // Mapping from account to operator approvals
968     mapping(address => mapping(address => bool)) private _operatorApprovals;
969 
970 
971     /* ============ Constructor ============ */
972     constructor () public {}
973 
974     /* ============ External Functions ============ */
975     /**
976      * See {IERC1155-setApprovalForAll}.
977      */
978     function setApprovalForAll(address operator, bool approved) external override {
979         require(msg.sender != operator, "Setting approval status for self");
980 
981         _operatorApprovals[msg.sender][operator] = approved;
982         emit ApprovalForAll(msg.sender, operator, approved);
983     }
984 
985     /**
986      * See {IERC1155-safeTransferFrom}.
987      */
988     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) external override {
989         require(to != address(0), "Transfer to must not be null address");
990         require(amount == 1, "Invalid amount");
991         require(
992             from == msg.sender || isApprovedForAll(from, msg.sender),
993             "Transfer caller is neither owner nor approved"
994         );
995         require(isOwnerOf(from, id), "Not the owner");
996 
997         starBelongTo[id] = to;
998 
999         emit TransferSingle(msg.sender, from, to, id, amount);
1000 
1001         _doSafeTransferAcceptanceCheck(msg.sender, from, to, id, amount, data);
1002     }
1003 
1004     /**
1005      * See {IERC1155-safeBatchTransferFrom}.
1006      */
1007     function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) external override {
1008         require(to != address(0), "Batch transfer to must not be null address");
1009         require(ids.length == amounts.length, "Array(ids, amounts) length mismatch");
1010         require(from == msg.sender || isApprovedForAll(from, msg.sender), "Transfer caller is neither owner nor approved");
1011 
1012         for (uint256 i = 0; i < ids.length; ++i) {
1013             uint256 id = ids[i];
1014             require(isOwnerOf(from, id), "Not the owner");
1015             starBelongTo[id] = to;
1016         }
1017 
1018         emit TransferBatch(msg.sender, from, to, ids, amounts);
1019 
1020         _doSafeBatchTransferAcceptanceCheck(msg.sender, from, to, ids, amounts, data);
1021     }
1022 
1023     function mint(address account, uint256 powah) external onlyMinter override returns (uint256) {
1024         return _mint(account, powah);
1025     }
1026 
1027     function mintBatch(address account, uint256 amount, uint256[] calldata powahArr) external onlyMinter override returns (uint256[] memory) {
1028         require(account != address(0), "Must not mint to null address");
1029         require(powahArr.length == amount, "Array(powah) length mismatch param(amount)");
1030         return _mintBatch(account, amount, powahArr);
1031     }
1032 
1033     function burn(address account, uint256 id) external onlyMinter override {
1034         require(isOwnerOf(account, id), "Not the owner");
1035         _burn(account, id);
1036     }
1037 
1038     function burnBatch(address account, uint256[] calldata ids) external onlyMinter override {
1039         for (uint i = 0; i < ids.length; i++) {
1040             require(isOwnerOf(account, ids[i]), "Not the owner");
1041         }
1042         _burnBatch(account, ids);
1043     }
1044 
1045     /**
1046      * PRIVILEGED MODULE FUNCTION. Sets a new baseURI for all token types.
1047      */
1048     function setURI(string memory newURI) external onlyOwner {
1049         baseURI = newURI;
1050     }
1051 
1052     /**
1053      * PRIVILEGED MODULE FUNCTION. Add a new minter.
1054      */
1055     function addMinter(address minter) external onlyOwner {
1056         require(minter != address(0), "Minter must not be null address");
1057         require(!minters[minter], "Minter already added");
1058         minters[minter] = true;
1059     }
1060 
1061     /**
1062      * PRIVILEGED MODULE FUNCTION. Remove a old minter.
1063      */
1064     function removeMinter(address minter) external onlyOwner {
1065         require(minters[minter], "Minter does not exist");
1066         delete minters[minter];
1067     }
1068 
1069     /* ============ External Getter Functions ============ */
1070     /**
1071      * See {IERC1155-isApprovedForAll}.
1072      */
1073     function isApprovedForAll(address account, address operator) public view override returns (bool) {
1074         return _operatorApprovals[account][operator];
1075     }
1076 
1077     /**
1078      * See {IERC1155MetadataURI-uri}.
1079      *
1080      * This implementation returns the same URI for *all* token types. It relies
1081      * on the token type ID substitution mechanism
1082      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1083      *
1084      * Clients calling this function must replace the `\{id\}` substring with the
1085      * actual token type ID.
1086      */
1087     function uri(uint256 id) external view override returns (string memory) {
1088         require(id <= starCount, "NFT does not exist");
1089         // Even if there is a base URI, it is only appended to non-empty token-specific URIs
1090         if (bytes(baseURI).length == 0) {
1091             return "";
1092         } else {
1093             // bytes memory b = new bytes(32);
1094             // assembly { mstore(add(b, 32), id) }
1095             // abi.encodePacked is being used to concatenate strings
1096             return string(abi.encodePacked(baseURI, uint2str(id), ".json"));
1097         }
1098     }
1099 
1100     /**
1101      * Is the nft owner.
1102      * Requirements:
1103      * - `account` must not be zero address.
1104      */
1105     function isOwnerOf(address account, uint256 id) public view override returns (bool) {
1106         if (account == address(0)) {
1107             return false;
1108         } else {
1109             return starBelongTo[id] == account;
1110         }
1111     }
1112 
1113     /**
1114      * See {IERC1155-balanceOf}.
1115      * Requirements:
1116      * - `account` must not be zero address.
1117      */
1118     function balanceOf(address account, uint256 id) public view override returns (uint256) {
1119         if (isOwnerOf(account, id)) {
1120             return 1;
1121         }
1122         return 0;
1123     }
1124 
1125     /**
1126      * See {IERC1155-balanceOfBatch}.
1127      * Requirements:
1128      * - `accounts` and `ids` must have the same length.
1129      */
1130     function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view override returns (uint256[] memory){
1131         require(accounts.length == ids.length, "Array(accounts, ids) length mismatch");
1132 
1133         uint256[] memory batchBalances = new uint256[](accounts.length);
1134 
1135         for (uint256 i = 0; i < accounts.length; ++i) {
1136             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1137         }
1138 
1139         return batchBalances;
1140     }
1141 
1142     /* ============ Internal Functions ============ */
1143     /* ============ Private Functions ============ */
1144     /**
1145      * Create star with `powah`, and assign it to `account`.
1146      *
1147      * Emits a {TransferSingle} event.
1148      *
1149      * Requirements:
1150      * - `account` must not be zero address.
1151      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1152      * acceptance magic value.
1153      */
1154     function _mint(address account, uint256 powah) private returns (uint256) {
1155         require(account != address(0), "Must not mint to null address");
1156         starCount++;
1157         uint256 sID = starCount;
1158         starBelongTo[sID] = account;
1159         //        _stars[sID] = NFTInfo({
1160         //        powah : uint128(powah),
1161         //        mintBlock : uint128(block.number),
1162         //        originator : address(0)
1163         //        });
1164 
1165         emit TransferSingle(msg.sender, address(0), account, sID, 1);
1166 
1167         _doSafeTransferAcceptanceCheck(msg.sender, address(0), account, sID, 1, "");
1168 
1169         return sID;
1170     }
1171 
1172     /**
1173      * Mint `amount` star nft to `to`
1174      *
1175      * Requirements:
1176      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1177      * acceptance magic value.
1178      */
1179     function _mintBatch(address to, uint256 amount, uint256[] calldata powahArr) private returns (uint256[] memory) {
1180         uint256[] memory ids = new uint256[](amount);
1181         uint256[] memory amounts = new uint256[](amount);
1182         for (uint i = 0; i < ids.length; i++) {
1183             starCount++;
1184             starBelongTo[starCount] = to;
1185             //            _stars[_starCount] = NFTInfo({
1186             //            powah : uint128(powahArr[i]),
1187             //            mintBlock : uint128(block.number),
1188             //            originator : to
1189             //            });
1190             ids[i] = starCount;
1191             amounts[i] = 1;
1192         }
1193 
1194         emit TransferBatch(msg.sender, address(0), to, ids, amounts);
1195 
1196         _doSafeBatchTransferAcceptanceCheck(msg.sender, address(0), to, ids, amounts, "");
1197 
1198         return ids;
1199     }
1200 
1201     /**
1202      * Burn `id` nft from `account`.
1203      */
1204     function _burn(address account, uint256 id) private {
1205         delete starBelongTo[id];
1206 
1207         emit TransferSingle(msg.sender, account, address(0), id, 1);
1208     }
1209 
1210     /**
1211      * xref:ROOT:erc1155.doc#batch-operations[Batched] version of {_burn}.
1212      *
1213      * Requirements:
1214      * - `ids` and `amounts` must have the same length.
1215      */
1216     function _burnBatch(address account, uint256[] memory ids) private {
1217         uint256[] memory amounts = new uint256[](ids.length);
1218         for (uint i = 0; i < ids.length; i++) {
1219             delete starBelongTo[ids[i]];
1220             //            delete _quasars[ids[i]];
1221             //            delete _supers[ids[i]];
1222             //            delete _stars[ids[i]];
1223             amounts[i] = 1;
1224         }
1225 
1226         emit TransferBatch(msg.sender, account, address(0), ids, amounts);
1227     }
1228 
1229     function _doSafeTransferAcceptanceCheck(address operator, address from, address to, uint256 id, uint256 amount, bytes memory data) private {
1230         if (to.isContract()) {
1231             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1232                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
1233                     revert("ERC1155Receiver rejected tokens");
1234                 }
1235             } catch Error(string memory reason) {
1236                 revert(reason);
1237             } catch {
1238                 revert("transfer to non ERC1155Receiver implementer");
1239             }
1240         }
1241     }
1242 
1243     function _doSafeBatchTransferAcceptanceCheck(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) private {
1244         if (to.isContract()) {
1245             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
1246                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1247                     revert("ERC1155Receiver rejected tokens");
1248                 }
1249             } catch Error(string memory reason) {
1250                 revert(reason);
1251             } catch {
1252                 revert("transfer to non ERC1155Receiver implementer");
1253             }
1254         }
1255     }
1256 
1257     /* ============ Util Functions ============ */
1258     function uint2str(uint _i) internal pure returns (string memory) {
1259         if (_i == 0) {
1260             return "0";
1261         }
1262         uint j = _i;
1263         uint len;
1264         while (j != 0) {
1265             len++;
1266             j /= 10;
1267         }
1268         bytes memory bStr = new bytes(len);
1269         uint k = len;
1270         while (_i != 0) {
1271             k = k - 1;
1272             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
1273             bytes1 b1 = bytes1(temp);
1274             bStr[k] = b1;
1275             _i /= 10;
1276         }
1277         return string(bStr);
1278     }
1279 }
