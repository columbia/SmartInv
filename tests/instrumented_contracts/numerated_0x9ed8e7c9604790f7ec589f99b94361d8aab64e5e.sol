1 pragma solidity 0.6.6;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      *
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      *
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      *
56      * - Subtraction cannot overflow.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      *
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      *
99      * - The divisor cannot be zero.
100      */
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 
160 interface IUniswapV2Router01 {
161   function factory() external pure returns (address);
162 
163   function WETH() external pure returns (address);
164 
165   function addLiquidity(
166     address tokenA,
167     address tokenB,
168     uint256 amountADesired,
169     uint256 amountBDesired,
170     uint256 amountAMin,
171     uint256 amountBMin,
172     address to,
173     uint256 deadline
174   )
175     external
176     returns (
177       uint256 amountA,
178       uint256 amountB,
179       uint256 liquidity
180     );
181 
182   function addLiquidityETH(
183     address token,
184     uint256 amountTokenDesired,
185     uint256 amountTokenMin,
186     uint256 amountETHMin,
187     address to,
188     uint256 deadline
189   )
190     external
191     payable
192     returns (
193       uint256 amountToken,
194       uint256 amountETH,
195       uint256 liquidity
196     );
197 
198   function removeLiquidity(
199     address tokenA,
200     address tokenB,
201     uint256 liquidity,
202     uint256 amountAMin,
203     uint256 amountBMin,
204     address to,
205     uint256 deadline
206   ) external returns (uint256 amountA, uint256 amountB);
207 
208   function removeLiquidityETH(
209     address token,
210     uint256 liquidity,
211     uint256 amountTokenMin,
212     uint256 amountETHMin,
213     address to,
214     uint256 deadline
215   ) external returns (uint256 amountToken, uint256 amountETH);
216 
217   function removeLiquidityWithPermit(
218     address tokenA,
219     address tokenB,
220     uint256 liquidity,
221     uint256 amountAMin,
222     uint256 amountBMin,
223     address to,
224     uint256 deadline,
225     bool approveMax,
226     uint8 v,
227     bytes32 r,
228     bytes32 s
229   ) external returns (uint256 amountA, uint256 amountB);
230 
231   function removeLiquidityETHWithPermit(
232     address token,
233     uint256 liquidity,
234     uint256 amountTokenMin,
235     uint256 amountETHMin,
236     address to,
237     uint256 deadline,
238     bool approveMax,
239     uint8 v,
240     bytes32 r,
241     bytes32 s
242   ) external returns (uint256 amountToken, uint256 amountETH);
243 
244   function swapExactTokensForTokens(
245     uint256 amountIn,
246     uint256 amountOutMin,
247     address[] calldata path,
248     address to,
249     uint256 deadline
250   ) external returns (uint256[] memory amounts);
251 
252   function swapTokensForExactTokens(
253     uint256 amountOut,
254     uint256 amountInMax,
255     address[] calldata path,
256     address to,
257     uint256 deadline
258   ) external returns (uint256[] memory amounts);
259 
260   function swapExactETHForTokens(
261     uint256 amountOutMin,
262     address[] calldata path,
263     address to,
264     uint256 deadline
265   ) external payable returns (uint256[] memory amounts);
266 
267   function swapTokensForExactETH(
268     uint256 amountOut,
269     uint256 amountInMax,
270     address[] calldata path,
271     address to,
272     uint256 deadline
273   ) external returns (uint256[] memory amounts);
274 
275   function swapExactTokensForETH(
276     uint256 amountIn,
277     uint256 amountOutMin,
278     address[] calldata path,
279     address to,
280     uint256 deadline
281   ) external returns (uint256[] memory amounts);
282 
283   function swapETHForExactTokens(
284     uint256 amountOut,
285     address[] calldata path,
286     address to,
287     uint256 deadline
288   ) external payable returns (uint256[] memory amounts);
289 
290   function quote(
291     uint256 amountA,
292     uint256 reserveA,
293     uint256 reserveB
294   ) external pure returns (uint256 amountB);
295 
296   function getAmountOut(
297     uint256 amountIn,
298     uint256 reserveIn,
299     uint256 reserveOut
300   ) external pure returns (uint256 amountOut);
301 
302   function getAmountIn(
303     uint256 amountOut,
304     uint256 reserveIn,
305     uint256 reserveOut
306   ) external pure returns (uint256 amountIn);
307 
308   function getAmountsOut(uint256 amountIn, address[] calldata path)
309     external
310     view
311     returns (uint256[] memory amounts);
312 
313   function getAmountsIn(uint256 amountOut, address[] calldata path)
314     external
315     view
316     returns (uint256[] memory amounts);
317 }
318 
319 
320 interface IUniswapV2Router02 is IUniswapV2Router01 {
321   function removeLiquidityETHSupportingFeeOnTransferTokens(
322     address token,
323     uint256 liquidity,
324     uint256 amountTokenMin,
325     uint256 amountETHMin,
326     address to,
327     uint256 deadline
328   ) external returns (uint256 amountETH);
329 
330   function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
331     address token,
332     uint256 liquidity,
333     uint256 amountTokenMin,
334     uint256 amountETHMin,
335     address to,
336     uint256 deadline,
337     bool approveMax,
338     uint8 v,
339     bytes32 r,
340     bytes32 s
341   ) external returns (uint256 amountETH);
342 
343   function swapExactTokensForTokensSupportingFeeOnTransferTokens(
344     uint256 amountIn,
345     uint256 amountOutMin,
346     address[] calldata path,
347     address to,
348     uint256 deadline
349   ) external;
350 
351   function swapExactETHForTokensSupportingFeeOnTransferTokens(
352     uint256 amountOutMin,
353     address[] calldata path,
354     address to,
355     uint256 deadline
356   ) external payable;
357 
358   function swapExactTokensForETHSupportingFeeOnTransferTokens(
359     uint256 amountIn,
360     uint256 amountOutMin,
361     address[] calldata path,
362     address to,
363     uint256 deadline
364   ) external;
365 }
366 
367 
368 /**
369  * @dev Interface of the ERC20 standard as defined in the EIP.
370  */
371 interface IERC20 {
372   /**
373    * @dev Returns the amount of tokens in existence.
374    */
375   function totalSupply() external view returns (uint256);
376 
377   /**
378    * @dev Returns the amount of tokens owned by `account`.
379    */
380   function balanceOf(address account) external view returns (uint256);
381 
382   /**
383    * @dev Moves `amount` tokens from the caller's account to `recipient`.
384    *
385    * Returns a boolean value indicating whether the operation succeeded.
386    *
387    * Emits a {Transfer} event.
388    */
389   function transfer(address recipient, uint256 amount) external returns (bool);
390 
391   /**
392    * @dev Returns the remaining number of tokens that `spender` will be
393    * allowed to spend on behalf of `owner` through {transferFrom}. This is
394    * zero by default.
395    *
396    * This value changes when {approve} or {transferFrom} are called.
397    */
398   function allowance(address owner, address spender)
399     external
400     view
401     returns (uint256);
402 
403   /**
404    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
405    *
406    * Returns a boolean value indicating whether the operation succeeded.
407    *
408    * IMPORTANT: Beware that changing an allowance with this method brings the risk
409    * that someone may use both the old and the new allowance by unfortunate
410    * transaction ordering. One possible solution to mitigate this race
411    * condition is to first reduce the spender's allowance to 0 and set the
412    * desired value afterwards:
413    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
414    *
415    * Emits an {Approval} event.
416    */
417   function approve(address spender, uint256 amount) external returns (bool);
418 
419   /**
420    * @dev Moves `amount` tokens from `sender` to `recipient` using the
421    * allowance mechanism. `amount` is then deducted from the caller's
422    * allowance.
423    *
424    * Returns a boolean value indicating whether the operation succeeded.
425    *
426    * Emits a {Transfer} event.
427    */
428   function transferFrom(
429     address sender,
430     address recipient,
431     uint256 amount
432   ) external returns (bool);
433 
434   /**
435    * @dev Emitted when `value` tokens are moved from one account (`from`) to
436    * another (`to`).
437    *
438    * Note that `value` may be zero.
439    */
440   event Transfer(address indexed from, address indexed to, uint256 value);
441 
442   /**
443    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
444    * a call to {approve}. `value` is the new allowance.
445    */
446   event Approval(address indexed owner, address indexed spender, uint256 value);
447 }
448 
449 
450 /**
451  * @dev Implementation of the {IERC20} interface.
452  *
453  * This implementation is agnostic to the way tokens are created. This means
454  * that a supply mechanism has to be added in a derived contract using {_mint}.
455  * For a generic mechanism see {ERC20PresetMinterPauser}.
456  *
457  * TIP: For a detailed writeup see our guide
458  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
459  * to implement supply mechanisms].
460  *
461  * We have followed general OpenZeppelin guidelines: functions revert instead
462  * of returning `false` on failure. This behavior is nonetheless conventional
463  * and does not conflict with the expectations of ERC20 applications.
464  *
465  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
466  * This allows applications to reconstruct the allowance for all accounts just
467  * by listening to said events. Other implementations of the EIP may not emit
468  * these events, as it isn't required by the specification.
469  *
470  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
471  * functions have been added to mitigate the well-known issues around setting
472  * allowances. See {IERC20-approve}.
473  */
474 contract ERC20 is IERC20 {
475   using SafeMath for uint256;
476 
477   mapping(address => uint256) private _balances;
478 
479   mapping(address => mapping(address => uint256)) private _allowances;
480 
481   uint256 private _totalSupply;
482 
483   string private _name;
484   string private _symbol;
485   uint8 private _decimals;
486 
487   /**
488    * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
489    * a default value of 18.
490    *
491    * To select a different value for {decimals}, use {_setupDecimals}.
492    *
493    * All three of these values are immutable: they can only be set once during
494    * construction.
495    */
496   constructor(string memory name, string memory symbol) public {
497     _name = name;
498     _symbol = symbol;
499     _decimals = 18;
500   }
501 
502   /**
503    * @dev Returns the name of the token.
504    */
505   function name() public view returns (string memory) {
506     return _name;
507   }
508 
509   /**
510    * @dev Returns the symbol of the token, usually a shorter version of the
511    * name.
512    */
513   function symbol() public view returns (string memory) {
514     return _symbol;
515   }
516 
517   /**
518    * @dev Returns the number of decimals used to get its user representation.
519    * For example, if `decimals` equals `2`, a balance of `505` tokens should
520    * be displayed to a user as `5,05` (`505 / 10 ** 2`).
521    *
522    * Tokens usually opt for a value of 18, imitating the relationship between
523    * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
524    * called.
525    *
526    * NOTE: This information is only used for _display_ purposes: it in
527    * no way affects any of the arithmetic of the contract, including
528    * {IERC20-balanceOf} and {IERC20-transfer}.
529    */
530   function decimals() public view returns (uint8) {
531     return _decimals;
532   }
533 
534   /**
535    * @dev See {IERC20-totalSupply}.
536    */
537   function totalSupply() public override view returns (uint256) {
538     return _totalSupply;
539   }
540 
541   /**
542    * @dev See {IERC20-balanceOf}.
543    */
544   function balanceOf(address account) public override view returns (uint256) {
545     return _balances[account];
546   }
547 
548   /**
549    * @dev See {IERC20-transfer}.
550    *
551    * Requirements:
552    *
553    * - `recipient` cannot be the zero address.
554    * - the caller must have a balance of at least `amount`.
555    */
556   function transfer(address recipient, uint256 amount)
557     public
558     override
559     returns (bool)
560   {
561     _transfer(msg.sender, recipient, amount);
562     return true;
563   }
564 
565   /**
566    * @dev See {IERC20-allowance}.
567    */
568   function allowance(address owner, address spender)
569     public
570     override
571     view
572     returns (uint256)
573   {
574     return _allowances[owner][spender];
575   }
576 
577   /**
578    * @dev See {IERC20-approve}.
579    *
580    * Requirements:
581    *
582    * - `spender` cannot be the zero address.
583    */
584   function approve(address spender, uint256 amount)
585     public
586     override
587     returns (bool)
588   {
589     _approve(msg.sender, spender, amount);
590     return true;
591   }
592 
593   /**
594    * @dev See {IERC20-transferFrom}.
595    *
596    * Emits an {Approval} event indicating the updated allowance. This is not
597    * required by the EIP. See the note at the beginning of {ERC20};
598    *
599    * Requirements:
600    * - `sender` and `recipient` cannot be the zero address.
601    * - `sender` must have a balance of at least `amount`.
602    * - the caller must have allowance for ``sender``'s tokens of at least
603    * `amount`.
604    */
605   function transferFrom(
606     address sender,
607     address recipient,
608     uint256 amount
609   ) public virtual override returns (bool) {
610     _transfer(sender, recipient, amount);
611     _approve(
612       sender,
613       msg.sender,
614       _allowances[sender][msg.sender].sub(
615         amount,
616         'ERC20: transfer amount exceeds allowance'
617       )
618     );
619     return true;
620   }
621 
622   /**
623    * @dev Atomically increases the allowance granted to `spender` by the caller.
624    *
625    * This is an alternative to {approve} that can be used as a mitigation for
626    * problems described in {IERC20-approve}.
627    *
628    * Emits an {Approval} event indicating the updated allowance.
629    *
630    * Requirements:
631    *
632    * - `spender` cannot be the zero address.
633    */
634   function increaseAllowance(address spender, uint256 addedValue)
635     public
636     returns (bool)
637   {
638     _approve(
639       msg.sender,
640       spender,
641       _allowances[msg.sender][spender].add(addedValue)
642     );
643     return true;
644   }
645 
646   /**
647    * @dev Atomically decreases the allowance granted to `spender` by the caller.
648    *
649    * This is an alternative to {approve} that can be used as a mitigation for
650    * problems described in {IERC20-approve}.
651    *
652    * Emits an {Approval} event indicating the updated allowance.
653    *
654    * Requirements:
655    *
656    * - `spender` cannot be the zero address.
657    * - `spender` must have allowance for the caller of at least
658    * `subtractedValue`.
659    */
660   function decreaseAllowance(address spender, uint256 subtractedValue)
661     public
662     virtual
663     returns (bool)
664   {
665     _approve(
666       msg.sender,
667       spender,
668       _allowances[msg.sender][spender].sub(
669         subtractedValue,
670         'ERC20: decreased allowance below zero'
671       )
672     );
673     return true;
674   }
675 
676   /**
677    * @dev Moves tokens `amount` from `sender` to `recipient`.
678    *
679    * This is internal function is equivalent to {transfer}, and can be used to
680    * e.g. implement automatic token fees, slashing mechanisms, etc.
681    *
682    * Emits a {Transfer} event.
683    *
684    * Requirements:
685    *
686    * - `sender` cannot be the zero address.
687    * - `recipient` cannot be the zero address.
688    * - `sender` must have a balance of at least `amount`.
689    */
690   function _transfer(
691     address sender,
692     address recipient,
693     uint256 amount
694   ) internal virtual {
695     require(sender != address(0), 'ERC20: transfer from the zero address');
696     require(recipient != address(0), 'ERC20: transfer to the zero address');
697     _balances[sender] = _balances[sender].sub(
698       amount,
699       'ERC20: transfer amount exceeds balance'
700     );
701     _balances[recipient] = _balances[recipient].add(amount);
702     emit Transfer(sender, recipient, amount);
703   }
704 
705   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
706    * the total supply.
707    *
708    * Emits a {Transfer} event with `from` set to the zero address.
709    *
710    * Requirements
711    *
712    * - `to` cannot be the zero address.
713    */
714   function _mint(address account, uint256 amount) internal virtual {
715     require(account != address(0), 'ERC20: mint to the zero address');
716     _totalSupply = _totalSupply.add(amount);
717     _balances[account] = _balances[account].add(amount);
718     emit Transfer(address(0), account, amount);
719   }
720 
721   /**
722    * @dev Destroys `amount` tokens from `account`, reducing the
723    * total supply.
724    *
725    * Emits a {Transfer} event with `to` set to the zero address.
726    *
727    * Requirements
728    *
729    * - `account` cannot be the zero address.
730    * - `account` must have at least `amount` tokens.
731    */
732   function _burn(address account, uint256 amount) internal virtual {
733     require(account != address(0), 'ERC20: burn from the zero address');
734     _balances[account] = _balances[account].sub(
735       amount,
736       'ERC20: burn amount exceeds balance'
737     );
738     _totalSupply = _totalSupply.sub(amount);
739     emit Transfer(account, address(0), amount);
740   }
741 
742   /**
743    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
744    *
745    * This is internal function is equivalent to `approve`, and can be used to
746    * e.g. set automatic allowances for certain subsystems, etc.
747    *
748    * Emits an {Approval} event.
749    *
750    * Requirements:
751    *
752    * - `owner` cannot be the zero address.
753    * - `spender` cannot be the zero address.
754    */
755   function _approve(
756     address owner,
757     address spender,
758     uint256 amount
759   ) internal virtual {
760     require(owner != address(0), 'ERC20: approve from the zero address');
761     require(spender != address(0), 'ERC20: approve to the zero address');
762 
763     _allowances[owner][spender] = amount;
764     emit Approval(owner, spender, amount);
765   }
766 }
767 
768 
769 /**
770  * @dev Extension of {ERC20} that allows token holders to destroy both their own
771  * tokens and those that they have an allowance for, in a way that can be
772  * recognized off-chain (via event analysis).
773  */
774 abstract contract ERC20Burnable is ERC20 {
775   /**
776    * @dev Destroys `amount` tokens from the caller.
777    *
778    * See {ERC20-_burn}.
779    */
780   function burn(uint256 amount) public virtual {
781     _burn(msg.sender, amount);
782   }
783 
784   /**
785    * @dev Destroys `amount` tokens from `account`, deducting from the caller's
786    * allowance.
787    *
788    * See {ERC20-_burn} and {ERC20-allowance}.
789    *
790    * Requirements:
791    *
792    * - the caller must have allowance for ``accounts``'s tokens of at least
793    * `amount`.
794    */
795   function burnFrom(address account, uint256 amount) public virtual {
796     uint256 decreasedAllowance = allowance(account, msg.sender).sub(
797       amount,
798       'ERC20: burn amount exceeds allowance'
799     );
800     _approve(account, msg.sender, decreasedAllowance);
801     _burn(account, amount);
802   }
803 }
804 
805 
806 /* 
807  * @dev Implementation of a token compliant with the ERC20 Token protocol;
808  * The token has additional burn functionality. 
809  */
810 contract Token is ERC20Burnable {
811   using SafeMath for uint256;
812 
813   /* 
814  * @dev Initialization of the token, 
815  * following arguments are provided via the constructor: name, symbol, recipient, totalSupply.
816  * The total supply of tokens is minted to the specified recipient.
817  */
818   constructor(
819     string memory name,
820     string memory symbol,
821     address recipient,
822     uint256 totalSupply
823   ) public ERC20(name, symbol) {
824     _mint(recipient, totalSupply);
825   }
826 }
827 
828 
829 /* 
830  * @dev Implementation of the Initial Stake Offering (ISO). 
831  * The ISO is a decentralized token offering with trustless liquidity provisioning, 
832  * dividend accumulation and bonus rewards from staking.
833  */
834 contract UnistakeTokenSale {
835   using SafeMath for uint256;
836 
837   struct Contributor {
838         uint256 phase;
839         uint256 remainder;
840         uint256 fromTotalDivs;
841     }
842   
843   address payable public immutable wallet;
844 
845   uint256 public immutable totalSupplyR1;
846   uint256 public immutable totalSupplyR2;
847   uint256 public immutable totalSupplyR3;
848 
849   uint256 public immutable totalSupplyUniswap;
850 
851   uint256 public immutable rateR1;
852   uint256 public immutable rateR2;
853   uint256 public immutable rateR3;
854 
855   uint256 public immutable periodDurationR3;
856 
857   uint256 public immutable timeDelayR1;
858   uint256 public immutable timeDelayR2;
859 
860   uint256 public immutable stakingPeriodR1;
861   uint256 public immutable stakingPeriodR2;
862   uint256 public immutable stakingPeriodR3;
863 
864   Token public immutable token;
865   IUniswapV2Router02 public immutable uniswapRouter;
866 
867   uint256 public immutable decreasingPctToken;
868   uint256 public immutable decreasingPctETH;
869   uint256 public immutable decreasingPctRate;
870   uint256 public immutable decreasingPctBonus;
871   
872   uint256 public immutable listingRate;
873   address public immutable platformStakingContract;
874 
875   mapping(address => bool)        private _contributor;
876   mapping(address => Contributor) private _contributors;
877   mapping(address => uint256)[3]  private _contributions;
878   
879   bool[3]    private _hasEnded;
880   uint256[3] private _actualSupply;
881 
882   uint256 private _startTimeR2 = 2**256 - 1;
883   uint256 private _startTimeR3 = 2**256 - 1;
884   uint256 private _endTimeR3   = 2**256 - 1;
885 
886   mapping(address => bool)[3] private _hasWithdrawn;
887 
888   bool    private _bonusOfferingActive;
889   uint256 private _bonusOfferingActivated;
890   uint256 private _bonusTotal;
891   
892   uint256 private _contributionsTotal;
893 
894   uint256 private _contributorsTotal;
895   uint256 private _contributedFundsTotal;
896  
897   uint256 private _bonusReductionFactor;
898   uint256 private _fundsWithdrawn;
899   
900   uint256 private _endedDayR3;
901   
902   uint256 private _latestStakingPlatformPayment;
903   
904   uint256 private _totalDividends;
905   uint256 private _scaledRemainder;
906   uint256 private _scaling = uint256(10) ** 12;
907   uint256 private _phase = 1;
908   uint256 private _totalRestakedDividends;
909   
910   mapping(address => uint256) private _restkedDividends;
911   mapping(uint256 => uint256) private _payouts;         
912 
913   
914   event Staked(
915       address indexed account, 
916       uint256 amount);
917       
918   event Claimed(
919       address indexed account, 
920       uint256 amount);
921       
922   event Reclaimed(
923       address indexed account, 
924       uint256 amount);
925       
926   event Withdrawn(
927       address indexed account, 
928       uint256 amount); 
929       
930   event Penalized(
931       address indexed account, 
932       uint256 amount);
933       
934   event Ended(
935       address indexed account, 
936       uint256 amount, 
937       uint256 time);
938       
939   event Splitted(
940       address indexed account, 
941       uint256 amount1, 
942       uint256 amount2);  
943   
944   event Bought(
945       uint8 indexed round, 
946       address indexed account,
947       uint256 amount);
948       
949   event Activated(
950       bool status, 
951       uint256 time);
952 
953 
954   /* 
955  * @dev Initialization of the ISO,
956  * following arguments are provided via the constructor: 
957  * ----------------------------------------------------
958  * tokenArg                    - token offered in the ISO.
959  * totalSupplyArg              - total amount of tokens allocated for each round.
960  * totalSupplyUniswapArg       - amount of tokens that will be sent to uniswap.
961  * ratesArg                    - contribution ratio ETH:Token for each round.
962  * periodDurationR3            - duration of a day during round 3.
963  * timeDelayR1Arg              - time delay between round 1 and round 2.
964  * timeDelayR2Arg              - time delay between round 2 and round 3.
965  * stakingPeriodArg            - staking duration required to get bonus tokens for each round.
966  * uniswapRouterArg            - contract address of the uniswap router object.
967  * decreasingPctArg            - decreasing percentages associated with: token, ETH, rate, and bonus.
968  * listingRateArg              - initial listing rate of the offered token.
969  * platformStakingContractArg  - contract address of the timed distribution contract.
970  * walletArg                   - account address of the team wallet.
971  * 
972  */
973   constructor(
974     address tokenArg,
975     uint256[3] memory totalSupplyArg,
976     uint256 totalSupplyUniswapArg,
977     uint256[3] memory ratesArg,
978     uint256 periodDurationR3Arg,
979     uint256 timeDelayR1Arg,
980     uint256 timeDelayR2Arg,
981     uint256[3] memory stakingPeriodArg,
982     address uniswapRouterArg,
983     uint256[4] memory decreasingPctArg,
984     uint256 listingRateArg,
985     address platformStakingContractArg,
986     address payable walletArg
987     ) public {
988     for (uint256 j = 0; j < 3; j++) {
989         require(totalSupplyArg[j] > 0, 
990         "The 'totalSupplyArg' argument must be larger than zero");
991         require(ratesArg[j] > 0, 
992         "The 'ratesArg' argument must be larger than zero");
993         require(stakingPeriodArg[j] > 0, 
994         "The 'stakingPeriodArg' argument must be larger than zero");
995     }
996     for (uint256 j = 0; j < 4; j++) {
997         require(decreasingPctArg[j] < 10000, 
998         "The 'decreasingPctArg' arguments must be less than 100 percent");
999     }
1000     require(totalSupplyUniswapArg > 0, 
1001     "The 'totalSupplyUniswapArg' argument must be larger than zero");
1002     require(periodDurationR3Arg > 0, 
1003     "The 'slotDurationR3Arg' argument must be larger than zero");
1004     require(tokenArg != address(0), 
1005     "The 'tokenArg' argument cannot be the zero address");
1006     require(uniswapRouterArg != address(0), 
1007     "The 'uniswapRouterArg' argument cannot be the zero addresss");
1008     require(listingRateArg > 0,
1009     "The 'listingRateArg' argument must be larger than zero");
1010     require(platformStakingContractArg != address(0), 
1011     "The 'vestingContractArg' argument cannot be the zero address");
1012     require(walletArg != address(0), 
1013     "The 'walletArg' argument cannot be the zero address");
1014     
1015     token = Token(tokenArg);
1016     
1017     totalSupplyR1 = totalSupplyArg[0];
1018     totalSupplyR2 = totalSupplyArg[1];
1019     totalSupplyR3 = totalSupplyArg[2];
1020     
1021     totalSupplyUniswap = totalSupplyUniswapArg;
1022     
1023     periodDurationR3 = periodDurationR3Arg;
1024     
1025     timeDelayR1 = timeDelayR1Arg;
1026     timeDelayR2 = timeDelayR2Arg;
1027     
1028     rateR1 = ratesArg[0];
1029     rateR2 = ratesArg[1];
1030     rateR3 = ratesArg[2];
1031     
1032     stakingPeriodR1 = stakingPeriodArg[0];
1033     stakingPeriodR2 = stakingPeriodArg[1];
1034     stakingPeriodR3 = stakingPeriodArg[2];
1035     
1036     uniswapRouter = IUniswapV2Router02(uniswapRouterArg);
1037     
1038     decreasingPctToken = decreasingPctArg[0];
1039     decreasingPctETH = decreasingPctArg[1];
1040     decreasingPctRate = decreasingPctArg[2];
1041     decreasingPctBonus = decreasingPctArg[3];
1042     
1043     listingRate = listingRateArg;
1044     
1045     platformStakingContract = platformStakingContractArg;
1046     wallet = walletArg;
1047   }
1048   
1049   /**
1050    * @dev The fallback function is used for all contributions
1051    * during the ISO. The function monitors the current 
1052    * round and manages token contributions accordingly.
1053    */
1054   receive() external payable {
1055       if (token.balanceOf(address(this)) > 0) {
1056           uint8 currentRound = _calculateCurrentRound();
1057           
1058           if (currentRound == 0) {
1059               _buyTokenR1();
1060           } else if (currentRound == 1) {
1061               _buyTokenR2();
1062           } else if (currentRound == 2) {
1063               _buyTokenR3();
1064           } else {
1065               revert("The stake offering rounds are not active");
1066           }
1067     } else {
1068         revert("The stake offering must be active");
1069     }
1070   }
1071   
1072   /**
1073    * @dev Wrapper around the round 3 closing function.
1074    */     
1075   function closeR3() external {
1076       uint256 period = _calculatePeriod(block.timestamp);
1077       _closeR3(period);
1078   }
1079   
1080   /**
1081    * @dev This function prepares the staking and bonus reward settings
1082    * and it also provides liquidity to a freshly created uniswap pair.
1083    */  
1084   function activateStakesAndUniswapLiquidity() external {
1085       require(_hasEnded[0] && _hasEnded[1] && _hasEnded[2], 
1086       "all rounds must have ended");
1087       require(!_bonusOfferingActive, 
1088       "the bonus offering and uniswap paring can only be done once per ISO");
1089       
1090       uint256[3] memory bonusSupplies = [
1091           (_actualSupply[0].mul(_bonusReductionFactor)).div(10000),
1092           (_actualSupply[1].mul(_bonusReductionFactor)).div(10000),
1093           (_actualSupply[2].mul(_bonusReductionFactor)).div(10000)
1094           ];
1095           
1096       uint256 totalSupply = totalSupplyR1.add(totalSupplyR2).add(totalSupplyR3);
1097       uint256 soldSupply = _actualSupply[0].add(_actualSupply[1]).add(_actualSupply[2]);
1098       uint256 unsoldSupply = totalSupply.sub(soldSupply);
1099           
1100       uint256 exceededBonus = totalSupply
1101       .sub(bonusSupplies[0])
1102       .sub(bonusSupplies[1])
1103       .sub(bonusSupplies[2]);
1104       
1105       uint256 exceededUniswapAmount = _createUniswapPair(_endedDayR3); 
1106       
1107       _bonusOfferingActive = true;
1108       _bonusOfferingActivated = block.timestamp;
1109       _bonusTotal = bonusSupplies[0].add(bonusSupplies[1]).add(bonusSupplies[2]);
1110       _contributionsTotal = soldSupply;
1111       
1112       _distribute(unsoldSupply.add(exceededBonus).add(exceededUniswapAmount));
1113      
1114       emit Activated(true, block.timestamp);
1115   }
1116   
1117   /**
1118    * @dev This function allows the caller to stake claimable dividends.
1119    */   
1120   function restakeDividends() external {
1121       uint256 pending = _pendingDividends(msg.sender);
1122       pending = pending.add(_contributors[msg.sender].remainder);
1123       require(pending >= 0, "You do not have dividends to restake");
1124       _restkedDividends[msg.sender] = _restkedDividends[msg.sender].add(pending);
1125       _totalRestakedDividends = _totalRestakedDividends.add(pending);
1126       _bonusTotal = _bonusTotal.sub(pending);
1127 
1128       _contributors[msg.sender].phase = _phase;
1129       _contributors[msg.sender].remainder = 0;
1130       _contributors[msg.sender].fromTotalDivs = _totalDividends;
1131       
1132       emit Staked(msg.sender, pending);
1133   }
1134 
1135   /**
1136    * @dev This function is called by contributors to 
1137    * withdraw round 1 tokens. 
1138    * -----------------------------------------------------
1139    * Withdrawing tokens might result in bonus tokens, dividends,
1140    * or similar (based on the staking duration of the contributor).
1141    * 
1142    */  
1143   function withdrawR1Tokens() external {
1144       require(_bonusOfferingActive, 
1145       "The bonus offering is not active yet");
1146       
1147       _withdrawTokens(0);
1148   }
1149  
1150   /**
1151    * @dev This function is called by contributors to 
1152    * withdraw round 2 tokens. 
1153    * -----------------------------------------------------
1154    * Withdrawing tokens might result in bonus tokens, dividends,
1155    * or similar (based on the staking duration of the contributor).
1156    * 
1157    */      
1158   function withdrawR2Tokens() external {
1159       require(_bonusOfferingActive, 
1160       "The bonus offering is not active yet");
1161       
1162       _withdrawTokens(1);
1163   }
1164  
1165   /**
1166    * @dev This function is called by contributors to 
1167    * withdraw round 3 tokens. 
1168    * -----------------------------------------------------
1169    * Withdrawing tokens might result in bonus tokens, dividends,
1170    * or similar (based on the staking duration of the contributor).
1171    * 
1172    */   
1173   function withdrawR3Tokens() external {
1174       require(_bonusOfferingActive, 
1175       "The bonus offering is not active yet");  
1176 
1177       _withdrawTokens(2);
1178   }
1179  
1180   /**
1181    * @dev wrapper around the withdrawal of funds function. 
1182    */    
1183   function withdrawFunds() external {
1184       uint256 amount = ((address(this).balance).sub(_fundsWithdrawn)).div(2);
1185       
1186       _withdrawFunds(amount);
1187   }  
1188  
1189   /**
1190    * @dev Returns the total amount of restaked dividends in the ISO.
1191    */    
1192   function getRestakedDividendsTotal() external view returns (uint256) { 
1193       return _totalRestakedDividends;
1194   }
1195   
1196   /**
1197    * @dev Returns the total staking bonuses in the ISO. 
1198    */     
1199   function getStakingBonusesTotal() external view returns (uint256) {
1200       return _bonusTotal;
1201   }
1202 
1203   /**
1204    * @dev Returns the latest amount of tokens sent to the timed distribution contract.  
1205    */    
1206   function getLatestStakingPlatformPayment() external view returns (uint256) {
1207       return _latestStakingPlatformPayment;
1208   }
1209  
1210   /**
1211    * @dev Returns the current day of round 3.
1212    */   
1213   function getCurrentDayR3() external view returns (uint256) {
1214       if (_endedDayR3 != 0) {
1215           return _endedDayR3;
1216       }
1217       return _calculatePeriod(block.timestamp);
1218   }
1219 
1220   /**
1221    * @dev Returns the ending day of round 3. 
1222    */    
1223   function getEndedDayR3() external view returns (uint256) {
1224       return _endedDayR3;
1225   }
1226 
1227   /**
1228    * @dev Returns the start time of round 2. 
1229    */    
1230   function getR2Start() external view returns (uint256) {
1231       return _startTimeR2;
1232   }
1233 
1234   /**
1235    * @dev Returns the start time of round 3. 
1236    */  
1237   function getR3Start() external view returns (uint256) {
1238       return _startTimeR3;
1239   }
1240 
1241   /**
1242    * @dev Returns the end time of round 3. 
1243    */  
1244   function getR3End() external view returns (uint256) {
1245       return _endTimeR3;
1246   }
1247 
1248   /**
1249    * @dev Returns the total amount of contributors in the ISO. 
1250    */  
1251   function getContributorsTotal() external view returns (uint256) {
1252       return _contributorsTotal;
1253   }
1254 
1255   /**
1256    * @dev Returns the total amount of contributed funds (ETH) in the ISO 
1257    */  
1258   function getContributedFundsTotal() external view returns (uint256) {
1259       return _contributedFundsTotal;
1260   }
1261   
1262   /**
1263    * @dev Returns the current round of the ISO. 
1264    */  
1265   function getCurrentRound() external view returns (uint8) {
1266       uint8 round = _calculateCurrentRound();
1267       
1268       if (round == 0 && !_hasEnded[0]) {
1269           return 1;
1270       } 
1271       if (round == 1 && !_hasEnded[1] && _hasEnded[0]) {
1272           if (block.timestamp <= _startTimeR2) {
1273               return 0;
1274           }
1275           return 2;
1276       }
1277       if (round == 2 && !_hasEnded[2] && _hasEnded[1]) {
1278           if (block.timestamp <= _startTimeR3) {
1279               return 0;
1280           }
1281           return 3;
1282       } 
1283       else {
1284           return 0;
1285       }
1286   }
1287 
1288   /**
1289    * @dev Returns whether round 1 has ended or not. 
1290    */   
1291   function hasR1Ended() external view returns (bool) {
1292       return _hasEnded[0];
1293   }
1294 
1295   /**
1296    * @dev Returns whether round 2 has ended or not. 
1297    */   
1298   function hasR2Ended() external view returns (bool) {
1299       return _hasEnded[1];
1300   }
1301 
1302   /**
1303    * @dev Returns whether round 3 has ended or not. 
1304    */   
1305   function hasR3Ended() external view returns (bool) { 
1306       return _hasEnded[2];
1307   }
1308 
1309   /**
1310    * @dev Returns the remaining time delay between round 1 and round 2.
1311    */    
1312   function getRemainingTimeDelayR1R2() external view returns (uint256) {
1313       if (timeDelayR1 > 0) {
1314           if (_hasEnded[0] && !_hasEnded[1]) {
1315               if (_startTimeR2.sub(block.timestamp) > 0) {
1316                   return _startTimeR2.sub(block.timestamp);
1317               } else {
1318                   return 0;
1319               }
1320           } else {
1321               return 0;
1322           }
1323       } else {
1324           return 0;
1325       }
1326   }
1327 
1328   /**
1329    * @dev Returns the remaining time delay between round 2 and round 3.
1330    */  
1331   function getRemainingTimeDelayR2R3() external view returns (uint256) {
1332       if (timeDelayR2 > 0) {
1333           if (_hasEnded[0] && _hasEnded[1] && !_hasEnded[2]) {
1334               if (_startTimeR3.sub(block.timestamp) > 0) {
1335                   return _startTimeR3.sub(block.timestamp);
1336               } else {
1337                   return 0;
1338               }
1339           } else {
1340               return 0;
1341           }
1342       } else {
1343           return 0;
1344       }
1345   }
1346 
1347   /**
1348    * @dev Returns the total sales for round 1.
1349    */  
1350   function getR1Sales() external view returns (uint256) {
1351       return _actualSupply[0];
1352   }
1353 
1354   /**
1355    * @dev Returns the total sales for round 2.
1356    */  
1357   function getR2Sales() external view returns (uint256) {
1358       return _actualSupply[1];
1359   }
1360 
1361   /**
1362    * @dev Returns the total sales for round 3.
1363    */  
1364   function getR3Sales() external view returns (uint256) {
1365       return _actualSupply[2];
1366   }
1367 
1368   /**
1369    * @dev Returns whether the staking- and bonus functionality has been activated or not.
1370    */    
1371   function getStakingActivationStatus() external view returns (bool) {
1372       return _bonusOfferingActive;
1373   }
1374   
1375   /**
1376    * @dev This function allows the caller to withdraw claimable dividends.
1377    */    
1378   function claimDividends() public {
1379       if (_totalDividends > _contributors[msg.sender].fromTotalDivs) {
1380           uint256 pending = _pendingDividends(msg.sender);
1381           pending = pending.add(_contributors[msg.sender].remainder);
1382           require(pending >= 0, "You do not have dividends to claim");
1383           
1384           _contributors[msg.sender].phase = _phase;
1385           _contributors[msg.sender].remainder = 0;
1386           _contributors[msg.sender].fromTotalDivs = _totalDividends;
1387           
1388           _bonusTotal = _bonusTotal.sub(pending);
1389 
1390           require(token.transfer(msg.sender, pending), "Error in sending reward from contract");
1391 
1392           emit Claimed(msg.sender, pending);
1393 
1394       }
1395   }
1396 
1397   /**
1398    * @dev This function allows the caller to withdraw restaked dividends.
1399    */     
1400   function withdrawRestakedDividends() public {
1401       uint256 amount = _restkedDividends[msg.sender];
1402       require(amount >= 0, "You do not have restaked dividends to withdraw");
1403       
1404       claimDividends();
1405       
1406       _restkedDividends[msg.sender] = 0;
1407       _totalRestakedDividends = _totalRestakedDividends.sub(amount);
1408       
1409       token.transfer(msg.sender, amount);      
1410       
1411       emit Reclaimed(msg.sender, amount);
1412   }    
1413   
1414   /**
1415    * @dev Returns claimable dividends.
1416    */    
1417   function getDividends(address accountArg) public view returns (uint256) {
1418       uint256 amount = ((_totalDividends.sub(_payouts[_contributors[accountArg].phase - 1])).mul(getContributionTotal(accountArg))).div(_scaling);
1419       amount += ((_totalDividends.sub(_payouts[_contributors[accountArg].phase - 1])).mul(getContributionTotal(accountArg))) % _scaling ;
1420       return (amount.add(_contributors[msg.sender].remainder));
1421   }
1422  
1423   /**
1424    * @dev Returns restaked dividends.
1425    */   
1426   function getRestakedDividends(address accountArg) public view returns (uint256) { 
1427       return _restkedDividends[accountArg];
1428   }
1429 
1430   /**
1431    * @dev Returns round 1 contributions of an account. 
1432    */  
1433   function getR1Contribution(address accountArg) public view returns (uint256) {
1434       return _contributions[0][accountArg];
1435   }
1436   
1437   /**
1438    * @dev Returns round 2 contributions of an account. 
1439    */    
1440   function getR2Contribution(address accountArg) public view returns (uint256) {
1441       return _contributions[1][accountArg];
1442   }
1443   
1444   /**
1445    * @dev Returns round 3 contributions of an account. 
1446    */  
1447   function getR3Contribution(address accountArg) public view returns (uint256) { 
1448       return _contributions[2][accountArg];
1449   }
1450 
1451   /**
1452    * @dev Returns the total contributions of an account. 
1453    */    
1454   function getContributionTotal(address accountArg) public view returns (uint256) {
1455       uint256 contributionR1 = getR1Contribution(accountArg);
1456       uint256 contributionR2 = getR2Contribution(accountArg);
1457       uint256 contributionR3 = getR3Contribution(accountArg);
1458       uint256 restaked = getRestakedDividends(accountArg);
1459 
1460       return contributionR1.add(contributionR2).add(contributionR3).add(restaked);
1461   }
1462 
1463   /**
1464    * @dev Returns the total contributions in the ISO (including restaked dividends). 
1465    */    
1466   function getContributionsTotal() public view returns (uint256) {
1467       return _contributionsTotal.add(_totalRestakedDividends);
1468   }
1469 
1470   /**
1471    * @dev Returns expected round 1 staking bonus for an account. 
1472    */  
1473   function getStakingBonusR1(address accountArg) public view returns (uint256) {
1474       uint256 contribution = _contributions[0][accountArg];
1475       
1476       return (contribution.mul(_bonusReductionFactor)).div(10000);
1477   }
1478 
1479   /**
1480    * @dev Returns expected round 2 staking bonus for an account. 
1481    */ 
1482   function getStakingBonusR2(address accountArg) public view returns (uint256) {
1483       uint256 contribution = _contributions[1][accountArg];
1484       
1485       return (contribution.mul(_bonusReductionFactor)).div(10000);
1486   }
1487 
1488   /**
1489    * @dev Returns expected round 3 staking bonus for an account. 
1490    */ 
1491   function getStakingBonusR3(address accountArg) public view returns (uint256) {
1492       uint256 contribution = _contributions[2][accountArg];
1493       
1494       return (contribution.mul(_bonusReductionFactor)).div(10000);
1495   }
1496 
1497   /**
1498    * @dev Returns the total expected staking bonuses for an account. 
1499    */   
1500   function getStakingBonusTotal(address accountArg) public view returns (uint256) {
1501       uint256 stakeR1 = getStakingBonusR1(accountArg);
1502       uint256 stakeR2 = getStakingBonusR2(accountArg);
1503       uint256 stakeR3 = getStakingBonusR3(accountArg);
1504 
1505       return stakeR1.add(stakeR2).add(stakeR3);
1506  }   
1507 
1508   /**
1509    * @dev This function handles distribution of extra supply.
1510    */    
1511   function _distribute(uint256 amountArg) private {
1512       uint256 vested = amountArg.div(2);
1513       uint256 burned = amountArg.sub(vested);
1514       
1515       token.transfer(platformStakingContract, vested);
1516       token.burn(burned);
1517   }
1518 
1519   /**
1520    * @dev This function handles calculation of token withdrawals
1521    * (it also withdraws dividends and restaked dividends 
1522    * during certain circumstances).
1523    */    
1524   function _withdrawTokens(uint8 indexArg) private {
1525       require(_hasEnded[0] && _hasEnded[1] && _hasEnded[2], 
1526       "The rounds must be inactive before any tokens can be withdrawn");
1527       require(!_hasWithdrawn[indexArg][msg.sender], 
1528       "The caller must have withdrawable tokens available from this round");
1529       
1530       claimDividends();
1531       
1532       uint256 amount = _contributions[indexArg][msg.sender];
1533       uint256 amountBonus = (amount.mul(_bonusReductionFactor)).div(10000);
1534       
1535       _contributions[indexArg][msg.sender] = _contributions[indexArg][msg.sender].sub(amount);
1536       _contributionsTotal = _contributionsTotal.sub(amount);
1537       
1538       uint256 contributions = getContributionTotal(msg.sender);
1539       uint256 restaked = getRestakedDividends(msg.sender);
1540       
1541       if (contributions.sub(restaked) == 0) withdrawRestakedDividends();
1542     
1543       uint pending = _pendingDividends(msg.sender);
1544       _contributors[msg.sender].remainder = (_contributors[msg.sender].remainder).add(pending);
1545       _contributors[msg.sender].fromTotalDivs = _totalDividends;
1546       _contributors[msg.sender].phase = _phase;
1547       
1548       _hasWithdrawn[indexArg][msg.sender] = true;
1549       
1550       token.transfer(msg.sender, amount);
1551       
1552       _endStake(indexArg, msg.sender, amountBonus);
1553   }
1554  
1555   /**
1556    * @dev This function handles fund withdrawals.
1557    */  
1558   function _withdrawFunds(uint256 amountArg) private {
1559       require(msg.sender == wallet, 
1560       "The caller must be the specified funds wallet of the team");
1561       require(amountArg <= ((address(this).balance.sub(_fundsWithdrawn)).div(2)),
1562       "The 'amountArg' argument exceeds the limit");
1563       require(!_hasEnded[2], 
1564       "The third round is not active");
1565       
1566       _fundsWithdrawn = _fundsWithdrawn.add(amountArg);
1567       
1568       wallet.transfer(amountArg);
1569   }  
1570 
1571   /**
1572    * @dev This function handles token purchases for round 1.
1573    */ 
1574   function _buyTokenR1() private {
1575       if (token.balanceOf(address(this)) > 0) {
1576           require(!_hasEnded[0], 
1577           "The first round must be active");
1578           
1579           bool isRoundEnded = _buyToken(0, rateR1, totalSupplyR1);
1580           
1581           if (isRoundEnded == true) {
1582               _startTimeR2 = block.timestamp.add(timeDelayR1);
1583           }
1584       } else {
1585           revert("The stake offering must be active");
1586     }
1587   }
1588  
1589   /**
1590    * @dev This function handles token purchases for round 2.
1591    */   
1592   function _buyTokenR2() private {
1593       require(_hasEnded[0] && !_hasEnded[1],
1594       "The first round one must not be active while the second round must be active");
1595       require(block.timestamp >= _startTimeR2,
1596       "The time delay between the first round and the second round must be surpassed");
1597       
1598       bool isRoundEnded = _buyToken(1, rateR2, totalSupplyR2);
1599       
1600       if (isRoundEnded == true) {
1601           _startTimeR3 = block.timestamp.add(timeDelayR2);
1602       }
1603   }
1604  
1605   /**
1606    * @dev This function handles token purchases for round 3.
1607    */   
1608   function _buyTokenR3() private {
1609       require(_hasEnded[1] && !_hasEnded[2],
1610       "The second round one must not be active while the third round must be active");
1611       require(block.timestamp >= _startTimeR3,
1612       "The time delay between the first round and the second round must be surpassed"); 
1613       
1614       uint256 period = _calculatePeriod(block.timestamp);
1615       
1616       (bool isRoundClosed, uint256 actualPeriodTotalSupply) = _closeR3(period);
1617 
1618       if (!isRoundClosed) {
1619           bool isRoundEnded = _buyToken(2, rateR3, actualPeriodTotalSupply);
1620           
1621           if (isRoundEnded == true) {
1622               _endTimeR3 = block.timestamp;
1623               uint256 endingPeriod = _calculateEndingPeriod();
1624               uint256 reductionFactor = _calculateBonusReductionFactor(endingPeriod);
1625               _bonusReductionFactor = reductionFactor;
1626               _endedDayR3 = endingPeriod;
1627           }
1628       }
1629   }
1630   
1631   /**
1632    * @dev This function handles bonus payouts and the split of forfeited bonuses.
1633    */     
1634   function _endStake(uint256 indexArg, address accountArg, uint256 amountArg) private {
1635       uint256 elapsedTime = (block.timestamp).sub(_bonusOfferingActivated);
1636       uint256 payout;
1637       
1638       uint256 duration = _getDuration(indexArg);
1639       
1640       if (elapsedTime >= duration) {
1641           payout = amountArg;
1642       } else if (elapsedTime >= duration.mul(3).div(4) && elapsedTime < duration) {
1643           payout = amountArg.mul(3).div(4);
1644       } else if (elapsedTime >= duration.div(2) && elapsedTime < duration.mul(3).div(4)) {
1645           payout = amountArg.div(2);
1646       } else if (elapsedTime >= duration.div(4) && elapsedTime < duration.div(2)) {
1647           payout = amountArg.div(4);
1648       } else {
1649           payout = 0;
1650       }
1651       
1652       _split(amountArg.sub(payout));
1653       
1654       if (payout != 0) {
1655           token.transfer(accountArg, payout);
1656       }
1657       
1658       emit Ended(accountArg, amountArg, block.timestamp);
1659   }
1660  
1661   /**
1662    * @dev This function splits forfeited bonuses into dividends 
1663    * and to timed distribution contract accordingly.
1664    */     
1665   function _split(uint256 amountArg) private {
1666       if (amountArg == 0) {
1667         return;
1668       }
1669       
1670       uint256 dividends = amountArg.div(2);
1671       uint256 platformStakingShare = amountArg.sub(dividends);
1672       
1673       _bonusTotal = _bonusTotal.sub(platformStakingShare);
1674       _latestStakingPlatformPayment = platformStakingShare;
1675       
1676       token.transfer(platformStakingContract, platformStakingShare);
1677       
1678       _addDividends(_latestStakingPlatformPayment);
1679       
1680       emit Splitted(msg.sender, dividends, platformStakingShare);
1681   }
1682   
1683    /**
1684    * @dev this function handles addition of new dividends.
1685    */   
1686   function _addDividends(uint256 bonusArg) private {
1687       uint256 latest = (bonusArg.mul(_scaling)).add(_scaledRemainder);
1688       uint256 dividendPerToken = latest.div(_contributionsTotal.add(_totalRestakedDividends));
1689       _scaledRemainder = latest.mod(_contributionsTotal.add(_totalRestakedDividends));
1690       _totalDividends = _totalDividends.add(dividendPerToken);
1691       _payouts[_phase] = _payouts[_phase-1].add(dividendPerToken);
1692       _phase++;
1693   }
1694   
1695    /**
1696    * @dev returns pending dividend rewards.
1697    */    
1698   function _pendingDividends(address accountArg) private returns (uint256) {
1699       uint256 amount = ((_totalDividends.sub(_payouts[_contributors[accountArg].phase - 1])).mul(getContributionTotal(accountArg))).div(_scaling);
1700       _contributors[accountArg].remainder += ((_totalDividends.sub(_payouts[_contributors[accountArg].phase - 1])).mul(getContributionTotal(accountArg))) % _scaling ;
1701       return amount;
1702   }
1703   
1704   /**
1705    * @dev This function creates a uniswap pair and handles liquidity provisioning.
1706    * Returns the uniswap token leftovers.
1707    */  
1708   function _createUniswapPair(uint256 endingPeriodArg) private returns (uint256) {
1709       uint256 listingPrice = endingPeriodArg.mul(decreasingPctRate);
1710 
1711       uint256 ethDecrease = uint256(5000).sub(endingPeriodArg.mul(decreasingPctETH));
1712       uint256 ethOnUniswap = (_contributedFundsTotal.mul(ethDecrease)).div(10000);
1713       
1714       ethOnUniswap = ethOnUniswap <= (address(this).balance)
1715       ? ethOnUniswap
1716       : (address(this).balance);
1717       
1718       uint256 tokensOnUniswap = ethOnUniswap
1719       .mul(listingRate)
1720       .mul(10000)
1721       .div(uint256(10000).sub(listingPrice))
1722       .div(100000);
1723       
1724       token.approve(address(uniswapRouter), tokensOnUniswap);
1725       
1726       uniswapRouter.addLiquidityETH.value(ethOnUniswap)(
1727       address(token),
1728       tokensOnUniswap,
1729       0,
1730       0,
1731       wallet,
1732       block.timestamp
1733       );
1734       
1735       wallet.transfer(address(this).balance);
1736       
1737       return (totalSupplyUniswap.sub(tokensOnUniswap));
1738   } 
1739  
1740   /**
1741    * @dev this function will close round 3 if based on day and sold supply.
1742    * Returns whether a particular round has ended or not and 
1743    * the max supply of a particular day during round 3.
1744    */    
1745   function _closeR3(uint256 periodArg) private returns (bool isRoundEnded, uint256 maxPeriodSupply) {
1746       require(_hasEnded[0] && _hasEnded[1] && !_hasEnded[2],
1747       'Round 3 has ended or Round 1 or 2 have not ended yet');
1748       require(block.timestamp >= _startTimeR3,
1749       'Pause period between Round 2 and 3');
1750       
1751       uint256 decreasingTokenNumber = totalSupplyR3.mul(decreasingPctToken).div(10000);
1752       maxPeriodSupply = totalSupplyR3.sub(periodArg.mul(decreasingTokenNumber));
1753       
1754       if (maxPeriodSupply <= _actualSupply[2]) {
1755           msg.sender.transfer(msg.value);
1756           _hasEnded[2] = true;
1757           
1758           _endTimeR3 = block.timestamp;
1759           
1760           uint256 endingPeriod = _calculateEndingPeriod();
1761           uint256 reductionFactor = _calculateBonusReductionFactor(endingPeriod);
1762           
1763           _endedDayR3 = endingPeriod;
1764           
1765           _bonusReductionFactor = reductionFactor;
1766           return (true, maxPeriodSupply);
1767           
1768       } else {
1769           return (false, maxPeriodSupply);
1770       }
1771   }
1772  
1773   /**
1774    * @dev this function handles low level token purchases. 
1775    * Returns whether a particular round has ended or not.
1776    */     
1777   function _buyToken(uint8 indexArg, uint256 rateArg, uint256 totalSupplyArg) private returns (bool isRoundEnded) {
1778       uint256 tokensNumber = msg.value.mul(rateArg).div(100000);
1779       uint256 actualTotalBalance = _actualSupply[indexArg];
1780       uint256 newTotalRoundBalance = actualTotalBalance.add(tokensNumber);
1781       
1782       if (!_contributor[msg.sender]) {
1783           _contributor[msg.sender] = true;
1784           _contributorsTotal++;
1785       }  
1786       
1787       if (newTotalRoundBalance < totalSupplyArg) {
1788           _contributions[indexArg][msg.sender] = _contributions[indexArg][msg.sender].add(tokensNumber);
1789           _actualSupply[indexArg] = newTotalRoundBalance;
1790           _contributedFundsTotal = _contributedFundsTotal.add(msg.value);
1791           
1792           emit Bought(uint8(indexArg + 1), msg.sender, tokensNumber);
1793           
1794           return false;
1795           
1796       } else {
1797           uint256 availableTokens = totalSupplyArg.sub(actualTotalBalance);
1798           uint256 availableEth = availableTokens.mul(100000).div(rateArg);
1799           
1800           _contributions[indexArg][msg.sender] = _contributions[indexArg][msg.sender].add(availableTokens);
1801           _actualSupply[indexArg] = totalSupplyArg;
1802           _contributedFundsTotal = _contributedFundsTotal.add(availableEth);
1803           _hasEnded[indexArg] = true;
1804           
1805           msg.sender.transfer(msg.value.sub(availableEth));
1806 
1807           emit Bought(uint8(indexArg + 1), msg.sender, availableTokens);
1808           
1809           return true;
1810       }
1811   }
1812 
1813   /**
1814    * @dev Returns the staking duration of a particular round.
1815    */   
1816   function _getDuration(uint256 indexArg) private view returns (uint256) {
1817       if (indexArg == 0) {
1818           return stakingPeriodR1;
1819       }
1820       if (indexArg == 1) {
1821           return stakingPeriodR2;
1822       }
1823       if (indexArg == 2) {
1824           return stakingPeriodR3;
1825       }
1826     }
1827  
1828   /**
1829    * @dev Returns the bonus reduction factor.
1830    */       
1831   function _calculateBonusReductionFactor(uint256 periodArg) private view returns (uint256) {
1832       uint256 reductionFactor = uint256(10000).sub(periodArg.mul(decreasingPctBonus));
1833       return reductionFactor;
1834   } 
1835  
1836   /**
1837    * @dev Returns the current round.
1838    */     
1839   function _calculateCurrentRound() private view returns (uint8) {
1840       if (!_hasEnded[0]) {
1841           return 0;
1842       } else if (_hasEnded[0] && !_hasEnded[1] && !_hasEnded[2]) {
1843           return 1;
1844       } else if (_hasEnded[0] && _hasEnded[1] && !_hasEnded[2]) {
1845           return 2;
1846       } else {
1847           return 2**8 - 1;
1848       }
1849   }
1850  
1851   /**
1852    * @dev Returns the current day.
1853    */     
1854   function _calculatePeriod(uint256 timeArg) private view returns (uint256) {
1855       uint256 period = ((timeArg.sub(_startTimeR3)).div(periodDurationR3));
1856       uint256 maxPeriods = uint256(10000).div(decreasingPctToken);
1857       
1858       if (period > maxPeriods) {
1859           return maxPeriods;
1860       }
1861       return period;
1862   }
1863  
1864   /**
1865    * @dev Returns the ending day of round 3.
1866    */     
1867   function _calculateEndingPeriod() private view returns (uint256) {
1868       require(_endTimeR3 != (2**256) - 1, 
1869       "The third round must be active");
1870       
1871       uint256 endingPeriod = _calculatePeriod(_endTimeR3);
1872       return endingPeriod;
1873   }
1874  
1875 
1876   
1877   
1878   
1879   
1880   
1881 }