1 // Sources flattened with hardhat v2.13.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.2
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.2
117 
118 
119 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev Interface of the ERC20 standard as defined in the EIP.
125  */
126 interface IERC20 {
127     /**
128      * @dev Emitted when `value` tokens are moved from one account (`from`) to
129      * another (`to`).
130      *
131      * Note that `value` may be zero.
132      */
133     event Transfer(address indexed from, address indexed to, uint256 value);
134 
135     /**
136      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
137      * a call to {approve}. `value` is the new allowance.
138      */
139     event Approval(address indexed owner, address indexed spender, uint256 value);
140 
141     /**
142      * @dev Returns the amount of tokens in existence.
143      */
144     function totalSupply() external view returns (uint256);
145 
146     /**
147      * @dev Returns the amount of tokens owned by `account`.
148      */
149     function balanceOf(address account) external view returns (uint256);
150 
151     /**
152      * @dev Moves `amount` tokens from the caller's account to `to`.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transfer(address to, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Returns the remaining number of tokens that `spender` will be
162      * allowed to spend on behalf of `owner` through {transferFrom}. This is
163      * zero by default.
164      *
165      * This value changes when {approve} or {transferFrom} are called.
166      */
167     function allowance(address owner, address spender) external view returns (uint256);
168 
169     /**
170      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * IMPORTANT: Beware that changing an allowance with this method brings the risk
175      * that someone may use both the old and the new allowance by unfortunate
176      * transaction ordering. One possible solution to mitigate this race
177      * condition is to first reduce the spender's allowance to 0 and set the
178      * desired value afterwards:
179      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180      *
181      * Emits an {Approval} event.
182      */
183     function approve(address spender, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Moves `amount` tokens from `from` to `to` using the
187      * allowance mechanism. `amount` is then deducted from the caller's
188      * allowance.
189      *
190      * Returns a boolean value indicating whether the operation succeeded.
191      *
192      * Emits a {Transfer} event.
193      */
194     function transferFrom(
195         address from,
196         address to,
197         uint256 amount
198     ) external returns (bool);
199 }
200 
201 
202 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.2
203 
204 
205 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
206 
207 pragma solidity ^0.8.0;
208 
209 /**
210  * @dev Interface for the optional metadata functions from the ERC20 standard.
211  *
212  * _Available since v4.1._
213  */
214 interface IERC20Metadata is IERC20 {
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the symbol of the token.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the decimals places of the token.
227      */
228     function decimals() external view returns (uint8);
229 }
230 
231 
232 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.2
233 
234 
235 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 
241 /**
242  * @dev Implementation of the {IERC20} interface.
243  *
244  * This implementation is agnostic to the way tokens are created. This means
245  * that a supply mechanism has to be added in a derived contract using {_mint}.
246  * For a generic mechanism see {ERC20PresetMinterPauser}.
247  *
248  * TIP: For a detailed writeup see our guide
249  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
250  * to implement supply mechanisms].
251  *
252  * We have followed general OpenZeppelin Contracts guidelines: functions revert
253  * instead returning `false` on failure. This behavior is nonetheless
254  * conventional and does not conflict with the expectations of ERC20
255  * applications.
256  *
257  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
258  * This allows applications to reconstruct the allowance for all accounts just
259  * by listening to said events. Other implementations of the EIP may not emit
260  * these events, as it isn't required by the specification.
261  *
262  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
263  * functions have been added to mitigate the well-known issues around setting
264  * allowances. See {IERC20-approve}.
265  */
266 contract ERC20 is Context, IERC20, IERC20Metadata {
267     mapping(address => uint256) private _balances;
268 
269     mapping(address => mapping(address => uint256)) private _allowances;
270 
271     uint256 private _totalSupply;
272 
273     string private _name;
274     string private _symbol;
275 
276     /**
277      * @dev Sets the values for {name} and {symbol}.
278      *
279      * The default value of {decimals} is 18. To select a different value for
280      * {decimals} you should overload it.
281      *
282      * All two of these values are immutable: they can only be set once during
283      * construction.
284      */
285     constructor(string memory name_, string memory symbol_) {
286         _name = name_;
287         _symbol = symbol_;
288     }
289 
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view virtual override returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view virtual override returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei. This is the value {ERC20} uses, unless this function is
312      * overridden;
313      *
314      * NOTE: This information is only used for _display_ purposes: it in
315      * no way affects any of the arithmetic of the contract, including
316      * {IERC20-balanceOf} and {IERC20-transfer}.
317      */
318     function decimals() public view virtual override returns (uint8) {
319         return 18;
320     }
321 
322     /**
323      * @dev See {IERC20-totalSupply}.
324      */
325     function totalSupply() public view virtual override returns (uint256) {
326         return _totalSupply;
327     }
328 
329     /**
330      * @dev See {IERC20-balanceOf}.
331      */
332     function balanceOf(address account) public view virtual override returns (uint256) {
333         return _balances[account];
334     }
335 
336     /**
337      * @dev See {IERC20-transfer}.
338      *
339      * Requirements:
340      *
341      * - `to` cannot be the zero address.
342      * - the caller must have a balance of at least `amount`.
343      */
344     function transfer(address to, uint256 amount) public virtual override returns (bool) {
345         address owner = _msgSender();
346         _transfer(owner, to, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(address owner, address spender) public view virtual override returns (uint256) {
354         return _allowances[owner][spender];
355     }
356 
357     /**
358      * @dev See {IERC20-approve}.
359      *
360      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
361      * `transferFrom`. This is semantically equivalent to an infinite approval.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function approve(address spender, uint256 amount) public virtual override returns (bool) {
368         address owner = _msgSender();
369         _approve(owner, spender, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-transferFrom}.
375      *
376      * Emits an {Approval} event indicating the updated allowance. This is not
377      * required by the EIP. See the note at the beginning of {ERC20}.
378      *
379      * NOTE: Does not update the allowance if the current allowance
380      * is the maximum `uint256`.
381      *
382      * Requirements:
383      *
384      * - `from` and `to` cannot be the zero address.
385      * - `from` must have a balance of at least `amount`.
386      * - the caller must have allowance for ``from``'s tokens of at least
387      * `amount`.
388      */
389     function transferFrom(
390         address from,
391         address to,
392         uint256 amount
393     ) public virtual override returns (bool) {
394         address spender = _msgSender();
395         _spendAllowance(from, spender, amount);
396         _transfer(from, to, amount);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically increases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      */
412     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
413         address owner = _msgSender();
414         _approve(owner, spender, allowance(owner, spender) + addedValue);
415         return true;
416     }
417 
418     /**
419      * @dev Atomically decreases the allowance granted to `spender` by the caller.
420      *
421      * This is an alternative to {approve} that can be used as a mitigation for
422      * problems described in {IERC20-approve}.
423      *
424      * Emits an {Approval} event indicating the updated allowance.
425      *
426      * Requirements:
427      *
428      * - `spender` cannot be the zero address.
429      * - `spender` must have allowance for the caller of at least
430      * `subtractedValue`.
431      */
432     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
433         address owner = _msgSender();
434         uint256 currentAllowance = allowance(owner, spender);
435         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
436         unchecked {
437             _approve(owner, spender, currentAllowance - subtractedValue);
438         }
439 
440         return true;
441     }
442 
443     /**
444      * @dev Moves `amount` of tokens from `from` to `to`.
445      *
446      * This internal function is equivalent to {transfer}, and can be used to
447      * e.g. implement automatic token fees, slashing mechanisms, etc.
448      *
449      * Emits a {Transfer} event.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `from` must have a balance of at least `amount`.
456      */
457     function _transfer(
458         address from,
459         address to,
460         uint256 amount
461     ) internal virtual {
462         require(from != address(0), "ERC20: transfer from the zero address");
463         require(to != address(0), "ERC20: transfer to the zero address");
464 
465         _beforeTokenTransfer(from, to, amount);
466 
467         uint256 fromBalance = _balances[from];
468         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
469         unchecked {
470             _balances[from] = fromBalance - amount;
471             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
472             // decrementing then incrementing.
473             _balances[to] += amount;
474         }
475 
476         emit Transfer(from, to, amount);
477 
478         _afterTokenTransfer(from, to, amount);
479     }
480 
481     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
482      * the total supply.
483      *
484      * Emits a {Transfer} event with `from` set to the zero address.
485      *
486      * Requirements:
487      *
488      * - `account` cannot be the zero address.
489      */
490     function _mint(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: mint to the zero address");
492 
493         _beforeTokenTransfer(address(0), account, amount);
494 
495         _totalSupply += amount;
496         unchecked {
497             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
498             _balances[account] += amount;
499         }
500         emit Transfer(address(0), account, amount);
501 
502         _afterTokenTransfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _beforeTokenTransfer(account, address(0), amount);
520 
521         uint256 accountBalance = _balances[account];
522         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
523         unchecked {
524             _balances[account] = accountBalance - amount;
525             // Overflow not possible: amount <= accountBalance <= totalSupply.
526             _totalSupply -= amount;
527         }
528 
529         emit Transfer(account, address(0), amount);
530 
531         _afterTokenTransfer(account, address(0), amount);
532     }
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
536      *
537      * This internal function is equivalent to `approve`, and can be used to
538      * e.g. set automatic allowances for certain subsystems, etc.
539      *
540      * Emits an {Approval} event.
541      *
542      * Requirements:
543      *
544      * - `owner` cannot be the zero address.
545      * - `spender` cannot be the zero address.
546      */
547     function _approve(
548         address owner,
549         address spender,
550         uint256 amount
551     ) internal virtual {
552         require(owner != address(0), "ERC20: approve from the zero address");
553         require(spender != address(0), "ERC20: approve to the zero address");
554 
555         _allowances[owner][spender] = amount;
556         emit Approval(owner, spender, amount);
557     }
558 
559     /**
560      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
561      *
562      * Does not update the allowance amount in case of infinite allowance.
563      * Revert if not enough allowance is available.
564      *
565      * Might emit an {Approval} event.
566      */
567     function _spendAllowance(
568         address owner,
569         address spender,
570         uint256 amount
571     ) internal virtual {
572         uint256 currentAllowance = allowance(owner, spender);
573         if (currentAllowance != type(uint256).max) {
574             require(currentAllowance >= amount, "ERC20: insufficient allowance");
575             unchecked {
576                 _approve(owner, spender, currentAllowance - amount);
577             }
578         }
579     }
580 
581     /**
582      * @dev Hook that is called before any transfer of tokens. This includes
583      * minting and burning.
584      *
585      * Calling conditions:
586      *
587      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
588      * will be transferred to `to`.
589      * - when `from` is zero, `amount` tokens will be minted for `to`.
590      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
591      * - `from` and `to` are never both zero.
592      *
593      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
594      */
595     function _beforeTokenTransfer(
596         address from,
597         address to,
598         uint256 amount
599     ) internal virtual {}
600 
601     /**
602      * @dev Hook that is called after any transfer of tokens. This includes
603      * minting and burning.
604      *
605      * Calling conditions:
606      *
607      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608      * has been transferred to `to`.
609      * - when `from` is zero, `amount` tokens have been minted for `to`.
610      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
611      * - `from` and `to` are never both zero.
612      *
613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614      */
615     function _afterTokenTransfer(
616         address from,
617         address to,
618         uint256 amount
619     ) internal virtual {}
620 }
621 
622 
623 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.8.2
624 
625 
626 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 /**
631  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
632  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
633  *
634  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
635  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
636  * need to send a transaction, and thus is not required to hold Ether at all.
637  */
638 interface IERC20Permit {
639     /**
640      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
641      * given ``owner``'s signed approval.
642      *
643      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
644      * ordering also apply here.
645      *
646      * Emits an {Approval} event.
647      *
648      * Requirements:
649      *
650      * - `spender` cannot be the zero address.
651      * - `deadline` must be a timestamp in the future.
652      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
653      * over the EIP712-formatted function arguments.
654      * - the signature must use ``owner``'s current nonce (see {nonces}).
655      *
656      * For more information on the signature format, see the
657      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
658      * section].
659      */
660     function permit(
661         address owner,
662         address spender,
663         uint256 value,
664         uint256 deadline,
665         uint8 v,
666         bytes32 r,
667         bytes32 s
668     ) external;
669 
670     /**
671      * @dev Returns the current nonce for `owner`. This value must be
672      * included whenever a signature is generated for {permit}.
673      *
674      * Every successful call to {permit} increases ``owner``'s nonce by one. This
675      * prevents a signature from being used multiple times.
676      */
677     function nonces(address owner) external view returns (uint256);
678 
679     /**
680      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
681      */
682     // solhint-disable-next-line func-name-mixedcase
683     function DOMAIN_SEPARATOR() external view returns (bytes32);
684 }
685 
686 
687 // File @openzeppelin/contracts/utils/Address.sol@v4.8.2
688 
689 
690 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
691 
692 pragma solidity ^0.8.1;
693 
694 /**
695  * @dev Collection of functions related to the address type
696  */
697 library Address {
698     /**
699      * @dev Returns true if `account` is a contract.
700      *
701      * [IMPORTANT]
702      * ====
703      * It is unsafe to assume that an address for which this function returns
704      * false is an externally-owned account (EOA) and not a contract.
705      *
706      * Among others, `isContract` will return false for the following
707      * types of addresses:
708      *
709      *  - an externally-owned account
710      *  - a contract in construction
711      *  - an address where a contract will be created
712      *  - an address where a contract lived, but was destroyed
713      * ====
714      *
715      * [IMPORTANT]
716      * ====
717      * You shouldn't rely on `isContract` to protect against flash loan attacks!
718      *
719      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
720      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
721      * constructor.
722      * ====
723      */
724     function isContract(address account) internal view returns (bool) {
725         // This method relies on extcodesize/address.code.length, which returns 0
726         // for contracts in construction, since the code is only stored at the end
727         // of the constructor execution.
728 
729         return account.code.length > 0;
730     }
731 
732     /**
733      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
734      * `recipient`, forwarding all available gas and reverting on errors.
735      *
736      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
737      * of certain opcodes, possibly making contracts go over the 2300 gas limit
738      * imposed by `transfer`, making them unable to receive funds via
739      * `transfer`. {sendValue} removes this limitation.
740      *
741      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
742      *
743      * IMPORTANT: because control is transferred to `recipient`, care must be
744      * taken to not create reentrancy vulnerabilities. Consider using
745      * {ReentrancyGuard} or the
746      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
747      */
748     function sendValue(address payable recipient, uint256 amount) internal {
749         require(address(this).balance >= amount, "Address: insufficient balance");
750 
751         (bool success, ) = recipient.call{value: amount}("");
752         require(success, "Address: unable to send value, recipient may have reverted");
753     }
754 
755     /**
756      * @dev Performs a Solidity function call using a low level `call`. A
757      * plain `call` is an unsafe replacement for a function call: use this
758      * function instead.
759      *
760      * If `target` reverts with a revert reason, it is bubbled up by this
761      * function (like regular Solidity function calls).
762      *
763      * Returns the raw returned data. To convert to the expected return value,
764      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
765      *
766      * Requirements:
767      *
768      * - `target` must be a contract.
769      * - calling `target` with `data` must not revert.
770      *
771      * _Available since v3.1._
772      */
773     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
774         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
779      * `errorMessage` as a fallback revert reason when `target` reverts.
780      *
781      * _Available since v3.1._
782      */
783     function functionCall(
784         address target,
785         bytes memory data,
786         string memory errorMessage
787     ) internal returns (bytes memory) {
788         return functionCallWithValue(target, data, 0, errorMessage);
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
793      * but also transferring `value` wei to `target`.
794      *
795      * Requirements:
796      *
797      * - the calling contract must have an ETH balance of at least `value`.
798      * - the called Solidity function must be `payable`.
799      *
800      * _Available since v3.1._
801      */
802     function functionCallWithValue(
803         address target,
804         bytes memory data,
805         uint256 value
806     ) internal returns (bytes memory) {
807         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
812      * with `errorMessage` as a fallback revert reason when `target` reverts.
813      *
814      * _Available since v3.1._
815      */
816     function functionCallWithValue(
817         address target,
818         bytes memory data,
819         uint256 value,
820         string memory errorMessage
821     ) internal returns (bytes memory) {
822         require(address(this).balance >= value, "Address: insufficient balance for call");
823         (bool success, bytes memory returndata) = target.call{value: value}(data);
824         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
825     }
826 
827     /**
828      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
829      * but performing a static call.
830      *
831      * _Available since v3.3._
832      */
833     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
834         return functionStaticCall(target, data, "Address: low-level static call failed");
835     }
836 
837     /**
838      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
839      * but performing a static call.
840      *
841      * _Available since v3.3._
842      */
843     function functionStaticCall(
844         address target,
845         bytes memory data,
846         string memory errorMessage
847     ) internal view returns (bytes memory) {
848         (bool success, bytes memory returndata) = target.staticcall(data);
849         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
850     }
851 
852     /**
853      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
854      * but performing a delegate call.
855      *
856      * _Available since v3.4._
857      */
858     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
859         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
860     }
861 
862     /**
863      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
864      * but performing a delegate call.
865      *
866      * _Available since v3.4._
867      */
868     function functionDelegateCall(
869         address target,
870         bytes memory data,
871         string memory errorMessage
872     ) internal returns (bytes memory) {
873         (bool success, bytes memory returndata) = target.delegatecall(data);
874         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
875     }
876 
877     /**
878      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
879      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
880      *
881      * _Available since v4.8._
882      */
883     function verifyCallResultFromTarget(
884         address target,
885         bool success,
886         bytes memory returndata,
887         string memory errorMessage
888     ) internal view returns (bytes memory) {
889         if (success) {
890             if (returndata.length == 0) {
891                 // only check isContract if the call was successful and the return data is empty
892                 // otherwise we already know that it was a contract
893                 require(isContract(target), "Address: call to non-contract");
894             }
895             return returndata;
896         } else {
897             _revert(returndata, errorMessage);
898         }
899     }
900 
901     /**
902      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
903      * revert reason or using the provided one.
904      *
905      * _Available since v4.3._
906      */
907     function verifyCallResult(
908         bool success,
909         bytes memory returndata,
910         string memory errorMessage
911     ) internal pure returns (bytes memory) {
912         if (success) {
913             return returndata;
914         } else {
915             _revert(returndata, errorMessage);
916         }
917     }
918 
919     function _revert(bytes memory returndata, string memory errorMessage) private pure {
920         // Look for revert reason and bubble it up if present
921         if (returndata.length > 0) {
922             // The easiest way to bubble the revert reason is using memory via assembly
923             /// @solidity memory-safe-assembly
924             assembly {
925                 let returndata_size := mload(returndata)
926                 revert(add(32, returndata), returndata_size)
927             }
928         } else {
929             revert(errorMessage);
930         }
931     }
932 }
933 
934 
935 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.8.2
936 
937 
938 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 
943 
944 /**
945  * @title SafeERC20
946  * @dev Wrappers around ERC20 operations that throw on failure (when the token
947  * contract returns false). Tokens that return no value (and instead revert or
948  * throw on failure) are also supported, non-reverting calls are assumed to be
949  * successful.
950  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
951  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
952  */
953 library SafeERC20 {
954     using Address for address;
955 
956     function safeTransfer(
957         IERC20 token,
958         address to,
959         uint256 value
960     ) internal {
961         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
962     }
963 
964     function safeTransferFrom(
965         IERC20 token,
966         address from,
967         address to,
968         uint256 value
969     ) internal {
970         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
971     }
972 
973     /**
974      * @dev Deprecated. This function has issues similar to the ones found in
975      * {IERC20-approve}, and its usage is discouraged.
976      *
977      * Whenever possible, use {safeIncreaseAllowance} and
978      * {safeDecreaseAllowance} instead.
979      */
980     function safeApprove(
981         IERC20 token,
982         address spender,
983         uint256 value
984     ) internal {
985         // safeApprove should only be called when setting an initial allowance,
986         // or when resetting it to zero. To increase and decrease it, use
987         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
988         require(
989             (value == 0) || (token.allowance(address(this), spender) == 0),
990             "SafeERC20: approve from non-zero to non-zero allowance"
991         );
992         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
993     }
994 
995     function safeIncreaseAllowance(
996         IERC20 token,
997         address spender,
998         uint256 value
999     ) internal {
1000         uint256 newAllowance = token.allowance(address(this), spender) + value;
1001         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1002     }
1003 
1004     function safeDecreaseAllowance(
1005         IERC20 token,
1006         address spender,
1007         uint256 value
1008     ) internal {
1009         unchecked {
1010             uint256 oldAllowance = token.allowance(address(this), spender);
1011             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1012             uint256 newAllowance = oldAllowance - value;
1013             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1014         }
1015     }
1016 
1017     function safePermit(
1018         IERC20Permit token,
1019         address owner,
1020         address spender,
1021         uint256 value,
1022         uint256 deadline,
1023         uint8 v,
1024         bytes32 r,
1025         bytes32 s
1026     ) internal {
1027         uint256 nonceBefore = token.nonces(owner);
1028         token.permit(owner, spender, value, deadline, v, r, s);
1029         uint256 nonceAfter = token.nonces(owner);
1030         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1031     }
1032 
1033     /**
1034      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1035      * on the return value: the return value is optional (but if data is returned, it must not be false).
1036      * @param token The token targeted by the call.
1037      * @param data The call data (encoded using abi.encode or one of its variants).
1038      */
1039     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1040         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1041         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1042         // the target address contains contract code and also asserts for success in the low-level call.
1043 
1044         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1045         if (returndata.length > 0) {
1046             // Return data is optional
1047             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1048         }
1049     }
1050 }
1051 
1052 
1053 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.2
1054 
1055 
1056 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 /**
1061  * @dev Contract module that helps prevent reentrant calls to a function.
1062  *
1063  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1064  * available, which can be applied to functions to make sure there are no nested
1065  * (reentrant) calls to them.
1066  *
1067  * Note that because there is a single `nonReentrant` guard, functions marked as
1068  * `nonReentrant` may not call one another. This can be worked around by making
1069  * those functions `private`, and then adding `external` `nonReentrant` entry
1070  * points to them.
1071  *
1072  * TIP: If you would like to learn more about reentrancy and alternative ways
1073  * to protect against it, check out our blog post
1074  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1075  */
1076 abstract contract ReentrancyGuard {
1077     // Booleans are more expensive than uint256 or any type that takes up a full
1078     // word because each write operation emits an extra SLOAD to first read the
1079     // slot's contents, replace the bits taken up by the boolean, and then write
1080     // back. This is the compiler's defense against contract upgrades and
1081     // pointer aliasing, and it cannot be disabled.
1082 
1083     // The values being non-zero value makes deployment a bit more expensive,
1084     // but in exchange the refund on every call to nonReentrant will be lower in
1085     // amount. Since refunds are capped to a percentage of the total
1086     // transaction's gas, it is best to keep them low in cases like this one, to
1087     // increase the likelihood of the full refund coming into effect.
1088     uint256 private constant _NOT_ENTERED = 1;
1089     uint256 private constant _ENTERED = 2;
1090 
1091     uint256 private _status;
1092 
1093     constructor() {
1094         _status = _NOT_ENTERED;
1095     }
1096 
1097     /**
1098      * @dev Prevents a contract from calling itself, directly or indirectly.
1099      * Calling a `nonReentrant` function from another `nonReentrant`
1100      * function is not supported. It is possible to prevent this from happening
1101      * by making the `nonReentrant` function external, and making it call a
1102      * `private` function that does the actual work.
1103      */
1104     modifier nonReentrant() {
1105         _nonReentrantBefore();
1106         _;
1107         _nonReentrantAfter();
1108     }
1109 
1110     function _nonReentrantBefore() private {
1111         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1112         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1113 
1114         // Any calls to nonReentrant after this point will fail
1115         _status = _ENTERED;
1116     }
1117 
1118     function _nonReentrantAfter() private {
1119         // By storing the original value once again, a refund is triggered (see
1120         // https://eips.ethereum.org/EIPS/eip-2200)
1121         _status = _NOT_ENTERED;
1122     }
1123 }
1124 
1125 
1126 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.8.2
1127 
1128 
1129 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
1130 
1131 pragma solidity ^0.8.0;
1132 
1133 // CAUTION
1134 // This version of SafeMath should only be used with Solidity 0.8 or later,
1135 // because it relies on the compiler's built in overflow checks.
1136 
1137 /**
1138  * @dev Wrappers over Solidity's arithmetic operations.
1139  *
1140  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1141  * now has built in overflow checking.
1142  */
1143 library SafeMath {
1144     /**
1145      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1146      *
1147      * _Available since v3.4._
1148      */
1149     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1150         unchecked {
1151             uint256 c = a + b;
1152             if (c < a) return (false, 0);
1153             return (true, c);
1154         }
1155     }
1156 
1157     /**
1158      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
1159      *
1160      * _Available since v3.4._
1161      */
1162     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1163         unchecked {
1164             if (b > a) return (false, 0);
1165             return (true, a - b);
1166         }
1167     }
1168 
1169     /**
1170      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1171      *
1172      * _Available since v3.4._
1173      */
1174     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1175         unchecked {
1176             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1177             // benefit is lost if 'b' is also tested.
1178             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1179             if (a == 0) return (true, 0);
1180             uint256 c = a * b;
1181             if (c / a != b) return (false, 0);
1182             return (true, c);
1183         }
1184     }
1185 
1186     /**
1187      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1188      *
1189      * _Available since v3.4._
1190      */
1191     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1192         unchecked {
1193             if (b == 0) return (false, 0);
1194             return (true, a / b);
1195         }
1196     }
1197 
1198     /**
1199      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1200      *
1201      * _Available since v3.4._
1202      */
1203     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1204         unchecked {
1205             if (b == 0) return (false, 0);
1206             return (true, a % b);
1207         }
1208     }
1209 
1210     /**
1211      * @dev Returns the addition of two unsigned integers, reverting on
1212      * overflow.
1213      *
1214      * Counterpart to Solidity's `+` operator.
1215      *
1216      * Requirements:
1217      *
1218      * - Addition cannot overflow.
1219      */
1220     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1221         return a + b;
1222     }
1223 
1224     /**
1225      * @dev Returns the subtraction of two unsigned integers, reverting on
1226      * overflow (when the result is negative).
1227      *
1228      * Counterpart to Solidity's `-` operator.
1229      *
1230      * Requirements:
1231      *
1232      * - Subtraction cannot overflow.
1233      */
1234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1235         return a - b;
1236     }
1237 
1238     /**
1239      * @dev Returns the multiplication of two unsigned integers, reverting on
1240      * overflow.
1241      *
1242      * Counterpart to Solidity's `*` operator.
1243      *
1244      * Requirements:
1245      *
1246      * - Multiplication cannot overflow.
1247      */
1248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1249         return a * b;
1250     }
1251 
1252     /**
1253      * @dev Returns the integer division of two unsigned integers, reverting on
1254      * division by zero. The result is rounded towards zero.
1255      *
1256      * Counterpart to Solidity's `/` operator.
1257      *
1258      * Requirements:
1259      *
1260      * - The divisor cannot be zero.
1261      */
1262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1263         return a / b;
1264     }
1265 
1266     /**
1267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1268      * reverting when dividing by zero.
1269      *
1270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1271      * opcode (which leaves remaining gas untouched) while Solidity uses an
1272      * invalid opcode to revert (consuming all remaining gas).
1273      *
1274      * Requirements:
1275      *
1276      * - The divisor cannot be zero.
1277      */
1278     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1279         return a % b;
1280     }
1281 
1282     /**
1283      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1284      * overflow (when the result is negative).
1285      *
1286      * CAUTION: This function is deprecated because it requires allocating memory for the error
1287      * message unnecessarily. For custom revert reasons use {trySub}.
1288      *
1289      * Counterpart to Solidity's `-` operator.
1290      *
1291      * Requirements:
1292      *
1293      * - Subtraction cannot overflow.
1294      */
1295     function sub(
1296         uint256 a,
1297         uint256 b,
1298         string memory errorMessage
1299     ) internal pure returns (uint256) {
1300         unchecked {
1301             require(b <= a, errorMessage);
1302             return a - b;
1303         }
1304     }
1305 
1306     /**
1307      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1308      * division by zero. The result is rounded towards zero.
1309      *
1310      * Counterpart to Solidity's `/` operator. Note: this function uses a
1311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1312      * uses an invalid opcode to revert (consuming all remaining gas).
1313      *
1314      * Requirements:
1315      *
1316      * - The divisor cannot be zero.
1317      */
1318     function div(
1319         uint256 a,
1320         uint256 b,
1321         string memory errorMessage
1322     ) internal pure returns (uint256) {
1323         unchecked {
1324             require(b > 0, errorMessage);
1325             return a / b;
1326         }
1327     }
1328 
1329     /**
1330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1331      * reverting with custom message when dividing by zero.
1332      *
1333      * CAUTION: This function is deprecated because it requires allocating memory for the error
1334      * message unnecessarily. For custom revert reasons use {tryMod}.
1335      *
1336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1337      * opcode (which leaves remaining gas untouched) while Solidity uses an
1338      * invalid opcode to revert (consuming all remaining gas).
1339      *
1340      * Requirements:
1341      *
1342      * - The divisor cannot be zero.
1343      */
1344     function mod(
1345         uint256 a,
1346         uint256 b,
1347         string memory errorMessage
1348     ) internal pure returns (uint256) {
1349         unchecked {
1350             require(b > 0, errorMessage);
1351             return a % b;
1352         }
1353     }
1354 }
1355 
1356 
1357 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.8.2
1358 
1359 
1360 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
1361 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
1362 
1363 pragma solidity ^0.8.0;
1364 
1365 /**
1366  * @dev Library for managing
1367  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1368  * types.
1369  *
1370  * Sets have the following properties:
1371  *
1372  * - Elements are added, removed, and checked for existence in constant time
1373  * (O(1)).
1374  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1375  *
1376  * ```
1377  * contract Example {
1378  *     // Add the library methods
1379  *     using EnumerableSet for EnumerableSet.AddressSet;
1380  *
1381  *     // Declare a set state variable
1382  *     EnumerableSet.AddressSet private mySet;
1383  * }
1384  * ```
1385  *
1386  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1387  * and `uint256` (`UintSet`) are supported.
1388  *
1389  * [WARNING]
1390  * ====
1391  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1392  * unusable.
1393  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1394  *
1395  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
1396  * array of EnumerableSet.
1397  * ====
1398  */
1399 library EnumerableSet {
1400     // To implement this library for multiple types with as little code
1401     // repetition as possible, we write it in terms of a generic Set type with
1402     // bytes32 values.
1403     // The Set implementation uses private functions, and user-facing
1404     // implementations (such as AddressSet) are just wrappers around the
1405     // underlying Set.
1406     // This means that we can only create new EnumerableSets for types that fit
1407     // in bytes32.
1408 
1409     struct Set {
1410         // Storage of set values
1411         bytes32[] _values;
1412         // Position of the value in the `values` array, plus 1 because index 0
1413         // means a value is not in the set.
1414         mapping(bytes32 => uint256) _indexes;
1415     }
1416 
1417     /**
1418      * @dev Add a value to a set. O(1).
1419      *
1420      * Returns true if the value was added to the set, that is if it was not
1421      * already present.
1422      */
1423     function _add(Set storage set, bytes32 value) private returns (bool) {
1424         if (!_contains(set, value)) {
1425             set._values.push(value);
1426             // The value is stored at length-1, but we add 1 to all indexes
1427             // and use 0 as a sentinel value
1428             set._indexes[value] = set._values.length;
1429             return true;
1430         } else {
1431             return false;
1432         }
1433     }
1434 
1435     /**
1436      * @dev Removes a value from a set. O(1).
1437      *
1438      * Returns true if the value was removed from the set, that is if it was
1439      * present.
1440      */
1441     function _remove(Set storage set, bytes32 value) private returns (bool) {
1442         // We read and store the value's index to prevent multiple reads from the same storage slot
1443         uint256 valueIndex = set._indexes[value];
1444 
1445         if (valueIndex != 0) {
1446             // Equivalent to contains(set, value)
1447             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1448             // the array, and then remove the last element (sometimes called as 'swap and pop').
1449             // This modifies the order of the array, as noted in {at}.
1450 
1451             uint256 toDeleteIndex = valueIndex - 1;
1452             uint256 lastIndex = set._values.length - 1;
1453 
1454             if (lastIndex != toDeleteIndex) {
1455                 bytes32 lastValue = set._values[lastIndex];
1456 
1457                 // Move the last value to the index where the value to delete is
1458                 set._values[toDeleteIndex] = lastValue;
1459                 // Update the index for the moved value
1460                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1461             }
1462 
1463             // Delete the slot where the moved value was stored
1464             set._values.pop();
1465 
1466             // Delete the index for the deleted slot
1467             delete set._indexes[value];
1468 
1469             return true;
1470         } else {
1471             return false;
1472         }
1473     }
1474 
1475     /**
1476      * @dev Returns true if the value is in the set. O(1).
1477      */
1478     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1479         return set._indexes[value] != 0;
1480     }
1481 
1482     /**
1483      * @dev Returns the number of values on the set. O(1).
1484      */
1485     function _length(Set storage set) private view returns (uint256) {
1486         return set._values.length;
1487     }
1488 
1489     /**
1490      * @dev Returns the value stored at position `index` in the set. O(1).
1491      *
1492      * Note that there are no guarantees on the ordering of values inside the
1493      * array, and it may change when more values are added or removed.
1494      *
1495      * Requirements:
1496      *
1497      * - `index` must be strictly less than {length}.
1498      */
1499     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1500         return set._values[index];
1501     }
1502 
1503     /**
1504      * @dev Return the entire set in an array
1505      *
1506      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1507      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1508      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1509      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1510      */
1511     function _values(Set storage set) private view returns (bytes32[] memory) {
1512         return set._values;
1513     }
1514 
1515     // Bytes32Set
1516 
1517     struct Bytes32Set {
1518         Set _inner;
1519     }
1520 
1521     /**
1522      * @dev Add a value to a set. O(1).
1523      *
1524      * Returns true if the value was added to the set, that is if it was not
1525      * already present.
1526      */
1527     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1528         return _add(set._inner, value);
1529     }
1530 
1531     /**
1532      * @dev Removes a value from a set. O(1).
1533      *
1534      * Returns true if the value was removed from the set, that is if it was
1535      * present.
1536      */
1537     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1538         return _remove(set._inner, value);
1539     }
1540 
1541     /**
1542      * @dev Returns true if the value is in the set. O(1).
1543      */
1544     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1545         return _contains(set._inner, value);
1546     }
1547 
1548     /**
1549      * @dev Returns the number of values in the set. O(1).
1550      */
1551     function length(Bytes32Set storage set) internal view returns (uint256) {
1552         return _length(set._inner);
1553     }
1554 
1555     /**
1556      * @dev Returns the value stored at position `index` in the set. O(1).
1557      *
1558      * Note that there are no guarantees on the ordering of values inside the
1559      * array, and it may change when more values are added or removed.
1560      *
1561      * Requirements:
1562      *
1563      * - `index` must be strictly less than {length}.
1564      */
1565     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1566         return _at(set._inner, index);
1567     }
1568 
1569     /**
1570      * @dev Return the entire set in an array
1571      *
1572      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1573      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1574      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1575      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1576      */
1577     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1578         bytes32[] memory store = _values(set._inner);
1579         bytes32[] memory result;
1580 
1581         /// @solidity memory-safe-assembly
1582         assembly {
1583             result := store
1584         }
1585 
1586         return result;
1587     }
1588 
1589     // AddressSet
1590 
1591     struct AddressSet {
1592         Set _inner;
1593     }
1594 
1595     /**
1596      * @dev Add a value to a set. O(1).
1597      *
1598      * Returns true if the value was added to the set, that is if it was not
1599      * already present.
1600      */
1601     function add(AddressSet storage set, address value) internal returns (bool) {
1602         return _add(set._inner, bytes32(uint256(uint160(value))));
1603     }
1604 
1605     /**
1606      * @dev Removes a value from a set. O(1).
1607      *
1608      * Returns true if the value was removed from the set, that is if it was
1609      * present.
1610      */
1611     function remove(AddressSet storage set, address value) internal returns (bool) {
1612         return _remove(set._inner, bytes32(uint256(uint160(value))));
1613     }
1614 
1615     /**
1616      * @dev Returns true if the value is in the set. O(1).
1617      */
1618     function contains(AddressSet storage set, address value) internal view returns (bool) {
1619         return _contains(set._inner, bytes32(uint256(uint160(value))));
1620     }
1621 
1622     /**
1623      * @dev Returns the number of values in the set. O(1).
1624      */
1625     function length(AddressSet storage set) internal view returns (uint256) {
1626         return _length(set._inner);
1627     }
1628 
1629     /**
1630      * @dev Returns the value stored at position `index` in the set. O(1).
1631      *
1632      * Note that there are no guarantees on the ordering of values inside the
1633      * array, and it may change when more values are added or removed.
1634      *
1635      * Requirements:
1636      *
1637      * - `index` must be strictly less than {length}.
1638      */
1639     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1640         return address(uint160(uint256(_at(set._inner, index))));
1641     }
1642 
1643     /**
1644      * @dev Return the entire set in an array
1645      *
1646      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1647      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1648      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1649      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1650      */
1651     function values(AddressSet storage set) internal view returns (address[] memory) {
1652         bytes32[] memory store = _values(set._inner);
1653         address[] memory result;
1654 
1655         /// @solidity memory-safe-assembly
1656         assembly {
1657             result := store
1658         }
1659 
1660         return result;
1661     }
1662 
1663     // UintSet
1664 
1665     struct UintSet {
1666         Set _inner;
1667     }
1668 
1669     /**
1670      * @dev Add a value to a set. O(1).
1671      *
1672      * Returns true if the value was added to the set, that is if it was not
1673      * already present.
1674      */
1675     function add(UintSet storage set, uint256 value) internal returns (bool) {
1676         return _add(set._inner, bytes32(value));
1677     }
1678 
1679     /**
1680      * @dev Removes a value from a set. O(1).
1681      *
1682      * Returns true if the value was removed from the set, that is if it was
1683      * present.
1684      */
1685     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1686         return _remove(set._inner, bytes32(value));
1687     }
1688 
1689     /**
1690      * @dev Returns true if the value is in the set. O(1).
1691      */
1692     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1693         return _contains(set._inner, bytes32(value));
1694     }
1695 
1696     /**
1697      * @dev Returns the number of values in the set. O(1).
1698      */
1699     function length(UintSet storage set) internal view returns (uint256) {
1700         return _length(set._inner);
1701     }
1702 
1703     /**
1704      * @dev Returns the value stored at position `index` in the set. O(1).
1705      *
1706      * Note that there are no guarantees on the ordering of values inside the
1707      * array, and it may change when more values are added or removed.
1708      *
1709      * Requirements:
1710      *
1711      * - `index` must be strictly less than {length}.
1712      */
1713     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1714         return uint256(_at(set._inner, index));
1715     }
1716 
1717     /**
1718      * @dev Return the entire set in an array
1719      *
1720      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1721      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1722      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1723      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1724      */
1725     function values(UintSet storage set) internal view returns (uint256[] memory) {
1726         bytes32[] memory store = _values(set._inner);
1727         uint256[] memory result;
1728 
1729         /// @solidity memory-safe-assembly
1730         assembly {
1731             result := store
1732         }
1733 
1734         return result;
1735     }
1736 }
1737 
1738 
1739 // File contracts/interfaces/IMasterChefBSC.sol
1740 
1741 
1742 pragma solidity ^0.8.0;
1743 
1744 interface IMasterChefBSC {
1745     function pendingCake(uint256 pid, address user) external view returns (uint256);
1746 
1747     function deposit(uint256 pid, uint256 amount) external;
1748 
1749     function withdraw(uint256 pid, uint256 amount) external;
1750 
1751     function emergencyWithdraw(uint256 pid) external;
1752 }
1753 
1754 
1755 // File contracts/interfaces/IMintNft.sol
1756 
1757 
1758 pragma solidity ^0.8.0;
1759 
1760 interface IMintNft {
1761     function mint(address to) external;
1762 }
1763 
1764 
1765 // File contracts/NFTMiner.sol
1766 
1767 
1768 
1769 pragma solidity ^0.8.0;
1770 
1771 
1772 
1773 
1774 
1775 
1776 
1777 
1778 contract NFTMiner is Ownable, ERC20 {
1779     using SafeMath for uint256;
1780     using SafeERC20 for IERC20;
1781 
1782     using EnumerableSet for EnumerableSet.AddressSet;
1783     EnumerableSet.AddressSet private _multLP;
1784 
1785     // Info of each user.
1786     struct UserInfo {
1787         uint256 amount;     // How many LP tokens the user has provided.
1788         uint256 rewardDebt; // Reward debt.
1789         uint256 multLpRewardDebt; //multLp Reward debt.
1790     }
1791 
1792     // Info of each pool.
1793     struct PoolInfo {
1794         IERC20 lpToken;           // Address of LP token contract.
1795         uint256 allocPoint;       // How many allocation points assigned to this pool. coins to distribute per block.
1796         uint256 lastRewardBlock;  // Last block number that coins distribution occurs.
1797         uint256 accPerShare; // Accumulated coins per share, times 1e12.
1798         uint256 accMultLpPerShare; //Accumulated multLp per share
1799         uint256 totalAmount;    // Total amount of current pool deposit.
1800     }
1801 
1802     // coin tokens created per block.
1803     uint256 public perBlock = 500000000000000000;
1804 //    uint256 public perBlock = 100*10**18;
1805     // Info of each pool.
1806     PoolInfo[] public poolInfo;
1807     // Info of each user that stakes LP tokens.
1808     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
1809     // Corresponding to the pid of the multLP pool
1810     mapping(uint256 => uint256) public poolCorrespond;
1811     // pid corresponding address
1812     mapping(address => uint256) public LpOfPid;
1813     // Control mining
1814     bool public paused = false;
1815     // Total allocation points. Must be the sum of all allocation points in all pools.
1816     uint256 public totalAllocPoint = 0;
1817     // The block number when coin mining starts.
1818     uint256 public startBlock;
1819     uint256 public endBlock;
1820     // multLP MasterChef
1821     address public multLpChef;
1822     // multLP Token
1823     address public multLpToken;
1824     // How many blocks are halved
1825     uint256 public halvingPeriod = 999999999;
1826     uint256 public perNFTBurn = 100 * 10 ** 18;
1827     address public nft;
1828     uint256 public totalQuota;
1829     uint256 public soldQuota;
1830 
1831     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1832     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1833     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1834 
1835     constructor(string memory name_, string memory symbol_,
1836         uint256 _startBlock, uint256 _endBlock, address _nft, uint256 _quota
1837     ) ERC20(name_, symbol_){
1838         startBlock = _startBlock;
1839         endBlock = _endBlock;
1840         nft = _nft;
1841         totalQuota = _quota;
1842     }
1843     function setNFT(address _nft) public onlyOwner {
1844         require(_nft != address(0), 'Address is zero address');
1845         nft = _nft;
1846     }
1847     modifier isOpening() {
1848         uint256 b = block.number;
1849         require(startBlock <= b && b <= endBlock, "Not in opening period");
1850         _;
1851     }
1852     // Set the number of coin produced by each block
1853     function setPerBlock(uint256 newPerBlock) public onlyOwner {
1854         massUpdatePools();
1855         perBlock = newPerBlock;
1856     }
1857     function poolLength() public view returns (uint256) {
1858         return poolInfo.length;
1859     }
1860 
1861     function addMultLP(address _addLP) public onlyOwner returns (bool) {
1862         require(_addLP != address(0), "LP is the zero address");
1863         IERC20(_addLP).approve(multLpChef, type(uint256).max);
1864         return EnumerableSet.add(_multLP, _addLP);
1865     }
1866 
1867     function isMultLP(address _LP) public view returns (bool) {
1868         return EnumerableSet.contains(_multLP, _LP);
1869     }
1870 
1871     function getMultLPLength() public view returns (uint256) {
1872         return EnumerableSet.length(_multLP);
1873     }
1874 
1875     function getMultLPAddress(uint256 _pid) public view returns (address){
1876         require(_pid <= getMultLPLength() - 1, "not find this multLP");
1877         return EnumerableSet.at(_multLP, _pid);
1878     }
1879 
1880     function setPause() public onlyOwner {
1881         paused = !paused;
1882     }
1883 
1884     function setMultLP(address _multLpToken, address _multLpChef) public onlyOwner {
1885         require(_multLpToken != address(0) && _multLpChef != address(0), "is the zero address");
1886         multLpToken = _multLpToken;
1887         multLpChef = _multLpChef;
1888     }
1889 
1890     function replaceMultLP(address _multLpToken, address _multLpChef) public onlyOwner {
1891         require(_multLpToken != address(0) && _multLpChef != address(0), "is the zero address");
1892         require(paused == true, "No mining suspension");
1893         multLpToken = _multLpToken;
1894         multLpChef = _multLpChef;
1895         uint256 length = getMultLPLength();
1896         while (length > 0) {
1897             address dAddress = EnumerableSet.at(_multLP, 0);
1898             uint256 pid = LpOfPid[dAddress];
1899             IMasterChefBSC(multLpChef).emergencyWithdraw(poolCorrespond[pid]);
1900             EnumerableSet.remove(_multLP, dAddress);
1901             length--;
1902         }
1903     }
1904 
1905     // Add a new lp to the pool. Can only be called by the owner.
1906     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1907     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1908         require(address(_lpToken) != address(0), "_lpToken is the zero address");
1909         if (_withUpdate) {
1910             massUpdatePools();
1911         }
1912         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1913         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1914         poolInfo.push(PoolInfo({
1915         lpToken : _lpToken,
1916         allocPoint : _allocPoint,
1917         lastRewardBlock : lastRewardBlock,
1918         accPerShare : 0,
1919         accMultLpPerShare : 0,
1920         totalAmount : 0
1921         }));
1922         LpOfPid[address(_lpToken)] = poolLength() - 1;
1923     }
1924 
1925     // Update the given pool's coin allocation point. Can only be called by the owner.
1926     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1927         if (_withUpdate) {
1928             massUpdatePools();
1929         }
1930         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1931         poolInfo[_pid].allocPoint = _allocPoint;
1932     }
1933 
1934     // The current pool corresponds to the pid of the multLP pool
1935     function setPoolCorr(uint256 _pid, uint256 _sid) public onlyOwner {
1936         require(_pid <= poolLength() - 1, "not find this pool");
1937         poolCorrespond[_pid] = _sid;
1938     }
1939 
1940     function phase(uint256 blockNumber) public view returns (uint256) {
1941         if (halvingPeriod == 0) {
1942             return 0;
1943         }
1944         if (blockNumber > startBlock) {
1945             return (blockNumber.sub(startBlock).sub(1)).div(halvingPeriod);
1946         }
1947         return 0;
1948     }
1949 
1950     function reward(uint256 blockNumber) public view returns (uint256) {
1951         uint256 _phase = phase(blockNumber);
1952         return perBlock.div(2 ** _phase).mul(poolLength());
1953     }
1954 
1955     function getBlockReward(uint256 _lastRewardBlock) public view returns (uint256) {
1956         uint256 blockReward = 0;
1957         uint256 n = phase(_lastRewardBlock);
1958         uint256 m = phase(block.number);
1959         while (n < m) {
1960             n++;
1961             uint256 r = n.mul(halvingPeriod).add(startBlock);
1962             blockReward = blockReward.add((r.sub(_lastRewardBlock)).mul(reward(r)));
1963             _lastRewardBlock = r;
1964         }
1965         blockReward = blockReward.add((block.number.sub(_lastRewardBlock)).mul(reward(block.number)));
1966         return blockReward;
1967     }
1968 
1969     // Update reward variables for all pools. Be careful of gas spending!
1970     function massUpdatePools() public {
1971         uint256 length = poolInfo.length;
1972         for (uint256 pid = 0; pid < length; ++pid) {
1973             updatePool(pid);
1974         }
1975     }
1976 
1977     // Update reward variables of the given pool to be up-to-date.
1978     function updatePool(uint256 _pid) public {
1979         PoolInfo storage pool = poolInfo[_pid];
1980         if (block.number <= pool.lastRewardBlock) {
1981             return;
1982         }
1983         uint256 lpSupply;
1984         if (isMultLP(address(pool.lpToken))) {
1985             if (pool.totalAmount == 0) {
1986                 pool.lastRewardBlock = block.number;
1987                 return;
1988             }
1989             lpSupply = pool.totalAmount;
1990         } else {
1991             lpSupply = pool.lpToken.balanceOf(address(this));
1992             if (lpSupply == 0) {
1993                 pool.lastRewardBlock = block.number;
1994                 return;
1995             }
1996         }
1997         uint256 blockReward = getBlockReward(pool.lastRewardBlock);
1998         if (blockReward <= 0) {
1999             return;
2000         }
2001         uint256 coinReward = blockReward.mul(pool.allocPoint).div(totalAllocPoint);
2002 
2003         pool.accPerShare = pool.accPerShare.add(coinReward.mul(1e12).div(lpSupply));
2004         pool.lastRewardBlock = block.number;
2005     }
2006 
2007     // View function to see pending coins on frontend.
2008     function pending(uint256 _pid, address _user) external view returns (uint256, uint256){
2009         PoolInfo storage pool = poolInfo[_pid];
2010         if (isMultLP(address(pool.lpToken))) {
2011             (uint256 amount, uint256 tokenAmount) = pendingCoinAndToken(_pid, _user);
2012             return (amount, tokenAmount);
2013         } else {
2014             uint256 amount = pendingCoin(_pid, _user);
2015             return (amount, 0);
2016         }
2017     }
2018 
2019     function pendingCoinAndToken(uint256 _pid, address _user) private view returns (uint256, uint256){
2020         PoolInfo storage pool = poolInfo[_pid];
2021         UserInfo storage user = userInfo[_pid][_user];
2022         uint256 accPerShare = pool.accPerShare;
2023         uint256 accMultLpPerShare = pool.accMultLpPerShare;
2024         if (user.amount > 0) {
2025             uint256 TokenPending = IMasterChefBSC(multLpChef).pendingCake(poolCorrespond[_pid], address(this));
2026             accMultLpPerShare = accMultLpPerShare.add(TokenPending.mul(1e12).div(pool.totalAmount));
2027             uint256 userPending = user.amount.mul(accMultLpPerShare).div(1e12).sub(user.multLpRewardDebt);
2028             if (block.number > pool.lastRewardBlock) {
2029                 uint256 blockReward = getBlockReward(pool.lastRewardBlock);
2030                 uint256 coinReward = blockReward.mul(pool.allocPoint).div(totalAllocPoint);
2031                 accPerShare = accPerShare.add(coinReward.mul(1e12).div(pool.totalAmount));
2032                 return (user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt), userPending);
2033             }
2034             if (block.number == pool.lastRewardBlock) {
2035                 return (user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt), userPending);
2036             }
2037         }
2038         return (0, 0);
2039     }
2040 
2041     function pendingCoin(uint256 _pid, address _user) private view returns (uint256){
2042         PoolInfo storage pool = poolInfo[_pid];
2043         UserInfo storage user = userInfo[_pid][_user];
2044         uint256 accPerShare = pool.accPerShare;
2045         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
2046         if (user.amount > 0) {
2047             if (block.number > pool.lastRewardBlock) {
2048                 uint256 blockReward = getBlockReward(pool.lastRewardBlock);
2049                 uint256 coinReward = blockReward.mul(pool.allocPoint).div(totalAllocPoint);
2050                 accPerShare = accPerShare.add(coinReward.mul(1e12).div(lpSupply));
2051                 return user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt);
2052             }
2053             if (block.number == pool.lastRewardBlock) {
2054                 return user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt);
2055             }
2056         }
2057         return 0;
2058     }
2059 
2060     // Deposit LP tokens to BSCPool for coin allocation.
2061     function deposit(uint256 _pid, uint256 _amount) public notPause isOpening {
2062         PoolInfo storage pool = poolInfo[_pid];
2063         if (isMultLP(address(pool.lpToken))) {
2064             depositCoinAndToken(_pid, _amount, msg.sender);
2065         } else {
2066             depositCoin(_pid, _amount, msg.sender);
2067         }
2068     }
2069 
2070     function depositCoinAndToken(uint256 _pid, uint256 _amount, address _user) private {
2071         PoolInfo storage pool = poolInfo[_pid];
2072         UserInfo storage user = userInfo[_pid][_user];
2073         updatePool(_pid);
2074         if (user.amount > 0) {
2075             uint256 pendingAmount = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
2076             if (pendingAmount > 0) {
2077                 safeCoinTransfer(_user, pendingAmount);
2078             }
2079             uint256 beforeToken = IERC20(multLpToken).balanceOf(address(this));
2080             IMasterChefBSC(multLpChef).deposit(poolCorrespond[_pid], 0);
2081             uint256 afterToken = IERC20(multLpToken).balanceOf(address(this));
2082             pool.accMultLpPerShare = pool.accMultLpPerShare.add(afterToken.sub(beforeToken).mul(1e12).div(pool.totalAmount));
2083             uint256 tokenPending = user.amount.mul(pool.accMultLpPerShare).div(1e12).sub(user.multLpRewardDebt);
2084             if (tokenPending > 0) {
2085                 IERC20(multLpToken).safeTransfer(_user, tokenPending);
2086             }
2087         }
2088         if (_amount > 0) {
2089             pool.lpToken.safeTransferFrom(_user, address(this), _amount);
2090             if (pool.totalAmount == 0) {
2091                 IMasterChefBSC(multLpChef).deposit(poolCorrespond[_pid], _amount);
2092                 user.amount = user.amount.add(_amount);
2093                 pool.totalAmount = pool.totalAmount.add(_amount);
2094             } else {
2095                 uint256 beforeToken = IERC20(multLpToken).balanceOf(address(this));
2096                 IMasterChefBSC(multLpChef).deposit(poolCorrespond[_pid], _amount);
2097                 uint256 afterToken = IERC20(multLpToken).balanceOf(address(this));
2098                 pool.accMultLpPerShare = pool.accMultLpPerShare.add(afterToken.sub(beforeToken).mul(1e12).div(pool.totalAmount));
2099                 user.amount = user.amount.add(_amount);
2100                 pool.totalAmount = pool.totalAmount.add(_amount);
2101             }
2102         }
2103         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
2104         user.multLpRewardDebt = user.amount.mul(pool.accMultLpPerShare).div(1e12);
2105         emit Deposit(_user, _pid, _amount);
2106     }
2107 
2108     function depositCoin(uint256 _pid, uint256 _amount, address _user) private {
2109         PoolInfo storage pool = poolInfo[_pid];
2110         UserInfo storage user = userInfo[_pid][_user];
2111         updatePool(_pid);
2112         if (user.amount > 0) {
2113             uint256 pendingAmount = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
2114             if (pendingAmount > 0) {
2115                 safeCoinTransfer(_user, pendingAmount);
2116             }
2117         }
2118         if (_amount > 0) {
2119             pool.lpToken.safeTransferFrom(_user, address(this), _amount);
2120             user.amount = user.amount.add(_amount);
2121             pool.totalAmount = pool.totalAmount.add(_amount);
2122         }
2123         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
2124         emit Deposit(_user, _pid, _amount);
2125     }
2126 
2127     // Withdraw LP tokens from BSCPool.
2128     function withdraw(uint256 _pid, uint256 _amount) public notPause {
2129         PoolInfo storage pool = poolInfo[_pid];
2130         if (isMultLP(address(pool.lpToken))) {
2131             withdrawCoinAndToken(_pid, _amount, msg.sender);
2132         } else {
2133             withdrawCoin(_pid, _amount, msg.sender);
2134         }
2135     }
2136 
2137     function withdrawCoinAndToken(uint256 _pid, uint256 _amount, address _user) private {
2138         PoolInfo storage pool = poolInfo[_pid];
2139         UserInfo storage user = userInfo[_pid][_user];
2140         require(user.amount >= _amount, "withdrawCoinAndToken: not good");
2141         updatePool(_pid);
2142         uint256 pendingAmount = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
2143         if (pendingAmount > 0) {
2144             safeCoinTransfer(_user, pendingAmount);
2145         }
2146         if (_amount > 0) {
2147             uint256 beforeToken = IERC20(multLpToken).balanceOf(address(this));
2148             IMasterChefBSC(multLpChef).withdraw(poolCorrespond[_pid], _amount);
2149             uint256 afterToken = IERC20(multLpToken).balanceOf(address(this));
2150             pool.accMultLpPerShare = pool.accMultLpPerShare.add(afterToken.sub(beforeToken).mul(1e12).div(pool.totalAmount));
2151             uint256 tokenPending = user.amount.mul(pool.accMultLpPerShare).div(1e12).sub(user.multLpRewardDebt);
2152             if (tokenPending > 0) {
2153                 IERC20(multLpToken).safeTransfer(_user, tokenPending);
2154             }
2155             user.amount = user.amount.sub(_amount);
2156             pool.totalAmount = pool.totalAmount.sub(_amount);
2157             pool.lpToken.safeTransfer(_user, _amount);
2158         }
2159         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
2160         user.multLpRewardDebt = user.amount.mul(pool.accMultLpPerShare).div(1e12);
2161         emit Withdraw(_user, _pid, _amount);
2162     }
2163 
2164     function withdrawCoin(uint256 _pid, uint256 _amount, address _user) private {
2165         PoolInfo storage pool = poolInfo[_pid];
2166         UserInfo storage user = userInfo[_pid][_user];
2167         require(user.amount >= _amount, "withdrawCoin: not good");
2168         updatePool(_pid);
2169         uint256 pendingAmount = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
2170         if (pendingAmount > 0) {
2171             safeCoinTransfer(_user, pendingAmount);
2172         }
2173         if (_amount > 0) {
2174             user.amount = user.amount.sub(_amount);
2175             pool.totalAmount = pool.totalAmount.sub(_amount);
2176             pool.lpToken.safeTransfer(_user, _amount);
2177         }
2178         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
2179         emit Withdraw(_user, _pid, _amount);
2180     }
2181 
2182     // Withdraw without caring about rewards. EMERGENCY ONLY.
2183     function emergencyWithdraw(uint256 _pid) public notPause {
2184         PoolInfo storage pool = poolInfo[_pid];
2185         if (isMultLP(address(pool.lpToken))) {
2186             emergencyWithdrawCoinAndToken(_pid, msg.sender);
2187         } else {
2188             emergencyWithdrawCoin(_pid, msg.sender);
2189         }
2190     }
2191 
2192     function emergencyWithdrawCoinAndToken(uint256 _pid, address _user) private {
2193         PoolInfo storage pool = poolInfo[_pid];
2194         UserInfo storage user = userInfo[_pid][_user];
2195         uint256 amount = user.amount;
2196         uint256 beforeToken = IERC20(multLpToken).balanceOf(address(this));
2197         IMasterChefBSC(multLpChef).withdraw(poolCorrespond[_pid], amount);
2198         uint256 afterToken = IERC20(multLpToken).balanceOf(address(this));
2199         pool.accMultLpPerShare = pool.accMultLpPerShare.add(afterToken.sub(beforeToken).mul(1e12).div(pool.totalAmount));
2200         user.amount = 0;
2201         user.rewardDebt = 0;
2202         pool.lpToken.safeTransfer(_user, amount);
2203         pool.totalAmount = pool.totalAmount.sub(amount);
2204         emit EmergencyWithdraw(_user, _pid, amount);
2205     }
2206 
2207     function emergencyWithdrawCoin(uint256 _pid, address _user) private {
2208         PoolInfo storage pool = poolInfo[_pid];
2209         UserInfo storage user = userInfo[_pid][_user];
2210         uint256 amount = user.amount;
2211         user.amount = 0;
2212         user.rewardDebt = 0;
2213         pool.lpToken.safeTransfer(_user, amount);
2214         pool.totalAmount = pool.totalAmount.sub(amount);
2215         emit EmergencyWithdraw(_user, _pid, amount);
2216     }
2217 
2218     // Safe coin transfer function, just in case if rounding error causes pool to not have enough coins.
2219     function safeCoinTransfer(address _to, uint256 _amount) internal {
2220         super._mint(_to, _amount);
2221     }
2222 
2223     modifier notPause() {
2224         require(!paused, "Mining has been suspended");
2225         _;
2226     }
2227     modifier hasQuota() {
2228         require(soldQuota < totalQuota, "not enough quota");
2229         _;
2230     }
2231     function burnForExchangeNFT(uint256 _pid) external hasQuota {
2232         withdrawCoin(_pid, 0, msg.sender);
2233         if (balanceOf(msg.sender) >= perNFTBurn) {
2234             _burn(msg.sender, perNFTBurn);
2235             soldQuota = soldQuota.add(1);
2236             IMintNft(nft).mint(msg.sender);
2237         }
2238     }
2239 }