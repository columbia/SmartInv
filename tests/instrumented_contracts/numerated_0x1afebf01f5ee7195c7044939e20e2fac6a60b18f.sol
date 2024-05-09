1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-13
3 */
4 
5 // SPDX-License-Identifier: Apache-2.0
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `recipient`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address recipient, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      */
102     function isContract(address account) internal view returns (bool) {
103         // This method relies on extcodesize, which returns 0 for contracts in
104         // construction, since the code is only stored at the end of the
105         // constructor execution.
106 
107         uint256 size;
108         assembly {
109             size := extcodesize(account)
110         }
111         return size > 0;
112     }
113 
114     /**
115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
116      * `recipient`, forwarding all available gas and reverting on errors.
117      *
118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
120      * imposed by `transfer`, making them unable to receive funds via
121      * `transfer`. {sendValue} removes this limitation.
122      *
123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
124      *
125      * IMPORTANT: because control is transferred to `recipient`, care must be
126      * taken to not create reentrancy vulnerabilities. Consider using
127      * {ReentrancyGuard} or the
128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
129      */
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(address(this).balance >= amount, "Address: insufficient balance");
132 
133         (bool success, ) = recipient.call{value: amount}("");
134         require(success, "Address: unable to send value, recipient may have reverted");
135     }
136 
137     /**
138      * @dev Performs a Solidity function call using a low level `call`. A
139      * plain `call` is an unsafe replacement for a function call: use this
140      * function instead.
141      *
142      * If `target` reverts with a revert reason, it is bubbled up by this
143      * function (like regular Solidity function calls).
144      *
145      * Returns the raw returned data. To convert to the expected return value,
146      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
147      *
148      * Requirements:
149      *
150      * - `target` must be a contract.
151      * - calling `target` with `data` must not revert.
152      *
153      * _Available since v3.1._
154      */
155     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionCall(target, data, "Address: low-level call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
161      * `errorMessage` as a fallback revert reason when `target` reverts.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal returns (bytes memory) {
170         return functionCallWithValue(target, data, 0, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but also transferring `value` wei to `target`.
176      *
177      * Requirements:
178      *
179      * - the calling contract must have an ETH balance of at least `value`.
180      * - the called Solidity function must be `payable`.
181      *
182      * _Available since v3.1._
183      */
184     function functionCallWithValue(
185         address target,
186         bytes memory data,
187         uint256 value
188     ) internal returns (bytes memory) {
189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
190     }
191 
192     /**
193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
194      * with `errorMessage` as a fallback revert reason when `target` reverts.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(
199         address target,
200         bytes memory data,
201         uint256 value,
202         string memory errorMessage
203     ) internal returns (bytes memory) {
204         require(address(this).balance >= value, "Address: insufficient balance for call");
205         require(isContract(target), "Address: call to non-contract");
206 
207         (bool success, bytes memory returndata) = target.call{value: value}(data);
208         return _verifyCallResult(success, returndata, errorMessage);
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
213      * but performing a static call.
214      *
215      * _Available since v3.3._
216      */
217     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
218         return functionStaticCall(target, data, "Address: low-level static call failed");
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(
228         address target,
229         bytes memory data,
230         string memory errorMessage
231     ) internal view returns (bytes memory) {
232         require(isContract(target), "Address: static call to non-contract");
233 
234         (bool success, bytes memory returndata) = target.staticcall(data);
235         return _verifyCallResult(success, returndata, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but performing a delegate call.
241      *
242      * _Available since v3.4._
243      */
244     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
245         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(
255         address target,
256         bytes memory data,
257         string memory errorMessage
258     ) internal returns (bytes memory) {
259         require(isContract(target), "Address: delegate call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.delegatecall(data);
262         return _verifyCallResult(success, returndata, errorMessage);
263     }
264 
265     function _verifyCallResult(
266         bool success,
267         bytes memory returndata,
268         string memory errorMessage
269     ) private pure returns (bytes memory) {
270         if (success) {
271             return returndata;
272         } else {
273             // Look for revert reason and bubble it up if present
274             if (returndata.length > 0) {
275                 // The easiest way to bubble the revert reason is using memory via assembly
276 
277                 assembly {
278                     let returndata_size := mload(returndata)
279                     revert(add(32, returndata), returndata_size)
280                 }
281             } else {
282                 revert(errorMessage);
283             }
284         }
285     }
286 }
287 
288 
289 library SafeERC20 {
290     using Address for address;
291 
292     function safeTransfer(
293         IERC20 token,
294         address to,
295         uint256 value
296     ) internal {
297         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
298     }
299 
300     function safeTransferFrom(
301         IERC20 token,
302         address from,
303         address to,
304         uint256 value
305     ) internal {
306         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
307     }
308 
309     /**
310      * @dev Deprecated. This function has issues similar to the ones found in
311      * {IERC20-approve}, and its usage is discouraged.
312      *
313      * Whenever possible, use {safeIncreaseAllowance} and
314      * {safeDecreaseAllowance} instead.
315      */
316     function safeApprove(
317         IERC20 token,
318         address spender,
319         uint256 value
320     ) internal {
321         // safeApprove should only be called when setting an initial allowance,
322         // or when resetting it to zero. To increase and decrease it, use
323         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
324         require(
325             (value == 0) || (token.allowance(address(this), spender) == 0),
326             "SafeERC20: approve from non-zero to non-zero allowance"
327         );
328         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
329     }
330 
331     function safeIncreaseAllowance(
332         IERC20 token,
333         address spender,
334         uint256 value
335     ) internal {
336         uint256 newAllowance = token.allowance(address(this), spender) + value;
337         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
338     }
339 
340     function safeDecreaseAllowance(
341         IERC20 token,
342         address spender,
343         uint256 value
344     ) internal {
345         unchecked {
346             uint256 oldAllowance = token.allowance(address(this), spender);
347             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
348             uint256 newAllowance = oldAllowance - value;
349             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
350         }
351     }
352 
353     /**
354      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
355      * on the return value: the return value is optional (but if data is returned, it must not be false).
356      * @param token The token targeted by the call.
357      * @param data The call data (encoded using abi.encode or one of its variants).
358      */
359     function _callOptionalReturn(IERC20 token, bytes memory data) private {
360         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
361         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
362         // the target address contains contract code and also asserts for success in the low-level call.
363 
364         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
365         if (returndata.length > 0) {
366             // Return data is optional
367             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
368         }
369     }
370 }
371 
372 
373 /**
374  * @dev Wrappers over Solidity's arithmetic operations with added overflow
375  * checks.
376  *
377  * Arithmetic operations in Solidity wrap on overflow. This can easily result
378  * in bugs, because programmers usually assume that an overflow raises an
379  * error, which is the standard behavior in high level programming languages.
380  * `SafeMath` restores this intuition by reverting the transaction when an
381  * operation overflows.
382  *
383  * Using this library instead of the unchecked operations eliminates an entire
384  * class of bugs, so it's recommended to use it always.
385  */
386 library SafeMath {
387   /**
388    * @dev Returns the addition of two unsigned integers, reverting on
389    * overflow.
390    *
391    * Counterpart to Solidity's `+` operator.
392    *
393    * Requirements:
394    * - Addition cannot overflow.
395    */
396   function add(uint256 a, uint256 b) internal pure returns (uint256) {
397     uint256 c = a + b;
398     require(c >= a, "SafeMath: addition overflow");
399 
400     return c;
401   }
402 
403   /**
404    * @dev Returns the subtraction of two unsigned integers, reverting on
405    * overflow (when the result is negative).
406    *
407    * Counterpart to Solidity's `-` operator.
408    *
409    * Requirements:
410    * - Subtraction cannot overflow.
411    */
412   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
413     return sub(a, b, "SafeMath: subtraction overflow");
414   }
415 
416   /**
417    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
418    * overflow (when the result is negative).
419    *
420    * Counterpart to Solidity's `-` operator.
421    *
422    * Requirements:
423    * - Subtraction cannot overflow.
424    */
425   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
426     require(b <= a, errorMessage);
427     uint256 c = a - b;
428 
429     return c;
430   }
431 
432   /**
433    * @dev Returns the multiplication of two unsigned integers, reverting on
434    * overflow.
435    *
436    * Counterpart to Solidity's `*` operator.
437    *
438    * Requirements:
439    * - Multiplication cannot overflow.
440    */
441   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
442     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
443     // benefit is lost if 'b' is also tested.
444     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
445     if (a == 0) {
446       return 0;
447     }
448 
449     uint256 c = a * b;
450     require(c / a == b, "SafeMath: multiplication overflow");
451 
452     return c;
453   }
454 
455   /**
456    * @dev Returns the integer division of two unsigned integers. Reverts on
457    * division by zero. The result is rounded towards zero.
458    *
459    * Counterpart to Solidity's `/` operator. Note: this function uses a
460    * `revert` opcode (which leaves remaining gas untouched) while Solidity
461    * uses an invalid opcode to revert (consuming all remaining gas).
462    *
463    * Requirements:
464    * - The divisor cannot be zero.
465    */
466   function div(uint256 a, uint256 b) internal pure returns (uint256) {
467     return div(a, b, "SafeMath: division by zero");
468   }
469 
470   /**
471    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
472    * division by zero. The result is rounded towards zero.
473    *
474    * Counterpart to Solidity's `/` operator. Note: this function uses a
475    * `revert` opcode (which leaves remaining gas untouched) while Solidity
476    * uses an invalid opcode to revert (consuming all remaining gas).
477    *
478    * Requirements:
479    * - The divisor cannot be zero.
480    */
481   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
482     // Solidity only automatically asserts when dividing by 0
483     require(b > 0, errorMessage);
484     uint256 c = a / b;
485     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
486 
487     return c;
488   }
489 
490   /**
491    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
492    * Reverts when dividing by zero.
493    *
494    * Counterpart to Solidity's `%` operator. This function uses a `revert`
495    * opcode (which leaves remaining gas untouched) while Solidity uses an
496    * invalid opcode to revert (consuming all remaining gas).
497    *
498    * Requirements:
499    * - The divisor cannot be zero.
500    */
501   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
502     return mod(a, b, "SafeMath: modulo by zero");
503   }
504 
505   /**
506    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
507    * Reverts with custom message when dividing by zero.
508    *
509    * Counterpart to Solidity's `%` operator. This function uses a `revert`
510    * opcode (which leaves remaining gas untouched) while Solidity uses an
511    * invalid opcode to revert (consuming all remaining gas).
512    *
513    * Requirements:
514    * - The divisor cannot be zero.
515    */
516   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
517     require(b != 0, errorMessage);
518     return a % b;
519   }
520 }
521 
522 
523 
524 /*
525  * @dev Provides information about the current execution context, including the
526  * sender of the transaction and its data. While these are generally available
527  * via msg.sender and msg.data, they should not be accessed in such a direct
528  * manner, since when dealing with GSN meta-transactions the account sending and
529  * paying for execution may not be the actual sender (as far as an application
530  * is concerned).
531  *
532  * This contract is only required for intermediate, library-like contracts.
533  */
534 contract Context {
535   // Empty internal constructor, to prevent people from mistakenly deploying
536   // an instance of this contract, which should be used via inheritance.
537   constructor ()  { }
538 
539   function _msgSender() internal view returns (address payable) {
540     return payable(msg.sender);
541   }
542 
543   function _msgData() internal view returns (bytes memory) {
544     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
545     return msg.data;
546   }
547 }
548 
549 
550 //ownerable
551 
552 contract Ownable is Context {
553   address private _owner;
554 
555   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
556 
557   /**
558    * @dev Initializes the contract setting the deployer as the initial owner.
559    */
560   constructor () {
561     address msgSender = _msgSender();
562     _owner = msgSender;
563     emit OwnershipTransferred(address(0), msgSender);
564   }
565 
566   /**
567    * @dev Returns the address of the current owner.
568    */
569   function owner() public view returns (address) {
570     return _owner;
571   }
572 
573   /**
574    * @dev Throws if called by any account other than the owner.
575    */
576   modifier onlyOwner() {
577     require(_owner == _msgSender(), "Ownable: caller is not the owner");
578     _;
579   }
580 
581   /**
582    * @dev Leaves the contract without owner. It will not be possible to call
583    * `onlyOwner` functions anymore. Can only be called by the current owner.
584    *
585    * NOTE: Renouncing ownership will leave the contract without an owner,
586    * thereby removing any functionality that is only available to the owner.
587    */
588   function renounceOwnership() public onlyOwner {
589     emit OwnershipTransferred(_owner, address(0));
590     _owner = address(0);
591   }
592 
593   /**
594    * @dev Transfers ownership of the contract to a new account (`newOwner`).
595    * Can only be called by the current owner.
596    */
597   function transferOwnership(address newOwner) public onlyOwner {
598     _transferOwnership(newOwner);
599   }
600 
601   /**
602    * @dev Transfers ownership of the contract to a new account (`newOwner`).
603    */
604   function _transferOwnership(address newOwner) internal {
605     require(newOwner != address(0), "Ownable: new owner is the zero address");
606     emit OwnershipTransferred(_owner, newOwner);
607     _owner = newOwner;
608   }
609 }
610 
611 
612 contract Staking is Ownable{
613     using SafeMath for uint256;
614     using SafeERC20 for IERC20;
615     
616     event Withdraw(address a,uint256 amount);
617     event Stake(address a,uint256 amount,uint256 unlocktime);
618     
619     struct staker{
620         uint256 amount;
621         uint256 lockedtime;
622         uint256 rate;
623     }
624     
625     mapping (address => staker) public _stakers;
626     
627     
628     //staking steps
629     uint256[] private times;
630     uint256[] private rates;
631     
632     //locked balance in contract
633     uint256 public lockedBalance;
634     
635     //buyforstaking
636     
637     IERC20 public usdt = IERC20 (0xdAC17F958D2ee523a2206206994597C13D831ec7);
638     IERC20 public weth =IERC20 (0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
639     IERC20 public atari = IERC20 (0xdacD69347dE42baBfAEcD09dC88958378780FB62);
640     
641     address private pairAtariEth = 0xc4d9102e36c5063b98010A03C1F7C8bD44c32A00;
642     address public pairEthUsdt = 0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852;
643     
644     constructor(){
645         times.push(2592000);
646         times.push(7776000);
647         times.push(15552000);
648         times.push(31104000);
649         rates.push(1);
650         rates.push(5);
651         rates.push(12);
652         rates.push(30);
653         
654     }
655     
656     function stake(uint256 amount,uint256 stakestep) external {
657         require(_stakers[msg.sender].amount==0,"already stake exist");
658         require(amount!=0 ,"amount must not 0");
659         require(times[stakestep]!=0,"lockedtime must not 0");
660         
661         atari.transferFrom(msg.sender,address(this),amount);
662         
663         uint256 lockBalance=amount.mul(rates[stakestep].add(100)).div(100);
664         lockedBalance=lockedBalance.add(lockBalance);
665         
666         require(lockedBalance<atari.balanceOf(address(this)),"Stake : staking is full");
667         
668         _stakers[msg.sender]= staker(lockBalance,block.timestamp.add(times[stakestep]),rates[stakestep]);
669         
670         emit Stake(msg.sender,lockBalance,block.timestamp.add(times[stakestep]));
671     }
672     
673     function withdraw() external {
674         require(_stakers[msg.sender].amount>0,"there is no staked amount");
675         require(_stakers[msg.sender].lockedtime<block.timestamp,"not ready to withdraw");
676         
677         lockedBalance=lockedBalance.sub(_stakers[msg.sender].amount);
678         atari.transfer(msg.sender,_stakers[msg.sender].amount);
679         _stakers[msg.sender]=staker(0,0,0);
680     }
681     
682     function getlocktime(address a)external view returns (uint256){
683         if(block.timestamp>_stakers[a].lockedtime)
684             return 0;
685         return _stakers[a].lockedtime.sub(block.timestamp);
686     }
687     
688     function getamount(address a)external view returns(uint256){
689         return _stakers[a].amount;
690     }
691     
692     function getTotoalAmount() external view returns(uint256){
693        return atari.balanceOf(address(this));
694     }
695     
696     
697     //for Owner
698     function withdrawOwner(uint256 amount) external onlyOwner{
699         require(amount<atari.balanceOf(address(this)).sub(lockedBalance));
700         atari.transfer(_msgSender(),amount);
701     }
702     
703     function withdrawOwnerETH(uint256 amount) external payable onlyOwner{
704         require(address(this).balance>amount);
705         _msgSender().transfer(amount);    
706     }
707     
708     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
709         require(amountIn > 0, 'Uniswap: INSUFFICIENT_OUTPUT_AMOUNT');
710         require(reserveIn > 0 && reserveOut > 0, 'Uniswap: INSUFFICIENT_LIQUIDITY');
711         uint numerator = amountIn.mul(reserveOut);
712         uint denominator = reserveIn.add(amountIn);
713         amountOut = numerator / denominator;
714     }
715     
716     
717     
718     function tokenPriceOut(uint256 amountin) public view returns(uint256){
719         
720         uint256 ethAmount = weth.balanceOf(pairAtariEth);
721         uint256 atariAmount = atari.balanceOf(pairAtariEth);
722         
723         return getAmountOut(amountin,ethAmount,atariAmount);
724     }
725     
726     function tokenPriceOutUsdt(uint256 amountin) public view returns(uint256){
727         
728         //get eth amount with usdt amount
729         uint256 ethAmount = weth.balanceOf(pairEthUsdt);
730         uint256 usdtAmount = usdt.balanceOf(pairEthUsdt);
731         
732         uint256 amountin1 = getAmountOut(amountin,usdtAmount,ethAmount);
733         
734         uint256 ethAmount1 = weth.balanceOf(pairAtariEth);
735         uint256 atariAmount = atari.balanceOf(pairAtariEth);
736         
737         return getAmountOut(amountin1,ethAmount1,atariAmount);
738     }
739     
740 
741     
742     function buyforstakingwithexactEHTforToken(uint256 stakestep) external payable {
743         uint256 tokenAmount=tokenPriceOut(msg.value.mul(100).div(100-rates[stakestep]));
744         
745         lockedBalance=lockedBalance.add(tokenAmount);
746         require(lockedBalance<atari.balanceOf(address(this)),"Stake : staking is full");
747         _stakers[msg.sender]=staker(tokenAmount,block.timestamp.add(times[stakestep]),rates[stakestep]);
748         payable(owner()).transfer(msg.value);
749         emit Stake(msg.sender,tokenAmount,block.timestamp.add(times[stakestep]));
750     }
751     
752     function buyforstakingwithexactUsdtforToken(uint256 amount, uint256 stakestep) external {
753         
754         uint256 tokenAmount=tokenPriceOutUsdt(amount.mul(100).div(100-rates[stakestep]));
755         usdt.safeTransferFrom(msg.sender,owner(),amount);
756         lockedBalance=lockedBalance.add(tokenAmount);
757         require(lockedBalance<atari.balanceOf(address(this)),"Stake : staking is full");
758         _stakers[msg.sender]=staker(tokenAmount,block.timestamp.add(times[stakestep]),rates[stakestep]);
759         
760         emit Stake(msg.sender,tokenAmount,block.timestamp.add(times[stakestep]));
761     }
762     
763     function buy() external payable {
764         uint256 tokenAmount=tokenPriceOut(msg.value);
765         require(atari.balanceOf(address(this)).sub(lockedBalance)>tokenAmount, "stake: atari balance not enough");
766         atari.transfer(msg.sender,tokenAmount);
767         payable(owner()).transfer(msg.value);
768     }
769     
770     function buyforUsdt(uint256 amount) external  {
771         uint256 tokenAmount=tokenPriceOutUsdt(amount);
772         require(atari.balanceOf(address(this)).sub(lockedBalance)>tokenAmount, "stake: atari balance not enough");
773         atari.transfer(msg.sender,tokenAmount);
774         usdt.safeTransferFrom(msg.sender,owner(),amount);
775     }
776     
777     
778     // function buyforstakingwithEHTforexactToken(uint256 amountOut,uint256 stakestep) external payable {
779         
780     //     uint256 ETHAmount=tokenPriceIn(amountOut).mul(100-rates[stakestep]).div(100);
781     //     require(ETHAmount==msg.value,"buyforstaking : wrong ETH amount");
782         
783     //     lockedBalance=lockedBalance.add(amountOut);
784     //     _stakers[msg.sender]=staker(amountOut,block.timestamp.add(times[stakestep]),rates[stakestep]);
785         
786     //     emit Stake(msg.sender,amountOut,block.timestamp.add(times[stakestep]));
787     // }
788     
789 }