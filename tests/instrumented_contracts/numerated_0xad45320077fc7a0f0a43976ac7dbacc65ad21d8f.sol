1 pragma solidity 0.6.7;
2 
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      *
13      * - Addition cannot overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, reverting on
24      * overflow (when the result is negative).
25      *
26      * Counterpart to Solidity's `-` operator.
27      *
28      * Requirements:
29      *
30      * - Subtraction cannot overflow.
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      *
61      * - Multiplication cannot overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the integer division of two unsigned integers. Reverts on
79      * division by zero. The result is rounded towards zero.
80      *
81      * Counterpart to Solidity's `/` operator. Note: this function uses a
82      * `revert` opcode (which leaves remaining gas untouched) while Solidity
83      * uses an invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      *
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * Reverts when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         return mod(a, b, "SafeMath: modulo by zero");
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts with custom message when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b != 0, errorMessage);
143         return a % b;
144     }
145 }
146 
147 
148 interface IERC20 {
149     /**
150      * @dev Returns the amount of tokens in existence.
151      */
152     function totalSupply() external view returns (uint256);
153 
154     /**
155      * @dev Returns the amount of tokens owned by `account`.
156      */
157     function balanceOf(address account) external view returns (uint256);
158 
159     /**
160      * @dev Moves `amount` tokens from the caller's account to `recipient`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transfer(address recipient, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Returns the remaining number of tokens that `spender` will be
170      * allowed to spend on behalf of `owner` through {transferFrom}. This is
171      * zero by default.
172      *
173      * This value changes when {approve} or {transferFrom} are called.
174      */
175     function allowance(address owner, address spender) external view returns (uint256);
176 
177     /**
178      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * IMPORTANT: Beware that changing an allowance with this method brings the risk
183      * that someone may use both the old and the new allowance by unfortunate
184      * transaction ordering. One possible solution to mitigate this race
185      * condition is to first reduce the spender's allowance to 0 and set the
186      * desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address spender, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Moves `amount` tokens from `sender` to `recipient` using the
195      * allowance mechanism. `amount` is then deducted from the caller's
196      * allowance.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Emitted when `value` tokens are moved from one account (`from`) to
206      * another (`to`).
207      *
208      * Note that `value` may be zero.
209      */
210     event Transfer(address indexed from, address indexed to, uint256 value);
211 
212     /**
213      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
214      * a call to {approve}. `value` is the new allowance.
215      */
216     event Approval(address indexed owner, address indexed spender, uint256 value);
217 
218 }
219 
220 
221 interface IUniswapV2Router01 {
222   function factory() external pure returns (address);
223 
224   function WETH() external pure returns (address);
225 
226   function addLiquidity(
227     address tokenA,
228     address tokenB,
229     uint256 amountADesired,
230     uint256 amountBDesired,
231     uint256 amountAMin,
232     uint256 amountBMin,
233     address to,
234     uint256 deadline
235   )
236     external
237     returns (
238       uint256 amountA,
239       uint256 amountB,
240       uint256 liquidity
241     );
242 
243   function addLiquidityETH(
244     address token,
245     uint256 amountTokenDesired,
246     uint256 amountTokenMin,
247     uint256 amountETHMin,
248     address to,
249     uint256 deadline
250   )
251     external
252     payable
253     returns (
254       uint256 amountToken,
255       uint256 amountETH,
256       uint256 liquidity
257     );
258 
259   function removeLiquidity(
260     address tokenA,
261     address tokenB,
262     uint256 liquidity,
263     uint256 amountAMin,
264     uint256 amountBMin,
265     address to,
266     uint256 deadline
267   ) external returns (uint256 amountA, uint256 amountB);
268 
269   function removeLiquidityETH(
270     address token,
271     uint256 liquidity,
272     uint256 amountTokenMin,
273     uint256 amountETHMin,
274     address to,
275     uint256 deadline
276   ) external returns (uint256 amountToken, uint256 amountETH);
277 
278   function removeLiquidityWithPermit(
279     address tokenA,
280     address tokenB,
281     uint256 liquidity,
282     uint256 amountAMin,
283     uint256 amountBMin,
284     address to,
285     uint256 deadline,
286     bool approveMax,
287     uint8 v,
288     bytes32 r,
289     bytes32 s
290   ) external returns (uint256 amountA, uint256 amountB);
291 
292   function removeLiquidityETHWithPermit(
293     address token,
294     uint256 liquidity,
295     uint256 amountTokenMin,
296     uint256 amountETHMin,
297     address to,
298     uint256 deadline,
299     bool approveMax,
300     uint8 v,
301     bytes32 r,
302     bytes32 s
303   ) external returns (uint256 amountToken, uint256 amountETH);
304 
305   function swapExactTokensForTokens(
306     uint256 amountIn,
307     uint256 amountOutMin,
308     address[] calldata path,
309     address to,
310     uint256 deadline
311   ) external returns (uint256[] memory amounts);
312 
313   function swapTokensForExactTokens(
314     uint256 amountOut,
315     uint256 amountInMax,
316     address[] calldata path,
317     address to,
318     uint256 deadline
319   ) external returns (uint256[] memory amounts);
320 
321   function swapExactETHForTokens(
322     uint256 amountOutMin,
323     address[] calldata path,
324     address to,
325     uint256 deadline
326   ) external payable returns (uint256[] memory amounts);
327 
328   function swapTokensForExactETH(
329     uint256 amountOut,
330     uint256 amountInMax,
331     address[] calldata path,
332     address to,
333     uint256 deadline
334   ) external returns (uint256[] memory amounts);
335 
336   function swapExactTokensForETH(
337     uint256 amountIn,
338     uint256 amountOutMin,
339     address[] calldata path,
340     address to,
341     uint256 deadline
342   ) external returns (uint256[] memory amounts);
343 
344   function swapETHForExactTokens(
345     uint256 amountOut,
346     address[] calldata path,
347     address to,
348     uint256 deadline
349   ) external payable returns (uint256[] memory amounts);
350 
351   function quote(
352     uint256 amountA,
353     uint256 reserveA,
354     uint256 reserveB
355   ) external pure returns (uint256 amountB);
356 
357   function getAmountOut(
358     uint256 amountIn,
359     uint256 reserveIn,
360     uint256 reserveOut
361   ) external pure returns (uint256 amountOut);
362 
363   function getAmountIn(
364     uint256 amountOut,
365     uint256 reserveIn,
366     uint256 reserveOut
367   ) external pure returns (uint256 amountIn);
368 
369   function getAmountsOut(uint256 amountIn, address[] calldata path)
370     external
371     view
372     returns (uint256[] memory amounts);
373 
374   function getAmountsIn(uint256 amountOut, address[] calldata path)
375     external
376     view
377     returns (uint256[] memory amounts);
378 }
379 
380 
381 interface IUniswapV2Router02 is IUniswapV2Router01 {
382   function removeLiquidityETHSupportingFeeOnTransferTokens(
383     address token,
384     uint256 liquidity,
385     uint256 amountTokenMin,
386     uint256 amountETHMin,
387     address to,
388     uint256 deadline
389   ) external returns (uint256 amountETH);
390 
391   function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
392     address token,
393     uint256 liquidity,
394     uint256 amountTokenMin,
395     uint256 amountETHMin,
396     address to,
397     uint256 deadline,
398     bool approveMax,
399     uint8 v,
400     bytes32 r,
401     bytes32 s
402   ) external returns (uint256 amountETH);
403 
404   function swapExactTokensForTokensSupportingFeeOnTransferTokens(
405     uint256 amountIn,
406     uint256 amountOutMin,
407     address[] calldata path,
408     address to,
409     uint256 deadline
410   ) external;
411 
412   function swapExactETHForTokensSupportingFeeOnTransferTokens(
413     uint256 amountOutMin,
414     address[] calldata path,
415     address to,
416     uint256 deadline
417   ) external payable;
418 
419   function swapExactTokensForETHSupportingFeeOnTransferTokens(
420     uint256 amountIn,
421     uint256 amountOutMin,
422     address[] calldata path,
423     address to,
424     uint256 deadline
425   ) external;
426 }
427 
428 
429 abstract contract Context {
430     function _msgSender() internal view virtual returns (address payable) {
431         return msg.sender;
432     }
433 
434     function _msgData() internal view virtual returns (bytes memory) {
435         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
436         return msg.data;
437     }
438 }
439 
440 
441 contract ERC20 is IERC20 {
442   using SafeMath for uint256;
443 
444   mapping(address => uint256) private _balances;
445 
446   mapping(address => mapping(address => uint256)) private _allowances;
447 
448   uint256 private _totalSupply;
449 
450   string private _name;
451   string private _symbol;
452   uint8 private _decimals;
453 
454   /**
455    * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
456    * a default value of 18.
457    *
458    * To select a different value for {decimals}, use {_setupDecimals}.
459    *
460    * All three of these values are immutable: they can only be set once during
461    * construction.
462    */
463   constructor(string memory name, string memory symbol) public {
464     _name = name;
465     _symbol = symbol;
466     _decimals = 18;
467   }
468 
469   /**
470    * @dev Returns the name of the token.
471    */
472   function name() public view returns (string memory) {
473     return _name;
474   }
475 
476   /**
477    * @dev Returns the symbol of the token, usually a shorter version of the
478    * name.
479    */
480   function symbol() public view returns (string memory) {
481     return _symbol;
482   }
483 
484   /**
485    * @dev Returns the number of decimals used to get its user representation.
486    * For example, if `decimals` equals `2`, a balance of `505` tokens should
487    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
488    *
489    * Tokens usually opt for a value of 18, imitating the relationship between
490    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
491    * called.
492    *
493    * NOTE: This information is only used for _display_ purposes: it in
494    * no way affects any of the arithmetic of the contract, including
495    * {IERC20-balanceOf} and {IERC20-transfer}.
496    */
497   function decimals() public view returns (uint8) {
498     return _decimals;
499   }
500 
501   /**
502    * @dev See {IERC20-totalSupply}.
503    */
504   function totalSupply() public override view returns (uint256) {
505     return _totalSupply;
506   }
507 
508   /**
509    * @dev See {IERC20-balanceOf}.
510    */
511   function balanceOf(address account) public override view returns (uint256) {
512     return _balances[account];
513   }
514 
515   /**
516    * @dev See {IERC20-transfer}.
517    *
518    * Requirements:
519    *
520    * - `recipient` cannot be the zero address.
521    * - the caller must have a balance of at least `amount`.
522    */
523   function transfer(address recipient, uint256 amount)
524     public
525     override
526     returns (bool)
527   {
528     _transfer(msg.sender, recipient, amount);
529     return true;
530   }
531 
532   /**
533    * @dev See {IERC20-allowance}.
534    */
535   function allowance(address owner, address spender)
536     public
537     override
538     view
539     returns (uint256)
540   {
541     return _allowances[owner][spender];
542   }
543 
544   /**
545    * @dev See {IERC20-approve}.
546    *
547    * Requirements:
548    *
549    * - `spender` cannot be the zero address.
550    */
551   function approve(address spender, uint256 amount)
552     public
553     override
554     returns (bool)
555   {
556     _approve(msg.sender, spender, amount);
557     return true;
558   }
559 
560   /**
561    * @dev See {IERC20-transferFrom}.
562    *
563    * Emits an {Approval} event indicating the updated allowance. This is not
564    * required by the EIP. See the note at the beginning of {ERC20};
565    *
566    * Requirements:
567    * - `sender` and `recipient` cannot be the zero address.
568    * - `sender` must have a balance of at least `amount`.
569    * - the caller must have allowance for ``sender``'s tokens of at least
570    * `amount`.
571    */
572   function transferFrom(
573     address sender,
574     address recipient,
575     uint256 amount
576   ) public virtual override returns (bool) {
577     _transfer(sender, recipient, amount);
578     _approve(
579       sender,
580       msg.sender,
581       _allowances[sender][msg.sender].sub(
582         amount,
583         'ERC20: transfer amount exceeds allowance'
584       )
585     );
586     return true;
587   }
588 
589   /**
590    * @dev Atomically increases the allowance granted to `spender` by the caller.
591    *
592    * This is an alternative to {approve} that can be used as a mitigation for
593    * problems described in {IERC20-approve}.
594    *
595    * Emits an {Approval} event indicating the updated allowance.
596    *
597    * Requirements:
598    *
599    * - `spender` cannot be the zero address.
600    */
601   function increaseAllowance(address spender, uint256 addedValue)
602     public
603     returns (bool)
604   {
605     _approve(
606       msg.sender,
607       spender,
608       _allowances[msg.sender][spender].add(addedValue)
609     );
610     return true;
611   }
612 
613   /**
614    * @dev Atomically decreases the allowance granted to `spender` by the caller.
615    *
616    * This is an alternative to {approve} that can be used as a mitigation for
617    * problems described in {IERC20-approve}.
618    *
619    * Emits an {Approval} event indicating the updated allowance.
620    *
621    * Requirements:
622    *
623    * - `spender` cannot be the zero address.
624    * - `spender` must have allowance for the caller of at least
625    * `subtractedValue`.
626    */
627   function decreaseAllowance(address spender, uint256 subtractedValue)
628     public
629     virtual
630     returns (bool)
631   {
632     _approve(
633       msg.sender,
634       spender,
635       _allowances[msg.sender][spender].sub(
636         subtractedValue,
637         'ERC20: decreased allowance below zero'
638       )
639     );
640     return true;
641   }
642 
643   /**
644    * @dev Moves tokens `amount` from `sender` to `recipient`.
645    *
646    * This is internal function is equivalent to {transfer}, and can be used to
647    * e.g. implement automatic token fees, slashing mechanisms, etc.
648    *
649    * Emits a {Transfer} event.
650    *
651    * Requirements:
652    *
653    * - `sender` cannot be the zero address.
654    * - `recipient` cannot be the zero address.
655    * - `sender` must have a balance of at least `amount`.
656    */
657   function _transfer(
658     address sender,
659     address recipient,
660     uint256 amount
661   ) internal virtual {
662     require(sender != address(0), 'ERC20: transfer from the zero address');
663     require(recipient != address(0), 'ERC20: transfer to the zero address');
664     _balances[sender] = _balances[sender].sub(
665       amount,
666       'ERC20: transfer amount exceeds balance'
667     );
668     _balances[recipient] = _balances[recipient].add(amount);
669     emit Transfer(sender, recipient, amount);
670   }
671 
672   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
673    * the total supply.
674    *
675    * Emits a {Transfer} event with `from` set to the zero address.
676    *
677    * Requirements
678    *
679    * - `to` cannot be the zero address.
680    */
681   function _mint(address account, uint256 amount) internal virtual {
682     require(account != address(0), 'ERC20: mint to the zero address');
683     _totalSupply = _totalSupply.add(amount);
684     _balances[account] = _balances[account].add(amount);
685     emit Transfer(address(0), account, amount);
686   }
687 
688   /**
689    * @dev Destroys `amount` tokens from `account`, reducing the
690    * total supply.
691    *
692    * Emits a {Transfer} event with `to` set to the zero address.
693    *
694    * Requirements
695    *
696    * - `account` cannot be the zero address.
697    * - `account` must have at least `amount` tokens.
698    */
699   function _burn(address account, uint256 amount) internal virtual {
700     require(account != address(0), 'ERC20: burn from the zero address');
701     _balances[account] = _balances[account].sub(
702       amount,
703       'ERC20: burn amount exceeds balance'
704     );
705     _totalSupply = _totalSupply.sub(amount);
706     emit Transfer(account, address(0), amount);
707   }
708 
709   /**
710    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
711    *
712    * This is internal function is equivalent to `approve`, and can be used to
713    * e.g. set automatic allowances for certain subsystems, etc.
714    *
715    * Emits an {Approval} event.
716    *
717    * Requirements:
718    *
719    * - `owner` cannot be the zero address.
720    * - `spender` cannot be the zero address.
721    */
722   function _approve(
723     address owner,
724     address spender,
725     uint256 amount
726   ) internal virtual {
727     require(owner != address(0), 'ERC20: approve from the zero address');
728     require(spender != address(0), 'ERC20: approve to the zero address');
729 
730     _allowances[owner][spender] = amount;
731     emit Approval(owner, spender, amount);
732   }
733 }
734 
735 
736 contract Ownable is Context {
737     address private _owner;
738 
739     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
740 
741     /**
742      * @dev Initializes the contract setting the deployer as the initial owner.
743      */
744     constructor () internal {
745         address msgSender = _msgSender();
746         _owner = msgSender;
747         emit OwnershipTransferred(address(0), msgSender);
748     }
749 
750     /**
751      * @dev Returns the address of the current owner.
752      */
753     function owner() public view returns (address) {
754         return _owner;
755     }
756 
757     /**
758      * @dev Throws if called by any account other than the owner.
759      */
760     modifier onlyOwner() {
761         require(_owner == _msgSender(), "Ownable: caller is not the owner");
762         _;
763     }
764 
765     /**
766      * @dev Leaves the contract without owner. It will not be possible to call
767      * `onlyOwner` functions anymore. Can only be called by the current owner.
768      *
769      * NOTE: Renouncing ownership will leave the contract without an owner,
770      * thereby removing any functionality that is only available to the owner.
771      */
772     function renounceOwnership() public virtual onlyOwner {
773         emit OwnershipTransferred(_owner, address(0));
774         _owner = address(0);
775     }
776 
777     /**
778      * @dev Transfers ownership of the contract to a new account (`newOwner`).
779      * Can only be called by the current owner.
780      */
781     function transferOwnership(address newOwner) public virtual onlyOwner {
782         require(newOwner != address(0), "Ownable: new owner is the zero address");
783         emit OwnershipTransferred(_owner, newOwner);
784         _owner = newOwner;
785     }
786 }
787 
788 
789 contract Token is IERC20, Ownable {
790     using SafeMath for uint256;
791     
792     struct Challenger {
793         uint256 acceptance;
794         uint256 challenge;
795     }
796     
797     uint256 private constant _BASE = 1 * _DECIMALFACTOR;
798     uint32  private constant _TERM = 24 hours;
799     
800     uint256 private _prizes;
801     uint256 private _challenges;
802     
803     mapping (address => Challenger) private _challengers;
804     
805     uint256 private _power;
806     mapping (address => uint256) private _powers;
807 
808     string  private constant _NAME = "Gauntlet Finance";
809     string  private constant _SYMBOL = "GFIv2";
810     uint8   private constant _DECIMALS = 18;
811     
812     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
813     
814     uint8   private constant _DENOMINATOR = 100;
815     uint8   private constant _PRECISION   = 100;
816 
817     mapping (address => uint256) private _balances;
818     mapping (address => mapping (address => uint256)) private _allowances;
819     
820     uint256 private _totalSupply; 
821 
822     uint256 private immutable _rate;
823     uint8   private immutable _penalty;
824     uint256 private immutable _requirement;
825     
826     uint256 private immutable _initialSupply;
827 
828     uint256 private _contributors;
829 
830     bool    private _paused;
831     address private _TDE;
832     
833 
834     event Penalized(
835         address indexed account,
836         uint256 amount);
837     
838     event Boosted(
839         address indexed account,
840         uint256 amount);
841     
842     event Deflated(
843         uint256 supply,
844         uint256 amount);
845     
846     event Recovered(
847         uint256 supply,
848         uint256 amount);
849     
850     event Added(
851         address indexed account,
852         uint256 time);
853         
854     event Removed(
855         address indexed account,
856         uint256 time);
857     
858     event Accepted(
859         address indexed account,
860         uint256 amount);
861 
862     event Rewarded(
863         address indexed account,
864         uint256 amount);
865         
866     event Powered(
867         address indexed account,
868         uint256 power);
869     
870     event Forfeited(
871         address indexed account,
872         uint256 amount);
873         
874     event Unpaused(
875         address indexed account,
876         uint256 time); 
877     
878     
879     constructor (
880         uint256 rate, 
881         uint8   penalty,
882         uint256 requirement) 
883         public {
884             
885         require(rate > 0, 
886         "error: must be larger than zero");
887         require(penalty > 0, 
888         "error: must be larger than zero");
889         require(requirement > 0, 
890         "error: must be larger than zero");
891             
892         _rate = rate;
893         _penalty = penalty;
894         _requirement = requirement;
895         
896         uint256 prizes = 20000 * _DECIMALFACTOR;
897         uint256 capacity = 25000 * _DECIMALFACTOR;
898         uint256 operations = 55000 * _DECIMALFACTOR;
899 
900         _mint(_environment(), prizes.add(capacity));
901         _mint(_msgSender(), operations);
902         
903         _prizes = prizes;
904         _initialSupply = prizes.add(capacity).add(operations);
905         
906         _paused = true;
907     }
908     
909 
910     function setTokenDistributionEvent(address TDE) external onlyOwner returns (bool) {
911         require(TDE != address(0), 
912         "error: must not be the zero address");
913         
914         require(_TDE == address(0), 
915         "error: must not be set already");
916     
917         _TDE = TDE;
918         return true;
919     }
920     function unpause() external returns (bool) {
921         address account = _msgSender();
922         
923         require(account == owner() || account == _TDE, 
924         "error: must be owner or must be token distribution event");
925 
926         _paused = false;
927         
928         emit Unpaused(account, _time());
929         return true;
930     }
931     
932     function reward() external returns (bool) {
933         uint256 prizes = getPrizesTotal();
934         
935         require(prizes > 0, 
936         "error: must be prizes available");
937         
938         address account = _msgSender();
939         
940         require(getReward(account) > 0, 
941         "error: must be worthy of a reward");
942         
943         uint256 amount = getReward(account);
944         
945         if (_isExcessive(amount, prizes)) {
946             
947             uint256 excess = amount.sub(prizes);
948             amount = amount.sub(excess);
949             
950             _challengers[account].acceptance = _time();
951             _prizes = _prizes.sub(amount);
952             _mint(account, amount);
953             emit Rewarded(account, amount);
954             
955         } else {
956             _challengers[account].acceptance = _time();
957             _prizes = _prizes.sub(amount);
958             _mint(account, amount);
959             emit Rewarded(account, amount);
960         }
961         return true;
962     }
963     function challenge(uint256 amount) external returns (bool) {
964         address account = _msgSender();
965         uint256 processed = amount.mul(_DECIMALFACTOR);
966         
967         require(_isEligible(account, processed), 
968         "error: must have sufficient holdings");
969         
970         require(_isContributor(account), 
971         "error: must be a contributor");
972         
973         require(_isAcceptable(processed), 
974         "error: must comply with requirement");
975         
976         _challengers[account].acceptance = _time();
977         _challengers[account].challenge = processed;
978         
979         _challenges = _challenges.add(processed);
980         
981         emit Accepted(account, processed);
982         return true;
983     }
984     
985     function powerUp() external returns (bool) {
986         address account = _msgSender();
987         
988         require(getReward(account) > 0, 
989         "error: must be worthy of a reward");
990         
991         uint256 amount = getReward(account);
992 
993         _challengers[account].acceptance = _time();        
994         _powers[account] = _powers[account].add(amount);
995         _power = _power.add(amount);
996         
997         emit Powered(account, amount);
998         return true;
999     }
1000     function powerDown() external returns (bool) {
1001         uint256 prizes = getPrizesTotal();
1002         
1003         require(prizes > 0, 
1004         "error: must be prizes available");
1005         
1006         address account = _msgSender();
1007         
1008         require(getPower(account) > 0, 
1009         "error: must have convertible power");
1010         
1011         uint256 amount = getPower(account);
1012 
1013         if (_isExcessive(amount, prizes)) {
1014             
1015             uint256 excess = amount.sub(prizes);
1016             amount = amount.sub(excess);
1017             
1018             _powers[account] = _powers[account].sub(amount);  
1019             _power = _power.sub(amount);
1020             
1021             _prizes = _prizes.sub(amount);
1022             _mint(account, amount);
1023             emit Rewarded(account, amount);
1024             
1025         } else {
1026             _powers[account] = _powers[account].sub(amount);  
1027             _power = _power.sub(amount);
1028             
1029             _prizes = _prizes.sub(amount);
1030             _mint(account, amount);
1031             emit Rewarded(account, amount);
1032         }
1033         
1034         emit Powered(account, amount);
1035         return true;
1036     }
1037     
1038     function burn(uint256 amount) external returns (bool) {
1039         _burn(_msgSender(), amount);
1040         return true;
1041     }
1042     
1043     function getTerm() public pure returns (uint256) {
1044         return _TERM;
1045     }
1046     function getBase() public pure returns (uint256) {
1047         return _BASE;
1048     }
1049     
1050     function getAcceptance(address account) public view returns (uint256) {
1051         return _challengers[account].acceptance;
1052     }
1053     function getPeriod(address account) public view returns (uint256) {
1054         if (getAcceptance(account) > 0) {
1055             
1056             uint256 period = _time().sub(_challengers[account].acceptance);
1057             uint256 term = getTerm();
1058             
1059             if (period >= term) {
1060                 return period.div(term);
1061             } else {
1062                 return 0;
1063             }
1064             
1065         } else { 
1066             return 0;
1067         }
1068     }
1069     
1070     function getChallenge(address account) public view returns (uint256) {
1071         return _challengers[account].challenge;
1072     }
1073     function getFerocity(address account) public view returns (uint256) {
1074         return (getChallenge(account).mul(_PRECISION)).div(getRequirement());
1075     }
1076     function getReward(address account) public view returns (uint256) {
1077         return _getBlock(account).mul((_BASE.mul(getFerocity(account))).div(_PRECISION));
1078     } 
1079     function getPower(address account) public view returns (uint256) {
1080         return _powers[account];
1081     }
1082     
1083     function getPrizesTotal() public view returns (uint256) {
1084         return _prizes;
1085     }
1086     function getChallengesTotal() public view returns (uint256) {
1087         return _challenges;
1088     }   
1089     function getPowerTotal() public view returns (uint256) {
1090         return _power;
1091     }
1092     
1093     function getRate() public view returns (uint256) {
1094         return _rate;
1095     }
1096     function getPenalty() public view returns (uint8) {
1097         return _penalty;
1098     }
1099     function getRequirement() public view returns (uint256) {
1100         return _requirement;
1101     }
1102 
1103     function getCapacity() public view returns (uint256) {
1104         return balanceOf(_environment()).sub(getPrizesTotal());
1105     }
1106     
1107     function getContributorsTotal() public view returns (uint256) {
1108         return _contributors;
1109     }
1110     function getContributorsLimit() public view returns (uint256) {
1111         return getCapacity().div(getRate());
1112     }
1113 
1114     function name() public pure returns (string memory) {
1115         return _NAME;
1116     }
1117     function symbol() public pure returns (string memory) {
1118         return _SYMBOL;
1119     }
1120     function decimals() public pure returns (uint8) {
1121         return _DECIMALS;
1122     }
1123 
1124     function totalSupply() public view override returns (uint256) {
1125         return _totalSupply;
1126     }
1127     function initialSupply() public view returns (uint256) {
1128         return _initialSupply;
1129     }
1130     
1131     function balanceOf(address account) public view override returns (uint256) {
1132         return _balances[account];
1133     }
1134 
1135     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1136         return _allowances[owner][spender];
1137     }
1138     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1139         _approve(_msgSender(), spender, amount);
1140         return true;
1141     }
1142 
1143     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1144         address sender = _msgSender();
1145 
1146         require(_isNotPaused() || recipient == _TDE || sender == _TDE, 
1147         "error: must not be paused else must be token distribution event recipient or sender");
1148 
1149         _checkReactiveness(sender, recipient, amount);
1150         _checkChallenger(sender, amount);
1151         
1152         _transfer(sender, recipient, amount);
1153 
1154         return true;
1155     }
1156     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1157         require(_isNotPaused() || recipient == _TDE || sender == _TDE, 
1158         "error: must not be paused else must be token distribution event recipient or sender");
1159         
1160         _checkReactiveness(sender, recipient, amount);
1161         _checkChallenger(sender, amount);
1162         
1163         _transfer(sender, recipient, amount);
1164         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1165 
1166         return true;
1167     }
1168     
1169     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1170         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1171         return true;
1172     }
1173     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1175         return true;
1176     }
1177     
1178     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1179         require(sender != address(0), "ERC20: transfer from the zero address");
1180         require(recipient != address(0), "ERC20: transfer to the zero address");
1181         
1182         if (sender == owner() && recipient == _TDE || sender == _TDE) {
1183             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1184             _balances[recipient] = _balances[recipient].add(amount);
1185             
1186             emit Transfer(sender, recipient, amount);
1187             
1188         } else {
1189             uint256 penalty = _computePenalty(amount);
1190             
1191             uint256 boosted = penalty.div(2);
1192             uint256 prize   = penalty.div(2);
1193 
1194             _prize(prize);
1195             _boost(boosted);
1196 
1197             uint256 processed = amount.sub(penalty);
1198             
1199             _balances[sender] = _balances[sender].sub(processed, "ERC20: transfer amount exceeds balance");
1200             _balances[recipient] = _balances[recipient].add(processed);
1201             
1202             emit Transfer(sender, recipient, processed);
1203         }
1204     }
1205 
1206     function _mint(address account, uint256 amount) internal virtual {
1207         require(account != address(0), "ERC20: mint to the zero address");
1208 
1209         _totalSupply = _totalSupply.add(amount);
1210         _balances[account] = _balances[account].add(amount);
1211         
1212         emit Transfer(address(0), account, amount);
1213     }
1214     function _burn(address account, uint256 amount) internal virtual {
1215         require(account != address(0), "ERC20: burn from the zero address");
1216 
1217         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1218         _totalSupply = _totalSupply.sub(amount);
1219         
1220         emit Transfer(account, address(0), amount);
1221     }
1222     
1223     function _approve(address owner, address spender, uint256 amount) internal virtual {
1224         require(owner != address(0), "ERC20: approve from the zero address");
1225         require(spender != address(0), "ERC20: approve to the zero address");
1226 
1227         _allowances[owner][spender] = amount;
1228         emit Approval(owner, spender, amount);
1229     }
1230     
1231     function _boost(uint256 amount) private returns (bool) {
1232         _mint(_environment(), amount);
1233         emit Boosted(_environment(), amount);
1234         return true;
1235     }
1236     function _prize(uint256 amount) private returns (bool) {
1237         _mint(_environment(), amount);
1238         _prizes = _prizes.add(amount);
1239         emit Rewarded(_environment(), amount);
1240         return true;
1241     }
1242     
1243     function _checkReactiveness(address sender, address recipient, uint256 amount) private {
1244         if (_isUnique(recipient)) {
1245             if (_isCompliant(recipient, amount)) {
1246                 _addContributor(recipient);
1247                 if(_isElastic()) {
1248                     _deflate();
1249                 }
1250             }
1251         }
1252         if (_isNotUnique(sender)) {
1253             if (_isNotCompliant(sender, amount)) {
1254                 _removeContributor(sender);
1255                 if(_isElastic()) {
1256                     _recover();
1257                 }
1258             }
1259         }
1260     }
1261     function _checkChallenger(address account, uint256 amount) private {
1262         if (_isChallenger(account)) {
1263             if (balanceOf(account).sub(amount) < getChallenge(account)) {
1264                 
1265                 uint256 challenged = getChallenge(account);
1266                 _challenges = _challenges.sub(challenged);
1267                 
1268                 delete _challengers[account].acceptance;
1269                 delete _challengers[account].challenge;
1270                 
1271                 emit Forfeited(account, challenged);
1272             }
1273         }
1274     }    
1275     
1276     function _deflate() private returns (bool) {
1277         uint256 amount = getRate();
1278         _burn(_environment(), amount);
1279         emit Deflated(totalSupply(), amount);
1280         return true;
1281         
1282     }
1283     function _recover() private returns (bool) {
1284         uint256 amount = getRate();
1285         _mint(_environment(), amount);
1286         emit Recovered(totalSupply(), amount);
1287         return true;
1288     }
1289     
1290     function _addContributor(address account) private returns (bool) {
1291         _contributors++;
1292         emit Added(account, _time());
1293         return true;
1294     } 
1295     function _removeContributor(address account) private returns (bool) {
1296         _contributors--;
1297         emit Removed(account, _time());
1298         return true;
1299     } 
1300 
1301     function _computePenalty(uint256 amount) private view returns (uint256) {
1302         return (amount.mul(getPenalty())).div(_DENOMINATOR);
1303     }
1304     function _isNotPaused() private view returns (bool) {
1305         if (_paused) { return false; } else { return true; }
1306     }
1307 
1308     function _isUnique(address account) private view returns (bool) {
1309         if (balanceOf(account) < getRequirement()) { return true; } else { return false; }
1310     }
1311     function _isNotUnique(address account) private view returns (bool) {
1312         if (balanceOf(account) > getRequirement()) { return true; } else { return false; }
1313     }    
1314     
1315     function _getAcceptance(address account) private view returns (uint256) {
1316         return _challengers[account].acceptance;
1317     }
1318     function _getEpoch(address account) private view returns (uint256) {
1319         if (_getAcceptance(account) > 0) { return _time().sub(_getAcceptance(account)); } else { return 0; }
1320     } 
1321     function _getBlock(address account) private view returns (uint256) {
1322         return _getEpoch(account).div(_TERM); 
1323     }
1324     
1325     function _isContributor(address account) private view returns (bool) {
1326         if (balanceOf(account) >= getRequirement()) { return true; } else { return false; }
1327     }
1328     function _isEligible(address account, uint256 amount) private view returns (bool) {
1329         if (balanceOf(account) >= amount) { return true; } else { return false; }
1330     }
1331     function _isAcceptable(uint256 amount) private view returns (bool) {
1332         if (amount >= getRequirement()) { return true; } else { return false; }
1333     }
1334     function _isChallenger(address account) private view returns (bool) {
1335         if (_getAcceptance(account) > 0) { return true; } else { return false; }
1336     }
1337     
1338     function _isExcessive(uint256 amount, uint256 ceiling) private pure returns (bool) {
1339         if (amount > ceiling) { return true; } else { return false; }
1340     }
1341     
1342     function _isCompliant(address account, uint256 amount) private view returns (bool) {
1343         if (balanceOf(account).add(amount) >= getRequirement()) { return true; } else { return false; }
1344     }
1345     function _isNotCompliant(address account, uint256 amount) private view returns (bool) {
1346         if (balanceOf(account).sub(amount) < getRequirement()) { return true; } else { return false; }
1347     }
1348     
1349     function _isElastic() private view returns (bool) {
1350         if (getContributorsTotal() <= getContributorsLimit() && getContributorsTotal() > 0) { return true; } else { return false; }
1351     }
1352     
1353     function _environment() private view returns (address) {
1354         return address(this);
1355     }
1356     function _time() private view returns (uint256) {
1357         return block.timestamp;
1358     }
1359     
1360 }