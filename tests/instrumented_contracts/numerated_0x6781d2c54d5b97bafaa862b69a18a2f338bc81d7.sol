1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 // 
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
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 // 
94 /**
95  * @dev Standard math utilities missing in the Solidity language.
96  */
97 library Math {
98     /**
99      * @dev Returns the largest of two numbers.
100      */
101     function max(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a >= b ? a : b;
103     }
104 
105     /**
106      * @dev Returns the smallest of two numbers.
107      */
108     function min(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a < b ? a : b;
110     }
111 
112     /**
113      * @dev Returns the average of two numbers. The result is rounded towards
114      * zero.
115      */
116     function average(uint256 a, uint256 b) internal pure returns (uint256) {
117         // (a + b) / 2 can overflow, so we distribute
118         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
119     }
120 }
121 
122 // 
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP.
125  */
126 interface IERC20 {
127     /**
128      * @dev Returns the amount of tokens in existence.
129      */
130     function totalSupply() external view returns (uint256);
131 
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `recipient`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address recipient, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `sender` to `recipient` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Emitted when `value` tokens are moved from one account (`from`) to
184      * another (`to`).
185      *
186      * Note that `value` may be zero.
187      */
188     event Transfer(address indexed from, address indexed to, uint256 value);
189 
190     /**
191      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
192      * a call to {approve}. `value` is the new allowance.
193      */
194     event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 // 
198 /**
199  * @dev Wrappers over Solidity's arithmetic operations with added overflow
200  * checks.
201  *
202  * Arithmetic operations in Solidity wrap on overflow. This can easily result
203  * in bugs, because programmers usually assume that an overflow raises an
204  * error, which is the standard behavior in high level programming languages.
205  * `SafeMath` restores this intuition by reverting the transaction when an
206  * operation overflows.
207  *
208  * Using this library instead of the unchecked operations eliminates an entire
209  * class of bugs, so it's recommended to use it always.
210  */
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `+` operator.
217      *
218      * Requirements:
219      *
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         return sub(a, b, "SafeMath: subtraction overflow");
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
245      * overflow (when the result is negative).
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         uint256 c = a - b;
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `*` operator.
265      *
266      * Requirements:
267      *
268      * - Multiplication cannot overflow.
269      */
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
272         // benefit is lost if 'b' is also tested.
273         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
274         if (a == 0) {
275             return 0;
276         }
277 
278         uint256 c = a * b;
279         require(c / a == b, "SafeMath: multiplication overflow");
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers. Reverts on
286      * division by zero. The result is rounded towards zero.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         return div(a, b, "SafeMath: division by zero");
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
302      * division by zero. The result is rounded towards zero.
303      *
304      * Counterpart to Solidity's `/` operator. Note: this function uses a
305      * `revert` opcode (which leaves remaining gas untouched) while Solidity
306      * uses an invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b > 0, errorMessage);
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316 
317         return c;
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
322      * Reverts when dividing by zero.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         return mod(a, b, "SafeMath: modulo by zero");
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * Reverts with custom message when dividing by zero.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      *
346      * - The divisor cannot be zero.
347      */
348     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         require(b != 0, errorMessage);
350         return a % b;
351     }
352 }
353 
354 // 
355 /**
356  * @dev Collection of functions related to the address type
357  */
358 library Address {
359     /**
360      * @dev Returns true if `account` is a contract.
361      *
362      * [IMPORTANT]
363      * ====
364      * It is unsafe to assume that an address for which this function returns
365      * false is an externally-owned account (EOA) and not a contract.
366      *
367      * Among others, `isContract` will return false for the following
368      * types of addresses:
369      *
370      *  - an externally-owned account
371      *  - a contract in construction
372      *  - an address where a contract will be created
373      *  - an address where a contract lived, but was destroyed
374      * ====
375      */
376     function isContract(address account) internal view returns (bool) {
377         // This method relies in extcodesize, which returns 0 for contracts in
378         // construction, since the code is only stored at the end of the
379         // constructor execution.
380 
381         uint256 size;
382         // solhint-disable-next-line no-inline-assembly
383         assembly { size := extcodesize(account) }
384         return size > 0;
385     }
386 
387     /**
388      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
389      * `recipient`, forwarding all available gas and reverting on errors.
390      *
391      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
392      * of certain opcodes, possibly making contracts go over the 2300 gas limit
393      * imposed by `transfer`, making them unable to receive funds via
394      * `transfer`. {sendValue} removes this limitation.
395      *
396      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
397      *
398      * IMPORTANT: because control is transferred to `recipient`, care must be
399      * taken to not create reentrancy vulnerabilities. Consider using
400      * {ReentrancyGuard} or the
401      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
402      */
403     function sendValue(address payable recipient, uint256 amount) internal {
404         require(address(this).balance >= amount, "Address: insufficient balance");
405 
406         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
407         (bool success, ) = recipient.call{ value: amount }("");
408         require(success, "Address: unable to send value, recipient may have reverted");
409     }
410 
411     /**
412      * @dev Performs a Solidity function call using a low level `call`. A
413      * plain`call` is an unsafe replacement for a function call: use this
414      * function instead.
415      *
416      * If `target` reverts with a revert reason, it is bubbled up by this
417      * function (like regular Solidity function calls).
418      *
419      * Returns the raw returned data. To convert to the expected return value,
420      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
421      *
422      * Requirements:
423      *
424      * - `target` must be a contract.
425      * - calling `target` with `data` must not revert.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
430       return functionCall(target, data, "Address: low-level call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
435      * `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
440         return _functionCallWithValue(target, data, 0, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but also transferring `value` wei to `target`.
446      *
447      * Requirements:
448      *
449      * - the calling contract must have an ETH balance of at least `value`.
450      * - the called Solidity function must be `payable`.
451      *
452      * _Available since v3.1._
453      */
454     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
455         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
460      * with `errorMessage` as a fallback revert reason when `target` reverts.
461      *
462      * _Available since v3.1._
463      */
464     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
465         require(address(this).balance >= value, "Address: insufficient balance for call");
466         return _functionCallWithValue(target, data, value, errorMessage);
467     }
468 
469     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
470         require(isContract(target), "Address: call to non-contract");
471 
472         // solhint-disable-next-line avoid-low-level-calls
473         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
474         if (success) {
475             return returndata;
476         } else {
477             // Look for revert reason and bubble it up if present
478             if (returndata.length > 0) {
479                 // The easiest way to bubble the revert reason is using memory via assembly
480 
481                 // solhint-disable-next-line no-inline-assembly
482                 assembly {
483                     let returndata_size := mload(returndata)
484                     revert(add(32, returndata), returndata_size)
485                 }
486             } else {
487                 revert(errorMessage);
488             }
489         }
490     }
491 }
492 
493 // 
494 /**
495  * @title SafeERC20
496  * @dev Wrappers around ERC20 operations that throw on failure (when the token
497  * contract returns false). Tokens that return no value (and instead revert or
498  * throw on failure) are also supported, non-reverting calls are assumed to be
499  * successful.
500  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
501  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
502  */
503 library SafeERC20 {
504     using SafeMath for uint256;
505     using Address for address;
506 
507     function safeTransfer(IERC20 token, address to, uint256 value) internal {
508         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
509     }
510 
511     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
512         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
513     }
514 
515     /**
516      * @dev Deprecated. This function has issues similar to the ones found in
517      * {IERC20-approve}, and its usage is discouraged.
518      *
519      * Whenever possible, use {safeIncreaseAllowance} and
520      * {safeDecreaseAllowance} instead.
521      */
522     function safeApprove(IERC20 token, address spender, uint256 value) internal {
523         // safeApprove should only be called when setting an initial allowance,
524         // or when resetting it to zero. To increase and decrease it, use
525         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
526         // solhint-disable-next-line max-line-length
527         require((value == 0) || (token.allowance(address(this), spender) == 0),
528             "SafeERC20: approve from non-zero to non-zero allowance"
529         );
530         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
531     }
532 
533     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
534         uint256 newAllowance = token.allowance(address(this), spender).add(value);
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
536     }
537 
538     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     /**
544      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
545      * on the return value: the return value is optional (but if data is returned, it must not be false).
546      * @param token The token targeted by the call.
547      * @param data The call data (encoded using abi.encode or one of its variants).
548      */
549     function _callOptionalReturn(IERC20 token, bytes memory data) private {
550         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
551         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
552         // the target address contains contract code and also asserts for success in the low-level call.
553 
554         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
555         if (returndata.length > 0) { // Return data is optional
556             // solhint-disable-next-line max-line-length
557             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
558         }
559     }
560 }
561 
562 // 
563 // Using these will cause _mint to be not found in Pool
564 // Using these seems to work
565 //import "./interfaces/IERC20.sol";
566 //import "./libraries/SafeERC20.sol";
567 contract LPTokenWrapper {
568     using SafeMath for uint256;
569     using SafeERC20 for IERC20;
570 
571     IERC20 public stakingToken;
572     uint256 public startTime;
573     // Developer fund
574     uint256 public devFund;
575     uint256 public devCount;
576     mapping(uint256 => address) public devIDs;
577     mapping(address => uint256) public devAllocations;
578     // Staking balances
579     uint256 public _totalSupply;
580     mapping(address => uint256) public _balances;
581     uint256 public _totalSupplyAccounting;
582     mapping(address => uint256) public _balancesAccounting;
583 
584     constructor(uint256 _startTime) public {
585         startTime = _startTime;
586 
587         devCount = 8;
588         // Set dev fund allocation percentages
589         devIDs[0] = 0xAd1CC47416C2c8C9a1B91BFf41Ea627718e80074;
590         devAllocations[0xAd1CC47416C2c8C9a1B91BFf41Ea627718e80074] = 16;
591         devIDs[1] = 0x8EDac59Ea229a52380D181498C5901a764ad1c40;
592         devAllocations[0x8EDac59Ea229a52380D181498C5901a764ad1c40] = 16;
593         devIDs[2] = 0xeBc3992D9a2ef845224F057637da84927FDACf95;
594         devAllocations[0xeBc3992D9a2ef845224F057637da84927FDACf95] = 9;
595         devIDs[3] = 0x59Cc100B954f609c21dA917d6d4A1bD1e50dFE93;
596         devAllocations[0x59Cc100B954f609c21dA917d6d4A1bD1e50dFE93] = 8;
597         devIDs[4] = 0x416C75cFE45b951a411B23FC55904aeC383FFd6F;
598         devAllocations[0x416C75cFE45b951a411B23FC55904aeC383FFd6F] = 9;
599         devIDs[5] = 0xA103D9a54E0dE29886b077654e01D15F80Dad20c;
600         devAllocations[0xA103D9a54E0dE29886b077654e01D15F80Dad20c] = 16;
601         devIDs[6] = 0x73b6f43c9c86E7746a582EBBcB918Ab1Ad49bBD8;
602         devAllocations[0x73b6f43c9c86E7746a582EBBcB918Ab1Ad49bBD8] = 16;
603         devIDs[7] = 0x1A345cb683B3CB6F62F5A882022849eeAF47DFB3;
604         devAllocations[0x1A345cb683B3CB6F62F5A882022849eeAF47DFB3] = 10;
605     }
606 
607     // Returns the total staked tokens within the contract
608     function totalSupply() public view returns (uint256) {
609         return _totalSupply;
610     }
611 
612     // Returns staking balance of the account
613     function balanceOf(address account) public view returns (uint256) {
614         return _balances[account];
615     }
616 
617     // Set the staking token for the contract
618     function setStakingToken(address stakingTokenAddress) internal {
619         stakingToken = IERC20(stakingTokenAddress);
620     }
621 
622     // Stake funds into the pool
623     function stake(uint256 amount) public virtual {
624         // Calculate tax and after-tax amount
625         uint256 taxRate = calculateTax();
626         uint256 taxedAmount = amount.mul(taxRate).div(100);
627         uint256 stakedAmount = amount.sub(taxedAmount);
628 
629         // Increment sender's balances and total supply
630         _balances[msg.sender] = _balances[msg.sender].add(stakedAmount);
631         _totalSupply = _totalSupply.add(stakedAmount);
632         // Increment dev fund by tax
633         devFund = devFund.add(taxedAmount);
634 
635         // Transfer funds
636         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
637     }
638 
639     // Withdraw staked funds from the pool
640     function withdraw(uint256 amount) public virtual {
641         _totalSupply = _totalSupply.sub(amount);
642         _balances[msg.sender] = _balances[msg.sender].sub(amount);
643         stakingToken.safeTransfer(msg.sender, amount);
644     }
645 
646     // Distributes the dev fund to the developer addresses, callable by anyone
647     function distributeDevFund() public virtual {
648         // Reset dev fund to 0 before distributing any funds
649         uint256 totalDistributionAmount = devFund;
650         devFund = 0;
651         // Distribute dev fund according to percentages
652         for (uint256 i = 0; i < devCount; i++) {
653             uint256 devPercentage = devAllocations[devIDs[i]];
654             uint256 allocation = totalDistributionAmount.mul(devPercentage).div(
655                 100
656             );
657             if (allocation > 0) {
658                 stakingToken.safeTransfer(devIDs[i], allocation);
659             }
660         }
661     }
662 
663     // Return the tax amount according to current block time
664     function calculateTax() public view returns (uint256) {
665         // Pre-pool start time = 3% tax
666         if (block.timestamp < startTime) {
667             return 3;
668             // 0-60 minutes after pool start time = 5% tax
669         } else if (
670             block.timestamp.sub(startTime) >= 0 minutes &&
671             block.timestamp.sub(startTime) <= 60 minutes
672         ) {
673             return 5;
674             // 60-90 minutes after pool start time = 3% tax
675         } else if (
676             block.timestamp.sub(startTime) > 60 minutes &&
677             block.timestamp.sub(startTime) <= 90 minutes
678         ) {
679             return 3;
680             // 90+ minutes after pool start time = 1% tax
681         } else if (block.timestamp.sub(startTime) > 90 minutes) {
682             return 1;
683         }
684     }
685 }
686 
687 // 
688 /*
689  * Copyright (c) 2020 Synthetix
690  *
691  * Permission is hereby granted, free of charge, to any person obtaining a copy
692  * of this software and associated documentation files (the "Software"), to deal
693  * in the Software without restriction, including without limitation the rights
694  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
695  * copies of the Software, and to permit persons to whom the Software is
696  * furnished to do so, subject tog the following conditions:
697  *
698  * The above copyright notice and this permission notice shall be included in all
699  * copies or substantial portions of the Software.
700  *
701  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
702  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
703  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
704  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
705  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
706  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
707  */
708 /*
709     ______                                          __    __
710    / ________ __________ ___  ____ _____ ____  ____/ ____/ ____  ____
711   / /_  / __ `/ ___/ __ `__ \/ __ `/ __ `/ _ \/ __  / __  / __ \/ __ \
712  / __/ / /_/ / /  / / / / / / /_/ / /_/ /  __/ /_/ / /_/ / /_/ / / / /
713 /_/    \__,_/_/  /_/ /_/ /_/\__,_/\__, /\___/\__,_/\__,_/\____/_/ /_/
714                                  /____/
715 
716 *   FARMAFINANCE: MintablePool.sol
717 *   https://farma.finance
718 *   telegram: TBA
719 */
720 contract GrowEthFarma is LPTokenWrapper, Ownable {
721     using SafeERC20 for IERC20;
722     IERC20 public rewardToken;
723     IERC20 public multiplierToken;
724 
725     uint256 public DURATION;
726     uint256 public periodFinish;
727     uint256 public rewardRate;
728     uint256 public lastUpdateTime;
729     uint256 public rewardPerTokenStored;
730     uint256 public deployedTime;
731     uint256 public multiplierTokenDevFund;
732 
733     uint256 public constant boostLevelOneCost = 250000000000000000;
734     uint256 public constant boostLevelTwoCost = 500000000000000000;
735     uint256 public constant boostLevelThreeCost = 1 * 1e18;
736     uint256 public constant boostLevelFourCost = 2 * 1e18;
737 
738     uint256 public constant FivePercentBonus = 50000000000000000;
739     uint256 public constant TwentyPercentBonus = 200000000000000000;
740     uint256 public constant FourtyPercentBonus = 400000000000000000;
741     uint256 public constant HundredPercentBonus = 1000000000000000000;
742 
743     mapping(address => uint256) public userRewardPerTokenPaid;
744     mapping(address => uint256) public rewards;
745     mapping(address => uint256) public spentMultiplierTokens;
746     mapping(address => uint256) public boostLevel;
747 
748     event RewardAdded(uint256 reward);
749     event Staked(address indexed user, uint256 amount);
750     event Withdrawn(address indexed user, uint256 amount);
751     event RewardPaid(address indexed user, uint256 reward);
752     event Boost(uint256 level);
753 
754     constructor(
755         address _stakingToken,
756         address _rewardToken,
757         address _multiplierToken,
758         uint256 _startTime,
759         uint256 _duration
760     ) public LPTokenWrapper(_startTime) {
761         setStakingToken(_stakingToken);
762         rewardToken = IERC20(_rewardToken);
763         multiplierToken = IERC20(_multiplierToken);
764         deployedTime = block.timestamp;
765         DURATION = _duration;
766     }
767 
768     function setOwner(address _newOwner) external onlyOwner {
769         super.transferOwnership(_newOwner);
770     }
771 
772     function lastTimeRewardApplicable() public view returns (uint256) {
773         return Math.min(block.timestamp, periodFinish);
774     }
775 
776     // Returns the current rate of rewards per token (doh)
777     function rewardPerToken() public view returns (uint256) {
778         // Do not distribute rewards before games begin
779         if (block.timestamp < startTime) {
780             return 0;
781         }
782         if (_totalSupply == 0) {
783             return rewardPerTokenStored;
784         }
785         // Effective total supply takes into account all the multipliers bought.
786         uint256 effectiveTotalSupply = _totalSupply.add(_totalSupplyAccounting);
787         return
788             rewardPerTokenStored.add(
789                 lastTimeRewardApplicable()
790                     .sub(lastUpdateTime)
791                     .mul(rewardRate)
792                     .mul(1e18)
793                     .div(effectiveTotalSupply)
794             );
795     }
796 
797     // Returns the current reward tokens that the user can claim.
798     function earned(address account) public view returns (uint256) {
799         // Each user has it's own effective balance which is just the staked balance multiplied by boost level multiplier.
800         uint256 effectiveBalance = _balances[account].add(
801             _balancesAccounting[account]
802         );
803         return
804             effectiveBalance
805                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
806                 .div(1e18)
807                 .add(rewards[account]);
808     }
809 
810     // Staking function which updates the user balances in the parent contract
811     function stake(uint256 amount) public override {
812         updateReward(msg.sender);
813         require(amount > 0, "Cannot stake 0");
814         super.stake(amount);
815 
816         // Users that have bought multipliers will have an extra balance added to their stake according to the boost multiplier.
817         if (boostLevel[msg.sender] > 0) {
818             uint256 prevBalancesAccounting = _balancesAccounting[msg.sender];
819             // Calculate and set user's new accounting balance
820             uint256 accTotalMultiplier = getTotalMultiplier(msg.sender);
821             uint256 newBalancesAccounting = _balances[msg.sender]
822                 .mul(accTotalMultiplier)
823                 .div(1e18)
824                 .sub(_balances[msg.sender]);
825             _balancesAccounting[msg.sender] = newBalancesAccounting;
826             // Adjust total accounting supply accordingly
827             uint256 diffBalancesAccounting = newBalancesAccounting.sub(
828                 prevBalancesAccounting
829             );
830             _totalSupplyAccounting = _totalSupplyAccounting.add(
831                 diffBalancesAccounting
832             );
833         }
834 
835         emit Staked(msg.sender, amount);
836     }
837 
838     // Withdraw function to remove stake from the pool
839     function withdraw(uint256 amount) public override {
840         require(amount > 0, "Cannot withdraw 0");
841         updateReward(msg.sender);
842         super.withdraw(amount);
843 
844         // Users who have bought multipliers will have their accounting balances readjusted.
845         if (boostLevel[msg.sender] > 0) {
846             // The previous extra balance user had
847             uint256 prevBalancesAccounting = _balancesAccounting[msg.sender];
848             // Calculate and set user's new accounting balance
849             uint256 accTotalMultiplier = getTotalMultiplier(msg.sender);
850             uint256 newBalancesAccounting = _balances[msg.sender]
851                 .mul(accTotalMultiplier)
852                 .div(1e18)
853                 .sub(_balances[msg.sender]);
854             _balancesAccounting[msg.sender] = newBalancesAccounting;
855             // Subtract the withdrawn amount from the accounting balance
856             // If all tokens are withdrawn the balance will be 0.
857             uint256 diffBalancesAccounting = prevBalancesAccounting.sub(
858                 newBalancesAccounting
859             );
860             _totalSupplyAccounting = _totalSupplyAccounting.sub(
861                 diffBalancesAccounting
862             );
863         }
864 
865         emit Withdrawn(msg.sender, amount);
866     }
867 
868     // Get the earned rewards and withdraw staked tokens
869     function exit() external {
870         getReward();
871         withdraw(balanceOf(msg.sender));
872     }
873 
874     // Sends out the reward tokens to the user.
875     function getReward() public {
876         updateReward(msg.sender);
877         uint256 reward = earned(msg.sender);
878         if (reward > 0) {
879             rewards[msg.sender] = 0;
880             rewardToken.safeTransfer(msg.sender, reward);
881             emit RewardPaid(msg.sender, reward);
882         }
883     }
884 
885     // Called to start the pool with the reward amount it should distribute
886     // The reward period will be the duration of the pool.
887     function notifyRewardAmount(uint256 reward) external onlyOwner {
888         updateRewardPerTokenStored();
889         if (block.timestamp >= periodFinish) {
890             rewardRate = reward.div(DURATION);
891         } else {
892             uint256 remaining = periodFinish.sub(block.timestamp);
893             uint256 leftover = remaining.mul(rewardRate);
894             rewardRate = reward.add(leftover).div(DURATION);
895         }
896         lastUpdateTime = block.timestamp;
897         periodFinish = block.timestamp.add(DURATION);
898         emit RewardAdded(reward);
899     }
900 
901     // Notify the reward amount without updating time;
902     function notifyRewardAmountWithoutUpdateTime(uint256 reward)
903         external
904         onlyOwner
905     {
906         updateRewardPerTokenStored();
907         if (block.timestamp >= periodFinish) {
908             rewardRate = reward.div(DURATION);
909         } else {
910             uint256 remaining = periodFinish.sub(block.timestamp);
911             uint256 leftover = remaining.mul(rewardRate);
912             rewardRate = reward.add(leftover).div(DURATION);
913         }
914         emit RewardAdded(reward);
915     }
916 
917     // Returns the users current multiplier level
918     function getLevel(address account) external view returns (uint256) {
919         return boostLevel[account];
920     }
921 
922     // Return the amount spent on multipliers, used for subtracting for future purchases.
923     function getSpent(address account) external view returns (uint256) {
924         return spentMultiplierTokens[account];
925     }
926 
927     // Calculate the cost for purchasing a boost.
928     function calculateCost(uint256 level) public pure returns (uint256) {
929         if (level == 1) {
930             return boostLevelOneCost;
931         } else if (level == 2) {
932             return boostLevelTwoCost;
933         } else if (level == 3) {
934             return boostLevelThreeCost;
935         } else if (level == 4) {
936             return boostLevelFourCost;
937         }
938     }
939 
940     // Purchase a multiplier level, same level cannot be purchased twice.
941     function purchase(uint256 level) external {
942         require(
943             boostLevel[msg.sender] <= level,
944             "Cannot downgrade level or same level"
945         );
946         uint256 cost = calculateCost(level);
947         // Cost will be reduced by the amount already spent on multipliers.
948         uint256 finalCost = cost.sub(spentMultiplierTokens[msg.sender]);
949 
950         // Transfer tokens to the contract
951         multiplierToken.safeTransferFrom(msg.sender, address(this), finalCost);
952 
953         // Update balances and level
954         multiplierTokenDevFund = multiplierTokenDevFund.add(finalCost);
955         spentMultiplierTokens[msg.sender] = spentMultiplierTokens[msg.sender]
956             .add(finalCost);
957         boostLevel[msg.sender] = level;
958 
959         // If user has staked balances, then set their new accounting balance
960         if (_balances[msg.sender] > 0) {
961             // Get the previous accounting balance
962             uint256 prevBalancesAccounting = _balancesAccounting[msg.sender];
963             // Get the new multiplier
964             uint256 accTotalMultiplier = getTotalMultiplier(msg.sender);
965             // Calculate new accounting  balance
966             uint256 newBalancesAccounting = _balances[msg.sender]
967                 .mul(accTotalMultiplier)
968                 .div(1e18)
969                 .sub(_balances[msg.sender]);
970             // Set the accounting balance
971             _balancesAccounting[msg.sender] = newBalancesAccounting;
972             // Get the difference for adjusting the total accounting balance
973             uint256 diffBalancesAccounting = newBalancesAccounting.sub(
974                 prevBalancesAccounting
975             );
976             // Adjust the global accounting balance.
977             _totalSupplyAccounting = _totalSupplyAccounting.add(
978                 diffBalancesAccounting
979             );
980         }
981 
982         emit Boost(level);
983     }
984 
985     // Returns the multiplier for user.
986     function getTotalMultiplier(address account) public view returns (uint256) {
987         uint256 boostMultiplier = 0;
988         if (boostLevel[account] == 1) {
989             boostMultiplier = FivePercentBonus;
990         } else if (boostLevel[account] == 2) {
991             boostMultiplier = TwentyPercentBonus;
992         } else if (boostLevel[account] == 3) {
993             boostMultiplier = FourtyPercentBonus;
994         } else if (boostLevel[account] == 4) {
995             boostMultiplier = HundredPercentBonus;
996         }
997         return boostMultiplier.add(1 * 10**18);
998     }
999 
1000     // Distributes the dev fund for accounts
1001     function distributeDevFund() public override {
1002         uint256 totalMulitplierDistributionAmount = multiplierTokenDevFund;
1003         multiplierTokenDevFund = 0;
1004         // Distribute multiplier dev fund according to percentages
1005         for (uint256 i = 0; i < devCount; i++) {
1006             uint256 devPercentage = devAllocations[devIDs[i]];
1007             uint256 allocation = totalMulitplierDistributionAmount
1008                 .mul(devPercentage)
1009                 .div(100);
1010             if (allocation > 0) {
1011                 multiplierToken.safeTransfer(devIDs[i], allocation);
1012             }
1013         }
1014         // Distribute the staking token rewards
1015         super.distributeDevFund();
1016     }
1017 
1018     // Ejects any remaining tokens from the pool.
1019     // Callable only after the pool has started and the pools reward distribution period has finished.
1020     function eject() external onlyOwner {
1021         require(
1022             startTime < block.timestamp && block.timestamp >= periodFinish,
1023             "Cannot eject before period finishes or pool has started"
1024         );
1025         uint256 currBalance = rewardToken.balanceOf(address(this));
1026         rewardToken.safeTransfer(msg.sender, currBalance);
1027     }
1028 
1029     // Forcefully retire a pool
1030     // Only sets the period finish to 0
1031     // This will prevent more rewards from being disbursed
1032     function kill() external onlyOwner {
1033         periodFinish = block.timestamp;
1034     }
1035 
1036     function updateRewardPerTokenStored() internal {
1037         rewardPerTokenStored = rewardPerToken();
1038         lastUpdateTime = lastTimeRewardApplicable();
1039     }
1040 
1041     function updateReward(address account) internal {
1042         updateRewardPerTokenStored();
1043         rewards[account] = earned(account);
1044         userRewardPerTokenPaid[account] = rewardPerTokenStored;
1045     }
1046 }