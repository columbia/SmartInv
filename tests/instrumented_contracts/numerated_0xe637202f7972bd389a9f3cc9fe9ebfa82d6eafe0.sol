1 // Web: felicette.xyz
2 // Tele: https://t.me/felicette_xyz
3 // Twitter: @felicette_xyz
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/utils/Context.sol
7 
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
34 
35 
36 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Emitted when `value` tokens are moved from one account (`from`) to
46      * another (`to`).
47      *
48      * Note that `value` may be zero.
49      */
50     event Transfer(address indexed from, address indexed to, uint256 value);
51 
52     /**
53      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
54      * a call to {approve}. `value` is the new allowance.
55      */
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `to`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address to, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `from` to `to` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(address from, address to, uint256 amount) external returns (bool);
112 }
113 
114 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 
122 /**
123  * @dev Interface for the optional metadata functions from the ERC20 standard.
124  *
125  * _Available since v4.1._
126  */
127 interface IERC20Metadata is IERC20 {
128     /**
129      * @dev Returns the name of the token.
130      */
131     function name() external view returns (string memory);
132 
133     /**
134      * @dev Returns the symbol of the token.
135      */
136     function symbol() external view returns (string memory);
137 
138     /**
139      * @dev Returns the decimals places of the token.
140      */
141     function decimals() external view returns (uint8);
142 }
143 
144 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
145 
146 
147 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 
153 
154 /**
155  * @dev Implementation of the {IERC20} interface.
156  *
157  * This implementation is agnostic to the way tokens are created. This means
158  * that a supply mechanism has to be added in a derived contract using {_mint}.
159  * For a generic mechanism see {ERC20PresetMinterPauser}.
160  *
161  * TIP: For a detailed writeup see our guide
162  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
163  * to implement supply mechanisms].
164  *
165  * The default value of {decimals} is 18. To change this, you should override
166  * this function so it returns a different value.
167  *
168  * We have followed general OpenZeppelin Contracts guidelines: functions revert
169  * instead returning `false` on failure. This behavior is nonetheless
170  * conventional and does not conflict with the expectations of ERC20
171  * applications.
172  *
173  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
174  * This allows applications to reconstruct the allowance for all accounts just
175  * by listening to said events. Other implementations of the EIP may not emit
176  * these events, as it isn't required by the specification.
177  *
178  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
179  * functions have been added to mitigate the well-known issues around setting
180  * allowances. See {IERC20-approve}.
181  */
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183     mapping(address => uint256) private _balances;
184 
185     mapping(address => mapping(address => uint256)) private _allowances;
186 
187     uint256 private _totalSupply;
188 
189     string private _name;
190     string private _symbol;
191 
192     /**
193      * @dev Sets the values for {name} and {symbol}.
194      *
195      * All two of these values are immutable: they can only be set once during
196      * construction.
197      */
198     constructor(string memory name_, string memory symbol_) {
199         _name = name_;
200         _symbol = symbol_;
201     }
202 
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() public view virtual override returns (string memory) {
207         return _name;
208     }
209 
210     /**
211      * @dev Returns the symbol of the token, usually a shorter version of the
212      * name.
213      */
214     function symbol() public view virtual override returns (string memory) {
215         return _symbol;
216     }
217 
218     /**
219      * @dev Returns the number of decimals used to get its user representation.
220      * For example, if `decimals` equals `2`, a balance of `505` tokens should
221      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
222      *
223      * Tokens usually opt for a value of 18, imitating the relationship between
224      * Ether and Wei. This is the default value returned by this function, unless
225      * it's overridden.
226      *
227      * NOTE: This information is only used for _display_ purposes: it in
228      * no way affects any of the arithmetic of the contract, including
229      * {IERC20-balanceOf} and {IERC20-transfer}.
230      */
231     function decimals() public view virtual override returns (uint8) {
232         return 18;
233     }
234 
235     /**
236      * @dev See {IERC20-totalSupply}.
237      */
238     function totalSupply() public view virtual override returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243      * @dev See {IERC20-balanceOf}.
244      */
245     function balanceOf(address account) public view virtual override returns (uint256) {
246         return _balances[account];
247     }
248 
249     /**
250      * @dev See {IERC20-transfer}.
251      *
252      * Requirements:
253      *
254      * - `to` cannot be the zero address.
255      * - the caller must have a balance of at least `amount`.
256      */
257     function transfer(address to, uint256 amount) public virtual override returns (bool) {
258         address owner = _msgSender();
259         _transfer(owner, to, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-allowance}.
265      */
266     function allowance(address owner, address spender) public view virtual override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
274      * `transferFrom`. This is semantically equivalent to an infinite approval.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         address owner = _msgSender();
282         _approve(owner, spender, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * NOTE: Does not update the allowance if the current allowance
293      * is the maximum `uint256`.
294      *
295      * Requirements:
296      *
297      * - `from` and `to` cannot be the zero address.
298      * - `from` must have a balance of at least `amount`.
299      * - the caller must have allowance for ``from``'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
303         address spender = _msgSender();
304         _spendAllowance(from, spender, amount);
305         _transfer(from, to, amount);
306         return true;
307     }
308 
309     /**
310      * @dev Atomically increases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to {approve} that can be used as a mitigation for
313      * problems described in {IERC20-approve}.
314      *
315      * Emits an {Approval} event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
322         address owner = _msgSender();
323         _approve(owner, spender, allowance(owner, spender) + addedValue);
324         return true;
325     }
326 
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
342         address owner = _msgSender();
343         uint256 currentAllowance = allowance(owner, spender);
344         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
345         unchecked {
346             _approve(owner, spender, currentAllowance - subtractedValue);
347         }
348 
349         return true;
350     }
351 
352     /**
353      * @dev Moves `amount` of tokens from `from` to `to`.
354      *
355      * This internal function is equivalent to {transfer}, and can be used to
356      * e.g. implement automatic token fees, slashing mechanisms, etc.
357      *
358      * Emits a {Transfer} event.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `from` must have a balance of at least `amount`.
365      */
366     function _transfer(address from, address to, uint256 amount) internal virtual {
367         require(from != address(0), "ERC20: transfer from the zero address");
368         require(to != address(0), "ERC20: transfer to the zero address");
369 
370         _beforeTokenTransfer(from, to, amount);
371 
372         uint256 fromBalance = _balances[from];
373         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
374         unchecked {
375             _balances[from] = fromBalance - amount;
376             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
377             // decrementing then incrementing.
378             _balances[to] += amount;
379         }
380 
381         emit Transfer(from, to, amount);
382 
383         _afterTokenTransfer(from, to, amount);
384     }
385 
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397 
398         _beforeTokenTransfer(address(0), account, amount);
399 
400         _totalSupply += amount;
401         unchecked {
402             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
403             _balances[account] += amount;
404         }
405         emit Transfer(address(0), account, amount);
406 
407         _afterTokenTransfer(address(0), account, amount);
408     }
409 
410     /**
411      * @dev Destroys `amount` tokens from `account`, reducing the
412      * total supply.
413      *
414      * Emits a {Transfer} event with `to` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      * - `account` must have at least `amount` tokens.
420      */
421     function _burn(address account, uint256 amount) internal virtual {
422         require(account != address(0), "ERC20: burn from the zero address");
423 
424         _beforeTokenTransfer(account, address(0), amount);
425 
426         uint256 accountBalance = _balances[account];
427         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
428         unchecked {
429             _balances[account] = accountBalance - amount;
430             // Overflow not possible: amount <= accountBalance <= totalSupply.
431             _totalSupply -= amount;
432         }
433 
434         emit Transfer(account, address(0), amount);
435 
436         _afterTokenTransfer(account, address(0), amount);
437     }
438 
439     /**
440      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
441      *
442      * This internal function is equivalent to `approve`, and can be used to
443      * e.g. set automatic allowances for certain subsystems, etc.
444      *
445      * Emits an {Approval} event.
446      *
447      * Requirements:
448      *
449      * - `owner` cannot be the zero address.
450      * - `spender` cannot be the zero address.
451      */
452     function _approve(address owner, address spender, uint256 amount) internal virtual {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     /**
461      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
462      *
463      * Does not update the allowance amount in case of infinite allowance.
464      * Revert if not enough allowance is available.
465      *
466      * Might emit an {Approval} event.
467      */
468     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
469         uint256 currentAllowance = allowance(owner, spender);
470         if (currentAllowance != type(uint256).max) {
471             require(currentAllowance >= amount, "ERC20: insufficient allowance");
472             unchecked {
473                 _approve(owner, spender, currentAllowance - amount);
474             }
475         }
476     }
477 
478     /**
479      * @dev Hook that is called before any transfer of tokens. This includes
480      * minting and burning.
481      *
482      * Calling conditions:
483      *
484      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
485      * will be transferred to `to`.
486      * - when `from` is zero, `amount` tokens will be minted for `to`.
487      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
488      * - `from` and `to` are never both zero.
489      *
490      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
491      */
492     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
493 
494     /**
495      * @dev Hook that is called after any transfer of tokens. This includes
496      * minting and burning.
497      *
498      * Calling conditions:
499      *
500      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
501      * has been transferred to `to`.
502      * - when `from` is zero, `amount` tokens have been minted for `to`.
503      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
504      * - `from` and `to` are never both zero.
505      *
506      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
507      */
508     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
512 
513 
514 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 
520 /**
521  * @dev Extension of {ERC20} that allows token holders to destroy both their own
522  * tokens and those that they have an allowance for, in a way that can be
523  * recognized off-chain (via event analysis).
524  */
525 abstract contract ERC20Burnable is Context, ERC20 {
526     /**
527      * @dev Destroys `amount` tokens from the caller.
528      *
529      * See {ERC20-_burn}.
530      */
531     function burn(uint256 amount) public virtual {
532         _burn(_msgSender(), amount);
533     }
534 
535     /**
536      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
537      * allowance.
538      *
539      * See {ERC20-_burn} and {ERC20-allowance}.
540      *
541      * Requirements:
542      *
543      * - the caller must have allowance for ``accounts``'s tokens of at least
544      * `amount`.
545      */
546     function burnFrom(address account, uint256 amount) public virtual {
547         _spendAllowance(account, _msgSender(), amount);
548         _burn(account, amount);
549     }
550 }
551 
552 // File: felicette.sol
553 
554 
555 pragma solidity ^0.8.9;
556 
557 
558 
559 contract FELICETTE is ERC20, ERC20Burnable {
560     constructor() ERC20("FELICETTE", "FELI") {
561         _mint(msg.sender, 196300000000 * 10 ** decimals());
562     }
563 }