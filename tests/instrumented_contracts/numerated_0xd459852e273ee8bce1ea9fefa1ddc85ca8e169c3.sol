1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
219 
220 
221 pragma solidity >=0.6.0 <0.8.0;
222 
223 /**
224  * @dev Interface of the ERC20 standard as defined in the EIP.
225  */
226 interface IERC20 {
227     /**
228      * @dev Returns the amount of tokens in existence.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     /**
233      * @dev Returns the amount of tokens owned by `account`.
234      */
235     function balanceOf(address account) external view returns (uint256);
236 
237     /**
238      * @dev Moves `amount` tokens from the caller's account to `recipient`.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transfer(address recipient, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Returns the remaining number of tokens that `spender` will be
248      * allowed to spend on behalf of `owner` through {transferFrom}. This is
249      * zero by default.
250      *
251      * This value changes when {approve} or {transferFrom} are called.
252      */
253     function allowance(address owner, address spender) external view returns (uint256);
254 
255     /**
256      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * IMPORTANT: Beware that changing an allowance with this method brings the risk
261      * that someone may use both the old and the new allowance by unfortunate
262      * transaction ordering. One possible solution to mitigate this race
263      * condition is to first reduce the spender's allowance to 0 and set the
264      * desired value afterwards:
265      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266      *
267      * Emits an {Approval} event.
268      */
269     function approve(address spender, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Moves `amount` tokens from `sender` to `recipient` using the
273      * allowance mechanism. `amount` is then deducted from the caller's
274      * allowance.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Emitted when `value` tokens are moved from one account (`from`) to
284      * another (`to`).
285      *
286      * Note that `value` may be zero.
287      */
288     event Transfer(address indexed from, address indexed to, uint256 value);
289 
290     /**
291      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
292      * a call to {approve}. `value` is the new allowance.
293      */
294     event Approval(address indexed owner, address indexed spender, uint256 value);
295 }
296 
297 // File: @openzeppelin/contracts/introspection/IERC165.sol
298 
299 
300 pragma solidity >=0.6.0 <0.8.0;
301 
302 /**
303  * @dev Interface of the ERC165 standard, as defined in the
304  * https://eips.ethereum.org/EIPS/eip-165[EIP].
305  *
306  * Implementers can declare support of contract interfaces, which can then be
307  * queried by others ({ERC165Checker}).
308  *
309  * For an implementation, see {ERC165}.
310  */
311 interface IERC165 {
312     /**
313      * @dev Returns true if this contract implements the interface defined by
314      * `interfaceId`. See the corresponding
315      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
316      * to learn more about how these ids are created.
317      *
318      * This function call must use less than 30 000 gas.
319      */
320     function supportsInterface(bytes4 interfaceId) external view returns (bool);
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
324 
325 
326 pragma solidity >=0.6.2 <0.8.0;
327 
328 
329 /**
330  * @dev Required interface of an ERC1155 compliant contract, as defined in the
331  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
332  *
333  * _Available since v3.1._
334  */
335 interface IERC1155 is IERC165 {
336     /**
337      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
338      */
339     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
340 
341     /**
342      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
343      * transfers.
344      */
345     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
346 
347     /**
348      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
349      * `approved`.
350      */
351     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
352 
353     /**
354      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
355      *
356      * If an {URI} event was emitted for `id`, the standard
357      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
358      * returned by {IERC1155MetadataURI-uri}.
359      */
360     event URI(string value, uint256 indexed id);
361 
362     /**
363      * @dev Returns the amount of tokens of token type `id` owned by `account`.
364      *
365      * Requirements:
366      *
367      * - `account` cannot be the zero address.
368      */
369     function balanceOf(address account, uint256 id) external view returns (uint256);
370 
371     /**
372      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
373      *
374      * Requirements:
375      *
376      * - `accounts` and `ids` must have the same length.
377      */
378     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
379 
380     /**
381      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
382      *
383      * Emits an {ApprovalForAll} event.
384      *
385      * Requirements:
386      *
387      * - `operator` cannot be the caller.
388      */
389     function setApprovalForAll(address operator, bool approved) external;
390 
391     /**
392      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
393      *
394      * See {setApprovalForAll}.
395      */
396     function isApprovedForAll(address account, address operator) external view returns (bool);
397 
398     /**
399      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
400      *
401      * Emits a {TransferSingle} event.
402      *
403      * Requirements:
404      *
405      * - `to` cannot be the zero address.
406      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
407      * - `from` must have a balance of tokens of type `id` of at least `amount`.
408      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
409      * acceptance magic value.
410      */
411     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
412 
413     /**
414      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
415      *
416      * Emits a {TransferBatch} event.
417      *
418      * Requirements:
419      *
420      * - `ids` and `amounts` must have the same length.
421      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
422      * acceptance magic value.
423      */
424     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
425 }
426 
427 // File: @openzeppelin/contracts/utils/Address.sol
428 
429 
430 pragma solidity >=0.6.2 <0.8.0;
431 
432 /**
433  * @dev Collection of functions related to the address type
434  */
435 library Address {
436     /**
437      * @dev Returns true if `account` is a contract.
438      *
439      * [IMPORTANT]
440      * ====
441      * It is unsafe to assume that an address for which this function returns
442      * false is an externally-owned account (EOA) and not a contract.
443      *
444      * Among others, `isContract` will return false for the following
445      * types of addresses:
446      *
447      *  - an externally-owned account
448      *  - a contract in construction
449      *  - an address where a contract will be created
450      *  - an address where a contract lived, but was destroyed
451      * ====
452      */
453     function isContract(address account) internal view returns (bool) {
454         // This method relies on extcodesize, which returns 0 for contracts in
455         // construction, since the code is only stored at the end of the
456         // constructor execution.
457 
458         uint256 size;
459         // solhint-disable-next-line no-inline-assembly
460         assembly { size := extcodesize(account) }
461         return size > 0;
462     }
463 
464     /**
465      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
466      * `recipient`, forwarding all available gas and reverting on errors.
467      *
468      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
469      * of certain opcodes, possibly making contracts go over the 2300 gas limit
470      * imposed by `transfer`, making them unable to receive funds via
471      * `transfer`. {sendValue} removes this limitation.
472      *
473      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
474      *
475      * IMPORTANT: because control is transferred to `recipient`, care must be
476      * taken to not create reentrancy vulnerabilities. Consider using
477      * {ReentrancyGuard} or the
478      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
479      */
480     function sendValue(address payable recipient, uint256 amount) internal {
481         require(address(this).balance >= amount, "Address: insufficient balance");
482 
483         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
484         (bool success, ) = recipient.call{ value: amount }("");
485         require(success, "Address: unable to send value, recipient may have reverted");
486     }
487 
488     /**
489      * @dev Performs a Solidity function call using a low level `call`. A
490      * plain`call` is an unsafe replacement for a function call: use this
491      * function instead.
492      *
493      * If `target` reverts with a revert reason, it is bubbled up by this
494      * function (like regular Solidity function calls).
495      *
496      * Returns the raw returned data. To convert to the expected return value,
497      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
498      *
499      * Requirements:
500      *
501      * - `target` must be a contract.
502      * - calling `target` with `data` must not revert.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
507       return functionCall(target, data, "Address: low-level call failed");
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
512      * `errorMessage` as a fallback revert reason when `target` reverts.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
517         return functionCallWithValue(target, data, 0, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but also transferring `value` wei to `target`.
523      *
524      * Requirements:
525      *
526      * - the calling contract must have an ETH balance of at least `value`.
527      * - the called Solidity function must be `payable`.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
532         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
537      * with `errorMessage` as a fallback revert reason when `target` reverts.
538      *
539      * _Available since v3.1._
540      */
541     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
542         require(address(this).balance >= value, "Address: insufficient balance for call");
543         require(isContract(target), "Address: call to non-contract");
544 
545         // solhint-disable-next-line avoid-low-level-calls
546         (bool success, bytes memory returndata) = target.call{ value: value }(data);
547         return _verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
557         return functionStaticCall(target, data, "Address: low-level static call failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
562      * but performing a static call.
563      *
564      * _Available since v3.3._
565      */
566     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
567         require(isContract(target), "Address: static call to non-contract");
568 
569         // solhint-disable-next-line avoid-low-level-calls
570         (bool success, bytes memory returndata) = target.staticcall(data);
571         return _verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a delegate call.
577      *
578      * _Available since v3.4._
579      */
580     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
581         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a delegate call.
587      *
588      * _Available since v3.4._
589      */
590     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
591         require(isContract(target), "Address: delegate call to non-contract");
592 
593         // solhint-disable-next-line avoid-low-level-calls
594         (bool success, bytes memory returndata) = target.delegatecall(data);
595         return _verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
599         if (success) {
600             return returndata;
601         } else {
602             // Look for revert reason and bubble it up if present
603             if (returndata.length > 0) {
604                 // The easiest way to bubble the revert reason is using memory via assembly
605 
606                 // solhint-disable-next-line no-inline-assembly
607                 assembly {
608                     let returndata_size := mload(returndata)
609                     revert(add(32, returndata), returndata_size)
610                 }
611             } else {
612                 revert(errorMessage);
613             }
614         }
615     }
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
619 
620 
621 pragma solidity >=0.6.0 <0.8.0;
622 
623 
624 
625 
626 /**
627  * @title SafeERC20
628  * @dev Wrappers around ERC20 operations that throw on failure (when the token
629  * contract returns false). Tokens that return no value (and instead revert or
630  * throw on failure) are also supported, non-reverting calls are assumed to be
631  * successful.
632  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
633  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
634  */
635 library SafeERC20 {
636     using SafeMath for uint256;
637     using Address for address;
638 
639     function safeTransfer(IERC20 token, address to, uint256 value) internal {
640         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
641     }
642 
643     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
644         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
645     }
646 
647     /**
648      * @dev Deprecated. This function has issues similar to the ones found in
649      * {IERC20-approve}, and its usage is discouraged.
650      *
651      * Whenever possible, use {safeIncreaseAllowance} and
652      * {safeDecreaseAllowance} instead.
653      */
654     function safeApprove(IERC20 token, address spender, uint256 value) internal {
655         // safeApprove should only be called when setting an initial allowance,
656         // or when resetting it to zero. To increase and decrease it, use
657         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
658         // solhint-disable-next-line max-line-length
659         require((value == 0) || (token.allowance(address(this), spender) == 0),
660             "SafeERC20: approve from non-zero to non-zero allowance"
661         );
662         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
663     }
664 
665     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
666         uint256 newAllowance = token.allowance(address(this), spender).add(value);
667         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
668     }
669 
670     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
671         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
672         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
673     }
674 
675     /**
676      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
677      * on the return value: the return value is optional (but if data is returned, it must not be false).
678      * @param token The token targeted by the call.
679      * @param data The call data (encoded using abi.encode or one of its variants).
680      */
681     function _callOptionalReturn(IERC20 token, bytes memory data) private {
682         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
683         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
684         // the target address contains contract code and also asserts for success in the low-level call.
685 
686         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
687         if (returndata.length > 0) { // Return data is optional
688             // solhint-disable-next-line max-line-length
689             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
690         }
691     }
692 }
693 
694 // File: @openzeppelin/contracts/utils/Context.sol
695 
696 
697 pragma solidity >=0.6.0 <0.8.0;
698 
699 /*
700  * @dev Provides information about the current execution context, including the
701  * sender of the transaction and its data. While these are generally available
702  * via msg.sender and msg.data, they should not be accessed in such a direct
703  * manner, since when dealing with GSN meta-transactions the account sending and
704  * paying for execution may not be the actual sender (as far as an application
705  * is concerned).
706  *
707  * This contract is only required for intermediate, library-like contracts.
708  */
709 abstract contract Context {
710     function _msgSender() internal view virtual returns (address payable) {
711         return msg.sender;
712     }
713 
714     function _msgData() internal view virtual returns (bytes memory) {
715         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
716         return msg.data;
717     }
718 }
719 
720 // File: @openzeppelin/contracts/access/Ownable.sol
721 
722 
723 pragma solidity >=0.6.0 <0.8.0;
724 
725 /**
726  * @dev Contract module which provides a basic access control mechanism, where
727  * there is an account (an owner) that can be granted exclusive access to
728  * specific functions.
729  *
730  * By default, the owner account will be the one that deploys the contract. This
731  * can later be changed with {transferOwnership}.
732  *
733  * This module is used through inheritance. It will make available the modifier
734  * `onlyOwner`, which can be applied to your functions to restrict their use to
735  * the owner.
736  */
737 abstract contract Ownable is Context {
738     address private _owner;
739 
740     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
741 
742     /**
743      * @dev Initializes the contract setting the deployer as the initial owner.
744      */
745     constructor () internal {
746         address msgSender = _msgSender();
747         _owner = msgSender;
748         emit OwnershipTransferred(address(0), msgSender);
749     }
750 
751     /**
752      * @dev Returns the address of the current owner.
753      */
754     function owner() public view virtual returns (address) {
755         return _owner;
756     }
757 
758     /**
759      * @dev Throws if called by any account other than the owner.
760      */
761     modifier onlyOwner() {
762         require(owner() == _msgSender(), "Ownable: caller is not the owner");
763         _;
764     }
765 
766     /**
767      * @dev Leaves the contract without owner. It will not be possible to call
768      * `onlyOwner` functions anymore. Can only be called by the current owner.
769      *
770      * NOTE: Renouncing ownership will leave the contract without an owner,
771      * thereby removing any functionality that is only available to the owner.
772      */
773     function renounceOwnership() public virtual onlyOwner {
774         emit OwnershipTransferred(_owner, address(0));
775         _owner = address(0);
776     }
777 
778     /**
779      * @dev Transfers ownership of the contract to a new account (`newOwner`).
780      * Can only be called by the current owner.
781      */
782     function transferOwnership(address newOwner) public virtual onlyOwner {
783         require(newOwner != address(0), "Ownable: new owner is the zero address");
784         emit OwnershipTransferred(_owner, newOwner);
785         _owner = newOwner;
786     }
787 }
788 
789 // File: contracts/interfaces/IBurnableToken.sol
790 
791 pragma solidity 0.7.5;
792 
793 interface IBurnableToken {
794     function burn(uint256 _amount) external;
795 }
796 
797 // File: contracts/NFTRewards.sol
798 
799 pragma solidity 0.7.5;
800 
801 // Inheritance
802 
803 
804 
805 
806 
807 
808 
809 /// @title   UMB to NFT swapping contract
810 /// @author  umb.network
811 contract NFTRewards is Ownable {
812     using SafeMath for uint;
813     using SafeERC20 for IERC20;
814 
815     address public umbToken;
816     address public leftoverReceiver;
817     uint256 public multiplier;
818     uint256 public rewardsDeadline;
819 
820     mapping(address => uint) public balances;
821 
822     constructor(address _umbToken, address _leftoverReceiver) {
823         require(_umbToken != address(0x0), "should be non-null UMB token address");
824         require(_leftoverReceiver != address(0x0), "should be non-null leftoverReceiver address");
825 
826         umbToken = _umbToken;
827         leftoverReceiver = _leftoverReceiver;
828     }
829 
830     function balanceOf(address _addr) view public returns(uint256) {
831         return balances[_addr].mul(multiplier);
832     }
833 
834     function startRewards(
835         uint _multiplier,
836         address[] calldata _addresses,
837         uint[] calldata _balances,
838         uint _duration
839     ) external onlyOwner {
840         require(_duration > 0, "duration should be positive");
841         require(rewardsDeadline == 0, "can start rewards one time");
842         require(_multiplier > 0, "multiplier must be positive");
843         require(_addresses.length > 0, "should be at least 1 address");
844         require(_addresses.length == _balances.length, "should be the same number of addresses and balances");
845 
846         for (uint i = 0; i < _addresses.length; i++) {
847             balances[_addresses[i]] = _balances[i];
848         }
849 
850         multiplier = _multiplier;
851         rewardsDeadline = block.timestamp + _duration;
852     }
853 
854     function close() external {
855         require(block.timestamp > rewardsDeadline, "cannot close the contract right now");
856 
857         uint umbBalance = IERC20(umbToken).balanceOf(address(this));
858 
859         if (umbBalance > 0) {
860             require(IERC20(umbToken).transfer(leftoverReceiver, umbBalance), "transfer failed");
861         }
862 
863         selfdestruct(msg.sender);
864     }
865 
866     function claimUMB() external {
867         uint nftAmount = balances[msg.sender];
868         require(nftAmount > 0, "amount should be positive");
869 
870         balances[msg.sender] = 0;
871 
872         uint umbAmount = nftAmount.mul(multiplier);
873 
874         IERC20(umbToken).safeTransfer(msg.sender, umbAmount);
875 
876         emit Claimed(msg.sender, nftAmount, umbAmount);
877     }
878 
879     event Claimed(
880         address indexed receiver,
881         uint nftAmount,
882         uint umbAmount);
883 }