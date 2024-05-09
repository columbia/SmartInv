1 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
2 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
3 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
4 //////////////////////////////////////.////////////////////////////////.////////////////////////////////////
5 ///////////////////////////////////.@.//////////////////////////////////.@./////////////////////////////////
6 ////////////////////////////////.@@.//////////////////////////////////////.@@.//////////////////////////////
7 /////////////////////////////..@@@.////////////////////////////////////////.@@@..///////////////////////////
8 ///////////////////////////.@@@@@.//////////////////////////////////////////.@@@@@./////////////////////////
9 /////////////////////////.@@@@@@@////////////////////////////////////////////@@@@@@@.///////////////////////
10 ////////////////////////.@@@@@@@.////////////////////////////////////////////.@@@@@@@.//////////////////////
11 //////////////////..///.@@@@@@@@//////////////////////////////////////////////@@@@@@@@.///..////////////////
12 ////////////////.@@.//.@@@@@@@@@//////////////////////////////////////////////@@@@@@@@@.//.@@.//////////////
13 ///////////////@@@@.//@@@@@@@@@.//////////////////////////////////////////////.@@@@@@@@@//@@@@@/////////////
14 //////////////@@@@@@//@@@@@@@@@.//////////////////////////////////////////////.@@@@@@@@@//@@@@@@////////////
15 /////////////@@@@@@@./@@@@@@@@@@//////////////////////////////////////////////@@@@@@@@@./.@@@@@@@///////////
16 /////////////@@@@@@@@//@@@@@@@@@.////////////////////////////////////////////.@@@@@@@@@//@@@@@@@@///////////
17 /////////////@@@@@@@@.//.@@@@@@@@.//////////////////////////////////////////@@@@@@@@@.//.@@@@@@@@///////////
18 /////////////@@@@@@@@@///.@@@@@@@@@.////////.//////////////////////////////@@@@@@@@@.///@@@@@@@@@///////////
19 /////////////.@@@@@@@@@///..@@@@@@@.////////.@.///////////////////////////.@@@@@@@.////@@@@@@@@@.///////////
20 //////////////.@@@@@@@@@.////.@@@@///////////.@@.//////////////////////////.@@@@.////.@@@@@@@@@.////////////
21 //////////.////.@@@@@@@@@@./////./////////////.@@@@..////////////////////////./////.@@@@@@@@@@.///..////////
22 //////////@@.///.@@@@@@@@@@@.//////////////////.@@@@@@@@@@./////////////////////..@@@@@@@@@@.///.@@.////////
23 //////////@@@@.///.@@@@@@@@@@@@.////////////////.@@@@@@@@@@@..///////////////.@@@@@@@@@@@@@.//.@@@@.////////
24 //////////.@@@@@@.///.@@@@@@@@@@@.///////////////.@@@@@@@@@@@@./////////////.@@@@@@@@@@@.//.@@@@@@@.////////
25 //////////.@@@@@@@@.////.@@@@@@@@@.///////////////@@@@@@@@@...@////////////.@@@@@@@@@.//..@@@@@@@@@.////////
26 //////////.@@@@@@@@@@@..////..@@@@@@./////////////@@@@@@@@@ /////////////.@@@@@@..///..@@@@@@@@@@@./////////
27 ///////////.@@@@@@@@@@@@@@..//////.....///////////@@@@@@@@@.///////////...../////..@@@@@@@@@@@@@@@//////////
28 ////////////.@@@@@@@@@@@@@@@@@@....///////////////@@@@@@@@@.///////////////...@@@@@@@@@@@@@@@@@@@.//////////
29 /////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@..///////@@@@@@@@@@//////....@@@@@@@@@@@@@@@@@@@@@@@@@@.///////////
30 //////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.///.@@@@@@@@@@/////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/////////////
31 ////////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@///@@@@@@@@@@@.///.@@@@@@@@@@@@@@@@@@@@@@@@@@@@.//////////////
32 //////////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@@@@@@@@@@@@@./.@@@@@@@@@@@@@@@@@@@@@@@@@@@.////////////////
33 ////////////////////.@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..//////////////////
34 //////////////////////..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@./////////////////////
35 /////////////////////////..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.////////////////////////
36 /////////////////////////////..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..///////////////////////////
37 /////////////////////////////////..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..///////////////////////////////
38 //////////////////////////////////////...@@@@@@@@@@@@@@@@@@@@@@@@@@@@...////////////////////////////////////
39 //////////////////////////////////////////////...@@@@@@@@@@@@@@...//////////////////////////////////////////
40 //////////////////////////////////////////////////.@@@@@@@@@////////////////////////////////////////////////
41 ////////////////////////////////////////////////.@@@@@./@@@@@///////////////////////////////////////////////
42 ///////////////////////////////////////////////.@@@@@@///@@@@@./////////////////////////////////////////////
43 /////////////////////////////////////////////.@@@@@@@/.@./@@@@@@.///////////////////////////////////////////
44 ////////////////////////////////////////////@@@@@@@@/.@@@/.@@@@@@@./////////////////////////////////////////
45 ///////////////////////////////////////////.@@@@@@@//@@@@@//@@@@@@@.////////////////////////////////////////
46 ////////////////////////////////////////////.@@@@@./@@@@@@@/.@@@@@./////////////////////////////////////////
47 //////////////////////////////////////////////.@@./@@@@@@@@@/.@@.///////////////////////////////////////////
48 ///////////////////////////////////////////////../@@@@@@@@@@@/..////////////////////////////////////////////
49 /////////////////////////////////////////////////@@@@@@@@@@@@@//////////////////////////////////////////////
50 ////////////////////////////////////////////////@@@@@@@@@@@@@@@/////////////////////////////////////////////
51 ///////////////////////////////////////////////@@@@@@.///.@@@@@.////////////////////////////////////////////
52 //////////////////////////////////////////////.@@..//.@@..//..@@.///////////////////////////////////////////
53 /////////////////////////////////////////////..//////@@@@//////...//////////////////////////////////////////
54 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
55 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
56 /////////////_______///________//____////____//_______//______///////__///__////______////______////////////
57 /////////////@@_____|//@@@__@@@\/\@@@\  /@@@//|@@@____||@@@_  \/////|@@\ |@@|///  __  \//|@@@_@@\///////////
58 ////////////|@@|//__//|@@|  |@@|//\@@@\/@@@///|@@|__///|@@|_)  |////|@@@\|@@|/|@@|  |@@|/|@@|_)@@|//////////
59 ////////////|@@| |_@|/|@@|  |@@|///\@@@@@@////|@@@__|//|@@@@@@//////|@@.@`@@|/|@@|  |@@|/|@@@@@@////////////
60 ////////////|@@|__|@|/|@@`--'@@|////\@@@@/////|@@|____/|@@|\@@\----.|@@|\@@@|/|@@`--'@@|/|@@|\@@\----.//////
61 /////////////\______|//\______///////\__//////|_______|| _| `._____||__| \__|//\______///|@_| `._____|//////
62 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
63 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
64 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
65 ////////////////////////////////////////////////////////////////////////////////////////////////////////////
66 // 
67 
68 // SPDX-License-Identifier: MIT
69 pragma solidity 0.6.12;
70 
71 
72 // 
73 /**
74  * @dev Interface of the ERC20 standard as defined in the EIP.
75  */
76 interface IERC20 {
77     /**
78      * @dev Returns the amount of tokens in existence.
79      */
80     function totalSupply() external view returns (uint256);
81 
82     /**
83      * @dev Returns the amount of tokens owned by `account`.
84      */
85     function balanceOf(address account) external view returns (uint256);
86 
87     /**
88      * @dev Moves `amount` tokens from the caller's account to `recipient`.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transfer(address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Returns the remaining number of tokens that `spender` will be
98      * allowed to spend on behalf of `owner` through {transferFrom}. This is
99      * zero by default.
100      *
101      * This value changes when {approve} or {transferFrom} are called.
102      */
103     function allowance(address owner, address spender) external view returns (uint256);
104 
105     /**
106      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * IMPORTANT: Beware that changing an allowance with this method brings the risk
111      * that someone may use both the old and the new allowance by unfortunate
112      * transaction ordering. One possible solution to mitigate this race
113      * condition is to first reduce the spender's allowance to 0 and set the
114      * desired value afterwards:
115      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address spender, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Moves `amount` tokens from `sender` to `recipient` using the
123      * allowance mechanism. `amount` is then deducted from the caller's
124      * allowance.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Emitted when `value` tokens are moved from one account (`from`) to
134      * another (`to`).
135      *
136      * Note that `value` may be zero.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140     /**
141      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
142      * a call to {approve}. `value` is the new allowance.
143      */
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 // 
148 /**
149  * @dev Wrappers over Solidity's arithmetic operations with added overflow
150  * checks.
151  *
152  * Arithmetic operations in Solidity wrap on overflow. This can easily result
153  * in bugs, because programmers usually assume that an overflow raises an
154  * error, which is the standard behavior in high level programming languages.
155  * `SafeMath` restores this intuition by reverting the transaction when an
156  * operation overflows.
157  *
158  * Using this library instead of the unchecked operations eliminates an entire
159  * class of bugs, so it's recommended to use it always.
160  */
161 library SafeMath {
162     /**
163      * @dev Returns the addition of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `+` operator.
167      *
168      * Requirements:
169      *
170      * - Addition cannot overflow.
171      */
172     function add(uint256 a, uint256 b) internal pure returns (uint256) {
173         uint256 c = a + b;
174         require(c >= a, "SafeMath: addition overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the subtraction of two unsigned integers, reverting on
181      * overflow (when the result is negative).
182      *
183      * Counterpart to Solidity's `-` operator.
184      *
185      * Requirements:
186      *
187      * - Subtraction cannot overflow.
188      */
189     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190         return sub(a, b, "SafeMath: subtraction overflow");
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
195      * overflow (when the result is negative).
196      *
197      * Counterpart to Solidity's `-` operator.
198      *
199      * Requirements:
200      *
201      * - Subtraction cannot overflow.
202      */
203     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b <= a, errorMessage);
205         uint256 c = a - b;
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the multiplication of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `*` operator.
215      *
216      * Requirements:
217      *
218      * - Multiplication cannot overflow.
219      */
220     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
221         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
222         // benefit is lost if 'b' is also tested.
223         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
224         if (a == 0) {
225             return 0;
226         }
227 
228         uint256 c = a * b;
229         require(c / a == b, "SafeMath: multiplication overflow");
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers. Reverts on
236      * division by zero. The result is rounded towards zero.
237      *
238      * Counterpart to Solidity's `/` operator. Note: this function uses a
239      * `revert` opcode (which leaves remaining gas untouched) while Solidity
240      * uses an invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function div(uint256 a, uint256 b) internal pure returns (uint256) {
247         return div(a, b, "SafeMath: division by zero");
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b > 0, errorMessage);
264         uint256 c = a / b;
265         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * Reverts when dividing by zero.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
283         return mod(a, b, "SafeMath: modulo by zero");
284     }
285 
286     /**
287      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
288      * Reverts with custom message when dividing by zero.
289      *
290      * Counterpart to Solidity's `%` operator. This function uses a `revert`
291      * opcode (which leaves remaining gas untouched) while Solidity uses an
292      * invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b != 0, errorMessage);
300         return a % b;
301     }
302 }
303 
304 // 
305 /**
306  * @dev Collection of functions related to the address type
307  */
308 library Address {
309     /**
310      * @dev Returns true if `account` is a contract.
311      *
312      * [IMPORTANT]
313      * ====
314      * It is unsafe to assume that an address for which this function returns
315      * false is an externally-owned account (EOA) and not a contract.
316      *
317      * Among others, `isContract` will return false for the following
318      * types of addresses:
319      *
320      *  - an externally-owned account
321      *  - a contract in construction
322      *  - an address where a contract will be created
323      *  - an address where a contract lived, but was destroyed
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize, which returns 0 for contracts in
328         // construction, since the code is only stored at the end of the
329         // constructor execution.
330 
331         uint256 size;
332         // solhint-disable-next-line no-inline-assembly
333         assembly { size := extcodesize(account) }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(address(this).balance >= amount, "Address: insufficient balance");
355 
356         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
357         (bool success, ) = recipient.call{ value: amount }("");
358         require(success, "Address: unable to send value, recipient may have reverted");
359     }
360 
361     /**
362      * @dev Performs a Solidity function call using a low level `call`. A
363      * plain`call` is an unsafe replacement for a function call: use this
364      * function instead.
365      *
366      * If `target` reverts with a revert reason, it is bubbled up by this
367      * function (like regular Solidity function calls).
368      *
369      * Returns the raw returned data. To convert to the expected return value,
370      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
371      *
372      * Requirements:
373      *
374      * - `target` must be a contract.
375      * - calling `target` with `data` must not revert.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
380       return functionCall(target, data, "Address: low-level call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
385      * `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
410      * with `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
415         require(address(this).balance >= value, "Address: insufficient balance for call");
416         require(isContract(target), "Address: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = target.call{ value: value }(data);
420         return _verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
440         require(isContract(target), "Address: static call to non-contract");
441 
442         // solhint-disable-next-line avoid-low-level-calls
443         (bool success, bytes memory returndata) = target.staticcall(data);
444         return _verifyCallResult(success, returndata, errorMessage);
445     }
446 
447     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 // solhint-disable-next-line no-inline-assembly
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 // 
468 /**
469  * @title SafeERC20
470  * @dev Wrappers around ERC20 operations that throw on failure (when the token
471  * contract returns false). Tokens that return no value (and instead revert or
472  * throw on failure) are also supported, non-reverting calls are assumed to be
473  * successful.
474  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
475  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
476  */
477 library SafeERC20 {
478     using SafeMath for uint256;
479     using Address for address;
480 
481     function safeTransfer(IERC20 token, address to, uint256 value) internal {
482         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
483     }
484 
485     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
486         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
487     }
488 
489     /**
490      * @dev Deprecated. This function has issues similar to the ones found in
491      * {IERC20-approve}, and its usage is discouraged.
492      *
493      * Whenever possible, use {safeIncreaseAllowance} and
494      * {safeDecreaseAllowance} instead.
495      */
496     function safeApprove(IERC20 token, address spender, uint256 value) internal {
497         // safeApprove should only be called when setting an initial allowance,
498         // or when resetting it to zero. To increase and decrease it, use
499         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
500         // solhint-disable-next-line max-line-length
501         require((value == 0) || (token.allowance(address(this), spender) == 0),
502             "SafeERC20: approve from non-zero to non-zero allowance"
503         );
504         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
505     }
506 
507     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
508         uint256 newAllowance = token.allowance(address(this), spender).add(value);
509         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
510     }
511 
512     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
513         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
514         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
515     }
516 
517     /**
518      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
519      * on the return value: the return value is optional (but if data is returned, it must not be false).
520      * @param token The token targeted by the call.
521      * @param data The call data (encoded using abi.encode or one of its variants).
522      */
523     function _callOptionalReturn(IERC20 token, bytes memory data) private {
524         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
525         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
526         // the target address contains contract code and also asserts for success in the low-level call.
527 
528         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
529         if (returndata.length > 0) { // Return data is optional
530             // solhint-disable-next-line max-line-length
531             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
532         }
533     }
534 }
535 
536 // 
537 /**
538  * @dev Library for managing
539  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
540  * types.
541  *
542  * Sets have the following properties:
543  *
544  * - Elements are added, removed, and checked for existence in constant time
545  * (O(1)).
546  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
547  *
548  * ```
549  * contract Example {
550  *     // Add the library methods
551  *     using EnumerableSet for EnumerableSet.AddressSet;
552  *
553  *     // Declare a set state variable
554  *     EnumerableSet.AddressSet private mySet;
555  * }
556  * ```
557  *
558  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
559  * and `uint256` (`UintSet`) are supported.
560  */
561 library EnumerableSet {
562     // To implement this library for multiple types with as little code
563     // repetition as possible, we write it in terms of a generic Set type with
564     // bytes32 values.
565     // The Set implementation uses private functions, and user-facing
566     // implementations (such as AddressSet) are just wrappers around the
567     // underlying Set.
568     // This means that we can only create new EnumerableSets for types that fit
569     // in bytes32.
570 
571     struct Set {
572         // Storage of set values
573         bytes32[] _values;
574 
575         // Position of the value in the `values` array, plus 1 because index 0
576         // means a value is not in the set.
577         mapping (bytes32 => uint256) _indexes;
578     }
579 
580     /**
581      * @dev Add a value to a set. O(1).
582      *
583      * Returns true if the value was added to the set, that is if it was not
584      * already present.
585      */
586     function _add(Set storage set, bytes32 value) private returns (bool) {
587         if (!_contains(set, value)) {
588             set._values.push(value);
589             // The value is stored at length-1, but we add 1 to all indexes
590             // and use 0 as a sentinel value
591             set._indexes[value] = set._values.length;
592             return true;
593         } else {
594             return false;
595         }
596     }
597 
598     /**
599      * @dev Removes a value from a set. O(1).
600      *
601      * Returns true if the value was removed from the set, that is if it was
602      * present.
603      */
604     function _remove(Set storage set, bytes32 value) private returns (bool) {
605         // We read and store the value's index to prevent multiple reads from the same storage slot
606         uint256 valueIndex = set._indexes[value];
607 
608         if (valueIndex != 0) { // Equivalent to contains(set, value)
609             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
610             // the array, and then remove the last element (sometimes called as 'swap and pop').
611             // This modifies the order of the array, as noted in {at}.
612 
613             uint256 toDeleteIndex = valueIndex - 1;
614             uint256 lastIndex = set._values.length - 1;
615 
616             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
617             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
618 
619             bytes32 lastvalue = set._values[lastIndex];
620 
621             // Move the last value to the index where the value to delete is
622             set._values[toDeleteIndex] = lastvalue;
623             // Update the index for the moved value
624             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
625 
626             // Delete the slot where the moved value was stored
627             set._values.pop();
628 
629             // Delete the index for the deleted slot
630             delete set._indexes[value];
631 
632             return true;
633         } else {
634             return false;
635         }
636     }
637 
638     /**
639      * @dev Returns true if the value is in the set. O(1).
640      */
641     function _contains(Set storage set, bytes32 value) private view returns (bool) {
642         return set._indexes[value] != 0;
643     }
644 
645     /**
646      * @dev Returns the number of values on the set. O(1).
647      */
648     function _length(Set storage set) private view returns (uint256) {
649         return set._values.length;
650     }
651 
652    /**
653     * @dev Returns the value stored at position `index` in the set. O(1).
654     *
655     * Note that there are no guarantees on the ordering of values inside the
656     * array, and it may change when more values are added or removed.
657     *
658     * Requirements:
659     *
660     * - `index` must be strictly less than {length}.
661     */
662     function _at(Set storage set, uint256 index) private view returns (bytes32) {
663         require(set._values.length > index, "EnumerableSet: index out of bounds");
664         return set._values[index];
665     }
666 
667     // Bytes32Set
668 
669     struct Bytes32Set {
670         Set _inner;
671     }
672 
673     /**
674      * @dev Add a value to a set. O(1).
675      *
676      * Returns true if the value was added to the set, that is if it was not
677      * already present.
678      */
679     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
680         return _add(set._inner, value);
681     }
682 
683     /**
684      * @dev Removes a value from a set. O(1).
685      *
686      * Returns true if the value was removed from the set, that is if it was
687      * present.
688      */
689     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
690         return _remove(set._inner, value);
691     }
692 
693     /**
694      * @dev Returns true if the value is in the set. O(1).
695      */
696     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
697         return _contains(set._inner, value);
698     }
699 
700     /**
701      * @dev Returns the number of values in the set. O(1).
702      */
703     function length(Bytes32Set storage set) internal view returns (uint256) {
704         return _length(set._inner);
705     }
706 
707    /**
708     * @dev Returns the value stored at position `index` in the set. O(1).
709     *
710     * Note that there are no guarantees on the ordering of values inside the
711     * array, and it may change when more values are added or removed.
712     *
713     * Requirements:
714     *
715     * - `index` must be strictly less than {length}.
716     */
717     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
718         return _at(set._inner, index);
719     }
720 
721     // AddressSet
722 
723     struct AddressSet {
724         Set _inner;
725     }
726 
727     /**
728      * @dev Add a value to a set. O(1).
729      *
730      * Returns true if the value was added to the set, that is if it was not
731      * already present.
732      */
733     function add(AddressSet storage set, address value) internal returns (bool) {
734         return _add(set._inner, bytes32(uint256(value)));
735     }
736 
737     /**
738      * @dev Removes a value from a set. O(1).
739      *
740      * Returns true if the value was removed from the set, that is if it was
741      * present.
742      */
743     function remove(AddressSet storage set, address value) internal returns (bool) {
744         return _remove(set._inner, bytes32(uint256(value)));
745     }
746 
747     /**
748      * @dev Returns true if the value is in the set. O(1).
749      */
750     function contains(AddressSet storage set, address value) internal view returns (bool) {
751         return _contains(set._inner, bytes32(uint256(value)));
752     }
753 
754     /**
755      * @dev Returns the number of values in the set. O(1).
756      */
757     function length(AddressSet storage set) internal view returns (uint256) {
758         return _length(set._inner);
759     }
760 
761    /**
762     * @dev Returns the value stored at position `index` in the set. O(1).
763     *
764     * Note that there are no guarantees on the ordering of values inside the
765     * array, and it may change when more values are added or removed.
766     *
767     * Requirements:
768     *
769     * - `index` must be strictly less than {length}.
770     */
771     function at(AddressSet storage set, uint256 index) internal view returns (address) {
772         return address(uint256(_at(set._inner, index)));
773     }
774 
775 
776     // UintSet
777 
778     struct UintSet {
779         Set _inner;
780     }
781 
782     /**
783      * @dev Add a value to a set. O(1).
784      *
785      * Returns true if the value was added to the set, that is if it was not
786      * already present.
787      */
788     function add(UintSet storage set, uint256 value) internal returns (bool) {
789         return _add(set._inner, bytes32(value));
790     }
791 
792     /**
793      * @dev Removes a value from a set. O(1).
794      *
795      * Returns true if the value was removed from the set, that is if it was
796      * present.
797      */
798     function remove(UintSet storage set, uint256 value) internal returns (bool) {
799         return _remove(set._inner, bytes32(value));
800     }
801 
802     /**
803      * @dev Returns true if the value is in the set. O(1).
804      */
805     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
806         return _contains(set._inner, bytes32(value));
807     }
808 
809     /**
810      * @dev Returns the number of values on the set. O(1).
811      */
812     function length(UintSet storage set) internal view returns (uint256) {
813         return _length(set._inner);
814     }
815 
816    /**
817     * @dev Returns the value stored at position `index` in the set. O(1).
818     *
819     * Note that there are no guarantees on the ordering of values inside the
820     * array, and it may change when more values are added or removed.
821     *
822     * Requirements:
823     *
824     * - `index` must be strictly less than {length}.
825     */
826     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
827         return uint256(_at(set._inner, index));
828     }
829 }
830 
831 // 
832 /*
833  * @dev Provides information about the current execution context, including the
834  * sender of the transaction and its data. While these are generally available
835  * via msg.sender and msg.data, they should not be accessed in such a direct
836  * manner, since when dealing with GSN meta-transactions the account sending and
837  * paying for execution may not be the actual sender (as far as an application
838  * is concerned).
839  *
840  * This contract is only required for intermediate, library-like contracts.
841  */
842 abstract contract Context {
843     function _msgSender() internal view virtual returns (address payable) {
844         return msg.sender;
845     }
846 
847     function _msgData() internal view virtual returns (bytes memory) {
848         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
849         return msg.data;
850     }
851 }
852 
853 // 
854 /**
855  * @dev Contract module which provides a basic access control mechanism, where
856  * there is an account (an owner) that can be granted exclusive access to
857  * specific functions.
858  *
859  * By default, the owner account will be the one that deploys the contract. This
860  * can later be changed with {transferOwnership}.
861  *
862  * This module is used through inheritance. It will make available the modifier
863  * `onlyOwner`, which can be applied to your functions to restrict their use to
864  * the owner.
865  */
866 abstract contract Ownable is Context {
867     address private _owner;
868 
869     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
870 
871     /**
872      * @dev Initializes the contract setting the deployer as the initial owner.
873      */
874     constructor () internal {
875         address msgSender = _msgSender();
876         _owner = msgSender;
877         emit OwnershipTransferred(address(0), msgSender);
878     }
879 
880     /**
881      * @dev Returns the address of the current owner.
882      */
883     function owner() public view returns (address) {
884         return _owner;
885     }
886 
887     /**
888      * @dev Throws if called by any account other than the owner.
889      */
890     modifier onlyOwner() {
891         require(_owner == _msgSender(), "Ownable: caller is not the owner");
892         _;
893     }
894 
895     /**
896      * @dev Leaves the contract without owner. It will not be possible to call
897      * `onlyOwner` functions anymore. Can only be called by the current owner.
898      *
899      * NOTE: Renouncing ownership will leave the contract without an owner,
900      * thereby removing any functionality that is only available to the owner.
901      */
902     function renounceOwnership() public virtual onlyOwner {
903         emit OwnershipTransferred(_owner, address(0));
904         _owner = address(0);
905     }
906 
907     /**
908      * @dev Transfers ownership of the contract to a new account (`newOwner`).
909      * Can only be called by the current owner.
910      */
911     function transferOwnership(address newOwner) public virtual onlyOwner {
912         require(newOwner != address(0), "Ownable: new owner is the zero address");
913         emit OwnershipTransferred(_owner, newOwner);
914         _owner = newOwner;
915     }
916 }
917 
918 //
919 // GovTreasurer is the treasurer of GDAO. She may allocate GDAO and she is a fair lady <3
920 // Note that it's ownable and the owner wields tremendous power. The ownership
921 // will be transferred to a governance smart contract once GDAO is sufficiently
922 // distributed and the community can show to govern itself.
923 contract GovTreasurer is Ownable {
924     using SafeMath for uint256;
925     using SafeERC20 for IERC20;
926     address devaddr;
927     address public treasury;
928     IERC20 public gdao;
929     uint256 public bonusEndBlock;
930     uint256 public GDAOPerBlock;
931 
932 
933     // INFO | USER VARIABLES
934     struct UserInfo {
935         uint256 amount;     // How many tokens the user has provided.
936         uint256 rewardDebt; // Reward debt. See explanation below.
937         //
938         // The pending GDAO entitled to a user is referred to as the pending reward:
939         //
940         //   pending reward = (user.amount * pool.accGDAOPerShare) - user.rewardDebt - user.taxedAmount
941         //
942         // Upon deposit and withdraw, the following occur:
943         //   1. The pool's `accGDAOPerShare` (and `lastRewardBlock`) gets updated.
944         //   2. User receives the pending reward sent to his/her address.
945         //   3. User's `amount` gets updated and taxed as 'taxedAmount'.
946         //   4. User's `rewardDebt` gets updated.
947     }
948 
949     // INFO | POOL VARIABLES
950     struct PoolInfo {
951         IERC20 token;           // Address of token contract.
952         uint256 allocPoint;       // How many allocation points assigned to this pool. GDAOs to distribute per block.
953         uint256 taxRate;          // Rate at which the LP token is taxed.
954         uint256 lastRewardBlock;  // Last block number that GDAOs distribution occurs.
955         uint256 accGDAOPerShare; // Accumulated GDAOs per share, times 1e12. See below.
956     }
957 
958     PoolInfo[] public poolInfo;
959     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
960     uint256 public totalAllocPoint = 0;
961     uint256 public startBlock;
962 
963     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
964     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
965     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
966 
967     constructor(IERC20 _gdao, address _treasury, uint256 _GDAOPerBlock, uint256 _startBlock, uint256 _bonusEndBlock) public {
968         gdao = _gdao;
969         treasury = _treasury;
970         devaddr = msg.sender;
971         GDAOPerBlock = _GDAOPerBlock;
972         startBlock = _startBlock;
973         bonusEndBlock = _bonusEndBlock;
974     }
975 
976     function poolLength() external view returns (uint256) {
977         return poolInfo.length;
978     }
979 
980 
981     // VALIDATION | ELIMINATES POOL DUPLICATION RISK
982     function checkPoolDuplicate(IERC20 _token) public view {
983         uint256 length = poolInfo.length;
984         for (uint256 pid = 0; pid < length; ++pid) {
985             require(poolInfo[pid].token != _token, "add: existing pool?");
986         }
987     }
988 
989     // ADD | NEW TOKEN POOL
990     function add(uint256 _allocPoint, IERC20 _token, uint256 _taxRate, bool _withUpdate) public 
991         onlyOwner {
992         if (_withUpdate) {
993             massUpdatePools();
994         }
995         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
996         totalAllocPoint = totalAllocPoint.add(_allocPoint);
997         poolInfo.push(PoolInfo({
998             token: _token,
999             allocPoint: _allocPoint,
1000             taxRate: _taxRate,
1001             lastRewardBlock: lastRewardBlock,
1002             accGDAOPerShare: 0
1003         }));
1004     }
1005 
1006     // UPDATE | ALLOCATION POINT
1007     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1008         if (_withUpdate) {
1009             massUpdatePools();
1010         }
1011         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1012         poolInfo[_pid].allocPoint = _allocPoint;
1013     }
1014 
1015     // RETURN | REWARD MULTIPLIER OVER GIVEN BLOCK RANGE | INCLUDES START BLOCK
1016     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1017         _from = _from >= startBlock ? _from : startBlock;
1018         if (_to <= bonusEndBlock) {
1019             return _to.sub(_from);
1020         } else if (_from >= bonusEndBlock) {
1021             return _to.sub(_from);
1022         } else {
1023             return bonusEndBlock.sub(_from).add(
1024                 _to.sub(bonusEndBlock)
1025             );
1026         }
1027     }
1028 
1029     // VIEW | PENDING REWARD
1030     function pendingGDAO(uint256 _pid, address _user) external view returns (uint256) {
1031         PoolInfo storage pool = poolInfo[_pid];
1032         UserInfo storage user = userInfo[_pid][_user];
1033         uint256 accGDAOPerShare = pool.accGDAOPerShare;
1034         uint256 lpSupply = pool.token.balanceOf(address(this));
1035         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1036             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1037             uint256 GDAOReward = multiplier.mul(GDAOPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1038             accGDAOPerShare = accGDAOPerShare.add(GDAOReward.mul(1e12).div(lpSupply));
1039         }
1040         return user.amount.mul(accGDAOPerShare).div(1e12).sub(user.rewardDebt);
1041     }
1042 
1043     // UPDATE | (ALL) REWARD VARIABLES | BEWARE: HIGH GAS POTENTIAL
1044     function massUpdatePools() public {
1045         uint256 length = poolInfo.length;
1046         for (uint256 pid = 0; pid < length; ++pid) {
1047             updatePool(pid);
1048         }
1049     }
1050 
1051     // UPDATE | (ONE POOL) REWARD VARIABLES
1052     function updatePool(uint256 _pid) public {
1053         PoolInfo storage pool = poolInfo[_pid];
1054         if (block.number <= pool.lastRewardBlock) {
1055             return;
1056         }
1057         uint256 lpSupply = pool.token.balanceOf(address(this));
1058         if (lpSupply == 0) {
1059             pool.lastRewardBlock = block.number;
1060             return;
1061         }
1062         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1063         uint256 GDAOReward = multiplier.mul(GDAOPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1064         safeGDAOTransfer(address(this), GDAOReward);
1065         pool.accGDAOPerShare = pool.accGDAOPerShare.add(GDAOReward.mul(1e12).div(lpSupply));
1066         pool.lastRewardBlock = block.number;
1067     }
1068 
1069     // VALIDATE | AUTHENTICATE _PID
1070     modifier validatePool(uint256 _pid) {
1071         require(_pid < poolInfo.length, "gov: pool exists?");
1072         _;
1073     }
1074 
1075     // WITHDRAW | ASSETS (TOKENS) WITH NO REWARDS | EMERGENCY ONLY
1076     function emergencyWithdraw(uint256 _pid) public {
1077         PoolInfo storage pool = poolInfo[_pid];
1078         UserInfo storage user = userInfo[_pid][msg.sender];
1079         
1080         user.amount = 0;
1081         user.rewardDebt = 0;
1082         
1083         pool.token.safeTransfer(address(msg.sender), user.amount);
1084 
1085         emit EmergencyWithdraw(msg.sender, _pid, user.amount);        
1086     }
1087 
1088     // DEPOSIT | ASSETS (TOKENS)
1089     function deposit(uint256 _pid, uint256 _amount) public {
1090         PoolInfo storage pool = poolInfo[_pid];
1091         UserInfo storage user = userInfo[_pid][msg.sender];
1092         updatePool(_pid);
1093         uint256 taxedAmount = _amount.div(pool.taxRate);
1094 
1095         if (user.amount > 0) { // if there are already some amount deposited
1096             uint256 pending = user.amount.mul(pool.accGDAOPerShare).div(1e12).sub(user.rewardDebt);
1097             if(pending > 0) { // sends pending rewards, if applicable
1098                 safeGDAOTransfer(msg.sender, pending);
1099             }
1100         }
1101         
1102         if(_amount > 0) { // if adding more
1103             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount.sub(taxedAmount));
1104             pool.token.safeTransferFrom(address(msg.sender), address(treasury), taxedAmount);
1105             user.amount = user.amount.add(_amount.sub(taxedAmount)); // update user.amount = non-taxed amount
1106         }
1107         
1108         user.rewardDebt = user.amount.mul(pool.accGDAOPerShare).div(1e12);
1109         emit Deposit(msg.sender, _pid, _amount.sub(taxedAmount));
1110     }
1111 
1112     // WITHDRAW | ASSETS (TOKENS)
1113     function withdraw(uint256 _pid, uint256 _amount) public {
1114         PoolInfo storage pool = poolInfo[_pid];
1115         UserInfo storage user = userInfo[_pid][msg.sender];
1116         require(user.amount >= _amount, "withdraw: not good");
1117         updatePool(_pid);
1118         uint256 pending = user.amount.mul(pool.accGDAOPerShare).div(1e12).sub(user.rewardDebt);
1119 
1120         if(pending > 0) { // send pending GDAO rewards
1121             safeGDAOTransfer(msg.sender, pending);
1122         }
1123         
1124         if(_amount > 0) {
1125             user.amount = user.amount.sub(_amount);
1126             pool.token.safeTransfer(address(msg.sender), _amount);
1127         }
1128         
1129         user.rewardDebt = user.amount.mul(pool.accGDAOPerShare).div(1e12);
1130         emit Withdraw(msg.sender, _pid, _amount);
1131     }
1132 
1133     // SAFE TRANSFER FUNCTION | ACCOUNTS FOR ROUNDING ERRORS | ENSURES SUFFICIENT GDAO IN POOLS.
1134     function safeGDAOTransfer(address _to, uint256 _amount) internal {
1135         uint256 GDAOBal = gdao.balanceOf(address(this));
1136         if (_amount > GDAOBal) {
1137             gdao.transfer(_to, GDAOBal);
1138         } else {
1139             gdao.transfer(_to, _amount);
1140         }
1141     }
1142 
1143     // UPDATE | DEV ADDRESS | DEV-ONLY
1144     function dev(address _devaddr) public {
1145         require(msg.sender == devaddr, "dev: wut?");
1146         devaddr = _devaddr;
1147     }
1148 }