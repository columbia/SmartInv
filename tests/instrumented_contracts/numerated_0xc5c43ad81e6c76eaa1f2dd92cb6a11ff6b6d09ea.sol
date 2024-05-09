1 /**
2     Shiba Cosmos- $SHIBCO here to explore the cosmos
3     
4     Total supply: 1 000 000 000 000 000 $WSDOGE
5     Liquidity: 30%
6     Burned: 50%
7     Giveaway: 5%
8     Marketing: 5%
9     Initial Liquidity Offering: 10%
10 
11     Website — http://shibacosmo.net
12 
13     Telegram — https://t.me/ShibaCosmo
14 */
15 
16 // SPDX-License-Identifier: Unlicensed
17 
18 pragma solidity ^0.6.12;
19 
20 abstract contract Context {
21   function _msgSender() internal view virtual returns (address payable) {
22     return msg.sender;
23   }
24 
25   function _msgData() internal view virtual returns (bytes memory) {
26     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27     return msg.data;
28   }
29 }
30 
31 interface IERC20 {
32   /**
33    * @dev Returns the amount of tokens in existence.
34    */
35   function totalSupply() external view returns (uint256);
36 
37   /**
38    * @dev Returns the amount of tokens owned by `account`.
39    */
40   function balanceOf(address account) external view returns (uint256);
41 
42   /**
43    * @dev Moves `amount` tokens from the caller's account to `recipient`.
44    *
45    * Returns a boolean value indicating whether the operation succeeded.
46    *
47    * Emits a {Transfer} event.
48    */
49   function transfer(address recipient, uint256 amount) external returns (bool);
50 
51   /**
52    * @dev Returns the remaining number of tokens that `spender` will be
53    * allowed to spend on behalf of `owner` through {transferFrom}. This is
54    * zero by default.
55    *
56    * This value changes when {approve} or {transferFrom} are called.
57    */
58   function allowance(address owner, address spender)
59     external
60     view
61     returns (uint256);
62 
63   /**
64    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65    *
66    * Returns a boolean value indicating whether the operation succeeded.
67    *
68    * IMPORTANT: Beware that changing an allowance with this method brings the risk
69    * that someone may use both the old and the new allowance by unfortunate
70    * transaction ordering. One possible solution to mitigate this race
71    * condition is to first reduce the spender's allowance to 0 and set the
72    * desired value afterwards:
73    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74    *
75    * Emits an {Approval} event.
76    */
77   function approve(address spender, uint256 amount) external returns (bool);
78 
79   /**
80    * @dev Moves `amount` tokens from `sender` to `recipient` using the
81    * allowance mechanism. `amount` is then deducted from the caller's
82    * allowance.
83    *
84    * Returns a boolean value indicating whether the operation succeeded.
85    *
86    * Emits a {Transfer} event.
87    */
88   function transferFrom(
89     address sender,
90     address recipient,
91     uint256 amount
92   ) external returns (bool);
93 
94   /**
95    * @dev Emitted when `value` tokens are moved from one account (`from`) to
96    * another (`to`).
97    *
98    * Note that `value` may be zero.
99    */
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 
102   /**
103    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104    * a call to {approve}. `value` is the new allowance.
105    */
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 library SafeMath {
110   /**
111    * @dev Returns the addition of two unsigned integers, reverting on
112    * overflow.
113    *
114    * Counterpart to Solidity's `+` operator.
115    *
116    * Requirements:
117    *
118    * - Addition cannot overflow.
119    */
120   function add(uint256 a, uint256 b) internal pure returns (uint256) {
121     uint256 c = a + b;
122     require(c >= a, 'SafeMath: addition overflow');
123 
124     return c;
125   }
126 
127   /**
128    * @dev Returns the subtraction of two unsigned integers, reverting on
129    * overflow (when the result is negative).
130    *
131    * Counterpart to Solidity's `-` operator.
132    *
133    * Requirements:
134    *
135    * - Subtraction cannot overflow.
136    */
137   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     return sub(a, b, 'SafeMath: subtraction overflow');
139   }
140 
141   /**
142    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
143    * overflow (when the result is negative).
144    *
145    * Counterpart to Solidity's `-` operator.
146    *
147    * Requirements:
148    *
149    * - Subtraction cannot overflow.
150    */
151   function sub(
152     uint256 a,
153     uint256 b,
154     string memory errorMessage
155   ) internal pure returns (uint256) {
156     require(b <= a, errorMessage);
157     uint256 c = a - b;
158 
159     return c;
160   }
161 
162   /**
163    * @dev Returns the multiplication of two unsigned integers, reverting on
164    * overflow.
165    *
166    * Counterpart to Solidity's `*` operator.
167    *
168    * Requirements:
169    *
170    * - Multiplication cannot overflow.
171    */
172   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174     // benefit is lost if 'b' is also tested.
175     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176     if (a == 0) {
177       return 0;
178     }
179 
180     uint256 c = a * b;
181     require(c / a == b, 'SafeMath: multiplication overflow');
182 
183     return c;
184   }
185 
186   /**
187    * @dev Returns the integer division of two unsigned integers. Reverts on
188    * division by zero. The result is rounded towards zero.
189    *
190    * Counterpart to Solidity's `/` operator. Note: this function uses a
191    * `revert` opcode (which leaves remaining gas untouched) while Solidity
192    * uses an invalid opcode to revert (consuming all remaining gas).
193    *
194    * Requirements:
195    *
196    * - The divisor cannot be zero.
197    */
198   function div(uint256 a, uint256 b) internal pure returns (uint256) {
199     return div(a, b, 'SafeMath: division by zero');
200   }
201 
202   /**
203    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204    * division by zero. The result is rounded towards zero.
205    *
206    * Counterpart to Solidity's `/` operator. Note: this function uses a
207    * `revert` opcode (which leaves remaining gas untouched) while Solidity
208    * uses an invalid opcode to revert (consuming all remaining gas).
209    *
210    * Requirements:
211    *
212    * - The divisor cannot be zero.
213    */
214   function div(
215     uint256 a,
216     uint256 b,
217     string memory errorMessage
218   ) internal pure returns (uint256) {
219     require(b > 0, errorMessage);
220     uint256 c = a / b;
221     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223     return c;
224   }
225 
226   /**
227    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228    * Reverts when dividing by zero.
229    *
230    * Counterpart to Solidity's `%` operator. This function uses a `revert`
231    * opcode (which leaves remaining gas untouched) while Solidity uses an
232    * invalid opcode to revert (consuming all remaining gas).
233    *
234    * Requirements:
235    *
236    * - The divisor cannot be zero.
237    */
238   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239     return mod(a, b, 'SafeMath: modulo by zero');
240   }
241 
242   /**
243    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244    * Reverts with custom message when dividing by zero.
245    *
246    * Counterpart to Solidity's `%` operator. This function uses a `revert`
247    * opcode (which leaves remaining gas untouched) while Solidity uses an
248    * invalid opcode to revert (consuming all remaining gas).
249    *
250    * Requirements:
251    *
252    * - The divisor cannot be zero.
253    */
254   function mod(
255     uint256 a,
256     uint256 b,
257     string memory errorMessage
258   ) internal pure returns (uint256) {
259     require(b != 0, errorMessage);
260     return a % b;
261   }
262 }
263 
264 library Address {
265   /**
266    * @dev Returns true if `account` is a contract.
267    *
268    * [IMPORTANT]
269    * ====
270    * It is unsafe to assume that an address for which this function returns
271    * false is an externally-owned account (EOA) and not a contract.
272    *
273    * Among others, `isContract` will return false for the following
274    * types of addresses:
275    *
276    *  - an externally-owned account
277    *  - a contract in construction
278    *  - an address where a contract will be created
279    *  - an address where a contract lived, but was destroyed
280    * ====
281    */
282   function isContract(address account) internal view returns (bool) {
283     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285     // for accounts without code, i.e. `keccak256('')`
286     bytes32 codehash;
287     bytes32 accountHash =
288       0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289     // solhint-disable-next-line no-inline-assembly
290     assembly {
291       codehash := extcodehash(account)
292     }
293     return (codehash != accountHash && codehash != 0x0);
294   }
295 
296   /**
297    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298    * `recipient`, forwarding all available gas and reverting on errors.
299    *
300    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301    * of certain opcodes, possibly making contracts go over the 2300 gas limit
302    * imposed by `transfer`, making them unable to receive funds via
303    * `transfer`. {sendValue} removes this limitation.
304    *
305    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306    *
307    * IMPORTANT: because control is transferred to `recipient`, care must be
308    * taken to not create reentrancy vulnerabilities. Consider using
309    * {ReentrancyGuard} or the
310    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311    */
312   function sendValue(address payable recipient, uint256 amount) internal {
313     require(address(this).balance >= amount, 'Address: insufficient balance');
314 
315     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316     (bool success, ) = recipient.call{value: amount}('');
317     require(
318       success,
319       'Address: unable to send value, recipient may have reverted'
320     );
321   }
322 
323   /**
324    * @dev Performs a Solidity function call using a low level `call`. A
325    * plain`call` is an unsafe replacement for a function call: use this
326    * function instead.
327    *
328    * If `target` reverts with a revert reason, it is bubbled up by this
329    * function (like regular Solidity function calls).
330    *
331    * Returns the raw returned data. To convert to the expected return value,
332    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333    *
334    * Requirements:
335    *
336    * - `target` must be a contract.
337    * - calling `target` with `data` must not revert.
338    *
339    * _Available since v3.1._
340    */
341   function functionCall(address target, bytes memory data)
342     internal
343     returns (bytes memory)
344   {
345     return functionCall(target, data, 'Address: low-level call failed');
346   }
347 
348   /**
349    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350    * `errorMessage` as a fallback revert reason when `target` reverts.
351    *
352    * _Available since v3.1._
353    */
354   function functionCall(
355     address target,
356     bytes memory data,
357     string memory errorMessage
358   ) internal returns (bytes memory) {
359     return _functionCallWithValue(target, data, 0, errorMessage);
360   }
361 
362   /**
363    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364    * but also transferring `value` wei to `target`.
365    *
366    * Requirements:
367    *
368    * - the calling contract must have an ETH balance of at least `value`.
369    * - the called Solidity function must be `payable`.
370    *
371    * _Available since v3.1._
372    */
373   function functionCallWithValue(
374     address target,
375     bytes memory data,
376     uint256 value
377   ) internal returns (bytes memory) {
378     return
379       functionCallWithValue(
380         target,
381         data,
382         value,
383         'Address: low-level call with value failed'
384       );
385   }
386 
387   /**
388    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389    * with `errorMessage` as a fallback revert reason when `target` reverts.
390    *
391    * _Available since v3.1._
392    */
393   function functionCallWithValue(
394     address target,
395     bytes memory data,
396     uint256 value,
397     string memory errorMessage
398   ) internal returns (bytes memory) {
399     require(
400       address(this).balance >= value,
401       'Address: insufficient balance for call'
402     );
403     return _functionCallWithValue(target, data, value, errorMessage);
404   }
405 
406   function _functionCallWithValue(
407     address target,
408     bytes memory data,
409     uint256 weiValue,
410     string memory errorMessage
411   ) private returns (bytes memory) {
412     require(isContract(target), 'Address: call to non-contract');
413 
414     // solhint-disable-next-line avoid-low-level-calls
415     (bool success, bytes memory returndata) =
416       target.call{value: weiValue}(data);
417     if (success) {
418       return returndata;
419     } else {
420       // Look for revert reason and bubble it up if present
421       if (returndata.length > 0) {
422         // The easiest way to bubble the revert reason is using memory via assembly
423 
424         // solhint-disable-next-line no-inline-assembly
425         assembly {
426           let returndata_size := mload(returndata)
427           revert(add(32, returndata), returndata_size)
428         }
429       } else {
430         revert(errorMessage);
431       }
432     }
433   }
434 }
435 
436 contract Ownable is Context {
437   address private _owner;
438 
439   event OwnershipTransferred(
440     address indexed previousOwner,
441     address indexed newOwner
442   );
443 
444   /**
445    * @dev Initializes the contract setting the deployer as the initial owner.
446    */
447   constructor() internal {
448     address msgSender = _msgSender();
449     _owner = msgSender;
450     emit OwnershipTransferred(address(0), msgSender);
451   }
452 
453   /**
454    * @dev Returns the address of the current owner.
455    */
456   function owner() public view returns (address) {
457     return _owner;
458   }
459 
460   /**
461    * @dev Throws if called by any account other than the owner.
462    */
463   modifier onlyOwner() {
464     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
465     _;
466   }
467 
468   /**
469    * @dev Leaves the contract without owner. It will not be possible to call
470    * `onlyOwner` functions anymore. Can only be called by the current owner.
471    *
472    * NOTE: Renouncing ownership will leave the contract without an owner,
473    * thereby removing any functionality that is only available to the owner.
474    */
475   function renounceOwnership() public virtual onlyOwner {
476     emit OwnershipTransferred(_owner, address(0));
477     _owner = address(0);
478   }
479 
480   /**
481    * @dev Transfers ownership of the contract to a new account (`newOwner`).
482    * Can only be called by the current owner.
483    */
484   function transferOwnership(address newOwner) public virtual onlyOwner {
485     require(newOwner != address(0), 'Ownable: new owner is the zero address');
486     emit OwnershipTransferred(_owner, newOwner);
487     _owner = newOwner;
488   }
489 }
490 
491 contract ShibaCosmos is Context, IERC20, Ownable {
492   using SafeMath for uint256;
493   using Address for address;
494 
495   mapping(address => uint256) private _rOwned;
496   mapping(address => uint256) private _tOwned;
497   mapping(address => mapping(address => uint256)) private _allowances;
498 
499   mapping(address => bool) private _isExcluded;
500   address[] private _excluded;
501 
502   uint256 private constant MAX = ~uint256(0);
503   uint256 private constant _tTotal = 10000000 * 10**5 * 10**9;
504   uint256 private _rTotal = (MAX - (MAX % _tTotal));
505   uint256 private _tFeeTotal;
506 
507   string private _name = 'Shiba Cosmos';
508   string private _symbol = 'SHIBCO';
509   uint8 private _decimals = 9;
510 
511   uint256 public _maxTxAmount = 3000000 * 10**5 * 10**9;
512 
513   constructor() public {
514     _rOwned[_msgSender()] = _rTotal;
515     emit Transfer(address(0), _msgSender(), _tTotal);
516   }
517 
518   function name() public view returns (string memory) {
519     return _name;
520   }
521 
522   function symbol() public view returns (string memory) {
523     return _symbol;
524   }
525 
526   function decimals() public view returns (uint8) {
527     return _decimals;
528   }
529 
530   function totalSupply() public view override returns (uint256) {
531     return _tTotal;
532   }
533 
534   function balanceOf(address account) public view override returns (uint256) {
535     if (_isExcluded[account]) return _tOwned[account];
536     return tokenFromReflection(_rOwned[account]);
537   }
538 
539   function transfer(address recipient, uint256 amount)
540     public
541     override
542     returns (bool)
543   {
544     _transfer(_msgSender(), recipient, amount);
545     return true;
546   }
547 
548   function allowance(address owner, address spender)
549     public
550     view
551     override
552     returns (uint256)
553   {
554     return _allowances[owner][spender];
555   }
556 
557   function approve(address spender, uint256 amount)
558     public
559     override
560     returns (bool)
561   {
562     _approve(_msgSender(), spender, amount);
563     return true;
564   }
565 
566   function transferFrom(
567     address sender,
568     address recipient,
569     uint256 amount
570   ) public override returns (bool) {
571     _transfer(sender, recipient, amount);
572     _approve(
573       sender,
574       _msgSender(),
575       _allowances[sender][_msgSender()].sub(
576         amount,
577         'ERC20: transfer amount exceeds allowance'
578       )
579     );
580     return true;
581   }
582 
583   function increaseAllowance(address spender, uint256 addedValue)
584     public
585     virtual
586     returns (bool)
587   {
588     _approve(
589       _msgSender(),
590       spender,
591       _allowances[_msgSender()][spender].add(addedValue)
592     );
593     return true;
594   }
595 
596   function decreaseAllowance(address spender, uint256 subtractedValue)
597     public
598     virtual
599     returns (bool)
600   {
601     _approve(
602       _msgSender(),
603       spender,
604       _allowances[_msgSender()][spender].sub(
605         subtractedValue,
606         'ERC20: decreased allowance below zero'
607       )
608     );
609     return true;
610   }
611 
612   function isExcluded(address account) public view returns (bool) {
613     return _isExcluded[account];
614   }
615 
616   function totalFees() public view returns (uint256) {
617     return _tFeeTotal;
618   }
619 
620   function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
621     _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
622   }
623 
624   function rescueFromContract() external onlyOwner {
625     address payable _owner = _msgSender();
626     _owner.transfer(address(this).balance);
627   }
628 
629   function reflect(uint256 tAmount) public {
630     address sender = _msgSender();
631     require(
632       !_isExcluded[sender],
633       'Excluded addresses cannot call this function'
634     );
635     (uint256 rAmount, , , , ) = _getValues(tAmount);
636     _rOwned[sender] = _rOwned[sender].sub(rAmount);
637     _rTotal = _rTotal.sub(rAmount);
638     _tFeeTotal = _tFeeTotal.add(tAmount);
639   }
640 
641   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
642     public
643     view
644     returns (uint256)
645   {
646     require(tAmount <= _tTotal, 'Amount must be less than supply');
647     if (!deductTransferFee) {
648       (uint256 rAmount, , , , ) = _getValues(tAmount);
649       return rAmount;
650     } else {
651       (, uint256 rTransferAmount, , , ) = _getValues(tAmount);
652       return rTransferAmount;
653     }
654   }
655 
656   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
657     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
658     uint256 currentRate = _getRate();
659     return rAmount.div(currentRate);
660   }
661 
662   function excludeAccount(address account) external onlyOwner() {
663     require(!_isExcluded[account], 'Account is already excluded');
664     if (_rOwned[account] > 0) {
665       _tOwned[account] = tokenFromReflection(_rOwned[account]);
666     }
667     _isExcluded[account] = true;
668     _excluded.push(account);
669   }
670 
671   function includeAccount(address account) external onlyOwner() {
672     require(_isExcluded[account], 'Account is already excluded');
673     for (uint256 i = 0; i < _excluded.length; i++) {
674       if (_excluded[i] == account) {
675         _excluded[i] = _excluded[_excluded.length - 1];
676         _tOwned[account] = 0;
677         _isExcluded[account] = false;
678         _excluded.pop();
679         break;
680       }
681     }
682   }
683 
684   function _approve(
685     address owner,
686     address spender,
687     uint256 amount
688   ) private {
689     require(owner != address(0), 'ERC20: approve from the zero address');
690     require(spender != address(0), 'ERC20: approve to the zero address');
691 
692     _allowances[owner][spender] = amount;
693     emit Approval(owner, spender, amount);
694   }
695 
696   function _transfer(
697     address sender,
698     address recipient,
699     uint256 amount
700   ) private {
701     require(sender != address(0), 'ERC20: transfer from the zero address');
702     require(recipient != address(0), 'ERC20: transfer to the zero address');
703     require(amount > 0, 'Transfer amount must be greater than zero');
704     if (sender != owner() && recipient != owner()) {
705       require(
706         amount <= _maxTxAmount,
707         'Transfer amount exceeds the maxTxAmount.'
708       );
709       require(!_isExcluded[sender], 'Account is excluded');
710     }
711 
712     if (_isExcluded[sender] && !_isExcluded[recipient]) {
713       _transferFromExcluded(sender, recipient, amount);
714     } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
715       _transferToExcluded(sender, recipient, amount);
716     } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
717       _transferStandard(sender, recipient, amount);
718     } else if (_isExcluded[sender] && _isExcluded[recipient]) {
719       _transferBothExcluded(sender, recipient, amount);
720     } else {
721       _transferStandard(sender, recipient, amount);
722     }
723   }
724 
725   function _transferStandard(
726     address sender,
727     address recipient,
728     uint256 tAmount
729   ) private {
730     (
731       uint256 rAmount,
732       uint256 rTransferAmount,
733       uint256 rFee,
734       uint256 tTransferAmount,
735       uint256 tFee
736     ) = _getValues(tAmount);
737     _rOwned[sender] = _rOwned[sender].sub(rAmount);
738     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
739     _reflectFee(rFee, tFee);
740     emit Transfer(sender, recipient, tTransferAmount);
741   }
742 
743   function _transferToExcluded(
744     address sender,
745     address recipient,
746     uint256 tAmount
747   ) private {
748     (
749       uint256 rAmount,
750       uint256 rTransferAmount,
751       uint256 rFee,
752       uint256 tTransferAmount,
753       uint256 tFee
754     ) = _getValues(tAmount);
755     _rOwned[sender] = _rOwned[sender].sub(rAmount);
756     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
757     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
758     _reflectFee(rFee, tFee);
759     emit Transfer(sender, recipient, tTransferAmount);
760   }
761 
762   function _transferFromExcluded(
763     address sender,
764     address recipient,
765     uint256 tAmount
766   ) private {
767     (
768       uint256 rAmount,
769       uint256 rTransferAmount,
770       uint256 rFee,
771       uint256 tTransferAmount,
772       uint256 tFee
773     ) = _getValues(tAmount);
774     _tOwned[sender] = _tOwned[sender].sub(tAmount);
775     _rOwned[sender] = _rOwned[sender].sub(rAmount);
776     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
777     _reflectFee(rFee, tFee);
778     emit Transfer(sender, recipient, tTransferAmount);
779   }
780 
781   function _transferBothExcluded(
782     address sender,
783     address recipient,
784     uint256 tAmount
785   ) private {
786     (
787       uint256 rAmount,
788       uint256 rTransferAmount,
789       uint256 rFee,
790       uint256 tTransferAmount,
791       uint256 tFee
792     ) = _getValues(tAmount);
793     _tOwned[sender] = _tOwned[sender].sub(tAmount);
794     _rOwned[sender] = _rOwned[sender].sub(rAmount);
795     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
796     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
797     _reflectFee(rFee, tFee);
798     emit Transfer(sender, recipient, tTransferAmount);
799   }
800 
801   function _reflectFee(uint256 rFee, uint256 tFee) private {
802     _rTotal = _rTotal.sub(rFee);
803     _tFeeTotal = _tFeeTotal.add(tFee);
804   }
805 
806   function _getValues(uint256 tAmount)
807     private
808     view
809     returns (
810       uint256,
811       uint256,
812       uint256,
813       uint256,
814       uint256
815     )
816   {
817     (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
818     uint256 currentRate = _getRate();
819     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
820       _getRValues(tAmount, tFee, currentRate);
821     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
822   }
823 
824   function _getTValues(uint256 tAmount)
825     private
826     pure
827     returns (uint256, uint256)
828   {
829     uint256 tFee = 0;
830     uint256 tTransferAmount = tAmount.sub(tFee);
831     return (tTransferAmount, tFee);
832   }
833 
834   function _getRValues(
835     uint256 tAmount,
836     uint256 tFee,
837     uint256 currentRate
838   )
839     private
840     pure
841     returns (
842       uint256,
843       uint256,
844       uint256
845     )
846   {
847     uint256 rAmount = tAmount.mul(currentRate);
848     uint256 rFee = tFee.mul(currentRate);
849     uint256 rTransferAmount = rAmount.sub(rFee);
850     return (rAmount, rTransferAmount, rFee);
851   }
852 
853   function _getRate() private view returns (uint256) {
854     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
855     return rSupply.div(tSupply);
856   }
857 
858   function _getCurrentSupply() private view returns (uint256, uint256) {
859     uint256 rSupply = _rTotal;
860     uint256 tSupply = _tTotal;
861     for (uint256 i = 0; i < _excluded.length; i++) {
862       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
863         return (_rTotal, _tTotal);
864       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
865       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
866     }
867     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
868     return (rSupply, tSupply);
869   }
870 }