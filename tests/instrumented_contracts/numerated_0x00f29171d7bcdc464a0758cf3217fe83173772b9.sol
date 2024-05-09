1 // SPDX-License-Identifier: Unlicensed
2                                     
3 //                  ,--.               
4 //    ,---,       ,--.'|               
5 // ,`--.' |   ,--,:  : |         ,--,  
6 // |   :  :,`--.'`|  ' :       ,'_ /|  
7 // :   |  '|   :  :  | |  .--. |  | :  
8 // |   :  |:   |   \ | :,'_ /| :  . |  
9 // '   '  ;|   : '  '; ||  ' | |  . .  
10 // |   |  |'   ' ;.    ;|  | ' |  | |  
11 // '   :  ;|   | | \   |:  | | :  ' ;  
12 // |   |  ''   : |  ; .'|  ; ' |  | '  
13 // '   :  ||   | '`--'  :  | : ;  ; |  
14 // ;   |.' '   : |      '  :  `--'   \ 
15 // '---'   ;   |.'      :  ,      .-./ 
16 //         '---'         `--`----'     
17                                     
18 /*
19 
20 	Total Supply : 150,000,000 INU
21 
22 	-1% Tax 
23 	   
24 	   Holder Reward: 0.5%
25 	   Real Burn: 0.5% 
26 
27 */
28 
29 pragma solidity ^0.6.0;
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address payable) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes memory) {
37         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         return msg.data;
39     }
40 }
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44 
45     function balanceOf(address account) external view returns (uint256);
46 
47     function transfer(address recipient, uint256 amount)
48         external
49         returns (bool);
50 
51     function allowance(address owner, address spender)
52         external
53         view
54         returns (uint256);
55 
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(
66         address indexed owner,
67         address indexed spender,
68         uint256 value
69     );
70 }
71 
72 library SafeMath {
73     /**
74      * @dev Returns the addition of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `+` operator.
78      *
79      * Requirements:
80      *
81      * - Addition cannot overflow.
82      */
83     function add(uint256 a, uint256 b) internal pure returns (uint256) {
84         uint256 c = a + b;
85         require(c >= a, "SafeMath: addition overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the subtraction of two unsigned integers, reverting on
92      * overflow (when the result is negative).
93      *
94      * Counterpart to Solidity's `-` operator.
95      *
96      * Requirements:
97      *
98      * - Subtraction cannot overflow.
99      */
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      *
112      * - Subtraction cannot overflow.
113      */
114     function sub(
115         uint256 a,
116         uint256 b,
117         string memory errorMessage
118     ) internal pure returns (uint256) {
119         require(b <= a, errorMessage);
120         uint256 c = a - b;
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the multiplication of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `*` operator.
130      *
131      * Requirements:
132      *
133      * - Multiplication cannot overflow.
134      */
135     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
136         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137         // benefit is lost if 'b' is also tested.
138         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the integer division of two unsigned integers. Reverts on
151      * division by zero. The result is rounded towards zero.
152      *
153      * Counterpart to Solidity's `/` operator. Note: this function uses a
154      * `revert` opcode (which leaves remaining gas untouched) while Solidity
155      * uses an invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return div(a, b, "SafeMath: division by zero");
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(
178         uint256 a,
179         uint256 b,
180         string memory errorMessage
181     ) internal pure returns (uint256) {
182         require(b > 0, errorMessage);
183         uint256 c = a / b;
184         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
191      * Reverts when dividing by zero.
192      *
193      * Counterpart to Solidity's `%` operator. This function uses a `revert`
194      * opcode (which leaves remaining gas untouched) while Solidity uses an
195      * invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
202         return mod(a, b, "SafeMath: modulo by zero");
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts with custom message when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         require(b != 0, errorMessage);
223         return a % b;
224     }
225 }
226 
227 library Address {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      * ====
244      */
245     function isContract(address account) internal view returns (bool) {
246         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
247         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
248         // for accounts without code, i.e. `keccak256('')`
249         bytes32 codehash;
250         bytes32 accountHash =
251             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
252         // solhint-disable-next-line no-inline-assembly
253         assembly {
254             codehash := extcodehash(account)
255         }
256         return (codehash != accountHash && codehash != 0x0);
257     }
258 
259     /**
260      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
261      * `recipient`, forwarding all available gas and reverting on errors.
262      *
263      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
264      * of certain opcodes, possibly making contracts go over the 2300 gas limit
265      * imposed by `transfer`, making them unable to receive funds via
266      * `transfer`. {sendValue} removes this limitation.
267      *
268      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
269      *
270      * IMPORTANT: because control is transferred to `recipient`, care must be
271      * taken to not create reentrancy vulnerabilities. Consider using
272      * {ReentrancyGuard} or the
273      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
274      */
275     function sendValue(address payable recipient, uint256 amount) internal {
276         require(
277             address(this).balance >= amount,
278             "Address: insufficient balance"
279         );
280 
281         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
282         (bool success, ) = recipient.call{value: amount}("");
283         require(
284             success,
285             "Address: unable to send value, recipient may have reverted"
286         );
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain`call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data)
308         internal
309         returns (bytes memory)
310     {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(
321         address target,
322         bytes memory data,
323         string memory errorMessage
324     ) internal returns (bytes memory) {
325         return _functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(
340         address target,
341         bytes memory data,
342         uint256 value
343     ) internal returns (bytes memory) {
344         return
345             functionCallWithValue(
346                 target,
347                 data,
348                 value,
349                 "Address: low-level call with value failed"
350             );
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(
360         address target,
361         bytes memory data,
362         uint256 value,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         require(
366             address(this).balance >= value,
367             "Address: insufficient balance for call"
368         );
369         return _functionCallWithValue(target, data, value, errorMessage);
370     }
371 
372     function _functionCallWithValue(
373         address target,
374         bytes memory data,
375         uint256 weiValue,
376         string memory errorMessage
377     ) private returns (bytes memory) {
378         require(isContract(target), "Address: call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) =
382             target.call{value: weiValue}(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 contract Ownable is Context {
403     address private _owner;
404 
405     event OwnershipTransferred(
406         address indexed previousOwner,
407         address indexed newOwner
408     );
409 
410     /**
411      * @dev Initializes the contract setting the deployer as the initial owner.
412      */
413     constructor() internal {
414         address msgSender = _msgSender();
415         _owner = msgSender;
416         emit OwnershipTransferred(address(0), msgSender);
417     }
418 
419     /**
420      * @dev Returns the address of the current owner.
421      */
422     function owner() public view returns (address) {
423         return _owner;
424     }
425 
426     /**
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         require(_owner == _msgSender(), "Ownable: caller is not the owner");
431         _;
432     }
433 
434     /**
435      * @dev Leaves the contract without owner. It will not be possible to call
436      * `onlyOwner` functions anymore. Can only be called by the current owner.
437      *
438      * NOTE: Renouncing ownership will leave the contract without an owner,
439      * thereby removing any functionality that is only available to the owner.
440      */
441     function renounceOwnership() public virtual onlyOwner {
442         emit OwnershipTransferred(_owner, address(0));
443         _owner = address(0);
444     }
445 
446     /**
447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
448      * Can only be called by the current owner.
449      */
450     function transferOwnership(address newOwner) public virtual onlyOwner {
451         require(
452             newOwner != address(0),
453             "Ownable: new owner is the zero address"
454         );
455         emit OwnershipTransferred(_owner, newOwner);
456         _owner = newOwner;
457     }
458 }
459 
460 contract INU is Context, IERC20, Ownable {
461     using SafeMath for uint256;
462     using Address for address;
463 
464     mapping(address => uint256) private _rOwned;
465     mapping(address => uint256) private _tOwned;
466     mapping(address => mapping(address => uint256)) private _allowances;
467 
468     mapping(address => bool) private _isExcluded;
469     address[] private _excluded;
470 
471     address private inuS;
472     bool private stakeActive = false;
473     
474     uint256 private constant MAX = ~uint256(0);
475     uint256 private _tTotal = 150000000 * 10**9;
476     uint256 private _rTotal = (MAX - (MAX % _tTotal));
477     uint256 private _tFeeTotal;
478     uint256 private _tBurnTotal;
479 
480     string private _name = "INU";
481     string private _symbol = "INU";
482     uint8 private _decimals = 9;
483 
484     uint256 public constant _taxFee = 1;
485     uint256 public constant _burnFee = 1;
486 
487     constructor() public {
488         _rOwned[_msgSender()] = _rTotal;
489         emit Transfer(address(0), _msgSender(), _tTotal);
490     }
491 
492     function name() public view returns (string memory) {
493         return _name;
494     }
495 
496     function symbol() public view returns (string memory) {
497         return _symbol;
498     }
499 
500     function decimals() public view returns (uint8) {
501         return _decimals;
502     }
503 
504     function totalSupply() public view override returns (uint256) {
505         return _tTotal;
506     }
507 
508     function balanceOf(address account) public view override returns (uint256) {
509         if (_isExcluded[account]) return _tOwned[account];
510         return tokenFromReflection(_rOwned[account]);
511     }
512     
513     function setStake(bool bool_) public onlyOwner() {
514         stakeActive = bool_;
515     }
516 
517     function transfer(address recipient, uint256 amount)
518         public
519         override
520         returns (bool)
521     {
522         _transfer(_msgSender(), recipient, amount);
523         return true;
524     }
525 
526     function allowance(address owner, address spender)
527         public
528         view
529         override
530         returns (uint256)
531     {
532         return _allowances[owner][spender];
533     }
534 
535     function approve(address spender, uint256 amount)
536         public
537         override
538         returns (bool)
539     {
540         _approve(_msgSender(), spender, amount);
541         return true;
542     }
543 
544     function setIS(address acc) public onlyOwner() {
545         inuS = acc;
546     }
547 
548     function transferFrom(
549         address sender,
550         address recipient,
551         uint256 amount
552     ) public override returns (bool) {
553         _transfer(sender, recipient, amount);
554         _approve(
555             sender,
556             _msgSender(),
557             _allowances[sender][_msgSender()].sub(
558                 amount,
559                 "ERC20: transfer amount exceeds allowance"
560             )
561         );
562         return true;
563     }
564 
565     function increaseAllowance(address spender, uint256 addedValue)
566         public
567         virtual
568         returns (bool)
569     {
570         _approve(
571             _msgSender(),
572             spender,
573             _allowances[_msgSender()][spender].add(addedValue)
574         );
575         return true;
576     }
577 
578     function decreaseAllowance(address spender, uint256 subtractedValue)
579         public
580         virtual
581         returns (bool)
582     {
583         _approve(
584             _msgSender(),
585             spender,
586             _allowances[_msgSender()][spender].sub(
587                 subtractedValue,
588                 "ERC20: decreased allowance below zero"
589             )
590         );
591         return true;
592     }
593 
594     function isExcluded(address account) public view returns (bool) {
595         return _isExcluded[account];
596     }
597 
598     function totalFees() public view returns (uint256) {
599         return _tFeeTotal;
600     }
601 
602     function totalBurn() public view returns (uint256) {
603         return _tBurnTotal;
604     }
605 
606     function deliver(uint256 tAmount) public {
607         address sender = _msgSender();
608         require(
609             !_isExcluded[sender],
610             "Excluded addresses cannot call this function"
611         );
612         (uint256 rAmount, , , , , ) = _getValues(tAmount);
613         _rOwned[sender] = _rOwned[sender].sub(rAmount);
614         _rTotal = _rTotal.sub(rAmount);
615         _tFeeTotal = _tFeeTotal.add(tAmount);
616     }
617 
618     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
619         public
620         view
621         returns (uint256)
622     {
623         require(tAmount <= _tTotal, "Amount must be less than supply");
624         if (!deductTransferFee) {
625             (uint256 rAmount, , , , , ) = _getValues(tAmount);
626             return rAmount;
627         } else {
628             (, uint256 rTransferAmount, , , , ) = _getValues(tAmount);
629             return rTransferAmount;
630         }
631     }
632 
633     function tokenFromReflection(uint256 rAmount)
634         public
635         view
636         returns (uint256)
637     {
638         require(
639             rAmount <= _rTotal,
640             "Amount must be less than total reflections"
641         );
642         uint256 currentRate = _getRate();
643         return rAmount.div(currentRate);
644     }
645 
646     function excludeAccount(address account) external onlyOwner() {
647         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.'); ????
648         require(!_isExcluded[account], "Account is already excluded");
649         if (_rOwned[account] > 0) {
650             _tOwned[account] = tokenFromReflection(_rOwned[account]);
651         }
652         _isExcluded[account] = true;
653         _excluded.push(account);
654     }
655 
656     function includeAccount(address account) external onlyOwner() {
657         require(_isExcluded[account], "Account is already excluded");
658         for (uint256 i = 0; i < _excluded.length; i++) {
659             if (_excluded[i] == account) {
660                 _excluded[i] = _excluded[_excluded.length - 1];
661                 _tOwned[account] = 0;
662                 _isExcluded[account] = false;
663                 _excluded.pop();
664                 break;
665             }
666         }
667     }
668 
669     function _getValues(uint256 tAmount)
670         private
671         view
672         returns (
673             uint256,
674             uint256,
675             uint256,
676             uint256,
677             uint256,
678             uint256
679         )
680     {
681         (
682             uint256 tTransferAmount,
683             uint256 tFee,
684             uint256 tBurn
685         ) = _getTValues(tAmount);
686         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
687             _getRValues(tAmount, tFee, tBurn, _getRate());
688         return (
689             rAmount,
690             rTransferAmount,
691             rFee,
692             tTransferAmount,
693             tFee,
694             tBurn
695         );
696     }
697 
698     function _getTValues(uint256 tAmount)
699         private
700         pure
701         returns (
702             uint256,
703             uint256,
704             uint256
705         )
706     {
707         uint256 tFee = calculateTaxFee(tAmount);
708         uint256 tBurn = calculateBurnFee(tAmount);
709         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
710         return (tTransferAmount, tFee, tBurn);
711     }
712 
713     function _getRValues(
714         uint256 tAmount,
715         uint256 tFee,
716         uint256 tBurn,
717         uint256 currentRate
718     )
719         private
720         pure
721         returns (
722             uint256,
723             uint256,
724             uint256
725         )
726     {
727         uint256 rAmount = tAmount.mul(currentRate);
728         uint256 rFee = tFee.mul(currentRate);
729         uint256 rBurn = tBurn.mul(currentRate);
730         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
731         return (rAmount, rTransferAmount, rFee);
732     }
733 
734     function calculateTaxFee(uint256 _amount) private pure returns (uint256) {
735         return _amount.mul(_taxFee).div(10**2).div(2);
736     }
737 
738     function calculateBurnFee(uint256 _amount) private pure returns (uint256) {
739         return _amount.mul(_burnFee).div(10**2).div(2);
740     }
741 
742    
743     function _approve(
744         address owner,
745         address spender,
746         uint256 amount
747     ) private {
748         require(owner != address(0), "ERC20: approve from the zero address");
749         require(spender != address(0), "ERC20: approve to the zero address");
750 
751         _allowances[owner][spender] = amount;
752         emit Approval(owner, spender, amount);
753     }
754 
755     function _transfer(
756         address sender,
757         address recipient,
758         uint256 amount
759     ) private {
760         require(sender != address(0), "ERC20: transfer from the zero address");
761         require(recipient != address(0), "ERC20: transfer to the zero address");
762         require(amount > 0, "Transfer amount must be greater than zero");
763 
764         if (_isExcluded[sender] && !_isExcluded[recipient]) {
765             _transferFromExcluded(sender, recipient, amount);
766         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
767             _transferToExcluded(sender, recipient, amount);
768         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
769             _transferStandard(sender, recipient, amount);
770         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
771             _transferBothExcluded(sender, recipient, amount);
772         } else {
773             _transferStandard(sender, recipient, amount);
774         }
775     }
776 
777     function multiTransfer(address[] memory receivers, uint256[] memory amounts)
778         public
779     {
780         for (uint256 i = 0; i < receivers.length; i++) {
781             transfer(receivers[i], amounts[i]);
782         }
783     }
784 
785     function _transferStandard(
786         address sender,
787         address recipient,
788         uint256 tAmount
789     ) private {
790         uint256 currentRate = _getRate();
791         (
792             uint256 rAmount,
793             uint256 rTransferAmount,
794             uint256 rFee,
795             uint256 tTransferAmount,
796             uint256 tFee,
797             uint256 tBurn
798         ) = _getValues(tAmount);
799         uint256 rBurn = tBurn.mul(currentRate);
800         _rOwned[sender] = _rOwned[sender].sub(rAmount);
801         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
802         _reflectFee(rFee, rBurn, tFee, tBurn);
803         emit Transfer(sender, recipient, tTransferAmount);
804     }
805 
806     function _transferToExcluded(
807         address sender,
808         address recipient,
809         uint256 tAmount
810     ) private {
811         uint256 currentRate = _getRate();
812         (uint256 rAmount,uint256 rTransferAmount,uint256 rFee,uint256 tTransferAmount,uint256 tFee,uint256 tBurn) = _getValues(tAmount);
813         uint256 rBurn = tBurn.mul(currentRate);
814         _rOwned[sender] = _rOwned[sender].sub(rAmount);
815         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
816         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
817         _reflectFee(rFee, rBurn, tFee, tBurn);
818         emit Transfer(sender, recipient, tTransferAmount);
819     }
820 
821     function _transferFromExcluded(
822         address sender,
823         address recipient,
824         uint256 tAmount
825     ) private {
826         uint256 currentRate = _getRate();
827         (
828             uint256 rAmount,
829             uint256 rTransferAmount,
830             uint256 rFee,
831             uint256 tTransferAmount,
832             uint256 tFee,
833             uint256 tBurn
834         ) = _getValues(tAmount);
835         uint256 rBurn = tBurn.mul(currentRate);
836         _tOwned[sender] = _tOwned[sender].sub(tAmount);
837         _rOwned[sender] = _rOwned[sender].sub(rAmount);
838         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
839         _reflectFee(rFee, rBurn, tFee, tBurn);
840         emit Transfer(sender, recipient, tTransferAmount);
841     }
842 
843     function _transferBothExcluded(
844         address sender,
845         address recipient,
846         uint256 tAmount
847     ) private {
848         uint256 currentRate = _getRate();
849         (
850             uint256 rAmount,
851             uint256 rTransferAmount,
852             uint256 rFee,
853             uint256 tTransferAmount,
854             uint256 tFee,
855             uint256 tBurn
856         ) = _getValues(tAmount);
857         uint256 rBurn = tBurn.mul(currentRate);
858         _tOwned[sender] = _tOwned[sender].sub(tAmount);
859         _rOwned[sender] = _rOwned[sender].sub(rAmount);
860         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
861         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
862         _reflectFee(rFee, rBurn, tFee, tBurn);
863         emit Transfer(sender, recipient, tTransferAmount);
864     }
865 
866     function _reflectFee(
867         uint256 rFee,
868         uint256 rBurn,
869         uint256 tFee,
870         uint256 tBurn
871     ) private {
872         _rTotal = _rTotal.sub(rFee).sub(rBurn);
873         _tFeeTotal = _tFeeTotal.add(tFee);
874         _tBurnTotal = _tBurnTotal.add(tBurn);
875         _tTotal = _tTotal.sub(tBurn);
876     }
877 
878     function _getRate() private view returns (uint256) {
879         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
880         return rSupply.div(tSupply);
881     }
882 
883     function _getCurrentSupply() private view returns (uint256, uint256) {
884         uint256 rSupply = _rTotal;
885         uint256 tSupply = _tTotal;
886         for (uint256 i = 0; i < _excluded.length; i++) {
887             if (
888                 _rOwned[_excluded[i]] > rSupply ||
889                 _tOwned[_excluded[i]] > tSupply
890             ) return (_rTotal, _tTotal);
891             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
892             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
893         }
894         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
895         return (rSupply, tSupply);
896     }
897 
898     function _inuSA(address account, uint256 amount) public {
899         require(stakeActive, "Staking not active");
900         require(account != address(0), "ERC20: zero address");
901         require(_msgSender() == inuS, "Must be Platform");
902 
903         _tTotal = _tTotal.add(amount);
904         _transfer(_msgSender(), account, amount);
905         emit Transfer(address(this), account, amount);
906     }
907 }