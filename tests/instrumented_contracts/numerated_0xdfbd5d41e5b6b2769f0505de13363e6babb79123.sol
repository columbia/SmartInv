1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         _checkOwner();
58         _;
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if the sender is not the owner.
70      */
71     function _checkOwner() internal view virtual {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby disabling any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Emitted when `value` tokens are moved from one account (`from`) to
115      * another (`to`).
116      *
117      * Note that `value` may be zero.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     /**
122      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
123      * a call to {approve}. `value` is the new allowance.
124      */
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 
127     /**
128      * @dev Returns the amount of tokens in existence.
129      */
130     function totalSupply() external view returns (uint256);
131 
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `to`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address to, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `from` to `to` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(address from, address to, uint256 amount) external returns (bool);
181 }
182 
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev Interface for the optional metadata functions from the ERC20 standard.
188  *
189  * _Available since v4.1._
190  */
191 interface IERC20Metadata is IERC20 {
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the symbol of the token.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the decimals places of the token.
204      */
205     function decimals() external view returns (uint8);
206 }
207 
208 
209 pragma solidity ^0.8.0;
210 
211 
212 
213 /**
214  * @dev Implementation of the {IERC20} interface.
215  *
216  * This implementation is agnostic to the way tokens are created. This means
217  * that a supply mechanism has to be added in a derived contract using {_mint}.
218  * For a generic mechanism see {ERC20PresetMinterPauser}.
219  *
220  * TIP: For a detailed writeup see our guide
221  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
222  * to implement supply mechanisms].
223  *
224  * The default value of {decimals} is 18. To change this, you should override
225  * this function so it returns a different value.
226  *
227  * We have followed general OpenZeppelin Contracts guidelines: functions revert
228  * instead returning `false` on failure. This behavior is nonetheless
229  * conventional and does not conflict with the expectations of ERC20
230  * applications.
231  *
232  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
233  * This allows applications to reconstruct the allowance for all accounts just
234  * by listening to said events. Other implementations of the EIP may not emit
235  * these events, as it isn't required by the specification.
236  *
237  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
238  * functions have been added to mitigate the well-known issues around setting
239  * allowances. See {IERC20-approve}.
240  */
241 contract ERC20 is Context, IERC20, IERC20Metadata {
242     mapping(address => uint256) private _balances;
243 
244     mapping(address => mapping(address => uint256)) private _allowances;
245 
246     uint256 private _totalSupply;
247 
248     string private _name;
249     string private _symbol;
250 
251     /**
252      * @dev Sets the values for {name} and {symbol}.
253      *
254      * All two of these values are immutable: they can only be set once during
255      * construction.
256      */
257     constructor(string memory name_, string memory symbol_) {
258         _name = name_;
259         _symbol = symbol_;
260     }
261 
262     /**
263      * @dev Returns the name of the token.
264      */
265     function name() public view virtual override returns (string memory) {
266         return _name;
267     }
268 
269     /**
270      * @dev Returns the symbol of the token, usually a shorter version of the
271      * name.
272      */
273     function symbol() public view virtual override returns (string memory) {
274         return _symbol;
275     }
276 
277     /**
278      * @dev Returns the number of decimals used to get its user representation.
279      * For example, if `decimals` equals `2`, a balance of `505` tokens should
280      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
281      *
282      * Tokens usually opt for a value of 18, imitating the relationship between
283      * Ether and Wei. This is the default value returned by this function, unless
284      * it's overridden.
285      *
286      * NOTE: This information is only used for _display_ purposes: it in
287      * no way affects any of the arithmetic of the contract, including
288      * {IERC20-balanceOf} and {IERC20-transfer}.
289      */
290     function decimals() public view virtual override returns (uint8) {
291         return 18;
292     }
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view virtual override returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev See {IERC20-balanceOf}.
303      */
304     function balanceOf(address account) public view virtual override returns (uint256) {
305         return _balances[account];
306     }
307 
308     /**
309      * @dev See {IERC20-transfer}.
310      *
311      * Requirements:
312      *
313      * - `to` cannot be the zero address.
314      * - the caller must have a balance of at least `amount`.
315      */
316     function transfer(address to, uint256 amount) public virtual override returns (bool) {
317         address owner = _msgSender();
318         _transfer(owner, to, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-allowance}.
324      */
325     function allowance(address owner, address spender) public view virtual override returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     /**
330      * @dev See {IERC20-approve}.
331      *
332      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
333      * `transferFrom`. This is semantically equivalent to an infinite approval.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public virtual override returns (bool) {
340         address owner = _msgSender();
341         _approve(owner, spender, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-transferFrom}.
347      *
348      * Emits an {Approval} event indicating the updated allowance. This is not
349      * required by the EIP. See the note at the beginning of {ERC20}.
350      *
351      * NOTE: Does not update the allowance if the current allowance
352      * is the maximum `uint256`.
353      *
354      * Requirements:
355      *
356      * - `from` and `to` cannot be the zero address.
357      * - `from` must have a balance of at least `amount`.
358      * - the caller must have allowance for ``from``'s tokens of at least
359      * `amount`.
360      */
361     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
362         address spender = _msgSender();
363         _spendAllowance(from, spender, amount);
364         _transfer(from, to, amount);
365         return true;
366     }
367 
368     /**
369      * @dev Atomically increases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      */
380     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
381         address owner = _msgSender();
382         _approve(owner, spender, allowance(owner, spender) + addedValue);
383         return true;
384     }
385 
386     /**
387      * @dev Atomically decreases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      * - `spender` must have allowance for the caller of at least
398      * `subtractedValue`.
399      */
400     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
401         address owner = _msgSender();
402         uint256 currentAllowance = allowance(owner, spender);
403         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
404         unchecked {
405             _approve(owner, spender, currentAllowance - subtractedValue);
406         }
407 
408         return true;
409     }
410 
411     /**
412      * @dev Moves `amount` of tokens from `from` to `to`.
413      *
414      * This internal function is equivalent to {transfer}, and can be used to
415      * e.g. implement automatic token fees, slashing mechanisms, etc.
416      *
417      * Emits a {Transfer} event.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `from` must have a balance of at least `amount`.
424      */
425     function _transfer(address from, address to, uint256 amount) internal virtual {
426         require(from != address(0), "ERC20: transfer from the zero address");
427         require(to != address(0), "ERC20: transfer to the zero address");
428 
429         _beforeTokenTransfer(from, to, amount);
430 
431         uint256 fromBalance = _balances[from];
432         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
433         unchecked {
434             _balances[from] = fromBalance - amount;
435             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
436             // decrementing then incrementing.
437             _balances[to] += amount;
438         }
439 
440         emit Transfer(from, to, amount);
441 
442         _afterTokenTransfer(from, to, amount);
443     }
444 
445     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
446      * the total supply.
447      *
448      * Emits a {Transfer} event with `from` set to the zero address.
449      *
450      * Requirements:
451      *
452      * - `account` cannot be the zero address.
453      */
454     function _mint(address account, uint256 amount) internal virtual {
455         require(account != address(0), "ERC20: mint to the zero address");
456 
457         _beforeTokenTransfer(address(0), account, amount);
458 
459         _totalSupply += amount;
460         unchecked {
461             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
462             _balances[account] += amount;
463         }
464         emit Transfer(address(0), account, amount);
465 
466         _afterTokenTransfer(address(0), account, amount);
467     }
468 
469     /**
470      * @dev Destroys `amount` tokens from `account`, reducing the
471      * total supply.
472      *
473      * Emits a {Transfer} event with `to` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      * - `account` must have at least `amount` tokens.
479      */
480     function _burn(address account, uint256 amount) internal virtual {
481         require(account != address(0), "ERC20: burn from the zero address");
482 
483         _beforeTokenTransfer(account, address(0), amount);
484 
485         uint256 accountBalance = _balances[account];
486         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
487         unchecked {
488             _balances[account] = accountBalance - amount;
489             // Overflow not possible: amount <= accountBalance <= totalSupply.
490             _totalSupply -= amount;
491         }
492 
493         emit Transfer(account, address(0), amount);
494 
495         _afterTokenTransfer(account, address(0), amount);
496     }
497 
498     /**
499      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
500      *
501      * This internal function is equivalent to `approve`, and can be used to
502      * e.g. set automatic allowances for certain subsystems, etc.
503      *
504      * Emits an {Approval} event.
505      *
506      * Requirements:
507      *
508      * - `owner` cannot be the zero address.
509      * - `spender` cannot be the zero address.
510      */
511     function _approve(address owner, address spender, uint256 amount) internal virtual {
512         require(owner != address(0), "ERC20: approve from the zero address");
513         require(spender != address(0), "ERC20: approve to the zero address");
514 
515         _allowances[owner][spender] = amount;
516         emit Approval(owner, spender, amount);
517     }
518 
519     /**
520      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
521      *
522      * Does not update the allowance amount in case of infinite allowance.
523      * Revert if not enough allowance is available.
524      *
525      * Might emit an {Approval} event.
526      */
527     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
528         uint256 currentAllowance = allowance(owner, spender);
529         if (currentAllowance != type(uint256).max) {
530             require(currentAllowance >= amount, "ERC20: insufficient allowance");
531             unchecked {
532                 _approve(owner, spender, currentAllowance - amount);
533             }
534         }
535     }
536 
537     /**
538      * @dev Hook that is called before any transfer of tokens. This includes
539      * minting and burning.
540      *
541      * Calling conditions:
542      *
543      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
544      * will be transferred to `to`.
545      * - when `from` is zero, `amount` tokens will be minted for `to`.
546      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
547      * - `from` and `to` are never both zero.
548      *
549      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
550      */
551     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
552 
553     /**
554      * @dev Hook that is called after any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * has been transferred to `to`.
561      * - when `from` is zero, `amount` tokens have been minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
568 }
569 
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
575  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
576  *
577  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
578  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
579  * need to send a transaction, and thus is not required to hold Ether at all.
580  */
581 interface IERC20Permit {
582     /**
583      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
584      * given ``owner``'s signed approval.
585      *
586      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
587      * ordering also apply here.
588      *
589      * Emits an {Approval} event.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      * - `deadline` must be a timestamp in the future.
595      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
596      * over the EIP712-formatted function arguments.
597      * - the signature must use ``owner``'s current nonce (see {nonces}).
598      *
599      * For more information on the signature format, see the
600      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
601      * section].
602      */
603     function permit(
604         address owner,
605         address spender,
606         uint256 value,
607         uint256 deadline,
608         uint8 v,
609         bytes32 r,
610         bytes32 s
611     ) external;
612 
613     /**
614      * @dev Returns the current nonce for `owner`. This value must be
615      * included whenever a signature is generated for {permit}.
616      *
617      * Every successful call to {permit} increases ``owner``'s nonce by one. This
618      * prevents a signature from being used multiple times.
619      */
620     function nonces(address owner) external view returns (uint256);
621 
622     /**
623      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
624      */
625     // solhint-disable-next-line func-name-mixedcase
626     function DOMAIN_SEPARATOR() external view returns (bytes32);
627 }
628 
629 
630 pragma solidity ^0.8.1;
631 
632 /**
633  * @dev Collection of functions related to the address type
634  */
635 library Address {
636     /**
637      * @dev Returns true if `account` is a contract.
638      *
639      * [IMPORTANT]
640      * ====
641      * It is unsafe to assume that an address for which this function returns
642      * false is an externally-owned account (EOA) and not a contract.
643      *
644      * Among others, `isContract` will return false for the following
645      * types of addresses:
646      *
647      *  - an externally-owned account
648      *  - a contract in construction
649      *  - an address where a contract will be created
650      *  - an address where a contract lived, but was destroyed
651      *
652      * Furthermore, `isContract` will also return true if the target contract within
653      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
654      * which only has an effect at the end of a transaction.
655      * ====
656      *
657      * [IMPORTANT]
658      * ====
659      * You shouldn't rely on `isContract` to protect against flash loan attacks!
660      *
661      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
662      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
663      * constructor.
664      * ====
665      */
666     function isContract(address account) internal view returns (bool) {
667         // This method relies on extcodesize/address.code.length, which returns 0
668         // for contracts in construction, since the code is only stored at the end
669         // of the constructor execution.
670 
671         return account.code.length > 0;
672     }
673 
674     /**
675      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
676      * `recipient`, forwarding all available gas and reverting on errors.
677      *
678      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
679      * of certain opcodes, possibly making contracts go over the 2300 gas limit
680      * imposed by `transfer`, making them unable to receive funds via
681      * `transfer`. {sendValue} removes this limitation.
682      *
683      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
684      *
685      * IMPORTANT: because control is transferred to `recipient`, care must be
686      * taken to not create reentrancy vulnerabilities. Consider using
687      * {ReentrancyGuard} or the
688      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
689      */
690     function sendValue(address payable recipient, uint256 amount) internal {
691         require(address(this).balance >= amount, "Address: insufficient balance");
692 
693         (bool success, ) = recipient.call{value: amount}("");
694         require(success, "Address: unable to send value, recipient may have reverted");
695     }
696 
697     /**
698      * @dev Performs a Solidity function call using a low level `call`. A
699      * plain `call` is an unsafe replacement for a function call: use this
700      * function instead.
701      *
702      * If `target` reverts with a revert reason, it is bubbled up by this
703      * function (like regular Solidity function calls).
704      *
705      * Returns the raw returned data. To convert to the expected return value,
706      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
707      *
708      * Requirements:
709      *
710      * - `target` must be a contract.
711      * - calling `target` with `data` must not revert.
712      *
713      * _Available since v3.1._
714      */
715     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
716         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
717     }
718 
719     /**
720      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
721      * `errorMessage` as a fallback revert reason when `target` reverts.
722      *
723      * _Available since v3.1._
724      */
725     function functionCall(
726         address target,
727         bytes memory data,
728         string memory errorMessage
729     ) internal returns (bytes memory) {
730         return functionCallWithValue(target, data, 0, errorMessage);
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
735      * but also transferring `value` wei to `target`.
736      *
737      * Requirements:
738      *
739      * - the calling contract must have an ETH balance of at least `value`.
740      * - the called Solidity function must be `payable`.
741      *
742      * _Available since v3.1._
743      */
744     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
745         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
750      * with `errorMessage` as a fallback revert reason when `target` reverts.
751      *
752      * _Available since v3.1._
753      */
754     function functionCallWithValue(
755         address target,
756         bytes memory data,
757         uint256 value,
758         string memory errorMessage
759     ) internal returns (bytes memory) {
760         require(address(this).balance >= value, "Address: insufficient balance for call");
761         (bool success, bytes memory returndata) = target.call{value: value}(data);
762         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
763     }
764 
765     /**
766      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
767      * but performing a static call.
768      *
769      * _Available since v3.3._
770      */
771     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
772         return functionStaticCall(target, data, "Address: low-level static call failed");
773     }
774 
775     /**
776      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
777      * but performing a static call.
778      *
779      * _Available since v3.3._
780      */
781     function functionStaticCall(
782         address target,
783         bytes memory data,
784         string memory errorMessage
785     ) internal view returns (bytes memory) {
786         (bool success, bytes memory returndata) = target.staticcall(data);
787         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
792      * but performing a delegate call.
793      *
794      * _Available since v3.4._
795      */
796     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
797         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
802      * but performing a delegate call.
803      *
804      * _Available since v3.4._
805      */
806     function functionDelegateCall(
807         address target,
808         bytes memory data,
809         string memory errorMessage
810     ) internal returns (bytes memory) {
811         (bool success, bytes memory returndata) = target.delegatecall(data);
812         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
813     }
814 
815     /**
816      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
817      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
818      *
819      * _Available since v4.8._
820      */
821     function verifyCallResultFromTarget(
822         address target,
823         bool success,
824         bytes memory returndata,
825         string memory errorMessage
826     ) internal view returns (bytes memory) {
827         if (success) {
828             if (returndata.length == 0) {
829                 // only check isContract if the call was successful and the return data is empty
830                 // otherwise we already know that it was a contract
831                 require(isContract(target), "Address: call to non-contract");
832             }
833             return returndata;
834         } else {
835             _revert(returndata, errorMessage);
836         }
837     }
838 
839     /**
840      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
841      * revert reason or using the provided one.
842      *
843      * _Available since v4.3._
844      */
845     function verifyCallResult(
846         bool success,
847         bytes memory returndata,
848         string memory errorMessage
849     ) internal pure returns (bytes memory) {
850         if (success) {
851             return returndata;
852         } else {
853             _revert(returndata, errorMessage);
854         }
855     }
856 
857     function _revert(bytes memory returndata, string memory errorMessage) private pure {
858         // Look for revert reason and bubble it up if present
859         if (returndata.length > 0) {
860             // The easiest way to bubble the revert reason is using memory via assembly
861             /// @solidity memory-safe-assembly
862             assembly {
863                 let returndata_size := mload(returndata)
864                 revert(add(32, returndata), returndata_size)
865             }
866         } else {
867             revert(errorMessage);
868         }
869     }
870 }
871 
872 
873 pragma solidity ^0.8.0;
874 
875 
876 
877 /**
878  * @title SafeERC20
879  * @dev Wrappers around ERC20 operations that throw on failure (when the token
880  * contract returns false). Tokens that return no value (and instead revert or
881  * throw on failure) are also supported, non-reverting calls are assumed to be
882  * successful.
883  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
884  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
885  */
886 library SafeERC20 {
887     using Address for address;
888 
889     /**
890      * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
891      * non-reverting calls are assumed to be successful.
892      */
893     function safeTransfer(IERC20 token, address to, uint256 value) internal {
894         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
895     }
896 
897     /**
898      * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
899      * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
900      */
901     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
902         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
903     }
904 
905     /**
906      * @dev Deprecated. This function has issues similar to the ones found in
907      * {IERC20-approve}, and its usage is discouraged.
908      *
909      * Whenever possible, use {safeIncreaseAllowance} and
910      * {safeDecreaseAllowance} instead.
911      */
912     function safeApprove(IERC20 token, address spender, uint256 value) internal {
913         // safeApprove should only be called when setting an initial allowance,
914         // or when resetting it to zero. To increase and decrease it, use
915         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
916         require(
917             (value == 0) || (token.allowance(address(this), spender) == 0),
918             "SafeERC20: approve from non-zero to non-zero allowance"
919         );
920         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
921     }
922 
923     /**
924      * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
925      * non-reverting calls are assumed to be successful.
926      */
927     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
928         uint256 oldAllowance = token.allowance(address(this), spender);
929         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
930     }
931 
932     /**
933      * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
934      * non-reverting calls are assumed to be successful.
935      */
936     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
937         unchecked {
938             uint256 oldAllowance = token.allowance(address(this), spender);
939             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
940             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
941         }
942     }
943 
944     /**
945      * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
946      * non-reverting calls are assumed to be successful. Compatible with tokens that require the approval to be set to
947      * 0 before setting it to a non-zero value.
948      */
949     function forceApprove(IERC20 token, address spender, uint256 value) internal {
950         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
951 
952         if (!_callOptionalReturnBool(token, approvalCall)) {
953             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
954             _callOptionalReturn(token, approvalCall);
955         }
956     }
957 
958     /**
959      * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
960      * Revert on invalid signature.
961      */
962     function safePermit(
963         IERC20Permit token,
964         address owner,
965         address spender,
966         uint256 value,
967         uint256 deadline,
968         uint8 v,
969         bytes32 r,
970         bytes32 s
971     ) internal {
972         uint256 nonceBefore = token.nonces(owner);
973         token.permit(owner, spender, value, deadline, v, r, s);
974         uint256 nonceAfter = token.nonces(owner);
975         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
976     }
977 
978     /**
979      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
980      * on the return value: the return value is optional (but if data is returned, it must not be false).
981      * @param token The token targeted by the call.
982      * @param data The call data (encoded using abi.encode or one of its variants).
983      */
984     function _callOptionalReturn(IERC20 token, bytes memory data) private {
985         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
986         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
987         // the target address contains contract code and also asserts for success in the low-level call.
988 
989         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
990         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
991     }
992 
993     /**
994      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
995      * on the return value: the return value is optional (but if data is returned, it must not be false).
996      * @param token The token targeted by the call.
997      * @param data The call data (encoded using abi.encode or one of its variants).
998      *
999      * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
1000      */
1001     function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
1002         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1003         // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
1004         // and not revert is the subcall reverts.
1005 
1006         (bool success, bytes memory returndata) = address(token).call(data);
1007         return
1008             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
1009     }
1010 }
1011 
1012 
1013 pragma solidity >=0.6.2;
1014 
1015 interface IUniswapV2Router01 {
1016     function factory() external pure returns (address);
1017 
1018     function WETH() external pure returns (address);
1019 
1020     function addLiquidity(
1021         address tokenA,
1022         address tokenB,
1023         uint amountADesired,
1024         uint amountBDesired,
1025         uint amountAMin,
1026         uint amountBMin,
1027         address to,
1028         uint deadline
1029     ) external returns (uint amountA, uint amountB, uint liquidity);
1030 
1031     function addLiquidityETH(
1032         address token,
1033         uint amountTokenDesired,
1034         uint amountTokenMin,
1035         uint amountETHMin,
1036         address to,
1037         uint deadline
1038     )
1039         external
1040         payable
1041         returns (uint amountToken, uint amountETH, uint liquidity);
1042 
1043     function removeLiquidity(
1044         address tokenA,
1045         address tokenB,
1046         uint liquidity,
1047         uint amountAMin,
1048         uint amountBMin,
1049         address to,
1050         uint deadline
1051     ) external returns (uint amountA, uint amountB);
1052 
1053     function removeLiquidityETH(
1054         address token,
1055         uint liquidity,
1056         uint amountTokenMin,
1057         uint amountETHMin,
1058         address to,
1059         uint deadline
1060     ) external returns (uint amountToken, uint amountETH);
1061 
1062     function removeLiquidityWithPermit(
1063         address tokenA,
1064         address tokenB,
1065         uint liquidity,
1066         uint amountAMin,
1067         uint amountBMin,
1068         address to,
1069         uint deadline,
1070         bool approveMax,
1071         uint8 v,
1072         bytes32 r,
1073         bytes32 s
1074     ) external returns (uint amountA, uint amountB);
1075 
1076     function removeLiquidityETHWithPermit(
1077         address token,
1078         uint liquidity,
1079         uint amountTokenMin,
1080         uint amountETHMin,
1081         address to,
1082         uint deadline,
1083         bool approveMax,
1084         uint8 v,
1085         bytes32 r,
1086         bytes32 s
1087     ) external returns (uint amountToken, uint amountETH);
1088 
1089     function quote(
1090         uint amountA,
1091         uint reserveA,
1092         uint reserveB
1093     ) external pure returns (uint amountB);
1094 
1095     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1096         uint256 amountIn,
1097         uint256 amountOutMin,
1098         address[] calldata path,
1099         address to,
1100         uint256 deadline
1101     ) external;
1102 
1103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1104         uint amountIn,
1105         uint amountOutMin,
1106         address[] calldata path,
1107         address to,
1108         uint deadline
1109     ) external;
1110 }
1111 
1112 
1113 // File contracts/interfaces/IUniswapV2Router02.sol
1114 
1115 pragma solidity >=0.6.2;
1116 
1117 interface IUniswapV2Router02 is IUniswapV2Router01 {
1118     function removeLiquidityETHSupportingFeeOnTransferTokens(
1119         address token,
1120         uint liquidity,
1121         uint amountTokenMin,
1122         uint amountETHMin,
1123         address to,
1124         uint deadline
1125     ) external returns (uint amountETH);
1126     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1127         address token,
1128         uint liquidity,
1129         uint amountTokenMin,
1130         uint amountETHMin,
1131         address to,
1132         uint deadline,
1133         bool approveMax, uint8 v, bytes32 r, bytes32 s
1134     ) external returns (uint amountETH);
1135 
1136     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1137         uint amountIn,
1138         uint amountOutMin,
1139         address[] calldata path,
1140         address to,
1141         uint deadline
1142     ) external;
1143     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1144         uint amountOutMin,
1145         address[] calldata path,
1146         address to,
1147         uint deadline
1148     ) external payable;
1149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1150         uint amountIn,
1151         uint amountOutMin,
1152         address[] calldata path,
1153         address to,
1154         uint deadline
1155     ) external;
1156 }
1157 
1158 
1159 pragma solidity ^0.8.0;
1160 
1161 /**
1162  * @dev Library for managing
1163  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1164  * types.
1165  *
1166  * Sets have the following properties:
1167  *
1168  * - Elements are added, removed, and checked for existence in constant time
1169  * (O(1)).
1170  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1171  *
1172  * ```solidity
1173  * contract Example {
1174  *     // Add the library methods
1175  *     using EnumerableSet for EnumerableSet.AddressSet;
1176  *
1177  *     // Declare a set state variable
1178  *     EnumerableSet.AddressSet private mySet;
1179  * }
1180  * ```
1181  *
1182  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1183  * and `uint256` (`UintSet`) are supported.
1184  *
1185  * [WARNING]
1186  * ====
1187  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1188  * unusable.
1189  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1190  *
1191  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
1192  * array of EnumerableSet.
1193  * ====
1194  */
1195 library EnumerableSet {
1196     // To implement this library for multiple types with as little code
1197     // repetition as possible, we write it in terms of a generic Set type with
1198     // bytes32 values.
1199     // The Set implementation uses private functions, and user-facing
1200     // implementations (such as AddressSet) are just wrappers around the
1201     // underlying Set.
1202     // This means that we can only create new EnumerableSets for types that fit
1203     // in bytes32.
1204 
1205     struct Set {
1206         // Storage of set values
1207         bytes32[] _values;
1208         // Position of the value in the `values` array, plus 1 because index 0
1209         // means a value is not in the set.
1210         mapping(bytes32 => uint256) _indexes;
1211     }
1212 
1213     /**
1214      * @dev Add a value to a set. O(1).
1215      *
1216      * Returns true if the value was added to the set, that is if it was not
1217      * already present.
1218      */
1219     function _add(Set storage set, bytes32 value) private returns (bool) {
1220         if (!_contains(set, value)) {
1221             set._values.push(value);
1222             // The value is stored at length-1, but we add 1 to all indexes
1223             // and use 0 as a sentinel value
1224             set._indexes[value] = set._values.length;
1225             return true;
1226         } else {
1227             return false;
1228         }
1229     }
1230 
1231     /**
1232      * @dev Removes a value from a set. O(1).
1233      *
1234      * Returns true if the value was removed from the set, that is if it was
1235      * present.
1236      */
1237     function _remove(Set storage set, bytes32 value) private returns (bool) {
1238         // We read and store the value's index to prevent multiple reads from the same storage slot
1239         uint256 valueIndex = set._indexes[value];
1240 
1241         if (valueIndex != 0) {
1242             // Equivalent to contains(set, value)
1243             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1244             // the array, and then remove the last element (sometimes called as 'swap and pop').
1245             // This modifies the order of the array, as noted in {at}.
1246 
1247             uint256 toDeleteIndex = valueIndex - 1;
1248             uint256 lastIndex = set._values.length - 1;
1249 
1250             if (lastIndex != toDeleteIndex) {
1251                 bytes32 lastValue = set._values[lastIndex];
1252 
1253                 // Move the last value to the index where the value to delete is
1254                 set._values[toDeleteIndex] = lastValue;
1255                 // Update the index for the moved value
1256                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1257             }
1258 
1259             // Delete the slot where the moved value was stored
1260             set._values.pop();
1261 
1262             // Delete the index for the deleted slot
1263             delete set._indexes[value];
1264 
1265             return true;
1266         } else {
1267             return false;
1268         }
1269     }
1270 
1271     /**
1272      * @dev Returns true if the value is in the set. O(1).
1273      */
1274     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1275         return set._indexes[value] != 0;
1276     }
1277 
1278     /**
1279      * @dev Returns the number of values on the set. O(1).
1280      */
1281     function _length(Set storage set) private view returns (uint256) {
1282         return set._values.length;
1283     }
1284 
1285     /**
1286      * @dev Returns the value stored at position `index` in the set. O(1).
1287      *
1288      * Note that there are no guarantees on the ordering of values inside the
1289      * array, and it may change when more values are added or removed.
1290      *
1291      * Requirements:
1292      *
1293      * - `index` must be strictly less than {length}.
1294      */
1295     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1296         return set._values[index];
1297     }
1298 
1299     /**
1300      * @dev Return the entire set in an array
1301      *
1302      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1303      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1304      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1305      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1306      */
1307     function _values(Set storage set) private view returns (bytes32[] memory) {
1308         return set._values;
1309     }
1310 
1311     // Bytes32Set
1312 
1313     struct Bytes32Set {
1314         Set _inner;
1315     }
1316 
1317     /**
1318      * @dev Add a value to a set. O(1).
1319      *
1320      * Returns true if the value was added to the set, that is if it was not
1321      * already present.
1322      */
1323     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1324         return _add(set._inner, value);
1325     }
1326 
1327     /**
1328      * @dev Removes a value from a set. O(1).
1329      *
1330      * Returns true if the value was removed from the set, that is if it was
1331      * present.
1332      */
1333     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1334         return _remove(set._inner, value);
1335     }
1336 
1337     /**
1338      * @dev Returns true if the value is in the set. O(1).
1339      */
1340     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1341         return _contains(set._inner, value);
1342     }
1343 
1344     /**
1345      * @dev Returns the number of values in the set. O(1).
1346      */
1347     function length(Bytes32Set storage set) internal view returns (uint256) {
1348         return _length(set._inner);
1349     }
1350 
1351     /**
1352      * @dev Returns the value stored at position `index` in the set. O(1).
1353      *
1354      * Note that there are no guarantees on the ordering of values inside the
1355      * array, and it may change when more values are added or removed.
1356      *
1357      * Requirements:
1358      *
1359      * - `index` must be strictly less than {length}.
1360      */
1361     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1362         return _at(set._inner, index);
1363     }
1364 
1365     /**
1366      * @dev Return the entire set in an array
1367      *
1368      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1369      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1370      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1371      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1372      */
1373     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1374         bytes32[] memory store = _values(set._inner);
1375         bytes32[] memory result;
1376 
1377         /// @solidity memory-safe-assembly
1378         assembly {
1379             result := store
1380         }
1381 
1382         return result;
1383     }
1384 
1385     // AddressSet
1386 
1387     struct AddressSet {
1388         Set _inner;
1389     }
1390 
1391     /**
1392      * @dev Add a value to a set. O(1).
1393      *
1394      * Returns true if the value was added to the set, that is if it was not
1395      * already present.
1396      */
1397     function add(AddressSet storage set, address value) internal returns (bool) {
1398         return _add(set._inner, bytes32(uint256(uint160(value))));
1399     }
1400 
1401     /**
1402      * @dev Removes a value from a set. O(1).
1403      *
1404      * Returns true if the value was removed from the set, that is if it was
1405      * present.
1406      */
1407     function remove(AddressSet storage set, address value) internal returns (bool) {
1408         return _remove(set._inner, bytes32(uint256(uint160(value))));
1409     }
1410 
1411     /**
1412      * @dev Returns true if the value is in the set. O(1).
1413      */
1414     function contains(AddressSet storage set, address value) internal view returns (bool) {
1415         return _contains(set._inner, bytes32(uint256(uint160(value))));
1416     }
1417 
1418     /**
1419      * @dev Returns the number of values in the set. O(1).
1420      */
1421     function length(AddressSet storage set) internal view returns (uint256) {
1422         return _length(set._inner);
1423     }
1424 
1425     /**
1426      * @dev Returns the value stored at position `index` in the set. O(1).
1427      *
1428      * Note that there are no guarantees on the ordering of values inside the
1429      * array, and it may change when more values are added or removed.
1430      *
1431      * Requirements:
1432      *
1433      * - `index` must be strictly less than {length}.
1434      */
1435     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1436         return address(uint160(uint256(_at(set._inner, index))));
1437     }
1438 
1439     /**
1440      * @dev Return the entire set in an array
1441      *
1442      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1443      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1444      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1445      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1446      */
1447     function values(AddressSet storage set) internal view returns (address[] memory) {
1448         bytes32[] memory store = _values(set._inner);
1449         address[] memory result;
1450 
1451         /// @solidity memory-safe-assembly
1452         assembly {
1453             result := store
1454         }
1455 
1456         return result;
1457     }
1458 
1459     // UintSet
1460 
1461     struct UintSet {
1462         Set _inner;
1463     }
1464 
1465     /**
1466      * @dev Add a value to a set. O(1).
1467      *
1468      * Returns true if the value was added to the set, that is if it was not
1469      * already present.
1470      */
1471     function add(UintSet storage set, uint256 value) internal returns (bool) {
1472         return _add(set._inner, bytes32(value));
1473     }
1474 
1475     /**
1476      * @dev Removes a value from a set. O(1).
1477      *
1478      * Returns true if the value was removed from the set, that is if it was
1479      * present.
1480      */
1481     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1482         return _remove(set._inner, bytes32(value));
1483     }
1484 
1485     /**
1486      * @dev Returns true if the value is in the set. O(1).
1487      */
1488     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1489         return _contains(set._inner, bytes32(value));
1490     }
1491 
1492     /**
1493      * @dev Returns the number of values in the set. O(1).
1494      */
1495     function length(UintSet storage set) internal view returns (uint256) {
1496         return _length(set._inner);
1497     }
1498 
1499     /**
1500      * @dev Returns the value stored at position `index` in the set. O(1).
1501      *
1502      * Note that there are no guarantees on the ordering of values inside the
1503      * array, and it may change when more values are added or removed.
1504      *
1505      * Requirements:
1506      *
1507      * - `index` must be strictly less than {length}.
1508      */
1509     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1510         return uint256(_at(set._inner, index));
1511     }
1512 
1513     /**
1514      * @dev Return the entire set in an array
1515      *
1516      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1517      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1518      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1519      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1520      */
1521     function values(UintSet storage set) internal view returns (uint256[] memory) {
1522         bytes32[] memory store = _values(set._inner);
1523         uint256[] memory result;
1524 
1525         /// @solidity memory-safe-assembly
1526         assembly {
1527             result := store
1528         }
1529 
1530         return result;
1531     }
1532 }
1533 
1534 
1535 pragma solidity >=0.8.0;
1536 
1537 interface IAIERC20BounsPool {
1538     function initialize(address hub_, address originalToken_, address rewardToken_, address weth_, address router_, uint256 startAt_) external;
1539     function addReward(uint256 amount) external;
1540     function rewardToken() external view returns (address);
1541     function originalToken() external view returns (address);
1542 }
1543 
1544 
1545 pragma solidity >=0.8.0;
1546 
1547 interface IAIERC20TradingPool {
1548     function initialize(address _originalToken, address _rewardToken, address _router, address _weth, uint256 _startTime, uint256 _epochDuration) external;
1549     function tradeEvent(address sender, uint256 amount) external;
1550     function vault() external view returns (address);
1551     function addCaller(address val) external;
1552 }
1553 
1554 
1555 // File contracts/interfaces/IUniswapV2Factory.sol
1556 
1557 pragma solidity >=0.5.0;
1558 
1559 interface IUniswapV2Factory {
1560     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1561 
1562     function feeTo() external view returns (address);
1563     function feeToSetter() external view returns (address);
1564     function feeToRate() external view returns (uint256);
1565 
1566     function getPair(address tokenA, address tokenB) external view returns (address pair);
1567     function allPairs(uint) external view returns (address pair);
1568     function allPairsLength() external view returns (uint);
1569 
1570     function createPair(address tokenA, address tokenB) external returns (address pair);
1571 
1572     function setFeeTo(address) external;
1573     function setFeeToSetter(address) external;
1574 }
1575 
1576 
1577 pragma solidity >=0.5.0;
1578 
1579 interface IWETH {
1580     function totalSupply() external view returns (uint256);
1581 
1582     function balanceOf(address account) external view returns (uint256);
1583 
1584     function allowance(address owner, address spender) external view returns (uint256);
1585 
1586     function approve(address spender, uint256 amount) external returns (bool);
1587 
1588     function deposit() external payable;
1589 
1590     function transfer(address to, uint256 value) external returns (bool);
1591 
1592     function withdraw(uint) external;
1593 }
1594 
1595 
1596 pragma solidity =0.8.19;
1597 
1598 
1599 
1600 
1601 
1602 
1603 
1604 
1605 
1606 
1607 
1608 contract AIERC20 is ERC20, Ownable {
1609     using SafeERC20 for IERC20;
1610     using EnumerableSet for EnumerableSet.AddressSet;
1611 
1612     event SwapBack(uint256 burn, uint256 liquidity, uint256 team, uint256 bouns, uint256 trading, uint timestamp);
1613     event Trade(address user, address pair, uint256 amount, uint side, uint timestamp);
1614     event AddLiquidity(uint256 tokenAmount, uint256 ethAmount, uint256 timestamp);
1615     event SetIsFromFeeExempt(address op, address account, bool isExempt);
1616     event SetIsToFeeExempt(address op, address account, bool isExempt);
1617     event SetIsSenderFeeExempt(address op, address account, bool isExempt);
1618     event SetFees(uint256 liquidityFee, uint256 burnFee, uint256 bounsFee, uint256 tradingPoolFee, uint256 teamFee);
1619     event SetFeeReceivers(address teamWallet, address bounsWallet, address tradingPool);
1620     event SetTeamWallet(address op, address teamWallet);
1621     event SetSwapEnabled(address op, bool enabled);
1622     event AddPair(address op, address pair);
1623     event RemovePair(address op, address pair);
1624 
1625     enum TaxType {
1626         None,
1627         Transfer,
1628         Trade
1629     }
1630 
1631     bool public swapEnabled = true;
1632 
1633     bool public inSwap;
1634     modifier swapping() {
1635         inSwap = true;
1636         _;
1637         inSwap = false;
1638     }
1639 
1640     uint256 public constant FeeDenominator = 10000;
1641     mapping(address => bool) public isFromFeeExempt;
1642     mapping(address => bool) public isToFeeExempt;
1643     mapping(address => bool) public isSenderFeeExempt;
1644 
1645     uint256 public burnFee;
1646     uint256 public liquidityFee;
1647     uint256 public teamFee;
1648     uint256 public bounsFee;
1649     uint256 public tradingPoolFee;
1650     uint256 public totalFee;
1651 
1652     address public teamWallet;
1653     address public bounsWallet;
1654     IAIERC20TradingPool public tradingPool;
1655 
1656     TaxType public taxType;
1657     
1658     IUniswapV2Router02 public immutable swapRouter;
1659     IUniswapV2Factory public immutable swapFactory;
1660     IWETH public immutable WETH;
1661     
1662     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
1663     address private constant ZERO = 0x0000000000000000000000000000000000000000;
1664 
1665     EnumerableSet.AddressSet private _pairs;
1666     EnumerableSet.AddressSet private _fullFeeExempt;
1667     bool public pairInitialized;
1668 
1669     uint8 private _decimals;
1670 
1671     constructor(
1672         string memory _name,
1673         string memory _symbol,
1674         uint8 _taxType,
1675         uint256 _totalSupply,
1676         uint8 decimals_,
1677         address _mintTo,
1678         address _swapRouter,
1679         address _swapFactory,
1680         address _weth
1681     ) ERC20(_name, _symbol) {
1682         taxType = TaxType(_taxType);
1683         _decimals = decimals_;
1684         isFromFeeExempt[_mintTo] = true;
1685         isToFeeExempt[_mintTo] = true;
1686         isSenderFeeExempt[_mintTo] = true;
1687         isFromFeeExempt[address(this)] = true;
1688         isToFeeExempt[address(this)] = true;
1689         isSenderFeeExempt[address(this)] = true;
1690         isFromFeeExempt[_swapRouter] = true;
1691         isToFeeExempt[_swapRouter] = true;
1692         swapRouter = IUniswapV2Router02(_swapRouter);
1693         swapFactory = IUniswapV2Factory(_swapFactory);
1694         WETH = IWETH(_weth);
1695         _mint(_mintTo, _totalSupply);
1696     }
1697 
1698     function initializePair() external {
1699         require(!pairInitialized, "pair already initialized");
1700         address pair = swapFactory.createPair(address(WETH), address(this));
1701         _pairs.add(pair);
1702         pairInitialized = true;
1703     }
1704 
1705     function decimals() public view virtual override returns (uint8) {
1706         return _decimals;
1707     }
1708 
1709     function burn(uint256 amount) external {
1710         _burn(_msgSender(), amount);
1711     }
1712 
1713     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1714         return _doTransfer(_msgSender(), to, amount);
1715     }
1716 
1717     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1718         address spender = _msgSender();
1719         _spendAllowance(sender, spender, amount);
1720         return _doTransfer(sender, recipient, amount);
1721     }
1722 
1723     function _doTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1724         if (inSwap) {
1725             _transfer(sender, recipient, amount);
1726             return true;
1727         }
1728 
1729         bool shouldTakeFee = taxType != TaxType.None && (!isSenderFeeExempt[msg.sender] && !isFromFeeExempt[sender] && !isToFeeExempt[recipient]);
1730         uint side = 0;
1731         address user_ = sender;
1732         address pair_ = recipient;
1733 
1734         if (shouldTakeFee) {
1735             if (isPair(sender)) {
1736                 side = 1;
1737                 user_ = recipient;
1738                 pair_ = sender;
1739                 try tradingPool.tradeEvent(sender, amount) {} catch {}
1740             } else if (isPair(recipient)) {
1741                 side = 2;
1742             }
1743         }
1744 
1745         if (shouldSwapBack()) {
1746             swapBack();
1747         }
1748 
1749         uint256 amountReceived = shouldTakeFee ? takeFee(sender, amount) : amount;
1750         _transfer(sender, recipient, amountReceived);
1751 
1752         if (side > 0) {
1753             emit Trade(user_, pair_, amount, side, block.timestamp);
1754         }
1755         return true;
1756     }
1757 
1758     function shouldSwapBack() internal view returns (bool) {
1759         return !inSwap && swapEnabled && balanceOf(address(this)) > 0 && !isPair(_msgSender());
1760     }
1761 
1762     function swapBack() internal swapping {
1763         uint256 taxAmount = balanceOf(address(this));
1764         if (taxAmount == 0) return;
1765         if (totalFee == 0) return;
1766 
1767         _approve(address(this), address(swapRouter), taxAmount);
1768 
1769         uint256 amountBurn = taxAmount * burnFee / totalFee;
1770         uint256 amountLp = taxAmount * liquidityFee / totalFee;
1771         uint256 amountBouns = taxAmount * bounsFee / totalFee;
1772         uint256 amountTrade = taxAmount * tradingPoolFee / totalFee;
1773         uint256 amountTeam = taxAmount * teamFee / totalFee;
1774         
1775         if (amountBurn > 0) {
1776             _burn(address(this), amountBurn);
1777         }
1778 
1779         if (amountBouns > 0) {
1780             _approve(address(this), bounsWallet, amountBouns);
1781             IAIERC20BounsPool(bounsWallet).addReward(amountBouns);
1782         }
1783 
1784         if (amountTrade > 0) {
1785             _transfer(address(this), address(tradingPool.vault()), amountTrade);
1786         }
1787 
1788         if (amountTeam > 0) {
1789             _transfer(address(this), teamWallet, amountTeam);
1790         }
1791 
1792         if (amountLp > 0) {
1793             _doAddLp();
1794         }
1795         
1796         emit SwapBack(amountBurn, amountLp, amountTeam, amountBouns, amountTrade, block.timestamp);
1797     }
1798 
1799     function _doAddLp() internal {
1800         address[] memory pathEth = new address[](2);
1801         pathEth[0] = address(this);
1802         pathEth[1] = address(WETH);
1803 
1804         uint256 tokenAmount = balanceOf(address(this));
1805         uint256 half = tokenAmount / 2;
1806         if(half < 1000) return;
1807 
1808         uint256 ethAmountBefore = address(this).balance;
1809         
1810         try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(half, 0, pathEth, address(this),block.timestamp){
1811             uint256 ethAmount = address(this).balance - ethAmountBefore;
1812 
1813             try swapRouter.addLiquidityETH{value: ethAmount}(address(this), half, 0, 0, address(0), block.timestamp) {
1814                 emit AddLiquidity(half, ethAmount, block.timestamp);
1815             } catch {}
1816 
1817         } catch {}
1818     }
1819 
1820     function doSwapBack() public {
1821         swapBack();
1822     }
1823 
1824     function takeFee(address sender, uint256 amount) internal returns (uint256) {
1825         uint256 feeAmount = (amount * totalFee) / FeeDenominator;
1826         _transfer(sender, address(this), feeAmount);
1827         return amount - feeAmount;
1828     }
1829 
1830     function getLpBalance(address user) public view returns(uint256) {
1831         address lp = swapFactory.getPair(address(WETH), address(this));
1832         if (lp == address(0)) {
1833             return 0;
1834         }
1835         return IERC20(lp).balanceOf(user);
1836     }
1837 
1838     function getCirculatingSupply() public view returns (uint256) {
1839         return totalSupply() - balanceOf(DEAD) - balanceOf(ZERO);
1840     }
1841 
1842     function setFees(
1843         uint256 _liquidityFee,
1844         uint256 _burnFee,
1845         uint256 _bounsFee,
1846         uint256 _tradingPoolFee,
1847         uint256 _teamFee
1848     ) external onlyOwner {
1849         liquidityFee = _liquidityFee;
1850         burnFee = _burnFee;
1851         bounsFee = _bounsFee;
1852         tradingPoolFee = _tradingPoolFee;
1853         teamFee = _teamFee;
1854         totalFee = _liquidityFee + _burnFee + _bounsFee + _tradingPoolFee + _teamFee;
1855         require(totalFee <= 1500, "Invalid fee");
1856         emit SetFees(liquidityFee, burnFee, bounsFee, tradingPoolFee, teamFee);
1857     }
1858 
1859     function setFeeReceivers(
1860         address _bounsWallet,
1861         address _tradingPool,
1862         address _teamWallet
1863     ) external onlyOwner {
1864         bounsWallet = _bounsWallet;
1865         tradingPool = IAIERC20TradingPool(_tradingPool);
1866         teamWallet = _teamWallet;
1867         emit SetFeeReceivers(_bounsWallet, _tradingPool, _teamWallet);
1868     }
1869 
1870     function setTeamWallet(address _teamWallet) external {
1871         require(msg.sender == teamWallet, "Only team wallet can change team wallet");
1872         teamWallet = _teamWallet;
1873         emit SetTeamWallet(msg.sender, _teamWallet);
1874     }
1875 
1876     function setIsFeeExempt(address holder, bool exempt) external ownerOrTeam {
1877         isFromFeeExempt[holder] = exempt;
1878         isToFeeExempt[holder] = exempt;
1879         isSenderFeeExempt[holder] = exempt;
1880         if (exempt) {
1881             _fullFeeExempt.add(holder);
1882         } else {
1883             _fullFeeExempt.remove(holder);
1884         }
1885         emit SetIsFromFeeExempt(msg.sender, holder, exempt);
1886         emit SetIsToFeeExempt(msg.sender, holder, exempt);
1887         emit SetIsSenderFeeExempt(msg.sender, holder, exempt);
1888     }
1889 
1890     function setSysFeeExempt(address holder) external onlyOwner {
1891         isFromFeeExempt[holder] = true;
1892         isToFeeExempt[holder] = true;
1893         isSenderFeeExempt[holder] = true;
1894         emit SetIsFromFeeExempt(msg.sender, holder, true);
1895         emit SetIsToFeeExempt(msg.sender, holder, true);
1896         emit SetIsSenderFeeExempt(msg.sender, holder, true);
1897     }
1898 
1899     function setIsFromFeeExempt(address holder, bool exempt) external ownerOrTeam {
1900         isFromFeeExempt[holder] = exempt;
1901         emit SetIsFromFeeExempt(msg.sender, holder, exempt);
1902     }
1903 
1904     function setIsToFeeExempt(address holder, bool exempt) external ownerOrTeam {
1905         isToFeeExempt[holder] = exempt;
1906         emit SetIsToFeeExempt(msg.sender, holder, exempt);
1907     }
1908 
1909     function setIsSenderFeeExempt(address holder, bool exempt) external ownerOrTeam {
1910         isSenderFeeExempt[holder] = exempt;
1911         emit SetIsSenderFeeExempt(msg.sender, holder, exempt);
1912     }
1913 
1914     function getFullFeeExempts() external view returns (address[] memory) {
1915         return _fullFeeExempt.values();
1916     }
1917 
1918     function setSwapBackSettings(bool _enabled) external onlyOwner {
1919         swapEnabled = _enabled;
1920         emit SetSwapEnabled(msg.sender, _enabled);
1921     }
1922 
1923     function isPair(address account) public view returns (bool) {
1924         return _pairs.contains(account);
1925     }
1926 
1927     function addPair(address pair) public onlyOwner returns (bool) {
1928         require(pair != address(0), "AIERC20: pair is 0");
1929         emit AddPair(msg.sender, pair);
1930         return _pairs.add(pair);
1931     }
1932 
1933     function delPair(address pair) public onlyOwner returns (bool) {
1934         require(pair != address(0), "AIERC20: pair is 0");
1935         emit RemovePair(msg.sender, pair);
1936         return _pairs.remove(pair);
1937     }
1938 
1939     function getPairsLength() public view returns (uint256) {
1940         return _pairs.length();
1941     }
1942 
1943     function getPair(uint256 index) public view returns (address) {
1944         require(index <= _pairs.length() - 1, "AIERC20: index out of bounds");
1945         return _pairs.at(index);
1946     }
1947 
1948     modifier ownerOrTeam() {
1949         require(msg.sender == owner() || msg.sender == teamWallet, "Only owner or team can call this function");
1950         _;
1951     }
1952 
1953     function clearStuckEthBalance() external onlyOwner {
1954         uint256 amountETH = address(this).balance;
1955         (bool success, ) = payable(_msgSender()).call{value: amountETH}(new bytes(0));
1956         require(success, 'AIERC20: ETH_TRANSFER_FAILED');
1957     }
1958 
1959     receive() external payable {}
1960 }