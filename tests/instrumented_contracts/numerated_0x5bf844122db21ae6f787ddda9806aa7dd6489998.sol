1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.4;
4 
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
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `to`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address to, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
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
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 /**
100  * @dev Interface for the optional metadata functions from the ERC20 standard.
101  *
102  * _Available since v4.1._
103  */
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 
122 /**
123  * @dev Implementation of the {IERC20} interface.
124  *
125  * This implementation is agnostic to the way tokens are created. This means
126  * that a supply mechanism has to be added in a derived contract using {_mint}.
127  * For a generic mechanism see {ERC20PresetMinterPauser}.
128  *
129  * TIP: For a detailed writeup see our guide
130  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
131  * to implement supply mechanisms].
132  *
133  * We have followed general OpenZeppelin Contracts guidelines: functions revert
134  * instead returning `false` on failure. This behavior is nonetheless
135  * conventional and does not conflict with the expectations of ERC20
136  * applications.
137  *
138  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
139  * This allows applications to reconstruct the allowance for all accounts just
140  * by listening to said events. Other implementations of the EIP may not emit
141  * these events, as it isn't required by the specification.
142  *
143  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
144  * functions have been added to mitigate the well-known issues around setting
145  * allowances. See {IERC20-approve}.
146  */
147 contract ERC20 is Context, IERC20, IERC20Metadata {
148     mapping(address => uint256) private _balances;
149 
150     mapping(address => mapping(address => uint256)) private _allowances;
151 
152     uint256 private _totalSupply;
153 
154     string private _name;
155     string private _symbol;
156 
157     /**
158      * @dev Sets the values for {name} and {symbol}.
159      *
160      * The default value of {decimals} is 18. To select a different value for
161      * {decimals} you should overload it.
162      *
163      * All two of these values are immutable: they can only be set once during
164      * construction.
165      */
166     constructor(string memory name_, string memory symbol_) {
167         _name = name_;
168         _symbol = symbol_;
169     }
170 
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() public view virtual override returns (string memory) {
175         return _name;
176     }
177 
178     /**
179      * @dev Returns the symbol of the token, usually a shorter version of the
180      * name.
181      */
182     function symbol() public view virtual override returns (string memory) {
183         return _symbol;
184     }
185 
186     /**
187      * @dev Returns the number of decimals used to get its user representation.
188      * For example, if `decimals` equals `2`, a balance of `505` tokens should
189      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
190      *
191      * Tokens usually opt for a value of 18, imitating the relationship between
192      * Ether and Wei. This is the value {ERC20} uses, unless this function is
193      * overridden;
194      *
195      * NOTE: This information is only used for _display_ purposes: it in
196      * no way affects any of the arithmetic of the contract, including
197      * {IERC20-balanceOf} and {IERC20-transfer}.
198      */
199     function decimals() public view virtual override returns (uint8) {
200         return 18;
201     }
202 
203     /**
204      * @dev See {IERC20-totalSupply}.
205      */
206     function totalSupply() public view virtual override returns (uint256) {
207         return _totalSupply;
208     }
209 
210     /**
211      * @dev See {IERC20-balanceOf}.
212      */
213     function balanceOf(address account) public view virtual override returns (uint256) {
214         return _balances[account];
215     }
216 
217     /**
218      * @dev See {IERC20-transfer}.
219      *
220      * Requirements:
221      *
222      * - `to` cannot be the zero address.
223      * - the caller must have a balance of at least `amount`.
224      */
225     function transfer(address to, uint256 amount) public virtual override returns (bool) {
226         address owner = _msgSender();
227         _transfer(owner, to, amount);
228         return true;
229     }
230 
231     /**
232      * @dev See {IERC20-allowance}.
233      */
234     function allowance(address owner, address spender) public view virtual override returns (uint256) {
235         return _allowances[owner][spender];
236     }
237 
238     /**
239      * @dev See {IERC20-approve}.
240      *
241      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
242      * `transferFrom`. This is semantically equivalent to an infinite approval.
243      *
244      * Requirements:
245      *
246      * - `spender` cannot be the zero address.
247      */
248     function approve(address spender, uint256 amount) public virtual override returns (bool) {
249         address owner = _msgSender();
250         _approve(owner, spender, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-transferFrom}.
256      *
257      * Emits an {Approval} event indicating the updated allowance. This is not
258      * required by the EIP. See the note at the beginning of {ERC20}.
259      *
260      * NOTE: Does not update the allowance if the current allowance
261      * is the maximum `uint256`.
262      *
263      * Requirements:
264      *
265      * - `from` and `to` cannot be the zero address.
266      * - `from` must have a balance of at least `amount`.
267      * - the caller must have allowance for ``from``'s tokens of at least
268      * `amount`.
269      */
270     function transferFrom(
271         address from,
272         address to,
273         uint256 amount
274     ) public virtual override returns (bool) {
275         address spender = _msgSender();
276         _spendAllowance(from, spender, amount);
277         _transfer(from, to, amount);
278         return true;
279     }
280 
281     /**
282      * @dev Atomically increases the allowance granted to `spender` by the caller.
283      *
284      * This is an alternative to {approve} that can be used as a mitigation for
285      * problems described in {IERC20-approve}.
286      *
287      * Emits an {Approval} event indicating the updated allowance.
288      *
289      * Requirements:
290      *
291      * - `spender` cannot be the zero address.
292      */
293     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
294         address owner = _msgSender();
295         _approve(owner, spender, _allowances[owner][spender] + addedValue);
296         return true;
297     }
298 
299     /**
300      * @dev Atomically decreases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to {approve} that can be used as a mitigation for
303      * problems described in {IERC20-approve}.
304      *
305      * Emits an {Approval} event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      * - `spender` must have allowance for the caller of at least
311      * `subtractedValue`.
312      */
313     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
314         address owner = _msgSender();
315         uint256 currentAllowance = _allowances[owner][spender];
316         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
317         unchecked {
318             _approve(owner, spender, currentAllowance - subtractedValue);
319         }
320 
321         return true;
322     }
323 
324     /**
325      * @dev Moves `amount` of tokens from `sender` to `recipient`.
326      *
327      * This internal function is equivalent to {transfer}, and can be used to
328      * e.g. implement automatic token fees, slashing mechanisms, etc.
329      *
330      * Emits a {Transfer} event.
331      *
332      * Requirements:
333      *
334      * - `from` cannot be the zero address.
335      * - `to` cannot be the zero address.
336      * - `from` must have a balance of at least `amount`.
337      */
338     function _transfer(
339         address from,
340         address to,
341         uint256 amount
342     ) internal virtual {
343         require(from != address(0), "ERC20: transfer from the zero address");
344         require(to != address(0), "ERC20: transfer to the zero address");
345 
346         _beforeTokenTransfer(from, to, amount);
347 
348         uint256 fromBalance = _balances[from];
349         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
350         unchecked {
351             _balances[from] = fromBalance - amount;
352         }
353         _balances[to] += amount;
354 
355         emit Transfer(from, to, amount);
356 
357         _afterTokenTransfer(from, to, amount);
358     }
359 
360     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
361      * the total supply.
362      *
363      * Emits a {Transfer} event with `from` set to the zero address.
364      *
365      * Requirements:
366      *
367      * - `account` cannot be the zero address.
368      */
369     function _mint(address account, uint256 amount) internal virtual {
370         require(account != address(0), "ERC20: mint to the zero address");
371 
372         _beforeTokenTransfer(address(0), account, amount);
373 
374         _totalSupply += amount;
375         _balances[account] += amount;
376         emit Transfer(address(0), account, amount);
377 
378         _afterTokenTransfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _beforeTokenTransfer(account, address(0), amount);
396 
397         uint256 accountBalance = _balances[account];
398         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
399         unchecked {
400             _balances[account] = accountBalance - amount;
401         }
402         _totalSupply -= amount;
403 
404         emit Transfer(account, address(0), amount);
405 
406         _afterTokenTransfer(account, address(0), amount);
407     }
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
411      *
412      * This internal function is equivalent to `approve`, and can be used to
413      * e.g. set automatic allowances for certain subsystems, etc.
414      *
415      * Emits an {Approval} event.
416      *
417      * Requirements:
418      *
419      * - `owner` cannot be the zero address.
420      * - `spender` cannot be the zero address.
421      */
422     function _approve(
423         address owner,
424         address spender,
425         uint256 amount
426     ) internal virtual {
427         require(owner != address(0), "ERC20: approve from the zero address");
428         require(spender != address(0), "ERC20: approve to the zero address");
429 
430         _allowances[owner][spender] = amount;
431         emit Approval(owner, spender, amount);
432     }
433 
434     /**
435      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
436      *
437      * Does not update the allowance amount in case of infinite allowance.
438      * Revert if not enough allowance is available.
439      *
440      * Might emit an {Approval} event.
441      */
442     function _spendAllowance(
443         address owner,
444         address spender,
445         uint256 amount
446     ) internal virtual {
447         uint256 currentAllowance = allowance(owner, spender);
448         if (currentAllowance != type(uint256).max) {
449             require(currentAllowance >= amount, "ERC20: insufficient allowance");
450             unchecked {
451                 _approve(owner, spender, currentAllowance - amount);
452             }
453         }
454     }
455 
456     /**
457      * @dev Hook that is called before any transfer of tokens. This includes
458      * minting and burning.
459      *
460      * Calling conditions:
461      *
462      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
463      * will be transferred to `to`.
464      * - when `from` is zero, `amount` tokens will be minted for `to`.
465      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
466      * - `from` and `to` are never both zero.
467      *
468      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
469      */
470     function _beforeTokenTransfer(
471         address from,
472         address to,
473         uint256 amount
474     ) internal virtual {}
475 
476     /**
477      * @dev Hook that is called after any transfer of tokens. This includes
478      * minting and burning.
479      *
480      * Calling conditions:
481      *
482      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
483      * has been transferred to `to`.
484      * - when `from` is zero, `amount` tokens have been minted for `to`.
485      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
486      * - `from` and `to` are never both zero.
487      *
488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
489      */
490     function _afterTokenTransfer(
491         address from,
492         address to,
493         uint256 amount
494     ) internal virtual {}
495 }
496 
497 contract RexToken is ERC20 {
498     constructor() ERC20("Runex", "REX") {
499         _mint(msg.sender, 300000000 * 10 ** decimals());
500     }
501 }