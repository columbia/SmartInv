1 // SPDX-License-Identifier: Unlicensed
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Emitted when `value` tokens are moved from one account (`from`) to
42      * another (`to`).
43      *
44      * Note that `value` may be zero.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /**
49      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
50      * a call to {approve}. `value` is the new allowance.
51      */
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 
54     /**
55      * @dev Returns the amount of tokens in existence.
56      */
57     function totalSupply() external view returns (uint256);
58 
59     /**
60      * @dev Returns the amount of tokens owned by `account`.
61      */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65      * @dev Moves `amount` tokens from the caller's account to `to`.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transfer(address to, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     /**
83      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * IMPORTANT: Beware that changing an allowance with this method brings the risk
88      * that someone may use both the old and the new allowance by unfortunate
89      * transaction ordering. One possible solution to mitigate this race
90      * condition is to first reduce the spender's allowance to 0 and set the
91      * desired value afterwards:
92      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93      *
94      * Emits an {Approval} event.
95      */
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Moves `amount` tokens from `from` to `to` using the
100      * allowance mechanism. `amount` is then deducted from the caller's
101      * allowance.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 amount
111     ) external returns (bool);
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
147 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
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
165  * We have followed general OpenZeppelin Contracts guidelines: functions revert
166  * instead returning `false` on failure. This behavior is nonetheless
167  * conventional and does not conflict with the expectations of ERC20
168  * applications.
169  *
170  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
171  * This allows applications to reconstruct the allowance for all accounts just
172  * by listening to said events. Other implementations of the EIP may not emit
173  * these events, as it isn't required by the specification.
174  *
175  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
176  * functions have been added to mitigate the well-known issues around setting
177  * allowances. See {IERC20-approve}.
178  */
179 contract ERC20 is Context, IERC20, IERC20Metadata {
180     mapping(address => uint256) private _balances;
181 
182     mapping(address => mapping(address => uint256)) private _allowances;
183 
184     uint256 private _totalSupply;
185 
186     string private _name;
187     string private _symbol;
188 
189     /**
190      * @dev Sets the values for {name} and {symbol}.
191      *
192      * The default value of {decimals} is 18. To select a different value for
193      * {decimals} you should overload it.
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
224      * Ether and Wei. This is the value {ERC20} uses, unless this function is
225      * overridden;
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
302     function transferFrom(
303         address from,
304         address to,
305         uint256 amount
306     ) public virtual override returns (bool) {
307         address spender = _msgSender();
308         _spendAllowance(from, spender, amount);
309         _transfer(from, to, amount);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         address owner = _msgSender();
327         _approve(owner, spender, allowance(owner, spender) + addedValue);
328         return true;
329     }
330 
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         address owner = _msgSender();
347         uint256 currentAllowance = allowance(owner, spender);
348         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
349         unchecked {
350             _approve(owner, spender, currentAllowance - subtractedValue);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Moves `amount` of tokens from `from` to `to`.
358      *
359      * This internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `from` must have a balance of at least `amount`.
369      */
370     function _transfer(
371         address from,
372         address to,
373         uint256 amount
374     ) internal virtual {
375         require(from != address(0), "ERC20: transfer from the zero address");
376         require(to != address(0), "ERC20: transfer to the zero address");
377 
378         _beforeTokenTransfer(from, to, amount);
379 
380         uint256 fromBalance = _balances[from];
381         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
382         unchecked {
383             _balances[from] = fromBalance - amount;
384             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
385             // decrementing then incrementing.
386             _balances[to] += amount;
387         }
388 
389         emit Transfer(from, to, amount);
390 
391         _afterTokenTransfer(from, to, amount);
392     }
393 
394     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
395      * the total supply.
396      *
397      * Emits a {Transfer} event with `from` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      */
403     function _mint(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: mint to the zero address");
405 
406         _beforeTokenTransfer(address(0), account, amount);
407 
408         _totalSupply += amount;
409         unchecked {
410             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
411             _balances[account] += amount;
412         }
413         emit Transfer(address(0), account, amount);
414 
415         _afterTokenTransfer(address(0), account, amount);
416     }
417 
418     /**
419      * @dev Destroys `amount` tokens from `account`, reducing the
420      * total supply.
421      *
422      * Emits a {Transfer} event with `to` set to the zero address.
423      *
424      * Requirements:
425      *
426      * - `account` cannot be the zero address.
427      * - `account` must have at least `amount` tokens.
428      */
429     function _burn(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: burn from the zero address");
431 
432         _beforeTokenTransfer(account, address(0), amount);
433 
434         uint256 accountBalance = _balances[account];
435         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
436         unchecked {
437             _balances[account] = accountBalance - amount;
438             // Overflow not possible: amount <= accountBalance <= totalSupply.
439             _totalSupply -= amount;
440         }
441 
442         emit Transfer(account, address(0), amount);
443 
444         _afterTokenTransfer(account, address(0), amount);
445     }
446 
447     /**
448      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
449      *
450      * This internal function is equivalent to `approve`, and can be used to
451      * e.g. set automatic allowances for certain subsystems, etc.
452      *
453      * Emits an {Approval} event.
454      *
455      * Requirements:
456      *
457      * - `owner` cannot be the zero address.
458      * - `spender` cannot be the zero address.
459      */
460     function _approve(
461         address owner,
462         address spender,
463         uint256 amount
464     ) internal virtual {
465         require(owner != address(0), "ERC20: approve from the zero address");
466         require(spender != address(0), "ERC20: approve to the zero address");
467 
468         _allowances[owner][spender] = amount;
469         emit Approval(owner, spender, amount);
470     }
471 
472     /**
473      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
474      *
475      * Does not update the allowance amount in case of infinite allowance.
476      * Revert if not enough allowance is available.
477      *
478      * Might emit an {Approval} event.
479      */
480     function _spendAllowance(
481         address owner,
482         address spender,
483         uint256 amount
484     ) internal virtual {
485         uint256 currentAllowance = allowance(owner, spender);
486         if (currentAllowance != type(uint256).max) {
487             require(currentAllowance >= amount, "ERC20: insufficient allowance");
488             unchecked {
489                 _approve(owner, spender, currentAllowance - amount);
490             }
491         }
492     }
493 
494     /**
495      * @dev Hook that is called before any transfer of tokens. This includes
496      * minting and burning.
497      *
498      * Calling conditions:
499      *
500      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
501      * will be transferred to `to`.
502      * - when `from` is zero, `amount` tokens will be minted for `to`.
503      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
504      * - `from` and `to` are never both zero.
505      *
506      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
507      */
508     function _beforeTokenTransfer(
509         address from,
510         address to,
511         uint256 amount
512     ) internal virtual {}
513 
514     /**
515      * @dev Hook that is called after any transfer of tokens. This includes
516      * minting and burning.
517      *
518      * Calling conditions:
519      *
520      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
521      * has been transferred to `to`.
522      * - when `from` is zero, `amount` tokens have been minted for `to`.
523      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
524      * - `from` and `to` are never both zero.
525      *
526      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
527      */
528     function _afterTokenTransfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal virtual {}
533 }
534 
535 // File: XIRTAM_LBP.sol
536 
537 pragma solidity ^0.8.9;
538 
539 
540 contract XIRTAM is ERC20 {
541     constructor() ERC20("XIRTAM", "XIRTAM") {
542         _mint(msg.sender, 1000000000 * 10 ** decimals());
543     }
544 }