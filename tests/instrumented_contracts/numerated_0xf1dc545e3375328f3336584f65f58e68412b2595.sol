1 // SPDX-License-Identifier: MIT
2 
3 // Welcome to Restakes.
4 
5 // https://restakes.io
6 // https://docs.restakes.io
7 
8 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
9 
10 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Contract module that helps prevent reentrant calls to a function.
16  *
17  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
18  * available, which can be applied to functions to make sure there are no nested
19  * (reentrant) calls to them.
20  *
21  * Note that because there is a single `nonReentrant` guard, functions marked as
22  * `nonReentrant` may not call one another. This can be worked around by making
23  * those functions `private`, and then adding `external` `nonReentrant` entry
24  * points to them.
25  *
26  * TIP: If you would like to learn more about reentrancy and alternative ways
27  * to protect against it, check out our blog post
28  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
29  */
30 abstract contract ReentrancyGuard {
31     // Booleans are more expensive than uint256 or any type that takes up a full
32     // word because each write operation emits an extra SLOAD to first read the
33     // slot's contents, replace the bits taken up by the boolean, and then write
34     // back. This is the compiler's defense against contract upgrades and
35     // pointer aliasing, and it cannot be disabled.
36 
37     // The values being non-zero value makes deployment a bit more expensive,
38     // but in exchange the refund on every call to nonReentrant will be lower in
39     // amount. Since refunds are capped to a percentage of the total
40     // transaction's gas, it is best to keep them low in cases like this one, to
41     // increase the likelihood of the full refund coming into effect.
42     uint256 private constant _NOT_ENTERED = 1;
43     uint256 private constant _ENTERED = 2;
44 
45     uint256 private _status;
46 
47     constructor() {
48         _status = _NOT_ENTERED;
49     }
50 
51     /**
52      * @dev Prevents a contract from calling itself, directly or indirectly.
53      * Calling a `nonReentrant` function from another `nonReentrant`
54      * function is not supported. It is possible to prevent this from happening
55      * by making the `nonReentrant` function external, and making it call a
56      * `private` function that does the actual work.
57      */
58     modifier nonReentrant() {
59         _nonReentrantBefore();
60         _;
61         _nonReentrantAfter();
62     }
63 
64     function _nonReentrantBefore() private {
65         // On the first call to nonReentrant, _status will be _NOT_ENTERED
66         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
67 
68         // Any calls to nonReentrant after this point will fail
69         _status = _ENTERED;
70     }
71 
72     function _nonReentrantAfter() private {
73         // By storing the original value once again, a refund is triggered (see
74         // https://eips.ethereum.org/EIPS/eip-2200)
75         _status = _NOT_ENTERED;
76     }
77 
78     /**
79      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
80      * `nonReentrant` function in the call stack.
81      */
82     function _reentrancyGuardEntered() internal view returns (bool) {
83         return _status == _ENTERED;
84     }
85 }
86 
87 // File: @openzeppelin/contracts/utils/Context.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/access/Ownable.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         _transferOwnership(_msgSender());
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         _checkOwner();
151         _;
152     }
153 
154     /**
155      * @dev Returns the address of the current owner.
156      */
157     function owner() public view virtual returns (address) {
158         return _owner;
159     }
160 
161     /**
162      * @dev Throws if the sender is not the owner.
163      */
164     function _checkOwner() internal view virtual {
165         require(owner() == _msgSender(), "Ownable: caller is not the owner");
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby disabling any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         _transferOwnership(address(0));
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Can only be called by the current owner.
182      */
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Internal function without access restriction.
191      */
192     function _transferOwnership(address newOwner) internal virtual {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
200 
201 
202 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Interface of the ERC20 standard as defined in the EIP.
208  */
209 interface IERC20 {
210     /**
211      * @dev Emitted when `value` tokens are moved from one account (`from`) to
212      * another (`to`).
213      *
214      * Note that `value` may be zero.
215      */
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     /**
219      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
220      * a call to {approve}. `value` is the new allowance.
221      */
222     event Approval(address indexed owner, address indexed spender, uint256 value);
223 
224     /**
225      * @dev Returns the amount of tokens in existence.
226      */
227     function totalSupply() external view returns (uint256);
228 
229     /**
230      * @dev Returns the amount of tokens owned by `account`.
231      */
232     function balanceOf(address account) external view returns (uint256);
233 
234     /**
235      * @dev Moves `amount` tokens from the caller's account to `to`.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transfer(address to, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Returns the remaining number of tokens that `spender` will be
245      * allowed to spend on behalf of `owner` through {transferFrom}. This is
246      * zero by default.
247      *
248      * This value changes when {approve} or {transferFrom} are called.
249      */
250     function allowance(address owner, address spender) external view returns (uint256);
251 
252     /**
253      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * IMPORTANT: Beware that changing an allowance with this method brings the risk
258      * that someone may use both the old and the new allowance by unfortunate
259      * transaction ordering. One possible solution to mitigate this race
260      * condition is to first reduce the spender's allowance to 0 and set the
261      * desired value afterwards:
262      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address spender, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Moves `amount` tokens from `from` to `to` using the
270      * allowance mechanism. `amount` is then deducted from the caller's
271      * allowance.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transferFrom(address from, address to, uint256 amount) external returns (bool);
278 }
279 
280 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
281 
282 
283 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
284 
285 pragma solidity ^0.8.0;
286 
287 
288 /**
289  * @dev Interface for the optional metadata functions from the ERC20 standard.
290  *
291  * _Available since v4.1._
292  */
293 interface IERC20Metadata is IERC20 {
294     /**
295      * @dev Returns the name of the token.
296      */
297     function name() external view returns (string memory);
298 
299     /**
300      * @dev Returns the symbol of the token.
301      */
302     function symbol() external view returns (string memory);
303 
304     /**
305      * @dev Returns the decimals places of the token.
306      */
307     function decimals() external view returns (uint8);
308 }
309 
310 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
311 
312 
313 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 
318 
319 
320 /**
321  * @dev Implementation of the {IERC20} interface.
322  *
323  * This implementation is agnostic to the way tokens are created. This means
324  * that a supply mechanism has to be added in a derived contract using {_mint}.
325  * For a generic mechanism see {ERC20PresetMinterPauser}.
326  *
327  * TIP: For a detailed writeup see our guide
328  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
329  * to implement supply mechanisms].
330  *
331  * The default value of {decimals} is 18. To change this, you should override
332  * this function so it returns a different value.
333  *
334  * We have followed general OpenZeppelin Contracts guidelines: functions revert
335  * instead returning `false` on failure. This behavior is nonetheless
336  * conventional and does not conflict with the expectations of ERC20
337  * applications.
338  *
339  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
340  * This allows applications to reconstruct the allowance for all accounts just
341  * by listening to said events. Other implementations of the EIP may not emit
342  * these events, as it isn't required by the specification.
343  *
344  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
345  * functions have been added to mitigate the well-known issues around setting
346  * allowances. See {IERC20-approve}.
347  */
348 contract ERC20 is Context, IERC20, IERC20Metadata {
349     mapping(address => uint256) private _balances;
350 
351     mapping(address => mapping(address => uint256)) private _allowances;
352 
353     uint256 private _totalSupply;
354 
355     string private _name;
356     string private _symbol;
357 
358     /**
359      * @dev Sets the values for {name} and {symbol}.
360      *
361      * All two of these values are immutable: they can only be set once during
362      * construction.
363      */
364     constructor(string memory name_, string memory symbol_) {
365         _name = name_;
366         _symbol = symbol_;
367     }
368 
369     /**
370      * @dev Returns the name of the token.
371      */
372     function name() public view virtual override returns (string memory) {
373         return _name;
374     }
375 
376     /**
377      * @dev Returns the symbol of the token, usually a shorter version of the
378      * name.
379      */
380     function symbol() public view virtual override returns (string memory) {
381         return _symbol;
382     }
383 
384     /**
385      * @dev Returns the number of decimals used to get its user representation.
386      * For example, if `decimals` equals `2`, a balance of `505` tokens should
387      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
388      *
389      * Tokens usually opt for a value of 18, imitating the relationship between
390      * Ether and Wei. This is the default value returned by this function, unless
391      * it's overridden.
392      *
393      * NOTE: This information is only used for _display_ purposes: it in
394      * no way affects any of the arithmetic of the contract, including
395      * {IERC20-balanceOf} and {IERC20-transfer}.
396      */
397     function decimals() public view virtual override returns (uint8) {
398         return 18;
399     }
400 
401     /**
402      * @dev See {IERC20-totalSupply}.
403      */
404     function totalSupply() public view virtual override returns (uint256) {
405         return _totalSupply;
406     }
407 
408     /**
409      * @dev See {IERC20-balanceOf}.
410      */
411     function balanceOf(address account) public view virtual override returns (uint256) {
412         return _balances[account];
413     }
414 
415     /**
416      * @dev See {IERC20-transfer}.
417      *
418      * Requirements:
419      *
420      * - `to` cannot be the zero address.
421      * - the caller must have a balance of at least `amount`.
422      */
423     function transfer(address to, uint256 amount) public virtual override returns (bool) {
424         address owner = _msgSender();
425         _transfer(owner, to, amount);
426         return true;
427     }
428 
429     /**
430      * @dev See {IERC20-allowance}.
431      */
432     function allowance(address owner, address spender) public view virtual override returns (uint256) {
433         return _allowances[owner][spender];
434     }
435 
436     /**
437      * @dev See {IERC20-approve}.
438      *
439      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
440      * `transferFrom`. This is semantically equivalent to an infinite approval.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function approve(address spender, uint256 amount) public virtual override returns (bool) {
447         address owner = _msgSender();
448         _approve(owner, spender, amount);
449         return true;
450     }
451 
452     /**
453      * @dev See {IERC20-transferFrom}.
454      *
455      * Emits an {Approval} event indicating the updated allowance. This is not
456      * required by the EIP. See the note at the beginning of {ERC20}.
457      *
458      * NOTE: Does not update the allowance if the current allowance
459      * is the maximum `uint256`.
460      *
461      * Requirements:
462      *
463      * - `from` and `to` cannot be the zero address.
464      * - `from` must have a balance of at least `amount`.
465      * - the caller must have allowance for ``from``'s tokens of at least
466      * `amount`.
467      */
468     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
469         address spender = _msgSender();
470         _spendAllowance(from, spender, amount);
471         _transfer(from, to, amount);
472         return true;
473     }
474 
475     /**
476      * @dev Atomically increases the allowance granted to `spender` by the caller.
477      *
478      * This is an alternative to {approve} that can be used as a mitigation for
479      * problems described in {IERC20-approve}.
480      *
481      * Emits an {Approval} event indicating the updated allowance.
482      *
483      * Requirements:
484      *
485      * - `spender` cannot be the zero address.
486      */
487     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
488         address owner = _msgSender();
489         _approve(owner, spender, allowance(owner, spender) + addedValue);
490         return true;
491     }
492 
493     /**
494      * @dev Atomically decreases the allowance granted to `spender` by the caller.
495      *
496      * This is an alternative to {approve} that can be used as a mitigation for
497      * problems described in {IERC20-approve}.
498      *
499      * Emits an {Approval} event indicating the updated allowance.
500      *
501      * Requirements:
502      *
503      * - `spender` cannot be the zero address.
504      * - `spender` must have allowance for the caller of at least
505      * `subtractedValue`.
506      */
507     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
508         address owner = _msgSender();
509         uint256 currentAllowance = allowance(owner, spender);
510         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
511         unchecked {
512             _approve(owner, spender, currentAllowance - subtractedValue);
513         }
514 
515         return true;
516     }
517 
518     /**
519      * @dev Moves `amount` of tokens from `from` to `to`.
520      *
521      * This internal function is equivalent to {transfer}, and can be used to
522      * e.g. implement automatic token fees, slashing mechanisms, etc.
523      *
524      * Emits a {Transfer} event.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `from` must have a balance of at least `amount`.
531      */
532     function _transfer(address from, address to, uint256 amount) internal virtual {
533         require(from != address(0), "ERC20: transfer from the zero address");
534         require(to != address(0), "ERC20: transfer to the zero address");
535 
536         _beforeTokenTransfer(from, to, amount);
537 
538         uint256 fromBalance = _balances[from];
539         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
540         unchecked {
541             _balances[from] = fromBalance - amount;
542             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
543             // decrementing then incrementing.
544             _balances[to] += amount;
545         }
546 
547         emit Transfer(from, to, amount);
548 
549         _afterTokenTransfer(from, to, amount);
550     }
551 
552     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
553      * the total supply.
554      *
555      * Emits a {Transfer} event with `from` set to the zero address.
556      *
557      * Requirements:
558      *
559      * - `account` cannot be the zero address.
560      */
561     function _mint(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: mint to the zero address");
563 
564         _beforeTokenTransfer(address(0), account, amount);
565 
566         _totalSupply += amount;
567         unchecked {
568             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
569             _balances[account] += amount;
570         }
571         emit Transfer(address(0), account, amount);
572 
573         _afterTokenTransfer(address(0), account, amount);
574     }
575 
576     /**
577      * @dev Destroys `amount` tokens from `account`, reducing the
578      * total supply.
579      *
580      * Emits a {Transfer} event with `to` set to the zero address.
581      *
582      * Requirements:
583      *
584      * - `account` cannot be the zero address.
585      * - `account` must have at least `amount` tokens.
586      */
587     function _burn(address account, uint256 amount) internal virtual {
588         require(account != address(0), "ERC20: burn from the zero address");
589 
590         _beforeTokenTransfer(account, address(0), amount);
591 
592         uint256 accountBalance = _balances[account];
593         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
594         unchecked {
595             _balances[account] = accountBalance - amount;
596             // Overflow not possible: amount <= accountBalance <= totalSupply.
597             _totalSupply -= amount;
598         }
599 
600         emit Transfer(account, address(0), amount);
601 
602         _afterTokenTransfer(account, address(0), amount);
603     }
604 
605     /**
606      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
607      *
608      * This internal function is equivalent to `approve`, and can be used to
609      * e.g. set automatic allowances for certain subsystems, etc.
610      *
611      * Emits an {Approval} event.
612      *
613      * Requirements:
614      *
615      * - `owner` cannot be the zero address.
616      * - `spender` cannot be the zero address.
617      */
618     function _approve(address owner, address spender, uint256 amount) internal virtual {
619         require(owner != address(0), "ERC20: approve from the zero address");
620         require(spender != address(0), "ERC20: approve to the zero address");
621 
622         _allowances[owner][spender] = amount;
623         emit Approval(owner, spender, amount);
624     }
625 
626     /**
627      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
628      *
629      * Does not update the allowance amount in case of infinite allowance.
630      * Revert if not enough allowance is available.
631      *
632      * Might emit an {Approval} event.
633      */
634     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
635         uint256 currentAllowance = allowance(owner, spender);
636         if (currentAllowance != type(uint256).max) {
637             require(currentAllowance >= amount, "ERC20: insufficient allowance");
638             unchecked {
639                 _approve(owner, spender, currentAllowance - amount);
640             }
641         }
642     }
643 
644     /**
645      * @dev Hook that is called before any transfer of tokens. This includes
646      * minting and burning.
647      *
648      * Calling conditions:
649      *
650      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
651      * will be transferred to `to`.
652      * - when `from` is zero, `amount` tokens will be minted for `to`.
653      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
654      * - `from` and `to` are never both zero.
655      *
656      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
657      */
658     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
659 
660     /**
661      * @dev Hook that is called after any transfer of tokens. This includes
662      * minting and burning.
663      *
664      * Calling conditions:
665      *
666      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
667      * has been transferred to `to`.
668      * - when `from` is zero, `amount` tokens have been minted for `to`.
669      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
670      * - `from` and `to` are never both zero.
671      *
672      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
673      */
674     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
675 }
676 
677 // File: unstake-migrate.sol
678 
679 
680 pragma solidity ^0.8.17;
681 
682 contract Restakes is ERC20, Ownable, ReentrancyGuard {
683     IERC20 public migrationToken;
684     bool public isSwapEnabled = true;
685     mapping(address => bool) public transferWhitelist;
686     bool public transferEnabled = false;
687 
688     constructor(address _migrationToken) ERC20("Restakes", "RSX") {
689         migrationToken = IERC20(_migrationToken);
690         _mint(address(this), 1000000 * 10 ** decimals());
691     }
692 
693     event TokenMigration(address indexed user, uint256 amount);
694     event MigrationPeriodEnded(bool status);
695 
696     function decimals() public view virtual override returns (uint8) {
697         return 9;
698     }
699 
700     function addToTransferWhitelist(address _address) external onlyOwner {
701         transferWhitelist[_address] = true;
702     }
703 
704     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
705         super._beforeTokenTransfer(from, to, amount);
706 
707         if(from != address(0) && to != address(0)) {
708             require(transferEnabled || transferWhitelist[from], "Transfers are disabled during migration period.");
709         }
710     }
711 
712     function migrateTokens(uint256 _amount) external { 
713         require(isSwapEnabled, "Migration has ended.");
714         require(migrationToken.balanceOf(msg.sender) >= _amount, "Insufficient migration tokens.");
715 
716         migrationToken.transferFrom(msg.sender, address(this), _amount);
717         _transfer(address(this), msg.sender, _amount);
718 
719         emit TokenMigration(msg.sender, _amount);
720     }
721 
722     function prepareEndMigrationPeriod() external onlyOwner {
723         uint256 migrationTokenBalance = migrationToken.balanceOf(address(this));
724         require(migrationTokenBalance > 0, "No migration tokens to transfer.");
725         migrationToken.transfer(msg.sender, migrationTokenBalance);
726 
727         uint256 ownTokenBalance = balanceOf(address(this));
728         if (ownTokenBalance > 0) {
729             _transfer(address(this), msg.sender, ownTokenBalance);
730         }
731     }
732 
733     function endMigrationPeriod() external onlyOwner {
734         isSwapEnabled = false;
735         transferEnabled = true;
736         emit MigrationPeriodEnded(true);
737     }
738 }