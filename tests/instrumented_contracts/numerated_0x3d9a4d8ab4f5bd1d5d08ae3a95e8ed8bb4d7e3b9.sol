1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(address from, address to, uint256 amount) external returns (bool);
80 }
81 
82 /**
83  * @dev Interface for the optional metadata functions from the ERC20 standard.
84  *
85  * _Available since v4.1._
86  */
87 interface IERC20Metadata is IERC20 {
88     /**
89      * @dev Returns the name of the token.
90      */
91     function name() external view returns (string memory);
92 
93     /**
94      * @dev Returns the symbol of the token.
95      */
96     function symbol() external view returns (string memory);
97 
98     /**
99      * @dev Returns the decimals places of the token.
100      */
101     function decimals() external view returns (uint8);
102 }
103 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         return msg.data;
124     }
125 }
126 
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
138  * The default value of {decimals} is 18. To change this, you should override
139  * this function so it returns a different value.
140  *
141  * We have followed general OpenZeppelin Contracts guidelines: functions revert
142  * instead returning `false` on failure. This behavior is nonetheless
143  * conventional and does not conflict with the expectations of ERC20
144  * applications.
145  *
146  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
147  * This allows applications to reconstruct the allowance for all accounts just
148  * by listening to said events. Other implementations of the EIP may not emit
149  * these events, as it isn't required by the specification.
150  *
151  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
152  * functions have been added to mitigate the well-known issues around setting
153  * allowances. See {IERC20-approve}.
154  */
155 contract ERC20 is Context, IERC20, IERC20Metadata {
156     mapping(address => uint256) private _balances;
157 
158     mapping(address => mapping(address => uint256)) private _allowances;
159 
160     uint256 private _totalSupply;
161 
162     string private _name;
163     string private _symbol;
164 
165     /**
166      * @dev Sets the values for {name} and {symbol}.
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
197      * Ether and Wei. This is the default value returned by this function, unless
198      * it's overridden.
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
275     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
276         address spender = _msgSender();
277         _spendAllowance(from, spender, amount);
278         _transfer(from, to, amount);
279         return true;
280     }
281 
282     /**
283      * @dev Atomically increases the allowance granted to `spender` by the caller.
284      *
285      * This is an alternative to {approve} that can be used as a mitigation for
286      * problems described in {IERC20-approve}.
287      *
288      * Emits an {Approval} event indicating the updated allowance.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      */
294     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
295         address owner = _msgSender();
296         _approve(owner, spender, allowance(owner, spender) + addedValue);
297         return true;
298     }
299 
300     /**
301      * @dev Atomically decreases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      * - `spender` must have allowance for the caller of at least
312      * `subtractedValue`.
313      */
314     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
315         address owner = _msgSender();
316         uint256 currentAllowance = allowance(owner, spender);
317         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
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
339     function _transfer(address from, address to, uint256 amount) internal virtual {
340         require(from != address(0), "ERC20: transfer from the zero address");
341         require(to != address(0), "ERC20: transfer to the zero address");
342 
343         _beforeTokenTransfer(from, to, amount);
344 
345         uint256 fromBalance = _balances[from];
346         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
347         unchecked {
348             _balances[from] = fromBalance - amount;
349             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
350             // decrementing then incrementing.
351             _balances[to] += amount;
352         }
353 
354         emit Transfer(from, to, amount);
355 
356         _afterTokenTransfer(from, to, amount);
357     }
358 
359     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
360      * the total supply.
361      *
362      * Emits a {Transfer} event with `from` set to the zero address.
363      *
364      * Requirements:
365      *
366      * - `account` cannot be the zero address.
367      */
368     function _mint(address account, uint256 amount) internal virtual {
369         require(account != address(0), "ERC20: mint to the zero address");
370 
371         _beforeTokenTransfer(address(0), account, amount);
372 
373         _totalSupply += amount;
374         unchecked {
375             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
376             _balances[account] += amount;
377         }
378         emit Transfer(address(0), account, amount);
379 
380         _afterTokenTransfer(address(0), account, amount);
381     }
382 
383     /**
384      * @dev Destroys `amount` tokens from `account`, reducing the
385      * total supply.
386      *
387      * Emits a {Transfer} event with `to` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      * - `account` must have at least `amount` tokens.
393      */
394     function _burn(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: burn from the zero address");
396 
397         _beforeTokenTransfer(account, address(0), amount);
398 
399         uint256 accountBalance = _balances[account];
400         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
401         unchecked {
402             _balances[account] = accountBalance - amount;
403             // Overflow not possible: amount <= accountBalance <= totalSupply.
404             _totalSupply -= amount;
405         }
406 
407         emit Transfer(account, address(0), amount);
408 
409         _afterTokenTransfer(account, address(0), amount);
410     }
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(address owner, address spender, uint256 amount) internal virtual {
426         require(owner != address(0), "ERC20: approve from the zero address");
427         require(spender != address(0), "ERC20: approve to the zero address");
428 
429         _allowances[owner][spender] = amount;
430         emit Approval(owner, spender, amount);
431     }
432 
433     /**
434      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
435      *
436      * Does not update the allowance amount in case of infinite allowance.
437      * Revert if not enough allowance is available.
438      *
439      * Might emit an {Approval} event.
440      */
441     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
442         uint256 currentAllowance = allowance(owner, spender);
443         if (currentAllowance != type(uint256).max) {
444             require(currentAllowance >= amount, "ERC20: insufficient allowance");
445             unchecked {
446                 _approve(owner, spender, currentAllowance - amount);
447             }
448         }
449     }
450 
451     /**
452      * @dev Hook that is called before any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * will be transferred to `to`.
459      * - when `from` is zero, `amount` tokens will be minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
466 
467     /**
468      * @dev Hook that is called after any transfer of tokens. This includes
469      * minting and burning.
470      *
471      * Calling conditions:
472      *
473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
474      * has been transferred to `to`.
475      * - when `from` is zero, `amount` tokens have been minted for `to`.
476      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
477      * - `from` and `to` are never both zero.
478      *
479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
480      */
481     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
482 }
483 
484 contract STONKS is ERC20 {
485     constructor(uint256 initialSupply) ERC20("STONKSDAO", "STONKS") {
486         _mint(msg.sender, initialSupply);
487     }
488 }