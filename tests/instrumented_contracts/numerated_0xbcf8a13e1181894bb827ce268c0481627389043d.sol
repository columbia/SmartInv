1 // SPDX-License-Identifier: BUSL-1.1
2 
3 pragma solidity ^0.6.11;
4 pragma experimental ABIEncoderV2;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 
83 
84 pragma solidity ^0.6.0;
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 
246 pragma solidity ^0.6.2;
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
387 
388 
389 
390 pragma solidity ^0.6.0;
391 
392 
393 
394 
395 /**
396  * @title SafeERC20
397  * @dev Wrappers around ERC20 operations that throw on failure (when the token
398  * contract returns false). Tokens that return no value (and instead revert or
399  * throw on failure) are also supported, non-reverting calls are assumed to be
400  * successful.
401  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
402  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
403  */
404 library SafeERC20 {
405     using SafeMath for uint256;
406     using Address for address;
407 
408     function safeTransfer(IERC20 token, address to, uint256 value) internal {
409         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
410     }
411 
412     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
414     }
415 
416     /**
417      * @dev Deprecated. This function has issues similar to the ones found in
418      * {IERC20-approve}, and its usage is discouraged.
419      *
420      * Whenever possible, use {safeIncreaseAllowance} and
421      * {safeDecreaseAllowance} instead.
422      */
423     function safeApprove(IERC20 token, address spender, uint256 value) internal {
424         // safeApprove should only be called when setting an initial allowance,
425         // or when resetting it to zero. To increase and decrease it, use
426         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
427         // solhint-disable-next-line max-line-length
428         require((value == 0) || (token.allowance(address(this), spender) == 0),
429             "SafeERC20: approve from non-zero to non-zero allowance"
430         );
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
432     }
433 
434     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).add(value);
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     /**
445      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
446      * on the return value: the return value is optional (but if data is returned, it must not be false).
447      * @param token The token targeted by the call.
448      * @param data The call data (encoded using abi.encode or one of its variants).
449      */
450     function _callOptionalReturn(IERC20 token, bytes memory data) private {
451         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
452         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
453         // the target address contains contract code and also asserts for success in the low-level call.
454 
455         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
456         if (returndata.length > 0) { // Return data is optional
457             // solhint-disable-next-line max-line-length
458             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/math/Math.sol
464 
465 
466 
467 pragma solidity ^0.6.0;
468 
469 /**
470  * @dev Standard math utilities missing in the Solidity language.
471  */
472 library Math {
473     /**
474      * @dev Returns the largest of two numbers.
475      */
476     function max(uint256 a, uint256 b) internal pure returns (uint256) {
477         return a >= b ? a : b;
478     }
479 
480     /**
481      * @dev Returns the smallest of two numbers.
482      */
483     function min(uint256 a, uint256 b) internal pure returns (uint256) {
484         return a < b ? a : b;
485     }
486 
487     /**
488      * @dev Returns the average of two numbers. The result is rounded towards
489      * zero.
490      */
491     function average(uint256 a, uint256 b) internal pure returns (uint256) {
492         // (a + b) / 2 can overflow, so we distribute
493         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
494     }
495 }
496 pragma solidity ^0.6.11;
497 
498 
499 contract TimelockInvesters {
500   using SafeERC20 for IERC20;
501   using SafeMath for uint256;
502 
503 
504   event Released(uint256 amount);
505   event AddInvester(address invester,uint256 amount);
506 
507   IERC20 public token;
508 
509   uint256 public  startTimestamp;
510   uint256 public  durationInDays;
511   uint256 public  totalPool;
512  
513   
514   struct Invester {
515     address to;
516     uint256 amount;
517     uint256 released;
518   }
519   
520   Invester[] investers;
521   mapping (address => uint256) investersIndex;  
522 
523    struct Recipient {
524     address to;
525     uint256 amount;
526   }
527 
528   constructor(
529     address _bid,
530     uint256 _startTimestamp,
531     uint256 _durationInDays,
532     Recipient[] memory _investors
533   ) public {
534 
535     token = IERC20(_bid);
536     durationInDays = _durationInDays;
537     startTimestamp = _startTimestamp == 0 ? blockTimestamp() : _startTimestamp;
538     
539     uint256 t=0;
540     for (uint256 i = 0; i < _investors.length; i++) {
541       address ia=_investors[i].to;
542       uint256 am=_investors[i].amount;
543       Invester memory iv=Invester({to: ia, amount:am,released:0});
544       investers.push(iv);
545       emit AddInvester(ia,am);
546       investersIndex[ia]=i+1; //cannot be 0
547       t=t.add(am);
548     }
549     totalPool=t;
550   }
551   
552   
553   function release() external {
554       uint256 i=_index1();
555       require(i>0, "investers not existed");
556       _release(i-1);
557   }
558   
559   function releasedToken() external view returns (uint256) {
560       uint256 i=_index1();
561       require(i>0, "investers not existed");  
562       return investers[i-1].released;
563   }
564   
565   function unreleasedToken() external view returns (uint256) {
566       uint256 i=_index1();
567       require(i>0, "investers not existed");  
568       return _vestedAmount(i-1);
569   }
570   
571   function checkUnreleasedToken(address _address) external view returns (uint256) {
572       uint256 i=investersIndex[_address];
573       require(i>0, "investers not existed");  
574       return _vestedAmount(i-1);
575   }
576 
577   function investedToken() external view returns (uint256) {
578       uint256 i=_index1();
579       require(i>0, "investers not existed");  
580       return investers[i-1].amount;
581   }
582   
583   
584   function poolBalance() external view returns (uint256){
585       return token.balanceOf(address(this));
586   }
587   
588   function minutesElapsed() external view returns (uint256){
589     if (blockTimestamp() < startTimestamp) {
590       return 0;
591     }
592 
593     uint256 elapsedTime = blockTimestamp().sub(startTimestamp);
594     uint256 elapsedMinutes = elapsedTime.div(60);
595     
596     return elapsedMinutes;
597   }
598   
599 
600   function _release(uint256 index) internal {
601     uint256 vested = _vestedAmount(index);
602     require(vested > 0, "No tokens to release");
603 
604     investers[index].released = investers[index].released.add(vested);
605     token.safeTransfer(investers[index].to, vested);
606 
607     emit Released(vested);
608   }
609 
610   function _index1() view internal returns (uint256) {
611       return investersIndex[msg.sender];
612   }
613 
614   function _vestedAmount(uint256 index) internal view returns (uint256) {
615     if (blockTimestamp() < startTimestamp) {
616       return 0;
617     }
618 
619     uint256 elapsedTime = blockTimestamp().sub(startTimestamp);
620     uint256 elapsedMinutes = elapsedTime.div(60);
621     uint256 durationMinutes = durationInDays.mul(24).mul(60);
622 
623 
624     // If over vesting duration, all tokens vested
625     if (elapsedMinutes >= durationMinutes) {
626       return investers[index].amount;
627     } else {
628       uint256 totalBalance = investers[index].amount;
629       uint256 released=investers[index].released;
630       uint256 currentBalance = token.balanceOf(address(this));
631 
632       uint256 vested = totalBalance.mul(elapsedMinutes).div(durationMinutes);
633       uint256 unreleased = vested.sub(released);
634 
635       // currentBalance can be 0 in case of vesting being revoked earlier.
636       return Math.min(currentBalance, unreleased);
637     }
638   }
639 
640   function blockTimestamp() public view virtual returns (uint256) {
641     return block.timestamp;
642   }
643 }