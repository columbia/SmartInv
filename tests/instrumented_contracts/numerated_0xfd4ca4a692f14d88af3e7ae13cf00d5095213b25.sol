1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.15;
3 
4 interface IUniswapV2Router01 {
5     function factory() external pure returns (address);
6     function WETH() external pure returns (address);
7 
8     function addLiquidity(
9         address tokenA,
10         address tokenB,
11         uint amountADesired,
12         uint amountBDesired,
13         uint amountAMin,
14         uint amountBMin,
15         address to,
16         uint deadline
17     ) external returns (uint amountA, uint amountB, uint liquidity);
18     function addLiquidityETH(
19         address token,
20         uint amountTokenDesired,
21         uint amountTokenMin,
22         uint amountETHMin,
23         address to,
24         uint deadline
25     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
26     function removeLiquidity(
27         address tokenA,
28         address tokenB,
29         uint liquidity,
30         uint amountAMin,
31         uint amountBMin,
32         address to,
33         uint deadline
34     ) external returns (uint amountA, uint amountB);
35     function removeLiquidityETH(
36         address token,
37         uint liquidity,
38         uint amountTokenMin,
39         uint amountETHMin,
40         address to,
41         uint deadline
42     ) external returns (uint amountToken, uint amountETH);
43     function removeLiquidityWithPermit(
44         address tokenA,
45         address tokenB,
46         uint liquidity,
47         uint amountAMin,
48         uint amountBMin,
49         address to,
50         uint deadline,
51         bool approveMax, uint8 v, bytes32 r, bytes32 s
52     ) external returns (uint amountA, uint amountB);
53     function removeLiquidityETHWithPermit(
54         address token,
55         uint liquidity,
56         uint amountTokenMin,
57         uint amountETHMin,
58         address to,
59         uint deadline,
60         bool approveMax, uint8 v, bytes32 r, bytes32 s
61     ) external returns (uint amountToken, uint amountETH);
62     function swapExactTokensForTokens(
63         uint amountIn,
64         uint amountOutMin,
65         address[] calldata path,
66         address to,
67         uint deadline
68     ) external returns (uint[] memory amounts);
69     function swapTokensForExactTokens(
70         uint amountOut,
71         uint amountInMax,
72         address[] calldata path,
73         address to,
74         uint deadline
75     ) external returns (uint[] memory amounts);
76     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
77         external
78         payable
79         returns (uint[] memory amounts);
80     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
81         external
82         returns (uint[] memory amounts);
83     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
84         external
85         returns (uint[] memory amounts);
86     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
87         external
88         payable
89         returns (uint[] memory amounts);
90 
91     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
92     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
93     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
94     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
95     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
96 }
97 
98 interface IUniswapV2Router02 is IUniswapV2Router01 {
99     function removeLiquidityETHSupportingFeeOnTransferTokens(
100         address token,
101         uint liquidity,
102         uint amountTokenMin,
103         uint amountETHMin,
104         address to,
105         uint deadline
106     ) external returns (uint amountETH);
107     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
108         address token,
109         uint liquidity,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline,
114         bool approveMax, uint8 v, bytes32 r, bytes32 s
115     ) external returns (uint amountETH);
116 
117     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124     function swapExactETHForTokensSupportingFeeOnTransferTokens(
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external payable;
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137 }
138 
139 
140 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
141 
142 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
143 
144 /**
145  * @dev Interface of the ERC20 standard as defined in the EIP.
146  */
147 interface IERC20 {
148     /**
149      * @dev Emitted when `value` tokens are moved from one account (`from`) to
150      * another (`to`).
151      *
152      * Note that `value` may be zero.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 value);
155 
156     /**
157      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
158      * a call to {approve}. `value` is the new allowance.
159      */
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 
162     /**
163      * @dev Returns the amount of tokens in existence.
164      */
165     function totalSupply() external view returns (uint256);
166 
167     /**
168      * @dev Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) external view returns (uint256);
171 
172     /**
173      * @dev Moves `amount` tokens from the caller's account to `to`.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transfer(address to, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Returns the remaining number of tokens that `spender` will be
183      * allowed to spend on behalf of `owner` through {transferFrom}. This is
184      * zero by default.
185      *
186      * This value changes when {approve} or {transferFrom} are called.
187      */
188     function allowance(address owner, address spender) external view returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `from` to `to` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(address from, address to, uint256 amount) external returns (bool);
216 }
217 
218 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
219 
220 /**
221  * @dev Interface for the optional metadata functions from the ERC20 standard.
222  *
223  * _Available since v4.1._
224  */
225 interface IERC20Metadata is IERC20 {
226     /**
227      * @dev Returns the name of the token.
228      */
229     function name() external view returns (string memory);
230 
231     /**
232      * @dev Returns the symbol of the token.
233      */
234     function symbol() external view returns (string memory);
235 
236     /**
237      * @dev Returns the decimals places of the token.
238      */
239     function decimals() external view returns (uint8);
240 }
241 
242 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
243 
244 /**
245  * @dev Provides information about the current execution context, including the
246  * sender of the transaction and its data. While these are generally available
247  * via msg.sender and msg.data, they should not be accessed in such a direct
248  * manner, since when dealing with meta-transactions the account sending and
249  * paying for execution may not be the actual sender (as far as an application
250  * is concerned).
251  *
252  * This contract is only required for intermediate, library-like contracts.
253  */
254 abstract contract Context {
255     function _msgSender() internal view virtual returns (address) {
256         return msg.sender;
257     }
258 
259     function _msgData() internal view virtual returns (bytes calldata) {
260         return msg.data;
261     }
262 }
263 
264 /**
265  * @dev Implementation of the {IERC20} interface.
266  *
267  * This implementation is agnostic to the way tokens are created. This means
268  * that a supply mechanism has to be added in a derived contract using {_mint}.
269  * For a generic mechanism see {ERC20PresetMinterPauser}.
270  *
271  * TIP: For a detailed writeup see our guide
272  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
273  * to implement supply mechanisms].
274  *
275  * The default value of {decimals} is 18. To change this, you should override
276  * this function so it returns a different value.
277  *
278  * We have followed general OpenZeppelin Contracts guidelines: functions revert
279  * instead returning `false` on failure. This behavior is nonetheless
280  * conventional and does not conflict with the expectations of ERC20
281  * applications.
282  *
283  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
284  * This allows applications to reconstruct the allowance for all accounts just
285  * by listening to said events. Other implementations of the EIP may not emit
286  * these events, as it isn't required by the specification.
287  *
288  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
289  * functions have been added to mitigate the well-known issues around setting
290  * allowances. See {IERC20-approve}.
291  */
292 contract ERC20 is Context, IERC20, IERC20Metadata {
293     mapping(address => uint256) private _balances;
294 
295     mapping(address => mapping(address => uint256)) private _allowances;
296 
297     uint256 private _totalSupply;
298 
299     string private _name;
300     string private _symbol;
301 
302     /**
303      * @dev Sets the values for {name} and {symbol}.
304      *
305      * All two of these values are immutable: they can only be set once during
306      * construction.
307      */
308     constructor(string memory name_, string memory symbol_) {
309         _name = name_;
310         _symbol = symbol_;
311     }
312 
313     /**
314      * @dev Returns the name of the token.
315      */
316     function name() public view virtual override returns (string memory) {
317         return _name;
318     }
319 
320     /**
321      * @dev Returns the symbol of the token, usually a shorter version of the
322      * name.
323      */
324     function symbol() public view virtual override returns (string memory) {
325         return _symbol;
326     }
327 
328     /**
329      * @dev Returns the number of decimals used to get its user representation.
330      * For example, if `decimals` equals `2`, a balance of `505` tokens should
331      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
332      *
333      * Tokens usually opt for a value of 18, imitating the relationship between
334      * Ether and Wei. This is the default value returned by this function, unless
335      * it's overridden.
336      *
337      * NOTE: This information is only used for _display_ purposes: it in
338      * no way affects any of the arithmetic of the contract, including
339      * {IERC20-balanceOf} and {IERC20-transfer}.
340      */
341     function decimals() public view virtual override returns (uint8) {
342         return 18;
343     }
344 
345     /**
346      * @dev See {IERC20-totalSupply}.
347      */
348     function totalSupply() public view virtual override returns (uint256) {
349         return _totalSupply;
350     }
351 
352     /**
353      * @dev See {IERC20-balanceOf}.
354      */
355     function balanceOf(address account) public view virtual override returns (uint256) {
356         return _balances[account];
357     }
358 
359     /**
360      * @dev See {IERC20-transfer}.
361      *
362      * Requirements:
363      *
364      * - `to` cannot be the zero address.
365      * - the caller must have a balance of at least `amount`.
366      */
367     function transfer(address to, uint256 amount) public virtual override returns (bool) {
368         address owner = _msgSender();
369         _transfer(owner, to, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-allowance}.
375      */
376     function allowance(address owner, address spender) public view virtual override returns (uint256) {
377         return _allowances[owner][spender];
378     }
379 
380     /**
381      * @dev See {IERC20-approve}.
382      *
383      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
384      * `transferFrom`. This is semantically equivalent to an infinite approval.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function approve(address spender, uint256 amount) public virtual override returns (bool) {
391         address owner = _msgSender();
392         _approve(owner, spender, amount);
393         return true;
394     }
395 
396     /**
397      * @dev See {IERC20-transferFrom}.
398      *
399      * Emits an {Approval} event indicating the updated allowance. This is not
400      * required by the EIP. See the note at the beginning of {ERC20}.
401      *
402      * NOTE: Does not update the allowance if the current allowance
403      * is the maximum `uint256`.
404      *
405      * Requirements:
406      *
407      * - `from` and `to` cannot be the zero address.
408      * - `from` must have a balance of at least `amount`.
409      * - the caller must have allowance for ``from``'s tokens of at least
410      * `amount`.
411      */
412     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
413         address spender = _msgSender();
414         _spendAllowance(from, spender, amount);
415         _transfer(from, to, amount);
416         return true;
417     }
418 
419     /**
420      * @dev Atomically increases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
432         address owner = _msgSender();
433         _approve(owner, spender, allowance(owner, spender) + addedValue);
434         return true;
435     }
436 
437     /**
438      * @dev Atomically decreases the allowance granted to `spender` by the caller.
439      *
440      * This is an alternative to {approve} that can be used as a mitigation for
441      * problems described in {IERC20-approve}.
442      *
443      * Emits an {Approval} event indicating the updated allowance.
444      *
445      * Requirements:
446      *
447      * - `spender` cannot be the zero address.
448      * - `spender` must have allowance for the caller of at least
449      * `subtractedValue`.
450      */
451     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
452         address owner = _msgSender();
453         uint256 currentAllowance = allowance(owner, spender);
454         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
455         unchecked {
456             _approve(owner, spender, currentAllowance - subtractedValue);
457         }
458 
459         return true;
460     }
461 
462     /**
463      * @dev Moves `amount` of tokens from `from` to `to`.
464      *
465      * This internal function is equivalent to {transfer}, and can be used to
466      * e.g. implement automatic token fees, slashing mechanisms, etc.
467      *
468      * Emits a {Transfer} event.
469      *
470      * Requirements:
471      *
472      * - `from` cannot be the zero address.
473      * - `to` cannot be the zero address.
474      * - `from` must have a balance of at least `amount`.
475      */
476     function _transfer(address from, address to, uint256 amount) internal virtual {
477         require(from != address(0), "ERC20: transfer from the zero address");
478         require(to != address(0), "ERC20: transfer to the zero address");
479 
480         _beforeTokenTransfer(from, to, amount);
481 
482         uint256 fromBalance = _balances[from];
483         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
484         unchecked {
485             _balances[from] = fromBalance - amount;
486             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
487             // decrementing then incrementing.
488             _balances[to] += amount;
489         }
490 
491         emit Transfer(from, to, amount);
492 
493         _afterTokenTransfer(from, to, amount);
494     }
495 
496     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
497      * the total supply.
498      *
499      * Emits a {Transfer} event with `from` set to the zero address.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      */
505     function _mint(address account, uint256 amount) internal virtual {
506         require(account != address(0), "ERC20: mint to the zero address");
507 
508         _beforeTokenTransfer(address(0), account, amount);
509 
510         _totalSupply += amount;
511         unchecked {
512             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
513             _balances[account] += amount;
514         }
515         emit Transfer(address(0), account, amount);
516 
517         _afterTokenTransfer(address(0), account, amount);
518     }
519 
520     /**
521      * @dev Destroys `amount` tokens from `account`, reducing the
522      * total supply.
523      *
524      * Emits a {Transfer} event with `to` set to the zero address.
525      *
526      * Requirements:
527      *
528      * - `account` cannot be the zero address.
529      * - `account` must have at least `amount` tokens.
530      */
531     function _burn(address account, uint256 amount) internal virtual {
532         require(account != address(0), "ERC20: burn from the zero address");
533 
534         _beforeTokenTransfer(account, address(0), amount);
535 
536         uint256 accountBalance = _balances[account];
537         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
538         unchecked {
539             _balances[account] = accountBalance - amount;
540             // Overflow not possible: amount <= accountBalance <= totalSupply.
541             _totalSupply -= amount;
542         }
543 
544         emit Transfer(account, address(0), amount);
545 
546         _afterTokenTransfer(account, address(0), amount);
547     }
548 
549     /**
550      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
551      *
552      * This internal function is equivalent to `approve`, and can be used to
553      * e.g. set automatic allowances for certain subsystems, etc.
554      *
555      * Emits an {Approval} event.
556      *
557      * Requirements:
558      *
559      * - `owner` cannot be the zero address.
560      * - `spender` cannot be the zero address.
561      */
562     function _approve(address owner, address spender, uint256 amount) internal virtual {
563         require(owner != address(0), "ERC20: approve from the zero address");
564         require(spender != address(0), "ERC20: approve to the zero address");
565 
566         _allowances[owner][spender] = amount;
567         emit Approval(owner, spender, amount);
568     }
569 
570     /**
571      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
572      *
573      * Does not update the allowance amount in case of infinite allowance.
574      * Revert if not enough allowance is available.
575      *
576      * Might emit an {Approval} event.
577      */
578     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
579         uint256 currentAllowance = allowance(owner, spender);
580         if (currentAllowance != type(uint256).max) {
581             require(currentAllowance >= amount, "ERC20: insufficient allowance");
582             unchecked {
583                 _approve(owner, spender, currentAllowance - amount);
584             }
585         }
586     }
587 
588     /**
589      * @dev Hook that is called before any transfer of tokens. This includes
590      * minting and burning.
591      *
592      * Calling conditions:
593      *
594      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
595      * will be transferred to `to`.
596      * - when `from` is zero, `amount` tokens will be minted for `to`.
597      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
598      * - `from` and `to` are never both zero.
599      *
600      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
601      */
602     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
603 
604     /**
605      * @dev Hook that is called after any transfer of tokens. This includes
606      * minting and burning.
607      *
608      * Calling conditions:
609      *
610      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
611      * has been transferred to `to`.
612      * - when `from` is zero, `amount` tokens have been minted for `to`.
613      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
614      * - `from` and `to` are never both zero.
615      *
616      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
617      */
618     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
619 }
620 
621 
622 // OpenZeppelin Contracts (last updated v4.9.3) (token/ERC20/utils/SafeERC20.sol)
623 
624 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
625 
626 /**
627  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
628  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
629  *
630  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
631  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
632  * need to send a transaction, and thus is not required to hold Ether at all.
633  */
634 interface IERC20Permit {
635     /**
636      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
637      * given ``owner``'s signed approval.
638      *
639      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
640      * ordering also apply here.
641      *
642      * Emits an {Approval} event.
643      *
644      * Requirements:
645      *
646      * - `spender` cannot be the zero address.
647      * - `deadline` must be a timestamp in the future.
648      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
649      * over the EIP712-formatted function arguments.
650      * - the signature must use ``owner``'s current nonce (see {nonces}).
651      *
652      * For more information on the signature format, see the
653      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
654      * section].
655      */
656     function permit(
657         address owner,
658         address spender,
659         uint256 value,
660         uint256 deadline,
661         uint8 v,
662         bytes32 r,
663         bytes32 s
664     ) external;
665 
666     /**
667      * @dev Returns the current nonce for `owner`. This value must be
668      * included whenever a signature is generated for {permit}.
669      *
670      * Every successful call to {permit} increases ``owner``'s nonce by one. This
671      * prevents a signature from being used multiple times.
672      */
673     function nonces(address owner) external view returns (uint256);
674 
675     /**
676      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
677      */
678     // solhint-disable-next-line func-name-mixedcase
679     function DOMAIN_SEPARATOR() external view returns (bytes32);
680 }
681 
682 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
683 
684 /**
685  * @dev Collection of functions related to the address type
686  */
687 library Address {
688     /**
689      * @dev Returns true if `account` is a contract.
690      *
691      * [IMPORTANT]
692      * ====
693      * It is unsafe to assume that an address for which this function returns
694      * false is an externally-owned account (EOA) and not a contract.
695      *
696      * Among others, `isContract` will return false for the following
697      * types of addresses:
698      *
699      *  - an externally-owned account
700      *  - a contract in construction
701      *  - an address where a contract will be created
702      *  - an address where a contract lived, but was destroyed
703      *
704      * Furthermore, `isContract` will also return true if the target contract within
705      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
706      * which only has an effect at the end of a transaction.
707      * ====
708      *
709      * [IMPORTANT]
710      * ====
711      * You shouldn't rely on `isContract` to protect against flash loan attacks!
712      *
713      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
714      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
715      * constructor.
716      * ====
717      */
718     function isContract(address account) internal view returns (bool) {
719         // This method relies on extcodesize/address.code.length, which returns 0
720         // for contracts in construction, since the code is only stored at the end
721         // of the constructor execution.
722 
723         return account.code.length > 0;
724     }
725 
726     /**
727      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
728      * `recipient`, forwarding all available gas and reverting on errors.
729      *
730      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
731      * of certain opcodes, possibly making contracts go over the 2300 gas limit
732      * imposed by `transfer`, making them unable to receive funds via
733      * `transfer`. {sendValue} removes this limitation.
734      *
735      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
736      *
737      * IMPORTANT: because control is transferred to `recipient`, care must be
738      * taken to not create reentrancy vulnerabilities. Consider using
739      * {ReentrancyGuard} or the
740      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
741      */
742     function sendValue(address payable recipient, uint256 amount) internal {
743         require(address(this).balance >= amount, "Address: insufficient balance");
744 
745         (bool success, ) = recipient.call{value: amount}("");
746         require(success, "Address: unable to send value, recipient may have reverted");
747     }
748 
749     /**
750      * @dev Performs a Solidity function call using a low level `call`. A
751      * plain `call` is an unsafe replacement for a function call: use this
752      * function instead.
753      *
754      * If `target` reverts with a revert reason, it is bubbled up by this
755      * function (like regular Solidity function calls).
756      *
757      * Returns the raw returned data. To convert to the expected return value,
758      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
759      *
760      * Requirements:
761      *
762      * - `target` must be a contract.
763      * - calling `target` with `data` must not revert.
764      *
765      * _Available since v3.1._
766      */
767     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
768         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
769     }
770 
771     /**
772      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
773      * `errorMessage` as a fallback revert reason when `target` reverts.
774      *
775      * _Available since v3.1._
776      */
777     function functionCall(
778         address target,
779         bytes memory data,
780         string memory errorMessage
781     ) internal returns (bytes memory) {
782         return functionCallWithValue(target, data, 0, errorMessage);
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
787      * but also transferring `value` wei to `target`.
788      *
789      * Requirements:
790      *
791      * - the calling contract must have an ETH balance of at least `value`.
792      * - the called Solidity function must be `payable`.
793      *
794      * _Available since v3.1._
795      */
796     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
797         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
802      * with `errorMessage` as a fallback revert reason when `target` reverts.
803      *
804      * _Available since v3.1._
805      */
806     function functionCallWithValue(
807         address target,
808         bytes memory data,
809         uint256 value,
810         string memory errorMessage
811     ) internal returns (bytes memory) {
812         require(address(this).balance >= value, "Address: insufficient balance for call");
813         (bool success, bytes memory returndata) = target.call{value: value}(data);
814         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
815     }
816 
817     /**
818      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
819      * but performing a static call.
820      *
821      * _Available since v3.3._
822      */
823     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
824         return functionStaticCall(target, data, "Address: low-level static call failed");
825     }
826 
827     /**
828      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
829      * but performing a static call.
830      *
831      * _Available since v3.3._
832      */
833     function functionStaticCall(
834         address target,
835         bytes memory data,
836         string memory errorMessage
837     ) internal view returns (bytes memory) {
838         (bool success, bytes memory returndata) = target.staticcall(data);
839         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
844      * but performing a delegate call.
845      *
846      * _Available since v3.4._
847      */
848     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
849         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
850     }
851 
852     /**
853      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
854      * but performing a delegate call.
855      *
856      * _Available since v3.4._
857      */
858     function functionDelegateCall(
859         address target,
860         bytes memory data,
861         string memory errorMessage
862     ) internal returns (bytes memory) {
863         (bool success, bytes memory returndata) = target.delegatecall(data);
864         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
865     }
866 
867     /**
868      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
869      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
870      *
871      * _Available since v4.8._
872      */
873     function verifyCallResultFromTarget(
874         address target,
875         bool success,
876         bytes memory returndata,
877         string memory errorMessage
878     ) internal view returns (bytes memory) {
879         if (success) {
880             if (returndata.length == 0) {
881                 // only check isContract if the call was successful and the return data is empty
882                 // otherwise we already know that it was a contract
883                 require(isContract(target), "Address: call to non-contract");
884             }
885             return returndata;
886         } else {
887             _revert(returndata, errorMessage);
888         }
889     }
890 
891     /**
892      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
893      * revert reason or using the provided one.
894      *
895      * _Available since v4.3._
896      */
897     function verifyCallResult(
898         bool success,
899         bytes memory returndata,
900         string memory errorMessage
901     ) internal pure returns (bytes memory) {
902         if (success) {
903             return returndata;
904         } else {
905             _revert(returndata, errorMessage);
906         }
907     }
908 
909     function _revert(bytes memory returndata, string memory errorMessage) private pure {
910         // Look for revert reason and bubble it up if present
911         if (returndata.length > 0) {
912             // The easiest way to bubble the revert reason is using memory via assembly
913             /// @solidity memory-safe-assembly
914             assembly {
915                 let returndata_size := mload(returndata)
916                 revert(add(32, returndata), returndata_size)
917             }
918         } else {
919             revert(errorMessage);
920         }
921     }
922 }
923 
924 /**
925  * @title SafeERC20
926  * @dev Wrappers around ERC20 operations that throw on failure (when the token
927  * contract returns false). Tokens that return no value (and instead revert or
928  * throw on failure) are also supported, non-reverting calls are assumed to be
929  * successful.
930  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
931  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
932  */
933 library SafeERC20 {
934     using Address for address;
935 
936     /**
937      * @dev Transfer `value` amount of `token` from the calling contract to `to`. If `token` returns no value,
938      * non-reverting calls are assumed to be successful.
939      */
940     function safeTransfer(IERC20 token, address to, uint256 value) internal {
941         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
942     }
943 
944     /**
945      * @dev Transfer `value` amount of `token` from `from` to `to`, spending the approval given by `from` to the
946      * calling contract. If `token` returns no value, non-reverting calls are assumed to be successful.
947      */
948     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
949         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
950     }
951 
952     /**
953      * @dev Deprecated. This function has issues similar to the ones found in
954      * {IERC20-approve}, and its usage is discouraged.
955      *
956      * Whenever possible, use {safeIncreaseAllowance} and
957      * {safeDecreaseAllowance} instead.
958      */
959     function safeApprove(IERC20 token, address spender, uint256 value) internal {
960         // safeApprove should only be called when setting an initial allowance,
961         // or when resetting it to zero. To increase and decrease it, use
962         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
963         require(
964             (value == 0) || (token.allowance(address(this), spender) == 0),
965             "SafeERC20: approve from non-zero to non-zero allowance"
966         );
967         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
968     }
969 
970     /**
971      * @dev Increase the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
972      * non-reverting calls are assumed to be successful.
973      */
974     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
975         uint256 oldAllowance = token.allowance(address(this), spender);
976         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance + value));
977     }
978 
979     /**
980      * @dev Decrease the calling contract's allowance toward `spender` by `value`. If `token` returns no value,
981      * non-reverting calls are assumed to be successful.
982      */
983     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
984         unchecked {
985             uint256 oldAllowance = token.allowance(address(this), spender);
986             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
987             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, oldAllowance - value));
988         }
989     }
990 
991     /**
992      * @dev Set the calling contract's allowance toward `spender` to `value`. If `token` returns no value,
993      * non-reverting calls are assumed to be successful. Meant to be used with tokens that require the approval
994      * to be set to zero before setting it to a non-zero value, such as USDT.
995      */
996     function forceApprove(IERC20 token, address spender, uint256 value) internal {
997         bytes memory approvalCall = abi.encodeWithSelector(token.approve.selector, spender, value);
998 
999         if (!_callOptionalReturnBool(token, approvalCall)) {
1000             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, 0));
1001             _callOptionalReturn(token, approvalCall);
1002         }
1003     }
1004 
1005     /**
1006      * @dev Use a ERC-2612 signature to set the `owner` approval toward `spender` on `token`.
1007      * Revert on invalid signature.
1008      */
1009     function safePermit(
1010         IERC20Permit token,
1011         address owner,
1012         address spender,
1013         uint256 value,
1014         uint256 deadline,
1015         uint8 v,
1016         bytes32 r,
1017         bytes32 s
1018     ) internal {
1019         uint256 nonceBefore = token.nonces(owner);
1020         token.permit(owner, spender, value, deadline, v, r, s);
1021         uint256 nonceAfter = token.nonces(owner);
1022         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1023     }
1024 
1025     /**
1026      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1027      * on the return value: the return value is optional (but if data is returned, it must not be false).
1028      * @param token The token targeted by the call.
1029      * @param data The call data (encoded using abi.encode or one of its variants).
1030      */
1031     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1032         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1033         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1034         // the target address contains contract code and also asserts for success in the low-level call.
1035 
1036         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1037         require(returndata.length == 0 || abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1038     }
1039 
1040     /**
1041      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1042      * on the return value: the return value is optional (but if data is returned, it must not be false).
1043      * @param token The token targeted by the call.
1044      * @param data The call data (encoded using abi.encode or one of its variants).
1045      *
1046      * This is a variant of {_callOptionalReturn} that silents catches all reverts and returns a bool instead.
1047      */
1048     function _callOptionalReturnBool(IERC20 token, bytes memory data) private returns (bool) {
1049         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1050         // we're implementing it ourselves. We cannot use {Address-functionCall} here since this should return false
1051         // and not revert is the subcall reverts.
1052 
1053         (bool success, bytes memory returndata) = address(token).call(data);
1054         return
1055             success && (returndata.length == 0 || abi.decode(returndata, (bool))) && Address.isContract(address(token));
1056     }
1057 }
1058 
1059 
1060 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1061 
1062 /**
1063  * @dev Contract module which provides a basic access control mechanism, where
1064  * there is an account (an owner) that can be granted exclusive access to
1065  * specific functions.
1066  *
1067  * By default, the owner account will be the one that deploys the contract. This
1068  * can later be changed with {transferOwnership}.
1069  *
1070  * This module is used through inheritance. It will make available the modifier
1071  * `onlyOwner`, which can be applied to your functions to restrict their use to
1072  * the owner.
1073  */
1074 abstract contract Ownable is Context {
1075     address private _owner;
1076 
1077     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1078 
1079     /**
1080      * @dev Initializes the contract setting the deployer as the initial owner.
1081      */
1082     constructor() {
1083         _transferOwnership(_msgSender());
1084     }
1085 
1086     /**
1087      * @dev Throws if called by any account other than the owner.
1088      */
1089     modifier onlyOwner() {
1090         _checkOwner();
1091         _;
1092     }
1093 
1094     /**
1095      * @dev Returns the address of the current owner.
1096      */
1097     function owner() public view virtual returns (address) {
1098         return _owner;
1099     }
1100 
1101     /**
1102      * @dev Throws if the sender is not the owner.
1103      */
1104     function _checkOwner() internal view virtual {
1105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1106     }
1107 
1108     /**
1109      * @dev Leaves the contract without owner. It will not be possible to call
1110      * `onlyOwner` functions. Can only be called by the current owner.
1111      *
1112      * NOTE: Renouncing ownership will leave the contract without an owner,
1113      * thereby disabling any functionality that is only available to the owner.
1114      */
1115     function renounceOwnership() public virtual onlyOwner {
1116         _transferOwnership(address(0));
1117     }
1118 
1119     /**
1120      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1121      * Can only be called by the current owner.
1122      */
1123     function transferOwnership(address newOwner) public virtual onlyOwner {
1124         require(newOwner != address(0), "Ownable: new owner is the zero address");
1125         _transferOwnership(newOwner);
1126     }
1127 
1128     /**
1129      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1130      * Internal function without access restriction.
1131      */
1132     function _transferOwnership(address newOwner) internal virtual {
1133         address oldOwner = _owner;
1134         _owner = newOwner;
1135         emit OwnershipTransferred(oldOwner, newOwner);
1136     }
1137 }
1138 
1139 
1140 contract WiskersToken is ERC20, Ownable {
1141     using SafeERC20 for IERC20;
1142 
1143     event UpdateTaxRouter(address router);
1144     event UpdateTax(address receiver, uint256 tax);
1145     event EnableTrading();
1146     event SetPair(address pair, bool state);
1147 
1148     mapping(address => bool) public pairs;
1149     uint256 public taxPercent = 5000;
1150     address public taxWallet;
1151     address public router;
1152     uint256 public constant taxThreshold = 100 * 10 ** 18;
1153 
1154     bool public isTradingLive;
1155     uint256 public lpTimestamp;
1156     uint24 public immutable antiBotMaxWallet;
1157     uint24 public immutable antiBotMaxBuy;
1158     uint24 public immutable antiBotMaxBuysPerBlock;
1159     mapping(uint256 => uint256) public buysPerBlock;
1160     mapping(address => mapping(uint256 => bool)) public buysPerBlockWallet;
1161 
1162     constructor(
1163         address _taxWallet,
1164         uint24 _antiBotMaxBuy,
1165         uint24 _antiBotMaxWallet,
1166         uint24 _antiBotMaxBuysPerBlock
1167     ) ERC20("Wiskers", "WSKR") {
1168         antiBotMaxBuy = _antiBotMaxBuy;
1169         antiBotMaxWallet = _antiBotMaxWallet;
1170         antiBotMaxBuysPerBlock = _antiBotMaxBuysPerBlock;
1171 
1172         taxWallet = _taxWallet;
1173         _mint(msg.sender, 100_000_000e18);
1174     }
1175 
1176     function setTax(address _wallet, uint256 _tax) external onlyOwner {
1177         if (_tax > 5000) revert("TaxOutOfBounds");
1178         taxPercent = _tax;
1179         taxWallet = _wallet;
1180         emit UpdateTax(_wallet, _tax);
1181     }
1182 
1183     function setTaxRouter(address _router) external onlyOwner {
1184         if (router != address(0)) _approve(address(this), router, 0);
1185         router = _router;
1186         _approve(address(this), router, type(uint256).max); 
1187         emit UpdateTaxRouter(_router);
1188     }
1189 
1190     function setPair(address _pair, bool _state) external onlyOwner {
1191         pairs[_pair] = _state;
1192         emit SetPair(_pair, _state);
1193     }
1194 
1195     function enableTrading() external onlyOwner {
1196         if (router == address(0)) revert("InvalidRouter");
1197         isTradingLive = true;
1198         lpTimestamp = block.timestamp;
1199         emit EnableTrading();
1200     }
1201 
1202     bool inSwap;
1203     modifier isSwapping() {
1204         if (inSwap == true) revert("inSwap");
1205         inSwap = true;
1206         _;
1207         inSwap = false;
1208     }
1209 
1210     function _sellTax() internal isSwapping {
1211         address _router = router;
1212         address[] memory path = new address[](2);
1213         path[0] = address(this);
1214         path[1] = IUniswapV2Router02(_router).WETH();
1215 
1216         IUniswapV2Router02(_router)
1217             .swapExactTokensForTokensSupportingFeeOnTransferTokens(
1218                 balanceOf(address(this)),
1219                 0,
1220                 path,
1221                 taxWallet,
1222                 block.timestamp
1223             );
1224     }
1225 
1226     function _handleTax(
1227         address from,
1228         address to,
1229         uint256 amount
1230     ) internal returns (uint256 amountLeft) {
1231         if (!isTradingLive && (from != owner() && to != owner())) {
1232             revert("TradingDisabled");
1233         }
1234 
1235         amountLeft = amount;
1236         if (isTradingLive && (taxPercent > 0) && (pairs[from] || pairs[to])) {
1237             if (amount < 100_000) {
1238                 revert("MinTransfer");
1239             }
1240 
1241             uint256 tax = (amount * taxPercent) / 100_000;
1242             amountLeft = (amount - tax);
1243             _transfer(from, address(this), tax);
1244 
1245             if (
1246                 (pairs[from]) &&
1247                 ((block.timestamp - lpTimestamp) < 4 minutes) &&
1248                 to != address(this)
1249             ) {
1250                 if (block.timestamp <= lpTimestamp) {
1251                     revert("NotAtStartTime");
1252                 }
1253 
1254                 if (!pairs[msg.sender] && msg.sender != tx.origin) {
1255                     revert("NoKatana");
1256                 }
1257 
1258                 if (amountLeft > (totalSupply() * antiBotMaxBuy) / 100_000) {
1259                     revert("MaxBuy");
1260                 }
1261 
1262                 if (
1263                     (balanceOf(to) + amountLeft) >
1264                     (totalSupply() * antiBotMaxWallet) / 100_000
1265                 ) {
1266                     revert("MaxWallet");
1267                 }
1268 
1269                 if (buysPerBlockWallet[msg.sender][block.number]) {
1270                     revert("WalletAlreadyBoughtInBlock");
1271                 } else {
1272                     buysPerBlockWallet[msg.sender][block.number] = true;
1273                 }
1274 
1275                 ++buysPerBlock[block.number];
1276                 if (buysPerBlock[block.number] > antiBotMaxBuysPerBlock) {
1277                     revert("BlockOverbought");
1278                 }
1279             }
1280         }
1281         if (
1282             !pairs[msg.sender] &&
1283             !inSwap &&
1284             (balanceOf(address(this)) > taxThreshold)
1285         ) {
1286             _sellTax();
1287         }
1288     }
1289 
1290     function transfer(
1291         address to,
1292         uint256 amount
1293     ) public virtual override returns (bool) {
1294         _transfer(msg.sender, to, _handleTax(msg.sender, to, amount));
1295         return true;
1296     }
1297 
1298     function transferFrom(
1299         address from,
1300         address to,
1301         uint256 amount
1302     ) public virtual override returns (bool) {
1303         _spendAllowance(from, msg.sender, amount);
1304         _transfer(from, to, _handleTax(from, to, amount));
1305         return true;
1306     }
1307 
1308     function recoverETH() external onlyOwner {
1309         uint256 balance = address(this).balance;
1310         (bool success, ) = payable(msg.sender).call{value: balance}("");
1311         require(success, "!recoverETH");
1312     }
1313 
1314     function recoverToken(IERC20 token) external onlyOwner {
1315         token.safeTransfer(msg.sender, token.balanceOf(address(this)));
1316     }
1317 }