1 /**
2  *
3  * Market has owned you?
4  * Now you will own the market
5  *
6  * Loading blackfisk.ai
7  *
8  *           .ooooooooooooooooooooooooooo+
9                 .ooooooooooooooooooooooooooo+
10                 .ooooooooooooooooooooooooooo+
11                 .ooooooooooooooooooooooooooo+
12        :+++++++++oooooooooooooooooooooooooooo+++++++++`
13        /oooooooooooooooooooooooooooooooooooooooooooooo`
14        /oooooooooooooooooooooooooooooooooooooooooooooo`
15        /oooooooooooooooooooooooooooooooooooooooooooooo`
16        /oooooooooooooooooooooooooooooooooooooooooooooo.````````
17        /oooooooooooooooooooooooooooooooooooooooooooooooooooooo-
18        /oooooooooooooooooooooooooooooooooooooooooooooooooooooo-
19        /oooooooooooooooooooooooooooooooooooooooooooooooooooooo-
20        /oooooooooooooooooooooooooooooooooooooooooooooooooooooo-
21        .--------/ooooooooooooooooooooooooooooooooooooooooooooo-
22                 .ooooooooooooooooooooooooo++++ooooooooo++++ooo-
23                 .oooooooooooooooooooooooo+---:oooooooo+:--:+oo-
24                 .oooooooooooooooooooooooo+----oooooooo+---:+oo-
25                 .oooooooooooooooooooooooo+----oooooooo+---:+oo-
26                  `````````````````/oooooo+::::oooooooo+:::/+oo-
27                                   :ooooooooooooooooooooooooooo-
28                                   :ooooooooooooooooooooooooooo-
29                                   :ooooooooooooooooooooooooooo-
30         ``````````````````````````/ooooooooooooooooooooooooooo:`````````````````````````````
31         /oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo/
32         /oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo/
33         /oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo/
34         /oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo/
35         /ooooooooo+::::::::ooooooooooooooooooooooooooo:::::::::/ooooooooo::::::::+ooooooooo/
36         /ooooooooo/        +oooooooooooooooooooooooooo`        -oooooooo+        /ooooooooo/
37         /ooooooooo/        +oooooooooooooooooooooooooo`        -oooooooo+        /ooooooooo/
38         /ooooooooo/        +oooooooooooooooooooooooooo`        -oooooooo+        /ooooooooo/
39 ......../ooooooooo+........ooooooooooooooooooooooooooo`        -ooooooooo........+ooooooooo/........
40 ooooooooo-```````-ooooooooo.```````/oooooooooooooooooo`        `````````.ooooooooo-```````-ooooooooo
41 ooooooooo-       .ooooooooo`       :oooooooooooooooooo`                 `ooooooooo.       -ooooooooo
42 ooooooooo-       .ooooooooo`       :oooooooooooooooooo`                 `ooooooooo.       -ooooooooo
43 ooooooooo-       .ooooooooo`       :oooooooooooooooooo`                 `ooooooooo.       -ooooooooo
44 ooooooooo-       .ooooooooo`       :ooooooooo+.......+/////////-        `ooooooooo.       -ooooooooo
45 ooooooooo-       .ooooooooo`       :ooooooooo+       +ooooooooo:        `ooooooooo.       -ooooooooo
46 ooooooooo-       .ooooooooo`       :ooooooooo+       +ooooooooo:        `ooooooooo.       -ooooooooo
47 ooooooooo-       .ooooooooo`       :ooooooooo+       +ooooooooo:        `ooooooooo.       -ooooooooo
48 ooooooooo-       .ooooooooo`       :ooooooooo+       +ooooooooo:        `ooooooooo.       -ooooooooo
49 
50  */
51 
52 
53 pragma solidity ^0.6.0;
54 
55 
56 interface IERC20 {
57     /**
58      * @dev Returns the amount of tokens in existence.
59      */
60     function totalSupply() external view returns (uint256);
61 
62     /**
63      * @dev Returns the amount of tokens owned by `account`.
64      */
65     function balanceOf(address account) external view returns (uint256);
66 
67     /**
68      * @dev Moves `amount` tokens from the caller's account to `recipient`.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transfer(address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Returns the remaining number of tokens that `spender` will be
78      * allowed to spend on behalf of `owner` through {transferFrom}. This is
79      * zero by default.
80      *
81      * This value changes when {approve} or {transferFrom} are called.
82      */
83     function allowance(address owner, address spender) external view returns (uint256);
84 
85     /**
86      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * IMPORTANT: Beware that changing an allowance with this method brings the risk
91      * that someone may use both the old and the new allowance by unfortunate
92      * transaction ordering. One possible solution to mitigate this race
93      * condition is to first reduce the spender's allowance to 0 and set the
94      * desired value afterwards:
95      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
96      *
97      * Emits an {Approval} event.
98      */
99     function approve(address spender, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Moves `amount` tokens from `sender` to `recipient` using the
103      * allowance mechanism. `amount` is then deducted from the caller's
104      * allowance.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
111 
112     /**
113      * @dev Emitted when `value` tokens are moved from one account (`from`) to
114      * another (`to`).
115      *
116      * Note that `value` may be zero.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     /**
121      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
122      * a call to {approve}. `value` is the new allowance.
123      */
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly {codehash := extcodehash(account)}
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success,) = recipient.call{value : amount}("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344         return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 library SafeERC20 {
408     using SafeMath for uint256;
409     using Address for address;
410 
411     function safeTransfer(IERC20 token, address to, uint256 value) internal {
412         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
413     }
414 
415     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
416         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
417     }
418 
419     /**
420      * @dev Deprecated. This function has issues similar to the ones found in
421      * {IERC20-approve}, and its usage is discouraged.
422      *
423      * Whenever possible, use {safeIncreaseAllowance} and
424      * {safeDecreaseAllowance} instead.
425      */
426     function safeApprove(IERC20 token, address spender, uint256 value) internal {
427         // safeApprove should only be called when setting an initial allowance,
428         // or when resetting it to zero. To increase and decrease it, use
429         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
430         // solhint-disable-next-line max-line-length
431         require((value == 0) || (token.allowance(address(this), spender) == 0),
432             "SafeERC20: approve from non-zero to non-zero allowance"
433         );
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
435     }
436 
437     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
438         uint256 newAllowance = token.allowance(address(this), spender).add(value);
439         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
440     }
441 
442     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
443         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     /**
448      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
449      * on the return value: the return value is optional (but if data is returned, it must not be false).
450      * @param token The token targeted by the call.
451      * @param data The call data (encoded using abi.encode or one of its variants).
452      */
453     function _callOptionalReturn(IERC20 token, bytes memory data) private {
454         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
455         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
456         // the target address contains contract code and also asserts for success in the low-level call.
457 
458         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
459         if (returndata.length > 0) {// Return data is optional
460             // solhint-disable-next-line max-line-length
461             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
462         }
463     }
464 }
465 
466 
467 library EnumerableSet {
468     // To implement this library for multiple types with as little code
469     // repetition as possible, we write it in terms of a generic Set type with
470     // bytes32 values.
471     // The Set implementation uses private functions, and user-facing
472     // implementations (such as AddressSet) are just wrappers around the
473     // underlying Set.
474     // This means that we can only create new EnumerableSets for types that fit
475     // in bytes32.
476 
477     struct Set {
478         // Storage of set values
479         bytes32[] _values;
480 
481         // Position of the value in the `values` array, plus 1 because index 0
482         // means a value is not in the set.
483         mapping(bytes32 => uint256) _indexes;
484     }
485 
486     /**
487      * @dev Add a value to a set. O(1).
488      *
489      * Returns true if the value was added to the set, that is if it was not
490      * already present.
491      */
492     function _add(Set storage set, bytes32 value) private returns (bool) {
493         if (!_contains(set, value)) {
494             set._values.push(value);
495             // The value is stored at length-1, but we add 1 to all indexes
496             // and use 0 as a sentinel value
497             set._indexes[value] = set._values.length;
498             return true;
499         } else {
500             return false;
501         }
502     }
503 
504     /**
505      * @dev Removes a value from a set. O(1).
506      *
507      * Returns true if the value was removed from the set, that is if it was
508      * present.
509      */
510     function _remove(Set storage set, bytes32 value) private returns (bool) {
511         // We read and store the value's index to prevent multiple reads from the same storage slot
512         uint256 valueIndex = set._indexes[value];
513 
514         if (valueIndex != 0) {// Equivalent to contains(set, value)
515             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
516             // the array, and then remove the last element (sometimes called as 'swap and pop').
517             // This modifies the order of the array, as noted in {at}.
518 
519             uint256 toDeleteIndex = valueIndex - 1;
520             uint256 lastIndex = set._values.length - 1;
521 
522             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
523             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
524 
525             bytes32 lastvalue = set._values[lastIndex];
526 
527             // Move the last value to the index where the value to delete is
528             set._values[toDeleteIndex] = lastvalue;
529             // Update the index for the moved value
530             set._indexes[lastvalue] = toDeleteIndex + 1;
531             // All indexes are 1-based
532 
533             // Delete the slot where the moved value was stored
534             set._values.pop();
535 
536             // Delete the index for the deleted slot
537             delete set._indexes[value];
538 
539             return true;
540         } else {
541             return false;
542         }
543     }
544 
545     /**
546      * @dev Returns true if the value is in the set. O(1).
547      */
548     function _contains(Set storage set, bytes32 value) private view returns (bool) {
549         return set._indexes[value] != 0;
550     }
551 
552     /**
553      * @dev Returns the number of values on the set. O(1).
554      */
555     function _length(Set storage set) private view returns (uint256) {
556         return set._values.length;
557     }
558 
559     /**
560      * @dev Returns the value stored at position `index` in the set. O(1).
561      *
562      * Note that there are no guarantees on the ordering of values inside the
563      * array, and it may change when more values are added or removed.
564      *
565      * Requirements:
566      *
567      * - `index` must be strictly less than {length}.
568      */
569     function _at(Set storage set, uint256 index) private view returns (bytes32) {
570         require(set._values.length > index, "EnumerableSet: index out of bounds");
571         return set._values[index];
572     }
573 
574     // AddressSet
575 
576     struct AddressSet {
577         Set _inner;
578     }
579 
580     /**
581      * @dev Add a value to a set. O(1).
582      *
583      * Returns true if the value was added to the set, that is if it was not
584      * already present.
585      */
586     function add(AddressSet storage set, address value) internal returns (bool) {
587         return _add(set._inner, bytes32(uint256(value)));
588     }
589 
590     /**
591      * @dev Removes a value from a set. O(1).
592      *
593      * Returns true if the value was removed from the set, that is if it was
594      * present.
595      */
596     function remove(AddressSet storage set, address value) internal returns (bool) {
597         return _remove(set._inner, bytes32(uint256(value)));
598     }
599 
600     /**
601      * @dev Returns true if the value is in the set. O(1).
602      */
603     function contains(AddressSet storage set, address value) internal view returns (bool) {
604         return _contains(set._inner, bytes32(uint256(value)));
605     }
606 
607     /**
608      * @dev Returns the number of values in the set. O(1).
609      */
610     function length(AddressSet storage set) internal view returns (uint256) {
611         return _length(set._inner);
612     }
613 
614     /**
615      * @dev Returns the value stored at position `index` in the set. O(1).
616      *
617      * Note that there are no guarantees on the ordering of values inside the
618      * array, and it may change when more values are added or removed.
619      *
620      * Requirements:
621      *
622      * - `index` must be strictly less than {length}.
623      */
624     function at(AddressSet storage set, uint256 index) internal view returns (address) {
625         return address(uint256(_at(set._inner, index)));
626     }
627 
628 
629     // UintSet
630 
631     struct UintSet {
632         Set _inner;
633     }
634 
635     /**
636      * @dev Add a value to a set. O(1).
637      *
638      * Returns true if the value was added to the set, that is if it was not
639      * already present.
640      */
641     function add(UintSet storage set, uint256 value) internal returns (bool) {
642         return _add(set._inner, bytes32(value));
643     }
644 
645     /**
646      * @dev Removes a value from a set. O(1).
647      *
648      * Returns true if the value was removed from the set, that is if it was
649      * present.
650      */
651     function remove(UintSet storage set, uint256 value) internal returns (bool) {
652         return _remove(set._inner, bytes32(value));
653     }
654 
655     /**
656      * @dev Returns true if the value is in the set. O(1).
657      */
658     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
659         return _contains(set._inner, bytes32(value));
660     }
661 
662     /**
663      * @dev Returns the number of values on the set. O(1).
664      */
665     function length(UintSet storage set) internal view returns (uint256) {
666         return _length(set._inner);
667     }
668 
669     /**
670      * @dev Returns the value stored at position `index` in the set. O(1).
671      *
672      * Note that there are no guarantees on the ordering of values inside the
673      * array, and it may change when more values are added or removed.
674      *
675      * Requirements:
676      *
677      * - `index` must be strictly less than {length}.
678      */
679     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
680         return uint256(_at(set._inner, index));
681     }
682 }
683 
684 
685 abstract contract Context {
686     function _msgSender() internal view virtual returns (address payable) {
687         return msg.sender;
688     }
689 
690     function _msgData() internal view virtual returns (bytes memory) {
691         this;
692         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
693         return msg.data;
694     }
695 }
696 
697 
698 contract Ownable is Context {
699     address private _owner;
700 
701     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
702 
703     /**
704      * @dev Initializes the contract setting the deployer as the initial owner.
705      */
706     constructor () internal {
707         address msgSender = _msgSender();
708         _owner = msgSender;
709         emit OwnershipTransferred(address(0), msgSender);
710     }
711 
712     /**
713      * @dev Returns the address of the current owner.
714      */
715     function owner() public view returns (address) {
716         return _owner;
717     }
718 
719     /**
720      * @dev Throws if called by any account other than the owner.
721      */
722     modifier onlyOwner() {
723         require(_owner == _msgSender(), "Ownable: caller is not the owner");
724         _;
725     }
726 
727     /**
728      * @dev Leaves the contract without owner. It will not be possible to call
729      * `onlyOwner` functions anymore. Can only be called by the current owner.
730      *
731      * NOTE: Renouncing ownership will leave the contract without an owner,
732      * thereby removing any functionality that is only available to the owner.
733      */
734     function renounceOwnership() public virtual onlyOwner {
735         emit OwnershipTransferred(_owner, address(0));
736         _owner = address(0);
737     }
738 
739     /**
740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
741      * Can only be called by the current owner.
742      */
743     function transferOwnership(address newOwner) public virtual onlyOwner {
744         require(newOwner != address(0), "Ownable: new owner is the zero address");
745         emit OwnershipTransferred(_owner, newOwner);
746         _owner = newOwner;
747     }
748 }
749 
750 
751 contract ERC20 is Context, IERC20 {
752     using SafeMath for uint256;
753     using Address for address;
754 
755     mapping(address => uint256) private _balances;
756 
757     mapping(address => mapping(address => uint256)) private _allowances;
758 
759     uint256 private _totalSupply;
760 
761     string private _name;
762     string private _symbol;
763     uint8 private _decimals;
764 
765     /**
766      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
767      * a default value of 18.
768      *
769      * To select a different value for {decimals}, use {_setupDecimals}.
770      *
771      * All three of these values are immutable: they can only be set once during
772      * construction.
773      */
774     constructor (string memory name, string memory symbol) public {
775         _name = name;
776         _symbol = symbol;
777         _decimals = 18;
778     }
779 
780     /**
781      * @dev Returns the name of the token.
782      */
783     function name() public view returns (string memory) {
784         return _name;
785     }
786 
787     /**
788      * @dev Returns the symbol of the token, usually a shorter version of the
789      * name.
790      */
791     function symbol() public view returns (string memory) {
792         return _symbol;
793     }
794 
795     /**
796      * @dev Returns the number of decimals used to get its user representation.
797      * For example, if `decimals` equals `2`, a balance of `505` tokens should
798      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
799      *
800      * Tokens usually opt for a value of 18, imitating the relationship between
801      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
802      * called.
803      *
804      * NOTE: This information is only used for _display_ purposes: it in
805      * no way affects any of the arithmetic of the contract, including
806      * {IERC20-balanceOf} and {IERC20-transfer}.
807      */
808     function decimals() public view returns (uint8) {
809         return _decimals;
810     }
811 
812     /**
813      * @dev See {IERC20-totalSupply}.
814      */
815     function totalSupply() public view override returns (uint256) {
816         return _totalSupply;
817     }
818 
819     /**
820      * @dev See {IERC20-balanceOf}.
821      */
822     function balanceOf(address account) public view override returns (uint256) {
823         return _balances[account];
824     }
825 
826     /**
827      * @dev See {IERC20-transfer}.
828      *
829      * Requirements:
830      *
831      * - `recipient` cannot be the zero address.
832      * - the caller must have a balance of at least `amount`.
833      */
834     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
835         _transfer(_msgSender(), recipient, amount);
836         return true;
837     }
838 
839     /**
840      * @dev See {IERC20-allowance}.
841      */
842     function allowance(address owner, address spender) public view virtual override returns (uint256) {
843         return _allowances[owner][spender];
844     }
845 
846     /**
847      * @dev See {IERC20-approve}.
848      *
849      * Requirements:
850      *
851      * - `spender` cannot be the zero address.
852      */
853     function approve(address spender, uint256 amount) public virtual override returns (bool) {
854         _approve(_msgSender(), spender, amount);
855         return true;
856     }
857 
858     /**
859      * @dev See {IERC20-transferFrom}.
860      *
861      * Emits an {Approval} event indicating the updated allowance. This is not
862      * required by the EIP. See the note at the beginning of {ERC20};
863      *
864      * Requirements:
865      * - `sender` and `recipient` cannot be the zero address.
866      * - `sender` must have a balance of at least `amount`.
867      * - the caller must have allowance for ``sender``'s tokens of at least
868      * `amount`.
869      */
870     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
871         _transfer(sender, recipient, amount);
872         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
873         return true;
874     }
875 
876     /**
877      * @dev Atomically increases the allowance granted to `spender` by the caller.
878      *
879      * This is an alternative to {approve} that can be used as a mitigation for
880      * problems described in {IERC20-approve}.
881      *
882      * Emits an {Approval} event indicating the updated allowance.
883      *
884      * Requirements:
885      *
886      * - `spender` cannot be the zero address.
887      */
888     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
889         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
890         return true;
891     }
892 
893     /**
894      * @dev Atomically decreases the allowance granted to `spender` by the caller.
895      *
896      * This is an alternative to {approve} that can be used as a mitigation for
897      * problems described in {IERC20-approve}.
898      *
899      * Emits an {Approval} event indicating the updated allowance.
900      *
901      * Requirements:
902      *
903      * - `spender` cannot be the zero address.
904      * - `spender` must have allowance for the caller of at least
905      * `subtractedValue`.
906      */
907     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
908         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
909         return true;
910     }
911 
912     /**
913      * @dev Moves tokens `amount` from `sender` to `recipient`.
914      *
915      * This is internal function is equivalent to {transfer}, and can be used to
916      * e.g. implement automatic token fees, slashing mechanisms, etc.
917      *
918      * Emits a {Transfer} event.
919      *
920      * Requirements:
921      *
922      * - `sender` cannot be the zero address.
923      * - `recipient` cannot be the zero address.
924      * - `sender` must have a balance of at least `amount`.
925      */
926     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
927         require(sender != address(0), "ERC20: transfer from the zero address");
928         require(recipient != address(0), "ERC20: transfer to the zero address");
929 
930         _beforeTokenTransfer(sender, recipient, amount);
931 
932         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
933         _balances[recipient] = _balances[recipient].add(amount);
934         emit Transfer(sender, recipient, amount);
935     }
936 
937     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
938      * the total supply.
939      *
940      * Emits a {Transfer} event with `from` set to the zero address.
941      *
942      * Requirements
943      *
944      * - `to` cannot be the zero address.
945      */
946     function _mint(address account, uint256 amount) internal virtual {
947         require(account != address(0), "ERC20: mint to the zero address");
948 
949         _beforeTokenTransfer(address(0), account, amount);
950 
951         _totalSupply = _totalSupply.add(amount);
952         _balances[account] = _balances[account].add(amount);
953         emit Transfer(address(0), account, amount);
954     }
955 
956     /**
957      * @dev Destroys `amount` tokens from `account`, reducing the
958      * total supply.
959      *
960      * Emits a {Transfer} event with `to` set to the zero address.
961      *
962      * Requirements
963      *
964      * - `account` cannot be the zero address.
965      * - `account` must have at least `amount` tokens.
966      */
967     function _burn(address account, uint256 amount) internal virtual {
968         require(account != address(0), "ERC20: burn from the zero address");
969 
970         _beforeTokenTransfer(account, address(0), amount);
971 
972         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
973         _totalSupply = _totalSupply.sub(amount);
974         emit Transfer(account, address(0), amount);
975     }
976 
977     /**
978      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
979      *
980      * This is internal function is equivalent to `approve`, and can be used to
981      * e.g. set automatic allowances for certain subsystems, etc.
982      *
983      * Emits an {Approval} event.
984      *
985      * Requirements:
986      *
987      * - `owner` cannot be the zero address.
988      * - `spender` cannot be the zero address.
989      */
990     function _approve(address owner, address spender, uint256 amount) internal virtual {
991         require(owner != address(0), "ERC20: approve from the zero address");
992         require(spender != address(0), "ERC20: approve to the zero address");
993 
994         _allowances[owner][spender] = amount;
995         emit Approval(owner, spender, amount);
996     }
997 
998     /**
999      * @dev Sets {decimals} to a value other than the default one of 18.
1000      *
1001      * WARNING: This function should only be called from the constructor. Most
1002      * applications that interact with token contracts will not expect
1003      * {decimals} to ever change, and may work incorrectly if it does.
1004      */
1005     function _setupDecimals(uint8 decimals_) internal {
1006         _decimals = decimals_;
1007     }
1008 
1009     /**
1010      * @dev Hook that is called before any transfer of tokens. This includes
1011      * minting and burning.
1012      *
1013      * Calling conditions:
1014      *
1015      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1016      * will be to transferred to `to`.
1017      * - when `from` is zero, `amount` tokens will be minted for `to`.
1018      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1019      * - `from` and `to` are never both zero.
1020      *
1021      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1022      */
1023     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1024 }
1025 
1026 contract BlackFisk is ERC20("BlackFisk", "BLFI"), Ownable {
1027     uint256 public total = 140000;
1028 
1029     constructor () public {
1030         // mint tokens
1031         _mint(msg.sender, total.mul(10 ** 18));
1032     }
1033 
1034     function burn(uint256 _amount) public {
1035         _burn(msg.sender, _amount);
1036     }
1037 }
1038 
1039 contract BlackFiskStaking is Ownable {
1040 
1041     /**
1042     * Libs for safeErc-20 and SafeMath
1043     */
1044     using SafeMath for uint256;
1045     using SafeERC20 for IERC20;
1046 
1047     /**
1048      *  Public constants helpers
1049      */
1050     address public zeroAddress = address(0);
1051     /** Number of currentEpoch */
1052     uint256 public currentEpoch = 0;
1053     /** Developer commission in case of using claim instead of user */
1054     uint256 public devCommission = 0;
1055 
1056 
1057     /**
1058     * Public structs
1059     */
1060 
1061     /** Struct User */
1062     struct User {
1063         uint256 activeAmount;
1064         uint256 totalDeposited;
1065         uint256 lastEpoch;
1066         uint256 lastDeposit;
1067         uint256 lastDepositEpoch;
1068     }
1069 
1070     /** Struct for Pool */
1071     struct Pool {
1072         uint256 totalSupplyLp;
1073         IERC20 lpToken;
1074     }
1075 
1076     /** Struct for Epoch  */
1077     struct Epoch {
1078         uint256 startTime;
1079         uint256 startBlock;
1080         uint256 endTime;
1081         uint256 endBlock;
1082         uint256 eth;
1083         uint256[] poolStatus;
1084     }
1085 
1086     /** List of supported lp pools for staking */
1087     Pool[] public pools;
1088     /** HashMap of users that take part in staking */
1089     mapping(uint256 => mapping(address => User)) public userInfo;
1090     /** HashMap of epoch starting from zero */
1091     mapping(uint256 => Epoch) public Epochs;
1092 
1093 
1094     /**
1095     * All events that uses in public transactions
1096     */
1097     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1098     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1099     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1100     event Claim(address indexed user, uint256 indexed pid, uint256 amount);
1101     event ClaimInsteadOfUser(address indexed caller, address indexed user, uint256 indexed pid, uint256 amount);
1102 
1103     /** Creates first epoch and init contract */
1104     constructor() public {
1105         Epoch memory epoch = Epoch(now, block.number, 0, 0, 0, new uint256[](0));
1106         Epochs[currentEpoch] = epoch;
1107     }
1108 
1109     /**
1110     *   Main for using BlackFiskStaking for users
1111     */
1112 
1113     /** Method that used by user to deposit tokens.
1114     * Check for reward if user deposited before than calculate and send them reward
1115     * than transfer lp-tokens to contract and start staking
1116     */
1117     function deposit(uint pid, uint256 amount) public {
1118         require(amount > 0, "BlackFiskStaking : Deposit must be bigger than zero");
1119         User storage user = userInfo[pid][msg.sender];
1120         if (user.totalDeposited > 0) {
1121             claim(pid); // checking for rewards
1122         } else {
1123             user.lastEpoch = currentEpoch;
1124         }
1125 
1126         user.lastDeposit = user.lastDeposit.add(amount);
1127         user.lastDepositEpoch = currentEpoch.add(1);
1128         user.totalDeposited = user.totalDeposited.add(amount);
1129         pools[pid].totalSupplyLp = pools[pid].totalSupplyLp.add(amount);
1130 
1131         pools[pid].lpToken.safeTransferFrom(address(msg.sender), address(this), amount);
1132         emit Deposit(msg.sender, pid, amount);
1133     }
1134 
1135     /** Method that used by user to withdraw tokens.
1136     * Check for reward if user deposited before than calculate and send them reward
1137     * than transfer lp-tokens to user
1138     */
1139     function withdraw(uint pid, uint256 amount) public {
1140         User storage user = userInfo[pid][msg.sender];
1141 
1142         require(amount > 0, "BlackFiskStaking : Withdraw must be bigger than zero");
1143         require(user.totalDeposited >= amount, "BlackFiskStaking: trying to withdraw more then are");
1144 
1145         claim(pid); // checking for rewards
1146 
1147         if(amount > user.lastDeposit){
1148             uint difference = amount.sub(user.lastDeposit);
1149             user.activeAmount = user.activeAmount.sub(difference);
1150             user.lastDeposit = 0;
1151             user.lastDepositEpoch = 0;
1152         } else {
1153             user.lastDeposit = user.lastDeposit.sub(amount);
1154         }
1155 
1156         user.totalDeposited = user.totalDeposited.sub(amount);
1157         pools[pid].totalSupplyLp = pools[pid].totalSupplyLp.sub(amount);
1158         pools[pid].lpToken.safeTransfer(address(msg.sender), amount);
1159         emit Withdraw(msg.sender, pid, amount);
1160     }
1161 
1162     /** Emergency withdraw use only in case of emergency.
1163     *   Nullify all rewards and withdraw lp-tokens
1164     */
1165     function emergencyWithdraw(uint pid) public {
1166         User storage user = userInfo[pid][msg.sender];
1167 
1168         uint amount = user.totalDeposited;
1169         pools[pid].totalSupplyLp = pools[pid].totalSupplyLp.sub(amount);
1170         pools[pid].lpToken.safeTransfer(address(msg.sender), amount);
1171 
1172         user.totalDeposited = 0;
1173         user.activeAmount = 0;
1174         user.lastDeposit = 0;
1175         user.lastDepositEpoch = 0;
1176 
1177         user.lastEpoch = currentEpoch;
1178         emit EmergencyWithdraw(msg.sender, pid, amount);
1179     }
1180 
1181     /** Method that calculate user reward and withdraw it
1182     *  Calculate reward by missed epochs and withdraw eth
1183     */
1184     function claim(uint pid) public payable {
1185         User storage user = userInfo[pid][msg.sender];
1186         uint amount = calcReward(pid, msg.sender);
1187 
1188         if(user.lastDepositEpoch <= currentEpoch){
1189             user.activeAmount = user.activeAmount.add(user.lastDeposit);
1190             user.lastDepositEpoch = 0;
1191             user.lastDeposit = 0;
1192         }
1193 
1194         if (address(this).balance > amount) {
1195             msg.sender.transfer(amount);
1196         } else {
1197             msg.sender.transfer(address(this).balance);
1198         }
1199         user.lastEpoch = currentEpoch;
1200         emit Claim(msg.sender, pid, amount);
1201     }
1202 
1203 
1204     /**
1205     * All admin functions
1206     */
1207 
1208     /** Waits for eth from deployer and call endEpoch*/
1209     receive() external payable {
1210         endEpoch(msg.value);
1211     }
1212 
1213     /** Close current epoch and start new Epoch */
1214     function endEpoch(uint256 amount) public payable onlyOwner {
1215         require(amount > 0, "BlackFiskStaking: reward must be bigger than zero");
1216         Epoch storage previousEpoch = Epochs[currentEpoch];
1217         previousEpoch.endBlock = block.number;
1218         previousEpoch.endTime = now;
1219         previousEpoch.eth = amount;
1220 
1221         // calculating all stakes
1222         for (uint i = 0; i < pools.length; i++) {
1223             previousEpoch.poolStatus.push(pools[i].totalSupplyLp);
1224         }
1225 
1226         currentEpoch = currentEpoch.add(1);
1227         Epochs[currentEpoch] = Epoch(now, block.number, 0, 0, 0, new uint256[](0));
1228     }
1229 
1230     /** add new lp-pool to staking (can be called from deployer) */
1231     function add(IERC20 _lpToken) public onlyOwner {
1232         pools.push(Pool({
1233         lpToken : _lpToken,
1234         totalSupplyLp : 0
1235         }));
1236     }
1237 
1238     /** Can claim eth instead of user.
1239      * This function will be used when person a lot of
1240      * epochs as a result his commission is to high.
1241      * This method send reward of user with but with minus commission that
1242      * deployers pays instead of him.
1243      * This method can helps to save a lot of eth.
1244      */
1245     function claimInsteadOfUser(uint pid, address payable userAddress, uint commission, uint reward) public onlyOwner {
1246         User storage user = userInfo[pid][userAddress];
1247 
1248         uint256 amount = reward.sub(commission);
1249 
1250         if (address(this).balance > amount) {
1251             userAddress.transfer(amount);
1252         } else {
1253             userAddress.transfer(address(this).balance);
1254         }
1255 
1256         devCommission = devCommission.add(commission);
1257         user.lastEpoch = currentEpoch;
1258         emit ClaimInsteadOfUser(msg.sender, userAddress, pid, amount);
1259     }
1260 
1261     /** Emergency only. Withdraw eth from contract when something went wrong or for migration to new contract*/
1262     function withdrawEther(uint256 amount) public onlyOwner {
1263         msg.sender.transfer(amount);
1264     }
1265 
1266     /** Withdraw eth (devs commissions received in claimInsteadOfUser) */
1267     function claimDevCommission() public onlyOwner {
1268         msg.sender.transfer(devCommission);
1269         devCommission = 0;
1270     }
1271 
1272 
1273     /**
1274     *  View methods
1275     */
1276 
1277     /** Return length of pools list */
1278     function poolLength() external view returns (uint256) {
1279         return pools.length;
1280     }
1281 
1282     /**
1283     *   Calculate profit of epochs starting from now
1284     */
1285     function getBotProfit(uint amountOfEpochs) external view returns (uint256){
1286         uint profit = 0;
1287         uint startEpochIndex =  currentEpoch.sub(1);
1288         uint endEpochIndex  = 0;
1289         if(amountOfEpochs <= startEpochIndex){
1290             endEpochIndex = currentEpoch.sub(amountOfEpochs);
1291         }
1292         for (uint i = startEpochIndex; i > endEpochIndex; i--) {
1293             Epoch storage epoch = Epochs[i];
1294             profit = profit.add(epoch.eth);
1295         }
1296 
1297         // to avoid overflow
1298         Epoch storage epoch = Epochs[0];
1299         profit = profit.add(epoch.eth);
1300 
1301         return profit;
1302     }
1303 
1304     /** Calculate Possible Reward for all epochs. Used by app and users methods. */
1305     function calcReward(uint pid, address user) public view returns (uint256){
1306         User storage currentUser = userInfo[pid][user];
1307         uint256 totalReward = 0;
1308         for (uint256 i = currentUser.lastEpoch; i < currentEpoch; i++) {
1309             uint amount = currentUser.activeAmount;
1310             if(currentUser.lastDepositEpoch <= i){
1311                 amount = amount.add(currentUser.lastDeposit);
1312             }
1313 
1314             Epoch storage epoch = Epochs[i];
1315             uint256 rewardForPool = epoch.eth.div(epoch.poolStatus.length);
1316             uint reward = amount.mul(rewardForPool).div(epoch.poolStatus[pid]);
1317             totalReward = totalReward.add(reward);
1318         }
1319         return totalReward;
1320     }
1321 }