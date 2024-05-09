1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Emitted when `value` tokens are moved from one account (`from`) to
10      * another (`to`).
11      *
12      * Note that `value` may be zero.
13      */
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     /**
17      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
18      * a call to {approve}. `value` is the new allowance.
19      */
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `to`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address to, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `from` to `to` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(
76         address from,
77         address to,
78         uint256 amount
79     ) external returns (bool);
80 }
81 
82 pragma solidity ^0.8.0;
83 /**
84  * @dev Interface for the optional metadata functions from the ERC20 standard.
85  *
86  * _Available since v4.1._
87  */
88 interface IERC20Metadata is IERC20 {
89     /**
90      * @dev Returns the name of the token.
91      */
92     function name() external view returns (string memory);
93 
94     /**
95      * @dev Returns the symbol of the token.
96      */
97     function symbol() external view returns (string memory);
98 
99     /**
100      * @dev Returns the decimals places of the token.
101      */
102     function decimals() external view returns (uint8);
103 }
104 
105 pragma solidity ^0.8.0;
106 /**
107  * @dev Provides information about the current execution context, including the
108  * sender of the transaction and its data. While these are generally available
109  * via msg.sender and msg.data, they should not be accessed in such a direct
110  * manner, since when dealing with meta-transactions the account sending and
111  * paying for execution may not be the actual sender (as far as an application
112  * is concerned).
113  *
114  * This contract is only required for intermediate, library-like contracts.
115  */
116 abstract contract Context {
117     function _msgSender() internal view virtual returns (address) {
118         return msg.sender;
119     }
120 
121     function _msgData() internal view virtual returns (bytes calldata) {
122         return msg.data;
123     }
124 }
125 
126 pragma solidity ^0.8.0;
127 /**
128  * @dev Implementation of the {IERC20} interface.
129  *
130  * This implementation is agnostic to the way tokens are created. This means
131  * that a supply mechanism has to be added in a derived contract using {_mint}.
132  * For a generic mechanism see {ERC20PresetMinterPauser}.
133  *
134  * TIP: For a detailed writeup see our guide
135  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
136  * to implement supply mechanisms].
137  *
138  * We have followed general OpenZeppelin Contracts guidelines: functions revert
139  * instead returning `false` on failure. This behavior is nonetheless
140  * conventional and does not conflict with the expectations of ERC20
141  * applications.
142  *
143  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
144  * This allows applications to reconstruct the allowance for all accounts just
145  * by listening to said events. Other implementations of the EIP may not emit
146  * these events, as it isn't required by the specification.
147  *
148  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
149  * functions have been added to mitigate the well-known issues around setting
150  * allowances. See {IERC20-approve}.
151  */
152 contract ERC20 is Context, IERC20, IERC20Metadata {
153     mapping(address => uint256) private _balances;
154 
155     mapping(address => mapping(address => uint256)) private _allowances;
156 
157     uint256 private _totalSupply;
158 
159     string private _name;
160     string private _symbol;
161 
162     /**
163      * @dev Sets the values for {name} and {symbol}.
164      *
165      * The default value of {decimals} is 18. To select a different value for
166      * {decimals} you should overload it.
167      *
168      * All two of these values are immutable: they can only be set once during
169      * construction.
170      */
171     constructor(string memory name_, string memory symbol_) {
172         _name = name_;
173         _symbol = symbol_;
174     }
175 
176     /**
177      * @dev Returns the name of the token.
178      */
179     function name() public view virtual override returns (string memory) {
180         return _name;
181     }
182 
183     /**
184      * @dev Returns the symbol of the token, usually a shorter version of the
185      * name.
186      */
187     function symbol() public view virtual override returns (string memory) {
188         return _symbol;
189     }
190 
191     /**
192      * @dev Returns the number of decimals used to get its user representation.
193      * For example, if `decimals` equals `2`, a balance of `505` tokens should
194      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
195      *
196      * Tokens usually opt for a value of 18, imitating the relationship between
197      * Ether and Wei. This is the value {ERC20} uses, unless this function is
198      * overridden;
199      *
200      * NOTE: This information is only used for _display_ purposes: it in
201      * no way affects any of the arithmetic of the contract, including
202      * {IERC20-balanceOf} and {IERC20-transfer}.
203      */
204     function decimals() public view virtual override returns (uint8) {
205         return 18;
206     }
207 
208     /**
209      * @dev See {IERC20-totalSupply}.
210      */
211     function totalSupply() public view virtual override returns (uint256) {
212         return _totalSupply;
213     }
214 
215     /**
216      * @dev See {IERC20-balanceOf}.
217      */
218     function balanceOf(address account) public view virtual override returns (uint256) {
219         return _balances[account];
220     }
221 
222     /**
223      * @dev See {IERC20-transfer}.
224      *
225      * Requirements:
226      *
227      * - `to` cannot be the zero address.
228      * - the caller must have a balance of at least `amount`.
229      */
230     function transfer(address to, uint256 amount) public virtual override returns (bool) {
231         address owner = _msgSender();
232         _transfer(owner, to, amount);
233         return true;
234     }
235 
236     /**
237      * @dev See {IERC20-allowance}.
238      */
239     function allowance(address owner, address spender) public view virtual override returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     /**
244      * @dev See {IERC20-approve}.
245      *
246      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
247      * `transferFrom`. This is semantically equivalent to an infinite approval.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      */
253     function approve(address spender, uint256 amount) public virtual override returns (bool) {
254         address owner = _msgSender();
255         _approve(owner, spender, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-transferFrom}.
261      *
262      * Emits an {Approval} event indicating the updated allowance. This is not
263      * required by the EIP. See the note at the beginning of {ERC20}.
264      *
265      * NOTE: Does not update the allowance if the current allowance
266      * is the maximum `uint256`.
267      *
268      * Requirements:
269      *
270      * - `from` and `to` cannot be the zero address.
271      * - `from` must have a balance of at least `amount`.
272      * - the caller must have allowance for ``from``'s tokens of at least
273      * `amount`.
274      */
275     function transferFrom(
276         address from,
277         address to,
278         uint256 amount
279     ) public virtual override returns (bool) {
280         address spender = _msgSender();
281         _spendAllowance(from, spender, amount);
282         _transfer(from, to, amount);
283         return true;
284     }
285 
286     /**
287      * @dev Atomically increases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to {approve} that can be used as a mitigation for
290      * problems described in {IERC20-approve}.
291      *
292      * Emits an {Approval} event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
299         address owner = _msgSender();
300         _approve(owner, spender, allowance(owner, spender) + addedValue);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      * - `spender` must have allowance for the caller of at least
316      * `subtractedValue`.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
319         address owner = _msgSender();
320         uint256 currentAllowance = allowance(owner, spender);
321         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
322         unchecked {
323             _approve(owner, spender, currentAllowance - subtractedValue);
324         }
325 
326         return true;
327     }
328 
329     /**
330      * @dev Moves `amount` of tokens from `from` to `to`.
331      *
332      * This internal function is equivalent to {transfer}, and can be used to
333      * e.g. implement automatic token fees, slashing mechanisms, etc.
334      *
335      * Emits a {Transfer} event.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `from` must have a balance of at least `amount`.
342      */
343     function _transfer(
344         address from,
345         address to,
346         uint256 amount
347     ) internal virtual {
348         require(from != address(0), "ERC20: transfer from the zero address");
349         require(to != address(0), "ERC20: transfer to the zero address");
350 
351         _beforeTokenTransfer(from, to, amount);
352 
353         uint256 fromBalance = _balances[from];
354         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
355         unchecked {
356             _balances[from] = fromBalance - amount;
357             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
358             // decrementing then incrementing.
359             _balances[to] += amount;
360         }
361 
362         emit Transfer(from, to, amount);
363 
364         _afterTokenTransfer(from, to, amount);
365     }
366 
367     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
368      * the total supply.
369      *
370      * Emits a {Transfer} event with `from` set to the zero address.
371      *
372      * Requirements:
373      *
374      * - `account` cannot be the zero address.
375      */
376     function _mint(address account, uint256 amount) internal virtual {
377         require(account != address(0), "ERC20: mint to the zero address");
378 
379         _beforeTokenTransfer(address(0), account, amount);
380 
381         _totalSupply += amount;
382         unchecked {
383             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
384             _balances[account] += amount;
385         }
386         emit Transfer(address(0), account, amount);
387 
388         _afterTokenTransfer(address(0), account, amount);
389     }
390 
391     /**
392      * @dev Destroys `amount` tokens from `account`, reducing the
393      * total supply.
394      *
395      * Emits a {Transfer} event with `to` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      * - `account` must have at least `amount` tokens.
401      */
402     function _burn(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: burn from the zero address");
404 
405         _beforeTokenTransfer(account, address(0), amount);
406 
407         uint256 accountBalance = _balances[account];
408         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
409         unchecked {
410             _balances[account] = accountBalance - amount;
411             // Overflow not possible: amount <= accountBalance <= totalSupply.
412             _totalSupply -= amount;
413         }
414 
415         emit Transfer(account, address(0), amount);
416 
417         _afterTokenTransfer(account, address(0), amount);
418     }
419 
420     /**
421      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
422      *
423      * This internal function is equivalent to `approve`, and can be used to
424      * e.g. set automatic allowances for certain subsystems, etc.
425      *
426      * Emits an {Approval} event.
427      *
428      * Requirements:
429      *
430      * - `owner` cannot be the zero address.
431      * - `spender` cannot be the zero address.
432      */
433     function _approve(
434         address owner,
435         address spender,
436         uint256 amount
437     ) internal virtual {
438         require(owner != address(0), "ERC20: approve from the zero address");
439         require(spender != address(0), "ERC20: approve to the zero address");
440 
441         _allowances[owner][spender] = amount;
442         emit Approval(owner, spender, amount);
443     }
444 
445     /**
446      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
447      *
448      * Does not update the allowance amount in case of infinite allowance.
449      * Revert if not enough allowance is available.
450      *
451      * Might emit an {Approval} event.
452      */
453     function _spendAllowance(
454         address owner,
455         address spender,
456         uint256 amount
457     ) internal virtual {
458         uint256 currentAllowance = allowance(owner, spender);
459         if (currentAllowance != type(uint256).max) {
460             require(currentAllowance >= amount, "ERC20: insufficient allowance");
461             unchecked {
462                 _approve(owner, spender, currentAllowance - amount);
463             }
464         }
465     }
466 
467     /**
468      * @dev Hook that is called before any transfer of tokens. This includes
469      * minting and burning.
470      *
471      * Calling conditions:
472      *
473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
474      * will be transferred to `to`.
475      * - when `from` is zero, `amount` tokens will be minted for `to`.
476      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
477      * - `from` and `to` are never both zero.
478      *
479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
480      */
481     function _beforeTokenTransfer(
482         address from,
483         address to,
484         uint256 amount
485     ) internal virtual {}
486 
487     /**
488      * @dev Hook that is called after any transfer of tokens. This includes
489      * minting and burning.
490      *
491      * Calling conditions:
492      *
493      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
494      * has been transferred to `to`.
495      * - when `from` is zero, `amount` tokens have been minted for `to`.
496      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
497      * - `from` and `to` are never both zero.
498      *
499      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
500      */
501     function _afterTokenTransfer(
502         address from,
503         address to,
504         uint256 amount
505     ) internal virtual {}
506 }
507 
508 contract COEX is ERC20 ("COEX", "COEX"){
509     constructor ( )    {
510         _mint(msg.sender, 86000000 * 1e18);
511     }
512 }