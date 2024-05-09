1 // SPDX-License-Identifier: MIT
2 
3 // @title An ERC20 token for the YW ecosystem.
4 
5 pragma solidity ^0.8.0;
6 
7 interface IERC20 {
8     /**
9      * @dev Emitted when `value` tokens are moved from one account (`from`) to
10      * another (`to`).
11      */
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14     /**
15      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
16      * a call to {approve}. `value` is the new allowance.
17      */
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `to`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address to, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `from` to `to` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amount
71     ) external returns (bool);
72 }
73 
74 /**
75  * @dev Interface for the optional metadata functions from the ERC20 standard.
76  *
77  * _Available since v4.1._
78  */
79 interface IERC20Metadata is IERC20 {
80     /**
81      * @dev Returns the name of the token.
82      */
83     function name() external view returns (string memory);
84 
85     /**
86      * @dev Returns the symbol of the token.
87      */
88     function symbol() external view returns (string memory);
89 
90     /**
91      * @dev Returns the decimals places of the token.
92      */
93     function decimals() external view returns (uint8);
94 }
95 
96 /**
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data.
99  */
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 
105     function _msgData() internal view virtual returns (bytes calldata) {
106         return msg.data;
107     }
108 }
109 
110 /**
111  * @dev Implementation of the {IERC20} interface.
112  *
113  * This implementation is agnostic to the way tokens are created. This means
114  * that a supply mechanism has to be added in a derived contract using {_mint}.
115  * For a generic mechanism see {ERC20PresetMinterPauser}.
116  *
117  * We have followed general OpenZeppelin Contracts guidelines: functions revert
118  * instead returning `false` on failure. This behavior is nonetheless
119  * conventional and does not conflict with the expectations of ERC20
120  * applications.
121  *
122  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
123  * This allows applications to reconstruct the allowance for all accounts just
124  * by listening to said events. Other implementations of the EIP may not emit
125  * these events, as it isn't required by the specification.
126  *
127  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
128  * functions have been added to mitigate the well-known issues around setting
129  * allowances. See {IERC20-approve}.
130  */
131 contract ERC20 is Context, IERC20, IERC20Metadata {
132     mapping(address => uint256) private _balances;
133 
134     mapping(address => mapping(address => uint256)) private _allowances;
135 
136     uint256 private _totalSupply;
137 
138     string private _name;
139     string private _symbol;
140 
141     /**
142      * @dev Sets the values for {name} and {symbol}.
143      *
144      * The default value of {decimals} is 18. To select a different value for
145      * {decimals} you should overload it.
146      *
147      * All two of these values are immutable: they can only be set once during
148      * construction.
149      */
150     constructor(string memory name_, string memory symbol_) {
151         _name = name_;
152         _symbol = symbol_;
153     }
154 
155     /**
156      * @dev Returns the name of the token.
157      */
158     function name() public view virtual override returns (string memory) {
159         return _name;
160     }
161 
162     /**
163      * @dev Returns the symbol of the token, usually a shorter version of the
164      * name.
165      */
166     function symbol() public view virtual override returns (string memory) {
167         return _symbol;
168     }
169 
170     /**
171      * @dev Returns the number of decimals used to get its user representation.
172      * For example, if `decimals` equals `2`, a balance of `505` tokens should
173      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
174      *
175      * Tokens usually opt for a value of 18, imitating the relationship between
176      * Ether and Wei. This is the value {ERC20} uses, unless this function is
177      * overridden;
178      *
179      * NOTE: This information is only used for _display_ purposes: it in
180      * no way affects any of the arithmetic of the contract, including
181      * {IERC20-balanceOf} and {IERC20-transfer}.
182      */
183     function decimals() public view virtual override returns (uint8) {
184         return 18;
185     }
186 
187     /**
188      * @dev See {IERC20-totalSupply}.
189      */
190     function totalSupply() public view virtual override returns (uint256) {
191         return _totalSupply;
192     }
193 
194     /**
195      * @dev See {IERC20-balanceOf}.
196      */
197     function balanceOf(address account) public view virtual override returns (uint256) {
198         return _balances[account];
199     }
200 
201     /**
202      * @dev See {IERC20-transfer}.
203      *
204      * Requirements:
205      *
206      * - `to` cannot be the zero address.
207      * - the caller must have a balance of at least `amount`.
208      */
209     function transfer(address to, uint256 amount) public virtual override returns (bool) {
210         address owner = _msgSender();
211         _transfer(owner, to, amount);
212         return true;
213     }
214 
215     /**
216      * @dev See {IERC20-allowance}.
217      */
218     function allowance(address owner, address spender) public view virtual override returns (uint256) {
219         return _allowances[owner][spender];
220     }
221 
222     /**
223      * @dev See {IERC20-approve}.
224      *
225      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
226      * `transferFrom`. This is semantically equivalent to an infinite approval.
227      *
228      * Requirements:
229      *
230      * - `spender` cannot be the zero address.
231      */
232     function approve(address spender, uint256 amount) public virtual override returns (bool) {
233         address owner = _msgSender();
234         _approve(owner, spender, amount);
235         return true;
236     }
237 
238     /**
239      * @dev See {IERC20-transferFrom}.
240      *
241      * Emits an {Approval} event indicating the updated allowance. This is not
242      * required by the EIP. See the note at the beginning of {ERC20}.
243      *
244      * NOTE: Does not update the allowance if the current allowance
245      * is the maximum `uint256`.
246      *
247      * Requirements:
248      *
249      * - `from` and `to` cannot be the zero address.
250      * - `from` must have a balance of at least `amount`.
251      * - the caller must have allowance for ``from``'s tokens of at least
252      * `amount`.
253      */
254     function transferFrom(
255         address from,
256         address to,
257         uint256 amount
258     ) public virtual override returns (bool) {
259         address spender = _msgSender();
260         _spendAllowance(from, spender, amount);
261         _transfer(from, to, amount);
262         return true;
263     }
264 
265     /**
266      * @dev Atomically increases the allowance granted to `spender` by the caller.
267      *
268      * This is an alternative to {approve} that can be used as a mitigation for
269      * problems described in {IERC20-approve}.
270      *
271      * Emits an {Approval} event indicating the updated allowance.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
278         address owner = _msgSender();
279         _approve(owner, spender, allowance(owner, spender) + addedValue);
280         return true;
281     }
282 
283     /**
284      * @dev Atomically decreases the allowance granted to `spender` by the caller.
285      *
286      * This is an alternative to {approve} that can be used as a mitigation for
287      * problems described in {IERC20-approve}.
288      *
289      * Emits an {Approval} event indicating the updated allowance.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      * - `spender` must have allowance for the caller of at least
295      * `subtractedValue`.
296      */
297     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
298         address owner = _msgSender();
299         uint256 currentAllowance = allowance(owner, spender);
300         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
301         unchecked {
302             _approve(owner, spender, currentAllowance - subtractedValue);
303         }
304 
305         return true;
306     }
307 
308     /**
309      * @dev Moves `amount` of tokens from `from` to `to`.
310      *
311      * This internal function is equivalent to {transfer}, and can be used to
312      * e.g. implement automatic token fees, slashing mechanisms, etc.
313      *
314      * Emits a {Transfer} event.
315      *
316      * Requirements:
317      *
318      * - `from` cannot be the zero address.
319      * - `to` cannot be the zero address.
320      * - `from` must have a balance of at least `amount`.
321      */
322     function _transfer(
323         address from,
324         address to,
325         uint256 amount
326     ) internal virtual {
327         require(from != address(0), "ERC20: transfer from the zero address");
328         require(to != address(0), "ERC20: transfer to the zero address");
329 
330         _beforeTokenTransfer(from, to, amount);
331 
332         uint256 fromBalance = _balances[from];
333         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
334         unchecked {
335             _balances[from] = fromBalance - amount;
336             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
337             // decrementing then incrementing.
338             _balances[to] += amount;
339         }
340 
341         emit Transfer(from, to, amount);
342 
343         _afterTokenTransfer(from, to, amount);
344     }
345 
346     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
347      * the total supply.
348      *
349      * Emits a {Transfer} event with `from` set to the zero address.
350      *
351      * Requirements:
352      *
353      * - `account` cannot be the zero address.
354      */
355     function _mint(address account, uint256 amount) internal virtual {
356         require(account != address(0), "ERC20: mint to the zero address");
357 
358         _beforeTokenTransfer(address(0), account, amount);
359 
360         _totalSupply += amount;
361         unchecked {
362             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
363             _balances[account] += amount;
364         }
365         emit Transfer(address(0), account, amount);
366 
367         _afterTokenTransfer(address(0), account, amount);
368     }
369 
370     /**
371      * @dev Destroys `amount` tokens from `account`, reducing the
372      * total supply.
373      *
374      * Emits a {Transfer} event with `to` set to the zero address.
375      *
376      * Requirements:
377      *
378      * - `account` cannot be the zero address.
379      * - `account` must have at least `amount` tokens.
380      */
381     function _burn(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: burn from the zero address");
383 
384         _beforeTokenTransfer(account, address(0), amount);
385 
386         uint256 accountBalance = _balances[account];
387         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
388         unchecked {
389             _balances[account] = accountBalance - amount;
390             // Overflow not possible: amount <= accountBalance <= totalSupply.
391             _totalSupply -= amount;
392         }
393 
394         emit Transfer(account, address(0), amount);
395 
396         _afterTokenTransfer(account, address(0), amount);
397     }
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
401      *
402      * This internal function is equivalent to `approve`, and can be used to
403      * e.g. set automatic allowances for certain subsystems, etc.
404      *
405      * Emits an {Approval} event.
406      *
407      * Requirements:
408      * - `owner` cannot be the zero address.
409      * - `spender` cannot be the zero address.
410      */
411     function _approve(
412         address owner,
413         address spender,
414         uint256 amount
415     ) internal virtual {
416         require(owner != address(0), "ERC20: approve from the zero address");
417         require(spender != address(0), "ERC20: approve to the zero address");
418 
419         _allowances[owner][spender] = amount;
420         emit Approval(owner, spender, amount);
421     }
422 
423     /**
424      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
425      *
426      * Does not update the allowance amount in case of infinite allowance.
427      * Revert if not enough allowance is available.
428      *
429      * May emit an {Approval} event.
430      */
431     function _spendAllowance(
432         address owner,
433         address spender,
434         uint256 amount
435     ) internal virtual {
436         uint256 currentAllowance = allowance(owner, spender);
437         if (currentAllowance != type(uint256).max) {
438             require(currentAllowance >= amount, "ERC20: insufficient allowance");
439             unchecked {
440                 _approve(owner, spender, currentAllowance - amount);
441             }
442         }
443     }
444 
445     /**
446      * @dev Hook that is called before any transfer of tokens. This includes
447      * minting and burning.
448      *
449      * Calling conditions:
450      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
451      * will be transferred to `to`.
452      * - when `from` is zero, `amount` tokens will be minted for `to`.
453      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
454      * - `from` and `to` are never both zero.
455      *
456      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
457      */
458     function _beforeTokenTransfer(
459         address from,
460         address to,
461         uint256 amount
462     ) internal virtual {}
463 
464     /**
465      * @dev Hook that is called after any transfer of tokens. This includes
466      * minting and burning.
467      *
468      * Calling conditions:
469      *
470      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
471      * has been transferred to `to`.
472      * - when `from` is zero, `amount` tokens have been minted for `to`.
473      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
474      * - `from` and `to` are never both zero.
475      *
476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
477      */
478     function _afterTokenTransfer(
479         address from,
480         address to,
481         uint256 amount
482     ) internal virtual {}
483 }
484 
485 contract YoureWelcome is ERC20 {
486     /**
487      * @dev Constructor gives msg.sender all of existing tokens.
488      */
489     constructor(
490         string memory name,
491         string memory symbol,
492         uint256 totalSupply
493     ) ERC20(name, symbol) {
494         // name = "YoureWelcome";
495         // symbol = "YoureWelcome";
496         // uint256 totalSupply = 10 ** 9 * 10 ** 18; // 1 billion total supply
497         _mint(msg.sender, totalSupply);
498     }
499 }