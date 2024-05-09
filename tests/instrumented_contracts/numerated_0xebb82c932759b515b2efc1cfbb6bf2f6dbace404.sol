1 /**
2 
3 
4 WEB3 Innovative investing protocol. 
5 Launch shares, not tokens, and follow the new crypto trend. 
6 Facilitating revenue sharing & staking. 
7 
8 shares.finance
9 x.com/sharesfinance
10 t.me/sharesfinance
11 
12 
13 */
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
40 
41 
42 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Interface of the ERC20 standard as defined in the EIP.
48  */
49 interface IERC20 {
50     /**
51      * @dev Emitted when `value` tokens are moved from one account (`from`) to
52      * another (`to`).
53      *
54      * Note that `value` may be zero.
55      */
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     /**
59      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
60      * a call to {approve}. `value` is the new allowance.
61      */
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 
64     /**
65      * @dev Returns the amount of tokens in existence.
66      */
67     function totalSupply() external view returns (uint256);
68 
69     /**
70      * @dev Returns the amount of tokens owned by `account`.
71      */
72     function balanceOf(address account) external view returns (uint256);
73 
74     /**
75      * @dev Moves `amount` tokens from the caller's account to `to`.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transfer(address to, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Returns the remaining number of tokens that `spender` will be
85      * allowed to spend on behalf of `owner` through {transferFrom}. This is
86      * zero by default.
87      *
88      * This value changes when {approve} or {transferFrom} are called.
89      */
90     function allowance(address owner, address spender) external view returns (uint256);
91 
92     /**
93      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * IMPORTANT: Beware that changing an allowance with this method brings the risk
98      * that someone may use both the old and the new allowance by unfortunate
99      * transaction ordering. One possible solution to mitigate this race
100      * condition is to first reduce the spender's allowance to 0 and set the
101      * desired value afterwards:
102      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103      *
104      * Emits an {Approval} event.
105      */
106     function approve(address spender, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Moves `amount` tokens from `from` to `to` using the
110      * allowance mechanism. `amount` is then deducted from the caller's
111      * allowance.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 amount
121     ) external returns (bool);
122 }
123 
124 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
125 
126 
127 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
128 
129 pragma solidity ^0.8.0;
130 
131 
132 /**
133  * @dev Interface for the optional metadata functions from the ERC20 standard.
134  *
135  * _Available since v4.1._
136  */
137 interface IERC20Metadata is IERC20 {
138     /**
139      * @dev Returns the name of the token.
140      */
141     function name() external view returns (string memory);
142 
143     /**
144      * @dev Returns the symbol of the token.
145      */
146     function symbol() external view returns (string memory);
147 
148     /**
149      * @dev Returns the decimals places of the token.
150      */
151     function decimals() external view returns (uint8);
152 }
153 
154 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
155 
156 
157 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 
163 
164 /**
165  * @dev Implementation of the {IERC20} interface.
166  *
167  * This implementation is agnostic to the way tokens are created. This means
168  * that a supply mechanism has to be added in a derived contract using {_mint}.
169  * For a generic mechanism see {ERC20PresetMinterPauser}.
170  *
171  * TIP: For a detailed writeup see our guide
172  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
173  * to implement supply mechanisms].
174  *
175  * We have followed general OpenZeppelin Contracts guidelines: functions revert
176  * instead returning `false` on failure. This behavior is nonetheless
177  * conventional and does not conflict with the expectations of ERC20
178  * applications.
179  *
180  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
181  * This allows applications to reconstruct the allowance for all accounts just
182  * by listening to said events. Other implementations of the EIP may not emit
183  * these events, as it isn't required by the specification.
184  *
185  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
186  * functions have been added to mitigate the well-known issues around setting
187  * allowances. See {IERC20-approve}.
188  */
189 contract ERC20 is Context, IERC20, IERC20Metadata {
190     mapping(address => uint256) private _balances;
191 
192     mapping(address => mapping(address => uint256)) private _allowances;
193 
194     uint256 private _totalSupply;
195 
196     string private _name;
197     string private _symbol;
198 
199     /**
200      * @dev Sets the values for {name} and {symbol}.
201      *
202      * The default value of {decimals} is 18. To select a different value for
203      * {decimals} you should overload it.
204      *
205      * All two of these values are immutable: they can only be set once during
206      * construction.
207      */
208     constructor(string memory name_, string memory symbol_) {
209         _name = name_;
210         _symbol = symbol_;
211     }
212 
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() public view virtual override returns (string memory) {
217         return _name;
218     }
219 
220     /**
221      * @dev Returns the symbol of the token, usually a shorter version of the
222      * name.
223      */
224     function symbol() public view virtual override returns (string memory) {
225         return _symbol;
226     }
227 
228     /**
229      * @dev Returns the number of decimals used to get its user representation.
230      * For example, if `decimals` equals `2`, a balance of `505` tokens should
231      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
232      *
233      * Tokens usually opt for a value of 18, imitating the relationship between
234      * Ether and Wei. This is the value {ERC20} uses, unless this function is
235      * overridden;
236      *
237      * NOTE: This information is only used for _display_ purposes: it in
238      * no way affects any of the arithmetic of the contract, including
239      * {IERC20-balanceOf} and {IERC20-transfer}.
240      */
241     function decimals() public view virtual override returns (uint8) {
242         return 18;
243     }
244 
245     /**
246      * @dev See {IERC20-totalSupply}.
247      */
248     function totalSupply() public view virtual override returns (uint256) {
249         return _totalSupply;
250     }
251 
252     /**
253      * @dev See {IERC20-balanceOf}.
254      */
255     function balanceOf(address account) public view virtual override returns (uint256) {
256         return _balances[account];
257     }
258 
259     /**
260      * @dev See {IERC20-transfer}.
261      *
262      * Requirements:
263      *
264      * - `to` cannot be the zero address.
265      * - the caller must have a balance of at least `amount`.
266      */
267     function transfer(address to, uint256 amount) public virtual override returns (bool) {
268         address owner = _msgSender();
269         _transfer(owner, to, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-allowance}.
275      */
276     function allowance(address owner, address spender) public view virtual override returns (uint256) {
277         return _allowances[owner][spender];
278     }
279 
280     /**
281      * @dev See {IERC20-approve}.
282      *
283      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
284      * `transferFrom`. This is semantically equivalent to an infinite approval.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function approve(address spender, uint256 amount) public virtual override returns (bool) {
291         address owner = _msgSender();
292         _approve(owner, spender, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See {IERC20-transferFrom}.
298      *
299      * Emits an {Approval} event indicating the updated allowance. This is not
300      * required by the EIP. See the note at the beginning of {ERC20}.
301      *
302      * NOTE: Does not update the allowance if the current allowance
303      * is the maximum `uint256`.
304      *
305      * Requirements:
306      *
307      * - `from` and `to` cannot be the zero address.
308      * - `from` must have a balance of at least `amount`.
309      * - the caller must have allowance for ``from``'s tokens of at least
310      * `amount`.
311      */
312     function transferFrom(
313         address from,
314         address to,
315         uint256 amount
316     ) public virtual override returns (bool) {
317         address spender = _msgSender();
318         _spendAllowance(from, spender, amount);
319         _transfer(from, to, amount);
320         return true;
321     }
322 
323     /**
324      * @dev Atomically increases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to {approve} that can be used as a mitigation for
327      * problems described in {IERC20-approve}.
328      *
329      * Emits an {Approval} event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
336         address owner = _msgSender();
337         _approve(owner, spender, allowance(owner, spender) + addedValue);
338         return true;
339     }
340 
341     /**
342      * @dev Atomically decreases the allowance granted to `spender` by the caller.
343      *
344      * This is an alternative to {approve} that can be used as a mitigation for
345      * problems described in {IERC20-approve}.
346      *
347      * Emits an {Approval} event indicating the updated allowance.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      * - `spender` must have allowance for the caller of at least
353      * `subtractedValue`.
354      */
355     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
356         address owner = _msgSender();
357         uint256 currentAllowance = allowance(owner, spender);
358         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
359         unchecked {
360             _approve(owner, spender, currentAllowance - subtractedValue);
361         }
362 
363         return true;
364     }
365 
366     /**
367      * @dev Moves `amount` of tokens from `from` to `to`.
368      *
369      * This internal function is equivalent to {transfer}, and can be used to
370      * e.g. implement automatic token fees, slashing mechanisms, etc.
371      *
372      * Emits a {Transfer} event.
373      *
374      * Requirements:
375      *
376      * - `from` cannot be the zero address.
377      * - `to` cannot be the zero address.
378      * - `from` must have a balance of at least `amount`.
379      */
380     function _transfer(
381         address from,
382         address to,
383         uint256 amount
384     ) internal virtual {
385         require(from != address(0), "ERC20: transfer from the zero address");
386         require(to != address(0), "ERC20: transfer to the zero address");
387 
388         _beforeTokenTransfer(from, to, amount);
389 
390         uint256 fromBalance = _balances[from];
391         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
392         unchecked {
393             _balances[from] = fromBalance - amount;
394             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
395             // decrementing then incrementing.
396             _balances[to] += amount;
397         }
398 
399         emit Transfer(from, to, amount);
400 
401         _afterTokenTransfer(from, to, amount);
402     }
403 
404     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
405      * the total supply.
406      *
407      * Emits a {Transfer} event with `from` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      */
413     function _mint(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: mint to the zero address");
415 
416         _beforeTokenTransfer(address(0), account, amount);
417 
418         _totalSupply += amount;
419         unchecked {
420             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
421             _balances[account] += amount;
422         }
423         emit Transfer(address(0), account, amount);
424 
425         _afterTokenTransfer(address(0), account, amount);
426     }
427 
428     /**
429      * @dev Destroys `amount` tokens from `account`, reducing the
430      * total supply.
431      *
432      * Emits a {Transfer} event with `to` set to the zero address.
433      *
434      * Requirements:
435      *
436      * - `account` cannot be the zero address.
437      * - `account` must have at least `amount` tokens.
438      */
439     function _burn(address account, uint256 amount) internal virtual {
440         require(account != address(0), "ERC20: burn from the zero address");
441 
442         _beforeTokenTransfer(account, address(0), amount);
443 
444         uint256 accountBalance = _balances[account];
445         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
446         unchecked {
447             _balances[account] = accountBalance - amount;
448             // Overflow not possible: amount <= accountBalance <= totalSupply.
449             _totalSupply -= amount;
450         }
451 
452         emit Transfer(account, address(0), amount);
453 
454         _afterTokenTransfer(account, address(0), amount);
455     }
456 
457     /**
458      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
459      *
460      * This internal function is equivalent to `approve`, and can be used to
461      * e.g. set automatic allowances for certain subsystems, etc.
462      *
463      * Emits an {Approval} event.
464      *
465      * Requirements:
466      *
467      * - `owner` cannot be the zero address.
468      * - `spender` cannot be the zero address.
469      */
470     function _approve(
471         address owner,
472         address spender,
473         uint256 amount
474     ) internal virtual {
475         require(owner != address(0), "ERC20: approve from the zero address");
476         require(spender != address(0), "ERC20: approve to the zero address");
477 
478         _allowances[owner][spender] = amount;
479         emit Approval(owner, spender, amount);
480     }
481 
482     /**
483      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
484      *
485      * Does not update the allowance amount in case of infinite allowance.
486      * Revert if not enough allowance is available.
487      *
488      * Might emit an {Approval} event.
489      */
490     function _spendAllowance(
491         address owner,
492         address spender,
493         uint256 amount
494     ) internal virtual {
495         uint256 currentAllowance = allowance(owner, spender);
496         if (currentAllowance != type(uint256).max) {
497             require(currentAllowance >= amount, "ERC20: insufficient allowance");
498             unchecked {
499                 _approve(owner, spender, currentAllowance - amount);
500             }
501         }
502     }
503 
504     /**
505      * @dev Hook that is called before any transfer of tokens. This includes
506      * minting and burning.
507      *
508      * Calling conditions:
509      *
510      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
511      * will be transferred to `to`.
512      * - when `from` is zero, `amount` tokens will be minted for `to`.
513      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
514      * - `from` and `to` are never both zero.
515      *
516      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
517      */
518     function _beforeTokenTransfer(
519         address from,
520         address to,
521         uint256 amount
522     ) internal virtual {}
523 
524     /**
525      * @dev Hook that is called after any transfer of tokens. This includes
526      * minting and burning.
527      *
528      * Calling conditions:
529      *
530      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
531      * has been transferred to `to`.
532      * - when `from` is zero, `amount` tokens have been minted for `to`.
533      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
534      * - `from` and `to` are never both zero.
535      *
536      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
537      */
538     function _afterTokenTransfer(
539         address from,
540         address to,
541         uint256 amount
542     ) internal virtual {}
543 }
544 
545 
546 pragma solidity ^0.8.9;
547 
548 
549 contract SHARES is ERC20 {
550     constructor() ERC20("shares.finance", "SHARES") {
551         _mint(msg.sender, 210000 * 10 ** decimals());
552     }
553 }