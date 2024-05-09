1 /**
2     Doge of Woof Street - $WSDOGE
3     
4     Total supply: 100 000 000 000 000 $WSDOGE
5     Liquidity: 35%
6     Burned: 50%
7     Marketing: 5%
8     Initial Liquidity Offering: 10%
9 
10     For more details, Make sure to check :
11 
12     Website — www.doge-of-woof-street.com
13 
14     Twitter — www.twitter.com/wsdoge1
15 
16     TG Group — https://t.me/dogeofwoofstreet
17 */
18 
19 // SPDX-License-Identifier: Unlicensed
20 
21 pragma solidity ^0.6.12;
22 
23 abstract contract Context {
24   function _msgSender() internal view virtual returns (address payable) {
25     return msg.sender;
26   }
27 
28   function _msgData() internal view virtual returns (bytes memory) {
29     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30     return msg.data;
31   }
32 }
33 
34 interface IERC20 {
35   /**
36    * @dev Returns the amount of tokens in existence.
37    */
38   function totalSupply() external view returns (uint256);
39 
40   /**
41    * @dev Returns the amount of tokens owned by `account`.
42    */
43   function balanceOf(address account) external view returns (uint256);
44 
45   /**
46    * @dev Moves `amount` tokens from the caller's account to `recipient`.
47    *
48    * Returns a boolean value indicating whether the operation succeeded.
49    *
50    * Emits a {Transfer} event.
51    */
52   function transfer(address recipient, uint256 amount) external returns (bool);
53 
54   /**
55    * @dev Returns the remaining number of tokens that `spender` will be
56    * allowed to spend on behalf of `owner` through {transferFrom}. This is
57    * zero by default.
58    *
59    * This value changes when {approve} or {transferFrom} are called.
60    */
61   function allowance(address owner, address spender)
62     external
63     view
64     returns (uint256);
65 
66   /**
67    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68    *
69    * Returns a boolean value indicating whether the operation succeeded.
70    *
71    * IMPORTANT: Beware that changing an allowance with this method brings the risk
72    * that someone may use both the old and the new allowance by unfortunate
73    * transaction ordering. One possible solution to mitigate this race
74    * condition is to first reduce the spender's allowance to 0 and set the
75    * desired value afterwards:
76    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77    *
78    * Emits an {Approval} event.
79    */
80   function approve(address spender, uint256 amount) external returns (bool);
81 
82   /**
83    * @dev Moves `amount` tokens from `sender` to `recipient` using the
84    * allowance mechanism. `amount` is then deducted from the caller's
85    * allowance.
86    *
87    * Returns a boolean value indicating whether the operation succeeded.
88    *
89    * Emits a {Transfer} event.
90    */
91   function transferFrom(
92     address sender,
93     address recipient,
94     uint256 amount
95   ) external returns (bool);
96 
97   /**
98    * @dev Emitted when `value` tokens are moved from one account (`from`) to
99    * another (`to`).
100    *
101    * Note that `value` may be zero.
102    */
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 
105   /**
106    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107    * a call to {approve}. `value` is the new allowance.
108    */
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 library SafeMath {
113   /**
114    * @dev Returns the addition of two unsigned integers, reverting on
115    * overflow.
116    *
117    * Counterpart to Solidity's `+` operator.
118    *
119    * Requirements:
120    *
121    * - Addition cannot overflow.
122    */
123   function add(uint256 a, uint256 b) internal pure returns (uint256) {
124     uint256 c = a + b;
125     require(c >= a, 'SafeMath: addition overflow');
126 
127     return c;
128   }
129 
130   /**
131    * @dev Returns the subtraction of two unsigned integers, reverting on
132    * overflow (when the result is negative).
133    *
134    * Counterpart to Solidity's `-` operator.
135    *
136    * Requirements:
137    *
138    * - Subtraction cannot overflow.
139    */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     return sub(a, b, 'SafeMath: subtraction overflow');
142   }
143 
144   /**
145    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146    * overflow (when the result is negative).
147    *
148    * Counterpart to Solidity's `-` operator.
149    *
150    * Requirements:
151    *
152    * - Subtraction cannot overflow.
153    */
154   function sub(
155     uint256 a,
156     uint256 b,
157     string memory errorMessage
158   ) internal pure returns (uint256) {
159     require(b <= a, errorMessage);
160     uint256 c = a - b;
161 
162     return c;
163   }
164 
165   /**
166    * @dev Returns the multiplication of two unsigned integers, reverting on
167    * overflow.
168    *
169    * Counterpart to Solidity's `*` operator.
170    *
171    * Requirements:
172    *
173    * - Multiplication cannot overflow.
174    */
175   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177     // benefit is lost if 'b' is also tested.
178     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179     if (a == 0) {
180       return 0;
181     }
182 
183     uint256 c = a * b;
184     require(c / a == b, 'SafeMath: multiplication overflow');
185 
186     return c;
187   }
188 
189   /**
190    * @dev Returns the integer division of two unsigned integers. Reverts on
191    * division by zero. The result is rounded towards zero.
192    *
193    * Counterpart to Solidity's `/` operator. Note: this function uses a
194    * `revert` opcode (which leaves remaining gas untouched) while Solidity
195    * uses an invalid opcode to revert (consuming all remaining gas).
196    *
197    * Requirements:
198    *
199    * - The divisor cannot be zero.
200    */
201   function div(uint256 a, uint256 b) internal pure returns (uint256) {
202     return div(a, b, 'SafeMath: division by zero');
203   }
204 
205   /**
206    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207    * division by zero. The result is rounded towards zero.
208    *
209    * Counterpart to Solidity's `/` operator. Note: this function uses a
210    * `revert` opcode (which leaves remaining gas untouched) while Solidity
211    * uses an invalid opcode to revert (consuming all remaining gas).
212    *
213    * Requirements:
214    *
215    * - The divisor cannot be zero.
216    */
217   function div(
218     uint256 a,
219     uint256 b,
220     string memory errorMessage
221   ) internal pure returns (uint256) {
222     require(b > 0, errorMessage);
223     uint256 c = a / b;
224     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226     return c;
227   }
228 
229   /**
230    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231    * Reverts when dividing by zero.
232    *
233    * Counterpart to Solidity's `%` operator. This function uses a `revert`
234    * opcode (which leaves remaining gas untouched) while Solidity uses an
235    * invalid opcode to revert (consuming all remaining gas).
236    *
237    * Requirements:
238    *
239    * - The divisor cannot be zero.
240    */
241   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
242     return mod(a, b, 'SafeMath: modulo by zero');
243   }
244 
245   /**
246    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247    * Reverts with custom message when dividing by zero.
248    *
249    * Counterpart to Solidity's `%` operator. This function uses a `revert`
250    * opcode (which leaves remaining gas untouched) while Solidity uses an
251    * invalid opcode to revert (consuming all remaining gas).
252    *
253    * Requirements:
254    *
255    * - The divisor cannot be zero.
256    */
257   function mod(
258     uint256 a,
259     uint256 b,
260     string memory errorMessage
261   ) internal pure returns (uint256) {
262     require(b != 0, errorMessage);
263     return a % b;
264   }
265 }
266 
267 library Address {
268   /**
269    * @dev Returns true if `account` is a contract.
270    *
271    * [IMPORTANT]
272    * ====
273    * It is unsafe to assume that an address for which this function returns
274    * false is an externally-owned account (EOA) and not a contract.
275    *
276    * Among others, `isContract` will return false for the following
277    * types of addresses:
278    *
279    *  - an externally-owned account
280    *  - a contract in construction
281    *  - an address where a contract will be created
282    *  - an address where a contract lived, but was destroyed
283    * ====
284    */
285   function isContract(address account) internal view returns (bool) {
286     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288     // for accounts without code, i.e. `keccak256('')`
289     bytes32 codehash;
290     bytes32 accountHash =
291       0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292     // solhint-disable-next-line no-inline-assembly
293     assembly {
294       codehash := extcodehash(account)
295     }
296     return (codehash != accountHash && codehash != 0x0);
297   }
298 
299   /**
300    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301    * `recipient`, forwarding all available gas and reverting on errors.
302    *
303    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304    * of certain opcodes, possibly making contracts go over the 2300 gas limit
305    * imposed by `transfer`, making them unable to receive funds via
306    * `transfer`. {sendValue} removes this limitation.
307    *
308    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309    *
310    * IMPORTANT: because control is transferred to `recipient`, care must be
311    * taken to not create reentrancy vulnerabilities. Consider using
312    * {ReentrancyGuard} or the
313    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314    */
315   function sendValue(address payable recipient, uint256 amount) internal {
316     require(address(this).balance >= amount, 'Address: insufficient balance');
317 
318     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
319     (bool success, ) = recipient.call{value: amount}('');
320     require(
321       success,
322       'Address: unable to send value, recipient may have reverted'
323     );
324   }
325 
326   /**
327    * @dev Performs a Solidity function call using a low level `call`. A
328    * plain`call` is an unsafe replacement for a function call: use this
329    * function instead.
330    *
331    * If `target` reverts with a revert reason, it is bubbled up by this
332    * function (like regular Solidity function calls).
333    *
334    * Returns the raw returned data. To convert to the expected return value,
335    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336    *
337    * Requirements:
338    *
339    * - `target` must be a contract.
340    * - calling `target` with `data` must not revert.
341    *
342    * _Available since v3.1._
343    */
344   function functionCall(address target, bytes memory data)
345     internal
346     returns (bytes memory)
347   {
348     return functionCall(target, data, 'Address: low-level call failed');
349   }
350 
351   /**
352    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353    * `errorMessage` as a fallback revert reason when `target` reverts.
354    *
355    * _Available since v3.1._
356    */
357   function functionCall(
358     address target,
359     bytes memory data,
360     string memory errorMessage
361   ) internal returns (bytes memory) {
362     return _functionCallWithValue(target, data, 0, errorMessage);
363   }
364 
365   /**
366    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367    * but also transferring `value` wei to `target`.
368    *
369    * Requirements:
370    *
371    * - the calling contract must have an ETH balance of at least `value`.
372    * - the called Solidity function must be `payable`.
373    *
374    * _Available since v3.1._
375    */
376   function functionCallWithValue(
377     address target,
378     bytes memory data,
379     uint256 value
380   ) internal returns (bytes memory) {
381     return
382       functionCallWithValue(
383         target,
384         data,
385         value,
386         'Address: low-level call with value failed'
387       );
388   }
389 
390   /**
391    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
392    * with `errorMessage` as a fallback revert reason when `target` reverts.
393    *
394    * _Available since v3.1._
395    */
396   function functionCallWithValue(
397     address target,
398     bytes memory data,
399     uint256 value,
400     string memory errorMessage
401   ) internal returns (bytes memory) {
402     require(
403       address(this).balance >= value,
404       'Address: insufficient balance for call'
405     );
406     return _functionCallWithValue(target, data, value, errorMessage);
407   }
408 
409   function _functionCallWithValue(
410     address target,
411     bytes memory data,
412     uint256 weiValue,
413     string memory errorMessage
414   ) private returns (bytes memory) {
415     require(isContract(target), 'Address: call to non-contract');
416 
417     // solhint-disable-next-line avoid-low-level-calls
418     (bool success, bytes memory returndata) =
419       target.call{value: weiValue}(data);
420     if (success) {
421       return returndata;
422     } else {
423       // Look for revert reason and bubble it up if present
424       if (returndata.length > 0) {
425         // The easiest way to bubble the revert reason is using memory via assembly
426 
427         // solhint-disable-next-line no-inline-assembly
428         assembly {
429           let returndata_size := mload(returndata)
430           revert(add(32, returndata), returndata_size)
431         }
432       } else {
433         revert(errorMessage);
434       }
435     }
436   }
437 }
438 
439 contract Ownable is Context {
440   address private _owner;
441 
442   event OwnershipTransferred(
443     address indexed previousOwner,
444     address indexed newOwner
445   );
446 
447   /**
448    * @dev Initializes the contract setting the deployer as the initial owner.
449    */
450   constructor() internal {
451     address msgSender = _msgSender();
452     _owner = msgSender;
453     emit OwnershipTransferred(address(0), msgSender);
454   }
455 
456   /**
457    * @dev Returns the address of the current owner.
458    */
459   function owner() public view returns (address) {
460     return _owner;
461   }
462 
463   /**
464    * @dev Throws if called by any account other than the owner.
465    */
466   modifier onlyOwner() {
467     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
468     _;
469   }
470 
471   /**
472    * @dev Leaves the contract without owner. It will not be possible to call
473    * `onlyOwner` functions anymore. Can only be called by the current owner.
474    *
475    * NOTE: Renouncing ownership will leave the contract without an owner,
476    * thereby removing any functionality that is only available to the owner.
477    */
478   function renounceOwnership() public virtual onlyOwner {
479     emit OwnershipTransferred(_owner, address(0));
480     _owner = address(0);
481   }
482 
483   /**
484    * @dev Transfers ownership of the contract to a new account (`newOwner`).
485    * Can only be called by the current owner.
486    */
487   function transferOwnership(address newOwner) public virtual onlyOwner {
488     require(newOwner != address(0), 'Ownable: new owner is the zero address');
489     emit OwnershipTransferred(_owner, newOwner);
490     _owner = newOwner;
491   }
492 }
493 
494 contract WSDOGEToken is Context, IERC20, Ownable {
495   using SafeMath for uint256;
496   using Address for address;
497 
498   mapping(address => uint256) private _rOwned;
499   mapping(address => uint256) private _tOwned;
500   mapping(address => mapping(address => uint256)) private _allowances;
501 
502   mapping(address => bool) private _isExcluded;
503   address[] private _excluded;
504 
505   uint256 private constant MAX = ~uint256(0);
506   uint256 private constant _tTotal = 100000000 * 10**6 * 10**9;
507   uint256 private _rTotal = (MAX - (MAX % _tTotal));
508   uint256 private _tFeeTotal;
509 
510   string private _name = 'Doge of Woof Street';
511   string private _symbol = 'WSDOGE';
512   uint8 private _decimals = 9;
513 
514   uint256 public _maxTxAmount = 300000 * 10**6 * 10**9;
515 
516   constructor() public {
517     _rOwned[_msgSender()] = _rTotal;
518     emit Transfer(address(0), _msgSender(), _tTotal);
519   }
520 
521   function name() public view returns (string memory) {
522     return _name;
523   }
524 
525   function symbol() public view returns (string memory) {
526     return _symbol;
527   }
528 
529   function decimals() public view returns (uint8) {
530     return _decimals;
531   }
532 
533   function totalSupply() public view override returns (uint256) {
534     return _tTotal;
535   }
536 
537   function balanceOf(address account) public view override returns (uint256) {
538     if (_isExcluded[account]) return _tOwned[account];
539     return tokenFromReflection(_rOwned[account]);
540   }
541 
542   function transfer(address recipient, uint256 amount)
543     public
544     override
545     returns (bool)
546   {
547     _transfer(_msgSender(), recipient, amount);
548     return true;
549   }
550 
551   function allowance(address owner, address spender)
552     public
553     view
554     override
555     returns (uint256)
556   {
557     return _allowances[owner][spender];
558   }
559 
560   function approve(address spender, uint256 amount)
561     public
562     override
563     returns (bool)
564   {
565     _approve(_msgSender(), spender, amount);
566     return true;
567   }
568 
569   function transferFrom(
570     address sender,
571     address recipient,
572     uint256 amount
573   ) public override returns (bool) {
574     _transfer(sender, recipient, amount);
575     _approve(
576       sender,
577       _msgSender(),
578       _allowances[sender][_msgSender()].sub(
579         amount,
580         'ERC20: transfer amount exceeds allowance'
581       )
582     );
583     return true;
584   }
585 
586   function increaseAllowance(address spender, uint256 addedValue)
587     public
588     virtual
589     returns (bool)
590   {
591     _approve(
592       _msgSender(),
593       spender,
594       _allowances[_msgSender()][spender].add(addedValue)
595     );
596     return true;
597   }
598 
599   function decreaseAllowance(address spender, uint256 subtractedValue)
600     public
601     virtual
602     returns (bool)
603   {
604     _approve(
605       _msgSender(),
606       spender,
607       _allowances[_msgSender()][spender].sub(
608         subtractedValue,
609         'ERC20: decreased allowance below zero'
610       )
611     );
612     return true;
613   }
614 
615   function isExcluded(address account) public view returns (bool) {
616     return _isExcluded[account];
617   }
618 
619   function totalFees() public view returns (uint256) {
620     return _tFeeTotal;
621   }
622 
623   function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
624     _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
625   }
626 
627   function rescueFromContract() external onlyOwner {
628     address payable _owner = _msgSender();
629     _owner.transfer(address(this).balance);
630   }
631 
632   function reflect(uint256 tAmount) public {
633     address sender = _msgSender();
634     require(
635       !_isExcluded[sender],
636       'Excluded addresses cannot call this function'
637     );
638     (uint256 rAmount, , , , ) = _getValues(tAmount);
639     _rOwned[sender] = _rOwned[sender].sub(rAmount);
640     _rTotal = _rTotal.sub(rAmount);
641     _tFeeTotal = _tFeeTotal.add(tAmount);
642   }
643 
644   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
645     public
646     view
647     returns (uint256)
648   {
649     require(tAmount <= _tTotal, 'Amount must be less than supply');
650     if (!deductTransferFee) {
651       (uint256 rAmount, , , , ) = _getValues(tAmount);
652       return rAmount;
653     } else {
654       (, uint256 rTransferAmount, , , ) = _getValues(tAmount);
655       return rTransferAmount;
656     }
657   }
658 
659   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
660     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
661     uint256 currentRate = _getRate();
662     return rAmount.div(currentRate);
663   }
664 
665   function excludeAccount(address account) external onlyOwner() {
666     require(!_isExcluded[account], 'Account is already excluded');
667     if (_rOwned[account] > 0) {
668       _tOwned[account] = tokenFromReflection(_rOwned[account]);
669     }
670     _isExcluded[account] = true;
671     _excluded.push(account);
672   }
673 
674   function includeAccount(address account) external onlyOwner() {
675     require(_isExcluded[account], 'Account is already excluded');
676     for (uint256 i = 0; i < _excluded.length; i++) {
677       if (_excluded[i] == account) {
678         _excluded[i] = _excluded[_excluded.length - 1];
679         _tOwned[account] = 0;
680         _isExcluded[account] = false;
681         _excluded.pop();
682         break;
683       }
684     }
685   }
686 
687   function _approve(
688     address owner,
689     address spender,
690     uint256 amount
691   ) private {
692     require(owner != address(0), 'ERC20: approve from the zero address');
693     require(spender != address(0), 'ERC20: approve to the zero address');
694 
695     _allowances[owner][spender] = amount;
696     emit Approval(owner, spender, amount);
697   }
698 
699   function _transfer(
700     address sender,
701     address recipient,
702     uint256 amount
703   ) private {
704     require(sender != address(0), 'ERC20: transfer from the zero address');
705     require(recipient != address(0), 'ERC20: transfer to the zero address');
706     require(amount > 0, 'Transfer amount must be greater than zero');
707     if (sender != owner() && recipient != owner()) {
708       require(
709         amount <= _maxTxAmount,
710         'Transfer amount exceeds the maxTxAmount.'
711       );
712       require(!_isExcluded[sender], 'Account is excluded');
713     }
714 
715     if (_isExcluded[sender] && !_isExcluded[recipient]) {
716       _transferFromExcluded(sender, recipient, amount);
717     } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
718       _transferToExcluded(sender, recipient, amount);
719     } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
720       _transferStandard(sender, recipient, amount);
721     } else if (_isExcluded[sender] && _isExcluded[recipient]) {
722       _transferBothExcluded(sender, recipient, amount);
723     } else {
724       _transferStandard(sender, recipient, amount);
725     }
726   }
727 
728   function _transferStandard(
729     address sender,
730     address recipient,
731     uint256 tAmount
732   ) private {
733     (
734       uint256 rAmount,
735       uint256 rTransferAmount,
736       uint256 rFee,
737       uint256 tTransferAmount,
738       uint256 tFee
739     ) = _getValues(tAmount);
740     _rOwned[sender] = _rOwned[sender].sub(rAmount);
741     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
742     _reflectFee(rFee, tFee);
743     emit Transfer(sender, recipient, tTransferAmount);
744   }
745 
746   function _transferToExcluded(
747     address sender,
748     address recipient,
749     uint256 tAmount
750   ) private {
751     (
752       uint256 rAmount,
753       uint256 rTransferAmount,
754       uint256 rFee,
755       uint256 tTransferAmount,
756       uint256 tFee
757     ) = _getValues(tAmount);
758     _rOwned[sender] = _rOwned[sender].sub(rAmount);
759     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
760     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
761     _reflectFee(rFee, tFee);
762     emit Transfer(sender, recipient, tTransferAmount);
763   }
764 
765   function _transferFromExcluded(
766     address sender,
767     address recipient,
768     uint256 tAmount
769   ) private {
770     (
771       uint256 rAmount,
772       uint256 rTransferAmount,
773       uint256 rFee,
774       uint256 tTransferAmount,
775       uint256 tFee
776     ) = _getValues(tAmount);
777     _tOwned[sender] = _tOwned[sender].sub(tAmount);
778     _rOwned[sender] = _rOwned[sender].sub(rAmount);
779     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
780     _reflectFee(rFee, tFee);
781     emit Transfer(sender, recipient, tTransferAmount);
782   }
783 
784   function _transferBothExcluded(
785     address sender,
786     address recipient,
787     uint256 tAmount
788   ) private {
789     (
790       uint256 rAmount,
791       uint256 rTransferAmount,
792       uint256 rFee,
793       uint256 tTransferAmount,
794       uint256 tFee
795     ) = _getValues(tAmount);
796     _tOwned[sender] = _tOwned[sender].sub(tAmount);
797     _rOwned[sender] = _rOwned[sender].sub(rAmount);
798     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
799     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
800     _reflectFee(rFee, tFee);
801     emit Transfer(sender, recipient, tTransferAmount);
802   }
803 
804   function _reflectFee(uint256 rFee, uint256 tFee) private {
805     _rTotal = _rTotal.sub(rFee);
806     _tFeeTotal = _tFeeTotal.add(tFee);
807   }
808 
809   function _getValues(uint256 tAmount)
810     private
811     view
812     returns (
813       uint256,
814       uint256,
815       uint256,
816       uint256,
817       uint256
818     )
819   {
820     (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
821     uint256 currentRate = _getRate();
822     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
823       _getRValues(tAmount, tFee, currentRate);
824     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
825   }
826 
827   function _getTValues(uint256 tAmount)
828     private
829     pure
830     returns (uint256, uint256)
831   {
832     uint256 tFee = 0;
833     uint256 tTransferAmount = tAmount.sub(tFee);
834     return (tTransferAmount, tFee);
835   }
836 
837   function _getRValues(
838     uint256 tAmount,
839     uint256 tFee,
840     uint256 currentRate
841   )
842     private
843     pure
844     returns (
845       uint256,
846       uint256,
847       uint256
848     )
849   {
850     uint256 rAmount = tAmount.mul(currentRate);
851     uint256 rFee = tFee.mul(currentRate);
852     uint256 rTransferAmount = rAmount.sub(rFee);
853     return (rAmount, rTransferAmount, rFee);
854   }
855 
856   function _getRate() private view returns (uint256) {
857     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
858     return rSupply.div(tSupply);
859   }
860 
861   function _getCurrentSupply() private view returns (uint256, uint256) {
862     uint256 rSupply = _rTotal;
863     uint256 tSupply = _tTotal;
864     for (uint256 i = 0; i < _excluded.length; i++) {
865       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
866         return (_rTotal, _tTotal);
867       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
868       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
869     }
870     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
871     return (rSupply, tSupply);
872   }
873 }