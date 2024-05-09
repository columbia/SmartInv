1 /**
2  *Submitted for verification at BscScan.com on 2021-07-30
3 */
4 
5 /**
6  *  SPDX-License-Identifier: MIT
7 */
8 
9 pragma solidity 0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  *
93  * _Available since v4.1._
94  */
95 interface IERC20Metadata is IERC20 {
96     /**
97      * @dev Returns the name of the token.
98      */
99     function name() external view returns (string memory);
100 
101     /**
102      * @dev Returns the symbol of the token.
103      */
104     function symbol() external view returns (string memory);
105 
106     /**
107      * @dev Returns the decimals places of the token.
108      */
109     function decimals() external view returns (uint8);
110 }
111 
112 
113 
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         return msg.data;
131     }
132 }
133 
134 
135 // CAUTION
136 // This version of SafeMath should only be used with Solidity 0.8 or later,
137 // because it relies on the compiler's built in overflow checks.
138 
139 /**
140  * @dev Wrappers over Solidity's arithmetic operations.
141  *
142  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
143  * now has built in overflow checking.
144  */
145 library SafeMath {
146     /**
147      * @dev Returns the addition of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             uint256 c = a + b;
154             if (c < a) return (false, 0);
155             return (true, c);
156         }
157     }
158 
159     /**
160      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
161      *
162      * _Available since v3.4._
163      */
164     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         unchecked {
166             if (b > a) return (false, 0);
167             return (true, a - b);
168         }
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
173      *
174      * _Available since v3.4._
175      */
176     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         unchecked {
178             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179             // benefit is lost if 'b' is also tested.
180             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181             if (a == 0) return (true, 0);
182             uint256 c = a * b;
183             if (c / a != b) return (false, 0);
184             return (true, c);
185         }
186     }
187 
188     /**
189      * @dev Returns the division of two unsigned integers, with a division by zero flag.
190      *
191      * _Available since v3.4._
192      */
193     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
194         unchecked {
195             if (b == 0) return (false, 0);
196             return (true, a / b);
197         }
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
202      *
203      * _Available since v3.4._
204      */
205     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
206         unchecked {
207             if (b == 0) return (false, 0);
208             return (true, a % b);
209         }
210     }
211 
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
223         return a + b;
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
237         return a - b;
238     }
239 
240     /**
241      * @dev Returns the multiplication of two unsigned integers, reverting on
242      * overflow.
243      *
244      * Counterpart to Solidity's `*` operator.
245      *
246      * Requirements:
247      *
248      * - Multiplication cannot overflow.
249      */
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a * b;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers, reverting on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator.
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function div(uint256 a, uint256 b) internal pure returns (uint256) {
265         return a / b;
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * reverting when dividing by zero.
271      *
272      * Counterpart to Solidity's `%` operator. This function uses a `revert`
273      * opcode (which leaves remaining gas untouched) while Solidity uses an
274      * invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
281         return a % b;
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
286      * overflow (when the result is negative).
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {trySub}.
290      *
291      * Counterpart to Solidity's `-` operator.
292      *
293      * Requirements:
294      *
295      * - Subtraction cannot overflow.
296      */
297     function sub(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         unchecked {
303             require(b <= a, errorMessage);
304             return a - b;
305         }
306     }
307 
308     /**
309      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
310      * division by zero. The result is rounded towards zero.
311      *
312      * Counterpart to Solidity's `/` operator. Note: this function uses a
313      * `revert` opcode (which leaves remaining gas untouched) while Solidity
314      * uses an invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function div(
321         uint256 a,
322         uint256 b,
323         string memory errorMessage
324     ) internal pure returns (uint256) {
325         unchecked {
326             require(b > 0, errorMessage);
327             return a / b;
328         }
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333      * reverting with custom message when dividing by zero.
334      *
335      * CAUTION: This function is deprecated because it requires allocating memory for the error
336      * message unnecessarily. For custom revert reasons use {tryMod}.
337      *
338      * Counterpart to Solidity's `%` operator. This function uses a `revert`
339      * opcode (which leaves remaining gas untouched) while Solidity uses an
340      * invalid opcode to revert (consuming all remaining gas).
341      *
342      * Requirements:
343      *
344      * - The divisor cannot be zero.
345      */
346     function mod(
347         uint256 a,
348         uint256 b,
349         string memory errorMessage
350     ) internal pure returns (uint256) {
351         unchecked {
352             require(b > 0, errorMessage);
353             return a % b;
354         }
355     }
356 }
357 
358 /**
359  * @dev Contract module which provides a basic access control mechanism, where
360  * there is an account (an owner) that can be granted exclusive access to
361  * specific functions.
362  *
363  * By default, the owner account will be the one that deploys the contract. This
364  * can later be changed with {transferOwnership}.
365  *
366  * This module is used through inheritance. It will make available the modifier
367  * `onlyOwner`, which can be applied to your functions to restrict their use to
368  * the owner.
369  */
370 abstract contract Ownable is Context {
371     address private _owner;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376      * @dev Initializes the contract setting the deployer as the initial owner.
377      */
378     constructor() {
379         _setOwner(_msgSender());
380     }
381 
382     /**
383      * @dev Returns the address of the current owner.
384      */
385     function owner() public view virtual returns (address) {
386         return _owner;
387     }
388 
389     /**
390      * @dev Throws if called by any account other than the owner.
391      */
392     modifier onlyOwner() {
393         require(owner() == _msgSender(), "Ownable: caller is not the owner");
394         _;
395     }
396 
397     /**
398      * @dev Leaves the contract without owner. It will not be possible to call
399      * `onlyOwner` functions anymore. Can only be called by the current owner.
400      *
401      * NOTE: Renouncing ownership will leave the contract without an owner,
402      * thereby removing any functionality that is only available to the owner.
403      */
404     function renounceOwnership() public virtual onlyOwner {
405         _setOwner(address(0));
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Can only be called by the current owner.
411      */
412     function transferOwnership(address newOwner) public virtual onlyOwner {
413         require(newOwner != address(0), "Ownable: new owner is the zero address");
414         _setOwner(newOwner);
415     }
416 
417     function _setOwner(address newOwner) private {
418         address oldOwner = _owner;
419         _owner = newOwner;
420         emit OwnershipTransferred(oldOwner, newOwner);
421     }
422 }
423 
424 
425 /**
426  *  dex pancake interface
427  */
428 
429 interface IPancakeFactory {
430     function createPair(address tokenA, address tokenB)
431         external
432         returns (address pair);
433 }
434 
435 interface IPancakeRouter {
436      function WETH() external pure returns (address);
437      function factory() external pure returns (address);
438      function swapExactTokensForETHSupportingFeeOnTransferTokens(
439         uint amountIn,
440         uint amountOutMin,
441         address[] calldata path,
442         address to,
443         uint deadline
444     ) external;
445 }
446 
447 interface IPancakePair{
448     function token0() external view returns (address);
449     function token1() external view returns (address);
450     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
451 }
452 
453  interface TokenProtect{
454     function check( address sender, address receiver, uint256 amount ) external;
455  }
456 
457 contract CreateNewToken is Context, IERC20, IERC20Metadata,Ownable {
458 
459     using SafeMath for uint256;
460 
461     mapping(address => uint256) private _balances;
462     mapping(address => mapping(address => uint256)) private _allowances;
463     mapping(address => bool) private _isExcludedFromFee;
464     mapping(address => bool) private _buyList;
465 
466     uint256 private _totalSupply;
467     uint256 private _initSupply = 1000000000000*10**18;
468     uint256 public dexTaxFee = 200; //take fee while sell token to dex
469     uint256 public dexTaxBuyFee = 200; 
470     uint256 public _startTime;
471     uint256 private _startAddTime;
472     
473     string private _name = "DO2 Token";
474     string private _symbol = "DO2";
475     
476     address public taxAddress;
477     address public taxBuyAddress;
478     address public  pairAddress;
479     address public  routerAddress;
480     // address public protectAddress;
481     address public usdtAddress;
482     address public tax2Address;
483 
484     bool public enableLock = true;
485     /**
486      * @dev Sets the values for {name} and {symbol}.
487      *
488      * The default value of {decimals} is 18. To select a different value for
489      * {decimals} you should overload it.
490      *
491      * All two of these values are immutable: they can only be set once during
492      * construction.
493      */
494     constructor() {
495         _mint(msg.sender, _initSupply);
496         address _taxAddress = 0x693429bF4b02dF67910087Da175FB7448e1C588f;
497         address _tax2Address = 0x44E8bA40327d697FAF80db045322Ab40b89F5BEF;
498 
499         taxAddress = payable(_taxAddress);
500         taxBuyAddress = payable(_taxAddress);
501         tax2Address = payable(_tax2Address);
502 
503         // IPancakeRouter _router = IPancakeRouter(0x1f9cDE0C9364883B2546DaD437c263886c200fd5);//bnb test
504         // IPancakeRouter _router = IPancakeRouter(0xc873fEcbd354f5A56E00E710B90EF4201db2448d);//arb 
505         IPancakeRouter _router = IPancakeRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//ETH
506        
507         
508         // set the rest of the contract variables
509         routerAddress = address(_router);
510         createPair();
511 
512         _isExcludedFromFee[owner()] = true;
513         _isExcludedFromFee[address(this)] = true;
514     }
515 
516      function createPair() public onlyOwner {
517          IPancakeRouter _router = IPancakeRouter(routerAddress);//arb 
518          address wethAddress = _router.WETH();
519         pairAddress = IPancakeFactory(_router.factory()).createPair(address(this), wethAddress);
520     }
521 
522     function stopLock() public onlyOwner {
523         require(enableLock,'Error');
524         enableLock = false;
525     }
526 
527     // function setPairAddress(address _pairAddress) public onlyOwner {
528     //     pairAddress = _pairAddress;
529     // }
530 
531     function setStartTime(uint256 startTime) public onlyOwner {
532         _startTime = startTime;
533     }
534 
535     function setStartAddTime(uint256 startAddTime) public onlyOwner {
536         _startAddTime = startAddTime;
537     }
538 
539     function setBuyOne(address account,bool _type) public onlyOwner {
540         _buyList[account] = _type;
541     }
542 
543     function setBuyList(address[] memory _addressList,bool _type) public onlyOwner {
544         for(uint256 i=0;i<_addressList.length;i++){
545              _buyList[_addressList[i]] = _type;
546         }
547     }
548     
549     // function setProtectAddress(address _address) public onlyOwner {
550     //     protectAddress = _address;
551     // }
552     
553     function excludeFromFee(address account,bool _type) public onlyOwner {
554         _isExcludedFromFee[account] = _type;
555     }
556     function excludeFromFeeList(address[] memory _addressList,bool _type) public onlyOwner {
557         for(uint256 i=0;i<_addressList.length;i++){
558              _isExcludedFromFee[_addressList[i]] = _type;
559         }
560         
561     }
562     
563 
564     function setTaxAddress(address _taxAddress) public onlyOwner {
565         taxAddress = _taxAddress;
566     }
567 
568     function setTax2Address(address _tax2Address) public onlyOwner {
569         tax2Address = _tax2Address;
570     }
571 
572     // function setTax(uint256 _taxFee) public onlyOwner{
573     //     dexTaxFee = _taxFee;
574     // }
575 
576     function setTaxBuyAddress(address _taxAddress) public onlyOwner {
577         taxBuyAddress = _taxAddress;
578     }
579 
580 
581 
582     // function setBuyTax(uint256 _taxFee) public onlyOwner{
583     //     dexTaxBuyFee = _taxFee;
584     // }
585 
586     function isExcludedFromFee(address account) public view returns (bool) {
587         return _isExcludedFromFee[account];
588     }
589 
590     function amountForEth(uint256 ethAmount) public view returns(uint256 tokenAmount){
591         address _token0Address = IPancakePair(pairAddress).token0();
592         address wethAddress = IPancakeRouter(routerAddress).WETH();
593 
594         (uint112 _reserve0,uint112 _reserve1,) = IPancakePair(pairAddress).getReserves();
595         uint256 _tokenAmount;
596         uint256 _wethAmount;
597         if(_token0Address==wethAddress){
598             _wethAmount = _reserve0;
599             _tokenAmount = _reserve1;
600         }
601         else{
602             _wethAmount = _reserve1;
603             _tokenAmount = _reserve0;
604         }
605         tokenAmount = ethAmount.mul(_tokenAmount).div(_wethAmount);
606     }
607 
608     /**
609      * @dev Returns the name of the token.
610      */
611     function name() public view virtual override returns (string memory) {
612         return _name;
613     }
614 
615     /**
616      * @dev Returns the symbol of the token, usually a shorter version of the
617      * name.
618      */
619     function symbol() public view virtual override returns (string memory) {
620         return _symbol;
621     }
622 
623     /**
624      * @dev Returns the number of decimals used to get its user representation.
625      * For example, if `decimals` equals `2`, a balance of `505` tokens should
626      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
627      *
628      * Tokens usually opt for a value of 18, imitating the relationship between
629      * Ether and Wei. This is the value {ERC20} uses, unless this function is
630      * overridden;
631      *
632      * NOTE: This information is only used for _display_ purposes: it in
633      * no way affects any of the arithmetic of the contract, including
634      * {IERC20-balanceOf} and {IERC20-transfer}.
635      */
636     function decimals() public view virtual override returns (uint8) {
637         return 18;
638     }
639 
640     /**
641      * @dev See {IERC20-totalSupply}.
642      */
643     function totalSupply() public view virtual override returns (uint256) {
644         return _totalSupply;
645     }
646 
647     /**
648      * @dev See {IERC20-balanceOf}.
649      */
650     function balanceOf(address account) public view virtual override returns (uint256) {
651         return _balances[account];
652     }
653 
654     /**
655      * @dev See {IERC20-transfer}.
656      *
657      * Requirements:
658      *
659      * - `recipient` cannot be the zero address.
660      * - the caller must have a balance of at least `amount`.
661      */
662     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
663         _transfer(_msgSender(), recipient, amount);
664         return true;
665     }
666 
667     /**
668      * @dev See {IERC20-allowance}.
669      */
670     function allowance(address owner, address spender) public view virtual override returns (uint256) {
671         return _allowances[owner][spender];
672     }
673 
674     /**
675      * @dev See {IERC20-approve}.
676      *
677      * Requirements:
678      *
679      * - `spender` cannot be the zero address.
680      */
681     function approve(address spender, uint256 amount) public virtual override returns (bool) {
682         _approve(_msgSender(), spender, amount);
683         return true;
684     }
685 
686     /**
687      * @dev See {IERC20-transferFrom}.
688      *
689      * Emits an {Approval} event indicating the updated allowance. This is not
690      * required by the EIP. See the note at the beginning of {ERC20}.
691      *
692      * Requirements:
693      *
694      * - `sender` and `recipient` cannot be the zero address.
695      * - `sender` must have a balance of at least `amount`.
696      * - the caller must have allowance for ``sender``'s tokens of at least
697      * `amount`.
698      */
699     function transferFrom(
700         address sender,
701         address recipient,
702         uint256 amount
703     ) public virtual override returns (bool) {
704         _transfer(sender, recipient, amount);
705 
706         uint256 currentAllowance = _allowances[sender][_msgSender()];
707         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
708         unchecked {
709             _approve(sender, _msgSender(), currentAllowance - amount);
710         }
711 
712         return true;
713     }
714 
715     /**
716      * @dev Atomically increases the allowance granted to `spender` by the caller.
717      *
718      * This is an alternative to {approve} that can be used as a mitigation for
719      * problems described in {IERC20-approve}.
720      *
721      * Emits an {Approval} event indicating the updated allowance.
722      *
723      * Requirements:
724      *
725      * - `spender` cannot be the zero address.
726      */
727     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
728         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
729         return true;
730     }
731 
732     /**
733      * @dev Atomically decreases the allowance granted to `spender` by the caller.
734      *
735      * This is an alternative to {approve} that can be used as a mitigation for
736      * problems described in {IERC20-approve}.
737      *
738      * Emits an {Approval} event indicating the updated allowance.
739      *
740      * Requirements:
741      *
742      * - `spender` cannot be the zero address.
743      * - `spender` must have allowance for the caller of at least
744      * `subtractedValue`.
745      */
746     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
747         uint256 currentAllowance = _allowances[_msgSender()][spender];
748         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
749         unchecked {
750             _approve(_msgSender(), spender, currentAllowance.sub(subtractedValue));
751         }
752 
753         return true;
754     }
755 
756     /**
757      * @dev Moves `amount` of tokens from `sender` to `recipient`.
758      *
759      * This internal function is equivalent to {transfer}, and can be used to
760      * e.g. implement automatic token fees, slashing mechanisms, etc.
761      *
762      * Emits a {Transfer} event.
763      *
764      * Requirements:
765      *
766      * - `sender` cannot be the zero address.
767      * - `recipient` cannot be the zero address.
768      * - `sender` must have a balance of at least `amount`.
769      */
770     function _transfer(
771         address sender,
772         address recipient,
773         uint256 amount
774     ) internal virtual {
775         require(sender != address(0), "ERC20: transfer from the zero address");
776         require(recipient != address(0), "ERC20: transfer to the zero address");
777         
778         if((recipient==pairAddress || sender==pairAddress)&& enableLock){
779             if(!_buyList[sender] && !_buyList[recipient]){
780                 require(block.timestamp>=(_startTime+_startAddTime),'ERC20: ERROR!');
781             }else{
782                 require(block.timestamp>=_startTime,'ERC20: ERROR');
783             }
784         }
785        
786         uint256 senderBalance = _balances[sender];
787         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
788 
789         unchecked {
790             _balances[sender] = senderBalance.sub(amount);
791         }
792 
793         bool takeFee = true;
794         if (_isExcludedFromFee[sender]) {
795             takeFee = false;
796         }
797         if(takeFee){
798             if(recipient==pairAddress){
799                 if(dexTaxFee>0){
800                     uint256 taxFee = amount.mul(dexTaxFee).div(10000);
801                     uint256 taxFeeHalf = taxFee.div(2);
802                     _balances[taxAddress] = _balances[taxAddress].add(taxFeeHalf);
803                     emit Transfer(sender, taxAddress, taxFeeHalf);
804                     _balances[tax2Address] = _balances[tax2Address].add(taxFeeHalf);
805                     emit Transfer(sender, tax2Address, taxFeeHalf);
806                     amount = amount.sub(taxFee);
807                 }
808             }else if(sender==pairAddress){
809                 if(dexTaxBuyFee>0){
810                     uint256 taxBuyFee = amount.mul(dexTaxBuyFee).div(10000);
811                     uint256 taxBuyFeeHalf = taxBuyFee.div(2);
812                     _balances[taxBuyAddress] = _balances[taxBuyAddress].add(taxBuyFeeHalf);
813                     emit Transfer(sender, taxBuyAddress, taxBuyFeeHalf);
814                     _balances[tax2Address] = _balances[tax2Address].add(taxBuyFeeHalf);
815                     emit Transfer(sender, tax2Address, taxBuyFeeHalf);
816 
817                     amount = amount.sub(taxBuyFee);
818                 }
819             }
820         }
821         
822 
823         _balances[recipient] = _balances[recipient].add(amount);
824         emit Transfer(sender, recipient, amount);
825     }
826     
827 
828     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
829      * the total supply.
830      *
831      * Emits a {Transfer} event with `from` set to the zero address.
832      *
833      * Requirements:
834      *
835      * - `account` cannot be the zero address.
836      */
837     function _mint(address account, uint256 amount) internal {
838         require(account != address(0), "ERC20: mint to the zero address");
839 
840         _totalSupply = _totalSupply.add(amount);
841         _balances[account] = _balances[account].add(amount);
842         emit Transfer(address(0), account, amount);
843     }
844 
845 
846     /**
847      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
848      *
849      * This internal function is equivalent to `approve`, and can be used to
850      * e.g. set automatic allowances for certain subsystems, etc.
851      *
852      * Emits an {Approval} event.
853      *
854      * Requirements:
855      *
856      * - `owner` cannot be the zero address.
857      * - `spender` cannot be the zero address.
858      */
859     function _approve(
860         address owner,
861         address spender,
862         uint256 amount
863     ) internal virtual {
864         require(owner != address(0), "ERC20: approve from the zero address");
865         require(spender != address(0), "ERC20: approve to the zero address");
866 
867         _allowances[owner][spender] = amount;
868         emit Approval(owner, spender, amount);
869     }
870 
871 }