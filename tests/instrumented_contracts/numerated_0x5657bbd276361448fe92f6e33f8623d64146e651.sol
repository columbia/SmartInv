1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
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
29 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Emitted when `value` tokens are moved from one account (`from`) to
39      * another (`to`).
40      *
41      * Note that `value` may be zero.
42      */
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 
45     /**
46      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
47      * a call to {approve}. `value` is the new allowance.
48      */
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 
51     /**
52      * @dev Returns the amount of tokens in existence.
53      */
54     function totalSupply() external view returns (uint256);
55 
56     /**
57      * @dev Returns the amount of tokens owned by `account`.
58      */
59     function balanceOf(address account) external view returns (uint256);
60 
61     /**
62      * @dev Moves `amount` tokens from the caller's account to `to`.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transfer(address to, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Returns the remaining number of tokens that `spender` will be
72      * allowed to spend on behalf of `owner` through {transferFrom}. This is
73      * zero by default.
74      *
75      * This value changes when {approve} or {transferFrom} are called.
76      */
77     function allowance(address owner, address spender) external view returns (uint256);
78 
79     /**
80      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * IMPORTANT: Beware that changing an allowance with this method brings the risk
85      * that someone may use both the old and the new allowance by unfortunate
86      * transaction ordering. One possible solution to mitigate this race
87      * condition is to first reduce the spender's allowance to 0 and set the
88      * desired value afterwards:
89      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
90      *
91      * Emits an {Approval} event.
92      */
93     function approve(address spender, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Moves `amount` tokens from `from` to `to` using the
97      * allowance mechanism. `amount` is then deducted from the caller's
98      * allowance.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 amount
108     ) external returns (bool);
109 }
110 
111 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Interface for the optional metadata functions from the ERC20 standard.
117  *
118  * _Available since v4.1._
119  */
120 interface IERC20Metadata is IERC20 {
121     /**
122      * @dev Returns the name of the token.
123      */
124     function name() external view returns (string memory);
125 
126     /**
127      * @dev Returns the symbol of the token.
128      */
129     function symbol() external view returns (string memory);
130 
131     /**
132      * @dev Returns the decimals places of the token.
133      */
134     function decimals() external view returns (uint8);
135 }
136 
137 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Implementation of the {IERC20} interface.
143  *
144  * This implementation is agnostic to the way tokens are created. This means
145  * that a supply mechanism has to be added in a derived contract using {_mint}.
146  * For a generic mechanism see {ERC20PresetMinterPauser}.
147  *
148  * TIP: For a detailed writeup see our guide
149  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
150  * to implement supply mechanisms].
151  *
152  * We have followed general OpenZeppelin Contracts guidelines: functions revert
153  * instead returning `false` on failure. This behavior is nonetheless
154  * conventional and does not conflict with the expectations of ERC20
155  * applications.
156  *
157  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
158  * This allows applications to reconstruct the allowance for all accounts just
159  * by listening to said events. Other implementations of the EIP may not emit
160  * these events, as it isn't required by the specification.
161  *
162  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
163  * functions have been added to mitigate the well-known issues around setting
164  * allowances. See {IERC20-approve}.
165  */
166 contract ERC20 is Context, IERC20, IERC20Metadata {
167     mapping(address => uint256) private _balances;
168 
169     mapping(address => mapping(address => uint256)) private _allowances;
170 
171     uint256 private _totalSupply;
172 
173     string private _name;
174     string private _symbol;
175 
176     /**
177      * @dev Sets the values for {name} and {symbol}.
178      *
179      * The default value of {decimals} is 18. To select a different value for
180      * {decimals} you should overload it.
181      *
182      * All two of these values are immutable: they can only be set once during
183      * construction.
184      */
185     constructor(string memory name_, string memory symbol_) {
186         _name = name_;
187         _symbol = symbol_;
188     }
189 
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() public view virtual override returns (string memory) {
194         return _name;
195     }
196 
197     /**
198      * @dev Returns the symbol of the token, usually a shorter version of the
199      * name.
200      */
201     function symbol() public view virtual override returns (string memory) {
202         return _symbol;
203     }
204 
205     /**
206      * @dev Returns the number of decimals used to get its user representation.
207      * For example, if `decimals` equals `2`, a balance of `505` tokens should
208      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
209      *
210      * Tokens usually opt for a value of 18, imitating the relationship between
211      * Ether and Wei. This is the value {ERC20} uses, unless this function is
212      * overridden;
213      *
214      * NOTE: This information is only used for _display_ purposes: it in
215      * no way affects any of the arithmetic of the contract, including
216      * {IERC20-balanceOf} and {IERC20-transfer}.
217      */
218     function decimals() public view virtual override returns (uint8) {
219         return 18;
220     }
221 
222     /**
223      * @dev See {IERC20-totalSupply}.
224      */
225     function totalSupply() public view virtual override returns (uint256) {
226         return _totalSupply;
227     }
228 
229     /**
230      * @dev See {IERC20-balanceOf}.
231      */
232     function balanceOf(address account) public view virtual override returns (uint256) {
233         return _balances[account];
234     }
235 
236     /**
237      * @dev See {IERC20-transfer}.
238      *
239      * Requirements:
240      *
241      * - `to` cannot be the zero address.
242      * - the caller must have a balance of at least `amount`.
243      */
244     function transfer(address to, uint256 amount) public virtual override returns (bool) {
245         address owner = _msgSender();
246         _transfer(owner, to, amount);
247         return true;
248     }
249 
250     /**
251      * @dev See {IERC20-allowance}.
252      */
253     function allowance(address owner, address spender) public view virtual override returns (uint256) {
254         return _allowances[owner][spender];
255     }
256 
257     /**
258      * @dev See {IERC20-approve}.
259      *
260      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
261      * `transferFrom`. This is semantically equivalent to an infinite approval.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         address owner = _msgSender();
269         _approve(owner, spender, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-transferFrom}.
275      *
276      * Emits an {Approval} event indicating the updated allowance. This is not
277      * required by the EIP. See the note at the beginning of {ERC20}.
278      *
279      * NOTE: Does not update the allowance if the current allowance
280      * is the maximum `uint256`.
281      *
282      * Requirements:
283      *
284      * - `from` and `to` cannot be the zero address.
285      * - `from` must have a balance of at least `amount`.
286      * - the caller must have allowance for ``from``'s tokens of at least
287      * `amount`.
288      */
289     function transferFrom(
290         address from,
291         address to,
292         uint256 amount
293     ) public virtual override returns (bool) {
294         address spender = _msgSender();
295         _spendAllowance(from, spender, amount);
296         _transfer(from, to, amount);
297         return true;
298     }
299 
300     /**
301      * @dev Atomically increases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
313         address owner = _msgSender();
314         _approve(owner, spender, allowance(owner, spender) + addedValue);
315         return true;
316     }
317 
318     /**
319      * @dev Atomically decreases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      * - `spender` must have allowance for the caller of at least
330      * `subtractedValue`.
331      */
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         address owner = _msgSender();
334         uint256 currentAllowance = allowance(owner, spender);
335         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
336         unchecked {
337             _approve(owner, spender, currentAllowance - subtractedValue);
338         }
339 
340         return true;
341     }
342 
343     /**
344      * @dev Moves `amount` of tokens from `from` to `to`.
345      *
346      * This internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `from` cannot be the zero address.
354      * - `to` cannot be the zero address.
355      * - `from` must have a balance of at least `amount`.
356      */
357     function _transfer(
358         address from,
359         address to,
360         uint256 amount
361     ) internal virtual {
362         require(from != address(0), "ERC20: transfer from the zero address");
363         require(to != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(from, to, amount);
366 
367         uint256 fromBalance = _balances[from];
368         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
369         unchecked {
370             _balances[from] = fromBalance - amount;
371             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
372             // decrementing then incrementing.
373             _balances[to] += amount;
374         }
375 
376         emit Transfer(from, to, amount);
377 
378         _afterTokenTransfer(from, to, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _beforeTokenTransfer(address(0), account, amount);
394 
395         _totalSupply += amount;
396         unchecked {
397             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
398             _balances[account] += amount;
399         }
400         emit Transfer(address(0), account, amount);
401 
402         _afterTokenTransfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         unchecked {
424             _balances[account] = accountBalance - amount;
425             // Overflow not possible: amount <= accountBalance <= totalSupply.
426             _totalSupply -= amount;
427         }
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
460      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
461      *
462      * Does not update the allowance amount in case of infinite allowance.
463      * Revert if not enough allowance is available.
464      *
465      * Might emit an {Approval} event.
466      */
467     function _spendAllowance(
468         address owner,
469         address spender,
470         uint256 amount
471     ) internal virtual {
472         uint256 currentAllowance = allowance(owner, spender);
473         if (currentAllowance != type(uint256).max) {
474             require(currentAllowance >= amount, "ERC20: insufficient allowance");
475             unchecked {
476                 _approve(owner, spender, currentAllowance - amount);
477             }
478         }
479     }
480 
481     /**
482      * @dev Hook that is called before any transfer of tokens. This includes
483      * minting and burning.
484      *
485      * Calling conditions:
486      *
487      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
488      * will be transferred to `to`.
489      * - when `from` is zero, `amount` tokens will be minted for `to`.
490      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
491      * - `from` and `to` are never both zero.
492      *
493      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
494      */
495     function _beforeTokenTransfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal virtual {}
500 
501     /**
502      * @dev Hook that is called after any transfer of tokens. This includes
503      * minting and burning.
504      *
505      * Calling conditions:
506      *
507      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
508      * has been transferred to `to`.
509      * - when `from` is zero, `amount` tokens have been minted for `to`.
510      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
511      * - `from` and `to` are never both zero.
512      *
513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
514      */
515     function _afterTokenTransfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {}
520 }
521 
522 abstract contract ERC20Decimals is ERC20 {
523     uint8 private immutable _decimals;
524 
525     constructor(uint8 decimals_) {
526         _decimals = decimals_;
527     }
528 
529     function decimals() public view virtual override returns (uint8) {
530         return _decimals;
531     }
532 }
533 
534 contract GRYPHON is ERC20Decimals {
535     constructor() ERC20("Behind the Magic", "GRYPHON") ERC20Decimals(18) {
536 
537         _mint(_msgSender(), 451_246_134_720 * (10**18));
538 
539     }
540 
541     function decimals() public view virtual override returns (uint8) {
542         return super.decimals();
543     }
544 }