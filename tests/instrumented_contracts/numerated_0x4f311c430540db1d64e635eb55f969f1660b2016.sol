1 /**
2 Welcome to the Pepechain.
3 
4 Website: https://pepe-chain.vip/
5 Telegram: t.me/pepechainpc
6 Twitter: twitter.com/pepechainpc
7 
8 Our chain is already live, bridge, dex and explorer:
9 Chain ID: 411
10 RPC: https://rpc.pepe-chain.vip/
11 Explorer: https://explorer.pepe-chain.vip
12 Symbol: PEPE
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity 0.8.16;
19 
20 interface IUniswapV2Factory {
21     event PairCreated(
22         address indexed token0,
23         address indexed token1,
24         address pair,
25         uint256
26     );
27 
28     function feeTo() external view returns (address);
29 
30     function feeToSetter() external view returns (address);
31 
32     function allPairsLength() external view returns (uint256);
33 
34     function getPair(address tokenA, address tokenB)
35         external
36         view
37         returns (address pair);
38 
39     function allPairs(uint256) external view returns (address pair);
40 
41     function createPair(address tokenA, address tokenB)
42         external
43         returns (address pair);
44 
45     function setFeeTo(address) external;
46 
47     function setFeeToSetter(address) external;
48 }
49 
50 interface IUniswapV2Pair {
51     event Approval(
52         address indexed owner,
53         address indexed spender,
54         uint256 value
55     );
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     function name() external pure returns (string memory);
59 
60     function symbol() external pure returns (string memory);
61 
62     function decimals() external pure returns (uint8);
63 
64     function totalSupply() external view returns (uint256);
65 
66     function balanceOf(address owner) external view returns (uint256);
67 
68     function allowance(address owner, address spender)
69         external
70         view
71         returns (uint256);
72 
73     function approve(address spender, uint256 value) external returns (bool);
74 
75     function transfer(address to, uint256 value) external returns (bool);
76 
77     function transferFrom(
78         address from,
79         address to,
80         uint256 value
81     ) external returns (bool);
82 
83     function DOMAIN_SEPARATOR() external view returns (bytes32);
84 
85     function PERMIT_TYPEHASH() external pure returns (bytes32);
86 
87     function nonces(address owner) external view returns (uint256);
88 
89     function permit(
90         address owner,
91         address spender,
92         uint256 value,
93         uint256 deadline,
94         uint8 v,
95         bytes32 r,
96         bytes32 s
97     ) external;
98 
99     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
100     event Burn(
101         address indexed sender,
102         uint256 amount0,
103         uint256 amount1,
104         address indexed to
105     );
106     event Swap(
107         address indexed sender,
108         uint256 amount0In,
109         uint256 amount1In,
110         uint256 amount0Out,
111         uint256 amount1Out,
112         address indexed to
113     );
114     event Sync(uint112 reserve0, uint112 reserve1);
115 
116     function MINIMUM_LIQUIDITY() external pure returns (uint256);
117 
118     function factory() external view returns (address);
119 
120     function token0() external view returns (address);
121 
122     function token1() external view returns (address);
123 
124     function getReserves()
125         external
126         view
127         returns (
128             uint112 reserve0,
129             uint112 reserve1,
130             uint32 blockTimestampLast
131         );
132 
133     function price0CumulativeLast() external view returns (uint256);
134 
135     function price1CumulativeLast() external view returns (uint256);
136 
137     function kLast() external view returns (uint256);
138 
139     function mint(address to) external returns (uint256 liquidity);
140 
141     function burn(address to)
142         external
143         returns (uint256 amount0, uint256 amount1);
144 
145     function swap(
146         uint256 amount0Out,
147         uint256 amount1Out,
148         address to,
149         bytes calldata data
150     ) external;
151 
152     function skim(address to) external;
153 
154     function sync() external;
155 
156     function initialize(address, address) external;
157 }
158 
159 interface IUniswapV2Router01 {
160     function factory() external pure returns (address);
161 
162     function WETH() external pure returns (address);
163 
164     function addLiquidity(
165         address tokenA,
166         address tokenB,
167         uint256 amountADesired,
168         uint256 amountBDesired,
169         uint256 amountAMin,
170         uint256 amountBMin,
171         address to,
172         uint256 deadline
173     )
174         external
175         returns (
176             uint256 amountA,
177             uint256 amountB,
178             uint256 liquidity
179         );
180 
181     function addLiquidityETH(
182         address token,
183         uint256 amountTokenDesired,
184         uint256 amountTokenMin,
185         uint256 amountETHMin,
186         address to,
187         uint256 deadline
188     )
189         external
190         payable
191         returns (
192             uint256 amountToken,
193             uint256 amountETH,
194             uint256 liquidity
195         );
196 
197     function removeLiquidity(
198         address tokenA,
199         address tokenB,
200         uint256 liquidity,
201         uint256 amountAMin,
202         uint256 amountBMin,
203         address to,
204         uint256 deadline
205     ) external returns (uint256 amountA, uint256 amountB);
206 
207     function removeLiquidityETH(
208         address token,
209         uint256 liquidity,
210         uint256 amountTokenMin,
211         uint256 amountETHMin,
212         address to,
213         uint256 deadline
214     ) external returns (uint256 amountToken, uint256 amountETH);
215 
216     function removeLiquidityWithPermit(
217         address tokenA,
218         address tokenB,
219         uint256 liquidity,
220         uint256 amountAMin,
221         uint256 amountBMin,
222         address to,
223         uint256 deadline,
224         bool approveMax,
225         uint8 v,
226         bytes32 r,
227         bytes32 s
228     ) external returns (uint256 amountA, uint256 amountB);
229 
230     function removeLiquidityETHWithPermit(
231         address token,
232         uint256 liquidity,
233         uint256 amountTokenMin,
234         uint256 amountETHMin,
235         address to,
236         uint256 deadline,
237         bool approveMax,
238         uint8 v,
239         bytes32 r,
240         bytes32 s
241     ) external returns (uint256 amountToken, uint256 amountETH);
242 
243     function swapExactTokensForTokens(
244         uint256 amountIn,
245         uint256 amountOutMin,
246         address[] calldata path,
247         address to,
248         uint256 deadline
249     ) external returns (uint256[] memory amounts);
250 
251     function swapTokensForExactTokens(
252         uint256 amountOut,
253         uint256 amountInMax,
254         address[] calldata path,
255         address to,
256         uint256 deadline
257     ) external returns (uint256[] memory amounts);
258 
259     function swapExactETHForTokens(
260         uint256 amountOutMin,
261         address[] calldata path,
262         address to,
263         uint256 deadline
264     ) external payable returns (uint256[] memory amounts);
265 
266     function swapTokensForExactETH(
267         uint256 amountOut,
268         uint256 amountInMax,
269         address[] calldata path,
270         address to,
271         uint256 deadline
272     ) external returns (uint256[] memory amounts);
273 
274     function swapExactTokensForETH(
275         uint256 amountIn,
276         uint256 amountOutMin,
277         address[] calldata path,
278         address to,
279         uint256 deadline
280     ) external returns (uint256[] memory amounts);
281 
282     function swapETHForExactTokens(
283         uint256 amountOut,
284         address[] calldata path,
285         address to,
286         uint256 deadline
287     ) external payable returns (uint256[] memory amounts);
288 
289     function quote(
290         uint256 amountA,
291         uint256 reserveA,
292         uint256 reserveB
293     ) external pure returns (uint256 amountB);
294 
295     function getAmountOut(
296         uint256 amountIn,
297         uint256 reserveIn,
298         uint256 reserveOut
299     ) external pure returns (uint256 amountOut);
300 
301     function getAmountIn(
302         uint256 amountOut,
303         uint256 reserveIn,
304         uint256 reserveOut
305     ) external pure returns (uint256 amountIn);
306 
307     function getAmountsOut(uint256 amountIn, address[] calldata path)
308         external
309         view
310         returns (uint256[] memory amounts);
311 
312     function getAmountsIn(uint256 amountOut, address[] calldata path)
313         external
314         view
315         returns (uint256[] memory amounts);
316 }
317 
318 interface IUniswapV2Router02 is IUniswapV2Router01 {
319     function removeLiquidityETHSupportingFeeOnTransferTokens(
320         address token,
321         uint256 liquidity,
322         uint256 amountTokenMin,
323         uint256 amountETHMin,
324         address to,
325         uint256 deadline
326     ) external returns (uint256 amountETH);
327 
328     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
329         address token,
330         uint256 liquidity,
331         uint256 amountTokenMin,
332         uint256 amountETHMin,
333         address to,
334         uint256 deadline,
335         bool approveMax,
336         uint8 v,
337         bytes32 r,
338         bytes32 s
339     ) external returns (uint256 amountETH);
340 
341     function swapExactETHForTokensSupportingFeeOnTransferTokens(
342         uint256 amountOutMin,
343         address[] calldata path,
344         address to,
345         uint256 deadline
346     ) external payable;
347 
348     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
349         uint256 amountIn,
350         uint256 amountOutMin,
351         address[] calldata path,
352         address to,
353         uint256 deadline
354     ) external;
355 
356     function swapExactTokensForETHSupportingFeeOnTransferTokens(
357         uint256 amountIn,
358         uint256 amountOutMin,
359         address[] calldata path,
360         address to,
361         uint256 deadline
362     ) external;
363 }
364 
365 /**
366  * @dev Interface of the ERC20 standard as defined in the EIP.
367  */
368 interface IERC20 {
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(
382         address indexed owner,
383         address indexed spender,
384         uint256 value
385     );
386 
387     /**
388      * @dev Returns the amount of tokens in existence.
389      */
390     function totalSupply() external view returns (uint256);
391 
392     /**
393      * @dev Returns the amount of tokens owned by `account`.
394      */
395     function balanceOf(address account) external view returns (uint256);
396 
397     /**
398      * @dev Moves `amount` tokens from the caller's account to `to`.
399      *
400      * Returns a boolean value indicating whether the operation succeeded.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transfer(address to, uint256 amount) external returns (bool);
405 
406     /**
407      * @dev Returns the remaining number of tokens that `spender` will be
408      * allowed to spend on behalf of `owner` through {transferFrom}. This is
409      * zero by default.
410      *
411      * This value changes when {approve} or {transferFrom} are called.
412      */
413     function allowance(address owner, address spender)
414         external
415         view
416         returns (uint256);
417 
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
420      *
421      * Returns a boolean value indicating whether the operation succeeded.
422      *
423      * IMPORTANT: Beware that changing an allowance with this method brings the risk
424      * that someone may use both the old and the new allowance by unfortunate
425      * transaction ordering. One possible solution to mitigate this race
426      * condition is to first reduce the spender's allowance to 0 and set the
427      * desired value afterwards:
428      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
429      *
430      * Emits an {Approval} event.
431      */
432     function approve(address spender, uint256 amount) external returns (bool);
433 
434     /**
435      * @dev Moves `amount` tokens from `from` to `to` using the
436      * allowance mechanism. `amount` is then deducted from the caller's
437      * allowance.
438      *
439      * Returns a boolean value indicating whether the operation succeeded.
440      *
441      * Emits a {Transfer} event.
442      */
443     function transferFrom(
444         address from,
445         address to,
446         uint256 amount
447     ) external returns (bool);
448 }
449 
450 /**
451  * @dev Interface for the optional metadata functions from the ERC20 standard.
452  *
453  * _Available since v4.1._
454  */
455 interface IERC20Metadata is IERC20 {
456     /**
457      * @dev Returns the name of the token.
458      */
459     function name() external view returns (string memory);
460 
461     /**
462      * @dev Returns the decimals places of the token.
463      */
464     function decimals() external view returns (uint8);
465 
466     /**
467      * @dev Returns the symbol of the token.
468      */
469     function symbol() external view returns (string memory);
470 }
471 
472 /**
473  * @dev Provides information about the current execution context, including the
474  * sender of the transaction and its data. While these are generally available
475  * via msg.sender and msg.data, they should not be accessed in such a direct
476  * manner, since when dealing with meta-transactions the account sending and
477  * paying for execution may not be the actual sender (as far as an application
478  * is concerned).
479  *
480  * This contract is only required for intermediate, library-like contracts.
481  */
482 abstract contract Context {
483     function _msgSender() internal view virtual returns (address) {
484         return msg.sender;
485     }
486 }
487 
488 /**
489  * @dev Contract module which provides a basic access control mechanism, where
490  * there is an account (an owner) that can be granted exclusive access to
491  * specific functions.
492  *
493  * By default, the owner account will be the one that deploys the contract. This
494  * can later be changed with {transferOwnership}.
495  *
496  * This module is used through inheritance. It will make available the modifier
497  * `onlyOwner`, which can be applied to your functions to restrict their use to
498  * the owner.
499  */
500 abstract contract Ownable is Context {
501     address private _owner;
502 
503     event OwnershipTransferred(
504         address indexed previousOwner,
505         address indexed newOwner
506     );
507 
508     /**
509      * @dev Initializes the contract setting the deployer as the initial owner.
510      */
511     constructor() {
512         _transferOwnership(_msgSender());
513     }
514 
515     /**
516      * @dev Throws if called by any account other than the owner.
517      */
518     modifier onlyOwner() {
519         _checkOwner();
520         _;
521     }
522 
523     /**
524      * @dev Returns the address of the current owner.
525      */
526     function owner() public view virtual returns (address) {
527         return _owner;
528     }
529 
530     /**
531      * @dev Throws if the sender is not the owner.
532      */
533     function _checkOwner() internal view virtual {
534         require(owner() == _msgSender(), "Ownable: caller is not the owner");
535     }
536 
537     /**
538      * @dev Leaves the contract without owner. It will not be possible to call
539      * `onlyOwner` functions anymore. Can only be called by the current owner.
540      *
541      * NOTE: Renouncing ownership will leave the contract without an owner,
542      * thereby removing any functionality that is only available to the owner.
543      */
544     function renounceOwnership() public virtual onlyOwner {
545         _transferOwnership(address(0));
546     }
547 
548     /**
549      * @dev Transfers ownership of the contract to a new account (`newOwner`).
550      * Can only be called by the current owner.
551      */
552     function transferOwnership(address newOwner) public virtual onlyOwner {
553         require(
554             newOwner != address(0),
555             "Ownable: new owner is the zero address"
556         );
557         _transferOwnership(newOwner);
558     }
559 
560     /**
561      * @dev Transfers ownership of the contract to a new account (`newOwner`).
562      * Internal function without access restriction.
563      */
564     function _transferOwnership(address newOwner) internal virtual {
565         address oldOwner = _owner;
566         _owner = newOwner;
567         emit OwnershipTransferred(oldOwner, newOwner);
568     }
569 }
570 
571 /**
572  * @dev Implementation of the {IERC20} interface.
573  *
574  * This implementation is agnostic to the way tokens are created. This means
575  * that a supply mechanism has to be added in a derived contract using {_mint}.
576  * For a generic mechanism see {ERC20PresetMinterPauser}.
577  *
578  * TIP: For a detailed writeup see our guide
579  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
580  * to implement supply mechanisms].
581  *
582  * We have followed general OpenZeppelin Contracts guidelines: functions revert
583  * instead returning `false` on failure. This behavior is nonetheless
584  * conventional and does not conflict with the expectations of ERC20
585  * applications.
586  *
587  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
588  * This allows applications to reconstruct the allowance for all accounts just
589  * by listening to said events. Other implementations of the EIP may not emit
590  * these events, as it isn't required by the specification.
591  *
592  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
593  * functions have been added to mitigate the well-known issues around setting
594  * allowances. See {IERC20-approve}.
595  */
596 contract ERC20 is Context, IERC20, IERC20Metadata {
597     mapping(address => uint256) private _balances;
598     mapping(address => mapping(address => uint256)) private _allowances;
599 
600     uint256 private _totalSupply;
601 
602     string private _name;
603     string private _symbol;
604 
605     constructor(string memory name_, string memory symbol_) {
606         _name = name_;
607         _symbol = symbol_;
608     }
609 
610     /**
611      * @dev Returns the symbol of the token, usually a shorter version of the
612      * name.
613      */
614     function symbol() external view virtual override returns (string memory) {
615         return _symbol;
616     }
617 
618     /**
619      * @dev Returns the name of the token.
620      */
621     function name() external view virtual override returns (string memory) {
622         return _name;
623     }
624 
625     /**
626      * @dev See {IERC20-balanceOf}.
627      */
628     function balanceOf(address account)
629         public
630         view
631         virtual
632         override
633         returns (uint256)
634     {
635         return _balances[account];
636     }
637 
638     /**
639      * @dev Returns the number of decimals used to get its user representation.
640      * For example, if `decimals` equals `2`, a balance of `505` tokens should
641      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
642      *
643      * Tokens usually opt for a value of 18, imitating the relationship between
644      * Ether and Wei. This is the value {ERC20} uses, unless this function is
645      * overridden;
646      *
647      * NOTE: This information is only used for _display_ purposes: it in
648      * no way affects any of the arithmetic of the contract, including
649      * {IERC20-balanceOf} and {IERC20-transfer}.
650      */
651     function decimals() public view virtual override returns (uint8) {
652         return 9;
653     }
654 
655     /**
656      * @dev See {IERC20-totalSupply}.
657      */
658     function totalSupply() external view virtual override returns (uint256) {
659         return _totalSupply;
660     }
661 
662     /**
663      * @dev See {IERC20-allowance}.
664      */
665     function allowance(address owner, address spender)
666         public
667         view
668         virtual
669         override
670         returns (uint256)
671     {
672         return _allowances[owner][spender];
673     }
674 
675     /**
676      * @dev See {IERC20-transfer}.
677      *
678      * Requirements:
679      *
680      * - `to` cannot be the zero address.
681      * - the caller must have a balance of at least `amount`.
682      */
683     function transfer(address to, uint256 amount)
684         external
685         virtual
686         override
687         returns (bool)
688     {
689         address owner = _msgSender();
690         _transfer(owner, to, amount);
691         return true;
692     }
693 
694     /**
695      * @dev See {IERC20-approve}.
696      *
697      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
698      * `transferFrom`. This is semantically equivalent to an infinite approval.
699      *
700      * Requirements:
701      *
702      * - `spender` cannot be the zero address.
703      */
704     function approve(address spender, uint256 amount)
705         external
706         virtual
707         override
708         returns (bool)
709     {
710         address owner = _msgSender();
711         _approve(owner, spender, amount);
712         return true;
713     }
714 
715     /**
716      * @dev See {IERC20-transferFrom}.
717      *
718      * Emits an {Approval} event indicating the updated allowance. This is not
719      * required by the EIP. See the note at the beginning of {ERC20}.
720      *
721      * NOTE: Does not update the allowance if the current allowance
722      * is the maximum `uint256`.
723      *
724      * Requirements:
725      *
726      * - `from` and `to` cannot be the zero address.
727      * - `from` must have a balance of at least `amount`.
728      * - the caller must have allowance for ``from``'s tokens of at least
729      * `amount`.
730      */
731     function transferFrom(
732         address from,
733         address to,
734         uint256 amount
735     ) external virtual override returns (bool) {
736         address spender = _msgSender();
737         _spendAllowance(from, spender, amount);
738         _transfer(from, to, amount);
739         return true;
740     }
741 
742     /**
743      * @dev Atomically decreases the allowance granted to `spender` by the caller.
744      *
745      * This is an alternative to {approve} that can be used as a mitigation for
746      * problems described in {IERC20-approve}.
747      *
748      * Emits an {Approval} event indicating the updated allowance.
749      *
750      * Requirements:
751      *
752      * - `spender` cannot be the zero address.
753      * - `spender` must have allowance for the caller of at least
754      * `subtractedValue`.
755      */
756     function decreaseAllowance(address spender, uint256 subtractedValue)
757         external
758         virtual
759         returns (bool)
760     {
761         address owner = _msgSender();
762         uint256 currentAllowance = allowance(owner, spender);
763         require(
764             currentAllowance >= subtractedValue,
765             "ERC20: decreased allowance below zero"
766         );
767         unchecked {
768             _approve(owner, spender, currentAllowance - subtractedValue);
769         }
770 
771         return true;
772     }
773 
774     /**
775      * @dev Atomically increases the allowance granted to `spender` by the caller.
776      *
777      * This is an alternative to {approve} that can be used as a mitigation for
778      * problems described in {IERC20-approve}.
779      *
780      * Emits an {Approval} event indicating the updated allowance.
781      *
782      * Requirements:
783      *
784      * - `spender` cannot be the zero address.
785      */
786     function increaseAllowance(address spender, uint256 addedValue)
787         external
788         virtual
789         returns (bool)
790     {
791         address owner = _msgSender();
792         _approve(owner, spender, allowance(owner, spender) + addedValue);
793         return true;
794     }
795 
796     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
797      * the total supply.
798      *
799      * Emits a {Transfer} event with `from` set to the zero address.
800      *
801      * Requirements:
802      *
803      * - `account` cannot be the zero address.
804      */
805     function _mint(address account, uint256 amount) internal virtual {
806         require(account != address(0), "ERC20: mint to the zero address");
807 
808         _totalSupply += amount;
809         unchecked {
810             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
811             _balances[account] += amount;
812         }
813         emit Transfer(address(0), account, amount);
814     }
815 
816     /**
817      * @dev Destroys `amount` tokens from `account`, reducing the
818      * total supply.
819      *
820      * Emits a {Transfer} event with `to` set to the zero address.
821      *
822      * Requirements:
823      *
824      * - `account` cannot be the zero address.
825      * - `account` must have at least `amount` tokens.
826      */
827     function _burn(address account, uint256 amount) internal virtual {
828         require(account != address(0), "ERC20: burn from the zero address");
829 
830         uint256 accountBalance = _balances[account];
831         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
832         unchecked {
833             _balances[account] = accountBalance - amount;
834             // Overflow not possible: amount <= accountBalance <= totalSupply.
835             _totalSupply -= amount;
836         }
837 
838         emit Transfer(account, address(0), amount);
839     }
840 
841     /**
842      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
843      *
844      * This internal function is equivalent to `approve`, and can be used to
845      * e.g. set automatic allowances for certain subsystems, etc.
846      *
847      * Emits an {Approval} event.
848      *
849      * Requirements:
850      *
851      * - `owner` cannot be the zero address.
852      * - `spender` cannot be the zero address.
853      */
854     function _approve(
855         address owner,
856         address spender,
857         uint256 amount
858     ) internal virtual {
859         require(owner != address(0), "ERC20: approve from the zero address");
860         require(spender != address(0), "ERC20: approve to the zero address");
861 
862         _allowances[owner][spender] = amount;
863         emit Approval(owner, spender, amount);
864     }
865 
866     /**
867      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
868      *
869      * Does not update the allowance amount in case of infinite allowance.
870      * Revert if not enough allowance is available.
871      *
872      * Might emit an {Approval} event.
873      */
874     function _spendAllowance(
875         address owner,
876         address spender,
877         uint256 amount
878     ) internal virtual {
879         uint256 currentAllowance = allowance(owner, spender);
880         if (currentAllowance != type(uint256).max) {
881             require(
882                 currentAllowance >= amount,
883                 "ERC20: insufficient allowance"
884             );
885             unchecked {
886                 _approve(owner, spender, currentAllowance - amount);
887             }
888         }
889     }
890 
891     function _transfer(
892         address from,
893         address to,
894         uint256 amount
895     ) internal virtual {
896         require(from != address(0), "ERC20: transfer from the zero address");
897         require(to != address(0), "ERC20: transfer to the zero address");
898 
899         uint256 fromBalance = _balances[from];
900         require(
901             fromBalance >= amount,
902             "ERC20: transfer amount exceeds balance"
903         );
904         unchecked {
905             _balances[from] = fromBalance - amount;
906             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
907             // decrementing then incrementing.
908             _balances[to] += amount;
909         }
910 
911         emit Transfer(from, to, amount);
912     }
913 }
914 
915 /**
916  * @dev Implementation of the {IERC20} interface.
917  *
918  * This implementation is agnostic to the way tokens are created. This means
919  * that a supply mechanism has to be added in a derived contract using {_mint}.
920  * For a generic mechanism see {ERC20PresetMinterPauser}.
921  *
922  * TIP: For a detailed writeup see our guide
923  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
924  * to implement supply mechanisms].
925  *
926  * We have followed general OpenZeppelin Contracts guidelines: functions revert
927  * instead returning `false` on failure. This behavior is nonetheless
928  * conventional and does not conflict with the expectations of ERC20
929  * applications.
930  *
931  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
932  * This allows applications to reconstruct the allowance for all accounts just
933  * by listening to said events. Other implementations of the EIP may not emit
934  * these events, as it isn't required by the specification.
935  *
936  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
937  * functions have been added to mitigate the well-known issues around setting
938  * allowances. See {IERC20-approve}.
939  */
940  contract Pepechain is ERC20, Ownable {
941     // TOKENOMICS START ==========================================================>
942     string private _name = "Pepechain Token";
943     string private _symbol = "PC";
944     uint8 private _decimals = 9;
945     uint256 private _supply = 420690000000000;
946     uint256 public taxForLiquidity = 0;
947     uint256 public taxForMarketing = 5;
948     uint256 public maxTxAmount = 6306900000000 * 10**_decimals;
949     uint256 public maxWalletAmount = 6306900000000 * 10**_decimals;
950     address public marketingWallet = 0x3531aF3ff6DE154544E3b5a224B91F9E825f5f75;
951     // TOKENOMICS END ============================================================>
952 
953     IUniswapV2Router02 public immutable uniswapV2Router;
954     address public immutable uniswapV2Pair;
955 
956     uint256 private _marketingReserves = 0;
957     mapping(address => bool) private _isExcludedFromFee;
958     uint256 private _numTokensSellToAddToLiquidity = 1020690000000 * 10**_decimals;
959     uint256 private _numTokensSellToAddToETH = 1020690000000 * 10**_decimals;
960     bool inSwapAndLiquify;
961 
962     event SwapAndLiquify(
963         uint256 tokensSwapped,
964         uint256 ethReceived,
965         uint256 tokensIntoLiqudity
966     );
967 
968     modifier lockTheSwap() {
969         inSwapAndLiquify = true;
970         _;
971         inSwapAndLiquify = false;
972     }
973 
974     /**
975      * @dev Sets the values for {name} and {symbol}.
976      *
977      * The default value of {decimals} is 18. To select a different value for
978      * {decimals} you should overload it.
979      *
980      * All two of these values are immutable: they can only be set once during
981      * construction.
982      */
983     constructor() ERC20(_name, _symbol) {
984         _mint(msg.sender, (_supply * 10**_decimals));
985 
986         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
987         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
988 
989         uniswapV2Router = _uniswapV2Router;
990 
991         _isExcludedFromFee[address(uniswapV2Router)] = true;
992         _isExcludedFromFee[msg.sender] = true;
993         _isExcludedFromFee[marketingWallet] = true;
994     }
995 
996     /**
997      * @dev Moves `amount` of tokens from `from` to `to`.
998      *
999      * This internal function is equivalent to {transfer}, and can be used to
1000      * e.g. implement automatic token fees, slashing mechanisms, etc.
1001      *
1002      * Emits a {Transfer} event.
1003      *
1004      * Requirements:
1005      *
1006      *
1007      * - `from` cannot be the zero address.
1008      * - `to` cannot be the zero address.
1009      * - `from` must have a balance of at least `amount`.
1010      */
1011     function _transfer(address from, address to, uint256 amount) internal override {
1012         require(from != address(0), "ERC20: transfer from the zero address");
1013         require(to != address(0), "ERC20: transfer to the zero address");
1014         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1015 
1016         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1017             if (from != uniswapV2Pair) {
1018                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1019                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1020                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1021                 }
1022                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1023                     _swapTokensForEth(_numTokensSellToAddToETH);
1024                     _marketingReserves -= _numTokensSellToAddToETH;
1025                     bool sent = payable(marketingWallet).send(address(this).balance);
1026                     require(sent, "Failed to send ETH");
1027                 }
1028             }
1029 
1030             uint256 transferAmount;
1031             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1032                 transferAmount = amount;
1033             } 
1034             else {
1035                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1036                 if(from == uniswapV2Pair){
1037                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1038                 }
1039 
1040                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1041                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1042                 transferAmount = amount - (marketingShare + liquidityShare);
1043                 _marketingReserves += marketingShare;
1044 
1045                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1046             }
1047             super._transfer(from, to, transferAmount);
1048         } 
1049         else {
1050             super._transfer(from, to, amount);
1051         }
1052     }
1053 
1054     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1055         uint256 half = (contractTokenBalance / 2);
1056         uint256 otherHalf = (contractTokenBalance - half);
1057 
1058         uint256 initialBalance = address(this).balance;
1059 
1060         _swapTokensForEth(half);
1061 
1062         uint256 newBalance = (address(this).balance - initialBalance);
1063 
1064         _addLiquidity(otherHalf, newBalance);
1065 
1066         emit SwapAndLiquify(half, newBalance, otherHalf);
1067     }
1068 
1069     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1070         address[] memory path = new address[](2);
1071         path[0] = address(this);
1072         path[1] = uniswapV2Router.WETH();
1073 
1074         _approve(address(this), address(uniswapV2Router), tokenAmount);
1075 
1076         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1077             tokenAmount,
1078             0,
1079             path,
1080             address(this),
1081             (block.timestamp + 300)
1082         );
1083     }
1084 
1085     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1086         private
1087         lockTheSwap
1088     {
1089         _approve(address(this), address(uniswapV2Router), tokenAmount);
1090 
1091         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1092             address(this),
1093             tokenAmount,
1094             0,
1095             0,
1096             owner(),
1097             block.timestamp
1098         );
1099     }
1100 
1101     function changeMarketingWallet(address newWallet)
1102         public
1103         onlyOwner
1104         returns (bool)
1105     {
1106         marketingWallet = newWallet;
1107         return true;
1108     }
1109 
1110     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1111         public
1112         onlyOwner
1113         returns (bool)
1114     {
1115         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1116         taxForLiquidity = _taxForLiquidity;
1117         taxForMarketing = _taxForMarketing;
1118 
1119         return true;
1120     }
1121 
1122     function changeMaxTxAmount(uint256 _maxTxAmount)
1123         public
1124         onlyOwner
1125         returns (bool)
1126     {
1127         maxTxAmount = _maxTxAmount;
1128 
1129         return true;
1130     }
1131 
1132     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1133         public
1134         onlyOwner
1135         returns (bool)
1136     {
1137         maxWalletAmount = _maxWalletAmount;
1138 
1139         return true;
1140     }
1141 
1142     receive() external payable {}
1143 }