1 // SPDX-License-Identifier: GPL-3.0
2 
3 
4 //BOO was voted the cutest dog in the world, he deserves his dedicated token!
5 
6 //BOO INU goes back to the essence of a meme token, it aims to bring the nature of meme tokens back to their true purpose by not pretending to be something it is not.
7 
8 //BOO INU aims at total decentralization, a token that belongs to all its community and where its destiny will be shaped by its community.
9 
10 //A token without team, without dev, without taxes, without false promises, just a pure decentralized meme token belonging to its community that will shape its future.
11 
12 //BOO INU the cutest token is now in your hands!
13 //It's up to you to make it shine!
14 
15 //twitter: https://twitter.com/BooINU_token
16 //telegram: https://t.me/BooINU_token
17 //website: https://boo-inu.com/
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Emitted when `value` tokens are moved from one account (`from`) to
27      * another (`to`).
28      *
29      * Note that `value` may be zero.
30      */
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     /**
34      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
35      * a call to {approve}. `value` is the new allowance.
36      */
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `to`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address to, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `from` to `to` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(
93         address from,
94         address to,
95         uint256 amount
96     ) external returns (bool);
97 }
98 
99 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
100 
101 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Interface for the optional metadata functions from the ERC20 standard.
107  *
108  * _Available since v4.1._
109  */
110 interface IERC20Metadata is IERC20 {
111     /**
112      * @dev Returns the name of the token.
113      */
114     function name() external view returns (string memory);
115 
116     /**
117      * @dev Returns the symbol of the token.
118      */
119     function symbol() external view returns (string memory);
120 
121     /**
122      * @dev Returns the decimals places of the token.
123      */
124     function decimals() external view returns (uint8);
125 }
126 
127 // File: @openzeppelin/contracts/utils/Context.sol
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
154 
155 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 
160 
161 /**
162  * @dev Implementation of the {IERC20} interface.
163  *
164  * This implementation is agnostic to the way tokens are created. This means
165  * that a supply mechanism has to be added in a derived contract using {_mint}.
166  * For a generic mechanism see {ERC20PresetMinterPauser}.
167  *
168  * TIP: For a detailed writeup see our guide
169  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
170  * to implement supply mechanisms].
171  *
172  * We have followed general OpenZeppelin Contracts guidelines: functions revert
173  * instead returning `false` on failure. This behavior is nonetheless
174  * conventional and does not conflict with the expectations of ERC20
175  * applications.
176  *
177  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
178  * This allows applications to reconstruct the allowance for all accounts just
179  * by listening to said events. Other implementations of the EIP may not emit
180  * these events, as it isn't required by the specification.
181  *
182  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
183  * functions have been added to mitigate the well-known issues around setting
184  * allowances. See {IERC20-approve}.
185  */
186 contract ERC20 is Context, IERC20, IERC20Metadata {
187     mapping(address => uint256) private _balances;
188 
189     mapping(address => mapping(address => uint256)) private _allowances;
190 
191     uint256 private _totalSupply;
192 
193     string private _name;
194     string private _symbol;
195 
196     /**
197      * @dev Sets the values for {name} and {symbol}.
198      *
199      * The default value of {decimals} is 18. To select a different value for
200      * {decimals} you should overload it.
201      *
202      * All two of these values are immutable: they can only be set once during
203      * construction.
204      */
205     constructor(string memory name_, string memory symbol_) {
206         _name = name_;
207         _symbol = symbol_;
208     }
209 
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() public view virtual override returns (string memory) {
214         return _name;
215     }
216 
217     /**
218      * @dev Returns the symbol of the token, usually a shorter version of the
219      * name.
220      */
221     function symbol() public view virtual override returns (string memory) {
222         return _symbol;
223     }
224 
225     /**
226      * @dev Returns the number of decimals used to get its user representation.
227      * For example, if `decimals` equals `2`, a balance of `505` tokens should
228      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
229      *
230      * Tokens usually opt for a value of 18, imitating the relationship between
231      * Ether and Wei. This is the value {ERC20} uses, unless this function is
232      * overridden;
233      *
234      * NOTE: This information is only used for _display_ purposes: it in
235      * no way affects any of the arithmetic of the contract, including
236      * {IERC20-balanceOf} and {IERC20-transfer}.
237      */
238     function decimals() public view virtual override returns (uint8) {
239         return 18;
240     }
241 
242     /**
243      * @dev See {IERC20-totalSupply}.
244      */
245     function totalSupply() public view virtual override returns (uint256) {
246         return _totalSupply;
247     }
248 
249     /**
250      * @dev See {IERC20-balanceOf}.
251      */
252     function balanceOf(address account) public view virtual override returns (uint256) {
253         return _balances[account];
254     }
255 
256     /**
257      * @dev See {IERC20-transfer}.
258      *
259      * Requirements:
260      *
261      * - `to` cannot be the zero address.
262      * - the caller must have a balance of at least `amount`.
263      */
264     function transfer(address to, uint256 amount) public virtual override returns (bool) {
265         address owner = _msgSender();
266         _transfer(owner, to, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-allowance}.
272      */
273     function allowance(address owner, address spender) public view virtual override returns (uint256) {
274         return _allowances[owner][spender];
275     }
276 
277     /**
278      * @dev See {IERC20-approve}.
279      *
280      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
281      * `transferFrom`. This is semantically equivalent to an infinite approval.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function approve(address spender, uint256 amount) public virtual override returns (bool) {
288         address owner = _msgSender();
289         _approve(owner, spender, amount);
290         return true;
291     }
292 
293     /**
294      * @dev See {IERC20-transferFrom}.
295      *
296      * Emits an {Approval} event indicating the updated allowance. This is not
297      * required by the EIP. See the note at the beginning of {ERC20}.
298      *
299      * NOTE: Does not update the allowance if the current allowance
300      * is the maximum `uint256`.
301      *
302      * Requirements:
303      *
304      * - `from` and `to` cannot be the zero address.
305      * - `from` must have a balance of at least `amount`.
306      * - the caller must have allowance for ``from``'s tokens of at least
307      * `amount`.
308      */
309     function transferFrom(
310         address from,
311         address to,
312         uint256 amount
313     ) public virtual override returns (bool) {
314         address spender = _msgSender();
315         _spendAllowance(from, spender, amount);
316         _transfer(from, to, amount);
317         return true;
318     }
319 
320     /**
321      * @dev Atomically increases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      */
332     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
333         address owner = _msgSender();
334         _approve(owner, spender, allowance(owner, spender) + addedValue);
335         return true;
336     }
337 
338     /**
339      * @dev Atomically decreases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to {approve} that can be used as a mitigation for
342      * problems described in {IERC20-approve}.
343      *
344      * Emits an {Approval} event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      * - `spender` must have allowance for the caller of at least
350      * `subtractedValue`.
351      */
352     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
353         address owner = _msgSender();
354         uint256 currentAllowance = allowance(owner, spender);
355         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
356         unchecked {
357             _approve(owner, spender, currentAllowance - subtractedValue);
358         }
359 
360         return true;
361     }
362 
363     /**
364      * @dev Moves `amount` of tokens from `from` to `to`.
365      *
366      * This internal function is equivalent to {transfer}, and can be used to
367      * e.g. implement automatic token fees, slashing mechanisms, etc.
368      *
369      * Emits a {Transfer} event.
370      *
371      * Requirements:
372      *
373      * - `from` cannot be the zero address.
374      * - `to` cannot be the zero address.
375      * - `from` must have a balance of at least `amount`.
376      */
377     function _transfer(
378         address from,
379         address to,
380         uint256 amount
381     ) internal virtual {
382         require(from != address(0), "ERC20: transfer from the zero address");
383         require(to != address(0), "ERC20: transfer to the zero address");
384 
385         _beforeTokenTransfer(from, to, amount);
386 
387         uint256 fromBalance = _balances[from];
388         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
389         unchecked {
390             _balances[from] = fromBalance - amount;
391         }
392         _balances[to] += amount;
393 
394         emit Transfer(from, to, amount);
395 
396         _afterTokenTransfer(from, to, amount);
397     }
398 
399     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
400      * the total supply.
401      *
402      * Emits a {Transfer} event with `from` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      */
408     function _mint(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: mint to the zero address");
410 
411         _beforeTokenTransfer(address(0), account, amount);
412 
413         _totalSupply += amount;
414         _balances[account] += amount;
415         emit Transfer(address(0), account, amount);
416 
417         _afterTokenTransfer(address(0), account, amount);
418     }
419 
420     /**
421      * @dev Destroys `amount` tokens from `account`, reducing the
422      * total supply.
423      *
424      * Emits a {Transfer} event with `to` set to the zero address.
425      *
426      * Requirements:
427      *
428      * - `account` cannot be the zero address.
429      * - `account` must have at least `amount` tokens.
430      */
431     function _burn(address account, uint256 amount) internal virtual {
432         require(account != address(0), "ERC20: burn from the zero address");
433 
434         _beforeTokenTransfer(account, address(0), amount);
435 
436         uint256 accountBalance = _balances[account];
437         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
438         unchecked {
439             _balances[account] = accountBalance - amount;
440         }
441         _totalSupply -= amount;
442 
443         emit Transfer(account, address(0), amount);
444 
445         _afterTokenTransfer(account, address(0), amount);
446     }
447 
448     /**
449      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
450      *
451      * This internal function is equivalent to `approve`, and can be used to
452      * e.g. set automatic allowances for certain subsystems, etc.
453      *
454      * Emits an {Approval} event.
455      *
456      * Requirements:
457      *
458      * - `owner` cannot be the zero address.
459      * - `spender` cannot be the zero address.
460      */
461     function _approve(
462         address owner,
463         address spender,
464         uint256 amount
465     ) internal virtual {
466         require(owner != address(0), "ERC20: approve from the zero address");
467         require(spender != address(0), "ERC20: approve to the zero address");
468 
469         _allowances[owner][spender] = amount;
470         emit Approval(owner, spender, amount);
471     }
472 
473     /**
474      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
475      *
476      * Does not update the allowance amount in case of infinite allowance.
477      * Revert if not enough allowance is available.
478      *
479      * Might emit an {Approval} event.
480      */
481     function _spendAllowance(
482         address owner,
483         address spender,
484         uint256 amount
485     ) internal virtual {
486         uint256 currentAllowance = allowance(owner, spender);
487         if (currentAllowance != type(uint256).max) {
488             require(currentAllowance >= amount, "ERC20: insufficient allowance");
489             unchecked {
490                 _approve(owner, spender, currentAllowance - amount);
491             }
492         }
493     }
494 
495     /**
496      * @dev Hook that is called before any transfer of tokens. This includes
497      * minting and burning.
498      *
499      * Calling conditions:
500      *
501      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
502      * will be transferred to `to`.
503      * - when `from` is zero, `amount` tokens will be minted for `to`.
504      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
505      * - `from` and `to` are never both zero.
506      *
507      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
508      */
509     function _beforeTokenTransfer(
510         address from,
511         address to,
512         uint256 amount
513     ) internal virtual {}
514 
515     /**
516      * @dev Hook that is called after any transfer of tokens. This includes
517      * minting and burning.
518      *
519      * Calling conditions:
520      *
521      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
522      * has been transferred to `to`.
523      * - when `from` is zero, `amount` tokens have been minted for `to`.
524      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
525      * - `from` and `to` are never both zero.
526      *
527      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
528      */
529     function _afterTokenTransfer(
530         address from,
531         address to,
532         uint256 amount
533     ) internal virtual {}
534 }
535 
536 
537 pragma solidity ^0.8.0;
538 
539 contract BOOINU is ERC20{
540     constructor() ERC20("BOO INU", "BOO"){
541         _mint(msg.sender,20000000000*10**18);
542     }
543 }