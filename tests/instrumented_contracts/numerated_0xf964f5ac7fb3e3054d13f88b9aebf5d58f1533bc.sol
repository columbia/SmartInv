1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.1
27 
28 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(
46         address indexed previousOwner,
47         address indexed newOwner
48     );
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         _checkOwner();
62         _;
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view virtual returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if the sender is not the owner.
74      */
75     function _checkOwner() internal view virtual {
76         require(owner() == _msgSender(), "Ownable: caller is not the owner");
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(
96             newOwner != address(0),
97             "Ownable: new owner is the zero address"
98         );
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.1
114 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP.
118  */
119 interface IERC20 {
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(
133         address indexed owner,
134         address indexed spender,
135         uint256 value
136     );
137 
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `to`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address to, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(
165         address owner,
166         address spender
167     ) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `from` to `to` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 amount
198     ) external returns (bool);
199 }
200 
201 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.1
202 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
203 
204 /**
205  * @dev Interface for the optional metadata functions from the ERC20 standard.
206  *
207  * _Available since v4.1._
208  */
209 interface IERC20Metadata is IERC20 {
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the symbol of the token.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the decimals places of the token.
222      */
223     function decimals() external view returns (uint8);
224 }
225 
226 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.1
227 
228 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
229 
230 /**
231  * @dev Implementation of the {IERC20} interface.
232  *
233  * This implementation is agnostic to the way tokens are created. This means
234  * that a supply mechanism has to be added in a derived contract using {_mint}.
235  * For a generic mechanism see {ERC20PresetMinterPauser}.
236  *
237  * TIP: For a detailed writeup see our guide
238  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
239  * to implement supply mechanisms].
240  *
241  * We have followed general OpenZeppelin Contracts guidelines: functions revert
242  * instead returning `false` on failure. This behavior is nonetheless
243  * conventional and does not conflict with the expectations of ERC20
244  * applications.
245  *
246  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
247  * This allows applications to reconstruct the allowance for all accounts just
248  * by listening to said events. Other implementations of the EIP may not emit
249  * these events, as it isn't required by the specification.
250  *
251  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
252  * functions have been added to mitigate the well-known issues around setting
253  * allowances. See {IERC20-approve}.
254  */
255 contract ERC20 is Context, IERC20, IERC20Metadata {
256     mapping(address => uint256) private _balances;
257 
258     mapping(address => mapping(address => uint256)) private _allowances;
259 
260     uint256 private _totalSupply;
261 
262     string private _name;
263     string private _symbol;
264 
265     /**
266      * @dev Sets the values for {name} and {symbol}.
267      *
268      * The default value of {decimals} is 18. To select a different value for
269      * {decimals} you should overload it.
270      *
271      * All two of these values are immutable: they can only be set once during
272      * construction.
273      */
274     constructor(string memory name_, string memory symbol_) {
275         _name = name_;
276         _symbol = symbol_;
277     }
278 
279     /**
280      * @dev Returns the name of the token.
281      */
282     function name() public view virtual override returns (string memory) {
283         return _name;
284     }
285 
286     /**
287      * @dev Returns the symbol of the token, usually a shorter version of the
288      * name.
289      */
290     function symbol() public view virtual override returns (string memory) {
291         return _symbol;
292     }
293 
294     /**
295      * @dev Returns the number of decimals used to get its user representation.
296      * For example, if `decimals` equals `2`, a balance of `505` tokens should
297      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
298      *
299      * Tokens usually opt for a value of 18, imitating the relationship between
300      * Ether and Wei. This is the value {ERC20} uses, unless this function is
301      * overridden;
302      *
303      * NOTE: This information is only used for _display_ purposes: it in
304      * no way affects any of the arithmetic of the contract, including
305      * {IERC20-balanceOf} and {IERC20-transfer}.
306      */
307     function decimals() public view virtual override returns (uint8) {
308         return 18;
309     }
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view virtual override returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(
322         address account
323     ) public view virtual override returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `to` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(
336         address to,
337         uint256 amount
338     ) public virtual override returns (bool) {
339         address owner = _msgSender();
340         _transfer(owner, to, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-allowance}.
346      */
347     function allowance(
348         address owner,
349         address spender
350     ) public view virtual override returns (uint256) {
351         return _allowances[owner][spender];
352     }
353 
354     /**
355      * @dev See {IERC20-approve}.
356      *
357      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
358      * `transferFrom`. This is semantically equivalent to an infinite approval.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(
365         address spender,
366         uint256 amount
367     ) public virtual override returns (bool) {
368         address owner = _msgSender();
369         _approve(owner, spender, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-transferFrom}.
375      *
376      * Emits an {Approval} event indicating the updated allowance. This is not
377      * required by the EIP. See the note at the beginning of {ERC20}.
378      *
379      * NOTE: Does not update the allowance if the current allowance
380      * is the maximum `uint256`.
381      *
382      * Requirements:
383      *
384      * - `from` and `to` cannot be the zero address.
385      * - `from` must have a balance of at least `amount`.
386      * - the caller must have allowance for ``from``'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(
390         address from,
391         address to,
392         uint256 amount
393     ) public virtual override returns (bool) {
394         address spender = _msgSender();
395         _spendAllowance(from, spender, amount);
396         _transfer(from, to, amount);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically increases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      */
412     function increaseAllowance(
413         address spender,
414         uint256 addedValue
415     ) public virtual returns (bool) {
416         address owner = _msgSender();
417         _approve(owner, spender, allowance(owner, spender) + addedValue);
418         return true;
419     }
420 
421     /**
422      * @dev Atomically decreases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      * - `spender` must have allowance for the caller of at least
433      * `subtractedValue`.
434      */
435     function decreaseAllowance(
436         address spender,
437         uint256 subtractedValue
438     ) public virtual returns (bool) {
439         address owner = _msgSender();
440         uint256 currentAllowance = allowance(owner, spender);
441         require(
442             currentAllowance >= subtractedValue,
443             "ERC20: decreased allowance below zero"
444         );
445         unchecked {
446             _approve(owner, spender, currentAllowance - subtractedValue);
447         }
448 
449         return true;
450     }
451 
452     /**
453      * @dev Moves `amount` of tokens from `from` to `to`.
454      *
455      * This internal function is equivalent to {transfer}, and can be used to
456      * e.g. implement automatic token fees, slashing mechanisms, etc.
457      *
458      * Emits a {Transfer} event.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `from` must have a balance of at least `amount`.
465      */
466     function _transfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {
471         require(from != address(0), "ERC20: transfer from the zero address");
472         require(to != address(0), "ERC20: transfer to the zero address");
473 
474         _beforeTokenTransfer(from, to, amount);
475 
476         uint256 fromBalance = _balances[from];
477         require(
478             fromBalance >= amount,
479             "ERC20: transfer amount exceeds balance"
480         );
481         unchecked {
482             _balances[from] = fromBalance - amount;
483             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
484             // decrementing then incrementing.
485             _balances[to] += amount;
486         }
487 
488         emit Transfer(from, to, amount);
489 
490         _afterTokenTransfer(from, to, amount);
491     }
492 
493     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
494      * the total supply.
495      *
496      * Emits a {Transfer} event with `from` set to the zero address.
497      *
498      * Requirements:
499      *
500      * - `account` cannot be the zero address.
501      */
502     function _mint(address account, uint256 amount) internal virtual {
503         require(account != address(0), "ERC20: mint to the zero address");
504 
505         _beforeTokenTransfer(address(0), account, amount);
506 
507         _totalSupply += amount;
508         unchecked {
509             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
510             _balances[account] += amount;
511         }
512         emit Transfer(address(0), account, amount);
513 
514         _afterTokenTransfer(address(0), account, amount);
515     }
516 
517     /**
518      * @dev Destroys `amount` tokens from `account`, reducing the
519      * total supply.
520      *
521      * Emits a {Transfer} event with `to` set to the zero address.
522      *
523      * Requirements:
524      *
525      * - `account` cannot be the zero address.
526      * - `account` must have at least `amount` tokens.
527      */
528     function _burn(address account, uint256 amount) internal virtual {
529         require(account != address(0), "ERC20: burn from the zero address");
530 
531         _beforeTokenTransfer(account, address(0), amount);
532 
533         uint256 accountBalance = _balances[account];
534         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
535         unchecked {
536             _balances[account] = accountBalance - amount;
537             // Overflow not possible: amount <= accountBalance <= totalSupply.
538             _totalSupply -= amount;
539         }
540 
541         emit Transfer(account, address(0), amount);
542 
543         _afterTokenTransfer(account, address(0), amount);
544     }
545 
546     /**
547      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
548      *
549      * This internal function is equivalent to `approve`, and can be used to
550      * e.g. set automatic allowances for certain subsystems, etc.
551      *
552      * Emits an {Approval} event.
553      *
554      * Requirements:
555      *
556      * - `owner` cannot be the zero address.
557      * - `spender` cannot be the zero address.
558      */
559     function _approve(
560         address owner,
561         address spender,
562         uint256 amount
563     ) internal virtual {
564         require(owner != address(0), "ERC20: approve from the zero address");
565         require(spender != address(0), "ERC20: approve to the zero address");
566 
567         _allowances[owner][spender] = amount;
568         emit Approval(owner, spender, amount);
569     }
570 
571     /**
572      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
573      *
574      * Does not update the allowance amount in case of infinite allowance.
575      * Revert if not enough allowance is available.
576      *
577      * Might emit an {Approval} event.
578      */
579     function _spendAllowance(
580         address owner,
581         address spender,
582         uint256 amount
583     ) internal virtual {
584         uint256 currentAllowance = allowance(owner, spender);
585         if (currentAllowance != type(uint256).max) {
586             require(
587                 currentAllowance >= amount,
588                 "ERC20: insufficient allowance"
589             );
590             unchecked {
591                 _approve(owner, spender, currentAllowance - amount);
592             }
593         }
594     }
595 
596     /**
597      * @dev Hook that is called before any transfer of tokens. This includes
598      * minting and burning.
599      *
600      * Calling conditions:
601      *
602      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
603      * will be transferred to `to`.
604      * - when `from` is zero, `amount` tokens will be minted for `to`.
605      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
606      * - `from` and `to` are never both zero.
607      *
608      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
609      */
610     function _beforeTokenTransfer(
611         address from,
612         address to,
613         uint256 amount
614     ) internal virtual {}
615 
616     /**
617      * @dev Hook that is called after any transfer of tokens. This includes
618      * minting and burning.
619      *
620      * Calling conditions:
621      *
622      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
623      * has been transferred to `to`.
624      * - when `from` is zero, `amount` tokens have been minted for `to`.
625      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
626      * - `from` and `to` are never both zero.
627      *
628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
629      */
630     function _afterTokenTransfer(
631         address from,
632         address to,
633         uint256 amount
634     ) internal virtual {}
635 }
636 
637 interface IUniswapV2Factory {
638     event PairCreated(
639         address indexed token0,
640         address indexed token1,
641         address pair,
642         uint
643     );
644 
645     function feeTo() external view returns (address);
646 
647     function feeToSetter() external view returns (address);
648 
649     function getPair(
650         address tokenA,
651         address tokenB
652     ) external view returns (address pair);
653 
654     function allPairs(uint) external view returns (address pair);
655 
656     function allPairsLength() external view returns (uint);
657 
658     function createPair(
659         address tokenA,
660         address tokenB
661     ) external returns (address pair);
662 
663     function setFeeTo(address) external;
664 
665     function setFeeToSetter(address) external;
666 }
667 
668 interface IUniswapV2Pair {
669     event Approval(address indexed owner, address indexed spender, uint value);
670     event Transfer(address indexed from, address indexed to, uint value);
671 
672     function name() external pure returns (string memory);
673 
674     function symbol() external pure returns (string memory);
675 
676     function decimals() external pure returns (uint8);
677 
678     function totalSupply() external view returns (uint);
679 
680     function balanceOf(address owner) external view returns (uint);
681 
682     function allowance(
683         address owner,
684         address spender
685     ) external view returns (uint);
686 
687     function approve(address spender, uint value) external returns (bool);
688 
689     function transfer(address to, uint value) external returns (bool);
690 
691     function transferFrom(
692         address from,
693         address to,
694         uint value
695     ) external returns (bool);
696 
697     function DOMAIN_SEPARATOR() external view returns (bytes32);
698 
699     function PERMIT_TYPEHASH() external pure returns (bytes32);
700 
701     function nonces(address owner) external view returns (uint);
702 
703     function permit(
704         address owner,
705         address spender,
706         uint value,
707         uint deadline,
708         uint8 v,
709         bytes32 r,
710         bytes32 s
711     ) external;
712 
713     event Mint(address indexed sender, uint amount0, uint amount1);
714     event Burn(
715         address indexed sender,
716         uint amount0,
717         uint amount1,
718         address indexed to
719     );
720     event Swap(
721         address indexed sender,
722         uint amount0In,
723         uint amount1In,
724         uint amount0Out,
725         uint amount1Out,
726         address indexed to
727     );
728     event Sync(uint112 reserve0, uint112 reserve1);
729 
730     function MINIMUM_LIQUIDITY() external pure returns (uint);
731 
732     function factory() external view returns (address);
733 
734     function token0() external view returns (address);
735 
736     function token1() external view returns (address);
737 
738     function getReserves()
739         external
740         view
741         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
742 
743     function price0CumulativeLast() external view returns (uint);
744 
745     function price1CumulativeLast() external view returns (uint);
746 
747     function kLast() external view returns (uint);
748 
749     function mint(address to) external returns (uint liquidity);
750 
751     function burn(address to) external returns (uint amount0, uint amount1);
752 
753     function swap(
754         uint amount0Out,
755         uint amount1Out,
756         address to,
757         bytes calldata data
758     ) external;
759 
760     function skim(address to) external;
761 
762     function sync() external;
763 
764     function initialize(address, address) external;
765 }
766 
767 interface IUniswapV2Router01 {
768     function factory() external pure returns (address);
769 
770     function WETH() external pure returns (address);
771 
772     function addLiquidity(
773         address tokenA,
774         address tokenB,
775         uint amountADesired,
776         uint amountBDesired,
777         uint amountAMin,
778         uint amountBMin,
779         address to,
780         uint deadline
781     ) external returns (uint amountA, uint amountB, uint liquidity);
782 
783     function addLiquidityETH(
784         address token,
785         uint amountTokenDesired,
786         uint amountTokenMin,
787         uint amountETHMin,
788         address to,
789         uint deadline
790     )
791         external
792         payable
793         returns (uint amountToken, uint amountETH, uint liquidity);
794 
795     function removeLiquidity(
796         address tokenA,
797         address tokenB,
798         uint liquidity,
799         uint amountAMin,
800         uint amountBMin,
801         address to,
802         uint deadline
803     ) external returns (uint amountA, uint amountB);
804 
805     function removeLiquidityETH(
806         address token,
807         uint liquidity,
808         uint amountTokenMin,
809         uint amountETHMin,
810         address to,
811         uint deadline
812     ) external returns (uint amountToken, uint amountETH);
813 
814     function removeLiquidityWithPermit(
815         address tokenA,
816         address tokenB,
817         uint liquidity,
818         uint amountAMin,
819         uint amountBMin,
820         address to,
821         uint deadline,
822         bool approveMax,
823         uint8 v,
824         bytes32 r,
825         bytes32 s
826     ) external returns (uint amountA, uint amountB);
827 
828     function removeLiquidityETHWithPermit(
829         address token,
830         uint liquidity,
831         uint amountTokenMin,
832         uint amountETHMin,
833         address to,
834         uint deadline,
835         bool approveMax,
836         uint8 v,
837         bytes32 r,
838         bytes32 s
839     ) external returns (uint amountToken, uint amountETH);
840 
841     function swapExactTokensForTokens(
842         uint amountIn,
843         uint amountOutMin,
844         address[] calldata path,
845         address to,
846         uint deadline
847     ) external returns (uint[] memory amounts);
848 
849     function swapTokensForExactTokens(
850         uint amountOut,
851         uint amountInMax,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external returns (uint[] memory amounts);
856 
857     function swapExactETHForTokens(
858         uint amountOutMin,
859         address[] calldata path,
860         address to,
861         uint deadline
862     ) external payable returns (uint[] memory amounts);
863 
864     function swapTokensForExactETH(
865         uint amountOut,
866         uint amountInMax,
867         address[] calldata path,
868         address to,
869         uint deadline
870     ) external returns (uint[] memory amounts);
871 
872     function swapExactTokensForETH(
873         uint amountIn,
874         uint amountOutMin,
875         address[] calldata path,
876         address to,
877         uint deadline
878     ) external returns (uint[] memory amounts);
879 
880     function swapETHForExactTokens(
881         uint amountOut,
882         address[] calldata path,
883         address to,
884         uint deadline
885     ) external payable returns (uint[] memory amounts);
886 
887     function quote(
888         uint amountA,
889         uint reserveA,
890         uint reserveB
891     ) external pure returns (uint amountB);
892 
893     function getAmountOut(
894         uint amountIn,
895         uint reserveIn,
896         uint reserveOut
897     ) external pure returns (uint amountOut);
898 
899     function getAmountIn(
900         uint amountOut,
901         uint reserveIn,
902         uint reserveOut
903     ) external pure returns (uint amountIn);
904 
905     function getAmountsOut(
906         uint amountIn,
907         address[] calldata path
908     ) external view returns (uint[] memory amounts);
909 
910     function getAmountsIn(
911         uint amountOut,
912         address[] calldata path
913     ) external view returns (uint[] memory amounts);
914 }
915 
916 interface IUniswapV2Router02 is IUniswapV2Router01 {
917     function removeLiquidityETHSupportingFeeOnTransferTokens(
918         address token,
919         uint liquidity,
920         uint amountTokenMin,
921         uint amountETHMin,
922         address to,
923         uint deadline
924     ) external returns (uint amountETH);
925 
926     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
927         address token,
928         uint liquidity,
929         uint amountTokenMin,
930         uint amountETHMin,
931         address to,
932         uint deadline,
933         bool approveMax,
934         uint8 v,
935         bytes32 r,
936         bytes32 s
937     ) external returns (uint amountETH);
938 
939     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
940         uint amountIn,
941         uint amountOutMin,
942         address[] calldata path,
943         address to,
944         uint deadline
945     ) external;
946 
947     function swapExactETHForTokensSupportingFeeOnTransferTokens(
948         uint amountOutMin,
949         address[] calldata path,
950         address to,
951         uint deadline
952     ) external payable;
953 
954     function swapExactTokensForETHSupportingFeeOnTransferTokens(
955         uint amountIn,
956         uint amountOutMin,
957         address[] calldata path,
958         address to,
959         uint deadline
960     ) external;
961 }
962 
963 contract MILFTOKENOFFICIAL is ERC20, Ownable {
964     uint256 public sellFeeRate = 5; // transaction fee sell
965     uint256 public buyFeeRate = 0;// transaction fee buy
966 
967     mapping (address => bool) public _isWhiteListedFromFee;
968     mapping(address => bool) public isBlackListed;
969     bool public _isTradeOpen = true;
970 
971     address public collectionWallet = 0x7533a3303C44200F6DE38351aef153283a28747b;
972 
973     IUniswapV2Router02 public immutable uniswapV2Router;
974     address public immutable uniswapV2Pair;
975 
976 
977     constructor() ERC20("MILF Token Official", "$MILF") {
978         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
979             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
980         );
981         // CREATE A UNISWAP PAIR FOR THIS NEW TOKEN
982         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
983             .createPair(address(this), _uniswapV2Router.WETH());
984         // SET THE REST OF THE CONTRACT VARIABLES
985         uniswapV2Router = _uniswapV2Router;
986 
987         // MINT INITIAL SUPPLY
988         _mint(msg.sender, 420000000000000 * 10 ** decimals());
989 
990         //WHITELIST PROJECT WALLETS FROM FEES
991         _isWhiteListedFromFee[owner()] = true;
992         _isWhiteListedFromFee[collectionWallet] = true;
993 
994     }
995 
996     function _transfer(
997         address sender,
998         address recipient,
999         uint256 amount
1000     ) internal virtual override {
1001         require(amount > 0, "Transfer amount must be greater than zero");
1002         require(isBlackListed[sender] != true && isBlackListed[recipient] != true, "Account is Blacklisted");
1003 
1004         uint256 transferAmount = amount;
1005 
1006         if (sender != owner() && recipient != owner()){
1007             require(_isTradeOpen, "Trade is not open");
1008         }
1009 
1010         if(!_isWhiteListedFromFee[sender] && !_isWhiteListedFromFee[recipient]){
1011 
1012         if(buyFeeRate > 0) {
1013         if (sender == uniswapV2Pair) {
1014             // TRANSACTION FEE
1015             uint256 feeOne = (amount * buyFeeRate) / 100;
1016             transferAmount = amount - feeOne;
1017             super._transfer(sender, collectionWallet, feeOne);
1018         }
1019         }
1020 
1021         if(sellFeeRate > 0) {
1022         if (recipient == uniswapV2Pair) {
1023             // TRANSACTION FEE
1024             uint256 fee = (amount * sellFeeRate) / 100;
1025             transferAmount = amount - fee;
1026             super._transfer(sender, collectionWallet, fee);
1027         }
1028         }
1029         }
1030         super._transfer(sender, recipient, transferAmount);
1031     }
1032 
1033     function whiteListFromFee(address account) public onlyOwner {
1034         _isWhiteListedFromFee[account] = true;
1035     }
1036 
1037     function includeInFee(address account) public onlyOwner{
1038         _isWhiteListedFromFee[account] = false;
1039     }
1040 
1041     function blackListAccount(address account) external onlyOwner {
1042         isBlackListed[account] = true;
1043     }
1044 
1045     function unBlackListAccount(address account) external onlyOwner  {
1046         isBlackListed[account] = false;
1047     }
1048 
1049     function openOrcloseTrade(bool _status) public onlyOwner {
1050         _isTradeOpen = _status;
1051     }
1052 
1053     function setBuyTax(uint256 amount) public onlyOwner {
1054         buyFeeRate = amount;
1055     }
1056 
1057     function setSellTax(uint256 amount) public onlyOwner {
1058         sellFeeRate = amount;
1059     }
1060 
1061     function setCollectionWallet(address _wallet) public onlyOwner {
1062         collectionWallet = _wallet;
1063     }
1064 }