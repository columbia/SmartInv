1 /**
2 
3 Just google "EGGS price" and find out. EGGS TO 100$! 
4 
5 https://t.me/EggsERC
6 https://twitter.com/EggsERC
7 
8 
9 */
10 
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.16;
15 
16 interface IUniswapV2Factory {
17     event PairCreated(
18         address indexed token0,
19         address indexed token1,
20         address pair,
21         uint256
22     );
23 
24     function feeTo() external view returns (address);
25 
26     function feeToSetter() external view returns (address);
27 
28     function allPairsLength() external view returns (uint256);
29 
30     function getPair(address tokenA, address tokenB)
31         external
32         view
33         returns (address pair);
34 
35     function allPairs(uint256) external view returns (address pair);
36 
37     function createPair(address tokenA, address tokenB)
38         external
39         returns (address pair);
40 
41     function setFeeTo(address) external;
42 
43     function setFeeToSetter(address) external;
44 }
45 
46 interface IUniswapV2Pair {
47     event Approval(
48         address indexed owner,
49         address indexed spender,
50         uint256 value
51     );
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     function name() external pure returns (string memory);
55 
56     function symbol() external pure returns (string memory);
57 
58     function decimals() external pure returns (uint8);
59 
60     function totalSupply() external view returns (uint256);
61 
62     function balanceOf(address owner) external view returns (uint256);
63 
64     function allowance(address owner, address spender)
65         external
66         view
67         returns (uint256);
68 
69     function approve(address spender, uint256 value) external returns (bool);
70 
71     function transfer(address to, uint256 value) external returns (bool);
72 
73     function transferFrom(
74         address from,
75         address to,
76         uint256 value
77     ) external returns (bool);
78 
79     function DOMAIN_SEPARATOR() external view returns (bytes32);
80 
81     function PERMIT_TYPEHASH() external pure returns (bytes32);
82 
83     function nonces(address owner) external view returns (uint256);
84 
85     function permit(
86         address owner,
87         address spender,
88         uint256 value,
89         uint256 deadline,
90         uint8 v,
91         bytes32 r,
92         bytes32 s
93     ) external;
94 
95     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
96     event Burn(
97         address indexed sender,
98         uint256 amount0,
99         uint256 amount1,
100         address indexed to
101     );
102     event Swap(
103         address indexed sender,
104         uint256 amount0In,
105         uint256 amount1In,
106         uint256 amount0Out,
107         uint256 amount1Out,
108         address indexed to
109     );
110     event Sync(uint112 reserve0, uint112 reserve1);
111 
112     function MINIMUM_LIQUIDITY() external pure returns (uint256);
113 
114     function factory() external view returns (address);
115 
116     function token0() external view returns (address);
117 
118     function token1() external view returns (address);
119 
120     function getReserves()
121         external
122         view
123         returns (
124             uint112 reserve0,
125             uint112 reserve1,
126             uint32 blockTimestampLast
127         );
128 
129     function price0CumulativeLast() external view returns (uint256);
130 
131     function price1CumulativeLast() external view returns (uint256);
132 
133     function kLast() external view returns (uint256);
134 
135     function mint(address to) external returns (uint256 liquidity);
136 
137     function burn(address to)
138         external
139         returns (uint256 amount0, uint256 amount1);
140 
141     function swap(
142         uint256 amount0Out,
143         uint256 amount1Out,
144         address to,
145         bytes calldata data
146     ) external;
147 
148     function skim(address to) external;
149 
150     function sync() external;
151 
152     function initialize(address, address) external;
153 }
154 
155 interface IUniswapV2Router01 {
156     function factory() external pure returns (address);
157 
158     function WETH() external pure returns (address);
159 
160     function addLiquidity(
161         address tokenA,
162         address tokenB,
163         uint256 amountADesired,
164         uint256 amountBDesired,
165         uint256 amountAMin,
166         uint256 amountBMin,
167         address to,
168         uint256 deadline
169     )
170         external
171         returns (
172             uint256 amountA,
173             uint256 amountB,
174             uint256 liquidity
175         );
176 
177     function addLiquidityETH(
178         address token,
179         uint256 amountTokenDesired,
180         uint256 amountTokenMin,
181         uint256 amountETHMin,
182         address to,
183         uint256 deadline
184     )
185         external
186         payable
187         returns (
188             uint256 amountToken,
189             uint256 amountETH,
190             uint256 liquidity
191         );
192 
193     function removeLiquidity(
194         address tokenA,
195         address tokenB,
196         uint256 liquidity,
197         uint256 amountAMin,
198         uint256 amountBMin,
199         address to,
200         uint256 deadline
201     ) external returns (uint256 amountA, uint256 amountB);
202 
203     function removeLiquidityETH(
204         address token,
205         uint256 liquidity,
206         uint256 amountTokenMin,
207         uint256 amountETHMin,
208         address to,
209         uint256 deadline
210     ) external returns (uint256 amountToken, uint256 amountETH);
211 
212     function removeLiquidityWithPermit(
213         address tokenA,
214         address tokenB,
215         uint256 liquidity,
216         uint256 amountAMin,
217         uint256 amountBMin,
218         address to,
219         uint256 deadline,
220         bool approveMax,
221         uint8 v,
222         bytes32 r,
223         bytes32 s
224     ) external returns (uint256 amountA, uint256 amountB);
225 
226     function removeLiquidityETHWithPermit(
227         address token,
228         uint256 liquidity,
229         uint256 amountTokenMin,
230         uint256 amountETHMin,
231         address to,
232         uint256 deadline,
233         bool approveMax,
234         uint8 v,
235         bytes32 r,
236         bytes32 s
237     ) external returns (uint256 amountToken, uint256 amountETH);
238 
239     function swapExactTokensForTokens(
240         uint256 amountIn,
241         uint256 amountOutMin,
242         address[] calldata path,
243         address to,
244         uint256 deadline
245     ) external returns (uint256[] memory amounts);
246 
247     function swapTokensForExactTokens(
248         uint256 amountOut,
249         uint256 amountInMax,
250         address[] calldata path,
251         address to,
252         uint256 deadline
253     ) external returns (uint256[] memory amounts);
254 
255     function swapExactETHForTokens(
256         uint256 amountOutMin,
257         address[] calldata path,
258         address to,
259         uint256 deadline
260     ) external payable returns (uint256[] memory amounts);
261 
262     function swapTokensForExactETH(
263         uint256 amountOut,
264         uint256 amountInMax,
265         address[] calldata path,
266         address to,
267         uint256 deadline
268     ) external returns (uint256[] memory amounts);
269 
270     function swapExactTokensForETH(
271         uint256 amountIn,
272         uint256 amountOutMin,
273         address[] calldata path,
274         address to,
275         uint256 deadline
276     ) external returns (uint256[] memory amounts);
277 
278     function swapETHForExactTokens(
279         uint256 amountOut,
280         address[] calldata path,
281         address to,
282         uint256 deadline
283     ) external payable returns (uint256[] memory amounts);
284 
285     function quote(
286         uint256 amountA,
287         uint256 reserveA,
288         uint256 reserveB
289     ) external pure returns (uint256 amountB);
290 
291     function getAmountOut(
292         uint256 amountIn,
293         uint256 reserveIn,
294         uint256 reserveOut
295     ) external pure returns (uint256 amountOut);
296 
297     function getAmountIn(
298         uint256 amountOut,
299         uint256 reserveIn,
300         uint256 reserveOut
301     ) external pure returns (uint256 amountIn);
302 
303     function getAmountsOut(uint256 amountIn, address[] calldata path)
304         external
305         view
306         returns (uint256[] memory amounts);
307 
308     function getAmountsIn(uint256 amountOut, address[] calldata path)
309         external
310         view
311         returns (uint256[] memory amounts);
312 }
313 
314 interface IUniswapV2Router02 is IUniswapV2Router01 {
315     function removeLiquidityETHSupportingFeeOnTransferTokens(
316         address token,
317         uint256 liquidity,
318         uint256 amountTokenMin,
319         uint256 amountETHMin,
320         address to,
321         uint256 deadline
322     ) external returns (uint256 amountETH);
323 
324     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
325         address token,
326         uint256 liquidity,
327         uint256 amountTokenMin,
328         uint256 amountETHMin,
329         address to,
330         uint256 deadline,
331         bool approveMax,
332         uint8 v,
333         bytes32 r,
334         bytes32 s
335     ) external returns (uint256 amountETH);
336 
337     function swapExactETHForTokensSupportingFeeOnTransferTokens(
338         uint256 amountOutMin,
339         address[] calldata path,
340         address to,
341         uint256 deadline
342     ) external payable;
343 
344     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
345         uint256 amountIn,
346         uint256 amountOutMin,
347         address[] calldata path,
348         address to,
349         uint256 deadline
350     ) external;
351 
352     function swapExactTokensForETHSupportingFeeOnTransferTokens(
353         uint256 amountIn,
354         uint256 amountOutMin,
355         address[] calldata path,
356         address to,
357         uint256 deadline
358     ) external;
359 }
360 
361 /**
362  * @dev Interface of the ERC20 standard as defined in the EIP.
363  */
364 interface IERC20 {
365     /**
366      * @dev Emitted when `value` tokens are moved from one account (`from`) to
367      * another (`to`).
368      *
369      * Note that `value` may be zero.
370      */
371     event Transfer(address indexed from, address indexed to, uint256 value);
372 
373     /**
374      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
375      * a call to {approve}. `value` is the new allowance.
376      */
377     event Approval(
378         address indexed owner,
379         address indexed spender,
380         uint256 value
381     );
382 
383     /**
384      * @dev Returns the amount of tokens in existence.
385      */
386     function totalSupply() external view returns (uint256);
387 
388     /**
389      * @dev Returns the amount of tokens owned by `account`.
390      */
391     function balanceOf(address account) external view returns (uint256);
392 
393     /**
394      * @dev Moves `amount` tokens from the caller's account to `to`.
395      *
396      * Returns a boolean value indicating whether the operation succeeded.
397      *
398      * Emits a {Transfer} event.
399      */
400     function transfer(address to, uint256 amount) external returns (bool);
401 
402     /**
403      * @dev Returns the remaining number of tokens that `spender` will be
404      * allowed to spend on behalf of `owner` through {transferFrom}. This is
405      * zero by default.
406      *
407      * This value changes when {approve} or {transferFrom} are called.
408      */
409     function allowance(address owner, address spender)
410         external
411         view
412         returns (uint256);
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * IMPORTANT: Beware that changing an allowance with this method brings the risk
420      * that someone may use both the old and the new allowance by unfortunate
421      * transaction ordering. One possible solution to mitigate this race
422      * condition is to first reduce the spender's allowance to 0 and set the
423      * desired value afterwards:
424      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
425      *
426      * Emits an {Approval} event.
427      */
428     function approve(address spender, uint256 amount) external returns (bool);
429 
430     /**
431      * @dev Moves `amount` tokens from `from` to `to` using the
432      * allowance mechanism. `amount` is then deducted from the caller's
433      * allowance.
434      *
435      * Returns a boolean value indicating whether the operation succeeded.
436      *
437      * Emits a {Transfer} event.
438      */
439     function transferFrom(
440         address from,
441         address to,
442         uint256 amount
443     ) external returns (bool);
444 }
445 
446 /**
447  * @dev Interface for the optional metadata functions from the ERC20 standard.
448  *
449  * _Available since v4.1._
450  */
451 interface IERC20Metadata is IERC20 {
452     /**
453      * @dev Returns the name of the token.
454      */
455     function name() external view returns (string memory);
456 
457     /**
458      * @dev Returns the decimals places of the token.
459      */
460     function decimals() external view returns (uint8);
461 
462     /**
463      * @dev Returns the symbol of the token.
464      */
465     function symbol() external view returns (string memory);
466 }
467 
468 /**
469  * @dev Provides information about the current execution context, including the
470  * sender of the transaction and its data. While these are generally available
471  * via msg.sender and msg.data, they should not be accessed in such a direct
472  * manner, since when dealing with meta-transactions the account sending and
473  * paying for execution may not be the actual sender (as far as an application
474  * is concerned).
475  *
476  * This contract is only required for intermediate, library-like contracts.
477  */
478 abstract contract Context {
479     function _msgSender() internal view virtual returns (address) {
480         return msg.sender;
481     }
482 }
483 
484 /**
485  * @dev Contract module which provides a basic access control mechanism, where
486  * there is an account (an owner) that can be granted exclusive access to
487  * specific functions.
488  *
489  * By default, the owner account will be the one that deploys the contract. This
490  * can later be changed with {transferOwnership}.
491  *
492  * This module is used through inheritance. It will make available the modifier
493  * `onlyOwner`, which can be applied to your functions to restrict their use to
494  * the owner.
495  */
496 abstract contract Ownable is Context {
497     address private _owner;
498 
499     event OwnershipTransferred(
500         address indexed previousOwner,
501         address indexed newOwner
502     );
503 
504     /**
505      * @dev Initializes the contract setting the deployer as the initial owner.
506      */
507     constructor() {
508         _transferOwnership(_msgSender());
509     }
510 
511     /**
512      * @dev Throws if called by any account other than the owner.
513      */
514     modifier onlyOwner() {
515         _checkOwner();
516         _;
517     }
518 
519     /**
520      * @dev Returns the address of the current owner.
521      */
522     function owner() public view virtual returns (address) {
523         return _owner;
524     }
525 
526     /**
527      * @dev Throws if the sender is not the owner.
528      */
529     function _checkOwner() internal view virtual {
530         require(owner() == _msgSender(), "Ownable: caller is not the owner");
531     }
532 
533     /**
534      * @dev Leaves the contract without owner. It will not be possible to call
535      * `onlyOwner` functions anymore. Can only be called by the current owner.
536      *
537      * NOTE: Renouncing ownership will leave the contract without an owner,
538      * thereby removing any functionality that is only available to the owner.
539      */
540     function renounceOwnership() public virtual onlyOwner {
541         _transferOwnership(address(0));
542     }
543 
544     /**
545      * @dev Transfers ownership of the contract to a new account (`newOwner`).
546      * Can only be called by the current owner.
547      */
548     function transferOwnership(address newOwner) public virtual onlyOwner {
549         require(
550             newOwner != address(0),
551             "Ownable: new owner is the zero address"
552         );
553         _transferOwnership(newOwner);
554     }
555 
556     /**
557      * @dev Transfers ownership of the contract to a new account (`newOwner`).
558      * Internal function without access restriction.
559      */
560     function _transferOwnership(address newOwner) internal virtual {
561         address oldOwner = _owner;
562         _owner = newOwner;
563         emit OwnershipTransferred(oldOwner, newOwner);
564     }
565 }
566 
567 /**
568  * @dev Implementation of the {IERC20} interface.
569  *
570  * This implementation is agnostic to the way tokens are created. This means
571  * that a supply mechanism has to be added in a derived contract using {_mint}.
572  * For a generic mechanism see {ERC20PresetMinterPauser}.
573  *
574  * TIP: For a detailed writeup see our guide
575  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
576  * to implement supply mechanisms].
577  *
578  * We have followed general OpenZeppelin Contracts guidelines: functions revert
579  * instead returning `false` on failure. This behavior is nonetheless
580  * conventional and does not conflict with the expectations of ERC20
581  * applications.
582  *
583  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
584  * This allows applications to reconstruct the allowance for all accounts just
585  * by listening to said events. Other implementations of the EIP may not emit
586  * these events, as it isn't required by the specification.
587  *
588  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
589  * functions have been added to mitigate the well-known issues around setting
590  * allowances. See {IERC20-approve}.
591  */
592 contract ERC20 is Context, IERC20, IERC20Metadata {
593     mapping(address => uint256) private _balances;
594     mapping(address => mapping(address => uint256)) private _allowances;
595 
596     uint256 private _totalSupply;
597 
598     string private _name;
599     string private _symbol;
600 
601     constructor(string memory name_, string memory symbol_) {
602         _name = name_;
603         _symbol = symbol_;
604     }
605 
606     /**
607      * @dev Returns the symbol of the token, usually a shorter version of the
608      * name.
609      */
610     function symbol() external view virtual override returns (string memory) {
611         return _symbol;
612     }
613 
614     /**
615      * @dev Returns the name of the token.
616      */
617     function name() external view virtual override returns (string memory) {
618         return _name;
619     }
620 
621     /**
622      * @dev See {IERC20-balanceOf}.
623      */
624     function balanceOf(address account)
625         public
626         view
627         virtual
628         override
629         returns (uint256)
630     {
631         return _balances[account];
632     }
633 
634     /**
635      * @dev Returns the number of decimals used to get its user representation.
636      * For example, if `decimals` equals `2`, a balance of `505` tokens should
637      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
638      *
639      * Tokens usually opt for a value of 18, imitating the relationship between
640      * Ether and Wei. This is the value {ERC20} uses, unless this function is
641      * overridden;
642      *
643      * NOTE: This information is only used for _display_ purposes: it in
644      * no way affects any of the arithmetic of the contract, including
645      * {IERC20-balanceOf} and {IERC20-transfer}.
646      */
647     function decimals() public view virtual override returns (uint8) {
648         return 9;
649     }
650 
651     /**
652      * @dev See {IERC20-totalSupply}.
653      */
654     function totalSupply() external view virtual override returns (uint256) {
655         return _totalSupply;
656     }
657 
658     /**
659      * @dev See {IERC20-allowance}.
660      */
661     function allowance(address owner, address spender)
662         public
663         view
664         virtual
665         override
666         returns (uint256)
667     {
668         return _allowances[owner][spender];
669     }
670 
671     /**
672      * @dev See {IERC20-transfer}.
673      *
674      * Requirements:
675      *
676      * - `to` cannot be the zero address.
677      * - the caller must have a balance of at least `amount`.
678      */
679     function transfer(address to, uint256 amount)
680         external
681         virtual
682         override
683         returns (bool)
684     {
685         address owner = _msgSender();
686         _transfer(owner, to, amount);
687         return true;
688     }
689 
690     /**
691      * @dev See {IERC20-approve}.
692      *
693      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
694      * `transferFrom`. This is semantically equivalent to an infinite approval.
695      *
696      * Requirements:
697      *
698      * - `spender` cannot be the zero address.
699      */
700     function approve(address spender, uint256 amount)
701         external
702         virtual
703         override
704         returns (bool)
705     {
706         address owner = _msgSender();
707         _approve(owner, spender, amount);
708         return true;
709     }
710 
711     /**
712      * @dev See {IERC20-transferFrom}.
713      *
714      * Emits an {Approval} event indicating the updated allowance. This is not
715      * required by the EIP. See the note at the beginning of {ERC20}.
716      *
717      * NOTE: Does not update the allowance if the current allowance
718      * is the maximum `uint256`.
719      *
720      * Requirements:
721      *
722      * - `from` and `to` cannot be the zero address.
723      * - `from` must have a balance of at least `amount`.
724      * - the caller must have allowance for ``from``'s tokens of at least
725      * `amount`.
726      */
727     function transferFrom(
728         address from,
729         address to,
730         uint256 amount
731     ) external virtual override returns (bool) {
732         address spender = _msgSender();
733         _spendAllowance(from, spender, amount);
734         _transfer(from, to, amount);
735         return true;
736     }
737 
738     /**
739      * @dev Atomically decreases the allowance granted to `spender` by the caller.
740      *
741      * This is an alternative to {approve} that can be used as a mitigation for
742      * problems described in {IERC20-approve}.
743      *
744      * Emits an {Approval} event indicating the updated allowance.
745      *
746      * Requirements:
747      *
748      * - `spender` cannot be the zero address.
749      * - `spender` must have allowance for the caller of at least
750      * `subtractedValue`.
751      */
752     function decreaseAllowance(address spender, uint256 subtractedValue)
753         external
754         virtual
755         returns (bool)
756     {
757         address owner = _msgSender();
758         uint256 currentAllowance = allowance(owner, spender);
759         require(
760             currentAllowance >= subtractedValue,
761             "ERC20: decreased allowance below zero"
762         );
763         unchecked {
764             _approve(owner, spender, currentAllowance - subtractedValue);
765         }
766 
767         return true;
768     }
769 
770     /**
771      * @dev Atomically increases the allowance granted to `spender` by the caller.
772      *
773      * This is an alternative to {approve} that can be used as a mitigation for
774      * problems described in {IERC20-approve}.
775      *
776      * Emits an {Approval} event indicating the updated allowance.
777      *
778      * Requirements:
779      *
780      * - `spender` cannot be the zero address.
781      */
782     function increaseAllowance(address spender, uint256 addedValue)
783         external
784         virtual
785         returns (bool)
786     {
787         address owner = _msgSender();
788         _approve(owner, spender, allowance(owner, spender) + addedValue);
789         return true;
790     }
791 
792     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
793      * the total supply.
794      *
795      * Emits a {Transfer} event with `from` set to the zero address.
796      *
797      * Requirements:
798      *
799      * - `account` cannot be the zero address.
800      */
801     function _mint(address account, uint256 amount) internal virtual {
802         require(account != address(0), "ERC20: mint to the zero address");
803 
804         _totalSupply += amount;
805         unchecked {
806             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
807             _balances[account] += amount;
808         }
809         emit Transfer(address(0), account, amount);
810     }
811 
812     /**
813      * @dev Destroys `amount` tokens from `account`, reducing the
814      * total supply.
815      *
816      * Emits a {Transfer} event with `to` set to the zero address.
817      *
818      * Requirements:
819      *
820      * - `account` cannot be the zero address.
821      * - `account` must have at least `amount` tokens.
822      */
823     function _burn(address account, uint256 amount) internal virtual {
824         require(account != address(0), "ERC20: burn from the zero address");
825 
826         uint256 accountBalance = _balances[account];
827         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
828         unchecked {
829             _balances[account] = accountBalance - amount;
830             // Overflow not possible: amount <= accountBalance <= totalSupply.
831             _totalSupply -= amount;
832         }
833 
834         emit Transfer(account, address(0), amount);
835     }
836 
837     /**
838      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
839      *
840      * This internal function is equivalent to `approve`, and can be used to
841      * e.g. set automatic allowances for certain subsystems, etc.
842      *
843      * Emits an {Approval} event.
844      *
845      * Requirements:
846      *
847      * - `owner` cannot be the zero address.
848      * - `spender` cannot be the zero address.
849      */
850     function _approve(
851         address owner,
852         address spender,
853         uint256 amount
854     ) internal virtual {
855         require(owner != address(0), "ERC20: approve from the zero address");
856         require(spender != address(0), "ERC20: approve to the zero address");
857 
858         _allowances[owner][spender] = amount;
859         emit Approval(owner, spender, amount);
860     }
861 
862     /**
863      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
864      *
865      * Does not update the allowance amount in case of infinite allowance.
866      * Revert if not enough allowance is available.
867      *
868      * Might emit an {Approval} event.
869      */
870     function _spendAllowance(
871         address owner,
872         address spender,
873         uint256 amount
874     ) internal virtual {
875         uint256 currentAllowance = allowance(owner, spender);
876         if (currentAllowance != type(uint256).max) {
877             require(
878                 currentAllowance >= amount,
879                 "ERC20: insufficient allowance"
880             );
881             unchecked {
882                 _approve(owner, spender, currentAllowance - amount);
883             }
884         }
885     }
886 
887     function _transfer(
888         address from,
889         address to,
890         uint256 amount
891     ) internal virtual {
892         require(from != address(0), "ERC20: transfer from the zero address");
893         require(to != address(0), "ERC20: transfer to the zero address");
894 
895         uint256 fromBalance = _balances[from];
896         require(
897             fromBalance >= amount,
898             "ERC20: transfer amount exceeds balance"
899         );
900         unchecked {
901             _balances[from] = fromBalance - amount;
902             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
903             // decrementing then incrementing.
904             _balances[to] += amount;
905         }
906 
907         emit Transfer(from, to, amount);
908     }
909 }
910 
911 /**
912  * @dev Implementation of the {IERC20} interface.
913  *
914  * This implementation is agnostic to the way tokens are created. This means
915  * that a supply mechanism has to be added in a derived contract using {_mint}.
916  * For a generic mechanism see {ERC20PresetMinterPauser}.
917  *
918  * TIP: For a detailed writeup see our guide
919  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
920  * to implement supply mechanisms].
921  *
922  * We have followed general OpenZeppelin Contracts guidelines: functions revert
923  * instead returning `false` on failure. This behavior is nonetheless
924  * conventional and does not conflict with the expectations of ERC20
925  * applications.
926  *
927  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
928  * This allows applications to reconstruct the allowance for all accounts just
929  * by listening to said events. Other implementations of the EIP may not emit
930  * these events, as it isn't required by the specification.
931  *
932  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
933  * functions have been added to mitigate the well-known issues around setting
934  * allowances. See {IERC20-approve}.
935  */
936  contract EGGS is ERC20, Ownable {
937     // TOKENOMICS START ==========================================================>
938     string private _name = "Eggs";
939     string private _symbol = "EGGS";
940     uint8 private _decimals = 9;
941     uint256 private _supply = 100000;
942     uint256 public taxForLiquidity = 0;
943     uint256 public taxForMarketing = 15;
944     uint256 public maxTxAmount = 1250 * 10**_decimals;
945     uint256 public maxWalletAmount = 1250 * 10**_decimals;
946     address public marketingWallet = 0x591a7A07FeDBcE2aBFe681D9238dC030957Ef612;
947     // TOKENOMICS END ============================================================>
948 
949     IUniswapV2Router02 public immutable uniswapV2Router;
950     address public immutable uniswapV2Pair;
951 
952     uint256 private _marketingReserves = 0;
953     mapping(address => bool) private _isExcludedFromFee;
954     uint256 private _numTokensSellToAddToLiquidity = 200 * 10**_decimals;
955     uint256 private _numTokensSellToAddToETH = 200 * 10**_decimals;
956     bool inSwapAndLiquify;
957 
958     event SwapAndLiquify(
959         uint256 tokensSwapped,
960         uint256 ethReceived,
961         uint256 tokensIntoLiqudity
962     );
963 
964     modifier lockTheSwap() {
965         inSwapAndLiquify = true;
966         _;
967         inSwapAndLiquify = false;
968     }
969 
970     /**
971      * @dev Sets the values for {name} and {symbol}.
972      *
973      * The default value of {decimals} is 18. To select a different value for
974      * {decimals} you should overload it.
975      *
976      * All two of these values are immutable: they can only be set once during
977      * construction.
978      */
979     constructor() ERC20(_name, _symbol) {
980         _mint(msg.sender, (_supply * 10**_decimals));
981 
982         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
983         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
984 
985         uniswapV2Router = _uniswapV2Router;
986 
987         _isExcludedFromFee[address(uniswapV2Router)] = true;
988         _isExcludedFromFee[msg.sender] = true;
989         _isExcludedFromFee[marketingWallet] = true;
990     }
991 
992     /**
993      * @dev Moves `amount` of tokens from `from` to `to`.
994      *
995      * This internal function is equivalent to {transfer}, and can be used to
996      * e.g. implement automatic token fees, slashing mechanisms, etc.
997      *
998      * Emits a {Transfer} event.
999      *
1000      * Requirements:
1001      *
1002      *
1003      * - `from` cannot be the zero address.
1004      * - `to` cannot be the zero address.
1005      * - `from` must have a balance of at least `amount`.
1006      */
1007     function _transfer(address from, address to, uint256 amount) internal override {
1008         require(from != address(0), "ERC20: transfer from the zero address");
1009         require(to != address(0), "ERC20: transfer to the zero address");
1010         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
1011 
1012         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
1013             if (from != uniswapV2Pair) {
1014                 uint256 contractLiquidityBalance = balanceOf(address(this)) - _marketingReserves;
1015                 if (contractLiquidityBalance >= _numTokensSellToAddToLiquidity) {
1016                     _swapAndLiquify(_numTokensSellToAddToLiquidity);
1017                 }
1018                 if ((_marketingReserves) >= _numTokensSellToAddToETH) {
1019                     _swapTokensForEth(_numTokensSellToAddToETH);
1020                     _marketingReserves -= _numTokensSellToAddToETH;
1021                     bool sent = payable(marketingWallet).send(address(this).balance);
1022                     require(sent, "Failed to send ETH");
1023                 }
1024             }
1025 
1026             uint256 transferAmount;
1027             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1028                 transferAmount = amount;
1029             } 
1030             else {
1031                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
1032                 if(from == uniswapV2Pair){
1033                     require((amount + balanceOf(to)) <= maxWalletAmount, "ERC20: balance amount exceeded max wallet amount limit");
1034                 }
1035 
1036                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1037                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1038                 transferAmount = amount - (marketingShare + liquidityShare);
1039                 _marketingReserves += marketingShare;
1040 
1041                 super._transfer(from, address(this), (marketingShare + liquidityShare));
1042             }
1043             super._transfer(from, to, transferAmount);
1044         } 
1045         else {
1046             super._transfer(from, to, amount);
1047         }
1048     }
1049 
1050     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1051         uint256 half = (contractTokenBalance / 2);
1052         uint256 otherHalf = (contractTokenBalance - half);
1053 
1054         uint256 initialBalance = address(this).balance;
1055 
1056         _swapTokensForEth(half);
1057 
1058         uint256 newBalance = (address(this).balance - initialBalance);
1059 
1060         _addLiquidity(otherHalf, newBalance);
1061 
1062         emit SwapAndLiquify(half, newBalance, otherHalf);
1063     }
1064 
1065     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1066         address[] memory path = new address[](2);
1067         path[0] = address(this);
1068         path[1] = uniswapV2Router.WETH();
1069 
1070         _approve(address(this), address(uniswapV2Router), tokenAmount);
1071 
1072         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1073             tokenAmount,
1074             0,
1075             path,
1076             address(this),
1077             (block.timestamp + 300)
1078         );
1079     }
1080 
1081     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1082         private
1083         lockTheSwap
1084     {
1085         _approve(address(this), address(uniswapV2Router), tokenAmount);
1086 
1087         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1088             address(this),
1089             tokenAmount,
1090             0,
1091             0,
1092             owner(),
1093             block.timestamp
1094         );
1095     }
1096 
1097     function changeMarketingWallet(address newWallet)
1098         public
1099         onlyOwner
1100         returns (bool)
1101     {
1102         marketingWallet = newWallet;
1103         return true;
1104     }
1105 
1106     function changeTaxForLiquidityAndMarketing(uint256 _taxForLiquidity, uint256 _taxForMarketing)
1107         public
1108         onlyOwner
1109         returns (bool)
1110     {
1111         require((_taxForLiquidity+_taxForMarketing) <= 100, "ERC20: total tax must not be greater than 100");
1112         taxForLiquidity = _taxForLiquidity;
1113         taxForMarketing = _taxForMarketing;
1114 
1115         return true;
1116     }
1117 
1118     function changeMaxTxAmount(uint256 _maxTxAmount)
1119         public
1120         onlyOwner
1121         returns (bool)
1122     {
1123         maxTxAmount = _maxTxAmount;
1124 
1125         return true;
1126     }
1127 
1128     function changeMaxWalletAmount(uint256 _maxWalletAmount)
1129         public
1130         onlyOwner
1131         returns (bool)
1132     {
1133         maxWalletAmount = _maxWalletAmount;
1134 
1135         return true;
1136     }
1137 
1138     receive() external payable {}
1139 }