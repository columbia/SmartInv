1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/access/Ownable.sol
101 
102 
103 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     /**
126      * @dev Initializes the contract setting the deployer as the initial owner.
127      */
128     constructor() {
129         _transferOwnership(_msgSender());
130     }
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         _checkOwner();
137         _;
138     }
139 
140     /**
141      * @dev Returns the address of the current owner.
142      */
143     function owner() public view virtual returns (address) {
144         return _owner;
145     }
146 
147     /**
148      * @dev Throws if the sender is not the owner.
149      */
150     function _checkOwner() internal view virtual {
151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
152     }
153 
154     /**
155      * @dev Leaves the contract without owner. It will not be possible to call
156      * `onlyOwner` functions anymore. Can only be called by the current owner.
157      *
158      * NOTE: Renouncing ownership will leave the contract without an owner,
159      * thereby removing any functionality that is only available to the owner.
160      */
161     function renounceOwnership() public virtual onlyOwner {
162         _transferOwnership(address(0));
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Can only be called by the current owner.
168      */
169     function transferOwnership(address newOwner) public virtual onlyOwner {
170         require(newOwner != address(0), "Ownable: new owner is the zero address");
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers ownership of the contract to a new account (`newOwner`).
176      * Internal function without access restriction.
177      */
178     function _transferOwnership(address newOwner) internal virtual {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
186 
187 
188 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Interface of the ERC20 standard as defined in the EIP.
194  */
195 interface IERC20 {
196     /**
197      * @dev Emitted when `value` tokens are moved from one account (`from`) to
198      * another (`to`).
199      *
200      * Note that `value` may be zero.
201      */
202     event Transfer(address indexed from, address indexed to, uint256 value);
203 
204     /**
205      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
206      * a call to {approve}. `value` is the new allowance.
207      */
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209 
210     /**
211      * @dev Returns the amount of tokens in existence.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns the amount of tokens owned by `account`.
217      */
218     function balanceOf(address account) external view returns (uint256);
219 
220     /**
221      * @dev Moves `amount` tokens from the caller's account to `to`.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transfer(address to, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Returns the remaining number of tokens that `spender` will be
231      * allowed to spend on behalf of `owner` through {transferFrom}. This is
232      * zero by default.
233      *
234      * This value changes when {approve} or {transferFrom} are called.
235      */
236     function allowance(address owner, address spender) external view returns (uint256);
237 
238     /**
239      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * IMPORTANT: Beware that changing an allowance with this method brings the risk
244      * that someone may use both the old and the new allowance by unfortunate
245      * transaction ordering. One possible solution to mitigate this race
246      * condition is to first reduce the spender's allowance to 0 and set the
247      * desired value afterwards:
248      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address spender, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Moves `amount` tokens from `from` to `to` using the
256      * allowance mechanism. `amount` is then deducted from the caller's
257      * allowance.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a {Transfer} event.
262      */
263     function transferFrom(
264         address from,
265         address to,
266         uint256 amount
267     ) external returns (bool);
268 }
269 
270 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
271 
272 
273 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 
278 /**
279  * @dev Interface for the optional metadata functions from the ERC20 standard.
280  *
281  * _Available since v4.1._
282  */
283 interface IERC20Metadata is IERC20 {
284     /**
285      * @dev Returns the name of the token.
286      */
287     function name() external view returns (string memory);
288 
289     /**
290      * @dev Returns the symbol of the token.
291      */
292     function symbol() external view returns (string memory);
293 
294     /**
295      * @dev Returns the decimals places of the token.
296      */
297     function decimals() external view returns (uint8);
298 }
299 
300 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
301 
302 
303 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
304 
305 pragma solidity ^0.8.0;
306 
307 
308 
309 
310 /**
311  * @dev Implementation of the {IERC20} interface.
312  *
313  * This implementation is agnostic to the way tokens are created. This means
314  * that a supply mechanism has to be added in a derived contract using {_mint}.
315  * For a generic mechanism see {ERC20PresetMinterPauser}.
316  *
317  * TIP: For a detailed writeup see our guide
318  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
319  * to implement supply mechanisms].
320  *
321  * We have followed general OpenZeppelin Contracts guidelines: functions revert
322  * instead returning `false` on failure. This behavior is nonetheless
323  * conventional and does not conflict with the expectations of ERC20
324  * applications.
325  *
326  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
327  * This allows applications to reconstruct the allowance for all accounts just
328  * by listening to said events. Other implementations of the EIP may not emit
329  * these events, as it isn't required by the specification.
330  *
331  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
332  * functions have been added to mitigate the well-known issues around setting
333  * allowances. See {IERC20-approve}.
334  */
335 contract ERC20 is Context, IERC20, IERC20Metadata {
336     mapping(address => uint256) private _balances;
337 
338     mapping(address => mapping(address => uint256)) private _allowances;
339 
340     uint256 private _totalSupply;
341 
342     string private _name;
343     string private _symbol;
344 
345     /**
346      * @dev Sets the values for {name} and {symbol}.
347      *
348      * The default value of {decimals} is 18. To select a different value for
349      * {decimals} you should overload it.
350      *
351      * All two of these values are immutable: they can only be set once during
352      * construction.
353      */
354     constructor(string memory name_, string memory symbol_) {
355         _name = name_;
356         _symbol = symbol_;
357     }
358 
359     /**
360      * @dev Returns the name of the token.
361      */
362     function name() public view virtual override returns (string memory) {
363         return _name;
364     }
365 
366     /**
367      * @dev Returns the symbol of the token, usually a shorter version of the
368      * name.
369      */
370     function symbol() public view virtual override returns (string memory) {
371         return _symbol;
372     }
373 
374     /**
375      * @dev Returns the number of decimals used to get its user representation.
376      * For example, if `decimals` equals `2`, a balance of `505` tokens should
377      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
378      *
379      * Tokens usually opt for a value of 18, imitating the relationship between
380      * Ether and Wei. This is the value {ERC20} uses, unless this function is
381      * overridden;
382      *
383      * NOTE: This information is only used for _display_ purposes: it in
384      * no way affects any of the arithmetic of the contract, including
385      * {IERC20-balanceOf} and {IERC20-transfer}.
386      */
387     function decimals() public view virtual override returns (uint8) {
388         return 18;
389     }
390 
391     /**
392      * @dev See {IERC20-totalSupply}.
393      */
394     function totalSupply() public view virtual override returns (uint256) {
395         return _totalSupply;
396     }
397 
398     /**
399      * @dev See {IERC20-balanceOf}.
400      */
401     function balanceOf(address account) public view virtual override returns (uint256) {
402         return _balances[account];
403     }
404 
405     /**
406      * @dev See {IERC20-transfer}.
407      *
408      * Requirements:
409      *
410      * - `to` cannot be the zero address.
411      * - the caller must have a balance of at least `amount`.
412      */
413     function transfer(address to, uint256 amount) public virtual override returns (bool) {
414         address owner = _msgSender();
415         _transfer(owner, to, amount);
416         return true;
417     }
418 
419     /**
420      * @dev See {IERC20-allowance}.
421      */
422     function allowance(address owner, address spender) public view virtual override returns (uint256) {
423         return _allowances[owner][spender];
424     }
425 
426     /**
427      * @dev See {IERC20-approve}.
428      *
429      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
430      * `transferFrom`. This is semantically equivalent to an infinite approval.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount) public virtual override returns (bool) {
437         address owner = _msgSender();
438         _approve(owner, spender, amount);
439         return true;
440     }
441 
442     /**
443      * @dev See {IERC20-transferFrom}.
444      *
445      * Emits an {Approval} event indicating the updated allowance. This is not
446      * required by the EIP. See the note at the beginning of {ERC20}.
447      *
448      * NOTE: Does not update the allowance if the current allowance
449      * is the maximum `uint256`.
450      *
451      * Requirements:
452      *
453      * - `from` and `to` cannot be the zero address.
454      * - `from` must have a balance of at least `amount`.
455      * - the caller must have allowance for ``from``'s tokens of at least
456      * `amount`.
457      */
458     function transferFrom(
459         address from,
460         address to,
461         uint256 amount
462     ) public virtual override returns (bool) {
463         address spender = _msgSender();
464         _spendAllowance(from, spender, amount);
465         _transfer(from, to, amount);
466         return true;
467     }
468 
469     /**
470      * @dev Atomically increases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      */
481     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
482         address owner = _msgSender();
483         _approve(owner, spender, allowance(owner, spender) + addedValue);
484         return true;
485     }
486 
487     /**
488      * @dev Atomically decreases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      * - `spender` must have allowance for the caller of at least
499      * `subtractedValue`.
500      */
501     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502         address owner = _msgSender();
503         uint256 currentAllowance = allowance(owner, spender);
504         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
505         unchecked {
506             _approve(owner, spender, currentAllowance - subtractedValue);
507         }
508 
509         return true;
510     }
511 
512     /**
513      * @dev Moves `amount` of tokens from `from` to `to`.
514      *
515      * This internal function is equivalent to {transfer}, and can be used to
516      * e.g. implement automatic token fees, slashing mechanisms, etc.
517      *
518      * Emits a {Transfer} event.
519      *
520      * Requirements:
521      *
522      * - `from` cannot be the zero address.
523      * - `to` cannot be the zero address.
524      * - `from` must have a balance of at least `amount`.
525      */
526     function _transfer(
527         address from,
528         address to,
529         uint256 amount
530     ) internal virtual {
531         require(from != address(0), "ERC20: transfer from the zero address");
532         require(to != address(0), "ERC20: transfer to the zero address");
533 
534         _beforeTokenTransfer(from, to, amount);
535 
536         uint256 fromBalance = _balances[from];
537         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
538         unchecked {
539             _balances[from] = fromBalance - amount;
540             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
541             // decrementing then incrementing.
542             _balances[to] += amount;
543         }
544 
545         emit Transfer(from, to, amount);
546 
547         _afterTokenTransfer(from, to, amount);
548     }
549 
550     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
551      * the total supply.
552      *
553      * Emits a {Transfer} event with `from` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      */
559     function _mint(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: mint to the zero address");
561 
562         _beforeTokenTransfer(address(0), account, amount);
563 
564         _totalSupply += amount;
565         unchecked {
566             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
567             _balances[account] += amount;
568         }
569         emit Transfer(address(0), account, amount);
570 
571         _afterTokenTransfer(address(0), account, amount);
572     }
573 
574     /**
575      * @dev Destroys `amount` tokens from `account`, reducing the
576      * total supply.
577      *
578      * Emits a {Transfer} event with `to` set to the zero address.
579      *
580      * Requirements:
581      *
582      * - `account` cannot be the zero address.
583      * - `account` must have at least `amount` tokens.
584      */
585     function _burn(address account, uint256 amount) internal virtual {
586         require(account != address(0), "ERC20: burn from the zero address");
587 
588         _beforeTokenTransfer(account, address(0), amount);
589 
590         uint256 accountBalance = _balances[account];
591         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
592         unchecked {
593             _balances[account] = accountBalance - amount;
594             // Overflow not possible: amount <= accountBalance <= totalSupply.
595             _totalSupply -= amount;
596         }
597 
598         emit Transfer(account, address(0), amount);
599 
600         _afterTokenTransfer(account, address(0), amount);
601     }
602 
603     /**
604      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
605      *
606      * This internal function is equivalent to `approve`, and can be used to
607      * e.g. set automatic allowances for certain subsystems, etc.
608      *
609      * Emits an {Approval} event.
610      *
611      * Requirements:
612      *
613      * - `owner` cannot be the zero address.
614      * - `spender` cannot be the zero address.
615      */
616     function _approve(
617         address owner,
618         address spender,
619         uint256 amount
620     ) internal virtual {
621         require(owner != address(0), "ERC20: approve from the zero address");
622         require(spender != address(0), "ERC20: approve to the zero address");
623 
624         _allowances[owner][spender] = amount;
625         emit Approval(owner, spender, amount);
626     }
627 
628     /**
629      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
630      *
631      * Does not update the allowance amount in case of infinite allowance.
632      * Revert if not enough allowance is available.
633      *
634      * Might emit an {Approval} event.
635      */
636     function _spendAllowance(
637         address owner,
638         address spender,
639         uint256 amount
640     ) internal virtual {
641         uint256 currentAllowance = allowance(owner, spender);
642         if (currentAllowance != type(uint256).max) {
643             require(currentAllowance >= amount, "ERC20: insufficient allowance");
644             unchecked {
645                 _approve(owner, spender, currentAllowance - amount);
646             }
647         }
648     }
649 
650     /**
651      * @dev Hook that is called before any transfer of tokens. This includes
652      * minting and burning.
653      *
654      * Calling conditions:
655      *
656      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
657      * will be transferred to `to`.
658      * - when `from` is zero, `amount` tokens will be minted for `to`.
659      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
660      * - `from` and `to` are never both zero.
661      *
662      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
663      */
664     function _beforeTokenTransfer(
665         address from,
666         address to,
667         uint256 amount
668     ) internal virtual {}
669 
670     /**
671      * @dev Hook that is called after any transfer of tokens. This includes
672      * minting and burning.
673      *
674      * Calling conditions:
675      *
676      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
677      * has been transferred to `to`.
678      * - when `from` is zero, `amount` tokens have been minted for `to`.
679      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
680      * - `from` and `to` are never both zero.
681      *
682      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
683      */
684     function _afterTokenTransfer(
685         address from,
686         address to,
687         uint256 amount
688     ) internal virtual {}
689 }
690 
691 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
692 
693 
694 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
695 
696 pragma solidity ^0.8.0;
697 
698 
699 
700 /**
701  * @dev Extension of {ERC20} that allows token holders to destroy both their own
702  * tokens and those that they have an allowance for, in a way that can be
703  * recognized off-chain (via event analysis).
704  */
705 abstract contract ERC20Burnable is Context, ERC20 {
706     /**
707      * @dev Destroys `amount` tokens from the caller.
708      *
709      * See {ERC20-_burn}.
710      */
711     function burn(uint256 amount) public virtual {
712         _burn(_msgSender(), amount);
713     }
714 
715     /**
716      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
717      * allowance.
718      *
719      * See {ERC20-_burn} and {ERC20-allowance}.
720      *
721      * Requirements:
722      *
723      * - the caller must have allowance for ``accounts``'s tokens of at least
724      * `amount`.
725      */
726     function burnFrom(address account, uint256 amount) public virtual {
727         _spendAllowance(account, _msgSender(), amount);
728         _burn(account, amount);
729     }
730 }
731 
732 // File: contracts/ERC20Stakeable.sol
733 
734 
735 // Creator: andreitoma8
736 pragma solidity ^0.8.4;
737 
738 
739 
740 
741 contract ERC20Stakeable is ERC20, ERC20Burnable, ReentrancyGuard {
742     // Staker info
743     struct Staker {
744         // The deposited tokens of the Staker
745         uint256 deposited;
746         // Last time of details update for Deposit
747         uint256 timeOfLastUpdate;
748         // Calculated, but unclaimed rewards. These are calculated each time
749         // a user writes to the contract.
750         uint256 unclaimedRewards;
751     }
752 
753     // Rewards per hour. A fraction calculated as x/10.000.000 to get the percentage
754     uint256 public rewardsPerHour = 120; // 0.001%/h or 10% APR
755 
756     // Minimum amount to stake
757     uint256 public minStake = 10 * 10**decimals();
758 
759     // Compounding frequency limit in seconds
760     uint256 public compoundFreq = 14400; //4 hours
761 
762     // Mapping of address to Staker info
763     mapping(address => Staker) internal stakers;
764 
765     // Constructor function
766     constructor(string memory _name, string memory _symbol)
767         ERC20(_name, _symbol)
768     {}
769 
770     // If address has no Staker struct, initiate one. If address already was a stake,
771     // calculate the rewards and add them to unclaimedRewards, reset the last time of
772     // deposit and then add _amount to the already deposited amount.
773     // Burns the amount staked.
774     function deposit(uint256 _amount) external nonReentrant {
775         require(_amount >= minStake, "Amount smaller than minimimum deposit");
776         require(
777             balanceOf(msg.sender) >= _amount,
778             "Can't stake more than you own"
779         );
780         if (stakers[msg.sender].deposited == 0) {
781             stakers[msg.sender].deposited = _amount;
782             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
783             stakers[msg.sender].unclaimedRewards = 0;
784         } else {
785             uint256 rewards = calculateRewards(msg.sender);
786             stakers[msg.sender].unclaimedRewards += rewards;
787             stakers[msg.sender].deposited += _amount;
788             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
789         }
790         _burn(msg.sender, _amount);
791     }
792 
793     // Compound the rewards and reset the last time of update for Deposit info
794     function stakeRewards() external nonReentrant {
795         require(stakers[msg.sender].deposited > 0, "You have no deposit");
796         require(
797             compoundRewardsTimer(msg.sender) == 0,
798             "Tried to compound rewars too soon"
799         );
800         uint256 rewards = calculateRewards(msg.sender) +
801             stakers[msg.sender].unclaimedRewards;
802         stakers[msg.sender].unclaimedRewards = 0;
803         stakers[msg.sender].deposited += rewards;
804         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
805     }
806 
807     // Mints rewards for msg.sender
808     function claimRewards() external nonReentrant {
809         uint256 rewards = calculateRewards(msg.sender) +
810             stakers[msg.sender].unclaimedRewards;
811         require(rewards > 0, "You have no rewards");
812         stakers[msg.sender].unclaimedRewards = 0;
813         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
814         _mint(msg.sender, rewards);
815     }
816 
817     // Withdraw specified amount of staked tokens
818     function withdraw(uint256 _amount) external nonReentrant {
819         require(
820             stakers[msg.sender].deposited >= _amount,
821             "Can't withdraw more than you have"
822         );
823         uint256 _rewards = calculateRewards(msg.sender);
824         stakers[msg.sender].deposited -= _amount;
825         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
826         stakers[msg.sender].unclaimedRewards = _rewards;
827         _mint(msg.sender, _amount);
828     }
829 
830     // Withdraw all stake and rewards and mints them to the msg.sender
831     function withdrawAll() external nonReentrant {
832         require(stakers[msg.sender].deposited > 0, "You have no deposit");
833         uint256 _rewards = calculateRewards(msg.sender) +
834             stakers[msg.sender].unclaimedRewards;
835         uint256 _deposit = stakers[msg.sender].deposited;
836         stakers[msg.sender].deposited = 0;
837         stakers[msg.sender].timeOfLastUpdate = 0;
838         uint256 _amount = _rewards + _deposit;
839         _mint(msg.sender, _amount);
840     }
841 
842     // Function useful for fron-end that returns user stake and rewards by address
843     function getDepositInfo(address _user)
844         public
845         view
846         returns (uint256 _stake, uint256 _rewards)
847     {
848         _stake = stakers[_user].deposited;
849         _rewards =
850             calculateRewards(_user) +
851             stakers[msg.sender].unclaimedRewards;
852         return (_stake, _rewards);
853     }
854 
855     // Utility function that returns the timer for restaking rewards
856     function compoundRewardsTimer(address _user)
857         public
858         view
859         returns (uint256 _timer)
860     {
861         if (stakers[_user].timeOfLastUpdate + compoundFreq <= block.timestamp) {
862             return 0;
863         } else {
864             return
865                 (stakers[_user].timeOfLastUpdate + compoundFreq) -
866                 block.timestamp;
867         }
868     }
869 
870     // Calculate the rewards since the last update on Deposit info
871     function calculateRewards(address _staker)
872         internal
873         view
874         returns (uint256 rewards)
875     {
876         return (((((block.timestamp - stakers[_staker].timeOfLastUpdate) *
877             stakers[_staker].deposited) * rewardsPerHour) / 3600) / 10000000);
878     }
879 }
880 // File: contracts/wCTMToken.sol
881 
882 
883 pragma solidity ^0.8.4;
884 
885 
886 
887 contract CheatmoonToken is ERC20Stakeable, Ownable {
888     address public creatorAddress = 0xbe1769f3D571108cc79A9a2045BFA547E6516114;
889     constructor()ERC20Stakeable("Cheatmoon", "CTM")
890     {
891         _mint(msg.sender, 2000000000 * 10**decimals());
892     }
893     function mint(uint256 amount) external nonReentrant {
894         require(msg.sender == creatorAddress, "You are not the token creator!");
895         _mint(creatorAddress, amount);
896     }
897 }