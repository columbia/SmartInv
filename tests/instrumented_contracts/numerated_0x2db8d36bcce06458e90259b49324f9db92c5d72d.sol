1 /**
2 Community owned 
3 By a chad. To all the chads.
4 */
5 
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
36 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
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
111     function transferFrom(
112         address from,
113         address to,
114         uint256 amount
115     ) external returns (bool);
116 }
117 
118 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
119 
120 
121 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 
126 /**
127  * @dev Interface for the optional metadata functions from the ERC20 standard.
128  *
129  * _Available since v4.1._
130  */
131 interface IERC20Metadata is IERC20 {
132     /**
133      * @dev Returns the name of the token.
134      */
135     function name() external view returns (string memory);
136 
137     /**
138      * @dev Returns the symbol of the token.
139      */
140     function symbol() external view returns (string memory);
141 
142     /**
143      * @dev Returns the decimals places of the token.
144      */
145     function decimals() external view returns (uint8);
146 }
147 
148 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
149 
150 
151 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
152 
153 pragma solidity ^0.8.0;
154 
155 
156 
157 
158 /**
159  * @dev Implementation of the {IERC20} interface.
160  *
161  * This implementation is agnostic to the way tokens are created. This means
162  * that a supply mechanism has to be added in a derived contract using {_mint}.
163  * For a generic mechanism see {ERC20PresetMinterPauser}.
164  *
165  * TIP: For a detailed writeup see our guide
166  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
167  * to implement supply mechanisms].
168  *
169  * We have followed general OpenZeppelin Contracts guidelines: functions revert
170  * instead returning `false` on failure. This behavior is nonetheless
171  * conventional and does not conflict with the expectations of ERC20
172  * applications.
173  *
174  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
175  * This allows applications to reconstruct the allowance for all accounts just
176  * by listening to said events. Other implementations of the EIP may not emit
177  * these events, as it isn't required by the specification.
178  *
179  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
180  * functions have been added to mitigate the well-known issues around setting
181  * allowances. See {IERC20-approve}.
182  */
183 contract ERC20 is Context, IERC20, IERC20Metadata {
184     mapping(address => uint256) private _balances;
185 
186     mapping(address => mapping(address => uint256)) private _allowances;
187 
188     uint256 private _totalSupply;
189 
190     string private _name;
191     string private _symbol;
192 
193     /**
194      * @dev Sets the values for {name} and {symbol}.
195      *
196      * The default value of {decimals} is 18. To select a different value for
197      * {decimals} you should overload it.
198      *
199      * All two of these values are immutable: they can only be set once during
200      * construction.
201      */
202     constructor(string memory name_, string memory symbol_) {
203         _name = name_;
204         _symbol = symbol_;
205     }
206 
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() public view virtual override returns (string memory) {
211         return _name;
212     }
213 
214     /**
215      * @dev Returns the symbol of the token, usually a shorter version of the
216      * name.
217      */
218     function symbol() public view virtual override returns (string memory) {
219         return _symbol;
220     }
221 
222     /**
223      * @dev Returns the number of decimals used to get its user representation.
224      * For example, if `decimals` equals `2`, a balance of `505` tokens should
225      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
226      *
227      * Tokens usually opt for a value of 18, imitating the relationship between
228      * Ether and Wei. This is the value {ERC20} uses, unless this function is
229      * overridden;
230      *
231      * NOTE: This information is only used for _display_ purposes: it in
232      * no way affects any of the arithmetic of the contract, including
233      * {IERC20-balanceOf} and {IERC20-transfer}.
234      */
235     function decimals() public view virtual override returns (uint8) {
236         return 18;
237     }
238 
239     /**
240      * @dev See {IERC20-totalSupply}.
241      */
242     function totalSupply() public view virtual override returns (uint256) {
243         return _totalSupply;
244     }
245 
246     /**
247      * @dev See {IERC20-balanceOf}.
248      */
249     function balanceOf(address account) public view virtual override returns (uint256) {
250         return _balances[account];
251     }
252 
253     /**
254      * @dev See {IERC20-transfer}.
255      *
256      * Requirements:
257      *
258      * - `to` cannot be the zero address.
259      * - the caller must have a balance of at least `amount`.
260      */
261     function transfer(address to, uint256 amount) public virtual override returns (bool) {
262         address owner = _msgSender();
263         _transfer(owner, to, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See {IERC20-allowance}.
269      */
270     function allowance(address owner, address spender) public view virtual override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273 
274     /**
275      * @dev See {IERC20-approve}.
276      *
277      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
278      * `transferFrom`. This is semantically equivalent to an infinite approval.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function approve(address spender, uint256 amount) public virtual override returns (bool) {
285         address owner = _msgSender();
286         _approve(owner, spender, amount);
287         return true;
288     }
289 
290     /**
291      * @dev See {IERC20-transferFrom}.
292      *
293      * Emits an {Approval} event indicating the updated allowance. This is not
294      * required by the EIP. See the note at the beginning of {ERC20}.
295      *
296      * NOTE: Does not update the allowance if the current allowance
297      * is the maximum `uint256`.
298      *
299      * Requirements:
300      *
301      * - `from` and `to` cannot be the zero address.
302      * - `from` must have a balance of at least `amount`.
303      * - the caller must have allowance for ``from``'s tokens of at least
304      * `amount`.
305      */
306     function transferFrom(
307         address from,
308         address to,
309         uint256 amount
310     ) public virtual override returns (bool) {
311         address spender = _msgSender();
312         _spendAllowance(from, spender, amount);
313         _transfer(from, to, amount);
314         return true;
315     }
316 
317     /**
318      * @dev Atomically increases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         address owner = _msgSender();
331         _approve(owner, spender, allowance(owner, spender) + addedValue);
332         return true;
333     }
334 
335     /**
336      * @dev Atomically decreases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      * - `spender` must have allowance for the caller of at least
347      * `subtractedValue`.
348      */
349     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
350         address owner = _msgSender();
351         uint256 currentAllowance = allowance(owner, spender);
352         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
353         unchecked {
354             _approve(owner, spender, currentAllowance - subtractedValue);
355         }
356 
357         return true;
358     }
359 
360     /**
361      * @dev Moves `amount` of tokens from `from` to `to`.
362      *
363      * This internal function is equivalent to {transfer}, and can be used to
364      * e.g. implement automatic token fees, slashing mechanisms, etc.
365      *
366      * Emits a {Transfer} event.
367      *
368      * Requirements:
369      *
370      * - `from` cannot be the zero address.
371      * - `to` cannot be the zero address.
372      * - `from` must have a balance of at least `amount`.
373      */
374     function _transfer(
375         address from,
376         address to,
377         uint256 amount
378     ) internal virtual {
379         require(from != address(0), "ERC20: transfer from the zero address");
380         require(to != address(0), "ERC20: transfer to the zero address");
381 
382         _beforeTokenTransfer(from, to, amount);
383 
384         uint256 fromBalance = _balances[from];
385         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
386         unchecked {
387             _balances[from] = fromBalance - amount;
388             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
389             // decrementing then incrementing.
390             _balances[to] += amount;
391         }
392 
393         emit Transfer(from, to, amount);
394 
395         _afterTokenTransfer(from, to, amount);
396     }
397 
398     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
399      * the total supply.
400      *
401      * Emits a {Transfer} event with `from` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      */
407     function _mint(address account, uint256 amount) internal virtual {
408         require(account != address(0), "ERC20: mint to the zero address");
409 
410         _beforeTokenTransfer(address(0), account, amount);
411 
412         _totalSupply += amount;
413         unchecked {
414             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
415             _balances[account] += amount;
416         }
417         emit Transfer(address(0), account, amount);
418 
419         _afterTokenTransfer(address(0), account, amount);
420     }
421 
422     /**
423      * @dev Destroys `amount` tokens from `account`, reducing the
424      * total supply.
425      *
426      * Emits a {Transfer} event with `to` set to the zero address.
427      *
428      * Requirements:
429      *
430      * - `account` cannot be the zero address.
431      * - `account` must have at least `amount` tokens.
432      */
433     function _burn(address account, uint256 amount) internal virtual {
434         require(account != address(0), "ERC20: burn from the zero address");
435 
436         _beforeTokenTransfer(account, address(0), amount);
437 
438         uint256 accountBalance = _balances[account];
439         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
440         unchecked {
441             _balances[account] = accountBalance - amount;
442             // Overflow not possible: amount <= accountBalance <= totalSupply.
443             _totalSupply -= amount;
444         }
445 
446         emit Transfer(account, address(0), amount);
447 
448         _afterTokenTransfer(account, address(0), amount);
449     }
450 
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
453      *
454      * This internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(
465         address owner,
466         address spender,
467         uint256 amount
468     ) internal virtual {
469         require(owner != address(0), "ERC20: approve from the zero address");
470         require(spender != address(0), "ERC20: approve to the zero address");
471 
472         _allowances[owner][spender] = amount;
473         emit Approval(owner, spender, amount);
474     }
475 
476     /**
477      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
478      *
479      * Does not update the allowance amount in case of infinite allowance.
480      * Revert if not enough allowance is available.
481      *
482      * Might emit an {Approval} event.
483      */
484     function _spendAllowance(
485         address owner,
486         address spender,
487         uint256 amount
488     ) internal virtual {
489         uint256 currentAllowance = allowance(owner, spender);
490         if (currentAllowance != type(uint256).max) {
491             require(currentAllowance >= amount, "ERC20: insufficient allowance");
492             unchecked {
493                 _approve(owner, spender, currentAllowance - amount);
494             }
495         }
496     }
497 
498     /**
499      * @dev Hook that is called before any transfer of tokens. This includes
500      * minting and burning.
501      *
502      * Calling conditions:
503      *
504      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
505      * will be transferred to `to`.
506      * - when `from` is zero, `amount` tokens will be minted for `to`.
507      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
508      * - `from` and `to` are never both zero.
509      *
510      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
511      */
512     function _beforeTokenTransfer(
513         address from,
514         address to,
515         uint256 amount
516     ) internal virtual {}
517 
518     /**
519      * @dev Hook that is called after any transfer of tokens. This includes
520      * minting and burning.
521      *
522      * Calling conditions:
523      *
524      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
525      * has been transferred to `to`.
526      * - when `from` is zero, `amount` tokens have been minted for `to`.
527      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
528      * - `from` and `to` are never both zero.
529      *
530      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
531      */
532     function _afterTokenTransfer(
533         address from,
534         address to,
535         uint256 amount
536     ) internal virtual {}
537 }
538 
539 // File: CHAD.sol
540 
541 
542 pragma solidity ^0.8.9;
543 
544 
545 contract Chadcoin is ERC20 {
546     constructor() ERC20("Chad Coin", "CHAD") {
547         _mint(msg.sender, 69420000000 * 10 ** decimals());
548     }
549 }