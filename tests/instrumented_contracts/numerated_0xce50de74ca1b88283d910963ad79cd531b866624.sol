1 // ███╗░░██╗░█████╗░████████╗░█████╗░██╗░░██╗
2 // ████╗░██║██╔══██╗╚══██╔══╝██╔══██╗╚██╗██╔╝
3 // ██╔██╗██║██║░░██║░░░██║░░░███████║░╚███╔╝░
4 // ██║╚████║██║░░██║░░░██║░░░██╔══██║░██╔██╗░
5 // ██║░╚███║╚█████╔╝░░░██║░░░██║░░██║██╔╝╚██╗
6 // ╚═╝░░╚══╝░╚════╝░░░░╚═╝░░░╚═╝░░╚═╝╚═╝░░╚═╝
7 
8 // Dev by t.me/edenlebg
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Emitted when `value` tokens are moved from one account (`from`) to
18      * another (`to`).
19      *
20      * Note that `value` may be zero.
21      */
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     /**
25      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
26      * a call to {approve}. `value` is the new allowance.
27      */
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `to`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address to, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `from` to `to` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address from,
85         address to,
86         uint256 amount
87     ) external returns (bool);
88 }
89 
90 
91 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.1
92 
93 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 
120 // File @openzeppelin/contracts/utils/Context.sol@v4.8.1
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 
147 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.1
148 
149 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 
154 
155 /**
156  * @dev Implementation of the {IERC20} interface.
157  *
158  * This implementation is agnostic to the way tokens are created. This means
159  * that a supply mechanism has to be added in a derived contract using {_mint}.
160  * For a generic mechanism see {ERC20PresetMinterPauser}.
161  *
162  * TIP: For a detailed writeup see our guide
163  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
164  * to implement supply mechanisms].
165  *
166  * We have followed general OpenZeppelin Contracts guidelines: functions revert
167  * instead returning `false` on failure. This behavior is nonetheless
168  * conventional and does not conflict with the expectations of ERC20
169  * applications.
170  *
171  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
172  * This allows applications to reconstruct the allowance for all accounts just
173  * by listening to said events. Other implementations of the EIP may not emit
174  * these events, as it isn't required by the specification.
175  *
176  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
177  * functions have been added to mitigate the well-known issues around setting
178  * allowances. See {IERC20-approve}.
179  */
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     mapping(address => uint256) private _balances;
182 
183     mapping(address => mapping(address => uint256)) private _allowances;
184 
185     uint256 private _totalSupply;
186 
187     string private _name;
188     string private _symbol;
189 
190     /**
191      * @dev Sets the values for {name} and {symbol}.
192      *
193      * The default value of {decimals} is 18. To select a different value for
194      * {decimals} you should overload it.
195      *
196      * All two of these values are immutable: they can only be set once during
197      * construction.
198      */
199     constructor(string memory name_, string memory symbol_) {
200         _name = name_;
201         _symbol = symbol_;
202     }
203 
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() public view virtual override returns (string memory) {
208         return _name;
209     }
210 
211     /**
212      * @dev Returns the symbol of the token, usually a shorter version of the
213      * name.
214      */
215     function symbol() public view virtual override returns (string memory) {
216         return _symbol;
217     }
218 
219     /**
220      * @dev Returns the number of decimals used to get its user representation.
221      * For example, if `decimals` equals `2`, a balance of `505` tokens should
222      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
223      *
224      * Tokens usually opt for a value of 18, imitating the relationship between
225      * Ether and Wei. This is the value {ERC20} uses, unless this function is
226      * overridden;
227      *
228      * NOTE: This information is only used for _display_ purposes: it in
229      * no way affects any of the arithmetic of the contract, including
230      * {IERC20-balanceOf} and {IERC20-transfer}.
231      */
232     function decimals() public view virtual override returns (uint8) {
233         return 18;
234     }
235 
236     /**
237      * @dev See {IERC20-totalSupply}.
238      */
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     /**
244      * @dev See {IERC20-balanceOf}.
245      */
246     function balanceOf(address account) public view virtual override returns (uint256) {
247         return _balances[account];
248     }
249 
250     /**
251      * @dev See {IERC20-transfer}.
252      *
253      * Requirements:
254      *
255      * - `to` cannot be the zero address.
256      * - the caller must have a balance of at least `amount`.
257      */
258     function transfer(address to, uint256 amount) public virtual override returns (bool) {
259         address owner = _msgSender();
260         _transfer(owner, to, amount);
261         return true;
262     }
263 
264     /**
265      * @dev See {IERC20-allowance}.
266      */
267     function allowance(address owner, address spender) public view virtual override returns (uint256) {
268         return _allowances[owner][spender];
269     }
270 
271     /**
272      * @dev See {IERC20-approve}.
273      *
274      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
275      * `transferFrom`. This is semantically equivalent to an infinite approval.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 amount) public virtual override returns (bool) {
282         address owner = _msgSender();
283         _approve(owner, spender, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20}.
292      *
293      * NOTE: Does not update the allowance if the current allowance
294      * is the maximum `uint256`.
295      *
296      * Requirements:
297      *
298      * - `from` and `to` cannot be the zero address.
299      * - `from` must have a balance of at least `amount`.
300      * - the caller must have allowance for ``from``'s tokens of at least
301      * `amount`.
302      */
303     function transferFrom(
304         address from,
305         address to,
306         uint256 amount
307     ) public virtual override returns (bool) {
308         address spender = _msgSender();
309         _spendAllowance(from, spender, amount);
310         _transfer(from, to, amount);
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
327         address owner = _msgSender();
328         _approve(owner, spender, allowance(owner, spender) + addedValue);
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
347         address owner = _msgSender();
348         uint256 currentAllowance = allowance(owner, spender);
349         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
350         unchecked {
351             _approve(owner, spender, currentAllowance - subtractedValue);
352         }
353 
354         return true;
355     }
356 
357     /**
358      * @dev Moves `amount` of tokens from `from` to `to`.
359      *
360      * This internal function is equivalent to {transfer}, and can be used to
361      * e.g. implement automatic token fees, slashing mechanisms, etc.
362      *
363      * Emits a {Transfer} event.
364      *
365      * Requirements:
366      *
367      * - `from` cannot be the zero address.
368      * - `to` cannot be the zero address.
369      * - `from` must have a balance of at least `amount`.
370      */
371     function _transfer(
372         address from,
373         address to,
374         uint256 amount
375     ) internal virtual {
376         require(from != address(0), "ERC20: transfer from the zero address");
377         require(to != address(0), "ERC20: transfer to the zero address");
378 
379         _beforeTokenTransfer(from, to, amount);
380 
381         uint256 fromBalance = _balances[from];
382         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
383         unchecked {
384             _balances[from] = fromBalance - amount;
385             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
386             // decrementing then incrementing.
387             _balances[to] += amount;
388         }
389 
390         emit Transfer(from, to, amount);
391 
392         _afterTokenTransfer(from, to, amount);
393     }
394 
395     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
396      * the total supply.
397      *
398      * Emits a {Transfer} event with `from` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      */
404     function _mint(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: mint to the zero address");
406 
407         _beforeTokenTransfer(address(0), account, amount);
408 
409         _totalSupply += amount;
410         unchecked {
411             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
412             _balances[account] += amount;
413         }
414         emit Transfer(address(0), account, amount);
415 
416         _afterTokenTransfer(address(0), account, amount);
417     }
418 
419     /**
420      * @dev Destroys `amount` tokens from `account`, reducing the
421      * total supply.
422      *
423      * Emits a {Transfer} event with `to` set to the zero address.
424      *
425      * Requirements:
426      *
427      * - `account` cannot be the zero address.
428      * - `account` must have at least `amount` tokens.
429      */
430     function _burn(address account, uint256 amount) internal virtual {
431         require(account != address(0), "ERC20: burn from the zero address");
432 
433         _beforeTokenTransfer(account, address(0), amount);
434 
435         uint256 accountBalance = _balances[account];
436         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
437         unchecked {
438             _balances[account] = accountBalance - amount;
439             // Overflow not possible: amount <= accountBalance <= totalSupply.
440             _totalSupply -= amount;
441         }
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
537 // File NOTAX.sol
538 
539 // SPDX-License-Identifier: MIT
540 pragma solidity ^0.8.9;
541 
542 contract NOTAX is ERC20 {
543     constructor() ERC20("NOTAX", "NOTAX") {
544         _mint(msg.sender, 300000 * 10 ** decimals());
545     }
546 }