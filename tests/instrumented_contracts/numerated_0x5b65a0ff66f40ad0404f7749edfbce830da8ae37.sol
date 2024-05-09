1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity ^0.8.9;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23 
24     function allowance(address owner, address spender) external view returns (uint256);
25 
26    
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     
30     function transferFrom(
31         address sender,
32         address recipient,
33         uint256 amount
34     ) external returns (bool);
35 
36     /**
37      * @dev Emitted when `value` tokens are moved from one account (`from`) to
38      * another (`to`).
39      *
40      * Note that `value` may be zero.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     /**
45      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
46      * a call to {approve}. `value` is the new allowance.
47      */
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 
52 interface IERC20Metadata is IERC20 {
53     /**
54      * @dev Returns the name of the token.
55      */
56     function name() external view returns (string memory);
57 
58     /**
59      * @dev Returns the symbol of the token.
60      */
61     function symbol() external view returns (string memory);
62 
63     /**
64      * @dev Returns the decimals places of the token.
65      */
66     function decimals() external view returns (uint8);
67 }
68 
69 
70 abstract contract Context {
71     function _msgSender() internal view virtual returns (address) {
72         return msg.sender;
73     }
74 
75     function _msgData() internal view virtual returns (bytes calldata) {
76         return msg.data;
77     }
78 }
79 
80 /**
81  * @dev Implementation of the {IERC20} interface.
82  *
83  * This implementation is agnostic to the way tokens are created. This means
84  * that a supply mechanism has to be added in a derived contract using {_mint}.
85  * For a generic mechanism see {ERC20PresetMinterPauser}.
86  *
87  * TIP: For a detailed writeup see our guide
88  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
89  * to implement supply mechanisms].
90  *
91  * We have followed general OpenZeppelin guidelines: functions revert instead
92  * of returning `false` on failure. This behavior is nonetheless conventional
93  * and does not conflict with the expectations of ERC20 applications.
94  *
95  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
96  * This allows applications to reconstruct the allowance for all accounts just
97  * by listening to said events. Other implementations of the EIP may not emit
98  * these events, as it isn't required by the specification.
99  *
100  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
101  * functions have been added to mitigate the well-known issues around setting
102  * allowances. See {IERC20-approve}.
103  */
104 contract ERC20 is Context, IERC20, IERC20Metadata {
105     mapping(address => uint256) private _balances;
106 
107     mapping(address => mapping(address => uint256)) private _allowances;
108 
109     uint256 private _totalSupply;
110 
111     string private _name;
112     string private _symbol;
113 
114     /**
115      * @dev Sets the values for {name} and {symbol}.
116      *
117      * The default value of {decimals} is 18. To select a different value for
118      * {decimals} you should overload it.
119      *
120      * All two of these values are immutable: they can only be set once during
121      * construction.
122      */
123     constructor(string memory name_, string memory symbol_) {
124         _name = name_;
125         _symbol = symbol_;
126     }
127 
128     /**
129      * @dev Returns the name of the token.
130      */
131     function name() public view virtual override returns (string memory) {
132         return _name;
133     }
134 
135     /**
136      * @dev Returns the symbol of the token, usually a shorter version of the
137      * name.
138      */
139     function symbol() public view virtual override returns (string memory) {
140         return _symbol;
141     }
142 
143     /**
144      * @dev Returns the number of decimals used to get its user representation.
145      * For example, if `decimals` equals `2`, a balance of `505` tokens should
146      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
147      *
148      * Tokens usually opt for a value of 18, imitating the relationship between
149      * Ether and Wei. This is the value {ERC20} uses, unless this function is
150      * overridden;
151      *
152      * NOTE: This information is only used for _display_ purposes: it in
153      * no way affects any of the arithmetic of the contract, including
154      * {IERC20-balanceOf} and {IERC20-transfer}.
155      */
156     function decimals() public view virtual override returns (uint8) {
157         return 18;
158     }
159 
160     /**
161      * @dev See {IERC20-totalSupply}.
162      */
163     function totalSupply() public view virtual override returns (uint256) {
164         return _totalSupply;
165     }
166 
167     /**
168      * @dev See {IERC20-balanceOf}.
169      */
170     function balanceOf(address account) public view virtual override returns (uint256) {
171         return _balances[account];
172     }
173 
174     /**
175      * @dev See {IERC20-transfer}.
176      *
177      * Requirements:
178      *
179      * - `recipient` cannot be the zero address.
180      * - the caller must have a balance of at least `amount`.
181      */
182     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     /**
188      * @dev See {IERC20-allowance}.
189      */
190     function allowance(address owner, address spender) public view virtual override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     /**
195      * @dev See {IERC20-approve}.
196      *
197      * Requirements:
198      *
199      * - `spender` cannot be the zero address.
200      */
201     function approve(address spender, uint256 amount) public virtual override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     /**
207      * @dev See {IERC20-transferFrom}.
208      *
209      * Emits an {Approval} event indicating the updated allowance. This is not
210      * required by the EIP. See the note at the beginning of {ERC20}.
211      *
212      * Requirements:
213      *
214      * - `sender` and `recipient` cannot be the zero address.
215      * - `sender` must have a balance of at least `amount`.
216      * - the caller must have allowance for ``sender``'s tokens of at least
217      * `amount`.
218      */
219     function transferFrom(
220         address sender,
221         address recipient,
222         uint256 amount
223     ) public virtual override returns (bool) {
224         _transfer(sender, recipient, amount);
225 
226         uint256 currentAllowance = _allowances[sender][_msgSender()];
227         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
228         unchecked {
229             _approve(sender, _msgSender(), currentAllowance - amount);
230         }
231 
232         return true;
233     }
234 
235     /**
236      * @dev Atomically increases the allowance granted to `spender` by the caller.
237      *
238      * This is an alternative to {approve} that can be used as a mitigation for
239      * problems described in {IERC20-approve}.
240      *
241      * Emits an {Approval} event indicating the updated allowance.
242      *
243      * Requirements:
244      *
245      * - `spender` cannot be the zero address.
246      */
247     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
248         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
249         return true;
250     }
251 
252     /**
253      * @dev Atomically decreases the allowance granted to `spender` by the caller.
254      *
255      * This is an alternative to {approve} that can be used as a mitigation for
256      * problems described in {IERC20-approve}.
257      *
258      * Emits an {Approval} event indicating the updated allowance.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      * - `spender` must have allowance for the caller of at least
264      * `subtractedValue`.
265      */
266     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
267         uint256 currentAllowance = _allowances[_msgSender()][spender];
268         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
269         unchecked {
270             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
271         }
272 
273         return true;
274     }
275 
276     /**
277      * @dev Moves `amount` of tokens from `sender` to `recipient`.
278      *
279      * This internal function is equivalent to {transfer}, and can be used to
280      * e.g. implement automatic token fees, slashing mechanisms, etc.
281      *
282      * Emits a {Transfer} event.
283      *
284      * Requirements:
285      *
286      * - `sender` cannot be the zero address.
287      * - `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      */
290     function _transfer(
291         address sender,
292         address recipient,
293         uint256 amount
294     ) internal virtual {
295         require(sender != address(0), "ERC20: transfer from the zero address");
296         require(recipient != address(0), "ERC20: transfer to the zero address");
297 
298         _beforeTokenTransfer(sender, recipient, amount);
299 
300         uint256 senderBalance = _balances[sender];
301         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
302         unchecked {
303             _balances[sender] = senderBalance - amount;
304         }
305         _balances[recipient] += amount;
306 
307         emit Transfer(sender, recipient, amount);
308 
309         _afterTokenTransfer(sender, recipient, amount);
310     }
311 
312     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
313      * the total supply.
314      *
315      * Emits a {Transfer} event with `from` set to the zero address.
316      *
317      * Requirements:
318      *
319      * - `account` cannot be the zero address.
320      */
321     function _mint(address account, uint256 amount) internal virtual {
322         require(account != address(0), "ERC20: mint to the zero address");
323 
324         _beforeTokenTransfer(address(0), account, amount);
325 
326         _totalSupply += amount;
327         _balances[account] += amount;
328         emit Transfer(address(0), account, amount);
329 
330         _afterTokenTransfer(address(0), account, amount);
331     }
332 
333     /**
334      * @dev Destroys `amount` tokens from `account`, reducing the
335      * total supply.
336      *
337      * Emits a {Transfer} event with `to` set to the zero address.
338      *
339      * Requirements:
340      *
341      * - `account` cannot be the zero address.
342      * - `account` must have at least `amount` tokens.
343      */
344     function _burn(address account, uint256 amount) internal virtual {
345         require(account != address(0), "ERC20: burn from the zero address");
346 
347         _beforeTokenTransfer(account, address(0), amount);
348 
349         uint256 accountBalance = _balances[account];
350         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
351         unchecked {
352             _balances[account] = accountBalance - amount;
353         }
354         _totalSupply -= amount;
355 
356         emit Transfer(account, address(0), amount);
357 
358         _afterTokenTransfer(account, address(0), amount);
359     }
360 
361     /**
362      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
363      *
364      * This internal function is equivalent to `approve`, and can be used to
365      * e.g. set automatic allowances for certain subsystems, etc.
366      *
367      * Emits an {Approval} event.
368      *
369      * Requirements:
370      *
371      * - `owner` cannot be the zero address.
372      * - `spender` cannot be the zero address.
373      */
374     function _approve(
375         address owner,
376         address spender,
377         uint256 amount
378     ) internal virtual {
379         require(owner != address(0), "ERC20: approve from the zero address");
380         require(spender != address(0), "ERC20: approve to the zero address");
381 
382         _allowances[owner][spender] = amount;
383         emit Approval(owner, spender, amount);
384     }
385 
386     /**
387      * @dev Hook that is called before any transfer of tokens. This includes
388      * minting and burning.
389      *
390      * Calling conditions:
391      *
392      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
393      * will be transferred to `to`.
394      * - when `from` is zero, `amount` tokens will be minted for `to`.
395      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
396      * - `from` and `to` are never both zero.
397      *
398      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
399      */
400     function _beforeTokenTransfer(
401         address from,
402         address to,
403         uint256 amount
404     ) internal virtual {}
405 
406     /**
407      * @dev Hook that is called after any transfer of tokens. This includes
408      * minting and burning.
409      *
410      * Calling conditions:
411      *
412      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
413      * has been transferred to `to`.
414      * - when `from` is zero, `amount` tokens have been minted for `to`.
415      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
416      * - `from` and `to` are never both zero.
417      *
418      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
419      */
420     function _afterTokenTransfer(
421         address from,
422         address to,
423         uint256 amount
424     ) internal virtual {}
425 }
426 
427 /**
428  * @dev Contract module which provides a basic access control mechanism, where
429  * there is an account (an owner) that can be granted exclusive access to
430  * specific functions.
431  *
432  * By default, the owner account will be the one that deploys the contract. This
433  * can later be changed with {transferOwnership}.
434  *
435  * This module is used through inheritance. It will make available the modifier
436  * `onlyOwner`, which can be applied to your functions to restrict their use to
437  * the owner.
438  */
439 abstract contract Ownable is Context {
440     address private _owner;
441 
442     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
443 
444     /**
445      * @dev Initializes the contract setting the deployer as the initial owner.
446      */
447     constructor() {
448     }
449 
450     /**
451      * @dev Returns the address of the current owner.
452      */
453     function owner() public view virtual returns (address) {
454         return _owner;
455     }
456 
457     /**
458      * @dev Throws if called by any account other than the owner.
459      */
460     modifier onlyOwner() {
461         require(owner() == _msgSender(), "Ownable: caller is not the owner");
462         _;
463     }
464 
465     /**
466      * @dev Leaves the contract without owner. It will not be possible to call
467      * `onlyOwner` functions anymore. Can only be called by the current owner.
468      *
469      * NOTE: Renouncing ownership will leave the contract without an owner,
470      * thereby removing any functionality that is only available to the owner.
471      */
472     function renounceOwnership() public virtual onlyOwner {
473         _setOwner(address(0));
474     }
475 
476     /**
477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
478      * Can only be called by the current owner.
479      */
480     function transferOwnership(address newOwner) public virtual onlyOwner {
481         require(newOwner != address(0), "Ownable: new owner is the zero address");
482         _setOwner(newOwner);
483     }
484 
485     function _setOwner(address newOwner) internal {
486         address oldOwner = _owner;
487         _owner = newOwner;
488         emit OwnershipTransferred(oldOwner, newOwner);
489     }
490 }
491 
492 /**
493  * @dev Contract module which allows children to implement an emergency stop
494  * mechanism that can be triggered by an authorized account.
495  *
496  * This module is used through inheritance. It will make available the
497  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
498  * the functions of your contract. Note that they will not be pausable by
499  * simply including this module, only once the modifiers are put in place.
500  */
501 abstract contract Pausable is Context {
502     /**
503      * @dev Emitted when the pause is triggered by `account`.
504      */
505     event Paused(address account);
506 
507     /**
508      * @dev Emitted when the pause is lifted by `account`.
509      */
510     event Unpaused(address account);
511 
512     bool private _paused;
513 
514     /**
515      * @dev Initializes the contract in unpaused state.
516      */
517     constructor() {
518         _paused = false;
519     }
520 
521     /**
522      * @dev Returns true if the contract is paused, and false otherwise.
523      */
524     function paused() public view virtual returns (bool) {
525         return _paused;
526     }
527 
528     /**
529      * @dev Modifier to make a function callable only when the contract is not paused.
530      *
531      * Requirements:
532      *
533      * - The contract must not be paused.
534      */
535     modifier whenNotPaused() {
536         require(!paused(), "Pausable: paused");
537         _;
538     }
539 
540     /**
541      * @dev Modifier to make a function callable only when the contract is paused.
542      *
543      * Requirements:
544      *
545      * - The contract must be paused.
546      */
547     modifier whenPaused() {
548         require(paused(), "Pausable: not paused");
549         _;
550     }
551 
552     /**
553      * @dev Triggers stopped state.
554      *
555      * Requirements:
556      *
557      * - The contract must not be paused.
558      */
559     function _pause() internal virtual whenNotPaused {
560         _paused = true;
561         emit Paused(_msgSender());
562     }
563 
564     /**
565      * @dev Returns to normal state.
566      *
567      * Requirements:
568      *
569      * - The contract must be paused.
570      */
571     function _unpause() internal virtual whenPaused {
572         _paused = false;
573         emit Unpaused(_msgSender());
574     }
575 }
576 
577 interface IUniswapV2Pair {
578     event Approval(address indexed owner, address indexed spender, uint value);
579     event Transfer(address indexed from, address indexed to, uint value);
580 
581     function name() external pure returns (string memory);
582     function symbol() external pure returns (string memory);
583     function decimals() external pure returns (uint8);
584     function totalSupply() external view returns (uint);
585     function balanceOf(address owner) external view returns (uint);
586     function allowance(address owner, address spender) external view returns (uint);
587 
588     function approve(address spender, uint value) external returns (bool);
589     function transfer(address to, uint value) external returns (bool);
590     function transferFrom(address from, address to, uint value) external returns (bool);
591 
592     function DOMAIN_SEPARATOR() external view returns (bytes32);
593     function PERMIT_TYPEHASH() external pure returns (bytes32);
594     function nonces(address owner) external view returns (uint);
595 
596     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
597 
598     event Mint(address indexed sender, uint amount0, uint amount1);
599     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
600     event Swap(
601         address indexed sender,
602         uint amount0In,
603         uint amount1In,
604         uint amount0Out,
605         uint amount1Out,
606         address indexed to
607     );
608     event Sync(uint112 reserve0, uint112 reserve1);
609 
610     function MINIMUM_LIQUIDITY() external pure returns (uint);
611     function factory() external view returns (address);
612     function token0() external view returns (address);
613     function token1() external view returns (address);
614     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
615     function price0CumulativeLast() external view returns (uint);
616     function price1CumulativeLast() external view returns (uint);
617     function kLast() external view returns (uint);
618 
619     function mint(address to) external returns (uint liquidity);
620     function burn(address to) external returns (uint amount0, uint amount1);
621     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
622     function skim(address to) external;
623     function sync() external;
624 
625     function initialize(address, address) external;
626 }
627 
628 interface IUniswapV2Factory {
629     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
630 
631     function feeTo() external view returns (address);
632     function feeToSetter() external view returns (address);
633 
634     function getPair(address tokenA, address tokenB) external view returns (address pair);
635     function allPairs(uint) external view returns (address pair);
636     function allPairsLength() external view returns (uint);
637 
638     function createPair(address tokenA, address tokenB) external returns (address pair);
639 
640     function setFeeTo(address) external;
641     function setFeeToSetter(address) external;
642 }
643 
644 interface IUniswapV2Router01 {
645     function factory() external pure returns (address);
646     function WETH() external pure returns (address);
647 
648     function addLiquidity(
649         address tokenA,
650         address tokenB,
651         uint amountADesired,
652         uint amountBDesired,
653         uint amountAMin,
654         uint amountBMin,
655         address to,
656         uint deadline
657     ) external returns (uint amountA, uint amountB, uint liquidity);
658     function addLiquidityETH(
659         address token,
660         uint amountTokenDesired,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline
665     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
666     function removeLiquidity(
667         address tokenA,
668         address tokenB,
669         uint liquidity,
670         uint amountAMin,
671         uint amountBMin,
672         address to,
673         uint deadline
674     ) external returns (uint amountA, uint amountB);
675     function removeLiquidityETH(
676         address token,
677         uint liquidity,
678         uint amountTokenMin,
679         uint amountETHMin,
680         address to,
681         uint deadline
682     ) external returns (uint amountToken, uint amountETH);
683     function removeLiquidityWithPermit(
684         address tokenA,
685         address tokenB,
686         uint liquidity,
687         uint amountAMin,
688         uint amountBMin,
689         address to,
690         uint deadline,
691         bool approveMax, uint8 v, bytes32 r, bytes32 s
692     ) external returns (uint amountA, uint amountB);
693     function removeLiquidityETHWithPermit(
694         address token,
695         uint liquidity,
696         uint amountTokenMin,
697         uint amountETHMin,
698         address to,
699         uint deadline,
700         bool approveMax, uint8 v, bytes32 r, bytes32 s
701     ) external returns (uint amountToken, uint amountETH);
702     function swapExactTokensForTokens(
703         uint amountIn,
704         uint amountOutMin,
705         address[] calldata path,
706         address to,
707         uint deadline
708     ) external returns (uint[] memory amounts);
709     function swapTokensForExactTokens(
710         uint amountOut,
711         uint amountInMax,
712         address[] calldata path,
713         address to,
714         uint deadline
715     ) external returns (uint[] memory amounts);
716     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
717         external
718         payable
719         returns (uint[] memory amounts);
720     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
721         external
722         returns (uint[] memory amounts);
723     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
724         external
725         returns (uint[] memory amounts);
726     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
727         external
728         payable
729         returns (uint[] memory amounts);
730 
731     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
732     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
733     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
734     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
735     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
736 }
737 
738 interface IUniswapV2Router02 is IUniswapV2Router01 {
739     function removeLiquidityETHSupportingFeeOnTransferTokens(
740         address token,
741         uint liquidity,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline
746     ) external returns (uint amountETH);
747     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
748         address token,
749         uint liquidity,
750         uint amountTokenMin,
751         uint amountETHMin,
752         address to,
753         uint deadline,
754         bool approveMax, uint8 v, bytes32 r, bytes32 s
755     ) external returns (uint amountETH);
756 
757     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
758         uint amountIn,
759         uint amountOutMin,
760         address[] calldata path,
761         address to,
762         uint deadline
763     ) external;
764     function swapExactETHForTokensSupportingFeeOnTransferTokens(
765         uint amountOutMin,
766         address[] calldata path,
767         address to,
768         uint deadline
769     ) external payable;
770     function swapExactTokensForETHSupportingFeeOnTransferTokens(
771         uint amountIn,
772         uint amountOutMin,
773         address[] calldata path,
774         address to,
775         uint deadline
776     ) external;
777 }
778 
779 contract BabyYoda is ERC20, Ownable, Pausable {
780 
781     // variables
782     
783     uint256 private initialSupply;
784    
785     uint256 private denominator = 100;
786 
787     uint256 private swapThreshold = 0.0000009 ether; // The contract will only swap to ETH, once the fee tokens reach the specified threshold
788     
789     uint256 private devTaxBuy;
790     uint256 private liquidityTaxBuy;
791    
792     
793     uint256 private devTaxSell;
794     uint256 private liquidityTaxSell;
795     uint256 public maxWallet;
796     
797     address private devTaxWallet;
798     address private liquidityTaxWallet;
799     
800     
801     // Mappings
802     
803     mapping (address => bool) private blacklist;
804     mapping (address => bool) private excludeList;
805    
806     
807     mapping (string => uint256) private buyTaxes;
808     mapping (string => uint256) private sellTaxes;
809     mapping (string => address) private taxWallets;
810     
811     bool public taxStatus = true;
812     
813     IUniswapV2Router02 private uniswapV2Router02;
814     IUniswapV2Factory private uniswapV2Factory;
815     IUniswapV2Pair private uniswapV2Pair;
816     
817     constructor(string memory _tokenName,string memory _tokenSymbol,uint256 _supply) ERC20(_tokenName, _tokenSymbol) payable
818     {
819         initialSupply =_supply * (10**18);
820         maxWallet = initialSupply * 2 / 100; 
821         _setOwner(msg.sender);
822         uniswapV2Router02 = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
823         uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
824         uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));
825         taxWallets["liquidity"] = address(0);
826         setBuyTax(0,0); //dev tax, liquidity tax
827         setSellTax(4,95); //dev tax, liquidity tax
828         setTaxWallets(0x54791f7AF07B13D163B84cE136606fB4013eC204); 
829         exclude(msg.sender);
830         exclude(address(this));
831         exclude(devTaxWallet);
832         _mint(msg.sender, initialSupply);
833     }
834     
835     
836     uint256 private devTokens;
837     uint256 private liquidityTokens;
838     
839     
840     /**
841      * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
842      */
843     function handleTax(address from, address to, uint256 amount) private returns (uint256) {
844         address[] memory sellPath = new address[](2);
845         sellPath[0] = address(this);
846         sellPath[1] = uniswapV2Router02.WETH();
847         
848         if(!isExcluded(from) && !isExcluded(to)) {
849             uint256 tax;
850             uint256 baseUnit = amount / denominator;
851             if(from == address(uniswapV2Pair)) {
852                 tax += baseUnit * buyTaxes["dev"];
853                 tax += baseUnit * buyTaxes["liquidity"];
854                
855                 
856                 if(tax > 0) {
857                     _transfer(from, address(this), tax);   
858                 }
859                 
860                 
861                 devTokens += baseUnit * buyTaxes["dev"];
862                 liquidityTokens += baseUnit * buyTaxes["liquidity"];
863 
864             } else if(to == address(uniswapV2Pair)) {
865                 
866                 tax += baseUnit * sellTaxes["dev"];
867                 tax += baseUnit * sellTaxes["liquidity"];
868                 
869                 
870                 if(tax > 0) {
871                     _transfer(from, address(this), tax);   
872                 }
873                 
874                
875                 devTokens += baseUnit * sellTaxes["dev"];
876                 liquidityTokens += baseUnit * sellTaxes["liquidity"];
877                 
878                 
879                 uint256 taxSum =  devTokens + liquidityTokens;
880                 
881                 if(taxSum == 0) return amount;
882                 
883                 uint256 ethValue = uniswapV2Router02.getAmountsOut( devTokens + liquidityTokens, sellPath)[1];
884                 
885                 if(ethValue >= swapThreshold) {
886                     uint256 startBalance = address(this).balance;
887 
888                     uint256 toSell = devTokens + liquidityTokens / 2 ;
889                     
890                     _approve(address(this), address(uniswapV2Router02), toSell);
891             
892                     uniswapV2Router02.swapExactTokensForETH(
893                         toSell,
894                         0,
895                         sellPath,
896                         address(this),
897                         block.timestamp
898                     );
899                     
900                     uint256 ethGained = address(this).balance - startBalance;
901                     
902                     uint256 liquidityToken = liquidityTokens / 2;
903                     uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
904                     
905                     
906                     uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
907                    
908                     
909                     _approve(address(this), address(uniswapV2Router02), liquidityToken);
910                     
911                     uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
912                         address(this),
913                         liquidityToken,
914                         0,
915                         0,
916                         taxWallets["liquidity"],
917                         block.timestamp
918                     );
919                     
920                     uint256 remainingTokens = (devTokens + liquidityTokens) - (toSell + liquidityToken);
921                     
922                     if(remainingTokens > 0) {
923                         _transfer(address(this), taxWallets["dev"], remainingTokens);
924                     }
925                     
926                     
927                    (bool success,) = taxWallets["dev"].call{value: devETH}("");
928                    require(success, "transfer to  dev wallet failed");
929                     
930                     
931                     if(ethGained - ( devETH + liquidityETH) > 0) {
932                        (bool success1,) = taxWallets["dev"].call{value: ethGained - (devETH + liquidityETH)}("");
933                         require(success1, "transfer to  dev wallet failed");
934                     }
935 
936                     
937                     
938                     
939                     devTokens = 0;
940                     liquidityTokens = 0;
941                     
942                 }
943                 
944             }
945             
946             amount -= tax;
947             if (to != address(uniswapV2Pair)){
948                 require(balanceOf(to) + amount <= maxWallet, "maxWallet limit exceeded");
949             }
950            
951         }
952         
953         return amount;
954     }
955     
956     function _transfer(
957         address sender,
958         address recipient,
959         uint256 amount
960     ) internal override virtual {
961         require(!paused(), "ERC20: token transfer while paused");
962         require(!isBlacklisted(msg.sender), "ERC20: sender blacklisted");
963         require(!isBlacklisted(recipient), "ERC20: recipient blacklisted");
964         require(!isBlacklisted(tx.origin), "ERC20: sender blacklisted");
965         
966         if(taxStatus) {
967             amount = handleTax(sender, recipient, amount);   
968         }
969 
970         super._transfer(sender, recipient, amount);
971     }
972     
973     /**
974      * @dev Triggers the tax handling functionality
975      */
976     function triggerTax() public onlyOwner {
977         handleTax(address(0), address(uniswapV2Pair), 0);
978     }
979     
980     /**
981      * @dev Pauses transfers on the token.
982      */
983     function pause() public onlyOwner {
984         require(!paused(), "ERC20: Contract is already paused");
985         _pause();
986     }
987 
988     /**
989      * @dev Unpauses transfers on the token.
990      */
991     function unpause() public onlyOwner {
992         require(paused(), "ERC20: Contract is not paused");
993         _unpause();
994     }
995 
996      /**
997      * @dev set max wallet limit per address.
998      */
999 
1000     function setMaxWallet (uint256 amount) external onlyOwner {
1001         require (amount > 10000, "NO rug pull");
1002         maxWallet = amount * 10**18;
1003     }
1004     
1005     /**
1006      * @dev Burns tokens from caller address.
1007      */
1008     function burn(uint256 amount) public onlyOwner {
1009         _burn(msg.sender, amount);
1010     }
1011     
1012     /**
1013      * @dev Blacklists the specified account (Disables transfers to and from the account).
1014      */
1015     function enableBlacklist(address account) public onlyOwner {
1016         require(!blacklist[account], "ERC20: Account is already blacklisted");
1017         blacklist[account] = true;
1018     }
1019     
1020     /**
1021      * @dev Remove the specified account from the blacklist.
1022      */
1023     function disableBlacklist(address account) public onlyOwner {
1024         require(blacklist[account], "ERC20: Account is not blacklisted");
1025         blacklist[account] = false;
1026     }
1027     
1028     /**
1029      * @dev Excludes the specified account from tax.
1030      */
1031     function exclude(address account) public onlyOwner {
1032         require(!isExcluded(account), "ERC20: Account is already excluded");
1033         excludeList[account] = true;
1034     }
1035     
1036     /**
1037      * @dev Re-enables tax on the specified account.
1038      */
1039     function removeExclude(address account) public onlyOwner {
1040         require(isExcluded(account), "ERC20: Account is not excluded");
1041         excludeList[account] = false;
1042     }
1043     
1044     /**
1045      * @dev Sets tax for buys.
1046      */
1047     function setBuyTax(uint256 dev,uint256 liquidity) public onlyOwner {
1048         buyTaxes["dev"] = dev;
1049         buyTaxes["liquidity"] = liquidity;
1050        
1051     }
1052     
1053     /**
1054      * @dev Sets tax for sells.
1055      */
1056     function setSellTax(uint256 dev, uint256 liquidity) public onlyOwner {
1057 
1058         sellTaxes["dev"] = dev;
1059         sellTaxes["liquidity"] = liquidity;
1060         
1061     }
1062     
1063     /**
1064      * @dev Sets wallets for taxes.
1065      */
1066     function setTaxWallets(address dev) public onlyOwner {
1067         taxWallets["dev"] = dev;
1068         
1069     }
1070 
1071     function claimStuckTokens(address _token) external onlyOwner {
1072  
1073         if (_token == address(0x0)) {
1074             payable(owner()).transfer(address(this).balance);
1075             return;
1076         }
1077         IERC20 erc20token = IERC20(_token);
1078         uint256 balance = erc20token.balanceOf(address(this));
1079         erc20token.transfer(owner(), balance);
1080     }
1081     
1082     /**
1083      * @dev Enables tax globally.
1084      */
1085     function enableTax() public onlyOwner {
1086         require(!taxStatus, "ERC20: Tax is already enabled");
1087         taxStatus = true;
1088     }
1089     
1090     /**
1091      * @dev Disables tax globally.
1092      */
1093     function disableTax() public onlyOwner {
1094         require(taxStatus, "ERC20: Tax is already disabled");
1095         taxStatus = false;
1096     }
1097     
1098     /**
1099      * @dev Returns true if the account is blacklisted, and false otherwise.
1100      */
1101     function isBlacklisted(address account) public view returns (bool) {
1102         return blacklist[account];
1103     }
1104     
1105     /**
1106      * @dev Returns true if the account is excluded, and false otherwise.
1107      */
1108     function isExcluded(address account) public view returns (bool) {
1109         return excludeList[account];
1110     }
1111     
1112     receive() external payable {}
1113 }