1 /**
2 */
3 //  SpaceCaneCorso - $SCORSO here to explore the cosmos
4 //  Total supply: 1,000,000,000,000 $SCORSO
5 //  Liquidity: 45%
6 //  Burned: 30%
7 //  Dev: 6%
8 //  Marketing: 4%
9 //  Initial Liquidity Offering: 15%
10 //  Website — https://spacecanecorso.com
11 //  Telegram — https://t.me/SpaceCaneCorso
12 
13 
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity ^0.6.12;
18 
19 abstract contract Context {
20   function _msgSender() internal view virtual returns (address payable) {
21     return msg.sender;
22   }
23 
24   function _msgData() internal view virtual returns (bytes memory) {
25     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26     return msg.data;
27   }
28 }
29 
30 interface IERC20 {
31   /**
32    * @dev Returns the amount of tokens in existence.
33    */
34   function totalSupply() external view returns (uint256);
35 
36   /**
37    * @dev Returns the amount of tokens owned by `account`.
38    */
39   function balanceOf(address account) external view returns (uint256);
40 
41   /**
42    * @dev Moves `amount` tokens from the caller's account to `recipient`.
43    *
44    * Returns a boolean value indicating whether the operation succeeded.
45    *
46    * Emits a {Transfer} event.
47    */
48   function transfer(address recipient, uint256 amount) external returns (bool);
49 
50   /**
51    * @dev Returns the remaining number of tokens that `spender` will be
52    * allowed to spend on behalf of `owner` through {transferFrom}. This is
53    * zero by default.
54    *
55    * This value changes when {approve} or {transferFrom} are called.
56    */
57   function allowance(address owner, address spender)
58     external
59     view
60     returns (uint256);
61 
62   /**
63    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64    *
65    * Returns a boolean value indicating whether the operation succeeded.
66    *
67    * IMPORTANT: Beware that changing an allowance with this method brings the risk
68    * that someone may use both the old and the new allowance by unfortunate
69    * transaction ordering. One possible solution to mitigate this race
70    * condition is to first reduce the spender's allowance to 0 and set the
71    * desired value afterwards:
72    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73    *
74    * Emits an {Approval} event.
75    */
76   function approve(address spender, uint256 amount) external returns (bool);
77 
78   /**
79    * @dev Moves `amount` tokens from `sender` to `recipient` using the
80    * allowance mechanism. `amount` is then deducted from the caller's
81    * allowance.
82    *
83    * Returns a boolean value indicating whether the operation succeeded.
84    *
85    * Emits a {Transfer} event.
86    */
87   function transferFrom(
88     address sender,
89     address recipient,
90     uint256 amount
91   ) external returns (bool);
92 
93   /**
94    * @dev Emitted when `value` tokens are moved from one account (`from`) to
95    * another (`to`).
96    *
97    * Note that `value` may be zero.
98    */
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 
101   /**
102    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103    * a call to {approve}. `value` is the new allowance.
104    */
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 library SafeMath {
109   /**
110    * @dev Returns the addition of two unsigned integers, reverting on
111    * overflow.
112    *
113    * Counterpart to Solidity's `+` operator.
114    *
115    * Requirements:
116    *
117    * - Addition cannot overflow.
118    */
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     require(c >= a, 'SafeMath: addition overflow');
122 
123     return c;
124   }
125 
126   /**
127    * @dev Returns the subtraction of two unsigned integers, reverting on
128    * overflow (when the result is negative).
129    *
130    * Counterpart to Solidity's `-` operator.
131    *
132    * Requirements:
133    *
134    * - Subtraction cannot overflow.
135    */
136   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137     return sub(a, b, 'SafeMath: subtraction overflow');
138   }
139 
140   /**
141    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142    * overflow (when the result is negative).
143    *
144    * Counterpart to Solidity's `-` operator.
145    *
146    * Requirements:
147    *
148    * - Subtraction cannot overflow.
149    */
150   function sub(
151     uint256 a,
152     uint256 b,
153     string memory errorMessage
154   ) internal pure returns (uint256) {
155     require(b <= a, errorMessage);
156     uint256 c = a - b;
157 
158     return c;
159   }
160 
161   /**
162    * @dev Returns the multiplication of two unsigned integers, reverting on
163    * overflow.
164    *
165    * Counterpart to Solidity's `*` operator.
166    *
167    * Requirements:
168    *
169    * - Multiplication cannot overflow.
170    */
171   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173     // benefit is lost if 'b' is also tested.
174     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175     if (a == 0) {
176       return 0;
177     }
178 
179     uint256 c = a * b;
180     require(c / a == b, 'SafeMath: multiplication overflow');
181 
182     return c;
183   }
184 
185   /**
186    * @dev Returns the integer division of two unsigned integers. Reverts on
187    * division by zero. The result is rounded towards zero.
188    *
189    * Counterpart to Solidity's `/` operator. Note: this function uses a
190    * `revert` opcode (which leaves remaining gas untouched) while Solidity
191    * uses an invalid opcode to revert (consuming all remaining gas).
192    *
193    * Requirements:
194    *
195    * - The divisor cannot be zero.
196    */
197   function div(uint256 a, uint256 b) internal pure returns (uint256) {
198     return div(a, b, 'SafeMath: division by zero');
199   }
200 
201   /**
202    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203    * division by zero. The result is rounded towards zero.
204    *
205    * Counterpart to Solidity's `/` operator. Note: this function uses a
206    * `revert` opcode (which leaves remaining gas untouched) while Solidity
207    * uses an invalid opcode to revert (consuming all remaining gas).
208    *
209    * Requirements:
210    *
211    * - The divisor cannot be zero.
212    */
213   function div(
214     uint256 a,
215     uint256 b,
216     string memory errorMessage
217   ) internal pure returns (uint256) {
218     require(b > 0, errorMessage);
219     uint256 c = a / b;
220     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222     return c;
223   }
224 
225   /**
226    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227    * Reverts when dividing by zero.
228    *
229    * Counterpart to Solidity's `%` operator. This function uses a `revert`
230    * opcode (which leaves remaining gas untouched) while Solidity uses an
231    * invalid opcode to revert (consuming all remaining gas).
232    *
233    * Requirements:
234    *
235    * - The divisor cannot be zero.
236    */
237   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238     return mod(a, b, 'SafeMath: modulo by zero');
239   }
240 
241   /**
242    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243    * Reverts with custom message when dividing by zero.
244    *
245    * Counterpart to Solidity's `%` operator. This function uses a `revert`
246    * opcode (which leaves remaining gas untouched) while Solidity uses an
247    * invalid opcode to revert (consuming all remaining gas).
248    *
249    * Requirements:
250    *
251    * - The divisor cannot be zero.
252    */
253   function mod(
254     uint256 a,
255     uint256 b,
256     string memory errorMessage
257   ) internal pure returns (uint256) {
258     require(b != 0, errorMessage);
259     return a % b;
260   }
261 }
262 
263 library Address {
264   /**
265    * @dev Returns true if `account` is a contract.
266    *
267    * [IMPORTANT]
268    * ====
269    * It is unsafe to assume that an address for which this function returns
270    * false is an externally-owned account (EOA) and not a contract.
271    *
272    * Among others, `isContract` will return false for the following
273    * types of addresses:
274    *
275    *  - an externally-owned account
276    *  - a contract in construction
277    *  - an address where a contract will be created
278    *  - an address where a contract lived, but was destroyed
279    * ====
280    */
281   function isContract(address account) internal view returns (bool) {
282     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
283     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
284     // for accounts without code, i.e. `keccak256('')`
285     bytes32 codehash;
286     bytes32 accountHash =
287       0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288     // solhint-disable-next-line no-inline-assembly
289     assembly {
290       codehash := extcodehash(account)
291     }
292     return (codehash != accountHash && codehash != 0x0);
293   }
294 
295   /**
296    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297    * `recipient`, forwarding all available gas and reverting on errors.
298    *
299    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300    * of certain opcodes, possibly making contracts go over the 2300 gas limit
301    * imposed by `transfer`, making them unable to receive funds via
302    * `transfer`. {sendValue} removes this limitation.
303    *
304    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305    *
306    * IMPORTANT: because control is transferred to `recipient`, care must be
307    * taken to not create reentrancy vulnerabilities. Consider using
308    * {ReentrancyGuard} or the
309    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310    */
311   function sendValue(address payable recipient, uint256 amount) internal {
312     require(address(this).balance >= amount, 'Address: insufficient balance');
313 
314     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315     (bool success, ) = recipient.call{value: amount}('');
316     require(
317       success,
318       'Address: unable to send value, recipient may have reverted'
319     );
320   }
321 
322   /**
323    * @dev Performs a Solidity function call using a low level `call`. A
324    * plain`call` is an unsafe replacement for a function call: use this
325    * function instead.
326    *
327    * If `target` reverts with a revert reason, it is bubbled up by this
328    * function (like regular Solidity function calls).
329    *
330    * Returns the raw returned data. To convert to the expected return value,
331    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332    *
333    * Requirements:
334    *
335    * - `target` must be a contract.
336    * - calling `target` with `data` must not revert.
337    *
338    * _Available since v3.1._
339    */
340   function functionCall(address target, bytes memory data)
341     internal
342     returns (bytes memory)
343   {
344     return functionCall(target, data, 'Address: low-level call failed');
345   }
346 
347   /**
348    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349    * `errorMessage` as a fallback revert reason when `target` reverts.
350    *
351    * _Available since v3.1._
352    */
353   function functionCall(
354     address target,
355     bytes memory data,
356     string memory errorMessage
357   ) internal returns (bytes memory) {
358     return _functionCallWithValue(target, data, 0, errorMessage);
359   }
360 
361   /**
362    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363    * but also transferring `value` wei to `target`.
364    *
365    * Requirements:
366    *
367    * - the calling contract must have an ETH balance of at least `value`.
368    * - the called Solidity function must be `payable`.
369    *
370    * _Available since v3.1._
371    */
372   function functionCallWithValue(
373     address target,
374     bytes memory data,
375     uint256 value
376   ) internal returns (bytes memory) {
377     return
378       functionCallWithValue(
379         target,
380         data,
381         value,
382         'Address: low-level call with value failed'
383       );
384   }
385 
386   /**
387    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
388    * with `errorMessage` as a fallback revert reason when `target` reverts.
389    *
390    * _Available since v3.1._
391    */
392   function functionCallWithValue(
393     address target,
394     bytes memory data,
395     uint256 value,
396     string memory errorMessage
397   ) internal returns (bytes memory) {
398     require(
399       address(this).balance >= value,
400       'Address: insufficient balance for call'
401     );
402     return _functionCallWithValue(target, data, value, errorMessage);
403   }
404 
405   function _functionCallWithValue(
406     address target,
407     bytes memory data,
408     uint256 weiValue,
409     string memory errorMessage
410   ) private returns (bytes memory) {
411     require(isContract(target), 'Address: call to non-contract');
412 
413     // solhint-disable-next-line avoid-low-level-calls
414     (bool success, bytes memory returndata) =
415       target.call{value: weiValue}(data);
416     if (success) {
417       return returndata;
418     } else {
419       // Look for revert reason and bubble it up if present
420       if (returndata.length > 0) {
421         // The easiest way to bubble the revert reason is using memory via assembly
422 
423         // solhint-disable-next-line no-inline-assembly
424         assembly {
425           let returndata_size := mload(returndata)
426           revert(add(32, returndata), returndata_size)
427         }
428       } else {
429         revert(errorMessage);
430       }
431     }
432   }
433 }
434 
435 contract Ownable is Context {
436   address private _owner;
437 
438   event OwnershipTransferred(
439     address indexed previousOwner,
440     address indexed newOwner
441   );
442 
443   /**
444    * @dev Initializes the contract setting the deployer as the initial owner.
445    */
446   constructor() internal {
447     address msgSender = _msgSender();
448     _owner = msgSender;
449     emit OwnershipTransferred(address(0), msgSender);
450   }
451 
452   /**
453    * @dev Returns the address of the current owner.
454    */
455   function owner() public view returns (address) {
456     return _owner;
457   }
458 
459   /**
460    * @dev Throws if called by any account other than the owner.
461    */
462   modifier onlyOwner() {
463     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
464     _;
465   }
466 
467   /**
468    * @dev Leaves the contract without owner. It will not be possible to call
469    * `onlyOwner` functions anymore. Can only be called by the current owner.
470    *
471    * NOTE: Renouncing ownership will leave the contract without an owner,
472    * thereby removing any functionality that is only available to the owner.
473    */
474   function renounceOwnership() public virtual onlyOwner {
475     emit OwnershipTransferred(_owner, address(0));
476     _owner = address(0);
477   }
478 
479   /**
480    * @dev Transfers ownership of the contract to a new account (`newOwner`).
481    * Can only be called by the current owner.
482    */
483   function transferOwnership(address newOwner) public virtual onlyOwner {
484     require(newOwner != address(0), 'Ownable: new owner is the zero address');
485     emit OwnershipTransferred(_owner, newOwner);
486     _owner = newOwner;
487   }
488 }
489 
490 contract SpaceCaneCorso is Context, IERC20, Ownable {
491   using SafeMath for uint256;
492   using Address for address;
493 
494   mapping(address => uint256) private _rOwned;
495   mapping(address => uint256) private _tOwned;
496   mapping(address => mapping(address => uint256)) private _allowances;
497 
498   mapping(address => bool) private _isExcluded;
499   address[] private _excluded;
500 
501   uint256 private constant MAX = ~uint256(0);
502   uint256 private constant _tTotal = 10000000 * 10**5 * 10**9;
503   uint256 private _rTotal = (MAX - (MAX % _tTotal));
504   uint256 private _tFeeTotal;
505 
506   string private _name = 'Space Cane Corso (Spacecanecorso.com)';
507   string private _symbol = 'SCORSO';
508   uint8 private _decimals = 9;
509 
510   uint256 public _maxTxAmount = 3000000 * 10**5 * 10**9;
511 
512   constructor() public {
513     _rOwned[_msgSender()] = _rTotal;
514     emit Transfer(address(0), _msgSender(), _tTotal);
515   }
516 
517   function name() public view returns (string memory) {
518     return _name;
519   }
520 
521   function symbol() public view returns (string memory) {
522     return _symbol;
523   }
524 
525   function decimals() public view returns (uint8) {
526     return _decimals;
527   }
528 
529   function totalSupply() public view override returns (uint256) {
530     return _tTotal;
531   }
532 
533   function balanceOf(address account) public view override returns (uint256) {
534     if (_isExcluded[account]) return _tOwned[account];
535     return tokenFromReflection(_rOwned[account]);
536   }
537 
538   function transfer(address recipient, uint256 amount)
539     public
540     override
541     returns (bool)
542   {
543     _transfer(_msgSender(), recipient, amount);
544     return true;
545   }
546 
547   function allowance(address owner, address spender)
548     public
549     view
550     override
551     returns (uint256)
552   {
553     return _allowances[owner][spender];
554   }
555 
556   function approve(address spender, uint256 amount)
557     public
558     override
559     returns (bool)
560   {
561     _approve(_msgSender(), spender, amount);
562     return true;
563   }
564 
565   function transferFrom(
566     address sender,
567     address recipient,
568     uint256 amount
569   ) public override returns (bool) {
570     _transfer(sender, recipient, amount);
571     _approve(
572       sender,
573       _msgSender(),
574       _allowances[sender][_msgSender()].sub(
575         amount,
576         'ERC20: transfer amount exceeds allowance'
577       )
578     );
579     return true;
580   }
581 
582   function increaseAllowance(address spender, uint256 addedValue)
583     public
584     virtual
585     returns (bool)
586   {
587     _approve(
588       _msgSender(),
589       spender,
590       _allowances[_msgSender()][spender].add(addedValue)
591     );
592     return true;
593   }
594 
595   function decreaseAllowance(address spender, uint256 subtractedValue)
596     public
597     virtual
598     returns (bool)
599   {
600     _approve(
601       _msgSender(),
602       spender,
603       _allowances[_msgSender()][spender].sub(
604         subtractedValue,
605         'ERC20: decreased allowance below zero'
606       )
607     );
608     return true;
609   }
610 
611   function isExcluded(address account) public view returns (bool) {
612     return _isExcluded[account];
613   }
614 
615   function totalFees() public view returns (uint256) {
616     return _tFeeTotal;
617   }
618 
619   function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
620     _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
621   }
622 
623   function rescueFromContract() external onlyOwner {
624     address payable _owner = _msgSender();
625     _owner.transfer(address(this).balance);
626   }
627 
628   function reflect(uint256 tAmount) public {
629     address sender = _msgSender();
630     require(
631       !_isExcluded[sender],
632       'Excluded addresses cannot call this function'
633     );
634     (uint256 rAmount, , , , ) = _getValues(tAmount);
635     _rOwned[sender] = _rOwned[sender].sub(rAmount);
636     _rTotal = _rTotal.sub(rAmount);
637     _tFeeTotal = _tFeeTotal.add(tAmount);
638   }
639 
640   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
641     public
642     view
643     returns (uint256)
644   {
645     require(tAmount <= _tTotal, 'Amount must be less than supply');
646     if (!deductTransferFee) {
647       (uint256 rAmount, , , , ) = _getValues(tAmount);
648       return rAmount;
649     } else {
650       (, uint256 rTransferAmount, , , ) = _getValues(tAmount);
651       return rTransferAmount;
652     }
653   }
654 
655   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
656     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
657     uint256 currentRate = _getRate();
658     return rAmount.div(currentRate);
659   }
660 
661   function excludeAccount(address account) external onlyOwner() {
662     require(!_isExcluded[account], 'Account is already excluded');
663     if (_rOwned[account] > 0) {
664       _tOwned[account] = tokenFromReflection(_rOwned[account]);
665     }
666     _isExcluded[account] = true;
667     _excluded.push(account);
668   }
669 
670   function includeAccount(address account) external onlyOwner() {
671     require(_isExcluded[account], 'Account is already excluded');
672     for (uint256 i = 0; i < _excluded.length; i++) {
673       if (_excluded[i] == account) {
674         _excluded[i] = _excluded[_excluded.length - 1];
675         _tOwned[account] = 0;
676         _isExcluded[account] = false;
677         _excluded.pop();
678         break;
679       }
680     }
681   }
682 
683   function _approve(
684     address owner,
685     address spender,
686     uint256 amount
687   ) private {
688     require(owner != address(0), 'ERC20: approve from the zero address');
689     require(spender != address(0), 'ERC20: approve to the zero address');
690 
691     _allowances[owner][spender] = amount;
692     emit Approval(owner, spender, amount);
693   }
694 
695   function _transfer(
696     address sender,
697     address recipient,
698     uint256 amount
699   ) private {
700     require(sender != address(0), 'ERC20: transfer from the zero address');
701     require(recipient != address(0), 'ERC20: transfer to the zero address');
702     require(amount > 0, 'Transfer amount must be greater than zero');
703     if (sender != owner() && recipient != owner()) {
704       require(
705         amount <= _maxTxAmount,
706         'Transfer amount exceeds the maxTxAmount.'
707       );
708       require(!_isExcluded[sender], 'Account is excluded');
709     }
710 
711     if (_isExcluded[sender] && !_isExcluded[recipient]) {
712       _transferFromExcluded(sender, recipient, amount);
713     } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
714       _transferToExcluded(sender, recipient, amount);
715     } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
716       _transferStandard(sender, recipient, amount);
717     } else if (_isExcluded[sender] && _isExcluded[recipient]) {
718       _transferBothExcluded(sender, recipient, amount);
719     } else {
720       _transferStandard(sender, recipient, amount);
721     }
722   }
723 
724   function _transferStandard(
725     address sender,
726     address recipient,
727     uint256 tAmount
728   ) private {
729     (
730       uint256 rAmount,
731       uint256 rTransferAmount,
732       uint256 rFee,
733       uint256 tTransferAmount,
734       uint256 tFee
735     ) = _getValues(tAmount);
736     _rOwned[sender] = _rOwned[sender].sub(rAmount);
737     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
738     _reflectFee(rFee, tFee);
739     emit Transfer(sender, recipient, tTransferAmount);
740   }
741 
742   function _transferToExcluded(
743     address sender,
744     address recipient,
745     uint256 tAmount
746   ) private {
747     (
748       uint256 rAmount,
749       uint256 rTransferAmount,
750       uint256 rFee,
751       uint256 tTransferAmount,
752       uint256 tFee
753     ) = _getValues(tAmount);
754     _rOwned[sender] = _rOwned[sender].sub(rAmount);
755     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
756     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
757     _reflectFee(rFee, tFee);
758     emit Transfer(sender, recipient, tTransferAmount);
759   }
760 
761   function _transferFromExcluded(
762     address sender,
763     address recipient,
764     uint256 tAmount
765   ) private {
766     (
767       uint256 rAmount,
768       uint256 rTransferAmount,
769       uint256 rFee,
770       uint256 tTransferAmount,
771       uint256 tFee
772     ) = _getValues(tAmount);
773     _tOwned[sender] = _tOwned[sender].sub(tAmount);
774     _rOwned[sender] = _rOwned[sender].sub(rAmount);
775     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
776     _reflectFee(rFee, tFee);
777     emit Transfer(sender, recipient, tTransferAmount);
778   }
779 
780   function _transferBothExcluded(
781     address sender,
782     address recipient,
783     uint256 tAmount
784   ) private {
785     (
786       uint256 rAmount,
787       uint256 rTransferAmount,
788       uint256 rFee,
789       uint256 tTransferAmount,
790       uint256 tFee
791     ) = _getValues(tAmount);
792     _tOwned[sender] = _tOwned[sender].sub(tAmount);
793     _rOwned[sender] = _rOwned[sender].sub(rAmount);
794     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
795     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
796     _reflectFee(rFee, tFee);
797     emit Transfer(sender, recipient, tTransferAmount);
798   }
799 
800   function _reflectFee(uint256 rFee, uint256 tFee) private {
801     _rTotal = _rTotal.sub(rFee);
802     _tFeeTotal = _tFeeTotal.add(tFee);
803   }
804 
805   function _getValues(uint256 tAmount)
806     private
807     view
808     returns (
809       uint256,
810       uint256,
811       uint256,
812       uint256,
813       uint256
814     )
815   {
816     (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
817     uint256 currentRate = _getRate();
818     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
819       _getRValues(tAmount, tFee, currentRate);
820     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
821   }
822 
823   function _getTValues(uint256 tAmount)
824     private
825     pure
826     returns (uint256, uint256)
827   {
828     uint256 tFee = 0;
829     uint256 tTransferAmount = tAmount.sub(tFee);
830     return (tTransferAmount, tFee);
831   }
832 
833   function _getRValues(
834     uint256 tAmount,
835     uint256 tFee,
836     uint256 currentRate
837   )
838     private
839     pure
840     returns (
841       uint256,
842       uint256,
843       uint256
844     )
845   {
846     uint256 rAmount = tAmount.mul(currentRate);
847     uint256 rFee = tFee.mul(currentRate);
848     uint256 rTransferAmount = rAmount.sub(rFee);
849     return (rAmount, rTransferAmount, rFee);
850   }
851 
852   function _getRate() private view returns (uint256) {
853     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
854     return rSupply.div(tSupply);
855   }
856 
857   function _getCurrentSupply() private view returns (uint256, uint256) {
858     uint256 rSupply = _rTotal;
859     uint256 tSupply = _tTotal;
860     for (uint256 i = 0; i < _excluded.length; i++) {
861       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
862         return (_rTotal, _tTotal);
863       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
864       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
865     }
866     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
867     return (rSupply, tSupply);
868   }
869 }