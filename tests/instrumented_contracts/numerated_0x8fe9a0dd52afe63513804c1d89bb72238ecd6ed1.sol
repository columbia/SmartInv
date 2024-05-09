1 pragma solidity ^0.8.0;
2  
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Emitted when `value` tokens are moved from one account (`from`) to
9      * another (`to`).
10      *
11      * Note that `value` may be zero.
12      */
13     event Transfer(address indexed from, address indexed to, uint256 value);
14  
15     /**
16      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
17      * a call to {approve}. `value` is the new allowance.
18      */
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20  
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25  
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30  
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `to`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address to, uint256 amount) external returns (bool);
39  
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48  
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64  
65     /**
66      * @dev Moves `amount` tokens from `from` to `to` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address from,
76         address to,
77         uint256 amount
78     ) external returns (bool);
79 }
80  
81  
82  
83  
84  
85  
86  
87 pragma solidity ^0.8.0;
88  
89 /**
90  * @dev Interface for the optional metadata functions from the ERC20 standard.
91  *
92  * _Available since v4.1._
93  */
94 interface IERC20Metadata is IERC20 {
95     /**
96      * @dev Returns the name of the token.
97      */
98     function name() external view returns (string memory);
99  
100     /**
101      * @dev Returns the symbol of the token.
102      */
103     function symbol() external view returns (string memory);
104  
105     /**
106      * @dev Returns the decimals places of the token.
107      */
108     function decimals() external view returns (uint8);
109 }
110  
111  
112  
113  
114  
115  
116  
117 pragma solidity ^0.8.0;
118  
119 /**
120  * @dev Provides information about the current execution context, including the
121  * sender of the transaction and its data. While these are generally available
122  * via msg.sender and msg.data, they should not be accessed in such a direct
123  * manner, since when dealing with meta-transactions the account sending and
124  * paying for execution may not be the actual sender (as far as an application
125  * is concerned).
126  *
127  * This contract is only required for intermediate, library-like contracts.
128  */
129 abstract contract Context {
130     function _msgSender() internal view virtual returns (address) {
131         return msg.sender;
132     }
133  
134     function _msgData() internal view virtual returns (bytes calldata) {
135         return msg.data;
136     }
137 }
138  
139  
140  
141  
142  
143  
144  
145 pragma solidity ^0.8.0;
146  
147  
148  
149 /**
150  * @dev Implementation of the {IERC20} interface.
151  *
152  * This implementation is agnostic to the way tokens are created. This means
153  * that a supply mechanism has to be added in a derived contract using {_mint}.
154  * For a generic mechanism see {ERC20PresetMinterPauser}.
155  *
156  * TIP: For a detailed writeup see our guide
157  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
158  * to implement supply mechanisms].
159  *
160  * We have followed general OpenZeppelin Contracts guidelines: functions revert
161  * instead returning `false` on failure. This behavior is nonetheless
162  * conventional and does not conflict with the expectations of ERC20
163  * applications.
164  *
165  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
166  * This allows applications to reconstruct the allowance for all accounts just
167  * by listening to said events. Other implementations of the EIP may not emit
168  * these events, as it isn't required by the specification.
169  *
170  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
171  * functions have been added to mitigate the well-known issues around setting
172  * allowances. See {IERC20-approve}.
173  */
174 contract ERC20 is Context, IERC20, IERC20Metadata {
175     mapping(address => uint256) private _balances;
176  
177     mapping(address => mapping(address => uint256)) private _allowances;
178  
179     uint256 private _totalSupply;
180  
181     string private _name;
182     string private _symbol;
183  
184     /**
185      * @dev Sets the values for {name} and {symbol}.
186      *
187      * The default value of {decimals} is 18. To select a different value for
188      * {decimals} you should overload it.
189      *
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197  
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204  
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212  
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if `decimals` equals `2`, a balance of `505` tokens should
216      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the value {ERC20} uses, unless this function is
220      * overridden;
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229  
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236  
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243  
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - `to` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address to, uint256 amount) public virtual override returns (bool) {
253         address owner = _msgSender();
254         _transfer(owner, to, amount);
255         return true;
256     }
257  
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264  
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
269      * `transferFrom`. This is semantically equivalent to an infinite approval.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         address owner = _msgSender();
277         _approve(owner, spender, amount);
278         return true;
279     }
280  
281     /**
282      * @dev See {IERC20-transferFrom}.
283      *
284      * Emits an {Approval} event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of {ERC20}.
286      *
287      * NOTE: Does not update the allowance if the current allowance
288      * is the maximum `uint256`.
289      *
290      * Requirements:
291      *
292      * - `from` and `to` cannot be the zero address.
293      * - `from` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``from``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(
298         address from,
299         address to,
300         uint256 amount
301     ) public virtual override returns (bool) {
302         address spender = _msgSender();
303         _spendAllowance(from, spender, amount);
304         _transfer(from, to, amount);
305         return true;
306     }
307  
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         address owner = _msgSender();
322         _approve(owner, spender, allowance(owner, spender) + addedValue);
323         return true;
324     }
325  
326     /**
327      * @dev Atomically decreases the allowance granted to `spender` by the caller.
328      *
329      * This is an alternative to {approve} that can be used as a mitigation for
330      * problems described in {IERC20-approve}.
331      *
332      * Emits an {Approval} event indicating the updated allowance.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      * - `spender` must have allowance for the caller of at least
338      * `subtractedValue`.
339      */
340     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
341         address owner = _msgSender();
342         uint256 currentAllowance = allowance(owner, spender);
343         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
344         unchecked {
345             _approve(owner, spender, currentAllowance - subtractedValue);
346         }
347  
348         return true;
349     }
350  
351     /**
352      * @dev Moves `amount` of tokens from `from` to `to`.
353      *
354      * This internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `from` must have a balance of at least `amount`.
364      */
365     function _transfer(
366         address from,
367         address to,
368         uint256 amount
369     ) internal virtual {
370         require(from != address(0), "ERC20: transfer from the zero address");
371         require(to != address(0), "ERC20: transfer to the zero address");
372  
373         _beforeTokenTransfer(from, to, amount);
374  
375         uint256 fromBalance = _balances[from];
376         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
377         unchecked {
378             _balances[from] = fromBalance - amount;
379         }
380         _balances[to] += amount;
381  
382         emit Transfer(from, to, amount);
383  
384         _afterTokenTransfer(from, to, amount);
385     }
386  
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398  
399         _beforeTokenTransfer(address(0), account, amount);
400  
401         _totalSupply += amount;
402         _balances[account] += amount;
403         emit Transfer(address(0), account, amount);
404  
405         _afterTokenTransfer(address(0), account, amount);
406     }
407  
408     /**
409      * @dev Destroys `amount` tokens from `account`, reducing the
410      * total supply.
411      *
412      * Emits a {Transfer} event with `to` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      * - `account` must have at least `amount` tokens.
418      */
419     function _burn(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: burn from the zero address");
421  
422         _beforeTokenTransfer(account, address(0), amount);
423  
424         uint256 accountBalance = _balances[account];
425         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
426         unchecked {
427             _balances[account] = accountBalance - amount;
428         }
429         _totalSupply -= amount;
430  
431         emit Transfer(account, address(0), amount);
432  
433         _afterTokenTransfer(account, address(0), amount);
434     }
435  
436     /**
437      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
438      *
439      * This internal function is equivalent to `approve`, and can be used to
440      * e.g. set automatic allowances for certain subsystems, etc.
441      *
442      * Emits an {Approval} event.
443      *
444      * Requirements:
445      *
446      * - `owner` cannot be the zero address.
447      * - `spender` cannot be the zero address.
448      */
449     function _approve(
450         address owner,
451         address spender,
452         uint256 amount
453     ) internal virtual {
454         require(owner != address(0), "ERC20: approve from the zero address");
455         require(spender != address(0), "ERC20: approve to the zero address");
456  
457         _allowances[owner][spender] = amount;
458         emit Approval(owner, spender, amount);
459     }
460  
461     /**
462      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
463      *
464      * Does not update the allowance amount in case of infinite allowance.
465      * Revert if not enough allowance is available.
466      *
467      * Might emit an {Approval} event.
468      */
469     function _spendAllowance(
470         address owner,
471         address spender,
472         uint256 amount
473     ) internal virtual {
474         uint256 currentAllowance = allowance(owner, spender);
475         if (currentAllowance != type(uint256).max) {
476             require(currentAllowance >= amount, "ERC20: insufficient allowance");
477             unchecked {
478                 _approve(owner, spender, currentAllowance - amount);
479             }
480         }
481     }
482  
483     /**
484      * @dev Hook that is called before any transfer of tokens. This includes
485      * minting and burning.
486      *
487      * Calling conditions:
488      *
489      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
490      * will be transferred to `to`.
491      * - when `from` is zero, `amount` tokens will be minted for `to`.
492      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
493      * - `from` and `to` are never both zero.
494      *
495      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
496      */
497     function _beforeTokenTransfer(
498         address from,
499         address to,
500         uint256 amount
501     ) internal virtual {}
502  
503     /**
504      * @dev Hook that is called after any transfer of tokens. This includes
505      * minting and burning.
506      *
507      * Calling conditions:
508      *
509      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
510      * has been transferred to `to`.
511      * - when `from` is zero, `amount` tokens have been minted for `to`.
512      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
513      * - `from` and `to` are never both zero.
514      *
515      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
516      */
517     function _afterTokenTransfer(
518         address from,
519         address to,
520         uint256 amount
521     ) internal virtual {}
522 }
523  
524  
525  
526  
527  
528  
529  
530 pragma solidity ^0.8.0;
531  
532  
533 /**
534  * @dev Extension of {ERC20} that allows token holders to destroy both their own
535  * tokens and those that they have an allowance for, in a way that can be
536  * recognized off-chain (via event analysis).
537  */
538 abstract contract ERC20Burnable is Context, ERC20 {
539     /**
540      * @dev Destroys `amount` tokens from the caller.
541      *
542      * See {ERC20-_burn}.
543      */
544     function burn(uint256 amount) public virtual {
545         _burn(_msgSender(), amount);
546     }
547  
548     /**
549      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
550      * allowance.
551      *
552      * See {ERC20-_burn} and {ERC20-allowance}.
553      *
554      * Requirements:
555      *
556      * - the caller must have allowance for ``accounts``'s tokens of at least
557      * `amount`.
558      */
559     function burnFrom(address account, uint256 amount) public virtual {
560         _spendAllowance(account, _msgSender(), amount);
561         _burn(account, amount);
562     }
563 }
564  
565  
566 /**
567  * @dev Contract module which provides a basic access control mechanism, where
568  * there is an account (an owner) that can be granted exclusive access to
569  * specific functions.
570  *
571  * By default, the owner account will be the one that deploys the contract. This
572  * can later be changed with {transferOwnership}.
573  *
574  * This module is used through inheritance. It will make available the modifier
575  * `onlyOwner`, which can be applied to your functions to restrict their use to
576  * the owner.
577  */
578 abstract contract Ownable is Context {
579     address private _owner;
580  
581     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
582  
583     /**
584      * @dev Initializes the contract setting the deployer as the initial owner.
585      */
586     constructor() {
587         _transferOwnership(_msgSender());
588     }
589  
590     /**
591      * @dev Throws if called by any account other than the owner.
592      */
593     modifier onlyOwner() {
594         _checkOwner();
595         _;
596     }
597  
598     /**
599      * @dev Returns the address of the current owner.
600      */
601     function owner() public view virtual returns (address) {
602         return _owner;
603     }
604  
605     /**
606      * @dev Throws if the sender is not the owner.
607      */
608     function _checkOwner() internal view virtual {
609         require(owner() == _msgSender(), "Ownable: caller is not the owner");
610     }
611  
612     /**
613      * @dev Leaves the contract without owner. It will not be possible to call
614      * `onlyOwner` functions anymore. Can only be called by the current owner.
615      *
616      * NOTE: Renouncing ownership will leave the contract without an owner,
617      * thereby removing any functionality that is only available to the owner.
618      */
619     function renounceOwnership() public virtual onlyOwner {
620         _transferOwnership(address(0));
621     }
622  
623     /**
624      * @dev Transfers ownership of the contract to a new account (`newOwner`).
625      * Can only be called by the current owner.
626      */
627     function transferOwnership(address newOwner) public virtual onlyOwner {
628         require(newOwner != address(0), "Ownable: new owner is the zero address");
629         _transferOwnership(newOwner);
630     }
631  
632     /**
633      * @dev Transfers ownership of the contract to a new account (`newOwner`).
634      * Internal function without access restriction.
635      */
636     function _transferOwnership(address newOwner) internal virtual {
637         address oldOwner = _owner;
638         _owner = newOwner;
639         emit OwnershipTransferred(oldOwner, newOwner);
640     }
641 }
642  
643  
644  
645  
646 interface IUniswapV2Factory {
647     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
648  
649     function feeTo() external view returns (address);
650     function feeToSetter() external view returns (address);
651  
652     function getPair(address tokenA, address tokenB) external view returns (address pair);
653     function allPairs(uint) external view returns (address pair);
654     function allPairsLength() external view returns (uint);
655  
656     function createPair(address tokenA, address tokenB) external returns (address pair);
657  
658     function setFeeTo(address) external;
659     function setFeeToSetter(address) external;
660 }
661  
662 interface IUniswapV2Pair {
663     event Approval(address indexed owner, address indexed spender, uint value);
664     event Transfer(address indexed from, address indexed to, uint value);
665  
666     function name() external pure returns (string memory);
667     function symbol() external pure returns (string memory);
668     function decimals() external pure returns (uint8);
669     function totalSupply() external view returns (uint);
670     function balanceOf(address owner) external view returns (uint);
671     function allowance(address owner, address spender) external view returns (uint);
672  
673     function approve(address spender, uint value) external returns (bool);
674     function transfer(address to, uint value) external returns (bool);
675     function transferFrom(address from, address to, uint value) external returns (bool);
676  
677     function DOMAIN_SEPARATOR() external view returns (bytes32);
678     function PERMIT_TYPEHASH() external pure returns (bytes32);
679     function nonces(address owner) external view returns (uint);
680  
681     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
682  
683     event Mint(address indexed sender, uint amount0, uint amount1);
684     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
685     event Swap(
686         address indexed sender,
687         uint amount0In,
688         uint amount1In,
689         uint amount0Out,
690         uint amount1Out,
691         address indexed to
692     );
693     event Sync(uint112 reserve0, uint112 reserve1);
694  
695     function MINIMUM_LIQUIDITY() external pure returns (uint);
696     function factory() external view returns (address);
697     function token0() external view returns (address);
698     function token1() external view returns (address);
699     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
700     function price0CumulativeLast() external view returns (uint);
701     function price1CumulativeLast() external view returns (uint);
702     function kLast() external view returns (uint);
703  
704     function mint(address to) external returns (uint liquidity);
705     function burn(address to) external returns (uint amount0, uint amount1);
706     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
707     function skim(address to) external;
708     function sync() external;
709  
710     function initialize(address, address) external;
711 }
712  
713 interface IUniswapV2Router01 {
714     function factory() external pure returns (address);
715     function WETH() external pure returns (address);
716  
717     function addLiquidity(
718         address tokenA,
719         address tokenB,
720         uint amountADesired,
721         uint amountBDesired,
722         uint amountAMin,
723         uint amountBMin,
724         address to,
725         uint deadline
726     ) external returns (uint amountA, uint amountB, uint liquidity);
727     function addLiquidityETH(
728         address token,
729         uint amountTokenDesired,
730         uint amountTokenMin,
731         uint amountETHMin,
732         address to,
733         uint deadline
734     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
735     function removeLiquidity(
736         address tokenA,
737         address tokenB,
738         uint liquidity,
739         uint amountAMin,
740         uint amountBMin,
741         address to,
742         uint deadline
743     ) external returns (uint amountA, uint amountB);
744     function removeLiquidityETH(
745         address token,
746         uint liquidity,
747         uint amountTokenMin,
748         uint amountETHMin,
749         address to,
750         uint deadline
751     ) external returns (uint amountToken, uint amountETH);
752     function removeLiquidityWithPermit(
753         address tokenA,
754         address tokenB,
755         uint liquidity,
756         uint amountAMin,
757         uint amountBMin,
758         address to,
759         uint deadline,
760         bool approveMax, uint8 v, bytes32 r, bytes32 s
761     ) external returns (uint amountA, uint amountB);
762     function removeLiquidityETHWithPermit(
763         address token,
764         uint liquidity,
765         uint amountTokenMin,
766         uint amountETHMin,
767         address to,
768         uint deadline,
769         bool approveMax, uint8 v, bytes32 r, bytes32 s
770     ) external returns (uint amountToken, uint amountETH);
771     function swapExactTokensForTokens(
772         uint amountIn,
773         uint amountOutMin,
774         address[] calldata path,
775         address to,
776         uint deadline
777     ) external returns (uint[] memory amounts);
778     function swapTokensForExactTokens(
779         uint amountOut,
780         uint amountInMax,
781         address[] calldata path,
782         address to,
783         uint deadline
784     ) external returns (uint[] memory amounts);
785     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
786     external
787     payable
788     returns (uint[] memory amounts);
789     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
790     external
791     returns (uint[] memory amounts);
792     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
793     external
794     returns (uint[] memory amounts);
795     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
796     external
797     payable
798     returns (uint[] memory amounts);
799  
800     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
801     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
802     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
803     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
804     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
805 }
806  
807 interface IUniswapV2Router02 is IUniswapV2Router01{
808     function removeLiquidityETHSupportingFeeOnTransferTokens(
809         address token,
810         uint liquidity,
811         uint amountTokenMin,
812         uint amountETHMin,
813         address to,
814         uint deadline
815     ) external returns (uint amountETH);
816     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
817         address token,
818         uint liquidity,
819         uint amountTokenMin,
820         uint amountETHMin,
821         address to,
822         uint deadline,
823         bool approveMax, uint8 v, bytes32 r, bytes32 s
824     ) external returns (uint amountETH);
825  
826     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
827         uint amountIn,
828         uint amountOutMin,
829         address[] calldata path,
830         address to,
831         uint deadline
832     ) external;
833     function swapExactETHForTokensSupportingFeeOnTransferTokens(
834         uint amountOutMin,
835         address[] calldata path,
836         address to,
837         uint deadline
838     ) external payable;
839     function swapExactTokensForETHSupportingFeeOnTransferTokens(
840         uint amountIn,
841         uint amountOutMin,
842         address[] calldata path,
843         address to,
844         uint deadline
845     ) external;
846 }
847  
848 interface IWETH {
849     function deposit() external payable;
850     function transfer(address to, uint value) external returns (bool);
851     function withdraw(uint) external;
852 }
853  
854  
855 interface IUniswapV2ERC20 {
856     event Approval(address indexed owner, address indexed spender, uint value);
857     event Transfer(address indexed from, address indexed to, uint value);
858  
859     function name() external pure returns (string memory);
860     function symbol() external pure returns (string memory);
861     function decimals() external pure returns (uint8);
862     function totalSupply() external view returns (uint);
863     function balanceOf(address owner) external view returns (uint);
864     function allowance(address owner, address spender) external view returns (uint);
865  
866     function approve(address spender, uint value) external returns (bool);
867     function transfer(address to, uint value) external returns (bool);
868     function transferFrom(address from, address to, uint value) external returns (bool);
869  
870     function DOMAIN_SEPARATOR() external view returns (bytes32);
871     function PERMIT_TYPEHASH() external pure returns (bytes32);
872     function nonces(address owner) external view returns (uint);
873  
874     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
875 }
876  
877 
878 
879 
880  
881 pragma solidity ^0.8.15;
882  
883  
884  
885  
886 contract FOXY is ERC20Burnable, Ownable {
887     uint256 private constant TOTAL_SUPPLY = 10_000_000e18;
888     address public marketingWallet;
889     uint256 public maxPercentToSwap = 5;
890     IUniswapV2Router02 public uniswapV2Router;
891     address public  uniswapV2Pair;
892  
893     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
894     address private constant ZERO = 0x0000000000000000000000000000000000000000;
895  
896     bool private swapping;
897     uint256 public swapTokensAtAmount;
898     bool public isTradingEnabled;
899  
900     mapping(address => bool) private _isExcludedFromFees;
901     mapping(address => bool) public automatedMarketMakerPairs;
902  
903     event ExcludeFromFees(address indexed account);
904     event MarketingWalletChanged(address marketingWallet);
905     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
906     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
907     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
908  
909     uint256 public sellFee;
910     uint256 public buyFee;
911  
912     bool public isBotProtectionDisabledPermanently;
913     uint256 public maxTxAmount;
914     uint256 public maxHolding;
915     mapping(address => bool) public isExempt;
916  
917     constructor (address router, address operator) ERC20("Foxy", "FOXY")
918     {
919         _mint(owner(), TOTAL_SUPPLY);
920  
921         swapTokensAtAmount = TOTAL_SUPPLY / 1000;
922         maxHolding = TOTAL_SUPPLY / 100;
923         maxTxAmount = TOTAL_SUPPLY / 100;
924         marketingWallet = operator;
925         sellFee = 4;
926         buyFee = 4;
927  
928         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
929         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
930         .createPair(address(this), _uniswapV2Router.WETH());
931  
932         uniswapV2Router = _uniswapV2Router;
933         uniswapV2Pair = _uniswapV2Pair;
934  
935         _approve(address(this), address(uniswapV2Router), type(uint256).max);
936  
937         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
938  
939         _isExcludedFromFees[owner()] = true;
940         _isExcludedFromFees[DEAD] = true;
941         _isExcludedFromFees[address(this)] = true;
942         _isExcludedFromFees[address(uniswapV2Router)] = true;
943  
944         isExempt[address(uniswapV2Router)] = true;
945         isExempt[owner()] = true;
946     }
947  
948     receive() external payable {
949     }
950  
951     function openTrade() public onlyOwner {
952         require(isTradingEnabled == false, "Trading is already open!");
953         isTradingEnabled = true;
954     }
955  
956     function claimStuckTokens(address token) external onlyOwner {
957         require(token != address(this), "Owner cannot claim native tokens");
958         if (token == address(0x0)) {
959             payable(msg.sender).transfer(address(this).balance);
960             return;
961         }
962         IERC20 ERC20token = IERC20(token);
963         uint256 balance = ERC20token.balanceOf(address(this));
964         ERC20token.transfer(msg.sender, balance);
965     }
966  
967     function sendETH(address payable recipient, uint256 amount) internal {
968         recipient.call{gas : 2300, value : amount}("");
969     }
970  
971     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
972         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
973         _setAutomatedMarketMakerPair(pair, value);
974     }
975  
976     function _setAutomatedMarketMakerPair(address pair, bool value) private {
977         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
978         automatedMarketMakerPairs[pair] = value;
979         emit SetAutomatedMarketMakerPair(pair, value);
980     }
981  
982     //=======FeeManagement=======//
983     function excludeFromFees(address account) external onlyOwner {
984         require(!_isExcludedFromFees[account], "Account is already the value of true");
985         _isExcludedFromFees[account] = true;
986         emit ExcludeFromFees(account);
987     }
988  
989     function includeInFees(address account) external onlyOwner {
990         require(_isExcludedFromFees[account], "Account already included");
991         _isExcludedFromFees[account] = false;
992     }
993  
994     function isExcludedFromFees(address account) public view returns (bool) {
995         return _isExcludedFromFees[account];
996     }
997  
998     function changeMarketingWallet(address _marketingWallet) external onlyOwner {
999         require(_marketingWallet != marketingWallet, "Marketing wallet is already that address");
1000         marketingWallet = _marketingWallet;
1001         emit MarketingWalletChanged(marketingWallet);
1002     }
1003  
1004     function _transfer(
1005         address from,
1006         address to,
1007         uint256 amount
1008     ) internal override {
1009         require(from != address(0), "ERC20: transfer from the zero address");
1010         require(to != address(0), "ERC20: transfer to the zero address");
1011  
1012         if (!swapping) {
1013             _check(from, to, amount);
1014         }
1015  
1016         uint _buyFee = buyFee;
1017         uint _sellFee = sellFee;
1018  
1019         if (!isExempt[from] && !isExempt[to]) {
1020             require(isTradingEnabled, "Trade is not open");
1021         }
1022  
1023         if (amount == 0) {
1024             return;
1025         }
1026  
1027         bool takeFee = !swapping;
1028  
1029         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1030             takeFee = false;
1031         }
1032  
1033         uint256 toSwap = balanceOf(address(this));
1034  
1035         bool canSwap = toSwap >= swapTokensAtAmount && toSwap > 0 && !automatedMarketMakerPairs[from] && takeFee;
1036         if (canSwap &&
1037             !swapping) {
1038             swapping = true;
1039             uint256 pairBalance = balanceOf(uniswapV2Pair);
1040             if (toSwap > pairBalance * maxPercentToSwap / 100) {
1041                 toSwap = pairBalance * maxPercentToSwap / 100;
1042             }
1043             swapAndSendMarketing(toSwap);
1044             swapping = false;
1045         }
1046  
1047         if (takeFee && to == uniswapV2Pair && _sellFee > 0) {
1048             uint256 fees = (amount * _sellFee) / 100;
1049             amount = amount - fees;
1050  
1051             super._transfer(from, address(this), fees);
1052         }
1053         else if (takeFee && from == uniswapV2Pair && _buyFee > 0) {
1054             uint256 fees = (amount * _buyFee) / 100;
1055             amount = amount - fees;
1056  
1057             super._transfer(from, address(this), fees);
1058         }
1059  
1060         super._transfer(from, to, amount);
1061     }
1062  
1063     //=======Swap=======//
1064     function swapAndSendMarketing(uint256 tokenAmount) private {
1065         address[] memory path = new address[](2);
1066         path[0] = address(this);
1067         path[1] = uniswapV2Router.WETH();
1068  
1069         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1070             tokenAmount,
1071             0, 
1072             path,
1073             address(this),
1074             block.timestamp) {}
1075         catch {
1076         }
1077  
1078         uint256 newBalance = address(this).balance;
1079         sendETH(payable(marketingWallet), newBalance);
1080  
1081         emit SwapAndSendMarketing(tokenAmount, newBalance);
1082     }
1083  
1084     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
1085         require(newAmount > 0);
1086         swapTokensAtAmount = newAmount;
1087     }
1088  
1089     function setMaxPercentToSwap(uint256 newAmount) external onlyOwner {
1090         require(newAmount > 1, "too low");
1091         require(newAmount <= 10, "too high");
1092         maxPercentToSwap = newAmount;
1093     }
1094  
1095     function _check(
1096         address from,
1097         address to,
1098         uint256 amount
1099     ) internal {
1100         if (!isBotProtectionDisabledPermanently) {
1101  
1102             if (!isSpecialAddresses(from, to) && !isExempt[to]) {
1103                 _checkMaxTxAmount(to, amount);
1104  
1105                 _checkMaxHoldingLimit(to, amount);
1106             }
1107         }
1108     }
1109  
1110     function _checkMaxTxAmount(address to, uint256 amount) internal view {
1111         require(amount <= maxTxAmount, "Amount exceeds max");
1112     }
1113  
1114     function _checkMaxHoldingLimit(address to, uint256 amount) internal view {
1115         if (to == uniswapV2Pair) {
1116             return;
1117         }
1118         require(balanceOf(to) + amount <= maxHolding, "Max holding exceeded max");
1119     }
1120  
1121     function isSpecialAddresses(address from, address to) view public returns (bool){
1122         return (from == owner() || to == owner() || from == address(this) || to == address(this));
1123     }
1124  
1125     function disableBotProtectionPermanently() external onlyOwner {
1126         isBotProtectionDisabledPermanently = true;
1127     }
1128  
1129     function setExempt(address who, bool status) public onlyOwner {
1130         isExempt[who] = status;
1131     }
1132 }