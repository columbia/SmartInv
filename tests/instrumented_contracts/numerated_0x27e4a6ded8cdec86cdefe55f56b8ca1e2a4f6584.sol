1 //ChatGPT bot available on Telegram as @ChatGPT_ERC_BOT
2 
3 //Telegram: https://t.me/chatgpt_erc
4 //Twitter: https://twitter.com/ChatGPT_ERC20
5 //Website: https://chat-gpt.app/
6 
7 
8 // SPDX-License-Identifier: MIT
9 
10 pragma solidity 0.8.16;
11 
12 interface IUniswapV2Factory {
13     event PairCreated(
14         address indexed token0,
15         address indexed token1,
16         address pair,
17         uint256
18     );
19 
20     function feeTo() external view returns (address);
21 
22     function feeToSetter() external view returns (address);
23 
24     function allPairsLength() external view returns (uint256);
25 
26     function getPair(address tokenA, address tokenB)
27         external
28         view
29         returns (address pair);
30 
31     function allPairs(uint256) external view returns (address pair);
32 
33     function createPair(address tokenA, address tokenB)
34         external
35         returns (address pair);
36 
37     function setFeeTo(address) external;
38 
39     function setFeeToSetter(address) external;
40 }
41 
42 interface IUniswapV2Pair {
43     event Approval(
44         address indexed owner,
45         address indexed spender,
46         uint256 value
47     );
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 
50     function name() external pure returns (string memory);
51 
52     function symbol() external pure returns (string memory);
53 
54     function decimals() external pure returns (uint8);
55 
56     function totalSupply() external view returns (uint256);
57 
58     function balanceOf(address owner) external view returns (uint256);
59 
60     function allowance(address owner, address spender)
61         external
62         view
63         returns (uint256);
64 
65     function approve(address spender, uint256 value) external returns (bool);
66 
67     function transfer(address to, uint256 value) external returns (bool);
68 
69     function transferFrom(
70         address from,
71         address to,
72         uint256 value
73     ) external returns (bool);
74 
75     function DOMAIN_SEPARATOR() external view returns (bytes32);
76 
77     function PERMIT_TYPEHASH() external pure returns (bytes32);
78 
79     function nonces(address owner) external view returns (uint256);
80 
81     function permit(
82         address owner,
83         address spender,
84         uint256 value,
85         uint256 deadline,
86         uint8 v,
87         bytes32 r,
88         bytes32 s
89     ) external;
90 
91     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
92     event Burn(
93         address indexed sender,
94         uint256 amount0,
95         uint256 amount1,
96         address indexed to
97     );
98     event Swap(
99         address indexed sender,
100         uint256 amount0In,
101         uint256 amount1In,
102         uint256 amount0Out,
103         uint256 amount1Out,
104         address indexed to
105     );
106     event Sync(uint112 reserve0, uint112 reserve1);
107 
108     function MINIMUM_LIQUIDITY() external pure returns (uint256);
109 
110     function factory() external view returns (address);
111 
112     function token0() external view returns (address);
113 
114     function token1() external view returns (address);
115 
116     function getReserves()
117         external
118         view
119         returns (
120             uint112 reserve0,
121             uint112 reserve1,
122             uint32 blockTimestampLast
123         );
124 
125     function price0CumulativeLast() external view returns (uint256);
126 
127     function price1CumulativeLast() external view returns (uint256);
128 
129     function kLast() external view returns (uint256);
130 
131     function mint(address to) external returns (uint256 liquidity);
132 
133     function burn(address to)
134         external
135         returns (uint256 amount0, uint256 amount1);
136 
137     function swap(
138         uint256 amount0Out,
139         uint256 amount1Out,
140         address to,
141         bytes calldata data
142     ) external;
143 
144     function skim(address to) external;
145 
146     function sync() external;
147 
148     function initialize(address, address) external;
149 }
150 
151 interface IUniswapV2Router01 {
152     function factory() external pure returns (address);
153 
154     function WETH() external pure returns (address);
155 
156     function addLiquidity(
157         address tokenA,
158         address tokenB,
159         uint256 amountADesired,
160         uint256 amountBDesired,
161         uint256 amountAMin,
162         uint256 amountBMin,
163         address to,
164         uint256 deadline
165     )
166         external
167         returns (
168             uint256 amountA,
169             uint256 amountB,
170             uint256 liquidity
171         );
172 
173     function addLiquidityETH(
174         address token,
175         uint256 amountTokenDesired,
176         uint256 amountTokenMin,
177         uint256 amountETHMin,
178         address to,
179         uint256 deadline
180     )
181         external
182         payable
183         returns (
184             uint256 amountToken,
185             uint256 amountETH,
186             uint256 liquidity
187         );
188 
189     function removeLiquidity(
190         address tokenA,
191         address tokenB,
192         uint256 liquidity,
193         uint256 amountAMin,
194         uint256 amountBMin,
195         address to,
196         uint256 deadline
197     ) external returns (uint256 amountA, uint256 amountB);
198 
199     function removeLiquidityETH(
200         address token,
201         uint256 liquidity,
202         uint256 amountTokenMin,
203         uint256 amountETHMin,
204         address to,
205         uint256 deadline
206     ) external returns (uint256 amountToken, uint256 amountETH);
207 
208     function removeLiquidityWithPermit(
209         address tokenA,
210         address tokenB,
211         uint256 liquidity,
212         uint256 amountAMin,
213         uint256 amountBMin,
214         address to,
215         uint256 deadline,
216         bool approveMax,
217         uint8 v,
218         bytes32 r,
219         bytes32 s
220     ) external returns (uint256 amountA, uint256 amountB);
221 
222     function removeLiquidityETHWithPermit(
223         address token,
224         uint256 liquidity,
225         uint256 amountTokenMin,
226         uint256 amountETHMin,
227         address to,
228         uint256 deadline,
229         bool approveMax,
230         uint8 v,
231         bytes32 r,
232         bytes32 s
233     ) external returns (uint256 amountToken, uint256 amountETH);
234 
235     function swapExactTokensForTokens(
236         uint256 amountIn,
237         uint256 amountOutMin,
238         address[] calldata path,
239         address to,
240         uint256 deadline
241     ) external returns (uint256[] memory amounts);
242 
243     function swapTokensForExactTokens(
244         uint256 amountOut,
245         uint256 amountInMax,
246         address[] calldata path,
247         address to,
248         uint256 deadline
249     ) external returns (uint256[] memory amounts);
250 
251     function swapExactETHForTokens(
252         uint256 amountOutMin,
253         address[] calldata path,
254         address to,
255         uint256 deadline
256     ) external payable returns (uint256[] memory amounts);
257 
258     function swapTokensForExactETH(
259         uint256 amountOut,
260         uint256 amountInMax,
261         address[] calldata path,
262         address to,
263         uint256 deadline
264     ) external returns (uint256[] memory amounts);
265 
266     function swapExactTokensForETH(
267         uint256 amountIn,
268         uint256 amountOutMin,
269         address[] calldata path,
270         address to,
271         uint256 deadline
272     ) external returns (uint256[] memory amounts);
273 
274     function swapETHForExactTokens(
275         uint256 amountOut,
276         address[] calldata path,
277         address to,
278         uint256 deadline
279     ) external payable returns (uint256[] memory amounts);
280 
281     function quote(
282         uint256 amountA,
283         uint256 reserveA,
284         uint256 reserveB
285     ) external pure returns (uint256 amountB);
286 
287     function getAmountOut(
288         uint256 amountIn,
289         uint256 reserveIn,
290         uint256 reserveOut
291     ) external pure returns (uint256 amountOut);
292 
293     function getAmountIn(
294         uint256 amountOut,
295         uint256 reserveIn,
296         uint256 reserveOut
297     ) external pure returns (uint256 amountIn);
298 
299     function getAmountsOut(uint256 amountIn, address[] calldata path)
300         external
301         view
302         returns (uint256[] memory amounts);
303 
304     function getAmountsIn(uint256 amountOut, address[] calldata path)
305         external
306         view
307         returns (uint256[] memory amounts);
308 }
309 
310 interface IUniswapV2Router02 is IUniswapV2Router01 {
311     function removeLiquidityETHSupportingFeeOnTransferTokens(
312         address token,
313         uint256 liquidity,
314         uint256 amountTokenMin,
315         uint256 amountETHMin,
316         address to,
317         uint256 deadline
318     ) external returns (uint256 amountETH);
319 
320     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
321         address token,
322         uint256 liquidity,
323         uint256 amountTokenMin,
324         uint256 amountETHMin,
325         address to,
326         uint256 deadline,
327         bool approveMax,
328         uint8 v,
329         bytes32 r,
330         bytes32 s
331     ) external returns (uint256 amountETH);
332 
333     function swapExactETHForTokensSupportingFeeOnTransferTokens(
334         uint256 amountOutMin,
335         address[] calldata path,
336         address to,
337         uint256 deadline
338     ) external payable;
339 
340     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
341         uint256 amountIn,
342         uint256 amountOutMin,
343         address[] calldata path,
344         address to,
345         uint256 deadline
346     ) external;
347 
348     function swapExactTokensForETHSupportingFeeOnTransferTokens(
349         uint256 amountIn,
350         uint256 amountOutMin,
351         address[] calldata path,
352         address to,
353         uint256 deadline
354     ) external;
355 }
356 
357 /**
358  * @dev Interface of the ERC20 standard as defined in the EIP.
359  */
360 interface IERC20 {
361     /**
362      * @dev Emitted when `value` tokens are moved from one account (`from`) to
363      * another (`to`).
364      *
365      * Note that `value` may be zero.
366      */
367     event Transfer(address indexed from, address indexed to, uint256 value);
368 
369     /**
370      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
371      * a call to {approve}. `value` is the new allowance.
372      */
373     event Approval(
374         address indexed owner,
375         address indexed spender,
376         uint256 value
377     );
378 
379     /**
380      * @dev Returns the amount of tokens in existence.
381      */
382     function totalSupply() external view returns (uint256);
383 
384     /**
385      * @dev Returns the amount of tokens owned by `account`.
386      */
387     function balanceOf(address account) external view returns (uint256);
388 
389     /**
390      * @dev Moves `amount` tokens from the caller's account to `to`.
391      *
392      * Returns a boolean value indicating whether the operation succeeded.
393      *
394      * Emits a {Transfer} event.
395      */
396     function transfer(address to, uint256 amount) external returns (bool);
397 
398     /**
399      * @dev Returns the remaining number of tokens that `spender` will be
400      * allowed to spend on behalf of `owner` through {transferFrom}. This is
401      * zero by default.
402      *
403      * This value changes when {approve} or {transferFrom} are called.
404      */
405     function allowance(address owner, address spender)
406         external
407         view
408         returns (uint256);
409 
410     /**
411      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
412      *
413      * Returns a boolean value indicating whether the operation succeeded.
414      *
415      * IMPORTANT: Beware that changing an allowance with this method brings the risk
416      * that someone may use both the old and the new allowance by unfortunate
417      * transaction ordering. One possible solution to mitigate this race
418      * condition is to first reduce the spender's allowance to 0 and set the
419      * desired value afterwards:
420      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
421      *
422      * Emits an {Approval} event.
423      */
424     function approve(address spender, uint256 amount) external returns (bool);
425 
426     /**
427      * @dev Moves `amount` tokens from `from` to `to` using the
428      * allowance mechanism. `amount` is then deducted from the caller's
429      * allowance.
430      *
431      * Returns a boolean value indicating whether the operation succeeded.
432      *
433      * Emits a {Transfer} event.
434      */
435     function transferFrom(
436         address from,
437         address to,
438         uint256 amount
439     ) external returns (bool);
440 }
441 
442 /**
443  * @dev Interface for the optional metadata functions from the ERC20 standard.
444  *
445  * _Available since v4.1._
446  */
447 interface IERC20Metadata is IERC20 {
448     /**
449      * @dev Returns the name of the token.
450      */
451     function name() external view returns (string memory);
452 
453     /**
454      * @dev Returns the decimals places of the token.
455      */
456     function decimals() external view returns (uint8);
457 
458     /**
459      * @dev Returns the symbol of the token.
460      */
461     function symbol() external view returns (string memory);
462 }
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
478 }
479 
480 /**
481  * @dev Contract module which provides a basic access control mechanism, where
482  * there is an account (an owner) that can be granted exclusive access to
483  * specific functions.
484  *
485  * By default, the owner account will be the one that deploys the contract. This
486  * can later be changed with {transferOwnership}.
487  *
488  * This module is used through inheritance. It will make available the modifier
489  * `onlyOwner`, which can be applied to your functions to restrict their use to
490  * the owner.
491  */
492 abstract contract Ownable is Context {
493     address private _owner;
494 
495     event OwnershipTransferred(
496         address indexed previousOwner,
497         address indexed newOwner
498     );
499 
500     /**
501      * @dev Initializes the contract setting the deployer as the initial owner.
502      */
503     constructor() {
504         _transferOwnership(_msgSender());
505     }
506 
507     /**
508      * @dev Throws if called by any account other than the owner.
509      */
510     modifier onlyOwner() {
511         _checkOwner();
512         _;
513     }
514 
515     /**
516      * @dev Returns the address of the current owner.
517      */
518     function owner() public view virtual returns (address) {
519         return _owner;
520     }
521 
522     /**
523      * @dev Throws if the sender is not the owner.
524      */
525     function _checkOwner() internal view virtual {
526         require(owner() == _msgSender(), "Ownable: caller is not the owner");
527     }
528 
529     /**
530      * @dev Leaves the contract without owner. It will not be possible to call
531      * `onlyOwner` functions anymore. Can only be called by the current owner.
532      *
533      * NOTE: Renouncing ownership will leave the contract without an owner,
534      * thereby removing any functionality that is only available to the owner.
535      */
536     function renounceOwnership() public virtual onlyOwner {
537         _transferOwnership(address(0));
538     }
539 
540     /**
541      * @dev Transfers ownership of the contract to a new account (`newOwner`).
542      * Can only be called by the current owner.
543      */
544     function transferOwnership(address newOwner) public virtual onlyOwner {
545         require(
546             newOwner != address(0),
547             "Ownable: new owner is the zero address"
548         );
549         _transferOwnership(newOwner);
550     }
551 
552     /**
553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
554      * Internal function without access restriction.
555      */
556     function _transferOwnership(address newOwner) internal virtual {
557         address oldOwner = _owner;
558         _owner = newOwner;
559         emit OwnershipTransferred(oldOwner, newOwner);
560     }
561 }
562 
563 /**
564  * @dev Implementation of the {IERC20} interface.
565  *
566  * This implementation is agnostic to the way tokens are created. This means
567  * that a supply mechanism has to be added in a derived contract using {_mint}.
568  * For a generic mechanism see {ERC20PresetMinterPauser}.
569  *
570  * TIP: For a detailed writeup see our guide
571  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
572  * to implement supply mechanisms].
573  *
574  * We have followed general OpenZeppelin Contracts guidelines: functions revert
575  * instead returning `false` on failure. This behavior is nonetheless
576  * conventional and does not conflict with the expectations of ERC20
577  * applications.
578  *
579  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
580  * This allows applications to reconstruct the allowance for all accounts just
581  * by listening to said events. Other implementations of the EIP may not emit
582  * these events, as it isn't required by the specification.
583  *
584  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
585  * functions have been added to mitigate the well-known issues around setting
586  * allowances. See {IERC20-approve}.
587  */
588 contract ERC20 is Context, IERC20, IERC20Metadata {
589     mapping(address => uint256) private _balances;
590     mapping(address => mapping(address => uint256)) private _allowances;
591 
592     uint256 private _totalSupply;
593 
594     string private _name;
595     string private _symbol;
596 
597     constructor(string memory name_, string memory symbol_) {
598         _name = name_;
599         _symbol = symbol_;
600     }
601 
602     /**
603      * @dev Returns the symbol of the token, usually a shorter version of the
604      * name.
605      */
606     function symbol() external view virtual override returns (string memory) {
607         return _symbol;
608     }
609 
610     /**
611      * @dev Returns the name of the token.
612      */
613     function name() external view virtual override returns (string memory) {
614         return _name;
615     }
616 
617     /**
618      * @dev See {IERC20-balanceOf}.
619      */
620     function balanceOf(address account)
621         public
622         view
623         virtual
624         override
625         returns (uint256)
626     {
627         return _balances[account];
628     }
629 
630     /**
631      * @dev Returns the number of decimals used to get its user representation.
632      * For example, if `decimals` equals `2`, a balance of `505` tokens should
633      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
634      *
635      * Tokens usually opt for a value of 18, imitating the relationship between
636      * Ether and Wei. This is the value {ERC20} uses, unless this function is
637      * overridden;
638      *
639      * NOTE: This information is only used for _display_ purposes: it in
640      * no way affects any of the arithmetic of the contract, including
641      * {IERC20-balanceOf} and {IERC20-transfer}.
642      */
643     function decimals() public view virtual override returns (uint8) {
644         return 9;
645     }
646 
647     /**
648      * @dev See {IERC20-totalSupply}.
649      */
650     function totalSupply() external view virtual override returns (uint256) {
651         return _totalSupply;
652     }
653 
654     /**
655      * @dev See {IERC20-allowance}.
656      */
657     function allowance(address owner, address spender)
658         public
659         view
660         virtual
661         override
662         returns (uint256)
663     {
664         return _allowances[owner][spender];
665     }
666 
667     /**
668      * @dev See {IERC20-transfer}.
669      *
670      * Requirements:
671      *
672      * - `to` cannot be the zero address.
673      * - the caller must have a balance of at least `amount`.
674      */
675     function transfer(address to, uint256 amount)
676         external
677         virtual
678         override
679         returns (bool)
680     {
681         address owner = _msgSender();
682         _transfer(owner, to, amount);
683         return true;
684     }
685 
686     /**
687      * @dev See {IERC20-approve}.
688      *
689      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
690      * `transferFrom`. This is semantically equivalent to an infinite approval.
691      *
692      * Requirements:
693      *
694      * - `spender` cannot be the zero address.
695      */
696     function approve(address spender, uint256 amount)
697         external
698         virtual
699         override
700         returns (bool)
701     {
702         address owner = _msgSender();
703         _approve(owner, spender, amount);
704         return true;
705     }
706 
707     /**
708      * @dev See {IERC20-transferFrom}.
709      *
710      * Emits an {Approval} event indicating the updated allowance. This is not
711      * required by the EIP. See the note at the beginning of {ERC20}.
712      *
713      * NOTE: Does not update the allowance if the current allowance
714      * is the maximum `uint256`.
715      *
716      * Requirements:
717      *
718      * - `from` and `to` cannot be the zero address.
719      * - `from` must have a balance of at least `amount`.
720      * - the caller must have allowance for ``from``'s tokens of at least
721      * `amount`.
722      */
723     function transferFrom(
724         address from,
725         address to,
726         uint256 amount
727     ) external virtual override returns (bool) {
728         address spender = _msgSender();
729         _spendAllowance(from, spender, amount);
730         _transfer(from, to, amount);
731         return true;
732     }
733 
734     /**
735      * @dev Atomically decreases the allowance granted to `spender` by the caller.
736      *
737      * This is an alternative to {approve} that can be used as a mitigation for
738      * problems described in {IERC20-approve}.
739      *
740      * Emits an {Approval} event indicating the updated allowance.
741      *
742      * Requirements:
743      *
744      * - `spender` cannot be the zero address.
745      * - `spender` must have allowance for the caller of at least
746      * `subtractedValue`.
747      */
748     function decreaseAllowance(address spender, uint256 subtractedValue)
749         external
750         virtual
751         returns (bool)
752     {
753         address owner = _msgSender();
754         uint256 currentAllowance = allowance(owner, spender);
755         require(
756             currentAllowance >= subtractedValue,
757             "ERC20: decreased allowance below zero"
758         );
759         unchecked {
760             _approve(owner, spender, currentAllowance - subtractedValue);
761         }
762 
763         return true;
764     }
765 
766     /**
767      * @dev Atomically increases the allowance granted to `spender` by the caller.
768      *
769      * This is an alternative to {approve} that can be used as a mitigation for
770      * problems described in {IERC20-approve}.
771      *
772      * Emits an {Approval} event indicating the updated allowance.
773      *
774      * Requirements:
775      *
776      * - `spender` cannot be the zero address.
777      */
778     function increaseAllowance(address spender, uint256 addedValue)
779         external
780         virtual
781         returns (bool)
782     {
783         address owner = _msgSender();
784         _approve(owner, spender, allowance(owner, spender) + addedValue);
785         return true;
786     }
787 
788     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
789      * the total supply.
790      *
791      * Emits a {Transfer} event with `from` set to the zero address.
792      *
793      * Requirements:
794      *
795      * - `account` cannot be the zero address.
796      */
797     function _mint(address account, uint256 amount) internal virtual {
798         require(account != address(0), "ERC20: mint to the zero address");
799 
800         _totalSupply += amount;
801         unchecked {
802             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
803             _balances[account] += amount;
804         }
805         emit Transfer(address(0), account, amount);
806     }
807 
808     /**
809      * @dev Destroys `amount` tokens from `account`, reducing the
810      * total supply.
811      *
812      * Emits a {Transfer} event with `to` set to the zero address.
813      *
814      * Requirements:
815      *
816      * - `account` cannot be the zero address.
817      * - `account` must have at least `amount` tokens.
818      */
819     function _burn(address account, uint256 amount) internal virtual {
820         require(account != address(0), "ERC20: burn from the zero address");
821 
822         uint256 accountBalance = _balances[account];
823         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
824         unchecked {
825             _balances[account] = accountBalance - amount;
826             // Overflow not possible: amount <= accountBalance <= totalSupply.
827             _totalSupply -= amount;
828         }
829 
830         emit Transfer(account, address(0), amount);
831     }
832 
833     /**
834      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
835      *
836      * This internal function is equivalent to `approve`, and can be used to
837      * e.g. set automatic allowances for certain subsystems, etc.
838      *
839      * Emits an {Approval} event.
840      *
841      * Requirements:
842      *
843      * - `owner` cannot be the zero address.
844      * - `spender` cannot be the zero address.
845      */
846     function _approve(
847         address owner,
848         address spender,
849         uint256 amount
850     ) internal virtual {
851         require(owner != address(0), "ERC20: approve from the zero address");
852         require(spender != address(0), "ERC20: approve to the zero address");
853 
854         _allowances[owner][spender] = amount;
855         emit Approval(owner, spender, amount);
856     }
857 
858     /**
859      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
860      *
861      * Does not update the allowance amount in case of infinite allowance.
862      * Revert if not enough allowance is available.
863      *
864      * Might emit an {Approval} event.
865      */
866     function _spendAllowance(
867         address owner,
868         address spender,
869         uint256 amount
870     ) internal virtual {
871         uint256 currentAllowance = allowance(owner, spender);
872         if (currentAllowance != type(uint256).max) {
873             require(
874                 currentAllowance >= amount,
875                 "ERC20: insufficient allowance"
876             );
877             unchecked {
878                 _approve(owner, spender, currentAllowance - amount);
879             }
880         }
881     }
882 
883     function _transfer(
884         address from,
885         address to,
886         uint256 amount
887     ) internal virtual {
888         require(from != address(0), "ERC20: transfer from the zero address");
889         require(to != address(0), "ERC20: transfer to the zero address");
890 
891         uint256 fromBalance = _balances[from];
892         require(
893             fromBalance >= amount,
894             "ERC20: transfer amount exceeds balance"
895         );
896         unchecked {
897             _balances[from] = fromBalance - amount;
898             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
899             // decrementing then incrementing.
900             _balances[to] += amount;
901         }
902 
903         emit Transfer(from, to, amount);
904     }
905 }
906 
907 /**
908  * @dev Implementation of the {IERC20} interface.
909  *
910  * This implementation is agnostic to the way tokens are created. This means
911  * that a supply mechanism has to be added in a derived contract using {_mint}.
912  * For a generic mechanism see {ERC20PresetMinterPauser}.
913  *
914  * TIP: For a detailed writeup see our guide
915  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
916  * to implement supply mechanisms].
917  *
918  * We have followed general OpenZeppelin Contracts guidelines: functions revert
919  * instead returning `false` on failure. This behavior is nonetheless
920  * conventional and does not conflict with the expectations of ERC20
921  * applications.
922  *
923  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
924  * This allows applications to reconstruct the allowance for all accounts just
925  * by listening to said events. Other implementations of the EIP may not emit
926  * these events, as it isn't required by the specification.
927  *
928  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
929  * functions have been added to mitigate the well-known issues around setting
930  * allowances. See {IERC20-approve}.
931  */
932  contract ChatGPT is ERC20, Ownable {
933     // TOKENOMICS START ==========================================================>
934     string private _name = "ChatGPT";
935     string private _symbol = "AI";
936     uint8 private _decimals = 9;
937     uint256 private _supply = 100000000;
938     uint256 public taxForLiquidity = 0;
939     uint256 public taxForMarketing = 25;
940     uint256 public maxTxAmount = 1000000 * 10**_decimals;
941     uint256 public maxWalletAmount = 1000000 * 10**_decimals;
942     address public marketingWallet = 0xCe90C5b05AdCD3a6F57F36D4E0f9234167cC4340;
943     // TOKENOMICS END ============================================================>
944 
945     IUniswapV2Router02 public immutable uniswapV2Router;
946     address public immutable uniswapV2Pair;
947 
948     uint256 private _marketingReserves = 0;
949     mapping(address => bool) private _isExcludedFromFee;
950     uint256 private _numTokensSellToAddToLiquidity = 1000000 * 10**_decimals;
951     uint256 private _numTokensSellToAddToETH = 200000 * 10**_decimals;
952     bool inSwapAndLiquify;
953 
954     event SwapAndLiquify(
955         uint256 tokensSwapped,
956         uint256 ethReceived,
957         uint256 tokensIntoLiqudity
958     );
959 
960     modifier lockTheSwap() {
961         inSwapAndLiquify = true;
962         _;
963         inSwapAndLiquify = false;
964     }
965 
966     /**
967      * @dev Sets the values for {name} and {symbol}.
968      *
969      * The default value of {decimals} is 18. To select a different value for
970      * {decimals} you should overload it.
971      *
972      * All two of these values are immutable: they can only be set once during
973      * construction.
974      */
975     constructor() ERC20(_name, _symbol) {
976         _mint(msg.sender, (_supply * 10**_decimals));
977 
978         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
979         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
980 
981         uniswapV2Router = _uniswapV2Router;
982 
983         _isExcludedFromFee[address(uniswapV2Router)] = true;
984         _isExcludedFromFee[msg.sender] = true;
985         _isExcludedFromFee[marketingWallet] = true;
986     }
987 
988     /**
989      * @dev Moves `amount` of tokens from `from` to `to`.
990      *
991      * This internal function is equivalent to {transfer}, and can be used to
992      * e.g. implement automatic token fees, slashing mechanisms, etc.
993      *
994      * Emits a {Transfer} event.
995      *
996      * Requirements:
997      *
998      *
999      * - `from` cannot be the zero address.
1000      * - `to` cannot be the zero address.
1001      * - `from` must have a balance of at least `amount`.
1002      */
1003     function _transfer(address from, address to, uint256 amount) internal override {
1004         require(from != address(0), "ERC20: transfer from the zero address");
1005         require(to != address(0), "ERC20: transfer to the zero address");
1006         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1007 
1008         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1009             if (from != uniswapV2Pair) {
1010                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1011                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1012                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1013                 }
1014                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1015                     _swapTokensForEth(_numTokensSellToAddToETH);
1016                     _marketingReserves -= _numTokensSellToAddToETH;
1017                     bool sent = payable(marketingWallet).send(address(this).balance);
1018                     require(sent, "Failed to send ETH");
1019                 }
1020             }
1021 
1022             uint256 transferAmount;
1023             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1024                 transferAmount = amount;
1025             } 
1026             else {
1027                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1028                 if(from == uniswapV2Pair){
1029                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1030                 }
1031 
1032                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1033                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1034                 transferAmount = amount - (marketingShare + liquidityShare);
1035                 _marketingReserves += marketingShare;
1036 
1037                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1038             }
1039             super._transfer(from, to, transferAmount);
1040         } 
1041         else {
1042             super._transfer(from, to, amount);
1043         }
1044     }
1045 
1046     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1047         uint256 half = (contractTokenBalance / 2);
1048         uint256 otherHalf = (contractTokenBalance - half);
1049 
1050         uint256 initialBalance = address(this).balance;
1051 
1052         _swapTokensForEth(half);
1053 
1054         uint256 newBalance = (address(this).balance - initialBalance);
1055 
1056         _addLiquidity(otherHalf, newBalance);
1057 
1058         emit SwapAndLiquify(half, newBalance, otherHalf);
1059     }
1060 
1061     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1062         address[] memory path = new address[](2);
1063         path[0] = address(this);
1064         path[1] = uniswapV2Router.WETH();
1065 
1066         _approve(address(this), address(uniswapV2Router), tokenAmount);
1067 
1068         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1069             tokenAmount,
1070             0,
1071             path,
1072             address(this),
1073             (block.timestamp + 300)
1074         );
1075     }
1076 
1077     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1078         private
1079         lockTheSwap
1080     {
1081         _approve(address(this), address(uniswapV2Router), tokenAmount);
1082 
1083         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1084             address(this),
1085             tokenAmount,
1086             0,
1087             0,
1088             owner(),
1089             block.timestamp
1090         );
1091     }
1092 
1093     function changeMarketingWallet(address newWallet)
1094         public
1095         onlyOwner
1096         returns (bool)
1097     {
1098         marketingWallet = newWallet;
1099         return true;
1100     }
1101 
1102     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1103         public
1104         onlyOwner
1105         returns (bool)
1106     {
1107         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1108         taxForLiquidity = _taxForLiquidity;
1109         taxForMarketing = _taxForMarketing;
1110 
1111         return true;
1112     }
1113 
1114     function changeMaxTxAmount(uint256 _maxTxAmount)
1115         public
1116         onlyOwner
1117         returns (bool)
1118     {
1119         maxTxAmount = _maxTxAmount;
1120 
1121         return true;
1122     }
1123 
1124     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1125         public
1126         onlyOwner
1127         returns (bool)
1128     {
1129         maxWalletAmount = _maxWalletAmount;
1130 
1131         return true;
1132     }
1133 
1134     receive() external payable {}
1135 }