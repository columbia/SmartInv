1 // Bringing Wall Street to crypto. For TEH people.
2 
3 // Welcome to TEH Market. 
4 
5 // Open: Mon-Fri 9-17 UTC
6 // Closed: Weekends
7 
8 // Join:
9 // https://teh.market
10 // https://t.me/tehportal_EN
11 // https://twitter.com/FukeTheDuke
12 
13 
14 // File @openzeppelin/contracts/utils/Context.sol@v4.9.1
15 
16 // SPDX-License-Identifier: MIT
17 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 
42 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.1
43 
44 
45 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 abstract contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         _checkOwner();
78         _;
79     }
80 
81     /**
82      * @dev Returns the address of the current owner.
83      */
84     function owner() public view virtual returns (address) {
85         return _owner;
86     }
87 
88     /**
89      * @dev Throws if the sender is not the owner.
90      */
91     function _checkOwner() internal view virtual {
92         require(owner() == _msgSender(), "Ownable: caller is not the owner");
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby disabling any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         _transferOwnership(address(0));
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _transferOwnership(newOwner);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Internal function without access restriction.
118      */
119     function _transferOwnership(address newOwner) internal virtual {
120         address oldOwner = _owner;
121         _owner = newOwner;
122         emit OwnershipTransferred(oldOwner, newOwner);
123     }
124 }
125 
126 
127 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.1
128 
129 
130 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Interface of the ERC20 standard as defined in the EIP.
136  */
137 interface IERC20 {
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 
152     /**
153      * @dev Returns the amount of tokens in existence.
154      */
155     function totalSupply() external view returns (uint256);
156 
157     /**
158      * @dev Returns the amount of tokens owned by `account`.
159      */
160     function balanceOf(address account) external view returns (uint256);
161 
162     /**
163      * @dev Moves `amount` tokens from the caller's account to `to`.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transfer(address to, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through {transferFrom}. This is
174      * zero by default.
175      *
176      * This value changes when {approve} or {transferFrom} are called.
177      */
178     function allowance(address owner, address spender) external view returns (uint256);
179 
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * IMPORTANT: Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Moves `amount` tokens from `from` to `to` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(address from, address to, uint256 amount) external returns (bool);
206 }
207 
208 
209 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.1
210 
211 
212 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @dev Interface for the optional metadata functions from the ERC20 standard.
218  *
219  * _Available since v4.1._
220  */
221 interface IERC20Metadata is IERC20 {
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the symbol of the token.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the decimals places of the token.
234      */
235     function decimals() external view returns (uint8);
236 }
237 
238 
239 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.1
240 
241 
242 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 
247 
248 /**
249  * @dev Implementation of the {IERC20} interface.
250  *
251  * This implementation is agnostic to the way tokens are created. This means
252  * that a supply mechanism has to be added in a derived contract using {_mint}.
253  * For a generic mechanism see {ERC20PresetMinterPauser}.
254  *
255  * TIP: For a detailed writeup see our guide
256  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
257  * to implement supply mechanisms].
258  *
259  * The default value of {decimals} is 18. To change this, you should override
260  * this function so it returns a different value.
261  *
262  * We have followed general OpenZeppelin Contracts guidelines: functions revert
263  * instead returning `false` on failure. This behavior is nonetheless
264  * conventional and does not conflict with the expectations of ERC20
265  * applications.
266  *
267  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
268  * This allows applications to reconstruct the allowance for all accounts just
269  * by listening to said events. Other implementations of the EIP may not emit
270  * these events, as it isn't required by the specification.
271  *
272  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
273  * functions have been added to mitigate the well-known issues around setting
274  * allowances. See {IERC20-approve}.
275  */
276 contract ERC20 is Context, IERC20, IERC20Metadata {
277     mapping(address => uint256) private _balances;
278 
279     mapping(address => mapping(address => uint256)) private _allowances;
280 
281     uint256 private _totalSupply;
282 
283     string private _name;
284     string private _symbol;
285 
286     /**
287      * @dev Sets the values for {name} and {symbol}.
288      *
289      * All two of these values are immutable: they can only be set once during
290      * construction.
291      */
292     constructor(string memory name_, string memory symbol_) {
293         _name = name_;
294         _symbol = symbol_;
295     }
296 
297     /**
298      * @dev Returns the name of the token.
299      */
300     function name() public view virtual override returns (string memory) {
301         return _name;
302     }
303 
304     /**
305      * @dev Returns the symbol of the token, usually a shorter version of the
306      * name.
307      */
308     function symbol() public view virtual override returns (string memory) {
309         return _symbol;
310     }
311 
312     /**
313      * @dev Returns the number of decimals used to get its user representation.
314      * For example, if `decimals` equals `2`, a balance of `505` tokens should
315      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
316      *
317      * Tokens usually opt for a value of 18, imitating the relationship between
318      * Ether and Wei. This is the default value returned by this function, unless
319      * it's overridden.
320      *
321      * NOTE: This information is only used for _display_ purposes: it in
322      * no way affects any of the arithmetic of the contract, including
323      * {IERC20-balanceOf} and {IERC20-transfer}.
324      */
325     function decimals() public view virtual override returns (uint8) {
326         return 18;
327     }
328 
329     /**
330      * @dev See {IERC20-totalSupply}.
331      */
332     function totalSupply() public view virtual override returns (uint256) {
333         return _totalSupply;
334     }
335 
336     /**
337      * @dev See {IERC20-balanceOf}.
338      */
339     function balanceOf(address account) public view virtual override returns (uint256) {
340         return _balances[account];
341     }
342 
343     /**
344      * @dev See {IERC20-transfer}.
345      *
346      * Requirements:
347      *
348      * - `to` cannot be the zero address.
349      * - the caller must have a balance of at least `amount`.
350      */
351     function transfer(address to, uint256 amount) public virtual override returns (bool) {
352         address owner = _msgSender();
353         _transfer(owner, to, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-allowance}.
359      */
360     function allowance(address owner, address spender) public view virtual override returns (uint256) {
361         return _allowances[owner][spender];
362     }
363 
364     /**
365      * @dev See {IERC20-approve}.
366      *
367      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
368      * `transferFrom`. This is semantically equivalent to an infinite approval.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      */
374     function approve(address spender, uint256 amount) public virtual override returns (bool) {
375         address owner = _msgSender();
376         _approve(owner, spender, amount);
377         return true;
378     }
379 
380     /**
381      * @dev See {IERC20-transferFrom}.
382      *
383      * Emits an {Approval} event indicating the updated allowance. This is not
384      * required by the EIP. See the note at the beginning of {ERC20}.
385      *
386      * NOTE: Does not update the allowance if the current allowance
387      * is the maximum `uint256`.
388      *
389      * Requirements:
390      *
391      * - `from` and `to` cannot be the zero address.
392      * - `from` must have a balance of at least `amount`.
393      * - the caller must have allowance for ``from``'s tokens of at least
394      * `amount`.
395      */
396     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
397         address spender = _msgSender();
398         _spendAllowance(from, spender, amount);
399         _transfer(from, to, amount);
400         return true;
401     }
402 
403     /**
404      * @dev Atomically increases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      */
415     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
416         address owner = _msgSender();
417         _approve(owner, spender, allowance(owner, spender) + addedValue);
418         return true;
419     }
420 
421     /**
422      * @dev Atomically decreases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      * - `spender` must have allowance for the caller of at least
433      * `subtractedValue`.
434      */
435     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
436         address owner = _msgSender();
437         uint256 currentAllowance = allowance(owner, spender);
438         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
439         unchecked {
440             _approve(owner, spender, currentAllowance - subtractedValue);
441         }
442 
443         return true;
444     }
445 
446     /**
447      * @dev Moves `amount` of tokens from `from` to `to`.
448      *
449      * This internal function is equivalent to {transfer}, and can be used to
450      * e.g. implement automatic token fees, slashing mechanisms, etc.
451      *
452      * Emits a {Transfer} event.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `from` must have a balance of at least `amount`.
459      */
460     function _transfer(address from, address to, uint256 amount) internal virtual {
461         require(from != address(0), "ERC20: transfer from the zero address");
462         require(to != address(0), "ERC20: transfer to the zero address");
463 
464         _beforeTokenTransfer(from, to, amount);
465 
466         uint256 fromBalance = _balances[from];
467         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
468         unchecked {
469             _balances[from] = fromBalance - amount;
470             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
471             // decrementing then incrementing.
472             _balances[to] += amount;
473         }
474 
475         emit Transfer(from, to, amount);
476 
477         _afterTokenTransfer(from, to, amount);
478     }
479 
480     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
481      * the total supply.
482      *
483      * Emits a {Transfer} event with `from` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      */
489     function _mint(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: mint to the zero address");
491 
492         _beforeTokenTransfer(address(0), account, amount);
493 
494         _totalSupply += amount;
495         unchecked {
496             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
497             _balances[account] += amount;
498         }
499         emit Transfer(address(0), account, amount);
500 
501         _afterTokenTransfer(address(0), account, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         uint256 accountBalance = _balances[account];
521         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
522         unchecked {
523             _balances[account] = accountBalance - amount;
524             // Overflow not possible: amount <= accountBalance <= totalSupply.
525             _totalSupply -= amount;
526         }
527 
528         emit Transfer(account, address(0), amount);
529 
530         _afterTokenTransfer(account, address(0), amount);
531     }
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
535      *
536      * This internal function is equivalent to `approve`, and can be used to
537      * e.g. set automatic allowances for certain subsystems, etc.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `owner` cannot be the zero address.
544      * - `spender` cannot be the zero address.
545      */
546     function _approve(address owner, address spender, uint256 amount) internal virtual {
547         require(owner != address(0), "ERC20: approve from the zero address");
548         require(spender != address(0), "ERC20: approve to the zero address");
549 
550         _allowances[owner][spender] = amount;
551         emit Approval(owner, spender, amount);
552     }
553 
554     /**
555      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
556      *
557      * Does not update the allowance amount in case of infinite allowance.
558      * Revert if not enough allowance is available.
559      *
560      * Might emit an {Approval} event.
561      */
562     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
563         uint256 currentAllowance = allowance(owner, spender);
564         if (currentAllowance != type(uint256).max) {
565             require(currentAllowance >= amount, "ERC20: insufficient allowance");
566             unchecked {
567                 _approve(owner, spender, currentAllowance - amount);
568             }
569         }
570     }
571 
572     /**
573      * @dev Hook that is called before any transfer of tokens. This includes
574      * minting and burning.
575      *
576      * Calling conditions:
577      *
578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
579      * will be transferred to `to`.
580      * - when `from` is zero, `amount` tokens will be minted for `to`.
581      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
582      * - `from` and `to` are never both zero.
583      *
584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
585      */
586     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
587 
588     /**
589      * @dev Hook that is called after any transfer of tokens. This includes
590      * minting and burning.
591      *
592      * Calling conditions:
593      *
594      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
595      * has been transferred to `to`.
596      * - when `from` is zero, `amount` tokens have been minted for `to`.
597      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
598      * - `from` and `to` are never both zero.
599      *
600      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
601      */
602     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
603 }
604 
605 
606 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol@v4.9.1
607 
608 
609 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 /**
614  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
615  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
616  *
617  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
618  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
619  * need to send a transaction, and thus is not required to hold Ether at all.
620  */
621 interface IERC20Permit {
622     /**
623      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
624      * given ``owner``'s signed approval.
625      *
626      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
627      * ordering also apply here.
628      *
629      * Emits an {Approval} event.
630      *
631      * Requirements:
632      *
633      * - `spender` cannot be the zero address.
634      * - `deadline` must be a timestamp in the future.
635      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
636      * over the EIP712-formatted function arguments.
637      * - the signature must use ``owner``'s current nonce (see {nonces}).
638      *
639      * For more information on the signature format, see the
640      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
641      * section].
642      */
643     function permit(
644         address owner,
645         address spender,
646         uint256 value,
647         uint256 deadline,
648         uint8 v,
649         bytes32 r,
650         bytes32 s
651     ) external;
652 
653     /**
654      * @dev Returns the current nonce for `owner`. This value must be
655      * included whenever a signature is generated for {permit}.
656      *
657      * Every successful call to {permit} increases ``owner``'s nonce by one. This
658      * prevents a signature from being used multiple times.
659      */
660     function nonces(address owner) external view returns (uint256);
661 
662     /**
663      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
664      */
665     // solhint-disable-next-line func-name-mixedcase
666     function DOMAIN_SEPARATOR() external view returns (bytes32);
667 }
668 
669 
670 // File @openzeppelin/contracts/utils/Address.sol@v4.9.1
671 
672 
673 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
674 
675 pragma solidity ^0.8.1;
676 
677 /**
678  * @dev Collection of functions related to the address type
679  */
680 library Address {
681     /**
682      * @dev Returns true if `account` is a contract.
683      *
684      * [IMPORTANT]
685      * ====
686      * It is unsafe to assume that an address for which this function returns
687      * false is an externally-owned account (EOA) and not a contract.
688      *
689      * Among others, `isContract` will return false for the following
690      * types of addresses:
691      *
692      *  - an externally-owned account
693      *  - a contract in construction
694      *  - an address where a contract will be created
695      *  - an address where a contract lived, but was destroyed
696      *
697      * Furthermore, `isContract` will also return true if the target contract within
698      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
699      * which only has an effect at the end of a transaction.
700      * ====
701      *
702      * [IMPORTANT]
703      * ====
704      * You shouldn't rely on `isContract` to protect against flash loan attacks!
705      *
706      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
707      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
708      * constructor.
709      * ====
710      */
711     function isContract(address account) internal view returns (bool) {
712         // This method relies on extcodesize/address.code.length, which returns 0
713         // for contracts in construction, since the code is only stored at the end
714         // of the constructor execution.
715 
716         return account.code.length > 0;
717     }
718 
719     /**
720      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
721      * `recipient`, forwarding all available gas and reverting on errors.
722      *
723      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
724      * of certain opcodes, possibly making contracts go over the 2300 gas limit
725      * imposed by `transfer`, making them unable to receive funds via
726      * `transfer`. {sendValue} removes this limitation.
727      *
728      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
729      *
730      * IMPORTANT: because control is transferred to `recipient`, care must be
731      * taken to not create reentrancy vulnerabilities. Consider using
732      * {ReentrancyGuard} or the
733      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
734      */
735     function sendValue(address payable recipient, uint256 amount) internal {
736         require(address(this).balance >= amount, "Address: insufficient balance");
737 
738         (bool success, ) = recipient.call{value: amount}("");
739         require(success, "Address: unable to send value, recipient may have reverted");
740     }
741 
742     /**
743      * @dev Performs a Solidity function call using a low level `call`. A
744      * plain `call` is an unsafe replacement for a function call: use this
745      * function instead.
746      *
747      * If `target` reverts with a revert reason, it is bubbled up by this
748      * function (like regular Solidity function calls).
749      *
750      * Returns the raw returned data. To convert to the expected return value,
751      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
752      *
753      * Requirements:
754      *
755      * - `target` must be a contract.
756      * - calling `target` with `data` must not revert.
757      *
758      * _Available since v3.1._
759      */
760     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
761         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
766      * `errorMessage` as a fallback revert reason when `target` reverts.
767      *
768      * _Available since v3.1._
769      */
770     function functionCall(
771         address target,
772         bytes memory data,
773         string memory errorMessage
774     ) internal returns (bytes memory) {
775         return functionCallWithValue(target, data, 0, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but also transferring `value` wei to `target`.
781      *
782      * Requirements:
783      *
784      * - the calling contract must have an ETH balance of at least `value`.
785      * - the called Solidity function must be `payable`.
786      *
787      * _Available since v3.1._
788      */
789     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
790         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
791     }
792 
793     /**
794      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
795      * with `errorMessage` as a fallback revert reason when `target` reverts.
796      *
797      * _Available since v3.1._
798      */
799     function functionCallWithValue(
800         address target,
801         bytes memory data,
802         uint256 value,
803         string memory errorMessage
804     ) internal returns (bytes memory) {
805         require(address(this).balance >= value, "Address: insufficient balance for call");
806         (bool success, bytes memory returndata) = target.call{value: value}(data);
807         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
812      * but performing a static call.
813      *
814      * _Available since v3.3._
815      */
816     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
817         return functionStaticCall(target, data, "Address: low-level static call failed");
818     }
819 
820     /**
821      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
822      * but performing a static call.
823      *
824      * _Available since v3.3._
825      */
826     function functionStaticCall(
827         address target,
828         bytes memory data,
829         string memory errorMessage
830     ) internal view returns (bytes memory) {
831         (bool success, bytes memory returndata) = target.staticcall(data);
832         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
833     }
834 
835     /**
836      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
837      * but performing a delegate call.
838      *
839      * _Available since v3.4._
840      */
841     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
842         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
843     }
844 
845     /**
846      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
847      * but performing a delegate call.
848      *
849      * _Available since v3.4._
850      */
851     function functionDelegateCall(
852         address target,
853         bytes memory data,
854         string memory errorMessage
855     ) internal returns (bytes memory) {
856         (bool success, bytes memory returndata) = target.delegatecall(data);
857         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
858     }
859 
860     /**
861      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
862      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
863      *
864      * _Available since v4.8._
865      */
866     function verifyCallResultFromTarget(
867         address target,
868         bool success,
869         bytes memory returndata,
870         string memory errorMessage
871     ) internal view returns (bytes memory) {
872         if (success) {
873             if (returndata.length == 0) {
874                 // only check isContract if the call was successful and the return data is empty
875                 // otherwise we already know that it was a contract
876                 require(isContract(target), "Address: call to non-contract");
877             }
878             return returndata;
879         } else {
880             _revert(returndata, errorMessage);
881         }
882     }
883 
884     /**
885      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
886      * revert reason or using the provided one.
887      *
888      * _Available since v4.3._
889      */
890     function verifyCallResult(
891         bool success,
892         bytes memory returndata,
893         string memory errorMessage
894     ) internal pure returns (bytes memory) {
895         if (success) {
896             return returndata;
897         } else {
898             _revert(returndata, errorMessage);
899         }
900     }
901 
902     function _revert(bytes memory returndata, string memory errorMessage) private pure {
903         // Look for revert reason and bubble it up if present
904         if (returndata.length > 0) {
905             // The easiest way to bubble the revert reason is using memory via assembly
906             /// @solidity memory-safe-assembly
907             assembly {
908                 let returndata_size := mload(returndata)
909                 revert(add(32, returndata), returndata_size)
910             }
911         } else {
912             revert(errorMessage);
913         }
914     }
915 }
916 
917 
918 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.9.1
919 
920 
921 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/utils/SafeERC20.sol)
922 
923 pragma solidity ^0.8.0;
924 
925 
926 
927 /**
928  * @title SafeERC20
929  * @dev Wrappers around ERC20 operations that throw on failure (when the token
930  * contract returns false). Tokens that return no value (and instead revert or
931  * throw on failure) are also supported, non-reverting calls are assumed to be
932  * successful.
933  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
934  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
935  */
936 library SafeERC20 {
937     using Address for address;
938 
939     /**
940      * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
941      * non-reverting calls are assumed to be successful.
942      */
943     function safeTransfer(IERC20 token, address to, uint256 value) internal {
944         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
945     }
946 
947     /**
948      * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
949      * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
950      */
951     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
952         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
953     }
954 
955     /**
956      * @dev Deprecated. This function has issues similar to the ones found in
957      * {IERC20-approve}, and its usage is discouraged.
958      *
959      * Whenever possible, use {safeIncreaseAllowance} and
960      * {safeDecreaseAllowance} instead.
961      */
962     function safeApprove(IERC20 token, address spender, uint256 value) internal {
963         // safeApprove should only be called when setting an initial allowance,
964         // or when resetting it to zero. To increase and decrease it, use
965         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
966         require(
967             (value == 0) || (token.allowance(address(this), spender) == 0),
968             "SafeERC20: approve from non-zero to non-zero allowance"
969         );
970         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
971     }
972 
973     /**
974      * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
975      * non-reverting calls are assumed to be successful.
976      */
977     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
978         uint256 oldAllowance = token.allowance(address(this), spender);
979         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
980     }
981 
982     /**
983      * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
984      * non-reverting calls are assumed to be successful.
985      */
986     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
987         unchecked {
988             uint256 oldAllowance = token.allowance(address(this), spender);
989             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
990             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
991         }
992     }
993 
994     /**
995      * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
996      * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
997      * 0 before setting it to a non-zero value.
998      */
999     function forceApprove(IERC20 token, address spender, uint256 value) internal {
1000         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
1001 
1002         if (!_callOptionalReturnBool(token, approvalCall)) {
1003             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
1004             _callOptionalReturn(token, approvalCall);
1005         }
1006     }
1007 
1008     /**
1009      * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
1010      * Revert on invalid signature.
1011      */
1012     function safePermit(
1013         IERC20Permit token,
1014         address owner,
1015         address spender,
1016         uint256 value,
1017         uint256 deadline,
1018         uint8 v,
1019         bytes32 r,
1020         bytes32 s
1021     ) internal {
1022         uint256 nonceBefore = token.nonces(owner);
1023         token.permit(owner, spender, value, deadline, v, r, s);
1024         uint256 nonceAfter = token.nonces(owner);
1025         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1026     }
1027 
1028     /**
1029      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1030      * on the return value: the return value is optional (but if data is returned, it must not be false).
1031      * @param token The token targeted by the call.
1032      * @param data The call data (encoded using abi.encode or one of its variants).
1033      */
1034     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1035         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1036         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1037         // the target address contains contract code and also asserts for success in the low-level call.
1038 
1039         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1040         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1041     }
1042 
1043     /**
1044      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1045      * on the return value: the return value is optional (but if data is returned, it must not be false).
1046      * @param token The token targeted by the call.
1047      * @param data The call data (encoded using abi.encode or one of its variants).
1048      *
1049      * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
1050      */
1051     function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
1052         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1053         // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
1054         // and not revert is the subcall reverts.
1055 
1056         (bool success, bytes memory returndata) = address(token).call(data);
1057         return
1058             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
1059     }
1060 }
1061 
1062 
1063 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.9.1
1064 
1065 
1066 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1067 
1068 pragma solidity ^0.8.0;
1069 
1070 /**
1071  * @dev Interface of the ERC165 standard, as defined in the
1072  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1073  *
1074  * Implementers can declare support of contract interfaces, which can then be
1075  * queried by others ({ERC165Checker}).
1076  *
1077  * For an implementation, see {ERC165}.
1078  */
1079 interface IERC165 {
1080     /**
1081      * @dev Returns true if this contract implements the interface defined by
1082      * `interfaceId`. See the corresponding
1083      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1084      * to learn more about how these ids are created.
1085      *
1086      * This function call must use less than 30 000 gas.
1087      */
1088     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1089 }
1090 
1091 
1092 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.9.1
1093 
1094 
1095 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 /**
1100  * @dev Required interface of an ERC721 compliant contract.
1101  */
1102 interface IERC721 is IERC165 {
1103     /**
1104      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1105      */
1106     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1107 
1108     /**
1109      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1110      */
1111     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1112 
1113     /**
1114      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1115      */
1116     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1117 
1118     /**
1119      * @dev Returns the number of tokens in ``owner``'s account.
1120      */
1121     function balanceOf(address owner) external view returns (uint256 balance);
1122 
1123     /**
1124      * @dev Returns the owner of the `tokenId` token.
1125      *
1126      * Requirements:
1127      *
1128      * - `tokenId` must exist.
1129      */
1130     function ownerOf(uint256 tokenId) external view returns (address owner);
1131 
1132     /**
1133      * @dev Safely transfers `tokenId` token from `from` to `to`.
1134      *
1135      * Requirements:
1136      *
1137      * - `from` cannot be the zero address.
1138      * - `to` cannot be the zero address.
1139      * - `tokenId` token must exist and be owned by `from`.
1140      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1141      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1146 
1147     /**
1148      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1149      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1150      *
1151      * Requirements:
1152      *
1153      * - `from` cannot be the zero address.
1154      * - `to` cannot be the zero address.
1155      * - `tokenId` token must exist and be owned by `from`.
1156      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1162 
1163     /**
1164      * @dev Transfers `tokenId` token from `from` to `to`.
1165      *
1166      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1167      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1168      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1169      *
1170      * Requirements:
1171      *
1172      * - `from` cannot be the zero address.
1173      * - `to` cannot be the zero address.
1174      * - `tokenId` token must be owned by `from`.
1175      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function transferFrom(address from, address to, uint256 tokenId) external;
1180 
1181     /**
1182      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1183      * The approval is cleared when the token is transferred.
1184      *
1185      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1186      *
1187      * Requirements:
1188      *
1189      * - The caller must own the token or be an approved operator.
1190      * - `tokenId` must exist.
1191      *
1192      * Emits an {Approval} event.
1193      */
1194     function approve(address to, uint256 tokenId) external;
1195 
1196     /**
1197      * @dev Approve or remove `operator` as an operator for the caller.
1198      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1199      *
1200      * Requirements:
1201      *
1202      * - The `operator` cannot be the caller.
1203      *
1204      * Emits an {ApprovalForAll} event.
1205      */
1206     function setApprovalForAll(address operator, bool approved) external;
1207 
1208     /**
1209      * @dev Returns the account approved for `tokenId` token.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      */
1215     function getApproved(uint256 tokenId) external view returns (address operator);
1216 
1217     /**
1218      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1219      *
1220      * See {setApprovalForAll}
1221      */
1222     function isApprovedForAll(address owner, address operator) external view returns (bool);
1223 }
1224 
1225 
1226 // File contracts/interfaces/IUniswapV2Router01.sol
1227 
1228 
1229 
1230 pragma solidity >=0.6.2;
1231 
1232 interface IUniswapV2Router01 {
1233     function factory() external pure returns (address);
1234 
1235     function WETH() external pure returns (address);
1236 
1237     function addLiquidity(
1238         address tokenA,
1239         address tokenB,
1240         uint amountADesired,
1241         uint amountBDesired,
1242         uint amountAMin,
1243         uint amountBMin,
1244         address to,
1245         uint deadline
1246     ) external returns (uint amountA, uint amountB, uint liquidity);
1247 
1248     function addLiquidityETH(
1249         address token,
1250         uint amountTokenDesired,
1251         uint amountTokenMin,
1252         uint amountETHMin,
1253         address to,
1254         uint deadline
1255     )
1256         external
1257         payable
1258         returns (uint amountToken, uint amountETH, uint liquidity);
1259 
1260     function removeLiquidity(
1261         address tokenA,
1262         address tokenB,
1263         uint liquidity,
1264         uint amountAMin,
1265         uint amountBMin,
1266         address to,
1267         uint deadline
1268     ) external returns (uint amountA, uint amountB);
1269 
1270     function removeLiquidityETH(
1271         address token,
1272         uint liquidity,
1273         uint amountTokenMin,
1274         uint amountETHMin,
1275         address to,
1276         uint deadline
1277     ) external returns (uint amountToken, uint amountETH);
1278 
1279     function removeLiquidityWithPermit(
1280         address tokenA,
1281         address tokenB,
1282         uint liquidity,
1283         uint amountAMin,
1284         uint amountBMin,
1285         address to,
1286         uint deadline,
1287         bool approveMax,
1288         uint8 v,
1289         bytes32 r,
1290         bytes32 s
1291     ) external returns (uint amountA, uint amountB);
1292 
1293     function removeLiquidityETHWithPermit(
1294         address token,
1295         uint liquidity,
1296         uint amountTokenMin,
1297         uint amountETHMin,
1298         address to,
1299         uint deadline,
1300         bool approveMax,
1301         uint8 v,
1302         bytes32 r,
1303         bytes32 s
1304     ) external returns (uint amountToken, uint amountETH);
1305 
1306     function swapExactTokensForTokens(
1307         uint amountIn,
1308         uint amountOutMin,
1309         address[] calldata path,
1310         address to,
1311         uint deadline
1312     ) external returns (uint[] memory amounts);
1313 
1314     function swapTokensForExactTokens(
1315         uint amountOut,
1316         uint amountInMax,
1317         address[] calldata path,
1318         address to,
1319         uint deadline
1320     ) external returns (uint[] memory amounts);
1321 
1322     function swapExactETHForTokens(
1323         uint amountOutMin,
1324         address[] calldata path,
1325         address to,
1326         uint deadline
1327     ) external payable returns (uint[] memory amounts);
1328 
1329     function swapTokensForExactETH(
1330         uint amountOut,
1331         uint amountInMax,
1332         address[] calldata path,
1333         address to,
1334         uint deadline
1335     ) external returns (uint[] memory amounts);
1336 
1337     function swapExactTokensForETH(
1338         uint amountIn,
1339         uint amountOutMin,
1340         address[] calldata path,
1341         address to,
1342         uint deadline
1343     ) external returns (uint[] memory amounts);
1344 
1345     function swapETHForExactTokens(
1346         uint amountOut,
1347         address[] calldata path,
1348         address to,
1349         uint deadline
1350     ) external payable returns (uint[] memory amounts);
1351 
1352     function quote(
1353         uint amountA,
1354         uint reserveA,
1355         uint reserveB
1356     ) external pure returns (uint amountB);
1357 
1358     function getAmountOut(
1359         uint amountIn,
1360         uint reserveIn,
1361         uint reserveOut
1362     ) external pure returns (uint amountOut);
1363 
1364     function getAmountIn(
1365         uint amountOut,
1366         uint reserveIn,
1367         uint reserveOut
1368     ) external pure returns (uint amountIn);
1369 
1370     function getAmountsOut(
1371         uint amountIn,
1372         address[] calldata path
1373     ) external view returns (uint[] memory amounts);
1374 
1375     function getAmountsIn(
1376         uint amountOut,
1377         address[] calldata path
1378     ) external view returns (uint[] memory amounts);
1379 }
1380 
1381 
1382 // File contracts/interfaces/IUniswapV2Router02.sol
1383 
1384 
1385 
1386 pragma solidity >=0.6.2;
1387 
1388 interface IUniswapV2Router02 is IUniswapV2Router01 {
1389     function removeLiquidityETHSupportingFeeOnTransferTokens(
1390         address token,
1391         uint liquidity,
1392         uint amountTokenMin,
1393         uint amountETHMin,
1394         address to,
1395         uint deadline
1396     ) external returns (uint amountETH);
1397 
1398     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1399         address token,
1400         uint liquidity,
1401         uint amountTokenMin,
1402         uint amountETHMin,
1403         address to,
1404         uint deadline,
1405         bool approveMax,
1406         uint8 v,
1407         bytes32 r,
1408         bytes32 s
1409     ) external returns (uint amountETH);
1410 
1411     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1412         uint amountIn,
1413         uint amountOutMin,
1414         address[] calldata path,
1415         address to,
1416         uint deadline
1417     ) external;
1418 
1419     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1420         uint amountOutMin,
1421         address[] calldata path,
1422         address to,
1423         uint deadline
1424     ) external payable;
1425 
1426     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1427         uint amountIn,
1428         uint amountOutMin,
1429         address[] calldata path,
1430         address to,
1431         uint deadline
1432     ) external;
1433 }
1434 
1435 
1436 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.9.1
1437 
1438 
1439 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
1440 
1441 pragma solidity ^0.8.0;
1442 
1443 /**
1444  * @dev Contract module that helps prevent reentrant calls to a function.
1445  *
1446  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1447  * available, which can be applied to functions to make sure there are no nested
1448  * (reentrant) calls to them.
1449  *
1450  * Note that because there is a single `nonReentrant` guard, functions marked as
1451  * `nonReentrant` may not call one another. This can be worked around by making
1452  * those functions `private`, and then adding `external` `nonReentrant` entry
1453  * points to them.
1454  *
1455  * TIP: If you would like to learn more about reentrancy and alternative ways
1456  * to protect against it, check out our blog post
1457  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1458  */
1459 abstract contract ReentrancyGuard {
1460     // Booleans are more expensive than uint256 or any type that takes up a full
1461     // word because each write operation emits an extra SLOAD to first read the
1462     // slot's contents, replace the bits taken up by the boolean, and then write
1463     // back. This is the compiler's defense against contract upgrades and
1464     // pointer aliasing, and it cannot be disabled.
1465 
1466     // The values being non-zero value makes deployment a bit more expensive,
1467     // but in exchange the refund on every call to nonReentrant will be lower in
1468     // amount. Since refunds are capped to a percentage of the total
1469     // transaction's gas, it is best to keep them low in cases like this one, to
1470     // increase the likelihood of the full refund coming into effect.
1471     uint256 private constant _NOT_ENTERED = 1;
1472     uint256 private constant _ENTERED = 2;
1473 
1474     uint256 private _status;
1475 
1476     constructor() {
1477         _status = _NOT_ENTERED;
1478     }
1479 
1480     /**
1481      * @dev Prevents a contract from calling itself, directly or indirectly.
1482      * Calling a `nonReentrant` function from another `nonReentrant`
1483      * function is not supported. It is possible to prevent this from happening
1484      * by making the `nonReentrant` function external, and making it call a
1485      * `private` function that does the actual work.
1486      */
1487     modifier nonReentrant() {
1488         _nonReentrantBefore();
1489         _;
1490         _nonReentrantAfter();
1491     }
1492 
1493     function _nonReentrantBefore() private {
1494         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1495         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1496 
1497         // Any calls to nonReentrant after this point will fail
1498         _status = _ENTERED;
1499     }
1500 
1501     function _nonReentrantAfter() private {
1502         // By storing the original value once again, a refund is triggered (see
1503         // https://eips.ethereum.org/EIPS/eip-2200)
1504         _status = _NOT_ENTERED;
1505     }
1506 
1507     /**
1508      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
1509      * `nonReentrant` function in the call stack.
1510      */
1511     function _reentrancyGuardEntered() internal view returns (bool) {
1512         return _status == _ENTERED;
1513     }
1514 }
1515 
1516 
1517 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.9.1
1518 
1519 
1520 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
1521 
1522 pragma solidity ^0.8.0;
1523 
1524 // CAUTION
1525 // This version of SafeMath should only be used with Solidity 0.8 or later,
1526 // because it relies on the compiler's built in overflow checks.
1527 
1528 /**
1529  * @dev Wrappers over Solidity's arithmetic operations.
1530  *
1531  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1532  * now has built in overflow checking.
1533  */
1534 library SafeMath {
1535     /**
1536      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1537      *
1538      * _Available since v3.4._
1539      */
1540     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1541         unchecked {
1542             uint256 c = a + b;
1543             if (c < a) return (false, 0);
1544             return (true, c);
1545         }
1546     }
1547 
1548     /**
1549      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1550      *
1551      * _Available since v3.4._
1552      */
1553     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1554         unchecked {
1555             if (b > a) return (false, 0);
1556             return (true, a - b);
1557         }
1558     }
1559 
1560     /**
1561      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1562      *
1563      * _Available since v3.4._
1564      */
1565     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1566         unchecked {
1567             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1568             // benefit is lost if 'b' is also tested.
1569             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1570             if (a == 0) return (true, 0);
1571             uint256 c = a * b;
1572             if (c / a != b) return (false, 0);
1573             return (true, c);
1574         }
1575     }
1576 
1577     /**
1578      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1579      *
1580      * _Available since v3.4._
1581      */
1582     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1583         unchecked {
1584             if (b == 0) return (false, 0);
1585             return (true, a / b);
1586         }
1587     }
1588 
1589     /**
1590      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1591      *
1592      * _Available since v3.4._
1593      */
1594     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1595         unchecked {
1596             if (b == 0) return (false, 0);
1597             return (true, a % b);
1598         }
1599     }
1600 
1601     /**
1602      * @dev Returns the addition of two unsigned integers, reverting on
1603      * overflow.
1604      *
1605      * Counterpart to Solidity's `+` operator.
1606      *
1607      * Requirements:
1608      *
1609      * - Addition cannot overflow.
1610      */
1611     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1612         return a + b;
1613     }
1614 
1615     /**
1616      * @dev Returns the subtraction of two unsigned integers, reverting on
1617      * overflow (when the result is negative).
1618      *
1619      * Counterpart to Solidity's `-` operator.
1620      *
1621      * Requirements:
1622      *
1623      * - Subtraction cannot overflow.
1624      */
1625     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1626         return a - b;
1627     }
1628 
1629     /**
1630      * @dev Returns the multiplication of two unsigned integers, reverting on
1631      * overflow.
1632      *
1633      * Counterpart to Solidity's `*` operator.
1634      *
1635      * Requirements:
1636      *
1637      * - Multiplication cannot overflow.
1638      */
1639     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1640         return a * b;
1641     }
1642 
1643     /**
1644      * @dev Returns the integer division of two unsigned integers, reverting on
1645      * division by zero. The result is rounded towards zero.
1646      *
1647      * Counterpart to Solidity's `/` operator.
1648      *
1649      * Requirements:
1650      *
1651      * - The divisor cannot be zero.
1652      */
1653     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1654         return a / b;
1655     }
1656 
1657     /**
1658      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1659      * reverting when dividing by zero.
1660      *
1661      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1662      * opcode (which leaves remaining gas untouched) while Solidity uses an
1663      * invalid opcode to revert (consuming all remaining gas).
1664      *
1665      * Requirements:
1666      *
1667      * - The divisor cannot be zero.
1668      */
1669     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1670         return a % b;
1671     }
1672 
1673     /**
1674      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1675      * overflow (when the result is negative).
1676      *
1677      * CAUTION: This function is deprecated because it requires allocating memory for the error
1678      * message unnecessarily. For custom revert reasons use {trySub}.
1679      *
1680      * Counterpart to Solidity's `-` operator.
1681      *
1682      * Requirements:
1683      *
1684      * - Subtraction cannot overflow.
1685      */
1686     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1687         unchecked {
1688             require(b <= a, errorMessage);
1689             return a - b;
1690         }
1691     }
1692 
1693     /**
1694      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1695      * division by zero. The result is rounded towards zero.
1696      *
1697      * Counterpart to Solidity's `/` operator. Note: this function uses a
1698      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1699      * uses an invalid opcode to revert (consuming all remaining gas).
1700      *
1701      * Requirements:
1702      *
1703      * - The divisor cannot be zero.
1704      */
1705     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1706         unchecked {
1707             require(b > 0, errorMessage);
1708             return a / b;
1709         }
1710     }
1711 
1712     /**
1713      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1714      * reverting with custom message when dividing by zero.
1715      *
1716      * CAUTION: This function is deprecated because it requires allocating memory for the error
1717      * message unnecessarily. For custom revert reasons use {tryMod}.
1718      *
1719      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1720      * opcode (which leaves remaining gas untouched) while Solidity uses an
1721      * invalid opcode to revert (consuming all remaining gas).
1722      *
1723      * Requirements:
1724      *
1725      * - The divisor cannot be zero.
1726      */
1727     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1728         unchecked {
1729             require(b > 0, errorMessage);
1730             return a % b;
1731         }
1732     }
1733 }
1734 
1735 
1736 // File contracts/interfaces/IUniswapV2Factory.sol
1737 
1738 
1739 
1740 pragma solidity >=0.5.0;
1741 
1742 interface IUniswapV2Factory {
1743     event PairCreated(
1744         address indexed token0,
1745         address indexed token1,
1746         address pair,
1747         uint
1748     );
1749 
1750     function feeTo() external view returns (address);
1751 
1752     function feeToSetter() external view returns (address);
1753 
1754     function getPair(
1755         address tokenA,
1756         address tokenB
1757     ) external view returns (address pair);
1758 
1759     function allPairs(uint) external view returns (address pair);
1760 
1761     function allPairsLength() external view returns (uint);
1762 
1763     function createPair(
1764         address tokenA,
1765         address tokenB
1766     ) external returns (address pair);
1767 
1768     function setFeeTo(address) external;
1769 
1770     function setFeeToSetter(address) external;
1771 }
1772 
1773 
1774 // File contracts/interfaces/IUniswapV2Pair.sol
1775 
1776 
1777 
1778 pragma solidity >=0.5.0;
1779 
1780 interface IUniswapV2Pair {
1781     event Approval(address indexed owner, address indexed spender, uint value);
1782     event Transfer(address indexed from, address indexed to, uint value);
1783 
1784     function name() external pure returns (string memory);
1785 
1786     function symbol() external pure returns (string memory);
1787 
1788     function decimals() external pure returns (uint8);
1789 
1790     function totalSupply() external view returns (uint);
1791 
1792     function balanceOf(address owner) external view returns (uint);
1793 
1794     function allowance(
1795         address owner,
1796         address spender
1797     ) external view returns (uint);
1798 
1799     function approve(address spender, uint value) external returns (bool);
1800 
1801     function transfer(address to, uint value) external returns (bool);
1802 
1803     function transferFrom(
1804         address from,
1805         address to,
1806         uint value
1807     ) external returns (bool);
1808 
1809     function DOMAIN_SEPARATOR() external view returns (bytes32);
1810 
1811     function PERMIT_TYPEHASH() external pure returns (bytes32);
1812 
1813     function nonces(address owner) external view returns (uint);
1814 
1815     function permit(
1816         address owner,
1817         address spender,
1818         uint value,
1819         uint deadline,
1820         uint8 v,
1821         bytes32 r,
1822         bytes32 s
1823     ) external;
1824 
1825     event Mint(address indexed sender, uint amount0, uint amount1);
1826     event Burn(
1827         address indexed sender,
1828         uint amount0,
1829         uint amount1,
1830         address indexed to
1831     );
1832     event Swap(
1833         address indexed sender,
1834         uint amount0In,
1835         uint amount1In,
1836         uint amount0Out,
1837         uint amount1Out,
1838         address indexed to
1839     );
1840     event Sync(uint112 reserve0, uint112 reserve1);
1841 
1842     function MINIMUM_LIQUIDITY() external pure returns (uint);
1843 
1844     function factory() external view returns (address);
1845 
1846     function token0() external view returns (address);
1847 
1848     function token1() external view returns (address);
1849 
1850     function getReserves()
1851         external
1852         view
1853         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1854 
1855     function price0CumulativeLast() external view returns (uint);
1856 
1857     function price1CumulativeLast() external view returns (uint);
1858 
1859     function kLast() external view returns (uint);
1860 
1861     function mint(address to) external returns (uint liquidity);
1862 
1863     function burn(address to) external returns (uint amount0, uint amount1);
1864 
1865     function swap(
1866         uint amount0Out,
1867         uint amount1Out,
1868         address to,
1869         bytes calldata data
1870     ) external;
1871 
1872     function skim(address to) external;
1873 
1874     function sync() external;
1875 
1876     function initialize(address, address) external;
1877 }
1878 
1879 
1880 // File contracts/TEH.sol
1881 
1882 
1883 pragma solidity ^0.8.0;
1884 
1885 contract TEH is Context, Ownable, ERC20, ReentrancyGuard {
1886     using SafeMath for uint256;
1887     using Address for address;
1888     using SafeERC20 for IERC20;
1889 
1890     address public adminAddress;
1891 
1892     mapping(address => bool) public blacklists;
1893     mapping(address => bool) private _isExcludedFromFee;
1894     mapping(address => bool) private _isExcludedFromMaxWalletAmount;
1895 
1896     IUniswapV2Router02 public uniswapV2Router;
1897     IERC721 public nft;
1898     address public uniswapV2PairAddress;
1899 
1900     uint256 public txFee = 3;
1901     uint256 public buyTxFee = 3;
1902     uint256 public sellTxFee = 3;
1903 
1904     address public txFeeAddress;
1905 
1906     uint256 public swapFeeTokensAtAmount = 4625000 * 10 ** decimals();
1907     uint256 public maxWalletAmount = 13875000 * 10 ** decimals();
1908     uint256 public maxTxAmount = 9250000 * 10 ** decimals();
1909 
1910     bool public escapeTradingRestriction = false;
1911     bool public tradingOpen = false;
1912     bool public feeOnTrades = true;
1913 
1914     // Error Codes
1915     error BlacklistedAddress(address from, address to);
1916     error InvalidNFTAddress(address _address);
1917     error TradingNotOpen();
1918     error AdminOnly();
1919     error ZeroAddressNotAllowed();
1920     error InvalidTxFees(uint256 _txFee, uint256 _buyTxFee, uint256 _sellTxFee);
1921     error InvalidMaxWalletAmount(uint256 _maxWalletAmount);
1922     error InvalidMaxTxAmount(uint256 _maxTxAmount);
1923 
1924     // Events
1925     event TradingOpen(bool tradingOpen);
1926     event Blacklist(address _address, bool _blacklist);
1927     event ExcludeFromFee(address _address, bool _exclude);
1928     event ExcludeFromMaxWalletAmount(address _address, bool _exclude);
1929     event SetTxFees(uint256 _txFee, uint256 _buyTxFee, uint256 _sellTxFee);
1930     event SetTxFeeAddr(address _txFeeAddr);
1931     event SetNftAddr(address _nftAddr);
1932     event SetEscapeTradingRestriction(bool _escapeTradingRestriction);
1933     event SetRouterAndPairAddress(
1934         IUniswapV2Router02 _uniswapV2Router,
1935         address _uniswapV2PairAddress
1936     );
1937     event SetSwapFeeTokensAtAmount(uint256 _swapFeeTokensAtAmount);
1938     event SetAdminAddress(address _adminAddress);
1939     event SetFeeOnTrades(bool _feeOnTrades);
1940     event SetMaxWalletAmount(uint256 _maxWalletAmount);
1941     event SetMaxTxAmount(uint256 _maxTxAmount);
1942     event Withdraw(address _tokenAddress);
1943 
1944     constructor(
1945         IUniswapV2Router02 _uniswapV2Router,
1946         address _admin
1947     ) ERC20("TEH Market", "TEH") {
1948         txFeeAddress = owner();
1949         adminAddress = _admin;
1950 
1951         uniswapV2Router = _uniswapV2Router;
1952 
1953         _isExcludedFromFee[owner()] = true;
1954         _isExcludedFromFee[address(this)] = true;
1955 
1956         _isExcludedFromMaxWalletAmount[owner()] = true;
1957         _isExcludedFromMaxWalletAmount[address(this)] = true;
1958 
1959         _mint(_msgSender(), 925000000 * 10 ** decimals()); // 925,000,000 TEH
1960     }
1961 
1962     receive() external payable {}
1963 
1964     modifier tradingPeriod(address from, address to) {
1965         if (
1966             from == owner() &&
1967             uniswapV2PairAddress == address(0) &&
1968             Address.isContract(to)
1969         ) {
1970             if (IUniswapV2Pair(to).totalSupply() == 0) {
1971                 uniswapV2PairAddress = to;
1972                 _isExcludedFromMaxWalletAmount[to] = true;
1973 
1974                 _;
1975                 return;
1976             }
1977         }
1978 
1979         if (escapeTradingRestriction) {
1980             _;
1981             return;
1982         }
1983 
1984         if (to == uniswapV2PairAddress || from == uniswapV2PairAddress) {
1985             if (!tradingOpen) {
1986                 revert TradingNotOpen();
1987             }
1988         }
1989         _;
1990     }
1991 
1992     modifier onlyAdmin() {
1993         if (_msgSender() == adminAddress || _msgSender() == owner()) {
1994             _;
1995             return;
1996         }
1997 
1998         revert AdminOnly();
1999     }
2000 
2001     function setTradingOpen(bool _tradingOpen) external onlyAdmin {
2002         tradingOpen = _tradingOpen;
2003 
2004         emit TradingOpen(_tradingOpen);
2005     }
2006 
2007     function blacklist(address _address, bool _blacklist) external onlyOwner {
2008         blacklists[_address] = _blacklist;
2009 
2010         emit Blacklist(_address, _blacklist);
2011     }
2012 
2013     function excludeFromFee(
2014         address _address,
2015         bool _exclude
2016     ) external onlyOwner {
2017         _isExcludedFromFee[_address] = _exclude;
2018 
2019         emit ExcludeFromFee(_address, _exclude);
2020     }
2021 
2022     function excludeFromMaxWalletAmount(
2023         address _address,
2024         bool _exclude
2025     ) external onlyOwner {
2026         _isExcludedFromMaxWalletAmount[_address] = _exclude;
2027 
2028         emit ExcludeFromMaxWalletAmount(_address, _exclude);
2029     }
2030 
2031     function setTxFees(
2032         uint256 _txFee,
2033         uint256 _buyTxFee,
2034         uint256 _sellTxFee
2035     ) external onlyOwner {
2036         if (_txFee > 100 || _buyTxFee > 100 || _sellTxFee > 100) {
2037             revert InvalidTxFees(_txFee, _buyTxFee, _sellTxFee);
2038         }
2039 
2040         txFee = _txFee;
2041         buyTxFee = _buyTxFee;
2042         sellTxFee = _sellTxFee;
2043 
2044         emit SetTxFees(_txFee, _buyTxFee, _sellTxFee);
2045     }
2046 
2047     function setTxFeeAddr(address _txFeeAddr) external onlyOwner {
2048         _isExcludedFromFee[_txFeeAddr] = true;
2049         _isExcludedFromMaxWalletAmount[_txFeeAddr] = true;
2050 
2051         txFeeAddress = _txFeeAddr;
2052 
2053         emit SetTxFeeAddr(_txFeeAddr);
2054     }
2055 
2056     function setNftAddr(address _nftAddr) external onlyOwner {
2057         if (IERC721(_nftAddr).supportsInterface(0x80ac58cd) != true) {
2058             revert InvalidNFTAddress(_nftAddr);
2059         }
2060 
2061         nft = IERC721(_nftAddr);
2062 
2063         emit SetNftAddr(_nftAddr);
2064     }
2065 
2066     function setEscapeTradingRestriction(
2067         bool _escapeTradingRestriction
2068     ) external onlyOwner {
2069         escapeTradingRestriction = _escapeTradingRestriction;
2070 
2071         emit SetEscapeTradingRestriction(_escapeTradingRestriction);
2072     }
2073 
2074     function setRouterAndPairAddress(
2075         IUniswapV2Router02 _uniswapV2Router,
2076         address _uniswapV2PairAddress
2077     ) external onlyOwner {
2078         uniswapV2Router = _uniswapV2Router;
2079         uniswapV2PairAddress = _uniswapV2PairAddress;
2080 
2081         _isExcludedFromMaxWalletAmount[_uniswapV2PairAddress] = true;
2082 
2083         emit SetRouterAndPairAddress(_uniswapV2Router, _uniswapV2PairAddress);
2084     }
2085 
2086     function setSwapFeeTokensAtAmount(
2087         uint256 _swapFeeTokensAtAmount
2088     ) external onlyOwner {
2089         swapFeeTokensAtAmount = _swapFeeTokensAtAmount;
2090 
2091         emit SetSwapFeeTokensAtAmount(_swapFeeTokensAtAmount);
2092     }
2093 
2094     function setAdminAddress(address _adminAddress) external onlyOwner {
2095         if (_adminAddress == address(0)) {
2096             revert ZeroAddressNotAllowed();
2097         }
2098 
2099         adminAddress = _adminAddress;
2100 
2101         emit SetAdminAddress(_adminAddress);
2102     }
2103 
2104     function setFeeOnTrades(bool _feeOnTrades) external onlyOwner {
2105         feeOnTrades = _feeOnTrades;
2106 
2107         emit SetFeeOnTrades(_feeOnTrades);
2108     }
2109 
2110     function setMaxWalletAmount(uint256 _maxWalletAmount) external onlyOwner {
2111         maxWalletAmount = _maxWalletAmount;
2112 
2113         emit SetMaxWalletAmount(_maxWalletAmount);
2114     }
2115 
2116     function setMaxTxAmount(uint256 _maxTxAmount) external onlyOwner {
2117         maxTxAmount = _maxTxAmount;
2118 
2119         emit SetMaxTxAmount(_maxTxAmount);
2120     }
2121 
2122     function _transfer(
2123         address from,
2124         address to,
2125         uint256 amount
2126     ) internal virtual override tradingPeriod(from, to) {
2127         if (blacklists[to] || blacklists[from]) {
2128             revert BlacklistedAddress(from, to);
2129         }
2130 
2131         if (!_isExcludedFromMaxWalletAmount[to]) {
2132             if (amount > maxTxAmount) {
2133                 revert InvalidMaxTxAmount(amount);
2134             }
2135 
2136             if (balanceOf(to).add(amount) > maxWalletAmount) {
2137                 revert InvalidMaxWalletAmount(amount);
2138             }
2139         }
2140 
2141         bool isSell = to == uniswapV2PairAddress;
2142         bool isBuy = from == uniswapV2PairAddress;
2143 
2144         bool isIgnoredAddress = _isExcludedFromFee[from] ||
2145             _isExcludedFromFee[to];
2146 
2147         if (!isIgnoredAddress && address(nft) != address(0)) {
2148             if (nft.balanceOf(from) > 0 || nft.balanceOf(to) > 0) {
2149                 isIgnoredAddress = true;
2150             }
2151         }
2152 
2153         uint256 feeAmount = 0;
2154         uint256 _txFee = _getTxFee(isBuy, isSell);
2155 
2156         if (!isIgnoredAddress) {
2157             feeAmount = amount.mul(_txFee).div(100);
2158             super._transfer(from, address(this), feeAmount);
2159 
2160             bool isTrading = tradingOpen || escapeTradingRestriction;
2161 
2162             if (
2163                 !isBuy &&
2164                 isTrading &&
2165                 balanceOf(address(this)) >= swapFeeTokensAtAmount
2166             ) {
2167                 _takeFeeAndSwap(balanceOf(address(this)));
2168             }
2169         }
2170 
2171         super._transfer(from, to, amount.sub(feeAmount));
2172     }
2173 
2174     function _getTxFee(
2175         bool isBuy,
2176         bool isSell
2177     ) internal view returns (uint256) {
2178         uint256 _txFee = 0;
2179 
2180         if (isBuy && feeOnTrades) {
2181             _txFee = buyTxFee;
2182         } else if (isSell && feeOnTrades) {
2183             _txFee = sellTxFee;
2184         } else if (!isBuy && !isSell) {
2185             _txFee = txFee;
2186         }
2187 
2188         return _txFee;
2189     }
2190 
2191     function _takeFeeAndSwap(uint256 feeAmount) internal virtual nonReentrant {
2192         _swapTokensForEth(feeAmount);
2193     }
2194 
2195     function _swapTokensForEth(uint256 tokenAmount) internal virtual {
2196         address[] memory path = new address[](2);
2197         path[0] = address(this);
2198         path[1] = uniswapV2Router.WETH();
2199 
2200         _approve(address(this), address(uniswapV2Router), tokenAmount);
2201 
2202         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2203             tokenAmount,
2204             0,
2205             path,
2206             txFeeAddress,
2207             block.timestamp
2208         );
2209     }
2210 
2211     function withdraw(address _tokenAddress) external onlyOwner returns (bool) {
2212         if (_tokenAddress == address(0)) {
2213             payable(owner()).transfer(address(this).balance);
2214 
2215             emit Withdraw(_tokenAddress);
2216 
2217             return true;
2218         }
2219 
2220         uint256 balance = IERC20(_tokenAddress).balanceOf(address(this));
2221         IERC20(_tokenAddress).safeTransfer(owner(), balance);
2222 
2223         emit Withdraw(_tokenAddress);
2224 
2225         return true;
2226     }
2227 }