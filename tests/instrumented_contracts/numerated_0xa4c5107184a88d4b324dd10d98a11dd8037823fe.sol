1 pragma solidity 0.6.12;
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 // SPDX-License-Identifier: MIT
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18   function _msgSender() internal view virtual returns (address payable) {
19     return msg.sender;
20   }
21 
22   function _msgData() internal view virtual returns (bytes memory) {
23     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24     return msg.data;
25   }
26 }
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 pragma solidity >=0.6.0 <0.8.0;
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44   address private _owner;
45   event OwnershipTransferred(
46     address indexed previousOwner,
47     address indexed newOwner
48   );
49 
50   /**
51    * @dev Initializes the contract setting the deployer as the initial owner.
52    */
53   constructor() internal {
54     address msgSender = _msgSender();
55     _owner = msgSender;
56     emit OwnershipTransferred(address(0), msgSender);
57   }
58 
59   /**
60    * @dev Returns the address of the current owner.
61    */
62   function owner() public view returns (address) {
63     return _owner;
64   }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(_owner == _msgSender(), "Ownable: caller is not the owner");
71     _;
72   }
73 
74   /**
75    * @dev Leaves the contract without owner. It will not be possible to call
76    * `onlyOwner` functions anymore. Can only be called by the current owner.
77    *
78    * NOTE: Renouncing ownership will leave the contract without an owner,
79    * thereby removing any functionality that is only available to the owner.
80    */
81   function renounceOwnership() public virtual onlyOwner {
82     emit OwnershipTransferred(_owner, address(0));
83     _owner = address(0);
84   }
85 
86   /**
87    * @dev Transfers ownership of the contract to a new account (`newOwner`).
88    * Can only be called by the current owner.
89    */
90   function transferOwnership(address newOwner) public virtual onlyOwner {
91     require(newOwner != address(0), "Ownable: new owner is the zero address");
92     emit OwnershipTransferred(_owner, newOwner);
93     _owner = newOwner;
94   }
95 }
96 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
97 
98 pragma solidity >=0.6.0 <0.8.0;
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104   /**
105    * @dev Returns the amount of tokens in existence.
106    */
107   function totalSupply() external view returns (uint256);
108 
109   /**
110    * @dev Returns the amount of tokens owned by `account`.
111    */
112   function balanceOf(address account) external view returns (uint256);
113 
114   /**
115    * @dev Moves `amount` tokens from the caller's account to `recipient`.
116    *
117    * Returns a boolean value indicating whether the operation succeeded.
118    *
119    * Emits a {Transfer} event.
120    */
121   function transfer(address recipient, uint256 amount) external returns (bool);
122 
123   /**
124    * @dev Returns the remaining number of tokens that `spender` will be
125    * allowed to spend on behalf of `owner` through {transferFrom}. This is
126    * zero by default.
127    *
128    * This value changes when {approve} or {transferFrom} are called.
129    */
130   function allowance(address owner, address spender)
131     external
132     view
133     returns (uint256);
134 
135   /**
136    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137    *
138    * Returns a boolean value indicating whether the operation succeeded.
139    *
140    * IMPORTANT: Beware that changing an allowance with this method brings the risk
141    * that someone may use both the old and the new allowance by unfortunate
142    * transaction ordering. One possible solution to mitigate this race
143    * condition is to first reduce the spender's allowance to 0 and set the
144    * desired value afterwards:
145    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146    *
147    * Emits an {Approval} event.
148    */
149   function approve(address spender, uint256 amount) external returns (bool);
150 
151   /**
152    * @dev Moves `amount` tokens from `sender` to `recipient` using the
153    * allowance mechanism. `amount` is then deducted from the caller's
154    * allowance.
155    *
156    * Returns a boolean value indicating whether the operation succeeded.
157    *
158    * Emits a {Transfer} event.
159    */
160   function transferFrom(
161     address sender,
162     address recipient,
163     uint256 amount
164   ) external returns (bool);
165 
166   /**
167    * @dev Emitted when `value` tokens are moved from one account (`from`) to
168    * another (`to`).
169    *
170    * Note that `value` may be zero.
171    */
172   event Transfer(address indexed from, address indexed to, uint256 value);
173   /**
174    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
175    * a call to {approve}. `value` is the new allowance.
176    */
177   event Approval(address indexed owner, address indexed spender, uint256 value);
178 }
179 // File: @openzeppelin/contracts/math/SafeMath.sol
180 
181 pragma solidity >=0.6.0 <0.8.0;
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations with added overflow
185  * checks.
186  *
187  * Arithmetic operations in Solidity wrap on overflow. This can easily result
188  * in bugs, because programmers usually assume that an overflow raises an
189  * error, which is the standard behavior in high level programming languages.
190  * `SafeMath` restores this intuition by reverting the transaction when an
191  * operation overflows.
192  *
193  * Using this library instead of the unchecked operations eliminates an entire
194  * class of bugs, so it's recommended to use it always.
195  */
196 library SafeMath {
197   /**
198    * @dev Returns the addition of two unsigned integers, reverting on
199    * overflow.
200    *
201    * Counterpart to Solidity's `+` operator.
202    *
203    * Requirements:
204    *
205    * - Addition cannot overflow.
206    */
207   function add(uint256 a, uint256 b) internal pure returns (uint256) {
208     uint256 c = a + b;
209     require(c >= a, "SafeMath: addition overflow");
210     return c;
211   }
212 
213   /**
214    * @dev Returns the subtraction of two unsigned integers, reverting on
215    * overflow (when the result is negative).
216    *
217    * Counterpart to Solidity's `-` operator.
218    *
219    * Requirements:
220    *
221    * - Subtraction cannot overflow.
222    */
223   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224     return sub(a, b, "SafeMath: subtraction overflow");
225   }
226 
227   /**
228    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
229    * overflow (when the result is negative).
230    *
231    * Counterpart to Solidity's `-` operator.
232    *
233    * Requirements:
234    *
235    * - Subtraction cannot overflow.
236    */
237   function sub(
238     uint256 a,
239     uint256 b,
240     string memory errorMessage
241   ) internal pure returns (uint256) {
242     require(b <= a, errorMessage);
243     uint256 c = a - b;
244     return c;
245   }
246 
247   /**
248    * @dev Returns the multiplication of two unsigned integers, reverting on
249    * overflow.
250    *
251    * Counterpart to Solidity's `*` operator.
252    *
253    * Requirements:
254    *
255    * - Multiplication cannot overflow.
256    */
257   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
258     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
259     // benefit is lost if 'b' is also tested.
260     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
261     if (a == 0) {
262       return 0;
263     }
264     uint256 c = a * b;
265     require(c / a == b, "SafeMath: multiplication overflow");
266     return c;
267   }
268 
269   /**
270    * @dev Returns the integer division of two unsigned integers. Reverts on
271    * division by zero. The result is rounded towards zero.
272    *
273    * Counterpart to Solidity's `/` operator. Note: this function uses a
274    * `revert` opcode (which leaves remaining gas untouched) while Solidity
275    * uses an invalid opcode to revert (consuming all remaining gas).
276    *
277    * Requirements:
278    *
279    * - The divisor cannot be zero.
280    */
281   function div(uint256 a, uint256 b) internal pure returns (uint256) {
282     return div(a, b, "SafeMath: division by zero");
283   }
284 
285   /**
286    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
287    * division by zero. The result is rounded towards zero.
288    *
289    * Counterpart to Solidity's `/` operator. Note: this function uses a
290    * `revert` opcode (which leaves remaining gas untouched) while Solidity
291    * uses an invalid opcode to revert (consuming all remaining gas).
292    *
293    * Requirements:
294    *
295    * - The divisor cannot be zero.
296    */
297   function div(
298     uint256 a,
299     uint256 b,
300     string memory errorMessage
301   ) internal pure returns (uint256) {
302     require(b > 0, errorMessage);
303     uint256 c = a / b;
304     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
305     return c;
306   }
307 
308   /**
309    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310    * Reverts when dividing by zero.
311    *
312    * Counterpart to Solidity's `%` operator. This function uses a `revert`
313    * opcode (which leaves remaining gas untouched) while Solidity uses an
314    * invalid opcode to revert (consuming all remaining gas).
315    *
316    * Requirements:
317    *
318    * - The divisor cannot be zero.
319    */
320   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
321     return mod(a, b, "SafeMath: modulo by zero");
322   }
323 
324   /**
325    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326    * Reverts with custom message when dividing by zero.
327    *
328    * Counterpart to Solidity's `%` operator. This function uses a `revert`
329    * opcode (which leaves remaining gas untouched) while Solidity uses an
330    * invalid opcode to revert (consuming all remaining gas).
331    *
332    * Requirements:
333    *
334    * - The divisor cannot be zero.
335    */
336   function mod(
337     uint256 a,
338     uint256 b,
339     string memory errorMessage
340   ) internal pure returns (uint256) {
341     require(b != 0, errorMessage);
342     return a % b;
343   }
344 }
345 // File: @openzeppelin/contracts/utils/Address.sol
346 
347 pragma solidity >=0.6.2 <0.8.0;
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353   /**
354    * @dev Returns true if `account` is a contract.
355    *
356    * [IMPORTANT]
357    * ====
358    * It is unsafe to assume that an address for which this function returns
359    * false is an externally-owned account (EOA) and not a contract.
360    *
361    * Among others, `isContract` will return false for the following
362    * types of addresses:
363    *
364    *  - an externally-owned account
365    *  - a contract in construction
366    *  - an address where a contract will be created
367    *  - an address where a contract lived, but was destroyed
368    * ====
369    */
370   function isContract(address account) internal view returns (bool) {
371     // This method relies on extcodesize, which returns 0 for contracts in
372     // construction, since the code is only stored at the end of the
373     // constructor execution.
374     uint256 size;
375     // solhint-disable-next-line no-inline-assembly
376     assembly {
377       size := extcodesize(account)
378     }
379     return size > 0;
380   }
381 
382   /**
383    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
384    * `recipient`, forwarding all available gas and reverting on errors.
385    *
386    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
387    * of certain opcodes, possibly making contracts go over the 2300 gas limit
388    * imposed by `transfer`, making them unable to receive funds via
389    * `transfer`. {sendValue} removes this limitation.
390    *
391    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
392    *
393    * IMPORTANT: because control is transferred to `recipient`, care must be
394    * taken to not create reentrancy vulnerabilities. Consider using
395    * {ReentrancyGuard} or the
396    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
397    */
398   function sendValue(address payable recipient, uint256 amount) internal {
399     require(address(this).balance >= amount, "Address: insufficient balance");
400     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
401     (bool success, ) = recipient.call{value: amount}("");
402     require(
403       success,
404       "Address: unable to send value, recipient may have reverted"
405     );
406   }
407 
408   /**
409    * @dev Performs a Solidity function call using a low level `call`. A
410    * plain`call` is an unsafe replacement for a function call: use this
411    * function instead.
412    *
413    * If `target` reverts with a revert reason, it is bubbled up by this
414    * function (like regular Solidity function calls).
415    *
416    * Returns the raw returned data. To convert to the expected return value,
417    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
418    *
419    * Requirements:
420    *
421    * - `target` must be a contract.
422    * - calling `target` with `data` must not revert.
423    *
424    * _Available since v3.1._
425    */
426   function functionCall(address target, bytes memory data)
427     internal
428     returns (bytes memory)
429   {
430     return functionCall(target, data, "Address: low-level call failed");
431   }
432 
433   /**
434    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
435    * `errorMessage` as a fallback revert reason when `target` reverts.
436    *
437    * _Available since v3.1._
438    */
439   function functionCall(
440     address target,
441     bytes memory data,
442     string memory errorMessage
443   ) internal returns (bytes memory) {
444     return functionCallWithValue(target, data, 0, errorMessage);
445   }
446 
447   /**
448    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449    * but also transferring `value` wei to `target`.
450    *
451    * Requirements:
452    *
453    * - the calling contract must have an ETH balance of at least `value`.
454    * - the called Solidity function must be `payable`.
455    *
456    * _Available since v3.1._
457    */
458   function functionCallWithValue(
459     address target,
460     bytes memory data,
461     uint256 value
462   ) internal returns (bytes memory) {
463     return
464       functionCallWithValue(
465         target,
466         data,
467         value,
468         "Address: low-level call with value failed"
469       );
470   }
471 
472   /**
473    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
474    * with `errorMessage` as a fallback revert reason when `target` reverts.
475    *
476    * _Available since v3.1._
477    */
478   function functionCallWithValue(
479     address target,
480     bytes memory data,
481     uint256 value,
482     string memory errorMessage
483   ) internal returns (bytes memory) {
484     require(
485       address(this).balance >= value,
486       "Address: insufficient balance for call"
487     );
488     require(isContract(target), "Address: call to non-contract");
489     // solhint-disable-next-line avoid-low-level-calls
490     (bool success, bytes memory returndata) = target.call{value: value}(data);
491     return _verifyCallResult(success, returndata, errorMessage);
492   }
493 
494   /**
495    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
496    * but performing a static call.
497    *
498    * _Available since v3.3._
499    */
500   function functionStaticCall(address target, bytes memory data)
501     internal
502     view
503     returns (bytes memory)
504   {
505     return
506       functionStaticCall(target, data, "Address: low-level static call failed");
507   }
508 
509   /**
510    * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511    * but performing a static call.
512    *
513    * _Available since v3.3._
514    */
515   function functionStaticCall(
516     address target,
517     bytes memory data,
518     string memory errorMessage
519   ) internal view returns (bytes memory) {
520     require(isContract(target), "Address: static call to non-contract");
521     // solhint-disable-next-line avoid-low-level-calls
522     (bool success, bytes memory returndata) = target.staticcall(data);
523     return _verifyCallResult(success, returndata, errorMessage);
524   }
525 
526   function _verifyCallResult(
527     bool success,
528     bytes memory returndata,
529     string memory errorMessage
530   ) private pure returns (bytes memory) {
531     if (success) {
532       return returndata;
533     } else {
534       // Look for revert reason and bubble it up if present
535       if (returndata.length > 0) {
536         // The easiest way to bubble the revert reason is using memory via assembly
537         // solhint-disable-next-line no-inline-assembly
538         assembly {
539           let returndata_size := mload(returndata)
540           revert(add(32, returndata), returndata_size)
541         }
542       } else {
543         revert(errorMessage);
544       }
545     }
546   }
547 }
548 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
549 
550 pragma solidity >=0.6.0 <0.8.0;
551 
552 /**
553  * @title SafeERC20
554  * @dev Wrappers around ERC20 operations that throw on failure (when the token
555  * contract returns false). Tokens that return no value (and instead revert or
556  * throw on failure) are also supported, non-reverting calls are assumed to be
557  * successful.
558  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
559  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
560  */
561 library SafeERC20 {
562   using SafeMath for uint256;
563   using Address for address;
564 
565   function safeTransfer(
566     IERC20 token,
567     address to,
568     uint256 value
569   ) internal {
570     _callOptionalReturn(
571       token,
572       abi.encodeWithSelector(token.transfer.selector, to, value)
573     );
574   }
575 
576   function safeTransferFrom(
577     IERC20 token,
578     address from,
579     address to,
580     uint256 value
581   ) internal {
582     _callOptionalReturn(
583       token,
584       abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
585     );
586   }
587 
588   /**
589    * @dev Deprecated. This function has issues similar to the ones found in
590    * {IERC20-approve}, and its usage is discouraged.
591    *
592    * Whenever possible, use {safeIncreaseAllowance} and
593    * {safeDecreaseAllowance} instead.
594    */
595   function safeApprove(
596     IERC20 token,
597     address spender,
598     uint256 value
599   ) internal {
600     // safeApprove should only be called when setting an initial allowance,
601     // or when resetting it to zero. To increase and decrease it, use
602     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
603     // solhint-disable-next-line max-line-length
604     require(
605       (value == 0) || (token.allowance(address(this), spender) == 0),
606       "SafeERC20: approve from non-zero to non-zero allowance"
607     );
608     _callOptionalReturn(
609       token,
610       abi.encodeWithSelector(token.approve.selector, spender, value)
611     );
612   }
613 
614   function safeIncreaseAllowance(
615     IERC20 token,
616     address spender,
617     uint256 value
618   ) internal {
619     uint256 newAllowance = token.allowance(address(this), spender).add(value);
620     _callOptionalReturn(
621       token,
622       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
623     );
624   }
625 
626   function safeDecreaseAllowance(
627     IERC20 token,
628     address spender,
629     uint256 value
630   ) internal {
631     uint256 newAllowance =
632       token.allowance(address(this), spender).sub(
633         value,
634         "SafeERC20: decreased allowance below zero"
635       );
636     _callOptionalReturn(
637       token,
638       abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
639     );
640   }
641 
642   /**
643    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
644    * on the return value: the return value is optional (but if data is returned, it must not be false).
645    * @param token The token targeted by the call.
646    * @param data The call data (encoded using abi.encode or one of its variants).
647    */
648   function _callOptionalReturn(IERC20 token, bytes memory data) private {
649     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
650     // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
651     // the target address contains contract code and also asserts for success in the low-level call.
652     bytes memory returndata =
653       address(token).functionCall(data, "SafeERC20: low-level call failed");
654     if (returndata.length > 0) {
655       // Return data is optional
656       // solhint-disable-next-line max-line-length
657       require(
658         abi.decode(returndata, (bool)),
659         "SafeERC20: ERC20 operation did not succeed"
660       );
661     }
662   }
663 }
664 
665 // File: contracts/Locker.sol
666 /*
667   Copyright 2020 Swap Holdings Ltd.
668   Licensed under the Apache License, Version 2.0 (the "License");
669   you may not use this file except in compliance with the License.
670   You may obtain a copy of the License at
671     http://www.apache.org/licenses/LICENSE-2.0
672   Unless required by applicable law or agreed to in writing, software
673   distributed under the License is distributed on an "AS IS" BASIS,
674   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
675   See the License for the specific language governing permissions and
676   limitations under the License.
677 */
678 /**
679  * @title Locker: Lock and Unlock Token Balances
680  */
681 contract Locker is Ownable {
682   using SafeERC20 for IERC20;
683   using SafeMath for uint256;
684   uint256 internal constant MAX_PERCENTAGE = 100;
685   // Token to be locked (ERC-20)
686   IERC20 public immutable token;
687   // Locked token balances per account
688   mapping(address => uint256) internal balances;
689   // Previous withdrawals per epoch
690   mapping(address => mapping(uint256 => uint256)) public withdrawals;
691   // Total amount locked
692   uint256 public totalSupply;
693   // ERC-20 token properties
694   string public name;
695   string public symbol;
696   uint8 public decimals;
697   // Maximum unlockable percentage per epoch
698   uint256 public throttlingPercentage;
699   // Duration of each epoch in seconds
700   uint256 public throttlingDuration;
701   // Balance above which maximum percentage kicks in
702   uint256 public throttlingBalance;
703   /**
704    * @notice Events
705    */
706   event Lock(address participant, uint256 amount);
707   event Unlock(address participant, uint256 amount);
708   event SetThrottlingPercentage(uint256 throttlingPercentage);
709   event SetThrottlingDuration(uint256 throttlingDuration);
710   event SetThrottlingBalance(uint256 throttlingBalance);
711 
712   /**
713    * @notice Constructor
714    * @param _token address
715    * @param _name string
716    * @param _symbol string
717    * @param _decimals uint8
718    * @param _throttlingPercentage uint256
719    * @param _throttlingDuration uint256
720    * @param _throttlingBalance uint256
721    */
722   constructor(
723     address _token,
724     string memory _name,
725     string memory _symbol,
726     uint8 _decimals,
727     uint256 _throttlingPercentage,
728     uint256 _throttlingDuration,
729     uint256 _throttlingBalance
730   ) public {
731     require(_throttlingPercentage <= MAX_PERCENTAGE, "PERCENTAGE_TOO_HIGH");
732     token = IERC20(_token);
733     name = _name;
734     symbol = _symbol;
735     decimals = _decimals;
736     throttlingPercentage = _throttlingPercentage;
737     throttlingDuration = _throttlingDuration;
738     throttlingBalance = _throttlingBalance;
739   }
740 
741   /**
742    * @notice Lock tokens for msg.sender
743    * @param amount of tokens to lock
744    */
745   function lock(uint256 amount) external {
746     _lock(msg.sender, msg.sender, amount);
747   }
748 
749   /**
750    * @notice Lock tokens on behalf of another account
751    * @param account to lock tokens for
752    * @param amount of tokens to lock
753    */
754   function lockFor(address account, uint256 amount) external {
755     _lock(msg.sender, account, amount);
756   }
757 
758   /**
759    * @notice Unlock and transfer to msg.sender
760    * @param amount of tokens to unlock
761    */
762   function unlock(uint256 amount) external {
763     uint256 previous = withdrawals[msg.sender][epoch()];
764     // Only enforce percentage above a certain balance
765     if (balances[msg.sender] > throttlingBalance) {
766       require(
767         (previous.add(amount)) <=
768           throttlingPercentage.mul(balances[msg.sender].add(previous)).div(
769             MAX_PERCENTAGE
770           ),
771         "AMOUNT_EXCEEDS_LIMIT"
772       );
773     }
774     balances[msg.sender] = balances[msg.sender].sub(amount);
775     totalSupply = totalSupply.sub(amount);
776     withdrawals[msg.sender][epoch()] = previous.add(amount);
777     token.safeTransfer(msg.sender, amount);
778     emit Unlock(msg.sender, amount);
779   }
780 
781   /**
782    * @notice Set throttling percentage
783    * @dev Only owner
784    */
785   function setThrottlingPercentage(uint256 _throttlingPercentage)
786     external
787     onlyOwner
788   {
789     require(_throttlingPercentage <= MAX_PERCENTAGE, "PERCENTAGE_TOO_HIGH");
790     throttlingPercentage = _throttlingPercentage;
791     emit SetThrottlingPercentage(throttlingPercentage);
792   }
793 
794   /**
795    * @notice Set throttling duration
796    * @dev Only owner
797    */
798   function setThrottlingDuration(uint256 _throttlingDuration)
799     external
800     onlyOwner
801   {
802     throttlingDuration = _throttlingDuration;
803     emit SetThrottlingDuration(throttlingDuration);
804   }
805 
806   /**
807    * @notice Set throttling balance
808    * @dev Only owner
809    */
810   function setThrottlingBalance(uint256 _throttlingBalance) external onlyOwner {
811     throttlingBalance = _throttlingBalance;
812     emit SetThrottlingBalance(throttlingBalance);
813   }
814 
815   /**
816    * @notice Return current epoch
817    */
818   function epoch() public view returns (uint256) {
819     return block.timestamp.sub(block.timestamp.mod(throttlingDuration));
820   }
821 
822   /**
823    * @notice See {IERC20-balanceOf}
824    */
825   function balanceOf(address account) external view returns (uint256) {
826     return balances[account];
827   }
828 
829   /**
830    * @notice Perform a locking token transfer
831    * @param from address
832    * @param account address
833    * @param amount uint256
834    */
835   function _lock(
836     address from,
837     address account,
838     uint256 amount
839   ) private {
840     require(
841       balances[account].add(amount) <= (type(uint256).max).div(MAX_PERCENTAGE),
842       "OVERFLOW_PROTECTION"
843     );
844     require(token.balanceOf(from) >= amount, "BALANCE_INSUFFICIENT");
845     balances[account] = balances[account].add(amount);
846     totalSupply = totalSupply.add(amount);
847     token.safeTransferFrom(from, address(this), amount);
848     emit Lock(account, amount);
849   }
850 }
851 
852 // File: contracts/Imports.sol
853 contract Imports {
854 
855 }
