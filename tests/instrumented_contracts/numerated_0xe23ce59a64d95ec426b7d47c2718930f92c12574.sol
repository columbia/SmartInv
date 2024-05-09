1 /// https://thezootsuit.com
2 /// https://t.me/thezootsuit
3 /// https://twitter.com/thezootsuiteth
4 /// 0.420/0.420 taxes (<1% slippage) for 30 days, 0 after
5 
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
8 
9 // SPDX-License-Identifier: MIT
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25   function _msgSender() internal view virtual returns (address) {
26     return msg.sender;
27   }
28 
29   function _msgData() internal view virtual returns (bytes calldata) {
30     return msg.data;
31   }
32 }
33 
34 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
35 
36 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53   address private _owner;
54 
55   event OwnershipTransferred(
56     address indexed previousOwner,
57     address indexed newOwner
58   );
59 
60   /**
61    * @dev Initializes the contract setting the deployer as the initial owner.
62    */
63   constructor() {
64     _transferOwnership(_msgSender());
65   }
66 
67   /**
68    * @dev Returns the address of the current owner.
69    */
70   function owner() public view virtual returns (address) {
71     return _owner;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(owner() == _msgSender(), 'Ownable: caller is not the owner');
79     _;
80   }
81 
82   /**
83    * @dev Leaves the contract without owner. It will not be possible to call
84    * `onlyOwner` functions anymore. Can only be called by the current owner.
85    *
86    * NOTE: Renouncing ownership will leave the contract without an owner,
87    * thereby removing any functionality that is only available to the owner.
88    */
89   function renounceOwnership() public virtual onlyOwner {
90     _transferOwnership(address(0));
91   }
92 
93   /**
94    * @dev Transfers ownership of the contract to a new account (`newOwner`).
95    * Can only be called by the current owner.
96    */
97   function transferOwnership(address newOwner) public virtual onlyOwner {
98     require(newOwner != address(0), 'Ownable: new owner is the zero address');
99     _transferOwnership(newOwner);
100   }
101 
102   /**
103    * @dev Transfers ownership of the contract to a new account (`newOwner`).
104    * Internal function without access restriction.
105    */
106   function _transferOwnership(address newOwner) internal virtual {
107     address oldOwner = _owner;
108     _owner = newOwner;
109     emit OwnershipTransferred(oldOwner, newOwner);
110   }
111 }
112 
113 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
114 
115 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123   /**
124    * @dev Returns the amount of tokens in existence.
125    */
126   function totalSupply() external view returns (uint256);
127 
128   /**
129    * @dev Returns the amount of tokens owned by `account`.
130    */
131   function balanceOf(address account) external view returns (uint256);
132 
133   /**
134    * @dev Moves `amount` tokens from the caller's account to `to`.
135    *
136    * Returns a boolean value indicating whether the operation succeeded.
137    *
138    * Emits a {Transfer} event.
139    */
140   function transfer(address to, uint256 amount) external returns (bool);
141 
142   /**
143    * @dev Returns the remaining number of tokens that `spender` will be
144    * allowed to spend on behalf of `owner` through {transferFrom}. This is
145    * zero by default.
146    *
147    * This value changes when {approve} or {transferFrom} are called.
148    */
149   function allowance(address owner, address spender)
150     external
151     view
152     returns (uint256);
153 
154   /**
155    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156    *
157    * Returns a boolean value indicating whether the operation succeeded.
158    *
159    * IMPORTANT: Beware that changing an allowance with this method brings the risk
160    * that someone may use both the old and the new allowance by unfortunate
161    * transaction ordering. One possible solution to mitigate this race
162    * condition is to first reduce the spender's allowance to 0 and set the
163    * desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    *
166    * Emits an {Approval} event.
167    */
168   function approve(address spender, uint256 amount) external returns (bool);
169 
170   /**
171    * @dev Moves `amount` tokens from `from` to `to` using the
172    * allowance mechanism. `amount` is then deducted from the caller's
173    * allowance.
174    *
175    * Returns a boolean value indicating whether the operation succeeded.
176    *
177    * Emits a {Transfer} event.
178    */
179   function transferFrom(
180     address from,
181     address to,
182     uint256 amount
183   ) external returns (bool);
184 
185   /**
186    * @dev Emitted when `value` tokens are moved from one account (`from`) to
187    * another (`to`).
188    *
189    * Note that `value` may be zero.
190    */
191   event Transfer(address indexed from, address indexed to, uint256 value);
192 
193   /**
194    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195    * a call to {approve}. `value` is the new allowance.
196    */
197   event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.5.0
201 
202 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Interface for the optional metadata functions from the ERC20 standard.
208  *
209  * _Available since v4.1._
210  */
211 interface IERC20Metadata is IERC20 {
212   /**
213    * @dev Returns the name of the token.
214    */
215   function name() external view returns (string memory);
216 
217   /**
218    * @dev Returns the symbol of the token.
219    */
220   function symbol() external view returns (string memory);
221 
222   /**
223    * @dev Returns the decimals places of the token.
224    */
225   function decimals() external view returns (uint8);
226 }
227 
228 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.5.0
229 
230 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Implementation of the {IERC20} interface.
236  *
237  * This implementation is agnostic to the way tokens are created. This means
238  * that a supply mechanism has to be added in a derived contract using {_mint}.
239  * For a generic mechanism see {ERC20PresetMinterPauser}.
240  *
241  * TIP: For a detailed writeup see our guide
242  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
243  * to implement supply mechanisms].
244  *
245  * We have followed general OpenZeppelin Contracts guidelines: functions revert
246  * instead returning `false` on failure. This behavior is nonetheless
247  * conventional and does not conflict with the expectations of ERC20
248  * applications.
249  *
250  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
251  * This allows applications to reconstruct the allowance for all accounts just
252  * by listening to said events. Other implementations of the EIP may not emit
253  * these events, as it isn't required by the specification.
254  *
255  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
256  * functions have been added to mitigate the well-known issues around setting
257  * allowances. See {IERC20-approve}.
258  */
259 contract ERC20 is Context, IERC20, IERC20Metadata {
260   mapping(address => uint256) private _balances;
261 
262   mapping(address => mapping(address => uint256)) private _allowances;
263 
264   uint256 private _totalSupply;
265 
266   string private _name;
267   string private _symbol;
268 
269   /**
270    * @dev Sets the values for {name} and {symbol}.
271    *
272    * The default value of {decimals} is 18. To select a different value for
273    * {decimals} you should overload it.
274    *
275    * All two of these values are immutable: they can only be set once during
276    * construction.
277    */
278   constructor(string memory name_, string memory symbol_) {
279     _name = name_;
280     _symbol = symbol_;
281   }
282 
283   /**
284    * @dev Returns the name of the token.
285    */
286   function name() public view virtual override returns (string memory) {
287     return _name;
288   }
289 
290   /**
291    * @dev Returns the symbol of the token, usually a shorter version of the
292    * name.
293    */
294   function symbol() public view virtual override returns (string memory) {
295     return _symbol;
296   }
297 
298   /**
299    * @dev Returns the number of decimals used to get its user representation.
300    * For example, if `decimals` equals `2`, a balance of `505` tokens should
301    * be displayed to a user as `5.05` (`505 / 10 ** 2`).
302    *
303    * Tokens usually opt for a value of 18, imitating the relationship between
304    * Ether and Wei. This is the value {ERC20} uses, unless this function is
305    * overridden;
306    *
307    * NOTE: This information is only used for _display_ purposes: it in
308    * no way affects any of the arithmetic of the contract, including
309    * {IERC20-balanceOf} and {IERC20-transfer}.
310    */
311   function decimals() public view virtual override returns (uint8) {
312     return 18;
313   }
314 
315   /**
316    * @dev See {IERC20-totalSupply}.
317    */
318   function totalSupply() public view virtual override returns (uint256) {
319     return _totalSupply;
320   }
321 
322   /**
323    * @dev See {IERC20-balanceOf}.
324    */
325   function balanceOf(address account)
326     public
327     view
328     virtual
329     override
330     returns (uint256)
331   {
332     return _balances[account];
333   }
334 
335   /**
336    * @dev See {IERC20-transfer}.
337    *
338    * Requirements:
339    *
340    * - `to` cannot be the zero address.
341    * - the caller must have a balance of at least `amount`.
342    */
343   function transfer(address to, uint256 amount)
344     public
345     virtual
346     override
347     returns (bool)
348   {
349     address owner = _msgSender();
350     _transfer(owner, to, amount);
351     return true;
352   }
353 
354   /**
355    * @dev See {IERC20-allowance}.
356    */
357   function allowance(address owner, address spender)
358     public
359     view
360     virtual
361     override
362     returns (uint256)
363   {
364     return _allowances[owner][spender];
365   }
366 
367   /**
368    * @dev See {IERC20-approve}.
369    *
370    * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
371    * `transferFrom`. This is semantically equivalent to an infinite approval.
372    *
373    * Requirements:
374    *
375    * - `spender` cannot be the zero address.
376    */
377   function approve(address spender, uint256 amount)
378     public
379     virtual
380     override
381     returns (bool)
382   {
383     address owner = _msgSender();
384     _approve(owner, spender, amount);
385     return true;
386   }
387 
388   /**
389    * @dev See {IERC20-transferFrom}.
390    *
391    * Emits an {Approval} event indicating the updated allowance. This is not
392    * required by the EIP. See the note at the beginning of {ERC20}.
393    *
394    * NOTE: Does not update the allowance if the current allowance
395    * is the maximum `uint256`.
396    *
397    * Requirements:
398    *
399    * - `from` and `to` cannot be the zero address.
400    * - `from` must have a balance of at least `amount`.
401    * - the caller must have allowance for ``from``'s tokens of at least
402    * `amount`.
403    */
404   function transferFrom(
405     address from,
406     address to,
407     uint256 amount
408   ) public virtual override returns (bool) {
409     address spender = _msgSender();
410     _spendAllowance(from, spender, amount);
411     _transfer(from, to, amount);
412     return true;
413   }
414 
415   /**
416    * @dev Atomically increases the allowance granted to `spender` by the caller.
417    *
418    * This is an alternative to {approve} that can be used as a mitigation for
419    * problems described in {IERC20-approve}.
420    *
421    * Emits an {Approval} event indicating the updated allowance.
422    *
423    * Requirements:
424    *
425    * - `spender` cannot be the zero address.
426    */
427   function increaseAllowance(address spender, uint256 addedValue)
428     public
429     virtual
430     returns (bool)
431   {
432     address owner = _msgSender();
433     _approve(owner, spender, _allowances[owner][spender] + addedValue);
434     return true;
435   }
436 
437   /**
438    * @dev Atomically decreases the allowance granted to `spender` by the caller.
439    *
440    * This is an alternative to {approve} that can be used as a mitigation for
441    * problems described in {IERC20-approve}.
442    *
443    * Emits an {Approval} event indicating the updated allowance.
444    *
445    * Requirements:
446    *
447    * - `spender` cannot be the zero address.
448    * - `spender` must have allowance for the caller of at least
449    * `subtractedValue`.
450    */
451   function decreaseAllowance(address spender, uint256 subtractedValue)
452     public
453     virtual
454     returns (bool)
455   {
456     address owner = _msgSender();
457     uint256 currentAllowance = _allowances[owner][spender];
458     require(
459       currentAllowance >= subtractedValue,
460       'ERC20: decreased allowance below zero'
461     );
462     unchecked {
463       _approve(owner, spender, currentAllowance - subtractedValue);
464     }
465 
466     return true;
467   }
468 
469   /**
470    * @dev Moves `amount` of tokens from `sender` to `recipient`.
471    *
472    * This internal function is equivalent to {transfer}, and can be used to
473    * e.g. implement automatic token fees, slashing mechanisms, etc.
474    *
475    * Emits a {Transfer} event.
476    *
477    * Requirements:
478    *
479    * - `from` cannot be the zero address.
480    * - `to` cannot be the zero address.
481    * - `from` must have a balance of at least `amount`.
482    */
483   function _transfer(
484     address from,
485     address to,
486     uint256 amount
487   ) internal virtual {
488     require(from != address(0), 'ERC20: transfer from the zero address');
489     require(to != address(0), 'ERC20: transfer to the zero address');
490 
491     _beforeTokenTransfer(from, to, amount);
492 
493     uint256 fromBalance = _balances[from];
494     require(fromBalance >= amount, 'ERC20: transfer amount exceeds balance');
495     unchecked {
496       _balances[from] = fromBalance - amount;
497     }
498     _balances[to] += amount;
499 
500     emit Transfer(from, to, amount);
501 
502     _afterTokenTransfer(from, to, amount);
503   }
504 
505   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
506    * the total supply.
507    *
508    * Emits a {Transfer} event with `from` set to the zero address.
509    *
510    * Requirements:
511    *
512    * - `account` cannot be the zero address.
513    */
514   function _mint(address account, uint256 amount) internal virtual {
515     require(account != address(0), 'ERC20: mint to the zero address');
516 
517     _beforeTokenTransfer(address(0), account, amount);
518 
519     _totalSupply += amount;
520     _balances[account] += amount;
521     emit Transfer(address(0), account, amount);
522 
523     _afterTokenTransfer(address(0), account, amount);
524   }
525 
526   /**
527    * @dev Destroys `amount` tokens from `account`, reducing the
528    * total supply.
529    *
530    * Emits a {Transfer} event with `to` set to the zero address.
531    *
532    * Requirements:
533    *
534    * - `account` cannot be the zero address.
535    * - `account` must have at least `amount` tokens.
536    */
537   function _burn(address account, uint256 amount) internal virtual {
538     require(account != address(0), 'ERC20: burn from the zero address');
539 
540     _beforeTokenTransfer(account, address(0), amount);
541 
542     uint256 accountBalance = _balances[account];
543     require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
544     unchecked {
545       _balances[account] = accountBalance - amount;
546     }
547     _totalSupply -= amount;
548 
549     emit Transfer(account, address(0), amount);
550 
551     _afterTokenTransfer(account, address(0), amount);
552   }
553 
554   /**
555    * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
556    *
557    * This internal function is equivalent to `approve`, and can be used to
558    * e.g. set automatic allowances for certain subsystems, etc.
559    *
560    * Emits an {Approval} event.
561    *
562    * Requirements:
563    *
564    * - `owner` cannot be the zero address.
565    * - `spender` cannot be the zero address.
566    */
567   function _approve(
568     address owner,
569     address spender,
570     uint256 amount
571   ) internal virtual {
572     require(owner != address(0), 'ERC20: approve from the zero address');
573     require(spender != address(0), 'ERC20: approve to the zero address');
574 
575     _allowances[owner][spender] = amount;
576     emit Approval(owner, spender, amount);
577   }
578 
579   /**
580    * @dev Spend `amount` form the allowance of `owner` toward `spender`.
581    *
582    * Does not update the allowance amount in case of infinite allowance.
583    * Revert if not enough allowance is available.
584    *
585    * Might emit an {Approval} event.
586    */
587   function _spendAllowance(
588     address owner,
589     address spender,
590     uint256 amount
591   ) internal virtual {
592     uint256 currentAllowance = allowance(owner, spender);
593     if (currentAllowance != type(uint256).max) {
594       require(currentAllowance >= amount, 'ERC20: insufficient allowance');
595       unchecked {
596         _approve(owner, spender, currentAllowance - amount);
597       }
598     }
599   }
600 
601   /**
602    * @dev Hook that is called before any transfer of tokens. This includes
603    * minting and burning.
604    *
605    * Calling conditions:
606    *
607    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608    * will be transferred to `to`.
609    * - when `from` is zero, `amount` tokens will be minted for `to`.
610    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
611    * - `from` and `to` are never both zero.
612    *
613    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614    */
615   function _beforeTokenTransfer(
616     address from,
617     address to,
618     uint256 amount
619   ) internal virtual {}
620 
621   /**
622    * @dev Hook that is called after any transfer of tokens. This includes
623    * minting and burning.
624    *
625    * Calling conditions:
626    *
627    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
628    * has been transferred to `to`.
629    * - when `from` is zero, `amount` tokens have been minted for `to`.
630    * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
631    * - `from` and `to` are never both zero.
632    *
633    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
634    */
635   function _afterTokenTransfer(
636     address from,
637     address to,
638     uint256 amount
639   ) internal virtual {}
640 }
641 
642 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1
643 
644 pragma solidity >=0.5.0;
645 
646 interface IUniswapV2Factory {
647   event PairCreated(
648     address indexed token0,
649     address indexed token1,
650     address pair,
651     uint256
652   );
653 
654   function feeTo() external view returns (address);
655 
656   function feeToSetter() external view returns (address);
657 
658   function getPair(address tokenA, address tokenB)
659     external
660     view
661     returns (address pair);
662 
663   function allPairs(uint256) external view returns (address pair);
664 
665   function allPairsLength() external view returns (uint256);
666 
667   function createPair(address tokenA, address tokenB)
668     external
669     returns (address pair);
670 
671   function setFeeTo(address) external;
672 
673   function setFeeToSetter(address) external;
674 }
675 
676 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
677 
678 pragma solidity >=0.6.2;
679 
680 interface IUniswapV2Router01 {
681   function factory() external pure returns (address);
682 
683   function WETH() external pure returns (address);
684 
685   function addLiquidity(
686     address tokenA,
687     address tokenB,
688     uint256 amountADesired,
689     uint256 amountBDesired,
690     uint256 amountAMin,
691     uint256 amountBMin,
692     address to,
693     uint256 deadline
694   )
695     external
696     returns (
697       uint256 amountA,
698       uint256 amountB,
699       uint256 liquidity
700     );
701 
702   function addLiquidityETH(
703     address token,
704     uint256 amountTokenDesired,
705     uint256 amountTokenMin,
706     uint256 amountETHMin,
707     address to,
708     uint256 deadline
709   )
710     external
711     payable
712     returns (
713       uint256 amountToken,
714       uint256 amountETH,
715       uint256 liquidity
716     );
717 
718   function removeLiquidity(
719     address tokenA,
720     address tokenB,
721     uint256 liquidity,
722     uint256 amountAMin,
723     uint256 amountBMin,
724     address to,
725     uint256 deadline
726   ) external returns (uint256 amountA, uint256 amountB);
727 
728   function removeLiquidityETH(
729     address token,
730     uint256 liquidity,
731     uint256 amountTokenMin,
732     uint256 amountETHMin,
733     address to,
734     uint256 deadline
735   ) external returns (uint256 amountToken, uint256 amountETH);
736 
737   function removeLiquidityWithPermit(
738     address tokenA,
739     address tokenB,
740     uint256 liquidity,
741     uint256 amountAMin,
742     uint256 amountBMin,
743     address to,
744     uint256 deadline,
745     bool approveMax,
746     uint8 v,
747     bytes32 r,
748     bytes32 s
749   ) external returns (uint256 amountA, uint256 amountB);
750 
751   function removeLiquidityETHWithPermit(
752     address token,
753     uint256 liquidity,
754     uint256 amountTokenMin,
755     uint256 amountETHMin,
756     address to,
757     uint256 deadline,
758     bool approveMax,
759     uint8 v,
760     bytes32 r,
761     bytes32 s
762   ) external returns (uint256 amountToken, uint256 amountETH);
763 
764   function swapExactTokensForTokens(
765     uint256 amountIn,
766     uint256 amountOutMin,
767     address[] calldata path,
768     address to,
769     uint256 deadline
770   ) external returns (uint256[] memory amounts);
771 
772   function swapTokensForExactTokens(
773     uint256 amountOut,
774     uint256 amountInMax,
775     address[] calldata path,
776     address to,
777     uint256 deadline
778   ) external returns (uint256[] memory amounts);
779 
780   function swapExactETHForTokens(
781     uint256 amountOutMin,
782     address[] calldata path,
783     address to,
784     uint256 deadline
785   ) external payable returns (uint256[] memory amounts);
786 
787   function swapTokensForExactETH(
788     uint256 amountOut,
789     uint256 amountInMax,
790     address[] calldata path,
791     address to,
792     uint256 deadline
793   ) external returns (uint256[] memory amounts);
794 
795   function swapExactTokensForETH(
796     uint256 amountIn,
797     uint256 amountOutMin,
798     address[] calldata path,
799     address to,
800     uint256 deadline
801   ) external returns (uint256[] memory amounts);
802 
803   function swapETHForExactTokens(
804     uint256 amountOut,
805     address[] calldata path,
806     address to,
807     uint256 deadline
808   ) external payable returns (uint256[] memory amounts);
809 
810   function quote(
811     uint256 amountA,
812     uint256 reserveA,
813     uint256 reserveB
814   ) external pure returns (uint256 amountB);
815 
816   function getAmountOut(
817     uint256 amountIn,
818     uint256 reserveIn,
819     uint256 reserveOut
820   ) external pure returns (uint256 amountOut);
821 
822   function getAmountIn(
823     uint256 amountOut,
824     uint256 reserveIn,
825     uint256 reserveOut
826   ) external pure returns (uint256 amountIn);
827 
828   function getAmountsOut(uint256 amountIn, address[] calldata path)
829     external
830     view
831     returns (uint256[] memory amounts);
832 
833   function getAmountsIn(uint256 amountOut, address[] calldata path)
834     external
835     view
836     returns (uint256[] memory amounts);
837 }
838 
839 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
840 
841 pragma solidity >=0.6.2;
842 
843 interface IUniswapV2Router02 is IUniswapV2Router01 {
844   function removeLiquidityETHSupportingFeeOnTransferTokens(
845     address token,
846     uint256 liquidity,
847     uint256 amountTokenMin,
848     uint256 amountETHMin,
849     address to,
850     uint256 deadline
851   ) external returns (uint256 amountETH);
852 
853   function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
854     address token,
855     uint256 liquidity,
856     uint256 amountTokenMin,
857     uint256 amountETHMin,
858     address to,
859     uint256 deadline,
860     bool approveMax,
861     uint8 v,
862     bytes32 r,
863     bytes32 s
864   ) external returns (uint256 amountETH);
865 
866   function swapExactTokensForTokensSupportingFeeOnTransferTokens(
867     uint256 amountIn,
868     uint256 amountOutMin,
869     address[] calldata path,
870     address to,
871     uint256 deadline
872   ) external;
873 
874   function swapExactETHForTokensSupportingFeeOnTransferTokens(
875     uint256 amountOutMin,
876     address[] calldata path,
877     address to,
878     uint256 deadline
879   ) external payable;
880 
881   function swapExactTokensForETHSupportingFeeOnTransferTokens(
882     uint256 amountIn,
883     uint256 amountOutMin,
884     address[] calldata path,
885     address to,
886     uint256 deadline
887   ) external;
888 }
889 
890 // File contracts/TheZootSuit.sol
891 
892 pragma solidity ^0.8.16;
893 
894 contract TheZootSuit is ERC20, Ownable {
895   uint256 public startedZooting;
896   bool public taxesOn = true;
897   mapping(address => bool) public bot;
898   IUniswapV2Router02 public router =
899     IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
900   address public pair;
901 
902   event GetZooted(address indexed user, uint256 amount);
903 
904   constructor() ERC20('The Zoot Suit', 'ZOOTED') {
905     _mint(msg.sender, 420_420_420_420 * 10**18);
906     pair = IUniswapV2Factory(router.factory()).createPair(
907       address(this),
908       router.WETH()
909     );
910   }
911 
912   function _transfer(
913     address sender,
914     address recipient,
915     uint256 amount
916   ) internal virtual override {
917     bool _buying = sender == pair && recipient != address(router);
918     bool _selling = recipient == pair;
919 
920     if (_buying) {
921       require(startedZooting > 0, 'NOTLAUNCHED');
922       if (block.timestamp <= startedZooting + 60) {
923         bot[recipient] = true;
924       } else if (block.timestamp < startedZooting + 60 minutes) {
925         require(
926           balanceOf(recipient) + amount <= (totalSupply() * 1) / 100,
927           '1PERC'
928         );
929       }
930     } else {
931       bool _bot = bot[recipient] || bot[sender] || bot[msg.sender];
932       require(!_bot, 'NONONONO');
933     }
934 
935     uint256 tax;
936     if (
937       taxesOn &&
938       block.timestamp < startedZooting + 30 days &&
939       (_buying || _selling)
940     ) {
941       tax = (amount * 42) / 10000; // 0.420%
942       _burnEv(sender, tax);
943     }
944 
945     super._transfer(sender, recipient, amount - tax);
946   }
947 
948   function _burnEv(address _user, uint256 _amount) internal {
949     _burn(_user, _amount);
950     emit GetZooted(_user, _amount);
951   }
952 
953   function zoot(uint256 _amount) external {
954     _burnEv(msg.sender, _amount);
955   }
956 
957   function getZooted() external onlyOwner {
958     require(startedZooting == 0, 'LAUNCHED');
959     startedZooting = block.timestamp;
960   }
961 
962   function setBot(address _user, bool _is) external onlyOwner {
963     require(bot[_user] != _is, 'TOGBOT');
964     bot[_user] = _is;
965   }
966 
967   function setTaxesOn(bool _is) external onlyOwner {
968     require(taxesOn != _is, 'TOGTAXES');
969     taxesOn = _is;
970   }
971 }