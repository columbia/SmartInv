1 /**
2 
3 /*************************************************************************
4  ZEN
5  https://t.me/ZEN_ERC
6  https://twitter.com/ZEN_ERC
7  https://en.wikipedia.org/wiki/Zen
8 ****************************************************************************/
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity ^0.8.15;
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
33 
34 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
35 
36 
37 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
38 
39 pragma solidity ^0.8.15;
40 
41 /**
42  * @dev Interface of the ERC20 standard as defined in the EIP.
43  */
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 
120 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
121 
122 
123 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
124 
125 pragma solidity ^0.8.15;
126 
127 /**
128  * @dev Interface for the optional metadata functions from the ERC20 standard.
129  *
130  * _Available since v4.1._
131  */
132 interface IERC20Metadata is IERC20 {
133     /**
134      * @dev Returns the name of the token.
135      */
136     function name() external view returns (string memory);
137 
138     /**
139      * @dev Returns the symbol of the token.
140      */
141     function symbol() external view returns (string memory);
142 
143     /**
144      * @dev Returns the decimals places of the token.
145      */
146     function decimals() external view returns (uint8);
147 }
148 
149 
150 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
151 
152 
153 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
154 
155 pragma solidity ^0.8.15;
156 
157 
158 
159 /**
160  * @dev Implementation of the {IERC20} interface.
161  *
162  * This implementation is agnostic to the way tokens are created. This means
163  * that a supply mechanism has to be added in a derived contract using {_mint}.
164  * For a generic mechanism see {ERC20PresetMinterPauser}.
165  *
166  * TIP: For a detailed writeup see our guide
167  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
168  * to implement supply mechanisms].
169  *
170  * We have followed general OpenZeppelin Contracts guidelines: functions revert
171  * instead returning `false` on failure. This behavior is nonetheless
172  * conventional and does not conflict with the expectations of ERC20
173  * applications.
174  *
175  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
176  * This allows applications to reconstruct the allowance for all accounts just
177  * by listening to said events. Other implementations of the EIP may not emit
178  * these events, as it isn't required by the specification.
179  *
180  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
181  * functions have been added to mitigate the well-known issues around setting
182  * allowances. See {IERC20-approve}.
183  */
184 contract ERC20 is Context, IERC20, IERC20Metadata {
185     mapping(address => uint256) private _balances;
186 
187     mapping(address => mapping(address => uint256)) private _allowances;
188 
189     uint256 private _totalSupply;
190 
191     string private _name;
192     string private _symbol;
193 
194     /**
195      * @dev Sets the values for {name} and {symbol}.
196      *
197      * The default value of {decimals} is 18. To select a different value for
198      * {decimals} you should overload it.
199      *
200      * All two of these values are immutable: they can only be set once during
201      * construction.
202      */
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207 
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214 
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222 
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if `decimals` equals `2`, a balance of `505` tokens should
226      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei. This is the value {ERC20} uses, unless this function is
230      * overridden;
231      *
232      * NOTE: This information is only used for _display_ purposes: it in
233      * no way affects any of the arithmetic of the contract, including
234      * {IERC20-balanceOf} and {IERC20-transfer}.
235      */
236     function decimals() public view virtual override returns (uint8) {
237         return 18;
238     }
239 
240     /**
241      * @dev See {IERC20-totalSupply}.
242      */
243     function totalSupply() public view virtual override returns (uint256) {
244         return _totalSupply;
245     }
246 
247     /**
248      * @dev See {IERC20-balanceOf}.
249      */
250     function balanceOf(address account) public view virtual override returns (uint256) {
251         return _balances[account];
252     }
253 
254     /**
255      * @dev See {IERC20-transfer}.
256      *
257      * Requirements:
258      *
259      * - `recipient` cannot be the zero address.
260      * - the caller must have a balance of at least `amount`.
261      */
262     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(_msgSender(), recipient, amount);
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
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 amount) public virtual override returns (bool) {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * Requirements:
293      *
294      * - `sender` and `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``sender``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         _transfer(sender, recipient, amount);
305 
306         uint256 currentAllowance = _allowances[sender][_msgSender()];
307         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
308         unchecked {
309             _approve(sender, _msgSender(), currentAllowance - amount);
310         }
311 
312         return true;
313     }
314 
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
329         return true;
330     }
331 
332     /**
333      * @dev Atomically decreases the allowance granted to `spender` by the caller.
334      *
335      * This is an alternative to {approve} that can be used as a mitigation for
336      * problems described in {IERC20-approve}.
337      *
338      * Emits an {Approval} event indicating the updated allowance.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      * - `spender` must have allowance for the caller of at least
344      * `subtractedValue`.
345      */
346     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
347         uint256 currentAllowance = _allowances[_msgSender()][spender];
348         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
349         unchecked {
350             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Moves `amount` of tokens from `sender` to `recipient`.
358      *
359      * This internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `sender` cannot be the zero address.
367      * - `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      */
370     function _transfer(
371         address sender,
372         address recipient,
373         uint256 amount
374     ) internal virtual {
375         require(sender != address(0), "ERC20: transfer from the zero address");
376         require(recipient != address(0), "ERC20: transfer to the zero address");
377 
378         _beforeTokenTransfer(sender, recipient, amount);
379 
380         uint256 senderBalance = _balances[sender];
381         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
382         unchecked {
383             _balances[sender] = senderBalance - amount;
384         }
385         _balances[recipient] += amount;
386 
387         emit Transfer(sender, recipient, amount);
388 
389         _afterTokenTransfer(sender, recipient, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _beforeTokenTransfer(address(0), account, amount);
405 
406         _totalSupply += amount;
407         _balances[account] += amount;
408         emit Transfer(address(0), account, amount);
409 
410         _afterTokenTransfer(address(0), account, amount);
411     }
412 
413     /**
414      * @dev Destroys `amount` tokens from `account`, reducing the
415      * total supply.
416      *
417      * Emits a {Transfer} event with `to` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      * - `account` must have at least `amount` tokens.
423      */
424     function _burn(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: burn from the zero address");
426 
427         _beforeTokenTransfer(account, address(0), amount);
428 
429         uint256 accountBalance = _balances[account];
430         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
431         unchecked {
432             _balances[account] = accountBalance - amount;
433         }
434         _totalSupply -= amount;
435 
436         emit Transfer(account, address(0), amount);
437 
438         _afterTokenTransfer(account, address(0), amount);
439     }
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
443      *
444      * This internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an {Approval} event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(
455         address owner,
456         address spender,
457         uint256 amount
458     ) internal virtual {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461 
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465 
466     /**
467      * @dev Hook that is called before any transfer of tokens. This includes
468      * minting and burning.
469      *
470      * Calling conditions:
471      *
472      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
473      * will be transferred to `to`.
474      * - when `from` is zero, `amount` tokens will be minted for `to`.
475      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
476      * - `from` and `to` are never both zero.
477      *
478      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
479      */
480     function _beforeTokenTransfer(
481         address from,
482         address to,
483         uint256 amount
484     ) internal virtual {}
485 
486     /**
487      * @dev Hook that is called after any transfer of tokens. This includes
488      * minting and burning.
489      *
490      * Calling conditions:
491      *
492      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
493      * has been transferred to `to`.
494      * - when `from` is zero, `amount` tokens have been minted for `to`.
495      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
496      * - `from` and `to` are never both zero.
497      *
498      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
499      */
500     function _afterTokenTransfer(
501         address from,
502         address to,
503         uint256 amount
504     ) internal virtual {}
505 }
506 
507 
508 // File contracts/baped.sol
509 
510 pragma solidity ^0.8.15;
511 
512 contract ZEN is ERC20 { 
513     constructor() ERC20("Zen", "ZEN") {
514         _mint(msg.sender, 9999999999999 * 10 ** decimals());
515     } 
516 }