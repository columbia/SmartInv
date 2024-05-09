1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Emitted when `value` tokens are moved from one account (`from`) to
41      * another (`to`).
42      *
43      * Note that `value` may be zero.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     /**
48      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
49      * a call to {approve}. `value` is the new allowance.
50      */
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 
53     /**
54      * @dev Returns the amount of tokens in existence.
55      */
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `to`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address to, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `from` to `to` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(
107         address from,
108         address to,
109         uint256 amount
110     ) external returns (bool);
111 }
112 
113 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Interface for the optional metadata functions from the ERC20 standard.
123  *
124  * _Available since v4.1._
125  */
126 interface IERC20Metadata is IERC20 {
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() external view returns (string memory);
131 
132     /**
133      * @dev Returns the symbol of the token.
134      */
135     function symbol() external view returns (string memory);
136 
137     /**
138      * @dev Returns the decimals places of the token.
139      */
140     function decimals() external view returns (uint8);
141 }
142 
143 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
144 
145 
146 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 
151 
152 
153 /**
154  * @dev Implementation of the {IERC20} interface.
155  *
156  * This implementation is agnostic to the way tokens are created. This means
157  * that a supply mechanism has to be added in a derived contract using {_mint}.
158  * For a generic mechanism see {ERC20PresetMinterPauser}.
159  *
160  * TIP: For a detailed writeup see our guide
161  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
162  * to implement supply mechanisms].
163  *
164  * We have followed general OpenZeppelin Contracts guidelines: functions revert
165  * instead returning `false` on failure. This behavior is nonetheless
166  * conventional and does not conflict with the expectations of ERC20
167  * applications.
168  *
169  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
170  * This allows applications to reconstruct the allowance for all accounts just
171  * by listening to said events. Other implementations of the EIP may not emit
172  * these events, as it isn't required by the specification.
173  *
174  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
175  * functions have been added to mitigate the well-known issues around setting
176  * allowances. See {IERC20-approve}.
177  */
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     mapping(address => uint256) private _balances;
180 
181     mapping(address => mapping(address => uint256)) private _allowances;
182 
183     uint256 private _totalSupply;
184 
185     string private _name;
186     string private _symbol;
187 
188     /**
189      * @dev Sets the values for {name} and {symbol}.
190      *
191      * The default value of {decimals} is 18. To select a different value for
192      * {decimals} you should overload it.
193      *
194      * All two of these values are immutable: they can only be set once during
195      * construction.
196      */
197     constructor(string memory name_, string memory symbol_) {
198         _name = name_;
199         _symbol = symbol_;
200     }
201 
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() public view virtual override returns (string memory) {
206         return _name;
207     }
208 
209     /**
210      * @dev Returns the symbol of the token, usually a shorter version of the
211      * name.
212      */
213     function symbol() public view virtual override returns (string memory) {
214         return _symbol;
215     }
216 
217     /**
218      * @dev Returns the number of decimals used to get its user representation.
219      * For example, if `decimals` equals `2`, a balance of `505` tokens should
220      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
221      *
222      * Tokens usually opt for a value of 18, imitating the relationship between
223      * Ether and Wei. This is the value {ERC20} uses, unless this function is
224      * overridden;
225      *
226      * NOTE: This information is only used for _display_ purposes: it in
227      * no way affects any of the arithmetic of the contract, including
228      * {IERC20-balanceOf} and {IERC20-transfer}.
229      */
230     function decimals() public view virtual override returns (uint8) {
231         return 18;
232     }
233 
234     /**
235      * @dev See {IERC20-totalSupply}.
236      */
237     function totalSupply() public view virtual override returns (uint256) {
238         return _totalSupply;
239     }
240 
241     /**
242      * @dev See {IERC20-balanceOf}.
243      */
244     function balanceOf(address account) public view virtual override returns (uint256) {
245         return _balances[account];
246     }
247 
248     /**
249      * @dev See {IERC20-transfer}.
250      *
251      * Requirements:
252      *
253      * - `to` cannot be the zero address.
254      * - the caller must have a balance of at least `amount`.
255      */
256     function transfer(address to, uint256 amount) public virtual override returns (bool) {
257         address owner = _msgSender();
258         _transfer(owner, to, amount);
259         return true;
260     }
261 
262     /**
263      * @dev See {IERC20-allowance}.
264      */
265     function allowance(address owner, address spender) public view virtual override returns (uint256) {
266         return _allowances[owner][spender];
267     }
268 
269     /**
270      * @dev See {IERC20-approve}.
271      *
272      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
273      * `transferFrom`. This is semantically equivalent to an infinite approval.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         address owner = _msgSender();
281         _approve(owner, spender, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-transferFrom}.
287      *
288      * Emits an {Approval} event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of {ERC20}.
290      *
291      * NOTE: Does not update the allowance if the current allowance
292      * is the maximum `uint256`.
293      *
294      * Requirements:
295      *
296      * - `from` and `to` cannot be the zero address.
297      * - `from` must have a balance of at least `amount`.
298      * - the caller must have allowance for ``from``'s tokens of at least
299      * `amount`.
300      */
301     function transferFrom(
302         address from,
303         address to,
304         uint256 amount
305     ) public virtual override returns (bool) {
306         address spender = _msgSender();
307         _spendAllowance(from, spender, amount);
308         _transfer(from, to, amount);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically increases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         address owner = _msgSender();
326         _approve(owner, spender, allowance(owner, spender) + addedValue);
327         return true;
328     }
329 
330     /**
331      * @dev Atomically decreases the allowance granted to `spender` by the caller.
332      *
333      * This is an alternative to {approve} that can be used as a mitigation for
334      * problems described in {IERC20-approve}.
335      *
336      * Emits an {Approval} event indicating the updated allowance.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      * - `spender` must have allowance for the caller of at least
342      * `subtractedValue`.
343      */
344     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
345         address owner = _msgSender();
346         uint256 currentAllowance = allowance(owner, spender);
347         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
348         unchecked {
349             _approve(owner, spender, currentAllowance - subtractedValue);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Moves `amount` of tokens from `from` to `to`.
357      *
358      * This internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `from` cannot be the zero address.
366      * - `to` cannot be the zero address.
367      * - `from` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address from,
371         address to,
372         uint256 amount
373     ) internal virtual {
374         require(from != address(0), "ERC20: transfer from the zero address");
375         require(to != address(0), "ERC20: transfer to the zero address");
376 
377         _beforeTokenTransfer(from, to, amount);
378 
379         uint256 fromBalance = _balances[from];
380         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
381         unchecked {
382             _balances[from] = fromBalance - amount;
383             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
384             // decrementing then incrementing.
385             _balances[to] += amount;
386         }
387 
388         emit Transfer(from, to, amount);
389 
390         _afterTokenTransfer(from, to, amount);
391     }
392 
393     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
394      * the total supply.
395      *
396      * Emits a {Transfer} event with `from` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      */
402     function _mint(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: mint to the zero address");
404 
405         _beforeTokenTransfer(address(0), account, amount);
406 
407         _totalSupply += amount;
408         unchecked {
409             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
410             _balances[account] += amount;
411         }
412         emit Transfer(address(0), account, amount);
413 
414         _afterTokenTransfer(address(0), account, amount);
415     }
416 
417     /**
418      * @dev Destroys `amount` tokens from `account`, reducing the
419      * total supply.
420      *
421      * Emits a {Transfer} event with `to` set to the zero address.
422      *
423      * Requirements:
424      *
425      * - `account` cannot be the zero address.
426      * - `account` must have at least `amount` tokens.
427      */
428     function _burn(address account, uint256 amount) internal virtual {
429         require(account != address(0), "ERC20: burn from the zero address");
430 
431         _beforeTokenTransfer(account, address(0), amount);
432 
433         uint256 accountBalance = _balances[account];
434         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
435         unchecked {
436             _balances[account] = accountBalance - amount;
437             // Overflow not possible: amount <= accountBalance <= totalSupply.
438             _totalSupply -= amount;
439         }
440 
441         emit Transfer(account, address(0), amount);
442 
443         _afterTokenTransfer(account, address(0), amount);
444     }
445 
446     /**
447      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
448      *
449      * This internal function is equivalent to `approve`, and can be used to
450      * e.g. set automatic allowances for certain subsystems, etc.
451      *
452      * Emits an {Approval} event.
453      *
454      * Requirements:
455      *
456      * - `owner` cannot be the zero address.
457      * - `spender` cannot be the zero address.
458      */
459     function _approve(
460         address owner,
461         address spender,
462         uint256 amount
463     ) internal virtual {
464         require(owner != address(0), "ERC20: approve from the zero address");
465         require(spender != address(0), "ERC20: approve to the zero address");
466 
467         _allowances[owner][spender] = amount;
468         emit Approval(owner, spender, amount);
469     }
470 
471     /**
472      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
473      *
474      * Does not update the allowance amount in case of infinite allowance.
475      * Revert if not enough allowance is available.
476      *
477      * Might emit an {Approval} event.
478      */
479     function _spendAllowance(
480         address owner,
481         address spender,
482         uint256 amount
483     ) internal virtual {
484         uint256 currentAllowance = allowance(owner, spender);
485         if (currentAllowance != type(uint256).max) {
486             require(currentAllowance >= amount, "ERC20: insufficient allowance");
487             unchecked {
488                 _approve(owner, spender, currentAllowance - amount);
489             }
490         }
491     }
492 
493     /**
494      * @dev Hook that is called before any transfer of tokens. This includes
495      * minting and burning.
496      *
497      * Calling conditions:
498      *
499      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
500      * will be transferred to `to`.
501      * - when `from` is zero, `amount` tokens will be minted for `to`.
502      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
503      * - `from` and `to` are never both zero.
504      *
505      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
506      */
507     function _beforeTokenTransfer(
508         address from,
509         address to,
510         uint256 amount
511     ) internal virtual {}
512 
513     /**
514      * @dev Hook that is called after any transfer of tokens. This includes
515      * minting and burning.
516      *
517      * Calling conditions:
518      *
519      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
520      * has been transferred to `to`.
521      * - when `from` is zero, `amount` tokens have been minted for `to`.
522      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
523      * - `from` and `to` are never both zero.
524      *
525      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
526      */
527     function _afterTokenTransfer(
528         address from,
529         address to,
530         uint256 amount
531     ) internal virtual {}
532 }
533 
534 // File: Dog1.sol
535 
536 
537 pragma solidity ^0.8.9;
538 
539 
540 contract Dog1 is ERC20 {
541     constructor() ERC20("Dog1", "DOG1") {
542         _mint(msg.sender, 1000000000 * 10 ** decimals());
543     }
544 }