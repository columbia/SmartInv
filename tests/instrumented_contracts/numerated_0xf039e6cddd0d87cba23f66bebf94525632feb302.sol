1 pragma solidity ^0.6.12;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     /**
8      * @dev Returns the amount of tokens owned by `account`.
9      */
10     function balanceOf(address account) external view returns (uint256);
11 
12     /**
13      * @dev Moves `amount` tokens from the caller's account to `recipient`.
14      *
15      * Returns a boolean value indicating whether the operation succeeded.
16      *
17      * Emits a {Transfer} event.
18      */
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     /**
22      * @dev Returns the remaining number of tokens that `spender` will be
23      * allowed to spend on behalf of `owner` through {transferFrom}. This is
24      * zero by default.
25      *
26      * This value changes when {approve} or {transferFrom} are called.
27      */
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     /**
31      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * IMPORTANT: Beware that changing an allowance with this method brings the risk
36      * that someone may use both the old and the new allowance by unfortunate
37      * transaction ordering. One possible solution to mitigate this race
38      * condition is to first reduce the spender's allowance to 0 and set the
39      * desired value afterwards:
40      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
41      *
42      * Emits an {Approval} event.
43      */
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Moves `amount` tokens from `sender` to `recipient` using the
48      * allowance mechanism. `amount` is then deducted from the caller's
49      * allowance.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Emitted when `value` tokens are moved from one account (`from`) to
59      * another (`to`).
60      *
61      * Note that `value` may be zero.
62      */
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     /**
66      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
67      * a call to {approve}. `value` is the new allowance.
68      */
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 
73 
74 /**
75  * @dev Wrappers over Solidity's arithmetic operations with added overflow
76  * checks.
77  *
78  * Arithmetic operations in Solidity wrap on overflow. This can easily result
79  * in bugs, because programmers usually assume that an overflow raises an
80  * error, which is the standard behavior in high level programming languages.
81  * `SafeMath` restores this intuition by reverting the transaction when an
82  * operation overflows.
83  *
84  * Using this library instead of the unchecked operations eliminates an entire
85  * class of bugs, so it's recommended to use it always.
86  */
87 
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      *
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      *
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      *
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b != 0, errorMessage);
227         return a % b;
228     }
229 }
230 
231 abstract contract Context {
232     function _msgSender() internal view virtual returns (address payable) {
233         return msg.sender;
234     }
235 
236     function _msgData() internal view virtual returns (bytes memory) {
237         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
238         return msg.data;
239     }
240 }
241 
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return _functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         return _functionCallWithValue(target, data, value, errorMessage);
355     }
356 
357     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
362         if (success) {
363             return returndata;
364         } else {
365             // Look for revert reason and bubble it up if present
366             if (returndata.length > 0) {
367                 // The easiest way to bubble the revert reason is using memory via assembly
368 
369                 // solhint-disable-next-line no-inline-assembly
370                 assembly {
371                     let returndata_size := mload(returndata)
372                     revert(add(32, returndata), returndata_size)
373                 }
374             } else {
375                 revert(errorMessage);
376             }
377         }
378     }
379 }
380 
381 /**
382  * @dev Contract module which provides a basic access control mechanism, where
383  * there is an account (an owner) that can be granted exclusive access to
384  * specific functions.
385  *
386  * By default, the owner account will be the one that deploys the contract. This
387  * can later be changed with {transferOwnership}.
388  *
389  * This module is used through inheritance. It will make available the modifier
390  * `onlyOwner`, which can be applied to your functions to restrict their use to
391  * the owner.
392  */
393 contract Ownable is Context {
394     address private _owner;
395     address private _previousOwner;
396     uint256 private _lockTime;
397 
398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
399 
400     /**
401      * @dev Initializes the contract setting the deployer as the initial owner.
402      */
403     constructor () internal {
404         address msgSender = _msgSender();
405         _owner = msgSender;
406         emit OwnershipTransferred(address(0), msgSender);
407     }
408 
409     /**
410      * @dev Returns the address of the current owner.
411      */
412     function owner() public view returns (address) {
413         return _owner;
414     }
415 
416     /**
417      * @dev Throws if called by any account other than the owner.
418      */
419     modifier onlyOwner() {
420         require(_owner == _msgSender(), "Ownable: caller is not the owner");
421         _;
422     }
423 
424     /**
425     * @dev Leaves the contract without owner. It will not be possible to call
426     * `onlyOwner` functions anymore. Can only be called by the current owner.
427     *
428     * NOTE: Renouncing ownership will leave the contract without an owner,
429     * thereby removing any functionality that is only available to the owner.
430     */
431     function renounceOwnership() public virtual onlyOwner {
432         emit OwnershipTransferred(_owner, address(0));
433         _owner = address(0);
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         emit OwnershipTransferred(_owner, newOwner);
443         _owner = newOwner;
444     }
445 
446     function geUnlockTime() public view returns (uint256) {
447         return _lockTime;
448     }
449 
450     //Locks the contract for owner for the amount of time provided
451     function lock(uint256 time) public virtual onlyOwner {
452         _previousOwner = _owner;
453         _owner = address(0);
454         _lockTime = now + time;
455         emit OwnershipTransferred(_owner, address(0));
456     }
457 
458     //Unlocks the contract for owner when _lockTime is exceeds
459     function unlock() public virtual {
460         require(_previousOwner == msg.sender, "You don't have permission to unlock");
461         require(now > _lockTime , "Contract is locked until 7 days");
462         emit OwnershipTransferred(_owner, _previousOwner);
463         _owner = _previousOwner;
464     }
465 }
466 
467 contract DEFToken is Context, IERC20, Ownable {
468     using SafeMath for uint256;
469     using Address for address;
470 
471     address public liquidityHolder;
472 
473     mapping (address => uint256) private _rOwned;
474     mapping (address => uint256) private _tOwned;
475     mapping (address => mapping (address => uint256)) private _allowances;
476 
477     mapping (address => bool) private _isExcludedFromFee;
478 
479     mapping (address => bool) private _isExcluded;
480     address[] private _excluded;
481 
482     uint256 private constant MAX = ~uint256(0);
483     uint256 private _tTotal = 1000 * 10**6 * 10**18;
484     uint256 private _rTotal = (MAX - (MAX % _tTotal));
485     uint256 private _tFeeTotal;
486 
487     string private _name = "DEF Token";
488     string private _symbol = "DEF";
489     uint8 private _decimals = 18;
490 
491     uint256 public _taxFee = 2;
492     uint256 private _previousTaxFee = _taxFee;
493 
494     uint256 public _liquidityFee = 3;
495     uint256 private _previousLiquidityFee = _liquidityFee;
496 
497     constructor (address _liquidityHolder) public {
498         liquidityHolder = _liquidityHolder;
499         _rOwned[_msgSender()] = _rTotal;
500         emit Transfer(address(0), _msgSender(), _tTotal);
501     }
502 
503     function name() public view returns (string memory) {
504         return _name;
505     }
506 
507     function symbol() public view returns (string memory) {
508         return _symbol;
509     }
510 
511     function decimals() public view returns (uint8) {
512         return _decimals;
513     }
514 
515     function totalSupply() public view override returns (uint256) {
516         return _tTotal;
517     }
518 
519     function balanceOf(address account) public view override returns (uint256) {
520         if (_isExcluded[account]) return _tOwned[account];
521         return tokenFromReflection(_rOwned[account]);
522     }
523 
524     function transfer(address recipient, uint256 amount) public override returns (bool) {
525         _transfer(_msgSender(), recipient, amount);
526         return true;
527     }
528 
529     function allowance(address owner, address spender) public view override returns (uint256) {
530         return _allowances[owner][spender];
531     }
532 
533     function approve(address spender, uint256 amount) public override returns (bool) {
534         _approve(_msgSender(), spender, amount);
535         return true;
536     }
537 
538     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
539         _transfer(sender, recipient, amount);
540         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
541         return true;
542     }
543 
544     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
545         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
546         return true;
547     }
548 
549     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
550         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
551         return true;
552     }
553 
554     function isExcludedFromReward(address account) public view returns (bool) {
555         return _isExcluded[account];
556     }
557 
558     function totalFees() public view returns (uint256) {
559         return _tFeeTotal;
560     }
561 
562     function deliver(uint256 tAmount) public {
563         address sender = _msgSender();
564         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
565         (uint256 rAmount,,,,,) = _getValues(tAmount);
566         _rOwned[sender] = _rOwned[sender].sub(rAmount);
567         _rTotal = _rTotal.sub(rAmount);
568         _tFeeTotal = _tFeeTotal.add(tAmount);
569     }
570 
571     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
572         require(tAmount <= _tTotal, "Amount must be less than supply");
573         if (!deductTransferFee) {
574             (uint256 rAmount,,,,,) = _getValues(tAmount);
575             return rAmount;
576         } else {
577             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
578             return rTransferAmount;
579         }
580     }
581 
582     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
583         require(rAmount <= _rTotal, "Amount must be less than total reflections");
584         uint256 currentRate =  _getRate();
585         return rAmount.div(currentRate);
586     }
587 
588     function excludeFromReward(address account) public onlyOwner() {
589         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
590         require(!_isExcluded[account], "Account is already excluded");
591         if(_rOwned[account] > 0) {
592             _tOwned[account] = tokenFromReflection(_rOwned[account]);
593         }
594         _isExcluded[account] = true;
595         _excluded.push(account);
596     }
597 
598     function includeInReward(address account) external onlyOwner() {
599         require(_isExcluded[account], "Account is already excluded");
600         for (uint256 i = 0; i < _excluded.length; i++) {
601             if (_excluded[i] == account) {
602                 _excluded[i] = _excluded[_excluded.length - 1];
603                 _tOwned[account] = 0;
604                 _isExcluded[account] = false;
605                 _excluded.pop();
606                 break;
607             }
608         }
609     }
610     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
611         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
612         _tOwned[sender] = _tOwned[sender].sub(tAmount);
613         _rOwned[sender] = _rOwned[sender].sub(rAmount);
614         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
615         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
616         _takeLiquidity(tLiquidity);
617         _reflectFee(rFee, tFee);
618         emit Transfer(sender, recipient, tTransferAmount);
619     }
620 
621     function excludeFromFee(address account) public onlyOwner {
622         _isExcludedFromFee[account] = true;
623     }
624 
625     function includeInFee(address account) public onlyOwner {
626         _isExcludedFromFee[account] = false;
627     }
628 
629     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
630         _taxFee = taxFee;
631     }
632 
633     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
634         _liquidityFee = liquidityFee;
635     }
636 
637     function _reflectFee(uint256 rFee, uint256 tFee) private {
638         _rTotal = _rTotal.sub(rFee);
639         _tFeeTotal = _tFeeTotal.add(tFee);
640     }
641 
642     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
643         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
644         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
645         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
646     }
647 
648     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
649         uint256 tFee = calculateTaxFee(tAmount);
650         uint256 tLiquidity = calculateLiquidityFee(tAmount);
651         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
652         return (tTransferAmount, tFee, tLiquidity);
653     }
654 
655     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
656         uint256 rAmount = tAmount.mul(currentRate);
657         uint256 rFee = tFee.mul(currentRate);
658         uint256 rLiquidity = tLiquidity.mul(currentRate);
659         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
660         return (rAmount, rTransferAmount, rFee);
661     }
662 
663     function _getRate() private view returns(uint256) {
664         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
665         return rSupply.div(tSupply);
666     }
667 
668     function _getCurrentSupply() private view returns(uint256, uint256) {
669         uint256 rSupply = _rTotal;
670         uint256 tSupply = _tTotal;
671         for (uint256 i = 0; i < _excluded.length; i++) {
672             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
673             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
674             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
675         }
676         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
677         return (rSupply, tSupply);
678     }
679 
680     function _takeLiquidity(uint256 tLiquidity) private {
681         uint256 currentRate =  _getRate();
682         uint256 rLiquidity = tLiquidity.mul(currentRate);
683         _rOwned[liquidityHolder] = _rOwned[liquidityHolder].add(rLiquidity);
684         if(_isExcluded[liquidityHolder])
685             _tOwned[liquidityHolder] = _tOwned[liquidityHolder].add(tLiquidity);
686     }
687 
688     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
689         return _amount.mul(_taxFee).div(
690             10**2
691         );
692     }
693 
694     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
695         return _amount.mul(_liquidityFee).div(
696             10**2
697         );
698     }
699 
700     function removeAllFee() private {
701         if(_taxFee == 0 && _liquidityFee == 0) return;
702 
703         _previousTaxFee = _taxFee;
704         _previousLiquidityFee = _liquidityFee;
705 
706         _taxFee = 0;
707         _liquidityFee = 0;
708     }
709 
710     function restoreAllFee() private {
711         _taxFee = _previousTaxFee;
712         _liquidityFee = _previousLiquidityFee;
713     }
714 
715     function isExcludedFromFee(address account) public view returns(bool) {
716         return _isExcludedFromFee[account];
717     }
718 
719     function _approve(address owner, address spender, uint256 amount) private {
720         require(owner != address(0), "ERC20: approve from the zero address");
721         require(spender != address(0), "ERC20: approve to the zero address");
722 
723         _allowances[owner][spender] = amount;
724         emit Approval(owner, spender, amount);
725     }
726 
727     function _transfer(
728         address from,
729         address to,
730         uint256 amount
731     ) private {
732         require(from != address(0), "ERC20: transfer from the zero address");
733         require(to != address(0), "ERC20: transfer to the zero address");
734         require(amount > 0, "Transfer amount must be greater than zero");
735         //        if(from != owner() && to != owner())
736         //            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
737 
738         // is the token balance of this contract address over the min number of
739         // tokens that we need to initiate a swap + liquidity lock?
740         // also, don't get caught in a circular liquidity event.
741         // also, don't swap & liquify if sender is uniswap pair.
742 
743         //indicates if fee should be deducted from transfer
744         bool takeFee = false;
745 
746         //if any account belongs to _isExcludedFromFee account then remove the fee
747         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
748             takeFee = true;
749         }
750 
751         //transfer amount, it will take tax, burn, liquidity fee
752         _tokenTransfer(from,to,amount,takeFee);
753     }
754 
755     //this method is responsible for taking all fee, if takeFee is true
756     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
757         if(!takeFee)
758             removeAllFee();
759 
760         if (_isExcluded[sender] && !_isExcluded[recipient]) {
761             _transferFromExcluded(sender, recipient, amount);
762         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
763             _transferToExcluded(sender, recipient, amount);
764         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
765             _transferStandard(sender, recipient, amount);
766         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
767             _transferBothExcluded(sender, recipient, amount);
768         } else {
769             _transferStandard(sender, recipient, amount);
770         }
771 
772         if(!takeFee)
773             restoreAllFee();
774     }
775 
776     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
777         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
778         _rOwned[sender] = _rOwned[sender].sub(rAmount);
779         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
780         _takeLiquidity(tLiquidity);
781         _reflectFee(rFee, tFee);
782         emit Transfer(sender, recipient, tTransferAmount);
783     }
784 
785     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
786         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
787         _rOwned[sender] = _rOwned[sender].sub(rAmount);
788         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
789         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
790         _takeLiquidity(tLiquidity);
791         _reflectFee(rFee, tFee);
792         emit Transfer(sender, recipient, tTransferAmount);
793     }
794 
795     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
796         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
797         _tOwned[sender] = _tOwned[sender].sub(tAmount);
798         _rOwned[sender] = _rOwned[sender].sub(rAmount);
799         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
800         _takeLiquidity(tLiquidity);
801         _reflectFee(rFee, tFee);
802         emit Transfer(sender, recipient, tTransferAmount);
803     }
804 }