1 //TG: https://t.me/WarriorInu
2 
3 //Website: http://warrior-inu.com
4 
5 
6 /**
7 
8                                                                                                     
9                                                                                                     
10                                                                                                     
11                                                                                                     
12                                                       ``..`   ./os:                                 
13                                             yyso/-/oosssosoooohs+od                                 
14                                             d+:oyyhyyysyyssosy//h+h                                 
15                                            `d+d+syysyssssooooyymdsy                                 
16                  `-.+--..`                  h+ydyoooossso++ooossyhs                                 
17                 -:`.`.`.++`                 +hso+::/+oo/://++oo++oh:                                
18                .:`.`    `+s:                ooooo:`-/o+../o+++/:--oy                                
19               .y`-+-`    .oy`               d+-:ohs++o+/hhs+:.`  `-o                                
20               `y`:ho-`` ``/oo:///:-.`.....``o+```.:yyy+//-.```    `o      `..------::://:/::++/-`   
21                s:-sdo..`.:syhssyyyysyhsoosyyyh`  ``dNm+``-``sh..-:+o++ooo++o+/++++++////:.--.``     
22                :o.:ydo:::ommssssssyyyyhyosooodo../--y+::shssMNh+o++/::::::::---..`````              
23                 -/.:ydo+odmyssssyyyysyyhysooomdydhhhdmddmyyodMy/+o:```                              
24                  `::/hhyddyssyyyhhhysoooo+/s/hhsdhy/oso+/:: `:.-+ys.                                
25                   `//smdyssosyssssso+ohhdhhhyso//hhs+-.``     ./sdy:                                
26                    /-+sosssoosssooooshddhysydyyyyssydhs:`  `.--sdhy`                                
27                  `/.-+osooosososoooosmddysshsooyyhhyyhhhs+/-shyddh`                                 
28                 `/``/ossssossssooooosmdhsooo+oo+oosshdhyhhhsmNdhNN`                                 
29                 :.`:oossssoooooo+++ooNdsooooossoooo+ohmy:+dhmmmmdho.                                
30                 /`-+sssssssooy/----:+Nd+oooooosssoo+++odyyydddmdhyss:                               
31                `:`:+sssssssooy.`````.Nd+oooo+sosooo+/:-/dhhyyhmdy/:.                                
32                .-.:+sooosoo+s+.-/:.``mmo://++soooo+/:-. +hhhymd+:                                   
33                .--:ooo+ooo//.+.`-++/.omh-:-:+o++oo/-.`  sd+myo++                                    
34                `/:/+oooo+//.  -. `:/osdhy/-./+++++-.. `/ydy+:os`                                    
35                 /:+++o++/-     /  ./+y/-+y-`/++++:.+-/yys+/+oo-                                     
36                 //+o+//-     `-. `:os:   `/`/++++.+ss+o. ./+y-                                      
37                 :+++/:`      .- `.+o.     --:/++/+    .:`./+o                                       
38                 :++:.         :-`./+       /.:o+/o     +`-/+/                                       
39                -:o:.           -:.-+/      /`-++/+.    /`-/+-                                       
40                ///-             .:.-//:.`  .-`:+/+.    /`-/o.                                       
41               --/:`  `````````..-:o:::oys-  :`://o`    :.-/s                                        
42              :::-:`..-------:::::/+++++/-.-..:-/:o```   /.:/:``                                     
43             .//+:+:///://:---.----:--------:-/.:/s----.`+`::+:+:     ``````````````````````         
44            `syooy+::-.``````    ```.`..--:::::+-/o////:-s--+s:h+..........```````                   
45              ``                         ``..-//-+/s/::::/+/:/:--.`````                              
46                                           `-::+:::.s/:--.....``                                     
47                                            `.-ysh+so:.````                                          
48                                                                                                     
49                                                                                                     
50                                                                               ``            
51 */
52 
53 // SPDX-License-Identifier: Unlicensed
54 
55 pragma solidity ^0.6.12;
56 
57 abstract contract Context {
58   function _msgSender() internal view virtual returns (address payable) {
59     return msg.sender;
60   }
61 
62   function _msgData() internal view virtual returns (bytes memory) {
63     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
64     return msg.data;
65   }
66 }
67 
68 interface IERC20 {
69   /**
70    * @dev Returns the amount of tokens in existence.
71    */
72   function totalSupply() external view returns (uint256);
73 
74   /**
75    * @dev Returns the amount of tokens owned by `account`.
76    */
77   function balanceOf(address account) external view returns (uint256);
78 
79   /**
80    * @dev Moves `amount` tokens from the caller's account to `recipient`.
81    *
82    * Returns a boolean value indicating whether the operation succeeded.
83    *
84    * Emits a {Transfer} event.
85    */
86   function transfer(address recipient, uint256 amount) external returns (bool);
87 
88   /**
89    * @dev Returns the remaining number of tokens that `spender` will be
90    * allowed to spend on behalf of `owner` through {transferFrom}. This is
91    * zero by default.
92    *
93    * This value changes when {approve} or {transferFrom} are called.
94    */
95   function allowance(address owner, address spender)
96     external
97     view
98     returns (uint256);
99 
100   /**
101    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
102    *
103    * Returns a boolean value indicating whether the operation succeeded.
104    *
105    * IMPORTANT: Beware that changing an allowance with this method brings the risk
106    * that someone may use both the old and the new allowance by unfortunate
107    * transaction ordering. One possible solution to mitigate this race
108    * condition is to first reduce the spender's allowance to 0 and set the
109    * desired value afterwards:
110    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111    *
112    * Emits an {Approval} event.
113    */
114   function approve(address spender, uint256 amount) external returns (bool);
115 
116   /**
117    * @dev Moves `amount` tokens from `sender` to `recipient` using the
118    * allowance mechanism. `amount` is then deducted from the caller's
119    * allowance.
120    *
121    * Returns a boolean value indicating whether the operation succeeded.
122    *
123    * Emits a {Transfer} event.
124    */
125   function transferFrom(
126     address sender,
127     address recipient,
128     uint256 amount
129   ) external returns (bool);
130 
131   /**
132    * @dev Emitted when `value` tokens are moved from one account (`from`) to
133    * another (`to`).
134    *
135    * Note that `value` may be zero.
136    */
137   event Transfer(address indexed from, address indexed to, uint256 value);
138 
139   /**
140    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
141    * a call to {approve}. `value` is the new allowance.
142    */
143   event Approval(address indexed owner, address indexed spender, uint256 value);
144 }
145 
146 library SafeMath {
147   /**
148    * @dev Returns the addition of two unsigned integers, reverting on
149    * overflow.
150    *
151    * Counterpart to Solidity's `+` operator.
152    *
153    * Requirements:
154    *
155    * - Addition cannot overflow.
156    */
157   function add(uint256 a, uint256 b) internal pure returns (uint256) {
158     uint256 c = a + b;
159     require(c >= a, 'SafeMath: addition overflow');
160 
161     return c;
162   }
163 
164   /**
165    * @dev Returns the subtraction of two unsigned integers, reverting on
166    * overflow (when the result is negative).
167    *
168    * Counterpart to Solidity's `-` operator.
169    *
170    * Requirements:
171    *
172    * - Subtraction cannot overflow.
173    */
174   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
175     return sub(a, b, 'SafeMath: subtraction overflow');
176   }
177 
178   /**
179    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
180    * overflow (when the result is negative).
181    *
182    * Counterpart to Solidity's `-` operator.
183    *
184    * Requirements:
185    *
186    * - Subtraction cannot overflow.
187    */
188   function sub(
189     uint256 a,
190     uint256 b,
191     string memory errorMessage
192   ) internal pure returns (uint256) {
193     require(b <= a, errorMessage);
194     uint256 c = a - b;
195 
196     return c;
197   }
198 
199   /**
200    * @dev Returns the multiplication of two unsigned integers, reverting on
201    * overflow.
202    *
203    * Counterpart to Solidity's `*` operator.
204    *
205    * Requirements:
206    *
207    * - Multiplication cannot overflow.
208    */
209   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
211     // benefit is lost if 'b' is also tested.
212     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
213     if (a == 0) {
214       return 0;
215     }
216 
217     uint256 c = a * b;
218     require(c / a == b, 'SafeMath: multiplication overflow');
219 
220     return c;
221   }
222 
223   /**
224    * @dev Returns the integer division of two unsigned integers. Reverts on
225    * division by zero. The result is rounded towards zero.
226    *
227    * Counterpart to Solidity's `/` operator. Note: this function uses a
228    * `revert` opcode (which leaves remaining gas untouched) while Solidity
229    * uses an invalid opcode to revert (consuming all remaining gas).
230    *
231    * Requirements:
232    *
233    * - The divisor cannot be zero.
234    */
235   function div(uint256 a, uint256 b) internal pure returns (uint256) {
236     return div(a, b, 'SafeMath: division by zero');
237   }
238 
239   /**
240    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
241    * division by zero. The result is rounded towards zero.
242    *
243    * Counterpart to Solidity's `/` operator. Note: this function uses a
244    * `revert` opcode (which leaves remaining gas untouched) while Solidity
245    * uses an invalid opcode to revert (consuming all remaining gas).
246    *
247    * Requirements:
248    *
249    * - The divisor cannot be zero.
250    */
251   function div(
252     uint256 a,
253     uint256 b,
254     string memory errorMessage
255   ) internal pure returns (uint256) {
256     require(b > 0, errorMessage);
257     uint256 c = a / b;
258     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
259 
260     return c;
261   }
262 
263   /**
264    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265    * Reverts when dividing by zero.
266    *
267    * Counterpart to Solidity's `%` operator. This function uses a `revert`
268    * opcode (which leaves remaining gas untouched) while Solidity uses an
269    * invalid opcode to revert (consuming all remaining gas).
270    *
271    * Requirements:
272    *
273    * - The divisor cannot be zero.
274    */
275   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
276     return mod(a, b, 'SafeMath: modulo by zero');
277   }
278 
279   /**
280    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281    * Reverts with custom message when dividing by zero.
282    *
283    * Counterpart to Solidity's `%` operator. This function uses a `revert`
284    * opcode (which leaves remaining gas untouched) while Solidity uses an
285    * invalid opcode to revert (consuming all remaining gas).
286    *
287    * Requirements:
288    *
289    * - The divisor cannot be zero.
290    */
291   function mod(
292     uint256 a,
293     uint256 b,
294     string memory errorMessage
295   ) internal pure returns (uint256) {
296     require(b != 0, errorMessage);
297     return a % b;
298   }
299 }
300 
301 library Address {
302   /**
303    * @dev Returns true if `account` is a contract.
304    *
305    * [IMPORTANT]
306    * ====
307    * It is unsafe to assume that an address for which this function returns
308    * false is an externally-owned account (EOA) and not a contract.
309    *
310    * Among others, `isContract` will return false for the following
311    * types of addresses:
312    *
313    *  - an externally-owned account
314    *  - a contract in construction
315    *  - an address where a contract will be created
316    *  - an address where a contract lived, but was destroyed
317    * ====
318    */
319   function isContract(address account) internal view returns (bool) {
320     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
321     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
322     // for accounts without code, i.e. `keccak256('')`
323     bytes32 codehash;
324     bytes32 accountHash =
325       0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
326     // solhint-disable-next-line no-inline-assembly
327     assembly {
328       codehash := extcodehash(account)
329     }
330     return (codehash != accountHash && codehash != 0x0);
331   }
332 
333   /**
334    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335    * `recipient`, forwarding all available gas and reverting on errors.
336    *
337    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338    * of certain opcodes, possibly making contracts go over the 2300 gas limit
339    * imposed by `transfer`, making them unable to receive funds via
340    * `transfer`. {sendValue} removes this limitation.
341    *
342    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343    *
344    * IMPORTANT: because control is transferred to `recipient`, care must be
345    * taken to not create reentrancy vulnerabilities. Consider using
346    * {ReentrancyGuard} or the
347    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348    */
349   function sendValue(address payable recipient, uint256 amount) internal {
350     require(address(this).balance >= amount, 'Address: insufficient balance');
351 
352     // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
353     (bool success, ) = recipient.call{value: amount}('');
354     require(
355       success,
356       'Address: unable to send value, recipient may have reverted'
357     );
358   }
359 
360   /**
361    * @dev Performs a Solidity function call using a low level `call`. A
362    * plain`call` is an unsafe replacement for a function call: use this
363    * function instead.
364    *
365    * If `target` reverts with a revert reason, it is bubbled up by this
366    * function (like regular Solidity function calls).
367    *
368    * Returns the raw returned data. To convert to the expected return value,
369    * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370    *
371    * Requirements:
372    *
373    * - `target` must be a contract.
374    * - calling `target` with `data` must not revert.
375    *
376    * _Available since v3.1._
377    */
378   function functionCall(address target, bytes memory data)
379     internal
380     returns (bytes memory)
381   {
382     return functionCall(target, data, 'Address: low-level call failed');
383   }
384 
385   /**
386    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387    * `errorMessage` as a fallback revert reason when `target` reverts.
388    *
389    * _Available since v3.1._
390    */
391   function functionCall(
392     address target,
393     bytes memory data,
394     string memory errorMessage
395   ) internal returns (bytes memory) {
396     return _functionCallWithValue(target, data, 0, errorMessage);
397   }
398 
399   /**
400    * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401    * but also transferring `value` wei to `target`.
402    *
403    * Requirements:
404    *
405    * - the calling contract must have an ETH balance of at least `value`.
406    * - the called Solidity function must be `payable`.
407    *
408    * _Available since v3.1._
409    */
410   function functionCallWithValue(
411     address target,
412     bytes memory data,
413     uint256 value
414   ) internal returns (bytes memory) {
415     return
416       functionCallWithValue(
417         target,
418         data,
419         value,
420         'Address: low-level call with value failed'
421       );
422   }
423 
424   /**
425    * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426    * with `errorMessage` as a fallback revert reason when `target` reverts.
427    *
428    * _Available since v3.1._
429    */
430   function functionCallWithValue(
431     address target,
432     bytes memory data,
433     uint256 value,
434     string memory errorMessage
435   ) internal returns (bytes memory) {
436     require(
437       address(this).balance >= value,
438       'Address: insufficient balance for call'
439     );
440     return _functionCallWithValue(target, data, value, errorMessage);
441   }
442 
443   function _functionCallWithValue(
444     address target,
445     bytes memory data,
446     uint256 weiValue,
447     string memory errorMessage
448   ) private returns (bytes memory) {
449     require(isContract(target), 'Address: call to non-contract');
450 
451     // solhint-disable-next-line avoid-low-level-calls
452     (bool success, bytes memory returndata) =
453       target.call{value: weiValue}(data);
454     if (success) {
455       return returndata;
456     } else {
457       // Look for revert reason and bubble it up if present
458       if (returndata.length > 0) {
459         // The easiest way to bubble the revert reason is using memory via assembly
460 
461         // solhint-disable-next-line no-inline-assembly
462         assembly {
463           let returndata_size := mload(returndata)
464           revert(add(32, returndata), returndata_size)
465         }
466       } else {
467         revert(errorMessage);
468       }
469     }
470   }
471 }
472 
473 contract Ownable is Context {
474   address private _owner;
475 
476   event OwnershipTransferred(
477     address indexed previousOwner,
478     address indexed newOwner
479   );
480 
481   /**
482    * @dev Initializes the contract setting the deployer as the initial owner.
483    */
484   constructor() internal {
485     address msgSender = _msgSender();
486     _owner = msgSender;
487     emit OwnershipTransferred(address(0), msgSender);
488   }
489 
490   /**
491    * @dev Returns the address of the current owner.
492    */
493   function owner() public view returns (address) {
494     return _owner;
495   }
496 
497   /**
498    * @dev Throws if called by any account other than the owner.
499    */
500   modifier onlyOwner() {
501     require(_owner == _msgSender(), 'Ownable: caller is not the owner');
502     _;
503   }
504 
505   /**
506    * @dev Leaves the contract without owner. It will not be possible to call
507    * `onlyOwner` functions anymore. Can only be called by the current owner.
508    *
509    * NOTE: Renouncing ownership will leave the contract without an owner,
510    * thereby removing any functionality that is only available to the owner.
511    */
512   function renounceOwnership() public virtual onlyOwner {
513     emit OwnershipTransferred(_owner, address(0));
514     _owner = address(0);
515   }
516 
517   /**
518    * @dev Transfers ownership of the contract to a new account (`newOwner`).
519    * Can only be called by the current owner.
520    */
521   function transferOwnership(address newOwner) public virtual onlyOwner {
522     require(newOwner != address(0), 'Ownable: new owner is the zero address');
523     emit OwnershipTransferred(_owner, newOwner);
524     _owner = newOwner;
525   }
526 }
527 
528 contract WarriorInu is Context, IERC20, Ownable {
529   using SafeMath for uint256;
530   using Address for address;
531 
532   mapping(address => uint256) private _rOwned;
533   mapping(address => uint256) private _tOwned;
534   mapping(address => mapping(address => uint256)) private _allowances;
535 
536   mapping(address => bool) private _isExcluded;
537   address[] private _excluded;
538 
539   uint256 private constant MAX = ~uint256(0);
540   uint256 private constant _tTotal = 10000000 * 10**5 * 10**9;
541   uint256 private _rTotal = (MAX - (MAX % _tTotal));
542   uint256 private _tFeeTotal;
543 
544   string private _name = 'Warrior Inu';
545   string private _symbol = 'WINU';
546   uint8 private _decimals = 9;
547 
548   uint256 public _maxTxAmount = 3750000 * 10**5 * 10**9;
549 
550   constructor() public {
551     _rOwned[_msgSender()] = _rTotal;
552     emit Transfer(address(0), _msgSender(), _tTotal);
553   }
554 
555   function name() public view returns (string memory) {
556     return _name;
557   }
558 
559   function symbol() public view returns (string memory) {
560     return _symbol;
561   }
562 
563   function decimals() public view returns (uint8) {
564     return _decimals;
565   }
566 
567   function totalSupply() public view override returns (uint256) {
568     return _tTotal;
569   }
570 
571   function balanceOf(address account) public view override returns (uint256) {
572     if (_isExcluded[account]) return _tOwned[account];
573     return tokenFromReflection(_rOwned[account]);
574   }
575 
576   function transfer(address recipient, uint256 amount)
577     public
578     override
579     returns (bool)
580   {
581     _transfer(_msgSender(), recipient, amount);
582     return true;
583   }
584 
585   function allowance(address owner, address spender)
586     public
587     view
588     override
589     returns (uint256)
590   {
591     return _allowances[owner][spender];
592   }
593 
594   function approve(address spender, uint256 amount)
595     public
596     override
597     returns (bool)
598   {
599     _approve(_msgSender(), spender, amount);
600     return true;
601   }
602 
603   function transferFrom(
604     address sender,
605     address recipient,
606     uint256 amount
607   ) public override returns (bool) {
608     _transfer(sender, recipient, amount);
609     _approve(
610       sender,
611       _msgSender(),
612       _allowances[sender][_msgSender()].sub(
613         amount,
614         'ERC20: transfer amount exceeds allowance'
615       )
616     );
617     return true;
618   }
619 
620   function increaseAllowance(address spender, uint256 addedValue)
621     public
622     virtual
623     returns (bool)
624   {
625     _approve(
626       _msgSender(),
627       spender,
628       _allowances[_msgSender()][spender].add(addedValue)
629     );
630     return true;
631   }
632 
633   function decreaseAllowance(address spender, uint256 subtractedValue)
634     public
635     virtual
636     returns (bool)
637   {
638     _approve(
639       _msgSender(),
640       spender,
641       _allowances[_msgSender()][spender].sub(
642         subtractedValue,
643         'ERC20: decreased allowance below zero'
644       )
645     );
646     return true;
647   }
648 
649   function isExcluded(address account) public view returns (bool) {
650     return _isExcluded[account];
651   }
652 
653   function totalFees() public view returns (uint256) {
654     return _tFeeTotal;
655   }
656 
657   function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
658     _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
659   }
660 
661   function rescueFromContract() external onlyOwner {
662     address payable _owner = _msgSender();
663     _owner.transfer(address(this).balance);
664   }
665 
666   function reflect(uint256 tAmount) public {
667     address sender = _msgSender();
668     require(
669       !_isExcluded[sender],
670       'Excluded addresses cannot call this function'
671     );
672     (uint256 rAmount, , , , ) = _getValues(tAmount);
673     _rOwned[sender] = _rOwned[sender].sub(rAmount);
674     _rTotal = _rTotal.sub(rAmount);
675     _tFeeTotal = _tFeeTotal.add(tAmount);
676   }
677 
678   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
679     public
680     view
681     returns (uint256)
682   {
683     require(tAmount <= _tTotal, 'Amount must be less than supply');
684     if (!deductTransferFee) {
685       (uint256 rAmount, , , , ) = _getValues(tAmount);
686       return rAmount;
687     } else {
688       (, uint256 rTransferAmount, , , ) = _getValues(tAmount);
689       return rTransferAmount;
690     }
691   }
692 
693   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
694     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
695     uint256 currentRate = _getRate();
696     return rAmount.div(currentRate);
697   }
698 
699   function excludeAccount(address account) external onlyOwner() {
700     require(!_isExcluded[account], 'Account is already excluded');
701     if (_rOwned[account] > 0) {
702       _tOwned[account] = tokenFromReflection(_rOwned[account]);
703     }
704     _isExcluded[account] = true;
705     _excluded.push(account);
706   }
707 
708   function includeAccount(address account) external onlyOwner() {
709     require(_isExcluded[account], 'Account is already excluded');
710     for (uint256 i = 0; i < _excluded.length; i++) {
711       if (_excluded[i] == account) {
712         _excluded[i] = _excluded[_excluded.length - 1];
713         _tOwned[account] = 0;
714         _isExcluded[account] = false;
715         _excluded.pop();
716         break;
717       }
718     }
719   }
720 
721   function _approve(
722     address owner,
723     address spender,
724     uint256 amount
725   ) private {
726     require(owner != address(0), 'ERC20: approve from the zero address');
727     require(spender != address(0), 'ERC20: approve to the zero address');
728 
729     _allowances[owner][spender] = amount;
730     emit Approval(owner, spender, amount);
731   }
732 
733   function _transfer(
734     address sender,
735     address recipient,
736     uint256 amount
737   ) private {
738     require(sender != address(0), 'ERC20: transfer from the zero address');
739     require(recipient != address(0), 'ERC20: transfer to the zero address');
740     require(amount > 0, 'Transfer amount must be greater than zero');
741     if (sender != owner() && recipient != owner()) {
742       require(
743         amount <= _maxTxAmount,
744         'Transfer amount exceeds the maxTxAmount.'
745       );
746       require(!_isExcluded[sender], 'Account is excluded');
747     }
748 
749     if (_isExcluded[sender] && !_isExcluded[recipient]) {
750       _transferFromExcluded(sender, recipient, amount);
751     } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
752       _transferToExcluded(sender, recipient, amount);
753     } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
754       _transferStandard(sender, recipient, amount);
755     } else if (_isExcluded[sender] && _isExcluded[recipient]) {
756       _transferBothExcluded(sender, recipient, amount);
757     } else {
758       _transferStandard(sender, recipient, amount);
759     }
760   }
761 
762   function _transferStandard(
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
774     _rOwned[sender] = _rOwned[sender].sub(rAmount);
775     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
776     _reflectFee(rFee, tFee);
777     emit Transfer(sender, recipient, tTransferAmount);
778   }
779 
780   function _transferToExcluded(
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
792     _rOwned[sender] = _rOwned[sender].sub(rAmount);
793     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
794     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
795     _reflectFee(rFee, tFee);
796     emit Transfer(sender, recipient, tTransferAmount);
797   }
798 
799   function _transferFromExcluded(
800     address sender,
801     address recipient,
802     uint256 tAmount
803   ) private {
804     (
805       uint256 rAmount,
806       uint256 rTransferAmount,
807       uint256 rFee,
808       uint256 tTransferAmount,
809       uint256 tFee
810     ) = _getValues(tAmount);
811     _tOwned[sender] = _tOwned[sender].sub(tAmount);
812     _rOwned[sender] = _rOwned[sender].sub(rAmount);
813     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
814     _reflectFee(rFee, tFee);
815     emit Transfer(sender, recipient, tTransferAmount);
816   }
817 
818   function _transferBothExcluded(
819     address sender,
820     address recipient,
821     uint256 tAmount
822   ) private {
823     (
824       uint256 rAmount,
825       uint256 rTransferAmount,
826       uint256 rFee,
827       uint256 tTransferAmount,
828       uint256 tFee
829     ) = _getValues(tAmount);
830     _tOwned[sender] = _tOwned[sender].sub(tAmount);
831     _rOwned[sender] = _rOwned[sender].sub(rAmount);
832     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
833     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
834     _reflectFee(rFee, tFee);
835     emit Transfer(sender, recipient, tTransferAmount);
836   }
837 
838   function _reflectFee(uint256 rFee, uint256 tFee) private {
839     _rTotal = _rTotal.sub(rFee);
840     _tFeeTotal = _tFeeTotal.add(tFee);
841   }
842 
843   function _getValues(uint256 tAmount)
844     private
845     view
846     returns (
847       uint256,
848       uint256,
849       uint256,
850       uint256,
851       uint256
852     )
853   {
854     (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
855     uint256 currentRate = _getRate();
856     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
857       _getRValues(tAmount, tFee, currentRate);
858     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
859   }
860 
861   function _getTValues(uint256 tAmount)
862     private
863     pure
864     returns (uint256, uint256)
865   {
866     uint256 tFee = 0;
867     uint256 tTransferAmount = tAmount.sub(tFee);
868     return (tTransferAmount, tFee);
869   }
870 
871   function _getRValues(
872     uint256 tAmount,
873     uint256 tFee,
874     uint256 currentRate
875   )
876     private
877     pure
878     returns (
879       uint256,
880       uint256,
881       uint256
882     )
883   {
884     uint256 rAmount = tAmount.mul(currentRate);
885     uint256 rFee = tFee.mul(currentRate);
886     uint256 rTransferAmount = rAmount.sub(rFee);
887     return (rAmount, rTransferAmount, rFee);
888   }
889 
890   function _getRate() private view returns (uint256) {
891     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
892     return rSupply.div(tSupply);
893   }
894 
895   function _getCurrentSupply() private view returns (uint256, uint256) {
896     uint256 rSupply = _rTotal;
897     uint256 tSupply = _tTotal;
898     for (uint256 i = 0; i < _excluded.length; i++) {
899       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
900         return (_rTotal, _tTotal);
901       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
902       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
903     }
904     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
905     return (rSupply, tSupply);
906   }
907 }