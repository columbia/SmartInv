1 /*
2                                                                     
3 Website: https://mebot.io/
4 Documents: https://docs.mebot.io/
5 Telegram Channel: https://t.me/MeBotNews
6 Telegram Group: https://t.me/MeBotChat
7 Twitter: https://twitter.com/MeBotEth
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.19;
14 
15 interface IUniswapV2Factory {
16     event PairCreated(
17         address indexed token0,
18         address indexed token1,
19         address pair,
20         uint256
21     );
22 
23     function feeTo() external view returns (address);
24 
25     function feeToSetter() external view returns (address);
26 
27     function allPairsLength() external view returns (uint256);
28 
29     function getPair(address tokenA, address tokenB)
30         external
31         view
32         returns (address pair);
33 
34     function allPairs(uint256) external view returns (address pair);
35 
36     function createPair(address tokenA, address tokenB)
37         external
38         returns (address pair);
39 
40     function setFeeTo(address) external;
41 
42     function setFeeToSetter(address) external;
43 }
44 
45 interface IUniswapV2Pair {
46     event Approval(
47         address indexed owner,
48         address indexed spender,
49         uint256 value
50     );
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     function name() external pure returns (string memory);
54 
55     function symbol() external pure returns (string memory);
56 
57     function decimals() external pure returns (uint8);
58 
59     function totalSupply() external view returns (uint256);
60 
61     function balanceOf(address owner) external view returns (uint256);
62 
63     function allowance(address owner, address spender)
64         external
65         view
66         returns (uint256);
67 
68     function approve(address spender, uint256 value) external returns (bool);
69 
70     function transfer(address to, uint256 value) external returns (bool);
71 
72     function transferFrom(
73         address from,
74         address to,
75         uint256 value
76     ) external returns (bool);
77 
78     function DOMAIN_SEPARATOR() external view returns (bytes32);
79 
80     function PERMIT_TYPEHASH() external pure returns (bytes32);
81 
82     function nonces(address owner) external view returns (uint256);
83 
84     function permit(
85         address owner,
86         address spender,
87         uint256 value,
88         uint256 deadline,
89         uint8 v,
90         bytes32 r,
91         bytes32 s
92     ) external;
93 
94     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
95     event Burn(
96         address indexed sender,
97         uint256 amount0,
98         uint256 amount1,
99         address indexed to
100     );
101     event Swap(
102         address indexed sender,
103         uint256 amount0In,
104         uint256 amount1In,
105         uint256 amount0Out,
106         uint256 amount1Out,
107         address indexed to
108     );
109     event Sync(uint112 reserve0, uint112 reserve1);
110 
111     function MINIMUM_LIQUIDITY() external pure returns (uint256);
112 
113     function factory() external view returns (address);
114 
115     function token0() external view returns (address);
116 
117     function token1() external view returns (address);
118 
119     function getReserves()
120         external
121         view
122         returns (
123             uint112 reserve0,
124             uint112 reserve1,
125             uint32 blockTimestampLast
126         );
127 
128     function price0CumulativeLast() external view returns (uint256);
129 
130     function price1CumulativeLast() external view returns (uint256);
131 
132     function kLast() external view returns (uint256);
133 
134     function mint(address to) external returns (uint256 liquidity);
135 
136     function burn(address to)
137         external
138         returns (uint256 amount0, uint256 amount1);
139 
140     function swap(
141         uint256 amount0Out,
142         uint256 amount1Out,
143         address to,
144         bytes calldata data
145     ) external;
146 
147     function skim(address to) external;
148 
149     function sync() external;
150 
151     function initialize(address, address) external;
152 }
153 
154 interface IUniswapV2Router01 {
155     function factory() external pure returns (address);
156 
157     function WETH() external pure returns (address);
158 
159     function addLiquidity(
160         address tokenA,
161         address tokenB,
162         uint256 amountADesired,
163         uint256 amountBDesired,
164         uint256 amountAMin,
165         uint256 amountBMin,
166         address to,
167         uint256 deadline
168     )
169         external
170         returns (
171             uint256 amountA,
172             uint256 amountB,
173             uint256 liquidity
174         );
175 
176     function addLiquidityETH(
177         address token,
178         uint256 amountTokenDesired,
179         uint256 amountTokenMin,
180         uint256 amountETHMin,
181         address to,
182         uint256 deadline
183     )
184         external
185         payable
186         returns (
187             uint256 amountToken,
188             uint256 amountETH,
189             uint256 liquidity
190         );
191 
192     function removeLiquidity(
193         address tokenA,
194         address tokenB,
195         uint256 liquidity,
196         uint256 amountAMin,
197         uint256 amountBMin,
198         address to,
199         uint256 deadline
200     ) external returns (uint256 amountA, uint256 amountB);
201 
202     function removeLiquidityETH(
203         address token,
204         uint256 liquidity,
205         uint256 amountTokenMin,
206         uint256 amountETHMin,
207         address to,
208         uint256 deadline
209     ) external returns (uint256 amountToken, uint256 amountETH);
210 
211     function removeLiquidityWithPermit(
212         address tokenA,
213         address tokenB,
214         uint256 liquidity,
215         uint256 amountAMin,
216         uint256 amountBMin,
217         address to,
218         uint256 deadline,
219         bool approveMax,
220         uint8 v,
221         bytes32 r,
222         bytes32 s
223     ) external returns (uint256 amountA, uint256 amountB);
224 
225     function removeLiquidityETHWithPermit(
226         address token,
227         uint256 liquidity,
228         uint256 amountTokenMin,
229         uint256 amountETHMin,
230         address to,
231         uint256 deadline,
232         bool approveMax,
233         uint8 v,
234         bytes32 r,
235         bytes32 s
236     ) external returns (uint256 amountToken, uint256 amountETH);
237 
238     function swapExactTokensForTokens(
239         uint256 amountIn,
240         uint256 amountOutMin,
241         address[] calldata path,
242         address to,
243         uint256 deadline
244     ) external returns (uint256[] memory amounts);
245 
246     function swapTokensForExactTokens(
247         uint256 amountOut,
248         uint256 amountInMax,
249         address[] calldata path,
250         address to,
251         uint256 deadline
252     ) external returns (uint256[] memory amounts);
253 
254     function swapExactETHForTokens(
255         uint256 amountOutMin,
256         address[] calldata path,
257         address to,
258         uint256 deadline
259     ) external payable returns (uint256[] memory amounts);
260 
261     function swapTokensForExactETH(
262         uint256 amountOut,
263         uint256 amountInMax,
264         address[] calldata path,
265         address to,
266         uint256 deadline
267     ) external returns (uint256[] memory amounts);
268 
269     function swapExactTokensForETH(
270         uint256 amountIn,
271         uint256 amountOutMin,
272         address[] calldata path,
273         address to,
274         uint256 deadline
275     ) external returns (uint256[] memory amounts);
276 
277     function swapETHForExactTokens(
278         uint256 amountOut,
279         address[] calldata path,
280         address to,
281         uint256 deadline
282     ) external payable returns (uint256[] memory amounts);
283 
284     function quote(
285         uint256 amountA,
286         uint256 reserveA,
287         uint256 reserveB
288     ) external pure returns (uint256 amountB);
289 
290     function getAmountOut(
291         uint256 amountIn,
292         uint256 reserveIn,
293         uint256 reserveOut
294     ) external pure returns (uint256 amountOut);
295 
296     function getAmountIn(
297         uint256 amountOut,
298         uint256 reserveIn,
299         uint256 reserveOut
300     ) external pure returns (uint256 amountIn);
301 
302     function getAmountsOut(uint256 amountIn, address[] calldata path)
303         external
304         view
305         returns (uint256[] memory amounts);
306 
307     function getAmountsIn(uint256 amountOut, address[] calldata path)
308         external
309         view
310         returns (uint256[] memory amounts);
311 }
312 
313 interface IUniswapV2Router02 is IUniswapV2Router01 {
314     function removeLiquidityETHSupportingFeeOnTransferTokens(
315         address token,
316         uint256 liquidity,
317         uint256 amountTokenMin,
318         uint256 amountETHMin,
319         address to,
320         uint256 deadline
321     ) external returns (uint256 amountETH);
322 
323     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
324         address token,
325         uint256 liquidity,
326         uint256 amountTokenMin,
327         uint256 amountETHMin,
328         address to,
329         uint256 deadline,
330         bool approveMax,
331         uint8 v,
332         bytes32 r,
333         bytes32 s
334     ) external returns (uint256 amountETH);
335 
336     function swapExactETHForTokensSupportingFeeOnTransferTokens(
337         uint256 amountOutMin,
338         address[] calldata path,
339         address to,
340         uint256 deadline
341     ) external payable;
342 
343     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
344         uint256 amountIn,
345         uint256 amountOutMin,
346         address[] calldata path,
347         address to,
348         uint256 deadline
349     ) external;
350 
351     function swapExactTokensForETHSupportingFeeOnTransferTokens(
352         uint256 amountIn,
353         uint256 amountOutMin,
354         address[] calldata path,
355         address to,
356         uint256 deadline
357     ) external;
358 }
359 
360 /**
361  * @dev Interface of the ERC20 standard as defined in the EIP.
362  */
363 interface IERC20 {
364     /**
365      * @dev Emitted when `value` tokens are moved from one account (`from`) to
366      * another (`to`).
367      *
368      * Note that `value` may be zero.
369      */
370     event Transfer(address indexed from, address indexed to, uint256 value);
371 
372     /**
373      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
374      * a call to {approve}. `value` is the new allowance.
375      */
376     event Approval(
377         address indexed owner,
378         address indexed spender,
379         uint256 value
380     );
381 
382     /**
383      * @dev Returns the amount of tokens in existence.
384      */
385     function totalSupply() external view returns (uint256);
386 
387     /**
388      * @dev Returns the amount of tokens owned by `account`.
389      */
390     function balanceOf(address account) external view returns (uint256);
391 
392     /**
393      * @dev Moves `amount` tokens from the caller's account to `to`.
394      *
395      * Returns a boolean value indicating whether the operation succeeded.
396      *
397      * Emits a {Transfer} event.
398      */
399     function transfer(address to, uint256 amount) external returns (bool);
400 
401     /**
402      * @dev Returns the remaining number of tokens that `spender` will be
403      * allowed to spend on behalf of `owner` through {transferFrom}. This is
404      * zero by default.
405      *
406      * This value changes when {approve} or {transferFrom} are called.
407      */
408     function allowance(address owner, address spender)
409         external
410         view
411         returns (uint256);
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
415      *
416      * Returns a boolean value indicating whether the operation succeeded.
417      *
418      * IMPORTANT: Beware that changing an allowance with this method brings the risk
419      * that someone may use both the old and the new allowance by unfortunate
420      * transaction ordering. One possible solution to mitigate this race
421      * condition is to first reduce the spender's allowance to 0 and set the
422      * desired value afterwards:
423      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
424      *
425      * Emits an {Approval} event.
426      */
427     function approve(address spender, uint256 amount) external returns (bool);
428 
429     /**
430      * @dev Moves `amount` tokens from `from` to `to` using the
431      * allowance mechanism. `amount` is then deducted from the caller's
432      * allowance.
433      *
434      * Returns a boolean value indicating whether the operation succeeded.
435      *
436      * Emits a {Transfer} event.
437      */
438     function transferFrom(
439         address from,
440         address to,
441         uint256 amount
442     ) external returns (bool);
443 }
444 
445 /**
446  * @dev Interface for the optional metadata functions from the ERC20 standard.
447  *
448  * _Available since v4.1._
449  */
450 interface IERC20Metadata is IERC20 {
451     /**
452      * @dev Returns the name of the token.
453      */
454     function name() external view returns (string memory);
455 
456     /**
457      * @dev Returns the decimals places of the token.
458      */
459     function decimals() external view returns (uint8);
460 
461     /**
462      * @dev Returns the symbol of the token.
463      */
464     function symbol() external view returns (string memory);
465 }
466 
467 /**
468  * @dev Provides information about the current execution context, including the
469  * sender of the transaction and its data. While these are generally available
470  * via msg.sender and msg.data, they should not be accessed in such a direct
471  * manner, since when dealing with meta-transactions the account sending and
472  * paying for execution may not be the actual sender (as far as an application
473  * is concerned).
474  *
475  * This contract is only required for intermediate, library-like contracts.
476  */
477 abstract contract Context {
478     function _msgSender() internal view virtual returns (address) {
479         return msg.sender;
480     }
481 }
482 
483 /**
484  * @dev Contract module which provides a basic access control mechanism, where
485  * there is an account (an owner) that can be granted exclusive access to
486  * specific functions.
487  *
488  * By default, the owner account will be the one that deploys the contract. This
489  * can later be changed with {transferOwnership}.
490  *
491  * This module is used through inheritance. It will make available the modifier
492  * `onlyOwner`, which can be applied to your functions to restrict their use to
493  * the owner.
494  */
495 abstract contract Ownable is Context {
496     address private _owner;
497 
498     event OwnershipTransferred(
499         address indexed previousOwner,
500         address indexed newOwner
501     );
502 
503     /**
504      * @dev Initializes the contract setting the deployer as the initial owner.
505      */
506     constructor() {
507         _transferOwnership(_msgSender());
508     }
509 
510     /**
511      * @dev Throws if called by any account other than the owner.
512      */
513     modifier onlyOwner() {
514         _checkOwner();
515         _;
516     }
517 
518     /**
519      * @dev Returns the address of the current owner.
520      */
521     function owner() public view virtual returns (address) {
522         return _owner;
523     }
524 
525     /**
526      * @dev Throws if the sender is not the owner.
527      */
528     function _checkOwner() internal view virtual {
529         require(owner() == _msgSender(), "Ownable: caller is not the owner");
530     }
531 
532     /**
533      * @dev Leaves the contract without owner. It will not be possible to call
534      * `onlyOwner` functions anymore. Can only be called by the current owner.
535      *
536      * NOTE: Renouncing ownership will leave the contract without an owner,
537      * thereby removing any functionality that is only available to the owner.
538      */
539     function renounceOwnership() public virtual onlyOwner {
540         _transferOwnership(address(0));
541     }
542 
543     /**
544      * @dev Transfers ownership of the contract to a new account (`newOwner`).
545      * Can only be called by the current owner.
546      */
547     function transferOwnership(address newOwner) public virtual onlyOwner {
548         require(
549             newOwner != address(0),
550             "Ownable: new owner is the zero address"
551         );
552         _transferOwnership(newOwner);
553     }
554 
555     /**
556      * @dev Transfers ownership of the contract to a new account (`newOwner`).
557      * Internal function without access restriction.
558      */
559     function _transferOwnership(address newOwner) internal virtual {
560         address oldOwner = _owner;
561         _owner = newOwner;
562         emit OwnershipTransferred(oldOwner, newOwner);
563     }
564 }
565 
566 /**
567  * @dev Implementation of the {IERC20} interface.
568  *
569  * This implementation is agnostic to the way tokens are created. This means
570  * that a supply mechanism has to be added in a derived contract using {_mint}.
571  * For a generic mechanism see {ERC20PresetMinterPauser}.
572  *
573  * TIP: For a detailed writeup see our guide
574  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
575  * to implement supply mechanisms].
576  *
577  * We have followed general OpenZeppelin Contracts guidelines: functions revert
578  * instead returning `false` on failure. This behavior is nonetheless
579  * conventional and does not conflict with the expectations of ERC20
580  * applications.
581  *
582  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
583  * This allows applications to reconstruct the allowance for all accounts just
584  * by listening to said events. Other implementations of the EIP may not emit
585  * these events, as it isn't required by the specification.
586  *
587  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
588  * functions have been added to mitigate the well-known issues around setting
589  * allowances. See {IERC20-approve}.
590  */
591 contract ERC20 is Context, IERC20, IERC20Metadata {
592     mapping(address => uint256) private _balances;
593     mapping(address => mapping(address => uint256)) private _allowances;
594 
595     uint256 private _totalSupply;
596 
597     string private _name;
598     string private _symbol;
599 
600     constructor(string memory name_, string memory symbol_) {
601         _name = name_;
602         _symbol = symbol_;
603     }
604 
605     /**
606      * @dev Returns the symbol of the token, usually a shorter version of the
607      * name.
608      */
609     function symbol() external view virtual override returns (string memory) {
610         return _symbol;
611     }
612 
613     /**
614      * @dev Returns the name of the token.
615      */
616     function name() external view virtual override returns (string memory) {
617         return _name;
618     }
619 
620     /**
621      * @dev See {IERC20-balanceOf}.
622      */
623     function balanceOf(address account)
624         public
625         view
626         virtual
627         override
628         returns (uint256)
629     {
630         return _balances[account];
631     }
632 
633     /**
634      * @dev Returns the number of decimals used to get its user representation.
635      * For example, if `decimals` equals `2`, a balance of `505` tokens should
636      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
637      *
638      * Tokens usually opt for a value of 18, imitating the relationship between
639      * Ether and Wei. This is the value {ERC20} uses, unless this function is
640      * overridden;
641      *
642      * NOTE: This information is only used for _display_ purposes: it in
643      * no way affects any of the arithmetic of the contract, including
644      * {IERC20-balanceOf} and {IERC20-transfer}.
645      */
646     function decimals() public view virtual override returns (uint8) {
647         return 9;
648     }
649 
650     /**
651      * @dev See {IERC20-totalSupply}.
652      */
653     function totalSupply() external view virtual override returns (uint256) {
654         return _totalSupply;
655     }
656 
657     /**
658      * @dev See {IERC20-allowance}.
659      */
660     function allowance(address owner, address spender)
661         public
662         view
663         virtual
664         override
665         returns (uint256)
666     {
667         return _allowances[owner][spender];
668     }
669 
670     /**
671      * @dev See {IERC20-transfer}.
672      *
673      * Requirements:
674      *
675      * - `to` cannot be the zero address.
676      * - the caller must have a balance of at least `amount`.
677      */
678     function transfer(address to, uint256 amount)
679         external
680         virtual
681         override
682         returns (bool)
683     {
684         address owner = _msgSender();
685         _transfer(owner, to, amount);
686         return true;
687     }
688 
689     /**
690      * @dev See {IERC20-approve}.
691      *
692      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
693      * `transferFrom`. This is semantically equivalent to an infinite approval.
694      *
695      * Requirements:
696      *
697      * - `spender` cannot be the zero address.
698      */
699     function approve(address spender, uint256 amount)
700         external
701         virtual
702         override
703         returns (bool)
704     {
705         address owner = _msgSender();
706         _approve(owner, spender, amount);
707         return true;
708     }
709 
710     /**
711      * @dev See {IERC20-transferFrom}.
712      *
713      * Emits an {Approval} event indicating the updated allowance. This is not
714      * required by the EIP. See the note at the beginning of {ERC20}.
715      *
716      * NOTE: Does not update the allowance if the current allowance
717      * is the maximum `uint256`.
718      *
719      * Requirements:
720      *
721      * - `from` and `to` cannot be the zero address.
722      * - `from` must have a balance of at least `amount`.
723      * - the caller must have allowance for ``from``'s tokens of at least
724      * `amount`.
725      */
726     function transferFrom(
727         address from,
728         address to,
729         uint256 amount
730     ) external virtual override returns (bool) {
731         address spender = _msgSender();
732         _spendAllowance(from, spender, amount);
733         _transfer(from, to, amount);
734         return true;
735     }
736 
737     /**
738      * @dev Atomically decreases the allowance granted to `spender` by the caller.
739      *
740      * This is an alternative to {approve} that can be used as a mitigation for
741      * problems described in {IERC20-approve}.
742      *
743      * Emits an {Approval} event indicating the updated allowance.
744      *
745      * Requirements:
746      *
747      * - `spender` cannot be the zero address.
748      * - `spender` must have allowance for the caller of at least
749      * `subtractedValue`.
750      */
751     function decreaseAllowance(address spender, uint256 subtractedValue)
752         external
753         virtual
754         returns (bool)
755     {
756         address owner = _msgSender();
757         uint256 currentAllowance = allowance(owner, spender);
758         require(
759             currentAllowance >= subtractedValue,
760             "ERC20: decreased allowance below zero"
761         );
762         unchecked {
763             _approve(owner, spender, currentAllowance - subtractedValue);
764         }
765 
766         return true;
767     }
768 
769     /**
770      * @dev Atomically increases the allowance granted to `spender` by the caller.
771      *
772      * This is an alternative to {approve} that can be used as a mitigation for
773      * problems described in {IERC20-approve}.
774      *
775      * Emits an {Approval} event indicating the updated allowance.
776      *
777      * Requirements:
778      *
779      * - `spender` cannot be the zero address.
780      */
781     function increaseAllowance(address spender, uint256 addedValue)
782         external
783         virtual
784         returns (bool)
785     {
786         address owner = _msgSender();
787         _approve(owner, spender, allowance(owner, spender) + addedValue);
788         return true;
789     }
790 
791     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
792      * the total supply.
793      *
794      * Emits a {Transfer} event with `from` set to the zero address.
795      *
796      * Requirements:
797      *
798      * - `account` cannot be the zero address.
799      */
800     function _mint(address account, uint256 amount) internal virtual {
801         require(account != address(0), "ERC20: mint to the zero address");
802 
803         _totalSupply += amount;
804         unchecked {
805             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
806             _balances[account] += amount;
807         }
808         emit Transfer(address(0), account, amount);
809     }
810 
811     /**
812      * @dev Destroys `amount` tokens from `account`, reducing the
813      * total supply.
814      *
815      * Emits a {Transfer} event with `to` set to the zero address.
816      *
817      * Requirements:
818      *
819      * - `account` cannot be the zero address.
820      * - `account` must have at least `amount` tokens.
821      */
822     function _burn(address account, uint256 amount) internal virtual {
823         require(account != address(0), "ERC20: burn from the zero address");
824 
825         uint256 accountBalance = _balances[account];
826         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
827         unchecked {
828             _balances[account] = accountBalance - amount;
829             // Overflow not possible: amount <= accountBalance <= totalSupply.
830             _totalSupply -= amount;
831         }
832 
833         emit Transfer(account, address(0), amount);
834     }
835 
836     /**
837      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
838      *
839      * This internal function is equivalent to `approve`, and can be used to
840      * e.g. set automatic allowances for certain subsystems, etc.
841      *
842      * Emits an {Approval} event.
843      *
844      * Requirements:
845      *
846      * - `owner` cannot be the zero address.
847      * - `spender` cannot be the zero address.
848      */
849     function _approve(
850         address owner,
851         address spender,
852         uint256 amount
853     ) internal virtual {
854         require(owner != address(0), "ERC20: approve from the zero address");
855         require(spender != address(0), "ERC20: approve to the zero address");
856 
857         _allowances[owner][spender] = amount;
858         emit Approval(owner, spender, amount);
859     }
860 
861     /**
862      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
863      *
864      * Does not update the allowance amount in case of infinite allowance.
865      * Revert if not enough allowance is available.
866      *
867      * Might emit an {Approval} event.
868      */
869     function _spendAllowance(
870         address owner,
871         address spender,
872         uint256 amount
873     ) internal virtual {
874         uint256 currentAllowance = allowance(owner, spender);
875         if (currentAllowance != type(uint256).max) {
876             require(
877                 currentAllowance >= amount,
878                 "ERC20: insufficient allowance"
879             );
880             unchecked {
881                 _approve(owner, spender, currentAllowance - amount);
882             }
883         }
884     }
885 
886     function _transfer(
887         address from,
888         address to,
889         uint256 amount
890     ) internal virtual {
891         require(from != address(0), "ERC20: transfer from the zero address");
892         require(to != address(0), "ERC20: transfer to the zero address");
893 
894         uint256 fromBalance = _balances[from];
895         require(
896             fromBalance >= amount,
897             "ERC20: transfer amount exceeds balance"
898         );
899         unchecked {
900             _balances[from] = fromBalance - amount;
901             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
902             // decrementing then incrementing.
903             _balances[to] += amount;
904         }
905 
906         emit Transfer(from, to, amount);
907     }
908 }
909 
910 /**
911  * @dev Implementation of the {IERC20} interface.
912  *
913  * This implementation is agnostic to the way tokens are created. This means
914  * that a supply mechanism has to be added in a derived contract using {_mint}.
915  * For a generic mechanism see {ERC20PresetMinterPauser}.
916  *
917  * TIP: For a detailed writeup see our guide
918  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
919  * to implement supply mechanisms].
920  *
921  * We have followed general OpenZeppelin Contracts guidelines: functions revert
922  * instead returning `false` on failure. This behavior is nonetheless
923  * conventional and does not conflict with the expectations of ERC20
924  * applications.
925  *
926  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
927  * This allows applications to reconstruct the allowance for all accounts just
928  * by listening to said events. Other implementations of the EIP may not emit
929  * these events, as it isn't required by the specification.
930  *
931  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
932  * functions have been added to mitigate the well-known issues around setting
933  * allowances. See {IERC20-approve}.
934  */
935 contract MeBot is ERC20, Ownable {
936     uint8 private _decimals = 9;
937     uint256 private _supply = 1000000000;
938     uint256 public taxForLiquidity = 1;
939     uint256 public taxForMarketing = 2;
940 
941     address public marketingWallet = 0xb484EC52969dB80a8fA16fffe87fd4dc4cAbaf84;
942     address public DEAD = 0x000000000000000000000000000000000000dEaD;
943     uint256 public _marketingReserves = 0;
944     mapping(address => bool) public _isExcludedFromFee;
945     mapping(address => uint256) public maxBuyAmount;
946     uint256 public numTokensSellToAddToLiquidity = 300000 * 10**_decimals;
947     uint256 public numTokensSellToAddToETH = 150000 * 10**_decimals;
948 
949     IUniswapV2Router02 public immutable uniswapV2Router;
950     address public uniswapV2Pair;
951 
952     bool inSwapAndLiquify;
953 
954     event SwapAndLiquify(
955         uint256 tokensSwapped,
956         uint256 ethReceived,
957         uint256 tokensIntoLiqudity
958     );
959     event MaxBuyAmount(uint256 amount);
960     event NumTokensSellToAddToLiquidityUpdated(
961         uint256 tokenToSell,
962         uint256 tokenToETH
963     );
964     event TaxForLiquidityAndMarketingUpdated(
965         uint256 liquidity,
966         uint256 marketing
967     );
968     event MarketingWalletUpdated(address wallet);
969 
970       modifier lockTheSwap() {
971         inSwapAndLiquify = true;
972         _;
973         inSwapAndLiquify = false;
974     }
975 
976     /**
977      * @dev Sets the values for {name} and {symbol}.
978      *
979      * The default value of {decimals} is 18. To select a different value for
980      * {decimals} you should overload it.
981      *
982      * All two of these values are immutable: they can only be set once during
983      * construction.
984      */
985     constructor() ERC20("MeBot", "MEBOT") {
986         _mint(_msgSender(), (_supply * 10**_decimals));
987 
988         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
989             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
990         );
991         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
992             .createPair(address(this), _uniswapV2Router.WETH());
993 
994         uniswapV2Router = _uniswapV2Router;
995 
996         _isExcludedFromFee[address(uniswapV2Router)] = true;
997         _isExcludedFromFee[_msgSender()] = true;
998         _isExcludedFromFee[marketingWallet] = true;
999         marketingWallet = _msgSender();
1000     }
1001 
1002     /**
1003      * @dev Moves `amount` of tokens from `from` to `to`.
1004      *
1005      * This internal function is equivalent to {transfer}, and can be used to
1006      * e.g. implement automatic token fees, slashing mechanisms, etc.
1007      *
1008      * Emits a {Transfer} event.
1009      *
1010      * Requirements:
1011      *
1012      *
1013      * - `from` cannot be the zero address.
1014      * - `to` cannot be the zero address.
1015      * - `from` must have a balance of at least `amount`.
1016      */
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 amount
1021     ) internal override {
1022         require(from != address(0), "ERC20: transfer from the zero address");
1023         require(to != address(0), "ERC20: transfer to the zero address");
1024         require(
1025             balanceOf(from) >= amount,
1026             "ERC20: transfer amount exceeds balance"
1027         );
1028         if (maxBuyAmount[from] > 0) {
1029             require(
1030                 balanceOf(to) + amount <= maxBuyAmount[from],
1031                 "BALANCE_LIMIT"
1032             );
1033         }
1034         if (
1035             (from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify
1036         ) {
1037             if (from != uniswapV2Pair) {
1038                 uint256 contractLiquidityBalance = balanceOf(address(this)) -
1039                     _marketingReserves;
1040                 if (contractLiquidityBalance >= numTokensSellToAddToLiquidity) {
1041                     _swapAndLiquify(numTokensSellToAddToLiquidity);
1042                 }
1043                 if ((_marketingReserves) >= numTokensSellToAddToETH) {
1044                     _swapTokensForETH(numTokensSellToAddToETH);
1045                     _marketingReserves -= numTokensSellToAddToETH;
1046                     payable(marketingWallet).transfer(address(this).balance);
1047                 }
1048             }
1049 
1050             uint256 transferAmount;
1051             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1052                 transferAmount = amount;
1053             } else {
1054                 uint256 marketingShare = ((amount * taxForMarketing) / 100);
1055                 uint256 liquidityShare = ((amount * taxForLiquidity) / 100);
1056                 transferAmount = amount - (marketingShare + liquidityShare);
1057                 _marketingReserves += marketingShare;
1058 
1059                 super._transfer(
1060                     from,
1061                     address(this),
1062                     (marketingShare + liquidityShare)
1063                 );
1064             }
1065             super._transfer(from, to, transferAmount);
1066         } else {
1067             super._transfer(from, to, amount);
1068         }
1069     }
1070 
1071     function excludeFromFee(address _address, bool _status) external onlyOwner {
1072         _isExcludedFromFee[_address] = _status;
1073     }
1074 
1075     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1076         uint256 half = (contractTokenBalance / 2);
1077         uint256 otherHalf = (contractTokenBalance - half);
1078 
1079         uint256 initialBalance = address(this).balance;
1080 
1081         _swapTokensForETH(half);
1082 
1083         uint256 newBalance = (address(this).balance - initialBalance);
1084 
1085         _addLiquidity(otherHalf, newBalance);
1086 
1087         emit SwapAndLiquify(half, newBalance, otherHalf);
1088     }
1089 
1090     function _swapTokensForETH(uint256 tokenAmount) private lockTheSwap {
1091         address[] memory path = new address[](2);
1092         path[0] = address(this);
1093         path[1] = uniswapV2Router.WETH();
1094 
1095         _approve(address(this), address(uniswapV2Router), tokenAmount);
1096 
1097         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1098             tokenAmount,
1099             0,
1100             path,
1101             address(this),
1102             block.timestamp
1103         );
1104     }
1105 
1106     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
1107         private
1108         lockTheSwap
1109     {
1110         _approve(address(this), address(uniswapV2Router), tokenAmount);
1111 
1112         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1113             address(this),
1114             tokenAmount,
1115             0,
1116             0,
1117             marketingWallet,
1118             block.timestamp
1119         );
1120     }
1121 
1122     function setMarketingWallet(address newWallet) public onlyOwner {
1123         require(newWallet != DEAD, "LP Pair cannot be the Dead wallet, or 0!");
1124         require(
1125             newWallet != address(0),
1126             "LP Pair cannot be the Dead wallet, or 0!"
1127         );
1128         marketingWallet = newWallet;
1129         emit MarketingWalletUpdated(newWallet);
1130     }
1131 
1132     function setTaxForLiquidityAndMarketing(
1133         uint256 _taxForLiquidity,
1134         uint256 _taxForMarketing
1135     ) public onlyOwner {
1136         require(
1137             (_taxForLiquidity + _taxForMarketing) <= 10,
1138             "ERC20: total tax must not be greater than 10%"
1139         );
1140         taxForLiquidity = _taxForLiquidity;
1141         taxForMarketing = _taxForMarketing;
1142 
1143         emit TaxForLiquidityAndMarketingUpdated(
1144             taxForLiquidity,
1145             taxForMarketing
1146         );
1147     }
1148 
1149     function setNumTokensSellToAddToLiquidity(
1150         uint256 _numTokensSellToAddToLiquidity,
1151         uint256 _numTokensSellToAddToETH
1152     ) public onlyOwner {
1153         require(
1154             _numTokensSellToAddToLiquidity < (_supply * 2) / 100,
1155             "Cannot liquidate more than 2% of the supply at once!"
1156         );
1157         require(
1158             _numTokensSellToAddToETH < (_supply * 2) / 100,
1159             "Cannot liquidate more than 2% of the supply at once!"
1160         );
1161         numTokensSellToAddToLiquidity =
1162             _numTokensSellToAddToLiquidity *
1163             10**_decimals;
1164         numTokensSellToAddToETH = _numTokensSellToAddToETH * 10**_decimals;
1165 
1166         emit NumTokensSellToAddToLiquidityUpdated(
1167             numTokensSellToAddToLiquidity,
1168             numTokensSellToAddToETH
1169         );
1170     }
1171 
1172     function setMaxBuyAmount(uint256 value) external onlyOwner {
1173         require(value != maxBuyAmount[uniswapV2Pair], "invalid amount");
1174         maxBuyAmount[uniswapV2Pair] = value;
1175         emit MaxBuyAmount(value);
1176     }
1177 
1178     receive() external payable {}
1179 }