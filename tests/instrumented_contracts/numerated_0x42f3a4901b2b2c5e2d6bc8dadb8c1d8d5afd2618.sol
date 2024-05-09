1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.10;
3 
4 interface IUniswapV2Router01 {
5     function factory() external pure returns (address);
6 
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint256 amountADesired,
13         uint256 amountBDesired,
14         uint256 amountAMin,
15         uint256 amountBMin,
16         address to,
17         uint256 deadline
18     )
19         external
20         returns (
21             uint256 amountA,
22             uint256 amountB,
23             uint256 liquidity
24         );
25 
26     function addLiquidityETH(
27         address token,
28         uint256 amountTokenDesired,
29         uint256 amountTokenMin,
30         uint256 amountETHMin,
31         address to,
32         uint256 deadline
33     )
34         external
35         payable
36         returns (
37             uint256 amountToken,
38             uint256 amountETH,
39             uint256 liquidity
40         );
41 
42     function removeLiquidity(
43         address tokenA,
44         address tokenB,
45         uint256 liquidity,
46         uint256 amountAMin,
47         uint256 amountBMin,
48         address to,
49         uint256 deadline
50     ) external returns (uint256 amountA, uint256 amountB);
51 
52     function removeLiquidityETH(
53         address token,
54         uint256 liquidity,
55         uint256 amountTokenMin,
56         uint256 amountETHMin,
57         address to,
58         uint256 deadline
59     ) external returns (uint256 amountToken, uint256 amountETH);
60 
61     function removeLiquidityWithPermit(
62         address tokenA,
63         address tokenB,
64         uint256 liquidity,
65         uint256 amountAMin,
66         uint256 amountBMin,
67         address to,
68         uint256 deadline,
69         bool approveMax,
70         uint8 v,
71         bytes32 r,
72         bytes32 s
73     ) external returns (uint256 amountA, uint256 amountB);
74 
75     function removeLiquidityETHWithPermit(
76         address token,
77         uint256 liquidity,
78         uint256 amountTokenMin,
79         uint256 amountETHMin,
80         address to,
81         uint256 deadline,
82         bool approveMax,
83         uint8 v,
84         bytes32 r,
85         bytes32 s
86     ) external returns (uint256 amountToken, uint256 amountETH);
87 
88     function swapExactTokensForTokens(
89         uint256 amountIn,
90         uint256 amountOutMin,
91         address[] calldata path,
92         address to,
93         uint256 deadline
94     ) external returns (uint256[] memory amounts);
95 
96     function swapTokensForExactTokens(
97         uint256 amountOut,
98         uint256 amountInMax,
99         address[] calldata path,
100         address to,
101         uint256 deadline
102     ) external returns (uint256[] memory amounts);
103 
104     function swapExactETHForTokens(
105         uint256 amountOutMin,
106         address[] calldata path,
107         address to,
108         uint256 deadline
109     ) external payable returns (uint256[] memory amounts);
110 
111     function swapTokensForExactETH(
112         uint256 amountOut,
113         uint256 amountInMax,
114         address[] calldata path,
115         address to,
116         uint256 deadline
117     ) external returns (uint256[] memory amounts);
118 
119     function swapExactTokensForETH(
120         uint256 amountIn,
121         uint256 amountOutMin,
122         address[] calldata path,
123         address to,
124         uint256 deadline
125     ) external returns (uint256[] memory amounts);
126 
127     function swapETHForExactTokens(
128         uint256 amountOut,
129         address[] calldata path,
130         address to,
131         uint256 deadline
132     ) external payable returns (uint256[] memory amounts);
133 
134     function quote(
135         uint256 amountA,
136         uint256 reserveA,
137         uint256 reserveB
138     ) external pure returns (uint256 amountB);
139 
140     function getAmountOut(
141         uint256 amountIn,
142         uint256 reserveIn,
143         uint256 reserveOut
144     ) external pure returns (uint256 amountOut);
145 
146     function getAmountIn(
147         uint256 amountOut,
148         uint256 reserveIn,
149         uint256 reserveOut
150     ) external pure returns (uint256 amountIn);
151 
152     function getAmountsOut(uint256 amountIn, address[] calldata path)
153         external
154         view
155         returns (uint256[] memory amounts);
156 
157     function getAmountsIn(uint256 amountOut, address[] calldata path)
158         external
159         view
160         returns (uint256[] memory amounts);
161 }
162 
163 interface IUniswapV2Router02 is IUniswapV2Router01 {
164     function removeLiquidityETHSupportingFeeOnTransferTokens(
165         address token,
166         uint256 liquidity,
167         uint256 amountTokenMin,
168         uint256 amountETHMin,
169         address to,
170         uint256 deadline
171     ) external returns (uint256 amountETH);
172 
173     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
174         address token,
175         uint256 liquidity,
176         uint256 amountTokenMin,
177         uint256 amountETHMin,
178         address to,
179         uint256 deadline,
180         bool approveMax,
181         uint8 v,
182         bytes32 r,
183         bytes32 s
184     ) external returns (uint256 amountETH);
185 
186     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
187         uint256 amountIn,
188         uint256 amountOutMin,
189         address[] calldata path,
190         address to,
191         uint256 deadline
192     ) external;
193 
194     function swapExactETHForTokensSupportingFeeOnTransferTokens(
195         uint256 amountOutMin,
196         address[] calldata path,
197         address to,
198         uint256 deadline
199     ) external payable;
200 
201     function swapExactTokensForETHSupportingFeeOnTransferTokens(
202         uint256 amountIn,
203         uint256 amountOutMin,
204         address[] calldata path,
205         address to,
206         uint256 deadline
207     ) external;
208 }
209 
210 interface IUniswapV2Factory {
211     event PairCreated(
212         address indexed token0,
213         address indexed token1,
214         address pair,
215         uint256
216     );
217 
218     function feeTo() external view returns (address);
219 
220     function feeToSetter() external view returns (address);
221 
222     function getPair(address tokenA, address tokenB)
223         external
224         view
225         returns (address pair);
226 
227     function allPairs(uint256) external view returns (address pair);
228 
229     function allPairsLength() external view returns (uint256);
230 
231     function createPair(address tokenA, address tokenB)
232         external
233         returns (address pair);
234 
235     function setFeeTo(address) external;
236 
237     function setFeeToSetter(address) external;
238 }
239 
240 interface IUniswapV2Pair {
241     event Approval(
242         address indexed owner,
243         address indexed spender,
244         uint256 value
245     );
246     event Transfer(address indexed from, address indexed to, uint256 value);
247 
248     function name() external pure returns (string memory);
249 
250     function symbol() external pure returns (string memory);
251 
252     function decimals() external pure returns (uint8);
253 
254     function totalSupply() external view returns (uint256);
255 
256     function balanceOf(address owner) external view returns (uint256);
257 
258     function allowance(address owner, address spender)
259         external
260         view
261         returns (uint256);
262 
263     function approve(address spender, uint256 value) external returns (bool);
264 
265     function transfer(address to, uint256 value) external returns (bool);
266 
267     function transferFrom(
268         address from,
269         address to,
270         uint256 value
271     ) external returns (bool);
272 
273     function DOMAIN_SEPARATOR() external view returns (bytes32);
274 
275     function PERMIT_TYPEHASH() external pure returns (bytes32);
276 
277     function nonces(address owner) external view returns (uint256);
278 
279     function permit(
280         address owner,
281         address spender,
282         uint256 value,
283         uint256 deadline,
284         uint8 v,
285         bytes32 r,
286         bytes32 s
287     ) external;
288 
289     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
290     event Burn(
291         address indexed sender,
292         uint256 amount0,
293         uint256 amount1,
294         address indexed to
295     );
296     event Swap(
297         address indexed sender,
298         uint256 amount0In,
299         uint256 amount1In,
300         uint256 amount0Out,
301         uint256 amount1Out,
302         address indexed to
303     );
304     event Sync(uint112 reserve0, uint112 reserve1);
305 
306     function MINIMUM_LIQUIDITY() external pure returns (uint256);
307 
308     function factory() external view returns (address);
309 
310     function token0() external view returns (address);
311 
312     function token1() external view returns (address);
313 
314     function getReserves()
315         external
316         view
317         returns (
318             uint112 reserve0,
319             uint112 reserve1,
320             uint32 blockTimestampLast
321         );
322 
323     function price0CumulativeLast() external view returns (uint256);
324 
325     function price1CumulativeLast() external view returns (uint256);
326 
327     function kLast() external view returns (uint256);
328 
329     function mint(address to) external returns (uint256 liquidity);
330 
331     function burn(address to)
332         external
333         returns (uint256 amount0, uint256 amount1);
334 
335     function swap(
336         uint256 amount0Out,
337         uint256 amount1Out,
338         address to,
339         bytes calldata data
340     ) external;
341 
342     function skim(address to) external;
343 
344     function sync() external;
345 
346     function initialize(address, address) external;
347 }
348 
349 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
350 
351 /**
352  * @dev Interface of the ERC20 standard as defined in the EIP.
353  */
354 interface IERC20 {
355     /**
356      * @dev Returns the amount of tokens in existence.
357      */
358     function totalSupply() external view returns (uint256);
359 
360     /**
361      * @dev Returns the amount of tokens owned by `account`.
362      */
363     function balanceOf(address account) external view returns (uint256);
364 
365     /**
366      * @dev Moves `amount` tokens from the caller's account to `to`.
367      *
368      * Returns a boolean value indicating whether the operation succeeded.
369      *
370      * Emits a {Transfer} event.
371      */
372     function transfer(address to, uint256 amount) external returns (bool);
373 
374     /**
375      * @dev Returns the remaining number of tokens that `spender` will be
376      * allowed to spend on behalf of `owner` through {transferFrom}. This is
377      * zero by default.
378      *
379      * This value changes when {approve} or {transferFrom} are called.
380      */
381     function allowance(address owner, address spender)
382         external
383         view
384         returns (uint256);
385 
386     /**
387      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * IMPORTANT: Beware that changing an allowance with this method brings the risk
392      * that someone may use both the old and the new allowance by unfortunate
393      * transaction ordering. One possible solution to mitigate this race
394      * condition is to first reduce the spender's allowance to 0 and set the
395      * desired value afterwards:
396      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
397      *
398      * Emits an {Approval} event.
399      */
400     function approve(address spender, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Moves `amount` tokens from `from` to `to` using the
404      * allowance mechanism. `amount` is then deducted from the caller's
405      * allowance.
406      *
407      * Returns a boolean value indicating whether the operation succeeded.
408      *
409      * Emits a {Transfer} event.
410      */
411     function transferFrom(
412         address from,
413         address to,
414         uint256 amount
415     ) external returns (bool);
416 
417     /**
418      * @dev Emitted when `value` tokens are moved from one account (`from`) to
419      * another (`to`).
420      *
421      * Note that `value` may be zero.
422      */
423     event Transfer(address indexed from, address indexed to, uint256 value);
424 
425     /**
426      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
427      * a call to {approve}. `value` is the new allowance.
428      */
429     event Approval(
430         address indexed owner,
431         address indexed spender,
432         uint256 value
433     );
434 }
435 
436 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
437 
438 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
439 
440 /**
441  * @dev Interface for the optional metadata functions from the ERC20 standard.
442  *
443  * _Available since v4.1._
444  */
445 interface IERC20Metadata is IERC20 {
446     /**
447      * @dev Returns the name of the token.
448      */
449     function name() external view returns (string memory);
450 
451     /**
452      * @dev Returns the symbol of the token.
453      */
454     function symbol() external view returns (string memory);
455 
456     /**
457      * @dev Returns the decimals places of the token.
458      */
459     function decimals() external view returns (uint8);
460 }
461 
462 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
463 
464 /**
465  * @dev Provides information about the current execution context, including the
466  * sender of the transaction and its data. While these are generally available
467  * via msg.sender and msg.data, they should not be accessed in such a direct
468  * manner, since when dealing with meta-transactions the account sending and
469  * paying for execution may not be the actual sender (as far as an application
470  * is concerned).
471  *
472  * This contract is only required for intermediate, library-like contracts.
473  */
474 abstract contract Context {
475     function _msgSender() internal view virtual returns (address) {
476         return msg.sender;
477     }
478 
479     function _msgData() internal view virtual returns (bytes calldata) {
480         return msg.data;
481     }
482 }
483 
484 /**
485  * @dev Implementation of the {IERC20} interface.
486  *
487  * This implementation is agnostic to the way tokens are created. This means
488  * that a supply mechanism has to be added in a derived contract using {_mint}.
489  * For a generic mechanism see {ERC20PresetMinterPauser}.
490  *
491  * TIP: For a detailed writeup see our guide
492  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
493  * to implement supply mechanisms].
494  *
495  * We have followed general OpenZeppelin Contracts guidelines: functions revert
496  * instead returning `false` on failure. This behavior is nonetheless
497  * conventional and does not conflict with the expectations of ERC20
498  * applications.
499  *
500  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
501  * This allows applications to reconstruct the allowance for all accounts just
502  * by listening to said events. Other implementations of the EIP may not emit
503  * these events, as it isn't required by the specification.
504  *
505  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
506  * functions have been added to mitigate the well-known issues around setting
507  * allowances. See {IERC20-approve}.
508  */
509 contract ERC20 is Context, IERC20, IERC20Metadata {
510     mapping(address => uint256) private _balances;
511 
512     mapping(address => mapping(address => uint256)) private _allowances;
513 
514     uint256 private _totalSupply;
515 
516     string private _name;
517     string private _symbol;
518 
519     /**
520      * @dev Sets the values for {name} and {symbol}.
521      *
522      * The default value of {decimals} is 18. To select a different value for
523      * {decimals} you should overload it.
524      *
525      * All two of these values are immutable: they can only be set once during
526      * construction.
527      */
528     constructor(string memory name_, string memory symbol_) {
529         _name = name_;
530         _symbol = symbol_;
531     }
532 
533     /**
534      * @dev Returns the name of the token.
535      */
536     function name() public view virtual override returns (string memory) {
537         return _name;
538     }
539 
540     /**
541      * @dev Returns the symbol of the token, usually a shorter version of the
542      * name.
543      */
544     function symbol() public view virtual override returns (string memory) {
545         return _symbol;
546     }
547 
548     /**
549      * @dev Returns the number of decimals used to get its user representation.
550      * For example, if `decimals` equals `2`, a balance of `505` tokens should
551      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
552      *
553      * Tokens usually opt for a value of 18, imitating the relationship between
554      * Ether and Wei. This is the value {ERC20} uses, unless this function is
555      * overridden;
556      *
557      * NOTE: This information is only used for _display_ purposes: it in
558      * no way affects any of the arithmetic of the contract, including
559      * {IERC20-balanceOf} and {IERC20-transfer}.
560      */
561     function decimals() public view virtual override returns (uint8) {
562         return 18;
563     }
564 
565     /**
566      * @dev See {IERC20-totalSupply}.
567      */
568     function totalSupply() public view virtual override returns (uint256) {
569         return _totalSupply;
570     }
571 
572     /**
573      * @dev See {IERC20-balanceOf}.
574      */
575     function balanceOf(address account)
576         public
577         view
578         virtual
579         override
580         returns (uint256)
581     {
582         return _balances[account];
583     }
584 
585     /**
586      * @dev See {IERC20-transfer}.
587      *
588      * Requirements:
589      *
590      * - `to` cannot be the zero address.
591      * - the caller must have a balance of at least `amount`.
592      */
593     function transfer(address to, uint256 amount)
594         public
595         virtual
596         override
597         returns (bool)
598     {
599         address owner = _msgSender();
600         _transfer(owner, to, amount);
601         return true;
602     }
603 
604     /**
605      * @dev See {IERC20-allowance}.
606      */
607     function allowance(address owner, address spender)
608         public
609         view
610         virtual
611         override
612         returns (uint256)
613     {
614         return _allowances[owner][spender];
615     }
616 
617     /**
618      * @dev See {IERC20-approve}.
619      *
620      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
621      * `transferFrom`. This is semantically equivalent to an infinite approval.
622      *
623      * Requirements:
624      *
625      * - `spender` cannot be the zero address.
626      */
627     function approve(address spender, uint256 amount)
628         public
629         virtual
630         override
631         returns (bool)
632     {
633         address owner = _msgSender();
634         _approve(owner, spender, amount);
635         return true;
636     }
637 
638     /**
639      * @dev See {IERC20-transferFrom}.
640      *
641      * Emits an {Approval} event indicating the updated allowance. This is not
642      * required by the EIP. See the note at the beginning of {ERC20}.
643      *
644      * NOTE: Does not update the allowance if the current allowance
645      * is the maximum `uint256`.
646      *
647      * Requirements:
648      *
649      * - `from` and `to` cannot be the zero address.
650      * - `from` must have a balance of at least `amount`.
651      * - the caller must have allowance for ``from``'s tokens of at least
652      * `amount`.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 amount
658     ) public virtual override returns (bool) {
659         address spender = _msgSender();
660         _spendAllowance(from, spender, amount);
661         _transfer(from, to, amount);
662         return true;
663     }
664 
665     /**
666      * @dev Atomically increases the allowance granted to `spender` by the caller.
667      *
668      * This is an alternative to {approve} that can be used as a mitigation for
669      * problems described in {IERC20-approve}.
670      *
671      * Emits an {Approval} event indicating the updated allowance.
672      *
673      * Requirements:
674      *
675      * - `spender` cannot be the zero address.
676      */
677     function increaseAllowance(address spender, uint256 addedValue)
678         public
679         virtual
680         returns (bool)
681     {
682         address owner = _msgSender();
683         _approve(owner, spender, _allowances[owner][spender] + addedValue);
684         return true;
685     }
686 
687     /**
688      * @dev Atomically decreases the allowance granted to `spender` by the caller.
689      *
690      * This is an alternative to {approve} that can be used as a mitigation for
691      * problems described in {IERC20-approve}.
692      *
693      * Emits an {Approval} event indicating the updated allowance.
694      *
695      * Requirements:
696      *
697      * - `spender` cannot be the zero address.
698      * - `spender` must have allowance for the caller of at least
699      * `subtractedValue`.
700      */
701     function decreaseAllowance(address spender, uint256 subtractedValue)
702         public
703         virtual
704         returns (bool)
705     {
706         address owner = _msgSender();
707         uint256 currentAllowance = _allowances[owner][spender];
708         require(
709             currentAllowance >= subtractedValue,
710             "ERC20: decreased allowance below zero"
711         );
712         unchecked {
713             _approve(owner, spender, currentAllowance - subtractedValue);
714         }
715 
716         return true;
717     }
718 
719     /**
720      * @dev Moves `amount` of tokens from `sender` to `recipient`.
721      *
722      * This internal function is equivalent to {transfer}, and can be used to
723      * e.g. implement automatic token fees, slashing mechanisms, etc.
724      *
725      * Emits a {Transfer} event.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `from` must have a balance of at least `amount`.
732      */
733     function _transfer(
734         address from,
735         address to,
736         uint256 amount
737     ) internal virtual {
738         require(from != address(0), "ERC20: transfer from the zero address");
739         require(to != address(0), "ERC20: transfer to the zero address");
740 
741         _beforeTokenTransfer(from, to, amount);
742 
743         uint256 fromBalance = _balances[from];
744         require(
745             fromBalance >= amount,
746             "ERC20: transfer amount exceeds balance"
747         );
748         unchecked {
749             _balances[from] = fromBalance - amount;
750         }
751         _balances[to] += amount;
752 
753         emit Transfer(from, to, amount);
754 
755         _afterTokenTransfer(from, to, amount);
756     }
757 
758     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
759      * the total supply.
760      *
761      * Emits a {Transfer} event with `from` set to the zero address.
762      *
763      * Requirements:
764      *
765      * - `account` cannot be the zero address.
766      */
767     function _mint(address account, uint256 amount) internal virtual {
768         require(account != address(0), "ERC20: mint to the zero address");
769 
770         _beforeTokenTransfer(address(0), account, amount);
771 
772         _totalSupply += amount;
773         _balances[account] += amount;
774         emit Transfer(address(0), account, amount);
775 
776         _afterTokenTransfer(address(0), account, amount);
777     }
778 
779     /**
780      * @dev Destroys `amount` tokens from `account`, reducing the
781      * total supply.
782      *
783      * Emits a {Transfer} event with `to` set to the zero address.
784      *
785      * Requirements:
786      *
787      * - `account` cannot be the zero address.
788      * - `account` must have at least `amount` tokens.
789      */
790     function _burn(address account, uint256 amount) internal virtual {
791         require(account != address(0), "ERC20: burn from the zero address");
792 
793         _beforeTokenTransfer(account, address(0), amount);
794 
795         uint256 accountBalance = _balances[account];
796         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
797         unchecked {
798             _balances[account] = accountBalance - amount;
799         }
800         _totalSupply -= amount;
801 
802         emit Transfer(account, address(0), amount);
803 
804         _afterTokenTransfer(account, address(0), amount);
805     }
806 
807     /**
808      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
809      *
810      * This internal function is equivalent to `approve`, and can be used to
811      * e.g. set automatic allowances for certain subsystems, etc.
812      *
813      * Emits an {Approval} event.
814      *
815      * Requirements:
816      *
817      * - `owner` cannot be the zero address.
818      * - `spender` cannot be the zero address.
819      */
820     function _approve(
821         address owner,
822         address spender,
823         uint256 amount
824     ) internal virtual {
825         require(owner != address(0), "ERC20: approve from the zero address");
826         require(spender != address(0), "ERC20: approve to the zero address");
827 
828         _allowances[owner][spender] = amount;
829         emit Approval(owner, spender, amount);
830     }
831 
832     /**
833      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
834      *
835      * Does not update the allowance amount in case of infinite allowance.
836      * Revert if not enough allowance is available.
837      *
838      * Might emit an {Approval} event.
839      */
840     function _spendAllowance(
841         address owner,
842         address spender,
843         uint256 amount
844     ) internal virtual {
845         uint256 currentAllowance = allowance(owner, spender);
846         if (currentAllowance != type(uint256).max) {
847             require(
848                 currentAllowance >= amount,
849                 "ERC20: insufficient allowance"
850             );
851             unchecked {
852                 _approve(owner, spender, currentAllowance - amount);
853             }
854         }
855     }
856 
857     /**
858      * @dev Hook that is called before any transfer of tokens. This includes
859      * minting and burning.
860      *
861      * Calling conditions:
862      *
863      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
864      * will be transferred to `to`.
865      * - when `from` is zero, `amount` tokens will be minted for `to`.
866      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
867      * - `from` and `to` are never both zero.
868      *
869      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
870      */
871     function _beforeTokenTransfer(
872         address from,
873         address to,
874         uint256 amount
875     ) internal virtual {}
876 
877     /**
878      * @dev Hook that is called after any transfer of tokens. This includes
879      * minting and burning.
880      *
881      * Calling conditions:
882      *
883      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
884      * has been transferred to `to`.
885      * - when `from` is zero, `amount` tokens have been minted for `to`.
886      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
887      * - `from` and `to` are never both zero.
888      *
889      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
890      */
891     function _afterTokenTransfer(
892         address from,
893         address to,
894         uint256 amount
895     ) internal virtual {}
896 }
897 
898 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
899 
900 /**
901  * @dev Contract module which provides a basic access control mechanism, where
902  * there is an account (an owner) that can be granted exclusive access to
903  * specific functions.
904  *
905  * By default, the owner account will be the one that deploys the contract. This
906  * can later be changed with {transferOwnership}.
907  *
908  * This module is used through inheritance. It will make available the modifier
909  * `onlyOwner`, which can be applied to your functions to restrict their use to
910  * the owner.
911  */
912 abstract contract Ownable is Context {
913     address private _owner;
914 
915     event OwnershipTransferred(
916         address indexed previousOwner,
917         address indexed newOwner
918     );
919 
920     /**
921      * @dev Initializes the contract setting the deployer as the initial owner.
922      */
923     constructor() {
924         _transferOwnership(_msgSender());
925     }
926 
927     /**
928      * @dev Returns the address of the current owner.
929      */
930     function owner() public view virtual returns (address) {
931         return _owner;
932     }
933 
934     /**
935      * @dev Throws if called by any account other than the owner.
936      */
937     modifier onlyOwner() {
938         require(owner() == _msgSender(), "Ownable: caller is not the owner");
939         _;
940     }
941 
942     /**
943      * @dev Leaves the contract without owner. It will not be possible to call
944      * `onlyOwner` functions anymore. Can only be called by the current owner.
945      *
946      * NOTE: Renouncing ownership will leave the contract without an owner,
947      * thereby removing any functionality that is only available to the owner.
948      */
949     function renounceOwnership() public virtual onlyOwner {
950         _transferOwnership(address(0));
951     }
952 
953     /**
954      * @dev Transfers ownership of the contract to a new account (`newOwner`).
955      * Can only be called by the current owner.
956      */
957     function transferOwnership(address newOwner) public virtual onlyOwner {
958         require(
959             newOwner != address(0),
960             "Ownable: new owner is the zero address"
961         );
962         _transferOwnership(newOwner);
963     }
964 
965     /**
966      * @dev Transfers ownership of the contract to a new account (`newOwner`).
967      * Internal function without access restriction.
968      */
969     function _transferOwnership(address newOwner) internal virtual {
970         address oldOwner = _owner;
971         _owner = newOwner;
972         emit OwnershipTransferred(oldOwner, newOwner);
973     }
974 }
975 
976 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
977 
978 // CAUTION
979 // This version of SafeMath should only be used with Solidity 0.8 or later,
980 // because it relies on the compiler's built in overflow checks.
981 
982 /**
983  * @dev Wrappers over Solidity's arithmetic operations.
984  *
985  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
986  * now has built in overflow checking.
987  */
988 library SafeMath {
989     /**
990      * @dev Returns the addition of two unsigned integers, with an overflow flag.
991      *
992      * _Available since v3.4._
993      */
994     function tryAdd(uint256 a, uint256 b)
995         internal
996         pure
997         returns (bool, uint256)
998     {
999         unchecked {
1000             uint256 c = a + b;
1001             if (c < a) return (false, 0);
1002             return (true, c);
1003         }
1004     }
1005 
1006     /**
1007      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1008      *
1009      * _Available since v3.4._
1010      */
1011     function trySub(uint256 a, uint256 b)
1012         internal
1013         pure
1014         returns (bool, uint256)
1015     {
1016         unchecked {
1017             if (b > a) return (false, 0);
1018             return (true, a - b);
1019         }
1020     }
1021 
1022     /**
1023      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1024      *
1025      * _Available since v3.4._
1026      */
1027     function tryMul(uint256 a, uint256 b)
1028         internal
1029         pure
1030         returns (bool, uint256)
1031     {
1032         unchecked {
1033             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1034             // benefit is lost if 'b' is also tested.
1035             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1036             if (a == 0) return (true, 0);
1037             uint256 c = a * b;
1038             if (c / a != b) return (false, 0);
1039             return (true, c);
1040         }
1041     }
1042 
1043     /**
1044      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1045      *
1046      * _Available since v3.4._
1047      */
1048     function tryDiv(uint256 a, uint256 b)
1049         internal
1050         pure
1051         returns (bool, uint256)
1052     {
1053         unchecked {
1054             if (b == 0) return (false, 0);
1055             return (true, a / b);
1056         }
1057     }
1058 
1059     /**
1060      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1061      *
1062      * _Available since v3.4._
1063      */
1064     function tryMod(uint256 a, uint256 b)
1065         internal
1066         pure
1067         returns (bool, uint256)
1068     {
1069         unchecked {
1070             if (b == 0) return (false, 0);
1071             return (true, a % b);
1072         }
1073     }
1074 
1075     /**
1076      * @dev Returns the addition of two unsigned integers, reverting on
1077      * overflow.
1078      *
1079      * Counterpart to Solidity's `+` operator.
1080      *
1081      * Requirements:
1082      *
1083      * - Addition cannot overflow.
1084      */
1085     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1086         return a + b;
1087     }
1088 
1089     /**
1090      * @dev Returns the subtraction of two unsigned integers, reverting on
1091      * overflow (when the result is negative).
1092      *
1093      * Counterpart to Solidity's `-` operator.
1094      *
1095      * Requirements:
1096      *
1097      * - Subtraction cannot overflow.
1098      */
1099     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1100         return a - b;
1101     }
1102 
1103     /**
1104      * @dev Returns the multiplication of two unsigned integers, reverting on
1105      * overflow.
1106      *
1107      * Counterpart to Solidity's `*` operator.
1108      *
1109      * Requirements:
1110      *
1111      * - Multiplication cannot overflow.
1112      */
1113     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1114         return a * b;
1115     }
1116 
1117     /**
1118      * @dev Returns the integer division of two unsigned integers, reverting on
1119      * division by zero. The result is rounded towards zero.
1120      *
1121      * Counterpart to Solidity's `/` operator.
1122      *
1123      * Requirements:
1124      *
1125      * - The divisor cannot be zero.
1126      */
1127     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1128         return a / b;
1129     }
1130 
1131     /**
1132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1133      * reverting when dividing by zero.
1134      *
1135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1136      * opcode (which leaves remaining gas untouched) while Solidity uses an
1137      * invalid opcode to revert (consuming all remaining gas).
1138      *
1139      * Requirements:
1140      *
1141      * - The divisor cannot be zero.
1142      */
1143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1144         return a % b;
1145     }
1146 
1147     /**
1148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1149      * overflow (when the result is negative).
1150      *
1151      * CAUTION: This function is deprecated because it requires allocating memory for the error
1152      * message unnecessarily. For custom revert reasons use {trySub}.
1153      *
1154      * Counterpart to Solidity's `-` operator.
1155      *
1156      * Requirements:
1157      *
1158      * - Subtraction cannot overflow.
1159      */
1160     function sub(
1161         uint256 a,
1162         uint256 b,
1163         string memory errorMessage
1164     ) internal pure returns (uint256) {
1165         unchecked {
1166             require(b <= a, errorMessage);
1167             return a - b;
1168         }
1169     }
1170 
1171     /**
1172      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1173      * division by zero. The result is rounded towards zero.
1174      *
1175      * Counterpart to Solidity's `/` operator. Note: this function uses a
1176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1177      * uses an invalid opcode to revert (consuming all remaining gas).
1178      *
1179      * Requirements:
1180      *
1181      * - The divisor cannot be zero.
1182      */
1183     function div(
1184         uint256 a,
1185         uint256 b,
1186         string memory errorMessage
1187     ) internal pure returns (uint256) {
1188         unchecked {
1189             require(b > 0, errorMessage);
1190             return a / b;
1191         }
1192     }
1193 
1194     /**
1195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1196      * reverting with custom message when dividing by zero.
1197      *
1198      * CAUTION: This function is deprecated because it requires allocating memory for the error
1199      * message unnecessarily. For custom revert reasons use {tryMod}.
1200      *
1201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1202      * opcode (which leaves remaining gas untouched) while Solidity uses an
1203      * invalid opcode to revert (consuming all remaining gas).
1204      *
1205      * Requirements:
1206      *
1207      * - The divisor cannot be zero.
1208      */
1209     function mod(
1210         uint256 a,
1211         uint256 b,
1212         string memory errorMessage
1213     ) internal pure returns (uint256) {
1214         unchecked {
1215             require(b > 0, errorMessage);
1216             return a % b;
1217         }
1218     }
1219 }
1220 
1221 contract DurhamInu is ERC20, Ownable {
1222     using SafeMath for uint256;
1223 
1224     IUniswapV2Router02 public immutable uniswapV2Router;
1225     address public immutable uniswapV2Pair;
1226     address public constant deadAddress = address(0xdead);
1227 
1228     bool private swapping;
1229 
1230     address public marketingWallet;
1231     address public devWallet;
1232 
1233     uint256 public maxTransactionAmount;
1234     uint256 public swapTokensAtAmount;
1235     uint256 public maxWallet;
1236 
1237     uint256 public percentForLPBurn = 25; // 25 = .25%
1238     bool public lpBurnEnabled = true;
1239     uint256 public lpBurnFrequency = 3600 seconds;
1240     uint256 public lastLpBurnTime;
1241 
1242     uint256 public manualBurnFrequency = 30 minutes;
1243     uint256 public lastManualLpBurnTime;
1244 
1245     bool public limitsInEffect = true;
1246     bool public tradingActive = false;
1247     bool public swapEnabled = false;
1248 
1249     // Anti-bot and anti-whale mappings and variables
1250     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1251     bool public transferDelayEnabled = true;
1252 
1253     uint256 public buyTotalFees;
1254     uint256 public buyMarketingFee;
1255     uint256 public buyLiquidityFee;
1256     uint256 public buyDevFee;
1257 
1258     uint256 public sellTotalFees;
1259     uint256 public sellMarketingFee;
1260     uint256 public sellLiquidityFee;
1261     uint256 public sellDevFee;
1262 
1263     uint256 public tokensForMarketing;
1264     uint256 public tokensForLiquidity;
1265     uint256 public tokensForDev;
1266 
1267     /******************/
1268 
1269     // exlcude from fees and max transaction amount
1270     mapping(address => bool) private _isExcludedFromFees;
1271     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1272 
1273     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1274     // could be subject to a maximum transfer amount
1275     mapping(address => bool) public automatedMarketMakerPairs;
1276 
1277     event UpdateUniswapV2Router(
1278         address indexed newAddress,
1279         address indexed oldAddress
1280     );
1281 
1282     event ExcludeFromFees(address indexed account, bool isExcluded);
1283 
1284     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1285 
1286     event marketingWalletUpdated(
1287         address indexed newWallet,
1288         address indexed oldWallet
1289     );
1290 
1291     event devWalletUpdated(
1292         address indexed newWallet,
1293         address indexed oldWallet
1294     );
1295 
1296     event SwapAndLiquify(
1297         uint256 tokensSwapped,
1298         uint256 ethReceived,
1299         uint256 tokensIntoLiquidity
1300     );
1301 
1302     event AutoNukeLP();
1303 
1304     event ManualNukeLP();
1305 
1306     constructor() ERC20("Durham Inu", "RBI") {
1307         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1308             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1309         );
1310 
1311         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1312         uniswapV2Router = _uniswapV2Router;
1313 
1314         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1315             .createPair(address(this), _uniswapV2Router.WETH());
1316         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1317         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1318 
1319         uint256 _buyMarketingFee = 5;
1320         uint256 _buyLiquidityFee = 3;
1321         uint256 _buyDevFee = 2;
1322 
1323         uint256 _sellMarketingFee = 10;
1324         uint256 _sellLiquidityFee = 3;
1325         uint256 _sellDevFee = 2;
1326 
1327         uint256 totalSupply = 1_000_000_000 * 1e18;
1328 
1329         maxTransactionAmount = (totalSupply * 1) / 1000; // 0.1% maxTransactionAmountTxn
1330         maxWallet = (totalSupply * 5) / 1000; // .5% maxWallet
1331         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1332 
1333         buyMarketingFee = _buyMarketingFee;
1334         buyLiquidityFee = _buyLiquidityFee;
1335         buyDevFee = _buyDevFee;
1336         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1337 
1338         sellMarketingFee = _sellMarketingFee;
1339         sellLiquidityFee = _sellLiquidityFee;
1340         sellDevFee = _sellDevFee;
1341         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1342 
1343         marketingWallet = address(owner()); // set as marketing wallet
1344         devWallet = address(owner()); // set as dev wallet
1345 
1346         // exclude from paying fees or having max transaction amount
1347         excludeFromFees(owner(), true);
1348         excludeFromFees(address(this), true);
1349         excludeFromFees(address(0xdead), true);
1350 
1351         excludeFromMaxTransaction(owner(), true);
1352         excludeFromMaxTransaction(address(this), true);
1353         excludeFromMaxTransaction(address(0xdead), true);
1354 
1355         /*
1356             _mint is an internal function in ERC20.sol that is only called here,
1357             and CANNOT be called ever again
1358         */
1359         _mint(msg.sender, totalSupply);
1360     }
1361 
1362     receive() external payable {}
1363 
1364     // once enabled, can never be turned off
1365     function enableTrading() external onlyOwner {
1366         tradingActive = true;
1367         swapEnabled = true;
1368         lastLpBurnTime = block.timestamp;
1369     }
1370 
1371     // remove limits after token is stable
1372     function removeLimits() external onlyOwner returns (bool) {
1373         limitsInEffect = false;
1374         return true;
1375     }
1376 
1377     // disable Transfer delay - cannot be reenabled
1378     function disableTransferDelay() external onlyOwner returns (bool) {
1379         transferDelayEnabled = false;
1380         return true;
1381     }
1382 
1383     // change the minimum amount of tokens to sell from fees
1384     function updateSwapTokensAtAmount(uint256 newAmount)
1385         external
1386         onlyOwner
1387         returns (bool)
1388     {
1389         require(
1390             newAmount >= (totalSupply() * 1) / 100000,
1391             "Swap amount cannot be lower than 0.001% total supply."
1392         );
1393         require(
1394             newAmount <= (totalSupply() * 5) / 1000,
1395             "Swap amount cannot be higher than 0.5% total supply."
1396         );
1397         swapTokensAtAmount = newAmount;
1398         return true;
1399     }
1400 
1401     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1402         require(
1403             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1404             "Cannot set maxTransactionAmount lower than 0.1%"
1405         );
1406         maxTransactionAmount = newNum * (10**18);
1407     }
1408 
1409     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1410         require(
1411             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1412             "Cannot set maxWallet lower than 0.5%"
1413         );
1414         maxWallet = newNum * (10**18);
1415     }
1416 
1417     function excludeFromMaxTransaction(address updAds, bool isEx)
1418         public
1419         onlyOwner
1420     {
1421         _isExcludedMaxTransactionAmount[updAds] = isEx;
1422     }
1423 
1424     // only use to disable contract sales if absolutely necessary (emergency use only)
1425     function updateSwapEnabled(bool enabled) external onlyOwner {
1426         swapEnabled = enabled;
1427     }
1428 
1429     function updateBuyFees(
1430         uint256 _marketingFee,
1431         uint256 _liquidityFee,
1432         uint256 _devFee
1433     ) external onlyOwner {
1434         buyMarketingFee = _marketingFee;
1435         buyLiquidityFee = _liquidityFee;
1436         buyDevFee = _devFee;
1437         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1438         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1439     }
1440 
1441     function updateSellFees(
1442         uint256 _marketingFee,
1443         uint256 _liquidityFee,
1444         uint256 _devFee
1445     ) external onlyOwner {
1446         sellMarketingFee = _marketingFee;
1447         sellLiquidityFee = _liquidityFee;
1448         sellDevFee = _devFee;
1449         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1450         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1451     }
1452 
1453     function excludeFromFees(address account, bool excluded) public onlyOwner {
1454         _isExcludedFromFees[account] = excluded;
1455         emit ExcludeFromFees(account, excluded);
1456     }
1457 
1458     function setAutomatedMarketMakerPair(address pair, bool value)
1459         public
1460         onlyOwner
1461     {
1462         require(
1463             pair != uniswapV2Pair,
1464             "The pair cannot be removed from automatedMarketMakerPairs"
1465         );
1466 
1467         _setAutomatedMarketMakerPair(pair, value);
1468     }
1469 
1470     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1471         automatedMarketMakerPairs[pair] = value;
1472 
1473         emit SetAutomatedMarketMakerPair(pair, value);
1474     }
1475 
1476     function updateMarketingWallet(address newMarketingWallet)
1477         external
1478         onlyOwner
1479     {
1480         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1481         marketingWallet = newMarketingWallet;
1482     }
1483 
1484     function updateDevWallet(address newWallet) external onlyOwner {
1485         emit devWalletUpdated(newWallet, devWallet);
1486         devWallet = newWallet;
1487     }
1488 
1489     function isExcludedFromFees(address account) public view returns (bool) {
1490         return _isExcludedFromFees[account];
1491     }
1492 
1493     event BoughtEarly(address indexed sniper);
1494 
1495     function _transfer(
1496         address from,
1497         address to,
1498         uint256 amount
1499     ) internal override {
1500         require(from != address(0), "ERC20: transfer from the zero address");
1501         require(to != address(0), "ERC20: transfer to the zero address");
1502 
1503         if (amount == 0) {
1504             super._transfer(from, to, 0);
1505             return;
1506         }
1507 
1508         if (limitsInEffect) {
1509             if (
1510                 from != owner() &&
1511                 to != owner() &&
1512                 to != address(0) &&
1513                 to != address(0xdead) &&
1514                 !swapping
1515             ) {
1516                 if (!tradingActive) {
1517                     require(
1518                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1519                         "Trading is not active."
1520                     );
1521                 }
1522 
1523                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1524                 if (transferDelayEnabled) {
1525                     if (
1526                         to != owner() &&
1527                         to != address(uniswapV2Router) &&
1528                         to != address(uniswapV2Pair)
1529                     ) {
1530                         require(
1531                             _holderLastTransferTimestamp[tx.origin] <
1532                                 block.number,
1533                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1534                         );
1535                         _holderLastTransferTimestamp[tx.origin] = block.number;
1536                     }
1537                 }
1538 
1539                 //when buy
1540                 if (
1541                     automatedMarketMakerPairs[from] &&
1542                     !_isExcludedMaxTransactionAmount[to]
1543                 ) {
1544                     require(
1545                         amount <= maxTransactionAmount,
1546                         "Buy transfer amount exceeds the maxTransactionAmount."
1547                     );
1548                     require(
1549                         amount + balanceOf(to) <= maxWallet,
1550                         "Max wallet exceeded"
1551                     );
1552                 }
1553                 //when sell
1554                 else if (
1555                     automatedMarketMakerPairs[to] &&
1556                     !_isExcludedMaxTransactionAmount[from]
1557                 ) {
1558                     require(
1559                         amount <= maxTransactionAmount,
1560                         "Sell transfer amount exceeds the maxTransactionAmount."
1561                     );
1562                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1563                     require(
1564                         amount + balanceOf(to) <= maxWallet,
1565                         "Max wallet exceeded"
1566                     );
1567                 }
1568             }
1569         }
1570 
1571         uint256 contractTokenBalance = balanceOf(address(this));
1572 
1573         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1574 
1575         if (
1576             canSwap &&
1577             swapEnabled &&
1578             !swapping &&
1579             !automatedMarketMakerPairs[from] &&
1580             !_isExcludedFromFees[from] &&
1581             !_isExcludedFromFees[to]
1582         ) {
1583             swapping = true;
1584 
1585             swapBack();
1586 
1587             swapping = false;
1588         }
1589 
1590         if (
1591             !swapping &&
1592             automatedMarketMakerPairs[to] &&
1593             lpBurnEnabled &&
1594             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1595             !_isExcludedFromFees[from]
1596         ) {
1597             autoBurnLiquidityPairTokens();
1598         }
1599 
1600         bool takeFee = !swapping;
1601 
1602         // if any account belongs to _isExcludedFromFee account then remove the fee
1603         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1604             takeFee = false;
1605         }
1606 
1607         uint256 fees = 0;
1608         // only take fees on buys/sells, do not take on wallet transfers
1609         if (takeFee) {
1610             // on sell
1611             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1612                 fees = amount.mul(sellTotalFees).div(100);
1613                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1614                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1615                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1616             }
1617             // on buy
1618             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1619                 fees = amount.mul(buyTotalFees).div(100);
1620                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1621                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1622                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1623             }
1624 
1625             if (fees > 0) {
1626                 super._transfer(from, address(this), fees);
1627             }
1628 
1629             amount -= fees;
1630         }
1631 
1632         super._transfer(from, to, amount);
1633     }
1634 
1635     function swapTokensForEth(uint256 tokenAmount) private {
1636         // generate the uniswap pair path of token -> weth
1637         address[] memory path = new address[](2);
1638         path[0] = address(this);
1639         path[1] = uniswapV2Router.WETH();
1640 
1641         _approve(address(this), address(uniswapV2Router), tokenAmount);
1642 
1643         // make the swap
1644         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1645             tokenAmount,
1646             0, // accept any amount of ETH
1647             path,
1648             address(this),
1649             block.timestamp
1650         );
1651     }
1652 
1653     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1654         // approve token transfer to cover all possible scenarios
1655         _approve(address(this), address(uniswapV2Router), tokenAmount);
1656 
1657         // add the liquidity
1658         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1659             address(this),
1660             tokenAmount,
1661             0, // slippage is unavoidable
1662             0, // slippage is unavoidable
1663             deadAddress,
1664             block.timestamp
1665         );
1666     }
1667 
1668     function swapBack() private {
1669         uint256 contractBalance = balanceOf(address(this));
1670         uint256 totalTokensToSwap = tokensForLiquidity +
1671             tokensForMarketing +
1672             tokensForDev;
1673         bool success;
1674 
1675         if (contractBalance == 0 || totalTokensToSwap == 0) {
1676             return;
1677         }
1678 
1679         if (contractBalance > swapTokensAtAmount * 20) {
1680             contractBalance = swapTokensAtAmount * 20;
1681         }
1682 
1683         // Halve the amount of liquidity tokens
1684         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1685             totalTokensToSwap /
1686             2;
1687         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1688 
1689         uint256 initialETHBalance = address(this).balance;
1690 
1691         swapTokensForEth(amountToSwapForETH);
1692 
1693         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1694 
1695         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1696             totalTokensToSwap
1697         );
1698         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1699 
1700         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1701 
1702         tokensForLiquidity = 0;
1703         tokensForMarketing = 0;
1704         tokensForDev = 0;
1705 
1706         (success, ) = address(devWallet).call{value: ethForDev}("");
1707 
1708         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1709             addLiquidity(liquidityTokens, ethForLiquidity);
1710             emit SwapAndLiquify(
1711                 amountToSwapForETH,
1712                 ethForLiquidity,
1713                 tokensForLiquidity
1714             );
1715         }
1716 
1717         (success, ) = address(marketingWallet).call{
1718             value: address(this).balance
1719         }("");
1720     }
1721 
1722     function setAutoLPBurnSettings(
1723         uint256 _frequencyInSeconds,
1724         uint256 _percent,
1725         bool _Enabled
1726     ) external onlyOwner {
1727         require(
1728             _frequencyInSeconds >= 600,
1729             "cannot set buyback more often than every 10 minutes"
1730         );
1731         require(
1732             _percent <= 1000 && _percent >= 0,
1733             "Must set auto LP burn percent between 0% and 10%"
1734         );
1735         lpBurnFrequency = _frequencyInSeconds;
1736         percentForLPBurn = _percent;
1737         lpBurnEnabled = _Enabled;
1738     }
1739 
1740     function autoBurnLiquidityPairTokens() internal returns (bool) {
1741         lastLpBurnTime = block.timestamp;
1742 
1743         // get balance of liquidity pair
1744         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1745 
1746         // calculate amount to burn
1747         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1748             10000
1749         );
1750 
1751         // pull tokens from pancakePair liquidity and move to dead address permanently
1752         if (amountToBurn > 0) {
1753             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1754         }
1755 
1756         //sync price since this is not in a swap transaction!
1757         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1758         pair.sync();
1759         emit AutoNukeLP();
1760         return true;
1761     }
1762 
1763     function manualBurnLiquidityPairTokens(uint256 percent)
1764         external
1765         onlyOwner
1766         returns (bool)
1767     {
1768         require(
1769             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1770             "Must wait for cooldown to finish"
1771         );
1772         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1773         lastManualLpBurnTime = block.timestamp;
1774 
1775         // get balance of liquidity pair
1776         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1777 
1778         // calculate amount to burn
1779         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1780 
1781         // pull tokens from pancakePair liquidity and move to dead address permanently
1782         if (amountToBurn > 0) {
1783             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1784         }
1785 
1786         //sync price since this is not in a swap transaction!
1787         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1788         pair.sync();
1789         emit ManualNukeLP();
1790         return true;
1791     }
1792 }