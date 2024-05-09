1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         _checkOwner();
54         _;
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if the sender is not the owner.
66      */
67     function _checkOwner() internal view virtual {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 /**
104  * @dev Interface of the ERC20 standard as defined in the EIP.
105  */
106 interface IERC20 {
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 
121     /**
122      * @dev Returns the amount of tokens in existence.
123      */
124     function totalSupply() external view returns (uint256);
125 
126     /**
127      * @dev Returns the amount of tokens owned by `account`.
128      */
129     function balanceOf(address account) external view returns (uint256);
130 
131     /**
132      * @dev Moves `amount` tokens from the caller's account to `to`.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transfer(address to, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Returns the remaining number of tokens that `spender` will be
142      * allowed to spend on behalf of `owner` through {transferFrom}. This is
143      * zero by default.
144      *
145      * This value changes when {approve} or {transferFrom} are called.
146      */
147     function allowance(address owner, address spender) external view returns (uint256);
148 
149     /**
150      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * IMPORTANT: Beware that changing an allowance with this method brings the risk
155      * that someone may use both the old and the new allowance by unfortunate
156      * transaction ordering. One possible solution to mitigate this race
157      * condition is to first reduce the spender's allowance to 0 and set the
158      * desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address spender, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Moves `amount` tokens from `from` to `to` using the
167      * allowance mechanism. `amount` is then deducted from the caller's
168      * allowance.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transferFrom(
175         address from,
176         address to,
177         uint256 amount
178     ) external returns (bool);
179 }
180 
181 
182 /**
183  * @dev Interface for the optional metadata functions from the ERC20 standard.
184  *
185  * _Available since v4.1._
186  */
187 interface IERC20Metadata is IERC20 {
188     /**
189      * @dev Returns the name of the token.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the symbol of the token.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the decimals places of the token.
200      */
201     function decimals() external view returns (uint8);
202 }
203 
204 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
205 
206 
207 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 
212 
213 
214 /**
215  * @dev Implementation of the {IERC20} interface.
216  *
217  * This implementation is agnostic to the way tokens are created. This means
218  * that a supply mechanism has to be added in a derived contract using {_mint}.
219  * For a generic mechanism see {ERC20PresetMinterPauser}.
220  *
221  * TIP: For a detailed writeup see our guide
222  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
223  * to implement supply mechanisms].
224  *
225  * We have followed general OpenZeppelin Contracts guidelines: functions revert
226  * instead returning `false` on failure. This behavior is nonetheless
227  * conventional and does not conflict with the expectations of ERC20
228  * applications.
229  *
230  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
231  * This allows applications to reconstruct the allowance for all accounts just
232  * by listening to said events. Other implementations of the EIP may not emit
233  * these events, as it isn't required by the specification.
234  *
235  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
236  * functions have been added to mitigate the well-known issues around setting
237  * allowances. See {IERC20-approve}.
238  */
239 contract ERC20 is Context, IERC20, IERC20Metadata {
240     mapping(address => uint256) private _balances;
241 
242     mapping(address => mapping(address => uint256)) private _allowances;
243 
244     uint256 private _totalSupply;
245 
246     string private _name;
247     string private _symbol;
248 
249     /**
250      * @dev Sets the values for {name} and {symbol}.
251      *
252      * The default value of {decimals} is 18. To select a different value for
253      * {decimals} you should overload it.
254      *
255      * All two of these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor(string memory name_, string memory symbol_) {
259         _name = name_;
260         _symbol = symbol_;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view virtual override returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view virtual override returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei. This is the value {ERC20} uses, unless this function is
285      * overridden;
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view virtual override returns (uint8) {
292         return 18;
293     }
294 
295     /**
296      * @dev See {IERC20-totalSupply}.
297      */
298     function totalSupply() public view virtual override returns (uint256) {
299         return _totalSupply;
300     }
301 
302     /**
303      * @dev See {IERC20-balanceOf}.
304      */
305     function balanceOf(address account) public view virtual override returns (uint256) {
306         return _balances[account];
307     }
308 
309     /**
310      * @dev See {IERC20-transfer}.
311      *
312      * Requirements:
313      *
314      * - `to` cannot be the zero address.
315      * - the caller must have a balance of at least `amount`.
316      */
317     function transfer(address to, uint256 amount) public virtual override returns (bool) {
318         address owner = _msgSender();
319         _transfer(owner, to, amount);
320         return true;
321     }
322 
323     /**
324      * @dev See {IERC20-allowance}.
325      */
326     function allowance(address owner, address spender) public view virtual override returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     /**
331      * @dev See {IERC20-approve}.
332      *
333      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
334      * `transferFrom`. This is semantically equivalent to an infinite approval.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function approve(address spender, uint256 amount) public virtual override returns (bool) {
341         address owner = _msgSender();
342         _approve(owner, spender, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-transferFrom}.
348      *
349      * Emits an {Approval} event indicating the updated allowance. This is not
350      * required by the EIP. See the note at the beginning of {ERC20}.
351      *
352      * NOTE: Does not update the allowance if the current allowance
353      * is the maximum `uint256`.
354      *
355      * Requirements:
356      *
357      * - `from` and `to` cannot be the zero address.
358      * - `from` must have a balance of at least `amount`.
359      * - the caller must have allowance for ``from``'s tokens of at least
360      * `amount`.
361      */
362     function transferFrom(
363         address from,
364         address to,
365         uint256 amount
366     ) public virtual override returns (bool) {
367         address spender = _msgSender();
368         _spendAllowance(from, spender, amount);
369         _transfer(from, to, amount);
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
386         address owner = _msgSender();
387         _approve(owner, spender, allowance(owner, spender) + addedValue);
388         return true;
389     }
390 
391     /**
392      * @dev Atomically decreases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      * - `spender` must have allowance for the caller of at least
403      * `subtractedValue`.
404      */
405     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
406         address owner = _msgSender();
407         uint256 currentAllowance = allowance(owner, spender);
408         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
409         unchecked {
410             _approve(owner, spender, currentAllowance - subtractedValue);
411         }
412 
413         return true;
414     }
415 
416     /**
417      * @dev Moves `amount` of tokens from `from` to `to`.
418      *
419      * This internal function is equivalent to {transfer}, and can be used to
420      * e.g. implement automatic token fees, slashing mechanisms, etc.
421      *
422      * Emits a {Transfer} event.
423      *
424      * Requirements:
425      *
426      * - `from` cannot be the zero address.
427      * - `to` cannot be the zero address.
428      * - `from` must have a balance of at least `amount`.
429      */
430     function _transfer(
431         address from,
432         address to,
433         uint256 amount
434     ) internal virtual {
435         require(from != address(0), "ERC20: transfer from the zero address");
436         require(to != address(0), "ERC20: transfer to the zero address");
437 
438         _beforeTokenTransfer(from, to, amount);
439 
440         uint256 fromBalance = _balances[from];
441         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
442         unchecked {
443             _balances[from] = fromBalance - amount;
444             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
445             // decrementing then incrementing.
446             _balances[to] += amount;
447         }
448 
449         emit Transfer(from, to, amount);
450 
451         _afterTokenTransfer(from, to, amount);
452     }
453 
454     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
455      * the total supply.
456      *
457      * Emits a {Transfer} event with `from` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      */
463     function _mint(address account, uint256 amount) internal virtual {
464         require(account != address(0), "ERC20: mint to the zero address");
465 
466         _beforeTokenTransfer(address(0), account, amount);
467 
468         _totalSupply += amount;
469         unchecked {
470             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
471             _balances[account] += amount;
472         }
473         emit Transfer(address(0), account, amount);
474 
475         _afterTokenTransfer(address(0), account, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`, reducing the
480      * total supply.
481      *
482      * Emits a {Transfer} event with `to` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      * - `account` must have at least `amount` tokens.
488      */
489     function _burn(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: burn from the zero address");
491 
492         _beforeTokenTransfer(account, address(0), amount);
493 
494         uint256 accountBalance = _balances[account];
495         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
496         unchecked {
497             _balances[account] = accountBalance - amount;
498             // Overflow not possible: amount <= accountBalance <= totalSupply.
499             _totalSupply -= amount;
500         }
501 
502         emit Transfer(account, address(0), amount);
503 
504         _afterTokenTransfer(account, address(0), amount);
505     }
506 
507     /**
508      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
509      *
510      * This internal function is equivalent to `approve`, and can be used to
511      * e.g. set automatic allowances for certain subsystems, etc.
512      *
513      * Emits an {Approval} event.
514      *
515      * Requirements:
516      *
517      * - `owner` cannot be the zero address.
518      * - `spender` cannot be the zero address.
519      */
520     function _approve(
521         address owner,
522         address spender,
523         uint256 amount
524     ) internal virtual {
525         require(owner != address(0), "ERC20: approve from the zero address");
526         require(spender != address(0), "ERC20: approve to the zero address");
527 
528         _allowances[owner][spender] = amount;
529         emit Approval(owner, spender, amount);
530     }
531 
532     /**
533      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
534      *
535      * Does not update the allowance amount in case of infinite allowance.
536      * Revert if not enough allowance is available.
537      *
538      * Might emit an {Approval} event.
539      */
540     function _spendAllowance(
541         address owner,
542         address spender,
543         uint256 amount
544     ) internal virtual {
545         uint256 currentAllowance = allowance(owner, spender);
546         if (currentAllowance != type(uint256).max) {
547             require(currentAllowance >= amount, "ERC20: insufficient allowance");
548             unchecked {
549                 _approve(owner, spender, currentAllowance - amount);
550             }
551         }
552     }
553 
554     /**
555      * @dev Hook that is called before any transfer of tokens. This includes
556      * minting and burning.
557      *
558      * Calling conditions:
559      *
560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
561      * will be transferred to `to`.
562      * - when `from` is zero, `amount` tokens will be minted for `to`.
563      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
564      * - `from` and `to` are never both zero.
565      *
566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
567      */
568     function _beforeTokenTransfer(
569         address from,
570         address to,
571         uint256 amount
572     ) internal virtual {}
573 
574     /**
575      * @dev Hook that is called after any transfer of tokens. This includes
576      * minting and burning.
577      *
578      * Calling conditions:
579      *
580      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
581      * has been transferred to `to`.
582      * - when `from` is zero, `amount` tokens have been minted for `to`.
583      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
584      * - `from` and `to` are never both zero.
585      *
586      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
587      */
588     function _afterTokenTransfer(
589         address from,
590         address to,
591         uint256 amount
592     ) internal virtual {}
593 }
594 
595 
596 
597 /**
598  * @dev Extension of {ERC20} that allows token holders to destroy both their own
599  * tokens and those that they have an allowance for, in a way that can be
600  * recognized off-chain (via event analysis).
601  */
602 abstract contract ERC20Burnable is Context, ERC20 {
603     /**
604      * @dev Destroys `amount` tokens from the caller.
605      *
606      * See {ERC20-_burn}.
607      */
608     function burn(uint256 amount) public virtual {
609         _burn(_msgSender(), amount);
610     }
611 
612     /**
613      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
614      * allowance.
615      *
616      * See {ERC20-_burn} and {ERC20-allowance}.
617      *
618      * Requirements:
619      *
620      * - the caller must have allowance for ``accounts``'s tokens of at least
621      * `amount`.
622      */
623     function burnFrom(address account, uint256 amount) public virtual {
624         _spendAllowance(account, _msgSender(), amount);
625         _burn(account, amount);
626     }
627 }
628 
629 
630 
631 interface IRouter {
632     function factory() external pure returns (address);
633 
634     function WETH() external pure returns (address);
635 
636     function addLiquidityETH(
637         address token,
638         uint256 amountTokenDesired,
639         uint256 amountTokenMin,
640         uint256 amountETHMin,
641         address to,
642         uint256 deadline
643     )
644         external
645         payable
646         returns (
647             uint256 amountToken,
648             uint256 amountETH,
649             uint256 liquidity
650         );
651 
652     function swapExactTokensForETHSupportingFeeOnTransferTokens(
653         uint256 amountIn,
654         uint256 amountOutMin,
655         address[] calldata path,
656         address to,
657         uint256 deadline
658     ) external;
659 }
660 
661 interface IFactory {
662     function createPair(address tokenA, address tokenB) external returns (address pair);
663 }
664 
665 
666 
667 contract LOL is ERC20, ERC20Burnable, Ownable {
668     uint256 private constant INITIAL_SUPPLY = 10000000000 * 10**18;
669 
670     IRouter public router;
671     address public uniswapV2Pair;
672     bool public limited;
673     uint256 public maxHoldingAmount;
674     uint256 public minHoldingAmount;
675     mapping(address => bool) public excludeLimitedList;
676 
677 
678     constructor() ERC20("LOL", "LOL") {
679         _mint(msg.sender, INITIAL_SUPPLY);
680         
681         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
682         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
683         router = _router;
684         uniswapV2Pair = _pair;
685         limited = true;
686         maxHoldingAmount = 200000000 * 10**18;
687         minHoldingAmount = 0;
688         excludeLimitedList[owner()] = true;
689         excludeLimitedList[uniswapV2Pair] = true;
690     }
691 
692     function setRule(bool _limited, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
693         limited = _limited;
694         maxHoldingAmount = _maxHoldingAmount;
695         minHoldingAmount = _minHoldingAmount;
696     }
697 
698     function setExcludeLimited(address account) public onlyOwner {
699         require(account != owner() && account != address(this), "account wrong");
700         require(account != address(0), "account wrong");
701         excludeLimitedList[account] = true;
702     }
703 
704     function setExcludeLimitedList(address[] calldata account) public onlyOwner {
705         require(account.length < 801, "GAS Error: max airdrop limit is 801 addresses");
706         for (uint256 i = 0; i < account.length; i++) {
707             excludeLimitedList[account[i]] = true;
708         }
709     }
710 
711     function _beforeTokenTransfer(
712         address from,
713         address to,
714         uint256 amount
715     ) override internal virtual {
716         if (uniswapV2Pair == address(0)) {
717             require(from == owner() || to == owner(), "trading is not started");
718             return;
719         }
720 
721         if (limited && from == uniswapV2Pair && !excludeLimitedList[to]) {
722             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
723         }
724     }
725 
726 
727     function distributeTokens(address distributionWallet) external onlyOwner {
728         uint256 supply = balanceOf(msg.sender);
729         require(supply == INITIAL_SUPPLY, "Tokens already distributed");
730 
731         _transfer(msg.sender, distributionWallet, supply);
732     }
733 
734     function multiTransfer(address[] calldata addresses, uint256[] calldata amounts) public {
735         require(addresses.length < 801, "GAS Error: max airdrop limit is 500 addresses");
736         require(addresses.length == amounts.length, "Mismatch between Address and token count");
737 
738         uint256 sum = 0;
739         for (uint256 i = 0; i < addresses.length; i++) {
740             sum = sum + amounts[i];
741         }
742 
743         require(balanceOf(msg.sender) >= sum, "Not enough amount in wallet");
744         for (uint256 i = 0; i < addresses.length; i++) {
745             _transfer(msg.sender, addresses[i], amounts[i]);
746         }
747     }
748 
749     function multiTransfer_fixed(address[] calldata addresses, uint256 amount) public {
750         require(addresses.length < 2001, "GAS Error: max airdrop limit is 2000 addresses");
751 
752         uint256 sum = amount * addresses.length;
753         require(balanceOf(msg.sender) >= sum, "Not enough amount in wallet");
754 
755         for (uint256 i = 0; i < addresses.length; i++) {
756             _transfer(msg.sender, addresses[i], amount);
757         }
758     }
759 }