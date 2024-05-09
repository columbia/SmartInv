1 /*
2 
3 
4         ,----,                                                     
5       ,/   .`|                                                     
6     ,`   .'  :          ,---,        ,---,.                        
7   ;    ;     /        ,--.' |      ,'  .'  \                       
8 .'___,/    ,'         |  |  :    ,---.' .' |                       
9 |    :     |          :  :  :    |   |  |: |             ,----._,. 
10 ;    |.';  ;   ,---.  :  |  |,--.:   :  :  /  ,--.--.   /   /  ' / 
11 `----'  |  |  /     \ |  :  '   |:   |    ;  /       \ |   :     | 
12     '   :  ; /    /  ||  |   /' :|   :     \.--.  .-. ||   | .\  . 
13     |   |  '.    ' / |'  :  | | ||   |   . | \__\/: . ..   ; ';  | 
14     '   :  |'   ;   /||  |  ' | :'   :  '; | ," .--.; |'   .   . | 
15     ;   |.' '   |  / ||  :  :_:,'|   |  | ; /  /  ,.  | `---`-'| | 
16     '---'   |   :    ||  | ,'    |   :   / ;  :   .'   \.'__/\_: | 
17              \   \  / `--''      |   | ,'  |  ,     .-./|   :    : 
18               `----'             `----'     `--`---'     \   \  /  
19                                                           `--`-'   
20 
21 
22 5353427A614746736243426E61585A6C49486C7664534230614755675A326C6D644342765A69423562335679633256735A67
23 
24 Socials:
25 Twitter: https://twitter.com/teh_bag
26 Telegram: t.me/teh_bag
27 
28 */
29 
30 pragma solidity ^0.8.0;
31  
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
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
49  
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54  
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59  
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `to`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address to, uint256 amount) external returns (bool);
68  
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77  
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93  
94     /**
95      * @dev Moves `amount` tokens from `from` to `to` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(
104         address from,
105         address to,
106         uint256 amount
107     ) external returns (bool);
108 }
109  
110  
111  
112  
113  
114  
115  
116 pragma solidity ^0.8.0;
117  
118 /**
119  * @dev Interface for the optional metadata functions from the ERC20 standard.
120  *
121  * _Available since v4.1._
122  */
123 interface IERC20Metadata is IERC20 {
124     /**
125      * @dev Returns the name of the token.
126      */
127     function name() external view returns (string memory);
128  
129     /**
130      * @dev Returns the symbol of the token.
131      */
132     function symbol() external view returns (string memory);
133  
134     /**
135      * @dev Returns the decimals places of the token.
136      */
137     function decimals() external view returns (uint8);
138 }
139  
140  
141  
142  
143  
144  
145  
146 pragma solidity ^0.8.0;
147  
148 /**
149  * @dev Provides information about the current execution context, including the
150  * sender of the transaction and its data. While these are generally available
151  * via msg.sender and msg.data, they should not be accessed in such a direct
152  * manner, since when dealing with meta-transactions the account sending and
153  * paying for execution may not be the actual sender (as far as an application
154  * is concerned).
155  *
156  * This contract is only required for intermediate, library-like contracts.
157  */
158 abstract contract Context {
159     function _msgSender() internal view virtual returns (address) {
160         return msg.sender;
161     }
162  
163     function _msgData() internal view virtual returns (bytes calldata) {
164         return msg.data;
165     }
166 }
167  
168  
169  
170  
171  
172  
173  
174 pragma solidity ^0.8.0;
175  
176  
177  
178 /**
179  * @dev Implementation of the {IERC20} interface.
180  *
181  * This implementation is agnostic to the way tokens are created. This means
182  * that a supply mechanism has to be added in a derived contract using {_mint}.
183  * For a generic mechanism see {ERC20PresetMinterPauser}.
184  *
185  * TIP: For a detailed writeup see our guide
186  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
187  * to implement supply mechanisms].
188  *
189  * We have followed general OpenZeppelin Contracts guidelines: functions revert
190  * instead returning `false` on failure. This behavior is nonetheless
191  * conventional and does not conflict with the expectations of ERC20
192  * applications.
193  *
194  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
195  * This allows applications to reconstruct the allowance for all accounts just
196  * by listening to said events. Other implementations of the EIP may not emit
197  * these events, as it isn't required by the specification.
198  *
199  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
200  * functions have been added to mitigate the well-known issues around setting
201  * allowances. See {IERC20-approve}.
202  */
203 contract ERC20 is Context, IERC20, IERC20Metadata {
204     mapping(address => uint256) private _balances;
205  
206     mapping(address => mapping(address => uint256)) private _allowances;
207  
208     uint256 private _totalSupply;
209  
210     string private _name;
211     string private _symbol;
212  
213     /**
214      * @dev Sets the values for {name} and {symbol}.
215      *
216      * The default value of {decimals} is 18. To select a different value for
217      * {decimals} you should overload it.
218      *
219      * All two of these values are immutable: they can only be set once during
220      * construction.
221      */
222     constructor(string memory name_, string memory symbol_) {
223         _name = name_;
224         _symbol = symbol_;
225     }
226  
227     /**
228      * @dev Returns the name of the token.
229      */
230     function name() public view virtual override returns (string memory) {
231         return _name;
232     }
233  
234     /**
235      * @dev Returns the symbol of the token, usually a shorter version of the
236      * name.
237      */
238     function symbol() public view virtual override returns (string memory) {
239         return _symbol;
240     }
241  
242     /**
243      * @dev Returns the number of decimals used to get its user representation.
244      * For example, if `decimals` equals `2`, a balance of `505` tokens should
245      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
246      *
247      * Tokens usually opt for a value of 18, imitating the relationship between
248      * Ether and Wei. This is the value {ERC20} uses, unless this function is
249      * overridden;
250      *
251      * NOTE: This information is only used for _display_ purposes: it in
252      * no way affects any of the arithmetic of the contract, including
253      * {IERC20-balanceOf} and {IERC20-transfer}.
254      */
255     function decimals() public view virtual override returns (uint8) {
256         return 18;
257     }
258  
259     /**
260      * @dev See {IERC20-totalSupply}.
261      */
262     function totalSupply() public view virtual override returns (uint256) {
263         return _totalSupply;
264     }
265  
266     /**
267      * @dev See {IERC20-balanceOf}.
268      */
269     function balanceOf(address account) public view virtual override returns (uint256) {
270         return _balances[account];
271     }
272  
273     /**
274      * @dev See {IERC20-transfer}.
275      *
276      * Requirements:
277      *
278      * - `to` cannot be the zero address.
279      * - the caller must have a balance of at least `amount`.
280      */
281     function transfer(address to, uint256 amount) public virtual override returns (bool) {
282         address owner = _msgSender();
283         _transfer(owner, to, amount);
284         return true;
285     }
286  
287     /**
288      * @dev See {IERC20-allowance}.
289      */
290     function allowance(address owner, address spender) public view virtual override returns (uint256) {
291         return _allowances[owner][spender];
292     }
293  
294     /**
295      * @dev See {IERC20-approve}.
296      *
297      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
298      * `transferFrom`. This is semantically equivalent to an infinite approval.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function approve(address spender, uint256 amount) public virtual override returns (bool) {
305         address owner = _msgSender();
306         _approve(owner, spender, amount);
307         return true;
308     }
309  
310     /**
311      * @dev See {IERC20-transferFrom}.
312      *
313      * Emits an {Approval} event indicating the updated allowance. This is not
314      * required by the EIP. See the note at the beginning of {ERC20}.
315      *
316      * NOTE: Does not update the allowance if the current allowance
317      * is the maximum `uint256`.
318      *
319      * Requirements:
320      *
321      * - `from` and `to` cannot be the zero address.
322      * - `from` must have a balance of at least `amount`.
323      * - the caller must have allowance for ``from``'s tokens of at least
324      * `amount`.
325      */
326     function transferFrom(
327         address from,
328         address to,
329         uint256 amount
330     ) public virtual override returns (bool) {
331         address spender = _msgSender();
332         _spendAllowance(from, spender, amount);
333         _transfer(from, to, amount);
334         return true;
335     }
336  
337     /**
338      * @dev Atomically increases the allowance granted to `spender` by the caller.
339      *
340      * This is an alternative to {approve} that can be used as a mitigation for
341      * problems described in {IERC20-approve}.
342      *
343      * Emits an {Approval} event indicating the updated allowance.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
350         address owner = _msgSender();
351         _approve(owner, spender, allowance(owner, spender) + addedValue);
352         return true;
353     }
354  
355     /**
356      * @dev Atomically decreases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to {approve} that can be used as a mitigation for
359      * problems described in {IERC20-approve}.
360      *
361      * Emits an {Approval} event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      * - `spender` must have allowance for the caller of at least
367      * `subtractedValue`.
368      */
369     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
370         address owner = _msgSender();
371         uint256 currentAllowance = allowance(owner, spender);
372         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
373         unchecked {
374             _approve(owner, spender, currentAllowance - subtractedValue);
375         }
376  
377         return true;
378     }
379  
380     /**
381      * @dev Moves `amount` of tokens from `from` to `to`.
382      *
383      * This internal function is equivalent to {transfer}, and can be used to
384      * e.g. implement automatic token fees, slashing mechanisms, etc.
385      *
386      * Emits a {Transfer} event.
387      *
388      * Requirements:
389      *
390      * - `from` cannot be the zero address.
391      * - `to` cannot be the zero address.
392      * - `from` must have a balance of at least `amount`.
393      */
394     function _transfer(
395         address from,
396         address to,
397         uint256 amount
398     ) internal virtual {
399         require(from != address(0), "ERC20: transfer from the zero address");
400         require(to != address(0), "ERC20: transfer to the zero address");
401  
402         _beforeTokenTransfer(from, to, amount);
403  
404         uint256 fromBalance = _balances[from];
405         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
406         unchecked {
407             _balances[from] = fromBalance - amount;
408         }
409         _balances[to] += amount;
410  
411         emit Transfer(from, to, amount);
412  
413         _afterTokenTransfer(from, to, amount);
414     }
415  
416     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
417      * the total supply.
418      *
419      * Emits a {Transfer} event with `from` set to the zero address.
420      *
421      * Requirements:
422      *
423      * - `account` cannot be the zero address.
424      */
425     function _mint(address account, uint256 amount) internal virtual {
426         require(account != address(0), "ERC20: mint to the zero address");
427  
428         _beforeTokenTransfer(address(0), account, amount);
429  
430         _totalSupply += amount;
431         _balances[account] += amount;
432         emit Transfer(address(0), account, amount);
433  
434         _afterTokenTransfer(address(0), account, amount);
435     }
436  
437     /**
438      * @dev Destroys `amount` tokens from `account`, reducing the
439      * total supply.
440      *
441      * Emits a {Transfer} event with `to` set to the zero address.
442      *
443      * Requirements:
444      *
445      * - `account` cannot be the zero address.
446      * - `account` must have at least `amount` tokens.
447      */
448     function _burn(address account, uint256 amount) internal virtual {
449         require(account != address(0), "ERC20: burn from the zero address");
450  
451         _beforeTokenTransfer(account, address(0), amount);
452  
453         uint256 accountBalance = _balances[account];
454         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
455         unchecked {
456             _balances[account] = accountBalance - amount;
457         }
458         _totalSupply -= amount;
459  
460         emit Transfer(account, address(0), amount);
461  
462         _afterTokenTransfer(account, address(0), amount);
463     }
464  
465     /**
466      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
467      *
468      * This internal function is equivalent to `approve`, and can be used to
469      * e.g. set automatic allowances for certain subsystems, etc.
470      *
471      * Emits an {Approval} event.
472      *
473      * Requirements:
474      *
475      * - `owner` cannot be the zero address.
476      * - `spender` cannot be the zero address.
477      */
478     function _approve(
479         address owner,
480         address spender,
481         uint256 amount
482     ) internal virtual {
483         require(owner != address(0), "ERC20: approve from the zero address");
484         require(spender != address(0), "ERC20: approve to the zero address");
485  
486         _allowances[owner][spender] = amount;
487         emit Approval(owner, spender, amount);
488     }
489  
490     /**
491      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
492      *
493      * Does not update the allowance amount in case of infinite allowance.
494      * Revert if not enough allowance is available.
495      *
496      * Might emit an {Approval} event.
497      */
498     function _spendAllowance(
499         address owner,
500         address spender,
501         uint256 amount
502     ) internal virtual {
503         uint256 currentAllowance = allowance(owner, spender);
504         if (currentAllowance != type(uint256).max) {
505             require(currentAllowance >= amount, "ERC20: insufficient allowance");
506             unchecked {
507                 _approve(owner, spender, currentAllowance - amount);
508             }
509         }
510     }
511  
512     /**
513      * @dev Hook that is called before any transfer of tokens. This includes
514      * minting and burning.
515      *
516      * Calling conditions:
517      *
518      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
519      * will be transferred to `to`.
520      * - when `from` is zero, `amount` tokens will be minted for `to`.
521      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
522      * - `from` and `to` are never both zero.
523      *
524      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
525      */
526     function _beforeTokenTransfer(
527         address from,
528         address to,
529         uint256 amount
530     ) internal virtual {}
531  
532     /**
533      * @dev Hook that is called after any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * has been transferred to `to`.
540      * - when `from` is zero, `amount` tokens have been minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546     function _afterTokenTransfer(
547         address from,
548         address to,
549         uint256 amount
550     ) internal virtual {}
551 }
552  
553  
554  
555  
556  
557  
558  
559 pragma solidity ^0.8.0;
560  
561  
562 /**
563  * @dev Extension of {ERC20} that allows token holders to destroy both their own
564  * tokens and those that they have an allowance for, in a way that can be
565  * recognized off-chain (via event analysis).
566  */
567 abstract contract ERC20Burnable is Context, ERC20 {
568     /**
569      * @dev Destroys `amount` tokens from the caller.
570      *
571      * See {ERC20-_burn}.
572      */
573     function burn(uint256 amount) public virtual {
574         _burn(_msgSender(), amount);
575     }
576  
577     /**
578      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
579      * allowance.
580      *
581      * See {ERC20-_burn} and {ERC20-allowance}.
582      *
583      * Requirements:
584      *
585      * - the caller must have allowance for ``accounts``'s tokens of at least
586      * `amount`.
587      */
588     function burnFrom(address account, uint256 amount) public virtual {
589         _spendAllowance(account, _msgSender(), amount);
590         _burn(account, amount);
591     }
592 }
593  
594  
595 /**
596  * @dev Contract module which provides a basic access control mechanism, where
597  * there is an account (an owner) that can be granted exclusive access to
598  * specific functions.
599  *
600  * By default, the owner account will be the one that deploys the contract. This
601  * can later be changed with {transferOwnership}.
602  *
603  * This module is used through inheritance. It will make available the modifier
604  * `onlyOwner`, which can be applied to your functions to restrict their use to
605  * the owner.
606  */
607 abstract contract Ownable is Context {
608     address private _owner;
609  
610     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
611  
612     /**
613      * @dev Initializes the contract setting the deployer as the initial owner.
614      */
615     constructor() {
616         _transferOwnership(_msgSender());
617     }
618  
619     /**
620      * @dev Throws if called by any account other than the owner.
621      */
622     modifier onlyOwner() {
623         _checkOwner();
624         _;
625     }
626  
627     /**
628      * @dev Returns the address of the current owner.
629      */
630     function owner() public view virtual returns (address) {
631         return _owner;
632     }
633  
634     /**
635      * @dev Throws if the sender is not the owner.
636      */
637     function _checkOwner() internal view virtual {
638         require(owner() == _msgSender(), "Ownable: caller is not the owner");
639     }
640  
641     /**
642      * @dev Leaves the contract without owner. It will not be possible to call
643      * `onlyOwner` functions anymore. Can only be called by the current owner.
644      *
645      * NOTE: Renouncing ownership will leave the contract without an owner,
646      * thereby removing any functionality that is only available to the owner.
647      */
648     function renounceOwnership() public virtual onlyOwner {
649         _transferOwnership(address(0));
650     }
651  
652     /**
653      * @dev Transfers ownership of the contract to a new account (`newOwner`).
654      * Can only be called by the current owner.
655      */
656     function transferOwnership(address newOwner) public virtual onlyOwner {
657         require(newOwner != address(0), "Ownable: new owner is the zero address");
658         _transferOwnership(newOwner);
659     }
660  
661     /**
662      * @dev Transfers ownership of the contract to a new account (`newOwner`).
663      * Internal function without access restriction.
664      */
665     function _transferOwnership(address newOwner) internal virtual {
666         address oldOwner = _owner;
667         _owner = newOwner;
668         emit OwnershipTransferred(oldOwner, newOwner);
669     }
670 }
671  
672  
673  
674  
675 interface IUniswapV2Factory {
676     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
677  
678     function feeTo() external view returns (address);
679     function feeToSetter() external view returns (address);
680  
681     function getPair(address tokenA, address tokenB) external view returns (address pair);
682     function allPairs(uint) external view returns (address pair);
683     function allPairsLength() external view returns (uint);
684  
685     function createPair(address tokenA, address tokenB) external returns (address pair);
686  
687     function setFeeTo(address) external;
688     function setFeeToSetter(address) external;
689 }
690  
691 interface IUniswapV2Pair {
692     event Approval(address indexed owner, address indexed spender, uint value);
693     event Transfer(address indexed from, address indexed to, uint value);
694  
695     function name() external pure returns (string memory);
696     function symbol() external pure returns (string memory);
697     function decimals() external pure returns (uint8);
698     function totalSupply() external view returns (uint);
699     function balanceOf(address owner) external view returns (uint);
700     function allowance(address owner, address spender) external view returns (uint);
701  
702     function approve(address spender, uint value) external returns (bool);
703     function transfer(address to, uint value) external returns (bool);
704     function transferFrom(address from, address to, uint value) external returns (bool);
705  
706     function DOMAIN_SEPARATOR() external view returns (bytes32);
707     function PERMIT_TYPEHASH() external pure returns (bytes32);
708     function nonces(address owner) external view returns (uint);
709  
710     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
711  
712     event Mint(address indexed sender, uint amount0, uint amount1);
713     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
714     event Swap(
715         address indexed sender,
716         uint amount0In,
717         uint amount1In,
718         uint amount0Out,
719         uint amount1Out,
720         address indexed to
721     );
722     event Sync(uint112 reserve0, uint112 reserve1);
723  
724     function MINIMUM_LIQUIDITY() external pure returns (uint);
725     function factory() external view returns (address);
726     function token0() external view returns (address);
727     function token1() external view returns (address);
728     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
729     function price0CumulativeLast() external view returns (uint);
730     function price1CumulativeLast() external view returns (uint);
731     function kLast() external view returns (uint);
732  
733     function mint(address to) external returns (uint liquidity);
734     function burn(address to) external returns (uint amount0, uint amount1);
735     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
736     function skim(address to) external;
737     function sync() external;
738  
739     function initialize(address, address) external;
740 }
741  
742 interface IUniswapV2Router01 {
743     function factory() external pure returns (address);
744     function WETH() external pure returns (address);
745  
746     function addLiquidity(
747         address tokenA,
748         address tokenB,
749         uint amountADesired,
750         uint amountBDesired,
751         uint amountAMin,
752         uint amountBMin,
753         address to,
754         uint deadline
755     ) external returns (uint amountA, uint amountB, uint liquidity);
756     function addLiquidityETH(
757         address token,
758         uint amountTokenDesired,
759         uint amountTokenMin,
760         uint amountETHMin,
761         address to,
762         uint deadline
763     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
764     function removeLiquidity(
765         address tokenA,
766         address tokenB,
767         uint liquidity,
768         uint amountAMin,
769         uint amountBMin,
770         address to,
771         uint deadline
772     ) external returns (uint amountA, uint amountB);
773     function removeLiquidityETH(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline
780     ) external returns (uint amountToken, uint amountETH);
781     function removeLiquidityWithPermit(
782         address tokenA,
783         address tokenB,
784         uint liquidity,
785         uint amountAMin,
786         uint amountBMin,
787         address to,
788         uint deadline,
789         bool approveMax, uint8 v, bytes32 r, bytes32 s
790     ) external returns (uint amountA, uint amountB);
791     function removeLiquidityETHWithPermit(
792         address token,
793         uint liquidity,
794         uint amountTokenMin,
795         uint amountETHMin,
796         address to,
797         uint deadline,
798         bool approveMax, uint8 v, bytes32 r, bytes32 s
799     ) external returns (uint amountToken, uint amountETH);
800     function swapExactTokensForTokens(
801         uint amountIn,
802         uint amountOutMin,
803         address[] calldata path,
804         address to,
805         uint deadline
806     ) external returns (uint[] memory amounts);
807     function swapTokensForExactTokens(
808         uint amountOut,
809         uint amountInMax,
810         address[] calldata path,
811         address to,
812         uint deadline
813     ) external returns (uint[] memory amounts);
814     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
815     external
816     payable
817     returns (uint[] memory amounts);
818     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
819     external
820     returns (uint[] memory amounts);
821     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
822     external
823     returns (uint[] memory amounts);
824     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
825     external
826     payable
827     returns (uint[] memory amounts);
828  
829     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
830     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
831     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
832     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
833     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
834 }
835  
836 interface IUniswapV2Router02 is IUniswapV2Router01{
837     function removeLiquidityETHSupportingFeeOnTransferTokens(
838         address token,
839         uint liquidity,
840         uint amountTokenMin,
841         uint amountETHMin,
842         address to,
843         uint deadline
844     ) external returns (uint amountETH);
845     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
846         address token,
847         uint liquidity,
848         uint amountTokenMin,
849         uint amountETHMin,
850         address to,
851         uint deadline,
852         bool approveMax, uint8 v, bytes32 r, bytes32 s
853     ) external returns (uint amountETH);
854  
855     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
856         uint amountIn,
857         uint amountOutMin,
858         address[] calldata path,
859         address to,
860         uint deadline
861     ) external;
862     function swapExactETHForTokensSupportingFeeOnTransferTokens(
863         uint amountOutMin,
864         address[] calldata path,
865         address to,
866         uint deadline
867     ) external payable;
868     function swapExactTokensForETHSupportingFeeOnTransferTokens(
869         uint amountIn,
870         uint amountOutMin,
871         address[] calldata path,
872         address to,
873         uint deadline
874     ) external;
875 }
876  
877 interface IWETH {
878     function deposit() external payable;
879     function transfer(address to, uint value) external returns (bool);
880     function withdraw(uint) external;
881 }
882  
883  
884 interface IUniswapV2ERC20 {
885     event Approval(address indexed owner, address indexed spender, uint value);
886     event Transfer(address indexed from, address indexed to, uint value);
887  
888     function name() external pure returns (string memory);
889     function symbol() external pure returns (string memory);
890     function decimals() external pure returns (uint8);
891     function totalSupply() external view returns (uint);
892     function balanceOf(address owner) external view returns (uint);
893     function allowance(address owner, address spender) external view returns (uint);
894  
895     function approve(address spender, uint value) external returns (bool);
896     function transfer(address to, uint value) external returns (bool);
897     function transferFrom(address from, address to, uint value) external returns (bool);
898  
899     function DOMAIN_SEPARATOR() external view returns (bytes32);
900     function PERMIT_TYPEHASH() external pure returns (bytes32);
901     function nonces(address owner) external view returns (uint);
902  
903     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
904 }
905  
906  
907  
908  
909  
910  
911 pragma solidity ^0.8.15;
912  
913  
914  
915  
916 contract BAG is ERC20Burnable, Ownable {
917     uint256 private constant TOTAL_SUPPLY = 1_000_000_000e18;
918     address public marketingWallet;
919     uint256 public maxPercentToSwap = 5;
920     IUniswapV2Router02 public uniswapV2Router;
921     address public  uniswapV2Pair;
922  
923     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
924     address private constant ZERO = 0x0000000000000000000000000000000000000000;
925  
926     bool private swapping;
927     uint256 public swapTokensAtAmount;
928     bool public isTradingEnabled;
929  
930     mapping(address => bool) private _isExcludedFromFees;
931     mapping(address => bool) public automatedMarketMakerPairs;
932  
933     event ExcludeFromFees(address indexed account);
934     event FeesUpdated(uint256 sellFee, uint256 buyFee);
935     event MarketingWalletChanged(address marketingWallet);
936     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
937     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 bnbSend);
938     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
939  
940     uint256 public sellFee;
941     uint256 public buyFee;
942  
943  
944     bool public isBotProtectionDisabledPermanently;
945     uint256 public maxTxAmount;
946     uint256 public maxHolding;
947     mapping(address => bool) public isExempt;
948  
949     constructor (address router, address operator) ERC20("tehBag", "BAG")
950     {
951         _mint(owner(), TOTAL_SUPPLY);
952  
953         swapTokensAtAmount = TOTAL_SUPPLY / 1000;
954         maxHolding = TOTAL_SUPPLY / 100;
955         maxTxAmount = TOTAL_SUPPLY / 100;
956         marketingWallet = operator;
957         sellFee = 50;
958         buyFee = 4;
959  
960         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
961         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
962         .createPair(address(this), _uniswapV2Router.WETH());
963  
964         uniswapV2Router = _uniswapV2Router;
965         uniswapV2Pair = _uniswapV2Pair;
966  
967         _approve(address(this), address(uniswapV2Router), type(uint256).max);
968  
969         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
970  
971         _isExcludedFromFees[owner()] = true;
972         _isExcludedFromFees[DEAD] = true;
973         _isExcludedFromFees[address(this)] = true;
974         _isExcludedFromFees[address(uniswapV2Router)] = true;
975  
976  
977         isExempt[address(uniswapV2Router)] = true;
978         isExempt[owner()] = true;
979     }
980  
981     receive() external payable {
982     }
983  
984     function openTrade() public onlyOwner {
985         require(isTradingEnabled == false, "Trading is already open!");
986         isTradingEnabled = true;
987     }
988  
989     function claimStuckTokens(address token) external onlyOwner {
990         require(token != address(this), "Owner cannot claim native tokens");
991         if (token == address(0x0)) {
992             payable(msg.sender).transfer(address(this).balance);
993             return;
994         }
995         IERC20 ERC20token = IERC20(token);
996         uint256 balance = ERC20token.balanceOf(address(this));
997         ERC20token.transfer(msg.sender, balance);
998     }
999  
1000     function sendETH(address payable recipient, uint256 amount) internal {
1001  
1002         recipient.call{gas : 2300, value : amount}("");
1003     }
1004  
1005     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1006         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1007  
1008         _setAutomatedMarketMakerPair(pair, value);
1009     }
1010  
1011     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1012         require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
1013         automatedMarketMakerPairs[pair] = value;
1014  
1015         emit SetAutomatedMarketMakerPair(pair, value);
1016     }
1017  
1018     //=======FeeManagement=======//
1019     function excludeFromFees(address account) external onlyOwner {
1020         require(!_isExcludedFromFees[account], "Account is already the value of true");
1021         _isExcludedFromFees[account] = true;
1022  
1023         emit ExcludeFromFees(account);
1024     }
1025  
1026     function includeInFees(address account) external onlyOwner {
1027         require(_isExcludedFromFees[account], "Account already included");
1028         _isExcludedFromFees[account] = false;
1029     }
1030  
1031     function isExcludedFromFees(address account) public view returns (bool) {
1032         return _isExcludedFromFees[account];
1033     }
1034  
1035     function updateFees(uint256 _sellFee, uint256 _buyFee) external onlyOwner {
1036         require(_sellFee <= 15, "Fees must be less than 10%");
1037         require(_buyFee <= 15, "Fees must be less than 10%");
1038         sellFee = _sellFee;
1039         buyFee = _buyFee;
1040  
1041         emit FeesUpdated(sellFee, buyFee);
1042     }
1043  
1044     function changeMarketingWallet(address _marketingWallet) external onlyOwner {
1045         require(_marketingWallet != marketingWallet, "Marketing wallet is already that address");
1046         marketingWallet = _marketingWallet;
1047         emit MarketingWalletChanged(marketingWallet);
1048     }
1049  
1050     function _transfer(
1051         address from,
1052         address to,
1053         uint256 amount
1054     ) internal override {
1055         require(from != address(0), "ERC20: transfer from the zero address");
1056         require(to != address(0), "ERC20: transfer to the zero address");
1057  
1058         if (!swapping) {
1059             _check(from, to, amount);
1060         }
1061  
1062         uint _buyFee = buyFee;
1063         uint _sellFee = sellFee;
1064  
1065         if (!isExempt[from] && !isExempt[to]) {
1066             require(isTradingEnabled, "Trade is not open");
1067         }
1068  
1069         if (amount == 0) {
1070             return;
1071         }
1072  
1073         bool takeFee = !swapping;
1074  
1075         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1076             takeFee = false;
1077         }
1078  
1079         uint256 toSwap = balanceOf(address(this));
1080  
1081         bool canSwap = toSwap >= swapTokensAtAmount && toSwap > 0 && !automatedMarketMakerPairs[from] && takeFee;
1082         if (canSwap &&
1083             !swapping) {
1084             swapping = true;
1085             uint256 pairBalance = balanceOf(uniswapV2Pair);
1086             if (toSwap > pairBalance * maxPercentToSwap / 100) {
1087                 toSwap = pairBalance * maxPercentToSwap / 100;
1088             }
1089             swapAndSendMarketing(toSwap);
1090             swapping = false;
1091         }
1092  
1093         if (takeFee && to == uniswapV2Pair && _sellFee > 0) {
1094             uint256 fees = (amount * _sellFee) / 100;
1095             amount = amount - fees;
1096  
1097             super._transfer(from, address(this), fees);
1098         }
1099         else if (takeFee && from == uniswapV2Pair && _buyFee > 0) {
1100             uint256 fees = (amount * _buyFee) / 100;
1101             amount = amount - fees;
1102  
1103             super._transfer(from, address(this), fees);
1104         }
1105  
1106         super._transfer(from, to, amount);
1107     }
1108  
1109     //=======Swap=======//
1110     function swapAndSendMarketing(uint256 tokenAmount) private {
1111  
1112         address[] memory path = new address[](2);
1113         path[0] = address(this);
1114         path[1] = uniswapV2Router.WETH();
1115  
1116         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1117             tokenAmount,
1118             0, 
1119             path,
1120             address(this),
1121             block.timestamp) {}
1122         catch {
1123         }
1124  
1125         uint256 newBalance = address(this).balance;
1126         sendETH(payable(marketingWallet), newBalance);
1127  
1128         emit SwapAndSendMarketing(tokenAmount, newBalance);
1129     }
1130  
1131     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
1132         require(newAmount > 0);
1133         swapTokensAtAmount = newAmount;
1134     }
1135  
1136     function setMaxPercentToSwap(uint256 newAmount) external onlyOwner {
1137         require(newAmount > 1, "too low");
1138         require(newAmount <= 10, "too high");
1139         maxPercentToSwap = newAmount;
1140     }
1141  
1142     function _check(
1143         address from,
1144         address to,
1145         uint256 amount
1146     ) internal {
1147  
1148         if (!isBotProtectionDisabledPermanently) {
1149  
1150             if (!isSpecialAddresses(from, to) && !isExempt[to]) {
1151                 _checkMaxTxAmount(to, amount);
1152  
1153                 _checkMaxHoldingLimit(to, amount);
1154             }
1155         }
1156     }
1157  
1158     function _checkMaxTxAmount(address to, uint256 amount) internal view {
1159         require(amount <= maxTxAmount, "Amount exceeds max");
1160  
1161     }
1162  
1163     function _checkMaxHoldingLimit(address to, uint256 amount) internal view {
1164         if (to == uniswapV2Pair) {
1165             return;
1166         }
1167  
1168         require(balanceOf(to) + amount <= maxHolding, "Max holding exceeded max");
1169  
1170     }
1171  
1172     function isSpecialAddresses(address from, address to) view public returns (bool){
1173  
1174         return (from == owner() || to == owner() || from == address(this) || to == address(this));
1175     }
1176  
1177     function disableBotProtectionPermanently() external onlyOwner {
1178         isBotProtectionDisabledPermanently = true;
1179     }
1180  
1181     function setMaxTxAmount(uint256 maxTxAmount_) external onlyOwner {
1182         maxTxAmount = maxTxAmount_;
1183     }
1184  
1185     function setMaxHolding(uint256 maxHolding_) external onlyOwner {
1186         maxHolding = maxHolding_;
1187     }
1188  
1189     function setExempt(address who, bool status) public onlyOwner {
1190         isExempt[who] = status;
1191     }
1192 }