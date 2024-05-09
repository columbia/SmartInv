1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         _nonReentrantBefore();
55         _;
56         _nonReentrantAfter();
57     }
58 
59     function _nonReentrantBefore() private {
60         // On the first call to nonReentrant, _status will be _NOT_ENTERED
61         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
62 
63         // Any calls to nonReentrant after this point will fail
64         _status = _ENTERED;
65     }
66 
67     function _nonReentrantAfter() private {
68         // By storing the original value once again, a refund is triggered (see
69         // https://eips.ethereum.org/EIPS/eip-2200)
70         _status = _NOT_ENTERED;
71     }
72 }
73 
74 // File: @openzeppelin/contracts/utils/Context.sol
75 
76 
77 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes calldata) {
97         return msg.data;
98     }
99 }
100 
101 // File: @openzeppelin/contracts/access/Ownable.sol
102 
103 
104 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 
109 /**
110  * @dev Contract module which provides a basic access control mechanism, where
111  * there is an account (an owner) that can be granted exclusive access to
112  * specific functions.
113  *
114  * By default, the owner account will be the one that deploys the contract. This
115  * can later be changed with {transferOwnership}.
116  *
117  * This module is used through inheritance. It will make available the modifier
118  * `onlyOwner`, which can be applied to your functions to restrict their use to
119  * the owner.
120  */
121 abstract contract Ownable is Context {
122     address private _owner;
123 
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     /**
127      * @dev Initializes the contract setting the deployer as the initial owner.
128      */
129     constructor() {
130         _transferOwnership(_msgSender());
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         _checkOwner();
138         _;
139     }
140 
141     /**
142      * @dev Returns the address of the current owner.
143      */
144     function owner() public view virtual returns (address) {
145         return _owner;
146     }
147 
148     /**
149      * @dev Throws if the sender is not the owner.
150      */
151     function _checkOwner() internal view virtual {
152         require(owner() == _msgSender(), "Ownable: caller is not the owner");
153     }
154 
155     /**
156      * @dev Leaves the contract without owner. It will not be possible to call
157      * `onlyOwner` functions anymore. Can only be called by the current owner.
158      *
159      * NOTE: Renouncing ownership will leave the contract without an owner,
160      * thereby removing any functionality that is only available to the owner.
161      */
162     function renounceOwnership() public virtual onlyOwner {
163         _transferOwnership(address(0));
164     }
165 
166     /**
167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
168      * Can only be called by the current owner.
169      */
170     function transferOwnership(address newOwner) public virtual onlyOwner {
171         require(newOwner != address(0), "Ownable: new owner is the zero address");
172         _transferOwnership(newOwner);
173     }
174 
175     /**
176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
177      * Internal function without access restriction.
178      */
179     function _transferOwnership(address newOwner) internal virtual {
180         address oldOwner = _owner;
181         _owner = newOwner;
182         emit OwnershipTransferred(oldOwner, newOwner);
183     }
184 }
185 
186 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
187 
188 
189 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP.
195  */
196 interface IERC20 {
197     /**
198      * @dev Emitted when `value` tokens are moved from one account (`from`) to
199      * another (`to`).
200      *
201      * Note that `value` may be zero.
202      */
203     event Transfer(address indexed from, address indexed to, uint256 value);
204 
205     /**
206      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
207      * a call to {approve}. `value` is the new allowance.
208      */
209     event Approval(address indexed owner, address indexed spender, uint256 value);
210 
211     /**
212      * @dev Returns the amount of tokens in existence.
213      */
214     function totalSupply() external view returns (uint256);
215 
216     /**
217      * @dev Returns the amount of tokens owned by `account`.
218      */
219     function balanceOf(address account) external view returns (uint256);
220 
221     /**
222      * @dev Moves `amount` tokens from the caller's account to `to`.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transfer(address to, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Returns the remaining number of tokens that `spender` will be
232      * allowed to spend on behalf of `owner` through {transferFrom}. This is
233      * zero by default.
234      *
235      * This value changes when {approve} or {transferFrom} are called.
236      */
237     function allowance(address owner, address spender) external view returns (uint256);
238 
239     /**
240      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * IMPORTANT: Beware that changing an allowance with this method brings the risk
245      * that someone may use both the old and the new allowance by unfortunate
246      * transaction ordering. One possible solution to mitigate this race
247      * condition is to first reduce the spender's allowance to 0 and set the
248      * desired value afterwards:
249      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250      *
251      * Emits an {Approval} event.
252      */
253     function approve(address spender, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Moves `amount` tokens from `from` to `to` using the
257      * allowance mechanism. `amount` is then deducted from the caller's
258      * allowance.
259      *
260      * Returns a boolean value indicating whether the operation succeeded.
261      *
262      * Emits a {Transfer} event.
263      */
264     function transferFrom(
265         address from,
266         address to,
267         uint256 amount
268     ) external returns (bool);
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
272 
273 
274 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 
279 /**
280  * @dev Interface for the optional metadata functions from the ERC20 standard.
281  *
282  * _Available since v4.1._
283  */
284 interface IERC20Metadata is IERC20 {
285     /**
286      * @dev Returns the name of the token.
287      */
288     function name() external view returns (string memory);
289 
290     /**
291      * @dev Returns the symbol of the token.
292      */
293     function symbol() external view returns (string memory);
294 
295     /**
296      * @dev Returns the decimals places of the token.
297      */
298     function decimals() external view returns (uint8);
299 }
300 
301 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
302 
303 
304 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
305 
306 pragma solidity ^0.8.0;
307 
308 
309 
310 
311 /**
312  * @dev Implementation of the {IERC20} interface.
313  *
314  * This implementation is agnostic to the way tokens are created. This means
315  * that a supply mechanism has to be added in a derived contract using {_mint}.
316  * For a generic mechanism see {ERC20PresetMinterPauser}.
317  *
318  * TIP: For a detailed writeup see our guide
319  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
320  * to implement supply mechanisms].
321  *
322  * We have followed general OpenZeppelin Contracts guidelines: functions revert
323  * instead returning `false` on failure. This behavior is nonetheless
324  * conventional and does not conflict with the expectations of ERC20
325  * applications.
326  *
327  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
328  * This allows applications to reconstruct the allowance for all accounts just
329  * by listening to said events. Other implementations of the EIP may not emit
330  * these events, as it isn't required by the specification.
331  *
332  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
333  * functions have been added to mitigate the well-known issues around setting
334  * allowances. See {IERC20-approve}.
335  */
336 contract ERC20 is Context, IERC20, IERC20Metadata {
337     mapping(address => uint256) private _balances;
338 
339     mapping(address => mapping(address => uint256)) private _allowances;
340 
341     uint256 private _totalSupply;
342 
343     string private _name;
344     string private _symbol;
345 
346     /**
347      * @dev Sets the values for {name} and {symbol}.
348      *
349      * The default value of {decimals} is 18. To select a different value for
350      * {decimals} you should overload it.
351      *
352      * All two of these values are immutable: they can only be set once during
353      * construction.
354      */
355     constructor(string memory name_, string memory symbol_) {
356         _name = name_;
357         _symbol = symbol_;
358     }
359 
360     /**
361      * @dev Returns the name of the token.
362      */
363     function name() public view virtual override returns (string memory) {
364         return _name;
365     }
366 
367     /**
368      * @dev Returns the symbol of the token, usually a shorter version of the
369      * name.
370      */
371     function symbol() public view virtual override returns (string memory) {
372         return _symbol;
373     }
374 
375     /**
376      * @dev Returns the number of decimals used to get its user representation.
377      * For example, if `decimals` equals `2`, a balance of `505` tokens should
378      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
379      *
380      * Tokens usually opt for a value of 18, imitating the relationship between
381      * Ether and Wei. This is the value {ERC20} uses, unless this function is
382      * overridden;
383      *
384      * NOTE: This information is only used for _display_ purposes: it in
385      * no way affects any of the arithmetic of the contract, including
386      * {IERC20-balanceOf} and {IERC20-transfer}.
387      */
388     function decimals() public view virtual override returns (uint8) {
389         return 18;
390     }
391 
392     /**
393      * @dev See {IERC20-totalSupply}.
394      */
395     function totalSupply() public view virtual override returns (uint256) {
396         return _totalSupply;
397     }
398 
399     /**
400      * @dev See {IERC20-balanceOf}.
401      */
402     function balanceOf(address account) public view virtual override returns (uint256) {
403         return _balances[account];
404     }
405 
406     /**
407      * @dev See {IERC20-transfer}.
408      *
409      * Requirements:
410      *
411      * - `to` cannot be the zero address.
412      * - the caller must have a balance of at least `amount`.
413      */
414     function transfer(address to, uint256 amount) public virtual override returns (bool) {
415         address owner = _msgSender();
416         _transfer(owner, to, amount);
417         return true;
418     }
419 
420     /**
421      * @dev See {IERC20-allowance}.
422      */
423     function allowance(address owner, address spender) public view virtual override returns (uint256) {
424         return _allowances[owner][spender];
425     }
426 
427     /**
428      * @dev See {IERC20-approve}.
429      *
430      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
431      * `transferFrom`. This is semantically equivalent to an infinite approval.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function approve(address spender, uint256 amount) public virtual override returns (bool) {
438         address owner = _msgSender();
439         _approve(owner, spender, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-transferFrom}.
445      *
446      * Emits an {Approval} event indicating the updated allowance. This is not
447      * required by the EIP. See the note at the beginning of {ERC20}.
448      *
449      * NOTE: Does not update the allowance if the current allowance
450      * is the maximum `uint256`.
451      *
452      * Requirements:
453      *
454      * - `from` and `to` cannot be the zero address.
455      * - `from` must have a balance of at least `amount`.
456      * - the caller must have allowance for ``from``'s tokens of at least
457      * `amount`.
458      */
459     function transferFrom(
460         address from,
461         address to,
462         uint256 amount
463     ) public virtual override returns (bool) {
464         address spender = _msgSender();
465         _spendAllowance(from, spender, amount);
466         _transfer(from, to, amount);
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         address owner = _msgSender();
484         _approve(owner, spender, allowance(owner, spender) + addedValue);
485         return true;
486     }
487 
488     /**
489      * @dev Atomically decreases the allowance granted to `spender` by the caller.
490      *
491      * This is an alternative to {approve} that can be used as a mitigation for
492      * problems described in {IERC20-approve}.
493      *
494      * Emits an {Approval} event indicating the updated allowance.
495      *
496      * Requirements:
497      *
498      * - `spender` cannot be the zero address.
499      * - `spender` must have allowance for the caller of at least
500      * `subtractedValue`.
501      */
502     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
503         address owner = _msgSender();
504         uint256 currentAllowance = allowance(owner, spender);
505         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
506         unchecked {
507             _approve(owner, spender, currentAllowance - subtractedValue);
508         }
509 
510         return true;
511     }
512 
513     /**
514      * @dev Moves `amount` of tokens from `from` to `to`.
515      *
516      * This internal function is equivalent to {transfer}, and can be used to
517      * e.g. implement automatic token fees, slashing mechanisms, etc.
518      *
519      * Emits a {Transfer} event.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `from` must have a balance of at least `amount`.
526      */
527     function _transfer(
528         address from,
529         address to,
530         uint256 amount
531     ) internal virtual {
532         require(from != address(0), "ERC20: transfer from the zero address");
533         require(to != address(0), "ERC20: transfer to the zero address");
534 
535         _beforeTokenTransfer(from, to, amount);
536 
537         uint256 fromBalance = _balances[from];
538         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
539         unchecked {
540             _balances[from] = fromBalance - amount;
541             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
542             // decrementing then incrementing.
543             _balances[to] += amount;
544         }
545 
546         emit Transfer(from, to, amount);
547 
548         _afterTokenTransfer(from, to, amount);
549     }
550 
551     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
552      * the total supply.
553      *
554      * Emits a {Transfer} event with `from` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      */
560     function _mint(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: mint to the zero address");
562 
563         _beforeTokenTransfer(address(0), account, amount);
564 
565         _totalSupply += amount;
566         unchecked {
567             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
568             _balances[account] += amount;
569         }
570         emit Transfer(address(0), account, amount);
571 
572         _afterTokenTransfer(address(0), account, amount);
573     }
574 
575     /**
576      * @dev Destroys `amount` tokens from `account`, reducing the
577      * total supply.
578      *
579      * Emits a {Transfer} event with `to` set to the zero address.
580      *
581      * Requirements:
582      *
583      * - `account` cannot be the zero address.
584      * - `account` must have at least `amount` tokens.
585      */
586     function _burn(address account, uint256 amount) internal virtual {
587         require(account != address(0), "ERC20: burn from the zero address");
588 
589         _beforeTokenTransfer(account, address(0), amount);
590 
591         uint256 accountBalance = _balances[account];
592         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
593         unchecked {
594             _balances[account] = accountBalance - amount;
595             // Overflow not possible: amount <= accountBalance <= totalSupply.
596             _totalSupply -= amount;
597         }
598 
599         emit Transfer(account, address(0), amount);
600 
601         _afterTokenTransfer(account, address(0), amount);
602     }
603 
604     /**
605      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
606      *
607      * This internal function is equivalent to `approve`, and can be used to
608      * e.g. set automatic allowances for certain subsystems, etc.
609      *
610      * Emits an {Approval} event.
611      *
612      * Requirements:
613      *
614      * - `owner` cannot be the zero address.
615      * - `spender` cannot be the zero address.
616      */
617     function _approve(
618         address owner,
619         address spender,
620         uint256 amount
621     ) internal virtual {
622         require(owner != address(0), "ERC20: approve from the zero address");
623         require(spender != address(0), "ERC20: approve to the zero address");
624 
625         _allowances[owner][spender] = amount;
626         emit Approval(owner, spender, amount);
627     }
628 
629     /**
630      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
631      *
632      * Does not update the allowance amount in case of infinite allowance.
633      * Revert if not enough allowance is available.
634      *
635      * Might emit an {Approval} event.
636      */
637     function _spendAllowance(
638         address owner,
639         address spender,
640         uint256 amount
641     ) internal virtual {
642         uint256 currentAllowance = allowance(owner, spender);
643         if (currentAllowance != type(uint256).max) {
644             require(currentAllowance >= amount, "ERC20: insufficient allowance");
645             unchecked {
646                 _approve(owner, spender, currentAllowance - amount);
647             }
648         }
649     }
650 
651     /**
652      * @dev Hook that is called before any transfer of tokens. This includes
653      * minting and burning.
654      *
655      * Calling conditions:
656      *
657      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
658      * will be transferred to `to`.
659      * - when `from` is zero, `amount` tokens will be minted for `to`.
660      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
661      * - `from` and `to` are never both zero.
662      *
663      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
664      */
665     function _beforeTokenTransfer(
666         address from,
667         address to,
668         uint256 amount
669     ) internal virtual {}
670 
671     /**
672      * @dev Hook that is called after any transfer of tokens. This includes
673      * minting and burning.
674      *
675      * Calling conditions:
676      *
677      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
678      * has been transferred to `to`.
679      * - when `from` is zero, `amount` tokens have been minted for `to`.
680      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
681      * - `from` and `to` are never both zero.
682      *
683      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
684      */
685     function _afterTokenTransfer(
686         address from,
687         address to,
688         uint256 amount
689     ) internal virtual {}
690 }
691 
692 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
693 
694 
695 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 
700 
701 /**
702  * @dev Extension of {ERC20} that allows token holders to destroy both their own
703  * tokens and those that they have an allowance for, in a way that can be
704  * recognized off-chain (via event analysis).
705  */
706 abstract contract ERC20Burnable is Context, ERC20 {
707     /**
708      * @dev Destroys `amount` tokens from the caller.
709      *
710      * See {ERC20-_burn}.
711      */
712     function burn(uint256 amount) public virtual {
713         _burn(_msgSender(), amount);
714     }
715 
716     /**
717      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
718      * allowance.
719      *
720      * See {ERC20-_burn} and {ERC20-allowance}.
721      *
722      * Requirements:
723      *
724      * - the caller must have allowance for ``accounts``'s tokens of at least
725      * `amount`.
726      */
727     function burnFrom(address account, uint256 amount) public virtual {
728         _spendAllowance(account, _msgSender(), amount);
729         _burn(account, amount);
730     }
731 }
732 
733 // File: contracts/ERC20Stakeable.sol
734 
735 
736 // Creator: andreitoma8
737 pragma solidity ^0.8.4;
738 
739 
740 
741 
742 contract ERC20Stakeable is ERC20, ERC20Burnable, ReentrancyGuard {
743     // Staker info
744     struct Staker {
745         // The deposited tokens of the Staker
746         uint256 deposited;
747         // Last time of details update for Deposit
748         uint256 timeOfLastUpdate;
749         // Calculated, but unclaimed rewards. These are calculated each time
750         // a user writes to the contract.
751         uint256 unclaimedRewards;
752     }
753 
754     // Rewards per hour. A fraction calculated as x/10.000.000 to get the percentage
755     uint256 public rewardsPerHour = 120; // 0.001%/h or 10% APR
756 
757     // Minimum amount to stake
758     uint256 public minStake = 10 * 10**decimals();
759 
760     // Compounding frequency limit in seconds
761     uint256 public compoundFreq = 14400; //4 hours
762 
763     // Mapping of address to Staker info
764     mapping(address => Staker) internal stakers;
765 
766     // Constructor function
767     constructor(string memory _name, string memory _symbol)
768         ERC20(_name, _symbol)
769     {}
770 
771     // If address has no Staker struct, initiate one. If address already was a stake,
772     // calculate the rewards and add them to unclaimedRewards, reset the last time of
773     // deposit and then add _amount to the already deposited amount.
774     // Burns the amount staked.
775     function deposit(uint256 _amount) external nonReentrant {
776         require(_amount >= minStake, "Amount smaller than minimimum deposit");
777         require(
778             balanceOf(msg.sender) >= _amount,
779             "Can't stake more than you own"
780         );
781         if (stakers[msg.sender].deposited == 0) {
782             stakers[msg.sender].deposited = _amount;
783             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
784             stakers[msg.sender].unclaimedRewards = 0;
785         } else {
786             uint256 rewards = calculateRewards(msg.sender);
787             stakers[msg.sender].unclaimedRewards += rewards;
788             stakers[msg.sender].deposited += _amount;
789             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
790         }
791         _burn(msg.sender, _amount);
792     }
793 
794     // Compound the rewards and reset the last time of update for Deposit info
795     function stakeRewards() external nonReentrant {
796         require(stakers[msg.sender].deposited > 0, "You have no deposit");
797         require(
798             compoundRewardsTimer(msg.sender) == 0,
799             "Tried to compound rewars too soon"
800         );
801         uint256 rewards = calculateRewards(msg.sender) +
802             stakers[msg.sender].unclaimedRewards;
803         stakers[msg.sender].unclaimedRewards = 0;
804         stakers[msg.sender].deposited += rewards;
805         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
806     }
807 
808     // Mints rewards for msg.sender
809     function claimRewards() external nonReentrant {
810         uint256 rewards = calculateRewards(msg.sender) +
811             stakers[msg.sender].unclaimedRewards;
812         require(rewards > 0, "You have no rewards");
813         stakers[msg.sender].unclaimedRewards = 0;
814         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
815         _mint(msg.sender, rewards);
816     }
817 
818     // Withdraw specified amount of staked tokens
819     function withdraw(uint256 _amount) external nonReentrant {
820         require(
821             stakers[msg.sender].deposited >= _amount,
822             "Can't withdraw more than you have"
823         );
824         uint256 _rewards = calculateRewards(msg.sender);
825         stakers[msg.sender].deposited -= _amount;
826         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
827         stakers[msg.sender].unclaimedRewards = _rewards;
828         _mint(msg.sender, _amount);
829     }
830 
831     // Withdraw all stake and rewards and mints them to the msg.sender
832     function withdrawAll() external nonReentrant {
833         require(stakers[msg.sender].deposited > 0, "You have no deposit");
834         uint256 _rewards = calculateRewards(msg.sender) +
835             stakers[msg.sender].unclaimedRewards;
836         uint256 _deposit = stakers[msg.sender].deposited;
837         stakers[msg.sender].deposited = 0;
838         stakers[msg.sender].timeOfLastUpdate = 0;
839         uint256 _amount = _rewards + _deposit;
840         _mint(msg.sender, _amount);
841     }
842 
843     // Function useful for fron-end that returns user stake and rewards by address
844     function getDepositInfo(address _user)
845         public
846         view
847         returns (uint256 _stake, uint256 _rewards)
848     {
849         _stake = stakers[_user].deposited;
850         _rewards =
851             calculateRewards(_user) +
852             stakers[msg.sender].unclaimedRewards;
853         return (_stake, _rewards);
854     }
855 
856     // Utility function that returns the timer for restaking rewards
857     function compoundRewardsTimer(address _user)
858         public
859         view
860         returns (uint256 _timer)
861     {
862         if (stakers[_user].timeOfLastUpdate + compoundFreq <= block.timestamp) {
863             return 0;
864         } else {
865             return
866                 (stakers[_user].timeOfLastUpdate + compoundFreq) -
867                 block.timestamp;
868         }
869     }
870 
871     // Calculate the rewards since the last update on Deposit info
872     function calculateRewards(address _staker)
873         internal
874         view
875         returns (uint256 rewards)
876     {
877         return (((((block.timestamp - stakers[_staker].timeOfLastUpdate) *
878             stakers[_staker].deposited) * rewardsPerHour) / 3600) / 10000000);
879     }
880 }
881 // File: contracts/wCTMToken.sol
882 
883 
884 pragma solidity ^0.8.4;
885 
886 
887 
888 contract MyStakeableToken is ERC20Stakeable, Ownable {
889     constructor()ERC20Stakeable("Cheatmoon", "wCTM")
890     {
891         _mint(msg.sender, 500000000 * 10**decimals());
892     }
893 }