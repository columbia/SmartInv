1 // SPDX-License-Identifier: MIT
2 
3 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
4 
5 // OpenZeppelin Contracts v4.3.2 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
30 
31 
32 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(
94         address sender,
95         address recipient,
96         uint256 amount
97     ) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol
115 
116 
117 // OpenZeppelin Contracts v4.3.2 (token/ERC20/extensions/IERC20Metadata.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Interface for the optional metadata functions from the ERC20 standard.
124  *
125  * _Available since v4.1._
126  */
127 interface IERC20Metadata is IERC20 {
128     /**
129      * @dev Returns the name of the token.
130      */
131     function name() external view returns (string memory);
132 
133     /**
134      * @dev Returns the symbol of the token.
135      */
136     function symbol() external view returns (string memory);
137 
138     /**
139      * @dev Returns the decimals places of the token.
140      */
141     function decimals() external view returns (uint8);
142 }
143 
144 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
145 
146 
147 // OpenZeppelin Contracts v4.3.2 (token/ERC20/ERC20.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 /**
153  * @dev Implementation of the {IERC20} interface.
154  *
155  * This implementation is agnostic to the way tokens are created. This means
156  * that a supply mechanism has to be added in a derived contract using {_mint}.
157  * For a generic mechanism see {ERC20PresetMinterPauser}.
158  *
159  * TIP: For a detailed writeup see our guide
160  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
161  * to implement supply mechanisms].
162  *
163  * We have followed general OpenZeppelin Contracts guidelines: functions revert
164  * instead returning `false` on failure. This behavior is nonetheless
165  * conventional and does not conflict with the expectations of ERC20
166  * applications.
167  *
168  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
169  * This allows applications to reconstruct the allowance for all accounts just
170  * by listening to said events. Other implementations of the EIP may not emit
171  * these events, as it isn't required by the specification.
172  *
173  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
174  * functions have been added to mitigate the well-known issues around setting
175  * allowances. See {IERC20-approve}.
176  */
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 18;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(_msgSender(), recipient, amount);
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
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * Requirements:
286      *
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``sender``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         _transfer(sender, recipient, amount);
298 
299         uint256 currentAllowance = _allowances[sender][_msgSender()];
300         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
301         unchecked {
302             _approve(sender, _msgSender(), currentAllowance - amount);
303         }
304 
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
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         uint256 currentAllowance = _allowances[_msgSender()][spender];
341         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
342         unchecked {
343             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Moves `amount` of tokens from `sender` to `recipient`.
351      *
352      * This internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `sender` cannot be the zero address.
360      * - `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) internal virtual {
368         require(sender != address(0), "ERC20: transfer from the zero address");
369         require(recipient != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(sender, recipient, amount);
372 
373         uint256 senderBalance = _balances[sender];
374         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[sender] = senderBalance - amount;
377         }
378         _balances[recipient] += amount;
379 
380         emit Transfer(sender, recipient, amount);
381 
382         _afterTokenTransfer(sender, recipient, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply += amount;
400         _balances[account] += amount;
401         emit Transfer(address(0), account, amount);
402 
403         _afterTokenTransfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         uint256 accountBalance = _balances[account];
423         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
424         unchecked {
425             _balances[account] = accountBalance - amount;
426         }
427         _totalSupply -= amount;
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Hook that is called before any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * will be transferred to `to`.
467      * - when `from` is zero, `amount` tokens will be minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _beforeTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 
479     /**
480      * @dev Hook that is called after any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * has been transferred to `to`.
487      * - when `from` is zero, `amount` tokens have been minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _afterTokenTransfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {}
498 }
499 
500 pragma solidity ^0.8.5;
501 
502 // OpenZeppelin Contracts v4.3.2 (token/ERC20/ERC20.sol)
503 
504 
505 contract Ownable is Context
506 {
507     address private _owner;
508     address private _previousOwner;
509     uint256 private _lockTime;
510 
511     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
512 
513     /**
514     * @dev Initializes the contract setting the deployer as the initial owner.
515     */
516     constructor ()
517     {
518         address msgSender = _msgSender();
519         _owner = msgSender;
520         emit OwnershipTransferred(address(0), msgSender);
521     }
522 
523     /**
524     * @dev Returns the address of the current owner.
525     */
526     function owner() public view returns (address)
527     {
528         return _owner;
529     }
530 
531     /**
532     * @dev Throws if called by any account other than the owner.
533     */
534     modifier onlyOwner()
535     {
536         require(_owner == _msgSender(), "Ownable: caller is not the owner");
537         _;
538     }
539 
540     /**
541     * @dev Leaves the contract without owner. It will not be possible to call
542     * `onlyOwner` functions anymore. Can only be called by the current owner.
543     *
544     * NOTE: Renouncing ownership will leave the contract without an owner,
545     * thereby removing any functionality that is only available to the owner.
546     */
547     function renounceOwnership() public virtual onlyOwner
548     {
549         emit OwnershipTransferred(_owner, address(0));
550         _owner = address(0);
551     }
552 
553     /**
554     * @dev Transfers ownership of the contract to a new account (`newOwner`).
555     * Can only be called by the current owner.
556     */
557     function transferOwnership(address newOwner) public virtual onlyOwner
558     {
559         require(newOwner != address(0), "Ownable: new owner is the zero address");
560         emit OwnershipTransferred(_owner, newOwner);
561         _owner = newOwner;
562     }
563 
564     function getUnlockTime() public view returns (uint256)
565     {
566         return _lockTime;
567     }
568 
569 }
570 
571 contract Zaddy is ERC20, Ownable
572 {
573     mapping (address => bool) private _isExcludedFromFee;
574 
575     address[] private _excluded;
576 
577     address DevWallet1 = 0x90291D0778Af73C87Fc3865bF50A0Ca122E3a62E;
578     address DevWallet2 = 0xF3dbe70188C49Dfbecbd6F16AF6dd3Ce8Ec93b81;
579     address DevWallet3 = 0x8ddca023C1d0F4BF33a284DaEF38C3C5803ccb82;
580     address DevWallet4 = 0xf8a22F34A07f4A9b04A195e46A43de04b69c6114;
581 
582     constructor() ERC20('ZaddyZelenskyy', 'ZADDY')
583     {
584         // Exclude dev wallet from fees for testing
585         _isExcludedFromFee[owner()] = true;
586         _isExcludedFromFee[address(this)] = true;
587         _isExcludedFromFee[DevWallet1] = true;
588         _isExcludedFromFee[DevWallet2] = true;
589         _isExcludedFromFee[DevWallet3] = true;
590         _isExcludedFromFee[DevWallet4] = true;
591 
592 
593         _mint(msg.sender, 50000000000 * 10 ** 18);
594     }
595 
596     /**
597      * @dev See {IERC20-transfer}.
598      *
599      * Requirements:
600      *
601      * - `recipient` cannot be the zero address.
602      * - the caller must have a balance of at least `amount`.
603      */
604     function transfer(address recipient, uint256 amount) public virtual override returns (bool)
605     {
606         uint256 singleFee = (amount / 100);     //Calculate 1% fee
607         uint256 burnFee = singleFee * 3 / 2;       //Calculate burn fee 1.5%
608         uint256 devFee = singleFee * 6;      //Calculate dev wallet dee
609 
610         uint256 newAmmount = amount - burnFee - devFee; //Calculate new amount
611 
612         if(isExcludedFromFee(_msgSender()))
613         {
614             _transfer(_msgSender(), recipient, amount);
615         }
616         else
617         {
618             _transfer(_msgSender(), DevWallet1, devFee);
619             _burn(_msgSender(), burnFee);
620             _transfer(_msgSender(), recipient, newAmmount);
621         }
622 
623         return true;
624     }
625 
626     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool)
627     {
628         uint256 singleFee = (amount / 100);     //Calculate 1% fee
629         uint256 burnFee = singleFee * 3 /2;       //Calculate burn fee 1.5%
630         uint256 devFee = singleFee * 6;      //Calculate dev wallet dee
631 
632         uint256 newAmmount = amount - burnFee - devFee; //Calculate new amount
633 
634         uint256 currentAllowance = allowance(sender,_msgSender());
635 
636         if (currentAllowance != type(uint256).max)
637         {
638             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
639 
640             unchecked
641             {
642                 _approve(sender, _msgSender(), currentAllowance - amount);
643             }
644         }
645 
646         if(isExcludedFromFee(_msgSender()))
647         {
648             _transfer(sender, recipient, amount);
649         }
650         else
651         {
652             _transfer(sender, DevWallet1, devFee);
653             _burn(sender, burnFee);
654             _transfer(sender, recipient, newAmmount);
655         }
656 
657         return true;
658     }
659 
660     function setExcludeFromFee(address account, bool excluded) external onlyOwner()
661     {
662         _isExcludedFromFee[account] = excluded;
663     }
664 
665     function isExcludedFromFee(address account) public view returns(bool)
666     {
667         return _isExcludedFromFee[account];
668     }
669 }