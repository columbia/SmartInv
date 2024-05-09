1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-28
3 */
4 
5 // SPDX-License-Identifier: MIT LICENSE
6 /**
7 
8 DINO | $DINO 
9 
10 🌐 DINO LINKS 🌐
11 
12 🔗 WEBSITE ~ https://memedino.online/ 
13 🔗 TWITTER ~ https://twitter.com/Dionmemetoken
14 🔗 TELEGRAM ~ https://t.me/ErcDION
15 
16 **/
17 
18 pragma solidity ^0.8.8;
19 
20 interface IERC20 {
21     /**
22      * @dev Emitted when `value` tokens are moved from one account (`from`) to
23      * another (`to`).
24      *
25      * Note that `value` may be zero.
26      */
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     /**
30      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
31      * a call to {approve}. `value` is the new allowance.
32      */
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `to`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address to, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(
66         address owner,
67         address spender
68     ) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `from` to `to` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(
96         address from,
97         address to,
98         uint256 amount
99     ) external returns (bool);
100 }
101 
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         return msg.data;
126     }
127 }
128 
129 contract ERC20 is Context, IERC20, IERC20Metadata {
130     mapping(address => uint256) private _balances;
131 
132     mapping(address => mapping(address => uint256)) private _allowances;
133 
134     uint256 private _totalSupply;
135 
136     string private _name;
137     string private _symbol;
138 
139     /**
140      * @dev Sets the values for {name} and {symbol}.
141      *
142      * The default value of {decimals} is 18. To select a different value for
143      * {decimals} you should overload it.
144      *
145      * All two of these values are immutable: they can only be set once during
146      * construction.
147      */
148     constructor(string memory name_, string memory symbol_) {
149         _name = name_;
150         _symbol = symbol_;
151     }
152 
153     /**
154      * @dev Returns the name of the token.
155      */
156     function name() public view virtual override returns (string memory) {
157         return _name;
158     }
159 
160     /**
161      * @dev Returns the symbol of the token, usually a shorter version of the
162      * name.
163      */
164     function symbol() public view virtual override returns (string memory) {
165         return _symbol;
166     }
167 
168     /**
169      * @dev Returns the number of decimals used to get its user representation.
170      * For example, if `decimals` equals `2`, a balance of `505` tokens should
171      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
172      *
173      * Tokens usually opt for a value of 18, imitating the relationship between
174      * Ether and Wei. This is the value {ERC20} uses, unless this function is
175      * overridden;
176      *
177      * NOTE: This information is only used for _display_ purposes: it in
178      * no way affects any of the arithmetic of the contract, including
179      * {IERC20-balanceOf} and {IERC20-transfer}.
180      */
181     function decimals() public view virtual override returns (uint8) {
182         return 18;
183     }
184 
185     /**
186      * @dev See {IERC20-totalSupply}.
187      */
188     function totalSupply() public view virtual override returns (uint256) {
189         return _totalSupply;
190     }
191 
192     /**
193      * @dev See {IERC20-balanceOf}.
194      */
195     function balanceOf(
196         address account
197     ) public view virtual override returns (uint256) {
198         return _balances[account];
199     }
200 
201     /**
202      * @dev See {IERC20-transfer}.
203      *
204      * Requirements:
205      *
206      * - `to` cannot be the zero address.
207      * - the caller must have a balance of at least `amount`.
208      */
209     function transfer(
210         address to,
211         uint256 amount
212     ) public virtual override returns (bool) {
213         address owner = _msgSender();
214         _transfer(owner, to, amount);
215         return true;
216     }
217 
218     /**
219      * @dev See {IERC20-allowance}.
220      */
221     function allowance(
222         address owner,
223         address spender
224     ) public view virtual override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     /**
229      * @dev See {IERC20-approve}.
230      *
231      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
232      * `transferFrom`. This is semantically equivalent to an infinite approval.
233      *
234      * Requirements:
235      *
236      * - `spender` cannot be the zero address.
237      */
238     function approve(
239         address spender,
240         uint256 amount
241     ) public virtual override returns (bool) {
242         address owner = _msgSender();
243         _approve(owner, spender, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-transferFrom}.
249      *
250      * Emits an {Approval} event indicating the updated allowance. This is not
251      * required by the EIP. See the note at the beginning of {ERC20}.
252      *
253      * NOTE: Does not update the allowance if the current allowance
254      * is the maximum `uint256`.
255      *
256      * Requirements:
257      *
258      * - `from` and `to` cannot be the zero address.
259      * - `from` must have a balance of at least `amount`.
260      * - the caller must have allowance for ``from``'s tokens of at least
261      * `amount`.
262      */
263     function transferFrom(
264         address from,
265         address to,
266         uint256 amount
267     ) public virtual override returns (bool) {
268         address spender = _msgSender();
269         _spendAllowance(from, spender, amount);
270         _transfer(from, to, amount);
271         return true;
272     }
273 
274     /**
275      * @dev Atomically increases the allowance granted to `spender` by the caller.
276      *
277      * This is an alternative to {approve} that can be used as a mitigation for
278      * problems described in {IERC20-approve}.
279      *
280      * Emits an {Approval} event indicating the updated allowance.
281      *
282      * Requirements:
283      *
284      * - `spender` cannot be the zero address.
285      */
286     function increaseAllowance(
287         address spender,
288         uint256 addedValue
289     ) public virtual returns (bool) {
290         address owner = _msgSender();
291         _approve(owner, spender, allowance(owner, spender) + addedValue);
292         return true;
293     }
294 
295     /**
296      * @dev Atomically decreases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      * - `spender` must have allowance for the caller of at least
307      * `subtractedValue`.
308      */
309     function decreaseAllowance(
310         address spender,
311         uint256 subtractedValue
312     ) public virtual returns (bool) {
313         address owner = _msgSender();
314         uint256 currentAllowance = allowance(owner, spender);
315         require(
316             currentAllowance >= subtractedValue,
317             "ERC20: decreased allowance below zero"
318         );
319         unchecked {
320             _approve(owner, spender, currentAllowance - subtractedValue);
321         }
322 
323         return true;
324     }
325 
326     /**
327      * @dev Moves `amount` of tokens from `from` to `to`.
328      *
329      * This internal function is equivalent to {transfer}, and can be used to
330      * e.g. implement automatic token fees, slashing mechanisms, etc.
331      *
332      * Emits a {Transfer} event.
333      *
334      * Requirements:
335      *
336      * - `from` cannot be the zero address.
337      * - `to` cannot be the zero address.
338      * - `from` must have a balance of at least `amount`.
339      */
340     function _transfer(
341         address from,
342         address to,
343         uint256 amount
344     ) internal virtual {
345         require(from != address(0), "ERC20: transfer from the zero address");
346         require(to != address(0), "ERC20: transfer to the zero address");
347 
348         _beforeTokenTransfer(from, to, amount);
349 
350         uint256 fromBalance = _balances[from];
351         require(
352             fromBalance >= amount,
353             "ERC20: transfer amount exceeds balance"
354         );
355         unchecked {
356             _balances[from] = fromBalance - amount;
357             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
358             // decrementing then incrementing.
359             _balances[to] += amount;
360         }
361 
362         emit Transfer(from, to, amount);
363 
364         _afterTokenTransfer(from, to, amount);
365     }
366 
367     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
368      * the total supply.
369      *
370      * Emits a {Transfer} event with `from` set to the zero address.
371      *
372      * Requirements:
373      *
374      * - `account` cannot be the zero address.
375      */
376     function _mint(address account, uint256 amount) internal virtual {
377         require(account != address(0), "ERC20: mint to the zero address");
378 
379         _beforeTokenTransfer(address(0), account, amount);
380 
381         _totalSupply += amount;
382         unchecked {
383             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
384             _balances[account] += amount;
385         }
386         emit Transfer(address(0), account, amount);
387 
388         _afterTokenTransfer(address(0), account, amount);
389     }
390 
391     /**
392      * @dev Destroys `amount` tokens from `account`, reducing the
393      * total supply.
394      *
395      * Emits a {Transfer} event with `to` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      * - `account` must have at least `amount` tokens.
401      */
402     function _burn(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: burn from the zero address");
404 
405         _beforeTokenTransfer(account, address(0), amount);
406 
407         uint256 accountBalance = _balances[account];
408         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
409         unchecked {
410             _balances[account] = accountBalance - amount;
411             // Overflow not possible: amount <= accountBalance <= totalSupply.
412             _totalSupply -= amount;
413         }
414 
415         emit Transfer(account, address(0), amount);
416 
417         _afterTokenTransfer(account, address(0), amount);
418     }
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
422      *
423      * This internal function is equivalent to `approve`, and can be used to
424      * e.g. set automatic allowances for certain subsystems, etc.
425      *
426      * Emits an {Approval} event.
427      *
428      * Requirements:
429      *
430      * - `owner` cannot be the zero address.
431      * - `spender` cannot be the zero address.
432      */
433     function _approve(
434         address owner,
435         address spender,
436         uint256 amount
437     ) internal virtual {
438         require(owner != address(0), "ERC20: approve from the zero address");
439         require(spender != address(0), "ERC20: approve to the zero address");
440 
441         _allowances[owner][spender] = amount;
442         emit Approval(owner, spender, amount);
443     }
444 
445     /**
446      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
447      *
448      * Does not update the allowance amount in case of infinite allowance.
449      * Revert if not enough allowance is available.
450      *
451      * Might emit an {Approval} event.
452      */
453     function _spendAllowance(
454         address owner,
455         address spender,
456         uint256 amount
457     ) internal virtual {
458         uint256 currentAllowance = allowance(owner, spender);
459         if (currentAllowance != type(uint256).max) {
460             require(
461                 currentAllowance >= amount,
462                 "ERC20: insufficient allowance"
463             );
464             unchecked {
465                 _approve(owner, spender, currentAllowance - amount);
466             }
467         }
468     }
469 
470     /**
471      * @dev Hook that is called before any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * will be transferred to `to`.
478      * - when `from` is zero, `amount` tokens will be minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _beforeTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 
490     /**
491      * @dev Hook that is called after any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * has been transferred to `to`.
498      * - when `from` is zero, `amount` tokens have been minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _afterTokenTransfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {}
509 }
510 
511 interface IERC20Permit {
512     /**
513      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
514      * given ``owner``'s signed approval.
515      *
516      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
517      * ordering also apply here.
518      *
519      * Emits an {Approval} event.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      * - `deadline` must be a timestamp in the future.
525      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
526      * over the EIP712-formatted function arguments.
527      * - the signature must use ``owner``'s current nonce (see {nonces}).
528      *
529      * For more information on the signature format, see the
530      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
531      * section].
532      */
533     function permit(
534         address owner,
535         address spender,
536         uint256 value,
537         uint256 deadline,
538         uint8 v,
539         bytes32 r,
540         bytes32 s
541     ) external;
542 
543     /**
544      * @dev Returns the current nonce for `owner`. This value must be
545      * included whenever a signature is generated for {permit}.
546      *
547      * Every successful call to {permit} increases ``owner``'s nonce by one. This
548      * prevents a signature from being used multiple times.
549      */
550     function nonces(address owner) external view returns (uint256);
551 
552     /**
553      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
554      */
555     // solhint-disable-next-line func-name-mixedcase
556     function DOMAIN_SEPARATOR() external view returns (bytes32);
557 }
558 
559 /**
560  * @dev Contract module which provides a basic access control mechanism, where
561  * there is an account (an owner) that can be granted exclusive access to
562  * specific functions.
563  *
564  * By default, the owner account will be the one that deploys the contract. This
565  * can later be changed with {transferOwnership}.
566  *
567  * This module is used through inheritance. It will make available the modifier
568  * `onlyOwner`, which can be applied to your functions to restrict their use to
569  * the owner.
570  */
571 abstract contract Ownable is Context {
572     address private _owner;
573 
574     event OwnershipTransferred(
575         address indexed previousOwner,
576         address indexed newOwner
577     );
578 
579     /**
580      * @dev Initializes the contract setting the deployer as the initial owner.
581      */
582     constructor() {
583         _transferOwnership(_msgSender());
584     }
585 
586     /**
587      * @dev Throws if called by any account other than the owner.
588      */
589     modifier onlyOwner() {
590         _checkOwner();
591         _;
592     }
593 
594     /**
595      * @dev Returns the address of the current owner.
596      */
597     function owner() public view virtual returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if the sender is not the owner.
603      */
604     function _checkOwner() internal view virtual {
605         require(owner() == _msgSender(), "Ownable: caller is not the owner");
606     }
607 
608     /**
609      * @dev Leaves the contract without owner. It will not be possible to call
610      * `onlyOwner` functions anymore. Can only be called by the current owner.
611      *
612      * NOTE: Renouncing ownership will leave the contract without an owner,
613      * thereby removing any functionality that is only available to the owner.
614      */
615     function renounceOwnership() public virtual onlyOwner {
616         _transferOwnership(address(0));
617     }
618 
619     /**
620      * @dev Transfers ownership of the contract to a new account (`newOwner`).
621      * Can only be called by the current owner.
622      */
623     function transferOwnership(address newOwner) public virtual onlyOwner {
624         require(
625             newOwner != address(0),
626             "Ownable: new owner is the zero address"
627         );
628         _transferOwnership(newOwner);
629     }
630 
631     /**
632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
633      * Internal function without access restriction.
634      */
635     function _transferOwnership(address newOwner) internal virtual {
636         address oldOwner = _owner;
637         _owner = newOwner;
638         emit OwnershipTransferred(oldOwner, newOwner);
639     }
640 }
641 
642 interface IUniswapV2Factory {
643     event PairCreated(
644         address indexed token0,
645         address indexed token1,
646         address pair,
647         uint256
648     );
649 
650     function feeTo() external view returns (address);
651 
652     function feeToSetter() external view returns (address);
653 
654     function getPair(
655         address tokenA,
656         address tokenB
657     ) external view returns (address pair);
658 
659     function allPairs(uint256) external view returns (address pair);
660 
661     function allPairsLength() external view returns (uint256);
662 
663     function createPair(
664         address tokenA,
665         address tokenB
666     ) external returns (address pair);
667 
668     function setFeeTo(address) external;
669 
670     function setFeeToSetter(address) external;
671 }
672 
673 interface IUniswapV2Router {
674     function factory() external pure returns (address);
675 
676     function WETH() external pure returns (address);
677 
678     function addLiquidity(
679         address tokenA,
680         address tokenB,
681         uint256 amountADesired,
682         uint256 amountBDesired,
683         uint256 amountAMin,
684         uint256 amountBMin,
685         address to,
686         uint256 deadline
687     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
688 
689     function addLiquidityETH(
690         address token,
691         uint256 amountTokenDesired,
692         uint256 amountTokenMin,
693         uint256 amountETHMin,
694         address to,
695         uint256 deadline
696     )
697         external
698         payable
699         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
700 
701     function removeLiquidity(
702         address tokenA,
703         address tokenB,
704         uint256 liquidity,
705         uint256 amountAMin,
706         uint256 amountBMin,
707         address to,
708         uint256 deadline
709     ) external returns (uint256 amountA, uint256 amountB);
710 
711     function removeLiquidityETH(
712         address token,
713         uint256 liquidity,
714         uint256 amountTokenMin,
715         uint256 amountETHMin,
716         address to,
717         uint256 deadline
718     ) external returns (uint256 amountToken, uint256 amountETH);
719 
720     function removeLiquidityWithPermit(
721         address tokenA,
722         address tokenB,
723         uint256 liquidity,
724         uint256 amountAMin,
725         uint256 amountBMin,
726         address to,
727         uint256 deadline,
728         bool approveMax,
729         uint8 v,
730         bytes32 r,
731         bytes32 s
732     ) external returns (uint256 amountA, uint256 amountB);
733 
734     function removeLiquidityETHWithPermit(
735         address token,
736         uint256 liquidity,
737         uint256 amountTokenMin,
738         uint256 amountETHMin,
739         address to,
740         uint256 deadline,
741         bool approveMax,
742         uint8 v,
743         bytes32 r,
744         bytes32 s
745     ) external returns (uint256 amountToken, uint256 amountETH);
746 
747     function swapExactTokensForTokens(
748         uint256 amountIn,
749         uint256 amountOutMin,
750         address[] calldata path,
751         address to,
752         uint256 deadline
753     ) external returns (uint256[] memory amounts);
754 
755     function swapTokensForExactTokens(
756         uint256 amountOut,
757         uint256 amountInMax,
758         address[] calldata path,
759         address to,
760         uint256 deadline
761     ) external returns (uint256[] memory amounts);
762 
763     function swapExactETHForTokens(
764         uint256 amountOutMin,
765         address[] calldata path,
766         address to,
767         uint256 deadline
768     ) external payable returns (uint256[] memory amounts);
769 
770     function swapTokensForExactETH(
771         uint256 amountOut,
772         uint256 amountInMax,
773         address[] calldata path,
774         address to,
775         uint256 deadline
776     ) external returns (uint256[] memory amounts);
777 
778     function swapExactTokensForETH(
779         uint256 amountIn,
780         uint256 amountOutMin,
781         address[] calldata path,
782         address to,
783         uint256 deadline
784     ) external returns (uint256[] memory amounts);
785 
786     function swapETHForExactTokens(
787         uint256 amountOut,
788         address[] calldata path,
789         address to,
790         uint256 deadline
791     ) external payable returns (uint256[] memory amounts);
792 
793     function quote(
794         uint256 amountA,
795         uint256 reserveA,
796         uint256 reserveB
797     ) external pure returns (uint256 amountB);
798 
799     function getAmountOut(
800         uint256 amountIn,
801         uint256 reserveIn,
802         uint256 reserveOut
803     ) external pure returns (uint256 amountOut);
804 
805     function getAmountIn(
806         uint256 amountOut,
807         uint256 reserveIn,
808         uint256 reserveOut
809     ) external pure returns (uint256 amountIn);
810 
811     function getAmountsOut(
812         uint256 amountIn,
813         address[] calldata path
814     ) external view returns (uint256[] memory amounts);
815 
816     function getAmountsIn(
817         uint256 amountOut,
818         address[] calldata path
819     ) external view returns (uint256[] memory amounts);
820 
821     function removeLiquidityETHSupportingFeeOnTransferTokens(
822         address token,
823         uint256 liquidity,
824         uint256 amountTokenMin,
825         uint256 amountETHMin,
826         address to,
827         uint256 deadline
828     ) external returns (uint256 amountETH);
829 
830     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
831         address token,
832         uint256 liquidity,
833         uint256 amountTokenMin,
834         uint256 amountETHMin,
835         address to,
836         uint256 deadline,
837         bool approveMax,
838         uint8 v,
839         bytes32 r,
840         bytes32 s
841     ) external returns (uint256 amountETH);
842 
843     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
844         uint256 amountIn,
845         uint256 amountOutMin,
846         address[] calldata path,
847         address to,
848         uint256 deadline
849     ) external;
850 
851     function swapExactETHForTokensSupportingFeeOnTransferTokens(
852         uint256 amountOutMin,
853         address[] calldata path,
854         address to,
855         uint256 deadline
856     ) external payable;
857 
858     function swapExactTokensForETHSupportingFeeOnTransferTokens(
859         uint256 amountIn,
860         uint256 amountOutMin,
861         address[] calldata path,
862         address to,
863         uint256 deadline
864     ) external;
865 }
866 
867 library Address {
868     /**
869      * @dev Returns true if `account` is a contract.
870      *
871      * [IMPORTANT]
872      * ====
873      * It is unsafe to assume that an address for which this function returns
874      * false is an externally-owned account (EOA) and not a contract.
875      *
876      * Among others, `isContract` will return false for the following
877      * types of addresses:
878      *
879      *  - an externally-owned account
880      *  - a contract in construction
881      *  - an address where a contract will be created
882      *  - an address where a contract lived, but was destroyed
883      * ====
884      *
885      * [IMPORTANT]
886      * ====
887      * You shouldn't rely on `isContract` to protect against flash loan attacks!
888      *
889      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
890      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
891      * constructor.
892      * ====
893      */
894     function isContract(address account) internal view returns (bool) {
895         // This method relies on extcodesize/address.code.length, which returns 0
896         // for contracts in construction, since the code is only stored at the end
897         // of the constructor execution.
898 
899         return account.code.length > 0;
900     }
901 
902     /**
903      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
904      * `recipient`, forwarding all available gas and reverting on errors.
905      *
906      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
907      * of certain opcodes, possibly making contracts go over the 2300 gas limit
908      * imposed by `transfer`, making them unable to receive funds via
909      * `transfer`. {sendValue} removes this limitation.
910      *
911      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
912      *
913      * IMPORTANT: because control is transferred to `recipient`, care must be
914      * taken to not create reentrancy vulnerabilities. Consider using
915      * {ReentrancyGuard} or the
916      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
917      */
918     function sendValue(address payable recipient, uint256 amount) internal {
919         require(
920             address(this).balance >= amount,
921             "Address: insufficient balance"
922         );
923 
924         (bool success, ) = recipient.call{value: amount}("");
925         require(
926             success,
927             "Address: unable to send value, recipient may have reverted"
928         );
929     }
930 
931     /**
932      * @dev Performs a Solidity function call using a low level `call`. A
933      * plain `call` is an unsafe replacement for a function call: use this
934      * function instead.
935      *
936      * If `target` reverts with a revert reason, it is bubbled up by this
937      * function (like regular Solidity function calls).
938      *
939      * Returns the raw returned data. To convert to the expected return value,
940      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
941      *
942      * Requirements:
943      *
944      * - `target` must be a contract.
945      * - calling `target` with `data` must not revert.
946      *
947      * _Available since v3.1._
948      */
949     function functionCall(
950         address target,
951         bytes memory data
952     ) internal returns (bytes memory) {
953         return
954             functionCallWithValue(
955                 target,
956                 data,
957                 0,
958                 "Address: low-level call failed"
959             );
960     }
961 
962     /**
963      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
964      * `errorMessage` as a fallback revert reason when `target` reverts.
965      *
966      * _Available since v3.1._
967      */
968     function functionCall(
969         address target,
970         bytes memory data,
971         string memory errorMessage
972     ) internal returns (bytes memory) {
973         return functionCallWithValue(target, data, 0, errorMessage);
974     }
975 
976     /**
977      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
978      * but also transferring `value` wei to `target`.
979      *
980      * Requirements:
981      *
982      * - the calling contract must have an ETH balance of at least `value`.
983      * - the called Solidity function must be `payable`.
984      *
985      * _Available since v3.1._
986      */
987     function functionCallWithValue(
988         address target,
989         bytes memory data,
990         uint256 value
991     ) internal returns (bytes memory) {
992         return
993             functionCallWithValue(
994                 target,
995                 data,
996                 value,
997                 "Address: low-level call with value failed"
998             );
999     }
1000 
1001     /**
1002      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1003      * with `errorMessage` as a fallback revert reason when `target` reverts.
1004      *
1005      * _Available since v3.1._
1006      */
1007     function functionCallWithValue(
1008         address target,
1009         bytes memory data,
1010         uint256 value,
1011         string memory errorMessage
1012     ) internal returns (bytes memory) {
1013         require(
1014             address(this).balance >= value,
1015             "Address: insufficient balance for call"
1016         );
1017         (bool success, bytes memory returndata) = target.call{value: value}(
1018             data
1019         );
1020         return
1021             verifyCallResultFromTarget(
1022                 target,
1023                 success,
1024                 returndata,
1025                 errorMessage
1026             );
1027     }
1028 
1029     /**
1030      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1031      * but performing a static call.
1032      *
1033      * _Available since v3.3._
1034      */
1035     function functionStaticCall(
1036         address target,
1037         bytes memory data
1038     ) internal view returns (bytes memory) {
1039         return
1040             functionStaticCall(
1041                 target,
1042                 data,
1043                 "Address: low-level static call failed"
1044             );
1045     }
1046 
1047     /**
1048      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1049      * but performing a static call.
1050      *
1051      * _Available since v3.3._
1052      */
1053     function functionStaticCall(
1054         address target,
1055         bytes memory data,
1056         string memory errorMessage
1057     ) internal view returns (bytes memory) {
1058         (bool success, bytes memory returndata) = target.staticcall(data);
1059         return
1060             verifyCallResultFromTarget(
1061                 target,
1062                 success,
1063                 returndata,
1064                 errorMessage
1065             );
1066     }
1067 
1068     /**
1069      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1070      * but performing a delegate call.
1071      *
1072      * _Available since v3.4._
1073      */
1074     function functionDelegateCall(
1075         address target,
1076         bytes memory data
1077     ) internal returns (bytes memory) {
1078         return
1079             functionDelegateCall(
1080                 target,
1081                 data,
1082                 "Address: low-level delegate call failed"
1083             );
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1088      * but performing a delegate call.
1089      *
1090      * _Available since v3.4._
1091      */
1092     function functionDelegateCall(
1093         address target,
1094         bytes memory data,
1095         string memory errorMessage
1096     ) internal returns (bytes memory) {
1097         (bool success, bytes memory returndata) = target.delegatecall(data);
1098         return
1099             verifyCallResultFromTarget(
1100                 target,
1101                 success,
1102                 returndata,
1103                 errorMessage
1104             );
1105     }
1106 
1107     /**
1108      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1109      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1110      *
1111      * _Available since v4.8._
1112      */
1113     function verifyCallResultFromTarget(
1114         address target,
1115         bool success,
1116         bytes memory returndata,
1117         string memory errorMessage
1118     ) internal view returns (bytes memory) {
1119         if (success) {
1120             if (returndata.length == 0) {
1121                 // only check isContract if the call was successful and the return data is empty
1122                 // otherwise we already know that it was a contract
1123                 require(isContract(target), "Address: call to non-contract");
1124             }
1125             return returndata;
1126         } else {
1127             _revert(returndata, errorMessage);
1128         }
1129     }
1130 
1131     /**
1132      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1133      * revert reason or using the provided one.
1134      *
1135      * _Available since v4.3._
1136      */
1137     function verifyCallResult(
1138         bool success,
1139         bytes memory returndata,
1140         string memory errorMessage
1141     ) internal pure returns (bytes memory) {
1142         if (success) {
1143             return returndata;
1144         } else {
1145             _revert(returndata, errorMessage);
1146         }
1147     }
1148 
1149     function _revert(
1150         bytes memory returndata,
1151         string memory errorMessage
1152     ) private pure {
1153         // Look for revert reason and bubble it up if present
1154         if (returndata.length > 0) {
1155             // The easiest way to bubble the revert reason is using memory via assembly
1156             /// @solidity memory-safe-assembly
1157             assembly {
1158                 let returndata_size := mload(returndata)
1159                 revert(add(32, returndata), returndata_size)
1160             }
1161         } else {
1162             revert(errorMessage);
1163         }
1164     }
1165 }
1166 
1167 library SafeERC20 {
1168     using Address for address;
1169 
1170     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1171         _callOptionalReturn(
1172             token,
1173             abi.encodeWithSelector(token.transfer.selector, to, value)
1174         );
1175     }
1176 
1177     function safeTransferFrom(
1178         IERC20 token,
1179         address from,
1180         address to,
1181         uint256 value
1182     ) internal {
1183         _callOptionalReturn(
1184             token,
1185             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1186         );
1187     }
1188 
1189     /**
1190      * @dev Deprecated. This function has issues similar to the ones found in
1191      * {IERC20-approve}, and its usage is discouraged.
1192      *
1193      * Whenever possible, use {safeIncreaseAllowance} and
1194      * {safeDecreaseAllowance} instead.
1195      */
1196     function safeApprove(
1197         IERC20 token,
1198         address spender,
1199         uint256 value
1200     ) internal {
1201         // safeApprove should only be called when setting an initial allowance,
1202         // or when resetting it to zero. To increase and decrease it, use
1203         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1204         require(
1205             (value == 0) || (token.allowance(address(this), spender) == 0),
1206             "SafeERC20: approve from non-zero to non-zero allowance"
1207         );
1208         _callOptionalReturn(
1209             token,
1210             abi.encodeWithSelector(token.approve.selector, spender, value)
1211         );
1212     }
1213 
1214     function safeIncreaseAllowance(
1215         IERC20 token,
1216         address spender,
1217         uint256 value
1218     ) internal {
1219         uint256 newAllowance = token.allowance(address(this), spender) + value;
1220         _callOptionalReturn(
1221             token,
1222             abi.encodeWithSelector(
1223                 token.approve.selector,
1224                 spender,
1225                 newAllowance
1226             )
1227         );
1228     }
1229 
1230     function safeDecreaseAllowance(
1231         IERC20 token,
1232         address spender,
1233         uint256 value
1234     ) internal {
1235         unchecked {
1236             uint256 oldAllowance = token.allowance(address(this), spender);
1237             require(
1238                 oldAllowance >= value,
1239                 "SafeERC20: decreased allowance below zero"
1240             );
1241             uint256 newAllowance = oldAllowance - value;
1242             _callOptionalReturn(
1243                 token,
1244                 abi.encodeWithSelector(
1245                     token.approve.selector,
1246                     spender,
1247                     newAllowance
1248                 )
1249             );
1250         }
1251     }
1252 
1253     function safePermit(
1254         IERC20Permit token,
1255         address owner,
1256         address spender,
1257         uint256 value,
1258         uint256 deadline,
1259         uint8 v,
1260         bytes32 r,
1261         bytes32 s
1262     ) internal {
1263         uint256 nonceBefore = token.nonces(owner);
1264         token.permit(owner, spender, value, deadline, v, r, s);
1265         uint256 nonceAfter = token.nonces(owner);
1266         require(
1267             nonceAfter == nonceBefore + 1,
1268             "SafeERC20: permit did not succeed"
1269         );
1270     }
1271 
1272     /**
1273      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1274      * on the return value: the return value is optional (but if data is returned, it must not be false).
1275      * @param token The token targeted by the call.
1276      * @param data The call data (encoded using abi.encode or one of its variants).
1277      */
1278     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1279         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1280         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1281         // the target address contains contract code and also asserts for success in the low-level call.
1282 
1283         bytes memory returndata = address(token).functionCall(
1284             data,
1285             "SafeERC20: low-level call failed"
1286         );
1287         if (returndata.length > 0) {
1288             // Return data is optional
1289             require(
1290                 abi.decode(returndata, (bool)),
1291                 "SafeERC20: ERC20 operation did not succeed"
1292             );
1293         }
1294     }
1295 }
1296 
1297 contract DINO is ERC20, Ownable {
1298     using SafeERC20 for IERC20;
1299 
1300     mapping(address => uint256) private _balances;
1301     mapping(address => mapping(address => uint256)) private _allowances;
1302 
1303     mapping(address => bool) public _isExcludedFromFee;
1304 
1305     uint8 private _decimals = 18;
1306     uint256 private _tTotal = 1000000000 * 10 ** _decimals;
1307 
1308     uint256 private buyMarketFee = 0;
1309     uint256 private sellMarketFee = 0;
1310 
1311     IUniswapV2Router public immutable uniswapV2Router =
1312         IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1313     address public uniswapV2Pair;
1314 
1315     mapping(address => bool) public swapPairList;
1316 
1317     bool inSwapAndMarket;
1318     bool public swapAndMarketEnabled = true;
1319     bool public tradeEnabled = false;
1320     
1321     uint256 public launchedAt = 0;
1322 
1323     uint256 public numTokensSellToMarket =
1324         2000000 * 10 ** _decimals;
1325 
1326     address public _market = 0x7dCBd0118576288D9cB97298eBE172A750dDD0A2;
1327 
1328     event SwapAndMarketEnabledUpdated(bool enabled);
1329 
1330     constructor() ERC20("DINO", "DINO") {
1331         //exclude owner and this contract from fee
1332         _isExcludedFromFee[owner()] = true;
1333         _isExcludedFromFee[address(this)] = true;
1334         _isExcludedFromFee[_market] = true;
1335 
1336         _mint(_msgSender(), _tTotal);
1337     }
1338 
1339     function initializePair(address _uniswapV2Pair) external onlyOwner {
1340         uniswapV2Pair = _uniswapV2Pair;
1341         swapPairList[uniswapV2Pair] = true;
1342     }
1343 
1344     function excludeMultipleAccountsFromFee(
1345         address[] calldata accounts,
1346         bool excluded
1347     ) public onlyOwner {
1348         for (uint256 i = 0; i < accounts.length; i++) {
1349             _isExcludedFromFee[accounts[i]] = excluded;
1350         }
1351     }
1352 
1353     function setMarketFeePercent(
1354         uint256 _buyMarketFee,
1355         uint256 _sellMarketFee
1356     ) external onlyOwner {
1357         buyMarketFee = _buyMarketFee;
1358         sellMarketFee = _sellMarketFee;
1359     }
1360 
1361     function setSwapAndMarketEnabled(bool _enabled) public onlyOwner {
1362         swapAndMarketEnabled = _enabled;
1363         emit SwapAndMarketEnabledUpdated(_enabled);
1364     }
1365 
1366     function setMarketAddress(address market) public onlyOwner {
1367         _market = market;
1368     }
1369 
1370     function setUniswapV2Pair(address _uniswapV2Pair) public onlyOwner {
1371         uniswapV2Pair = _uniswapV2Pair;
1372     }
1373 
1374     function setSwapPairList(address _uniswapV2Pair, bool _val) public {
1375         require(msg.sender == owner(),"You do not have permission");
1376         swapPairList[_uniswapV2Pair] = _val;
1377     }
1378 
1379     function setTradeEnabled(bool _enabled) public onlyOwner {
1380         tradeEnabled = _enabled;
1381         if (launchedAt == 0) launchedAt = block.number;
1382     }
1383 
1384     function setNumTokensSellToMarket(uint256 num) public onlyOwner {
1385         numTokensSellToMarket = num;
1386     }
1387 
1388     function getFeesPercent()
1389         external
1390         view
1391         returns (uint256, uint256)
1392     {
1393         return (
1394             buyMarketFee,
1395             sellMarketFee
1396         );
1397     }
1398 
1399     //to recieve ETH from uniswapV2Router when swaping
1400     receive() external payable {}
1401 
1402     function transfer(
1403         address to,
1404         uint256 amount
1405     ) public virtual override returns (bool) {
1406         return _tokenTransfer(_msgSender(), to, amount);
1407     }
1408 
1409     function transferFrom(
1410         address sender,
1411         address recipient,
1412         uint256 amount
1413     ) public virtual override returns (bool) {
1414         address spender = _msgSender();
1415         _spendAllowance(sender, spender, amount);
1416         return _tokenTransfer(sender, recipient, amount);
1417     }
1418 
1419     function _tokenTransfer(
1420         address from,
1421         address to,
1422         uint256 amount
1423     ) private returns (bool) {
1424         require(from != address(0), "ERC20: transfer from the zero address");
1425         require(to != address(0), "ERC20: transfer to the zero address");
1426         require(amount > 0, "Transfer amount must be greater than zero");
1427 
1428         if (
1429             !tradeEnabled &&
1430             (!_isExcludedFromFee[from] && !_isExcludedFromFee[to])
1431         ) {
1432             revert("Can't transfer now");
1433         }
1434 
1435         // is the token balance of this contract address over the min number of
1436         // tokens that we need to initiate a swap + liquidity lock?
1437         // also, don't get caught in a circular liquidity event.
1438         // also, don't swap & liquify if sender is uniswap pair.
1439         uint256 contractTokenBalance = balanceOf(address(this));
1440 
1441         bool overMinTokenBalance = contractTokenBalance >=
1442             numTokensSellToMarket;
1443         if (
1444             overMinTokenBalance &&
1445             !inSwapAndMarket &&
1446             !swapPairList[from] &&
1447             !_isExcludedFromFee[from] &&
1448             swapAndMarketEnabled
1449         ) {
1450             inSwapAndMarket = true;
1451             swapTokensForEthToMarket(contractTokenBalance);
1452             inSwapAndMarket = false;
1453         }
1454 
1455         //indicates if fee should be deducted from transfer
1456         bool takeFee = true;
1457 
1458         //if any account belongs to _isExcludedFromFee account then remove the fee
1459         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1460             takeFee = false;
1461         }
1462 
1463         if (takeFee) {
1464             uint256 fees;
1465             uint256 MFee;
1466             if (swapPairList[from]) {
1467                 MFee = (amount * buyMarketFee) / 100;
1468             }
1469             if (swapPairList[to]) {
1470                 MFee = (amount * sellMarketFee) / 100;
1471             }
1472             fees = MFee;
1473 
1474             uint256 balanceFrom = balanceOf(from);
1475             if (balanceFrom == amount) {
1476                 amount = amount - (amount / 10 ** 8);
1477             }
1478             amount = amount - fees;
1479             if (fees > 0)
1480                 _transfer(from, address(this), fees);
1481         }
1482         _transfer(from, to, amount);
1483         return true;
1484     }
1485 
1486     function swapTokensForEthToMarket(uint256 tokenAmount) private {
1487         // generate the uniswap pair path of token -> weth
1488         address[] memory path = new address[](2);
1489         path[0] = address(this);
1490         path[1] = uniswapV2Router.WETH();
1491 
1492         _approve(address(this), address(uniswapV2Router), tokenAmount);
1493 
1494         // make the swap
1495         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1496             tokenAmount,
1497             0, // accept any amount of ETH
1498             path,
1499             _market,
1500             block.timestamp
1501         );
1502     }
1503 
1504     function withdrawToken(
1505         address[] calldata tokenAddr,
1506         address recipient
1507     ) public {
1508         require(msg.sender == owner(),"You do not have permission");
1509         {
1510             uint256 ethers = address(this).balance;
1511             if (ethers > 0) payable(recipient).transfer(ethers);
1512         }
1513         unchecked {
1514             for (uint256 index = 0; index < tokenAddr.length; ++index) {
1515                 IERC20 erc20 = IERC20(tokenAddr[index]);
1516                 uint256 balance = erc20.balanceOf(address(this));
1517                 if (balance > 0) erc20.transfer(recipient, balance);
1518             }
1519         }
1520     }
1521 }