1 // SPDX-License-Identifier: MIT
2 
3 /* 
4 *   $GECKO the most memeable Gecko in existence.
5 *       
6 *   - No Fees
7 *   - 100% Meme
8 *
9 *   TG: https://t.me/geckocoineth
10 *
11 */
12 
13 // File: @openzeppelin/contracts/utils/Context.sol
14 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
39 
40 
41 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP.
47  */
48 interface IERC20 {
49     /**
50      * @dev Emitted when `value` tokens are moved from one account (`from`) to
51      * another (`to`).
52      *
53      * Note that `value` may be zero.
54      */
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 
57     /**
58      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
59      * a call to {approve}. `value` is the new allowance.
60      */
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 
63     /**
64      * @dev Returns the amount of tokens in existence.
65      */
66     function totalSupply() external view returns (uint256);
67 
68     /**
69      * @dev Returns the amount of tokens owned by `account`.
70      */
71     function balanceOf(address account) external view returns (uint256);
72 
73     /**
74      * @dev Moves `amount` tokens from the caller's account to `to`.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transfer(address to, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Returns the remaining number of tokens that `spender` will be
84      * allowed to spend on behalf of `owner` through {transferFrom}. This is
85      * zero by default.
86      *
87      * This value changes when {approve} or {transferFrom} are called.
88      */
89     function allowance(address owner, address spender) external view returns (uint256);
90 
91     /**
92      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * IMPORTANT: Beware that changing an allowance with this method brings the risk
97      * that someone may use both the old and the new allowance by unfortunate
98      * transaction ordering. One possible solution to mitigate this race
99      * condition is to first reduce the spender's allowance to 0 and set the
100      * desired value afterwards:
101      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
102      *
103      * Emits an {Approval} event.
104      */
105     function approve(address spender, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Moves `amount` tokens from `from` to `to` using the
109      * allowance mechanism. `amount` is then deducted from the caller's
110      * allowance.
111      *
112      * Returns a boolean value indicating whether the operation succeeded.
113      *
114      * Emits a {Transfer} event.
115      */
116     function transferFrom(
117         address from,
118         address to,
119         uint256 amount
120     ) external returns (bool);
121 }
122 
123 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 
131 /**
132  * @dev Interface for the optional metadata functions from the ERC20 standard.
133  *
134  * _Available since v4.1._
135  */
136 interface IERC20Metadata is IERC20 {
137     /**
138      * @dev Returns the name of the token.
139      */
140     function name() external view returns (string memory);
141 
142     /**
143      * @dev Returns the symbol of the token.
144      */
145     function symbol() external view returns (string memory);
146 
147     /**
148      * @dev Returns the decimals places of the token.
149      */
150     function decimals() external view returns (uint8);
151 }
152 
153 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
154 
155 
156 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 
162 
163 /**
164  * @dev Implementation of the {IERC20} interface.
165  *
166  * This implementation is agnostic to the way tokens are created. This means
167  * that a supply mechanism has to be added in a derived contract using {_mint}.
168  * For a generic mechanism see {ERC20PresetMinterPauser}.
169  *
170  * TIP: For a detailed writeup see our guide
171  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
172  * to implement supply mechanisms].
173  *
174  * We have followed general OpenZeppelin Contracts guidelines: functions revert
175  * instead returning `false` on failure. This behavior is nonetheless
176  * conventional and does not conflict with the expectations of ERC20
177  * applications.
178  *
179  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
180  * This allows applications to reconstruct the allowance for all accounts just
181  * by listening to said events. Other implementations of the EIP may not emit
182  * these events, as it isn't required by the specification.
183  *
184  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
185  * functions have been added to mitigate the well-known issues around setting
186  * allowances. See {IERC20-approve}.
187  */
188 contract ERC20 is Context, IERC20, IERC20Metadata {
189     mapping(address => uint256) private _balances;
190 
191     mapping(address => mapping(address => uint256)) private _allowances;
192 
193     uint256 private _totalSupply;
194 
195     string private _name;
196     string private _symbol;
197 
198     /**
199      * @dev Sets the values for {name} and {symbol}.
200      *
201      * The default value of {decimals} is 18. To select a different value for
202      * {decimals} you should overload it.
203      *
204      * All two of these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor(string memory name_, string memory symbol_) {
208         _name = name_;
209         _symbol = symbol_;
210     }
211 
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() public view virtual override returns (string memory) {
216         return _name;
217     }
218 
219     /**
220      * @dev Returns the symbol of the token, usually a shorter version of the
221      * name.
222      */
223     function symbol() public view virtual override returns (string memory) {
224         return _symbol;
225     }
226 
227     /**
228      * @dev Returns the number of decimals used to get its user representation.
229      * For example, if `decimals` equals `2`, a balance of `505` tokens should
230      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
231      *
232      * Tokens usually opt for a value of 18, imitating the relationship between
233      * Ether and Wei. This is the value {ERC20} uses, unless this function is
234      * overridden;
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view virtual override returns (uint8) {
241         return 18;
242     }
243 
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view virtual override returns (uint256) {
248         return _totalSupply;
249     }
250 
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account) public view virtual override returns (uint256) {
255         return _balances[account];
256     }
257 
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `to` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address to, uint256 amount) public virtual override returns (bool) {
267         address owner = _msgSender();
268         _transfer(owner, to, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-allowance}.
274      */
275     function allowance(address owner, address spender) public view virtual override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278 
279     /**
280      * @dev See {IERC20-approve}.
281      *
282      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
283      * `transferFrom`. This is semantically equivalent to an infinite approval.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount) public virtual override returns (bool) {
290         address owner = _msgSender();
291         _approve(owner, spender, amount);
292         return true;
293     }
294 
295     /**
296      * @dev See {IERC20-transferFrom}.
297      *
298      * Emits an {Approval} event indicating the updated allowance. This is not
299      * required by the EIP. See the note at the beginning of {ERC20}.
300      *
301      * NOTE: Does not update the allowance if the current allowance
302      * is the maximum `uint256`.
303      *
304      * Requirements:
305      *
306      * - `from` and `to` cannot be the zero address.
307      * - `from` must have a balance of at least `amount`.
308      * - the caller must have allowance for ``from``'s tokens of at least
309      * `amount`.
310      */
311     function transferFrom(
312         address from,
313         address to,
314         uint256 amount
315     ) public virtual override returns (bool) {
316         address spender = _msgSender();
317         _spendAllowance(from, spender, amount);
318         _transfer(from, to, amount);
319         return true;
320     }
321 
322     /**
323      * @dev Atomically increases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      */
334     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
335         address owner = _msgSender();
336         _approve(owner, spender, allowance(owner, spender) + addedValue);
337         return true;
338     }
339 
340     /**
341      * @dev Atomically decreases the allowance granted to `spender` by the caller.
342      *
343      * This is an alternative to {approve} that can be used as a mitigation for
344      * problems described in {IERC20-approve}.
345      *
346      * Emits an {Approval} event indicating the updated allowance.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      * - `spender` must have allowance for the caller of at least
352      * `subtractedValue`.
353      */
354     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
355         address owner = _msgSender();
356         uint256 currentAllowance = allowance(owner, spender);
357         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
358         unchecked {
359             _approve(owner, spender, currentAllowance - subtractedValue);
360         }
361 
362         return true;
363     }
364 
365     /**
366      * @dev Moves `amount` of tokens from `from` to `to`.
367      *
368      * This internal function is equivalent to {transfer}, and can be used to
369      * e.g. implement automatic token fees, slashing mechanisms, etc.
370      *
371      * Emits a {Transfer} event.
372      *
373      * Requirements:
374      *
375      * - `from` cannot be the zero address.
376      * - `to` cannot be the zero address.
377      * - `from` must have a balance of at least `amount`.
378      */
379     function _transfer(
380         address from,
381         address to,
382         uint256 amount
383     ) internal virtual {
384         require(from != address(0), "ERC20: transfer from the zero address");
385         require(to != address(0), "ERC20: transfer to the zero address");
386 
387         _beforeTokenTransfer(from, to, amount);
388 
389         uint256 fromBalance = _balances[from];
390         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
391         unchecked {
392             _balances[from] = fromBalance - amount;
393             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
394             // decrementing then incrementing.
395             _balances[to] += amount;
396         }
397 
398         emit Transfer(from, to, amount);
399 
400         _afterTokenTransfer(from, to, amount);
401     }
402 
403     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
404      * the total supply.
405      *
406      * Emits a {Transfer} event with `from` set to the zero address.
407      *
408      * Requirements:
409      *
410      * - `account` cannot be the zero address.
411      */
412     function _mint(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: mint to the zero address");
414 
415         _beforeTokenTransfer(address(0), account, amount);
416 
417         _totalSupply += amount;
418         unchecked {
419             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
420             _balances[account] += amount;
421         }
422         emit Transfer(address(0), account, amount);
423 
424         _afterTokenTransfer(address(0), account, amount);
425     }
426 
427     /**
428      * @dev Destroys `amount` tokens from `account`, reducing the
429      * total supply.
430      *
431      * Emits a {Transfer} event with `to` set to the zero address.
432      *
433      * Requirements:
434      *
435      * - `account` cannot be the zero address.
436      * - `account` must have at least `amount` tokens.
437      */
438     function _burn(address account, uint256 amount) internal virtual {
439         require(account != address(0), "ERC20: burn from the zero address");
440 
441         _beforeTokenTransfer(account, address(0), amount);
442 
443         uint256 accountBalance = _balances[account];
444         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
445         unchecked {
446             _balances[account] = accountBalance - amount;
447             // Overflow not possible: amount <= accountBalance <= totalSupply.
448             _totalSupply -= amount;
449         }
450 
451         emit Transfer(account, address(0), amount);
452 
453         _afterTokenTransfer(account, address(0), amount);
454     }
455 
456     /**
457      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
458      *
459      * This internal function is equivalent to `approve`, and can be used to
460      * e.g. set automatic allowances for certain subsystems, etc.
461      *
462      * Emits an {Approval} event.
463      *
464      * Requirements:
465      *
466      * - `owner` cannot be the zero address.
467      * - `spender` cannot be the zero address.
468      */
469     function _approve(
470         address owner,
471         address spender,
472         uint256 amount
473     ) internal virtual {
474         require(owner != address(0), "ERC20: approve from the zero address");
475         require(spender != address(0), "ERC20: approve to the zero address");
476 
477         _allowances[owner][spender] = amount;
478         emit Approval(owner, spender, amount);
479     }
480 
481     /**
482      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
483      *
484      * Does not update the allowance amount in case of infinite allowance.
485      * Revert if not enough allowance is available.
486      *
487      * Might emit an {Approval} event.
488      */
489     function _spendAllowance(
490         address owner,
491         address spender,
492         uint256 amount
493     ) internal virtual {
494         uint256 currentAllowance = allowance(owner, spender);
495         if (currentAllowance != type(uint256).max) {
496             require(currentAllowance >= amount, "ERC20: insufficient allowance");
497             unchecked {
498                 _approve(owner, spender, currentAllowance - amount);
499             }
500         }
501     }
502 
503     /**
504      * @dev Hook that is called before any transfer of tokens. This includes
505      * minting and burning.
506      *
507      * Calling conditions:
508      *
509      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
510      * will be transferred to `to`.
511      * - when `from` is zero, `amount` tokens will be minted for `to`.
512      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
513      * - `from` and `to` are never both zero.
514      *
515      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
516      */
517     function _beforeTokenTransfer(
518         address from,
519         address to,
520         uint256 amount
521     ) internal virtual {}
522 
523     /**
524      * @dev Hook that is called after any transfer of tokens. This includes
525      * minting and burning.
526      *
527      * Calling conditions:
528      *
529      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
530      * has been transferred to `to`.
531      * - when `from` is zero, `amount` tokens have been minted for `to`.
532      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
533      * - `from` and `to` are never both zero.
534      *
535      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
536      */
537     function _afterTokenTransfer(
538         address from,
539         address to,
540         uint256 amount
541     ) internal virtual {}
542 }
543 
544 contract GeckoCoin is ERC20 {
545     constructor() ERC20("Gecko Coin", "GECKO") {
546         _mint(msg.sender, 69420000000 * 10 ** decimals());
547     }
548 }