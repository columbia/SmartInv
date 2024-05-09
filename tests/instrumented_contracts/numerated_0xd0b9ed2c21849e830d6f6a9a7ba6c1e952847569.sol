1 pragma solidity ^0.8.17;
2 
3 
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Emitted when `value` tokens are moved from one account (`from`) to
11      * another (`to`).
12      *
13      * Note that `value` may be zero.
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16  
17     /**
18      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
19      * a call to {approve}. `value` is the new allowance.
20      */
21     event Approval(address indexed owner, address indexed spender, uint256 value);
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
49     function allowance(address owner, address spender) external view returns (uint256);
50  
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66  
67     /**
68      * @dev Moves `amount` tokens from `from` to `to` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address from,
78         address to,
79         uint256 amount
80     ) external returns (bool);
81 }
82  
83  
84  
85  
86  
87  
88  
89 pragma solidity ^0.8.17;
90  
91 /**
92  * @dev Interface for the optional metadata functions from the ERC20 standard.
93  *
94  * _Available since v4.1._
95  */
96 interface IERC20Metadata is IERC20 {
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() external view returns (string memory);
101  
102     /**
103      * @dev Returns the symbol of the token.
104      */
105     function symbol() external view returns (string memory);
106  
107     /**
108      * @dev Returns the decimals places of the token.
109      */
110     function decimals() external view returns (uint8);
111 }
112  
113  
114  
115  
116  
117  
118  
119 pragma solidity ^0.8.17;
120  
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135  
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140  
141  
142  
143  
144  
145  
146  
147 pragma solidity ^0.8.17;
148  
149  
150  
151 /**
152  * @dev Implementation of the {IERC20} interface.
153  *
154  * This implementation is agnostic to the way tokens are created. This means
155  * that a supply mechanism has to be added in a derived contract using {_mint}.
156  * For a generic mechanism see {ERC20PresetMinterPauser}.
157  *
158  * TIP: For a detailed writeup see our guide
159  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
160  * to implement supply mechanisms].
161  *
162  * We have followed general OpenZeppelin Contracts guidelines: functions revert
163  * instead returning `false` on failure. This behavior is nonetheless
164  * conventional and does not conflict with the expectations of ERC20
165  * applications.
166  *
167  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
168  * This allows applications to reconstruct the allowance for all accounts just
169  * by listening to said events. Other implementations of the EIP may not emit
170  * these events, as it isn't required by the specification.
171  *
172  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
173  * functions have been added to mitigate the well-known issues around setting
174  * allowances. See {IERC20-approve}.
175  */
176 contract ERC20 is Context, IERC20, IERC20Metadata {
177     mapping(address => uint256) private _balances;
178  
179     mapping(address => mapping(address => uint256)) private _allowances;
180  
181     uint256 private _totalSupply;
182  
183     string private _name;
184     string private _symbol;
185  
186     /**
187      * @dev Sets the values for {name} and {symbol}.
188      *
189      * The default value of {decimals} is 18. To select a different value for
190      * {decimals} you should overload it.
191      *
192      * All two of these values are immutable: they can only be set once during
193      * construction.
194      */
195     constructor(string memory name_, string memory symbol_) {
196         _name = name_;
197         _symbol = symbol_;
198     }
199  
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() public view virtual override returns (string memory) {
204         return _name;
205     }
206  
207     /**
208      * @dev Returns the symbol of the token, usually a shorter version of the
209      * name.
210      */
211     function symbol() public view virtual override returns (string memory) {
212         return _symbol;
213     }
214  
215     /**
216      * @dev Returns the number of decimals used to get its user representation.
217      * For example, if `decimals` equals `2`, a balance of `505` tokens should
218      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
219      *
220      * Tokens usually opt for a value of 18, imitating the relationship between
221      * Ether and Wei. This is the value {ERC20} uses, unless this function is
222      * overridden;
223      *
224      * NOTE: This information is only used for _display_ purposes: it in
225      * no way affects any of the arithmetic of the contract, including
226      * {IERC20-balanceOf} and {IERC20-transfer}.
227      */
228     function decimals() public view virtual override returns (uint8) {
229         return 18;
230     }
231  
232     /**
233      * @dev See {IERC20-totalSupply}.
234      */
235     function totalSupply() public view virtual override returns (uint256) {
236         return _totalSupply;
237     }
238  
239     /**
240      * @dev See {IERC20-balanceOf}.
241      */
242     function balanceOf(address account) public view virtual override returns (uint256) {
243         return _balances[account];
244     }
245  
246     /**
247      * @dev See {IERC20-transfer}.
248      *
249      * Requirements:
250      *
251      * - `to` cannot be the zero address.
252      * - the caller must have a balance of at least `amount`.
253      */
254     function transfer(address to, uint256 amount) public virtual override returns (bool) {
255         address owner = _msgSender();
256         _transfer(owner, to, amount);
257         return true;
258     }
259  
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266  
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
271      * `transferFrom`. This is semantically equivalent to an infinite approval.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount) public virtual override returns (bool) {
278         address owner = _msgSender();
279         _approve(owner, spender, amount);
280         return true;
281     }
282  
283     /**
284      * @dev See {IERC20-transferFrom}.
285      *
286      * Emits an {Approval} event indicating the updated allowance. This is not
287      * required by the EIP. See the note at the beginning of {ERC20}.
288      *
289      * NOTE: Does not update the allowance if the current allowance
290      * is the maximum `uint256`.
291      *
292      * Requirements:
293      *
294      * - `from` and `to` cannot be the zero address.
295      * - `from` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``from``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address from,
301         address to,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         address spender = _msgSender();
305         _spendAllowance(from, spender, amount);
306         _transfer(from, to, amount);
307         return true;
308     }
309  
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         address owner = _msgSender();
324         _approve(owner, spender, allowance(owner, spender) + addedValue);
325         return true;
326     }
327  
328     /**
329      * @dev Atomically decreases the allowance granted to `spender` by the caller.
330      *
331      * This is an alternative to {approve} that can be used as a mitigation for
332      * problems described in {IERC20-approve}.
333      *
334      * Emits an {Approval} event indicating the updated allowance.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      * - `spender` must have allowance for the caller of at least
340      * `subtractedValue`.
341      */
342     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
343         address owner = _msgSender();
344         uint256 currentAllowance = allowance(owner, spender);
345         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
346         unchecked {
347             _approve(owner, spender, currentAllowance - subtractedValue);
348         }
349  
350         return true;
351     }
352  
353     /**
354      * @dev Moves `amount` of tokens from `from` to `to`.
355      *
356      * This internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `from` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address from,
369         address to,
370         uint256 amount
371     ) internal virtual {
372         require(from != address(0), "ERC20: transfer from the zero address");
373         require(to != address(0), "ERC20: transfer to the zero address");
374  
375         _beforeTokenTransfer(from, to, amount);
376  
377         uint256 fromBalance = _balances[from];
378         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
379         unchecked {
380             _balances[from] = fromBalance - amount;
381         }
382         _balances[to] += amount;
383  
384         emit Transfer(from, to, amount);
385  
386         _afterTokenTransfer(from, to, amount);
387     }
388  
389     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
390      * the total supply.
391      *
392      * Emits a {Transfer} event with `from` set to the zero address.
393      *
394      * Requirements:
395      *
396      * - `account` cannot be the zero address.
397      */
398     function _mint(address account, uint256 amount) internal virtual {
399         require(account != address(0), "ERC20: mint to the zero address");
400  
401         _beforeTokenTransfer(address(0), account, amount);
402  
403         _totalSupply += amount;
404         _balances[account] += amount;
405         emit Transfer(address(0), account, amount);
406  
407         _afterTokenTransfer(address(0), account, amount);
408     }
409  
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423  
424         _beforeTokenTransfer(account, address(0), amount);
425  
426         uint256 accountBalance = _balances[account];
427         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
428         unchecked {
429             _balances[account] = accountBalance - amount;
430         }
431         _totalSupply -= amount;
432  
433         emit Transfer(account, address(0), amount);
434  
435         _afterTokenTransfer(account, address(0), amount);
436     }
437  
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458  
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462  
463     /**
464      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
465      *
466      * Does not update the allowance amount in case of infinite allowance.
467      * Revert if not enough allowance is available.
468      *
469      * Might emit an {Approval} event.
470      */
471     function _spendAllowance(
472         address owner,
473         address spender,
474         uint256 amount
475     ) internal virtual {
476         uint256 currentAllowance = allowance(owner, spender);
477         if (currentAllowance != type(uint256).max) {
478             require(currentAllowance >= amount, "ERC20: insufficient allowance");
479             unchecked {
480                 _approve(owner, spender, currentAllowance - amount);
481             }
482         }
483     }
484  
485     /**
486      * @dev Hook that is called before any transfer of tokens. This includes
487      * minting and burning.
488      *
489      * Calling conditions:
490      *
491      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
492      * will be transferred to `to`.
493      * - when `from` is zero, `amount` tokens will be minted for `to`.
494      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
495      * - `from` and `to` are never both zero.
496      *
497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
498      */
499     function _beforeTokenTransfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {}
504  
505     /**
506      * @dev Hook that is called after any transfer of tokens. This includes
507      * minting and burning.
508      *
509      * Calling conditions:
510      *
511      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
512      * has been transferred to `to`.
513      * - when `from` is zero, `amount` tokens have been minted for `to`.
514      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
515      * - `from` and `to` are never both zero.
516      *
517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
518      */
519     function _afterTokenTransfer(
520         address from,
521         address to,
522         uint256 amount
523     ) internal virtual {}
524 }
525  
526  
527  
528  
529  
530  
531  
532 pragma solidity ^0.8.17;
533  
534  
535 /**
536  * @dev Extension of {ERC20} that allows token holders to destroy both their own
537  * tokens and those that they have an allowance for, in a way that can be
538  * recognized off-chain (via event analysis).
539  */
540 abstract contract ERC20Burnable is Context, ERC20 {
541     /**
542      * @dev Destroys `amount` tokens from the caller.
543      *
544      * See {ERC20-_burn}.
545      */
546     function burn(uint256 amount) public virtual {
547         _burn(_msgSender(), amount);
548     }
549  
550     /**
551      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
552      * allowance.
553      *
554      * See {ERC20-_burn} and {ERC20-allowance}.
555      *
556      * Requirements:
557      *
558      * - the caller must have allowance for ``accounts``'s tokens of at least
559      * `amount`.
560      */
561     function burnFrom(address account, uint256 amount) public virtual {
562         _spendAllowance(account, _msgSender(), amount);
563         _burn(account, amount);
564     }
565 }
566  
567  
568 /**
569  * @dev Contract module which provides a basic access control mechanism, where
570  * there is an account (an owner) that can be granted exclusive access to
571  * specific functions.
572  *
573  * By default, the owner account will be the one that deploys the contract. This
574  * can later be changed with {transferOwnership}.
575  *
576  * This module is used through inheritance. It will make available the modifier
577  * `onlyOwner`, which can be applied to your functions to restrict their use to
578  * the owner.
579  */
580 abstract contract Ownable is Context {
581     address private _owner;
582  
583     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
584  
585     /**
586      * @dev Initializes the contract setting the deployer as the initial owner.
587      */
588     constructor() {
589         _transferOwnership(_msgSender());
590     }
591  
592     /**
593      * @dev Throws if called by any account other than the owner.
594      */
595     modifier onlyOwner() {
596         _checkOwner();
597         _;
598     }
599  
600     /**
601      * @dev Returns the address of the current owner.
602      */
603     function owner() public view virtual returns (address) {
604         return _owner;
605     }
606  
607     /**
608      * @dev Throws if the sender is not the owner.
609      */
610     function _checkOwner() internal view virtual {
611         require(owner() == _msgSender(), "Ownable: caller is not the owner");
612     }
613  
614     /**
615      * @dev Leaves the contract without owner. It will not be possible to call
616      * `onlyOwner` functions anymore. Can only be called by the current owner.
617      *
618      * NOTE: Renouncing ownership will leave the contract without an owner,
619      * thereby removing any functionality that is only available to the owner.
620      */
621     function renounceOwnership() public virtual onlyOwner {
622         _transferOwnership(address(0));
623     }
624  
625     /**
626      * @dev Transfers ownership of the contract to a new account (`newOwner`).
627      * Can only be called by the current owner.
628      */
629     function transferOwnership(address newOwner) public virtual onlyOwner {
630         require(newOwner != address(0), "Ownable: new owner is the zero address");
631         _transferOwnership(newOwner);
632     }
633  
634     /**
635      * @dev Transfers ownership of the contract to a new account (`newOwner`).
636      * Internal function without access restriction.
637      */
638     function _transferOwnership(address newOwner) internal virtual {
639         address oldOwner = _owner;
640         _owner = newOwner;
641         emit OwnershipTransferred(oldOwner, newOwner);
642     }
643 }
644  
645  
646  
647  
648 interface IUniswapV2Factory {
649     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
650  
651     function feeTo() external view returns (address);
652     function feeToSetter() external view returns (address);
653  
654     function getPair(address tokenA, address tokenB) external view returns (address pair);
655     function allPairs(uint) external view returns (address pair);
656     function allPairsLength() external view returns (uint);
657  
658     function createPair(address tokenA, address tokenB) external returns (address pair);
659  
660     function setFeeTo(address) external;
661     function setFeeToSetter(address) external;
662 }
663  
664 interface IUniswapV2Pair {
665     event Approval(address indexed owner, address indexed spender, uint value);
666     event Transfer(address indexed from, address indexed to, uint value);
667  
668     function name() external pure returns (string memory);
669     function symbol() external pure returns (string memory);
670     function decimals() external pure returns (uint8);
671     function totalSupply() external view returns (uint);
672     function balanceOf(address owner) external view returns (uint);
673     function allowance(address owner, address spender) external view returns (uint);
674  
675     function approve(address spender, uint value) external returns (bool);
676     function transfer(address to, uint value) external returns (bool);
677     function transferFrom(address from, address to, uint value) external returns (bool);
678  
679     function DOMAIN_SEPARATOR() external view returns (bytes32);
680     function PERMIT_TYPEHASH() external pure returns (bytes32);
681     function nonces(address owner) external view returns (uint);
682  
683     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
684  
685     event Mint(address indexed sender, uint amount0, uint amount1);
686     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
687     event Swap(
688         address indexed sender,
689         uint amount0In,
690         uint amount1In,
691         uint amount0Out,
692         uint amount1Out,
693         address indexed to
694     );
695     event Sync(uint112 reserve0, uint112 reserve1);
696  
697     function MINIMUM_LIQUIDITY() external pure returns (uint);
698     function factory() external view returns (address);
699     function token0() external view returns (address);
700     function token1() external view returns (address);
701     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
702     function price0CumulativeLast() external view returns (uint);
703     function price1CumulativeLast() external view returns (uint);
704     function kLast() external view returns (uint);
705  
706     function mint(address to) external returns (uint liquidity);
707     function burn(address to) external returns (uint amount0, uint amount1);
708     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
709     function skim(address to) external;
710     function sync() external;
711  
712     function initialize(address, address) external;
713 }
714  
715 interface IUniswapV2Router01 {
716     function factory() external pure returns (address);
717     function WETH() external pure returns (address);
718  
719     function addLiquidity(
720         address tokenA,
721         address tokenB,
722         uint amountADesired,
723         uint amountBDesired,
724         uint amountAMin,
725         uint amountBMin,
726         address to,
727         uint deadline
728     ) external returns (uint amountA, uint amountB, uint liquidity);
729     function addLiquidityETH(
730         address token,
731         uint amountTokenDesired,
732         uint amountTokenMin,
733         uint amountETHMin,
734         address to,
735         uint deadline
736     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
737     function removeLiquidity(
738         address tokenA,
739         address tokenB,
740         uint liquidity,
741         uint amountAMin,
742         uint amountBMin,
743         address to,
744         uint deadline
745     ) external returns (uint amountA, uint amountB);
746     function removeLiquidityETH(
747         address token,
748         uint liquidity,
749         uint amountTokenMin,
750         uint amountETHMin,
751         address to,
752         uint deadline
753     ) external returns (uint amountToken, uint amountETH);
754     function removeLiquidityWithPermit(
755         address tokenA,
756         address tokenB,
757         uint liquidity,
758         uint amountAMin,
759         uint amountBMin,
760         address to,
761         uint deadline,
762         bool approveMax, uint8 v, bytes32 r, bytes32 s
763     ) external returns (uint amountA, uint amountB);
764     function removeLiquidityETHWithPermit(
765         address token,
766         uint liquidity,
767         uint amountTokenMin,
768         uint amountETHMin,
769         address to,
770         uint deadline,
771         bool approveMax, uint8 v, bytes32 r, bytes32 s
772     ) external returns (uint amountToken, uint amountETH);
773     function swapExactTokensForTokens(
774         uint amountIn,
775         uint amountOutMin,
776         address[] calldata path,
777         address to,
778         uint deadline
779     ) external returns (uint[] memory amounts);
780     function swapTokensForExactTokens(
781         uint amountOut,
782         uint amountInMax,
783         address[] calldata path,
784         address to,
785         uint deadline
786     ) external returns (uint[] memory amounts);
787     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
788     external
789     payable
790     returns (uint[] memory amounts);
791     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
792     external
793     returns (uint[] memory amounts);
794     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
795     external
796     returns (uint[] memory amounts);
797     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
798     external
799     payable
800     returns (uint[] memory amounts);
801  
802     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
803     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
804     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
805     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
806     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
807 }
808  
809 interface IUniswapV2Router02 is IUniswapV2Router01{
810     function removeLiquidityETHSupportingFeeOnTransferTokens(
811         address token,
812         uint liquidity,
813         uint amountTokenMin,
814         uint amountETHMin,
815         address to,
816         uint deadline
817     ) external returns (uint amountETH);
818     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
819         address token,
820         uint liquidity,
821         uint amountTokenMin,
822         uint amountETHMin,
823         address to,
824         uint deadline,
825         bool approveMax, uint8 v, bytes32 r, bytes32 s
826     ) external returns (uint amountETH);
827  
828     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
829         uint amountIn,
830         uint amountOutMin,
831         address[] calldata path,
832         address to,
833         uint deadline
834     ) external;
835     function swapExactETHForTokensSupportingFeeOnTransferTokens(
836         uint amountOutMin,
837         address[] calldata path,
838         address to,
839         uint deadline
840     ) external payable;
841     function swapExactTokensForETHSupportingFeeOnTransferTokens(
842         uint amountIn,
843         uint amountOutMin,
844         address[] calldata path,
845         address to,
846         uint deadline
847     ) external;
848 }
849  
850 interface IWETH {
851     function deposit() external payable;
852     function transfer(address to, uint value) external returns (bool);
853     function withdraw(uint) external;
854 }
855  
856  
857 interface IUniswapV2ERC20 {
858     event Approval(address indexed owner, address indexed spender, uint value);
859     event Transfer(address indexed from, address indexed to, uint value);
860  
861     function name() external pure returns (string memory);
862     function symbol() external pure returns (string memory);
863     function decimals() external pure returns (uint8);
864     function totalSupply() external view returns (uint);
865     function balanceOf(address owner) external view returns (uint);
866     function allowance(address owner, address spender) external view returns (uint);
867  
868     function approve(address spender, uint value) external returns (bool);
869     function transfer(address to, uint value) external returns (bool);
870     function transferFrom(address from, address to, uint value) external returns (bool);
871  
872     function DOMAIN_SEPARATOR() external view returns (bytes32);
873     function PERMIT_TYPEHASH() external pure returns (bytes32);
874     function nonces(address owner) external view returns (uint);
875  
876     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
877 }
878  
879  
880  
881  
882  
883  
884 pragma solidity ^0.8.17;
885  
886  
887  
888  
889 contract NEOAI is ERC20Burnable, Ownable {
890     uint256 private constant TOTAL_SUPPLY = 1_000_000e18;
891     address public marketingWallet;
892     uint256 public maxPercentToSwap = 5;
893     IUniswapV2Router02 public uniswapV2Router;
894     address public  uniswapV2Pair;
895  
896     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
897     address private constant ZERO = 0x0000000000000000000000000000000000000000;
898  
899     bool private swapping;
900     uint256 public swapTokensAtAmount;
901     bool public isTradingEnabled;
902  
903     mapping(address => bool) private _isExcludedFromFees;
904     mapping(address => bool) public automatedMarketMakerPairs;
905  
906     event ExcludeFromFees(address indexed account);
907     event FeesUpdated(uint256 sellFee, uint256 buyFee);
908     event MarketingWalletChanged(address marketingWallet);
909     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
910     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
911     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
912  
913     uint256 public sellFee;
914     uint256 public buyFee;
915  
916  
917     bool public isBotProtectionDisabledPermanently;
918     uint256 public maxTxAmount;
919     uint256 public maxHolding;
920     mapping(address => bool) public isExempt;
921  
922     constructor (address router, address operator) ERC20("NEO AI", "NEOAI")
923     {
924         _mint(owner(), TOTAL_SUPPLY);
925  
926         swapTokensAtAmount = TOTAL_SUPPLY / 1000;
927         maxHolding = TOTAL_SUPPLY / 100;
928         maxTxAmount = TOTAL_SUPPLY / 100;
929         marketingWallet = operator;
930         sellFee = 30;
931         buyFee = 5;
932  
933         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
934         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
935         .createPair(address(this), _uniswapV2Router.WETH());
936  
937         uniswapV2Router = _uniswapV2Router;
938         uniswapV2Pair = _uniswapV2Pair;
939  
940         _approve(address(this), address(uniswapV2Router), type(uint256).max);
941  
942         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
943  
944         _isExcludedFromFees[owner()] = true;
945         _isExcludedFromFees[DEAD] = true;
946         _isExcludedFromFees[address(this)] = true;
947         _isExcludedFromFees[address(uniswapV2Router)] = true;
948  
949  
950         isExempt[address(uniswapV2Router)] = true;
951         isExempt[owner()] = true;
952     }
953  
954     receive() external payable {
955     }
956  
957     function openTrade() public onlyOwner {
958         require(isTradingEnabled == false, "Trading is already open!");
959         isTradingEnabled = true;
960     }
961  
962     function claimStuckTokens(address token) external onlyOwner {
963         require(token != address(this), "Owner cannot claim native tokens");
964         if (token == address(0x0)) {
965             payable(msg.sender).transfer(address(this).balance);
966             return;
967         }
968         IERC20 ERC20token = IERC20(token);
969         uint256 balance = ERC20token.balanceOf(address(this));
970         ERC20token.transfer(msg.sender, balance);
971     }
972  
973     function sendETH(address payable recipient, uint256 amount) internal {
974  
975         recipient.call{gas : 2300, value : amount}("");
976     }
977  
978     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
979         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
980  
981         _setAutomatedMarketMakerPair(pair, value);
982     }
983  
984     function _setAutomatedMarketMakerPair(address pair, bool value) private {
985         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
986         automatedMarketMakerPairs[pair] = value;
987  
988         emit SetAutomatedMarketMakerPair(pair, value);
989     }
990  
991     //=======FeeManagement=======//
992     function excludeFromFees(address account) external onlyOwner {
993         require(!_isExcludedFromFees[account], "Account is already the value of true");
994         _isExcludedFromFees[account] = true;
995  
996         emit ExcludeFromFees(account);
997     }
998  
999     function includeInFees(address account) external onlyOwner {
1000         require(_isExcludedFromFees[account], "Account already included");
1001         _isExcludedFromFees[account] = false;
1002     }
1003  
1004     function isExcludedFromFees(address account) public view returns (bool) {
1005         return _isExcludedFromFees[account];
1006     }
1007  
1008     function updateFees(uint256 _sellFee, uint256 _buyFee) external onlyOwner {
1009         require(_sellFee <= 15, "Fees must be less than 15%");
1010         require(_buyFee <= 15, "Fees must be less than 15%");
1011         sellFee = _sellFee;
1012         buyFee = _buyFee;
1013  
1014         emit FeesUpdated(sellFee, buyFee);
1015     }
1016  
1017     function changeMarketingWallet(address _marketingWallet) external onlyOwner {
1018         require(_marketingWallet != marketingWallet, "Marketing wallet is already that address");
1019         marketingWallet = _marketingWallet;
1020         emit MarketingWalletChanged(marketingWallet);
1021     }
1022  
1023     function _transfer(
1024         address from,
1025         address to,
1026         uint256 amount
1027     ) internal override {
1028         require(from != address(0), "ERC20: transfer from the zero address");
1029         require(to != address(0), "ERC20: transfer to the zero address");
1030  
1031         if (!swapping) {
1032             _check(from, to, amount);
1033         }
1034  
1035         uint _buyFee = buyFee;
1036         uint _sellFee = sellFee;
1037  
1038         if (!isExempt[from] && !isExempt[to]) {
1039             require(isTradingEnabled, "Trade is not open");
1040         }
1041  
1042         if (amount == 0) {
1043             return;
1044         }
1045  
1046         bool takeFee = !swapping;
1047  
1048         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1049             takeFee = false;
1050         }
1051  
1052         uint256 toSwap = balanceOf(address(this));
1053  
1054         bool canSwap = toSwap >= swapTokensAtAmount && toSwap > 0 && !automatedMarketMakerPairs[from] && takeFee;
1055         if (canSwap &&
1056             !swapping) {
1057             swapping = true;
1058             uint256 pairBalance = balanceOf(uniswapV2Pair);
1059             if (toSwap > pairBalance * maxPercentToSwap / 100) {
1060                 toSwap = pairBalance * maxPercentToSwap / 100;
1061             }
1062             swapAndSendMarketing(toSwap);
1063             swapping = false;
1064         }
1065  
1066         if (takeFee && to == uniswapV2Pair && _sellFee > 0) {
1067             uint256 fees = (amount * _sellFee) / 100;
1068             amount = amount - fees;
1069  
1070             super._transfer(from, address(this), fees);
1071         }
1072         else if (takeFee && from == uniswapV2Pair && _buyFee > 0) {
1073             uint256 fees = (amount * _buyFee) / 100;
1074             amount = amount - fees;
1075  
1076             super._transfer(from, address(this), fees);
1077         }
1078  
1079         super._transfer(from, to, amount);
1080     }
1081  
1082     //=======Swap=======//
1083     function swapAndSendMarketing(uint256 tokenAmount) private {
1084  
1085         address[] memory path = new address[](2);
1086         path[0] = address(this);
1087         path[1] = uniswapV2Router.WETH();
1088  
1089         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1090             tokenAmount,
1091             0, 
1092             path,
1093             address(this),
1094             block.timestamp) {}
1095         catch {
1096         }
1097  
1098         uint256 newBalance = address(this).balance;
1099         sendETH(payable(marketingWallet), newBalance);
1100  
1101         emit SwapAndSendMarketing(tokenAmount, newBalance);
1102     }
1103  
1104     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
1105         require(newAmount > 0);
1106         swapTokensAtAmount = newAmount;
1107     }
1108  
1109     function setMaxPercentToSwap(uint256 newAmount) external onlyOwner {
1110         require(newAmount > 1, "too low");
1111         require(newAmount <= 10, "too high");
1112         maxPercentToSwap = newAmount;
1113     }
1114  
1115     function _check(
1116         address from,
1117         address to,
1118         uint256 amount
1119     ) internal {
1120  
1121         if (!isBotProtectionDisabledPermanently) {
1122  
1123             if (!isSpecialAddresses(from, to) && !isExempt[to]) {
1124                 _checkMaxTxAmount(to, amount);
1125  
1126                 _checkMaxHoldingLimit(to, amount);
1127             }
1128         }
1129     }
1130  
1131     function _checkMaxTxAmount(address to, uint256 amount) internal view {
1132         require(amount <= maxTxAmount, "Amount exceeds max");
1133  
1134     }
1135  
1136     function _checkMaxHoldingLimit(address to, uint256 amount) internal view {
1137         if (to == uniswapV2Pair) {
1138             return;
1139         }
1140  
1141         require(balanceOf(to) + amount <= maxHolding, "Max holding exceeded max");
1142  
1143     }
1144  
1145     function isSpecialAddresses(address from, address to) view public returns (bool){
1146  
1147         return (from == owner() || to == owner() || from == address(this) || to == address(this));
1148     }
1149  
1150     function disableBotProtectionPermanently() external onlyOwner {
1151         isBotProtectionDisabledPermanently = true;
1152     }
1153  
1154     function setMaxTxAmount(uint256 maxTxAmount_) external onlyOwner {
1155         maxTxAmount = maxTxAmount_;
1156     }
1157  
1158     function setMaxHolding(uint256 maxHolding_) external onlyOwner {
1159         maxHolding = maxHolding_;
1160     }
1161  
1162     function setExempt(address who, bool status) public onlyOwner {
1163         isExempt[who] = status;
1164     }
1165 }