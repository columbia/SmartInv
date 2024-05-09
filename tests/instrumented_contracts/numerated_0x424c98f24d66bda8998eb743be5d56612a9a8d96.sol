1 // Get your cash back
2 // Cashback is here to save the day 888
3 // https://twitter.com/cashback_coin
4 // https://t.me/cashback_coin
5 
6 // File: @openzeppelin/contracts/utils/Context.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/access/Ownable.sol
34 
35 
36 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 
41 /**
42  * @dev Contract module which provides a basic access control mechanism, where
43  * there is an account (an owner) that can be granted exclusive access to
44  * specific functions.
45  *
46  * By default, the owner account will be the one that deploys the contract. This
47  * can later be changed with {transferOwnership}.
48  *
49  * This module is used through inheritance. It will make available the modifier
50  * `onlyOwner`, which can be applied to your functions to restrict their use to
51  * the owner.
52  */
53 abstract contract Ownable is Context {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev Initializes the contract setting the deployer as the initial owner.
60      */
61     constructor() {
62         _transferOwnership(_msgSender());
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         _checkOwner();
70         _;
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if the sender is not the owner.
82      */
83     function _checkOwner() internal view virtual {
84         require(owner() == _msgSender(), "Ownable: caller is not the owner");
85     }
86 
87     /**
88      * @dev Leaves the contract without owner. It will not be possible to call
89      * `onlyOwner` functions anymore. Can only be called by the current owner.
90      *
91      * NOTE: Renouncing ownership will leave the contract without an owner,
92      * thereby removing any functionality that is only available to the owner.
93      */
94     function renounceOwnership() public virtual onlyOwner {
95         _transferOwnership(address(0));
96     }
97 
98     /**
99      * @dev Transfers ownership of the contract to a new account (`newOwner`).
100      * Can only be called by the current owner.
101      */
102     function transferOwnership(address newOwner) public virtual onlyOwner {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         _transferOwnership(newOwner);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Internal function without access restriction.
110      */
111     function _transferOwnership(address newOwner) internal virtual {
112         address oldOwner = _owner;
113         _owner = newOwner;
114         emit OwnershipTransferred(oldOwner, newOwner);
115     }
116 }
117 
118 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
119 
120 
121 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Interface of the ERC20 standard as defined in the EIP.
127  */
128 interface IERC20 {
129     /**
130      * @dev Emitted when `value` tokens are moved from one account (`from`) to
131      * another (`to`).
132      *
133      * Note that `value` may be zero.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 value);
136 
137     /**
138      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
139      * a call to {approve}. `value` is the new allowance.
140      */
141     event Approval(address indexed owner, address indexed spender, uint256 value);
142 
143     /**
144      * @dev Returns the amount of tokens in existence.
145      */
146     function totalSupply() external view returns (uint256);
147 
148     /**
149      * @dev Returns the amount of tokens owned by `account`.
150      */
151     function balanceOf(address account) external view returns (uint256);
152 
153     /**
154      * @dev Moves `amount` tokens from the caller's account to `to`.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transfer(address to, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Returns the remaining number of tokens that `spender` will be
164      * allowed to spend on behalf of `owner` through {transferFrom}. This is
165      * zero by default.
166      *
167      * This value changes when {approve} or {transferFrom} are called.
168      */
169     function allowance(address owner, address spender) external view returns (uint256);
170 
171     /**
172      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * IMPORTANT: Beware that changing an allowance with this method brings the risk
177      * that someone may use both the old and the new allowance by unfortunate
178      * transaction ordering. One possible solution to mitigate this race
179      * condition is to first reduce the spender's allowance to 0 and set the
180      * desired value afterwards:
181      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182      *
183      * Emits an {Approval} event.
184      */
185     function approve(address spender, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Moves `amount` tokens from `from` to `to` using the
189      * allowance mechanism. `amount` is then deducted from the caller's
190      * allowance.
191      *
192      * Returns a boolean value indicating whether the operation succeeded.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 amount
200     ) external returns (bool);
201 }
202 
203 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
204 
205 
206 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 
211 /**
212  * @dev Interface for the optional metadata functions from the ERC20 standard.
213  *
214  * _Available since v4.1._
215  */
216 interface IERC20Metadata is IERC20 {
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the symbol of the token.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the decimals places of the token.
229      */
230     function decimals() external view returns (uint8);
231 }
232 
233 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 
241 
242 
243 /**
244  * @dev Implementation of the {IERC20} interface.
245  *
246  * This implementation is agnostic to the way tokens are created. This means
247  * that a supply mechanism has to be added in a derived contract using {_mint}.
248  * For a generic mechanism see {ERC20PresetMinterPauser}.
249  *
250  * TIP: For a detailed writeup see our guide
251  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
252  * to implement supply mechanisms].
253  *
254  * We have followed general OpenZeppelin Contracts guidelines: functions revert
255  * instead returning `false` on failure. This behavior is nonetheless
256  * conventional and does not conflict with the expectations of ERC20
257  * applications.
258  *
259  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
260  * This allows applications to reconstruct the allowance for all accounts just
261  * by listening to said events. Other implementations of the EIP may not emit
262  * these events, as it isn't required by the specification.
263  *
264  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
265  * functions have been added to mitigate the well-known issues around setting
266  * allowances. See {IERC20-approve}.
267  */
268 contract ERC20 is Context, IERC20, IERC20Metadata {
269     mapping(address => uint256) private _balances;
270 
271     mapping(address => mapping(address => uint256)) private _allowances;
272 
273     uint256 private _totalSupply;
274 
275     string private _name;
276     string private _symbol;
277 
278     /**
279      * @dev Sets the values for {name} and {symbol}.
280      *
281      * The default value of {decimals} is 18. To select a different value for
282      * {decimals} you should overload it.
283      *
284      * All two of these values are immutable: they can only be set once during
285      * construction.
286      */
287     constructor(string memory name_, string memory symbol_) {
288         _name = name_;
289         _symbol = symbol_;
290     }
291 
292     /**
293      * @dev Returns the name of the token.
294      */
295     function name() public view virtual override returns (string memory) {
296         return _name;
297     }
298 
299     /**
300      * @dev Returns the symbol of the token, usually a shorter version of the
301      * name.
302      */
303     function symbol() public view virtual override returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @dev Returns the number of decimals used to get its user representation.
309      * For example, if `decimals` equals `2`, a balance of `505` tokens should
310      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
311      *
312      * Tokens usually opt for a value of 18, imitating the relationship between
313      * Ether and Wei. This is the value {ERC20} uses, unless this function is
314      * overridden;
315      *
316      * NOTE: This information is only used for _display_ purposes: it in
317      * no way affects any of the arithmetic of the contract, including
318      * {IERC20-balanceOf} and {IERC20-transfer}.
319      */
320     function decimals() public view virtual override returns (uint8) {
321         return 18;
322     }
323 
324     /**
325      * @dev See {IERC20-totalSupply}.
326      */
327     function totalSupply() public view virtual override returns (uint256) {
328         return _totalSupply;
329     }
330 
331     /**
332      * @dev See {IERC20-balanceOf}.
333      */
334     function balanceOf(address account) public view virtual override returns (uint256) {
335         return _balances[account];
336     }
337 
338     /**
339      * @dev See {IERC20-transfer}.
340      *
341      * Requirements:
342      *
343      * - `to` cannot be the zero address.
344      * - the caller must have a balance of at least `amount`.
345      */
346     function transfer(address to, uint256 amount) public virtual override returns (bool) {
347         address owner = _msgSender();
348         _transfer(owner, to, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See {IERC20-allowance}.
354      */
355     function allowance(address owner, address spender) public view virtual override returns (uint256) {
356         return _allowances[owner][spender];
357     }
358 
359     /**
360      * @dev See {IERC20-approve}.
361      *
362      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
363      * `transferFrom`. This is semantically equivalent to an infinite approval.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 amount) public virtual override returns (bool) {
370         address owner = _msgSender();
371         _approve(owner, spender, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-transferFrom}.
377      *
378      * Emits an {Approval} event indicating the updated allowance. This is not
379      * required by the EIP. See the note at the beginning of {ERC20}.
380      *
381      * NOTE: Does not update the allowance if the current allowance
382      * is the maximum `uint256`.
383      *
384      * Requirements:
385      *
386      * - `from` and `to` cannot be the zero address.
387      * - `from` must have a balance of at least `amount`.
388      * - the caller must have allowance for ``from``'s tokens of at least
389      * `amount`.
390      */
391     function transferFrom(
392         address from,
393         address to,
394         uint256 amount
395     ) public virtual override returns (bool) {
396         address spender = _msgSender();
397         _spendAllowance(from, spender, amount);
398         _transfer(from, to, amount);
399         return true;
400     }
401 
402     /**
403      * @dev Atomically increases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {IERC20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      */
414     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
415         address owner = _msgSender();
416         _approve(owner, spender, allowance(owner, spender) + addedValue);
417         return true;
418     }
419 
420     /**
421      * @dev Atomically decreases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      * - `spender` must have allowance for the caller of at least
432      * `subtractedValue`.
433      */
434     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
435         address owner = _msgSender();
436         uint256 currentAllowance = allowance(owner, spender);
437         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
438         unchecked {
439             _approve(owner, spender, currentAllowance - subtractedValue);
440         }
441 
442         return true;
443     }
444 
445     /**
446      * @dev Moves `amount` of tokens from `from` to `to`.
447      *
448      * This internal function is equivalent to {transfer}, and can be used to
449      * e.g. implement automatic token fees, slashing mechanisms, etc.
450      *
451      * Emits a {Transfer} event.
452      *
453      * Requirements:
454      *
455      * - `from` cannot be the zero address.
456      * - `to` cannot be the zero address.
457      * - `from` must have a balance of at least `amount`.
458      */
459     function _transfer(
460         address from,
461         address to,
462         uint256 amount
463     ) internal virtual {
464         require(from != address(0), "ERC20: transfer from the zero address");
465         require(to != address(0), "ERC20: transfer to the zero address");
466 
467         _beforeTokenTransfer(from, to, amount);
468 
469         uint256 fromBalance = _balances[from];
470         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
471         unchecked {
472             _balances[from] = fromBalance - amount;
473             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
474             // decrementing then incrementing.
475             _balances[to] += amount;
476         }
477 
478         emit Transfer(from, to, amount);
479 
480         _afterTokenTransfer(from, to, amount);
481     }
482 
483     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
484      * the total supply.
485      *
486      * Emits a {Transfer} event with `from` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      */
492     function _mint(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: mint to the zero address");
494 
495         _beforeTokenTransfer(address(0), account, amount);
496 
497         _totalSupply += amount;
498         unchecked {
499             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
500             _balances[account] += amount;
501         }
502         emit Transfer(address(0), account, amount);
503 
504         _afterTokenTransfer(address(0), account, amount);
505     }
506 
507     /**
508      * @dev Destroys `amount` tokens from `account`, reducing the
509      * total supply.
510      *
511      * Emits a {Transfer} event with `to` set to the zero address.
512      *
513      * Requirements:
514      *
515      * - `account` cannot be the zero address.
516      * - `account` must have at least `amount` tokens.
517      */
518     function _burn(address account, uint256 amount) internal virtual {
519         require(account != address(0), "ERC20: burn from the zero address");
520 
521         _beforeTokenTransfer(account, address(0), amount);
522 
523         uint256 accountBalance = _balances[account];
524         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
525         unchecked {
526             _balances[account] = accountBalance - amount;
527             // Overflow not possible: amount <= accountBalance <= totalSupply.
528             _totalSupply -= amount;
529         }
530 
531         emit Transfer(account, address(0), amount);
532 
533         _afterTokenTransfer(account, address(0), amount);
534     }
535 
536     /**
537      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
538      *
539      * This internal function is equivalent to `approve`, and can be used to
540      * e.g. set automatic allowances for certain subsystems, etc.
541      *
542      * Emits an {Approval} event.
543      *
544      * Requirements:
545      *
546      * - `owner` cannot be the zero address.
547      * - `spender` cannot be the zero address.
548      */
549     function _approve(
550         address owner,
551         address spender,
552         uint256 amount
553     ) internal virtual {
554         require(owner != address(0), "ERC20: approve from the zero address");
555         require(spender != address(0), "ERC20: approve to the zero address");
556 
557         _allowances[owner][spender] = amount;
558         emit Approval(owner, spender, amount);
559     }
560 
561     /**
562      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
563      *
564      * Does not update the allowance amount in case of infinite allowance.
565      * Revert if not enough allowance is available.
566      *
567      * Might emit an {Approval} event.
568      */
569     function _spendAllowance(
570         address owner,
571         address spender,
572         uint256 amount
573     ) internal virtual {
574         uint256 currentAllowance = allowance(owner, spender);
575         if (currentAllowance != type(uint256).max) {
576             require(currentAllowance >= amount, "ERC20: insufficient allowance");
577             unchecked {
578                 _approve(owner, spender, currentAllowance - amount);
579             }
580         }
581     }
582 
583     /**
584      * @dev Hook that is called before any transfer of tokens. This includes
585      * minting and burning.
586      *
587      * Calling conditions:
588      *
589      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
590      * will be transferred to `to`.
591      * - when `from` is zero, `amount` tokens will be minted for `to`.
592      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
593      * - `from` and `to` are never both zero.
594      *
595      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
596      */
597     function _beforeTokenTransfer(
598         address from,
599         address to,
600         uint256 amount
601     ) internal virtual {}
602 
603     /**
604      * @dev Hook that is called after any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * has been transferred to `to`.
611      * - when `from` is zero, `amount` tokens have been minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _afterTokenTransfer(
618         address from,
619         address to,
620         uint256 amount
621     ) internal virtual {}
622 }
623 
624 // File: contracts/Cash.sol
625 
626 
627 pragma solidity ^0.8.20;
628 
629 
630 
631 interface IUniswapV2Factory {
632     function createPair(address tokenA, address tokenB) external returns (address pair);
633 }
634 
635 interface IUniswapV2Router01 {
636     function factory() external pure returns (address);
637     function WETH() external pure returns (address);
638 }
639 
640 error MaxWalletLimitReached(uint256 balance);
641 error LaunchBuyLimitReached(uint256 out);
642 
643 contract Cashback is Ownable, ERC20 {
644     uint256 constant TOTAL_SUPPLY = 800000000000 ether;
645     uint256 constant LAUNCH_MAX_BUY = TOTAL_SUPPLY * 1 / 500;
646     uint256 constant LAUNCH_MAX_BUY_DELAY = 15 minutes;
647     uint256 constant LAUNCH_MAX_WALLET_LIMIT = TOTAL_SUPPLY * 1 / 125;
648     uint256 constant LAUNCH_MAX_HOLD_DELAY = 30 minutes;
649 
650     uint256 private _purchaseLimitTs;
651     uint256 private _maxHeldLimitTs;
652     address private _pair;
653     address private _team;
654     address private _marketingCEX;
655     bool private _skipChecks;
656 
657 	constructor() ERC20("Cashback", "$CASH") {
658 		_mint(msg.sender, TOTAL_SUPPLY);
659 
660         _pair = IUniswapV2Factory(
661             0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
662         ).createPair(
663             address(this), 
664             0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6
665         );
666 	}
667 
668     function setLaunch() external onlyOwner {
669         _purchaseLimitTs = block.timestamp + LAUNCH_MAX_BUY_DELAY;
670         _maxHeldLimitTs = block.timestamp + LAUNCH_MAX_HOLD_DELAY;
671     }
672 
673     function _transfer(address from, address to, uint256 amount) internal virtual override {
674         if(!_skipChecks && from == _pair) {
675             uint256 ts = block.timestamp;
676 
677             if(_maxHeldLimitTs > ts && balanceOf(to) + amount > LAUNCH_MAX_WALLET_LIMIT)
678                 revert MaxWalletLimitReached(balanceOf(to));
679 
680             if(_purchaseLimitTs > ts) {
681                 if(amount >= LAUNCH_MAX_BUY)
682                     revert LaunchBuyLimitReached(amount);
683             }
684 
685             if(_maxHeldLimitTs > ts && _purchaseLimitTs > ts)
686                 _skipChecks = true;
687         }
688 
689         super._transfer(from, to, amount);
690     }
691 }