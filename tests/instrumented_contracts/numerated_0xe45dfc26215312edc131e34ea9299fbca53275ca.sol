1 // Sources flattened with hardhat v2.12.6 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.3
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 
89 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.3
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 
119 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 
147 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.3
148 
149 
150 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 
155 
156 /**
157  * @dev Implementation of the {IERC20} interface.
158  *
159  * This implementation is agnostic to the way tokens are created. This means
160  * that a supply mechanism has to be added in a derived contract using {_mint}.
161  * For a generic mechanism see {ERC20PresetMinterPauser}.
162  *
163  * TIP: For a detailed writeup see our guide
164  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
165  * to implement supply mechanisms].
166  *
167  * We have followed general OpenZeppelin Contracts guidelines: functions revert
168  * instead returning `false` on failure. This behavior is nonetheless
169  * conventional and does not conflict with the expectations of ERC20
170  * applications.
171  *
172  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
173  * This allows applications to reconstruct the allowance for all accounts just
174  * by listening to said events. Other implementations of the EIP may not emit
175  * these events, as it isn't required by the specification.
176  *
177  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
178  * functions have been added to mitigate the well-known issues around setting
179  * allowances. See {IERC20-approve}.
180  */
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     mapping(address => uint256) private _balances;
183 
184     mapping(address => mapping(address => uint256)) private _allowances;
185 
186     uint256 private _totalSupply;
187 
188     string private _name;
189     string private _symbol;
190 
191     /**
192      * @dev Sets the values for {name} and {symbol}.
193      *
194      * The default value of {decimals} is 18. To select a different value for
195      * {decimals} you should overload it.
196      *
197      * All two of these values are immutable: they can only be set once during
198      * construction.
199      */
200     constructor(string memory name_, string memory symbol_) {
201         _name = name_;
202         _symbol = symbol_;
203     }
204 
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() public view virtual override returns (string memory) {
209         return _name;
210     }
211 
212     /**
213      * @dev Returns the symbol of the token, usually a shorter version of the
214      * name.
215      */
216     function symbol() public view virtual override returns (string memory) {
217         return _symbol;
218     }
219 
220     /**
221      * @dev Returns the number of decimals used to get its user representation.
222      * For example, if `decimals` equals `2`, a balance of `505` tokens should
223      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
224      *
225      * Tokens usually opt for a value of 18, imitating the relationship between
226      * Ether and Wei. This is the value {ERC20} uses, unless this function is
227      * overridden;
228      *
229      * NOTE: This information is only used for _display_ purposes: it in
230      * no way affects any of the arithmetic of the contract, including
231      * {IERC20-balanceOf} and {IERC20-transfer}.
232      */
233     function decimals() public view virtual override returns (uint8) {
234         return 18;
235     }
236 
237     /**
238      * @dev See {IERC20-totalSupply}.
239      */
240     function totalSupply() public view virtual override returns (uint256) {
241         return _totalSupply;
242     }
243 
244     /**
245      * @dev See {IERC20-balanceOf}.
246      */
247     function balanceOf(address account) public view virtual override returns (uint256) {
248         return _balances[account];
249     }
250 
251     /**
252      * @dev See {IERC20-transfer}.
253      *
254      * Requirements:
255      *
256      * - `to` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address to, uint256 amount) public virtual override returns (bool) {
260         address owner = _msgSender();
261         _transfer(owner, to, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
276      * `transferFrom`. This is semantically equivalent to an infinite approval.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         address owner = _msgSender();
284         _approve(owner, spender, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20}.
293      *
294      * NOTE: Does not update the allowance if the current allowance
295      * is the maximum `uint256`.
296      *
297      * Requirements:
298      *
299      * - `from` and `to` cannot be the zero address.
300      * - `from` must have a balance of at least `amount`.
301      * - the caller must have allowance for ``from``'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(
305         address from,
306         address to,
307         uint256 amount
308     ) public virtual override returns (bool) {
309         address spender = _msgSender();
310         _spendAllowance(from, spender, amount);
311         _transfer(from, to, amount);
312         return true;
313     }
314 
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         address owner = _msgSender();
329         _approve(owner, spender, allowance(owner, spender) + addedValue);
330         return true;
331     }
332 
333     /**
334      * @dev Atomically decreases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      * - `spender` must have allowance for the caller of at least
345      * `subtractedValue`.
346      */
347     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
348         address owner = _msgSender();
349         uint256 currentAllowance = allowance(owner, spender);
350         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
351         unchecked {
352             _approve(owner, spender, currentAllowance - subtractedValue);
353         }
354 
355         return true;
356     }
357 
358     /**
359      * @dev Moves `amount` of tokens from `from` to `to`.
360      *
361      * This internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `from` cannot be the zero address.
369      * - `to` cannot be the zero address.
370      * - `from` must have a balance of at least `amount`.
371      */
372     function _transfer(
373         address from,
374         address to,
375         uint256 amount
376     ) internal virtual {
377         require(from != address(0), "ERC20: transfer from the zero address");
378         require(to != address(0), "ERC20: transfer to the zero address");
379 
380         _beforeTokenTransfer(from, to, amount);
381 
382         uint256 fromBalance = _balances[from];
383         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
384         unchecked {
385             _balances[from] = fromBalance - amount;
386             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
387             // decrementing then incrementing.
388             _balances[to] += amount;
389         }
390 
391         emit Transfer(from, to, amount);
392 
393         _afterTokenTransfer(from, to, amount);
394     }
395 
396     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
397      * the total supply.
398      *
399      * Emits a {Transfer} event with `from` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      */
405     function _mint(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: mint to the zero address");
407 
408         _beforeTokenTransfer(address(0), account, amount);
409 
410         _totalSupply += amount;
411         unchecked {
412             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
413             _balances[account] += amount;
414         }
415         emit Transfer(address(0), account, amount);
416 
417         _afterTokenTransfer(address(0), account, amount);
418     }
419 
420     /**
421      * @dev Destroys `amount` tokens from `account`, reducing the
422      * total supply.
423      *
424      * Emits a {Transfer} event with `to` set to the zero address.
425      *
426      * Requirements:
427      *
428      * - `account` cannot be the zero address.
429      * - `account` must have at least `amount` tokens.
430      */
431     function _burn(address account, uint256 amount) internal virtual {
432         require(account != address(0), "ERC20: burn from the zero address");
433 
434         _beforeTokenTransfer(account, address(0), amount);
435 
436         uint256 accountBalance = _balances[account];
437         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
438         unchecked {
439             _balances[account] = accountBalance - amount;
440             // Overflow not possible: amount <= accountBalance <= totalSupply.
441             _totalSupply -= amount;
442         }
443 
444         emit Transfer(account, address(0), amount);
445 
446         _afterTokenTransfer(account, address(0), amount);
447     }
448 
449     /**
450      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
451      *
452      * This internal function is equivalent to `approve`, and can be used to
453      * e.g. set automatic allowances for certain subsystems, etc.
454      *
455      * Emits an {Approval} event.
456      *
457      * Requirements:
458      *
459      * - `owner` cannot be the zero address.
460      * - `spender` cannot be the zero address.
461      */
462     function _approve(
463         address owner,
464         address spender,
465         uint256 amount
466     ) internal virtual {
467         require(owner != address(0), "ERC20: approve from the zero address");
468         require(spender != address(0), "ERC20: approve to the zero address");
469 
470         _allowances[owner][spender] = amount;
471         emit Approval(owner, spender, amount);
472     }
473 
474     /**
475      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
476      *
477      * Does not update the allowance amount in case of infinite allowance.
478      * Revert if not enough allowance is available.
479      *
480      * Might emit an {Approval} event.
481      */
482     function _spendAllowance(
483         address owner,
484         address spender,
485         uint256 amount
486     ) internal virtual {
487         uint256 currentAllowance = allowance(owner, spender);
488         if (currentAllowance != type(uint256).max) {
489             require(currentAllowance >= amount, "ERC20: insufficient allowance");
490             unchecked {
491                 _approve(owner, spender, currentAllowance - amount);
492             }
493         }
494     }
495 
496     /**
497      * @dev Hook that is called before any transfer of tokens. This includes
498      * minting and burning.
499      *
500      * Calling conditions:
501      *
502      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
503      * will be transferred to `to`.
504      * - when `from` is zero, `amount` tokens will be minted for `to`.
505      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
506      * - `from` and `to` are never both zero.
507      *
508      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
509      */
510     function _beforeTokenTransfer(
511         address from,
512         address to,
513         uint256 amount
514     ) internal virtual {}
515 
516     /**
517      * @dev Hook that is called after any transfer of tokens. This includes
518      * minting and burning.
519      *
520      * Calling conditions:
521      *
522      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
523      * has been transferred to `to`.
524      * - when `from` is zero, `amount` tokens have been minted for `to`.
525      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
526      * - `from` and `to` are never both zero.
527      *
528      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
529      */
530     function _afterTokenTransfer(
531         address from,
532         address to,
533         uint256 amount
534     ) internal virtual {}
535 }
536 
537 
538 // File contracts/rel/RELToken.sol
539 
540 pragma solidity ^0.8.0;
541 
542 contract RelationToken is ERC20 {
543     uint256 public constant TOTAL_SUPPLY = 1_000_000_000 * 10**18;
544 
545     constructor(
546         address receiver
547     ) ERC20("Relation Token", "REL") {
548         _mint(receiver, TOTAL_SUPPLY);
549     }
550 }