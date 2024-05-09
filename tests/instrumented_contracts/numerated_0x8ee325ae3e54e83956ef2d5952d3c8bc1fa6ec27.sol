1 /**
2  *Submitted for verification at Etherscan.io on 2022-10-20
3 */
4 
5 /**
6 
7 */
8 
9 /**
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity 0.8.16;
16 
17 interface IUniswapV2Factory {
18     event PairCreated(
19         address indexed token0,
20         address indexed token1,
21         address pair,
22         uint256
23     );
24 
25     function feeTo() external view returns (address);
26 
27     function feeToSetter() external view returns (address);
28 
29     function allPairsLength() external view returns (uint256);
30 
31     function getPair(address tokenA, address tokenB)
32         external
33         view
34         returns (address pair);
35 
36     function allPairs(uint256) external view returns (address pair);
37 
38     function createPair(address tokenA, address tokenB)
39         external
40         returns (address pair);
41 
42     function setFeeTo(address) external;
43 
44     function setFeeToSetter(address) external;
45 }
46 
47 interface IUniswapV2Pair {
48     event Approval(
49         address indexed owner,
50         address indexed spender,
51         uint256 value
52     );
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     function name() external pure returns (string memory);
56 
57     function symbol() external pure returns (string memory);
58 
59     function decimals() external pure returns (uint8);
60 
61     function totalSupply() external view returns (uint256);
62 
63     function balanceOf(address owner) external view returns (uint256);
64 
65     function allowance(address owner, address spender)
66         external
67         view
68         returns (uint256);
69 
70     function approve(address spender, uint256 value) external returns (bool);
71 
72     function transfer(address to, uint256 value) external returns (bool);
73 
74     function transferFrom(
75         address from,
76         address to,
77         uint256 value
78     ) external returns (bool);
79 
80     function DOMAIN_SEPARATOR() external view returns (bytes32);
81 
82     function PERMIT_TYPEHASH() external pure returns (bytes32);
83 
84     function nonces(address owner) external view returns (uint256);
85 
86     function permit(
87         address owner,
88         address spender,
89         uint256 value,
90         uint256 deadline,
91         uint8 v,
92         bytes32 r,
93         bytes32 s
94     ) external;
95 
96     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
97     event Burn(
98         address indexed sender,
99         uint256 amount0,
100         uint256 amount1,
101         address indexed to
102     );
103     event Swap(
104         address indexed sender,
105         uint256 amount0In,
106         uint256 amount1In,
107         uint256 amount0Out,
108         uint256 amount1Out,
109         address indexed to
110     );
111     event Sync(uint112 reserve0, uint112 reserve1);
112 
113     function MINIMUM_LIQUIDITY() external pure returns (uint256);
114 
115     function factory() external view returns (address);
116 
117     function token0() external view returns (address);
118 
119     function token1() external view returns (address);
120 
121     function getReserves()
122         external
123         view
124         returns (
125             uint112 reserve0,
126             uint112 reserve1,
127             uint32 blockTimestampLast
128         );
129 
130     function price0CumulativeLast() external view returns (uint256);
131 
132     function price1CumulativeLast() external view returns (uint256);
133 
134     function kLast() external view returns (uint256);
135 
136     function mint(address to) external returns (uint256 liquidity);
137 
138     function burn(address to)
139         external
140         returns (uint256 amount0, uint256 amount1);
141 
142     function swap(
143         uint256 amount0Out,
144         uint256 amount1Out,
145         address to,
146         bytes calldata data
147     ) external;
148 
149     function skim(address to) external;
150 
151     function sync() external;
152 
153     function initialize(address, address) external;
154 }
155 
156 interface IUniswapV2Router01 {
157     function factory() external pure returns (address);
158 
159     function WETH() external pure returns (address);
160 
161     function addLiquidity(
162         address tokenA,
163         address tokenB,
164         uint256 amountADesired,
165         uint256 amountBDesired,
166         uint256 amountAMin,
167         uint256 amountBMin,
168         address to,
169         uint256 deadline
170     )
171         external
172         returns (
173             uint256 amountA,
174             uint256 amountB,
175             uint256 liquidity
176         );
177 
178     function addLiquidityETH(
179         address token,
180         uint256 amountTokenDesired,
181         uint256 amountTokenMin,
182         uint256 amountETHMin,
183         address to,
184         uint256 deadline
185     )
186         external
187         payable
188         returns (
189             uint256 amountToken,
190             uint256 amountETH,
191             uint256 liquidity
192         );
193 
194     function removeLiquidity(
195         address tokenA,
196         address tokenB,
197         uint256 liquidity,
198         uint256 amountAMin,
199         uint256 amountBMin,
200         address to,
201         uint256 deadline
202     ) external returns (uint256 amountA, uint256 amountB);
203 
204     function removeLiquidityETH(
205         address token,
206         uint256 liquidity,
207         uint256 amountTokenMin,
208         uint256 amountETHMin,
209         address to,
210         uint256 deadline
211     ) external returns (uint256 amountToken, uint256 amountETH);
212 
213     function removeLiquidityWithPermit(
214         address tokenA,
215         address tokenB,
216         uint256 liquidity,
217         uint256 amountAMin,
218         uint256 amountBMin,
219         address to,
220         uint256 deadline,
221         bool approveMax,
222         uint8 v,
223         bytes32 r,
224         bytes32 s
225     ) external returns (uint256 amountA, uint256 amountB);
226 
227     function removeLiquidityETHWithPermit(
228         address token,
229         uint256 liquidity,
230         uint256 amountTokenMin,
231         uint256 amountETHMin,
232         address to,
233         uint256 deadline,
234         bool approveMax,
235         uint8 v,
236         bytes32 r,
237         bytes32 s
238     ) external returns (uint256 amountToken, uint256 amountETH);
239 
240     function swapExactTokensForTokens(
241         uint256 amountIn,
242         uint256 amountOutMin,
243         address[] calldata path,
244         address to,
245         uint256 deadline
246     ) external returns (uint256[] memory amounts);
247 
248     function swapTokensForExactTokens(
249         uint256 amountOut,
250         uint256 amountInMax,
251         address[] calldata path,
252         address to,
253         uint256 deadline
254     ) external returns (uint256[] memory amounts);
255 
256     function swapExactETHForTokens(
257         uint256 amountOutMin,
258         address[] calldata path,
259         address to,
260         uint256 deadline
261     ) external payable returns (uint256[] memory amounts);
262 
263     function swapTokensForExactETH(
264         uint256 amountOut,
265         uint256 amountInMax,
266         address[] calldata path,
267         address to,
268         uint256 deadline
269     ) external returns (uint256[] memory amounts);
270 
271     function swapExactTokensForETH(
272         uint256 amountIn,
273         uint256 amountOutMin,
274         address[] calldata path,
275         address to,
276         uint256 deadline
277     ) external returns (uint256[] memory amounts);
278 
279     function swapETHForExactTokens(
280         uint256 amountOut,
281         address[] calldata path,
282         address to,
283         uint256 deadline
284     ) external payable returns (uint256[] memory amounts);
285 
286     function quote(
287         uint256 amountA,
288         uint256 reserveA,
289         uint256 reserveB
290     ) external pure returns (uint256 amountB);
291 
292     function getAmountOut(
293         uint256 amountIn,
294         uint256 reserveIn,
295         uint256 reserveOut
296     ) external pure returns (uint256 amountOut);
297 
298     function getAmountIn(
299         uint256 amountOut,
300         uint256 reserveIn,
301         uint256 reserveOut
302     ) external pure returns (uint256 amountIn);
303 
304     function getAmountsOut(uint256 amountIn, address[] calldata path)
305         external
306         view
307         returns (uint256[] memory amounts);
308 
309     function getAmountsIn(uint256 amountOut, address[] calldata path)
310         external
311         view
312         returns (uint256[] memory amounts);
313 }
314 
315 interface IUniswapV2Router02 is IUniswapV2Router01 {
316     function removeLiquidityETHSupportingFeeOnTransferTokens(
317         address token,
318         uint256 liquidity,
319         uint256 amountTokenMin,
320         uint256 amountETHMin,
321         address to,
322         uint256 deadline
323     ) external returns (uint256 amountETH);
324 
325     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
326         address token,
327         uint256 liquidity,
328         uint256 amountTokenMin,
329         uint256 amountETHMin,
330         address to,
331         uint256 deadline,
332         bool approveMax,
333         uint8 v,
334         bytes32 r,
335         bytes32 s
336     ) external returns (uint256 amountETH);
337 
338     function swapExactETHForTokensSupportingFeeOnTransferTokens(
339         uint256 amountOutMin,
340         address[] calldata path,
341         address to,
342         uint256 deadline
343     ) external payable;
344 
345     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
346         uint256 amountIn,
347         uint256 amountOutMin,
348         address[] calldata path,
349         address to,
350         uint256 deadline
351     ) external;
352 
353     function swapExactTokensForETHSupportingFeeOnTransferTokens(
354         uint256 amountIn,
355         uint256 amountOutMin,
356         address[] calldata path,
357         address to,
358         uint256 deadline
359     ) external;
360 }
361 
362 /**
363  * @dev Interface of the ERC20 standard as defined in the EIP.
364  */
365 interface IERC20 {
366     /**
367      * @dev Emitted when `value` tokens are moved from one account (`from`) to
368      * another (`to`).
369      *
370      * Note that `value` may be zero.
371      */
372     event Transfer(address indexed from, address indexed to, uint256 value);
373 
374     /**
375      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
376      * a call to {approve}. `value` is the new allowance.
377      */
378     event Approval(
379         address indexed owner,
380         address indexed spender,
381         uint256 value
382     );
383 
384     /**
385      * @dev Returns the amount of tokens in existence.
386      */
387     function totalSupply() external view returns (uint256);
388 
389     /**
390      * @dev Returns the amount of tokens owned by `account`.
391      */
392     function balanceOf(address account) external view returns (uint256);
393 
394     /**
395      * @dev Moves `amount` tokens from the caller's account to `to`.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * Emits a {Transfer} event.
400      */
401     function transfer(address to, uint256 amount) external returns (bool);
402 
403     /**
404      * @dev Returns the remaining number of tokens that `spender` will be
405      * allowed to spend on behalf of `owner` through {transferFrom}. This is
406      * zero by default.
407      *
408      * This value changes when {approve} or {transferFrom} are called.
409      */
410     function allowance(address owner, address spender)
411         external
412         view
413         returns (uint256);
414 
415     /**
416      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
417      *
418      * Returns a boolean value indicating whether the operation succeeded.
419      *
420      * IMPORTANT: Beware that changing an allowance with this method brings the risk
421      * that someone may use both the old and the new allowance by unfortunate
422      * transaction ordering. One possible solution to mitigate this race
423      * condition is to first reduce the spender's allowance to 0 and set the
424      * desired value afterwards:
425      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address spender, uint256 amount) external returns (bool);
430 
431     /**
432      * @dev Moves `amount` tokens from `from` to `to` using the
433      * allowance mechanism. `amount` is then deducted from the caller's
434      * allowance.
435      *
436      * Returns a boolean value indicating whether the operation succeeded.
437      *
438      * Emits a {Transfer} event.
439      */
440     function transferFrom(
441         address from,
442         address to,
443         uint256 amount
444     ) external returns (bool);
445 }
446 
447 /**
448  * @dev Interface for the optional metadata functions from the ERC20 standard.
449  *
450  * _Available since v4.1._
451  */
452 interface IERC20Metadata is IERC20 {
453     /**
454      * @dev Returns the name of the token.
455      */
456     function name() external view returns (string memory);
457 
458     /**
459      * @dev Returns the decimals places of the token.
460      */
461     function decimals() external view returns (uint8);
462 
463     /**
464      * @dev Returns the symbol of the token.
465      */
466     function symbol() external view returns (string memory);
467 }
468 
469 /**
470  * @dev Provides information about the current execution context, including the
471  * sender of the transaction and its data. While these are generally available
472  * via msg.sender and msg.data, they should not be accessed in such a direct
473  * manner, since when dealing with meta-transactions the account sending and
474  * paying for execution may not be the actual sender (as far as an application
475  * is concerned).
476  *
477  * This contract is only required for intermediate, library-like contracts.
478  */
479 abstract contract Context {
480     function _msgSender() internal view virtual returns (address) {
481         return msg.sender;
482     }
483 }
484 
485 /**
486  * @dev Contract module which provides a basic access control mechanism, where
487  * there is an account (an owner) that can be granted exclusive access to
488  * specific functions.
489  *
490  * By default, the owner account will be the one that deploys the contract. This
491  * can later be changed with {transferOwnership}.
492  *
493  * This module is used through inheritance. It will make available the modifier
494  * `onlyOwner`, which can be applied to your functions to restrict their use to
495  * the owner.
496  */
497 abstract contract Ownable is Context {
498     address private _owner;
499 
500     event OwnershipTransferred(
501         address indexed previousOwner,
502         address indexed newOwner
503     );
504 
505     /**
506      * @dev Initializes the contract setting the deployer as the initial owner.
507      */
508     constructor() {
509         _transferOwnership(_msgSender());
510     }
511 
512     /**
513      * @dev Throws if called by any account other than the owner.
514      */
515     modifier onlyOwner() {
516         _checkOwner();
517         _;
518     }
519 
520     /**
521      * @dev Returns the address of the current owner.
522      */
523     function owner() public view virtual returns (address) {
524         return _owner;
525     }
526 
527     /**
528      * @dev Throws if the sender is not the owner.
529      */
530     function _checkOwner() internal view virtual {
531         require(owner() == _msgSender(), "Ownable: caller is not the owner");
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         _transferOwnership(address(0));
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Can only be called by the current owner.
548      */
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(
551             newOwner != address(0),
552             "Ownable: new owner is the zero address"
553         );
554         _transferOwnership(newOwner);
555     }
556 
557     /**
558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
559      * Internal function without access restriction.
560      */
561     function _transferOwnership(address newOwner) internal virtual {
562         address oldOwner = _owner;
563         _owner = newOwner;
564         emit OwnershipTransferred(oldOwner, newOwner);
565     }
566 }
567 
568 /**
569  * @dev Implementation of the {IERC20} interface.
570  *
571  * This implementation is agnostic to the way tokens are created. This means
572  * that a supply mechanism has to be added in a derived contract using {_mint}.
573  * For a generic mechanism see {ERC20PresetMinterPauser}.
574  *
575  * TIP: For a detailed writeup see our guide
576  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
577  * to implement supply mechanisms].
578  *
579  * We have followed general OpenZeppelin Contracts guidelines: functions revert
580  * instead returning `false` on failure. This behavior is nonetheless
581  * conventional and does not conflict with the expectations of ERC20
582  * applications.
583  *
584  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
585  * This allows applications to reconstruct the allowance for all accounts just
586  * by listening to said events. Other implementations of the EIP may not emit
587  * these events, as it isn't required by the specification.
588  *
589  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
590  * functions have been added to mitigate the well-known issues around setting
591  * allowances. See {IERC20-approve}.
592  */
593 contract ERC20 is Context, IERC20, IERC20Metadata {
594     mapping(address => uint256) private _balances;
595     mapping(address => mapping(address => uint256)) private _allowances;
596 
597     uint256 private _totalSupply;
598 
599     string private _name;
600     string private _symbol;
601 
602     constructor(string memory name_, string memory symbol_) {
603         _name = name_;
604         _symbol = symbol_;
605     }
606 
607     /**
608      * @dev Returns the symbol of the token, usually a shorter version of the
609      * name.
610      */
611     function symbol() external view virtual override returns (string memory) {
612         return _symbol;
613     }
614 
615     /**
616      * @dev Returns the name of the token.
617      */
618     function name() external view virtual override returns (string memory) {
619         return _name;
620     }
621 
622     /**
623      * @dev See {IERC20-balanceOf}.
624      */
625     function balanceOf(address account)
626         public
627         view
628         virtual
629         override
630         returns (uint256)
631     {
632         return _balances[account];
633     }
634 
635     /**
636      * @dev Returns the number of decimals used to get its user representation.
637      * For example, if `decimals` equals `2`, a balance of `505` tokens should
638      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
639      *
640      * Tokens usually opt for a value of 18, imitating the relationship between
641      * Ether and Wei. This is the value {ERC20} uses, unless this function is
642      * overridden;
643      *
644      * NOTE: This information is only used for _display_ purposes: it in
645      * no way affects any of the arithmetic of the contract, including
646      * {IERC20-balanceOf} and {IERC20-transfer}.
647      */
648     function decimals() public view virtual override returns (uint8) {
649         return 9;
650     }
651 
652     /**
653      * @dev See {IERC20-totalSupply}.
654      */
655     function totalSupply() external view virtual override returns (uint256) {
656         return _totalSupply;
657     }
658 
659     /**
660      * @dev See {IERC20-allowance}.
661      */
662     function allowance(address owner, address spender)
663         public
664         view
665         virtual
666         override
667         returns (uint256)
668     {
669         return _allowances[owner][spender];
670     }
671 
672     /**
673      * @dev See {IERC20-transfer}.
674      *
675      * Requirements:
676      *
677      * - `to` cannot be the zero address.
678      * - the caller must have a balance of at least `amount`.
679      */
680     function transfer(address to, uint256 amount)
681         external
682         virtual
683         override
684         returns (bool)
685     {
686         address owner = _msgSender();
687         _transfer(owner, to, amount);
688         return true;
689     }
690 
691     /**
692      * @dev See {IERC20-approve}.
693      *
694      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
695      * `transferFrom`. This is semantically equivalent to an infinite approval.
696      *
697      * Requirements:
698      *
699      * - `spender` cannot be the zero address.
700      */
701     function approve(address spender, uint256 amount)
702         external
703         virtual
704         override
705         returns (bool)
706     {
707         address owner = _msgSender();
708         _approve(owner, spender, amount);
709         return true;
710     }
711 
712     /**
713      * @dev See {IERC20-transferFrom}.
714      *
715      * Emits an {Approval} event indicating the updated allowance. This is not
716      * required by the EIP. See the note at the beginning of {ERC20}.
717      *
718      * NOTE: Does not update the allowance if the current allowance
719      * is the maximum `uint256`.
720      *
721      * Requirements:
722      *
723      * - `from` and `to` cannot be the zero address.
724      * - `from` must have a balance of at least `amount`.
725      * - the caller must have allowance for ``from``'s tokens of at least
726      * `amount`.
727      */
728     function transferFrom(
729         address from,
730         address to,
731         uint256 amount
732     ) external virtual override returns (bool) {
733         address spender = _msgSender();
734         _spendAllowance(from, spender, amount);
735         _transfer(from, to, amount);
736         return true;
737     }
738 
739     /**
740      * @dev Atomically decreases the allowance granted to `spender` by the caller.
741      *
742      * This is an alternative to {approve} that can be used as a mitigation for
743      * problems described in {IERC20-approve}.
744      *
745      * Emits an {Approval} event indicating the updated allowance.
746      *
747      * Requirements:
748      *
749      * - `spender` cannot be the zero address.
750      * - `spender` must have allowance for the caller of at least
751      * `subtractedValue`.
752      */
753     function decreaseAllowance(address spender, uint256 subtractedValue)
754         external
755         virtual
756         returns (bool)
757     {
758         address owner = _msgSender();
759         uint256 currentAllowance = allowance(owner, spender);
760         require(
761             currentAllowance >= subtractedValue,
762             "ERC20: decreased allowance below zero"
763         );
764         unchecked {
765             _approve(owner, spender, currentAllowance - subtractedValue);
766         }
767 
768         return true;
769     }
770 
771     /**
772      * @dev Atomically increases the allowance granted to `spender` by the caller.
773      *
774      * This is an alternative to {approve} that can be used as a mitigation for
775      * problems described in {IERC20-approve}.
776      *
777      * Emits an {Approval} event indicating the updated allowance.
778      *
779      * Requirements:
780      *
781      * - `spender` cannot be the zero address.
782      */
783     function increaseAllowance(address spender, uint256 addedValue)
784         external
785         virtual
786         returns (bool)
787     {
788         address owner = _msgSender();
789         _approve(owner, spender, allowance(owner, spender) + addedValue);
790         return true;
791     }
792 
793     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
794      * the total supply.
795      *
796      * Emits a {Transfer} event with `from` set to the zero address.
797      *
798      * Requirements:
799      *
800      * - `account` cannot be the zero address.
801      */
802     function _mint(address account, uint256 amount) internal virtual {
803         require(account != address(0), "ERC20: mint to the zero address");
804 
805         _totalSupply += amount;
806         unchecked {
807             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
808             _balances[account] += amount;
809         }
810         emit Transfer(address(0), account, amount);
811     }
812 
813     /**
814      * @dev Destroys `amount` tokens from `account`, reducing the
815      * total supply.
816      *
817      * Emits a {Transfer} event with `to` set to the zero address.
818      *
819      * Requirements:
820      *
821      * - `account` cannot be the zero address.
822      * - `account` must have at least `amount` tokens.
823      */
824     function _burn(address account, uint256 amount) internal virtual {
825         require(account != address(0), "ERC20: burn from the zero address");
826 
827         uint256 accountBalance = _balances[account];
828         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
829         unchecked {
830             _balances[account] = accountBalance - amount;
831             // Overflow not possible: amount <= accountBalance <= totalSupply.
832             _totalSupply -= amount;
833         }
834 
835         emit Transfer(account, address(0), amount);
836     }
837 
838     /**
839      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
840      *
841      * This internal function is equivalent to `approve`, and can be used to
842      * e.g. set automatic allowances for certain subsystems, etc.
843      *
844      * Emits an {Approval} event.
845      *
846      * Requirements:
847      *
848      * - `owner` cannot be the zero address.
849      * - `spender` cannot be the zero address.
850      */
851     function _approve(
852         address owner,
853         address spender,
854         uint256 amount
855     ) internal virtual {
856         require(owner != address(0), "ERC20: approve from the zero address");
857         require(spender != address(0), "ERC20: approve to the zero address");
858 
859         _allowances[owner][spender] = amount;
860         emit Approval(owner, spender, amount);
861     }
862 
863     /**
864      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
865      *
866      * Does not update the allowance amount in case of infinite allowance.
867      * Revert if not enough allowance is available.
868      *
869      * Might emit an {Approval} event.
870      */
871     function _spendAllowance(
872         address owner,
873         address spender,
874         uint256 amount
875     ) internal virtual {
876         uint256 currentAllowance = allowance(owner, spender);
877         if (currentAllowance != type(uint256).max) {
878             require(
879                 currentAllowance >= amount,
880                 "ERC20: insufficient allowance"
881             );
882             unchecked {
883                 _approve(owner, spender, currentAllowance - amount);
884             }
885         }
886     }
887 
888     function _transfer(
889         address from,
890         address to,
891         uint256 amount
892     ) internal virtual {
893         require(from != address(0), "ERC20: transfer from the zero address");
894         require(to != address(0), "ERC20: transfer to the zero address");
895 
896         uint256 fromBalance = _balances[from];
897         require(
898             fromBalance >= amount,
899             "ERC20: transfer amount exceeds balance"
900         );
901         unchecked {
902             _balances[from] = fromBalance - amount;
903             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
904             // decrementing then incrementing.
905             _balances[to] += amount;
906         }
907 
908         emit Transfer(from, to, amount);
909     }
910 }
911 
912 /**
913  * @dev Implementation of the {IERC20} interface.
914  *
915  * This implementation is agnostic to the way tokens are created. This means
916  * that a supply mechanism has to be added in a derived contract using {_mint}.
917  * For a generic mechanism see {ERC20PresetMinterPauser}.
918  *
919  * TIP: For a detailed writeup see our guide
920  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
921  * to implement supply mechanisms].
922  *
923  * We have followed general OpenZeppelin Contracts guidelines: functions revert
924  * instead returning `false` on failure. This behavior is nonetheless
925  * conventional and does not conflict with the expectations of ERC20
926  * applications.
927  *
928  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
929  * This allows applications to reconstruct the allowance for all accounts just
930  * by listening to said events. Other implementations of the EIP may not emit
931  * these events, as it isn't required by the specification.
932  *
933  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
934  * functions have been added to mitigate the well-known issues around setting
935  * allowances. See {IERC20-approve}.
936  */
937  contract Tyrant is ERC20, Ownable {
938     // TOKENOMICS START ==========================================================>
939     string private _name = "Fable Of The Dragon";
940     string private _symbol = "TYRANT";
941     uint8 private _decimals = 9;
942     uint256 private _supply = 10000000;
943     uint256 public taxForLiquidity = 0;
944     uint256 public taxForMarketing = 25;
945     uint256 public maxTxAmount = 100000 * 10**_decimals;
946     uint256 public maxWalletAmount = 100000 * 10**_decimals;
947     address public marketingWallet = 0x6BD72A62bd476BC7113010CB939EE39fA80D6a19;
948     // TOKENOMICS END ============================================================>
949 
950     IUniswapV2Router02 public immutable uniswapV2Router;
951     address public immutable uniswapV2Pair;
952 
953     uint256 private _marketingReserves = 0;
954     mapping(address => bool) private _isExcludedFromFee;
955     uint256 private _numTokensSellToAddToLiquidity = 5000 * 10**_decimals;
956     uint256 private _numTokensSellToAddToETH = 2000 * 10**_decimals;
957     bool inSwapAndLiquify;
958 
959     event SwapAndLiquify(
960         uint256 tokensSwapped,
961         uint256 ethReceived,
962         uint256 tokensIntoLiqudity
963     );
964 
965     modifier lockTheSwap() {
966         inSwapAndLiquify = true;
967         _;
968         inSwapAndLiquify = false;
969     }
970 
971     /**
972      * @dev Sets the values for {name} and {symbol}.
973      *
974      * The default value of {decimals} is 18. To select a different value for
975      * {decimals} you should overload it.
976      *
977      * All two of these values are immutable: they can only be set once during
978      * construction.
979      */
980     constructor() ERC20(_name, _symbol) {
981         _mint(msg.sender, (_supply * 10**_decimals));
982 
983         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
984         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
985 
986         uniswapV2Router = _uniswapV2Router;
987 
988         _isExcludedFromFee[address(uniswapV2Router)] = true;
989         _isExcludedFromFee[msg.sender] = true;
990         _isExcludedFromFee[marketingWallet] = true;
991     }
992 
993     /**
994      * @dev Moves `amount` of tokens from `from` to `to`.
995      *
996      * This internal function is equivalent to {transfer}, and can be used to
997      * e.g. implement automatic token fees, slashing mechanisms, etc.
998      *
999      * Emits a {Transfer} event.
1000      *
1001      * Requirements:
1002      *
1003      *
1004      * - `from` cannot be the zero address.
1005      * - `to` cannot be the zero address.
1006      * - `from` must have a balance of at least `amount`.
1007      */
1008     function _transfer(address from, address to, uint256 amount) internal override {
1009         require(from != address(0), "ERC20: transfer from the zero address");
1010         require(to != address(0), "ERC20: transfer to the zero address");
1011         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1012 
1013         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1014             if (from != uniswapV2Pair) {
1015                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1016                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1017                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1018                 }
1019                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1020                     _swapTokensForEth(_numTokensSellToAddToETH);
1021                     _marketingReserves -= _numTokensSellToAddToETH;
1022                     bool sent = payable(marketingWallet).send(address(this).balance);
1023                     require(sent, "Failed to send ETH");
1024                 }
1025             }
1026 
1027             uint256 transferAmount;
1028             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1029                 transferAmount = amount;
1030             } 
1031             else {
1032                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1033                 if(from == uniswapV2Pair){
1034                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1035                 }
1036 
1037                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1038                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1039                 transferAmount = amount - (marketingShare + liquidityShare);
1040                 _marketingReserves += marketingShare;
1041 
1042                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1043             }
1044             super._transfer(from, to, transferAmount);
1045         } 
1046         else {
1047             super._transfer(from, to, amount);
1048         }
1049     }
1050 
1051     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1052         uint256 half = (contractTokenBalance / 2);
1053         uint256 otherHalf = (contractTokenBalance - half);
1054 
1055         uint256 initialBalance = address(this).balance;
1056 
1057         _swapTokensForEth(half);
1058 
1059         uint256 newBalance = (address(this).balance - initialBalance);
1060 
1061         _addLiquidity(otherHalf, newBalance);
1062 
1063         emit SwapAndLiquify(half, newBalance, otherHalf);
1064     }
1065 
1066     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1067         address[] memory path = new address[](2);
1068         path[0] = address(this);
1069         path[1] = uniswapV2Router.WETH();
1070 
1071         _approve(address(this), address(uniswapV2Router), tokenAmount);
1072 
1073         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1074             tokenAmount,
1075             0,
1076             path,
1077             address(this),
1078             (block.timestamp + 300)
1079         );
1080     }
1081 
1082     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1083         private
1084         lockTheSwap
1085     {
1086         _approve(address(this), address(uniswapV2Router), tokenAmount);
1087 
1088         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1089             address(this),
1090             tokenAmount,
1091             0,
1092             0,
1093             owner(),
1094             block.timestamp
1095         );
1096     }
1097 
1098     function changeMarketingWallet(address newWallet)
1099         public
1100         onlyOwner
1101         returns (bool)
1102     {
1103         marketingWallet = newWallet;
1104         return true;
1105     }
1106 
1107     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1108         public
1109         onlyOwner
1110         returns (bool)
1111     {
1112         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1113         taxForLiquidity = _taxForLiquidity;
1114         taxForMarketing = _taxForMarketing;
1115 
1116         return true;
1117     }
1118 
1119     function changeMaxTxAmount(uint256 _maxTxAmount)
1120         public
1121         onlyOwner
1122         returns (bool)
1123     {
1124         maxTxAmount = _maxTxAmount;
1125 
1126         return true;
1127     }
1128 
1129     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1130         public
1131         onlyOwner
1132         returns (bool)
1133     {
1134         maxWalletAmount = _maxWalletAmount;
1135 
1136         return true;
1137     }
1138 
1139     receive() external payable {}
1140 }