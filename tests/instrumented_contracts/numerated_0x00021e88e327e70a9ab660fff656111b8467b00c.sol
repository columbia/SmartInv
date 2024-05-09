1 // Sources flattened with hardhat v2.14.0 https://hardhat.org
2 
3 // File lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
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
89 // File lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
90 
91 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 
116 // File lib/openzeppelin-contracts/contracts/utils/Context.sol
117 
118 /**
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         return msg.data;
135     }
136 }
137 
138 
139 // File lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
140 
141 
142 
143 
144 /**
145  * @dev Implementation of the {IERC20} interface.
146  *
147  * This implementation is agnostic to the way tokens are created. This means
148  * that a supply mechanism has to be added in a derived contract using {_mint}.
149  * For a generic mechanism see {ERC20PresetMinterPauser}.
150  *
151  * TIP: For a detailed writeup see our guide
152  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
153  * to implement supply mechanisms].
154  *
155  * We have followed general OpenZeppelin Contracts guidelines: functions revert
156  * instead returning `false` on failure. This behavior is nonetheless
157  * conventional and does not conflict with the expectations of ERC20
158  * applications.
159  *
160  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
161  * This allows applications to reconstruct the allowance for all accounts just
162  * by listening to said events. Other implementations of the EIP may not emit
163  * these events, as it isn't required by the specification.
164  *
165  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
166  * functions have been added to mitigate the well-known issues around setting
167  * allowances. See {IERC20-approve}.
168  */
169 contract ERC20 is Context, IERC20, IERC20Metadata {
170     mapping(address => uint256) private _balances;
171 
172     mapping(address => mapping(address => uint256)) private _allowances;
173 
174     uint256 private _totalSupply;
175 
176     string private _name;
177     string private _symbol;
178 
179     /**
180      * @dev Sets the values for {name} and {symbol}.
181      *
182      * The default value of {decimals} is 18. To select a different value for
183      * {decimals} you should overload it.
184      *
185      * All two of these values are immutable: they can only be set once during
186      * construction.
187      */
188     constructor(string memory name_, string memory symbol_) {
189         _name = name_;
190         _symbol = symbol_;
191     }
192 
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() public view virtual override returns (string memory) {
197         return _name;
198     }
199 
200     /**
201      * @dev Returns the symbol of the token, usually a shorter version of the
202      * name.
203      */
204     function symbol() public view virtual override returns (string memory) {
205         return _symbol;
206     }
207 
208     /**
209      * @dev Returns the number of decimals used to get its user representation.
210      * For example, if `decimals` equals `2`, a balance of `505` tokens should
211      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
212      *
213      * Tokens usually opt for a value of 18, imitating the relationship between
214      * Ether and Wei. This is the value {ERC20} uses, unless this function is
215      * overridden;
216      *
217      * NOTE: This information is only used for _display_ purposes: it in
218      * no way affects any of the arithmetic of the contract, including
219      * {IERC20-balanceOf} and {IERC20-transfer}.
220      */
221     function decimals() public view virtual override returns (uint8) {
222         return 18;
223     }
224 
225     /**
226      * @dev See {IERC20-totalSupply}.
227      */
228     function totalSupply() public view virtual override returns (uint256) {
229         return _totalSupply;
230     }
231 
232     /**
233      * @dev See {IERC20-balanceOf}.
234      */
235     function balanceOf(address account) public view virtual override returns (uint256) {
236         return _balances[account];
237     }
238 
239     /**
240      * @dev See {IERC20-transfer}.
241      *
242      * Requirements:
243      *
244      * - `to` cannot be the zero address.
245      * - the caller must have a balance of at least `amount`.
246      */
247     function transfer(address to, uint256 amount) public virtual override returns (bool) {
248         address owner = _msgSender();
249         _transfer(owner, to, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
264      * `transferFrom`. This is semantically equivalent to an infinite approval.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 amount) public virtual override returns (bool) {
271         address owner = _msgSender();
272         _approve(owner, spender, amount);
273         return true;
274     }
275 
276     /**
277      * @dev See {IERC20-transferFrom}.
278      *
279      * Emits an {Approval} event indicating the updated allowance. This is not
280      * required by the EIP. See the note at the beginning of {ERC20}.
281      *
282      * NOTE: Does not update the allowance if the current allowance
283      * is the maximum `uint256`.
284      *
285      * Requirements:
286      *
287      * - `from` and `to` cannot be the zero address.
288      * - `from` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``from``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address from,
294         address to,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         address spender = _msgSender();
298         _spendAllowance(from, spender, amount);
299         _transfer(from, to, amount);
300         return true;
301     }
302 
303     /**
304      * @dev Atomically increases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
316         address owner = _msgSender();
317         _approve(owner, spender, allowance(owner, spender) + addedValue);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         address owner = _msgSender();
337         uint256 currentAllowance = allowance(owner, spender);
338         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
339         unchecked {
340             _approve(owner, spender, currentAllowance - subtractedValue);
341         }
342 
343         return true;
344     }
345 
346     /**
347      * @dev Moves `amount` of tokens from `from` to `to`.
348      *
349      * This internal function is equivalent to {transfer}, and can be used to
350      * e.g. implement automatic token fees, slashing mechanisms, etc.
351      *
352      * Emits a {Transfer} event.
353      *
354      * Requirements:
355      *
356      * - `from` cannot be the zero address.
357      * - `to` cannot be the zero address.
358      * - `from` must have a balance of at least `amount`.
359      */
360     function _transfer(
361         address from,
362         address to,
363         uint256 amount
364     ) internal virtual {
365         require(from != address(0), "ERC20: transfer from the zero address");
366         require(to != address(0), "ERC20: transfer to the zero address");
367 
368         _beforeTokenTransfer(from, to, amount);
369 
370         uint256 fromBalance = _balances[from];
371         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
372         unchecked {
373             _balances[from] = fromBalance - amount;
374             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
375             // decrementing then incrementing.
376             _balances[to] += amount;
377         }
378 
379         emit Transfer(from, to, amount);
380 
381         _afterTokenTransfer(from, to, amount);
382     }
383 
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395 
396         _beforeTokenTransfer(address(0), account, amount);
397 
398         _totalSupply += amount;
399         unchecked {
400             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
401             _balances[account] += amount;
402         }
403         emit Transfer(address(0), account, amount);
404 
405         _afterTokenTransfer(address(0), account, amount);
406     }
407 
408     /**
409      * @dev Destroys `amount` tokens from `account`, reducing the
410      * total supply.
411      *
412      * Emits a {Transfer} event with `to` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      * - `account` must have at least `amount` tokens.
418      */
419     function _burn(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: burn from the zero address");
421 
422         _beforeTokenTransfer(account, address(0), amount);
423 
424         uint256 accountBalance = _balances[account];
425         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
426         unchecked {
427             _balances[account] = accountBalance - amount;
428             // Overflow not possible: amount <= accountBalance <= totalSupply.
429             _totalSupply -= amount;
430         }
431 
432         emit Transfer(account, address(0), amount);
433 
434         _afterTokenTransfer(account, address(0), amount);
435     }
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
439      *
440      * This internal function is equivalent to `approve`, and can be used to
441      * e.g. set automatic allowances for certain subsystems, etc.
442      *
443      * Emits an {Approval} event.
444      *
445      * Requirements:
446      *
447      * - `owner` cannot be the zero address.
448      * - `spender` cannot be the zero address.
449      */
450     function _approve(
451         address owner,
452         address spender,
453         uint256 amount
454     ) internal virtual {
455         require(owner != address(0), "ERC20: approve from the zero address");
456         require(spender != address(0), "ERC20: approve to the zero address");
457 
458         _allowances[owner][spender] = amount;
459         emit Approval(owner, spender, amount);
460     }
461 
462     /**
463      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
464      *
465      * Does not update the allowance amount in case of infinite allowance.
466      * Revert if not enough allowance is available.
467      *
468      * Might emit an {Approval} event.
469      */
470     function _spendAllowance(
471         address owner,
472         address spender,
473         uint256 amount
474     ) internal virtual {
475         uint256 currentAllowance = allowance(owner, spender);
476         if (currentAllowance != type(uint256).max) {
477             require(currentAllowance >= amount, "ERC20: insufficient allowance");
478             unchecked {
479                 _approve(owner, spender, currentAllowance - amount);
480             }
481         }
482     }
483 
484     /**
485      * @dev Hook that is called before any transfer of tokens. This includes
486      * minting and burning.
487      *
488      * Calling conditions:
489      *
490      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
491      * will be transferred to `to`.
492      * - when `from` is zero, `amount` tokens will be minted for `to`.
493      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
494      * - `from` and `to` are never both zero.
495      *
496      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
497      */
498     function _beforeTokenTransfer(
499         address from,
500         address to,
501         uint256 amount
502     ) internal virtual {}
503 
504     /**
505      * @dev Hook that is called after any transfer of tokens. This includes
506      * minting and burning.
507      *
508      * Calling conditions:
509      *
510      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
511      * has been transferred to `to`.
512      * - when `from` is zero, `amount` tokens have been minted for `to`.
513      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
514      * - `from` and `to` are never both zero.
515      *
516      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
517      */
518     function _afterTokenTransfer(
519         address from,
520         address to,
521         uint256 amount
522     ) internal virtual {}
523 }
524 
525 
526 // File src/Token21e8.sol
527 
528 contract Token21e8 is ERC20 {
529     // 21e8.cc
530 
531     constructor() ERC20("21e8", "21e8") {
532         _mint(tx.origin, 21e26);
533     }
534 }