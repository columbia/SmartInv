1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Emitted when `value` tokens are moved from one account (`from`) to
12      * another (`to`).
13      *
14      * Note that `value` may be zero.
15      */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
20      * a call to {approve}. `value` is the new allowance.
21      */
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `to`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address to, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `from` to `to` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address from,
79         address to,
80         uint256 amount
81     ) external returns (bool);
82 }
83 
84 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
85 
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
109 
110 /**
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         return msg.data;
127     }
128 }
129 
130 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
131 
132 /**
133  * @dev Implementation of the {IERC20} interface.
134  *
135  * This implementation is agnostic to the way tokens are created. This means
136  * that a supply mechanism has to be added in a derived contract using {_mint}.
137  * For a generic mechanism see {ERC20PresetMinterPauser}.
138  *
139  * TIP: For a detailed writeup see our guide
140  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
141  * to implement supply mechanisms].
142  *
143  * We have followed general OpenZeppelin Contracts guidelines: functions revert
144  * instead returning `false` on failure. This behavior is nonetheless
145  * conventional and does not conflict with the expectations of ERC20
146  * applications.
147  *
148  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
149  * This allows applications to reconstruct the allowance for all accounts just
150  * by listening to said events. Other implementations of the EIP may not emit
151  * these events, as it isn't required by the specification.
152  *
153  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
154  * functions have been added to mitigate the well-known issues around setting
155  * allowances. See {IERC20-approve}.
156  */
157 contract ERC20 is Context, IERC20, IERC20Metadata {
158     mapping(address => uint256) private _balances;
159 
160     mapping(address => mapping(address => uint256)) private _allowances;
161 
162     uint256 private _totalSupply;
163 
164     string private _name;
165     string private _symbol;
166 
167     /**
168      * @dev Sets the values for {name} and {symbol}.
169      *
170      * The default value of {decimals} is 18. To select a different value for
171      * {decimals} you should overload it.
172      *
173      * All two of these values are immutable: they can only be set once during
174      * construction.
175      */
176     constructor(string memory name_, string memory symbol_) {
177         _name = name_;
178         _symbol = symbol_;
179     }
180 
181     /**
182      * @dev Returns the name of the token.
183      */
184     function name() public view virtual override returns (string memory) {
185         return _name;
186     }
187 
188     /**
189      * @dev Returns the symbol of the token, usually a shorter version of the
190      * name.
191      */
192     function symbol() public view virtual override returns (string memory) {
193         return _symbol;
194     }
195 
196     /**
197      * @dev Returns the number of decimals used to get its user representation.
198      * For example, if `decimals` equals `2`, a balance of `505` tokens should
199      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
200      *
201      * Tokens usually opt for a value of 18, imitating the relationship between
202      * Ether and Wei. This is the value {ERC20} uses, unless this function is
203      * overridden;
204      *
205      * NOTE: This information is only used for _display_ purposes: it in
206      * no way affects any of the arithmetic of the contract, including
207      * {IERC20-balanceOf} and {IERC20-transfer}.
208      */
209     function decimals() public view virtual override returns (uint8) {
210         return 18;
211     }
212 
213     /**
214      * @dev See {IERC20-totalSupply}.
215      */
216     function totalSupply() public view virtual override returns (uint256) {
217         return _totalSupply;
218     }
219 
220     /**
221      * @dev See {IERC20-balanceOf}.
222      */
223     function balanceOf(address account) public view virtual override returns (uint256) {
224         return _balances[account];
225     }
226 
227     /**
228      * @dev See {IERC20-transfer}.
229      *
230      * Requirements:
231      *
232      * - `to` cannot be the zero address.
233      * - the caller must have a balance of at least `amount`.
234      */
235     function transfer(address to, uint256 amount) public virtual override returns (bool) {
236         address owner = _msgSender();
237         _transfer(owner, to, amount);
238         return true;
239     }
240 
241     /**
242      * @dev See {IERC20-allowance}.
243      */
244     function allowance(address owner, address spender) public view virtual override returns (uint256) {
245         return _allowances[owner][spender];
246     }
247 
248     /**
249      * @dev See {IERC20-approve}.
250      *
251      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
252      * `transferFrom`. This is semantically equivalent to an infinite approval.
253      *
254      * Requirements:
255      *
256      * - `spender` cannot be the zero address.
257      */
258     function approve(address spender, uint256 amount) public virtual override returns (bool) {
259         address owner = _msgSender();
260         _approve(owner, spender, amount);
261         return true;
262     }
263 
264     /**
265      * @dev See {IERC20-transferFrom}.
266      *
267      * Emits an {Approval} event indicating the updated allowance. This is not
268      * required by the EIP. See the note at the beginning of {ERC20}.
269      *
270      * NOTE: Does not update the allowance if the current allowance
271      * is the maximum `uint256`.
272      *
273      * Requirements:
274      *
275      * - `from` and `to` cannot be the zero address.
276      * - `from` must have a balance of at least `amount`.
277      * - the caller must have allowance for ``from``'s tokens of at least
278      * `amount`.
279      */
280     function transferFrom(
281         address from,
282         address to,
283         uint256 amount
284     ) public virtual override returns (bool) {
285         address spender = _msgSender();
286         _spendAllowance(from, spender, amount);
287         _transfer(from, to, amount);
288         return true;
289     }
290 
291     /**
292      * @dev Atomically increases the allowance granted to `spender` by the caller.
293      *
294      * This is an alternative to {approve} that can be used as a mitigation for
295      * problems described in {IERC20-approve}.
296      *
297      * Emits an {Approval} event indicating the updated allowance.
298      *
299      * Requirements:
300      *
301      * - `spender` cannot be the zero address.
302      */
303     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
304         address owner = _msgSender();
305         _approve(owner, spender, allowance(owner, spender) + addedValue);
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
324         address owner = _msgSender();
325         uint256 currentAllowance = allowance(owner, spender);
326         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
327         unchecked {
328             _approve(owner, spender, currentAllowance - subtractedValue);
329         }
330 
331         return true;
332     }
333 
334     /**
335      * @dev Moves `amount` of tokens from `from` to `to`.
336      *
337      * This internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `from` cannot be the zero address.
345      * - `to` cannot be the zero address.
346      * - `from` must have a balance of at least `amount`.
347      */
348     function _transfer(
349         address from,
350         address to,
351         uint256 amount
352     ) internal virtual {
353         require(from != address(0), "ERC20: transfer from the zero address");
354         require(to != address(0), "ERC20: transfer to the zero address");
355 
356         _beforeTokenTransfer(from, to, amount);
357 
358         uint256 fromBalance = _balances[from];
359         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
360         unchecked {
361             _balances[from] = fromBalance - amount;
362             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
363             // decrementing then incrementing.
364             _balances[to] += amount;
365         }
366 
367         emit Transfer(from, to, amount);
368 
369         _afterTokenTransfer(from, to, amount);
370     }
371 
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _beforeTokenTransfer(address(0), account, amount);
385 
386         _totalSupply += amount;
387         unchecked {
388             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
389             _balances[account] += amount;
390         }
391         emit Transfer(address(0), account, amount);
392 
393         _afterTokenTransfer(address(0), account, amount);
394     }
395 
396     /**
397      * @dev Destroys `amount` tokens from `account`, reducing the
398      * total supply.
399      *
400      * Emits a {Transfer} event with `to` set to the zero address.
401      *
402      * Requirements:
403      *
404      * - `account` cannot be the zero address.
405      * - `account` must have at least `amount` tokens.
406      */
407     function _burn(address account, uint256 amount) internal virtual {
408         require(account != address(0), "ERC20: burn from the zero address");
409 
410         _beforeTokenTransfer(account, address(0), amount);
411 
412         uint256 accountBalance = _balances[account];
413         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
414         unchecked {
415             _balances[account] = accountBalance - amount;
416             // Overflow not possible: amount <= accountBalance <= totalSupply.
417             _totalSupply -= amount;
418         }
419 
420         emit Transfer(account, address(0), amount);
421 
422         _afterTokenTransfer(account, address(0), amount);
423     }
424 
425     /**
426      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
427      *
428      * This internal function is equivalent to `approve`, and can be used to
429      * e.g. set automatic allowances for certain subsystems, etc.
430      *
431      * Emits an {Approval} event.
432      *
433      * Requirements:
434      *
435      * - `owner` cannot be the zero address.
436      * - `spender` cannot be the zero address.
437      */
438     function _approve(
439         address owner,
440         address spender,
441         uint256 amount
442     ) internal virtual {
443         require(owner != address(0), "ERC20: approve from the zero address");
444         require(spender != address(0), "ERC20: approve to the zero address");
445 
446         _allowances[owner][spender] = amount;
447         emit Approval(owner, spender, amount);
448     }
449 
450     /**
451      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
452      *
453      * Does not update the allowance amount in case of infinite allowance.
454      * Revert if not enough allowance is available.
455      *
456      * Might emit an {Approval} event.
457      */
458     function _spendAllowance(
459         address owner,
460         address spender,
461         uint256 amount
462     ) internal virtual {
463         uint256 currentAllowance = allowance(owner, spender);
464         if (currentAllowance != type(uint256).max) {
465             require(currentAllowance >= amount, "ERC20: insufficient allowance");
466             unchecked {
467                 _approve(owner, spender, currentAllowance - amount);
468             }
469         }
470     }
471 
472     /**
473      * @dev Hook that is called before any transfer of tokens. This includes
474      * minting and burning.
475      *
476      * Calling conditions:
477      *
478      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
479      * will be transferred to `to`.
480      * - when `from` is zero, `amount` tokens will be minted for `to`.
481      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
482      * - `from` and `to` are never both zero.
483      *
484      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
485      */
486     function _beforeTokenTransfer(
487         address from,
488         address to,
489         uint256 amount
490     ) internal virtual {}
491 
492     /**
493      * @dev Hook that is called after any transfer of tokens. This includes
494      * minting and burning.
495      *
496      * Calling conditions:
497      *
498      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
499      * has been transferred to `to`.
500      * - when `from` is zero, `amount` tokens have been minted for `to`.
501      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
502      * - `from` and `to` are never both zero.
503      *
504      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
505      */
506     function _afterTokenTransfer(
507         address from,
508         address to,
509         uint256 amount
510     ) internal virtual {}
511 }
512 
513 contract OleaToken is ERC20 {
514     constructor(
515         string memory name,
516         string memory symbol,
517         uint256 initialSupply,
518         address owner
519     ) ERC20(name, symbol) {
520         _mint(owner, initialSupply);
521     }
522 }