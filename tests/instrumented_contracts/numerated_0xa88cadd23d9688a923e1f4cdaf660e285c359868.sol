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
15   function _msgSender() internal view virtual returns (address) {
16     return msg.sender;
17   }
18 
19   function _msgData() internal view virtual returns (bytes calldata) {
20     return msg.data;
21   }
22 }
23 
24 // File: @openzeppelin/contracts/access/Ownable.sol
25 
26 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
27 
28 pragma solidity ^0.8.0;
29 
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43   address private _owner;
44 
45   event OwnershipTransferred(
46     address indexed previousOwner,
47     address indexed newOwner
48   );
49 
50   /**
51    * @dev Initializes the contract setting the deployer as the initial owner.
52    */
53   constructor() {
54     _transferOwnership(_msgSender());
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     _checkOwner();
62     _;
63   }
64 
65   /**
66    * @dev Returns the address of the current owner.
67    */
68   function owner() public view virtual returns (address) {
69     return _owner;
70   }
71 
72   /**
73    * @dev Throws if the sender is not the owner.
74    */
75   function _checkOwner() internal view virtual {
76     require(owner() == _msgSender(), "Ownable: caller is not the owner");
77   }
78 
79   /**
80    * @dev Leaves the contract without owner. It will not be possible to call
81    * `onlyOwner` functions anymore. Can only be called by the current owner.
82    *
83    * NOTE: Renouncing ownership will leave the contract without an owner,
84    * thereby removing any functionality that is only available to the owner.
85    */
86   function renounceOwnership() public virtual onlyOwner {
87     _transferOwnership(address(0));
88   }
89 
90   /**
91    * @dev Transfers ownership of the contract to a new account (`newOwner`).
92    * Can only be called by the current owner.
93    */
94   function transferOwnership(address newOwner) public virtual onlyOwner {
95     require(newOwner != address(0), "Ownable: new owner is the zero address");
96     _transferOwnership(newOwner);
97   }
98 
99   /**
100    * @dev Transfers ownership of the contract to a new account (`newOwner`).
101    * Internal function without access restriction.
102    */
103   function _transferOwnership(address newOwner) internal virtual {
104     address oldOwner = _owner;
105     _owner = newOwner;
106     emit OwnershipTransferred(oldOwner, newOwner);
107   }
108 }
109 
110 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
111 
112 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP.
118  */
119 interface IERC20 {
120   /**
121    * @dev Emitted when `value` tokens are moved from one account (`from`) to
122    * another (`to`).
123    *
124    * Note that `value` may be zero.
125    */
126   event Transfer(address indexed from, address indexed to, uint256 value);
127 
128   /**
129    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130    * a call to {approve}. `value` is the new allowance.
131    */
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 
134   /**
135    * @dev Returns the amount of tokens in existence.
136    */
137   function totalSupply() external view returns (uint256);
138 
139   /**
140    * @dev Returns the amount of tokens owned by `account`.
141    */
142   function balanceOf(address account) external view returns (uint256);
143 
144   /**
145    * @dev Moves `amount` tokens from the caller's account to `to`.
146    *
147    * Returns a boolean value indicating whether the operation succeeded.
148    *
149    * Emits a {Transfer} event.
150    */
151   function transfer(address to, uint256 amount) external returns (bool);
152 
153   /**
154    * @dev Returns the remaining number of tokens that `spender` will be
155    * allowed to spend on behalf of `owner` through {transferFrom}. This is
156    * zero by default.
157    *
158    * This value changes when {approve} or {transferFrom} are called.
159    */
160   function allowance(
161     address owner,
162     address spender
163   ) external view returns (uint256);
164 
165   /**
166    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167    *
168    * Returns a boolean value indicating whether the operation succeeded.
169    *
170    * IMPORTANT: Beware that changing an allowance with this method brings the risk
171    * that someone may use both the old and the new allowance by unfortunate
172    * transaction ordering. One possible solution to mitigate this race
173    * condition is to first reduce the spender's allowance to 0 and set the
174    * desired value afterwards:
175    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176    *
177    * Emits an {Approval} event.
178    */
179   function approve(address spender, uint256 amount) external returns (bool);
180 
181   /**
182    * @dev Moves `amount` tokens from `from` to `to` using the
183    * allowance mechanism. `amount` is then deducted from the caller's
184    * allowance.
185    *
186    * Returns a boolean value indicating whether the operation succeeded.
187    *
188    * Emits a {Transfer} event.
189    */
190   function transferFrom(
191     address from,
192     address to,
193     uint256 amount
194   ) external returns (bool);
195 }
196 
197 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
198 
199 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
200 
201 pragma solidity ^0.8.0;
202 
203 /**
204  * @dev Interface for the optional metadata functions from the ERC20 standard.
205  *
206  * _Available since v4.1._
207  */
208 interface IERC20Metadata is IERC20 {
209   /**
210    * @dev Returns the name of the token.
211    */
212   function name() external view returns (string memory);
213 
214   /**
215    * @dev Returns the symbol of the token.
216    */
217   function symbol() external view returns (string memory);
218 
219   /**
220    * @dev Returns the decimals places of the token.
221    */
222   function decimals() external view returns (uint8);
223 }
224 
225 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
226 
227 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20PresetMinterPauser}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin Contracts guidelines: functions revert
243  * instead returning `false` on failure. This behavior is nonetheless
244  * conventional and does not conflict with the expectations of ERC20
245  * applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257   mapping(address => uint256) private _balances;
258 
259   mapping(address => mapping(address => uint256)) private _allowances;
260 
261   uint256 private _totalSupply;
262 
263   string private _name;
264   string private _symbol;
265 
266   /**
267    * @dev Sets the values for {name} and {symbol}.
268    *
269    * The default value of {decimals} is 18. To select a different value for
270    * {decimals} you should overload it.
271    *
272    * All two of these values are immutable: they can only be set once during
273    * construction.
274    */
275   constructor(string memory name_, string memory symbol_) {
276     _name = name_;
277     _symbol = symbol_;
278   }
279 
280   /**
281    * @dev Returns the name of the token.
282    */
283   function name() public view virtual override returns (string memory) {
284     return _name;
285   }
286 
287   /**
288    * @dev Returns the symbol of the token, usually a shorter version of the
289    * name.
290    */
291   function symbol() public view virtual override returns (string memory) {
292     return _symbol;
293   }
294 
295   /**
296    * @dev Returns the number of decimals used to get its user representation.
297    * For example, if `decimals` equals `2`, a balance of `505` tokens should
298    * be displayed to a user as `5.05` (`505 / 10 ** 2`).
299    *
300    * Tokens usually opt for a value of 18, imitating the relationship between
301    * Ether and Wei. This is the value {ERC20} uses, unless this function is
302    * overridden;
303    *
304    * NOTE: This information is only used for _display_ purposes: it in
305    * no way affects any of the arithmetic of the contract, including
306    * {IERC20-balanceOf} and {IERC20-transfer}.
307    */
308   function decimals() public view virtual override returns (uint8) {
309     return 18;
310   }
311 
312   /**
313    * @dev See {IERC20-totalSupply}.
314    */
315   function totalSupply() public view virtual override returns (uint256) {
316     return _totalSupply;
317   }
318 
319   /**
320    * @dev See {IERC20-balanceOf}.
321    */
322   function balanceOf(
323     address account
324   ) public view virtual override returns (uint256) {
325     return _balances[account];
326   }
327 
328   /**
329    * @dev See {IERC20-transfer}.
330    *
331    * Requirements:
332    *
333    * - `to` cannot be the zero address.
334    * - the caller must have a balance of at least `amount`.
335    */
336   function transfer(
337     address to,
338     uint256 amount
339   ) public virtual override returns (bool) {
340     address owner = _msgSender();
341     _transfer(owner, to, amount);
342     return true;
343   }
344 
345   /**
346    * @dev See {IERC20-allowance}.
347    */
348   function allowance(
349     address owner,
350     address spender
351   ) public view virtual override returns (uint256) {
352     return _allowances[owner][spender];
353   }
354 
355   /**
356    * @dev See {IERC20-approve}.
357    *
358    * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
359    * `transferFrom`. This is semantically equivalent to an infinite approval.
360    *
361    * Requirements:
362    *
363    * - `spender` cannot be the zero address.
364    */
365   function approve(
366     address spender,
367     uint256 amount
368   ) public virtual override returns (bool) {
369     address owner = _msgSender();
370     _approve(owner, spender, amount);
371     return true;
372   }
373 
374   /**
375    * @dev See {IERC20-transferFrom}.
376    *
377    * Emits an {Approval} event indicating the updated allowance. This is not
378    * required by the EIP. See the note at the beginning of {ERC20}.
379    *
380    * NOTE: Does not update the allowance if the current allowance
381    * is the maximum `uint256`.
382    *
383    * Requirements:
384    *
385    * - `from` and `to` cannot be the zero address.
386    * - `from` must have a balance of at least `amount`.
387    * - the caller must have allowance for ``from``'s tokens of at least
388    * `amount`.
389    */
390   function transferFrom(
391     address from,
392     address to,
393     uint256 amount
394   ) public virtual override returns (bool) {
395     address spender = _msgSender();
396     _spendAllowance(from, spender, amount);
397     _transfer(from, to, amount);
398     return true;
399   }
400 
401   /**
402    * @dev Atomically increases the allowance granted to `spender` by the caller.
403    *
404    * This is an alternative to {approve} that can be used as a mitigation for
405    * problems described in {IERC20-approve}.
406    *
407    * Emits an {Approval} event indicating the updated allowance.
408    *
409    * Requirements:
410    *
411    * - `spender` cannot be the zero address.
412    */
413   function increaseAllowance(
414     address spender,
415     uint256 addedValue
416   ) public virtual returns (bool) {
417     address owner = _msgSender();
418     _approve(owner, spender, allowance(owner, spender) + addedValue);
419     return true;
420   }
421 
422   /**
423    * @dev Atomically decreases the allowance granted to `spender` by the caller.
424    *
425    * This is an alternative to {approve} that can be used as a mitigation for
426    * problems described in {IERC20-approve}.
427    *
428    * Emits an {Approval} event indicating the updated allowance.
429    *
430    * Requirements:
431    *
432    * - `spender` cannot be the zero address.
433    * - `spender` must have allowance for the caller of at least
434    * `subtractedValue`.
435    */
436   function decreaseAllowance(
437     address spender,
438     uint256 subtractedValue
439   ) public virtual returns (bool) {
440     address owner = _msgSender();
441     uint256 currentAllowance = allowance(owner, spender);
442     require(
443       currentAllowance >= subtractedValue,
444       "ERC20: decreased allowance below zero"
445     );
446     unchecked {
447       _approve(owner, spender, currentAllowance - subtractedValue);
448     }
449 
450     return true;
451   }
452 
453   /**
454    * @dev Moves `amount` of tokens from `from` to `to`.
455    *
456    * This internal function is equivalent to {transfer}, and can be used to
457    * e.g. implement automatic token fees, slashing mechanisms, etc.
458    *
459    * Emits a {Transfer} event.
460    *
461    * Requirements:
462    *
463    * - `from` cannot be the zero address.
464    * - `to` cannot be the zero address.
465    * - `from` must have a balance of at least `amount`.
466    */
467   function _transfer(
468     address from,
469     address to,
470     uint256 amount
471   ) internal virtual {
472     require(from != address(0), "ERC20: transfer from the zero address");
473     require(to != address(0), "ERC20: transfer to the zero address");
474 
475     _beforeTokenTransfer(from, to, amount);
476 
477     uint256 fromBalance = _balances[from];
478     require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
479     unchecked {
480       _balances[from] = fromBalance - amount;
481       // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
482       // decrementing then incrementing.
483       _balances[to] += amount;
484     }
485 
486     emit Transfer(from, to, amount);
487 
488     _afterTokenTransfer(from, to, amount);
489   }
490 
491   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
492    * the total supply.
493    *
494    * Emits a {Transfer} event with `from` set to the zero address.
495    *
496    * Requirements:
497    *
498    * - `account` cannot be the zero address.
499    */
500   function _mint(address account, uint256 amount) internal virtual {
501     require(account != address(0), "ERC20: mint to the zero address");
502 
503     _beforeTokenTransfer(address(0), account, amount);
504 
505     _totalSupply += amount;
506     unchecked {
507       // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
508       _balances[account] += amount;
509     }
510     emit Transfer(address(0), account, amount);
511 
512     _afterTokenTransfer(address(0), account, amount);
513   }
514 
515   /**
516    * @dev Destroys `amount` tokens from `account`, reducing the
517    * total supply.
518    *
519    * Emits a {Transfer} event with `to` set to the zero address.
520    *
521    * Requirements:
522    *
523    * - `account` cannot be the zero address.
524    * - `account` must have at least `amount` tokens.
525    */
526   function _burn(address account, uint256 amount) internal virtual {
527     require(account != address(0), "ERC20: burn from the zero address");
528 
529     _beforeTokenTransfer(account, address(0), amount);
530 
531     uint256 accountBalance = _balances[account];
532     require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
533     unchecked {
534       _balances[account] = accountBalance - amount;
535       // Overflow not possible: amount <= accountBalance <= totalSupply.
536       _totalSupply -= amount;
537     }
538 
539     emit Transfer(account, address(0), amount);
540 
541     _afterTokenTransfer(account, address(0), amount);
542   }
543 
544   /**
545    * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
546    *
547    * This internal function is equivalent to `approve`, and can be used to
548    * e.g. set automatic allowances for certain subsystems, etc.
549    *
550    * Emits an {Approval} event.
551    *
552    * Requirements:
553    *
554    * - `owner` cannot be the zero address.
555    * - `spender` cannot be the zero address.
556    */
557   function _approve(
558     address owner,
559     address spender,
560     uint256 amount
561   ) internal virtual {
562     require(owner != address(0), "ERC20: approve from the zero address");
563     require(spender != address(0), "ERC20: approve to the zero address");
564 
565     _allowances[owner][spender] = amount;
566     emit Approval(owner, spender, amount);
567   }
568 
569   /**
570    * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
571    *
572    * Does not update the allowance amount in case of infinite allowance.
573    * Revert if not enough allowance is available.
574    *
575    * Might emit an {Approval} event.
576    */
577   function _spendAllowance(
578     address owner,
579     address spender,
580     uint256 amount
581   ) internal virtual {
582     uint256 currentAllowance = allowance(owner, spender);
583     if (currentAllowance != type(uint256).max) {
584       require(currentAllowance >= amount, "ERC20: insufficient allowance");
585       unchecked {
586         _approve(owner, spender, currentAllowance - amount);
587       }
588     }
589   }
590 
591   /**
592    * @dev Hook that is called before any transfer of tokens. This includes
593    * minting and burning.
594    *
595    * Calling conditions:
596    *
597    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
598    * will be transferred to `to`.
599    * - when `from` is zero, `amount` tokens will be minted for `to`.
600    * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
601    * - `from` and `to` are never both zero.
602    *
603    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
604    */
605   function _beforeTokenTransfer(
606     address from,
607     address to,
608     uint256 amount
609   ) internal virtual {}
610 
611   /**
612    * @dev Hook that is called after any transfer of tokens. This includes
613    * minting and burning.
614    *
615    * Calling conditions:
616    *
617    * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
618    * has been transferred to `to`.
619    * - when `from` is zero, `amount` tokens have been minted for `to`.
620    * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
621    * - `from` and `to` are never both zero.
622    *
623    * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
624    */
625   function _afterTokenTransfer(
626     address from,
627     address to,
628     uint256 amount
629   ) internal virtual {}
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
633 
634 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
635 
636 pragma solidity ^0.8.0;
637 
638 /**
639  * @dev Extension of {ERC20} that allows token holders to destroy both their own
640  * tokens and those that they have an allowance for, in a way that can be
641  * recognized off-chain (via event analysis).
642  */
643 abstract contract ERC20Burnable is Context, ERC20 {
644   event Burned(address indexed burner, uint256 amount);
645 
646   /**
647    * @dev Destroys `amount` tokens from the caller.
648    *
649    * See {ERC20-_burn}.
650    */
651   function burn(uint256 amount) public virtual {
652     _burn(_msgSender(), amount);
653 
654     emit Burned(msg.sender, amount);
655   }
656 }
657 
658 pragma solidity ^0.8.9;
659 
660 contract MonkCoin is ERC20, ERC20Burnable, Ownable {
661   constructor() ERC20("MonkCoin", "MONK") {
662     _mint(owner(), 6_942_000_000_000 * (10 ** 18));
663   }
664 
665   function airdrop(
666     address[] memory addresses,
667     uint256[] memory amounts
668   ) external {
669     require(addresses.length == amounts.length, "MONK: Arrays must be equal");
670     uint256 totalAmount;
671 
672     for (uint256 i = 0; i < amounts.length; i++) {
673       totalAmount += amounts[i];
674     }
675 
676     require(balanceOf(msg.sender) >= totalAmount, "MONK: Not enough tokens");
677 
678     for (uint256 i = 0; i < addresses.length; i++) {
679       _transfer(_msgSender(), addresses[i], amounts[i]);
680     }
681   }
682 
683   function claimStuckTokens(address token) external onlyOwner {
684     IERC20 ERC20token = IERC20(token);
685     uint256 balance = ERC20token.balanceOf(address(this));
686     ERC20token.transfer(msg.sender, balance);
687   }
688 
689   function recoverStuckEther() external onlyOwner {
690     uint256 balance = address(this).balance;
691     require(balance > 0, "MONK: No ETH available for recovery");
692     payable(msg.sender).transfer(balance);
693   }
694 }