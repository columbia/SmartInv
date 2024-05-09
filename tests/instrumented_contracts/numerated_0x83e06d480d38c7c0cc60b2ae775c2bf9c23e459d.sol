1 // File: @openzeppelin\contracts\utils\Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin\contracts\access\Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
106 
107 
108 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
109 
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP.
114  */
115 interface IERC20 {
116     /**
117      * @dev Returns the amount of tokens in existence.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     /**
122      * @dev Returns the amount of tokens owned by `account`.
123      */
124     function balanceOf(address account) external view returns (uint256);
125 
126     /**
127      * @dev Moves `amount` tokens from the caller's account to `to`.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transfer(address to, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Returns the remaining number of tokens that `spender` will be
137      * allowed to spend on behalf of `owner` through {transferFrom}. This is
138      * zero by default.
139      *
140      * This value changes when {approve} or {transferFrom} are called.
141      */
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     /**
145      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * IMPORTANT: Beware that changing an allowance with this method brings the risk
150      * that someone may use both the old and the new allowance by unfortunate
151      * transaction ordering. One possible solution to mitigate this race
152      * condition is to first reduce the spender's allowance to 0 and set the
153      * desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Moves `amount` tokens from `from` to `to` using the
162      * allowance mechanism. `amount` is then deducted from the caller's
163      * allowance.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transferFrom(
170         address from,
171         address to,
172         uint256 amount
173     ) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to {approve}. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 // File: @openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
191 
192 
193 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Interface for the optional metadata functions from the ERC20 standard.
199  *
200  * _Available since v4.1._
201  */
202 interface IERC20Metadata is IERC20 {
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the symbol of the token.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the decimals places of the token.
215      */
216     function decimals() external view returns (uint8);
217 }
218 
219 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
220 
221 
222 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 
227 
228 /**
229  * @dev Implementation of the {IERC20} interface.
230  *
231  * This implementation is agnostic to the way tokens are created. This means
232  * that a supply mechanism has to be added in a derived contract using {_mint}.
233  * For a generic mechanism see {ERC20PresetMinterPauser}.
234  *
235  * TIP: For a detailed writeup see our guide
236  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
237  * to implement supply mechanisms].
238  *
239  * We have followed general OpenZeppelin Contracts guidelines: functions revert
240  * instead returning `false` on failure. This behavior is nonetheless
241  * conventional and does not conflict with the expectations of ERC20
242  * applications.
243  *
244  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
245  * This allows applications to reconstruct the allowance for all accounts just
246  * by listening to said events. Other implementations of the EIP may not emit
247  * these events, as it isn't required by the specification.
248  *
249  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
250  * functions have been added to mitigate the well-known issues around setting
251  * allowances. See {IERC20-approve}.
252  */
253 contract ERC20 is Context, IERC20, IERC20Metadata {
254     mapping(address => uint256) private _balances;
255 
256     mapping(address => mapping(address => uint256)) private _allowances;
257 
258     uint256 private _totalSupply;
259 
260     string private _name;
261     string private _symbol;
262 
263     /**
264      * @dev Sets the values for {name} and {symbol}.
265      *
266      * The default value of {decimals} is 18. To select a different value for
267      * {decimals} you should overload it.
268      *
269      * All two of these values are immutable: they can only be set once during
270      * construction.
271      */
272     constructor(string memory name_, string memory symbol_) {
273         _name = name_;
274         _symbol = symbol_;
275     }
276 
277     /**
278      * @dev Returns the name of the token.
279      */
280     function name() public view virtual override returns (string memory) {
281         return _name;
282     }
283 
284     /**
285      * @dev Returns the symbol of the token, usually a shorter version of the
286      * name.
287      */
288     function symbol() public view virtual override returns (string memory) {
289         return _symbol;
290     }
291 
292     /**
293      * @dev Returns the number of decimals used to get its user representation.
294      * For example, if `decimals` equals `2`, a balance of `505` tokens should
295      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
296      *
297      * Tokens usually opt for a value of 18, imitating the relationship between
298      * Ether and Wei. This is the value {ERC20} uses, unless this function is
299      * overridden;
300      *
301      * NOTE: This information is only used for _display_ purposes: it in
302      * no way affects any of the arithmetic of the contract, including
303      * {IERC20-balanceOf} and {IERC20-transfer}.
304      */
305     function decimals() public view virtual override returns (uint8) {
306         return 18;
307     }
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view virtual override returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view virtual override returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `to` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address to, uint256 amount) public virtual override returns (bool) {
332         address owner = _msgSender();
333         _transfer(owner, to, amount);
334         return true;
335     }
336 
337     /**
338      * @dev See {IERC20-allowance}.
339      */
340     function allowance(address owner, address spender) public view virtual override returns (uint256) {
341         return _allowances[owner][spender];
342     }
343 
344     /**
345      * @dev See {IERC20-approve}.
346      *
347      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
348      * `transferFrom`. This is semantically equivalent to an infinite approval.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public virtual override returns (bool) {
355         address owner = _msgSender();
356         _approve(owner, spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      *
363      * Emits an {Approval} event indicating the updated allowance. This is not
364      * required by the EIP. See the note at the beginning of {ERC20}.
365      *
366      * NOTE: Does not update the allowance if the current allowance
367      * is the maximum `uint256`.
368      *
369      * Requirements:
370      *
371      * - `from` and `to` cannot be the zero address.
372      * - `from` must have a balance of at least `amount`.
373      * - the caller must have allowance for ``from``'s tokens of at least
374      * `amount`.
375      */
376     function transferFrom(
377         address from,
378         address to,
379         uint256 amount
380     ) public virtual override returns (bool) {
381         address spender = _msgSender();
382         _spendAllowance(from, spender, amount);
383         _transfer(from, to, amount);
384         return true;
385     }
386 
387     /**
388      * @dev Atomically increases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to {approve} that can be used as a mitigation for
391      * problems described in {IERC20-approve}.
392      *
393      * Emits an {Approval} event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
400         address owner = _msgSender();
401         _approve(owner, spender, _allowances[owner][spender] + addedValue);
402         return true;
403     }
404 
405     /**
406      * @dev Atomically decreases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      * - `spender` must have allowance for the caller of at least
417      * `subtractedValue`.
418      */
419     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
420         address owner = _msgSender();
421         uint256 currentAllowance = _allowances[owner][spender];
422         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
423         unchecked {
424             _approve(owner, spender, currentAllowance - subtractedValue);
425         }
426 
427         return true;
428     }
429 
430     /**
431      * @dev Moves `amount` of tokens from `sender` to `recipient`.
432      *
433      * This internal function is equivalent to {transfer}, and can be used to
434      * e.g. implement automatic token fees, slashing mechanisms, etc.
435      *
436      * Emits a {Transfer} event.
437      *
438      * Requirements:
439      *
440      * - `from` cannot be the zero address.
441      * - `to` cannot be the zero address.
442      * - `from` must have a balance of at least `amount`.
443      */
444     function _transfer(
445         address from,
446         address to,
447         uint256 amount
448     ) internal virtual {
449         require(from != address(0), "ERC20: transfer from the zero address");
450         require(to != address(0), "ERC20: transfer to the zero address");
451 
452         _beforeTokenTransfer(from, to, amount);
453 
454         uint256 fromBalance = _balances[from];
455         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
456         unchecked {
457             _balances[from] = fromBalance - amount;
458         }
459         _balances[to] += amount;
460 
461         emit Transfer(from, to, amount);
462 
463         _afterTokenTransfer(from, to, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `account` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479 
480         _totalSupply += amount;
481         _balances[account] += amount;
482         emit Transfer(address(0), account, amount);
483 
484         _afterTokenTransfer(address(0), account, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, reducing the
489      * total supply.
490      *
491      * Emits a {Transfer} event with `to` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      * - `account` must have at least `amount` tokens.
497      */
498     function _burn(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: burn from the zero address");
500 
501         _beforeTokenTransfer(account, address(0), amount);
502 
503         uint256 accountBalance = _balances[account];
504         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
505         unchecked {
506             _balances[account] = accountBalance - amount;
507         }
508         _totalSupply -= amount;
509 
510         emit Transfer(account, address(0), amount);
511 
512         _afterTokenTransfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
517      *
518      * This internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(
529         address owner,
530         address spender,
531         uint256 amount
532     ) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
542      *
543      * Does not update the allowance amount in case of infinite allowance.
544      * Revert if not enough allowance is available.
545      *
546      * Might emit an {Approval} event.
547      */
548     function _spendAllowance(
549         address owner,
550         address spender,
551         uint256 amount
552     ) internal virtual {
553         uint256 currentAllowance = allowance(owner, spender);
554         if (currentAllowance != type(uint256).max) {
555             require(currentAllowance >= amount, "ERC20: insufficient allowance");
556             unchecked {
557                 _approve(owner, spender, currentAllowance - amount);
558             }
559         }
560     }
561 
562     /**
563      * @dev Hook that is called before any transfer of tokens. This includes
564      * minting and burning.
565      *
566      * Calling conditions:
567      *
568      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
569      * will be transferred to `to`.
570      * - when `from` is zero, `amount` tokens will be minted for `to`.
571      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
572      * - `from` and `to` are never both zero.
573      *
574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
575      */
576     function _beforeTokenTransfer(
577         address from,
578         address to,
579         uint256 amount
580     ) internal virtual {}
581 
582     /**
583      * @dev Hook that is called after any transfer of tokens. This includes
584      * minting and burning.
585      *
586      * Calling conditions:
587      *
588      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
589      * has been transferred to `to`.
590      * - when `from` is zero, `amount` tokens have been minted for `to`.
591      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
592      * - `from` and `to` are never both zero.
593      *
594      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
595      */
596     function _afterTokenTransfer(
597         address from,
598         address to,
599         uint256 amount
600     ) internal virtual {}
601 }
602 
603 // File: contracts\Skyward.sol
604 
605 // SPDX-License-Identifier: MIT
606 pragma solidity 0.8.13;
607 
608 /* ------------------------------------------ Imports ------------------------------------------ */
609 
610 
611 /* -------------------------------------- Dex Interfaces --------------------------------------- */
612 
613 interface IDexFactory {
614     function createPair(address tokenA, address tokenB) external returns (address pair);
615 }
616 
617 interface IDexRouter {
618     function factory() external pure returns (address);
619     function WETH() external pure returns (address);
620 
621     function addLiquidityETH(
622         address token,
623         uint amountTokenDesired,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline
628     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
629     
630     function swapExactTokensForETHSupportingFeeOnTransferTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external;
637 
638     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
639 }
640 
641 /* --------------------------------------- Main Contract --------------------------------------- */
642 
643 contract Skyward is ERC20, Ownable {
644 
645     /* ----------------------------------- State Variables ------------------------------------ */
646 
647     IDexRouter private immutable uniswapV2Router;
648     address private immutable uniswapV2Pair;
649     address[] private wethContractPath;
650     mapping (address => bool) private excludedFromFees;
651     mapping (address => uint256) public owedRewards;
652 
653     address public skyRewards;
654     address public skyTreasury;
655 
656     uint256 public maxWallet;
657     uint256 public baseFees;
658     uint256 public liquidityFee;
659     uint256 public treasuryFee;
660     uint256 private swapTokensAtAmount;
661     uint256 private tokensForLiquidity;
662     uint256 private tokensForTreasury;
663 
664     uint256 public bonusRewards;
665     uint256 public bonusRewardsMultiplier;
666     uint256 public rewardsFee;
667     uint256 public rewardsFeeMultiplier;
668 
669     uint256 public currentAth;
670     uint256 public currentPrice;
671     uint256 public resetAthTime;
672     uint256 public supportThreshold;
673 
674     event AthReset(uint256 newAth);
675     event UpdatedBaseFees(uint256 newAmount);
676     event UpdatedMaxWallet(uint256 newAmount);
677     event UpdatedMultipliers(uint256 newBonus, uint256 newRewards);
678     event UpdatedSkyRewardsAddress(address indexed newWallet);
679     event UpdatedSkyTreasuryAddress(address indexed newWallet);
680     event UpdatedSupportThreshold(uint256 newThreshold);
681 
682     /* --------------------------------- Contract Constructor --------------------------------- */
683 
684     constructor(address dexRouter) ERC20("Skyward", "SKY") {
685         uniswapV2Router = IDexRouter(dexRouter);
686         uniswapV2Pair = IDexFactory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
687 
688         uint256 totalSupply = 100000000 * 10**18;
689         swapTokensAtAmount = totalSupply * 1 / 4000;
690         maxWallet = totalSupply * 2 / 100;
691         treasuryFee = 9;
692         liquidityFee = 1;
693         baseFees = treasuryFee + liquidityFee;
694         supportThreshold = 10;
695         bonusRewardsMultiplier = 2;
696         rewardsFeeMultiplier = 2;
697 
698         excludeFromFees(msg.sender, true);
699         excludeFromFees(address(this), true);
700         excludeFromFees(address(0), true);
701 
702         wethContractPath = [uniswapV2Router.WETH(), address(this)];
703         
704         _mint(msg.sender, totalSupply);
705         transferOwnership(msg.sender);
706     }
707 
708     receive() external payable {}
709 
710     /* ------------------------------- Main Contract Functions -------------------------------- */
711 
712     // Transfer tokens
713     function _transfer(address from, address to, uint256 amount) internal override {
714         require(from != address(0), "ERC20: transfer from the zero address");
715         require(to != address(0), "ERC20: transfer to the zero address");
716         require(amount > 0, "Amount must be greater than 0");
717         
718         if (!excludedFromFees[from] && !excludedFromFees[to]) {
719             if (to != uniswapV2Pair) {
720                 require(amount + balanceOf(to) <= maxWallet, "Exceeds max wallet");
721             }
722 
723             checkPrice();
724 
725             if (from == uniswapV2Pair) {
726                 uint256 bonus = 0;
727                 bonus = amount * bonusRewards / 100 + owedRewards[to];
728                 if (bonus > 0) {
729                     if (bonus <= balanceOf(skyRewards)) {
730                         super._transfer(skyRewards, to, bonus);
731                         delete owedRewards[to];
732                     } else {
733                         owedRewards[to] += bonus;
734                     }
735                 }
736             } else if (to == uniswapV2Pair && baseFees > 0) {
737                 if (balanceOf(address(this)) >= swapTokensAtAmount) {
738                     swapBack();
739                 }
740 
741                 uint256 fees = 0;
742                 uint256 penaltyFees = 0;
743                 fees = amount * baseFees / 100;
744                 penaltyFees = amount * rewardsFee / 100;
745                 tokensForTreasury += fees * treasuryFee / baseFees;
746                 tokensForLiquidity += fees * liquidityFee / baseFees;
747                 if (fees > 0) {
748                     super._transfer(from, address(this), fees);
749                 }
750 
751                 if (penaltyFees > 0) {
752                     super._transfer(from, skyRewards, penaltyFees);
753                 }
754 
755                 if (owedRewards[from] > 0 && owedRewards[from] <= balanceOf(skyRewards)) {
756                     super._transfer(skyRewards, from, owedRewards[from]);
757                     delete owedRewards[from];
758                 }
759                 amount -= fees + penaltyFees;
760             }
761         }
762         super._transfer(from, to, amount);
763     }
764 
765     // Claim owed rewards (manual implementation)
766     function claimOwed() external {
767         require(owedRewards[msg.sender] > 0, "You have no owed rewards");
768         require(owedRewards[msg.sender] <= balanceOf(skyRewards), "Insufficient rewards in rewards pool");
769         super._transfer(skyRewards, msg.sender, owedRewards[msg.sender]);
770         delete owedRewards[msg.sender];
771     }
772 
773     /* ----------------------------------- Owner Functions ------------------------------------ */
774 
775     // Withdraw stuck ETH
776     function clearStuckBalance() external onlyOwner {
777         bool success;
778         (success,) = address(msg.sender).call{value: address(this).balance}("");
779     }
780 
781     // Exclude an address from transaction fees
782     function excludeFromFees(address account, bool excluded) public onlyOwner {
783         excludedFromFees[account] = excluded;
784     }
785 
786     // Set the current ATH to current price (manual implementation)
787     function resetAthManual() external onlyOwner {
788         currentPrice = getCurrentPrice();
789         require(currentPrice != 0, "Not a valid price");
790         resetAth(currentPrice);
791         emit AthReset(currentPrice);
792     }
793 
794     // Designate rewards address
795     function setSkyRewardsAddress(address _skyRewards) external onlyOwner {
796         require(_skyRewards != address(0), "_skyRewards address cannot be the zero address");
797         skyRewards = _skyRewards;
798         emit UpdatedSkyRewardsAddress(skyRewards);
799     }
800     
801     // Designate treasury address
802     function setSkyTreasuryAddress(address _skyTreasury) external onlyOwner {
803         require(_skyTreasury != address(0), "_skyTreasury address cannot be the zero address");
804         skyTreasury = payable(_skyTreasury);
805         emit UpdatedSkyTreasuryAddress(skyTreasury);
806     }
807 
808     // Withdraw non-native tokens
809     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
810         require(_token != address(0), "_token address cannot be the zero address");
811         require(_token != address(this), "Can't withdraw native tokens");
812         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
813         _sent = IERC20(_token).transfer(_to, _contractBalance);
814     }
815 
816     // Update fees
817     function updateFees(uint256 _treasuryFee, uint256 _liquidityFee) external onlyOwner {
818         require(_treasuryFee + _liquidityFee <= 10, "Must keep fees at 10% or less");
819         treasuryFee = _treasuryFee;
820         liquidityFee = _liquidityFee;
821         baseFees = treasuryFee + liquidityFee;
822         emit UpdatedBaseFees(baseFees);
823     }
824 
825     // Update max wallet
826     function updateMaxWallet(uint256 _maxWallet) external onlyOwner {
827         require(_maxWallet > 0, "Max wallet must be greater than 0%");
828         maxWallet = totalSupply() * _maxWallet / 100;
829         emit UpdatedMaxWallet(maxWallet);
830     }
831 
832     // Update bonus rewards and rewards fee multipliers
833     function updateMultipliers(uint256 _bonusRewardsMultiplier, uint256 _rewardsFeeMultiplier) external onlyOwner {
834         require(_bonusRewardsMultiplier > 0, "Bonus rewards multiplier cannot be 0");
835         require(_bonusRewardsMultiplier <= 5, "Bonus rewards multiplier greater than 5");
836         require(_rewardsFeeMultiplier <= 2, "Rewards fee multiplier greater than 2");
837         bonusRewardsMultiplier = _bonusRewardsMultiplier;
838         rewardsFeeMultiplier = _rewardsFeeMultiplier;
839         emit UpdatedMultipliers(bonusRewardsMultiplier, rewardsFeeMultiplier);
840     }
841 
842     // Update support threshold
843     function updateSupportThreshold(uint256 _supportThreshold) external onlyOwner {
844         require(_supportThreshold >= 5 , "Threshold lower than 5%");
845         require(_supportThreshold <= 20, "Threshold greater than 20%");
846         supportThreshold = _supportThreshold;
847         emit UpdatedSupportThreshold(supportThreshold);
848     }
849 
850     // Update token threshold for when the contract sells for liquidity and treasury
851     function updateSwapTokensAtAmount(uint256 _swapTokensAtAmount) external onlyOwner { 
852   	    require(_swapTokensAtAmount <= (totalSupply() * 1 / 1000) / 10**18, "Threshold higher than 0.1% total supply");
853   	    swapTokensAtAmount = _swapTokensAtAmount * 10**18;
854   	}
855 
856     /* ------------------------------- Private Helper Functions ------------------------------- */
857 
858     // Liquidity injection helper function
859     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
860         _approve(address(this), address(uniswapV2Router), tokenAmount);
861         uniswapV2Router.addLiquidityETH{value: ethAmount}(
862             address(this),
863             tokenAmount,
864             0,
865             0,
866             owner(),
867             block.timestamp
868         );
869     }
870 
871     // Check current price and modify bonus rewards & reward fees accordingly
872     function checkPrice() private {
873         currentPrice = getCurrentPrice();
874         require(currentPrice != 0, "Not a valid price");
875 
876         if (currentPrice <= currentAth || currentAth == 0) {
877             resetAth(currentPrice);
878         } else if (currentPrice > currentAth) {
879             if (resetAthTime == 0) {
880                 resetAthTime = block.timestamp + 7 * 1 days;
881             } else {
882                 if (block.timestamp >= resetAthTime) {
883                     resetAth(currentPrice);
884                 }
885             }
886 
887             uint256 priceDifference = (10000 - (10000 * currentAth / currentPrice));
888 
889             if (priceDifference / 100 >= supportThreshold) {
890                 bonusRewards = bonusRewardsMultiplier * supportThreshold;
891                 rewardsFee = rewardsFeeMultiplier * supportThreshold;
892             } else {
893                 if (priceDifference % 100 >= 50) {
894                     bonusRewards = bonusRewardsMultiplier * ((priceDifference / 100) + 1);
895                     rewardsFee = rewardsFeeMultiplier * ((priceDifference / 100) + 1);
896                 } else {
897                     bonusRewards = bonusRewardsMultiplier * ((priceDifference / 100));
898                     rewardsFee = rewardsFeeMultiplier * ((priceDifference / 100));
899                 }
900             }
901         }
902     }
903 
904     // Set the current ATH to current price
905     function resetAth(uint256 _currentPrice) private {
906         currentAth = _currentPrice;
907         resetAthTime = 0;
908         bonusRewards = 0;
909         rewardsFee = 0;
910     }
911 
912     // Contract sells for liquidity and treasury
913     function swapBack() private {
914         uint256 contractBalance = balanceOf(address(this));
915         uint256 totalTokensToSwap = tokensForTreasury + tokensForLiquidity;
916         
917         if (contractBalance == 0 || totalTokensToSwap == 0) {
918             return;
919         }
920 
921         if (contractBalance > swapTokensAtAmount * 10) {
922             contractBalance = swapTokensAtAmount * 10;
923         }
924 
925         bool success;
926         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
927         swapTokensForETH(contractBalance - liquidityTokens); 
928 
929         uint256 ethBalance = address(this).balance;
930         uint256 ethForTreasury = ethBalance * tokensForTreasury / (totalTokensToSwap - (tokensForLiquidity / 2));
931         uint256 ethForLiquidity = ethBalance - ethForTreasury;
932 
933         tokensForLiquidity = 0;
934         tokensForTreasury = 0;
935         
936         if (liquidityTokens > 0 && ethForLiquidity > 0) {
937             addLiquidity(liquidityTokens, ethForLiquidity);
938         }
939 
940         (success,) = address(skyTreasury).call{value: address(this).balance}("");
941     }
942 
943     // Swap native token for ETH
944     function swapTokensForETH(uint256 tokenAmount) private {
945         address[] memory path = new address[](2);
946         path[0] = address(this);
947         path[1] = uniswapV2Router.WETH();
948         _approve(address(this), address(uniswapV2Router), tokenAmount);
949         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
950             tokenAmount,
951             0,
952             path,
953             address(this),
954             block.timestamp
955         );
956     }
957 
958     /* -------------------------------- Public View Functions --------------------------------- */
959 
960     // Retrieve current exchange rate of native token for 1 WETH
961     function getCurrentPrice() public view returns (uint256) {
962         try uniswapV2Router.getAmountsOut(1 * 10**18, wethContractPath) returns (uint256[] memory amounts) {
963             return amounts[1];
964         } catch {
965             return 0;
966         }
967     }
968 }