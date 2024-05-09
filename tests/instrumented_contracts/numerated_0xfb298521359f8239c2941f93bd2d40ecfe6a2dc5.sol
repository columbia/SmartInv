1 // ██████╗ ███████╗████████╗ █████╗
2 // ██╔══██╗██╔════╝╚══██╔══╝██╔══██╗
3 // ██║  ██║█████╗     ██║   ███████║
4 // ██║  ██║██╔══╝     ██║   ██╔══██║
5 // ██████╔╝███████╗   ██║   ██║  ██║
6 // ╚═════╝ ╚══════╝   ╚═╝   ╚═╝  ╚═╝
7 
8 // Token: Deta Finance
9 // Website: https://deta.io
10 // Twitter: https://twitter.com/detafinance
11 // Telegram: https://t.me/detafinance
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity 0.8.18;
15 
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
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Emitted when `value` tokens are moved from one account (`from`) to
32      * another (`to`).
33      *
34      * Note that `value` may be zero.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /**
39      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
40      * a call to {approve}. `value` is the new allowance.
41      */
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 
48     /**
49      * @dev Returns the amount of tokens in existence.
50      */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54      * @dev Returns the amount of tokens owned by `account`.
55      */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59      * @dev Moves `amount` tokens from the caller's account to `to`.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transfer(address to, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Returns the remaining number of tokens that `spender` will be
69      * allowed to spend on behalf of `owner` through {transferFrom}. This is
70      * zero by default.
71      *
72      * This value changes when {approve} or {transferFrom} are called.
73      */
74     function allowance(
75         address owner,
76         address spender
77     ) external view returns (uint256);
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
111 interface IERC20Metadata is IERC20 {
112     /**
113      * @dev Returns the name of the token.
114      */
115     function name() external view returns (string memory);
116 
117     /**
118      * @dev Returns the symbol of the token.
119      */
120     function symbol() external view returns (string memory);
121 
122     /**
123      * @dev Returns the decimals places of the token.
124      */
125     function decimals() external view returns (uint8);
126 }
127 
128 contract ERC20 is Context, IERC20, IERC20Metadata {
129     mapping(address => uint256) private _balances;
130 
131     mapping(address => mapping(address => uint256)) private _allowances;
132 
133     uint256 private _totalSupply;
134 
135     string private _name;
136     string private _symbol;
137 
138     /**
139      * @dev Sets the values for {name} and {symbol}.
140      *
141      * The default value of {decimals} is 18. To select a different value for
142      * {decimals} you should overload it.
143      *
144      * All two of these values are immutable: they can only be set once during
145      * construction.
146      */
147     constructor(string memory name_, string memory symbol_) {
148         _name = name_;
149         _symbol = symbol_;
150     }
151 
152     /**
153      * @dev Returns the name of the token.
154      */
155     function name() public view virtual override returns (string memory) {
156         return _name;
157     }
158 
159     /**
160      * @dev Returns the symbol of the token, usually a shorter version of the
161      * name.
162      */
163     function symbol() public view virtual override returns (string memory) {
164         return _symbol;
165     }
166 
167     /**
168      * @dev Returns the number of decimals used to get its user representation.
169      * For example, if `decimals` equals `2`, a balance of `505` tokens should
170      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
171      *
172      * Tokens usually opt for a value of 18, imitating the relationship between
173      * Ether and Wei. This is the value {ERC20} uses, unless this function is
174      * overridden;
175      *
176      * NOTE: This information is only used for _display_ purposes: it in
177      * no way affects any of the arithmetic of the contract, including
178      * {IERC20-balanceOf} and {IERC20-transfer}.
179      */
180     function decimals() public view virtual override returns (uint8) {
181         return 18;
182     }
183 
184     /**
185      * @dev See {IERC20-totalSupply}.
186      */
187     function totalSupply() public view virtual override returns (uint256) {
188         return _totalSupply;
189     }
190 
191     /**
192      * @dev See {IERC20-balanceOf}.
193      */
194     function balanceOf(
195         address account
196     ) public view virtual override returns (uint256) {
197         return _balances[account];
198     }
199 
200     /**
201      * @dev See {IERC20-transfer}.
202      *
203      * Requirements:
204      *
205      * - `to` cannot be the zero address.
206      * - the caller must have a balance of at least `amount`.
207      */
208     function transfer(
209         address to,
210         uint256 amount
211     ) public virtual override returns (bool) {
212         address owner = _msgSender();
213         _transfer(owner, to, amount);
214         return true;
215     }
216 
217     /**
218      * @dev See {IERC20-allowance}.
219      */
220     function allowance(
221         address owner,
222         address spender
223     ) public view virtual override returns (uint256) {
224         return _allowances[owner][spender];
225     }
226 
227     /**
228      * @dev See {IERC20-approve}.
229      *
230      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
231      * `transferFrom`. This is semantically equivalent to an infinite approval.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function approve(
238         address spender,
239         uint256 amount
240     ) public virtual override returns (bool) {
241         address owner = _msgSender();
242         _approve(owner, spender, amount);
243         return true;
244     }
245 
246     /**
247      * @dev See {IERC20-transferFrom}.
248      *
249      * Emits an {Approval} event indicating the updated allowance. This is not
250      * required by the EIP. See the note at the beginning of {ERC20}.
251      *
252      * NOTE: Does not update the allowance if the current allowance
253      * is the maximum `uint256`.
254      *
255      * Requirements:
256      *
257      * - `from` and `to` cannot be the zero address.
258      * - `from` must have a balance of at least `amount`.
259      * - the caller must have allowance for ``from``'s tokens of at least
260      * `amount`.
261      */
262     function transferFrom(
263         address from,
264         address to,
265         uint256 amount
266     ) public virtual override returns (bool) {
267         address spender = _msgSender();
268         _spendAllowance(from, spender, amount);
269         _transfer(from, to, amount);
270         return true;
271     }
272 
273     /**
274      * @dev Atomically increases the allowance granted to `spender` by the caller.
275      *
276      * This is an alternative to {approve} that can be used as a mitigation for
277      * problems described in {IERC20-approve}.
278      *
279      * Emits an {Approval} event indicating the updated allowance.
280      *
281      * Requirements:
282      *
283      * - `spender` cannot be the zero address.
284      */
285     function increaseAllowance(
286         address spender,
287         uint256 addedValue
288     ) public virtual returns (bool) {
289         address owner = _msgSender();
290         _approve(owner, spender, allowance(owner, spender) + addedValue);
291         return true;
292     }
293 
294     /**
295      * @dev Atomically decreases the allowance granted to `spender` by the caller.
296      *
297      * This is an alternative to {approve} that can be used as a mitigation for
298      * problems described in {IERC20-approve}.
299      *
300      * Emits an {Approval} event indicating the updated allowance.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      * - `spender` must have allowance for the caller of at least
306      * `subtractedValue`.
307      */
308     function decreaseAllowance(
309         address spender,
310         uint256 subtractedValue
311     ) public virtual returns (bool) {
312         address owner = _msgSender();
313         uint256 currentAllowance = allowance(owner, spender);
314         require(
315             currentAllowance >= subtractedValue,
316             "ERC20: decreased allowance below zero"
317         );
318         unchecked {
319             _approve(owner, spender, currentAllowance - subtractedValue);
320         }
321 
322         return true;
323     }
324 
325     /**
326      * @dev Moves `amount` of tokens from `from` to `to`.
327      *
328      * This internal function is equivalent to {transfer}, and can be used to
329      * e.g. implement automatic token fees, slashing mechanisms, etc.
330      *
331      * Emits a {Transfer} event.
332      *
333      * Requirements:
334      *
335      * - `from` cannot be the zero address.
336      * - `to` cannot be the zero address.
337      * - `from` must have a balance of at least `amount`.
338      */
339     function _transfer(
340         address from,
341         address to,
342         uint256 amount
343     ) internal virtual {
344         require(from != address(0), "ERC20: transfer from the zero address");
345         require(to != address(0), "ERC20: transfer to the zero address");
346 
347         _beforeTokenTransfer(from, to, amount);
348 
349         uint256 fromBalance = _balances[from];
350         require(
351             fromBalance >= amount,
352             "ERC20: transfer amount exceeds balance"
353         );
354         unchecked {
355             _balances[from] = fromBalance - amount;
356             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
357             // decrementing then incrementing.
358             _balances[to] += amount;
359         }
360 
361         emit Transfer(from, to, amount);
362 
363         _afterTokenTransfer(from, to, amount);
364     }
365 
366     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
367      * the total supply.
368      *
369      * Emits a {Transfer} event with `from` set to the zero address.
370      *
371      * Requirements:
372      *
373      * - `account` cannot be the zero address.
374      */
375     function _mint(address account, uint256 amount) internal virtual {
376         require(account != address(0), "ERC20: mint to the zero address");
377 
378         _beforeTokenTransfer(address(0), account, amount);
379 
380         _totalSupply += amount;
381         unchecked {
382             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
383             _balances[account] += amount;
384         }
385         emit Transfer(address(0), account, amount);
386 
387         _afterTokenTransfer(address(0), account, amount);
388     }
389 
390     /**
391      * @dev Destroys `amount` tokens from `account`, reducing the
392      * total supply.
393      *
394      * Emits a {Transfer} event with `to` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      * - `account` must have at least `amount` tokens.
400      */
401     function _burn(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: burn from the zero address");
403 
404         _beforeTokenTransfer(account, address(0), amount);
405 
406         uint256 accountBalance = _balances[account];
407         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
408         unchecked {
409             _balances[account] = accountBalance - amount;
410             // Overflow not possible: amount <= accountBalance <= totalSupply.
411             _totalSupply -= amount;
412         }
413 
414         emit Transfer(account, address(0), amount);
415 
416         _afterTokenTransfer(account, address(0), amount);
417     }
418 
419     /**
420      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
421      *
422      * This internal function is equivalent to `approve`, and can be used to
423      * e.g. set automatic allowances for certain subsystems, etc.
424      *
425      * Emits an {Approval} event.
426      *
427      * Requirements:
428      *
429      * - `owner` cannot be the zero address.
430      * - `spender` cannot be the zero address.
431      */
432     function _approve(
433         address owner,
434         address spender,
435         uint256 amount
436     ) internal virtual {
437         require(owner != address(0), "ERC20: approve from the zero address");
438         require(spender != address(0), "ERC20: approve to the zero address");
439 
440         _allowances[owner][spender] = amount;
441         emit Approval(owner, spender, amount);
442     }
443 
444     /**
445      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
446      *
447      * Does not update the allowance amount in case of infinite allowance.
448      * Revert if not enough allowance is available.
449      *
450      * Might emit an {Approval} event.
451      */
452     function _spendAllowance(
453         address owner,
454         address spender,
455         uint256 amount
456     ) internal virtual {
457         uint256 currentAllowance = allowance(owner, spender);
458         if (currentAllowance != type(uint256).max) {
459             require(
460                 currentAllowance >= amount,
461                 "ERC20: insufficient allowance"
462             );
463             unchecked {
464                 _approve(owner, spender, currentAllowance - amount);
465             }
466         }
467     }
468 
469     /**
470      * @dev Hook that is called before any transfer of tokens. This includes
471      * minting and burning.
472      *
473      * Calling conditions:
474      *
475      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
476      * will be transferred to `to`.
477      * - when `from` is zero, `amount` tokens will be minted for `to`.
478      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
479      * - `from` and `to` are never both zero.
480      *
481      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
482      */
483     function _beforeTokenTransfer(
484         address from,
485         address to,
486         uint256 amount
487     ) internal virtual {}
488 
489     /**
490      * @dev Hook that is called after any transfer of tokens. This includes
491      * minting and burning.
492      *
493      * Calling conditions:
494      *
495      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
496      * has been transferred to `to`.
497      * - when `from` is zero, `amount` tokens have been minted for `to`.
498      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
499      * - `from` and `to` are never both zero.
500      *
501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
502      */
503     function _afterTokenTransfer(
504         address from,
505         address to,
506         uint256 amount
507     ) internal virtual {}
508 }
509 
510 abstract contract ERC20Burnable is Context, ERC20 {
511     /**
512      * @dev Destroys `amount` tokens from the caller.
513      *
514      * See {ERC20-_burn}.
515      */
516     function burn(uint256 amount) public virtual {
517         _burn(_msgSender(), amount);
518     }
519 
520     /**
521      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
522      * allowance.
523      *
524      * See {ERC20-_burn} and {ERC20-allowance}.
525      *
526      * Requirements:
527      *
528      * - the caller must have allowance for ``accounts``'s tokens of at least
529      * `amount`.
530      */
531     function burnFrom(address account, uint256 amount) public virtual {
532         _spendAllowance(account, _msgSender(), amount);
533         _burn(account, amount);
534     }
535 }
536 
537 contract DetaFinance is ERC20, ERC20Burnable {
538     constructor() ERC20("Deta Finance", "DETA") {
539         _mint(msg.sender, 800_000_000 ether);
540     }
541 
542     function _beforeTokenTransfer(
543         address from,
544         address to,
545         uint256 amount
546     ) internal override(ERC20) {
547         super._beforeTokenTransfer(from, to, amount);
548     }
549 
550     function _transfer(
551         address sender,
552         address recipient,
553         uint256 amount
554     ) internal virtual override(ERC20) {
555         super._transfer(sender, recipient, amount);
556     }
557 }