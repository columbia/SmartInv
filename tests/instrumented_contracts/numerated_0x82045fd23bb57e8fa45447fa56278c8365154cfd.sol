1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
3 
4 pragma solidity ^0.8.0;
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
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(
40         address owner,
41         address spender
42     ) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(
88         address indexed owner,
89         address indexed spender,
90         uint256 value
91     );
92 }
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125 
126 contract ERC20 is Context, IERC20, IERC20Metadata {
127     mapping(address => uint256) private _balances;
128 
129     mapping(address => mapping(address => uint256)) private _allowances;
130 
131     uint256 private _totalSupply;
132 
133     string private _name;
134     string private _symbol;
135     uint8 private _decimals;
136 
137     /**
138      * @dev Sets the values for {name} and {symbol}.
139      *
140      * The default value of {decimals} is 18. To select a different value for
141      * {decimals} you should overload it.
142      *
143      * All two of these values are immutable: they can only be set once during
144      * construction.
145      */
146     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
147         _name = name_;
148         _symbol = symbol_;
149         _decimals = decimals_;
150     }
151 
152     /**
153      * @dev Returns the name of the token.
154      */
155     function name() public view virtual override returns (string memory) {
156         return _name;
157     }
158 
159     /**
160      * @dev Returns the symbol of the token, usually a shorter version of the
161      * name.
162      */
163     function symbol() public view virtual override returns (string memory) {
164         return _symbol;
165     }
166 
167     /**
168      * @dev Returns the number of decimals used to get its user representation.
169      * For example, if `decimals` equals `2`, a balance of `505` tokens should
170      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
171      *
172      * Tokens usually opt for a value of 18, imitating the relationship between
173      * Ether and Wei. This is the value {ERC20} uses, unless this function is
174      * overridden;
175      *
176      * NOTE: This information is only used for _display_ purposes: it in
177      * no way affects any of the arithmetic of the contract, including
178      * {IERC20-balanceOf} and {IERC20-transfer}.
179      */
180     function decimals() public view virtual override returns (uint8) {
181         return _decimals;
182     }
183 
184     function _decimal(uint8 decimal_) internal virtual {
185         _decimals = decimal_;
186     }
187 
188     /**
189      * @dev See {IERC20-totalSupply}.
190      */
191     function totalSupply() public view virtual override returns (uint256) {
192         return _totalSupply;
193     }
194 
195     /**
196      * @dev See {IERC20-balanceOf}.
197      */
198     function balanceOf(
199         address account
200     ) public view virtual override returns (uint256) {
201         return _balances[account];
202     }
203 
204     /**
205      * @dev See {IERC20-transfer}.
206      *
207      * Requirements:
208      *
209      * - `recipient` cannot be the zero address.
210      * - the caller must have a balance of at least `amount`.
211      */
212     function transfer(
213         address recipient,
214         uint256 amount
215     ) public virtual override returns (bool) {
216         _transfer(_msgSender(), recipient, amount);
217         return true;
218     }
219 
220     /**
221      * @dev See {IERC20-allowance}.
222      */
223     function allowance(
224         address owner,
225         address spender
226     ) public view virtual override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     /**
231      * @dev See {IERC20-approve}.
232      *
233      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
234      * `transferFrom`. This is semantically equivalent to an infinite approval.
235      *
236      * Requirements:
237      *
238      * - `spender` cannot be the zero address.
239      */
240     function approve(
241         address spender,
242         uint256 amount
243     ) public virtual override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-transferFrom}.
250      *
251      * Emits an {Approval} event indicating the updated allowance. This is not
252      * required by the EIP. See the note at the beginning of {ERC20}.
253      *
254      * NOTE: Does not update the allowance if the current allowance
255      * is the maximum `uint256`.
256      *
257      * Requirements:
258      *
259      * - `sender` and `recipient` cannot be the zero address.
260      * - `sender` must have a balance of at least `amount`.
261      * - the caller must have allowance for ``sender``'s tokens of at least
262      * `amount`.
263      */
264     function transferFrom(
265         address sender,
266         address recipient,
267         uint256 amount
268     ) public virtual override returns (bool) {
269         uint256 currentAllowance = _allowances[sender][_msgSender()];
270         if (currentAllowance != type(uint256).max) {
271             require(
272                 currentAllowance >= amount,
273                 "ERC20: transfer amount exceeds allowance"
274             );
275             unchecked {
276                 _approve(sender, _msgSender(), currentAllowance - amount);
277             }
278         }
279 
280         _transfer(sender, recipient, amount);
281 
282         return true;
283     }
284 
285     /**
286      * @dev Atomically increases the allowance granted to `spender` by the caller.
287      *
288      * This is an alternative to {approve} that can be used as a mitigation for
289      * problems described in {IERC20-approve}.
290      *
291      * Emits an {Approval} event indicating the updated allowance.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      */
297     function increaseAllowance(
298         address spender,
299         uint256 addedValue
300     ) public virtual returns (bool) {
301         _approve(
302             _msgSender(),
303             spender,
304             _allowances[_msgSender()][spender] + addedValue
305         );
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(
324         address spender,
325         uint256 subtractedValue
326     ) public virtual returns (bool) {
327         uint256 currentAllowance = _allowances[_msgSender()][spender];
328         require(
329             currentAllowance >= subtractedValue,
330             "ERC20: decreased allowance below zero"
331         );
332         unchecked {
333             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
334         }
335 
336         return true;
337     }
338 
339     /**
340      * @dev Moves `amount` of tokens from `sender` to `recipient`.
341      *
342      * This internal function is equivalent to {transfer}, and can be used to
343      * e.g. implement automatic token fees, slashing mechanisms, etc.
344      *
345      * Emits a {Transfer} event.
346      *
347      * Requirements:
348      *
349      * - `sender` cannot be the zero address.
350      * - `recipient` cannot be the zero address.
351      * - `sender` must have a balance of at least `amount`.
352      */
353     function _transfer(
354         address sender,
355         address recipient,
356         uint256 amount
357     ) internal virtual {
358         require(sender != address(0), "ERC20: transfer from the zero address");
359         require(recipient != address(0), "ERC20: transfer to the zero address");
360 
361         _beforeTokenTransfer(sender, recipient, amount);
362 
363         uint256 senderBalance = _balances[sender];
364         require(
365             senderBalance >= amount,
366             "ERC20: transfer amount exceeds balance"
367         );
368         unchecked {
369             _balances[sender] = senderBalance - amount;
370         }
371         _balances[recipient] += amount;
372 
373         emit Transfer(sender, recipient, amount);
374 
375         _afterTokenTransfer(sender, recipient, amount);
376     }
377 
378     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
379      * the total supply.
380      *
381      * Emits a {Transfer} event with `from` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      */
387     function _mint(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: mint to the zero address");
389 
390         _beforeTokenTransfer(address(0), account, amount);
391 
392         _totalSupply += amount;
393         _balances[account] += amount;
394         emit Transfer(address(0), account, amount);
395 
396         _afterTokenTransfer(address(0), account, amount);
397     }
398 
399     /**
400      * @dev Destroys `amount` tokens from `account`, reducing the
401      * total supply.
402      *
403      * Emits a {Transfer} event with `to` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      * - `account` must have at least `amount` tokens.
409      */
410     function _burn(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: burn from the zero address");
412 
413         _beforeTokenTransfer(account, address(0), amount);
414 
415         uint256 accountBalance = _balances[account];
416         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
417         unchecked {
418             _balances[account] = accountBalance - amount;
419         }
420         _totalSupply -= amount;
421 
422         emit Transfer(account, address(0), amount);
423 
424         _afterTokenTransfer(account, address(0), amount);
425     }
426 
427     /**
428      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
429      *
430      * This internal function is equivalent to `approve`, and can be used to
431      * e.g. set automatic allowances for certain subsystems, etc.
432      *
433      * Emits an {Approval} event.
434      *
435      * Requirements:
436      *
437      * - `owner` cannot be the zero address.
438      * - `spender` cannot be the zero address.
439      */
440     function _approve(
441         address owner,
442         address spender,
443         uint256 amount
444     ) internal virtual {
445         require(owner != address(0), "ERC20: approve from the zero address");
446         require(spender != address(0), "ERC20: approve to the zero address");
447 
448         _allowances[owner][spender] = amount;
449         emit Approval(owner, spender, amount);
450     }
451 
452     /**
453      * @dev Hook that is called before any transfer of tokens. This includes
454      * minting and burning.
455      *
456      * Calling conditions:
457      *
458      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
459      * will be transferred to `to`.
460      * - when `from` is zero, `amount` tokens will be minted for `to`.
461      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
462      * - `from` and `to` are never both zero.
463      *
464      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
465      */
466     function _beforeTokenTransfer(
467         address from,
468         address to,
469         uint256 amount
470     ) internal virtual {}
471 
472     /**
473      * @dev Hook that is called after any transfer of tokens. This includes
474      * minting and burning.
475      *
476      * Calling conditions:
477      *
478      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
479      * has been transferred to `to`.
480      * - when `from` is zero, `amount` tokens have been minted for `to`.
481      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
482      * - `from` and `to` are never both zero.
483      *
484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
485      */
486     function _afterTokenTransfer(
487         address from,
488         address to,
489         uint256 amount
490     ) internal virtual {}
491 }
492 
493 abstract contract Ownable is Context {
494     address private _owner;
495 
496     event OwnershipTransferred(
497         address indexed previousOwner,
498         address indexed newOwner
499     );
500 
501     /**
502      * @dev Initializes the contract setting the deployer as the initial owner.
503      */
504     constructor() {
505         _setOwner(_msgSender());
506     }
507 
508     /**
509      * @dev Returns the address of the current owner.
510      */
511     function owner() public view virtual returns (address) {
512         return _owner;
513     }
514 
515     /**
516      * @dev Throws if called by any account other than the owner.
517      */
518     modifier onlyOwner() {
519         require(owner() == _msgSender(), "Ownable: caller is not the owner");
520         _;
521     }
522 
523     /**
524      * @dev Leaves the contract without owner. It will not be possible to call
525      * `onlyOwner` functions anymore. Can only be called by the current owner.
526      *
527      * NOTE: Renouncing ownership will leave the contract without an owner,
528      * thereby removing any functionality that is only available to the owner.
529      */
530     function renounceOwnership() public virtual onlyOwner {
531         _setOwner(address(0));
532     }
533 
534     /**
535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
536      * Can only be called by the current owner.
537      */
538     function transferOwnership(address newOwner) public virtual onlyOwner {
539         require(
540             newOwner != address(0),
541             "Ownable: new owner is the zero address"
542         );
543         _setOwner(newOwner);
544     }
545 
546     function _setOwner(address newOwner) private {
547         address oldOwner = _owner;
548         _owner = newOwner;
549         emit OwnershipTransferred(oldOwner, newOwner);
550     }
551 }
552 
553 interface IUniswapV2Factory {
554     function createPair(
555         address tokenA,
556         address tokenB
557     ) external returns (address pair);
558 }
559 
560 interface IUniswapV2Router02 {
561     function factory() external pure returns (address);
562 
563     function WETH() external pure returns (address);
564 }
565 
566 interface IUniswapV2Pair {
567     function totalSupply() external view returns (uint);
568 }
569 
570 contract HtdToken is ERC20, Ownable {
571     string private constant name_ = "HotPad";
572     string private constant symbol_ = "HTD";
573     uint8 private constant decimal_ = 18;
574     uint256 private constant total_ = 1 * (10 ** 8) * (10 ** uint256(decimal_));
575 
576     mapping(address => bool) public blocklist;
577     mapping(address => bool) public pairs;
578 
579     uint256 public tradingTime = 1672502400;
580     uint256 public lockSecond;
581     IUniswapV2Pair uniswapV2Pair;
582     IERC20 currency;
583 
584     event UpdateBlocklist(address account, bool isBlock);
585 
586     constructor(
587         address _router,
588         address _currency
589     ) ERC20(name_, symbol_, decimal_) {
590         _mint(msg.sender, total_);
591         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(_router);
592         address uniswapV2PairAddress = IUniswapV2Factory(
593             uniswapV2Router.factory()
594         ).createPair(address(this), _currency);
595         uniswapV2Pair = IUniswapV2Pair(uniswapV2PairAddress);
596         currency = IERC20(_currency);
597         pairs[uniswapV2PairAddress] = true;
598     }
599 
600     function setBlocklist(address account, bool _block) external onlyOwner {
601         _addBlocklist(account, _block);
602     }
603 
604     function setTimeInfo(
605         uint256 _tradingTime,
606         uint256 _lock_s
607     ) external onlyOwner {
608         tradingTime = _tradingTime;
609         lockSecond = _lock_s;
610     }
611 
612     function _addBlocklist(address account, bool _block) internal {
613         blocklist[account] = _block;
614         emit UpdateBlocklist(account, _block);
615     }
616 
617     function _transfer(
618         address sender,
619         address recipient,
620         uint256 amount
621     ) internal override {
622         require(!blocklist[sender], "blocklist");
623 
624         if (pairs[recipient] || pairs[sender]) {
625             if (checkIsBlock() && !_isOwnerTransfer(sender, recipient)) {
626                 _addBlock(sender);
627                 _addBlock(recipient);
628             }
629         }
630 
631         super._transfer(sender, recipient, amount);
632     }
633 
634     function _isOwnerTransfer(
635         address _sender,
636         address _recipient
637     ) internal view returns (bool) {
638         return _sender == owner() || _recipient == owner();
639     }
640 
641     function _addBlock(address addr) internal {
642         if (!pairs[addr]) {
643             _addBlocklist(addr, true);
644         }
645     }
646 
647     function checkIsBlock() internal view returns (bool) {
648         return tradingTime + lockSecond > block.timestamp;
649     }
650 }