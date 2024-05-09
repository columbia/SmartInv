1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Emitted when `value` tokens are moved from one account (`from`) to
11      * another (`to`).
12      *
13      * Note that `value` may be zero.
14      */
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 
17     /**
18      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
19      * a call to {approve}. `value` is the new allowance.
20      */
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `to`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address to, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `from` to `to` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(
77         address from,
78         address to,
79         uint256 amount
80     ) external returns (bool);
81 }
82 
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
105 /**
106  * @dev Provides information about the current execution context, including the
107  * sender of the transaction and its data. While these are generally available
108  * via msg.sender and msg.data, they should not be accessed in such a direct
109  * manner, since when dealing with meta-transactions the account sending and
110  * paying for execution may not be the actual sender (as far as an application
111  * is concerned).
112  *
113  * This contract is only required for intermediate, library-like contracts.
114  */
115 abstract contract Context {
116     function _msgSender() internal view virtual returns (address) {
117         return msg.sender;
118     }
119 
120     function _msgData() internal view virtual returns (bytes calldata) {
121         return msg.data;
122     }
123 }
124 
125 /**
126  * @dev Implementation of the {IERC20} interface.
127  *
128  * This implementation is agnostic to the way tokens are created. This means
129  * that a supply mechanism has to be added in a derived contract using {_mint}.
130  * For a generic mechanism see {ERC20PresetMinterPauser}.
131  *
132  * TIP: For a detailed writeup see our guide
133  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
134  * to implement supply mechanisms].
135  *
136  * We have followed general OpenZeppelin Contracts guidelines: functions revert
137  * instead returning `false` on failure. This behavior is nonetheless
138  * conventional and does not conflict with the expectations of ERC20
139  * applications.
140  *
141  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
142  * This allows applications to reconstruct the allowance for all accounts just
143  * by listening to said events. Other implementations of the EIP may not emit
144  * these events, as it isn't required by the specification.
145  *
146  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
147  * functions have been added to mitigate the well-known issues around setting
148  * allowances. See {IERC20-approve}.
149  */
150 contract ERC20 is Context, IERC20, IERC20Metadata {
151     mapping(address => uint256) private _balances;
152 
153     mapping(address => mapping(address => uint256)) private _allowances;
154 
155     uint256 private _totalSupply;
156 
157     string private _name;
158     string private _symbol;
159 
160     /**
161      * @dev Sets the values for {name} and {symbol}.
162      *
163      * The default value of {decimals} is 18. To select a different value for
164      * {decimals} you should overload it.
165      *
166      * All two of these values are immutable: they can only be set once during
167      * construction.
168      */
169     constructor(string memory name_, string memory symbol_) {
170         _name = name_;
171         _symbol = symbol_;
172     }
173 
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() public view virtual override returns (string memory) {
178         return _name;
179     }
180 
181     /**
182      * @dev Returns the symbol of the token, usually a shorter version of the
183      * name.
184      */
185     function symbol() public view virtual override returns (string memory) {
186         return _symbol;
187     }
188 
189     /**
190      * @dev Returns the number of decimals used to get its user representation.
191      * For example, if `decimals` equals `2`, a balance of `505` tokens should
192      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
193      *
194      * Tokens usually opt for a value of 18, imitating the relationship between
195      * Ether and Wei. This is the value {ERC20} uses, unless this function is
196      * overridden;
197      *
198      * NOTE: This information is only used for _display_ purposes: it in
199      * no way affects any of the arithmetic of the contract, including
200      * {IERC20-balanceOf} and {IERC20-transfer}.
201      */
202     function decimals() public view virtual override returns (uint8) {
203         return 18;
204     }
205 
206     /**
207      * @dev See {IERC20-totalSupply}.
208      */
209     function totalSupply() public view virtual override returns (uint256) {
210         return _totalSupply;
211     }
212 
213     /**
214      * @dev See {IERC20-balanceOf}.
215      */
216     function balanceOf(address account) public view virtual override returns (uint256) {
217         return _balances[account];
218     }
219 
220     /**
221      * @dev See {IERC20-transfer}.
222      *
223      * Requirements:
224      *
225      * - `to` cannot be the zero address.
226      * - the caller must have a balance of at least `amount`.
227      */
228     function transfer(address to, uint256 amount) public virtual override returns (bool) {
229         address owner = _msgSender();
230         _transfer(owner, to, amount);
231         return true;
232     }
233 
234     /**
235      * @dev See {IERC20-allowance}.
236      */
237     function allowance(address owner, address spender) public view virtual override returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     /**
242      * @dev See {IERC20-approve}.
243      *
244      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
245      * `transferFrom`. This is semantically equivalent to an infinite approval.
246      *
247      * Requirements:
248      *
249      * - `spender` cannot be the zero address.
250      */
251     function approve(address spender, uint256 amount) public virtual override returns (bool) {
252         address owner = _msgSender();
253         _approve(owner, spender, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-transferFrom}.
259      *
260      * Emits an {Approval} event indicating the updated allowance. This is not
261      * required by the EIP. See the note at the beginning of {ERC20}.
262      *
263      * NOTE: Does not update the allowance if the current allowance
264      * is the maximum `uint256`.
265      *
266      * Requirements:
267      *
268      * - `from` and `to` cannot be the zero address.
269      * - `from` must have a balance of at least `amount`.
270      * - the caller must have allowance for ``from``'s tokens of at least
271      * `amount`.
272      */
273     function transferFrom(
274         address from,
275         address to,
276         uint256 amount
277     ) public virtual override returns (bool) {
278         address spender = _msgSender();
279         _spendAllowance(from, spender, amount);
280         _transfer(from, to, amount);
281         return true;
282     }
283 
284     /**
285      * @dev Atomically increases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
297         address owner = _msgSender();
298         _approve(owner, spender, allowance(owner, spender) + addedValue);
299         return true;
300     }
301 
302     /**
303      * @dev Atomically decreases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      * - `spender` must have allowance for the caller of at least
314      * `subtractedValue`.
315      */
316     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
317         address owner = _msgSender();
318         uint256 currentAllowance = allowance(owner, spender);
319         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
320         unchecked {
321             _approve(owner, spender, currentAllowance - subtractedValue);
322         }
323 
324         return true;
325     }
326 
327     /**
328      * @dev Moves `amount` of tokens from `from` to `to`.
329      *
330      * This internal function is equivalent to {transfer}, and can be used to
331      * e.g. implement automatic token fees, slashing mechanisms, etc.
332      *
333      * Emits a {Transfer} event.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `from` must have a balance of at least `amount`.
340      */
341     function _transfer(
342         address from,
343         address to,
344         uint256 amount
345     ) internal virtual {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348 
349         _beforeTokenTransfer(from, to, amount);
350 
351         uint256 fromBalance = _balances[from];
352         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
353         unchecked {
354             _balances[from] = fromBalance - amount;
355             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
356             // decrementing then incrementing.
357             _balances[to] += amount;
358         }
359 
360         emit Transfer(from, to, amount);
361 
362         _afterTokenTransfer(from, to, amount);
363     }
364 
365     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
366      * the total supply.
367      *
368      * Emits a {Transfer} event with `from` set to the zero address.
369      *
370      * Requirements:
371      *
372      * - `account` cannot be the zero address.
373      */
374     function _mint(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: mint to the zero address");
376 
377         _beforeTokenTransfer(address(0), account, amount);
378 
379         _totalSupply += amount;
380         unchecked {
381             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
382             _balances[account] += amount;
383         }
384         emit Transfer(address(0), account, amount);
385 
386         _afterTokenTransfer(address(0), account, amount);
387     }
388 
389     /**
390      * @dev Destroys `amount` tokens from `account`, reducing the
391      * total supply.
392      *
393      * Emits a {Transfer} event with `to` set to the zero address.
394      *
395      * Requirements:
396      *
397      * - `account` cannot be the zero address.
398      * - `account` must have at least `amount` tokens.
399      */
400     function _burn(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: burn from the zero address");
402 
403         _beforeTokenTransfer(account, address(0), amount);
404 
405         uint256 accountBalance = _balances[account];
406         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
407         unchecked {
408             _balances[account] = accountBalance - amount;
409             // Overflow not possible: amount <= accountBalance <= totalSupply.
410             _totalSupply -= amount;
411         }
412 
413         emit Transfer(account, address(0), amount);
414 
415         _afterTokenTransfer(account, address(0), amount);
416     }
417 
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
420      *
421      * This internal function is equivalent to `approve`, and can be used to
422      * e.g. set automatic allowances for certain subsystems, etc.
423      *
424      * Emits an {Approval} event.
425      *
426      * Requirements:
427      *
428      * - `owner` cannot be the zero address.
429      * - `spender` cannot be the zero address.
430      */
431     function _approve(
432         address owner,
433         address spender,
434         uint256 amount
435     ) internal virtual {
436         require(owner != address(0), "ERC20: approve from the zero address");
437         require(spender != address(0), "ERC20: approve to the zero address");
438 
439         _allowances[owner][spender] = amount;
440         emit Approval(owner, spender, amount);
441     }
442 
443     /**
444      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
445      *
446      * Does not update the allowance amount in case of infinite allowance.
447      * Revert if not enough allowance is available.
448      *
449      * Might emit an {Approval} event.
450      */
451     function _spendAllowance(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         uint256 currentAllowance = allowance(owner, spender);
457         if (currentAllowance != type(uint256).max) {
458             require(currentAllowance >= amount, "ERC20: insufficient allowance");
459             unchecked {
460                 _approve(owner, spender, currentAllowance - amount);
461             }
462         }
463     }
464 
465     /**
466      * @dev Hook that is called before any transfer of tokens. This includes
467      * minting and burning.
468      *
469      * Calling conditions:
470      *
471      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
472      * will be transferred to `to`.
473      * - when `from` is zero, `amount` tokens will be minted for `to`.
474      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
475      * - `from` and `to` are never both zero.
476      *
477      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
478      */
479     function _beforeTokenTransfer(
480         address from,
481         address to,
482         uint256 amount
483     ) internal virtual {}
484 
485     /**
486      * @dev Hook that is called after any transfer of tokens. This includes
487      * minting and burning.
488      *
489      * Calling conditions:
490      *
491      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
492      * has been transferred to `to`.
493      * - when `from` is zero, `amount` tokens have been minted for `to`.
494      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
495      * - `from` and `to` are never both zero.
496      *
497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
498      */
499     function _afterTokenTransfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {}
504 }
505 
506 contract ET is ERC20 {
507     /**
508      * @dev Constructor that gives msg.sender all of existing tokens.
509      */
510     constructor(
511         string memory name,
512         string memory symbol,
513         uint256 totalSupply
514     ) ERC20(name, symbol) {
515         // name = "The One Question";
516         // symbol = "ET";
517         // uint256 totalSupply = 10 ** 9 * 10 ** 18; // 1 billion total supply
518         _mint(msg.sender, totalSupply);
519     }
520 }