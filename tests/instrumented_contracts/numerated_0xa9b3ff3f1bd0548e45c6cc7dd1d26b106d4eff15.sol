1 /**
2 Burn Coin
3 tax0/0
4 
5 https://t.me/BurnCoinEth
6 https://burnerc.com/
7 https://twitter.com/BurnCoinErc
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.15;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
34 
35 
36 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
37 
38 pragma solidity ^0.8.15;
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102 
103     /**
104      * @dev Emitted when `value` tokens are moved from one account (`from`) to
105      * another (`to`).
106      *
107      * Note that `value` may be zero.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     /**
112      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113      * a call to {approve}. `value` is the new allowance.
114      */
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 
119 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
120 
121 
122 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
123 
124 pragma solidity ^0.8.15;
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
148 
149 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
150 
151 
152 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
153 
154 pragma solidity ^0.8.15;
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
166  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
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
258      * - `recipient` cannot be the zero address.
259      * - the caller must have a balance of at least `amount`.
260      */
261     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See {IERC20-allowance}.
268      */
269     function allowance(address owner, address spender) public view virtual override returns (uint256) {
270         return _allowances[owner][spender];
271     }
272 
273     /**
274      * @dev See {IERC20-approve}.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-transferFrom}.
287      *
288      * Emits an {Approval} event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of {ERC20}.
290      *
291      * Requirements:
292      *
293      * - `sender` and `recipient` cannot be the zero address.
294      * - `sender` must have a balance of at least `amount`.
295      * - the caller must have allowance for ``sender``'s tokens of at least
296      * `amount`.
297      */
298     function transferFrom(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) public virtual override returns (bool) {
303         _transfer(sender, recipient, amount);
304 
305         uint256 currentAllowance = _allowances[sender][_msgSender()];
306         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
307         unchecked {
308             _approve(sender, _msgSender(), currentAllowance - amount);
309         }
310 
311         return true;
312     }
313 
314     /**
315      * @dev Atomically increases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
327         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
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
346         uint256 currentAllowance = _allowances[_msgSender()][spender];
347         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
348         unchecked {
349             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Moves `amount` of tokens from `sender` to `recipient`.
357      *
358      * This internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `sender` cannot be the zero address.
366      * - `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address sender,
371         address recipient,
372         uint256 amount
373     ) internal virtual {
374         require(sender != address(0), "ERC20: transfer from the zero address");
375         require(recipient != address(0), "ERC20: transfer to the zero address");
376 
377         _beforeTokenTransfer(sender, recipient, amount);
378 
379         uint256 senderBalance = _balances[sender];
380         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
381         unchecked {
382             _balances[sender] = senderBalance - amount;
383         }
384         _balances[recipient] += amount;
385 
386         emit Transfer(sender, recipient, amount);
387 
388         _afterTokenTransfer(sender, recipient, amount);
389     }
390 
391     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
392      * the total supply.
393      *
394      * Emits a {Transfer} event with `from` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      */
400     function _mint(address account, uint256 amount) internal virtual {
401         require(account != address(0), "ERC20: mint to the zero address");
402 
403         _beforeTokenTransfer(address(0), account, amount);
404 
405         _totalSupply += amount;
406         _balances[account] += amount;
407         emit Transfer(address(0), account, amount);
408 
409         _afterTokenTransfer(address(0), account, amount);
410     }
411 
412     /**
413      * @dev Destroys `amount` tokens from `account`, reducing the
414      * total supply.
415      *
416      * Emits a {Transfer} event with `to` set to the zero address.
417      *
418      * Requirements:
419      *
420      * - `account` cannot be the zero address.
421      * - `account` must have at least `amount` tokens.
422      */
423     function _burn(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: burn from the zero address");
425 
426         _beforeTokenTransfer(account, address(0), amount);
427 
428         uint256 accountBalance = _balances[account];
429         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
430         unchecked {
431             _balances[account] = accountBalance - amount;
432         }
433         _totalSupply -= amount;
434 
435         emit Transfer(account, address(0), amount);
436 
437         _afterTokenTransfer(account, address(0), amount);
438     }
439 
440     /**
441      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
442      *
443      * This internal function is equivalent to `approve`, and can be used to
444      * e.g. set automatic allowances for certain subsystems, etc.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `owner` cannot be the zero address.
451      * - `spender` cannot be the zero address.
452      */
453     function _approve(
454         address owner,
455         address spender,
456         uint256 amount
457     ) internal virtual {
458         require(owner != address(0), "ERC20: approve from the zero address");
459         require(spender != address(0), "ERC20: approve to the zero address");
460 
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
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
506 
507 // File contracts/baped.sol
508 
509 pragma solidity ^0.8.15;
510 
511 contract BURN is ERC20 { 
512     constructor() ERC20("Burn Coin", "BURN") {
513         _mint(msg.sender, 420690000000000 * 10 ** decimals());
514     } 
515 }