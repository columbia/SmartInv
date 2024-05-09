1 // SPDX-License-Identifier: MIT    
2 // TG: https://t.me/EtherFlexPortal                                                                           
3                                                     
4 pragma solidity 0.8.19;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 library Address {
18     function isContract(address account) internal view returns (bool) {
19         return account.code.length > 0;
20     }
21 
22     function sendValue(address payable recipient, uint256 amt) internal {
23         require(address(this).balance >= amt, "Address: insufficient balance");
24 
25         (bool success, ) = recipient.call{value: amt}("");
26         require(success, "Address: unable to send value, recipient may have reverted");
27     }
28 
29     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
30         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
31     }
32 
33     function functionCall(
34         address target,
35         bytes memory data,
36         string memory errorMessage
37     ) internal returns (bytes memory) {
38         return functionCallWithValue(target, data, 0, errorMessage);
39     }
40 
41     /**
42      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
43      * but also transferring `value` wei to `target`.
44      *
45      * Requirements:
46      *
47      * - the calling contract must have an ETH balance of at least `value`.
48      * - the called Solidity function must be `payable`.
49      *
50      * _Available since v3.1._
51      */
52     function functionCallWithValue(
53         address target,
54         bytes memory data,
55         uint256 value
56     ) internal returns (bytes memory) {
57         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
58     }
59 
60     /**
61      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
62      * with `errorMessage` as a fallback revert reason when `target` reverts.
63      *
64      * _Available since v3.1._
65      */
66     function functionCallWithValue(
67         address target,
68         bytes memory data,
69         uint256 value,
70         string memory errorMessage
71     ) internal returns (bytes memory) {
72         require(address(this).balance >= value, "Address: insufficient balance for call");
73         (bool success, bytes memory returndata) = target.call{value: value}(data);
74         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
75     }
76 
77     /**
78      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
79      * but performing a static call.
80      *
81      * _Available since v3.3._
82      */
83     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
84         return functionStaticCall(target, data, "Address: low-level static call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
89      * but performing a static call.
90      *
91      * _Available since v3.3._
92      */
93     function functionStaticCall(
94         address target,
95         bytes memory data,
96         string memory errorMessage
97     ) internal view returns (bytes memory) {
98         (bool success, bytes memory returndata) = target.staticcall(data);
99         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
100     }
101 
102     /**
103      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
104      * but performing a delegate call.
105      *
106      * _Available since v3.4._
107      */
108     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
109         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
114      * but performing a delegate call.
115      *
116      * _Available since v3.4._
117      */
118     function functionDelegateCall(
119         address target,
120         bytes memory data,
121         string memory errorMessage
122     ) internal returns (bytes memory) {
123         (bool success, bytes memory returndata) = target.delegatecall(data);
124         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
125     }
126 
127     /**
128      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
129      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
130      *
131      * _Available since v4.8._
132      */
133     function verifyCallResultFromTarget(
134         address target,
135         bool success,
136         bytes memory returndata,
137         string memory errorMessage
138     ) internal view returns (bytes memory) {
139         if (success) {
140             if (returndata.length == 0) {
141                 // only check isContract if the call was successful and the return data is empty
142                 // otherwise we already know that it was a contract
143                 require(isContract(target), "Address: call to non-contract");
144             }
145             return returndata;
146         } else {
147             _revert(returndata, errorMessage);
148         }
149     }
150 
151     /**
152      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
153      * revert reason or using the provided one.
154      *
155      * _Available since v4.3._
156      */
157     function verifyCallResult(
158         bool success,
159         bytes memory returndata,
160         string memory errorMessage
161     ) internal pure returns (bytes memory) {
162         if (success) {
163             return returndata;
164         } else {
165             _revert(returndata, errorMessage);
166         }
167     }
168 
169     function _revert(bytes memory returndata, string memory errorMessage) private pure {
170         // Look for revert reason and bubble it up if present
171         if (returndata.length > 0) {
172             // The easiest way to bubble the revert reason is using memory via assembly
173             /// @solidity memory-safe-assembly
174             assembly {
175                 let returndata_size := mload(returndata)
176                 revert(add(32, returndata), returndata_size)
177             }
178         } else {
179             revert(errorMessage);
180         }
181     }
182 }
183 
184 library SafeERC20 {
185     using Address for address;
186 
187     function safeTransfer(
188         IERC20 token,
189         address to,
190         uint256 value
191     ) internal {
192         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
193     }
194 
195     function _callOptionalReturn(IERC20 token, bytes memory data) private {
196         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
197         if (returndata.length > 0) {
198             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
199         }
200     }
201 }
202 
203 interface IERC20 {
204     function totalSupply() external view returns (uint256);
205     function balanceOf(address account) external view returns (uint256);
206     function transfer(address recipient, uint256 amt) external returns (bool);
207     function allowance(address owner, address spender) external view returns (uint256);
208     function approve(address spender, uint256 amt) external returns (bool);
209     function transferFrom(address sender, address recipient, uint256 amt) external returns (bool);
210     function name() external view returns (string memory);
211     function symbol() external view returns (string memory);
212     function decimals() external view returns (uint8);
213 
214     event Transfer(address indexed from, address indexed to, uint256 value);
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 contract ERC20 is Context, IERC20 {
219     mapping(address => uint256) private _balances;
220 
221     mapping(address => mapping(address => uint256)) private _allowances;
222 
223     uint256 private _totalSupply;
224 
225     string private _name;
226     string private _symbol;
227 
228     constructor(string memory name_, string memory symbol_) {
229         _name = name_;
230         _symbol = symbol_;
231     }
232 
233     function name() public view virtual override returns (string memory) {
234         return _name;
235     }
236 
237     function symbol() public view virtual override returns (string memory) {
238         return _symbol;
239     }
240 
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244 
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248 
249     function balanceOf(address account) public view virtual override returns (uint256) {
250         return _balances[account];
251     }
252 
253     function transfer(address recipient, uint256 amt) public virtual override returns (bool) {
254         _transfer(_msgSender(), recipient, amt);
255         return true;
256     }
257 
258     function allowance(address owner, address spender) public view virtual override returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     function approve(address spender, uint256 amt) public virtual override returns (bool) {
263         _approve(_msgSender(), spender, amt);
264         return true;
265     }
266 
267     function transferFrom(address sender, address recipient, uint256 amt) public virtual override returns (bool) {
268         _transfer(sender, recipient, amt);
269 
270         uint256 currentAllowance = _allowances[sender][_msgSender()];
271         require(currentAllowance >= amt, "ERC20: transfer amt exceeds allowance");
272         unchecked {
273             _approve(sender, _msgSender(), currentAllowance - amt);
274         }
275 
276         return true;
277     }
278 
279     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
280         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
281         return true;
282     }
283 
284     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
285         uint256 currentAllowance = _allowances[_msgSender()][spender];
286         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
287         unchecked {
288             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
289         }
290 
291         return true;
292     }
293 
294     function _transfer(address sender, address recipient, uint256 amt) internal virtual {
295         require(sender != address(0), "ERC20: transfer from the zero address");
296         require(recipient != address(0), "ERC20: transfer to the zero address");
297 
298         uint256 senderBalance = _balances[sender];
299         require(senderBalance >= amt, "ERC20: transfer amt exceeds balance");
300         unchecked {
301             _balances[sender] = senderBalance - amt;
302         }
303         _balances[recipient] += amt;
304 
305         emit Transfer(sender, recipient, amt);
306     }
307 
308     function _createInitialSupply(address account, uint256 amt) internal virtual {
309         require(account != address(0), "ERC20: mint to the zero address");
310 
311         _totalSupply += amt;
312         _balances[account] += amt;
313         emit Transfer(address(0), account, amt);
314     }
315 
316     function _approve(address owner, address spender, uint256 amt) internal virtual {
317         require(owner != address(0), "ERC20: approve from the zero address");
318         require(spender != address(0), "ERC20: approve to the zero address");
319 
320         _allowances[owner][spender] = amt;
321         emit Approval(owner, spender, amt);
322     }
323 }
324 
325 contract Ownable is Context {
326     address private _owner;
327 
328     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
329     
330     constructor () {
331         address msgSender = _msgSender();
332         _owner = msgSender;
333         emit OwnershipTransferred(address(0), msgSender);
334     }
335 
336     function owner() public view returns (address) {
337         return _owner;
338     }
339 
340     modifier onlyOwner() {
341         require(_owner == _msgSender(), "Ownable: caller is not the owner");
342         _;
343     }
344 
345     function renounceOwnership() external virtual onlyOwner {
346         emit OwnershipTransferred(_owner, address(0));
347         _owner = address(0);
348     }
349 
350     function transferOwnership(address newOwner) public virtual onlyOwner {
351         require(newOwner != address(0), "Ownable: new owner is the zero address");
352         emit OwnershipTransferred(_owner, newOwner);
353         _owner = newOwner;
354     }
355 }
356 
357 interface IDexRouter {
358     function factory() external pure returns (address);
359     function WETH() external pure returns (address);
360     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
361     function swapExactETHForTokensSupportingFeeOnTransferTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable;
362     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
363     function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, address referrer, uint deadline) external;
364     function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
365     function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
366     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
367     function removeLiquidity(address tokenA, address tokenB, uint liquidity, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB);
368 }
369 
370 interface DividendPayingTokenOptionalInterface {
371   /// @notice View the amt of dividend in wei that an address can withdraw.
372   /// @param _owner The address of a token holder.
373   /// @return The amt of dividend in wei that `_owner` can withdraw.
374   function withdrawableDividendOf(address _owner) external view returns(uint256);
375 
376   /// @notice View the amt of dividend in wei that an address has withdrawn.
377   /// @param _owner The address of a token holder.
378   /// @return The amt of dividend in wei that `_owner` has withdrawn.
379   function withdrawnDividendOf(address _owner) external view returns(uint256);
380 
381   /// @notice View the amt of dividend in wei that an address has earned in total.
382   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
383   /// @param _owner The address of a token holder.
384   /// @return The amt of dividend in wei that `_owner` has earned in total.
385   function accumulativeDividendOf(address _owner) external view returns(uint256);
386 }
387 
388 interface DividendPayingTokenInterface {
389   /// @notice View the amt of dividend in wei that an address can withdraw.
390   /// @param _owner The address of a token holder.
391   /// @return The amt of dividend in wei that `_owner` can withdraw.
392   function dividendOf(address _owner) external view returns(uint256);
393 
394   /// @notice Distributes ether to token holders as dividends.
395   /// @dev SHOULD distribute the paid ether to token holders as dividends.
396   ///  SHOULD NOT directly transfer ether to token holders in this function.
397   ///  MUST emit a `DividendsDistributed` event when the amt of distributed ether is greater than 0.
398   function distributeDividends() external payable;
399 
400   /// @notice Withdraws the ether distributed to the sender.
401   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
402   ///  MUST emit a `DividendWithdrawn` event if the amt of ether transferred is greater than 0.
403   function withdrawDividend() external;
404 
405   /// @dev This event MUST emit when ether is distributed to token holders.
406   /// @param from The address which sends ether to this contract.
407   /// @param weiAmt The amt of distributed ether in wei.
408   event DividendsDistributed(
409     address indexed from,
410     uint256 weiAmt
411   );
412 
413   /// @dev This event MUST emit when an address withdraws their dividend.
414   /// @param to The address which withdraws ether from this contract.
415   /// @param weiAmt The amt of withdrawn ether in wei.
416   event DividendWithdrawn(
417     address indexed to,
418     uint256 weiAmt
419   );
420 }
421 
422 library SafeMath {
423     /**
424      * @dev Returns the addition of two unsigned integers, reverting on
425      * overflow.
426      *
427      * Counterpart to Solidity's `+` operator.
428      *
429      * Requirements:
430      *
431      * - Addition cannot overflow.
432      */
433     function add(uint256 a, uint256 b) internal pure returns (uint256) {
434         uint256 c = a + b;
435         require(c >= a, "SafeMath: addition overflow");
436 
437         return c;
438     }
439 
440     /**
441      * @dev Returns the subtraction of two unsigned integers, reverting on
442      * overflow (when the result is negative).
443      *
444      * Counterpart to Solidity's `-` operator.
445      *
446      * Requirements:
447      *
448      * - Subtraction cannot overflow.
449      */
450     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
451         return sub(a, b, "SafeMath: subtraction overflow");
452     }
453 
454     /**
455      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
456      * overflow (when the result is negative).
457      *
458      * Counterpart to Solidity's `-` operator.
459      *
460      * Requirements:
461      *
462      * - Subtraction cannot overflow.
463      */
464     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
465         require(b <= a, errorMessage);
466         uint256 c = a - b;
467 
468         return c;
469     }
470 
471     /**
472      * @dev Returns the multiplication of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `*` operator.
476      *
477      * Requirements:
478      *
479      * - Multiplication cannot overflow.
480      */
481     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
482         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
483         // benefit is lost if 'b' is also tested.
484         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
485         if (a == 0) {
486             return 0;
487         }
488 
489         uint256 c = a * b;
490         require(c / a == b, "SafeMath: multiplication overflow");
491 
492         return c;
493     }
494 
495     /**
496      * @dev Returns the integer division of two unsigned integers. Reverts on
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
508         return div(a, b, "SafeMath: division by zero");
509     }
510 
511     /**
512      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
513      * division by zero. The result is rounded towards zero.
514      *
515      * Counterpart to Solidity's `/` operator. Note: this function uses a
516      * `revert` opcode (which leaves remaining gas untouched) while Solidity
517      * uses an invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b > 0, errorMessage);
525         uint256 c = a / b;
526         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
527 
528         return c;
529     }
530 
531     /**
532      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
533      * Reverts when dividing by zero.
534      *
535      * Counterpart to Solidity's `%` operator. This function uses a `revert`
536      * opcode (which leaves remaining gas untouched) while Solidity uses an
537      * invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
544         return mod(a, b, "SafeMath: modulo by zero");
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
549      * Reverts with custom message when dividing by zero.
550      *
551      * Counterpart to Solidity's `%` operator. This function uses a `revert`
552      * opcode (which leaves remaining gas untouched) while Solidity uses an
553      * invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      *
557      * - The divisor cannot be zero.
558      */
559     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b != 0, errorMessage);
561         return a % b;
562     }
563 }
564 
565 library SafeMathInt {
566     int256 private constant MIN_INT256 = int256(1) << 255;
567     int256 private constant MAX_INT256 = ~(int256(1) << 255);
568 
569     /**
570      * @dev Multiplies two int256 variables and fails on overflow.
571      */
572     function mul(int256 a, int256 b) internal pure returns (int256) {
573         int256 c = a * b;
574 
575         // Detect overflow when multiplying MIN_INT256 with -1
576         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
577         require((b == 0) || (c / b == a));
578         return c;
579     }
580 
581     /**
582      * @dev Division of two int256 variables and fails on overflow.
583      */
584     function div(int256 a, int256 b) internal pure returns (int256) {
585         // Prevent overflow when dividing MIN_INT256 by -1
586         require(b != -1 || a != MIN_INT256);
587 
588         // Solidity already throws when dividing by 0.
589         return a / b;
590     }
591 
592     /**
593      * @dev Subtracts two int256 variables and fails on overflow.
594      */
595     function sub(int256 a, int256 b) internal pure returns (int256) {
596         int256 c = a - b;
597         require((b >= 0 && c <= a) || (b < 0 && c > a));
598         return c;
599     }
600 
601     /**
602      * @dev Adds two int256 variables and fails on overflow.
603      */
604     function add(int256 a, int256 b) internal pure returns (int256) {
605         int256 c = a + b;
606         require((b >= 0 && c >= a) || (b < 0 && c < a));
607         return c;
608     }
609 
610     /**
611      * @dev Converts to absolute value, and fails on overflow.
612      */
613     function abs(int256 a) internal pure returns (int256) {
614         require(a != MIN_INT256);
615         return a < 0 ? -a : a;
616     }
617 
618 
619     function toUint256Safe(int256 a) internal pure returns (uint256) {
620         require(a >= 0);
621         return uint256(a);
622     }
623 }
624 
625 library SafeMathUint {
626   function toInt256Safe(uint256 a) internal pure returns (int256) {
627     int256 b = int256(a);
628     require(b >= 0);
629     return b;
630   }
631 }
632 
633 contract DividendPayingToken is DividendPayingTokenInterface, DividendPayingTokenOptionalInterface, Ownable {
634   using SafeMath for uint256;
635   using SafeMathUint for uint256;
636   using SafeMathInt for int256;
637 
638   // With `magnitude`, we can properly distribute dividends even if the amt of received ether is small.
639   // For more discussion about choosing the value of `magnitude`,
640   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
641   uint256 constant internal magnitude = 2**128;
642 
643   uint256 internal magnifiedDividendPerShare;
644   
645   // About dividendCorrection:
646   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
647   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
648   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
649   //   `dividendOf(_user)` should not be changed,
650   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
651   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
652   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
653   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
654   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
655   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
656   mapping(address => int256) internal magnifiedDividendCorrections;
657   mapping(address => uint256) internal withdrawnDividends;
658   
659   mapping (address => uint256) public holderBalance;
660   uint256 public totalBalance;
661 
662   uint256 public totalDividendsDistributed;
663 
664   /// @dev Distributes dividends whenever ether is paid to this contract.
665   receive() external payable {
666     distributeDividends();
667   }
668 
669   /// @notice Distributes ether to token holders as dividends.
670   /// @dev It reverts if the total supply of tokens is 0.
671   /// It emits the `DividendsDistributed` event if the amt of received ether is greater than 0.
672   /// About undistributed ether:
673   ///   In each distribution, there is a small amt of ether not distributed,
674   ///     the magnified amt of which is
675   ///     `(msg.value * magnitude) % totalSupply()`.
676   ///   With a well-chosen `magnitude`, the amt of undistributed ether
677   ///     (de-magnified) in a distribution can be less than 1 wei.
678   ///   We can actually keep track of the undistributed ether in a distribution
679   ///     and try to distribute it in the next distribution,
680   ///     but keeping track of such data on-chain costs much more than
681   ///     the saved ether, so we don't do that.
682     
683   function distributeDividends() public override payable {
684     if(totalBalance > 0){
685         uint256 amt = msg.value;
686         if (amt > 0) {
687         magnifiedDividendPerShare = magnifiedDividendPerShare.add(
688             (amt).mul(magnitude) / totalBalance
689         );
690         emit DividendsDistributed(msg.sender, amt);
691 
692         totalDividendsDistributed = totalDividendsDistributed.add(amt);
693         }
694     }
695   }
696 
697 
698   /// @notice Withdraws the ether distributed to the sender.
699   /// @dev It emits a `DividendWithdrawn` event if the amt of withdrawn ether is greater than 0.
700   function withdrawDividend() public virtual override {
701     _withdrawDividendOfUser(payable(msg.sender));
702   }
703 
704   /// @notice Withdraws the ether distributed to the sender.
705   /// @dev It emits a `DividendWithdrawn` event if the amt of withdrawn ether is greater than 0.
706   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
707     uint256 _withdrawableDividend = withdrawableDividendOf(user);
708     if (_withdrawableDividend > 0) {
709       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
710       emit DividendWithdrawn(user, _withdrawableDividend);
711       bool success;
712       (success,) = address(user).call{value: _withdrawableDividend}("");
713 
714       return _withdrawableDividend;
715     }
716 
717     return 0;
718   }
719 
720 
721   /// @notice View the amt of dividend in wei that an address can withdraw.
722   /// @param _owner The address of a token holder.
723   /// @return The amt of dividend in wei that `_owner` can withdraw.
724   function dividendOf(address _owner) public view override returns(uint256) {
725     return withdrawableDividendOf(_owner);
726   }
727 
728   /// @notice View the amt of dividend in wei that an address can withdraw.
729   /// @param _owner The address of a token holder.
730   /// @return The amt of dividend in wei that `_owner` can withdraw.
731   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
732     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
733   }
734 
735   /// @notice View the amt of dividend in wei that an address has withdrawn.
736   /// @param _owner The address of a token holder.
737   /// @return The amt of dividend in wei that `_owner` has withdrawn.
738   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
739     return withdrawnDividends[_owner];
740   }
741 
742 
743   /// @notice View the amt of dividend in wei that an address has earned in total.
744   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
745   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
746   /// @param _owner The address of a token holder.
747   /// @return The amt of dividend in wei that `_owner` has earned in total.
748   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
749     return magnifiedDividendPerShare.mul(holderBalance[_owner]).toInt256Safe()
750       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
751   }
752 
753   /// @dev Internal function that increases tokens to an account.
754   /// Update magnifiedDividendCorrections to keep dividends unchanged.
755   /// @param account The account that will receive the created tokens.
756   /// @param value The amt that will be created.
757   function _increase(address account, uint256 value) internal {
758     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
759       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
760   }
761 
762   /// @dev Internal function that reduces an amt of the token of a given account.
763   /// Update magnifiedDividendCorrections to keep dividends unchanged.
764   /// @param account The account whose tokens will be burnt.
765   /// @param value The amt that will be burnt.
766   function _reduce(address account, uint256 value) internal {
767     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
768       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
769   }
770 
771   function _setBalance(address account, uint256 newBalance) internal {
772     uint256 currentBalance = holderBalance[account];
773     holderBalance[account] = newBalance;
774     if(newBalance > currentBalance) {
775       uint256 increaseAmt = newBalance.sub(currentBalance);
776       _increase(account, increaseAmt);
777       totalBalance += increaseAmt;
778     } else if(newBalance < currentBalance) {
779       uint256 reduceAmt = currentBalance.sub(newBalance);
780       _reduce(account, reduceAmt);
781       totalBalance -= reduceAmt;
782     }
783   }
784 }
785 
786 contract DividendTracker is DividendPayingToken {
787     using SafeMath for uint256;
788     using SafeMathInt for int256;
789 
790     Map private tokenHoldersMap;
791     uint256 public lastProcessedIndex;
792 
793     mapping (address => bool) public excludedFromDividends;
794 
795     mapping (address => uint256) public lastClaimTimes;
796 
797     uint256 public claimWait;
798     uint256 public immutable minimumTokenBalanceForDividends;
799 
800     event ExcludeFromDividends(address indexed account);
801     event IncludeInDividends(address indexed account);
802     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
803 
804     event Claim(address indexed account, uint256 amt, bool indexed automatic);
805 
806     constructor() {
807     	claimWait = 1;
808         minimumTokenBalanceForDividends = 1;
809     }
810 
811     struct Map {
812         address[] keys;
813         mapping(address => uint) values;
814         mapping(address => uint) indexOf;
815         mapping(address => bool) inserted;
816     }
817 
818     function get(address key) private view returns (uint) {
819         return tokenHoldersMap.values[key];
820     }
821 
822     function getIndexOfKey(address key) private view returns (int) {
823         if(!tokenHoldersMap.inserted[key]) {
824             return -1;
825         }
826         return int(tokenHoldersMap.indexOf[key]);
827     }
828 
829     function getKeyAtIndex(uint index) private view returns (address) {
830         return tokenHoldersMap.keys[index];
831     }
832 
833 
834 
835     function size() private view returns (uint) {
836         return tokenHoldersMap.keys.length;
837     }
838 
839     function set(address key, uint val) private {
840         if (tokenHoldersMap.inserted[key]) {
841             tokenHoldersMap.values[key] = val;
842         } else {
843             tokenHoldersMap.inserted[key] = true;
844             tokenHoldersMap.values[key] = val;
845             tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
846             tokenHoldersMap.keys.push(key);
847         }
848     }
849 
850     function remove(address key) private {
851         if (!tokenHoldersMap.inserted[key]) {
852             return;
853         }
854 
855         delete tokenHoldersMap.inserted[key];
856         delete tokenHoldersMap.values[key];
857 
858         uint index = tokenHoldersMap.indexOf[key];
859         uint lastIndex = tokenHoldersMap.keys.length - 1;
860         address lastKey = tokenHoldersMap.keys[lastIndex];
861 
862         tokenHoldersMap.indexOf[lastKey] = index;
863         delete tokenHoldersMap.indexOf[key];
864 
865         tokenHoldersMap.keys[index] = lastKey;
866         tokenHoldersMap.keys.pop();
867     }
868 
869     function excludeFromDividends(address account) external onlyOwner {
870     	excludedFromDividends[account] = true;
871 
872     	_setBalance(account, 0);
873     	remove(account);
874 
875     	emit ExcludeFromDividends(account);
876     }
877     
878     function includeInDividends(address account) external onlyOwner {
879     	require(excludedFromDividends[account]);
880     	excludedFromDividends[account] = false;
881 
882     	emit IncludeInDividends(account);
883     }
884 
885     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
886         require(newClaimWait >= 1200 && newClaimWait <= 86400, "Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
887         require(newClaimWait != claimWait, "Dividend_Tracker: Cannot update claimWait to same value");
888         emit ClaimWaitUpdated(newClaimWait, claimWait);
889         claimWait = newClaimWait;
890     }
891 
892     function getLastProcessedIndex() external view returns(uint256) {
893     	return lastProcessedIndex;
894     }
895 
896     function getNumberOfTokenHolders() external view returns(uint256) {
897         return tokenHoldersMap.keys.length;
898     }
899 
900     function getAccount(address _account)
901         public view returns (
902             address account,
903             int256 index,
904             int256 iterationsUntilProcessed,
905             uint256 withdrawableDividends,
906             uint256 totalDividends,
907             uint256 lastClaimTime,
908             uint256 nextClaimTime,
909             uint256 secondsUntilAutoClaimAvailable) {
910         account = _account;
911 
912         index = getIndexOfKey(account);
913 
914         iterationsUntilProcessed = -1;
915 
916         if(index >= 0) {
917             if(uint256(index) > lastProcessedIndex) {
918                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
919             }
920             else {
921                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
922                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
923                                                         0;
924 
925 
926                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
927             }
928         }
929 
930 
931         withdrawableDividends = withdrawableDividendOf(account);
932         totalDividends = accumulativeDividendOf(account);
933 
934         lastClaimTime = lastClaimTimes[account];
935 
936         nextClaimTime = lastClaimTime > 0 ?
937                                     lastClaimTime.add(claimWait) :
938                                     0;
939 
940         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
941                                                     nextClaimTime.sub(block.timestamp) :
942                                                     0;
943     }
944 
945     function getAccountAtIndex(uint256 index)
946         public view returns (
947             address,
948             int256,
949             int256,
950             uint256,
951             uint256,
952             uint256,
953             uint256,
954             uint256) {
955     	if(index >= size()) {
956             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
957         }
958 
959         address account = getKeyAtIndex(index);
960 
961         return getAccount(account);
962     }
963 
964     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
965     	if(lastClaimTime > block.timestamp)  {
966     		return false;
967     	}
968 
969     	return block.timestamp.sub(lastClaimTime) >= claimWait;
970     }
971 
972     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
973     	if(excludedFromDividends[account]) {
974     		return;
975     	}
976 
977     	if(newBalance >= minimumTokenBalanceForDividends) {
978             _setBalance(account, newBalance);
979     		set(account, newBalance);
980     	}
981     	else {
982             _setBalance(account, 0);
983     		remove(account);
984     	}
985 
986     	processAccount(account, true);
987     }
988     
989     
990     function process(uint256 gas) public returns (uint256, uint256, uint256) {
991     	uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
992 
993     	if(numberOfTokenHolders == 0) {
994     		return (0, 0, lastProcessedIndex);
995     	}
996 
997     	uint256 _lastProcessedIndex = lastProcessedIndex;
998 
999     	uint256 gasUsed = 0;
1000 
1001     	uint256 gasLeft = gasleft();
1002 
1003     	uint256 iterations = 0;
1004     	uint256 claims = 0;
1005 
1006     	while(gasUsed < gas && iterations < numberOfTokenHolders) {
1007     		_lastProcessedIndex++;
1008 
1009     		if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1010     			_lastProcessedIndex = 0;
1011     		}
1012 
1013     		address account = tokenHoldersMap.keys[_lastProcessedIndex];
1014 
1015     		if(canAutoClaim(lastClaimTimes[account])) {
1016     			if(processAccount(payable(account), true)) {
1017     				claims++;
1018     			}
1019     		}
1020 
1021     		iterations++;
1022 
1023     		uint256 newGasLeft = gasleft();
1024 
1025     		if(gasLeft > newGasLeft) {
1026     			gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1027     		}
1028     		gasLeft = newGasLeft;
1029     	}
1030 
1031     	lastProcessedIndex = _lastProcessedIndex;
1032 
1033     	return (iterations, claims, lastProcessedIndex);
1034     }
1035 
1036     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1037         uint256 amt = _withdrawDividendOfUser(account);
1038 
1039     	if(amt > 0) {
1040     		lastClaimTimes[account] = block.timestamp;
1041             emit Claim(account, amt, automatic);
1042     		return true;
1043     	}
1044 
1045     	return false;
1046     }
1047 }
1048 
1049 interface IDexFactory {
1050     function createPair(address tokenA, address tokenB) external returns (address pair);
1051 }
1052 
1053 interface ILpPair {
1054     function sync() external;
1055 }
1056 
1057 contract EthRewards is ERC20, Ownable {
1058 
1059     uint256 public maxBuyAmt;
1060     uint256 public maxSellAmt;
1061     uint256 public maxWalletAmt;
1062 
1063     DividendTracker public dividendTracker;
1064 
1065     IDexRouter public immutable dexRouter;
1066     address public lpPair;
1067 
1068     IERC20 public REWARDTOKEN; 
1069     address public REWARDPAIRTOKEN;
1070 
1071     bool private swapping;
1072     uint256 public swapTokensAtAmt;
1073 
1074     address public marketingAddress;
1075 
1076     uint256 public tradingLiveBlock = 0; // 0 means trading is not active
1077     uint256 private blockForPenaltyEnd;
1078 
1079     bool public limitsActive = true;
1080     bool public tradingLive = false;
1081     bool public swapEnabled = false;
1082 
1083     uint256 public constant FEE_DIVISOR = 10000;
1084 
1085     uint256 public buyTotalTax;
1086     uint256 public buyLiquidityTax;
1087     uint256 public buyMarketingTax;
1088     uint256 public buyRewardTax;
1089 
1090     uint256 public sellTotalTax;
1091     uint256 public sellMarketingTax;
1092     uint256 public sellLiquidityTax;
1093     uint256 public sellRewardTax;
1094 
1095     uint256 public tokensForMarketing;
1096     uint256 public tokensForLiquidity;
1097     uint256 public tokensForReward;
1098     
1099     mapping (address => bool) private _isExcludedFromTax;
1100     mapping (address => bool) public _isExcludedMaxTransactionAmt;
1101 
1102     mapping (address => bool) public automatedMarketMakerPairs;
1103 
1104     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1105     event StartedTrading();
1106     event RemovedLimits();
1107     event ExcludeFromTax(address indexed account, bool isExcluded);
1108     event UpdatedMaxBuyAmt(uint256 newAmt);
1109     event UpdatedMaxSellAmt(uint256 newAmt);
1110     event UpdatedMaxWalletAmt(uint256 newAmt);
1111     event UpdatedBuyTax(uint256 newAmt);
1112     event UpdatedSellTax(uint256 newAmt);
1113     event UpdatedMarketingAddress(address indexed newWallet);
1114     event MaxTransactionExclusion(address _address, bool excluded);
1115     event OwnerForcedSwapBack(uint256 timestamp);
1116     event TransferForeignToken(address token, uint256 amt);
1117 
1118     constructor() ERC20("EtherFlex", "FLEX") payable {
1119 
1120         address _dexRouter;
1121 
1122         if(block.chainid == 1){
1123             _dexRouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Ethereum: Uniswap V2
1124         } else if(block.chainid == 56){
1125             _dexRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // PCS V2
1126         } else {
1127             revert("Chain not configured");
1128         }
1129 
1130         dividendTracker = new DividendTracker();
1131 
1132         address newOwner = msg.sender; // can leave alone if owner is deployer.
1133 
1134         dexRouter = IDexRouter(_dexRouter);
1135 
1136         uint256 totalSupply = 100000000 * 1e18;
1137         
1138         maxBuyAmt = totalSupply * 5 / 1000;
1139         maxSellAmt = totalSupply * 1/ 100;
1140         maxWalletAmt = totalSupply * 1 / 100;
1141         swapTokensAtAmt = totalSupply * 25 / 100000;
1142 
1143         buyMarketingTax = 1000;
1144         buyLiquidityTax = 0;
1145         buyRewardTax = 1000;
1146         buyTotalTax = buyMarketingTax + buyLiquidityTax + buyRewardTax;
1147 
1148         sellMarketingTax = 4000;
1149         sellLiquidityTax = 0;
1150         sellRewardTax = 4000;
1151         sellTotalTax = sellMarketingTax + sellLiquidityTax + sellRewardTax;
1152 
1153         // @dev update these!
1154         marketingAddress = address(msg.sender);
1155 
1156         // create pair
1157         lpPair = IDexFactory(dexRouter.factory()).createPair(address(this), dexRouter.WETH());
1158         _excludeFromMaxTransaction(address(lpPair), true);
1159         setAutomatedMarketMakerPair(address(lpPair), true);
1160 
1161         _excludeFromMaxTransaction(newOwner, true);
1162         _excludeFromMaxTransaction(address(this), true);
1163         _excludeFromMaxTransaction(address(dexRouter), true);
1164         _excludeFromMaxTransaction(address(0xdead), true);
1165         _excludeFromMaxTransaction(address(marketingAddress), true);
1166 
1167         // exclude from receiving dividends
1168         dividendTracker.excludeFromDividends(address(dividendTracker));
1169         dividendTracker.excludeFromDividends(address(this));
1170         dividendTracker.excludeFromDividends(address(dexRouter));
1171         dividendTracker.excludeFromDividends(newOwner);
1172         dividendTracker.excludeFromDividends(address(0xdead));
1173 
1174         excludeFromTax(newOwner, true);
1175         excludeFromTax(address(this), true);
1176         excludeFromTax(address(dexRouter), true);
1177         excludeFromTax(address(0xdead), true);
1178         excludeFromTax(address(marketingAddress), true);
1179 
1180         transferOwnership(newOwner);
1181 
1182         _approve(address(this), address(dexRouter), type(uint256).max);
1183 
1184         _createInitialSupply(address(this), totalSupply - balanceOf(newOwner));
1185     }
1186 
1187     // excludes wallets and contracts from dividends (such as CEX hotwallets, etc.)
1188     function excludeFromDividends(address account) external onlyOwner {
1189         dividendTracker.excludeFromDividends(account);
1190     }
1191 
1192     // removes exclusion on wallets and contracts from dividends (such as CEX hotwallets, etc.)
1193     function includeInDividends(address account) external onlyOwner {
1194         dividendTracker.includeInDividends(account);
1195     }
1196 
1197     // remove limits after token is stable
1198     function removeLimits() external onlyOwner {
1199         limitsActive = false;
1200         emit RemovedLimits();
1201     }
1202 
1203     function updateMaxBuyAmt(uint256 newNum) external onlyOwner {
1204         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set max sell amt lower than 1%");
1205         maxBuyAmt = newNum * (10**18);
1206         emit UpdatedMaxBuyAmt(maxBuyAmt);
1207     }
1208     
1209     function updateMaxSellAmt(uint256 newNum) external onlyOwner {
1210         require(newNum >= (totalSupply() * 1 / 100)/1e18, "Cannot set max sell amt lower than 1%");
1211         maxSellAmt = newNum * (10**18);
1212         emit UpdatedMaxSellAmt(maxSellAmt);
1213     }
1214 
1215     function removeMaxWallet() external onlyOwner {
1216         maxWalletAmt = totalSupply();
1217         emit UpdatedMaxWalletAmt(maxWalletAmt);
1218     }
1219 
1220     function updateSwapTokensAtAmt(uint256 newAmt) external onlyOwner {
1221   	    require(newAmt >= totalSupply() * 1 / 1000000, "Swap amt cannot be lower than 0.0001% total supply.");
1222   	    require(newAmt <= totalSupply() * 1 / 1000, "Swap amt cannot be higher than 0.1% total supply.");
1223   	    swapTokensAtAmt = newAmt;
1224   	}
1225     
1226     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
1227         _isExcludedMaxTransactionAmt[updAds] = isExcluded;
1228         emit MaxTransactionExclusion(updAds, isExcluded);
1229     }
1230 
1231     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInWei) external onlyOwner {
1232         require(wallets.length == amountsInWei.length, "arrays must be the same length");
1233         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits");
1234         for(uint256 i = 0; i < wallets.length; i++){
1235             super._transfer(msg.sender, wallets[i], amountsInWei[i]);
1236             dividendTracker.setBalance(payable(wallets[i]), balanceOf(wallets[i]));
1237         }
1238     }
1239     
1240     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
1241         if(!isEx){
1242             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
1243         }
1244         _isExcludedMaxTransactionAmt[updAds] = isEx;
1245     }
1246 
1247     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1248         require(pair != lpPair || value, "The pair cannot be removed from automatedMarketMakerPairs");
1249         automatedMarketMakerPairs[pair] = value;
1250         _excludeFromMaxTransaction(pair, value);
1251         if(value) {
1252             dividendTracker.excludeFromDividends(pair);
1253         }
1254         emit SetAutomatedMarketMakerPair(pair, value);
1255     }
1256 
1257     function updateBuyTax(uint256 _marketingTax, uint256 _liquidityTax, uint256 _rewardTax) external onlyOwner {
1258         buyMarketingTax = _marketingTax;
1259         buyLiquidityTax = _liquidityTax;
1260         buyRewardTax = _rewardTax;
1261         buyTotalTax = buyMarketingTax + buyLiquidityTax + buyRewardTax;
1262         require(buyTotalTax <= 1000, "Must keep tax at 10% or less");
1263         emit UpdatedBuyTax(buyTotalTax);
1264     }
1265 
1266     function updateSellTax(uint256 _marketingTax, uint256 _liquidityTax, uint256 _rewardTax) external onlyOwner {
1267         sellMarketingTax = _marketingTax;
1268         sellLiquidityTax = _liquidityTax;
1269         sellRewardTax = _rewardTax;
1270         sellTotalTax = sellMarketingTax + sellLiquidityTax + sellRewardTax;
1271         require(sellTotalTax <= 1000, "Must keep tax at 10% or less");
1272         emit UpdatedSellTax(sellTotalTax);
1273     }
1274 
1275     function excludeFromTax(address account, bool excluded) public onlyOwner {
1276         _isExcludedFromTax[account] = excluded;
1277         emit ExcludeFromTax(account, excluded);
1278     }
1279 
1280     function updateClaimWait(uint256 claimWait) external onlyOwner {
1281         dividendTracker.updateClaimWait(claimWait);
1282     }
1283 
1284     function getClaimWait() external view returns(uint256) {
1285         return dividendTracker.claimWait();
1286     }
1287 
1288     function getTotalDividendsDistributed() external view returns (uint256) {
1289         return dividendTracker.totalDividendsDistributed();
1290     }
1291 
1292     function withdrawableDividendOf(address account) public view returns(uint256) {
1293     	return dividendTracker.withdrawableDividendOf(account);
1294   	}
1295 
1296 	function dividendTokenBalanceOf(address account) public view returns (uint256) {
1297 		return dividendTracker.holderBalance(account);
1298 	}
1299 
1300     function getAccountDividendsInfo(address account)
1301         external view returns (
1302             address,
1303             int256,
1304             int256,
1305             uint256,
1306             uint256,
1307             uint256,
1308             uint256,
1309             uint256) {
1310         return dividendTracker.getAccount(account);
1311     }
1312 
1313 	function getAccountDividendsInfoAtIndex(uint256 index)
1314         external view returns (
1315             address,
1316             int256,
1317             int256,
1318             uint256,
1319             uint256,
1320             uint256,
1321             uint256,
1322             uint256) {
1323     	return dividendTracker.getAccountAtIndex(index);
1324     }
1325 
1326     function claim() external {
1327 		dividendTracker.processAccount(payable(msg.sender), false);
1328     }
1329 
1330     function getLastProcessedIndex() external view returns(uint256) {
1331     	return dividendTracker.getLastProcessedIndex();
1332     }
1333 
1334     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1335         return dividendTracker.getNumberOfTokenHolders();
1336     }
1337     
1338     function getNumberOfDividends() external view returns(uint256) {
1339         return dividendTracker.totalBalance();
1340     }
1341     
1342     function _transfer(address from, address to, uint256 amt) internal override {
1343 
1344         require(from != address(0), "ERC20: transfer from the zero address");
1345         require(to != address(0), "ERC20: transfer to the zero address");
1346         if(amt == 0){
1347             super._transfer(from, to, 0);
1348             return;
1349         }
1350         
1351         if(!tradingLive){
1352             require(_isExcludedFromTax[from] || _isExcludedFromTax[to], "Trading is not active.");
1353         }
1354 
1355         if(_isExcludedFromTax[from] || _isExcludedFromTax[to] || swapping){
1356             super._transfer(from, to, amt);
1357             dividendTracker.setBalance(payable(from), balanceOf(from));
1358             dividendTracker.setBalance(payable(to), balanceOf(to));
1359             return;
1360         }
1361         
1362         if(limitsActive){
1363             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromTax[from] && !_isExcludedFromTax[to]){
1364                 //when buy
1365                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmt[to]) {
1366                     require(amt <= maxBuyAmt, "Buy transfer amt exceeds the max buy.");
1367                     require(amt + balanceOf(to) <= maxWalletAmt, "Cannot Exceed max wallet");
1368                 } 
1369                 //when sell
1370                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmt[from]) {
1371                     require(amt <= maxSellAmt, "Sell transfer amt exceeds the max sell.");
1372                 } 
1373                 else if (!_isExcludedMaxTransactionAmt[to]){
1374                     require(amt + balanceOf(to) <= maxWalletAmt, "Cannot Exceed max wallet");
1375                 }
1376             }
1377         }
1378 
1379         uint256 contractTokenBalance = balanceOf(address(this));
1380         
1381         bool canSwap = contractTokenBalance >= swapTokensAtAmt;
1382 
1383         if(canSwap && swapEnabled && !swapping && automatedMarketMakerPairs[to]) {
1384             swapping = true;
1385             swapBack();
1386             swapping = false;
1387         }
1388 
1389         bool takeTax = true;
1390         // if any account belongs to _isExcludedFromTax account then remove the tax
1391         if(_isExcludedFromTax[from] || _isExcludedFromTax[to]) {
1392             takeTax = false;
1393         }
1394         
1395         uint256 tax = 0;
1396         // only take tax on buys/sells, do not take on wallet transfers
1397         if(takeTax){
1398 
1399             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && !_isExcludedFromTax[to] && buyTotalTax > 0){
1400                 tax = amt * 9900 / FEE_DIVISOR;
1401         	    tokensForLiquidity += tax * buyLiquidityTax / buyTotalTax;
1402                 tokensForMarketing += tax * buyMarketingTax / buyTotalTax;
1403                 tokensForReward += tax * buyRewardTax / buyTotalTax;
1404             }
1405             // on sell
1406             else if (automatedMarketMakerPairs[to] && sellTotalTax > 0){
1407                 tax = amt * sellTotalTax / FEE_DIVISOR;
1408                 tokensForLiquidity += tax * sellLiquidityTax / sellTotalTax;
1409                 tokensForMarketing += tax * sellMarketingTax / sellTotalTax;
1410                 tokensForReward += tax * sellRewardTax / sellTotalTax;
1411             }
1412             // on buy
1413             else if(automatedMarketMakerPairs[from] && buyTotalTax > 0) {
1414         	    tax = amt * buyTotalTax / FEE_DIVISOR;
1415         	    tokensForMarketing += tax * buyMarketingTax / buyTotalTax;
1416         	    tokensForLiquidity += tax * buyLiquidityTax / buyTotalTax;
1417                 tokensForReward += tax * buyRewardTax / buyTotalTax;
1418             }
1419             
1420             if(tax > 0){    
1421                 super._transfer(from, address(this), tax);
1422             }
1423         	
1424         	amt -= tax;
1425         }
1426 
1427         super._transfer(from, to, amt);
1428 
1429         dividendTracker.setBalance(payable(from), balanceOf(from));
1430         dividendTracker.setBalance(payable(to), balanceOf(to));
1431     }
1432 
1433     function swapTokenForETH(uint256 tokenAmt) private {
1434 
1435         // generate the uniswap pair path of token -> weth
1436         address[] memory path = new address[](2);
1437         path[0] = address(this);
1438         path[1] = dexRouter.WETH();
1439 
1440         // make the swap
1441         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1442             tokenAmt,
1443             0, // accept any amt of ETH
1444             path,
1445             address(this),
1446             block.timestamp
1447         );
1448     }
1449 
1450     function swapBack() private {
1451 
1452         uint256 contractBalance = balanceOf(address(this));
1453         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForReward;
1454         
1455         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1456 
1457         if(contractBalance > swapTokensAtAmt * 40){
1458             contractBalance = swapTokensAtAmt * 40;
1459         }
1460         
1461         if(tokensForLiquidity > 0){
1462             uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap;
1463             super._transfer(address(this), lpPair, liquidityTokens);
1464             try ILpPair(lpPair).sync(){} catch {}
1465             contractBalance -= liquidityTokens;
1466             totalTokensToSwap -= tokensForLiquidity;
1467             tokensForLiquidity = 0;
1468         }
1469         
1470         if(contractBalance > 0){
1471             bool success;
1472             swapTokenForETH(contractBalance);
1473             if(tokensForReward > 0){
1474                 uint256 rewardTokens = tokensForReward * address(this).balance / totalTokensToSwap;
1475                 (success,) = address(dividendTracker).call{value: rewardTokens}("");
1476             }
1477 
1478             if(tokensForMarketing > 0){
1479                 (success,) = address(marketingAddress).call{value: address(this).balance}("");
1480             }
1481 
1482             tokensForMarketing = 0;
1483             tokensForReward = 0;
1484         }
1485     }
1486 
1487     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1488         require(_marketingAddress != address(0), "address cannot be 0");
1489         marketingAddress = payable(_marketingAddress);
1490         emit UpdatedMarketingAddress(_marketingAddress);
1491     }
1492 
1493     // force Swap back if slippage issues.
1494     function forceSwapBack() external onlyOwner {
1495         require(balanceOf(address(this)) >= swapTokensAtAmt, "Can only swap when token amt is at or higher than restriction");
1496         swapping = true;
1497         swapBack();
1498         swapping = false;
1499         emit OwnerForcedSwapBack(block.timestamp);
1500     }
1501 
1502     function transferForeignToken(address _token, address _to) external onlyOwner {
1503         require(_token != address(0), "_token address cannot be 0");
1504         require(_token != address(this) || !tradingLive, "Can't withdraw native tokens");
1505         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1506         SafeERC20.safeTransfer(IERC20(_token),_to, _contractBalance);
1507         emit TransferForeignToken(_token, _contractBalance);
1508     }
1509     function enableTrading(uint256 blocksForPenalty) external onlyOwner {
1510         require(!tradingLive, "Trading is already active, cannot relaunch.");
1511         tradingLive = true;
1512         swapEnabled = true;
1513         tradingLiveBlock = block.number;
1514         blockForPenaltyEnd = tradingLiveBlock + blocksForPenalty;
1515     }
1516 
1517     function earlyBuyPenaltyInEffect() public view returns (bool){
1518         return block.number < blockForPenaltyEnd;
1519     }
1520 
1521     receive() external payable {}
1522 }