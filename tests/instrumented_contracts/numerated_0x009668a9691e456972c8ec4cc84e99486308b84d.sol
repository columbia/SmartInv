1 pragma solidity 0.8.0;
2 
3 // SPDX-License-Identifier: Unlicensed
4 interface IERC20 {
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
19     function transfer(address recipient, uint256 amount)
20         external
21         returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender)
31         external
32         view
33         returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(
61         address sender,
62         address recipient,
63         uint256 amount
64     ) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(
79         address indexed owner,
80         address indexed spender,
81         uint256 value
82     );
83 
84     event Reflection(uint256 rFee, uint256 rAmount, uint256 rTransferAmount);
85     event TotalFee(uint256 tFee);
86 }
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      *
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(
145         uint256 a,
146         uint256 b,
147         string memory errorMessage
148     ) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      *
163      * - Multiplication cannot overflow.
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167         // benefit is lost if 'b' is also tested.
168         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "SafeMath: multiplication overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         uint256 c = a / b;
214         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return mod(a, b, "SafeMath: modulo by zero");
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts with custom message when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(
248         uint256 a,
249         uint256 b,
250         string memory errorMessage
251     ) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 /**
258  * @dev Provides information about the current execution context, including the
259  * sender of the transaction and its data. While these are generally available
260  * via msg.sender and msg.data, they should not be accessed in such a direct
261  * manner, since when dealing with meta-transactions the account sending and
262  * paying for execution may not be the actual sender (as far as an application
263  * is concerned).
264  *
265  * This contract is only required for intermediate, library-like contracts.
266  */
267 abstract contract Context {
268     function _msgSender() internal view virtual returns (address) {
269         return msg.sender;
270     }
271 
272     function _msgData() internal view virtual returns (bytes calldata) {
273         return msg.data;
274     }
275 }
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly {
306             codehash := extcodehash(account)
307         }
308         return (codehash != accountHash && codehash != 0x0);
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(
329             address(this).balance >= amount,
330             "Address: insufficient balance"
331         );
332 
333         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
334         (bool success, ) = recipient.call{value: amount}("");
335         require(
336             success,
337             "Address: unable to send value, recipient may have reverted"
338         );
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain`call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data)
360         internal
361         returns (bytes memory)
362     {
363         return functionCall(target, data, "Address: low-level call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
368      * `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         return _functionCallWithValue(target, data, 0, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but also transferring `value` wei to `target`.
383      *
384      * Requirements:
385      *
386      * - the calling contract must have an ETH balance of at least `value`.
387      * - the called Solidity function must be `payable`.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value
395     ) internal returns (bytes memory) {
396         return
397             functionCallWithValue(
398                 target,
399                 data,
400                 value,
401                 "Address: low-level call with value failed"
402             );
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(
412         address target,
413         bytes memory data,
414         uint256 value,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(
418             address(this).balance >= value,
419             "Address: insufficient balance for call"
420         );
421         return _functionCallWithValue(target, data, value, errorMessage);
422     }
423 
424     function _functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 weiValue,
428         string memory errorMessage
429     ) private returns (bytes memory) {
430         require(isContract(target), "Address: call to non-contract");
431 
432         // solhint-disable-next-line avoid-low-level-calls
433         (bool success, bytes memory returndata) = target.call{value: weiValue}(
434             data
435         );
436         if (success) {
437             return returndata;
438         } else {
439             // Look for revert reason and bubble it up if present
440             if (returndata.length > 0) {
441                 // The easiest way to bubble the revert reason is using memory via assembly
442 
443                 // solhint-disable-next-line no-inline-assembly
444                 assembly {
445                     let returndata_size := mload(returndata)
446                     revert(add(32, returndata), returndata_size)
447                 }
448             } else {
449                 revert(errorMessage);
450             }
451         }
452     }
453 }
454 
455 /**
456  * @dev Contract module which provides a basic access control mechanism, where
457  * there is an account (an owner) that can be granted exclusive access to
458  * specific functions.
459  *
460  * By default, the owner account will be the one that deploys the contract. This
461  * can later be changed with {transferOwnership}.
462  *
463  * This module is used through inheritance. It will make available the modifier
464  * `onlyOwner`, which can be applied to your functions to restrict their use to
465  * the owner.
466  */
467 contract Ownable is Context {
468     address private _owner;
469     address private _previousOwner;
470     uint256 private _lockTime;
471 
472     event OwnershipTransferred(
473         address indexed previousOwner,
474         address indexed newOwner
475     );
476 
477     /**
478      * @dev Initializes the contract setting the deployer as the initial owner.
479      */
480     constructor() {
481         address msgSender = _msgSender();
482         _owner = msgSender;
483         emit OwnershipTransferred(address(0), msgSender);
484     }
485 
486     /**
487      * @dev Returns the address of the current owner.
488      */
489     function owner() public view returns (address) {
490         return _owner;
491     }
492 
493     /**
494      * @dev Throws if called by any account other than the owner.
495      */
496     modifier onlyOwner() {
497         require(_owner == _msgSender(), "Ownable: caller is not the owner");
498         _;
499     }
500 
501     /**
502      * @dev Leaves the contract without owner. It will not be possible to call
503      * `onlyOwner` functions anymore. Can only be called by the current owner.
504      *
505      * NOTE: Renouncing ownership will leave the contract without an owner,
506      * thereby removing any functionality that is only available to the owner.
507      */
508     function renounceOwnership() public virtual onlyOwner {
509         emit OwnershipTransferred(_owner, address(0));
510         _owner = address(0);
511     }
512 
513     /**
514      * @dev Transfers ownership of the contract to a new account (`newOwner`).
515      * Can only be called by the current owner.
516      */
517     function transferOwnership(address newOwner) public virtual onlyOwner {
518         require(
519             newOwner != address(0),
520             "Ownable: new owner is the zero address"
521         );
522         emit OwnershipTransferred(_owner, newOwner);
523         _owner = newOwner;
524     }
525 
526     function geUnlockTime() public view returns (uint256) {
527         return _lockTime;
528     }
529 
530     //Locks the contract for owner for the amount of time provided
531     function lock(uint256 time) public virtual onlyOwner {
532         _previousOwner = _owner;
533         _owner = address(0);
534         _lockTime = block.timestamp + time;
535         emit OwnershipTransferred(_owner, address(0));
536     }
537 
538     //Unlocks the contract for owner when _lockTime is exceeds
539     function unlock() public virtual {
540         require(
541             _previousOwner == msg.sender,
542             "You don't have permission to unlock"
543         );
544         require(block.timestamp > _lockTime, "Contract is locked until 7 days");
545         emit OwnershipTransferred(_owner, _previousOwner);
546         _owner = _previousOwner;
547     }
548 }
549 
550 contract Terareum is Context, IERC20, Ownable {
551     using SafeMath for uint256;
552     using Address for address;
553 
554     mapping(address => uint256) private _rOwned;
555     mapping(address => uint256) private _tOwned;
556     mapping(address => mapping(address => uint256)) private _allowances;
557 
558     mapping(address => bool) private _isExcludedFromFee;
559 
560     mapping(address => bool) private _isExcluded;
561     address[] private _excluded;
562 
563     address public BURN_ADDRESS = 0x0000000000000000000000000000000000000000;
564     address public MARKET_ADDRESS = 0xd27Aed4D22A6AC0B36FfF66fb682c067CD38E1B4;
565 
566     uint256 private constant MAX = ~uint256(0);
567     uint256 private _tTotal = 100000 * 10**12 * 10**18;
568     uint256 private _rTotal = (MAX - (MAX % _tTotal));
569     uint256 private _tFeeTotal;
570 
571     string private _name = "Terareum";
572     string private _symbol = "TERA";
573     uint8 private _decimals = 18;
574 
575     uint256 public _taxFee = 3; 
576     uint256 private _previousTaxFee = _taxFee;
577 
578     uint256 public _burnFee = 3; 
579     uint256 private _previousBurnFee = _burnFee;
580 
581     uint256 public _marketFee = 3; 
582     uint256 private _previousMarketFee = _marketFee;
583 
584     event TransferBurn(
585         address indexed from,
586         address indexed burnAddress,
587         uint256 value
588     );
589     event TransferMarket(
590         address indexed from,
591         address indexed marketAddress,
592         uint256 value
593     );
594 
595     constructor() {
596         _rOwned[_msgSender()] = _rTotal;
597 
598         //exclude owner and this contract from fee
599         _isExcludedFromFee[owner()] = true;
600         _isExcludedFromFee[address(this)] = true;
601         _isExcluded[address(this)] = true;
602 
603         _isExcludedFromFee[BURN_ADDRESS] = true;
604         _isExcluded[BURN_ADDRESS] = true;
605 
606         _isExcludedFromFee[MARKET_ADDRESS] = true;
607         _isExcluded[MARKET_ADDRESS] = true;
608 
609         emit Transfer(address(0), _msgSender(), _tTotal);
610     }
611 
612     function name() public view returns (string memory) {
613         return _name;
614     }
615 
616     function symbol() public view returns (string memory) {
617         return _symbol;
618     }
619 
620     function decimals() public view returns (uint8) {
621         return _decimals;
622     }
623 
624     function totalSupply() public view override returns (uint256) {
625         return _tTotal;
626     }
627 
628     function balanceOf(address account) public view override returns (uint256) {
629         if (_isExcluded[account]) return _tOwned[account];
630         return tokenFromReflection(_rOwned[account]);
631     }
632 
633     function transfer(address recipient, uint256 amount)
634         public
635         override
636         returns (bool)
637     {
638         _transfer(_msgSender(), recipient, amount);
639         return true;
640     }
641 
642     function allowance(address owner, address spender)
643         public
644         view
645         override
646         returns (uint256)
647     {
648         return _allowances[owner][spender];
649     }
650 
651     function approve(address spender, uint256 amount)
652         public
653         override
654         returns (bool)
655     {
656         _approve(_msgSender(), spender, amount);
657         return true;
658     }
659 
660     function transferFrom(
661         address sender,
662         address recipient,
663         uint256 amount
664     ) public override returns (bool) {
665         _transfer(sender, recipient, amount);
666         _approve(
667             sender,
668             _msgSender(),
669             _allowances[sender][_msgSender()].sub(
670                 amount,
671                 "ERC20: transfer amount exceeds allowance"
672             )
673         );
674         return true;
675     }
676 
677     function increaseAllowance(address spender, uint256 addedValue)
678         public
679         virtual
680         returns (bool)
681     {
682         _approve(
683             _msgSender(),
684             spender,
685             _allowances[_msgSender()][spender].add(addedValue)
686         );
687         return true;
688     }
689 
690     function decreaseAllowance(address spender, uint256 subtractedValue)
691         public
692         virtual
693         returns (bool)
694     {
695         _approve(
696             _msgSender(),
697             spender,
698             _allowances[_msgSender()][spender].sub(
699                 subtractedValue,
700                 "ERC20: decreased allowance below zero"
701             )
702         );
703         return true;
704     }
705 
706     function isExcludedFromReward(address account) public view returns (bool) {
707         return _isExcluded[account];
708     }
709 
710     function totalFees() public view returns (uint256) {
711         return _tFeeTotal;
712     }
713 
714     function totalBurned() public view returns (uint256) {
715         return balanceOf(BURN_ADDRESS);
716     }
717 
718     function totalMarketBalance() public view returns (uint256) {
719         return balanceOf(MARKET_ADDRESS);
720     } 
721 
722     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
723         public
724         view
725         returns (uint256)
726     {
727         require(tAmount <= _tTotal, "Amount must be less than supply");
728         if (!deductTransferFee) {
729             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
730             return rAmount;
731         } else {
732             (, uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
733             return rTransferAmount;
734         }
735     }
736 
737     function tokenFromReflection(uint256 rAmount)
738         public
739         view
740         returns (uint256)
741     {
742         require(
743             rAmount <= _rTotal,
744             "Amount must be less than total reflections"
745         );
746         uint256 currentRate = _getRate();
747         return rAmount.div(currentRate);
748     }
749 
750     function excludeFromReward(address account) public onlyOwner {
751         require(!_isExcluded[account], "Account is already excluded");
752         if (_rOwned[account] > 0) {
753             _tOwned[account] = tokenFromReflection(_rOwned[account]);
754         }
755         _isExcluded[account] = true;
756         _excluded.push(account);
757     }
758 
759     function includeInReward(address account) external onlyOwner {
760         require(_isExcluded[account], "Account is already excluded");
761         for (uint256 i = 0; i < _excluded.length; i++) {
762             if (_excluded[i] == account) {
763                 _excluded[i] = _excluded[_excluded.length - 1];
764                 _tOwned[account] = 0;
765                 _isExcluded[account] = false;
766                 _excluded.pop();
767                 break;
768             }
769         }
770     }
771     function excludeFromFee(address account) public onlyOwner {
772         _isExcludedFromFee[account] = true;
773     }
774 
775     function includeInFee(address account) public onlyOwner {
776         _isExcludedFromFee[account] = false;
777     }
778 
779     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
780         _taxFee = taxFee;
781     }
782 
783     function setBurnFeePercent(uint256 burnFee) external onlyOwner {
784         _burnFee = burnFee;
785     }
786 
787     function setMarketFeePercent(uint256 marketFee) external onlyOwner {
788         _marketFee = marketFee;
789     }
790 
791     //to recieve ETH from uniswapV2Router when swaping
792     receive() external payable {}
793 
794     function _reflectFee(uint256 rFee, uint256 tFee) private {
795         _rTotal = _rTotal.sub(rFee);
796         _tFeeTotal = _tFeeTotal.add(tFee);
797     }
798 
799     function _getValues(uint256 tAmount)
800         private
801         view
802         returns (
803             uint256,
804             uint256,
805             uint256,
806             uint256,
807             uint256,
808             uint256,
809             uint256
810         )
811     {
812         (
813             uint256 tTransferAmount,
814             uint256 tFee,
815             uint256 tBurn,
816             uint256 tMarket
817         ) = _getTValues(tAmount);
818         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
819             tAmount,
820             tFee,
821             tBurn,
822             tMarket,
823             _getRate()
824         );
825         return (
826             rAmount,
827             rTransferAmount,
828             rFee,
829             tTransferAmount,
830             tFee,
831             tBurn,
832             tMarket
833         );
834     }
835 
836     function _getTValues(uint256 tAmount)
837         private
838         view
839         returns (
840             uint256,
841             uint256,
842             uint256,
843             uint256
844         )
845     {
846         uint256 tFee = calculateTaxFee(tAmount);
847         uint256 tBurn = calculateBurnFee(tAmount);
848         uint256 tMarket = calculateMarketFee(tAmount);
849         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tMarket);
850         return (tTransferAmount, tFee, tBurn, tMarket);
851     }
852 
853     function _getRValues(
854         uint256 tAmount,
855         uint256 tFee,
856         uint256 tBurn,
857         uint256 tMarket,
858         uint256 currentRate
859     )
860         private
861         pure
862         returns (
863             uint256,
864             uint256,
865             uint256
866         )
867     {
868         uint256 rAmount = tAmount.mul(currentRate);
869         uint256 rFee = tFee.mul(currentRate);
870         uint256 rBurn = tBurn.mul(currentRate);
871         uint256 rMarket = tMarket.mul(currentRate);
872         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rMarket);
873         return (rAmount, rTransferAmount, rFee);
874     }
875 
876     function _getRate() private view returns (uint256) {
877         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
878         return rSupply.div(tSupply);
879     }
880 
881     function _getCurrentSupply() private view returns (uint256, uint256) {
882         uint256 rSupply = _rTotal;
883         uint256 tSupply = _tTotal;
884         for (uint256 i = 0; i < _excluded.length; i++) {
885             if (
886                 _rOwned[_excluded[i]] > rSupply ||
887                 _tOwned[_excluded[i]] > tSupply
888             ) return (_rTotal, _tTotal);
889             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
890             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
891         }
892         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
893         return (rSupply, tSupply);
894     }
895 
896     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
897         return _amount.mul(_taxFee).div(10**2);
898     }
899 
900     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
901         return _amount.mul(_burnFee).div(10**2);
902     }
903 
904     function calculateMarketFee(uint256 _amount)
905         private
906         view
907         returns (uint256)
908     {
909         return _amount.mul(_marketFee).div(10**2);
910     }
911 
912     function removeAllFee() private {
913         if (_taxFee == 0) return;
914 
915         _previousTaxFee = _taxFee;
916         _taxFee = 0;
917 
918         _previousBurnFee = _burnFee;
919         _burnFee = 0;
920 
921         _previousMarketFee = _marketFee;
922         _marketFee = 0;
923     }
924 
925     function restoreAllFee() private {
926         _taxFee = _previousTaxFee;
927         _marketFee = _previousMarketFee;
928         _burnFee = _previousBurnFee;
929     }
930 
931     function isExcludedFromFee(address account) public view returns (bool) {
932         return _isExcludedFromFee[account];
933     }
934 
935     function _approve(
936         address owner,
937         address spender,
938         uint256 amount
939     ) private {
940         require(owner != address(0), "ERC20: approve from the zero address");
941         require(spender != address(0), "ERC20: approve to the zero address");
942 
943         _allowances[owner][spender] = amount;
944         emit Approval(owner, spender, amount);
945     }
946 
947     function _transfer(
948         address from,
949         address to,
950         uint256 amount
951     ) private {
952         require(from != address(0), "ERC20: transfer from the zero address");
953         require(to != address(0), "ERC20: transfer to the zero address");
954         require(amount > 0, "Transfer amount must be greater than zero");
955 
956         //indicates if fee should be deducted from transfer
957         bool takeFee = true;
958 
959         //if any account belongs to _isExcludedFromFee account then remove the fee
960         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
961             takeFee = false;
962         }
963 
964         //transfer amount, it will take tax, burn, liquidity fee
965         _tokenTransfer(from, to, amount, takeFee);
966     }
967 
968     //this method is responsible for taking all fee, if takeFee is true
969     function _tokenTransfer(
970         address sender,
971         address recipient,
972         uint256 amount,
973         bool takeFee
974     ) private {
975         if (!takeFee) removeAllFee();
976 
977         if (_isExcluded[sender] && !_isExcluded[recipient]) {
978             _transferFromExcluded(sender, recipient, amount);
979         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
980             _transferToExcluded(sender, recipient, amount);
981         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
982             _transferStandard(sender, recipient, amount);
983         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
984             _transferBothExcluded(sender, recipient, amount);
985         } else {
986             _transferStandard(sender, recipient, amount);
987         }
988 
989         if (!takeFee) restoreAllFee();
990     }
991 
992     function _transferStandard(
993         address sender,
994         address recipient,
995         uint256 tAmount
996     ) private {
997         (
998             uint256 rAmount,
999             uint256 rTransferAmount,
1000             uint256 rFee,
1001             uint256 tTransferAmount,
1002             uint256 tFee,
1003             uint256 tBurn,
1004             uint256 tMarket
1005         ) = _getValues(tAmount);
1006         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1007         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1008         _reflectFee(rFee, tFee);
1009         _transferMarketFee(tMarket);
1010         _transferBurnFee(tBurn);
1011         emit TransferBurn(sender, BURN_ADDRESS, tBurn);
1012         emit TransferMarket(sender, MARKET_ADDRESS, tMarket);
1013         emit Transfer(sender, recipient, tTransferAmount);
1014     }
1015 
1016     function _transferToExcluded(
1017         address sender,
1018         address recipient,
1019         uint256 tAmount
1020     ) private {
1021         (
1022             uint256 rAmount,
1023             uint256 rTransferAmount,
1024             uint256 rFee,
1025             uint256 tTransferAmount,
1026             uint256 tFee,
1027             uint256 tBurn,
1028             uint256 tMarket
1029         ) = _getValues(tAmount);
1030         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1031         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1032         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1033         _reflectFee(rFee, tFee);
1034         _transferMarketFee(tMarket);
1035         _transferBurnFee(tBurn);
1036         emit TransferBurn(sender, BURN_ADDRESS, tBurn);
1037         emit TransferMarket(sender, MARKET_ADDRESS, tMarket);
1038         emit Transfer(sender, recipient, tTransferAmount);
1039     }
1040 
1041     function _transferFromExcluded(
1042         address sender,
1043         address recipient,
1044         uint256 tAmount
1045     ) private {
1046         (
1047             uint256 rAmount,
1048             uint256 rTransferAmount,
1049             uint256 rFee,
1050             uint256 tTransferAmount,
1051             uint256 tFee,
1052             uint256 tBurn,
1053             uint256 tMarket
1054         ) = _getValues(tAmount);
1055         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1056         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1057         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1058         _reflectFee(rFee, tFee);
1059         _transferMarketFee(tMarket);
1060         _transferBurnFee(tBurn);
1061         emit TransferBurn(sender, BURN_ADDRESS, tBurn);
1062         emit TransferMarket(sender, MARKET_ADDRESS, tMarket);
1063         emit Transfer(sender, recipient, tTransferAmount);
1064     }
1065 
1066     function _transferBothExcluded(
1067         address sender,
1068         address recipient,
1069         uint256 tAmount
1070     ) private {
1071         (
1072             uint256 rAmount,
1073             uint256 rTransferAmount,
1074             uint256 rFee,
1075             uint256 tTransferAmount,
1076             uint256 tFee,
1077             uint256 tBurn,
1078             uint256 tMarket
1079         ) = _getValues(tAmount);
1080         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1081         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1082         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1083         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1084         _reflectFee(rFee, tFee);
1085         emit TransferBurn(sender, BURN_ADDRESS, tBurn);
1086         emit TransferMarket(sender, MARKET_ADDRESS, tMarket);
1087         emit Transfer(sender, recipient, tTransferAmount);
1088     }
1089 
1090     function _transferMarketFee(uint256 tMarket) private {
1091         uint256 currentRate = _getRate();
1092         uint256 rMarket = tMarket.mul(currentRate);
1093         _rOwned[MARKET_ADDRESS] = _rOwned[MARKET_ADDRESS].add(rMarket);
1094         if (_isExcluded[MARKET_ADDRESS])
1095             _tOwned[MARKET_ADDRESS] = _tOwned[MARKET_ADDRESS].add(tMarket);
1096     }
1097 
1098     function _transferBurnFee(uint256 tBurn) private {
1099         uint256 currentRate = _getRate();
1100         uint256 rBurn = tBurn.mul(currentRate);
1101         _rOwned[BURN_ADDRESS] = _rOwned[BURN_ADDRESS].add(rBurn);
1102         if (_isExcluded[BURN_ADDRESS])
1103             _tOwned[BURN_ADDRESS] = _tOwned[BURN_ADDRESS].add(tBurn);
1104     }
1105 }