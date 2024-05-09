1 // Sources flattened with hardhat v2.14.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.9.3
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.3
31 
32 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby disabling any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 
114 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3
115 
116 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Emitted when `value` tokens are moved from one account (`from`) to
126      * another (`to`).
127      *
128      * Note that `value` may be zero.
129      */
130     event Transfer(address indexed from, address indexed to, uint256 value);
131 
132     /**
133      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134      * a call to {approve}. `value` is the new allowance.
135      */
136     event Approval(address indexed owner, address indexed spender, uint256 value);
137 
138     /**
139      * @dev Returns the amount of tokens in existence.
140      */
141     function totalSupply() external view returns (uint256);
142 
143     /**
144      * @dev Returns the amount of tokens owned by `account`.
145      */
146     function balanceOf(address account) external view returns (uint256);
147 
148     /**
149      * @dev Moves `amount` tokens from the caller's account to `to`.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transfer(address to, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165 
166     /**
167      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * IMPORTANT: Beware that changing an allowance with this method brings the risk
172      * that someone may use both the old and the new allowance by unfortunate
173      * transaction ordering. One possible solution to mitigate this race
174      * condition is to first reduce the spender's allowance to 0 and set the
175      * desired value afterwards:
176      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Moves `amount` tokens from `from` to `to` using the
184      * allowance mechanism. `amount` is then deducted from the caller's
185      * allowance.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(address from, address to, uint256 amount) external returns (bool);
192 }
193 
194 
195 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.3
196 
197 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @dev Interface for the optional metadata functions from the ERC20 standard.
203  *
204  * _Available since v4.1._
205  */
206 interface IERC20Metadata is IERC20 {
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the symbol of the token.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the decimals places of the token.
219      */
220     function decimals() external view returns (uint8);
221 }
222 
223 
224 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.3
225 
226 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 
231 
232 /**
233  * @dev Implementation of the {IERC20} interface.
234  *
235  * This implementation is agnostic to the way tokens are created. This means
236  * that a supply mechanism has to be added in a derived contract using {_mint}.
237  * For a generic mechanism see {ERC20PresetMinterPauser}.
238  *
239  * TIP: For a detailed writeup see our guide
240  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
241  * to implement supply mechanisms].
242  *
243  * The default value of {decimals} is 18. To change this, you should override
244  * this function so it returns a different value.
245  *
246  * We have followed general OpenZeppelin Contracts guidelines: functions revert
247  * instead returning `false` on failure. This behavior is nonetheless
248  * conventional and does not conflict with the expectations of ERC20
249  * applications.
250  *
251  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
252  * This allows applications to reconstruct the allowance for all accounts just
253  * by listening to said events. Other implementations of the EIP may not emit
254  * these events, as it isn't required by the specification.
255  *
256  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
257  * functions have been added to mitigate the well-known issues around setting
258  * allowances. See {IERC20-approve}.
259  */
260 contract ERC20 is Context, IERC20, IERC20Metadata {
261     mapping(address => uint256) private _balances;
262 
263     mapping(address => mapping(address => uint256)) private _allowances;
264 
265     uint256 private _totalSupply;
266 
267     string private _name;
268     string private _symbol;
269 
270     /**
271      * @dev Sets the values for {name} and {symbol}.
272      *
273      * All two of these values are immutable: they can only be set once during
274      * construction.
275      */
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the default value returned by this function, unless
303      * it's overridden.
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual override returns (uint8) {
310         return 18;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view virtual override returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `to` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address to, uint256 amount) public virtual override returns (bool) {
336         address owner = _msgSender();
337         _transfer(owner, to, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-allowance}.
343      */
344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
345         return _allowances[owner][spender];
346     }
347 
348     /**
349      * @dev See {IERC20-approve}.
350      *
351      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
352      * `transferFrom`. This is semantically equivalent to an infinite approval.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function approve(address spender, uint256 amount) public virtual override returns (bool) {
359         address owner = _msgSender();
360         _approve(owner, spender, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-transferFrom}.
366      *
367      * Emits an {Approval} event indicating the updated allowance. This is not
368      * required by the EIP. See the note at the beginning of {ERC20}.
369      *
370      * NOTE: Does not update the allowance if the current allowance
371      * is the maximum `uint256`.
372      *
373      * Requirements:
374      *
375      * - `from` and `to` cannot be the zero address.
376      * - `from` must have a balance of at least `amount`.
377      * - the caller must have allowance for ``from``'s tokens of at least
378      * `amount`.
379      */
380     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
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
401         _approve(owner, spender, allowance(owner, spender) + addedValue);
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
421         uint256 currentAllowance = allowance(owner, spender);
422         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
423         unchecked {
424             _approve(owner, spender, currentAllowance - subtractedValue);
425         }
426 
427         return true;
428     }
429 
430     /**
431      * @dev Moves `amount` of tokens from `from` to `to`.
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
444     function _transfer(address from, address to, uint256 amount) internal virtual {
445         require(from != address(0), "ERC20: transfer from the zero address");
446         require(to != address(0), "ERC20: transfer to the zero address");
447 
448         _beforeTokenTransfer(from, to, amount);
449 
450         uint256 fromBalance = _balances[from];
451         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
452         unchecked {
453             _balances[from] = fromBalance - amount;
454             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
455             // decrementing then incrementing.
456             _balances[to] += amount;
457         }
458 
459         emit Transfer(from, to, amount);
460 
461         _afterTokenTransfer(from, to, amount);
462     }
463 
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `account` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal virtual {
474         require(account != address(0), "ERC20: mint to the zero address");
475 
476         _beforeTokenTransfer(address(0), account, amount);
477 
478         _totalSupply += amount;
479         unchecked {
480             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
481             _balances[account] += amount;
482         }
483         emit Transfer(address(0), account, amount);
484 
485         _afterTokenTransfer(address(0), account, amount);
486     }
487 
488     /**
489      * @dev Destroys `amount` tokens from `account`, reducing the
490      * total supply.
491      *
492      * Emits a {Transfer} event with `to` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `account` cannot be the zero address.
497      * - `account` must have at least `amount` tokens.
498      */
499     function _burn(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: burn from the zero address");
501 
502         _beforeTokenTransfer(account, address(0), amount);
503 
504         uint256 accountBalance = _balances[account];
505         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
506         unchecked {
507             _balances[account] = accountBalance - amount;
508             // Overflow not possible: amount <= accountBalance <= totalSupply.
509             _totalSupply -= amount;
510         }
511 
512         emit Transfer(account, address(0), amount);
513 
514         _afterTokenTransfer(account, address(0), amount);
515     }
516 
517     /**
518      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
519      *
520      * This internal function is equivalent to `approve`, and can be used to
521      * e.g. set automatic allowances for certain subsystems, etc.
522      *
523      * Emits an {Approval} event.
524      *
525      * Requirements:
526      *
527      * - `owner` cannot be the zero address.
528      * - `spender` cannot be the zero address.
529      */
530     function _approve(address owner, address spender, uint256 amount) internal virtual {
531         require(owner != address(0), "ERC20: approve from the zero address");
532         require(spender != address(0), "ERC20: approve to the zero address");
533 
534         _allowances[owner][spender] = amount;
535         emit Approval(owner, spender, amount);
536     }
537 
538     /**
539      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
540      *
541      * Does not update the allowance amount in case of infinite allowance.
542      * Revert if not enough allowance is available.
543      *
544      * Might emit an {Approval} event.
545      */
546     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
547         uint256 currentAllowance = allowance(owner, spender);
548         if (currentAllowance != type(uint256).max) {
549             require(currentAllowance >= amount, "ERC20: insufficient allowance");
550             unchecked {
551                 _approve(owner, spender, currentAllowance - amount);
552             }
553         }
554     }
555 
556     /**
557      * @dev Hook that is called before any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * will be transferred to `to`.
564      * - when `from` is zero, `amount` tokens will be minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
571 
572     /**
573      * @dev Hook that is called after any transfer of tokens. This includes
574      * minting and burning.
575      *
576      * Calling conditions:
577      *
578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
579      * has been transferred to `to`.
580      * - when `from` is zero, `amount` tokens have been minted for `to`.
581      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
582      * - `from` and `to` are never both zero.
583      *
584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
585      */
586     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
587 }
588 
589 
590 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.9.3
591 
592 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
593 
594 pragma solidity ^0.8.0;
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
630 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol@v4.9.3
631 
632 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 /**
637  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
638  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
639  *
640  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
641  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
642  * need to send a transaction, and thus is not required to hold Ether at all.
643  */
644 interface IERC20Permit {
645     /**
646      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
647      * given ``owner``'s signed approval.
648      *
649      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
650      * ordering also apply here.
651      *
652      * Emits an {Approval} event.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      * - `deadline` must be a timestamp in the future.
658      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
659      * over the EIP712-formatted function arguments.
660      * - the signature must use ``owner``'s current nonce (see {nonces}).
661      *
662      * For more information on the signature format, see the
663      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
664      * section].
665      */
666     function permit(
667         address owner,
668         address spender,
669         uint256 value,
670         uint256 deadline,
671         uint8 v,
672         bytes32 r,
673         bytes32 s
674     ) external;
675 
676     /**
677      * @dev Returns the current nonce for `owner`. This value must be
678      * included whenever a signature is generated for {permit}.
679      *
680      * Every successful call to {permit} increases ``owner``'s nonce by one. This
681      * prevents a signature from being used multiple times.
682      */
683     function nonces(address owner) external view returns (uint256);
684 
685     /**
686      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
687      */
688     // solhint-disable-next-line func-name-mixedcase
689     function DOMAIN_SEPARATOR() external view returns (bytes32);
690 }
691 
692 
693 // File @openzeppelin/contracts/utils/Counters.sol@v4.9.3
694 
695 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @title Counters
701  * @author Matt Condon (@shrugs)
702  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
703  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
704  *
705  * Include with `using Counters for Counters.Counter;`
706  */
707 library Counters {
708     struct Counter {
709         // This variable should never be directly accessed by users of the library: interactions must be restricted to
710         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
711         // this feature: see https://github.com/ethereum/solidity/issues/4637
712         uint256 _value; // default: 0
713     }
714 
715     function current(Counter storage counter) internal view returns (uint256) {
716         return counter._value;
717     }
718 
719     function increment(Counter storage counter) internal {
720         unchecked {
721             counter._value += 1;
722         }
723     }
724 
725     function decrement(Counter storage counter) internal {
726         uint256 value = counter._value;
727         require(value > 0, "Counter: decrement overflow");
728         unchecked {
729             counter._value = value - 1;
730         }
731     }
732 
733     function reset(Counter storage counter) internal {
734         counter._value = 0;
735     }
736 }
737 
738 
739 // File @openzeppelin/contracts/utils/math/Math.sol@v4.9.3
740 
741 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @dev Standard math utilities missing in the Solidity language.
747  */
748 library Math {
749     enum Rounding {
750         Down, // Toward negative infinity
751         Up, // Toward infinity
752         Zero // Toward zero
753     }
754 
755     /**
756      * @dev Returns the largest of two numbers.
757      */
758     function max(uint256 a, uint256 b) internal pure returns (uint256) {
759         return a > b ? a : b;
760     }
761 
762     /**
763      * @dev Returns the smallest of two numbers.
764      */
765     function min(uint256 a, uint256 b) internal pure returns (uint256) {
766         return a < b ? a : b;
767     }
768 
769     /**
770      * @dev Returns the average of two numbers. The result is rounded towards
771      * zero.
772      */
773     function average(uint256 a, uint256 b) internal pure returns (uint256) {
774         // (a + b) / 2 can overflow.
775         return (a & b) + (a ^ b) / 2;
776     }
777 
778     /**
779      * @dev Returns the ceiling of the division of two numbers.
780      *
781      * This differs from standard division with `/` in that it rounds up instead
782      * of rounding down.
783      */
784     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
785         // (a + b - 1) / b can overflow on addition, so we distribute.
786         return a == 0 ? 0 : (a - 1) / b + 1;
787     }
788 
789     /**
790      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
791      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
792      * with further edits by Uniswap Labs also under MIT license.
793      */
794     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
795         unchecked {
796             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
797             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
798             // variables such that product = prod1 * 2^256 + prod0.
799             uint256 prod0; // Least significant 256 bits of the product
800             uint256 prod1; // Most significant 256 bits of the product
801             assembly {
802                 let mm := mulmod(x, y, not(0))
803                 prod0 := mul(x, y)
804                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
805             }
806 
807             // Handle non-overflow cases, 256 by 256 division.
808             if (prod1 == 0) {
809                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
810                 // The surrounding unchecked block does not change this fact.
811                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
812                 return prod0 / denominator;
813             }
814 
815             // Make sure the result is less than 2^256. Also prevents denominator == 0.
816             require(denominator > prod1, "Math: mulDiv overflow");
817 
818             ///////////////////////////////////////////////
819             // 512 by 256 division.
820             ///////////////////////////////////////////////
821 
822             // Make division exact by subtracting the remainder from [prod1 prod0].
823             uint256 remainder;
824             assembly {
825                 // Compute remainder using mulmod.
826                 remainder := mulmod(x, y, denominator)
827 
828                 // Subtract 256 bit number from 512 bit number.
829                 prod1 := sub(prod1, gt(remainder, prod0))
830                 prod0 := sub(prod0, remainder)
831             }
832 
833             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
834             // See https://cs.stackexchange.com/q/138556/92363.
835 
836             // Does not overflow because the denominator cannot be zero at this stage in the function.
837             uint256 twos = denominator & (~denominator + 1);
838             assembly {
839                 // Divide denominator by twos.
840                 denominator := div(denominator, twos)
841 
842                 // Divide [prod1 prod0] by twos.
843                 prod0 := div(prod0, twos)
844 
845                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
846                 twos := add(div(sub(0, twos), twos), 1)
847             }
848 
849             // Shift in bits from prod1 into prod0.
850             prod0 |= prod1 * twos;
851 
852             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
853             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
854             // four bits. That is, denominator * inv = 1 mod 2^4.
855             uint256 inverse = (3 * denominator) ^ 2;
856 
857             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
858             // in modular arithmetic, doubling the correct bits in each step.
859             inverse *= 2 - denominator * inverse; // inverse mod 2^8
860             inverse *= 2 - denominator * inverse; // inverse mod 2^16
861             inverse *= 2 - denominator * inverse; // inverse mod 2^32
862             inverse *= 2 - denominator * inverse; // inverse mod 2^64
863             inverse *= 2 - denominator * inverse; // inverse mod 2^128
864             inverse *= 2 - denominator * inverse; // inverse mod 2^256
865 
866             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
867             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
868             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
869             // is no longer required.
870             result = prod0 * inverse;
871             return result;
872         }
873     }
874 
875     /**
876      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
877      */
878     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
879         uint256 result = mulDiv(x, y, denominator);
880         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
881             result += 1;
882         }
883         return result;
884     }
885 
886     /**
887      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
888      *
889      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
890      */
891     function sqrt(uint256 a) internal pure returns (uint256) {
892         if (a == 0) {
893             return 0;
894         }
895 
896         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
897         //
898         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
899         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
900         //
901         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
902         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
903         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
904         //
905         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
906         uint256 result = 1 << (log2(a) >> 1);
907 
908         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
909         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
910         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
911         // into the expected uint128 result.
912         unchecked {
913             result = (result + a / result) >> 1;
914             result = (result + a / result) >> 1;
915             result = (result + a / result) >> 1;
916             result = (result + a / result) >> 1;
917             result = (result + a / result) >> 1;
918             result = (result + a / result) >> 1;
919             result = (result + a / result) >> 1;
920             return min(result, a / result);
921         }
922     }
923 
924     /**
925      * @notice Calculates sqrt(a), following the selected rounding direction.
926      */
927     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
928         unchecked {
929             uint256 result = sqrt(a);
930             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
931         }
932     }
933 
934     /**
935      * @dev Return the log in base 2, rounded down, of a positive value.
936      * Returns 0 if given 0.
937      */
938     function log2(uint256 value) internal pure returns (uint256) {
939         uint256 result = 0;
940         unchecked {
941             if (value >> 128 > 0) {
942                 value >>= 128;
943                 result += 128;
944             }
945             if (value >> 64 > 0) {
946                 value >>= 64;
947                 result += 64;
948             }
949             if (value >> 32 > 0) {
950                 value >>= 32;
951                 result += 32;
952             }
953             if (value >> 16 > 0) {
954                 value >>= 16;
955                 result += 16;
956             }
957             if (value >> 8 > 0) {
958                 value >>= 8;
959                 result += 8;
960             }
961             if (value >> 4 > 0) {
962                 value >>= 4;
963                 result += 4;
964             }
965             if (value >> 2 > 0) {
966                 value >>= 2;
967                 result += 2;
968             }
969             if (value >> 1 > 0) {
970                 result += 1;
971             }
972         }
973         return result;
974     }
975 
976     /**
977      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
978      * Returns 0 if given 0.
979      */
980     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
981         unchecked {
982             uint256 result = log2(value);
983             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
984         }
985     }
986 
987     /**
988      * @dev Return the log in base 10, rounded down, of a positive value.
989      * Returns 0 if given 0.
990      */
991     function log10(uint256 value) internal pure returns (uint256) {
992         uint256 result = 0;
993         unchecked {
994             if (value >= 10 ** 64) {
995                 value /= 10 ** 64;
996                 result += 64;
997             }
998             if (value >= 10 ** 32) {
999                 value /= 10 ** 32;
1000                 result += 32;
1001             }
1002             if (value >= 10 ** 16) {
1003                 value /= 10 ** 16;
1004                 result += 16;
1005             }
1006             if (value >= 10 ** 8) {
1007                 value /= 10 ** 8;
1008                 result += 8;
1009             }
1010             if (value >= 10 ** 4) {
1011                 value /= 10 ** 4;
1012                 result += 4;
1013             }
1014             if (value >= 10 ** 2) {
1015                 value /= 10 ** 2;
1016                 result += 2;
1017             }
1018             if (value >= 10 ** 1) {
1019                 result += 1;
1020             }
1021         }
1022         return result;
1023     }
1024 
1025     /**
1026      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1027      * Returns 0 if given 0.
1028      */
1029     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1030         unchecked {
1031             uint256 result = log10(value);
1032             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
1033         }
1034     }
1035 
1036     /**
1037      * @dev Return the log in base 256, rounded down, of a positive value.
1038      * Returns 0 if given 0.
1039      *
1040      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1041      */
1042     function log256(uint256 value) internal pure returns (uint256) {
1043         uint256 result = 0;
1044         unchecked {
1045             if (value >> 128 > 0) {
1046                 value >>= 128;
1047                 result += 16;
1048             }
1049             if (value >> 64 > 0) {
1050                 value >>= 64;
1051                 result += 8;
1052             }
1053             if (value >> 32 > 0) {
1054                 value >>= 32;
1055                 result += 4;
1056             }
1057             if (value >> 16 > 0) {
1058                 value >>= 16;
1059                 result += 2;
1060             }
1061             if (value >> 8 > 0) {
1062                 result += 1;
1063             }
1064         }
1065         return result;
1066     }
1067 
1068     /**
1069      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
1070      * Returns 0 if given 0.
1071      */
1072     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1073         unchecked {
1074             uint256 result = log256(value);
1075             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1076         }
1077     }
1078 }
1079 
1080 
1081 // File @openzeppelin/contracts/utils/math/SignedMath.sol@v4.9.3
1082 
1083 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 /**
1088  * @dev Standard signed math utilities missing in the Solidity language.
1089  */
1090 library SignedMath {
1091     /**
1092      * @dev Returns the largest of two signed numbers.
1093      */
1094     function max(int256 a, int256 b) internal pure returns (int256) {
1095         return a > b ? a : b;
1096     }
1097 
1098     /**
1099      * @dev Returns the smallest of two signed numbers.
1100      */
1101     function min(int256 a, int256 b) internal pure returns (int256) {
1102         return a < b ? a : b;
1103     }
1104 
1105     /**
1106      * @dev Returns the average of two signed numbers without overflow.
1107      * The result is rounded towards zero.
1108      */
1109     function average(int256 a, int256 b) internal pure returns (int256) {
1110         // Formula from the book "Hacker's Delight"
1111         int256 x = (a & b) + ((a ^ b) >> 1);
1112         return x + (int256(uint256(x) >> 255) & (a ^ b));
1113     }
1114 
1115     /**
1116      * @dev Returns the absolute unsigned value of a signed value.
1117      */
1118     function abs(int256 n) internal pure returns (uint256) {
1119         unchecked {
1120             // must be unchecked in order to support `n = type(int256).min`
1121             return uint256(n >= 0 ? n : -n);
1122         }
1123     }
1124 }
1125 
1126 
1127 // File @openzeppelin/contracts/utils/Strings.sol@v4.9.3
1128 
1129 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 
1134 /**
1135  * @dev String operations.
1136  */
1137 library Strings {
1138     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1139     uint8 private constant _ADDRESS_LENGTH = 20;
1140 
1141     /**
1142      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1143      */
1144     function toString(uint256 value) internal pure returns (string memory) {
1145         unchecked {
1146             uint256 length = Math.log10(value) + 1;
1147             string memory buffer = new string(length);
1148             uint256 ptr;
1149             /// @solidity memory-safe-assembly
1150             assembly {
1151                 ptr := add(buffer, add(32, length))
1152             }
1153             while (true) {
1154                 ptr--;
1155                 /// @solidity memory-safe-assembly
1156                 assembly {
1157                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1158                 }
1159                 value /= 10;
1160                 if (value == 0) break;
1161             }
1162             return buffer;
1163         }
1164     }
1165 
1166     /**
1167      * @dev Converts a `int256` to its ASCII `string` decimal representation.
1168      */
1169     function toString(int256 value) internal pure returns (string memory) {
1170         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
1171     }
1172 
1173     /**
1174      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1175      */
1176     function toHexString(uint256 value) internal pure returns (string memory) {
1177         unchecked {
1178             return toHexString(value, Math.log256(value) + 1);
1179         }
1180     }
1181 
1182     /**
1183      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1184      */
1185     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1186         bytes memory buffer = new bytes(2 * length + 2);
1187         buffer[0] = "0";
1188         buffer[1] = "x";
1189         for (uint256 i = 2 * length + 1; i > 1; --i) {
1190             buffer[i] = _SYMBOLS[value & 0xf];
1191             value >>= 4;
1192         }
1193         require(value == 0, "Strings: hex length insufficient");
1194         return string(buffer);
1195     }
1196 
1197     /**
1198      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1199      */
1200     function toHexString(address addr) internal pure returns (string memory) {
1201         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1202     }
1203 
1204     /**
1205      * @dev Returns true if the two strings are equal.
1206      */
1207     function equal(string memory a, string memory b) internal pure returns (bool) {
1208         return keccak256(bytes(a)) == keccak256(bytes(b));
1209     }
1210 }
1211 
1212 
1213 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.9.3
1214 
1215 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/ECDSA.sol)
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 /**
1220  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1221  *
1222  * These functions can be used to verify that a message was signed by the holder
1223  * of the private keys of a given address.
1224  */
1225 library ECDSA {
1226     enum RecoverError {
1227         NoError,
1228         InvalidSignature,
1229         InvalidSignatureLength,
1230         InvalidSignatureS,
1231         InvalidSignatureV // Deprecated in v4.8
1232     }
1233 
1234     function _throwError(RecoverError error) private pure {
1235         if (error == RecoverError.NoError) {
1236             return; // no error: do nothing
1237         } else if (error == RecoverError.InvalidSignature) {
1238             revert("ECDSA: invalid signature");
1239         } else if (error == RecoverError.InvalidSignatureLength) {
1240             revert("ECDSA: invalid signature length");
1241         } else if (error == RecoverError.InvalidSignatureS) {
1242             revert("ECDSA: invalid signature 's' value");
1243         }
1244     }
1245 
1246     /**
1247      * @dev Returns the address that signed a hashed message (`hash`) with
1248      * `signature` or error string. This address can then be used for verification purposes.
1249      *
1250      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1251      * this function rejects them by requiring the `s` value to be in the lower
1252      * half order, and the `v` value to be either 27 or 28.
1253      *
1254      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1255      * verification to be secure: it is possible to craft signatures that
1256      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1257      * this is by receiving a hash of the original message (which may otherwise
1258      * be too long), and then calling {toEthSignedMessageHash} on it.
1259      *
1260      * Documentation for signature generation:
1261      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1262      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1263      *
1264      * _Available since v4.3._
1265      */
1266     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1267         if (signature.length == 65) {
1268             bytes32 r;
1269             bytes32 s;
1270             uint8 v;
1271             // ecrecover takes the signature parameters, and the only way to get them
1272             // currently is to use assembly.
1273             /// @solidity memory-safe-assembly
1274             assembly {
1275                 r := mload(add(signature, 0x20))
1276                 s := mload(add(signature, 0x40))
1277                 v := byte(0, mload(add(signature, 0x60)))
1278             }
1279             return tryRecover(hash, v, r, s);
1280         } else {
1281             return (address(0), RecoverError.InvalidSignatureLength);
1282         }
1283     }
1284 
1285     /**
1286      * @dev Returns the address that signed a hashed message (`hash`) with
1287      * `signature`. This address can then be used for verification purposes.
1288      *
1289      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1290      * this function rejects them by requiring the `s` value to be in the lower
1291      * half order, and the `v` value to be either 27 or 28.
1292      *
1293      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1294      * verification to be secure: it is possible to craft signatures that
1295      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1296      * this is by receiving a hash of the original message (which may otherwise
1297      * be too long), and then calling {toEthSignedMessageHash} on it.
1298      */
1299     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1300         (address recovered, RecoverError error) = tryRecover(hash, signature);
1301         _throwError(error);
1302         return recovered;
1303     }
1304 
1305     /**
1306      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1307      *
1308      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1309      *
1310      * _Available since v4.3._
1311      */
1312     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
1313         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1314         uint8 v = uint8((uint256(vs) >> 255) + 27);
1315         return tryRecover(hash, v, r, s);
1316     }
1317 
1318     /**
1319      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1320      *
1321      * _Available since v4.2._
1322      */
1323     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
1324         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1325         _throwError(error);
1326         return recovered;
1327     }
1328 
1329     /**
1330      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1331      * `r` and `s` signature fields separately.
1332      *
1333      * _Available since v4.3._
1334      */
1335     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
1336         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1337         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1338         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1339         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1340         //
1341         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1342         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1343         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1344         // these malleable signatures as well.
1345         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1346             return (address(0), RecoverError.InvalidSignatureS);
1347         }
1348 
1349         // If the signature is valid (and not malleable), return the signer address
1350         address signer = ecrecover(hash, v, r, s);
1351         if (signer == address(0)) {
1352             return (address(0), RecoverError.InvalidSignature);
1353         }
1354 
1355         return (signer, RecoverError.NoError);
1356     }
1357 
1358     /**
1359      * @dev Overload of {ECDSA-recover} that receives the `v`,
1360      * `r` and `s` signature fields separately.
1361      */
1362     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1363         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1364         _throwError(error);
1365         return recovered;
1366     }
1367 
1368     /**
1369      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1370      * produces hash corresponding to the one signed with the
1371      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1372      * JSON-RPC method as part of EIP-191.
1373      *
1374      * See {recover}.
1375      */
1376     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
1377         // 32 is the length in bytes of hash,
1378         // enforced by the type signature above
1379         /// @solidity memory-safe-assembly
1380         assembly {
1381             mstore(0x00, "\x19Ethereum Signed Message:\n32")
1382             mstore(0x1c, hash)
1383             message := keccak256(0x00, 0x3c)
1384         }
1385     }
1386 
1387     /**
1388      * @dev Returns an Ethereum Signed Message, created from `s`. This
1389      * produces hash corresponding to the one signed with the
1390      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1391      * JSON-RPC method as part of EIP-191.
1392      *
1393      * See {recover}.
1394      */
1395     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1396         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1397     }
1398 
1399     /**
1400      * @dev Returns an Ethereum Signed Typed Data, created from a
1401      * `domainSeparator` and a `structHash`. This produces hash corresponding
1402      * to the one signed with the
1403      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1404      * JSON-RPC method as part of EIP-712.
1405      *
1406      * See {recover}.
1407      */
1408     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
1409         /// @solidity memory-safe-assembly
1410         assembly {
1411             let ptr := mload(0x40)
1412             mstore(ptr, "\x19\x01")
1413             mstore(add(ptr, 0x02), domainSeparator)
1414             mstore(add(ptr, 0x22), structHash)
1415             data := keccak256(ptr, 0x42)
1416         }
1417     }
1418 
1419     /**
1420      * @dev Returns an Ethereum Signed Data with intended validator, created from a
1421      * `validator` and `data` according to the version 0 of EIP-191.
1422      *
1423      * See {recover}.
1424      */
1425     function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
1426         return keccak256(abi.encodePacked("\x19\x00", validator, data));
1427     }
1428 }
1429 
1430 
1431 // File @openzeppelin/contracts/interfaces/IERC5267.sol@v4.9.3
1432 
1433 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC5267.sol)
1434 
1435 pragma solidity ^0.8.0;
1436 
1437 interface IERC5267 {
1438     /**
1439      * @dev MAY be emitted to signal that the domain could have changed.
1440      */
1441     event EIP712DomainChanged();
1442 
1443     /**
1444      * @dev returns the fields and values that describe the domain separator used by this contract for EIP-712
1445      * signature.
1446      */
1447     function eip712Domain()
1448         external
1449         view
1450         returns (
1451             bytes1 fields,
1452             string memory name,
1453             string memory version,
1454             uint256 chainId,
1455             address verifyingContract,
1456             bytes32 salt,
1457             uint256[] memory extensions
1458         );
1459 }
1460 
1461 
1462 // File @openzeppelin/contracts/utils/StorageSlot.sol@v4.9.3
1463 
1464 // OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
1465 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
1466 
1467 pragma solidity ^0.8.0;
1468 
1469 /**
1470  * @dev Library for reading and writing primitive types to specific storage slots.
1471  *
1472  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
1473  * This library helps with reading and writing to such slots without the need for inline assembly.
1474  *
1475  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
1476  *
1477  * Example usage to set ERC1967 implementation slot:
1478  * ```solidity
1479  * contract ERC1967 {
1480  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
1481  *
1482  *     function _getImplementation() internal view returns (address) {
1483  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
1484  *     }
1485  *
1486  *     function _setImplementation(address newImplementation) internal {
1487  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
1488  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
1489  *     }
1490  * }
1491  * ```
1492  *
1493  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
1494  * _Available since v4.9 for `string`, `bytes`._
1495  */
1496 library StorageSlot {
1497     struct AddressSlot {
1498         address value;
1499     }
1500 
1501     struct BooleanSlot {
1502         bool value;
1503     }
1504 
1505     struct Bytes32Slot {
1506         bytes32 value;
1507     }
1508 
1509     struct Uint256Slot {
1510         uint256 value;
1511     }
1512 
1513     struct StringSlot {
1514         string value;
1515     }
1516 
1517     struct BytesSlot {
1518         bytes value;
1519     }
1520 
1521     /**
1522      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
1523      */
1524     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
1525         /// @solidity memory-safe-assembly
1526         assembly {
1527             r.slot := slot
1528         }
1529     }
1530 
1531     /**
1532      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
1533      */
1534     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
1535         /// @solidity memory-safe-assembly
1536         assembly {
1537             r.slot := slot
1538         }
1539     }
1540 
1541     /**
1542      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
1543      */
1544     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
1545         /// @solidity memory-safe-assembly
1546         assembly {
1547             r.slot := slot
1548         }
1549     }
1550 
1551     /**
1552      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
1553      */
1554     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
1555         /// @solidity memory-safe-assembly
1556         assembly {
1557             r.slot := slot
1558         }
1559     }
1560 
1561     /**
1562      * @dev Returns an `StringSlot` with member `value` located at `slot`.
1563      */
1564     function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
1565         /// @solidity memory-safe-assembly
1566         assembly {
1567             r.slot := slot
1568         }
1569     }
1570 
1571     /**
1572      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
1573      */
1574     function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
1575         /// @solidity memory-safe-assembly
1576         assembly {
1577             r.slot := store.slot
1578         }
1579     }
1580 
1581     /**
1582      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
1583      */
1584     function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
1585         /// @solidity memory-safe-assembly
1586         assembly {
1587             r.slot := slot
1588         }
1589     }
1590 
1591     /**
1592      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
1593      */
1594     function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
1595         /// @solidity memory-safe-assembly
1596         assembly {
1597             r.slot := store.slot
1598         }
1599     }
1600 }
1601 
1602 
1603 // File @openzeppelin/contracts/utils/ShortStrings.sol@v4.9.3
1604 
1605 // OpenZeppelin Contracts (last updated v4.9.0) (utils/ShortStrings.sol)
1606 
1607 pragma solidity ^0.8.8;
1608 
1609 // | string  | 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |
1610 // | length  | 0x                                                              BB |
1611 type ShortString is bytes32;
1612 
1613 /**
1614  * @dev This library provides functions to convert short memory strings
1615  * into a `ShortString` type that can be used as an immutable variable.
1616  *
1617  * Strings of arbitrary length can be optimized using this library if
1618  * they are short enough (up to 31 bytes) by packing them with their
1619  * length (1 byte) in a single EVM word (32 bytes). Additionally, a
1620  * fallback mechanism can be used for every other case.
1621  *
1622  * Usage example:
1623  *
1624  * ```solidity
1625  * contract Named {
1626  *     using ShortStrings for *;
1627  *
1628  *     ShortString private immutable _name;
1629  *     string private _nameFallback;
1630  *
1631  *     constructor(string memory contractName) {
1632  *         _name = contractName.toShortStringWithFallback(_nameFallback);
1633  *     }
1634  *
1635  *     function name() external view returns (string memory) {
1636  *         return _name.toStringWithFallback(_nameFallback);
1637  *     }
1638  * }
1639  * ```
1640  */
1641 library ShortStrings {
1642     // Used as an identifier for strings longer than 31 bytes.
1643     bytes32 private constant _FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF;
1644 
1645     error StringTooLong(string str);
1646     error InvalidShortString();
1647 
1648     /**
1649      * @dev Encode a string of at most 31 chars into a `ShortString`.
1650      *
1651      * This will trigger a `StringTooLong` error is the input string is too long.
1652      */
1653     function toShortString(string memory str) internal pure returns (ShortString) {
1654         bytes memory bstr = bytes(str);
1655         if (bstr.length > 31) {
1656             revert StringTooLong(str);
1657         }
1658         return ShortString.wrap(bytes32(uint256(bytes32(bstr)) | bstr.length));
1659     }
1660 
1661     /**
1662      * @dev Decode a `ShortString` back to a "normal" string.
1663      */
1664     function toString(ShortString sstr) internal pure returns (string memory) {
1665         uint256 len = byteLength(sstr);
1666         // using `new string(len)` would work locally but is not memory safe.
1667         string memory str = new string(32);
1668         /// @solidity memory-safe-assembly
1669         assembly {
1670             mstore(str, len)
1671             mstore(add(str, 0x20), sstr)
1672         }
1673         return str;
1674     }
1675 
1676     /**
1677      * @dev Return the length of a `ShortString`.
1678      */
1679     function byteLength(ShortString sstr) internal pure returns (uint256) {
1680         uint256 result = uint256(ShortString.unwrap(sstr)) & 0xFF;
1681         if (result > 31) {
1682             revert InvalidShortString();
1683         }
1684         return result;
1685     }
1686 
1687     /**
1688      * @dev Encode a string into a `ShortString`, or write it to storage if it is too long.
1689      */
1690     function toShortStringWithFallback(string memory value, string storage store) internal returns (ShortString) {
1691         if (bytes(value).length < 32) {
1692             return toShortString(value);
1693         } else {
1694             StorageSlot.getStringSlot(store).value = value;
1695             return ShortString.wrap(_FALLBACK_SENTINEL);
1696         }
1697     }
1698 
1699     /**
1700      * @dev Decode a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
1701      */
1702     function toStringWithFallback(ShortString value, string storage store) internal pure returns (string memory) {
1703         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
1704             return toString(value);
1705         } else {
1706             return store;
1707         }
1708     }
1709 
1710     /**
1711      * @dev Return the length of a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
1712      *
1713      * WARNING: This will return the "byte length" of the string. This may not reflect the actual length in terms of
1714      * actual characters as the UTF-8 encoding of a single character can span over multiple bytes.
1715      */
1716     function byteLengthWithFallback(ShortString value, string storage store) internal view returns (uint256) {
1717         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
1718             return byteLength(value);
1719         } else {
1720             return bytes(store).length;
1721         }
1722     }
1723 }
1724 
1725 
1726 // File @openzeppelin/contracts/utils/cryptography/EIP712.sol@v4.9.3
1727 
1728 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/EIP712.sol)
1729 
1730 pragma solidity ^0.8.8;
1731 
1732 
1733 
1734 /**
1735  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1736  *
1737  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1738  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1739  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1740  *
1741  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1742  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1743  * ({_hashTypedDataV4}).
1744  *
1745  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1746  * the chain id to protect against replay attacks on an eventual fork of the chain.
1747  *
1748  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1749  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1750  *
1751  * NOTE: In the upgradeable version of this contract, the cached values will correspond to the address, and the domain
1752  * separator of the implementation contract. This will cause the `_domainSeparatorV4` function to always rebuild the
1753  * separator from the immutable values, which is cheaper than accessing a cached version in cold storage.
1754  *
1755  * _Available since v3.4._
1756  *
1757  * @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
1758  */
1759 abstract contract EIP712 is IERC5267 {
1760     using ShortStrings for *;
1761 
1762     bytes32 private constant _TYPE_HASH =
1763         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1764 
1765     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1766     // invalidate the cached domain separator if the chain id changes.
1767     bytes32 private immutable _cachedDomainSeparator;
1768     uint256 private immutable _cachedChainId;
1769     address private immutable _cachedThis;
1770 
1771     bytes32 private immutable _hashedName;
1772     bytes32 private immutable _hashedVersion;
1773 
1774     ShortString private immutable _name;
1775     ShortString private immutable _version;
1776     string private _nameFallback;
1777     string private _versionFallback;
1778 
1779     /**
1780      * @dev Initializes the domain separator and parameter caches.
1781      *
1782      * The meaning of `name` and `version` is specified in
1783      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1784      *
1785      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1786      * - `version`: the current major version of the signing domain.
1787      *
1788      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1789      * contract upgrade].
1790      */
1791     constructor(string memory name, string memory version) {
1792         _name = name.toShortStringWithFallback(_nameFallback);
1793         _version = version.toShortStringWithFallback(_versionFallback);
1794         _hashedName = keccak256(bytes(name));
1795         _hashedVersion = keccak256(bytes(version));
1796 
1797         _cachedChainId = block.chainid;
1798         _cachedDomainSeparator = _buildDomainSeparator();
1799         _cachedThis = address(this);
1800     }
1801 
1802     /**
1803      * @dev Returns the domain separator for the current chain.
1804      */
1805     function _domainSeparatorV4() internal view returns (bytes32) {
1806         if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
1807             return _cachedDomainSeparator;
1808         } else {
1809             return _buildDomainSeparator();
1810         }
1811     }
1812 
1813     function _buildDomainSeparator() private view returns (bytes32) {
1814         return keccak256(abi.encode(_TYPE_HASH, _hashedName, _hashedVersion, block.chainid, address(this)));
1815     }
1816 
1817     /**
1818      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1819      * function returns the hash of the fully encoded EIP712 message for this domain.
1820      *
1821      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1822      *
1823      * ```solidity
1824      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1825      *     keccak256("Mail(address to,string contents)"),
1826      *     mailTo,
1827      *     keccak256(bytes(mailContents))
1828      * )));
1829      * address signer = ECDSA.recover(digest, signature);
1830      * ```
1831      */
1832     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1833         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1834     }
1835 
1836     /**
1837      * @dev See {EIP-5267}.
1838      *
1839      * _Available since v4.9._
1840      */
1841     function eip712Domain()
1842         public
1843         view
1844         virtual
1845         override
1846         returns (
1847             bytes1 fields,
1848             string memory name,
1849             string memory version,
1850             uint256 chainId,
1851             address verifyingContract,
1852             bytes32 salt,
1853             uint256[] memory extensions
1854         )
1855     {
1856         return (
1857             hex"0f", // 01111
1858             _name.toStringWithFallback(_nameFallback),
1859             _version.toStringWithFallback(_versionFallback),
1860             block.chainid,
1861             address(this),
1862             bytes32(0),
1863             new uint256[](0)
1864         );
1865     }
1866 }
1867 
1868 
1869 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol@v4.9.3
1870 
1871 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/ERC20Permit.sol)
1872 
1873 pragma solidity ^0.8.0;
1874 
1875 
1876 
1877 
1878 
1879 /**
1880  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1881  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1882  *
1883  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1884  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1885  * need to send a transaction, and thus is not required to hold Ether at all.
1886  *
1887  * _Available since v3.4._
1888  */
1889 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1890     using Counters for Counters.Counter;
1891 
1892     mapping(address => Counters.Counter) private _nonces;
1893 
1894     // solhint-disable-next-line var-name-mixedcase
1895     bytes32 private constant _PERMIT_TYPEHASH =
1896         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1897     /**
1898      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1899      * However, to ensure consistency with the upgradeable transpiler, we will continue
1900      * to reserve a slot.
1901      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1902      */
1903     // solhint-disable-next-line var-name-mixedcase
1904     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1905 
1906     /**
1907      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1908      *
1909      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1910      */
1911     constructor(string memory name) EIP712(name, "1") {}
1912 
1913     /**
1914      * @dev See {IERC20Permit-permit}.
1915      */
1916     function permit(
1917         address owner,
1918         address spender,
1919         uint256 value,
1920         uint256 deadline,
1921         uint8 v,
1922         bytes32 r,
1923         bytes32 s
1924     ) public virtual override {
1925         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1926 
1927         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1928 
1929         bytes32 hash = _hashTypedDataV4(structHash);
1930 
1931         address signer = ECDSA.recover(hash, v, r, s);
1932         require(signer == owner, "ERC20Permit: invalid signature");
1933 
1934         _approve(owner, spender, value);
1935     }
1936 
1937     /**
1938      * @dev See {IERC20Permit-nonces}.
1939      */
1940     function nonces(address owner) public view virtual override returns (uint256) {
1941         return _nonces[owner].current();
1942     }
1943 
1944     /**
1945      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1946      */
1947     // solhint-disable-next-line func-name-mixedcase
1948     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1949         return _domainSeparatorV4();
1950     }
1951 
1952     /**
1953      * @dev "Consume a nonce": return the current value and increment.
1954      *
1955      * _Available since v4.1._
1956      */
1957     function _useNonce(address owner) internal virtual returns (uint256 current) {
1958         Counters.Counter storage nonce = _nonces[owner];
1959         current = nonce.current();
1960         nonce.increment();
1961     }
1962 }
1963 
1964 
1965 // File contracts/Tyrion.sol
1966 
1967 pragma solidity ^0.8.9;
1968 
1969 /*
1970 
1971 Website: https://tyrion.finance
1972 TG: https://t.me/tyrionfinance
1973 Twitter: https://twitter.com/tyrionfinance
1974 
1975 */
1976 
1977 
1978 
1979 
1980 
1981 interface IUniswapV2Factory {
1982     event PairCreated(
1983         address indexed token0,
1984         address indexed token1,
1985         address pair,
1986         uint256
1987     );
1988 
1989     function feeTo() external view returns (address);
1990 
1991     function feeToSetter() external view returns (address);
1992 
1993     function getPair(address tokenA, address tokenB)
1994         external
1995         view
1996         returns (address pair);
1997 
1998     function allPairs(uint256) external view returns (address pair);
1999 
2000     function allPairsLength() external view returns (uint256);
2001 
2002     function createPair(address tokenA, address tokenB)
2003         external
2004         returns (address pair);
2005 
2006     function setFeeTo(address) external;
2007 
2008     function setFeeToSetter(address) external;
2009 }
2010 
2011 interface IUniswapV2Router02 {
2012     function factory() external pure returns (address);
2013 
2014     function WETH() external pure returns (address);
2015 
2016     function swapExactTokensForETHSupportingFeeOnTransferTokens(
2017         uint256 amountIn,
2018         uint256 amountOutMin,
2019         address[] calldata path,
2020         address to,
2021         uint256 deadline
2022     ) external;
2023 
2024     function addLiquidityETH(
2025         address token,
2026         uint amountTokenDesired,
2027         uint amountTokenMin,
2028         uint amountETHMin,
2029         address to,
2030         uint deadline
2031     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
2032 }
2033 
2034 contract Tyrion is ERC20, ERC20Burnable, ERC20Permit, Ownable {
2035     uint public tax;
2036     uint256 public swapTokensAtAmount;
2037     uint256 public maxTaxSwap;
2038     uint256 public maxWalletSize;
2039     address public taxWallet;
2040     bool private swapping;
2041 
2042     IUniswapV2Router02 public immutable uniswapV2Router;
2043     address public immutable uniswapV2Pair;
2044 
2045     mapping(address => bool) public isExcludedFromFees;
2046     mapping(address => bool) public automatedMarketMakerPairs;
2047     mapping(address => bool) public blacklist;
2048     uint256 public uniswapDeployBlock;
2049     bool public isBlacklistActive;
2050 
2051     constructor()
2052         ERC20("Tyrion.finance", "TYRION")
2053         ERC20Permit("Tyrion.finance")
2054     {
2055         uniswapV2Router = IUniswapV2Router02(
2056             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D //Uniswap V2 Router
2057         );
2058         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
2059             .createPair(address(this), uniswapV2Router.WETH());
2060 
2061         setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
2062         excludeFromFees(msg.sender, true);
2063         excludeFromFees(address(this), true);
2064 
2065         _mint(msg.sender, 1000000000 * 10 ** decimals());
2066 
2067         taxWallet = msg.sender;
2068         tax = 50; // 5%
2069         swapTokensAtAmount = totalSupply() * 2 / 10000; // 0.02%
2070         maxTaxSwap = totalSupply() * 20 / 10000; // 0.2%
2071         maxWalletSize = totalSupply() * 3 / 100; // 3%
2072     }
2073 
2074     function _transfer(
2075         address from,
2076         address to,
2077         uint256 amount
2078     ) internal override {
2079         require(from != address(0), "ERC20: transfer from the zero address");
2080         require(to != address(0), "ERC20: transfer to the zero address");
2081         require(!blacklist[from], "From address is blacklisted");
2082 
2083         if (amount == 0) {
2084             super._transfer(from, to, 0);
2085             return;
2086         }
2087 
2088         if (maxWalletSize > 0 && automatedMarketMakerPairs[from]) {
2089             require(balanceOf(to) + amount <= maxWalletSize, "Recipient's wallet size exceeded");
2090         }
2091 
2092         // Blacklist buyers in first 3 blocks of Uniswap pool launch
2093         if (block.number <= uniswapDeployBlock + 3 && automatedMarketMakerPairs[from]) {
2094             blacklist[to] = true;
2095         }
2096 
2097         uint256 contractTokenBalance = balanceOf(address(this));
2098         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
2099 
2100         if (
2101             canSwap &&
2102             !swapping &&
2103             automatedMarketMakerPairs[to] &&
2104             !isExcludedFromFees[from] &&
2105             !isExcludedFromFees[to]
2106         ) {
2107             swapping = true;
2108             swapTokensForEth(Math.min(contractTokenBalance, maxTaxSwap));
2109             swapping = false;
2110         }
2111 
2112         bool takeFee = (tax > 0) && !swapping;
2113 
2114         // If any account belongs to _isExcludedFromFee account then remove the fee
2115         if (isExcludedFromFees[from] || isExcludedFromFees[to]) {
2116             takeFee = false;
2117         }
2118 
2119         uint256 fees = 0;
2120         // Only take fees on buys/sells, do not take on wallet transfers
2121         if (takeFee && (automatedMarketMakerPairs[to] || automatedMarketMakerPairs[from])) {
2122             fees = (amount * tax) / 1000;
2123         }
2124 
2125         if (fees > 0) {
2126             super._transfer(from, address(this), fees);
2127             amount -= fees;
2128         }
2129 
2130         super._transfer(from, to, amount);
2131     }
2132 
2133     function setTaxPercent(uint newTax) public onlyOwner {
2134         require(newTax <= 50, "Can't set higher tax than 5%");
2135         tax = newTax;
2136     }
2137 
2138     function setMaxWalletSize(uint256 newSize) public onlyOwner {
2139         maxWalletSize = newSize;
2140     }
2141 
2142     function setMaxTaxSwap(uint256 newMax) public onlyOwner {
2143         maxTaxSwap = newMax;
2144     }
2145 
2146     function setTaxWallet(address newWallet) public onlyOwner {
2147         taxWallet = newWallet;
2148     }
2149 
2150     function excludeFromFees(address account, bool excluded) public onlyOwner {
2151         isExcludedFromFees[account] = excluded;
2152     }
2153 
2154     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
2155         automatedMarketMakerPairs[pair] = value;
2156     }
2157 
2158     function setBlacklist(address account, bool value) public onlyOwner {
2159         require(
2160             isBlacklistActive || (!isBlacklistActive && !value),
2161             "You can no longer blacklist addresses when the blacklist is deactivated"
2162         );
2163         blacklist[account] = value;
2164     }
2165 
2166     function getBlacklist(address account) public view returns (bool) {
2167         return blacklist[account];
2168     }
2169 
2170     function deactivateBlacklist() public onlyOwner {
2171         isBlacklistActive = false;
2172     }
2173 
2174     function withdrawEth(address toAddr) public onlyOwner {
2175         (bool success, ) = toAddr.call{
2176             value: address(this).balance
2177         } ("");
2178         require(success);
2179     }
2180 
2181     function launchUniswapPool(uint256 poolTokens) external payable onlyOwner {
2182         require(poolTokens > 0, "Must provide liquidity");
2183         require(msg.value > 0, "Must provide liquidity");
2184 
2185         uniswapDeployBlock = block.number;
2186         isBlacklistActive = true;
2187 
2188         transfer(address(this), poolTokens);
2189         _approve(address(this), address(uniswapV2Router), poolTokens);
2190 
2191         uniswapV2Router.addLiquidityETH{ value: msg.value }(
2192             address(this),
2193             poolTokens,
2194             0,
2195             0,
2196             owner(),
2197             block.timestamp
2198         );
2199     }
2200 
2201     function swapTokensForEth(uint256 tokenAmount) private {
2202         // Generate the uniswap pair path of token -> weth
2203         address[] memory path = new address[](2);
2204         path[0] = address(this);
2205         path[1] = uniswapV2Router.WETH();
2206 
2207         _approve(address(this), address(uniswapV2Router), tokenAmount);
2208 
2209         // Make the swap
2210         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2211             tokenAmount,
2212             0, // Accept any amount of ETH; ignore slippage
2213             path,
2214             address(taxWallet),
2215             block.timestamp
2216         );
2217     }
2218 
2219     receive() external payable {}
2220 }