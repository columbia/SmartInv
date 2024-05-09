1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Address.sol
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Collection of functions related to the address type
103  */
104 library Address {
105     /**
106      * @dev Returns true if `account` is a contract.
107      *
108      * [IMPORTANT]
109      * ====
110      * It is unsafe to assume that an address for which this function returns
111      * false is an externally-owned account (EOA) and not a contract.
112      *
113      * Among others, `isContract` will return false for the following
114      * types of addresses:
115      *
116      *  - an externally-owned account
117      *  - a contract in construction
118      *  - an address where a contract will be created
119      *  - an address where a contract lived, but was destroyed
120      * ====
121      */
122     function isContract(address account) internal view returns (bool) {
123         // This method relies on extcodesize, which returns 0 for contracts in
124         // construction, since the code is only stored at the end of the
125         // constructor execution.
126 
127         uint256 size;
128         // solhint-disable-next-line no-inline-assembly
129         assembly { size := extcodesize(account) }
130         return size > 0;
131     }
132 
133     /**
134      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
135      * `recipient`, forwarding all available gas and reverting on errors.
136      *
137      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
138      * of certain opcodes, possibly making contracts go over the 2300 gas limit
139      * imposed by `transfer`, making them unable to receive funds via
140      * `transfer`. {sendValue} removes this limitation.
141      *
142      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
143      *
144      * IMPORTANT: because control is transferred to `recipient`, care must be
145      * taken to not create reentrancy vulnerabilities. Consider using
146      * {ReentrancyGuard} or the
147      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
148      */
149     function sendValue(address payable recipient, uint256 amount) internal {
150         require(address(this).balance >= amount, "Address: insufficient balance");
151 
152         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
153         (bool success, ) = recipient.call{ value: amount }("");
154         require(success, "Address: unable to send value, recipient may have reverted");
155     }
156 
157     /**
158      * @dev Performs a Solidity function call using a low level `call`. A
159      * plain`call` is an unsafe replacement for a function call: use this
160      * function instead.
161      *
162      * If `target` reverts with a revert reason, it is bubbled up by this
163      * function (like regular Solidity function calls).
164      *
165      * Returns the raw returned data. To convert to the expected return value,
166      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
167      *
168      * Requirements:
169      *
170      * - `target` must be a contract.
171      * - calling `target` with `data` must not revert.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
176       return functionCall(target, data, "Address: low-level call failed");
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
181      * `errorMessage` as a fallback revert reason when `target` reverts.
182      *
183      * _Available since v3.1._
184      */
185     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, 0, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
191      * but also transferring `value` wei to `target`.
192      *
193      * Requirements:
194      *
195      * - the calling contract must have an ETH balance of at least `value`.
196      * - the called Solidity function must be `payable`.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
211         require(address(this).balance >= value, "Address: insufficient balance for call");
212         require(isContract(target), "Address: call to non-contract");
213 
214         // solhint-disable-next-line avoid-low-level-calls
215         (bool success, bytes memory returndata) = target.call{ value: value }(data);
216         return _verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
226         return functionStaticCall(target, data, "Address: low-level static call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
236         require(isContract(target), "Address: static call to non-contract");
237 
238         // solhint-disable-next-line avoid-low-level-calls
239         (bool success, bytes memory returndata) = target.staticcall(data);
240         return _verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a delegate call.
246      *
247      * _Available since v3.4._
248      */
249     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
250         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a delegate call.
256      *
257      * _Available since v3.4._
258      */
259     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
260         require(isContract(target), "Address: delegate call to non-contract");
261 
262         // solhint-disable-next-line avoid-low-level-calls
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return _verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
268         if (success) {
269             return returndata;
270         } else {
271             // Look for revert reason and bubble it up if present
272             if (returndata.length > 0) {
273                 // The easiest way to bubble the revert reason is using memory via assembly
274 
275                 // solhint-disable-next-line no-inline-assembly
276                 assembly {
277                     let returndata_size := mload(returndata)
278                     revert(add(32, returndata), returndata_size)
279                 }
280             } else {
281                 revert(errorMessage);
282             }
283         }
284     }
285 }
286 
287 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
288 
289 
290 pragma solidity ^0.8.0;
291 
292 /**
293  * @dev Interface of the ERC20 standard as defined in the EIP.
294  */
295 interface IERC20 {
296     /**
297      * @dev Returns the amount of tokens in existence.
298      */
299     function totalSupply() external view returns (uint256);
300 
301     /**
302      * @dev Returns the amount of tokens owned by `account`.
303      */
304     function balanceOf(address account) external view returns (uint256);
305 
306     /**
307      * @dev Moves `amount` tokens from the caller's account to `recipient`.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * Emits a {Transfer} event.
312      */
313     function transfer(address recipient, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Returns the remaining number of tokens that `spender` will be
317      * allowed to spend on behalf of `owner` through {transferFrom}. This is
318      * zero by default.
319      *
320      * This value changes when {approve} or {transferFrom} are called.
321      */
322     function allowance(address owner, address spender) external view returns (uint256);
323 
324     /**
325      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * IMPORTANT: Beware that changing an allowance with this method brings the risk
330      * that someone may use both the old and the new allowance by unfortunate
331      * transaction ordering. One possible solution to mitigate this race
332      * condition is to first reduce the spender's allowance to 0 and set the
333      * desired value afterwards:
334      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
335      *
336      * Emits an {Approval} event.
337      */
338     function approve(address spender, uint256 amount) external returns (bool);
339 
340     /**
341      * @dev Moves `amount` tokens from `sender` to `recipient` using the
342      * allowance mechanism. `amount` is then deducted from the caller's
343      * allowance.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * Emits a {Transfer} event.
348      */
349     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
350 
351     /**
352      * @dev Emitted when `value` tokens are moved from one account (`from`) to
353      * another (`to`).
354      *
355      * Note that `value` may be zero.
356      */
357     event Transfer(address indexed from, address indexed to, uint256 value);
358 
359     /**
360      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
361      * a call to {approve}. `value` is the new allowance.
362      */
363     event Approval(address indexed owner, address indexed spender, uint256 value);
364 }
365 
366 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
367 
368 pragma solidity ^0.8.0;
369 
370 
371 
372 /**
373  * @title SafeERC20
374  * @dev Wrappers around ERC20 operations that throw on failure (when the token
375  * contract returns false). Tokens that return no value (and instead revert or
376  * throw on failure) are also supported, non-reverting calls are assumed to be
377  * successful.
378  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
379  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
380  */
381 library SafeERC20 {
382     using Address for address;
383 
384     function safeTransfer(IERC20 token, address to, uint256 value) internal {
385         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
386     }
387 
388     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
389         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
390     }
391 
392     /**
393      * @dev Deprecated. This function has issues similar to the ones found in
394      * {IERC20-approve}, and its usage is discouraged.
395      *
396      * Whenever possible, use {safeIncreaseAllowance} and
397      * {safeDecreaseAllowance} instead.
398      */
399     function safeApprove(IERC20 token, address spender, uint256 value) internal {
400         // safeApprove should only be called when setting an initial allowance,
401         // or when resetting it to zero. To increase and decrease it, use
402         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
403         // solhint-disable-next-line max-line-length
404         require((value == 0) || (token.allowance(address(this), spender) == 0),
405             "SafeERC20: approve from non-zero to non-zero allowance"
406         );
407         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
408     }
409 
410     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
411         uint256 newAllowance = token.allowance(address(this), spender) + value;
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
413     }
414 
415     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         unchecked {
417             uint256 oldAllowance = token.allowance(address(this), spender);
418             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
419             uint256 newAllowance = oldAllowance - value;
420             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
421         }
422     }
423 
424     /**
425      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
426      * on the return value: the return value is optional (but if data is returned, it must not be false).
427      * @param token The token targeted by the call.
428      * @param data The call data (encoded using abi.encode or one of its variants).
429      */
430     function _callOptionalReturn(IERC20 token, bytes memory data) private {
431         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
432         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
433         // the target address contains contract code and also asserts for success in the low-level call.
434 
435         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
436         if (returndata.length > 0) { // Return data is optional
437             // solhint-disable-next-line max-line-length
438             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
439         }
440     }
441 }
442 
443 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
444 
445 
446 pragma solidity ^0.8.0;
447 
448 // CAUTION
449 // This version of SafeMath should only be used with Solidity 0.8 or later,
450 // because it relies on the compiler's built in overflow checks.
451 
452 /**
453  * @dev Wrappers over Solidity's arithmetic operations.
454  *
455  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
456  * now has built in overflow checking.
457  */
458 library SafeMath {
459     /**
460      * @dev Returns the addition of two unsigned integers, with an overflow flag.
461      *
462      * _Available since v3.4._
463      */
464     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
465         unchecked {
466             uint256 c = a + b;
467             if (c < a) return (false, 0);
468             return (true, c);
469         }
470     }
471 
472     /**
473      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
474      *
475      * _Available since v3.4._
476      */
477     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
478         unchecked {
479             if (b > a) return (false, 0);
480             return (true, a - b);
481         }
482     }
483 
484     /**
485      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
486      *
487      * _Available since v3.4._
488      */
489     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
490         unchecked {
491             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
492             // benefit is lost if 'b' is also tested.
493             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
494             if (a == 0) return (true, 0);
495             uint256 c = a * b;
496             if (c / a != b) return (false, 0);
497             return (true, c);
498         }
499     }
500 
501     /**
502      * @dev Returns the division of two unsigned integers, with a division by zero flag.
503      *
504      * _Available since v3.4._
505      */
506     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
507         unchecked {
508             if (b == 0) return (false, 0);
509             return (true, a / b);
510         }
511     }
512 
513     /**
514      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
515      *
516      * _Available since v3.4._
517      */
518     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
519         unchecked {
520             if (b == 0) return (false, 0);
521             return (true, a % b);
522         }
523     }
524 
525     /**
526      * @dev Returns the addition of two unsigned integers, reverting on
527      * overflow.
528      *
529      * Counterpart to Solidity's `+` operator.
530      *
531      * Requirements:
532      *
533      * - Addition cannot overflow.
534      */
535     function add(uint256 a, uint256 b) internal pure returns (uint256) {
536         return a + b;
537     }
538 
539     /**
540      * @dev Returns the subtraction of two unsigned integers, reverting on
541      * overflow (when the result is negative).
542      *
543      * Counterpart to Solidity's `-` operator.
544      *
545      * Requirements:
546      *
547      * - Subtraction cannot overflow.
548      */
549     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
550         return a - b;
551     }
552 
553     /**
554      * @dev Returns the multiplication of two unsigned integers, reverting on
555      * overflow.
556      *
557      * Counterpart to Solidity's `*` operator.
558      *
559      * Requirements:
560      *
561      * - Multiplication cannot overflow.
562      */
563     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
564         return a * b;
565     }
566 
567     /**
568      * @dev Returns the integer division of two unsigned integers, reverting on
569      * division by zero. The result is rounded towards zero.
570      *
571      * Counterpart to Solidity's `/` operator.
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function div(uint256 a, uint256 b) internal pure returns (uint256) {
578         return a / b;
579     }
580 
581     /**
582      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
583      * reverting when dividing by zero.
584      *
585      * Counterpart to Solidity's `%` operator. This function uses a `revert`
586      * opcode (which leaves remaining gas untouched) while Solidity uses an
587      * invalid opcode to revert (consuming all remaining gas).
588      *
589      * Requirements:
590      *
591      * - The divisor cannot be zero.
592      */
593     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
594         return a % b;
595     }
596 
597     /**
598      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
599      * overflow (when the result is negative).
600      *
601      * CAUTION: This function is deprecated because it requires allocating memory for the error
602      * message unnecessarily. For custom revert reasons use {trySub}.
603      *
604      * Counterpart to Solidity's `-` operator.
605      *
606      * Requirements:
607      *
608      * - Subtraction cannot overflow.
609      */
610     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
611         unchecked {
612             require(b <= a, errorMessage);
613             return a - b;
614         }
615     }
616 
617     /**
618      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
619      * division by zero. The result is rounded towards zero.
620      *
621      * Counterpart to Solidity's `%` operator. This function uses a `revert`
622      * opcode (which leaves remaining gas untouched) while Solidity uses an
623      * invalid opcode to revert (consuming all remaining gas).
624      *
625      * Counterpart to Solidity's `/` operator. Note: this function uses a
626      * `revert` opcode (which leaves remaining gas untouched) while Solidity
627      * uses an invalid opcode to revert (consuming all remaining gas).
628      *
629      * Requirements:
630      *
631      * - The divisor cannot be zero.
632      */
633     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
634         unchecked {
635             require(b > 0, errorMessage);
636             return a / b;
637         }
638     }
639 
640     /**
641      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
642      * reverting with custom message when dividing by zero.
643      *
644      * CAUTION: This function is deprecated because it requires allocating memory for the error
645      * message unnecessarily. For custom revert reasons use {tryMod}.
646      *
647      * Counterpart to Solidity's `%` operator. This function uses a `revert`
648      * opcode (which leaves remaining gas untouched) while Solidity uses an
649      * invalid opcode to revert (consuming all remaining gas).
650      *
651      * Requirements:
652      *
653      * - The divisor cannot be zero.
654      */
655     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
656         unchecked {
657             require(b > 0, errorMessage);
658             return a % b;
659         }
660     }
661 }
662 
663 // File: AerariumMilitare.sol
664 
665 
666 pragma solidity ^0.8.0;
667 
668 
669 
670 
671 contract AerariumMilitare is Ownable {
672   using SafeMath for uint256;
673   using SafeERC20 for IERC20;
674 
675   // The start time of the ERC20 token distribution
676   uint256 public immutable startTime;
677   // The end time for the ERC20 token distribution
678   uint256 public immutable endTime;
679   // The lock period for the ERC20 token
680   uint256 public immutable lockTime;
681   // The ERC20 token address passed in the constructor
682   IERC20 public immutable token;
683   // The total amount of tokens to be distributed
684   uint256 public totalTokenAmount;
685   // A mapping of each investor address to a specific amount
686   mapping(address => uint256) public userTotalAmount;
687   // A mapping of each investor address to the amount of JRT already claimed
688   mapping(address => uint256) public claimedAmount;
689 
690   /** @dev Constructor when deploying the smart contract
691    * @param _token - The address of the ERC20 token
692    * @param _startTime - Setting the start time of the distribution
693    * @param _endTime - Setting the end time of the distribution
694    */
695   constructor(
696     IERC20 _token,
697     uint256 _startTime,
698     uint256 _endTime
699   ) {
700     require(_endTime > _startTime, 'End time must be after start time');
701     require(
702       _startTime > block.timestamp,
703       'Start time must be after actual time'
704     );
705     token = _token;
706     startTime = _startTime;
707     endTime = _endTime;
708     lockTime = _endTime - _startTime;
709   }
710 
711   /** @dev - A function which can be called only by owner and stores the investor addresses and corresponding tokens to be distributed
712    * @param addresses - An array of all the investors addresses
713    * @param amounts - An array of the amounts to be distributed per investor
714    */
715   function addInvestors(
716     address[] calldata addresses,
717     uint256[] calldata amounts
718   ) public onlyOwner {
719     require(
720       block.timestamp < startTime,
721       'Current time should be before the start of the distribution'
722     );
723     require(
724       addresses.length == amounts.length,
725       'Number of addresses and amounts does not match'
726     );
727     uint256 totalActualAmount = 0;
728     for (uint256 i = 0; i < addresses.length; i++) {
729       require(
730         addresses[i] != address(0),
731         'Provided address can not be the 0 address'
732       );
733       require(userTotalAmount[addresses[i]] == 0, 'Investor already inserted');
734       uint256 userAmount = amounts[i];
735       userTotalAmount[addresses[i]] = userAmount;
736       totalActualAmount = totalActualAmount.add(userAmount);
737     }
738     uint256 newTotalAmount = totalTokenAmount.add(totalActualAmount);
739     totalTokenAmount = newTotalAmount;
740     require(
741       token.balanceOf(address(this)) >= newTotalAmount,
742       'The balance of the contract is not enough'
743     );
744   }
745 
746   /** @dev - A function to be called by the frontend to check the current claimable ERC20 token
747    * @param investor - Address of investor about which check the claimable tokens
748    * @return Claimable tokens
749    */
750   function claimableJRT(address investor) external view returns (uint256) {
751     uint256 totalAmount = userTotalAmount[investor];
752     uint256 timePassed =
753       block.timestamp <= endTime
754         ? block.timestamp.sub(startTime)
755         : endTime.sub(startTime);
756     return
757       timePassed.mul(totalAmount).div(lockTime).sub(claimedAmount[investor]);
758   }
759 
760   /** @dev - The function which is called when an investor wants to claim unlocked ERC20 tokens with linear proportionality
761    */
762   function claim() external {
763     require(block.timestamp < endTime, 'The end time has passed');
764     uint256 totalAmount = userTotalAmount[msg.sender];
765     uint256 timePassed = block.timestamp.sub(startTime);
766     uint256 amount =
767       timePassed.mul(totalAmount).div(lockTime).sub(claimedAmount[msg.sender]);
768     claimedAmount[msg.sender] = claimedAmount[msg.sender].add(amount);
769     token.safeTransfer(msg.sender, amount);
770   }
771 
772   /** @dev - A function which calls internal _liquidate function to transfer any tokens left on the contract to investors after the endTime has passed
773    * @param investors - Array of investors addresses to liquidate
774    */
775   function liquidate(address[] calldata investors) external {
776     require(block.timestamp >= endTime, 'The end time has not passed');
777     for (uint256 i = 0; i < investors.length; i++) {
778       address investor = investors[i];
779       uint256 availableTokens = userTotalAmount[investor];
780       uint256 claimedTokens = claimedAmount[investor];
781       require(
782         availableTokens != 0 && availableTokens != claimedTokens,
783         'no tokens to be distributed for an investor'
784       );
785       _liquidate(investor, availableTokens, claimedTokens);
786     }
787   }
788 
789   /** @dev - Internal function which performs the transfer of tokens from the smart contract to the investor after endTime
790    * updates claimedAmount to be equal to the totalAmount the investor should receive
791    */
792   function _liquidate(
793     address investor,
794     uint256 availableTokens,
795     uint256 claimedTokens
796   ) internal {
797     token.safeTransfer(investor, availableTokens.sub(claimedTokens));
798     claimedAmount[investor] = availableTokens;
799   }
800 }