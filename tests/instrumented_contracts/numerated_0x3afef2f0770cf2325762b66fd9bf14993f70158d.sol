1 /**
2 
3 https://twitter.com/magacoinerc
4 Telegram Soon!
5 
6 ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠋⠉⡉⣉⡛⣛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
7 ⣿⣿⣿⣿⣿⣿⣿⡿⠋⠁⠄⠄⠄⠄⠄⢀⣸⣿⣿⡿⠿⡯⢙⠿⣿⣿⣿⣿⣿⣿
8 ⣿⣿⣿⣿⣿⣿⡿⠄⠄⠄⠄⠄⡀⡀⠄⢀⣀⣉⣉⣉⠁⠐⣶⣶⣿⣿⣿⣿⣿⣿
9 ⣿⣿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠁⣿⣿⣀⠈⠿⢟⡛⠛⣿⠛⠛⣿⣿⣿⣿⣿⣿⣿
10 ⣿⣿⣿⣿⣿⣿⡆⠄⠄⠄⠄⠄⠈⠁⠰⣄⣴⡬⢵⣴⣿⣤⣽⣿⣿⣿⣿⣿⣿⣿
11 ⣿⣿⣿⣿⣿⣿⡇⠄⢀⢄⡀⠄⠄⠄⠄⡉⠻⣿⡿⠁⠘⠛⡿⣿⣿⣿⣿⣿⣿⣿
12 ⣿⣿⣿⣿⣿⡿⠃⠄⠄⠈⠻⠄⠄⠄⠄⢘⣧⣀⠾⠿⠶⠦⢳⣿⣿⣿⣿⣿⣿⣿
13 ⣿⣿⣿⣿⣿⣶⣤⡀⢀⡀⠄⠄⠄⠄⠄⠄⠻⢣⣶⡒⠶⢤⢾⣿⣿⣿⣿⣿⣿⣿
14 ⣿⣿⣿⣿⡿⠟⠋⠄⢘⣿⣦⡀⠄⠄⠄⠄⠄⠉⠛⠻⠻⠺⣼⣿⠟⠋⠛⠿⣿⣿
15 ⠋⠉⠁⠄⠄⠄⠄⠄⠄⢻⣿⣿⣶⣄⡀⠄⠄⠄⠄⢀⣤⣾⣿⣿⡀⠄⠄⠄⠄⢹
16 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢻⣿⣿⣿⣷⡤⠄⠰⡆⠄⠄⠈⠉⠛⠿⢦⣀⡀⡀⠄
17 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠈⢿⣿⠟⡋⠄⠄⠄⢣⠄⠄⠄⠄⠄⠄⠄⠈⠹⣿⣀
18 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠘⣷⣿⣿⣷⠄⠄⢺⣇⠄⠄⠄⠄⠄⠄⠄⠄⠸⣿
19 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠹⣿⣿⡇⠄⠄⠸⣿⡄⠄⠈⠁⠄⠄⠄⠄⠄⣿
20 ⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢻⣿⡇⠄⠄⠄⢹⣧⠄⠄⠄⠄⠄⠄⠄⠄⠘
21 
22 */
23 // File: @openzeppelin/contracts/utils/Context.sol
24 // SPDX-License-Identifier: MIT
25 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
50 
51 
52 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev Interface of the ERC20 standard as defined in the EIP.
58  */
59 interface IERC20 {
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 
74     /**
75      * @dev Returns the amount of tokens in existence.
76      */
77     function totalSupply() external view returns (uint256);
78 
79     /**
80      * @dev Returns the amount of tokens owned by `account`.
81      */
82     function balanceOf(address account) external view returns (uint256);
83 
84     /**
85      * @dev Moves `amount` tokens from the caller's account to `to`.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transfer(address to, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Returns the remaining number of tokens that `spender` will be
95      * allowed to spend on behalf of `owner` through {transferFrom}. This is
96      * zero by default.
97      *
98      * This value changes when {approve} or {transferFrom} are called.
99      */
100     function allowance(address owner, address spender) external view returns (uint256);
101 
102     /**
103      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * IMPORTANT: Beware that changing an allowance with this method brings the risk
108      * that someone may use both the old and the new allowance by unfortunate
109      * transaction ordering. One possible solution to mitigate this race
110      * condition is to first reduce the spender's allowance to 0 and set the
111      * desired value afterwards:
112      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address spender, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Moves `amount` tokens from `from` to `to` using the
120      * allowance mechanism. `amount` is then deducted from the caller's
121      * allowance.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transferFrom(
128         address from,
129         address to,
130         uint256 amount
131     ) external returns (bool);
132 }
133 
134 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 
142 /**
143  * @dev Interface for the optional metadata functions from the ERC20 standard.
144  *
145  * _Available since v4.1._
146  */
147 interface IERC20Metadata is IERC20 {
148     /**
149      * @dev Returns the name of the token.
150      */
151     function name() external view returns (string memory);
152 
153     /**
154      * @dev Returns the symbol of the token.
155      */
156     function symbol() external view returns (string memory);
157 
158     /**
159      * @dev Returns the decimals places of the token.
160      */
161     function decimals() external view returns (uint8);
162 }
163 
164 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
165 
166 
167 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 
172 
173 
174 /**
175  * @dev Implementation of the {IERC20} interface.
176  *
177  * This implementation is agnostic to the way tokens are created. This means
178  * that a supply mechanism has to be added in a derived contract using {_mint}.
179  * For a generic mechanism see {ERC20PresetMinterPauser}.
180  *
181  * TIP: For a detailed writeup see our guide
182  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
183  * to implement supply mechanisms].
184  *
185  * We have followed general OpenZeppelin Contracts guidelines: functions revert
186  * instead returning `false` on failure. This behavior is nonetheless
187  * conventional and does not conflict with the expectations of ERC20
188  * applications.
189  *
190  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
191  * This allows applications to reconstruct the allowance for all accounts just
192  * by listening to said events. Other implementations of the EIP may not emit
193  * these events, as it isn't required by the specification.
194  *
195  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
196  * functions have been added to mitigate the well-known issues around setting
197  * allowances. See {IERC20-approve}.
198  */
199 contract ERC20 is Context, IERC20, IERC20Metadata {
200     mapping(address => uint256) private _balances;
201 
202     mapping(address => mapping(address => uint256)) private _allowances;
203 
204     uint256 private _totalSupply;
205 
206     string private _name;
207     string private _symbol;
208 
209     /**
210      * @dev Sets the values for {name} and {symbol}.
211      *
212      * The default value of {decimals} is 18. To select a different value for
213      * {decimals} you should overload it.
214      *
215      * All two of these values are immutable: they can only be set once during
216      * construction.
217      */
218     constructor(string memory name_, string memory symbol_) {
219         _name = name_;
220         _symbol = symbol_;
221     }
222 
223     /**
224      * @dev Returns the name of the token.
225      */
226     function name() public view virtual override returns (string memory) {
227         return _name;
228     }
229 
230     /**
231      * @dev Returns the symbol of the token, usually a shorter version of the
232      * name.
233      */
234     function symbol() public view virtual override returns (string memory) {
235         return _symbol;
236     }
237 
238     /**
239      * @dev Returns the number of decimals used to get its user representation.
240      * For example, if `decimals` equals `2`, a balance of `505` tokens should
241      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
242      *
243      * Tokens usually opt for a value of 18, imitating the relationship between
244      * Ether and Wei. This is the value {ERC20} uses, unless this function is
245      * overridden;
246      *
247      * NOTE: This information is only used for _display_ purposes: it in
248      * no way affects any of the arithmetic of the contract, including
249      * {IERC20-balanceOf} and {IERC20-transfer}.
250      */
251     function decimals() public view virtual override returns (uint8) {
252         return 18;
253     }
254 
255     /**
256      * @dev See {IERC20-totalSupply}.
257      */
258     function totalSupply() public view virtual override returns (uint256) {
259         return _totalSupply;
260     }
261 
262     /**
263      * @dev See {IERC20-balanceOf}.
264      */
265     function balanceOf(address account) public view virtual override returns (uint256) {
266         return _balances[account];
267     }
268 
269     /**
270      * @dev See {IERC20-transfer}.
271      *
272      * Requirements:
273      *
274      * - `to` cannot be the zero address.
275      * - the caller must have a balance of at least `amount`.
276      */
277     function transfer(address to, uint256 amount) public virtual override returns (bool) {
278         address owner = _msgSender();
279         _transfer(owner, to, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-allowance}.
285      */
286     function allowance(address owner, address spender) public view virtual override returns (uint256) {
287         return _allowances[owner][spender];
288     }
289 
290     /**
291      * @dev See {IERC20-approve}.
292      *
293      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
294      * `transferFrom`. This is semantically equivalent to an infinite approval.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function approve(address spender, uint256 amount) public virtual override returns (bool) {
301         address owner = _msgSender();
302         _approve(owner, spender, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-transferFrom}.
308      *
309      * Emits an {Approval} event indicating the updated allowance. This is not
310      * required by the EIP. See the note at the beginning of {ERC20}.
311      *
312      * NOTE: Does not update the allowance if the current allowance
313      * is the maximum `uint256`.
314      *
315      * Requirements:
316      *
317      * - `from` and `to` cannot be the zero address.
318      * - `from` must have a balance of at least `amount`.
319      * - the caller must have allowance for ``from``'s tokens of at least
320      * `amount`.
321      */
322     function transferFrom(
323         address from,
324         address to,
325         uint256 amount
326     ) public virtual override returns (bool) {
327         address spender = _msgSender();
328         _spendAllowance(from, spender, amount);
329         _transfer(from, to, amount);
330         return true;
331     }
332 
333     /**
334      * @dev Atomically increases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
346         address owner = _msgSender();
347         _approve(owner, spender, allowance(owner, spender) + addedValue);
348         return true;
349     }
350 
351     /**
352      * @dev Atomically decreases the allowance granted to `spender` by the caller.
353      *
354      * This is an alternative to {approve} that can be used as a mitigation for
355      * problems described in {IERC20-approve}.
356      *
357      * Emits an {Approval} event indicating the updated allowance.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      * - `spender` must have allowance for the caller of at least
363      * `subtractedValue`.
364      */
365     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
366         address owner = _msgSender();
367         uint256 currentAllowance = allowance(owner, spender);
368         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
369         unchecked {
370             _approve(owner, spender, currentAllowance - subtractedValue);
371         }
372 
373         return true;
374     }
375 
376     /**
377      * @dev Moves `amount` of tokens from `from` to `to`.
378      *
379      * This internal function is equivalent to {transfer}, and can be used to
380      * e.g. implement automatic token fees, slashing mechanisms, etc.
381      *
382      * Emits a {Transfer} event.
383      *
384      * Requirements:
385      *
386      * - `from` cannot be the zero address.
387      * - `to` cannot be the zero address.
388      * - `from` must have a balance of at least `amount`.
389      */
390     function _transfer(
391         address from,
392         address to,
393         uint256 amount
394     ) internal virtual {
395         require(from != address(0), "ERC20: transfer from the zero address");
396         require(to != address(0), "ERC20: transfer to the zero address");
397 
398         _beforeTokenTransfer(from, to, amount);
399 
400         uint256 fromBalance = _balances[from];
401         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
402         unchecked {
403             _balances[from] = fromBalance - amount;
404             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
405             // decrementing then incrementing.
406             _balances[to] += amount;
407         }
408 
409         emit Transfer(from, to, amount);
410 
411         _afterTokenTransfer(from, to, amount);
412     }
413 
414     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
415      * the total supply.
416      *
417      * Emits a {Transfer} event with `from` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      */
423     function _mint(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: mint to the zero address");
425 
426         _beforeTokenTransfer(address(0), account, amount);
427 
428         _totalSupply += amount;
429         unchecked {
430             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
431             _balances[account] += amount;
432         }
433         emit Transfer(address(0), account, amount);
434 
435         _afterTokenTransfer(address(0), account, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`, reducing the
440      * total supply.
441      *
442      * Emits a {Transfer} event with `to` set to the zero address.
443      *
444      * Requirements:
445      *
446      * - `account` cannot be the zero address.
447      * - `account` must have at least `amount` tokens.
448      */
449     function _burn(address account, uint256 amount) internal virtual {
450         require(account != address(0), "ERC20: burn from the zero address");
451 
452         _beforeTokenTransfer(account, address(0), amount);
453 
454         uint256 accountBalance = _balances[account];
455         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
456         unchecked {
457             _balances[account] = accountBalance - amount;
458             // Overflow not possible: amount <= accountBalance <= totalSupply.
459             _totalSupply -= amount;
460         }
461 
462         emit Transfer(account, address(0), amount);
463 
464         _afterTokenTransfer(account, address(0), amount);
465     }
466 
467     /**
468      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
469      *
470      * This internal function is equivalent to `approve`, and can be used to
471      * e.g. set automatic allowances for certain subsystems, etc.
472      *
473      * Emits an {Approval} event.
474      *
475      * Requirements:
476      *
477      * - `owner` cannot be the zero address.
478      * - `spender` cannot be the zero address.
479      */
480     function _approve(
481         address owner,
482         address spender,
483         uint256 amount
484     ) internal virtual {
485         require(owner != address(0), "ERC20: approve from the zero address");
486         require(spender != address(0), "ERC20: approve to the zero address");
487 
488         _allowances[owner][spender] = amount;
489         emit Approval(owner, spender, amount);
490     }
491 
492     /**
493      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
494      *
495      * Does not update the allowance amount in case of infinite allowance.
496      * Revert if not enough allowance is available.
497      *
498      * Might emit an {Approval} event.
499      */
500     function _spendAllowance(
501         address owner,
502         address spender,
503         uint256 amount
504     ) internal virtual {
505         uint256 currentAllowance = allowance(owner, spender);
506         if (currentAllowance != type(uint256).max) {
507             require(currentAllowance >= amount, "ERC20: insufficient allowance");
508             unchecked {
509                 _approve(owner, spender, currentAllowance - amount);
510             }
511         }
512     }
513 
514     /**
515      * @dev Hook that is called before any transfer of tokens. This includes
516      * minting and burning.
517      *
518      * Calling conditions:
519      *
520      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
521      * will be transferred to `to`.
522      * - when `from` is zero, `amount` tokens will be minted for `to`.
523      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
524      * - `from` and `to` are never both zero.
525      *
526      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
527      */
528     function _beforeTokenTransfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal virtual {}
533 
534     /**
535      * @dev Hook that is called after any transfer of tokens. This includes
536      * minting and burning.
537      *
538      * Calling conditions:
539      *
540      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
541      * has been transferred to `to`.
542      * - when `from` is zero, `amount` tokens have been minted for `to`.
543      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
544      * - `from` and `to` are never both zero.
545      *
546      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
547      */
548     function _afterTokenTransfer(
549         address from,
550         address to,
551         uint256 amount
552     ) internal virtual {}
553 }
554 
555 pragma solidity ^0.8.9;
556 
557 
558 contract MAGACoin is ERC20 {
559     constructor() ERC20("Make America Great Again", "MAGA") {
560         _mint(msg.sender, 454545454545 * 10 ** decimals());
561     }
562 }