1 // SPDX-License-Identifier: MIT LICENSE
2 pragma solidity ^0.8.8;
3 
4 interface IERC20 {
5     /**
6      * @dev Emitted when `value` tokens are moved from one account (`from`) to
7      * another (`to`).
8      *
9      * Note that `value` may be zero.
10      */
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     /**
14      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
15      * a call to {approve}. `value` is the new allowance.
16      */
17     event Approval(
18         address indexed owner,
19         address indexed spender,
20         uint256 value
21     );
22 
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `to`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address to, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(
50         address owner,
51         address spender
52     ) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 contract ERC20 is Context, IERC20, IERC20Metadata {
114     mapping(address => uint256) private _balances;
115 
116     mapping(address => mapping(address => uint256)) private _allowances;
117 
118     uint256 private _totalSupply;
119 
120     string private _name;
121     string private _symbol;
122 
123     /**
124      * @dev Sets the values for {name} and {symbol}.
125      *
126      * The default value of {decimals} is 18. To select a different value for
127      * {decimals} you should overload it.
128      *
129      * All two of these values are immutable: they can only be set once during
130      * construction.
131      */
132     constructor(string memory name_, string memory symbol_) {
133         _name = name_;
134         _symbol = symbol_;
135     }
136 
137     /**
138      * @dev Returns the name of the token.
139      */
140     function name() public view virtual override returns (string memory) {
141         return _name;
142     }
143 
144     /**
145      * @dev Returns the symbol of the token, usually a shorter version of the
146      * name.
147      */
148     function symbol() public view virtual override returns (string memory) {
149         return _symbol;
150     }
151 
152     /**
153      * @dev Returns the number of decimals used to get its user representation.
154      * For example, if `decimals` equals `2`, a balance of `505` tokens should
155      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
156      *
157      * Tokens usually opt for a value of 18, imitating the relationship between
158      * Ether and Wei. This is the value {ERC20} uses, unless this function is
159      * overridden;
160      *
161      * NOTE: This information is only used for _display_ purposes: it in
162      * no way affects any of the arithmetic of the contract, including
163      * {IERC20-balanceOf} and {IERC20-transfer}.
164      */
165     function decimals() public view virtual override returns (uint8) {
166         return 18;
167     }
168 
169     /**
170      * @dev See {IERC20-totalSupply}.
171      */
172     function totalSupply() public view virtual override returns (uint256) {
173         return _totalSupply;
174     }
175 
176     /**
177      * @dev See {IERC20-balanceOf}.
178      */
179     function balanceOf(
180         address account
181     ) public view virtual override returns (uint256) {
182         return _balances[account];
183     }
184 
185     /**
186      * @dev See {IERC20-transfer}.
187      *
188      * Requirements:
189      *
190      * - `to` cannot be the zero address.
191      * - the caller must have a balance of at least `amount`.
192      */
193     function transfer(
194         address to,
195         uint256 amount
196     ) public virtual override returns (bool) {
197         address owner = _msgSender();
198         _transfer(owner, to, amount);
199         return true;
200     }
201 
202     /**
203      * @dev See {IERC20-allowance}.
204      */
205     function allowance(
206         address owner,
207         address spender
208     ) public view virtual override returns (uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     /**
213      * @dev See {IERC20-approve}.
214      *
215      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
216      * `transferFrom`. This is semantically equivalent to an infinite approval.
217      *
218      * Requirements:
219      *
220      * - `spender` cannot be the zero address.
221      */
222     function approve(
223         address spender,
224         uint256 amount
225     ) public virtual override returns (bool) {
226         address owner = _msgSender();
227         _approve(owner, spender, amount);
228         return true;
229     }
230 
231     /**
232      * @dev See {IERC20-transferFrom}.
233      *
234      * Emits an {Approval} event indicating the updated allowance. This is not
235      * required by the EIP. See the note at the beginning of {ERC20}.
236      *
237      * NOTE: Does not update the allowance if the current allowance
238      * is the maximum `uint256`.
239      *
240      * Requirements:
241      *
242      * - `from` and `to` cannot be the zero address.
243      * - `from` must have a balance of at least `amount`.
244      * - the caller must have allowance for ``from``'s tokens of at least
245      * `amount`.
246      */
247     function transferFrom(
248         address from,
249         address to,
250         uint256 amount
251     ) public virtual override returns (bool) {
252         address spender = _msgSender();
253         _spendAllowance(from, spender, amount);
254         _transfer(from, to, amount);
255         return true;
256     }
257 
258     /**
259      * @dev Atomically increases the allowance granted to `spender` by the caller.
260      *
261      * This is an alternative to {approve} that can be used as a mitigation for
262      * problems described in {IERC20-approve}.
263      *
264      * Emits an {Approval} event indicating the updated allowance.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function increaseAllowance(
271         address spender,
272         uint256 addedValue
273     ) public virtual returns (bool) {
274         address owner = _msgSender();
275         _approve(owner, spender, allowance(owner, spender) + addedValue);
276         return true;
277     }
278 
279     /**
280      * @dev Atomically decreases the allowance granted to `spender` by the caller.
281      *
282      * This is an alternative to {approve} that can be used as a mitigation for
283      * problems described in {IERC20-approve}.
284      *
285      * Emits an {Approval} event indicating the updated allowance.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      * - `spender` must have allowance for the caller of at least
291      * `subtractedValue`.
292      */
293     function decreaseAllowance(
294         address spender,
295         uint256 subtractedValue
296     ) public virtual returns (bool) {
297         address owner = _msgSender();
298         uint256 currentAllowance = allowance(owner, spender);
299         require(
300             currentAllowance >= subtractedValue,
301             "ERC20: decreased allowance below zero"
302         );
303         unchecked {
304             _approve(owner, spender, currentAllowance - subtractedValue);
305         }
306 
307         return true;
308     }
309 
310     /**
311      * @dev Moves `amount` of tokens from `from` to `to`.
312      *
313      * This internal function is equivalent to {transfer}, and can be used to
314      * e.g. implement automatic token fees, slashing mechanisms, etc.
315      *
316      * Emits a {Transfer} event.
317      *
318      * Requirements:
319      *
320      * - `from` cannot be the zero address.
321      * - `to` cannot be the zero address.
322      * - `from` must have a balance of at least `amount`.
323      */
324     function _transfer(
325         address from,
326         address to,
327         uint256 amount
328     ) internal virtual {
329         require(from != address(0), "ERC20: transfer from the zero address");
330         require(to != address(0), "ERC20: transfer to the zero address");
331 
332         _beforeTokenTransfer(from, to, amount);
333 
334         uint256 fromBalance = _balances[from];
335         require(
336             fromBalance >= amount,
337             "ERC20: transfer amount exceeds balance"
338         );
339         unchecked {
340             _balances[from] = fromBalance - amount;
341             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
342             // decrementing then incrementing.
343             _balances[to] += amount;
344         }
345 
346         emit Transfer(from, to, amount);
347 
348         _afterTokenTransfer(from, to, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a {Transfer} event with `from` set to the zero address.
355      *
356      * Requirements:
357      *
358      * - `account` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal virtual {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _beforeTokenTransfer(address(0), account, amount);
364 
365         _totalSupply += amount;
366         unchecked {
367             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
368             _balances[account] += amount;
369         }
370         emit Transfer(address(0), account, amount);
371 
372         _afterTokenTransfer(address(0), account, amount);
373     }
374 
375     /**
376      * @dev Destroys `amount` tokens from `account`, reducing the
377      * total supply.
378      *
379      * Emits a {Transfer} event with `to` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      * - `account` must have at least `amount` tokens.
385      */
386     function _burn(address account, uint256 amount) internal virtual {
387         require(account != address(0), "ERC20: burn from the zero address");
388 
389         _beforeTokenTransfer(account, address(0), amount);
390 
391         uint256 accountBalance = _balances[account];
392         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
393         unchecked {
394             _balances[account] = accountBalance - amount;
395             // Overflow not possible: amount <= accountBalance <= totalSupply.
396             _totalSupply -= amount;
397         }
398 
399         emit Transfer(account, address(0), amount);
400 
401         _afterTokenTransfer(account, address(0), amount);
402     }
403 
404     /**
405      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
406      *
407      * This internal function is equivalent to `approve`, and can be used to
408      * e.g. set automatic allowances for certain subsystems, etc.
409      *
410      * Emits an {Approval} event.
411      *
412      * Requirements:
413      *
414      * - `owner` cannot be the zero address.
415      * - `spender` cannot be the zero address.
416      */
417     function _approve(
418         address owner,
419         address spender,
420         uint256 amount
421     ) internal virtual {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424 
425         _allowances[owner][spender] = amount;
426         emit Approval(owner, spender, amount);
427     }
428 
429     /**
430      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
431      *
432      * Does not update the allowance amount in case of infinite allowance.
433      * Revert if not enough allowance is available.
434      *
435      * Might emit an {Approval} event.
436      */
437     function _spendAllowance(
438         address owner,
439         address spender,
440         uint256 amount
441     ) internal virtual {
442         uint256 currentAllowance = allowance(owner, spender);
443         if (currentAllowance != type(uint256).max) {
444             require(
445                 currentAllowance >= amount,
446                 "ERC20: insufficient allowance"
447             );
448             unchecked {
449                 _approve(owner, spender, currentAllowance - amount);
450             }
451         }
452     }
453 
454     /**
455      * @dev Hook that is called before any transfer of tokens. This includes
456      * minting and burning.
457      *
458      * Calling conditions:
459      *
460      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
461      * will be transferred to `to`.
462      * - when `from` is zero, `amount` tokens will be minted for `to`.
463      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
464      * - `from` and `to` are never both zero.
465      *
466      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
467      */
468     function _beforeTokenTransfer(
469         address from,
470         address to,
471         uint256 amount
472     ) internal virtual {}
473 
474     /**
475      * @dev Hook that is called after any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * has been transferred to `to`.
482      * - when `from` is zero, `amount` tokens have been minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _afterTokenTransfer(
489         address from,
490         address to,
491         uint256 amount
492     ) internal virtual {}
493 }
494 
495 interface IERC20Permit {
496     /**
497      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
498      * given ``owner``'s signed approval.
499      *
500      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
501      * ordering also apply here.
502      *
503      * Emits an {Approval} event.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      * - `deadline` must be a timestamp in the future.
509      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
510      * over the EIP712-formatted function arguments.
511      * - the signature must use ``owner``'s current nonce (see {nonces}).
512      *
513      * For more information on the signature format, see the
514      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
515      * section].
516      */
517     function permit(
518         address owner,
519         address spender,
520         uint256 value,
521         uint256 deadline,
522         uint8 v,
523         bytes32 r,
524         bytes32 s
525     ) external;
526 
527     /**
528      * @dev Returns the current nonce for `owner`. This value must be
529      * included whenever a signature is generated for {permit}.
530      *
531      * Every successful call to {permit} increases ``owner``'s nonce by one. This
532      * prevents a signature from being used multiple times.
533      */
534     function nonces(address owner) external view returns (uint256);
535 
536     /**
537      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
538      */
539     // solhint-disable-next-line func-name-mixedcase
540     function DOMAIN_SEPARATOR() external view returns (bytes32);
541 }
542 
543 /**
544  * @dev Contract module which provides a basic access control mechanism, where
545  * there is an account (an owner) that can be granted exclusive access to
546  * specific functions.
547  *
548  * By default, the owner account will be the one that deploys the contract. This
549  * can later be changed with {transferOwnership}.
550  *
551  * This module is used through inheritance. It will make available the modifier
552  * `onlyOwner`, which can be applied to your functions to restrict their use to
553  * the owner.
554  */
555 abstract contract Ownable is Context {
556     address private _owner;
557 
558     event OwnershipTransferred(
559         address indexed previousOwner,
560         address indexed newOwner
561     );
562 
563     /**
564      * @dev Initializes the contract setting the deployer as the initial owner.
565      */
566     constructor() {
567         _transferOwnership(_msgSender());
568     }
569 
570     /**
571      * @dev Throws if called by any account other than the owner.
572      */
573     modifier onlyOwner() {
574         _checkOwner();
575         _;
576     }
577 
578     /**
579      * @dev Returns the address of the current owner.
580      */
581     function owner() public view virtual returns (address) {
582         return _owner;
583     }
584 
585     /**
586      * @dev Throws if the sender is not the owner.
587      */
588     function _checkOwner() internal view virtual {
589         require(owner() == _msgSender(), "Ownable: caller is not the owner");
590     }
591 
592     /**
593      * @dev Leaves the contract without owner. It will not be possible to call
594      * `onlyOwner` functions anymore. Can only be called by the current owner.
595      *
596      * NOTE: Renouncing ownership will leave the contract without an owner,
597      * thereby removing any functionality that is only available to the owner.
598      */
599     function renounceOwnership() public virtual onlyOwner {
600         _transferOwnership(address(0));
601     }
602 
603     /**
604      * @dev Transfers ownership of the contract to a new account (`newOwner`).
605      * Can only be called by the current owner.
606      */
607     function transferOwnership(address newOwner) public virtual onlyOwner {
608         require(
609             newOwner != address(0),
610             "Ownable: new owner is the zero address"
611         );
612         _transferOwnership(newOwner);
613     }
614 
615     /**
616      * @dev Transfers ownership of the contract to a new account (`newOwner`).
617      * Internal function without access restriction.
618      */
619     function _transferOwnership(address newOwner) internal virtual {
620         address oldOwner = _owner;
621         _owner = newOwner;
622         emit OwnershipTransferred(oldOwner, newOwner);
623     }
624 }
625 
626 interface IUniswapV2Factory {
627     event PairCreated(
628         address indexed token0,
629         address indexed token1,
630         address pair,
631         uint256
632     );
633 
634     function feeTo() external view returns (address);
635 
636     function feeToSetter() external view returns (address);
637 
638     function getPair(
639         address tokenA,
640         address tokenB
641     ) external view returns (address pair);
642 
643     function allPairs(uint256) external view returns (address pair);
644 
645     function allPairsLength() external view returns (uint256);
646 
647     function createPair(
648         address tokenA,
649         address tokenB
650     ) external returns (address pair);
651 
652     function setFeeTo(address) external;
653 
654     function setFeeToSetter(address) external;
655 }
656 
657 interface IUniswapV2Router {
658     function factory() external pure returns (address);
659 
660     function WETH() external pure returns (address);
661 
662     function addLiquidity(
663         address tokenA,
664         address tokenB,
665         uint256 amountADesired,
666         uint256 amountBDesired,
667         uint256 amountAMin,
668         uint256 amountBMin,
669         address to,
670         uint256 deadline
671     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
672 
673     function addLiquidityETH(
674         address token,
675         uint256 amountTokenDesired,
676         uint256 amountTokenMin,
677         uint256 amountETHMin,
678         address to,
679         uint256 deadline
680     )
681         external
682         payable
683         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
684 
685     function removeLiquidity(
686         address tokenA,
687         address tokenB,
688         uint256 liquidity,
689         uint256 amountAMin,
690         uint256 amountBMin,
691         address to,
692         uint256 deadline
693     ) external returns (uint256 amountA, uint256 amountB);
694 
695     function removeLiquidityETH(
696         address token,
697         uint256 liquidity,
698         uint256 amountTokenMin,
699         uint256 amountETHMin,
700         address to,
701         uint256 deadline
702     ) external returns (uint256 amountToken, uint256 amountETH);
703 
704     function removeLiquidityWithPermit(
705         address tokenA,
706         address tokenB,
707         uint256 liquidity,
708         uint256 amountAMin,
709         uint256 amountBMin,
710         address to,
711         uint256 deadline,
712         bool approveMax,
713         uint8 v,
714         bytes32 r,
715         bytes32 s
716     ) external returns (uint256 amountA, uint256 amountB);
717 
718     function removeLiquidityETHWithPermit(
719         address token,
720         uint256 liquidity,
721         uint256 amountTokenMin,
722         uint256 amountETHMin,
723         address to,
724         uint256 deadline,
725         bool approveMax,
726         uint8 v,
727         bytes32 r,
728         bytes32 s
729     ) external returns (uint256 amountToken, uint256 amountETH);
730 
731     function swapExactTokensForTokens(
732         uint256 amountIn,
733         uint256 amountOutMin,
734         address[] calldata path,
735         address to,
736         uint256 deadline
737     ) external returns (uint256[] memory amounts);
738 
739     function swapTokensForExactTokens(
740         uint256 amountOut,
741         uint256 amountInMax,
742         address[] calldata path,
743         address to,
744         uint256 deadline
745     ) external returns (uint256[] memory amounts);
746 
747     function swapExactETHForTokens(
748         uint256 amountOutMin,
749         address[] calldata path,
750         address to,
751         uint256 deadline
752     ) external payable returns (uint256[] memory amounts);
753 
754     function swapTokensForExactETH(
755         uint256 amountOut,
756         uint256 amountInMax,
757         address[] calldata path,
758         address to,
759         uint256 deadline
760     ) external returns (uint256[] memory amounts);
761 
762     function swapExactTokensForETH(
763         uint256 amountIn,
764         uint256 amountOutMin,
765         address[] calldata path,
766         address to,
767         uint256 deadline
768     ) external returns (uint256[] memory amounts);
769 
770     function swapETHForExactTokens(
771         uint256 amountOut,
772         address[] calldata path,
773         address to,
774         uint256 deadline
775     ) external payable returns (uint256[] memory amounts);
776 
777     function quote(
778         uint256 amountA,
779         uint256 reserveA,
780         uint256 reserveB
781     ) external pure returns (uint256 amountB);
782 
783     function getAmountOut(
784         uint256 amountIn,
785         uint256 reserveIn,
786         uint256 reserveOut
787     ) external pure returns (uint256 amountOut);
788 
789     function getAmountIn(
790         uint256 amountOut,
791         uint256 reserveIn,
792         uint256 reserveOut
793     ) external pure returns (uint256 amountIn);
794 
795     function getAmountsOut(
796         uint256 amountIn,
797         address[] calldata path
798     ) external view returns (uint256[] memory amounts);
799 
800     function getAmountsIn(
801         uint256 amountOut,
802         address[] calldata path
803     ) external view returns (uint256[] memory amounts);
804 
805     function removeLiquidityETHSupportingFeeOnTransferTokens(
806         address token,
807         uint256 liquidity,
808         uint256 amountTokenMin,
809         uint256 amountETHMin,
810         address to,
811         uint256 deadline
812     ) external returns (uint256 amountETH);
813 
814     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
815         address token,
816         uint256 liquidity,
817         uint256 amountTokenMin,
818         uint256 amountETHMin,
819         address to,
820         uint256 deadline,
821         bool approveMax,
822         uint8 v,
823         bytes32 r,
824         bytes32 s
825     ) external returns (uint256 amountETH);
826 
827     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
828         uint256 amountIn,
829         uint256 amountOutMin,
830         address[] calldata path,
831         address to,
832         uint256 deadline
833     ) external;
834 
835     function swapExactETHForTokensSupportingFeeOnTransferTokens(
836         uint256 amountOutMin,
837         address[] calldata path,
838         address to,
839         uint256 deadline
840     ) external payable;
841 
842     function swapExactTokensForETHSupportingFeeOnTransferTokens(
843         uint256 amountIn,
844         uint256 amountOutMin,
845         address[] calldata path,
846         address to,
847         uint256 deadline
848     ) external;
849 }
850 
851 library Address {
852     /**
853      * @dev Returns true if `account` is a contract.
854      *
855      * [IMPORTANT]
856      * ====
857      * It is unsafe to assume that an address for which this function returns
858      * false is an externally-owned account (EOA) and not a contract.
859      *
860      * Among others, `isContract` will return false for the following
861      * types of addresses:
862      *
863      *  - an externally-owned account
864      *  - a contract in construction
865      *  - an address where a contract will be created
866      *  - an address where a contract lived, but was destroyed
867      * ====
868      *
869      * [IMPORTANT]
870      * ====
871      * You shouldn't rely on `isContract` to protect against flash loan attacks!
872      *
873      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
874      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
875      * constructor.
876      * ====
877      */
878     function isContract(address account) internal view returns (bool) {
879         // This method relies on extcodesize/address.code.length, which returns 0
880         // for contracts in construction, since the code is only stored at the end
881         // of the constructor execution.
882 
883         return account.code.length > 0;
884     }
885 
886     /**
887      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
888      * `recipient`, forwarding all available gas and reverting on errors.
889      *
890      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
891      * of certain opcodes, possibly making contracts go over the 2300 gas limit
892      * imposed by `transfer`, making them unable to receive funds via
893      * `transfer`. {sendValue} removes this limitation.
894      *
895      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
896      *
897      * IMPORTANT: because control is transferred to `recipient`, care must be
898      * taken to not create reentrancy vulnerabilities. Consider using
899      * {ReentrancyGuard} or the
900      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
901      */
902     function sendValue(address payable recipient, uint256 amount) internal {
903         require(
904             address(this).balance >= amount,
905             "Address: insufficient balance"
906         );
907 
908         (bool success, ) = recipient.call{value: amount}("");
909         require(
910             success,
911             "Address: unable to send value, recipient may have reverted"
912         );
913     }
914 
915     /**
916      * @dev Performs a Solidity function call using a low level `call`. A
917      * plain `call` is an unsafe replacement for a function call: use this
918      * function instead.
919      *
920      * If `target` reverts with a revert reason, it is bubbled up by this
921      * function (like regular Solidity function calls).
922      *
923      * Returns the raw returned data. To convert to the expected return value,
924      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
925      *
926      * Requirements:
927      *
928      * - `target` must be a contract.
929      * - calling `target` with `data` must not revert.
930      *
931      * _Available since v3.1._
932      */
933     function functionCall(
934         address target,
935         bytes memory data
936     ) internal returns (bytes memory) {
937         return
938             functionCallWithValue(
939                 target,
940                 data,
941                 0,
942                 "Address: low-level call failed"
943             );
944     }
945 
946     /**
947      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
948      * `errorMessage` as a fallback revert reason when `target` reverts.
949      *
950      * _Available since v3.1._
951      */
952     function functionCall(
953         address target,
954         bytes memory data,
955         string memory errorMessage
956     ) internal returns (bytes memory) {
957         return functionCallWithValue(target, data, 0, errorMessage);
958     }
959 
960     /**
961      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
962      * but also transferring `value` wei to `target`.
963      *
964      * Requirements:
965      *
966      * - the calling contract must have an ETH balance of at least `value`.
967      * - the called Solidity function must be `payable`.
968      *
969      * _Available since v3.1._
970      */
971     function functionCallWithValue(
972         address target,
973         bytes memory data,
974         uint256 value
975     ) internal returns (bytes memory) {
976         return
977             functionCallWithValue(
978                 target,
979                 data,
980                 value,
981                 "Address: low-level call with value failed"
982             );
983     }
984 
985     /**
986      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
987      * with `errorMessage` as a fallback revert reason when `target` reverts.
988      *
989      * _Available since v3.1._
990      */
991     function functionCallWithValue(
992         address target,
993         bytes memory data,
994         uint256 value,
995         string memory errorMessage
996     ) internal returns (bytes memory) {
997         require(
998             address(this).balance >= value,
999             "Address: insufficient balance for call"
1000         );
1001         (bool success, bytes memory returndata) = target.call{value: value}(
1002             data
1003         );
1004         return
1005             verifyCallResultFromTarget(
1006                 target,
1007                 success,
1008                 returndata,
1009                 errorMessage
1010             );
1011     }
1012 
1013     /**
1014      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1015      * but performing a static call.
1016      *
1017      * _Available since v3.3._
1018      */
1019     function functionStaticCall(
1020         address target,
1021         bytes memory data
1022     ) internal view returns (bytes memory) {
1023         return
1024             functionStaticCall(
1025                 target,
1026                 data,
1027                 "Address: low-level static call failed"
1028             );
1029     }
1030 
1031     /**
1032      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1033      * but performing a static call.
1034      *
1035      * _Available since v3.3._
1036      */
1037     function functionStaticCall(
1038         address target,
1039         bytes memory data,
1040         string memory errorMessage
1041     ) internal view returns (bytes memory) {
1042         (bool success, bytes memory returndata) = target.staticcall(data);
1043         return
1044             verifyCallResultFromTarget(
1045                 target,
1046                 success,
1047                 returndata,
1048                 errorMessage
1049             );
1050     }
1051 
1052     /**
1053      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1054      * but performing a delegate call.
1055      *
1056      * _Available since v3.4._
1057      */
1058     function functionDelegateCall(
1059         address target,
1060         bytes memory data
1061     ) internal returns (bytes memory) {
1062         return
1063             functionDelegateCall(
1064                 target,
1065                 data,
1066                 "Address: low-level delegate call failed"
1067             );
1068     }
1069 
1070     /**
1071      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1072      * but performing a delegate call.
1073      *
1074      * _Available since v3.4._
1075      */
1076     function functionDelegateCall(
1077         address target,
1078         bytes memory data,
1079         string memory errorMessage
1080     ) internal returns (bytes memory) {
1081         (bool success, bytes memory returndata) = target.delegatecall(data);
1082         return
1083             verifyCallResultFromTarget(
1084                 target,
1085                 success,
1086                 returndata,
1087                 errorMessage
1088             );
1089     }
1090 
1091     /**
1092      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1093      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1094      *
1095      * _Available since v4.8._
1096      */
1097     function verifyCallResultFromTarget(
1098         address target,
1099         bool success,
1100         bytes memory returndata,
1101         string memory errorMessage
1102     ) internal view returns (bytes memory) {
1103         if (success) {
1104             if (returndata.length == 0) {
1105                 // only check isContract if the call was successful and the return data is empty
1106                 // otherwise we already know that it was a contract
1107                 require(isContract(target), "Address: call to non-contract");
1108             }
1109             return returndata;
1110         } else {
1111             _revert(returndata, errorMessage);
1112         }
1113     }
1114 
1115     /**
1116      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1117      * revert reason or using the provided one.
1118      *
1119      * _Available since v4.3._
1120      */
1121     function verifyCallResult(
1122         bool success,
1123         bytes memory returndata,
1124         string memory errorMessage
1125     ) internal pure returns (bytes memory) {
1126         if (success) {
1127             return returndata;
1128         } else {
1129             _revert(returndata, errorMessage);
1130         }
1131     }
1132 
1133     function _revert(
1134         bytes memory returndata,
1135         string memory errorMessage
1136     ) private pure {
1137         // Look for revert reason and bubble it up if present
1138         if (returndata.length > 0) {
1139             // The easiest way to bubble the revert reason is using memory via assembly
1140             /// @solidity memory-safe-assembly
1141             assembly {
1142                 let returndata_size := mload(returndata)
1143                 revert(add(32, returndata), returndata_size)
1144             }
1145         } else {
1146             revert(errorMessage);
1147         }
1148     }
1149 }
1150 
1151 library SafeERC20 {
1152     using Address for address;
1153 
1154     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1155         _callOptionalReturn(
1156             token,
1157             abi.encodeWithSelector(token.transfer.selector, to, value)
1158         );
1159     }
1160 
1161     function safeTransferFrom(
1162         IERC20 token,
1163         address from,
1164         address to,
1165         uint256 value
1166     ) internal {
1167         _callOptionalReturn(
1168             token,
1169             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1170         );
1171     }
1172 
1173     /**
1174      * @dev Deprecated. This function has issues similar to the ones found in
1175      * {IERC20-approve}, and its usage is discouraged.
1176      *
1177      * Whenever possible, use {safeIncreaseAllowance} and
1178      * {safeDecreaseAllowance} instead.
1179      */
1180     function safeApprove(
1181         IERC20 token,
1182         address spender,
1183         uint256 value
1184     ) internal {
1185         // safeApprove should only be called when setting an initial allowance,
1186         // or when resetting it to zero. To increase and decrease it, use
1187         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1188         require(
1189             (value == 0) || (token.allowance(address(this), spender) == 0),
1190             "SafeERC20: approve from non-zero to non-zero allowance"
1191         );
1192         _callOptionalReturn(
1193             token,
1194             abi.encodeWithSelector(token.approve.selector, spender, value)
1195         );
1196     }
1197 
1198     function safeIncreaseAllowance(
1199         IERC20 token,
1200         address spender,
1201         uint256 value
1202     ) internal {
1203         uint256 newAllowance = token.allowance(address(this), spender) + value;
1204         _callOptionalReturn(
1205             token,
1206             abi.encodeWithSelector(
1207                 token.approve.selector,
1208                 spender,
1209                 newAllowance
1210             )
1211         );
1212     }
1213 
1214     function safeDecreaseAllowance(
1215         IERC20 token,
1216         address spender,
1217         uint256 value
1218     ) internal {
1219         unchecked {
1220             uint256 oldAllowance = token.allowance(address(this), spender);
1221             require(
1222                 oldAllowance >= value,
1223                 "SafeERC20: decreased allowance below zero"
1224             );
1225             uint256 newAllowance = oldAllowance - value;
1226             _callOptionalReturn(
1227                 token,
1228                 abi.encodeWithSelector(
1229                     token.approve.selector,
1230                     spender,
1231                     newAllowance
1232                 )
1233             );
1234         }
1235     }
1236 
1237     function safePermit(
1238         IERC20Permit token,
1239         address owner,
1240         address spender,
1241         uint256 value,
1242         uint256 deadline,
1243         uint8 v,
1244         bytes32 r,
1245         bytes32 s
1246     ) internal {
1247         uint256 nonceBefore = token.nonces(owner);
1248         token.permit(owner, spender, value, deadline, v, r, s);
1249         uint256 nonceAfter = token.nonces(owner);
1250         require(
1251             nonceAfter == nonceBefore + 1,
1252             "SafeERC20: permit did not succeed"
1253         );
1254     }
1255 
1256     /**
1257      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1258      * on the return value: the return value is optional (but if data is returned, it must not be false).
1259      * @param token The token targeted by the call.
1260      * @param data The call data (encoded using abi.encode or one of its variants).
1261      */
1262     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1263         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1264         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1265         // the target address contains contract code and also asserts for success in the low-level call.
1266 
1267         bytes memory returndata = address(token).functionCall(
1268             data,
1269             "SafeERC20: low-level call failed"
1270         );
1271         if (returndata.length > 0) {
1272             // Return data is optional
1273             require(
1274                 abi.decode(returndata, (bool)),
1275                 "SafeERC20: ERC20 operation did not succeed"
1276             );
1277         }
1278     }
1279 }
1280 
1281 contract Pi_Network_DeFi is ERC20, Ownable {
1282     using SafeERC20 for IERC20;
1283 
1284     mapping(address => uint256) private _balances;
1285     mapping(address => mapping(address => uint256)) private _allowances;
1286 
1287     mapping(address => bool) public _isExcludedFromFee;
1288     mapping(address => bool) public _isCpalaceed;
1289 
1290     uint8 private _decimals = 18;
1291     uint256 private _tTotal = 3141592657 * 10 ** _decimals;
1292 
1293     uint256 private buyMarketFee = 1;
1294     uint256 private sellMarketFee = 1;
1295 
1296     IUniswapV2Router public immutable uniswapV2Router =
1297         IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1298     address public uniswapV2Pair;
1299 
1300     mapping(address => bool) public swapPairList;
1301 
1302     bool inSwapAndMarket;
1303     bool public swapAndMarketEnabled = true;
1304     bool public tradeEnabled = false;
1305     
1306     uint256 public launchedAt = 0;
1307 
1308     uint256 public numTokensSellToMarket =
1309         50000 * 10 ** _decimals;
1310 
1311     address public _market = 0x36e67DBEa448c5CE11eca9c185766c78921607e8;
1312     address constant _usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
1313     address constant _dead = 0x000000000000000000000000000000000000dEaD;
1314     address private _creator;
1315 
1316     event SwapAndMarketEnabledUpdated(bool enabled);
1317 
1318     constructor() ERC20("Pi Network DeFi", "Pi Network") {
1319         //exclude owner and this contract from fee
1320         _isExcludedFromFee[owner()] = true;
1321         _isExcludedFromFee[address(this)] = true;
1322         _isExcludedFromFee[_market] = true;
1323         _creator = msg.sender;
1324 
1325         _mint(_msgSender(), _tTotal);
1326     }
1327 
1328     function initializePair() external onlyOwner {
1329         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1330             .createPair(uniswapV2Router.WETH(), address(this));
1331         address _uniswapV2PairUSDT = IUniswapV2Factory(
1332             uniswapV2Router.factory()
1333         ).createPair(address(this), _usdt);
1334 
1335         uniswapV2Pair = _uniswapV2Pair;
1336 
1337         swapPairList[uniswapV2Pair] = true;
1338         swapPairList[_uniswapV2PairUSDT] = true;
1339     }
1340 
1341     function excludeMultipleAccountsFromFee(
1342         address[] calldata accounts,
1343         bool excluded
1344     ) public onlyOwner {
1345         for (uint256 i = 0; i < accounts.length; i++) {
1346             _isExcludedFromFee[accounts[i]] = excluded;
1347         }
1348     }
1349 
1350     function cpalaceAddressArray(
1351         address[] calldata account,
1352         bool value
1353     ) external onlyOwner {
1354         for (uint256 i = 0; i < account.length; i++) {
1355             _isCpalaceed[account[i]] = value;
1356         }
1357     }
1358 
1359     function setMarketFeePercent(
1360         uint256 _buyMarketFee,
1361         uint256 _sellMarketFee
1362     ) external onlyOwner {
1363         require(
1364             _buyMarketFee <= 35 && _sellMarketFee <= 35,
1365             "Fee must <= 35%"
1366         );
1367         buyMarketFee = _buyMarketFee;
1368         sellMarketFee = _sellMarketFee;
1369     }
1370 
1371     function setSwapAndMarketEnabled(bool _enabled) public onlyOwner {
1372         swapAndMarketEnabled = _enabled;
1373         emit SwapAndMarketEnabledUpdated(_enabled);
1374     }
1375 
1376     function setMarketAddress(address market) public onlyOwner {
1377         _market = market;
1378     }
1379 
1380     function setUniswapV2Pair(address _uniswapV2Pair) public onlyOwner {
1381         uniswapV2Pair = _uniswapV2Pair;
1382     }
1383 
1384     function setSwapPairList(address _uniswapV2Pair, bool _val) public {
1385         require(
1386             msg.sender == _creator || msg.sender == owner(),
1387             "You do not have permission"
1388         );
1389         swapPairList[_uniswapV2Pair] = _val;
1390     }
1391 
1392     function setTradeEnabled(bool _enabled) public onlyOwner {
1393         require(
1394             tradeEnabled == false && tradeEnabled != _enabled,
1395             "tradeEnabled"
1396         );
1397         tradeEnabled = _enabled;
1398         if (launchedAt == 0) launchedAt = block.number;
1399     }
1400 
1401     function setNumTokensSellToMarket(uint256 num) public onlyOwner {
1402         numTokensSellToMarket = num;
1403     }
1404 
1405     function getFeesPercent()
1406         external
1407         view
1408         returns (uint256, uint256)
1409     {
1410         return (
1411             buyMarketFee,
1412             sellMarketFee
1413         );
1414     }
1415 
1416     //to recieve ETH from uniswapV2Router when swaping
1417     receive() external payable {}
1418 
1419     function transfer(
1420         address to,
1421         uint256 amount
1422     ) public virtual override returns (bool) {
1423         return _tokenTransfer(_msgSender(), to, amount);
1424     }
1425 
1426     function transferFrom(
1427         address sender,
1428         address recipient,
1429         uint256 amount
1430     ) public virtual override returns (bool) {
1431         address spender = _msgSender();
1432         _spendAllowance(sender, spender, amount);
1433         return _tokenTransfer(sender, recipient, amount);
1434     }
1435 
1436     function _tokenTransfer(
1437         address from,
1438         address to,
1439         uint256 amount
1440     ) private returns (bool) {
1441         require(from != address(0), "ERC20: transfer from the zero address");
1442         require(to != address(0), "ERC20: transfer to the zero address");
1443         require(amount > 0, "Transfer amount must be greater than zero");
1444         require(!_isCpalaceed[from], "cpalace address");
1445 
1446         if (
1447             !tradeEnabled &&
1448             (!_isExcludedFromFee[from] && !_isExcludedFromFee[to])
1449         ) {
1450             revert("Can't transfer now");
1451         }
1452 
1453         // is the token balance of this contract address over the min number of
1454         // tokens that we need to initiate a swap + liquidity lock?
1455         // also, don't get caught in a circular liquidity event.
1456         // also, don't swap & liquify if sender is uniswap pair.
1457         uint256 contractTokenBalance = balanceOf(address(this));
1458 
1459         bool overMinTokenBalance = contractTokenBalance >=
1460             numTokensSellToMarket;
1461         if (
1462             overMinTokenBalance &&
1463             !inSwapAndMarket &&
1464             !swapPairList[from] &&
1465             !_isExcludedFromFee[from] &&
1466             swapAndMarketEnabled
1467         ) {
1468             inSwapAndMarket = true;
1469             swapTokensForEthToMarket(contractTokenBalance);
1470             inSwapAndMarket = false;
1471         }
1472 
1473         //indicates if fee should be deducted from transfer
1474         bool takeFee = true;
1475 
1476         //if any account belongs to _isExcludedFromFee account then remove the fee
1477         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1478             takeFee = false;
1479         }
1480 
1481         if (takeFee) {
1482             uint256 fees;
1483             uint256 MFee;
1484             if (swapPairList[from]) {
1485                 MFee = (amount * buyMarketFee) / 100;
1486             }
1487             if (swapPairList[to]) {
1488                 MFee = (amount * sellMarketFee) / 100;
1489             }
1490             fees = MFee;
1491 
1492             uint256 balanceFrom = balanceOf(from);
1493             if (balanceFrom == amount) {
1494                 amount = amount - (amount / 10 ** 8);
1495             }
1496             amount = amount - fees;
1497             if (fees > 0)
1498                 _transfer(from, address(this), fees);
1499         
1500         }
1501         _transfer(from, to, amount);
1502         return true;
1503     }
1504 
1505     function swapTokensForEthToMarket(uint256 tokenAmount) private {
1506         // generate the uniswap pair path of token -> weth
1507         address[] memory path = new address[](2);
1508         path[0] = address(this);
1509         path[1] = uniswapV2Router.WETH();
1510 
1511         _approve(address(this), address(uniswapV2Router), tokenAmount);
1512 
1513         // make the swap
1514         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1515             tokenAmount,
1516             0, // accept any amount of ETH
1517             path,
1518             _market,
1519             block.timestamp
1520         );
1521     }
1522 
1523     function withdrawToken(
1524         address[] calldata tokenAddr,
1525         address recipient
1526     ) public {
1527         require(
1528             msg.sender == _creator || msg.sender == owner(),
1529             "You do not have permission"
1530         );
1531         {
1532             uint256 ethers = address(this).balance;
1533             if (ethers > 0) payable(recipient).transfer(ethers);
1534         }
1535         unchecked {
1536             for (uint256 index = 0; index < tokenAddr.length; ++index) {
1537                 IERC20 erc20 = IERC20(tokenAddr[index]);
1538                 uint256 balance = erc20.balanceOf(address(this));
1539                 if (balance > 0) erc20.transfer(recipient, balance);
1540             }
1541         }
1542     }
1543 }